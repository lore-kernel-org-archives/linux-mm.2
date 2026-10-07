Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1140CCA5FED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C516B0095; Tue,  6 Oct 2026 22:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3AB6B0096; Tue,  6 Oct 2026 22:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6874B6B0098; Tue,  6 Oct 2026 22:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4666B0095
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 382B7A7639
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:29 +0000 (UTC)
X-FDA: 85294211058.03.64A385B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id BAB641C0003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Wa XcFB+";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791339267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0wKg5+CnFc66UiMVgZhWFbiztro7R5LMhQ/aoV5NIl4=;
	b=GM1ta6Y6mxg/2PLfoaUUUdMswbJbGcUFvMUkPG3+TccwZM3KaK0IoF7rM51JTaOGBRYQdh
	5U5OuIXuwhbK0oVw/XDcXUEM6OeWYcMYaBzDOFzeynKd2dFd/qSgv8w4I+iosWW8CQTL50
	X+RLSWRA81oV2M+u5ALQzPx5bL4iQMQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Wa XcFB+";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791339267;
	b=3CSVZwbVvIpjvZBIOFEucoZNQ5/4ooH4jnW6oR4nhAHTfLgoLNjZXJYYl+P7MBctHtSNXX
	qyGMYRS+J2GJmlh9NuvJd7ah+8qNNVXJSv61y12DIwYgNSJyhSX60hbzWwrfb5Vfy2dKBP
	QdU0e1sDiAaH6nCnO+8vWxV8TnzVBV0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=0wKg5+CnFc66UiMVgZhWFbiztro7R5LMhQ/aoV5NIl4=; b=Wa
	XcFB+fjj7yO+Bt2Kujy8WyZGnMJfSjlEDry/UaGKO6NAwf/yYqPxBsXK9PF2X0hB/3Qk4K8tKV+2b
	Py8tGGmMWjPIcndQecjrneE1hu6E2STthiZaFrz/B3jEuf3a0w1HDd8o5RS4xoRqQDHWV/xKUjr2i
	OLhIR/Q7MZgkTSH0DvxR1b3LkPH3hkPIHg/Bozr63bWDaD6tP7CXfiGN+prr02ElBg+V60L7oI/7I
	GZfPCUwE7KJnd47PAg5w30YPoiAxCeoXH4Vzhz8sBi3Zzl9tgZ8EihGWLBCdiGlPkBjKpMbfs5UAT
	CXvUar4nlOoKafAqBZezHV6fX33CUplg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEH9M-0000000B2cT-3kLi;
	Wed, 07 Oct 2026 02:12:56 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/page_alloc: keep non-movable pages out of movable pageblocks for THP
Date: Tue,  6 Oct 2026 22:12:45 -0400
Message-ID: <20261007021250.1665929-1-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zyiq3t5ps66emhd7n11b87smbja6x7df
X-Rspam-User: 
X-Rspamd-Queue-Id: BAB641C0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791339267-199406
X-HE-Meta: U2FsdGVkX18UPiC/OrbHr5IdHe/xrzYZ9zyOWhaMcRBicdnKUaxGHEXtwKP/5H8AxECCY9MGFZy7MVaqfwFnt59TpfcMHSxLSi1xxijDQrVBhdi3nIwW7XYY9JCMzuuiv2X1P+9opE2+wuIezWNwrKFSprkg3MBP1aHsyKJWLTADPQZWbsVXi+Rr9Sf1LXmXnXKWAkyojuTdDKBwKwI/sU2SzdTbEbshjfBa5qshW1W87zim7rjcb4az7skJ6YFnf/8a/dtRQ+X31xe9ptNTTAg5vDFu17sq41oRQbLYOyrFQ+L5J3BmUjgaRFNAJ3FcF7v3eeRHe87xm8IdCZxvZzCSaHMLlG/zjN24JJccJOEWPw2Q+33uPkLSB4RwcP/TS1Y+eK0CT4f755IlybBhQwZbhBWYBnEFvMK7H/gOZsLaM9FeWCaPGk8MZzUdL9A9SQCd6OXVjRQyU2VnzuuJ0ks26vL3AKlS4ClX9u7xLqqk+AD58WJ2V6y4dYLyig/YGr063N2t2UUFR6RvAZ6vhTVNxxldh1pw+Q2hqqflyDYB9KZDXik49zJGbO67BIESL1W+rReoRqzcDUwsw8zSlU/GCH0XMGyRDB27SfEb7AZ7sjEKvEnBqPqxSw8rmCZW05PAKbf3KoqmGQItK2ki1b22vsXYe6caRioI2ybd19oWkjupoQ9BO9Y9wrGm4LxjH25clBqsL4dm1KX9SuTszhC/0Z0YBWXQfWNsX8CwusNYyxx2J/nbj8DXQXcFrmoheBn0k1cqCldwSzdLHflrgt0PjevLTqmPbvro6lMDlDvVwjsBKQfAWkTRqYg27G+ChmLuVXyBSoEHO5NBHX9zKOIFRTO4R+AyY+0bgixYvZbP/TOQR4+b68bzeueNIxPNihr8fFmCtFtHSgCMuHQwCGd57a0G7HeKynNBsnQlYqwW4TvWaFDs/3JsnkGtgWFutV+SkYFAXGkfGB654op
 OBsXZygs
 pv4oSJLhhxBkuMu7BaDvosu5lT0WRUxuMKuzqjmVCDuhCXfYA/lOMrIPBwdgTBf2mj6jyIkmLtqP9X0QpFpD+lJcLxqmHkCsXY4wfStaB9f2U9n8WPPGccn/7LzUcM9pDlQGiZJp582Zu5ak1hWcoLEm39HHQUNDtPyLhMcQkYRDWpCiMogpIRhzVfkrQsltdMn9kWfKPJZvs38xDsHp1PqxIGxsY1VGjdLjDiENLQksBj+qj8npVElDeb8biMuXxRw5efU17AG14q/S1/z4FzYWL3SyiW2j7LTvLvmuvG7TQ7yidQpKsg2q22graF6EckcqZgIOq3B33T4BduqHMhohCWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Last week I posted the first prototype of the reworked gigablock
