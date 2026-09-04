Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE7BC79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 07:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224626B0088; Fri,  4 Sep 2026 03:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5D96B008A; Fri,  4 Sep 2026 03:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB856B008C; Fri,  4 Sep 2026 03:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D61BA6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:13:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E78F1206EE
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:13:18 +0000 (UTC)
X-FDA: 85175213676.12.0FCAC16
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7F78C0004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:13:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788505996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TnJ3GcPQ8Ohm7bJDDF2RqjEhq9oi8J+AhVjzEAnv+JY=;
	b=r/3dz1qNfS7mpBJu+6gNsGMy+urB+mTuQD16XNBYQBFnNm2moqSEHRFxl+Vw3BU7PpRkKl
	0BQ9ChWMCWzS9E8UqvtK46ommeHgBV8nVk+0pDlaGOUUoWBhjENnmFwKJicgnXtdJ+kNoa
	0CBD9s7tMiSK+PEVIZXBLKqLc29v1IY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788505996;
	b=6pvCQxK/J4p8/+303t2xP4/Sa7e4nbXfRQDWFETW3Gzzlm0Pfp1PlkA7jkaLM5qAHOQfxA
	CtW1Akq0RRsSsaUywa6ekc++ZCEsVgvEvUEPlQO5hlnfLPAQmLPdwMjKF/qmiA+yjzAJaZ
	YTuMXzijmpvx/uubUsGD0LDExHc8LCc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.52 with ESMTP; 4 Sep 2026 16:13:10 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 4 Sep 2026 16:13:10 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 4 Sep 2026 16:13:10 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 00/13] mm/swap: introduce per-priority
 allocation queues
Message-ID: <appvhlPleahTRklV@yjaykim-PowerEdge-T330>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7F78C0004
X-Stat-Signature: xxah57h665eu168i8qp97sed6z6isgr7
X-Rspam-User: 
X-HE-Tag: 1788505994-18304
X-HE-Meta: U2FsdGVkX181M5s38zWue2Jj8kFegpkk74uVdcpMxPMMgTOYrwbSWjALdY5GSp3CqDBY6irMdkCERgVSrhufj6Vb5EgzDYi2fh9QN1qcUq4L1vXzbL9m4E8b7xAZeZsDWcWpGkh28f8BHwFUWSD+Q1ZaHYkASQ1NgF1cWSUMC4SfH7X3b6CfXk4w19fkKFbzASsNT9YgD0YCPXPJquJh8ffhI1oOgG3Px8TPMuvKq39JY6TNNg9ses8c61dAv+EAU/FUVlih++8EhM+pegNWLtADGtYnp1sfR4bsXtqfq56eGnJ27FhwBnRTGjM9QQC4NyaA7IdpQUWpZNhFQTMrQHkLGX1ZDBLuNkCFAaWEPqqJcD0Ggg1bxKz4jyGNiiogfiVatgc1PI/JKNQPTr/dVFSRI4EcfSuB5riki5Gs2fmTEtiE39+icvm6WYV4+K2nHXWhIIiHf8ix3O2ZwM2rRltVnTBhcOZzEKcJnHK1UxCBrTfifdlR2Pirlxmkej8D0hD024oUq6/yRCFd73mpn3zocO9bKCHsmnbc6BJ9+TESFkSnetffBzf1ZxkqG7IO97668SnBm0p5WQ46lQfVxdXRcLnh6l+VPnsa4xbB2nSkaX2fsRI8WagX5/k5d/msxgU9tFRMsmW4L7cyUa0HstAKgYmCMpEf8xEz91GPvhjAxfyTJv07VnJuRob8hrKrDqCu2vz4k36WbyNJfQXI1QnW3/zT7zyaMV66+RqIrqFE3TkWaeA78pmkwSdyirNcptuK5Tx+lloW1EmuqqEnnkIa6ww28oxGSRmdP2fYsn+Kq4ffRUy3WqSNPNMddBHXCzxtlHDwrVdqeuZCZZxRwtv61YjHIcwa9b+y1gFA7brlu2WXwECarr8lq9bJfLKGmJbECQmymMscocWfka535LHDMydhixTWlhjIzRPdUC+lNcDzyzR5uMYii3EqaO9krMo4i4trEXkxc8T4zw+
 X1/6o1HJ
 IyeXo7P/pKz5C0+dcgrMFc/wILCH0Mvo5sROmqXxQwDoPndb4VUHVK9RqQ0GsYIS5zu1aKnKcd5ptCGWz4VyxVFXOUjTtaD+uX8Q4k4rOpt+lrK58PWri19bg4i3N4bL8yU9uXINkszRKh1kXFkgkb/Tv2ExrkxdMvJj1D07mbHPa9Mzzd7hF6v/04rDv+gGgDSq1OCpRFNBcUpfFpI0aiEuV05V7ERRiRE75GmDYDCDVj1InqPKp2/vFsdJ6uBS4s9Nv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 03:43:50PM +0800, Lian Wang (ProcessMission) wrote:
