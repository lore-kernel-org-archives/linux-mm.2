Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28020CCD1BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375448E000C; Tue, 21 Oct 2025 20:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE9C8E0002; Tue, 21 Oct 2025 20:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1782D8E000C; Tue, 21 Oct 2025 20:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03BEF8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C6051406BA
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:27 +0000 (UTC)
X-FDA: 84023936934.27.6CAF6E8
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id CBDBB120005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NmlWkCPU;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+qadFBBotkNKd/oqO1HqvVbgecomYazxdkikuzLBKg=;
	b=N9SZfSS8/4qLaqgx1aRv7N15ykwHfKjSSe3BB0QhbcA/Km1mDbYaisoivew5/qGiBjvFxU
	goLGHmaIyIoFRKC69KBWdBo3KlI/AXvhx3537bA4GlOmLpIS49z0IvuX+2ey0VwHNrc5P9
	eQAB7ik34ujuTpHY5v4VtJQ/Wt87W+U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NmlWkCPU;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094645; a=rsa-sha256;
	cv=none;
	b=Vm5ePFiL4yKcFxGy2Xb7K+Rq4/FyrKvCdegRZwB4uR3lOZ8UxAjdxJqGGY3Pwz4d2BYNW2
	mi6CoO87dJsNCZXDfHZ+oWtvRxnXco0oQ96tuhq2hwJxPsw/CokbsPpQNZydJ6pltWHH4s
	RqVQ6b3UzUH/NDzSqVbcdgikxY0rquI=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4e2d2d764a3so4276271cf.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094645; x=1761699445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W+qadFBBotkNKd/oqO1HqvVbgecomYazxdkikuzLBKg=;
        b=NmlWkCPUTvjdzHvRTXEMvpaDuqUQCgJhc0rZmqr9amHxI1ZsX0w+qK3T80BtWxHpj2
         I/mmVdM/xGQqcLSA30zf+UKhx5jiF3iZoLbWtwwyHcATBt2QRij8SvuqN9+SLD8F7igk
         NGvGOdGYwpaWMyrxsX03TJFvcFGWk5vhkh6z1HqvELLe3I7/7HiFWV4vawRyBCrB6Tx/
         WTunSvVpPnO9tDnGB+YM+zy50RVpmlr786tKT/RbLQvK1jm7TSRsXGeF/ZAW2BH0/WNW
         Qv9Wflur8lko7pjOiU9T7LECuxEbpLYJDI6bupqnb7aQ2zdAdQZ5WBaF+U4puTTxh+E1
         gmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094645; x=1761699445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+qadFBBotkNKd/oqO1HqvVbgecomYazxdkikuzLBKg=;
        b=P+eNIGPfOw45I32iP37bgso+RcvqyfvBqyQG3G1J57xSipx03GDdTNDeE+79s5sk7c
         1ADeEKpd3thwCxPH4huy30gbOpgI9t9o03TR9Kf4BhDFsvY/NeZaQtNiUZ8J9OWXV6Zo
         bAn+VBaSWhN4nLSt8f6Nq3bnplhFyIkANMsoNk7YAHlSSQbG8JI4Cj4uMQ/HSUkjGpB5
         39y88OBONHUMo6qAen2AHpwUhI8zwE4TOYvKHTnOg6OWEP0z0ABxMwJLrF1M22xV0Yhm
         Qig8gD1TDDKbhpczCFIC+IAR6OhRn3cQGz802T9EU9JfPaPDzlpSLF5npgfb0p76ff0J
         nElQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSt3kvB0Kiarhjz5bLOYsi6bSixz4s4MXn5H/npVoLfppBVDox1KgOwlQB50N6FiwTwBUEkRCYcA==@kvack.org
X-Gm-Message-State: AOJu0YxhXdqiPr3Yadb/Rbe9YyCrXDY+sBrb4EyTmGfH4084uPYSM2o5
	wRFnrzoBaFezfTZ+JM2qeRl6tgcmFhrkxnxGiFNZwQUM3xDDsuk69+9/LBPD6gPw42k=
X-Gm-Gg: ASbGncu7i5WzOd6axZv0kZD743MBZVD2vC6ZJ1SS3EHko9vNOde1i1qYHJFv3TfTD9A
	trmLn2Cs/nLVydPyHP1KhTtGVrdwhfNGa2mEgoJsP3hwrYGBUkfnPvJHsqxfDR2jpLDt00vpylG
	2M5Dc7K5oqxDMLoZRPHPgwAsvbfqe/yMZ8l6ShhLMbViZ2LKJCWugn2e4eWFReDUP2h/05HqwD1
	y/dThVxjwVRHePTZkZqjcOAe5qQaCwS7zs3X/sBwrJd9t2FC80xQaXgme85/LsRU8ddii5Vkbby
	M2esX+Kxd6wa9CrZMoH5eIf3WYyH1zMEFYRkP5/WG1Ts8UvNIqeDTR4z6KSFiJVCGXQISEl9iaw
	9L/Ygz/co/0EIyYvWNr8h6uSWrNnBFuW+GZWRyZAYqksbRA+3x3WXmeDioQMeGV2KYRY6cclZor
	uAmjM62G09BraygfqBBNiODTHylV8asO4ImSwZcIOx/fmh+ZLOuGq1WIyJ0o0lGdJlXUhY+rSx9
	QjREdQ6w15zPNMyFc9Uuoi/bbjFRzrB
