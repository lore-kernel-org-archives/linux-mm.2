Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C303CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3028E0009; Mon,  6 Oct 2025 23:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D968E0002; Mon,  6 Oct 2025 23:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD5D8E0009; Mon,  6 Oct 2025 23:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEC08E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D09FBAF59
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:14 +0000 (UTC)
X-FDA: 83969892468.27.51F095B
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37FB840011
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZhLpBYGy;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d75MC7yX8fTJ3DXLRKGrsbPruNC6LGxufxG+WL9vn/A=;
	b=JOvkmZmWpfnjkQrpR1xV4eEUqzBmPX5qCTkv5uCwd5Q3mWxQ2aUuNFOJSl/VA9wIxfWoqA
	enfJIQrFiTjNli9o2bxenRF6TI6morBJtAYUIqd6kObJT8J1xyB16CW0Xk7Q/wnASLwywS
	xJ6RVQ3rdpm1dJsu2wFmZpFXSuD4lPk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZhLpBYGy;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759807872; a=rsa-sha256;
	cv=none;
	b=FU83/m0tCbzJWxS5njte9jgtBCGEhhaq8Q/vGk84yk6ecQa6Iuyy+xXyr4GztLQvFTCibP
	72VDmYJ0vO+1TkJbIaPqlMcfl+hypnPBO3kXfsEe/Y1jENXiNtzmrF/5EysajeYhMhljB2
	Opqn+tWZrIpXe7s1j0+4HDQwOUYAlbg=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-54a7bf06edfso3931058e0c.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 20:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759807871; x=1760412671; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d75MC7yX8fTJ3DXLRKGrsbPruNC6LGxufxG+WL9vn/A=;
        b=ZhLpBYGyug3c/yHlV8CPd3Psl4HomJYEmCWpQogicEE+Q4rm53qtXhvPtvI/sv8Iww
         bXmQ9rWbghDdcuB3SjlGUc/KPTDCfv0EnVPIgC2M2VHo4jRSf5BkHqC0NP7QuY4sjRX1
         NtcrX3ZrsvQ0AEByG0KV7zwCPd1awyAMCOnu+QH/WEcoUDLi2g/g2SpcwMIb4dyXSBpK
         3Eq1GoduhrbRfLAJ/qJ12KVQ+EDRRUad7XktZOFvDcX85B7ogyUYwJrTj8Wqgb1i71Ev
         Xr98cRnG/x4I2UodHE/fJtSIzZqURY3slyztF3drq+XZKKDwzIviHH5gjp4lnuiFIcez
         RCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759807871; x=1760412671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d75MC7yX8fTJ3DXLRKGrsbPruNC6LGxufxG+WL9vn/A=;
        b=TGMOUVG0NFrURRKU1mpyfXzladOFS+HRlMn/xfmZGoFkO9iqlQVFsvJnWdnaZ2lga5
         zykTkTKi5j7X0eeJILT7vXsYgu4nmCDO6Cso1c4SjTGnmCBKdcenQXmyql22Msh1jEGr
         T9JtHatK6Z+UowpJ7w8/doizcAfL/KscCp2SHUv2vYp0mAh46qYRwR/iy8J1NjFzASYI
         t9T3L6ivEZ1X0sGxy6+Dy5lNkwVj8sJuMurufD4jZhU/ujsoGCm+fq+H6XUmOJDPZQJm
         66IcoUUW4+eyZLjPuFNfuk2B/LdXm5GoBGISkgYK+gwBYDidiYt8pD1EYeNeAeMXaICb
         fstg==
X-Forwarded-Encrypted: i=1; AJvYcCVxX67x9Q5VtmcmUX28BDbY1PUpJH2zab49R2z3P9fxg4mGjMW2xXv9ZYQp6ldTGNbJgNZTaiZV4Q==@kvack.org
X-Gm-Message-State: AOJu0YwanLF4OjxRi/lwEqcwRTF97akojmC6wuKp2pSuaV0CIrcIndAR
	uR0QsUbubFGYOdFbIpWgH5APSgLn8fJUjE895iRecECr+pGlg0KKZBezlapwb6FeHcc=
X-Gm-Gg: ASbGncskznRGioF/ncH1Y5bvfWZrH9AC9y7ty5K/NVbGb2VQykttggKi3z7UM0gZaI6
	0Z+KFvEcsVcvkpAI09AdyqPlulOEydWcQEg/deNiuVrkugrou9szQfBYueNyjI0hwkTAxFGc1p8
	VqxzvumN5Oa8CP+1m+eI85hh8EEs8mty5FFqpjV1dS2fNhwF80fTXskef50cGxQsnd02I3eXloI
	P5BREwgUN/bfjzHrrA41HeqmvBMNTHddKzKJWWd4KpZniFeBE+DckSkXQeEPk+rTAOoU38VfCco
	LDDyCsZXW+2rhq2VIdfjvNr/YQyYNz1WoSqgdKUTNBk7cLf5qn5Qc2djAlFbiv4o3caoeswbkq4
	Lcl1+x2WEaBonOeI4vKs72ZvnjCWkf2o7RSEEbjyfKN+1mQI6/4gaMTexW2Mvg5xfEcCsvxmnyD
	xlIN6imNyMWD8UDrhQwAXQDKWMzrx9Y0c=
