Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEC810A3D96
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA65E6B0089; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B586B0092; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2C26B008A; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A04A46B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D3F5C2BF7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:23 +0000 (UTC)
X-FDA: 84588550326.09.35C5399
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8550A20012
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=foxB+9tf;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=foxB+9tf;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774537821; a=rsa-sha256;
	cv=none;
	b=KaErwNt9Ide7mnxJgAMpWEcptNVkJRMXYlHgQD/+tbK4m8uS2JOji6rvyIwtPorb38B9a7
	y9k5bAIQhkDRy5cumXblZf7ZZ8qSCqhWZrV1N5W8JmlWodXAasBSTAA7R9iOce5cihwilk
	+jW/vD+KD+Ql5sOJVL2DbutQrZz17PQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774537821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M1+Dtm74mh1nMGihjL6ZTbw1kVNoWgQVSWL33VEGTMg=;
	b=t4ohGJl+O8gtG/D0k/JCc/kSo/U5Mt64oENmZeRbap9kE8W0DdqpWRGYKScX6F7n8mSMsH
	qioyrJ0Crq+oE0yK4eI0kURRbtcDTg3yGhZJAVcxqxWMi1BY0VA8c067s8cIgIMsnr5DKw
	faJTMw9/qmmMN2nhO/H4nRoiAB+p1IM=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 3CE29BDE0C;
	Thu, 26 Mar 2026 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774537819;
	bh=M1+Dtm74mh1nMGihjL6ZTbw1kVNoWgQVSWL33VEGTMg=;
	h=From:To:Cc:Subject:Date;
	b=foxB+9tflNYRsMsAY4hojtZCw/YTQr+FELes3WoVGZTqYTw4RLvxG6kVkDfPhx1Es
	 WfZSO0LF7OxaHQKKEsEqP2ELT19d7KZXMxVcw9n1dzDXFfT8Ja254y5nkHoj8mBT01
	 8W0qKSjrh3q1FwHjrVma7oHJAxOp21dXQUbuZX7U=
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
Subject: [PATCH v4 0/5] locking: contended_release tracepoint instrumentation
Date: Thu, 26 Mar 2026 15:09:59 +0000
Message-ID: <cover.1774536681.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8550A20012
X-Stat-Signature: np6m3zj5j7z4c9sda6rfycapirsu9oni
X-Rspam-User: 
X-HE-Tag: 1774537821-554267
X-HE-Meta: U2FsdGVkX18yNSVUgCrL12Z2JhpebbCOSZSrmK6nD1SasEiXF7LUOP1oPqbvJTdn9ENKDGY2hMukciZtTV3GQeCaeT1kMSb+3+Zq11h8SFD3GfhpWih2OEviM9tzkCKxq3u5VkHrqOQpxlIVataQ0V8J1gvc3X9fBzURhuLPgk1smoO8E/zVLJnE5gk1AQCFl0t0VXBs9DLgXCK3sZC7tNb/Ka8TXjCOMbLHZsYbtwSfCVrqcvRAWXmVVFKfCavMFGz/rvgoFHnADsTx+llqaJD5tcIlZyjO8AOZNN5lgRqJffBfVJ3te5XbU/zLmXkGeT6jNy5zSvNWvZLCUrDnKNivS8wPxLuIGviuaptz5b/JTHz77x+HoKfKupb8DgKKT+uCd2TkAV6A6mlDubGd4jaHyv1dPiYEM5161XoGhKxgnsHu8Qhu0DGCI28ASFQ6PFHDnJFVpFym8xlNA6Oq+7WGN6c6xfgGUvoT13EHbz0u0E71kAtukXr3sjc9CtFd5z3vzvnT/5FIX86HvghLaAbMq3ogQBtsQIE579Daeuwehfowfbgbs9kiaRI2NFpsbo4V52bSliWZqVLBzsRWy7zOlCQC8quO+TN1bYQFTy02gWbEM48TLEH2fQ/7M6hVJyAvPKagQDOsxpZu0tEuaw1ISaKAOqrSdxfgnu1bjGv6XKUFJy27KQrLuhDcu8Q/hj9D+poiY8kRrNUMmU0Mb5lyUZpx+bB8O55gDcuyK+W7jPi5gqz2z+eiHXTx90KfvaGgdR0Rlz8sT8wqFw+mTrQJw1FrhobgYE2wu9JhP/hEjz5eIXr/3R1rbRRDu6ywtFgWUeTWetBRMx0SBRzqwfb9A0KE+TcPTkEVsvfwGoBea+aBczCsExtubRFcG8Wg55582dPMGajCQenyoMHJSqpwXbgeNxqvxwPTp5n/hiayNpGpiCUtAqcPndooiSKJcvUlkqv1qe0=
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

v3: https://lore.kernel.org/all/cover.1773858853.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/cover.1773164180.git.d@ilvokhin.com/
RFC: https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/aa7G1nD7Rd9F4eBH@casper.infradead.org/

Dmitry Ilvokhin (5):
  tracing/lock: Remove unnecessary linux/sched.h include
  locking/percpu-rwsem: Extract __percpu_up_read()
  locking: Add contended_release tracepoint to sleepable locks
  locking: Factor out queued_spin_release()
  locking: Add contended_release tracepoint to spinning locks

 arch/mips/include/asm/spinlock.h         |  6 +--
 arch/x86/include/asm/paravirt-spinlock.h |  6 +--
 include/asm-generic/qrwlock.h            | 48 ++++++++++++++++++++----
 include/asm-generic/qspinlock.h          | 33 ++++++++++++++--
 include/linux/percpu-rwsem.h             | 15 ++------
 include/trace/events/lock.h              | 18 ++++++++-
 kernel/locking/mutex.c                   |  4 ++
 kernel/locking/percpu-rwsem.c            | 29 ++++++++++++++
 kernel/locking/qrwlock.c                 | 16 ++++++++
 kernel/locking/qspinlock.c               |  8 ++++
 kernel/locking/rtmutex.c                 |  1 +
 kernel/locking/rwbase_rt.c               |  6 +++
 kernel/locking/rwsem.c                   | 10 ++++-
 kernel/locking/semaphore.c               |  4 ++
 14 files changed, 172 insertions(+), 32 deletions(-)

-- 
2.52.0


