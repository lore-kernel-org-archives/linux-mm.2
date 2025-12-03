Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A54DD116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 04:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C426B0005; Tue,  2 Dec 2025 23:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C9F6B000C; Tue,  2 Dec 2025 23:27:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849AD6B000D; Tue,  2 Dec 2025 23:27:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 760406B0005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:27:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C320B160456
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:27:49 +0000 (UTC)
X-FDA: 84176876658.27.DEE0C2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 322CC100002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:27:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W1coB1wn;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764736068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JNa8d9DpelZxgdyO18mh8CPJb5ZYat2BuCyOuHqDEc=;
	b=QVO8v6ApclNSDzMvotJTq4cqjOEYZ/BC0RyT+MZyLE4pKlyjDkUCTkdW5WjILGuB2uGRx3
	9S6KV3d3Ka0kl10aT6utUZhOCoD0oQf254T2UOzEqNkzogYmQxqKejAgCNasL7Ug58mQUA
	0W+EgaAqTM/8KkwwiqgIj0wszYPhrJ0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W1coB1wn;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764736068; a=rsa-sha256;
	cv=none;
	b=hdV1Yuj54AwNVP/aPKWN4cyFkGzoyotQKaTjgvtWXtW2204mesMlj0uPhnSmVOagWBRcGh
	Y9x6IxJTDOsQPY/UmZ+LioteaBsdG0brJ3FKAgrTbPDsc4SKEOq7KU2FqACsgtp9KE6mi3
	+peotDm1WQ8E7MT3vEK65a1TaQGSh+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B1E6013B;
	Wed,  3 Dec 2025 04:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B92C4CEFB;
	Wed,  3 Dec 2025 04:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764736066;
	bh=tPlfzQ7ySw2YU91N1d0A6LgeE5AkyUSUmsZCqgfFqsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1coB1wnikJJ76puWnf4JrHWVFoeydnfcimJxjAX4L8p6D9gihk5hBHWgav02o+jc
	 /2fSgBF6P47IibKcBCeAocTndDmW3viLdOvudKgbzGC4ID6V27pkXp0r2JxPL4Eqfe
	 mnWIbcLSiYhvxTwek5wRCqSizcS2sOWLfY/mpavUvK9+DTql6gED9HQddzk61RuhOU
	 cZQFvo8R8FaMx5dgkn3/i1bb2iHf4aUEXOS3WWHofzZfDQS55KxY7EiBhiDcAbP1Na
	 BYxz1l3h6YSUJ5Te016O61UTLf45dEwGW0a2SG6s2+CVLWoqACiVKpo0kz17zdkp76
	 fcUK5ITxg75ew==
From: SeongJae Park <sj@kernel.org>
To: Jung-JaeJoon <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	rgbi3307@naver.com,
	damon@lists.linux.dev
