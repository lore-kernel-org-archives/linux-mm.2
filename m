Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BDE606B0A1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKXpz5BQ
Received: by kanga.kvack.org (Postfix)
	id 226986B05B2; Thu, 12 Nov 2026 09:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE4C6B05CF; Thu, 12 Nov 2026 09:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114106B05D1; Thu, 12 Nov 2026 09:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3A476B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:30:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77FF31C3E0A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:30:38 +0000 (UTC)
X-FDA: 85426702956.16.C1F500C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DEB5C100010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:30:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKXpz5BQ;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsmy0r2PiQc6pLBgGT2iVgxiMmcutgitiTqzWpJ1o5Q=;
	b=OQQq9+7n04sUHwTf8ZkZyK9EARs2BMbLGX7b/POzBcjbFMEH2/75vUj2mCp2Gq2Xcxfy/V
	0va7RB/nkrMURNb7SICR2keepNYE65JU3qCOkVQXjMq2HtAp9iUvZqRZcfd2XXDCM3R07o
	0va2vC8grCKj22jSRQT7s3PrNJ9e+Fs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493837;
	b=TQxCHql1CGJ0oJAQ1Mc2qxTueAm9w4DKjBiTFNtj5AwqwyJIGomQVYAULnGNbSYXR456bM
	B0QmC7FeGSm23sLWs8s0KGYZwl0DhecbSy4beJnvKn0I8SWSNfwIt6+8qCgz7cAqedLE2A
	+nzOftTqGPLMqtgQPLk3OEAAVmS+4pQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iKXpz5BQ;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 547C9611F4;
	Thu, 12 Nov 2026 14:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF411F00A05;
	Thu, 12 Nov 2026 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493836;
	bh=gsmy0r2PiQc6pLBgGT2iVgxiMmcutgitiTqzWpJ1o5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iKXpz5BQspSTB/yVdyil9C8T9ubHWY8dy7Fu6HvyNLXCWgAFgZHlou8L1dRh1Zs75
	 www38WX9HcC1KcjqWybnFDKl7yzmVBKK6cUPmp8Em6U8Ui/7b/3EPj8H1BV+l+kBGY
	 vrhmK64tjy1wZk6jq1l7MtzWiGJvZLg6rtA3+mhY45dfu0YFjMfSHXp0Q6cum6PX5T
	 yduq9ExJuohOhP8GXdZXpwItvJCZ44kgZcBnejO6MgeVYRY3gdF/g5wAxccms0lITo
	 5Ld9jDkL6I+Hbfusrq/seuR5n0AT+URmssp/mgtRG7vGAz9wtH/ZacSq0i1OJu3inY
	 A/ZYRCXukx7bQ==
Date: Thu, 12 Nov 2026 14:30:34 +0000
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock
 fails
Message-ID: <avXL3ZGyyiQpv4vG@thinkstation>
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DEB5C100010
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: syk36x6y6zxf35gzgh7545o7qs3axmfg
X-Rspam-User: 
X-HE-Tag: 1794493836-348387
X-HE-Meta: U2FsdGVkX1966ZFhRKsVEpZf6gzRNEAkOzv5gHRFUgLieLIUGYUNbJ93t6XdUVgR/v2q12o7U4kbL/fn9anCSi8TB78xlSmpB2YN/3P9qr1MULAJnQ6Hbac0QqPgnOCRc/31fTOn3VUbFhk8yxflV+vxZUR6q1/FKIYFZuOJOL3825ZTTYei+F+g4lxmUU76lpKlwmPka2n4xNvHdKvHWVRAJAUMdn9SCGznJghLdMKt0rS+O1totFsAhTQZPfSta1fQvGvaqTpor39eR+yfaumg22MMr/qhECeRiKS3FuT1nkxFQvTSOAkYnk+3ZcEb0sX3mktMUA/EsKPfpdIIkJuMhBnkA/pmRELdaslQ+3sfkAjovmHWO1yNKb0ATEV4YEYWN1ijhm0430qH77nSgcX1I7AyIPLXLfMRyPlqw8wbewxOaWv2JzO0qKZ2udV3XjrJQBTJUOEhPu0cizS2coW/Kjdjh1SrMYEF81Y+/hsUrsq+xiMnKG7AnFdep2z7Lzzlp6leZvy7RdKpL/5r6HoTjOWKzNah+QRLkykwgMTkeRSFl4ok2x4hdQxgPWPEFyOnuYkK8lzn9eqUJUk4Wzo1VJRM8OuorPSKUk3x/4lKUxA4inoIscYOIY4H2faCltn0dNQC6TbNGjCtBFIJUi3dns6bTUxDalbjQQjWQ1YuIxUBFWRbx9hOCB+Z2yuAgOcSKAM9BjH/0iwgMxA11P+q27HzK9W6+c0p9UTxkm7R5awQJUj8EhpDQnUT7rQgdEwEUK8Q+2EDuDKwtGv1JO6bcH+hZ75XeNGBaGz9K8mVoPka01K4Wb0mJUB4nYk2BC+OLa1Ze2APgEIfIMynUHMizXtiBYOXvDM34tKCkYIUjuDqnp5wuHUGTspS+DQ7TLRdbA/PzYAXG7j45GYYJhl0PXsrVGpzdcz+80iBNOMSXOrNNDVcpvGd/u3V+TJoT0NJulgJC6xEGiRxScW
 NEaUtdMQ
 GeikoauomL1qDl+qT6A8ulomeIVXSoH0mWRBHQV8pjILEwJXlyZg4FIDddZf8jgEIQj/4NH8STeC4V2zvy/SIWqPjBwcLw3E+EGrKTxQrexkA7FQLataAIMqfJGXU4YPjE+jfmbcr1hgQiLS2EpWv1TlH6RnreFmPpNkXae9H0/TandigF8A+IVM6+etQKX5y8pWuUBubPU5rt5imFdk9RiSJaabiQ3Qky7lHceZhTpP8gOMCBdD837e0eW8nrjSBRuczj31vqCmB82HtIR2KQxAntIs8UvyTP9PVko+XcE3OG4iJJufeyRPbjRg5pr9BfFFf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 05:32:20PM -0800, Shakeel Butt wrote:
> When interrupt code, such as an RCU callback in softirq, runs on top of
> a task that holds the obj stock lock, its trylock fails and the bytes go
> to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
> using the objcg keeps it in its stock, so it can grow without limit.
> 
> Users see memory.current and the "kernel" field of memory.stat keep
> growing while the cgroup's real usage does not. With memory.high or
> memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
> for memory it does not use. The counter is 32-bit, so after 4 GiB it
> wraps, and those 4 GiB stay charged to the cgroup and its ancestors
> until reboot, even after the cgroup is removed.
> 
> Fix it by uncharging the whole pages in nr_charged_bytes whenever the
> trylock fails.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: stable@vger.kernel.org
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f5f567f7d4a9..091401cecf39 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3553,6 +3553,8 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>  	int i, slot = -1, empty_slot = -1;
>  
>  	if (!stock) {
> +		nr_bytes += atomic_read(&objcg->nr_charged_bytes)
> +			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
>  		nr_pages = nr_bytes >> PAGE_SHIFT;
>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
> -- 
> 2.53.0-Meta

-- 
Cheers,
Harry / Hyeonggon

