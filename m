Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40C7606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=OiWWvGUc
Received: by kanga.kvack.org (Postfix)
	id C298A6B05B7; Mon,  2 Nov 2026 02:05:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00A56B05B8; Mon,  2 Nov 2026 02:05:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EC26B05B9; Mon,  2 Nov 2026 02:05:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 850E46B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:05:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02AC2A0BE0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:05:40 +0000 (UTC)
X-FDA: 85389293682.21.E6C694D
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf30.hostedemail.com (Postfix) with ESMTP id 128B780005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:05:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OiWWvGUc;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793603139;
	b=uUmylUAmZzjmYwmp9w801j6aFqXHldo/SozORM3wdx5gMgoNP5+q6msggGIFPQGHQu3ahJ
	DdaAWKx3Zz4MGyfnyp/ewkw5GNjABtQFPgoIR735zLQQphg6ED95L1y9q//toPIFcHzfE7
	8xavK2YpkjK+GKimARp6x6f5K5Nputs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=OiWWvGUc;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793603139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9pzLVpw5HDbiXA/WRKY+RZLeQwbQg9GRKfExmkQd1tQ=;
	b=3Gkdr6ldDpDW8RbkdxURRMYdLq0jP7ka0ImGo1SqjuU/9b5QekFxlfK/XkWWLfjjA82gD5
	pThCYRSi8aV8FWQl52zIXFpi4geZO4ZAzO1VeasaJHaT5+YChphxvFWWpnuOgDZdl7jOKK
	AlpG1iVeUX2g09toUdfOeG/PuXldW1g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793603129; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9pzLVpw5HDbiXA/WRKY+RZLeQwbQg9GRKfExmkQd1tQ=;
 b=OiWWvGUcycVItn39v4uVvnI+CgrbskeFEVGfmLnJm8FRtFz4mV/5O5XyplvZBV5nLWrdDn
 vDb4TJZtomzPX6EyE7D5p99nQ42GDZ6fgrfPjh+n9BlQ3cVBliRv3Naj5ngrkuKBh8uopH
 glO/5JlMiH7T9fgwivgDp0pqa9RGN61Mu2chU9Jnc79cL6F3ZiNThw9MCjEpSzFnzH+e9A
 VyaXCNJZ3ZEMY0mGpvhCSWl49xYDFM1NrboDXAtGgwO85HMQBHYRKNyR4maqjrFvKBCYnH
 ShaC3aFbBohHBdBfsluhvfoV5hcENXCYVfBvt5tHKi4+LQGZ5LLMbLMIImsaHg==
