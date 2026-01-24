Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6797D77898
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460126B057F; Fri, 23 Jan 2026 20:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3766B0580; Fri, 23 Jan 2026 20:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7EB6B0581; Fri, 23 Jan 2026 20:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 145486B057F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:50:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3F611A0142
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:50:50 +0000 (UTC)
X-FDA: 84365178660.04.D35C4E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CE84A0008
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:50:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pi6KGUl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769219449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jybDuo0SU5t03QvKtsXD3hl0S3XX7LBCeHSY/DVxHDk=;
	b=1tm9FEe1jn7HTC9DUHc7l7qJ0cLjM7JSQH4f3CbHfOC9kn9csa9c1xc63DRueDzQtcfylS
	buCJm+nEmo3SAXSo/CZ5zHtsgPecMmmxmhNjZc6HMJetYcdfMwPRpxBMmt492RZj2BDX3d
	UqMIUQ+pxpquOdqltRHyHYqlx5GBFvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769219449; a=rsa-sha256;
	cv=none;
	b=YyEUFjqyrFzTTKeH3gv/quU75ut1fUV4FXzZV47Ftc1XasudmwRxYmMyABJYO7coUXcLiH
	ndIbIdvqQ8kzho4GWclADJJB4wafW6RJkxkgtBzhYVIVDzidsga8CZcauQt5R27XVysmUu
	1wBF1t5E8h6Xwfw2hQzJZ5dIuhdhrno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pi6KGUl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64FEC60128;
	Sat, 24 Jan 2026 01:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D706CC4CEF1;
	Sat, 24 Jan 2026 01:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769219448;
	bh=JWD03LcVC4Uq83Qeg54JgO0yQb0xdGXIZJtfoTLCMpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi6KGUl58lMTzwlt+EPrWr4Flc0Exif/FEbpNOSMXSglS+c9qi6LXhGIcWWzid59x
	 d/BSBm/fy1wUpNgwxYW/tXPS7BLMi1EvMaeyYdO+JrsGTGUdHJYXNwY4qNXMSFUnNJ
	 fW9I/789qQJ1gvspTz1kcSu7ZgCqKzkhpM5TY94Wz41sScMvPaSzEIHVt2w5DiS6wn
	 AnEkQvyU0B0/izoMkp2NAl3OP5E/3+rkL3eOBDS4ucMS1jRM20SB0s+kO8xeMkg+eO
	 M0P5nda04ZdL9Hk/O2NbGNW9S8Sde+wAczdmLoFii8kjuasGCI/aoBRv99XkMug1bJ
	 PnO4mFKp8x/aw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for PA-based migration control
