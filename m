Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ECCCA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 10:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E31B6B00D9; Mon, 18 Aug 2025 06:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093F46B00DA; Mon, 18 Aug 2025 06:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4DF6B00DB; Mon, 18 Aug 2025 06:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFCDA6B00D9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:19:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8364F1DAF0A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:19:37 +0000 (UTC)
X-FDA: 83789481594.15.42D6B59
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D11140005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:19:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RkXGPKzq;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755512375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MTx7agaNe36/VzeL9vGYmASreOCACg/uPibdLjsm25U=;
	b=0un70OXvMROcE7d2Ja34WpCmGp/SRfINcnf9mE7RfFYTG+tZR8QlzUFkAafwyHaMKveVbb
	vx1hSlkHCj893CI/WcUQPaEL8Edfrdo9U8eyu5PKF/YzYp4nMltgHKr14HyJmapw+ITLt6
	zZO/EImEgIu8kCX497EB0iBZ4NqLQZM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RkXGPKzq;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755512375; a=rsa-sha256;
	cv=none;
	b=8Kkcn8NaX/TYNQpKDkCp4s6EcDWBIwQYFNT4ZIGu/57GnNShS8N15ug1alAlTrlHIMNTvr
	0g3zQL8ZiryB8oj3WHcGY9E0NyxapGHdZvEgPAt7BPDDHGikS2XUO6JEuCLn3khcvDQnnr
	G+UnLrFtPo+chnN6QqeMp/AO+x0fIsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755512375; x=1787048375;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=lZiiDjhlNsl+eM7oVIh7z93U9V6yzoNAKFATgG2dY5Q=;
  b=RkXGPKzq12qZZH5kf8RnA0A2H+A3+cdeVqWF53x8TdoRZTW2fG+c2Rne
   ZmXwJ+IVuSZXuIsZopOhUoEHe+hX7tyhiuIdhU5Qrtsl9BIps5pfPujSV
   oVmb7nrfAfP4gooaYEchNSip0SvRpo5m364pcqNPRYM9pGOkX1pVMQB8f
   Jgpl2aV8OKVKVca4iWUXnj4mOn3nXEdkm6IaRfDiV6kKJAvOaWquYsI6z
   iZ5KBHlX9On+sXWcRyedfZoAwh2LuiFVJuGPKjGBcvzMsAho9KzcaGL4V
   TwzEBC2HFd2/TKvQ3LVIBYbLyRkhQTWUeZMR5f9s4LM8trz6lhmx5NseL
   A==;
X-CSE-ConnectionGUID: yD89PIYzSWCt1+FykVN6Aw==
X-CSE-MsgGUID: EKKuJD5HQT6BqI52rXMDoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="80312628"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="80312628"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 03:19:33 -0700
X-CSE-ConnectionGUID: gM3778k1SOyC1UpJ9uDsug==
X-CSE-MsgGUID: uqegUku6SaaCpn2qnljGsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="204703381"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 18 Aug 2025 03:19:31 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unwxJ-000E99-1Z;
	Mon, 18 Aug 2025 10:19:27 +0000
Date: Mon, 18 Aug 2025 18:17:13 +0800
From: kernel test robot <lkp@intel.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 166/188] arch/arm/mm/flush.c:307:41: error:
 incompatible pointer types passing 'memdesc_flags_t *' to parameter of type
 'volatile unsigned long *'
