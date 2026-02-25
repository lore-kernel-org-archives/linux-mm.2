Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C47DFD3762
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869C46B0088; Wed, 25 Feb 2026 09:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6D46B0089; Wed, 25 Feb 2026 09:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A7D6B008A; Wed, 25 Feb 2026 09:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA2D6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:44:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F36F78C055
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:10 +0000 (UTC)
X-FDA: 84483249060.22.D8DAC8D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32B0D18000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=dpyHCzsr;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772030649; a=rsa-sha256;
	cv=none;
	b=fCLC1s2tjrkAhDoieRaHzWmBL0XKBZ70GMP3pGtV22Nl+LeUBBS6UrheHn54V1kolgvrEj
	QpRhKmRIAHIi3z7apcJ9EF1FlPhIFlWNQivAK9HnWNeoH1P0wSIv9A6Ka7/1ZQPo3PSIN+
	t+w8YXiSlGbU276mIqS2vqN1i9TXrlY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=dpyHCzsr;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772030649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QC896ptdoNlPjD8cLAaltMQp2bbytEcY+6oAad9VY0I=;
	b=KZvFQzUeD3wm5xA2298slfgXbgn0tohxexDjvGYkOm9EC5ewrxIA0XE1la0Gks3rt+t2BZ
	TUOROHWRSfO7rhCQfOsAhIWcFVuMnWtp7JSVhrFNKWXAAopEz+hWIZ6BOZL87QeHi7b/bs
	p3TO2kH12ZcgW5teTeT2uTzbCy1j1pc=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 2B50BB2C25;
	Wed, 25 Feb 2026 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772030647;
	bh=QC896ptdoNlPjD8cLAaltMQp2bbytEcY+6oAad9VY0I=;
	h=From:To:Cc:Subject:Date;
	b=dpyHCzsrq1PL9pMzfm9Tsig1czhXhFsKwmupRA2E7bQbmPy/1cSxCV/OIXCaW4PXi
	 fTDIU/dMBx+M8nj+j7clH33eHwebJcm29qlLSUk0a2Re9ASFppNeOcfzNtIKNwacGy
	 VgqjeQJ773HiexHF6AIc4zVv5xDLKuABUkt/zlmk=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 0/4] mm: zone lock tracepoint instrumentation
Date: Wed, 25 Feb 2026 14:43:02 +0000
Message-ID: <cover.1772030186.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4wgkag585ohki4xg1twpq36n6nmsdkkc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32B0D18000A
X-HE-Tag: 1772030648-600257
X-HE-Meta: U2FsdGVkX1+uQXbyELdNTQYDD1qUG/kEFJOCnyMicwFvw2wK++IcqA6HCCrRO6AKybuuZLHFJfXOkXp1o6E/WvlG8LD1+M9S4qaURNjt7ggDmEXd+x+5YJQLbOka4KrenYHR+g4MqY/FTz7byXguSOURPCYwxtzTfNxPnBGbUN8afdZQ1etxsC0/H64K6he9adajLeBxWcn5WBuyBigTgSF9AAhORE35PWfh2i6iEYl6GEi1gX4FacVJZ7xA7sXfvcr7oL3w8CPGJYBaILx9/ru7+tp6PnLYUKKvxYBOuMSYJz+kbGuOmUy6XR6v8/9tLm8fhxunM9NtNx6/af9w2Weaow8NAC1YOkxr+nazbp6MyFJB3MQqpq2d2yuL7DzxcNCn+01Vn31AaGPYF9iAaApAFEnf39DDZcgUuXqyIU8cTADlOv8/bh7NWW4vBoM8iHk84xv800YnNV2Rbi9QgV8sjIMd4AzdAP4FCyfXW9Mxs1OUXVCokU3TWKjgSVuH/zm1S596v4LYqdjyUri/omjxxIvct3NxMMgqspCHrciI/h7wqWplr5BFJwnx2x1m1GvIVroMxaENWgKMduFf9ISL2OsI0hL2HI4D8OLCsvfYP/XXOpJ8CR88rxi8lk2fPaaR4D0o0qqr1TV+QP1u1jGcThpwT5aVgQgqytCaU6nkNk6ZsEKJAa3exmxRNKgSqK/KWFz9Mu3Xmnsn/fOgUmc8ri/56Pc1WtWDHY2sdvr0ec3xHKyw2+h1ZqAexgVpM9oqgbgY/x5XT67FsLjZvhGvIQ8gW+3k/+J5AaO+1RI+Y6Kri/DGQB4g5dLA8d3b3/eZwNuq3FvErPXR5yFfN7An8MnlJUkHuuLCDEVP2gq6XnGL7fx0qI0FzRq5qnGCA4NRmXpiKMzBhZg0LV4T+9/2gIpBW3TNZkGIZADHSmtqSp7UCF7WcLnPQrOzVi9rHKPr94ZeANLCM7Ev5xO
 GqeYwz7R
 EmBPdvQTewtfBK0pkBALONJgbyIdyHIaGNnKhPBvL1jvqhNIyfIZsj1D+Zm/0oG1/960YKXqRU6QozH0pY+gWt0AJqhegmMWUEItyF4m7stmUJg76JhdcRwFgHDccCKhmAja85JBda7xc2+/3tq/vlBd6Udmm6NO4fcTXmcVIPtYayD73qoKu2HJWdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zone lock contention can significantly impact allocation and