Date: Fri, 23 Jan 2026 17:50:43 -0800
Message-ID: <20260124015045.78075-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123045733.6954-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1CE84A0008
X-Stat-Signature: ear3jg794u3wiys6o3aor8kdokbeibwp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769219448-227428
X-HE-Meta: U2FsdGVkX19WQjwUyP0U+6kdyhyUyEj/R8cNQnxpaM1clZasuLd6ohsoMp4qGocwxeWWyWMzEFsKMAiIvFhPJQTfbJEajQYyRHDWy9b3I8xySq+pijgu92iDyfAmYSQ43OQ8kQeISz43JruqEKQuEejoOiXGrhDrAUx7Odoz56cauDcsFVuj9BtstglHeSJc9H7dtowqWn1OKFpKzqXz3im8RmgzNVDYEGf5OsdaA+sEh4mHPQovii9+VV2AjTqU2en9v9mn2qPpUE9TvuJOSQacp4DPxVhB3VbmMq+eaBOyluAzPCGYO0tmh/emD1AeLASHO3NTPCW1iTTrmN/GjpDR2yt1/BnX2tpr9HMUZL+IG2VvSfOiSYgbMqSf0RYqh8D5BZZM/fvHDHL4vpdJ3hl0Gt6mIx9RW1ivVx7D/gT+cdPQlzlV7tEklsJHFTWhYAoyfWhx33c/0zq01mClGcQKhCD908cGbeGCQTFD4CouTjKr2nCIA2pcQl3Np8tlARUPdxIqSVIc2CAWXjBiLSvXrpWY+En6jLDlvw2Sdvz+rG4MfKRGwkGkordSxplmhAvRqGgWvf5Euq9nxqO4XuIKaJiCz2VZdbksZHT9b/d9KivNp965TJWaponKb8JPveUqVAsynIlTa8z2gW86H7VrkOV5IV3fcrmjz0elu0p9B/hYp2+jDu80gUTwUex5gSZ+hg+nx8vLQ2fQNtYWg8Rjvv/Me56z6NxnA/hLU/ZMzykW3eB1PPD+TOf9Dlj5zn6yZrODoeVkz8I6ujSButy40+Ohd6m5zkUsRcoyB4ZLTLbVvMPQqyzSnviYwVPejyC8nFHatiUTd9w7BwFkFft30biPqkIsfticrrB1arDErS6ynm3jCZ0S0OnJZww+9W10RYOVbcjp/KMiJtYcdqy2zIQ2Tyc3tAHwBcDIUMtdJzxy+i3AKhgx5teZvFfKKdTGz8WoxxpAsa6pd25
 d+svVX8r
 RC9bfKN4JWXbkH33bRnaNvcQIPY+gTK2IsDbjpwH42RuzyQYumVTOTpT5JtqtLmUHaum0C+3GF5Hc1q9iEI4P35U0yDMsy6PFde8Lv87X4JtA+OInGmk3bKA/ZQNcx/TLGuQACYUtGgdqL9YBE3wRSE+weUrBmS6OxAPkp1ofQs4XFWdvtiEKqJa4FFhpqwu5bQ+p9K/snSRzEH4b7nsZQ+T3DK0z86lZn6XjLhTJhV/9hCaZkUSJYFkOm3LHuuqOUhvtIoTQuNIiKfV410BC6n7v43HA7mZdYMjy5caCmfQP1zXpvDR2IYWxyWnPRzV6hBnHTS4yYAVM6ANHreB/MZH7XBDQnY5bCZnWkIPQAqeolHnlHdeYiWywYhXPMZ3Srg7bypQhbB/vPRqKgMDcrqorr2frkjxxjulW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ing SK hynix folks (Honggyu and Yunjeong) for quota auto-tuning behavior
confusion (not stop immediately after satisfying the goal) I discuss below.

Hello Ravi,


Thank you for sharing this great RFC!

I had a chance to be involved in a high level design of this series, off the
mailing list.  I'm disclosing the fact for others' context, since a few of my
comments below are based on the previous off-list discussion.

On Thu, 22 Jan 2026 20:57:23 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This series introduces a new DAMON quota goal metric,

As I discussed off the list, I believe the new goal can be useful.  Thank you
again for making this!

> `node_sys_bp`, designed
> for controlling memory migration in heterogeneous memory systems (e.g.,
> DRAM↔CXL tiering). These patches are provided as an initial RFC and have
> not been tested on actual hardware.

I feel like the name is not very self explaining what it is, though.  I'm also
bit confused about what it does is what we discussed off list.  I'll add more
details below, on more detailed explanation about the new goal.

> 
> Background and Motivation
> =========================
> 
> A previous patch series [1] by Bijan Tabatabai and myself added weighted
> interleave support for DAMON migrate_{hot,cold} actions. That series
> implemented the feature for vaddr (virtual address) schemes because the
> weight-based approach requires VMA offset information to determine target
> nodes:
> 
>     target_node = (vma_offset % total_weight) → node_from_weights
> 
> For paddr (physical address) schemes, obtaining VMA offset requires costly
> rmap (reverse mapping) walks. As noted in that series:
> 
>     "However, finding out how a folio is mapped inside of a VMA requires
>      a costly rmap walk when using a paddr scheme. As such, we have
>      decided that this functionality makes more sense as a vaddr scheme."

Indeed the rmap overhead was one main concern.  I'd like to also note that,
however, another major concern from me was that the behavior sounds not easy to
intuitively understand.

