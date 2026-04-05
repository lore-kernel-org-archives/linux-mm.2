Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24761E9D812
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 17:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765016B0089; Sun,  5 Apr 2026 13:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF4C6B008A; Sun,  5 Apr 2026 13:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BBEE6B008C; Sun,  5 Apr 2026 13:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4718F6B0089
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 13:22:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E64CB1A0839
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:22:28 +0000 (UTC)
X-FDA: 84625171176.28.9B8C611
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id A20E920005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:22:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=OnjF72Jv;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775409747; a=rsa-sha256;
	cv=pass;
	b=kGFTg+d4F6yQHRrt5vCZPt3v2yhQvu7pbx16mGPwFl2da0xrhsBkA0kIOxg9G6w8mU3NZW
	UP54r+FjneNd2gmX1kC0zwJbCn0/jfJWmN2z/CRsXsZFtR/Wr33e9Ilbj5juYiB4jMr9AO
	HBd0+zQyssTywT1Sqv2qwB4/GAbpP4w=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=OnjF72Jv;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775409747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czjZYzl8IpvVjGZriCfygDe76v9wOdmo8Oo/MMFlhDg=;
	b=ESYj41cN29IT38PFTiaA7wMKIT1hMTpQeO4bflpZivp0GFKAGhpkj2kn6dIT4m1NenPf6+
	Sft7mm8F3ASFxsEgOskqJ5lgttN14eJzxYhTaxk5DFvMQ79+LqGiF0JtjQcFI8QouapPsF
	TKk+z6TLwv7BKFenn5DUJ4ZHIjtEnvQ=
ARC-Seal: i=1; a=rsa-sha256; t=1775409724; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=CYbJsI7rO4keDv1j0RKam3sCO105e30x0K48NxZdFrXfH4nRcxIsnVFcHGLPRnG7Bayprmjcz0YhthvNG0dQiexcfQiYKPNUnJT0K7Qc4n14nY/13y5rOlIIk1/VC+H4vbjmqVCdNTQpO7D3Y1m8/5Ik/naJi/WQdglF+rQpu8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775409724; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=czjZYzl8IpvVjGZriCfygDe76v9wOdmo8Oo/MMFlhDg=; 
	b=HdJ2E9BhhTV+49R3uIIFjKgG/dVGHSuwT8FFnB9d+WmC8F1RbLCPd4VWLqS6Lw9jZMfyQnX9Qrm4b5upHKmTymYEi+it/sec6Nr2ZNbfQ4tSqksoViZZFevHmatIZJ95gfqH/1HsM6h11LMTs5/ucgqLwrnqD57DclFkIiFriJ4=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775409724;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=czjZYzl8IpvVjGZriCfygDe76v9wOdmo8Oo/MMFlhDg=;
	b=OnjF72Jv+kTqz0X6fY/ksq6KdBgIkOzytB+MmYTamW5wCaWaGgcZZp+lwf5GYeBL
	4/LNwmXwN+FOL16RA7JIlEQQ/bis4OEYPtCNKyvzRn1BFgtHE2RLsAM6FyCZBikNPkK
	wyIHEJGPf2iWSQsnDluU+E694REDDPY91fZeBS4w=
