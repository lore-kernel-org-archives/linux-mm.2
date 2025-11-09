Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0388CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 13:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C1A8E0010; Sun,  9 Nov 2025 08:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533B38E0002; Sun,  9 Nov 2025 08:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449438E0010; Sun,  9 Nov 2025 08:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30FF88E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:15:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC7F31409B7
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:15:54 +0000 (UTC)
X-FDA: 84091116228.23.6ECCF12
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59AE2140003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:15:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SJwZNoig;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762694152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaNfRsFFQql0axZY7YeFX5M0NS/3t1UFCPcfwoMuQiE=;
	b=EDdtGV+FuT0YtLn5hPsTqFTzajj2w58braZirypD8ESVSHevMtRH5/N6CQRUEilr3GfOZu
	0BYtoLOA+MbWA1rBC8z2J1m/Amo3RXeHKOdoFqx4E88gxlSWPkp3laApF1Vx/BPpJR+wqI
	BgTCvDb0EDoI/qeSyJhthCjwyPjNChU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SJwZNoig;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762694152; a=rsa-sha256;
	cv=none;
	b=WRsPcROSMJL7iYc4U6SzVs9yIqmKRvYIQvGPUyGSQRW0FhDgseM1GL55RL6p5LuYs6dDaP
	Em8UtvVDkgbRAzpwsjTLBrei0UL0M4rVSzc8zdR8hGs34NL5m4UzS3oGVz1JJRFEiB+A9N
	kq+/cuUWnd8DJGgQk4C+nv4aV0jyUWI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762694152; x=1794230152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/v/wzx6TVHA6w4gVVmVw44uU7KClaZZTDL0IVwpYqbY=;
  b=SJwZNoig7fx7zaOK6bByJ0YS+Rv6BTfqcdLgytZ+S3xhalDyYBgXyxi/
   +GAHj7c4GZkWbDQ85VzCWH4YV3761eV5LqF3g8dnlSPRaxXvqvupM5+Q0
   RsRrpoDpu6UObZLcSziyzKhXaoLWtJnH2JCrWh7QdQnzZyYfIGZmDoWpP
   PWCwqHym0oFxOTB1yDVJThqLrfZEJ0j0Y8rHOlsVH/EvANtfDqo20ZuMU
   DL4EVhXn2pmawIppHro6q+lB5WOCppGrTOKnQ/XgzaC5gnWTupy2e9Khk
   g1AWY3vHZb/K21MnVnOZFY/5uErfsAaokY+m8mQhOmp9f5oMVTg6sfSh0
   w==;
X-CSE-ConnectionGUID: PDt6Bks0S72OQ3JX/LqjrA==
X-CSE-MsgGUID: cpYC7F7ySRC2da2CWd9fUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11607"; a="64805781"
X-IronPort-AV: E=Sophos;i="6.19,291,1754982000"; 
   d="scan'208";a="64805781"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 05:15:49 -0800
X-CSE-ConnectionGUID: 9Q7luGKBQKmQSeKqcR7S9w==
X-CSE-MsgGUID: ZBoNrpD3Q6aOPPg9WvDM8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,291,1754982000"; 
   d="scan'208";a="188195706"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 09 Nov 2025 05:15:47 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vI5Gi-00020p-0m;
	Sun, 09 Nov 2025 13:15:44 +0000