> 
> This new series takes a different approach that enables PA-based migration
> WITHOUT requiring rmap walks, by using basis points (bp) target-state goals
> instead of weight-based action rates.
> 
> The rmap Cost vs Oscillation Trade-off
> ======================================
> 
> For PA-based migration with weights, there are two possibilities:
> 
>   1. Weight-based with rmap:
>      - Use rmap to find VMA offset for each physical page
>      - Apply weights based on VMA offset (same algorithm as VA)
>      - Works correctly: VMA offset provides stable identity
>      - Problem: rmap walks are expensive for every migration candidate
> 
>   2. Weight-based without rmap:
>      - Attempt to apply weights using only physical address information
>      - No stable identity across migrations
>      - Results in page oscillation (see below)
>      - Not viable
> 
> The Oscillation Problem (Weights Without rmap)
> ==============================================
> 
> Weight-based migration relies on a stable identifier to determine which node
> a page "belongs to". For VA, this is the VMA offset - it remains constant
> regardless of which physical node backs the page. For PA without rmap, no
> such stable identifier exists.
> 
> Consider a two-node system with weights {Node 0: 40, Node 1: 60}:
> 
>   Initial state:
>     Hot pages on Node 0: PFN 0x1000, 0x1001, 0x1002, 0x1003, 0x1004
>     Node 1: empty
> 
>   Iteration 1 - Weight-based selection (no rmap):
>     System tries to achieve 40/60 distribution
>     Selects pages at PFN 0x1002, 0x1003, 0x1004 (60%) for Node 1
>     After migration, these pages get NEW PFNs on Node 1:
>       PFN 0x1002 → PFN 0x5000 (Node 1)
>       PFN 0x1003 → PFN 0x5001 (Node 1)
>       PFN 0x1004 → PFN 0x5002 (Node 1)
> 
>   State after Iteration 1:
>     Node 0: PFN 0x1000, 0x1001 (40%)
>     Node 1: PFN 0x5000, 0x5001, 0x5002 (60%)
> 
>   Iteration 2 - Weight-based selection runs again:
>     System sees pages at PFN 0x5000, 0x5001, 0x5002 on Node 1
>     These are "new" pages from the system's perspective
>     NO MEMORY that these were just migrated FROM Node 0
>     Weight-based logic may select some for migration back to Node 0
> 
>   Iteration 3, 4, 5...:
>     Same pages continue bouncing between nodes
>     Each migration changes the PFN, erasing any "history"
>     System never converges to stable state
> 
> The fundamental issue: weights define an ACTION RATE ("migrate X% of
> candidate pages to each node") rather than a TARGET STATE. Without stable
> page identity (which rmap provides via VMA offset), the system cannot
> determine which pages have already been "handled" and continues to
> reprocess the same logical pages indefinitely.
> 
> With rmap, the VMA offset provides stable identity - a page at file offset
> 0x1000 always hashes to the same target node regardless of its current PFN.
> Without rmap, we have no such anchor, and weights become meaningless.
> 
> Solution: bp-Based Target State Goals
> =====================================
> 
> Instead of specifying action rates, `node_sys_bp` specifies a TARGET STATE:
> 
>     "Node N should contain X basis points (X/10000) of system memory"

I'm not sure if this is exactly what we discussed off list.  What I expected
the goal would be based on our discussion is, what the first patch is saying.
To quote the part,

    @@ -155,6 +155,7 @@ enum damos_action {
      * @DAMOS_QUOTA_NODE_MEM_FREE_BP:      MemFree ratio of a node.
      * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:    MemUsed ratio of a node for a cgroup.
      * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:    MemFree ratio of a node for a cgroup.
    + * @DAMOS_QUOTA_NODE_SYS_BP:           Scheme-eligible bytes ratio of a node.
      * @NR_DAMOS_QUOTA_GOAL_METRICS:       Number of DAMOS quota goal metrics.

That is, my understanding of what we want to achive with the new goal is,
letting users to ask DAMON "migrate hot pages of node A to node B, aiming
X % of node B becomes hot, as a result of the migrations".

But your above description is not saying about the "scheme-eligibility".  Also,
the goal metric is the ratio of the memory to the entire system memory, not
just a given node.  My quick read of damon_pa_get_node_sys_bp() on the second
patch of this series confirms the implementation is following your description,
not what I imagined.

Have you found something we missed during the off list discussion, and
therefore changed the definition of the goal to the current one?  If so, could
you share the details?  Or, you might also wanted to implement what I expected,
but something bothered your code and documentation?

> 
> The migration control loop:
> 
>   1. Calculate current_bp: sum bytes per node across monitored regions
>   2. Compare: if current_bp >= target_bp, STOP (goal satisfied)
>   3. Otherwise: continue migrating toward target
> 
>   Example with target: "Node 0 should have 4000 bp (40%)"

Regardless of why my expectation was different from this one, the goal I was
expecting might still be used for your descripted case.  That is, the scheme's
target access pattern could be "any access pattern", and the target metric
value could be adjusted based on the ratio between the node 0 memory and the
total memory.  For example, let's suppose there is 100 GiB memory in total, and
80 GiB memory in node 0 (80% of total memory in node 0).  Then 40 % of total
memory, which is the target of the above example, is 40 GiB, which is 50 % of
node 0.  So, you could use the goal I expected, with 50 % as the target value.
Imaginable usage of that would look like,

    # --damos_quota_goal receives <metric name>, <target metric value>, and
    # <node id of the goal>
    damo tune --damos_action migrate_hot --damos_quota_goal new_goal_metric 50% 0

I sure you know that you could s/migrate_hot/migrate_cold/ if you prefer
migrating cold pages first.

So, the metric of my expected definition can still be useful for your new use
case.  I'd prefer my expected definition if there is no concern, since it seems
useful for more cases.

> 
>     Iteration 1:
>       current_bp = 10000 (100% on Node 0)

How could 100% system memory can be on node 0?  Are you saying 100% of "hot"
memory?  This makes me suspect you _might_ actually wanted to implement what I
was expecting and the first patch of this series is documenting
(Scheme-eligible bytes ratio of a node) but somehow something bothered you to
drop the ball in a wrong place.

>       target_bp  = 4000 (40%)
>       current > target → migrate cold pages away from Node 0
> 
>     After Iteration 1:
>       current_bp = 4000 (40% on Node 0)
> 
>     Iteration 2:
>       current_bp = 4000
>       target_bp  = 4000
>       current >= target → STOP, goal satisfied

Please note that the goal-based quota auto-tuning works in proportional way,
preferring small steps and "eventual" goal convergence.  As a result, migration
will occur a few more times until it is completely stopped after the goal is
satisfied.  Unless there is another scheme that migrates pages into node 0, you
may end up having node 0 having a bit less than the 40% memory.

> 
>     No oscillation - migration stops when target state is reached.

So, little bit of oscillation could still happen.  Hopefully that shouldn't be
significant, though.

IIRC, SK hynix people also confused with the behavior when they experimented
migrate_{hot,cold} action with NODE_MEM_USED_BP goal based quota auto-tuning,
but using only a single scheme that does migration in a single direction.
Because this is at least second time it made confusion, if you need, maybe I
can try to add a feature for making DAMOS immediately stops after the goal is
satisfied.  Let me know if such new feature can be useful for you.  Cc-ing SK
hynix people (Honggyu and Yunjeong) so that they can correct me if my memory is
broken, or answer if the new feature I described here can be useful for them.

> 
> No page identity tracking needed because we measure the END STATE, not
> which specific pages were moved. The early-exit prevents oscillation by
> stopping when the goal is met.
> 
> Why get_goal_metric() Ops Callback
> ==================================
> 
> The bp calculation requires iterating over monitored PA regions:
> 
>     for (pfn = start_pfn; pfn < end_pfn; pfn++) {
>         if (page_to_nid(pfn_to_page(pfn)) == nid)
>             node_bytes += PAGE_SIZE;
>     }
>     bp = node_bytes * 10000 / system_total;
> 
> This requires address-space knowledge that only the ops provider has.
> Existing goal metrics (PSI, node_mem_*, node_memcg_*) are computed in
> core using system-wide data that doesn't require iterating monitored
> regions.
> 
> The new `get_goal_metric()` callback in `damon_operations` allows:
> 
>   1. Core to remain generic - handles all common metrics

I agree this is indeed making the design clean.  But, we already having such
exception, like core.c code using 'damon_target_has_pid().  Having just one
more exception seems ok to me, unless it makes code too ugly.

>   2. Ops providers to implement metrics requiring region iteration
>   3. Clean separation - PA implements node_sys_bp, VA could add
>      different metrics in future

I agree it could be useful for clean support of virtual address mode in future.
But, I'd prefer making this as simple and small as possible for the support we
will use at the moment.

>   4. Optional implementation - ops return 0 if metric unsupported

Again, letting core logic having a bit of ops layer information is not a big
problem to my humble perspective.

So, I'd more prefer not adding the Ops callback, unless you have some other
concerns.

> 
> This design ensures node_sys_bp is only computed when using PA contexts
> where it makes sense, while keeping the core quota goal infrastructure
> unchanged for other metrics and ops providers.
> 
> The callback pattern allows each ops provider to implement metrics
> specific to its address space model without burdening the core with
> ops-specific knowledge.
> 
> Advantages of PA-Based Migration
> ================================
> 
> PA-based migration with DAMON enables integration of multiple hotness
> sources for migration decisions:
> 
>   1. DAMON's native access pattern monitoring
>   2. Fault-based information (similar to NUMA Balancing)
>   3. Future: Hardware monitoring units (e.g., CXL CHMU)
>   4. Future: Instruction-Based Sampling (AMD IBS, Intel PEBS)
> 
> Unlike VA-based approaches tied to individual process address spaces, PA
> monitoring can aggregate hotness information from multiple sources to make
> system-wide migration decisions across the entire physical memory space.

Maybe you are saying about the damon_report_access() based DAMON extension
project [1]?  Since it is not yet upstreamed, and the long term plan is to
support not only physical address but also virtual address space, I think this
section is better to be removed, unless the DAMON extension project is merged
before this patch series.  I expect this patch series will be merged much
earlier than the extension project.

> 
> Complementary to Existing vaddr Migration
> =========================================
> 
> This series complements rather than replaces the vaddr weighted interleave
> migration merged in 6.18:
> 
>   vaddr migration (weight-based):
>     - Per-process control
>     - Fine-grained interleave patterns via VMA offset
>     - Deterministic placement based on weights
> 
>   paddr migration (bp-based, this series):
>     - System-wide control
>     - Target-state goals for node capacity management
>     - No rmap overhead
>     - Aggregates multiple hotness sources

As I mentioned above, the last item could be dropped until the extension
project [1] is upstreamed.

> 
> Capacity Clamping
> =================
> 
> The series also implements capacity clamping for `node_sys_bp` goals. In a
> system where Node 0 has 40% of total RAM, setting a target of 50% is
> impossible. The implementation clamps:
> 
>     effective_target = min(user_target, node_capacity_bp)
> 
> This prevents the quota auto-tuning from chasing impossible targets and
> avoids thrashing in two-context DRAM↔CXL setups.
> 
> Patches
> =======
> 
>   1/5: mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
>        Adds the enum value and documentation.
> 
>   2/5: mm/damon: add get_goal_metric() op and PA provider
>        Introduces the ops callback and PA implementation that iterates
>        monitored regions to calculate node_sys_bp without rmap.
> 
>   3/5: mm/damon/core: add new ops-specific goal metric
>        Wires the new metric into core's quota goal evaluation, delegating
>        to ops.get_goal_metric() for DAMOS_QUOTA_NODE_SYS_BP.
> 
>   4/5: mm/damon/paddr: capacity clamp and directional early-exit
>        Adds capacity clamping and early-exit logic to prevent migration
>        when goal is already satisfied.
> 
>   5/5: mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_metric
>        Exposes the new metric to userspace via sysfs.
> 
> Status
> ======
> 
> This is an early RFC for design review. The patches:
>   - Compile successfully with no errors or warnings
>   - Have NOT been tested on actual hardware

I understand you plan to run tests, and that would be useful, appreciate.  Note
that I think having no test results is blocker for RFC patch series.  So, again
appreciate for sharing this RFC! :)

> 
> Feedback on the overall approach and design is appreciated.

I hope my above comments helps the forward progress of this nice series.

> 
> References
> ==========
> 
> [1] mm/damon/vaddr: Allow interleaving in migrate_{hot,cold} actions (v4)
>     https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gmail.com/
>     Merged in Linux 6.18
> 
> 
> Ravi Jonnalagadda (5):
>   mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
>   mm/damon: add get_goal_metric() op and PA provider
>   mm/damon/core: add new ops-specific goal metric
>   mm/damon/paddr: capacity clamp and directional early-exit for
>     node_sys_bp
>   mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_metric
> 
>  include/linux/damon.h    |   5 ++
>  mm/damon/core.c          |  34 ++++++++++---
>  mm/damon/paddr.c         | 102 +++++++++++++++++++++++++++++++++++++++
>  mm/damon/sysfs-schemes.c |   7 +++
>  4 files changed, 141 insertions(+), 7 deletions(-)
> 
> -- 
> 2.43.0

[1] https://lore.kernel.org/damon/20251208062943.68824-1-sj@kernel.org/


Thanks,
SJ

