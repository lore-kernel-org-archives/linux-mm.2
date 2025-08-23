Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E248DCA0FE1
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 17:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21956B00B9; Sat, 23 Aug 2025 13:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8FE6B00BA; Sat, 23 Aug 2025 13:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D153E6B00BB; Sat, 23 Aug 2025 13:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDFC76B00B9
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:55:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C912118738
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 17:55:25 +0000 (UTC)
X-FDA: 83808774210.08.6D5F4FF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64905140003
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 17:55:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KF1eNQhr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755971723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvl9c6cQ/v3Ith5O9jHlM84cQ80gOrdpUe2c7aLFCNQ=;
	b=QJQqrM6/tLV8X5tDYMFvQ9HeqHSOlGAFqB3EtxmWkrGyUIDFrOlcxCYQpmFjkbt2mRSOxD
	UZWHxFjyrzrCGAc2oW8hR4986x53K7PyJOL5mWDOt14sAOjziISWHx4Zj+NEnxudzFLmI8
	Jebq2QwPipjmSLNLxbEr8h7byoZNCIk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KF1eNQhr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755971723; a=rsa-sha256;
	cv=none;
	b=MH0+OhpopVFyawvb/9U/kX6zqsmvEn9GdNGkuCjiBV8DVmgrYiIp1N8dRj+696JPXq70oo
	Wh2GUZdenv/0q4FYocTc9WFEcQG8GLBhun6m0Nwlw0RighxLWuCv4/yOpi90SwklGftp3w
	5ohj2ZyO20Tsg+TxBw7TFqvkL8juQac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755971723; x=1787507723;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fBJPHujQaTfeJ/QhlahQ1Q7Dchv0xfwiZ8tXvM4XPX0=;
  b=KF1eNQhr832835eaQU7rRmy+5mDMjkcO0NJ86M6Y8qiNtTwejZdvxsKu
   oFlXeCWtvuYxkD1Mq4VySaez6OrmJDrIQeA5b2QqIGVCaJ/0yOSuP3UzI
   laBeY5uLklbXcG1AYmvginkCvoU9dWxmE7H2nt1fJNVAr7Mm4Xbr/W1GF
   QKyarfSuhuyzlfv7rUZwZz74mb6ve/kCyjBfPjBqjSjuldEJcd6rvFsgV
   HmQjxU0ahiiohJ/b4Rk8qXBb2JBuuk7ubpjRGEC2/2FWNhW28hOOUKVN2
   RyqXz/+Kq1gJWvC6wkkAciHmPIoWvKN8WKIqjhX2SXxGAkmC6aZyWswQK
   w==;
X-CSE-ConnectionGUID: HewRjnYySxCVUj6tV+/Gwg==
X-CSE-MsgGUID: vQopoDcbTM+s85gt0ykhWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="75699938"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="75699938"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2025 10:55:21 -0700
X-CSE-ConnectionGUID: aWklkkZATGyZegBWr3QXJg==
X-CSE-MsgGUID: 4XPQOh4hSRmImI3tNEsAzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="174247581"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 23 Aug 2025 10:55:17 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upsSQ-000MUB-0W;
	Sat, 23 Aug 2025 17:55:14 +0000
Date: Sun, 24 Aug 2025 01:54:52 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 2/3] tracing: Add a tracepoint verification check at
 build time
