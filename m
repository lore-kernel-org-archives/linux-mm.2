Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44568CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3656B000E; Thu, 27 Nov 2025 04:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86CB36B0010; Thu, 27 Nov 2025 04:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7343D6B0012; Thu, 27 Nov 2025 04:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6186B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:13:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 075AB131B41
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:13:47 +0000 (UTC)
X-FDA: 84155824494.26.F2DDF4B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3BA554000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:13:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CTvLcWPZ;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764234825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpviOPO85h2t8kVf2ioXQV/Pq7PZFKmP53VOWZm+PY0=;
	b=feeaWjO305FeXWLOWcdUEYQL4QNp4139esHZi9Ri3/TfWFvpbiNFT1WpTxpDm5vHDqKMOI
	Q56oAgHYDtvziak7DRNh1NB2FFZs7sZKVjO49kil0oMtdrdWebI0Q8kpc7o9s1K/U9OdhA
	HYWSPnOg5v6RIXrr7oyo7GD93T2ydZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764234825; a=rsa-sha256;
	cv=none;
	b=MVyP1GtqgFQpUED+tsIdBaNVmW+WI75WSxJKebZwkMaPofV8ZN1+I8snW6KG/DZFyQ1rS+
	lu6DfYJlYz4emptvYnurUus32fimvVpmy69Opi5IXRPJKhnxIfqW4usDW1iYguVjEk527v
	pRhT8Ctyx2rZ10JHiWe63rW4s3GujiI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CTvLcWPZ;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764234824; x=1795770824;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nMeiv3SIi8QG4moeoqdXt6Rrisu/4W7V71FP8WJhXLY=;
  b=CTvLcWPZGNjvbz/wSds7XMBMwmVnXa4KPUXdZG0RD0AnghiIJMSdFLbI
   OvS7+7xbEHqmQP7lznOh64q7HhsldYe5P8ZsdFiKctOAgxg4FyDaG6aap
   XYpcPTMKT3qTvustDZcqyZRoyVLtJRES7Z5ujPNQlmwrv8484KD1ok6E9
   x+CPfJOmbuZYh/g2PO1VOj2YrcedRJWU8hKhHVX20SeGs7CHOC6kpas0Y
   miai+lI6J8Rx/eoqZG/7DTv3VLjMk/QN4zI0a/a4/pLegqzKsqVN097FZ
   sxObhT4Glb1TLpzZFvTKrgbSfEWcferxslxyPsN2MlKFlRVeZimBUsxfE
   Q==;
X-CSE-ConnectionGUID: N8PKQlATRYSrWbcBrEEC+w==
X-CSE-MsgGUID: Is4/Ck5IRsK5s62JBFR8jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="91759731"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="91759731"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2025 01:13:41 -0800
X-CSE-ConnectionGUID: galzY4AMRqWW3GAP7HFGLQ==
X-CSE-MsgGUID: qPStb08kTMKgIAKRQFTcDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="193206736"
Received: from igk-lkp-server01.igk.intel.com (HELO 1f7de368ad0d) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 27 Nov 2025 01:13:39 -0800
Received: from kbuild by 1f7de368ad0d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOY4F-000000001hN-3iCC;
	Thu, 27 Nov 2025 09:13:35 +0000
Date: Thu, 27 Nov 2025 10:13:23 +0100
From: kernel test robot <lkp@intel.com>
To: Tim Bird <tim@bird.org>, pmladek@suse.com,
	Steve Rostedt <rostedt@goodmis.org>, john.ogness@linutronix.de,
	senozhatsky@chromium.org
Cc: oe-kbuild-all@lists.linux.dev, Tim Bird <Tim.Bird@sony.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Francesco Valla <francesco@valla.it>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] printk: add early_counter_ns routine for printk blind
 spot
