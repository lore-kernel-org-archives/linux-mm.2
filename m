Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430DDCA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 04:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539D68E0002; Fri,  5 Sep 2025 00:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510FC8E0001; Fri,  5 Sep 2025 00:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426E18E0002; Fri,  5 Sep 2025 00:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7318E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 00:07:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3B6FC04EB
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:07:28 +0000 (UTC)
X-FDA: 83853862176.26.4CEF272
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00389180003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:07:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z9yZ4Lzi;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757045246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pAEKz+y6RQ3HaN3KHZgwD3Cm+8RXkyBbeVRPgIY0qI=;
	b=1ThKHA28Zissa8XefGgEIof+MVkRVMmkXfMqM2/e5IMIV2T5DcwbTJdq6+mEiBzOqsOND7
	llrTB//kPyOgow6coj6svkIEr4j9ye5UnPfHC24DCM95nlIZ/LlRHuJSIAx9SnIw6KZ2Cn
	zOKqbpf0nsFdQJ1giSPby537aRojDKs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z9yZ4Lzi;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757045246; a=rsa-sha256;
	cv=none;
	b=gFpViAS2JCwCKNj+uUGfO9LzfTfRc9p82rKepu9+NXuyjojKiogsdOSUJBOL8gdOqQfGIn
	/fDS4czrpdrURVSujUTJkx3sznQ34wuxvceOXmhOeD2SUELv5yTSpEdKnUcm2x/Dd0TieP
	hItUorcu/VOScBWVRejNSegkMkVJzcg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757045246; x=1788581246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4ik2CJTqkP7JyZGKZODFZYdcNPSHjRkjR5R+MPvEcCo=;
  b=Z9yZ4Lzi5UF9mKK1b5CTw6FgJ7Qsz5nGYb5qZlvhU8qZG4TnSxSEl/vZ
   XUOzV8sNEGdRC5melIDdHgSRKlUclNTdge4fOyoC6Qtvkif0ZRlm9U557
   mo88jZhovlkmhH1lKTZs6H6KPdRKZ/zuNyA7ZXDTozNT/5AMQBqtbIfqC
   YCZlg52XsS8ePOAFOmPAj8P51rQ5t31iDEAgTGkIAmdsg5kxGZg0+zkj7
   Zx7jZwwCqhKSkXbLX9dNUAYEkipHkJNqEC4KR/VMr2VxoUVq5b5W2mfG0
   OhFvDHB6HTSBKnzGOBzo333PKTxr+2F4frlHQh0T/W1mt+Udn3zXVhE0r
   A==;
X-CSE-ConnectionGUID: R5LxByfkTbua+maFArZINw==
X-CSE-MsgGUID: 3JdErbL2Q4WwzgQ5S0RvxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="70773228"
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="70773228"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 21:07:24 -0700
X-CSE-ConnectionGUID: UzhF1ARWTg+dFKBwSb3SZQ==
X-CSE-MsgGUID: SZdZEBhnTWOI4Prh+5yVeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="195723838"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 Sep 2025 21:07:20 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuNjJ-00001H-2e;
	Fri, 05 Sep 2025 04:07:17 +0000
