Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C36F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524316B0088; Mon, 13 Apr 2026 11:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BEA16B0095; Mon, 13 Apr 2026 11:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348816B0092; Mon, 13 Apr 2026 11:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24E6D6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:28:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0A321B70E1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:28:40 +0000 (UTC)
X-FDA: 84653914800.13.99DDBA4
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7BF8C000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:28:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OWvjARud;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wet7hLRLN2GT7pig65ujdZ2ffuA5bew4whWaQBopYTA=;
	b=a1vE8yqI77Vzngzxhsm+AHhYzkMzhQwlmATFYoJdsHr6QfCgrpWMe1/65Lfo3cvdy0MRDm
	rw9R7scX2FS0ryO43zF72C0gDjvSZK9Rmt1QBYNT3EcBwmLMVu4jTls2Elwp0hsQQlk4wC
	BvtSLNSK9Q+//T0+hdc5+dHfxD+ZHQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094119; a=rsa-sha256;
	cv=none;
	b=6nUYGPPlkLLN381pK7vSNFhJPG4HKf1hq8HZ5q0P0131q+2ARWtqhDxVxOUAM8LVb0GdIV
	NgWp1R6R/S4vd/9ExCa/1o/WH6Sv3fxqqC0S6E13PfD9IyuKLJzfa2/aoty/2SCQG0UOlh
	DXlkyvMI6uyzDN4/1KrUg3wY6sqE69E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OWvjARud;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488b8efed61so43857825e9.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776094117; x=1776698917; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wet7hLRLN2GT7pig65ujdZ2ffuA5bew4whWaQBopYTA=;
        b=OWvjARud+D8QaZMuJ93APMlYh8DFOL84V2aGcg1wxRcSx0XxfAuVjTpYEGpdsZ0u5i
         4yy/OQb/X27bLvkL/7fq3yWFcnIDu+3dtSAadpmQThNfP7Tl7LmIz5kbw0BkkJZTr7YG
         fKhJLxmJ51PsJvDPiWu6KyX3jjQbYs3At9sHlvJ+OQanpV28PF4Z48Zrvu+KkHVZlY/R
         0Jb0kqm3FkapvyFbYV3AYHFMpoT03J917tRz51TiosKLGMUjVTEqJRrQLoGw5gHYlo0G
         v7poh3oKlczAILBdpiAkFbz5Ykf8kbh1I+/GGFTAIMhiTiE2h4AV8tIabCBkzC4OuG0l
         2Hsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776094117; x=1776698917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wet7hLRLN2GT7pig65ujdZ2ffuA5bew4whWaQBopYTA=;
        b=PzWsoZ2JpFqPHwv8NG5J9ADqAe3xxWDyyfzfmDA9x9pURbIffqR/P19QF8nK7G7a5M
         Jhat66i4kBNNqhcslyVUYBDyRIFlx2ba2VxoxtC85i0nQXOlhk8nKOtU9vIFghVqwro8
         0ZGG7qR51zNMFP+TU0+2wlkA1IF+jGMCcVL+FnQ0G5o3BGJhyBhe1/IcksFuDp0Zti/s
         PCSWJMM1+9j2xh0geh8uzLVxkYAywsrxwhnJzoy3guKyTL+ZeXd70NbFY2KJN04OuTaC
         GBy/MRQ1+zHKa0nvaghSpRWwrFEBfHDR/PyNy3UdNXGH60a54wHWnOxK3Mbl8r9F3rPb
         iKiA==
X-Forwarded-Encrypted: i=1; AFNElJ9GMYxnmLONZFv4TyHfdDcgMTJkVha0oIr14Nq55xAXY+AuhCgpG7QnwqXLM2L/B2/cCylM4vFgCQ==@kvack.org
X-Gm-Message-State: AOJu0YxFdk08kj91dEDPfBVboTvtZFU3DIVEnRRo9CfnUuERJXxfVPDI
	3bli1hsoufT0lvK00H4M+d+0wSKtGQ7Fo42LSTUO8RvxnkfKs/nPTKelypul0V9EyKM=
