Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10293C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE776B0092; Thu, 17 Sep 2026 10:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F466B0093; Thu, 17 Sep 2026 10:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166E46B0095; Thu, 17 Sep 2026 10:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E62886B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:44:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FEA41203B5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:44:08 +0000 (UTC)
X-FDA: 85223524176.10.073B180
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 178BE20009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:44:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=ENdtwNl6;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789656246;
	b=YqKpWMYpODzf6lGnVaeM1pVdSyrlacT/Pgv3rTI+PGEZBLdIZLkfLI976Eu1foBhGiAZK8
	OAJKrm3R2qAh1CYqRILd/MT15Tg+/Wi43ZCOj+cNNItHQFCl5rDvCXmCkyF4PmUxFeNZKZ
	EdWWam6fHZLB79JB0H1KWV6kOKpUQf0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=ENdtwNl6;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789656246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eN/fpov6PZomGcIc0BH4XcakhyNs65CVNspNQIZgj8o=;
	b=bTpXdVr5IcSzJzQ9VxKecpsOnA8SUN2EYeaarg+Odl4aiLBONqxg4w4Ke3B8bvqU9mJ+VJ
	a9LUqN6hLWj9zm2x5QQgqQIipGHsXQJ2rO9txEPTv8i39NjD+9MMpbhJYK3kYLp+ZsBIpx
	AWV5BUhVmXcdIYc1VyLA5mwJrSxTTM0=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eN/fpov6PZomGcIc0BH4XcakhyNs65CVNspNQIZgj8o=;
	b=ENdtwNl6Of5Mw57sPbnSS8ZNCnLxCM4htviuYxG42735NSvgDOlnelUkYKOqaV9TwdNxNHVpf
	ehmU7WThGPKyGJaIPk/w+1QivaLeXDOILENbiPsoiyLb56CnfK5Sb0exEagBIiM/gI8F1iIDm7i
	nPdZDok57MBhsDPOdmIV/Lo=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hlz543pkvzJ46fh;
	Thu, 17 Sep 2026 22:43:04 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D35484058E;
	Thu, 17 Sep 2026 22:44:00 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 17:44:00 +0300
Message-ID: <e07def52-eb4b-4c98-96ba-0a9f263d45ab@huawei-partners.com>
Date: Thu, 17 Sep 2026 17:43:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] mm/damon/core: use abs_diff() in
 damon_feed_loop_next_input()
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260917142210.90829-1-sj@kernel.org>
 <20260917142210.90829-3-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260917142210.90829-3-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 178BE20009
X-Stat-Signature: 8whtuoe9wwzgtnynte9uwquriysipr5u
X-HE-Tag: 1789656245-140949
X-HE-Meta: U2FsdGVkX1/DVVTBJJz9E1VczsMzUTwwcmlxw0v7jF1txYS6DddsRk4BhpPmmmhsy7aYJ5JqRPQsG0XtOorblrB2yq1Y9cGcJnQyJzBVd0iZrJAgCJDJE+PUJhtv+/qcgpVfQUYyItf1Ck168P0vl3Vdd6YHQoUwj94EaATIMd6r81AfHLmB+tkxPQxk90zRO+QWb3KKF6FKwDhj1nyidgAatBpkByxy/+5kx2hFqOsEZFflE7eCGuWwTe3gXlaqX9fOY5AL5pU6YEdmIEE2TshqxShzELVuUL+CEu8LfAW3Q74jjzO+3rGdboc8zH9UEZfc/ALL3kl/5yTE1lUb4dh6beykSHX9r00tirHwNv39+bxfazSXN+puzP8OXo6/55HUcy32ergcR02F4pCkOk/xFZOylqRdzAwgKRXRU4kDik8U3mCdIIaOG5UCxj0uUQsG2s1PPMOseiGAC8EwffVFpqCSjDT37i/hPf2ad6XxRRSHP6q/5CGTQp67iYUR2pCuFL3jrnnpiZZWPI6cxvVnRe0aIXoM3h81y48g2OOo28roWde3P8a78ZF+aC9BR1aVPSXclL2ADkSvolaVvi37opw2S2Io4E1P1Ud3Dvnf9DqJuddJzONJqEitto3mGOVj1SM2tujExeAm0HqUvmugfViXylnf/ikAVbC9GbFXrRrg+afzM7QbWeySty0/3gjO2d+429KH2k8zM33R6LUDlfP14zZOOK62WdgEhT7zksFc4Hl5TBEEH8uGBgmO+Kxba1pLKT663ozuMeVFKAXcDpCwPV2rXO1zX58US+4Y1TuRNzDSzg5IB2d8lLeLVOy3NuzF3eprOqMFtaD8/j0BvzOaw1Ecn7mGJJoWis3IRp+64PcK4K2UlwJL/5W9IcJd4sArsPk/JQa/gIPdyc40/67Y8DvTiLSY5caaLi57Jwnb7pP0RsZH6Ln7p3Fhh7IVKacFLOrugErxH/3
 addinh5w
 QYmpe0dJ9dYQlOUwLNb+C3BVK3JL4E90wHUULZ8ttlpGiOd9+OWyOJrH3trOqBtvj1NfXqvOHmoWBf0X6LtP4cpuCSUSjAORb/IbTjmDBIWN6a1nhLxs0Q4OsAIimYnhzocsBP7NFRHJLluc71oFwiMQEoaWtkWrhoF40MP4G21rHRt+en07XyfQAgvuMjzovxLospjKwoeyxSvHxkbytbno6hoOocvHqvRlC6ALT0ZjbL7EazCwAMwP5pE0otHyKFGsPx7Xlt2OP4E48S+Vz5IWu6744fdw/sDeNEge4Gz8oFsg2fmUxgrp36wKgH27t9pI/wwEf6ky8NXnRTEQ4az23C8aJq+FnQZwXwYGC65FyROIcnj189aV7VtYfB3hHBKYmLghE1UHzS6bUK3QGJQVyaNTFrWFETgmegHeHUG4h+rk+dNdmrnj4avITIiQTLS7eAN9CdmeuOv7Ktx3SuB677pfWM8QPDvXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/2026 5:22 PM, SJ Park wrote:
> damon_feed_loop_next_input() is open-coding absolute diff calculation
> instead of the dedicated helper, abs_diff(), for no good reason.  Use
> the dedicated helper.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 444c97c184027..de46072dc1a2f 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2926,10 +2926,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
>  	if (score >= goal * 2)
>  		return min_input;
>  
> -	if (over_achieving)
> -		score_goal_diff = score - goal;
> -	else
> -		score_goal_diff = goal - score;
> +	score_goal_diff = abs_diff(score, goal);
>  
>  	if (last_input < ULONG_MAX / score_goal_diff)
>  		compensation = last_input * score_goal_diff / goal;
LGTM

Reviewed-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
-- 
Asier Gutierrez
Huawei


