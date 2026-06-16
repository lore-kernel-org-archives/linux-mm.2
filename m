Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC394CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF3C6B009B; Tue, 16 Jun 2026 17:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360846B00DD; Tue, 16 Jun 2026 17:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229636B00E1; Tue, 16 Jun 2026 17:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2AF96B009B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:42:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 605C64026E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:38 +0000 (UTC)
X-FDA: 84887100396.23.9C27A9F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C7C340012
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=btGYs9sM;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOvX4RZR/pDRt2jv/Wl1jQyJJ9xmvr29K3ndLYIsFzU=;
	b=X/tqt1uEmrStFlSWiOweJ6WFr4N+bM1I4S95XREzDCB7ktPv9LV1Z7gumtMv0nHC5nWYFo
	wgv2PLVdrYM7GbuNmBeHuoucv81IYFZammOK8jp0i+reSLMprBhkZPLir1KUfmvmQJ0jP/
	paarGmBU9KWD6lLuLuBDdGpWHOsnyHI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=btGYs9sM;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646156;
	b=fPTwKyWb4vsmnzmLg2lsRz+dReOApDDWXgkzh17K18I+T/WbpAsMuz+OqpQ8PI5GQ2g1uu
	vnjE9Z8xHDGJzR90I8XNNH+6ApC+AskihAG5lEJ084DJbgW6c+qLGe7va5s6p/UOvQag2g
	If0Uov2rkghaUjskkvuW86PNOdnBrqM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MOvX4RZR/pDRt2jv/Wl1jQyJJ9xmvr29K3ndLYIsFzU=; b=btGYs9sMX+WlAdQ7YaipGJ3rHU
	PivCbcP4KrBK9vhRq5kWEoL6HgKzeVU4U8C3bPvInk6bZ63bbHnRdUASiVqEKtQRgE5eIB0ljgz9a
	2/weGlDRtTjMxGPCApsDIR2ZL4UMg2O7dHyOn2Bwd/NfV3rngvpTsLBCb1pIifct5XRYH0iA3qOv+
	y70EPw7WwyTV151au0iu7xIXB7cb8RHjhNOOWfBbgdIgsJNkvUhJ9DuG+NRvEbfHfKlKWkahsXCJN
	h+SrSQoGHnai+9Snd2HyDRjFtRDMjs+D/xIC+0WEgcwn7Mql2TRvxObZuUbJzlaPuPNzGP4ELkKpi
	rbM8h5bA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wZZ4Q-000000005GL-1Tf8;
	Tue, 16 Jun 2026 15:03:34 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>
Subject: [PATCH 1/3] x86/mm: use READ_ONCE/WRITE_ONCE for mm->context.untag_mask
Date: Tue, 16 Jun 2026 15:02:58 -0400
Message-ID: <20260616190300.1509639-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616190300.1509639-1-riel@surriel.com>
References: <20260616190300.1509639-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C7C340012
X-Stat-Signature: ekwf7jsz66qhxnw4ozrkgqgknur6r7gz
X-Rspam-User: 
X-HE-Tag: 1781646155-764794
X-HE-Meta: U2FsdGVkX195V6L7wyrAt9LWoailTJGMwZGM1hc+oiCjvwhXKJjHX11KzrIzHVxnqKCzdCFMktaaHyFMkrO40OXPbskOTNnsMVJPdpkF3wPAEgc/dsxn3S03UkVoiEBztZgAS2YlwHj1EbMZiPiGWcGMuVfPiSeI30wZ00hxMINPFRZPPEZtHUMWZyCpA3//yYiDwhhn8/4+PSIhukXbQL3Ugyh8aPGEpIfU0FYTWs/NjfftSSjxgcD7Xfh5z/9rk9K8OMa2jxb/SiFFRqCPRcPPKhkfD8xBjSv4AZA97Xzhu7FnUKuN2p4K0Jg3CcC/xBDIxMIWsueY/WwxzOnLukkCq/79/5LOlh5DNnlv3t7/7gB7HsAlI/l3Bs+fmA48AMU7xX3fToJk1HwEaPRY/KwjiOg1K/CjcpSBtqy0OLlV9pTJqGyt9wmIs2IPawKk2C/yMOjID7w+eob8Z7CpO2sUeio0s0zsArowofWX92YMHsFLtgOSIFXI/N5RWXIQkbrbU+I7IKWgSrUhiuVhgDfVWtf0bP5QwGEQAq+GOuqqxZYon8XjfnXkEx/v69JONEV8qgf4zZDGg7mj89ZPTPcYoAyDFSN+iDkB/6sbZBE2Iqp7uiPESUtHS0DEmITdOklUhUSFvzBCNngSpaJhbTaChCR8Armvq3NLoRAnNLXnN3F1S7FGrjalr2FVhreh7ADurUEODJ2p6ba8Gtjjqffot/a9qSuQ8XqnBoVnlL6XQHW3bVqdFbRVPKRuWNyLuPplcBgqvRfnwNp8drkw2Az7LwAjcTTTls3FE1rWrgiciApfFhucetc1fJXas3v+t+XvIFY5EObZaILTXqn35L2MIgc7zSiwT9S908r7x6oAP5rtP4s/eYce/KTzrMHUcpZsYxS4RrVRwhE4VR1MEB/ukrNtjBzjssCcIHDfIIPKcvCJEm9KXkEQ/rkZijYov8xy9jpRUKk9FV+VLQu
 XsRfnmv6
 xPUMivNBXztxyHDiQR4Xp3hTQfZyWayV1n1bv7YBM4hRbdnEFY/DvwNXvz+1CYZ8I9GlWZgIeFmmhZIzYiWt8Uz2z9x9f90uYobevEXygAqzFFq01sbsMvl2NniLht0ur5Si2+rezWoFEqF9pRmft3OTZ7FZlW7nmPfXmJJUV63MrPsGmSnVqO3NTlxIVO9p1IW77SebIUbPnfLpc/w79Wb6LpK3+b2mJ/2QxDHA51t3Csf5J6d5pu+r5oZUj0aSMhnwaBNi9JkecVzyQOySImVwXIJiBUUPrODLMKzCmr5XpOgUqJ7j+GyNc3T3PquugmsR1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm->context.untag_mask is written once, when LAM is enabled
