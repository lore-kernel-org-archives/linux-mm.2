Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B33CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41CF6B0093; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9C46B0099; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780F96B0093; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6B16B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3726C1673
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:46 +0000 (UTC)
X-FDA: 84919477692.29.637AC27
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id DA3B620005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YaMGx9yB;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417045;
	b=TpHtu4E36PTFw0zlmu1u2tvth8kGEC8CDxLaflmw97X+kegJNIYmOPo6TZYk2jFqy1a4HV
	sS/zwIZzg2qd6d2JNZFe5un3sJcjdP9vyu0QQEh+MNs8bKH8tn6CgpjTQdu5vJ6N842Co7
	09dm++y8SMMmjtu+uL6gpsi7/xAfkr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2L2hQKeqlov9gdF6mrnS7Hxo22uCqfn3hih+qh45f4Y=;
	b=uF0/whUlvusG4W3V5z5YBE+aIoEmf4J7I/2gJQgS6XUIRX+GkFFfFDxyi5vZrHXjcej9jg
	/+03nWz3c3JYnAv107mIDbun3KDF672JdvxkormZSR2g50NA5r2nIzR3Ta6RoosQSYMwB2
	5OP9mgq5K3+c7u0Tc4iB+1B2C3te3qo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YaMGx9yB;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2L2hQKeqlov9gdF6mrnS7Hxo22uCqfn3hih+qh45f4Y=; b=YaMGx9yB7K2dFolNNjsqulgDn3
	wmOV0nw8ac8diVP17zxJzBMde0z5vv5Nk8jrBH7SAVRIsNP/deKgw3rLXO2szXo0bvSk9P5fFAnUG
	SKXGHDOqOWPsYPupPN1sqJrbVsCNJT1zTG0yAR5DbySyd98rNqO8s/yygBasfJk5Nnf7nr7ysGRmi
	D6liwymBRm6NqAmfiNbZPsRC16f0LmlSRHC94mFFiSbGDCrvVk4xiylYvkcXrtz0kR3dLrG4s/wx0
	BLSarnSMoCDJeD/YKYCdJwjGg8tQ/xAq5whQ9tVL6hkfdHBRfwwuChtvZCfKb4w+5kXctLcpe9T1L
	WHLwA4yg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq5z-0000000AWY2-1qQ6;
	Thu, 25 Jun 2026 19:50:43 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 03/11] filemap: Do sync readahead under the fault lock
