Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6060FC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0356B0278; Tue,  1 Sep 2026 11:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798096B0279; Tue,  1 Sep 2026 11:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE116B027A; Tue,  1 Sep 2026 11:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 469956B0278
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:18:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45E6080480
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:41 +0000 (UTC)
X-FDA: 85165550442.05.8C9E3FA
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54EB418000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:18:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bmTf5nVc;
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EcnqIGbKAVtdyFI4AnAxKNCEqkoHQsPJ+QMG1G+XIUo=;
	b=222ggTUxHkoiaZF8lYEJo2/uWSRJChUBbMultJ5GXmIY458Glq71H3EHSlHEMKOlBCUfV0
	6yDphJGg7dc/giVqMjMv1a8saV6ua9efBa99P7RYXJFHAAqahwP1RdyBSJMbP8pIbJZvuU
	Qhsntslci7al7M4JjTFHVJG9sLoJHOg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275919;
	b=vkWAXNY/jE+5Ri2yJwtDGRnFKvUxbb+C2X3ZgXWN4mjeqwswn+XyKhn/JLsbcM4VcN6/Ac
	aNoDf9TJkBOCL+iP3L/tlbVnY86TSz6VvYS/ao2XbvWlzyjDJU6g3eNamIOr4VOHcpWsth
	qlHeoPv2gtT62586lfIA8bGjMnfUPDc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bmTf5nVc;
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-85457d780adso282474b3a.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788275918; x=1788880718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EcnqIGbKAVtdyFI4AnAxKNCEqkoHQsPJ+QMG1G+XIUo=;
        b=bmTf5nVcm3satu4XyD4qgtRL08XKAqC99TS8v2hOYTDiVxnfChabA3UCaTrBvWbItw
         2BNP8/ORdLyNrwfmDhCbcAHMoy85OmG5tOwK8xamp6hiVMH2+rfK2JgAOvGGMy7EadpF
         NVWnXVPIHqBFXjXABujcW4V1lyA4xo3zgRiQcEOe/i0m3hH57lWCvyrxO4KaoqRhK/8e
         +7qvuBb/Z0sgdtgynGbJ37eugrWaibz18gmgHI25sdrZh1u8U11Qu6V8y6JuGZtKrUjf
         ICYA11m3yF9W8PGR0Q+mk1yJqSufzAxVNYK334zNw7dsH+rN2rSSNRR4FH/IVyWkUnTh
         16RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788275918; x=1788880718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EcnqIGbKAVtdyFI4AnAxKNCEqkoHQsPJ+QMG1G+XIUo=;
        b=LypAspJF9B9gYBzoHlccOhQlEiZz1Fo6Y68Dx/aYWSiK/hIIm2lnL2w0iWzSv/esyX
         HHGuw5LdQCqiAaLTK14UC032WKUPuiwVma+gRB91aFNSuR/+G1khv7/Tj1sIJ3VQUE8G
         ZQMDh/XdVAfi2mVKFqHgJiBpgMufdMn4CljqlYU7XSjvQuYd+4qON1HeJ+qCiAqMg6hP
         i9ol1CYMfZIhK0Va8kcfPLypIac+tfmXYy+dYWoSkav0xyZtAsVj5foa1T/3FHI/vN7B
         SH9zIJIWH6+OG4I54rkcRbLVgyhK6iYfonQc/lWh7OUmRhNJ96qcPvLPzV8yXe2Im0Ub
         iH9A==
X-Forwarded-Encrypted: i=1; AHgh+RonhhYdc7tQBWgsZ8SCfQs2NFegm+4epu2BCLcCDmihhEGs4399Rihg0QyO7dvE/vKNOJ9OS2RPSA==@kvack.org
X-Gm-Message-State: AFuF++meBk4Z9C47vA1mXtx2RH9OTA/1CicGAGdXutm/smUofWGv1bWc
	yOkRfWioclNg1oXUr/MiiuR/pckHfSUkc/rrnVc5k+1yJO7Bwv+4pNqu
