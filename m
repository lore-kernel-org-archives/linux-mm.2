Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDFFFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5814C6B0093; Thu, 30 Apr 2026 08:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532356B0095; Thu, 30 Apr 2026 08:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421266B0096; Thu, 30 Apr 2026 08:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC596B0093
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:12:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2170B8980E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:12:31 +0000 (UTC)
X-FDA: 84715110102.24.E0DE875
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A96C1C0015
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:12:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RBwqGcS2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777551149; a=rsa-sha256;
	cv=none;
	b=BU431kw4VHKcJv3QT3qZMCpLqYtRNj1s3fxbShceExfrFq5OQPCPsQt3xZ60ML4YAODkgm
	7op1lc9KX5XCkBrW30wVSBbno5+1fGFEgo+iZwrAJ+6bbf2qs2nnAVHYAwmoPJQ8PgLOn0
	w4dyDPamzDicEGGb7QdmCWZAzDMqVS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RBwqGcS2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777551149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SK7bgVXN584vmXcFdOlyz7SlnNkF9IliRB/aPh+PkM8=;
	b=S3NrR9yFLhJur40FfA6ofShKhwFPpipwVd+gQXQzbj23zUAOQR48qoDreQ9xzzxB5hybG0
	P3oyCGTJD/yl7iRjBwMs+W+oYe9Hm/tj9DHs/36ackGEoygp1irVdzspGQhYrvFiJuz3cU
	RnLHAAgxd5dWtQedesdeLCFnNupymMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777551148; x=1809087148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=egPFU7xhA88lBAq519bT9HYe8a4c+pVY/6MihkNd9Ls=;
  b=RBwqGcS2Np7Z8qrvlrwfBY9vuJWxvpdIfaUQqyzTHNK7nTYO4nbdGyYz
   ZBwqkQwmgkXwa1NdBIXyVSTi0p1obfTlZbdSOPnd6D4DxiXIeJyPMWpeM
   FIHlW5pYvRBnYSf1txamIJthlzN5CkWyvla0YTSmDMjkyx60eJF39eX3y
   cSxerqspYC86WkEIgrJY8+OCAJ5mB8O1/J+7K4XVkgyY0cQDGv6IL4BGt
   WG/yk1M/k/Dvqmk8l704tVGxfuiXflHJ3TM2XBqb10iEIuZqNapXGcvnc
   CUX1kCKKzVU0CvolqhbLgda9GAn1cpGa+mwxxwMqa6MbNtZUd4mxQSZvw
   Q==;
X-CSE-ConnectionGUID: G4zYzCJoRQGS4vEqxKMAPg==
X-CSE-MsgGUID: PAdAkE94RnGMoVZ5I703xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="77664026"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77664026"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 05:12:27 -0700
X-CSE-ConnectionGUID: ZxgXd7DlSKCSNgbVzm2Psg==
X-CSE-MsgGUID: u0hvwTPbSL+4imX9slDRJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="258143800"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Apr 2026 05:12:23 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIQFg-00000000CNY-3Cyc;
	Thu, 30 Apr 2026 12:12:20 +0000
