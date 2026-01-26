Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40322C88E57
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 06:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C8E6B0092; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD4D6B0096; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94BA6B0092; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 975CA6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:53:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F62B13B765
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:53:40 +0000 (UTC)
X-FDA: 84373199400.01.A183E79
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id 25708160006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:53:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769410418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=2hIM1pprJ3wQivRSRw3ksBJeRWn6zwjMimAUjUO6pUc=;
	b=x/vVvprE9/EbZyk7bNNrkjlZctKyfpzwp7NyTNnb/YudtWrEzxzQiaTJJyz67eVKI3iKe8
	3nqzWPUOv13gO6efJ/4aY09dyxzTobvybv9hbdwXc1whO/42m37/xPyt84JoXEvDVw6qfA
	DjI5WR7Msbm+yWNuyJWK09sjPXen470=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769410418; a=rsa-sha256;
	cv=none;
	b=8GqTZk26Gw2Ir/mfQO2/EhAfoBJNeKAU5POeh2Ugh8cABmYm4WoGJYSRUdCX7cR6Q9nQHE
	zyaxCc5dIr+HxmDmWexrKramcgHtOFYY2sN1i5n3Zw6JEPEG2tlCrdNxhWXurgCR7pglJH
	eHlDqzvqDwh8LhLHWOXZVFAf4czls6g=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Jan 2026 15:53:33 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	austin.kim@lge.com,
	youngjun.park@lge.com
Subject: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Mon, 26 Jan 2026 15:52:37 +0900
Message-Id: <20260126065242.1221862-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25708160006
X-Stat-Signature: iisjuwuojq75pkaeukxhgjhxwk93xtn5
X-Rspam-User: 
X-HE-Tag: 1769410416-433809
X-HE-Meta: U2FsdGVkX18fY93Dk1lS4jmTduYuyY7IlmBfNQCyQfxjnyOwT+I6TRcfYTqIvcAr6TduJ4dgQyblpQ8WYRWp0g5sh5jTFdShltTfEbOZ5aMjziJtVLD6wf8tzwKhwrTUg1SnrcQAt5C2CBXy1cPHRUJv0V8wnSXYwAnePo4iFMvnW8H8HREyF/3N58XLlhCuh86bkaW3NG5TWBaoO8sjzh0eqmXLRbswdT6jipHLIMxL23yOMv/FPIkM886wP0UFhYcb9sf6wXUTWtH8Ogi3Sjt+I3ljT36+SLN5wqUOzrVEOiksxgI4roF4NZ1QG8wzxJRARnZkDwQLDOWK9TwPH1FHBvOP/I1dFqYOJBrwTSOyzGXuR5+X/Tu9Fph2zu1Jmya4JI16JktmwCJYWNTl2v6xIUb+SKJKWsjyKrJvj+1kONsEDq6/F2TKjwAhL1UHRYsMRJUjYsc+8ADwhIe2ubUjZ9fzlvDpG4TQmaa1a9KHP+8Z20dx7pW1fgai5pEmmtM6YuUU6tXEPPIgYXroJf5VZkGNlq7InAraIAdwZrQTqP2y+YDgJsXgRcJ5PKfRjHEERq/7h/2EsMI+X5g6GMi/+oux19Lg7sD8PLlIO8xLvmfO9hZFaY2vWZ1U7eErwV+wGESq/C9OjvoRUuvaax1alfOYy0UNVdC4w8/PpFQbJDdFv4or6eIKZcYRI9xkRjusBhpVeuORJmYtO2dgMnHg/NHPLAIGi4MP2ToRRik4Etge1b2Qj/xR2DDcjEZJtckEuE0BR2gCMw4r0AdkQbJnUnCy9g6ztLyrOn9G1E7oiXe7VktTjfHiZg0ytn3LAsXhWauK1l7JjMH/DevQwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the second version of the RFC for the "Swap Tiers" concept.
Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/

This version incorporates feedback received during LPC 2025 and addresses
comments from the previous review. We have also included experimental
results based on usage scenarios intended for our internal platforms.

Motivation & Concept recap
==========================
Current Linux swap allocation is global, limiting the ability to assign
faster devices to specific cgroups. Our initial attempt at per-cgroup
priorities proved over-engineered and caused LRU inversion.

Following Chris Li's suggestion, we pivoted to "Swap Tiers." A tier is
simply a user-named group of swap devices sharing the same priority range.
This abstraction facilitates swap device selection based on speed, allowing
users to configure specific tiers for cgroups.

For more details, please refer to the LPC 2025 presentation
https://lpc.events/event/19/contributions/2141/attachments/1857/3998/LPC2025Finalss.pdf
or v1 patch.

Changes in v2
=============
1. Respect cgroup hierarchy principle (LPC 2025 feedback)
- The logic now strictly follows standard cgroup hierarchy principles.

Previous: Children could select any tier using "+" regardless of the
parent's configuration. "+" tier is referenced. (could not be silently disappeared)

