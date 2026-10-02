Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04BACA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB1A6B0096; Fri,  2 Oct 2026 05:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BA26B0098; Fri,  2 Oct 2026 05:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A866B0099; Fri,  2 Oct 2026 05:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642F66B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:10:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E08DD1603B5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:28 +0000 (UTC)
X-FDA: 85277115336.01.FB30251
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 16EBC120003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:10:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XLklXoAH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790932227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+brmQ4g6fgo5Njbplw2vRXkj0/5uqGmn7J2kABfLu4=;
	b=PJecPewk6D/FyKQnXjpNM72s6bc6wLgdEjxjSBe8TJqFz5Yh7yvfxetgXm9w9g4gbmL96Y
	sx9CFDl5WWy52wZmXq5lHL8tVncqvpc7M3zcMo9N2jcMvW3x4/s+5uj6x7888cMm1FO5V6
	TnHBC8XWXvXTptayzxHyKhVFTV4twoI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XLklXoAH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790932227;
	b=gvjQsryBCqXQoJNx+khr+Va4eEzmACzSaU5hWZOdUD608a0vsT5vWwfURkyrpkBYfp0FwD
	i5QhVeElDfXuIG2Kypmq95LuiyDfzMsA6QVusaFEWa15WHiSgQjOfU/T5MtK5rEetVEvtt
	qEBGhm5hPYMfQgGXBajyz20kRagznog=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2d747ee1f9bso36073045ad.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790932226; x=1791537026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K+brmQ4g6fgo5Njbplw2vRXkj0/5uqGmn7J2kABfLu4=;
        b=XLklXoAHhwx+ZUV7pp8RkhaOz7OBEejS651ezFcrBDhkJEYIj8UbFsSYhWnuLH55dD
         g90voLL2IrRGeIfSkvAgQqS67LMgkUE/Bdkw18Wc21kV3GyBpzbX3h1JbrNorC9apD/P
         U9LbprROhSY15hrrJrfOUCSKTPKNFrp9KXBUB5QwxJRWeBXdFajyW+0/OAfl3u9CoYcL
         NlC8tDNVpERkmxwSryNrf76FYFsyvJmr1sNSB3s4hGD9pwoYORR9vrSQifDlZMCPd6N4
         jn9MiEqTT/IMrsfz9vJkJdZh8rBHUUVmbJbOGfI+BbiSQglyVKT1L1CS8Bbv+z8EDEOa
         Y7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932226; x=1791537026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K+brmQ4g6fgo5Njbplw2vRXkj0/5uqGmn7J2kABfLu4=;
        b=ly0t7JyGcpCvFKCROKVzEjtqURfvea4RvpRcCRb3BAmx1SowtOZUnZmIpa9iYd/pNP
         XkPF0bdXdvYpfR6NT26DJ2UmvTjezPIU+Sk+v3HyKUTNGc/KvPaAPZ3Gc6Q+W9BbIkqo
         TD7P8/JBcTydvXqyOOvbPz/iBnq2G0M2FSLTuIabjQX9NfzhLZT23UhMaSNkqesLcowb
         zLGWBiANXATQhK8mWaONeJZAvRy6sYgMSXsTcfcGtqzl9EsAhA2/1Jp2XGHmOnsDxiwn
         wj0ACozsYXcJzHk4usQqyQBS6DBbyua+uduTA2SexE/etfGfjHacqYZbIvBYm+34OdbV
         pltw==
X-Forwarded-Encrypted: i=1; AKwUvBxxw8QL4h60jBUFmnVnkQroQ8ZEVrH9x2H0HTp8GluviTFlcS/MFtKld92gRrdMdTiJ+JBQRMoZPg==@kvack.org
X-Gm-Message-State: AFq9FYKxzfpcHDLOZObqfvsJZ8ccyTifq6wOfYpiHjMmHwH7WY0W4lbw
	o6F31KYOgEt5M7J057TokjEQaHXViFGAPknJD8SluCT6Zt1uHE2u9LDj
X-Gm-Gg: AYBFou1Xt5pU/4DbRvtRNchSkcJvz30RL5JCEvIsR9paHmHx28l4Dg4ThyZcoRbI8ie
	mjyBzAhE0iwoZ/jWeEdveKPnCV1mLrTpc7ruPB5/IxvtL60jHWzpsGCUxvyNhQCjlT+MM8NxaDY
	WP69WliYR7QHfgX2qYztCqYn9oe8S6Rq3YQ0WgZjSWAHYyXEaMr/5Yb5Hr21Yk6teUx+HypSTe+
	u/32xSGEgOOnytlU5GMfqIbGoN1Ci79XKnhKOK5wDxjd5CdQMBp3p0JJwVYC7J7NhmNC0A4oMxo
	75hGXFjTvXDSfCGRoDQT3PZ8OzhQ9qWj59eb4VByfNloU4jixok8rLrhixPSTmVBmefaS5nfUVQ
	Py3eGubhuoEv1Ih445dFlSNN8BRo/PTFcrz8f6RxwtA58rCFVjP7dqF2Ch3+WPw06jdpUA+Rvpf
	ckA0Syf40wnAIPRfegXg0UJYYPfsTWOvK6YgbCtW2BqGQM4Y1UMwGFcmOGYF4nmB2bXSwESuNuN
	wRDpQ31mmtXJuwsndB36Q==