X-Google-Smtp-Source: AGHT+IFIriag8/rRrhYuf3ipZRqogDe9fVyFCNEZ9cflZH8v8IsXkHoHC8oknMO6yF3MW6LcKWyWVA==
X-Received: by 2002:a05:6122:1823:b0:539:44bc:7904 with SMTP id 71dfb90a1353d-5524e8b6931mr5202328e0c.5.1759807871292;
        Mon, 06 Oct 2025 20:31:11 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-552ea335f07sm2446030e0c.15.2025.10.06.20.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 20:31:10 -0700 (PDT)
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
	tj@kernel.org
Subject: [PATCH v5 4/7] kho: add interfaces to unpreserve folios and page ranes
Date: Tue,  7 Oct 2025 03:30:57 +0000
Message-ID: <20251007033100.836886-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
In-Reply-To: <20251007033100.836886-1-pasha.tatashin@soleen.com>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37FB840011
X-Stat-Signature: rd9wodrafia45ks41xo3sonjpisf7z87
X-Rspam-User: 
X-HE-Tag: 1759807872-845507
X-HE-Meta: U2FsdGVkX18tKVQZwRAxGUomckjkgfWoYMFAU3ZSx55imtu5DkS1rKhgXpG6erAgWoG5Lnp81awiklbZiKcR897HzxOEFV6af84d+kNDVNDvHRxvYdbLgItafeRaAJQG1EOLQ7AonPDcWE/mSv5hwibpfXPzjoZI+vgU3xdMfZ3/x0xlpKDbPOvTdkzo/6sW4vSmLUMVFL3H9nOQfcHSiVvgIiq4rRRDJsmYuqNdH3K6OblxMyHncgrPC4xgFb0egshXXn7bULoRwxMdj58t1x34J+z7ARA/6jYKRw66MM9TbXSAexRf7T21iVx0kicNeDt/52I/YfMbJ5Blnt1N4wIhsFkV2ySuuk4jNGrhRb7OtTP3T1Wd0oBwFKD8WWAdcTPmR/9eZ5AdHlpl1LIqPbAqmiux4bExsTKRafLDFILmI7WVTYHmAw457dBXFv0gdcZVqYl3bpyXT6/ONSNChwT1rVhxH5fTnkncegROJaUfwdfdJc5ZA/uJgL2rhR5HBlp3CXWNyzq3KyTaIkESs1+Y3bq+YtxJh/yjvUg+8flAKEl9hTIZ0AZZ1g2AfCWyZr5cf7jcpjC504rebhVJVAdF4a4I8MlJTrZ5e0ZKXYQCRzEX9dXT+F2X7951R1oefGMLK3IuGklM8vR9rY602PcdhZ39zkGCEqt7usNK+x4ycrdh2CYEG/gMwbA4FlWDFEnzxIAyVkAO85FH6a/iCExmFhkyfBiPrYo1EWzqcJEq3haeHE74hhMNsHRzsmgpCN7nlOTlMpDXXpc5bEXxcMj5UvlJcUnI88tfBVX7ZIXafknJIZDwtII76v/OCb6Jm7+uqWjJgQsn6Pl4u4GW/n1aXHuB+eYQPGLn8tyXGCVE2rlmmvOZQqbOFoknRs3iRIJrN2hS5cSVq+Qib0aBrxX8TOLc5nB15NTUUhKlXnAkdOhPDatyy1/Rr5YBCRvGDfoYiooQma8XhE1B6tE
 mGxFr2Gb
 OahYH1+zNJ/rlxSvaG6b9JYetIYYjUdd5R6fG2cnPM94K3IpJJTa1nVc2SQrRsMcSLeVYPLOKLfRRA4cWGDtp4TqWRAdbry9VN6hmGL6jZH4o2v6wB7pHEH3PfjWQHNhbzD13I3WyOq5qH6uLVlGNXNvRRbncfxD+v77ziO0OcjTct2nIXmJkPUumSrgV8wbA7ztRVcRZN3toRG8An9ET6lIpVCSTHt8HuwabUbdErYSwBhZuB769gDnSEJI+oAyRJFHS0rgyRFye1DskNEYE6SW2RypUrdu1kxOgtSMoEJ9ZYxVBlrdanenKQVmT+tt/rjgVJ9HZya9wM1HpRLJuDF66SDbRCqFW0jaFZM64+spdLtM=
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
index 846fb4aa6948..77fd7dd991d2 100644
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
2.51.0.618.g983fd99d29-goog


