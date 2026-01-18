Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3845D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3626B00AE; Sun, 18 Jan 2026 13:37:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B0B6B00AF; Sun, 18 Jan 2026 13:37:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4B66B00B0; Sun, 18 Jan 2026 13:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF2ED6B00AE
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:37:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B29261A05B6
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:37:11 +0000 (UTC)
X-FDA: 84345941862.26.DADF24D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC66D1C0009
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:37:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RAC8mm1x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768761429; a=rsa-sha256;
	cv=none;
	b=ySQCHWUUT54JpoLt5+x9onxoWjRWH9KtkZQ3dAFUPNwylTVtD6V3WKi1dyhZOuJObyMQCj
	Ob682dalgy/Hein1+FcPF3znSFJp0Re3i74osVM9eUhN9yczytOqzS0ZRAufMyrk/W7fuJ
	kbVGxeeMLOoqi2e+q+R7v4/uu5Bm2yI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RAC8mm1x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768761429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCFN5GOdeoINMlQiEsJ6PanwSfmeQ6abGMUDhciel6U=;
	b=p5yBdrmnB1CuHGdGRFdkXyFo04Noz5oi/XTtmF8CyLmSZIwfcUbx3Vx2V/Gbv0i5FlgywY
	61Onw8IXtUQ4fjeHntrWeGveaW9AN1mMeJMEisz21GHbpKiwqE3ZP142l+tSQvzW6pImZs
	1TGOH47kbKxUbFX/yYswvcZJwWlEpAI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768761429; x=1800297429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8O/5joRe3cFbEUfBDmw9o/JAu/DiyxFA8DnJE5KGfag=;
  b=RAC8mm1xxPxsYxj4wBam+6sti3gLCxFJRjKBZp4NU4YKK0nCPk4KH/yM
   5DZswMlWySMs8a/OlN7h6x4YfE8BFF4QJrAtKpExC852JPTatLNKDaq+I
   eNYrkZZaK1nLyVxy4oPGSSWkHmDXaQscM2FZY5d4KalS5uxCef6j9H2oO
   a2y70HSJbjt/I7HNQhQvCHkz8B6qMX8TmZM04g4GqmHswCibfQyo0DbB4
   9T2FjT01GfkL/6ZtNYLa3gCzH1Wh9M0pKtxkuiciHcp+yD3KEOCTKYhjb
   6dfnT1iqNw7Ge0ih9tM01Eh/KxRKisnLdxuux0H3Ifc1iH4gVFWIiR+3Z
   Q==;
X-CSE-ConnectionGUID: mU1FJ9TFQFOZxHFfel+QzQ==
X-CSE-MsgGUID: fe0MTgT+RliEccQ7thYBug==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="73835475"
X-IronPort-AV: E=Sophos;i="6.21,236,1763452800"; 
   d="scan'208";a="73835475"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 10:37:07 -0800
X-CSE-ConnectionGUID: hm2VYymoQTiQVnvTIOnENw==
X-CSE-MsgGUID: Z31XybFiRhilpkSXiTJoTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,236,1763452800"; 
   d="scan'208";a="210543106"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 18 Jan 2026 10:37:05 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhXe2-00000000N9g-2MNB;
	Sun, 18 Jan 2026 18:37:02 +0000
