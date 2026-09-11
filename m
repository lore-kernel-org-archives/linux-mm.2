Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E2DC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55EBC6B008A; Fri, 11 Sep 2026 03:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FB06B008C; Fri, 11 Sep 2026 03:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD1D6B0092; Fri, 11 Sep 2026 03:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15CBC6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:58:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E39CC0132
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:29 +0000 (UTC)
X-FDA: 85200729138.22.E0D1834
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7825720004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:58:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=czgAtOF3;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wOgTCEbQYAco9Y4McmPRaV1mhNoWht7hjNtbhEmX5no=;
	b=8dkiiClEB+zfA95uTG7lLCYzEb/t2cXOZNGAi3Q4/2QewkSFR1/lq8RztP/mYITV06Dl/J
	HC8RP/KURrtCimaPaNcC9tWbABR8wD3u/ue1e0LVNZ3ZL2ZvbZYt6dPJDB6ziIKj2g0XBa
	nC5oq8x2yfy7G0KS3yLrRMrdjJpHe0c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=czgAtOF3;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113504;
	b=8APpVgif2L1/DCLdbmI7EIasbPyKrRVo6aIHquMhyWZYOCSJO3zjg/txT0ng/P2JTtHtoK
	5KBUAW32WLngI48vOnBlfyRLWBRPO14v9qCgdkSZ6uLt69rdiXTxxfnLKBb8/CgvvK2sne
	/jbe+ofqt0VJkAKa4RKRXK10cZFhBxs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2z6K28VZFghAvaOC2rxcV8P37YjNcXnY9WqrSWMHQ/k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113497; v=1; x=1789718297;
 b=czgAtOF3JlWxuaKbHd6nJn+3vEEx++yytKytXfhgizpNlKXoBu0iIPbhZbr1uCfHrYUvkPQD
 pkP6XMVK5eXLDp8cDD9X27POKFZ1M6XVUvSlRcXc7oWwe48CfuZxUSc6jmc7O3rXoKS75h0w7Ex
 c/9gvUSCt+YiV0IBUdtl2XfQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 08c4df989fc31bb8;
	Fri, 11 Sep 2026 07:58:16 +0000
X-Mizu-Trace-ID: 08c4df989fc31bb8
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com
Subject: [PATCH v3 00/15] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Fri, 11 Sep 2026 15:57:45 +0800
Message-Id: <20260911075800.491472-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xgxojk66hjqf8sy84j9zm3w5hngunbow
X-Rspamd-Queue-Id: 7825720004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789113504-188800
X-HE-Meta: U2FsdGVkX1+twHBVTVz8bz5CNYpN2EDIYBe1gPkgO4gBKv+SKFSQ2XMeUlG2yncfzhtlhYz2r8uuyEI7S4qc8WtlYl09ucg6rQxzLypEXGc4N3lKBJ2wce1ZOCqhzXgsXBrx6yI9UdSJresdiWWxpoQid3vkDNgeTb3FrIpDtzpUWabpEA4HvBmE6ftOh7mX3jdcRor/LSStA44yapbLIGTDHJHxyG59ajYwXmXDHFscGVTXjMOkDu70y3v3YaGUZotUBnMX/xF+naK4KiiusGSZPA3Z5Cc/nmrt/9seyM0cFwtDSnMD/xBmMq5mV2Mi5gHiF/+UnEoI5u5R67aguoBjiIjdO7M7H4jdoSHpJt1/eYgPzalC24wsUsBzA7CWutVCv/dP9vUPnOggqn9YdTEO4F8pBHRb/KRBkuKDksnveKQV5oDMZeV/8FCQv/NNguEPTtAHzJjJEUe4YewgI1ucOjUk8OuGRptXtwWfBOgTULIhuiW192iJKSZ5adprf9V1bm7KkLXtDWbjo53pSSIsUmstpbwDmD6vMHsskpyT+0iFXisTe5MKzBEK/MMcOJ1qjgwnKdT06NnaujxXugzcdWvAyHH3CnO2Ez7zIbqKXX4GzH9zAJ6A58U+IeJvKEBvH7oaXH/EjLoGK26KD6YRAiqR0fHNfLMVumUBhboCpzmKH4M1hBDoaTuPov7nkIKQzNpeN+RpPHFEwNebcwz/Iexr6rZCCi+hrimBzSmDQofmJymlP4DnG5egjK9o1Qw74u5AVXOJoO9bhMTPkhgKq7J85KbBDnMgMLlzfKqX9g+LqJlyiwtcLoXv6ze2Wh0oMtLLF/zC3DGWfSpsp1UnmzbfKzxgO1P9B6nnZ0bPlhrsD2YMek2NinliR9EccbvVrId+6B9/grRxGkY5hOQGrbnSQ8OuigLNncY0OXFlTMOGFKhCoODFOsuB/clq3bFJ94lM3xmIP+5aTsF
 co/4JYSR
 qaMy9CJshGMZ6WMsWYSkow94ogoZ7uJF5v/t+/e1L/MMO+VT515wxjf/skteD/0aEsAJBIkQqooIfsnH/kfXLpSkfP3+yRFcx9wwx4YFKZA3VOWNSm7CJ4CLriMZScPpCBjqFfA6CweT1xVz7nVCQOQmOnG4FgGM7nr9tUe3ZWhhdfNNdABgfoPTmzb4QqdaZFgZFzTIfETDLrWKWVJ4n7VBKqsCaBvhdTpqm0m82qzZqiJkYUt/XNsxJDBoQHxnz+LA83A9vQDmZl9z7wKFkcmejxWZOc0GLASP0gi+Y5+s69iusxc5FVp4Ub4SFTdMSq1S122f1jNU9CvFLiDbAUWJvDKwR+r8JZjPA1/onyYSptG4uuu2fcOWs9eqX6coY7alVHtnsp03GFMuowgqmxEMfyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Introduce for_each_process_rculock(), for_each_thread_rculock() and
