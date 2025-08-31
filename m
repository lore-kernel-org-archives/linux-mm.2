Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4D5BCA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 10:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C2B6B000C; Sun, 31 Aug 2025 06:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33766B000E; Sun, 31 Aug 2025 06:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6FD76B0010; Sun, 31 Aug 2025 06:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 910846B000C
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 06:15:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 431BB1DD754
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 10:15:47 +0000 (UTC)
X-FDA: 83836646334.16.0C8738E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8FD3A1C000B
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 10:15:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="B/buqw60";
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756635345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LEs88vBnHYdZkCP7DNljXknVsfJHlUyaZ1vENeVNW34=;
	b=JWy8GaogaU2ADOo6qJ+G7w07wHnQlvCUYnXpb+iupec8qQopc8aClfmtmvAB3f1+32Sken
	TJivErmEf13YvzRzhw0FuLvfjPq035vpbtJs2Y7Jza6hrDcayj5roaKO/QSSIIjPbgpTvm
	m2P1boUGs/ptqCifBck5vfG0nmiH0c8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="B/buqw60";
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756635345; a=rsa-sha256;
	cv=none;
	b=jc1G0RGi/d24g5BNjO73tpuDnoVncSQg7nntuTt+KJiJJSEgLMqk7nOLFyCw04b1aq1oH6
	1PimVepxrDjse8f1lP6kKplXFWn403QDgsKwspxTCVMu4pWy9JAX3EaYSVp0qovB7hi0EY
	Zzu8ylzhxCPyJ4Hf0WG7rCv7etWMZ5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756635345; x=1788171345;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=p3WI4FCDeL4So+P3eBVdNKKy1LNMbXqDY5+OtJLZkQc=;
  b=B/buqw60exGgGPSPTSPJi5h971YazxD7ehoM6vyBdK4KXOMgWPIkwisK
   C9A0gV6J/7K5KHa6or8WQCo+uWz10Khjy3mP363+KEoi/8QTBvDfP1IXh
   RBs76n7C+btg3hf0GytxYfSc8YoIs7Rb/7iXGx/WI1K5uokC5PqDDS+t8
   KEkDa9+NDn4f7xpm4EVoB0hG8hIkd5luv0nXLnei6W1Qor0G/zDdab4zT
   /WhadjICjppiLB5qkCOgjrEZvujy/RDJwyDZQGuemtJ9CmozjbhdPY4VX
   gjKrjQ9Z/oYvRxI7iZ3VifxECzOL8UDonfuUMXTPLSxYOq1JqX/THA8kr
   g==;
X-CSE-ConnectionGUID: qFknlk2jS3KVRViCJNhVAA==
X-CSE-MsgGUID: b7yXvwwnQ/iN8Drw/wNzDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="61492374"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="61492374"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 03:15:42 -0700
X-CSE-ConnectionGUID: Yd7pGHJCS8a9JmBAGnJB0g==
X-CSE-MsgGUID: FjUQrYhLTKmLfPBtkw2XBg==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 31 Aug 2025 03:15:41 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usf5x-000W4h-1a;
	Sun, 31 Aug 2025 10:15:35 +0000
Date: Sun, 31 Aug 2025 18:15:31 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/mprotect.c:450:23: sparse: sparse: cast to non-scalar
Message-ID: <202508311724.Mp4RhDNi-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8FD3A1C000B
X-Rspam-User: 
X-Stat-Signature: mxkpogn88c1t3f3awkimm8bisj878qk7
X-Rspamd-Server: rspam09
X-HE-Tag: 1756635344-265197
X-HE-Meta: U2FsdGVkX1/T+KByr5eCjsbTrnbUno5QQoqVVYoGPJlR9ER9uFOs2a20z/okI+9zXR/mltVdnvqZUFwgMvZ3t6CNYs5SfGt1ZYiMC1MJQ4+buXANwN6bGrHRTdl5bmvOT5kA10cGVFmZmv1+jEqqoBhQVZAVHL0ziwvo49lm9xa3cxT816qUG3X1mmzYf3enywZQkieGjxwVuVJMeCQUfmOgtlkT4Am9tormjt2oLv2GLQlV/G783etwJnrUNbHI2cscr5YO3eY+ehv2log5Ykg7FkV1Stf0iWUcM3Hd//Xxc+oJ9/wcvQ3qFsKqSvlmuLD+1BOjEZE8nBpGc0txFX1hF76CM+2iQN+k1YVjBwfEtAhDIRGwcVQiUtQxWP49G4260svEAS7hpB+kLeo5gM9b0lLMWfHtagml123f8HM0ZDFzUTE187ilysP0FOT3mdoJTbDn8E6VdeFIbB/hJ5O0SEDunNHLtZR32pCIA5DIyHI2oJE7AnIHuqIcBSHYzZ+2Zmg2k3QwoYmTWn3Q6uAA19rRzNJKUUCP7kY3YreuK27mz9gj9z52l8UFY23qkojm41VYT13DyqgtkOjjKePbfK5wKVtjDx5DHHqsHU+Sb12+Npp1ox6z5jGcOqQDDCB4LX5cvgdis9kBK3aSwI90D6vevgSbKCJrINyYBEjsDHzZbeBBK46wG74ShCtIT6p6QgR1OdBtSvsbhN81o2bJ3mYAwsrfh00O0Qlw48B9bjugdx27hJJCpLijx4h8JzhFFSwfffAup3WG7enD0B5PRtFjD52WolNe/ZX86OPirmNIyvwxMbGpWgCAfyHYdeUeFydvPqo3XjOmCiAmHv75JcFyFtyHdj6KRc+eNuUdScM+tvVL6Pi1Mm0iyCT8EeOhBb5ztyxdznUv7jUCqPk25qlS5Q1b5FPb2Ghucp9JrkUqYn5y2Q8PK024vSkkX+9Y7DD8qx/jSAaTQXi
 KIAXOgyl
 MvpQnE4rbFeSlIh8LjyuDxu1oZvZiBAFvI/GRMEYt+fKXk1LFVaAzhqSJvpGfYmH39p9+IMaT3t6/1b6gLazLDx7dZarb2azrJG6j0Orla1Epa+OgRKRwip1dNAJrPx5dVW2Ofm7TY3z256x5yYfQA436V4rG4vYrmf96BAGNCKEEkvMD4ADS1XjpS6D8VMBBr4XZMLmlfENaDBa6XjyGhTXEV43A/kjYz/ugRBCRsWO3359KyMKDLiNFN/cyt25xeNq9axAOxXUSxXYE70nkECZpQnshG8IvOBBS/wSPvSQ1Bwhdv+P0LSS9kyQZUyLzim96leTe3aiTStrPU9L6+6AgKm9ZLIbgGKIZ/a4qW3uf2cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   c8bc81a52d5a2ac2e4b257ae123677cf94112755
