Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7910C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963686B00A1; Mon, 29 Jun 2026 07:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913AF6B00A2; Mon, 29 Jun 2026 07:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4E26B00A3; Mon, 29 Jun 2026 07:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E64B6B00A1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC3DD1C68ED
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:48 +0000 (UTC)
X-FDA: 84932710296.02.D84C43E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id 048E61C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CRGWzNr/";
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732107;
	b=fY4YdKLF8ZvSqS1QUZixtWyjv+ZH6LpZcJ0+e/lcrDxCGMLxeayWpCcovEavD+VVBE5AuE
	wQynXrU0jTWmeVIQIX0XpgW7inPgL7rjhL/yH7v2e3JIinQxcJfHmpGRCzh1FOFD+3zW7+
	j5J1iGk0T0XhrIm9oX/aZWT1HDe1NIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=zUtd94ayvRXOVOfOVqQN/PYLWnqaJL3rDBL+BA6+o/M=;
	b=aLzdPmHQJGk6ipXe/Fhy8FYgBXiubw872VGRMYhh1OQ188Gp4TrwJAH84mlzgv03PCn+Zj
	/kk/aMWyK/MGDn+8MaOvxSH/BSJTyK7x6OAkEddFzENKr4rcm2TVO/W24F6a65CF4QLy9e
	y1FAr0PtkXmZRjn2mFDVNPA5Cd43iiA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CRGWzNr/";
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782732106; x=1814268106;
  h=date:from:to:cc:subject:message-id;
  bh=5LWEXxUWHTCSVKsPU06YRisBpoOzrLgoMx8poq2lJhs=;
  b=CRGWzNr/qbrqETBlEwdZAFUNU57c5VRo1PJQQPuzEuv8kDx2kLsJj0Lw
   t3kdmdeCw1/zyOhL2+MCDF0Trn97YHTr6QOYSGVfMIBQxMPefZWZvix9O
   4Edh4qbfqtG4LTA2E1b1Anfl9ooQborOWe00qD9KIxokZaBLZehLlBXw3
   CkTzmwBwlyFb3tND0JDdQMsGc1R6JfNj2DsWFqJq1wdLB/pi7i+4ZEiPh
   uVmw+WqDOKmUBiAJwX/9g8aRKWaYsHUiumuvYetFuFyc1IoKK2gRkTFeZ
   NBsC3M0A8Cq3eKDWwTwzeDpVNeccgH0C8otT6x8D4iJjcaEEy/UYOW3t3
   g==;
X-CSE-ConnectionGUID: P4erBHL/Rfy5X/XrZUYtjA==
X-CSE-MsgGUID: 2SvX6lMKSlmIKrd/CzSUvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="87323615"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="87323615"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 04:19:03 -0700
X-CSE-ConnectionGUID: oup/CHX1TU+U6w3blX9YZg==
X-CSE-MsgGUID: M6uJRUDKT0evHSKxIi8TIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="250865264"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 29 Jun 2026 04:19:01 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1weA0v-000000007Kv-3gAR;
	Mon, 29 Jun 2026 11:18:57 +0000
Date: Mon, 29 Jun 2026 19:18:51 +0800
From: kernel test robot <lkp@intel.com>
To: Wenchao Hao <haowenchao@xiaomi.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>
Subject: [akpm-mm:mm-new 107/142] mm/zsmalloc.c:800:21: warning:
 'obj_to_class_idx' defined but not used
Message-ID: <202606291933.Cw5TBs54-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: ox1f6bmp1nxq5q8qm5hr3g3heew7pbpy
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 048E61C0003
X-HE-Tag: 1782732105-652793
X-HE-Meta: U2FsdGVkX19QEBF0nNDDvtd2R0DwIUuOAqq1RpTChVtK8IrQ9Pvmmk4QuVslw90DipYSNm1PDyLKD9Mk+PtS+Lds3szgnAPgzRnklfPIhDbkW9Usqw2UM88ELJCcZtbqv0tDFjZf4LBSollu/5ZYASFKdUrif7xr48QL40JpRShzQB+7ROHE1i8qP8TPMGrbcRJDduEjhMiziFnUX3gqU/+p6sby/KHOcgb+pupeNSl5BC00+SAGP5S2WwZ0QiWQsuhujrV/f0zfHNJHdjX+u6YTgsQS7ldaZgcBzyqE6zW0nNcaoC0X1oeYWwwy+aW8t/yAaKoEZPI0nwtJ9rBxlEM86VZJUJMGbB4OZ8gcFCnMXLfvXRndnfDPst7LRuTubTuerbGt3070VP9x1SdxPnTVraK7Rl8LKdyOE29Joqiggi5BsaHJ88FZHhlyOuSN7CWsUEdxtw2eTZPnekwtpJizFEAbjo8k2Lw3Hif1qEapoBVbDmzB/6VMjMsXcfxZsCJuFfiN+CfOZe6BdOub0dJZS8sInNUkjM62/ZX1bzC9w8I76IalxOXf5S4SjwCmg+sY0J1GGW92rbXP1einWSCFaG8jaudVxjzwrxqv5m3GLofsPMbHOVtDadDPDjP63+SzhyHAKtN/IMYnnNwOZPjd10xLz2D4e1qWHsF0Qyk0R4FCZseH4QwbrtEcQBjZp6E7wA9UhKhxMg3S2IQ2B4i2BL8CH0eX0plf2A9lIcqa5H4i+b/hVhf6wzOhR8Qn/hG1/w5BY3ohqDgOK1azn52YLaLdhZq0S4W7GQdGCTROT12HZrWk25oF60qjz7G7i3cQaH7GBcpumQyyRsbBxALm/RrLSQ2jiNIcmRXOqM+XoNdn4g7sBFC91PcooiM6t5WeYwgNezJWzQcF1zIcW3d1HH2zGRgtR5qpmmGNQH2vdOUxjBwPx0w4QiVQz/5SAfJopLKlS2I5YTQGyfW
 0c2ZMTCR
 k2wHBFWJmZqSuPjntIyOLZpj5h5YJ+Eg4l7Qlueo6HMm4Q5JTJ7x/x13Lh9Z02FT2XW2hRj89egAtH6FQv3wjMSpVPs5IyiSuGjv89qgqV0bAlR34GmHCUhCeJWj6hRV9juBKHek9hfRd928PSFWa006LmsHzZqEtVIu/JdVinQDKm5onNAtanOVEXsEZz57LfoXDIslymx/wRUO9OsS9IcN5DSUUX+grpwS0gqSMqvOLYXPNCGOLLxpAR/wjxOv1tvXyAoDV8pTjdu3LQyaNPMKnc2XYibMX7xfL8tvsStZDezbzDEmGhG+iVix+6b0PY0yP5JT8vJWA9Ho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   88cefc306c43b58d9bb65c9e96e284306710d961
commit: b3a8a00229ce2b0367afff075a00d53b92e1234a [107/142] mm/zsmalloc: encode class index in obj value for lockless class lookup
config: csky-randconfig-001-20260629 (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291933.Cw5TBs54-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/zsmalloc.c:800:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]
     800 | static unsigned int obj_to_class_idx(unsigned long obj)
         |                     ^~~~~~~~~~~~~~~~


vim +/obj_to_class_idx +800 mm/zsmalloc.c

   798	
   799	/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
 > 800	static unsigned int obj_to_class_idx(unsigned long obj)
   801	{
   802		return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
   803	}
   804	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

