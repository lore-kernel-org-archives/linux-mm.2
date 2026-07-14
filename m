Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D281C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5DC6B0005; Mon, 13 Jul 2026 21:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1766C6B0088; Mon, 13 Jul 2026 21:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08DBD6B0096; Mon, 13 Jul 2026 21:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C89006B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:51:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 513AE160238
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:37 +0000 (UTC)
X-FDA: 84985705434.18.0DC9043
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 34956180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kifN5DfT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993895;
	b=gnPRJjhOFuhtpYxzEtprsE5SUUHxRnOyeyRfKUZXl8znvZHeK1LJgkRQ2GflmwWMWKNlzW
	Wq3S4B/+W3sBbFXbegyxMBVamY+L3zrte6tzPj5uduIVJuXEzg88tYC0aT/xr4Mrx4Z0C1
	eB7MM0M3uaQBY4TzERHqThYl3EekLCM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kifN5DfT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iaDVF3WuxppNxImS1nHcF1VL6OsrhCsOpkRvEZ8Asik=;
	b=WK7rNnJEnVXIptDpbJbaCcJdELiYjYm/2keU/GEGwUJX+dEg6XolLkaxrwVabECp0hmKou
	ndWJJPCZVX+gouM+TdszwLuW9cmH91bEfEiL6SsKd1YvrVrjEBaTARVG3iR6jIeoLwIjs9
	ESPdmD538GN/eLjO/FeSMNcYs84pxfc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iaDVF3WuxppNxImS1nHcF1VL6OsrhCsOpkRvEZ8Asik=;
	b=kifN5DfTV8lnCj/IHHJTFSR5RynbXvrlPDQRBA1r8TOXEBcPS9ssNFn39vguX2dD8h6+3u
	XMXeymH89qzvBXZHoQ/0TYaRPuqJMZtKsQ2jC39vzmmTR9gMjzgsH0vMsITeV4RHTxC3HC
	z0kv3zEkEEfGsfKH7rCQnX65rqPUxZg=
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
Subject: [PATCH v6 0/9] mm/page_owner: misc cleanups
Date: Tue, 14 Jul 2026 09:50:59 +0800
Message-ID: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 34956180003
X-Rspam-User: 
X-Stat-Signature: ff1nohh6i5k1r6uer5hkiij76p8ztink
X-Rspamd-Server: rspam03
X-HE-Tag: 1783993895-638825
X-HE-Meta: U2FsdGVkX19w+AFOxqGa7Xcmd9kUdKFIYJj4EQsxZYWAnxfurzSVp3BxGmCSRhO85ea5d4Hr+I3z52lazOkZ6rc2KX9xVUoQOGRnAiRlyQHBBpWNthY9RfTBO7ZbOKn7KKuemIvbDbHGjW9RtmLaxJDoXpboROgOMabV8zDeNGLaHqNDWKW1v4xRXq0omNRCPFnI3pavqemIYB9GZY9dc4aJAtaKpjRvZE1RxPKbMfArzfwZReTHz7JziJvJYid431AwZLpX5Zcyj77Uk7qA7a6TZPWCg5Ms+P+xvUPHtYbNPsEEzFXGeuJGfYKajJAbMPyrKBGMW715sgNMGucgCG+NmndflUDR7mX2vTsvcJUKmb9mBxG8xmiDkzRKQZFXLK/r1dTvm6WyeULWcq67GJElLHBbyNnc0qumca1l1HnyN4NJbdslPKmqsGiY8o/Xzga+YY8L0slqPdj0AuQmjccM1Zwka5Mk8/14eAI2Knnln53TzQZnAAwiFpa9Q7OtePdwpVqdgkyFyiGpysvmp/GYVqCIt5tIfNnGsbvg5Hpe6InmxsyYoRBNSBS204kVVRTtdMctiBgwPB/5OLEaMhtxfF2z4a5WhNRC0m5pn6sXw+hPylAmiUs+G1K2Dn4aVCNULmJXTDu/Bq4M9e4Yh6lqvqRoP7cg+D0kezAKDhFA7iHfvO3gI6c6hGnAH227O5wujaesmkLQx5m0Jb0INUiSKywB1ltiN89/d8yYigFfoZIEjbuQT4Z/PTzd05XJzifVnzAJkvMNtcORUEL0ekPORnKQ+ErnZqKyRv833Iu5cp/WpYN9Z5ksOKsv7puRz9pzigyueQrJO7CYHBepSlkwd9VMMGTe+1fJa/nQ+KSNQ65D1MBBJoSvq5XrtcSRxUNuRDUsVQYjQnwOLR4pUg97mJZBWyesXvbn+etPFfib9F+A//qw5cGT+55ED1jMeC8xt1MuNAGpfSsPs44
 O+NLtRyQ
 44EYbu/8J7Vmzsr9hT+UISG1aYMpLIQ4eX6Y8dZQLwbet2qXckj4bmxHDXz1G35by59eLrr3JDzH8ogO2ppgyaoX4UIMUnR/1zQIp4TCUpR916WNYu+E2GGMTVcV6ft+7Cpy4eiVotlBcKvutNsKZjyoM9DqhtKZ5OgN/APDHR9WaRSfJNuKFZa+tNQDFQFwjDbOETibNbphAbnEuR4yibFi46E57nRrPoYtOfXBp0+JjKu93As0bNQhwnBJyULTr8Ea86YpBjmkm6YnNdSz45yMiVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Patch 8 clamps the PFN advance in skip_buddy_pages() at the next
