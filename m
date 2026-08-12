Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC65C5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737596B0092; Tue, 11 Aug 2026 21:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8456B0093; Tue, 11 Aug 2026 21:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD706B0095; Tue, 11 Aug 2026 21:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 315DA6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:48:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B526C402EA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:48:28 +0000 (UTC)
X-FDA: 85090932696.11.D536444
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id 73DC680004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:48:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iN2rs9b8;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786499306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rWVdCu83teJ19Z7r5KO4PDsNmLbo0c61f0Vzsp3u2D8=;
	b=JpqZ6IR8QdNEDh2eFr0+oeCgJkLLufubkwF7JHcujutZGJyJBZgkTqxnKlfaQWu3Mdw9a7
	PmwBjUzKc2ML7G9EJhq5yAX1+Z7+ExTUxeYJxODwJprOkxXl+Pc4opGNk8V7EKFdytw3z5
	gOM/VBE0O4TiSCANYyrKTm/C0YZiIwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786499306;
	b=7EvIfn7mEImQnBH05Oic0/8p1PM/6urhP6GvoXM+pLqsgAWSN2PnOPlERxqrMWy0/lX63C
	bvg025MKRJEKE7nGMI1+/wsb/4EQuJUv4XsSIrro4DybiTSLaLYDBjASRhhR7QSTKbtmBV
	gxiTfTTPdEowq9Ev11z55VjdeekBi78=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iN2rs9b8;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786499305; x=1818035305;
  h=date:from:to:cc:subject:message-id;
  bh=GAuDrBlrychbUMsJxe/lbW/Fj2S9CVT2BYdqaa4RTHQ=;
  b=iN2rs9b8AP6WlCium8WUnMub1V6/MIWdt9z17Op8k4RzSimRRA35Xr9z
   Si+yONp4aeeJoXmFeMydLgpV3aqWD4oZ0R59jj7wHkY0wf3U/JV06mZQF
   8gqDF0zF+/oaWkD6qLSxZtDWF32+9KcNRY4+swIGGfP1JzUvIuijNGmQG
   muC5zujz5PyIP1qms3pXON7FlKbz4tyXjXEjL9yqRtmF8QI2BapkQyIn5
   AD9YHbAacj3QIEvBAYspcOI0W8UO4DC9RZOFwdhjj+7SAWrU0BTBFNy0y
   LFCb5hLY9mDQe7Ypc/ySGmlL9eizWUqQE56v7aUkL6KxlgcwqtdPVHQ4U
   A==;
X-CSE-ConnectionGUID: bNuynngZRSOd3EQ9hmBiuQ==
X-CSE-MsgGUID: Wct+X7+GR56nD947XDp6tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="98399572"
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="98399572"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 18:48:24 -0700
X-CSE-ConnectionGUID: aGR9z4UwSmmwM5JKvbm5bA==
X-CSE-MsgGUID: hu/z+v9JTdObPeePjZu6mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="267757874"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 11 Aug 2026 18:48:22 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wty4p-00000000Pbq-0Zkz;
	Wed, 12 Aug 2026 01:48:19 +0000
Date: Wed, 12 Aug 2026 09:47:24 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 223/226] WARNING: modpost: vmlinux: section
 mismatch in reference: chmod_common+0x94 (section: .text) ->
 tegra_p2u_driver_init (section: .init.text)
