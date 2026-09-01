Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56904C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CF36B00E4; Tue,  1 Sep 2026 12:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32ADC6B00E5; Tue,  1 Sep 2026 12:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BF36B00E6; Tue,  1 Sep 2026 12:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB29D6B00E4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:40:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B843404C3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:40:15 +0000 (UTC)
X-FDA: 85165755990.03.4E71B26
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 782FC14000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:40:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UVwL7oh7;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788280813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFL2PnQFXGTwOtmj8ilJJ1QqFCeQkcb04bsOr6A5nS4=;
	b=7SfKOZzJUgv2223cxVw/Nl/eIeFr90VlCdxcF2beG6NerWCO6euH2Y4gav5OwVNgRdDh5F
	MH8tD84+OnZc0suY/ep86mKd+V+QXNdLrveyoPfgOmg0Usjt+KPCrVMWV2Df/qpn4FlQuX
	Hf7rPX+JKbvMHraN9mmJS5nXlEBkxYE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UVwL7oh7;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788280813;
	b=IuE2V6GyYDGk8MdKZVj8xC67m8Nv09j9lQHDM6G9uT9rL7cjIlrJM3cAmpT6oNH9mDEwf6
	j0XRn0iGL+wLqLZ16RhdxBFCT7kNMPzmFhm5rllrvnRE33JVxY7WXnaSfAXpqruT8MSRO6
	ODB1vqjWEWr4vQYQrfHUE7AhThUGLas=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c25420fe973so187738266b.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788280812; x=1788885612; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BFL2PnQFXGTwOtmj8ilJJ1QqFCeQkcb04bsOr6A5nS4=;
        b=UVwL7oh76TNmW/IjGZJN/gphOuXwYrqHN0sc75tPLlL07nWyO7AVNHZQMu98nx3iqn
         vbyVPYxu1pyP5kd32aG7tHB8cOMoroIK735XyAz+ITYjKNelGC1i9k4T6Cs2kR+8x760
         84duu+t1ZOtpkbgu3p78XlvCzm1BAA6XvPDcdLv7lqjgxFV9d+dKud67kM4Ymnovq0aw
         gGjUQd7tGA/IjsbsfFZGKngRF5R83ADpL9VwNM+Giun8jTAmxpNXITkWC54kat5Bdlj9
         hn5TmJvI/AgCXsybH55bHHSRpWPWPGKdkHxOaFwATy9sPnB+7hHZYQrBv7e1Fao68KQB
         f7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788280812; x=1788885612;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BFL2PnQFXGTwOtmj8ilJJ1QqFCeQkcb04bsOr6A5nS4=;
        b=iVpCNntZpseJrhAMb5izFNNTNGjrJ87mKQKDy9AAcfxAPP3kqhzHgROa/Qd4bDpk7a
         P/ql7SOqpg+1O61Cy1kCU0j5/CO97Gi5ptOeuQXuSebnzoKOyj55siugCUvhORHc4yUR
         EnuGPgkmyGhBVqwED0JJHKhCOXmqbQAnx/pGEkM0k7p85b2OZwVIizn42XZCvmuHU5T3
         MnB4nTclImyw7+951ttTHFUSBGt1FKCgls3hfV0IUqnMYf2IwbYYkuVRK22npEbGswye
         PeNnZX0UQwqAALtjtKOf+xuERDWJTzehLImqfucRd8tilXhefQkr0mmIbvLoyN41mgb9
         pmGg==
X-Forwarded-Encrypted: i=1; AHgh+RoyUeEXaKX3F7W48sq8iOpBlZ4WoNQQh6rMuJsbpPtSv1/+xQzcgyzzguk/Is0dgtG/1JE3PwAruQ==@kvack.org
X-Gm-Message-State: AFuF++lOfiULDzCjcpOva65kcfy1F7Uwe/uVo5TIzBI/Q27s+tbsfDkO
	y+MPhH/FrZcmV1ntr3f1+pJjfNI9P/w3Ywlj74jQE4JhA5aO+gMX99Elq2imlk5M
X-Gm-Gg: AR+sD10nJN57/1PHTnmGsTDJnoHvUhlkV16ro+o3uJHbXH2SqdKxWqpwRJFRr4eW9WI
	Jr7rRvZcX0TBpbBjJTGEQKITWBpFLY8mhmJXAqIgUUzWdqysLZX0QvP97mnAoJgQMNLx2IXenSP
	tsqQjr8Cqeyg2KALq4TPqBwkj1S8j2ofLWQ+ywRcTr5Xt4bQsmeTY1jJFN9qYDYoNpzIqb1jdmP
	mvcXx1w0W1bdq92SQuABwvp8GJb898HpyrQ4ezLDCIyJYL0et1w69hfM1G0nFI1xOUdw0aukvWn
	kbIim0LZVAzt75VE6QPqS7aSPEtpCsm8QCfiqNlMX0s2dIOfEng1SQhekRil7daGyFC3gd4DROy
	R52Xmc4i8d7Nsf7RIMpWGNn3LWA03pa4aQ7ZksWypkqN2U3CVrUz/7irwNBdO4Beoe0zgEOVtdl
	3KPRKfrlcyMn6TL00O4heIDAIjmA==
