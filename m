Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58FD2FF8860
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 16:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429796B0088; Sat, 25 Apr 2026 12:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400B16B008A; Sat, 25 Apr 2026 12:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DB66B008C; Sat, 25 Apr 2026 12:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 231886B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:00:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 778321C03FB
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 15:59:59 +0000 (UTC)
X-FDA: 84697539318.18.A33B295
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C126520014
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 15:59:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1aHgkr9;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777132797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnqAI7pmuEI0raqWvprGf7Ze8JU+g5tS4qbHidamZH4=;
	b=bn1q9geuH9vOYe+wvqINCOIZcdpQyx5xDXZaTr0ANmSkHbn9z5XUXn4Rg1fwyuvECEoQxK
	rQ+fRda8faN98vgcZPsGGO0w+umxam4q3ywsmhhKRgtLciyzXyO3LWPcjDK6KHe3Lneq3H
	JCdzkNU2v9s1GrALb7lvuxC/q72j+xE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777132797; a=rsa-sha256;
	cv=none;
	b=7KlU3hiu7RbFGFw6RD7KTNHAvRHBsT9u61M/j6WWWA8V4idRjQGQS0+h1DZNQ8TettO5Gl
	VMimnDul6l8GHyidOlEoEIEsxZBvXb48WGSoxETMuPlhYY+7eUxsA9yLVU7qEEtw89QG7X
	Gaonxj6XRhA/SIYi6n/TIrDfhe8QDsU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1aHgkr9;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C07960055;
	Sat, 25 Apr 2026 15:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7988EC2BCB0;
	Sat, 25 Apr 2026 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777132796;
	bh=DEqdJy/28z3gGC1txmGyukKotmF5okcgnV0GsqgHyVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1aHgkr96M93PgifDMLXkU27xgWWi/FWy0PrfWaWaromyXpgy7Jns+UHZghLKuAmN
	 14QDE8vGqOaWDhnuzV0RJEPAcjYVHlS08O4VmBBBSWKYeVUOATdQdmsxD5rmfAa7rO
	 6ZeJMzcnyYkD1L+FWtr+J2fcahu+BtvsiLzrjlnfUPRhVCXWTvVhGlGF+8VE1434tZ
	 NBciTL27oBraNsdVaJ5vl8vCRpTjntkInHiROpNH0VH3DNnIda5Wz2gb8/kz1GBA+D
	 b8u8qj6yk/UeyEAL7f3hUhx54rLSaq44M5RXrbhjv6pHa6A3zHcYXaCGwtZ5EdllHg
	 AxovvLoaEjdsg==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx PRNG
