Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13B4606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=fDUG1u4C
Received: by kanga.kvack.org (Postfix)
	id 897DE6B0197; Tue, 20 Oct 2026 22:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EA86B05AA; Tue, 20 Oct 2026 22:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DF96B05AC; Tue, 20 Oct 2026 22:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0A76B0197
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C398C120376
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:46 +0000 (UTC)
X-FDA: 85345077972.24.E4969D8
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16F8EC0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fDUG1u4C;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IJC2MsJ0jpysriv3T3ncr7oRZBUiitKdqEmiCZfBP3c=;
	b=AloWoEUdD1UDRXxKjUfCx5nNuLElBjdJMV0R6zfPa3jwPT/9GR5qWQM+VjYfDVcqFccP1C
	aPrGoeG+H8LwL4YGWGSBzK2kA8NPGwjzkIVMjHmP53y/qvU4ifEGMsnqsvokefOj+Wj5yr
	HUO6TAQWuV/+z/4O8Ew7+UQrPVKtrNs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fDUG1u4C;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550385;
	b=GKbOd7tMaCYccj7LA2XR9s7t/TBkfwu0KYaAoU5H7zlF70nq7oEe8itnEhzxSzRSa3W/dV
	zGJrjIxfedL5LBs3y60Ubj57wAHCtcTLPptM3U498quJokTrBXT3Lvy36+nsKoNSa0zJa4
	LK0uWOTS1ytAjdBRVIW7n/mtap+QiTU=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91b8306b9f8so4261776d6.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550384; x=1793155184; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IJC2MsJ0jpysriv3T3ncr7oRZBUiitKdqEmiCZfBP3c=;
        b=fDUG1u4CThz52JmvQobGasDJZlo4zidheJuo9duui7Jpupj1IFEs3YW03J+TcFipyj
         T7pm1fJqqsouKoO1frfYTVmhJ3IZM9Txo9yEC1UCX3mCo8U3b9tJW1U3BE4cbxsquzBs
         Gxu0+/7Z0Ro/Clz/RS4mUkUcawpnPawhvDr8Wp5MbemsoKIrYq8leqoCoJ+sjiETt/pr
         aUMkK7FuprTJB3asdVq1eHe0U9B+E2DqaUF+PPXiRDP6Hhi2cDlBVaYmWjvi2mfZb+de
         MB6NI1JeCAcMBsACYZT8yPAApSMgIuc66S1h7PSa5hwe4jxXvLuBlhS+M5JrNkthIbU/
         7Ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550384; x=1793155184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IJC2MsJ0jpysriv3T3ncr7oRZBUiitKdqEmiCZfBP3c=;
        b=zuiepCocVJAiBANVQhCibi3iRUdyQ1ipCqs4HqNOB7qO5bFHb1a+g4v6LxqdvJHmRw
         06+EFmiPIHiSxt05q4u3pYVUYKgCW70O142yqJfeMKyUUnEEBvmC8vq4Pd3oTy31szM5
         kEanhRtlqbnhEx1nUJ8+TsH+KjrD6pKTWrecSGRvXXv9Fq2HpBwck3CtH63/Np46r78w
         1oIoNhDISeyfmZytq7S6cdAwRm1rqQElYnX1ZfRl+VYiQa8kL88XVdJdtx/aU+ELM/uL
         kUXOfA+lmMGNKbSKP4DpM9zslVvzlLQvhL55SlIly3uBg7EDzqzpKFOw4d2wGkrIkTla
         T9ew==
X-Gm-Message-State: AFq9FYJtLa7EEkj/Jw48n14AOBKdDwM2r//tC7Eec3GOvh3vllgpDCo5
	RPyd1s9xxP3F0OJqfb7dcZfShqdbNj7LhE3XAnbTu+qXVochq7OdHDRD6XU2E6ZICzLq4glgw0C
	Ls9e+
