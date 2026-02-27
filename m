Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5239FEFB5E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DC56B0005; Fri, 27 Feb 2026 10:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB5E6B008C; Fri, 27 Feb 2026 10:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4AC6B0098; Fri, 27 Feb 2026 10:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89E666B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:37:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 424E513B8F7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:37:39 +0000 (UTC)
X-FDA: 84490641438.30.5DC2A22
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90AFE100005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:37:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=QMHLFA8U;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772206657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9FzERZOw4BS/qsQeVuofTxgYvCh8L3A5wSs6tnpu+HI=;
	b=ACiGGXZfZWJvz0S0Qoz6dB1NPhZy62R9s9Q+AEQ9/EENN9aCK769GtpAcnt7Lii/lnuy0a
	erY6Mm4ShNZanc5/RZ4Nda7//sXL5c1hHT9eywYOSvRUQPzcFZlzUnO6Zrcxhgq1ZE4EMq
	kfTqUpn6ZhEiVoa3v8FtSPhW1MhTWPk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=QMHLFA8U;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772206657; a=rsa-sha256;
	cv=none;
	b=6pZRcew+URGOmR10GnrfEuQjnbeePnKEeScH9zoRWVZh+PGnht9QzD71WoJ8kGd9mZSJPM
	dRb++5qsG9B4m7QEIVRZxvMEC5X/rYuVYTulepDLYVz+nBx9RNJAEuorShuzLXfvOUNJRe
	YBLDiGKxXrrCSW7nYhiHvHAXBuqloOQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1772206656;
	bh=9FzERZOw4BS/qsQeVuofTxgYvCh8L3A5wSs6tnpu+HI=;
	h=From:To:Cc:Subject:Date:From;
	b=QMHLFA8UAdseSJWA+md/FvYuNDIJQ3lNdNBHgLQ3wBFeovfETUv+ev1bfYcvuin35
	 VwnVuUFoj/D92Sb9pQga5XPLxqmfN7q2slrBask0AXvmtKMnzwF1n0CksVXGs+fBIU
	 4u7bW44PFrb7H54b2XUCya/33rEoUgwAUAO/h/3UxkJuVKLkvX0PqPq0ECxf3TeUSI
	 OuAUmNGQJTwQShuh0wgH8l1RzV/SGBP6WUM4rg97jRqcSR1bwSACYcfXAwiHoOP5ZW
	 JuyS3f5epdYk6PKQnPmn0iRKF8+7xkabufclZCpgx6jqarS0igGhji6Y/yS9Py7Kdp
	 36Gd6lVEPdzCg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fMssD4BkMzKM1;
	Fri, 27 Feb 2026 10:37:36 -0500 (EST)
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
Subject: [PATCH v18 0/3] Improve proc RSS accuracy
Date: Fri, 27 Feb 2026 10:37:27 -0500
Message-Id: <20260227153730.1556542-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90AFE100005
X-Stat-Signature: x7fygau6x86hjzmazzaiiyt7it77hdq7
X-HE-Tag: 1772206657-949732
X-HE-Meta: U2FsdGVkX1/9ZQWAYLHoUFZkOnJtm7uXLDuYFQjEQNKILAhtQO+P2GkB8mG6YAwNJo+tgzWMv0iooYDQYToV6zvZ/GS0EdcfzHz/Hq1TWVUpkuuKgfEe6hwotiXZGoN8s44wcVfejc4xSMPJwujhLNP4x67cV8Ej0InfYCmU2o3oDw+SNkrZCcbmIWZVuhoZCRWEs5UIpA/cNAWHAbrLUcbzW8bOfn7rcGJTPnzkgyWMHPb3i5+2c3PnvAfwj68IGoCZgK+rtTyaudtT760mqzL2+qQAXXuACwKHPJvnIKLV26LC16xTc3VAk1q+lAkUFK5mNNWpAXDXHcsLcWQ7scQl8XYJJvYEx3ATUkdsfBjkfhpGsaA6wythwvd3wPic1Jc5K/NTarM3Uzbk4VpZibqBnPaFLBLkw4dAvpW7eZVJEM+GEoeuwgAbPkUzI/5VhuwNUPXvQdqGPH/PMA81IBBVwuh2D8aRUrm1KHpYp0iymjuvogFC5ZnocRGVhcLREMG6j290XRx1K5ZnjIO5vKXlT9d/UYiOteb+/pM7+Nnk56k5ws5jmqKTd0Wh3MIuirMjq1A3AfXCHklod/5PT8NW9sN5cJmJVnrmtD2qSJHqEnAbuutOZAxXRxka6KtYk+J2kktrE1HL9RcRztuXw/T2i8NMIkMrqv0cebHasdl5H8FxLLrLRrWApardUUcXZJ6Q4o2HQGq0Vitxd7Kd0YaFCMGTKRpQkbqkaNGmMvfjxS9TkRgOGNAGB+84l9LmNPy7Hf+QUfT17HO0+QaLrrxm67Sxb8q9a01hCe3Hte2Xqe/UsGG/MLn/8PmzkGPj5f0cDghnS8l6VI/WUsfucrJ0Brim6M79gn/lKh457pwMfHSuREvTGiO5E8ucrNIv37foxcaA+dBKVHQaEjSXp3T95GMS71jrIVrvMQA3sGIQfsKMxOXecb6rt02nHKf6dMI3xNj84mCI6/i1MXU
 GJ4vkJLb
 wCFDTuLCQiE94ECY8io+bPAfdLOjg9AHFoE/YyaHtuLY+HrDfuGnc7n0FZH1VBBf/91T9jpALVBjkhPghzQwI4xw0cNx+fX44hVy1UOTtERRKqgWfIDTp0WDcETi09HpJe4gJrtO0/P5Divs7FcX/C2Wi7+IU5wCjpiG8DFSv5Lkcwh2RTt3ToqBM+4LQDI3kQNBDJ3XSyPvDmP5qec4rpqnqQ63QOnoNcA44IFU6APTACyAwj/urELyKhXEff7cE6DURg9U20Y5+W5ffLKW23TYRt/z1nudtuGO4hvhFwptBlpnbLIltwMh9FF4tV6UloUjkz4ZxHPHsKVSg9G5g3Z+Rk8IfFrtaM5WPO4ICoFykX7fxPBBBXX6Xi07tSCoWHNrB3AivkpZsi3FRwpmMgjw6PJJFWG1ok1HGEyPLj5JtEbK9McsiKJS8TZfSO6XkbsbKaysBlMDKdp/44URQk/fjOhzsPzUVBv5kr+KFNtzFJj+8a37pBLwWnk0F4N+4psiaETC63cpCzsKIWCGINHBqd6OH1BAlRHsbWYn/2FavQFXTdXvMyBK034Vnl0rHleO8Da22pYsvMUJwqhBtpYVjwYluhukuL+1C4OstCkLS7pG5jp6yLo6e+U9azXgGF23HxO31lAC8PcGWcNGf4mhHn4bGK7nifP+t0wt5aY4pkcXH3B1UhUEFG1N0+iDwdJ3fxfMEqNn8OPll+k+PlsPD8gNOOXtankrFyxjGEwab0EWYDCBiOTO5dphlqWGSUuQMo82me9wTucPxmebnKEdlQ9YFqqg3uCY1A0OSxDHCY4SFXeKH97KJEVRdHXbmxk9+r0xqrgMrAxt6eNfV2uVsfsD8F7JW6vL6rWWDTkXc6NqQ8UaoEAX5KuJfKKocgIG6/CHTheIpDo4ZmjOGrIC6zTs/KpVouFeZtYGXD3JoCG1ogEIl7kbijJSahxsnowavonYDzHgrVSDucUdtKlGKc6uc
 UErziMmf
 t7yzR+fdD5NLGDZZLVjCp7uR7g8Kss8zu0NmnjPnSFN0/jaRCTMC+qLWoeTjvwkYTrV3Dz18ED6536YEtQKKQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces the hierarchical tree counter (hpcc) to increase
