Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5EDCDE005
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524386B0099; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8226B009D; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A3E6B009B; Wed, 24 Jun 2026 21:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 063A16B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:51:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35DFBA04BB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:21 +0000 (UTC)
X-FDA: 84916757562.26.F450197
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id A307918000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Lw8qO9J+;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352279;
	b=ni3zmLiKk9FHHzKNhuTMn1zlbBwA8Xk5VG+eOQFPK89+d0Zaciz1g56ODfouaObZGnNQkB
	w/TWlMJN2cMzfJjQXoaeO9US41rrsHObiStGNaeqDUX8iBO9VSMZWNSi0XPyu6Mvye2VPW
	s2LO/2oqkR8GeAf+YwxXQ0JiXE5T7Mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOvX4RZR/pDRt2jv/Wl1jQyJJ9xmvr29K3ndLYIsFzU=;
	b=x5QQhbV3w6i9Dq9lTFc7lsdr9zM0YpFIL8nKq0i5/HlnF7A1VDLrR96MVBXj4ljmpse8Pp
	g/SR2KcVuqo7xBJEcuUUEH+TxmbqMSrzB8Z2H7FinfA3YrxIlQhAJdYGwJWFxazRyRU9QN
	vsCq59MrXJUIdVFr5jvXkxqIr4cwWg8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Lw8qO9J+;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MOvX4RZR/pDRt2jv/Wl1jQyJJ9xmvr29K3ndLYIsFzU=; b=Lw8qO9J+51sc3ejV94J+uUBF77
	i7PSTDPlbDLBo4HPWJLe7NVcly2/cq+Y0lLIf5IgdGUH/7B6SeAhfF/KZnuGTFnzJsNdF0nU63q3s
	Rl6DwoYnv8rEwXeds4gdF8pAZxG+c6rY4+FeHNE/ChMZDreKd1s0QxVoaEJ0aoxhsQ0hWxa02TBZC
	EhahuBq5uDFMyE9faWStsOAHOj4Jdy7AknCm//YAs30IlOMRjLZ1Tu1LTn6Lpoi1cYYeMkxbpHDBg
	JEDbN1fIIcIU37ZpBIVZISIPKWzMKKGIqyi+B9Bd4k5hhlvFq1jBMr0Sp98xDxtarmu0QJwj+cj6l
	5GakgaMA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wcZF7-0000000043x-3wAz;
	Wed, 24 Jun 2026 21:51:01 -0400
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
	"Suren Baghdasaryan" <surenb@google.com>,
	kernel-team@meta.com
Subject: [PATCH 1/3] x86/mm: use READ_ONCE/WRITE_ONCE for mm->context.untag_mask
Date: Wed, 24 Jun 2026 21:50:51 -0400
Message-ID: <20260625015053.2445008-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625015053.2445008-1-riel@surriel.com>
References: <20260625015053.2445008-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1468izd3pzfkgapcg9w11z9enyim966o
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A307918000A
X-HE-Tag: 1782352279-514952
X-HE-Meta: U2FsdGVkX1/HzEFYQrdm0nyVfPQOrxWo20A8JXRpGKHDuYXMGJ+is/9r8EUy6EG+Xp9XXSjWNw/7OBMvRwM1231HqJe9R98YKw2dg/EYC0ckiEv+F7XSdvfKZizdBt32hQiC3Fzw3t/2Q5IAcdMJlBloG+iyRwOvP/SeQOIlT3rffPFEbFGebtP82xq/+6tMbFiMEZaIwZPHO1lGfnc16ZTHkgguTzHS77j/8VhwMpgsAJrK4gxVN4BffHq5cdBZZr5hBsQ2YBdinGlhVcqImjoV1b/SDn91/wPYjbMU5xrbOaavcuIvsoO2SgNVB6UJ2A4n3RXDRq5H1V7JXdUUZrXnSsOV+Ecia40HPBVgWqtkcrQvpL3vbMUMqNlqKxhSDt/V6Vszt+0SJfJr/LRYUvZ9zJNoJ4ZeWd/F9FktgPXYM5HQYxu2em+uh43FyW5ozEAjr4IkhVo6A8ah3M8dCpomns08IAHu+QIrcESrwarTRiTij6B43x7ibNT8o0mzA6VBNn2woL3L1EvwE2oLS/l1WNLN5xtVM5sUbOaggPzFK8wFXGqM7b1iB0bcFaNNHkaWjOOt/BMkp6J6Fa6j3H5ZqIJvH0zY6WGqz0RGZ9aaruEVYPN+/DWijtJfxWvT6CpQSXTrMTz94fxhCj8BHKBuKl4PMUtzt4o+s4MGHDH/xXB5BA0HhQxTrarlF6RofZk8u1CZZZflw+ofJI3iBRMc7v3yTfvjS79KJNa/7Oa8PbllGY8Z7jM6mYKtUmlgmIogUGCsxGfUGt7ZxJ27arTPYWC7DxfKjLbpbwiUqpckcy21bz3oaFK8TUqaLdKfGMFPwuVhtlGpAyCr7ZcoYbZqjQ5i5BAIN3gSc3BbRP+g/mjUEP3YmgQUvAvKKHOz9pXGrziI2RHmJZSyOBhImuOz1VumKPfmc+5UeZHx0OFVpJYhYmAs5CLhNpz6w4vynd209on8FVGi6vL2Dmc
 3ip3yUEg
 2KPXy1nLVIm6dNaxXBVEJLIEwkJmlzMrE3+pcbnQX/GEK0vyJdU7GH3ECkwJHQg31U3IVWvtHf5GIugyeP5Fq8v0RbE3ydiQgNiTIYIbbYCozF83giSMUpv4yHg92dmvO9f12EqgYzB4EqBISJf51XfkMWNhQQwu0p/DjbHSnGjJ+18gJtNwAw2oEue+7fUA/0i8wNXKLj2zQhf7z+Y4xLMM2jOZnHzd4WhTxw7evcCAMzTf7p17txXrryseFEGPolmhbtTG37Vee4ohe4pV8glUuiyGnbOubgFBqJn/LFJmh4NotT8qOJSVAQFFUcYfmlTp7
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


