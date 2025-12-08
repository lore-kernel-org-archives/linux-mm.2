Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56081D3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 12:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722F16B0005; Mon,  8 Dec 2025 07:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3B76B0007; Mon,  8 Dec 2025 07:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9AF6B0008; Mon,  8 Dec 2025 07:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9C66B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:08:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D904C6005A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:08:11 +0000 (UTC)
X-FDA: 84196180782.26.8603F9E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 57DDB1C0021
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:08:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S5CPmBtl;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765195689; a=rsa-sha256;
	cv=none;
	b=eWgsMOwU9cpTNg89V4GSWJP/ySVeJpUSIXONwGyd0cv+KLyBEH/aRuhW7Nxpqr7asDXMv4
	h9i1EW0xpTxAQ70Wpg9GIQSOoyiSQTS4W3MHYFgeLRO6b6BKdxtfEHePRYnZhjtRY3kl48
	PwwwuVfVkErLQxwtHQ06Ga/vU7POY4Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S5CPmBtl;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765195689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yBMNTLrTCxFlzfr7JQ2aDnZ06bn0nrbw89Nrd2rFjNk=;
	b=uo+cW5+ONyI9+5QQ/d0tTtOwu8lxa+kNpE/pfWl02irlgoc3fsPqYK9jSHRKAUq0yulvmu
	iYYZgJX0G62FExoAsGcBYYnzMlafUI0HGHM6I4ZznaK0Zx0KGdXi2fYslVTfcY2garl3yj
	NTPRGmpngphH33aQKjTG4HCQl8yg3VQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765195689; x=1796731689;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6lLM4kv6uoEq2E1MNZZZuauSNtK3L1hPhYSD+obOpSk=;
  b=S5CPmBtlBDZabrfuZpu9zAXoIbPfC9Y3Lf/S7VMGs9XNF3bA3414Ijsi
   sR6fmiiHVJwZyhxKlZNO5rLKe7hSlWYU1xcyIDk7tNuOLSQM1lcNpUXUO
   Dqw+qm9+t31Ws6t/OwOZKPiCKkojudNg5GfGF+dmyz4nFfvDwTjZqFP7O
   d7irawthaLiqOsxNBpwHUE6O0M7JpLN2wk5DibdpnOffd+o1AWbPQ3Ru7
   SFANuV49smfZInwuso3Ub/0PnYZTwCuLcdyxRs90/+LKbzAlmwNTik6bI
   /yweB4bXj2YMCTXao/XoJixPyJfD0rWyFv4qSmbHXjQ2ghVvB+nvqVaOl
   A==;
X-CSE-ConnectionGUID: a/WVRVwqSbazHzPKUAK8/Q==
X-CSE-MsgGUID: 6gjFViKRTkq/h2g9wfBMeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="66318093"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="66318093"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 04:08:07 -0800
X-CSE-ConnectionGUID: s/eJmeAcRZ62oUDptcorDw==
X-CSE-MsgGUID: LVAA6ifFT6+az/Jjt8E2iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="194976726"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 08 Dec 2025 04:08:06 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSa27-000000000G9-2VC2;
	Mon, 08 Dec 2025 12:08:03 +0000
Date: Mon, 8 Dec 2025 20:07:09 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 13538/13721] mm/kasan/common.c:601:14: error: use
 of undeclared identifier 'KASAN_VMALLOC_KEEP_TAG'
