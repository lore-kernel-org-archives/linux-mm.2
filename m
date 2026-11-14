Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C593C606A894
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=O5EbDOSV
Received: by kanga.kvack.org (Postfix)
	id B39726B05B0; Sat, 14 Nov 2026 02:10:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCB96B05B1; Sat, 14 Nov 2026 02:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EF36B05B2; Sat, 14 Nov 2026 02:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67EE76B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE2A8160110
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:06 +0000 (UTC)
X-FDA: 85432850412.27.503BFAC
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17884140009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O5EbDOSV;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640205;
	b=dp/X14llQRZDBgiohhYGWKBwla0BoruwFpXnVtGUzeFAdfXhRDLOUqPMbnExc7WWOAG0M0
	tSSPLvYbXjI9/dgaxeskHfzUElHmQ4R8HhtqlOXtMcPu6R5eKhxYBkKhTtTS/LjDHeahJ4
	B8uXDChfCOOAWXg02amcYahkIppiBjk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=O5EbDOSV;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oRfBKleHhU3BUp7ltu8uNKVynP2g/0Xp3jgnuf+J/Eo=;
	b=hKKdpoPuE+PUWtTrANYirE42OOFZN1FXOtgb2tqzfbllJSBddObi4OYstDsuWef8GAbBG6
	+i5zVFUXeiI8oRjZWIgjD69uBYGPFb3l8otLOz6n+WF/fMDVElSngSpUq20QKewIBeWScz
	NB91AWz7brzSRFSSetL6LbLOTxNF3gs=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9495c633eb5so58036985a.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640204; x=1795245004; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oRfBKleHhU3BUp7ltu8uNKVynP2g/0Xp3jgnuf+J/Eo=;
        b=O5EbDOSVLl1f6B+0VnuSbghYPE1vMK7QP9xpkhAPp9SQI1GqrTR6Cgwe9uqrXCAwMf
         CFAWdbazInQcjGxEJyGXu2Lgarj7tEt9tuJG1ksXwU04FhepP6oyFC6l4WwssbEeb4qU
         NGCe84bKTB5D6xI0IeM9T9y96eDhlz2xiWBowTt7sViamcG/f4/pEdFZfystgQh+hl5o
         Hh4XcXlqRfsWlMnk7QNDkMo8GBp4jyc+tvc8hzpqIhODYrF2XHAmfcm12nxQoAcYycDV
         EYlWTPCKyDBeqTN9d1eWppoj0+bHG3QkIZ5HKZfjhYcxRpRX5S87pu89YTCYNGqtxs/J
         YbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640204; x=1795245004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oRfBKleHhU3BUp7ltu8uNKVynP2g/0Xp3jgnuf+J/Eo=;
        b=Mg6O9qmNzflp4rgDBqyuGtjDmPvIj+CxQHi+wUoaE14vjPzKwJl41qrTIiAuvi+fTX
         f9k2GkHwaOOtFurYZoxLG6xanh+Eg6qWAwx8YKFHybH/wKlPJo6hz2YLiUx49ioIgPHp
         HVI1/zJg3W5Dv/raq81NS6EJBiqS1f+VtyjKCuOBU+1f+OI2f1U955ut3UlXJEzFQwFs
         mDa9AYvlFdSDg/cMios7ZVM5W0ccfuqTAMSu4tpPfIv+V+PhLh/8rmirBa0wnMwN2I02
         FazsNjDqtDUyhiQVvdCk4g2sNfjeqFHIfE7vTDlYxWFiP85od1iQ/jaDWD1nVKijLJ8X
         52Zw==
X-Gm-Message-State: APuU4Z8TQsH8DTUUSeMBmDlDoozk/E0Ocpn5FemEiFM411WRaHAGhseI
	U8epvZq0XGnHqk425d+v8DfekeJcODAz0L3a2oOljdRNMir6aANHRp7IWB6EcfkTqAjwI/LpUoZ
	et/gN
X-Gm-Gg: AYBFou1GFEapPRIkodauZhRaYD+5B4FHAi6SGiXUEawWfd7I3s56E5HlvEk+H5Fvzvk
	J8SrrOp38Ds1Za8a6GtSpIWIx9ZdMu6C+4JvFqeNFBA2PigSBim2uuJqCQhKPwDV2iSZgEqRWDr
	Aw+VUIYkl30yxMmHMPqVa5gfgZYKmqHwPaagfOYxxbROnnpWH/37bYU1lHG5kUAHLf2Cfa9oxhv
	Im25+E2agLRGUABQF3O5xe0ot466JSVIGzfkef30Wbre0qi6k9SxFAytnMQ1MYvwXOEHNlAPO8o
	j9rO/V7RIhMk8K8QotgX8ZTBQW6+Ghoig/7eGR4lujaWJZHIsrw2/D5n7hctsZYElTxwWLym350
	7/O11nte9Qkav/1iaEzU3bzkr815zbOt+26r/fpz2v+HHlRY9UHdeY8ibyg+NxRGy4MNzjXDPQW
	i1xU4ouguCvAJTFIPqoe6n3Ct0V1ejCnFeulIg4ODhDmoyrrVuy89t4Dmcv9cqwGRra0DR4zP3y
	yOTIg080/i1rtzDDBFEp2dFjJjkBJZqFKWBE84RTxH8LTlo3NrwjI2iilYODmfPFSv1V1YoooQu
	alC28/GErzjgAsHMukDGzqGGNrqL6sjjB/ZN3bPNY7NtwUqTgKzMKSyiUpeJ89kSyPYIOPS1xXH
	TSFuZWARyUpA8c0KI
