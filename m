Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2308DD4A607
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5136B0088; Fri, 16 Jan 2026 02:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692F56B0089; Fri, 16 Jan 2026 02:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F056B008A; Fri, 16 Jan 2026 02:45:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46C346B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:45:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA4825944A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:45:53 +0000 (UTC)
X-FDA: 84337042986.15.C8A66B9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 126AC40003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:45:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g0Wpmt47;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768549552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBvtGQtsc5yZmecgCknE10ho4JD/cXwUogpmH0GuUSw=;
	b=XlSSMHNEbf67/xfDD+FM0fL3ARbNTtidPptg6Yr8moJODE94PIw188jmja1OOT2pxBTQyC
	BHUxj6Xzh6OaMOWwBKwNChHmRH8VDOrOUxF2Z1ozbyisxEYlDCJIDGVPNW4VK/whTfMURs
	upXuCI2Lu4+0un1+Vq/2hE5P+cur5Mc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g0Wpmt47;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768549552; a=rsa-sha256;
	cv=none;
	b=M8ZeSAmRB2hQnEzv9z8KYlLzYqIKsqwkNfB67ED6k6N4CXakvru0JBVpvWi1dDh7qPcdVd
	tPp/G3U4W3u4VnMGVvAf9H8u/Jd7CVGyzDkIi2n9efHb56Hzt06JU7kcFe+TWCyg8MVyGN
	EY8PxGyZEedBcoxlPsWmgL8REjV8KvE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768549551; x=1800085551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G0V6S9md6+nld2O30zY+hMSqsUc4Po2MsCahVSA79HY=;
  b=g0Wpmt47C/AmqjETD36tUw7BsrWMaK7CpFkow+7vIm+YTLXxnaPoZ9UV
   jnc69PJFRVlFj2d5PrlOkoN6jsMsNpahbfFJj5Oo7akUUsXr3mj5rjpiP
   f3vI2vKvyDVEmsisxMqPTN9ezMWDyh0F9l9cKm1Tp+IsgoOtL3Ocet6sT
   amX6vN4JKbTSykyWTIe/eRNjzjHe8vNW9a44w3NyOWXT+VphNNu96qzY2
   tkTf41J6flFA8AsWDUXM4NybxsFsJWlyAjtk5K4LOixn877ohhpqcbqBK
   CcWSogtXWMQ8Vj7IlTYrD5bdhGe5DtjxrYm2goUcK+wbQPF8H3Ok5DiPA
   A==;
X-CSE-ConnectionGUID: OAAalqSlQfKPMuOGY3YFjQ==
X-CSE-MsgGUID: Ps2DSIQZTi2GKIRh010Pyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69065583"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69065583"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 23:45:49 -0800
X-CSE-ConnectionGUID: ONnquVpZT+qEY5I8SvDUjg==
X-CSE-MsgGUID: tDcssknwRjy3qULDu7oUIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="242723017"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 15 Jan 2026 23:45:46 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgeWd-00000000KXw-0hBC;
	Fri, 16 Jan 2026 07:45:43 +0000
Date: Fri, 16 Jan 2026 15:45:19 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH 10/28] maple_tree: Introduce maple_copy node and use it
 in mas_spanning_rebalance()
Message-ID: <202601161501.NZ3GNDCG-lkp@intel.com>
References: <20260115193647.1695937-11-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115193647.1695937-11-Liam.Howlett@oracle.com>
X-Stat-Signature: s6txio4iota3kzp5e8474kqsh3bpyho1
X-Rspamd-Queue-Id: 126AC40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768549550-783819
X-HE-Meta: U2FsdGVkX18nS3V7UI27Rh58b3EUG4F2vBmKGC1w8uDP6e6OKZDLFtiLFA+rGFj/JBkVMCxIisEh2P2hkbFpnZN0sUk827gqow9rafPqKHNTtrIHcmb2k6W55/SEiOdjV+YDknpgdHSKHg8u30AhCPRLkyu5qiZGNbbdS7K64TMAYC/t/Ly6FNhdHgLDzESBw5SFXz4dNm0CbNgKfi3oxfzEdltBeTilqnTJaEsdJM7zm9ciGBe/95kmaPEKFO71ZOrDVQN0yi/ETddF9bo4sLVdrLAVlgWC82vXU5jPoMs+rbwnZJP7XSD6fx/W4yNjQCHkRAVWmzj+OlmMxxHvSfziQ7nRItnAWcPVHBxAhGLJvlsIMGFwRzcOKLWqr/r5iIWV9YiTni6KXPOJyrKF+dnT7YmG+dRdLbrhCI7hDV25eeMvH9YRW3x6Gz4SGQ3ATAah0DolqL0/+gTRGNrm2dhfKuAGxUGyEkpty5R5cmDIc7b6QBDYQ1SFSdo2oi6XzttjOS7fU9tKXZvKXzFtC9TG3VBm9VQ4H+bKBdQdG4qAavzvrRADuAtNhN5GKOT+V0iT0pluW13prKfPnv6rdGx+cjs5dns/jbIaHvvFQ/fVdLatzGdA7lq5FUFYBMrwUMMkAInCkb1W/8Uth1uOtjPpKNkOlV533PlH/SDxfpoGiAHvwGscnt5NKVY0bq1/lVcwctWQ3KfukS1aCaUNKchHgxNHnK7uIFa64Sj9xnAVDFTPD7cDB1SwpZ3sUbSodveNmyWGxyhjsdwvVvXkIgqPal/kB6osfdoSQaurehXUcIlsYE145hH5p1M5x0ZGz/zrAPXmSK975m/YBH5//CI7ql62E9Amw16QyzXm+jP5aAuEwwQS07rSNhop5sBFCvumcxjUIXEgCBLX5WKvZ986E+FTCR6C5ucvvSHuI5a0rUxAdEba12yJbCCdTRGN+W8YBTKrIcX4+jueTSn
 4p5ZMLHa
 daBKTjPQULMa/JEjMD+Xkv9+4/Pl/fzt9zC4ENlOYyY7sHPRvy+wMPZ7d4L+6V5g/rBlmF8V92OWAg6JN6/bYQCQuGn/ELyGkzMX5U1en5+K0A1HKiJgaR9oRyS+HCsoJEDScTm2v9KzwfmdodzGvZUuKFdigHPYedVnBIqiBgqmaayU3qgzELPWlsO/Rob4eIzV1q1HTeZpHufZryeXsGhEjLKlxRvZgGyFPv/f9g3MMO6yEstqbgG9s3xnXxwjUnVwZHhtJZrgW61frKkwFZf2/GNCXAGzHXgeV3PW3NbleLrf3VuDcvcTgDcMTp9s3CDUQg2e9ddB7Gi5CkOPk9S3qn9alFyRrXCxXuDd09+jQdEKQZbgsx/Nf3HCMswCP1PTSuqPbv67ntanb/dSg5h+gLC2HVn1Jgm8ZtBas8nIutcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on next-20260115]
