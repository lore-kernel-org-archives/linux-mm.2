Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1615CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD026B00DA; Fri,  8 May 2026 04:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1854F6B0111; Fri,  8 May 2026 04:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A6A6B0112; Fri,  8 May 2026 04:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED3016B0111
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:05:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A58ED1C05DB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:05:21 +0000 (UTC)
X-FDA: 84743517642.30.81C9474
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 83688100003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:05:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=cQUcQv7a;
	dkim=pass header.d=suse.com header.s=susede1 header.b=cQUcQv7a;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf14.hostedemail.com: domain of jgross@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=jgross@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778227519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zin7zp/9oBAHtr4qfaN5VFN9hhxtKHeI7hC3NPeLalg=;
	b=VDFlcSHoNgencFzP+fBlNO+Qf8nns3CqNhKnYE3mtr5lb6pLH6d67hG3y3dzCDwroHjQDI
	qT1GOJxTYoocZE1LAeP4gXG4TmAwbGW7br6mV5oSyonBl/Ap/MtZE5BjvJBlF3YQlJqNxf
	E82bFTCE9wD5R1NWnBFyb55WRlZlZI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778227519; a=rsa-sha256;
	cv=none;
	b=LciXKwKEe1NLwSL4a5OETcsy3hRt4+cJC3XBbqgxq/NQxs1eA1F1U1LSr8FNTonOyNUK0p
	0DVLfO6V+7v9oqGpjoC3jlez/+UyFV40ZSYaovpXZHANozu+mHFyNppzsxtR3hqccym68T
	PgmSxQVMQ2xgw+1zwe/Q2reunRUmBZo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=cQUcQv7a;
	dkim=pass header.d=suse.com header.s=susede1 header.b=cQUcQv7a;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf14.hostedemail.com: domain of jgross@suse.com designates 195.135.223.131 as permitted sender) smtp.mailfrom=jgross@suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A41BF5C480;
	Fri,  8 May 2026 08:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778227517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zin7zp/9oBAHtr4qfaN5VFN9hhxtKHeI7hC3NPeLalg=;
	b=cQUcQv7a3lNGXcjekKFXsChUBFrlQ7V8GcZILNGJXroQuGu8Uc9zLmO3xF/IYkxLmIGOsU
	3Ua2wlHDk3UA0TMOxVJADwq+mwMIAiHXGu/pTbcvENmhIXRNMTJJzedX3hfiz6MA62M6K4
	h3wKKxjV/nSnHAbaPrSRFH6tShevb/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778227517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=zin7zp/9oBAHtr4qfaN5VFN9hhxtKHeI7hC3NPeLalg=;
	b=cQUcQv7a3lNGXcjekKFXsChUBFrlQ7V8GcZILNGJXroQuGu8Uc9zLmO3xF/IYkxLmIGOsU
	3Ua2wlHDk3UA0TMOxVJADwq+mwMIAiHXGu/pTbcvENmhIXRNMTJJzedX3hfiz6MA62M6K4
	h3wKKxjV/nSnHAbaPrSRFH6tShevb/w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32B27593A7;
	Fri,  8 May 2026 08:05:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oHwnCz2Z/WlsPwAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 08 May 2026 08:05:17 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org
Cc: kevin.brodsky@arm.com,
	mmarek@invisiblethingslab.com,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH] x86/xen: Fix lazy mmu handling across context switch