X-Lms-Return-Path: <lba+26ae83637+2d29d9+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon,  2 Nov 2026 15:04:39 +0800
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC v2 0/1] mm: add source selector to memory.reclaim
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <rakie.kim@sk.com>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Message-Id: <20261102070440.16262-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 128B780005
X-Stat-Signature: wmrzai8kggh4c69ise8o95t7ghxz6y9g
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793603137-754763
X-HE-Meta: U2FsdGVkX19iQNBdTJLXOUciFfNkqA/vIld/skmKzomz7qQuW4hMNdQjrgwbLYVjhBf8tgAVjlPL9QO6qZ7CiQ85mov6pqUpS/RvRR/49eWF1Obvm3wfbslqy4LluXiqY2sfZJVIIJzIf91cvfT03/hlVBOZs/ONj2LJFQgLIjW6LxBB9Pl92jVwt5s9CbkUHnkfvAKHG1Xae4vJZ2R+PM1WnWsHpl/xtfCHz+mthenGwZuyLR7pVZa0FakKhvixkqE8QKEwGg8mrbRciTFvWnK41SUo7XDtrGyneJnHrKrIcKQmv2A8fv26O4b0Ptpam4KzCFKSaygJChKPq/J4pliWg7lomiS8x0eG2d7MgdwzcfQgwmHwpKWuQ7McQtccHKHLrZjOiZzhTMO2CdiTYGFJWqcM64+PrIjnIkZ28cMltzc0WnBI4Gu4NF8+mFLDO7YGFBBL/OcLtR9I0H6vF1y+TY2yf2wixzRQNcfm6M3JteUGefH/weBEk4Ir7rVoinXS/7cvIBD09oHkXlg1Y3D7phE5VE8qhvjwJru722cMIlP4psqzq1/Gyuy4Pfvd9FokXWXRHg3D/Vut594Atketv9KgOxyEr9mkukuofYsyUr01OPKPilTwWBAG4gDDk4L++2xEkH1vxu5gSSsybcDbXj1+f6hHPIVDuY4fg8dADfJpp1E22fcbIb69U7FRLl0kOhy4Hpqr0+meewklnOKLukrHpeVgBvAcflRfgNqUazfNgyyXbesVTvzNZ5iWqZQeIyt/zGYidw4ToxLE7HoMuNhJGuVhBYXVuBLzWRDz3aJEqwWvUvbNK9WFA9MWwf/h1g9FVjtClR5yoXwLTp6L9yOjPuyC/VCC41gwBTGDQkdXK0xlTrC2nc2kTj2rB2kYiAAEwdSsT4Gcyzs0iYkLX3nFlK7QFCc2ihUx6FJvc6F/eyfxvLU263qKrZnmcsT/zzeoQhjgquujmkb
 NS+OUtGg
 T/StdCtkNr+DbkrqQ3BV+dvrOW69gXzLqyOUH/X26ARyE2BV+YI+5EdCEt1Rw7TaCIAtSVZ6koL5xOvdcZ5kQFH3VTI7KkWBwTvobZEvrhpBaCQv6S7dh0a0KJyC+Y0YTpX0hD63h+ID1UXQN1LqenkZ+9dJnOH6OrZsAiusPgXcQIkc9hK5RGwpdhkN+wuQPZPYQLiMpjdrJxm4fQWRYXGG2nJwvNui3kpUnl3UWTdZYrOyYMtV8j4XTHC3m5c0oD0hxkIU9t9LHZ68RcY2G4EWcUAQ7Rjvqh7cvdaKWOk6eO4OEH8pcryDi9uO9IigNi22hDoLTgRKtq28pu+xg1kmOSz7LogVO1sUY8ZagCm329kyQGZLatj5QNmDA4DAexSgk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memory.reclaim is a useful proactive reclaim interface for memcgs, but
tiered memory makes "reclaim N bytes from this memcg" underspecified for
userspace controllers that manage memory placement across tiers. The
kernel reclaim path may demote some folios and evict others. Without a
way to declare where reclaim pressure should be applied, userspace can
only reclaim from the memcg as a whole and observe one aggregate progress
value.

There is prior history here [1]. The old nodes= proposal tried to let
memory.reclaim scan selected NUMA nodes, but the discussion left several
ABI questions unresolved:

- nodes= did not clearly say whether the mask was a source selector, a
  reclaim domain, or a demotion-target constraint.
- The implementation did not apply the mask to the whole reclaim path,
  so demotion could allocate outside the mask. If userspace interpreted
  the mask as a domain or target constraint, the ABI did not provide
  that.
- Selecting top-tier nodes could become an implicit way to request
  demotion without uncharge. That would make userspace depend on a
  particular reclaim policy and could make future policy changes hard.
- The separate completion-accounting question remained: demotion can
  count as reclaim progress even though memory.current is not reduced.

This series takes a narrower approach. It adds a typed source= key which
declares only the resident source to which the existing memory.reclaim
path should apply pressure. It is not a demotion target selector, not a
demotion-only goal, not an eviction-only goal, and not a change to the
existing completion accounting. Leaving source unspecified preserves the
existing memory.reclaim behavior.

In that sense, this series extends node-scoped reclaim pressure to the
memcg memory.reclaim interface. The existing node memory_reclaim
interface can apply pressure to a node, but it is not scoped to a
particular memcg. This series lets userspace apply the same kind of
source-scoped pressure to a cgroup's resident memory on selected nodes,
while still using the normal memcg reclaim path.

