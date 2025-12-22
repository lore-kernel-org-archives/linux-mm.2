Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81546D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 01:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58826B008A; Sun, 21 Dec 2025 20:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30946B008C; Sun, 21 Dec 2025 20:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CCB6B0092; Sun, 21 Dec 2025 20:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5FA06B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:47:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5629B5BC1F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:47:05 +0000 (UTC)
X-FDA: 84245418810.20.D5F4A91
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf21.hostedemail.com (Postfix) with ESMTP id 470811C000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:47:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lYRbuysm;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766368023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSMZmesBLFgpq+A0LYpVko4h+lt0AEEuH7RX7GEQVlo=;
	b=db72WDUjdZVjHJyChfkdUf7oLUizVXnwUvvvvOxNCRFWDU4C7UqUUtBb/HC3tyvT4mooV5
	8vnSGba2G6RSOh+oeOtaSZU1WA7Rq6YbY8K0VHh5m10YA8khwzNLtFTbdbjVYn1DLBdfgh
	/gVIBkteFkmRzISa03gLySQj5LjR4zA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lYRbuysm;
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766368023; a=rsa-sha256;
	cv=none;
	b=W6vvDpSVzVSIZSUb6VAISeeMLrtEr+hM+Y1k4J8zPT0heo8Pno9q2iKi9xzHRkMvhiye7/
	ZRMiOBjqWLsfIlrgRYO79k/ZTwkwKsg+FeAC+z28EgSHLRbrOT/PzoYWutb8gY4r7AXh+h
	QRo0f34g8ANNQ1JCqGwR8S//BdpEzcI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rSMZmesBLFgpq+A0LYpVko4h+lt0AEEuH7RX7GEQVlo=;
	b=lYRbuysmu5FfGITGv6TYTLp3eumslNXWu5jf/XWdplckklCgTmhi4Ys0azd9VS900rj2hSeix
	vxLPDzJJo0lXa4MbcXWl26NzKCdGbjZFQXzmlDjSTnDVJ8Q8Q+/CGkZQGQlaUPE5ESZWJgdGZ0X
	Y8ULjA2ipNdsiZc7Y9MgRjo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dZLX74R6xz1K98D;
	Mon, 22 Dec 2025 09:43:51 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C2A040539;
	Mon, 22 Dec 2025 09:46:55 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 09:46:54 +0800
Message-ID: <2f528a53-5acb-4e2b-9346-231f882ecb6a@huawei.com>
Date: Mon, 22 Dec 2025 09:46:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
To: kernel test robot <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Oscar
 Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>
CC: <oe-kbuild-all@lists.linux.dev>, Linux Memory Management List
	<linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi
 Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>
References: <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
 <202512202141.mGkUgIRF-lkp@intel.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <202512202141.mGkUgIRF-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam02
