Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A281BCDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992186B00A5; Thu, 25 Jun 2026 16:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4186B00A7; Thu, 25 Jun 2026 16:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4006B00A8; Thu, 25 Jun 2026 16:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 541496B00A5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:14:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C847E8CE72
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:16 +0000 (UTC)
X-FDA: 84919536912.20.32512DA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49142C000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d9owe1jK;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418455;
	b=CXieRy4dTc8xn/8Eb4EFTwW+H0I3uL8W/O6/lPFKJx7052yGMk5McFMOXeEAAxPq0ZB3WP
	b/XY2y3C8/mHaxHcJsWmv9PWVZZspofsNl9lIV3AumMB9MJg7s+wq69EeZ22Gl+O0JYdTt
	bzspqdxaMLOswRxG9mM2Yq9fo3p5HSY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpLunw3505z44O0RkeDkiOGZNGO9r4mN4zq7pVOMb8Y=;
	b=rjv7Q71dbdLqzfbqaUDzCPEjTgj7mLiU2C0AtRe4VCVUtciCp4GWGMoiiPCgWQ72fKnLGk
	1AJ9ByQmcw0zl6dQiJyva+bMPiZQOs6yZP1g3Rtv9eASHyZIduGlORAGDYmVRWooVVGa7d
	J0OPnMWWnujkZ/JyJYqhkrqEj6oLHwQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d9owe1jK;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=wpLunw3505z44O0RkeDkiOGZNGO9r4mN4zq7pVOMb8Y=; b=d9owe1jKRYQtd5+XoIbQecr266
	GRwN6USe7214wSw/8+Rd4vnIXfCVJkAuiEVpKoeeCQRrV977zmjRrJZC7viH1lVAKdZc/eRWO2eEX
	zfxWulX6IINgN10a6GF30AbFudtHrnH17W6n414AqLj/U06aV8GcQtnaJ2kg1rwCIjLoo59cwbMHi
	2tC19BGHdqK47RSTpRK8aZjXEGs2ivLG/IhHhy2fxOBB8YAlcyTHpM+EqzScRIVTRs0uZF629I+/u
	a0GV6HJ9GuAEre24SIXLJLBJNe65H6DlJ3t7GtgBR5ST/MeWaLBF+EgZPWjB06RK1flkBI9aNWfJl
	DiVc+6oQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq61-0000000AWZ6-3br9;
	Thu, 25 Jun 2026 19:50:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 10/11] mm: Do not release fault lock while handling write fault
