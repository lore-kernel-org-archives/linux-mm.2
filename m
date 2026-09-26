Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C1FC9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 18:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F136B0088; Sat, 26 Sep 2026 14:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E88B6B008A; Sat, 26 Sep 2026 14:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5726B008C; Sat, 26 Sep 2026 14:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08D0E6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:31:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75D051403EC
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:31:37 +0000 (UTC)
X-FDA: 85256756634.11.857EC69
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf20.hostedemail.com (Postfix) with ESMTP id 035721C0005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:31:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jPtRzGzU;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790447495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=IF8K1DzuftNl1ZDBZoI11gPxs1m/otMNxVlRbN5Duuk=;
	b=wmn2egcM6xyqbTLOeCzKyiGpGhkP32lo2fsgj6ekrmwbeEY+rLD5akvM6Q0E09Z4QgkLvE
	T+wSt8XyPbkD8XLf8TKbVYnOPd6Gy+cB6EMVwC9EKDzm0EOlgJ6QUW0KeOJkhLuxHw7YCY
	LUFLw70AAtvFxycgqizcViIspp7HH4g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jPtRzGzU;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790447495;
	b=Z3l27Y7J4yVgD7K/4YwAUZxNIpwv18lYKT6+3+gyWnhexvJtjWwzw0f1MX4mfztJWN7ZuL
	JK5Hb7B2Wjw765RqY7EcKOb30tpR+XI+gOrtc6DpwK5EhT7q8Ek/Z7vxJXFTPNBqN44e5h
	06wgJFSDBz+tltf21Wz1iONOPsZH+gU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790447495; x=1821983495;
  h=date:from:to:cc:subject:message-id;
  bh=YhoPhH9eZ/OebksKCmZlQ29kPnAYvBb86I3w02YRknM=;
  b=jPtRzGzUz2lk9arz0ECdKQ9w/iMiiO6XNscGu5PbevVmF6hJZqIpstbf
   YdLD17cxnrFkLQn09xULicUF6isa6otV87yu1qx6LEc3NRCl5GkuFMWDM
   OxLsz01qfmS0U4Kk13YYSliX6i2WQQ/43Kh1XuOB/JDlXnXWu/kSgap3E
   dq13nFJNKYtM4zkvO68H8+3HHkc3+iPnMPKcS1BJkA0QykpGhqf6+HURv
   xcYU6F+DO+Wuv20M3XEmOqUYapykTiEBbnVVW4hRXm6j+Y92dH/UKF8pp
   m3QAQYN2XKAXWdxmYIOwCplSD0hPSPqjooYQm4ufYT9cqooVPHvBHXpkA
   g==;
X-CSE-ConnectionGUID: pdQqbtjLSXOFmUSbUGXJzg==
X-CSE-MsgGUID: 1TTuF+xBRJu0639aAnFA0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="116733226"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="116733226"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 11:31:33 -0700
X-CSE-ConnectionGUID: +CWZBnYSSkqN9g9NBvujVw==
X-CSE-MsgGUID: PFs+2ZvDTLyPDetV7Jzz3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="278008807"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 26 Sep 2026 11:31:31 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAXBJ-00000000M73-1T0e;
	Sat, 26 Sep 2026 18:31:29 +0000
Date: Sun, 27 Sep 2026 02:30:30 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 10221/10910]
 include/linux/mmzone.h:94:34: error: 'PUD_SHIFT' undeclared here (not in a
 function); did you mean 'NMI_SHIFT'?
Message-ID: <202609270240.3jTO1ZSC-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 035721C0005
X-Rspam-User: 
X-Stat-Signature: stkkzcttpjypa6dkdi8yabudt5ozmw8d
X-HE-Tag: 1790447494-962339
X-HE-Meta: U2FsdGVkX1/7I6awm+UclqbMhgUfjut9TY8Ws8jb190RQYO1SY5e//Qy5IQXCdT/aEbex9XE4wIGlzlAyj8uPjh7E/5b20o6jK/AISUZAnmrUADWTaBo7JOq9pyUwvHdABTP+fpSoLufZZMWyAi9F2ZQcAk+NbQt39p63agvW6O35y0hv4evnSmc1Y1ajdYOaYDX9wS+xaAZ9E881Wy4OtTN4kly3ujBNUOLsQOOC6jet80uPx8rdILb5qJftZ465wb2ZFKDZ+Z4SYOaxaH1/FGkk8qIZic5Lt5TZoG5wITDoJ0Wqlm2j1OUs06BjiFMefAbLBNySGrH3AQZU8RBtnKI2tZMYjIWhS1UPQrKe/lUtBDNn5KNcoKmPuiVgN7PUK0ot3nPel5YJYhJDmdohZk0/5xJTVbyPUqpkE68hxonurZA2KsqXWWCgXUrudt5mM7iIZIuTnlP/SNZKAbM53pMb2FfeIrS/zu37/UZGeC5m5tIGP2qeJkjWPHxPSKgvEnXaeZ3UElvNQ3xecO+653kuTuevISlRCbR1ZrvKm1EI4pcc/rJ2Gt9EdmeP3sc8bLCXoH8bdAYqiCU2+pfThDZ4Pza3rFh0bI9gNZbqUqfleAXhzRxioZiUUe+Yd6HyUEMSOQeSE4abtupmuW3zF1uZTlmMy/Jld/xGZPdr+bLT2LBl3msQdBuCkfYGhoOnJ42IuxB0XlZNT9qLdzrH7aii6Z3mnKoEHWK4zvh1m7WIN+02v73AijghpXFtD06YybjLyeAAaZZSFI/AFDNngs9Tsjce9LoYA6WuwWe/xQHGyXpxC7sdqSe7ae6//nA+PtLtjq0QbJrOM65v3X3Y4ARnFAxv5JnDYSYp+fsjIjYdSPdOWY6UmsfnwMUb38MXhFIbLhdr0KhkPMaUsXlx1K3MdbFhMIyeGmkCoWl3utPMD0q8FEQqZdlSuPD5S6py2NR65TIqiNXVxISMtY
 mgP6fsmm
 ONOeVzr/cnnKaKsycAJ8BnGIsToyypiEU6IGu8P46TkiRn3D7VCOJiaz2x8KJD3eq2jQRowZGiDs0Tt1XyHk+HdLFIgqla/NkcGqN135dZ09wzQipYMZjowblCw4BPHBtnpP2oc7fXs/zwdn4qBgAzLcDCwqRST0eX52igia8mOUfL1E0MUyeVzPHQHPRirMR66fFlFfQlSORDu1eJI7udyq85esCuQxxZb6SQE4A9FUIau2ezeBjqelgbIzr3znEy+gZIXjX3sQ9wGtnquc+Ge4/Xu5leVnalG9JXgXUZaYw81o17cfy+2PWWrdVhdK6ygxFi55miAQFdeEoqwqMhZm5Ug78iYhIMWYY9DglGiaqSdbcRMtSNMmwLwHTI6jsiTO+Ft+qMr/Z+macDiNUbmhYZNiZYLzEA79+6Sx9UBgU6uKtNT+fBeo5fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   f5f84daefcd92d7a630066635ecea1433ed5eac7
