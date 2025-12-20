Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680F4E668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 14:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991506B0088; Sat, 20 Dec 2025 09:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F2D6B0089; Sat, 20 Dec 2025 09:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F2E6B008A; Sat, 20 Dec 2025 09:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9E76B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 09:46:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D9C11405D6
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:46:20 +0000 (UTC)
X-FDA: 84240124920.23.3AC530C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf29.hostedemail.com (Postfix) with ESMTP id 894D3120012
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:46:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eCxmx9fx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766241977; a=rsa-sha256;
	cv=none;
	b=ZWCkQj0PuPL3B5LqNpaU8j6n5/aJqAAh0ZL/uFV4vZTOqJn2MtuMSeDlYOgIiltpUJEJT2
	UxBJXOhSmvSQOeSoLBodGX6Ivf9IOc2MmKdQaMTHteLzJJdkYlnTPgiW3+uBvLe5/Fr+sd
	6MNH2QGMZKGQRl1F9i/N7HYA1+S4kME=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eCxmx9fx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766241977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqrQsZ730aQuJQDgadVa17wgtOV7hwAK8gwkm7UQcjY=;
	b=U99lFnY4M8BAVQ5LSEdP/XPa28Cxi2xItWuPxD8+9wE/0ZooicNoxgnRS/eAdVC3s29ulT
	nJhxwTZXcjwJGhMdjzg33CeVpf/KtgKeolHSkj+DyfBfEFODBJNIsucLBqflMR9FdLNER4
	zLr0VmFJhtuG96c6Dd3LrkFIACPYMpQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766241978; x=1797777978;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0/9AqWDR0QjCmpU+CYPu2fRg5LQPeaeBa8kwPoIxDO4=;
  b=eCxmx9fxNPbiUEUMnwxLX8eqwRf5kRVsthlRO1H4H7IQVV93Z2rjGybR
   b1voqrmrZXQXcdQc3xZz5FHe+y/laB/TWoYT+ozKfG/kA98YpelojHhlc
   VB2mr4GdtGoqTqCqM4mzYIjjaW8r9PI0BnOTq07iQGXHswZm5Q9sVq4tX
   bbJ44RGfDWe/HnEPKB1P4CIakmbp67ubY/MTz7vHmdForH9fcXWFHckO0
   Tjg6Jr+5QcwDLTJn4HD2bwggaUJuAYfvG943LiKdHIzTRtl+JqM++yxXD
   QwUeoykApRVPHpQCSbA8F5SKiooiPxMLTip/GTZeMzVXcy/06JOLKE0NK
   A==;
X-CSE-ConnectionGUID: tuE1KMbAT7Otkmpp9vey7g==
X-CSE-MsgGUID: XXLpGtkETjak4PNLIlIxNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="85760390"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="85760390"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 06:46:16 -0800
X-CSE-ConnectionGUID: zaOdA7FhQs+c+8EGhahraQ==
X-CSE-MsgGUID: Gd8F3kBzSy6LdBZnFHEqKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199024654"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 20 Dec 2025 06:46:09 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWyDf-000000004fu-1cUP;
	Sat, 20 Dec 2025 14:46:07 +0000
Date: Sat, 20 Dec 2025 22:45:45 +0800
From: kernel test robot <lkp@intel.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>, aou@eecs.berkeley.edu,
	alex@ghiti.fr, andii@kernel.org, andybnac@gmail.com,
	apatel@ventanamicro.com, ast@kernel.org, ben.dooks@codethink.co.uk,
	bjorn@kernel.org, bpf@vger.kernel.org, charlie@rivosinc.com,
	cl@gentwo.org, conor.dooley@microchip.com, cyrilbur@tenstorrent.com,
	daniel@iogearbox.net, debug@rivosinc.com, dennis@kernel.org,
	eddyz87@gmail.com, haoluo@google.com, john.fastabend@gmail.com,
	jolsa@kernel.org, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-riscv@lists.infradead.org,
	linux@rasmusvillemoes.dk, martin.lau@linux.dev, palmer@dabbelt.com,
	pjw@kernel.org, puranjay@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3 2/3] riscv: introduce percpu.h into include/asm
