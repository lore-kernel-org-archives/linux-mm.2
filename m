Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD2F1061B18
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2656B008C; Mon, 30 Mar 2026 14:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A856B0095; Mon, 30 Mar 2026 14:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E5F6B0096; Mon, 30 Mar 2026 14:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEF256B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:58:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F62013BB5E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:58:40 +0000 (UTC)
X-FDA: 84603640800.15.EB1128E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01289A000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:58:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lDRIznEE;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774897118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NZ0KrhJpa7RGy+ZaIJAHOmnES8bmoOZLsF2p2Q1RNRg=;
	b=J2q8/TxcV6KQwrsG4HoAvezIq9IQt0VyM/geEFrfo7TX2Oy1GXuQxup/r0SK4nLAdMJp+H
	XKmbjRc1ICvwtS5qx7DyLEwnvnZdY5wHtm2mqK+xSVxJfryReWdWNZx67lF43QxcpU0AgT
	Esz4g0RD7im9epYOyO1ZG/3pM3RvQBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lDRIznEE;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774897118; a=rsa-sha256;
	cv=none;
	b=MJ/XWSTrtoPoMm6bdbPUlEivAL03B4Cd0JnTfE9BrEBjBBoBCJiA8aSwpVRe7aS56kXpnS
	o9J7TNdNj6xY+/B1tFy6FzVudCCC/G0J6eIH2ic0i8iVAU5d4zFtOTVIzQNS1iluEyAXIo
	t5Q6E7DErtMCSeLrJkgysRfKSIuNzb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774897118; x=1806433118;
  h=date:from:to:cc:subject:message-id;
  bh=TCiuOVib0wNb4F6I5gmpYr/Ci5Yz/eB2swQ+rRI4eKc=;
  b=lDRIznEEX+M0WKRxweqSzEew+NFLFYVuQhB2HB8jrJuADgiPoO8pdFmU
   NwX3yoV3fjq+oGg9xKK6kTh+6aGSBLWbg1jK0QsxtQ240+zvG0KnP9rbZ
   cGVgy0sbh1cdCW1xyicrb2yXYuG90Y1Dlkf0nQjBCTDr/gs4iqs72g2/s
   tcdl7vuZS7okEWIu6fSL05mJY8K4lt66llhf2c1bdJ7ZCYOEOqiew7K/2
   leUCP/WS20oEv/A/k8IBSh2M7suycptfBGkTm43g/j70yf6BzBoCj1GDV
   wCVscoVdNJRSeQK7uqeNF7IGHkby3LEHhyNaTs6OV56GQjB4akByT1X5Y
   A==;
X-CSE-ConnectionGUID: bxGvTIIFTBaY3d3Wj709/A==
X-CSE-MsgGUID: cICeYAn1SGKGwTLT77MnLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="86591868"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="86591868"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 11:58:36 -0700
X-CSE-ConnectionGUID: 4QFd2bA1S5Cw0Pr3m0JNTg==
X-CSE-MsgGUID: DckZ8NrsT/W0o9dLtI5faw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="225149343"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 30 Mar 2026 11:58:34 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7Hol-000000001Wb-0VWu;
	Mon, 30 Mar 2026 18:58:31 +0000
Date: Tue, 31 Mar 2026 02:58:30 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: arch/powerpc/mm/book3s64/hash_tlb.c:45:42: sparse: sparse:
 incorrect type in initializer (different address spaces)
