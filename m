Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B9FCE8D6F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9CD8E0026; Fri, 14 Nov 2025 14:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC9A8E0023; Fri, 14 Nov 2025 14:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC5E8E0026; Fri, 14 Nov 2025 14:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5403E8E0023
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 218AF1404D7
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:23 +0000 (UTC)
X-FDA: 84110128326.23.31A0F25
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41D5210001D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="aIwkw4U/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146821; a=rsa-sha256;
	cv=none;
	b=w5fmURmyPhaNIZwP7XF4a5CJ516TlwRgtvUNN+pyCyhrZQG2QVvc3Sb1QT0ueCzZFgW07L
	isvMETtDJTJj2pivkyoAtZlIK9CmUX2qXKv6KJJq+QI/GfYJNhRbV1Qs2IEi5rOcWPOP9G
	5cM7EwpIkfqEsy2AzSldJtbD9EmthNo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="aIwkw4U/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffjFNwR3lXfHPjG3OmQVmnhwINj2hMoShbrtcOYEMn4=;
	b=Khx1tyMEkcLbIfWIgJ+XagWAeCBZWSJ99nzWDvV94anB626FdkEbTiQ1kGFHgxxlzT+vOd
	yNgp5hrmqoPY2my0BRZ5HwfVvaA8KYMlwGUAi+ydBir94B+IMV7hWsTUt1d9xRFO6vHiXw
	bW2flbguDxrQY5bsA6FhuFmN+WjNiLY=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-640c9c85255so2494968d50.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146820; x=1763751620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffjFNwR3lXfHPjG3OmQVmnhwINj2hMoShbrtcOYEMn4=;
        b=aIwkw4U/dXhXVH46xVld5X2PkVXKhoXfF4H0R6b1t0NFEZwIdn3nsCCXtlRilaX2Os
         Q6p4cC5z68+EQiu52s4zpyIAIJoBE1TZdQ4/mXLj42bTXF/KF071iJShotWJc9rqQkMC
         hPFWYNELmxFTeqoaVcZe2iNmABP3TT9UPeia4QQns/W8IIVBvTmYuef1DxKPWD8ta1dt
         LD+E50JqjYPO063skbXBE/rGtz5nwxLW39D/+0XFO61min+XDJn47nUjKGImX95n2Td7
         OGN9Kym+280gH1a3URpNJh/lOWehMURT50+mq69eljgUYgSAFJTjkw14jKM8xRYBVz47
         Xy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146820; x=1763751620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ffjFNwR3lXfHPjG3OmQVmnhwINj2hMoShbrtcOYEMn4=;
        b=a39xkwxNu2uxL/SbWZV8a9KkQULcJr2yorDTuiGp0JtSZw6Yd7JjcoW+FpMFW10j1k
         jte2CJnzTw9dsJ/cCKnQeD1tn9+0SzRsVxmIVcfGy+oi6hOczWzmNzgsoJIiidzC4DTH
         A83oC5gNgmgsCuqZ1VxDl/XPWe1t4+EfIwH36LFXfLVIiGikHk+olJT+xhAiQvjxDFrx
         W2uX7XzOxFPS/3SFCLYoX3aw1fEDFYY5N/D2yFzDQXZXCCTy1W26kZWukSqhrT9cdCwG
         j2e2wohTcY3GP828xDdm+kceIVQh0DY9hpjSFDaWg5q8Dcf0qiFOFpCWA+AXu8EXu8La
         oLLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzTh7d32T+duzwcL9wPtNY78XtoKFnJlY3DtgwuYYI5fnNmysDVvV7JwwStNU8rQkF9rSTHXxwTg==@kvack.org
X-Gm-Message-State: AOJu0Yy8g9/zDmnz8xhmNikkjwRAVrlm4Z/bC8TwM62Wk0P2+xruCCKb
	q4F8DUmzBEd8UyctdQhDj1yhD5JjVN0oT4KTDz3XRSr6aAFzOcPuaZA+i4blbETtrAk=
