Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DC5C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1568E0003; Wed,  6 Aug 2025 18:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951FC8E0002; Wed,  6 Aug 2025 18:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8673D8E0003; Wed,  6 Aug 2025 18:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7756E8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:06:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AB2A5AD36
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:06:45 +0000 (UTC)
X-FDA: 83747717970.06.635AC4A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6ABFE16000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:06:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XS5I7d+Q;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754518003; a=rsa-sha256;
	cv=none;
	b=0qKSiFvC7MvaCjv1521PJ0a3h5JK6LCpPjr1kt3KhBCyLA/xoSADfwc94Ym0mmlWgzM6Co
	AzxgOKpybBBw46QnEV9kZXSZBagk9C41saTFBYmHAJh5mp3rDfKvYcHmOlRu+X2gVFDl73
	n2eKGRunXTeE0PaotlvqJuL8w1HWGX4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XS5I7d+Q;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754518003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EgWvaKpwpCnj7rg2uGT2f4hc7SsaRBqXn81DBqFH83s=;
	b=6VTS79HMxVdAs+9+dSHQ5VW1vHlI5w5ahwss9enxYQ2OKE0eA3oQm/VQlmVpFleks+qEIo
	GY9CexoNkhz0eqLtkEBsmm0lbQh0U6f7S7tT7fq8PcpcpKoUkTUDOaEQ+7QSxQ12utYk3g
	HhKsd03Z7F3nyI9GlGAoJP0/Qt7lQIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754518003; x=1786054003;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oaqukWOvjnqduMOZkaFZu0eoQBevzC+4PNgtMUvuSbE=;
  b=XS5I7d+Q3EBW+4+BNKExv0p9mNwqzdaZqsYVQ288w0dnElX/7tG/c6MK
   5HNFmGilhzTvlSUm4DGGEuEYpvtNNMypmTrQE2wtrOohJd50drAzqasS8
   ccLaqCDAC85ZlAt4S0TDTdFeSMsnKyCBVPE+iJzlpOIEpQ/Ek2ZQaEXNy
   6yBKRGJnWwMZO88xtk0iw4wVSPGTFoRcD7ORG4ZFl54OfqvrNIBwC/8R9
   me8oggXIuEt7mWLmedxS7YCvbRCS2pHaogK+DD5o5OcATPY0/1J3FjLVK
   ECtsp47AhlmFjqKGxriaQ0WFagwFqxXIbjmRg5L8Xn0eGcgWmd1f5Wjjv
   g==;
X-CSE-ConnectionGUID: UwQHlxv3QVm7l15aL8XDxw==
X-CSE-MsgGUID: ZaY2nEi/S3eA3HbqjWL/Mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60478491"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="60478491"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 15:06:41 -0700
X-CSE-ConnectionGUID: yYEBHRQKQNeIUKyQIAmMbg==
X-CSE-MsgGUID: 3iQbChD8R0ujUwgic2K68w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170155989"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 06 Aug 2025 15:06:39 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujmHN-00029E-0j;
	Wed, 06 Aug 2025 22:06:37 +0000
