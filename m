Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F43CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 01:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285446B00C5; Thu, 18 Jun 2026 21:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DE96B00C7; Thu, 18 Jun 2026 21:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B5A6B00C8; Thu, 18 Jun 2026 21:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEEA16B00C5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:59:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73EE81C1A52
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:59:44 +0000 (UTC)
X-FDA: 84895005888.30.832B5F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D7EC240006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:59:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVOgvpQq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781834382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ofmb9frWuZSVPum7XAfwUBl7J7p0AxyClhSStJ7K28=;
	b=osM7HmlvDzs5gSqvPhfuzWhoVbUJK4xIIgUJtgPbEcpmnnLZlk4MjTzGUItOBfoB4ZCdQa
	1PQg62vACG7SCm34UBKdpfu9iUwupWv5V7Hsh1QwVBtLcSO2S1JZJQ52t9NAtD/VgmcDiV
	oPJIF4DDDzAUz3lQtoQsdMM+0iSykdA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVOgvpQq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781834382;
	b=JywgCxAOiKvfQlMeHXAr1h1JR4dbfv+RiB07kBA6g5Q2q9805ewByCkJxuvpnc91C9Tn6Q
	zPTqDcPBvQ90/eI5XNWehFX+58e8i2gGmva76mkiKn8kwM95DKNOcBmjq5F+uN55F5KjA1
	X9mk+Fm5nL1Ik+VuBOb/fnpEzS7eE/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D935601E1;
	Fri, 19 Jun 2026 01:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F154D1F000E9;
	Fri, 19 Jun 2026 01:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781834381;
	bh=7Ofmb9frWuZSVPum7XAfwUBl7J7p0AxyClhSStJ7K28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVOgvpQqTuaIoN9yLw03Z01TcQunNRa0inlrc7z8zb4Vnpvaw2feFLmgP+jo3BFqb
	 cvYeNWdTgfstWZFeJXwT5EiWt797tKvWML3w5W7SrcLgndRKXp4B+9vw14qydbvy67
	 RaEOBqELsnZSHK1f28uOVTMmG4yR5GqcR1sUweiCSU4mZegYGwzOUgY/ZerJbHscE+
	 p+jMlH44AyMw4K0trskFoJLHZsoknyAunS2uaUvrXIGgGWFmzrMakmPZ4RfSmFsG6s
	 Jcbk1AVpiyEH1pSdeJIsQ+s/S/OMpzN8c4MrEiYC7d7QG2IGsF8H1OwJCY/3wOpiHH
	 0Rwv+Oz9MHsnw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Wang Lian <lianux.mm@gmail.com>,
	akpm@linux-foundation.org,
	npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	damon@lists.linux.dev
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM SPE feedback
Date: Thu, 18 Jun 2026 18:59:30 -0700
Message-ID: <20260619015931.9690-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619015411.9554-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7EC240006
X-Stat-Signature: poi9m4otpo8skapzxcojedkay7jmgxus
X-Rspam-User: 
X-HE-Tag: 1781834382-343813
X-HE-Meta: U2FsdGVkX18817dokXgfFLxVYRddbcq1WI822MfCDtW1VgRRhPyiBKO/53Bx0Tb7groBQa+XsTCcsgyYMlueI75P7R0FdFMluxlOmZY9HdWi86SNiztRROqERAlmno9GlzHJgu+MuKr1ZC128/fROgqyqOqHdMHrn6rZBYjF7pGjOr8jTTi2Iq18kcc/RjGnNNZ5GA2wpsWQ/9pegXz4nniDy6qKkyEKZZ1roXwW5rT2q6h4B4Q0hXUUZtBLL2BZ45tLIyJzYei25QCTLHRjqCN13idjxyo2RDPLiL+xYtt4cWyQ2Ezn0zD6EMwHdDlrQ8po2Zd5dIBIal4AlG/QYj81CQcb9dxtBoLnemWOQ29sruA4twykUSj06BkEKxW9LzmDSaOUHqFmyaukitqrqIMUKAgxlDh7nnZtr07tdDL+xChC1irJ8RPHXUu3mQB7yBHNIiBzgnNHve6tUDqwY9D9cM0QSoJ+9sA+0hNvpBBUZ2O9Kwqlrl/rGAQIjhuxnQIyEbt3BGzev8FsUenV+Ii/BG1sEpUhsqUJ8zZtV8K6hG+4W6eQsXzp2UrQa9SG0l5puAdXKnBGbJNK6wyxDlgVt1coynhqA0oZgQ1ewuoCzs0JsavVyCma3yBKqrDBAtp7i2Sh6ITvyw960wkhNQwWjvT1vUBsXZA/k3mJU7PI7ZkP0Smps9o9N2VEB8HXySFa93NLQAhEddA06XP5+x6UE17RONYXdAynydKKcmOg6lOPodO6A/q6J1HagFB3ciDKXJJsaUxfleAXDSCERlPeGYWDA4wNPNlNiUC2XP0PEJdDpYj0M6UA/zoQLpaEvDM0QnOSXJ/sAxj/7nzzEFCc/GhP5ZUPPBrnDKDzs1FEUqYuNDpyBbIXJqlrapU/NJsirxbkx1BuPEJkRUcw30dpkBo50x7rEFpFp4Dtx5Zlf/ex3CLTzm/1z/2KMGAzSQa4/zJHe5oqHgZ61Bc
 fxGTVgLk
 A0NWdG2rC11BwLVvZ2D0yCEC2BKN9yOhpQlU9tlDRu4C1LuH7LJcxMt7XimaAOyX6zLT9dH9YO3kliXn/Qfjg5HrYemVZuUTmzOVdrU2oZjtM1K82VpZZAreVeQMA0gLD26r+SULpqY6nIulzEehLfjhtA8PLTVhiYGPn9ZlloyLhEKmM8HIxkoDJL/t8RPs2I6b1G1tQWU3+q1AQayvVxNUU/eUhXDp4J3JWq7SnoE/jRTp/c0hUZuMLtk6VPRv6NUujktXgwRYlmfwDIr+tuMVYLrkTv1q3PqIw8k/ig9QrCaHw7STMxIFDn//0TBQdyObnFdz38ZuVQO+YGUO+fV4uoAnyiDe7S9aT48ijZlB41oa+K2SyllqRoPvFH9STWla/jr8RANnz/CHev3Or+Ya/Hf8M+2R17GaRtvLSoWCawcdNLhNGv2Xdl0e6HT8YNljn2sePnmM2iZ5aVHh+tVW7ozZkAzH3zB631+LySp2GXMaFdkztUL7PcR3tmDUEJ8aQqcJdiNA/6cJ3EM/kLCIAIWUQf9Fhf0ryofsfmgfbG2uPwNTQfhdJz27DFdQ723lz44QMnjlrsvdUiy4kCeJsbIHCMMoJEQ9Pj6zZsz92Y6nhDitsOAHIAbIJsyEozS38fLanP+ofNSbH7hlEZPhDLLbJuTWv2Khz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ damon@lists.linux.dev

