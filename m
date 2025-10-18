Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1597CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13718E000B; Sat, 18 Oct 2025 13:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D8D8E0002; Sat, 18 Oct 2025 13:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D228E000B; Sat, 18 Oct 2025 13:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A74948E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67AAA14038F
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:06 +0000 (UTC)
X-FDA: 84011892972.14.724786E
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0500140005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CI2c9cfp;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5WHxfW3SzIizo02A/UzhAYaawAGGPcI6431h04qDCk=;
	b=XAzdorbHwq5CWH/7+ogELuOXRhaFnKD2mvmhnUp9wBMa8gOvxrGEumFHI4aLwMuGJJl5bo
	IK10BGuz28z9z6rEOoTetrOZnHXN49lGq9bO/xtggaSvl1z0/QCA2kdoWR+yVrArodNeMi
	Av6VeSe+bF9HBLoPxkctC88ZH2BQ2QQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CI2c9cfp;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807884; a=rsa-sha256;
	cv=none;
	b=5O0d+clDoxAyAnYGOt7SsDKZM48DnWnvI7AwYM8gszi/X1n9jJ7jHs8MDL/rZg8Vw1p9+p
	lRn7alYTEeghjgONSkjURLurKY1czYiy32Jc0sMr+PfZCwjfTJRFogQD4PfQELmsO+RqdU
	9BNGqQ3OFxCWYxUOTQJvR1EXLAJSG/o=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-87dcb1dd50cso14331486d6.3
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807884; x=1761412684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5WHxfW3SzIizo02A/UzhAYaawAGGPcI6431h04qDCk=;
        b=CI2c9cfpVDH66DuIj0qAeY/7AKj+q+dQ93Kr0tu5AHxUJPIoMYncecF7r8KL7g6HDK
         fdNHRJIxBKGMioHFbD0xRMU3IEyCUgmg0KgHWkS06vsk2f9KbMyDOQBezmatvkMtyyUn
         VgKuWUHR6RIrxVtwA5nX5H9uFWaD1X0xETZMLmNNsapozibhb9xJCKt96f5wp63P2Qh4
         kSlVlypSgKu7i9yhoEH3okfGTqyRoj0cSwEHQnH40jVKfcucMQoP/dqafiTHSO1lpaMC
         NYx8OF68HXRdAq3slbvntjrC4tHKd9M+CTh36nwQlk4dla/jNjUgoO+zG3onfptKGmrw
         0LBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807884; x=1761412684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5WHxfW3SzIizo02A/UzhAYaawAGGPcI6431h04qDCk=;
        b=fR0ipSTO2yx8YXhYNKQ9TwVsuiaM/XFJBkVnIWqohEjg0YL2so1Rqugk3TVlruFuCa
         G/zmq2NX3TidOz3MwOClrhYIxxPhpAn7SPKWS8obfDCTQs9U7z5gBve4H/VhdKbHG2gy
         k+gWVTyCpsjm7YZOLGeU/bFjgvenpSfqfkE4riTPaIL23YA+nf7qF0r4srMYGcNrNOMV
         vHRk4u+uQuxLQ6iduzo7IwClNDok5GC+AjCB0eUQRW+GPLWKDMpTpToGri7L6RnOzAog
         cGw3QUWuISeBEtsWes7q+53+RJLXxWoumIcEx5iuDiJad/Zl3Ed2qdYGfCJ6yBo6qXJB
         zzVw==
X-Forwarded-Encrypted: i=1; AJvYcCXfmQGVYpBHfTnwZzQqfSLcjl+vMt+v6sMIZt8MEeWpUx3pgDlgIrY3c2nxF4E1ch3l/W0veH8QyA==@kvack.org
X-Gm-Message-State: AOJu0YzAbY0JiBNcwwlPfBofBIRHuVWBrM3G8EZoBJshFEZsy4zw8vLF
	1A6pc8I94qxJYI4tHsdrGxRJKODsaO8KZFKJpWzCrfq7WCT8mP1ziyhAZ7LVFiHqtis=
