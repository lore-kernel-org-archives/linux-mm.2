Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6C7C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6909C6B008C; Fri,  4 Sep 2026 02:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640686B0092; Fri,  4 Sep 2026 02:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558A06B0095; Fri,  4 Sep 2026 02:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9696B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:52:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F6A580680
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:52:38 +0000 (UTC)
X-FDA: 85175161596.30.C7336A2
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf20.hostedemail.com (Postfix) with ESMTP id F21081C0002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:52:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=O6rjfpBa;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788504757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=28SnKEvKoJ3nWwHB2ftkFSyFO3g/G4nEKnDXDivfznM=;
	b=nwdTzfIpBC4txAABSuw8dpaYJUG0vVz8K7fOjPMAHLyZ11fiweu4ZbD6WopZTQuiExtlpN
	wRS7Fgj1m9fLJDcuil11v2f6w98yxWfdfvniSIzg1qrLM0u7qkLtiWTSkxRzO+rOb3grKz
	22zNhYPlJjUZybsbePpnErdCDplLyEM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=O6rjfpBa;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788504757;
	b=GJBSIkcgmSlkT9srs+CxJRg3bAlrFrWuUmeZj18NvhgLEn1wNBDewx4ZtbRy9O99tLFUf1
	dXXrgvPUDMYWilqZJ+Z6DqX+XiCeFADLfCFG93v7RZjxL3BdioDgKU8lqMvlwT9jcY7cpf
	65a85r8Qg0rS32JQG1xVTGUzO2YYX/s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788504748; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=28SnKEvKoJ3nWwHB2ftkFSyFO3g/G4nEKnDXDivfznM=;
 b=O6rjfpBak0JRuHQ3Q0TsStrZ5DrTED/F43Kw59lqymysp4p3BN9D37Hock/VNXTr6dzr72
 QcYCHW5/nKmaZTU2dNkVlYgv4dfDWdCNO1/jJ8N4ZJBn2Zyd1dw+KqNW2Q+LBkZ83nsjvj
 DgD/Op2O9pQMgQE+8k6BtSCU7qvsS4YtAU12lSzodKvysglQbp1wXvK3odRJI+q3rfHe4T
 bIFkmjqGZHhinSbbZHDakUuW4mrIyZpYtftbgg1fgIiTAxtFInMcuannl4HyXnsizMPR9C
 qgStbSE82nrAPeD4yCFjSK4Z0I0wCgIKR5dnI+e4Ri0YWlTqX8Ev+y0uIilkrw==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <qi.zheng@linux.dev>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC 0/2] mm: add explicit goals to memcg memory.reclaim
Date: Fri,  4 Sep 2026 14:51:57 +0800
Message-Id: <20260904065159.34409-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a9a6aaa+cf76a3+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: r8wncwm7xr5spnki8jigbg9unkwz3xxj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F21081C0002
X-Rspam-User: 
X-HE-Tag: 1788504753-636427
X-HE-Meta: U2FsdGVkX1/Rg6AfAO7pQGovB/+iX0+ZmKU5XT4/w74JAyzczd8SYIjpWe4yVUQGEyHRitGNvyT6gCgmCyWPT+LjgPUn+3/OI5IuEKp0rDda1xrRtkUZhPv2Sw+jF44HI4cwFHNm3oBKlRPljt3DbPGKw/UsGkRfjM5wZzRHAMee8iCVL8Dc8OLeyY1ErjKtZRr7fZnKKWQJ+Pt/g2DS68zZOS8btMA1c0cWgG4BTgbQGFytDiywzzwB5adtZdmKq8K03Umi952vAFakS+RgbFN4gqKTD0MFpZu8/8+Nq/lXeBuqSZG2i0HW7if3hEnOsAygZty0Vy+S9B3ybHqbseNkI4/Y6obdJuZJDVtO7oBMRiiPgZ03Oae/wBhGZVyE0WSoIWedaRP0t61PeJLykx+bcFaEF4HwtavxlWMuwVTO2phi8pN8NB8m/K0stnEVfXvZKUvlDkTPqGVuW4cklOkeS1QDdE6JsFWlV7aA5OMk0owsguZuNMkTGAKSHgDRGzRiX3fwWWEgiMGa4+RYqJq9xbWj63SP9sVBZh0RnnhjzWVVibIyLv8HeFsFJ13d//jwyoZTMjcqBOPCl2jDEy76/46BKqqcYtas5/4NkN4dsSEtMvHSEpi0j1gAahrlmvKoMW5WqaI/OhzaP15P4HTk3hTmBRsap8OWV9HTyNyEhMeW82zAMuB9vCyhoP8emom1tN3jwKSGQCVYGFtpWOITH+9LHeQQsqMyrN3o+HWKewfeO0PsJcuRx2Mx1zcdeX6+rDHcwxfdjy2NwTQ/COahvajBrq+G30ds5uG3u3YVYfq9B5H9NAU/2/2ODsfENaYZVt08ZCUTHWRzKb0OIxhq4qGfvFzWqv5z66sXsUU/Q6luEaOz8zBOj6pQ2XFiRvXvDYRb95ih/wklsqd0qOpkPUW6sLcIs9jQTHixgig734r5jjmpAeHXJIkP9lHVAvHeq7CzH6+8ZJ2THIp
 t1XgHbhW
 8hhmUzgDbgFK/pgcTgjFArT/tcFNCBPXI/EdM4H8gdrC+mlk9uoikKqW3oNsT4yad1fJamUbZfhhCKjBOXlMPlmpwuKUsffNL1mUK+Ng6c7skmzRGPXHnsjSPnVdeJ2hb5lnnZBc3nwI1RYiPUbbtl+5rVmqtodid+0gWfJZ/jZgP1hOrUG7arZn3dmJTpH+sgTWWjNfzcUt8l7r8IAFSuT5GTu7rP7cyn+GTvgIxoAZFt4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory.reclaim is used by userspace controllers as a proactive memcg