commit: cb0f01beb16669e91510fcdb2cea213931aee017 mm/mprotect: fix dax pud handlings
date:   12 months ago
config: arm64-randconfig-r121-20250831 (https://download.01.org/0day-ci/archive/20250831/202508311724.Mp4RhDNi-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project ac23f7465eedd0dd565ffb201f573e7a69695fa3)
reproduce: (https://download.01.org/0day-ci/archive/20250831/202508311724.Mp4RhDNi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508311724.Mp4RhDNi-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/mprotect.c: note: in included file (through include/linux/pgtable.h, include/linux/mm.h, include/linux/pagewalk.h):
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast to non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast from non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast to non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast from non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast to non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast from non-scalar
   mm/mprotect.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:869:25: sparse: sparse: context imbalance in 'change_pte_range' - unexpected unlock
>> mm/mprotect.c:450:23: sparse: sparse: cast to non-scalar
>> mm/mprotect.c:450:23: sparse: sparse: cast from non-scalar
   mm/mprotect.c: note: in included file (through include/linux/mm.h, include/linux/pagewalk.h):
   include/linux/pgtable.h:324:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:324:16: sparse: sparse: cast from non-scalar
   mm/mprotect.c: note: in included file (through include/linux/pgtable.h, include/linux/mm.h, include/linux/pagewalk.h):
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast to non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast from non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast to non-scalar
   arch/arm64/include/asm/pgtable.h:315:16: sparse: sparse: cast from non-scalar

vim +450 mm/mprotect.c

   428	
   429	static inline long change_pud_range(struct mmu_gather *tlb,
   430			struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
   431			unsigned long end, pgprot_t newprot, unsigned long cp_flags)
   432	{
   433		struct mmu_notifier_range range;
   434		pud_t *pudp, pud;
   435		unsigned long next;
   436		long pages = 0, ret;
   437	
   438		range.start = 0;
   439	
   440		pudp = pud_offset(p4d, addr);
   441		do {
   442	again:
   443			next = pud_addr_end(addr, end);
   444			ret = change_prepare(vma, pudp, pmd, addr, cp_flags);
   445			if (ret) {
   446				pages = ret;
   447				break;
   448			}
   449	
 > 450			pud = READ_ONCE(*pudp);
   451			if (pud_none(pud))
   452				continue;
   453	
   454			if (!range.start) {
   455				mmu_notifier_range_init(&range,
   456							MMU_NOTIFY_PROTECTION_VMA, 0,
   457							vma->vm_mm, addr, end);
   458				mmu_notifier_invalidate_range_start(&range);
   459			}
   460	
   461			if (pud_leaf(pud)) {
   462				if ((next - addr != PUD_SIZE) ||
   463				    pgtable_split_needed(vma, cp_flags)) {
   464					__split_huge_pud(vma, pudp, addr);
   465					goto again;
   466				} else {
   467					ret = change_huge_pud(tlb, vma, pudp,
   468							      addr, newprot, cp_flags);
   469					if (ret == 0)
   470						goto again;
   471					/* huge pud was handled */
   472					if (ret == HPAGE_PUD_NR)
   473						pages += HPAGE_PUD_NR;
   474					continue;
   475				}
   476			}
   477	
   478			pages += change_pmd_range(tlb, vma, pudp, addr, next, newprot,
   479						  cp_flags);
   480		} while (pudp++, addr = next, addr != end);
   481	
   482		if (range.start)
   483			mmu_notifier_invalidate_range_end(&range);
   484	
   485		return pages;
   486	}
   487	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

