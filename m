Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD958C44508
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 01:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EE16B0098; Wed, 21 Jan 2026 20:23:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28BD6B0099; Wed, 21 Jan 2026 20:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34D76B009B; Wed, 21 Jan 2026 20:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D04BE6B0098
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:23:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F2AC13C9EF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:23:34 +0000 (UTC)
X-FDA: 84357852348.19.C63D399
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9C51F1C0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:23:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=REmR6IZH;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769045011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmvD5SIeHJPa1IPpg58+kdHp73KnGmnXe2hAhcjORiM=;
	b=5mRIvhGoyvxPGYXyl/mYrG8hbxnp1ovyFMk9iO5/Nt46yqM3qLI9esrc+nQ/0/cmb7Fhwc
	TBmDsibBIClJOotEOokrG9vw13ipJtNiXV4HWDgJ6cvAjXzuuEbEMzt1Ks7zsj7tmKS9qB
	yHzW/BE5fsVXGmBwa0d5/ntfYdf04ew=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=REmR6IZH;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769045011; a=rsa-sha256;
	cv=none;
	b=GsJLtQDSZfxORDH3kTe/qqs3P2Od/NUmgsQlLwx9HS6tw5IXbcnST5nqaEqfcgTDgyXWNr
	OadPw2rASPqnU3WtsE4C4XP53/IuvZHhGYbKqBgmJoRR3HCIlOkOoZmbicRttIYHeBphGY
	MZldz1xX7DaQbYlnoqxdkCZ+oaOrxjo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769045012; x=1800581012;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=roQTG7BUnVXv2IGEQlqh5+zLrO9mjPF10u/iCVEG5JM=;
  b=REmR6IZHhLebjv6CCCXLuF8L+I7S1AbzKZ7DOktNxlHXJ2PxX7Pml90F
   6Wb/Gp+luU48n5Kb0cYms9Q1vxup5KC3Z1D+i+kVigR34Qze66Ba7RVeS
   4q93KgJBpR+5D6Ljig/wAhfjBb2fMCOt5yu5/+PibrHasm/IgsyQ8tpEV
   vUsILCc/QrxxOPgX20LXXuytmeasuSclYZQa42KgoXVPxqwchujCiB5iC
   +RGGafoldTT7sclN0LuwTB8jn0BXD3PY8M/bF15qg9Ikf27F3ZRLF2Bqc
   4ublwIoH9cFTbrlqPdyXYxKhF/vCr57sRT0sozZrDxsCXn3ztUgTdHj4Z
   w==;
X-CSE-ConnectionGUID: kaTwDzUaQJinz8eAG212/Q==
X-CSE-MsgGUID: sBFg5NqlTt++WcmylNv6EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70448947"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="70448947"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 17:23:29 -0800
X-CSE-ConnectionGUID: 509RMO9hSZeFWJL92bc8nQ==
X-CSE-MsgGUID: lnLLwhhmQUu/f10JpD2HZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="205842636"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 21 Jan 2026 17:23:25 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vijPt-00000000SG5-4BMx;
	Thu, 22 Jan 2026 01:23:21 +0000
Date: Thu, 22 Jan 2026 09:23:16 +0800
From: kernel test robot <lkp@intel.com>
To: david.laight.linux@gmail.com, Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH next 12/14] bits: move the defitions of BIT() and
 BIT_ULL() back to linux/bits.h
Message-ID: <202601220951.7C4YG7hB-lkp@intel.com>
References: <20260121145731.3623-13-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121145731.3623-13-david.laight.linux@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C51F1C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: m81frwq6zndss1mqoumt86updot5d8t9
X-HE-Tag: 1769045011-410261
X-HE-Meta: U2FsdGVkX1//LO2njVuZ3aTw0soEpQ3q80bbxclMzx7W+wGzT/oyrFKuuUedFm5PzoGGNq1HLnIbuzW10uWNwzFExlpyWZHVkkkraC10MI2mP6E8fgIR6oYfzvcOpGw/GCXZvZ0mMX/uE26a1lqIu+nImYcJZH62cTdtXZcJoRtDlDN9LDUdI1sAiGdx6Pj5ZKRwITRY5oUAdokAFdTEbUf5Hbx3puj7dx/LEgn0/oWqOXD5Z1ksZr/6qrwgFJ8M9eJKGuWjHw7bobYb/3XAczz81LjJP4STo6zhWj87ow479K/shcJ2AacC6jHHab0aEKVAwrza4cELcN5G298Fljc4GLg1cUeVAU2kiiIconhZgzJp4T8p99lOFK4dBbHQAG8fW93id3waz8EgHPPz6Pg2kmGxxGvOFlWWeKwgWBN6Qf+PXlXuMG5jbBS3B1KOKhed8Lhv14r4EvF0dTkMEXeu4AAEtk1sk60moqcpxcfHhF/+HXb00frNPbYlEgOrD4dWtfsUEpfBLWxRkmn6N0q0hCeh34fFhv8sNFrbKxbJuvm7r9+9irhKDkJg6ciIurHJVuGVK1l+HjwOur+NUqxUO0leKDSkBCfqjSScJSeeevGHeInv5Rcvp2B29jXu7DAzY3EIZSNbjJRKuYqQ1rl1uLdWMqYpczwtuhgnekzoB/hmWJ1U3ZvmJAjZmAMxPIRJSeF/UnfoxbfUFIe/+zJ+sE6QF6bk/QTQ7444fEPk4EcP3PbZwjWw3N5XAZGPo2e+eVPuqUHv0Fjb7KqIzY0dGNU2n1T54IqSiJaqB6t1DcKdYKeLaNNtf8QPz0Eq4nquWkOnr+/cFf35YjpzFuecf25cMI8f6XRx1b0Zy+bkylDTXHCeNvNj3mbT9Yr/NVurdV3I4lIiYw9Wj04MEPd0dLmnOzZdNDXQba28KZBqe3VJ7+g1uZrj52Dr20TSHiiZZjQQ8GefYYaUTPF
 W6ZjmMMm
 IFjuAcasNiKPJEjqUw3TCIYIXC4e/DnZtapAhWRkSnRpbxUL3qiKg78PIICsYPJnkPfube1LlaE3LkOtPJ9NINeh99cJ2fZjGeJuAzhVVR6PyPbhGYv2pGkG5iVS3R+HostgFNXSkrEEyrVBdfOXoPFNVD97BaBq9QFuxCoXMSe744wFZbgH9P3prtRUhUcjEQN8bj+lsMYhw9zL2J+L7CrSsXXNvpNnbG3XDHisCWaDDl/cVul02Y+RuLvIVyuzs+BMtjv48AuOcusX1EaP7Iyns65W57qcwjIf6nuXaNEjigQUp2XBNB60rouNHg4NmW73/meSoBFj/C6bwVnE0lWbocpSiSvp1A8GPkErn5VMYzRCQQgyafoAOyZds+Dfu3SNicBKdu+uzMSRJ89RhnbhUwBzRWKgadAcVWl1ENixTuxlwNesJaK9sUpixxmWVnPx5lkr81WyhRLX7SLtH4ilzEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260120]