(mm_enable_lam(), under mmap_write_lock and while the process is still
single-threaded), and is otherwise stable and never reverted.
untagged_addr_remote() reads it for a remote mm, and the new
untagged_addr_remote_unlocked() (used by the per-VMA-lock
access_remote_vm() fast path) reads it without the mmap lock.

The field is a single aligned word and cannot tear, but annotate the
reads and writes with READ_ONCE()/WRITE_ONCE() to make the lockless
access explicit and keep the compiler from reloading or tearing it.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/mmu_context.h | 6 +++---
 arch/x86/include/asm/uaccess_64.h  | 2 +-
 arch/x86/kernel/process_64.c       | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index ef5b507de34e..cee710f64658 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -100,18 +100,18 @@ static inline unsigned long mm_lam_cr3_mask(struct mm_struct *mm)
 static inline void dup_lam(struct mm_struct *oldmm, struct mm_struct *mm)
 {
 	mm->context.lam_cr3_mask = oldmm->context.lam_cr3_mask;
-	mm->context.untag_mask = oldmm->context.untag_mask;
+	WRITE_ONCE(mm->context.untag_mask, READ_ONCE(oldmm->context.untag_mask));
 }
 
 #define mm_untag_mask mm_untag_mask
 static inline unsigned long mm_untag_mask(struct mm_struct *mm)
 {
-	return mm->context.untag_mask;
+	return READ_ONCE(mm->context.untag_mask);
 }
 
 static inline void mm_reset_untag_mask(struct mm_struct *mm)
 {
-	mm->context.untag_mask = -1UL;
+	WRITE_ONCE(mm->context.untag_mask, -1UL);
 }
 
 #define arch_pgtable_dma_compat arch_pgtable_dma_compat
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 20de34cc9aa6..4a52497ba6a1 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -43,7 +43,7 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
 						   unsigned long addr)
 {
 	mmap_assert_locked(mm);
-	return addr & (mm)->context.untag_mask;
+	return addr & READ_ONCE((mm)->context.untag_mask);
 }
 
 #define untagged_addr_remote(mm, addr)	({				\
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d44afbe005bb..55096136de53 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -814,7 +814,7 @@ static void enable_lam_func(void *__mm)
 static void mm_enable_lam(struct mm_struct *mm)
 {
 	mm->context.lam_cr3_mask = X86_CR3_LAM_U57;
-	mm->context.untag_mask =  ~GENMASK(62, 57);
+	WRITE_ONCE(mm->context.untag_mask, ~GENMASK(62, 57));
 
 	/*
 	 * Even though the process must still be single-threaded at this
-- 
2.53.0-Meta


