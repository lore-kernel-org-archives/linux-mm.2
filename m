Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3D7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B508E0012; Mon, 15 Sep 2025 15:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338BF8E0010; Mon, 15 Sep 2025 15:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226EF8E0012; Mon, 15 Sep 2025 15:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 114508E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC64513BA49
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:25 +0000 (UTC)
X-FDA: 83892531450.09.DF0B6C1
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id B1ADFA0013
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vyt7KcZm;
	spf=pass (imf25.hostedemail.com: domain of 3dm7IaAQKCMEm2ksnvvnsl.jvtspu14-ttr2hjr.vyn@flex--fvdl.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dm7IaAQKCMEm2ksnvvnsl.jvtspu14-ttr2hjr.vyn@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCTw8mMhgOWN3pIIBb2gy+S0Zzj+AR1Jz+wSOMeCQlc=;
	b=qycq0/g8XD6Y+c9+ICewn7TZqTfKx+LnzkFKxGIKAAvBeZRm9fri5GsHgl+Yg0vvOC5iAr
	U1OQ3J29kQkrh6+pesiYRczVAtqdDaYT6TOji/POpSyUu8LwPE2+EWz/26Axh+kD1eoIRI
	r3Qbd9RW/SK6K7rQiYtcp4REGUBmA9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965943; a=rsa-sha256;
	cv=none;
	b=32xsvb1GeDUn9LMsSARXkLU9OAlFAgm8LSzqMadMuFdPWFGd17Rqc45+/80BS0MYp58r48
	o7ROC+D95kHF/HeBY05bH8ZX2B9VBGslZ5uG8H8qHuOlSfLmB3C+RXozPvzmJZMWaaq56m
	IGMgVkKkbWriNvPXDZRg5uVF4oSH+kg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vyt7KcZm;
	spf=pass (imf25.hostedemail.com: domain of 3dm7IaAQKCMEm2ksnvvnsl.jvtspu14-ttr2hjr.vyn@flex--fvdl.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dm7IaAQKCMEm2ksnvvnsl.jvtspu14-ttr2hjr.vyn@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-25bdf8126ceso82586265ad.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965942; x=1758570742; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eCTw8mMhgOWN3pIIBb2gy+S0Zzj+AR1Jz+wSOMeCQlc=;
        b=vyt7KcZmEb422bwzuzLKL6aLz8XGktm4IxomK1w5y3+v8GJIB9Cf5L5ECAmknRHSLK
         2FLhBTHdlV7ID48DvZTqJcTuyobib7o0VGUXBhOwta5emVOzq4zs3xLLpwB5StU61afZ
         Z3GwI63ZF/2trMA0SxzvGhL2YZGBHPvgKGWQIh0s6sJraCjTTiF63ZazckbxH9zN6RlC
         gGcdaOvtMq5RC5V9KmzMHBq5x2HgKc50bMzCvGB0veWjT7FFOlzn9aI4y8aA/4HSJCG7
         I6pZMh/C4Kpd6Cm8pn5jNrZ6el+sRSHQHZos14ZdKb6oWvcTtgTjI0zWxknwZgdT4/Uf
         787Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965942; x=1758570742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCTw8mMhgOWN3pIIBb2gy+S0Zzj+AR1Jz+wSOMeCQlc=;
        b=cJXYSgCyaXZlW1JtzFJJSfjQE5VxvVGQNZHoz1jcldOZuC5GQ3p5viPYgGyXfwEdje
         rKDNxZfOseuE1M9wBMisMgp64/EFNUWS+xX57HyDC2HHkyx3nWmz6og3eu2CaQY7OlZB
         T78iSkWXIfbJmMl/UNIkvvqKFyo1M61/cCs4L6kINtdo+T0p0qetR8W6pY5w2N8LmJm9
         Yjd7sq5LuYkrMU8mw79u44XV03poVMuQgs6/7aGBKuFM9J8TXGZBjnu0j2NGd3KHVqqs
         e40XgpcwK+RK9WIEPbRJkk1sKe9PQP5+a+ut+tjAj1Yk7FNNWme7ngO+8wYGxOjhaQe8
         Mfaw==
X-Forwarded-Encrypted: i=1; AJvYcCX9GfomGpyDfiUWdT8WK3ete2WfkfHJcDkWFxIVc1aGnXLtCCXQJV+ry5CxP/y0lHWoV9iTR1xaTA==@kvack.org
X-Gm-Message-State: AOJu0Yx7bsZFRDrN5hHkGEwecivekfuz3ldN20Id/MieiATo5L8CPfwu
	Lid7iUaEbgwQLE2E3jS9o/aEZJm0nrGvILKY+UR63fjdi3I7SLTPVM4eTh/BiFlQaKRkAtQfdw=
	=
X-Google-Smtp-Source: AGHT+IGswRfPvIKTnjtI+zMkN8y9+vmlGysmny2W+PeHbqNy2QPIL4i0nZkeiDjM4ghnJMXDuajKx5Z0
X-Received: from pjbpd11.prod.google.com ([2002:a17:90b:1dcb:b0:32e:73f6:ef02])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b0c:b0:250:411d:fa83
 with SMTP id d9443c01a7336-25d248c991amr137402865ad.15.1757965942499; Mon, 15
 Sep 2025 12:52:22 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:44 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-4-fvdl@google.com>
Subject: [RFC PATCH 03/12] mm/cma: add flags argument to init functions
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9juj7hhiinwknrfq7f1kigsd9i5upf74
X-Rspamd-Queue-Id: B1ADFA0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757965943-97145
X-HE-Meta: U2FsdGVkX1/kd2UYGSjbpDoBbFUL6C93g/5e8cfx0zSkXn+it4XZ6fBozHCeUrHoaAo9X/Yu/cdtnapRgMgYzWZKDBec+D6+KLPlJRC+U/3e78INCuN33imffZxJ2+CqD3F7ekKpyzJZiV+xoRnbmLE/2CSXvuH1OaWVjBF2YequaQxv4DuzDk6Ky/LQjH4zu21Wg51Fv8/pOH8TpU8NrCHKNLki9KXDukIuGbVqRZY4gZJvUHhhJYu0DinliKTIQA7bEQRMZVJ1qxsTNfJQoWuqABFp1KrLYmwvPdP58ho+HxYZLHEESYD5drWnCM6qEgtzMIFNGTJxr+QhOFaAKd2kePL5d5dAna6gu1CKAAff5ObBfrq+/6Fiu5T1nV4FWuYL6TsUO9o1/a956cV/Jft1I51+8JFiDlIp9FKC27uRZ5nLpJp2vjeUp5X3yTHwLQTMKlC5SZ1kVMXZDm/vwrQQhVCbGh7uPqdqxZQhTh2+E57O/eJEgWHVL/osJuC4jU7b9v4ohHQbNMZOleuaGk6yc5XalNYmycbOAMoHoQJi+6Hz08cHrljiEJDKrNlIc4GfTkQA/I2nRmBEbAmxlffshMjjHhTyp7jZYWL0ierkhE66FFzNiP27f8wrfCFY4mZnJp7tHwqUHwBcSEYfluW+mdVYdnEQ4ntCwzca26XHYKLCX1eBLwGFX93A3ZXsakyvasMR2vIDAT9tPdJPkHWz9pVkZA8fGgVyph74eSx1l+8Bom0epGXTXBQTfw/HWhkk+VLponpjXR6qAd291Dz0B+LCZrwm+V+pgj4F15s6UI4Ud/Fy33l9QRLApeaFW5O/gEbwQWhKIalxql3U9wnz1PjHKqpnRfS8OF9fyAX1z3hUq2bU5yPhU6x5SWMyznOyxojbgnPQEHW+br9+KyYTME5+3hWKlTxlfOVk1H8lR3xw+OP1WRtN3UBU5VpqbelJaO8PDXvn0b/+OFR
 7FqlVrt5
 m9ZhagZ37bUfbX8RV4yKpj1wn6KeVYc/fXtGkRY/eTKhFSbPwzaZ3o3JW3Y4hlqXPzGNtub+cas7oALpbjALyFlJ4u4o5/K+F4KBP2TQIhFtHZOhNDO0/KotW8l1x11oNP50zrbkdz9QACFPXQWDGXBh6JIyQFVfPAIRiK6aaxsd9lb3dSrK2Lm0XC72vh/cQ8WUFGglgJZUMJLfRFc0PMbxTFqBFs9ubkWhdvdxc2Dzyr4imgPUxZaKEJPPMQVkv43U146I0FYPkDp5IznJAx4jrG5qXMDIt4rn99UGTpwJAZnsPCRP27rvf7d3tL/Qo7xuX9/DL9PbfhFa+AwcGzNchlwBxzOhuFr1lYdd4idBENfH5k/zOdKNTy7uwGbAdV0mx8r0iNUAgmHaIXPr2s8g9uo95GNRTQssnhag+mPkR6ZQFMUgi6TYr57zu/m3IovehRNe3pC0mOZR19+NTHcJmjJ+iUKRiwst0NgrmH/Q4aJTEBcOxOhSUcWTmQOSahqbNJoa3Gf3aS3WvY60AwUq9nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a flags argument to the various CMA init functions, as
there will be a need to pass in more flags to control init
and runtime behavior other than just the current 'fixed'
argument.

Replace the fixed argument with a flags argument, and adapt
callers.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 arch/powerpc/kernel/fadump.c         |  2 +-
 arch/powerpc/kvm/book3s_hv_builtin.c |  2 +-
 drivers/s390/char/vmcp.c             |  2 +-
 include/linux/cma.h                  | 20 ++++++++++------
 kernel/dma/contiguous.c              | 10 ++++----
 mm/cma.c                             | 36 ++++++++++++++++++----------
 mm/hugetlb_cma.c                     |  2 +-
 7 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 5782e743fd27..a763419bd1bc 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -112,7 +112,7 @@ void __init fadump_cma_init(void)
 		return;
 	}
 
-	rc = cma_init_reserved_mem(base, size, 0, "fadump_cma", &fadump_cma);
+	rc = cma_init_reserved_mem(base, size, 0, 0, "fadump_cma", &fadump_cma);
 	if (rc) {
 		pr_err("Failed to init cma area for firmware-assisted dump,%d\n", rc);
 		/*
diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index fa0e3a22cac0..23dcb67e797a 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -95,7 +95,7 @@ void __init kvm_cma_reserve(void)
 			 (unsigned long)selected_size / SZ_1M);
 		align_size = HPT_ALIGN_PAGES << PAGE_SHIFT;
 		cma_declare_contiguous(0, selected_size, 0, align_size,
-			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, false, "kvm_cma",
+			KVM_CMA_CHUNK_ORDER - PAGE_SHIFT, 0, "kvm_cma",
 			&kvm_cma);
 	}
 }
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 69899bb86b3e..cd0c0edc496b 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -54,7 +54,7 @@ void __init vmcp_cma_reserve(void)
 {
 	if (!machine_is_vm())
 		return;
-	cma_declare_contiguous(0, vmcp_cma_size, 0, 0, 0, false, "vmcp", &vmcp_cma);
+	cma_declare_contiguous(0, vmcp_cma_size, 0, 0, 0, 0, "vmcp", &vmcp_cma);
 }
 
 static void vmcp_response_alloc(struct vmcp_session *session)
diff --git a/include/linux/cma.h b/include/linux/cma.h
index 5c3fdc5da908..ec48f2a11f1d 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -25,12 +25,16 @@ enum cma_flags {
 	__CMA_ZONES_VALID,
 	__CMA_ZONES_INVALID,
 	__CMA_ACTIVATED,
+	__CMA_FIXED,
 };
 
 #define CMA_RESERVE_PAGES_ON_ERROR	BIT(__CMA_RESERVE_PAGES_ON_ERROR)
 #define CMA_ZONES_VALID			BIT(__CMA_ZONES_VALID)
 #define CMA_ZONES_INVALID		BIT(__CMA_ZONES_INVALID)
 #define CMA_ACTIVATED			BIT(__CMA_ACTIVATED)
+#define CMA_FIXED			BIT(__CMA_FIXED)
+
+#define CMA_INIT_FLAGS (CMA_FIXED|CMA_RESERVE_PAGES_ON_ERROR)
 
 struct cma;
 
@@ -42,23 +46,25 @@ extern const char *cma_get_name(const struct cma *cma);
 extern int __init cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma,
-			int nid);
+			unsigned long flags, const char *name,
+			struct cma **res_cma, int nid);
 static inline int __init cma_declare_contiguous(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma)
+			unsigned long flags, const char *name,
+			struct cma **res_cma)
 {
 	return cma_declare_contiguous_nid(base, size, limit, alignment,
-			order_per_bit, fixed, name, res_cma, NUMA_NO_NODE);
+			order_per_bit, flags, name, res_cma, NUMA_NO_NODE);
 }
 extern int __init cma_declare_contiguous_multi(phys_addr_t size,
 			phys_addr_t align, unsigned int order_per_bit,
-			const char *name, struct cma **res_cma, int nid);
+			unsigned long flags, const char *name,
+			struct cma **res_cma, int nid);
 extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
-					const char *name,
-					struct cma **res_cma);
+					unsigned long flags,
+					const char *name, struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
 extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index d9b9dcba6ff7..7f2eed3b7cc5 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -175,7 +175,7 @@ static void __init dma_numa_cma_reserve(void)
 			cma = &dma_contiguous_pernuma_area[nid];
 			snprintf(name, sizeof(name), "pernuma%d", nid);
 			ret = cma_declare_contiguous_nid(0, pernuma_size_bytes, 0, 0,
-							 0, false, name, cma, nid);
+							 0, 0, name, cma, nid);
 			if (ret)
 				pr_warn("%s: reservation failed: err %d, node %d", __func__,
 					ret, nid);
@@ -185,7 +185,7 @@ static void __init dma_numa_cma_reserve(void)
 
 			cma = &dma_contiguous_numa_area[nid];
 			snprintf(name, sizeof(name), "numa%d", nid);
-			ret = cma_declare_contiguous_nid(0, numa_cma_size[nid], 0, 0, 0, false,
+			ret = cma_declare_contiguous_nid(0, numa_cma_size[nid], 0, 0, 0, 0,
 							 name, cma, nid);
 			if (ret)
 				pr_warn("%s: reservation failed: err %d, node %d", __func__,
@@ -279,7 +279,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 {
 	int ret;
 
-	ret = cma_declare_contiguous(base, size, limit, 0, 0, fixed,
+	ret = cma_declare_contiguous(base, size, limit, 0, 0,
+					fixed ? CMA_FIXED : 0,
 					"reserved", res_cma);
 	if (ret)
 		return ret;
@@ -478,7 +479,8 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 		return -EINVAL;
 	}
 
-	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
+	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, 0, rmem->name,
+				    &cma);
 	if (err) {
 		pr_err("Reserved memory: unable to setup CMA region\n");
 		return err;
diff --git a/mm/cma.c b/mm/cma.c
index 549d85b2e3a3..00d8d365f0b5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -35,6 +35,7 @@
 
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
+static DEFINE_MUTEX(cma_mutex);
 
 phys_addr_t cma_get_base(const struct cma *cma)
 {
@@ -215,7 +216,7 @@ void __init cma_reserve_pages_on_error(struct cma *cma)
 }
 
 static int __init cma_new_area(const char *name, phys_addr_t size,
-			       unsigned int order_per_bit,
+			       unsigned int order_per_bit, unsigned long flags,
 			       struct cma **res_cma)
 {
 	struct cma *cma;
@@ -239,6 +240,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
 
 	cma->available_count = cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
+	cma->flags = flags;
 	*res_cma = cma;
 	totalcma_pages += cma->count;
 
@@ -265,7 +267,7 @@ static void __init cma_drop_area(struct cma *cma)
  */
 int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 				 unsigned int order_per_bit,
-				 const char *name,
+				 unsigned long flags, const char *name,
 				 struct cma **res_cma)
 {
 	struct cma *cma;
@@ -288,7 +290,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;
 
-	ret = cma_new_area(name, size, order_per_bit, &cma);
+	ret = cma_new_area(name, size, order_per_bit, flags, &cma);
 	if (ret != 0)
 		return ret;
 
@@ -429,12 +431,18 @@ static phys_addr_t __init cma_alloc_mem(phys_addr_t base, phys_addr_t size,
 static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma,
-			int nid)
+			unsigned long flags, const char *name,
+			struct cma **res_cma, int nid)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
 	phys_addr_t base = *basep;
 	int ret;
+	bool fixed;
+
+	if (flags & ~CMA_INIT_FLAGS)
+		return -EINVAL;
+
+	fixed = (flags & CMA_FIXED);
 
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
 		__func__, &size, &base, &limit, &alignment);
