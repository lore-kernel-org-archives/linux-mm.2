Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53FE5FEFB6C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884346B0005; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8615F6B0088; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763DD6B008A; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B30D6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18C4DC2876
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:16 +0000 (UTC)
X-FDA: 84490700952.12.10C2277
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2B3D14002E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OvR8DcUw;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UzoB36Gdji3J1eB7hSJEZSO6/0RcFg8v9qSv2IGUJ3k=;
	b=mjETbmHxkFKl6htiWx7ssyWrxjsTiBSKAGfFVJajbnIfwt1j3K0R1ObdW7jUthNVI5EL1t
	fVJ/QjwTIzCvCLYEqRhiAUL6Rm24ayjqLIUZ8H/vqAHdD9N+pA7K9bwoFN9UNePXsm96zA
	Rhj/9Y/o4RTWgL/zaxdzcdVCRzceIl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208074; a=rsa-sha256;
	cv=none;
	b=788kHkBcp2GuliSq0alhSrNW88bT7pBfdFsQuFbHrA9TWA6s7q74pBVtWtWbJtqx9D0Swq
	klgOL2oCtZ/JaDPyfuRpUWjKtaUEf5iONXf7Xm4vdalDzAO84LJs6qNBF4isLBhPTa32BB
	jdpBlCjnPF+9Q0U0exuvKyh56UAB3ew=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OvR8DcUw;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9847DB2E32;
	Fri, 27 Feb 2026 16:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772208071;
	bh=UzoB36Gdji3J1eB7hSJEZSO6/0RcFg8v9qSv2IGUJ3k=;
	h=From:To:Cc:Subject:Date;
	b=OvR8DcUwEVl2s2n57k8VSZguWeBebBaxFLg1zQpS8GImERtTnvoUro+qg+ZTBybVB
	 gh+IF+emoV8VDF0MbFl39pAuJbpLoFYrIbBkV8oO2NmBac1Ix8X1R+8Kav7ecD7Dhv
	 sBc+1bJ/bbqdp6Gj1VL7zWD3usYXcCP4MZAbgknI=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	"linux-cxl@vger.kernel.orgkernel-team"@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Date: Fri, 27 Feb 2026 16:00:22 +0000
Message-ID: <cover.1772206930.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5hg3cumc31guz33egj6tx16pbebjgmct
X-Rspam-User: 
X-Rspamd-Queue-Id: E2B3D14002E
X-Rspamd-Server: rspam12
X-HE-Tag: 1772208073-366377
X-HE-Meta: U2FsdGVkX1/V2mDfJiPsd0fmjWOfN4eHsjyGPgS/wyYPrK/WNJpeOhN04ay8w09Xde0XKkVogJPUo7Wqwub2+Czv7kaEEStlWx8PkkgBLnldU2LSdsWKEbxUGRWhiUhpZYLrvx8/GSLgOjnknec75hGKdD35wKxzYa+879sf9vnUryDnKl2yDeGicCN0G+xCTJokiLP6Ywq1n0VlXH9GwZ5qcWNjJaBdGjnNJnKHNcvuR2zb0WYSNIbgvRp7Hlbiq2w/v6c7txE/dUAUdpLz+BjI5tSS11A0HGwa8B5Jf0tmZ1J/IIVMvaQ1WBq1d4VuMNMXAhhzVatnxqKmnYeAUPTLhqjLV89glU4IKaXIlCURxHt9nbCMdGGftWkMcB16p5ddPw8OGbr9P6XmNlD1D22NAZZ8Rq/ylkNtGqAaD89CMLYnbHse+9UhwGT6xzgD2YJJ33BM8Y1bGrwrNkFCudTsturyfBmE2BB0WL0ztDF9eB9O52hR6twhsct3Z9Ou90s/gr82sNYPRK67FMA03epZyljQyq36BzU8tXkBTpJUnbxW5WbC2nd+QJr6yCdsiaE6+bKBDErUGzd/yW3bAKdrbU1hfaOCcPdU5wZW8qnK/DfegxyywLqtLoQnRrQTgD1Amc4yLicQp3jB6FCOQ5E3Pg+vkT6/RKgv8ABmQWPKKiHearlCYNPLnfObyhaoUjs0kVQ/GPOB8izLXIwFO0BLtLO9IOtghTXyBFZrhut42dTIGuDkXK+Elgz4IPprazf7bD6pPkAFuiNaWvYB68qDuNKvQ/Eri2lPKBYPlRSth1pXL+l3lip40eJVBnB8iTnNtCAjCYjA8/x/5zczSWzPJqeT1Zxb5d7kjmoS+9ebVsaHoHTUWOrwvVs/goh2TlnnwcLm/tPVEaE3rrVK1e3MBXGwi0V/oubZSeqEYo6uw3A//Sh7nl+fXBX7EI020Y3L8vbuPdjBsG/ui7/
 D3JruwmK
 3t0fPmkNjJlALVcY4/zTwSMuTHtKWvP/f+pfB05QL0RZtvJ69Q+fBZQJZkPcW8Il3+RoVsO8gDemOt7cN89cFTfaZ76I7FSpaMvA0a7a+fu+DbIdb6Tps+MqHNWVosxkkK7eKJv84O/BDG/aU3vtRQ2qgh0dfj/vQLqfERHumgNjq0bqHE5Ntp82XamiCHb0IAMh26xFpXToXQNob5BSUlk8kvfGBVKrJZJ6I0Gi2Fg1JYsh/TbydzrXk+GgiRXwliRqEM2vsb8q9Qts=
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
  4. Rename zone->lock to zone->_lock.
  5. Add zone lock tracepoints.

