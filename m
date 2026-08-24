Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70457C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B8E6B0092; Mon, 24 Aug 2026 09:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D1A6B0095; Mon, 24 Aug 2026 09:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B596B0096; Mon, 24 Aug 2026 09:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF6A6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:19:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1A58160131
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:19:47 +0000 (UTC)
X-FDA: 85136220414.26.04A8B23
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 02FE8C0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:19:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DeNCO4cd;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787577586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUP9UlMsBWRJmeASo8LmnRIcQu22MzYbbDAVky2m5Rk=;
	b=cOPDl2CmkQ2lytMU2E0Srr/3zXcH/L0fjBFrgkImJ59KCn0yCPLd6YvoqUGwlUDIxDD4eN
	6jLQVlT3YwPDD1duZsNPHk3n86RNhKZ1O+E446Qq07Qz2zpklSC2nN6IQi/dYeZu0EBK0n
	DK1MNKLE+/d+Fv06yQpVDDYCgx30sig=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DeNCO4cd;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787577586;
	b=3jBZxsHJil3QXdjvx1mbK9+DJDqxRy4pQFaofUAxxrt5HoLgGkY9CPhtVZVT5/aU0fdVQo
	3BnKbKgaMWJBuSFW7d3bV4iVSKv0VfpHeHMM6vE9+qOXSaKwcCPys00x0EGb4otIMsRbMp
	xgbJ+TGl4TszwsalY2hpYBfOBDgdKWg=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso5854117a12.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787577584; x=1788182384; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yUP9UlMsBWRJmeASo8LmnRIcQu22MzYbbDAVky2m5Rk=;
        b=DeNCO4cddjfrsOUUu2SIGGP7p6K0XivuVjSY85Buk97JTG0aEdlwLMvY8DXihAR4ON
         sKBdsFya+OCfsV9W5EKCf8YUIPIX8ykyxrfptMoau0jWtrMzSUpe/9W6jrM3B3Y9fbfI
         ac9dRTX9ozmpIM+cVzfC+YLkPq39CRj/OlU/AoJLwZB6i6g4edOxpvhV7Fg0jeLOEFK6
         bEE2ZnRXbOorpgiVLoRwH/qsM9l+pDEeO94IJg9Ac4RVoiedtzEBc3HxjmYAvXjmuM9/
         dNdrJFmXl1H50inK+O0W2Lyxr3v06LzrExBmi6NbmSJKlhMrTVBZldHqBVu48+yx4UGI
         UqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787577584; x=1788182384;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yUP9UlMsBWRJmeASo8LmnRIcQu22MzYbbDAVky2m5Rk=;
        b=bT/JEVKIep/JWIRmkZsiS8LSTeJ0Lpl5K7K+59uK+E1CR4Cc2bBFO0WFR7uDYEX1tw
         p3dty+YSrcjrNFf+fDdde92SWG/tTrDVWp8G3gZogRML/MfLGn+mo83QMQFQBL3117Fn
         VmLuHYwu1QW2oFuMzVB3h8DlaW5cWpYcsw0/lLHWDPeqEXFNNSE+5pXwfShGwScu+fKD
         I9JCF3GAvjfvwB6JgkMb8uKQq0wtPurub8aequHK/aARkppXVRlY0v23Yo0tVFJ16yPB
         vPCqv3d1t5OdUg2ZNSofNLCW7G0dWVEvcgKhbaHA1Uc7AEzPdIgSZoePCL89XCiA+LiQ
         9GcQ==
X-Forwarded-Encrypted: i=1; AHgh+RqGLIiOxXgs7JIJU1Ml4QBHOP2kx0Dp3c4ZEoyaazhAe1imjgqiMDmy+Gl1n6zS7LwOVaBGzN8spA==@kvack.org
X-Gm-Message-State: AFuF++kot49LfhWSE+xZw6XYwMA7Omolvte9+x00Ow/rmdFE5vI6tWaM
	qKLiv7DTsU/w81keqHY0N08o100emJzO+gxx8zWqDcE9BosCgN29MhVD