The typed source= form also follows a direction that has recently been
discussed for memory.reclaim. In the zswap proactive writeback series,
the interface was changed from a one-off zswap_writeback_only key to
source=zswap so that other reclaim sources could be selected in the
future [2][3]. This series uses the same extensible key shape, but
defines a different source class: resident NUMA nodes. source=zswap
bypasses ordinary reclaim and performs zswap writeback; source=nodes:
<nodelist> only constrains where the normal memcg reclaim path applies
pressure.

The main benefit of this series is to give userspace a steering knob for
per-node memory placement control. A tiering controller can still build
per-tier policy on top of it by translating a tier to its node list, for
example from /sys/devices/virtual/memory_tiering/memory_tierN/nodelist.
It can then apply reclaim pressure to the nodes that should be relieved.
For example, it can apply pressure to top-tier nodes so that, under the
existing tiering policy, cold folios can usually be demoted to lower
tiers. Another controller may first reclaim from lower-tier nodes so that
later top-tier reclaim has room for demotion. A controller can also
reclaim from terminal-tier nodes when it needs actual charge reduction.

The existing memory.reclaim interface cannot express this. It applies
pressure to the memcg as a whole, so on a multi-tier system the kernel
may make progress in a tier different from the one userspace is trying
to control. That makes a userspace feedback loop for tier ratios
ineffective: the controller can observe that a specific node or tier is
over its desired resident footprint, but it cannot direct the next
reclaim request to the corresponding source nodes.

This version only adds source=nodes:<nodelist>, which is the basic
source selector. More convenience selectors can be considered later, but
the tier use case is already expressible by resolving a tier's current
nodelist in userspace and passing that nodelist to
source=nodes:<nodelist>. Starting with the node-based interface keeps the
ABI smaller while preserving the source= namespace for future selectors.

The remaining issues from the old discussion are intentionally left out
of this series. If userspace needs to control demotion targets, that
should be a separate target/demotion-policy ABI rather than folded into
source=. If userspace needs a strict "bytes actually uncharged"
completion mode, that should be discussed as a separate accounting or
goal extension because it would change the observable meaning of
memory.reclaim progress. This series only adds source selection for the
existing reclaim policy.

Testing:

I ran a simple userspace feedback controller on a CXL test machine. The
machine had nodes 0-2 as the DRAM tier and node 3 as the CXL tier. The
basic matrix used node 0 as the DRAM source and node 3 as the CXL
source for the target memcg, with fio and stress-ng as the load
generators. The controller:

- read anon/file bytes from memory.numa_stat by node;
- aggregated them into DRAM and CXL resident bytes;
- targeted a 1:1 DRAM:CXL resident ratio for the target memcg;
- selected the side above 55%;
- wrote memory.reclaim with source=nodes:<selected nodes>; and
- slept for the configured control period before the next sample.

The controller loop was approximately:

while running:
        stat = read_memory_numa_stat()
        dram = resident_bytes(stat, dram_nodes)
        cxl = resident_bytes(stat, cxl_nodes)
        total = dram + cxl

        if dram > total * 0.55:
                source_nodes = dram_nodes
                excess = dram - total / 2
        else if cxl > total * 0.55:
                source_nodes = cxl_nodes
                excess = cxl - total / 2
        else:
                sleep(period)
                continue

        bytes = clamp(excess * gain, min_step, max_step)
        write(memory.reclaim,
              "$bytes source=nodes:<source_nodes>")
        sleep(period)

The requested reclaim size was proportional to the excess bytes, with
per-workload min/max bounds. I tested 1G, 5G, 10G, 20G and 50G
workloads with 1s, 2s, 5s and 10s control periods. A run was considered
within target when max(abs(dram_ratio - 0.5), abs(cxl_ratio - 0.5)) was
not greater than 5 percentage points.

Basic feedback-controller matrix, final deviation from the 1:1 target:

The 1s, 2s, 5s and 10s columns are controller periods.

The file-cache-CXL-high case used fio under numactl to create about 25%
DRAM and 75% CXL page cache. It reached within 5% by at most the
eighth control cycle, and all 20 runs ended within 5%.

size  1s     2s     5s     10s
 1G   3.96%  3.96%  4.45%  3.96%
 5G   2.65%  2.75%  2.65%  2.65%