X-Gm-Gg: ASbGncuZb0ek7bE+vztl+KU4dfVPMXWrW6ctG8gf8jC70eY7OR0NsDHTnPoXgwPr2Lb
	PqbiQyJo4fQYZRPHiIf5zC3Y3bxXn2ad9mEqyyxd6rcOMcDgkevj1ge/tM9zc5YBxRjKvZZ0XaX
	mb6rI9t+fR+rypFrZpRQpM4N8iDZX6KhJRyCd67cHdS3mlSTVjr0FwMZciwbqhK9Q9Yz7wBVOLh
	hhS32vzWzNUxQ+fyrwcRXCiM8KZ//duHgQQnHv2QPyXRGMLxm7V55Gzg3HhpApudlNU4mfTMFJF
	/6O3OvNy1IMNfJIM/zutZc7kIM4ve8iLptFajPxkL2lVXmmywZ88Xd/IPu+0s4mvCQcOR8riuuE
	8JvE2X34IRNSwsgdvbpncb/AMuVsmRgykSkCWdRg3kEXmUSPj6M82a4IEIA+e6vOTySGumNR9Ix
	VaMdu121+dsWIzI4b1RYBYmWaDcFw/V0v97VC1VvvB6W71ukzAQc1B7U7f6ECLS65Fk0Ry
X-Google-Smtp-Source: AGHT+IHr72sxnwnDW01eveiKOMN8ReuV1UUnXNulAeH1fLWng/AE/xORbhmHjOyCI/0xtighT8mEng==
X-Received: by 2002:a05:690e:1546:20b0:640:e5e1:190e with SMTP id 956f58d0204a3-641e769b270mr3139275d50.57.1763146820114;
        Fri, 14 Nov 2025 11:00:20 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:19 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 12/13] kho: Allow memory preservation state updates after finalization
Date: Fri, 14 Nov 2025 14:00:01 -0500
Message-ID: <20251114190002.3311679-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41D5210001D
X-Stat-Signature: k4tstghgxpjgd56pdk11ge9xf1xsjipy
X-HE-Tag: 1763146821-841926
X-HE-Meta: U2FsdGVkX18XiBmN5a7EnSE2rxSJHL3TOQs8ZqcJCONtVEHx4Ru3DjmC0h7w1PZxZnxxnM+yYqsD9L5pvVDLw7bknMAfMTDu6BmgjJL8mJ33cG7De8qPBNp6ZoVN9s2CDKbHsDcCFALsxLKS3pM+6OAXH9zGlJaQJXcbLEo/c0pk14P+TR19TM3g62lVf7Jkb+y/jlbhov5a5h/uPrTA2KcqH4clrG4bMbQgoMHt79cqNZmXyljNlBhoOfjrKbc1GHExrYwwValXpQp5ANukR+zNS2tjYpNjIyn+XIRfzHk9Mi1tUDK3sqeoyZoBqNn6bC/olU4kd7nNXdeph/4MKCwixoDNm9jqr13RMNd1hqChO40fchvfewji//lx60F4wiJ7HsFJ+WBPyxVWR4gxdi4Fo/7S5XFfdsXwn/ou8bXF0u1EwrI68/13yPsyDcVZ9N2N2Aa+o7YIvML+Olh0cqLtJvVW09uBxN3XuYs1mU5g92O5UhBDaKBbMAn3f7bCDVXS+f6smc5gLhlIEZhH6rU1taZbeRRw/C/Yn51EUzOmH2eqUsjnyAmzW+B6tt2mBa8ntwNp40z4Gk6FYY8kGx/6ii7SMfXoKxmvQFe/b3CIfc+0JHkI4yl4f2L/ExD5fXLeYRMyqVr+G9UVPfUvBPo34dO3r18AEsCetyU+6JG0SEWISPlhgqwaAtFGOhMz4+nlzS7OjxVVk+mEqxfVEd6SvQjowjeDqj03utEbFH8SLRQsh4fv3ejhDrpDOMg33CR1JnA3CeGSEH+pr94VgLMwLCDWKJCwPqeZdtuvb96bAupDeKZ0biXRsB0vfiKkuMduHSV2dlhHSnPAMyOle4K75uDFky+hIOlpE4OJMRADZ4gW7jEiVH+mKKQUA/KoHSviRTTm7loIprGEJdOuwI+WSBxQ8Wq0N/7nVsVYR30moYDnj/DhnFQf3/i21bAQYb5lwyRGYUN7NUVd/wi
 kx6I7dub
 Au1wYJ+fSVesXilir9rmwm2l15o5640GS1+iW2QGUn1uzJmlWaXAowuIGZeCDLox6q3XLOp+4g3Dinp9UiHJpbdeqQVDCpbloIQ6ufsYEnkvH5UvHBhT4Cg1FZ+lMBjkDmILUpP+RveAcxt+3wnXwXmYBe8H9DaNu2V7O2UysWgqfRdzsUcyBMKs0j20Oza2xF72oWvhIk4m7CHGAInqMKtuLkGlC6c2qFi2G23CIdt2c37/bHVDiKYX3S4ZV0+dFCNuxXltWmGx8v1etBeJ66/cZ9IVX/HFKHqU97lTN1iRmbLW7yDLOWlcsn8/MG+hzXWYyBY+dirt/a3PpZnqFzYzNCUDlX9MeFicEFzSjXzBfOkuhuTvBryd7gYxQ4MHD/3fX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, kho_preserve_* and kho_unpreserve_* return -EBUSY if