Date: Fri, 5 Sep 2025 12:06:33 +0800
From: kernel test robot <lkp@intel.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: oe-kbuild-all@lists.linux.dev, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 5/9] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <202509051132.C0y3nq6E-lkp@intel.com>
References: <20250902154630.4032984-6-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902154630.4032984-6-thierry.reding@gmail.com>
X-Stat-Signature: x9nwzkzon4qe7akjfngt6bpsdotca3zh
X-Rspam-User: 
X-Rspamd-Queue-Id: 00389180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1757045245-353727
X-HE-Meta: U2FsdGVkX190JzY5FRia0rh2BqNjdZNq04C4exO0Grn/ojuAacjRT6Vo7ROEXVcVxeFb5/Fe2s+GUCWjqVQ1gYEwaoAzxmU7XqJZ7IEL35cgBxKndWOyGQH7p37B0aaFG7f+VbaHSPANyIGdEjs72mD7nMhB29PQquv3v7mUmu0TD8zM04mmRizCbMsil0aZQYpi8f3A7dmJMtuHyjU8TS2N7pRpw5T1fgRTB/usH+suF2cfuXisefqSByCGGjNcS2CeD6sBZELVYSFzOgi4WxzQ+ngg3yVgqttXJX9hFtHIx4qacJUfQR+Z/asreTJVTUr8seqNz7cIiv8RAI3NorayneNmcbT8yLas0HiulqPCE2aRmJRQBzqzACUJl6KabrcZ7DSvEaKjwTaPjePQONKfdT8bJzQ3Uz0wiQo0HSbU4wzv/vPaWRqwJe8bHop4figSvVkTC1xzmYhuAIvgIF4AaMGeSsa+KTbj3IhE9B0Hd+6xM0/fVMEYIV68qG71Bc+rY+HyuvTplL0NhIq3X93T3jdVyHymEeQlSPnvZ/z6Me+0RmTPntxFM/JFlsjDK47+0XLn12GeBh8xAqvB8AvEzaag862eSFjQQgwa+ECbaVWitA5qTK9uAMNt3Oh80hB7RzFRmbSOSItpZUgwKtYmczMqOA9D6A8rbPMCpNguHfwYkiHoJOcdB1Kh0aNsslPZZyfmOmsAVh+bI/xJTb/c/FOu17V2V7EyocqdwOYV0mXuSDrSDHBzO1udyvAx2EsyJ3kUOBTs150F8YTIUdWMA603IW5pHKlmvOkhermmzFh6r0gLzyuAmUwRNUaDSM6ykS8/9cmMOfPubmA9b/B39UosyodXqg+7d3mxmHCywsdhr4kEAiKsWqPtgTykmMgXzBQwNDgCqcsW1Mmyx2khrQEmByfiM1rXJer2zkY3nYuKfaUYfyBt8ftbvrheE6bNAYcTwuhUmLPQi0s
 wvA12UQn
 2aNcLXOvhCVoMJP+PT9gA7EaYK1a7i81DeUxT1xJbtvryf+a0sNNvPPYe+1G8cJXMAeDXfL5irf0ZAj77gXLEW/vDss6lV17+2ZMAiQIriwyrjwqwhDJVBPwRPYaeZMpNcfWAUGitqiosiyy0iLc4XKNZMTCq32+2vv2uOK9XcLSr2ZflGvgKw4y7D+CSRtyGFF33ouL7QRZUL4FoUYOs6qDo/3zlQww2R9QwUGOktmnY7A1tWU4bffEfXLDZmrt/R9C3Kt0Cy94Pcvu7ECnCWsfcUmogcQUnvEPRi8YTaK8iyH1zUAbgRIPcz6ZMf2fsEC6uRnAhm4yQaEDD8bsVnS9HiDrvU35jm3Qhp+591mAhD6FV2QWUO0H/5+p8EaUs6mtHPn2u/t7RCn8grABCrq5Hy03maGhokweGDpJmkzI5ZShTVR6HJDrgtuqV+J9wElxbsjWRPZJKX9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thierry,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20250902]
