Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF0FCA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 01:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E428E0019; Tue,  2 Sep 2025 21:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665AA8E0001; Tue,  2 Sep 2025 21:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2C88E0019; Tue,  2 Sep 2025 21:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4729B8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:40:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F219FB9879
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:40:03 +0000 (UTC)
X-FDA: 83846233086.29.5DE595A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2288840005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:40:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VWWYQ1yQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756863602; a=rsa-sha256;
	cv=none;
	b=wnUMdH7K7AedBDTNHzGGgCVKA2O/kL/EWAGnIy03lx9MLlR3PXt2oeD9dedmV5c4MC7qgT
	JDY73NH6DGR1z6+txuVdn0E3XJ6yn2SspxQo6dZ+MSVXvs5Eq9JEsBWZnhMOW0dd/JkxVn
	jIWdf8dmQxKC32JWBdWIWCQauG9tywI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VWWYQ1yQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756863602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBFnrycFy90OytnzxFhcHJdc8o4eGnhelby35FOE5H4=;
	b=1tLm9k+aYh0gmCxEiajwAQYqHgT71gqnLxWkECYBvvF2UkJZyDM+om3ZmW7WsyHyhy44Lm
	SqXAdL+nTR8i+GTdTen+n6pwMskmTzW8YXDyUFVMwnlE/tDPHOqYyLxdoyweC9QoOGl4Nc
	YdIxH1d1MVT401jadZ8kCylHygWDZPQ=
Message-ID: <06c7a189-7ea2-4005-a1f2-12608fb2931e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756863599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nBFnrycFy90OytnzxFhcHJdc8o4eGnhelby35FOE5H4=;
	b=VWWYQ1yQyLGa2x64akE37pTTcmFwUyCWMES7oeh7Gzd3h2W5kN4HNNW9NJXIN2+H4P9G+V
	N24WCyDrr7uCsLuT5sQvcY6Ibpe5BWJ6fYvJsn6v5FH3kvQDPjyv6FeVDxPYgMf7p9HSsK
	3jP4FvdKFqz8D+3uytEsLaEmU+kaBWs=
Date: Wed, 3 Sep 2025 09:39:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in
 show_free_areas
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 SeongJae Park <sj@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2288840005
X-Stat-Signature: 5rsnaa8thtu5irdghogiumchgzju6fsx
X-HE-Tag: 1756863601-262622
X-HE-Meta: U2FsdGVkX1+iAyWsxHR/ooujDGKcmJp6YzpubtRaaoOl+VQuqYMO4eM54yPnG0NveQS9E9tCS1AaxnoEqvp8u+jHp8bFh+hfIM/Gcqgy4XJK1QCZBik6xO7U3YSb7L3QLVYQBLdwmR1QONQrdm5HDtNuR0JuuS612Re2OX6/5bYOlU9ixPOh7RgLNefNujP+odwUt00XGhBJN6ioMznU801SmAHP8ZhyuAFQPP5zn7SEtcfRXXlKEvtx+Q5zpD+V1txoSBMJeWIaj3dH/PRrQCXNw9z8pBQEuo+2NaKmgxwh4iEVtw25QrYXlOKUj+spMYE+4VyAwVbOLA4JkBo67RsmbP1WhOcINASdpCJ3iGBpJCmz7HGwTvkI3dQXSbpj8Aww1kfzHn5QoEuOPgjFKgGok2jgTxig3iCAVNqXYtrjW9ft0RcEntF/LQkC5AsWu1Os9IdfEhEvMQ/YpWtD/0ZzQmPMjjVAgaHP51UKoiJEhWqopwHrXuC/ugQJokLVAkfYAWBQfGm7Om4zkW/4zzQigNDLZOBkza6TyI5J/PxMampMoyv2wFQEXZtRxWqvHaNKMgd5AH5SbvmWAzmab+3tYBGppRmmn3w8LCKHl69HH8Dg2FUJK73crheDVLW2GH66t0N/6LYSt/uj5Ud4EkzS1QPTlpMEoCkkyIIm0FBb7OEfI9goWGwWfmVhXQSGJNUugOwG/VWikVfI9F6/7d3F92jp4YQ35HCml0J8udOEIfdDUzoBEVNS4X9sJBXT2aWhCfkfcw22Ntvz2Wd7b3vq0Z67s9eseOmifT8fhCcxqTBrgkFI2mLa83GINLGiASswJDKSoeW/7UTAdW4fls8cuM0fjgT2d4Fr0I0W7ZAQycQ1nTQUTh1aVtMse8k5o7AOY5SYIoH52FMfxnyUE/QA3hHFP8OFEFR1lztggD8G+Yt2jjdfFuDOvdW+qFX3gO4woSxm+BXG1GeKBsk
 4NmQdUgf
 y9fLR5um/A1oLBr4Jty2z5D7VDsuQeCtSAa2cBen80aLzNNN9pJogajEdSouPpYOrTJAbVH1RCFTK0T45TNwarO/Mz6+9tOFURGPsjQ6tOZQasvwgK6npe+yNoOTTF7pPZ9i/VxUdGYSIZlpO8ob96y6kyG5Iix9+FxYDhpW88JW2RM+lb1nUzjv8Jy2CGIBbMMF+ptbF4m3mUescSqWfnIDD560xf6g7RGzgxgUoaWbyTWxqTBBrif/4CbiIvfRpbZtROuQqj5IrlFOxq48SjcIqWYzCqZ8U0YRjjoDw1PkcbjSpyyRw64mfqMddqj8OS9FO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/2 20:49, Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
> 
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks!

> ---
> v2:
> - fix build when CONFIG_ZSMALLOC is not enabled
> ---
>   mm/show_mem.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91c1f68d824b03eaea8 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>   			" inactive_file:%lukB"
>   			" unevictable:%lukB"
>   			" writepending:%lukB"
> +			" zspages:%lukB"
>   			" present:%lukB"
>   			" managed:%lukB"
>   			" mlocked:%lukB"
> @@ -332,6 +333,11 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>   			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>   			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>   			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +#if IS_ENABLED(CONFIG_ZSMALLOC)
> +			K(zone_page_state(zone, NR_ZSPAGES)),
> +#else
> +			0UL,
> +#endif
>   			K(zone->present_pages),
>   			K(zone_managed_pages(zone)),
>   			K(zone_page_state(zone, NR_MLOCK)),
> 
> ---
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> change-id: 20250902-show_mem_zspages-d090ea0bd1d4
> 
> Best regards,

