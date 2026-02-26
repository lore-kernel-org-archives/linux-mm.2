Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0306FD8FF9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1769A6B016C; Thu, 26 Feb 2026 13:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B99E6B0172; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61266B0173; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35AF6B016C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:26:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9415958825
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:26:59 +0000 (UTC)
X-FDA: 84487439358.27.3609ECE
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id D6A4120003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:26:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OXH8f7Fl;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LlCjj+3UcXvXvqd5PfGg5q5chZ1QMHNerBnuWirnbHA=;
	b=KlQN4mqUYdegs2GMHWazSfuDv5K5rTBrB+SopTSg7UnyFsdafBkiMl4mJ0hp+FPsoUpc6c
	KfFEwwp4Vxto0beIrX+UIacXlJV1QXRzZkLp+q7FIKF1oQEEoNcEy6kIUrmhJdo/TbH/1D
	GjmZkn7uEoZN4sUM51uixQBo71Kq430=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OXH8f7Fl;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130418; a=rsa-sha256;
	cv=none;
	b=heCixD0lEVF/r232Q1NXeGxcJ9mg+C3/QpRld+L6Dzp9lgKcAoc15qd9J0oHR9/RF1k6hy
	mLwq2NkGPdXzpU12s0KJkURxq6OBFRcZpr00FYJv2Mt1rYwq39wRAbhzH2Lwm85qnnPpzv
	C18pQzjCaD25BOFTRKE6U4kD4EQpyHc=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 34E3CB2CD9;
	Thu, 26 Feb 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772130414;
	bh=LlCjj+3UcXvXvqd5PfGg5q5chZ1QMHNerBnuWirnbHA=;
	h=From:To:Cc:Subject:Date;
	b=OXH8f7FlOnxRA+eanQJnKn/eZc8rUSUG5RNK9MOQAg1wdyf1WUHzZIzq119NaxEQg
	 ITICJ0B0MOIR43D4yzTWI/bnDjH040u5352TQ9ixNzCkSMxAM9ZJRitpZ2GIFMg3B9
	 cDltXdx1xa7+0bG+P6hLsjU6iLNzNFb0TvLgrM18=
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
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v3 0/5] mm: zone lock tracepoint instrumentation
Date: Thu, 26 Feb 2026 18:26:17 +0000
Message-ID: <cover.1772129168.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wekiyce8kbi5ydxtk4wemnpweue8pphb
X-Rspamd-Queue-Id: D6A4120003
X-Rspamd-Server: rspam10
X-HE-Tag: 1772130417-266631
X-HE-Meta: U2FsdGVkX19nMn7Z+ZdzGlgyYjLC2iyYFsvvJfS/BY709atlBR1BYu9psGgpIjWst2RaX/fwHKKyuMWFjm5ShNde5pQbF1V8SOMbWWcUSvxmoNXGpvEG3QUdxLxoGIKT/A7MnZWjmJCCa4dxdoh/C/EWq0D/kcqqNOsmJcJAwoo91KNOLOkJX8zKO1VjMnrFafIJSamREO84VPeWcIlPoqu+wlOEfyZYXaxytUDL6ri76lrkxlk00ifiToqh3vovR8zYstrpyIee9I9PZNjgQRwEYbNzbwxSyHrB6XctPP9qS2mLA86x4sxU4lgIYSMOasqvbui+y22i5BA3U232EFJjrfSjys3OIrFgQ1DoOgF45ahWZlcrKMtDsi7w5NUwjsmfyIrQq8GnuM2tdCnfTln3Zg/YMNl5vX47/e8ueDsqAAUbIKXQWovQcNzVYGmJhtIC4Jxzos106Ri1/5aNvQaDYimaTlgEHXEjfVxdpkytz7k/Cvx6Lu+HEOpMUuylDg7yVj0Jm6gFp1l4AnxPRYTj398a4ykjF01t4NF25cAT8fKYgRpz2Ih6AeeLHhjwa9DR1EEdZUDLGsbZEyt4Vhje7Q3ohnJhRRgKWUnoCne/oZ4N/+bNnAjjZCkEymEyhxotGlKX6YWdScncKgs0lgc85zuzYEz6UHNTqDz9fPStwdV8yicbzOzPCbRLbxKYCZv7jxs31CsFDpHTh6puSyZMFsLbOHmpveNmhqC0Kce6QJ4/8oU6XGb+dcNIVn/obStUz+37uLuA6VMDB9ubR+nweAE/NNqt7f/BAcrK80AK3fIM6FrufmVbH8cTd5damp7TgSTGCbOqrlpnCIvNbpNPy0jBVYH6VxD517txU+Nzaa2xndJOD3m4Qx1V2zIyAbYhE/ZrBgxfOYKcTMs5TmW7RoZooQgW3daCsVsEA3kS11xDr/ieCnPER6AjWYowzkkBrGeTurv6UpgF4Cb
 lT3kSKPM
 CfYyeoxNxb3ExdKpoRDU2xG0WTBAy9Vx55AtGj2PX7voXCAoW249DIAYjl5SXVLw5VVDaDj8Sr+kR0FnfNYpr/m4lOBj2B8eKkJgYaA6yRL7qldygi40S6iyCca8f0objK9Yv62OUdrYBGcQIAuHU9iVGg6V8yNMMUd1ezO5JTWd9dCV+82WqiT3XpQAhM5tLQ7ZTN4vXg4W6bG1AMQ9GAavAQG4g4zVBrPp2dpTKDEDwpUmHlYl/V9anU+HuytlclhpTD82SNqE5URo=
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

Changes in v3:
- Split compact_lock_irqsave() to compact_zone_lock_irqsave() and 
  compact_lruvec_lock_irqsave().
- Rename zone->lock to zone->_lock.

Changes in v2:
- Move mecanical changes from mm/compaction.c to different commit.
- Removed compact_do_zone_trylock() and compact_do_raw_trylock_irqsave().

v1: https://lore.kernel.org/all/cover.1770821420.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/cover.1772030186.git.d@ilvokhin.com/

Dmitry Ilvokhin (5):
  mm: introduce zone lock wrappers
  mm: convert zone lock users to wrappers
  mm: convert compaction to zone lock wrappers
  mm: rename zone->lock to zone->_lock
  mm: add tracepoints for zone lock

 MAINTAINERS                      |   3 +
 include/linux/mmzone.h           |   7 ++-
 include/linux/zone_lock.h        | 100 +++++++++++++++++++++++++++++++
 include/trace/events/zone_lock.h |  64 ++++++++++++++++++++
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
 mm/vmscan.c                      |   5 +-
 mm/vmstat.c                      |   9 +--
 mm/zone_lock.c                   |  31 ++++++++++
 17 files changed, 326 insertions(+), 99 deletions(-)
 create mode 100644 include/linux/zone_lock.h
 create mode 100644 include/trace/events/zone_lock.h
 create mode 100644 mm/zone_lock.c

-- 
2.47.3


