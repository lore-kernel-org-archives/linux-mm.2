Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD15CFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9256B0088; Mon, 27 Apr 2026 09:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAA56B008A; Mon, 27 Apr 2026 09:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0326B008C; Mon, 27 Apr 2026 09:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF686B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:18:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7E251A01EA
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:18:22 +0000 (UTC)
X-FDA: 84704389644.02.CA1D8A7
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id A7B0C2000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:18:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777295900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/rlQ2dz7L9naLNYask5zkrnIy1bNKP76TfQanHIM5eE=;
	b=LOnQX/MhIuAAZFP5ZvGHf6mkJRhCwpK2pUdrI/VvskeAxwnRQp1aSz/7XU1SwZERvo+aUA
	fIZ81Y2YuFwmmCnB0UM/sAGXKs2eZzXR8Z+Zfn+l/sVVoMPiScilzBl/PugNBakUVTptqs
	l+3Ztvf705qn8Xef+5M2r12NJ5xKuo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777295900; a=rsa-sha256;
	cv=none;
	b=ZEPnxiB6ZBz3joppbXGkDpXbgU3gbRs2Xuuuky6PAH8d4JX0wPAfM6/cdJ3XxTxI/Y05mG
	TX2x8ww466zEZVKaQ9R7h7JfBYTNNF+SWPJWyZCuej8gIgw/rpqKYA4mmyz1ZKAa33bThy
	4JZteNOhDG+2wUzKb/skuhMG9K1NwSQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g43yR1fTszHnGk5;
	Mon, 27 Apr 2026 21:17:35 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C05740570;
	Mon, 27 Apr 2026 21:18:15 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 16:18:14 +0300
Message-ID: <2e2bee93-d68c-4b29-9ad1-1ef975fccec4@huawei-partners.com>
Date: Mon, 27 Apr 2026 16:18:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/19] mm/damon/core: embed damon_probe objects in
 damon_ctx
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260426205222.93895-1-sj@kernel.org>
 <20260426205222.93895-3-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260426205222.93895-3-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7B0C2000D
X-Rspam-User: 
X-Stat-Signature: qhjicfanch7trhn91ik54taxoygz4szh
X-HE-Tag: 1777295900-679249
X-HE-Meta: U2FsdGVkX1+uC+68PZ2WEVQOMGzHfaDIn6QwdoG071/ECJGShQx/7BT4WZfGLIBOv2IU1Cth+8qsCCPdeE6wIDK/Cp9T88jV8a7n05uE2VHlDqa+OC6vmb9uyoU5lPU0ripPc7mqEUpdQJUf0JYiVXfIEoJvt3kwYcokulnWpAJHDWMsRDyqlkTUL3MOQ15YarjhH503kN/k1DPKigUdKRXws4rJD8M6NGmclmegLdT3dl3h+z6/LldQKlIMC6lZTpYf0StqCpNBv7kSZLcrfSvK1EBxrGU/t6trQ339jeSpB2BH7hMpbe8zwXAKnNx+/RuAza0fHl+jhUudLJSE12HiOJA9GwjZRsbMO9eshB23hLI+3lxeiLHUI/NSW/xVdfmTTrW5NAlHtNd1/KgIjNVvLspar3RSfQ+0pLD5ALPCzn2xnyk/K/Gdkkn5Iefd4JEM1bbhOgbKyG3d4L5jyx/7q2GJq8XI8IpNSBe0oyNs5vI4GDqONRWVF3Tv8aBDOD3q5dNzgrM6QGabsuICVh7ZkbSrqW0TQaVOQa+de3Lbpm+Cj00qePbdGkrcgg1iCms28gSVL+B73fEnDLz0U9+WWMVuRyQzAwAK1KdTFLVIBfwsGmHTxs0w+myA/mjiwUXgFoloG2vnSoaIXT28TVSpgpmMqQestBEd2IdR52lOUQ7G2jn1ZxVWO5yjhw1supwBRaRiko8H55ZIzxZ0TJn9aXiNdzZ59qk1h+vsppZPQKnkjmAEJzB2qzuax5YAMt7fFaCioqKfMlYXXy2Atb62iyvZB0pKScDubBpBQ+ebhNV1iCxURaxdFDUvwPzqhcue2FrKmBdZKCAfk+WgXRr8aMwwbzxZ0yyA4h/JZ06wZ3WWaLV6BLHC6aVv1ayp9JZNW44K3tnRGaHn6FtUPTenczqC2huc+25K0cUaoDFI/+J2wn4qpW+PDX6R9VU8JIQgn+9pBhPKZ72VC7d
 coNgaB/b
 KTR3c0GJbnGFNDeVKwv2/7oByo/jK0mIlHiUTBfJhH3miL0oGeVxpi1wpU/XVykL3BbReowW/yuE4SQ0HLdgF6TQPdkiudfOPzcOQKJCL3y8509QVWrUE7kjfrnOOGPqkBnQ9u4hRM5s3aAIdvoX2H1/Q9e1qZ0Y2EVDkbTmJ4PMHSbMfK1GOOE0DWXuf9liBaD5VdGQqkiUc0OXDOnNj5wtA+uK/792pn4uIB7UE4X/OXB3WvCSfVHxbiEDFo70DpnwO2kJoFy5gSRqX9bK4Qbkg7mw8y5cw2H2h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/26/2026 11:52 PM, SeongJae Park wrote:
