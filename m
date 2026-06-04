Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD5ECD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619C86B0092; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3986B0093; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4925C6B0095; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38F576B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF5C2162310
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:32 +0000 (UTC)
X-FDA: 84841369704.12.B0B17FF
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 39DDA40010
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="mxVOn/D4";
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Hg79y15YCdHs+Aahi2RclYmfUq76gHwLkFjgTtqnUGk=;
	b=xX9t/Etg+5vBXzSZ6xBrVYKurv5MeC+UNkI1Jia7ilegsUFWg3fMvJdpkQPcPeAqf6tHJI
	wmJH3DYGc62SmYD00Uh/65yfja9tA3jqTuwcDnpj6FgY1k/qJNUIsiKa4b3yNZnFO1ljbW
	6jk67Ca7clLmGtTJ55E1/KAPX4hhCoc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="mxVOn/D4";
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780557331;
	b=l5QbLapehcQiBLhdW/JwEncqTEUXuOuOajeXipcdwTblO/sLXiyp1VyGe3XVkPTjzqD1zf
	QCw0EnzEWkyIDIjECAP2QeO3U/14hF7n1+vHjG2wa7B7HeqLFBW7xrC+OAgFpEqyVJ67ah
	4m1SeK9evE37qFVVd4/J2LXWcI/J9hE=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6B4B8D1154;
	Thu, 04 Jun 2026 07:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780557329;
	bh=Hg79y15YCdHs+Aahi2RclYmfUq76gHwLkFjgTtqnUGk=;
	h=From:To:Cc:Subject:Date;
	b=mxVOn/D46yT/c8oRCWsfgKBKKJdDOYbfbftFtW1NR+CFmqTi8/81mGSrmmM3F2sjW
	 1+KkuhAIt9c4x3RtV5+/g3DJIwGeXX+QE0cq+oBQYJlW6bR+JPk/hnGB4KuAJAAZoJ
	 VS3erzX5NwDRv+n9slnaOvs3lyUa/1lt3ODHjBuU=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v7 0/3] locking: contended_release tracepoint instrumentation
Date: Thu,  4 Jun 2026 07:15:04 +0000
Message-ID: <cover.1780506267.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bm9ona1qe3e3uzwui1mw44ypn6tk7uam
X-Rspamd-Queue-Id: 39DDA40010
X-HE-Tag: 1780557331-463140
X-HE-Meta: U2FsdGVkX18fFtQEjpOB5qwgXRr6Pd9ewTsZDiWctS2qt75zP4bTsxm785ojt/x0qL5B3I2sfU/Ly8TmtGpJsCAvLl6c3eGV6Wx2Y4fz5mlTKfJqpkM/3Gw4mavc82iM24RDevZgxvuUXgrPYhLODlsHLiibV7OL1CmiW9wJgK0FJJIm6u77rnAE9hsQvv8kcvrzVdPasy1IhkllWrs7i0T0046jXzE5+i74AsIp3rKT+iGnx02OjHG019dSIN7eA4Nu5yiPhMEe6uh+0wqfv4kD6ByYQF5kdEs1DIVhoDG+QQq4Qf+BeJXZ8XnfDYl3HyzhNtVTXBl+7zoFcblMaYJzUyR9xjGh8C/hw4eEnt7St18GseIZPxYjuRNCyJDbQzdIEW4GqrKXOnJP4d/SRNxus0CqsxRAbvYij2FaBR9OHI3o/T9g0dExVVgn1LSwde1V1aY5i5Z22UW72/70jh2FwZSuJ4drJoV/hHzf7pQQpqNUnze2RzVIGgbyeQgTtN8lyarorSyMt4ISM/gJJsOI1ePQRulhjlewbaFnlLrSSXq9nCANHjnBPFItNlRr2qk6nqgcg2tJ9s2GkRkB+ZSRT+RXiN3OU8G5cm3ZU97gFd+qWS1oRMn+44mkYVmoVCufHfGMj4H7lF237YikSl5pa0MxnJPjjkCwpGAEnAW2iEmlcOoLtW0PdMWn7uSSNYjdDmTuekZibp6LAOpBjp/Mn1KCQRK8hWidAn8aN2J6O/L7zg32k1vkjcmYK7kqr7D4UTjpTBWIUskEaJRxinIef5pf+0sqmG6czuXe7Dh+MEVVez1sXFLPoC4C85AtqqRmJch7vH4JvKHDvPoSa6zOh8wXo0vpB6UThhbQdbbAqmgD4G7pt8xWie9+VyH4lZ/oXQf57pwQ+RYvdXunQO6f9Bu5ylcKk2QONTmWpEfswdt4/TesdKOHklxA5YgGaRCHdfHZgjVxal1XmJ+
 K6V9AXxZ
 ylHfZ/UPi3o+nSeoGWDRWtT2Ku7uK3HRaKgLOn40icpRb4M2f9Lciexq1/e2EhX9n5hl8m5hRRZto21lQ1pQ9sZIWtZotN4mWBBxMT63eeEL+5oz9Lw0HhudVqYtHcrH3rSl1A/v/u+M3tiyd3RcJwdt5XBvq50PfEpbIR37g4GNAhx6/k/KLuC7U4h8ZN9kalWy8FR3vy9kO57trS/2Svnj3gIwVcTOwoWOQYRh7O9hPl88R7EcEbhoQXYuQwSR89LEB2sVp9nNnHYUAeolZMZy3rT23o2kMnNA+L6ZWmevaD2vJ8wqtdKTeBgI03oGsp8SwEJeFR9Km4YXEymyaCBT8gCRQJIqiwKs656CRfZy28pQDGwgNAT75eyvyyU1Zz24iuwRClMBdn4wD+QgeMMD1AVdOTsTwB/8LZu90pnYgyDVRE5sY6gw7Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing contention_begin/contention_end tracepoints fire on the
