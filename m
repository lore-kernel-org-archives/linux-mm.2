Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E5BC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A323C6B00AA; Fri, 17 Jul 2026 13:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09F16B00AB; Fri, 17 Jul 2026 13:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FB16B00AC; Fri, 17 Jul 2026 13:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7AC6B00AA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E13F7C01F4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:09 +0000 (UTC)
X-FDA: 84998883858.21.29CCBE3
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id A46942000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=XMjTuISn;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307668;
	b=2kLii8NheXnt8NIRc7OR7KVu0atHQ83bR72psClYK94m3qGzjhki69fesP8s17M2DVgA2d
	eBSkDApcgkUHv7jKimfg1BmpzWH1S+Nkg42yZZXe/uMkHmKPcDzjsF6x8bygpBkiZSDHkh
	eMh/2RVL8KIAg77j3YLFJAYze4mLkN0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=XMjTuISn;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3vbKYZxRsDMfVpHBxPVOyxjBlSbaKA9GcdBzuhy8/M=;
	b=e2bYhlOwfZW5bfvMfwcOxNT/s7cd6DAqS5/C/j6l840/yV7Ym91rfswxNtL+F6i3Bmo7j1
	tSH+tpEB1fH3cfaUE464FOVVtct9X2uyZAUYt121s4ZNKywe/RMw+PQEyuiogbK+plNVGl
	V2/Nqq3IbjrMtDK56Dx5urzD4fbJBQI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g3vbKYZxRsDMfVpHBxPVOyxjBlSbaKA9GcdBzuhy8/M=; b=XMjTuISn/VdlNzVWcRsravLbi+
	hkm1J4NIe32NGtJ/rpWfaJWjH8D3byPUvCx2Ep3/yG+yt2xCVZMtqVpq8gZpHQsbh9iym/67wN+lA
	AkBJFCYjoPUHE2exwMEyZUSMaW6xyxpezzSRV60t6ynJO4+YvOrGE33wfARHZm/ZxrvkfrcJr/H+w
	AbBMHegmNPgTO24/Zh3o/6OKRsqZ5Q2svwFm82Ln5N9ol24MwTbvJ8pvmCZ1vrqnVqFrgXmtuKCnw
	9i8ALaPLZqrixvZNaZsMgrrdjRL4569xiHMD+rtQKmSgjeKoTq7zLx2RCPLv5nJvr4iC//wmWo9qS
	v9oLlYZg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-0K81;
	Fri, 17 Jul 2026 13:00:38 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-riscv@lists.infradead.org
Subject: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
Date: Fri, 17 Jul 2026 13:00:32 -0400
Message-ID: <20260717170036.743149-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
References: <20260717170036.743149-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A46942000A
X-Rspam-User: 
X-Stat-Signature: wiuw9qdboisf118prrxeca7cznidk6go
X-Rspamd-Server: rspam03
X-HE-Tag: 1784307666-8535
X-HE-Meta: U2FsdGVkX19p9YqPdCkfWC3eyMECGy4aj7hMkk5V5VRkCvgg79lbGv/DDK8GJfGfrVDxmN114hhJrJVwZXMoDTnyW8YQJODygWL+U5owm+iab5VvoaGh9cM0+agInDGVWZapJeyNsejJNlMduKj3YAvDB6dOKq/9puqd+yV4R7fvrE5ZD791YexV05xFgiU0JAis1outFCcTHX/CkFmZ7Qikbtg0SQiUfBgguETOBbkH++gjChS+FEHJJKH4t5Pr7faSjQ86Do1+FRWknU0XeJnY+zbjs9myB9yitVyo1dlSgDFi7TIfcubhRXsPWlKvvXr4UKBGE53rFMJZEyHZc1REpMmI/poAZfUmGTB2IyQXxa0Kgjyh5FgIIlrEIxR0KTfICAkvhqOgorg7ZQxR8alLozb0mZDyJFRGf3d2aDezNpNlernrODkfEwMKHkfhTzr0xl8OyuzP5u1HJHjHpdlNtisiqGpKDmeIGffd7bOQ3J0AZFBUtHyyxgxX82IOjqRhYzKj0xRA6Ea14EYxK6QbL5rmpmXPCzdYy9OO11Jcz7eoRmp0/EiuwtGoho+dnJFhqO8xatSJIC/1VHdT5VOKRxhmRDvXCwc3S9DQOG5XnKWxbw93YAM3SuMgv/SWb5RHh/ReIjnen3q1ExAkC4bvk7ROnDu9lNDXt6i/zSDESktzExqlxXNXWv/j+MV9dfYGbiD1yC3cKyt/IXl0QtB9+Ze7bcSK1keAZg7CT+msnPzFTgBO3OoD+v7DBTce/SkUcx3HpO5pb+OTKNVF/wG78opT8sF8nlp/mNUN/mZpLv3KVWsY1VFV7Tq5MR3HwYOpIxO0YxMaZBbFf9UgKS61Wb40p/fYLXenYtINN9roT6SHR5uKt9X8Dm7ApzrCssP8U/QmSowhR1nPvcYWfu3cqsdndzPrTSAipwAufk/f6bCr8vqMK4ctaOxVb7XrXKCH6H3arL2zFyD8tVS
 UG5YWN38
 omUiqoMeTbax8PqWTdzIEntLlhKdnDxW8Th+JCDucd3qb8FnOGTOm9uCZmGjpdINd9x3TbaQvZkjIu8IDS+0AehoXYQ528I7rXgllBcFtXPN6BGjzZvs4ZjwSe7oTE1cFF8bDnRqpgJtvE1XaOEIMSR2BYspFElOwA+7ZTyUvLsy4v3eOHbvnpp0a2C8AACIPf9iNkYhOrTcY5OVHb8eTsVd1l4jgXpSkEUSGDelJF7eRVPwpp5d4f7u1G4nOTNp/3HswxD4j3H+Q/sNx7BybuaVOlestfN6QWbfJ+i8wD233PoW8Q5nJKoHiEDUj/LkQwrpH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() untags the remote address before looking up the VMA,
