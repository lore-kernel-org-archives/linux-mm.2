Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5D6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C456B00A1; Mon, 29 Jun 2026 21:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553C26B00A2; Mon, 29 Jun 2026 21:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469AF6B00A3; Mon, 29 Jun 2026 21:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD816B00A1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:53:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A18051C24BE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:53:44 +0000 (UTC)
X-FDA: 84934907568.25.BDB73DA
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA384C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:53:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AadapI6E;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784423;
	b=kOpRc11PQt4Jy9Pmb5jP+7ErPqKCA8LA5Bq6LvDrPjNX0sOsU5bt5JvvIwF7ZJOnMIZfwL
	cIqBBVhDVfIQ2S5sqehFUQkGV3TIoDP+grzL66Vn5EKonI6GCfLc98TV+nFTn2LeA+yKal
	Mb706jbkYtXjN5C9i7s/Z2IhdgmjHDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RAiVY9p2/6zW0az0kEL0BpXI8oyGRX6ACvl6M8eG5fE=;
	b=Jl8tpbU9pVfQnghr2Hh48JRuRR0EQ5PC0/RI3PXbvAcoSAOUSnIyH7b2tVY710v65Gdwl7
	Z1Dkdprypd09ASDNMkv82SiNCPHv5opOhR6qg6fm3QfAhDbgA2HpNLTpVh9Kni+P/tTZTH
	tdL++tBOOkFZUdwh3xtk2jhkLT5cpq8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AadapI6E;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RAiVY9p2/6zW0az0kEL0BpXI8oyGRX6ACvl6M8eG5fE=;
	b=AadapI6EufOnhm95GCsivQ14o6hpkJKiqd+DVPcPm1zpBYVEf5wQlPDtd71DDiDHViZq1a
	j7sp6cX/602tOi4jw8BGa1nfio2AQxcpGfNvvFrrq2FAbVXenhG15CB9GpjACbU+/JHzca
	vBW5m1dewPOS2NuCi3O3voduYwIXz10=
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
Subject: [PATCH v3 0/7] mm/page_owner: misc cleanups
Date: Tue, 30 Jun 2026 09:53:17 +0800
Message-ID: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: xzgnnj4m6wxijt6ndq6mz9ian1hdqua4
X-Rspamd-Queue-Id: EA384C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782784422-912877
X-HE-Meta: U2FsdGVkX19v+Sws6WJ7JGNKvGy5wllWHMTatZ3W1w0TDsldhNNtOWj5vZktgRc6kGJBGj5z3rfHyk9ScmFHF9Z0TqDLTSYBLtpsPzVxP5+60N/kOooy4b5AKVvjqTjRfPVc+1td+NhDH7tdi9sD5o5OH8tJ25x9I8QlUoQXskNEj3ZJagZJ1fEST6Q2CKCqqP5WxhzmhYc5XYpxe+5GroSPmNTTbE+xSUjUUDq94bDBkQ7uXMRk+Y97/0qyRHh3+77AewTag+Z9u1R6LSXUioZl4ActNNGZAYhDPc6EL1NzgXfFIz+aYWe75M2eNlP3hVhr9q/dtBvrUE9OHh2DGbtttehcJbMojeO6rlgQ386a1dH9YzcRrma+xAbUT/Jtecli/yeLE+qsWSkq71abQeUCwcdTD1bJ/9/XRPYZU/mQP6aHnYSRWDnhxMLhh3lzgPgH/21xq1qFjduS+Sk/r/MWslfNO3ZTeMcel6LjVSFCRaagL/dGEhq4gO40UD+73E9aiPc0oEw/8p/Y+m7xDsCrqnW9K9ng1rT2EDXQlYFRm8NWZ88gWLUFvn9NO/LAPfMtGIOzSPK1/F/da4WQ/0q53PHdRxrp7jHDf2Oxhj4uEP9azaqxuJ60unYrubHbNBBf+xmUxPFacbGO7O34/yVU+6HxJhYSPIx/X4atAQGby3Nx0LnaV4PUxJ7QEE/YDVK38AyQ20ntrSmQQPxFxqVf29UyV5T1EKjuaNuqsX/EvobAAaKoLqeJCHQf+NdW5kZKcv/K9tIIpa2IP3S4N0+/nlx0krFsHWv2bxt0lgH1SQFcUfvoBuzlnR8MvgLqJUC0unHzBfeKDy2zXQ/yuIGtShwPM194uOirlhAOPT3v79zS0Lr5cWX4k8OkclTw+lvisOn1LxbGpO/mvdb/i7M4iDufsx853t5qMvyOmW9MWAlP8Ud98u7zv7kF2CjY5kXXW5Tv7QGnfaHptEv
 KT1ysgTj
 84zO7jXs2DJWbKnC39W/lZ0hCNuXfRft1dVgecaQlTDQK8ysmkEZNmiCRO1Vq6xVTy/ghWcnDRnRswv/Qy2QU3aatUc2wREfXNh9E/LlkcTgyXRQK05MtfJqxn2Am4qDrq0mflsvEjJTCVGHzy+UuVO0jvjRhV6mWUqJ4laDUGwOR0pGgaoTOOb7YnokfTpj5By+3aPz+txL1NSFE++CWta1WJaa6PGIydtYv2/V/EU6bukJjnRGvYd+k5RXvzN3dHSRI2dV1z1berEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
proper MR_NEVER member in enum migrate_reason, and adds the
corresponding "never_migrated" string in the MIGRATE_REASON trace
macro.

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

 include/linux/hugetlb.h        |   9 +--
 include/linux/migrate.h        |   6 +-
 include/linux/migrate_mode.h   |   1 +
 include/linux/page_owner.h     |   7 +-
 include/trace/events/migrate.h |  11 ++--
 mm/hugetlb.c                   |   3 +-
 mm/migrate.c                   |  12 ++--
 mm/page_owner.c                | 115 +++++++++++++++++----------------
 8 files changed, 88 insertions(+), 76 deletions(-)

--
2.43.0


