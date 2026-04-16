Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9600DF8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E930F6B008A; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43C36B0092; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4516B0093; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD4D36B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 604DEC2D07
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:38 +0000 (UTC)
X-FDA: 84664743156.07.49407DA
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id 864F620014
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="SzR8ef/b";
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FK/OfSY81tq6Km5AQA+377gd2A9PmNkH4LJCplG+lec=;
	b=mC5qm+u4Mv4pYebU1es4o/NY81j4MHSXRZx3q6tPO+UHRDj/Tv50SyqjsqgeE2Q/N8aYiz
	d+2fVF4jX5VeEHjlBdYNSXQ3kRYAm/36m1QDxc83W6uBzEtNAoDMTi4Y4S0rXvDeQmDLOh
	FEsm3UvG2pNiLjDh2mEXjADGAZiL4Bc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351936; a=rsa-sha256;
	cv=none;
	b=8APeYDEQ7sm7rJETbfEGwxXZ4J3Ai46offTsEGYGQj+FNznL0Afz6dtmJ7tAOFtwhJgIsz
	hp2pgSNl56cjHXOlOzyeDBcCVCdo8sAf5dcV41lqwjQDQCl69aTZ37bES86R/rZnLfC9CI
	3hOtnQcVl6vpZT0kt6FZO6ZzhaVXCdc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="SzR8ef/b";
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 749ACC7435;
	Thu, 16 Apr 2026 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351934;
	bh=FK/OfSY81tq6Km5AQA+377gd2A9PmNkH4LJCplG+lec=;
	h=From:To:Cc:Subject:Date;
	b=SzR8ef/bttplCqAFTmD6PT3OUECvzJmIpp9H46s/VbOQbzw128wChoOs901P3BLVK
	 Kiu3JDTTE+PZw5mBpkx4Qz2OR1D1+ViWFvM44BD3mikj/Z/Dx1Vg07FUonAAzFusjJ
	 Lt+NkxGAgCXpEZJyfnfe6dkzGobgLxZlbNpq8Sto=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v5 0/7] locking: contended_release tracepoint instrumentation
Date: Thu, 16 Apr 2026 15:05:06 +0000
Message-ID: <cover.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: crcdh4ruuq46thza8kr1hyom8ouh98pf
X-Rspam-User: 
X-Rspamd-Queue-Id: 864F620014
X-Rspamd-Server: rspam05
X-HE-Tag: 1776351936-803823
X-HE-Meta: U2FsdGVkX1/JueH5mM86tp5OhL3TOmJY95XjBuR2Ens1x/9Lt8JLWZT8FBPVdGYhAXX7jmySV/z4qvDGBowlfNNr4vcLKFSBKQrqs88CB0YySj4Kd40iANsC9lu2O/UzLW3N51FLSk9m7zWUtpQpmbkhuJ966jPv8c5UE5Wwta17vcKnZvgwTuGUBtm/Ro4pSRBFRISNC8rMBfLagOtTANufNJPlp0JyQDmDUVzDwp1iC5nv34auR+pSMe/+gXK2/iMnpS67QUywMqwGyKjlYEQ+NnJs54njaQVqraNTDSu/II6nqRHxXCrqI336lR8a6Ed7qEyb0tHRdfTZv+hLhUAGlr0WCOwaAoIu7gGLQpeX50g8G/InidXE+xBttbOQ3AfRmz5/rQF5U+cFKd0k+fRBvCD3bSo7AGzvZMhWNx9h4hFY3MeqQupmDsGti1uwkkZYw/nflbTSV7SBsfVW6fOqplSFWdKiK905WWgcDAMsYUYQMLMbVrCI+xgnnZ5h0k4aDyePD+jwndaKj7Hp6wybxFsH9jj+R3qZt2aXlJw+cxNGE7yqWJiKzYPQhstfi7LKUSpr9XQt7wYnSgTcf/5MkNmpivxpdU9RvndMcFUH8gi1xXfDfVbczHVbBKJ4o494KdMuz5qvVt5+f/pfqmfdAzDUsUWS+XWPJCirI+7zRPaPy8kEYWB/XfR9o4RgoPDzeKxGOKhN5ZrG46q9eGTnkBeErK1tIQL6MOcJaIUHQGQkLytoA8BZMeZpClCxdTTEscvpAB/waRTZhZgQdhqCW3teCMTpkO66cYyaNT6PIbvRMFWt4jLBJzM/tAPjB0+RIaWaYG0z0H44sVNCOicuWHMOEq6uX6nGibR1HTaKHXAvYNZQ58mN18e0HZY5U42TiMtscDER5QUMMQjMciwNFU1+euVtvOO0qVBd8RIVrn1aqtCJ30nly8ZHVgnzzViBEwFggbmFfnrBK2a
 loXN/Gx2
 R8PUa+chWtlTJMz9tkOK5UyYV0RzfnDw87rNyeUaYPODk/m6pRMta83lyPQ51hlI6bkTA9aOgb9SEwqykYfqRzydrF8oSae5fkv1QpYOTFd6bpyyeo5aYogUG0AR5BXVt98M6a644kR4E451jXhd53CLDxko7FwG76qyEC7+COl5yv8PdInAGr8pqV8sA6DrXHET1ovJi3WIGHyuYwLV9TjS7U8BWWfiUXlm68UtChv/4Blo3eq1JslAq24EIoZbC/HiNd6igWBQz0NvCHe/ysveOez2UOgcfGlSnfHa8/w30gFM1cQYxXt5Xh3b4kVGwdzgwxykxC083DISVLUD6kVXCfctWHPWIqm6RJK46aYJyFXKcogMV0RurtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing contention_begin/contention_end tracepoints fire on the
waiter side. The lock holder's identity and stack can be captured at
contention_begin time (e.g. perf lock contention --lock-owner), but
this reflects the holder's state when a waiter arrives, not when the
lock is actually released.

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

v4: https://lore.kernel.org/all/cover.1774536681.git.d@ilvokhin.com/
v3: https://lore.kernel.org/all/cover.1773858853.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/cover.1773164180.git.d@ilvokhin.com/
RFC: https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/aa7G1nD7Rd9F4eBH@casper.infradead.org/

Dmitry Ilvokhin (7):
  tracing/lock: Remove unnecessary linux/sched.h include
  locking/percpu-rwsem: Extract __percpu_up_read()
  locking: Add contended_release tracepoint to sleepable locks
  locking: Factor out queued_spin_release()
  locking: Add contended_release tracepoint to qspinlock
  locking: Factor out __queued_read_unlock()/__queued_write_unlock()
  locking: Add contended_release tracepoint to qrwlock

 arch/mips/include/asm/spinlock.h         |  6 ++--
 arch/x86/include/asm/paravirt-spinlock.h |  6 ++--
 include/asm-generic/qrwlock.h            | 38 ++++++++++++++++++++++--
 include/asm-generic/qspinlock.h          | 33 ++++++++++++++++++--
 include/linux/percpu-rwsem.h             | 15 ++--------
 include/trace/events/lock.h              | 18 ++++++++++-
 kernel/locking/mutex.c                   |  4 +++
 kernel/locking/percpu-rwsem.c            | 29 ++++++++++++++++++
 kernel/locking/qrwlock.c                 | 16 ++++++++++
 kernel/locking/qspinlock.c               |  8 +++++
 kernel/locking/rtmutex.c                 |  1 +
 kernel/locking/rwbase_rt.c               |  6 ++++
 kernel/locking/rwsem.c                   | 10 +++++--
 kernel/locking/semaphore.c               |  4 +++
 14 files changed, 167 insertions(+), 27 deletions(-)

-- 
2.52.0


