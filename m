Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EAACCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 01:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414278E0010; Fri,  7 Nov 2025 20:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2538E0006; Fri,  7 Nov 2025 20:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2868E0010; Fri,  7 Nov 2025 20:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED6CF8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:12:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869A9140605
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:12:07 +0000 (UTC)
X-FDA: 84085663494.22.41525A0
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8877B80008
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:12:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5rSzadg;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762564325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZbaHET7zK1X93cUl1eWP2E4xGTD3LFygd8aVoi2Wrw=;
	b=jsbSSkXeio34mEyzBRJYSkwIXqNsaTVe3R4OC8/vJZkJQIEaPDoAVmVj6tF0DvTzmtijmT
	q4AH4miZO4nKw220Va8ZX2+ziIy2y1CAqnm7S4hFF+FRmvg/Vxo2QVdF1+Yv5ptfpa8QD9
	PG3Yd8JwRTA6WXDYiBi4KGAAZh5jSB0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5rSzadg;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762564325; a=rsa-sha256;
	cv=none;
	b=BeADxAFngWx/MuQdcPBKEjt8ugIlW0UQTJsOsMANhLHo6RNh8ZeMcjkjyTipTg/8t//ccU
	B4V4cZI2GY7Zup5MMPfHWOuvd74pzgjtGYlBUAFk5Q05Od2nDHHFdtRiAj/WPQqRGl1txT
	3e3v2qRJfp6u7R/kjlMhNbXwlO9t2Tc=
Date: Fri, 7 Nov 2025 17:11:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762564323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CZbaHET7zK1X93cUl1eWP2E4xGTD3LFygd8aVoi2Wrw=;
	b=I5rSzadgX52p8BgtcjjBQ1EnC0y/Iix4dKzL789+/HBp1XeHGhz7OPqARZUbg4/LwgeTaQ
	FTtFXHqsnUeZJRTbcJ2FlbVPupoPbHqRNZE4kljiXWx637jsItRXEcaKDJ8hMEil0zxa8e
	6nsY1JEVd0UfcjFkyISfEz/K9ppS+lo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-ID: <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251024022711.382238-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8877B80008
X-Stat-Signature: xxoj18e9yii38hd334q3dr6jke5h7er7
X-Rspam-User: 
X-HE-Tag: 1762564325-803550
X-HE-Meta: U2FsdGVkX186ldAFHZxp2sNKowUcXCrlXYE/Gr93if0i4/J0bEhyixLT0KwioKq9aUlwwIC4054zUDXp8vUfuxNOX6FH4eTBxlpXVtXX5VF74BK5D0uLr6y0GL7T6fXgwB/wsObNfhb+wORiCD7QGW/UHorVo9kRVGIot5gjji7pdQEzJ1xSVUBgiJOwAfgCFQGsOVHQmC08VfZTpwusHMRgLQKkr8WpFiI5X7mVJjDMdKdrGO0hYgxxODH6H2XdkA1nn9S9p+34cF2ysaf8iWuUI1LekiV3jT5wg7YEF8mWlClxQuzHL/Q/UBXpQTNBnqhXYYupkT6nvlAt2AFNnkVBBNwzkDCtLvZE6J0wnNpFPDqIvyUzorfGQQ+DxJ8piZJ1i+k72SMaznWpWzva6BwLz8FXk584YrncGGptp8bniUHgmE6iI1FU+PjYl0t+Zy9XxyW30N2/+6qGV2vJGHCMiknOKLVt5BKUhWq2Hmk5nMaLK9xypEnYxudX9lMOgeJFWoMQMDopkdFDKIGyq2xrQhJYEELJHnKt+5w4awBtkjMq0gB69/6TCSFVKmzskJgakinc02lnerLnpXs3D5CjI+GGjcT0LMdhLbFRXw5iEwrtblqAOiqLNrBm81s6ymOW1JjGfSvATcIgTetnYCeLRNIS24Jw9hq4Vs8j14KIU7lvCqJol9NHulhRQ8xGhD88jUXiVmND5WRp6G6OzvPjCkodZ2MisHw0RPkjEdV8x7a9gCXAGClwBECoDxIzRf8h9rVPM4JSF5nRft1KQ6HHQSapeXBpzwj6EMqPPlbRO8JGzH1d/ibcdOHSZvZzy/YpHIqWt6L+dtbzoAVw/nDzKO3fLqu2hzmROfpTZZZzhj0YXeKiiwUjJiXpLAVNrLlxxas5RcqSkEB6TB0Fx9Rk9l2yj/RQLPUD+wQY/T+T1yhn8WEbt2U355jLiiib8w4Emb4fcZSWrOyrGUB
 3jU/8HZh
 XpOdVGmHA28Laty99nLoMRdKbqbsGfwO02al3baQFlSGgt7g3D98FA3AX3TLbQW0GyGgROspkSqpA65MZht5S9RW4KcuHXpVSGhiTbWS8dmFc3NUCvipn1AKvpEFuws2bCnMP2+PR11cLVXFsDI11W1nzxCsDNbWurb4IqQeIn6T8RB6Dmt8Sqd20uRHt5RgpidOTqn6w92SIY+pIK9M5vFg1n8yD7SqhuzQwj/a8YqcVaWUba27coFw4a/T36v5ezDwabRZlDCozmm+6BGM+o6Kc+Qhj04/M5ZX60XrqqZRM5jfmaiuAnc0uEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:27:11AM +0800, Jiayuan Chen wrote:
