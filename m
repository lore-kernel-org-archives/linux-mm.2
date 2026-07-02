Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCABDC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C417D6B00DC; Thu,  2 Jul 2026 20:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18516B00DF; Thu,  2 Jul 2026 20:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE18B6B00E0; Thu,  2 Jul 2026 20:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF866B00DC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:33:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4378FC144B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:36:02 +0000 (UTC)
X-FDA: 84944690964.25.D698A37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9DA8812000C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:36:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=habG5SnP;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783017360;
	b=nVBJxE7F3RndfRhJDjidA2IzdqJTnG/kwkCDpfBGqsjAJwk8JdTow3kqvGQc/W1Rw3Px3p
	/e2jNNJd2l8SpmbNivzAmWkJ3NXVFmwQGLCIjljVsDBJ+qdP2syQS+ybYZP2uX03SVoI1F
	0uFFKiT8so21fLmb7ukBchXn407Rh7c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783017360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEqziiIB4STneFn12q0ZQvXJ95tO62sFkbvLi/w3KcM=;
	b=lSUZpi/CC/NrSm7T3JMYUJKFxoCBXcA6PgKAzOVXDQmesuxeYq1C+w+q8Fon3gXsw95bFm
	CSFPjM2L318OjdMZ7NyKfoBLTHIBoqr/LLE3rQvlLNL/U1e8LIiyY5Xp22mcz8Lt8f/8oU
	/AYSCgv2/mTyZGqgUd8UhLlU+mOtxts=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=habG5SnP;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0379601CA;
	Thu,  2 Jul 2026 18:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415521F000E9;
	Thu,  2 Jul 2026 18:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783017359;
	bh=lEqziiIB4STneFn12q0ZQvXJ95tO62sFkbvLi/w3KcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=habG5SnPRwBjGuNNiw9jEqc0+C6Ndk6h6wRFg5GBqSO6f3xfjTjfq7FiWxlBZPZPH
	 9mQBkVPUQFi5C9J5oQtIx94gB3kqgwAPh65c1trImbbDHfInpc5wXEmJGUSVCD/Pzz
	 4dxqKikxjQZtWyfIRJMd08GNrzRWLRCGmT2ls3L1QLF0N0CZwywddhHZL+omWU5VKv
	 gk8vBFWqYN58IrG4gYbmqVRxMDSlb5ALt7dwKS2yE9HBSgyO+lBrspQzRS6WximyxB
	 AUvNpXK0B8vCHFfJQEfo6R0SVQBLuqJI9glQt0TjxH01nWfduZRiTqyagfUQACgo7K
	 v4vcxUGXVik5A==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Thu,  2 Jul 2026 11:35:51 -0700
