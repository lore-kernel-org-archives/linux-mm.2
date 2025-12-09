Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C9FD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849766B0005; Mon,  8 Dec 2025 21:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821E36B0007; Mon,  8 Dec 2025 21:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711036B0008; Mon,  8 Dec 2025 21:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCB46B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:13:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E806A5887A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:13:08 +0000 (UTC)
X-FDA: 84198310056.24.888C1C2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32858A000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:13:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BDNa51IP;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765246386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glDzOI3BvTHH98VHUkTbJrYG9vrLLEleyF2NCIMuros=;
	b=gdpopyvxCtFTUB6ZRD3vQX3GtV9y9ad6cuY5gVLd8F+zHihoKElhljCtqImGKEnYBZMC4n
	DIJnB73pGJmt2nfIhsU9cxAGQZQv0SHsXWHDeCjh+tRJV3A3vZecKn8qhOJc5o3uh4uQun
	gzNvBxLKEC/AVOtPHThrI8g3gW8cPxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765246387; a=rsa-sha256;
	cv=none;
	b=XUksX2uzKkjBh1RPgD3AIuTjmh5I8AGi8hB0u+VSMcCqActyiWujkLL72Ep7yE3VnVezf3
	hHxkYTdGV8UlJXKKj89REWZMmTm4fcQsPUkodlhSxZ+/6Cc+PvSJAA384m0ObS3ofqHS51
	A4ojoJUeEvk+EWsnEQA8mu6fpt78q4k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BDNa51IP;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765246386; x=1796782386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t/n0Kb2PQ4ho9yOiWbXGt8ntdqBp4Egqu5F/G8IrLH4=;
  b=BDNa51IPSdCYzCC7yJaSHB4MIwyXpumKfWmctY8rCZ4l/88fKq87fxpQ
   XjKWNTKL2NVYdSHcaojZe1PB3iRLqw0kZy6CMS3eWZDCvnnbxpx5jXJj7
   xwv2Kjvji7y56iqSEtSlKSCRkCvcJi2yyA499N1Ijn1COY1YO7kVHgzhH
   kpIilO9nmbQm6pAgKXhCa/0bZh16kHb3noM2fvjflxtx3I5XkdQUTCzIk
   2VZZ/Ft8nfSPNeQhirN8VT0jHy0dIGkKOKYI8KrmPSd6iDv3dCw3CErwp
   xdlAOasoZOEteKbhWBRVMX8AClnsdX/a6t4jUTyMqqrB3RjmyWyvvEtJ2
   A==;
X-CSE-ConnectionGUID: a+3ML+FQQxKycCTPp3SVlg==
X-CSE-MsgGUID: GVOmOhscRkOGrfjx4C6naA==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="92673865"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="92673865"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 18:13:04 -0800
X-CSE-ConnectionGUID: kMd9kbGSTMiVFdT/ioshHQ==
X-CSE-MsgGUID: 7VGMrLKDT/GWc4gYkwlMOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="219442996"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 08 Dec 2025 18:12:58 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSnDj-000000001Be-2v6q;
	Tue, 09 Dec 2025 02:12:55 +0000
