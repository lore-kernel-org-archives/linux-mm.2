Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 602DAC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CAB36B013C; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C136B013E; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B93A6B013F; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10D736B013C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:50:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAA8C1C6E3A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:43:40 +0000 (UTC)
X-FDA: 84944559000.16.AB51341
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6A67120002
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:43:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PxMvIRBf;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014219;
	b=CageVnSUP0oZH0ouby/b+HNUvgFS52o48Tu+q0/b3gCS+IcFS9U6dU33bhlcgWvjwCTuD0
	DH/3qarrYCmz8Lnx233oYq/W4L8AMcp+Sa3NwcqzC4waLGfjSzPLDyWXMvET47Tmkf2Axm
	132lDtUguQ/ckP6UD3+PASNjwO2Busg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=fmVHkjv2MM9+6eB8Ztw4ftwrH2iuE6q373EWQ4BEoEM=;
	b=s6iiQ5lSo2Oc47YDh+iPWC2CBgoYkAcvkdIgvkvg96O7uNN26oCqKO4yenKSwkp/qO1IPN
	Sga7vHEl5jRLKuCimskRylo+l2iGByH3HoLSOvQEKOl+JXTfDnrEYB1nLyGzl11pT+Mvp1
	w/i5Ay/04lNdF0peUn4PP0U2HNF2e48=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PxMvIRBf;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783014219; x=1814550219;
  h=date:from:to:cc:subject:message-id;
  bh=QEGMOc3SpuqbmNd6M2wJK5ocPmc94n1B/IOdlFDjgHY=;
  b=PxMvIRBfabhdpoXYPLrWntrXrcNbWkqcSphV783gDxH6Mrc7Nx1VzjdO
   e0E8m3LM6GHxJJwcO4b5zb4ChQo+aLxRylxKXp5flv1qMdAjoB7WSKLyw
   9UtBhTNNhYiEFnRw3ODyXVfp4MoNjiTEdJZkDSeBtmkLAnzEyqu4O8gOG
   dckT9kLlrCVm8R715SYzhab1s8PhLjLQzeqnvLFqGDM10pvCDRIrpOvQF
   NhXxli9sFyswbfnhfPa6Dl/HQEgU4Xc/L/96PMIULamGxdV6TceRpYUH2
   1ZCNfH3XJPn8BjerN62ndev2PIXF6sT1QKuLkRo4Q37utvjh79bHeVtpN
   A==;
X-CSE-ConnectionGUID: ZoW4cdQyRxqZr56ipGAK3w==
X-CSE-MsgGUID: 0uVinNUgQd+wBJzMQ/lMoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="87688604"
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="87688604"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 10:43:37 -0700
X-CSE-ConnectionGUID: 7BhZeXN6RvKxoVjeSEDdLA==
X-CSE-MsgGUID: 7JE9EWfPRHKgCLJ+37a3Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,144,1779174000"; 
   d="scan'208";a="257263034"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 02 Jul 2026 10:43:35 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfLRj-00000000B2x-1n7W;
	Thu, 02 Jul 2026 17:43:31 +0000
Date: Fri, 03 Jul 2026 01:43:00 +0800
From: kernel test robot <lkp@intel.com>
To: Kir Chou <note351@hotmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, David Gow <davidgow@google.com>
Subject: [akpm-mm:mm-nonmm-unstable 59/59] WARNING: modpost: module
 random32_kunit uses symbol prandom_warmup from namespace
 EXPORTED_FOR_KUNIT_TESTING, but does not import it.
Message-ID: <202607030125.ziX4WI61-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A67120002
X-Stat-Signature: 9jb7ospycr8am6jipfgdeuhmnto3aiga
X-Rspam-User: 
X-HE-Tag: 1783014218-450029
X-HE-Meta: U2FsdGVkX19m5qUZ5YzaUBw05wW54sgN/890WoU7XTYfOVLEXPquF+a6ORyOg83KTLTOA/yJSGfA5j1EBdais1b3VKYpB3NDBLyw7U+jWLMv2qU5SkGfUCvCEzAgAdwhUepcTH7jyGuDWPRQIuB4vRn7smYovt/zYGEBeAxPnSuJqos9nuUJBYm2Nr8ImdUCZuxR0uOkHgyJJ2Ca6WoQpHhu4Q/QFaofIyPOqr1kNtWfyBjybMcRFhMIbUVk22FPf28dAgvxk623WVP7LMeF1FrL2HBgGdssDgJWIRyjVtVEJ+QHWlyoux8igyc/60W9VORhLUJF6+m5hvLdUa95NpOT9oPj/CNkNZ8rNTQvQTpyLNAIZdlB3BlDM6Sjxc9Oja/y3iWaCkzhPhSzOVmjzdL8+3aC1cLUnsI14QxfnLMos+DYayJNWh5rQ5PBM/mAqThyAuKuR4uJL1pwEIxCP7UYjR2ZpaYizTVr1mVy10NScOSvFRgR6cyptXizHHtWoQPA9QaS8N0f/5gvHwlWTqKC8DknEnEolVoj+fsHV6gN2iepON0Wphu6uXBL0XVnIr5Ihirmks2xJPUZQWLCu4KM2D3EKPH5+5COsW5A/tiK4miBDrlAwa4GA0XAdYnLxXqu+TJjlrvYHWVTooaYUw8acO4EEM7zqGos8YAanGRmbV8slma34x+AnEsl4bv8IpvXW2N/09aDfO12Yw7GqlNL01MJqDw+/VXwsj93849dhSqi0Iy0rSxSH4I0Xwr4EY1S8Tm2iKXfjMRvwlMMHPob7KvqODHaEQl60JwzTgh2FJJDnQyg3W3VAxAk4VjjBLAEYq6n+e+CHRRl1duCBNrDkaoGJr9N80APHc+8gBxt16dl7N2hBFFU5Lp0JDynmw/AOVQbAIju85NZ1UisTHgTAGJjJncc7KD1pkegJZOm2hZ4rn12PM5hHUXTccDMHvo0SWksq0bWHoWDhnX
 4F1G/Xdo
 U+4c4vmtGBT47AFwTsu3PO807LbyOVmPvrHNBnWDWd3bJwz1eHSpUdHAIhGi4lamHpKiFrAh7/4jDDJJRIP8zz4Jc1yCbO6Yd1NrlLyTuOGKY/op8Cyu0ozs45j1skB2fDoTsGJQPNYZbKlGIyq9cqZeVBRoj9n7B4ZODATIWldr40mJFaOZLe+MYU4t92uQ4vSNssGtjiwKsg7Oh96hRNkWuZ0VbYDvby2eQ5xt1wg0lDUxo7W3xvIbggXzxFBWfuTrHyVK9FazgbJ5BkGc0d2ydtsHZAIIiyMUwso3SQGz/72KNPYh+s7i4GXKgtPk6YI/MOqly7GIlE6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   2ee1282ed36ff65ff425a4c6d3121bd701dcd547
commit: 1f9afe351aeb325ebb94489d40d8ab65f30f8d2a [59/59] lib/random32: convert selftest to KUnit
config: arm-randconfig-001-20260702 (https://download.01.org/0day-ci/archive/20260703/202607030125.ziX4WI61-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607030125.ziX4WI61-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607030125.ziX4WI61-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: module random32_kunit uses symbol prandom_warmup from namespace EXPORTED_FOR_KUNIT_TESTING, but does not import it.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

