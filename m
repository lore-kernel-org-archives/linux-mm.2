Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53DE2D37E3D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEFB6B0089; Wed, 14 Jan 2026 09:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5FC6B0092; Wed, 14 Jan 2026 09:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98206B0093; Wed, 14 Jan 2026 09:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 979C16B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:59:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 657511A02EE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:59:22 +0000 (UTC)
X-FDA: 84330877764.20.D144325
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id D96E21C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:59:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=EgpdmmB0;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768402760; a=rsa-sha256;
	cv=none;
	b=Eh+Obgok8eYo4T+Y7Dmc0xUvnX91Yrjcw8Qo+JFxyFkmXmkX676Wrf400WbhYqHrtSdf55
	O0OTy95Dw1LhBr1z3epE7Q7Vmcayj+IB0qQ4v39PPX/TP4m4wMqlFKwXyWkGeDTOE3k5u6
	Nda2vBkVXjkSlAAeyyJ7UrkiJ9ae3zM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=EgpdmmB0;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768402760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gmDWQxZXl+iq5JtzXMv1UfK4Kj8WDaLba3HxCXNbTAQ=;
	b=no9yeaEfHoxvUom8vGGw87Xc50J3OxnuvXUwNP639wqs359p/WOFBMtUsbU3/qcp2mVEZ6
	MHRAzEOnMFonLczJB6UIRfyLYyuBJFOrwQ4j/11/PYiq1t4eVTpNyulCP1Mx/E7dANQqoh
	TufIM+2JyI5fKZfmqvfLzWHwzCxvJlI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768402760;
	bh=gmDWQxZXl+iq5JtzXMv1UfK4Kj8WDaLba3HxCXNbTAQ=;
	h=From:To:Cc:Subject:Date:From;
	b=EgpdmmB0iMS3s52XNQ4OgK/nv1/dt8wN4bABj6J/VpYqJeI+Lwqj6hh/z22KzuxbP
	 D6VTr8rQAP07R2bVV3x7I8EvA50BSRZK9xTbbr6fZJ0J7gjOgIGDXUO88eKKlcYz1+
	 MbBLEcMlJGKQ/pCMgU+fY/bsJBXBDmla5XwPscX4mBRUZphWBCU4yCnbzrvRyuCrVq
	 JsEvgMAbJM5OQYBYpIhaidMLaCaOpo9DDEnyH/TNZ78Y/DX45AUhiAVF2gCVXiF/Fh
	 KaD6/13uRKUplAwxGTUm6/bKtq7d1jnydfPPube5mmOxltUe7YTZ6/GpBiR6H3lY1e
	 qmCxRnV3dyRnw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drq5N0jGHzkxF;
	Wed, 14 Jan 2026 09:59:20 -0500 (EST)
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
Subject: [PATCH v16 0/3] Improve proc RSS accuracy and OOM killer latency
Date: Wed, 14 Jan 2026 09:59:12 -0500
Message-Id: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D96E21C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: 9uhqip17pqptkpdm55f36x3ond3bacjy
X-Rspam-User: 
X-HE-Tag: 1768402760-333901
X-HE-Meta: U2FsdGVkX1+f6HruuwD8Yaa8TdExH/1qHrXXr7q8fb9+u+BxqzMAHhQ4wD0CBWzo/zeCXoOd0l68+Ej8GclszulT3TFh73cX2KFT+t083lw+qHMwmVEXFNuPQQjXgq1wpUzDTdSuVM/pNGtwA67TpSGiHjprdnvtgVfkN5epnAaP1gvarWLu69y1cUWHoD2Z04WO3TlptyKLWVvtI/iw5JwZKlIMNvSw86psDldTKvj4KTrM18eP2+rxC/pJPjJAKRyQSh2b8mmJSSReNcy69AtDFUprGPSKxrRg6TaBueNkj6EZ7aLOeRcZq8e0roBr7LkipH30NHzrkWXlEIbSwPSMURFJNr4zcpAkFiXmJ1sOoNlBgyasED4vzHymHLGV/nOPFKGZpImBeQO0gZjT9KY/CSQzyjNXmTB6Xw7mE3DwboExn9qqczpEN/JqjeNAhM5MOzrHpX7VVXqrrQuhKwydEgVLGmILhU83eN84OJ5yOQCjMuHayihPBpa1chemPFRzrAgOcJgBIJlUgZC9Pm/IQS8hlmPQvOAaK5I9cRun6BMRX2lcoWiPoQuONSLWhelqtOwFuS66fuTBIUZlpypluF1WlljlqaKTTcG0Oot92Naz3g/TIhtfkRw7SJvrQJi3bf88RqIhbA5KFZzMfLBMlR17qjlyQzmV1n+E68cyVPDe++560fiekwj0v/gKc1c+FodhxqYvl6MgYHxtXx56JFe9jRPxHvNkh4e00PMlBg6jN91iRxx08D5WgOy3XvaZWAd+ayu2fyIyLGgyEuz8ZWNvqhlIOceDyEO42OFQEI5Wwryq4Kkb/GPnQjOB0+NLNnwbmZuSGgVI2ZYnuiNEZfK7LXA6SCtkmxZflXjsV9KaVoWQBR5CxT+CJutwNlX16jvFtcsUy8483G1gMtFMNpfJ7Po8B0cbXaFjvFDnWoCPAo6mhGYPyzHgVZnalgDHQS1A4KViBxqgYRw
 C1OzmFQl
 JcmKifif1AEalbutV/tGYECxwrtFvi0tvcc/JCQ8cFXnq1w0gl3A05A+3c5lbb4pYXtp28E9Felf8lfbJYeoUzIyiuHKRkABzTHL43Jy9M0Jy0mdNJphMkOb2BzrVFCnG+6ubBorFgEc+mlTz2l56tB8f6ZsUjrbl1lZH1BOVUebV3kMROaQ1CHXiD+KFOLLpYYMt0dW9XrHVakDsP7B/WhYXK57xhK5uXCjhisqDV8JldgmzjniA4YTESlRMJdLVVJ1hrqtnQz6zQGrO35QljllfAhl+wqJ+tJngLr/mb13Mc8eFlqNr+vUpKA9bkEMfNAUAn563UoJnEvC0STE7D6zKisdIWVXvHGDZGMOvvLec0ob2TAFIoTR7qrkEYnXpw9oi+W+ZVUdrNYACnt27SEICNPzbBn5KhJ+t0I2/X1Pous4U3yJJsivGFVmA5bEXUU/R8J92mRuNE8SfOYUuZ7SelAs0IjuHmlYx5X68FYsdxyin+vKS+vO7G/ImHOgVJTDT57bamlCfE58VgjhocY5pFMTcWTgGTI/o27BEDEX810yUSfuJOnY050LBRV4YyfIRxn0aJcc8PBflmDn/hCkTu1wxVmNGiZBpx3+ZnEY+V9I7MOWenFxo3OAGkcy7eysgOLLyUzLmptSPMcMQ68qdZbRvAl5Qz3x0RNSh7ik42Q1nA5fWXxsSzarQeMmrkd8Savb2Mqk0tDmEUrqcH0tMTBZ2K/EaPRvk4IeJswWQSrLZ8r+xBUVOEEP4kZOTvOrJTVrortriVSTRmaNp7u2cNOwehjYVNb/wIgV3mJouw0HosbgV7AG+hLXtHDq3/JjnJeRHlJqCJcPIbtdkphK+K9OQASVrzgvdm+7/0RM6tBJYTjqutLzRWD3CpcXouwEu7/IzdHnCReI3kasCrSyfIoAfeMk41ECEx3gA/We13NJLOTN24QxLUaVN3DO0Q6U58/Mxlg+fBGZgdpE7uLVdyije
 d3/U9hmp
 91fQpC3gLNs1hspk4gFxRCUJP9kg2y18zUXl8yXfURHeKWREuLGaIH6KTX0xjVqvuENCxiYiX2m3LGvO6HTClA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series use the hierarchical tree counter approximation (hpcc) to:

* Increase accuracy of approximated RSS counters exposed through proc
  interfaces:

With a test program hopping across CPUs doing frequent mmap/munmap
operations, the upstream implementation approximation reaches a 1GB
delta from the precise value after a few minutes, compared to a 80MB
delta with the hierarchical counter. The hierarchical counter provides a
guaranteed maximum approximation inaccuracy of 192MB on that hardware
topology.
 
* Implement the OOM killer task selection with a 2-pass algorithm. This
  is a latency reduction improvement of the OOM killer task selection:

Testing the execution time of select_bad_process() with a single
tail -f /dev/zero:

    AMD EPYC 9654 96-Core (2 sockets)
    Within a KVM, configured with 256 logical cpus.

                                      | precise sum |   hpcc   |
    ----------------------------------|-------------|----------|
    nr_processes=40                   |    0.5 ms   |   0.3 ms |
    nr_processes=10000                |   80.0 ms   |   7.9 ms |

I'm sending this series to gather feedback. I plan to re-submit it for
inclusion into mm-new _after_ the next merge window closes, so the bug
fix "mm: Fix OOM killer inaccuracy on large many-core systems" can be
tested in the current release cycle.

Andrew, if you have a prior version of this specific series in mm-new,
please drop it for now.

This series is based on v6.19-rc4, on top of the following three
preparation series:

https://lore.kernel.org/linux-mm/20251224173358.647691-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20251224173810.648699-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20260114143642.47333-1-mathieu.desnoyers@efficios.com/

Thanks,

Mathieu

Cc: Andrew Morton <akpm@linux-foundation.org>
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
  mm: Improve RSS counter approximation accuracy for proc interfaces
  mm: Reduce latency of OOM killer task selection with 2-pass algorithm

 .../core-api/percpu-counter-tree.rst          |  75 ++
 fs/proc/base.c                                |   2 +-
 include/linux/mm.h                            |  49 +-
 include/linux/mm_types.h                      |  54 +-
 include/linux/oom.h                           |  11 +-
 include/linux/percpu_counter_tree.h           | 367 ++++++++++
 include/trace/events/kmem.h                   |   2 +-
 init/main.c                                   |   2 +
 kernel/fork.c                                 |  22 +-
 lib/Makefile                                  |   1 +
 lib/percpu_counter_tree.c                     | 679 ++++++++++++++++++
 mm/oom_kill.c                                 |  84 ++-
 12 files changed, 1295 insertions(+), 53 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

