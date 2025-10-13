Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B36CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72DE8E003D; Mon, 13 Oct 2025 08:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AA18E000F; Mon, 13 Oct 2025 08:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C872F8E003D; Mon, 13 Oct 2025 08:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8F8D8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:49:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E8C61DFEDF
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:49:14 +0000 (UTC)
X-FDA: 83993071428.05.EBFCB3A
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C4B710000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:49:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cbxvzdiS;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760359752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPpxy6AvW2cQPybZQNUIFruqP5j+LHTJaagWB0GFvTc=;
	b=1TizaUa4AQRr/E+fKic75FLb8lOtKQtUmsfqwNj4sH5wQrWMllLxGAq5+nilRkYRh9VCFF
	o52T8C6fudeO0cepA+VbFrpqjH5Ur01QRTg9BXtSD5yVpYz6fURSbkUhQ6tgA+o6GQdQaP
	43qZTgWIbi986C68qZTGQ9ZA8j/rSEY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cbxvzdiS;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760359752; a=rsa-sha256;
	cv=none;
	b=ix/xOGREeN9NWX2avhIptxHaZb7if9HYpwCPHEE/tzkc3YbJ2+wEqfY7E0o5mETfnTI4KO
	0tBHLhkRYyzXC4x9uUb7vft/SziiYGv6ysDidDV+qnMnRrbbZrG+V75gDb4NYgHQehBVRh
	X3p0xMgovLYKYwkKkQrRJn9xIq0wUEU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NPpxy6AvW2cQPybZQNUIFruqP5j+LHTJaagWB0GFvTc=;
	b=cbxvzdiSgDBBMJHt2rjFnoPvB9dq3BLBlVZCQeYHxJSMISjXQtz0bNyN0jZ3X2zSFNjrQySoN
	ixJgsZxi0noaF268+Do0VqUJKomNRq5bZdGihYlzXUKvBfO6hNVurYN8OoFHqCDarPCmI7fbF+O
	B0vREHECmdXAEXaJTUzq5gw=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4clcbh1Nrtz1prKv;
	Mon, 13 Oct 2025 20:48:48 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A88611800EB;
	Mon, 13 Oct 2025 20:49:07 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 20:49:06 +0800
Message-ID: <2740dc95-d6a4-4eaf-9ac0-651cad13e13a@huawei.com>
Date: Mon, 13 Oct 2025 20:49:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime
 helper
To: Usama Arif <usamaarif642@gmail.com>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <shakeel.butt@linux.dev>, <linux-mm@kvack.org>, <hannes@cmpxchg.org>,
	<riel@surriel.com>, <kas@kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-team@meta.com>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20251009172433.4158118-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C4B710000A
