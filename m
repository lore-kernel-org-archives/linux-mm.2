Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E12CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082B28E00CC; Fri, 24 Oct 2025 12:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23928E00C9; Fri, 24 Oct 2025 12:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3C58E00CC; Fri, 24 Oct 2025 12:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C565F8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 898D4BE6C7
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:11 +0000 (UTC)
X-FDA: 84033494622.21.5636C46
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADFA8A000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sy3Q+Okt;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wl2EF5uWhoTCG3S4g09Ne4AB8gBDQLqMsfh4TvH+1zA=;
	b=Bsc9AYqPWcadODOM9VgHcYRr3vLWFXHRTWYQNxiTxFpPhI+Be30rHvT8QInLpYZf9Ofh0K
	lqYiIR0xc0AYuXtdgZWk48PZ4vDyZ1sDw3sk5sXSHl/jP7R2AxO/wc9sD6VRZAJM92Fc2z
	uEI+4i0FcI7UZAA2NGp/ySSsuc321tg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Sy3Q+Okt;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322209; a=rsa-sha256;
	cv=none;
	b=e3QlxUDwHCYVEe773eNnsqrJCLUN5eu1N47nrtfp05XlIau5GfM1afcU9g5yDfrtVrHf/4
	q0/3vKxlRpdkgb87vjwy2Rvjr1YHPCVqX3LhVs3rU9fZwcMEBbBbiaNJE19hBoYPOsiZ/r
	LZODHXr9U17YLjcuxeVfyHaULc9wSL8=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-781421f5bf5so25510307b3.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322209; x=1761927009; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wl2EF5uWhoTCG3S4g09Ne4AB8gBDQLqMsfh4TvH+1zA=;
        b=Sy3Q+OktApx7zpIjLQ7cN8q1hmww9mEHO0xTcFiaiw786d2M2JY8xz/ZhdammlAd3C
         blZ6aPaZGP6gIDMTdfEI1f+uaIrWoEuSPdy3RwxkLG9otgD7I61/f/bMO62Kj9UvFArq
         yTmgzB35CQoDRQD67l1I8YIY1B3ZoqakKILmdNToMFKWcwKZ1Qev3QxQ5SSfe/2Ntxfs
         IFe5xB8qwqvvBJaVqNeXjAmTUTGaPStOTsLa08fpWFaZQ9xccD1rk/kJ+E053HjNVmdW
         Hnguq4jBCwTi530By5srns/4EDbL/tAAsHOXf8ZVK0/tfAJYe8zgk48omg7+Z/ScoStN
         Vn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322209; x=1761927009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wl2EF5uWhoTCG3S4g09Ne4AB8gBDQLqMsfh4TvH+1zA=;
        b=p+F2uqY1bv2f2uomT/5xZulJ07uyR9kAUKawbOkFRRI5fUFGo4VPPiPJRF4q6QaPXU
         PdyfUnRaa1ovcXdywfuqfMOeUEF37DIVCMNzre9OX29nm01fs77/Zkf8hM4LeD3SVjUU
         wf/nC/fxSWFoLX6x8hFKTX4HJT855RVNtITiPgrpXQg/cvqXSD3y73eB4IPGW3FClYq5
         fmtAso84G8H9NnoUK8/FJ654TPWJMVBeqsm7TBXLvdS94w64t4EP4Go+p5EZBxAVygB2
         MUsjRpOEIg540aUSg1/oeezJlv1y6pqUc/mrBhPn9/g6hcDFTULHioIcuFHFuK6ZsvsV
         92Rg==
X-Forwarded-Encrypted: i=1; AJvYcCVkQQ7x48r1nDppApYCv8y6/KTBzF6+WoaelqI80Tjsgdet+kiXIicjH4US/+1Npc4ml7uxF6fdlQ==@kvack.org
X-Gm-Message-State: AOJu0YxZO2uZMlakghw3ocZFvcTG8m2bI3AqRSmiQEq0Cl0JZsW86kTm
	d4n6Wos8mFbAAs7c8co7JRRGMasauxu0wojkhCpB70gT0VQEn78//ryN0i7dz75jvvE=
X-Gm-Gg: ASbGncscni+kijoRXCBfgPmXcPBIAL/pWixIlEfc9NPEkkEpg3n4SP6X9VRUx9DsTle
	Ats512MPGnaKFAtToxIQWuy5EIt3ZD6mgv9DfFU8eoaPVzNaKNMaSW0zgCX29jsTAtR/gerCLIK
	7OUF2BqzCxSIM20f0vpO5L2duAV6sz3ov189Blzjne+cec+yMr3WAriq/z9YGSxKvtLg420TzU7
	csXxpm3HAsCUDUKefHNxSahAO2ajPcoAPFKOtR1QatgkR6iw4UBODDmNxiNdTr0mLTRJOLB7M4X
	RlFWmYMrYRIkBlWRhUO5YiqdMVfGUo5F4k1v14lcZDBN02zxsbZLz59epFpqsLer6pwVz5o746P
	Ze9GRfAa2xkRvs+5/rvYVLy/A437Wxt+iNTIMD6B75Uhoxlr0aDT/deaNkb0+KU8pbWAe86q2Lj
	Gj0/8kWn7UGo2+RoZhFcX5jvojF5WQ6VvzrsUyJDCkYe1p6KA1FUG8KyXeD3XndCfEzHwboRuJZ
	dB9SX8+kvsW27P8rAXML9xMS2ePptJxcA==