Message-ID: <202511271051.yfp2O98B-lkp@intel.com>
References: <39b09edb-8998-4ebd-a564-7d594434a981@bird.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b09edb-8998-4ebd-a564-7d594434a981@bird.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BA554000A
X-Stat-Signature: d4rm6zch5r6fjuwfcqgrn1cwph6aexcf
X-HE-Tag: 1764234824-208882
X-HE-Meta: U2FsdGVkX18uTQS2rIwFletGzLoLJ1JHOUNjWUuOOVjL2AeX6eAbEQHsDUgfSrpDX5M5V3wJpEbfsRA6RtWUEmIWBXvzPVbUj8NnK7vXfVtnezGtpPjKMhU4BeFqKrMXfXsccNZOZRF6zylHmtDqnAVqepqjbY7SBtpzH87FDlPIgM8o4hCZIKS87aHJsWn1QQmaY87asNXEo+gJWSv8OJnfl5I09LixyzgInTuoBzio5cy/P4pEM420f8s5ySVP46s4OMyj9VxLnaNcFAxOQBhTkdyTddTZHeiwgMsTvA7hMrmEpoAhe/vN0ZUtuXYtKB5dKGGhFcHpq4NC2qqPKmISVh6mFsfnQhVkChnj5X2rEhbsIfm3WAPZ9tpeNw7SRzPO3XgXh40MLJEBPbA3R96CbpVwr/gQ/lSGWfRVEMjn/HOUfBXlfmziy8vQ9BoSblEa7lEHe4gC+GtuRIH0F4Z+WnsOoBYZydfDbHVuFamQuM0gL7XcI6AvdCLkyNNTZCahMdPxQffFGXowtknPLXr9h8p0yXReXdQNKR5zA+bmzH7rs6C4cuu/4iUwkzOt0l4EwaTXskOBfgTBkHY+DHhe5HOnyKvVmgdAYsG912YpbarIIJRqtFxnpgDIlTf19F6Ps2hs86XM1gkpdBIP0OsdOGr9MmZ+jPLAlTghKCfLxyBIzwsJ1r+aTwZrmN1ykJj2B2gnCYECL0Xw7tXB++LucUAOpejReaC3eshcUL6XIWBWPh2W0tNAZyjbHRJN/mX7/YgKQn0AJ3J9VxMJLKsKHawCryLwhqa6aUg0f0n438EVAH2iov8qjkPDOOY6JkloZJNRdyTj1tqakcFW01MWYCe0hQZfcgfwUvb9av4P2BDYtRJ5XiNrDcuW5DrGZdTyYji+1MBWv2OYgLk/UXVDZWd9/oJKoh/ZJrmCr5O6sDcXDX1npp0eUJJ1Es5l4n0/BS6jdNEl8MUWcyM
 i2PaSbWS
 ufzafI+Cp/M+/1LCThepqWsgCD1I6RVNo81NuuR0PmaAnGH+06w/YX1obkgRuAgvg+nFUjyPSUAeL1ZI8Uu4/IzFpP+6odpQzqTRhhk3dBUMKoW6glOwqKL4hU/lx5Lc8fEq5xG6lxMqKf6kvlrG5Wq9SN/FDPXAPOTq63xl+AbxftKuuRREAO1Crp4CNqPN86iOKe8M0OlO8lExZWxdMTT/rMEydA+r/T4gnWCo5kP7mUBMk9xlDOMKl0wbHck7NCStCsU9tlpBhVAqXlA+LE+jiO/CPmhRY6re4lSHGc+IGF12Pa7/1d8PWawH+R/VKt+qsNAAZLREy2B12cDsSI2JMo+/Ll7wIY5f1510Guhf/ydcmtPtnJiN7Tmf/ZFzRuug3LeTUrjRcMYEfcrL9nJ+4b0MJ+uhKDmqWQqOqvn9Fbh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tim,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.18-rc7]
[cannot apply to akpm-mm/mm-everything next-20251127]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tim-Bird/printk-add-early_counter_ns-routine-for-printk-blind-spot/20251125-133242
base:   linus/master
patch link:    https://lore.kernel.org/r/39b09edb-8998-4ebd-a564-7d594434a981%40bird.org
patch subject: [PATCH] printk: add early_counter_ns routine for printk blind spot
config: i386-randconfig-2006-20250825 (https://download.01.org/0day-ci/archive/20251127/202511271051.yfp2O98B-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251127/202511271051.yfp2O98B-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511271051.yfp2O98B-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: init/main.o: in function `kernel_init':
>> init/main.c:1522:(.ref.text+0x201): undefined reference to `__udivdi3'


vim +1522 init/main.c

  1481	
  1482	static int __ref kernel_init(void *unused)
  1483	{
  1484		int ret;
  1485		u64 end_cycles, end_ns;
  1486		u32 early_mult, early_shift;
  1487	
  1488		/*
  1489		 * Wait until kthreadd is all set-up.
  1490		 */
  1491		wait_for_completion(&kthreadd_done);
  1492	
  1493		kernel_init_freeable();
  1494		/* need to finish all async __init code before freeing the memory */
  1495		async_synchronize_full();
  1496	
  1497		system_state = SYSTEM_FREEING_INITMEM;
  1498		kprobe_free_init_mem();
  1499		ftrace_free_init_mem();
  1500		kgdb_free_init_mem();
  1501		exit_boot_config();
  1502		free_initmem();
  1503		mark_readonly();
  1504	
  1505		/*
  1506		 * Kernel mappings are now finalized - update the userspace page-table
  1507		 * to finalize PTI.
  1508		 */
  1509		pti_finalize();
  1510	
  1511		system_state = SYSTEM_RUNNING;
  1512		numa_default_policy();
  1513	
  1514		rcu_end_inkernel_boot();
  1515	
  1516		do_sysctl_args();
  1517	
  1518		/* show calibration data for early_counter_ns */
  1519		end_cycles = get_cycles();
  1520		end_ns = local_clock();
  1521		clocks_calc_mult_shift(&early_mult, &early_shift,
> 1522			((end_cycles - start_cycles) * NSEC_PER_SEC)/(end_ns - start_ns),
  1523			NSEC_PER_SEC, 50);
  1524	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