Date: Sat, 25 Apr 2026 08:59:52 -0700
Message-ID: <20260425155953.89674-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a322f827-ea39-4bfe-9c13-fa798b22e3ae@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C126520014
X-Stat-Signature: r1cphiqeux4616r575n7bgf3xmng5ya5
X-Rspam-User: 
X-HE-Tag: 1777132797-147625
X-HE-Meta: U2FsdGVkX1/OJR+zJt7vbYEo0kbM1ZTO5x2sFwDvbMe1XMIOabTzPVLzn+dJZqNSjELTG2DvJmtFb5g+CwtV/wzUMG1kvtuSjDtIDfTXNw9xN/GkQ6l8UnP0PXIokM3iT69b5ABmmcRnwrFFdIvyS3htEfp1q1os7XdEE43qWJgZXplnWoxKcRXmiVURcCsqUeJTfOu4lOOegcTPkCJWjHW2cVMuq47XtGI7Vb8OhI6n1EZ7nHkrluCIVNPaXxKs07R+JdpiRc1T0BHXQsc0cGLQ28xCSvOdouO98PMyy80pGEllOSDzN1iKsbYm+skVBu4nLENGnZYZQB4cdI32Ws/Pxx4iR/lr2nAG3FmHLN8iG1tEC2goMf1CKtXGBgQVwz5oX4WBngEUxMp8qvIFeOq2F6dwTk+pLYHKBUGLg+giLgkT4f5xe5KHJfYbxroZUst6IqLz4NREikv91gOwfFqtELcfIqul2y+iaBWt/pjZIsUVysQSfZfmew5sDOaYjHlkizpUFedRqZbTUTlgfoL937YGLxQnHl6qRysjYYuwtYPxAagUf3DTl+G1aQhpo8CVlZsYHucdrkK7qJBU04dYI31XTp6uJR2JPI176VnKF8QKU3cqn3PTYaQ/nMlZG4o1oMCzVFeG0ghIyWstl3/NZxaMPipwdgOA6Vs5YWtGB9T9Mls1FZ1xU2SV2tfM7OTn2nIgiOal8Rc5dF1RHaP1pdbjrzEbrRAZe6M+TB/UBEP3OEyNf21m+rGsH6FqR1+DwAgiVqesE2RGJ2KA/18lyuWdUZdj+jY+0Mk+Y/iL+X9FJNQM2U9gFjJeGAONM+1CIcU/uah3EodXgrfjbIjof/qtWG0LNQtM4Uf6VGBC3zgqxEyYfHWP3VhpqDEoed8bNkOaMbysFqOdJUgnBBQInIlUcrIbWgB0rZmClKYdq+NsIPpFkeFYTspQ5csMgOaaRo2WZIP2NIGMWhB
 ngWe5VCg
 ZHnFzEsENwbcds1SKJp7k/211Ywu1ucJyCgccy0iG5yc6erG/bphczpfLsXO5U8zy2qPXXcTtylsKOwgvePKRNlKLl3XGYXcBf6f+LxuOfff8AEDq7Gc122ImsfcAZKqHKJEuaBosGHsESg7/WS8o02iH4s/jMBwbFdf+Ae4nhM5vcEz9F6mCQHjjjh3iieXBI+kXTeQQtnMSpaylF8rVraIu2FWa/yGpCyU9trcnghTwZsPkYzaBwFK9nOyDVLS4mA+Rvekh8m3loRLGMRMsFg/CeWdlBTP71cJOzYkvqB26+Zw7k0tHI0k8529c8OLeiQxcCuHRs+8sk2OMWpNC4T0gB0YOp4YgaHij
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 11:36:02 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> 
> On 4/24/26 11:11 PM, SeongJae Park wrote:
> > On Fri, 24 Apr 2026 10:29:58 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> Hello SJ,
> >>
> >> Thank you for the review.
> >>
> >> On 4/24/26 9:36 AM, SeongJae Park wrote:
> >>> Hello Jiayuan,
> >>>
> >>>
> >>> Thank you for sharing this patch with us!
> >>>
> >>> On Thu, 23 Apr 2026 20:23:36 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >>>
> >>>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >>>>
> >>>> damon_rand() on the sampling_addr hot path calls get_random_u32_below(),
> >>>> which takes a local_lock_irqsave() around a per-CPU batched entropy pool
> >>>> and periodically refills it with ChaCha20.  On workloads with large
> >>>> nr_regions (20k+), this shows up as a large fraction of kdamond CPU
> >>>> time: the lock_acquire / local_lock pair plus __get_random_u32_below()
> >>>> dominate perf profiles.
> >>> Could you please share more details about the use case?  I'm particularly
> >>> curious how you ended up setting 'nr_regiions' that high, while the upper limit
> >>> of nr_regions is set to 1,0000 by default.
> >> We use DAMON paddr on a 2 TiB host for per-cgroup hot/cold page
> >> classification.  Target cgroups can be as small as 1-2% of total
> >> memory (tens of GiB).
> > Thank you for sharing this detail!
> >
> > Could you further share me what do you do with the hot/cold information?  We
> > found some people want to use DAMON for proactive cold pages reclamation but
> > they watned to use it for only file-backed pages, and therefore developed page
> > level DAMOS filter.  In a similar way, if we know your detailed use case, we
> > might be able to serve you better by finding not well advertised features, or
> > developing a new features.
> >
> 
> Hello SJ,
> 
> Thanks.
> 
> Use case: mixed-workload Kubernetes host (latency-sensitive + batch
> pods on the same machine).  We need continuous per-pod cold/hot
> signal for two things -- k8s scheduling decisions (which pod can
> give up memory under host pressure) and sizing the eventual
> reclamation through memory.reclaim.  Both anon and file pages
> matter (swap is configured); reclamation itself goes through
> mainline.  What we add is the per-pod cold attribution feeding the
> scheduler.