Message-ID: <202608120824.3r84IiZb-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 9s9zqae1xb5bgzdkeyay66ugn4u7c7tt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73DC680004
X-HE-Tag: 1786499305-432801
X-HE-Meta: U2FsdGVkX18CWIG8UrbKbgWKU8u+KuX/G7LIwvDzDeKZ1E+qZEsnDiUNv0HL4vfWgl8ucrHsBUBnZi52rHvGjm5vl7T3F0qA93xdQ06awxdmqiK9uGw6x7n13B2l7XUf/2w1S9Wios7xIp3b67dLlkf5N+deU0IMDHkAvFUWJxWg3+63kodraNpiQMibD8bozkK8GkNUod2k0Bbwm9Zc1e44T5HGfCv/TEZdemh479pT5RsF5POb5Raj0w9rHwmtyn+zkZJ6yy3fPrWaA5QlIzD4jUkrv7ibKRZUres6i4jFSrEwTeTg4dBmBEAn9L7qrjaBnlgYj4Gdh75wzwa2a4z984nZirT50gEB6W066wxCO7eo9rB9HahIw152L16Pc1gcocMiWjzSUI7Z1HUtIIft/U5x2W4Ja1NwK7NKj181b2dxdYD+F/jXtjar8Xx2nVfeisc2zhwBaGGrc4p3RZKpqJhh6o1I2pMKJhQ4S/p4aQO/EiH/wWa0jzrRnbMuWpQXTEh+L9/bj9IFy5VnzqNa1w0KqCd4q4fdnLH375kWpNKHVvyt5FCPJxjDXl53IRa44YkY+LOOzax7pnvYJFaijCFWDl5xTDHufZeb9dJZXpvaeuOQpWq2IAJtIl7bH+FvbMSuTyv+qlafMU3x/bsEdBYXJfB3u+dOnV1AcjnIUeX2RSLizfxyhfQN5L0wctLSTp4Gjf1EPwaa2PC1719DMBrV29qOKDeBZClgMG5CJfMmMsDdj+jOBWgXnicLvC4nvIjBk8d8suRZexVBH2vAIciHfMHW1eyT6oeH3Z4meoX++C/pZnCdeg737zv5YAPZuYQEbYnploSbebagTGRbxBnzlVBS2lp4U1QC/YakWZn4TW3haPFb2xOYPMVGV5uD0XFnCwclwRmMT3nnfUYl/DwTHeZlzjUT0TuDC470VMvrWh9MT44jnHzFd6GzbqKbaATY0eaXU4LZ+p7
 1R1Ebth4
 7e6uIxJgToZDQAUi40BwUyWOLlf+0eXTiZrJrb8odVRGJGOrQuoSP18Qxbd2nSjCRZV9kcyjKuzaVmlFsagZVBO0u47lnj3qy4bE0/74XPaNLfeLVd01tpnGq45cXqWamclw/YKGjB1bjyRcpuHCcrK3I6dJgpcGuqvrR2W27wwtQbOq6om+g1f/LIQIPsjhu1L5M1QsrvW6h9BlC19IXTR/p9BQY/rdk24lNeKj+RQXGGiIZuL3p1VtomCsijbKRk2SV1z0t+CGAQqZ7Crzf9wUyuGFSCuSIRL525GVQOcv0QLO9CHaDhw9x5tmpTZYGkv0XEwdvLEgd1/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   480a31230b426efb005b6e71a14ef80f405f18b6