reclaim latency, as it is a central synchronization point in
the page allocator and reclaim paths. Improved visibility into
its behavior is therefore important for diagnosing performance
issues in memory-intensive workloads.

On some production workloads at Meta, we have observed noticeable
zone lock contention. Deeper analysis of lock holders and waiters
is currently difficult with existing instrumentation.

While generic lock contention_begin/contention_end tracepoints
cover the slow path, they do not provide sufficient visibility
into lock hold times. In particular, the lack of a release-side
event makes it difficult to identify long lock holders and
correlate them with waiters. As a result, distinguishing between
short bursts of contention and pathological long hold times
requires additional instrumentation.

This patch series adds dedicated tracepoint instrumentation to
zone lock, following the existing mmap_lock tracing model.

The goal is to enable detailed holder/waiter analysis and lock
hold time measurements without affecting the fast path when
tracing is disabled.

The series is structured as follows:

  1. Introduce zone lock wrappers.
  2. Mechanically convert zone lock users to the wrappers.
  3. Convert compaction to use the wrappers (requires minor
     restructuring of compact_lock_irqsave()).
  4. Add zone lock tracepoints.

The tracepoints are added via lightweight inline helpers in the
wrappers. When tracing is disabled, the fast path remains
unchanged.

The compaction changes required abstracting compact_lock_irqsave() away from
raw spinlock_t. I chose a small tagged struct to handle both zone and LRU
locks uniformly. If there is a preferred alternative (e.g. splitting helpers
or using a different abstraction), I would appreciate feedback.

Changes in v2:

- Move mecanical changes from mm/compaction.c to different commit.
- Removed compact_do_zone_trylock() and compact_do_raw_trylock_irqsave().

Dmitry Ilvokhin (4):
  mm: introduce zone lock wrappers
  mm: convert zone lock users to wrappers
  mm: convert compaction to zone lock wrappers
  mm: add tracepoints for zone lock

 MAINTAINERS                      |   3 +
 include/linux/zone_lock.h        | 100 +++++++++++++++++++++++++++++++
 include/trace/events/zone_lock.h |  64 ++++++++++++++++++++
 mm/Makefile                      |   2 +-
 mm/compaction.c                  |  96 +++++++++++++++++++++++------
 mm/memory_hotplug.c              |   9 +--
 mm/mm_init.c                     |   3 +-
 mm/page_alloc.c                  |  73 +++++++++++-----------
 mm/page_isolation.c              |  19 +++---
 mm/page_reporting.c              |  13 ++--
 mm/show_mem.c                    |   5 +-
 mm/vmscan.c                      |   5 +-
 mm/vmstat.c                      |   9 +--
 mm/zone_lock.c                   |  31 ++++++++++
 14 files changed, 348 insertions(+), 84 deletions(-)
 create mode 100644 include/linux/zone_lock.h
 create mode 100644 include/trace/events/zone_lock.h
 create mode 100644 mm/zone_lock.c

-- 
2.47.3