Date: Mon, 19 Jan 2026 02:36:18 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Dumazet <edumazet@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Nicolas Pitre <npitre@baylibre.com>
Subject: Re: [PATCH] compiler_types: Introduce inline_for_performance
Message-ID: <202601190247.dDAvbbMH-lkp@intel.com>
References: <20260118152448.2560414-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118152448.2560414-1-edumazet@google.com>
X-Rspam-User: 
X-Stat-Signature: ra7idyekqgfqscm5qra8nwkrq4681tk4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC66D1C0009
X-HE-Tag: 1768761428-541338
X-HE-Meta: U2FsdGVkX18EJ9LlY/yRlZdWa3dpjEGpL9ftJjbR8QSat0OPznN0cXAU4qdz4zb0wlOf8Krtwnw0l3VMoPqa207lxvh/oimycA1tqU2ABA0sevXwsdHk+x2gQ/ECVYO3EvADikZGI3T2HO+UgkmMMK1s2Hh4cu0FsewG6oP0LGJoM1fmBm/hJZaxMDwXqBpQMA3vJr1vY44+ZueNvy3LeogLzDru9TKIeh8va2BW+u/cOeoYFuDeYRS3eZyU4ZHCRFXfYD0Bj/skRVrieVUl6BE0q9dY9+PCZ956gbhNsfEgEPazRMIB2TX/cnUxHUL8kPo1EuTdOWuAAchOQazOTJ6zfOyEBZtH6noCiATt0fGIzLEyZHUIlbzDsSmFeLFGDI2SuMHJ2ooToeiVrLSd+XCQlnyk21kokcQ5DhYQaqhDWqAOyE40rQCmLHij4KAERUe5oG7z45A5yywqMbWUEcidzyFoWdXVaJfjTPLLLzdV/wytSc0Hj2DpjGt5BeNQmrgnU1WJXFNTFmOc6YVl9Ya5+4hjze+YF+tElOhmgTNe6gLiR4NanO8jKvEZu2ibeG61+rNZ1lIKVQmdSvTlmbHsEbPuc65Mr/+KIpgVbLKpn7+yWwNV1Iw+wPGREqC4xiINQ5ZXSbRZIYINEHC6fALQebAIkPyXts8EffUwqdKPKxHL9TvRLJD+Do2gSRQZfSCn4PtvslG5g+ot8nZp0vPeQsnTHHAu6aEBSz4WWq3FQD+Twu9yyZMw59oPA2SpfTLh7i8+PS66V1eOHPYgq0sMSyWVUQWz/iSvkGvu+8YvqDLERr9yXVlFQDulAI1k3VxqNzB3Ol1Ta1M0x4QMhmT7CcaaFKoWLzeZzV9XrP3aHwzNWIAmFnGFJkahr6VvV3OXjXx11f4JhhnhapdGtoa3poL2RxR288Q5G5jWtPj9zLF7IUZzN4gNWaFx3aGWvu652wMBr2LtGYdnULA
 uwK/PAd8
 tq1kt8boUPFfJ/8cDw+33l1en7hC8KJrnq9C+TP7zQ+akdBqKuwha7U2JqbOtiR/z7/r0DXLrI6K9WC6Jh2PZ3kEDOJoIBEdLtT6wwrf55aHnjlAT6iPMMxekhGJwS9q1uiuxn7BDVyWdnloMbzAHJEtzokEYKM1przhz+JgfUUTr1U6wWXkQs3Sdc3qdJ051qMxhUv7kPe3xuoksKGicFwwGHvCrh7pSVBxcvlSXbwJ5Cqns8tEGbCjthzWNheiU+aNAnGjfKgIlHWEM28ugP+XUujUX1mSReddQJsYMXsOSKeKjMr64TTM4ltWxb/g2WtL9TV8KrtjEGZfdQRxKHhnpI2GgqruPJ+pQbmcJQOra4cOmij+kNOvvtAXQWxR17+SDOKaxZk4vuaX8qtVmO9yQxlbI+uLei2yrqvxeZBt+dSDIbxtEPzDXLQv/+7EdydlhfVZoHXa6zqDYIE/F8aRDjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eric,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e84d960149e71e8d5e4db69775ce31305898ed0c]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/compiler_types-Introduce-inline_for_performance/20260118-232653
