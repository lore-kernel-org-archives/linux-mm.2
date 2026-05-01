Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189FFCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AF246B0005; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2391A6B008A; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1279F6B008C; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01FAC6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 768A4A02B7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:15 +0000 (UTC)
X-FDA: 84720078870.08.EB12F12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 777BC120010
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyM05ewp;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669453;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6iIUVO17fFI54Oo6JoVvH3M832pGhQaZ0xlMmkADuc0=;
	b=QFJA60w33kAey5kVlTC/ESfavW+v2NWQJGTc2n98XgKwpwkfxVrC2jgYRiFPJxhqP2og0D
	YUVJ9xfhv0SuPYzCLlUFVbbroJwTHSAQQof5GBOfSEp+in0RE0LjSU9alptpkuyX0uQtnG
	ccS5PY4vTs1aCdTlo2C+ad7ip+zPAOQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyM05ewp;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669453; a=rsa-sha256;
	cv=none;
	b=N3/Mh/EoI+krPra0ms7iAMjhEDblItPpajxv7M9gxX5SnsoC7rAT/JeRWT+8lD16E0I/hz
	5EIcbrD+oG8K4X+DHEVxLURbx68poZei5F47LFpVQR3WmP+gesDb/W2oCQq87sFQK/lLGZ
	1VqUlhKeW1y3zgXc6Jirwctaf/0PV6c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5157F60123;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECFB6C2BCB4;
	Fri,  1 May 2026 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=DBOpIru7jqacweorBAeXDkuyacrHQhA4NDUgZl7zFQ0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=iyM05ewp4nZk2SjKWbuezpqzbgUYp6tl9YpgYp0OeLoekJEbOh8pYIGA+D6ijJ9TY
	 2UzN/kQqBm632dnOOAzpJFx4qEIfDgpgqViBjmBv5NcF5m7nkZ+Oqe5wNySZqVYxq8
	 Rv37oO5UxswDT4qZTPMk5cVRfQ3h1SdkYRuuyj+3wyAloDLAMS4pOGI3eWm85KU7h0
	 ljl9SeJ7TOk+eGTxcXQxYthx0UQ6aN44zDwKqxq8boZ4pbwUa+yCpFxQFZoCdTNcH1
	 CmgpXIN6/oeCFAantZmBhvurRr1GN1CtYIXbSSJRugZRv/y7JsyO1LVA1yLeQo17IG
	 VLgVypSp9WXlA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B14CD13DF;
	Fri,  1 May 2026 21:04:11 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC 00/32] mm/mglru: MGLRU-FG and refault distance support
Date: Sat, 02 May 2026 05:03:46 +0800
Message-Id: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEyMT3dz0nKJS3bR0XYukJAtTo9Q0CyODNCWg8oKi1LTMCrBR0UpBbs5
 KsRDB4tKkrNTkEpAhSrW1AJ2j1E5xAAAA