X-Gm-Gg: AR+sD12buZk/pjjdxkPwSuF6JwgZrcAB+5yFEtucfMkL2EU9epZnn74eoA2ei8oHyqo
	/1shdEaZGislGdjdJs0x4/jHtVmd7zwkC3cLBBpVrjuMu58oDap0eKTnwhnLg0IdxRFAHnGvZGs
	z6ow17qWM3aH6JNfbhIagwInd6I4FDhg3rpEuQxNTn74msMoxN4OYgzvGKzGt/qepn56WatWwpn
	2/I7OQBqEQoFKaRkRm55h97yL1JavCyP3/+E7KkDoXsacQ/cJx+mQ6wsvFpMmeXmvxp1y6iZnkb
	kYpacQxiNaVQRi5i7qgZ42SbDHmNsltT2QQ6269aJM469xNtAhiFTD4N3fHP9vTEY/J0Jc5tGXo
	i+1mRKOsXybTO+/q52Hs+oWL0cL60JeKzROx+v4luNbMzSEDEug+7Bcp4WNoXFVNKWw6PfdqNG2
	ARBJQHOwyFzdgKLcScdnMfx0BqiCq50yTkmM5i739QBr3DjAUxO3mRG78oGhxi+Xm7mdAcULOzT
	jbITFXNJtsb6/av7Hubc6P77W6QkRIHmUFs
X-Received: by 2002:a05:6a20:7f82:b0:3bf:b228:10b4 with SMTP id adf61e73a8af0-3d26795f2e7mr31819840637.2.1788275917973;
        Tue, 01 Sep 2026 08:18:37 -0700 (PDT)