X-Gm-Gg: AeBDiesVr9Ub0akqQgEXInGCukRAYb4LPQS1WjkFNG8rYzDVpHDuSicZaL5BTzjhU8Z
	6Y2VSSQpdEp6txm+8wHKsPQSHSnBRiR6ClQMid6mQrhllF32nCNJdjg65dgD6z/WNG/hpWpswv1
	9tg/W1ostPBRp1SvsmWQTTl1ObIIhe6WgEsYf1V+Yna+TsaE3gwf6uGQw7y8fnBC2IBzU83766S
	AsFqZTulGkdHMcQ5Vj5liZtAtoQoVlEMv45A3NcR5DpYcCWXVQlkJuiToWRrJk2NHpaaFKBVr9t
	BczhLrzTkJWM1NG2AWbAuZ3z7Ld22PxOboxvxEDsSNNHA0nHcXk4KVVyjAmQtRGa16hTx78Uaiv
	lZdDv5ZaaGX075qgYxuPrlqKjhS1dW6284eChE4kbAkpIUEPkTjuLYGw2VTtmdeUxu1oPz2VHZ/
	fqo7hMRXUO7hvcZj6kEzxWRZj34HXmWa/b0dIUBUKMtYLK
X-Received: by 2002:a05:600c:154d:b0:485:3989:b3e4 with SMTP id 5b1f17b1804b1-488d685b6ddmr183708165e9.6.1776094116989;
        Mon, 13 Apr 2026 08:28:36 -0700 (PDT)