X-Received: by 2002:a05:620a:8398:b0:93c:ba88:cd65 with SMTP id af79cd13be357-9494b9e13damr803141185a.7.1794640204107;
        Fri, 13 Nov 2026 23:10:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:03 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 00/22] mm: introduce N_MEMORY_COMMON
Date: Sat, 14 Nov 2026 02:09:37 -0500
Message-ID: <20261114070959.3490008-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xotwqh9gweorku4h6pqrkkjg1935fw9y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17884140009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794640204-719745
X-HE-Meta: U2FsdGVkX1+9LnWPtUE6MSiIAqUs8atPaSkZ3dIJbPx9pPGnPw7YkrgCyY13PhbxjQGwYr7tjvUYclyI/z32k/R9NCqaPTouVwHAMeS41kKZPSoDdx6dvqlDutGy59llq1m2Ewx8O1baYSUuzWBmlma4tb03eZApttKgdgYJO6SOnn0GGJdqqhHUmqQitYRILKWDAY1evxb5M4/ruOPkAfjoNpJqyJDXXtg+w8tqeaKSYXF/RFPWqhaNyvWgaYVg2uM8rGdLnQ/s/1Slkqhr5VWB0le+paueOxH1wpRLWw2aqUKmuktkdNrEFOFHn1hS1c7dP+7CfxclcasRaFzvSkl0U1M3NrOi7qzCHfK9K52PSRq71NLrFP+rQumiU5ccGH5F6nASq9Vb5mqdIc603KPOpitjRK/QN5dvyI7KCgiQGZKHLw4MUrNhrqJqpqy+929er1ZYzDXQ25bMKqUyMBr679Hzj1R7UKOhRNMwRGGBnO3kHgHkVoamop32adtuaF8xIOKlB5zSUf65KaLWd0SvxKG/PdKl1Dkq9KKn29X91C6DaRB3upnj9VmtzwIb2j+EvJS5U44yj+XSJAIK0ak/8pVaDQnXaC+/bjRn2elf6bnGCy09bdR+3MzjgWicg6cWruayMNisPJLn5SBFNa9Bc2BMzfJ9pOXlklCRI3kpQQNrVCnUGH/Em05tV1te1DW65NPcB+Ur1QoEhQMnOkVEss6R44tmdipdNlfBpjnGLeWkfOtpQ3G8M4aDptSxZHfidD43NTyxHAa6PnxxAUBNMpW+ZnBmDUNL3WC5kN0hfgo0aZNS9e0zCV/O5CkuvQtHvJsACifXIHFYuww+Z6scxy+POiVH+3mOpiDTBvgApT+9/GCfPNLRdqWg0hgL85h+cPAQROFvDCShQoabJn0SJK2G3V4P4kHIJ+lIW4hVHV6d0F5IQkvsBqioId0hXYv89N2AhXripwMIGG2
 zPVejRcp
 eGlejwU6S283rTyfgG7fe3Rpof40vGXGjnuHqfslMHRJhsHoaSx6No8B0UZcn2Vk7x56CE6W6v0csQCRY2C7BOiPDQO8IGIgUZYhCeSblBqR7efgRaJjjjv4obh7g+6SF/CXsvSMAW1c4yr/TYnC1cMeFNfUSbIRK8UY+3z1SwAzSQoDjnLL+Ld9by2OBeBVzE/iptt2neGhKehNYNbb9ixv2FL5wHCEsqkS3+mmALK96wa2WGmEbj+yrv4JTXIRQsU6NdovI2Gsrxb6uFrPAWfhec/FtRB5sqDtYpQB92ib6kA2J+ouXtIKsfJ7ffH5TYtqlmmHuw22P+wLukIHCZ4KCted2ymN2JWCv9V/yuzfPFhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is phase 1 of the Private NUMA node series.

I will send v6 "Private Memory NUMA nodes" (phases 2 and 3) separately
next week for further discussion - but I pulled this out ahead to make
the core filtering mechanism easier to review.

The series is now broken up like so:

Phase 1: Introduce N_MEMORY_COMMON to define "general purpose" (common)
         memory as a concept separate from a node having memory as a
         topological feature (N_MEMORY).

         This phase is a no-op for existing systems, but creates the
         baseline for ensuring private node memory is default opted-out
         of being touched by MM (much like ZONE_DEVICE).


Phase 2: Introduce N_MEMORY_PRIVATE to define memory not part of the
         general purpose pool. With this we can introduce a minimum set
         of KUnit tests for the page allocator to demonstrate the
         isolation mechanism.

         At this point it will be possible for a driver to re-use the
         buddy allocator to make uniform order-N allocations.


