Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B459CD5854
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA27D6B0092; Wed,  7 Jan 2026 05:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FF66B0093; Wed,  7 Jan 2026 05:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E626B0095; Wed,  7 Jan 2026 05:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 936E46B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:53:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18E5F579D2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:53:10 +0000 (UTC)
X-FDA: 84304855740.27.23B608F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F04640006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:53:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=njq1kpJ5;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767783188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fQS0X5pRywCsQ9jVQ1vJTIle8dfFf0HfqJEEe5XfWY=;
	b=3/Tj8Xh5+PJCzrKNayoFyjx42ivCXwS+U5t/kac0CYx2RoDSHrHlijpblL9U6WTtJ4SI/W
	R4nM0asKLyOkJ0NJvmBqx/kHe9+SsRm7uc+cxnvwYQEYL9Qo6mVqnHyuGW9cwKDehX10Dn
	HjYEtG0s1qC1FpQhc1TuZeCIb+TSWSo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=njq1kpJ5;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767783188; a=rsa-sha256;
	cv=none;
	b=NtU2P+Gd7UX/ZFlOh4SS3YXLHWoE9JS4IadmvEWTfs/4ftwDinrcNXZ4KgVffa4Unnk2GU
	l1s/ujaxIviRGfPDygH8EDakfWgwmd4rck0DfSFGBLFsNSwVG83HB7qC0XpYPMqxx3PwXr
	a5ZZFbWvQBn99NSU57Orac+Qn73Ycy4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767783188; x=1799319188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BvZSuaPuz2QWKv/uboQwgBkx7RyykGPhhK/HVoD4tqg=;
  b=njq1kpJ5knvYDP8+1JowZMc0WFEH/bQm6hzp7EPstFTUHSTdALnyrpo3
   DZsv97+BMDhM3/L3pcWpVEOcBragBRAqTAB0shOWnwECMgWaXEUXQgaZB
   YOf0xDW2aI3Mdhlgj9gqvKA3ZEy9ZqywqRphSchWH/lg2DXYHPayK6x25
   /r4/ykzSYvr+/lSoPmRM5DosguXrAFujl79O9z//BNLlRpqRTWa5W5qkh
   a8d8IzDuUEynYZCDGn4so4H/qmYs41sVDXWz3qCw5ebh9SHaad4BPuVGI
   obOLg1crE+DhmVx/ikHjUYeiDn0zPMhnWvHFooKmRrrmcnemxIyxW1igi
   A==;
X-CSE-ConnectionGUID: Ib13Rtw4QUi+4a5zgz+OtQ==
X-CSE-MsgGUID: D74DPazeSGOYelRl8cSMUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="79453588"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="79453588"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 02:53:05 -0800
X-CSE-ConnectionGUID: JsXEonzOQh62h1mxBhnXIw==
X-CSE-MsgGUID: 0ONkis6wRYa2MhyUp6gCWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="207426387"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 07 Jan 2026 02:52:58 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdR9s-000000001Zc-0pw1;
	Wed, 07 Jan 2026 10:52:56 +0000
Date: Wed, 7 Jan 2026 11:52:43 +0100
From: kernel test robot <lkp@intel.com>
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, will@kernel.org,
	aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	ioworker0@gmail.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH RESEND v3 2/2] mm: introduce pmdp_collapse_flush_sync()
 to skip redundant IPI
