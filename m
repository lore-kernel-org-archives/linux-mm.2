Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B964FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0876B00BD; Tue,  5 May 2026 13:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD27F6B00BE; Tue,  5 May 2026 13:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0986B00BE; Tue,  5 May 2026 13:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAC7E6B00BA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71A4314057D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:59 +0000 (UTC)
X-FDA: 84734003718.05.6A8BE61
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id A1DB21C000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OSHLOw1z;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INT5iVx0BJhEgv/8g1hlou4GKubElqnqSOStPxLCWSY=;
	b=BemHAO93SZ/nM6w8yJjBZ35uuj3PRVVpsIFxNN7skPKKJfOdscV5/veOn9VfPC1ktB1zHR
	8l51fiyi2O+gVSVbkvhgqxFt/Kq4Z8CecefJOPIyaqkHIeJU0NXdKWzbDXWSzyDq9PG5S1
	VX8jz1UL0EzLQKWeb0kl/KiEZc6F+xc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=OSHLOw1z;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000997; a=rsa-sha256;
	cv=none;
	b=BZDpQYgn4ofD7ugG2ZSk4z3GtlXPEYxvVc+EDewWQO9USICOf2POkDX1BwiT3MVMTL5cGX
	6poblRhA9J9YEWwymLpLxibmF1qGMVG3//WF+tn8pja+5dDdbSHS+cDxWGHnWudOaNDpqr
	FLs0K0E9Tcgrz3nxi7/Zh0exgvKcseA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id C1410D0000;
	Tue, 05 May 2026 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000995;
	bh=INT5iVx0BJhEgv/8g1hlou4GKubElqnqSOStPxLCWSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSHLOw1zDhJR+x0r5tP3lBldueD1O2a5vME5r5oHVcjUs5p8dH/1Yr2pO1Qw54Nr+
	 0YBFA6hi2CbPKnKzw+a/zlZteQUiGT6Leq4Udz8CuKYMktDxrfqYeYBrNnmfOv1Hrp
	 u4pXd3jpKmhYH2W/lXI6NxVpRBNQJybvo3y89KTY=
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
	Dmitry Ilvokhin <d@ilvokhin.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH v6 5/7] locking: Add contended_release tracepoint to qspinlock
Date: Tue,  5 May 2026 17:09:34 +0000
Message-ID: <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1DB21C000B
X-Stat-Signature: 1fz87hznefxa1gh7xsr6cumtxcj9nyju
X-HE-Tag: 1778000997-215494
X-HE-Meta: U2FsdGVkX19OwX8KOIgRr2sFk0GnRcX/KnVfJ+PaSjkczMxN/05v/do0qK2Z6xnqzBm9ML/Dcr2kcPwijQneujS10r71Ek4kj9nBGBHapFt2P4/aCyEoVwdaQlFd0LQQbfuTCgz3/Q40r3s1QzeNsjFEXIfLfzRu8zqbJT2x1RxPxN68IQd9RumoktOSq/A9FIEpHIW6l3Je8NyKsRZsbt9z/WRMpB8kJqkO2fBmVu48UkYZIXHbTL+J/BPBImwoMP8KvIA1zmI5spdfjMoicCkyx05uiKwpcbSaIeF38i063buBFcf6yH1V8Evt6+6X8yGxVDQCy4Uh7trEG57AqRaOKOEqvdnleC7N71l3J9rfa2eK/0VO4ZjsV97dBW0gN1zrueF/Rs/LAtULjbIjKeVrUs2kBNUzmondKPWhWwA5FBfCj0urBIdM/tibI6dnnH6pZp+XLS72oXytBPxGAaMO/V+5ZU9QDC4UgC9zQ8hCLUsQdqwjR1dltNU+5HAckbzfFu2AyOBnksPclfkXDBSsk8YSYWLnBwZytUkAWGCTzuQzluGaHrobdlX5ck+bwTcMVoz4Q0IQGeNelkiiPzjmrLa03Iv6mWEK9QHyZPbZcSDwE3+kSxSUMwWph8JscdWb1piihMW4YPhOMoMyv8G0om3HjLrex5lNjQxy2P/mt9gI858LLoTNLNVnK1ejkeD7ZHew/o6R/RJE6XVLXRyDNBHeBkk17wSWuNGL16QZX+kFwx+x5QIO73/1jUOMFX6k2myq34LqYkWAa7Tdac1L//HuYRKD/NnUhZHVpUuZ9k/JQ6C5VTkKnS/4GG3AW0wSYiuAb9bjEKrydjTTSfBJSn0/1t51YPmsJoj8e6ZCoyfRBZEU5BjtoDmn/He0R6Jxb32r5K4w7OaClephBWqpSM8Cfa0XhdWdN2bbSm5BPkrSn8GQoLsc735JJWpUXtYfLkV93lIqDkeTEgK
 QQnzEBoN
 5WsitI34UEZMpl5x31t0PlHWB8Qnmzxl7e8jp5bxk4IqgfXQiaeTSZjDqp2wKPBmo8VBpZ0vNehJyUG/blJLOA6XhhxJ8d05YI/ZPLBjVVpLa2yE+i8ug9fwU00ck9eICUIgIvOCgGdf7miwFJk25Ek9iUnzn2xLw7cqoo54Ee+LevBs/HRUe8UpwSDlwkWuJFtYltqSWWoFbz08B9+azFlrnnpn8ROiA80vdNRs6HNJzrNsGqRoyZ8MBKqH1ga3Qq2RjqE9I5qbDM7jrdtjofkrcQStO0GXS/UER+op/ZHxEPQCi3npHuXh/PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the arch-overridable queued_spin_release(), introduced in the
