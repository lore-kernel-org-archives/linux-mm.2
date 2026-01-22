Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2FDC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 00:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244726B0005; Wed, 21 Jan 2026 19:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CC86B0089; Wed, 21 Jan 2026 19:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B416B008A; Wed, 21 Jan 2026 19:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0A386B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:51:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9532D1412C4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:51:30 +0000 (UTC)
X-FDA: 84357771540.18.CDCF521
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id E1ABB8000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:51:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mu3YSULU;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769043088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvhBhWC+XPtsYYPSl8MUCgknKc6dEJ1uqWnCcYrsnEg=;
	b=zPz7wsyAp/pCmeakYVWB0bLSjl4of8KRh+dJhaf5EouDn1X3N9oZ8DJEAU4YTRZ6NIwMSC
	e/nawndkrZkZESysyNAWVfAfc+rmXaN8iqsm3KaNQJvAn3t7uwR5kW+6NfmFIRNTo3MCR3
	NnuTTax5LczILKIs7AAgIbT4hD9ai3Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mu3YSULU;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769043088; a=rsa-sha256;
	cv=none;
	b=23Z4oGQn3vLwxceygnboAjexuH3R8Gm0QW3hQ88abdqJ1IzZZpnfAoH2XOdT4FIwEoJ49I
	X/i8CTS6gLwaAhVQYaQZUT9fY/hFo1NXTC3GuwTMj+/3NaIHQff0mgHa2NxdiToc3ApBwu
	TwPezRJIKptI8YdAggBZFreVXrcxjxw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769043088; x=1800579088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RCNqkVMwIfVKf0aQSQfx46Kk4bHwCtxB2Y9S7fFQWu4=;
  b=mu3YSULUrPZKzakR8BVTNl12M42KKHAMO4GxhWiRX6J6BBKotGmWTRv6
   bsJGZWVRocembvmyJAcX3o7jWfCtd2kz3Yx9ij8hFc7RZqu5oT7XxMI2c
   C2bstZVxf+Lb+Nvq99hFPuUA46sCGns7LUYFA4X571Di0pshlSWc7UC7+
   vzzbGxfy5xcp4kbT051h4OawJsavXa1hmSuu18zT8eDbEaOd4fLnqp+Zh
   tyYFl8HISMAHHE9YeZmTrg3R7kBqqmsn7vDzt+n/J4yY//kBCBSzfTyPF
   pXOa+AT++5sF4tOTq6+KWw56tj9LQaERTUWNo8AN1qK1L1rL4JbNB4h8H
   w==;
X-CSE-ConnectionGUID: zkALhv8cSPywqMgb5RFKwQ==
X-CSE-MsgGUID: tkKTMn5fTIW+6A5MrmqXFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70195050"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="70195050"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 16:51:27 -0800
X-CSE-ConnectionGUID: yJHh1HgCSqaYPg05Nf/Q/g==
X-CSE-MsgGUID: DwXXI/rqSsuGHmoae9oqng==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 21 Jan 2026 16:51:21 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1viiut-00000000SDR-2mlh;
	Thu, 22 Jan 2026 00:51:19 +0000
