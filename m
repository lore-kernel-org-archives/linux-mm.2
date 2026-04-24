Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBD8FE51F1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 09:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06EDE6B0005; Fri, 24 Apr 2026 05:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FD06B008A; Fri, 24 Apr 2026 05:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E521C6B008C; Fri, 24 Apr 2026 05:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF12A6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:23:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D4C114072D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:23:38 +0000 (UTC)
X-FDA: 84692911716.01.F65532C
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf21.hostedemail.com (Postfix) with ESMTP id 36B2A1C000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:23:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=rtIERuUY;
	spf=pass (imf21.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777022616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tQ8JWfpO9xD8Zh3e6LE/YGI3e6p3A9zZvIzDas0gdfI=;
	b=ohsFhrbjkhSkZs3y/QK8V9H9UkxfL4GtuHo96q5bM40JAx/1MZWuchCPSDIeNex7lb2cH+
	eAbh4//BbN+qhlz/abjE+R78RCHDWe3a+GHqpBRWdOOvr2UgGHWnwEOwCd4o7A/CAAIDrX
	WM3HC/zmQYsa8tKa0ZYHgTalyqgpkXQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=rtIERuUY;
	spf=pass (imf21.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777022616; a=rsa-sha256;
	cv=pass;
	b=BYcb0KBoqXWk2zyxLG9ApokdYJXybRSAgyPdOx3vDbP1j0GROtLWxPZgvz6gUfKjdCS9l1
	nwB6Tvy6NkC1bA+W9h3Y640wnw9tc+YEqt4FjGDqzXfu+kBFX6zvVrdsZtwAlTbUm1b773
	ICCq9fBnWd35MS8VoqMyQMpqCgpwMCM=
ARC-Seal: i=1; a=rsa-sha256; t=1777022598; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=J7DUkWFqFmqyKoeE0Du6wqO2tC6enX3KXX1ntnmPdxRTcSCoPMiWiIjlsmpQ7vQGLnTaKfhuza7iSE9Ctoco7WRW83qOAgayqmRWD2Yljmx4m9yTmxlPMr0yuWAR2H1y3B1fWjhiiQee/Hl9wciGDVjX/7kgZRtAC/ScEykyAh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1777022598; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=tQ8JWfpO9xD8Zh3e6LE/YGI3e6p3A9zZvIzDas0gdfI=; 
	b=QeC0dDVYvW6mcoZvUgHb82N8RslrOd7mHAxiiS8vDI60+8/K06t5UoOrjUJIfxcvBSni455IODZ5urXoysPaCa9+roDPu0PQikxCI2ufVbTdWrkJjZMfC30046qHmkLenh1Ir0BZQGe2S61SJldCU9UTwBDFlGeS0FFb8X6GLzg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1777022598;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=tQ8JWfpO9xD8Zh3e6LE/YGI3e6p3A9zZvIzDas0gdfI=;
	b=rtIERuUYXODbqrGJ1kE7bCtGx8PPiM6SLI3/F5qaUBOZDR1INoKEGA1YgdYzaC67
	jlvQV14E/05+UASOmw85PGZTFiT6A5mg0JFQNmgRXKdiQwg25xSlNdjozzYdpX2Xpqq
	2tsmtfyzwKZj0r2EgIbOOzxnuW7qhBu6p9T8NQC8=
Received: by mx.zoho.in with SMTPS id 1777022594995823.6057481970303;
	Fri, 24 Apr 2026 14:53:14 +0530 (IST)
From: Aditya Sharma <adi.sharma@zohomail.in>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	Aditya Sharma <adi.sharma@zohomail.in>
Subject: [PATCH v4] mm/memory: update stale locking comments for fault handlers
Date: Fri, 24 Apr 2026 14:52:17 +0530
Message-Id: <20260424092217.263648-1-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: p5abn8631981p3bmwhddbqynwe1578ir
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36B2A1C000F
X-HE-Tag: 1777022615-618493
X-HE-Meta: U2FsdGVkX1+Js5WwQkzSjfvCEMT3ToEeXeDdwTwF0cwE95XDHU+dKsseCykvLMQaLr7n7jDcrH6++Z4l3+9HSprzRZIodeKibRHKfZ1uW+cEKtOLjqFgvLjrQtxQDS92dtg/znVhFwMxR2h62YnRTK2mmeZPDsNtxUwRPARjwZaLf5LrP0D2tmKL7M7+3V8haDhDFXdAvQVNMgd8jp2nzVo6s1nkTOl6xL8CGNnyFirDW+sxQfEQcnj75VLMvXyA86nPm8QR8GVzfyielrvse5xLi8RUYfMHjnXNurGw9vXYuQZp1/3P0ymbD9LPuYQ+atCe5da+JesIUYpD01cEgEL3b3Eh8/oNXRmqVrOAlN1mkC07a1nK0KfYjf7KSS059TAnbcs0LBueo4+EabWsxH3JzZgLK4nC5Ta3GwKMOVSC12IvSTH6cj4H20d7BKkD956lPmnhrbmsaWJHbYYN3kqeEihgEBpxMAKOfZJQiC+x4rO98okelpFDKSkWrefIXdDrErwJr0h8XCCz+9Cd6gIrNu56O8Q2gaFbQ8L+6F3UO9uYVlDINY4aRDnJmAHbXmpu5je3EwohG33TkuC0x86F263NbKqwQkyf4lQ1GuBQrBoXuYwZNO0KeuOD88DMZRVHHrEsXqBZgCIMlRMD69CjsNyzo/5DYyEfLKRo7UFkgj3mZC/f8dt7C6nBlUYPrD+nB4mAjAxehHEZbWCxc6Q7Nj8lIBQhBJSi6XEYbwRcES2Q+ejSiTWuOCklds588LIjPGMKBKUyOln8jEq15bTqhBsEAmu2wej/oAwJmmtgm5gW44n73g54EzbFeWTYZiJCcl9xfVMArQ8L2RwJZDH64hY6/s3yB0QZuF9vyv8H30wSj/AQC32YPU1k/ZUWdeQry9Vb+ssOLAeNYeOYPWdPI72Oai4pT6qxU6LXuclJJUfv/Lf9ewT883O7O1FzTgndaN7yIfzmcDw98PR
 1u1ax52b
 nyVk4J8U3xOWEVgdyeGqmL0jgQ4h1P5p1NeyudDTVsE4uVe8Ho9yuzES/WH3/UHkFGmHGue2ZMTGUe2TO5gr+ue2ik25HlkT40yAZnmTe2A4eLbj//qUEfmO/4fVwa42QR2+3X5Qz/aCLbY8QPvK/l0P1Zf7kpiVgeTY/mBG9s4HRQrq4ZT0O0q0YGrpD2qkSQtaYRbJo+FD6eiEwgt2vtRdylsLtkvTeFacY9UvNF/HlWWvK9umFmASuGIDn8HW+8A2lAjFooGcERyXo1pDQY6Eo451TUzGK3TtQBkKkq3ffLthbgYQmpSTagg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(),
do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(),
__handle_mm_fault(), and handle_mm_fault() to concisely clarify that
they can be entered holding either the mmap_lock or the VMA lock,
and that the lock may be released upon returning VM_FAULT_RETRY.

Additionally, make the following corrections:
- In do_anonymous_page(), correct the outdated claim that the function
  is entered with the PTE "mapped but not yet locked". Since
  handle_pte_fault() unmaps the empty PTE before routing to
  do_pte_missing(), the comment now correctly states it is entered
  with the PTE unmapped and unlocked.
- In __do_fault(), update the stale reference from __lock_page_retry()
  to __folio_lock_or_retry().

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
v4:
- Rephrased the do_swap_page() return-lock comment to match the
  style used elsewhere in the patch (per David Hildenbrand).
- Added "(see FAULT_FLAG_VMA_LOCK)" reference to the __do_fault()
  comment for consistency (per David Hildenbrand).

v3:
- Rephrased the lock state to explicitly say "held" (e.g., "either the VMA 
  lock or the mmap_lock held").
- Shortened the FAULT_FLAG_VMA_LOCK explanation to "(see FAULT_FLAG_VMA_LOCK)" 
  across all updated comments (per David Hildenbrand).

v2:
- Simplified the comment to concisely state "either the VMA lock or 
  the mmap_lock" instead of a verbose explanation (per David Hildenbrand).
- Expanded the scope to cover 8 other fault handlers in mm/memory.c 
  that suffered from the same stale mmap_lock comments.
- Fixed an additional historical inaccuracy in do_anonymous_page() 
  regarding the PTE mapping state on entry.
- Updated a stale reference in __do_fault() from __lock_page_retry() 
  to __folio_lock_or_retry().


 mm/memory.c | 55 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86..f94e16ecc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3742,8 +3742,8 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
  *
- * Called with mmap_lock locked and the old page referenced, but
- * without the ptl held.
+ * Called with either the VMA lock or the mmap_lock held (see FAULT_FLAG_VMA_LOCK)
+ * and the old page referenced, but without the ptl held.
  *
  * High level logic flow:
  *
@@ -4142,9 +4142,9 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
  * though the page will change only once the write actually happens. This
  * avoids a few races, and potentially makes it more efficient.
  *
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), with pte both mapped and locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK) and pte both mapped and locked. We return with
+ * the same lock still held, but pte unmapped and unlocked.
  */
 static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	__releases(vmf->ptl)
@@ -4696,12 +4696,12 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
  *
- * We return with the mmap_lock locked or unlocked in the same cases
- * as does filemap_fault().
+ * When returning, the lock may have been released in the same cases
+ * as done by filemap_fault().
  */
 vm_fault_t do_swap_page(struct vm_fault *vmf)
 {
@@ -5210,9 +5210,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
- * We return with mmap_lock still held, but pte unmapped and unlocked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte unmapped and unlocked.
+ * We return with the lock still held, but pte unmapped and unlocked.
+ * If VM_FAULT_RETRY is returned, the lock may have been released.
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
@@ -5330,9 +5331,10 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 }
 
 /*
- * The mmap_lock must have been held on entry, and may have been
- * released depending on flags and vma->vm_ops->fault() return value.
- * See filemap_fault() and __lock_page_retry().
+ * Either the VMA lock or the mmap_lock must have been held on entry
+ * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
+ * flags and vma->vm_ops->fault() return value.
+ * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t __do_fault(struct vm_fault *vmf)
 {
@@ -5893,11 +5895,11 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults).
- * The mmap_lock may have been released depending on flags and our
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK).
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
- * If mmap_lock is released, vma may become invalid (for example
+ * If the lock is released, vma may become invalid (for example
  * by other thread calling munmap()).
  */
 static vm_fault_t do_fault(struct vm_fault *vmf)
@@ -6264,10 +6266,11 @@ static void fix_spurious_fault(struct vm_fault *vmf,
  * with external mmu caches can use to update those (ie the Sparc or
  * PowerPC hashed page tables that act as extended TLBs).
  *
- * We enter with non-exclusive mmap_lock (to exclude vma changes, but allow
- * concurrent faults).
+ * On entry, we hold either the VMA lock or the mmap_lock
+ * (see FAULT_FLAG_VMA_LOCK).
  *
- * The mmap_lock may have been released depending on flags and our return value.
+ * The mmap_lock or VMA lock may have been released depending on flags
+ * and our return value.
  * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
@@ -6348,8 +6351,8 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 
 /*
  * On entry, we hold either the VMA lock or the mmap_lock
- * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
- * the result, the mmap_lock is not held on exit.  See filemap_fault()
+ * (see FAULT_FLAG_VMA_LOCK).  If VM_FAULT_RETRY is set in
+ * the result, the lock is not held on exit.  See filemap_fault()
  * and __folio_lock_or_retry().
  */
 static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
@@ -6581,9 +6584,9 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
 
 /*
  * By the time we get here, we already hold either the VMA lock or the
- * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
+ * mmap_lock (see FAULT_FLAG_VMA_LOCK).
  *
- * The mmap_lock may have been released depending on flags and our
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
  */
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
-- 
2.34.1