Message-ID: <20260702183551.91007-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702094633.75658-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: woittx1x496zm9hqj8sn8s5k4czistt7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DA8812000C
X-HE-Tag: 1783017360-956514
X-HE-Meta: U2FsdGVkX188j2wtIX71IiMK8vG/sGk+cBNBdSH+IEUa4Orwpi1xTQERw230XYxBopdc9zeNyA/aLA0Y7yHD30G6PJKSNYfDmOdpPFxaDVxMDtyDjIt2riwjcGYNme+7W7N+OsJKNBMmT1avxuEgy3zqKsidwI4Q5YgusMqLRFsToRJ08EhrFWXypSzh+Tszsoc+upI0Tb84e9L7alGqvm5s+0er0ah9eGps4m8H9VfIvG75pRCzGB6d60TbHthrnRR4DSe4Ryt362NLtJSBT4YH8SgQACW6tK4Fc2mi4z3h5Tl+29mlolLduEuN/dIihIFvpl1oG5yBThqYiQbaYnUKQitO8EngeF9toltVeQxMZBvtPe5tqcdbaLyujWehITg1TNwZYhMsWi1lxXsG8MlS/57fdehom3ZXHtEvWggMF3tQbMAvfuLfSEeIx/8y+HvqAxUYQ/BXjD8J77hoW5bzVXdYAdK3rHYMMiZNo/FS3ulWZoTR8hZhj7SHHj+ezCHyoQoqrHYNzE9dumcXd2KsEE83sADcpw0OUyNyi/0p81m6rmV9jRGq5tJBXP3OmKLT0SDh0iZ+MB4pKUanQmi6uRqAhzGm9YZQgGDQWrbSugdiByK3hCM795wC77hCZVRij1Fcov/6uKjfjBBvLjLqoREwVyBJiP6xGC3a1xXjp76QGbdJVwTxsHPAPep3id+5hstReAvoTYtBLETrS1ebLFtaG4rwmVZI/eqvqyyu5Ioi4hGKX4S2T+ptkl3EfZFpCbwifCGoeMF0vO4xvlxFJzFcbhgZn2Sr580L6eDKpcvXV9MgVQ3maQSegVMgEptJGCqW9OX9s/dV9tz1zVzOSnfXcjtf0OtusOZnF0we6Y92xYqLb1vRFui+Sz/1dJEavBR9Y/KDX8LxbIJqDKTWXEjqLWrsvIPgDSDYodd8r6v6Bkw2PewAJ7GaeAoj4Gti9Sq2kGe74Aiqktm
 wkNkP49m
 9PLDSomDTwhXU165qoAI9yWODQJIIX9JYcojaIqQG46z+hbMOwCAO3rFcEzcdR5lwDpjNgaNSmhnZXaZ6Hd7PINzZyKWa1RPIowwIfJZkvT1pZcQdMVntlY+Bb2G2lEip0F5GqPPEeA6/bZY5j6lEJ32iOLn9ayxzQnBVZ5ZHscf3B1e1TmXr2FlMz1bWvHgFfL6nvPDjYMGTARsIBPb8Fi1IR+0f1cmwDiNJ/NRq9QQSB/9njO0lRSbOI+h0aKKlhj5JWa/6NaPUif3YjT5wTkKwTg4Ajl/rOwx6iLzsrLsI4i+4w5QqtRW6/wBaTVqNHTeFLm9fxxyMtuRYMd4AwX9IBBg+FB491qF2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 17:46:28 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Resend of v2 with the RFC tag restored (v1 was RFC PATCH, so v2 should
> be RFC PATCH v2).
> 
> This resend also includes fixes for issues identified during review of
> the earlier mis-sent PATCH v2 thread: uninitialized memory, TOCTOU
> races, BUILD_BUG guards, missing sysfs action name registration, and
> stack allocation overflow.  The series has been re-tested on aarch64
> (anonymous and file-backed THP split) and is checkpatch clean.
> 
> v1: https://lore.kernel.org/linux-mm/20260618094838.32805-1-lianux.mm@gmail.com/

Let's call it 'RFC v1'.

> 
> Changes since v1

Ditto.