Please Cc damon@lists.linux.dev from the next revision, and all DAMON patches
in future.


Thanks,
SJ

On Thu, 18 Jun 2026 18:54:23 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 18 Jun 2026 18:47:16 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > Hello Lian,
> > 
> > On Thu, 18 Jun 2026 17:48:32 +0800 Wang Lian <lianux.mm@gmail.com> wrote:
> > 
> > > Received an off-list report that DAMON significantly overestimates
> > > hot memory in KVM/QEMU deployments with THP-backed tmpfs guest memory
> > > running Oracle workloads.
> > > 
> > > The root cause is structural: a PMD entry covers 512 4KB subpages with
> > > a single Access Flag (AF) bit. When any one subpage is accessed, the entire
> > > 2MB region appears "hot" to DAMON. On ARM64,
> > 
> > This makes sense to me.  I also agree this could caused the reported problem.
> > And this is a known limitation of DAMON.  My suggestion for straightforward
> > workaround of this problem is, using 'age' information of DAMON for better
> > identification of the hot memory.
> > 
> > That is, I don't expect real hot data in real production systems will evenly
> > scattered.  Even if they are, I don't expect they will all evenly frequently
> > accessed.  Only a few of those would be accessed frequently for long.  Even if
> > that is, there would be data that frequently for longer.  You could show the
> > distriibution of the pattern and find X % of hottest memory as hot.
> > 
> > We invented idle time percentiles [1] for a similar purpose, though it is more
> > focusing on finding cold memory.
> > 
> > I understand this patch series is trying to make more fundamental and better
> > solution on hardware that can do better.  Makes sense to me.
> > 
> > > this is compounded by the
> > > hardware AF mechanism -- the AF is only set on a TLB miss. Consequently, when the
> > > working set fits entirely within the L2 TLB (e.g., a 16MB working set with 2MB THP
> > > running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes completely blind to
> > > subsequent accesses.
> > 
> > This makes sense to me.  However, I don't get how this is contributing to the
> > problem.  Could you please elaborate?
> > 
> > > x86 is not subject to this specific blindness under similar
> > > conditions.
> > 
> > To my understanding on x86, same issue exists.  If TLB hits, Aceessed bit is
> > not set, and DAMON shows it as unaccessed.  Am I missing something?
> > 
> > > 
> > > We reproduced this memory inflation on a Kunpeng 920 platform using a synthetic
> > > workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB actually hot):
> > > THP=always causes DAMON to report the entire 8GB as hot, while THP=never
> > > reports only a few hundred MB -- a 512x overestimate relative to the actual
> > > 16MB hotspot under THP, and a ~33x gap between the two THP modes. ARM SPE hardware profiling
> > > independently confirms this asymmetry: out of 2,005 THPs sampled system-wide
> > > over 10 seconds, 97% had fewer than 10% of their 4KB subpages actually accessed.
> > 
> > I don't think the real world production systems to have this very artificial
> > access pattern.  I believe (or, hope) use of 'age' can work around the issue in
> > a reasonable level for many cases.  I understand this setup is only for PoC,
> > and I think this is well designed test for the purpose.  Thank you for sharing
> > this.
> > 
> > > 
> > > To mitigate this, this series extends the existing DAMOS_COLLAPSE action to be
> > > mTHP-aware via a new target_order field,
> > 
> > Makes sensee, and sounds nice.  Definitely no one size fits all!
> > 
> > > and introduces a new
> > > DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split PMD THPs
> > > into smaller mTHPs
> > 
> > Nice!  Asier was planning to do similar work in future.  I think you could
> > collaborate to reduce unnecessary duplicates!
> > 
> > I'd suggest making the name simpler and consistent to DAMOS_COLLAPSE, though.
> > Say, DAMOS_SPLIT ?
> > 
> > > when most subpages are probed as cold, and collapse them
> > > back when beneficial. To resolve the sub-PMD monitoring blindness, the split
> > > path can incorporate fine-grained hardware feedback from ARM SPE.
> > > 
> > > The hardware feedback loop (damon_spe_folio_heatmap) implements a two-pass
> > > signal filter: it first identifies the peak chunk access count, and then marks
> > > sub-chunks with >= 1/10 of the peak count as hot, effectively filtering out
> > > SPE sampling noise. A configurable hot_threshold (default 30%) controls the
> > > split decision: only folios with a hot fraction below this threshold are
> > > eligible for splitting. When no SPE data is available, the infrastructure
> > > gracefully falls back to explicit PTE-level scanning via folio_walk.
> > > 
> > > Currently, SPE data is fed from userspace via debugfs (e.g., perf script piped
> > > through a histogram builder into /sys/kernel/debug/damon/spe_feed).
> > 
> > So you implemented a debugfs interface?  That must be a nice approach for PoC.
> > But it may be difficult to be upstreamed as is.
> > 
> > You could build a control plane that decides the exact address ranges to split,
> > and directly feed it to DAMOS using DAMOS address filter.  max_nr_snapshots can
> > also be useful for making such kind of user space controls more deterministic.
> > 
> > For simpler user-space control, utilizing user_input DAMOS quota goal [2]
> > should also be another option.
> > 
> > We are also planning [3] to extend DAMON for perf events.  On top of it, we
> > might be able to extend it further to utilize ARM SPE by DAMON itself, and do
> > all this without the user space help but only DAMOS.
> > 
> > Baseed on below 'limitations' section, I understand this is only for PoC at the
> > moment, and you plan to explore the perf event based approach.  I'd also
> > recommend that.
> > 
> > > 
> > > Collapse path (patches 1-3):
> > >   DAMON scheme action=COLLAPSE, target_order=N
> > >   -> damos_va_collapse() -> damon_collapse_folio_range()
> > >   -> collapse_huge_page()
> > > 
> > > Split path (patches 4-5):
> > >   DAMON scheme action=MTHP_SPLIT, target_order=N, hot_threshold=M
> > >   -> damos_va_mthp_split() -> damon_spe_hot_fraction()
> > >   -> split_folio_to_order()
> > > 
> > > SPE feedback infrastructure (patch 6):
> > >   perf script -> spe_hist -> debugfs spe_feed
> > >   -> per-folio rbtree {THP-aligned PFN -> access_count[512]}
> > >   -> damon_spe_folio_heatmap() -> hot_bitmap -> split decision
> > > 
> > > The userspace helper tools (including the spe_hist histogram builder and
> > > validation scripts) are archived at:
> > >   https://github.com/lianux-mm/damon_spe
> > 
> > Thank you for making all the grateful code open!
> > 
> > > 
> > > Testing was performed on a Kunpeng 920 system (256 cores, 249GB RAM, base kernel
> > > 7.1.0-rc5+):
> > > 
> > >   T1 ARM64 blind spot: A 16MB THP workload (where 8 PMDs fit entirely within the
> > >      L2 TLB) resulted in DAMON detecting 0 regions. Conversely, using 512MB
> > >      with 4KB base pages, or a 16GB THP layout (exceeding L2 TLB reach), allowed
> > >      DAMON to function normally.
> > > 
> > >   T2 THP inflation: With an 8GB mmap and 16MB actually hot (0.2%),
> > >      THP=always: DAMON reported 8GB hot (512x vs ground truth);
> > >      THP=never: ~245MB (15x vs ground truth).  The THP-induced gap
> > >      between the two modes was ~33x.
> > > 
> > >   T3 RocksDB: Fragmented malloc allocation prevented THP formation, and DAMON
> > >      behaved normally. We could not reproduce THP inflation with RocksDB.
> > >      The workloads fundamentally vulnerable to this structural issue remain KVM
> > >      guests, JVM large heaps, and PostgreSQL shared_buffers.
> > > 
> > >   T4 min=0 deadlock break: A 256MB THP induced the DAMON blind spot.
> > >      Triggering an unconditional mthp_split (via nr_accesses/min=0) successfully
> > >      shattered the space into 16384x16KB folios, allowing DAMON to fully recover.
> > > 
> > >   T5 ARM SPE histogram: Out of 2005 sampled THPs, 97% exhibited <10% hot subpages.
> > >      A typical trace showed PFN 0x820db800 accumulated 39,794 hardware accesses
> > >      concentrated across only 3 out of 512 subpages.
> > > 
> > >   End-to-end: Verified hot/cold discrimination. The SPE feed preserved a 90%
> > >      hot THP intact, while successfully splitting a 25% cold THP into 128x16KB folios.
> > > 
> > > Known limitations:
> > > - The full KVM + Oracle production chain has not yet been benchmarked end-to-end.
> > >   While individual component verification is complete, full integration testing
> > >   is planned in collaboration with Sangfor.
> > > - khugepaged may aggressively re-collapse the mTHPs that DAMON splits. A
> > >   coordination/back-off mechanism is required to avoid ping-pong effects.
> > 
> > Do you really need to khugepaged together, when you already have
> > DAMOS_COLLAPSE, and anyway you are running DAMON for hugepage splits?
> > 
> > > - SPE data is currently funneled via a userspace daemon and debugfs. Direct
> > >   kernel-side perf_event sampling integration is planned as a follow-up.
> > 
> > Nice, I think this will make our projects aligned and reduce unnecessary
> > duplicates.  I'd encourage you to try this path.
> > 
> > > - The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are empirical
> > >   defaults subject to further tuning.
> > 
> > I don't fully understand this part.  Could you please elaborate?
> > 
> > > - The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing hardware-MMU
> > >   characteristic, not introduced by this series. Setting nr_accesses/min=0
> > >   serves as an effective workaround for the split path.
> > 
> > I don't fully understand this, too.  Could you please elaborate and enlighten
> > me?
> > 
> > > 
> > > Reported-by: Chaobing Dai <daichaobing@sangfor.com.cn>
> > > Cc: SeongJae Park <sj@kernel.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Nico Pache <npache@redhat.com>
> > > Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> > > 
> > > Wang Lian (6):
> > >   mm/damon: add target_order field for DAMOS_COLLAPSE
> > >   mm/khugepaged: add damon_collapse_folio_range() for external callers
> > >   mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
> > >   mm/damon: introduce DAMOS_MTHP_SPLIT action and hot_threshold
> > >   mm/damon/vaddr: implement DAMOS_MTHP_SPLIT handler
> > >   mm/damon: add SPE feedback for sub-THP split decisions
> > > 
> > >  include/linux/damon.h      |  18 ++
> > >  include/linux/khugepaged.h |   3 +
> > >  mm/damon/Kconfig           |  12 +
> > >  mm/damon/Makefile          |   1 +
> > >  mm/damon/core.c            |   3 +
> > >  mm/damon/spe.c             | 505 +++++++++++++++++++++++++++++++++++++
> > >  mm/damon/spe.h             |  62 +++++
> > >  mm/damon/sysfs-schemes.c   |  96 +++++++
> > >  mm/damon/vaddr.c           | 118 +++++++++
> > >  mm/khugepaged.c            |  39 +++
> > >  10 files changed, 857 insertions(+)
> > >  create mode 100644 mm/damon/spe.c
> > >  create mode 100644 mm/damon/spe.h
> > 
> > Because this is an RFC and we found high level TODO (trying perf event based
> > appraoch instead of debugfs), I will skip reviewing the details.  If you have
> > specific parts that want my detailed review, let me know.
> > 
> > Also, the perf event based monitoring is a long term project.  The ETA is the
> > LSFMMBPF'27.  If you cannot wait until the time, maybe you could try the
> > alternative approaches (using address filter or user_input quota goal) and
> > upstreaming dependent parts (DAMOS_COLLAPSE extension for mTHP and DAMOS_SPLIT)
> > first could also be a nice approach, in my opinion.
> > 
> > [1] https://origin.kernel.org/doc/html/latest/admin-guide/mm/damon/stat.html#memory-idle-ms-percentiles
> > [2] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning
> > [3] https://lore.kernel.org/20251128193947.80866-1-sj@kernel.org/
> 
> The above link ([3]) is wrong, sorry.  Please use below.
> 
> [3] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Sent using hkml (https://github.com/sjp38/hackermail)