X-Gm-Gg: ASbGncv20fU23pI55AXDz91+r3KSzl2F8+kD04VHejOP1Y2iKu924VEJz5yKTArA4OV
	VGBtaWB05AMBk0La5PiCKXCSt1mPeeUO3vHPXE9lI7c3gk8TfgPqT2O3t+ErnzysCjDy39lS27c
	js6JzHVXlwxiTVcKLNDQPizSJpPEcoExGeCkc1uMY3akT77TPnkMghikgwQ0uAtC2bE4L9sZuZ5
	ytAeUpb+17/30lYI30WLKiw3p05P690Hu8SSwlQ4BhAGlDcsTyzwxShoaYrv0shAptTV1nxdJHB
	E5bVop1rBJhq6tAqYpUQ5MjTr0ml1VQ6snlWCOGcYdUCJ5YnlzzZYeu9O0fxyxPxuIaPbd/uWzy
	RKB4iIRwVkPLZlB2pqWWDkCRR6kazbol9wy9+WXUczuDZIfg5GC3C+CQa2Pyc4yyGpIj3kiRYff
	XhPKMrGaRHM8UFBS8z451PUy7Z3ZO4IcMHy+CKbpGN2mzFWuXZhZSjhMw9bddRColV17TzOlu/m
	cdyoh3y2L4wErYKSFv06w==
X-Google-Smtp-Source: AGHT+IG0KpOyqwiHpmU8fcJJ9o2guHulcSg9jALnJeFdUCRHHRENhNr850M5g3dIeP0VTEoRasLhkQ==
X-Received: by 2002:a05:6214:d04:b0:87d:cabd:d4a3 with SMTP id 6a1803df08f44-87dcabdd615mr25975966d6.49.1760807883659;
        Sat, 18 Oct 2025 10:18:03 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:03 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 04/10] kho: add interfaces to unpreserve folios and page ranes
Date: Sat, 18 Oct 2025 13:17:50 -0400
Message-ID: <20251018171756.1724191-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8z1qakk9o6uwcgzzoc8a5c9iua7cgn3m
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0500140005
X-HE-Tag: 1760807884-239625
X-HE-Meta: U2FsdGVkX1/vhYJgu+6MGCkdCRWvMTw07DgM/fpAdxXzRLYs4IT6dn/X9OyMitfJM1u6M6SE4gffxV75mGydd6loGWR/1gsamYXhak0GvpI79xNAEWUavhoouxpAWsBSvnw6U5DS/B+w9peQFw2uPao3BVPMs+fuYUjbNoXLpZu8RC5w5BdKLtzdfzWWo/oJ5u6ZYtLOAn46HQt5wA6uxrYz2TmYzfT+FYUzcWK3DUQK7wXXE2LygwAetyM+w1H66iN2QTDxB+BA+efb/5/kC5JCcjJ8U1Hwjumi6CE0Bezt3BddeStk0K3gLDupyrh0ZnNC4pqnZQ8wr23rZQUApouWKfWcD5ylTwTvoG7JuX9OLkI+Xqp4vYtRDmoNdRn6r+BkUDaFxk6qWSVbQYNstK7JtKdA/LPIsAQ+ShUouTBwJkcr9XgxiINGuFqb5yekpOaFqKUqdhWQbiby7MfKBDOKR+vmgNYAMkiMjACxLPO2MSJdXeqICKj7NGBJ3MW+i55GqA/10HeIsuaocvCygP9EI1OcEhOosEaaz4ZtQQK/efbN8EaO0z3WkudPUtXs7ElrwTDBc/frQTIlPyBI3dlabMpWptoxnS8hsMLoI2YnpyNPgeFMItzA0yZlTdwY/AH7rIDAxykoVBFHd7PRjObts6bkTjAGsF1LAR4cxFH+KqGW7m7i8GFhABdsUiOjl4gGVYFrtNqWV93zeRUIM/pduloDQuUQ+YA1o24uX9xs2hw86FImq9JGjCHq/gO4BC/Ud2nc1/KAT903NdK8cqz+T7xQPi8FgDavA3z6L0TW1dl0xPCxE67qblUa2n3hbz36o1MkiD1MdJXCc1aYcCiKvvw+sDfPpVttjytPSLsAZB0cUwGBD+AM1nGbxfQp8qNwldmffmP2/CW90tEPndWK6Cn95hllLxLCs3ZLzg1mbAYdaz/W9caBTCIKERS1t5rWoxsxjnbZI9GlnHH
 lSgLmqUk
 0e0wz4GTnUVfLw8HLDLmUoBRJIQEDmOiSVzWq9mipH3MLcWZmomzUifyXGOqoJzEP8jKF5dr+FW9lPSgoEDUZbG7UaNbptZvlPP7EYR1AOjqwsy52gl7in+/Ei5RvAu/D4i2UHLyVIm7vqghtBlpk44RaJnh+kelt0r1YRorMaXnaOe7dScANGzt+nqS3Mm7C0pzpTE7JazBvoEanyy6nMnsL0HX5lvHAvcxkUqe+GaFqd8Q87pPlP6+4Dk0BtnM+e/okVAkPB7EHyv/AqyfD4bHWGCO1uoBomA34eNkLgpl9kqt8Vi8srqt79NCHvAcK+1i778EEz97PNXOhm1zCYgI4n/MRoGAlchmJ9i89OpCUWfM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow users of KHO to cancel the previous preservation by adding the
