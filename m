Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E38C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16236B00AC; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2696B00AF; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69816B00B3; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73CCA6B00AC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E72BB1C0160
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:12 +0000 (UTC)
X-FDA: 84998883984.19.38F9C0A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8A40140007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="keJ/nUbp";
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUviapJKXkmCmGZC2J3yV4WlPPv4IevEHJi7vfOXIEY=;
	b=tZbsGQqjAtOhd5Wnv2boQX/DVDgM6f0O4WRX4lnxGgw1HKkm9yktbARtLqnDQRtu1HQ9tg
	G+pHfv2xTC2eEFYncez0kHYUp2cDuc+oLzs1MYxXoEgttZX69H5W0EvbSHtRmc9pBXu84d
	HTu/N110mNuNBojqCeSJK/I5RKu4OHc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="keJ/nUbp";
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307671;
	b=C/nxGMclyZ7IZ3c3Ceo9jvsF4VzHoTg6ahRlU4Yjtp2804wmVZAedjuiYZStpBntvFzHi+
	HK0GfpUvbOpCGElSLeSmbNlNBbEwf613aFht/C53kyyNCUQ87nnZGggBHZQSf95p6UnsKf
	x80Z80S6yOWm5u+A5iWS+Y9fj0eU2KU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iUviapJKXkmCmGZC2J3yV4WlPPv4IevEHJi7vfOXIEY=; b=keJ/nUbptoUuFh/dToE97NtnUe
	VF5w74JwYDghMknIO1vCHJRLKILijbOsApAT2KOhOMApTwn3oSPvSO13CSd9sdT4/uIBn/JSu2n1W
	KmwmQLCY5Fc1HbS1rG6cq7Ff2QCxlzAeJnGmGYHr+9TXVsCX7of/X4tLnbiK7BHXHX2pwNyxw0yB3
	ZPU9ADhqr5QkLi74kuE9XKZSM8lUNJUK+4Xi6xVvaZzaICVclMULUqYXAqvVP/9OVNO+2sEcc2Jha
	kn2HLdLkIL3x/SCM1fP0tXsnO7AeL6olcpxFOY5X7yJpijb9R9LZV3kgyAcp/fOGTSV52EktqYOn0
	UxSzeejg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-0DlG;
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
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH RFC v3 1/6] x86/mm: add untagged_addr_remote_unlocked()
Date: Fri, 17 Jul 2026 13:00:31 -0400
Message-ID: <20260717170036.743149-2-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
References: <20260717170036.743149-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C8A40140007
X-Stat-Signature: jrecuz1x3ghi4ueh5h46ty4q68yxfmoj
X-HE-Tag: 1784307669-320183
X-HE-Meta: U2FsdGVkX197Eq8AI8nGHBmDDPGfW4T/G7JjIw3FS21a06F5SOJ5hNg1wn+iWomrztuuW/Nf+60OTU7v9uv37WE89pHgUDK53MhBv4ZNgLW8ibmF0RrKwZMX1DdANdGeMuIIT7r1MrHY4ChQYAqyjM+TXvk2zpZTZ1KFQiCABIzq3pVigT9yNz97nyyvoPsFQ2hCC/xDBsicevMPLs9zHDkVDq9ssgKbvtW0+O1EY/K9IvXEX9DlXskFoYw0ImT4UcTK9YBihvrWVLW4pDyzTwig478DvfyoKEJxMGNruZNq8GjyzOQl8pcP59ak/u82pnAWikxVj5iMCCzlo4ssgKtcmxuyHnF43PD/XsIX1TkdYadSnk/WnytP5tM+gypMli5ejvQB1YVYt1yZaP6sbYWmaK6xwEZhuWdA8np0piaksYmY1gIGnALj0bMaTOBDoBv+k3zz5mDaQBg9F5E0J8kMA/8PFaWHKpOZbt70E3dzHT20AuZ1WV5WIbRbIfcaJYYWuMs2e8UHJAaLj/c/UCVRIrgt1bF3l1LtroBJgFxoiCI33LcszsGBNJSdlAJ3j0pGnRivqLWsIa1HCz1Y2L9gLiiMqUrJ2Rev7+K/OLmLfIesyRc53pVlU8dUVNfmncGSTZ8sZCh3vi6XejkXEC1RQm7IoRPLyOKctEUqO4bXrDmmHZBNq6cg7E7/y5c0ioM6sZqbnZBNSFoumorp3idUe3A0XrKP5ujonXLv9PzmY8cDwfemP8a0Q7xPIJFM9UC6Q2NYZkcrrT1/ykjjwaNMBca1Z5I1/ri7o9Qzz6lr3t9JYGBK/u1w5JfrQJXjyUzWV4hMyjt2b/41zyTI6PJxXBc0ljmYyOFKoxjjeig2I+h6WJnREl2xDB5uopXUTcj+8TiXCNX4hMhuNDSD0hmDLAeoJaRO36M3iXCiQPdc/CqSueVAxPoDJbUOMmShiEGacDK8eFP+dRYiOZS
 MfvGen/P
 O+CxqP5i4edm14WYq3wReYvEhMrWfi6Wa7wXsv9mWMTYLa58zKGKVoLxTODkfDy07tSx/9RSHHk4mwLGYGKM+aWVUnHJtrf6iZKGGVQqBFDmpxOq1V86aWcpSharSMJyBrgQUjqHX0rmsP9sXyRtmy4jdLPxopmvLrtcSMPAtnDDsPAiGsqo1Dom/KtCig8rtzLbatiQXJufWsoE7skfjB3wPW8ywx2MKMz8F2QHhD4Y3/8SVib/O7BoI8SLvuDph1tHOWKQ7q3a/LeKl82CjFB6+Zjc4qGlXj8BTzhEpjuIo63nkc7h6HpN6KCeu36UY3vKlCTW8K0gJ+6e1gbGQO1Jqgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() reads another process's memory under the mmap lock. On
large machines that lock is contended by tasks polling /proc/PID/cmdline,
/proc/PID/environ, or calling process_vm_readv(), even though the memory
they read is almost always resident and could be reached under the per-VMA
lock instead.

Looking up the VMA first requires untagging the address.
untagged_addr_remote() asserts the mmap lock only because it reads
mm->context.untag_mask, which can race with the write in mm_enable_lam().

That mask is set once, when LAM is enabled, and never changes afterwards,
so the read itself does not need the lock. It is already read without it,
from the context switch path and /proc/PID/status.

Add untagged_addr_remote_unlocked() for callers that have not taken the
mmap lock, and annotate access to mm->context.untag_mask with READ_ONCE()
and WRITE_ONCE() so the existing lockless reads are explicit and
KCSAN-clean. untagged_addr_remote() keeps its assertion and shares the same
code.

Assisted-by: Claude:claude-opus-4.8
Acked-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/mmu_context.h |  6 +++---
 arch/x86/include/asm/uaccess_64.h  | 14 +++++++++++---
 arch/x86/kernel/process_64.c       |  4 ++--
 include/linux/uaccess.h            |  7 +++++++
 4 files changed, 23 insertions(+), 8 deletions(-)

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
index 20de34cc9aa6..05377ad804d1 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -39,18 +39,26 @@ static inline unsigned long __untagged_addr(unsigned long addr)
 	(__force __typeof__(addr))__untagged_addr(__addr);		\
 })
 
+/*
+ * mm->context.untag_mask is set once, when LAM is enabled, and never
+ * changes afterwards, so it can be read without holding the mmap lock.
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
-- 
2.53.0-Meta


