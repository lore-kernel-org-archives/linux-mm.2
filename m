Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF8AF8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434076B009D; Thu, 16 Apr 2026 11:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E1A6B0096; Thu, 16 Apr 2026 11:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0137A6B009B; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD3086B0096
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D0A71A08F6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:41 +0000 (UTC)
X-FDA: 84664743282.12.8F84E04
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id A98BAC0016
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=NftkS5tz;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351940; a=rsa-sha256;
	cv=none;
	b=d9SuYgQLIIrvuWK5Lh8M6dUmlY/Ki+dsNwji/IK5eDcgkpWQRvZllr1DdHYSKfv4WrKVHo
	Y23cGo3hpoOlKguEFQ9uzCOW/+fV8rgpOzT1z6Q0n6mbDvBG9HSIGJdbMOzUx3PCz1/lnS
	ViUZs8YWe81Lu0TB50r6vJ1XSF5Vc0A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=NftkS5tz;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VNXsfwo1hWIpxn/gK53LLCns39qj3Tz5b8p/6O9yoc=;
	b=Mk5aeLOCOnoJecn99zhGOFDsZUO/Sp52eGQUccIF9aEbNAkFeLdTtZ7epqwgK8/MiL38Pj
	pVR7IV0MvwZT4JN4F+FoAbxzYg2WgjBIstnO7F+nq+oNgNA5hB+ezpNd2dzYVgAH+z1VKd
	WqkUPFuKblgBtjmgIVP/0qWe1z6NMOg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 09DCCC744F;
	Thu, 16 Apr 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351937;
	bh=+VNXsfwo1hWIpxn/gK53LLCns39qj3Tz5b8p/6O9yoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NftkS5tzXrASQNIrqYJxqv7yuKDzVytqt/4J+FFcCxu+RQq5ADLuajrMtGINxGj7T
	 nunbbBVG/b/KD91hn6VinZ1Gof65ZUG0LjUrkVC5N5hq8MeAnWYLXy6tbasbpkNFuM
	 +iB3XJIjf/JzdW7Di0ju9WhAvy4AoDwh0DB+Ui6I=
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
Subject: [PATCH v5 7/7] locking: Add contended_release tracepoint to qrwlock
Date: Thu, 16 Apr 2026 15:05:13 +0000
Message-ID: <f71b196c7877c57d6a1ab615cc1f470476f55938.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A98BAC0016
X-Stat-Signature: pntmc3tazr9kz15yein3ryq4eu9roghh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776351939-612085
X-HE-Meta: U2FsdGVkX18I22s4M20XnPef+GjBMU/DNcCtcn1cqSRWtKM08cNgX0vBk/9vLTv5EFv1Ef/boHoHwRn5l8E1kcaBhDAqIbdkaZIAN+7XksHU7CHJKJ2FyH6e2Ok9h3E7ARAxeEw2poUaP81eh5alXBcQchMzq/B4u+3FJx6kixX8zamq3Nn/R7Ei3Uk+XTbia8uuMKcjlNncvwW0zLsEXP6dy5V6TAAwSsDFhDecWY8ZsTvmQRnFJnbyMh2cDYQM+Nv4YDqleq+Z5CWLJowyx9x6V0I90Qq6Z1+eVdlaFvVDjFxEYm+JjVuSV3joxwouY8TgKt6p7iBNfe80iFnUcl6P/KHuzllgm605ZtRN1wHmp5gYH+F8IhYVEHNy7IlYplJoX8JMU1o2OotsMOFR/P26MS+wGipjBSDnu81M6jFG6VbV9h9nbMgBJiaYOzc0ggdQ0/uSxkmJAb5phFqiMI9CQVsLyw7Sj7YMNtq3HjdAbwJ0RuVRnaC0JmlkKBDypl+Lx+rp1FUpucLsYKRwKh7rI0XdfhkW6G+GW9Gk8cqqcU4rL+P9Kbd3PaMiWR4RVwYU2dhRqvylBAMJS5LglRaF44A/LOh5hkalNmxw7RC7d/ZAN4J1cR23mMpRNvjfWhTwpiV4V5woVEFwqyclGo0X1ZGIfkif8BhGpDsrhGolACDjQGIeMXRVwR3XfvYnkiHcms9cq73LSA79VxEXLBhHui1Q3whNaW8Z2x8jl7MuD+Cd7eD8MlpRxWguoiASXYQhvbARB5roTNz8PBFxvscS4ZCyrrVE/up7+AQsHE2DuPpSPN8a8McuybOJ2PBt09U7Kcu8H2CPsTuaObMNzyKh7F4rT+hUfQOsJ+hhJ0xlgMf6qfg1seFLMT8f8e478ab+E4WZasxPFIXtU1GarA0nwmiSTsbDGA0+nDjm5CzuYSZ4ITceMtipYGl/rrsELRGJ3MK8bJ/qoKSgUc6
 N+Qkccm8
 tdlpYT26JuduHr/EomKuR++8DbQOWCNS+TJeAIbRXOUnkjsXq7pDpzzKFPfSZO5U0TYBCaRcGZFDUyT3DQmoWNCHwyvth7VlF4tsvLvRIQguM4/wV9MADaZ1xcAlO+neRadBo+KoojEj5SJZZ2LW2D/5cSvZKeFkIVI0Xrf7pdLdLQc84yJUQFCT7zXnVPGGQPSZ6Kkv7vbALUzBckQ5V0AwqjMsWrTfkfYgfsPYE0/24GaIBT/Xow8I6YyM30JA1ztkuFUcLpFg2dBn57jZBOUsVJarTvswFcVLbxyWEm2jAduaVWQ1coH/ltzKvZx0Cper02TsM1P3UWRSa5KDimlioIUOxB4L5NROj9Jg+RYes4wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the contended_release tracepoint to queued rwlocks, using the
