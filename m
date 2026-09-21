Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9457CC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F24B6B00E1; Mon, 21 Sep 2026 05:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA036B00E2; Mon, 21 Sep 2026 05:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFFB6B00E3; Mon, 21 Sep 2026 05:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47E3E6B00E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:21:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 853BA1605BC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:21:28 +0000 (UTC)
X-FDA: 85237226256.01.7576BF7
Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C2AD160005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:21:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bPUBDz2V;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hFkh22aspQ2MZ5yfhbllnB6ZpJeyVgsBFDz/axc495I=;
	b=zxqWAtfA3FEdFHngHjugPsFoJkJxY6MZCP8ZIa//GKS4IcZdrGKY2Gg0d8Z1CqVe7rh4yA
	Lm1/CBmkYFyqp/JfO7LoGDJUDF4LqTsR2a2UGdsi9BltakM6eJJDuEmMLLHjLpQI/yVMSb
	cHBo3dk4ojkR5/GuX7hroTwROoeZN1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982486;
	b=sp81qfcmNuFPyOiB3QFRzKdadetZ64BHa6+laW/kUdXWAS4x8iCwqgkcOpPz1miflYoUM+
	wBbTyDEGUIDP3Ty3+gYwniFBI7p0XaCVgX7uQKw8TtXo+m70aCJL/zjOkrrHICp+fb8gIw
	TsuBe9BwCFm9qBox+ipDFDa88649Xnc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bPUBDz2V;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SoD6rbNlmdBhL/S9+WOTUPuzd+nRVogzcLA/JJFQNZM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982480; v=1; x=1790587280;
 b=bPUBDz2VIyGxyOartNajvdI+c+JjY7hBzrcjVlofzPUL37v9FEcKoJqURJ+2UuSja2hv7j/h
 PmlAHbUFkOIMZTdyjDVpYocVAyStm7FniK73fDL63jeUrpUu/tN6Glsm7osTxofWvzw2iwtdgsy
 UEvtC8siMo/2TMxAN9LtXYvg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b70590be7f446065;
	Mon, 21 Sep 2026 09:21:19 +0000