now without holding the mmap lock. riscv defines untagged_addr_remote() but
not untagged_addr_remote_unlocked(), so it falls back to the generic
version, which untags with untagged_addr().

That reads current->mm, not the target mm, so a remote access to a process
using pointer masking would untag with the wrong mask.

mm->context.pmlen is set only through PR_SET_TAGGED_ADDR_CTRL and is stable
afterwards, so it can be read without the mmap lock, as it already is from
untagged_addr() and mm_untag_mask().

Add untagged_addr_remote_unlocked(), which untags against the target mm,
and annotate context.pmlen accesses with READ_ONCE() and WRITE_ONCE() so
the lockless reads are explicit and KCSAN-clean. untagged_addr_remote()
keeps its mmap_assert_locked() and shares the code.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/riscv/include/asm/mmu_context.h |  4 ++--
 arch/riscv/include/asm/uaccess.h     | 10 +++++++---
 arch/riscv/kernel/process.c          | 12 +++++++-----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/asm/mmu_context.h
index dbf27a78df6c..3ce16796e5a2 100644
--- a/arch/riscv/include/asm/mmu_context.h
+++ b/arch/riscv/include/asm/mmu_context.h
@@ -21,7 +21,7 @@ static inline void activate_mm(struct mm_struct *prev,
 			       struct mm_struct *next)
 {
 #ifdef CONFIG_RISCV_ISA_SUPM
-	next->context.pmlen = 0;
+	WRITE_ONCE(next->context.pmlen, 0);
 #endif
 	switch_mm(prev, next, NULL);
 }
@@ -44,7 +44,7 @@ DECLARE_STATIC_KEY_FALSE(use_asid_allocator);
 #define mm_untag_mask mm_untag_mask
 static inline unsigned long mm_untag_mask(struct mm_struct *mm)
 {
-	return -1UL >> mm->context.pmlen;
+	return -1UL >> READ_ONCE(mm->context.pmlen);
 }
 #endif
 
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 5d4ec15584cf..53806e0f7dcf 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -16,7 +16,7 @@
 static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigned long addr)
 {
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SUPM)) {
-		u8 pmlen = mm->context.pmlen;
+		u8 pmlen = READ_ONCE(mm->context.pmlen);
 
 		/* Virtual addresses are sign-extended; physical addresses are zero-extended. */
 		if (IS_ENABLED(CONFIG_MMU))
@@ -33,12 +33,16 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigne
 	(__force __typeof__(addr))__untagged_addr_remote(current->mm, __addr);	\
 })
 
-#define untagged_addr_remote(mm, addr) ({					\
+#define untagged_addr_remote_unlocked(mm, addr) ({				\
 	unsigned long __addr = (__force unsigned long)(addr);			\
-	mmap_assert_locked(mm);							\
 	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);		\
 })
 
+#define untagged_addr_remote(mm, addr) ({					\
+	mmap_assert_locked(mm);							\
+	untagged_addr_remote_unlocked(mm, addr);				\
+})
+
 #define access_ok(addr, size) likely(__access_ok(untagged_addr(addr), size))
 #else
 #define untagged_addr(addr) (addr)
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index b2df7f72241a..6ae7552fed09 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -357,13 +357,15 @@ long set_tagged_addr_ctrl(struct task_struct *task, unsigned long arg)
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags) && mm->context.pmlen != pmlen) {
-		mmap_write_unlock(mm);
-		return -EBUSY;
+	if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags)) {
+		if (READ_ONCE(mm->context.pmlen) != pmlen) {
+			mmap_write_unlock(mm);
+			return -EBUSY;
+		}
 	}
 
 	envcfg_update_bits(task, ENVCFG_PMM, pmm);
-	mm->context.pmlen = pmlen;
+	WRITE_ONCE(mm->context.pmlen, pmlen);
 
 	mmap_write_unlock(mm);
 
@@ -394,7 +396,7 @@ long get_tagged_addr_ctrl(struct task_struct *task)
 		break;
 	}
 
-	if (task->mm->context.pmlen)
+	if (READ_ONCE(task->mm->context.pmlen))
 		ret |= PR_TAGGED_ADDR_ENABLE;
 
 	return ret;
-- 
2.53.0-Meta


