Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02179D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 07:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8046B0005; Sun,  7 Dec 2025 02:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B0A6B0006; Sun,  7 Dec 2025 02:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFD26B0008; Sun,  7 Dec 2025 02:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19A8D6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 02:15:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD3131341F5
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:15:08 +0000 (UTC)
X-FDA: 84191813496.12.3DD5777
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 65D9D40003
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:15:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EnXz7Iev;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765091706; a=rsa-sha256;
	cv=none;
	b=qwznJAF+rGfV7rIm7MrbVXZLnVGOR6SSpFm8j2wL8UXMHkIrSUMMGsx7w6ORkKh9MWSGqv
	gWAb1Cwpj69tIz55y026GO518ZQvCgaIYGKoLyLd8LnmAM2l1mVNpUBcVy/2/20Zsr1XcV
	FBWInxhnJN2tMfI1B6OMF9H7aPwHbqE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EnXz7Iev;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765091706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DGoBeiZIRyOw0karqRL3sdRLEiKZKU2zvS02dSYEWRg=;
	b=E24bFnJo0VNJm5xdpEs3diK9w7ZFKz1zWVuZr5tSyKPlkOguqjJKp4kyMCEMLCKbJnFYm1
	n0Is5Hhk0HKSW9HqLvOmioLmvw2fEuBAfb6Hbk2J82uD8VSt3hw3tLbYSaQJmQla3GpSqM
	CQNIc4R9WxZzfxjXUN989R/AihPDZA8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765091707; x=1796627707;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oOn2WmfklNsNTh6AfKiWmYcYPyNgBrwjdZ33qXIS2eo=;
  b=EnXz7IevlEBcKycVQTSiMaCZsNkSndoHoOfueUQSliZT/mp3LakH+UNB
   9/fS0Zh+Yof1UJeM4VnNkw2+vUzFkm9175M2+bMJU8jXc/NQJ8TH11dWY
   KMpiYeZOu1Ne98CJ9qvt9nIFz4R28ehPha4E9jkO6p6Qt14RtnYCPWNSD
   8B4Wh69Ly9Sc2WZ0gZgDhn6YMEW7GAVff5nk4ft95MM1MW3lySkLbTGXx
   SzxM4ioZjyzRiCeBrSbIUdbr8AYGX5/VyjGPoeBIC4A0kjPMsgs4srYLo
   Xsf6SeG5lA98Pg+nHlETgv6ebrsm3u/CC9Zua8xrb3tW2JtHaOcdP7iq3
   w==;
X-CSE-ConnectionGUID: pU8K8IMeQpaKtlogwmA6gA==
X-CSE-MsgGUID: fzDGmBjuSWyYxf+z9bG7zQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="84474731"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="84474731"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:15:05 -0800
X-CSE-ConnectionGUID: Nv0bbilSSVKe2d6dcxC45w==
X-CSE-MsgGUID: GSASqY1yQleSo+7nI4fMag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="195726085"
Received: from igk-lkp-server01.igk.intel.com (HELO 314ca7b3cca8) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 06 Dec 2025 23:15:04 -0800
Received: from kbuild by 314ca7b3cca8 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vS8yz-000000001Av-1UFI;
	Sun, 07 Dec 2025 07:15:01 +0000
Date: Sun, 7 Dec 2025 08:14:27 +0100
From: kernel test robot <lkp@intel.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 52/72] mm/kasan/common.c:601:21: error:
 'KASAN_VMALLOC_KEEP_TAG' undeclared; did you mean
 'KASAN_VMALLOC_PAGE_RANGE'?
