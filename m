Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548A1C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 16:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327C16B0088; Sat, 26 Sep 2026 12:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEE96B008A; Sat, 26 Sep 2026 12:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216356B008C; Sat, 26 Sep 2026 12:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00D456B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:33:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CA671A06B2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:33:29 +0000 (UTC)
X-FDA: 85256458938.12.C9A2C5F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C749140002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:33:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KlVRrCLR;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790440407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=o9MXbZTpH7A14+YS2X7BOUiXMRcP5EMQ4evfdQo12B0=;
	b=ItsVuj/4l/TyZxaTy9SX5auWIYX9rPG5A6gPZC9D56nBisL13D0FBJxo7lzty6KwH5u9J7
	B+wO83mlEu2HH+JrRsBWgWbTy609P2YFO9LJaAtGjRTI4plGV1zvEPhBI770lUbDlGgMlR
	yFR0/DDSpsdZS3kEGch7f1XPeBmjyyQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KlVRrCLR;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790440407;
	b=3rcODP9aOlziQU8YQa8x43Y2YSgbShaHc3Ah47VVyE2YjnX0QDT5pN3LIVackoC97UZ5iG
	6hibuHrSATyOGtJxltMxoOZzoCC+pV0RLCAeuh5pDKIHCsXU4HoXy+4dd/T4fuDu8vsVMS
	1YuyuWTVRAxoniA7A32KWE5PC6Xo9M8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790440406; x=1821976406;
  h=date:from:to:cc:subject:message-id;
  bh=Xc4mqmXyIdGRF00RAE0TbL9TU95xsagceJS/KQl6m7w=;
  b=KlVRrCLRrUHok++OSoGVzATZFNQJcIg2MlGe0Ez/5xTJlJUmlS2edapK
   jcC7SQeqBJX9rIfsuw2/RfO5eGJSiNMq6C4lnCP6EJt6M0QZejvgQkehp
   FCrHRSW4S7S04p/pTAZjF0BpSx6d+Bk67u3KwoHcWpWvHCXkWVGAZSLCC
   WP/bDGy/ypYp6mV5or5Pxp5pGF5vt50dG/di/1B/OX5gjKcDycf88T+EC
   G+7XiF/WuoXNFbKEVeB6ZW701o9eIYw6WnZSrqNGGLtAxn4HbbT/1PHxV
   IZIvm0tdAhcAXIXGAWQtAOlc4VrxnkTJJnePobamTDWZIMcibcn307JGa
   w==;
X-CSE-ConnectionGUID: tQWU36dsQAS8L1tVTARC9A==
X-CSE-MsgGUID: XdNDnjtUSAiXhIjMa4m+9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="101725532"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="101725532"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 09:33:25 -0700
X-CSE-ConnectionGUID: P0AEcz5PT6ifZ56d6jHhWg==
X-CSE-MsgGUID: EcmS14TASEy6+k7KPaQxJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="273852166"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 26 Sep 2026 09:33:22 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAVKy-00000000LzN-09W0;
	Sat, 26 Sep 2026 16:33:20 +0000
Date: Sun, 27 Sep 2026 00:32:54 +0800
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Subject: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
Message-ID: <202609270030.Y0QVBPmK-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C749140002
X-Stat-Signature: kzirr47m9dmcot7m1yi7omkk3o35tyxw
X-Rspam-User: 
X-HE-Tag: 1790440406-549442
X-HE-Meta: U2FsdGVkX19b8FFYKPiaWEZy0ym9tUG6rdGRwLRyARgYON1Z/i7xdT3MA1BmRpkMOZANqhu3iY/4pSiZKV8pO2AaUimGz4dRWdg5vHQrpegVTOVYAZ6DZaeDD+7oU8XsMD8MRB7jxRxvo8r2StL/XdpmTCoSXguwHoI02CsJ7UiRu5rLfeqEJpXKmVFwN+34krBALYHIfaxXZmZzDOVy18Q7owAhpGWdFjw/7x2dvtd76boJjDI9Yo9xygPXkBt4MI29MyJ7WPgelohMdYbkKWtb/yGmMa0Alzk3i3r0OKqriA42wV1xSD5HCtB+bcqedHTnRT/ocUeQXO6BU6Tbdc1zhsXsCBW6q8OeAJKYzqEuwaTzbAjCMqErATrn84800D3Y3E5ceOLhRkBIDX9ymR18/Zo+pbTd+yMDiVbsOiKPr4Ed9u+rvSnjekb5Lk7Fk82cXjbRYTisqCqRZw7ZH+TB9eowRukxk037Blh6mlixeTA2aQaXeuhPMpNMmwspspr2cmED/gUDxh4tL5+jd1wchDOg4Q+tZPqP+1ICalXXuhXK6icJBgkYKXPL+6VEeDhsYau2llco+5HNs+MyYJKgiBjf5aOQl/wHKyjwZkHGCYXM+yCigb3tCCl0ZWCVyTbHRQK2UIz8Qpl/oj3TlTHESF8QcBwUqUsSl0LxiCjxAd9zM3+WFq4aGLB+YfoUV1drF17sOF7yeeI45ybSIY4HI4KN64osQA374TqC7CrVIvAz11SEdlNdgVtFxmwcKODJ2KDOS3ZJ/Zue59NjmInwRggfumZF6hRsGntl4iIDUEN2qep7bdtYiQE7PCdJNqHlYAwD9p7FqTJQ6sSm5ZeLhWQ6Q9FE0uTpIwHa/UH8e3mMZJLXlA9aGgouJiNTZzNnmh0wsbIhY4W5sSwmQU1aoRDi/3hcjCOxreRln4teCIOSm3EFXzwlH2hyX/C9rfUokG22zcWk0JaMKG/
 tDM14we9
 Bam6bs7Qk8VdvvskdguOmQ3K0o0HY3wIKkcDkV8jBazINp9ZT/ACknjSgn0CtO7nmOWw4zXc1DQgbekAp09z9wAHQzX/KFtMNh0RQYH6TjLuRJRlTf7kQyXcYUYGQEdJgfbGQ8C9K6jMZ/xOub3Mjz5rFiZjSIcI6lFYRcihzXe9jbBidJGmMOfLItMHoVI4vvAz5/KgPRZCIFPFr/GwhZ//1ZB4r7o7WexXVqS4CsUPSrz4iFEcVHmYOKHnw4A7AqS48nVXVe24IvsaHtql2wBwW6lbmj26vXLL2QyAq3t8vdrvQHjNWG2pwG+jPfh2Z4p3bhWND5AAYBKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   b4fc90c82982d98959af08b4320420bcfc01303b
commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/

All errors (new ones prefixed by >>):

>> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
>> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
   aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
>> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
>> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
>> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
>> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
>> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
   aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

