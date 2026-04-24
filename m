Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEEFAFED3E2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF91C6B00A4; Fri, 24 Apr 2026 11:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA886B00A6; Fri, 24 Apr 2026 11:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99686B00AB; Fri, 24 Apr 2026 11:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2C586B00A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:11:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73C131401C5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:11:49 +0000 (UTC)
X-FDA: 84693789138.07.A98BA60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF99E140004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:11:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kyKaecCZ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZDiHKL9Ii5ZJArgcdLthhax4hBth5WqDKqfrLVvMPE=;
	b=2Ujd/5ROJ1UBl3EUXrC9wNfkGbcuyCdsc6PqeYK7VteiT+3bHJwmqzRAJq8o+4qBIbIxR7
	KhxW1+USHSt1jMyuphyVYIMHNoHvkv7d2hd6NPcck8AIHpPyvRvwY520HVaOzZaMS4QY6i
	QcxjMo99PFE8+pGiNJvBRSx821empT0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kyKaecCZ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043507; a=rsa-sha256;
	cv=none;
	b=7ZVZqtwvG0zY5a5dIxehsoPsgYb6hx05Gq47vwkTx42LBzKDqJB+sO8hjDmNlB9YxAWBFu
	MoJ8sGA1cUkVyBWugTbG9dHYwciUja7n0ZW2eKFnWK4vO+oyCdVJa2G4kqcUUMrHnoVaGS
	xx6ENuvB1iTctxTMjYassR6KR3L/MQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6928600AE;
	Fri, 24 Apr 2026 15:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070EBC19425;
	Fri, 24 Apr 2026 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777043506;
	bh=9+RqmMFlBNXW0TQUXqXjzFnZMxrBJbIBkvK0FcCfowc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyKaecCZWrMobSMG0KveoOGwikyfXdgL5vtfdxePM+XkREFuv8qwiGweOFI8mj5Lb
	 1qNRaFqulP8VPZkWyp10NrlDI8hoCUS9SrIMr51tSqT8nCQxwsK/+/dVjH/EHvJI/M
	 kUhZavxRrUk8gIrT1sD6mWLCt2jKbpUuF/2ix4fYwVbEuy0EjEWUpwQatsrUsD9f30
	 OLaZMJ7GZeSumGk3GJM0r2mYEc/DEFG80Kk6PyZ4sn2gnIlkpE17VD6QPT/OknJevq
	 5Ef8gkHzze8dnfNpie3RPzBR8ZvdakQ9rDZdigXkPWOCEZRDthMaSnhc1PZWzzfOg6
	 xJ0He6uHdkIQA==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx PRNG
Date: Fri, 24 Apr 2026 08:11:37 -0700
Message-ID: <20260424151138.4692-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <eb215ae6-bead-47ef-9c3a-3f4c80d39361@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF99E140004
X-Stat-Signature: wxs1i5zfjmczkmoagd7bm1gm348b3mqx
X-Rspam-User: 
X-HE-Tag: 1777043507-169178
X-HE-Meta: U2FsdGVkX1+ojYjG1qvGKqFBFxlbnl1OMUuFjBB5qEF8BUbGt/crQWka0dx9I7ErS6RJaCR17ntSYPtCY4aqEJss6qyhUf29hJiQsMuutkycbyQSyvn/s3vRdLb3Gv2KvEuj1nKOAVPy4BjzCjsgpmgLjPlY3Svf6iJp4CePFZq1SyP+HalNEPNLi+DpGYgkspriL8go8sIlK6z3YCYQf2xCN/2d47t6UQTYNcx3PjSonfCatqvuo9apcrP4/OCAc/h7TbWZth8rd2vxeKxXdaBkpQGiw1viGnOofCwjntopySudkWEf2dhLzU1VIpg68pYYl7qb6uJNXEpoW6NA2uDJ3rqYBFiKgs3TAK/EuHgipZcZnoOyOo92cQrp83OqLfz3u4oVTnZkFMceL4adnJNkKCHYwjyUz2DCg6OGKKzCDx8SuwQo5icoAgJipJh6BzqPcGbYrUhZh96BUgbKDUNjoQmqfR6Cy2/kVFB++VYOxzYUzY+Pu+q+S3TK52re6mZROzUJvFT4cJdgJYtpPUGfz9cDHZvtszrtgMWHleGNmg404wmTWW5BTbNbXVrMBV9KVdAEzqPvRIXmF78DZQ+df2SAmM3rji4LnmT+zBjn9GmisC5kMIFPkQNEfWi6jUTx8L0ZenXfr2HoZYwuPyM5VLniR0lFN+oIpHpNm5SRnvhrihJT2INgf2OsLpdUkM3eFRZ8m2oU2+uB3+lzr9b00S9nNHiBcaItLUsv+rLdy0Q8G36RHXWkzgScrodxrOZDP5XL42dd+jsDVKhSisJGiZrwoLwJSDV+Xs0BuXoEYX/c90Z2t2NX9p5E/Ymee9jsNATLIy4aR/KIaZXUz8ZSIejFPaWEdjzupCjfsNis5hSWJtcIcWnZrPN8cfR6S2pSPVu4zbxh9cT6zzX4hnHsZleVbk3yn+ZspawwyhfQ/9TM4LN4l5txEHPyWGPIHi9dHa4IKTMAIl0SAZa
 R6YrRFJu
 y6IHdEhCSRvklX1gPLjRKUBMEx0okHIdIT7gUix8UyJ78/bLNx48/lfrrL6+sRl7+edS2x7IwDRcQ9shu8xco41fFrOxXUOB3iizipSJzKdUKocpU07kA0hBdFvdeRWrUKAViOcuRNFjjsHMvHi3lhbY9MNI8L7pjyfo3V3xYXOc4lHb2jMIasphI7VsOyQUdnplQs/PM1dzzLkl+YlX6jG7gSFkMmu6n9DSwlpQ9e2AGfEf3HdOL++DCiU0VPevmu6upm3MADil1U4Blyy/5ZHFzfEzgWnq7E05hZ0obJLIVJgD6oSxXsKVGfKAYgWX1bq/V1RPhwRN3Yp7a4ew4i09kFVi7X+v2gSxNG2U74shaSOckjCjxBDIQary1lqFUGw688/4Nhrtj7Jf56giPyuoXn7g9p6PggOiD7aMBeWDTXqZp7D6LzmjzYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 10:29:58 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> Hello SJ,