Date: Sun, 9 Nov 2025 21:14:59 +0800
From: kernel test robot <lkp@intel.com>
To: Alejandro Colomar <alx@kernel.org>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
Message-ID: <202511092053.40sHnHlA-lkp@intel.com>
References: <35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 59AE2140003
X-Stat-Signature: s51mhkbor53md6ekdjek71wnncp6yrxm
X-Rspam-User: 
X-HE-Tag: 1762694151-629396
X-HE-Meta: U2FsdGVkX1+MO16YI8Gra7UQJkt3rlJwbwtzCSgnA2DSw8UjW5CwhFF64OJWbvekVNBrWe5clMFjXS9VBg/B0H6pBpR6WoDYNQsHWOdI8s3/sC3xr6t0nGK3EvyMFEoOif1bdFd4pMNAwxn89EG1kexD58pNgq7PfihfikEY/Mu1mn7iU6XCejNFKVjmLdo+YgnRNDD1E6+KQHBM0gHBc3nf7lZnRv6jO5gA4+oUCrjbcC4u1RC7ZjPeuSUpFxoPa6VF9HJraRziezECXXF2hHnzu/NEg6/MFJ2ZNyAqrThsQOMyNiBkucrtUlaqA5GGs0E8IyzohUtKEGUGIM88sjZXaOjXYbV5NeAyTpGUgeY332eIcTEVRUlA1lboNAlDFb92jZOITXpnmiLZwp/RUf1W9ngxSOCZ2kS5wNGvOlwLjQCdaShYsPdQRX2Czl2traNvAZdd2w5/0tmojAbWMKvQTruBS0mH0q8PtuJaxoaQCrcNnWrtRjJsCP23zzftsrOCpfYKP3DZiTHW932NEUNae1AXsXpEbz+LfrJ4A3Ywujc6MM30qqbpt2vWs6boxdMx/xQl5OdfU+vXcYYl9o5wdhr6Yu5pCLcgsbY/HL82vxwV/SjR39YnsLneAa38wcPNYCvDesUw6Pu3P5SDzNR1FzWVVC+tCN+5Ed74iBDS/JKE8oCxVUDM/IdeEVB1RjaFmMmhAj9ymQYQ2A0hfOx1u1FVu/Y5F/ERPdQrAmtoSQYaA7CLVgOEnprmfk/BMztRc9f+v4FjPzS/hoBvUTmg4YiGIUDq/f7CuljjW63zAh+JGegD2uEmfYyiLooRceltwwp9vtbaR5qsOnKx+iaxvWDhUMIt7F7bMl9w3w550kCQqlfbDbwvA7A0v2LQeHgxudoeV5RShsh+GP7nQu9pVkrMXdTT18z27reM2mzhKqGVe/fyZ+GCFMROgO9+GvlJ16Ncdnw75W1hVKo
 ugVMyXM9
 dPwTsoGVqIaWZHZ91Qcllcqi2pWrJkWJ5fnXfxmdpNike9Kq8k3ojPAyRS3dRMYHc3xOipYhB1qHrXc8gbMhtGdekZlH14FGtY8QblaNHLCuHCvZuev0I+uvB6d6rzvgnfT/Vt1r8OSKESG6sif4tN9vmf229EJJBwEzNv0xXPwZGPEDgyJFKjPDBvIorm2lD/38G2GilxPuPHTEHZykPHspNsuZmlCEv+TtGW+VbJVXUwsL6X7gLo540xBrOBX3s1agbDmTJ1gtP/hmPBss6oE4QRV/Sf1hXzG/962fa8wNmXa6X99Y7X/grXwNvfenlOe4xe3tPof79pYbwmUO2iM9lkQZD7FWmzV9IZPP+Frr94J4+03WfyWDgV+pU4MDsQli8sLprCoOpA5F1ikiMnFyoDDCKaA8/dmtXbIvHL6zOckbVtz9n64lKZuiPd8PVVSxb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alejandro,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6146a0f1dfae5d37442a9ddcba012add260bceb0]

url:    https://github.com/intel-lab-lkp/linux/commits/Alejandro-Colomar/array_size-h-Add-ARRAY_END/20251109-062234
base:   6146a0f1dfae5d37442a9ddcba012add260bceb0
patch link:    https://lore.kernel.org/r/35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx%40kernel.org
patch subject: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
config: x86_64-randconfig-001-20251109 (https://download.01.org/0day-ci/archive/20251109/202511092053.40sHnHlA-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251109/202511092053.40sHnHlA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511092053.40sHnHlA-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/block/floppy.c:4805:9: warning: 'ARRAY_END' macro redefined [-Wmacro-redefined]
    4805 | #define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
         |         ^
   include/linux/array_size.h:17:9: note: previous definition is here
      17 | #define ARRAY_END(a)  (a + ARRAY_SIZE(a))
         |         ^
   1 warning generated.


vim +/ARRAY_END +4805 drivers/block/floppy.c

5a74db06cc8d36 Philippe De Muyter 2009-02-18  4804  
5a74db06cc8d36 Philippe De Muyter 2009-02-18 @4805  #define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
5a74db06cc8d36 Philippe De Muyter 2009-02-18  4806  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

