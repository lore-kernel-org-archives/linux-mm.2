Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E420ACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBCF6B01F7; Tue, 26 Aug 2025 22:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092CF6B01F8; Tue, 26 Aug 2025 22:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA416B01FB; Tue, 26 Aug 2025 22:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D97836B01F7
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:58:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 798941397B7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:58:46 +0000 (UTC)
X-FDA: 83821029852.23.3F648C7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD507A0009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:58:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JhSGgQGK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756263524; a=rsa-sha256;
	cv=none;
	b=Ho9xHjKAdohT9hMEgumnUOWoVStCFJKBSM+bYvyqmAFaRlJnm4CUuQU9c7va25hxGF8mmc
	hgT7o3ZCq+Yaw1gSKJRC+0rZ/+y1FOia1Pk/APpDw79iiJJYXj94u62MDlmf8u7ppblXdA
	hbeisCRhvdRxuhO4jTEfbTShKUxF2Bw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JhSGgQGK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756263524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u97TUi06cZXHhbujWvc2VCRR4uTQ/fwVirKOmrv2k64=;
	b=ThACsUzUvXiPIQ3M+gkvptpI5AMA631j7zvc/scQ2pU2MTxBgh9m+r6oz/AOFVEB5E86zB
	tYJM6iN3uBb+WXL3ikr4KbOBBHyVsVlQ/jrfaAc/UGWUj/pVX9An8SxpVAXJU5rh1Id8UR
	3IxGoi+uhgszcOhdcbxxH/5GNWI0rHo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756263524; x=1787799524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FaAYjYeaqo6BXH3QV/GlJJdaIRRLN9q/K9TzS6NDhLo=;
  b=JhSGgQGK614kUqdtKg4xp3jjojVvhSAzgeqmIIlgRhTlYinv3590vQw9
   0GPsvw99oBJIFwpZxgLC3NYW/Mcnl2YWqOB6d1sP8pFKza8zvoXN468vc
   tPZdZiCaRzjGycdjPsrUMTe4Y4jbHLD6D7387oBPHr8qwIkzswc8K+6Ex
   adtXWyxuRi3Z1UAJDxD3nWzfCO6y9c8zguYQchTrnyKg3ifnUlsTBIjaq
   XebJphSiKpSJBom6FBEvd5n78me4mATkik+6cvPr4M+DRCGhryiaAtyhq
   OoVze5IcM4SK9iMh6eyiyvpccZQKNvbLgnJM86eD1qtmBK9AAc0SSfA78
   Q==;
X-CSE-ConnectionGUID: YfPwKLcVS06UFJ68bUgiDA==
X-CSE-MsgGUID: tYNyRVB9RM+4egy8gGC5xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58569369"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58569369"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 19:58:42 -0700
X-CSE-ConnectionGUID: WQLEuyUDQBiSRfhdVtzXyA==
X-CSE-MsgGUID: uWywIkghRhiOifWM3Oe+9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="193380595"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 26 Aug 2025 19:58:36 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ur6Mr-000Sbz-3B;
	Wed, 27 Aug 2025 02:58:33 +0000
Date: Wed, 27 Aug 2025 10:57:10 +0800
From: kernel test robot <lkp@intel.com>
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	hannes@cmpxchg.org, usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com, willy@infradead.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net
Cc: oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP
 order selection
