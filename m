Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938A2C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7A86B0095; Thu,  3 Sep 2026 05:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9891F6B0096; Thu,  3 Sep 2026 05:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878206B0099; Thu,  3 Sep 2026 05:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62F3D6B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:11:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD71BC0179
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:11:03 +0000 (UTC)
X-FDA: 85171881606.04.84919B8
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB33F20004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:11:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oqo1MfCM;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dsu+vk43VpSBv82gBLNeaPR8X7xILN5rCQXYDm2G8Ts=;
	b=vxfnUDCgmjI/iqY4jAzauRUEq2JY7K0GcqQ/DxjtQ6qzCRteMePK1yNH6a96WTBpm89dRL
	F5cJszStn0F7HQgLjDDh/CVNxA23i+i+ZXWfVwcdIuISRnsFpYWI3YhlrvbbhLZoEU2DQZ
	3vuc/3/koP7gdmNnJvNqZh9M4dUf1Xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426661;
	b=pLE+/7vct08W0A6K97cwEvNliIWM66eGmYjAaWVZmBV9p+xPDfN1G+jnW73ONCueMcd6xf
	8x/UPMvtdU/xBp8aJj+BPjctR9evAJBuw7jmJ3iYs8I54k5WeLp5DPWtuElehOUYQfXJv+
	6DWrUxuKVGSETzUB6xFRBEn/w0GEIlQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oqo1MfCM;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c169ae1cb26so141203166b.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 02:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788426660; x=1789031460; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dsu+vk43VpSBv82gBLNeaPR8X7xILN5rCQXYDm2G8Ts=;
        b=Oqo1MfCM2kYYQr6jbiLX1Dnq81RBsgSPCyrhJ2aoNRJ9+xAhpUsVb5atVrmHTDd9gU
         sHnBysijOJDtLhQRuIgbwGNTgsFn2p25hVxtq+LlXdqs1NrjySqc4+n/FWZ1xnFfU3bj
         fSE9Q8pHEQ+9OMrAOC36ht0AEsfGX1k1E3Mpb3vEzigcYvti8T9C1zb6Q9Kw23PWYGSU
         2FaLbJRaVuyF2Q6ilsM1tTTfWwbeSt+lDcGqx46C9TOiYexY3RtS9g6y+2KfSss+LHBX
         rfCSy24WZWQHDlpWPKKlJIL0GLefeDrQnYoqga3D4/uKcPxTR1buabLODosLKri12e+V
         WxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788426660; x=1789031460;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Dsu+vk43VpSBv82gBLNeaPR8X7xILN5rCQXYDm2G8Ts=;
        b=BULyosVUHlTY80P8t36AhOXPfPRp/N9wRbLA0aszfKZebtrKWWkMy2bdidKMXGprwS
         fmfBbJGGm7gnOcd40Z5PdtyfrnM/dTmQtMXjKGONLubl9PwnuRPNk4J9+HuDOpi1BR99
         PUOv340F0LbyIk5Z/Lv9k3Kl0/+xhwpxm4MZ+QwgPCicJt627Z+OUiPxsnK8KixXyG5z
         IgHIspLiqfA00lOaUK2crXtrEVgpoUul0Vt7zQc+lKoGX0K2Z4nz0gcvZtawP9dOgdbn
         XSS2SYkHKuu1xFcs7eFSvbQdAWkdV85tVTddKe5n2hThmhDqHGaJmkIAIK1VC+MWm/GW
         m6Rg==
X-Forwarded-Encrypted: i=1; AKwUvBwnMNREXvhkXWXLZFP0bHLKfGMWJZRakjXvOQlmuEOAkiXLToVkaw7X9LY/3wjGA80vN3Pzia8wZg==@kvack.org
X-Gm-Message-State: AFuF++nIpfaInBfGUKFxUZ/DezedUKAMVbIDLutj966OboBsB838yB1g
	FCBgjfsG8aYL7gJWC5hC7yfGMIHjGZ0kNZyPZ9Skl50w5jzg2SvOvNjh
