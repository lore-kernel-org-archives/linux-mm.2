Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D73D25032
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 15:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0476B008A; Sun, 11 Jan 2026 10:03:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CB86B0095; Sun, 11 Jan 2026 10:03:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AEB6B008A; Sun, 11 Jan 2026 10:03:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D79E26B008C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 10:02:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB334C2FE9
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:02:58 +0000 (UTC)
X-FDA: 84320000436.25.D9720B2
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4422218001A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:02:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lPYQlMWK;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768143777; a=rsa-sha256;
	cv=none;
	b=KJsZbUxZ2UNS+LHgIOIbBBgOzfd/zWZUThCvBWPG7mS8NQOv2IqN3koumDHd741BbzV6wO
	SWPk+O+itfAwS6h55zp9Bi3F1KiRm6h8F9BFrDOBjSOx8UeSb4XVoyBKeINLmyiP2Y3hEe
	HY2xHDiUKc/6ig3ZqIIAwtQwPGBr6/w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lPYQlMWK;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768143777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K9SplFdsQ5NNi79gNC7Cn1xWYX0YiWYDAX5ZAyvhZUQ=;
	b=4ho2FxPTJz/UNp1gMW6HKQHEpCJxqOt/9R6WatkbhYAdIU9ixmcD07fmztp/uhXf6Q54NG
	QIpts3rWRyyo/aaUMJCQbSyJYC1cWKCLSxkAl5y+yPVSQ/CQuzjPZRmq9hfcIS3nvk/bHG
	bPTBgvy+eR3UTKsO1MzuxnAm70XPyx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768143776;
	bh=K9SplFdsQ5NNi79gNC7Cn1xWYX0YiWYDAX5ZAyvhZUQ=;
	h=From:To:Cc:Subject:Date:From;
	b=lPYQlMWK+RoKjgWELpWL3sTMvgvqwKLtD6eiTnXt5zONfw+qYErhN/wK2NQ/cjUvu
	 gnWu0w8yB46wyqlg2+mQ3b4npR3D3IxcqxWFxEhjdKsGgqNGYW87evfbVUSd5B4FPN
	 X/5YsNxkvGRmOaPfBO5qTpMTiyXeG9V7x/V5vZPCFWyWKDNe5Lbzv3VTGFVhquduNX
	 SK7/MqSjPvhT9GiRCuZQ7FLfN/3GgKuk2TMQSsifTs5t2qt9Je/9wD6E8f2byKniGa
	 GtBFYe6axmhETXMU3sqlOLec7soeHpNOZTbSeY8xp1EoqaCSoKLCtPNG6RjT16t/bS
	 jWaCDO7zKNONA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dpzJw0Nb9zkvq;
	Sun, 11 Jan 2026 10:02:56 -0500 (EST)
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
Subject: [PATCH v12 0/3] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Sun, 11 Jan 2026 10:02:46 -0500
Message-Id: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4422218001A
X-Stat-Signature: mj9tmw8ndb4demhdkadhuj8r758s84g9
X-Rspam-User: 
X-HE-Tag: 1768143776-429923
X-HE-Meta: U2FsdGVkX19uoIXBe8ypjkpA/sxCWi8e4iJYH9p7qUC+us9sWiLRybbBfRa76u2FyeWlaGHyXyWSSM6FFYd7nmEGNEzH+m9ZZIcZPNPSGl2i64zlnsIR6HHqDEU1OuahZibyLA4oK7u3F1gM6QR4vK5VT3CJj9bOunNEkSxMILizMSEDKJUiXmaTJ8nhwPSTbDraJrOvX6Lx6roTwCr7PZNRS3Wtu+NkMYfvjLhIN11mqgiy261bmG4+uRBEoD6fG76xdODukw7/Qsp//V1BBITmaTEV+/YUg3p/qzABFSCf2wl6bTS9k/zlihbsLrNYn+9Y4/vdOPLTWtZrG+QFvfx76otwOiGfvYXSPDICt+VxtMWz7TaQ4MHuEBRQBEtOSsP748iSHHRHnMqpLZILm6uzQGZV+BzEq8kheOp8kEMR4FXMGRwJePW4cnOxeh0LPjl7i0Vm8H9z85+TZVhL+20VdDiTwquzcUnlc0iqttWGi0JzrMxow0SNsA/HFC39MPHe7oAqtdKUOh7Y2Rkn9bxOemq77l4wCKP2Sq1zs3fWD0YjjBO52jU5r1BV+GmfzyQz60iNHa5SRjdDtHK4Dt1LEY3Qa57T8tu0gJHl4ViPViBBionc5LkPteHBoixbdzYzxvRsUs9IGNpFy51HAJcwpYGs37CDhdLgpYjKOVpbOb41HkEh49p7WTRz6ezx2MvbpNRl5zfZYUqS8uzAAsa3XEnuWhIEMHS5gtqvh1j4n2FTYpJj22fA/8yeAho5nLoSH+S80phnYlZlFu2o3reL5QnYTeYdfgHMWk2/dFDt/AMAWxEFb7AE0KT5ijosbsMLxoYiVKxZowxHQujc4gkQbzU5I3yZFD42xSrcHeirE0CN/gNOYh+AplBluXA9WRWHdqQdRzylrWN1zak/qhgyJ38kPJYk+sXnIIKrwkMYpl/7nLCABe6g218vSsm+PAiRBLVB6u0a8T4l/y2
 FCGXzzrr
 pzqvUzUWyj9pQvW3kcm/azNIW/bBZDqHYFoon0//2NvyxbrmGnWjQaVIS7nfx7nB89yKrNVRHvAwnkKy6RAFOhyx7YxIT73if/uKAGkpc7zDq2me30igdp0Nh2u96uPhQrya9t5OXYpBA+wgPgHkMFhMbIUV2ov1i2/tthRNSzJksMwKqs+x4NdsfYykqY2eeHMISeCQO4ZJ3bZ3St0rmtISZ5gnjGQxAWKb6dzhR6JSgLgbwB9XeGs4fhhrrtWeUiErhk9zCEy5syEkJzua6wsSYVcsgevfAu09O927X5dHSQ5Bu29u92Wsri0u8zaEoZnagONk88u5FPsUyPHxle3Q451N1r/6I3SvLu+mdKnXn3I8nf7Q+UxHgvEAyzvWiu2nWviL2mnFJG1WejGD8mRSZ5gcQuZXjwYSH2hNoiDyFtYZiBKxkZipmm5oErQI98shoKYnCJtu+fU3VDL+e0Hh99NRwrMkSN6+NOJLaVAkr5uQkr5V+MvI9eca4qpUbQ/omHOXHhxsp6QDWhQRg2igOf++0rB/bxuSCTGe0h1QrzXhNVCE9ROK0qRRsSGzOfxt16s2JgTifmLBIkOAPgUfqhYGI+Rh8197UOnLV6GGrgwdgNd2E0E0U687W8GiRMV12bzc+IcAbtCsm02aJLrUt/lsq3M3yx+T8B9riRgQ1GuQYiRV+2F8xAdZpSngUPHxh6LksnGKB9Pv/9xi3SB1LgTfE1omt3Bmqej6/3lhNoLNZ/AlevkHZROsh7wmAtxe/pFw8l3mjrLS8twxbgVUvNR5scM9hgPxHD7uaqu5nDAcCdqp141OHG4QlbCj4xLuqdC+OkEJNbKvz7loSH1mMT6p+ekUbPz6PyxHBGf0psi0uMTXm95M+eGcKEEkaPNjd723RcrJy+6s79lFgyWKItxqVeP0lfxV7l9kKfwcvhXxIncwrwu8cW7ZxVyLj6U1pqbgyFSwPgOyFeuHM+mY8DFVf
 AUQXMWSw
 VFTsys76EYuh0Qo+2TJ4ShSRmAtJcqg0KTser46h0L5rqMfGVAHXKZLZ+6E5FBp0nEw9TD81GiC1rLdYbPox6aagG3iuzov/cePoOk15FH8=
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

Notable changes for v12:

- Reduce per-CPU counters memory allocation size to sizeof long
  (fixing mixup with sizeof intermediate cache line aligned items).
- Use "long" counters types rather than "int".
- get_mm_counter_sum() returns a precise sum.
- Introduce and use functions to calculate the min/max possible precise
  sum values associated with an approximate sum.

I've done moderate testing of this series on a 256-core VM with 128GB
RAM. Figuring out whether this indeed helps solve issues with real-life
workloads will require broader feedback from the community.

This series is based on v6.19-rc4, on top of the following two
preparation series:

https://lore.kernel.org/linux-mm/20251224173358.647691-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20251224173810.648699-1-mathieu.desnoyers@efficios.com/T/#t

Andrew, this series replaces v11, for testing in mm-new.

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
 mm/oom_kill.c                       |  82 +++-
 11 files changed, 1222 insertions(+), 49 deletions(-)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

