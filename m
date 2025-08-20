Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2008CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 17:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4698D8E001A; Wed, 20 Aug 2025 13:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441968E000B; Wed, 20 Aug 2025 13:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E8E8E001A; Wed, 20 Aug 2025 13:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25C7C8E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:19:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D356859BF2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:19:47 +0000 (UTC)
X-FDA: 83797798014.15.32418FC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6375020005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:19:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WPaFPXMF;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755710385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6YpAsXZZzDkH/7EJfKpWuNpYHlgc7oSUoWpcR48r34=;
	b=o4QAt40DM7VUGOi+ViUo4I31XWG/79m5h1jx5FwUDaacQQHAuDKMyX8cKwPgJmvMt1jw+5
	2+ywyl2rAggTZt7b7O9DqAgc9fpLTzCD0FmwRfIAlwXE0SZ9wym8kLg3TphaQFpkDYhgw1
	xKaOgV1z9zBIXxG/VutqNEcatXSpOqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755710385; a=rsa-sha256;
	cv=none;
	b=Kmq+Va8KhztbHVWz6khsJcvFPb8pwMJDl5fwa9Dh6rkaWKtUMWNUu57hWZ+zdWWCqj86wW
	lxvQ0tmi8/aVRXOLdaQeMC+xfZ6vMKTU4vNp47dEK5W1TCva7QdhDUeyxTy8zLlQM2rMUY
	10DhOMqbu5H0uHOzaM9CJE3fddNLL/Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WPaFPXMF;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755710386; x=1787246386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GxHr6/54rgcy6sAclCD5AO7ktqqANCdjdS8twJwHCMA=;
  b=WPaFPXMFyioctLFG54NvGVKxUXSif9nXzGrKfAIDndUV00MR80CtzsID
   S1XWBv1/e+fgo4ONTTiw74USoXPEB+YYiAtY5e6kuujH8Pgbr0uDnrBNh
   YAzmzk/qRg67xNnn1OYz3YRh6nufJBSJz0b3+shNLwTw0YXi//Sr0pu4L
   f3OCnbJoTJDmfREq2Tr+rhrh8H5sB3V3zMpP4udQLqzfEprmzGS5ZToOX
   llU9LjrUoOYD7XTV8ZK5+ev3Yz5Eh0SzoA/IrvH0V4TU6OSF3Ej1v4t1H
   EFLfBjHje8gNrtPljA4mxUHWlPl5Y+durffbiwvm5Ov7735nrilg983F1
   Q==;
X-CSE-ConnectionGUID: 3p1DxkOiSri+Oc2W6iO6OA==
X-CSE-MsgGUID: 2BdRnm3dRbqJ/P4N1JCIZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="83406116"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="83406116"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 10:19:44 -0700
X-CSE-ConnectionGUID: id3NsaM5RTK6EUgGk1bUSw==
X-CSE-MsgGUID: F/GOHyWPSxGZCqOCHmhCXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167798899"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 20 Aug 2025 10:19:40 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uomTK-000JXL-03;
	Wed, 20 Aug 2025 17:19:38 +0000
