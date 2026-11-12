Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9DF606B366
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=nQLBYvLp
Received: by kanga.kvack.org (Postfix)
	id 762CD6B05D9; Thu, 12 Nov 2026 06:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B2A6B05DA; Thu, 12 Nov 2026 06:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629A56B05DB; Thu, 12 Nov 2026 06:27:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49FA96B05D9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:27:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECD878052E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:27:28 +0000 (UTC)
X-FDA: 85426241376.06.352731E
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63BA6160002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:27:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nQLBYvLp;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qS4PUEw5D4i182BvRdf3oEmT2ARm6b9LLZ69zC+a5K8=;
	b=uvnYh7HQB/GdYJrVAtXbRG6aCMwnYKwaOm+7yxYwEtIzXftS/94jO5OjNa4pOwODGoB1O/
	oczDAcvCI46heUKi7dKTx/NW992Bxuo5R0Z9RCgQUpUKAjjFaa2HIVNiwY9S4W5TIqDVPC
	3UbrHnUXvvzZTbugyX/5Bp4pzhvoyHk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nQLBYvLp;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482847;
	b=YDOhtApSn+5+RujPKaBw5i+kjgGA8a+YMknNlAjnC1Vy33AZ/k+drOc1DQExfC8uMjcuK/
	u5U9sNQmUZ4DantZHgl8ad3g3MEcSWW+0Qniq/WNQwmfL5zDNdKIGbfVXDGpP9wfA2FDtF
	uOJVn4HOBYq4O9McgkvD7tg3n4dhuUU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qS4PUEw5D4i182BvRdf3oEmT2ARm6b9LLZ69zC+a5K8=;
	b=nQLBYvLpdp7DfEOKHrVzZVG6Lk5UnxaQfy9h5S0P2Z7RgAV3pGDypQQTJQD+86TQJJdeUX+Eg
	E1C0qHRpqGBP+vJucPe+vcNHIlv+MJVGWcFKZDxe7i6sol/+4PgwUEu+jaaKlbsE5oTTAPrMd0e
	9zuUVuS0Ffv+CG9Ar3n4d1g=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jQJ5V4wwfz12LJQ;
	Thu, 12 Nov 2026 19:27:26 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CA9E4057F;
	Thu, 12 Nov 2026 19:27:21 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 12 Nov 2026 19:27:20 +0800
Message-ID: <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
Date: Thu, 12 Nov 2026 19:27:19 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
To: Qi Zheng <qi.zheng@linux.dev>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>,
	<azpijr@gmail.com>, <lance.yang@linux.dev>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Qi Zheng
	<zhengqi.arch@bytedance.com>, <stable@vger.kernel.org>, "Oscar Salvador
 (SUSE)" <osalvador@kernel.org>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 63BA6160002