X-Google-Smtp-Source: AGHT+IEbvWQwrifIahe6E5wZ3o39RE/3lexOa2z4QGwcdffIuvb1yOyb5Y/9vOdhLrPU2DTeJO1H3Q==
X-Received: by 2002:a05:622a:1206:b0:4e8:b23e:8558 with SMTP id d75a77b69052e-4ea0dea50e5mr93304831cf.77.1761094644824;
        Tue, 21 Oct 2025 17:57:24 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:24 -0700 (PDT)
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
Subject: [PATCHv7 4/7] kho: add interfaces to unpreserve folios and page ranges
Date: Tue, 21 Oct 2025 20:57:16 -0400
Message-ID: <20251022005719.3670224-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5skfq6t8n8s5i835sknhpq4uc65i8z7t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CBDBB120005
X-HE-Tag: 1761094645-324511
X-HE-Meta: U2FsdGVkX1/HxqiNS+AFhrgxIbqDDw4kVMf/wGFla7yj7r08Y+C9CdeqMNjNR5VXrnWFA2l/cIOp5ThOAYzExizfnNDCjapAD1AyuLhKgVCCUawrhdha11k5hRROGlyI01WthEaun+vKrmSGDQr2MFLGPj3LCSFPxhEy8yln6wbVtamon31dJ6Jy+qCmeOmFxq/EUyMTDVShO611nuBhazkBEaYCdtpI+LlNkzIzsSwdDXFEqbvRUhByTch5nD2GlBbvCfV1uq9ZwPEc1oUysbJc0JJTzRxuf1QSu94N9fUroTz/mPcr3U6BNeTKySYbQB0Eig5OLUtF83z10dWm2BKShPY0GLF/aXS+3hpdO3YCkiI8242yiZefPxMFPLp6AF5E528LzUHYix0rRgm167325viM3irm/yM4/e5zFka7iRn2vY4WuoMXypW2JiN/51QvtAz0MVq2SfFFE32x2yT6HFnvF/EAIPgKPRG9Vf7OqSGx+r0evUr5jq/aRSKpZ/YSFRDTiUrAyFwsZHwtmvcQmzOHJY4uEIfjm4uF2wOTarodFN315j1OQW7xUXY3nf5/TyjYpcIUDA0Hh2Vvgb6AgsGMOffmglVNRmNj6EoSCLkBEY4xBokIL0x4bdnMvcMCXQm13RiJodmMSb3bYJBuwGNJyZjrKf65UiwTjPKH35yqURQ5nUMC1vvYH1F+ZGJUY2miU7XKiBe5x1n2sL+m2spGGsV0j/vs5YzrBsXjayjCrffug4I4qFoFpNkEVYwEX1g0CEyN1PYmBGI1D7wj4JcxAbo9XSaPyru/7dNFoUWRXtJbk/j/z+jiT8yLRaVKrytdm1USbxVOnC/M8L6yZzLMHMttqLbyEsN/LnhE91g/zsv7mxNTyueIHHFuWm5Px6SOG1r5ojul7SluInX3gpAdHmVDRZekRPzm3SHQatKd1xNUmEg3qIid6o9DiEpKNfGAxPqZx81u0U9
 9i3AFtyT
 bPgS2jl9Jb2pDspPURMUSA9odQKf+/hsZ7fnlBpYbX+OcB3iQWUd7I2dGGTdNKq2/yLFbwXjTPf0i/IBVvCv5T9nAny8JM6J6g7zPMTBAYGt9JTdtViOf+MVXVBB0vbWN2R1sJkGKqcdjpK8FIMRhmcAd7p7DFaqN7bbtHhd1/8tJymAsuO4Mc1pzegarKs67PzJdyUaR10xZTy/69E3Dv/PZG13zStTcchHz2NI8V6uFiKOI45KJz+dRO8wUtFfj6gmzTTWS8Z9yQ63Khyk67/rpz15HyoyVYjQjUtxBXI6EVHYFMIIhkP4HcKr35RMHix0syzKpgU5IAJ6pjoTDRWokYGV+oHUir7tv4I7U83Uoxu8=
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
index 0a4234269fe5..8412897385ad 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -157,26 +157,33 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 	return no_free_ptr(elm);
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
@@ -749,6 +756,30 @@ int kho_preserve_folio(struct folio *folio)
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
@@ -793,6 +824,34 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
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


