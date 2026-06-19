Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934ACCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 01:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0496B00C6; Thu, 18 Jun 2026 21:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7916B00C7; Thu, 18 Jun 2026 21:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD4B6B00C8; Thu, 18 Jun 2026 21:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3FF46B00C6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:47:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 524CC1C148B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:47:19 +0000 (UTC)
X-FDA: 84894974598.18.EC4E78B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C7501C0003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:47:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd5Pl9ec;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781833637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfgiR0+FeRWf6gz0rkS4PYIys/OHYotQ7c9aSOd3T1c=;
	b=4Kfo2LzxBQZJ/bKqGGoWhlj4CxPvooES7j7C2JH8fFXuTojLlSiVoF3uUj5WXb+GDpai9N
	VJEy0erLST5bORCJZZMDVdtoG2toQkw0EOLmsD/nCLUbfZVLFnG2RAO+B43BPT3jjWSm5G
	aL8/V12wktN7eA7n/PuuKk9kpEBNQpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781833637;
	b=z7kGxrvQUor7siCIZVhyJATAn37quILL7B6R1VkRJdc5TZ2nZbwPzqBpLDIVnLN9ZMMg2i
	6+9FvD/9XOysXDyKsT2cwSziTzyFvJwMizvVVLBsrD6/xM+hf2Decw3DkXJhprM8JS/Dcn
	Rif+ZbPGZPOs6+c1O83rc/gmaRj3PoI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fd5Pl9ec;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91D9541A88;
	Fri, 19 Jun 2026 01:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D951F000E9;
	Fri, 19 Jun 2026 01:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781833636;
	bh=GfgiR0+FeRWf6gz0rkS4PYIys/OHYotQ7c9aSOd3T1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fd5Pl9ec4czWtJVqesB970YSC0tKGXb+Vt6B9kzWbjaoCuOEaOjcNLKYyy8kXWlyX
	 vlo+N3L8YfrnIMq4Q8b86XKrOrCZM98WTEu9PjoBMX6TVL8i13vc4PBrPoh9hssUHk
	 ejzFqaS7MjfSL4Y7AEiEJcJNj/3LultOgFYNtdTOmft8EZ9Orh+4yq5ZqVSL31mTJz
	 7ezSSeQY5IJ0RTwCYvYXV75puTxSC5Gb+q03lJKbcBQ1q+C2Tura61jPZ29vmktfzE
	 /Pw2F8UQHPMzufSwFMjXLyxfGaWO8Q18h8VQ99TM90xSz7keYFQSCjiwxdZ9m/sDmv
	 6NLxGvl9dO1Rw==