Date: Thu, 30 Apr 2026 20:11:21 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
Message-ID: <202604302041.gNPhRRxL-lkp@intel.com>
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427052000.196402-1-agordeev@linux.ibm.com>
X-Stat-Signature: iki3yitaf1pjpwqtew5kcmoxdtiojazr
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A96C1C0015
X-Rspamd-Server: rspam07
X-HE-Tag: 1777551147-278936
X-HE-Meta: U2FsdGVkX1+QHCUbRqVNAEUBpSBlQohGnDN6ilqT1uaqJC73/gZtTxqZWoE1jysYTep0D7hg1uQtLfdquiF4SJTxMZSaWtFsEGP5ohtsg/CdhMd71t4BXbOMYVZula2YyecIagKLv+7Bu9GnffCIn96Q07HJHqFGOi6jvPEXhygb+dn9MJOOD7OIw3k2NCDi+c+VMm9ZxqeGtgC016oRlELOZSZQm/g66LU0axflfeHx2NmdmaF5A7A9nR78Yj5LQh5SxdvSLTw8QLnSzU8Prw2u9/ZZyUzTvBLrPwkjcD8sPkX5Y0GgE3GBlKMZWJJbyHHnRcUvW9lKBnfNR25V/9iSXFT+Wl+3OzV2bI8aGGUVrDDO6UmjunoxOfscgIwmPfI/mNUPcfycjbFRcl7I2/Tyg113zi+wjP7M8a1c1MXRikDtVT0Ldx7HrH5OZdKOwpm6mVyrT9BQrI7pXWb7SdznPWSxsy5u6iZ0LzIi81DncH3mdo6jYEtLAuuCW7boDiZRWbQMfjuzj4yOCkzDcYvu1tcKlET/qOhvJ3VsLlJlvPXPUKszte73nigVyUk40TxpI//KJhqeVCCn2mHc3YlWXB5/eATD7zZzbiprN8p+aYpD50XqtomvwYP+j+Pa1HV33eK+sBkASAw/IRZDDrwVHtVfsCNKDdEifeI6mBlSxxmiz4OwH1hN5c3mh+cl2p3GreCfAvSVCpOWK4M+H5Kt4rN2MIJ+zgNxDnUNiFgieI97KnNQ1XifCsVI/KOiOw7s7ZEwBb/L1NwKi4o/DKpI2xTtc+g9tns0kfTw1g7PkpBGQlTsfvHCH+KKqSzHybzbLwIElVOHDTwpb+JVBdgjuicJEiWyWwHp+wvnjF0eUOfDkXirSSAjUKKMfkiv0HEcAZ65lTAzZLqcGXcIywSvrj4Yd0HTx2GLG90CZbXOkgbUnIlCFv+1dFxTklnNNPqMG/TGZ8Bi80CVP9L
 l2y+WO04
 FdlxUyMcrq3HPS9IKcVc1++tsBeDc0BdF/U3KYZ/UWikYOkqHRkDXSfg9NFi6dUXWzRJUU+4YhrD0+3VDQ4ONM4z4rxBXyndVfushLNX5G8k7ELG4w+nIr0JXbiuNQxiL/AWP3oA+EjaP2oK3bbA9uetfAIJ0gYWyotbVyuMCokksAMC1Xnw4wDB9HhOQ5CsSpBFX8SuX4E++y1oByJ8UqHmhcY679rPCc8/Op2QDqiKyNP0RFB8erPEqP/1EkIqsqJBwg7vHEZgK4qVIGLSQuHGyk0A4c8lDGTC3HYqIcT+W+1y/4HKLTIZo7EXtuaLYkiEpi8EGHmV95j/siYwTnQMrGpKEBTG6IR/Y4KNnqcB3fke+kIRndy5fmhvqucPdIOeviBRfphr4oSPkwjM4iRVbzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Gordeev/mm-page_vma_mapped_walk-add-missing-pgtable-entry-accessors/20260429-030409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260427052000.196402-1-agordeev%40linux.ibm.com
