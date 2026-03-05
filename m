Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14FAEFCE56
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 00:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72C86B0005; Wed,  4 Mar 2026 19:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C545E6B0088; Wed,  4 Mar 2026 19:46:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B534F6B0089; Wed,  4 Mar 2026 19:46:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2BDF6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:46:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A183160775
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:46:58 +0000 (UTC)
X-FDA: 84510169716.04.7A20F74
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id 104B74000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:46:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tak8hToa;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772671616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=qZ90msOcgsrVdfWnPxN/NhQfroFLWZBjrVJqUkxE1UA=;
	b=Lh0LiyO9S+/vvVCGX+uOLeRhOPePLQ51cZQjFwa2t49YdMZUocoNn+l79lRCqlTV3XTzOq
	eJ9qjIWXPOk+03UCuNgBYHPFA44BrhJ3rj9Bwdx3iTgE2XsdqCf3NF6oRRrfLzy9/LYB0F
	/ZY5oBqAc05p8OStxeK+jTZeQkuriVU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tak8hToa;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772671616; a=rsa-sha256;
	cv=none;
	b=3DYZtJP5cCdGNhvTcSS79Q+4EL9v7UnfC6t3rPPC2mELuwDL5luiqvKx6i52NXn4v7OGmp
	dTxSzJRwrdsgucChfjT7X0ny2i7AlDf6/psMjVvJvi5mnSx+Ay3ThuutoqHFjFMRMer3nY
	SZaEJ3W3C5JWgPLXJ1ZpvfiTZ4Y/qtU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772671616; x=1804207616;
  h=date:from:to:cc:subject:message-id;
  bh=bJ7+DgHCozu0Mp90zJWreRWGE3aDkWPO8YWYz7k+W8A=;
  b=Tak8hToasMpSu0rZCkwrvxXXZm0rEAqYTovP1ucO3fnu/8nTMJkzCbUX
   00YBvNzDY/RT6goV66M2aN8hkfFeBzT53hqjt4iU6F+RDNrSFQxrZEPOx
   Br39EFxMgJihWfNLONZBjR1kGWjo2I//pxh325e6y+BMFtZ0nL/4q1a2o
   sO9/CUdpRW/Q9ZTd9oNOJSdvSCQcMqEeRu1JiLGIa5eLZ9Wt3LR+hDQOg
   gSBgHBGBvcw0SIiexzDGpq8jekpqaaxftmNlRWLU7kcG32AQIahBG6ctn
   uatfft9ixXge7FACWAwJMiLjUAi0dvBxXUydceR5L1XHB8TSav67Kf5Rw
   g==;
X-CSE-ConnectionGUID: 65kMzBOGRvOg9epSOocNYg==
X-CSE-MsgGUID: WQ3mkRwtQKKDMDMG+eY+yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="85219039"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="85219039"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 16:46:54 -0800
X-CSE-ConnectionGUID: KwCz41QtSGi5Es0LC77l6w==
X-CSE-MsgGUID: e2VFDQeBT7+piCMJXRvB3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="241519940"
Received: from lkp-server01.sh.intel.com (HELO f27a57aa7a36) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 Mar 2026 16:46:52 -0800
Received: from kbuild by f27a57aa7a36 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxwrZ-000000004sB-2dh1;
	Thu, 05 Mar 2026 00:46:49 +0000
Date: Thu, 05 Mar 2026 08:45:55 +0800
From: kernel test robot <lkp@intel.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: oe-kbuild-all@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 2981/3989] mm/page_table_check.c:154:6:
 error: too many arguments to function 'pte_user_accessible_page'