Message-ID: <202512070858.6Mhh5r5D-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 65D9D40003
X-Stat-Signature: jdci1ss7b43re5q75id6dw1cmuao1e73
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765091706-560757
X-HE-Meta: U2FsdGVkX19DG75WOxotTJsTe8WRLm7wILr8KdrkTt/Lvugd1npeCjULyH8fwCNCQKTn9XDg5ZMG9oiWZszjHC6lihycjE0yLwNX8GnIs27JD4LWj6UNB3MoQZi86Uea2t+VUwByr8TAqc+5qDDsh/sNOeAIOXsDrSE0r8OhdJNjN4UbEcAOY45U0qenTF/7mkfGVzA8jtf8GBA2s1NSt36aByan6B50OkuSOYAosoEW2S/ljpyzOvwtbv3t+mIugtchUBkTdLIdgWjI7LZgYDNkQxji2FAB3RgoXgbe3WvJVXW+WoBClNIw/HRsDNOQiGMJhPJ+S8WHPP3kAI+u3k6ev9V1wT+JyIzGE2dJ+3IRVC3P1rv7+WCZmC/7D5coTyFf+CeivB21f7qoUimBbbF2Szg8Cdwl6DlJaUy1TnAcyzNTScHQnrzvP0RQeyYaOBZzz9d1Hq/Nrvlydvafz+oVGdeLKtPL2D5pzs7RYb1nSpvCVetwpMbJRPbN2yx6+7cUVB41U7Q4XRkOY5ikkx6AXSPCMVfi8Ox69jCD83k/rmn6R3wGbNNWhUKWuEeRmme+tfe2G90DDA7Zup4s7wcQLB3QckIrkLHfu8YrGwm/HE241Vphd68JwvCoW8sFHey3J7Qnu6diJvvIxhlhL2RAcPfIzGcACr20A12VaH5AAFgt6vs3ZnUjFFDhk7d71S/7eFs/xNDwU0Q/Ipx0bW0m+V8WYQsL86mfNFuxs+uhtVcqBxxP+DeT3oKds8vKJJVnrYohn/7eFai5AGQnVR542+3Kj0hYE8O4cmRc06MGbdkYgFLTd2gltxTJubI9emkAUbkFnw4dpBXbUWJX981VbUHIpOpqQpV0T9yZI6prcvh81PSU3Eqvyqf4W1aP8p7wHByC18SzcBNbhsh8bRUQn6l8S1ANoV+ghP3xUl+b5h5QczhCTGSsrTBnVwloI65GZxSRKUaKmjobT9o
 Rjd0GoV7
 QQJXcRpRNyyvnVcBz9by68Qg360gSxpMBCIHOp1GA5Qlp3IqL/c6J3FAkF7BIZWUglWC3os5StfSMda/V2JH2F0g4BuVcnLHHvxlspWYDLBvjRM1aA7vpX6Zoa2/IRI6vEslFGCsNExxpFgqrjKBidYh3B8CZL03C2Vz6Y1pkxJl7oEunYDt2Cq3b7Tv7sDehkw4f342qSCK05tKIUjcc9HTvk7Mc3icUWnt2piTe8NqCOXJQ9oKqe1HAjiJCViAzRoq7h7lhts2xxSQjtfbdmVcA4A9VP4upqHnLabiDe75Q//r74x6PdcMzPVygIGvD8VsGcQP9eScXTUhfWih+yE/NYPz2YfgoJ77TskduDuZaLH7oQ1qXdDTUjoT/hUm1iYKC0wKA+8gOUkn3mX1jYSs1ukmwgBAjFB3O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   ecc46e02e0abe025a6e840cba2d647f23fd1d721
commit: 6b83afdcfa935db4f836906ca7f0fcafdca8d229 [52/72] kasan: unpoison vms[area] addresses with a common tag
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251207/202512070858.6Mhh5r5D-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251207/202512070858.6Mhh5r5D-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512070858.6Mhh5r5D-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/kasan/common.c: In function '__kasan_unpoison_vmap_areas':
>> mm/kasan/common.c:601:21: error: 'KASAN_VMALLOC_KEEP_TAG' undeclared (first use in this function); did you mean 'KASAN_VMALLOC_PAGE_RANGE'?
     601 |         if (flags & KASAN_VMALLOC_KEEP_TAG) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~
         |                     KASAN_VMALLOC_PAGE_RANGE
   mm/kasan/common.c:601:21: note: each undeclared identifier is reported only once for each function it appears in


vim +601 mm/kasan/common.c

   586	
   587	#ifdef CONFIG_KASAN_VMALLOC
   588	void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
   589					 kasan_vmalloc_flags_t flags)
   590	{
   591		unsigned long size;
   592		void *addr;
   593		int area;
   594		u8 tag;
   595	
   596		/*
   597		 * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] pointers
   598		 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
   599		 * KASAN checks down the line.
   600		 */
 > 601		if (flags & KASAN_VMALLOC_KEEP_TAG) {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