Date: Thu, 21 Aug 2025 01:18:54 +0800
From: kernel test robot <lkp@intel.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Yunhui Cui <cuiyunhui@bytedance.com>
Subject: Re: [PATCH 2/2] riscv: introduce percpu.h into include/asm
Message-ID: <202508210101.WySkXlSZ-lkp@intel.com>
References: <20250819135007.85646-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819135007.85646-3-cuiyunhui@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6375020005
X-Stat-Signature: gwytz814bz5ui4n3ur8ciita6wopn1t1
X-HE-Tag: 1755710385-965914
X-HE-Meta: U2FsdGVkX19l0bkzzmmIknj1HJg+4eosGj8NSgsmynrX234Whg7oJd5EjtItB/IVVhcUBwH8+N7jGfJ9sgGNYgMlF5WHKQPSQ7vbcieqMDCAr2FlbLrz/BJRoLGAcjU0G4WlkMuWZZWYlQN1rBAqI9Zxvt9eTI3Rtxu2o5zE4BYoCloDtqAqAzxA0msvaTjr5n1oXROjZfa2TA8GelNcP76f8anpcorpcLJmzlpNDEz2ijMPyzPmxPqYYarl2/iP0ldbnMr36uZQ1aiXtS4iWrtHX5LnWAxUrmbVkw5EIVma+39drlLFRc+ILZswKDYHj8k9CS7uJMHEBRpH+EWBqY6HKmUYHLr3kPjoREeRAjJChWLoq6lt1wcCDfd7ZgqJ6LylZAQRLeniSwkjbHoejCdBzA/pDthYNTDNyj/cP540BSdkelazQhuInrhBwkaKtMMXMqaR9a+mBsRjR2FaZMysfjQdPUjSokAcZXOGF4DOBajlYdiqw3ZcuA64VKSzkPU/GR17L0l2WwJMkhZJIBLLiKE792oFiPjcefzzOCHCgseBXgNGZA7ypoyw8+8wy9/W3OMsZMcuSvCPbi30g0vd4/4611trpfBAcycPrSsldsgAppejiBO5bibKY55lHTLeLUcteR9hqRAbx00BQrDom/Ms3dL/cUxW4BbMYfzG/kLyIFyCDqEiGJoFwQimMEV91PNXW1FplH2CargncULG96B2D3D7o+oz+6Oi5ZhRgI1owEPMd/HaUw42KvdGuA0rzVPS9So2RlrIcGhGE7kICObydhbhb9ONWXYQ+x5VoBV5kjZqig/Qq8cUmTp67uVlgIsSO48+Qye0qLAncAFqBoK99CA/8UqajTQo6tOnlQUVOND23k3ct0r/3OBUMoMjETZd3ORiE9DYl/b2y7iBiYKWSihbKEk/vBS8g3pNXgM5iMeZkdElSlfy4PaiXoLXNOCrtTCRe2UrA+B
 54VPCtLB
 T1U05vHuRk/V312gLomXdtqldRBvQSRAlD5vc7Md9xUHUFjRz3qk/xx7v1x4DFhMuKKKWWxqGo3ChSkk/aDKxCy5gtnB9LIv69+nFRn49a8mru2bNbOvACl5KQQZLPpCLC/0/sgt/Y/GM/Fru3QuoGv0/BzXybCI2iUwxaqYUG8FWv91C1cx/72ay7ke4N/G620EZjuEaghuGlxt0ge2KyJaJDltfOieTnhsuTqLX6hBupS/veJeD7/fHef/HCgne2DApcj69gtDGqOL7vvmtV40yqH30Fvv9DXTYjgPuxi/MACbYLfmx+Bk+WYAngipDohjN0G2MgHfu2bEX/eRuKPqCAPCBlit6BGIMUDeth99fHwNf4LrKku0zJjP7Hjd3vF0OjhmYWk7oJRExeiey/2NUgN8IwdfpVN8EvRYqjhjTtwYQ57ei4xINttq48TWKGpn8
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
[also build test ERROR on dennis-percpu/for-next v6.17-rc2 next-20250820]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20250819-215256
base:   linus/master
patch link:    https://lore.kernel.org/r/20250819135007.85646-3-cuiyunhui%40bytedance.com
patch subject: [PATCH 2/2] riscv: introduce percpu.h into include/asm
config: riscv-allnoconfig (https://download.01.org/0day-ci/archive/20250821/202508210101.WySkXlSZ-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250821/202508210101.WySkXlSZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508210101.WySkXlSZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/atomic.h:80,
                    from include/linux/cpumask.h:14,
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
   arch/riscv/include/asm/percpu.h:131:17: note: in expansion of macro 'cmpxchg128_local'
     131 |         ret__ = cmpxchg128_local(ptr__, old__, new__);                  \
         |                 ^~~~~~~~~~~~~~~~
   include/asm-generic/percpu.h:108:17: note: in expansion of macro 'this_cpu_cmpxchg128'
     108 |         __val = _cmpxchg(pcp, __old, nval);                             \
         |                 ^~~~~~~~
   include/asm-generic/percpu.h:527:9: note: in expansion of macro '__cpu_fallback_try_cmpxchg'
     527 |         __cpu_fallback_try_cmpxchg(pcp, ovalp, nval, this_cpu_cmpxchg128)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/slab.h:24:41: note: in expansion of macro 'this_cpu_try_cmpxchg128'
      24 | #define this_cpu_try_cmpxchg_freelist   this_cpu_try_cmpxchg128
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~
   mm/slub.c:3638:16: note: in expansion of macro 'this_cpu_try_cmpxchg_freelist'
    3638 |         return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid.full,
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +414 include/linux/atomic/atomic-arch-fallback.h

9257959a6e5b4f Mark Rutland 2023-06-05  413  
9257959a6e5b4f Mark Rutland 2023-06-05 @414  #define raw_cmpxchg128_local arch_cmpxchg128_local
e6ce9d741163af Uros Bizjak  2023-04-05  415  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