X-Mizu-Trace-ID: b70590be7f446065
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
Subject: [PATCH v4 00/15] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Mon, 21 Sep 2026 17:20:46 +0800
Message-Id: <20260921092101.89285-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C2AD160005
X-Stat-Signature: ocaj75uid3denrtrmcraidz8m1rx7cq9
X-Rspam-User: 
X-HE-Tag: 1789982484-69150
X-HE-Meta: U2FsdGVkX1+S3RsYEVn7HDsWXJx1/ykgc81wxaqnk9VCI781tplqOvjCxSEZtOE9qZapA4ykb3snBl0/X2yJXG5+LpLbP1rSrh+cYz3GSqdUftgj45HhLIgfJ3i8xvH6uESkyjAVb959shYM7uEz2ZMMYe9vCDQ44LLrdRCaVB+zexXkfX82viYGSwfK9QioH+QUppNuQf0xjaI3rNOaa/SOEE6wZNyAQMAVLsQNMUQnrCHsfXZsADlZH0oqT4eDAonVcCV+G3cDJYDdVku8gE9Rsqz6YQuQtklhOFrPtEoVWbbj7n8rO/L+x+OHZB7EFNCa542oq8yXR/JwaNfhcbYX+CINTB/osP3N7vp5mrGqK4GaqU6JXzh0mqfqjgs1GtrKHWxqKZFxboT+ZwvdZdeYBfWxTD1YXpMR5dMrxN5m/343tgmLftQjZdKAP09eEHxLRv7DrppXVrXWLuquDDFmETkmzdaG8TRc+uxUg2+Tqtu+5vrD6SKv8hMEBzHaOSDt4dKhaEgg9Y47VxmP2uQu8g86jSv8qc7tbajHD6nXM3mhgx7vO3iMqywAiBiOoK+xdfsdPrf9sKvEDI+brWLLdZXOV4u+KpO2JRYbPxAn4eFU9k2sWrR/rjLwgpeqIGHE7J8HeMoypzyL7R9t7NPDMYjSyC/Q89AGoRuhGJIuZT9XlYYaLKSnDaJdd2YBTCGjBTcqiphQBBunQCsoHQ8kcYBs9ahYn6Sb3c+J10DRaD3vzcsWSl763bwfT7Nhc+sQFFo/0vvFn64Lz2eD6SSkBO7VeXm9RsmLn3nHCgwyTnWlGP9tK2bcv2QLH/zKyzTYXO1+XpGNL6zmwKeepQ4/locEiKfJeuYYvoLW+V+c4+GJFe/NG5Yq/7Ouh2isedf5w7P6l0GaafGrMU/HsZFNU10c4x96natQRMFp1yvZr/buIjCEaLotI3IyItu8ba/N59b4/Kfc001h7pQ
 Q9Y+gBmD
 W5ssiWgXJTxndnhN99V/Oe23dfCVy2R7arJ9sdZrtRk9Gf5f+uIqPlWyZCWo9dlDrkt0ocNGzukY0iYr65B7+/sP6+OYTz3+iUSh1KRDAGhOcTEToM0Obk3qa7HiBcT0iFCTX6Sd11KVDcHXABY9axgPTrgM9wDC5VqPazpf2uu3ErMO1MdiSIemHpFN7tdA96iYWe2gA/DVUl/Pg8gtYZelnhgEsCqUCCJdkLLrGj4EEvSou41yvH5eLAfr8wnIBfJsTcddmAgMyIRyg6fbD7xgGijO57pCJLeu1tnuo0nCzjcCD6XjU54poCwnDoo/S84KAyL62p6QHHDhM8HfZYH1qmwlF5CSFLUxoHG1zE1USVKwzAyMonZ64TafCA+fHJpKCzBcybLMUOHqz0Kq2HyLmG4j/+ii37MOY
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
Changes since v3 [4]:
  - Fix patch 5 (cpu/hotplug): title and commit message incorrectly
    said "thread iterator" and "for_each_thread_rculock" while the
    code converts for_each_process() to for_each_process_rculock().

Note: Patches 4, 11, and 13 received automated reviews from sashiko-bot
in the v3 thread [4] that were verified as false positives:

  - Patch 4: claimed the folio lock is dropped before collect_procs(),
    leading to a NULL deref on folio->mapping; the lock is held in all
    call paths.
  - Patch 11: claimed mixing goto/scope-based cleanup in
    alloc_retstack_tasklist(); the goto free label handles memory
    cleanup, not lock management.
  - Patch 13: claimed mixing goto/scope-based cleanup in
    __set_oom_adj(); goto err_unlock manages oom_adj_mutex while
    scoped_guard(rcu) manages the RCU read lock — different resources.

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
[4] https://lore.kernel.org/all/20260911075800.491472-1-ye.liu@linux.dev/

Ye Liu (15):
  sched: introduce for_each_process_rculock and for_each_thread_rculock
  mm/oom_kill: convert process/thread iterators to for_each_*_rculock
  mm/ksm: convert process iterator to for_each_process_rculock
  mm/memory-failure: convert process iterator to
    for_each_process_rculock
  cpu/hotplug: convert process iterator to for_each_process_rculock
  freezer: convert thread iterator to for_each_thread_rculock
  hung_task: convert process/thread iterators to for_each_*_rculock
  locking/lockdep: convert process/thread iterators to
    for_each_*_rculock
  rcu: convert process/thread iterator to
    for_each_process_thread_rculock
  sched: convert process/thread iterators to for_each_*_rculock
  tracing/fgraph: convert process/thread iterator to
    for_each_process_thread_rculock
  unwind: convert process/thread iterator to
    for_each_process_thread_rculock
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

