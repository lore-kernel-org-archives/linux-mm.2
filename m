Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792AEC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 10:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E456B008A; Thu, 31 Jul 2025 06:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F436B008C; Thu, 31 Jul 2025 06:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E3E6B0092; Thu, 31 Jul 2025 06:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E587B6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:04:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F64C8087C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:04:39 +0000 (UTC)
X-FDA: 83724125478.27.128188C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id EB695180011
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:04:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HeGuNe9W;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753956277; a=rsa-sha256;
	cv=none;
	b=O3dmI4JZfprwdRJeOsTs9503LpSg4Qj/fLHdA+3WzTe8uHRp0jlnSVcsSQYDpEGaFwj7sf
	YbJU4o5Cxtf8+WeZMXphbe2SOribwWE9CpQFTVCZFPAc6ZDPO+wgPY/7ee4TiM3eRrxw4O
	XXqTXF3Zyw9kllfceKZj5hcSJw48U+o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HeGuNe9W;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753956277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYIYDKE7YjdKcHoQ/rqt6bnOC6iezVempkuuGY16b/o=;
	b=Yh1qG+bgRt9C5tqUYWoDQBOJMoe+bEzkf/eTaliFL0LM/G2baIh0HgjVtfyd4r4zUFly12
	SOSl7/tzrrCpyiSoCLzr7nYMBnzk8es3DaW9VB0/THoM009hUSg6FfY8kVjLCTSnYtUQAv
	tQ9FROZTWo/K9fxeRK8dlL11BQzj0K4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753956277; x=1785492277;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6+ao0BB2eP9Lbd+emGj1G640tLXJbZdN7LjBCYC17sI=;
  b=HeGuNe9WK66PN5Tuqlpc5mSYpCvPIrpThgz26d8pkEj2gFyIWgrrCwnc
   s6gUtKVtFyEFyivRSY+gflOszfRWQJFC2qYOhQMOYeBdf1mBF1SlfK/9a
   AS7m05T5ZSuR3l4LK+ggGFDQV327TEgnkCEfVVCze7kaFed69sc+3tong
   vHy8gfrK/KUkUuf0taLiggaro17p+RUX8qudHzCGA1rKQz0noafj8xmSM
   ikaHGxnwpXkb8QsGBpvuJmqcUO4B9Ah6jQ5VBT//tbivKVuCYXZts1w+s
   4hzMfKb2Y8znU5YjVwJvQ5xXAmyau9BxDLYatZdED1Tat38KmWK4cgSYx
   A==;
X-CSE-ConnectionGUID: 2TcPyhJDQ2ukh7D23IDabQ==
X-CSE-MsgGUID: L32m6t1UTOSHidBcWBozRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="60098339"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="60098339"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 03:04:35 -0700
X-CSE-ConnectionGUID: /YULmVUrS1OPxbNT2GS1mg==
X-CSE-MsgGUID: b+5Hrj5WR82NXclqcajgyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="167398722"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 31 Jul 2025 03:04:29 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhQ9D-0003ds-23;
	Thu, 31 Jul 2025 10:04:27 +0000
