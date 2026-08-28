Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72442C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7307B6B008C; Fri, 28 Aug 2026 12:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0AC6B0092; Fri, 28 Aug 2026 12:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0316B0095; Fri, 28 Aug 2026 12:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C72E6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:54:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD931A3D69
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:54:24 +0000 (UTC)
X-FDA: 85151276448.05.BE24688
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id E998FC0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:54:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TXp5KVgW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787936062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZc1WWxRZ8hTjRwH7hstNkGifi5usT3ZTkYTcQBOSfg=;
	b=LJshI29XvdSzcOpEmJ8wdOqQIEymjBuxh1dc5DDJkYsenfEc5d8hKuBYq4na2BtGvFndnY
	M8jEqlH/VuM+5uKzjVzyxKKnItSpCW82AQTQ5o2OYNFwjRzUeDzU6NsmuwaeCISeO4c2yF
	WTcJYVdUNb0WyEfvRMGLz25R3+ZzD8o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TXp5KVgW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787936062;
	b=FHvdAve4159rlKefWWfe5MziopMC9qlcao1y1E++YeSD2ZxqeuoOW2ef7rI2wdOODiZN5e
	vbX+sjkTqUbF0ZYYSl6TLb3b5mE7mp7nK5BDgJQOZGRvMPTN2rUX2bNuhZsDUPPcdoL8cM
	At+jmTmuwYYK8YqezO3rFnppJfUGta4=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c250c6a6a9aso203286266b.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787936061; x=1788540861; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PZc1WWxRZ8hTjRwH7hstNkGifi5usT3ZTkYTcQBOSfg=;
        b=TXp5KVgWwvL+gyOQFq0HiNVjbWCG34/J1Ub+Vd7W+M4r6ZJVzMY1bMKKHRvN1VmErZ
         NMywm5uSOnvKEevK2wLOv3FCuO7zGF0H3ppdnlfTTkDyg7VUtmOKx+qxKPJ5UTStQ4B4
         9+hMfCuSWpc2Jzs9t6NKoFEvKEd3cfhpJWPldC3s9uyYXL1A2qdqV+Lw/7Auf4byu0qW
         Hbmg0S+NAxZmZ0lMk1x8ZNkTmyXX1OnA7qKCj4ZZq11a9ft9R2whCEvNcTBS8HQ1Ms5L
         P5ZQZYT1Ycuvs3/uYtF2b0kn9BHW5hMrUO5W2/7T1xRtstLyiXV+jyzPYdjx62dVdyIh
         IBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787936061; x=1788540861;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PZc1WWxRZ8hTjRwH7hstNkGifi5usT3ZTkYTcQBOSfg=;
        b=jLKn/N2FrfevSeYoK1RB2E9tA3U3lQ5AwQ2J8NOW1TcUbC95O1sNNRAc2L6gFouQBg
         l7F4Sz/ro7x6ProSZ8Uzg95403Man0jxJUZM1/bMOf4o44IivA3IHwbVazJ4IeWSqKnL
         NIe9IHsoNpVBHtR+ZpgSdrBZa9ynJmpeT8dmYEJhbEUPEk8nDgEH9doG8kTSlTVsXT0I
         fnwKj0pB52ssdGWI43i3HxPHddiW9V1tKB/5iTC1CqeBLIUnX0RBgjVYYzozVem5NHAM
         Lkwrf9CBCj3vpdM/GtfzWOiRH7qqeC4RmmqN9OzL4kPsMNEqbL0eViKcFeGSrem3IWSq
         B0jw==
X-Forwarded-Encrypted: i=1; AHgh+RpUCCvkJT+FFKoG3zbFg/DG7MNZrnFZiJgdkJejhd5I86NKcgXt+wZH9NoDU3ILzKnYbiYQckB+uw==@kvack.org
X-Gm-Message-State: AFuF++l1lnYjMY7bJd7BS63Zsha5zyIGJh6ALi62gj2386hg+33Nnd1x
	OKiiqXWfKikUqIDWUoIoqro8s6EQQAEONz7XaFmeSCYyUSzRWiE/pL6o
