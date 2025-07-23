Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00B8C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF88F6B00C6; Wed, 23 Jul 2025 10:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9706B00FB; Wed, 23 Jul 2025 10:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70CD6B00FD; Wed, 23 Jul 2025 10:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91C7B6B00C6
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E3F180729
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:11 +0000 (UTC)
X-FDA: 83695807062.30.98C6153
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A56440012
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=zxM0NC+V;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282029; a=rsa-sha256;
	cv=none;
	b=iHA86tL/Q75w9CtL1rmOfEFw9F83D4HBWVYLl3D+4WvOrm+Te637h6Cs3k8g7GzKPl+Zqa
	bCnv2semFOQBZfo6TjRow9oUMMw4WMkg/ViziHhv74tijKVH3f6Urpxxo/69WYflEkbQRC
	LjnxqcBfz6k2N3r/sXJKu+FPnR2MnCg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=zxM0NC+V;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUhylTCjCy3uyYdpO2FGhnRAf1jyGBpF/+3Er3S6ctA=;
	b=6mQljLN28ug4CCK1azU4VOfB8TBU/cwyu++rdTCpdtId1V8ewnJ/X8aQ9FbHtbEeGgE0QO
	5+D7+NQJz8D90cHDm03pLAVm8XgGe6CW9r5WqWF6KIhNrcP+DGMmbltmUJxrR9vq9I/ynl
	z8l+lbv6a4jxtl/5B73TD/uI4u0e7u8=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7183d264e55so67240927b3.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282028; x=1753886828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yUhylTCjCy3uyYdpO2FGhnRAf1jyGBpF/+3Er3S6ctA=;
        b=zxM0NC+Vdxz5oGIOzyYXxaq4pzqQ1dOYC0MexU0U8a+FDsl1uCRKPqrJnIPS0jb7yw
         W/f2Eu7dzWVdkBe1wCohjySBxNaxVkpzlCqhm9Um3VaxFcyAcBx6FfI9MeTiPczGNu+L
         pa6cBVQfJexyTE6Rb7yzZjFnX+sfKmk8WCKItr2Ev1ZRUICiRUtHUA8WaZOSSK2Y5jca
         8Y0naVvl9yopJQaGp2tC607VTQRCJHZAty8+bsIBN+ElyKA3VTfHX0oO3R0pmULWqEej
         X1xPDTPY4vfgRURfHoh/Os3gL7kQUu+fZHzYR6Yh+kHZKpb6tH/Fet4Lf0d5P2476zvA
         F6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282028; x=1753886828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUhylTCjCy3uyYdpO2FGhnRAf1jyGBpF/+3Er3S6ctA=;
        b=HaszelhIq7sokwQntf3kam4+igJNiLi78pjjRmlGp6JwSmaV217+Z9cBPy8WOX+puN
         2DwbdM+1TuWpmpA3svj+Eq4pwWBvPG9SMKUYTcLE+HINorgOs9q6WGUtKRZIUW2etMe8
         2LUP8qYcuXU9wbgPGr2EVcS+ldEI/IWQWFCJBIbIZVxqFAlkRUANPSw6XUoWIao+rEbI
         QNNapCX3j16lvbB72G/WCDPH4Fv0vU+k/3yQIam/8fCpZ6RUC+da7Ig0v2hqaMTsgS8c
         4B52lVHIupTedb9TP0FR3XL40VSGt0/kLd5ODgl/XbKjXi9ba4BWeIYKyj3kHWW8eK7l
         x8Ew==
X-Forwarded-Encrypted: i=1; AJvYcCV6iKPCV3iyQy+nGznJneF/U/yanPfU9teGZhxV5GhmnCpQkXpT/DJkEvpd/j0/iw3IJiTBCy79Fg==@kvack.org
X-Gm-Message-State: AOJu0YzuAtDacEheSwOzvzrD/NzmFj7yMpgb+4H1w2YrL46mgAmTywdM
	fzBhDweNrkPGMBD1JE8hq6Ta9kcDz659oYkhaCtAtf8hv5AtMLunnoETEP1SVo370+I=
X-Gm-Gg: ASbGncv+2dIq4gU/gFyP1Ei36WUAI5mN0wI2AcqiDWihGMl5jdsXQNsRkKv9SW/58mH
	IDld6fLZrJVivnwUV9ALivOGEMNopw9ITcL04J7yxL/v9iuGXAUX5rLs6XrohH8yj6YX61LXTuG
	PPc7A47fCcjUubouxSL+tI4QQP/pGXve4Cznk0j67b7dheil8i9gIMBOCU+rOtVfiFfDCO3VPbn
	mqjT6Yqh3alGrKrCMKn/G8yI+sJ9IeWCQxzJiKNpjcOv8PmWhbCHqfCrnxXA6lHTG7mPc9U2+PL
	C9t7qXRrAEs1dsji9M7wkCze7ImGlGB0dBYW0ih8f886cbXQsCSrJYLdO5da9Ntt2NKsQ0b6fzo
	rZe9UdMQlZpsXpqvaABuSmGAwD8ojBK8OxFtSEje3R3Q+7BIPESVrus3577IsT9oMMFOYUQ3Ac4
	yqVMnIZygeQXP9+RB2wKSJLePt
