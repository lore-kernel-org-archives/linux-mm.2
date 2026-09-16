Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4651C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4126B0095; Wed, 16 Sep 2026 14:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331B66B0098; Wed, 16 Sep 2026 14:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227A26B0093; Wed, 16 Sep 2026 14:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF7486B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:34:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1DD5807AA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:42 +0000 (UTC)
X-FDA: 85220476404.19.59D8924
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf11.hostedemail.com (Postfix) with ESMTP id A643140007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:34:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789583681;
	b=w/XEKutUj54OlYa2+wYvwmxg1RLFd1uhplO/+yQ3bjC+fCfXbjVS//P+1qCYmUBgxViD1t
	EhFwGKqzpMfCuVVOSKBfIdUwpH6DEQqsO25wcpa8Topi0yjZWqQjbH1eHvSB1Js+U7G90v
	QSqlNKy3zgXphn5eRlcy45he4Jm6jCQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789583681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=GGIsjnpMmyXNRzLC0ZPseHxzGUyt5CAd187eVI+5n7w=;
	b=gUSKcz1lOmfica5/gPK3gtewaQdRjb87YjoEXPgqysPBzaMAM0qqSph8RMmNHw2yiliBlK
	xFaz5vFAzLiYYDnZJ5agWsyN2p+MDewsboBglCGemErTX7CQ6+3xr0pv0FXDUctiUlYdXT
	PUDEQcSPnXdTCHCpTiY9Ff+GeblRwnY=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Sep 2026 03:34:37 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	taejoon.song@lge.com,
	her0gyugyu@gmail.com,
	lianux.mm@gmail.com
Subject: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup selection
Date: Thu, 17 Sep 2026 03:34:33 +0900
Message-Id: <20260916183437.2946306-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A643140007
X-Stat-Signature: 4ssj3mxb5oqtdwkqzm1sfe7xfrybfp5o
X-HE-Tag: 1789583680-864184
X-HE-Meta: U2FsdGVkX19TvCMY5r56AXhBlKS4XWrU6CKWC+BpK7ABKOnlP/NUAeYwGv8dSOp31BFnDzUQ5KJ8ahauJoCVv7o0XhRu5IgRzNUn0Kj3K4nULsS3NgbguZ4Nz3Xio+IP1lRC0z8H0IsahDkqmm3PucpL0mMqBwyPgFRvPdf7o9swyp1Hwb+GZgRXD9x0aKc69J3msUBDs2CWsgPoSvqCDdYV+LsVQAt3ZOeimSJLSsogO3jD7T5g653+xmBRNywi3NyRv1QqQogUW+zPXj8ec1+9gPczSLAUjgBrl6jcAxeEUig/RBqp7Xq0LN17w7DmAnXfytsE3PmSdnW48FpB078TVosjld8Vpg7Gr3JnQkPp7o/1EvhtGPLhzNaxCHtq+8NToWAH1P7LEJXRXE993O5fjiMSOHN/YRN2LOtX/vA5pDQmSq4g4TcPVGmN+dic1F6giwvPLs79/tJEJsUmuqcyT5vQ2a77fRtXb218MIle0B5tFUbFtqLSwgtX1b0XGJgIinMVuYMKIerhYtQ6bbfnkIAGj5udaYMkInMbxyy/VHMMUwKnrlgrzltMfOvyZzXaYkiugpIy9xQWagtLziHnxiv78FX/qUFiP6X5Tnv6+iXHlZvmcsayKiFEEjgFzQZNUdDPPLfB9ntHg+r4ut48LXzBwhz7lrIqXfq22ky2ZSkAhLo+dbhTj9QqEZuCrnOv/IC5fN1T/si2pZqTe8ZP2U/MrYKJjkum3rAbU1YoOrFb4MTrkVfZNIBQ4zTku1etsRHbW4yavZACfzlp55Z3v2w13xaoarScV+Lij9Ov/czEUnOLUky4bC3/pbD86yxlt6ieRTzqmxm0ZxxYUo2tPikGOiHkV2MBEjRzydfHnubb/RzzBrsS1F5gcNl0YGzvx29k4Fume/Ql/uDxFKGHgy5GtfEN7QWiYcLJME5xxJ0YIhvpN153pYSq2s6ojO/JlfGnSUSq6d45bqp
 +UlrZdPY
 ivvGihQJRGyI17BpLVZw+8rBOn0wkrsyIfHEPAFc+VJfFHBl6/ImDS8xJGgzKZqQrJsdQlUIPEMiAamw6iHJkyljrzb5MTYSIbjGZtp73jGah9xY1rBcZZY3z3dZIcN3V2XLcr+Al6MZh62SIeaOy6DLvctqO3WmLtXrTGcf4qoUoCmZc6x47KNLRTIY0cacEcM3sdH+OsI1quBORuswWEKHShP4+dNOUbqNSrPlhX32Oqb7sjvIvwB5qACwIQKPaIJhBs7iVi5S3jIsLDOm1Ua7xegM+4/diWit/nGvfVIxZGcN8lZKE+EuxyTcsnvw5ZtInL5wJ03ZW1ajqhIOsteQqzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is RFC v11 of the swap tier series [1], reworked after the v10
discussion [2][3].

Motivation
==========

After the v10 discussion, I would like to first land the parts that do
not affect users, before anything touches memcg, with two goals in mind.

- Serve as a bridge that causes no trouble when the tier interface and
  memcg support are introduced later.
