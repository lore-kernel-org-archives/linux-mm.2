Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 492BECAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732F28E000C; Sun, 28 Sep 2025 21:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD4E8E0001; Sun, 28 Sep 2025 21:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5106B8E000C; Sun, 28 Sep 2025 21:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEF28E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A824160211
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:40 +0000 (UTC)
X-FDA: 83940490200.01.BB1F343
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 478978000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F05oGGfj;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezlL3LcjIf2ht7RpS8bynkMbzZtMKTbogv0OCRBHCJM=;
	b=0tKk7nh3Io81HL03ebJ5Qxj4yAiHeFc+ydgg5lalvj+xh1D6prlBZJAvFKWtLvG64x8apk
	vRA9WjTVEFTj4d4iB67xYBv/hFOzRAIJRD7Otw6s3s/VKJcYe/Mp/PHosyRBxJ8v+qo95r
	j47ZpAtBjgA9PjP4kjpj3vOYMQ28HBM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F05oGGfj;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107818; a=rsa-sha256;
	cv=none;
	b=cvHQnIcoDyQo6X/4MEKH1Cb+KcZr9Bz8+gkHsdBVJ5Aq+zEaeYeiQZWJb2x73FGEWfzIxU
	9l6W2JogscKDmuYKAp5xlybF+SsmZ/bTFJhtTuLZTJvWG1WACBzgsW+NqloZM0gcrPcXSo
	Q5pR1JB3Z1QU4i1HXiwOHpymZeSkIgo=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-86302b5a933so207902485a.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107817; x=1759712617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ezlL3LcjIf2ht7RpS8bynkMbzZtMKTbogv0OCRBHCJM=;
        b=F05oGGfjmEW+fSlU6wc7ImmS9CTQQ7r64x+P6P1HUh8oAwJ/g/vQNZUHr4Kbzw7RPK
         tZZz77HbTPEytclrvKZNruO837S65fT25MHZGb2BSyUhbyFvYXtm1RKCjImclysOdXfP
         4Ma2OmIbOZyXwg9lW+xZyYr/YZe0svYHJFMRw2PPS7fJ170Mu9mbll5xq1esxNQ9JyT0
         DO+ze/U05Wm5Vv/oZf3n7eWUmavNH0JYJvcugGiGKAweEzB+is39PlV3CP5rkXUz04tb
         9MMnU5eTQgzQeWK5uQlM9KVhiFmiJFoJGzrHAsFkdSIF84lO1LQ/e++kBOA9u6il6WjE
         TbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107817; x=1759712617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ezlL3LcjIf2ht7RpS8bynkMbzZtMKTbogv0OCRBHCJM=;
        b=VcmOBWDIlB7FMwmzkpDZMRGGvFdifz2Xr+UzOy3Lz5QM929KQIfU3NgA8LNE2xOmxG
         CruzkaMQXWU/m8QPV7E9mj7LLklUyNiFCT4hhw4Z2L3Z1bJa5NV4aNhUnlwcHJgd5v3L
         AEOkWXHa+ly/MoxpK0vf9lxEcnpcT32lAWtuq1o9UQuI1tiTedpkexAJA3ngkcOeVacI
         w0MMndY2VLzHKL06cNK50f9/iGvUJAIWT+oEl7erz+Z9d2ObErnetV4DHk2MyOBNjGiy
         yrBovR3vqMZcOLa/V4GxUiI2q72vWnPAgvubCFo0kF6f4BCBYOuxfwHE0nNtj6Q9XD7f
         EGwA==
X-Forwarded-Encrypted: i=1; AJvYcCV3GGyhx100yZZbIVocEXIvJ68UpTPF2G7mVY8h1vvBOD5P9bN9ubHkCR3ad5WhZo7aF0tdZx1n7g==@kvack.org
X-Gm-Message-State: AOJu0Yy6fC001KPBF/Aa21Ay2tbOgg79uaaAAmu6PT4DEMU7HB/dsJlS
	WdQkeIG1GbRnoL5SPe8TqMP7l+Tl2pknitIUBm3/LCYbiGFwg9IZIo3ete1oXbNXhWE=
X-Gm-Gg: ASbGnctTaEbDN8kBViHXR57xWm6/Y8AZc47TAJv1zDzFRaayKTrYxGNsbloVAm+7b2s
	MWBqRtnxmnisZACjpCYglqnLyXFvIqKopdzzk7ADuPZxrQKJLpRaddXabIGfbLm8Vu5W0peRv55
	k8CtUd8s1HT4fq/JqXLwC767BFDD+LKaQxG+04YK9gHqNcJOlqQIngE+Edj0EwvyvdXf5vS9Vjy
	HRPOEIVzBFohTvER3gSlgBKUJfoFTguch53fLt2Th+rK5isFswJusEU0RRqlWDaNDhQtYdZDe6A
	XH4x0r2DsLU9duP0ah5x44R/7vMbdrc88uvv9gUgSh4rpyNzk4XPCrut+ugrRlZzC6G1M6cn0T+
	MlwKq3Mx1PkYAN6MTt9Ij7dDulwmIZ5NIE1BFLs+Aj3L3/IjuqdxiTHPsfe0qHYCJzmzGvTmFB9
	H9z008HD5oL4Dp94m3tC2iKE/o/krl
