Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CD3CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB176B0096; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B006B0099; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8766B0098; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6766B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F6491A029F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:47 +0000 (UTC)
X-FDA: 84919477734.05.C36049B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id E112340012
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JY750gk4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417045;
	b=2IkUnlSzA+jghPUdMO88+WT7GjMtK30KovoIUPiEx4RR6dFohGLtDp7tjcuKqPZrJWWc10
	S7ZZVa0ZfTNJ0CvwhO2eXo3xQBixnujHzTqUEtMO4/fVt0OPsJC4tpo9evEH+LmT7S3OKs
	Nw5nljXMwrGvGpxnDz15nZfAcsiL0yg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQRU47JJNfGVXzF5pXjlArv9LIZyrfeqN5hqqIGQOWY=;
	b=tbADbtSgHz2FTLBD0WNUCuDb6JACXRPgE/W2OokCA2KXh5h0nzulwIqeL7m7oXG8hX1T33
	eublcbPv4Ck1I+nAgjsWOWSykktbS7JhdEnm6R0eBUfFfRyQ32vRmRrLMnYjuiTEoolq9T
	iPlAxrlpdOrpjZc2hJ4EYFU/x1yipmU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JY750gk4;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=WQRU47JJNfGVXzF5pXjlArv9LIZyrfeqN5hqqIGQOWY=; b=JY750gk4LCQE9BMeS/6rXuW7LP
	g4sWhM3GrtZUWDg60mcgInrLbdoxAzXip9oN3P7jxv9VphfSLEsaXpDN7joFn2wt5U+hgvMtcGDVB
	1kShEdOEJC0jSyIrzNjgpv8Je52SwBy5U72UoXlQk3GXKQdJF6zRQzRQP6WhYhzQ2doxx8P3qGPoJ
	DxH4Sv0b7UrFrilEHV1yZASQZIiCij1uzWruHEAa8MfRd79sgHxNm6lydBSRhFSuWzY323sm0LKce
	Tx5M5o5u1rJMonTZgCujA/kncss/6qzzdJrk2v/g5bDPnaUJ9xMXndINlGgH9fPuad3wqC9KKzd1i
	V0+7oKOg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq5y-0000000AWXx-46qX;
	Thu, 25 Jun 2026 19:50:43 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 02/11] mm: Make all page faults killable
