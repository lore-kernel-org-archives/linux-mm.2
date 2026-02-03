Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8C4E83059
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 06:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757D66B0005; Tue,  3 Feb 2026 01:32:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E406B0088; Tue,  3 Feb 2026 01:32:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637636B0089; Tue,  3 Feb 2026 01:32:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 510346B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:32:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4702C1A73
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:32:57 +0000 (UTC)
X-FDA: 84402177594.30.C25D599
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id 107BDC0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:32:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Wu/8b/bS";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770100375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZRDSZh4BMEV92VYkes92GOUsY0dzEPTFK3g7xWfK6w=;
	b=K4HOgsV7G7U9Z04HzKFz6xuVJkBxF5ei5bCKg0OhUaU6gT34+m3+EypGqqYOk4DB0rkMGd
	qPN+i8JQ7aN0ByK5tdb5ianAZexpUciLCmVEYJKZ3mELtmuDhWwZHfvWV0fsAP/gUDn22x
	DwHiWUha1LyWxhqPaXcdfPua8Ka2218=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770100375; a=rsa-sha256;
	cv=none;
	b=gTeQDWlPah886q2gk5m8a7M3tqA32MFeErhh2LOoocwX8Q/SU0xfYCeGt+3RjiIbauevsC
	Xf3Ce3CaVxUgmHgiyXxaBbuLjWOsDBYTpKGXLQKSlHEpOgBq/h197FLOD/g8TfoefiMo73
	fetKntAl/tUVvnwWo0AD0vbSa7QvlrU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Wu/8b/bS";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770100376; x=1801636376;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bbRpxtdvAN6Almr7Ilsz7KDIEVA2KjyHmdEG720mlAs=;
  b=Wu/8b/bS6nVHXLxVrNfJPfuowcW1ehwq/erR1QHnalTf3lQIGba+9bFk
   1ZP+fDS+C8r4YbpdeTru0YIjahr0eb4KEjgfbB50/UUtyXwpVPwaPHiem
   XXNAI0Am4N2O8KtbFgpZ5AGh5bv104hObA2G/PETc6/ZKB7Qq5wLv9vS3
   cxbIa1Ih30kJQoB+qozQ3txQTPNm6aZg7CMrNNXVTcjWwAPSxOJ0Fe8Sp
   KY9FWfiAVtOgmhFetyRCsFZxziNm9CyG4qkzycnjfyr9/biT8DNuk029G
   g8y41dWfdMmCx1rk5mJ93BgxHXelshE7LFrMU0LGGq+0xnnht6WrA1gmm
   A==;
X-CSE-ConnectionGUID: lbwzS43aQ/CAH65XYyDZrQ==
X-CSE-MsgGUID: wM/tfl3XQvC7JbpbZw+dEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="93918124"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="93918124"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 22:32:54 -0800
X-CSE-ConnectionGUID: Ye7mVCl3RIupOvhMgTD0Gg==
X-CSE-MsgGUID: fXPNwjQ5Tn6S6RGQuGTtTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="214713889"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 02 Feb 2026 22:32:50 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vn9xw-00000000gLa-0VMZ;
	Tue, 03 Feb 2026 06:32:48 +0000
