Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D0E5C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FAC46B00C2; Wed, 22 Jul 2026 23:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2786B00C3; Wed, 22 Jul 2026 23:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7696B00C4; Wed, 22 Jul 2026 23:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB9E16B00C2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:08:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 561D3160378
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:08:39 +0000 (UTC)
X-FDA: 85018558758.23.0D32E4E
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A614920006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:08:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IAemcC5L;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784776117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPn+6PAbSUYy39pblfECZc7kLKlZRJn3Dc36PYNt1tA=;
	b=Rxl1IfDPACX/8UCFRixBMyDywqeCOVJqhBF3fkpUgPWaMlDAfcHxlS9L4pZslkC8eZSdpz
	QxKLk/mmQiUpsS0FqNPTzIdRplvajcaGfy4K1uqSjBqOt6y4L7zlk0akWTVwH4sKDtKZKK
	4/Im8MEamT6z/kfxaswr9Rv50sAtJ/o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784776117;
	b=e9z3E23yblAeuLWLB9OFYaNUuEC5G+7YW6XfyjEKYpDeKW795p0UsIUWYRsKmZV8275eZS
	BhDb3RZbYTA5xxB6qmCIfsMUtU8exgb2VmIbJsDZd8qHKlxHZ5kaPt5xTdm3xl01kuXWbT
	996ZQ5psMrKu6wiajwyiMF7+hTWV7vQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IAemcC5L;
	spf=pass (imf13.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784776116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CPn+6PAbSUYy39pblfECZc7kLKlZRJn3Dc36PYNt1tA=;
	b=IAemcC5LbRot2vZtr/G6azzKBwifUlE6e8OYKzasZZhv9sJZRcLA6xQtRGjTr8jvr6s1L3
	W2XsYO+04T/tSF73omVbfY9ZtQxhu68Qmlm9yNVtvPzo4lHySl1zavuR42tnwurdFQnXXx
	CtuWJOEOLGKgtA0obNbrRKlJoySFFdo=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2 2/2] mm: Extract non-swap page handling to do_non_swap_page()
Date: Thu, 23 Jul 2026 11:07:52 +0800
Message-ID: <20260723030752.16979-3-hongfu.li@linux.dev>
In-Reply-To: <20260723030752.16979-1-hongfu.li@linux.dev>
References: <20260723030752.16979-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A614920006
X-Stat-Signature: dtya37kyfp96zmhi3ot6hboa1hj4a6gh
X-Rspam-User: 
X-HE-Tag: 1784776117-119997
X-HE-Meta: U2FsdGVkX18l4o1yVN1fV5jregjvTOyTmOqJQAy8coeJMav4Be9YAKbQ8oL+d0zdj49N+ewDXcR/19l5b3L6GEeez9K6q72d75/R7aL50Jqh2S5aubML/SpqaD8RuQTp6csx4/0k1F2h3DdC11PkgyIPhGXkJahGVSJ/PRvI45rkGtV/fjEpYRlaASwRdoy1//MJYfo8rVDpHf50CONXx8kJfhYqXHrutd3N3KWRlgr+6rhDTqzF4p/wecykCT1gFs5O5cvdztMCP+kC2JG1Oyf9libmRQnLsKrM6kf5D29csPUIyLQKsvLJDLvvRmkqVGKHnsJnH76rR+KpdpCS73TU/U6c8DjEWNYpPyrVBhHlkrgoQ5fexS2fAaP6PqeGNIKlcAf3G37yZjhyhRjQ7sbVg2kyTBsuE/KAt6qP8u4F5EH0NqbS3kPQ6Dk0HYHqsPuj4JaqNs3O42Q+kwOwZJaEqY6y5hBBhgzWXac1u6yvOymdpcoDUOyM4JzKsScfkK732rYg0jAqhUij6c2VsJTP6zQJSgoE+rYVB74TAij8ACAgtAAjOVrq/jdksg8qfdBB/GbgTYiCr8/nawwqnqnyl3lxQaAZVuDcpGu6vmQ1XsRKpBbtYjJwU2LQyrrp70oPTXKjDMjLZIOd6xpIjoIIPrUZJlUTgJS1pjQAZtT3lCorbrGc18YOJWU4QbHZyecSGZ4ohmuNiVSw4vlU/Q+upF0aF0qSE52KULqu6iUwGTndHxcvJ/EpuIJO0V/ZHXcN6lBPZLslgEOZVvHdNu0MVLckpORXm5pI01wOMf+yGdv7k8pxQiKNgXfNfVKnoT5TWg4v7nlWYaDF6Anp0Rblrw5iLWLfjYPIXTZazEUSZVbJrqWk1oGTM3AQvUKuWfxif+c9Emeqyo4GrxdKXW8WGIxpElxs444ihe+TQkaxpkkcslUmLyqPJSjPwSnUuCH3c/rjCLHDsA0NBwx
 4XZeLZei
 Rxez+e2kpC/C66gKZlYR2vQWOhLvLT55JlcyenRxbuYd23SOGgxPKqrZyqrU7Z1ZDwiaECVERCpAhdD5k0LU8PZBElu5xjkrFHnyPdmScjLqAl1ZYObOUxz7RkbzmP+h+ZPZ2nAknD4Zrmi2nKlZASTqNQXabY4CyrLm2/gJCIKal9S2Bu2SagG+iyLCqN1zs9VjpKzRngcY4WzlL8M+zx9VForO/ZiwgYZWuEIURBaqElbJQdOkLDzbfuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Factor non-swap entry logic out of bloated do_swap_page() to simplify
