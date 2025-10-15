Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D63CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7208E000F; Wed, 15 Oct 2025 01:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7D18E0003; Wed, 15 Oct 2025 01:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972458E000F; Wed, 15 Oct 2025 01:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78B658E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:31:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38F68C0B31
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:28 +0000 (UTC)
X-FDA: 83999225856.07.AE6E642
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6B7A140009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KRM+rDH2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760506286; a=rsa-sha256;
	cv=none;
	b=TZoY1oKJ3b/KUp4vbxeuGbbBqOuIgJ98BWVnME2FCJulY83BIAz8ApgsamZ5Mtiu/a8OTh
	OgeWUlBMkMCjtvQXeEaUoIuUKixlrQHFrWrvI6d47Zh9+/093ywdZpvLqzQyQS2Z7aeaf7
	PETC9E/7ZM7JOY/M8ehnGlM2w872xfE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KRM+rDH2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760506286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FX//HAu2ie94it+tD5SdOdZKlGHwRq6PauprKab6pa4=;
	b=TWqhcpaG3nywvJlNi0BD3JsbixrK3sLXoPhSwjBHukMrhXsqS0ILlJk+zqHPzPmSWlBEHh
	MXxuGlcf5sH16ZJEGzowIOZYJWsELDKtsYqffuiscVxy0ROJZDlGLSRDlp1bXdfdmol+Ga
	P0jttZ43631wL9xC/cBwvOKfbU7hEXg=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-79a7d439efbso77009736d6.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760506285; x=1761111085; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FX//HAu2ie94it+tD5SdOdZKlGHwRq6PauprKab6pa4=;
        b=KRM+rDH2UKq0VjohA5Vb8uht7tIcTk+KAdtwrFnX3obowusDIgG00rgWIHivnzEMC+
         w8Bs1w8U8RuLoN/8Youi3nW7SnSI1Jh5lLAZmqCITzVNr0ukOJ6SwE4aRsLfGX0DUr7Z
         mtCDY6o1eue3S0w6ZHIrKPt5w6ga5N2UXT/pukvooNisdTjhwA5As/lnUDjBd+UXGECp
         xFU2sRRopUbRJwKzV5PD8jbCQh7S+P6AGNnUiL+V8xL0ywo7veGqi1HNj4eKrXIc0XNc
         MFWhpUxu5JC30rFg4/4ErJMMNe1yWDzAkHPNFiu0/f6MPa7sj+n0Rbg6fkWlADUWeWxI
         bdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760506285; x=1761111085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FX//HAu2ie94it+tD5SdOdZKlGHwRq6PauprKab6pa4=;
        b=qoZbWNWG44XpFlbjwHaIFviX3LfRH1CKodp+uZPXYJ00DH4WdYOxgKVDCoKYJbsgqn
         /ADFZFBlfyjlStW/qOm3GLRMH4QKNePqmn8cuxfhWj49qx6CHr/SwSY0w3sdbkq/gwZb
         Hi+Q/WJdBFfIWHFH50OAfWwZ6MpE8VU5DHv5V1Cj0OL77VNmKTuEgrU1Jh+jE+LTMrHA
         suWuOtEITedIEvK1qVn5JXkUxLxD9ezK4Vxz0AnI/SJL5Wt3gwNa/9wexx+S22p3Wqjn
         AOUAJLFkskOA3Ifc6+fmc8cJ7V637YT46o2vbY9B1e66b8QFdFg5sCnNVR8pCiRtLmFf
         +0Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWLxq2gE0TJIDKJJ+kPs5tVjmWTMMYE7vBwdZfLvqWazrCHTpfsT6HR9Icfw5qYu9DMRrzS/ZFjQA==@kvack.org
X-Gm-Message-State: AOJu0YyEnzvNMPvcgxC98RzGLPG43sm/gNE0VYe6TqjzIT1tNLovIiiT
	66sWeDETLCEOf5YXEfsYet++OuMdjUcm31dctKQmCiftqlL48LbyCqx15nfFYxcoh0Q=