commit: 90506255be6d7481d4141e51dbbe11d7800e9e75 [10221/10910] mm-sparse-vmemmap-introduce-config_vmemmap_optimization-fix
config: riscv-randconfig-1001-20260927 (https://download.01.org/0day-ci/archive/20260927/202609270240.3jTO1ZSC-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270240.3jTO1ZSC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609270240.3jTO1ZSC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/gfp.h:7,
                    from include/linux/mm.h:8,
                    from arch/riscv/kernel/asm-offsets.c:9:
>> include/linux/mmzone.h:94:34: error: 'PUD_SHIFT' undeclared here (not in a function); did you mean 'NMI_SHIFT'?
      94 | #define MAX_FOLIO_ORDER         (PUD_SHIFT - PAGE_SHIFT)
         |                                  ^~~~~~~~~
   include/linux/mmzone.h:117:10: note: in expansion of macro 'MAX_FOLIO_ORDER'
     117 |         (MAX_FOLIO_ORDER - VMEMMAP_OPTIMIZATION_MIN_ORDER + 1)
         |          ^~~~~~~~~~~~~~~
   include/linux/mmzone.h:119:11: note: in expansion of macro '__VMEMMAP_OPTIMIZATION_NR_ORDERS'
     119 |         ((__VMEMMAP_OPTIMIZATION_NR_ORDERS > 0 &&       \
         |           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mmzone.h:1160:36: note: in expansion of macro 'VMEMMAP_OPTIMIZATION_NR_ORDERS'
    1160 |         struct page *vmemmap_tails[VMEMMAP_OPTIMIZATION_NR_ORDERS];
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:185: arch/riscv/kernel/asm-offsets.s] Error 1 shuffle=3113152511
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1425: prepare0] Error 2 shuffle=3113152511
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=3113152511
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=3113152511
   make: Target 'prepare' not remade because of errors.


vim +94 include/linux/mmzone.h

5ad333eb66ff1e Andy Whitcroft  2007-07-17  64  
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  65  #if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  66  /*
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  67   * We don't expect any folios that exceed buddy sizes (and consequently
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  68   * memory sections).
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  69   */
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  70  #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  71  #elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  72  /*
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  73   * Only pages within a single memory section are guaranteed to be
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  74   * contiguous. By limiting folios to a single memory section, all folio
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  75   * pages are guaranteed to be contiguous.
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  76   */
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  77  #define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  78  #elif defined(CONFIG_HUGETLB_PAGE)
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  79  /*
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  80   * There is no real limit on the folio size. We limit them to the maximum we
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  81   * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  82   * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  83   */
622026e87c4019 Kiryl Shutsemau 2026-02-27  84  #ifdef CONFIG_64BIT
622026e87c4019 Kiryl Shutsemau 2026-02-27  85  #define MAX_FOLIO_ORDER		(ilog2(SZ_16G) - PAGE_SHIFT)
622026e87c4019 Kiryl Shutsemau 2026-02-27  86  #else
622026e87c4019 Kiryl Shutsemau 2026-02-27  87  #define MAX_FOLIO_ORDER		(ilog2(SZ_1G) - PAGE_SHIFT)
622026e87c4019 Kiryl Shutsemau 2026-02-27  88  #endif
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  89  #else
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  90  /*
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  91   * Without hugetlb, gigantic folios that are bigger than a single PUD are
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  92   * currently impossible.
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  93   */
622026e87c4019 Kiryl Shutsemau 2026-02-27 @94  #define MAX_FOLIO_ORDER		(PUD_SHIFT - PAGE_SHIFT)
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  95  #endif
a2c77ec320a995 Kiryl Shutsemau 2026-02-27  96  

:::::: The code at line 94 was first introduced by commit
:::::: 622026e87c4019e609010811757e31193cc23847 mm/hugetlb: remove fake head pages

:::::: TO: Kiryl Shutsemau <kas@kernel.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