Date: Thu, 25 Jun 2026 20:50:28 +0100
Message-ID: <20260625195040.2508362-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E112340012
X-Rspam-User: 
X-Stat-Signature: biho7zzw8hbid6r3eyjy5myn6847hq9m
X-HE-Tag: 1782417044-363673
X-HE-Meta: U2FsdGVkX18flzkvLOy3+OMn+Kb6rnOVNR2GP9nHTSWORda5dZpTJZmjFxtCmEA7h6gMzTZ964zE4xbBwAr/qbUJ2dw8Eu/pRwh/FURjYXo8mN0J2husDHnNArILN0sm48WotueyYlzVymw+i5ExSMqPW055Zjsz4XYnupXDWBPjytht9j8S8558d1+musJ1+JyCiR2/V79mJ6KvqSt4ZEpUloLggREPKVbKYcAgc5hx5clqxea3yZt4DNfwa2SHd3e2/T8JmF+ot52TKs1fus5LO5REPjrsD5qZJ1Ddww5ndJ830qw42MhZMxbe7zoLI7dNkXKSuWS+N+I9pin4VPQdlwwxPaHCg2uM/7WONEu+WHBGDqDQePwz1HmjdNkjh3VSZlRJQXcS3lnSlfqYtI6jlpuqykbRBsqtonJ0KQGU8ZVu37MVHAX3ggJh5mjNSO9m9hlSXrTUUFrs4rSAZAUJzQbF755TscZWm0WX8SpnJwiKcNX11hPzzy17k1JQLp4LAP2qU9mr9WtbT+950+9gXUKJ/m+wX0YRhWL5KzROwd6Kj1c6D6zXxGyGZB9DqDbpZxCmq609WPrh/KKkg6B8GuSr11HcVzGLI15qGvFZb6fHJ/Mg6AxAae1eyI4jyHvZx+JdHi6J936eM6BlSrUZhdoD28mZLqk32YVS8/tUI0RB9/RtaqLR/4zi6UXJcUCYsh66omfRBN0uLfobSFiVufjK7PCcORzzLG2sHQjNjF1wV1A1YTlhqQj2VrH6LnYpgE573cg029dbdfGFQ/xOuNj1e8SfGSLXrob+WYPodZ8Mb+WSElbI7qf0wwwi76Jqf+RhUzvXeqO+DFx6uNgvBqB5IcTl8DCsx54Alh2/8VsG8n8P6Nt/MbA1hCT4Fc0p/uhoOcOuB7Q/iBTXHcOcFbOcPGtgHa889j9nqTzvJOv5KhsDzqk7JqlxWAdUvqzip8XrMgcu8qotV4r
 dQqMen+i
 fBy5g0F157GNfXpdX7OLoZyWpQeHbU2tuIDM+avAwWQXqcUoGSy0VAmujOMnlImUvcblQa/OW8haJ1D2jyRYr/vbdiAl9iPuG35wTR9IyQLdpo1qVBxP7Np7+9yNpOW/j1ilTQZUGiW8Zggk33cmjndLW5zU17TDg7KIwwSQHngxZ93d6ZIc6gghzn0vbQbJbcu2WrWc95mFOc1IPinSEV1KFKn+9h+mgGWKbjC2xrrWD8KugSs4R9wSHGnH5jd5Ct+nm2hh+roHyjutE5DGVjAWLqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All architectures now use FAULT_FLAG_KILLABLE when handling page faults.
There are a few callers of handle_mm_fault() that don't specify it, but
I have audited all of them, and they all seem to handle errors correctly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 arch/x86/mm/fault.c      | 12 +++++-----
 include/linux/mm.h       |  2 --
 include/linux/mm_types.h | 18 +++++++--------
 mm/filemap.c             | 49 +++++++++++++++-------------------------
 mm/gup.c                 |  7 +++---
 mm/userfaultfd.c         | 20 +++++-----------
 6 files changed, 41 insertions(+), 67 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..dd9b50676f71 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1384,12 +1384,12 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * the fault.  Since we never set FAULT_FLAG_RETRY_NOWAIT, if
 	 * we get VM_FAULT_RETRY back, the mmap_lock has been unlocked.
 	 *