Date: Thu, 22 Jan 2026 08:50:22 +0800
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
Message-ID: <202601220832.NJbHlnXC-lkp@intel.com>
References: <20260121145731.3623-13-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121145731.3623-13-david.laight.linux@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1ABB8000C
X-Stat-Signature: z1uxaox7pkeetcm16r5bhn3c1qbk7t9d
X-Rspam-User: 
X-HE-Tag: 1769043087-742748
X-HE-Meta: U2FsdGVkX1+mvSo7wa3oemOaK8QandN+HG7f5yMgl90xrzAb7/QMCqGI4d7AUqoVyh3AIxxS9+qmvDUMx+qSd58SbWIVQLEkl+hYMHCTRLspSzmsmPHS0FARp8oO6c504YNZmKlZqXjRs21f5mmQCYUWBk15qNOqQRaa+2yZxQM1y1146Dqj99l2mtUCdjCgv6uwmFx7/eswTy7+WgKmY6g8G2qRi1GpA3uVl7h6Qd0Utid2KD6fmUj8IqeYen7RrIusMVgZu4uT/R4nEDjoQns6XsA/k0uBcsLnKfKXE1t36BKHjEAAM2J/LZe5RwskhBK/Qjj6YyET16TSLlXAwyMgm4iZGoycqdLUWywbAFSqCut0+1b2m2rffa3NTSLXclJQbkRP/hFQYErrvZaqh9EmvnuiifHi4f+Zer3s8WtGGBzr9+4kFNGY4QxhZPPgqCPjCCpmCBqcEfKEMQFqJMCQmvoz/GTgmDtLUhuLctUwmIzsXeh//4xF82e6JGbOWQFA9Pm0IXwMTzKMJAm0GMxxDM0iYZkB9F4NR8JkeStNMAXGOcSXS2cBUTx8/fZmOPxg7+7P97nwCj/PQIFc9IxpMJ7Uscb/pdMBEyloeAp+FYy+pYIwgg1nJTqnh7VigTIChKO3u/Fp5qgxUKBReoIIXz2hs+WVMBNTd0AlF4funiXz4vG9uU8FXVfxt0Z/oK/gdbkMu5iszJcIuGyoCeCizGrWTgHC+9fi1e2X6MTAFN12tSCMd73YwvzxsKYO/IQAhq9LKv8lED/rKAWtZ5aZCn0m8t+U4LCimdSL5AEGl6JKtNfRTGPtEaQVd8WtqH9/rZoinaK+Y4XAzy16YpH30zSeP/S8HoQCzFTdsOnLcREYju4e0KJtVtS7BVTOC0H/wRHpLwDAQFxYLfo8aC6W6ruParHBeJw7Nvw06rpSvichltUlNT2ZZ8d4or4q6TeAJzgOarq6tInq0pa
 OJJf2yO1
 tNbRUfSqTyo1fSv3pwJxVKhchsOYY7OyBn9fbX/IrqUup+eGvWXY0GTcJbUC8aQFoR2TDrwJhx2EKnHaS3aAv7veiqt/OQ8qdauiN8R/vrt4RykoU6hbc4+AtDBIzBRNw9TIvv+N45LDJsa3wuu1rkfnx1ATlnBFt+HKpTp6P1hb4vfelu7ym5UoAoMPCrzoTjWtGHFt4oa3t6f3g+8e8DAJJUnNAykdi0gPjrJIycM3QkOLiQHOurUEBgAjjmbP7nTWxt/KqPbEzGSlx18jtImAiCslmwDsNRQ4s6x8WF/WpFyhrPNrLdTprx2QLIAto8CwBazaP9tt1Vthdx3Dqbz78bbX/JxSZqXPG1HyEqDr3xb4HK20JCdxga9Q8eOu68fmuFaPgZsJMz0yleq3k3cQKJH0/CU4xXRwEuUCogcpIovWV02KaKwiBR5f3ydyQ2ECl2K2GmFkCO07wzYpLUWzobg==
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
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20260122/202601220832.NJbHlnXC-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220832.NJbHlnXC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601220832.NJbHlnXC-lkp@intel.com/