Message-ID: <202508240152.kQo4DBMl-lkp@intel.com>
References: <20250820174828.080947631@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820174828.080947631@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64905140003
X-Stat-Signature: mgiwg547y9dz47ks4o5xi4i1uocm99bd
X-Rspam-User: 
X-HE-Tag: 1755971722-909403
X-HE-Meta: U2FsdGVkX18v23WE23Yyx6alVfGkdg3BkfbPxSyxgC0gMb0eHongsViNarq70piaTmOxPgpfLnpF+Q7B27zvY38eLDZrNE4dk72Cvv737Uhwhu7HBLEx41Ap/y87HcwAkVakEDCqXo694XSzebagTFYGTwbTEIOjl8LsWqcjymMXq7uwaE5w18Nyqcy75poxnR2yyN55NEXakPXYmT3CGow6vwV28yNFyagPWiRZdPLscmFt7r+l4pIPdm8Vvxv4Io/THwJjt+QwrOegEv0jUNAA4riI4oP6XJjllDuKwmktpWdwwjZaDbR5bruG2yHsZ6BgrQrunaYsT1LFQkBbIS/+rAZoCHpjRvpSxBDVRXJATEPjccRDFmk1o7ShXVVFuTbnZTZMu2x1t/1YQPD28NH2kxGS+gbiU4Qdx0Un1mq+FC8EfkoxsOTyhYpajYSaqPPqCLKsh+Y1GGDGS1JuI2JneCrKIS5E3IaTiKgIh8s/i+ODkRP2B/mrKPtuAHkJJekG2xH0CM20LLlDrLgNimOaiQdjaDAK+wYtybMwBOs0uI96i11G68wz2j+J4yDuURxZ6D5PQ7L+mqmUu/RodHkYP9/+C0yLB9+akIiC5mm/iRMIyWPdTv6Eu7O4q4Dhr/o5DLJRHVTO17SMeMf4Q1JYbvS9CtOxrElOjRGP+Q5AaS0AI5b5xXZLyMGWi4aku6dkAJNSKZX//AQrKEfD8MpSsJRtCtJpe+N20Vw7FXachd4FACum6NBazUlVBcgdVe9aHujSzZWjKM9eTPYLrCfrgxbzh8Xd+mnE7bKsWTshkjucLTT7PCH1y7K4NIgXR30P6xa85XIygIh3PodMSB3vsjvekNSARAhQsDKAqAU8+L+xY0+6QEH9yw2o/N79rDPg2nKnX7CST0ZikNRYfo9AkJGMBuvbKr6o9HRqvaADh3MBsKLic/gZiWh1O8PSGAo89UssNiMeyY/LJE2
 WyuUuJL6
 mIbB0wH8f0sRPU0gLQoBUDbeX8bshga1a3st+5wYEM5CuFKQ3Sg8lgSuNGtgiYOdM/Fs5yZ01+TT5Bi+h815OfEuOrnd6P8JZ3ooFCRj0VOhWXhuByCbwgQY30I2ajWvYn7dC+j/RFmM37h4NacYpBvKIXE5MXy4r3UnKXV8UAatRhsRcR0yqhmpdwjcoOTKY06KJc7oPEXZloIOYA53rXO+t5LZRgWQZCCF+TsRjqOnBS58K9vuweYSJgW66KL9qA/I76ChRm7ezO4SgMP94wa+dudtFFLHc/OxI/BJtS0nmBQSqk/sUm26qqf4nUx43wSnOe511cUbVoV0g59R+qVpGHlUCtjMMQpikXvjHZuUWns3eJH9N1tGIxG3nzv9MDgeXJFPSHbGh5UH7afMmP1109ZB4XYIGYQl9X+M9rihOIYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on trace/for-next]