[also build test WARNING on v6.17-rc4]
[cannot apply to robh/for-next akpm-mm/mm-everything tegra/for-next linus/master v6.17-rc4 v6.17-rc3 v6.17-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thierry-Reding/dt-bindings-reserved-memory-Document-Tegra-VPR/20250902-235038
base:   next-20250902
patch link:    https://lore.kernel.org/r/20250902154630.4032984-6-thierry.reding%40gmail.com
patch subject: [PATCH 5/9] dma-buf: heaps: Add support for Tegra VPR
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20250905/202509051132.C0y3nq6E-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509051132.C0y3nq6E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509051132.C0y3nq6E-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_protect_pages':
   drivers/dma-buf/heaps/tegra-vpr.c:192:21: error: implicit declaration of function '__ptep_get'; did you mean 'ptep_get'? [-Werror=implicit-function-declaration]
     192 |         pte_t pte = __ptep_get(ptep);
         |                     ^~~~~~~~~~
         |                     ptep_get
   drivers/dma-buf/heaps/tegra-vpr.c:192:21: error: invalid initializer
   drivers/dma-buf/heaps/tegra-vpr.c:194:15: error: implicit declaration of function 'clear_pte_bit'; did you mean 'clear_ptes'? [-Werror=implicit-function-declaration]
     194 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |               ^~~~~~~~~~~~~
         |               clear_ptes
   In file included from arch/x86/include/asm/paravirt_types.h:11,
                    from arch/x86/include/asm/ptrace.h:175,
                    from arch/x86/include/asm/math_emu.h:5,
                    from arch/x86/include/asm/processor.h:13,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:59,
                    from include/linux/thread_info.h:60,
                    from include/linux/spinlock.h:60,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from include/linux/debugfs.h:15,
                    from drivers/dma-buf/heaps/tegra-vpr.c:12:
   drivers/dma-buf/heaps/tegra-vpr.c:194:43: error: 'PROT_NORMAL' undeclared (first use in this function)
     194 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                           ^~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:194:43: note: each undeclared identifier is reported only once for each function it appears in
     194 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                           ^~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:195:15: error: implicit declaration of function 'set_pte_bit'; did you mean 'set_pte_at'? [-Werror=implicit-function-declaration]
     195 |         pte = set_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |               ^~~~~~~~~~~
         |               set_pte_at
   drivers/dma-buf/heaps/tegra-vpr.c:195:41: error: 'PROT_DEVICE_nGnRnE' undeclared (first use in this function)
     195 |         pte = set_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |                                         ^~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:197:9: error: implicit declaration of function '__set_pte'; did you mean 'set_pte'? [-Werror=implicit-function-declaration]
     197 |         __set_pte(ptep, pte);
         |         ^~~~~~~~~
         |         set_pte
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_unprotect_pages':
   drivers/dma-buf/heaps/tegra-vpr.c:205:21: error: invalid initializer
     205 |         pte_t pte = __ptep_get(ptep);
         |                     ^~~~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c:207:43: error: 'PROT_DEVICE_nGnRnE' undeclared (first use in this function)
     207 |         pte = clear_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |                                           ^~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c:208:41: error: 'PROT_NORMAL' undeclared (first use in this function)
     208 |         pte = set_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                         ^~~~~~~~~~~
   arch/x86/include/asm/pgtable_types.h:202:48: note: in definition of macro '__pgprot'
     202 | #define __pgprot(x)             ((pgprot_t) { (x) } )
         |                                                ^
   drivers/dma-buf/heaps/tegra-vpr.c: In function 'tegra_vpr_add_heap':
>> drivers/dma-buf/heaps/tegra-vpr.c:8:21: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
       8 | #define pr_fmt(fmt) "tegra-vpr: " fmt
         |                     ^~~~~~~~~~~~~
   include/linux/dynamic_debug.h:224:29: note: in expansion of macro 'pr_fmt'
     224 |                 func(&id, ##__VA_ARGS__);                       \
         |                             ^~~~~~~~~~~
   include/linux/dynamic_debug.h:248:9: note: in expansion of macro '__dynamic_func_call_cls'
     248 |         __dynamic_func_call_cls(__UNIQUE_ID(ddebug), cls, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:250:9: note: in expansion of macro '_dynamic_func_call_cls'
     250 |         _dynamic_func_call_cls(_DPRINTK_CLASS_DFLT, fmt, func, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/dynamic_debug.h:269:9: note: in expansion of macro '_dynamic_func_call'
     269 |         _dynamic_func_call(fmt, __dynamic_pr_debug,             \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/printk.h:636:9: note: in expansion of macro 'dynamic_pr_debug'
     636 |         dynamic_pr_debug(fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c:715:17: note: in expansion of macro 'pr_debug'
     715 |                 pr_debug("  %2u: %pap-%pap (%lu MiB)\n", i, &start, &end,
         |                 ^~~~~~~~
   cc1: some warnings being treated as errors


vim +8 drivers/dma-buf/heaps/tegra-vpr.c

   > 8	#define pr_fmt(fmt) "tegra-vpr: " fmt
     9	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

