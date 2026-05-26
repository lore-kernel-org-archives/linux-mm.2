Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FEE7CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1B86B00D8; Tue, 26 May 2026 11:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8B16B00DA; Tue, 26 May 2026 11:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA80B6B00DC; Tue, 26 May 2026 11:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C96C76B00D8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:08:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 962E71C14CF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:08:21 +0000 (UTC)
X-FDA: 84809902002.07.F7D2FB4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id A32A940004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:08:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GhZkjoUn;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GhZkjoUn;
	spf=pass (imf12.hostedemail.com: domain of jgross@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8n0xmlv2MYEjHKFAD27nORLcuW4BlTygWfoqXW5DVk4=;
	b=Dp4FqRBJogxh2If7Y8zXEjdPChofD+MovOtv1uNQD6OVzI6241fVb1/IQSRwmPJdbZiDFZ
	8Vh/HbuCsDTBxteqasZ2cXEn+0273CEcBQ8gAfarWDDEZdMPjD7BIfi1mdLOAZDFRy5vmE
	q9ttu5OE7lPyTiB8axICfIOSJQuKpdA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GhZkjoUn;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GhZkjoUn;
	spf=pass (imf12.hostedemail.com: domain of jgross@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808099; a=rsa-sha256;
	cv=none;
	b=6pvbTG3XReIm5RryqF3AYSGgD6sdQfkIa0FSr2sw7pWdSXZ/+e8jzUt8ftNRfLlkcwy03D
	DjwPkK408rLoieCmxcZBB5zllj+8o0MK6gWaA1yEfbMhc4F69w9w5UWqZ0JH4/ghgDdO8F
	mV0i5UOfjnOjNKHGSX2C+F8zHH7dLQU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C4BD6B4EB;
	Tue, 26 May 2026 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779808098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8n0xmlv2MYEjHKFAD27nORLcuW4BlTygWfoqXW5DVk4=;
	b=GhZkjoUnVPRMpVt2BnzpVURKBQVRg/dwhbDOUD6xe1XaM4w/6t615Ymt7Ws/F5aUQn4UkE
	sO9yYtqrNh8W81Hz7SJkD1MVDK+vvTrymty6LjmeRW2VOTQu4NdxZgYBQoqm5gS31mEroL
	My6F9xEkZpqjLdOBh8p9FPoJIpY+nYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779808098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8n0xmlv2MYEjHKFAD27nORLcuW4BlTygWfoqXW5DVk4=;
	b=GhZkjoUnVPRMpVt2BnzpVURKBQVRg/dwhbDOUD6xe1XaM4w/6t615Ymt7Ws/F5aUQn4UkE
	sO9yYtqrNh8W81Hz7SJkD1MVDK+vvTrymty6LjmeRW2VOTQu4NdxZgYBQoqm5gS31mEroL
	My6F9xEkZpqjLdOBh8p9FPoJIpY+nYU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B9C65A27D;
	Tue, 26 May 2026 15:08:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id okjDAWK3FWqhVQAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 26 May 2026 15:08:18 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Juergen Gross <jgross@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 3/5] mm: Refactor lazy_mmu_mode_pause() and lazy_mmu_mode_resume()
Date: Tue, 26 May 2026 17:05:12 +0200
Message-ID: <20260526150514.129330-4-jgross@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526150514.129330-1-jgross@suse.com>
References: <20260526150514.129330-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ze4581hsamhwgwecy5xnb9mcqi9nhna4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A32A940004
X-HE-Tag: 1779808099-29373
X-HE-Meta: U2FsdGVkX19yRA28Dc35pSMWBIyjzgZtVu5u1HHYrDNFKl+ekNlEfX+KN3tcCOthM5lJUbPIATQE9w/O24tYcmcOLmFSZAy07AFKgoX0/WK6miEhnqX9wQhKcWr0G3VJtXLEz37VlKuKmLFVjxIVn7Imkt9oAr0LvYTDaxneYbRSuV2Wruw3bCVd+1IX7wduqjwCPgKtaDtj1VDALZhbQn8oGiHfFfIS5MypTp21Yzc7h+NyqD6F4FtzREBF+jU+3X4eiK32z1F+Kx9I1jEW32wBha+H8zAeuy/ARm1tO2L/h0GVsxRmlgIRcDUc+gig3RRq3w3Lt1OPZf+qtOYrFZ8r4fL8hXWsfqN7xg2J2IaYZBwbMNct3im4raWffUTJDmpOLf1y3Ns/6Zb2hdpKHQn77HzQnpk79qYOMdeeOdUmFxPh3i9ZbbeJ7rJzR9HOwK2nYK5PwLaYbw8g7Jif9Z6rK7hExJA2/QkfAQo40E8KsAGPY5BhF0N/R3kXvTldlYzLu7Ehn96H/JlzTni3P0az/jn8ZZPrsEFgfYs/1F0yQN5VfUlKAlBwdcKV0hOmgS7p46th20/6jXCsgYmkvLFTCeRlu+s54OAXBV5ANJ3hE7sa0XJAMQQ//1W6aegYmZ0/XFeqFpUIKFBhYtRpyEEGlTYGhdouwXI08xG5iDT97Tb5Kn4BiSHn7Co+IRafioaGdR1Jf/hP5cpOSo/M17EIUqR6kXCADSpvFxbpFN+DIWJMlOGzNhmq2ED/dxo9q4rXfAzYH5uzawjsOkAONOenyhpwXs51ZqZ+bmg4SKhsBSdFEd+icTWzAHZmN4XrFvc9J1U5QXha6QDlYQPre1fjVw+OornSXjDb3Lp4hGE1RtB401v5ij6aZRAIy6BKVEUGzt2rlOMYIph8q/CjYd7XVDYSc8Wru8AtEXiaFmK9Pu3/LmK/qQlDmDZNZs8yRDfM9DOphBNXtbeS7ZK
 qtWgooB/
 WGYczOwqDig9VOo2hX6+SA819rWB8KQtPPsN2ERGnBjIfyQZZMtaHE8PUxwYTAZs/qznDGBuMoiTeUrhdhYJ2zy16r+NbgexaAAnhGxx/fZ7wQAi0YJ+qetNXTauC2/L+YXRFPZkExmFUIgo6H7fOwHRvGbBxx63mNLeu1/eXQqCLgj5XBFglIKfMCL5+WKeuKWKlXaNl+dv2/GFV7a/9EFmiN2Thv8KWXX40ynVHV0WVEZa2bSucFe58E/rxBVVG38kzod8t37PBDqF3pu36QrO2Uvysfi07QUuS1DkicIuV6lnFL0usZM4FvAweAmO17u1P8CsIuWrCxIb4mhc3rxCQD/YptG3K1anzACNCiucKojjLfx8hU9kkDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to allow pausing and resuming MMU lazy mode for other tasks
than current, refactor lazy_mmu_mode_pause() and
lazy_mmu_mode_resume().

This will be needed when dropping the Xen PV private lazy MMU
bookkeeping.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 include/linux/pgtable.h | 56 +++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..07483ed9b3ce 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -300,6 +300,28 @@ static inline void lazy_mmu_mode_disable(void)
 
 }
 
