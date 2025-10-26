Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36B4CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 04:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAFD8E015B; Sun, 26 Oct 2025 00:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C288E0150; Sun, 26 Oct 2025 00:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D88E8E015B; Sun, 26 Oct 2025 00:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD438E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:40:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F54357AFB
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:40:11 +0000 (UTC)
X-FDA: 84039013422.02.1E490D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8C1840002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:40:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rr7R4bHX;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761453610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwnggeDrRRxWrTTkg/x4YtttAQlkg46zBaU4nkhGQec=;
	b=5Wd73bZK2p0zvac602xQ082JhqkbCQa/WPTu1hUJ/cqWDR15JGmfXqPSpCrbvG1UldaGiz
	YOpiWki+JvLw1wp6mE7kNuTXRy38iYzXyT/f9ezx9hAOQbhIG0y8hl5VVs+G5YppcODBR+
	/etj4EyqydCRtnc4LtE36q5D3jY05yw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761453610; a=rsa-sha256;
	cv=none;
	b=kv1OgBx/0nG72t+odHT6aOso5xzNsSNwUd12srMpB9RC9e2Y5P/S1GcGmkA9N0xP0Tzh/W
	3sE2054PMQPUd5QO52huJNl88XeURqgI+lz1ddsEkQ7dn74ihRteNxr4mltv0dpeYObBnc
	Sc/d4oY6ahRb6ApRcvxdqTonVIpLs2c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rr7R4bHX;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE1E543C5F;
	Sun, 26 Oct 2025 04:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55075C4CEE7;
	Sun, 26 Oct 2025 04:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761453608;
	bh=FDldBYNu9OOsuTnGhGPzDkHwWzpYPvYf6kAIzN+sI+w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rr7R4bHXfFhKR8vYgEqIjFNpfqFk6wc50HcffRyvSgULZ8KV6qM/7H+xOPpj0sQ5d
	 DO92mqomuCDC25HUD4JEm6vlX0QMqeZUtWRytw3C9t6v5O5FtQm4aeOS0zMLrr9JSI
	 x1mczdh0HdlJRxLCOV8ZRTofVv4YEyXVYrBJkcyE=
Date: Sat, 25 Oct 2025 21:40:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-Id: <20251025214007.736d659ee266a416c40aa6e5@linux-foundation.org>
In-Reply-To: <20251024022711.382238-1-jiayuan.chen@linux.dev>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8C1840002
X-Rspamd-Server: rspam02
X-Stat-Signature: tywofnbmmpqwmcfopjyqc5mtkrfr5tyr
X-HE-Tag: 1761453609-353645
X-HE-Meta: U2FsdGVkX1+BOivJdzGWOIz+S9CKCghWqyfaw0ag0kEonWaAVBKfIwvy+nAplUh3Ll6PCgCifMtp5TTu2SSk4NoALFLcPrT5eJGuo49y6iBwKYtldPhYaE4Jod3r+1aQzixidM7Fcckz5rSiXmEXfi7kcyY21NaUUD2ZvsDBOY2pqLP9iJA4UPlVVrr+UVeuTvsMJ64Fwyeke1SGHSLOxPIzzEg6c5IiNt18v/2rac16xX0GVYc1v5tXWoF0fwTczDUc1t6E9WYmHbK1FrTncpyjmuoyNzGgB8hg3EQjVl8st0qVN7VYXJBSsRecz5SjVOrpaJvS6OVidSyChQ5qy0FPUDcB5wvmtlt4iBPuL1UXTN0bbjRGtfjHao0+szXYUang4JPdAu5/WHeFdyJO9tdWMpQgquBIwh5oJ2ryhYlVByQBM/gsvKsZDJY0d4WbGwfWz8KWpen7GW/77VoElDvmkGIklyNVbeAhxzztL1P0bFf0MPzbmytBW2yyRoZ4s6RA+jJtOzje5bqVaaIkfikzdqfyuVB2wOlGJFuWCH3pvQgF9FWKLIMG2B19zVYrxWqmVk2AEtflsdly5X6I9y+X4PqFlOvYOap/wwVASM4wi4LamwU+RHa52oFqBKcq2gi5HnnLJFZAuwtimEcF9FlD5Xa3jps6edAn5iKGyksFEGm4dfvgVdJw0LoeENsIJczYAfFtjDpZkBBob4zxlzJhgRaWWGjM2S+Hs6vsXMPInHXPqHe5xnSz2VzWaqusqxo4fG4Hl5X4UpnfgNzxPIc8+T/EEKxePrxtKq+b3EstuCQkbQ0OgVdzS2VwzEUc6fxlLfspjiNdMU4xjVqNLGjvBD8rf4LETrLq07+cJMAPdItkQ6LSzF/ErjOvRjwV49o61b+UphIFthk8vbuNcdZMCR30iyFmft+SKf+AHW9jel611yCR8kkCsQV1oUWa2CoOKNhAo21BL+GNL8n
 uA5XIWqh
 B4UGe3LkNzGzRFK+jdtwaT1JDkLwJ+yy9SkUoaBNdK0rXTGv/0DZc83yARXxfrUNzYuG2Vk+DWh2HLkaTPqdykE0efJWDM+03tFlsYgAfrilsc08GWCb9uUaKBDwvYkmit1qfD9EDvYu96nZdFxP8zpQDaE1E5Zec09HvOz9L/N1RNwIxpEC6CiZwA9zynE5Y8tTm5TkxdsGoTTKCd9ZwCohUS0MqjFCNXcgNXJEuuojsAb7wvsomEOimz/GdiX+JbQ0IaKRokkaj3HXygUY9nrTE2etv6YYEYwgh5Lkmh7yYYN7Msyw88c5XiOSQ3majLtbY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 10:27:11 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> We encountered a scenario where direct memory reclaim was triggered,
> leading to increased system latency:

Who is "we", if I may ask?

> 1. The memory.low values set on host pods are actually quite large, some
>    pods are set to 10GB, others to 20GB, etc.
> 2. Since most pods have memory protection configured, each time kswapd is
>    woken up, if a pod's memory usage hasn't exceeded its own memory.low,
>    its memory won't be reclaimed.
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

This logic appears to be at least eight years old.  Can you suggest why
this issue is being observed after so much time?

>
> ...
>
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
>  

Thanks, I'll toss it in for testing and shall await reviewer input
before proceeding further.