for_each_process_thread_rculock() macros that combine the existing
iteration macros with scoped_guard(rcu), so that the RCU read lock
is automatically acquired before iteration and released when the
loop exits — including via break, goto, or return.

The rest of the series converts manual rcu_read_lock()/
rcu_read_unlock() and guard(rcu)() pairs across mm/, kernel/, fs/,
lib/ and security/ to use the new macros.

Suggested by Michal Hocko for the oom_kill path [2].

Signed-off-by: Ye Liu <liuye@kylinos.cn>

---
Changes since v2 [3]:
  - Split the kernel/ patch into per-subsystem patches, as the
    combined patch could not be applied (Peter Zijlstra, Steven
    Rostedt).
  - Move changelog below the --- separator so it is excluded from
    the commit message (Lorenzo Stoakes).
  - Indent loop body in macro definitions to show scoped_guard
    scope (Lorenzo Stoakes).

Changes since v1 [1]:
  - Rename macros from *_rcu to *_rculock, as suggested by Steven
    Rostedt and acked by Thomas Gleixner, to avoid confusion with
    existing *_rcu() list iterators that expect the caller to hold
    the RCU read lock.
  - Improve the comment on for_each_process_thread_rculock() to
    document that 'break' only exits the inner loop and 'goto' is
    needed to exit both loops (Thomas Gleixner).
  - Rename the stale 'unlock:' label to 'out:' in hung_task.c, as
    noted by Günther Noack.
  - Clarify in patch 4 that page_pgoff() is safe outside the RCU
    read-side critical section (SJ Park).
  - CC all relevant maintainers on every patch (Lorenzo Stoakes).
  - Drop the mm: prefix from patch 1, as the macros are in
    include/linux/sched/signal.h (Michal Hocko).

[1] https://lore.kernel.org/all/20260904083001.553587-1-ye.liu@linux.dev/
[2] https://lore.kernel.org/all/20260813092933.562028-1-ye.liu@linux.dev/
[3] https://lore.kernel.org/all/20260907081334.1152889-1-ye.liu@linux.dev/

Ye Liu (15):
  sched: introduce for_each_process_rculock and for_each_thread_rculock
  mm/oom_kill: convert process/thread iterators to for_each_*_rculock
  mm/ksm: convert process iterator to for_each_process_rculock
  mm/memory-failure: convert process iterator to for_each_process_rculock
  cpu/hotplug: convert thread iterator to for_each_thread_rculock
  freezer: convert thread iterator to for_each_thread_rculock
  hung_task: convert process/thread iterators to for_each_*_rculock
  locking/lockdep: convert process/thread iterators to for_each_*_rculock
  rcu: convert process/thread iterator to for_each_process_thread_rculock
  sched: convert process/thread iterators to for_each_*_rculock
  tracing/fgraph: convert process/thread iterator to for_each_process_thread_rculock
  unwind: convert process/thread iterator to for_each_process_thread_rculock
  fs: convert process/thread iterators to for_each_*_rculock
  lib: convert process iterator to for_each_process_rculock
  security/landlock: convert thread iterator to for_each_thread_rculock

 fs/proc/base.c               |  4 +---
 fs/resctrl/rdtgroup.c        |  8 ++------
 include/linux/sched/signal.h | 26 ++++++++++++++++++++++++++
 kernel/cpu.c                 |  4 +---
 kernel/freezer.c             |  4 +---
 kernel/hung_task.c           | 11 ++++-------
 kernel/locking/lockdep.c     |  4 +---
 kernel/rcu/update.c          |  4 +---
 kernel/sched/core.c          |  3 +--
 kernel/sched/debug.c         |  4 +---
 kernel/trace/fgraph.c        |  8 ++------
 kernel/unwind/deferred.c     |  3 +--
 lib/is_single_threaded.c     |  5 +----
 mm/ksm.c                     |  4 +---
 mm/memory-failure.c          | 16 ++++------------
 mm/oom_kill.c                | 20 +++++---------------
 security/landlock/tsync.c    |  8 ++------
 17 files changed, 55 insertions(+), 81 deletions(-)

--
2.25.1