> We encountered a scenario where direct memory reclaim was triggered,
> leading to increased system latency:
> 
> 1. The memory.low values set on host pods are actually quite large, some
>    pods are set to 10GB, others to 20GB, etc.
> 2. Since most pods have memory protection configured, each time kswapd is
>    woken up, if a pod's memory usage hasn't exceeded its own memory.low,
>    its memory won't be reclaimed.

Can you share the numa configuration of your system? How many nodes are
there?

> 3. When applications start up, rapidly consume memory, or experience
>    network traffic bursts, the kernel reaches steal_suitable_fallback(),
>    which sets watermark_boost and subsequently wakes kswapd.
> 4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
>    triggered by watermark_boost, the maximum priority is 10. Higher
>    priority values mean less aggressive LRU scanning, which can result in
>    no pages being reclaimed during a single scan cycle:
> 
> if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
>     raise_priority = false;

Am I understanding this correctly that watermark boost increase the
chances of this issue but it can still happen?

> 
> 5. This eventually causes pgdat->kswapd_failures to continuously
>    accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops
>    working. At this point, the system's available memory is still
>    significantly above the high watermark — it's inappropriate for kswapd
>    to stop under these conditions.
> 
> The final observable issue is that a brief period of rapid memory
> allocation causes kswapd to stop running, ultimately triggering direct
> reclaim and making the applications unresponsive.
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> 
> ---
> v1 -> v2: Do not modify memory.low handling
> https://lore.kernel.org/linux-mm/20251014081850.65379-1-jiayuan.chen@linux.dev/
> ---
>  mm/vmscan.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 92f4ca99b73c..fa8663781086 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7128,7 +7128,12 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		goto restart;
>  	}
>  
> -	if (!sc.nr_reclaimed)
> +	/*
> +	 * If the reclaim was boosted, we might still be far from the
> +	 * watermark_high at this point. We need to avoid increasing the
> +	 * failure count to prevent the kswapd thread from stopping.
> +	 */
> +	if (!sc.nr_reclaimed && !boosted)
>  		atomic_inc(&pgdat->kswapd_failures);

In general I think not incrementing the failure for boosted kswapd
iteration is right. If this issue (high protection causing kswap
failures) happen on non-boosted case, I am not sure what should be right
behavior i.e. allocators doing direct reclaim potentially below low
protection or allowing kswapd to reclaim below low. For min, it is very
clear that direct reclaimer has to reclaim as they may have to trigger
oom-kill. For low protection, I am not sure.