- Make per-cgroup swap device selection possible.

While thinking this through, I came across some insights that I'd like
to discuss with the community. Hence this RFC v11.

As a starting point, let's look at what swap priority already gives us.

- Devices with different priorities are used in priority order.
- Devices with the same priority are used round-robin.

From this point of view, a priority itself can be seen as a tier rather
than a property of a device. Each distinct priority is a tier, the
devices with that priority hang off it, and allocation walks the tiers.

This is one of the insights that led me here. In the v10 design, a tier
was a priority range, so one tier could contain multiple priorities.
That raised two questions.

- If devices in a tier are allocated in priority order, aren't they
  effectively different tiers?
- Is there a real use case for several same-priority round-robin
  groups inside one tier?

If each distinct priority is its own tier, both questions go away.
A tier is one round-robin group, and ordering exists only between
tiers. (Anyone who wants priority-based allocation inside a tier can
still get it through a separate tier interface later. 
mix allocation policy? also possible. we have interface.)

Either way, no explicit tier interface like the one in v10 is needed
yet.

Even when real tiers work are introduced, the view stays the same.

- We want an ordering between tier A and tier B.
- Devices in one tier form one service speed group. How they share
  allocations may become flexible, and will normally stay round-robin
  as it is today.
- On top of that, we will add backend transfer between tiers after
  swap virtualization.

This series changes the current swap code to follow that view, which
gives us the following.

- Per-cgroup swap can later fit into a swap tier interface without
  trouble.
- A base for the per-priority allocation queue series [4].
- It is close to a refactoring of the existing structure, so userspace
  is not tied to an implementation.

Kairui, Lian, would it be okay to use this as the groundwork for [4]?
What do you think?

Per-cgroup swap in debugfs
==========================

Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.

  # swapon -p 100 /dev/nvme0n1p2
  # swapon -p 50 /dev/sdb2
  # cat /sys/kernel/debug/swap/tiers
  Idx   Prio
  0     100
  1     50
  # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers

Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
its index for its lifetime, so the mask keeps selecting the same tier
across swapon and swapoff.

Masks are kept in a list keyed by cgroup ID rather than in struct
mem_cgroup, so the series does not touch memcg code and needs no Kconfig
option. A mask applies only to its own cgroup and is not inherited by
child cgroups.

This debugfs interface is a stepping stone. Once the tier model
settles, /sys/kernel/mm/swap/tiers would list and name the tiers, and a
memcg knob such as memory.swap.tiers.max would take tier names and turn
them into this mask.

Future direction
================

This is not done in this series. If the tiers introduced here settle,
which differs from giving tiers priority ranges, work can continue
along these lines depending on the discussion.

The following are common to both.
- The per-priority allocation queue series from Kairui and Lian [4].
- Add /sys/kernel/mm/swap/tiers.
- A memcg memory.swap.tiers.max interface.
- Per-tier allocation policy (an extension that needs discussion).

If tiers are assigned by priority ranges as before, the tiers here have
to be related to those ranges. When a tier is assigned at runtime, the
devices that fall into its range are merged into that tier.

If tiers are extended the way they work here, a tier stays a priority
and the interface only adds names. A tier starts with a default name,
such as its priority, and can be renamed through the tier interface.

(I think there are a lot of possible way which we can discuss.)

Change log
==========

v11
- Reworked after the v10 discussion [2][3], with no new user ABI.
- A swap tier is now a single swap priority, created and removed by
  swapon and swapoff. /sys/kernel/mm/swap/tiers and CONFIG_NR_SWAP_TIERS
  are dropped.
- The active and available swap device lists move into the tiers.
  (#1, #2 patches)
- Per-cgroup tier selection moves from memory.swap.tiers.max to debugfs.
  (#3 patch)
- Masks are kept in a cgroup ID list instead of struct mem_cgroup, and
  are no longer inherited by child cgroups. (#3 patch)
- Dropped the selftests, which tested the dropped interfaces.
- Rebased on recent mm-new.
- v10 link: https://lore.kernel.org/linux-mm/20260713025644.170839-1-youngjun.park@lge.com/

Changes up to v10 are in the v10 cover letter [1].

[1] https://lore.kernel.org/linux-mm/20260713025644.170839-1-youngjun.park@lge.com/
[2] https://lore.kernel.org/linux-mm/amDCIl51NoNPL7Op@cmpxchg.org/
[3] https://lore.kernel.org/linux-mm/amIlqHQ40baRoz3O@cmpxchg.org/
[4] https://lore.kernel.org/linux-mm/20260829-swap-pcp-priq-v2-0-68d3d925578c@gmail.com/

Youngjun Park (4):
  mm: swap: introduce swap tier infrastructure
  mm: swap: allocate swap slots from swap tiers
  mm: swap: add a debugfs interface for memcg tier selection
  mm: swap: filter swap allocation by memcg tier mask

 Documentation/mm/index.rst     |   1 +
 Documentation/mm/swap-tier.rst |  55 +++++
 MAINTAINERS                    |   3 +
 include/linux/swap.h           |   5 +-
 mm/Makefile                    |   2 +-
 mm/swap.h                      |   2 +
 mm/swap_tier.c                 | 421 +++++++++++++++++++++++++++++++++
 mm/swap_tier.h                 |  71 ++++++
 mm/swapfile.c                  | 173 ++++++++------
 9 files changed, 658 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h


base-commit: b08a65b93426d86e3f354d655d6225397b591877
-- 
2.48.1