same out-of-line traced unlock approach as queued spinlocks.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/asm-generic/qrwlock.h | 22 ++++++++++++++++++++++
 kernel/locking/qrwlock.c      | 16 ++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 4b627bafba8b..274c19006125 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -14,6 +14,7 @@
 #define __ASM_GENERIC_QRWLOCK_H
 
 #include <linux/atomic.h>
+#include <linux/tracepoint-defs.h>
 #include <asm/barrier.h>
 #include <asm/processor.h>
 
@@ -35,6 +36,10 @@
  */
 extern void queued_read_lock_slowpath(struct qrwlock *lock);
 extern void queued_write_lock_slowpath(struct qrwlock *lock);
+extern void queued_read_unlock_traced(struct qrwlock *lock);
+extern void queued_write_unlock_traced(struct qrwlock *lock);
+
+DECLARE_TRACEPOINT(contended_release);
 
 /**
  * queued_read_trylock - try to acquire read lock of a queued rwlock
@@ -115,6 +120,17 @@ static __always_inline void __queued_read_unlock(struct qrwlock *lock)
  */
 static inline void queued_read_unlock(struct qrwlock *lock)
 {
+	/*
+	 * Trace and unlock are combined in the traced unlock variant so
+	 * the compiler does not need to preserve the lock pointer across
+	 * the function call, avoiding callee-saved register save/restore
+	 * on the hot path.
+	 */
+	if (tracepoint_enabled(contended_release)) {
+		queued_read_unlock_traced(lock);
+		return;
+	}
+
 	__queued_read_unlock(lock);
 }
 
@@ -129,6 +145,12 @@ static __always_inline void __queued_write_unlock(struct qrwlock *lock)
  */
 static inline void queued_write_unlock(struct qrwlock *lock)
 {
+	/* See comment in queued_read_unlock(). */
+	if (tracepoint_enabled(contended_release)) {
+		queued_write_unlock_traced(lock);
+		return;
+	}
+
 	__queued_write_unlock(lock);
 }
 
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index d2ef312a8611..5f7a0fc2b27a 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -90,3 +90,19 @@ void __lockfunc queued_write_lock_slowpath(struct qrwlock *lock)
 	trace_contention_end(lock, 0);
 }
 EXPORT_SYMBOL(queued_write_lock_slowpath);
+
+void __lockfunc queued_read_unlock_traced(struct qrwlock *lock)
+{
+	if (queued_rwlock_is_contended(lock))
+		trace_contended_release(lock);
+	__queued_read_unlock(lock);
+}
+EXPORT_SYMBOL(queued_read_unlock_traced);
+
+void __lockfunc queued_write_unlock_traced(struct qrwlock *lock)
+{
+	if (queued_rwlock_is_contended(lock))
+		trace_contended_release(lock);
+	__queued_write_unlock(lock);
+}
+EXPORT_SYMBOL(queued_write_unlock_traced);
-- 
2.52.0


