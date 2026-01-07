Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D1CCF6C1F
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB82F6B00A4; Wed,  7 Jan 2026 04:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FC76B00A6; Wed,  7 Jan 2026 04:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8E66B00A7; Wed,  7 Jan 2026 04:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C751D6B00A4
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:47:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 677EEB6FE2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:47:08 +0000 (UTC)
X-FDA: 84304689336.06.19AD0AC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id C46E1120002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:47:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R8tPF8Sl;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767779226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waSAWphj6QEXmMzbrIfZyab2Dy1N5rz1KjnogAtKrpI=;
	b=WbUml2PvGX/wXL/uHKFvSWnPrYu56CeovnLmJHOkVULUOEYACbQvIhMrwNJz060mZfw4qn
	7r45lfC7it2dZaU0UHZkYsRG9MOvAZSBtbIHzskFJQQx/ME8jNfmsUUk48WHvzANFJkwrk
	anaziscxuVD4XD87dH/vM5wme3Jivk0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R8tPF8Sl;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767779226; a=rsa-sha256;
	cv=none;
	b=PcESahPZZAr6ofX31WeAI3uB7fivLMIe1gCjLwOwj2xexcKjV17fQaLZ2MFb9/yFUAGIwV
	S2EAFNpTD4lAGfmHMrp3voVGQv+f9YuW8VGmxB+XujWeWsps49VxGe2ZzRUUboqjchIFoL
	hoPUx/onfp9Z0v4De0EwRy/mS7Y7plE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767779226; x=1799315226;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a83o+wX7r90L4ywH9PsTkkN4tbWjpPaE9B8Y5qgLNgE=;
  b=R8tPF8Sl+F+qunaqlZaKlXrZ6mUL2JPvW+QYs73YhscQIxVcN0DJnUsS
   9Rwxxi74XCsYp9pD4LPW5uCRwETPvZCtGsdHld5kQXoUH12joFcjK+Daf
   OV+FOrbtRfhf2LJ1/dZeyWuF0vX55w8GjLby2SNrH5PDWsFt8bqblF88u
   daCxN9O6Ytwr80s5RYI2nVNReHCRmX2gWq0uVG5uV79Rxi7lBWAMUMkPA
   fdiIy00SKHs3uCxwLvS+s9NdpwYRV15wxdp4il3LlQtZKTnmXWUnonsNJ
   1YLIZG0TCF++YmjPgNLhdZZkaGmbnO/YTSyCl7DQHCX6b0AlTs2x13EMO
   w==;
X-CSE-ConnectionGUID: vdql81A/TBiRSq1kEANDfw==
X-CSE-MsgGUID: I8nmpnHJSNS9uVYYdjwi1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="69194212"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="69194212"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 01:47:04 -0800
X-CSE-ConnectionGUID: jZSHIXi8QfuiQFR7GjwoYQ==
X-CSE-MsgGUID: tChYKJK2Qp6DUXgcZ++UGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="202899201"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 07 Jan 2026 01:46:57 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdQ7y-000000001Xg-3SbX;
	Wed, 07 Jan 2026 09:46:54 +0000