X-Google-Smtp-Source: AGHT+IEOPbBvm+lExMBK1VGNT5FBczDOJCWJOjmYu7xROX/4TrUbJOB5wagHwsMhLi4jdkRspXck2w==
X-Received: by 2002:a05:690c:4b13:b0:783:7266:58ee with SMTP id 00721157ae682-78372666210mr456748687b3.7.1761322208709;
        Fri, 24 Oct 2025 09:10:08 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:07 -0700 (PDT)
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
Subject: [PATCH v8 4/8] kho: add interfaces to unpreserve folios and page ranges
Date: Fri, 24 Oct 2025 12:09:58 -0400
Message-ID: <20251024161002.747372-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADFA8A000F
X-Stat-Signature: uxha645mgx8e7q1egiojcknyu4gf3ioj
X-Rspam-User: 
X-HE-Tag: 1761322209-583662
X-HE-Meta: U2FsdGVkX197t9S0tyGGR0upvrxx5osn2N/3jWLj2p78I1dbRG2IV/MJGlg4uabAvX+F3EG0h3Sh91cBY1omDhyb580LlEygNK6ReXHWySXz5Iy1/PZ3kDe8t4HRHZieoUxbeRlPcNpwNLKHh1xHIIuVjgaOZAdceQ8+tVcJhF6Sqfxj2oaX+KfUggoQ7h3kJVLkIYIRfH4sB36CmCJMwzemS4qFOxBC9tQqMgeNwDqxiYGs1/XrUIJfPDZtK8mM+sCixlBlFMuCY0ILdf3Hj+2cNoz2dIldKDKENBzRVl2mC5WkHWmdyiam0gjtGN5NxCgwv7lYBC3ApijE5KEF8A4MLeA7rKS8sbJi0zUAWUm4oOWMp6VXvaUR5eCnUnIzE3wV+fUVAxRBJbmEhBoleHMtY1urbJzprblqWo2VOnKGasAWBSjU8QhiRfAYeGk9FgUCm9aEXuO3uZOFphI1oQKV7XaxA0WGK/zVtebL7RiHvJUa4bCZt1YLlkFYpssMsDURxc+opb9HuKK5Es5Hh6EmAnvcq5afBF5vx3wGaz488mDokFCB5Xh69F3WU4s4H+2JhAk6DQ8t0HvOg8GUFsiluL6jPl36YzY4lwurwgCFuG8hW41XTaUUZ0VrdQBCRe1u7myrSajT3W8q5d5hHM/9pNjpEvp5PQkK0m22MX31m4719ePdXx/PxkkVJpoLS3KO2x9UXyH0jTOtx846xSvLFTUJhaphLDjWHc+HRB9R8a+xATsGlleR4rN+5lgJEFhkNlrpJCpM/FoNiGIzErh2Kage7uzXcV7K6N0JYdm9EZATknM6jz/3qWWfDHcepmLGAkXhcibLfymH+0LNK/OH8jpQnEosJfSL1pcYgm2KOV6RwqIXNCK9Ooy2nf0G7tcPqMe4f+BYC2LtwGS5T1TAAYjJV5LLuVScpIxUEjE9J9bqQ+BQHv+dDYQ8qHw0WnwKA31SKFD2XmscQJM
 bvf3E7iR
 D8fYfnDHqfJBmjZI39t+HEI6vxPej69HdA9NxP0/FqRcHTGdTcqRNAyzD07I/tUz5YdXJWhGtHo8/B745/M7j6FwtSd4bj0ensI6ZEz3RBLkVKAtiv3GEFMMsM43Vmm0qKUjG3Vf2Xcenxhc3h0WQkR7aDd9nJQa2SR0dhV7qmguNtOXpmwTW9G8681JibkBlIx3dr1MVkpFjqD5KzyFU/oKXo4yDzQkP1dhYKIrjVANxdcqjS7ovH9SmoHN3Zl+jKl4D9jVCb1Pc9LGPmrsDoUn2eBoN2nQjocBR9NAxRklUSklJ2NZPa2KZpJmKAU0xxgyzG8QG7Nzkq/kwYMxrpTiDTDM5iwa8QlVxXm8IanDn2H5B/LTSfTGBE6IR2oSpRv9q
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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h | 12 +++++
 kernel/kexec_handover.c        | 84 ++++++++++++++++++++++++++++------
 2 files changed, 83 insertions(+), 13 deletions(-)

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
index 82137eba1474..994ee0b70757 100644
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
@@ -745,6 +752,30 @@ int kho_preserve_folio(struct folio *folio)
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
@@ -789,6 +820,33 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_pages);
 
+/**
+ * kho_unpreserve_pages - unpreserve contiguous pages.
+ * @page: first page in the list.
+ * @nr_pages: number of pages.
+ *
+ * Instructs KHO to unpreserve @nr_pages contiguous pages starting from @page.
+ * This must be called with the same @page and @nr_pages as the corresponding
+ * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
+ * preserved blocks is not supported.
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
2.51.1.821.gb6fe4d2222-goog


