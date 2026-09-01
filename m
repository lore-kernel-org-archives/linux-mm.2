Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B98C6C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB48B6B0096; Tue,  1 Sep 2026 12:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C616B0099; Tue,  1 Sep 2026 12:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D556B009B; Tue,  1 Sep 2026 12:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3516B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:51:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD9561C2163
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:51:02 +0000 (UTC)
X-FDA: 85165783164.21.8308258
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5A36A000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:51:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G+N/+dYu";
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281460;
	b=MVUq7kPcLevXvo/CPJvYe19doUfziM3WC6VlLmec9PprYV4ehAr0TX4x6gW+wafqL9n5Lo
	j5aesNiiOnLssN067t9BI1l4fX0bUIfAfM0DMNpV1m0zWPGPdyLzIt9Dj7vkR1vv/2bmK2
	V3kXpekmHaf/IUmlU6vfx+w0WRVlDNc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="G+N/+dYu";
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtqPoM0c1dC0lrkur+oQD0yCDgbYlDlCJcSGxrJXNGE=;
	b=xQWzU1p5s+VRAeOdXS3rWhDTQPQ2pbn+9ANQL6GOVTkiFHgPDmlusWsA5vs4/kyLwkoFSb
	rImphb9AcQvu3z/BOvZjHswzBX9WJBzsCuWuJPuQIlH82QaXG0LxCu72F0T9rz7l2r+jSl
	KBq4W3Dtqt7LbVIUWAeONrcReS9X2wc=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3a2e985245eso431351fa.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281459; x=1788886259; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VtqPoM0c1dC0lrkur+oQD0yCDgbYlDlCJcSGxrJXNGE=;
        b=G+N/+dYu9IWz1qQoVbkyKRlVhHsQwz6CblAYD9yJbH0zNNQgZzdLFqaDonWDJJF4sx
         dRpcnuWuJbKHMy7ZQWx1lDnH/bCZK3Rd8KaU0sMOoY5vT0VlWQOxMtLdd5mc/3BoikvX
         pRWkoUvJKuTt2bDwPVuj46SUF4uSPhk3kABmR87Rnq7/SgQbvAizMUxxcGxEFgdNF5yq
         g+5uF/8gyt/WTfrCRBMPYiocyvsDd5V4uXJud90axr+0fLO7IOI2lw5K5UZ4xB+8bNdy
         wn3jSUCPkvE6uG0R/x004YZweSgJoVwvXNCL+58SMS8KJK5FLcehTIsq16i6HBQsywrs
         adVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281459; x=1788886259;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VtqPoM0c1dC0lrkur+oQD0yCDgbYlDlCJcSGxrJXNGE=;
        b=Z69sQzJ2cSnkFYNXan6DGL4chl8Rs6EHahgZozmJmgpPpJp8oI7Hc/NjFDojshUzmJ
         mC2lhTZFngw0iHS8wXjJen68zkrtiLEIAbyOxRLOiizaEpQ15qxRbnlb+uRhr/zvHcwq
         GtfoexXmgPJf81k7ZEDiaT2ZGiD7gA+tKpo4NWpVRUVTv565UiqUlZJc9CEaao5XZhzl
         ZsY083old/0P1vfJNQFvupvr+XUJB2r1gyio6GXRpha55mFQ7yqNxNgm7hFtmMHWrl+R
         OX9z+HhVMtE3tnI8+hfD3Z5cdhWzezUHvYbA6Vtvce2wQJdgQtysBTLsI6d2+l4gQkmK
         O1Ug==
X-Forwarded-Encrypted: i=1; AKwUvByVpfktdsiOVmbxS7RNzlvXy8gvFajALHn8XL/m3/yoOSaTABrS5S6vxKFNOWsO+hGsAaFOWnce6Q==@kvack.org
X-Gm-Message-State: AFuF++mWTz+9My8O6edpqIWINMAfr/1Wc/0AWHiJmsTfido/016YuIIX
	xshUSp2NV9k8niLW1RdhBXvT1GHSGEsxSZMbJNLvTrVCL+1MXXOWB30MlExrZI3d
