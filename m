Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E46D5FF4933
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 03:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BD986B0096; Sun, 29 Mar 2026 23:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195766B0098; Sun, 29 Mar 2026 23:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0841F6B0099; Sun, 29 Mar 2026 23:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7FE66B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 23:15:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81D01C2092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:15:26 +0000 (UTC)
X-FDA: 84601263852.07.EA3BAF4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id BE96AA0008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:15:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MIR/7YSL";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774840524; a=rsa-sha256;
	cv=none;
	b=AoWZdcsw9utZNoK2P1jXsZbDMx2Ps25CUvwx1i1a+EMrsIpsW2xK+STAsnj6Dk/yBWQFpG
	pfypnGdb4a2rH0ISohv4Yz2HW7K85jg+1Njq1fnE+XHRzadJGiyjiNFzL1GizfYGAcAums
	tgSDGinFaJPx8cC5ub4xb7XgeZXxEKY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MIR/7YSL";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774840524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ZhtVGB0mCFQZ5ER0VM0tXTAo0NsSqt8Wt9S+rJfdgys=;
	b=dDeB9HCIEBWinTda9d39Dy3OpuADmEnr5XDBNQW3FUchqqo/cQFxCGdxUFvh5kfzV7Y0sD
	gwWIa1Z6hPSQS3fTOCGsjo09DcnOuJ1k5jRP6i70DZgVmeFPG1WKTznNMUl5cblFmmiPAa
	i3xSOVZtPZDu5kzCXep4Sii/5JA6tNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774840523; x=1806376523;
  h=date:from:to:cc:subject:message-id;
  bh=9XXDiBBOdstSsctXLA/grLYAkXok6ua2OirS2KFL35o=;
  b=MIR/7YSLzzFsaPmFuCd5+KaEAyI/bBypsYM8Uz/MJZwTHCOpw+8hecfZ
   DRDHRsWRa7JCwYj3Z4aaF25JTI71moIFba/1xhnS9nmm1uvioCgUxa5RA
   tRG367CGiBSZ1/TyZ1cBinjtsxKqzOr689yfSUnW5Pvr8exT1ex/4ZDNS
   vIcUQE7osWDCbOq2qGnH+kM6YVbz2CEXgxnSFAe9A/1/vzczwGGXUGGks
   wc4R+DqGEq03Yjpg5t07aZY+9dhgRUCt5LoqkhM3NX2JS0hbpl5FlQ8Fm
   EeIkE1eB2w0TczmblHdXX6hXbUXhFJINf7c3enCniav8D0fY1RKXG8e6g
   g==;
X-CSE-ConnectionGUID: MzcSYyyRRuKVx88oY05g8Q==
X-CSE-MsgGUID: iDa3/hsRRJiFvDmne8Pm2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="75939815"
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="75939815"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 20:15:22 -0700
X-CSE-ConnectionGUID: iHbqDrBKTf+/753tAOshSA==
X-CSE-MsgGUID: dhLUaD43TyWhVWjfRtR4XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="225818161"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 29 Mar 2026 20:15:20 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w735x-000000000bB-1IhG;
	Mon, 30 Mar 2026 03:15:17 +0000
Date: Mon, 30 Mar 2026 11:14:42 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/huge_memory.c:84:13: warning: variable
 'anon_orders_configured' set but not used
Message-ID: <202603301149.yXng4wfz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: pttixyy8d4x3zx8ti3fdcb75x7xube6x
X-Rspamd-Queue-Id: BE96AA0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774840523-855359
X-HE-Meta: U2FsdGVkX19StcuD1RuFPtnP6tM4WzN0y04WX5mTPw4ibB6uRMZKb7DLR1v4NQFwjCC2qFoAS1G9lxg+eC8H8mZTC7//ZWvpGAeIV4xY1hBLCY07Xrpr5QMo4dtMzyWQ++dxqaWeW0aiHVV/fwJNlVrNUuBz6HRJdu/zGhsHEtFQ5dWMI5c38YPGb81U4ZAnLpius3EDsHavub6pThkfloSTuFPnsWCTSr7dKKKiW6GG0phtXMWxsAZXlPnohXZg2BJOXFUz5StgULQwtd14KyEwB0zDQvEK9h0U3+zgX33f+4fF7ITzIMX/1/9c5cqZCUIVKXEF1SZENDpfUJYCn9QqU9v2JtW+wk9tFd92uNzGpLaX8JiXBvRA40tO0DoeXm3/QPsb+jSgh3SPi5YtYtn9YLlU8FEJtl1ZA60DPafZRMH81A9J1tlYtqQEbte0b8ORpQUTii/UZSSnOskRlt5rm0owqh3qbyxqU6k849htJYDS8nwYxinGQ9dG/FWhK9aIshbYPyoWBrByXVZtLPMsF/aMk6RX0EHqknJAvdHAKe2T/MJ+dHfAJidS2UNR2NSikEEkEuLO9gBMzEZgiesd9oGizZASmNfprYO4A4mYWvHjB3npVmFf71EJeiJHLlU6bZyFxaucLWthlOjYywGWtRPqPzf9sq33dC01QjLh1KMsOjY5n5MeyrtR6ScAR66OZXTTG49FPf436beWZEeGxKf2aiT7UXwnlUDBRVWK6TH9rL6nHkj0+pfqPb8hHmuiIyTtl40jz1wCTPBURpFHgpqs4NCIdOQzfo+zFTFaC8E0N34wb0JyuXie1bCnWX6yBmbFj4zC8oSq4L0bAejesj4wNDa3AgUKBcrVmPGLWy8DxPvo47JWy8qY/LCt7WZ5s5ejBJxBubogesTzznHtHCAfIL3Bho136wTXPDPMTNw8qJ36GqApNN31NwjZEV3KcE9a9MX8phV0zWm
 fsiBvjyE
 b0AFchhQdpl4XE0G4iuG1Gya/GIEuNoYzS+XF+QelaEMyBiPaP9v2rslC6Avqltp/FZhW3WZlND1ATXcyO/RF4v6W/jU1feqKu/Fq9HqaG/jtLCHQFVB/CW3+Qu7sNh/vwOiZF35Ch4AVACsXWqa8aLhC54iLA6mWETixJ6yMNlih4IsIQZpb2lXOOMf/Tf0tIT9t/dd7PBmdI+fy2tii7ptOXjbAkwCg/t4l8vaLM4tLwUL57vaOFiMFO46CX1TLzAesV63OBwPXZdsj/H6YM6yUsrKTp+s3Zjmk6ooRt6GdePoDYPJrQBP8KBQDXQCjoOlia+IgeCMYxhMvrviduPw1Z+JaQp/ipsHsOcGsfY5uegklYo0mVwvZ0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7aaa8047eafd0bd628065b15757d9b48c5f9c07d