X-Gm-Gg: ASbGncvr1yLY0vmzqxW3tkLkBvsS2YQoV6btX6+hib6f/QU5H3VISsGUkx9/NZS+qaa
	bPzJu5B4mJN4B575ib0OFLFTz3Q/w7vbEXLSc/j/cpQRBPiowa4b2vJ5Oa9t2HfPlkVJpxcUBO3
	sX4JJmvEkZMghCi5MHy7ueIGAOmPHyKjVVTAeSwjg2IIsur9YIz7BpT7XufZvZ9mdi3cLpsJtv5
	SSjguyzpE1bcJZngnMUVbHlg0KpLP9+inpyDqEFj5ZV6P4pyrhCVXv4+BQ8HAFJ92XRwMOao3Jv
	5Vugt791AhZ5HmsYSC/Tm/QEPP9PYDNZmQbMdH7zToTcF4LvTowy3ntIcslVBRwZ5f7L+mNHZau
	jBd+iXne/Hrwu9jkZfNF+gZnywMFxFjV6QUNeSoXXd7emlKdIR8trd6Um4SnmhrXfB10Oxd/0Uw
	mXnLNc45mlGPMDsT7YVdD9gD6Q4OQVE5zYhb+Slwizk0kVm/7835TYBHGmymI=
X-Google-Smtp-Source: AGHT+IG4TVlyGj87gL4l3Cn5wFpTA6+9S0+DZSHD6GOiJNS/JWUuuuCXSPGMqGA/FDM8qzc6tZIhdg==
X-Received: by 2002:ac8:5a06:0:b0:4e8:85e8:8019 with SMTP id d75a77b69052e-4e885e8859amr10940541cf.78.1760506285490;
        Tue, 14 Oct 2025 22:31:25 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e881d01f5asm12572661cf.27.2025.10.14.22.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 22:31:25 -0700 (PDT)
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
Subject: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or preserved memory in scratch area
Date: Wed, 15 Oct 2025 01:31:20 -0400
Message-ID: <20251015053121.3978358-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ytr9s339prcqkqth8414nkomo1exex8
X-Rspamd-Queue-Id: 6B7A140009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760506286-764163
X-HE-Meta: U2FsdGVkX1+3eOw1qcIviBCDrSNAV1D9Ep5YMK/c/YsA5p5AEehnfvHye6sh9jyN3L4/D3G2f5inf430lOQIiL8IvucEeH9wjhJK5LMUK7asMvWvrS3vRYbyaa4PHoSuic+Ufzt5b9anKZS/VqTz9P01GOaFStCwdJoWUxprSAQx4kgXafklm2Xx0TcD0a+qbYs2mZH37N8dw0ib8yG11mxfYdefhMUXDHuZmO41O2fJdbC4MfKZGTQ1BCM881or8An3RHYFB8uJWNZw9jZi3D8cXcLwl/8h5SiotTnQjsMV5Hr5/l26wl0eAPBHTd51zhmFrcoYGWVEyIAT3vcQGmZL4vIKeMUKHoH4hBtPrTh35Im7cKZh/x+3SSM64HVcu7C6mNUc3XjjMeXTnUS6nm8HaZ6e1hnr3oM46aNBuKkpMuQWH+oMBgpEtzZqPXQecuK2TcXaXyr/zyP9BslqhiK8gJGi9vo+GgEpe5DADCv+h9xo/eRVbyFHwjlFE6oqrLo76JEhxwGXeqQpX1PaSZ5gFuZAnR/4QAOItS4KQ9cj7yKHWKu8yU04VuW80zGzvd5SC5y43mH++cA7euOVVJBt5wvFlo1ph+HVjBUbvmZB+Lk4/s0+QDzKLe+AEQhDBnget9pQ5f8yVZ6YwadBfPrgq4ucOgt4oqFCYTAj1bZQdf8BK9Wg1U9W3VcMtq68PhJg5YDoeVDZpwna/1UaFRu/Q772MIlkHPReuv7uEIAr+Dg8Sn3uIdwUEwpCX8+vl+5OTn/QCTVRxfWY2NApLtL6liy7O7So3KXnwt/zUJLSaATDJWAG0cgddsexoiQpulzwNY/PoTbFCpA49BPDYHpAdMVnOu7IXRpMkgmsP2F/24Luf/VJCxtdX3fiGDlObo6Sm2V749Om+twwdkeRC2LJwIJyGx2QtkItd6vEjLWRwCQkzHL4rc8jpc57M60xunAUpTFvmvsoJIP7JBj
 bHFacLn+
 RfxJhVrzQY4BXlpfCcIffrPA/+dkYocSmZh2BG0Yw11FYccII1+AlGwqwleZeXFdbOpEeF/oN4+WuSp9BqGD/tWl4G3dXgowqhfIqfULuTKERY/a1MCY3LNsH/AVNvVMLlE0WaK2H4pzHCacTWv+qGGGI6PjDtufhctduxr1FjKLZzmwekIQQholj8JUF3npltFQ+HMs4Un12P99LxmBQsBbDaUIMoPHC1VlZkrBXysL/x4YTauZXp/CHbsP+g7wkRGFvy0VvNbsWOlmq/+6b9/4j6PKEKWUOOnc6VBOBcaTZNB94asYHgWftb/MXAp89AguHuSu/P1+sB8lSJSt9ZfHvllQhYTLkA6ADCPaYMYartu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is invalid for KHO metadata or preserved memory regions to be located