necessary interfaces to unpreserve folio and pages.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h | 12 +++++
 kernel/kexec_handover.c        | 85 ++++++++++++++++++++++++++++------
 2 files changed, 84 insertions(+), 13 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 2faf290803ce..4ba145713838 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -43,7 +43,9 @@ bool kho_is_enabled(void);
 bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
+int kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned int nr_pages);
+int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
@@ -76,11 +78,21 @@ static inline int kho_preserve_folio(struct folio *folio)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_folio(struct folio *folio)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
 {
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e6890fe6a171..78acaa218c12 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -153,26 +153,33 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 	return elm;
 }
 
-static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
-			     unsigned long end_pfn)
+static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
+				   unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
 	struct kho_mem_phys *physxa;
+	const unsigned long pfn_high = pfn >> order;
 
-	while (pfn < end_pfn) {
-		const unsigned int order =
-			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		const unsigned long pfn_high = pfn >> order;
+	physxa = xa_load(&track->orders, order);
+	if (!physxa)
+		return;
+
+	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
+	if (!bits)
+		return;
 
-		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+}
+
+static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
+			     unsigned long end_pfn)
+{
+	unsigned int order;
 
-		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+	while (pfn < end_pfn) {
+		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
 
-		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+		__kho_unpreserve_order(track, pfn, order);
 
 		pfn += 1 << order;
 	}
@@ -734,6 +741,30 @@ int kho_preserve_folio(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
 
+/**
+ * kho_unpreserve_folio - unpreserve a folio.
+ * @folio: folio to unpreserve.
+ *
+ * Instructs KHO to unpreserve a folio that was preserved by
+ * kho_preserve_folio() before. The provided @folio (pfn and order)
+ * must exactly match a previously preserved folio.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_folio(struct folio *folio)
+{
+	const unsigned long pfn = folio_pfn(folio);
+	const unsigned int order = folio_order(folio);
+	struct kho_mem_track *track = &kho_out.track;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	__kho_unpreserve_order(track, pfn, order);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
+
 /**
  * kho_preserve_pages - preserve contiguous pages across kexec
  * @page: first page in the list.
@@ -773,6 +804,34 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
+/**
+ * kho_unpreserve_pages - unpreserve contiguous pages.
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
+ *
+ * Instructs KHO to unpreserve @nr_pages contigious  pages starting from @page.
+ * This call must exactly match a granularity at which memory was originally
+ * preserved by kho_preserve_pages, call with the same @page and
+ * @nr_pages). Unpreserving arbitrary sub-ranges of larger preserved blocks is
+ * not supported.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
+{
+	struct kho_mem_track *track = &kho_out.track;
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	__kho_unpreserve(track, start_pfn, end_pfn);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
+
 struct kho_vmalloc_hdr {
 	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
 };
-- 
2.51.0.915.g61a8936c21-goog