MAX_ORDER_NR_PAGES boundary.  The lockless buddy_order_unsafe() read
can return a garbage order value if the page is concurrently allocated
between the PageBuddy check and the private read, potentially causing
the PFN to advance past the next bounadry whose pfn_valid() check
would have caught an offline memory section.  In read_page_owner(),
which relies solely on boundary-aligned pfn_valid() to guard
pfn_to_page(), this could lead to an unmapped mem_section access.

Patch 9 avoids two TOCTOU issues in print_page_owner_memcg() by
reusing the page->memcg_data snapshot already taken via READ_ONCE at
the top of the function throughout, instead of calling
page_memcg_check() and PageMemcgKmem() which re-read page->memcg_data
locklessly with VM_BUG_ON assertions.  If the page is concurrently
freed and reallocated as a THP tail or slab page between the initial
guards and these later calls, those assertions can fire on
CONFIG_DEBUG_VM=y builds.  The OBJEXTS (slab) case is also simplified
with an early return since objcg != memcg for slabs.

Ye Liu (9):
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
  mm/page_owner: clamp skip_buddy_pages() PFN advance at
    MAX_ORDER_NR_PAGES boundary
  mm/page_owner: use memcg_data snapshot to avoid TOCTOU in
    print_page_owner_memcg()

 include/linux/hugetlb.h         |   9 ++-
 include/linux/migrate.h         |   8 +-
 include/linux/migrate_mode.h    |   1 +
 include/linux/page_owner.h      |   7 +-
 include/trace/events/migrate.h  |  11 +--
 mm/hugetlb.c                    |   3 +-
 mm/migrate.c                    |  12 +--
 mm/page_owner.c                 | 135 ++++++++++++++++++--------------
 scripts/gdb/linux/page_owner.py |   4 +-
 9 files changed, 109 insertions(+), 81 deletions(-)

---
v6:
 - Patch 3: drop unnecessary 'extern' from __folio_set_owner_migrate_reason()
   declaration in page_owner.h; Adjust the indentation; add Reviewed-by from 
   Lorenzo Stoakes.
 - Patch 8: clarify commit message wording; add Reviewed-by from Zi Yan and
   Vlastimil Babka.
 - Patch 9: rename patch to cover both TOCTOU fixes; also replace
   page_memcg_check(page) with extracting objcg from the memcg_data snapshot
   to fix a second TOCTOU issue; add early return for the MEMCG_DATA_OBJEXTS
   (slab) case.
 - Link: https://lore.kernel.org/all/20260701061101.344679-1-ye.liu@linux.dev/
v5:
 - Place the two patches corresponding to the Close connection, patch8 
   and patch9, together in this part.
 - Close: https://lore.kernel.org/all/20260625014708.87386-1-ye.liu@linux.dev/
 - Link: https://lore.kernel.org/all/20260701012239.315262-1-ye.liu@linux.dev/

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
-- 
2.43.0