commit: 7180df00addf6dbb96228c349a2b8641f77e633b [223/226] mm/swap: move swap_ops into file systems for file system-based swap
config: mips-randconfig-r051-20260811 (https://download.01.org/0day-ci/archive/20260812/202608120824.3r84IiZb-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260812/202608120824.3r84IiZb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608120824.3r84IiZb-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: lockdep_register_key+0x24 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lockdep_register_key+0x28 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: static_obj+0x14 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: static_obj+0x18 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lockdep_init_map_type+0x7c (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lockdep_init_map_type+0x80 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: is_dynamic_key+0x24 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: is_dynamic_key+0x28 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lockdep_unregister_key+0x54 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lockdep_unregister_key+0x58 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: assign_lock_key+0x3c (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: assign_lock_key+0x40 (section: .text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: dma_map_page_attrs+0x70 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: dma_map_resource+0x10 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: hmm_dma_map_pfn+0x98 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: do_truncate+0x90 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: break_lease+0x60 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: do_ftruncate+0x140 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: chmod_common+0x94 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: chmod_common+0x104 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: chown_common+0x180 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: chown_common+0x1f0 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: do_dentry_open+0x4c4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_create+0x198 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: try_break_deleg+0x64 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: path_openat+0x85c (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: path_openat+0x990 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_mknod+0x204 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: filename_mknodat+0x21c (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_mkdir+0x1e0 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: filename_mkdirat+0x154 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_rmdir+0x1e4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: filename_rmdir+0x218 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_unlink+0x1e0 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_unlink+0x238 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: filename_unlinkat+0x114 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_symlink+0x11c (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: filename_symlinkat+0x164 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: filename_linkat+0x1e4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: filename_renameat2+0x368 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: file_remove_privs_flags+0xd0 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: notify_change+0x554 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __vfs_setxattr_locked+0x100 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_setxattr+0x130 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __vfs_removexattr_locked+0xdc (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_removexattr+0xc4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: vfs_utimes+0x19c (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_utimes+0x20c (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_set_acl+0x1a4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_set_acl+0x228 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_remove_acl+0xd4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vfs_remove_acl+0x150 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_destroy_inode+0x40 (section: .text) -> omap_control_phy_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_statfs+0x2c (section: .text) -> omap_control_phy_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_workdir_create+0x24c (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_verify_lowerdata+0x148 (section: .text) -> omap_control_phy_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_setattr+0x13c (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_getattr+0x60 (section: .text) -> omap_control_phy_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_fileattr_set+0x38 (section: .text) -> omap_control_phy_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_fileattr_get+0x24 (section: .text) -> omap_control_phy_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_create_handle_whiteouts+0x3e0 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_dir_open+0x54 (section: .text) -> omap_control_phy_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_set_attr+0x6c (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_set_attr+0xbc (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_set_attr+0x154 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_copy_up_flags+0xd2c (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_copy_up_flags+0xf1c (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ovl_copy_up_metadata+0x398 (section: .text) -> tegra_p2u_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_file_write_checks+0x164 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_ilock2_io_mmap+0xe4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_ilock2_io_mmap+0x144 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_ilock2_io_mmap+0x188 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_ilock2_io_mmap+0x1e0 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_break_leased_layouts+0xa4 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xfs_break_leased_layouts+0x134 (section: .text) -> tegra_p2u_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_update_inode+0x80 (section: .text) -> da8xx_usb_phy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_create_new_inode+0x76c (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_rename2+0x1078 (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_unlink+0xd8 (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_rmdir+0x11c (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_remove_free_space_inode+0x88 (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: create_reloc_inode+0x2f8 (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: btrfs_begin_enable_verity+0xac (section: .text) -> da8xx_usb_phy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: blk_dma_map_iter_start+0xa8 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: blk_rq_dma_map_iter_next+0x94 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: blk_rq_integrity_dma_map_iter_next+0x94 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: packing_test_unpack_fields+0x54 (section: .text) -> xpsgtr_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: mhi_unmap_single_no_bb+0x18 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cpm_muram_init+0x124 (section: .text) -> xpsgtr_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: cmdq_pkt_destroy+0x28 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtqueue_add+0x4c0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtqueue_add+0x8f8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtqueue_unmap_page_attrs+0x38 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtqueue_unmap_single_attrs+0x48 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtqueue_add_split+0x678 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: detach_buf_split_in_order+0x88 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: detach_buf_split_in_order+0x1cc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: detach_buf_split_in_order+0x278 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtqueue_add_indirect_packed+0x2b0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: vring_unmap_extra_packed+0x8c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: detach_buf_packed_in_order+0xdc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: msm_stop_dma+0xe4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: s3c24xx_serial_release_dma+0x4c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: s3c24xx_serial_release_dma+0xa0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: tegra_uart_shutdown+0x2cc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: tegra_uart_startup+0x4f4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ttm_pool_unmap_and_free+0x70 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ttm_pool_backup+0x3dc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: virtio_gpu_probe+0x4c (section: .text) -> pinctrl_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: sti_bind+0x1c (section: .text) -> pinctrl_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: imx_drm_bind+0x20 (section: .text) -> pinctrl_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: meson_drv_bind_master+0xac (section: .text) -> pinctrl_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: kirin_drm_bind+0x44 (section: .text) -> pinctrl_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: stm32_timers_dma_burst_read+0x240 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_setup_ctrl+0x33c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_teardown_admin_queue+0xf8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_destroy_queue_ib+0x118 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_free_ring+0x60 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_cm_handler+0x8b4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_complete_rq+0xd4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: nvme_rdma_queue_rq+0x148 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_rcv_ls_req+0x258 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_xmt_ls_rsp_free+0xb8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_delete_association+0x14c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_delete_association+0x170 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_term_aen_ops+0x34 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_term_aen_ops+0x58 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __nvme_fc_send_ls_req+0x250 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __nvme_fc_finish_ls_req+0x98 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_exit_request+0x30 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvme_fc_exit_request+0x54 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_free_rsp+0x28 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_cm_handler+0xc1c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_alloc_cmds+0x3ac (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_alloc_cmds+0x418 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_free_cmd+0x88 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_free_cmd+0xe8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nvmet_rdma_free_rsps+0x74 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ag71xx_poll+0x154 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ag71xx_hard_start_xmit+0x29c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ag71xx_rings_cleanup+0x80 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_tx_timeout_work+0x188 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_poll+0x168 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_poll+0x478 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_stop+0x1b0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_stop+0x284 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_xmit+0x438 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: xgmac_xmit+0x4bc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: geth_cleanup_freeq+0xb4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: geth_resize_freeq+0x3bc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: geth_freeq_alloc_map_page+0x148 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: gmac_clean_txq+0xcc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: gmac_map_tx_bufs+0x46c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftgmac100_hard_start_xmit+0x438 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftgmac100_hard_start_xmit+0x590 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftgmac100_poll+0x168 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftgmac100_poll+0x418 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftgmac100_free_buffers+0xac (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftgmac100_free_buffers+0x1a8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftmac100_poll+0x204 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftmac100_poll+0x5e4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftmac100_free_buffers+0x88 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ftmac100_free_buffers+0x10c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hix5hd2_poll+0x1e0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hix5hd2_poll+0x264 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hix5hd2_poll+0x310 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hix5hd2_poll+0x528 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hix5hd2_net_close+0xe8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hix5hd2_net_close+0x164 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hip04_rx_poll+0x13c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hip04_mac_stop+0x168 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hip04_tx_reclaim+0x104 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hip04_tx_reclaim+0x1ac (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hnae_fini_ring+0x104 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hnae_init_ring+0x2ac (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hnae_unmap_buffer+0x44 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hnae_unmap_buffer+0x7c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hns_nic_net_xmit_hw+0x434 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hisi_femac_poll+0xe4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hisi_femac_poll+0x23c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hisi_femac_net_close+0x104 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hisi_femac_net_close+0x1a0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: libeth_tx_complete_any+0x90 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: libeth_tx_complete_any+0x114 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_napi_rx+0xc78 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_rx_clean+0xd4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_tx_unmap+0x54 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_tx_unmap+0x78 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_tx_unmap+0xb4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_tx_unmap+0xd4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_wed_hwrro_free_buffer+0x70 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __mtk_wed_detach+0x74 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __mtk_wed_detach+0xe4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_wed_amsdu_buffer_alloc+0x150 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_wed_wo_deinit+0xb0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_wed_wo_deinit+0x15c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_wed_wo_irq_tasklet+0x160 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mlxbf_gige_rx_init+0x3a0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mlxbf_gige_rx_deinit+0x8c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mlxbf_gige_poll+0x1ac (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mlxbf_gige_tx_deinit+0xbc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mlxbf_gige_tx_deinit+0x13c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mlxbf_gige_handle_tx_complete+0x19c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lan966x_fdma_napi_poll+0x124 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lan966x_fdma_napi_poll+0x188 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nixge_poll+0xd0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nixge_start_xmit+0x340 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nixge_start_xmit+0x37c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nixge_dma_err_handler+0x9c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nixge_tx_irq+0x17c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: nixge_hw_dma_bd_release+0x40 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ave_napi_poll_tx+0x1a4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ave_stop+0x18c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ave_stop+0x220 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ave_rx_receive+0x174 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: netsec_napi_poll+0xb8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: netsec_uninit_pkt_dring+0x130 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: bam_dmux_remove+0x224 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: bam_dmux_power_off+0x108 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: fw_iso_buffer_map_dma+0xec (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: fw_iso_buffer_destroy+0x58 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: at91_twi_dma_cleanup+0x10c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: at91_twi_read_data_dma_callback+0x28 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: at91_twi_write_data_dma_callback+0x20 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_imx_dma_xfer+0x168 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i2c_imx_dma_callback+0x28 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x10cc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x1100 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x115c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x11b4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x1208 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x12d4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x13d4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: lpi2c_imx_xfer_common+0x1718 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_i2c_transfer+0xa60 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_i2c_transfer+0xa88 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_i2c_transfer+0xab0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_i2c_transfer+0xac8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_i2c_transfer+0xb58 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_i2c_transfer+0xcb8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sh_mobile_xfer+0x3a8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sh_mobile_xfer+0x454 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sh_mobile_xfer+0x704 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: sh_mobile_i2c_dma_callback+0x40 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: stm32f7_i2c_handle_isr_errs+0x108 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: stm32f7_i2c_dma_callback+0x64 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: stm32_i2c_prep_dma_xfer+0x1a8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: i3c_master_dma_unmap_single+0x20 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: hci_dma_free+0xd0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: rdma_rw_ctx_init_bvec+0x14c (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rdma_rw_ctx_init_bvec+0x4ec (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_send_done+0x1bc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_send_done+0x1e4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_send_mad+0x28c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_send_mad+0x2b0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_send_mad+0x354 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_init_device+0xa00 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_init_device+0xa80 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_port_close+0x19c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_port_close+0x240 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_post_receive_mads+0x2d0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: ib_mad_recv_done+0x114 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srp_free_ch_ib+0x1f0 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srp_free_ch_ib+0x294 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srp_init_cmd_priv+0x138 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srp_exit_cmd_priv+0x50 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srp_cm_rep_handler+0x460 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srp_cm_rep_handler+0x4b4 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srpt_alloc_ioctx_ring+0x2ac (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: srpt_free_ioctx_ring+0xa8 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iser_alloc_rx_descriptors+0x37c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iser_alloc_rx_descriptors+0x3dc (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iser_free_login_buf+0x48 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iser_free_login_buf+0x70 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iser_free_rx_descriptors+0x70 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iser_dataout_comp+0x48 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: iscsi_iser_cleanup_task+0x54 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: scm_legacy_call+0x354 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: qcom_tzmem_pool_add_memory+0x148 (section: .text) -> xpsgtr_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: tee_protmem_static_pool_alloc+0xa0 (section: .text) -> xpsgtr_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: tee_shm_pool_alloc_res_mem+0x9c (section: .text) -> xpsgtr_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: tso_dma_map_init+0x13c (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: tso_dma_map_init+0x240 (section: .text) -> stf_dphy_driver_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: page_pool_return_netmem+0x70 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: page_pool_release+0x404 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: page_pool_dma_map+0x28c (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: net_devmem_bind_dmabuf+0x304 (section: .text) -> xpsgtr_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: ct_seq_show+0x3e8 (section: .text) -> log_buf_len_setup (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ct_seq_show+0x3f0 (section: .text) -> log_buf_len_setup (section: .init.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: ct_seq_show+0x3f4 (section: .text) -> log_buf_len_update (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: ct_seq_show+0x3fc (section: .text) -> log_buf_len_update (section: .init.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: ct_seq_show+0x434 (section: .text) -> new_log_buf_len (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: ct_seq_show+0x438 (section: .text) -> new_log_buf_len (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: sctp_make_abort_user+0x248 (section: .text) -> algif_hash_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: sctp_make_abort_user+0x24c (section: .text) -> algif_hash_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: sctp_user_addto_chunk+0xb0 (section: .text) -> algif_hash_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: sctp_user_addto_chunk+0xb4 (section: .text) -> algif_hash_init (section: .init.text)
WARNING: modpost: vmlinux: section mismatch in reference: rdma_request+0x190 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: rdma_request+0x398 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: send_done+0x44 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: recv_done+0x44 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: digital_start_poll+0x224 (section: .text) -> sw842_debugfs_remove (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: digital_start_poll+0x228 (section: .text) -> sw842_debugfs_remove (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: __xp_dma_unmap+0x78 (section: .text) -> stf_dphy_driver_exit (section: .exit.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: resource_init+0x78 (section: .init.text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: resource_init+0x7c (section: .init.text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mem_init_print_info+0x110 (section: .init.text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mem_init_print_info+0x114 (section: .init.text) -> stm32_combophy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: libeth_xdp_xmit_return_bulk+0x58 (section: .text.unlikely.) -> stf_dphy_driver_exit (section: .exit.text)
WARNING: modpost: vmlinux: section mismatch in reference: mtk_setup_legacy_sram+0x9c (section: .text.unlikely.) -> xpsgtr_driver_exit (section: .exit.text)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

