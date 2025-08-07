Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486BEC87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17BB6B009C; Wed,  6 Aug 2025 21:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7E66B009D; Wed,  6 Aug 2025 21:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992306B009E; Wed,  6 Aug 2025 21:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 874226B009C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5791281EF6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:00 +0000 (UTC)
X-FDA: 83748267960.23.32E1AF0
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id B75F620004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bq9l2PEf;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+B2pqucc9Fmko4Lv5M93Olp+poBlrEG0AoODeQS2z8=;
	b=ceNxU3WohBqTJoy4St0T8MkPbp3LemanmVDenv7v7cGXh7jwqXLho7Z8RlT5tK0JvTSyeg
	zcmFVYciQC93V587eFTXowZJKgKfwd5MyKM6XX32kxuo4S85m3RDCaoyQapoKAzqp3rOst
	kukEv8EJF+CGqfFji+MoK5auHiJUARI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531098; a=rsa-sha256;
	cv=none;
	b=SRaZe8Q5CtW2I4j2jyrpKhiKkZrSLFxrQhqtYW0N7q7bvvv6IxHdMcJAJZO56UEkv7djqt
	cQ/M8R0XUxfFQfbsfq0Acf+ESlQtWFbCM/rIKJPyWjji5U5L5CtIgAQKj/Zt7tRIsTF5IE
	q/jIZBjbVFG3bGt/s695LqEFcS2ZS/E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bq9l2PEf;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-7073075c767so6815166d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531098; x=1755135898; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+B2pqucc9Fmko4Lv5M93Olp+poBlrEG0AoODeQS2z8=;
        b=bq9l2PEfUcsjPtW7uCMguH+zDjqZGVxzoQRfrnjIF0tBsR4gzKqmrKHkpMsmGXYROK
         BZhliy/PKR28GZqxNrY1ztRZLXp/oGcDKgQCzSGWy+85SN4mGd3yrmgbyQNELwcEcFBF
         EhatcyzbZHf5Xqy/FDeW+RZndVXBLb7eg02Lpuh0tSfJAuPvXimDLX8mwg/RVyUq1RKO
         I/6u4qxDw0V9YPvix5/eTe2BRmROtKl/ktVhqmb/+S44v2W76iEH3TW8YY9AmcQV7Ls0
         jK2u1rwhBECC+OExKbBR7dVnsE/1Z3ob10XxIOfgHQabB5SxcBuA79mBzUC1SWtV/M7e
         PJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531098; x=1755135898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s+B2pqucc9Fmko4Lv5M93Olp+poBlrEG0AoODeQS2z8=;
        b=Cj/BNH4lKF2v498NilWT3W1JaEkP6DmNqOdwJJqIbLT0GqZKk3jiCx0LcxaxkGXBx0
         gOamoTFCsp8uD1mNilT1xjxRQoq1C+2KhgHHbQOgVNcr8Km2qNPy6uBzcu/Q9x4ALnXc
         ut+7tnq1RQlP9L/CRFg9X/K/pFlJVFf+m0FjOXjSE7kvoax4ZFhNYOAxJK7vyaCkohjx
         FEo2onJMNKKPuhf7W1miu5CTeKQ/zYWCb3ZEDW5V09TjHxYwbHmCLnUFAM8GZcx53lcv
         zvHVu1Uavt0oeHnLVgvqNRvD846i68UsxzhZYJNUmiXU61INLuxDnCC2CYFqVHblaLrj
         BvFQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6e9Jg+9Nji815+TVHvxB/Dme0pDc8YZbZzcNIbNQkXl3e9Gc8xaKa7I6FtYAotb3MPBCXhXfK8w==@kvack.org
X-Gm-Message-State: AOJu0Yx3qJYupoulB27IJpsjZjaoJ06iPtYzk33QS6+w/vtztartVtvd
	20pso/kZJ7vpMJ92NdulwxD2lGVBtigutUOWZ4TPbraKB5Qhd5hvOKcHieqhSQUjKtQ=
X-Gm-Gg: ASbGncsZ8fGixyrQO5L+2fFH0AO6ZMShx0b2SqB0RXqWwZ/vAvT1rjKEKSRVf5MwwOY
	gAo7aoEoR9YRt2CLV+ikGMCYfXm6bjz9RdJPqznXtQdn3pMKq7rTmWxEAk7lTLT9qj3Qz+FJ9zk
	dGdccvcpsdkXCjjyiNoTKC78M/jXELWM7OKPwFaPYNzMGGQtvOIkUGdDd89pnc+Z2T+jrNdRhfc
	t0413E45shGGPZgxIUVEFweodkLKmHBU/9RubDGw4cAl8QwsxwQG6zm6aCFVeEcw4K+6FNXxQi9
	vHOcW1PfN9z9wXr2No7t3PvreZH6zQKaDVup0R/6zuuWEOcmp4ZBfHSBmCoovTdJ37KTMuZxZqW
	M0XHkIswM8tOZ2Q4DzvdfTkHBzDE3XMT1GWw0FweGnsydRsGvRAEGASbk4FJKV/g+rYtpxx5lC4
	OYvzpy5uYo1x75X5yQnudZicg=
X-Google-Smtp-Source: AGHT+IGAEOC4X/n5iybE9j8P6hUMRBMLG9Syy/4PfWc1CO2/gkmjV3XW7jEAwKFIXrmXPPP2oTU9ug==
X-Received: by 2002:a05:6214:5081:b0:707:415b:c13a with SMTP id 6a1803df08f44-70979539363mr72512306d6.22.1754531097555;
        Wed, 06 Aug 2025 18:44:57 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:56 -0700 (PDT)
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
	witu@nvidia.com
