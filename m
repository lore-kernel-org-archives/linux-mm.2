Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C90C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E696B00A4; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F066B00A0; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF686B00A3; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 310156B009F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE4921401B5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:20 +0000 (UTC)
X-FDA: 85025115000.06.A3EF482
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0BD2C140009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=DwRMlYPQ;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IF4h0IOGesCPD6JnizKVFYQDqwHWpzKQAHqpitemykk=;
	b=qqbSTXHgnmGkhdvWsWMq3A+nfLDm44Dh4jwIOILQGuajhg+jCPT8X2O6v0Wray9EHAzlsz
	P/2OjzDrM8zO98GCBVOVfI/J6P7i58i4O1SZPYXeg3wrvsBEH/S1IIFM0RPPfqHbYysicD
	8KTSwhbFRinAPeGuT+Mm4aM0gy29cJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932219;
	b=tqS9LEHgWrXFcLEcuTFhHF8gIcR9M9H6m3Xd+Vaa+7cMfIVdVnK99BiOI3D14SNgAEJFvv
	8F4ShKyayMvGklfLy5/ivVPNTMng4XINODYTRAR1DQ9gnntaOUY6Hm5mWKc3c0qqc7qGcz
	X1fh0DK1eKzsebjmMwwT11Ytz6gAf0M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=DwRMlYPQ;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IF4h0IOGesCPD6JnizKVFYQDqwHWpzKQAHqpitemykk=; b=DwRMlYPQpIsFsEsXZzPPL3sxm/
	XwEli1sW2qLlJIwTseXX2o/q1glQCXOW/6qb3eWO+YB9NsZJ21DXr8JDOmcD4G8gCuqrbySUNPK0X
	AeN9ZFPsQawYFLRUwxaTF0qcs/+YwkcQm3g17KMh1EuuHv6EHqkdEfHW5IDK3KUSQ5zpTkQ75MAe7
	xMin7ON9QwNgwRZWPvemLN7ReOBz/2+blnX+hqbzOcZ+CVBqoJItKziZOvlfBfywfefvI80kHSH7u
	48Irw4hOCzBUYEdb5XsYKbjnzXSQK4vHCnAHc0nabbE43UPB8NzmeRB55+/i970oo+hEwo0d6bduS
	oRzqlBOA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-14Iy;
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
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-riscv@lists.infradead.org
Subject: [PATCH RFC v4 02/12] riscv/mm: add untagged_addr_remote_unlocked()
Date: Fri, 24 Jul 2026 18:29:24 -0400
Message-ID: <20260724222934.1463812-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0BD2C140009
X-Stat-Signature: 35t5byeo7gjpubwp9n9sya35p6qcr16u
X-Rspam-User: 
X-HE-Tag: 1784932218-209358
X-HE-Meta: U2FsdGVkX198cCIFJ2SjOF5raSYPOL04FUwC2uK6Vq84YseLwXlA7iXNafBUPtXserku6IzTu/HvZ14C7JLOLPUaMDf3ZD7wbsMQFuDprpUkBI1kJCt3d52JOZasgv4Y1a/f4HQh1o+YPigZ3NfS4Ny426hF5aWDMhzaqtqyqYLx0CISauEiTiNibmmmj8KyMX0jbl4oNzqwAJP4mZleYQFz3CkzmK2JylamV2tnhlAxoMRrT5AjeLUK8j45U5lbR2kpT3rySoFxV61TVIuXLbnY0abkwNx+5EL19lyuKWqVyUM3kXABcalklNUkPfceFs36HzvkF9QafdMfdi61d1cC9mjH11BRdDmQlK+ZDbAxjJk6bA9HXer6Wxx2lDHAceY5eurIxC2mQD6jMaspQjrpiuXkHj18W/gQVKj4zYFPLmshej07+xVL4Fsao3O/WMP7AUY/CnmeAwjxW9qdHUVN+VkO2hjq6GRgRPoEfK1ADh5kLaBobEOmSR//whTrN4el5cNOeMBeFywFLD0SkNCciJHObFAV0VKOFZq2K8fdJaAJdcqqQcBOOUsjJOLClLgu3nEqJCK7ytzSy+397luQqVqh96TmTZT2sA/VJCrkA+DERyOFja+eultErrI/UeDaiSt1wTv+Vxo3qrjcjbZHiIq2OnqRlDv8kUmH1Q5mSnfmshXZskcvWFyJS8h8pOWPJFxNxfFCysNhAiRdhJ2UxFvbU7U04b3w+twfgL3VdwFcwrt1ZBhf8Qt9rcyvgaHhUrYxuBACHo3FM6lzeMjTGtv+lW2JvqNIMl7Azyx0l49M+5tVffCQG3ufCcfJzo5amddUlxgUqsKU6kOlf6VA00Sm+94VpickmoKf5yAcVEDcgd8PfO2rNZFJWxFZHaINYEia/5t3unVb072HZWWT5dHhxSynCMqf56IGnosEADAj21ztp5t3Ghr/G0nPR1J5ELTZF0ZM84sec63
 f+78hDFZ
 hljCiBl6ko4z+Irs/Y/CHqcsEVWOu3w05FaR68gwZFzyKfqbFXEH0z9F5nwPMjz8AwQvoM2C9Re+htyMx7kjWH79Vbgr9w9LWf9nu5UuLuzRRTPr11pV+LlJMi7vecpdcF+08MROjg/pHbg9lUCMmM7Mz3Pq5DWTyRQXLRZMG32UpPRlrBkL6klOMO2qKPwzLCzdyvnnOzF8RgXyj8belhVVH6d95aOfvun6hn+WwWWAhOeOzy4O1WiSUFzkJhDQb9VMFzB1uBYqJdijjDVX5UHcvfFbLuKfAL20K2oi2/F6W/sGiLNY3+RqtYcPgMA8nsyyq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() reads another task's memory under the mmap lock. That
lock is contended on large multi-threaded workloads, where an mmap() or
munmap() stalls readers like /proc/PID/cmdline or process_vm_readv() even
though the target memory is resident and reachable under the per-VMA lock.

Reaching it under the per-VMA lock means looking up the VMA first, which
requires untagging the remote address without the mmap lock. riscv's
untagged_addr_remote() asserts that lock and has no unlocked variant; the
generic untagged_addr_remote_unlocked() falls back to untagged_addr(),
which masks against current->mm, not the target mm.

Add untagged_addr_remote_unlocked(), which masks @addr against the target
mm without asserting the lock, and redefine untagged_addr_remote() on top
of it so it keeps the assertion.

The mask width is mm->context.pmlen, written while a program is single
threaded, and frozen with MM_CONTEXT_LOCK_PMLEN once it spawns a second
thread.

That read need not be stable: pmlen is already read locklessly by
untagged_addr() and mm_untag_mask(), and a remote untag is best-effort.
Annotate the lockless reads with READ_ONCE() and the writes with
WRITE_ONCE(), so a reader sees one whole value and the accesses are
KCSAN-clean.

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


