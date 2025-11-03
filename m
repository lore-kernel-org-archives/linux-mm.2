Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED732CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD508E0097; Mon,  3 Nov 2025 10:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B48B8E005A; Mon,  3 Nov 2025 10:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA068E0097; Mon,  3 Nov 2025 10:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0868E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:02:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5B8016017C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:02:29 +0000 (UTC)
X-FDA: 84069612018.05.4E007E8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id BDF7840017
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:02:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="mmXHD2G/";
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762182147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7je1rkE/yWTykFeZww6tTQ470YSosQj5htrTdaSPds=;
	b=d0NgLPc2wtykq47BukHmaWygHPDS5hWYVjxQ0cktpqHpwvuD78nqSMikFIb9L3l+YV8M1V
	29yFYn/6AgSXG/9hkc1QLLznflp9gRRfYJWRnxVGlRpDLnCS0ZF5/Bk0hmzcrObdKmka6J
	4eNPbfS9F5LhFixT7W/dDXTuZ/rRLqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762182147; a=rsa-sha256;
	cv=none;
	b=Y87Rrdo9yJmi5y8UHd+bR7pCweuMc8Vm34fl+NKYXYHb8fI9w5unbtriGQcIcF5cJRn6IW
	9Yr9qSPLYKeOEtLty1X1Cpayvjg+OfcPQ8LvfYH08ZJpxv7nBi2vQYHE0Rn3L+xj1NpbWW
	sgMDH673veiYoqaZozOmyMt770izN4s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="mmXHD2G/";
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762182147; x=1793718147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1qVfb6Tt9ZEGVb7HA+q4Rz6oZPevQ+HIETeIkX0+qao=;
  b=mmXHD2G/C3PTILwr4nClMzPo0W1ZI8a0SDTptc96mCNWYvChZKrvpW41
   Ibuygvv0wzYozB6zRlFpdIYckBfBVMHR4teRV68uPK2kGuy3TQKUesE0R
   gkDRFHJY/VZCkOkt1cjwGME6IS1kzT7bzfjThyE29lS+6jdMSRLwaChHD
   DSuhRdaFJ+d2IAa8wPh62NGFnUYyrKwutPa4PGnee2yU7sHkB1d5S8sR6
   /xK2sK0XvTYQw+/2unVfbo9t7KwHrtc7RZ8a7mTB8nV9xoAUORG3Mun3K
   G5tof8Yfb+HsdEd3VnXJkBH7EwAWjKm/Fvv5vWv7zRQBfqjjvL9T8i8CY
   g==;
X-CSE-ConnectionGUID: ghn6g9T+Swqr20dTcp3/rw==
X-CSE-MsgGUID: RJzVfGfGQxCfIEpuTM9Fxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="66870687"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="66870687"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 07:02:25 -0800
X-CSE-ConnectionGUID: jTBFCisFTR2zenyJuK5hng==
X-CSE-MsgGUID: i1CyeBCmTo+G5dsPULoKag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="217525253"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 03 Nov 2025 07:02:18 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vFw48-000QFs-1a;
	Mon, 03 Nov 2025 15:01:58 +0000
Date: Mon, 3 Nov 2025 23:01:09 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 10/16] mm: replace pmd_to_swp_entry() with
 leafent_from_pmd()