X-Google-Smtp-Source: AGHT+IGZ9Bv9q7KwM+e5SZ4p5HtmWokaa1yTavfU4ti4TiXgkGO4Jv4+Imx8qhXiY7NKxrpPJpXoKw==
X-Received: by 2002:a05:690c:93:b0:710:f46d:cec0 with SMTP id 00721157ae682-719b41459e7mr40440567b3.1.1753282028495;
        Wed, 23 Jul 2025 07:47:08 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:07 -0700 (PDT)
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
Subject: [PATCH v2 07/32] kho: add interfaces to unpreserve folios and physical memory ranges
Date: Wed, 23 Jul 2025 14:46:20 +0000
Message-ID: <20250723144649.1696299-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3dn7a5apnn4i3qp5o68pip8bua5i6rgk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A56440012
X-Rspamd-Server: rspam02
X-HE-Tag: 1753282029-901670
X-HE-Meta: U2FsdGVkX18xBx3PRvgzEF7FwBS9Solhuy7HHCOWSw4EsZ7DLyQS3kSIJQ0YATBHGpOVR5lB9RP72jhcvJIoRgZzWyJawn/l65Swo7ieCnY/x+I4Qg2Si2comKHabJzD6DmfzGDxur1rsZ8SgS8GLNOrgc+n/eSBDXOpxwgtv1Z8fhBjNNKg/TzmCV51VbePvbNhK6COTOMGkhIgYgmX+aZt+ph9K1q05ErVqF5wGMswgSnXS/6Z0CzSWKkRmtlkLRwTQyBTQHlFFRGSgUW5PtMYrPfHuPK1nc2A39+Bx5ToGuqrl5VLfG61KjzFo4ZwN7KivINRUETAbj2t2T2CKikGdSxMOdXW1hPiuMhQcEB/iEBgNVwKVuI0yA7YpD7HrREOzqikVelHYDM2Fc53CwjLVr30saRRlgKw3ykcJb6Z6JR4fvtLVDNtcofqbsgkExJJp7UpNuziVge24EkgNhigsgbGOwgLZXtPq1cuxyXKMWXiYaSU89wpufEvn21BaihKpPlzGuMaweZMAraD3jOLG1jGZY/+d+sII+paaY5fY15mtIU4QeSGc38RYypMp0FaLKbvqeKDiGi3uXbIEWS7NYlP7j7mkk94iGFPf/y7BOOUvPSlKi4yUwCzNJj2X665zpjvtoqqASGo1/x0EZKklNipYjGRSTDo0wUxBTq/wJiDguQDUP3VXqk10+j0Lz6OKaeBiD6Jp1ukkx2tjSgIpuYW5amd4lfKsob3oMme0myzdc26kO0ntCYrMeKTvnKeg92FyrH4ccwsOixw7g7R/V1ur+gCeVYnO0lHPxVAbDSkVVfHG0IGGD93w1ViqYFPR8KI1S2UJQXcC0MWneVHL+j3z/n38d/wdFpC/CUBPMtxlbme5dyQx8yDohp3Ym4zhf7xZ/y4qK25DAa8bedkOtabrJ8CkL58cEc8hKvEbTQA4TMHcu1bY58DB3mDAiAN45cx8JcWdbkX2+X
 2F8whQsE
 A5yvK/ccfxOXHLWmik/ZBpc36nkCO/TNz8Z2/DnoLHqXtSgZxoH7OR378iUEhUw3bDrhDMCTQaQuXxpdxwmDRVFqqWGuY18eHDrxIhMuXZYbbkcj1FaF2/ZZSDY7aWGhK4yBy/07lQLRtS7UsR5oppb0/wPuumB0Wn6yqgIAldzE4UOJlIgk5RxOM06yC7wo4aYBQe/sfRSCKhkKBfsR6OcrpR5xaCe6+m5o2X6egTQOqnuO/l0uKaa2TSGn7+Oazd/rFj/R3O+2ogNijqyMbewFs3KwtWBEsOFhFHj1QPFIiEoB/Ek5GDqAKykJeaiJ04pZS9NL4W4EEC6l0RuxdOXih9dZwprP9lLZBkKydtm+1Yj/evAYusEVgTDUj1Licd8pRdF2Al+Qkpzytg1WqRo4+wgQtkJk3HR3wSk2PtwXlCvNl3VeFCOLoMFpCVH0zQYkf7K1Q0nG4EHEkhibk9CYbeK6cRbRJJ3JigUugDp9cAk4T5H8s7lFLo+LrM83dYdw60nFCUiBjNOVKdStcmAgroaD4iOY9Gfzq+/7Le+P2jQ0=
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
index 30d673f7f68a..26ad926912a7 100644
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
2.50.0.727.gbf7dc18ff4-goog