> 
>  - Rename DAMOS_MTHP_SPLIT -> DAMOS_SPLIT for naming consistency with
>    the existing actions (per SJ's review).
>  - Drop the per-scheme hot_threshold field.  Hotness policy does not
>    belong in the kernel; target selection now lives in user space and
>    is expressed to DAMOS via the address filter (per SJ's review).
>  - Drop the v1 SPE debugfs patch entirely.  debugfs is not the right
>    interface for a feature, and the SPE profiler belongs in user space
>    (see "User-space target selection" below).  v2 is kernel mechanism
>    only: 5 patches.
>  - Decouple T1 (a lab observation) from T2 (the production issue), and
>    correct the architecture claim: ptep_test_and_clear_young() skips
>    the TLB flush on both x86_64 and arm64, so the blind spot is
>    architecture-independent rather than arm64-only.
>  - Terminology: avoid "stale TLB".  A valid TLB entry is doing its
>    job; the point is only that it lets the CPU satisfy a translation
>    without a page-table walk, so the Accessed bit cleared by DAMON is
>    not re-set.

Thank you for detailed changelog.  This is helpful for reviewers.
> 
> Background
> 
> Two effects degrade DAMON's PTE-Accessed-bit (AF) signal once THP is
> in play.  Both are described here as motivation only; this series does
> not change the AF monitoring path.
> 
> T2 -- PMD-granularity inflation (production issue)

I think it is better to call this T1, for readers.

> 
> A 2MB THP is tracked by a single PMD-level Accessed bit.  One access
> to any 4KB sub-page sets the AF for the whole 2MB, so DAMON reports
> the entire THP as hot and cannot distinguish a genuinely hot 2MB
> region from a 2MB region with a single hot 4KB page.  Cold memory
> hides inside "hot" THPs, and access-driven pageout/migration becomes
> coarse.
> 
> This is the workload that drove the work: Sangfor's Kunpeng 920 KVM
> hosts running Oracle.  ARM SPE sampling of that workload shows 94.6%
> of THPs have fewer than 10% of their sub-pages actually accessed.

Cool finding, thank you for sharing.  What DB workloads were running there?
Real production workload?  Or, synthetic benchmarks?

On the first read, I was wondering how you did ARM SPE sampling.  After reading
this mail to the end, I now understand you use perf.  Briefly mentioning that
here would  be nice.  E.g., "ARM SPE sampling of that worklaod using perf shows
..."

> 
> T1 -- TLB-reach blind spot (lab observation)

I think it is better to call this T2, for readers.

> 
> When the working set fits within L2 TLB reach (measured at 2048
> entries x 2MB = 4GB on Kunpeng 920; no public data available), the
> CPU satisfies translations entirely from the TLB,
> preventing translation table walks.  Because
> ptep_test_and_clear_young() does not flush

Wrapping text for the max columns is nice.  But let's not wrap it early when
there are spaces.  That could reduce space, and even carbon emissions from
people who want to read this nice cover letter after printing out on a paper.

> the TLB, valid TLB entries continue to satisfy translations and the
> AF that DAMON cleared is never re-set, so DAMON sees nr_accesses=0 for
> memory that is in fact hot, and no scheme triggers.  This reproduces
> in the lab with small workloads; it is not something we have seen
> reported from production, where working sets exceed TLB reach.
> 
> What this series adds
> 
> Rather than change AF monitoring, this series adds two order-aware
> DAMOS actions so a policy layer can act at mTHP granularity:

The background explained rooms to improve in DAMON's THP access "monitoring".
And this patch series is proposing adding new DAMOS actions for THP "handling".
Those are two unrelated things.

I really appreciate sharing your findings with the background, but as those are
not related to the proposal, I think it is better to be shared in a different
way.

I understand you are proposing this change because you know DAMON's hugepages
monitoring is imperfect, but still useful enough to get some benefits.  If
there were some findings that made you to think so, that could be good
background.

Also, you may have a reason to believe it is a good idea to use larger mTHP for
hot pages, and smaller mTHP for cold pages.  If so, and the description of the
reason is not trivial, that could be good materials to add on background.

> 
>  - DAMOS_COLLAPSE + target_order (patches 1-3): collapse small folios

This reads like you are introducing a new DAMOS action.  You indeed mentioned
"this series adds two order-aware DAMOS actions".  That's not completely wrong
in a sense, but more technically speaking you are adding a new mode of
DAMOS_COLLAPSE.  I'd recommend rephrasing to "extend" DAMOS_COLLAPSE..

>    up to a chosen mTHP order.  Patch 1 adds the target_order field and
>    its sysfs file; patch 2 exports a khugepaged helper
>    (damon_collapse_folio_range());

So patch 2 modifies khugepaged?  As Lorenzo mentioned on the other reply, that
change should also be reviewed by THP developers on MAINTAINERS file.  Please
ensure adding THP developers to the recipients list of the patch and this cover
letter.

The patch adds damon_collapse_folio_range() to khugepaged.h.  I understand
DAMON is the only user for now, and therefore you are adding damon_ prefix to
the name.  Not necesasrily DAMON is the only user forever.  And having damon_
prefix in a land outside of DAMON feels weird.  To be consistent with other
functions like collapse_pte_mapped_thp(), I'd suggest dropping the prefix from
the name.

>    patch 3 wires the vaddr handler.
> 
>  - DAMOS_SPLIT + target_order (patches 4-5): split large folios down
>    to a chosen mTHP order via split_folio_to_order(), for both
>    anonymous and file-backed (tmpfs/shmem) folios.
> 
> The two are complementary, not competing:
> 
>    THP=never  + DAMOS_COLLAPSE: start at 4KB, grow hot regions up.
>    THP=always + DAMOS_SPLIT:    start at 2MB, shrink cold regions down.
> 
> This dual-path design aligns with ideas discussed with Asier
> Gutierrez; we plan to unify our mTHP automation and evaluation
> roadmaps under this standard DAMOS_SPLIT action.
> 
> A deployment can pick either baseline, or run both, and let DAMOS
> manage the placement.  THP is still wanted for the hot working set
> (fewer TLB misses, shallower walks); the goal is not "no THP" but
> "THP where it is hot, small pages where it is cold."

I think this is a good idea.  Could you further elaborate what benefit users
can get from this in more detail, though?  Off the top of my head, I can expect
the benefits would be 1) less TLB miss from hot data, and 2) less mTHP
allocation failures from cold data occupying phsically contiguous memory.  But
you might showing even more benefits.    Anyway I think those are better to be
widely known by our kernel users.  Some of those may better to be put on the
background section.

> 
> User-space target selection
> 
> The decision of *which* regions to collapse or split is left to user
> space and fed to DAMOS through the existing DAMOS address filter
> (DAMOS_FILTER_TYPE_ADDR) -- the interface suggested during v1 review.
> The kernel provides the mechanism; user space provides the policy,
> consistent with the perf/BPF "kernel samples, user space decides"
> model and with the DAMON-X direction.
> 
> Because the AF signal is unreliable at PMD granularity (T1/T2), the
> scheme is run with min_nr_accesses=0 so it does not gate on access
> count, and the address filter selects targets.  min_nr_accesses=0 is
> also what unblocks the T1 case, where nr_accesses is pinned at 0.

