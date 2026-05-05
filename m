Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F0BCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68CE6B00B9; Tue,  5 May 2026 13:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19CB6B00BA; Tue,  5 May 2026 13:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08856B00BC; Tue,  5 May 2026 13:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23E46B00B9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6296EA0575
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:58 +0000 (UTC)
X-FDA: 84734003676.18.7490FA2
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id 84A634000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=NddL6V50;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iNiXafam+/e0hkdJzF6nIr0O4d4HoUoH1x5V8VkIAs=;
	b=SjVRyOHpqrU5FTI3ozSwnoiAKaRFnp7/8AmqUAv+sfcr80Wbd3Ev1pFVhshea1KiqxD/t0
	JgXRviR8rDcqMP4L2/4LIRKkK1PPyisAoPrb5ka6NakZeOJQ3fOxWge7dcujiEoq3Bn2b8
	9wgGyer8fx7Bu/aCGr4bNiJ1IE0+3Fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000996; a=rsa-sha256;
	cv=none;
	b=W2O+YU5CidR14LIsvu34Zj/Rf5ww0Pc7qMkmYVUC1fP3uEufNIs2HzTEoBPbjE9IvGQKzn
	veMDHcsV546MAU6NB877Ob9HPo9uxIGp5gSecNghtw1XIsQhVGMe/gcd0xyfcq+I3iQ4QR
	fvhm15mv3Jp2gpxQOLsA98HThMCkANU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=NddL6V50;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 5D462CFFFB;
	Tue, 05 May 2026 17:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000994;
	bh=0iNiXafam+/e0hkdJzF6nIr0O4d4HoUoH1x5V8VkIAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NddL6V50gn9QHy1qO45QfNnsCGY22x/FGJ9pE4goYDRaBNmo5J1FEz/pCZ86C3hfQ
	 bXOIi3qyfbj1qjkBuNbWqzN7Yja6FSueSZPaV5S5oU1HXvzY9z7SUhaiQWQKfOUvLe
	 QG3eIABqUNEWkkCnlSPfPahP+NN2+iFMyyJjTW5U=
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
Subject: [PATCH v6 4/7] locking: Factor out queued_spin_release()
Date: Tue,  5 May 2026 17:09:33 +0000
Message-ID: <64c202b8a76a7d98515cf10cc1f99ecb0a9a7ccf.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84A634000D
X-Stat-Signature: yc6f7e8dp5mbg77ufm51wg1x8hsqu1f6
X-Rspam-User: 
X-HE-Tag: 1778000996-137037
X-HE-Meta: U2FsdGVkX1+WP6JYP5G8XodalRFvqtH7GWKUjkrQKh1EqHhXw2BmXPwHa0xsOhBPDW2ztr8JB6EqFW5DnZ9TxJp9NALcO4iN3w79UCVX/CDJiv+hTYgtP9pZK5lxzgA7ioSMWNuGXZeVmvGUq2bPrX1qFmku0Ig/G4m7+eQcQeZ4OD/xO1S6WGGrtYy3q4P4fVKPRxZyrpAVl3gW2+264NIyHzlHYOj1IEyJckwwsbcJSNw6jsVQnkt48kTdBuFXf+xO3p1hLwKlpeizy59AEAdLjk6dZH7LlGCJNkRYlC/FA+zMidwEwiarZAi2c67n5a3i86QSwvefbno+MaMGg7SGVEtqMrYeZqWwWejQIB6du1jLUWepaIKF7jPZgSoqqNn1IM+Zn3A+jd5P96ZbAfNnUKIaDyAcYHiayRaV78oQKc2FWHtGDI+Nqxtl6v4j/OueGgsJ3Q1DlEX66tWFCrEbuQEfgyeCxiZ9h0ed2hM5+VhDxZE9E39wMosrF4bSXpZu+iGPqjtfksHUaG4UHzAO6wCYcZWSCcpJWQZzPkkjXp/l664CpZ9UOpjjfchJkYul5w1Q0LD6HMAGDOBz/gIaSN08d9B+MEX0+0X/eQbWiaHffTSR/FRdUxbIAUQdBp4E7mAXVML4Q6UOs1WmQOMjJn0xjC9RvwS8qDi3XVOkN/DWrIalqamy3uTy/2rNNWoNP5HSiH1GmFjqbVqruOiSzWjhEKa6UqHEx9c3Bz149WP6SSnDNOFy4ZJ78OfqD0tDrnuRsfaW1VEEKjk3pjmpRu/xRmIOb1K3aREzMQMCXsG66Bl9Tn6I/HKuzpBbMjUBbdCoyC6Ma1I0l7QktvT2zj52PdENxQIKASFe0+d/4Pv+78zXdWrz99mtpYIMf4Wb3hBgbJGaRVU+UIM84akVLf1EBVOrxDbTnEdzbG7BUP0d/rQCuAIXKmCI0GMU+pdjbEtNO87gNQjFjgp
 JWyn3tx1
 ldcGF56QOgZFd3cgTPHaPhQXRqmgNAterl+GB08AI0KEXLon3VVfzYu65islLV6Y8j/5aQOJAwD59c4Ct3FtBxoadYlSmaw99w2QkvflqAD2f4Zcf/3i9UfVreFa5HPUZeciDe3TQHDrlAMee+Z515C3ERwO2JWLXiY8geR29AxnMz3mA0gC63dfgKaFVN0xj5L3ApVBTubNTA8EUxn15mQIse/D8qCTY1EWZtbMYUkHaOUHHtgDmMFACB3XgM97wzczp70PM6+RfJeTwj44lqEFAqcW/6fU0by/cUnug6T/lJFK+ExJD8Pw69/7dNEM084Q9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce queued_spin_release() as an arch-overridable unlock primitive,
