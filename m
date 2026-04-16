Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38A0F8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3A26B0096; Thu, 16 Apr 2026 11:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431DE6B0099; Thu, 16 Apr 2026 11:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3C56B009E; Thu, 16 Apr 2026 11:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08CDA6B0096
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B71031608A3
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:41 +0000 (UTC)
X-FDA: 84664743282.30.9BE3467
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7DE718000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ZJ0D+hte;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntzklD+dlafRxc2qQ7RauvHyr8rVOtuWoe+2Ne6//MM=;
	b=3suBRsnpMNyS1UpwK41HRcr4YWm8rgGLBih92XEMCVqE8Nt7ScuVdeFzjoPWzlm5/JARSG
	WHvzlEhopg/IzIY9IJ04Pt9T1HS64aF0pfef5vuvgGL5dgrL/77Q5hKVn0UHx6s5+xofkM
	aIWQ0hsYnTvuJ3UXeD2atfPE5jAF/y8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ZJ0D+hte;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351940; a=rsa-sha256;
	cv=none;
	b=Drh+ol4Tr8Z/b1Ckon0gstHDsSqbiLoOqRmpOSCVAXo9yLmz8B/FJnNhLSg8lUnmexCluV
	I53v9ONUzMwzbZLDrEX/y+b/auQN1JblU/3fQG2Mke8jjDv61vYGwzHEAlEymrwv3yXjw2
	t8lsP90SxT33Ng+E0ft9Y1dkiLnKS2E=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4610CC7445;
	Thu, 16 Apr 2026 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351936;
	bh=ntzklD+dlafRxc2qQ7RauvHyr8rVOtuWoe+2Ne6//MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJ0D+hte6v21FBtB159stP65D5edyBCtOztjwIJ4B83RE+6twBpRXQV/ufulR85Hr
	 xv0/3D8s8xhx7NnpT6mzB1U7KkZNmkDnMtWl880ln3z99TkM6GOfYQhfSwno9ljTG/
	 02QN2PBrMtUtalpoGs3NMaYrhkh3/0jPjrUp+xFQ=
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
Subject: [PATCH v5 5/7] locking: Add contended_release tracepoint to qspinlock
Date: Thu, 16 Apr 2026 15:05:11 +0000
Message-ID: <af285ffefa3fa2f73b73a39e9f06fb176009e047.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DE718000C
X-Stat-Signature: gaw98xhzb46h5pp1csknx3z6zwywsd1d
X-Rspam-User: 
X-HE-Tag: 1776351939-547777
X-HE-Meta: U2FsdGVkX19REHNTevLw1qqaulI0mmJ/wSc65cNn9uj+47Rd2+z4kz2FMQPRb+gwOxGVLsfzWf24TjryJZETdnlWB0TsOOtO6xGaIBNCLi5TBKobquV81KRrwnN4Z6wU7K3RBqgKq89EgM/9gkkxyOCotqYQ83yR+twCdAidVwDpvRqeVeVpKTTxdVaWToFPHHDV+pvD/acR52D33OWAV0VCEuhh6vqnjigFWWEj6BUpjp1YWQuYmbIhTCZhN0hncQ3LGXLmnzNY9sOEhAxyYiSQhX7Gbv0sgUUYZ2BBD2K8FofTKck97VQjVDXxU2oZelApQt4d6N4u1Z/7CN4qYZL3eSfIMZowjKpxtT5vIoK8jqGDtABuy6ImAzJD1pnDxgFy9IeWVNKvX6N9UDi7TXtCdvLVR5QPQQOq2DUrxnvuqFsatDZcgmH3P2YZdw+DnwdLj6JZn5AKWTkOBKvmN7OkEsrm+lP3jNMwpNPH6ERAfjZi5Gm85UxRJxCwQCnVuCH0R+lPAJXTl46WkOr7e9x9AAu31KiCWaUKOgUlPtyMyXnvMrpXe8D2RWXt1KIMjlssbHR5t7gQuokXXNYisd6GYERgmXfcEHqGfJLzOWyBcjICvJtnF1rtphiJA2hyjGC1y2RX3a/okpSFARkN7Os3VE84dQ6KrFrEIR8MZ98fiJEhxelVD8SBpNyX02JLtHVkPFd3B7MpTKg2IgCEOXKq532ZombDnQbkArH8uxDDU584xEIFJ3WtA0fNk03NCNIU0sc/+3Hk1WWOpLikCbHfDblcfLgj8+rNfnaghnGZ5iWr1lSP6hqvSKDLxFAzkdpl66FK36M6id9RCgoDzH5da622SiijVGuBziQt0Ri54/O5rU1GFyuMEpia5zs1dryZrslGY2iz7I+o85EXFrLW5T4a37QXvCllwD7VVGdFzhXRwXPgOX0WrOkovf6nrK5oTlJTZWMjdK+bQE+
 q5RMV/XR
 g1o03aymgXzszgTbvRESQ0tIWwuL88RALuTD/6q4Vh8pc9VHV7hAhd35GG12HLnk1Wj0hJUldePotFwJ+pM9ds0C2H0WxB3bC/mVzYE7H5zQWW2Pzw7Q9W+CzMk5QR9tzKHXzA1JcILvZ5tmTvDKl0PEzxZZHY0d/bAeQCk3vILzgXw8q1O2ZSh0wa/V8Xv6lEs5TeJbjbx/nl/ER8d0CKfnPllwU0Hubg8IMxqtBreHh5UzOKNRXXEGFa4jB41Co+s+YLJmdAv85hdJkk4kTGZ1wVF5ba6y/ssvYXVoth1+csmOxn/SdBnpFqRBNc9JMHzdASOGYszwEWQU=
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
index af8d122bb649..c72610980ec7 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -104,6 +104,14 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
 #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
 #endif
 
+void __lockfunc queued_spin_release_traced(struct qspinlock *lock)
+{
+	if (queued_spin_is_contended(lock))
+		trace_contended_release(lock);
+	queued_spin_release(lock);
+}
+EXPORT_SYMBOL(queued_spin_release_traced);
+
 #endif /* _GEN_PV_LOCK_SLOWPATH */
 
 /**
-- 
2.52.0