X-Gm-Gg: AR+sD1391sXz3zCPQ2vbF/+JUdygTsyZkNm1kYPNzStGPJRrYFZyh57654eHTBBkAaG
	+VLHgS6G9qKCvWop/dYboQ0uuQqMjPdkT38x00fMtXobbL2TnOoxkoVPGu+X+By0KqBm36lVanT
	c+caXBkveebllAEbg/yLA3g/aKJDa+AVtnvoKPmDeEUW1yxNqiKYlQHukzrn/n2g6Uj/pTplrfC
	ZHAvxUzkFjERkSgYFLyzp1kU4V+bBIhvXGsfWQ7P94QW1FVxBJs7cdtPWkc2eC8o2t7LKWIwT3a
	8JM5Ek724H2owdySH1sgeOvIW31q0zaEC4y37ZNwnwA1ixYTp050svxTeIrzXvOHiWaF+QGlHzW
	zGN2/jz0gIpouvAyu+ZhYZQ7DBq397v1GpQbL5UyVndQ6pPTjtR2gfqVxvZEfcmU/4x1vX3oup0
	cItmoMwil+RwMGY0tscZpZLOZx7Q==
X-Received: by 2002:a17:907:e901:b0:c16:769b:9838 with SMTP id a640c23a62f3a-c246a2eba8amr2906625466b.5.1787577584401;
        Mon, 24 Aug 2026 06:19:44 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249673d43bsm1191762766b.47.2026.08.24.06.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:19:43 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 24 Aug 2026 15:19:42 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: fix vmap_purge_lock livelock under memory
 pressure
