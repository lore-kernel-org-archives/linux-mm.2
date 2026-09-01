Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911BCC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D316B0096; Tue,  1 Sep 2026 12:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E176B0099; Tue,  1 Sep 2026 12:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AB56B00A9; Tue,  1 Sep 2026 12:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D26A6B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:59:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3B82120475
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:59:57 +0000 (UTC)
X-FDA: 85165805634.04.DCBA8F0
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA5C1C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:59:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SfZEn5P0;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281995;
	b=Rx3W+y7G5nTtlf+H9CmPuafUoa9V8cSVHA1HUxglnatQuCAQn7iU0EXuTsfXTURpN6Tlfw
	80fT/k8wl5jn3egD+QsWog/xEuCn01VnaFqp0fkRlkYcFm5RElHbsYnUnfhcRBk4g5J7wP
	kQ5yemTL1pNzB8HB2ZSvhcJBSomaY08=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SfZEn5P0;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+u2ZpPe4WF1Q2YUp42qnHHNqN5pF4v/rnDCZv4ozNq4=;
	b=GxrdKbYVOtNd10oSHrSMXSD/q4NSBy//0SnrPK89aApdRofQOALsnFTDO/F5AIqR16d34h
	RyF3cqNer1NCgv+j+4QLBC8vNWxnkiYsoSpXWdB0BrY+35rct70HqOJbxx+S0KV8VXtCvQ
	QAKlYSena3G99Ks+fkwsGUvx6lat1RA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a5e971c970so2200302a12.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281994; x=1788886794; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+u2ZpPe4WF1Q2YUp42qnHHNqN5pF4v/rnDCZv4ozNq4=;
        b=SfZEn5P0PRcPqB5dOagYGa0h+Naj4/59VkvtSJ9kcqIWn2Op+WSPhTodSEfHjPLhJK
         YQGg7ClaxeYP3kPbQ3vTwc+E91pA7bX6yWxYG9VlwM12TVmRNbtcf4hpJEoMMSs4zULy
         pgibl5fihWlAAlSKQxGftYl5hLEJIvkHXy7lzM6NwBZZvvEJMLQA1HxN88XinKzvGtao
         VSXWxpujGrXcadLOEAnFhV5cWQyIJyR6U6fNg21Nr1dydTZQwaUWukkOPIs5kc0LyQml
         wcQJ8cZ7v8gTZtWevmRDndm+TQGOL2ZE88JFeaLOHbflTwd6o2Gqe2o1tSoaNBLn8p+4
         /oEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281994; x=1788886794;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+u2ZpPe4WF1Q2YUp42qnHHNqN5pF4v/rnDCZv4ozNq4=;
        b=ctxcOvjrdyOTEq7GuyZZuzPKAoGafF+aAnz4U3m66tfd/6vHJXTEodNYXkYNpXv75C
         WfoZD2Sggzf2yOTkdegM4UAPsWytcFR1jyzLQtnZ8vRPs1FK8OnEIWfbLMDKlBf7ehVX
         m3iOCboR0ZKwH5zoCIG3ppNpB+bgvWNiP7nnBYS2pqgktuyeemH54/G3fcXPV7ENF/pi
         O6uIlzCzQ9GdlOvY2F8ljPB9mL8EKuovC+BOhIKOwgB+zu4w59WL5i78gPLgml2ulmBJ
         c8gWihAeO8tOJCvuLQCkxJr7a0gIusqcD/MxqXUoluS5NdDXlxjzQh4VFYzTti+I/SjM
         8Ilw==
X-Forwarded-Encrypted: i=1; AKwUvBwfUBr+MyhzZIlrHRoSNfCRSyr/Zsl5eSZ2APvrWas4tpi2m6ymGo+E0KHTF7EdX9oUnEcoiUIgOA==@kvack.org
X-Gm-Message-State: AFuF++lcuCxSOddlCwF8px8LTy8fcIKOQP5ogWhSTsb5wGQYAnI5EGfz
	zsXj1jHtQ8//r7oGYFZK0Nry8C+bS1S+AjIMxDS8e5NIbzJIuojFS/QC
X-Gm-Gg: AYBFou2G2E/aAFd3QOpSbJUSbOMQvs0Vz1kGBSx5WPDzB+Nyhe8OaopXk3g07AGJkQ1
	0/ar43PSqlI0Y0KOAVFU0TJYz9wZ3xPqItdWScnZP3EPj0bmAjAL4kYhejQ0sFb00bQ0aNGW00O
	H+QC3olAama8xyqkU+XFggXZyTPdmKildm5xb2EiMmndWVHVpSqdLMLFiMiZd+/x5os6uryzZul
	D78Mgsgtt8XMm/fjOTO7LE4BiLvvOQbRJlAHAUnbZOT8AWHjIdJ5ZOznLkjlkJksvAqS2HvzKRd
	Um4msOBbfv9AD//8E/nlFhDzdD9sEr04UGhXiMzOstbDZAlmN81girWs3JRiEK+8MAHFn27NIhd
	L7O+eK1HL5Rcm9h9VkndQ5yO1bwtUBoUE+7f3wfyecZnQrpmMR+9OrHAE8oC3/AfzH635PK3TrM
	8aiRaR5Ef3+MFiqnInnqcGSRWGOIU=