reclaim interface. On systems without memory tiering, a completed request
is normally interpreted as eviction-oriented progress: pages were freed
and the cgroup's charged footprint can drop.

Memory tiering makes that interpretation ambiguous. The reclaim scanner
may satisfy the requested amount by demoting cold folios from a faster
tier to a slower tier. That is useful aging behavior, but it means a
request can complete even though the cgroup's charged footprint is
unchanged. Userspace controllers that rely on memory.reclaim for actual
cgroup footprint reduction therefore lose the ability to request the same
kind of outcome they get on non-tiered systems.

At the same time, some controllers want the opposite operation: use the
reclaim scanner as a best-effort placement mechanism to move cold folios
from DRAM to CXL or other lower tiers, without evicting them from memory.
This can be used to maintain top-tier headroom or a desired
DRAM/CXL occupancy ratio according to workload policy.

This series keeps the existing behavior as the default, and adds explicit
opt-in goals for userspace controllers that want a more specific outcome
from memcg memory.reclaim:

  echo "1G goal=evict" > memory.reclaim

    Run the normal reclaim scanner and keep demotion enabled as part of
    tier aging, but do not count successful demotion toward completing the
    requested amount. This lets callers ask memory.reclaim to continue
    until eviction progress, rather than demotion-only progress, satisfies
    the request. If the cgroup has no usable demotion target, goal=evict
    falls back to the default goal=progress behavior.

  echo "1G goal=demote" > memory.reclaim

    Use the existing reclaim scanner for best-effort memory tier demotion
    without LRU folio eviction. This is intended for placement control,
    such as maintaining top-tier headroom or a desired DRAM/CXL occupancy
    ratio. Demoted folios remain charged to the cgroup, so this goal does
    not imply memory.current reduction. If the cgroup has no usable
    demotion target, the request fails early with -EAGAIN.

The default remains goal=progress, which is the current memory.reclaim
behavior. In that mode, the kernel's existing reclaim progress accounting
is unchanged and successful demotion can satisfy the requested amount.

Patch 1 preserves the tiered LRU aging model. It changes the completion
accounting for an eviction-oriented request, while still allowing demotion
to happen as an intermediate step. After enough demotion has been done in
a batch, reclaim avoids repeatedly scanning the top tiers in the cgroup's
allowed demotion hierarchy just to produce more demotion-only progress,
while still allowing lower tiers to age or reclaim normally.

Patch 2 constrains a request in the other direction: it allows best-effort
demotion as the requested action, while keeping folios that are not queued
for demotion instead of evicting them from the LRU. It also skips slab
shrinking, because slab reclaim cannot contribute demotion progress and
would otherwise be retried aggressively for an underfilled demotion
request.

This also keeps the ABI scoped to the existing memory.reclaim interface
instead of adding a new cgroup file. The goal key describes what kind of
progress the caller wants from the request; it does not select a source or
target tier, does not provide strict placement guarantees, and remains
subject to cgroup protection, swappiness balancing, reclaim eligibility,
and demotion target availability.

This series is memcg-only. The per-node reclaim interface shares the
parser but has different semantics: node reclaim can legitimately treat
demotion as the desired way to relieve pressure on a node. For that
reason, the new goals are rejected from the per-node path rather than
being given a different meaning there.

Li Zhe (2):
  mm: add goal=evict to memory.reclaim
  mm: add goal=demote to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst |  26 ++++
 include/linux/memory-tiers.h            |  13 ++
 mm/internal.h                           |   2 +
 mm/memory-tiers.c                       |  35 +++++-
 mm/vmscan.c                             | 154 ++++++++++++++++++++++--
 5 files changed, 219 insertions(+), 11 deletions(-)

-- 
2.20.1

