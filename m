Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D895CD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 03:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2014C6B0005; Mon,  8 Dec 2025 22:56:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B27B6B0007; Mon,  8 Dec 2025 22:56:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B246B0008; Mon,  8 Dec 2025 22:56:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E542F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 22:56:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B58614038C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:56:19 +0000 (UTC)
X-FDA: 84198570078.26.47187AC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F4711A000D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 03:56:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EuyJI9XG;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765252577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKGlg9Q55uD2b6Xvxd178rQ7huBIFnUcB/DRvI49k+c=;
	b=ph6oC9sKvddP9AlTDbxhDUtWFs128rvoYOi2hLF0hIjOL1XqwQwC30ByvQRw5Osyz8cFdL
	E551IHbakfu5kYyHke3S93x+7cEV9Ps8Yw0Nky1af+pzCyktK4iPdhFJWg0ocfCxQMaX75
	N6lQqcuhZDkm91QVftowLdOQDIBPg9Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EuyJI9XG;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765252577; a=rsa-sha256;
	cv=none;
	b=CVFjfnFmCbLKi27nElMmbql8/OxAweAHyexOQSFY+lR5iCQX1yC5TbMCASQEqQvyt3LGO9
	7v4VQHm+LV47Qqaa5BSOOXM43u6d5R46neVwIUMwpbdYVjn37BQortAxcK6QAeYWD7dCSp
	rRXkodKGC/vVkM3SiENvGGq2zsSeQ0g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765252577; x=1796788577;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7BP/S/pgzhOWIgTxUdCLG8fbFzYoQrglr8XUeSf1EHs=;
  b=EuyJI9XGytyL87zFdUF8uWp8Vx4/5pJrZ8tRCVbM/TAt+RItNFX7eoj+
   W7hHUnfDBSyrHsZ097sh0dLONiLCCsedTu45xMmdlv04JGb0cOfChDhlT
   nEn9XPUV38H1f4LXjRVIQAeeHWpB89K7YC66yAgNi6P6bMlX5kx94FzDw
   qQCYyHmhHnXRgm8oi9KsEf03zSCkbvv/+4m+3VQLAGO/eoTCraPH/FJhs
   W22DJyynkYQyR19X78VVPRI+6HG449AY7IWuf2NOVeer/3htZGeBYq6MB
   jj6Z6WQ4VEVyYRuCCKfyiIgVmR6iqG7NkyWCgihhwd0PxicGhrXL5Tlh2
   A==;
X-CSE-ConnectionGUID: /TL8p4h/TQuEd1uh7HfBxw==
X-CSE-MsgGUID: x2YGh43fSDWH8Sp1HJU2ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="67284327"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="67284327"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 19:56:15 -0800
X-CSE-ConnectionGUID: GP2DZnxMQm+Hrj5HWbbDlA==
X-CSE-MsgGUID: 1Rq14/z4TO2zsMNQ7ndFqQ==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 08 Dec 2025 19:56:08 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSopa-000000001ID-0gUl;
	Tue, 09 Dec 2025 03:56:06 +0000
