Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41B1CCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002896B008A; Fri, 16 Oct 2026 09:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDA76B009B; Fri, 16 Oct 2026 09:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD7E6B009D; Fri, 16 Oct 2026 09:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC63C6B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:22:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42A3E1A02C8
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:22:10 +0000 (UTC)
X-FDA: 85328552820.15.8C1D524
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7064E14000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:22:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AjBFXF9Z;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792156928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rfnRKC0dnb7v2Iwowqo7DeL++H/auk/eHigU5I5UgE=;
	b=1tXx+Cs5VIVQB7CbehhW+inj5y/wFfXGUh7Odohmmke0AY60gwEhGcNgQT1r8Eqv23TfJ/
	kIOfO9XxuOIPYLHGgeSiDbpBM6L9L5O7rEWKRsadpeaoJPUoA9v8I+ktjwjgYi4omcLGpF
	iEFeFnImRSfpBmkcz+xr3XNhVnmdsqQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AjBFXF9Z;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792156928;
	b=Jn64cWmlWFS8EFrU+/OQ3VsoE+FIP11rI1WbLjSvBjiBfHCrA7b3IMeq6OqDt1EP2ERrJK
	AjMe94s79UT0pgZckVlgBGtaW7tqzhmiMSZnd82R0EEursnSOex5yuMdTOEvMEXK20l67j
	5JYe+XVozyRjfwqNjuy+Zep539KQm0U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792156928; x=1823692928;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A7txyVYnucQ+mXIF45spbjwttKKlMtGxt+1t/z8ssrA=;
  b=AjBFXF9Zlv1st+vCmMS9rT6OGzi58sNO/53ZhYR81mBpds54THKpSkvO
   Q/+O8pnQHTUCaZlpTjUbXN/VSOwTP3sy8nQNKnvDWUNo0YBdlZPjEhTDr
   O+rTMnWFZRMg/cKjHSYFRrfKfB6NVfCm29OaLTumjPlIFC0ZG3h0fsU8D
   jQ1my+6sSDgyWPJDomSrHCi6beVOq1tEfRMM8aiHVCE71Rq+QFl+9TvA8
   rhXG6B11Amb6L+n4H/hn2TOo/M2xJE/976R/Hg+CERQdxKUnc7WHaPZlk
   zidGiWNgGP+v3qycK0r14yBsXUIDuCiSvf5wHp+drYcsY/VcxBv1JdvGm
   Q==;
X-CSE-ConnectionGUID: I7a+h3kHSLSQwwhAQytbjA==
X-CSE-MsgGUID: IMvtjUp3S9Wvs3jfO1rhbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="820268"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="820268"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2026 06:22:06 -0700
X-CSE-ConnectionGUID: NG1UJPDCSDKpNOKt4UMv+A==
X-CSE-MsgGUID: 7F3DT3sORvSDv1o3mBLYiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1831994"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 16 Oct 2026 06:22:03 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHhsl-00000000IAU-1WH4;
	Fri, 16 Oct 2026 13:21:59 +0000
Date: Fri, 16 Oct 2026 21:21:14 +0800
From: kernel test robot <lkp@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Rae Moar <raemoar63@gmail.com>,
	Ryota Sakamoto <sakamo.ryota@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Kir Chou <note351@hotmail.com>, Petr Mladek <pmladek@suse.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	linux-kernel@vger.kernel.org,
	"(open list:KERNEL UNIT TESTING FRAMEWORK \\(KUnit\\))" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] lib/tests: kunit for associative array