Date: Thu, 31 Jul 2025 18:04:07 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v2 07/11] mm/thp: add split during migration support
Message-ID: <202507311724.mavZerV1-lkp@intel.com>
References: <20250730092139.3890844-8-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730092139.3890844-8-balbirs@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB695180011
X-Stat-Signature: xfipj1dbrynjrs9j9n4jd4ydp3k361q3
X-HE-Tag: 1753956276-241695
X-HE-Meta: U2FsdGVkX18t3gQE6ZpQbeV7+laSs/8aufHRXjBITOlgwseVH6EPYTvYWvMxs4+2hKrhwfCU/kBV24DIYU5q+wc+QVNIrZfeuNKTvCa9y2I7ThvRpVLd9eTRxmO9EwKKwv6Vo9OQlC22WPJADBQd2k0Wrm+mC/M3qKGeVPX7e9/hfL/M+00XRtSCGbrflxkR9wLc9a2Rwnd5spikftMU+EfWZrmXQ0K6WO5Ootd1GrCWm+a3dof9uKHuthHQHqoPwIUAsM3vAihuxIR+sgnN+hc2VK9VofLJDaEaMkIIYH+CC9b0olgsNVU7OpMW0FeXDYhgK300lru6LxjVM5cTGtuUMZ8wYbm2jwoMLHrpB64Vf7zabpbcPWayVFBQxbuf/AdZ2oY8C6+SYTkYyMX75/eGzu6l7LsTDeKfSJwcvSIV7Y5Bp4mhWqN4UjHNztuwDn8h+OTCD2npy8iimow0IHKgVr2iWv1ofVBBhlgAv5wQYVhAKsM/KiXhTnIF+Xw4yqew2EMrNRqcDNX8prWSPDKT7SCAgjWVprUF4e6Gi/Df43B2rYCJpItqC8nRxlxs8CeoD4Hz3OJ41u6u7g/BO0pCytwYX73sReWfDzIEUecBhFywtlGOrjteiMyO3MluCOiol2gNDT3hTVQR/cWM0XltnNcPuNXv2i/KRd5rtf6ZIGyMR3RIbrtlBsUwI/dUyVsLVAMyQU2Wz0O53Of/Q8rDCD71P5qSbaxa2OIHYj2oiySqcy4pUnoZlRm6p/Nf6B3RzeL/uINUpRpUvXCsrtMmOWZifygCDDvutUhWdSTt5U+sPtGJdptmUBH4czCOBU95o3vvBoOaBtuyaSLUS46FQWiAaennSmMDPYw72/kzp1hKLDZyCvuf8UM2EWan5jd4ME9bVjwlfVe7jeAP2nPEwSBAulwkocmPr6po5rlyp8ph4w0OwaMWu8a7111HMtYZseFHpFB+2f7hShV
 ICzxUEfX
 oBb49OPqZQ3FcqLfuzibWvmnD6QUM3RHCbd6USoDwx3TknhWVLkG8gJmGnOK1XGeBF0owTqy7R9sZNPn6yKoo3relxhZ1AUnIzA8CPQoF6YdVZPlbgAmATcWrqtPcElU1MH/zaezOqtyP4RPeWhgZXwTpVn8l7xvU3OrxN6bJfUT8FSkVAVRKL2PRNwYkZLba+ENuFodzv+wTsm7U0j8ePi5AA/Ptau2agw+//hWS41GGJBoFgMQknhMi8FItbLSxzAWQkBvvCHKJAS+5HpCXW6Piho6W4ELO9pKFKmaWUgY2OsNDVAYVnPA5kCEu/yGSdcrwKQGwxw+StKq4HDiU5bh/vJPl0KQxAKHlAxrZOR2xAM6CUTrjmOPsdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20250731]
