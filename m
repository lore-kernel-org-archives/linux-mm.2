Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C397EEA849
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37006B0005; Thu, 12 Feb 2026 21:16:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7596B0089; Thu, 12 Feb 2026 21:16:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01476B008A; Thu, 12 Feb 2026 21:16:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 926CD6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:16:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F8C5C1A05
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:16:03 +0000 (UTC)
X-FDA: 84437818206.01.807F393
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE12480009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:15:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BkzFt8i5;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770948961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=4f6UKJqv0EZreU2cUTsC5yfYMhOv1c5A5WABK4i+u/4=;
	b=S4wP1KO6CLOkuDZLmpncnedw9R3aimP13d9UGT8uEocsbiFazG8V+j4/OlBbutjTFzh58d
	9iJeisU9d1wmwz/lMtfZfZnW8XWFFXKmVsdaeX7+jXEjJIt+etw9wbcLPqvw1BoQmoSZhC
	A+G85AcEBl7haHN7rGcc8ur7pqbQ0ec=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BkzFt8i5;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770948961; a=rsa-sha256;
	cv=none;
	b=3/BybBl1jFNKclq/6PHoYxzqB+XGHi8jmBLAaoHfcD3sGo80zK72Tu7TdAXViq7zmux0sS
	N0gGrZWyzQiAjmDqW0SLC9awSBWnKgLcHJY3MNf3UkBiGam+vqcBAqFi0buAJ8ptJt4Ga3
	dNpRSNDcnfd/Y7SHj7a6fNY0G0RjpeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770948961; x=1802484961;
  h=date:from:to:cc:subject:message-id;
  bh=n6ODPch9WajSMYJP0Oxh5+ni/vR+Gf0X2ZdeGR3S3nA=;
  b=BkzFt8i5n7eX0xlYA59zb6tRzEO8k4SNhye0szgEIPLSMv6e4ivpTl0N
   lz3nMz+g+UdIlMDF/oUk9bT2dbxKA7MVa36vcCSOu9Is7IGvqE5z7Th/7
   UINB6CGlnVfLDI/FXgbBf9dxlK3riGnYgn/eXftETPiLZc6JgVneZ53ca
   0ddz0jC+lH862jCXA6zjLf0mIFWMLKPOP1IIpaoS/Hiq3/dR3AYqLKGRd
   ARBotwMIh4RuKRsd+oMcKx6xnbdE2Efq4D0xWBs+q6Wia9L+1rAWAxHwc
   ZZgIBUMydOvTpR4Qg2fpwEBomqKCn4YuPq2c2jRFssDzMibq4XfpF0bLN
   g==;
X-CSE-ConnectionGUID: FKd9KGImRZ65nfFRu78ubw==
X-CSE-MsgGUID: gA+9zInLSV2yQPgwkuyonA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72039459"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72039459"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 18:15:59 -0800
X-CSE-ConnectionGUID: KtnzGUohTGmA8xGajQ7Uhg==
X-CSE-MsgGUID: Syb5yLSLSjOPtH7soLe43w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="217330197"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 12 Feb 2026 18:15:57 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vqiio-00000000uZt-0gMI;
	Fri, 13 Feb 2026 02:15:54 +0000
Date: Fri, 13 Feb 2026 10:15:04 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Finn Thain <fthain@linux-m68k.org>
Subject: {standard input}:44576: Error: pcrel offset for branch to
 .LS0066 too far (0x3a)
Message-ID: <202602131056.yW8CcR2i-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE12480009
X-Stat-Signature: w3yoqkcfiuxi5ip3k7e9hjqnhcezoz3o
X-Rspam-User: 
X-HE-Tag: 1770948959-251288
X-HE-Meta: U2FsdGVkX1/kvyTlk2RvBoXvbpdAI4Pt3xVDLEzqsK2xkZLLcQZIQt8WD9FvzbUBj20lB6D5uTD4VaVgwwlIbKtR/k7wzLd/p8OGCYkMBMik0AHQIWTO5YwXy5yNI3jevAI0z2CKHqQbJ296LjgfIoRncUyriaTtVqcy+tM3LctehjSdhe+nfoMMdBggs7fZMVN97l4VjUMDRlmXfQfNylPhRbxdS4ont6D4QJT0Fc4QEEge4fDMQixcQgcx1mX8e2rEusG5/LaHrs9DQ0QJEyMfkwFm4FgG0MOsKqY1gzVxgqEUisbjQ0jHA9Mcsj+PbKyc8HIa1+FT6Y+zcXSqHdPc6bcZSHhOUbmZlnNVxIOAIjhqX45lOXMsQlfyql5ugmuRpkco6Rz2coJ06FG9UbvwPnVvoXcpuYx3tQoEmWNCniVE9lZc2YxNHzz6V74J5uG38j0rjc4zBoX/9kqArxg957poIuBb0Gzjcl62hLWwZOLEIo3MMV6szbLJbyk+flk1aNxyHSLrMNCPmCCjKd5bgykW7exdpkuzDoCMEPLfEamV1btzYPYpCbyjkin3XGQwLhH0at94ewNihxR+uthOCrEIL91G5aqriTVDQccZXrSufrwZUtNCGUA700tjO0YuJzlQ6ArrqIhEx/16xk1W9FMDw42ct5uw7/DmixtrgO2XKhqBddrsBN7I/dpOvOKhTrHmamE2xp+aftRsMVlC9K+AfiOOpO60LZBpofhK7hUr5Y/zPT/Vd7+Kw3j9pPCr/gncN0U9euGi8RfffP4gZWC0s7et2P1eeZ0I0lCIZowOsRWoF023ahxpIYTTOqx4BxEPSpDzU+uaY2KKtC5d/d7iRQejLENn2i2QugXJCom8zatSjfe82wulSXmLopfAal4VHBCo2AlIjWNdksZRJKcoNH/hvMoNnglmJBEr7SIF/JGVoX9ZmTtaocNLCcQEPtCHSB42TKLOKcJ
 cW/Cdkpo
 dWfck4YxOx1alZwpdlv04UCar4f/nemubwuo/PIFtUP/sdXGd8qgVrlEl8ZKbgwuj/dbhAmqRS2Gm5x7FOQGzOFja92e596o16O/P6tV15KT0b34LWsHqNlssuuqM9AwB1YM9Gh4jeY6bD9Afrtx0WSFXY+Jy2mlBr7YknRsocR0rc8v20IrHzMo7RFwSHViRn0owXb4epJut/l9noxiZJfFOB96M99J7rPxg7lFBWi9h77KEPvJ+QWddPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   582a1ef360a05bff4350bbf6e383f61d26b804f0
commit: 80047d84eed25e9c92cfb9169980a0dfec110246 atomic: add alignment check to instrumented atomic operations
date:   2 weeks ago
config: csky-randconfig-r071-20260213 (https://download.01.org/0day-ci/archive/20260213/202602131056.yW8CcR2i-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.2.0
smatch version: v0.5.0-8994-gd50c5a4c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260213/202602131056.yW8CcR2i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602131056.yW8CcR2i-lkp@intel.com/

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:44576: Error: pcrel offset for branch to .LS0066 too far (0x3a)
--
   {standard input}: Assembler messages:
>> {standard input}:16916: Error: pcrel offset for branch to .LS0027 too far (0x3c)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