All errors (new ones prefixed by >>):

     163 | _SIG_SET_BINOP(sigandnsets, _sig_andn)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:139:8: note: expanded from macro '_SIG_SET_BINOP'
     139 |                 b3 = b->sig[3]; b2 = b->sig[2];                         \
         |                      ^      ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:163:1: warning: array index 2 is past the end of the array (that has type 'const unsigned long[2]') [-Warray-bounds]
     163 | _SIG_SET_BINOP(sigandnsets, _sig_andn)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:139:24: note: expanded from macro '_SIG_SET_BINOP'
     139 |                 b3 = b->sig[3]; b2 = b->sig[2];                         \
         |                                      ^      ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:163:1: warning: array index 3 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
     163 | _SIG_SET_BINOP(sigandnsets, _sig_andn)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:140:3: note: expanded from macro '_SIG_SET_BINOP'
     140 |                 r->sig[3] = op(a3, b3);                                 \
         |                 ^      ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:163:1: warning: array index 2 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
     163 | _SIG_SET_BINOP(sigandnsets, _sig_andn)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:141:3: note: expanded from macro '_SIG_SET_BINOP'
     141 |                 r->sig[2] = op(a2, b2);                                 \
         |                 ^      ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:187:1: warning: array index 3 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
     187 | _SIG_SET_OP(signotset, _sig_not)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:174:27: note: expanded from macro '_SIG_SET_OP'
     174 |         case 4: set->sig[3] = op(set->sig[3]);                          \
         |                                  ^        ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:187:1: warning: array index 3 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
     187 | _SIG_SET_OP(signotset, _sig_not)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:174:10: note: expanded from macro '_SIG_SET_OP'
     174 |         case 4: set->sig[3] = op(set->sig[3]);                          \
         |                 ^        ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:187:1: warning: array index 2 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
     187 | _SIG_SET_OP(signotset, _sig_not)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:175:20: note: expanded from macro '_SIG_SET_OP'
     175 |                 set->sig[2] = op(set->sig[2]);                          \
         |                                  ^        ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:187:1: warning: array index 2 is past the end of the array (that has type 'unsigned long[2]') [-Warray-bounds]
     187 | _SIG_SET_OP(signotset, _sig_not)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/signal.h:175:3: note: expanded from macro '_SIG_SET_OP'
     175 |                 set->sig[2] = op(set->sig[2]);                          \
         |                 ^        ~
   arch/arm/include/asm/signal.h:17:2: note: array 'sig' declared here
      17 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/arm/kernel/asm-offsets.c:14:
>> include/linux/mm.h:994:26: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
     994 |         const vm_flags_t mask = BIT((__force int)bit);
         |                                 ^
   include/linux/bits.h:94:18: note: expanded from macro 'BIT'
      94 | #define BIT(nr)         BIT_TYPE(unsigned long, nr)
         |                         ^
   include/linux/bits.h:88:17: note: expanded from macro 'BIT_TYPE'
      88 |         ((unsigned int)BIT_INPUT_CHECK(+(nr), BITS_PER_TYPE(type)) + ((type)1 << (nr)))
         |                        ^
   include/linux/bits.h:82:24: note: expanded from macro 'BIT_INPUT_CHECK'
      82 |                 sizeof(struct { char bit_number_too_big[-((nr) >= (width))];}), \
         |                                      ^
   28 warnings and 16 errors generated.
   make[3]: *** [scripts/Makefile.build:182: arch/arm/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1330: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +994 include/linux/mm.h

bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26   990  
568822502383acd Lorenzo Stoakes    2025-11-18   991  static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
2b6a3f061f11372 Lorenzo Stoakes    2025-11-25   992  					   vma_flag_t bit)
568822502383acd Lorenzo Stoakes    2025-11-18   993  {
2b6a3f061f11372 Lorenzo Stoakes    2025-11-25  @994  	const vm_flags_t mask = BIT((__force int)bit);
568822502383acd Lorenzo Stoakes    2025-11-18   995  
568822502383acd Lorenzo Stoakes    2025-11-18   996  	/* Only specific flags are permitted */
568822502383acd Lorenzo Stoakes    2025-11-18   997  	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
568822502383acd Lorenzo Stoakes    2025-11-18   998  		return false;
568822502383acd Lorenzo Stoakes    2025-11-18   999  
568822502383acd Lorenzo Stoakes    2025-11-18  1000  	return true;
568822502383acd Lorenzo Stoakes    2025-11-18  1001  }
568822502383acd Lorenzo Stoakes    2025-11-18  1002  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

