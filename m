Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5ABCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B008E000D; Thu, 13 Nov 2025 13:45:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422698E0002; Thu, 13 Nov 2025 13:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FA58E000D; Thu, 13 Nov 2025 13:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23FD28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:45:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ACD89140B77
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:45:01 +0000 (UTC)
X-FDA: 84106460802.02.0DC78B3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1EE0A180010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:44:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iI2o+pd7;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763059499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdlMQgwVjsQQokMUoarVWLzYOF89ILJG6lqyPcbeycg=;
	b=uzkLBf8F6SEgdOUpZ/N0GaSum6T6HN5ScaDLGfqN+tdU0TSIyBgxsglWBcL9X3neDRM2oE
	1NZE+/K+4Zrss2NB+i8TpHn1yIL67OnwnqamxVHaLxO3dLqcuv1QQoGXdDBJkDgR9PCZg0
	NkN5g/WO0MuCUnD1D+tGBFD6V8OMe1Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iI2o+pd7;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763059499; a=rsa-sha256;
	cv=none;
	b=soqpOtHIQYQOHDA+nBaxR7lTygHv4fd4J0x6ojMlMVYQnlGSOcZvOSluUmdwj2qvfaHsGU
	L9IMkXhC9WWImx80q7lV0HTWy16/7FsqdONWr9gjYgaRonTtUVFrrZwbK2F06jRPZYnP5S
	uhKBtOZPCN0KDZtb9b8plvMLdZtLD/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763059499; x=1794595499;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uJwfz7y+UOjyl3txMn7ctra7YU4BaP0tmmsat+CbBmU=;
  b=iI2o+pd75clBr0Wnay/oEeb0Bv853/ZKAwRxuekaHXHiXo7MRk6B9/Ky
   h0HX3QLJhzXHon2jGVM4r/ePJE+CwdCfQjo+NLdgQTFdZ+TvAsAuUTEG3
   xrzqgp0+CZ1vVD6dsmyEySk+CMd6lC/9YWgcZR6rPn9ha559QI/UizXJ9
   41zEpq2wKwxDLpeIx01x3VW0cCCrmy/vzTWHmmud7pVzLLeQPcGQ85+fr
   xjDRRQ9xe071dAo5mUD8g0X5nueFMeoQhUaexhK/MEnjBuEkWDzlc0uSU
   o3cCnZSZ6FrF5URzfl8JcQOxmTEeGsWDqoA/+lhGX1NPEmIHeX2Mm8Otn
   g==;
X-CSE-ConnectionGUID: gEDskzYNSgqoFLFvyhnDtw==
X-CSE-MsgGUID: qsCb/8lWSSuhSjx00aQmkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="82782230"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="82782230"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 10:44:57 -0800
X-CSE-ConnectionGUID: pXRj2ntZQ4eRt1WRIuqYvA==
X-CSE-MsgGUID: ckktt7N/RVqHdg43JpF33A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="189835423"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 13 Nov 2025 10:44:53 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJcJO-0005l9-2G;
	Thu, 13 Nov 2025 18:44:50 +0000
Date: Fri, 14 Nov 2025 02:43:53 +0800
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
Subject: Re: [PATCH v2 3/7] of/fdt: Fix the len check in
 early_init_dt_check_for_usable_mem_range()
