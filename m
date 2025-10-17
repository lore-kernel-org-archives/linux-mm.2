Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C91CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 03:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100C28E002F; Thu, 16 Oct 2025 23:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AA08E0002; Thu, 16 Oct 2025 23:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F096C8E002F; Thu, 16 Oct 2025 23:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEADC8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:10:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59FFC571A7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:10:12 +0000 (UTC)
X-FDA: 84006127464.22.8F0A53A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id B2BC81C0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:10:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l2K4EoTI;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760670610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2xL4jQ8GyYQDkBHp74gpV6GZnEkg/JS7T7OgbOrryE=;
	b=Kowj/jdIw8Hm3VmDGTcQyRExj+BvOqyaY6wqsaHigThWPnlUP4D5DzfU/HsnN8c0VEVSkp
	3QpA2Fb+Sr9YYYSuPWfHfYKe3B5huZBUdK0+9kgRVfSFqjbLzes5IjCpLcK/dsRCmT7/Jw
	MdNYhjpjunyrDpT5DeTPOZUlzPVFFto=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l2K4EoTI;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760670610; a=rsa-sha256;
	cv=none;
	b=QG5Fnuu7zlqeJlKpmrYdDormkHCKlmsSnbfEg3IP0oMmQpwWUTV5Bh4FfdMvAPFDqdV/5a
	5X097XPCa6GTOH5iN/NTl9TFCGTWMX6BuxIoKfF7P3g9S+PAMvbsif479Uvib6bvdMagBj
	utxfZJVWe+HptW13KBZKOLLoBL4tmGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760670609; x=1792206609;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/+LxSluv7aDw/AI/2fm6dlIfW0gbQe7klAqez1nbV6E=;
  b=l2K4EoTIwKhdGgCJBu5UGI2sP35rjQXqKzXRS0fhmOEEL3pTZb4Ovmvc
   klKI93ifPsrQ6DWCulncSDC5kuPkgWEW3uu83k7q0nJmw7dYyxdHOrfvy
   3aysIl+HbaNStacF9p/b3N1jLFXqL6zrWdRhCLVIdIfvHXm+rjIOLdq2C
   pZuyVWYsDeC9VtaF8gu95ETZ7zCMvF77BBkRhg3kvOASjjx/Uy06Pagkm
   cr4qvHVEqlFhgYtspRTzgFBWmdRck4H61CB9opcdHdP2uvcGEh6+ka9Cm
   OdN27+Rokpy3CyY/wvCee6rPqTrqSyNTeyOnhzKKjzX7GiJ1HvyPArid6
   Q==;
X-CSE-ConnectionGUID: FJBT+OInSo+YcoC3rKZfnw==
X-CSE-MsgGUID: 02bIWSfZTqCuKkkAxquaIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62922604"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62922604"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 20:10:08 -0700
X-CSE-ConnectionGUID: Xgxzd1jNR9eqCP7aaJr8zg==
X-CSE-MsgGUID: znK5Y+kFS/WADBCN5mannw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="213203965"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 16 Oct 2025 20:10:04 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9aqv-0005Tv-2m;
	Fri, 17 Oct 2025 03:10:01 +0000
Date: Fri, 17 Oct 2025 11:09:27 +0800
From: kernel test robot <lkp@intel.com>
To: Longlong Xia <xialonglong2025@163.com>, linmiaohe@huawei.com,
	david@redhat.com, lance.yang@linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	markus.elfring@web.de, nao.horiguchi@gmail.com,
	akpm@linux-foundation.org, wangkefeng.wang@huawei.com,
	qiuxu.zhuo@intel.com, xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page
 by migrating to healthy duplicate
