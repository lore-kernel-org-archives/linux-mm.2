Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B19F606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QlUbauQ6
Received: by kanga.kvack.org (Postfix)
	id 401506B05B9; Mon, 26 Oct 2026 11:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8DF6B05BC; Mon, 26 Oct 2026 11:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE556B05BD; Mon, 26 Oct 2026 11:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08B516B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:59:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 993371C40F4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:59:43 +0000 (UTC)
X-FDA: 85365237846.25.7F30E8A
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id C56D440002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:59:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QlUbauQ6;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030381;
	b=S5tDpQLHwo8SkGYNTtmxWXqKh/MbUElOH5xIiwFjG9tVLcK0z4uWWJXPX4zGNV1uFeQykB
	tNLdCcrD8UeSll0J4cahWz1mBFwguKjw80DFOjtj3ataFbrocQ6ClWjazIQ8btwe7RRdDv
	/flqeXg7ab8yM7jsH6dzCm7IJRpYEEM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QlUbauQ6;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyFiso9+UY01nOzc02SOL/HPcXdIU5ZZ9sXDmMwwpGg=;
	b=LLBmruDvL97uNG5DVmhTJE4ZEjsGqgZCdIn86vzhXabcAyXBDNgUt9OnSkt7R+pV3h1Ofo
	nd63579JYr/Odo0X3Fst6eg/1Gll6Dotiq3fJQQ0pgUNyk7jwnYFCeyxXPMVFUueTw2k1j
	6AehZE7Wa6ngK/KpfByOpIh4V2z8rmI=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8726acc5eadso23861107b3.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793030381; x=1793635181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fyFiso9+UY01nOzc02SOL/HPcXdIU5ZZ9sXDmMwwpGg=;
        b=QlUbauQ64ckwry2vh3EpyyEPGfHLFlc/ZpiMuEYZ5HBJs4LOO0zfn0Mneug3eYxveW
         B8lfUxLcEswnB1z3mJ72ugYGSUA0ORi/aHLbB4/Ernes3QAvFnjqQbSTOA/tE4EIoMfW
         xpp44pHr6qlou+bZqLiLM6QKfEU5c0gTxVfq330oNR0LDjW7vv8Dpkw2rBQgvI+EoHxf
         Xx63uXwXadxuW9RIJofTnTpUMZafURZSlhKvZwwizYQhUkKRLPsenR58UgCz1jEVwu1u
         KGH+Y+7DJRbgC1SurtpKclq9XTNyHb70jr1Wiep48QLK2OVeCwW2lfFlNVDD32y0/9le
         glYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793030381; x=1793635181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fyFiso9+UY01nOzc02SOL/HPcXdIU5ZZ9sXDmMwwpGg=;
        b=Dmsw7kzffQRNG65xNbAMxyjI80Kpz70s/VzcouNdhZkjujbVgqFWQ33hKi0b9iuE4w
         SVf7fTyQr9Cj/lEcgUy8KdLIotRmzVe1SRRHWB2rRQXMjRRfF4zgxkORYclH+y9CuXTe
         MGMzL0Z4OZPP1ez9dOxWebLlNz5jTNTXTjG3yaHvlLl80yRWgX4/StI8jQ20QbC0GE0p
         KW0hgpedN2N7luA3BZ7cJIUS5AnDfGdlmv8WKBPfOGGTZ1yIVMuDQa3dIPRA1M08m5B3
         Obd+VlsmaBv+AeUnAaGGUljeV6B/sq8zdD6OMTbD79DPr17zyc82/ke6PuqgGrtxrrxn
         5qkQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7WsvtnHIO1vq8xbtatWsexmuG949AY3pKCS9xkZT+IUf8SLKaNpLpJPE78HqWnh/RoGbuXbZRug==@kvack.org
X-Gm-Message-State: AFq9FYKvZl7KNNcGidSJ+W0RDP8HLvr6VSWtWRNf5XJDPgyY1bCEkxzh
	3a5qP/Ro8rVaD0GyNbrhIH2oTARISGNr4ik51S+zEfwfwCEUNc5g6gS+