From: SeongJae Park <sj@kernel.org>
To: Wang Lian <lianux.mm@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM SPE feedback
Date: Thu, 18 Jun 2026 18:47:06 -0700
Message-ID: <20260619014707.9297-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C7501C0003
X-Rspam-User: 
X-Stat-Signature: i5eomm44ipnnast5ekshoar8q1y5u1te
X-HE-Tag: 1781833637-749859
X-HE-Meta: U2FsdGVkX18cRbo4X+R6Ck/I0uPSAvvdDsrs+P51kv80wP4KJ3PxmhlmiHaP4R4QsobdGM0+LinqEQX3nkpCvG+t8uVQcGC91Rw6FJi0S9nnLF46L0huupxb04cfd7M52SzqBV2fbRFJCDIa7qgBzdNKo2uWA/wIiYpKsbex/iIRf/8kOWI+GG1iwFM0D8h7Gf6XXuTdMISw4acj3+srKPtn6hvfHyzbRdIy5tFe6cHQ893kkWiFPypiz0yHjenh4w8XlK0+QdX3LC81GCVXW+cPFOeGe0FojSa4GlvTAr54DhBHDmWiQWhy9lU5QhDW4zU1H2aKQ2PZXavoEqwXItLy1UkOhQIsymYmZqW0HfLHR+nf5L8JHmv5NQHiNzAxXEAzW0OT9JZkb7ylLICo5pAEHQKm+McuApk/EEBXxNk8czMlo4D6iOzbQknOOLK+jYcXvyvzL0d6ZyMQbAtjEBPa5dqkgMU7VBYGHHMF6XcuYSRjl61VujakvkWIJpVrNoiB8PbP+mID5bCwC+j4Cq/Y88yJP6OcK5FxTEuHPgW3Vjz7JvRtfyYE1o9S9qs5XkSewhvoiFriZGr8XvN6Mb9/m4hwKfX+geQh+/Z95GJ8uIPJX7002qAHPywsJnOnIMML17YFHdFrtgOrDck0bMYNKhIJBRpLewsVrqDRJ3Wykp8XOP61Z0QnBbWg4axf+GMaUnpVCFhAWmP/2gvPYSPdJHRUPAZ2UWbNvVGTzHRl3ufXGsVPtqOZuYZSvK4CHK/begiAO3eud5hu0FZyMfw+Cm+0RkwgFVDiAG/hgo8uG09O3sbHTjrECv8x1YzSMoGC7eteKfDpe/qm9dQD9ww3CubQotjojC3aIa6KiHE7g3Xgx2qnK9NtyBwH3Yq+OARYq4ZStQU0qEus6J2v7XgDMAdBzbKT07cWTeBU0gYs2A4C3SAapC3Zy++dJDrZpackc99Vx7sFHDR490m
 C+uob9ho
 PupWUN+QLKHEiOxY5HAf/1FDiYZztNg0dD0cfM7KbYUYhCgmUEkNgUurZOout6CifEEWYCZU2V58RtqtMxlqR0kusk+p7X+nKTKPZA00JE/4o3YecXqvtuMuBv2fCEf4vo7nxZK0/BRYcgcNHyFFev+DhcxdofKa1jQUthPkB/MKuGEztf1OAK6+1jsBxpbwoGkIKCXOTcgLANo5FHpEbJgByhdcKrQK2phrYZsGFtNBII+nM5i0ZpfFBh8YudBOdlTNLUhtQ951cp0CTKW+R2ofwCDG7QEqpWQ7f5LvY15uAPZAgEIOO6+ZUZI3VbNKnNfp/SD6IrC6K04lNCZFDr/2OXxD5ENRvorP3JkAE+vdWL86tFCMvlQvV88kFEFETCfpcgTWA16xTHBt7mblX4ghhqKK9Q5s9TV2xb29BxaK2NlgiZ6KtC1wjcjLIpGLSjm1pzO4zODYZVMnditA2vDxV8ca9fOTQo12FdrunD3c5oWvuFnzmgnkrwqf9T/9Ah100NIYNiaYZB8oLJGPE0qtQ69NFBId/ToYqnfMavIIrOsf6fjkXZTuwUKSV9+D3QCEs7UMuZCKzZZalrKRhTeSsXlHS2pp7oNs3ktEkYBZRPoZmlUPYKPGVDMOgZ5bcs5Fkkn1SZafRIMC1GgCMc3UwYA3hNDp/Mbc1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Lian,

On Thu, 18 Jun 2026 17:48:32 +0800 Wang Lian <lianux.mm@gmail.com> wrote:

> Received an off-list report that DAMON significantly overestimates
> hot memory in KVM/QEMU deployments with THP-backed tmpfs guest memory
> running Oracle workloads.
> 
> The root cause is structural: a PMD entry covers 512 4KB subpages with
> a single Access Flag (AF) bit. When any one subpage is accessed, the entire
> 2MB region appears "hot" to DAMON. On ARM64,

This makes sense to me.  I also agree this could caused the reported problem.
And this is a known limitation of DAMON.  My suggestion for straightforward
workaround of this problem is, using 'age' information of DAMON for better
identification of the hot memory.

That is, I don't expect real hot data in real production systems will evenly
scattered.  Even if they are, I don't expect they will all evenly frequently
accessed.  Only a few of those would be accessed frequently for long.  Even if
that is, there would be data that frequently for longer.  You could show the
distriibution of the pattern and find X % of hottest memory as hot.

We invented idle time percentiles [1] for a similar purpose, though it is more
focusing on finding cold memory.

I understand this patch series is trying to make more fundamental and better
solution on hardware that can do better.  Makes sense to me.

