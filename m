Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25685FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356A46B00AB; Tue,  5 May 2026 13:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3073C6B00AD; Tue,  5 May 2026 13:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D746B00AE; Tue,  5 May 2026 13:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1009C6B00AB
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A262D1A05CE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:56 +0000 (UTC)
X-FDA: 84734003592.30.02938FC
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id DFF24140004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OxH5iBec;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JME30EqI9Oa5nd9X+jXdCtKM53zsahsE6SloH0sWIsQ=;
	b=XK0BHd8DXqlBN95QQzSImBH6HBDrMnp2g515Dlpe1um50pG+mssTLEN0EXF8UgSsng2Xbr
	uYzcrtSZZ5/z19TYuM/7pHlclTY29yZo2Wn9jC62X2P7vBHL0ecDcZWPAbVsfW1dPn40ii
	m2EHNZYPVkriQxVmNeRFLf1PulyWaVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000995; a=rsa-sha256;
	cv=none;
	b=RzMFNf05AOYHcM0jyBuBKqugL9Fizoit94qlH7HuHYKAgbysFtRxB4tqEX6Duiq/FR45Um
	6FBklM0dTgdCkfjNTRS3U4+JZUUzIcO2GzC9wXsK+TpyRmmnpaYuU+J0r/G2xcm+qtfQcf
	heqm0ey/YVgrN0O07ffPBdxWVC1TwYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OxH5iBec;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AA6A9CFFEE;
	Tue, 05 May 2026 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000993;
	bh=JME30EqI9Oa5nd9X+jXdCtKM53zsahsE6SloH0sWIsQ=;
	h=From:To:Cc:Subject:Date;
	b=OxH5iBecNhNPv/fsyArIHSOs50UmZpgSC+Gr69EUqFDlcBykPD/TR+C3/purZaSyg
	 DyeTgbtoe5JSD1gip7bC0O+QN9mZdGISQI/mqWYr4OJFxFTjF8TqbDTHeNRbpSi20k
	 b7Gdk6ac14edfT+wR5kmclfbP2xsqCOdYlSD4dKQ=
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
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v6 0/7] locking: contended_release tracepoint instrumentation
Date: Tue,  5 May 2026 17:09:29 +0000
Message-ID: <cover.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFF24140004
X-Stat-Signature: rxhe5paj5ooweuupuy1j5rexx9gp3ht9
X-Rspam-User: 
X-HE-Tag: 1778000994-556316
X-HE-Meta: U2FsdGVkX18ab3LShO+zvIuiOgebhFcSnToY163Qii7z0tWnWEneKpw52RIuToGgwnZJL1gIHpXk3LRQ+B2Qj0Hx7CxFRkiW3A5kzxDuEY/VNdjWvAgfCSKjFATqvhXtgSD8EFvHLGEQUqAVV13wdkO6xLryf4BxPSwJk4BQ7kpIyDwZFbEpBGv2Fsk8Dfl72mtFZxOY58TeJ3PRO/Hj0NnleGRbuYmlK/K7SCaFtRcydZiiMjDrKnURIoiPGkaZsU1Ruherj+vCGDTWLQX7X7xlE4EZRWKz73HKqMdMMhT8yjEhL5TfYzbRysKiLD2QJqak8IK4GDuUwkSKLQGjrfZHl/jNVXgQU4tuv51G4qYSCJHvKO3Jf9VfqaLPW0uIa4r/OxnCr/zCCWIjYMcDY3xwe5k2TQW/j2VPN6pBtDxRx1/DwYPEV4fgaDil8FYGx9h3xHDADA7x9gMiX3isngwM1kfueWcoSFLVY1hxI/zyYsExhkXqU4Od5cq07TzzkqvmHVC5RA7RY1e/FL8e6VLy3QDWck5zwSZpdhMqz5lUPGWHuXyHgeV+TgxCXRzXLXs05jtB2LsnSnJeEOr+eNCYdvM4aFSY/p/eTGJ2EgLwuuOaYJJgjAc2yh0WZairnvDtlC+vwSFI4tZWR81hANdfZULYqNx7KFSPQ1aTd62XiSWzZTIwakLRHkZ+rgsX/b/n/wFg29yVq4F0FDtPvZNUMxgEjJbV2r9QpldudNsO2iJwgGudHOto1UV2Yrs5WOUDDjPRmqitZVbzUioh4y302RZ4Rj4Ghvds/vMS/rcG2JD0MpgEAkbnxPQRVUg1dJrRRdTWAeuQpYwXGwuRR/6X5w+wmlBK0C0vHuApDAYoYeEkDBY1WGxT5Z9QnHvRj1OCoie2GttaQq8l7asG6joR+Dy1vdBoqa/SsVY60RkCLZXecd9GUthUzjf+Ybd8Mt09DFbwAl4sfdJIaht
 RvyyZ31j
 1bv17qP7pbVLDFQHDx5W1f6Ev8RIBt6lwP8aBNkrTfTgBiF+yqAl2Ai3bbPkoe5+ZSdXS5Bkbyp8rnuGJb7K5k04vmlGUPClVc+IgMkJeDYPYhcR1Mnx4WjBMBxVZOXBbOnPeUjzhjqAGBzg/3RtDuMcKZzngsTAtjisvkP+yHMTH94jUEtIGElkXia/7CYrJcvWpyhvg27vJWWnpeKE7zDy06ZmXHEUdTV/93eR3t2HVVPhP8PQNK3wqvwfFlHk03wn9/xsGxWm8rq0cMxQHSVofDjZR/q4pOH5UHr5zkf1TS8WUs4ZsQIrwTxClh14mrdi67oVtnPB5iYQMsN1TiA7J+AoLaad0y+7zEH18WV6vx8+gT2A4yEGQyg==
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

v5: https://lore.kernel.org/all/cover.1776350944.git.d@ilvokhin.com/
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