X-Gm-Gg: AYBFou298cln7ZvQy/EziTjZkyfhrZTLGLDXR/HWU1lQa7VV9LCD0F6BJ69sPUNFeA3
	SX62huDydx+dQNylpCovv6KJYXEKReNYwID//t/BaThfxGrT18VBAeEaa+L8yhB9PoYaXXG0641
	1eA5rSsW+l7uipr53Z2Jo7ePrIq9r5STBPVeYmLO8nEAqDNDb2Bx/486glt+EgtWNlJ7SK/j6hJ
	oF3nv8Z5spgQcIhOsplKfY7CW1bpf1/nHGaXjQoFOXQzwQbZou4iziarYShD+TNf+xuDbsYGT7X
	ce6xqNWYY1lgeOki1tyav19BiCcNpL/7CYUI379JJRPSrK+eSJv/B3z/9/8q33Je/aJZf0tD46I
	tULwwoDRQpnsJQt4NVU9ed8mWx7m/lfANgv7IWZ0wq6EuDStDiYxT8ngSfxA0SF9G2W20iGn29a
	EToqxQXU6aan/8ps/Ks22XRiPBqY7mu4oTf6fTqY+etajeZusZX80gnPvyI+PAMMB6g2RwvIr1k
	SaL6mKgI1Qa6a4NeEiYtMFUNH4Me4T6yAaAX8QgfVNqw+NA+qHWmRuwszxRXYUXGw1U1kzKKLtc
	d+KHKTSfCQI=
X-Received: by 2002:a05:690c:e3cc:b0:8b0:d4bb:c9e7 with SMTP id 00721157ae682-8b166c476edmr51979547b3.46.1793030379764;
        Mon, 26 Oct 2026 08:59:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b166dd01c0sm32803247b3.7.2026.10.26.08.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:59:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Mon, 26 Oct 2026 08:59:37 -0700
Message-ID: <20261026155937.1235453-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <at8XfoqWwe9HSL9y@tiehlicka>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C56D440002
X-Stat-Signature: b5ch6i8fz1oakaziq3c5fdt9j13e1a1t
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793030381-373324
X-HE-Meta: U2FsdGVkX191CBjLv/xwMyCoUz7uNvKUlrGgq4mpWz8WYVrsd0CCQarTqDSDESRgUCa9bXUjZOjF3ZIY0U8AdIBjeT0nrw+ZYiTdz0Ms+PT2emkIqIlZ4Ff8tr9TYsjmHaiBSICaKBZOxM/O3Li9+REMyBFNNwTQT0yPFmpKgc3oEPuHa0T0M5kBFjTT9ktjSx+iTivjbwfCNyNclPU7DWVAWys/rmYd2peeePge/EKzmoWxC0AgvrsjeiU/5bZoZmfKGzMW2rtMVMELz4+oCr3dEYQVP8VMCokTjWFSyS4emzTEune+mUgo3TWrapvrbbs4SFJOZNuYVQS05qvo6jSU+jy7PSjnC77DzgLOP6GKr+AcXwNotss/0G1bUAqrZa9U35WHIsmCv05lrEy+j3wzimQw8+NMTu6B77AjqV6OKu2Uu5u418+czTj06AKZ/uu4/K+ABvO7O9XG9uSQ9AdqSqn2KD5rUtmXrVK338cAcB/rZri31LhUPQnGlI9SypLNHYQNg9UNTKhJ/r3lWUq/LqdvZatGdWF+UQLZbm785l+c0SLENX+Jv8lWSxOvChW1Y+HSpLBe3GLuPYixNni+bFpZZGy0bNDAxAWfxgO0emRP5ESh8j52DUqUaPFWRyS/O6TTd4DmW90Z/Q+M5e6cMrwej2FKAPk5fNoPej4+MCEevAz7peoKr8jBGxA4aa6yv/nzmwOga18fOP0TGG+FF3reKWUg7IxuLPi11rXvibfm9/QbszYhPfWggU8aZWRkoqKghxgSCWywAxuxADQYNcQFsC75MPSBqY/p36v9gdfgaJnDRS9ztVcTqGz5xKxbIU2nsrg+v6MdkF2eutp6EY10B77YcUgQI1qnhCWgEutrbPwzMfMw1WpRnE9TFjVkgYhSxOL51cxiC8Xoakw1hPRwp4uPFYdr6//ZbVYz81O9fN2U0zEy9JOlAmsz2aRNsB8FBmVn4/TDRVq
 54wsf6Bu
 SaHFwh2+lmM5b0gX/uMOMhNF3F83Ox0VxinwqE8C9uHDjnY8vic+nY9auP0qcdFa8n9D7eDPk1utU6TMmMhe1H5k219Q2saP+cz2gwxCq+jZ+LYGZ4jeZiJeR4nFKUb/j/AHbG+K9WqM5pmuHKyZRtyRW1S+PWE5ZES/oobhU9IGd69FskF0NNJaRkJPXFJQqF6RehhQ9Cr/+FOnQ+NgD9gW1vExNPCtI1ImHIuhtEfkpoK4UhworU3DHce0NbFo9S0N7DtWSy4zj+TzFo2LOK2ewu0RdlhBUJCKvzrUHtL3ohLu52fEYhnkl0toISsHEVwrmQM4GdfuELZ6uYgp9k+s57uhWSkXBzLVyipvznccGGuHQYGJVg3Nq7Hb/OQRTD9LNyANFPmH7mziUt3bQUXb9AjIGnI+5BnI6+HOx3qE4JvhiogAfsree5plBPPg0xWTwTD2j+LBpOjrk3LlUCJMDHD+aQZ96xWomX2tAIHzSCwylesl9LZ7+KvHwCUIcU//VVHnMlOuILYIWX1MaTBo1+ykRPdVksSXfhTpVHvUCPtPmiTBIps13JQlPGdSwznMFh42+K6KNvGPhshvPDyNuYX0yU9ZuSGXGSYXodOamU78OHffto6rLqxdT6W+b+5jz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 10:03:58 +0100 Michal Hocko <mhocko@suse.com> wrote:

> [Sorry for coming to this really late]

Hi Michal, no worries at all : -) Thanks for taking a look!

> On Wed 21-10-26 15:55:09, Joshua Hahn wrote:
> > v6 --> v7
> > =========
> > - Preserve two cgroup v1 proprerties that previously followed implicitly
> >   from sharing a stock:
> >   - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
> >   - Reclaim does not swap when memory and memsw have equal limits.
> > - Wordsmithing commit messages for 4/5 and 5/5 to document the
> >   cgroupv1 divergence (bounded) between memory and memsw caused by
> >   independent stock.
> > 
> > INTRODUCTION
> > ============
> > Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> > allocations do not walk the page_counter hierarchy every time.
> > Today, the stock implementation is within memcontrol code, even though
> > the operation it caches is a page_counter charge. This makes it
> > difficult to add new page_counters to a memcg and preserve the fast
> > path behavior.
> > 
> > This matters for future work like my tiered memcg limits series [1]
> > which introduces multiple new page_counters to memcg. Without making
> > stock a page_counter-level property, it means that every memcg charge
> > now goes through multiple page_counter hierarchy walks, instead of
> > being able to cache these charges.
> > 
> > To make future page_counters scalable and performant, move stock from
> > mem_cgroup to page_counter so that each page_counter can opt into its
> > own per-CPU cache of pre-charged pages.
> 
> What does it mean that each counter can opt into its own per-cpu
> caching?

So right now for cgroupv2, there's kind of a 1-1 mapping between
page_counter and memcg. I say "kind of" because there still is a
page_counter for swap, but it takes a completely different charging
path (i.e. not try_charge_memcg).

This means that currently stocking charge for memcg is equivalent to
stocking charge for the memcg->memory page_counter.

However, one of the series that I'm currently working on [1] adds new
page_counters to struct memcg to track the usage of memory
per-memcg, per-tier. The goal is to (1) track how much memory of a
cgroup lives on which tier, and (2) to limit the usage so that a single
cgroup doesn't use up all the fast tier memory alone, and shares it
fairly with all the other cgroups on the host.