Date: Thu, 25 Jun 2026 20:50:29 +0100
Message-ID: <20260625195040.2508362-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DA3B620005
X-Rspam-User: 
X-Stat-Signature: eaxmaiwda85smaaffytx3kdtybq1u8rp
X-HE-Tag: 1782417044-667742
X-HE-Meta: U2FsdGVkX19khfigiq5OKgGc9bAjoMl/+FyftRJx6z935pPhNeKQxky856LQYuqw3PoJyqx97qebMq6i2hZQRgISMUYgZ0W4kC2rt77HGA+goBII0GNIh4+BkNlzCP5OiGhgU027b0KtHK4mg3sTXQb77tenr8DCzKXq/2BOdR5oulILV7Wcw+LXDAuLcat6ETbh4ve9M79yORQLtOOWqrpyFKnOwHsH3mUe0Hp8QcKxL0qj6qW3KrDHcpZ1KxzebjTmmgR4oY7voLlVFj4fEuXFDVu5ErEEW18YFIh7grn+VU9XP14h5C6nMq4TU+ud4oTUc8ARH391xZMgwAO6xsU7hnnUHCGZjrRRn3k6D10L2bUUJ53O1xYFij69Tsr02uIggIWrnlloXOMoc5EKXE/GwgEkyArCy2KoX42mSXm7HT7JEHNJDX6MrI1pknB2Em5Yh4WwcoraFP5kHqgDWgdATA71a2MsQb3zWOK72Q+zjGXnbjiQkLG4Z/IP/CxZmbjeqKgdZ6uAEjY2VC8qET4j5VRQNiDtlRMrbm2ZNxTxv8u56IY8VIOJlnQTxykzyNFLCJhgAv+8dvLz9lTQWInL8O3o8+OVhGKPx0V8avGxbNQQIx6zq6Tqou2g+lDy1eTSYQbLvSiWpJcEAQfJJIu5mqiqPD2iSnjaDS485IPfS6J3OrtoL4Al4AedTTu+3S9SgkHa6F9f44DBSj4HZ/hUsk3rKqjKCdiYdJX1JSgfAsakQ7OSmMJlUTXuU14apWVxudPi5w5v2RWyQ7kseIyS45dZ+MvxqfYToXKVdfL3ePuCvmmuyvfler5W1bQ0ZCm79G1RGOTTIqix6y+jjhdVEqKc5vtbyylqzjOKOM20+eBHqpzRKKyOJNQoB9IR5AoN208tzMjR9NhNlAwXaGgrj0WMPiAnWPDUL81lSHYsyUaVS1iMvkRqY8KWk9zyV1hGfBDkT5bsgPOi+7V
 qFyn1ghH
 W77YAZQTovCVPezNvsmntbQl+sn0OmjC+/B/uemcIVqW7I4jtvnLVwivGqfOcM/Bx8SwsM7iuAZw0N+DdK16X//IibTWLKOgkSDQjfwTAinGAu1iLr9dxOOcgksvKr/LXYMNR0oSeumpUbCKX73k8lynIfCjMWj+jD8fvP5JZe/898JTrvHiPP/s+KyHDWyjJS/bYAldq5kSpJvalLfFi/Cne19t2WmaVLfWmIgZ86pzeBPWYF5UY392Czb1xlyWcZElEy7cC2/rQUAivEZwZH64fTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of pinning the file, dropping the fault lock and retrying
the page fault, just submit the read while holding the fault lock.
The priority inversion originally addressed by commit 6b4c9f446981
is addressed by per-VMA locks, so we no longer need this complexity
in the filemap path.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b7ecd03d4fc9..ce115411404f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3302,13 +3302,12 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
  * that.  If we didn't pin a file then we return NULL.  The file that is
  * returned needs to be fput()'ed when we're done with it.
  */
-static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
+static void do_sync_mmap_readahead(struct vm_fault *vmf)
 {
 	struct file *file = vmf->vma->vm_file;
 	struct file_ra_state *ra = &file->f_ra;
 	struct address_space *mapping = file->f_mapping;
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
-	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
 	bool force_thp_readahead = false;
 	unsigned int thp_order = 0;
@@ -3336,15 +3335,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * VM_EXEC case below is already intended for random access.
 		 */
 		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
-			return fpin;
+			return;
 
 		if (!ra->ra_pages)
-			return fpin;
+			return;
 
 		if (vm_flags & VM_SEQ_READ) {
-			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 			page_cache_sync_ra(&ractl, ra->ra_pages);
-			return fpin;
+			return;
 		}
 	}
 
@@ -3359,13 +3357,12 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * stop bothering with read-ahead. It will only hurt.
 		 */
 		if (mmap_miss > MMAP_LOTSAMISS)
-			return fpin;
+			return;
 	}
 
 	if (force_thp_readahead) {
 		unsigned long folio_nr_pages = 1UL << thp_order;
 
-		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~(folio_nr_pages - 1);
 		ra->size = folio_nr_pages;
 		/*
@@ -3377,7 +3374,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		ra->async_size = folio_nr_pages;
 		ra->order = thp_order;
 		page_cache_ra_order(&ractl, ra);
-		return fpin;
+		return;
 	}
 
 	if (vm_flags & VM_EXEC) {
@@ -3414,10 +3411,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		ra->order = 0;
 	}
 
-	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	ractl._index = ra->start;
 	page_cache_ra_order(&ractl, ra);
-	return fpin;
 }
 
 /*
@@ -3570,7 +3565,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
-		fpin = do_sync_mmap_readahead(vmf);
+		do_sync_mmap_readahead(vmf);
 retry_find:
 		/*
 		 * See comment in filemap_create_folio() why we need
-- 
2.47.3


