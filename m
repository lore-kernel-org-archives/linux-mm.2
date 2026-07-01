Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69973C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8C96B00A6; Wed,  1 Jul 2026 02:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268AA6B00A8; Wed,  1 Jul 2026 02:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180CC6B00A9; Wed,  1 Jul 2026 02:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E00456B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69A321677DC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:17 +0000 (UTC)
X-FDA: 84939185394.30.3B262B6
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7B2F640002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C1fftJtt;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886275;
	b=RSUbu0R9rE57q8MWnw88ATskbmUzNMv1vhu0bitko7obtyIVmOCeJFot/CODq15urOUKIL
	G4+sKhvxvPm0mszbP5AfLMXZk66ucixGe0aYDcQI11sNTDiK5Ya8kvxiCrkxuTsNmbBPlH
	QirHCavEUzFUQd5KWVNtKh6omGdG7XA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ypz/Ukr7QMyOPoCjR35C1QTtc8LxW4fOAidoNmsA6a4=;
	b=LcfmyavilirZ1l34WEfzi2dhGCH0XXDxxnOcNiyxFuZdaP3fc9wfxnVWlHaa+KVETaqyHe
	XkWFFrcr55bTmmLYNi6t3dvv3Jo4a8JO68SnXeGpjtDazOMLnaXvEQEqIyGinHEsxPwDYY
	b+VejE3tcUDCK/yFLZwvVY9cUmz7cGg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C1fftJtt;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ypz/Ukr7QMyOPoCjR35C1QTtc8LxW4fOAidoNmsA6a4=;
	b=C1fftJtt641Ka28ho6DUwuH0eyyGnEFHd+NqUAaH2pj2z6qcrO9mrBNmFh87dBXe4pi5Bi
	zsqqAcrFauvovQZ+s6hW95mW1rDy3iRnn/ZfgTO1VlA7LEv6nJCNcoEooCcSGp+zOngk6v
	gTs+Yre4sRJGn6mejlPtCeTpMTFQg48=
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
Subject: [PATCH v5 0/9] mm/page_owner: misc cleanups
Date: Wed,  1 Jul 2026 14:10:43 +0800
Message-ID: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: jzxtg13gr5ufyip8miu8dbzkxq56k5ya
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B2F640002
X-HE-Tag: 1782886275-338930
X-HE-Meta: U2FsdGVkX1+/KL9VezcFYnFpCk8HB5BOVpGMjdj7pn+xWrCR2gJFVczAi0qJM7o55/GpP3GobVuwJ0J2p9E90APuqQK0lIIQAqbvJeygFhO5usnciYxXq3jjn4zJfFQKE4sHB1nOPGljB3Zamv+aXXMUHamqtCo7hIxhzGNQp7PRvo6xVw10KLOQp9eDK1RBbTGnj9xLFe7QQE/4m66VfFItv3Q2erLxZ4IZAxRauhdt1rCsWkbADQ1h/UktKlsRVqFiKrQrBIsQgweOMzzHSMeisjuOwzn2O0F2eQlgffqvtu/4GulrpZegsIddxRGtiTQpDB5roE8gxXIwSGtY0Iz31wQXitUXLSsjEvF2K/vPOIQcn2K/emu9ZUvQ9A87VbWxS7ZAdax8cdJsh6FrXqAnioE4dhqQQopGCbMbwc3MUGeIjNmYc/sJttlykBmN4/dQeyRc1cvoW5gCOHYxhubIp3osJGYgvrUrLr0WW9HnUi/BSodb9+Kl9DiRVfI716VA7zcBMTejmvME8UfvbnRA8Am9AYfnenU4QpfE8zq9zjdH/QDnM6waPThCdJGoxS0RrXvNgPVfxLuZnBnWBAH2VpHmsywE54EFXqftokMtiD1F0RR0fAv6OsrL9pw58XdwHI4sGVRBKwQ5p1Eaz56cQD6hS3Iu7mCyNSiRfAWRusaKXejdmSoZRXqb+xfyZFBxlW4LirpHnJFG9aL1mBleM9YYQUs5pvu18d4EgMxMBdcaiz3xNOHCpXqCyHnttvQ6Mjd7vW/3tYzOYNC4rdPIi2eiWu2TB81GKKWsgVYkJtLfnbn0yEx/c2nlabtLRmbNiAymKKYThLadcCXPPQcvI11JDftIVFHqMSXYL7PNDzzXIK9gS9dAZqzxf+oQ7udYWtrP8Z8n4UxfNORLB/LkvOBZVMpggialPFl2xqn7BMu+zjaoHMNRcE6JQJKyA2TXYkzbs4Gt5+9jgt6
 GX2Nka6K
 YzCZxy3ZGCyiFKlMVo6dsJK/9ctAiZUt1gQnFg24EeTIClQ1tXi45XAxTCgFIUg9ch+Zc2QMnCmVjPqydo9lG5ckKnksZZ6JD2w85dagcwAAcdLSyMwgjr5qhbuwauGZHIb2UjlciwdsTaWvtxtnOA1Y1hOvZJ0VJPeozWatoHuBX+Y/so/3Ethq7CRorv9Ns3sloDsdFy83FeMMhArWPWkWIiESCDW6q315MtF3intL1jo0d01ZZPmkffZYsG3tPyq1K22jL1O3rI04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Patch 9 avoids a TOCTOU VM_BUG_ON in print_page_owner_memcg() by
reusing the page->memcg_data snapshot already taken via READ_ONCE at
the top of the function, instead of calling PageMemcgKmem() which
re-reads folio->memcg_data and page->compound_head locklessly with
VM_BUG_ON assertions.  If the page is concurrently freed and
reallocated as a THP tail or slab page between the initial guards and
this final call, those assertions can fire on CONFIG_DEBUG_VM=y builds.

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
  mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to
    avoid TOCTOU VM_BUG_ON

 include/linux/hugetlb.h         |   9 ++-                             
 include/linux/migrate.h         |   6 +-                              
 include/linux/migrate_mode.h    |   1 +                               
 include/linux/page_owner.h      |   7 +-                              
 include/trace/events/migrate.h  |  11 +--                             
 mm/hugetlb.c                    |   3 +-                              
 mm/migrate.c                    |  12 +--                             
 mm/page_owner.c                 | 127 ++++++++++++++++++--------------
 scripts/gdb/linux/page_owner.py |   4 +-                              
 9 files changed, 102 insertions(+), 78 deletions(-)                   


--
2.43.0


