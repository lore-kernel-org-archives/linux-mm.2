Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A54ACD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52D88E0017; Thu, 13 Nov 2025 14:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29A98E0007; Thu, 13 Nov 2025 14:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F598E0017; Thu, 13 Nov 2025 14:38:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B34168E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:38:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 626F014012A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:38:06 +0000 (UTC)
X-FDA: 84106594572.29.6AFFD38
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5B63180011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:38:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SDTS0g7C;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763062684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AhN2wb7T6jwZnqtd7QyeGvu3i9eVmsxPLBsM9WDtnM=;
	b=gwdSUn09v2yH/sbuieE1VyUp387puGWzF6/Yu7ddAs0MjmtsfdrMzc8rsiAoP7UVXWGta1
	iKZbOevLfmRlaqWlWMNaa9QHQiuLmcV18lVNpsMdEs5anQa5Kz4w+xuqqRrpMfdU8taa9/
	FeR+eMlSG3KFrswGBs/c6Ie2E7o/9lw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SDTS0g7C;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763062684; a=rsa-sha256;
	cv=none;
	b=S1nKObvfHDKFKoTO2w8TudPof358g1noMuHCSwjpHXndePfnSmVGnex9V6WRWQIkegXK/f
	s0RMmo8R6WkZZ3ySLFiyWfkALajPyIhK+qBqGkehDn/o3z7sUueH4y1CAYHAnB/gCIXJ6w
	ROJC4OYRtSPBVSurgewugWc9gFnDvhM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763062684; x=1794598684;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HEJSaA71TuXh1QUGrm04DbY3CyzCazML7OWPoC5lA1M=;
  b=SDTS0g7CB/avHDLgtiDAtSG8U/CAc9eKrR7rrsWVVZjXFlQT8t7bNnC0
   1+JQ5lUNkHHrj19J0VC0NrDKou6isYc9ORUblKDxCuLk+SPulbntDGKma
   s81LA6TE4bxBek4VSq4b68o9Q0dr1UJ4LrbeUPkU4rDrNUz8lfsLHUXMA
   AZr+u2DbT3iHn7kzFnIkUw4qEziEvU71FnOLEsckQrg/HtPzkN05ta6cA
   XIE4O2TuHIHWjljFcaM/qYJgntIxP3aTo2OA5NT0K2YJVJXWdUkBSTQhX
   21wrC5cI9msvDJnfTdaFNMeDpWlmUHNu2izGCpT9EpotsHmUdTh1S42Rn
   g==;
X-CSE-ConnectionGUID: HXuTwM7lQWCYcOn4eFfHqA==
X-CSE-MsgGUID: 0aX+IEiOQgSH2iMr+qY4xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65250466"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="65250466"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 11:38:02 -0800
X-CSE-ConnectionGUID: soxY0Zs6Ty2frP213V6FJQ==
X-CSE-MsgGUID: CcjC+fnwTheaokIWwwZZ5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="193858615"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 Nov 2025 11:37:58 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJd8l-0005nn-2B;
	Thu, 13 Nov 2025 19:37:55 +0000
Date: Fri, 14 Nov 2025 03:37:13 +0800
From: kernel test robot <lkp@intel.com>
To: Yuntao Wang <yuntao.wang@linux.dev>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, Baoquan He <bhe@redhat.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Geoff Levand <geoff@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yuntao Wang <yuntao.wang@linux.dev>
Subject: Re: [PATCH v2 6/7] of/reserved_mem: Simplify the logic of
 __reserved_mem_reserve_reg()
