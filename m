Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6DEFD4417D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 11:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44596B0006; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12616B000A; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2DD6B0007; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACB96B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5023E140526
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:19:58 +0000 (UTC)
X-FDA: 84210574476.09.6A92F06
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id 19B2A16001A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:19:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jlej8Nln;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765538396; a=rsa-sha256;
	cv=none;
	b=dv5BWt+cOzaA28517Oj1c1/+VVn4RjPJnupJ80g16tXEBYTvWvOV9HlsFtMjIdayvwJI1W
	06Yycz/OFyfwnWwvr17+EZi9bVH+EO5qof5bgcHdB4yM7x9Zy6VSXI4IcnT93qf4YudtHv
	tcuabYTUFvElaKf12saPs6ckpj/QRvc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jlej8Nln;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765538396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4gw70ETM+CuR8ZDOUjSzhXQ+/t7Wp70tvmNXNVWNKQ=;
	b=PGKKZNgO+t+/OG0ZbTEwClZfwFAlIl9yYWhjss5WWZCL98nSuynSHnRORdk59B088SvOI4
	veJ1YmdPGYj0U3M8udiqHegovovX33Lg/yBsjFF/yi/H8N2dCgHl/aT6HC1elT5kIj3gW4
	/PK68w8+0xtJCEAW0/YHzFSKikS6Qfk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765538396; x=1797074396;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EdVCtB2iBvhcT8kAVicT/eJPLJyC3Q8G7MCNhAvQuvs=;
  b=Jlej8Nlnhu/BSkHtY0I7m7zGeDKelSGkcUX0hyAHz3G2oT1KEMIFu4y7
   S+7HNAcLaD4XeM+DGfSWP3dw+qX8IylKSwxwExg2yVXcO24PbMEXny3FG
   sxWEBrbiRjLFeSM42Eb4OAjU7CQiRaZGYZypKLXt3SlPMQ4q+ACqe2w6A
   JWmWE6+pFmgoVmTQSc6fMZpQ6Ad0StHozoV5BhCLgZhCvFpQ+SLTFAh+H
   It1X150HG7sQKJB9deJlAV1c9gBBaL0b3ndSTWb0m1CZ3N6XWOKPblLFp
   YTy5ghR0vBqJ7gbNDFyqIFb7PpMTlUDTiU32CQAINRtJhvW6+48mm6NMx
   g==;
X-CSE-ConnectionGUID: 7SUw4kovRVeQng/nsYvQyQ==
X-CSE-MsgGUID: Z4/g9iOuRoG9Mn8CfVbfDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="78908858"
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="78908858"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 03:19:54 -0800
X-CSE-ConnectionGUID: qJI1cXddTlCXNr/oOR58Sg==
X-CSE-MsgGUID: nS3unyGGQ8uyAJys3jLiqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="196666572"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 12 Dec 2025 03:19:49 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vU1Bb-000000005yZ-1Ard;
	Fri, 12 Dec 2025 11:19:47 +0000
Date: Fri, 12 Dec 2025 19:19:09 +0800
From: kernel test robot <lkp@intel.com>
To: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	robh@kernel.org, m.szyprowski@samsung.com, ye.li@oss.nxp.com
Cc: oe-kbuild-all@lists.linux.dev, oreoluwa.babatunde@oss.qualcomm.com,
	kernel@oss.qualcomm.com, saravanak@google.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	robin.murphy@arm.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
Message-ID: <202512121807.G5FMUgvU-lkp@intel.com>
References: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19B2A16001A
X-Stat-Signature: ztpxxhudshni8a3obp5inqtcdgh3db54
X-Rspam-User: 
X-HE-Tag: 1765538395-223141
X-HE-Meta: U2FsdGVkX19f6FOr95Hfhgb0U+k6ofTdUh21C+0SBhe7eI5DIGxpODYuvuY8UFYtLU5q5VQ2CjOneA9wF/oBfeYk8BsDtKsOAXC5Mop88htif0YQAMrCFRC9Tv9kNzI97Bw+skfoFfSQ5llbdIrbC6Q/6bYPzcEe7nD4LTJYUk6qV49ZIbJ25wD48JGKw5aK2IDLcKMmEBtGwJMWPBkjHG1rG03QOLeU2NuBFdaLYolLWsY2jw4732VhnSOoZ+2MagAvZbp4yc7h7g8dmTOHSVAFJ9cd7XPWOau8wfSAGagdORwbRMAHUdUEBz/an/wTLGJ00xdPYNNa3FRSo9NMRy9bqGZdTNzd7j8qxAPNNd8DSk/JK4wun5H30jNdLqU8R123U5RFVPLj942KDmYkZUu+zadAOe0mQ5CtaMcLm7AWjUrO628GNiSGJpmiU0l8wpMGsCQ9OsxxzmyYtHjpWfwkLjgpEUyHFF5WugUCCYiKow36fxBSTVP73okURsj1J3tRzOM/HC1bWTqZyno8HdHck+pqfunWkASm+3OmQN3BrTqfda+sxmE8S4WSc5qr1MuSftL/4GaYIs340BtOhph0p32ikrLk2/Du3rh41Am4sBQP48d9hqkQTbPH2nbM+UMeqWOFgdTWi0+0SpJN42baahXyoqwzLIJH9C03cKO4wr0R40IDy/b4RPun8iXiG4IbX6swZrn0nRNUJXvzfsmMRDP6S1Y+mdlE1eozphnKVr8MFnBix7C3oZLGoEedkD5u9fc82g/dL3KyioB7gfn6kK2OxQkpOm3xtDMJJTaVeNvd6J6e4b0pDpdF+06c38Rv7RXcs4bAWo4KjYKZ860B7tkgrXhW9nN/t8F2x8PLKCtTZ5KvCmlMVoHA//PJWu9bl2JVOlgfFqeaE9YYCA9efrRFP006U7udq/lnHA+Ew33VYyY24cZy8qG2FUJjKX65jEukAJXyRHSS6TG
 uE+wIULZ
 jUt794trfGysfYBaJZQRerfxa4Ezs6sQa8yAJJfpFyrOhGA/J7XYUVJSOMMa/hwlgmT7kHcusgqvhg+/x0tDqdBtsauVibK/cS7mBgbuFUsNfp87PRK/+qFfgNKMwCHZ9y3RMVlFx6bSP/maRi3L2E+a6JgWj4XDciVNyLqH2qSJVdo0AhSqXORbdcJITT/7EfZ0HllIo2m07tQrLiq8MS4TCdnw7qockkSp4G1ovmEMf7w8BDIAbAFo8l9qBApJyuYtnjpz5IZrHVDXqmNQcE9nAIr+OTdQ9PMTNRKtQB4T7TvdFsNUSLVvfRGT1uiXj0KuFVIsNw1iT4WkgwNLECH344d9hpUayTPofeS/r1fh3yBM3t38ku0stJBIlHQVXCuZAAcgDwQa7bXm3WR7bRJZjFvis3z2/iqQNc+Q9pT7zoUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oreoluwa,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on v6.18]