url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
base:   next-20260120
patch link:    https://lore.kernel.org/r/20260121145731.3623-13-david.laight.linux%40gmail.com
patch subject: [PATCH next 12/14] bits: move the defitions of BIT() and BIT_ULL() back to linux/bits.h
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260122/202601220951.7C4YG7hB-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220951.7C4YG7hB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601220951.7C4YG7hB-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from kernel/bounds.c:14:
   In file included from include/linux/log2.h:12:
   In file included from include/linux/bitops.h:28:
   In file included from include/asm-generic/bitops/generic-non-atomic.h:7:
   In file included from arch/arm64/include/asm/barrier.h:14:
>> arch/arm64/include/asm/alternative-macros.h:18:20: warning: 'unsigned' is not defined, evaluates to 0 [-Wundef]
      18 | #if ARM64_NCAPS >= ARM64_CB_BIT
         |                    ^
   arch/arm64/include/asm/alternative-macros.h:16:22: note: expanded from macro 'ARM64_CB_BIT'
      16 | #define ARM64_CB_BIT    BIT(ARM64_CB_SHIFT)
         |                         ^
   include/linux/bits.h:94:18: note: expanded from macro 'BIT'
      94 | #define BIT(nr)         BIT_TYPE(unsigned long, nr)
         |                         ^
   include/linux/bits.h:88:4: note: expanded from macro 'BIT_TYPE'
      88 |         ((unsigned int)BIT_INPUT_CHECK(+(nr), BITS_PER_TYPE(type)) + ((type)1 << (nr)))
         |           ^
   In file included from kernel/bounds.c:14:
   In file included from include/linux/log2.h:12:
   In file included from include/linux/bitops.h:28:
   In file included from include/asm-generic/bitops/generic-non-atomic.h:7:
   In file included from arch/arm64/include/asm/barrier.h:14:
>> arch/arm64/include/asm/alternative-macros.h:18:20: error: token is not a valid binary operator in a preprocessor subexpression
      18 | #if ARM64_NCAPS >= ARM64_CB_BIT
         |                    ^~~~~~~~~~~~
   arch/arm64/include/asm/alternative-macros.h:16:22: note: expanded from macro 'ARM64_CB_BIT'
      16 | #define ARM64_CB_BIT    BIT(ARM64_CB_SHIFT)
         |                         ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:94:18: note: expanded from macro 'BIT'
      94 | #define BIT(nr)         BIT_TYPE(unsigned long, nr)
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:88:13: note: expanded from macro 'BIT_TYPE'
      88 |         ((unsigned int)BIT_INPUT_CHECK(+(nr), BITS_PER_TYPE(type)) + ((type)1 << (nr)))
         |           ~~~~~~~~ ^
   1 warning and 1 error generated.
   make[3]: *** [scripts/Makefile.build:182: kernel/bounds.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1330: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +18 arch/arm64/include/asm/alternative-macros.h

4c0bd995d73ed8 Mark Rutland 2022-09-12  17  
4c0bd995d73ed8 Mark Rutland 2022-09-12 @18  #if ARM64_NCAPS >= ARM64_CB_BIT
4c0bd995d73ed8 Mark Rutland 2022-09-12  19  #error "cpucaps have overflown ARM64_CB_BIT"
4c0bd995d73ed8 Mark Rutland 2022-09-12  20  #endif
7cda23da52ad79 Will Deacon  2020-06-30  21  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