Message-ID: <202603310251.oTtJlApu-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 01289A000F
X-Stat-Signature: e6qfkf6oeckthyd9zx4cpd69m9oyo8g3
X-Rspamd-Server: rspam06
X-HE-Tag: 1774897117-520355
X-HE-Meta: U2FsdGVkX19Jjym4ovMxTORtV1m0mgosm2c+D4O7b+bRshTZlcZa+TOnFbhwgNoLJnmyqDlkWEInpAq+e2c7NDE46WE2qYyPrvwsykLQI2kCz/xAq0a1fldbgnhyAbZxQj9IaUO/xwtJgnm6iJQn7VKygT+hmv4nhqGS/tJs2BkzECG5Ho7Dba+SCuE1e8O2eTpwT7zHCddg26bH8dSiwTIw7hECdqsc6hSFE34+gNEe5vwgeAPqopk5fcrzq4Bg8VHdGMXO2L/5u2/DwXxfF36oUPEDj7PKdgifdP9sRRnKWmsvSsbYlqIeGyOj/orVRl+XLBs5fqyjL/xuBj7Tuck2jD5qXRMYBxbY5jul8TEQDpZLsJoguicBnl/s83RLv1v+BYIaNJwrboPC19MxflO02A/PalEJE/12MoeBZrqAtGkcb21/Rzgyjy5/pItJrIDOJRbSsDowyQd1fEsVaw9k+trP0T7ceYkb6K+VfLNP51TqG3AmxpN1qO5eW15FWND7QE44uBrDxcvlVYo7fEJ6aieCyOYWe1Mp3ooHAfDBENhTogi1umUMnoJqY1sVfkFYj8vHHzZhWlge1M2ef3hTOgRmDt0Ge7Y87M37XdRWKGmoq2oQJR8Kj4zILTuuuuRa/WYoDa7IGsTI+r93TtN3F0wineGh8PiE2/QZRLGeLXVHtp+idLLQruaySzCz5TvS+mQK544SNVI6cFt53y7YH67zpAGbbNqJ5co54bV+mOubeVtbY2Qm/RY6PxAzG6SmOWyYPQcrZJmbpmXq5gmo/cFKk+XYzGj8o9/2iGXjpwTpMjWEmcE+qaUk8uqkf9rlB1NsGLhrCF351dQUCyNJxVyGDGeTYY7hxzux33jTLT6ykuKZ4VAhizOJghxVYFPw3VoApxYhrzXxFHywVAvYAYOam08TVaHPpzY+ggK2LSARLWtq6VvcXKxHaWXgAasV5fjHlyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7aaa8047eafd0bd628065b15757d9b48c5f9c07d
commit: ee628d9cc8d5b96fdceeb270cf662efc4f85f2b6 mm: add basic tests for lazy_mmu
date:   10 weeks ago
config: powerpc64-randconfig-r113-20260330 (https://download.01.org/0day-ci/archive/20260331/202603310251.oTtJlApu-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 2cd67b8b69f78e3f95918204320c3075a74ba16c)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603310251.oTtJlApu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603310251.oTtJlApu-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/powerpc/mm/book3s64/hash_tlb.c:45:42: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ppc64_tlb_batch * @@
   arch/powerpc/mm/book3s64/hash_tlb.c:45:42: sparse:     expected void const [noderef] __percpu *__vpp_verify
   arch/powerpc/mm/book3s64/hash_tlb.c:45:42: sparse:     got struct ppc64_tlb_batch *
   arch/powerpc/mm/book3s64/hash_tlb.c:162:45: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct ppc64_tlb_batch * @@
   arch/powerpc/mm/book3s64/hash_tlb.c:162:45: sparse:     expected void const [noderef] __percpu *__vpp_verify
   arch/powerpc/mm/book3s64/hash_tlb.c:162:45: sparse:     got struct ppc64_tlb_batch *

vim +45 arch/powerpc/mm/book3s64/hash_tlb.c

^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   34  
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   35  /*
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   36   * A linux PTE was changed and the corresponding hash table entry
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   37   * neesd to be flushed. This function will either perform the flush
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   38   * immediately or will batch it up if the current CPU has an active
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   39   * batch on it.
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   40   */
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   41  void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   42  		     pte_t *ptep, unsigned long pte, int huge)
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   43  {
5524a27d39b6877 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2012-09-10   44  	unsigned long vpn;
f342552b917a18a arch/powerpc/mm/tlb_hash64.c        Peter Zijlstra         2011-02-24  @45  	struct ppc64_tlb_batch *batch = &get_cpu_var(ppc64_tlb_batch);
5524a27d39b6877 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2012-09-10   46  	unsigned long vsid;
bf72aeba2ffef59 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2006-06-15   47  	unsigned int psize;
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11   48  	int ssize;
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   49  	real_pte_t rpte;
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   50  	int i, offset;
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   51  
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   52  	i = batch->index;
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16   53  
47d99948eee48a8 arch/powerpc/mm/book3s64/hash_tlb.c Christophe Leroy       2019-03-29   54  	/*
47d99948eee48a8 arch/powerpc/mm/book3s64/hash_tlb.c Christophe Leroy       2019-03-29   55  	 * Get page size (maybe move back to caller).
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   56  	 *
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   57  	 * NOTE: when using special 64K mappings in 4K environment like
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   58  	 * for SPEs, we obtain the page size from the slice, which thus
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   59  	 * must still exist (and thus the VMA not reused) at the time
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   60  	 * of this call
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   61  	 */
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   62  	if (huge) {
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   63  #ifdef CONFIG_HUGETLB_PAGE
d258e64ef595792 arch/powerpc/mm/tlb_hash64.c        Joe Perches            2009-06-28   64  		psize = get_slice_psize(mm, addr);
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   65  		/* Mask the address for the correct page size */
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   66  		addr &= ~((1UL << mmu_psize_defs[psize].shift) - 1);
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   67  		if (unlikely(psize == MMU_PAGE_16G))
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   68  			offset = PTRS_PER_PUD;
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   69  		else
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   70  			offset = PTRS_PER_PMD;
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   71  #else
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   72  		BUG();
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   73  		psize = pte_pagesize_index(mm, addr, pte); /* shutup gcc */
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   74  #endif
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   75  	} else {
16c2d4762325232 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-05-08   76  		psize = pte_pagesize_index(mm, addr, pte);
47d99948eee48a8 arch/powerpc/mm/book3s64/hash_tlb.c Christophe Leroy       2019-03-29   77  		/*
47d99948eee48a8 arch/powerpc/mm/book3s64/hash_tlb.c Christophe Leroy       2019-03-29   78  		 * Mask the address for the standard page size.  If we
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   79  		 * have a 64k page kernel, but the hardware does not
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   80  		 * support 64k pages, this might be different from the
47d99948eee48a8 arch/powerpc/mm/book3s64/hash_tlb.c Christophe Leroy       2019-03-29   81  		 * hardware page size encoded in the slice table.
47d99948eee48a8 arch/powerpc/mm/book3s64/hash_tlb.c Christophe Leroy       2019-03-29   82  		 */
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   83  		addr &= PAGE_MASK;
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   84  		offset = PTRS_PER_PTE;
77058e1adcc4391 arch/powerpc/mm/tlb_hash64.c        David Gibson           2010-02-08   85  	}
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07   86  
f71dc176aa06359 arch/powerpc/mm/tlb_hash64.c        David Gibson           2009-10-26   87  
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   88  	/* Build full vaddr */
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   89  	if (!is_kernel_addr(addr)) {
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11   90  		ssize = user_segment_size(addr);
f384796c40dc55b arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-03-26   91  		vsid = get_user_vsid(&mm->context, addr, ssize);
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11   92  	} else {
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11   93  		vsid = get_kernel_vsid(addr, mmu_kernel_ssize);
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11   94  		ssize = mmu_kernel_ssize;
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11   95  	}
c60ac5693c47df3 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2013-03-13   96  	WARN_ON(vsid == 0);
5524a27d39b6877 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2012-09-10   97  	vpn = hpt_vpn(addr, vsid, ssize);
ff31e105464d8c8 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2018-02-11   98  	rpte = __real_pte(__pte(pte), ptep, offset);
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10   99  
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  100  	/*
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  101  	 * Check if we have an active batch on this CPU. If not, just
c5cee6421cd6514 arch/powerpc/mm/tlb_hash64.c        Balbir Singh           2017-05-25  102  	 * flush now and return.
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  103  	 */
313a05a15a1b29c arch/powerpc/mm/book3s64/hash_tlb.c Kevin Brodsky          2025-12-15  104  	if (!is_lazy_mmu_mode_active()) {
c5cee6421cd6514 arch/powerpc/mm/tlb_hash64.c        Balbir Singh           2017-05-25  105  		flush_hash_page(vpn, rpte, psize, ssize, mm_is_thread_local(mm));
f342552b917a18a arch/powerpc/mm/tlb_hash64.c        Peter Zijlstra         2011-02-24  106  		put_cpu_var(ppc64_tlb_batch);
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  107  		return;
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  108  	}
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  109  
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  110  	/*
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  111  	 * This can happen when we are in the middle of a TLB batch and
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  112  	 * we encounter memory pressure (eg copy_page_range when it tries
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  113  	 * to allocate a new pte). If we have to reclaim memory and end
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  114  	 * up scanning and resetting referenced bits then our batch context
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  115  	 * will change mid stream.
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07  116  	 *
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07  117  	 * We also need to ensure only one page size is present in a given
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07  118  	 * batch
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  119  	 */
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11  120  	if (i != 0 && (mm != batch->mm || batch->psize != psize ||
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11  121  		       batch->ssize != ssize)) {
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  122  		__flush_tlb_pending(batch);
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  123  		i = 0;
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  124  	}
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  125  	if (i == 0) {
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  126  		batch->mm = mm;
3c726f8dee6f55e arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2005-11-07  127  		batch->psize = psize;
1189be6508d4518 arch/powerpc/mm/tlb_64.c            Paul Mackerras         2007-10-11  128  		batch->ssize = ssize;
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  129  	}
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  130  	batch->pte[i] = rpte;
5524a27d39b6877 arch/powerpc/mm/tlb_hash64.c        Aneesh Kumar K.V       2012-09-10  131  	batch->vpn[i] = vpn;
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  132  	batch->index = ++i;
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  133  	if (i >= PPC64_TLB_BATCH_NR)
a741e6796957716 arch/powerpc/mm/tlb_64.c            Benjamin Herrenschmidt 2007-04-10  134  		__flush_tlb_pending(batch);
f342552b917a18a arch/powerpc/mm/tlb_hash64.c        Peter Zijlstra         2011-02-24  135  	put_cpu_var(ppc64_tlb_batch);
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  136  }
^1da177e4c3f415 arch/ppc64/mm/tlb.c                 Linus Torvalds         2005-04-16  137  

:::::: The code at line 45 was first introduced by commit
:::::: f342552b917a18a7a1fa2c10625df85fac828c36 powerpc/mm: Make hpte_need_flush() safe for preemption

:::::: TO: Peter Zijlstra <a.p.zijlstra@chello.nl>
:::::: CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