Subject: [PATCH v3 07/30] kho: add interfaces to unpreserve folios and physical memory ranges
Date: Thu,  7 Aug 2025 01:44:13 +0000
Message-ID: <20250807014442.3829950-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B75F620004
X-Stat-Signature: mmc9txrmauzkxp4jt63o96s9g7bfr8np
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531098-446205
X-HE-Meta: U2FsdGVkX1/06scT7kfUIm7kEKksZKYqRMAvCCrh/d0DlEg76aJmHHKhudinQCzpc2o8sHsNz9Dpqutk7bOAq7JUhtM6zpjWxDpKl4u6He6MkwIDm8spL/D29ntpC1Gk3ttCdiRtCZtiwhwASN5lV93ETgNDorOEzsaYQjbQZOcK2I1EBVOe+qCOapeN9M74U85E4II39qDHADkwADJixc7v4DacZyNHnDSFs+x0vmqHYZlovJLsW8+WKCWdr86a2Mg1cYs6K8xTae4hURaflAcJBVAYG7ZsM54mzQIVBUS344RmnSscwiD7wyRryddV5pZkKY9wiKN0jG/WuoFzWOnXgicymLfMfWWi5b7sWClqDRO2TjRiIM54vnpquQdmp+Tzjx7AU4agBfUUildmyb8zrl+r2sU7LZ4TVELj7NC3p+h2jJd0hFfrPi8o3hguGCloz3LJ5i49gvx0zFd+sPuk6oT4cAnQn+1mmNIEvh6Du6CBV2cYaB7Iyq7bVeq09AaHmIl1BsJd49/y+mZEBNC6eXux1fdt6x2PReJmoRnZvQMcTfrw0fCBLTP3zRA0mvKCrNAPrRE8tjdgKwtWrsD1l3VmzrfpPu96x92wKdfYgiGkmiIij0zfyL3zrRE5g+kkmZoSc0a935Z6bFfU6m0IwTcYmxUiwHYlcfnkDKQENxllYo7lTVJRvWFgEOCbn+aM84syGv/geEjbLmtFIp+/GcxUtjRqoV9r6iQZd7VpCYOmsRqtlHHGZdG5yHkVVBh0jatwUoYh7F2gioAzX/Y7w+vy4NqIFod9/jOtqCFV1S2BLu3bL35sgPnziI3/7dnlcoGL13eRj31dmOlcLvYQ46HTAAygVQio6thJR4W8X/i4S9CjLRxazS6ZlNbpBp8nsrzjqF9isXQF4sXok1hLM9PnCNmRc4UULjT2xJOUdM5HmRAhfHEI/ORI/ghzTsR+fH9DwUTQz2gryf8
 dZ5JKMLu
 7ZqMzVzAMX2P4LIg6To+bwkbTKnIREQ8dkXHaqPiaZoVhuaLKMhVZnCr4lPRc0ytv387jlMz7RlMxIxQmyuzTnW022y1tnrRjTJNBCvCaSKnDFMpc0PJkK/ifpQEg3BzFmwWd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Changyuan Lyu <changyuanl@google.com>

Allow users of KHO to cancel the previous preservation by adding the
necessary interfaces to unpreserve folio.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h | 12 +++++
 kernel/kexec_handover.c        | 90 +++++++++++++++++++++++++++++-----
 2 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index cabdff5f50a2..383e9460edb9 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -33,7 +33,9 @@ struct folio;
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
+int kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
+int kho_unpreserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
@@ -58,11 +60,21 @@ static inline int kho_preserve_folio(struct folio *folio)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_folio(struct folio *folio)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_phys(phys_addr_t phys, size_t size)
 {
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_unpreserve_phys(phys_addr_t phys, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
 	return NULL;
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 8a4894e8ac71..b2e99aefbb32 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -136,26 +136,33 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
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
 
-		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
+	if (!bits)
+		return;
 
-		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+}
 
-		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
+static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
+			     unsigned long end_pfn)
+{
+	unsigned int order;
+
+	while (pfn < end_pfn) {
+		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
+
+		__kho_unpreserve_order(track, pfn, order);
 
 		pfn += 1 << order;
 	}
@@ -667,6 +674,30 @@ int kho_preserve_folio(struct folio *folio)
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
  * kho_preserve_phys - preserve a physically contiguous range across kexec.
  * @phys: physical address of the range.
@@ -712,6 +743,39 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
+/**
+ * kho_unpreserve_phys - unpreserve a physically contiguous range.
+ * @phys: physical address of the range.
+ * @size: size of the range.
+ *
+ * Instructs KHO to unpreserve the memory range from @phys to @phys + @size.
+ * The @phys address must be aligned to @size, and @size must be a
+ * power-of-2 multiple of PAGE_SIZE.
+ * This call must exactly match a granularity at which memory was originally
+ * preserved (either by a `kho_preserve_phys` call with the same `phys` and
+ * `size`). Unpreserving arbitrary sub-ranges of larger preserved blocks is not
+ * supported.
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_unpreserve_phys(phys_addr_t phys, size_t size)
+{
+	struct kho_mem_track *track = &kho_out.track;
+	unsigned long pfn = PHYS_PFN(phys);
+	unsigned long end_pfn = PHYS_PFN(phys + size);
+
+	if (kho_out.finalized)
+		return -EBUSY;
+
+	if (!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(size))
+		return -EINVAL;
+
+	__kho_unpreserve(track, pfn, end_pfn);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_phys);
+
 static int __kho_abort(void)
 {
 	int err = 0;
-- 
2.50.1.565.gc32cd1483b-goog