X-Stat-Signature: g4uhxayh3ct69hugpuzpkxg6wqr716eb
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794482845-145443
X-HE-Meta: U2FsdGVkX192psduIBSUOrzpOvsgi2PfMc9BpLLJTDzo+p6dLE83mvJejukCzWrhduwVc+8RAl9xh+kiG00whKOJDSwYPEQDN7DF153BEFVl47sudDY5IuJEwVSO4xiRshyh65wze3lgXEuJ4+R36q/8iDddYTFyvLXTn7ye2+YMZb/l9K5Yp7baHL+m/nY14MmOaWFmphIn33l+9xEDDipaFvgNzLy2IQqVBr+72LfIYk0I7ikXNQPHru0Ujz6+r2NiBr6laebXlC6NQcBAXRu5MDqoloQVSEh0lDwtWDY8gEI9x5OYxE0M4kTqI+J7ej/gJzLbTv0vw2m/MMsTX/w9EvX4++Tec30mGgNP8Nrzh1LzR4xG3dIZHoUZYgHiBVu7djjUbOJbXcGrJkQjC6EzL7pD51gyZA/gdVZvQvdzJshqmUnnvtcWwBIka5gedu73ZGmCOwrGsY9ten8TRpiQ5YZSItUCjYNuuPWwb7AnlfucKNSOAfKu1tQHrU4uFjD5sMkGCyvcWWyWD4FFBjJF/b3QrKvXRyiKRVxuM3kF5XukWYt10dN03HlIbWGZ3FfWpiBRst5XHSZbmG9GpaE5BKp1D1Q57KP38GKC/34yr+/tffzBL0wg4tczA0WzlLd+D1GddNuFqh8atF7aSW5XCCsN2D+F3jDje6JKMqA5UieLw+iSeU6p/9KcwnhozqBvwHQzF8OrbYt7aTlRB+57PyxUCr+pHoLShl9kYYBYkOs2H7DSvWxmz3d4mhK4jZ68xTZCEAjMZsJNTZOMJLbfnc4WC+Cs8ME+mds1dDiv51ltdGbQY5X+LHTsDV5wc+MafvCWrw/mXP/TWechqpxFgOo0F7tXzc5FYjHm57bQsB4wJc/IdphXIrSSW6QpmcgX57xFAcx+ELj76KDEkkjzb3UXHZgJWBL22+M1oz+jVnJhZIwm9AGsQJZ4INwZ1ibCXvBYgJYEHQz+LvD
 pPDOObTO
 yZGPu/BOoBc2gmoZ7fcGO+Fdo2IJB1C1pOvbFV/Wxv4cyU1tErWq4kNBk6rUPmTuZsFV0sFZUC3NSUrDxqZuGhpXMydZzPaTl76yXA6EmxH71IgUZ7W/D+PljYqfO3fVTMUPSdtRvPiDwMgYF3G7+2I9eK20flCcAzW541NwqhXe88JJtPvd10UHOLjgJOFUVY/DLgeb3DkzdYpPnaP/t9Q/KWkhZQX4bBLIHlRhI6oIXEWXfg0xJD5BvHGHAojtBZrQMJP2ACwnnh/m2k9eGbe7De2Le1EW/zH0L1zWGuPtf83aHvZLgzlzwwQOiGoO7uUd/Qc/um/yjhDpujHPjeuFEwQ9YP01VYq+fYvdqMr1dwmzxACAhpQDBSSzAYW5GLcbDBHIvhlKeSWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/2026 2:46 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
> during the first MPOL_PREFERRED_MANY allocation attempt even though
> the caller clears __GFP_DIRECT_RECLAIM.

MPOL_PREFERRED_MANY is only used for the partner allocator. Without your
patches "mm: hugetlb: add CMA support for PMD-sized pages,"
cma_alloc_frozen_compound() is only used for huge page allocations. In
this case, I think we don't need the gfp flag, which is why I hardcoded
it, so there's no need for the Fixes tag; this patch should be part of
your new feature. Maybe I missed something?

> 
> Pass the caller's GFP mask through the helper so CMA respects its
> reclaim constraints when trying the preferred nodes.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
> ---
>   include/linux/cma.h |  2 +-
>   mm/cma.c            | 10 ++++++++--
>   mm/hugetlb_cma.c    |  4 ++--
>   3 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1a..4539ea5f2c4e8 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -53,7 +53,7 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
>   
>   struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>   		unsigned int align, bool no_warn);
> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp);
>   bool cma_release_frozen(struct cma *cma, const struct page *pages,
>   		unsigned long count);
>   
> diff --git a/mm/cma.c b/mm/cma.c
> index 9ec1d1fd5dff5..a7c47c0e7d070 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -933,9 +933,15 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>   	return __cma_alloc_frozen(cma, count, align, gfp);
>   }
>   
> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
>   {
> -	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
> +	/*
> +	 * The only caller of cma_alloc_frozen_compound() is hugetlb, and
> +	 * hugetlb constructs its gfp mask via htlb_alloc_mask(), which already
> +	 * sets __GFP_COMP. Check here for usecases bypassing htlb_alloc_mask().
> +	 */
> +	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
> +		return NULL;
>   
>   	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
>   }
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index cd6a64986278a..3e5a30571524a 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -69,14 +69,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>   	}
>   
>   	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
> -		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
> +		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
>   
>   	if (!page && !(gfp_mask & __GFP_THISNODE)) {
>   		for_each_node_mask(node, *nmask) {
>   			if (node == nid || !hugetlb_cma[node])
>   				continue;
>   
> -			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
> +			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
>   			if (page)
>   				break;
>   		}


