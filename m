Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5973C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E637F6B073C; Fri, 14 Aug 2026 20:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14A86B073D; Fri, 14 Aug 2026 20:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A0D6B073E; Fri, 14 Aug 2026 20:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEC2C6B073C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:47:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33B2D80295
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:47:10 +0000 (UTC)
X-FDA: 85101664620.06.E9CA008
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8275180004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:47:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i16Ylhwx;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786754828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=M1GjqDqY9YQuYwoA8TTDDCJRJWVT3vSgoBMi5ybFBqs=;
	b=rwk+W/c/SG/11dJYtrW8H4/IYDE9vbBOS0P71gKLThwj3/aUPgztQKSd7yrHIOIhM2YPtQ
	W3f37jDbUU5vsylMW4rKwghL08QRhGTChyiOwA70VEclO0G47IpMPf7f0ARvfhB+4CV0Se
	zsdhkZcfl/wdcBD7NpuyBpQLDhbD9xw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i16Ylhwx;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786754828;
	b=CAElL+sm7UpOe4rNCRuOt+j1DzwdckfzbSUV9McdsJqZdmULshO9l4+EJT8ef37SnUqWUH
	RJKRdudg9c8iIG+qqlsNV5/ZI9YZgvjeeArjPjEspylhaso5C0bmgSlI5ewbHgCMvAnkpu
	HW72lN9kq+7fUxRXRtneWRhV70WC2+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786754828; x=1818290828;
  h=date:from:to:cc:subject:message-id;
  bh=etHYRGpiCmuGavxDzFQSiyhQmmDpoZp0Rpvk1+7Lw3U=;
  b=i16YlhwxOYFpiti8Yuv5jx1oxxWX2mO37LvJWOXwoCtuIiAmuXbvKaht
   AvBLv3iybxi/zWCj5LcG1et2VenqA1T0urqnGYf50osGHQU5R1bTd7AwZ
   gzfYxesNmBrqcidP72xJbNApdT3EtIShchotWmXrJDuLoBim1GaUzY9F/
   UtxCcq62g4e0Q5NSpszNLsbeT2IRF21jEobzsY+FJTmwHfeOUsWP/UvnT
   UbFKi3RXNgrZAS81Og9kOGWz7kTM3EdboedjvH8fEtXsW2A1v5z8IV+Ai
   roblfF911IiPbjMGP+Qsg981mBjL5dTMVjPEp1h6DJUGzeSC/zU6yKQ01
   w==;
X-CSE-ConnectionGUID: a1ys1nuGSQS3w7u/Y1Fw4A==
X-CSE-MsgGUID: BUu2a5SPQNm+kKG92MVnQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="98488003"
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="98488003"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 17:47:07 -0700
X-CSE-ConnectionGUID: m/53ieOYRSCGMuNFckhJEQ==
X-CSE-MsgGUID: 5Xv7btRAT9C28Rd209XX7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,224,1779174000"; 
   d="scan'208";a="263030089"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Aug 2026 17:47:04 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wv2YA-00000000afq-28NQ;
	Sat, 15 Aug 2026 00:47:02 +0000
Date: Sat, 15 Aug 2026 08:46:33 +0800
From: kernel test robot <lkp@intel.com>
To: "Jordan R Abrahams-Whitehead" <ajordanr@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Nick Desaulniers <ndesaulniers@google.com>
Subject: [linux-next:master 14076/14447] WARNING: modpost: vmlinux:
 section mismatch in reference: tracing_gen_ctx+0xb0 (section: .text.unlikely)
 -> initcall_level_names (section: .init.data)
Message-ID: <202608150840.187qzdRz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8275180004
X-Stat-Signature: xwfbzbqx31amgri1btry1tnjxbpkjs1r
X-Rspam-User: 
X-HE-Tag: 1786754827-364928
X-HE-Meta: U2FsdGVkX1/sWYb6/EMwBxVwkW24+EG1L0HtJ33rLX/DDHeEeRCrlQr+x3VIK3rOzihDAP8ukg4hL4pl1+bPop5aHfgDgPoiyype5mxelb9oNo6pA2kIRBkeWQf7Jcw3OTf715nHYv8uKUuQprJim1g7bppCXQhvzGlo3Z3ZzSYqfNp4MqnkEXxQ/edHBaVeqmQoi6z1qPPvrs4frOKHpoLF7Lr8T/VJIy4RXXhDRRbLtLmHeRAcF1soBBKrcrJUDvKgN2jCKjA8on7SK3dueM3D6tQ4fSz5KQ18AbcRe5oTaDeLlq78TX7URT9vbqsKtTuLfy5/nTf2g3RUpJ1XvmcNEU5pN7m88VRajhv/8f6Cx4816a27yRkijls40VOiNVR8Ug7pFu1PGM+p6td4DzV0W9XJ2EhHYJ77IBQqojgmNHhCyOneHmYiJk4ySgYG4gTPmptjOmXcxnngy08C+45tklA8HJTU2/VN/ADGxvnoQd3f2E+YeZazeuuVAVwxUqCj/5oVrm/Ll5Oohw2YG22BodYjl2qqceBGUWzCYw4rVv2S9JEOyuYxmMXXZozluavQNcsrVvA/eaBzsYXmH65y5+X7vWuaeZP+qa+1La/fJ5qT3SxyFpvEgYVqG3EQWfmeY1nglqfG4WGmfR0zrsaTw3TVE8THqiiiA9t1CjO+zlXl1iVxsSClutJuH6TzibJ5wYr41ZwkUjtQbvuEu+7t2mND0VVhbIz+T/qvT+DjgvIYawnGpqYr51h6zUWVkBSCwQCEI2TPk+VJy0v5GxbltMskll/Sgzcbp/XP++i0F7OOco9Urdv0gEqMpAw3nYp8niJueehQQUMelcbbHcZmYPM5YyCrPxciKNik6fWKRzznjyFIaGgABG7Qqvwg7ijxfJ09u0PD0utvct2Ec0k5Y9wevHFYUZJjnK21m9DOPdKWeFV1xVIluoSF7bKhioyX2e2/5g1vfKzjA/q
 cZ9BfDma
 bls+/Xbg7U5yUW3WbegiGFJjITu6EvB5ihIlNhhQijriZk3XoFm0zGArWe3073gagJPpjcCCFWAFscnoEf8p5zrQTPe9bP0YJcH/lU5Ro59IeNbBaOxIcT0jyDJiUt+w1Oby9bZZAIDWKUneg2H1KDceJIaqHsu0BSCxvM9uXgqsNu0cNaLLio7sAGvCnZEntMrEH00sXCgxRzRjAks9fHQPgdZh5t8F9QK4jskV8WkEPYu/MtcFpRRCAis9SvRyXrdZOcDomNO5YUb3xypKlt0DU3xC3pgVRopG1UAzs9YDMHsCybFtMQ4pqjxPV6EQc9eN8o+fDz28tUY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   2697ef8943c9985c14708a6429e21812693857b2
commit: 40fd9c2c1736dfd38593ae259600373dc99d447d [14076/14447] include/linux/list.h: mark list_add and __list_add as __always_inline
config: xtensa-randconfig-002-20260814 (https://download.01.org/0day-ci/archive/20260815/202608150840.187qzdRz-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260815/202608150840.187qzdRz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608150840.187qzdRz-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: try_to_run_init_process+0x2c (section: .text.unlikely) -> initcall_level_names (section: .init.data)
>> WARNING: modpost: vmlinux: section mismatch in reference: tracing_gen_ctx+0xb0 (section: .text.unlikely) -> initcall_level_names (section: .init.data)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