Date: Tue, 9 Dec 2025 11:55:54 +0800
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
Subject: Re: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
Message-ID: <202512091137.3Qw1dX94-lkp@intel.com>
References: <20251208034944.73113-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208034944.73113-3-cuiyunhui@bytedance.com>
X-Stat-Signature: 1tnr8cwi9roibwdbm3nj7pbcwctnmecn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F4711A000D
X-HE-Tag: 1765252576-601311
X-HE-Meta: U2FsdGVkX1/P3QmAJ2WEb50cDR+kLFK6u1cw+Ka7IjcDS1yPWOy9iqO3FXF2cmmvzD0+eeKWCeFoGywvOXCwHbvYLFkTsKDat6qIWvl6seA8dlrsdzwFzrQbL/lIHt0odS99cNI9Y5/YvPft6ZS2lHXKQB66cx/0ZticII0Jyxni5TlQjrnQ3JQ3QOz8vBj0UEQx7ZumFJIkHV0OEsUk0hysbyXYlpBvUSrebe1Fl9jIyyQsPyNpH0dW8hkxYy+ViYslLdKIwXr1rfDBXkZRvHrYylRRfSu83TOr1tNgiqJw+ii69eiZGtKLApuZbXXfOP8OAR76fwzQlwWuN2K3VBJ9LhgFlPYiit8Ev/p+HHQfpjhMjlRMcLCdN36BOttyEf1TjJPIIqWljel3KxGPDPcacKvlP3aCoCMdND8p2ualo6yoE4LtXFGAbXHrGGN14ic5W2Zq0Uo7v9fcD5tyWN2IpIGp4IkJ87wJKTA+1hIcpOM8w7KSYK3SgmP4eAMU64/heMkbKQKqZ1u8ME277bnqLb7UNmf0rBqV14GfS4C3yMeDNu77eaitislII5cwb8P/rKB/zPJniYnbsbNmwT0UDMiThEdg6U0TvceFKUVYIZTwsOPtoqezFV8I4Y9q3AIGpF5dFbx/sVtP/0Ky2WGK2UcqKa4MfnYcVMe2hjSnScVjR9xmNDbsiaBVnGqLD8P8g55EOmU3t/gzvNwwrlVVLEQWSgHIMESilxwMPiIMeIb1u/b+1JFeGMOCUoJKLtphyRkW3FX3AESP6DtUJOPFm/Lddh1tYf21ZEZi52ZULHhPPBlQR69j8ipNKl8xUMEyu8DHp+2qjpcT+LvacOXUDhyI8RwE7jvy3viNiZl0Wvnnj9A4BC/6qbEb6i4VrF6b/zP2kdlh6RJIc7zFbKmhXRLOFWxueN073mo2w9fchYEdQ9VMQp6TKQXlI6n/
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
[also build test ERROR on v6.18 next-20251209]
[cannot apply to bpf-next/net bpf-next/master bpf/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20251208-115407
base:   linus/master
patch link:    https://lore.kernel.org/r/20251208034944.73113-3-cuiyunhui%40bytedance.com
patch subject: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
config: riscv-randconfig-002-20251209 (https://download.01.org/0day-ci/archive/20251209/202512091137.3Qw1dX94-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512091137.3Qw1dX94-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512091137.3Qw1dX94-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/slub.c:4380:9: error: call to undeclared function 'arch_cmpxchg128_local'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    4380 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^
   mm/slab.h:24:39: note: expanded from macro 'this_cpu_try_cmpxchg_freelist'
      24 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg128
         |                                         ^
   include/asm-generic/percpu.h:529:47: note: expanded from macro 'this_cpu_try_cmpxchg128'
     529 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg128)
         |                                                      ^
   1 error generated.


vim +/arch_cmpxchg128_local +4380 mm/slub.c

0b303fb402862d Vlastimil Babka 2021-05-08  4371  
6801be4f2653e5 Peter Zijlstra  2023-05-31  4372  static inline bool
6801be4f2653e5 Peter Zijlstra  2023-05-31  4373  __update_cpu_freelist_fast(struct kmem_cache *s,
6801be4f2653e5 Peter Zijlstra  2023-05-31  4374  			   void *freelist_old, void *freelist_new,
6801be4f2653e5 Peter Zijlstra  2023-05-31  4375  			   unsigned long tid)
6801be4f2653e5 Peter Zijlstra  2023-05-31  4376  {
b244358e9a1cd6 Vlastimil Babka 2025-11-07  4377  	struct freelist_tid old = { .freelist = freelist_old, .tid = tid };
b244358e9a1cd6 Vlastimil Babka 2025-11-07  4378  	struct freelist_tid new = { .freelist = freelist_new, .tid = next_tid(tid) };
6801be4f2653e5 Peter Zijlstra  2023-05-31  4379  
b244358e9a1cd6 Vlastimil Babka 2025-11-07 @4380  	return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
b244358e9a1cd6 Vlastimil Babka 2025-11-07  4381  					     &old.freelist_tid, new.freelist_tid);
6801be4f2653e5 Peter Zijlstra  2023-05-31  4382  }
6801be4f2653e5 Peter Zijlstra  2023-05-31  4383  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