X-Received: by 2002:a17:907:f495:b0:c25:37e2:2d3b with SMTP id a640c23a62f3a-c25571b387emr2163930966b.10.1788280811791;
        Tue, 01 Sep 2026 09:40:11 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255f1fb4c3sm629113266b.48.2026.09.01.09.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:40:10 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 1 Sep 2026 18:40:08 +0200
To: Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Ye Liu <ye.liu@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-ID: <apb_6DUfmilJGsp1@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
 <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
 <apVPTt9Xw8kSgmTU@milan>
 <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54bd749f-04f5-4665-bd5f-d485e7197132@arm.com>
X-Stat-Signature: 5jzxkr8yhaj3podd6mer4xwdaz1p3zyw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 782FC14000A
X-Rspam-User: 
X-HE-Tag: 1788280813-374321
X-HE-Meta: U2FsdGVkX1+YpuMmm4u8lW9raB/IH+Sz0vZXfOoB3WugyZ0uYOU/3Qw2HT+lFJx+lAcXVPp4v6rRzEekmckP/TqkH1ik5koteKoG3kPkwL4oqv9rgS0FZ+TnG0gjAwNja+Av7okHupeB6o0CL3AzKKmLntQuDXKeGmlKMd/5FkROYwClKITXWEqsOMcvZ8gwGDqbWsPri2mHNbKqajWdiYRtuF/2NP1OS71VyRgE7YsIwqE3kdfKdc/LtdqEu9D+abszCZP+2tAPnW2PEDPmac2Rck/cSYZUdae2WCoPevR4RneL7q+ly7RiV6cBEZfi8ARFEyZUCSby59vg7spmfOGPjeBKrMh7iMOXqSikkewFEF7mcQ6d3l2plTFTiOEf086W5IdHLZtGVEt88+ssQCWapGNie5Lj14k2lw1gf8X6Q+6LfbUYnd0tWfVCOuWu5ml3yYno1xdxSOi3txZ/KB66h8Od1QctBh2R362IBTPtCeOXTCIVESO9pvWF3+3N+6oc8DB34LSZzzc8NTderAtCntlYjDq6NQjC2Odkw1x5AbYgxiYOZPDgEahiabB1FgCB1F+QjPB7H26AYQ1L05BtP5YVnjS5lJHxX6S5y9/GJ/tjLQoortfKi2nTAVrofsvEgYCWPRky2O3lska13t5/YtF9K2Iv0WugIQXTsLmgNPcv5X2fAP1iRO0smDzIMRaNu/mn95qnTNqDp5hG4mL2mU1dmgYpynH+WiBH6ypVjqVfeBHmKbv67JSUbk+DeQ99gOGz0bsqMEUugtVrS00ltdet3TWPjN0oV3mrQAk9dSFjltEa9sq7dv6269Z4v0u1/ad9FtRETsbYdtnlWnoegLnHGIaS+P1EEKEMYShTjFvAC1nn0ZQjr1BT48Vr/U/z6CHjhxddntmWc8UMJ9bCW3qpaNFZmRI175htrBlSx68UFvoN6VzfSjGyhLyyIkAtDS7Hn8BMIhO4iKA
 pq7kL6Rc
 7LqFI5L9Q9lhYkmZ8I8Wp6JhktD4d2M/H817EuGB4i8xTFV8x/rxx7tTiaia2/sD5qsQE/ipo0co1y/s46+FZ3UJ9LP3mHTsgA/qZTmsx9JVkZgcl8a4jaqjbWJsRvq8nwcBc3jfdUwZrumKbSjwB6Yw2BBc9HDM8f86tjqmjVl0HKMMeIbEybkzQ361aIiGeUaeR+jUFeI8k7dO1obFqK+QiuQtLfNWaI6kOAdHMQxpi5NGknK0u2D32PhSSOtYGNNBEgN+1wgggUzt4ZelqrKowZ3ETlY3GP1q3kTuFbikE0PWgakLXXKUkvlNEz9RZe9r3XJ5eS1M4D+NcLuoS8jHWmSvE0ycq5EQ9swyt/RdNi8wiWMZcc0NQ/cP9ie5ffPky0sDyDJcKQuYiAO/0ZO79G6rTYTk/PcZL/HzFsq4vk5eWuQvo35zDuWRrjoxkPbhCytWDwa11U1nQz+0sB73X9vxhzL/HeGgTlCQ4KhnRyB/fibnjICk0M4fEIIP9T14Lgqsm4TFhJeSG0UPay+POipcMLaCbAzvUuYexrIC6KlA/E5TfO33i5jJ9wtP1MCrfXIRy89j6wfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 11:52:11AM +0530, Dev Jain wrote:
> 
> 
> On 31/08/26 3:24 pm, Uladzislau Rezki wrote:
> > On Mon, Aug 31, 2026 at 11:39:14AM +0530, Dev Jain wrote:
> >>
> >>
> >> On 28/08/26 11:35 pm, Andrew Morton wrote:
> >>> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> >>>
> >>>> From: Ye Liu <liuye@kylinos.cn>
> >>>>
> >>>> The vmap_purge_lock mutex can be held for an extended period by
> >>>> __purge_vmap_area_lazy() which calls flush_work() to wait for
> >>>> purge_vmap_node workers while holding the lock.  Under memory
> >>>> pressure, those workers may themselves be blocked in direct
> >>>> reclaim trying to acquire the same lock via the
> >>>> vmap_node_shrink_scan() shrinker callback, creating a circular
> >>>> dependency that deadlocks the entire system.
> >>>>
> >>>> Two places acquire vmap_purge_lock from paths that can be reached
> >>>> during direct reclaim:
> >>>>
> >>>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
> >>>>    mutex_trylock().  This is a shrinker that only decays the vmap
> >>>>    pool and returns SHRINK_STOP without freeing memory; skipping a
> >>>>    decay cycle when the lock is contended is harmless and prevents
> >>>>    tasks from piling up on the mutex in the direct reclaim path.
> >>>>
> >>>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
> >>>>    mutex_trylock().  This is called from the vmalloc allocation
> >>>>    overflow path; if trylock fails, another thread is already
> >>>>    purging and the allocator's retry will find freed space.  The
> >>>>    notifier chain provides a fallback if the retry still fails.
> >>>>
> >>>> Both trylock failures break the circular dependency: the lock
> >>>> holder's flush_work() can complete because workers are no longer
> >>>> blocked on vmap_purge_lock in the direct reclaim path.
> >>>
> >>> Thanks.  AI review expressed a couple of concerns:
> >>> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev
> >>
> >>
> >> Sounds legit to me. Now there is no guarantee of purge being successful, and we
> >> can get a spurious failure.
> >>
> >> How about using a WQ_RECLAIM workqueue:
> >>
> >> vmap_purge_wq = alloc_workqueue("vmap_purge",
> >> 				WQ_MEM_RECLAIM | WQ_PERCPU, 0);
> >>
> >> I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().
> >>
> > WQ_MEM_RECLAIM makes sense but this is another patch.
> > 
> > I copied here AI comment:
> >>
> >> Does replacing this blocking lock with a trylock break synchronization for
> >> the callers?
> >>
> > No it does not. If someone is doing reclaim we do not wait and do not try
> > to do it again thus fail allocation.
> > 
> >> When vmalloc space is exhausted, alloc_vmap_area() calls
> >> reclaim_and_purge_vmap_areas() and relies on its blocking behavior to ensure
> >> that free space has actually been reclaimed before looping back to retry:
> >> mm/vmalloc.c:alloc_vmap_area() {
> >>    ...
> >> overflow:
> >> 	if (!purged) {
> >> 		reclaim_and_purge_vmap_areas();
> >> 		purged = 1;
> >> 		goto retry;
> >> 	}
> >>    ...
> >> }
> >> With this patch, if another thread holds vmap_purge_lock, mutex_trylock()
> >> fails and the function returns immediately.
> >>
> > If reclaim is in progress and trylock fails a caller repeats only one
> > time to retry an allocation. There is no any infinite loop.
> > 
> >>
> >> The allocator then retries
> >> instantly without waiting for the concurrent purge to complete.
> >> Because the retry fails and purged is already 1, could this cause the
> >> allocation to abort and return a spurious vmalloc allocation failure
> >> (-EBUSY or -ENOMEM)?
> >>
> > vmap space can be fragmented and not avail for 32-bit systems. For
> > 64-bit system it is likely impossible.
> > 
> > But, i think we can overt mutex_lock() into mutex_trylock() just only
> > in the:
> > 
> > static unsigned long
> > vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> > {
> > 	struct vmap_node *vn;
> > 
> > 	guard(mutex)(&vmap_purge_lock);
> > 	for_each_vmap_node(vn)
> > 		decay_va_pool_node(vn, true);
> > 
> > 	return SHRINK_STOP;
> > }
> > 
> > so the reclaim path is not blocked. It should also address an issue
> > reported by the Ye Liu <ye.liu@linux.dev>.
> 
> IIUC you are suggesting mutex_trylock() only in the shrinker path. But
> then, the following is possible no: take purge lock, try to get a
> worker thread, worker thread is stuck in vmalloc -> alloc_vmap_area
> -> reclaim_and_purge_vmap_areas -> take purge lock?
> 
It is possible what you describe. Usually when no memory, the work item
can be delayed for a while. As it was noted WQ_RECLAIM and separate WQ
which has a rescue worker.

IMO, it should be a separate patch.

--
Uladzislau Rezki

