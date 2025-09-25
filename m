Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05500CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40968E0007; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9A28E000F; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17FD8E0007; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B62F18E0008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:37:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 632D284712
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:37:21 +0000 (UTC)
X-FDA: 83927874282.25.234EE37
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf21.hostedemail.com (Postfix) with ESMTP id B1AF31C0014
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:37:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZmfNSaGR;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758807439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lisu6T/1EdLJ6jH1m/3ioLM+TiWwEq11PnkT01FtkJo=;
	b=we4gWcUJ4hoooIrDJmaZHUpTdwszLGIPKbunWEDnZ7fHPFsmmHsCwtRNUPC9hp4cMHqwVi
	8h8rWN0tzBASzzscxxhViri7/r0+MMrz8u1UFEAWc+ewmyh+NT5QFdxXZSwUbn6mN8HJZ4
	pAO1nqqfVPGuFnUIrYcpIFVP8y9ZWZc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZmfNSaGR;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758807439; a=rsa-sha256;
	cv=none;
	b=xPtb/kj1M+GxI4u03/CA2Qn2kfdJDqxE7k1DxN66Gm0tDn8y4evzSZq5CZmNU3iyvU1dES
	xofUbub/4cRpl2NB2G6w1qVzLAHd+GZaDugMBWfRJhxkFaW1EZno5UzbwGuNytL7z8NJU1
	8I4blm6h9hxWphvsDzEXgJ5eklV1vBA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758807439; x=1790343439;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LTr4oshAkMcVoBpx4J040ZcczOQeM7IvBewq8YixS1g=;
  b=ZmfNSaGRI70tRhmKsFRFmwbjbWWXBIMbyH/F1xCiBWWpbmcsJJY0KBeW
   Td1HcUePGqBBWbg6tm4Do+5QgMJQwrNasR2vkGfBof1ulqGe4XKtSxnTe
   6gLVE68hL2NglkNncOgalo9bW+Wr7dMRZtKw1OTiXzC8kRTNL/5hv7RhE
   uaxvMtT6bVCPoaR9gfXqTAazZifpgh5adI7D0OtwbUQAgu/YeycNVhKrj
   d9qvh7646jmp0YgQQZYDDh/aozxxRzSPvdeXU4kkFDfp/si6bntNWcI2j
   B+7FFJwIJiN4eoi823vnjVkcJlMDShAf1o94p2WrBKNTsMsXPzGnHc9V/
   Q==;
X-CSE-ConnectionGUID: kseVnEZGTMOtI1JD0Bht1w==
X-CSE-MsgGUID: zmWkgzqiRBaDri+0FaBXWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="63755051"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="63755051"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 06:37:17 -0700
X-CSE-ConnectionGUID: CAKflSAnTA2IHm58h9lsPQ==
X-CSE-MsgGUID: mNkaVc6/T1Cn7dX6zZBZFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="176467467"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 25 Sep 2025 06:37:11 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1m9k-0005GH-01;
	Thu, 25 Sep 2025 13:37:08 +0000
