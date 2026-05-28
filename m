Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4B4CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 20:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0A66B0005; Thu, 28 May 2026 16:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197EC6B008A; Thu, 28 May 2026 16:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5366B008C; Thu, 28 May 2026 16:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F044D6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:30:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C62C162171
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:30:13 +0000 (UTC)
X-FDA: 84817970706.24.F5B140F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1493C0008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:30:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WNECfLJB;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780000211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+ua/mjvw+I573uBdpP33D1T+QacscMq/uJH6WyPC4M=;
	b=QsxpxqGl8lKhp5xRJ6ACOiff2TSivByTtCiOKiQSAP8hjxF/4nCLsYfAzIBQsUNXj4V972
	m74bLYB71PSSkG05e6HFIk+YSAei7waIja9wI1Y/LT1ZbUL4OJxJpHYm37vC8MulD6wtwG
	KUttVCR9pFt1KyS7RdTA6C6c40KK1XI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WNECfLJB;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780000211; a=rsa-sha256;
	cv=none;
	b=LxoOJQKfsTgjAXDSlSDx675u332KcP9aWBESE3YoDY0njw70fm7tmonVGtMkR3wEI+ZMBf
	NusAkvITxd/smxpMnj5xLaDzW+XOPmM4gVPHUKrM3tQc9LthObDUESqzKVpYfRsiNqoIGk
	x5y/N1N1p/38lMVlvQdLlPceTESFnCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780000211; x=1811536211;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ODNxYs339E2YF89enQLYGjmAuCOA1Oyzei0NMHrO2jE=;
  b=WNECfLJB5/V5KiFGe1WoC25tQadJRBTKhD8xp027vhgbqBauxQ8cAxW2
   9YLUTj859XmftfS0bt7jgrjUxoEae+jOq0DspzaPb6IeFdKqtOCNulhLK
   fMfesUpm+PNhciUFGJ13ZOuo2rUARcyswDGYPyJMTxP4ODkBon9JLZALP
   0ky2noE93c64QigQ+d29gVIyychlAZcmGiGL30ATPN/uOZagt1mS7MUhY
   mHqP2LY39KGCukKm1wvL6IgEIzYzWkOjNetGih9dSfT/Revm6gUmDYDXA
   lwJBKzd867Yly4XVN66PuMtQOFjyHBTWtIU3DOzFtYH2XNVfLKazfC3rj
   w==;
X-CSE-ConnectionGUID: aRLgJ+1dQoG4CipUaCqtDA==
X-CSE-MsgGUID: yOi4cuKSSGquZFAhGq+A0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80751927"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="80751927"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 13:30:08 -0700
X-CSE-ConnectionGUID: D0LZuv9tTsKm4VJfEniS6w==
X-CSE-MsgGUID: XweaD3oNR+Sqd5m0kCTstA==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 28 May 2026 13:30:04 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wShMf-000000006Q2-2z5X;
	Thu, 28 May 2026 20:30:01 +0000
Date: Fri, 29 May 2026 04:29:08 +0800
From: kernel test robot <lkp@intel.com>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, harry@kernel.org,
	akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	zhang.run@zte.com.cn, cai.qu@zte.com.cn