> Hi all,
>
> RESEND: Only the first cover letter was sent, with an outdated sender
> display name.  No patches from the series were sent.  This resend uses
> the corrected sender identity and starts the complete thread.  There are
> no code or content changes from the previously reviewed v2 draft.
>
> This is v2 of Kairui's swap priority queue RFC [1].  With Kairui's
> agreement, I am carrying this revision while preserving the original
> authorship of his patches and Youngjun's per-device percpu-cluster patch.

Hi Lian,
Thank you for work!

Since tiers come up further down, I'd like to raise a point about the
patch subject line too. As Kairui mentioned in RFC v1 that we would
stay aligned with tiers, would it make sense to frame this RFC as a
per-tier allocation policy (or something along those lines)? Kairui,
what's your opinion?

Devices assigned to the same tier already share the same priority, so
I don't think the allocation policy needs more than one option for
that case (I can't think of a use case that would need it).

1. For legacy swap with no tier configured, define it as a single
   priority treated as one tier.
2. When priorities match, allocation naturally falls to a single
   policy (not a queue). the concrete policy here is this
   queue-based scheme.
3. When tiers are enabled, devices previously assigned under legacy
   swap are reassigned to tiers at runtime.
   (This means different swap device on same tier handled like same priority device)

Point 3 reflects my thinking based on the current tier implementation.
Current tier concept is good enough, but I keep thinking how to improve...
(This means I don't think we need runtime tier enablement with
 ability to change swap tier number range. swap device on/off & priority change not that dynamic? right?)

There's an alternative tier-assignment approach that might fit this
series better, and I'd like your thoughts on it.

a. Fix the tier as a boot-time parameter.
   (This way, legacy swap without tiers never hits case 3 at all. On
   kernels with tiers enabled, swap devices are assigned per their
   tier, and devices in the same tier follow the same policy even if
   their priorities differ. plus ther is no swaptier interface management
   add, remove, etc)

b. If boot time isn't preferred, define tiers at compile time by
   grouping equal priorities, or by splitting the priority range into
   1/n buckets based on the number of tiers.
   - The tier interface would then only allow naming (or should this
     also be fixed at compile time?)
   - grouping equal priorities strategy has some limit like

I think this direction aligns well with this patch and, in some
ways, leads to a cleaner architecture. But, both (a) and (b)
have rough edges once I try to work them through in practice, and
each would need to be resolved one at a time with agreement before
introducing it. I'd like to hear other opinions, and if this
is acceptable, I'll introduce original and this idea.

> My substantive code changes are concentrated in patches 3, 9 and 11.
> Patches 5, 10 and 12 contain the dependent adaptations needed to keep
> the stack coherent and bisectable.  The code patch-ids of patches 1, 2,
> 4, 6, 7, 8 and 13 are unchanged from v1.  My Signed-off-by on the full
> series records the handoff and DCO chain; Co-developed-by is limited to
> the three patches with substantive changes.
>
> The current swap allocator rotates swap_avail_head with plist_requeue()
> when it moves between devices of the same priority.  That couples device
> selection to the global cluster cache and serializes cluster transitions
> on swap_avail_lock.

> This series first restores per-device percpu clusters, then replaces the
> allocation-time plist rotation with a priority-ordered queue.  Each
> priority has a mostly immutable ring of devices.  Per-CPU readers rotate

I think this feature will also be needed on the virtualized swap side,
which makes me wonder whether this patch should go back into the swap
tier series instead. Kairui, Lian, what do you think? (Or separately?)

I've also been thinking about how to move the tier series forward
since v10. I'll prepare v11 shortly.

> within a ring after a fixed allocation quota, so the allocator preserves
> strict priority ordering without contending on one global rotation point.
>
> The queue is also intended to separate device selection policy from the
> per-device cluster allocator.  Youngjun's swap-tier series [2] remains

FYI, the thing I've been hesitating over since v10 is that there was
feedback that going through the memcg interface needs more swap code matureness (backend transfer)
and discussion,
so I needed to settle on a direction first.

This patch itself looks like it could align well with the swap-tier
use case (see my note on the interface below). As mentioned above,
I'll follow up with the tier series soon.

> under separate review. This RFC does not introduce a tier ABI or assume
> that the tier series has landed: a ring is keyed by the existing swap
> priority.  If tiers land first, the same queue can become an in-tier
> allocation policy rather than a competing tier definition.

This is the direction I was hoping for. (TBD)

Within a tier. /sys/kernel/mm/swap/tiers/<tier name>/<policy name>

- Across tiers: allocation follows priority based on speed
  differences.
- Within a tier: a selectable policy applies.
  - The default policy is this series' scheme.
  - Priority-based distribution should also be possible within a
    tier.
  - If xswap is introduced, its allocation should be selectable based
    on memcg.
  - Other custom allocation methods (round-robin, etc.).

...

> Testing
> =======
>
> Kunwu ran an A/B/C/D/E matrix on a Kunpeng 920 server with 256 CPUs,
> 249 GiB RAM and an aarch64 kernel.  The workload built a fixed kernel
> source with "make -j96 defconfig Image modules" under 2 GiB and 3 GiB
> memory cgroups, using eight equal-priority ZRAM devices.  Every arm used
> one warm-up followed by 12 measured runs.
>
> A/B/C share the v1 base and reproduce the progression reported in v1:
>
>   A: before the series
>   B: after patch 8, with per-device percpu clusters but the old plist
>   C: after patch 13, with the complete priority queue
>
> D/E share the tested v2 base and isolate the current series:
>
>   D: before the series
>   E: after all 13 v2 patches
>
> 1. Reproducing the v1 performance shape
>
> Average system time over 12 measured kernel builds:
>
>                               2 GiB       3 GiB
>   Before (A)                40899.14s    22621.86s
>   After patch 8 (B)         88712.52s    53244.70s
>   After patch 13 (C)        41140.76s    22925.48s
>
> Patch 8 alone increased system time by 116.9% in the 2 GiB workload
> and 135.4% in the 3 GiB workload.  Adding the priority queue returned
> system time to within 0.59% and 1.34% of A, respectively.  The absolute
> times differ from the v1 machine, but the expected performance shape is
> reproduced: moving the cluster cache back to device scope is expensive
> while allocation still rotates the plist, and the queue removes that
> contention.
>
> 2. Isolating the v2 delta
>
> Average system time over 12 measured runs:
>
>                               2 GiB       3 GiB
>   Base (D)                  39643.77s    22139.66s
>   Full v2 (E)              40336.91s    22984.62s
>   Delta                       +1.75%       +3.82%
>
> Average elapsed time, with sample standard deviation:
>
>                               2 GiB       3 GiB
>   Base (D)              518.97 +/- 5.87s  334.07 +/- 4.01s
>   Full v2 (E)           527.24 +/- 5.21s  342.98 +/- 2.78s
>   Delta                       +1.59%       +2.67%
>
> The arms were run sequentially rather than interleaved, so these small
> D/E deltas may include temporal drift.  They are reported as observed
> instead of being described as zero regression.

No regression is great news. the plist refactor is valuable on its
own merits.

That said, could you also share data on other angles, such as lock-
contention benefits, or advantages in other use-case scenarios? (I'll
also think about what would be worth testing here.)

I've done an initial pass and given my review. I'll keep providing
feedback as I go through the patch contents. :)

Youngjun

