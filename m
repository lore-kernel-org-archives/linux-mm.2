Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B0C7E9E31E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035A26B0089; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A3B6B0093; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CB96B008C; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A67966B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC38C13AB91
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:25 +0000 (UTC)
X-FDA: 84432544770.04.356D27E
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18DA814000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Bz3OY9Oi;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770823404; a=rsa-sha256;
	cv=none;
	b=LIiYEZgZpE1ECgnJuhIM917HdfFw3b3kRJNzYzLg/1CnganWPTljf/LFIDAUCkoroNh97o
	G9GjwuBMmL57kAVl/tPtxafTwZNNxOGCD1t7i8Fkb7tEQNcqzPRp9Vw0/IYyEhaa7n8dGo
	CHZ1cLtEytCVrhw546fAK/r+zzkoDfI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Bz3OY9Oi;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770823404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WDbtQj7bSQAlHwvUW/twErw6BWjpEQCq4GiuByWk9GA=;
	b=TmZxLBO+tylvbc2x/8ukFlpDxE/GLV4t1SSR/LyPpAT1JSVWRgEK9CGPQS/B/SxSaBZnlz
	+nHlpDaJvzodquQ0+4rCAkDlMqwvBbx0Rj1V0TFO8rP75aIz+ObAVmgRVtlBEFWFU3OJzJ
	lKKohqgsxN7s3bv5Zy9DwRHPS7Vwmw0=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 0B0EEB2583;
	Wed, 11 Feb 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1770823402;
	bh=WDbtQj7bSQAlHwvUW/twErw6BWjpEQCq4GiuByWk9GA=;
	h=From:To:Cc:Subject:Date;
	b=Bz3OY9Oio9m17o64qJae1ZUjvKKUkogsk4a0w3FDLc+FAg1vHv3ipl+nVYPOU1jYa
	 h8aIqj7Fkf+/IVSINuT+7UgC8S5zIW3xcjUWn9vAd0lRBqXUsusUT9G68QxYm9uCJt
	 MgCDATl4xkLuQ6gqHsjiLrqWg/B/UfjaV9ATTz/E=
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
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 0/4] mm: zone lock tracepoint instrumentation
Date: Wed, 11 Feb 2026 15:22:12 +0000
Message-ID: <cover.1770821420.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 18DA814000F
X-Stat-Signature: zxa8u4co1otkx61tmjpb8igcusy8iq5c
X-HE-Tag: 1770823403-204169
X-HE-Meta: U2FsdGVkX1/yFbjtbdETlixJ2DgtMLaw13e5wR8dGWvfBPJmy6zHHqvwVngbDq9fkujnuSwotQifpzP5YBEVAaLfYQDQdh8KGeCatotCJJoIt804uZKPZd0ddXjQR63wxALP3pUkhKwbcGy+oIHmZpKVV36sa0Vlh9TAXfpHxyp3QXaCFnr2XpcRVq8sMAkLFKHDTAWNEmZfFWJVqDcfZRbtMdl9yRae0wVDmfqNLse2QNzRs+o3vAXRRdQY/apDWWeFr70h2HLOEtZ9CGnjFNZWjQq9qJf95eib9pmo6qygMd2IPVI2NUSH47T1AcvpscyUOHRLgEiH1Fku7/ovYibYcJm1WaeBxa6/YB7SPXBaFrcm3C4uJSh53kV8eoHSetxeBX1Y3G14AWocjd8KQhGr8wbrGoBMFtiP44r3PTPNhJBGZfjfnR3/KGCPTNCHtsjagr9T3sc6KOXA9GhNzjOuBx6Y6djPmv+1jL3jX+KuEFTn4E4/fqyAa5ImUgbe4YBcBQ5zxxxxC9PMlB5wkxJsjCoIVXn5kcQTk3aArKV0DHGp6IS91O6rEXpm7hnTj4uBs+CuPx0V5JutyLC5YhVb61LSo9CYquZR8FyEsDFVyI6v8WQtk0pZ7MZXZHY0qyyAeksDz6RRHPrhGJmF5RllGL2haJO6JW6e7P4ixaY1E+i5K0ljDmlvbw44cxieMeATOHbzIr+EexDVZVs3YCtxlh8ePa9tfiqwSVgOrLxBS88kR+3pVdF9fi8QqopDU0AzG3iddOXaSggCMQZCuF1OOn3WUWpGiowgpxGJ6TsYvtaCc08+byelEQEK9ogblClpS2tkJDfu5BlXIXF2qHrFr3Xeihe9UOuV5yn40hKqWoCEi/+Nsm/YnJqr+XCZ3KFaHx5mNpION0nkZ9Z/uJDSW0gK8lvN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Dmitry Ilvokhin (4):
  mm: introduce zone lock wrappers
  mm: convert zone lock users to wrappers
  mm: convert compaction to zone lock wrappers
  mm: add tracepoints for zone lock

 MAINTAINERS                      |   3 +
 include/linux/zone_lock.h        | 100 ++++++++++++++++++++++++++++
 include/trace/events/zone_lock.h |  64 ++++++++++++++++++
 mm/Makefile                      |   2 +-
 mm/compaction.c                  | 108 +++++++++++++++++++++++++------
 mm/memory_hotplug.c              |   9 +--
 mm/mm_init.c                     |   3 +-
 mm/page_alloc.c                  |  73 ++++++++++-----------
 mm/page_isolation.c              |  19 +++---
 mm/page_reporting.c              |  13 ++--
 mm/show_mem.c                    |   5 +-
 mm/vmscan.c                      |   5 +-
 mm/vmstat.c                      |   9 +--
 mm/zone_lock.c                   |  31 +++++++++
 14 files changed, 360 insertions(+), 84 deletions(-)
 create mode 100644 include/linux/zone_lock.h
 create mode 100644 include/trace/events/zone_lock.h
 create mode 100644 mm/zone_lock.c

-- 
2.47.3