10G   2.65%  2.68%  2.65%  2.69%
20G   2.65%  2.66%  2.66%  2.64%
50G   4.31%  4.31%  4.31%  4.31%

The anon-DRAM-high case used stress-ng under numactl to create
anonymous memory on DRAM and used swappiness=max so that the normal
reclaim path could demote or reclaim anonymous memory. It reached
within 5% by at most the seventh control cycle, and all 20 runs ended
within 5%.

size  1s     2s     5s     10s
 1G   0.15%  0.02%  0.16%  0.02%
 5G   3.16%  3.13%  3.14%  3.13%
10G   3.13%  3.13%  3.15%  3.12%
20G   3.12%  3.13%  3.12%  3.12%
50G   1.88%  1.88%  1.88%  1.88%

For comparison, I also ran the same controller and workloads without
the source=nodes selector. The controller still chose the side above the
target and computed the same request size, but wrote plain
memory.reclaim without a source constraint.

case                  final <=5%  reached <=5%  worst deviation
file-cache CXL high        1/20          1/20     50.00%
anon DRAM high            20/20         20/20      5.00%

This shows why the source selector matters for placement control. In
the file-cache-CXL-high case, plain memory.reclaim could not reliably
control the target ratio without source=nodes. In the anon-DRAM-high
case, plain memory.reclaim worked well. This is likely because, in this
setup, the whole-memcg reclaim walk reached DRAM nodes before CXL nodes,
so it already applied pressure to the over-target DRAM side first for
this workload.

I also ran a disturbed case with external reclaim and demotion activity.
The target memcg used stress-ng under numactl to create about 25% DRAM
and 75% CXL anonymous memory. NUMA demotion and zswap were enabled, and
watermark_scale_factor was raised to 3000 so background reclaim became
visible in a short run. A ballast cgroup kept DRAM free memory low, and
a separate CXL-heavy cgroup kept reclaim activity present on the CXL
tier. The result below was measured on the target memcg.

During the matrix, pgdemote_kswapd increased in 16/20 runs. The
CXL-free-down/DRAM-free-up/pgdemote pattern appeared in 13/20 runs.
Even with that external activity, the target memcg controller still
drove its own DRAM:CXL resident ratio toward 1:1.

Disturbed case, final deviation from the 1:1 target. The 1s, 2s, 5s and
10s columns are controller periods:

size  1s     2s     5s     10s
 1G   1.18%  1.11%  1.11%  1.42%
 5G   2.14%  2.06%  2.14%  2.14%
10G   2.13%  2.10%  2.15%  2.11%
20G   2.15%  2.23%  2.15%  2.43%
50G   4.87%  4.87%  4.89%  4.87%

All 20 disturbed runs reached within 5% by the third control cycle and
ended within 5%. This does not make memory.reclaim a one-shot footprint
guarantee, but it shows that source=nodes can act as a useful
feedback-loop actuator.

References:
[1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
[2] https://lore.kernel.org/all/20260629112032.20423-1-jiahao.kernel@gmail.com/
[3] https://lore.kernel.org/all/20260629112032.20423-5-jiahao.kernel@gmail.com/

Li Zhe (1):
  mm: add source selector to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst |  9 +++++
 mm/bpf_memcontrol.c                     |  3 +-
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 ++++--
 mm/vmscan.c                             | 49 +++++++++++++++++++++++--
 6 files changed, 70 insertions(+), 11 deletions(-)

---
v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/

Changes since v1:
- Reworded the cover letter and documentation to describe the interface
  as applying reclaim pressure to a selected resident source.
- Added the lower-tier use case where userspace reclaims from a lower
  tier first so that later top-tier reclaim has room for demotion.
- Dropped patch 2, the tier convenience selector, for now. Tier-aware
  userspace can resolve a tier to a nodelist and use source=nodes.
- Added references to the zswap proactive writeback discussion, which
  also uses the typed source= form to keep memory.reclaim extensible.
- Added CXL feedback-controller test results using fio and stress-ng
  load generators, including a no-source baseline.

-- 
2.20.1

