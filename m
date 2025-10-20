Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDFACCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453F48E0002; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E42A8E0008; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E82B8E0005; Sun, 19 Oct 2025 20:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFCDA8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C2E613B8E8
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:02 +0000 (UTC)
X-FDA: 84016577484.10.39E67DE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 567041C0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l8xa878S
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760919420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsC4AVFnnb6VOsYWXU5qORHanYLvWN30fSNbU8QS7Rw=;
	b=sWN2xP7ijYl1C/vHyweh4bjItLBRiZ0bp1krv9DIifReKJodc/y1vVJhafMi6zDK9GDbt4
	jwlyk4Ot+j8YOlToyDP46rQ02eU/4klTM9hpLNZlGaMLuECXnE4uUUos2GO2wbua8YpTDC
	rEsiwfqzSXY0nWiyP/DQHk9dL+Y+vVk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l8xa878S;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760919420; a=rsa-sha256;
	cv=none;
	b=aMhzMwHbc4CTg2uvx4WtZOlQORHc0IUGHnXI0WLtbMC+/fpjWcWI/FM7+my8Gh377ow3fD
	zXvkpGnNZ6tQ/fllR+BoBeIEB3MB/8+glGtlUis76cPK0nA+w+bmj3Xb/WYo2sSlGcElbC
	eKYaXVrGzb5JZUOUPdS9ojW3AK+YZbY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HsC4AVFnnb6VOsYWXU5qORHanYLvWN30fSNbU8QS7Rw=; b=l8xa878SbbUf9srg3QGFs4H+E/
	FghfMoB90iWI7v6u2Q9XNLJ2OPisEaCnFTN9OULZ15ry7KlHzZ5LE7ovgPVToNDQKp+f7EKg06bj0
	uJ9c/e+FcemwkkkE+5jUK9P8e6R/AyvY4VsXWGETmnzWl/3G1BovgrjTm2ArN/mSoF29LhqdVmSoA
	+yTKnt4QOSol0NKSGNv8Adjieth9SiMSa+4m3igvhIo6qQImPHVy5+4Xf47J2KhuqgtpX8LlkAzfE
	tSHPajshBfwHareR1+ztHekbydXYDn+YdQ4Xy6Sh0fANPa9SImrt8il1QiVvTi29gEzFqfPsnf0C4
	Ue6+qq5w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda4-00000008t6W-41BJ;
	Mon, 20 Oct 2025 00:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 1/7] mm: Use frozen pages for page tables
Date: Mon, 20 Oct 2025 01:16:36 +0100
Message-ID: <20251020001652.2116669-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 567041C0007
X-Stat-Signature: qkzicggtm84o16is7m3jcsj4dbqs94ex
X-Rspam-User: 
X-HE-Tag: 1760919420-13349
X-HE-Meta: U2FsdGVkX18G14AcXGmo+fqOtuNalIa2LoKLbc2+fUkGr66ff/Dyzw1vnjkRAN7BkQdlwKq8Vmhj6627kp3biWX/BQ9ZvfFC8dN7UXlqk3Nnocj5zRpfT0zb1NCGFmQiVKcloJ83kGHAvoWOCNq05Lyyt2nlplNWeqziuTf5WM+PjnObPqNyCbfLzrfSoit62IE4gc1AYb1r3hTFlX3IpMXZgH0xb/lIhU3p0S4veDcF7k4Z21JHBe039z5u70aVnC2yHIUZTzubMFKqUaLOOzv6Buqbq6IfreQEVvJc8mWlCCn594C7BSO1McgyyFXpef9Jq/ru1G+fnTzOiJp0p6MZFRFFeCLKKcdrVdKTElIAqnUuqaVpas5NtInT89tiM/tMKLi3SoYhJ677O0iURaEUQoBc3/bjZQGwRcMohjzAww+Omso8E8JImROhqs81O9gmAqoH6dM9UB9A9pOBHhK/M4EDIKteYaQpxXfpu5NECuWjkNh9rNBZqTrM7ioGu0fknlaZX+5TXAreuja9KizEqNxT/4cWlJd5xIUoZ1EEwR5O0rmbsZPl9SdD7L4FuhA+IIRILdrKJrLRlk3o1eXCUaOglEVTSQyPUQgIRgQsEwtE4QK/UzByoqDJFr9Dc6OzNAoPKAV4rML/Dr1s0C2hnKrKBByHVJm24zQmm6ik9ZAUw2DetDrEDVz7iTC5HzHK4Qkt8QfFChcOEGFTYbuJ3tVAhgWvziXRLD2wb4/Qfx5y2yLhyXTDN/RfQXZtj5AxczFN4shfMJae8o3Pd8NAPzCMWHo0RK93koIeIAaV/pHiXLemabhpYi3z+hjhQSjBdMLDksIP9anOZJ1slFOsJgeO2zu6WjuDer8SfbHeG4DVpiQ5j/PHiVlPqJO4hf9GYDuOKF4Fwzc+vNoJUBc0W/kpZapVAiGcbq8H8Wus5GtXSHxYpvjgGvZF5tKOyXEBzj0kyf0v+WCqNna
 jIToXuYl
 QVkOgz5xLetN+N4Zm4dUTi8cn267b4GaJoraJic00o/hBRF3eDcgDycnyaCum7a0B2pH1jEVoRX04rK8rPV9KDLKumK1Z7xHD3fcRc32U58rwkFIaB6P4ThwqSpHQ5CYIVtjma/wzfpblcTukNUhuyCkfSs/m5YUKJ5Qy1MwU+hBHHZ4msZwrJkENzm8TEnzchpq13RXrCBoF0kp2sjUJYDtfwkV+f1MD00ssWfQtah7HaO1jiO93ByFuvOx8QphmDN+4NKWL3KLdcCXmlXXIMNYK45eC+YiPI4jujuQwB9MHP5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Page tables do not use the reference count.  That means we can avoid