Thank you for sharing this detail!

> 
> DAMON_RECLAIM alone doesn't fit -- it is reclaim-only with
> aggregate stats, while we need continuous per-pod visibility even
> when reclamation isn't firing.
> 
> Let me re-frame the region-size point, since I don't think I
> explained it well last time.  We are NOT trying to make region
> size match cgroup size; you're right that pages are scattered and
> that mapping doesn't work.  The high nr_regions is so that DAMON's
> adaptive split has enough resolution to identify cold sub-areas of
> physical memory at all -- regardless of cgroup.

Thank you, this helps me betetr understand your concern.

> With ~2 GiB
> default regions on a 2 TiB host, a small pod's pages are averaged
> with thousands of non-pod pages in the same region, and the
> region never reaches nr_accesses=0 even when the pod is genuinely
> idle.

But, the adaptive regions adjustment mechanism dynamically change size of
regions, down to 4 KiB.  If the small pod's page is really cold while its
surrounding pages are not, DAMON should down-size the region to capture only
the page and show you nr_accesses=0.

> The cold signal is gone before any cgroup attribution
> happens.  Cgroup attribution itself is done at sample granularity
> (folio_memcg per sampled page), not at region granularity -- the
> regions just need to be fine enough that there *is* a cold signal
> to attribute.

Could you please share more details about what is the cgroup attribution, and
how it is done?  I guess that is the way to map DAMON's monitoring regions to
each cgroup to determine if each cgroup is hot or cold.  I'm unsure how it is
really be done.

> 
> >> With the default max_nr_regions=1000, each region covers ~2 GiB on
> >> average, which is often larger than the entire target cgroup.
> >> Adaptive split cannot carve out cgroup-homogeneous regions in that
> >> regime: each region's nr_accesses averages the (small) cgroup
> >> fraction with the surrounding non-cgroup pages, and the cgroup's
> >> access signal gets washed out.
> > But, pages of cgroups would be scattered around on the physical address space.
> > So even if DAMON finds a hot or cold region on physical address space that
> > having a size smaller than a cgroup's memory, it is hard to say if it is for a
> > specific cgroup.  How do you know if the region is for which cgroup?  Do you
> > have a way to make sure pages of same cgroup are gathered on the physical
> > address space?  If not, I'm not sure how ensuring size of region to be equal or
> > smaller than each cgroup size helps you.
> >
> > We are supporting page level monitoring [1] for such cgroup-aware use case.
> > Are you using it?  But again, if you use it, I'm not sure why you need to
> > ensure DAMON region size smaller than the cgroup size.
> This is also why DAMOS memcg filters do not bypass the
> nr_regions constraint -- the scheme's access-pattern matcher
> operates on the already-averaged region, so by the time any
> filter sees pages the signal is already lost.  Whatever
> attribution mechanism we use afterwards (custom callback, memcg
> filter, page-level reporting), the region count needs to be high
> enough first.

But, I'm not understanding why the regions adjustment mechanism cannot work
here.  Your answer to my above question will be helpful.

> > Fyi, I'm also working [2] on making the cgroup-aware monitoring much more
> > lightweight.
> 
> 
> Looking forward to it -- hopefully it'll cover our case. 😁