> 
> Thank you for the review.
> 
> On 4/24/26 9:36 AM, SeongJae Park wrote:
> > Hello Jiayuan,
> >
> >
> > Thank you for sharing this patch with us!
> >
> > On Thu, 23 Apr 2026 20:23:36 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >>
> >> damon_rand() on the sampling_addr hot path calls get_random_u32_below(),
> >> which takes a local_lock_irqsave() around a per-CPU batched entropy pool
> >> and periodically refills it with ChaCha20.  On workloads with large
> >> nr_regions (20k+), this shows up as a large fraction of kdamond CPU
> >> time: the lock_acquire / local_lock pair plus __get_random_u32_below()
> >> dominate perf profiles.
> > Could you please share more details about the use case?  I'm particularly
> > curious how you ended up setting 'nr_regiions' that high, while the upper limit
> > of nr_regions is set to 1,0000 by default.
> 
> We use DAMON paddr on a 2 TiB host for per-cgroup hot/cold page
> classification.  Target cgroups can be as small as 1-2% of total
> memory (tens of GiB).

Thank you for sharing this detail!

Could you further share me what do you do with the hot/cold information?  We
found some people want to use DAMON for proactive cold pages reclamation but
they watned to use it for only file-backed pages, and therefore developed page
level DAMOS filter.  In a similar way, if we know your detailed use case, we
might be able to serve you better by finding not well advertised features, or
developing a new features.

> 
> With the default max_nr_regions=1000, each region covers ~2 GiB on
> average, which is often larger than the entire target cgroup.
> Adaptive split cannot carve out cgroup-homogeneous regions in that
> regime: each region's nr_accesses averages the (small) cgroup
> fraction with the surrounding non-cgroup pages, and the cgroup's
> access signal gets washed out.

But, pages of cgroups would be scattered around on the physical address space.
So even if DAMON finds a hot or cold region on physical address space that
having a size smaller than a cgroup's memory, it is hard to say if it is for a
specific cgroup.  How do you know if the region is for which cgroup?  Do you
have a way to make sure pages of same cgroup are gathered on the physical
address space?  If not, I'm not sure how ensuring size of region to be equal or
smaller than each cgroup size helps you.

We are supporting page level monitoring [1] for such cgroup-aware use case.
Are you using it?  But again, if you use it, I'm not sure why you need to
ensure DAMON region size smaller than the cgroup size.

Fyi, I'm also working [2] on making the cgroup-aware monitoring much more
lightweight.