@@ -503,7 +511,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 		kmemleak_ignore_phys(base);
 	}
 
-	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
+	ret = cma_init_reserved_mem(base, size, order_per_bit, flags,
+				    name, res_cma);
 	if (ret) {
 		memblock_phys_free(base, size);
 		return ret;
@@ -526,7 +535,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
  */
 int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 			phys_addr_t align, unsigned int order_per_bit,
-			const char *name, struct cma **res_cma, int nid)
+			unsigned long flags, const char *name,
+			struct cma **res_cma, int nid)
 {
 	phys_addr_t start = 0, end;
 	phys_addr_t size, sizesum, sizeleft;
@@ -543,7 +553,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 	 * First, try it the normal way, producing just one range.
 	 */
 	ret = __cma_declare_contiguous_nid(&start, total_size, 0, align,
-			order_per_bit, false, name, res_cma, nid);
+			order_per_bit, flags, name, res_cma, nid);
 	if (ret != -ENOMEM)
 		goto out;
 
@@ -567,7 +577,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 	sizesum = 0;
 	failed = NULL;
 
-	ret = cma_new_area(name, total_size, order_per_bit, &cma);
+	ret = cma_new_area(name, total_size, order_per_bit, flags, &cma);
 	if (ret != 0)
 		goto out;
 