Date: Thu, 25 Jun 2026 20:50:36 +0100
Message-ID: <20260625195040.2508362-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w7s73ne6obckurwd5z75fgqiutzd7jd3
X-Rspamd-Queue-Id: 49142C000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782418455-918668
X-HE-Meta: U2FsdGVkX191AU/Z4mwEfwwU0GClliGuArWo9xujYOHI+moCj6yRPJ7djRosmlDd2oQjyOl7GWCYTsdjeyCYr5rMrnRteHf26RgbWcKNsbVQh2qvcEjpULMQMdyrLhEOUyusv+plYj3A4PdBtxi/OwXjoc+9PPcYDdsI280/Jh2jCf98OZMQyI8AioX2V8frgXPdipwpkDaQlskhiGgurscqAppdURfyHXXCGwlAkBx5a28kb4/R164FRc9e3V0+Ouv37zKzfVOnMB1PKFlbZHkky0sEzNwXrdUP1rQnVzg7Z8M7yq94U0cIVXevLFxhtTT4ZiLXrqyxqf/umaCDDEN47svEPjdOp+mRTieQ18+AwtKTZF3W8iFvuWeTqToC93vtHNCgoASK0i8M32WpqyOnTjxxLX5+iwBnU3Of39ExkX5NpYbf+A/ETTHB54fzKW3c9+iBrlhAaw46W9GkQAKSArLBXSZZsXchiQPkB2fK6Mjj2P6PztXBjcUTJ8J6uwNRvoyl4b5vTn82KZjbXYjOP7Q1HxSvo25oFlV4WeaH/OgVr6Wv6dSzAqExhtYkirui71wCyG3Ff+un4LGRflP4IxEO6U4sXvmntNrTvOFzB3eSRpQVkz7fmVlYf3jrfvyeClI1FBr0Tt1heZUdQ2kUn20qokhi1gFlgvwBI1N8DlvF2crz7+rRONk/CmdIa5g7/DwxXswpBCCLeQfbnIRi8AhN8W1ubFO0TZdIuBvOpGxDhCIBt/vnARk0oveQhhQlBP5yN1MhbYnZZhrCSVFWSBLUTetuIz0giiAVSba1+DaaLLUrn4aeGt23dEeRhktjoUT77HjuRMR0XTh4OHjNQzYEXCDJlz+kWVIpjSNqmMHFjqWLY1Q9LN9wxHviDzlmv/bvynXC+Q1d2GP64ggGyvIxmkoZJMNcz1H9A9qmfTLap7fvclGjpKnn7zQI4bKazWlFbd4xlfm2nM6
 C1OKpIjT
 jJHAnnBvwcdp4twBPLGQfdv7f1igsy8n6zlvN0oOFeUArhm0f8/tEP+j/SCsxZ7J5v6SlgVXQvetiO12TZvGKA5ILynt2y6nLxNQfLqJlZJ7a5LitH3UqnpitiJ7br09CcpABDmeBH2HRA/GnqmMuTZFCvzJ7Gui2nLvExO5BHwSldWDbZw9dH+QLrJsT9MWxc5pFuT1q+OWOajdnwnHAwLNyccZpDM2JT7Gtmv1U2mnih5xfXO65/to0GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for removing maybe_unlock_mmap_for_io(), undo the effects
of commit 89b15332af7c.  The problem mentioned in that commit (holding
the mmap_lock in read mode while a second task attempts to modify a
different VMA and causing subsequent tasks to block on the mmap_lock)
no longer happens thanks to using VMA locks to handle faults.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memory.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0124a87c3e81..316c0fcc865b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3701,9 +3701,9 @@ static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
 /*
  * Handle dirtying of a page in shared file mapping on a write fault.
  *
- * The function expects the page to be locked and unlocks it.
+ * The function expects the folio to be locked and unlocks it.
  */
-static vm_fault_t fault_dirty_shared_page(struct vm_fault *vmf)
+static void fault_dirty_shared_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping;
@@ -3729,23 +3729,10 @@ static vm_fault_t fault_dirty_shared_page(struct vm_fault *vmf)
 	 * Throttle page dirtying rate down to writeback speed.
 	 *
 	 * mapping may be NULL here because some device drivers do not
-	 * set page.mapping but still dirty their pages
-	 *
-	 * Drop the mmap_lock before waiting on IO, if we can. The file
-	 * is pinning the mapping, as per above.
+	 * set folio->mapping but still dirty their pages
 	 */
-	if ((dirtied || page_mkwrite) && mapping) {
-		struct file *fpin;
-
-		fpin = maybe_unlock_mmap_for_io(vmf);
+	if ((dirtied || page_mkwrite) && mapping)
 		balance_dirty_pages_ratelimited(mapping);
-		if (fpin) {
-			fput(fpin);
-			return VM_FAULT_COMPLETED;
-		}
-	}
-
-	return 0;
 }
 
 /*
@@ -4098,7 +4085,7 @@ static vm_fault_t wp_page_shared(struct vm_fault *vmf, struct folio *folio)
 		wp_page_reuse(vmf, folio);
 		folio_lock(folio);
 	}
-	ret |= fault_dirty_shared_page(vmf);
+	fault_dirty_shared_page(vmf);
 	folio_put(folio);
 
 	return ret;
@@ -5949,7 +5936,7 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
 		return ret;
 	}
 
-	ret |= fault_dirty_shared_page(vmf);
+	fault_dirty_shared_page(vmf);
 	return ret;
 }
 
-- 
2.47.3