X-Gm-Gg: AYBFou3PFflhJsOWc4+tlBNxjcRG2xRhYjMZKchFknWcc5EVfRmFbpxjnTG1KntkSYu
	ONLg0HYdnXNETpUPog56oC7WliOfKwv9dHwCvqmGQ20q/u2lzoY3Pyodayb6Uq0rwOgtvcCy6wQ
	abc3OD46+FD4m/k9nDvboGCMLr/P3dBmb7NJ1MoYjc8CwLIw0GQG92QxOR66LDZa2cpmzHo/Fhr
	fNBnqRbhnQDCONiEqOItuO66o41AmQ6xwf4iG6k/VjPSZOsTq9JxvxZOn66Ugf4cswjT4FJz/ub
	j9rvzC9nFRxd9EtiD5JV8nS6dB6JSrDvOQV7fg633epWUT0/lsiWW0ZqYKEtr7vSli5EAt7ozfy
	GjtAik+PsWklf+p1uFvY8SMALg3jOjY37HXgirC2QGYz2TVeF3A/gIKkJ1KbWKj4RRtemZ9MrtG
	fMeLR/isiANkUbCkcfdeEKI3KsgOnk/a1hY6RCP6gC8TStIuZTDtyxv93TA1OUA/mDg+/tdJ7la
	S4OHMTmmudRc6TAZlqkheIAfSEwlPr2nubjTWk/T3j9OGT2UxGh2oOKgeHvJffMkrjsIiqycnlK
	x3R05+wNWLIjj5GqdQP/QD3yuwl8/Nlm5jrkkfkMMA==
X-Received: by 2002:a05:6214:3bc5:b0:91b:8059:5037 with SMTP id 6a1803df08f44-91c12ee3a7dmr14525426d6.32.1792550384097;
        Tue, 20 Oct 2026 19:39:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:43 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com
Subject: [PATCH v3 0/8] mm: fix allocator races with memory hotplug
Date: Tue, 20 Oct 2026 22:39:32 -0400
Message-ID: <20261021023940.1940971-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16F8EC0002
X-Stat-Signature: jp6yker1e85efc1a7zbgfdsq5pifd9uh
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792550384-903518
X-HE-Meta: U2FsdGVkX18XnBdoRlbne928MjYz3pe63qPjEkanZDmDkHUp90y6FOS3TvwogpLCa7YExE2KMYSXx8gtrpBiys+kMr43y/tYIZ2ds+3OjeocNY6IRLCdw7Wz9yXbP16MDVwrEmu/Ya0Epsr3VkIvAbqQHsoYobwprY/39w/kfjBQQ7TME4c8dAksS8jxORooYHgBFGQVBpk2ICztXka92bIbgx4dFHCFGybDUeWx/koPGNiJJ9QD8EVQMPRe0Pttd9YyI6KtLLKFAiuOfnW7I7tXJHPRQNtjcJ3uLaJrlP6ar4s/RHwdijPT1lEgewvvFEajl87b4eIJXt33Jkhv3+wVIT/ETlkkm6HfqS/rcahTawJ0VnWOWh2Pq0U1LqVhnI1wPbcRUzQybQ2unyOzMzcWkUSC+C2U5GLSlcD7jBONsONTXi8f+raKQuU6ym82CLYA/H0zDjQ1jQXb4ENbK8wr5ys2gx8Q07J5uFW+8KtFrOLapjAOQQpd2+y7FS3hztN0UBQrdh8xp7hBOz3V6coc4601qXjebqown1M0JcJ6wtLKG9pb4WkMgOZ87PEnF2O4IMYnRojMY63i/p/KVJKqSfzlhX0PpZzm16ibtYX3DwhNqnz+cq6Zs8K8mC4N5W0z2wIY306phaNcb5HqFvrZcxttMSBlDZfU0ddx4+muDmQnO79e+0Ecw4Ya1Y33X7caQxmbN6O/7IHjq3VUEWnghOsgLcDa/nd0PGGR+8PZmcwwv19GtRy6G14vDkTVO/Ei2qPNYgN6N3Gn4Db7O/3zy+dwnGzdlQQL0HxJ/xgy6riO/If95Z+//AerBE0RV2v5CK/SDHhWGuJDvp+ninQKrgTsU6crkvhYTr7T/I+AAJQfYF7jjrZkJzEBXgepue0Bl2kb645G9VFfKGf+HzicjPO/P1s7K7JKZz+NSD7ooPDkbjM0y0d/r2ZUBKSMvwtNcf7452vzoCQkvEN
 vreca9BX
 pnWv7sloAnsm2NonApO3ybqCjhqByttLAK2NFxmx2I73x9ykCY+EqNpO41BCkj/D6CMmmOrOTZ1ATP6TeViRru06wM47pTmOGDRN0aE+z90DRf9+kr1/2poChe3rl4H599Zm/1mzQkV1P+RZYqK45ik8El2MA4dCgCvVtfVVAepTEd8HRD5B3u/VuspBdM6YR5PRbsdpV90PUcxMnZQLrIUiDvICvd1267Kjax5rtZtD/ZKuN/1hqOpv/e2Z6SY1G9gMoevwDWsbg8W0WBUzCJ04nASNctsFhKFWnhRZnkLf12rjwg93i0aWqNWCd/JNOPOUwtCmmKW4ZO7Xo91TtE3S0NFu3O/WsKD7EZG6Lq/RaN3rZCyp6oM29i8WejDlIL6jVcQOQL3PE7A42SXCK2LQ3OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Eight fixes for allocator paths that can act on state another CPU is
