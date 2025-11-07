Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B069DCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158138E000B; Fri,  7 Nov 2025 12:22:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105618E000C; Fri,  7 Nov 2025 12:22:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE218E0002; Fri,  7 Nov 2025 12:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8E6E8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:22:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58382160554
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:22:26 +0000 (UTC)
X-FDA: 84084479892.24.07F1CFB
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1717C0013
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:22:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=ODiVoDZH;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762536144; a=rsa-sha256;
	cv=none;
	b=hcOS3UT9PMOELsGYSXEKe8vGDA/YJYl46IRQAomiKFe4ntjlZZYECUxPwKWmthyuC3yxtb
	uyvpvhX7kLJZ6/TTM/Xo1L14OKHySRG3DU3q3OuSexH3JA/QC+Vk34pr+a5C8f+6wzQo5a
	sICdFLWO07OzHKZY6cst5g7MGSucWUI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=ODiVoDZH;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762536144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wcANZRjMX6eDeb9g7LnxYqx3PUgZNlqK6yxyYeMGIZw=;
	b=jkWs38TvkW0n/EJgerMbf98Xde/GNVc/XXfyPpPbBS/uCXnNt3UbCm2lYhtLFZnG9VpfHT
	Crqpu+MW2rvHPImdOK5Kb/P4vL4Vyy/Fzo9/Ujh0rGWmy82A028KT6vS+Rc1vqZGryZt/q
	23QcMxQHewET30bt7aVJghdydiOZP+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1762536143;
	bh=wcANZRjMX6eDeb9g7LnxYqx3PUgZNlqK6yxyYeMGIZw=;
	h=From:To:Cc:Subject:Date:From;
	b=ODiVoDZHi1ShVyo4MfksyRzqOOGsV+QFDx9HmO2x0gJAku4KgQXSlfV/3bCIm+Rmz
	 w+sAgGUx19M9VBk2S/gib9z9Cs9DTYzAVB7fU3DFMCdSbu/S+ycLP3ddMFq5vvJmgz
	 rlAKyuypbjFbmpxY2+/8ryaNqrIfOV7WczJfRGaSbdaXUhjl/tLW66ulphgWoXzwmJ
	 cJfBJdIEU+DiUV2CmtqgJEa+kaZg10AryGai/xuXrw97OqPzWLf0vFgGPB6cdNm8h+
	 YsTARl4pJ9ZTglFho9wqBxUQ9Khjsz/Imuygqf8Z9q4jo4WsALDv7/VthFOGnrv0Uj
	 6+S4vcLTDwyUw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4d35Tq5MmHzHX4;
	Fri, 07 Nov 2025 12:22:23 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Sweet Tea Dorminy <sweettea@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH v8 0/2] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Fri,  7 Nov 2025 12:22:14 -0500
Message-Id: <20251107172216.515754-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D1717C0013
X-Stat-Signature: 3itz5odqy3t9p67frhphcowydkraneda
X-Rspam-User: 
X-HE-Tag: 1762536144-583263
X-HE-Meta: U2FsdGVkX1/gBmPWYPH7UKMvz1Jme35PBMX0U573sFmrsJv9fUK2m5v1bFJ2jHYjQpVAMwnY0z97Z9qodA12NbkorGxyTXU/kJ3MR3JkdnAjv7U5+7kUKPREExZBjMKNwUiN9Nv/aHRgPKR7Z5lreEfiUNhVedKp8mVdqUbtmcgLQQu9sSEv1BfT9SF6yCQx8YxP2PUaec4jDQgGJsv47dWHtuFw8Lfn2qFqfOs3MKyqCsz1vQ83q4U4HBexXx/0wMwjqD+kjDs9aKSOL9hAkNAe3JwOoIq/U9rJO4cniHGHCMe4/vpMevfS3iMD+XSdNUfj0d/WYlBYQoIyXbdyrCHcw8L5WEhi6tZ7Z8zI7BWLKVldhCr2vlPIjm8r3ODug4wQ0RhWg59etLfW5MwOqHgNrerI6cVovYG8iUT1GJYTHqAqqB2uRk00q41lvchQS71WtgJlmZO+aFwBK0+G6leT33Bxp2wClbHrJHpYjsMXYG66RfaDrbvPBeztPUcnJK+KUEWphx7Kcts0qOQUuO8mt3vG/6yKNBjUOgav3fgYTfcBo1P09/gvUuunG7DEwdYpEHHdUff275tsQFuLZz+wAUtVs5mbjjXrNJ+c/PTbz/4TLrqPW1LzqegH6105RyJEKtoQCqIUO8UNklbu+tdO8qOAWn+eeYfeeEODAupD7Z0KE3FAkQk//cDo6SwPgKCeM5+r54YHPYM7q1ZbkxJXsGC3lpwSOhAnNhHGeNd0wosmiuiCu6gzyNnHqUsfA/H0aTp5/54qzaPD4Ik+g03fPvPGkz20m8RHQzyLgCiXFL2dIfAUmx49kAEjQ04N/zOPImqh0R1P9MSGaBgJD7dXcxituuPnW8RBk5EH7R3+nQM5/RHrYQuc45cYlJhWuGK4uvuODJnn3ukbHvKKkdEOO1+AAoefun9jl0qgTN1syl4sqAD73LBhl2SQQvxQj/bJeAxliZyRwK0I8Zt
 tjGFK0Br
 sP2WOxK9UHRMin7ZW2LjyvdAbH4cXZMWbprTjy/xB6c5rugcJ1bbHBR8WNjUNcWW9LlgpkFuHFedwnLc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce hierarchical per-cpu counters and use them for rss tracking to
fix the per-mm RSS tracking which has become too inaccurate for OOM
killer purposes on large many-core systems.

The approach proposed here is to replace this by the hierarchical
per-cpu counters, which bounds the inaccuracy based on the system
topology with O(N*logN).

Relevant delta since v7: Initialize the subsystem earlier in
start_kernel() so it is ready before any mm is created. Introduce and
use a precise sum positive API to cover the scenario where an unlucky
precise sum iteration happens concurrently with a sequence of counter
updates that makes it observe a negative sum.

Testing and feedback are welcome!

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
Cc: Sweet Tea Dorminy <sweettea@google.com>
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

Mathieu Desnoyers (2):
  lib: Introduce hierarchical per-cpu counters
  mm: Fix OOM killer inaccuracy on large many-core systems

 include/linux/mm.h                  |  10 +-
 include/linux/mm_types.h            |   4 +-
 include/linux/percpu_counter_tree.h | 217 +++++++++++++++
 include/trace/events/kmem.h         |   2 +-
 init/main.c                         |   2 +
 kernel/fork.c                       |  32 ++-
 lib/Makefile                        |   1 +
 lib/percpu_counter_tree.c           | 392 ++++++++++++++++++++++++++++
 8 files changed, 641 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c

-- 
2.39.5