Message-ID: <202510171017.wBXHozQb-lkp@intel.com>
References: <20251016101813.484565-2-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016101813.484565-2-xialonglong2025@163.com>
X-Stat-Signature: ecoo5qnmcb3gu3ki4ixq9x8kp95oimex
X-Rspamd-Queue-Id: B2BC81C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760670609-633042
X-HE-Meta: U2FsdGVkX19gKtCNoBAiM5iLvnLoEhEAr6zR72/42Q5sDkQ3mlcQFGORfrNiTPzII1iTcjyifjJ4ZV3XxZIiRp8qZsZzF/dT++OR+kn5hIqSpIXUVxTeyF7+VWPVrtW5nJOZFkdKV1pxcBku8xSEGEjzkv6EovJ40LmE+xnlfTBpEWHZQHxzX4Jbt1k+aoUvDxOuDUpFXwzf42dqLQOtxugKy2q/TMVNWrtsvHJ0o1KeHXieP4YwkSw4IW6nWkwVOVcsrYO3YS+Ao7C8XgJRPXIWqVUGmjVPfCi03/LS24il4scu8hDw14nfrYea3E6GAVHOE4ilU1LCzoGoQpLati08FaomM4llBYqIfc6SPXxYFhWo4gNILn1x/dUtXGJtMvC2C/ZynDhWEPMNPa8cEYxJD3mmULDtAL4M418fVKYLJz/XLoNSZwzVo9gzkC4hBg17p0nTRdGLz3k6xdj0Ty4UzhkQVDhxiCii/W53lAzjHpGg8LoMtUOKHuCg1kuLKAYhXVKsRApzPdLcuu7J8UUE7aGmiv2T9lI3l5O31g5U1vQG8ru9a9HrmR/8zfoFJxNKqiiX2N4poDkN8+Q6n/en6rN2F/F9r6YdDbT2D1ksDtygmmVzNwymjPCkBsi75HjwzsRADwu8+nWeXfo2fPGSszOqeeRvQ/5uc/1AwSjfYrsumW/zrKa+LJQwG2LB0dXqi5s8TXmDcYd8GkGs7rrJtXvD6q4krT+7egIsfUvBmOYCqnJgwN4AeqVwfaLtyE97/j94n11XezT83fQzWr2kyQUDWxguUt06EYPJwPe+uBPgcjAYjiy19mfVjTZKHL+SQYugunYC6O1U1aBMlAVFxOlG5XiXj1GS+7CgHJ9bouJcTTlijMC1jgT5HJjWkgBhSzLX9r5GU79A3ljCF8/IUZ57PdpzWDHZELpkdSyDHf/mRKBWqTAcKP3egyKQ6TbWwewBfeeyxzl1kzg
 S9Q3bPPm
 Wn8GXnZ066kqDntDcE69yhVBCXJhnDwx2BmXu7FXSpsQszRcvr9qNuepQPa900ALeV5qm72coEmc5tL5kIYESsQZLWnB/opGnmxcqtPVPYzoG6vNUqVfUyuLlwFZUMuiyTW38wV+dYatmiwSCBT8Feb1w1XnHP2FpcT4VU+zBfyp44YiLxr6O84xJBu5aS4U0bgsKR++J6OW6US72jd3TLqdYRK/hzo2B6djWFaLKy1GC5A9WrHEcg0LZxoNehRmtQxVss/QxPcJQYhh0rK4OxPIrv4/Ij5LFoWHAzv++/X+/Rr8aZ0cKxCaXp0gGfka4lQYAnDBZARElAlZ7EWpHqoYpWiHAxRm8omVh2Euuvs38VQtuZGIMEm3BpIvvMzHeUA+JubpoMDj5WYSemRC/bK7Ul+n6wyxb1lTZ6axxYW4mRCt9df5NAh6PWRFwtmVqRLQCF7IQzn6qa9evn/CPFIMv+l6h9wAr0RdL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Longlong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.18-rc1 next-20251016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Longlong-Xia/mm-ksm-recover-from-memory-failure-on-KSM-page-by-migrating-to-healthy-duplicate/20251016-182115
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251016101813.484565-2-xialonglong2025%40163.com
patch subject: [PATCH v2 1/1] mm/ksm: recover from memory failure on KSM page by migrating to healthy duplicate
config: x86_64-buildonly-randconfig-003-20251017 (https://download.01.org/0day-ci/archive/20251017/202510171017.wBXHozQb-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251017/202510171017.wBXHozQb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510171017.wBXHozQb-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/ksm.c:3160:6: warning: variable 'nid' set but not used [-Wunused-but-set-variable]
    3160 |         int nid;
         |             ^
   1 warning generated.


vim +/nid +3160 mm/ksm.c

  3155	
  3156	static struct page *create_new_stable_node_dup(struct ksm_stable_node *chain_head,
  3157			struct folio *healthy_folio,
  3158			struct ksm_stable_node **new_stable_node)
  3159	{
> 3160		int nid;
  3161		unsigned long kpfn;
  3162		struct page *new_page = NULL;
  3163	
  3164		if (!is_stable_node_chain(chain_head))
  3165			return NULL;
  3166	
  3167		new_page = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_ZERO);
  3168		if (!new_page)
  3169			return NULL;
  3170	
  3171		copy_highpage(new_page, folio_page(healthy_folio, 0));
  3172	
  3173		*new_stable_node = alloc_stable_node();
  3174		if (!*new_stable_node) {
  3175			__free_page(new_page);
  3176			return NULL;
  3177		}
  3178	
  3179		INIT_HLIST_HEAD(&(*new_stable_node)->hlist);
  3180		kpfn = page_to_pfn(new_page);
  3181		(*new_stable_node)->kpfn = kpfn;
  3182		nid = get_kpfn_nid(kpfn);
  3183		DO_NUMA((*new_stable_node)->nid = nid);
  3184		(*new_stable_node)->rmap_hlist_len = 0;
  3185	
  3186		(*new_stable_node)->head = STABLE_NODE_DUP_HEAD;
  3187		hlist_add_head(&(*new_stable_node)->hlist_dup, &chain_head->hlist);
  3188		ksm_stable_node_dups++;
  3189		folio_set_stable_node(page_folio(new_page), *new_stable_node);
  3190		folio_add_lru(page_folio(new_page));
  3191	
  3192		return new_page;
  3193	}
  3194	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

