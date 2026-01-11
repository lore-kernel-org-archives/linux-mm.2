Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37219D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BCEB6B0089; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CF96B008A; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528646B0092; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 415B66B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA0075DD74
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:51:15 +0000 (UTC)
X-FDA: 84320726910.12.99C5B68
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 390CBC0003
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:51:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=QoqeIcBs;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768161074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yAwiRqrdAmP8pCSKjbC3edGBSXcyUKNWIDaZWn2p4dg=;
	b=vWXbH1buGvc68v6MLoNRBJUTHxWLZNWhV/XBhlvRPAAFn4x8L3VLzqNADcUTsmAo/HAGNk
	N/inrGVK+RMtC+muJHUe2Mz1Epr089tx2UfdLPnzitB11oRGOjOjtiaS4WXBpAJB/0nUjB
	xouvSLUPkgMxv+SjAGNkHnfbtoQ9Ydo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=QoqeIcBs;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768161074; a=rsa-sha256;
	cv=none;
	b=DplSpQNJI3l7w9AwUqNNVqRMwoQpmgWloCH9Xh1LjCdG9O35X/9meUu11z26Yl/+A+bfPK
	WkDnC4gj7y2ojUq51sixf0ABf47ytvR9EOR3JBgtrfYgjwsdSvxdSYeJIs/bmlX9gIpnvE
	x5/BxkzYYaHm/o5gni4y0cITEuhXkm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768161073;
	bh=yAwiRqrdAmP8pCSKjbC3edGBSXcyUKNWIDaZWn2p4dg=;
	h=From:To:Cc:Subject:Date:From;
	b=QoqeIcBsomscMEWl6UFvKLKSjdGrB/L/u8ilIsfEOdkIUYWJrWKdIVz9b4BM9jBjv
	 s4gz/ukju0XEw9MDXasZfATLQOdI4k26IB262IYchd1Mb1YLy2AfSn0iqeNFN8c9Pq
	 2xzOYAn7rS1G+abXDmrKRIFS6zvSjwUnmX3hjmj/cYbur50XVOXiVAMX1osTD5uj65
	 LaiFvhHdoawj1Lg5LNqHn0bloODuhfQNULHC47ozBADImXuSfnW4kSAUVHpX8OIp3q
	 ZRywuGZdZ39zr8bizMa+aC1jdaHuJHD3rxuuu05OVzarnE0WdEYgPcWZiMDaEqX1tb
	 9lT3YJRHZ1ITw==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dq5jY1Vltzl6t;
	Sun, 11 Jan 2026 14:51:13 -0500 (EST)
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
Subject: [PATCH v13 0/3] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Sun, 11 Jan 2026 14:49:55 -0500
Message-Id: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 390CBC0003
X-Stat-Signature: rynyhupwiife1539troanxezr875hgoq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768161074-947962
X-HE-Meta: U2FsdGVkX1+do8mvEsmP+iIGXTcwaWkATxRcS6fELkLx7gK1gqG9fAT0JWznnjhwLIwvDjkr48o72yQaFwLfK1wM3qtagdqbPgbrrgYdi8Ohm3XFK1qUxcr5wn8DaHZwmGLsJJMTNs6cn5dCuHrRjytL5ktG7Da0TnLMZ494PEY0eRrh26NJ38NHCFE7NnntnGeNUDtv7AlXEnsesjOwlMn8yp1nUKOEhBAEDnLf10zqSGeUBCUj54McSZrWcKmM4aWxzXZV+WK++eVzy6fuimMvi1FD/YxzIfzPULAMJi+48tNGWe/6MpE30QlJ7pYAsjSN9ufLqkEKdEt7y9iwR1VswlCzrK5G1c89pwYQXtK5JFn9w4M1Q2xwyWuUsM7YbkLKm/McauTW+ErgIC4XAlCwYmx/oQyV7gum/5ILUaI1+5StMemrk2qm0EXRJe6hhdyCPiGupZTGv+erGsFqs7FVCH67Oi0N/ADORhx1bfgToycYAs2hkz4dhlUlmIN4NWs0PR56SABrF/N3aX9fSGgKBkewPKNddAcIgqWxvjbCtA/e4NokjXBauHPtaUijcoKnI3TD+8oMbdq4vgzbwL+JVjn5SmOh5JfZho4mix2shvD4DNGPkOK7DDLkdbHJfQfnazVg+t54o1Vop1n7EW4MPSItZrhdLxu4QUj1i6RYw7e0epJo2p+7WCubkz/HephXgPATWlzgFIdLpUw95bI8rZ41m8ng7Ce9qKj965rtJssNgfvd9zftUBG+C1EkaBTnmgEggBms/usgqvopcwp1mEFAnNVg5YPHgaxuPvKCjxTlwnKqNUbFzRGWlbzBgJr2P8b0IF0o1PTy/5nl1jP0avkEuHj//lvKYlFDUzm4mD2Cryh8ToNo3PA3Jib5T1xIz0O3zqhWeFBwnwKjHt96jmKna89HqHjm/i2UzauLBSI2wsuFgxayIelH5lF6iRGq/2YMAZRJyBIVrb5
 DiBqwNuu
 jjQyH4fGsrIfExWYHH84bWIgGXDbxtXcl7SzzRRmGJNUfjX/wQvN+E73dix2hvzdCknTmB+Q4147ncH8sOccesYdlZ3RA8ld39Odjif4s2kH4+Hu5/6gOVreVU7MMpuY8mq54Q4WoTBJgXYHDjhga2SWg5CX45mWAFY9bwFByc/9oWAnCjymId7ZzOXlYuMzGXTqR7Hl9mxerwfTsEGLkE1uzZAFaFqGIWYATTeBSb7ytMsx+ZBzX3tpoBXi5koeoySlzpJGg8+llSIgju/ooXdaCMhjb55PHAz1auE7vCrtGqYxgio66zC2CaK/iTTBEvjUb5ldXHOewSYU04zus9BOlMto1BC8i5bcv7vTib9XSVI1px2gSfLlhM/WRt5DEFp2RZfu3/gY5rkZqyWTItvHwflhhE/OLPFJacc0dUtcpcCtjM6oYCs6iklNloaVRaZnyqDWxNIvGeOHk/HjRDgPmKr17IHQA0KzXRqolNywMFgCurlp0CJ7LOeyZYZFgVeYNwGTX7LPt27KZPgh/yocI84BFqk+/zFEwCbSprpf8KSxnxLSqEXUc1I9rWeSDbNy/nT+pZuU/ZyDdJp9KuPM3/4dd6JvfNAexLoQwdkkFYuFbyxlnXZ6Z2rdZpozK/MuEbGB2W+gKwXHLSQKUi4fMIeTMdxkZaJowPHvJ4AUU0h3+oe6inr+lHX6dq6rcGUqw22UeRl97cou/zZM4lL4nZhP9I0z18uxbmwuX9o8xiPPjUVA1eMshYItLF4z933Obxn9eDYePRDUtQsla+9tgzJB19fCrPIiUKbf99DwZHEWV2hl6j4Q9FP43YEXcDglg6FvuWucUhrkzrMQQzOKpMjRd7eyC8k/NnxvtvKITcQgHgW6ckKAYi4t9IsDJjC8YMGq4rhlMpvk+1p7pHPdCbIsR0p65gtSGhQioeDQtNBpg8x8/+lgRJmfqV63DLiq+yNWVcOvfzmaPRwI26zugVRfC
 Ps+lGk1D
 HX2a34dUpEwHB8ATbVUzLkslEOwxwbKtl0+o8I7sx3fKn1DcWDtsj3FKF/21xNYXsQ+I9YcyjpCj3Ub8gX8guZZ9X73qElCrILN04hJs9rI=
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

Notable changes for v13:

- One uninitialized variable fix for oom_task_origin case.
- percpu_counter_tree_set needs to use atomic_long_set in UP build.
- percpu_counter_tree_precise_sum needs to return long type.

I've done moderate testing of this series on a 256-core VM with 128GB
RAM. Figuring out whether this indeed helps solve issues with real-life
workloads will require broader feedback from the community.

This series is based on v6.19-rc4, on top of the following two
preparation series:

https://lore.kernel.org/linux-mm/20251224173358.647691-1-mathieu.desnoyers@efficios.com/T/#t
https://lore.kernel.org/linux-mm/20251224173810.648699-1-mathieu.desnoyers@efficios.com/T/#t

Andrew, this series replaces v12, for testing in mm-new.

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