Message-ID: <202511032203.LAN8NcTM-lkp@intel.com>
References: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BDF7840017
X-Stat-Signature: z85kn8m1bysk77mxkqm8ccgc3xib9ou3
X-HE-Tag: 1762182146-935882
X-HE-Meta: U2FsdGVkX1/S5R/zlLtP9o1nBd8HNa1kP7whpybXVzoxDuSBcscokMHiG9prdeEbwvwc8qdkVLkixLttMKNeQYfYMIaluE5bvVVk0jLcmTCTD89EhwRxgezNpPVyZ0dqOuuMxmCAEJkTu+kBpI7/cEWSDsCdP3jBBRBa0/7aCMCbcXwMqt/Z2rG1kfiIoKqiD//vDmgq9UcNcRn8QqOhseCFGDac3fzq/F/gELx5UxrcVaf6Imy96OnWWdZPJA1iUxSCSHfEVHmGM6sdSxMjkuCywxbT4TCebkMhKAF9bGXOjpIW89YnsLfBZuQRjGzfW0dp5RGMBC5kamwOSeghVhmOv6bwg0vgamMcryh892mcUhYeQ1IuOrQjlUWhRcrvh1kPX4fwYGRQvyH+GVdJgSoCXLadtbazdXNCr9pr4NhcFR08pNZrLlUt0Qs61klYqnrH9ZJFgYCgF5OwHBz8tV/yGFS/d60ZxoLOj9AvzWFZDJKwYPAWtdZr43q0ohbBfAZl2/RJ3+ePtJIG/hHI86Q+0cBNax1hZGCKRzVNQrR7BbRMUBr/4yHEdByttWYUS+ojNWrx6fLLbq0fmV9vdC8Z39fRF6fD28jhWfZ5cDl46kdmnFLtpFnoXd5SmAdCMZAwxdHmskD/M/kh2f0jo2brNO5ehp2YmWFHRAotdyw09k2ZzBMdIbuIT2U63HSc9ozgxzWGrIWvS7CV6R+uKWbbN4UCGM5lUcTdLkSqrwqLhRBOVm6G86KE0fjq2ZKh+hRLLCnGkK68/aQKQJU+fXRsRUIyMgOXJ3nw+9x7LP6P52oISZq3klrNWLODynrkOf48rn7Whhl++oQiV91ryhUKfz1fKKVfvOwG9EGDpo4Ed8Bzxyhv44yOk4S6GphsvCUxnYChuRfudpK6feM0CaKgN1ZX9xzh6tK1r+HEl2oABQTW4RUshPp+oLOKh1j56JmyrE1bDGHoN1c6J8Q
 /T+PaQkm
 3O/t29Un4wex40HMKzLoIWyM22rjJ9UDfK1ga/E0UFw6UwUycz473J0LOHb1v7Hwo/0ZvdFS9OjO6AstC3f9rGI6txbyUOVUDByq8ZIBIiiU2+NcK/PF+o+xMMRCbY2PvgAvRTmioJPz+nhhwkwVR9ReIOHwlK62BMwixWPeQmWJkAyKvb52o35zmXOIZO1wA/NJJ8XRM/mf1ruM+U1SYOsCidgZE5a+vHICBmqou3JSSu/rkS3KBPW2S7wcMTpt2dh4xUs7Se20MsilvR2GwsOs7bF4Sl+svQQ2vq1HLdYaYPXjlJNdV4CzgDtz8WH5VXtJj5IAO5YRZDWsivSvfx3nEZYBkpADg1IQ2GmDFq8svSkjMbNzI+Rf1m9wDZI2pufrpS7xxw3SE5wFQ/+O0OKBZ3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-correctly-handle-UFFD-PTE-markers/20251103-204118
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 10/16] mm: replace pmd_to_swp_entry() with leafent_from_pmd()
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20251103/202511032203.LAN8NcTM-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251103/202511032203.LAN8NcTM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511032203.LAN8NcTM-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mm_inline.h:11,
                    from kernel/fork.c:46:
   include/linux/leafops.h: In function 'leafent_from_pmd':
>> include/linux/leafops.h:111:22: error: implicit declaration of function '__pmd_to_swp_entry'; did you mean 'pte_to_swp_entry'? [-Wimplicit-function-declaration]
     111 |         arch_entry = __pmd_to_swp_entry(pmd);
         |                      ^~~~~~~~~~~~~~~~~~
         |                      pte_to_swp_entry
>> include/linux/leafops.h:111:22: error: incompatible types when assigning to type 'leaf_entry_t' {aka 'swp_entry_t'} from type 'int'
--
   In file included from include/linux/leafops.h:6,
                    from include/linux/migrate.h:9,
                    from mm/folio-compat.c:7:
   include/linux/swapops.h: In function 'swp_entry':
>> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:90:28: note: in expansion of macro 'SWP_TYPE_SHIFT'
      90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
         |                            ^~~~~~~~~~~~~~
   include/linux/swapops.h:27:46: note: each undeclared identifier is reported only once for each function it appears in
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:90:28: note: in expansion of macro 'SWP_TYPE_SHIFT'
      90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
         |                            ^~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'swp_type':
>> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:100:30: note: in expansion of macro 'SWP_TYPE_SHIFT'
     100 |         return (entry.val >> SWP_TYPE_SHIFT);
         |                              ^~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'swp_offset':
>> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:28:34: note: in expansion of macro 'SWP_TYPE_SHIFT'
      28 | #define SWP_OFFSET_MASK ((1UL << SWP_TYPE_SHIFT) - 1)
         |                                  ^~~~~~~~~~~~~~
   include/linux/swapops.h:109:28: note: in expansion of macro 'SWP_OFFSET_MASK'
     109 |         return entry.val & SWP_OFFSET_MASK;
         |                            ^~~~~~~~~~~~~~~
   In file included from include/linux/bits.h:5,
                    from include/linux/ratelimit_types.h:5,
                    from include/linux/printk.h:9,
                    from include/asm-generic/bug.h:22,
                    from arch/openrisc/include/asm/bug.h:5,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from include/linux/migrate.h:5:
   include/linux/swapops.h: In function 'swp_offset_pfn':
>> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/vdso/bits.h:7:44: note: in definition of macro 'BIT'
       7 | #define BIT(nr)                 (UL(1) << (nr))
         |                                            ^~
   include/linux/minmax.h:89:9: note: in expansion of macro '__cmp_once_unique'
      89 |         __cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |         ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:161:27: note: in expansion of macro '__cmp_once'
     161 | #define min_t(type, x, y) __cmp_once(min, type, x, y)
         |                           ^~~~~~~~~~
   include/linux/swapops.h:38:33: note: in expansion of macro 'min_t'
      38 | #define SWP_PFN_BITS            min_t(int, \
         |                                 ^~~~~
   include/linux/swapops.h:40:39: note: in expansion of macro 'SWP_TYPE_SHIFT'
      40 |                                       SWP_TYPE_SHIFT)
         |                                       ^~~~~~~~~~~~~~
   include/linux/swapops.h:42:38: note: in expansion of macro 'SWP_PFN_BITS'
      42 | #define SWP_PFN_MASK            (BIT(SWP_PFN_BITS) - 1)
         |                                      ^~~~~~~~~~~~
   include/linux/swapops.h:120:36: note: in expansion of macro 'SWP_PFN_MASK'
     120 |         return swp_offset(entry) & SWP_PFN_MASK;
         |                                    ^~~~~~~~~~~~
   include/linux/swapops.h: In function 'make_pte_marker_entry':
>> include/linux/swapops.h:395:26: error: 'SWP_PTE_MARKER' undeclared (first use in this function)
     395 |         return swp_entry(SWP_PTE_MARKER, marker);
         |                          ^~~~~~~~~~~~~~
   In file included from <command-line>:
   include/linux/swapops.h: In function 'is_pfn_swap_entry':
>> include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:577:23: note: in definition of macro '__compiletime_assert'
     577 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:597:9: note: in expansion of macro '_compiletime_assert'
     597 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/swapops.h:448:9: note: in expansion of macro 'BUILD_BUG_ON'
     448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
         |         ^~~~~~~~~~~~
   include/linux/swapops.h:448:22: note: in expansion of macro 'SWP_TYPE_SHIFT'
     448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
         |                      ^~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'non_swap_entry':
   include/linux/swapops.h:491:35: error: 'MAX_SWAPFILES' undeclared (first use in this function); did you mean 'S_SWAPFILE'?
     491 |         return swp_type(entry) >= MAX_SWAPFILES;
         |                                   ^~~~~~~~~~~~~
         |                                   S_SWAPFILE
   include/linux/leafops.h: In function 'leafent_from_pmd':
>> include/linux/leafops.h:111:22: error: implicit declaration of function '__pmd_to_swp_entry'; did you mean 'pte_to_swp_entry'? [-Wimplicit-function-declaration]
     111 |         arch_entry = __pmd_to_swp_entry(pmd);
         |                      ^~~~~~~~~~~~~~~~~~
         |                      pte_to_swp_entry
>> include/linux/leafops.h:111:22: error: incompatible types when assigning to type 'leaf_entry_t' {aka 'swp_entry_t'} from type 'int'


vim +111 include/linux/leafops.h

    90	
    91	/**
    92	 * leafent_from_pmd() - Obtain a leaf entry from a PMD entry.
    93	 * @pmd: PMD entry.
    94	 *
    95	 * If @pmd is present (therefore not a leaf entry) the function returns an empty
    96	 * leaf entry. Otherwise, it returns a leaf entry.
    97	 *
    98	 * Returns: Leaf entry.
    99	 */
   100	static inline leaf_entry_t leafent_from_pmd(pmd_t pmd)
   101	{
   102		leaf_entry_t arch_entry;
   103	
   104		if (pmd_present(pmd))
   105			return leafent_mk_none();
   106	
   107		if (pmd_swp_soft_dirty(pmd))
   108			pmd = pmd_swp_clear_soft_dirty(pmd);
   109		if (pmd_swp_uffd_wp(pmd))
   110			pmd = pmd_swp_clear_uffd_wp(pmd);
 > 111		arch_entry = __pmd_to_swp_entry(pmd);
   112	
   113		/* Temporary until swp_entry_t eliminated. */
   114		return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
   115	}
   116	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