Date: Tue, 9 Dec 2025 10:12:47 +0800
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
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
Message-ID: <202512090907.agDhp0Nd-lkp@intel.com>
References: <20251208034944.73113-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208034944.73113-3-cuiyunhui@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32858A000C
X-Stat-Signature: i7wn73ii9rcx9qe1heytp7f9phmp94ha
X-Rspam-User: 
X-HE-Tag: 1765246385-660393
X-HE-Meta: U2FsdGVkX18N6ClFlObmRlTtHs/814Py4BFi6pRWg+/wdDNdlGiC+uv8QNsJ26i36Doj7Gj4mMV6W75MuKALPHlO68q/HAthfi+qfyP5yrwVvhCpmh3c7BBDmmD4fjEYu2qUVc+gaWeT7XLZVzQ9ce2heUxc1akV6wycYwXwp9ZQOmyvHTmviWUGXA3I1TpU6Y4KUhrY2WDbdX5OFPEtnu9CJHzVwNwqww61EeEKPFGm9LhY7Pm0LqnwbxixiWxmh8BPv2+f/YbC2Xm2HRwi4sC03rNNoJPuEXTTPhIOvmoyy5Xzh/75qy5ayIV3beCwbOY6pBe2FjjbV38VVnS4m9OoARgj9wqgAtR/QLwZSGFjL4svQA2Gqx09DSEQWvdNtJl8b2XcqBw60S0awW3n6D+NtgNhz3UzuMEy9TnVoNQ97Dt5xQfYmu8FKvTA4r3UqS5x+DO0sjRvz8WS72l4I6XrEw7k8paENgjvBW8WlkkM8qWJmId5A80Pp8uzyRtEMDIhs6HyEV9LRlEUnHg6vT36XlvVyiczvHlKtyCXbsylQWDPlceZMotI5F5Wmjede/hHjik9u+mEo5kh7b74k/jqRFwgiukawqw4NFamw19dUAg7Apq+LcR4fpYeVafIiaw0e3yHSPe19M7jItbtLENNSXuD/eqKalNnhtanm3siHaSbdhYOkwASL02jFRuitndQSMLLU8UBbC6HzbicZ2mWJFkgaUuyDCVbYOdxXXAT4TR6gJf8eByQQBSIwRGoavo0J70BttpnQaR0HYtpNNDW945wIa1/D1g6+w+vjdD35D9j7YQBtTWgTROtqKnCN+PuMvelMcun1WEroENZyfZdwjtpHv6ZIgPFgsRBMO47+iYoW4YdomiWgRjwh7hY/isP+/ipr3pUtPS0ptk3jwHLNCqLDlTKLviF29BGwV+VopcTH9cQDIPP1DltHQ6zsOFhkdL9ajTXtNUYr90
 9HNWJEXe
 2MrCH1MxpdJJBLY1iN0IMWE7HIEtA1iWX21hOBIrT5ALjI+kfm161aX6fn+QehOow3kBscPVlQRnTrABhRRozAQQO3m2fYYsbqzkgVNn4LMxLKp5OVGM9iGwK7rIBtGJgH/gZ7XDSBHw/mFfjJMn6jTXh6rNQhchW3hGQlScs35jh/xz0cLh41eSx3K2MJnKUnQdYKfIUJ1uPCDZPmFCswSAnmkLnCdCdyZ8j0GDzNXzXG0cvlftVs/LLi3yeK96Xk4DYQsks8Je0MzWnKSceMO8Ewo9ZL0p2hK5qDoMJahoU4bJxl4DgctigQXeI8J3D9bdOCPJqEMbNR+9yeYt1iGOY39wRJx5DbnDF2w3JkRAJeZuKAaTjkuhXfCMO1F88QyEZLPyt1xFGOmIZALisVrHOoNNxKEYc/johobFjyM/9iIEH8JmMOf2rrkBbDqL26CDhBad919tcgPfnH4M0FJGfDjtpYn64ycVCDBEEh6nlQCQ=
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
[also build test ERROR on v6.18 next-20251208]
[cannot apply to bpf-next/net bpf-next/master bpf/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20251208-115407
base:   linus/master
patch link:    https://lore.kernel.org/r/20251208034944.73113-3-cuiyunhui%40bytedance.com
patch subject: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
config: riscv-allnoconfig (https://download.01.org/0day-ci/archive/20251209/202512090907.agDhp0Nd-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512090907.agDhp0Nd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512090907.agDhp0Nd-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/atomic.h:80,
                    from include/linux/cpumask.h:10,
                    from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:7,
                    from mm/slub.c:13:
   mm/slub.c: In function '__update_cpu_freelist_fast':
>> include/linux/atomic/atomic-arch-fallback.h:414:30: error: implicit declaration of function 'arch_cmpxchg128_local'; did you mean 'arch_cmpxchg64_local'? [-Wimplicit-function-declaration]
     414 | #define raw_cmpxchg128_local arch_cmpxchg128_local
         |                              ^~~~~~~~~~~~~~~~~~~~~
   include/linux/atomic/atomic-instrumented.h:5005:9: note: in expansion of macro 'raw_cmpxchg128_local'
    5005 |         raw_cmpxchg128_local(__ai_ptr, __VA_ARGS__); \
         |         ^~~~~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/percpu.h:231:17: note: in expansion of macro 'cmpxchg128_local'
     231 |         ret__ = cmpxchg128_local(ptr__, old__, new__);                  \
         |                 ^~~~~~~~~~~~~~~~
   include/asm-generic/percpu.h:110:17: note: in expansion of macro 'this_cpu_cmpxchg128'
     110 |         __val = _cmpxchg(pcp, __old, nval);                             \
         |                 ^~~~~~~~
   include/asm-generic/percpu.h:529:9: note: in expansion of macro '__cpu_fallback_try_cmpxchg'
     529 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg128)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/slab.h:24:41: note: in expansion of macro 'this_cpu_try_cmpxchg128'
      24 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg128
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~
   mm/slub.c:4380:16: note: in expansion of macro 'this_cpu_try_cmpxchg_freelist'
    4380 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +414 include/linux/atomic/atomic-arch-fallback.h

9257959a6e5b4f Mark Rutland 2023-06-05  413  
9257959a6e5b4f Mark Rutland 2023-06-05 @414  #define raw_cmpxchg128_local arch_cmpxchg128_local
e6ce9d741163af Uros Bizjak  2023-04-05  415  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