The tracepoints are added via lightweight inline helpers in the
wrappers. When tracing is disabled, the fast path remains
unchanged.

Changes in v4:
- Fix build errors in kernel/power/snapshot.c and mm/shuffle.c files.
- Remove EXPORT_SYMBOL().
- Rename header zone_lock.h to mmzone_lock.h.
- Properly indent __acquires() annotation.

Changes in v3:
- Split compact_lock_irqsave() to compact_zone_lock_irqsave() and 
  compact_lruvec_lock_irqsave().
- Rename zone->lock to zone->_lock.

Changes in v2:
- Move mecanical changes from mm/compaction.c to different commit.
- Removed compact_do_zone_trylock() and compact_do_raw_trylock_irqsave().

v1: https://lore.kernel.org/all/cover.1770821420.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/cover.1772030186.git.d@ilvokhin.com/
v3: https://lore.kernel.org/all/cover.1772129168.git.d@ilvokhin.com/

Dmitry Ilvokhin (5):
  mm: introduce zone lock wrappers
  mm: convert zone lock users to wrappers
  mm: convert compaction to zone lock wrappers
  mm: rename zone->lock to zone->_lock
  mm: add tracepoints for zone lock

 MAINTAINERS                      |   2 +
 include/linux/mmzone.h           |   7 ++-
 include/linux/mmzone_lock.h      | 100 +++++++++++++++++++++++++++++++
 include/trace/events/zone_lock.h |  64 ++++++++++++++++++++
 kernel/power/snapshot.c          |   5 +-
 mm/Makefile                      |   2 +-
 mm/compaction.c                  |  58 +++++++++++-------
 mm/internal.h                    |   2 +-
 mm/memory_hotplug.c              |   9 +--
 mm/mm_init.c                     |   3 +-
 mm/page_alloc.c                  |  89 +++++++++++++--------------
 mm/page_isolation.c              |  23 +++----
 mm/page_owner.c                  |   2 +-
 mm/page_reporting.c              |  13 ++--
 mm/show_mem.c                    |   5 +-
 mm/shuffle.c                     |   9 +--
 mm/vmscan.c                      |   5 +-
 mm/vmstat.c                      |   9 +--
 mm/zone_lock.c                   |  28 +++++++++
 19 files changed, 330 insertions(+), 105 deletions(-)
 create mode 100644 include/linux/mmzone_lock.h
 create mode 100644 include/trace/events/zone_lock.h
 create mode 100644 mm/zone_lock.c

-- 
2.47.3