X-Stat-Signature: 5zrbwidxhqreqxjm5kfxmnyb1anru1mq
X-Rspam-User: 
X-Rspamd-Queue-Id: 470811C000C
X-HE-Tag: 1766368021-196849
X-HE-Meta: U2FsdGVkX19pMrdrmCoyQXDeVEsFVewtHIfXTeytIdPQu0dLxVvCHi7aJaUxJ8NUauwnSWytP4wOq22qq2jLKncMKCehpdQZ7Np6bT+EG26jO+me/UwOb2EkjKASKEZ2lJPZhZFBsXEu1FXtudPwufvlwfoMRg7PH/faw9CZFof13ht1fey7BaVKJseMjqvprxn0qNvaQ4UYJ/8RutrnqcIe7vq1Bfk2DCAHIlnJiuTKH+/VI18ftABgmgAJFzWPhw29CwFXnSUBSZTvW+B3U9Me8gUzg3+aG9PcWpPXzkSltWQwi2gRw/2Jt+LHpjIv0d3A9WGnzcxCTU3HKIYOHl5UkrK1hIch2ANMdCDB4YGrSyt8NWQTBkxLANkP7Zkk5iUAESlGBcc8L2k7nIhfHPtFFgu4imG68q11uABge4/5evN8a+gtUA/by+mqqOd8ky0PY0eZrpL7eoA3SLUo29ueCbKcEZshcDmqMapIaMOj4nVivnWCO3a/RRRqu0Sk4ZYQrLKk8HvDAqnujri/gMOomjUjvo/5KvE00l2LuqeEZue/RlrWkULzSheHdu+hs5Jytp/uttX44uyacfwhRjydtvHWeTARg3Phb9RiB+iHFrkn41HzthlZdv0Or6nnO4DspWO/mC5vHdXcCV7OWbTsuNJ4D8ZzFa+e2pvglo6TJZeq5y33i2DP2qCS9EQZQfLsgjaqt54vUZ2tAqzM0r01PrdxGJuIff5g+S9x6Er3SOKIHy4u4hgF3+4lcJwZLHW6hW/JEy+CF7qzzl+IBWLU37hBXPcw4wrTdXF1skDLY2M1WAHrIWpWQTgBZw3R2jbUJr/HwdxcckeRtWwANOYCvjCPflEYO4l8HnQDfCGAToTJiaEYTE9QuAFOsBHXdUP9jAankjbl6U8dZEeKf0HU9U7rg5zIa571MzHRYDpTl0LCswOYG3LAtuYlRXHQrWadFTfCvEzqBdCRYes
 LYoQKgRT
 +Thf/udXGElww0tIZSWfHWKp7WkZIOMVEV3z8Nml1qB3uqd6QJWyEqgiAJ+EPbuHolQXQ9cjaf5Kk4Dl/g4lvR/sjn4kKMh6lzlS8VcbxalylF2weFQUUU+a9O1Rl4B+maufuBzym1GH1th8U5f10A79bA8/WeGsLZIbQpcCEEsIyVbe5fyGX3BfFeQ6ShyCh04TKyg6EAJtgsdA3bYCuDh0QBz638ONe5amnnSZ81o2zS0za5C22COUqPjQClBhHndDizIpnm4qKDbfE77r2kG2sBARhZsSbaMSQ+ZiH2jvHYgjKG2HmT9r9FBVPOyYHyXw72l/4nxMjktlHVOX4Em4jHVZe0h+C1Jdbcx3Kniua3RuHPMMid46J6+j31pgk+sfyK1BrNqJw38Xu26TMA8MK8ODKVolLqA0/O83WoqLxirZV680AG7J6qPuzyEHWeHoedfXxy9xpqIswR2Xej/M1OET0BWD0IdPj8czRKC89X5QN3+QdOJKQ5JpmMmC9thsbHfuInjKslqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/20 22:34, kernel test robot wrote:
> Hi Kefeng,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Kefeng-Wang/mm-debug_vm_pgtable-add-debug_vm_pgtable_free_huge_page/20251216-195027
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251216114844.2126250-6-wangkefeng.wang%40huawei.com
> patch subject: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
> config: s390-randconfig-r053-20251218 (https://download.01.org/0day-ci/archive/20251220/202512202141.mGkUgIRF-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202141.mGkUgIRF-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512202141.mGkUgIRF-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>     mm/hugetlb_cma.c: In function 'hugetlb_cma_alloc_folio':
>>> mm/hugetlb_cma.c:44:11: warning: array subscript [0, 0] is outside array bounds of 'struct cma *[1]' [-Warray-bounds]
>         page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Kconfig warnings: (for reference only)
>     WARNING: unmet direct dependencies detected for CAN_DEV
>     Depends on [n]: NETDEVICES [=n] && CAN [=m]
>     Selected by [m]:
>     - CAN [=m] && NET [=y]
> 
> 
> vim +44 mm/hugetlb_cma.c
> 
>      28	
>      29	struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
>      30					      int nid, nodemask_t *nodemask)
>      31	{
>      32		int node;
>      33		struct folio *folio;
>      34		struct page *page = NULL;
>      35	
>      36		if (hugetlb_cma[nid])
>      37			page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
>      38	
>      39		if (!page && !(gfp_mask & __GFP_THISNODE)) {
>      40			for_each_node_mask(node, *nodemask) {
>      41				if (node == nid || !hugetlb_cma[node])
>      42					continue;
>      43	
>    > 44				page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);

Oh, it should be hugetlb_cma[node] in the fallback path, thanks for the 
reporting.


