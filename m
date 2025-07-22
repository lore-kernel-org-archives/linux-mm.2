Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEAF0C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351336B00A4; Tue, 22 Jul 2025 10:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3028E6B00A7; Tue, 22 Jul 2025 10:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F6F6B00A9; Tue, 22 Jul 2025 10:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18B1F6B00A4
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:14:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4FFBB9629
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:14:21 +0000 (UTC)
X-FDA: 83692095522.09.9F4403C
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf03.hostedemail.com (Postfix) with ESMTP id 85C4420019
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:14:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193660; a=rsa-sha256;
	cv=none;
	b=z7b1/nlUT9JRCAJGDh4hYuzICb+A3XsQlF5whciyxX0g2NBYwUHZfIhWS6rE13gKwitllL
	DCV46ns5gbhTeDOmsE/K4+GfptWvyklzws54EOi36QoSILb1gpc9hrsTx/2Zbln3ndRrHo
	/8IvJNpY3CRf2smsVD8qs+afwk3vQQs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=69wFwka6emBR8tBkwHGN1pUqh6+e3BWq6cA/h0Y11+Y=;
	b=3ELYrgUvL+P0cho9YjxXAVXcsv65GCzS8UjW0eQBaiyDik1H94vBeX/T4Pvp1vsR3S7+KM
	/WRM7JwDblrSGNwHwlu9fFPEpIwa2Fmk2r8JcBMSIDjs1ZhHJYx7xh5DhqybQyFng2Tl/9
	Xp0pM2RhTe10+nva8yq7k7fx9sHnbR0=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 22 Jul 2025 23:14:16 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 22 Jul 2025 23:14:09 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org,
	oe-kbuild-all@lists.linux.dev, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aH+csQxNcCmQMgZa@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-2-youngjun.park@lge.com>
 <202507212243.Lf8fSo0T-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507212243.Lf8fSo0T-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 85C4420019
X-Stat-Signature: hgn1tfzrrhdsq1ebj3wxsbptgzardtid
X-HE-Tag: 1753193659-502336
X-HE-Meta: U2FsdGVkX19C2muJe/dZnBnKfELv/Gsv6ZOivBW5pm8hcr6r8LkaJBaab47SKLDgQAPpY+VXX12ad44QQEWHWRAUyKnFp0P/6+RAsvSp8NYb1sAeN9s1FrKsyi6yYw+p0b2E76fxa3x1sYpIAtX0Zy5GTdILQeZkclneyWvK7EIywrL2i++gWJIXhuBNwNdh4+k9y+Hcp3XXnnp94bMVdWdlRbK/nTfdXQIXHldvfsxSIvMQvD1i1CrV0q4JZlwt5Go2XwcK3dPbYb+Rcu9Lyx/tZutwyt4DzNNcF+3iEvBcowcdbbe4N6sQC6+3BTkzWr3IE1f8FjrdiwiqGQKooDbgScyLoYusXlGq87fkQBIgbCPiC0XsGo5WB1Yhm7oQWrIi6rn5KoWvvxe0qLnGQzAto8ARu6wqfKJN+FOIE7W4W6pgnRjaLKyn+Isu+QibzKjEf8VzXgr8jYPrHvNtt+rHLGbLO1jgob+9VJnIlWp3I7CtF8SpESEP9FFru3WrPq8SSdXv3juFI/FltQ02MmnR3vMB/vok7FgyibCRoYl1l+bkPoTtddQWLMYssgSFfTwZxEKBr0AhvJnRUerR/zwKboyw4YykAH8hsqVW++NwCegSg9Ezomw9hwAFck4KxOpeEZYeL8YnSAnyY/Xm7nzjAzuOJZWD0y/VQtI0fnBWR02C2Y5ieh4p6USRx7bVdJ9+X1OzXOCV9dxzfiiKb2PkKDB8OtL3peYx+QjDP+qSIuSibbnmrvVsDJxJBC1yyL2fGjHaphO85UhrkzhSSYNgRX29eryMChu/wjBUPAVzaQzmDpU+JxSDTj/zcCNm34q3N1ZYtbOgRd6QXt1dOucq1/9aHkoT9/mSMBATKAbY3G28NK0FXYd9oQWRqrv83k4CkWPw6Y9UmhKjnbRvtp4LcTlAaG1IiLZ4Iq1l2MsjQvastI9/2/iW7FCHy4e81Vt0aXycgIeXDnD/LN6
 +Pig3nsF
 53i7ZHjRwo73EG2t/BT7ExR5SVMY4Oc8z75Ghnb2rUfqu4M1xhMw4Hex3SokP8M1Cr7z1bRamaJKRb2IJAAc/zhlPO3G+aC9wLcQcQsVbmfRu/SfGktt5xdNlofrm6aTzhOuff8D6ACZdQHCs0MwFewsVOwZX7Fc0YtGuxKe4q2KGa6AbSugtLCzhqWF3POjH2WQvHnIfzrZwWW0Q1dlMw6EVc2VujVWLLUoVUzklQYu4ZZK1apKmO4V8tLAw+9ZAzKopdP1xawLtfxsnYvec/dP5F3HMEzHd50mKZswImm1bSYYmvRZvDoFm6EBJZbPy6gmIEi0QQdKW5W0aFtOoJqvmOwRw5nS5waBGxOmQV9uOF1WDs5UDxn1mOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 11:13:24PM +0800, kernel test robot wrote:
> Hi Youngjun,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on 347e9f5043c89695b01e66b3ed111755afcf1911]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-memcg-Introduce-infrastructure-for-cgroup-based-swap-priority/20250717-042648
> base:   347e9f5043c89695b01e66b3ed111755afcf1911
> patch link:    https://lore.kernel.org/r/20250716202006.3640584-2-youngjun.park%40lge.com
> patch subject: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for cgroup-based swap priority
> config: loongarch-randconfig-r123-20250721 (https://download.01.org/0day-ci/archive/20250721/202507212243.Lf8fSo0T-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce: (https://download.01.org/0day-ci/archive/20250721/202507212243.Lf8fSo0T-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507212243.Lf8fSo0T-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> mm/swap_cgroup_priority.c:115:16: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    mm/swap_cgroup_priority.c:115:16: sparse:    struct swap_cgroup_priority [noderef] __rcu *
>    mm/swap_cgroup_priority.c:115:16: sparse:    struct swap_cgroup_priority *
>    mm/swap_cgroup_priority.c:729:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    mm/swap_cgroup_priority.c:729:9: sparse:    struct swap_cgroup_priority [noderef] __rcu *
>    mm/swap_cgroup_priority.c:729:9: sparse:    struct swap_cgroup_priority *
>    mm/swap_cgroup_priority.c:638:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
>    mm/swap_cgroup_priority.c:638:25: sparse:    struct swap_cgroup_priority [noderef] __rcu *
>    mm/swap_cgroup_priority.c:638:25: sparse:    struct swap_cgroup_priority *
> 
> vim +115 mm/swap_cgroup_priority.c
> 
>    108	
>    109	static struct swap_cgroup_priority *get_swap_cgroup_priority(
>    110		struct mem_cgroup *memcg)
>    111	{
>    112		if (!memcg)
>    113			return NULL;
>    114	
>  > 115		return rcu_dereference(memcg->swap_priority);
>    116	}
>    117	
> 

This part of the code, which retrieves the object, 
is expected to be properly updated in a subsequent patch series. 
Therefore, I believe it's reasonable to leave it as-is for now.

Best Regard,
Youngjun Park