the main swap fault flow and improve readability.

The new do_non_swap_page() handles migration, device private/exclusive,
hwpoison, marker and bad PTE entries.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memory.c | 120 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 51 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ae521baa8c84..50d8e92aef91 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4815,6 +4815,74 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 	} while (--nr_pages);
 }
 
+static vm_fault_t do_non_swap_page(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
+	softleaf_t entry;
+	vm_fault_t ret = 0;
+
+	entry = softleaf_from_pte(vmf->orig_pte);
+	if (softleaf_is_migration(entry)) {
+		migration_entry_wait(vma->vm_mm, vmf->pmd,
+				     vmf->address);
+	} else if (softleaf_is_device_exclusive(entry)) {
+		vmf->page = softleaf_to_page(entry);
+		ret = remove_device_exclusive_entry(vmf);
+	} else if (softleaf_is_device_private(entry)) {
+
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			/*
+			 * migrate_to_ram is not yet ready to operate
+			 * under VMA lock.
+			 */
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
+
+		vmf->page = softleaf_to_page(entry);
+		vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+						vmf->address, &vmf->ptl);
+		if (unlikely(!vmf->pte ||
+			     !pte_same(ptep_get(vmf->pte),
+					vmf->orig_pte)))
+			goto unlock;
+
+		/*
+		 * Get a folio reference while we know the folio can't be
+		 * freed.
+		 */
+		folio = page_folio(vmf->page);
+		if (folio_trylock(folio)) {
+			struct dev_pagemap *pgmap;
+
+			folio_get(folio);
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			pgmap = page_pgmap(vmf->page);
+			ret = pgmap->ops->migrate_to_ram(vmf);
+			folio_unlock(folio);
+			folio_put(folio);
+		} else {
+			pte_unmap(vmf->pte);
+			softleaf_entry_wait_on_locked(entry, vmf->ptl);
+		}
+	} else if (softleaf_is_hwpoison(entry)) {
+		ret = VM_FAULT_HWPOISON;
+	} else if (softleaf_is_marker(entry)) {
+		ret = handle_pte_marker(vmf);
+	} else {
+		print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
+		ret = VM_FAULT_SIGBUS;
+	}
+
+	return ret;
+
+unlock:
+	if (vmf->pte)
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return ret;
+}
+
 /*
  * We enter with either the VMA lock or the mmap_lock held (see
  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
@@ -4845,57 +4913,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	entry = softleaf_from_pte(vmf->orig_pte);
 	if (unlikely(!softleaf_is_swap(entry))) {
-		if (softleaf_is_migration(entry)) {
-			migration_entry_wait(vma->vm_mm, vmf->pmd,
-					     vmf->address);
-		} else if (softleaf_is_device_exclusive(entry)) {
-			vmf->page = softleaf_to_page(entry);
-			ret = remove_device_exclusive_entry(vmf);
-		} else if (softleaf_is_device_private(entry)) {
-			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-				/*
-				 * migrate_to_ram is not yet ready to operate
-				 * under VMA lock.
-				 */
-				vma_end_read(vma);
-				ret = VM_FAULT_RETRY;
-				goto out;
-			}
-
-			vmf->page = softleaf_to_page(entry);
-			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-					vmf->address, &vmf->ptl);
-			if (unlikely(!vmf->pte ||
-				     !pte_same(ptep_get(vmf->pte),
-							vmf->orig_pte)))
-				goto unlock;
-
-			/*
-			 * Get a folio reference while we know the folio can't be
-			 * freed.
-			 */
-			folio = page_folio(vmf->page);
-			if (folio_trylock(folio)) {
-				struct dev_pagemap *pgmap;
-
-				folio_get(folio);
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
-				pgmap = page_pgmap(vmf->page);
-				ret = pgmap->ops->migrate_to_ram(vmf);
-				folio_unlock(folio);
-				folio_put(folio);
-			} else {
-				pte_unmap(vmf->pte);
-				softleaf_entry_wait_on_locked(entry, vmf->ptl);
-			}
-		} else if (softleaf_is_hwpoison(entry)) {
-			ret = VM_FAULT_HWPOISON;
-		} else if (softleaf_is_marker(entry)) {
-			ret = handle_pte_marker(vmf);
-		} else {
-			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
-			ret = VM_FAULT_SIGBUS;
-		}
+		ret = do_non_swap_page(vmf);
 		goto out;
 	}
 
-- 
2.54.0