previous commit, to ensure the tracepoint works correctly across all
architectures, including those with custom unlock implementations (e.g.
x86 paravirt).

When the tracepoint is disabled, the only addition to the hot path is a
single NOP instruction (the static branch). When enabled, the contention
check, trace call, and unlock are combined in an out-of-line function to
minimize hot path impact, avoiding the compiler needing to preserve the
lock pointer in a callee-saved register across the trace call.

Binary size impact (x86_64, defconfig):
  uninlined unlock (common case): +680 bytes  (+0.00%)
  inlined unlock (worst case):    +83659 bytes (+0.21%)

The inlined unlock case could not be achieved through Kconfig options on
x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
inline the unlock path and estimate the worst case binary size increase.

In practice, configurations with UNINLINE_SPIN_UNLOCK=n have already
opted against binary size optimization, so the inlined worst case is
unlikely to be a concern.

Architectures with fully custom qspinlock implementations (e.g.
PowerPC) are not covered by this change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
 include/asm-generic/qspinlock.h | 18 ++++++++++++++++++
 kernel/locking/qspinlock.c      |  8 ++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index df76f34645a0..915a4c2777f6 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -41,6 +41,7 @@
 
 #include <asm-generic/qspinlock_types.h>
 #include <linux/atomic.h>
+#include <linux/tracepoint-defs.h>
 
 #ifndef queued_spin_is_locked
 /**
@@ -129,12 +130,29 @@ static __always_inline void queued_spin_release(struct qspinlock *lock)
 }
 #endif
 
+DECLARE_TRACEPOINT(contended_release);
+
+extern void queued_spin_release_traced(struct qspinlock *lock);
+
 /**
  * queued_spin_unlock - unlock a queued spinlock
  * @lock : Pointer to queued spinlock structure
+ *
+ * Generic tracing wrapper around the arch-overridable
+ * queued_spin_release().
  */
 static __always_inline void queued_spin_unlock(struct qspinlock *lock)
 {
+	/*
+	 * Trace and release are combined in queued_spin_release_traced() so
+	 * the compiler does not need to preserve the lock pointer across the
+	 * function call, avoiding callee-saved register save/restore on the
+	 * hot path.
+	 */
+	if (tracepoint_enabled(contended_release)) {
+		queued_spin_release_traced(lock);
+		return;
+	}
 	queued_spin_release(lock);
 }
 
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index af8d122bb649..649fdca69288 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
 #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
 #endif
 
+void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
+{
+	if (queued_spin_is_contended(lock))
+		trace_call__contended_release(lock);
+	queued_spin_release(lock);
+}
+EXPORT_SYMBOL(queued_spin_release_traced);
+
 #endif /* _GEN_PV_LOCK_SLOWPATH */
 
 /**
-- 
2.52.0