Message-ID: <202511140236.zLyckeBA-lkp@intel.com>
References: <20251113155104.226617-4-yuntao.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113155104.226617-4-yuntao.wang@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1EE0A180010
X-Stat-Signature: yp4jt7qgza3s7urpit6by5mb8uzhrsxh
X-Rspam-User: 
X-HE-Tag: 1763059498-800144
X-HE-Meta: U2FsdGVkX1/OdY/mNv7iai4zk+iI4UDWnRlkPuyJ7KOkvzBPyhrIsOFq/MxtGFStTQaFUF6bUQbsBP5agckykEzVxjJCD2hxX5f5clElN6wjlaD1TxMGZ6f2f4ZbqQYzCgnKcKddQg81cdmzKfkW8vfQdvbKJwbC8lTefnmtb5KVCqPodZ+hWUNewYB6wMPGE+wckRIQIx3ee+MCjqXkRMo9P4w1LRryLPQF5sQjfHq5tjkvn++d/kNpVnB9S4cTA3aUH1L4Pah4UDAAnDyRkgsrLV1WLj42AlUUXjSyLCWTEAniBEvW59gi9I2A6eb1lH5hLrQQJEuzL4AQyMcqIk/KhNpC80v8QmDO+yw/MxSOELX8j2fQojYg0jc43/mxru3cLafWhIpRWVY+PppMD9Mn7MzJYVBhhqkj3yjnFUl7RWBEkMLEdLWq5uvKnQB8lvcBgTvmjRAIyqrMphM8Pv47402gcp+fPNmkZXs5dqmA62hyoiA3dk/l2U0WNVZ9Qp+xLx1LO5oi2uPkMX4CIkX/N1hKcrHd8aGdDq73cdcxvBJp3uU/MV3hduw5s1s5CuAb5xymZCOO+CF9Dq+GlBJBIphnU5I+n5r8qWu0MZlqiIQ2GFuHdUmk0ObGJIlI6rGMvurAZN1hjRd9N05mdtV0w3QZRXe62Xh/T9ezwpEf2lA1DCtqUFUWnthBmMPml1TbwofNaL/BkRs4qwewjI6dZyAz9yIajWZPnXP/M9yUBUVs+7pYLMFWtcgMlUXm+NzDq8vL3stYlruOUyQAYJl+87/BOARMM5bmmG9Tfhs+SstYT3pNBA/hYghmr9b00yTbCVIDfMOxPhZ2QZLlvZP39UjmMEOr4UMiw7PhKsHPMd/3O0HTGt15U/GpZxqnkMMU61/Izk28LuDY2yj06AIBnCINUaGUMxtpssn1gv7t1UJtDUSQfgTtQe6xgLn9fkgvOLLywFJ+KljCfUC
 8wiTgyFz
 96T9wxAbHuQ48oTN6F8Qogym0ldg3kAIL3/d78qxPXw5yViWqzfqtWXIqqPaCVH59QEA5pmBhZyoXGGzcvYSYtzVshv9MX0O5bJ3jSPIEKmgKStvpP66PSW+IlDknqILHITEnGBZzKJYIfG8vygRThclpSpE/ea0MUjgn6sgTfRFhaddguWyOYSD+ZQ9msBkurmypNR3510DGTMqtCHnZhhEW1VHg1g/5uCBebqk4TMKg3/sXPWkO+sxtiiVmQNRUSm0zE6v07KlChWr278MNa8kRUBB2g/Lcgq3FZo+Ai7yWJOpbgHGXTUJMdeXpOCyouvI3gDZTphjAoXw5z9+CARNRuwNX7H08QQ2QUqNmwdaxRck2bGW0rKi8DuDgU/a4jtSbzsNIJAeUwor07lmQFshvtHLrzGKDzh/JZc/OvyV7jVXP6PsMCdRJsx+fmaGWN7buDhh+EtMd6tQPqQ6cpOpBCi9Jda5OZOvG
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
patch link:    https://lore.kernel.org/r/20251113155104.226617-4-yuntao.wang%40linux.dev
patch subject: [PATCH v2 3/7] of/fdt: Fix the len check in early_init_dt_check_for_usable_mem_range()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251114/202511140236.zLyckeBA-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140236.zLyckeBA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140236.zLyckeBA-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/of/fdt.c:903:31: error: incompatible pointer types passing 'phys_addr_t *' (aka 'unsigned int *') to parameter of type 'u64 *' (aka 'unsigned long long *') [-Wincompatible-pointer-types]
     903 |                 of_fdt_read_addr_size(prop, &rgn[i].base, &rgn[i].size);
         |                                             ^~~~~~~~~~~~
   drivers/of/fdt.c:663:60: note: passing argument to parameter 'addr' here
     663 | void __init of_fdt_read_addr_size(const __be32 *prop, u64 *addr, u64 *size)
         |                                                            ^
   drivers/of/fdt.c:903:45: error: incompatible pointer types passing 'phys_addr_t *' (aka 'unsigned int *') to parameter of type 'u64 *' (aka 'unsigned long long *') [-Wincompatible-pointer-types]
     903 |                 of_fdt_read_addr_size(prop, &rgn[i].base, &rgn[i].size);
         |                                                           ^~~~~~~~~~~~
   drivers/of/fdt.c:663:71: note: passing argument to parameter 'size' here
     663 | void __init of_fdt_read_addr_size(const __be32 *prop, u64 *addr, u64 *size)
         |                                                                       ^
   2 errors generated.


vim +903 drivers/of/fdt.c

   879	
   880	/**
   881	 * early_init_dt_check_for_usable_mem_range - Decode usable memory range
   882	 * location from flat tree
   883	 */
   884	void __init early_init_dt_check_for_usable_mem_range(void)
   885	{
   886		struct memblock_region rgn[MAX_USABLE_RANGES] = {0};
   887		const __be32 *prop;
   888		int len, i;
   889		unsigned long node = chosen_node_offset;
   890	
   891		if ((long)node < 0)
   892			return;
   893	
   894		pr_debug("Looking for usable-memory-range property... ");
   895	
   896		prop = of_fdt_get_addr_size_prop(node, "linux,usable-memory-range", &len);
   897		if (!prop)
   898			return;
   899	
   900		len = min(len, MAX_USABLE_RANGES);
   901	
   902		for (i = 0; i < len; i++) {
 > 903			of_fdt_read_addr_size(prop, &rgn[i].base, &rgn[i].size);
   904	
   905			pr_debug("cap_mem_regions[%d]: base=%pa, size=%pa\n",
   906				 i, &rgn[i].base, &rgn[i].size);
   907		}
   908	
   909		memblock_cap_memory_range(rgn[0].base, rgn[0].size);
   910		for (i = 1; i < MAX_USABLE_RANGES && rgn[i].size; i++)
   911			memblock_add(rgn[i].base, rgn[i].size);
   912	}
   913	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