+/**
+ * __task_lazy_mmu_mode_pause() - Pause the lazy MMU mode for a task.
+ * @tsk: The task to check.
+ *
+ * Pauses the lazy MMU mode of @tsk.
+ *
+ * This function only operates on the state saved in task_struct; to pause
+ * current lazy_mmu_mode_pause() should be used instead.
+ *
+ * This function is intended for architectures that implement the lazy MMU
+ * mode; it must not be called from generic code.
+ */
+static inline void __task_lazy_mmu_mode_pause(struct task_struct *tsk)
+{
+	struct lazy_mmu_state *state = &tsk->lazy_mmu_state;
+
+	VM_WARN_ON_ONCE(state->pause_count == U8_MAX);
+
+	if (state->pause_count++ == 0 && state->enable_count > 0)
+		arch_leave_lazy_mmu_mode();
+}
+
 /**
  * lazy_mmu_mode_pause() - Pause the lazy MMU mode.
  *
@@ -315,15 +337,32 @@ static inline void lazy_mmu_mode_disable(void)
  */
 static inline void lazy_mmu_mode_pause(void)
 {
-	struct lazy_mmu_state *state = &current->lazy_mmu_state;
-
 	if (in_interrupt())
 		return;
 
-	VM_WARN_ON_ONCE(state->pause_count == U8_MAX);
+	__task_lazy_mmu_mode_pause(current);
+}
 
-	if (state->pause_count++ == 0 && state->enable_count > 0)
-		arch_leave_lazy_mmu_mode();
+/**
+ * __task_lazy_mmu_mode_resume() - Resume the lazy MMU mode for a task.
+ * @tsk: The task to check.
+ *
+ * Resumes the lazy MMU mode of @tsk.
+ *
+ * This function only operates on the state saved in task_struct; to resume
+ * current lazy_mmu_mode_resume() should be used instead.
+ *
+ * This function is intended for architectures that implement the lazy MMU
+ * mode; it must not be called from generic code.
+ */
+static inline void __task_lazy_mmu_mode_resume(struct task_struct *tsk)
+{
+	struct lazy_mmu_state *state = &tsk->lazy_mmu_state;
+
+	VM_WARN_ON_ONCE(state->pause_count == 0);
+
+	if (--state->pause_count == 0 && state->enable_count > 0)
+		arch_enter_lazy_mmu_mode();
 }
 
 /**
@@ -341,15 +380,10 @@ static inline void lazy_mmu_mode_pause(void)
  */
 static inline void lazy_mmu_mode_resume(void)
 {
-	struct lazy_mmu_state *state = &current->lazy_mmu_state;
-
 	if (in_interrupt())
 		return;
 
-	VM_WARN_ON_ONCE(state->pause_count == 0);
-
-	if (--state->pause_count == 0 && state->enable_count > 0)
-		arch_enter_lazy_mmu_mode();
+	__task_lazy_mmu_mode_resume(current);
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
-- 
2.54.0


