Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4104AFD4F08
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F326B008A; Tue, 10 Mar 2026 13:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D90B6B0089; Tue, 10 Mar 2026 13:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1E56B0093; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1B556B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3631957A86
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:50:02 +0000 (UTC)
X-FDA: 84530891844.12.80A9D57
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id 66DDC180010
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:50:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=qEddDznM;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GipfqqlCII/Hem6pBQgM4xJOjMevRQ0ClZajmMmWO00=;
	b=Hbnyo2c9y8k8gRgueHyYXVJSbpHvvEU5qLeBB5FnPWTt4d4WueYBOLHjwK2MUN3SxwQFaF
	vAt1kbTvYCAqHMz9921Sigoo/XxFKms3Owdiu9gc4UQX0eAnehYhyQp+8M0DNweUMhPIh1
	hBtd3f1/amVVjiolRfZxY1O+GKMmUJ8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=qEddDznM;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165000; a=rsa-sha256;
	cv=none;
	b=PE6O0oVk455ybGOZ8Q4m1PvTxj4JETguG86hCOswSj5E0OEIrmaM8v023kWfm8//t/jzUe
	Kj+24cKSZGQxL+V88WBA1SJ5W+5T0B7EQzpCLL9cGQHVSikDaQz5Fg1WDdwB8lB6pgMJ4z
	ydC0A5qV6+iHFV65NLbFeCgbp3ZcRh8=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 70785B3827;
	Tue, 10 Mar 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773164998;
	bh=GipfqqlCII/Hem6pBQgM4xJOjMevRQ0ClZajmMmWO00=;
	h=From:To:Cc:Subject:Date;
	b=qEddDznMfx2OlOzDi8Qf5nLRp4E88iy5IfYfzYbDLYqQcehpWTY1A89JDuPKVZZjO
	 YUKDR7edSb1qsiGWyHSGZF7PDZstf4Gdt7VS2EojefP2u/XofwNRHm2abz9/b27cMn
	 Djob0d8DX05vQlflLLjbgMJWnWnC5IbGpmEZbB3Y=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Dennis Zhou <dennis@kernel.org>,
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
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 0/2] locking: contended_release tracepoint instrumentation
Date: Tue, 10 Mar 2026 17:49:37 +0000
Message-ID: <cover.1773164180.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66DDC180010
X-Stat-Signature: dpgzmym5czyshr9ujtenafhb6h3zkhrn
X-Rspam-User: 
X-HE-Tag: 1773165000-481026
X-HE-Meta: U2FsdGVkX1/yal5WzKLt3/D1yhXO3Q9A8pnXg0WO3PQDllgyJNV/iPk+nvKt1CRsB+CmYFzfdZw8pcIBpz+BPo2I8+xH7P+3ipdBnJRXFZgHnZPn2HMTij+agM4WMO1MFXij7POdM+R9pfPHh3BY8VB3owiww8TW5aEtAB/MJx0j6/jFb7Zw/NN1Bupq/lgbP7JEX3JwmVmLWaYFPnhz9AZuZhpfNEPP6D3RNuU3YYJE3TTvp8OH2O3dSizwX/9y14AO9gF79Qb1EpztuyUOVGZleXtCqA4erACIB8lnvUQBT/Iu21QL0sVq8ZhbXdCLZjexDf2T7dVvbvs5WPyaJwWvzQEmt9TAlD8VpEkqYtcQpxygXN6XlzXbII//7Y1ocyT4j0ewNigKF6WaZnjZ8A0fBgDkEAvgXPrsEYSQhOtVOUubhG2PUNPaeEtwSSVghdSnB4Ue0ennUsD2g+f6LAA4qC8Re9Wjtyb+F/7lFITzZ/E0x3TQGFDZiVuEVVMVwvijuyyfwdoVk7NkgGJplV4ctH4lYm3o6VuSc5adq6C12MGPlfrT1u8DqJC0kOTahogRxBUFAKSG4Ps3B4rtyM5rjd0vYVFxKxgTwrRPxyptUoT6hs6F3laAaT5AoXFu4ykIKTHD1UZ2t5w3NHmab25DIWHP2yu4yjkWXE2RTfwAiJZINbo6xQ4W+ePaX8zcxCHeMVRUshh2TXpk+5554YNQHnHiPFhB4cLH+TuMlfepKkMmX+IS/SOuikwUE1XO4EbA/mBZiV7HjLxp4eDV/SmZusPxG9J2B3sCeTW226zJc4OXIME6eJKjZd5ak5J1bZMvdQbly33oMccTJ+WVLIR9UkkE9aCDXzb5opqJYPbi08oGK9P7FjuM/dGtrxZnjPZw6ozNv24m5HYY6IYRBfWUxerr8iLIZIaFKSvZkg9uHxXUSfEqc1KpgZ/OjS6PH7mdkfp13yBT02/DpnA
 88Kw7sC7
 Ri5cSjnQDzG5XFcm8aKbeDye2bGs7VMmv4C7o9HuPD1QCfIJi04Fi1uRybpAYuakMm/nhIZSyycZBFuSdggwDP/ubT44SiFqepbXxX2vlnmyXYLbUkVhtKrH3CTv7MckFQuFLspTWnDqblAYBlaxbjrdQUcokh2uwT4d2rd2F7T8gv0S3e7virCoZ9we5vZzQ+cbAIDf5hswGtbwYzuqf+z8zaN3g1th7uDTnULkOnkN7Fz5Z5MUzAUABgAjAqdFekAAApnuSlnmqD7Iilnaxpe8S5hB/ldTf3R2Qyxhm+jxt779/5dgvh8Rexg==
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

The tracepoint is placed exclusively in slowpath unlock paths, so
there is no performance impact on the uncontended fast path and
expected minimal impact on binary size.

Based on the feedback on the RFC, here is v2 with the suggested fixes.
Since there were no objections to the approach, I am dropping the RFC
tag.

RFC -> v2:

- Add trace_contended_release_enabled() guard before waiter checks that
  exist only for the tracepoint (Steven Rostedt).
- Rename __percpu_up_read_slowpath() to __percpu_up_read() (Peter
  Zijlstra).
- Add extern for __percpu_up_read() (Peter Zijlstra).
- Squashed tracepoint introduction and usage commits (Masami Hiramatsu).

RFC: https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/

Dmitry Ilvokhin (2):
  locking/percpu-rwsem: Extract __percpu_up_read()
  locking: Add contended_release tracepoint

 include/linux/percpu-rwsem.h  | 15 +++------------
 include/trace/events/lock.h   | 17 +++++++++++++++++
 kernel/locking/mutex.c        |  1 +
 kernel/locking/percpu-rwsem.c | 21 +++++++++++++++++++++
 kernel/locking/rtmutex.c      |  1 +
 kernel/locking/rwbase_rt.c    |  8 +++++++-
 kernel/locking/rwsem.c        |  9 +++++++--
 kernel/locking/semaphore.c    |  4 +++-
 8 files changed, 60 insertions(+), 16 deletions(-)

-- 
2.52.0