> Let damon_probe objects be able to be installed on a given damon_ctx, by
> adding a linked list header for storing the objects.  Add initialization
> and cleanup of the new field with helper functions, too.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h |  9 +++++++++
>  mm/damon/core.c       | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index da2f026eac725..65d7ee0a70ac0 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -859,6 +859,7 @@ struct damon_ctx {
>  
>  /* public: */
>  	struct damon_operations ops;
> +	struct list_head probes;
>  	unsigned long addr_unit;
>  	unsigned long min_region_sz;
>  	bool pause;
> @@ -892,6 +893,11 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
>  	return r->ar.end - r->ar.start;
>  }
>  
> +#define damon_for_each_probe(p, ctx) \
> +	list_for_each_entry(p, &ctx->probes, list)
> +
> +#define damon_for_each_probe_safe(p, next, ctx) \
> +	list_for_each_entry_safe(p, next, &ctx->probes, list)
>  
>  #define damon_for_each_region(r, t) \
>  	list_for_each_entry(r, &t->regions_list, list)
> @@ -934,6 +940,9 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
>  
>  #ifdef CONFIG_DAMON
>  
> +struct damon_probe *damon_new_probe(void);
> +void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
> +
>  struct damon_region *damon_new_region(unsigned long start, unsigned long end);
>  
>  int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f556786597c83..861ab977d1edf 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -109,6 +109,38 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
>  	return err;
>  }
>  
> +struct damon_probe *damon_new_probe(void)
> +{
> +	struct damon_probe *p;
> +
> +	p = kmalloc_obj(*p);
> +	if (!p)
> +		return NULL;
> +	INIT_LIST_HEAD(&p->list);
> +	return p;
> +}
> +
> +void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe)
> +{
> +	list_add_tail(&probe->list, &ctx->probes);
> +}
> +
> +static void damon_del_probe(struct damon_probe *p)
> +{
> +	list_del(&p->list);
> +}
> +
> +static void damon_free_probe(struct damon_probe *p)
> +{
> +	kfree(p);
> +}
> +
> +static void damon_destroy_probe(struct damon_probe *p)
> +{
> +	damon_del_probe(p);
> +	damon_free_probe(p);

Why don't we inline list_del and kfree here instead of calling
damon_del/free_probe?

> +}
> +
>  #ifdef CONFIG_DAMON_DEBUG_SANITY
>  static void damon_verify_new_region(unsigned long start, unsigned long end)
>  {
> @@ -633,6 +665,8 @@ struct damon_ctx *damon_new_ctx(void)
>  	ctx->attrs.min_nr_regions = 10;
>  	ctx->attrs.max_nr_regions = 1000;
>  
> +	INIT_LIST_HEAD(&ctx->probes);
> +
>  	ctx->addr_unit = 1;
>  	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
>  
> @@ -653,12 +687,16 @@ static void damon_destroy_targets(struct damon_ctx *ctx)
>  void damon_destroy_ctx(struct damon_ctx *ctx)
>  {
>  	struct damos *s, *next_s;
> +	struct damon_probe *p, *next_p;
>  
>  	damon_destroy_targets(ctx);
>  
>  	damon_for_each_scheme_safe(s, next_s, ctx)
>  		damon_destroy_scheme(s);
>  
> +	damon_for_each_probe_safe(p, next_p, ctx)
> +		damon_destroy_probe(p);
> +
>  	kfree(ctx);
>  }
>  

-- 
Asier Gutierrez
Huawei