X-Received: by 2002:a17:903:228e:b0:2dd:c100:7cb6 with SMTP id d9443c01a7336-2e49b6b662dmr16609685ad.50.1790932225869;
        Fri, 02 Oct 2026 02:10:25 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6ab2b9sm5480555ad.36.2026.10.02.02.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 02:10:25 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
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
	ryan.roberts@arm.com
Subject: [PATCH v10 05/10] arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Date: Fri,  2 Oct 2026 17:09:42 +0800
Message-Id: <20261002090947.869220-6-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002090947.869220-1-jiangwen6@xiaomi.com>
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16EBC120003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7od4c8o3nre9zhb45jayo5qp4yj7ikek
X-HE-Tag: 1790932226-426920
X-HE-Meta: U2FsdGVkX1/CpjLLVQ2ZsJiBwRUmv/BEcaey+wxmFaGgdTK1miYxEMFC1HWHbu9vsELzNf5P4ULr13Qug92SHF6kSsDB51TPRFpxRFC8d66o23XuGxyW15GtwhRe5bpivYfrkY0QeJQxy4HCAIZQCT85PMVwascfPKtnobQPMnhsqfKr2cMkH6mwdymfzUJCngIHvK66PPXPsqwBQnwj/nhYIo+rFjqKNEF18lyRe2+SqQsgQfdi8bxDJx7zJ+1WEI8BVZHF6Fc3pP3imT3jvM2GTP74iRRYcsG58qKksZZHwkgvqoI3vXbzccZfF0KG0+lt5OBgLH+qIguUZlBBWDaqtaHu0odX/J1nhDqkd3ZdXgKAg8I6aK9JJqsJQ0YOyZwIsS6vpQlZ3fgGEBTt7ILJjFkLIMpYo3dxC1ORXEvk9rM1111PRpiMVJdS77X1zrJw8a76vMjE3t/H7knd9rEfprnScK4bs/DBLaoy8OAX7MeZXfSVgE+HScngNqAnGgR7YT4hz/O3Lx7+lzzWuXKaPcR3FdMqSVviMha8yksRRwqniPHXEr5S5GJ7jPx8n7GuTc8pwN22Z1DrR+7BWMV2WIP9CSUeksCCR9hH66M0ghPuQtx5w0MZ0agPhDG4m9T+6kQ6qoexDNKiBlFsE5FEAB9Q38EvMzv5zzjIi4Yq54wqS5YjX/3rl8puYrQYwXrJHQAkQHiA+bK7oTaRRs7chTVmhdpcV9Bw3Oz2r+bUA1w9Y9xQ/nXgOS/BVee0ashIgdMbAJYKEgO+IJ2jnr/Ws4QKxUtvg99wEsoy9eQa63IUYdXGtYtXIuj8QOqMor0+TXjOLzsnUp3zwU9KmKiADHDr6M7/6invRQ8M7A+0OziC4NRIfAVp7g+eEgbBkFmJdkL4G1heyvsD1l3ldvf9zB3WGIDRzmPjfLMl8Qa9B6D+q9C1u5atehX0Cgfm6rl7AW8DgLfMr2YHpHM
 aOlqR6tg
 t16nfUIBM0yN+CN13vWkNZx6FBfcz2Ia12nYPMkdwsKK8Z7iWASAdkR7PAq4JdBEhDPhiGyBzI+XdzAEs91eV+kTIcEDiY5O6aRIsgE/eq6meFCYwwKstzI7wedoeYCZu2k4j6yeksd7etdGnTFE8PzNRJVw7AwpNQpTvCh5Oezp4opUB/2ubqQheGTdZlNjpgiER/zRYe4SmrTbXiUc+JJMVdu/PiZtihuT4YernMXsXtlwQiqgjBiCnAYMd00MKBbK7wgS1/+QW/7bGiumMqxTqSDp1srKBtzOwa23/R8S203kZDUXTed2Bd8INw779GN524qVq6bpyXEDD3gmn0xbi0kyTFPm8EvgT0G45ilKEKvPqydiG5z5/uK58MobDhqOpnEpESl9Pa6yyEFBTNwVgbGEMzTelMSEk3uxJzxJ8/PZFo1RGCOmPaQ9x+l4xbGYXOdTKNOFKGthXdAL3xLK2CjbkJltuVO1M8AlzASi7u/ctj1n5jZxRwHCWoNbhHKXxnaFY+bcGVy62QexL5iVGueWWzp32f+Ks+yauUCEPYxLT6tw4bfnceqQitEunGNdcDyU2Ra8LcyNHsT2kbhjweQ7+Oj9kHfOk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Previously the function returned a single CONT_PTE_SIZE for an aligned
range, so the caller mapped one CONT_PTE block per iteration. Now, for a
CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
that fits within both the remaining range and the caller's max_page_shift,
so a single pte_set_huge() call installs several CONT_PTE blocks at once.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 arch/arm64/include/asm/vmalloc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..c29704a19e276 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
-	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
-	 * aligned in both virtual and physical space, then we can pte-map the
-	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
+	 * virtual and physical space, return the largest CONT_PTE-aligned size
+	 * that fits, for more efficient use of the TLB.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min(end - addr, 1UL << max_page_shift);
+	size = round_down(size, CONT_PTE_SIZE);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.34.1