X-Received: by 2002:a05:6402:4608:b0:6a6:485b:3b7e with SMTP id 4fb4d7f45d1cf-6a66a59b428mr4221026a12.1.1788281994348;
        Tue, 01 Sep 2026 09:59:54 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f895e14sm46521a12.3.2026.09.01.09.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:59:53 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 1 Sep 2026 18:59:51 +0200
To: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <ye.liu@linux.dev>, Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apcEh4iuYa6_47TJ@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
 <apVPTt9Xw8kSgmTU@milan>
 <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
 <2e9488bb-feb6-4994-92e3-e5ef0c1ff5ec@linux.dev>
 <apcAvwXe89M20mGs@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apcAvwXe89M20mGs@milan>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA5C1C0004
X-Stat-Signature: xam656hao41o3nh7ebz81irmkxr4g4mp
X-HE-Tag: 1788281995-901379
X-HE-Meta: U2FsdGVkX1/wGUVVAfwh/5IRr21equSryaA8Xz60Lz3UA8eCjTblKhF3ErOV+Ln86omFb2VgrxYS2eL5MZZutpCTCJhrwXorbRk9JqAE0oj8HmMhG7EOByhb/A0K7Qc8C05b9ysZxrmUxF1FNoxG3f+qgQ5HZmwyG3b3DR6EqRH5Dg2/IQTM3iY1q5XPhhDXzi+JiwAPPJqkH5X3nrvEwoJSZ5DtBLqwNHKXQthWbZHPPmrZbUGJxCe9NloStKVb8rBw42E54bGz73UtN0mZDq8hbbyAZblOtNnPIlL34WWAbsqhjsa6AZwua0Qy7Lw5f88OKoFsPsw9MJByfhbyfBKUadigpkUY3bJ9Q4LJg8aunhFtVj8O2NbDMX8z5u2m0UwIBfBP55u9TMSvAPkjV7VWWhCCJEI0Rrr8P8PHAotyMZnPisSaswey0iPv+hBRsDOffqWwXxkTKC0tDNeLW1FbtF0ss44JEmg9Cy2w0zOverdfk3vftPl3WxGiEH7nuQJgEpiXQiOL5jeiTngMNlJ/OTbQnaJFC4pvHzFEfZx5jj9WCSEuaVkAUk569ajk+s90F06T+/58MHtI6nKxUIGWdJz+BAYwa3nkE5ZzmfDMmCLWAY9GRT8dksj0RyrnHIifFyJXNhu5G08C+BliD1dTV8ktlHA8pN2p3doIHYCnoOF00HZtCtd2T9LpkKUTM7Yqwn1/Z1TDqTidDVXyLxL70AohGUEcjmt2tSVthJciBSnoKSUqTelgJvN+W80CcaKO3tS/Yq08jP3EeEctWXJv8Pmxp4XyYEid+YFqMfAm1x4lw8aW7mZMkQyMTKjwt+wJe8aVjah00NHGUXzvWGqMgHVfIx2t+xOJuXq8aOt+T4S+KiQ+K+IKSHTCGBzkLZrE8N9a++QVzZPIYbs5met9IrsF5119xUqv+8Zp0hULFlnfIaKo6Ww/XsuKbRnyFK7zJ5bk69c4FC3Tjmv
 UYkgI170
 fFHJxeAsD1q3BTnUR2nCEjNpHlNk4UtfmatnPWipyV2yKwVklljGUqo7Zvc1AHDJwMxjqs1SKumw3WtKwxjq6utZkERKGw431uoVjDNwJL0MrEIiSV+07fYouPrQZ/UV6YpmC83gUr4nUTYjjzm4VvzvrapKEsF2Kz4robyddQNOOFVQoWzyYYRxHoacXn6xczLGcENUUwRlIRr+H9YBkKZecYcQnkqYUG43z1nU4tTNPE4l22cvIWQXkgAmv4r6Isu+2XNitpstqyLFcjEiApbocMkJ/fCp+ejYDJ9nK+DM/T/Vs2pfAwRDZKWxTpxbyI0bqY1naoWsALI2L8jCaAyUj+lEx+PJWWoz4EVWBEGfDg0OrNb/a2Xyj18Ay9GzKDP+b9V4ejT1ZfG9zUmPyCm30bBy0ZX7/doz7B8K9RkvXpcuhzAkJ3K6zXPrGzL7kfsMOkXZiohKI7mvgEeETJI4YWh5iPkGR35y/hSXuwbwrSjWxcYN0cRReuBwzAA1hgFhJyJ1OTGFPfU0urbjVssX/eICzyPdjr2SGXUNu45JGYmH5dVjhNHwCyt63SVjIOlnyGVDwSKOv950=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 06:43:43PM +0200, Uladzislau Rezki wrote:
> On Tue, Sep 01, 2026 at 05:07:30PM +0800, Ye Liu wrote:
> > 
> > 
> > 在 2026/9/1 14:22, Dev Jain 写道:
> > > 
> > > 
> > > On 31/08/26 3:24 pm, Uladzislau Rezki wrote:
> > >> On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
> > >>>
> > >>>
> > >>> On 28/08/26 11:35 pm, Andrew Morton wrote:
> > >>>> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> > >>>>
> > >>>>> From: Ye Liu <liuye@kylinos.cn>
> > >>>>>
> > >>>>> The vmap_purge_lock mutex can be held for an extended period by
> > >>>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
> > >>>>> purge_vmap_node workers while holding the lock.  Under memory
> > >>>>> pressure, those workers may themselves be blocked in direct
> > >>>>> reclaim trying to acquire the same lock via the
> > >>>>> vmap_node_shrink_scan() shrinker callback, creating a circular
> > >>>>> dependency that deadlocks the entire system.
> > >>>>>
> > >>>>> Two places acquire vmap_purge_lock from paths that can be reached
> > >>>>> during direct reclaim:
> > >>>>>
> > >>>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
> > >>>>>    mutex_trylock().  This is a shrinker that only decays the vmap
> > >>>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
> > >>>>>    decay cycle when the lock is contended is harmless and prevents
> > >>>>>    tasks from piling up on the mutex in the direct reclaim path.
> > >>>>>
> > >>>>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
> > >>>>>    mutex_trylock().  This is called from the vmalloc allocation
> > >>>>>    overflow path; if trylock fails, another thread is already
> > >>>>>    purging and the allocator's retry will find freed space.  The
> > >>>>>    notifier chain provides a fallback if the retry still fails.
> > >>>>>
> > >>>>> Both trylock failures break the circular dependency: the lock
> > >>>>> holder's flush_work() can complete because workers are no longer
> > >>>>> blocked on vmap_purge_lock in the direct reclaim path.
> > >>>>
> > >>>> Thanks.  AI review expressed a couple of concerns:
> > >>>> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
> > >>>
> > >>>
> > >>> Sounds legit to me. Now there is no guarantee of purge being successful, and we
> > >>> can get a spurious failure.
> > >>>
> > >>> How about using a WQ_RECLAIM workqueue:
> > >>>
> > >>> vmap_purge_wq = alloc_workqueue("vmap_purge",
> > >>> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> > >>>
> > >>> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
> > >>>
> > >> WQ_MEM_RECLAIM makes sense but this is another patch.
> > >>
> > >> I copied here AI comment:
> > >>>
> > >>> Does replacing this blocking lock with a trylock break synchronization for
> > >>> the callers?
> > >>>
> > >> No it does not. If someone is doing reclaim we do not wait and do not try
> > >> to do it again thus fail allocation.
> > >>
> > >>> When vmalloc space is exhausted, alloc_vmap_area() calls
> > >>> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
> > >>> that free space has actually been reclaimed before looping back to retry:
> > >>> mm/vmalloc.c:alloc_vmap_area() {
> > >>>    ...
> > >>> overflow:
> > >>> 	if (!purged) {
> > >>> 		reclaim_and_purge_vmap_areas();
> > >>> 		purged = 1;
> > >>> 		goto retry;
> > >>> 	}
> > >>>    ...
> > >>> }
> > >>> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
> > >>> fails and the function returns immediately.
> > >>>
> > >> If reclaim is in progress and trylock fails a caller repeats only one
> > >> time to retry an allocation. There is no any infinite loop.
> > >>
> > >>>
> > >>> The allocator then retries
> > >>> instantly without waiting for the concurrent purge to complete.
> > >>> Because the retry fails and purged is already 1, could this cause the
> > >>> allocation to abort and return a spurious vmalloc allocation failure
> > >>> (-EBUSY or -ENOMEM)?
> > >>>
> > >> vmap space can be fragmented and not avail for 32-bit systems. For
> > >> 64-bit system it is likely impossible.
> > >>
> > >> But, i think we can overt mutex_lock() into mutex_trylock() just only
> > >> in the:
> > >>
> > >> static unsigned long
> > >> vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> > >> {
> > >> 	struct vmap_node *vn;
> > >>
> > >> 	guard(mutex)(&vmap_purge_lock);
> > >> 	for_each_vmap_node(vn)
> > >> 		decay_va_pool_node(vn, true);
> > >>
> > >> 	return SHRINK_STOP;
> > >> }
> > >>
> > >> so the reclaim path is not blocked. It should also address an issue
> > >> reported by the Ye Liu <ye.liu@linux.dev>.
> > > 
> > > IIUC you are suggesting mutex_trylock() only in the shrinker path. But
> > > then, the following is possible no: take purge lock, try to get a
> > > worker thread, worker thread is stuck in vmalloc -> alloc_vmap_area
> > > -> reclaim_and_purge_vmap_areas -> take purge lock?
> > > 
> > > 
> > 
> > Personally, I lean toward the WQ_MEM_RECLAIM workqueue solution. 
> > After taking a closer look at the code, I noticed a subtle but 
> > potentially problematic scenario:
> > 
> > When drain_vmap_area_work acquires vmap_purge_lock and calls into 
> > __purge_vmap_area_lazy, it may subsequently invoke queue_work/queue_work_on 
> > on the same CPU's system_wq. If the newly queued work ends up waiting 
> > for an available worker on that same CPU, while the current worker is
> > blocked waiting for that very work to complete (via flush_work), 
> > we could end up with a self-deadlock on a single CPU.
> > 
> > Theoretically, this seems possible. I suspect the reason we don't 
> > see widespread reports of such deadlocks is that the nr_purge_helpers 
> > logic limits the number of asynchronous workers; when resources are tight, 
> > it falls back to synchronous execution (purge_vmap_node directly), 
> > which avoids queuing additional work. 
> > 
> > Using a dedicated workqueue with WQ_MEM_RECLAIM would provide a clean, 
> > explicit isolation—ensuring forward progress under memory pressure and 
> > eliminating the risk of interfering with other subsystems' workqueues. 
> > I believe this approach is more robust in the long run.
> > 
> > Perhaps like the code below：
> > the dedicated queue eliminates the self‑deadlock risk, and the trylock 
> > in the shrinker prevents recursive lock attempts from reclaim contexts.
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index bea9f76ed7e7..68fc1f5acb2f 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2218,6 +2218,9 @@ static unsigned long lazy_max_pages(void)
> >   */
> >  static DEFINE_MUTEX(vmap_purge_lock);
> >  
> > +/* Workqueue for lazy vmap purging; WQ_MEM_RECLAIM guarantees progress. */
> > +static struct workqueue_struct *vmap_purge_wq;
> > +
> >  /* for per-CPU blocks */
> >  static void purge_fragmented_blocks_allcpus(void);
> >  
> > @@ -2408,9 +2411,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
> >                                 INIT_WORK(&vn->purge_work, purge_vmap_node);
> >  
> >                                 if (cpumask_test_cpu(i, cpu_online_mask))
> > -                                       schedule_work_on(i, &vn->purge_work);
> > +                                       queue_work_on(i, vmap_purge_wq, &vn->purge_work);
> >                                 else
> > -                                       schedule_work(&vn->purge_work);
> > +                                       queue_work(vmap_purge_wq, &vn->purge_work);
> >  
> >                                 nr_purge_helpers--;
> >                         } else {
> > @@ -5519,10 +5522,14 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> >  {
> >         struct vmap_node *vn;
> >  
> > -       guard(mutex)(&vmap_purge_lock);
> > +       if (!mutex_trylock(&vmap_purge_lock))
> > +               return SHRINK_STOP;
> > +
> >         for_each_vmap_node(vn)
> >                 decay_va_pool_node(vn, true);
> >  
> > +       mutex_unlock(&vmap_purge_lock);
> > +
> >         return SHRINK_STOP;
> >  }
> >  
> > @@ -5575,6 +5582,17 @@ void __init vmalloc_init(void)
> >          * Now we can initialize a free vmap space.
> >          */
> >         vmap_init_free_space();
> > +
> > +       /*
> > +        * A dedicated workqueue for lazy vmap purging.  WQ_MEM_RECLAIM
> > +        * reserves a rescue worker so queued purge work items are executed
> > +        * even under memory pressure, when workers of the system workqueue
> > +        * may be stuck in direct reclaim.
> > +        */
> > +       vmap_purge_wq = alloc_workqueue("vmap_purge",
> > +                                       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> > +       WARN_ON(!vmap_purge_wq);
> > +
> >         vmap_initialized = true;
> > 
> I agree. We should have it and it should be as separate patch, i.e.
> split vmap_node_shrink_scan() and dedicated per-cpu WQs per vmap drain.
> 
And i sent out already the WQ_UNBOUND | WQ_MEM_RECLAIM and separate WQ
for vmap drain logic. It looks like Andrew/me forgot about it:

https://lore.kernel.org/all/20260331202352.879718-1-urezki@gmail.com/

--
Uladzislau Rezki