within the KHO scratch area, as this area is overwritten when the next
kernel is loaded, and used early in boot by the next kernel. This can
lead to memory corruption.

Adds checks to kho_preserve_* and KHO's internal metadata allocators
(xa_load_or_alloc, new_chunk) to verify that the physical address of the
memory does not overlap with any defined scratch region. If an overlap
is detected, the operation will fail and a WARN_ON is triggered. To
avoid performance overhead in production kernels, these checks are
enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Kconfig                   | 15 ++++++++++
 kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
 kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
 kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
 4 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 522b9f74d605..d119f4f3f4b1 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
 	  Also, enables inspecting the KHO fdt trees with the debugfs binary
 	  blobs.
 
+config KEXEC_HANDOVER_DEBUG
+	bool "Enable Kexec Handover debug checks"
+	depends on KEXEC_HANDOVER_DEBUGFS
+	help
+	  This option enables extra sanity checks for the Kexec Handover
+	  subsystem.
+
+	  These checks verify that neither preserved memory regions nor KHO's
+	  internal metadata are allocated from within a KHO scratch area.
+	  An overlap can lead to memory corruption during a subsequent kexec
+	  operation.
+
+	  If an overlap is detected, the kernel will print a warning and the
+	  offending operation will fail. This should only be enabled for
+	  debugging purposes due to runtime overhead.
 endmenu
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5da21f1510cc..ef1e6f7a234b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
+		kfree(elm);
+		return ERR_PTR(-EINVAL);
+	}
+
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
 	if (xa_is_err(res))
 		res = ERR_PTR(xa_err(res));
@@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
 
 	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!chunk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE))) {
+		kfree(chunk);
+		return ERR_PTR(-EINVAL);
+	}
+
 	chunk->hdr.order = order;
 	if (cur_chunk)
 		KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
@@ -379,14 +390,17 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 	struct khoser_mem_chunk *chunk = NULL;
 	struct kho_mem_phys *physxa;
 	unsigned long order;
+	int ret = -ENOMEM;
 
 	xa_for_each(&kho_out->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
 		chunk = new_chunk(chunk, order);
-		if (!chunk)
+		if (IS_ERR(chunk)) {
+			ret = PTR_ERR(chunk);
 			goto err_free;
+		}
 
 		if (!first_chunk)
 			first_chunk = chunk;
@@ -396,8 +410,10 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 
 			if (chunk->hdr.num_elms == ARRAY_SIZE(chunk->bitmaps)) {
 				chunk = new_chunk(chunk, order);
-				if (!chunk)
+				if (IS_ERR(chunk)) {
+					ret = PTR_ERR(chunk);
 					goto err_free;
+				}
 			}
 
 			elm = &chunk->bitmaps[chunk->hdr.num_elms];
@@ -414,7 +430,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 
 err_free:
 	kho_mem_ser_free(first_chunk);
-	return -ENOMEM;
+	return ret;
 }
 
 static void __init deserialize_bitmap(unsigned int order,
@@ -737,6 +753,9 @@ int kho_preserve_folio(struct folio *folio)
 	const unsigned int order = folio_order(folio);
 	struct kho_mem_track *track = &kho_out.track;
 
+	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+		return -EINVAL;
+
 	return __kho_preserve_order(track, pfn, order);
 }
 EXPORT_SYMBOL_GPL(kho_preserve_folio);
@@ -784,6 +803,11 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 	unsigned long failed_pfn = 0;
 	int err = 0;
 
+	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
+					nr_pages << PAGE_SHIFT))) {
+		return -EINVAL;
+	}
+
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
index eb47f000887d..294d1d290142 100644
--- a/kernel/liveupdate/kexec_handover_debug.c
+++ b/kernel/liveupdate/kexec_handover_debug.c
@@ -214,3 +214,21 @@ __init int kho_debugfs_init(void)
 		return -ENOENT;
 	return 0;
 }
+
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	phys_addr_t scratch_start, scratch_end;
+	unsigned int i;
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size - 1;
+
+		if (phys <= scratch_end && (phys + size) > scratch_start)
+			return true;
+	}
+
+	return false;
+}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index b3fc1957affa..92798346fa5a 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -44,4 +44,13 @@ static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
 					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+#else
+static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
+
 #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
-- 
2.51.0.788.g6d19910ace-goog