commit: 4496e1c1354bd4837bcc1414f6e1a4d042857903 crash_dump, nvme: select CONFIGFS_FS as built-in
date:   10 months ago
config: loongarch-randconfig-002-20260330 (https://download.01.org/0day-ci/archive/20260330/202603301149.yXng4wfz-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 2cd67b8b69f78e3f95918204320c3075a74ba16c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260330/202603301149.yXng4wfz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603301149.yXng4wfz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/huge_memory.c:44:
   arch/loongarch/include/asm/tlb.h:142:24: warning: default initialization of an object of type 'struct vm_area_struct' with const member leaves the object uninitialized [-Wdefault-const-init-field-unsafe]
     142 |         struct vm_area_struct vma;
         |                               ^
   include/linux/mm_types.h:803:20: note: member 'vm_flags' declared 'const' here
     803 |                 const vm_flags_t vm_flags;
         |                                  ^
>> mm/huge_memory.c:84:13: warning: variable 'anon_orders_configured' set but not used [-Wunused-but-set-global]
      84 | static bool anon_orders_configured __initdata;
         |             ^
   2 warnings generated.
--
>> mm/ksm.c:255:22: warning: variable 'ksm_pages_scanned' set but not used [-Wunused-but-set-global]
     255 | static unsigned long ksm_pages_scanned;
         |                      ^
>> mm/ksm.c:258:22: warning: variable 'ksm_pages_shared' set but not used [-Wunused-but-set-global]
     258 | static unsigned long ksm_pages_shared;
         |                      ^
>> mm/ksm.c:261:22: warning: variable 'ksm_pages_sharing' set but not used [-Wunused-but-set-global]
     261 | static unsigned long ksm_pages_sharing;
         |                      ^
>> mm/ksm.c:264:22: warning: variable 'ksm_pages_unshared' set but not used [-Wunused-but-set-global]
     264 | static unsigned long ksm_pages_unshared;
         |                      ^
>> mm/ksm.c:270:22: warning: variable 'ksm_stable_node_chains' set but not used [-Wunused-but-set-global]
     270 | static unsigned long ksm_stable_node_chains;
         |                      ^
>> mm/ksm.c:273:22: warning: variable 'ksm_stable_node_dups' set but not used [-Wunused-but-set-global]
     273 | static unsigned long ksm_stable_node_dups;
         |                      ^
>> mm/ksm.c:301:22: warning: variable 'ksm_pages_skipped' set but not used [-Wunused-but-set-global]
     301 | static unsigned long ksm_pages_skipped;
         |                      ^
   7 warnings generated.
--
   In file included from mm/khugepaged.c:25:
   arch/loongarch/include/asm/tlb.h:142:24: warning: default initialization of an object of type 'struct vm_area_struct' with const member leaves the object uninitialized [-Wdefault-const-init-field-unsafe]
     142 |         struct vm_area_struct vma;
         |                               ^
   include/linux/mm_types.h:803:20: note: member 'vm_flags' declared 'const' here
     803 |                 const vm_flags_t vm_flags;
         |                                  ^
>> mm/khugepaged.c:73:21: warning: variable 'khugepaged_pages_collapsed' set but not used [-Wunused-but-set-global]
      73 | static unsigned int khugepaged_pages_collapsed;
         |                     ^
>> mm/khugepaged.c:74:21: warning: variable 'khugepaged_full_scans' set but not used [-Wunused-but-set-global]
      74 | static unsigned int khugepaged_full_scans;
         |                     ^
   3 warnings generated.
--
>> drivers/of/fdt.c:463:12: warning: variable 'of_fdt_crc32' set but not used [-Wunused-but-set-global]
     463 | static u32 of_fdt_crc32;
         |            ^
   1 warning generated.


vim +/anon_orders_configured +84 mm/huge_memory.c

97ae17497e996f Kirill A. Shutemov      2012-12-12  43  
71e3aac0724ffe Andrea Arcangeli        2011-01-13 @44  #include <asm/tlb.h>
71e3aac0724ffe Andrea Arcangeli        2011-01-13  45  #include <asm/pgalloc.h>
71e3aac0724ffe Andrea Arcangeli        2011-01-13  46  #include "internal.h"
014bb1de4fc17d NeilBrown               2022-05-09  47  #include "swap.h"
71e3aac0724ffe Andrea Arcangeli        2011-01-13  48  
283fd6fe0528ae Anshuman Khandual       2022-03-24  49  #define CREATE_TRACE_POINTS
283fd6fe0528ae Anshuman Khandual       2022-03-24  50  #include <trace/events/thp.h>
283fd6fe0528ae Anshuman Khandual       2022-03-24  51  
ba76149f47d8c9 Andrea Arcangeli        2011-01-13  52  /*
b14d595aa29923 Michael DeGuzis         2017-05-17  53   * By default, transparent hugepage support is disabled in order to avoid
b14d595aa29923 Michael DeGuzis         2017-05-17  54   * risking an increased memory footprint for applications that are not
b14d595aa29923 Michael DeGuzis         2017-05-17  55   * guaranteed to benefit from it. When transparent hugepage support is
b14d595aa29923 Michael DeGuzis         2017-05-17  56   * enabled, it is for all mappings, and khugepaged scans all mappings.
8bfa3f9a012c40 Jianguo Wu              2013-11-12  57   * Defrag is invoked by khugepaged hugepage allocations and by page faults
8bfa3f9a012c40 Jianguo Wu              2013-11-12  58   * for all hugepage allocations.
ba76149f47d8c9 Andrea Arcangeli        2011-01-13  59   */
71e3aac0724ffe Andrea Arcangeli        2011-01-13  60  unsigned long transparent_hugepage_flags __read_mostly =
13ece886d99cd6 Andrea Arcangeli        2011-01-13  61  #ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
ba76149f47d8c9 Andrea Arcangeli        2011-01-13  62  	(1<<TRANSPARENT_HUGEPAGE_FLAG)|
13ece886d99cd6 Andrea Arcangeli        2011-01-13  63  #endif
13ece886d99cd6 Andrea Arcangeli        2011-01-13  64  #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
13ece886d99cd6 Andrea Arcangeli        2011-01-13  65  	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
13ece886d99cd6 Andrea Arcangeli        2011-01-13  66  #endif
444eb2a449ef36 Mel Gorman              2016-03-17  67  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
79da5407eeadc7 Kirill A. Shutemov      2012-12-12  68  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
79da5407eeadc7 Kirill A. Shutemov      2012-12-12  69  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
ba76149f47d8c9 Andrea Arcangeli        2011-01-13  70  
54d917295b8366 Qi Zheng                2023-09-11  71  static struct shrinker *deferred_split_shrinker;
54d917295b8366 Qi Zheng                2023-09-11  72  static unsigned long deferred_split_count(struct shrinker *shrink,
54d917295b8366 Qi Zheng                2023-09-11  73  					  struct shrink_control *sc);
54d917295b8366 Qi Zheng                2023-09-11  74  static unsigned long deferred_split_scan(struct shrinker *shrink,
54d917295b8366 Qi Zheng                2023-09-11  75  					 struct shrink_control *sc);
81d3ff3c6f7630 Usama Arif              2024-08-30  76  static bool split_underused_thp = true;
f000565adb770b Andrea Arcangeli        2011-01-13  77  
97ae17497e996f Kirill A. Shutemov      2012-12-12  78  static atomic_t huge_zero_refcount;
5691753d73a233 Matthew Wilcox (Oracle  2024-03-26  79) struct folio *huge_zero_folio __read_mostly;
3b77e8c8cde581 Hugh Dickins            2021-06-15  80  unsigned long huge_zero_pfn __read_mostly = ~0UL;
3485b88390b0af Ryan Roberts            2023-12-07  81  unsigned long huge_anon_orders_always __read_mostly;
3485b88390b0af Ryan Roberts            2023-12-07  82  unsigned long huge_anon_orders_madvise __read_mostly;
3485b88390b0af Ryan Roberts            2023-12-07  83  unsigned long huge_anon_orders_inherit __read_mostly;
dd4d30d1cdbe82 Ryan Roberts            2024-08-14 @84  static bool anon_orders_configured __initdata;
3485b88390b0af Ryan Roberts            2023-12-07  85  

:::::: The code at line 84 was first introduced by commit
:::::: dd4d30d1cdbe826e6569b44453c2d9bb9424d234 mm: override mTHP "enabled" defaults at kernel cmdline

:::::: TO: Ryan Roberts <ryan.roberts@arm.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