updating: zonelists rebuilt by memory hotplug, and the pagesets of a
zone that offlining empties.

I've packaged these together because they're all related to hotplug.

*** Backport note - Patches 5-7 build on patch 1: without it, their
    retry is compiled out when CONFIG_MEMORY_HOTREMOVE=n.

Most of these race conditions stem from zonelists being re-ordered
in-place at runtime during hotplug.  The result is a mixture of failed
allocations, NULL dereferences, incorrect placement (GFP_KERNEL in
ZONE_MOVABLE), node misplacement, or incorrectly allowing hugetlb /
contig allocations on a node/zone otherwise not eligible.

Most of these are incredibly narrow race conditions, but since the most
likely impacted machines are VMs with memory hotplug, the narrow
condition can more easily occur when a vCPU takes a long interrupt / VM
exit of some kind.  I've made all of these race conditions
deterministics with a kprobe reproduction module described below.

Reproducers
===========

All eight races were reproduced on unmodified source in a QEMU guest
with three NUMA nodes:
   node 0: 3G, CPUs 0-1
   node 1: 1G ZONE_NORMAL, CPU 2
   node 2: 1G ZONE_NORMAL, CPU 3

And a 512M pc-dimm cold-plugged on node 1, left offline at boot
(CONFIG_ACPI_HOTPLUG_MEMORY=y).

Patch 1 needs CONFIG_MEMORY_HOTREMOVE=n to show the failure
Patch 3 needs mm/mmzone.o built with -fno-inline -fno-ipa-sra,
        without which the two reads are merged.
Patch 4 needs the reclaim_retry_zone tracepoint enabled.
Patch 7's hugetlb case needs a 64G guest (node 1: 4G) so that one
        memory block is 1G, with a 2G pc-dimm on node 1.

The windows are a few instructions wide, so I used a test module to
widen them with kprobes that stall one CPU inside the window. This
emulates an interrupt or vCPU preemption.  The vCPU preemption is the
more likely event to cause this at large scale with memory hotplug.

Patch 1 (zonelist):

  Online node 1's first memory block as ZONE_MOVABLE, which rebuilds
  node 1's zonelists.

  Stall the rebuild after it writes ZONE_MOVABLE into the first entry
  but before it writes ZONE_NORMAL into the second.

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1.

  Before: the allocation fails, 3/3 runs.
  After:  the allocation waits for the rebuild and succeeds, 3/3 runs.

Patch 2 (preferred zone):

  Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
  [MOVABLE, NORMAL].

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1,
  whose preferred slot is NORMAL, and stall it after it loads the zone.

  Offline the block, which rebuilds the list as [NORMAL] and moves the
  terminator into the preferred slot.

  Before: NULL dereference in get_page_from_freelist(), 3/3 runs.
  After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.

Patch 3 (slot reread):

  Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
  [MOVABLE, NORMAL].

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1
  with nodemask {1}, and stall it after __next_zones_zonelist() tests
  the NORMAL slot for NULL but before it reads the slot again.

  Offline the block, which rebuilds the list as [NORMAL] and moves the
  terminator into that slot.

  Before: NULL dereference in zone_to_nid(), 3/3 runs.
  After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.

Patch 4 (tracepoint):

  Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
  [MOVABLE, NORMAL], and enable the reclaim_retry_zone tracepoint.

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1, with
  its get_page_from_freelist() calls failed so that the slowpath reaches
  should_reclaim_retry(), and stall it in zone_reclaimable_pages() for
  node 1's NORMAL zone.

  Offline the block, which rebuilds the list as [NORMAL] and moves the
  terminator into that slot.

  Before: NULL dereference in the tracepoint, 3/3 runs. With the
          tracepoint disabled, no oops (1 run).
  After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.

