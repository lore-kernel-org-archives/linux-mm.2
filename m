Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6601DCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE2A6B0092; Tue, 29 Sep 2026 06:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F016B0093; Tue, 29 Sep 2026 06:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5286B0095; Tue, 29 Sep 2026 06:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9C96B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:26:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9AF3C0439
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:26:03 +0000 (UTC)
X-FDA: 85266419406.10.617F2FF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0588F140005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:26:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=QOVoSUlA;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790677561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT4o9d/2vlBFcR99884BysVogSlpXFQqRDgo+bJW/Q8=;
	b=xu8g5DXgpC5JZdl9qeHvlPkiAF3hyEDf+8BTrxVebm6I3RHZo0pLuOVJytnZPN4An/x1re
	0otNmqRNRMGTTA3CoRKloeQ6DHx7xVQVBQcgO+XxHkLhW83y5FaC7Ncp5ghUKArwY8kNIa
	ti88tDIU20DEnQQy9UXottZm9DwV7sA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790677561;
	b=wLAMxhBU0+sER9RqjG+ug0ilwM7FCW+KJZgz2iNf3+0+KMsryMHEDJ2kYNt9IZEVgluRYT
	RF/OBt+tfT+X826+LFBJFFL0GGZblUX1rG/4Agtjf6WbNjJKEn5v7e7T11RZabA9ixz/PU
	Y/mvmsbDlWstN5zvLp7y7u1JeDqb6Z0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=QOVoSUlA;
	spf=pass (imf09.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fT4o9d/2vlBFcR99884BysVogSlpXFQqRDgo+bJW/Q8=;
	b=QOVoSUlA6uxSUZ/8KC9VBGBcbFjtEbI0KjLLjDtHtjN5UYJR5iWXetzv0+byKAzqNQJknHaj9
	RJQyjJZBN6mqM9Gsjv88ata+Ws5W8Vqr3pl9JT2RD1B/l6CZTrQAPhswxUc4WnDP4alDF0iCW2c
	xhXjxrjHg8+z6ZvKC1PPx4g=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hvDpc1xzszJ46ZV;
	Tue, 29 Sep 2026 18:25:44 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D1B4340575;
	Tue, 29 Sep 2026 18:25:58 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 13:25:58 +0300
Message-ID: <c19759f2-c28c-4b7e-a587-0a4087e85997@huawei-partners.com>
Date: Tue, 29 Sep 2026 13:25:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/damon/core: add complement argument to
 damos_new_quota_goal()
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260929080113.41708-1-sj@kernel.org>
 <20260929080113.41708-3-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260929080113.41708-3-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Stat-Signature: d4iy7ddnb3exi3om1p1e5jgsdq1g6n4d
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0588F140005
X-HE-Tag: 1790677560-482834
X-HE-Meta: U2FsdGVkX1/sOpBQztqr5Y/aROFuUWmsO2IIYeaZP0KYsDp/IQOsFckFjIjHW2i4iv1g/79zp0nYsy+jcCHSCvMEBJ3tCSuh89y5kTICjzOQ75L6uqxw5A3Kx5hqvUIpqU5X0nPplMV+2KeK4p24TJ9nJ9NE+IVxp8FiFjfn46GXlKrICFG6keOkHAkhCKcImAGaa1lQrTgQOqR5duujlSXUCqameofRV/ElBEdYEtELMJXm1fIeQR6tjgBvM5afWw3fSy3oA0uM8pz6xsMwgHPI71LSGTFenYhRHsuFJR6HtXEv6BJ2GHGO0dZUlrPf6OwZcQqQkXUm0R3N/2LMpCnssMaLyFKBNSAj4LXJDA52VElYgp0TOcdtasjfguklbuv+IxY5dFezYPgoIHNoJZbNfJv7636BqZXad3I0SokqpvCzhe06tdY31gLZV3soiKRprXvwV4JdH49uM2w7xJAkq7yupVfW4h9iB2o2iz3YcoaRHCWz0Y2dh53+bHb4OLHQIcT6ewYcH4jevaSwUAK/XgHaJsOUfFeF7we2tGWtkt02RS9V0/25TR4M7Ja2UsObCZ7i0lfuOOurOROmgRNT6u2AtWT63tLs0yZ3dg1B6Px3N7dkpHMI/n4O0u/fTr8+Qr4f6Q0SMCruNDsVCHv5Vueli37ctUVlK+1PoJowSl2pLwwFN1vUcF+2LZSfUh/U5FoIuKaDLKhC7NAitEn2AcmkHPC6LUXqsBBQXjAmG+wJ1mkLKdDdgUR+8Gi3Q4o57S4z6VnIk4mzH7RA3Jq0ibs+H8m82BtJ08a6Buf+c7bUW1cge6xcyWz4KwmRWDJ9UdFZDlZBy6NlRA1lhekj7ncHCZHDORiXjeyc8e8eupdn7FUfq8BVxojPKoerrVzeR+vxh06S1eoOwruOTu5RcOQUNKyqeexplIuMFRcde04gNQ/TpnqnScclDjmbQR7Pf8Mcj+MW7rRe4S0
 LxkyVKJb
 POEb2HWx2CbHUZoUkbutXdZ/ISAF7HGqUPbydgP4BHkVqRODRWHqTADkT20RpjS2vXSoa0/nQJw11SufxHV89u90iv6/0bK+KY6H2J1NUMI90eBQsGtnkbp/UJiAjRLWsitndhKjYeVHXWR59osO3Xv14d8qUvS3nMhtzwbUijOLky42LkF9/OBPdFyYgnNbkIgQiEUkGl658/eLlpoRHsUUXaKSyFySB3s4/HfL8Eyey+iPqOX3u0FO2h/eApv7EoB39sFk3fERpPiEZckMNdX6MfXQAY45QqNnHJRu9AhJdcTaUb5Tl2FkUxbSvi4/30/3dm03a1KTgdGaAwkirze+3mzsas6liOFA14A//6P0wzQGAq2hcnt3h6YwrlzwA71mN4bSAWZrqUk0Av65Rlbol2Vow2elCwQU8TYECWMN+06iT9rXMLOU06Cl1Xu2bGGyjoYSPj2wgN/ub/ccCWH9nn35ssBc0DkFQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/2026 11:01 AM, SJ Park wrote:
> damos_quota_goal->complement needs to be manually set by each API
> callers.  It is easy to make mistakes.  Extend the quota goal
> constructor, damos_new_quota_goal() to receive and set the complement
> flag value. Also update all callers to use the new signature.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  include/linux/damon.h       | 2 +-
>  mm/damon/core.c             | 7 ++++---
>  mm/damon/lru_sort.c         | 5 +++--
>  mm/damon/reclaim.c          | 5 +++--
>  mm/damon/sysfs-schemes.c    | 2 +-
>  mm/damon/tests/core-kunit.h | 3 ++-
>  samples/damon/mtier.c       | 2 +-
>  7 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 42234839ce29..63050eb2206a 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -1090,7 +1090,7 @@ bool damos_filter_for_ops(enum damos_filter_type type);
>  void damos_destroy_filter(struct damos_filter *f);
>  
>  struct damos_quota_goal *damos_new_quota_goal(
> -		enum damos_quota_goal_metric metric,
> +		enum damos_quota_goal_metric metric, bool complement,
>  		unsigned long target_value);
>  void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
>  void damos_destroy_quota_goal(struct damos_quota_goal *goal);
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 1ab5154511e6..86fee9ca03a4 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -691,7 +691,7 @@ void damos_destroy_filter(struct damos_filter *f)
>  }
>  
>  struct damos_quota_goal *damos_new_quota_goal(
> -		enum damos_quota_goal_metric metric,
> +		enum damos_quota_goal_metric metric, bool complement,
>  		unsigned long target_value)
>  {
>  	struct damos_quota_goal *goal;
> @@ -700,6 +700,7 @@ struct damos_quota_goal *damos_new_quota_goal(
>  	if (!goal)
>  		return NULL;
>  	goal->metric = metric;
> +	goal->complement = complement;
>  	goal->target_value = target_value;
>  	if (metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
>  		goal->last_psi_total = U64_MAX;
> @@ -1262,8 +1263,8 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
>  	damos_for_each_quota_goal_safe(src_goal, next, src) {
>  		if (j++ < i)
>  			continue;
> -		new_goal = damos_new_quota_goal(
> -				src_goal->metric, src_goal->target_value);
> +		new_goal = damos_new_quota_goal(src_goal->metric,
> +				src_goal->complement, src_goal->target_value);
>  		if (!new_goal)
>  			return -ENOMEM;
>  		err = damos_commit_quota_goal(new_goal, src_goal);
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 273efa3c913e..64e086985eb5 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -233,12 +233,13 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
>  
>  	if (!active_mem_bp)
>  		return 0;
> -	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
> +	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, false,
> +			active_mem_bp);
>  	if (!goal)
>  		return -ENOMEM;
>  	damos_add_quota_goal(&hot_scheme->quota, goal);
>  	/* aim 0.2 % goal conflict, to keep little ping pong */
> -	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
> +	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP, false,
>  			10000 - active_mem_bp + 2);
>  	if (!goal)
>  		return -ENOMEM;
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 42a2c9cb1343..014b0779ea6d 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -233,7 +233,7 @@ static int damon_reclaim_apply_parameters(void)
>  	damon_set_schemes(param_ctx, &scheme, 1);
>  
>  	if (quota_mem_pressure_us) {
> -		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
> +		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US, false,
>  				quota_mem_pressure_us);
>  		if (!goal)
>  			goto out;
> @@ -241,7 +241,8 @@ static int damon_reclaim_apply_parameters(void)
>  	}
>  
>  	if (quota_autotune_feedback) {
> -		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
> +		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false,
> +				10000);
>  		if (!goal)
>  			goto out;
>  		goal->current_value = quota_autotune_feedback;
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index bfb6f0bc3f21..06af417bc9a2 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -2869,7 +2869,7 @@ static int damos_sysfs_add_quota_score(
>  		if (!sysfs_goal->target_value)
>  			continue;
>  
> -		goal = damos_new_quota_goal(sysfs_goal->metric,
> +		goal = damos_new_quota_goal(sysfs_goal->metric, false,
>  				sysfs_goal->target_value);
>  		if (!goal)
>  			return -ENOMEM;
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 2111faa58153..5a924edb171f 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1014,6 +1014,7 @@ static void damos_test_commit_quota_goals_for(struct kunit *test,
>  		 * Make it kfree()-able.
>  		 */
>  		goal = damos_new_quota_goal(dst_goals[i].metric,
> +				dst_goals[i].complement,
>  				dst_goals[i].target_value);
>  		if (!goal)
>  			goto out;
> @@ -2411,7 +2412,7 @@ static void damos_test_esz_goal_temporal(struct kunit *test)
>  	}
>  	damon_add_scheme(ctx, s);
>  
> -	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
> +	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, false, 10000);
>  	if (!goal) {
>  		damon_destroy_ctx(ctx);
>  		kunit_skip(test, "quota goal alloc fail");
> diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
> index 27dc88bdf7a0..a2e311082cd4 100644
> --- a/samples/damon/mtier.c
> +++ b/samples/damon/mtier.c
> @@ -163,7 +163,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
>  	damon_set_schemes(ctx, &scheme, 1);
>  	quota_goal = damos_new_quota_goal(
>  			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
> -			DAMOS_QUOTA_NODE_MEM_FREE_BP,
> +			DAMOS_QUOTA_NODE_MEM_FREE_BP, false,
>  			promote ? node0_mem_used_bp : node0_mem_free_bp);
>  	if (!quota_goal)
>  		goto free_out;

LGTM

Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

-- 
Asier Gutierrez
Huawei