Received: from o6.lan ([240e:391:ed0:47d0::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f33a0sm89911b3a.9.2026.09.01.08.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:18:37 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	usama.arif@linux.dev,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	kas@kernel.org,
	rppt@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Date: Tue,  1 Sep 2026 23:18:16 +0800
Message-ID: <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54EB418000F
X-Stat-Signature: a8dthnc1a9am78u4o3jkiikjnmjmd86x
X-HE-Tag: 1788275919-933285
X-HE-Meta: U2FsdGVkX192OfM8x466GSxtQidJn83VYZJm8280RJRCGMIK4sYII9+m9cBcAS1zSkGU/n3Q97ZpYJviICE1/D1NH7a7KRKekRbGUncVFQUKtNvWIG/eZmW9badWq0m2rpWkvPQm4NKnkTAFHypmaR2aqH9kpoR552u+h0073QDhcrKWL90XEG1SbIYm/HONIubVEyy6ubRiKFEvHStRxHy2W0Em/C8kzS2fouWxqfZ6RpKfN0K9XOS1614sq19nXE17523mrCrXcvj8YhVsKqmJl0af1ZEySfDAdNJYGwQQkXYvxDXUyInciikjuHyJJezT7HzyCDqgiU8wSUKjpOam1h1bEpxXRq71CSg59I/e1XtnT+ilUD1cX73PJq2zN1n66vjrW6rY0VZ9m8jTSqcJNETEvg4X4ZkUGg7O4PDa7ttPodwyF11cRLB6pK0lSMj1ZDzIrLVJcJYadpE1l7l/lrxdRWIuXcwxLjTWv5Wc7Us7RX0xW8kvHkeZ7IGjSlVgumJuHPWp94XMZ+3rvwuFH466KELmIx+5spQi28F+IU7jTSehBycPYyrtocyC4sw/8Gm76NVc0VVMwX/NKGDAQNV8LfSo562IcsaeFeNlxUZCGmE1p3dijXEbqo9B7Wyz4rbZtvwEKcBpM037oQp74gzJJggbbmEmvseZ41sb5/8zM+N8GZ7IKw0J0A9PiLDENlP54v9ALNAcu2kp/RUW3BaTwpLur+Fa/zfjNVxKOSg/D6L45UqW9Tq9c6ec3d9GUT36W5vrHWTpS1hObyBb7j7yT82Q5CSfE/1m0kajX0eIBcB5koiRNq3jJRzWzmCXJLIMXdvovSNhzjbKtR4l2qNRxy1j+UsqBeJumh1OQGQqizebTEHORH19bD+ZsnjKU6iMKD3aUt7xw3P2tO9JKL7L1X8nTpxF1ZipYa6gfU3K3yWSDMe9EGzWM92L4E+ssQLNZpI2wdTtqJJ
 wdL7xq0V
 13SoTDXwP9PLjlNNUSBX5pxlNz7AKl8JD1kaqUTvGCQj6qWHGa9VDGcyJByxtRVaJ1krhIsU9rM1nX91RrdNIfnx7RQmmHKx65i+p66ftOmhIJ+7MbeVo1YlEXUYhLuyLNTXfs9tshC9fPRN9pxfNRQDuM7VB1e9YIu/HGSSPfHU5TTcOHMW0Ir68q/mYs36LwP89mPbiJeVKPSj5iSbNVddlAk54p9j1X26deZDoqXO4WhKFsYgWlCQvdqyFpT5eKa1i8EOTvB7gGOEJqD5Avaj7bS1pIoHaq9yWkIsDV4RtseLhUk4TFHNlk8/o0ocuo6Pvto1Y80/Ct9Fq4pkjFQdnxYpgSPNMriErUDU2X2BNdQLxlKc7czfCx4jREbyfWYbR3WcPI7gXIGKoiABpdTMyI7yTvphx8V2Uj5uNeIWXn6n+rl6XYjis2eFE44++VUNOrADcpjDGj6aet9rSlaENpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out [1], kernel bugs have
ended up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the folio read-only in the direct map
turns such writes into faults instead of silent zero-page corruption.

Add a page-based helper consistent with the existing direct-map interfaces.
Handle TLB invalidation in the architecture implementation; unsupported
architectures retain their current behavior.

Protect the folio after initialization. Skip highmem folios, which have no
permanent direct-map mapping.

Inspired by Jann Horn's read-only zero page work [1] and follow-up
discussion [3] with Yang Shi.

Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49@google.com [1]
Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org [2]
Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com [3]

Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/set_memory.h | 17 +++++++++++++++++
 mm/huge_memory.c           | 13 ++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3fe293cfed8c..ed9ce04b18a1 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
 #endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
+#ifndef set_direct_map_ro
+/**
+ * set_direct_map_ro - make a direct-map range read-only
+ * @page: first page in the direct-map range
+ * @nr: number of pages in the range
+ *
+ * Make the direct-map range starting at @page read-only and invalidate stale
+ * writable translations before returning.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static inline int set_direct_map_ro(struct page *page, unsigned int nr)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_X86_64
 int set_mce_nospec(unsigned long pfn);
 int clear_mce_nospec(unsigned long pfn);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..742283b36d74 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -42,6 +42,7 @@
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
 #include <linux/cleanup.h>
+#include <linux/set_memory.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
 	huge_zero_folio = alloc_huge_zero_folio();
 	if (!huge_zero_folio) {
 		pr_warn("Allocating persistent huge zero folio failed\n");
-	} else {
-		huge_zero_pfn = folio_pfn(huge_zero_folio);
-		count_vm_event(THP_ZERO_PAGE_ALLOC);
+		return 0;
 	}
+
+	huge_zero_pfn = folio_pfn(huge_zero_folio);
+	count_vm_event(THP_ZERO_PAGE_ALLOC);
+
+	/* Highmem folios have no permanent direct-map mapping to protect. */
+	if (!folio_test_highmem(huge_zero_folio))
+		set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_PMD_NR);
+
 	return 0;
 }
 
-- 
2.47.3


