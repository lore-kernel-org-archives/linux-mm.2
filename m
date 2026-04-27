Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A68FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DD06B008C; Mon, 27 Apr 2026 09:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4826B0092; Mon, 27 Apr 2026 09:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922566B0093; Mon, 27 Apr 2026 09:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81D5C6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:25:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12D58160201
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:25:20 +0000 (UTC)
X-FDA: 84704407200.16.BD9FBA9
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F5F6100003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:25:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OUrL8uRdoVkzolpM0Z8Fvo8ige2A/3se3mi5l6Tj/qs=;
	b=PN1UgElYsz3HqQYnlYaItYHa1sHxfilpFBAgbB09T10/96fcebZqOBk3hkhp5LSvOxtTwG
	RuBFGZi5WZcaw8kFynuxORKFnneSN+St0mF2BQVJ+Dbc3sxwX4oeTpvtw85/qJk02nm0CQ
	EKyw+9ZrX6h+wQpcisW2olZh7gGr1RY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296318; a=rsa-sha256;
	cv=none;
	b=rDcpcPHi9jiLrWy0lXqX/Ze4JLA1811LJt352DJQksgIajx4ayYMh6YRTom4L2BCGvk06A
	TntjRtditieYkibTrZq9Z/q9NrNDoK5xJaf9zDeaoQ0Od2QPXCnJheCWKs6JyZzBwTYtap
	S38ZiSX0FgxPXuJLT9Q6NssH9DNhIeE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g447B6cf0zJ46XJ;
	Mon, 27 Apr 2026 21:25:10 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 3ED494058C;
	Mon, 27 Apr 2026 21:25:13 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Apr 2026 16:25:12 +0300
Message-ID: <d08d7ffd-8d51-474d-bf57-887e09cf1b05@huawei-partners.com>
Date: Mon, 27 Apr 2026 16:25:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 14/19] mm/damon/sysfs: setup probes on DAMON core API
 parameters
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260426205222.93895-1-sj@kernel.org>
 <20260426205222.93895-15-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260426205222.93895-15-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F5F6100003
X-Rspamd-Server: rspam04
X-Stat-Signature: n15p3you36rabjodqu8p9a86dawdodhe
X-HE-Tag: 1777296317-186106
X-HE-Meta: U2FsdGVkX185J+eKSESC9iVOp9XlfifdISI5pQUMNSBeQ7GJtIwtMnvf2LKLzH4oPwzPtEma32x8siLW/TVjq6EEQKf2jU9z5MZsOv2udgPHXvXfwnC5KQpdztiX8YHB0mxI2kll1N8DiPqIrk77DtPGw5vmwk8g85HxgoL+43tRsrH0aGjmKgKy+nwvizOa4a+umjya4bH5mUg3UlI2yhePb8g8Qe2LGeC4H0p1yMhDNnuGuhCcTwss/1PR/gLLcRPV+CBwZcfeza2LzwrxRe/RF2/YtKJn0uv3AUKfgdZcgJf6Wc+hvWl+gBc1Gexd1iusfOdYSZs7ILOvjM2H+JucWdnpG/I+pyBBQU9LKqYhacp67kTEcYNO9agK366l8TLcwmei2Tkyl1EbF77ZxFeudw2FIxRKjvLcMMHcP3ErRJ98Ji2Fdk4HA7txwQLSYoLG0Ve5VZA6HI15oG3wph+yZSR4nMs+9V9FinmVnkk/xRbGM2kasgy9skzzd1nqP8CmRGobsPNRXSWPomRqZvTTgnw5j/MHZt969fzXEFZTFRHlyZx3fPbQeQECPGQe3EfFDwXX2I3w8szsWm4sInMW0J+2fj7VvroNYBTpmTxpRKTB0NB0jm/TIM8RRNFkN+dZjrWRUqa2JrvgkM2NJMYarYAopwykB5hAp9QnWolu0RhtUGs89QQzI37x34Y7ToGABM5QfLPnh2Ed7umqqDHiJYSLJC/g+pGLFfzR32M3u+IvVc2ueLkcPgHxH4+hSEVgEcqf5l1XqsKvRLnmyw+rhKPWf6h8hxOdoeUHFnMpOZu2EVSG/5mtOH4TbsBXD/gQwS0zYkG8qaDWb9TOTDUGzKff9VoPYrjT0BhmsXy4h+g364dcC6uoU5kDm/bmltol8k5+Le/MMOc8hff3I+rsBMhCjpBy9BZY6VZvlJRLURii16taloEg+QExHqRDFWkeLfeFWgzBPrr5ATG
 x8O5sG7T
 rddV3MeYbkXRJldQOUHo8O/7Pj5FBe6s0fkOKdi3mRnQMngNbAfZScqAMPxiiSwErNJrLyFKfie61OzMbehwv4msxT8r9ZbbJ0HUS4cS7xGQxIPS2HzeBCZ8nAMHGH0Xa846dwBbjpztvdVsDV0hks+GWmuR/IyTPWho38JU/mUkSxxugG+ll1oaNUAccbrxq0dOLiAKWb2R4eh5lQNrRAnJqwlmy0RtdvZDnE4ed5Ckj9pCKsHCwxT2F3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/26/2026 11:52 PM, SeongJae Park wrote:
> Add user-installed data probes to DAMON core API parameters, so that
> user inputs for data probes are passed to DAMON core.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 2e0b7eca6bcbf..8007961295d3d 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
>  	return damon_set_attrs(ctx, &attrs);
>  }
>  
> +static int damon_sysfs_set_probes(struct damon_ctx *ctx,
> +		struct damon_sysfs_probes *sys_probes)
> +{
> +	int i;
> +
> +	for (i = 0; i < sys_probes->nr; i++) {
> +		struct damon_sysfs_filters *sys_filters =
> +			sys_probes->probes_arr[i]->filters;
> +		struct damon_probe *c;
> +		int j;
> +
> +		if (!sys_filters)
> +			continue;
> +		c = damon_new_probe();
> +		if (!c)
> +			return -ENOMEM;
> +		damon_add_probe(ctx, c);
> +
> +		for (j = 0; j < sys_filters->nr; j++) {
> +			struct damon_sysfs_filter *sys_filter =
> +				sys_filters->filters_arr[j];
> +			struct damon_filter *t;
Move the declaration of these two variables to the top of the
function.
> +
> +			t = damon_new_filter(sys_filter->type,
> +					sys_filter->matching,
> +					sys_filter->allow);
> +			if (!t)
> +				return -ENOMEM;
> +			damon_add_filter(c, t);
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int damon_sysfs_set_regions(struct damon_target *t,
>  		struct damon_sysfs_regions *sysfs_regions,
>  		unsigned long min_region_sz)
> @@ -1967,6 +2001,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
>  				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
>  	ctx->pause = sys_ctx->pause;
>  	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
> +	if (err)
> +		return err;
> +	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
>  	if (err)
>  		return err;
>  	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);

-- 
Asier Gutierrez
Huawei