X-Gm-Gg: AYBFou2aFv6JZ5jr7297GPIFv6t356wOzehXW06r5VUWDxzBGO3ORIe2FrGvFbGnGJy
	GWqGFf24V5jto5UzeaZoT0/cuzKLxXrhV19xdPJGmsPUT6ufVdm2CqVJktOZ6NGkd/nWBrxm7AR
	pRXl8hl7eCy4i6REBqaFCYZ/ftU9sUWUydnkinKMshZrurCr+/TwJm2eNgzo0JeeZz2eqYcrc0K
	xLf53N5QZvKfT3SaHAglGd1YBEGIxrop1w0K4ZZXF5YP6Fv32We2vNG3P86qzMrYBD9XRm0u8UY
	IavqZOZ3fqVRYZa7chg9zbaIjwUOxpyyvv9tHcCtZuV6gngKfyS6ed+IveLHFqWyG/hx3EDF4GC
	X4e92GkaolETfpmSgNxaH4e6KK5WZHdjR9Q2+3HB245LcvcAf84TygS0F2HE8utZA1PWr97oC8G
	WRCODeGkrIh0lZ2bkL6ERKkR/yWg==
X-Received: by 2002:a17:907:c01c:b0:c21:382e:9a38 with SMTP id a640c23a62f3a-c2556c18e20mr2424645566b.2.1788281027128;
        Tue, 01 Sep 2026 09:43:47 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25ab2f9aa6sm257006166b.35.2026.09.01.09.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:43:45 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 1 Sep 2026 18:43:43 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>, Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apcAvwXe89M20mGs@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
 <apVPTt9Xw8kSgmTU@milan>
 <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
 <2e9488bb-feb6-4994-92e3-e5ef0c1ff5ec@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e9488bb-feb6-4994-92e3-e5ef0c1ff5ec@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5A36A000E
X-Stat-Signature: 6ta5j9ncyc6ywrwuag73hmykzi797nib
X-Rspam-User: 
X-HE-Tag: 1788281460-710906
X-HE-Meta: U2FsdGVkX18JnfMoA/JC4gAAGW183Gsh/vvSJcYAwYlD5GQe2BoOyRRded+3TJ0oAmo3zAEbePahgrRz9JlF61SA78sUvCmL6nUl2XswfI4lga0D5G+RJHmhbkip8l3GcL4I/glRZdXkw27AgSFFdV+s4JLTy7l3apXeTtD0gSUWMloDwQWmXYOII5yZh76EHApfsSWLFfrefhhPcmG7TDcM8RjrCgO6hfMXXCLz4M9SObRoujCouLMMPiPSPd+iHZ8d4vxRas8WKmcFujCLeL6gTrr84THjkXRdo+0/XJTTSUrbA7rMA26PvQZd8E1YW7mAdFUBapMhevQBkWBb4w7pxrnXxyjMkHBDJdQuWfxG9rqEL4sKu9vILf3VmJeLyJyzcKF0J0sVUYwssn91Ii/bIvOs7979NXR2SdWhIYCxAlD1NGktTotXTuvhYHtBny1DnhNW9AMNJrkAN7PAxLZbQ6RFkWe+SMIKlK7Ik6X4INkW7hPXL2hUQ2z8xE3h1LzDec4r4Xfl1e5SeA4XkWQxByV1sw3n9xdgGFJnazgAywZXC19ojAFNAMJAf4E5wkUeZhD2vRQm4419ndVKnXLkmNR7YTzJoG3f7Z0QzVPgFGKB6lwTz3jYGzDKWYtHyo5g9jJXZiEZ9oUDEqGZXozvbmoNnNSg/AcKvqpXoo+t6HldDDkBhG0iKA3Udd4sw1aPdKRS+9+K6IP0ok/noy7XrzCp7WqzWuURLgl8oYrBqhBzuT9sBlG6CeppMLQC4NRX7JLssoRRGAyz23bN8NWv/PM7QCXaIu3XlWC96hw8w+UQY4w7Kb7feCQEuVaoAQBuGBgP9+ThBaCRXaOzjsFJp/IFCF3BpTZ9eJVgc6mJHpEE8N6o7OIFJsgmUdmB1v7GANecMzAPy9uu3MKqk6vtfCoxdJZ7WnphGMDzDpqTatSQw5c0vf7GMb1iHYJ97aIelCptBYJ8XWNVDTY
 QecRjAjU
 ZRxg8Ll8J7mfP0A71mM33E3EXE/PUwqDWnyv3qyKMv+jVNAAajLkNGgRWtli6A01Mt0VP/pt3XaS493rMD0gor0oZIMDQ0tUqaPLuBObBDgmPLf0tlUX+VDsgSEAkxxuN0mWqmBiDva+E1+vH2nj6ROAbNCDNLxn40njsTqu3CYffP4z2tUgeE4PERipxU5WDzQ3DaJ0Lans0t9URIkTb1dt9tWP+uhiKujzyIENGu7r0AqXHnD8/QRYVTCKQF8FByR4oYo8KcfdfgDAWUEpuvKWww343wqzSJLEMY/bxGpMweNhbUACT2L0zfA1MPuHWiiT94R4qHz2p++UUiEbjTLubqWNUrt+U8eoTyFvwhFlsEreQ+jex2DEOTc6XYoCrM8y4zI6biFtjL83NKIQrkuNGqWXLMzF1M/lTu7+j1+HSjWmQS0pm58P2RzkUQKRkHfXB116s6Z7jQaETRMpcT+cUU4+TOPxT2f2fRXVaY9c2pBsXrKNgtHD+nGffZ/m1AsWJs+w0rHcgdqkxQyX71tLDQNM1MY0Ugfel4Hu85efEbIjl/80gx6XpW1MDPORYxDSyq8fMBK1OB5QHSVnC4Ye9nKekB3fFmIkX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 05:07:30PM +0800, Ye Liu wrote:
> 
> 
> 在 2026/9/1 14:22, Dev Jain 写道:
> > 
> > 
> > On 31/08/26 3:24 pm, Uladzislau Rezki wrote:
> >> On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
> >>>
> >>>
> >>> On 28/08/26 11:35 pm, Andrew Morton wrote:
> >>>> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> >>>>
> >>>>> From: Ye Liu <liuye@kylinos.cn>
> >>>>>
> >>>>> The vmap_purge_lock mutex can be held for an extended period by
> >>>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
> >>>>> purge_vmap_node workers while holding the lock.  Under memory
> >>>>> pressure, those workers may themselves be blocked in direct
> >>>>> reclaim trying to acquire the same lock via the
> >>>>> vmap_node_shrink_scan() shrinker callback, creating a circular
> >>>>> dependency that deadlocks the entire system.
> >>>>>
> >>>>> Two places acquire vmap_purge_lock from paths that can be reached
> >>>>> during direct reclaim:
> >>>>>
> >>>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
> >>>>>    mutex_trylock().  This is a shrinker that only decays the vmap
> >>>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
> >>>>>    decay cycle when the lock is contended is harmless and prevents
> >>>>>    tasks from piling up on the mutex in the direct reclaim path.
> >>>>>
> >>>>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
> >>>>>    mutex_trylock().  This is called from the vmalloc allocation
> >>>>>    overflow path; if trylock fails, another thread is already
> >>>>>    purging and the allocator's retry will find freed space.  The
> >>>>>    notifier chain provides a fallback if the retry still fails.
> >>>>>
> >>>>> Both trylock failures break the circular dependency: the lock
> >>>>> holder's flush_work() can complete because workers are no longer
> >>>>> blocked on vmap_purge_lock in the direct reclaim path.
> >>>>
> >>>> Thanks.  AI review expressed a couple of concerns:
> >>>> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
> >>>
> >>>
> >>> Sounds legit to me. Now there is no guarantee of purge being successful, and we
> >>> can get a spurious failure.
> >>>
> >>> How about using a WQ_RECLAIM workqueue:
> >>>
> >>> vmap_purge_wq = alloc_workqueue("vmap_purge",
> >>> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> >>>
> >>> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
> >>>
> >> WQ_MEM_RECLAIM makes sense but this is another patch.
> >>
> >> I copied here AI comment:
> >>>
> >>> Does replacing this blocking lock with a trylock break synchronization for
> >>> the callers?
> >>>
> >> No it does not. If someone is doing reclaim we do not wait and do not try
> >> to do it again thus fail allocation.
> >>
> >>> When vmalloc space is exhausted, alloc_vmap_area() calls
> >>> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
> >>> that free space has actually been reclaimed before looping back to retry:
> >>> mm/vmalloc.c:alloc_vmap_area() {
> >>>    ...
> >>> overflow:
> >>> 	if (!purged) {
> >>> 		reclaim_and_purge_vmap_areas();
> >>> 		purged = 1;
> >>> 		goto retry;
> >>> 	}
> >>>    ...
> >>> }
> >>> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
> >>> fails and the function returns immediately.
> >>>
> >> If reclaim is in progress and trylock fails a caller repeats only one
> >> time to retry an allocation. There is no any infinite loop.
> >>
> >>>
> >>> The allocator then retries
> >>> instantly without waiting for the concurrent purge to complete.
> >>> Because the retry fails and purged is already 1, could this cause the
> >>> allocation to abort and return a spurious vmalloc allocation failure
> >>> (-EBUSY or -ENOMEM)?
> >>>
> >> vmap space can be fragmented and not avail for 32-bit systems. For
> >> 64-bit system it is likely impossible.
> >>
> >> But, i think we can overt mutex_lock() into mutex_trylock() just only
> >> in the:
> >>
> >> static unsigned long
> >> vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >> {
> >> 	struct vmap_node *vn;
> >>
> >> 	guard(mutex)(&vmap_purge_lock);
> >> 	for_each_vmap_node(vn)
> >> 		decay_va_pool_node(vn, true);
> >>
> >> 	return SHRINK_STOP;
> >> }
> >>
> >> so the reclaim path is not blocked. It should also address an issue
> >> reported by the Ye Liu <ye.liu@linux.dev>.
> > 
> > IIUC you are suggesting mutex_trylock() only in the shrinker path. But
> > then, the following is possible no: take purge lock, try to get a
> > worker thread, worker thread is stuck in vmalloc -> alloc_vmap_area
> > -> reclaim_and_purge_vmap_areas -> take purge lock?
> > 
> > 
> 
> Personally, I lean toward the WQ_MEM_RECLAIM workqueue solution. 
> After taking a closer look at the code, I noticed a subtle but 
> potentially problematic scenario:
> 
> When drain_vmap_area_work acquires vmap_purge_lock and calls into 
> __purge_vmap_area_lazy, it may subsequently invoke queue_work/queue_work_on 
> on the same CPU's system_wq. If the newly queued work ends up waiting 
> for an available worker on that same CPU, while the current worker is
> blocked waiting for that very work to complete (via flush_work), 
> we could end up with a self-deadlock on a single CPU.
> 
> Theoretically, this seems possible. I suspect the reason we don't 
> see widespread reports of such deadlocks is that the nr_purge_helpers 
> logic limits the number of asynchronous workers; when resources are tight, 
> it falls back to synchronous execution (purge_vmap_node directly), 
> which avoids queuing additional work. 
> 
> Using a dedicated workqueue with WQ_MEM_RECLAIM would provide a clean, 
> explicit isolation—ensuring forward progress under memory pressure and 
> eliminating the risk of interfering with other subsystems' workqueues. 
> I believe this approach is more robust in the long run.
> 
> Perhaps like the code below：
> the dedicated queue eliminates the self‑deadlock risk, and the trylock 
> in the shrinker prevents recursive lock attempts from reclaim contexts.
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e7..68fc1f5acb2f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2218,6 +2218,9 @@ static unsigned long lazy_max_pages(void)
>   */
>  static DEFINE_MUTEX(vmap_purge_lock);
>  
> +/* Workqueue for lazy vmap purging; WQ_MEM_RECLAIM guarantees progress. */
> +static struct workqueue_struct *vmap_purge_wq;
> +
>  /* for per-CPU blocks */
>  static void purge_fragmented_blocks_allcpus(void);
>  
> @@ -2408,9 +2411,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>                                 INIT_WORK(&vn->purge_work, purge_vmap_node);
>  
>                                 if (cpumask_test_cpu(i, cpu_online_mask))
> -                                       schedule_work_on(i, &vn->purge_work);
> +                                       queue_work_on(i, vmap_purge_wq, &vn->purge_work);
>                                 else
> -                                       schedule_work(&vn->purge_work);
> +                                       queue_work(vmap_purge_wq, &vn->purge_work);
>  
>                                 nr_purge_helpers--;
>                         } else {
> @@ -5519,10 +5522,14 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
>         struct vmap_node *vn;
>  
> -       guard(mutex)(&vmap_purge_lock);
> +       if (!mutex_trylock(&vmap_purge_lock))
> +               return SHRINK_STOP;
> +
>         for_each_vmap_node(vn)
>                 decay_va_pool_node(vn, true);
>  
> +       mutex_unlock(&vmap_purge_lock);
> +
>         return SHRINK_STOP;
>  }
>  
> @@ -5575,6 +5582,17 @@ void __init vmalloc_init(void)
>          * Now we can initialize a free vmap space.
>          */
>         vmap_init_free_space();
> +
> +       /*
> +        * A dedicated workqueue for lazy vmap purging.  WQ_MEM_RECLAIM
> +        * reserves a rescue worker so queued purge work items are executed
> +        * even under memory pressure, when workers of the system workqueue
> +        * may be stuck in direct reclaim.
> +        */
> +       vmap_purge_wq = alloc_workqueue("vmap_purge",
> +                                       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> +       WARN_ON(!vmap_purge_wq);
> +
>         vmap_initialized = true;
> 
I agree. We should have it and it should be as separate patch, i.e.
split vmap_node_shrink_scan() and dedicated per-cpu WQs per vmap drain.

--
Uladzislau Rezki

