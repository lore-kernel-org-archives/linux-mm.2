Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1241E776EA
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2090F6B0088; Wed, 24 Dec 2025 12:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B66A6B0089; Wed, 24 Dec 2025 12:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B0F6B008A; Wed, 24 Dec 2025 12:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E83806B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:46:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84657C17D9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:46:46 +0000 (UTC)
X-FDA: 84255094812.14.7FAF58E
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id E14788000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:46:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Otzie/no";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf30.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766598405; a=rsa-sha256;
	cv=none;
	b=g7B8+TXXnVinV50DloaNIVhDrm1s6YXCaOA8TpXkHnWrqpJRZGWn8U1xvkADtA72PoncYI
	uLcYl+V884udbroikU6lqPTwaDI+hVTKbyzG37CkxjkXWueqdFHXBE4tLI48KUE04SWMc1
	UlV3BpNgZAe2kL6jKRWh5rnO7qbku88=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Otzie/no";
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf30.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766598405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CszSCs+rrvraiI/Od4kDDjuN8xlbJ+4qU0NWbxgUKvo=;
	b=cF8a83fs8UsArVLcHeGeqX56FHqaT+qFYuBqE9IQEe7hf8KVpGVyptCKtqv/ypgjTkWe+b
	91V/57Wnq//23kdsb7sdgvto/1OXJGv40hc5nrMSKJb6kjgQERoIUAr9pWQDa1eC6T5Lra
	wTxNOombXaXra+zOehpknHR2zVDDQmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766598404;
	bh=CszSCs+rrvraiI/Od4kDDjuN8xlbJ+4qU0NWbxgUKvo=;
	h=From:To:Cc:Subject:Date:From;
	b=Otzie/no3Nt+vPDICcXiUGA87GO4aFmIM478A2tiAhyqFE/TZNo3qvzOs/O/HJ2xf
	 diOeJPWqVGv6GuXp3VwTeaCTUuZgvrN48MQibApgyLFzlSKyDLqrbvVfMHdZYaZEoY
	 73Ych4AlK8LXzuNFzqI1aJm+TOKbgp5MhNuze2yKhQhSX2jsbuKil+pqJ7EwOCWlo5
	 2TFt0Wwg+H732ge4urXU4moS9JiNXpuOEmkoC1kdRLc9pvKcgSoW+lo/Uzd7OS+a12
	 8ajiZXkZHV3jUfPQzdEmGx5iL7iJAkj7668SPJUzYIYuEal3wfhwsxpPt5Au2JXMrE
	 ZuMQJs/61SExA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzpC6kj6zdQ7;
	Wed, 24 Dec 2025 12:46:43 -0500 (EST)
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
Subject: [PATCH v11 0/3] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Wed, 24 Dec 2025 12:46:35 -0500
Message-Id: <20251224174638.650551-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E14788000C
X-Stat-Signature: fop8qr53xhod1bggfgaxw8rh4ztt9wzo
X-HE-Tag: 1766598404-972626
X-HE-Meta: U2FsdGVkX19aTsB83z4VClsc/RLhvMn2Lx7zt/vl1pawu3X7b+KiGLTd0WQHVmIJ9WWcZ1h4cSjmIP3XAIHkZZ7yOE1ooUauS/Ca1vRSiu/ctfofRoZyxpSTJ8msa+b5ANJjo6nwukG4YFpwoSeEgS7HJWB3bGdPzEHFcpzJppo4dlFNRlUok0rBrpeshX3FhxOInlIcc+cVARk1raXchAkijTR+uLvaX7iw5aIuoMUagRH5DXBfpmc0Ol15EmIg0uBOS3nvIBPUdy3lEShCcg/iXuG4x+1tiC4dbdTc/JVxe4B8p0NnTzSIZR4449sizspx41lPG04M6lOX9wfnuIcBc8mE87fAOCzevdgqg2PZ5vs4iJsID6e6EIdAjPVlsaFRbdq9ap+58Ly/NM1GYGsF+APDubtnJksZG5YzrJ7t5iNAsCqt8wauwZt/k2N/6GrahhkCe5MGqaA7TyYKg/CQKoRdrAV5m+ZgFVmpDvczHzzjPsIppqYMEJ7dmjrUjN7zk2fqMxt22EXxErKgvtvPCz/opM4eU1PjeqCSEDDwVhDhWHg4wjuYcEaGmoE5XRGhykfEFIvvzJMuXwD/SslYTIQQrheBI+a3Pt6fuyQQNVmIhjSAYnQpYgHA/S4d2x1rphgKBaTtKKywZbgpM24xH8ULOua2tfRjmx9kPgKxBJplDJuQBbS99IMMrF/wxy4lAvoFFeYuqzm4ZClbmw6L4qKWLqgelT4gg6TAKuxQn2rdVCK4iuXpX/HDV3HepN9pY3paqvMid/7Rd+CATRgUX2Z5YbrAgiOzwPee8BsBZvf91SrHEdl7P5YnZIY6D1TqBU8HPFvZV8hL2M4v/JfgmANtqaXnGrtYoiu4FRS3ym99viPdrcW4loIH0SlcbXgYgd5Lye7xIZ1BwowbPvTu5rb+JthumQgSzWkgwheOLTFMDiMjPBaZTrSTlUDzuYbBoYNyyx2o8znO3qX
 kbjmvpgR
 w3uFoablYpjBoWOjYJ2HHpPo4d4z/8QuUkVT+vN5onNnmbzpvoomfIechdOFHsJVNYTpsXJlelnP4TKBAsB1m06N03zR5RJU7p6If/ghF8LgFlz7QvtEm4BALLBt9ZjJNDXOhdS/iTK+WQBblEde3yhESEiSGepLKZcwOwVVLcWoXmxqRMc78tOV2Msa1p2IfwoK0QmUwWzTQC7yFX/rimJYJuiwUqg1Q5ffiPiztwgwe7UbHAb3C6hPTLzg7baSLVaqpFlz1d75hWi6TG2ETlSIcFGdtOfXHAjlO6z/6PQJqT+aQc6NM9csV6MzS4CNVLqutYnyW6sCZnjMxPp/7BA5enFFxEfWBWfRn+JZjLicwtV9/SOmkz2Oo9MKB163C8IRNiuQe+IxbnvBsRCvi7GvliVVMJnAKBYHumy0NbmmHPJFrmkr8dr3h6J+gN9mEoV/s7StOqkA/hkA5tPvMo+8QeyA0Uladu7+N4WUllGl7Hxxky+segiTUwELdQ4QImxyp08wOUVwQ6jXXN1tKSLuYExw2ls+S4kfkJcFY+cIqU1N2yg1b36rRtuQD7dtryTYyS9s+oFy1gRga0bHCNRhpoNzxJcMuQqwzSuwPLYKho5XK0puHI17Sp/LmYI3BO2vou89T958J3KyF8eY3FSHl/WqfBFykpK1MoSOS1pfAVxm88WRxsYrtcD38GPI+zrFcVokmf/f3TYKKczI0KgOfZbPkCMBbQuAJvm9Bjb7AvlvA8M8tyXNz/0cufSEv9br13UzGt48d2+bLPfBv02AGaQ6zlHxnZD+6i1zYRla0WWC+4i5Hfe3MXy9fv6rttumzdBZMfKCrxq/HR885MtlPa3DQMLra3FOVgKChvot0s77rF+EFHhYOhkaaqF2ThwMTf0Kdjmi/uCvgJGi4XyKbOhZFXb3DoSGN7lo2pioT4pH7D2QhfvtZ8DcF5XipQjiuNJow6YgregP7pp9t4SkCMHAQ
 RXREFupm
 PQzAhT+TCGGfDO6kpO1WgohgKZxf0RU6nTmldWqGVZYUyex9yvrWR7zH6QGfIMZr7UR7DKcqsbcWKB43DDGsgA==
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

Notable change for v11: Rebased on preparation patches fixing mm_struct
static init for init_mm and efi_mm.

I've done moderate testing of this series on a 256-core VM with 128GB
RAM. Figuring out whether this indeed helps solve issues with real-life
workloads will require broader feedback from the community.

This series is based on v6.19-rc2, on top of the following two
preparation series:

https://lore.kernel.org/linux-mm/20251224173358.647691-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20251224173810.648699-1-mathieu.desnoyers@efficios.com/T/#t

Andrew, this series replaces v10, for testing in mm-new if you're still
up for it.

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
 include/linux/mm.h                  |  58 ++-
 include/linux/mm_types.h            |  10 +-
 include/linux/oom.h                 |  12 +-
 include/linux/percpu_counter_tree.h | 293 ++++++++++++
 include/trace/events/kmem.h         |   2 +-
 init/main.c                         |   2 +
 kernel/fork.c                       |  24 +-
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 705 ++++++++++++++++++++++++++++
 mm/oom_kill.c                       |  72 ++-
 11 files changed, 1143 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