X-Stat-Signature: 5dtk5tfi6esdxqjdozajg3wqbqwhgrrh
X-Rspam-User: 
X-HE-Tag: 1760359751-173237
X-HE-Meta: U2FsdGVkX19ZghSw+MrdOMBjfQnbL6yPQ0klqqUMHr1SPbn2eDzAriirds404cLzhVWja9USXhS5mqRv++7zEOfJDdLdFXN0K6/lfF6+HDg0jtp6fzJf06e4BjeBuP3pHyO9CbfkliS7pVt+ucb4vySLDAMPPFjSn7J7X+/giOin31qJ2/JihLDSDq+/G/rsE1MTYKthhSv4NfiRiaL+3tGPD8EFc1MCYvZliURxgh48vjA/xIn1TiOGXB7QVufGGkuc2tErioOO1/aG3T4PhU5WvguvcMIUVTVx4n+jNEYou9hh6BeZztNgFdBJ2TFdhw7UrrnQY7Ndn3Kpvm4NitDeX337MKxdiHL1Wftmj07CTRTnieuWW0/sbwk5QvN9CKVdwZln5SYSmzCXaVSPJxKzzUBVLAa95292CNwzhQOQ7rW8OAe+2sx7aFS/qe7CLUxLC8pirMJoJxoaBsipByGfMDW5rPFQ/xCNJqMWb1nYwuPdqzPRT9gul0pb4FpijoaDybbeA/A0HL3+t348YxvxW7qXrqTeImVOEvhEfNsTxqIsWnUiMEa6Buz9y1MapaqRb4KzPGIP06W4IctBk/WRq07HCv4ySAkTLdGRH1GdaGFf5W1p3SpooChDYUezUqoPr0ycEttXTGLtO4cW1dvyLB6IX0vJwygX05XOj04rmdN57yGVU72dsvJ+lLJZLPeEu7dDLEFqD9Zz5PjG+CEiThW79iWrD7+WaRrVPJBAdIhVE/H7OPRobaj6esRIQqALFpi7KdC4f70ZP+Iu0DrKesFXc0eqaLQ/APa9iZldrzttDimvKy8e0UBfVYeAE+Ig5B9PQBepMQf81HgO98XEsNjuQfKQatrY18xBMO5J+InE9sLlfHp7v77dabCythEGS1eyLCYI+7c8VtdeP2nTcHpl7KTnlhiU94kaCTbWxxL4mwNgEFgCnl1ipV4IrqZkFQS8o4wRNDjYz0V
 gx9obxpo
 SoY9lpS/DWQmvEA9gaFLILENa2D+i6w5iD2TYDi0nXnkZI+IphNsBrKbeOXc0D+f8xVfftpHjpshzvu76ntB/fvzlDeO1ZwedrPJ90AaHn4aAfy8JkBjz3HbIU3nUaGCef5AukSpULq8yzslAuY1+ytKJ6DLYop/yYisOuwewB23+qTyzgBc7UfWStH/flqFP2adJRj51r0i+hKohZoxUVsreSE70ZJgkg+BDoiGSR3QtgDGtQvW/QBuaj9QQi+oVvg2ajuw4+Oq8nPh0Nsb/LPVPfZVP41N9rffe6n9xeZISde3/ZfFwArV3kbnBexzGBwHqAlHAPwRmTQ55MbzDcp0/22WP5j50s8//a+p+iQHgymbPBXBdeGXYdxHBdvjQ4BCgVemKSbC/EPphIUOGmfWV4+bZ0vVRQV1LCt7/j2HMEyMZzeFca3e2cr472NnhZ3qihWuOVx6joVV3bnFnfhg3xA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/10 1:24, Usama Arif wrote:
> This is a common condition used to skip operations that cannot
> be performed on gigantic pages when runtime support is disabled.
> This helper is introduced as the condition will exist even more
> when allowing "overcommit" of gigantic hugepages.
> No functional change intended with this patch.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>

> ---
>   mm/hugetlb.c | 21 ++++++++++++++++-----
>   1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c07b7192aff26..e74e41386b100 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -134,6 +134,17 @@ static void hugetlb_free_folio(struct folio *folio)
>   	folio_put(folio);
>   }
>   
> +/*
> + * Check if the hstate represents gigantic pages but gigantic page
> + * runtime support is not available. This is a common condition used to
> + * skip operations that cannot be performed on gigantic pages when runtime
> + * support is disabled.
> + */
> +static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
> +{
> +	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
> +}
> +
>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>   {
>   	if (spool->count)
> @@ -1555,7 +1566,7 @@ static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
>   	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
>   
>   	lockdep_assert_held(&hugetlb_lock);
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>   		return;
>   
>   	list_del(&folio->lru);
> @@ -1617,7 +1628,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
>   {
>   	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
>   
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>   		return;
>   
>   	/*
> @@ -2511,7 +2522,7 @@ static void return_unused_surplus_pages(struct hstate *h,
>   	/* Uncommit the reservation */
>   	h->resv_huge_pages -= unused_resv_pages;
>   
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>   		goto out;
>   
>   	/*
> @@ -3725,7 +3736,7 @@ static void __init hugetlb_init_hstates(void)
>   		 * - If CMA allocation is possible, we can not demote
>   		 *   HUGETLB_PAGE_ORDER or smaller size pages.
>   		 */
> -		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +		if (hstate_is_gigantic_no_runtime(h))
>   			continue;
>   		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
>   			continue;
> @@ -4202,7 +4213,7 @@ static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
>   	int err;
>   	nodemask_t nodes_allowed, *n_mask;
>   
> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> +	if (hstate_is_gigantic_no_runtime(h))
>   		return -EINVAL;
>   
>   	if (nid == NUMA_NO_NODE) {