[cannot apply to akpm-mm/mm-nonmm-unstable soc/for-next linus/master v6.19-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/maple_tree-Move-mas_spanning_rebalance-loop-to-function/20260116-034135
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260115193647.1695937-11-Liam.Howlett%40oracle.com
patch subject: [PATCH 10/28] maple_tree: Introduce maple_copy node and use it in mas_spanning_rebalance()
config: x86_64-randconfig-121-20260116 (https://download.01.org/0day-ci/archive/20260116/202601161501.NZ3GNDCG-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161501.NZ3GNDCG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601161501.NZ3GNDCG-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/maple_tree.c:2621:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got void *content @@
   lib/maple_tree.c:2621:29: sparse:     expected void [noderef] __rcu *
   lib/maple_tree.c:2621:29: sparse:     got void *content
>> lib/maple_tree.c:2624:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got void *entry @@
   lib/maple_tree.c:2624:23: sparse:     expected void [noderef] __rcu *
   lib/maple_tree.c:2624:23: sparse:     got void *entry
   lib/maple_tree.c:2680:17: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu **b_slots @@     got void [noderef] __rcu * @@
   lib/maple_tree.c:2680:17: sparse:     expected void [noderef] __rcu **b_slots
   lib/maple_tree.c:2680:17: sparse:     got void [noderef] __rcu *
   lib/maple_tree.c:6412:30: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_node * @@
   lib/maple_tree.c:6412:30: sparse:     expected void [noderef] __rcu *
   lib/maple_tree.c:6412:30: sparse:     got struct maple_node *
   lib/maple_tree.c:6412:30: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __rcu * @@     got struct maple_node * @@
   lib/maple_tree.c:6412:30: sparse:     expected void [noderef] __rcu *
   lib/maple_tree.c:6412:30: sparse:     got struct maple_node *

vim +2621 lib/maple_tree.c

  2603	
  2604	/*
  2605	 * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
  2606	 * spanning store
  2607	 * @cp: The maple copy node
  2608	 * @mas: The maple state
  2609	 * @l_wr_mas: The left write state of the spanning store
  2610	 * @r_wr_mas: The right write state of the spanning store
  2611	 */
  2612	static inline void cp_leaf_init(struct maple_copy *cp,
  2613			struct ma_state *mas, struct ma_wr_state *l_wr_mas,
  2614			struct ma_wr_state *r_wr_mas)
  2615	{
  2616		unsigned char end = 0;
  2617	
  2618		/* Create entries to insert including split entries to left and right */
  2619		if (l_wr_mas->r_min < mas->index) {
  2620			end++;
> 2621			cp->slot[0] = l_wr_mas->content;
  2622			cp->pivot[0] = mas->index - 1;
  2623		}
> 2624		cp->slot[end] = l_wr_mas->entry;
  2625		cp->pivot[end] = mas->last;
  2626	
  2627		if (r_wr_mas->end_piv > mas->last) {
  2628			end++;
  2629			cp->slot[end] = r_wr_mas->slots[r_wr_mas->offset_end];
  2630			cp->pivot[end] = r_wr_mas->end_piv;
  2631		}
  2632	
  2633		cp->min = l_wr_mas->r_min;
  2634		cp->max = cp->pivot[end];
  2635		cp->end = end;
  2636	}
  2637	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

