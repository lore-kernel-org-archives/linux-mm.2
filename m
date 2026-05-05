Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E70EACD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFBD6B00AA; Tue,  5 May 2026 13:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0636B00AB; Tue,  5 May 2026 13:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FE16B00AE; Tue,  5 May 2026 13:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE72B6B00AA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:15:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AF6A140572
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:15:37 +0000 (UTC)
X-FDA: 84734017914.11.B062B34
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5A67180005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:15:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1OW0Qc3m;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778001336; a=rsa-sha256;
	cv=none;
	b=j9OHxskGAMhoMFv7t82FpcTD525V0zlM7342G/OheFpyu8WaKGnLSueFOn9wn+bvz6AzFV
	/rExkR/JlI1o3wDU4LT94qb3p/OdD/XL4ZrIy80hj9lWBkMstLmo8eS9EC4GDRQWO7XdVj
	TAkEisUuPx1JCNxLL+enyFtSlDIMlPM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1OW0Qc3m;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778001336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x6FaQ8RAPWiFTMehIyIvGpXzwgZYwE2l4ogWqmfm5I=;
	b=vwWY7cff3t9mXkSbm7fm8uZZEcy3Q69gq2wWxQETcqUQs2F4wbAw7OxkqznG9O7h7EsgI7
	dTbi0qwaVj6alxbRXKuTK/zP+5YzjFejaBQUZO3vRa/3x4CpdROC1nFgYQ+Hx4b6kOXcuy
	DcIiVNRVcr0kRllX95Pxm40qQhrRypA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A1FB9D000F;
	Tue, 05 May 2026 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000995;
	bh=5x6FaQ8RAPWiFTMehIyIvGpXzwgZYwE2l4ogWqmfm5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OW0Qc3mLC4qVMBQ1Uc315DJ5RE3HdXkq8W9njLbvKRJQ08noQiB1vYfPi+KCYhwr
	 31pqiATb64htMJIHCUdBhkjmLNs49yVSXJkrXzmdhsqj62zVihyRvPPrrMxT3pARkb
	 4Mpf91HRD+GSXIZ31isxB5rn4U4bOLuKGOKx+XtE=
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
Subject: [PATCH v6 7/7] locking: Add contended_release tracepoint to qrwlock
Date: Tue,  5 May 2026 17:09:36 +0000
Message-ID: <b67fda8e847fff72da05eff7f799019f8d17ce21.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fpabtsabqkjdp1pnpmcpzbcettnai6cg
X-Rspam-User: 
X-Rspamd-Queue-Id: C5A67180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778001335-604278
X-HE-Meta: U2FsdGVkX1/OMr2XqojMlAKo1BtJB45slqNLuDyj1eL60g9ajTpwtRC/Lw0kaDT3+FaU7wO03kLBnsaxUo20OnSu2c/mLMv8BCR4NR3icHT5pYw7qZ27i8W6eSRo0+QOUejL6BVE0tX6zMiguA23es/ciKpESk87HZyU98BnOiMXhtje/Y4Ts9ao+0Fi88k3wbhskF5rvM9au3xuLv9p9v5DZErYKgr2fEZkX1x0ImPhGf6HK/gEDtHX3Al6DKoc/K1GJ1f4UuuD7Rgc9BoWfxYokTGN0kSa4sG/gpB7qDJHpjUO1hXXCBM6n6KuTgLHLruZ19IT813uJmb0M3OY39dOK+YahCOSGi9JwlXvPpBJCDwNuHPwSonVFg5wSzkSZoyKGoSEc7Rjo3eYZXzWgYFlXCY7sBuHQD8i0WIuz73F6pKxJy8fg2mpUkIFitdXECtiQ8PNpvhLQn7rUonlHtEqNGT3FH3RirpqKSWKzjNh9JFObv5DhbaTSkscNaUh62kWn8AUKO6VNThBROyukjicKo7sIvrDVapTyKdgVUQaQw7OSU8+siwqTO0dvqeDhnrmJrfl428yfOaZTiEupDjqrhzU3fGYj8nul/18HIO3c5co1AY5/od3gEBaBddUOyaWQjK0FaEbUCYaLoabw6++K+646KIRl5XjGu4ye9QVJv4b+/VcmXGyQavSH8fKjJufMyVUs/hyARHDLFQEKlroERrE9zhMwmCNhLBa/5FECHhi1bA5uf1KwFjhnnfkHkaA6wx56InywnwP32Vg1Uq0d9reO7tKSe991MoxxDmABYb5jL1Mbdg/Tdy94m6hJSZmkmEjcxknibJWJbPv/a895ybhGAFQukzb/o5rGG34TmcakAuUO9ydvQhctkJCx1XB7lsKIcVPhDFa5mT7oI+wWwvDaOg46jJbZKipzNLTaYfFZVqnmk+Q7vxxI7TH8xvJAqxD/QjgK2yCMrm
 KSSU2d6R
 73IILGkRtmxGfZgBnXv8e0076M+oScM664fWt15pnXyVPp9xvMH5E8xozGHswzBTRkz2mYGR832IcqVE6K/4Lpb01vcsIfWVhm9T6HvJC3kxs+AJ3X/52mNy3xONjRR0JuoMLQ9HpNlO/8WV7eAW1JO171BdtuG+yqmfPRQzmoD5iFnHwsIJVUkw6RPwyI9jfAFp+WCjp9owB8xA9NTXoDRNb3bR47/gEKI9pEP0xaG6popF/qTiMFBO5WqbPTKrvL5xCP7I3ppSgVe/K+UvRhMX+EVD5yvF/dXk3UlmmeNJDmg3gR7zIljK185kCicRDJJKgpE1NGN83nStwZ/yFpc9ytL+MmyauShrbAWvdHeOPEjs=
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
index d2ef312a8611..5ae4b0372719 100644
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
+		trace_call__contended_release(lock);
+	__queued_read_unlock(lock);
+}
+EXPORT_SYMBOL(queued_read_unlock_traced);
+
+void __lockfunc queued_write_unlock_traced(struct qrwlock *lock)
+{
+	if (queued_rwlock_is_contended(lock))
+		trace_call__contended_release(lock);
+	__queued_write_unlock(lock);
+}
+EXPORT_SYMBOL(queued_write_unlock_traced);
-- 
2.52.0


