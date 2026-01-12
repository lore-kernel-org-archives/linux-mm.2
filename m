Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630F4CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8152E6B0092; Mon, 12 Jan 2026 15:01:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753686B0093; Mon, 12 Jan 2026 15:01:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C876B0005; Mon, 12 Jan 2026 15:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBEA6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:01:13 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC1BD8D0E5
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:01:12 +0000 (UTC)
X-FDA: 84324380784.26.37C1E18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1AF1910000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:01:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=BijV+8lS;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768248071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BxBSRmGxgfXg/cqYvYDq8dvF1zaNPsFOZi5Vw1+H8Lw=;
	b=kJUqt1ixU/Nt+hqQEhTM38PUckhxZ+jZ8FKEyGdjoc5W+9ncVDkR42ntO1HKMc4M/rzCkO
	l/id0L9X27nER7CsUxTAtQR8B5BwJdlm1Q6Fy3hEDLenVdKLJDb4srDkP+H5ibgxc4EHnH
	QlKxvw6bVOuek6Z53WmtVA1OlK39Hoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768248071; a=rsa-sha256;
	cv=none;
	b=7aq4utSuFbKk6c+EUx5a6TYr686X0aFIpJzHQRffs0w/nmFMm6WVOMCcjNEngl1phB9AMQ
	0GpzbkuvaX9hNSUW39wXstz2oeGoNgSTl+AhD9SijX1CmP9+Bd/8AGP1JS1+AS/AOD+iwS
	rB7/mWp2ec6Va3YTNxDFdY1Vg8DXdkw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=BijV+8lS;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768248070;
	bh=BxBSRmGxgfXg/cqYvYDq8dvF1zaNPsFOZi5Vw1+H8Lw=;
	h=From:To:Cc:Subject:Date:From;
	b=BijV+8lSFalUiReQfK65dQWqBj1T3ltynENnDHrcIvy5TapIKD7QVnDcnF/Z6Fq6I
	 QUeBEmLRTeSIMgsU1J/qk1GDp1r/AUyazsIm7oKS1pndyTm/wERjJWpKYZQD65tzB6
	 dN2q1W0X8luat7dQESVxy6dwM8tsR2v07CSLQ3FsR4T33t/C1o4wpb5IwbiCPMOdl5
	 7fjyfyzPzMBq2wfyVNFmI523yByzO0EKyguxc75eXo4AUWiutscco9OHpAqUtUBApC
	 JobNzP2CEv54z3yRrCbIVsHeE0gTToqCtAMl1Qd3XmZ8/dUTDwT7kIySbqKz8/AhsI
	 J7JlKMCyP0zOg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dqjtZ0tMPzkqd;
	Mon, 12 Jan 2026 15:01:10 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v14 0/3] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Mon, 12 Jan 2026 15:00:53 -0500