Message-ID: <202508181807.zhZF5TQ0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D11140005
X-Stat-Signature: swpo1res6gdwyubdbhpwnkupyom5g9js
X-Rspam-User: 
X-HE-Tag: 1755512374-528769
X-HE-Meta: U2FsdGVkX18ZP5/ms8k7hRaEGnT9HcbjG6bEy+dHJ5Roly1mrdDFKPYPJiDfudGo1vVsZGMXnzj8TlkmIAFuWT6oeDYNblOQBsB6NQitLHcea8677DfOw4MzGQSTN1MrX2mhlDSt1DMnJB0Nwr7M4rP0LW9ceigzW9fdl+deuPDGR2NNbAMrcoXx2Zs1Rltk8woFiazAtPqwtN9n2+uU2Nwzqq2gw6z23P1VBaF2WOzsk6zijC45xeJWoCoaj7Med9AWK3YNOJ6xTgjrCgosp6fEjzC07M6+sbmlHCa0uqTsdQUA7G4ksPU4ONAP/Dykp7KeyfYtV+gE58tyv8dnJw8MGd+5yLBSyz8yTgp1mQEWAtL0R3BVKtC5LOcEb57zvstfQi+qBQ+uwoZXmf6bra92aNUSbm7P4JLuFMb1j/kVBeDwAsFXqUT0abXXlts3dpL8zXAgMSF3PKXKofDwD00ahWFQqO017CurwgovuQBMWW/NGZwcQRLOA3FUC6Lqj+mcm3kYP8veBFPuhC46i/NSTNepQDMfUPiQVX/S+ejYAM9JPJGRCu6ZtUDl8LtZUWjMGwmI6ZWdJxO6ZYWmxfHViiGAulaHpECNfUpP75yVPnz4vuXJgVJ/mM3/f2FeW+2yhCArkqJvBm9LkTgKvLp9eEArjIg9xnhj4mtwjE8p66RNJAaVB6m5l6vVddv+T0c/MZ+Q8neLoY9056T2IPplvsC8qKJbaEN+6MUtL4XJtEWEq+FSDu+tSHuu1UyWjJkm2IF51pquvMpH4irbjE+dog0lVIGPBEYYb/KWCrltCqChPdRPdOLcQdGirr9AQo2lQiRdVqc2oNxrIPkfVwQsPd93Uod62QjE6GMlhquEuggriUu+5Jja4g5GSWA62Y93wv8x2gHeQmLefDVoZctZU66zXd8ALQLaPH+2gp08fPwViBSu5xjZ2Q/UOHSMl3ua51DHMjRHjZ1Qvny
 dFaoYFXp
 ZJmkQzdr4orJvWHastPzrE06llAvJSmFuLsfa1xqPjnZsOYd+cgkaAGsopr9jwqagUHkwC1/qsqKDheAWwCDzRLOcL6TwoKpwF5uWxD0FfMoGKX93FRFxxbPu3h3+gASduDqO05iuer+W2BGClJSmz7qwYGFVneToBrZbekLxKRAVxmDyvcVYGaMfNQMal72GmqWhvj5Hr5U/uIxvWxyDP0OSKENIu92S0BjUHKq5FmMXpO0ALsHVcnlv3ZfHQSxQiDOB6gmVHQl9YuTwVqh2wky6BaQvTsYmnhwkObVJXEtcAmklksEW8kfCkfUushICvN9q+I6eH59bUXwpGuxZ+S4pYU/q+THSTnwrlyCoQOndvgv0Ny3ohwj/isxKDfHVeHnRCwhT2JcAHRQ5TWRGtLKSRLfgG3Qmaf+HcbzGkTgKEtslDzBi1ofBHgxYMSTozOyJOl2MoVzFa/GAd5NOqDV2f7nPgen1yIBENjAIlH+FcnqRaPOq6p4cxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   dd1510cefdfec9dc3fa2bae40e0f16f1bf825567