Subject: Re: [PATCH v3] mm/slub: free prefilled empty sheaves consistently
Message-ID: <202605290406.mjAKJqbo-lkp@intel.com>
References: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525211000387LYqTHmxYL900XIB8qwV3h@zte.com.cn>
X-Rspamd-Server: rspam12
X-Stat-Signature: kksxabnsbhz979s5du8niagksyhhihzm
X-Rspam-User: 
X-Rspamd-Queue-Id: B1493C0008
X-HE-Tag: 1780000210-385628
X-HE-Meta: U2FsdGVkX19abeb3gonvhkjsttDhnZQNJ8jPywmyHhz6G0rMVVIegPjxRXLX4LihGILrOdAorHtRxaF1ivKJvbH8sqd3OYfbAitc6QXZLiuxWOL+0UuDkhLZD7mT5JrR4GObw1hFNcq03s8S2/yH314Ro+oTd1TxMo0cX5IgmeCnoEzlP6bYgGKH/3WWNaFKdua3klfzCFYhoIJmKAGfRhp+YGUbwnKMu0gGCvFbGBxDYK3YX2T4KVgJ21UVIEqnD9jQIJ+SeotHISxvCfbdUadp7vAmmf8oG0sIulr0+SAlZL5K5oszWE4ZMszPewefo5Qk+PBdlPrZrx0wXhO+R+zlthQZs5KozrJxfgYVAHuvMA8Opw5ciKErc6q85+Tz2TUo5z1LFwDNAbMmoPnjwWYq0BvxPY+CiI+j0kkK4qIJof3ig34DXyqv6fd2JGMYTwI2p2vcxoYqLypTeBr/pIUnCTdYQ5PAFdwXm8OPvwFwRXWBDIt8zBsmITKIRr4bl1wvfwRoqQm6EcZ753QBb+Uc/a1oJJIkSnIXealrPEW65hTxtgvAk4B27mnMirGPSg3ASbHWIcnEw+7cnXY9czG+Jm7R9x35dNy8kEVEdUDYnqW3ivvIAlbD1rRovA9uPbFwlbhPuHXONuoPoPImRPKVoH2MNOIWdSyvPTfRLwxjxIBsYlw7c93OwdL185Dx2b/2TVttNPAM4Kq8jJw6m66itXBY4d7RECOKjh3Z6bofzT0ITShmUT9DycHTmDQgLwEexK9oQ+aTkvwMLhhBBra7Z5VVueblN+Ya6uI+MokTmvnAMel1gkEJhfDX2+vWv/vHB0JTX8IFFjzpZe5aN3IInNNjqj/0VhpCWCCROrjzlWOMefNxiuNtn1sZdsZFbsuhDfRrrDsv2zOWv+E73KXZ5cNQDji3njHAav/FFj6S7gCljt4nBhYn31u5OA/1FM6Sa0DzrBtDusbUaCv
 zJbNpPgG
 xDT4U+s8RjcEFF2NuOZRgH2v4l2X5WAGRgFsjrgmDxnif5pEliTTboPDS7QZupFUeo+6bLyYWPf9YS/keyhd/gy5SL1dW38OrBKFvtPXZL8CgryGQ1RLDBqK8mEZca2n7fos6iH8dZP4HWP733dVIcaemDRn+gOt/c45zq1CXAGmUZmJ3Xg8yc7rlqM0pMzyFmRfNKsgPVEotQA/kFwPOpcB0FKrlMcH4QtSL+FOVngdTS28ucklV0AVB7ewSsyuPJjyDIGEC8Tlf8e1C+LtnC47mJKox47rIbG5jiYYcdB5Z5AXMfTZ2SkbnCrfqsXpoT08X6bIGcML/kIKAETmptmYrEaa5VZeqsskDn+5yXwhCSAp94c+Z03l+lcxkYRylY+tAsoD/lC5fxwC10dVADnTNduMQv2ty7mliwL4ocJaW8Co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/hu-shengming-zte-com-cn/mm-slub-free-prefilled-empty-sheaves-consistently/20260525-211805
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260525211000387LYqTHmxYL900XIB8qwV3h%40zte.com.cn
patch subject: [PATCH v3] mm/slub: free prefilled empty sheaves consistently
config: powerpc-randconfig-002-20260529 (https://download.01.org/0day-ci/archive/20260529/202605290406.mjAKJqbo-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605290406.mjAKJqbo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605290406.mjAKJqbo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: relocation R_PPC_ADDR16_HA cannot be used against symbol 'decrementers_next_tb'; recompile with -fPIC
   >>> defined in vmlinux.a(arch/powerpc/kernel/time.o)
   >>> referenced by time.c
   >>>               arch/powerpc/kernel/time.o:(decrementer_set_next_event) in archive vmlinux.a
--
>> ld.lld: error: relocation R_PPC_ADDR16_HA cannot be used against symbol 'ppc_emulated'; recompile with -fPIC
   >>> defined in vmlinux.a(arch/powerpc/kernel/traps.o)
   >>> referenced by align.c
   >>>               arch/powerpc/kernel/align.o:(fix_alignment) in archive vmlinux.a

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