Patch 5 (zonelist slots):

  On one CPU, allocate GFP_KERNEL with a nodemask, and stall it after
  the iterator approves its first zonelist slot but before the
  allocator loads the zone from that slot.

  Online node 1's first memory block as ZONE_MOVABLE, which inserts
  ZONE_MOVABLE at the front of node 1's zonelists.

  This was run for single-page and bulk allocations, and for a
  single-page allocation whose fast path is made to fail so that the
  slowpath's walk races.

  Before: nodemask {1} gets a node 1 ZONE_MOVABLE page and nodemask
          {2} a node 1 ZONE_NORMAL page, 18/18 runs.
  After:  nodemask {1} gets node 1 ZONE_NORMAL and nodemask {2} gets
          node 2 ZONE_NORMAL, 18/18 runs.

  The check adds 5 instructions to an order-0 allocation on x86,
  counted with a hardware counter on a non-debug build.

Patch 6 (hugetlb):

  Reserve hugetlb pages on every node. On CPU 1, fault a hugetlb page
  bound to node 2 with mbind(); the pool walk uses node 0's zonelist,
  where node 2 follows node 1. Stall the walk after it approves
  node 2's slot.

  Online node 1's first memory block as ZONE_MOVABLE, which shifts
  node 1's ZONE_NORMAL into that slot.

  Before: the page comes from node 1, 3/3 runs.
  After:  the page comes from node 2, 3/3 runs.

Patch 7 (alloc_contig):

  Write 1 to node 1's 1G nr_hugepages, and stall the gigantic page's
  zonelist walk after it approves node 1's ZONE_NORMAL slot.

  Online node 1's first memory block as ZONE_MOVABLE, which inserts
  ZONE_MOVABLE into that slot.

  Before: the 1G page is allocated from ZONE_MOVABLE, 3/3 runs.
  After:  the 1G page is allocated from ZONE_NORMAL, 3/3 runs.

  Calling alloc_contig_pages() directly with GFP_KERNEL in the first
  guest, as in patch 5, nodemask {1} gets a ZONE_MOVABLE range and
  nodemask {2} a node 1 range before, 3/3 runs each, and neither after.

Patch 8 (pagesets):

  Online node 1's block as ZONE_MOVABLE, then offline it.

  Stall the offline before the zone empties, and stall the vmstat
  worker on another CPU (kicked through /proc/sys/vm/stat_refresh) in
  decay_pcp_high() for that zone. Let the offline free the pagesets,
  reallocate the freed percpu area with a known value, then release
  the worker.

  Before: decay_pcp_high() runs on the freed pageset, 6/6 runs. In
          1/6 the area was reallocated before the worker resumed, and
          decay_pcp_high() rewrote the new object.
  After:  the pageset is not freed, 3/3 runs.

All eight reproducers also pass on the series tip, 3/3 runs each.

Changes in v3
=============
- Replaced v2 patch 2 (zonelist_zone_valid() recheck) with patch 5,
  which checks zonelist_update_seq whenever an allocation succeeds
  (Vlastimil). A raced attempt's page is discarded, so a stale preferred
  zone can no longer affect the result (Sashiko).
- Moved the NULL dereference fixes ahead of patch 5.
- Added patches 6 and 7 for the hugetlb pool walk and
  alloc_contig_pages(), which have the same slot shift.
- Added patch 4 for the reclaim_retry_zone tracepoint's re-read.
- Fixes: tags on patches 2-6 now name the stop_machine
  removal that made rebuilds run concurrently with zonelist walks.

Link: https://lore.kernel.org/linux-mm/20261014222456.2318284-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261019172346.3344005-1-gourry@gourry.net/

Gregory Price (Meta) (8):
  mm/page_alloc: detect zonelist rebuilds from memory hot-add
  mm/page_alloc: snapshot the preferred zone against shrink rebuilds
  mm/mmzone: read each zoneref slot once when filtering by nodemask
  mm/page_alloc: pass the zone, not the zoneref, to reclaim_retry_zone
  mm/page_alloc: retry allocations that raced with a zonelist rebuild
  mm/hugetlb: retry the pool walk when the zonelist is rebuilt
  mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
  mm/page_alloc: keep a zone's pagesets when it goes empty

 include/trace/events/oom.h |   8 +--
 mm/hugetlb.c               |  13 +++--
 mm/mmzone.c                |  11 ++--
 mm/page_alloc.c            | 106 +++++++++++++++++++++++++++++--------
 mm/page_alloc.h            |   3 ++
 5 files changed, 107 insertions(+), 34 deletions(-)

-- 
2.53.0-Meta


