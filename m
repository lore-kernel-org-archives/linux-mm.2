Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46741077605
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58F76B02D8; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F2E6B02DA; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF74B6B02D9; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB25F6B02D7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C50DB4D26
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:57 +0000 (UTC)
X-FDA: 84560063154.13.CBF5D78
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66DB92000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=N+hWuJ1A;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773859555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ezdQ/F1a9PQHRulpi8cke6vRgjLP5GH76Dfq640SPO0=;
	b=PALOIsZP9jXedZVlKqEQpr8pq5FTtw2G9cEhViZTr6gPuf+hRqpYbU2/O4kc6tu8bc6cpe
	egTrE0RligOLLrMo/edh7s+58yn0Vzi/ZL/VvQPy9ipouYP9BG7Js9kzvvzO3PylLkJoqU
	R6P1vAqrzGQekrgAxSIKaxetJRxDSp0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=N+hWuJ1A;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773859555; a=rsa-sha256;
	cv=none;
	b=rSsbarFyQK+GXlGaQCv0L0o/4JgVzK56V+0bxAybBsGAQBXSsJ5A5/bH3WjaVW4P4Wh/dX
	qDMWX3XVwAh2EmPvhL+X6hNmmNjRMfcZWZl35+bYONVYwOctsxKkeO5jQYYI1EVmxiBtAI
	broorpXSo7Pag8VV0Tco3AkUJcOQhYg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 8C128B3E3C;
	Wed, 18 Mar 2026 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773859553;
	bh=ezdQ/F1a9PQHRulpi8cke6vRgjLP5GH76Dfq640SPO0=;
	h=From:To:Cc:Subject:Date;
	b=N+hWuJ1Aufm8nD8KZtt4ROPvMhpSNIEkP0Wuc0uMViH2juxUYlJhklH8g6KfKRHgE
	 W/j/HPfNThDJweibRwtpH8yaOncNtCRkYmnMNQHg2or7mCFkfzxSdvNNINJXo89LXb
	 KOsHJPi4YlfbnZN4cT5x8v6+YB2WH1bBjr7YrXSc=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v3 0/4] locking: contended_release tracepoint instrumentation
Date: Wed, 18 Mar 2026 18:45:17 +0000
Message-ID: <cover.1773858853.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66DB92000C
X-Stat-Signature: 4we4hu7cwh8eydhd1o3w799n33sbygs8
X-Rspam-User: 
X-HE-Tag: 1773859555-515614
X-HE-Meta: U2FsdGVkX18zsmS9sBgRAR6Znkb4ujVcTUVC7GvcWVVNJg3NKpcSp3ib3Bk8/XsoW+yCpMtIG7zNDw3HMGrAgyo0utmQYr/+HNEU7dQfOJUKWxFvMj2l5OxqKFRvD8Qin7tw4gig5Vaqy3quWaLnV2QvwFbJj/drNRCGaI36CugCCsm43AYbHHeq5WbPqLJ2sClkJK2TDckgyruEOJ6/oI4BXs7p8XOhmtUmTb5++u7ro3HQ7ZuB0rMKd/iZjWH0WJ7VmbJQuYa5upqM7M2KQqyfjWo9bSf1WeMFfdSh4HOHHK7LlF4wNZI8POKUZobN9B5Zh7CnYVmaZPzU62gruDI+ieDRWfNQSOGsbSx67Pfs1b+yGeT+Lh2G6PopEfyjt5NlwDoLNDIjA3A4iBZuhTO9z+X9MKz7H+z7lNE4NLfZpW5PBOEt/UdgX63wQ/kdqNBJvQIK01fHq68BnUbch5anoUgta80LWViisZy5TMpTmtu2xh1m4SOfa29RNCh/qvBWLKYzgm8U+YyeEHTAe6o/+PdiDmHs07QlDpwQ8PrsFeNCIKAS0T3c5RmYRLjg73ZQpNK6aMTJ2zEWWsUPuzMPvn9F3RzHpkn794zD0MXaPe6SSScZDPwXz7EP0Ww5f8n1hmieDqQxLhiSw2Rw9PwY8c8zaN+Eepz0F+R/Ul0Y7uxYUSRUGPCVrjip9eIJP5P9CZzPYnGdwA3gpmHOUjLr7VA3sdQniizfyB5jza08ZhC9zcKXnFOAj70ZN5n4PsulewLWKNN7MFj9zycQgcrKldjnBN3AUJXS9Ll+lcLFCEsXjClYK/52aB4WkJrOqQQjF38O3HWUBgQdWDLW/IZMySg9xWiefAz2bnhe7hNQCYRFLrV1PtWQfV0nkRXsWLaSFsjuqGZImhcq5hcAPEm7OVVfdW4uWY05MrCF+Dl9FuVtfbULczAUykg4UFFjamrG7w7A8GPr4/iI3ic
 rZgmbS7l
 UhyO/jU8ZnSnVUqIzReQQ7TpDzjEkUXrIJ/PbMZt/3cpk0bBccEwIOFCX/Kn8/6tg91MrL9gdqOSpumXaSc7FIBCRNtmCbWjlLfNM0GRjCyUlWNCudjQPvauP0kwWVFtqjDjXA0gDQcSEELpJXiTOUC8fJ2KcUeUOeThJbUyze/uqK4/TKJqGLVl1BZDi9c1PzuNKF0OE9CeSdLZxT5nNq5f1388Qya85a+0dCaf23qmECGfXGGSyNz90Vk8jc+3CVR1/9ZUaKNeKMihlWkvAqEtw8GrWobTm9S8Led8XPxM+loNdyscUW5XZkHSo7Gw3ppegVaP+i6zoV4D9XksmBb2gH9dAMCSUU6L2FZSvs3XERP3kiojNdfhjlQ==
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

The series is structured as follows:

1. Remove unnecessary linux/sched.h include from trace/events/lock.h.
2. Extract __percpu_up_read() out of the inline percpu_up_read() to
   avoid binary size increase from adding a tracepoint.
3. Add contended_release tracepoint and instrument sleepable locks:
   mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and rwbase_rt.
4. RFC. Extend contended_release to queued spinlocks and queued rwlocks.

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

v2: https://lore.kernel.org/all/cover.1773164180.git.d@ilvokhin.com/
RFC: https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/aa7G1nD7Rd9F4eBH@casper.infradead.org/

Dmitry Ilvokhin (4):
  tracing/lock: Remove unnecessary linux/sched.h include
  locking/percpu-rwsem: Extract __percpu_up_read()
  locking: Add contended_release tracepoint to sleepable locks
  locking: Add contended_release tracepoint to spinning locks

 include/asm-generic/qrwlock.h   | 48 +++++++++++++++++++++++++++------
 include/asm-generic/qspinlock.h | 25 +++++++++++++++--
 include/linux/percpu-rwsem.h    | 15 +++--------
 include/trace/events/lock.h     | 18 ++++++++++++-
 kernel/locking/mutex.c          |  3 +++
 kernel/locking/percpu-rwsem.c   | 22 +++++++++++++++
 kernel/locking/qrwlock.c        | 16 +++++++++++
 kernel/locking/qspinlock.c      |  8 ++++++
 kernel/locking/rtmutex.c        |  1 +
 kernel/locking/rwbase_rt.c      |  8 +++++-
 kernel/locking/rwsem.c          |  9 +++++--
 kernel/locking/semaphore.c      |  4 ++-
 12 files changed, 150 insertions(+), 27 deletions(-)

-- 
2.52.0


