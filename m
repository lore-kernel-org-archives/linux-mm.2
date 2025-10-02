Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26905CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 02:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657858E0008; Wed,  1 Oct 2025 22:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608348E0002; Wed,  1 Oct 2025 22:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D798E0008; Wed,  1 Oct 2025 22:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF4E8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:00:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7F971DE89C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:00:50 +0000 (UTC)
X-FDA: 83951520660.08.7698679
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB63A100012
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 02:00:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oSCc68e7;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759370449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HMd5BXDmBs6kaRh+x8jnIISHs12jMw6ZyMyiwHHdes=;
	b=SL/01Z7NFKLncwBXYG23nzwzjOUDqmVdYQrOStsG0H06p+vOt7aA3EYIYEpo1tZFlv8IY8
	pShA4U9CfODtKgo+ixA13R5yOlS/HI8Zs3OuXI2wCuJLkLC6s5Fipdu3EpsQAsS3r9XLNd
	IHYoTri3ElpNYUL+608WV+ahmcESm+c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oSCc68e7;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759370449; a=rsa-sha256;
	cv=none;
	b=KtKDjuahvMuZL8AQF0ujMn3DFd3u44V0xePs9SpFjng6BqPmLirjZ18ozmJS15iwwgcqLj
	wq8mxVT6oiBJFIv3wXY380T3omu45Y4TzAEluV2HZ1f+m6F7ASV2q37SzZwc9lCcPex7bb
	sOPi83LDLPDUfQV782YFuvXmyn2F9kE=
Message-ID: <7afdf764-35f4-47fb-9a26-14aba34ec1f2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759370446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7HMd5BXDmBs6kaRh+x8jnIISHs12jMw6ZyMyiwHHdes=;
	b=oSCc68e7KGmydUHYLfzlMlHBIAB4Zar/wunLVZUs1nwRE6om5Qp6TZA53LAGcD78L3yI8B
	MQS8sAfupFVYWVGc9FjaIyLZYCAdoSc2ue8ptzYT/+VobyO1RKblwn2ipDYYJwdurH8aME
	IFYwSd9O0YJgQgB5plCjN9bgun3DBNc=
Date: Thu, 2 Oct 2025 10:00:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm/page_owner: simplify zone iteration logic in
 init_early_allocated_pages()
To: Hu Song <husong@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250930092153.843109-1-husong@kylinos.cn>
 <20250930092153.843109-2-husong@kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20250930092153.843109-2-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DB63A100012
