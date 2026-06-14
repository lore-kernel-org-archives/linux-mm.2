Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DD0CD98DC
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 04:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399A06B0005; Sun, 14 Jun 2026 00:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AD76B008A; Sun, 14 Jun 2026 00:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260926B008C; Sun, 14 Jun 2026 00:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14EAA6B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 00:32:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A68E1C3DED
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 04:32:35 +0000 (UTC)
X-FDA: 84877247070.13.A7F56D0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5E1661C0007
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 04:32:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h++d1cC7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781411553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wbTsdcKabIyQohejTSPjDg4bsyzeWwiLRpGSTlitJAg=;
	b=mWF13tKE1rlBEc0scRDs/MHr1OruTnrRuTVnAJQ43FniXG1mvVEPUkdskTe0iTpRnqqpXx
	eptcirJfOMLj2nMkD0uScmU48FjJfQmjt1h5TKfCokh+GwskiG8CGQ8OdIwER+oq9MFq50
	ES5f6q+2yiCuD5Ix8EZ88kLK6/XBAl4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h++d1cC7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781411553;
	b=IFSwvaDUGcqQw/OSnw2ueAuYnQbdEx/tCbRED/lzKnOi9x4Sirr2d2Kc7aWep0+uG59y36
	CNKh36E+/Nbm/ou5vWrCrVHIsPZkD+Dkbf/O6i33N49xwNLinmsY8DYz1H3cy6mzheZDre
	gB7ZkVLGOvY7N5BHJ49QUwByiLZbuXw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781411552; x=1812947552;
  h=date:from:to:cc:subject:message-id;
  bh=mcAUpQPzV89gY8Em0RjRj9LGRVt4Uu77gUkO07OzNcA=;
  b=h++d1cC7tp/ZgeUe+Zfiwg9gbgnJQxzHDh6B45dZyj1QniYHUjoPv4mI
   sA1WMgRxCnZa7scu4DdPrb4OoYNCb6ReNz7AJX1iYRWdDQXSHhkz/43A+
   N7qkJ/hoA54hPsMkR3I+UXjAjFvMiipIS//xM7B5bZ+gHboQt2eSL7aL3
   T4B2NK9rIt1kFclQ7ffUoDmyW5k7AcUAThXN0+4N05irEeflLQd9guYcv
   +TFyp5MBcge1i5OKS+oWGyNoOZxESc/TJ1OflmkM9ZWvYIvBGGpztPJNC
   LbSzG4P6DEJUI88vRuojVIQQAspNw4n4c1gmNXBkuKAxtStdogweStACx
   A==;
X-CSE-ConnectionGUID: XcYX1ZrqRraCM6BYcrniKg==
X-CSE-MsgGUID: Hdp8X+aKRPC3t2m9iID0lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11816"; a="93681834"
X-IronPort-AV: E=Sophos;i="6.24,204,1774335600"; 
   d="scan'208";a="93681834"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2026 21:32:31 -0700
X-CSE-ConnectionGUID: j79822ffSSmGUnXYNkUdXw==
X-CSE-MsgGUID: 2ap/MrKtSseyjQGSUCASqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,204,1774335600"; 
   d="scan'208";a="246061958"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 13 Jun 2026 21:32:29 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wYcWI-00000000QYI-1yWM;
	Sun, 14 Jun 2026 04:32:26 +0000
Date: Sun, 14 Jun 2026 12:31:43 +0800
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: include/linux/decompress/mm.h:(.text.get_bits+0x5c):
 undefined reference to `__ashldi3'
Message-ID: <202606141256.AcV2LO0U-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ish9r33scjfa35z9fw8okx9mxun1w11o
X-Rspamd-Queue-Id: 5E1661C0007
X-HE-Tag: 1781411552-238613
X-HE-Meta: U2FsdGVkX1+bFoVQ9icf76SYg3PVW+GHiAmkIFhcWap8ULtWmvJpsIIXJlBKVRzwE429yomPtSm3oxiAfiVpvLM6yE9d+HLuJCuvAs5dtKPv/XfomezwV9OxZ9CFbEaStyuUGshcNaMdOmriNK2TClnDC+jSTxAdBDNFgY8z4yfo9uTi0xuEmfirreZTDYU1ek+Bue88JYdwvIYpyeiuoC8p/+an3DkMkHGHP8IKNqpxiXKr33lnOrXBW3JnF/JZZc10zbbPp6tQsEX+oD+Tm+9lthe7orIqTXZxCZHvJcfDV4aY6fiUf90ouAJXGW8pEKvgh7KEKktMBDLtmye13aBXNLiuFPEzi46OLEC7yHlq8feZgmWQlc1vsbqQ7Q29bKjSa53wJCL4gJUeHiRXhUrT2XRv9WvKxAQC+MG0yPE67ov0SexaVbOIWAKgaiVlkcJB9HM1AAG8ctXnQglzDTMnzBJjPinyIqNgN0oBwyDGhY6CB3zT3ne7+xPz/TEliN88OGqnEu8QxMn3BsdSHx/TZ3/souPWdEfHViAeq45Ji4Pn/FCfqz5QX7nA+RiDKL4EL8EEyM/E0HWdASAyyKPlPfDJGGaDIKibGbBQQhHgvLyuBCdRqv2axpzxvgC+fMJfEhj9lFzkq/q+oL27ooZ/LMrkECO/p7DLn686l5OHodVYcQmR9KmEWNhDNvz6X/fhrrDUy9lJ4jx4VQTQ5rNUDFKtUuYMRguUauQzsdyHCznKGaKzIi+YS9CNYw/fKk/3xNug8Ya22XaFFhQjf6DRQ7jehVh4/6nkCQ9UINKAcMn4Pa12XRG/Z9EsuoBvqNipf4hnHfD/gVMZXXks6hsjqdi17OQCdW+sB5gQoVnwRgwPvSoPWvnQ3olN9lCkotuRKiu0cQhLnkibUqYZgOzfVI1v4HPMCLlJvkuG8jzAVTdgOsqkO3bkjLRGE1xDt7cs2wWNGeKNY/LkVUq
 75cMXBp6
 cK3+8q/2MnK7ldCanuyIwdp4iFP5nVe1fTrAVeCeIXf+usRED9N80/shP+po8jDIEDEXRn1NlzTFj8IdBiFaorJPdCTn7ZAIc2/JNu/FzSjOAOgQVX852PxVCloArKUOKa1XawwmrsmtX85HR7ToAhSN7roEU2+FXGMUeHg4+bqOmxOQTPp9ULimjaaATd5Vq98W0nAVVuzikQpUMYl4hxHJWyzyNkFsLcawWJ+ysq4omPFYACPdtseDl8PHrasJr2aQEq0lALvEJVBe5l5IsnrFacSYqHGK0Ub802+m83B8ABa9fdd6T0f7EGei5ighi0YmQ2HSnGgpFXEzTPnAgr2XnHJ8+9ifU+BVG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   2b07ea76fd28989bde5993532d7a943a6f90e246
commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
date:   3 months ago
config: mips-randconfig-r052-20260614 (https://download.01.org/0day-ci/archive/20260614/202606141256.AcV2LO0U-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260614/202606141256.AcV2LO0U-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606141256.AcV2LO0U-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `get_bits':
>> include/linux/decompress/mm.h:(.text.get_bits+0x5c): undefined reference to `__ashldi3'
>> mips-linux-ld: include/linux/decompress/mm.h:(.text.get_bits+0xf0): undefined reference to `__ashldi3'
>> mips-linux-ld: arch/mips/boot/compressed/decompress.o:(.debug_addr+0x3a0): undefined reference to `__ashldi3'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