Subject: Re: [PATCH] mm/damon: Remove duplicate attrs.intervals_goal at the damon_stat_build_ctx()
Date: Tue,  2 Dec 2025 20:27:38 -0800
Message-ID: <20251203042738.47206-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203033350.14629-1-rgbi3307@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 322CC100002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: s9u85hbs9jxz7zkeywkhqgptj6ykc7jw
X-HE-Tag: 1764736068-17353
X-HE-Meta: U2FsdGVkX19ZaT0iOlJWf7ECK9Csds6xgndwb8C2bHSmb3gek7GA6+Qt9I7HsulUxUxZhuRTNs4O/0o7j8qRbBc+9DVBEZ3S7X34VJ1mXuUVolRXsv3nG33RlK3A8SBC61OQSZ4ge6Y7rj3wa12AbD2N9MlbRcZBzyB+0qu3hQ3NvoAfElY6xlB2AyGYpR98uH9GYbr3ZZvM8IOv0iVARKyjhXhxHq2v4QnMAaSmXw0NHiVKi551QId7QtI0MshOzEcVJ4/joiDjSzvDPmvtwbeDTd0oUGHADHartBLsoTb//JDrwZVp9SFllkmlMEXkmGpK7ffo8Lyp6X/kyfBCWLhGnER5HW6+N+A61JvPAupsz4vjP92+LAK0VKom6iEJquw0M5wkOQS87ioE3SgeeACW/p0dID2dUwagDdM3yIzHCwhPge7d+80T3kUJNxgEeSl3zgbFyy6mJ0q/ty1BNgu8LOEP+MQEgikBqnNubO/fvYGv2dOUTnMrOXMbR4jJzttdQ0PXTl+9pwsoreFMR3ypgFQHzlB4DFjOg3dH2o3uufOFV36KPLYr9UVZwZfW8XQgWpO5/xyatO8OksgCFBgnaymbBACskSBeBsL2hursFAlx7hlSrz9NiRwidyprV/xfBvRNIFLDTF2fllXTtGbYUVSb7WeyYs5L9WX6ZJwkVnOjxspFhsxaeeu9UA8FN4CYHo9nlzCeqY8damZXSA+1RrTUyBeNpfKmbBMFBfCa4v+3/1zNSodPTu8aka/59WxAXIFHTS7XsvysO0XYBh3lzKf/MbwrLi/XcgibVWPynfCSvpzu3HMS+H/+ldlX8crLgawgJHps0X8SeErArbxQwzDOOI0arqgzeW6qYcHvy8ZoBcYoX7cyfy4UzdJeLnw7139eE3x6Wfw4FbfmckXk6NOVuG8PbeobhSKgTTGAztpAM0IoaQe/Bq14EkB9lz2wdz4vQK1PonShtxa
 ps5icpdy
 Xi3+F3yIB8zkHZJChw42hh7K1KSRfpYD6is4lFjJ7BPueHVS5D18m0Eu6Itlkba0XsEgf7DpzZb1nRBIdEKh+t11zxdV/AEXZW0u2TVEiBerkFqRh1q+fiLdSRxOt3I7ZNKGvEn84yCYDf5uYBevQA5VseXCrIVm6QPyji/2DCGaueHgoXmbCpx0tD3Of+FOZJvs/tQIIZbAivdUo2HXd+vQikLlnnTxwPGXOQLowLVm19QiApNbDW64+g0tQW8YTa9xI95gY23NDGhIZQIHM8q8AUrLP+MRs4UmTQt1MAUtDrcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ damon@lists.linux.dev

Please Cc damon@lists.linux.dev for DAMON patches from next time.

On Wed,  3 Dec 2025 12:33:48 +0900 Jung-JaeJoon <rgbi3307@gmail.com> wrote:

> The damon_stat_build_ctx() function sets the values
> of attrs.intervals_goal structure members.
> These values are applied to damon_ctx in damon_set_attrs().
> However, It is resetting the values that were already applied previously
> to the same values.
> I suggest removing this code as it constitutes duplicate execution.

Thank you for finding and fixing this!

> Please check the modified code below:

The above sentence is not needed for normal patch descriptions.  Please drop
it.

Also, I think the subject could be better describe this change, e.g.,

mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()

Could you please make the above suggested changes to this patch and resend the
modified version as v2?

> 
> Signed-off-by: Jung-JaeJoon <rgbi3307@gmail.com>

If you agree to my above trivial suggestions and make the requested changes,
please feel free to add below on the v2 patch.

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/stat.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index bf8626859902..51dd29685915 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_build_ctx(void)
>  	if (damon_set_attrs(ctx, &attrs))
>  		goto free_out;
>  
> -	/*
> -	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
> -	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
> -	 */
> -	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
> -		.access_bp = 400, .aggrs = 3,
> -		.min_sample_us = 5000, .max_sample_us = 10000000,
> -	};
>  	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
>  		goto free_out;
>  
> -- 
> 2.43.0


Thanks,
SJ

[...]