accuracy of approximated RSS counters exposed through proc interfaces.

With a test program hopping across CPUs doing frequent mmap/munmap
operations, the upstream implementation approximation reaches a 1GB
delta from the precise value after a few minutes, compared to a 80MB
delta with the hierarchical counter. The hierarchical counter provides a
guaranteed maximum approximation inaccuracy of 192MB on that hardware
topology.

This series is based on tag v7.0-rc1.

The main changes since v17:
- Fix patch series bissectability.
- Export GPL symbols for kunit tests.
- Improve kunit tests coverage.
- Fix kunit tests wait queue head reinit bug.
- Fix an out-of-bound on bootup on configurations where nr_cpu_ids is
  close to NR_CPUS.

Andrew, this series targets 7.1.

Thanks!

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
  lib: Test hierarchical per-cpu counters
  mm: Improve RSS counter approximation accuracy for proc interfaces

 .../core-api/percpu-counter-tree.rst          |  75 ++
 include/linux/mm.h                            |  19 +-
 include/linux/mm_types.h                      |  54 +-
 include/linux/percpu_counter_tree.h           | 367 +++++++++
 include/trace/events/kmem.h                   |   2 +-
 init/main.c                                   |   2 +
 kernel/fork.c                                 |  22 +-
 lib/Kconfig                                   |  12 +
 lib/Makefile                                  |   1 +
 lib/percpu_counter_tree.c                     | 702 ++++++++++++++++++
 lib/tests/Makefile                            |   2 +
 lib/tests/percpu_counter_tree_kunit.c         | 399 ++++++++++
 12 files changed, 1627 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

-- 
2.39.5