commit: a2004477b3282318589bf43a786d952856adcaee [166/188] mm: introduce memdesc_flags_t
config: arm-randconfig-002-20250818 (https://download.01.org/0day-ci/archive/20250818/202508181807.zhZF5TQ0-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 93d24b6b7b148c47a2fa228a4ef31524fa1d9f3f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250818/202508181807.zhZF5TQ0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508181807.zhZF5TQ0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/arm/mm/flush.c:307:41: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     307 |         if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
         |                                                ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:194:66: note: expanded from macro 'test_and_set_bit'
     194 | #define test_and_set_bit(nr,p)          ATOMIC_BITOP(test_and_set_bit,nr,p)
         |                                                                          ^
   arch/arm/include/asm/bitops.h:183:52: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                           ^
   arch/arm/include/asm/bitops.h:73:71: note: passing argument to parameter 'p' here
      73 | ____atomic_test_and_set_bit(unsigned int bit, volatile unsigned long *p)
         |                                                                       ^
>> arch/arm/mm/flush.c:307:41: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     307 |         if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
         |                                                ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:194:66: note: expanded from macro 'test_and_set_bit'
     194 | #define test_and_set_bit(nr,p)          ATOMIC_BITOP(test_and_set_bit,nr,p)
         |                                                                          ^
   arch/arm/include/asm/bitops.h:183:68: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                                           ^
   arch/arm/include/asm/bitops.h:156:63: note: passing argument to parameter 'p' here
     156 | extern int _test_and_set_bit(int nr, volatile unsigned long * p);
         |                                                               ^
>> arch/arm/mm/flush.c:346:33: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'const volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     346 |                 if (test_bit(PG_dcache_clean, &folio->flags))
         |                                               ^~~~~~~~~~~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:47:17: note: expanded from macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                        ^~~~
   include/asm-generic/bitops/generic-non-atomic.h:166:64: note: passing argument to parameter 'addr' here
     166 | const_test_bit(unsigned long nr, const volatile unsigned long *addr)
         |                                                                ^
>> arch/arm/mm/flush.c:346:33: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'const volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     346 |                 if (test_bit(PG_dcache_clean, &folio->flags))
         |                                               ^~~~~~~~~~~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:47:32: note: expanded from macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                                       ^~~~
   include/asm-generic/bitops/generic-non-atomic.h:121:66: note: passing argument to parameter 'addr' here
     121 | generic_test_bit(unsigned long nr, const volatile unsigned long *addr)
         |                                                                  ^
   arch/arm/mm/flush.c:347:31: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     347 |                         clear_bit(PG_dcache_clean, &folio->flags);
         |                                                    ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:192:53: note: expanded from macro 'clear_bit'
     192 | #define clear_bit(nr,p)                 ATOMIC_BITOP(clear_bit,nr,p)
         |                                                                   ^
   arch/arm/include/asm/bitops.h:183:52: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                           ^
   arch/arm/include/asm/bitops.h:48:83: note: passing argument to parameter 'p' here
      48 | static inline void ____atomic_clear_bit(unsigned int bit, volatile unsigned long *p)
         |                                                                                   ^
   arch/arm/mm/flush.c:347:31: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     347 |                         clear_bit(PG_dcache_clean, &folio->flags);
         |                                                    ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:192:53: note: expanded from macro 'clear_bit'
     192 | #define clear_bit(nr,p)                 ATOMIC_BITOP(clear_bit,nr,p)
         |                                                                   ^
   arch/arm/include/asm/bitops.h:183:68: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                                           ^
   arch/arm/include/asm/bitops.h:154:57: note: passing argument to parameter 'p' here
     154 | extern void _clear_bit(int nr, volatile unsigned long * p);
         |                                                         ^
   arch/arm/mm/flush.c:355:30: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     355 |                 clear_bit(PG_dcache_clean, &folio->flags);
         |                                            ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:192:53: note: expanded from macro 'clear_bit'
     192 | #define clear_bit(nr,p)                 ATOMIC_BITOP(clear_bit,nr,p)
         |                                                                   ^
   arch/arm/include/asm/bitops.h:183:52: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                           ^
   arch/arm/include/asm/bitops.h:48:83: note: passing argument to parameter 'p' here
      48 | static inline void ____atomic_clear_bit(unsigned int bit, volatile unsigned long *p)
         |                                                                                   ^
   arch/arm/mm/flush.c:355:30: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     355 |                 clear_bit(PG_dcache_clean, &folio->flags);
         |                                            ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:192:53: note: expanded from macro 'clear_bit'
     192 | #define clear_bit(nr,p)                 ATOMIC_BITOP(clear_bit,nr,p)
         |                                                                   ^
   arch/arm/include/asm/bitops.h:183:68: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                                           ^
   arch/arm/include/asm/bitops.h:154:57: note: passing argument to parameter 'p' here
     154 | extern void _clear_bit(int nr, volatile unsigned long * p);
         |                                                         ^
   arch/arm/mm/flush.c:362:28: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     362 |                 set_bit(PG_dcache_clean, &folio->flags);
         |                                          ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:191:49: note: expanded from macro 'set_bit'
     191 | #define set_bit(nr,p)                   ATOMIC_BITOP(set_bit,nr,p)
         |                                                                 ^
   arch/arm/include/asm/bitops.h:183:52: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                           ^
   arch/arm/include/asm/bitops.h:36:81: note: passing argument to parameter 'p' here
      36 | static inline void ____atomic_set_bit(unsigned int bit, volatile unsigned long *p)
         |                                                                                 ^
   arch/arm/mm/flush.c:362:28: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     362 |                 set_bit(PG_dcache_clean, &folio->flags);
         |                                          ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:191:49: note: expanded from macro 'set_bit'
     191 | #define set_bit(nr,p)                   ATOMIC_BITOP(set_bit,nr,p)
         |                                                                 ^
   arch/arm/include/asm/bitops.h:183:68: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                                           ^
   arch/arm/include/asm/bitops.h:153:55: note: passing argument to parameter 'p' here
     153 | extern void _set_bit(int nr, volatile unsigned long * p);
         |                                                       ^
   10 errors generated.
--
>> arch/arm/mm/copypage-v6.c:76:41: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
      76 |         if (!test_and_set_bit(PG_dcache_clean, &src->flags))
         |                                                ^~~~~~~~~~~
   arch/arm/include/asm/bitops.h:194:66: note: expanded from macro 'test_and_set_bit'
     194 | #define test_and_set_bit(nr,p)          ATOMIC_BITOP(test_and_set_bit,nr,p)
         |                                                                          ^
   arch/arm/include/asm/bitops.h:183:52: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                           ^
   arch/arm/include/asm/bitops.h:73:71: note: passing argument to parameter 'p' here
      73 | ____atomic_test_and_set_bit(unsigned int bit, volatile unsigned long *p)
         |                                                                       ^
>> arch/arm/mm/copypage-v6.c:76:41: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
      76 |         if (!test_and_set_bit(PG_dcache_clean, &src->flags))
         |                                                ^~~~~~~~~~~
   arch/arm/include/asm/bitops.h:194:66: note: expanded from macro 'test_and_set_bit'
     194 | #define test_and_set_bit(nr,p)          ATOMIC_BITOP(test_and_set_bit,nr,p)
         |                                                                          ^
   arch/arm/include/asm/bitops.h:183:68: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                                           ^
   arch/arm/include/asm/bitops.h:156:63: note: passing argument to parameter 'p' here
     156 | extern int _test_and_set_bit(int nr, volatile unsigned long * p);
         |                                                               ^
   2 errors generated.
--
>> arch/arm/mm/dma-mapping.c:721:30: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     721 |                                 set_bit(PG_dcache_clean, &folio->flags);
         |                                                          ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:191:49: note: expanded from macro 'set_bit'
     191 | #define set_bit(nr,p)                   ATOMIC_BITOP(set_bit,nr,p)
         |                                                                 ^
   arch/arm/include/asm/bitops.h:183:52: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                           ^
   arch/arm/include/asm/bitops.h:36:81: note: passing argument to parameter 'p' here
      36 | static inline void ____atomic_set_bit(unsigned int bit, volatile unsigned long *p)
         |                                                                                 ^
>> arch/arm/mm/dma-mapping.c:721:30: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]
     721 |                                 set_bit(PG_dcache_clean, &folio->flags);
         |                                                          ^~~~~~~~~~~~~
   arch/arm/include/asm/bitops.h:191:49: note: expanded from macro 'set_bit'
     191 | #define set_bit(nr,p)                   ATOMIC_BITOP(set_bit,nr,p)
         |                                                                 ^
   arch/arm/include/asm/bitops.h:183:68: note: expanded from macro 'ATOMIC_BITOP'
     183 |         (__builtin_constant_p(nr) ? ____atomic_##name(nr, p) : _##name(nr,p))
         |                                                                           ^
   arch/arm/include/asm/bitops.h:153:55: note: passing argument to parameter 'p' here
     153 | extern void _set_bit(int nr, volatile unsigned long * p);
         |                                                       ^
   2 errors generated.


vim +307 arch/arm/mm/flush.c

^1da177e4c3f415 Linus Torvalds          2005-04-16  283  
6012191aa9c6fff Catalin Marinas         2010-09-13  284  #if __LINUX_ARM_ARCH__ >= 6
6012191aa9c6fff Catalin Marinas         2010-09-13  285  void __sync_icache_dcache(pte_t pteval)
6012191aa9c6fff Catalin Marinas         2010-09-13  286  {
6012191aa9c6fff Catalin Marinas         2010-09-13  287  	unsigned long pfn;
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  288) 	struct folio *folio;
6012191aa9c6fff Catalin Marinas         2010-09-13  289  	struct address_space *mapping;
6012191aa9c6fff Catalin Marinas         2010-09-13  290  
6012191aa9c6fff Catalin Marinas         2010-09-13  291  	if (cache_is_vipt_nonaliasing() && !pte_exec(pteval))
6012191aa9c6fff Catalin Marinas         2010-09-13  292  		/* only flush non-aliasing VIPT caches for exec mappings */
6012191aa9c6fff Catalin Marinas         2010-09-13  293  		return;
6012191aa9c6fff Catalin Marinas         2010-09-13  294  	pfn = pte_pfn(pteval);
6012191aa9c6fff Catalin Marinas         2010-09-13  295  	if (!pfn_valid(pfn))
6012191aa9c6fff Catalin Marinas         2010-09-13  296  		return;
6012191aa9c6fff Catalin Marinas         2010-09-13  297  
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  298) 	folio = page_folio(pfn_to_page(pfn));
0c66c6f4e21cb22 Yongqiang Liu           2024-03-07  299  	if (folio_test_reserved(folio))
0c66c6f4e21cb22 Yongqiang Liu           2024-03-07  300  		return;
0c66c6f4e21cb22 Yongqiang Liu           2024-03-07  301  
6012191aa9c6fff Catalin Marinas         2010-09-13  302  	if (cache_is_vipt_aliasing())
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  303) 		mapping = folio_flush_mapping(folio);
6012191aa9c6fff Catalin Marinas         2010-09-13  304  	else
6012191aa9c6fff Catalin Marinas         2010-09-13  305  		mapping = NULL;
6012191aa9c6fff Catalin Marinas         2010-09-13  306  
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02 @307) 	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  308) 		__flush_dcache_folio(mapping, folio);
8373dc38ca8d491 saeed bishara           2011-05-16  309  
8373dc38ca8d491 saeed bishara           2011-05-16  310  	if (pte_exec(pteval))
6012191aa9c6fff Catalin Marinas         2010-09-13  311  		__flush_icache_all();
6012191aa9c6fff Catalin Marinas         2010-09-13  312  }
6012191aa9c6fff Catalin Marinas         2010-09-13  313  #endif
6012191aa9c6fff Catalin Marinas         2010-09-13  314  
^1da177e4c3f415 Linus Torvalds          2005-04-16  315  /*
^1da177e4c3f415 Linus Torvalds          2005-04-16  316   * Ensure cache coherency between kernel mapping and userspace mapping
^1da177e4c3f415 Linus Torvalds          2005-04-16  317   * of this page.
^1da177e4c3f415 Linus Torvalds          2005-04-16  318   *
^1da177e4c3f415 Linus Torvalds          2005-04-16  319   * We have three cases to consider:
^1da177e4c3f415 Linus Torvalds          2005-04-16  320   *  - VIPT non-aliasing cache: fully coherent so nothing required.
^1da177e4c3f415 Linus Torvalds          2005-04-16  321   *  - VIVT: fully aliasing, so we need to handle every alias in our
^1da177e4c3f415 Linus Torvalds          2005-04-16  322   *          current VM view.
^1da177e4c3f415 Linus Torvalds          2005-04-16  323   *  - VIPT aliasing: need to handle one alias in our current VM view.
^1da177e4c3f415 Linus Torvalds          2005-04-16  324   *
^1da177e4c3f415 Linus Torvalds          2005-04-16  325   * If we need to handle aliasing:
^1da177e4c3f415 Linus Torvalds          2005-04-16  326   *  If the page only exists in the page cache and there are no user
^1da177e4c3f415 Linus Torvalds          2005-04-16  327   *  space mappings, we can be lazy and remember that we may have dirty
^1da177e4c3f415 Linus Torvalds          2005-04-16  328   *  kernel cache lines for later.  Otherwise, we assume we have
^1da177e4c3f415 Linus Torvalds          2005-04-16  329   *  aliasing mappings.
df2f5e721ed36e2 Russell King            2005-11-30  330   *
31bee4cf0e74e9c saeed bishara           2011-05-16  331   * Note that we disable the lazy flush for SMP configurations where
31bee4cf0e74e9c saeed bishara           2011-05-16  332   * the cache maintenance operations are not automatically broadcasted.
^1da177e4c3f415 Linus Torvalds          2005-04-16  333   */
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  334) void flush_dcache_folio(struct folio *folio)
^1da177e4c3f415 Linus Torvalds          2005-04-16  335  {
421fe93cc4b06b2 Russell King            2009-10-25  336  	struct address_space *mapping;
421fe93cc4b06b2 Russell King            2009-10-25  337  
421fe93cc4b06b2 Russell King            2009-10-25  338  	/*
421fe93cc4b06b2 Russell King            2009-10-25  339  	 * The zero page is never written to, so never has any dirty
421fe93cc4b06b2 Russell King            2009-10-25  340  	 * cache lines, and therefore never needs to be flushed.
421fe93cc4b06b2 Russell King            2009-10-25  341  	 */
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  342) 	if (is_zero_pfn(folio_pfn(folio)))
421fe93cc4b06b2 Russell King            2009-10-25  343  		return;
421fe93cc4b06b2 Russell King            2009-10-25  344  
00a19f3e25c0c40 Rabin Vincent           2016-11-08  345  	if (!cache_ops_need_broadcast() && cache_is_vipt_nonaliasing()) {
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02 @346) 		if (test_bit(PG_dcache_clean, &folio->flags))
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  347) 			clear_bit(PG_dcache_clean, &folio->flags);
00a19f3e25c0c40 Rabin Vincent           2016-11-08  348  		return;
00a19f3e25c0c40 Rabin Vincent           2016-11-08  349  	}
00a19f3e25c0c40 Rabin Vincent           2016-11-08  350  
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  351) 	mapping = folio_flush_mapping(folio);
^1da177e4c3f415 Linus Torvalds          2005-04-16  352  
85848dd7ab75fce Catalin Marinas         2010-09-13  353  	if (!cache_ops_need_broadcast() &&
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  354) 	    mapping && !folio_mapped(folio))
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  355) 		clear_bit(PG_dcache_clean, &folio->flags);
85848dd7ab75fce Catalin Marinas         2010-09-13  356  	else {
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  357) 		__flush_dcache_folio(mapping, folio);
8830f04a092b47f Russell King            2005-06-20  358  		if (mapping && cache_is_vivt())
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  359) 			__flush_dcache_aliases(mapping, folio);
826cbdaff29764b Catalin Marinas         2008-06-13  360  		else if (mapping)
826cbdaff29764b Catalin Marinas         2008-06-13  361  			__flush_icache_all();
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  362) 		set_bit(PG_dcache_clean, &folio->flags);
8830f04a092b47f Russell King            2005-06-20  363  	}
^1da177e4c3f415 Linus Torvalds          2005-04-16  364  }
8b5989f33337172 Matthew Wilcox (Oracle  2023-08-02  365) EXPORT_SYMBOL(flush_dcache_folio);
6020dff09252e36 Russell King            2006-12-30  366  

:::::: The code at line 307 was first introduced by commit
:::::: 8b5989f3333717273d02ab87ba8781f72a6783ab arm: implement the new page table range API

:::::: TO: Matthew Wilcox (Oracle) <willy@infradead.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

