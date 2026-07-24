Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 876F6C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5561E6B008A; Fri, 24 Jul 2026 18:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506566B008C; Fri, 24 Jul 2026 18:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F60D6B0096; Fri, 24 Jul 2026 18:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02BEE6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:40:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D98014019E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:40:23 +0000 (UTC)
X-FDA: 85025140326.13.55A983A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id D19C24000F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:40:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=KaYyL4Mb;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932821;
	b=ki8veNtwOMHELx7Jt+4tTdA0ILY4+y9kUzw3TaI1+15YVYr/m6FTDRLfWS54w6QPctcHvr
	/XwZpTqUYzagr0j9tY3w98s9AvLSaLEmEUZCgTFSAgIIg3ZbojVBsi0XOhchd2GxSEOpib
	Iwm5fVlXRpULy8A+nzgi1iPo5za6Rj4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=KaYyL4Mb;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7NU1MfovW+7lx1xP2l6wfJPEmWK+PLGNyfdih7cuN8=;
	b=HXW2ZDQV/az8SG8TG5th7bFuYRiLCJwIqz1HKOZw2cLtbS09G2K2CHo6oiQo7lzyONj+df
	1TM69XEnwhAGHOxvYDts1ck0CZ5dtasjqovxbnfTPPTmPVI9TImRxaUFIGZPuV+cxncuCE
	1w2+omRjTwn7Uk33hm83j1/z9qE0XTA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C7NU1MfovW+7lx1xP2l6wfJPEmWK+PLGNyfdih7cuN8=; b=KaYyL4MbCf5uM4PBwpzJonMKl9
	cyXNE0D+OJUbxfv34AEjHgCSvXMJ8SgkagJY/CwSHuKatkwmtyO+J0MZYTRJuRK35fyAfLK4C5loJ
	bgEanDnDhIa18xkaNlqkFxBqRPp1XE7YbGrjwSbNQ2RJafZt9rjXhfmE6t3q/CBf0yUcnf8kaLj4v
	FSxcISpKkWhv3uZi5KgsIhYZQHey7sxnKewn2AG300IBLTrCuw0WfcbGYJKGlCbGqqmZOfQ4tIH/6
	aZL4Q/572xDEJjOBhMPboLFBSluS4UpJxEBa+UjlzkqKyazeVe7cVtI3JTaWXgCcIJtnRzKMvWX4q
	z6mERBQg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-0xfn;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH RFC v4 01/12] x86/mm: add untagged_addr_remote_unlocked()
Date: Fri, 24 Jul 2026 18:29:23 -0400
Message-ID: <20260724222934.1463812-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D19C24000F
X-Stat-Signature: 4wpt1m6rnbx4umgz6yy13ejmyakoqdnr
X-Rspam-User: 
X-HE-Tag: 1784932821-706512
X-HE-Meta: U2FsdGVkX19gFWoITsSpiHj+beDJFjBmJqPo6w85Ke/NcCyv7ag33o/id5BCCwhT3Z+KCmYh2TVYR6qiuRyExeYihiiSdzDP66eax4NUKPXYCCKaDG5cxl6OLLIg0Ld/VS97ki/6pi5/82TBp984+GeXZsCY8QPV6vkwMl40PugyL036V58UaZX3oKfvFgkzsC20DXTAgNVLkCqGrnreLyXoOOl0F7+zVQZYk1F+O9L+A3N1r/w6xu1kmZnFYVjig7rfQmUBUYk3KhW5PerH8MySA0sz8RRxBPXPfuk88oxck94bgzjS8hAYympmNQXYgokjPWFfkltm4fB6L3Pu89QqLpkxOlUtXa9TMyf2YbVaqMhY25ViCK4nKspAe+5zMRXR99zEHl+m24/DqXypUnVZJ3vRc8zDnCOj0QTRXzO0SItRO9QZ+644ehz8uziG6DiL1j45dUB5NyV8fxsImy/2F0PeuEgXMPWuYD/FG2UBGqfHMQSykw1irgDYR8ROO0ptGVy/mhia3rugWg0CMI/9Lbo9bsV0fLuCE08dt6fuHa6KS0sOkORxNJGsa3f1w/OLDFXqHpXUsP4fn11thsMU3avZrdAWBO7uQyaxB+dMHlqU3PaVACyOsYaVxgzwKpzSiiUnCbuJ7DHykUgEjQ/GMx9OzeAtkgRgHFpdRiBgUZ1R31/VBrrM/x/h0q7wXqih4+hQrs3fcjTsQW6PaHY4DMhN34kghpCCTBnVeSurwTRmEh7OZfg5olbZJH9I4PRw04cXrlvQG32vjtpLbItB9R5Q1nS686Vk3x5M9XmaNHW9Tokbpj4Dl7Op5l4ll1QACNPiF9xHiLauOJwIZUqj6Pj9qLqsHNexnf2veeEheIKNHCBvzY5dAzeFsqH9l99+sYZaw+RQ8LylaWReHj4hzgoekv62/rwRy9pO73sjiKtzzg7mqL/98zSjuGhZHbRRrHbaUInIyYvQKJT
 aTIYdWpE
 BNKsw7WaJZ9BJdS1SxxtAY01rmq16Rr5NBrGqdreNY+QKn7ugkW1tBD6i4InhJCTq3YZ12TcGNfnPKZTP6jcPZj6rjn8XleypEza34y78IH94rpxaTwsmhaH3Pbqr1sSsMDof81uV9dlAYsZsUdFW4g4mxe1xbQ2mqfcYI+RJpSSdAXy6Bp8m3GRnDPf6NPuI07GN9BLrQPR3ErZ3iNQ8noCMMiRyEwz0CeQG/OZLgWnM0IqVYCX4t5xahreyfJw0XXz66xsSPcZp1y66Ms/1qPjEzioy2RTkk73wwMrc7XCT4pttIDt6TFMrT+oIgg28KmYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() reads another process's memory under the mmap lock. On