-	 * Note that handle_userfault() may also release and reacquire mmap_lock
-	 * (and not return with VM_FAULT_RETRY), when returning to userland to
-	 * repeat the page fault later with a VM_FAULT_NOPAGE retval
-	 * (potentially after handling any pending signal during the return to
-	 * userland). The return to userland is identified whenever
-	 * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
+	 * Note that handle_userfault() may also release and reacquire
+	 * the fault lock (and not return with VM_FAULT_RETRY), when
+	 * returning to userland to repeat the page fault later with a
+	 * VM_FAULT_NOPAGE retval (potentially after handling any pending
+	 * signal during the return to userland). The return to userland
+	 * is identified whenever FAULT_FLAG_USER is set in flags.
 	 */
 	fault = handle_mm_fault(vma, address, flags, regs);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..e1ec278205ee 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -682,7 +682,6 @@ enum {
  * arch-specific page fault handlers.
  */
 #define FAULT_FLAG_DEFAULT  (FAULT_FLAG_ALLOW_RETRY | \
-			     FAULT_FLAG_KILLABLE | \
 			     FAULT_FLAG_INTERRUPTIBLE)
 
 /**
@@ -709,7 +708,6 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
 	{ FAULT_FLAG_ALLOW_RETRY,	"ALLOW_RETRY" }, \
 	{ FAULT_FLAG_RETRY_NOWAIT,	"RETRY_NOWAIT" }, \
-	{ FAULT_FLAG_KILLABLE,		"KILLABLE" }, \
 	{ FAULT_FLAG_TRIED,		"TRIED" }, \
 	{ FAULT_FLAG_USER,		"USER" }, \
 	{ FAULT_FLAG_REMOTE,		"REMOTE" }, \
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..1691b61df877 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1759,7 +1759,6 @@ enum tlb_flush_reason {
  * @FAULT_FLAG_MKWRITE: Fault was mkwrite of existing PTE.
  * @FAULT_FLAG_ALLOW_RETRY: Allow to retry the fault if blocked.
  * @FAULT_FLAG_RETRY_NOWAIT: Don't drop mmap_lock and wait when retrying.
- * @FAULT_FLAG_KILLABLE: The fault task is in SIGKILL killable region.
  * @FAULT_FLAG_TRIED: The fault has been tried once.
  * @FAULT_FLAG_USER: The fault originated in userspace.
  * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
@@ -1800,15 +1799,14 @@ enum fault_flag {
 	FAULT_FLAG_MKWRITE =		1 << 1,
 	FAULT_FLAG_ALLOW_RETRY =	1 << 2,
 	FAULT_FLAG_RETRY_NOWAIT = 	1 << 3,
-	FAULT_FLAG_KILLABLE =		1 << 4,
-	FAULT_FLAG_TRIED = 		1 << 5,
-	FAULT_FLAG_USER =		1 << 6,
-	FAULT_FLAG_REMOTE =		1 << 7,
-	FAULT_FLAG_INSTRUCTION =	1 << 8,
-	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
-	FAULT_FLAG_UNSHARE =		1 << 10,
-	FAULT_FLAG_ORIG_PTE_VALID =	1 << 11,
-	FAULT_FLAG_VMA_LOCK =		1 << 12,
+	FAULT_FLAG_TRIED = 		1 << 4,
+	FAULT_FLAG_USER =		1 << 5,
+	FAULT_FLAG_REMOTE =		1 << 6,
+	FAULT_FLAG_INSTRUCTION =	1 << 7,
+	FAULT_FLAG_INTERRUPTIBLE =	1 << 8,
+	FAULT_FLAG_UNSHARE =		1 << 9,
+	FAULT_FLAG_ORIG_PTE_VALID =	1 << 10,
+	FAULT_FLAG_VMA_LOCK =		1 << 11,
 };
 
 typedef unsigned int __bitwise zap_flags_t;
diff --git a/mm/filemap.c b/mm/filemap.c
index 12e445a139f9..b7ecd03d4fc9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1746,13 +1746,11 @@ static int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
  *     mmap_lock or per-VMA lock has been released (mmap_read_unlock() or
  *     vma_end_read()), unless flags had both FAULT_FLAG_ALLOW_RETRY and
  *     FAULT_FLAG_RETRY_NOWAIT set, in which case the lock is still held.
- *
- * If neither ALLOW_RETRY nor KILLABLE are set, will always return 0
- * with the folio locked and the mmap_lock/per-VMA lock is left unperturbed.
  */
 vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
 {
 	unsigned int flags = vmf->flags;
+	bool ret;
 
 	if (fault_flag_allow_retry_first(flags)) {
 		/*
@@ -1763,22 +1761,14 @@ vm_fault_t __folio_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
 			return VM_FAULT_RETRY;
 
 		release_fault_lock(vmf);
-		if (flags & FAULT_FLAG_KILLABLE)
-			folio_wait_locked_killable(folio);
-		else
-			folio_wait_locked(folio);
+		folio_wait_locked_killable(folio);
 		return VM_FAULT_RETRY;
 	}
-	if (flags & FAULT_FLAG_KILLABLE) {
-		bool ret;
 
-		ret = __folio_lock_killable(folio);
-		if (ret) {
-			release_fault_lock(vmf);
-			return VM_FAULT_RETRY;
-		}
-	} else {
-		__folio_lock(folio);
+	ret = __folio_lock_killable(folio);
+	if (ret) {
+		release_fault_lock(vmf);
+		return VM_FAULT_RETRY;
 	}
 
 	return 0;
@@ -3289,21 +3279,18 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 		return 0;
 
 	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (vmf->flags & FAULT_FLAG_KILLABLE) {
-		if (__folio_lock_killable(folio)) {
-			/*
-			 * We didn't have the right flags to drop the
-			 * fault lock, but all fault_handlers only check
-			 * for fatal signals if we return VM_FAULT_RETRY,
-			 * so we need to drop the fault lock here and
-			 * return 0 if we don't have a fpin.
-			 */
-			if (*fpin == NULL)
-				release_fault_lock(vmf);
-			return 0;
-		}
-	} else
-		__folio_lock(folio);
+	if (__folio_lock_killable(folio)) {
+		/*
+		 * We didn't have the right flags to drop the
+		 * fault lock, but all fault_handlers only check
+		 * for fatal signals if we return VM_FAULT_RETRY,
+		 * so we need to drop the fault lock here and
+		 * return 0 if we don't have a fpin.
+		 */
+		if (*fpin == NULL)
+			release_fault_lock(vmf);
+		return 0;
+	}
 
 	return 1;
 }
diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..70c94d62fdfd 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1098,7 +1098,7 @@ static int faultin_page(struct vm_area_struct *vma,
 	if (flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
 	if (flags & FOLL_UNLOCKABLE) {
-		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
 		/*
 		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
 		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
@@ -1571,7 +1571,7 @@ int fixup_user_fault(struct mm_struct *mm,
 	address = untagged_addr_remote(mm, address);
 
 	if (unlocked)
-		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
 
 retry:
 	vma = gup_vma_lookup(mm, address);
@@ -1581,8 +1581,7 @@ int fixup_user_fault(struct mm_struct *mm,
 	if (!vma_permits_fault(vma, fault_flags))
 		return -EFAULT;
 
-	if ((fault_flags & FAULT_FLAG_KILLABLE) &&
-	    fatal_signal_pending(current))
+	if (fatal_signal_pending(current))
 		return -EINTR;
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 246af12bf801..77ed5dc4c8dd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2666,26 +2666,18 @@ static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
 	if (flags & FAULT_FLAG_INTERRUPTIBLE)
 		return TASK_INTERRUPTIBLE;
 
-	if (flags & FAULT_FLAG_KILLABLE)
-		return TASK_KILLABLE;
-
-	return TASK_UNINTERRUPTIBLE;
+	return TASK_KILLABLE;
 }
 
 /*
- * The locking rules involved in returning VM_FAULT_RETRY depending on
- * FAULT_FLAG_ALLOW_RETRY, FAULT_FLAG_RETRY_NOWAIT and
- * FAULT_FLAG_KILLABLE are not straightforward. The "Caution"
- * recommendation in __lock_page_or_retry is not an understatement.
+ * The locking rules involved in returning VM_FAULT_RETRY depending
+ * on FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_RETRY_NOWAIT are not
+ * straightforward. The "Caution" recommendation in __folio_lock_or_retry
+ * is not an understatement.
  *
- * If FAULT_FLAG_ALLOW_RETRY is set, the mmap_lock must be released
+ * If FAULT_FLAG_ALLOW_RETRY is set, the fault lock must be released
  * before returning VM_FAULT_RETRY only if FAULT_FLAG_RETRY_NOWAIT is
  * not set.
- *
- * If FAULT_FLAG_ALLOW_RETRY is set but FAULT_FLAG_KILLABLE is not
- * set, VM_FAULT_RETRY can still be returned if and only if there are
- * fatal_signal_pending()s, and the mmap_lock must be released before
- * returning it.
  */
 vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 {
-- 
2.47.3


