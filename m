Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81765C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C466B0096; Mon, 27 Jul 2026 12:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8D86B0098; Mon, 27 Jul 2026 12:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5212C6B0099; Mon, 27 Jul 2026 12:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 290306B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:15:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FA20A010F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:15:11 +0000 (UTC)
X-FDA: 85035056022.23.81A1C03
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 04E2D1C0003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:15:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DYtjl+yY;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJKSSBhRPedkMVVywssYQjk4ahFV59GCfhRtzY5CUSA=;
	b=jggmZMTchdlYy0cDUfOpiY8Od0xYcfnXm5mtE3j6ua77Q7q/xcuQ4SjKxNDHqj3U0ixB6h
	tcaoVijyZwcN6Px/8O678Ws4a8x01OPlKvRq3TQwrUjE4yr0IXcITqzUU3gVzOiGuSA7rP
	QobZL0pxzpEk8/eSlRAwtqWGoFbHI1o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DYtjl+yY;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168910;
	b=aY7zpDW58zMo4xdrsNbNJyn7HmbnncVHN2FP8x+f6MGvv1MSv3JSaqoCswANTN/NTorQIh
	sWLIDazvKINhKQiHmSsvraNINXT1D19ukSRXEM4MAfe7TJ41+rKAkP67dC9KC8P8OtUc7Q
	zgwgA5FaRD04mhT3nNgjms5b4MQCa7U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785168908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJKSSBhRPedkMVVywssYQjk4ahFV59GCfhRtzY5CUSA=;
	b=DYtjl+yYCOopk1WeVqRls6ftKg78ir+NT/ZaZ/E32jseTGbwMsabLCkxstrGzmb/dUa2tD
	uCT87+SXCpcK7139YzfpXCyQmdWV1blGyVAxfX5Oo+y75yxUFjJwA73UBe7BY0t8FyK3gF
	SHg9/2l+X35r4v+DZL+PeuQOdNk3bOg=
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
Subject: [PATCH v3 2/2] mm: Extract non-swap entry handling to do_nonswap_softleaf()
Date: Tue, 28 Jul 2026 00:14:31 +0800
Message-ID: <20260727161431.13455-3-hongfu.li@linux.dev>
In-Reply-To: <20260727161431.13455-1-hongfu.li@linux.dev>
References: <20260727161431.13455-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 04E2D1C0003
X-Stat-Signature: fx6hyprxxaj7bwe398peza9p5n9aa8u9
X-HE-Tag: 1785168909-890823
X-HE-Meta: U2FsdGVkX1+iC2LscqtxFgrdnMU6/Rhe75wPi7nEW26S1icTxpYDakXpsKLEM4w3yCy9S4w+AYNhULBYHuN4HMaZSDLmhY8cQTPxEMCXXGBe1D0iUhhmNkvE7l0Zrmkw/hCZbC3KA/8R2r+ozVU3xCM3rfJIH9//uDOP8J+JCQaE5Xp0KkJg5eP9lZ2HuSlpRgs9sTijM+1wt0ikwSGgwavutrB11JJq2mnQcTS6w0pT+8J3VSSe8dEh0osd9S2eWUJNr+l2+J6c9FQaRyr08ae2nqGSnDQI3nXy8RSeAh3Ov1P8xVIO8C5rzMhl8tmUUr4Ff+W1yw6O1unVRO0Ht9aViq0dUOxBIXjojYU28uuBZhy8cWYafQdQ98ybAiW4HcOLB9APOJythcqPmInzS6bdmphsHg5yBIxRQluB6ttDbk1VE6wEpCATdvm8sPoT9bZZE1D7WoLn1558nFNMR2geAvnbT9bX+meqsTAweaVawnEAFSNyq/R7UH7+pj33BfVMLIe5p/ENU0VM8klRwFggQpC9GCglnJmLY8+jxsVEq2fnHvL6w12DcIj7bTy4Cnz0EZpVREuWfxGtfyx6WS0C/UDLeuoXGYaxbM6ayqg5tDBmC9TY3P6Kd9D1cfG+ttMLycrSTLGrt/a9mlo0vOMlAdnFk2tcvP1MQkMX8zOmwKYXYv0A/rGvYhygHirwIaZ2wboA0sfF1DUJPUP1tPmb+pDxXa6WHRm6Ckkv0qxyW/cUZsj+LAnZrEr7WiTc1hlfeiv0cJ1HmLLtxpvLIt3nkMW8sMbtkrZMuTP8xDawPkyWj4wsajx82ppwb2wc3XLZF3TGXtfIfw+NLsI9TzMbm6gV5S9Sc60o188BpVSmKHH3AqyiWpbwXTV61GrE1o7LApaX38+U/Ba6X442OrDLosdCVUaPjcrTLnqFt6xT8xgBJlY+O6jROuyEfDkfZpwwFHjL7SEmOJzHViu
 Z1hILNED
 4z8tBCe7wrDr3N530vi0hwaHCPARvcPOGnR9HlyaNjKo6GmzO+8ImzXqs5M4s9uY+UWa65JjsrL/aKvQXB79GnbCJ2h+l+jQHbwzjmj3ZPn05R2kRVqtAo1l/D8scHKiWrtNbb2ndqjaR/C8eKvaxsZtKE8CiRCLLP74fSkBCbvSLryf3e3e/K9GL3zJ0qv0lKwYF1Fayb/4Y8HVHKxA9OF4ZQ0l5fQY3j/QZvP9LFn8j70/sfVPRjRGx+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Factor non-swap entry logic out of bloated do_swap_page() to simplify
the main swap fault flow and improve readability.

The new do_nonswap_softleaf() handles migration, device private/exclusive,
hwpoison, marker and bad PTE entries.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memory.c | 119 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 68 insertions(+), 51 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index bbb289ba09d3..ff3da0aa3e11 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4817,6 +4817,73 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 	} while (--nr_pages);
 }
 
+static vm_fault_t do_nonswap_softleaf(struct vm_fault *vmf)
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
@@ -4847,57 +4914,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
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
+		ret = do_nonswap_softleaf(vmf);
 		goto out;
 	}
 
-- 
2.54.0