@@ -716,7 +726,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
  * @limit: End address of the reserved memory (optional, 0 for any).
  * @alignment: Alignment for the CMA area, should be power of 2 or zero
  * @order_per_bit: Order of pages represented by one bit on bitmap.
- * @fixed: hint about where to place the reserved area
+ * @flags: flags controlling various aspects of the area
  * @name: The name of the area. See function cma_init_reserved_mem()
  * @res_cma: Pointer to store the created cma region.
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
@@ -732,13 +742,13 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 int __init cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma,
-			int nid)
+			unsigned long flags, const char *name,
+			struct cma **res_cma, int nid)
 {
 	int ret;
 
 	ret = __cma_declare_contiguous_nid(&base, size, limit, alignment,
-			order_per_bit, fixed, name, res_cma, nid);
+			order_per_bit, flags, name, res_cma, nid);
 	if (ret != 0)
 		pr_err("Failed to reserve %ld MiB\n",
 				(unsigned long)size / SZ_1M);
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f58ef4969e7a..71d0e9a048d4 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -221,7 +221,7 @@ void __init hugetlb_cma_reserve(int order)
 		 * huge page demotion.
 		 */
 		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
-					HUGETLB_PAGE_ORDER, name,
+					HUGETLB_PAGE_ORDER, 0, name,
 					&hugetlb_cma[nid], nid);
 		if (res) {
 			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
-- 
2.51.0.384.g4c02a37b29-goog