X-Change-ID: 20260424-mglru-fg-8bb852ef820f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=7590;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=DBOpIru7jqacweorBAeXDkuyacrHQhA4NDUgZl7zFQ0=;
 b=1KI9TPY28o+QlUdOb0aHnPYcmh5Khm9aqozsCx0JrNb1IBSBovc+nlEFzVo52Jle+W0+f5u8E
 V29tnRKWiYCCgFwOUtd2uQJvr2ZwYxL0wUy1u9+4JQFwQkKJznMKnat
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 777BC120010
X-Rspamd-Server: rspam06
X-Stat-Signature: pgtcprgan3zue8bn5eq4oo9w6iwbpmas
X-HE-Tag: 1777669453-746049
X-HE-Meta: U2FsdGVkX1+u6WkCO/eoIhnmyWcWTsaYnaOm1sKl2B5T5P1W46dNfuvDfocMQd6SHRZNV7xJCKwXRtFm9A0Sjjs6YGZthOoK+FnEdldfU69hdbb+tKfAIUjjbV6p/V7G62AZPpsbuw0L0I9/s0f6fVKKSxIMIfXeMQNkRp7qv+TIgq0123PHcqpbSeNWqrMrmsqJJKlQjSK+aLvQ1eE+DYtKv4cG1iffSaML5cu+eqz2mw2ckkXoFo73jzQ1jDNM59MjxVGW0/W7q6aGRMqyEZBo3XWAuyCuY7iCZx6vk1dfaesFqNC1A3yUj0ZtarLEDRY1dOjI7beePkKnFjloJBVfUv1wI7gRmuzDdrua6Vex+7bg+2b0gJj/ClZFqcTUvcFC0f78UYcpdc31gZTX7cr6YQ8DYK7EJwWgRSl+CzX2fNhHhILpEDpDgvYF496cCB2oXkC49Oici9SpTK/mM2+TAfmzFxFf2L5NmkklNyJzIaQyQ+Cx6vYdtNPd/Vgul8/mgS5ogtvYRy/qR6EJFzJI9s42JxSsBCkapWLLhzK65iSKOG4wx8g94M6xbJkgs+9j3hFH90pT61Td+8JOxbtGpzm+o0ZB46ZxouoJrRkpmw1FbSJGznDWYXvbmWgHW2732nLnuDw6HLfylHUlJS3uhZH7iU05UluUCwidAbRswwFg9VGNGofsOV579IOkbOaL1EffvbszjZHu9+BlejUTcuagBS/u2Z5rCAXCJY1l54P0cetZIjHP2mCZ6puz62Eosg14zVoHyLBro4aQk7grvj/Rt2oEpy8Pph8/CfXKA7XQ8S6JJiFvKyhLAzVIqqR0JWFptUYiphFbg27BmhRfyXGYlYUKMWPG4VwINNK2upQnN6ZVcuccHmv9H9ti1Mn/V2Szm7aX1oNQ6qlVb5JlbCy4LbMJ9KgtAhzRA963TB6+mOj1f4R2cogc80kVW06c9cRZqYFsggY9l+V
 s2Kev6Vd
 J8QGvI7B8e1IFi3eJX5y537SKKWWnySZkFCxLijJ63cOmQmcElHuDl0LNnPMm37j4j6gCPpslndGsDl4tUjgbRuLFn5diV9jSNrEosbfmGHIP0vVHUfdICQBbCk8429mKXzBNkWPuCfSMhtcNU9MpM4EuZT5NFdGQcyhMLi2C2+llytSsFmyJ+DEniq1l4J6sAdlFCIZ6Hu1em0mmNek7tlNedye4Dl/fZBelnjOxjJHMTbL2A1V7wpeVytka0KIxryJfJqdHluvTHezr1m+PwhCSYUX7MY4OJHiYLGBAOfyuvOnzpC987FYWpt1bq1P8sFH6RxnFEp46GDf3oRAJc1GIt8x81W9mgjcQeVbNYaSEr3zDMa/MGocRhUnoU8QXUAFmhZ8Lloo7IkKvFXmpiU1iKCIc/DqN5JQxyjR19hXa0DEOu8JbC3DQF3WYlCrw/tSYx2koUkkZtBQFyjNlUfID6xy8TUf5xZjeW8UTDvyXVeaKRMmGAUIFhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC following the idea proposed as LSFMMBPF topic [1] this
year for demonstrating the design and improvements, sending it out so it
can be discussed better before or after the event. It's stable and
performing well, but obviously, it's too long for review, so I plan to
send these out step by step if we are OK with the basic ideas here.
Worth noting that the design is still not finalized yet, the tier and
refault calculation can still be better adjusted, and with more
benchmarking and testing. This is rebased on top of the current
mm-unstable as it is supposed to work on top of another series which is
currently there [4].

With this series, I'm seeing an obviously performance gain for tests
like GET/SCAN with LevelDB (which is borrowed from Tal's paper [2])
and MongoDB with TPCC [3] or YCSB [4]:

GET/SCAN LevelDB [2]:
Classical LRU: throughput_avg: 993.64 Ops/s
MGLRU before:  throughput_avg: 951.12 Ops/s
MGLRU after:   throughput_avg: 1344.72 Ops/s (+41% faster)

MongoDB YCSB workloadb (MGLRU):
Before: 82127.65 ops/sec
After:  95933.99 ops/sec (+16.8%)

Build kernel test (MGLRU):
Before: refault_file: 259681   refault_anon: 3006202  real: 1m49.005s
After:  refault_file: 201472   refault_anon: 3048107  reaL: 1m49.050s

FIO with zipf:
Before: 73557.72 MB/s
After:  74553.44 MB/s

Also, mechanisms like PSI, smap, readahead, will all have better
accuracy since this series unified the flag usage between classical
LRU and MGLRU.

This also reduces MGLRU's max flag usage by one, and hopefully provides
a generic API for other components like DAMON to contribute to MGLRU's
hotness tracking.

Other tests like the MySQL are looking fine, no regression. Filesearch
test in [2] also shows some improvement, not comparable to cache_ext, since
this still need to rely on things like the refault distance to establish a
pattern before it takes any effect, but more generic.

This series basically composed of three parts:

1) Make the MGLRU be frequency guided and rework MGLRU's flag format
   to shrink the bit usage. The format rework and MGLRU-FG design is
   strongly bound togther with 2) below.

   The main patch implementing MGLRU-FG is:
   mm/mglru: frequency guided workingset promotion (MGLRU-FG)