X-Gm-Gg: AYBFou3a5rU1YxWIFylBFC0CmadgXv9xJWx1eqTb4v8gnYWjDKIi5P3OdF3dm9iXA8Z
	IWINpogdmADWPhpjdLHfU85Y0FQDJiAGlaMnwMp/LQoQ4AH/+Zbg57Fah15c2t3ceXUZwFUo3zM
	ESnKHNSlKomqlQMJn9JouatcnVP2QmwejE72eLEJRqw6GRxWsHah1/433yBZ7qA8AgnSoi9bNKJ
	TPUDr5oOO27AnWpElfgb4gWsyGi52furNtxBI1BcVkt/G+p7tFTjFjf7tSUGMj+j/IpQJRBRt3C
	Z894XQ1AEfUk4ilKuoTRWBBO8IiRw2EXZpD0BmNP4ZSNkUWVhIBWzetbTZZYhO8xmuokrW3R8+E
	NK2gg8b3pzTxQnak7JXkA2Dxcvtjrqnoss95ubHq7VuZEiyCMZLhMKjSvDPwFanX5W93XeMz5lk
	4GDYi384bk5WDOiT1sTfiewnL1vw==
X-Received: by 2002:a17:907:944a:b0:c25:f7dc:2d4 with SMTP id a640c23a62f3a-c25f7dc092amr91549966b.21.1788426659790;
        Thu, 03 Sep 2026 02:10:59 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f932bf5sm2116425a12.14.2026.09.03.02.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 02:10:59 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 3 Sep 2026 11:10:57 +0200
To: Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <ye.liu@linux.dev>, Ye Liu <liuye@kylinos.cn>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apk5oYoBQ1EDc0u9@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
 <apVPTt9Xw8kSgmTU@milan>
 <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
 <2e9488bb-feb6-4994-92e3-e5ef0c1ff5ec@linux.dev>
 <apcAvwXe89M20mGs@milan>
 <apcEh4iuYa6_47TJ@milan>
 <c88d035a-cf81-4431-bc28-bb09878e09d7@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c88d035a-cf81-4431-bc28-bb09878e09d7@arm.com>
X-Stat-Signature: q8rcsu6sw835dog49ugmj8fxa94x3zsb
X-Rspamd-Queue-Id: BB33F20004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788426661-932929
X-HE-Meta: U2FsdGVkX1/sibLKCRoFet47vXzG1QKSCtz9roctXcbOj2KB/+4xrULIalMtmQehvAqlHBwgFI09IXegouWSgjTauFRu3v+ryBgN4TDeDMKQV3x8VtHFsdR623CtIUOwgC+bWBvby7l4aLVJz4qCJHggRxdgEvmiKKD2PAItw42S2yr9TeRt5ZO6X/8l4rIyHVYBl4j/sNVPYsWFApFBymwMnDfwdQePFk5tmCOIcC4Ocz9ekmMxacthipiZ/vYT1Nj4tEdyk21sh+2vmtcI4hkJfhb+lnqOzfzQ1MugZ488pS1us+Os3THUg7yQtcN9+3o8ekLU7+ZjyiYcibPQ/yzfuOgan8hZsGEE35M6Y3bsBtWX4I17Yehh8Rief8E+tVx4bmlFF65o0wGKf+HeRyw2yk2BIWaEO3RUWldfPQSWPZZO8rGEI4AISItfLWz0FnQizfdhli4rAiKAPsKJtujKAjc1BGHhLXfpAszTIF55gEoAjcj543om+e4uDHOSWpu4XAoDAkN0qoIrkrfSDaml2AQHlTYWriBI8/FSvKYcOS5grpxfUWJm6eoXXyCzct5GI8jbDQSMb1DOzHyZ6jqjofDh+ysl2SR1o5yDkoYxi3weOoSXb5DgS7p0TTzcClMu3gYytfGxYqv7JHdCXnuIIIQnC789La7q87pEcL1jUeyI8fdUbkzWnCix/AnLhJMrJxKoeARD2WvGso1s+gn8SGqJi7kzOfhLpJ7YTVvncd1v0InB7AgfrJxmbwlRE3mzdrlSZfd9PxP+OsPhyk42i2v9a8FbpHBW8Xp54gryr3Aux5ewali4w15PWOketKt0C5WfPXrHOWyRcwtGGItG6VZZGHP7RWVB3/Qe6qNZ1patnlrH4gPey//Fsmw0XXsjngy3/MsjkwOKGwtzP7zIr2iuBzT/ZTcI5/ZuDFmKaIwZoiopFDBoJ7LcCbcHm0h585dc+yXjsoBo352
 xVPUA2So
 PP7NeGdeix4OIc3+OGLgAw5vxGzjtmV3u8xvw8jwAFfwssGOL8kCwjSSayMqZdP0HKsSU5QHv22O4rSS5mAf71hZ3QezCSibml0PuK3GhgUM1FBhE7WPsEbDGwOt3sRGRXjulxLNHhE1Ow5Q1rm+ad8hBV1zF3aoKw3MqkqWk6M9MjLg40vcP9HQyKjEunY15H0pbl2WMTVPewBI6WsMG/Pa45LjXjEZCErjbdxELx5Tue23qPbIKLxlmVPqr/R69Dtg7NAQUGbWrfcYrtycgz5C73rbkcGyMYW5l2y+jzm4GEOEy7ilVb/RVzu5THmhI3cBanALUu3Qr9nehoEDgWnGh6WXTUoZVPUxk9VVbGUm3eRn3C5kmVLoliu7XdrO595DtD1YtS0RlI8Y5siyClcIK1dunZ5zcuuSE8hrvapMCaABidygsh9LmBSRRA15Z9r3f48N0qyRf9bKqh18iq+CAB07LGPJX4FeQVTCi1Ygevwb7ZeS13hUPuaXeHbDfIHp9sWDzXEHgwghzU/DiHwQ1F79Ab8qr4G59ra99PY+3ZNwmZIZ/2hZtmkUMfr2bCuQRne1jyJc/b84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 10:00:57AM +0530, Dev Jain wrote:
> 
> 
> On 01/09/26 10:29 pm, Uladzislau Rezki wrote:
> > On Tue, Sep 01, 2026 at 06:43:43PM +0200, Uladzislau Rezki wrote:
> >> On Tue, Sep 01, 2026 at 05:07:30PM +0800, Ye Liu wrote:
> >>>
> >>>
> >>> 在 2026/9/1 14:22, Dev Jain 写道:
> >>>>
> >>>>
> >>>> On 31/08/26 3:24 pm, Uladzislau Rezki wrote:
> >>>>> On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 28/08/26 11:35 pm, Andrew Morton wrote:
> >>>>>>> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> >>>>>>>
> >>>>>>>> From: Ye Liu <liuye@kylinos.cn>
> >>>>>>>>
> >>>>>>>> The vmap_purge_lock mutex can be held for an extended period by
> >>>>>>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
> >>>>>>>> purge_vmap_node workers while holding the lock.  Under memory
> >>>>>>>> pressure, those workers may themselves be blocked in direct
> >>>>>>>> reclaim trying to acquire the same lock via the
> >>>>>>>> vmap_node_shrink_scan() shrinker callback, creating a circular
> >>>>>>>> dependency that deadlocks the entire system.
> >>>>>>>>
> >>>>>>>> Two places acquire vmap_purge_lock from paths that can be reached
> >>>>>>>> during direct reclaim:
> >>>>>>>>
> >>>>>>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
> >>>>>>>>    mutex_trylock().  This is a shrinker that only decays the vmap
> >>>>>>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
> >>>>>>>>    decay cycle when the lock is contended is harmless and prevents
> >>>>>>>>    tasks from piling up on the mutex in the direct reclaim path.
> >>>>>>>>
> >>>>>>>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
> >>>>>>>>    mutex_trylock().  This is called from the vmalloc allocation
> >>>>>>>>    overflow path; if trylock fails, another thread is already
> >>>>>>>>    purging and the allocator's retry will find freed space.  The
> >>>>>>>>    notifier chain provides a fallback if the retry still fails.
> >>>>>>>>
> >>>>>>>> Both trylock failures break the circular dependency: the lock
> >>>>>>>> holder's flush_work() can complete because workers are no longer
> >>>>>>>> blocked on vmap_purge_lock in the direct reclaim path.
> >>>>>>>
> >>>>>>> Thanks.  AI review expressed a couple of concerns:
> >>>>>>> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
> >>>>>>
> >>>>>>
> >>>>>> Sounds legit to me. Now there is no guarantee of purge being successful, and we
> >>>>>> can get a spurious failure.
> >>>>>>
> >>>>>> How about using a WQ_RECLAIM workqueue:
> >>>>>>
> >>>>>> vmap_purge_wq = alloc_workqueue("vmap_purge",
> >>>>>> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> >>>>>>
> >>>>>> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
> >>>>>>
> >>>>> WQ_MEM_RECLAIM makes sense but this is another patch.
> >>>>>
> >>>>> I copied here AI comment:
> >>>>>>
> >>>>>> Does replacing this blocking lock with a trylock break synchronization for
> >>>>>> the callers?
> >>>>>>
> >>>>> No it does not. If someone is doing reclaim we do not wait and do not try
> >>>>> to do it again thus fail allocation.
> >>>>>
> >>>>>> When vmalloc space is exhausted, alloc_vmap_area() calls
> >>>>>> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
> >>>>>> that free space has actually been reclaimed before looping back to retry:
> >>>>>> mm/vmalloc.c:alloc_vmap_area() {
> >>>>>>    ...
> >>>>>> overflow:
> >>>>>> 	if (!purged) {
> >>>>>> 		reclaim_and_purge_vmap_areas();
> >>>>>> 		purged = 1;
> >>>>>> 		goto retry;
> >>>>>> 	}
> >>>>>>    ...
> >>>>>> }
> >>>>>> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
> >>>>>> fails and the function returns immediately.
> >>>>>>
> >>>>> If reclaim is in progress and trylock fails a caller repeats only one
> >>>>> time to retry an allocation. There is no any infinite loop.
> >>>>>
> >>>>>>
> >>>>>> The allocator then retries
> >>>>>> instantly without waiting for the concurrent purge to complete.
> >>>>>> Because the retry fails and purged is already 1, could this cause the
> >>>>>> allocation to abort and return a spurious vmalloc allocation failure
> >>>>>> (-EBUSY or -ENOMEM)?
> >>>>>>
> >>>>> vmap space can be fragmented and not avail for 32-bit systems. For
> >>>>> 64-bit system it is likely impossible.
> >>>>>
> >>>>> But, i think we can overt mutex_lock() into mutex_trylock() just only
> >>>>> in the:
> >>>>>
> >>>>> static unsigned long
> >>>>> vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >>>>> {
> >>>>> 	struct vmap_node *vn;
> >>>>>
> >>>>> 	guard(mutex)(&vmap_purge_lock);
> >>>>> 	for_each_vmap_node(vn)
> >>>>> 		decay_va_pool_node(vn, true);
> >>>>>
> >>>>> 	return SHRINK_STOP;
> >>>>> }
> >>>>>
> >>>>> so the reclaim path is not blocked. It should also address an issue
> >>>>> reported by the Ye Liu <ye.liu@linux.dev>.
> >>>>
> >>>> IIUC you are suggesting mutex_trylock() only in the shrinker path. But
> >>>> then, the following is possible no: take purge lock, try to get a
> >>>> worker thread, worker thread is stuck in vmalloc -> alloc_vmap_area
> >>>> -> reclaim_and_purge_vmap_areas -> take purge lock?
> >>>>
> >>>>
> >>>
> >>> Personally, I lean toward the WQ_MEM_RECLAIM workqueue solution. 
> >>> After taking a closer look at the code, I noticed a subtle but 
> >>> potentially problematic scenario:
> >>>
> >>> When drain_vmap_area_work acquires vmap_purge_lock and calls into 
> >>> __purge_vmap_area_lazy, it may subsequently invoke queue_work/queue_work_on 
> >>> on the same CPU's system_wq. If the newly queued work ends up waiting 
> >>> for an available worker on that same CPU, while the current worker is
> >>> blocked waiting for that very work to complete (via flush_work), 
> >>> we could end up with a self-deadlock on a single CPU.
> >>>
> >>> Theoretically, this seems possible. I suspect the reason we don't 
> >>> see widespread reports of such deadlocks is that the nr_purge_helpers 
> >>> logic limits the number of asynchronous workers; when resources are tight, 
> >>> it falls back to synchronous execution (purge_vmap_node directly), 
> >>> which avoids queuing additional work. 
> >>>
> >>> Using a dedicated workqueue with WQ_MEM_RECLAIM would provide a clean, 
> >>> explicit isolation—ensuring forward progress under memory pressure and 
> >>> eliminating the risk of interfering with other subsystems' workqueues. 
> >>> I believe this approach is more robust in the long run.
> >>>
> >>> Perhaps like the code below：
> >>> the dedicated queue eliminates the self‑deadlock risk, and the trylock 
> >>> in the shrinker prevents recursive lock attempts from reclaim contexts.
> >>>
> >>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>> index bea9f76ed7e7..68fc1f5acb2f 100644
> >>> --- a/mm/vmalloc.c
> >>> +++ b/mm/vmalloc.c
> >>> @@ -2218,6 +2218,9 @@ static unsigned long lazy_max_pages(void)
> >>>   */
> >>>  static DEFINE_MUTEX(vmap_purge_lock);
> >>>  
> >>> +/* Workqueue for lazy vmap purging; WQ_MEM_RECLAIM guarantees progress. */
> >>> +static struct workqueue_struct *vmap_purge_wq;
> >>> +
> >>>  /* for per-CPU blocks */
> >>>  static void purge_fragmented_blocks_allcpus(void);
> >>>  
> >>> @@ -2408,9 +2411,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
> >>>                                 INIT_WORK(&vn->purge_work, purge_vmap_node);
> >>>  
> >>>                                 if (cpumask_test_cpu(i, cpu_online_mask))
> >>> -                                       schedule_work_on(i, &vn->purge_work);
> >>> +                                       queue_work_on(i, vmap_purge_wq, &vn->purge_work);
> >>>                                 else
> >>> -                                       schedule_work(&vn->purge_work);
> >>> +                                       queue_work(vmap_purge_wq, &vn->purge_work);
> >>>  
> >>>                                 nr_purge_helpers--;
> >>>                         } else {
> >>> @@ -5519,10 +5522,14 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >>>  {
> >>>         struct vmap_node *vn;
> >>>  
> >>> -       guard(mutex)(&vmap_purge_lock);
> >>> +       if (!mutex_trylock(&vmap_purge_lock))
> >>> +               return SHRINK_STOP;
> >>> +
> >>>         for_each_vmap_node(vn)
> >>>                 decay_va_pool_node(vn, true);
> >>>  
> >>> +       mutex_unlock(&vmap_purge_lock);
> >>> +
> >>>         return SHRINK_STOP;
> >>>  }
> >>>  
> >>> @@ -5575,6 +5582,17 @@ void __init vmalloc_init(void)
> >>>          * Now we can initialize a free vmap space.
> >>>          */
> >>>         vmap_init_free_space();
> >>> +
> >>> +       /*
> >>> +        * A dedicated workqueue for lazy vmap purging.  WQ_MEM_RECLAIM
> >>> +        * reserves a rescue worker so queued purge work items are executed
> >>> +        * even under memory pressure, when workers of the system workqueue
> >>> +        * may be stuck in direct reclaim.
> >>> +        */
> >>> +       vmap_purge_wq = alloc_workqueue("vmap_purge",
> >>> +                                       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> >>> +       WARN_ON(!vmap_purge_wq);
> >>> +
> >>>         vmap_initialized = true;
> >>>
> >> I agree. We should have it and it should be as separate patch, i.e.
> >> split vmap_node_shrink_scan() and dedicated per-cpu WQs per vmap drain.
> >>
> > And i sent out already the WQ_UNBOUND | WQ_MEM_RECLAIM and separate WQ
> > for vmap drain logic. It looks like Andrew/me forgot about it:
> > 
> > https://lore.kernel.org/all/20260331202352.879718-1-urezki@gmail.com/
> 
> Great! Perhaps resend it and we can review it?
> 
I will and add you to Cc.

--
Uladzislau Rezki