> 
> Raising max_nr_regions to 10k-20k gives the adaptive split enough
> spatial resolution that cgroup-majority regions can form at cgroup
> boundaries (allocations have enough physical locality in practice for
> this to work -- THP, per-node allocation, etc.).  At that region
> count, damon_rand() starts showing up at the top of kdamond profiles,
> which is what motivated this patch.

Thank you for sharing how this patch has developed.  I'm still curious if there
is yet more ways to make DAMON better for your use case.  But this patch makes
sense in general to me.

> 
> 
> > I know some people worry if the limit is too low and it could result in poor
> > monitoring accuracy.  Therefore we developed [1] monitoring intervals
> > auto-tuning.  From multiple tests on real environment it showed somewhat
> > convincing results, and therefore I nowadays suggest DAMON users to try that if
> > they didn't try.
> >
> > I'm bit concerned if this is over-engineering.  It would be helpful to know if
> > it is, if you could share the more detailed use case.
> 
> 
> Thanks for pointing to intervals auto-tuning - we do use it.  But it
> 
> trades sampling frequency against monitoring overhead; it cannot
> change the spatial resolution.  With N=1000 regions on a 2 TiB host,
> a 20 GiB cgroup cannot be resolved no matter how we tune sample_us /
> aggr_us, because the region boundary itself averages cgroup and
> 
> non-cgroup pages together.
> 
> So raising max_nr_regions and making the per-region overhead cheap
> are complementary to interval auto-tuning, not redundant with it.

Makes sense.  I'm still not sure how it helps for cgroup.  But, if you do want
it and if it helps you, you are of course ok to use it in your way, and I will
help you. :)

> 
> >> Introduce damon_rand_fast(), which uses a lockless lfsr113 generator
> >> (struct rnd_state) held per damon_ctx and seeded from get_random_u64()
> >> in damon_new_ctx().  kdamond is the sole consumer of a given ctx, so no
> >> synchronization is required.  Range mapping uses Lemire's
> >> (u64)rnd * span >> 32 to avoid a 64-bit division; residual bias is
> >> bounded by span / 2^32, negligible for statistical sampling.
> >>
> >> The new helper is intended for the sampling-address hot path only.
> >> damon_rand() is kept for call sites that run outside the kdamond loop
> >> and/or have no ctx available (damon_split_regions_of(), kunit tests).
> >>
> >> Convert the two hot callers:
> >>
> >>    - __damon_pa_prepare_access_check()
> >>    - __damon_va_prepare_access_check()
> >>
> >> lfsr113 is a linear PRNG and MUST NOT be used for anything
> >> security-sensitive.  DAMON's sampling_addr is not exposed to userspace
> >> and is only consumed as a probe point for PTE accessed-bit sampling, so
> >> a non-cryptographic PRNG is appropriate here.
> >>
> >> Tested with paddr monitoring and max_nr_regions=20000: kdamond CPU
> >> usage reduced from ~72% to ~50% of one core.
> >>
> >> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> >> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> >> ---
> >>   include/linux/damon.h | 28 ++++++++++++++++++++++++++++
> >>   mm/damon/core.c       |  2 ++
> >>   mm/damon/paddr.c      | 10 +++++-----
> >>   mm/damon/vaddr.c      |  9 +++++----
> >>   4 files changed, 40 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >> index f2cdb7c3f5e6..0afdc08119c8 100644
> >> --- a/include/linux/damon.h
> >> +++ b/include/linux/damon.h
> >> @@ -10,6 +10,7 @@
> >>   
> >>   #include <linux/memcontrol.h>
> >>   #include <linux/mutex.h>
> >> +#include <linux/prandom.h>
> >>   #include <linux/time64.h>
> >>   #include <linux/types.h>
> >>   #include <linux/random.h>
> >> @@ -843,8 +844,35 @@ struct damon_ctx {
> >>   
> >>   	struct list_head adaptive_targets;
> >>   	struct list_head schemes;
> >> +
> >> +	/*
> >> +	 * Per-ctx lockless PRNG state for damon_rand_fast(). Seeded from
> >> +	 * get_random_u64() in damon_new_ctx(). Owned exclusively by the
> >> +	 * kdamond thread of this ctx, so no locking is required.
> >> +	 */
> >> +	struct rnd_state rnd_state;
> >>   };
> >>   
> >> +/*
> >> + * damon_rand_fast - per-ctx PRNG variant of damon_rand() for hot paths.
> >> + *
> >> + * Uses the lockless lfsr113 state kept in @ctx->rnd_state. Safe because
> >> + * kdamond is the single consumer of a given ctx, so no synchronization
> >> + * is required. Quality is sufficient for statistical sampling; do NOT
> >> + * use for any security-sensitive randomness.
> >> + *
> >> + * Range mapping uses Lemire's (u64)rnd * span >> 32 to avoid a division;
> >> + * bias is bounded by span / 2^32, negligible for DAMON.
> >> + */
> >> +static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
> >> +					    unsigned long l, unsigned long r)
> >> +{
> >> +	u32 rnd = prandom_u32_state(&ctx->rnd_state);
> >> +	u32 span = (u32)(r - l);
> >> +
> >> +	return l + (unsigned long)(((u64)rnd * span) >> 32);
> >> +}
> > As Sashiko pointed out [2], we may better to return 'unsigned long' from this
> > function.  Can this algorithm be extended for that?
> 
> Sashiko is correct that (u32)(r - l) truncates spans greater than 4 GiB.
> 
> This is a pre-existing limitation of damon_rand() itself, which
> passes r - l to get_random_u32_below() (a u32 parameter) and
> truncates the same way.  My patch makes that truncation
> explicit but does not introduce a new bug.