[also build test WARNING on akpm-mm/mm-everything linus/master v6.17-rc2 next-20250822]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/sorttable-Move-ELF-parsing-into-scripts-elf-parse-ch/20250821-015048
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250820174828.080947631%40kernel.org
patch subject: [PATCH v6 2/3] tracing: Add a tracepoint verification check at build time
config: x86_64-randconfig-003-20250823 (https://download.01.org/0day-ci/archive/20250824/202508240152.kQo4DBMl-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250824/202508240152.kQo4DBMl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508240152.kQo4DBMl-lkp@intel.com/

All warnings (new ones prefixed by >>):

   warning: tracepoint 'nfsd_cb_setup_err' is unused.
   warning: tracepoint 'nfsd_cb_setup' is unused.
   warning: tracepoint 'nfsd_cb_rpc_release' is unused.
   warning: tracepoint 'nfsd_cb_rpc_done' is unused.
   warning: tracepoint 'nfsd_cb_rpc_prepare' is unused.
   warning: tracepoint 'nfsd_cb_shutdown' is unused.
   warning: tracepoint 'nfsd_cb_lost' is unused.
   warning: tracepoint 'nfsd_cb_probe' is unused.
   warning: tracepoint 'nfsd_cb_new_state' is unused.
   warning: tracepoint 'nfsd_cb_start' is unused.
   warning: tracepoint 'nfsd_cb_nodelegs' is unused.
   warning: tracepoint 'nfsd_cb_args' is unused.
   warning: tracepoint 'nfsd_clid_confirmed_r' is unused.
   warning: tracepoint 'nfsd_clid_fresh' is unused.
   warning: tracepoint 'nfsd_clid_verf_mismatch' is unused.
   warning: tracepoint 'nfsd_clid_cred_mismatch' is unused.
   warning: tracepoint 'nfsd_grace_complete' is unused.
   warning: tracepoint 'nfsd_grace_start' is unused.
   warning: tracepoint 'nfsd_mark_client_expired' is unused.
   warning: tracepoint 'nfsd_clid_stale' is unused.
   warning: tracepoint 'nfsd_clid_renew' is unused.
   warning: tracepoint 'nfsd_clid_purged' is unused.
   warning: tracepoint 'nfsd_clid_replaced' is unused.
   warning: tracepoint 'nfsd_clid_admin_expired' is unused.
   warning: tracepoint 'nfsd_clid_destroyed' is unused.
   warning: tracepoint 'nfsd_clid_confirmed' is unused.
   warning: tracepoint 'nfsd_clid_reclaim_complete' is unused.
   warning: tracepoint 'nfsd_clid_expire_unconf' is unused.
   warning: tracepoint 'nfsd_slot_seqid_sequence' is unused.
   warning: tracepoint 'nfsd_slot_seqid_unconf' is unused.
   warning: tracepoint 'nfsd_slot_seqid_conf' is unused.
   warning: tracepoint 'nfsd_seq4_status' is unused.
   warning: tracepoint 'nfsd_stateowner_replay' is unused.
   warning: tracepoint 'nfsd_stid_revoke' is unused.
   warning: tracepoint 'nfsd_open_confirm' is unused.
   warning: tracepoint 'nfsd_preprocess' is unused.
   warning: tracepoint 'nfsd_deleg_return' is unused.
   warning: tracepoint 'nfsd_deleg_write' is unused.
   warning: tracepoint 'nfsd_deleg_read' is unused.
   warning: tracepoint 'nfsd_open' is unused.
   warning: tracepoint 'nfsd_layout_recall_release' is unused.
   warning: tracepoint 'nfsd_layout_recall_fail' is unused.
   warning: tracepoint 'nfsd_layout_recall_done' is unused.
   warning: tracepoint 'nfsd_layout_recall' is unused.
   warning: tracepoint 'nfsd_layout_return_lookup_fail' is unused.
   warning: tracepoint 'nfsd_layout_commit_lookup_fail' is unused.
   warning: tracepoint 'nfsd_layout_get_lookup_fail' is unused.
   warning: tracepoint 'nfsd_layoutstate_free' is unused.
   warning: tracepoint 'nfsd_layoutstate_unhash' is unused.
   warning: tracepoint 'nfsd_layoutstate_alloc' is unused.
   warning: tracepoint 'nfsd_delegret_wakeup' is unused.
   warning: tracepoint 'nfsd_clone_file_range_err' is unused.
   warning: tracepoint 'nfsd_compound_encode_err' is unused.
   warning: tracepoint 'nfsd_compound_op_err' is unused.
   warning: tracepoint 'nfsd_compound_decode_err' is unused.
   warning: tracepoint 'nfsd_compound_status' is unused.
   warning: tracepoint 'nfsd_compound' is unused.
   warning: tracepoint 'xfs_metadir_link' is unused.
   warning: tracepoint 'xfs_metadir_start_link' is unused.
   warning: tracepoint 'xfs_file_dax_write' is unused.
   warning: tracepoint 'xfs_file_dax_read' is unused.
   warning: tracepoint 'xrep_done' is unused.
   warning: tracepoint 'xrep_attempt' is unused.
   warning: tracepoint 'cachefiles_ondemand_fd_release' is unused.
   warning: tracepoint 'cachefiles_ondemand_fd_write' is unused.
   warning: tracepoint 'cachefiles_ondemand_cread' is unused.
   warning: tracepoint 'cachefiles_ondemand_read' is unused.
   warning: tracepoint 'cachefiles_ondemand_close' is unused.
   warning: tracepoint 'cachefiles_ondemand_copen' is unused.
   warning: tracepoint 'cachefiles_ondemand_open' is unused.
   warning: tracepoint 'ocfs2_encode_fh_begin' is unused.
   warning: tracepoint 'ocfs2_duplicate_clusters_by_jbd' is unused.
   warning: tracepoint 'zonefs_file_dio_append' is unused.
   warning: tracepoint 'edma_readb' is unused.
   warning: tracepoint 'edma_readw' is unused.
   warning: tracepoint 'xe_exec_queue_supress_resume' is unused.
   warning: tracepoint 'xe_vm_restart' is unused.
   warning: tracepoint 'xe_vma_userptr_rebind_exec' is unused.
   warning: tracepoint 'xe_vma_userptr_rebind_worker' is unused.
   warning: tracepoint 'xe_vma_flush' is unused.
   warning: tracepoint 'dma_fence_emit' is unused.
   warning: tracepoint 'scsi_zone_wp_update' is unused.
   warning: tracepoint 'scsi_prepare_zone_append' is unused.
   warning: tracepoint 'ata_sff_flush_pio_task' is unused.
   warning: tracepoint 'atapi_send_cdb' is unused.
   warning: tracepoint 'atapi_pio_transfer_data' is unused.
   warning: tracepoint 'ata_sff_pio_transfer_data' is unused.
   warning: tracepoint 'ata_sff_port_intr' is unused.
   warning: tracepoint 'ata_sff_hsm_command_complete' is unused.
   warning: tracepoint 'ata_sff_hsm_state' is unused.
   warning: tracepoint 'ata_bmdma_status' is unused.
   warning: tracepoint 'ata_bmdma_stop' is unused.
   warning: tracepoint 'ata_bmdma_start' is unused.
   warning: tracepoint 'ata_bmdma_setup' is unused.
   warning: tracepoint 'ata_exec_command' is unused.
   warning: tracepoint 'ata_tf_load' is unused.
   warning: tracepoint 'ice_tx_tstamp_complete' is unused.
   warning: tracepoint 'ice_tx_tstamp_fw_done' is unused.
   warning: tracepoint 'ice_tx_tstamp_fw_req' is unused.
   warning: tracepoint 'ice_tx_tstamp_request' is unused.
>> warning: tracepoint 'mlx5e_rep_neigh_update' is unused.
   warning: tracepoint 'xhci_dbc_giveback_request' is unused.
   warning: tracepoint 'xhci_dbc_queue_request' is unused.
   warning: tracepoint 'xhci_dbc_free_request' is unused.
   warning: tracepoint 'xhci_dbc_alloc_request' is unused.
   warning: tracepoint 'xhci_dbc_gadget_ep_queue' is unused.
   warning: tracepoint 'xhci_dbc_handle_transfer' is unused.
   warning: tracepoint 'xhci_dbc_handle_event' is unused.
   warning: tracepoint 'musb_req_deq' is unused.
   warning: tracepoint 'musb_req_enq' is unused.
   warning: tracepoint 'musb_req_start' is unused.
   warning: tracepoint 'musb_req_free' is unused.
   warning: tracepoint 'musb_req_alloc' is unused.
   warning: tracepoint 'musb_req_rx' is unused.
   warning: tracepoint 'musb_req_tx' is unused.
   warning: tracepoint 'musb_req_gb' is unused.
   warning: tracepoint 'ufshcd_wl_resume' is unused.
   warning: tracepoint 'ufshcd_wl_suspend' is unused.
   warning: tracepoint 'ufshcd_system_resume' is unused.
   warning: tracepoint 'ufshcd_system_suspend' is unused.
   warning: tracepoint 'br_mdb_full' is unused.
   warning: tracepoint 'tcp_hash_md5_mismatch' is unused.
   warning: tracepoint 'tcp_hash_md5_unexpected' is unused.
   warning: tracepoint 'devlink_hwerr' is unused.
   warning: tracepoint 'rpc_socket_reset_connection' is unused.
   warning: tracepoint 'rxrpc_rxgk_rekey' is unused.
   warning: tracepoint 'rxrpc_drop_ack' is unused.
   warning: tracepoint 'rxrpc_rx_response' is unused.
   warning: tracepoint 'rxrpc_rx_challenge' is unused.
   warning: tracepoint 'rxrpc_tx_challenge' is unused.
   warning: tracepoint 'cfg80211_return_u32' is unused.
   warning: tracepoint 'cfg80211_return_uint' is unused.
   warning: tracepoint 'cfg80211_chandef_dfs_required' is unused.
   warning: tracepoint 'cfg80211_send_rx_auth' is unused.
   warning: tracepoint 'rdev_return_void_tx_rx' is unused.
   warning: tracepoint 'rdev_resume' is unused.
   warning: tracepoint 'rdev_suspend' is unused.
   warning: tracepoint 'tipc_node_dump' is unused.
   warning: tracepoint '802154_rdev_resume' is unused.
   warning: tracepoint '802154_rdev_suspend' is unused.
   warning: tracepoint '802154_new_scan_event' is unused.
   warning: tracepoint '802154_drv_set_pan_coord' is unused.
>> warning: tracepoint 'batadv_dbg' is unused.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

