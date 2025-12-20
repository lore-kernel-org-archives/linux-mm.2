Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5A4E668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 16:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4476B0088; Sat, 20 Dec 2025 11:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191A46B0089; Sat, 20 Dec 2025 11:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0917F6B008A; Sat, 20 Dec 2025 11:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9A366B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:31:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3851140669
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 16:31:37 +0000 (UTC)
X-FDA: 84240390234.09.0368DAC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56D96C0013
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 16:31:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gwal3aEK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766248295; a=rsa-sha256;
	cv=none;
	b=4Eb/2B3P1FrIQgFIPAAHDVHyelqaj3Pdqf0JLINyHb/Yl3wfTixMcV+GOB7HDW0+K1NBTh
	R1MM1DDRpaxtRmJL+tagIg/ZGIQk4KzB6wk4kQrk7GNxuXAUbSGCQCfX6Ca4k41uvWpEha
	kBSbBHNNO6mcTFszeKbu0+CMjRcfcqY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gwal3aEK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766248295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guk2WXaRfNrS7/XdrKE0e71POJpSI0KGpPl7HIkjCpM=;
	b=icdISfdvEpTn67JvDhfKO2KUKQThkQsjC0L61DX1QoFyE71En+xaaa26EWN09zak4XEOD5
	N9rP9wc2GE3S3ncS5S1DYZpAGShbcFklP2S0OdlrFgIXYQNbMyl87ZmsupkDKFCNAX0TL7
	3yy/q5yms1KGwiyVFe37/YMrkypZzxI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766248294; x=1797784294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gFxpIXF13nGXH8jcMN3U6G/SWnqn2l0yxiGSNIRPPzs=;
  b=gwal3aEKqJtOeL/O/XS2zIBMFbd7s8J5Ylwqg8CZQJKZQm4gEWY06GWh
   MbouhWoTmBmSCkCg3hyOn2r1/4zwzDbJ5YREjY1SyeqIBRMi0SQSP9ja3
   iImrKYrc1lklHPwW1AZ6KvUlnEnS+oaI5gPJZjRMvnIdyaIkh34AuWWWV
   vSgyAwL/3JQDLZW44aXmVh9V07LGQPxwasWcvufNP2I+DFqru/Sz+c8fd
   Urpts0yKWKtFm2z9Hs4VzXSFgjJCSLmAJj9TvhB6khE8xPbhjDKnqEteK
   zxE6bam496a9e6OIsbHmbhkR6pQFTDWITEN0TAAEaEwHaZxxmGbiAwMcK
   A==;
X-CSE-ConnectionGUID: ZsM3wTOIQW2dvEBorT51YA==
X-CSE-MsgGUID: zRZrXrCRQtK1tcZ9H6v4AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="67375605"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="67375605"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 08:31:32 -0800
X-CSE-ConnectionGUID: 2zwW58zfTPKjCecmEA7d3Q==
X-CSE-MsgGUID: ub5ZTe6sRmib9MeS8+2Qkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="222605833"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 20 Dec 2025 08:31:25 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWzrX-000000004sd-0pgl;
	Sat, 20 Dec 2025 16:31:23 +0000
Date: Sun, 21 Dec 2025 00:31:08 +0800
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
Message-ID: <202512210052.w0bpUAAO-lkp@intel.com>
References: <20251216014721.42262-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216014721.42262-3-cuiyunhui@bytedance.com>
X-Rspamd-Queue-Id: 56D96C0013
X-Stat-Signature: guind3wnb61989snsefuzixxtexzadt3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766248294-884422
X-HE-Meta: U2FsdGVkX1+Z4dW9lW1ed60TXLpD53jt2wKlV6Ngemi2JSD8agBW0jfua0BrRXhUWAGv4t3s3kE5TMfRUP7lQvMZx1KEhc6fpEVc1Ly4ok6b7+Ck0vxP7IIwU3pBJxoE8MrLRfzzwKNrRajKR+huExl9RqKiM+UpVOQI1xvZhIvd6RwtCl/LHK8n/Vj3t+3PW0xKcN7JG7OJaMBuj7eNWaFHdySx7MfJNcnyJjXTwsSB/NXrrBTCLOfaepp1dXHp546Dlb3tGmfPAnA8okMXjZ0Ifumt3xTdpvjLb2OPGenlyHUWMtE4NwZAEXMlhAyixbtgOMIhAPLDIA4H8SDBISJvRt65QcWRZcGqK3uV4mVVsN36MYUkoTAIIf8rOjvVwqbmK4HLXDS1sifm8S/DZZmEaX7cFA1VXCJvdHmWY1+RypqAH4EtIZGzP4S70/noqxBAvwW+e4TAPx9iHScRfdRkPCbdL2R7gO4q2+cCpI7ItgtySOuy5diVFAtMknvhW6L7Pog6Tb3z9nDj/Oyu3De7WxDb40DjTsLaeb21NBjYqfeVi4yz5BS0rFSZYWu4w8RIWYvI9NH/X2Q+LtvvrJ9izEctTuho8sD9rrqJPbW0Xp+9rAMrgKN2TV2rmQOuworimPNrNuxOXvtWamjM0pLL/aZaxr/Y4if0n1yTVSlGxSEFYPNY4UY/nx5nR41V5sabW6iuNR8XPqN5TuO4kgP2ZkBlDlGbV0N1vsXYbXCt9xcXkdsBNTbodPMOlWVd08gSVytfnQdAaZmMx3IyNuLmsnQ5hK1f35ufp2kWpt3dDQTypSpBf2akfErJjPiMaFZCwR8r6rb22xmF8zd20OMyvBamVsCTsGT26VOTVRMQ5udupkJXDUjD0MqTbg1AWZoE3Kzox9aV+iyP/a8se6HJ2Yqq9+QxP8FO/P6ArPghK1dNzvTqtQ4ox9U3VKNLD6q/aC/eORk0gIk3kTE
 E/xRnJIq
 Flemt6lne9pEooe7YeF0tSRWtTBdFfrg7xnp6hAjdf26MbmOUaW7zycvk3iWHaID9wEY2fPLzxKd+fqBseZ7tz8yg5ZY4qt/g5Bmscao95NCG+1KwSQPZfVMfzkMXzHJH7aE70wtkUBLgFj2aJ8mwKDGSOadIBOhPLDO7J3IVwQr4VROH5hXi41OdI6yOXoAB5SHatWqkJvraWuH95UODh5zOGfEtW03r7PXVjgX2JA+GiIrkQfUJEXqv/vsjDJBkGEcHFDGG9UcGGlZOrumrz8DnBa4xAgVH0JFWJ1+U9EFKPLzLIJ5a3LaWQEignD+7umn3wkWXY8YVo/kfww+nooIHi8o2IJ1BHWCHrE/Ju8d94P2OG9oyRChhiu/oeQuCjxzhmIS3uD9CWj3hhvS1octb9sA+Y+mRlr8LRV9wUDnJJNYMteMmKcntIoeGoWxPQaomFV/Go2eRzmQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunhui,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19-rc1 next-20251219]
