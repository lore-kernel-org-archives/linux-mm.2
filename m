Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57F4C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80AA06B0098; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B276B009D; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C4C6B009E; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5D36B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB60212010F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:39 +0000 (UTC)
X-FDA: 85176560238.08.0DE625F
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 170C3140007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=rpdrEs39;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=19kdMNiQwxNu9bc7s+IHFuS9MHPIUiSFua29/KmdJZg=;
	b=IqgGS1UwrujTwrkNSe3PXLUl6rTgdGm5d7skI3bRHMd47TN+E2e1dLCi27ui1sozKQWGGB
	R7e4WrmQEZi8xmUzcNokkxm1rRWPQ2OkVpJ87v1ypJk7B7Q7C/HmwPvc/k8u/rzuBDO2aI
	VO9lakINQEELfi2cJgSGNQUolMt/f+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538058;
	b=2+C6KmZYhZbQ8FY6UYBUpMUhkTzoDMqwyN+7c2H8wMM76vfWj53U8F0KdZwKCF+WcXDrBt
	OzOOq6EePXDtY+eQiH39mqQVVVEgpnbea6NyHW/OfNmHi1YALK6C2VQMsnOvavkunL4fai
	YkztJp5IT6xq3WK/6Ws3RwqywkA3KbM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=rpdrEs39;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538057;
	bh=19kdMNiQwxNu9bc7s+IHFuS9MHPIUiSFua29/KmdJZg=;
	h=From:To:Cc:Subject:Date:From;
	b=rpdrEs39APtxZ6+3S5p+33a/iyA8sRLllVXkbtA+JmzTwH6mV1kw08UFj3xYwgvmd
	 bwXQEkGIVdjWnmjJZ+JC0pJkg2SX+pQmQF8J4VAYNG7f+kvdQIFqemYWAOwtTDWxaR
	 EyAPcGzv9EosvkaaKlfEOyDu9Uds6cc5Y4qc24ULbc0iq8Rym+26lo0up5voR2ls7u
	 aYYxMEZEu7a2kT/s9/r4Ua+tB4yQTXCCWkyo4P3JUy3+WWe+x612vbQPx2CYCsKzZY
	 mg/fZtIN6Ex3AhbGFb1Xb8uq8EKKr3mMnmPmfu1u6TfNNujBNg+RJX9jag9vGAwJA3
	 5YNF0gPYLBayg==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zd19WhzWWW;
	Fri, 04 Sep 2026 12:07:37 -0400 (EDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v22 00/10] Hierarchical Percpu Counters for RSS