Message-ID: <aoxE7rw6gru13DB5@milan>
References: <20260824095020.1225189-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824095020.1225189-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02FE8C0007
X-Stat-Signature: faa4ja9qowf9ixbq9bdde865inxey1sg
X-Rspam-User: 
X-HE-Tag: 1787577585-728696
X-HE-Meta: U2FsdGVkX1/ytZWeyj1mjFdk2o+gPFnbNm+QrnNkgTbzhR5A8mMnX2DetdYOABTtr1ab1fDZms/AuZ8Ejk7c9fm5fe+CZxhgBn/rI4Wlm9gsu/PHjoe0xs/d9vaxmN0Yj2mCX1Xum00v5YQAJEdFi5OF3RkxlJwngO7N8C3UnMep97AaXP2VmpjfY3c0VP8EUOLK2QAcMaBXB96yIcVlOVCc/dtuvy2CT5Cf6nhOqDxcqIaWK6OWT/8IcB9G/YRG128nEzlgVBPpdCgCl2s/IGWVAZgJnYKVGxRw8AoH1q7nZrmpOsLr705M3AGfWunN7sKnQcx01KFKzze3uxf6tRXrP1u55YdUODhG+49ogMNqmc9xiVqWGwccKrykO5hyi8f15Jwne+BSwAV1o4qYDWS9F+zadf/tnvcsscv2IAjtIWgHb7wKb1WYCh6WKhCQOqWop8R5eLKUUN7JfXjkOqTqbwnGZts6xpVUnCUS9wLZP4MzGmc8PUdbD0Ul5m+92wHZnQ3WIS5n+T6kpz4aAHYyCLO/bKFSf5Xl4c1x0sDLbc5Gbb3CPO6YLmpQKXVe4tavhNPco//Dp0sUVGPS14SsfCWwHQlBApLOA+pZuv2ALswr43ZUhaeM+B0H17K2hszr5fQM0VRxwmI8YJoiRhJ+ASVdAohrextITUwFii2dn1WIV58C8ejO5+TpskM3nrw/EPzslyIzFaxC3B0hqQHx6d3qIp0iMsD/SqLDkOpjcwd0qbgw5SPhuJadvXdWsBKDATqwwaMelmWrYE3mHTMsRkQSP6QCZcMcKMwRhQxxFLQLDv8Qh9sqfFZXI5SQVKbGoHbFmaGcC7L6mfXS5Wfl5LpiMTRzOEcnNFoeiou8oIFr1+2LNWfm7bojD/aQWJN8t/r2UnFBlhkiHAZDMDqV5MDzK+paskPOkcwSXIrtCrozp5Qx1V2YkfVcJw3twPhZq/Upg+HhkopbSnt
 T9JYHP/+
 Rw7Vwf9F1KJShB5Bb1+ZG2kadMfIiRKc5Ebw0OPwJE4mDvbf/+jmB0sGDgHQhr/egSHohBeoQ8Kl6PRVFDBVHgzpZ2D541WU7Vd5/m2cecjbNTuWshxnICBMPJphCSlG4vmoO5RaCQd/H8s9b3o49vnRsberoyc0nNl31FjdPGonFcFLTrXv/Wg98oJUrqwfiqu4vidFRVuMXO6aX0UojRGbyGWplsrT0fXk3zZ4nbHQi8AW42hvH3CjCYhrXMKR2NHjoM3cxUMtGUyXMpkyfludGD7v7d0XQphsoK5/Yt44950rZBDS+YvnLWoXQCcbmmkFwhnNWzVN9EOiQmhmyy3w/rgp7fmkjk8ife5klyok6Vo6qIrQeqVvS7N0I+RDdZ18jCRCinTuqX2E6A6ap0Rx+PxMJI/tkU3MSx9UD2M3jZikFoWaYeIFq5WCc1wv1knybLcWj/h2oABsda66mrqd6kzMifY6EXLaIyeDAVKHsDpTn7biOuXeoG6zIcKjZlb6nS4wSAMabKqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:50:19PM +0800, Ye Liu wrote:
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
> Two changes:
> 
> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
>    mutex_trylock().  This is a shrinker that only decays the vmap
>    pool and returns SHRINK_STOP without freeing memory; skipping a
>    decay cycle when the lock is contended is harmless and prevents
>    tasks from piling up on the mutex in the direct reclaim path.
> 
> 2. __purge_vmap_area_lazy(): purge all vmap nodes inline instead of
>    scheduling purge_vmap_node via workqueue and calling flush_work()
>    while holding vmap_purge_lock.  The workqueue dispatch + flush
>    pattern under a mutex is the deadlock trigger: if no free worker
>    threads are available (all blocked on the same lock), flush_work()
>    never returns and the lock is held indefinitely.
> 
> Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 51 +++++++++++++++++++++------------------------------
>  1 file changed, 21 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e7..41443708d22d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2358,7 +2358,6 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		bool full_pool_decay)
>  {
>  	unsigned long nr_purged_areas = 0;
> -	unsigned int nr_purge_helpers;
>  	static cpumask_t purge_nodes;
>  	unsigned int nr_purge_nodes;
>  	struct vmap_node *vn;
> @@ -2397,36 +2396,17 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  	if (nr_purge_nodes > 0) {
>  		flush_tlb_kernel_range(start, end);
>  
> -		/* One extra worker is per a lazy_max_pages() full set minus one. */
> -		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
> -		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
> -
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> -
> -			if (nr_purge_helpers > 0) {
> -				INIT_WORK(&vn->purge_work, purge_vmap_node);
> -
> -				if (cpumask_test_cpu(i, cpu_online_mask))
> -					schedule_work_on(i, &vn->purge_work);
> -				else
> -					schedule_work(&vn->purge_work);
> -
> -				nr_purge_helpers--;
> -			} else {
> -				vn->purge_work.func = NULL;
> -				purge_vmap_node(&vn->purge_work);
> -				nr_purged_areas += vn->nr_purged;
> -			}
> -		}
> -
> +		/*
> +		 * Purge all nodes inline.  Do not schedule_work() and
> +		 * flush_work() here: flush_work() while holding
> +		 * vmap_purge_lock can deadlock if the worker pool is
> +		 * starved (e.g. all workers blocked on this same lock
> +		 * in the direct reclaim path via vmap_node_shrink_scan).
> +		 */
>  		for_each_cpu(i, &purge_nodes) {
>  			vn = &vmap_nodes[i];
> -
> -			if (vn->purge_work.func) {
> -				flush_work(&vn->purge_work);
> -				nr_purged_areas += vn->nr_purged;
> -			}
> +			purge_vmap_node(&vn->purge_work);
> +			nr_purged_areas += vn->nr_purged;
>  		}
>  	}
>  
> @@ -5519,10 +5499,21 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct vmap_node *vn;
>  
> -	guard(mutex)(&vmap_purge_lock);
> +	/*
> +	 * This shrinker is invoked from direct reclaim path where memory
> +	 * pressure is already high.  Blocking on vmap_purge_lock here can
> +	 * cause a pile-up of tasks all waiting for the same mutex while
> +	 * the lock holder may itself be blocked in flush_work() waiting for
> +	 * a worker that is stuck in the same reclaim path.  Use trylock to
> +	 * avoid this; skipping a pool decay cycle is harmless.
> +	 */
> +	if (!mutex_trylock(&vmap_purge_lock))
> +		return SHRINK_STOP;
> +
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
Have you seen any report about the problem you described?

--
Uladzislau Rezki

