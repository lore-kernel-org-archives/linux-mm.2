Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0448CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189946B008C; Tue,  2 Jun 2026 16:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13A276B0092; Tue,  2 Jun 2026 16:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078BC6B0093; Tue,  2 Jun 2026 16:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F06C46B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:37:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95CB1140128
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:37:10 +0000 (UTC)
X-FDA: 84836132220.03.48F1C4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA4FC120003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:37:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="syh/dB1E";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780432629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i6QVlrk9KIwFEZhpsKIC890QBmDvw0SsLedgmaGYs4=;
	b=MM6vbn9A+8OXylkV2wLh9bmIGjqR6Rhwg6FOF9uQloX9X+C1hNBZDbvs8rZ8xZMj52cF+i
	hAgrY9d+ouy94z9kUNC52fZs40yNs4jYEQEg53O91SNSFdBnXcDPSu5HMu2T/9Q828pU3c
	gnWSNeFp6gB/e1c2PE5aIbzeQQ78WZ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780432629;
	b=RhaTk7ZcaJbUus+pbttkVmtNYPj3G1PHa+yG5EPFiMQx6acTY6NXmfi2/m8gyctuE1MH7I
	JpGOzM6HddSPpvkc4ghutwMO5Bw6955YOsgpzuc1bv/lL4FfUMg6Yt9PGoE4OtbzaMCagM
	JyXl4150sLPj/fhzEoo+5FATQay9XgQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="syh/dB1E";
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0658343AAC;
	Tue,  2 Jun 2026 20:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152EB1F00893;
	Tue,  2 Jun 2026 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780432627;
	bh=+i6QVlrk9KIwFEZhpsKIC890QBmDvw0SsLedgmaGYs4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=syh/dB1EW+9SWFgHZbUvo/EUL4RkLrCLodacuueVZmydHJsnt91C8Iw4O01J/tcJ1
	 yp+YEy/RYVdEnLv1TC3ckLEQpOKlgNf8WjYIVSlvgaeKES+5ITABh6XGCz5sBgmo1p
	 K7V4uTlNEL7gKItw1AKMDTl5LEmtliP6m7TSpWRg=
Date: Tue, 2 Jun 2026 13:37:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, usama.arif@linux.dev, kas@kernel.org,
 vbabka@kernel.org, ryncsn@gmail.com, zaslonko@linux.ibm.com,
 gor@linux.ibm.com, wangkefeng.wang@huawei.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner
 <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Message-Id: <20260602133706.d737a82858d1cf89870521b1@linux-foundation.org>
In-Reply-To: <20260602043453.67597-1-lance.yang@linux.dev>
References: <20260602043453.67597-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA4FC120003
X-Rspam-User: 
X-Stat-Signature: tptpuoii3d1nsmg8ituxrp1xg6jdsohh
X-Rspamd-Server: rspam08
X-HE-Tag: 1780432628-867924
X-HE-Meta: U2FsdGVkX1/Z6t3SpO8UXiF17eaZHuRBqjbT5nCGYvN5fxsz6xqbIoyaofHLyOBZ72VF1trsiBL6OTccogluyiSDDr8ZlWj4QjROYY8UHf/x7yirs6hoUfPjA0usr5GmECFl+kMclI99sRxoVe1GH3HMWZtWuSVZEeSjhvZZqGLpyVeNf/nv3Nlj6NGk/0/5CwszW0OyGeG+HV6OvxjRnMtlZCW2eNcodcl+gAKty7u+nUcpwT04Zyld9WntZPVdt/ov1ePoz8TewSiwLLXkmva0qoN3i1coLFwFq351TmnKONd/oWQbtWEqVPD0zDNv4QDJ2begYW2fgAqtKlhP02qAkk3UK9X/5b/4Mz9NL4Xdjx6+8zFfh43sS7S7OIocYC/DYOr4VolFSV8jSEz+GCyqXidtXJ3cXiG4FsjJQs9d1cKar3Fq94kFHWRgt9LKj9NDHcwW+CxFXY6U7TfNKDavyVj2wwde3oDXM+ZR30QYQzw0C21vlRfpjHpjwQOLivWgzkHlwtL8ojB8qYshPRk7JZOmIZ038rdE4QcEUngEt8NuK9ChMb9edGBnAbd9K1whTFQzyjTHosrp28qTVsdKGSDpItOtBvj8BtdO6pWg44sbMWUlwPG0Cn6jEjYwtTHUAoZ56AWSK7sA+ByEkJz/bBh+KLDeqpae5M75QJ6jcKRRk5jmhoGt1B6rSHt24iNLb380XID0GhXFG/y0VkiSWfBGGZQboBr9qDZAWfXNZVtUd4pKIJpddhVh1DslqD2i7OCKK+fpNnswAacUs2VntUbW+eLVJY6lH2LuR/VTrnZTGtXiD6+Jlg46gFtciaUUgbdQr6G6izzBe42ufgRmu2XQ/qaPv9hGVAJpa6a6w0W6f7kv3EwxJEeUkLbkTJCzYE4oy9DECntyAOMI7bzDLQQZJWUkHJ5RV/kO9x4t+XBslKWmg7ZRw9CLBpfZ+rTUoOaOr2HudPblmFs
 +eE50yRt
 2ZaeNzTUf8vaIGc3b6jaJSEcgopWK5uWZuqUhEHvw4ha84jvfka3LWN4sy1YX3D3bJidhQC4pJBZDSPoXDF33wf5x3QHqgBP5dYcfIIE4BqXJlnphor8eBflKys2Ww6RRCwaHbNiU4Ckb+RTJJUUdyL0G/ewx9TJiXKXKnlOgHR67VJTtwk6hnVHy8NBHER0493no2lZV0Spc/BSaClr1lc8NQRFBqVWECEiZupPnMhD8Z9PRHy07RLITa53AQrrnNAou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Jun 2026 12:34:53 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> deferred_split_count() returns the raw list_lru count. When the per-memcg,
> per-node list is empty, that count is 0.
> 
> That skips scanning, but it does not tell memcg reclaim that the shrinker
> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
> count callback reports SHRINK_EMPTY.
> 
> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
> cleared once the queue has drained.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/huge_memory.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 72f6caf0fec6..62d598290c3b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  static unsigned long deferred_split_count(struct shrinker *shrink,
>  		struct shrink_control *sc)
>  {
> -	return list_lru_shrink_count(&deferred_split_lru, sc);
> +	unsigned long count;
> +
> +	count = list_lru_shrink_count(&deferred_split_lru, sc);
> +	return count ?: SHRINK_EMPTY;
>  }
>  
>  static bool thp_underused(struct folio *folio)

Should this be handled as a fix against hannes's "mm: switch deferred
split shrinker to list_lru"?

