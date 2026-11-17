Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF62606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ODD5n0my
Received: by kanga.kvack.org (Postfix)
	id D40B26B05B2; Tue, 17 Nov 2026 07:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0E06B05B5; Tue, 17 Nov 2026 07:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0BE6B05BA; Tue, 17 Nov 2026 07:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 963626B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:28:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC24B1203BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:28:03 +0000 (UTC)
X-FDA: 85444538046.03.55625BF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id 34B0918000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:28:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ODD5n0my;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794918481;
	b=PTIi0oPNNw3BAY3sggqosaSMT9PKyGo6eSwnodmTzm/7c9lZ+3swJBC4L1z/fOG+9egM78
	DEoDVLq4onAwnD0+7QyDtOl0ChMsLhJP7dPnOmidMKm+dd0+EyKTWMV5DG0te01VE1zP0b
	EAtp+hbeTwEDbklOnuisemYGdrZmg3E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ODD5n0my;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794918481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KM2AxC661JUFDMgbgS/j/UEBdUL+WXU1AFM74ye9SbA=;
	b=3M+s5iY4d1abu4+vpe8tMdfu9CxvgiVbFhcQxFO3kN6wtKCkHEBTUqsc/rP37VvbPcXoxD
	J+j2jRaIOt1ox0esBm96BjBhIlKzK7ydTw+arKG7zHkpqlyk02rjdSYlefHA7uXqDmyIu1
	huS36fbXWfmTzHMxv1Nnd1Jby0MsFp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794918482; x=1826454482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ndTg7sq8BTwzV5ZIdQVv8vLbR7ewI5Azcqn8dK7UYzM=;
  b=ODD5n0myDcJetvO7T3XghdjKW+KzqXBwFMlg9ytSGFRh/NLP3MvXj5Wr
   Xo7HHhECD9zaYeAjaSDWDyN0oty+zpgkthSkc/8yGqHq2xBIArYd8AzwF
   QacF7rQtImGLVjeex+cyQzKSUIVPvqz+hauwarpI26i0lYosdPYK4+ezS
   +YtouxeW9sBTdSGGd5zriEj+vTXVu0mHI6X/tVkgA2NgontKtMhQD/IJR
   xgQFapVeNzthyrXPX7jZXw1lc6yQW3CdtfZn2mD9DXwFQ5U+JwoavD+6R
   cYxkOOvMRASkJx4QZYfmgaZaRbW4ZGBDWsm9QttOE59BlZEIBVAZFsROF
   A==;
X-CSE-ConnectionGUID: PcG8pOSeTQe4Q1buhwHndA==
X-CSE-MsgGUID: I4XUwHyCTeG1oLX/5DUjsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3708467"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3708467"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 04:28:00 -0800
X-CSE-ConnectionGUID: NXh2zuLfQMCZt8jrPFWneA==
X-CSE-MsgGUID: hloi4fbTT666ZNmxD62qgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="10225051"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 17 Nov 2026 04:27:57 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTIHy-00000001BTZ-3Fww;
	Tue, 17 Nov 2026 12:27:54 +0000
Date: Tue, 17 Nov 2026 20:27:32 +0800
From: kernel test robot <lkp@intel.com>
To: xu.xin@linux.dev, David Hildenbrand <david@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Xu Xin <xu.xin@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE
 markers on fork