X-Gm-Gg: AR+sD13H02ok9vQJoUBhUgahtnbT2S0tvJTCUnEu4htdjeHwrLiL8NEfsbMmaYnW2mV
	O2bb9azcGI/G2l4+qqccd/BP9tapZzcovSkwbWgdD1lfOAUD87PP3sPwpXjUS2uJp6TdPiQfQxk
	q1uoQwUcrdueq6FgoiWwQ/qp+/6tcO7I5nQE+xa5vbxpHF4lxJ8OIuIOFrIODjgZNoWxqVMn4bM
	2WiVqY2EeesY7X9L8HaYfDiP3na5AeLsjoRxdY6n+SYHJQT23Mxu+m4ZkzSO7OrZ6k3nkvE50yx
	hWH4qFzzmBRdpqmi0UzmeRnRr4ewn3Vk/UtPt7yWEnlZl3F5FqVJYEM45cAXDevdLtdWubPRdiT
	qpUBmF+ZGEQTXzYb4inxtOPmNjvkTUpKRSLDwJPbyBBKehT4Ye4KRa2uzBjD4Z+tu5U9cM4eZ03
	UOokpk4S/fuNhVT/XNid3b2tHGcw==
X-Received: by 2002:a17:907:1c90:b0:c24:d6f0:1223 with SMTP id a640c23a62f3a-c2557012418mr630435366b.12.1787936061168;
        Fri, 28 Aug 2026 09:54:21 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255ee0b23esm102793266b.2.2026.08.28.09.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 09:54:20 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 28 Aug 2026 18:54:18 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Ye Liu <liuye@kylinos.cn>,
	Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apG9OjDrFygvb4Yo@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828091753.299295-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: s39g7ew8f4zakw88ezun1tufk3mkmeni
X-Rspamd-Queue-Id: E998FC0002
X-HE-Tag: 1787936062-186736
X-HE-Meta: U2FsdGVkX1+FmMMy0TorGfVw41mxUKU2qjmADNyABYVnsU+F/KG/DC4HGdeJ9YX/i2vm5UjAUWYC3bVBGaWR3W76TfSt+SenWbIpyEVaLQ+4envKJF1Vack+3uFCS4tYTaOPh9i5typbjwFo09fvSnc/Rt8+sShu+TEICbfi1DaxgDzYxkHULCQbLuaI9yd99ASwMoHW0eVyZSaNag/vmEXIRXDWqIvY5n9dAUVzVVMg/g+2Od+cBLZda79iuMYBWfQdksk9sEnVK28ZLdGoGdCh8YYSCTqG05Nv+X/SCgubVmCsXyZ0hlOz2hIJ5NyOtVf2yizRsmmOKu2z6+GrAYqPDxHZX0CgfY6a3bdLj91RUEGa2RylIhaWId6mJKZv4WGUToGpmXg3IYCHqZJ7sKafYA4g92JPXnu4WLgXM9KJog7+kISzC1p/0velRN4jOmNy1kggqDGcGTwWYYwazFWz7dwL03q6BO696VYofJ6BsdtiIMJ/EcsQyuW9HbGpj+AahyVb4j0Cf2r7yCn4oWr91abU36sIlzHZ4GD9pdTPB+299jiSFeFbNmkR7qwvTduHSeoRo8M/AaelAER0LeayGkbbxMxqXDyjFBHS+fYGe9MU8U/xj45oaVUKmGMKYNMiSs9fQ2MLWLxOW5J9ImreKwEccsLkEhPd8u9HAOkZnv075CdQaxHj6TcYQq+8vivOzhQxAffp6Oxmbi57Yql4j0nlPCw76k72pszckHYtr3aPDv+Y3Gfl627rorwIs7Vny09tdwfBf+aUD5v+Uf1htW8Kap4BQjrwRZbUEYNh+usdBEHRR3NYdx1YbWTEojao03bPIAZGxB7P95VFgojAZ5YhVlk3kVpsoFCwgg9fQOc02nwe71DW8zrhiG7mYBaD1yoTs4Ft+9zDwEonOFt0yuweWSAxt++jCALocY5POBmiyx9uhmYNYO5nCupY0zVVqy21hK8V9ylhCT6
 pZpXZ5b2
 5KQA4rHTLIMHdEQJRhnqkRrKJZNXZzeuqnYuWnuWD1z6dvaAB1QJXrctdOit02PrGrf3Ool6TZ3v0KgGHps58RERg7ecvCObbLNThJtxnfS0QeK4PePH3uD2Uhp49Ic6pkGGCMILs3aafn0UJ3SXAjUEtQBXhgXRf60Qr2+75kEWRfzItX6sMoBuzE63UUyPN6i650VIlPlpFTSZ6b3/YJvpuB71d8E4QluMKUApWpeJhNg3r6bnUHKZDn9zWET4m+4K4f03JCQr8FW3YmSl1Q+YuRdSsDzSGVi1dKwSoVwrp/mozlXVGUYon8DHjM4X4qlPGagOL6rvYm01xEXCRuIggSNyhTO3+2ezeAgIsowdxcOsueJ1CdFF+uJkc13qYaqdxZEoJUyVj+M5z9Tgn9rNbKZKDB8liE5NfCgIMLoyjsA8rHV9NyKKSRKBcip1ljak5XivW4riZz5S/MCeZp9c5No56blGZCvwLJgyc38m6Tfw/VbcXKnax0L3zavVjZAuaGQd+8oEOsaw4tFH5dsxpvpu/+sbOwy+X5LmNwC2i9C8RaKceOLg+NXkWh6ma+9pXOv3tALYt00LvOF5H8LdFtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 05:17:53PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The vmap_purge_lock mutex can be held for an extended period by
