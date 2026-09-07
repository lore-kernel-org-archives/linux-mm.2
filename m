Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DAAC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4827D6B009B; Mon,  7 Sep 2026 04:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459F26B009D; Mon,  7 Sep 2026 04:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3705A6B009E; Mon,  7 Sep 2026 04:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 097756B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:13:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82B0AA0696
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:13:52 +0000 (UTC)
X-FDA: 85186252704.12.E8E43A0
Received: from mta0.migadu.com (out-223.mta0.migadu.com [91.218.175.223])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6535F120008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:13:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=crrNKirS;
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.223 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1ZuvmB1KyZmSTIhlRU+E3rqLuFU+OwFfAN7irisOh0Y=;
	b=cCh0ov+Pe8cvNEWwj7HBSHO6doDMXNXa6L+QKSODClLe2AbfMZXnHGiM8K5pvxC/+C3zmY
	fTtQJUv7rF2VM7jr2a6PyVaOdnotHmQRlRk6UJZHRMjLQdzqcICBEHXdPWYDEEM6/SIiph
	BGRaeQ2yB14Odmc2lUqnJzSQAfMx+gk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768830;
	b=5aIZf4hDy4H4dWOpM+nRGc8UoWnzC/jcaLL5GkJ8Br3fbTVgaoRnqLy/e0SmDjeV3Qhdq5
	urCq1MZCv7LuGyRNpYahjrfsZoNujaqIx+ooxStVEBYmmXqUtG9wtWtxiRap0yNqa3fo0D
	hko1dEX8jh7FOhncX+mma9wNx46H/3k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=crrNKirS;
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.223 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WPjsFkKr6FEYMnlHhMl1nDBxkpUdBFsa1ndkFSmZ/0Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768828; v=1; x=1789373628;
 b=crrNKirSqCWRXtMKzcMLrd5Pr+KEL469evIyIDu0TuNSSltuuZgJPHpt1rJogB6oRN0/99hM
 nQnFgQYvjoiAgHCnf1L6IQynfj3mqIKlj4TLcxUCRfXwXHPGzd8tS0xRmj5V3wnp1uj3vngbMc2
 wo/yPRoS2cZswZPb4rm8udr0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2103926bec6903fd;
	Mon, 07 Sep 2026 08:13:48 +0000
X-Mizu-Trace-ID: 2103926bec6903fd
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
Subject: [PATCH v2 0/8] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Mon,  7 Sep 2026 16:13:26 +0800
Message-Id: <20260907081334.1152889-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6535F120008
X-Stat-Signature: g7jekpp1km5e8m1ztmd6g96fkqf44k7y
X-HE-Tag: 1788768830-66295
X-HE-Meta: U2FsdGVkX1/rF1DBaXS8BJRwA4FeJqOcVbBENREm0ShKDB0yi1+Rgc3uaCoq75ptWidmHzmNJXd22vgSst8fwHT6ggMFN0Q+RYkANb3C1fyZaH+YS5mrNS6QTeemmedCTxNdTWDH5PZ4fOBQhhy6EiTlyKNzP8377fwJzt3JD2AbM0CPmCvYv94xQUlTHbtQkt0KdB4C5uK3cnZxUansao7+ONkehYNbDckTzTfMZbpENHI/IXECCFktW0ng8P/3FFpsVtbwBxJ/Qc8M+M8EcYUlyJKY2I6Br74DV+uqj6iwCWXjJJmO9JJYLWaFqrI7vncjP8LuupvpNZIFXx2I2tgDBYKwuvmroqQmRwojAR0VD6Z5AoGn8Ds8OGhFvA+CEJoizgjmnj43HNB5wyd9O3WYg+/Q789Th3J7zayUBxp19vnQED8p8r2yAa9aVxXjG6KPHakwsQXsKXlHTubSmMv6xDtlHHaXieDc5inuzjeJ2vrt8Wt7eiUHWG1zWRy7RYbrf0fgX4JTKl0YxBA7HU3LEUvj8Ll3uGd5qAFUj1J6sxeCYxoTuXBRvdX7LleZmrPBuemIuCog8cNpeO0oIFuvlDGfmwxrYFvr+OoqKbpaHDvubi98m1ai4duhxJyxrb0wOpRcYrnObNxcmBZZwQ4JXEej77gEBaqYLtu3hqgsX5jkVV9/mywv5QYkYWljqF+UbMLLpLe+kB3QRA8PTngW4OxmD9gvYy4b6q0ohoYuiTaTP535thyqNJOt4eRjV5wtex9+hcI23EGwDaJXLv82fVBrlQeNlqIwP9sfRm+sMqa9BkrPVh9GeTTb74bIfWdrGMh/kfPRLbpdmbTGT3KaL/5oYMeISeV/7/Dfnhk2c8Zn/z0OD0S2qdjW44HylmB32e4Lzq+IImIDsDdNLH/EoytcrJlT3/JyhtZimyyomH8zH1M5DkSD5oMp4DUSBqLeGyUttIqcjnZ+V4i
 UhwdzAE1
 yaTrpDO3R+t8K366tXhHAajQ6cyRFR5Sa/CboAcMI7LD6tWtgEzwumugZrVP7OBuNdtEZIRfKO7PuKwJpYTPF9XH0cgedU8OmvZlFph+DJKODuDOpAGfM5HlM+m6fkhP4M/kn8EEVn9CMgMBgHrfR9jdinnHVBNoKb8f3OWqc6VaqNHF6ttnUFzUvO2GBXbPPOw7nPhOl9Yfg7DwiUlpb5RF+PCJJMtAG8YGOLkEQjAGmURmPzXojMOuTap2hYWvCOjXdYiKnI1PNYDZjpxARHwpd7DCjMMVCDX42/5veDkayMO0C3JxIzklH6GXHquuDXXow45vnuUkQP5ls3gasWuX7WqJmq97CrRReEiMyUX/kzll6ovkbpLlDx2x2D64YbPCDZ8khcU+3egBODv5VfpJqbA==
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

Patch 1 may trigger checkpatch "Macros with complex values should be
enclosed in parentheses" errors.  These are false positives — the
scoped_guard() pattern is a control-flow construct, not a multi-
statement macro, and the same idiom is used elsewhere in the kernel.

Suggested by Michal Hocko for the oom_kill path [2].

[1] https://lore.kernel.org/all/20260904083001.553587-1-ye.liu@linux.dev/
[2] https://lore.kernel.org/all/20260813092933.562028-1-ye.liu@linux.dev/

Ye Liu (8):
  sched: introduce for_each_process_rculock and for_each_thread_rculock
  mm/oom_kill: convert process/thread iterators to for_each_*_rculock
  mm/ksm: convert process iterator to for_each_process_rculock
  mm/memory-failure: convert process iterator to for_each_process_rculock
  kernel: convert process/thread iterators to for_each_*_rculock
  fs: convert process/thread iterators to for_each_*_rculock
  lib: convert process iterator to for_each_process_rculock
  security/landlock: convert thread iterator to for_each_thread_rculock

 fs/proc/base.c               |  4 +---
 fs/resctrl/rdtgroup.c        |  8 ++------
 include/linux/sched/signal.h | 25 +++++++++++++++++++++++++
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
 17 files changed, 54 insertions(+), 81 deletions(-)

Signed-off-by: Ye Liu <liuye@kylinos.cn>

--
2.25.1