Message-ID: <202611172040.LO8S0kBo-lkp@intel.com>
References: <20261117081821.7211-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117081821.7211-1-xu.xin@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 34B0918000A
X-Stat-Signature: tin3k9a6igxdsfu6f51bsaociie5trei
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794918480-441585
X-HE-Meta: U2FsdGVkX198/68KKLtN/YaOk8kEoULgaW9pd2J4h59D9YvwgrJThbqfEPD7QFt9N+Ajxpnsjyy2pTYy28RYYjRd8+SZ1dMp/p1HYqnYvPquBLmzTS+qNCHjyHPM/pZGBb5RpZX2NmY1nI75oHBqIeg4y3EaMGAyt2dvIrw3WKnYRfRkKqsrV0nGazu6Scm/vtqowtD6dvQxvkM2RobPXlLEFXNxYR5fmAT7RtHRqccB7kURmBDREPCaA0fUq3iaL7Kxktlp+0M5u8HCMNs4srY//0QqBu4x8YyOGUHFsEp6KXZHAU8FpI0f5AaITaesH7qEEblV5M1HP2slqdRY8tZ705VbPETtZ4TmD1PnFRiT2uUuUOphP9nyJAPiLes9qAck5RLJM9mFJhsJZJi6opUfvs/GJBktxBX9kxZgba46riOTI5UMa0OecWauzBBeJba2JRT3b5Wbp9eyc9aA9u4dt95I8L5cfU6kjDV913LaNzjWAuSmEVQJNeWFRxNqtP/L0v3ExR+q1NJpih45p/RZ5oRF1kNTRAX7RpLVm6iYo+tdgKrwwuYWZ7+Vd6XgKFvzXLJxixMQULvcC2vdAOlwV2oyCRZFjP1nxEtf1rM3921VmfWzi1C9c57Aj0ztwmDug+EZbToRM8zjwhd2lssaBdQ7vgtA/GfZm4oCiNmLKuAHcUtX6iN/oVBpmw4bm47ORBH+pr2WA0dH4g3hqSusIjNKJ0NvcqJQNViQ+InjD9L9R76vi4XmVbTwtR5DROW2umlT9E7yVUZZL/6hC6nF1cvzEDyY7RdWq0hNkWdCK2AyDF8s9zlhlFqa8sGu/C9RFEZ8wRQ+IoxnRWowfREsx0VDg8Ryo1g2U/gIqh2zX6aqMMcZfDHDF9Y1EbOUYfkIRF4X1kmiIHIZGfiEZA8/iHauK7ExS3ILbHMK52dg1zi2nxJl1Zg6Fc1AUa0znQakbxvwmlZXfQ4yVM8
 7pOcKbPW
 YLraglzilwqRHB5boubT8YOOv/bT5WsEgzX1h7ejBE+vuL1CwyFPOy03p/vSo5M2Mr2Z5YrDsnd0uAT8xzT/IDL3pFnfitXShJa75CsEYjLuhYY4UiAQMl2VqoNGrF95e4KVhW2rjdiky0m4wZDhOc7mTXhyuEoj21HKAoWm53ebBLIdWSDWj+rucqkWg9x6ThBS+zvJY92hRgzAYQ8Jpz91j8bbwRXxD8ymp9Qr3Me2w4iDFl4pA6/JCNok5erVu5H+Hp9dfww1/B5JtK1wkefE1WmJGOJwDQzV6LpxeFUvowwf8M769h0I27HzkDuRMXjzyzm7rGc2PdNJZ1+lBQMWsEOG2aObouqpbwLxrQV9+dqdeeteyVCi+qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/xu-xin-linux-dev/mm-ksm-do-not-inherit-ksm_zero_pages-counter-or-PTE-markers-on-fork/20261117-161821
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261117081821.7211-1-xu.xin%40linux.dev
patch subject: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20261117/202611172040.LO8S0kBo-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project a69be15ed58ed48738a69ec4c7d0f3e8c7dbe4ce)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261117/202611172040.LO8S0kBo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611172040.LO8S0kBo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory.c:1168:6: error: call to undeclared function 'is_ksm_zero_pte'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1168 |         if (is_ksm_zero_pte(pte))
         |             ^
   1 error generated.


vim +/is_ksm_zero_pte +1168 mm/memory.c

  1123	
  1124	static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
  1125			struct vm_area_struct *src_vma, pte_t *dst_pte, pte_t *src_pte,
  1126			pte_t pte, unsigned long addr, int nr)
  1127	{
  1128		struct mm_struct *src_mm = src_vma->vm_mm;
  1129		bool writable;
  1130	
  1131		/*
  1132		 * Snapshot writability before the RWP-disarm rewrite below: when the
  1133		 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
  1134		 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
  1135		 * so a later pte_write(pte) check would skip the COW wrprotect and
  1136		 * leave the parent writable over a folio shared with the child.
  1137		 */
  1138		writable = pte_write(pte);
  1139	
  1140		/*
  1141		 * Child is not RWP-armed: restore accessible protection so the
  1142		 * inherited PAGE_NONE does not cost a fault on first read. Gate on
  1143		 * pte_uffd(pte) so unrelated PAGE_NONE markers (e.g. NUMA balancing)
  1144		 * are not normalised away.
  1145		 */
  1146		if (!userfaultfd_protected(dst_vma)) {
  1147			if (userfaultfd_rwp(src_vma) && pte_uffd(pte))
  1148				pte = pte_modify(pte, dst_vma->vm_page_prot);
  1149			pte = pte_clear_uffd(pte);
  1150		}
  1151	
  1152		/* If it's a COW mapping, write protect it both processes. */
  1153		if (vma_is_cow_mapping(src_vma) && writable) {
  1154			wrprotect_ptes(src_mm, addr, src_pte, nr);
  1155			pte = pte_wrprotect(pte);
  1156		}
  1157	
  1158		/* If it's a shared mapping, mark it clean in the child. */
  1159		if (src_vma->vm_flags & VM_SHARED)
  1160			pte = pte_mkclean(pte);
  1161		pte = pte_mkold(pte);
  1162	
  1163		/*
  1164		 * Clear the dirty-bit marker on KSM-placed zero-page PTEs in the
  1165		 * child so inherited mappings are not accounted against the child or
  1166		 * unshared by MADV_UNMERGEABLE.  Special PTEs always have nr == 1.
  1167		 */
> 1168		if (is_ksm_zero_pte(pte))
  1169			pte = pte_mkclean(pte);
  1170	
  1171		set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
  1172	}
  1173	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