Date: Tue, 3 Feb 2026 14:32:39 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v4 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202602031458.obPf0uoY-lkp@intel.com>
References: <20260202112622.2104213-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202112622.2104213-2-mpenttil@redhat.com>
X-Rspamd-Queue-Id: 107BDC0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: frd8b8w9bdd98ets8wtq4m856kufyf5q
X-HE-Tag: 1770100374-666624
X-HE-Meta: U2FsdGVkX191eyr8XCl8CyFLBlTHanFAd9SEI9DlcFh2vaUO1betopqQiZCz5hUGMeC3Ka1Kzy0EG/k3YBJSJmOKyTbXkbPpxxrG5U/ZNBh2o3xdf+O2ujXMM1B42IZw1p0N8/S1BexUK2qcl7yCRMZ+SnXE8CoHynidBgbrgrd2A2qHdJqVYfVtvoHYsnTRMuZiZ139nmOpiyqDZjV1tDPE9SK0B9dJ1v/f/BappldC7mHXwyQ/vyhILyrHSc6kl2DoU2cFO+CSu6imv8KJ5Ck1z1STh1WZkWQhBPD+g2N4BaTkEEyqNHPILXxXVDeM4mTqx6LxF33FIXZZ7OgYgycHjggSBva3SchDibrveQXgkjIPAuINGBOO6AVgkY9Yx2+1lt9mosFTXWYL9wTFEKerRn0OXBHCkZvs+tJ8tNV3qw68jUo56te+o71lviYMoqBmHSUP8WTI21dyiwA5J6zJFkFMj6gnu2nc7KvGKkIi3DY7LebLI23nIf0XN8fhBgL1e8gkirNDMcCpNYSaPqncQvh5KCYYAMmoVugoRSYyhWU2iBXRP5CexekVNB68NMZy8+eyungdEu5n9E2+oxvR/XzouhvhYVo5MtlE9Zj4sSKPh7tn7fesV0MYlgS8i/hP2JTbpuDS558cB+ndr7uyuN8UsVV9FKa5cqOwHwwEsNNUztViDUnQf7W3I2qR2JJV1YXAJVUEq3KMUk41aOmEJB/ZAIOTJKbHCEuq/DAAye8dcoA9jaeiXmFkMA4SeCZn21KR02vUJ/BlfW49lDEL6lGO96y8w73C2CjUHekxKLmxDHOb+/PnaTjkBcokmmtE3rBH5WLkmP2Btu0C/pr8SkyQw1h61HQ7ZlhmcFZN1PbyVXmEXL+zPayai+tvZaebwAdRbkKgoIvgipAR0uO9xc6+FaDGqgqYxvoS1s4b2BZU+HX84eHrCoRL4ew0UvVqbyyXkhb126MEcY8
 PJk3cZa2
 P9FPYI7LABpeq6DUrNcxNjY/WWMlBDbC1Cz8vr+i/RH0mu34hKQyWsihT/8l0Y+faHDebiK5mLE+VO7KeQz8dwNxK7G/X+YlDv3TbFtofkP95mBLIXp1lDIFHHuwW4Pbw9o4anxpH5CZtmQVACBIe1K8GbkLeps5tfRqdg2hPOfZ8t6vhKWjARM2dCm/7ZIXT0Y1IAwoB9Q/yhevCB6bGiW1VITJOSEyyItyayHkrPkEQDm9ZTe1g3hUOg9ik++e8NjMcWXm5lFMC+LFcHhagK/Gb4Z0nk/r0s0AmuqFR5v5yBtrSxjQBlj3zokWcYFGRuoLiQvbe8GjWIVZwu56XoqjFLFu05/GCcE81
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 18f7fcd5e69a04df57b563360b88be72471d6b62]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260202-192748
base:   18f7fcd5e69a04df57b563360b88be72471d6b62
patch link:    https://lore.kernel.org/r/20260202112622.2104213-2-mpenttil%40redhat.com
patch subject: [PATCH v4 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: x86_64-randconfig-101-20260202 (https://download.01.org/0day-ci/archive/20260203/202602031458.obPf0uoY-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602031458.obPf0uoY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602031458.obPf0uoY-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: mm/hmm.o: in function `hmm_vma_walk_pmd':
>> mm/hmm.c:1028:(.text+0x21ab): undefined reference to `hmm_vma_handle_pmd'


vim +1028 mm/hmm.c

   936	
   937	static int hmm_vma_walk_pmd(pmd_t *pmdp,
   938				    unsigned long start,
   939				    unsigned long end,
   940				    struct mm_walk *walk)
   941	{
   942		struct hmm_vma_walk *hmm_vma_walk = walk->private;
   943		struct hmm_range *range = hmm_vma_walk->range;
   944		unsigned long *hmm_pfns =
   945			&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
   946		unsigned long npages = (end - start) >> PAGE_SHIFT;
   947		struct mm_struct *mm = walk->vma->vm_mm;
   948		unsigned long addr = start;
   949		enum migrate_vma_info minfo;
   950		unsigned long i;
   951		pte_t *ptep;
   952		pmd_t pmd;
   953		int r = 0;
   954	
   955		minfo = hmm_select_migrate(range);
   956	
   957	again:
   958		hmm_vma_walk->ptelocked = false;
   959		hmm_vma_walk->pmdlocked = false;
   960	
   961		if (minfo) {
   962			hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
   963			hmm_vma_walk->pmdlocked = true;
   964			pmd = pmdp_get(pmdp);
   965		} else
   966			pmd = pmdp_get_lockless(pmdp);
   967	
   968		if (pmd_none(pmd)) {
   969			r = hmm_vma_walk_hole(start, end, -1, walk);
   970	
   971			if (hmm_vma_walk->pmdlocked) {
   972				spin_unlock(hmm_vma_walk->ptl);
   973				hmm_vma_walk->pmdlocked = false;
   974			}
   975			return r;
   976		}
   977	
   978		if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
   979			if (!minfo) {
   980				if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
   981					hmm_vma_walk->last = addr;
   982					pmd_migration_entry_wait(walk->mm, pmdp);
   983					return -EBUSY;
   984				}
   985			}
   986			for (i = 0; addr < end; addr += PAGE_SIZE, i++)
   987				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
   988	
   989			if (hmm_vma_walk->pmdlocked) {
   990				spin_unlock(hmm_vma_walk->ptl);
   991				hmm_vma_walk->pmdlocked = false;
   992			}
   993	
   994			return 0;
   995		}
   996	
   997		if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
   998	
   999			if (!pmd_present(pmd)) {
  1000				r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
  1001							      pmd);
  1002				// If not migrating we are done
  1003				if (r || !minfo) {
  1004					if (hmm_vma_walk->pmdlocked) {
  1005						spin_unlock(hmm_vma_walk->ptl);
  1006						hmm_vma_walk->pmdlocked = false;
  1007					}
  1008					return r;
  1009				}
  1010			} else {
  1011	
  1012				/*
  1013				 * No need to take pmd_lock here if not migrating,
  1014				 * even if some other thread is splitting the huge
  1015				 * pmd we will get that event through mmu_notifier callback.
  1016				 *
  1017				 * So just read pmd value and check again it's a transparent
  1018				 * huge or device mapping one and compute corresponding pfn
  1019				 * values.
  1020				 */
  1021	
  1022				if (!minfo) {
  1023					pmd = pmdp_get_lockless(pmdp);
  1024					if (!pmd_trans_huge(pmd))
  1025						goto again;
  1026				}
  1027	
> 1028				r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
  1029	
  1030				// If not migrating we are done
  1031				if (r || !minfo) {
  1032					if (hmm_vma_walk->pmdlocked) {
  1033						spin_unlock(hmm_vma_walk->ptl);
  1034						hmm_vma_walk->pmdlocked = false;
  1035					}
  1036					return r;
  1037				}
  1038			}
  1039	
  1040			r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
  1041	
  1042			if (hmm_vma_walk->pmdlocked) {
  1043				spin_unlock(hmm_vma_walk->ptl);
  1044				hmm_vma_walk->pmdlocked = false;
  1045			}
  1046	
  1047			if (r == -ENOENT) {
  1048				r = hmm_vma_walk_split(pmdp, addr, walk);
  1049				if (r) {
  1050					/* Split not successful, skip */
  1051					return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
  1052				}
  1053	
  1054				/* Split successful or "again", reloop */
  1055				hmm_vma_walk->last = addr;
  1056				return -EBUSY;
  1057			}
  1058	
  1059			return r;
  1060	
  1061		}
  1062	
  1063		if (hmm_vma_walk->pmdlocked) {
  1064			spin_unlock(hmm_vma_walk->ptl);
  1065			hmm_vma_walk->pmdlocked = false;
  1066		}
  1067	
  1068		/*
  1069		 * We have handled all the valid cases above ie either none, migration,
  1070		 * huge or transparent huge. At this point either it is a valid pmd
  1071		 * entry pointing to pte directory or it is a bad pmd that will not
  1072		 * recover.
  1073		 */
  1074		if (pmd_bad(pmd)) {
  1075			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
  1076				return -EFAULT;
  1077			return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
  1078		}
  1079	
  1080		if (minfo) {
  1081			ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
  1082			if (ptep)
  1083				hmm_vma_walk->ptelocked = true;
  1084		} else
  1085			ptep = pte_offset_map(pmdp, addr);
  1086		if (!ptep)
  1087			goto again;
  1088	
  1089		for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
  1090	
  1091			r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
  1092			if (r) {
  1093				/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
  1094				return r;
  1095			}
  1096	
  1097			r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
  1098			if (r == -EAGAIN) {
  1099				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
  1100				goto again;
  1101			}
  1102			if (r) {
  1103				hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
  1104				break;
  1105			}
  1106		}
  1107	
  1108		if (hmm_vma_walk->ptelocked) {
  1109			pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
  1110			hmm_vma_walk->ptelocked = false;
  1111		} else
  1112			pte_unmap(ptep - 1);
  1113	
  1114		return 0;
  1115	}
  1116	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