page allocation code, which uses the per-migrate_type free lists
in the zone as its fast path:

https://lore.kernel.org/lkml/20261004013657.03a63c4c@fangorn/

Zi Yan took a look, and pointed out that the first patches in
the series might help with THP allocation. Testing showed he
is right.

Having this code be useful by itself changes the gigablock
merge plan. It can now be done in stages:
1) Pageblock claiming fixes & improvements, which show a
   modest improvement in THP allocation. This is the only
   code in the fast path.
2) Page compaction, evacuation, and free list threshold changes,
   which can really help concentrate non-movable allocations in
   non-movable typed pageblocks, hopefully making compaction and
   THP allocation noticeably more reliable.
3) The actual gigablock targeting. This is also a slow path,
   like compaction and evacuation.

This first series addresses pageblock claiming and stealing
policies. Current page allocation policies cause the THP allocation
success rate to collapse under sustained non-movable demand.

A single non-movable page in a movable-type page block prevents
that page block from being used for a THP, but it does not
prevent kcompactd from spending time on that block.

Three paths mix unmovable pages into movable-typed blocks.
try_to_claim_block() converts a movable block for a non-movable
allocation only when half its pages are free or compatible.
__rmqueue_steal() takes pages without converting at all, and a
bulk batch that steals once never reaches the claim path again.

compaction_capture() hands a merged movable block to a
non-movable request with no type change.

Patches 1-2 are standalone accounting fixes: guard pages return
to the counts when their buddy merges, and a merged buddy's
pages move to the merged type in the free page accounting.

Patches 3-5 make the pageblock migrate type follow the content:
convert any movable block on a non-movable claim, skip movable
blocks on non-movable steals, and claim movable blocks fully taken
by non-movable compaction capture.

Pageblocks that straddle zones cannot safely change type,
since the allocator may have locked the "wrong" zone. Those
blocks are left alone.

The series is preventive: it keeps new placements to their own
type and stops polluting movable block. The next step, for
another series, will be to evacuate movable content from
pageblocks stolen by non-movable allocations, in order to
concentrate kernel allocations in fewer pageblocks.

Measured on 64GB 8-vCPU KVM guests, THP=always, defrag=always,
khugepaged collapse off, 8GB virtio swap. The guest boots into
a fragmented base: a 10GB mlocked block flood, 36GB of aged
anonymous memory, and background unmovable allocations.

Then 8 rounds of type-pressure buildup. Each round drains
high-order free memory with a large NOHUGEPAGE touch, adds 550
pagetable-heavy processes plus 200000 slab files as unmovable
demand, and ends with a fixed 2GB 8-thread THP probe that stays
mapped while success is measured. The bursts persist across
rounds while the drain shrinks by ~2.75GB each round, so each
round's demand faces less free memory.

Measured is the thp_fault_alloc success rate, across
4 runs of 8 rounds each.

                                   patched        base
rounds with <50% success            7/31         16/31
THP alloc success rate @r4       74% (47-98)  42% (25-67)
blocks with unmovable pages @r8     43-154     1674-2131

Two rounds died due to swap exhaustion, and are not counted.

Pageblocks with unmovable pages were counted by checking
/proc/kpageflags after each round. The total amount of
unmovable pages is similar with and without the series,
they just get packed into fewer pageblocks.

Converting taken blocks and refusing fallback steals packs
unmovable pages into converted blocks, leaving clean movable
victims for the scanners: a round-2 probe on the series
kernel compacts 690 of 697 attempts at 92.6% THP where the
base compacts 47 of 376 at 4.7%.

This series is broken out of the 1GB gigablock prototype work:

 include/linux/mmzone.h |  13 +++++
 mm/page_alloc.c        | 117 +++++++++++++++++++++++++++++++------------------
 2 files changed, 88 insertions(+), 42 deletions(-)

base-commit: 67f0943b394d9