and make queued_spin_unlock() a generic wrapper around it.

This is a preparatory refactoring for the next commit, which adds
contended_release tracepoint instrumentation to queued_spin_unlock().

Rename the existing arch-specific queued_spin_unlock() overrides on
x86 (paravirt) and MIPS to queued_spin_release().

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
---
 arch/mips/include/asm/spinlock.h         |  6 +++---
 arch/x86/include/asm/paravirt-spinlock.h |  6 +++---
 include/asm-generic/qspinlock.h          | 15 ++++++++++++---
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/mips/include/asm/spinlock.h b/arch/mips/include/asm/spinlock.h
index 6ce2117e49f6..c349162f15eb 100644
--- a/arch/mips/include/asm/spinlock.h
+++ b/arch/mips/include/asm/spinlock.h
@@ -13,12 +13,12 @@
 
 #include <asm-generic/qspinlock_types.h>
 
-#define	queued_spin_unlock queued_spin_unlock
+#define	queued_spin_release queued_spin_release
 /**
- * queued_spin_unlock - release a queued spinlock
+ * queued_spin_release - release a queued spinlock
  * @lock : Pointer to queued spinlock structure
  */
-static inline void queued_spin_unlock(struct qspinlock *lock)
+static inline void queued_spin_release(struct qspinlock *lock)
 {
 	/* This could be optimised with ARCH_HAS_MMIOWB */
 	mmiowb();
diff --git a/arch/x86/include/asm/paravirt-spinlock.h b/arch/x86/include/asm/paravirt-spinlock.h
index 7beffcb08ed6..ac75e0736198 100644
--- a/arch/x86/include/asm/paravirt-spinlock.h
+++ b/arch/x86/include/asm/paravirt-spinlock.h
@@ -49,9 +49,9 @@ static __always_inline bool pv_vcpu_is_preempted(long cpu)
 				ALT_NOT(X86_FEATURE_VCPUPREEMPT));
 }
 
-#define queued_spin_unlock queued_spin_unlock
+#define queued_spin_release queued_spin_release
 /**
- * queued_spin_unlock - release a queued spinlock
+ * queued_spin_release - release a queued spinlock
  * @lock : Pointer to queued spinlock structure
  *
  * A smp_store_release() on the least-significant byte.
@@ -66,7 +66,7 @@ static inline void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	pv_queued_spin_lock_slowpath(lock, val);
 }
 
-static inline void queued_spin_unlock(struct qspinlock *lock)
+static inline void queued_spin_release(struct qspinlock *lock)
 {
 	kcsan_release();
 	pv_queued_spin_unlock(lock);
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index bf47cca2c375..df76f34645a0 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -115,12 +115,12 @@ static __always_inline void queued_spin_lock(struct qspinlock *lock)
 }
 #endif
 
-#ifndef queued_spin_unlock
+#ifndef queued_spin_release
 /**
- * queued_spin_unlock - release a queued spinlock
+ * queued_spin_release - release a queued spinlock
  * @lock : Pointer to queued spinlock structure
  */
-static __always_inline void queued_spin_unlock(struct qspinlock *lock)
+static __always_inline void queued_spin_release(struct qspinlock *lock)
 {
 	/*
 	 * unlock() needs release semantics:
@@ -129,6 +129,15 @@ static __always_inline void queued_spin_unlock(struct qspinlock *lock)
 }
 #endif
 
+/**
+ * queued_spin_unlock - unlock a queued spinlock
+ * @lock : Pointer to queued spinlock structure
+ */
+static __always_inline void queued_spin_unlock(struct qspinlock *lock)
+{
+	queued_spin_release(lock);
+}
+
 #ifndef virt_spin_lock
 static __always_inline bool virt_spin_lock(struct qspinlock *lock)
 {
-- 
2.52.0