Message-Id: <20260112200056.1250404-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1AF1910000E
X-Rspam-User: 
X-Stat-Signature: ibswce7acmn1zt5n7uq3i9xyji61wxoq
X-HE-Tag: 1768248070-98021
X-HE-Meta: U2FsdGVkX18VF00b6NIGKlnSSYogmYPjYYB4RfrAcCe65ijFIv+eYZo4Y4jCQby36hEqBtKf5AFYZtI56EBPCKM73O/bzcpLq0Xi27g4gjgxEchgg2NGwlC4V/O7Ms7wlB29PjJuyX98cisOFMHZLUWfHiW7A+2A/a1Z2g04V982JgOn56FtaPqN7igES1q47pxNrZr1I5EMu8oUJ4qa+je2kV6q7RBjUFgntPIhk/wjRcg4pQQIjcTYS/EzUKztfjeP7ne6b0Yn4DQ1iDHDN4p6pLTAfqIBBPeDCD9U2ZQ9zcx5gNiImearj3yzxZQb6STkK9VOqbraxQ7IznRSjvSjeHPgoY+3Mh9JBfYR0KZKdPyk2nPjt2sOwppYN/gkGhEmUy8nbjHqapf1LsLqxshJxgqJPZhPaKMqfAHugC0LJRgm57PrrEIGHIYNA9nQ0eo9BhwkdU0h83Bmt7PJHOd+6SkfjELvsKo8mnWhIxaSoziYn5dno2JagTAAFnsSoBoL8T2ApKiYhMiz0H2nXlffxVEAdXul5e1FmWBlh5Yv65Yux1C6fpjBaJ/R05jpWVKMx0Uk2sMJ4EEV9X3A5byORlVtmjdiCgIkAvzr4LljsoGhhFOnVxzhdAXJOVfSuLSaGaD0QiO73LWaFPbKfMz6S2DUUj4VcFWcZOgf/DeO1UOU8nRggGAI3kMxdG95qZbUX+lp86TaOB0Io/VclDYESRPnLBx4rIC2rk934ACrJ5Bp+hlDboxnevZUNDNN1x0N9D9OKIMLqskDRR/95G7gkfIiZYwElVymQ+iG0OUZXosxfIUtn19yC+EiwY79WxP5kp7AC9Plm+hx5Dh3vr4JDr/a4bMY6CPeLg+RSr7a0DXjHQZGknmMPfGcmjM2qfDYg15kNZhBbqKTDbEIuBs9Ou3nwTstbelAqze1naP+QkbUPDooNq/BXSez7KpEKcou8FIHHNrQjXLZpsf
 tDzE0EMP
 O4zs9RaxfwA4YyZW9ohRI+5f+cJyPadVj872RXT2L3Wh9TfPkpFel8lKHyzinPrw5mI8nNurQrm1ZiyxG7Fj1sTCD8QXY8nxF6PNYhjC3r7FqEAEbqaIX/OwGkSZSBdxdVREgTgLXa7uHi8Or/pltbvOU3jMPlbxgCQJfpEq+F4BMXaUNOa7WPH5qpYRcp+2eRCi8m/1gV/mOEespfwQ/2VHhcQOQ9qWCWjkpS3fAku8pnJCLO45Grqe3/ZZq36I6A5SwyfZH8/06IdgPLmb2zI2sbEGxtYqLO4b8szfkHS1z3HR68ojfv5yxEfZPJuYhIBrWyJLpA9RTCQMNVoWVKYentyrbyKrp7y/9XUNhstNfI4IusqDSHKZ0GUahboAVl5cY94gxajY9mPjYG+XWb2+bLbfTpNXclIxegNn+fSnXV0K0Hhz4jCNvV2JkOb6U6yUgcNySk/A/G2C81ERxH0MwZYhiuE8XeD5W3mBPyaqZ0tThH6oVCyefLPLSkfgScsu/xBTPiXw8bjTADEu4J7SZI/Nq2N+PytJfdTyv5o6qq4iUuc3rKBhYWqDiu6DxqmexJClbHSW4pRMajD9x78EEfkFGGuZWUtt5d1AkcUO1g2e4S7GeGlIcg87i0243qrKXH8omxBu6ACd+munVl+vqvHLa05kfChpR/CkoklTK4WyKipFXY79YNgv9amEET1xX5wfV7ip6uJAH1udwWBzCgEMd3GcGq+kkz/ifqcCPhRGT/TvYP+WwZZCVbF6hG9RdF2urZejzfMf73QIDs9C02AureumasIHWQOX7vcf3bffnHXP/Y3ljjXTrLAioWsMKO7E/Q/yDQOd6MWjBYin5hvolpPINyYtnE5vuml1VSF5OMWGOOa0FnANt3hlRH72SL8k8DtK3LCJ2glHnDbdc/rStHkGuKUOmSQZgU8jWaWZVF6ijmtlxwpIP2ryjlaHph6pyKHDVDn/YV9Zk1X9Le7MB
 LgSYzzFS
 KeeFuAUKNrLWX7b50kjfCzf5+58SiXcYJmbrVgxThVk98YYrsrTj7tHb7e/X9JZDWFZ5xkVunPD57smAtjN9wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce hierarchical per-cpu counters and use them for RSS tracking to
fix the per-mm RSS tracking which has become too inaccurate for OOM
killer purposes on large many-core systems.

The following rss tracking issues were noted by Sweet Tea Dorminy [1],
which lead to picking wrong tasks as OOM kill target:

  Recently, several internal services had an RSS usage regression as part of a
  kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
  read RSS statistics in a backup watchdog process to monitor and decide if
  they'd overrun their memory budget. Now, however, a representative service
  with five threads, expected to use about a hundred MB of memory, on a 250-cpu
  machine had memory usage tens of megabytes different from the expected amount
  -- this constituted a significant percentage of inaccuracy, causing the
  watchdog to act.

  This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
  into percpu_counter") [1].  Previously, the memory error was bounded by
  64*nr_threads pages, a very livable megabyte. Now, however, as a result of
  scheduler decisions moving the threads around the CPUs, the memory error could
  be as large as a gigabyte.

  This is a really tremendous inaccuracy for any few-threaded program on a
  large machine and impedes monitoring significantly. These stat counters are
  also used to make OOM killing decisions, so this additional inaccuracy could
  make a big difference in OOM situations -- either resulting in the wrong
  process being killed, or in less memory being returned from an OOM-kill than
  expected.

The approach proposed here is to replace this by the hierarchical
per-cpu counters, which bounds the inaccuracy based on the system
topology with O(N*logN).

Notable changes for v14:

- Change check_mm print format from %d to %ld (was folded into the wrong
  patch).

I've done moderate testing of this series on a 256-core VM with 128GB
RAM. Figuring out whether this indeed helps solve issues with real-life
workloads will require broader feedback from the community.

This series is based on v6.19-rc4, on top of the following two
preparation series:

https://lore.kernel.org/linux-mm/20251224173358.647691-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20251224173810.648699-1-mathieu.desnoyers@efficios.com/T/#t

Andrew, this series replaces v13, for testing in mm-new.

Thanks!

Mathieu

Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>

Mathieu Desnoyers (3):
  lib: Introduce hierarchical per-cpu counters
  mm: Fix OOM killer inaccuracy on large many-core systems
  mm: Implement precise OOM killer task selection

 fs/proc/base.c                      |   2 +-
 include/linux/mm.h                  |  49 +-
 include/linux/mm_types.h            |  54 ++-
 include/linux/oom.h                 |  11 +-
 include/linux/percpu_counter_tree.h | 344 ++++++++++++++
 include/trace/events/kmem.h         |   2 +-
 init/main.c                         |   2 +
 kernel/fork.c                       |  22 +-
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 702 ++++++++++++++++++++++++++++
 mm/oom_kill.c                       |  84 +++-
 11 files changed, 1223 insertions(+), 50 deletions(-)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

