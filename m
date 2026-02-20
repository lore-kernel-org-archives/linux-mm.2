Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CFCC55ABC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 12:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69406B0088; Fri, 20 Feb 2026 07:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A636B0089; Fri, 20 Feb 2026 07:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B563A6B008A; Fri, 20 Feb 2026 07:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A25F46B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:31:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BAA9140182
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:31:35 +0000 (UTC)
X-FDA: 84464770950.20.2B07A19
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EE464000E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:31:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="I/SJ+vh+";
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771590693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paC9R7VowpxtjcyveRbHciWvakOZD/98nE1roKe929I=;
	b=yerFIpYjHp1LTTcC39i4zssXtYR0dGtT8mtgGuK4r3qM9LbZCAiWRJfyJhcmVYTdXATco6
	WvBykKx+6Yl7PS4iJocs2TAZRu40O2eXk726jAImZm8XOBWiynyaZF85Fe/mxZjL3eQunG
	8tq4BvdK4euZGUgantI/eBnVggVTevk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="I/SJ+vh+";
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771590693; a=rsa-sha256;
	cv=none;
	b=shi1A0UY2fxm2ZmWW9j0teYbD0n8AqyiYV4aD1ar9NJx2934/vDVjkITy/PBHdnroRU99P
	TuzdsnVirmK3eyx5mRDkkX6HXbbvgpTTKJ3s+QBX6xHwcNtirz3ZNFx/Rv9Ywho+kGnjIa
	czhaoV6qvZp11YbgvhpX0Gk5Se2Fojs=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4833115090dso19101265e9.3
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771590691; x=1772195491; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=paC9R7VowpxtjcyveRbHciWvakOZD/98nE1roKe929I=;
        b=I/SJ+vh+sVof7tx6sTh985u/Y8zJSJUBphazXVWX007u5pu+ZgEhccuSD5MQnWcR0G
         ssfMpabSHZisHy9gN15pSeZu7sa96g4d0L8SFLi8T7TpZJWnFX2/dq8GeIZjuj8ce8Am
         qGxXV7BcuRXquInw60cOC+T057TJAraudi8JPzOf9THinJOe0pmm/nm0YcZYVly3fVaC
         lvtmeRVzColl98CZbRuysfS8WMX94UkGa4hEdCgPUtoVH7psH7vEMmuaMvo4zOYvmxnc
         KKqNowrHeDPSFyCNZHQMw/TYWpaT6Ihxs2KaNgMJu+wIyqC6brlQ8uUHsuLQJh77TlLm
         fbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771590691; x=1772195491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=paC9R7VowpxtjcyveRbHciWvakOZD/98nE1roKe929I=;
        b=aPgvobpUXJjPB+ZhxHHuHzzIi9bZWMwqUqTJxw8+xsIcyHC2zVcldJHH/wsuxHPDQq
         V8Lmg2abrGHMCQEJKchKg4S22WGaMVSwVa1iYEPzhTLlPj/oBny8WaHonwn8x6HeD5ga
         DnlfGgMCgPJyiXCFqIOzsY9OLfoK8u1hAtiRGaTrqVhHsQuuRqTfM2gVhbDeK8x3Af2Y
         1YrnCZnBIr9Hk4cdii7ol2gnI2PhuED5JxvIB1A/sBZFHp5VBpeTrFW8Rj7FDJGxZvu4
         /r+RhEOQt+Wdh+alBeq04dccJ2eSBLyDXhMIpCuZnOeJbizeZQFGPtZhYQ0oM2cjReFF
         EEKw==
X-Forwarded-Encrypted: i=1; AJvYcCUhvJz7AlH7tR0xjkqRIE/ia7TeaKJ61qRPx/6FLqdJrN9ycgHlSOrJCXiDDvp9PvkqsFkBWwb+3g==@kvack.org
X-Gm-Message-State: AOJu0YzQXjitllIOCBk/VMQvutR4SWRwAZbgJsfim7oVlEnJMPW+yp1I
	vTyOZCrUNqbfhd7r0Hxne5IPaRBsJp8i7PjSMeUSzIM/74cjNuefiA9YV5QrDmmzBMk=