Message-ID: <202508271009.5neOZ0OG-lkp@intel.com>
References: <20250826071948.2618-2-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826071948.2618-2-laoar.shao@gmail.com>
X-Rspamd-Queue-Id: CD507A0009
X-Stat-Signature: 3zziihhri77b4ykousrwy8sfzwejr1rz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756263523-125803
X-HE-Meta: U2FsdGVkX1/Oyeyb2s/gqiFFEjY5ccOHcrrf/7K3McfMU/scn8Fmx39y5pEW9nCLZZlEeG3lmk2k+Z6RMGjWyalqi4CEdBALji0SCgklpqL06f6RauoDOwhVhcwEtPQsGWfLk7XYKM1zM+OHsYKJ7VMW2YZf+daiuaSfBdNljnIv9eZIog+OPXEW0q7j3XyVgLTPdAO5ir30SK5VbN2v7nwcJEYRkJwmhdFEnttMI+hGnbj7BSZgXxEXT8v5VLCNTd719FjTL061YeBxXwKlJlCgTTXtCEfxynZzb2hgx5kPun8z7/tFd/oC5b+LrnojSE+PaFOADgbaJURT73sIZGINNywQr/UC4tNrqrHv11bTRnHVFXTT2ivAjKchqaxsKopy2PLZhPBAGW3CRbUgfG5GehUTCH5C95ubeXFTm4Q4MkllAbqddUyfNWDv7zqOu1jSOrAT/g05/juvh4yhuwI/mjZtl6GyLhhI3MZ16S4xMHvkPsTtEM+yu9nM5sWoNwrsCmUPaJ+qK/oqWiHY2pG2Wycj6qJ9tgZuwwKP2WRd8FAIzcqZT9uOEKXUZvx2tSyJsY4naPk73YLdXmPE1JUM0MPuCSgz534HYmpc/Qd86L5hJSuGFSZkm2zw46apsy6Wh2tFqruzyd+9CYz7atI6PjoWF0WnFNG0/StzonsWWCuhMuGBLDzf+Ce4weZtXZJOW2p+k6ZY7vbixw96ZIc2UmESSNz92XA8SjMLz/g/UMFjyyAXHF+VyllkbG6W4JxUwl7drCGAyRjD8XM8nj+lwbpS1KelS4/xy+pPtA/lcWKfDxEEqb69YCcO7s/7kBtILtwNM4ZvsBf3WU76giERgs6nEclrw6OD0I4145AqKKyFgxsyM207XpfDmQPG7AZbaeEoqhYA6bexvkDXhcSTP4PeAHQDdATxhK/7EudJYapW1YuYTC0kh5jXKVYvCdi1OUePkT/oS2MEEgJ
 P22PLhp2
 cxhCUzObPR2pnBnmqSa+qUKD+m5iYGN8nNYpG89GF5D9ja6GT+TXqVEqS4NfqsNRVBVUNfJ5Mn3PHW0atZovxQ+jLTPSUSs/zTSWa/3ZZ+9JPEM15wu/kLI0o/2SggjMQXhUdG1+EHC4M13VkBii87fspPUnjwKeKfKuWCCwbyCD460U/GeqwF+hNgOElMqZ7wCoF9Xn500Hg7czrTnxHMJ5xaRYhH9MxD7q91Wn7uyrepNhnEnowa+RUB9AW6dN1ny6YLkancEfstAL4TQtB6S2MXRCb+9cZgHen3MKXo5NxgBirHfx5/drTkeSICwzzNn0b/4XWAxOaj7a0hJk7jnVygTHPlfW/kn2sRds5C3bzRGwUTutlTu3pd2SYdl4TcEOFoXc3/FCoIaHqScC0mZSnBkNUbeBAcPH8EFsIE5WbV4Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yafang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-thp-add-support-for-BPF-based-THP-order-selection/20250826-152415
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250826071948.2618-2-laoar.shao%40gmail.com
patch subject: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP order selection
config: loongarch-randconfig-r113-20250827 (https://download.01.org/0day-ci/archive/20250827/202508271009.5neOZ0OG-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce: (https://download.01.org/0day-ci/archive/20250827/202508271009.5neOZ0OG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508271009.5neOZ0OG-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/bpf_thp.c:47:31: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:47:31: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:47:31: sparse:    int ( * )( ... )
   mm/bpf_thp.c:101:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:101:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:101:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:102:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:102:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:102:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:111:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:111:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:111:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:112:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:112:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:112:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:112:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:112:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:112:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:133:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:133:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:133:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:134:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:134:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:134:9: sparse:    int ( * )( ... )
   mm/bpf_thp.c:134:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/bpf_thp.c:134:9: sparse:    int ( [noderef] __rcu * )( ... )
   mm/bpf_thp.c:134:9: sparse:    int ( * )( ... )
>> mm/bpf_thp.c:102:9: sparse: sparse: dereference of noderef expression
>> mm/bpf_thp.c:102:9: sparse: sparse: dereference of noderef expression
   mm/bpf_thp.c:112:9: sparse: sparse: dereference of noderef expression
   mm/bpf_thp.c:134:9: sparse: sparse: dereference of noderef expression
   mm/bpf_thp.c:134:9: sparse: sparse: dereference of noderef expression
   mm/bpf_thp.c:134:9: sparse: sparse: dereference of noderef expression
   mm/bpf_thp.c:148:14: sparse: sparse: dereference of noderef expression

vim +47 mm/bpf_thp.c

    33	
    34	int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
    35				u64 vma_flags, enum tva_type tva_flags, int orders)
    36	{
    37		int (*bpf_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
    38					   u64 vma_flags, enum tva_type tva_flags, int orders);
    39		int suggested_orders = orders;
    40	
    41		/* No BPF program is attached */
    42		if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
    43			      &transparent_hugepage_flags))
    44			return suggested_orders;
    45	
    46		rcu_read_lock();
  > 47		bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
    48		if (!bpf_suggested_order)
    49			goto out;
    50	
    51		suggested_orders = bpf_suggested_order(mm, vma__nullable, vma_flags, tva_flags, orders);
    52		if (highest_order(suggested_orders) > highest_order(orders))
    53			suggested_orders = orders;
    54	
    55	out:
    56		rcu_read_unlock();
    57		return suggested_orders;
    58	}
    59	
    60	static bool bpf_thp_ops_is_valid_access(int off, int size,
    61						enum bpf_access_type type,
    62						const struct bpf_prog *prog,
    63						struct bpf_insn_access_aux *info)
    64	{
    65		return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
    66	}
    67	
    68	static const struct bpf_func_proto *
    69	bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
    70	{
    71		return bpf_base_func_proto(func_id, prog);
    72	}
    73	
    74	static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
    75		.get_func_proto = bpf_thp_get_func_proto,
    76		.is_valid_access = bpf_thp_ops_is_valid_access,
    77	};
    78	
    79	static int bpf_thp_init(struct btf *btf)
    80	{
    81		return 0;
    82	}
    83	
    84	static int bpf_thp_init_member(const struct btf_type *t,
    85				       const struct btf_member *member,
    86				       void *kdata, const void *udata)
    87	{
    88		return 0;
    89	}
    90	
    91	static int bpf_thp_reg(void *kdata, struct bpf_link *link)
    92	{
    93		struct bpf_thp_ops *ops = kdata;
    94	
    95		spin_lock(&thp_ops_lock);
    96		if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
    97				     &transparent_hugepage_flags)) {
    98			spin_unlock(&thp_ops_lock);
    99			return -EBUSY;
   100		}
   101		WARN_ON_ONCE(rcu_access_pointer(bpf_thp.get_suggested_order));
 > 102		rcu_assign_pointer(bpf_thp.get_suggested_order, ops->get_suggested_order);
   103		spin_unlock(&thp_ops_lock);
   104		return 0;
   105	}
   106	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