X-Rspamd-Server: rspam05
X-Stat-Signature: dwrgxywabxkxgbu65wgskcuqsx57qykf
X-Rspam-User: 
X-HE-Tag: 1759370448-139153
X-HE-Meta: U2FsdGVkX1+bdvTPM+lhS4dJOybBRE+pbJBRoPsGL1wxQ39nxTiIy2R7Oj6B4HVlyzjrZjRUQuWnlGM23C55dvZDmgZLX9DdHddUPUwboWRIYM20kJPbIsl84rKBmjLE0y2x74EWIQx11ZxfnNBKXap8SLcYe2avsaASdcXJ7lwzWGDXVTq7V2AAgx3T4qx9O9hzjCVidG93oL62uI01lDfeu9xN7LeNui/heVO6Ms9jZ/RhY0qurY83eohT+qxcYR7JOyqt2ZrANae4hEZlCiYwrx+cEMtPgGHF1SvurSMTXPw5tyYFEOAz5+6EtcMfU4KNd5DJAxhD/z6cuHL0kCVP48+6iAvBPNq9g76cmBtWlheDihQtcZTA1ZSeGdEw4d445ytunWIJmF9qOgUJ7Tz0WTyVK0juXT30h7ggIm92Z7cDmZP72GZaGKLnnJr2V/rOovBrMtFUY2KO3YBbcBhf2UB1hv8rdhHm+5sO3TF9ZjI7flj93hOQxanyM3k4q5eKMo+f3ZQUX8fYLW1INDB7j0jrxNlX/dqxCYtqX58309UpCuNnN+00yEPSKpkSyf9E1MZ7wDCLtTolwLe2PhxicDI+4FBsI2dLiWLqQ6LHH8V2IShd7MQIAN8UoUZQVED6llr9+xs12F6GUsvkMI89x9INwGDKyoLWKIaDt6EW7W22B2Q2RjR+FE6ZG51sioQzOc9OFoJxpYgyuKxijcVVF0AYOmSyImaPuotPVmiHk645r/w/KDBXS0b/+SeKQhswtAnOM2SelbM22Z2HDnG1coiyzd6Js7ZrOpsLuAkJxosG3SZiBqJjMtaIJaFiIFCCpkmTsrvfQ5veyA5FYsGsR73yF0T4CN5ZMIb2AF4jeqTR/EDVUZ6HYYrJjQBMnIJQDuA8AqAgFugJUsHsRJLOr2/GP2I/t+WuJr5Z+L4lVbJhmhFal43eji6EApAEbq2FcMxO0j6yIHxnaNO
 kSU/OPmG
 acyGJ2NmUJIRNCjdo3l8wai42turngVxn0c8Oi58DAaybrkiL33zioda7uR3C43PdZlHNhbRMVmmOGUtA7ovSDebEXMs3kPHixjZWjL0BDUFUxWyN74d4F0Jms6COSwnpzBqnB3psXTvaFncJNBf3iVZabI3QxF3t9J6ytddo98uIPcvqMG8FGIavfi6ieDp0H1TyepxPUu4c3RK98ClufR1ONYiAyHnmvrjg6/uwaQYi5hPu8InU8M8WABcVzFuWtX1VqD8nRYC0wSBbFdikJnfryQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/9/30 17:21, Hu Song 写道:
> From: Song Hu <husong@kylinos.cn>
>
> The current implementation uses nested loops: first iterating over all
> online nodes, then over zones within each node. This can be simplified
> by using the for_each_populated_zone() macro which directly iterates
> through all populated zones.
>
> This change:
> 1. Removes the intermediate init_zones_in_node() function
> 2. Simplifies init_early_allocated_pages() to use direct zone iteration
> 3. Updates init_pages_in_zone() to take only zone parameter and access
>    node_id via zone->zone_pgdat
>
> The functionality remains identical, but the code is cleaner and more
> maintainable.
>
> Signed-off-by: Song Hu <husong@kylinos.cn>


Reviewed-by: Ye Liu <liuye@kylinos.cn>

> ---
>  mm/page_owner.c | 23 +++++------------------
>  1 file changed, 5 insertions(+), 18 deletions(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index bb88b72b6062..b170b27d87a1 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -757,7 +757,7 @@ static loff_t lseek_page_owner(struct file *file, loff_t offset, int orig)
>  	return file->f_pos;
>  }
>  
> -static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
> +static void init_pages_in_zone(struct zone *zone)
>  {
>  	unsigned long pfn = zone->zone_start_pfn;
>  	unsigned long end_pfn = zone_end_pfn(zone);
> @@ -824,28 +824,15 @@ static void init_pages_in_zone(pg_data_t *pgdat, struct zone *zone)
>  	}
>  
>  	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
> -		pgdat->node_id, zone->name, count);
> -}
> -
> -static void init_zones_in_node(pg_data_t *pgdat)
> -{
> -	struct zone *zone;
> -	struct zone *node_zones = pgdat->node_zones;
> -
> -	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
> -		if (!populated_zone(zone))
> -			continue;
> -
> -		init_pages_in_zone(pgdat, zone);
> -	}
> +		zone->zone_pgdat->node_id, zone->name, count);
>  }
>  
>  static void init_early_allocated_pages(void)
>  {
> -	pg_data_t *pgdat;
> +	struct zone *zone;
>  
> -	for_each_online_pgdat(pgdat)
> -		init_zones_in_node(pgdat);
> +	for_each_populated_zone(zone)
> +		init_pages_in_zone(zone);
>  }
>  
>  static const struct file_operations page_owner_fops = {

-- 
Thanks,
Ye Liu