Date: Fri,  8 May 2026 10:05:14 +0200
Message-ID: <20260508080514.454607-1-jgross@suse.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83688100003
X-Stat-Signature: hp35xex918pyf1bxgy836nqzxdq3uut1
X-Rspam-User: 
X-HE-Tag: 1778227519-389280
X-HE-Meta: U2FsdGVkX19N0Xv7y8ExKqJokhHdp19Hpg525fWhnPSIG3k1XqQUz4j3Or5vJX/7PrAyLHHTkH30wHVAycYtMbJMASfZhWz0NBWmNKuYASYa3N+04b5WGgeE5olnLCU/Q7P4o0qEGa9HhSyhS4xQfHUJ+z6p0OG1+ReWu5QKh243bYYLprGu20Lm2Mb6t6R3Y4OK1P4rcFNTf3/lhzHfubaIt5/xMLkr4UdeG74anS4BeAxlls8Rhs7ZN6RylpsU7QJaXmhbXZe4ymMItwFRoLKfOyLPnx4X/6oaa4acFYj6803VAKBXs3AJn2ZXmAclXhyHn+agRHM3NavYE3IFRaSgvMcy8/otC4ZwQGFYBbFCbN2M9i5xwTJRop+fFuJUyD7q1V9aTSOs/bLXhRsnr9VV5ASearFzhEyaiOz+0avC8g1Mrj1EFT+b5rsTxcN1Zv/X+kFL6FhRagj0Y0cRMdL/t5/sJGbccUPpHAUl3GdL/mYERtsNI5tHEydO6y3gnS6Tt2fxDfogn7Fy7+Bgilm0ANvYYNZDoAqNUSQFZDSiI68DyBgdk/mfv1CzGjmJyisH++/6UCVPwYHH+FVT04sefhhVZhJ82k8Qi9+CqekX3tnWT7Xnp7WDM60iuqziqRO3alJkrnRaKPn0AMuRzyNltTApqczD7aUwmsq83ymPNCNlfiLLxaYa0q7Zra7PujIXfHUNUzlexj5eNFeM+MwfD47XoYegHSAnZ8IzTHogifXLwb0QZf7ZMtigCKMJmRpd+dBf34kqRj6UgAomI2ZLLxiKWLl56QGi/7KvWhn21aX8YEukWE8o3A4m3cZk2NLhLiYDK4WV2qgfYSDjc+N4ngsduVQX2ZN2RSPCVtqAfONhjTExO/T/Dz5G4Nxw9bY2Wf4kP2vjH/VY1zeYERKrpcWy05ERAHVwltOzatTcrCLX36hgvEFGJbuQ7Kw7T/+KWX/7VdL4+VvW/l7
 pNpQcYNg
 TdtapHr863URKh0c/88Fi49dgHA9iy5sACZUWytS1hCLJ5pNTVM6WJzgISJ2Hai8gqsG+1T7T3VkVO2eknBAKGe7/8Fvyvouyw6i5cTiXkqouAn9HxAcEwGGHwbTa3AOAbaPJP7qXqURqqvxT0sJQfmg/NMe4DcZZgC7Zod8ges/IFytotaOPaYu7D1W0aUEkvJuIbqjjiu6jyHuo+v0HoxVfh4Lyi0UbuaurQ8dI/6+mkDL3sItjcW9+G2Bosa5Y0e+aWqnvfI6xNSYesTfwV46eZQUWjVm6CtruAySBeNO0NjbZ1LUv3sjRw478lbx2u8zz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The recent rework of mmu lazy mode has resulted in problems when
running as a Xen PV guest. Enabling lazy mmu mode for the new context
during context switch is done from the arch_end_context_switch() hook,
but when calling this hook current hasn't been changed yet, so the
lazy mmu mode state of the wrong task is modified.

Additionally it is much cleaner to use lazy_mmu_mode_pause() and
lazy_mmu_mode_resume() in the Xen context switch hooks, as it avoids
conditionals in those hooks.

In order not having to add another hook to be called after switching
current, modify lazy_mmu_mode_resume() to use a new sub-function which
takes a task pointer as parameter. This new sub-function can then be
used in the xen_end_context_switch() hook.

Fixes: 291b3abed657 ("x86/xen: use lazy_mmu_state when context-switching")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten_pv.c |  7 ++-----
 include/linux/pgtable.h     | 33 ++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index ed2d7a3756ce..67bb6bf6d240 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -424,9 +424,7 @@ static void xen_start_context_switch(struct task_struct *prev)
 {
 	BUG_ON(preemptible());
 
-	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-	}
+	lazy_mmu_mode_pause();
 	enter_lazy(XEN_LAZY_CPU);
 }
 
@@ -436,8 +434,7 @@ static void xen_end_context_switch(struct task_struct *next)
 
 	xen_mc_flush();
 	leave_lazy(XEN_LAZY_CPU);
-	if (__task_lazy_mmu_mode_active(next))
-		arch_enter_lazy_mmu_mode();
+	lazy_mmu_mode_resume_task(next);
 }
 
 static unsigned long xen_store_tr(void)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..83a099bf2038 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -326,6 +326,28 @@ static inline void lazy_mmu_mode_pause(void)
 		arch_leave_lazy_mmu_mode();
 }
 
+/**
+ * lazy_mmu_mode_resume_task() - Resume the lazy MMU mode for a specific task.
+ *
+ * Like lazy_mmu_mode_resume() below, but with a task specified.
+ * Must be called only by lazy_mmu_mode_resume() or during context switch.
+ * Must never be called in interrupt context.
+ *
+ * Must match a call to lazy_mmu_mode_pause().
+ *
+ * Has no effect if called:
+ * - While paused (inside another pause()/resume() pair)
+ */
+static inline void lazy_mmu_mode_resume_task(struct task_struct *task)
+{
+	struct lazy_mmu_state *state = &task->lazy_mmu_state;
+
+	VM_WARN_ON_ONCE(state->pause_count == 0);
+
+	if (--state->pause_count == 0 && state->enable_count > 0)
+		arch_enter_lazy_mmu_mode();
+}
+
 /**
  * lazy_mmu_mode_resume() - Resume the lazy MMU mode.
  *
@@ -341,15 +363,8 @@ static inline void lazy_mmu_mode_pause(void)
  */
 static inline void lazy_mmu_mode_resume(void)
 {
-	struct lazy_mmu_state *state = &current->lazy_mmu_state;
-
-	if (in_interrupt())
-		return;
-
-	VM_WARN_ON_ONCE(state->pause_count == 0);
-
-	if (--state->pause_count == 0 && state->enable_count > 0)
-		arch_enter_lazy_mmu_mode();
+	if (!in_interrupt())
+		lazy_mmu_mode_resume_task(current);
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
-- 
2.54.0