two atomic operations (one on alloc, one on free) by allocating frozen
pages here.  This does not interfere with compaction as page tables are
non-movable allocations.

pagetable_alloc() and pagetable_free() need to move out of line to make
this work as alloc_frozen_page() and free_frozen_page() are not exported
outside the mm for now.  We'll want them out of line anyway soon.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm.h | 32 ++------------------------------
 mm/memory.c        | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..ec9365375d9c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2965,37 +2965,9 @@ static inline bool pagetable_is_reserved(struct ptdesc *pt)
 	return test_bit(PT_reserved, &pt->pt_flags.f);
 }
 
-/**
- * pagetable_alloc - Allocate pagetables
- * @gfp:    GFP flags
- * @order:  desired pagetable order
- *
- * pagetable_alloc allocates memory for page tables as well as a page table
- * descriptor to describe that memory.
- *
- * Return: The ptdesc describing the allocated page tables.
- */
-static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
-{
-	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
-
-	return page_ptdesc(page);
-}
+struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order);
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
-
-/**
- * pagetable_free - Free pagetables
- * @pt:	The page table descriptor
- *
- * pagetable_free frees the memory of all page tables described by a page
- * table descriptor and the memory for the descriptor itself.
- */
-static inline void pagetable_free(struct ptdesc *pt)
-{
-	struct page *page = ptdesc_page(pt);
-
-	__free_pages(page, compound_order(page));
-}
+void pagetable_free(struct ptdesc *pt);
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
 #if ALLOC_SPLIT_PTLOCKS
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..de9f999ffcf6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7267,6 +7267,37 @@ long copy_folio_from_user(struct folio *dst_folio,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+/**
+ * pagetable_alloc - Allocate pagetables
+ * @gfp:    GFP flags
+ * @order:  desired pagetable order
+ *
+ * pagetable_alloc allocates memory for page tables as well as a page table
+ * descriptor to describe that memory.
+ *
+ * Return: The ptdesc describing the allocated page tables.
+ */
+struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
+{
+	struct page *page = alloc_frozen_pages_noprof(gfp | __GFP_COMP, order);
+
+	return page_ptdesc(page);
+}
+
+/**
+ * pagetable_free - Free pagetables
+ * @pt:	The page table descriptor
+ *
+ * pagetable_free frees the memory of all page tables described by a page
+ * table descriptor and the memory for the descriptor itself.
+ */
+void pagetable_free(struct ptdesc *pt)
+{
+	struct page *page = ptdesc_page(pt);
+
+	free_frozen_pages(page, compound_order(page));
+}
+
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
-- 
2.47.2