Date: Thu, 25 Sep 2025 21:36:46 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, bp@alien8.de,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
Message-ID: <202509252153.JhjsdZ6c-lkp@intel.com>
References: <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1AF31C0014
X-Stat-Signature: cj15g34niibpo6tom4kqnorwc9k37pyh
X-HE-Tag: 1758807438-767568
X-HE-Meta: U2FsdGVkX19kYAGOy+pmbWkr7i3MKXEaB+bE8OGdwyqnuyuQlE/kJ7qLIYYNyxfvl6JFtDtd8YWImrIVvK9U4F/5KxqZlTX+0hlqZd950u5jlP+53rkDnhhvUSZNRlCTOjPyJCgdZQKesAfgqfGneo41v3Voa2p7LV9jrdCi70nh1snG54sCxHJ5OQBMRkCkcrzd0SKMk07yWNwM/cqOvj3cG6a0HDGNeYb8wADcn2Nj+sRfwFqzk40EPQX7OL5HocNupEnmV6/IW4lyg8uSxOWpofzEE1ZljSzpIj8EVJeHGLiu/oKOak5KX3cuLp7ivoVWYZZtv50vwNK9oz46wSOUGCfNjY6kw4jfAihDry0fbPb0XQAmo0z8hGEZGCLu4KWifo2YQ5yWKxPVjoZJZwfmLnVLryJtm3zlwx155JzhWLbyAPozeGS6zeIVZu4Wishq9fg4BkgMH3DUiZB/4rlROP81Itb3cPA6EYa4CtZ65dNaSZYB195yXum9rGtysSXRJfUeIv1s+CvcSyYyYt2N8Ys1OPyMdgqRQtgDQ/3LhpeFHsWYRoR0zmIGerQ4Xrbc9NfyvMeOq3kbffTqGA7Ia0ljQlUN8pF1Pey/ZRHLpE5xie04APMajoRyCzmiZYqKRPW5l+QGIiQ19xhbEdpETYXPSXmqinIiO1IHd4gEQQ3PYD5H51dhwLpbzT4zV0M9SInGLnb3CEq1BOuNpifVDgCLGEc0eNaxdVz8xUM86SbtY7ukLMHAbvibYl4N3nRgylO2aJR2o0oZh0mci/ssqgyIND4xSqcONm2f8aVNx5TpI/EQJ7nJIPjfNQ+OW9+xqrZX1z6TT46QbcqqGjrYynSoBp+zXFzUxL8jhJxiJnH0IYrA+z7eqL9uY13mIzUgUAI2E+jnJEYcSVkCafh/UqhTU1WaVJtJOjvWS39oZtVHo00juWfySSceEYlfE2waWt0G//NZM0ud+Ib
 w5iat9XU
 KfRcndjXllz8gqB2x1A9dog3JR2C6zeWa2Ig3H6NrZ8giPvvrECjA1FsD3p0kJEdHrzfcMQ7Qw8c+gjFaj7y23xueGfjh0KJqDW6wkcOnHQFnI9Ce8wDO9THkjb5DpdinNl8+j+SI3wpmB9g8KHzy5mIm6W4xU2Ru9P/csCrHTQ4Y4R0bmmnlhjthSNGUxbR4BNjEs2/BUZIpTFrQAKdxMLMzC3HcUUvMkzVruciMS5/qIjQ6S+m7TVnDzuFeXatBjJU+fnIYeEQ1aem+O9eGMiaF0eIH44ye+ph1iVjMVcGoqoXkYVBm/FtJ8Vevwpmn2039PCDeIVEXOPIwbjC6RQ+VWJlPGxjZQbql
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bf2602a3cb2381fb1a04bf1c39a290518d2538d1]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/x86-mm-asi-Add-CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION/20250924-230633
base:   bf2602a3cb2381fb1a04bf1c39a290518d2538d1
patch link:    https://lore.kernel.org/r/20250924-b4-asi-page-alloc-v1-5-2d861768041f%40google.com
patch subject: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
config: x86_64-buildonly-randconfig-002-20250925 (https://download.01.org/0day-ci/archive/20250925/202509252153.JhjsdZ6c-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250925/202509252153.JhjsdZ6c-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509252153.JhjsdZ6c-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/mm/pat/set_memory.c: In function 'mirror_asi_direct_map':
>> arch/x86/mm/pat/set_memory.c:1995:25: warning: variable 'asi_cpa' set but not used [-Wunused-but-set-variable]
    1995 |         struct cpa_data asi_cpa = *cpa;
         |                         ^~~~~~~


vim +/asi_cpa +1995 arch/x86/mm/pat/set_memory.c

  1988	
  1989	/*
  1990	 * Having updated the unrestricted PGD, reflect this change in the ASI
  1991	 * restricted address space too.
  1992	 */
  1993	static inline int mirror_asi_direct_map(struct cpa_data *cpa, int primary)
  1994	{
> 1995		struct cpa_data asi_cpa = *cpa;
  1996	
  1997		if (!asi_enabled_static())
  1998			return 0;
  1999	
  2000		/* Only need to do this for the real unrestricted direct map. */
  2001		if ((cpa->pgd && cpa->pgd != init_mm.pgd) || !is_direct_map(*cpa->vaddr))
  2002			return 0;
  2003		VM_WARN_ON_ONCE(!is_direct_map(*cpa->vaddr + (cpa->numpages * PAGE_SIZE)));
  2004	
  2005		asi_cpa.pgd = asi_nonsensitive_pgd;
  2006		asi_cpa.curpage = 0;
  2007		return __change_page_attr(cpa, primary);
  2008	}
  2009	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

