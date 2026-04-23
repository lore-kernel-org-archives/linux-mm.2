Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA67FFDEE2B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 16:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DBE6B0088; Thu, 23 Apr 2026 12:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDEC6B008A; Thu, 23 Apr 2026 12:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCD76B008C; Thu, 23 Apr 2026 12:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD0B96B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:57:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43B601A035D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:57:38 +0000 (UTC)
X-FDA: 84690426996.10.AE3D5EB
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2499F8000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:57:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="xCRe5/FN";
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776963456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bTpepXrqOzl9lhQcjh/bhp9I0cYkCXGZ5uxxx7tU9nE=;
	b=R2qgvyIMuwiKC1pz/wq0c6kDcSARpGx8I+TmkIkyfFinKsXngpZ1vXsfkZRrdZ068rWGCM
	KY55o3oAW5I+vYGLp+OFVQBpzbEz76Je1SZXgpMPWEltl+avwJUn7N6QfocgzQyojVcCJC
	PoZ9V3MDAGJCWHAC0IXQsPv8DhFeHgw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776963456; a=rsa-sha256;
	cv=pass;
	b=nAPllay08jiDs4q4/wPdd1SWvvMm0Tl32nwtB6AeRUTdpPfYOSoc6BYKndOyCmuHL7Nsmk
	O9GattmQBf8bfMbPCvj+pDVnI+PSHkkNGe3hx9kEyxR/KCyeuEa7i8qWxqo7RSSvwZgLWE
	W2y/yUt3v0oRv3Q59XoNwxNKxAz6k1k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="xCRe5/FN";
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1776963437; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=btCkjrEtsyVPsR9+OFVTKWKG5w/pdb67DihR7cde+9rXDhbyS/1nL5dINU/vyW26OJBvT+eP134XXRut1LqdKVI0W6u0Z8lwTREKrGCKb9pKY+1W7+pvBkBBAZsf0qtibD8aZIT8KPX8nbMnFDXOS3sihhT52D312nUVDZOBesM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1776963437; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=bTpepXrqOzl9lhQcjh/bhp9I0cYkCXGZ5uxxx7tU9nE=; 
	b=fdCwGCCCQJoleSToHVJ/IwGcujOjxxNDElYrUUd2egD/j0OZKrvSdltBWhPWQSMC6DK2BybJYEAoIbZii6OBYDYB4jElnQEMzpdjZ3TdtMz7JS5R5lDtbTN2O8htFCGZfMIPDRLwG8z05rq1yZAaaMpTV1BeD307ntF659TWkQA=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776963437;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=bTpepXrqOzl9lhQcjh/bhp9I0cYkCXGZ5uxxx7tU9nE=;
	b=xCRe5/FNH9LSMaOEiOOkFOxEhvpbp7tm9+KrlbIYs+NnVEgmSCt0YsXAmoLRlab1
	GmlwLyndf/NLms7rtbQqSFjkAiMhP7bahMhxRbURVp5Vwzwjmlp4F/uhJVwCyL9NDC7
	UoD+vswN++lrKlri8cYXnnnPCdQJskqVa0pBKxdk=
Received: by mx.zoho.in with SMTPS id 1776963434245116.48353661832061;
	Thu, 23 Apr 2026 22:27:14 +0530 (IST)
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
Subject: [PATCH v3] mm/memory: update stale locking comments for fault handlers
Date: Thu, 23 Apr 2026 22:26:09 +0530
Message-Id: <20260423165609.251787-1-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: qpt5o9fuy4txnjexwesrkmoni1x1fzns
X-Rspam-User: 
X-Rspamd-Queue-Id: 2499F8000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776963455-60190
X-HE-Meta: U2FsdGVkX1+QQ88zVUDiHg7goIpwl1zWzJl14Q/5Ai8OLfmKXWTAnZLufHDxx0R+nOXDpGid3wQ1G1es+uxxiCaqjn3DgNBCx54EVkiskWgTxGeyOFlNGCxi+xfQaH7M9BT9iuss2zdvIl6Aqg29pcB3ACIkXCsFUNAlFKrvXxiVQ7gQikd5y95tq0z6RACqHI41XvSD7wvFw0cBRpbCSOYtrazkLlGXPGwIc0pz37A4Vw2HSQp1qC8/FguGLICbVcu9myj2hTGiz6J0OPLZid7NLm+YQUSTpzJ90q6q62hXH5YZ6bQYjA4Ov/gg7ivhgLcBBg69GidoGUSWi582bj9TWdZHH/0wWJZOaeXeZ1YTeSCXipLWyAUxpsz465Zn14W98LoUzPrTu6wt7hdQ9CmEi127ciWYM/0ZJG3jTcK+pF2h9OiJGIja6oNgiaGyD2grliah8UTQyryMsN6GHiG809oAvoTvpqr6i4fq6SZrQnTTCaZTdm9tmCFBbJuxYN1LBOBgMSfBu1FWaTfwusGybmlFO7dFYpLbxsoW8akeO+kDwy6H9Ny/6BGXB5Rxo4YF/hc5op1f+BO5/JA8szob3odNp/mgBJO9UW2JucjKT7nZaubgtTIVQQufNXmfm2vobepqWh8K7JJNTgdPfg8qN3SmO3r/7jWL3NzfnFdw1SfaBhkk/fbZXdD3kvWrlmjs19wuzQLP5zCc5FLYNbVMFwoGWCZkqxtaFMPJAcgSX++MXjLRK2BgSaoMaaFKwfhIE9tPkeERYCjdVG1Gfgb4P1Dm8ryIm9wuimmBzaIuTAwhAew/x6Gef5kl6rqCyRAs71G4jnkgcylXeH9C5hlAC9h4QcOooUHBKRUY2Ex5a6P8ITB28x6CatQmdOJB1U7dCLHlXLvaXvVh1dAmzuv9IOftom4H1eKhRfg4KVvAC/oLjwQmv75vF4BDSMYEhjv8OAOPqG8BpUg1+VU
 43P57AuN
 EWAGfHoESI4JLAujxBTjM8dWlIfXrHvJ+IxQ8RqsNj4EyjeoYKiRuNNmQTq1MM70TuP+MGIZAVGKbZp1lk1b3nXKzkX1wmMGnPF1CmgnNnqxftfSTbPPZ+PQrM9h24mGehqw5qx8VFoEdiVL69yzZpDh14pzMn5AhhhpMTWcpx4ftn/Q85Wzsp6ay1zExJcu/uWzh1+CA1zPNc7Dn1psuKxhbQrhawOxE5WQsY84qSRXJpRfPBgFWUGlEg/KuCmcuuh5KSTNr7xoQHDiSIPdlP4A3oMWLYdFC+D7k+nt6VvUd/Pi1MS23z1HKng==
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


 mm/memory.c | 53 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86..302ccb82e 100644
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
@@ -4696,11 +4696,11 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
+ * We enter with either the VMA lock or the mmap_lock held (see
+ * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
  * We return with pte unmapped and unlocked.
  *
- * We return with the mmap_lock locked or unlocked in the same cases
+ * We return with the lock locked or unlocked in the same cases
  * as does filemap_fault().
  */
 vm_fault_t do_swap_page(struct vm_fault *vmf)
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
+ * Either the VMA lock or the mmap_lock must have been held on entry,
+ * and may have been released depending on flags and vma->vm_ops->fault()
+ * return value.
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