Phase 3: Introduce feature bits (COMPACTION, RECLAIM, MEMPOLICY) which
         is the minimum viable set to allow userland to manage a private
         memory node via mbind() and migrate_pages().  

         This enables management of HBM and Coherent GPU memory via
         userland tools (numactl, cpuset) while protecting them from
         incidental allocation (no fallbacks, only explicit placement).

         The memory could even be hotplugged in ZONE_NORMAL and pinned.

Actual cover letter for this portion
====================================

N_MEMORY has two meanings today:
  1) this node has memory
  2) ordinary allocations and MM services can use this node's memory

The two are the same today. They stop being the same once a NUMA node
with memory isn't part of the general allocation pool.

This series adds N_MEMORY_COMMON for the second meaning and converts
the relevant N_MEMORY users accordingly. N_MEMORY continues reporting
memory topology - and some users (cpusets) still utilize it.

At the end of this series, N_MEMORY == N_MEMORY_COMMON, so the series
changes no behavior for existing systems. A later series will add memory
outside N_MEMORY_COMMON without having to audit every N_MEMORY user again.

Rather than add new hooks for page-table and pfn walkers, we consolidate
existing ZONE_DEVICE checks (page/folio_is_zone_device()) into a general
`page/folio_is_common_memory()` check.

The series is laid out as:

  1-3   helper functions to check node states and a folio's
        membership to a common memory node.  N_MEMORY_COMMON itself, and
        the `has_common_memory` sysfs ABI.
  4     zonelists: the fallback lists hold common nodes, and a node's
        __GFP_THISNODE list is built only for a common node
  5-21  N_MEMORY->N_MEMORY_COMMON and zone_device -> common_memory
        conversions. One component per patch.
  22    removal of first_memory_node/next_memory_node, which no longer
        have users after this series.

Each conversion restricts or adjusts:
  - an MM service (reclaim, compaction, KSM, collapse, etc)
  - an allocation target to common memory
  - accounting meant for ordinary allocations from common memory only

has_common_memory lists the same nodes as has_memory until memory
outside N_MEMORY_COMMON exists. It is added now so that userspace, such
as libnuma, can start choosing allocation targets from it, and so that
the meaning is fixed before anything makes the two lists differ.

first/next_memory_node() is replaced by first/next_node_state().

Gregory Price (Meta) (22):
  mm: add node-state-filtered zone and node iterators
  mm: publish and clear node memory states via helpers
  mm: introduce the common-memory node state
  mm/page_alloc: build zonelists from common memory
  mm/mempolicy: keep interleave and tmpfs mount policies on common memory
  mm: base hash distribution on common memory nodes
  mm/memory_hotplug: migrate offlined pages to common memory
  mm/memory-tiers: restrict demotion topology to common memory
  mm/ksm: restrict merging to common memory
  mm/khugepaged: restrict collapse to common memory
  mm/mempolicy: don't NUMA-hint folios outside common memory
  mm/damon: restrict DAMON-native folio operations to common memory
  mm/hugetlb: restrict pool growth to common memory
  mm/page_alloc: count common memory nodes for kswapd recovery
  mm/oom_kill: compare OOM constraints against common memory
  tty/sysrq: use common memory for the manual OOM zonelist
  mm/vmscan: restrict reclaim to common memory
  mm/compaction: restrict compaction to common memory
  mm/migrate: restrict move_pages() destinations to common memory
  PM: hibernate: size the image from common memory
  mm/khugepaged: base the recommended min_free_kbytes on common memory
  nodemask: remove the now-unused first_memory_node/next_memory_node

 Documentation/ABI/stable/sysfs-devices-node | 16 +++++++
 Documentation/mm/physical_memory.rst        |  8 +++-
 drivers/base/node.c                         |  2 +
 drivers/tty/sysrq.c                         |  3 +-
 include/linux/mmzone.h                      | 46 +++++++++++++++++++++
 include/linux/nodemask.h                    | 38 +++++++++++++----
 kernel/power/snapshot.c                     |  7 +++-
 mm/compaction.c                             | 14 +++----
 mm/damon/ops-common.c                       |  7 ++--
 mm/damon/vaddr.c                            |  2 +-
 mm/hugetlb.c                                | 44 +++++++++-----------
 mm/internal.h                               | 18 ++++++++
 mm/khugepaged.c                             | 12 ++++--
 mm/ksm.c                                    |  8 ++--
 mm/memory-tiers.c                           | 23 ++++++-----
 mm/memory_hotplug.c                         | 25 ++++++-----
 mm/mempolicy.c                              | 30 +++++++-------
 mm/migrate.c                                |  2 +-
 mm/mm_init.c                                | 16 ++++---
 mm/oom_kill.c                               |  7 ++--
 mm/page_alloc.c                             | 43 +++++++++++++------
 mm/vmscan.c                                 | 26 ++++++------
 22 files changed, 266 insertions(+), 131 deletions(-)

-- 
2.53.1-Meta


