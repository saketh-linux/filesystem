#
# Cookbook:: filesystem
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

node['disks'].each do |disk|
  lvm_physical_volume disk do
    ignore_failure true
  end
end


#node.default['pvs'] = shell_out('pvscan -sn|grep dev').stdout.split

host = node['hostname']
lvm_volume_group "vg_#{host}" do
  physical_volumes lazy { node.default['pvs'] = shell_out('pvscan -sn|grep dev').stdout.split }
  ignore_failure true
end

lvm_logical_volume 'lv_myAPP' do
  group "vg_#{host}"
  size '100%VG'
  filesystem 'xfs'
  mount_point '/myAPP'
  wipe_signatures true
end  