[cannot apply to akpm-mm/mm-nonmm-unstable shuah-kselftest/next shuah-kselftest/fixes linus/master v6.16]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-zone_device-support-large-zone-device-private-folios/20250730-172600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250730092139.3890844-8-balbirs%40nvidia.com
patch subject: [v2 07/11] mm/thp: add split during migration support
config: x86_64-randconfig-071-20250731 (https://download.01.org/0day-ci/archive/20250731/202507311724.mavZerV1-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507311724.mavZerV1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507311724.mavZerV1-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/migrate_device.c:1082:5: error: statement requires expression of scalar type ('void' invalid)
    1082 |                                 if (migrate_vma_split_pages(migrate, i, addr,
         |                                 ^   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1083 |                                                                 folio)) {
         |                                                                 ~~~~~~
   1 error generated.


vim +1082 mm/migrate_device.c

   999	
  1000	static void __migrate_device_pages(unsigned long *src_pfns,
  1001					unsigned long *dst_pfns, unsigned long npages,
  1002					struct migrate_vma *migrate)
  1003	{
  1004		struct mmu_notifier_range range;
  1005		unsigned long i, j;
  1006		bool notified = false;
  1007		unsigned long addr;
  1008	
  1009		for (i = 0; i < npages; ) {
  1010			struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
  1011			struct page *page = migrate_pfn_to_page(src_pfns[i]);
  1012			struct address_space *mapping;
  1013			struct folio *newfolio, *folio;
  1014			int r, extra_cnt = 0;
  1015			unsigned long nr = 1;
  1016	
  1017			if (!newpage) {
  1018				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
  1019				goto next;
  1020			}
  1021	
  1022			if (!page) {
  1023				unsigned long addr;
  1024	
  1025				if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE))
  1026					goto next;
  1027	
  1028				/*
  1029				 * The only time there is no vma is when called from
  1030				 * migrate_device_coherent_folio(). However this isn't
  1031				 * called if the page could not be unmapped.
  1032				 */
  1033				VM_BUG_ON(!migrate);
  1034				addr = migrate->start + i*PAGE_SIZE;
  1035				if (!notified) {
  1036					notified = true;
  1037	
  1038					mmu_notifier_range_init_owner(&range,
  1039						MMU_NOTIFY_MIGRATE, 0,
  1040						migrate->vma->vm_mm, addr, migrate->end,
  1041						migrate->pgmap_owner);
  1042					mmu_notifier_invalidate_range_start(&range);
  1043				}
  1044	
  1045				if ((src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
  1046					(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
  1047					nr = HPAGE_PMD_NR;
  1048					src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
  1049				} else {
  1050					nr = 1;
  1051				}
  1052	
  1053				for (j = 0; j < nr && i + j < npages; j++) {
  1054					src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
  1055					migrate_vma_insert_page(migrate,
  1056						addr + j * PAGE_SIZE,
  1057						&dst_pfns[i+j], &src_pfns[i+j]);
  1058				}
  1059				goto next;
  1060			}
  1061	
  1062			newfolio = page_folio(newpage);
  1063			folio = page_folio(page);
  1064			mapping = folio_mapping(folio);
  1065	
  1066			/*
  1067			 * If THP migration is enabled, check if both src and dst
  1068			 * can migrate large pages
  1069			 */
  1070			if (thp_migration_supported()) {
  1071				if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
  1072					(src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
  1073					!(dst_pfns[i] & MIGRATE_PFN_COMPOUND)) {
  1074	
  1075					if (!migrate) {
  1076						src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
  1077								 MIGRATE_PFN_COMPOUND);
  1078						goto next;
  1079					}
  1080					nr = 1 << folio_order(folio);
  1081					addr = migrate->start + i * PAGE_SIZE;
> 1082					if (migrate_vma_split_pages(migrate, i, addr,
  1083									folio)) {
  1084						src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
  1085								 MIGRATE_PFN_COMPOUND);
  1086						goto next;
  1087					}
  1088				} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
  1089					(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
  1090					!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
  1091					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
  1092				}
  1093			}
  1094	
  1095	
  1096			if (folio_is_device_private(newfolio) ||
  1097			    folio_is_device_coherent(newfolio)) {
  1098				if (mapping) {
  1099					/*
  1100					 * For now only support anonymous memory migrating to
  1101					 * device private or coherent memory.
  1102					 *
  1103					 * Try to get rid of swap cache if possible.
  1104					 */
  1105					if (!folio_test_anon(folio) ||
  1106					    !folio_free_swap(folio)) {
  1107						src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
  1108						goto next;
  1109					}
  1110				}
  1111			} else if (folio_is_zone_device(newfolio)) {
  1112				/*
  1113				 * Other types of ZONE_DEVICE page are not supported.
  1114				 */
  1115				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
  1116				goto next;
  1117			}
  1118	
  1119			BUG_ON(folio_test_writeback(folio));
  1120	
  1121			if (migrate && migrate->fault_page == page)
  1122				extra_cnt++;
  1123			for (j = 0; j < nr && i + j < npages; j++) {
  1124				folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
  1125				newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
  1126	
  1127				r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
  1128				if (r != MIGRATEPAGE_SUCCESS)
  1129					src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
  1130				else
  1131					folio_migrate_flags(newfolio, folio);
  1132			}
  1133	next:
  1134			i += nr;
  1135		}
  1136	
  1137		if (notified)
  1138			mmu_notifier_invalidate_range_end(&range);
  1139	}
  1140	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