Current: The explicit selection ("+") concept is removed. By
default, all tiers are selected. Users now use "-" to exclude specific
tiers. Excluded tier could disappeared silently.
A child cgroup is always a subset of its parent. Even if a child
re-enables a tier with "+" that was excluded by the parent, the effective
tier list is limited to the parent's allowed subset.

Example:
Global Tiers: SSD, HDD, NET
Parent: SSD, NET (HDD excluded)
Child: HDD, NET (SSD excluded)
-> Effective Child Tier: NET (Intersection of Parent and Child)

2. Simplified swap_tier structure (Chris Li)
- Replaced 'end prio' and priority lists with standard list_head.

3. Reference counting removed
- Removed refcount for swap_tiers. Liveness is now guaranteed by checking
if the swap device is in use.
- Since the default selection is "ALL", holding references for disappearing
tiers is unnecessary. only exclusions ("-") matter.

4. Support mixed operation (/sys/kernel/mm/swap/tiers) (Chris Li)
- Supports mixed use of "+" and "-" operations.

5. Add modify operation
- Introduced an operation to modify the priority of existing tiers.
Format: "tier_name:priority"

6. Restore swap device cluster allocation rule on same swap device priority (Kairui Song, Baoquan He)
- Preserve existing fastpath and slowpath swap allocation logic using percpu swap device cache.
- Therefore, the swap device cluster allocation rule is preserved on same swap device priority

7. Remove compile time selection (Chris Li)
- Removed CONFIG_SWAP_TIER. this is now a base kernel feature.

8. Cgroup tier calculation logic update
- The effective swap tier for a cgroup is now calculated at the time of
configuration (writing to swap.tiers), rather than at the time of swap
allocation.

9. Commit reorganization (Chris Li)
- Commit order reorganized for clarity.

10. Documentation (Chris Li)
- Added documentation for the Swap Tiers concept and usage, as explained in
the RFC.

Apply and Benchmark
===================
1. Real-world Scenario: App Preloading
We applied this patchset to our embedded platform to enable application
preloading for faster launch times. Since the platform uses flash storage
as the default swap device, we aim to minimize swap usage on it to extend
its lifespan.

To achieve this, we utilized an idle device (configured via NBD) as a
separate swap tier specifically for these preloaded applications.

While it is self-evident that restoring from swap (warm launch) is faster
than a cold launch, the data below demonstrates the latency reduction
achieved in this environment.

Streaming App A:
Before (Cold Launch): 13.17s
After (Preloaded): 4.18s (68% reduction)

Streaming App B:
Before (Cold Launch): 5.60s
After (Preloaded): 1.12s (80% reduction)

E-commerce App C:
Before (Cold Launch): 10.25s
After (Preloaded): 2.00s (80% reduction)

We have a plan to solidify this usage and expand the usage.

2. Microbenchmarks
In response to feedback regarding potential regressions in the swap
fastpath (specifically concerning the overhead of global percpu clusters
vs. swap device percpu cache), we addressed this in RFC v2.

By preserving the existing fastpath and slowpath mechanisms via the per-cpu
swap device cache, we ensured that the performance characteristics remain
unchanged. The simple benchmark results below confirm there is no
significant difference.

A. Build kernel test:
Test using 128GB swapfile on Simulated SSD, Qemu VM with 4 CPUs, 4GB RAM,
avg of 5 test runs:

              Before        After
System time:  1584.20s      1590.74s (+0.41%)

Considering the deviation between max/min values, there seems to be no
significant difference.

B. vm-scalability
usemem --init-time -O -y -x -n 32 256M (qemu, 16G memory, global pressure,
simulated SDD as swap), avg of 5 test runs:

                           Before          After
System time:               588.48 s        592.15 s
Sum Throughput:            16.65 MB/s      15.95 MB/s
Single process Throughput: 0.52 MB/s       0.50 MB/s
Avg Free latency:          1098422.97 us   1106388.97 us

The results indicate that the performance remains stable with negligible
variance.

Any feedback is welcome.

Thanks,
Youngjun Park

Youngjun Park (5):
  mm: swap: introduce swap tier infrastructure
  mm: swap: associate swap devices with tiers
  mm: memcontrol: add interface for swap tier selection
  mm, swap: change back to use each swap device's percpu cluster
  mm, swap: introduce percpu swap device cache to avoid fragmentation

 Documentation/admin-guide/cgroup-v2.rst |  27 ++
 Documentation/mm/swap-tier.rst          | 109 ++++++
 MAINTAINERS                             |   2 +
 include/linux/memcontrol.h              |   3 +-
 include/linux/swap.h                    |  17 +-
 mm/Makefile                             |   2 +-
 mm/memcontrol.c                         |  80 +++++
 mm/swap.h                               |   4 +
 mm/swap_state.c                         |  70 ++++
 mm/swap_tier.c                          | 452 ++++++++++++++++++++++++
 mm/swap_tier.h                          |  70 ++++
 mm/swapfile.c                           | 132 +++----
 12 files changed, 900 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
-- 
2.34.1

