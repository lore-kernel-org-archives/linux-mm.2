Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F3BFD8FC1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E8D06B00BA; Thu, 26 Feb 2026 09:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1046B00BB; Thu, 26 Feb 2026 09:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECBA6B00BC; Thu, 26 Feb 2026 09:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69F046B00BA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:50:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17F7856612
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:50:24 +0000 (UTC)
X-FDA: 84486893568.16.37E5799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35C8840006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:50:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gI8JYFS2;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772117422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywC5t9QIuDAGxs74b68NUGBRG1yt/AK8MK3anoFZulM=;
	b=USU48tMhH/qqBlxNUX0a8HQwoiII9ydygIb2axLTIzlnw2x2UveEO4AtbWvmskUZr7jm3v
	qIFwkB3Sgijj9Cuf0skLEpoI+hbCqEi7iCZRdz/GRW5nJE+p7SID7/MPDaShi9Sj/rbGNE
	IHl+uC2vwwVqIOBUm3ac1WFF8ECdp88=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gI8JYFS2;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772117422; a=rsa-sha256;
	cv=none;
	b=PHpqtNmKEmNU0l8CFG9gtDK/fB2d6KDFJOT8kehnny2LOurSnbqBcw3kXU8DlFD41WNjar
	7Rh1nzJLR/OCbKDvD5UAneXJ27f02946lWE2ZN6TO+FLG3YmwZ9lcIaYoobH2Q7VioSvqp
	SmU6YJqHGOl1h1ffxPDGG0BCUJ3OonI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B417D41ACE;
	Thu, 26 Feb 2026 14:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0113C116C6;
	Thu, 26 Feb 2026 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772117420;
	bh=GK0sbKFuo5mAqtUMy66Ge5gunIW0qAF6CCoSBdhwHwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gI8JYFS2gzn78RReEOysbVYUdkvhVolNIb88Nz/sQ4k0P+M9Kh0pzoGlrKOEXk0Le
	 qywh9uBW+bX5Ca7aXe10/riYs9S6SARPpvtXzSQtBA7kzp1ITLSkbq3PiS/JOYaAKy
	 ynC2rQ2U3WCOWY3BW+b23nF3kcp/AiGwI4FdImwVU1YtqeBfl/j/sB76MB/UnKHWMR
	 wnrynwk3O1q4xo3AEfUHIP6lW6e0c382ET38WeJe06hqk+RmaHa998Ln/nZuydbmLE
	 ISZITSNfw30nB9NVJoc18eA60gSHZy0J46dQAJM9pqyuUaMOxClG3q5+CQXhHUtSgV
	 rs5V7pQNuWK2w==
Message-ID: <c6e94e2a-34ac-4515-b4df-222f2c08c992@kernel.org>
Date: Thu, 26 Feb 2026 15:50:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Marcelo Tosatti <mtosatti@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35C8840006
X-Stat-Signature: 3sp315mhxxjq48uoxzjfrygrhdhgjxtb
X-Rspam-User: 
X-HE-Tag: 1772117421-450292
X-HE-Meta: U2FsdGVkX19jVZRpDtj/VNzkAmpQFabhUpzJujuslBCrhNi1PCD1k704XM3sAwZYHELhKPVugMFfXGpblrfCrrDrEa/pAwchcikZTXmPO21t8p4DiZLQLSK/+SUiEic/4WgNTwJ10VaZy7XyxlWUzPENknhwEh0iKhpfMtjyBGN/7UjwrAKttJL90V7MzASWgMz3LWEwVKen59QlhXwpZubJb3URSINnbajlwqv136jgOK9Vu9Pjc1Jx9rclJAhmTC/IqkZb2qBa2/Mk0PcY/tAX0N1G3gFoRylL7gEouDWuvhudNFrmMu5TPr0awol9tbMNsFPTUWNR6NsV9eaR6C18R7QvvBhheuQCCXmEKGRoZspEVIZtw5RdgHD4MnStKc+EPi3BtZ6zktxPT6FPIVp89wbCyXms8DpUiSiR0pUcOywW9gCzEyMxTi6EhMxy7jakBQiODT+CMf+B9bpphzeX4rcyYSK/jDRHslr58b7e5mYXZTTbyEie40JMttU9Z/93pF1JgMYvbiuZk1tvfKeIJBoGkkDq53SpLUkwQbI153P0m8tQoLW0N0OQTA2KgdVLBQqkWBnUU1Y7PCkWmrOpOE6gpSQU03uBYKo/2ScREsu3VfxMCZdT7Tfw+hGbiAnG+QSnlQTzxQTIwuGTaQ2njbo+3VH7JHSUDADG0m0AYrzg7vmY9DHGCdz4DsN7SJgPbCALeFZ7G9UD+YltVQdVmNa85F0jYeITt9vVTeSHcpFeLntrYREkZ56Xr/Bq9Djtk3HFKJz+T4GJvyFaIkHi4Fo64GFZy0iOGPV2Kw6gNoTEW+fb3kX5FmABhx7ZElLOtMzZLeLkRwlNhgWhXantOazJRbHT0lXWjfNeW2mDaaVIETUC3CdFt6aL+34wKb0SO7YF3PWVo4Z+qw5wXWRbxA3nHCkgUi48rlJVb3tS5QjJa3XPE8fWXeeMxJQX4xEgSpU+kjAJ+sRJfO2
 ZcFqvpg8
 LP/PWpZGXyiwOT4NySq5PkC5qyTSC7Y2fwVmxsgK4EIAJOfmGBrVmxUIGOhxAbcJe/33r6jqMEL0aVMrXxPyesZE08+3F6ZMNH26UVeYI2iiMRRi1ESE/39dVU0nnbOVL4JTWrgZgylIspv08x5KVMy5iNsD8kUdDLzv8q/m3bjZuw2l/YMoqZfB2uIgVjq6T5+te7NwK8LNPf4bIFKx019FxvZHMSIyadMape0I9MDUkYOIP4xvEOrnHmiN/ZsGbLsb0vM3JRIR2G7YC9/bngDlgDig2Bbg7mvdyVtz4FFCc/OIsEJzUbAzE/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 10:42, Vlastimil Babka wrote:
> sheaf_flush_main() can be called from __pcs_replace_full_main() where
> the trylock can in theory fail, and pcs_flush_all() where it's not
> expected to and it would be actually a problem if it failed and left the
> main sheaf not flushed.

Thinking about this more, I now think it's not a theoretical issue because
on PREEMPT_RT I think pcs_flush_all() can preempt someone holding the lock
(on PREEMPT_RT it doesn't have to be an irq handler preempting a holder),
and then fail to flush the main sheaf silently.

The impact is probably limited though - if this failure to flush happens in
__kmem_cache_shutdown(), it means someone was destroying a cache while using
it, so that was already buggy. slab_mem_going_offline_callback() could be
where this matters although it's unlikely someone would do memory hotplug
together with PREEMPT_RT.

But maybe still worth tagging this as Fixes: 2d517aa09bbc ("slab: add opt-in
caching layer of percpu sheaves") and Cc stable and sending it as a hotfix.

> To make this explicit, split the function into sheaf_flush_main() (using
> local_lock()) and sheaf_try_flush_main() (using local_trylock()) where
> both call __sheaf_flush_main_batch() to flush a single batch of objects.
> This will allow lockdep to verify our assumptions.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 47 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 18c30872d196..12912b29f5bb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2844,19 +2844,19 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
>   * object pointers are moved to a on-stack array under the lock. To bound the
>   * stack usage, limit each batch to PCS_BATCH_MAX.
>   *
> - * returns true if at least partially flushed
> + * Must be called with s->cpu_sheaves->lock locked, returns with the lock
> + * unlocked.
> + *
> + * Returns how many objects are remaining to be flushed
>   */
> -static bool sheaf_flush_main(struct kmem_cache *s)
> +static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  	unsigned int batch, remaining;
>  	void *objects[PCS_BATCH_MAX];
>  	struct slab_sheaf *sheaf;
> -	bool ret = false;
>  
> -next_batch:
> -	if (!local_trylock(&s->cpu_sheaves->lock))
> -		return ret;
> +	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
>  	pcs = this_cpu_ptr(s->cpu_sheaves);
>  	sheaf = pcs->main;
> @@ -2874,10 +2874,37 @@ static bool sheaf_flush_main(struct kmem_cache *s)
>  
>  	stat_add(s, SHEAF_FLUSH, batch);
>  
> -	ret = true;
> +	return remaining;
> +}
>  
> -	if (remaining)
> -		goto next_batch;
> +static void sheaf_flush_main(struct kmem_cache *s)
> +{
> +	unsigned int remaining;
> +
> +	do {
> +		local_lock(&s->cpu_sheaves->lock);
> +
> +		remaining = __sheaf_flush_main_batch(s);
> +
> +	} while (remaining);
> +}
> +
> +/*
> + * Returns true if the main sheaf was at least partially flushed.
> + */
> +static bool sheaf_try_flush_main(struct kmem_cache *s)
> +{
> +	unsigned int remaining;
> +	bool ret = false;
> +
> +	do {
> +		if (!local_trylock(&s->cpu_sheaves->lock))
> +			return ret;
> +
> +		ret = true;
> +		remaining = __sheaf_flush_main_batch(s);
> +
> +	} while (remaining);
>  
>  	return ret;
>  }
> @@ -5685,7 +5712,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	if (put_fail)
>  		 stat(s, BARN_PUT_FAIL);
>  
> -	if (!sheaf_flush_main(s))
> +	if (!sheaf_try_flush_main(s))
>  		return NULL;
>  
>  	if (!local_trylock(&s->cpu_sheaves->lock))
> 
> ---
> base-commit: 27125df9a5d3b4cfd03bce3a8ec405a368cc9aae
> change-id: 20260211-b4-sheaf-flush-2eb99a9c8bfb
> 
> Best regards,