Received: from localhost (109-81-29-22.rct.o2.cz. [109.81.29.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67b4903sm128558245e9.5.2026.04.13.08.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:28:36 -0700 (PDT)
Date: Mon, 13 Apr 2026 17:28:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8 RFC] mm/memcontrol, page_counter: move stock from
 mem_cgroup to page_counter
Message-ID: <ad0LoxXjP49PZBwR@tiehlicka>
References: <adyZ-t4fiKFv_X5p@tiehlicka>
 <20260413142958.2037913-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413142958.2037913-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: B7BF8C000E
X-Stat-Signature: jwijfnq1xhwf37ysiusg717zgx1dhrgj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776094118-882807
X-HE-Meta: U2FsdGVkX18U5DpWTDa4FaITA+45prJ3cIiZT6cvgIVsAc4cD8pixnBAfRaK6R5CDvm4fkWWomGbs+kcHsbGMGk91ZQhOG+QFnwJevK93y5NFYgXyKM86nHVm5ovFJFYtGj6EzatA4JRbuLCB+sybFyCA7vFRoacW4VMyUmfLtLN5J6D/1wtMAaaCf5LuhHw2AZsO38s5LDZ1c3Ryty6RpAKqBSUWdUjFS8ZNjCXEK/VQHpVUa41XAczY5n6Or1qTt6SzFQkM62Cv+EoifJ+IMuxw7QtBn8NxOMNIY15MWVwVFI2q6XE52QIRNDo4yh2ydOVJlqdn04BF3foMqc59OdHnv01nZsMyHPNJItL0bkIZcJvMLe+FzknfR/VEYWyxChHYJR+bPwAs5wQRhXk/CFM8PVa/6vS8WzQM3E7XwbLD38kmqasCvnP/jRU4p1cz3jLjHsF2TYacXGunWBgnvNJlC2uisI36pHbzz4RPMbcSbgyRoskxajrpS9sEBtzC/thMHkrEWxQ0hTjK4HU6bOl0LEWpJdSvBYNJd1W8AgbFd191PusLIfhi91YDnFaiptCPFFMcgPOUXiHMLvxK114KszqzBO8jrFLO7HiV1dVBur4x77YnU5E9X0uCmeDCgLEU/CbhRQnc1cW8ht51GJTKySjfjS0jIc5ZmNsGtiMmAdgKB+JZu2E0EB5WqwsRIo5doAZ9cDcP6MOofGwJ8OoHyIcghchkMVCFSoA2RIs3wvZa4pZMEDpO6iWpFY8+VPvzuqls0Xukqh884XIRdq70VrU7kV2Rw9Ki/v3yWbUywIvKinan2zNgxNLCsiZOxp446uqGFqVJUPQRrMoQtDhegTPM8R4iDj9brtKWOvW86lBknZRmbxh+SclusCQWWNLguIi223vj5PJfYzqT4MemgGtckgLC412KDFVmmlWPqdJeNu7/UkdrMZVaCMkgtBxQLUMDKGK4U0Wf+X
 XcW5e8/j
 26qwrK/s4WiPnoWQ/B3cLaPVZW23xecL4b7CR1Osk+oXV9LrbqXX5onHXXgHjd84FApuGgoMGBgG7PRED0e/A3k8w/J1kM+N/F5LC/BZ0O0CgfcRIQL8fsRbK6tGXJg6/k8gtNyEZRlvty+J2xBTQ0nXNMgTfzhx8ZY1gQrZdynRfFSJaQ9PTupzTdlFHsUsG0Zjs5UtTvNJI9YPOJfzjRkNFZFVMWhH2PWSvpnWiMtdopnjXj2F6w9ZjiH9JhuRXLTWRPcQV5/K/il2KvH4QoKcimDjhHhYKktfD9QfJelv5OeVaQv/Mtign4FnrRr5Nmf+Y99aRZpWjZUtONwGrvqc7Y6UxAkRIgh2TiL+8qHxw2nxnZQBZPxRT3O60f1XIClHp4PDqxZVA8skFuZnQYtfewNGWI5zcJ6synMLIPtucg6F06YDKnMUibfRLdDUG8CPEYDAxRSQuuC4cgQKaCt6dDwtkrQ+wVaHnOD6FNk+MXUHqWy7aLadfDSJpjsEomKPSkGBPnrZcqX/1w/5XJCXYTwjVid8qU1FElMM+Dua8J0bWxZvv2GAigN13QRSuE9rEvSzX8Ua/5KRp0oUNylhBfZKnke64j+hQqz9VAUOBEmP8UQAdVaqHDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-04-26 07:29:58, Joshua Hahn wrote:
> On Mon, 13 Apr 2026 09:23:38 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> Hello Michal,
> 
> Thank you for your review as always!
> 
> > On Fri 10-04-26 14:06:54, Joshua Hahn wrote:
> > > Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> > > allocations, allowing small allocations and frees to avoid walking the
> > > expensive mem_cgroup hierarchy traversal on each charge. This design
> > > introduces a fastpath to charge/uncharge, but has several limitations:
> > > 
> > > 1. Each CPU can track up to 7 (NR_MEMCG_STOCK) mem_cgroups. When more
> > >    than 7 mem_cgroups are actively charging on a single CPU, a random
> > >    victim is evicted, and its associated stock is drained, which
> > >    triggers unnecessary hierarchy walks.
> > > 
> > >    Note that previously there used to be a 1-1 mapping between CPU and
> > >    memcg stock; it was bumped up to 7 in f735eebe55f8f ("multi-memcg
> > >    percpu charge cache") because it was observed that stock would
> > >    frequently get flushed and refilled.
> > 
> > All true but it is quite important to note that this all is bounded to
> > nr_online_cpus*NR_MEMCG_STOCK*MEMCG_CHARGE_BATCH. You are proposing to
> > increase this to s@NR_MEMCG_STOCK@nr_leaf_cgroups@. In invornments with
> > many cpus and and directly charged cgroups this can be considerable
> > hidden overcharge. Have you considered that and evaluated potential
> > impact?
> 
> This is a great point. I would like to note though, that for systems running
> less than 7 leaf cgroups (I'm not sure what systems typically look like outside
> of Meta, so I cannot say whether this is likely or not!) this change would
> be an optimization since we allocate only for the leaf cgroups we need ; -)
> 
> But let's do the math for the worst-case scenario:
> Because we initialize the stock to be 0 and only refill on a charge / 
> uncharge, the worst-case scenario involves a workload that charges
> to all CPUs just once, so that it is not enough to benefit from the
> cacheing. On a very large system, say 300 CPUs, with 4k pages, that's
> 300 * 64 * 4kb = 75 mb of overcharging per leaf-cgroup.
>
> This is definitely a serious amount of overcharging. With that said, I
> would like to note that this seems like quite a rare scenario; what
> would cause a workload to jump across 300 CPUs? 

A typical situation I would expect this to be more visible is a large
machine hosting a lot of smaller containers. Not an untypical situation.

Without an external pressure those caches could accumulate a lot. On the
other hand a large machine the overall overcharging shouldn't cause the
memory depletion even if we are talking about 1000s of memcgs. The
behavior will change though and this is something you should explain
in your changelog. There will certainly be cons that we need to weigh
against pros. There are many good points below that you can use.
[...]

> > > 2. Stock management is tightly coupled to struct mem_cgroup, which
> > >    makes it difficult to add a new page_counter to struct mem_cgroup
> > >    and do its own stock management, since each operation has to be
> > >    duplicated.
> > 
> > Could you expand why this is a problem we need to address?
> 
> Yes of course. So to give some context, I realized that stock was a bit
> uncomfortable to work with at a memcg granularity when I tried to introduce
> a new page counter for toptier memory tracking (in order to enforce strict
> limits. I didn't explicitly note this in the cover letter because I thought
> that there was a lot of good motivation aside from the specific use case
> I was thinking of, so decided to leave it out. What do you think? : -)

Yes, if there are future plans that might benefit from this then this is
worth mentioning. Because just based on 1 I cannot really tell whether
going this way is better then tune NR_MEMCG_STOCK. As I've said I like
the resulting code better but there are some practical cons as well.

> I'm not a memcgv1 user so I cannot tell from experience whether this is a
> pain point or not, but I also did find it awkward that one stock gated the
> charges for two page_counters memsw and memory, which made the slowpath
> incur double the hierarchy walks on a single stock failing, instead of keeping
> them separate so that it is less likely for both the page hierarchy walks
> to happen on a single charge attempt.

v1 is legacy and we have decided to not invest into new
optimizations/feature long ago.

> 
> > > 3. Each stock slot requires a css reference, as well as a traversal
> > >    overhead on every stock operation to check which cpu-memcg we are
> > >    trying to consume stock for.
> > 
> > Why is this a problem?
> 
> I don't think this is really that big of a problem, but just something that
> I wanted to note as a benefit of these changes. I remember being a bit
> confused by the memcg slot scanning & traversal when reading the stock
> code, personally I think being able to directly be able to attribute stock
> to the page_cache it comes from, as well as not randomly evicting stock
> could be helpful.

OK so this boils down to code clarity.

> > Please also be more explicit what kind of workloads are going to benefit
> > from this change. The existing caching scheme is simple and ineffective
> > but is it worth improving (likely your points 2 and 3 could clarify that)?
> 
> I think that the biggest strength for this series is actually not with
> performance gains but rather with more interpretable semantics for stock
> management and transparent charging in try_charge_memcg.
> 
> But to break it down, any systems using less than 7 cgroups will get
> reduced memory overhead (from the percpu structs) and comparable performance.
> Any systems using more than 7 leaf cgroups will benefit because stock is
> no longer randomly evicted and needed to refill.
> 
> >From my limited benchmark tests, these didn't seem too visible from a
> wall time perspective. But I can trace for how often we refill the stock
> in the next version, and I hope that it can show more tangible results.

Another points for the changelog.
-- 
Michal Hocko
SUSE Labs