Message-ID: <202603050830.LXQcUa5Z-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 104B74000B
X-Rspamd-Server: rspam07
X-Stat-Signature: kz6o6oag416o9pizyk4aa9tq4f91ce5z
X-Rspam-User: 
X-HE-Tag: 1772671615-607418
X-HE-Meta: U2FsdGVkX1/nOtrz8LX29o4UM7asG9BlXHsP/ps0uaPKN5mhq86TmDxjlxJOfne6HiUXfixyxcQ3bE104MzelH+GuCrXe9KdbOKbpqwSpHTBroW7FW76LZnksg/wE61QzDzvJV4TI3K1UzpIWwSCi3lTyD8el0YJDzvWhRIGJZbOHLWm87G7Cywr0DynZi56Mef9IOR0euzkzGdh4dzuEmar4Epa9trudlXL6PdNGOzuoEbKrxkznhSHlMRhUHwX3Mep90nI4rVhHHO9kiJrscpHXg9QLM0ItzVfWYoCJi5NuH/jT/Vbxc5ItwkoqG0kBCYsg9j5YOIKuhNBuVPoywXSUBKDI7edHDYhf2DwmL5JlDw0CDbJEkkv+107t0PtCfpGJuBdOjKPeLXk9b8jIdjVPbX+De5SpKnvOuVdfNQh3Q71So4apIVlyq5rwglRSfr6pFNbyfhML3pVmKE7i+MWUWhd/eWEbe/DeDMA6e5Tt8eCpaNaLiZeVNGU3vX4eQ1T6agmvWlzmBLuSEcJJMbnkjzkA/BmvXEyz74Vb6Nq8awrEipgnyIr/6uHSQucLa/9WCQRzVH9au/W1SAlQvJ4nLtXgbYDnNEY83zIGSr3k4p32xilOCWarSXS+uaOZDhTVqCA4jNIoADH0YCZMGvy2sCRszFxw25l4L39Ru66DSr1nreyOdTnjNcgYNqA5pcDbnUpaV/2Z/7IXiLxZY0Poa5nl7Slu2QeNb5FoXwHrp/bY6uHwswLtvD1Tf96rf6LXb3Ns0PAXGjoHh7g9EW16CrCDjmIXuk6PJhs9bmAMtqlXT+Cjpl3bcUv2dNRrybDUpY0GuF1Jo0WA8danwL53rYB4Z2S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   fc7b1a72c6cd5cbbd989c6c32a6486e3e4e3594d
commit: fba4fd7b84a5f96d12c9153b7eedb4807b9d96c5 [2981/3989] mm/page_table_check: Pass mm_struct to pxx_user_accessible_page()
config: powerpc-randconfig-002-20260305 (https://download.01.org/0day-ci/archive/20260305/202603050830.LXQcUa5Z-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260305/202603050830.LXQcUa5Z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603050830.LXQcUa5Z-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/page_table_check.c: In function '__page_table_check_pte_clear':
   mm/page_table_check.c:154:31: warning: passing argument 1 of 'pte_user_accessible_page' makes integer from pointer without a cast [-Wint-conversion]
     if (pte_user_accessible_page(mm, addr, pte))
                                  ^~
   In file included from arch/powerpc/include/asm/book3s/pgtable.h:8,
                    from arch/powerpc/include/asm/pgtable.h:18,
                    from include/linux/pgtable.h:6,
                    from include/linux/mm.h:32,
                    from mm/page_table_check.c:8:
   arch/powerpc/include/asm/book3s/32/pgtable.h:441:51: note: expected 'pte_t' {aka 'long unsigned int'} but argument is of type 'struct mm_struct *'
    static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
                                                ~~~~~~^~~
>> mm/page_table_check.c:154:6: error: too many arguments to function 'pte_user_accessible_page'
     if (pte_user_accessible_page(mm, addr, pte))
         ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/powerpc/include/asm/book3s/pgtable.h:8,
                    from arch/powerpc/include/asm/pgtable.h:18,
                    from include/linux/pgtable.h:6,
                    from include/linux/mm.h:32,
                    from mm/page_table_check.c:8:
   arch/powerpc/include/asm/book3s/32/pgtable.h:441:20: note: declared here
    static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
                       ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/page_table_check.c: In function '__page_table_check_pmd_clear':
>> mm/page_table_check.c:165:44: error: macro "pmd_user_accessible_page" passed 3 arguments, but takes just 2
     if (pmd_user_accessible_page(mm, addr, pmd))
                                               ^
>> mm/page_table_check.c:165:6: error: 'pmd_user_accessible_page' undeclared (first use in this function); did you mean 'pte_user_accessible_page'?
     if (pmd_user_accessible_page(mm, addr, pmd))
         ^~~~~~~~~~~~~~~~~~~~~~~~
         pte_user_accessible_page
   mm/page_table_check.c:165:6: note: each undeclared identifier is reported only once for each function it appears in
   mm/page_table_check.c: In function '__page_table_check_pud_clear':
>> mm/page_table_check.c:176:44: error: macro "pud_user_accessible_page" passed 3 arguments, but takes just 2
     if (pud_user_accessible_page(mm, addr, pud))
                                               ^
>> mm/page_table_check.c:176:6: error: 'pud_user_accessible_page' undeclared (first use in this function); did you mean 'pte_user_accessible_page'?
     if (pud_user_accessible_page(mm, addr, pud))
         ^~~~~~~~~~~~~~~~~~~~~~~~
         pte_user_accessible_page
   mm/page_table_check.c: In function '__page_table_check_ptes_set':
   mm/page_table_check.c:211:31: warning: passing argument 1 of 'pte_user_accessible_page' makes integer from pointer without a cast [-Wint-conversion]
     if (pte_user_accessible_page(mm, addr, pte))
                                  ^~
   In file included from arch/powerpc/include/asm/book3s/pgtable.h:8,
                    from arch/powerpc/include/asm/pgtable.h:18,
                    from include/linux/pgtable.h:6,
                    from include/linux/mm.h:32,
                    from mm/page_table_check.c:8:
   arch/powerpc/include/asm/book3s/32/pgtable.h:441:51: note: expected 'pte_t' {aka 'long unsigned int'} but argument is of type 'struct mm_struct *'
    static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
                                                ~~~~~~^~~
   mm/page_table_check.c:211:6: error: too many arguments to function 'pte_user_accessible_page'
     if (pte_user_accessible_page(mm, addr, pte))
         ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/powerpc/include/asm/book3s/pgtable.h:8,
                    from arch/powerpc/include/asm/pgtable.h:18,
                    from include/linux/pgtable.h:6,
                    from include/linux/mm.h:32,
                    from mm/page_table_check.c:8:
   arch/powerpc/include/asm/book3s/32/pgtable.h:441:20: note: declared here
    static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
                       ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/page_table_check.c: In function '__page_table_check_pmds_set':
   mm/page_table_check.c:241:44: error: macro "pmd_user_accessible_page" passed 3 arguments, but takes just 2
     if (pmd_user_accessible_page(mm, addr, pmd))
                                               ^
   mm/page_table_check.c:241:6: error: 'pmd_user_accessible_page' undeclared (first use in this function); did you mean 'pte_user_accessible_page'?
     if (pmd_user_accessible_page(mm, addr, pmd))
         ^~~~~~~~~~~~~~~~~~~~~~~~
         pte_user_accessible_page
   mm/page_table_check.c: In function '__page_table_check_puds_set':
   mm/page_table_check.c:257:44: error: macro "pud_user_accessible_page" passed 3 arguments, but takes just 2
     if (pud_user_accessible_page(mm, addr, pud))
                                               ^
   mm/page_table_check.c:257:6: error: 'pud_user_accessible_page' undeclared (first use in this function); did you mean 'pte_user_accessible_page'?
     if (pud_user_accessible_page(mm, addr, pud))
         ^~~~~~~~~~~~~~~~~~~~~~~~
         pte_user_accessible_page


vim +/pte_user_accessible_page +154 mm/page_table_check.c

     2	
     3	/*
     4	 * Copyright (c) 2021, Google LLC.
     5	 * Pasha Tatashin <pasha.tatashin@soleen.com>
     6	 */
     7	#include <linux/kstrtox.h>
   > 8	#include <linux/mm.h>
     9	#include <linux/page_table_check.h>
    10	#include <linux/swap.h>
    11	#include <linux/leafops.h>
    12	
    13	#undef pr_fmt
    14	#define pr_fmt(fmt)	"page_table_check: " fmt
    15	
    16	struct page_table_check {
    17		atomic_t anon_map_count;
    18		atomic_t file_map_count;
    19	};
    20	
    21	static bool __page_table_check_enabled __initdata =
    22					IS_ENABLED(CONFIG_PAGE_TABLE_CHECK_ENFORCED);
    23	
    24	DEFINE_STATIC_KEY_TRUE(page_table_check_disabled);
    25	EXPORT_SYMBOL(page_table_check_disabled);
    26	
    27	static int __init early_page_table_check_param(char *buf)
    28	{
    29		return kstrtobool(buf, &__page_table_check_enabled);
    30	}
    31	
    32	early_param("page_table_check", early_page_table_check_param);
    33	
    34	static bool __init need_page_table_check(void)
    35	{
    36		return __page_table_check_enabled;
    37	}
    38	
    39	static void __init init_page_table_check(void)
    40	{
    41		if (!__page_table_check_enabled)
    42			return;
    43		static_branch_disable(&page_table_check_disabled);
    44	}
    45	
    46	struct page_ext_operations page_table_check_ops = {
    47		.size = sizeof(struct page_table_check),
    48		.need = need_page_table_check,
    49		.init = init_page_table_check,
    50		.need_shared_flags = false,
    51	};
    52	
    53	static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
    54	{
    55		BUG_ON(!page_ext);
    56		return page_ext_data(page_ext, &page_table_check_ops);
    57	}
    58	
    59	/*
    60	 * An entry is removed from the page table, decrement the counters for that page
    61	 * verify that it is of correct type and counters do not become negative.
    62	 */
    63	static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
    64	{
    65		struct page_ext_iter iter;
    66		struct page_ext *page_ext;
    67		struct page *page;
    68		bool anon;
    69	
    70		if (!pfn_valid(pfn))
    71			return;
    72	
    73		page = pfn_to_page(pfn);
    74		BUG_ON(PageSlab(page));
    75		anon = PageAnon(page);
    76	
    77		rcu_read_lock();
    78		for_each_page_ext(page, pgcnt, page_ext, iter) {
    79			struct page_table_check *ptc = get_page_table_check(page_ext);
    80	
    81			if (anon) {
    82				BUG_ON(atomic_read(&ptc->file_map_count));
    83				BUG_ON(atomic_dec_return(&ptc->anon_map_count) < 0);
    84			} else {
    85				BUG_ON(atomic_read(&ptc->anon_map_count));
    86				BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
    87			}
    88		}
    89		rcu_read_unlock();
    90	}
    91	
    92	/*
    93	 * A new entry is added to the page table, increment the counters for that page
    94	 * verify that it is of correct type and is not being mapped with a different
    95	 * type to a different process.
    96	 */
    97	static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
    98					 bool rw)
    99	{
   100		struct page_ext_iter iter;
   101		struct page_ext *page_ext;
   102		struct page *page;
   103		bool anon;
   104	
   105		if (!pfn_valid(pfn))
   106			return;
   107	
   108		page = pfn_to_page(pfn);
   109		BUG_ON(PageSlab(page));
   110		anon = PageAnon(page);
   111	
   112		rcu_read_lock();
   113		for_each_page_ext(page, pgcnt, page_ext, iter) {
   114			struct page_table_check *ptc = get_page_table_check(page_ext);
   115	
   116			if (anon) {
   117				BUG_ON(atomic_read(&ptc->file_map_count));
   118				BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);
   119			} else {
   120				BUG_ON(atomic_read(&ptc->anon_map_count));
   121				BUG_ON(atomic_inc_return(&ptc->file_map_count) < 0);
   122			}
   123		}
   124		rcu_read_unlock();
   125	}
   126	
   127	/*
   128	 * page is on free list, or is being allocated, verify that counters are zeroes
   129	 * crash if they are not.
   130	 */
   131	void __page_table_check_zero(struct page *page, unsigned int order)
   132	{
   133		struct page_ext_iter iter;
   134		struct page_ext *page_ext;
   135	
   136		BUG_ON(PageSlab(page));
   137	
   138		rcu_read_lock();
   139		for_each_page_ext(page, 1 << order, page_ext, iter) {
   140			struct page_table_check *ptc = get_page_table_check(page_ext);
   141	
   142			BUG_ON(atomic_read(&ptc->anon_map_count));
   143			BUG_ON(atomic_read(&ptc->file_map_count));
   144		}
   145		rcu_read_unlock();
   146	}
   147	
   148	void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
   149					  pte_t pte)
   150	{
   151		if (&init_mm == mm)
   152			return;
   153	
 > 154		if (pte_user_accessible_page(mm, addr, pte))
   155			page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
   156	}
   157	EXPORT_SYMBOL(__page_table_check_pte_clear);
   158	
   159	void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
   160					  pmd_t pmd)
   161	{
   162		if (&init_mm == mm)
   163			return;
   164	
 > 165		if (pmd_user_accessible_page(mm, addr, pmd))
   166			page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
   167	}
   168	EXPORT_SYMBOL(__page_table_check_pmd_clear);
   169	
   170	void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
   171					  pud_t pud)
   172	{
   173		if (&init_mm == mm)
   174			return;
   175	
 > 176		if (pud_user_accessible_page(mm, addr, pud))
   177			page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
   178	}
   179	EXPORT_SYMBOL(__page_table_check_pud_clear);
   180	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