[cannot apply to bpf-next/net bpf-next/master bpf/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20251216-094956
base:   linus/master
patch link:    https://lore.kernel.org/r/20251216014721.42262-3-cuiyunhui%40bytedance.com
patch subject: [PATCH v3 2/3] riscv: introduce percpu.h into include/asm
config: riscv-randconfig-002-20251217 (https://download.01.org/0day-ci/archive/20251221/202512210052.w0bpUAAO-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512210052.w0bpUAAO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210052.w0bpUAAO-lkp@intel.com/

All errors (new ones prefixed by >>):

     109 | #define insw(addr, buffer, count) __insw(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from net/core/page_pool.c:14:
   In file included from include/net/netdev_lock.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/core/page_pool.c:14:
   In file included from include/net/netdev_lock.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/core/page_pool.c:14:
   In file included from include/net/netdev_lock.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/core/page_pool.c:14:
   In file included from include/net/netdev_lock.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/core/page_pool.c:14:
   In file included from include/net/netdev_lock.h:7:
   In file included from include/linux/netdevice.h:38:
   In file included from include/net/net_namespace.h:43:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, s4, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, s9, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, s9, 0(a0)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, s7, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   In file included from net/core/page_pool.c:11:
   In file included from include/linux/slab.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:8:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   7 warnings and 9 errors generated.
--
   include/asm-generic/io.h:854:2: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     854 |         insl(addr, buffer, count);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/io.h:110:53: note: expanded from macro 'insl'
     110 | #define insl(addr, buffer, count) __insl(PCI_IOBASE + (addr), buffer, count)
         |                                          ~~~~~~~~~~ ^
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
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
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/riscv/include/asm/io.h:140:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:5:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:13:
   In file included from include/linux/shrinker.h:8:
   In file included from include/linux/completion.h:12:
   In file included from include/linux/swait.h:7:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:5:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:13:
   In file included from include/linux/shrinker.h:8:
   In file included from include/linux/completion.h:12:
   In file included from include/linux/swait.h:7:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, s6, 0(a1)
         |         ^
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:5:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:13:
   In file included from include/linux/shrinker.h:8:
   In file included from include/linux/completion.h:12:
   In file included from include/linux/swait.h:7:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a2, 0(a1)
         |         ^
   In file included from net/batman-adv/routing.c:7:
   In file included from net/batman-adv/routing.h:10:
   In file included from net/batman-adv/main.h:207:
   In file included from include/linux/etherdevice.h:20:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:5:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:13:
   In file included from include/linux/shrinker.h:8:
   In file included from include/linux/completion.h:12:
   In file included from include/linux/swait.h:7:
   In file included from include/linux/spinlock.h:59:
   In file included from include/linux/irqflags.h:19:
>> arch/riscv/include/asm/percpu.h:43:1: error: instruction requires the following: RV64I Base Instruction Set
      43 | PERCPU_OP(add, add)
         | ^
   arch/riscv/include/asm/percpu.h:41:2: note: expanded from macro 'PERCPU_OP'
      41 |         __PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
         |         ^
   arch/riscv/include/asm/percpu.h:33:3: note: expanded from macro '__PERCPU_AMO_OP_CASE'
      33 |                 "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
         |                 ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         amoadd.d zero, a1, 0(a2)
         |         ^
   7 warnings and 4 errors generated.
..


vim +43 arch/riscv/include/asm/percpu.h

    38	
    39	#define PERCPU_OP(name, amo_insn)					\
    40		__PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)			\
    41		__PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
    42	
  > 43	PERCPU_OP(add, add)
    44	PERCPU_OP(andnot, and)
    45	PERCPU_OP(or, or)
    46	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