large machines running big multi-threaded applications, that lock is
contended between readers and writers: an mmap() or munmap() in one thread
stalls readers like /proc/PID/cmdline, /proc/PID/environ, or
process_vm_readv(), even though the memory they read is almost always
resident and reachable under the per-VMA lock instead.

Looking up the VMA first requires untagging the address.
untagged_addr_remote() asserts the mmap lock only because it reads
mm->context.untag_mask, which can race with the write in mm_enable_lam().

That mask changes only while the target is single-threaded, when it
enables LAM or resets it at exec. The read need not be stable: it is
already read locklessly elsewhere, and a remote untag is best-effort.

Add untagged_addr_remote_unlocked() for callers that have not taken the
mmap lock, and annotate access to mm->context.untag_mask with READ_ONCE()
and WRITE_ONCE() so the existing lockless reads are explicit and
KCSAN-clean. untagged_addr_remote() keeps its assertion and shares the same
code.

Assisted-by: Claude:claude-opus-4.8
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/mmu_context.h |  6 +++---
 arch/x86/include/asm/uaccess_64.h  | 15 ++++++++++++---
 arch/x86/kernel/process_64.c       |  4 ++--
 include/linux/uaccess.h            |  7 +++++++
 4 files changed, 24 insertions(+), 8 deletions(-)

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
index 20de34cc9aa6..a095165eb648 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -39,18 +39,27 @@ static inline unsigned long __untagged_addr(unsigned long addr)
 	(__force __typeof__(addr))__untagged_addr(__addr);		\
 })
 
+/*
+ * mm->context.untag_mask changes only when the target enables LAM or execs,
+ * always single-threaded. An unlocked remote reader can race that; READ_ONCE
+ * keeps the value whole and the untag is best-effort.
+ */
 static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
 						   unsigned long addr)
 {
-	mmap_assert_locked(mm);
-	return addr & (mm)->context.untag_mask;
+	return addr & READ_ONCE(mm->context.untag_mask);
 }
 
-#define untagged_addr_remote(mm, addr)	({				\
+#define untagged_addr_remote_unlocked(mm, addr)	({			\
 	unsigned long __addr = (__force unsigned long)(addr);		\
 	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);	\
 })
 
+#define untagged_addr_remote(mm, addr)	({				\
+	mmap_assert_locked(mm);						\
+	untagged_addr_remote_unlocked(mm, addr);			\
+})
+
 #endif
 
 #define valid_user_address(x) \
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d44afbe005bb..9fa659117f38 100644
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
@@ -952,7 +952,7 @@ long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
 #endif
 #ifdef CONFIG_ADDRESS_MASKING
 	case ARCH_GET_UNTAG_MASK:
-		return put_user(task->mm->context.untag_mask,
+		return put_user(mm_untag_mask(task->mm),
 				(unsigned long __user *)arg2);
 	case ARCH_ENABLE_TAGGED_ADDR:
 		return prctl_enable_tagged_addr(task->mm, arg2);
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index eddbbb65ccc4..7e6e4c89184c 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -34,6 +34,13 @@
 })
 #endif
 
+#ifndef untagged_addr_remote_unlocked
+#define untagged_addr_remote_unlocked(mm, addr)	({	\
+	(void)(mm);					\
+	untagged_addr(addr);				\
+})
+#endif
+
 #ifdef masked_user_access_begin
  #define can_do_masked_user_access() 1
 # ifndef masked_user_write_access_begin

base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
-- 
2.53.0-Meta