When adding a new per-tier page_counter to struct mem_cgroup that gets
charged for every memcg_charge, I cannot use the stock fastpath since
the stock does not distinguish where the memory resides. It would
essentialy boil down to this pattern:

try_charge_memcg
   \__ page_couner_try_charge(memcg->tier[0])
   \__ consume_stock()

Where every path still has to do a hierarchy charge to the tier it's
charging to, whereas this patch gets us:

try_charge_memcg
   \__ page_counter_try_charge(memcg->tier[0])
          \__ consume_stock(memcg->tier[0])
   \__ page_countertry_charge(memcg->memory)
          \__ consume_stock(memcg->memory)

So that we can avoid the hierarchy walk for most charges.

I'd be happy to submit a new cover letter which better explains this
idea!

> > We get an added benefit of simplifying try_charge_memcg(), which now
> > has all the stock management handled transparently within the
> > page_counter layer.
> 
> This is quite a large change and I believe it will be really benefitial
> to have some high level design overview in the cover rather than trying to
> chase it in respective patches.

Sounds good with me. I can add the call traces above which should
explain my thought process a bit more. Hopefully the problem I am
trying to solve is evident there.

> Namely, are there any changes to the locking (which is arguably quite
> tricky to allow completely lockless fast path)?

No changes to locking. In fact this series is mostly just moving code
from mm/memcontrol.c to mm/page_counter.c, everything is essentially
the same. 

> Also what are implications to caching at different levels of the
> hierarchy? An example of cache propagation up/down the hierarchy during
> charge/uncharge/draining would be really useful to wrap ones head around
> how this is supposed to work.

This series should not have any changes for cgroup v2, including when
and where the cache is stocked / drained in the hierarchy. I can
include a snippet on how stocking currently works to add a visual
explanation, if that helps too.

> > EFFECT ON MEMCG V2 USERS
> > ========================
> > This series has no functional changes intended for memcg v2 users. We
> > preserve all draining, refilling, and (un)charging behavior, including
> > the uncharge path's refills / direct uncharges.
> > 
> > EFFECT ON MEMCG V1 USERS
> > ========================
> > For memcg v1 users, the decoupling of the memsw and memory stock means
> > that each of them now manage their own independent stocks and can lead
> > to a different size of precharged cache for each.
> > 
> > Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
> > than or equal to memory.usage_in_bytes, because memsw is a superset of
> > memory. With separate stocking, this could have been broken in scenarios
> > where the memory stock is bigger than the memsw stock, leading to
> > memory usage appearing to be inflated and greater than memsw usage,
> > even though the real usage preserves the invariant.
> 
> How can this happen when counters are always charged together?

Yeah, so this part is a little bit annoying. Let's just look at a single
leaf cgroup for example, where the limit for memsw and memory are both
64 pages.

charge_memcg(64)
	raw memory: 64			raw memsw: 64
	reported memory: 64		reported memsw: 64
	memory stock: 0			memory stock: 0

swap out 32 pages
	raw memory: 32			raw memsw: 64
	reported memory: 32		reported memsw: 64
	memory stock: 0			memsw stock: 0

free 32 pages
	raw memory: 0			raw memsw: 32
	reported memory: 0		reported memsw: 32
	memory stock: 0			memsw stock: 0

charge_memcg(1)
	raw memory: 1			raw memsw: 33
	reported memory: 64		reported memsw: 33
	memory stock: 63		memsw stock: 0

Where the last charge_memcg() causes the inversion. memsw tries to
charge a batch of 64 to refill the stock, but fails since 32+64=96
puts the memsw over its max limit. So it falls back to direct charging
where it charges the page_counter directly, and ends up with 0 stock
and reporting a usage of 33.

On the other hand, memory will greedily refill the stock with 64 pages
and since usage is 0, the batch refill will succeed, and it will report
a usage of 64.

So the idea with reporting the minimum is to report the minimum of the
two reported values, we will just fuzzily report the stocked value.
IIRC usage_in_bytes has always been fuzzy anyways, due to how much
memory has been stocked.

Thanks again for taking a look, Michal! I hope you have a great day : -)
Joshua

> -- 
> Michal Hocko
> SUSE Labs

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

