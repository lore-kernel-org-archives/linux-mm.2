Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1638EF9014
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4866B009E; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13ED6B009D; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96866B0099; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D42A6B0098
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 228DEC2303
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:47 +0000 (UTC)
X-FDA: 84508984854.04.226B806
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5AB3014000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wSekldyQ;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T1+Xe0hpuwDVSwIdHcyHYuf9owiRaYKeAnBVPR2fvR0=;
	b=ibhNhw5GERmqw0SvgvfTrmbVL5nnnkzsy25icf7Qm/UKxaJoR/AXC1dhT4iBj4HnTAGiVr
	D7sargoHUen2beWwDh73u7bI/qe7C0gcxTL8300elWBB4dA3p1vfRHWH1B+WUSivZAV9fN
	dl5V/veYcrh99QFReqmadE7OWnrE2/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643405; a=rsa-sha256;
	cv=none;
	b=l4bDvy8ZHfC6ooQCq4URUASM9MbxxnTcoy5ZuOdPjFABfktMrfXFsh/sTwSyK5TM0nxetN
	sxDQRsY1uGJKGup/VEkDxJTZklVr15nIpyMytis5UX+OlwW3Zr845+zqXX3mgep86t3zvU
	6s/MVtIkzZUFBG6Df7CASXrwcutkH4w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wSekldyQ;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4C3AAB31B4;
	Wed, 04 Mar 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772643403;
	bh=T1+Xe0hpuwDVSwIdHcyHYuf9owiRaYKeAnBVPR2fvR0=;
	h=From:To:Cc:Subject:Date;
	b=wSekldyQBH/s5dnSI1CySpkLeIMgNgJZZhm/HGt4WUtqiZiYCQplr5K++GlCTWk1d
	 tgllfFIVZvMT1xHwR2g+EY7Vartths7ovlQQlcPwhRGITwrd7W6DfS4NbI0fjinznA
	 v3YSN/G2sZC/1Z2qlNy0OsUF6pEGlS4Tu5H6n3pc=
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
Subject: [PATCH RFC 0/3] locking: contended_release tracepoint instrumentation
Date: Wed,  4 Mar 2026 16:56:14 +0000
Message-ID: <cover.1772642407.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zq9pkn7fit1jeq4568j9cxrzzesc1kxg
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AB3014000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772643405-609739
X-HE-Meta: U2FsdGVkX1/GQ+G0baqhRbtFWWweDyNUTNZGNx2Cb0Gw0x1//UKO/1phgd2IvUPtsD68LWwu8exZH3lsfwljL0Dt04Xg/8kxIH72mwxcWSqWrwISpPnMwEcXSsTSNQsv9hBTettL693l6qFteu0IVbilXn6+k9zFn6q5R2AImrR+8iuP3n7HwHjbwBAsFnHEPt72CRwOAXN4odYKM9ySyuf9qZA/6Xyj3nriz0LtuyN3o2JwP1LXLoDM5IUjX6qrCPKahtM4cRPLhT+GW9INVegejTta9+CJZIX/yR09i7Radi/mPAY96kxb6C+U0hF9cakj0FJ6GDlz7jG0DJrt3dU++QyvWwKcwvcuwAZNR30x9ogA9+Nfpj0UF1Nr76ef8bS1GcaH5G24GAitdrn1INEqHi1aIsN9ztFxz4fSWAB8X2rLMjRpWCcKtsQR3E19lcQDUez31GPUdF5h//hvzJGr6Rumq+EZ2ExL60SMbu9ZCouklq91e0oi2KUvUafOtlEVA+a87tEisMOOD1L73GetfQc/booJ9EkTK/5VLwyHKS7DIYyxCP/wXD9n2tVcMaiJCZXK4y8WBZW7MRiDkLvtrDJIT6K6Say5z0mNTs0ObOZ97m8MHwqQDLRSxMH9cRA0vNUkYY4IXZwNNe6iUUupRV5H/YbzFXeCT9Ykc7Cle/GNg3PQKTFNzpZ+3kqCvmQDU5kRRgacUKwi+VkpYilUs0hEtgqsGqOJeeZNPlvPZ4X/wP3ND/UQEU2/fo0qv/q1ZUFH2OhOViPYqdG1m+lyx9XGanUfZaCCnqEHC+0D3j3d+ZknYLKS1Oq1EJ3eo+VIIubysTMlm94YR1/EOc3kkVoS6IHD4NzI5WoZRakDmoEYKW35eJ/t0i0Xtz8j17p1w4q4wZ43KEYBI9+q+YnOYtFyU6Jb/wAjk1JUatpZVLk8SjQCcpW21O5uIjGXO0dgdqqNf99WzBLRW0K
 fGl6QeP1
 SidWL6afyT/ECcPR73zWly9c95FXMmwNhFl8jushWE1xZfUzXnBVVf0nQiZ0iXX97CB57sRvcxhdF06H2BaA3LAaFqqMGaEdhGdGWgHyXWztUi0I1T6WVpE4wAO6qpGx1h9qz4879BKqKM3khF6XKJWx1N0YmcSljAWx4vFidvGUz9wjEqvMROdogB5H8W6XCn6UZgN2Pbg2Kr2WXxNhC8/etZe9MwKgC7d0uAb7zROqC+mg=
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

Dmitry Ilvokhin (3):
  locking: Add contended_release tracepoint
  locking/percpu-rwsem: Extract __percpu_up_read_slowpath()
  locking: Wire up contended_release tracepoint

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
2.47.3