Message-ID: <202610162123.hSusVMnq-lkp@intel.com>
References: <20261014160144.1835860-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014160144.1835860-1-jarkko@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7064E14000B
X-Rspam-User: 
X-Stat-Signature: ok38yn8yrstifpydjywixs9chgkokd68
X-HE-Tag: 1792156927-404068
X-HE-Meta: U2FsdGVkX1++Dj966zMI8nhaNErjyULjs/Ug1DINLge2PlWM5hvqk/1D8IFpvgiexqeAgPg/z9oXgWOuVtBhxPWZllD6SEU/D1qik/3cKg05YLmF9IJ9btkZRlxoF4JkFtq0bFkKvF6x/k1Bby42mgVxvrTkthBVH8EOZiGku/mguwhzj1zXRtUgoRuE9eS08awqKv+eu3WJqxMvRMdSSOxpD8/g30K5EJWqcm15H4Gu5xp5RmWEZ25Nv7rUyet0liw6qwddvT64oZ4FjN+57XGuJ9zD87tgBkKtALxCjMcS71MHdLdAEWpg5FBsbdmDB794xbgRqY7l4c1tfXWZl+vfYDQPh4pjLq2iA+oohvDvBrw3jH3S/wr1sOFUgRfoACfNivRMRPNUMvwcUnRBXlybecOmgEAIbDQrVljaE6IRcu+YZvCnwzdveI7cTm6BjGLp/BF75iM/roB18yfeEH/JgOEQ5rmWkdCiMmrPHGEUvF01IguczfHaUSSKbSr9dcUChmBiEQd72dvGuYX8yw7aGAr4U0JY/VZM4mr7HUjg/semmTXBz6OUmHuzK++R0MnkS9JrnSTNkU7WpJL8EsHP5RAreQ7W5D79EV8lOIlgTIyW153Xr+UgvhdatmJb4HXAHEsMo5iYAFhYZYUsK9PYGPuIRrgy8utU37j8qfUrCW/4Uya5mRfBV/TNR+tbs/Q3NTccnKqKNk6VWC881IrDTVmRWgM8AUd9ZZ7i2F+XcgoMiokEAzE6pUG8xmOIMpT45w4TlytX0UHWeQ+9qpAfusrxjlwOs/R/vPcsXL7pX6rsx/l2c7UXLbrSvLTH+3C4FOIVqVpRMKpktH9cHvcI/RS9lsGn2qZv+Atm4DGwvD9f6oVWJ0hYlQZ88wCXwE+E3s/xwgOn5AoyMQm36NCYciuXtRzNuvixK4i6V+JwyjcPi1YxwzthvXq97WNZjNELCy5nXPvF8Vy8Rpt
 MinN8xFa
 1cEO2CX4ENZmivHkg8jU7NJuTxMhYJpn9E9b0IG+ziEhKhyKubRbd7IZdsMNG7I+ME4Z3hTTai3jh0ZebY5vLJHJhHkfblpmaPZJGZIcXNVVOULrKJT8mlAyhqJitQe9AH2yiND8WouSEGL86vHwo1CDGad4KUNwZwR+n+Fow2yfXTJlijk3qePG9OWDAEBjAF30Rfs4tQOurPYB/neoYq1tfoc1rjpw8Bh0PrbCDlLTdiRM3DnYdRHC5/Ih0g/ajneTlygxSv6kV7glOUAIuCYr2nWZLNK8//XkxsBmIawyQvp3Qr/4xNOuntcRKl4iLFNtK1wwzfmDdJi5uelStak4o3ePy8+yHDgfcGJuylgC5CG63RJowmFLbKzy5vVfG7IOVCfOoPTi3aUneiu0MqRI32eozzPwWSy7/W/aMPAY6+rE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jarkko,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on linus/master v7.3-rc7]
[cannot apply to next-20261012]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/lib-tests-kunit-for-associative-array/20261014-190138
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20261014160144.1835860-1-jarkko%40kernel.org
patch subject: [PATCH] lib/tests: kunit for associative array
config: i386-randconfig-1010-20261016 (https://download.01.org/0day-ci/archive/20261016/202610162123.hSusVMnq-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610162123.hSusVMnq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610162123.hSusVMnq-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_iterate' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_gc' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_insert' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_cancel_edit' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_delete' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_clear' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_apply_edit' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_destroy' undefined!
>> ERROR: modpost: lib/tests/assoc_array_kunit.ko: symbol 'assoc_array_find' undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