Date: Fri,  4 Sep 2026 12:07:12 -0400
Message-ID: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 170C3140007
X-Stat-Signature: 8pz8xm4t3fmygpmsfprp9k739qfh3u4w
X-HE-Tag: 1788538057-100171
X-HE-Meta: U2FsdGVkX1/dcAZafzT/pih9VaCuMh7B0vbRD2Jgoph4O8ulwlJXenwMpCFsmqtc/V5n9utWTul1frsb7ZKccizFKJ93bE7Ab6QQ6HYNE1PaclK2Rvxo7GoS7l9GLzpDtGwSV/O8VrrVhnt53IEYANw4WiFsEIyr+9sspIhHWifb087EVRSZw7uler+pVGK4vwuHcQld59qboIg0a8bz7qnSAvJtYB0LxgFxMpFOBIjrlM7O7lllamSaBY+BRaRVRyhDihFFXx94BWLuU+1o8NGrTbDeLZbmyThZo0ojt1IEC95IqaDeFQ5CwJqqaN96rHqbGgaUaT7C57heArbufoyNNLflmF5iT17lEi9kUFcd8+PsaVBX+UXnr7E9v42HCuJPZefLKCU8h0eX3waIfiMvIHK1rTF5EAQD641kIdioyw+tR9W4vdQIP/7WlOSXpmNmzRfGs+2cOV3/mCczyHciT+7L+8fpX8zlUIxGJzLKtddL3NtLlg41Me6kTM43bsIbHAxrKJWLxWKOXPhE/+RneKsUdB1tOO251Kg0O1eIq6ePRfImKtuBV+Xd8KFe87NVV2msKzOa8bFO8yDq7Nu+AB1L/PgBGiqhPypfAswchmnlbAkkV49L6viUNqDBXGcrniv0WUgtMPzR+7tD8V16JOaWR3BIipHfm7UhJzVUD5VIdycJCaYsoef7CGM5PF8PfrFfW514xtoDu1h0YG4uOV0DtQ82JTmolKk/ZXxgxioRW2flsM1+j8N68Je9TDlQ7UOd364lRUlus12kQunLWiH7iErtv7aYbEtXsUbF/Oud14UaSOndC0eBQpWOHrSd7PoFob+goqGJpObTIE6MAhEZobiajnCDHdpvg1MBOR0C9cROKUzlkPpbcVeiWemNj8pzTGEfTK3B+6bx6huHWgjzj0nXmXzle6asNnBNRWaKUEa34PZLZc6ycCNTbpyocNwtiP4fHXz+Cky
 S81nlWIw
 Ev7YhJN+BcIoZe7wofBPXOgpo8Pw1bN1QRTLIuxWn4mlacy66SlVTVvYNt/04tuqx8lukcRm96jWZQN5w3s9NSf1OGMT79Et3XmoDYBU3VLroxHj1VdoMz0+tTj8whk4nULXebGhLMhUMvAIMrdbwAaHUOBB9h6ad8VL9/uO8nSBKlpOI1cZWgqbzfEq19hmMt1QXrJaTiicXrLulOM84C5moY1yWWrtEMMFF1Ek8Wzkcrvzg5hGL25L7Mt1b9s3Ah42EUoDUOIgZWSAt4ZvxmM2PP4cHkuqWpyPDHhQqtqODbzci2tW4Qr58f1h+eHOnY9MgimNYOBUkLpHWdZt4hAJEMXME3EWmOtTmPGlL77Idkg6hhd4g2U1+YqolNBIK0lT0IYR9FVTzORTum5bbMflGOMcx1TNf3SadjrifOuXhRuOwqZZXg/awlx2RryWAuzGORFKGq+PeQLG/uzB2bf9iDMRSW3/0MKUfJG+mJ/OT+XJ9LsV0IBriwAn7qZIomN3ezokOXEWgBIKLDTXQRyAXiw5N4PhGXxJeCkMtlaEc+dLbkAe/prAXhkB9KjuDD2c1Tpltqu516rvXNpcbJkbYK1S0CIJmNk7JhA+JXi25W4Hm9DJbCfuz0xa5hIuTI12F79JrurILGvMNOjdZrz64zKLKp6xHAxHe6s7Rdh+P9N2zvfdLl65cYoE5hgGnw1Dydzs+owXn/n/fHICemQCaFgIliTrYehiiKxepMbYBS+tK/gY99CB3CaK0GYK9i3hU5nR+kP8K5ZMXqtL3q6okG7drT7uBY4MauCXH/Q2DVQH+j0Keu65clIFG/JSE/zLp4pzur3lCbENjJBQJmrCSN1Aq+odbT1vt+9CUYvacM3vUP7hWvh5v+1WjXqzaqw7depnkkQGBY1hDKzEXjSLvBtyrlgS4g7enLp7GW/d2N+vVdWdUpDbUio2u/Vu/85uyc66zsPoqXm4llit6m5PCO2Ql
 rTQ4cSri
 WlK+mVCagh7I24vGV4gQy++eLioK4hU/yyvmEcH8a+H1bgzZd7JnSOoMtGhZNEYWlWiWAWr4IoXF5WJgyf8oZuJ2WbBEmVaOAnnoKP5IS/dBzQILbBsX7Y6gTcdlHrS35owsPLogzyRF48r9cCSPo76JhcaYhYPN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Here is the hierarchical percpu counters for RSS accounting series
rebased on top of v7.3-rc1. It includes a series of documentation and
test code fixes done to answer a review from Sashiko at:
https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers@efficios.com

This aims at replacing the prior version of the series you had
in mm.

As a reminder, the goal here is to provide more precise RSS counters
through /proc. A future step would be to also use these counters to
speed up the OOM killer task selection when OOM is triggered by
memcg. In whole-machine OOM situations, latency introduced by the
OOM killer task selection may not be too much of an issue, but for
memcg, where cgroups may routinely depend on the OOM killer, the
acceptable latency tradeoff is quite different.

Thanks,

Mathieu

Mathieu Desnoyers (10):
  lib: introduce hierarchical per-cpu counters
  lib: test hierarchical per-cpu counters
  mm: improve RSS counter approximation accuracy for proc interfaces
  mm: reorder mm_struct flexible array to place mm_cpumask first
  init: move percpu_counter_tree_subsystem_init() earlier in boot
  lib: inline percpu_counter_tree_items_size with boot-safety sentinel
  lib/hpcc: Document that accuracy is a property of settled counters
  lib/hpcc: Clarify accuracy range documentation
  lib/hpcc: Introduce wrapped delta helper
  lib/tests/hpcc: Fix hotplug, module unload, and error handling

Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org

 .../core-api/percpu-counter-tree.rst          |  82 ++
 include/linux/mm.h                            |  20 +-
 include/linux/mm_types.h                      |  65 +-
 include/linux/percpu_counter_tree.h           | 391 +++++++++
 include/trace/events/kmem.h                   |   2 +-
 init/main.c                                   |   2 +
 kernel/fork.c                                 |  24 +-
 lib/Kconfig                                   |  12 +
 lib/Makefile                                  |   1 +
 lib/percpu_counter_tree.c                     | 747 ++++++++++++++++++
 lib/tests/Makefile                            |   2 +
 lib/tests/percpu_counter_tree_kunit.c         | 583 ++++++++++++++
 12 files changed, 1899 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

-- 
2.43.0


