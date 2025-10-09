Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F79CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389458E0098; Thu,  9 Oct 2025 11:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311C28E0008; Thu,  9 Oct 2025 11:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B31C8E0098; Thu,  9 Oct 2025 11:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02AAA8E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:54:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 956E988375
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:54:23 +0000 (UTC)
X-FDA: 83979022806.18.5852E13
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0E66C000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:54:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fAsaWlUD;
	spf=pass (imf10.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760025261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3jD6Srgk8c77Z/UJ+8ukqBQAN6er5a/zSDavY8QJGM=;
	b=dsDouudEp5Ly9NBNPaxLbNYVF/hXbRFU+NTgvlClbz54EGkHnrd8bAtYZeScveVuvgGJ8l
	iUaPTN2Pxk3qpynxtOcTU+5PVlV3dsJLmIFIK8oI+BA+mkJYqejPaMwDysNQybuyHzuc2X
	5V34Ns21VUKx8O5pHLEoarshXK+nitc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760025261; a=rsa-sha256;
	cv=none;
	b=kHH2X5PSunR4UF82Hep8q/rwphi90H/OkiAfyyWk14Sk3pPU50yjIw6Dgj6n0wSCEgtGNt
	kX9L9t2p5U0gju3fWUpvmCKMeSZWbRFZ5nVXnkbAJUTPA2nMra1ZaNI5vn8l5cDuuxH5BD
	396+xph8d4EbckZqyn/d1jl1oiebSt8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fAsaWlUD;
	spf=pass (imf10.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-362e291924aso7235681fa.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760025260; x=1760630060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3jD6Srgk8c77Z/UJ+8ukqBQAN6er5a/zSDavY8QJGM=;
        b=fAsaWlUDv5rzcu98sxgGAkXmMR4RP0G67ZG6Bbb/SXxVixWj7i9ki93roA6a9c3Kbx
         +eW0JqYQFPpoX8JO0LW5cYkemBJ2mP6DEj8h5f8VUlxH/iJHKM++rs7YkmdiNp1MaWp1
         w0MUUSydQYLrRBFALNHfuimDnEXgdW5NKmLl+b22Idf9JkS5Fj0F/risW/RF8e4UKmzm
         1MlaP49Q74ktC27kE5Ka5YLb6jpvAMhRPbkjMhTV7SwMiUjumx06769jksiHR/FRICsW
         S3wEflH4RwD5iOhrZf/YhlJRUBzdEIz3iOe9UC88wJl9CTmoTjb3FR2xuYbpZO9PYqJ7
         hUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760025260; x=1760630060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3jD6Srgk8c77Z/UJ+8ukqBQAN6er5a/zSDavY8QJGM=;
        b=YovV68MV3IcJyz/djzOnw0KXjz+7QybksiRaK++JFC3fvAFwYUjMVlAucnX7fDssGD
         1fZOGnuohJQHcYV/SmeU/n6maQoHrhYxKaXghc7DrYACbwayP/IFLohLnksiV7zyI/vp
         N9LHLjTp9L1oA+fNSo6fAlktwxhFz/QkQ2WEyYtRdAeiL3Sy/Egv6OoMYpvvVhFWkx2i
         b1AbhZ+wUC4HAQ8q4aPHo/QLaoyPl/8DZgvHZeJG9yYC/CQFgiwj/D3+yrMsriTS68bG
         0akVXxEeP3V2xOtksIK53mfdst4nE6MDPXqyPNX1z74oUBYHLvWmYEkhL3XM2s0AZtdI
         h/1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgYLqTad88FPg/8KUxCISKSvjXNpMKzbkwFo7HOAst9SkCZ6lW57IuQS8vmQJibWUtXg0ojCExpw==@kvack.org
X-Gm-Message-State: AOJu0YyuKIi6vxT2EGNJomWSkQN6yGuULaUUY4hIuatvlLpDKnu7kmoP
	zRouSpb7GS8k6A5Csq9pJrJfoCJZspkL9DDIUFAbiy3G+bhM7k4K5nmm
X-Gm-Gg: ASbGnct+zqS/DGmcGcH8cHZk8V+qr91wK2hS5Wr5QvjA2yuoGn5yIyGXhjM0qL3lhc8
	0B084bF1MjIWFkXbW6oHHN+AANCW4QjuVIOIhbTxOeR80RjBu7GQ/7FxTXqujDXwf4pH+4tbtam
	5f5kxy1yvC/9C9rkK0s0P8BF5JTvdzqqiC2pGa9edO8Tlophp0hQsC361wvGpmV4aM4zdo0il5Q
	ChbbcKN/VELOVGDD9jV2WMeP7fnPjm5BOgawEuCAGShcYzbPCtZIRjgz/alETNAE+fABhZKCAZv
	RXdrNp/6o1dD85MOL590gUGYTSbl8c8hcpXvGc3Gv3icI97gAGVQ2zafSToJLpxDhc/Q18w3euY
	OxIWtZ1QbSLr5SMVMKetWe61jVeggdPpDlcCCEdYHZzCYwzpB6g6bmms3OKeLUda8eW8AUl4XEw
	==
X-Google-Smtp-Source: AGHT+IEw+s+w6dsCMs+FyUWCNhIcM01oy6wj30FcD6bZDLMLaZbzcGhDGKpIi8Zl/WSuXa35QvXIUw==
X-Received: by 2002:a05:651c:2210:b0:373:a537:6a19 with SMTP id 38308e7fff4ca-37609cf869emr22052341fa.2.1760025259655;
        Thu, 09 Oct 2025 08:54:19 -0700 (PDT)
Received: from fedora (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-375f3bcd2a8sm29499831fa.55.2025.10.09.08.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 08:54:19 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	bhe@redhat.com
Cc: christophe.leroy@csgroup.eu,
	ritesh.list@gmail.com,
	snovitoll@gmail.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] kasan: cleanup of kasan_enabled() checks
Date: Thu,  9 Oct 2025 20:54:03 +0500
Message-ID: <20251009155403.1379150-3-snovitoll@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155403.1379150-1-snovitoll@gmail.com>
References: <20251009155403.1379150-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: j3zkg3adnidi7norcs9f6xfzybjff78a
X-Rspam-User: 
X-Rspamd-Queue-Id: A0E66C000D
X-HE-Tag: 1760025261-81366
X-HE-Meta: U2FsdGVkX19ebtQCNFGt0dI11BGIbjj81LqjgX20Lk3bwl2meQFyuMbcJC1iozn8W4XwRSDBojYrIqg3MfxEnT4BvG6c6UFU2dXcd80T1qE6vBl7V0PJVsDdnsL09L2ext48qNQ5aGUxufv4AFIvIeEHYJwQo+sd9D7inJ3jW/Xwwr1aq+PgrsRzzqNeecVVdndmz2T/Skgb7aiJDYIgaHMOj+2TsOAx+3c6Qw1bANTeE7DAt91H6SxsQkFvyEJnR9qPxFSwcIQuhsF3kQi4wtrqGzX7vpLhRZyxrh7enGwdSQTK1IKjZt9b0BYIgpyjTo1rEV9xHPMcG7xBUk8U9Ba+jmz5lsK0wtJKcSSS3Q0+Efmv0ghJP2WtOyrhYwRat2MuM7wz1Y2kkjaJX9Atm/PbrQtch2JUa8MsLIA3gXI4eGysjmwtn3rcDWWdV745oDU21I78RFOaU+TZeqqykbAm4R+82pJOxYz1Qa9mMivxJZb4+j94LA8aOaQ4N+h/mK+w0EKbrx+mLDehPPSP2bcZbX3pnPIn1LCePwSdswSj7nAAgemTU4loX83BUQuVW5RGO62/pjx1nfAZfq6p0+1ePpykyfR+LTthOVeV6yzU/uHauPmrIoNxxoTgrrniD2+z6b8sJ1NY5iUST4yLcFqZ47lyXMYdrENRhi4vsmjIw25pXHEZHGP9KHw25gfTKc5Sx8gfTfuE6CX2Mcu3cXH3HKycUZ49byo4gVa3/zSYl1RS1YyVQPAHhizkFIfPp+S3AKc6ESym16GbCnYDI5ZR0+iCHh+EQcN4G4ddZamZv51uEnFx7RPE0sDWLQt9eaJKP2jYn+SvasWVPxW5v0Qr2QnbfBUYYhUVT99UMIpB/Qyec/dmMkd5HrQGcVSG9ugfav8QHiRaJ2fCeEWJIQbukleQ5BkDG6vLhv2CRZN6gpOH9p0kP9aMPjICUZQXrVXAEscOx5I5nFnN70U
 Vgg+L/bE
 tNrcsy7xj9YYZIdteNdv/Qn6kyJBuZI5yuZmJe6/xBHAl3zLAd/t/DA0yv/MhNqHwZGPBOBeCkRaXWEwZIBb2s6rsn3nO98kwmiVl2jv7pL3btii9DfhQn41b1kwUeVP7keZmCnuB7oOnaqVfmyVJji8l5fuLw1V9wtFPzdHOs8OqPZjA1zIZio2NNmciOYxT17cQmz/wP4icnhVW6dW40OKmSitQ2bstJm3Kgc3+UaaSI0+TigwWF0EzFWN5XwubB7uiks5TqBrFXJMg1+qvfjO+xWjvKbVLm4hS2/jbRalyKm2rzEG5uCp36gu2/b5C8iJQ3pd2cibvWKmU8XpPXVFcT3TMvWVqWN2crqXp/KSQhBby+jwZ7zkstFqabVeVlA/ZUMEMyL3fjiuT4XWkDP0Scd9JoxkvHE/csMA5qSQsLPWi0il5Dhps50dgAVUeZX0tP+khJ3VOGRMcmk/De/WbAJZsrowxWVUQwzC8F/DFCgZLBwQi+lleoeJc/DdugAHVBJGiJRJAOtQGun46AfVeDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deduplication of kasan_enabled() checks which are already used by callers.

* Altered functions:

check_page_allocation
	Delete the check because callers have it already in __wrappers in
	include/linux/kasan.h:
		__kasan_kfree_large
		__kasan_mempool_poison_pages
		__kasan_mempool_poison_object

kasan_populate_vmalloc, kasan_release_vmalloc
	Add __wrappers in include/linux/kasan.h.
	They are called externally in mm/vmalloc.c.

__kasan_unpoison_vmalloc, __kasan_poison_vmalloc
	Delete checks because there're already kasan_enabled() checks
	in respective __wrappers in include/linux/kasan.h.

release_free_meta -- Delete the check because the higher caller path
	has it already. See the stack trace:

	__kasan_slab_free -- has the check already
	__kasan_mempool_poison_object -- has the check already
		poison_slab_object
			kasan_save_free_info
				release_free_meta
					kasan_enabled() -- Delete here

Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 include/linux/kasan.h | 20 ++++++++++++++++++--
 mm/kasan/common.c     |  3 ---
 mm/kasan/generic.c    |  3 ---
 mm/kasan/shadow.c     | 20 ++++----------------
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index d12e1a5f5a9..f335c1d7b61 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -571,11 +571,27 @@ static inline void kasan_init_hw_tags(void) { }
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
 void kasan_populate_early_vm_area_shadow(void *start, unsigned long size);
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
-void kasan_release_vmalloc(unsigned long start, unsigned long end,
+int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask);
+static inline int kasan_populate_vmalloc(unsigned long addr,
+					 unsigned long size, gfp_t gfp_mask)
+{
+	if (kasan_enabled())
+		return __kasan_populate_vmalloc(addr, size, gfp_mask);
+	return 0;
+}
+void __kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
 			   unsigned long flags);
+static inline void kasan_release_vmalloc(unsigned long start, unsigned long end,
+			   unsigned long free_region_start,
+			   unsigned long free_region_end,
+			   unsigned long flags)
+{
+	if (kasan_enabled())
+		return __kasan_release_vmalloc(start, end, free_region_start,
+					 free_region_end, flags);
+}
 
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index d4c14359fea..22e5d67ff06 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -305,9 +305,6 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 
 static inline bool check_page_allocation(void *ptr, unsigned long ip)
 {
-	if (!kasan_enabled())
-		return false;
-
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 516b49accc4..2b8e73f5f6a 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -506,9 +506,6 @@ static void release_alloc_meta(struct kasan_alloc_meta *meta)
 
 static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
-	if (!kasan_enabled())
-		return;
-
 	/* Check if free meta is valid. */
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
 		return;
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 5d2a876035d..cf842b620a2 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -354,7 +354,7 @@ static int ___alloc_pages_bulk(struct page **pages, int nr_pages, gfp_t gfp_mask
 	return 0;
 }
 
-static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_t gfp_mask)
+static int __kasan_populate_vmalloc_do(unsigned long start, unsigned long end, gfp_t gfp_mask)
 {
 	unsigned long nr_pages, nr_total = PFN_UP(end - start);
 	struct vmalloc_populate_data data;
@@ -403,14 +403,11 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_
 	return ret;
 }
 
-int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
+int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
-	if (!kasan_enabled())
-		return 0;
-
 	if (!is_vmalloc_or_module_addr((void *)addr))
 		return 0;
 
@@ -432,7 +429,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t gfp_mas
 	shadow_start = PAGE_ALIGN_DOWN(shadow_start);
 	shadow_end = PAGE_ALIGN(shadow_end);
 
-	ret = __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_mask);
+	ret = __kasan_populate_vmalloc_do(shadow_start, shadow_end, gfp_mask);
 	if (ret)
 		return ret;
 
@@ -574,7 +571,7 @@ static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
  * pages entirely covered by the free region, we will not run in to any
  * trouble - any simultaneous allocations will be for disjoint regions.
  */
-void kasan_release_vmalloc(unsigned long start, unsigned long end,
+void __kasan_release_vmalloc(unsigned long start, unsigned long end,
 			   unsigned long free_region_start,
 			   unsigned long free_region_end,
 			   unsigned long flags)
@@ -583,9 +580,6 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 	unsigned long region_start, region_end;
 	unsigned long size;
 
-	if (!kasan_enabled())
-		return;
-
 	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
 	region_end = ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
@@ -634,9 +628,6 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
 	 */
 
-	if (!kasan_enabled())
-		return (void *)start;
-
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
@@ -659,9 +650,6 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
  */
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
-	if (!kasan_enabled())
-		return;
-
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
-- 
2.34.1


