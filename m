Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E1DC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE076B0095; Thu, 17 Sep 2026 10:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957186B009E; Thu, 17 Sep 2026 10:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F74D6B009F; Thu, 17 Sep 2026 10:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5787B6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:44:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C19C714036C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:44:30 +0000 (UTC)
X-FDA: 85223525100.23.B6836A0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 950771C0009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:44:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=RScLDk2o;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789656269;
	b=pgRdb0DQ5rUnqWWA7MPLsCuaspoNMKybkqpE6n/8OeqPaydsoLsYvURAIbtH1++aiJ8R+e
	1ldMzxMr2repd8iDJJqoz8J6+9bnP4N3+zMPCldTgiPIBAhstziaxH2EyGC1j/bU1D1z8M
	h0yceGuyewksq7ooD6jYt7Bz60nnuAo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=RScLDk2o;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789656269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6sH0YRnOsx9ADT5cVOZaWbkhNPDhNeBUllgAggui2w=;
	b=M8pROUNF/WAfO9qZKqBV9bkyLXgxdffo6NyWe62RTe9/zRTmxrg3bKlg0tvAwrfUKLnjJu
	1M6udWX0N87YSn6Bjr5LedrX2YPsFAyrdJKlkF0qATDE10VQQOPPq30p8Y360Jpxfu6NSE
	hfEU6oz892ktlPb4N1YgXy3THSjF/P0=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=r6sH0YRnOsx9ADT5cVOZaWbkhNPDhNeBUllgAggui2w=;
	b=RScLDk2onGX0+mDgTvLhod536XLzUT92fXxoV9S/M1qsKC+Iwo09H3jDk2nl0+PkGiJlCffn1
	ubuaGkO1Dfhlvzq6oDpmHEdXyOBEhPxdXt+1Tx7WDijYrh0Oj/kHhYwRpuVRz1hV1ima/1u60um
	dNvKth28CBCEejisxJPMl3o=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hlz6B6ZxWzHnHJt;
	Thu, 17 Sep 2026 22:44:02 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 91CFC40571;
	Thu, 17 Sep 2026 22:44:19 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 17:44:19 +0300
Message-ID: <643b7cce-cfb4-461b-9e4f-89439ee7eee3@huawei-partners.com>
Date: Thu, 17 Sep 2026 17:44:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] mm/damon/core: use mult_frac() in
 damon_feed_loop_next_input()
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260917142210.90829-1-sj@kernel.org>
 <20260917142210.90829-4-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260917142210.90829-4-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 950771C0009
X-Stat-Signature: tuhq56akhfsjmht84tc9rsjhye5ssgsu
X-Rspam-User: 
X-HE-Tag: 1789656268-466046
X-HE-Meta: U2FsdGVkX1+vTbxw47LNni65UCyS3iPeOz1vuv329nOc6VU3u4wofduL2tugrIJiilqbNDgdJW3DGpkmbN/DJGk2h2qHBFULy16+iR6YAm5a+QJRu15Bu1P5TPsM4xx2PORunoJuvAnUaBJmsc4i3AgOxcjOT0RjG6B3/sbcL0I805F6KvG7vuxPClaV2vmxBvfE4FPAdL9vtxL6StEME8Rs/d6iNQz25VGBcdZr7uFmNIZsWwGRG6S5/Jo/aTRsSxw8VUEWr66bNmxxszGUVC2R56OD+MQJo3MbfZ7ST1w53NpOT/mOA1L4KzJCHvJbHJs/TLozRnFc00ojwgX5Kjqdxxp6XdXYPs96ZtsAPTU64etUZ1BSglVVyMeY/aMZEN/wA7GMLSGC2MR2mv7Sa2JQbN6CBrvvgOHB0jupd2HMBBoPjiRwND1fWRam4hblLRFv8RnA9QOX8fmK/a8YmSGjy9U2JtWcZy2tax7QFyKBAUHz5IE2vpg5St+sWSLlicd2U+DtVfKekFiv0TgGqXyCB+/tX1gXG81PzWj7ADBQxA14hizohyX868JfrF3Bp315IIrjb5JaI+eOcxbIg9SR9KqD3bVuWwjob1b+RjsKm4mYRYnOxbt2A6P9gG2tsZLJKnQ61B5d+Ei/EAOMnUe4OwLfeNNEnTQNKPaHVaXvcBVouyQpe3ehu8VeZsHmkZ2sEoRBwH+1C29crei8uHgTsL9klpUilUaoKJCpGn2V2C4/aGEY/qh3u8wOM74ETDx2Zxg6ALVjaWZQQsFEXedcgIsK/AlRYCUmnMAxfC5p91JZvhqJn7Rkr0KaDfuFbbgyXiWn4XAxAiTo/4NGMUDREc+jyia/2x3w/oiExHlHqi1qMRlsyUxggBQhAsbphHpU/3jqu/Ju2Xo2q/a8qVpDmFGbfhswmte+g1lKsSU4LBtD0bK07MzLjx596/tUiIeIdHL85arlK69g0Md
 OVfMqzvg
 lmuMCjJazuLxzY6iSl0ofAtpn2EA4FeH4Yf6bj953e66tuxrPi4YHQ3RFTswPWdq/EJscEzhmzaS7TdaRGf4TdwrdUaiVd08aOvV/yskTYy74x/1AP0hz4pwwPBk5VUZnBQHbyHFYqcavl1tGU0mCBXlpeL/czsTAZoK7dCAYh644bxhzX64ziHBqIcn8yiw1Z4gOzD1B8e+sn6L0n32DoC8PT3m+cM+IX5lyTJ5owY3VN+y4LkJeAhbn/YlWIdTRco1nsb+ZO6K39bQHJh6zr/uOvfe9oWRAKfpLXzcrBUODIPBBC24XBT4y5f899Nd9FpM6qhaNqDdNxwRcgUp9A6R8JjG1adBqG16T3LRvVR9QnSAdqjZWbInXhqbC3IQQWiVrhyzua67gVUN3dPkYN0oRSagahwqlRKiC6oc1PIwfM83dlOokJJTVRnbvTw2WvIErre9shotHQF8/+pRptMxrz/1dSzmMHCCo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/2026 5:22 PM, SJ Park wrote:
> damon_feed_loop_next_input() does its best effort overflow protection.
> score_goal_diff is always smaller than goal (10,000).  Hence the
> calculation can be replaced to use mult_frac() without concerning the
> overflow.  Use mult_frac().
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index de46072dc1a2f..bc41ac7ecca43 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2927,11 +2927,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
>  		return min_input;
>  
>  	score_goal_diff = abs_diff(score, goal);
> -
> -	if (last_input < ULONG_MAX / score_goal_diff)
> -		compensation = last_input * score_goal_diff / goal;
> -	else
> -		compensation = last_input / goal * score_goal_diff;
> +	compensation = mult_frac(last_input, score_goal_diff, goal);
>  
>  	if (over_achieving)
>  		return max(last_input - compensation, min_input);
LGTM

Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>


-- 
Asier Gutierrez
Huawei