[cannot apply to robh/for-next linus/master next-20251212]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Oreoluwa-Babatunde/of-reserved_mem-Allow-reserved_mem-framework-detect-cma-kernel-param/20251210-082127
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251210002027.1171519-1-oreoluwa.babatunde%40oss.qualcomm.com
patch subject: [PATCH] of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param
config: nios2-randconfig-r073-20251212 (https://download.01.org/0day-ci/archive/20251212/202512121807.G5FMUgvU-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512121807.G5FMUgvU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512121807.G5FMUgvU-lkp@intel.com/

All errors (new ones prefixed by >>):

   nios2-linux-ld: drivers/of/of_reserved_mem.o: in function `__reserved_mem_reserve_reg':
>> drivers/of/of_reserved_mem.c:176: undefined reference to `cma_skip_dt_default_reserved_mem'
>> drivers/of/of_reserved_mem.c:176:(.init.text+0x5b8): relocation truncated to fit: R_NIOS2_CALL26 against `cma_skip_dt_default_reserved_mem'
   nios2-linux-ld: drivers/of/of_reserved_mem.o: in function `__reserved_mem_alloc_size':
   drivers/of/of_reserved_mem.c:444: undefined reference to `cma_skip_dt_default_reserved_mem'
   drivers/of/of_reserved_mem.c:444:(.init.text+0x8a4): relocation truncated to fit: R_NIOS2_CALL26 against `cma_skip_dt_default_reserved_mem'
   nios2-linux-ld: drivers/of/of_reserved_mem.o: in function `fdt_scan_reserved_mem_reg_nodes':
   drivers/of/of_reserved_mem.c:272: undefined reference to `cma_skip_dt_default_reserved_mem'
   drivers/of/of_reserved_mem.c:272:(.init.text+0xbb0): relocation truncated to fit: R_NIOS2_CALL26 against `cma_skip_dt_default_reserved_mem'


vim +176 drivers/of/of_reserved_mem.c

   150	
   151	/*
   152	 * __reserved_mem_reserve_reg() - reserve all memory described in 'reg' property
   153	 */
   154	static int __init __reserved_mem_reserve_reg(unsigned long node,
   155						     const char *uname)
   156	{
   157		int t_len = (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32);
   158		phys_addr_t base, size;
   159		int len;
   160		const __be32 *prop;
   161		bool nomap, default_cma;
   162	
   163		prop = of_get_flat_dt_prop(node, "reg", &len);
   164		if (!prop)
   165			return -ENOENT;
   166	
   167		if (len && len % t_len != 0) {
   168			pr_err("Reserved memory: invalid reg property in '%s', skipping node.\n",
   169			       uname);
   170			return -EINVAL;
   171		}
   172	
   173		nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
   174		default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
   175	
 > 176		if (default_cma && cma_skip_dt_default_reserved_mem()) {
   177			pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
   178			return -EINVAL;
   179		}
   180	
   181		while (len >= t_len) {
   182			base = dt_mem_next_cell(dt_root_addr_cells, &prop);
   183			size = dt_mem_next_cell(dt_root_size_cells, &prop);
   184	
   185			if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
   186				/* Architecture specific contiguous memory fixup. */
   187				if (of_flat_dt_is_compatible(node, "shared-dma-pool") &&
   188				    of_get_flat_dt_prop(node, "reusable", NULL))
   189					dma_contiguous_early_fixup(base, size);
   190				pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
   191					uname, &base, (unsigned long)(size / SZ_1M));
   192			} else {
   193				pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
   194				       uname, &base, (unsigned long)(size / SZ_1M));
   195			}
   196	
   197			len -= t_len;
   198		}
   199		return 0;
   200	}
   201	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