> __purge_vmap_area_lazy() which calls flush_work() to wait for
> purge_vmap_node workers while holding the lock.  Under memory
> pressure, those workers may themselves be blocked in direct
> reclaim trying to acquire the same lock via the
> vmap_node_shrink_scan() shrinker callback, creating a circular
> dependency that deadlocks the entire system.
> 
> Two places acquire vmap_purge_lock from paths that can be reached
> during direct reclaim:
> 
> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
>    mutex_trylock().  This is a shrinker that only decays the vmap
>    pool and returns SHRINK_STOP without freeing memory; skipping a
>    decay cycle when the lock is contended is harmless and prevents
>    tasks from piling up on the mutex in the direct reclaim path.
> 
> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
>    mutex_trylock().  This is called from the vmalloc allocation
>    overflow path; if trylock fails, another thread is already
>    purging and the allocator's retry will find freed space.  The
>    notifier chain provides a fallback if the retry still fails.
> 
> Both trylock failures break the circular dependency: the lock
> holder's flush_work() can complete because workers are no longer
> blocked on vmap_purge_lock in the direct reclaim path.
> 
> Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
> Suggested-by: Uladzislau Rezki <urezki@gmail.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
> v2:
>  - Use mutex_trylock instead of mutex_lock to acquire vmap_purge_lock,
>    as suggested by Uladzislau Rezki and Dev Jain.
>  - Link: https://lore.kernel.org/all/20260824095020.1225189-1-ye.liu@linux.dev/
>  mm/vmalloc.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e7..e5c68b795a3e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2440,7 +2440,8 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  static void reclaim_and_purge_vmap_areas(void)
>  
>  {
> -	mutex_lock(&vmap_purge_lock);
> +	if (!mutex_trylock(&vmap_purge_lock))
> +		return;
>  	purge_fragmented_blocks_allcpus();
>  	__purge_vmap_area_lazy(ULONG_MAX, 0, true);
>  	mutex_unlock(&vmap_purge_lock);
> @@ -5519,10 +5520,20 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct vmap_node *vn;
>  
> -	guard(mutex)(&vmap_purge_lock);
> +	/*
> +	 * This shrinker is invoked from direct reclaim where memory
> +	 * pressure is already high.  Blocking on vmap_purge_lock here
> +	 * can deadlock the system: the lock holder may be blocked in
> +	 * flush_work() waiting for a worker that is stuck in this same
> +	 * reclaim path trying to acquire the same lock.  Use trylock
> +	 * to avoid this; skipping a pool decay cycle is harmless.
> +	 */
> +	if (!mutex_trylock(&vmap_purge_lock))
> +		return SHRINK_STOP;
>  	for_each_vmap_node(vn)
>  		decay_va_pool_node(vn, true);
>  
> +	mutex_unlock(&vmap_purge_lock);
>  	return SHRINK_STOP;
>  }
>  
> -- 
> 2.25.1
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