patch subject: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry accessors
config: arm-defconfig (https://download.01.org/0day-ci/archive/20260430/202604302041.gNPhRRxL-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604302041.gNPhRRxL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604302041.gNPhRRxL-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: use of undeclared identifier 'pgdp'; did you mean 'pgd'?
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:36: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   mm/page_vma_mapped.c:186:9: note: 'pgd' declared here
     186 |         pgd_t *pgd;
         |                ^
>> mm/page_vma_mapped.c:222:20: error: passing 'const volatile pmdval_t *' (aka 'const volatile unsigned int *') to parameter of type 'pmdval_t *' (aka 'unsigned int *') discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:25: note: expanded from macro 'pgdp_get'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                 ^~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:47:28: note: expanded from macro 'READ_ONCE'
      47 | #define READ_ONCE(x)                                                    \
         |                                                                         ^
      48 | ({                                                                      \
         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      50 |         __READ_ONCE(x);                                                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      51 | })
         | ~~
   include/asm-generic/pgtable-nop4d.h:23:37: note: passing argument to parameter 'pgd' here
      23 | static inline int pgd_present(pgd_t pgd)        { return 1; }
         |                                     ^
   8 errors generated.


vim +222 mm/page_vma_mapped.c

   155	
   156	/**
   157	 * page_vma_mapped_walk - check if @pvmw->pfn is mapped in @pvmw->vma at
   158	 * @pvmw->address
   159	 * @pvmw: pointer to struct page_vma_mapped_walk. page, vma, address and flags
   160	 * must be set. pmd, pte and ptl must be NULL.
   161	 *
   162	 * Returns true if the page is mapped in the vma. @pvmw->pmd and @pvmw->pte point
   163	 * to relevant page table entries. @pvmw->ptl is locked. @pvmw->address is
   164	 * adjusted if needed (for PTE-mapped THPs).
   165	 *
   166	 * If @pvmw->pmd is set but @pvmw->pte is not, you have found PMD-mapped page
   167	 * (usually THP). For PTE-mapped THP, you should run page_vma_mapped_walk() in
   168	 * a loop to find all PTEs that map the THP.
   169	 *
   170	 * For HugeTLB pages, @pvmw->pte is set to the relevant page table entry
   171	 * regardless of which page table level the page is mapped at. @pvmw->pmd is
   172	 * NULL.
   173	 *
   174	 * Returns false if there are no more page table entries for the page in
   175	 * the vma. @pvmw->ptl is unlocked and @pvmw->pte is unmapped.
   176	 *
   177	 * If you need to stop the walk before page_vma_mapped_walk() returned false,
   178	 * use page_vma_mapped_walk_done(). It will do the housekeeping.
   179	 */
   180	bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
   181	{
   182		struct vm_area_struct *vma = pvmw->vma;
   183		struct mm_struct *mm = vma->vm_mm;
   184		unsigned long end;
   185		spinlock_t *ptl;
   186		pgd_t *pgd;
   187		p4d_t *p4d;
   188		pud_t *pud;
   189		pmd_t pmde;
   190	
   191		/* The only possible pmd mapping has been handled on last iteration */
   192		if (pvmw->pmd && !pvmw->pte)
   193			return not_found(pvmw);
   194	
   195		if (unlikely(is_vm_hugetlb_page(vma))) {
   196			struct hstate *hstate = hstate_vma(vma);
   197			unsigned long size = huge_page_size(hstate);
   198			/* The only possible mapping was handled on last iteration */
   199			if (pvmw->pte)
   200				return not_found(pvmw);
   201			/*
   202			 * All callers that get here will already hold the
   203			 * i_mmap_rwsem.  Therefore, no additional locks need to be
   204			 * taken before calling hugetlb_walk().
   205			 */
   206			pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
   207			if (!pvmw->pte)
   208				return false;
   209	
   210			pvmw->ptl = huge_pte_lock(hstate, mm, pvmw->pte);
   211			if (!check_pte(pvmw, pages_per_huge_page(hstate)))
   212				return not_found(pvmw);
   213			return true;
   214		}
   215	
   216		end = vma_address_end(pvmw);
   217		if (pvmw->pte)
   218			goto next_pte;
   219	restart:
   220		do {
   221			pgd = pgd_offset(mm, pvmw->address);
 > 222			if (!pgd_present(pgdp_get(pgd))) {
   223				step_forward(pvmw, PGDIR_SIZE);
   224				continue;
   225			}
   226			p4d = p4d_offset(pgd, pvmw->address);
   227			if (!p4d_present(p4dp_get(p4d))) {
   228				step_forward(pvmw, P4D_SIZE);
   229				continue;
   230			}
   231			pud = pud_offset(p4d, pvmw->address);
   232			if (!pud_present(pudp_get(pud))) {
   233				step_forward(pvmw, PUD_SIZE);
   234				continue;
   235			}
   236	
   237			pvmw->pmd = pmd_offset(pud, pvmw->address);
   238			/*
   239			 * Make sure the pmd value isn't cached in a register by the
   240			 * compiler and used as a stale value after we've observed a
   241			 * subsequent update.
   242			 */
   243			pmde = pmdp_get_lockless(pvmw->pmd);
   244	
   245			if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
   246				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
   247				pmde = pmdp_get(pvmw->pmd);
   248				if (!pmd_present(pmde)) {
   249					softleaf_t entry;
   250	
   251					if (!thp_migration_supported() ||
   252					    !(pvmw->flags & PVMW_MIGRATION))
   253						return not_found(pvmw);
   254					entry = softleaf_from_pmd(pmde);
   255	
   256					if (!softleaf_is_migration(entry) ||
   257					    !check_pmd(softleaf_to_pfn(entry), pvmw))
   258						return not_found(pvmw);
   259					return true;
   260				}
   261				if (likely(pmd_trans_huge(pmde))) {
   262					if (pvmw->flags & PVMW_MIGRATION)
   263						return not_found(pvmw);
   264					if (!check_pmd(pmd_pfn(pmde), pvmw))
   265						return not_found(pvmw);
   266					return true;
   267				}
   268				/* THP pmd was split under us: handle on pte level */
   269				spin_unlock(pvmw->ptl);
   270				pvmw->ptl = NULL;
   271			} else if (!pmd_present(pmde)) {
   272				const softleaf_t entry = softleaf_from_pmd(pmde);
   273	
   274				if (softleaf_is_device_private(entry)) {
   275					pvmw->ptl = pmd_lock(mm, pvmw->pmd);
   276					return true;
   277				}
   278	
   279				if ((pvmw->flags & PVMW_SYNC) &&
   280				    thp_vma_suitable_order(vma, pvmw->address,
   281							   PMD_ORDER) &&
   282				    (pvmw->nr_pages >= HPAGE_PMD_NR))
   283					sync_with_folio_pmd_zap(mm, pvmw->pmd);
   284	
   285				step_forward(pvmw, PMD_SIZE);
   286				continue;
   287			}
   288			if (!map_pte(pvmw, &pmde, &ptl)) {
   289				if (!pvmw->pte)
   290					goto restart;
   291				goto next_pte;
   292			}
   293	this_pte:
   294			if (check_pte(pvmw, 1))
   295				return true;
   296	next_pte:
   297			do {
   298				pvmw->address += PAGE_SIZE;
   299				if (pvmw->address >= end)
   300					return not_found(pvmw);
   301				/* Did we cross page table boundary? */
   302				if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
   303					if (pvmw->ptl) {
   304						spin_unlock(pvmw->ptl);
   305						pvmw->ptl = NULL;
   306					}
   307					pte_unmap(pvmw->pte);
   308					pvmw->pte = NULL;
   309					pvmw->flags |= PVMW_PGTABLE_CROSSED;
   310					goto restart;
   311				}
   312				pvmw->pte++;
   313			} while (pte_none(ptep_get_lockless(pvmw->pte)));
   314	
   315			if (!pvmw->ptl) {
   316				spin_lock(ptl);
   317				if (unlikely(!pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))) {
   318					pte_unmap_unlock(pvmw->pte, ptl);
   319					pvmw->pte = NULL;
   320					goto restart;
   321				}
   322				pvmw->ptl = ptl;
   323			}
   324			goto this_pte;
   325		} while (pvmw->address < end);
   326	
   327		return false;
   328	}
   329	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

