Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95ECDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049456B00A6; Tue, 30 Jun 2026 21:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C356B00A8; Tue, 30 Jun 2026 21:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51916B00A9; Tue, 30 Jun 2026 21:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFB6A6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:22:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B04E1C5C2F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:22:54 +0000 (UTC)
X-FDA: 84938458668.09.8FF7E1F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id CA2E5C0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:22:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QirvxEdA;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782868972;
	b=WVweTmsBrGqzCjsiLZ5oqwcX1nd5+fAcxQito1+G7DsMPh8kRpVZNXgubE/ecc3hsPksWJ
	6eYUwb0FfokXZf9wL9+BdVE8KdbQf3s8qxhpehtKk1dOTDNVvJJhv5omy4M6QwYiJ8J1lR
	lmASCtu3w6f6m+n1ZqY+dCJOUa+Kn7k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782868972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nXEEcNJTN7FnoR0xBwUMHXMV9u8zlDjses4zEMqvZzg=;
	b=tkCWptqNW3jNlzy6DelgkWEPtawa/VrV8diJQeJhC7P2u5DjArwBYFzNRKSUcjH6PRTzE6
	R4p3aU+CxIv2bf3Go+TCfgAuAXeTtjP/JTcoEIE/6Efj4tMRCJ2aTUiSvX4v9drFCy6hC/
	yRdTq14IIsmS7usD4QVuvDb3BC4mDgE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QirvxEdA;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782868969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nXEEcNJTN7FnoR0xBwUMHXMV9u8zlDjses4zEMqvZzg=;
	b=QirvxEdAvcKJ+K2HLjD+xxB78qJvjmSl+qobEbi4RTwHCHcsSmnHt7VhfeCsJa8C2KR7H8
	j+nCBZY8AIl5xcdlQfxCMfSRxccbm7ksU07/NcFi/z79Q8qnSYVHDfYxw2bgyMzABpBg3z
	Lg767IDHQM2A+X4XrADU4VDxHyCPtyw=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>
Cc: Ye Liu <ye.liu@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/7] mm/page_owner: misc cleanups
Date: Wed,  1 Jul 2026 09:22:26 +0800
Message-ID: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aqayze8qhbmj1techt96smdiej3dyoea
X-Rspamd-Queue-Id: CA2E5C0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782868971-274945
X-HE-Meta: U2FsdGVkX18mApJH/VNVIa0HTdnObFPUaQ/wBGGm76OaGjQoZzlzfJKFQZ9u8g8TRS8Hr4Qb1VEBa72QV1YXq+lijR64fKOv9gi5e9Jpcy1b1/K/i34X6/y/CFq+LZzEsjyULFS9on7brnZcFy+GVpgLpoxnDvYj6bFgle1wyLN+y7FQBLq1J+0CGXEsqPSCRiP5kQDAOhM9lDXU+ZmjvUP1OzU72QlaRh7xYBL6D0RI9ijgiV/4PeolTspENURBCTfFcXqIYg451JN4pIrIaEcqvKWSR2MFI/DL4SiMvFP51tAJcJwLjkaB3OxES2zHjaEh39wKl/amMlLDyEd5IiQk872k5rCrH+aX+r+jQJpBIWK7S8N6NlHH9ZCYfSZK9cMiw9UvXGNvEtEQB82eApWajmX0cGQv8/9mAbxzrQPitwm8sTYGy/WhfObRklkAcIbiBBseHEt+rMaTvLdU78nkbxkjiWBzMod/VQQGekwg1BEeov+ppphGcO+FHF+aCj3ABUBEmUVdi3FwII4gWyPnsTYiHK2tlolJoPHeBuyzDJgdpTG4Bgm7Vtr6iCGznRHcVb0GL5GEWcrimSLJCv6ju3qUb9ROJp34L0vy3YcDpRxv9KRbyYq2BamM34c/yfIZbgFh4XpnCEmmfcjKaDQYjOMrJGFSSwHmTRptndJUxEyEH2jqekdDMUCUWpVpy61Lzxb+yZTwITmTAbWM3xJh9gREeCDOkPt5N5c79bSesCBuRYFBT7++NDoUqVK6uhHvofRZcuWRu2I6d25rOX5yo+qMfhNkP8fRoGHiodQO50ZC1mo/elV9NBZJ/1zbVEQ6f/cpjS5vnIpbR8qWWx+hIcIIq4QohWms4ur1AbRhMXL6Ipn1ivV59f5dLExpgrkLFiZJBCuCwUw1kmQ5DfUD8oqI/Rko5nO8MZ6GTkH6ZKCT9qtT3Il6Pl99rErFdxyd/AF99I5KAXc/pzD
 IgzvaGbt
 S7ym3I8nni2fvq/yYw6z/WYBCDyhCpso3cgviHXJvgA/v61mw/Xyxc2PPhQBB1Xs7Yf0maD1oIj8yDQ1/zzjAblKoyhKomHD1woRjJfR92q73LQynGgUqjMJ7PxpCVoaXy0aD6OgQWpezfeWW33isujaegc2bM2ePhBw9VZQDuKUrI3ZgmMoDTyNSLt0EG6SaKJ3bkDwP96xmYWsAagE8riP231N/RPPo/wJxiiIfJocb2c8hzOX0Vg3BmMiDNjWBOh0/LoA7eEIP3MqU9XZMdoOORg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v4:
 - Patch 2: also update scripts/gdb/linux/page_owner.py to use MR_NEVER
   instead of the hardcoded -1.
 - https://lore.kernel.org/all/20260630015331.147174-1-ye.liu@linux.dev/