I hope so, too! :)

> 
> 
> >> Raising max_nr_regions to 10k-20k gives the adaptive split enough
> >> spatial resolution that cgroup-majority regions can form at cgroup
> >> boundaries (allocations have enough physical locality in practice for
> >> this to work -- THP, per-node allocation, etc.).  At that region
> >> count, damon_rand() starts showing up at the top of kdamond profiles,
> >> which is what motivated this patch.
> > Thank you for sharing how this patch has developed.  I'm still curious if there
> > is yet more ways to make DAMON better for your use case.  But this patch makes
> > sense in general to me.
> >
> >>
> >>> I know some people worry if the limit is too low and it could result in poor
> >>> monitoring accuracy.  Therefore we developed [1] monitoring intervals
> >>> auto-tuning.  From multiple tests on real environment it showed somewhat
> >>> convincing results, and therefore I nowadays suggest DAMON users to try that if
> >>> they didn't try.
> >>>
> >>> I'm bit concerned if this is over-engineering.  It would be helpful to know if
> >>> it is, if you could share the more detailed use case.
> >>
> >> Thanks for pointing to intervals auto-tuning - we do use it.  But it
> >>
> >> trades sampling frequency against monitoring overhead; it cannot
> >> change the spatial resolution.  With N=1000 regions on a 2 TiB host,
> >> a 20 GiB cgroup cannot be resolved no matter how we tune sample_us /
> >> aggr_us, because the region boundary itself averages cgroup and
> >>
> >> non-cgroup pages together.
> >>
> >> So raising max_nr_regions and making the per-region overhead cheap
> >> are complementary to interval auto-tuning, not redundant with it.
> > Makes sense.  I'm still not sure how it helps for cgroup.  But, if you do want
> > it and if it helps you, you are of course ok to use it in your way, and I will
> > help you. :)
> >
> [...]
> >> Sashiko is correct that (u32)(r - l) truncates spans greater than 4 GiB.
> >>
> >> This is a pre-existing limitation of damon_rand() itself, which
> >> passes r - l to get_random_u32_below() (a u32 parameter) and
> >> truncates the same way.  My patch makes that truncation
> >> explicit but does not introduce a new bug.
> > You are 100% correct and I agree.  Thank you for making this clear.  I should
> > also mentioned and underlined this in my previous reply, but I forgot it.
> >
> > So I think this patch is ok to be merged as is (after addressing my nit trivial
> > comments about coding styles), but we may still want to fix it in future.  So I
> damon_rand() is now only called by damon_split_regions_of() with
> the constant range (1, 10).  may by we can rename it to
> damon_rand_u32() to make the u32 constraint explicit in the API
> name; that closes out the truncation concern at the legacy helper
> without needing a separate series.

Good point.  I'm wondering if we have a reason to keep using damon_rand() at
all.  I find no such reason.  If you also find no real reason, how about simply
removing existing damon_rand() and renaming damon_rand_fast() to damon_rand()?

> > was wondering if such future fix for this new, shiny and efficient function is
> > easy.
> 
> 
> Will do.
> 
> v2 is a single patch with the style fixes (drop 'likely', 'r' on the 
> first line for paddr.c, ctx at the end for
> 
> vaddr.c) and 64-bit handling:
> 
>        static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
>                        unsigned long l, unsigned long r)
>        {
>                unsigned long span = r - l;
>                u64 rnd;
> 
>                if (span <= U32_MAX) {
>                        rnd = prandom_u32_state(&ctx->rnd_state);
>                        return l + (unsigned long)((rnd * span) >> 32);
>                }
>                rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
>                      prandom_u32_state(&ctx->rnd_state);
>                return l + mul_u64_u64_shr(rnd, span, 64);
>        }
> 
> I will also drop Prefetch patch.

Sounds good, looking forward to v2!


Thanks,
SJ

[...]