waiter side. The lock holder's identity and stack can be captured at
contention_begin time (e.g. perf lock contention --lock-owner), but only
for locks whose owner it reads: mutex and rwsem. Other lock types have
none it can read, so they get no holder-side attribution today.

This series adds a contended_release tracepoint that fires on the
holder side when a lock with waiters is released. This provides:

- Hold time estimation: when the holder's own acquisition was
  contended, its contention_end (acquisition) and contended_release
  can be correlated to measure how long the lock was held under
  contention.

- The holder's stack at release time, which may differ from what perf lock
  contention --lock-owner captures if the holder does significant work between
  the waiter's arrival and the unlock.

Note: for reader/writer locks, the tracepoint fires for every reader
releasing while a writer is waiting, not only for the last reader.

v6 -> v7:

- Dropped spinlocks instrumentation patches, I'll rework them based on Peter's
  static call idea. See [2].

v5 -> v6:

- Use trace_call__contended_release() instead of trace_contended_release(),
  where appropriate to avoid a redundant static branch check when the caller
  already guards with trace_contended_release_enabled().
- Added acked-by from Paul.
- Rebase on top of the fresh locking/core.

v4 -> v5:

- Split the combined spinning locks patch into separate qspinlock and
  qrwlock patches (Paul E. McKenney).
- Factor out __queued_read_unlock()/__queued_write_unlock() as a
  separate preparatory commit, mirroring the queued_spin_release()
  split (Paul E. McKenney).
- Updated binary size numbers for qspinlock-only change.
- Added Acked-by and Reviewed-by tags where appropriate.

v3 -> v4:

- Fix spurious events in __percpu_up_read(): guard with
  rcuwait_active(&sem->writer) to avoid tracing during the RCU grace
  period after a writer releases (Sashiko).
- Fix possible use-after-free in semaphore up(): move
  trace_contended_release() inside the sem->lock critical section
  (Sashiko).
- Fix build failure with CONFIG_PARAVIRT_SPINLOCKS=y: introduce
  queued_spin_release() as the arch-overridable unlock primitive,
  so queued_spin_unlock() can be a generic tracing wrapper. Convert
  x86 (paravirt) and MIPS overrides (Sashiko).
- Add EXPORT_TRACEPOINT_SYMBOL_GPL(contended_release) for module
  support (Sashiko).
- Split spinning locks patch: factor out queued_spin_release() as a
  separate preparatory commit (Sashiko).
- Make read unlock tracepoint behavior consistent across all
  reader/writer lock types: fire for every reader releasing while
  a writer is waiting (rwsem, rwbase_rt were previously last-reader
  only).

v2 -> v3:

- Added new patch: extend contended_release tracepoint to queued spinlocks
  and queued rwlocks (marked as RFC, requesting feedback). This is prompted by
  Matthew Wilcox's suggestion to try to come up with generic instrumentation,
  instead of instrumenting each "special" lock manually. See [1] for the
  discussion.
- Reworked tracepoint placement to fire before the lock is released and
  before the waiter is woken where possible, for consistency with
  spinning locks where there is no explicit wake (inspired by Usama Arif's
  suggestion).
- Remove unnecessary linux/sched.h include from trace/events/lock.h.

RFC -> v2:

- Add trace_contended_release_enabled() guard before waiter checks that
  exist only for the tracepoint (Steven Rostedt).
- Rename __percpu_up_read_slowpath() to __percpu_up_read() (Peter
  Zijlstra).
- Add extern for __percpu_up_read() (Peter Zijlstra).
- Squashed tracepoint introduction and usage commits (Masami Hiramatsu).

v6: https://lore.kernel.org/all/cover.1777999826.git.d@ilvokhin.com/
v5: https://lore.kernel.org/all/cover.1776350944.git.d@ilvokhin.com/
v4: https://lore.kernel.org/all/cover.1774536681.git.d@ilvokhin.com/
v3: https://lore.kernel.org/all/cover.1773858853.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/cover.1773164180.git.d@ilvokhin.com/
RFC: https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/aa7G1nD7Rd9F4eBH@casper.infradead.org/
[2]: https://lore.kernel.org/all/20260603120811.GW3493090@noisy.programming.kicks-ass.net/

Dmitry Ilvokhin (3):
  tracing/lock: Remove unnecessary linux/sched.h include
  locking/percpu-rwsem: Extract __percpu_up_read()
  locking: Add contended_release tracepoint to sleepable locks

 include/linux/percpu-rwsem.h  | 15 +++------------
 include/trace/events/lock.h   | 18 +++++++++++++++++-
 kernel/locking/mutex.c        |  4 ++++
 kernel/locking/percpu-rwsem.c | 29 +++++++++++++++++++++++++++++
 kernel/locking/rtmutex.c      |  1 +
 kernel/locking/rwbase_rt.c    |  6 ++++++
 kernel/locking/rwsem.c        | 10 ++++++++--
 kernel/locking/semaphore.c    |  4 ++++
 8 files changed, 72 insertions(+), 15 deletions(-)

-- 
2.53.0-Meta