v3:
 - Patch 2: add MR_NEVER directly to enum migrate_reason instead of
   using a local MIGRATE_REASON_NONE define (Zi Yan and Vlastimil Babka).
 - Patch 3 (new): convert all 'int reason' parameters in the migration
   callchain to 'enum migrate_reason' so the type system reflects the
   actual semantics.
 - Patch 7: make threshold_fops a single line.
 - Link: https://lore.kernel.org/all/20260626020522.28619-1-ye.liu@linux.dev/

v2:
 - Add cover letter (no code changes).
 - Link: https://lore.kernel.org/all/20260623065234.31866-2-ye.liu@linux.dev/

This series collects a few cleanups for mm/page_owner.c that have been
accumulated while reading through the file.  There is no functional
change -- the goal is to make the code easier to read and maintain.

Patch 1 consolidates three identical PageBuddy skip blocks into a
single skip_buddy_pages() helper, eliminating the duplication and
keeping the lockless-read comment in one place.

Patch 2 replaces the -1 magic number used for "never migrated" with a
proper MR_NEVER member in enum migrate_reason, adds the corresponding
"never_migrated" string in the MIGRATE_REASON trace macro, and updates
the GDB page_owner script to use MR_NEVER so that lx-dump-page-owner
correctly detects unmigrated pages.

Patch 3 follows up by converting the remaining 'int reason' parameters
throughout the migration and hugetlb callchains to 'enum migrate_reason',
making the type explicit and gaining compiler checking.  The 'short
last_migrate_reason' struct field in page_owner is intentionally left
as 'short' since it is per-page metadata where size matters.

Patch 4 hoists the CONFIG_MEMCG guard out of print_page_owner_memcg()'s
body so that the real implementation and the empty stub are two clearly
separate definitions, the common kernel idiom.

Patch 5 adds a missing \n to the count_threshold debugfs attribute
format string so that cat(1) output is properly terminated.

Patch 6 moves free_ts_nsec from the allocation summary line to the
free section in __dump_page_owner(), grouping it with free_pid and
free_tgid where it logically belongs.  This also makes the dump
output consistent with print_page_owner().

Patch 7 drops the redundant page_owner_ prefix from file-scoped static
symbols (stack_fops, threshold_fops, etc.).  Since they cannot collide
across translation units, the prefix carries no information.

The series is based on v6.17-rc1 and has been compile-tested with and
without CONFIG_MEMCG.

Ye Liu (7):
  mm/page_owner: extract skip_buddy_pages() helper to unify buddy page
    skipping
  mm/page_owner: add MR_NEVER to enum migrate_reason and use it for
    last_migrate_reason
  mm: use enum migrate_reason instead of int for migration reason
    parameters
  mm/page_owner: hoist CONFIG_MEMCG to function level for
    print_page_owner_memcg()
  mm/page_owner: add missing newline to count_threshold format string
  mm/page_owner: move free_ts_nsec output to free section in
    __dump_page_owner()
  mm/page_owner: drop redundant page_owner prefix from static symbols

 include/linux/hugetlb.h         |   9 +--
 include/linux/migrate.h         |   6 +-
 include/linux/migrate_mode.h    |   1 +
 include/linux/page_owner.h      |   7 +-
 include/trace/events/migrate.h  |  11 +--
 mm/hugetlb.c                    |   3 +-
 mm/migrate.c                    |  12 ++--
 mm/page_owner.c                 | 115 +++++++++++++++++---------------
 scripts/gdb/linux/page_owner.py |   4 +-
 9 files changed, 91 insertions(+), 77 deletions(-)


--
2.43.0