Oh, so you are saying DAMON's huge pages monitoring is too problematic to use
as-is, for your use case.  That's completely fair.  And that explains what you
really want to do.  But this whole pictur is better to be described earlier
than your changes proposal.

From the beginning, explain why using larger mTHP for hot pages and smaller
mTHP for cold pages are good idea.  After that, explain how DAMON can be
extended for doing that.  Then, you can further explain your T1 and T2 findings
that explain why DAMON-only appraoch is not feasible, and how user-space target
selection can overcome it.

Also, I understand DAMON-only approach is not optimum or just useless for your
aimed use case.  But, is it completely useless for every possible use case?  I
think it might still provide some benefit in some use cases.  Could you pleae
clarify this point more in detail?  If you have data showing how useless
DAMON-only appraoch is, and how user space approach improves, it would be
awesome.

> 
> Why not just turn khugepaged off?  You can, but khugepaged is global
> and usually left enabled because other workloads rely on it; it cannot
> be disabled per region.  DAMOS_COLLAPSE gives per-region,
> access-pattern-driven collapse -- a more precise, targeted complement
> to khugepaged's global scan, not a replacement for it.  To handle the
> runtime race where khugepaged might aggressively re-collapse what
> DAMOS_SPLIT just split, we are evaluating a precise VMA-level handshake
> or back-off mechanism to prevent ping-pong effects in mixed
> environments.

Good reasoning.  However, khugepaged can be turned off per process, using
prctl().  How about turning khugepaged off for the process you want to use
DAMOS_COLLAPSE/SPLIT for?

> 
> Two user-space data sources produce the candidate address ranges:
> 
>  1. ARM SPE (ARMv8.2+): perf record (SPE) -> per-2MB hot-fraction
>     histogram -> PA->VA via /proc/<pid>/pagemap -> sparse-THP VA
>     ranges.  SPE reads physical addresses from the CPU pipeline,
>     bypassing the TLB and page tables, so it is immune to T1 and T2.
> 
>  2. smaps fallback (no SPE): scan /proc/<pid>/smaps for THP-backed
>     VMAs and treat the 2MB-aligned ranges as split candidates.
> 
> The SPE profiler stays in user space deliberately: the SPE PMU is a
> single-consumer resource, so a kernel consumer would lock out
> user-space perf and tooling (x86 PEBS / AMD IBS have the same
> property).  Keeping it in user space avoids that and keeps the metric
> source pluggable, in line with DAMON-X.

Maybe you are mentioning the perf events based DAMON, not DAMON-X.

And I understand you plan to extend DAMON to use ARM SPE, on top of the perf
events based DAMON as a future work.  As I mentioned before, I think that makes
perfect sense and I'm aligned.  Maybe this paragraph can bit reworded to make
it more clear, though.

> This is why v2 drops the v1
> SPE debugfs patch.
> 
> Testing
> 
> Tested on aarch64 with this series applied to 7.1.0-rc5, THP=always,
> using a DAMOS_SPLIT scheme (target_order=2, min_nr_accesses=0) and a
> single DAMOS address filter selecting one 2MB-aligned range:
> 
>  - Anonymous THP: the filter splits exactly that one THP --
>    sz_applied=2MB and AnonHugePages drops by 2MB, the rest of the
>    256MB mapping untouched.
>  - File-backed THP (tmpfs/shmem mounted huge=always): the same setup
>    splits exactly one 2MB shmem THP -- sz_applied=2MB and
>    ShmemPmdMapped drops by 2MB.  This confirms split_folio_to_order()
>    works for shmem folios (the KVM-guest-on-THP-tmpfs case).
>  - The address filter is what bounds the action: sz_tried covers the
>    whole ~2GB monitored region while sz_applied is exactly the 2MB the
>    filter selected.
>  - A smaps-based path (for hosts without SPE) enumerates THP-backed
>    ranges and splits all THP in the target workload.
>  - checkpatch clean on all 5 patches.

So, you tested only split part, for functionality.  Do you have plans to
further test collapse part, and performance?

> 
> Test scripts and SPE-to-DAMON pipeline tools:
> https://github.com/lianux-mm/damon_spe/tree/v2

Thank you for sharing the code!

So, I find rooms to improve on this cover letter for the readability and
clarity of the idea.  But as I mentioned before, I like the overall idea of
this series.


Thanks,
SJ

[...]