Date: Wed, 7 Jan 2026 10:46:12 +0100
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
Message-ID: <202601071005.oEsmtf0J-lkp@intel.com>
References: <20260106120303.38124-3-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106120303.38124-3-lance.yang@linux.dev>
X-Stat-Signature: f55ybyemxexe6xgh4mxo4rzkmi75rx3w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C46E1120002
X-HE-Tag: 1767779225-328344
X-HE-Meta: U2FsdGVkX1++L2yjktdR7vTSMlo6UoSlJ1hEN4NgFx543af/gdy2SBkHKkq26B+X6Y2syA1wQ5dF/S2EGgCide3ukZUjF7pGHNqFjsv4Kd+VByyvblz17BO9yUu/Ceq8RcdzvQ829750Vrw1HqSsrY4UHu5w9iU5jA2gJazGtDuxMlNxwUXITYsSqHc9GxJDnmWeCQ9M9WAJPLxxffeEOv97VJIwaQgpgQzKJp2bVHmgOtlI13jU4STYrGO4ZWnFKK2jopS+Z2kLeQTO6cwaUsqM4rrm4vpXEmjKzLF1Ejd9qOIUkkI7wBxiy6Do7kam5dHVurI/RPkGo8l/GIy2DI7tpFFjcanlB66R+ZTiEivqQOJKjYOAyh/IU7gQD6B8iAHUg0R8BjOx+2yT3cRBRquZWl+qVwU/ZyJOcw8kyUikvjgaDGBrJW3vLVKqUGHLMPAvCzftu0FzeYQaFViCem8ddGf9c16VHI1ToT6r9VoiQMzDLlpWbcyl0e8Y4xfCYuno0eknqMKN3ZOtVi7tVbxCS0uVBIY8imoAoIDcVckygAAPjnKrVkEBQE7EubNUp3HDIlwR800terOg29s/nf0hYwGlZ+hdMWPB7SlIdayfGUPOH6In0Wi/fevHqptthv7nWz305zkuPjN3/ZWP998FFQz79i7BTs6Lvb49pQyJk1ozKlL/Gt+DX1FufVWPWqukbMP+onf+qWnNRTztiT+CUtLKXSEyhtb2V8yk1rchsCD0mBvNR+dYEYoioOSd9Yykcb9FWWOzcgyFjzgBz20u1awNNJCEeLwWzR7w9BpYGdafi4puAxogDJpVQEjOTYgoOaAmizdvdmu6UCwDVZi7qPjGI0nx3FC0RkxyXSFop0xsnyqKJdJWxdJ6mqkU75AIV1ri5mLNIW+R0R7//AsF64zeVE08maqs/Q7zRtXL9fTLAogrpd01tCrZJUk4Uq59EfRfs9sBtPNDYDw
 4tftTxMt
 ChZsHFUeyZ5V4rZAJG/0O7D846eI5LiuGL/5DGsXPfYnL8KbAFQgWiSBFk/faxDkHkfbuN3EnNr5FOwhX5OuX7ERZNzbrltkgC6fRZmAybsKhyg+AgxUYJHuhDY/2BlT/DrryKmw71OcZdkNYB6/llEuYGWxBcz/sRsM8SNCbIsbQ4Xi4CkWvoDF0WUWNfSbtggJi883yh+LqwGqb/xBYIIawcCxn8Kl4Ey/vuaawRxz6L/NtTPW2dylxxwY3XeaL9EBbbyTVxU2yTcVsVmSsxmWOMrNLs6ngkf0pfSJfmmkF3R+D4EwgSft/6U2iLAhDqecFqcRC5t+z9PnRWhk1Ah5oRkj+wCTViCqh+AGxUuJEkYrjWfKMPjH2zNLgjzg7xh2lebPu9B4ThbU=
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
[cannot apply to tip/x86/core tip/x86/mm arnd-asm-generic/master linus/master v6.19-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lance-Yang/mm-tlb-skip-redundant-IPI-when-TLB-flush-already-synchronized/20260106-200505
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260106120303.38124-3-lance.yang%40linux.dev
patch subject: [PATCH RESEND v3 2/2] mm: introduce pmdp_collapse_flush_sync() to skip redundant IPI
config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260107/202601071005.oEsmtf0J-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260107/202601071005.oEsmtf0J-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601071005.oEsmtf0J-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/khugepaged.c: In function 'collapse_huge_page':
>> mm/khugepaged.c:1180:16: error: implicit declaration of function 'pmdp_collapse_flush_sync'; did you mean 'pmdp_collapse_flush'? [-Wimplicit-function-declaration]
    1180 |         _pmd = pmdp_collapse_flush_sync(vma, address, pmd);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~
         |                pmdp_collapse_flush


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