Message-ID: <202601071153.9k8Fm05X-lkp@intel.com>
References: <20260106120303.38124-3-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106120303.38124-3-lance.yang@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0F04640006
X-Stat-Signature: nunj4wt78b6qau1emqqazpjrochx1cbd
X-Rspam-User: 
X-HE-Tag: 1767783186-202572
X-HE-Meta: U2FsdGVkX1+N5AA8X1RPumWmmVUJ7d5IvtwZBTZlrwpw4w9vBYji1XJinGkhWWL7hsB9ZE3i8hkyeirsFXX5bfQseQ5HMBgXkmbcs4QSV2mZfBBQDc/JXxih/7Cw7JKJxmhz1BEN4H4Xnubs8Trwx9pIUGZvOn8dm4gFNs/EKB7sFu/FhmujEOEmqSxY7ALlHJSAGXRIQxfPgYFiiKq9Z1JqvO4JYQJvW1Yayp3CeEpdSFFWAwNnYBNOUNcHSX1FwvsZRicIToXsPI+eeIOxW5N3hAH1+8xCLvDSrEExLPieX8X3rb6gn9otRi+ucldyfl8enujx/ClYcGRGZEq0gjGdSYC9nA4tLW3xY0FbdkZCp1dCr8CmkBqqqAvOWGqTT5aIQEdJsIZ7MLj++MffZzUz1Y4Ns73XU9ZkGnyWefl53ceyj0SiqpZKX7QEyYO6Nfs+/TdNH1RME4RIWvCcIZA4wOP+MTr8O5z5aGIhXxNfYYkM1XecR3u2XAHcEPlrvJUjNnwN6LhpZHDesqb3jeDOgErrtsunmJr41MRydh/NimAgQsLYMT9ac4mkNVkAhYfU4Kzv+X+8u5dPrp/pRYt3TUWueKn0+VjOhs5kSb8gHIeG+/pJjipiFYdHRcHmN0arFdQnirfbQGxaMVZhl4TnQxZOAYd1/bDbn7x7TgKgcp4jkuDvKDMB98P8bbDkJTn9Wu+UvcXt62ihjcYdruTohQ0raaK8iMrBFWDRKtrCSIEDGh82qpfzPiNEip9spdRJPjAcpPUn8uJ/N9tJrfQFSAlmPndTAgjueBZDYXjmPCF+Ryo6AzmWb07wiG0iOIvMsXfyNrDUBBKV1aKZ/bY9SF0JGKHVZOJ5nZJsMRexKSZc2ZiFtJfUaErSYB5xDNnSIboSvRC+FFcR2SLp4I/aBc4743/3i5+oiHXY+kXhQxQTuqnhQfI7R1V8xV8JoZ01AJrKYTkQcKo+yDo
 TEV54tFH
 tMNO5cjUTg3Hy/+kWz/DfmBoRjEWdM3nfKTR46lsf9uCqSqIxwDDgW7Q2ogHWtamIlHLl4PXi7NG0n0LPR/OED56GK7wBuBSKSqvlqmbez5+FbdV0UFakr0mCdLeWO4hyyNX8Bb+eZvlR7vKVcSDKWGQW1I9f9UOLQGQndnUerTB84AY8Hkrc+8JOuf2xoKIgP3JluzSrXX9v8rjZ8s83c7sZijYYDhViKtZw7qk1I2+64gKdWdGNpYoeZ5RnaN/uSIyOqunHTBPCa8q/W2gyQIAPFZoNlvRspMNm2UNZa19fUqbUIy89SCfdTTrAsoQ960nJsjrKbiXwtUGy25iJgtlfbG3Ho9Z/2zgPMr4Ct/GuYO9OD996sYwT29PvEsRbDyxG2H/+aAGrJAb9DHTZByiBbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20260107]
[cannot apply to tip/x86/core tip/x86/mm linus/master v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lance-Yang/mm-tlb-skip-redundant-IPI-when-TLB-flush-already-synchronized/20260106-200505
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260106120303.38124-3-lance.yang%40linux.dev
patch subject: [PATCH RESEND v3 2/2] mm: introduce pmdp_collapse_flush_sync() to skip redundant IPI
config: riscv-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260107/202601071153.9k8Fm05X-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260107/202601071153.9k8Fm05X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601071153.9k8Fm05X-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/khugepaged.c: In function 'collapse_huge_page':
   mm/khugepaged.c:1180:16: error: implicit declaration of function 'pmdp_collapse_flush_sync'; did you mean 'pmdp_collapse_flush'? [-Wimplicit-function-declaration]
    1180 |         _pmd = pmdp_collapse_flush_sync(vma, address, pmd);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~
         |                pmdp_collapse_flush
>> mm/khugepaged.c:1180:16: error: incompatible types when assigning to type 'pmd_t' from type 'int'
   mm/khugepaged.c: In function 'try_collapse_pte_mapped_thp':
   mm/khugepaged.c:1665:19: error: incompatible types when assigning to type 'pmd_t' from type 'int'
    1665 |         pgt_pmd = pmdp_collapse_flush_sync(vma, haddr, pmd);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/khugepaged.c: In function 'retract_page_tables':
   mm/khugepaged.c:1818:35: error: incompatible types when assigning to type 'pmd_t' from type 'int'
    1818 |                         pgt_pmd = pmdp_collapse_flush_sync(vma, addr, pmd);
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~


vim +1180 mm/khugepaged.c

  1092	
  1093	static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
  1094						   int referenced, int unmapped,
  1095						   struct collapse_control *cc)
  1096	{
  1097		LIST_HEAD(compound_pagelist);
  1098		pmd_t *pmd, _pmd;
  1099		pte_t *pte;
  1100		pgtable_t pgtable;
  1101		struct folio *folio;
  1102		spinlock_t *pmd_ptl, *pte_ptl;
  1103		enum scan_result result = SCAN_FAIL;
  1104		struct vm_area_struct *vma;
  1105		struct mmu_notifier_range range;
  1106	
  1107		VM_BUG_ON(address & ~HPAGE_PMD_MASK);
  1108	
  1109		/*
  1110		 * Before allocating the hugepage, release the mmap_lock read lock.
  1111		 * The allocation can take potentially a long time if it involves
  1112		 * sync compaction, and we do not need to hold the mmap_lock during
  1113		 * that. We will recheck the vma after taking it again in write mode.
  1114		 */
  1115		mmap_read_unlock(mm);
  1116	
  1117		result = alloc_charge_folio(&folio, mm, cc);
  1118		if (result != SCAN_SUCCEED)
  1119			goto out_nolock;
  1120	
  1121		mmap_read_lock(mm);
  1122		result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
  1123		if (result != SCAN_SUCCEED) {
  1124			mmap_read_unlock(mm);
  1125			goto out_nolock;
  1126		}
  1127	
  1128		result = find_pmd_or_thp_or_none(mm, address, &pmd);
  1129		if (result != SCAN_SUCCEED) {
  1130			mmap_read_unlock(mm);
  1131			goto out_nolock;
  1132		}
  1133	
  1134		if (unmapped) {
  1135			/*
  1136			 * __collapse_huge_page_swapin will return with mmap_lock
  1137			 * released when it fails. So we jump out_nolock directly in
  1138			 * that case.  Continuing to collapse causes inconsistency.
  1139			 */
  1140			result = __collapse_huge_page_swapin(mm, vma, address, pmd,
  1141							     referenced);
  1142			if (result != SCAN_SUCCEED)
  1143				goto out_nolock;
  1144		}
  1145	
  1146		mmap_read_unlock(mm);
  1147		/*
  1148		 * Prevent all access to pagetables with the exception of
  1149		 * gup_fast later handled by the ptep_clear_flush and the VM
  1150		 * handled by the anon_vma lock + PG_lock.
  1151		 *
  1152		 * UFFDIO_MOVE is prevented to race as well thanks to the
  1153		 * mmap_lock.
  1154		 */
  1155		mmap_write_lock(mm);
  1156		result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
  1157		if (result != SCAN_SUCCEED)
  1158			goto out_up_write;
  1159		/* check if the pmd is still valid */
  1160		vma_start_write(vma);
  1161		result = check_pmd_still_valid(mm, address, pmd);
  1162		if (result != SCAN_SUCCEED)
  1163			goto out_up_write;
  1164	
  1165		anon_vma_lock_write(vma->anon_vma);
  1166	
  1167		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
  1168					address + HPAGE_PMD_SIZE);
  1169		mmu_notifier_invalidate_range_start(&range);
  1170	
  1171		pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
  1172		/*
  1173		 * This removes any huge TLB entry from the CPU so we won't allow
  1174		 * huge and small TLB entries for the same virtual address to
  1175		 * avoid the risk of CPU bugs in that area.
  1176		 *
  1177		 * Parallel GUP-fast is fine since GUP-fast will back off when
  1178		 * it detects PMD is changed.
  1179		 */
