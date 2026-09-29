Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC48CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E026B0088; Tue, 29 Sep 2026 06:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E3A6B008A; Tue, 29 Sep 2026 06:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD8D6B008C; Tue, 29 Sep 2026 06:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 698DE6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:24:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D46FE140483
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:24:30 +0000 (UTC)
X-FDA: 85266415500.14.19E3B10
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id C183A100007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:24:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b="BomE8Z/A";
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790677467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zV15/2vXc2zmmCBC0wBRxIby3C3ggjhlTWNSwlGL0ro=;
	b=22UL0BdlrGnZdrSwfawkCaHmefWR68/+cVde2vwVPmJ3fKYenH5KSJxBDwnYcWSFW7zCNy
	9itFSaDjxFa+7kEiM1yoWfydFI9J1euIjl4nc++n9LQovyufmer+vwJgjL9ukrY7nj2Tvf
	n7At37/mfolB8himk82TcWTaDa4LTHM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b="BomE8Z/A";
	spf=pass (imf05.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790677467;
	b=stcA4v2gdsAdp7feyBLBzvmHnQmMbkkZnDSURwpWapXEHdGZrRuheQxyPc6uNcs4/VAR4h
	tGWAhXnSVMfuGhwDh52xFA6b6sELWVgqDlUYPYotujlOiemG62H8h0sTdwGmLJ3kU0hJLa
	LVweNtJnDB3PE2l/ltPl3m05xPx61jo=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zV15/2vXc2zmmCBC0wBRxIby3C3ggjhlTWNSwlGL0ro=;
	b=BomE8Z/Agr0yj3ehCeSYnRmn1e64OrhvSs/g1NC/W0zvjSqOBYpNDl8KaxE3XefivF9VN1jBj
	r+XraTw0qNIDUXuOko8ijMpOqXyBBSb+fqu1faPa4dJXTHpL4d0npNsa0q3xkHitf4XVevIs0bE
	cHYdkGcNMgCPtlHy0mPPOZg=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hvDml6Y8jzJ46Xx;
	Tue, 29 Sep 2026 18:24:07 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 7CA0F4058B;
	Tue, 29 Sep 2026 18:24:22 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 13:24:21 +0300
Message-ID: <9e07dbdd-3b02-4175-b343-c8cb6f9885e0@huawei-partners.com>
Date: Tue, 29 Sep 2026 13:24:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/damon/core: introduce damos_quota_goal->complement
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260929080113.41708-1-sj@kernel.org>
 <20260929080113.41708-2-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260929080113.41708-2-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C183A100007
X-Stat-Signature: xfoprwm3ajw5dkc3x7dzp9qi19aywszf
X-HE-Tag: 1790677466-385833
X-HE-Meta: U2FsdGVkX19kcCnASLraVwA3BqCQMEie6R+hXPPzdi4LFMewjM0mFEB/1shnuSVo8KayqG+i9tTGmSJFyGaM3ezi7EclKGLW7eLa74BbeiQ3rjlR02s6HtXhbAYnZjCcNIXp1fDRzfCrkTfbuDCCnQJAYPMbEC5bhYlwW4HSYSgEOuMHCD+1gBn7hgvk+0TbT2GZTCoXYFqieHcusAyOg3aGRiVTwB5ufFwm+XVPsHTDpSlGQ43vNoPlcSgKTFquyMM3HbXE96faZyxN8vkRqpV0O+MH26oMtvwUop6g+oG2L/lSojzpwPUaeiOBSOMnGGWNtuHz6R79jxtwRDuVWd1NpRHhh9FFg+pkPN5OwSIrB1T424i3jo9esI3T//bZ+HvVKa5I/768EoYo7g4CZFXYvCz8dKZux9Ov4BUsjC5NmOIjAYZt5MQ8cVoH+tOvGt/68UOFVq8ws5AhrxtwXuA1ZvY23cQtJSVwuHsDUfCAadyr7O9vskNw+pALLJkwpUEGdNO6t3GScZbiAgyP96MpIqnjdSJ/Fc9Uo764I1Lq1MDCJoSLuIGCc5DfE4D9uZ9ALlI+DV2Tm6ehd/3pFsk0UzDn/5TnUk3/+OrwKf+w/wc5fC3UjUXhzhcsE9y5oUw65vV0tN1uhhp/AgvJHf+aIqeE6zcVWu5Gz/22rWFWIGFHQpYL5PEKpefoEGaysLCF586NWxxjnmI4l+SakO7vVYXURsoEk0UyxP41AkQDdcQZBtuYuyOkVloplxSkGgz9LxCPkkv3BTKoQjuBAW0eUZrIV5WCDECMK4FmJuEYoTZKcij5T4RdPcZzu11Na7L34vYuoEjQXPcOghYFXcgnIWdcPyUwt5BJPMM7pP7DsSAksGfyoRmloAmmRF087MGaKWEf3bsYw7cvirvO/HF0Ewrduz0megjCnQZIyQJRxmzN536144t7andfzb/df1j6ibAPW9eLhTTihPX
 HgSkIv4x
 DoiNPofG6jVyD+CvSshnOfs0EeHXOIIV3bw4CdRJyFF2ho5W54WOHoht9VGLM/WUERROIjf/jHIshMe3+LCuG5UUm45wjquxEILAArRU2uEg/Bax1cLsprSWM7vBdhTJWcM7nqasyd3tvNDvp23SCd6irZR87pGTWqdJFaINyMH0cwSHdvODUzar7fE7s3WZlnHDMJTKJxNL3eXFBBAhQQ2MtAqyRTjogl/gutiAYxdtBJmpIBFNgtp7tRP7sLuQIBoaOBpFWIpUhmVVSQIpvJqZ1tmaRHPJeeVVaDDJ1kib+JaHgj85w1nTbxfLB0PJwUkmHfB+c4nU2CWgyB4ctgyYruf2MulDzC4sBJF0vMRDWSGSTXpIb+5T9lHvyswdNeF/+qacSRHkF8XrH+Td85xI1Gz0nO6/0tT9x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 9/29/2026 11:01 AM, SJ Park wrote:
> Introduce damos_quota_goal->complement for specifying whether to use a
> complemented value of the given goal target metric.  Add the field to
> the data structure and implement essential core support.  Handle the
> flag in the quota goal commit and current quota goal metric value
> retrieval.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  include/linux/damon.h |  2 ++
>  mm/damon/core.c       | 26 +++++++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 6a29dc2ac8db..42234839ce29 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -169,6 +169,7 @@ enum damos_quota_goal_metric {
>  /**
>   * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
>   * @metric:		Metric to be used for representing the goal.
> + * @complement:		Use the complement of the metric.
>   * @target_value:	Target value of @metric to achieve with the tuning.
>   * @current_value:	Current value of @metric.
>   * @nid:		Node id.
> @@ -191,6 +192,7 @@ enum damos_quota_goal_metric {
>   */
>  struct damos_quota_goal {
>  	enum damos_quota_goal_metric metric;
> +	bool complement;
>  	unsigned long target_value;
>  	unsigned long current_value;
>  	/* metric-dependent fields */
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 5ecbea5d71e1..1ab5154511e6 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1224,6 +1224,7 @@ static int damos_commit_quota_goal(
>  	if (!src->target_value)
>  		return  -EINVAL;
>  	dst->metric = src->metric;
> +	dst->complement = src->complement;
>  	dst->target_value = src->target_value;
>  	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
>  		dst->current_value = src->current_value;
> @@ -2960,10 +2961,18 @@ static void damos_set_psi_current_val(u64 now_psi_total,
>  		struct damos_quota_goal *goal, struct damos *s)
>  {
>  	u64 last_psi_total = goal->last_psi_total;
> +	unsigned long val;
>  
>  	goal->last_psi_total = now_psi_total;
>  	if (last_psi_total != U64_MAX) {
> -		goal->current_value = now_psi_total - last_psi_total;
> +		val = now_psi_total - last_psi_total;
> +		if (goal->complement) {
> +			if (val < s->quota.reset_interval * 1000)
> +				val = s->quota.reset_interval * 1000 - val;
> +			else
> +				val = 0;
> +		}
> +		goal->current_value = val;
>  		return;
>  	}
>  	/* uninitialized last_psi_total; make no effect this round */
> @@ -3255,6 +3264,21 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  	default:
>  		break;
>  	}
> +	if (!goal->complement)
> +		return;
> +
> +	/* updte current_value to complemented value */
There is a typo there. It should be "update". Also, what is the 
purpose of this comment? It doesn't explain anything, which may
not be obvious.> +
> +	/* for user_input, users set complemented value on their own */
> +	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
> +		return;
> +	/* damos_set_psi_current_val() handles complement flag itself */
> +	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
> +		return;
> +	if (goal->current_value < 10000)
> +		goal->current_value = 10000 - goal->current_value;
> +	else
> +		goal->current_value = 0;
>  }
>  
>  /* Return the highest score since it makes schemes least aggressive */

-- 
Asier Gutierrez
Huawei