Received: by mx.zoho.in with SMTPS id 177540972225570.15298322322928;
	Sun, 5 Apr 2026 22:52:02 +0530 (IST)
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
Subject: [PATCH v2] mm/memory: update stale locking comments for fault handlers
Date: Sun,  5 Apr 2026 22:48:34 +0530
Message-Id: <20260405171834.15971-1-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260331142936.229667-1-adi.sharma@zohomail.in>
References: <20260331142936.229667-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: 7uodpukpdex4kt9n3cx3mkig789tg9gx
X-Rspamd-Queue-Id: A20E920005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775409746-869304
X-HE-Meta: U2FsdGVkX182BKJDMn6lQIqTuaRXiRHcHh4gzt/Xyai0xQi4heUHISaxhFpdjXkDm0dOwm05vC8jjS/LhKLQEqNWTAahRcdtJPsa/8KX+6TLYxN/08EIpSrOQSq4qQuQ4b1TmbygqplptZ5fU46IpL4eVnjlHmDF8dlYUQz/mYZKybH8VQ0gaI9aPFHTwcLPXlDESn8X2F4FADN+7JJqLD1mFKwgy1tD1ySkPZoMAE1f96kbPBpgoNL0D3+IMp3oNu3vXEpuktyB2YF/glDnDjQewrWTEL39OvwOzNN2hgRvzK+zpAXiOet6zrb0HDH9awSjQfZgywEeOoKpijc00JyGaHq4PbGZH93+lzpxQVDryK/4ATJnvrJTDeNrNqVnt4JgxKAjmYyI6tpJ7Z8MQCTeTmg8S898r8AQ464wVyA9TqbeevBo3OMRNULRpuKgXGkaCvrvN+jfEG2YtAv4AsNhlhiIOp/MRF6L+jlKDvftskFyFTc7fZyV8czYIGbHiglnFyvAJAJkFdcjc9AhMuAjkPM47M4S82o00RUcavO+trBj28sq44hpTagVcVIAJLrzXjtmZaD8Nu6VSHitFdiXQneXi0wIgcQpkIhLjpUbSw7lfJT8uCIfgzwE/w9A3SxJoSi9+v0Ks9F/G2h4dDABM0zPa+e48R5qWzld1FgqmoDje3/hu0rjfyepK/cEjVn4VQapvjeoQ2rIErEOhVMv5jvZTYjBPTU3zfXZJD1YYQZFHyOeL6Zvt/i3KmZJjhQGGx8xc/dEje7/XCaX81vA2SMeQ4EcyX3/ssR2BsmD6prfp/ofvPFQEWA2LuaEW73kPcovU12pXO7T1BNfJ9iqducx5CnrDX4yrhXkaJr4uiJp3Q6T92ZTWQfs8AoyNTVXiHoJ5YF/bMnTKkKE0C82dGBHpIJWOVDoJja3cjiezEKLTmCcamJ/D5xHl8abma6c2asS6SXncjHAqxS
 eQ5yyL8+
 fIhRLIth3ATB9HxvwEzE40xnRBt7IFg5xB+Az16gL0HCZSKHAReUstK4Z+P831afqFnC/EXmE66V/9AzE2jmar44fObVJsXAGmJAD4rJHoEYScFXTr1j7HfJxEJzR/LkFHj4+Ee6vCb1zA4if6tb9sZEK707zavAal6vni7gu0zfZlCqBsPsUKsfXNXIsuF54E+lN/IGET9wNcQN2TtAtKj1cE5XxAzLgRnwfYkNGtQsR84F2Z7TkCNYg2skfifgZOa4kWxOLgTieERZrZcSAO0B6PQirsUFJ6R4B3365oKwMD4UO0DMgGb+BSA==
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
v2:
- Simplified the comment to concisely state "either the VMA lock or 
  the mmap_lock" instead of a verbose explanation (per David Hildenbrand).
- Expanded the scope to cover 8 other fault handlers in mm/memory.c 
  that suffered from the same stale mmap_lock comments.
- Fixed an additional historical inaccuracy in do_anonymous_page() 
  regarding the PTE mapping state on entry.
- Updated a stale reference in __do_fault() from __lock_page_retry() 
  to __folio_lock_or_retry().


 mm/memory.c | 49 ++++++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86..2b407e3f9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3742,8 +3742,8 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
  * Handle the case of a page which we actually need to copy to a new page,
  * either due to COW or unsharing.
  *
- * Called with mmap_lock locked and the old page referenced, but
- * without the ptl held.
+ * Called with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK
+ * tells you which) and the old page referenced, but without the ptl held.
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
+ * We enter with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK
+ * tells you which), and pte both mapped and locked. We return with 
+ * the same lock still held, but pte unmapped and unlocked.
  */
 static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	__releases(vmf->ptl)
@@ -4696,11 +4696,11 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 }
 
 /*
- * We enter with non-exclusive mmap_lock (to exclude vma changes,
- * but allow concurrent faults), and pte mapped but not yet locked.
+ * We enter with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK
+ * tells you which), and pte mapped but not yet locked.
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
+ * We enter with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK
+ * tells you which), and pte unmapped and unlocked. 
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
+ * We enter with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK
+ * tells you which).
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
+ * (FAULT_FLAG_VMA_LOCK tells you which).
  *
- * The mmap_lock may have been released depending on flags and our return value.
+ * The mmap_lock or VMA lock may have been released depending on flags 
+ * and our return value.
  * See filemap_fault() and __folio_lock_or_retry().
  */
 static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
@@ -6349,7 +6352,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 /*
  * On entry, we hold either the VMA lock or the mmap_lock
  * (FAULT_FLAG_VMA_LOCK tells you which).  If VM_FAULT_RETRY is set in
- * the result, the mmap_lock is not held on exit.  See filemap_fault()
+ * the result, the lock is not held on exit.  See filemap_fault()
  * and __folio_lock_or_retry().
  */
 static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
@@ -6583,7 +6586,7 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
  * By the time we get here, we already hold either the VMA lock or the
  * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
  *
- * The mmap_lock may have been released depending on flags and our
+ * The lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
  */
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
-- 
2.34.1