You are 100% correct and I agree.  Thank you for making this clear.  I should
also mentioned and underlined this in my previous reply, but I forgot it.

So I think this patch is ok to be merged as is (after addressing my nit trivial
comments about coding styles), but we may still want to fix it in future.  So I
was wondering if such future fix for this new, shiny and efficient function is
easy.

> 
> We can restrict the region size when config or just allow spans greater 
> than 4G.
> 
> static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
>                unsigned long l, unsigned long r)
> {
>        unsigned long span = r - l;
>        u64 rnd;
> 
>        if (likely(span <= U32_MAX)) {

I think we could drop 'likely' and hope compiler or hardware branch prediction
to be smart enough.

>                rnd = prandom_u32_state(&ctx->rnd_state);
>                return l + (unsigned long)((rnd * span) >> 32);
>        }
>        rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
>              prandom_u32_state(&ctx->rnd_state);
> 
>        // same as 'l + (unsigned long)((rnd * span) >> 32);'
>        return l + mul_u64_u64_shr(rnd, span, 64);

Makes sense to me.

> }
> 
> 
> >> +
> >>   static inline struct damon_region *damon_next_region(struct damon_region *r)
> >>   {
> >>   	return container_of(r->list.next, struct damon_region, list);
> >> diff --git a/mm/damon/core.c b/mm/damon/core.c
> >> index 3dbbbfdeff71..c3779c674601 100644
> >> --- a/mm/damon/core.c
> >> +++ b/mm/damon/core.c
> >> @@ -607,6 +607,8 @@ struct damon_ctx *damon_new_ctx(void)
> >>   	INIT_LIST_HEAD(&ctx->adaptive_targets);
> >>   	INIT_LIST_HEAD(&ctx->schemes);
> >>   
> >> +	prandom_seed_state(&ctx->rnd_state, get_random_u64());
> >> +
> >>   	return ctx;
> >>   }
> >>   
> >> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> >> index 5cdcc5037cbc..b5e1197f2ba2 100644
> >> --- a/mm/damon/paddr.c
> >> +++ b/mm/damon/paddr.c
> >> @@ -48,12 +48,12 @@ static void damon_pa_mkold(phys_addr_t paddr)
> >>   	folio_put(folio);
> >>   }
> >>   
> >> -static void __damon_pa_prepare_access_check(struct damon_region *r,
> >> -		unsigned long addr_unit)
> >> +static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
> >> +					    struct damon_region *r)
> > Let's keep 'r' on the first line, and update the second line without indent
> > change.
> >
> Thanks

You're welcome :)

So I'm still unsure if this is the only single and best way for your use case.
I'd like to further discuss your use case and find more way to help it if you
are also interested.  So, I'd like to continue the conversation.

Regardless of it, though, I think this patch is good enough to be merged for
general use case, though it require above trivial style changes.  I wouldn't
strongly request you to solve the >4GiB region issue together, but it would be
nice to be added from the beginning.  It's up to your choice.

I'm also waiting for your answer to the second patch of this series.  I'm still
bit skeptical about it, though.  To my simple brain, it feels introducing too
much complexity.  I feel like making this damon_rand() optimization patch
merged first and keep discussing your use case and the second patch later might
be a path forward.  If you agree, please feel free to post a new version of
this patch.


[1] https://github.com/damonitor/damo/blob/next/USAGE.md#damo-report-access-page-level-properties-based-access-monitoring
[2] https://lore.kernel.org/linux-mm/20260307210250.204245-1-sj@kernel.org/


Thanks,
SJ

[...]