Message-ID: <202512202218.FI6bB5kV-lkp@intel.com>
References: <20251216014721.42262-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216014721.42262-3-cuiyunhui@bytedance.com>
X-Rspamd-Queue-Id: 894D3120012
X-Rspamd-Server: rspam03
X-Stat-Signature: gak9xhdcje1drnzg6jgkeygsyoqcuu71
X-Rspam-User: 
X-HE-Tag: 1766241977-523520
X-HE-Meta: U2FsdGVkX1+0dmkThCHMUW76CxZ/g1HzN0BvrKuQL0IPW/GmxOpvcQsVH20BBK66y0JbvvBIm7pFtw3ThHmgxfp089yJzENrN6vHmfeFnOswo87Bd/TRgkXzJ9dXGX+84th1oeTrrTYMhMUI1SqJ/FsJFs8dzEISMa9ZYnQuXyyAJz42DR/XixpCW5Op1fGxEwTKRQH0QA2i4vWlZiZXvXGkws3mD4EzzW0YA82L3wc/WLo66DiMI0KuEbk3wAqnxZ74yqlDjb4zBzhxAonO+YghfsjWddNXijcozQU9gMHJtCevEtZ66XaqRwVq9NOTRKuaF2vDUZ3CdoXGisUmuqe9Z5WEYJvH6QIBo7EIYIqIOX1GwPPNo7joVtvc/jRq1FOcOe4LwzwxZiDgF2yQ+c9Iqs0xhII+mGmikf/a7F3Z46ob9Rsjeghb1IBNAK716/499vddK8guiZLIpQKx4t15gtSuvIk4gL5qlqrYuAKglyYO++kcs4Vl8wxKTgNlCEvwdhPEJ2w2fJOnt38m063KP6Fl1NsvF/scqypfJ9KdHLfydZF6+niI5f1nrGlsmGQGFWJ0Ed6N/K1SonmMiOO81VEcfxinc+eWi6jCWL34vLzFlCX7ko5xrzfOMxDVHsyjw1GCNw0JDaDUE6huSk0GbRQcA/KctZpbP4/PXACJOgdaYiZDy1yAw4LeBBSf7KoN1AkmRBuVUwu0fqDNX774K4fC87NZ7kYfmM15/6JTavxxnAcC8mswEf09utsWqoBrvLAAXjY/H+lLjDCPfe01Lr0FhB+1wH+CMD/NHMTGamtGFLPVVXr7FtkTm0qmPaVyA91tv/CbCAaGTi3nJMazcP9zZK6YqRX9HcdVyAuALW31NBu2UaYDBXDDdYaxvf7W//PZCi99UnKvgpTkEw+IwbrB/Q4lJtTUTt+eNrJbUDvYpwe+dYkax+oIN7SSySiSXQq0njxNCPP7Cd+
 FnRMEjkp
 is89tRHOVC+vcN6IFDz5N49RkojvlSrz26cPpgj0duhHnR6XpvWVX25EdT/FoMnLx2+T+DnRrcv76IKhiaIuPwK8o7A+6SkFTMl9i1v/a7pg2p29K2sBfdhTUZjaf5E4vRf/CSJEdQEYrs6wlAtDMMPHJrT/ZUCn23qh2QaoA0BG1c6WTMhbz2scXXLEGRUD5T8FO2GglkuDc/zI2Wf03hy4Zbzb6bObdU8aWZEaofYOrVIiFDjVNu4vOQnuMUteHHtJkgcB5hRAIq0r7R71WM75fi9uJZGdvmw7EegWW/iJ6iEesYeW24fyeiOEr182oPZAKnijghKZ5dXK+9DUfoVnwtHtTE4QjM/NLzdIEbc5dmqhr42KLfpk7rHU2eOTIbQU/ogqh5PuoxevReo+UaWbOr9WbHsjfylkiP8c+zNHyP9fCeVOYlqdgvd8DkWE3YODi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunhui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19-rc1 next-20251219]
