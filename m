Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95483C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E6F6B009F; Thu, 17 Sep 2026 01:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F6A6B00A0; Thu, 17 Sep 2026 01:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865776B00A1; Thu, 17 Sep 2026 01:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65E156B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC875A49AF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:21 +0000 (UTC)
X-FDA: 85222128642.02.B15CC87
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 29D8240008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LOCwZIkt;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRHIBzX1Ph+VWLlGic49OjVgc6epG84F5iB9tVuXpJQ=;
	b=diggG5+IVMd2CVEq8/Au0RFtjqkX0Z/SJVR0xq+e4R0DvcgbO8ouxr93C9DjWPJu3pbz/l
	5LdzWcCRBldgG5uA70V6Na55kIr8WxFkIML4JWwFIPEyPYiUlahLiy2iwky4R7re7KkQz+
	xvrpovS0gzbVrhE0vlZE2YGpMdhAW/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623020;
	b=OEb5AEYT2HFciq4IQoX6vI+MA5lIDHGovHEhdw0R4xdCiM1/RXmGLfxQHky5J0S7C88V/i
	0rmo7u7gJQjGL4pQh155B/M9TLUwRIiTZhO4eswLyvQR/kvvj7hlL6YN1BHAEY5iABWIw5
	PJ7XEv9K1cd5xrufLVVeanDVv5nMWaQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LOCwZIkt;
	spf=pass (imf17.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b350c6920so379070a91.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623019; x=1790227819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRHIBzX1Ph+VWLlGic49OjVgc6epG84F5iB9tVuXpJQ=;
        b=LOCwZIktUFHfrpQPSfJF1ClbMzC47mFgdNU5zcNoiEBs+QJW9dRw2C0SuN8LKuG7of
         NXFHZgJ42vAyHvM86eiYJdM837mVvDNWOzbtLnt0QzkGEs4Y3fTHsOaXAZu9F9HCg0Ia
         ZOp/0kVFrwfVS7AMmy5YGG3w4kEhaEw2yhZDsVxgov9PkrfqTke2YYY+ineaY9TnuHym
         vpJ6bZAkO+ynltX2UGZYEUQbl38Kl5QtSzGONDQ4ejNmQs/L9cxRwMbDi1rbKwb6VyXV
         +iILmCzBzGXL5PMcq9yFjXW6lZzIQHtKIhNNlafSp6vuae1Ld0k+vMWJ0zRZ0bBUo1iN
         34gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623019; x=1790227819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRHIBzX1Ph+VWLlGic49OjVgc6epG84F5iB9tVuXpJQ=;
        b=PmjGUFxgFAnwrWNJC4T2W7Mw6OnZfboztNXWhEeA2nudie8VJarhyAexh+eNkK8f2M
         q7TGg0i2V/gUEFsDQ/rGcLb/TKtj2BYY9cnrD/02ZAWYqpbsDxVQhrAqxHotsYqvODYA
         0AYC7gP8yU26//J+0wsM8ylnRFxXfVk5sfmVKKh5vub8EcJTvv/DXiiGuMvbw9rfYF4G
         pJRxaF2FPNxx85PO+M8UPIllEs5WHbuTU2mSQS3Sgid72F/c/wYeuxdRFSt737JC1l/F
         ViLpLopATg47m2pX3gJ/vlygi3NihED+TuBI9fdrQZUCLJU27J8nJMqWAn+jj5JPHkdm
         IYFA==
X-Forwarded-Encrypted: i=1; AKwUvBwXljq1Sr3O3aoGA4HvGlGMqgfRM/bD0EHeuYZIoegtyLS/6Ug/UJEbVCRwxzRDOsNRBZvjrsoO9w==@kvack.org
X-Gm-Message-State: AFuF++lwfSIlauu1CACxLLB3g48ta/fNUzb/9NxArwQWe64vGQg3euP2
	R17Vw+DXq/80RkXTEFy085eY/s9iWZRWb2wgfxs3kHQHzLJCXFUzd+TG
X-Gm-Gg: AYBFou1q4EM76irvBs1JWjy8LOQ9XBVAwgQQaJYIDbCinNT/pyFbJHcwsd40ytN7UoQ
	3T19K8bxsASuR8UChGGVgmsx28P2yjo6VuhaoqWo6RlhWC/JaIyfWL9YfkVeT9TncCIVGm0uq7F
	8BcTjl5FmJnYRW6YEUjVrr1bBpOTrkvWpGdKFhwj44fyURy+vtiuKubDXBVWi3jf1Be6Jd8sJAf
	KmQHWTk6xPXiNsN2OZVxWUDNRklwzoqqi1SerLPpyVemh6nrvyi8TX8WjyV0FeSI0w2Zzk0zh4+
	Fu84q3oNG+zQ2hFU0GcSA4L2CiaAmEN/YM6034nOuYhjFCPhx1XZR8P2zi1XcnrlwIRSNFowwYd
	gdjemLjB8INfTCyazLd1FXc5mHVo+zS9QB62SFFlOHJKqmIhs8FuHskuugmVKsAtjccC93ZCEtH
	DGc27t35sWrXS5O6Ualhp6LP+KLZMB+5nZtEFtoQMWDZ5958s8NNlFVJ4/eui8rr74sL72PZc67
	HWxlkyWvDa46ku0HQfURnuAYSJWFcJkpI4RiQ==
X-Received: by 2002:a17:90a:d644:b0:39e:288:80c9 with SMTP id 98e67ed59e1d1-39e1e4d3fd1mr12367022a91.19.1789623018896;
        Wed, 16 Sep 2026 22:30:18 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:18 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v8 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Date: Thu, 17 Sep 2026 13:29:28 +0800
Message-Id: <20260917052933.188679-6-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29D8240008
X-Stat-Signature: j17bhqybrx8ej3f95sx6tra3h1runj5f
X-Rspam-User: 
X-HE-Tag: 1789623019-89552
X-HE-Meta: U2FsdGVkX19g3Nbxz6LjYoVGPhuei+RLD3gKgDumzpEjyZ+RKGYcNZsJppSFi6mGLV9ZLx9c/VGptFq8tnihk4YXEz3TCBuKSnGMz/Z5/ydReuzYlz2n65eb01wTWCeH4DpNSAw24RV5YG0Xq8f52hDn6Foi23U6owyn138lrseMtO4hqfyQUa/UvnB1wuEHCgXCd980UYLSHVb1Slbg/QI2y387RZbkTkkk4MJ5Y+jyGfyUvZs+fLwlDq4gkQK2Dt8+ZGEfZtAQivFXHa+0QaufPeeH3mEskKA1dDRWl4KJFLAkbtidz1NN/CiCAGCD/BOwPx0j0XkKRQ8OcE3lay/qyOB4JYHY5+lkzJh3OHUXRDbYYAZ5z5L62YGjdChnOy+SUApZo1inRKrQx8m22FgCfptG3euktdo2ilcD1FF8ThJUB81+gJ0j/+Q654L4u2GUOInJLHYNpaXAkNfHfbuB+9JMlyJYWzpzCdJ9KHuz2m9mns7JSPM1BtAAyHXx5HgHmwspxXeEs1Sk/8cqAisUaoTWimQWBBowCvELoMm4vAmneynMsI1lGO129W9uy42/OqLMpYij4oaUidK/wlIf3jk7CTgTBJmqw1sOjwbZ15g+2ytzFWCUy7YffC0PdnCaFDXJ2XvlHlkFMHp+QAVvS4w+yO9CHjUXjmQmslEHSWUk22ahFi9SOcDqxQ98iqSin3MTFSBb2+GtuOnUprPsWtJHfHYvf/a0NKcVRz3cn9GcltasV2hnugxpKsDKgxeWrqv/wXmYRVV6neyqF/V3OEHYiD5MSqEbuMzkyEFIY053PzePifJWqwPwuZFL7lQM5n7/x9nYiHgxSyxISn0SifGUdeNk6HG48nmocyi0GAWv7QmSkzjUBXVSwKs6tLGJE60SgnV6qR8F4h2OHUer7Ice233jqnI9eHvEotqt2fP2n4vBhpOICjN/091zmkuGLCPzK5dQQr2TgW9
 lg5lrO5A
 HW91B4+5Vw/EzcIVxx8g61b2T+GhSKxrA0/RYWdaioBWyZ6rLG9+mO3Ehr/R23G+eIjwG1Fvfau60arjhIiKPSL0JtsE/uLD9Hi2LKd6o9mcnAG7gv2X09QwOPE170QBV7GhvhUERptb33Nu4Bz2vlJhBwGx5DeExwzyQ9yBlGN2J4QMPqtSNaQvcKO4TK/VKiTmx3wqtI/110DpO66uCIqEZPUp4TRf59QqBbi6bmpBfMdxORm1vwDLjCec/knXWfI3Yacm3uC5UDTda9LodsKtNSSzsLEiLVq8vCfGkQfeKmlnFaxomZsgmtuA4vEEMGgiFx4QHoD9Kd6f7/Xvmc/fCQyQmhltCueYFga3tdx6TlqQ5DHdJkfRdrmIKZuuCBnxuWG/HZq32MJPUCNSsykxms3r1j7t89cG2VrheHNI5tpXiFlU5hNYPRdY04s/CJeY3o8wb37hUNekU6KpM/tIisRDMK9cnWQpx9mpjUeTeq9bPuFsDnJAQDdn1WpiPT/Fd5rn4+rzIomm7SH5TtOiMjGz0CaBXjrGFyrIMwp0b4uVQ5pCoyW9binv4kA/zmPxq5wqbEtH6B6oir5nkDSrs2qWt7jN8QYIU/hcoflyN6BtGXhCxP3H/tC6G1wbH5XyIzfWDoftNTTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

For CONT_PTE_SIZE-aligned ranges, return a mapping size that may cover
multiple CONT_PTE blocks, capped below PMD_SIZE. These sizes are vmalloc
mapping spans, not HugeTLB hstate sizes.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..4053b1ec1902e 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
 	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
+	 * capped below PMD_SIZE.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = round_down(size, CONT_PTE_SIZE);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


