Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0178C10A3D9A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DD246B0092; Thu, 26 Mar 2026 11:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DD76B0093; Thu, 26 Mar 2026 11:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654F76B0095; Thu, 26 Mar 2026 11:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 494806B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14ABA52F4E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:25 +0000 (UTC)
X-FDA: 84588550410.09.4E5520E
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C23B100015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="fS1AnZ/H";
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="fS1AnZ/H";
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774537823; a=rsa-sha256;
	cv=none;
	b=GgM0MtYXAh+5VS/3T6Iq6tLLThMWW6pqp4SJLgb7+lr36KlwM6tWg3Z/4COTkeIozeYtGd
	Ji/zzA+G2RJH8xvbzgfH8FzRj8qCbUsuFZpDliVoVvQRWrZXkhUnw3mF5Il+a9Sg5C/Vpx
	5Y1kq7T4/LR4LQLcwsw5vIMOTD59FT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774537823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72ZUqls9X5Zxxy0EgcvU1FGMJtT1EgV5tBxL8foNtm4=;
	b=mq3G403cUZfJOwYfQS9eOtYtsM4u1CNciN63up01tyu758TiRAE75X7C7ANzqTYn/aU32a
	p8yneXaIFLNBlEsl7mc69kPw8oGIEUST8yKwdSjtYt2suZsLEqYXBfa/+8uIde4gexbP2d
	ppdkBdqcdt0xKSlwk+J4oPZGOvjLKkA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 21B38BDE1A;
	Thu, 26 Mar 2026 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774537821;
	bh=72ZUqls9X5Zxxy0EgcvU1FGMJtT1EgV5tBxL8foNtm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fS1AnZ/HQlSe70Ax1fOuyRM8x6rg4qhAT4E8gFsscQUcDFKPsnj2VF77IxipYcdq5
	 tccXuj0olEgX95inon7/ZI7w82wjSIIhdGV9NUfAXVQn+npzwnxxZFKMTKgFVBPLZZ
	 6ym8V9XEZznruRazOkrIVPFlXWgY/0r9ml7F0dXE=
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
Subject: [PATCH v4 4/5] locking: Factor out queued_spin_release()
Date: Thu, 26 Mar 2026 15:10:03 +0000
Message-ID: <c15d0462f57722aa9e7bd4fd4ec1b48a0420c442.1774536681.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C23B100015
X-Stat-Signature: sefupoz7trcdptknd5btsuekznghods1
X-Rspam-User: 
X-HE-Tag: 1774537822-967777
X-HE-Meta: U2FsdGVkX19PfhzpHw8n8su6jpuPJ3JJ+JbHn2o5k23OIMxwMpbihKjxDnjXY/K1hZLXBjsZCCoY/FCge94PNIRrGZ/brpl+TCfISjHyJnpojkKHTkd/12WftV/vCeESz6NYi4CVDLWOvM4hUOa0tePGxpZ+3J/eYL53vWD1Bn1fKaE4/f3O66fMBmLgQFjQqnt7vAgjor5GynLLpru63UCL7slocg6+0dndtPqBbRJ0nWnpmtHARzU7dvEpAld27e0y/uh2Ao43wrElcopO+kZTu3G9rKtxPLiMNjmziNxiDulbYw5HgaHHz9y9PaTarMO9kF2vG5Sg46HOyIIZpHzA4sQelf1YqWwcoDWOQAWQPzVUKg0m/CvGUjPxLynmqS49617YKbwscDNj1FoS19FA6qktleNEFPzcn7vS7L/VMUMX9FRoGY8lGQ35IetDiM3Edbx820VOpz2kn3JH+y6tMMD94v7ugvjtqiHd/WlbtsjhveXbrSVFbPvPSzSpnvG1X3qlur8FigxPm3w1xY3sxqjTWtcefMkceB/YJd8GIU1xLJiJd2qxbGvEdbXaLZOrqTNgynwdNq0EloR9IWYvasOQlYUWrUwwKmOZyIVdG1Ct/K4vFcWghff19gQc8dZOez4wdIlvy+zJH/2uM/NkRgMEVjnU5CIHYd9S6jATHlj1XIQWh9FIEWptvBWf9HBKi6BSF+IYvnPsRFXzcf38U0VOw6t3UrWeU8JVO0DsB89tgwLkAnDYbRZ7OSNOF5lKS8du+HefM41gCQEcfvz5ODzpPVUwc1fmJs0REl8Atl9yZ+hhVN5dTWihZQOH5M1DonvRe/OqGPsgzIoBEREh9v8jOXYbGndWWEn6fZZlYQg+Ms7ijHp0LyBpdqH5brRxt/Vb4fSOv/cnQrCqhKtgaUtnhYbCg9djDBjyk7elcySoh69BWlvNWZrF25YuWa51iZh0/vX8PrercJE
 Nt97D/tu
 A9NA0s68tjpe45SiLRHYqVKVJHEA7II5m+LuiK7j4a5wtFtyFDZRtKIt5zrxdc+RmI/VpmI1i3Tiq5jxQ8HEyw2kig508HcPYYjzNkKbNsXCJ1wQEPd+jFixtBzVhbBXjKTSN/68LY9PUSNtup9/x09Ieb5Np7W2SvZZn1UWq8BiZFPhyM5CmeS4jWkfSiWMZG3lknn6ZSWCUA4ZxaoLaM8S2zox5ymDHg/gPayiMLHwY0zeOGc/DoK9T9Ar2wV1s4ehSlPyRyKVr9bvXcNP7j8Q8UwHc307GVLjICtjcIH0QNHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce queued_spin_release() as an arch-overridable unlock primitive,
and make queued_spin_unlock() a generic wrapper around it. This is a
preparatory refactoring for the next commit, which adds
contended_release tracepoint instrumentation to queued_spin_unlock().

Rename the existing arch-specific queued_spin_unlock() overrides on
x86 (paravirt) and MIPS to queued_spin_release().

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
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