Message-ID: <202511140307.Th0UqUd9-lkp@intel.com>
References: <20251113155104.226617-7-yuntao.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113155104.226617-7-yuntao.wang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5B63180011
X-Stat-Signature: d445urxo957wi6fhrbtqqwksranq887f
X-Rspam-User: 
X-HE-Tag: 1763062683-425349
X-HE-Meta: U2FsdGVkX1/LbFtFvTcB5LBak7qr3gq9XdTGdEIxyWsOX+h1Kgpccx6FIkIX6MntFHXoBomOc87dVHtSvPQkBMWcErzGD8brhHlUrtCqCXrbQFcFQZCffl0QDoIi4FuhNU5cmABk1LQycVCT+EnWOheNLaTUQnf6ymXlmqoGaTyZOBvZtJlY0MwWE7CH14EhJ/8mY2t6Ng0V7WxL/tIm7w7N0noRrLkB2GwRA6298EcB/gRXHEH7zJBCByGo/HmoEKL9WyFxGz2uBIIPDbE3/h2sz4e+XX6/JKxm9BMNFJL/jnVog+Rt2juIU05LIx4YiyiFH49t/3fyTytWamR5VEuiBifp1AZRJId/MvP0B2UjH/3RgxhCLYByxKDDGiDOoi460LPn4oXLDxkw3bq25w0g0r5OczxVHccJizYPeujM74bl0K5Ar0SnxsYIUbFQMwZ7YpXqQ6rV6VmagVU5m7Wb0wm6G4Y1qPVLY4ggJlwNWVCAffgJ9mOu2pzaHY2G8Gf4IgW6iLnTNI/S01+kBwBDRlBlbyIVc6ofm2Nw+tjIAs2+uI34DIR/5eStmYECgTGRMWZdnQdYhd5w1tUpOl8cd74jyFDZAlIX0O7TmbxIdq8BTd74RHXiW1I0u9XFrBbxuShahMo7Yet6o5kTsqCOuYstYqU4VIYHLxrBlCdSKfUD3CxQYoj7nB4ig2+LdxXBUM4NJJ+hTlfQj4ulVnwhHMGzCmTTM2Gz+f/16ANFsuMN6kMCa4cER0+RUSejYnLDm5tQibFxiT2PLHsRaXV/ooluyC1LK/qG1zdkIsriA1CrrbrpiqwgchuFbUTRD+9EzZaaSz8fUh+ZNvjKjVjMWidjvjyN7QI6w5O30KuIZO9zvhG5lnDnqEXLxuwYy5ooSjy2kLbUnlmgXVNzJ6DWJOU7nA4cNCqcso7oTuHEDrpxEyudIzdzRhogguG+KgG7DF7uVxmUPqP6c69
 21N/EAeK
 1d8sk2hTJHWO4hDyKJAHMDqMAvjjVd0ylkkBXaI6xP3yprPt+I3hduegrNfzwaZBPA8UTF74Tr9R84a/NAJUSm82eYnUkT6B+O/fTUQn8YbroRaxBLtYraAG5VfMy6eOhZEs9Gk8nYVC2JPvzRw9VfAYUCzGfIUxpNCJwYRGWogJAuRiubdbjHMv8oaU46haQpGMcmxSzqBSvjKCSY5rWsCIO/8UxKmmDsod8Ngn+5pIS9+V8WETsR9JPowzB1LnTqHPCilduDFgxP0GYwobM+MqxkMp7MWYm3a92V8/GYJ4ncz8SFp8aZSjOVBvv5wSaSBf94fXF5NdSmDqIiZ1nYxub7FA21PZpWpjdD+KOXrr356dTjmRhYUdHk2JdDEJ0DMZvEjrUuZ3fHHpvFkHVviFtmiv/dF1VFRCGDrlmC+VyHHSJeiNnbhJjv28bWmybnvf8fQ5lpaFlF7HihywlJ60+D2RQA67k2JED
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yuntao,

kernel test robot noticed the following build errors:

[auto build test ERROR on robh/for-next]
[also build test ERROR on linus/master v6.18-rc5 next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yuntao-Wang/of-fdt-Consolidate-duplicate-code-into-helper-functions/20251114-004121
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20251113155104.226617-7-yuntao.wang%40linux.dev
patch subject: [PATCH v2 6/7] of/reserved_mem: Simplify the logic of __reserved_mem_reserve_reg()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251114/202511140307.Th0UqUd9-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140307.Th0UqUd9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140307.Th0UqUd9-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/of/of_reserved_mem.c:175:31: error: incompatible pointer types passing 'phys_addr_t *' (aka 'unsigned int *') to parameter of type 'u64 *' (aka 'unsigned long long *') [-Wincompatible-pointer-types]
     175 |                 of_fdt_read_addr_size(prop, &base, &size);
         |                                             ^~~~~
   include/linux/of_fdt.h:62:60: note: passing argument to parameter 'addr' here
      62 | extern void of_fdt_read_addr_size(const __be32 *prop, u64 *addr, u64 *size);
         |                                                            ^
   drivers/of/of_reserved_mem.c:175:38: error: incompatible pointer types passing 'phys_addr_t *' (aka 'unsigned int *') to parameter of type 'u64 *' (aka 'unsigned long long *') [-Wincompatible-pointer-types]
     175 |                 of_fdt_read_addr_size(prop, &base, &size);
         |                                                    ^~~~~
   include/linux/of_fdt.h:62:71: note: passing argument to parameter 'size' here
      62 | extern void of_fdt_read_addr_size(const __be32 *prop, u64 *addr, u64 *size);
         |                                                                       ^
   2 errors generated.


vim +175 drivers/of/of_reserved_mem.c

   150	
   151	/*
   152	 * __reserved_mem_reserve_reg() - reserve all memory described in 'reg' property
   153	 */
   154	static int __init __reserved_mem_reserve_reg(unsigned long node,
   155						     const char *uname)
   156	{
   157		phys_addr_t base, size;
   158		int len;
   159		const __be32 *prop;
   160		bool nomap;
   161	
   162		prop = of_fdt_get_addr_size_prop(node, "reg", &len);
   163		if (!len)
   164			return -ENOENT;
   165	
   166		if (len < 0) {
   167			pr_err("Reserved memory: invalid reg property in '%s', skipping node.\n",
   168			       uname);
   169			return -EINVAL;
   170		}
   171	
   172		nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
   173	
   174		while (len-- > 0) {
 > 175			of_fdt_read_addr_size(prop, &base, &size);
   176	
   177			if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
   178				/* Architecture specific contiguous memory fixup. */
   179				if (of_flat_dt_is_compatible(node, "shared-dma-pool") &&
   180				    of_get_flat_dt_prop(node, "reusable", NULL))
   181					dma_contiguous_early_fixup(base, size);
   182				pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
   183					uname, &base, (unsigned long)(size / SZ_1M));
   184			} else {
   185				pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
   186				       uname, &base, (unsigned long)(size / SZ_1M));
   187			}
   188		}
   189		return 0;
   190	}
   191	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