X-Gm-Gg: AZuq6aKnpOr2dgoIvuxz/U2ect3k58tlZ8PRdHApzr/fOA6/4XxToBX+SxvISmP/HBq
	gb03T4mf5QjEyp0Xsw8BQpXlBxqBGoXxRRrAvv0CQKoWHhm2DTXzS4ejpqDiK6Ap17KQ7IR3vBn
	05tixnC6HlpCBH5aMg9++HsC4JU1i64z7B3OFTDUgv1eNZwQ3kCol2VSRuyQKCuPnLReJdt7us7
	zOYo3PgLjwLh5frPYiXnGIPM4rLqkjOP2fb+IAdItgouvM4O6wpe+OxE0igi8gsIjOwoR5p7YFL
	1/rWtX/2CDGQJ+BLPmC8H/VYiRfATYnI9Av3u8Y+MAF/ucuSheErYSyEngBeyY+efUEsTnfK6p6
	/3suIT6tyiI18umw9007A1tQ3jUAKefR4drbLj/jLGTHF5KPSAyoeWc+82rw8t141Xp+F9wJJMF
	A4hhhz+WGzbbYB/VUDuxjNPwFrIgoABCqerZnoOiukaA==
X-Received: by 2002:a05:600c:3e14:b0:483:7783:5363 with SMTP id 5b1f17b1804b1-48398b6e214mr129218225e9.26.1771590691440;
        Fri, 20 Feb 2026 04:31:31 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a74704sm59690480f8f.16.2026.02.20.04.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 04:31:31 -0800 (PST)
Date: Fri, 20 Feb 2026 13:31:29 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZhUIbpWF7z5HOMr@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EE464000E
X-Stat-Signature: 47wdamq9cbghexut9gaufkxyfpzdjrng
X-HE-Tag: 1771590692-661277
X-HE-Meta: U2FsdGVkX1+36AXKmUqNHF6FdYvu6IlVDQjpjONZLvbm9bVoZMKo0ZX/Qz9Y1BCkBvcPKiAkLpdsOaqDx+RLQmP+inS7alpjkNwf0v6BaBEtydzdRCw5/vuPiKU8EJbsU++K0EEhBVrqpEksJIz3hJhkwYULBcaOBcGhBKXbFumguSe2YXK3ypvhd2w9pRXcTlAxG9FOo5xLL5nvkQY0AHYX0EPxa/ITkeFsSapXsOAp5eqJagqyP3xmfMlEv3KJUFQ4FLt/Y6ktsdoIK4V0bIoPLp/E0y4VVFXMP5991wKz6M+LCokOUfQtSdN/322YAQ1HPpWr4XUGehoE9g/elAyFhyrk0ahejlxccEwqVyS+K/BFg8hOnFMbhEiw04LA9i3/k6akwkzTQdgVa4SG22Bg4H55KThL6LQVXEjef0ZJ0niDjMOizFFmh9PjueeLSFyaKY2wAGHp31Yu0vmBx3e4vh1zbWs8NPWS+a+O9DcdNKMQIxbdkHeCJomGwniDvbOyEtFhgltVni1wB/DXdQ6NeU3DTADglBvL5s7YaK/PGjLUKbmzN0GC4oqewuyqqzwqCDE/+sc71nf2ffi6C57Of+8gLo0xObBVuiK7EDzMLkCtF1SlHd3PvEHVCLeMzQ6CVnDpmgwh/VYMRUXDMR5VlFT5cAbGgomAMXVlw1B6gQHCfMJ/6W4iJChnuy6ETZeNPBCIRHUVQD0FhI8vpbs1rZRFua2HgjBWGhmj1nmx3Lb0jgnvmr2GwLoEgyTaL2FVBoMZFiKU5L1C9brAKzw4ZaW3GFey7YedOF59Bx3NdF2FVBpBrRAeC8mZlzQxGuVSmHibzNpZrnNWpB60QNqXQfuVGEopJi0iwC0fkiZxqQy4TvgN1Xph0olEjCnsUdAjx7rob/K1/rELTI9sdr9zszIoKYSN61CZY63UorsTiQn5z7lGVrOJfCpAs4wWeZN/58R3CRduDJ/C5QU
 0NmV56Ga
 xaNCNk7pMx+g16VyJuC/JIRtRZpQ6DljZnRaxYPbL2SKQvdGzQKni7LQFXFDxlcuWaNzZ0ExdPr0er7IQ81treFOSu2KJUlW83rPDnhPZQNqA/MXX4J2zmIgVru5iqFt3cUlDb1273rXGSvOFwbamyqeO4MtNvs8tY5AYM9tQYVFTu4UBcp6B2gSG8sYVb5gX3UOsHcHPRkSoB+ILAKU5F3vfCUu7gL1H4cAxxOljaF+mf4GbCRASHxB61CEJwnPVd13uOCwp2UTLtJWV+/9DGMycgB+RymaEfDOITbgFnQfD535orSfD/UQZPjlFWfu28zGT1pitydbV8dlOvGZnUZ02by6Br9UeyritKlSZLHEBHp7zlQX0XG+jtKR7LfdAjQxgPb0HQ6zbPjI42dVnygDE9ktw25/9DIZYkP3QQqW9IcE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-02-26 11:48:00, Vlastimil Babka wrote:
> On 2/19/26 16:27, Marcelo Tosatti wrote:
> > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > 
> > Michal,
> > 
> > Again, i don't see how moving operations to happen at return to 
> > kernel would help (assuming you are talking about 
> > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> > 
> > The IPIs in the patchset above can be deferred until user->kernel
> > transition because they are TLB flushes, for addresses which do not
> > exist on the address space mapping in userspace.
> > 
> > What are the per-CPU objects in SLUB ?
> > 
> > struct slab_sheaf {
> >         union {
> >                 struct rcu_head rcu_head;
> >                 struct list_head barn_list;
> >                 /* only used for prefilled sheafs */
> >                 struct {
> >                         unsigned int capacity;
> >                         bool pfmemalloc;
> >                 };
> >         };
> >         struct kmem_cache *cache;
> >         unsigned int size;
> >         int node; /* only used for rcu_sheaf */
> >         void *objects[];
> > };
> > 
> > struct slub_percpu_sheaves {
> >         local_trylock_t lock;
> >         struct slab_sheaf *main; /* never NULL when unlocked */
> >         struct slab_sheaf *spare; /* empty or full, may be NULL */
> >         struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
> > };
> > 
> > Examples of local CPU operation that manipulates the data structures:
> > 1) kmalloc, allocates an object from local per CPU list.
> > 2) kfree, returns an object to local per CPU list.
> > 
> > Examples of an operation that would perform changes on the per-CPU lists 
> > remotely:
> > kmem_cache_shrink (cache shutdown), kmem_cache_shrink.
> > 
> > You can't delay either kmalloc (removal of object from per-CPU freelist), 
> > or kfree (return of object from per-CPU freelist), or kmem_cache_shrink 
> > or kmem_cache_shrink to return to userspace.
> > 
> > What i missing something here? (or do you have something on your mind
> > which i can't see).
> 
> Let's try and analyze when we need to do the flushing in SLUB
> 
> - memory offline - would anyone do that with isolcpus? if yes, they probably
> deserve the disruption
> 
> - cache shrinking (mainly from sysfs handler) - not necessary for
> correctness, can probably skip cpu if needed, also kinda shooting your own
> foot on isolcpu systems
> 
> - kmem_cache is being destroyed (__kmem_cache_shutdown()) - this is
> important for correctness. destroying caches should be rare, but can't rule
> it out
> 
> - kvfree_rcu_barrier() - a very tricky one; currently has only a debugging
> caller, but that can change
> 
> (BTW, see the note in flush_rcu_sheaves_on_cache() and how it relies on the
> flush actually happening on the cpu. Won't QPW violate that?)

Thanks, this is a very useful insight.
 
> How would this work with houskeeping on return to userspace approach?
> 
> - Would we just walk the list of all caches to flush them? could be
> expensive. Would we somehow note only those that need it? That would make
> the fast paths do something extra?
> 
> - If some other CPU executed kmem_cache_destroy(), it would have to wait for
> the isolated cpu returning to userspace. Do we have the means for
> synchronizing on that? Would that risk a deadlock? We used to have a
> deferred finishing of the destroy for other reasons but were glad to get rid
> of it when it was possible, now it might be necessary to revive it?

This would be tricky because there is no time guarantee when isolated
workload enters the kernel again. Maybe never if all the
pre-initialization was sufficient. On the other hand if the flush
happens on the way to userspace then you only need to wait for the
isolated workload to return from a syscall (modulo task dying and
similar edge cases).
 
> How would this work with QPW?
> 
> - probably fast paths more expensive due to spin lock vs local_trylock_t
> 
> - flush_rcu_sheaves_on_cache() needs to be solved safely (see above)
> 
> What if we avoid percpu sheaves completely on isolated cpus and instead
> allocate/free using the slowpaths?

That seems like a reasonable performance price to pay for very edge case
(isolated workload).
-- 
Michal Hocko
SUSE Labs