Message-ID: <202512081926.ICUawXRm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 57DDB1C0021
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: po8xkuyc7gc3icu5dbimckf64y33qhw5
X-HE-Tag: 1765195689-623142
X-HE-Meta: U2FsdGVkX19x0sRLYHeRy6ZdytPuvmKVtQ0CSiFEsyoh0B8NhL7nVr8B0+le7X/AB9raiAo/pn2dOpIPdtOpn+pGBi2rbMnsPaQSMx8osY246k/Q7D1X0sz1JOeonBsKQMd90TbXvd3ettDqM1kGlOI3crqFd43oBXqXceOGr31euaKRI2MKDu/AaChb48VacYCRdE89P/LX4uvriakCCy/srb/W2rNIhsF91yaOfrovyKp9zg+AYmXOFnQ1fRsgQNvpY+kB8E80y750ck8vvxwiOlP+pK2pwBLQFJx4G/6nmfKbRvYdOUGDdRZl5eQIItUK3wb2B3Jvson6Uu9SsOQyd/oVieCNanaJ5/9qrtWtbEB84qxPRscXxV5V22BS68/vucDitKQyqaoV+Ok9nqGrRAZRdq4NKTSds3K5u1QVdaZKFCHCG+8IcCXTYYpcsl+gBllZPI1lypcosD16eO7D4z8M/oTd/vdaAF+pysi8mO5ACETyb0HSs88YMGfjbDL7fSyBosiop6dfWbQ6J8w9w44FP8ohFWRKAqO2egmQ3mqmS2bhZXF+TM33S4T+6xHk8zLjbM7iCSeGG7Ew7acxtPr9zmdiKRhYvX+CdybWHjF10tJXMjo+2r73JDobvDr03OqL6ukKaptwb3B0zmaZ2sZSy0AMFssh/r5beZU0UgVDLtqG48FHlCvzqCj/Pfq9jKunJxt7KrSPE4U8Gwk98yZ96Xie5ivA/lzFQWPwFpG/1zFrKXgl2lT0tanXBRemdrjEoO82z2WfyCZho6CRfCLlxGOnBC3ybgYlgXwAqAcxrxfZCHVAR1HQhRPBl0J6lEVprTf2Tr+49ixFRsBGjrag2mUhdFQ3VEbgSWGhYm5CcxSY7dC5JX6gjE8Ey07j8llBYr8PgpbBhYhtlpA97mmC3x80qHJnSu7Bp0tZYNXV7Ce+rGdJXQ80SkQBf7WSs23xuXIR/xb1fRQ
 U0JEi0wV
 uuT4TB7/Kz6oxLICDFkG+g1eL5uwD2HECjS9xHxa6AR41jKXUFeW11zRndw6104tk4bbrTyPGT8pjqnJM+X/Hr/wcdlCKSgxUl4bb9mr4l1zTLo7tSDJvGVXfDlTv4q6V/ieQ2Uli0n5mehAt+4ScO7oO5iKepn6rY6XanwyvHe8jLbW6tnx2e3iUY3g8hENWXyrZCDwQtIWsdHzQHBY3acymJuDYqr55ztWP6SJS+GlD+r1UfOX/9YUbxVbcBjn2tEHXnxntD3BNnL3pCLtHYDO4rHF382ZKcH9M7/IhniF2j/ReUUsWXkvKfe2ZlX8Hill44FuvoUJdOxmhoKqAPgnyBUeER0EKxddQX424v26m2mv6jJPzyb+VWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   82bcd04d124a4d84580ea4a8ba6b120db5f512e7
commit: 6b83afdcfa935db4f836906ca7f0fcafdca8d229 [13538/13721] kasan: unpoison vms[area] addresses with a common tag
config: um-allmodconfig (https://download.01.org/0day-ci/archive/20251208/202512081926.ICUawXRm-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251208/202512081926.ICUawXRm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512081926.ICUawXRm-lkp@intel.com/

Note: the linux-next/master HEAD 82bcd04d124a4d84580ea4a8ba6b120db5f512e7 builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

   In file included from mm/kasan/common.c:17:
   In file included from include/linux/memblock.h:13:
   In file included from arch/um/include/asm/dma.h:5:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
>> mm/kasan/common.c:601:14: error: use of undeclared identifier 'KASAN_VMALLOC_KEEP_TAG'
     601 |         if (flags & KASAN_VMALLOC_KEEP_TAG) {
         |                     ^
   mm/kasan/common.c:615:49: error: use of undeclared identifier 'KASAN_VMALLOC_KEEP_TAG'
     615 |                         __kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
         |                                                                      ^
   1 warning and 2 errors generated.


vim +/KASAN_VMALLOC_KEEP_TAG +601 mm/kasan/common.c

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