> 1180		_pmd = pmdp_collapse_flush_sync(vma, address, pmd);
  1181		spin_unlock(pmd_ptl);
  1182		mmu_notifier_invalidate_range_end(&range);
  1183	
  1184		pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
  1185		if (pte) {
  1186			result = __collapse_huge_page_isolate(vma, address, pte, cc,
  1187							      &compound_pagelist);
  1188			spin_unlock(pte_ptl);
  1189		} else {
  1190			result = SCAN_NO_PTE_TABLE;
  1191		}
  1192	
  1193		if (unlikely(result != SCAN_SUCCEED)) {
  1194			if (pte)
  1195				pte_unmap(pte);
  1196			spin_lock(pmd_ptl);
  1197			BUG_ON(!pmd_none(*pmd));
  1198			/*
  1199			 * We can only use set_pmd_at when establishing
  1200			 * hugepmds and never for establishing regular pmds that
  1201			 * points to regular pagetables. Use pmd_populate for that
  1202			 */
  1203			pmd_populate(mm, pmd, pmd_pgtable(_pmd));
  1204			spin_unlock(pmd_ptl);
  1205			anon_vma_unlock_write(vma->anon_vma);
  1206			goto out_up_write;
  1207		}
  1208	
  1209		/*
  1210		 * All pages are isolated and locked so anon_vma rmap
  1211		 * can't run anymore.
  1212		 */
  1213		anon_vma_unlock_write(vma->anon_vma);
  1214	
  1215		result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
  1216						   vma, address, pte_ptl,
  1217						   &compound_pagelist);
  1218		pte_unmap(pte);
  1219		if (unlikely(result != SCAN_SUCCEED))
  1220			goto out_up_write;
  1221	
  1222		/*
  1223		 * The smp_wmb() inside __folio_mark_uptodate() ensures the
  1224		 * copy_huge_page writes become visible before the set_pmd_at()
  1225		 * write.
  1226		 */
  1227		__folio_mark_uptodate(folio);
  1228		pgtable = pmd_pgtable(_pmd);
  1229	
  1230		spin_lock(pmd_ptl);
  1231		BUG_ON(!pmd_none(*pmd));
  1232		pgtable_trans_huge_deposit(mm, pmd, pgtable);
  1233		map_anon_folio_pmd_nopf(folio, pmd, vma, address);
  1234		spin_unlock(pmd_ptl);
  1235	
  1236		folio = NULL;
  1237	
  1238		result = SCAN_SUCCEED;
  1239	out_up_write:
  1240		mmap_write_unlock(mm);
  1241	out_nolock:
  1242		if (folio)
  1243			folio_put(folio);
  1244		trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
  1245		return result;
  1246	}
  1247	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