KHO is finalized. This enforces a rigid "freeze" on the KHO memory
state.

With the introduction of re-entrant finalization, this restriction is
no longer necessary. Users should be allowed to modify the preservation
set (e.g., adding new pages or freeing old ones) even after an initial
finalization.

The intended workflow for updates is now:
1. Modify state (preserve/unpreserve).
2. Call kho_finalize() again to refresh the serialized metadata.

Remove the kho_out.finalized checks to enable this dynamic behavior.

This also allows to convert kho_unpreserve_* functions to void, as they
do not return any error anymore.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h     | 21 ++++--------
 kernel/liveupdate/kexec_handover.c | 55 +++++++-----------------------
 2 files changed, 19 insertions(+), 57 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 38a9487a1a00..6dd0dcdf0ec1 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -44,11 +44,11 @@ bool kho_is_enabled(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
-int kho_unpreserve_folio(struct folio *folio);
+void kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
-int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
+void kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
-int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
+void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
@@ -79,20 +79,14 @@ static inline int kho_preserve_folio(struct folio *folio)
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_unpreserve_folio(struct folio *folio)
-{
-	return -EOPNOTSUPP;
-}
+static inline void kho_unpreserve_folio(struct folio *folio) { }
 
 static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
-{
-	return -EOPNOTSUPP;
-}
+static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
@@ -100,10 +94,7 @@ static inline int kho_preserve_vmalloc(void *ptr,
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
-{
-	return -EOPNOTSUPP;
-}
+static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation) { }
 
 void *kho_alloc_preserve(size_t size)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4596e67de832..a7f876ece445 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -185,10 +185,6 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
-
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	physxa = xa_load(&track->orders, order);
 	if (!physxa) {
 		int err;
@@ -807,20 +803,14 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
  * Instructs KHO to unpreserve a folio that was preserved by
  * kho_preserve_folio() before. The provided @folio (pfn and order)
  * must exactly match a previously preserved folio.
- *
- * Return: 0 on success, error code on failure
  */
-int kho_unpreserve_folio(struct folio *folio)
+void kho_unpreserve_folio(struct folio *folio)
 {
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.track;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	__kho_unpreserve_order(track, pfn, order);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
@@ -877,21 +867,14 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
  * This must be called with the same @page and @nr_pages as the corresponding
  * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
  * preserved blocks is not supported.
- *
- * Return: 0 on success, error code on failure
  */
-int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
 {
 	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 
-	if (kho_out.finalized)
-		return -EBUSY;
-
 	__kho_unpreserve(track, start_pfn, end_pfn);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
@@ -976,20 +959,6 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
 	}
 }
 
-static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
-{
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
-
-	while (chunk) {
-		struct kho_vmalloc_chunk *tmp = chunk;
-
-		kho_vmalloc_unpreserve_chunk(chunk, kho_vmalloc->order);
-
-		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		free_page((unsigned long)tmp);
-	}
-}
-
 /**
  * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
  * @ptr: pointer to the area in vmalloc address space
@@ -1051,7 +1020,7 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
 	return 0;
 
 err_free:
-	kho_vmalloc_free_chunks(preservation);
+	kho_unpreserve_vmalloc(preservation);
 	return err;
 }
 EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
@@ -1062,17 +1031,19 @@ EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
  *
  * Instructs KHO to unpreserve the area in vmalloc address space that was
  * previously preserved with kho_preserve_vmalloc().
- *
- * Return: 0 on success, error code on failure
  */
-int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
+void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
 {
-	if (kho_out.finalized)
-		return -EBUSY;
+	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
 
-	kho_vmalloc_free_chunks(preservation);
+	while (chunk) {
+		struct kho_vmalloc_chunk *tmp = chunk;
 
-	return 0;
+		kho_vmalloc_unpreserve_chunk(chunk, preservation->order);
+
+		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
+		free_page((unsigned long)tmp);
+	}
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
 
@@ -1221,7 +1192,7 @@ void kho_unpreserve_free(void *mem)
 		return;
 
 	folio = virt_to_folio(mem);
-	WARN_ON_ONCE(kho_unpreserve_folio(folio));
+	kho_unpreserve_folio(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_free);
-- 
2.52.0.rc1.455.g30608eb744-goog


