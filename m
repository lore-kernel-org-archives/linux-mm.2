Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E670F8D753
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829416B0098; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73FDA6B0099; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A8C6B0095; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4376B0095
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB1FA13B99A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:40 +0000 (UTC)
X-FDA: 84664743240.17.D15D8E7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf16.hostedemail.com (Postfix) with ESMTP id DA54A180013
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=3TJtPhEi;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iNiXafam+/e0hkdJzF6nIr0O4d4HoUoH1x5V8VkIAs=;
	b=eOUO8avaPT8V0127RIUsvSz1WjC1vRSm255/0du2DHpxJH0MfFvU4YM4WVDtMtnSmDblV4
	LpR4/8sY4q6e6X65pwoPxYtpsskaqmgMzmdbrOzLGLDYa6Rob2TZD6gVgTsqyF8sDpwBMs
	+8I25Y5a4sKU5Z47859fjevprTdS6Xw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351939; a=rsa-sha256;
	cv=none;
	b=hUGeuKRWBdt07t+cLRZoF09lojIbuwAhHgNlG5lxaNKkv2dZ2ldetEOsZeDNzCMGXIuMjr
	PmqGo0VdGLHZOqsV6pEZO6XyxumobdNn7dHUWB2H6W0UQqWJAjKwFeNuMzqdbfI0TI2wTf
	8R/RHAsGWlFHvI0UvE6C+jturbuAZ7w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=3TJtPhEi;
	spf=pass (imf16.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E322BC7442;
	Thu, 16 Apr 2026 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351936;
	bh=0iNiXafam+/e0hkdJzF6nIr0O4d4HoUoH1x5V8VkIAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=3TJtPhEirfgcM4Mp+y12OqqpCtgrlTu1gBPbKH4woMmwhFIrlBuBkE+p1sj1IY6LX
	 VXfevcdTXViMWKZf5xjTMP55D4UuU2U4KJatrcLuegUo4PXYEVFK2I/0DsdYv8rdx8
	 JJh4+06+hN7Upzg2Fhqyelg8VEIR5mC+LY1T15cg=
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
Subject: [PATCH v5 4/7] locking: Factor out queued_spin_release()
Date: Thu, 16 Apr 2026 15:05:10 +0000
Message-ID: <e42c5d27d82b4ba083b91a0413b2046b0959f5b7.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9iz6qxc3grppq3ns9kf8awox76ee6kxy
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA54A180013
X-Rspam-User: 
X-HE-Tag: 1776351938-575560
X-HE-Meta: U2FsdGVkX1+3Dk36aOo+b3PhiuilWVIBfMUfcaSEuo2in0R+gJNt77bdCnPjNpZ49wJ4ZcuYh4za7hAwRe3QIGrNNZFsO1FmAegtEvQN1spNlXnxXLCC2BzVHhBXmt3KZ88xI7/YSOWKmwJwp3T7UCDY9UESj3tlYjg64fc48AN/BXF27Eh/aAQRxjfEfP2DUsu9yV0DPNLPrKTLU1yLjHGM13FecfOySTIj57CZP2PZPUsIqMhnEeppclom6iDcwdMZ8G+vmLE4Qd0uNbYewgqYId+t3LNknFRw5xMin6GPM9PkIKsbnSve8bSr5oy1KM9BYs6rW85ajZBE2/gcBB4zliaOKF2AuIm40909c7KyRAyHj21QrlrvZuriVkjvr6YeACND2mwBvO24vGEcyuqavv9+TwjttQoM+sLbpZW/c54xlksG17b1b+SPE8Aj06cc/cFKzqthaQBgTZxpKuo1ku62vprK9p3tpxL6rRKpHWNtRTwG15/wiDQKnB6Qzj87t2Eo9Tk08Q4N3CG3I83vwOAtqztDxc/dkQwa6cgZkqjxvUT2+tLcrTrXMHFSHomRHcYkkmXXfQIja4LWKbpVtcRlDadALn8lH7+mgWQQnSSuvK+gVerNssw8dIMUMIZi0uUM8H0Byx6vJx2bbAgbNQNicRWIf8JBZmq387RDYhTnLcKBWOoB+FiI9AMHzIdIe1MXxrzgUltdf+Ngo4VRPb32SDfLDtQ+2PLNvVENRACaRS5Aw2kIC512OBj/L8EE9T/Epymk34ZwbU7nTgD6MduUh2W+QCUEpkwuVyI5WgaTq306engHizezQ7FVbjUoozdbkGlm1VNtCImqcqnkSqyS5ly1O2groJkKFpdfGmbrjDfiamnRfmik5mvg0ZA1C+YgOBl70FgbVWbupiJmKfkjIVqjhpvwC1D3CpaZEaN4f0XNRg6kckWH5l928ngmqOIlp+/VRFUwkp6
 fqZtcpcI
 1rPKWGQawTwMucK0yhxPYretIBeEJ3zxyH10VDwaoh5r9IGmiICZ3mfqp37CUsl3efnZwR8ynOUulkUHvQpJ7eZoVf56ayD68hcuONr0S61+vteyKU0fTk3eJfOg/O94XtoAESniwU4dahyQifzsqil9AIL8+GbYZx9uJdLRoFATZ7nKdvkf3n1f/z5i37iSwS9HoEvH5zgN+Eu7vIgB5WfrC2U/hVvTYLXyKsd3/NlF9UEtgish5jTCQMFZaVJwrcWXTz+w73dWGSHQGqtISwxxp3AIJ3gntOh3Ych97cvegItxhWp5p0BSJ9lqJa5aMlROW
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


