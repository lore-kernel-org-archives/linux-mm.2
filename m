Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32D25EE4997
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 18:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971DE6B0088; Tue, 30 Dec 2025 13:24:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FB46B0089; Tue, 30 Dec 2025 13:24:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DA26B008A; Tue, 30 Dec 2025 13:24:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBF06B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:24:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01526140184
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:24:50 +0000 (UTC)
X-FDA: 84276963582.08.C2D9339
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EDEE100002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:24:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JSpKrliv;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767119089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=uQFrgilGBJORL2w9N4rhn7kj5Jinb1a9MlRGqRI3Pk0=;
	b=TiE+vQT7Pt+ppWhkyAXZmKEY/jDflYOnyFJ+2Sl5aJ3FpsFxQKQdbjLGXSMn8DBTGsGGP2
	hOWpMKUgE5tWTZn6V8VAsw5Wik2gULphMLzqm+qCMmfODwd+e2szXvv/2IVs3Gad+OfCnm
	3Rb/tvBgx+wCMJm7Ush3AG/qsayvGMg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JSpKrliv;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767119089; a=rsa-sha256;
	cv=none;
	b=5FPlfUMsIjdLCLS9pGHgGwQx7BVGDcLNaT0XxZFaCqcDSH4kD6cr3uDBzuhzJYvwr1fpiT
	zhytd065zvqdkYLfpc55pu3avRnob5Q+x9vXpeN4bNf0P7hO3qU7D5d2S1j/+sVuW/FyRC
	rKUYR1XRpAF9KBqPzFINRpKSHxO1318=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767119088; x=1798655088;
  h=date:from:to:cc:subject:message-id;
  bh=cHvRSZlVUMr+b2MgusEI/XFX3df8wkSK6guuRDpNxsY=;
  b=JSpKrliv0uHPkDrPYQ7MZRiBp//1DwFgo/9hDV42chY3Dtq/KSCPskkm
   0DMLXibp7A1/locW192barqMyR/RHC7B3/405UU6f4cHnctC33HK+3Qm3
   Ih/QPVWplo8zP8g7v1EGWwPVuhx1t9HYJbxwwcZP8jg5NqL1727dzlyB5
   rf+GDXSeP6QB+ZGk2BxFmnAAWIfaO6xgz5JhM+3AaYeJZDj5Puvcz24lU
   9y8/rSGtEgiv/ZEicJr/0yVZoQKwWms6qZn8elsZrYNi95VpuQGmbNC5n
   Tx77vbCuxGwyo6Z0aj97Ry14BIiwzTPtnBtNzv0Y2kYB9LOFNzetHYDLh
   Q==;
X-CSE-ConnectionGUID: zS/8GnCwTX2bplc7tSQn1g==
X-CSE-MsgGUID: J+8zQMK6T5+At4iqOVGzmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11657"; a="80158483"
X-IronPort-AV: E=Sophos;i="6.21,189,1763452800"; 
   d="scan'208";a="80158483"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 10:24:47 -0800
X-CSE-ConnectionGUID: UPWkG/5hSmCS4Mzd0gDgkQ==
X-CSE-MsgGUID: oIIV1CvYSv24V1a+Jpw2rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,189,1763452800"; 
   d="scan'208";a="201151764"
Received: from lkp-server01.sh.intel.com (HELO c9aa31daaa89) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 30 Dec 2025 10:24:45 -0800
Received: from kbuild by c9aa31daaa89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vaeOg-000000000c1-3e5q;
	Tue, 30 Dec 2025 18:24:42 +0000
Date: Wed, 31 Dec 2025 02:24:40 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [linux-next:master 2254/2671] ERROR: modpost:
 "arch_enter_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
Message-ID: <202512310238.ViLCpEnx-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EDEE100002
X-Stat-Signature: a63d3ah1scz4ckft96fca8i3kke8f7aw
X-HE-Tag: 1767119088-511604
X-HE-Meta: U2FsdGVkX18Dnu6YdSQ2MGiQBJcQKWLL71plKxbgVvt0rHCW/+pUuKHlGeGWFVuaa/XO4VkXqTwHm2soVVN6BbkVKaq0Tt+dd5f4DN7AnBLyvqu5hxtZon3vA6qxfQ5uY2HOFHLdlAzZvzhBIe9cEy3wXLeuFQLUMNAbdwiGNMucRbZuY/WvbUtsIXFXjWIgJlHgezVlns1JxNfXpCPZwr1M+GKyfpfKWa/p+4i9G06hR62NPvHmSYihIX2eHBwQ3g4PKHqgkLklWu4H1D2pEm/TdpYH68GaICCtLhVzQNL1fdDCW+KU0tYTEKj8jiwETVcVQ2ebaH0GoFTIDFUIvfaMYxet8GTLKcqKL+gSz+1mqzmqmlzSxDZC7nd3uuz/5vjMh6okvNLG+hBYohKv9AHq8UR3gvKjM81HS0mxq3qNYS1dAnaac9bmD/E6EYrTzUd5RyJYb3NpJ5j5/J5+pU9fv+iDzTPAItkhua5CGHysgZGo+6768cNjGKfejsSPmkSW1R3ihKtSNQIqWZdhIok569vF90iOR3gScC3g5IxunuhM7gjV8ulTdg+GO53hoSD5bMOy9TPfxIRaCn4lRCA3i94PFKEyv7XgqzfCQ7CbQq858hHKxjmU5HZ4jl8DzEVU4W1VepBge90UW2Hq+mrKCOkXw2qIPact5bsBAc4M03KXg6IEtkP4shUQmPQHsDQyP6LuEjH+586Sk9ZqtCbvHvBGNIfVRO7qTUaHsh4sCQ51wcg/lsUp8IKURUIpwtflsTEccxTjqoOfN5O0KVdc2JhQhKiBYewjYlOXgcIWkIORsPTdPPCutgfr8E1VeoXzeGpSoK43re8CgK2kx3iLTGhu4cjZZ4uC31OC6+aNaDnAqVCiAbtxz+LHnzQT9JMBh4xQgX1/9KUyfZFtTVtfXgf6bH2bGnLHlHq+L9QPeZUqf/RKu1O8ubsbahr6NrOuqlabV8nKHWMG0kG
 hcyWIPmb
 NiVaZAqp8WSDVyxVff2FCzcKQ7vsUo01UF0xu/RVbFowuztFKgKc4l5ofk82sIqvsVRJjmKh72WCPc9OVf3lFG4/AZOQNzJL8hn2+jvNDYId2G88Jku5PXJCHE0mv2qZtx1SWQJZJ6p3glHwWD3eqKTWQvUIaZten5BhjVkCo5Or7pt7ZKS9fQkWU07tmMnceadmQpXHRM7E6CQtq+Eeo3H70YUBR3dA6sHbBCerixt9vZxYNccsHIZ5Ch2Dx6Hi31YLBXZGEreyABlq3ZR+aupYyoJv8+SucQBoFDbGRvFmzY9rDmogdlI+i/NUhTbRCvqBq4dMnQQUDQaApTuDxEJKHymlLYjOD240pA4ybjWWj2qCHMzhVz8ADIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
commit: a525b83d913f000bed66b69f6d9c05c0c04551dd [2254/2671] mm: add basic tests for lazy_mmu
config: sparc-randconfig-r073-20251230 (https://download.01.org/0day-ci/archive/20251231/202512310238.ViLCpEnx-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251231/202512310238.ViLCpEnx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512310238.ViLCpEnx-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "arch_enter_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
>> ERROR: modpost: "arch_leave_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
>> ERROR: modpost: "arch_flush_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

