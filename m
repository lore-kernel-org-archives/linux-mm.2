Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5FB9D5B86E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6EE36B0088; Mon, 15 Dec 2025 16:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C836B0089; Mon, 15 Dec 2025 16:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11496B008A; Mon, 15 Dec 2025 16:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B89316B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:12:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A1D51358E8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:12:50 +0000 (UTC)
X-FDA: 84222954900.14.0F255E7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9EE56180006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:12:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ik9x5uNQ;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=if6QZi5JroXU1CyM2svfkRDTrfzBrlPAPCrpEdjxBLg=;
	b=xZexauk7HyV1wMzo7d2fvibTpMjm41BWbfxuymMjk27R+teYDvZ+Q5IzS/je0VpfGTvMoD
	vFZwI3DvCaVYKN58Eky99oz1A9YhC1Eff3FsPF3ChXEN/AbOY51kESH0iTMBySJQxdnfP9
	0GsF7xc15RsZgVx/VD/NDZCE7VWlHkg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ik9x5uNQ;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833168; a=rsa-sha256;
	cv=none;
	b=1ue07faiJuPXPaEIB2ZynCWBVNROTtxCM2MxYmxHtpYtOVRXOk3hgtyPrHCVEA4/qsnXR/
	ioKhZW3bYYV7bScF8w/Vt8xtTWlaCHv0kXW7I+Rq/czxN8wnA3VI6w5eZaz3L5PU20WQnE
	7CZijKRqxdRoAnzQZhhc6P/o37v53cs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765833168; x=1797369168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gmz5sebIS4/mbIHs/2L/cB/qwRD8A8HBxtWUTIQaBYQ=;
  b=Ik9x5uNQaEC4OxAhCi8nI5zK1/dgLkKs9KrlbsTXtMnwzVLyaqP71ucY
   XbsMnQwb1stdfA2vdbuR50cjRroYBHldPWtOqxUafgEhgVe6fCOLziBBv
   +gbY6AX84YbZ0pOMfrDRs3T5+pe+uLoLn+UfkXcBFqwxCVeX1YZCC3+fI
   DlpnmzP/cWIEvkL45UI+5pVtS9BwRywXvo370Oc/y7v3iA8wubdOukYy2
   XO496i2Mh8q4zPQC3433BDaFVC0jpcQxDL8hU5zpXJ0huJNxETxxbGWT/
   gXPo/7XyBoWClOMyWITHrDJv1nGvn+oK8Zo6dIeiFiTyZ6TNgNQP2OYQe
   g==;
X-CSE-ConnectionGUID: t5CWbwgGRRmYZUUuwaxsTg==
X-CSE-MsgGUID: 2hLmZ7tbRQefJePaBRjQgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67687998"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67687998"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 13:12:46 -0800
X-CSE-ConnectionGUID: fJ01Gs0pSjCdMMW8DsXsPg==
X-CSE-MsgGUID: +0ui6J9KTYquXH0qhk6wRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,151,1763452800"; 
   d="scan'208";a="228482533"
Received: from lkp-server02.sh.intel.com (HELO 034c7e8e53c3) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 15 Dec 2025 13:12:44 -0800
Received: from kbuild by 034c7e8e53c3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVFs1-000000000mT-0ThQ;
	Mon, 15 Dec 2025 21:12:41 +0000
Date: Tue, 16 Dec 2025 05:12:16 +0800
From: kernel test robot <lkp@intel.com>
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, npache@redhat.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <202512160400.pTmarqg6-lkp@intel.com>
References: <20251215090419.174418-4-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215090419.174418-4-yanglincheng@kylinos.cn>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9EE56180006
X-Stat-Signature: nkwkgrowhf3ewbuk4z583ffh8uu8o1bm
X-Rspam-User: 
X-HE-Tag: 1765833167-371700
X-HE-Meta: U2FsdGVkX18O/f9WojrgypYRzEWX4OOUEqejGC5gfU3DO4ZswIkQ/U4AAsAUK9Pyt4tPIvnmHqG0nehbYOt/D7869BtCrsq0bDpHiSxPPiHRP18zbz/RGFOrKa3AZeKohgr50cgAd74QlkMqaPlXsU/s0dRJN8vGGPXVGc7Hcvs3fTdCk3vel3C8ZP4wg803+BnHraZM4cO0CpdODW7x/l0f4hInnTxXhk15MvhjOUlxOvECIzk2yGCmZZCIv0Uxc0srNQ56DWw4vj1NaDSKPu3sUbph2hjHYXGnxGPoP96CY6X+ZXLj6OYS/PJpTcadhxU7jS2KvyHGiUG8oZBX+YL+TbXZmnyXTYDL0WCIKudzg1S4CHffVEVrtJ7XmkICmv41n2tr5op481OzKD1DAf/Z6MtDc1Mlwhgk+R45GoTpaSDGW0JE/0rUAgrQl8XOTBUgRAybIwMOGCQNxnkArdyDvd7+nTDBf62G0mlBlQ3TJY6aNznn6KiqjTATaRy/i85skthTT1s/S0ZreRe5xquVqJnMK3DhLTYk7Tvgtg4rRfQzUVR3W0J0RsKgZ8SbkZMv72H6iQjxOlV16zGpA/5MZavLDmXuacV1XYXMlqLOhVSAO54X38+tIwl5+ZRDswwIb+IDPdpQ3K9uHlKt0L3X6Y2bVok4l2JfE8iZg/pFc8cDcD592IKKn9urW7NznyYaNkv2dKTdA0ouCLwiDybcizRg45iy+M+F3u1I4tGGpHXaeGm+Tn4QnQJHOXs0FKthGyN/yfGxlBFpI0N9UZlaN5cGUWiQpPBN29DxRZR0weiJhZiZlSsz9hxurJ4+0VDobSUb1zEc4aTxLffTTPMHfwFfifGS54Fre0Y+TAneNNzJWDI8ToW4e1mD7zDlI+FpQKKhyBlXUCvR6Xkp9g2w4k9KmBdnhr8Tywhoafw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vernon,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.19-rc1 next-20251215]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251215090419.174418-4-yanglincheng%40kylinos.cn
patch subject: [PATCH 3/4] mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20251216/202512160400.pTmarqg6-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512160400.pTmarqg6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512160400.pTmarqg6-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/madvise.c: In function 'madvise_cold':
>> mm/madvise.c:609:9: error: implicit declaration of function 'khugepaged_move_tail'; did you mean 'khugepaged_exit'? [-Wimplicit-function-declaration]
     609 |         khugepaged_move_tail(vma->vm_mm);
         |         ^~~~~~~~~~~~~~~~~~~~
         |         khugepaged_exit


vim +609 mm/madvise.c

   595	
   596	static long madvise_cold(struct madvise_behavior *madv_behavior)
   597	{
   598		struct vm_area_struct *vma = madv_behavior->vma;
   599		struct mmu_gather tlb;
   600	
   601		if (!can_madv_lru_vma(vma))
   602			return -EINVAL;
   603	
   604		lru_add_drain();
   605		tlb_gather_mmu(&tlb, madv_behavior->mm);
   606		madvise_cold_page_range(&tlb, madv_behavior);
   607		tlb_finish_mmu(&tlb);
   608	
 > 609		khugepaged_move_tail(vma->vm_mm);
   610	
   611		return 0;
   612	}
   613	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