> this is compounded by the
> hardware AF mechanism -- the AF is only set on a TLB miss. Consequently, when the
> working set fits entirely within the L2 TLB (e.g., a 16MB working set with 2MB THP
> running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes completely blind to
> subsequent accesses.

This makes sense to me.  However, I don't get how this is contributing to the
problem.  Could you please elaborate?

> x86 is not subject to this specific blindness under similar
> conditions.

To my understanding on x86, same issue exists.  If TLB hits, Aceessed bit is
not set, and DAMON shows it as unaccessed.  Am I missing something?

> 
> We reproduced this memory inflation on a Kunpeng 920 platform using a synthetic
> workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB actually hot):
> THP=always causes DAMON to report the entire 8GB as hot, while THP=never
> reports only a few hundred MB -- a 512x overestimate relative to the actual
> 16MB hotspot under THP, and a ~33x gap between the two THP modes. ARM SPE hardware profiling
> independently confirms this asymmetry: out of 2,005 THPs sampled system-wide
> over 10 seconds, 97% had fewer than 10% of their 4KB subpages actually accessed.

I don't think the real world production systems to have this very artificial
access pattern.  I believe (or, hope) use of 'age' can work around the issue in
a reasonable level for many cases.  I understand this setup is only for PoC,
and I think this is well designed test for the purpose.  Thank you for sharing
this.

> 
> To mitigate this, this series extends the existing DAMOS_COLLAPSE action to be
> mTHP-aware via a new target_order field,

Makes sensee, and sounds nice.  Definitely no one size fits all!

> and introduces a new
> DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split PMD THPs
> into smaller mTHPs

Nice!  Asier was planning to do similar work in future.  I think you could
collaborate to reduce unnecessary duplicates!

I'd suggest making the name simpler and consistent to DAMOS_COLLAPSE, though.
Say, DAMOS_SPLIT ?

> when most subpages are probed as cold, and collapse them
> back when beneficial. To resolve the sub-PMD monitoring blindness, the split
> path can incorporate fine-grained hardware feedback from ARM SPE.
> 
> The hardware feedback loop (damon_spe_folio_heatmap) implements a two-pass
> signal filter: it first identifies the peak chunk access count, and then marks
> sub-chunks with >= 1/10 of the peak count as hot, effectively filtering out
> SPE sampling noise. A configurable hot_threshold (default 30%) controls the
> split decision: only folios with a hot fraction below this threshold are
> eligible for splitting. When no SPE data is available, the infrastructure
> gracefully falls back to explicit PTE-level scanning via folio_walk.
> 
> Currently, SPE data is fed from userspace via debugfs (e.g., perf script piped
> through a histogram builder into /sys/kernel/debug/damon/spe_feed).

So you implemented a debugfs interface?  That must be a nice approach for PoC.
But it may be difficult to be upstreamed as is.

You could build a control plane that decides the exact address ranges to split,
and directly feed it to DAMOS using DAMOS address filter.  max_nr_snapshots can
also be useful for making such kind of user space controls more deterministic.

For simpler user-space control, utilizing user_input DAMOS quota goal [2]
should also be another option.

We are also planning [3] to extend DAMON for perf events.  On top of it, we
might be able to extend it further to utilize ARM SPE by DAMON itself, and do
all this without the user space help but only DAMOS.

Baseed on below 'limitations' section, I understand this is only for PoC at the
moment, and you plan to explore the perf event based approach.  I'd also
recommend that.

> 
> Collapse path (patches 1-3):
>   DAMON scheme action=COLLAPSE, target_order=N
>   -> damos_va_collapse() -> damon_collapse_folio_range()
>   -> collapse_huge_page()
> 
> Split path (patches 4-5):
>   DAMON scheme action=MTHP_SPLIT, target_order=N, hot_threshold=M
>   -> damos_va_mthp_split() -> damon_spe_hot_fraction()
>   -> split_folio_to_order()
> 
> SPE feedback infrastructure (patch 6):
>   perf script -> spe_hist -> debugfs spe_feed
>   -> per-folio rbtree {THP-aligned PFN -> access_count[512]}
>   -> damon_spe_folio_heatmap() -> hot_bitmap -> split decision
> 
> The userspace helper tools (including the spe_hist histogram builder and
> validation scripts) are archived at:
>   https://github.com/lianux-mm/damon_spe

Thank you for making all the grateful code open!