base:   e84d960149e71e8d5e4db69775ce31305898ed0c
patch link:    https://lore.kernel.org/r/20260118152448.2560414-1-edumazet%40google.com
patch subject: [PATCH] compiler_types: Introduce inline_for_performance
config: m68k-amcore_defconfig (https://download.01.org/0day-ci/archive/20260119/202601190247.dDAvbbMH-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260119/202601190247.dDAvbbMH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601190247.dDAvbbMH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/m68k/include/asm/div64.h:6,
                    from include/linux/math.h:6,
                    from include/linux/kernel.h:27,
                    from arch/m68k/coldfire/cache.c:12:
>> include/asm-generic/div64.h:138:10: warning: '__arch_xprod_64' defined but not used [-Wunused-function]
     138 | uint64_t __arch_xprod_64(const uint64_t m, uint64_t n, bool bias)
         |          ^~~~~~~~~~~~~~~


vim +/__arch_xprod_64 +138 include/asm-generic/div64.h

461a5e51060c93 Nicolas Pitre 2015-10-30  125  
f682b27c57aec2 Nicolas Pitre 2015-10-30  126  #ifndef __arch_xprod_64
f682b27c57aec2 Nicolas Pitre 2015-10-30  127  /*
f682b27c57aec2 Nicolas Pitre 2015-10-30  128   * Default C implementation for __arch_xprod_64()
f682b27c57aec2 Nicolas Pitre 2015-10-30  129   *
f682b27c57aec2 Nicolas Pitre 2015-10-30  130   * Prototype: uint64_t __arch_xprod_64(const uint64_t m, uint64_t n, bool bias)
f682b27c57aec2 Nicolas Pitre 2015-10-30  131   * Semantic:  retval = ((bias ? m : 0) + m * n) >> 64
f682b27c57aec2 Nicolas Pitre 2015-10-30  132   *
f682b27c57aec2 Nicolas Pitre 2015-10-30  133   * The product is a 128-bit value, scaled down to 64 bits.
00a31dd3acea0f Nicolas Pitre 2024-10-03  134   * Hoping for compile-time optimization of  conditional code.
f682b27c57aec2 Nicolas Pitre 2015-10-30  135   * Architectures may provide their own optimized assembly implementation.
f682b27c57aec2 Nicolas Pitre 2015-10-30  136   */
5f712d70e20a46 Eric Dumazet  2026-01-18  137  static inline_for_performance
d533cb2d2af400 Nicolas Pitre 2024-10-03 @138  uint64_t __arch_xprod_64(const uint64_t m, uint64_t n, bool bias)
f682b27c57aec2 Nicolas Pitre 2015-10-30  139  {
f682b27c57aec2 Nicolas Pitre 2015-10-30  140  	uint32_t m_lo = m;
f682b27c57aec2 Nicolas Pitre 2015-10-30  141  	uint32_t m_hi = m >> 32;
f682b27c57aec2 Nicolas Pitre 2015-10-30  142  	uint32_t n_lo = n;
f682b27c57aec2 Nicolas Pitre 2015-10-30  143  	uint32_t n_hi = n >> 32;
00a31dd3acea0f Nicolas Pitre 2024-10-03  144  	uint64_t x, y;
f682b27c57aec2 Nicolas Pitre 2015-10-30  145  
00a31dd3acea0f Nicolas Pitre 2024-10-03  146  	/* Determine if overflow handling can be dispensed with. */
00a31dd3acea0f Nicolas Pitre 2024-10-03  147  	bool no_ovf = __builtin_constant_p(m) &&
00a31dd3acea0f Nicolas Pitre 2024-10-03  148  		      ((m >> 32) + (m & 0xffffffff) < 0x100000000);
f682b27c57aec2 Nicolas Pitre 2015-10-30  149  
00a31dd3acea0f Nicolas Pitre 2024-10-03  150  	if (no_ovf) {
00a31dd3acea0f Nicolas Pitre 2024-10-03  151  		x = (uint64_t)m_lo * n_lo + (bias ? m : 0);
00a31dd3acea0f Nicolas Pitre 2024-10-03  152  		x >>= 32;
00a31dd3acea0f Nicolas Pitre 2024-10-03  153  		x += (uint64_t)m_lo * n_hi;
00a31dd3acea0f Nicolas Pitre 2024-10-03  154  		x += (uint64_t)m_hi * n_lo;
00a31dd3acea0f Nicolas Pitre 2024-10-03  155  		x >>= 32;
00a31dd3acea0f Nicolas Pitre 2024-10-03  156  		x += (uint64_t)m_hi * n_hi;
f682b27c57aec2 Nicolas Pitre 2015-10-30  157  	} else {
00a31dd3acea0f Nicolas Pitre 2024-10-03  158  		x = (uint64_t)m_lo * n_lo + (bias ? m_lo : 0);
00a31dd3acea0f Nicolas Pitre 2024-10-03  159  		y = (uint64_t)m_lo * n_hi + (uint32_t)(x >> 32) + (bias ? m_hi : 0);
00a31dd3acea0f Nicolas Pitre 2024-10-03  160  		x = (uint64_t)m_hi * n_hi + (uint32_t)(y >> 32);
00a31dd3acea0f Nicolas Pitre 2024-10-03  161  		y = (uint64_t)m_hi * n_lo + (uint32_t)y;
00a31dd3acea0f Nicolas Pitre 2024-10-03  162  		x += (uint32_t)(y >> 32);
f682b27c57aec2 Nicolas Pitre 2015-10-30  163  	}
f682b27c57aec2 Nicolas Pitre 2015-10-30  164  
00a31dd3acea0f Nicolas Pitre 2024-10-03  165  	return x;
f682b27c57aec2 Nicolas Pitre 2015-10-30  166  }
f682b27c57aec2 Nicolas Pitre 2015-10-30  167  #endif
f682b27c57aec2 Nicolas Pitre 2015-10-30  168  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