Date: Thu, 7 Aug 2025 06:05:54 +0800
From: kernel test robot <lkp@intel.com>
To: Baoquan He <bhe@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [sj:mm-new 39/45] arch/x86/include/asm/atomic.h:23: undefined
 reference to `kasan_flag_enabled'
Message-ID: <202508070658.s1RZB1Fd-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: j71mpqckoc1wbxpge1dxf9bdaydwrdco
X-Rspam-User: 
X-Rspamd-Queue-Id: 6ABFE16000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1754518002-397221
X-HE-Meta: U2FsdGVkX1+c2dXVyXzVlBcd/IijB1TUKlOR3SOp/FA9/g3k29s/+46Y/kCrdekjq5xUpk1a+9lLal8rw9c/0H1Qwanfjf5YfxB22+oyYeCNh60013teKiIGA45v4kEUQMzZfVOwkGq/eL+nkZShX6AkeDAKOLrVZEsyQC0gI52yEcpgaVN1A32DLV5RSGvfq+cP32QPDm4e72oEfjUTClEUSVPsiw6odIrii25u+9771HUHhAHs/ZHk1d/uq4LvgMveDP3Rr286Y+MG0jEtgoA/fJfIhgUKNVnfGwCUZT3h31wvZ6O35ZcGDLac9Q1HYC1HhE1nRa1AJYVHna/qWJhfxZ2rC1AA1V7MBpUFD6m2pnwuTXUq+wvWjCS9kkuEnxsivRgePmocfo5nhbn9plgwj6KMMDbTZIMfIPB7LCX06Ncr94TveKAWvErdHcEMXCfEmjAj31QQTE6Ypi0JicfzjpY4ZqwYuEFGoIymSNH+D7x+edSl5zdQIaQVVSRx0jqILixuz7hifiAsguxG9zpMtHNiVgBmCgWAyRPGXX++lmebVOJ197+c3jUfNCgRIwOAj97zUSv+hb9zuHl6IkjpA/IexnYbBcwE5oUf5AtoMqJ0xaw5uJoV4FA3HdO2bWqvcfAszk/7IDWuR30pOqCVCcd8yeEBQI/gMBX7u3HNGOkIaA2Fdd20gN7d3QEFOU774qTAo5iEVZrcM8uw374CfAaY0mQQ+pdqO+kbDgKQST0n2/Fr5GIZRGiL3bebR4czQRiOsV9u7hwyQs+IBRONSgmrTMV8s7mOvL1s8FZFWr9o+XvJIEvg9NS5hyTtA7eqM1FF4b7tGyqytfT/Kl+BjFbgYRHJPgDgm1o5EXDLPRYfPdrROxoECNG3Zel+X4RjLak6DmFTp1xVCm4FmWNuDLZkIWpckHUIHh85VFjwsnIZhFfizK1gPRpIm9TS27KaaC0ktCNbd3++NYC
 PvcKw5nw
 nw3FWRngICJE6GRMrZUDAjkRUViynmLTeQnRZtTN1hPWWEPZtjEz4W5mLYlzQUrSLOGxb0Vqea7/LHqzzyyoVW97XREQgtFfPUS/RH2c54f/BYbHRAOuCpjC5yZhD0HYeTg8KcP+lLmD0LLmIlMdJetv4FqynnojRjbqdHOj17tZOlWYaggyboFDa/sXMCI+xdDu2pD6kSj/Ev3lTsb+wj0IALHn0yHeE/GtZztuiJoc8wyEn5+huwfArAS1YWbfy11rzVqGbnsuHqRg+YveYjF0dZS1pWUGhY/lVtIZl5zmYYGRMhXy9Q/qgfF/qdreTbY4P316jdztvjKaItcB3aCZt0tuTMrLz68WNllXH9t1K/VQ5HE+RLa1ZLrnXzIED73I1E/XDdzZTsRacD/C4IFRptSaXCBeAJMmymftAKak2qGHx3T7IQtpiUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
head:   b2a4beca30ba51331a16d7bb84387a70b692a66d
commit: 825af80daf827d439c7dd3e24ef5648cc338bc98 [39/45] mm/kasan: make kasan=on|off take effect for all three modes
config: um-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508070658.s1RZB1Fd-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508070658.s1RZB1Fd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508070658.s1RZB1Fd-lkp@intel.com/

All errors (new ones prefixed by >>):

   /usr/bin/ld: lib/stackdepot.o: in function `stack_depot_early_init':
   stackdepot.c:(.init.text+0x21f): undefined reference to `kasan_flag_enabled'
   /usr/bin/ld: mm/mempool.o: in function `remove_element':
>> arch/x86/include/asm/atomic.h:23: undefined reference to `kasan_flag_enabled'
   /usr/bin/ld: mm/mempool.o: in function `poison_element':
>> arch/x86/include/asm/atomic.h:23: undefined reference to `kasan_flag_enabled'
   collect2: error: ld returned 1 exit status


vim +23 arch/x86/include/asm/atomic.h

5abbbbf0b0cd4a Brian Gerst    2010-01-07  11  
5abbbbf0b0cd4a Brian Gerst    2010-01-07  12  /*
5abbbbf0b0cd4a Brian Gerst    2010-01-07  13   * Atomic operations that C can't guarantee us.  Useful for
5abbbbf0b0cd4a Brian Gerst    2010-01-07  14   * resource counting etc..
5abbbbf0b0cd4a Brian Gerst    2010-01-07  15   */
5abbbbf0b0cd4a Brian Gerst    2010-01-07  16  
8bf705d130396e Dmitry Vyukov  2018-01-29  17  static __always_inline int arch_atomic_read(const atomic_t *v)
5abbbbf0b0cd4a Brian Gerst    2010-01-07  18  {
ac605bee0bfab4 Dmitry Vyukov  2018-01-29  19  	/*
ac605bee0bfab4 Dmitry Vyukov  2018-01-29  20  	 * Note for KASAN: we deliberately don't use READ_ONCE_NOCHECK() here,
ac605bee0bfab4 Dmitry Vyukov  2018-01-29  21  	 * it's non-inlined function that increases binary size and stack usage.
ac605bee0bfab4 Dmitry Vyukov  2018-01-29  22  	 */
37f8173dd84936 Peter Zijlstra 2020-01-24 @23  	return __READ_ONCE((v)->counter);
5abbbbf0b0cd4a Brian Gerst    2010-01-07  24  }
5abbbbf0b0cd4a Brian Gerst    2010-01-07  25  

:::::: The code at line 23 was first introduced by commit
:::::: 37f8173dd84936ea78000ed1cad24f8b18d48ebb locking/atomics: Flip fallbacks and instrumentation

:::::: TO: Peter Zijlstra <peterz@infradead.org>
:::::: CC: Thomas Gleixner <tglx@linutronix.de>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