> 
> Testing was performed on a Kunpeng 920 system (256 cores, 249GB RAM, base kernel
> 7.1.0-rc5+):
> 
>   T1 ARM64 blind spot: A 16MB THP workload (where 8 PMDs fit entirely within the
>      L2 TLB) resulted in DAMON detecting 0 regions. Conversely, using 512MB
>      with 4KB base pages, or a 16GB THP layout (exceeding L2 TLB reach), allowed
>      DAMON to function normally.
> 
>   T2 THP inflation: With an 8GB mmap and 16MB actually hot (0.2%),
>      THP=always: DAMON reported 8GB hot (512x vs ground truth);
>      THP=never: ~245MB (15x vs ground truth).  The THP-induced gap
>      between the two modes was ~33x.
> 
>   T3 RocksDB: Fragmented malloc allocation prevented THP formation, and DAMON
>      behaved normally. We could not reproduce THP inflation with RocksDB.
>      The workloads fundamentally vulnerable to this structural issue remain KVM
>      guests, JVM large heaps, and PostgreSQL shared_buffers.
> 
>   T4 min=0 deadlock break: A 256MB THP induced the DAMON blind spot.
>      Triggering an unconditional mthp_split (via nr_accesses/min=0) successfully
>      shattered the space into 16384x16KB folios, allowing DAMON to fully recover.
> 
>   T5 ARM SPE histogram: Out of 2005 sampled THPs, 97% exhibited <10% hot subpages.
>      A typical trace showed PFN 0x820db800 accumulated 39,794 hardware accesses
>      concentrated across only 3 out of 512 subpages.
> 
>   End-to-end: Verified hot/cold discrimination. The SPE feed preserved a 90%
>      hot THP intact, while successfully splitting a 25% cold THP into 128x16KB folios.
> 
> Known limitations:
> - The full KVM + Oracle production chain has not yet been benchmarked end-to-end.
>   While individual component verification is complete, full integration testing
>   is planned in collaboration with Sangfor.
> - khugepaged may aggressively re-collapse the mTHPs that DAMON splits. A
>   coordination/back-off mechanism is required to avoid ping-pong effects.

Do you really need to khugepaged together, when you already have
DAMOS_COLLAPSE, and anyway you are running DAMON for hugepage splits?

> - SPE data is currently funneled via a userspace daemon and debugfs. Direct
>   kernel-side perf_event sampling integration is planned as a follow-up.

Nice, I think this will make our projects aligned and reduce unnecessary
duplicates.  I'd encourage you to try this path.

> - The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are empirical
>   defaults subject to further tuning.

I don't fully understand this part.  Could you please elaborate?

> - The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing hardware-MMU
>   characteristic, not introduced by this series. Setting nr_accesses/min=0
>   serves as an effective workaround for the split path.

I don't fully understand this, too.  Could you please elaborate and enlighten
me?

> 
> Reported-by: Chaobing Dai <daichaobing@sangfor.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> 
> Wang Lian (6):
>   mm/damon: add target_order field for DAMOS_COLLAPSE
>   mm/khugepaged: add damon_collapse_folio_range() for external callers
>   mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
>   mm/damon: introduce DAMOS_MTHP_SPLIT action and hot_threshold
>   mm/damon/vaddr: implement DAMOS_MTHP_SPLIT handler
>   mm/damon: add SPE feedback for sub-THP split decisions
> 
>  include/linux/damon.h      |  18 ++
>  include/linux/khugepaged.h |   3 +
>  mm/damon/Kconfig           |  12 +
>  mm/damon/Makefile          |   1 +
>  mm/damon/core.c            |   3 +
>  mm/damon/spe.c             | 505 +++++++++++++++++++++++++++++++++++++
>  mm/damon/spe.h             |  62 +++++
>  mm/damon/sysfs-schemes.c   |  96 +++++++
>  mm/damon/vaddr.c           | 118 +++++++++
>  mm/khugepaged.c            |  39 +++
>  10 files changed, 857 insertions(+)
>  create mode 100644 mm/damon/spe.c
>  create mode 100644 mm/damon/spe.h

Because this is an RFC and we found high level TODO (trying perf event based
appraoch instead of debugfs), I will skip reviewing the details.  If you have
specific parts that want my detailed review, let me know.

Also, the perf event based monitoring is a long term project.  The ETA is the
LSFMMBPF'27.  If you cannot wait until the time, maybe you could try the
alternative approaches (using address filter or user_input quota goal) and
upstreaming dependent parts (DAMOS_COLLAPSE extension for mTHP and DAMOS_SPLIT)
first could also be a nice approach, in my opinion.

[1] https://origin.kernel.org/doc/html/latest/admin-guide/mm/damon/stat.html#memory-idle-ms-percentiles
[2] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning
[3] https://lore.kernel.org/20251128193947.80866-1-sj@kernel.org/


Thanks,
SJ

[...]