[cannot apply to bpf-next/net bpf-next/master bpf/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20251216-094956
base:   linus/master
patch link:    https://lore.kernel.org/r/20251216014721.42262-3-cuiyunhui%40bytedance.com
patch subject: [PATCH v3 2/3] riscv: introduce percpu.h into include/asm
config: riscv-randconfig-002-20251217 (https://download.01.org/0day-ci/archive/20251220/202512202218.FI6bB5kV-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202218.FI6bB5kV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202218.FI6bB5kV-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:846:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     846 |         insw(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:109:53: note: expanded from macro 'insw'
     109 | #define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from mm/slub.c:14:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:854:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     854 |         insl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:110:53: note: expanded from macro 'insl'
     110 | #define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from mm/slub.c:14:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:863:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     863 |         outsb(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:122:55: note: expanded from macro 'outsb'
     122 | #define outsb(addr, buffer, count) __outsb(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from mm/slub.c:14:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:872:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     872 |         outsw(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:123:55: note: expanded from macro 'outsw'
     123 | #define outsw(addr, buffer, count) __outsw(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from mm/slub.c:14:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:881:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     881 |         outsl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:124:55: note: expanded from macro 'outsl'
     124 | #define outsl(addr, buffer, count) __outsl(PCI_IOBASE + (addr), buffer, count)
         |                                            ~~~~~~~~~~ ^
   In file included from mm/slub.c:14:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
>> mm/slub.c:4385:9: warning: variable '__old' is uninitialized when used within its own initialization [-Wuninitialized]
    4385 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    4386 |                                              &old.freelist_tid, new.freelist_tid);
         |                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:2: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/percpu.h:110:24: note: expanded from macro '__cpu_fallback_try_cmpxchg'
     110 |         __val = _cmpxchg(pcp, __old, nval);                             \
         |                 ~~~~~~~~~~~~~~^~~~~~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/atomic/atomic-instrumented.h:4810:32: note: expanded from macro 'cmpxchg_relaxed'
    4810 |         raw_cmpxchg_relaxed(__ai_ptr, __VA_ARGS__); \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
   arch/riscv/include/asm/cmpxchg.h:265:24: note: expanded from macro 'arch_cmpxchg_relaxed'
     265 |         _arch_cmpxchg((ptr), (o), (n),                                  \
         |         ~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     266 |                       SC_SFX(""), CAS_SFX(""),                          \
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     267 |                       SC_PREPEND(""), SC_APPEND(""),                    \
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     268 |                       CAS_PREPEND(""), CAS_APPEND(""))
         |                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/cmpxchg.h:218:32: note: expanded from macro '_arch_cmpxchg'
     218 |         __typeof__(*(__ptr)) __old = (old);                             \
         |                              ~~~~~    ^~~
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:47: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |                                                      ^
   <inline asm>:1:5: note: instantiated into assembly here
       1 |         0:      lr.d s9, 0(a1)
         |                 ^
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set
    4385 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:47: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |                                                      ^
   <inline asm>:3:2: note: instantiated into assembly here
       3 |         sc.d a3, a0, 0(a1)
         |         ^
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set
    4385 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:47: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |                                                      ^
   <inline asm>:1:5: note: instantiated into assembly here
       1 |         0:      lr.d s9, 0(a1)
         |                 ^
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set
    4385 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:47: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |                                                      ^
   <inline asm>:3:2: note: instantiated into assembly here
       3 |         sc.d a3, a0, 0(a1)
         |         ^
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set
    4385 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:47: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |                                                      ^
   <inline asm>:1:5: note: instantiated into assembly here
       1 |         0:      lr.d s10, 0(a1)
         |                 ^
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set
    4385 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^
   mm/slab.h:31:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      31 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg64
         |                                         ^
   include/asm-generic/percpu.h:520:47: note: expanded from macro 'this_cpu_try_cmpxchg64'
     520 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg64)
         |                                                      ^
   <inline asm>:3:2: note: instantiated into assembly here
       3 |         sc.d a3, a0, 0(a1)
         |         ^
   mm/slub.c:4385:9: error: instruction requires the following: RV64I Base Instruction Set


vim +/__old +4385 mm/slub.c

0b303fb402862d Vlastimil Babka 2021-05-08  4376  
6801be4f2653e5 Peter Zijlstra  2023-05-31  4377  static inline bool
6801be4f2653e5 Peter Zijlstra  2023-05-31  4378  __update_cpu_freelist_fast(struct kmem_cache *s,
6801be4f2653e5 Peter Zijlstra  2023-05-31  4379  			   void *freelist_old, void *freelist_new,
6801be4f2653e5 Peter Zijlstra  2023-05-31  4380  			   unsigned long tid)
6801be4f2653e5 Peter Zijlstra  2023-05-31  4381  {
b244358e9a1cd6 Vlastimil Babka 2025-11-07  4382  	struct freelist_tid old = { .freelist = freelist_old, .tid = tid };
b244358e9a1cd6 Vlastimil Babka 2025-11-07  4383  	struct freelist_tid new = { .freelist = freelist_new, .tid = next_tid(tid) };
6801be4f2653e5 Peter Zijlstra  2023-05-31  4384  
b244358e9a1cd6 Vlastimil Babka 2025-11-07 @4385  	return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
b244358e9a1cd6 Vlastimil Babka 2025-11-07  4386  					     &old.freelist_tid, new.freelist_tid);
6801be4f2653e5 Peter Zijlstra  2023-05-31  4387  }
6801be4f2653e5 Peter Zijlstra  2023-05-31  4388  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