X-Google-Smtp-Source: AGHT+IHaETUM84OTpHheMB0hdUMDHvd/ZJx9O8NiNJ3bWGiu/zS0OpwUNUxS2hk0EnKZS1qySrlkgw==
X-Received: by 2002:a05:620a:f0c:b0:855:cfe0:b6eb with SMTP id af79cd13be357-85ae9c6d420mr1897035985a.75.1759107817220;
        Sun, 28 Sep 2025 18:03:37 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:36 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 04/30] kho: add interfaces to unpreserve folios and page ranes
Date: Mon, 29 Sep 2025 01:02:55 +0000
Message-ID: <20250929010321.3462457-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ff5cfo9ihssno9wspq48nhjynain5y5
X-Rspam-User: 
X-Rspamd-Queue-Id: 478978000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759107818-231780
X-HE-Meta: U2FsdGVkX18yVOFI4xgymu0Xs/TzZTGcU9rEMN/Nrz/2oyCa08ssjztrRFI5abwAgZ0E7N4SlRngd6X/8eFJXShVe+pK/wWicjOx1rgoSt/x6ovcVeQqweqXfTcgdrTpqs99nV4xEItARVrJTQqbhwMXBCUFJZK9zz3/qjYB47YdXN88OGSy1M165Lsj++DaWH6IzYWT7pBn+b4HG0nAT1KCuilkRCYVawOc4tPa0afsvaOvAJdyZkdyRJsUreBkhHa5KMJxaHbOnjzkmK7i1Pr40zAoTqIMWR0f9MG23T1LrMbsuC2JIqRe2srsnNX04CO02Ed7Qd8479sn3QKV5i+cCPnNx3lLcmY1MvFpro3yQeGRkgijyPh/BtXeyBxKay6pCzlYSThOxC5KehdNPd4DJoxn03ohv1A3nO6Tj9T5dqmHWJabAGxp45+b5VI2Xmy65XOqlJqjj2if20L+N4O+FUqPEI8fX0sVaTlOzDzlO/HYAEAdHkBTCnnZS5xGqLAvl+rn2pdBDLJ8OwlRlUhfPS6K+n26eeDG9hTPNl3ql2j9fefq/LPbGmiNwpu6aQV3FHXU2qsGeZCxMOvxXD8kZG8B1Ts/bXblznODtgZv6MyQ96wuml5aUSv9Crr2FDjnpYLy/u3Ky5/tRIbG+dcGiW+qp6ixpN7OEU/Ls+ZrOJezpoJJUJhdRkDqR5XgebtmWnmdb1sGsazIiAXE8NpRGTZLMqpdMvUlKFJpT4ImM0vUPbNn+PmWnfKXSlEFVFdYmSgv88XfOPMw1SASJqLwizyOeSIVVYByM6FjltdbGg8uDuIcgrcXkVbkoFY3K8GM5dHScV2nFhLxvWqLX9YfJ1B/dW7/LNtRSRtd4+ecyZXQKpznIGGnFD1frdPWAlpIx2TVrsZEZ1KJ/ef1oWB87SDw31Ym4lo1MAVnCio4rWFX/20AQlaBEw//k/qKaXTajdrDyZNWGiC7sWV
 2ie2VeSp
 7leSGfzFL01nwe+uzgsaLWb8qPDiN2ePubvk9gF/Xwy80dXIqIpS+50DCSTgMq9Ngm0VbhpEBz8pR84da7z7mFM5dR2BGvbStV2Wu3LatR1mtCGnaVja/T71aezSz/pF/NralcDUWhlK2l6H0FA7zJPeIcSHmw5XsQ8xjcwU1lIRrM5jdtW9OmAjcEP0IaZeb+/MAaS41SQfGugNYQos68ZMUHVk5qcAg/J8kB+Bo0p0jmfzwcCTqqJH7mWlIUDLx1UT8/9E3uJmDHyioJkyWbj3nTZu/Uip96qZXNpJ0MBttstcPUjqiTHuembyivAupheQrSN8f1WpgGUUZWM+LRddOSYYNbHetmXvVq5rQYGQU0HgR+okQ3epTyB+gK3gLhS3u7UFBBSaVjW7jTNVY2nhhsNhxFm4+Y9cR0F8qT0inTeGWfPtp67pylcbp/1DBdJ7BLvdQ+NwvSVA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow users of KHO to cancel the previous preservation by adding the
necessary interfaces to unpreserve folio and pages.

Co-developed-by: Changyuan Lyu <changyuanl@google.com>
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
index e0dc0ed565ef..26e035eb1314 100644
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
2.51.0.536.g15c5d4f767-goog