2) Convert all workingset / referenced flag user to use the new generic
   LRU refs API introduced by above.

3) Refault distance support for MGLRU.

   Refault distance refactor and support starts with:
   mm/workingset: simplify and use a more intuitive model

Step 1) and 2) are working well. But the overhead from 3) is still having
slightly higher than expected overhead (dozens of more atomic operations
upon refault, and an extra rstat flush, which is just like classical LRU),
and not a fully optimized work, so I'm still looking into it.

More detailes are in the commit message.

It's recommaneded to test it seperately for these three parts. Sending as
a long whole series to avoid conflict and provide a complete view of the
ongoing project.

NOTE for an RFC quality series: several helpers like folio_mark_referenced
might need further improvement, currently the implementation may lead to
inaccurate hotness info, only in theory and doesn't seems a new issue, but
could be improved easily later.

And the page flag removal can be decoupled from the workingset series easily.

Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
Link: https://dl.acm.org/doi/10.1145/3731569.3764820 [2]
Link: https://lwn.net/Articles/945266/ [3]
Link: https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/ [4]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (32):
      mm/memcontrol: make lru_zone_size atomic and simplify sanity check
      mm/memcontrol: allow update of LRU statistic without holding LRU lock
      mm/mglru: wrap all access to folio flags with accessor
      mm/mglru: introduce and use helpers for updating lru_gen refs and gen
      mm/mglru: make generation page counters atomic
      mm/mglru: frequency guided workingset promotion (MGLRU-FG)
      mm/mglru: don't reset folios LRU refs count on protection by default
      mm: make folio lru referenced times count a generic API
      mm: replace folio_set_workingset with folio_mark_workingset
      mm: replace folio_test_workingset with folio_is_workingset
      mm/smap: report workingset folios as referenced
      mm/huge_memory: mark file folio as accessed more accurately on split
      mm/khugepaged: consider workingset folios as referenced
      mm: convert rest folio LRU referenced usages to new helpers
      mm/gup: use new helpers for marking folios as referenced
      mm: convert folio referenced flag usages to new bitwise identical helpers
      mm/shmem: mark folio as referenced use new helper
      mm/vmscan: convert to new bitwise identical helper
      mm/madvise: convert to new lru refs API and better support for MGLRU
      mm/damon: don't clear the lruref for MGLRU
      mm/swap: convert to new bitwise identical helper
      mm/workingset: simplify and use a more intuitive model
      mm/workingset: rename the nonresistence age counter
      mm/workingset: use a single atomic operation for read and age
      mm/workingset, lru_gen: simplify lru_gen recent
      mm/workingset: properly define the format of a folio shadow
      mm/workingset: move refault distance checking into a helper
      mm/workingset: split lruvec retrieving and flush into a helper
      mm/mglru: convert avg_total and avg_refaulted to atomic
      mm/mglru, workingset: apply refault-distance based re-activation
      mm: remove PG_workingset
      mm: remove PG_referenced

 fs/btrfs/compression.c                 |   3 +-
 fs/erofs/zdata.c                       |   3 +-
 fs/fuse/dev.c                          |   2 -
 fs/proc/page.c                         |   1 -
 fs/proc/task_mmu.c                     |  22 +-
 include/linux/memcontrol.h             |   9 +-
 include/linux/mm.h                     |   2 +-
 include/linux/mm_inline.h              | 257 ++++++++++---
 include/linux/mmzone.h                 | 113 ++++--
 include/linux/page-flags.h             |  13 +-
 include/linux/swap.h                   |   2 -
 include/trace/events/mmflags.h         |   2 -
 include/uapi/linux/kernel-page-flags.h |   1 -
 kernel/bounds.c                        |   2 +-
 mm/damon/paddr.c                       |   3 +-
 mm/filemap.c                           |  12 +-
 mm/gup.c                               |   6 +-
 mm/huge_memory.c                       |  12 +-
 mm/khugepaged.c                        |   6 +-
 mm/madvise.c                           |  37 +-
 mm/memcontrol.c                        |  22 +-
 mm/migrate.c                           |   4 -
 mm/page_io.c                           |   3 +-
 mm/readahead.c                         |   8 +-
 mm/shmem.c                             |   2 +-
 mm/slub.c                              |   2 +-
 mm/swap.c                              | 109 ++++--
 mm/vmscan.c                            | 189 +++++-----
 mm/workingset.c                        | 666 ++++++++++++++++++---------------
 tools/mm/page-types.c                  |   1 -
 30 files changed, 916 insertions(+), 598 deletions(-)
---
base-commit: 2ed06bf65cef2e7b763ce59a9fc2e4a42ecfa1ce
change-id: 20260424-mglru-fg-8bb852ef820f

Best regards,
--  
Kairui Song <kasong@tencent.com>



