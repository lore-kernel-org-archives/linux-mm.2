Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA049C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515CC6B00BC; Tue,  7 Jul 2026 23:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478CC6B00BE; Tue,  7 Jul 2026 23:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F9D6B00BF; Tue,  7 Jul 2026 23:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECE066B00BC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43D9E12065C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:44 +0000 (UTC)
X-FDA: 84964134528.21.163E4C7
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 964491C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/mDQmHV";
	spf=pass (imf20.hostedemail.com: domain of 37b9NagoKCPwnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=37b9NagoKCPwnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3/ZNamF37j63F7OBjkPRQYLwgVzCnxnT7m65A9NwFE=;
	b=gG85qkLWir2I1IeKWgYXGgLioIuKsHHLpmcWh3OulcdnGqjUY5E04/OCJFwaMrVwAINjvg
	P4M38kW0upRqXxi23vpYVhLaIswm3dH0ExwzYcEjONmwtVL2QEogN6aJUT6cikILgOSNMR
	uN6sLlDuHYKHKeHum9m/A52TKGhMQ7A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/mDQmHV";
	spf=pass (imf20.hostedemail.com: domain of 37b9NagoKCPwnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=37b9NagoKCPwnxlsyklxsrksskpi.gsqpmry1-qqozego.svk@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480302;
	b=xfd/EvhrR/HZvh72FVY8unFprqzxbUyZh8nfaFdgJWSufxj1WhB1jCTBFVxq0eFoQWAEUp
	YXDTz0t33t5ghzCgORIp9yXj4GdNML1dhPf9/wnW/vSpXKPoP8bM+Lj0wG3ZohkXbCD6iI
	2vbTmyhuocboXS4P3hoHVn4fhPCBRe4=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cc86a9ef97so6300915ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480301; x=1784085101; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v3/ZNamF37j63F7OBjkPRQYLwgVzCnxnT7m65A9NwFE=;
        b=T/mDQmHVwH3M0RxGOUjfuUBv+qMb9S0ZCFfcLrvhUWlAsgBEVGZtlGAn5Pe9dbdBQ+
         N2CiCgmPVr7fveALUdpXfmhwoZVR8WVklwwrRuANdZl+TPYpaUgNUfEJk3Dc31swBDDb
         cuwS0pYSKcI5SB7W3rfp5ANyb7pgRcwFaiWw59glitHVV0APdyp5Guv1v9Sdn9Lgy+Zi
         bxmOWSmhpSjzifnj9FoGeR0RVGox74B09FFCRnA7cljBfd5zup6Qrq1vpXwiJIpGxUBo
         KCS2ZVOoQ3isykcXjYOMZuf4xMLx6HVpjYCnTMpQCFSDB2CotXXLtWPKtzcED9xEF9Jq
         yikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480301; x=1784085101;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v3/ZNamF37j63F7OBjkPRQYLwgVzCnxnT7m65A9NwFE=;
        b=g8na2/bDN3gyfBk4OXA/BN9qFYgB8kOQykmtRQhOsP4mx7eVmM/oaDguRX2eF1+1mU
         kODk/vW0iNgGEDs8ZN9dkHt2n/UYoWdZ7/iiMWeIgQbGBcgfxXRIU1bB3+07adbHYgar
         mpaYNA97CAl8YptGZkGGV8FeNjYsMTBg4Owewg297kX7DH2ISr7NRBnXdUNUo2L+PEd8
         4zrR1+2pevwaIcwSmIRsx/eGgaEVpA1jgVWMlcH3x/+8WQleZHDcqWfUnBaCzF/JKISW
         +d4fQ+Rps9i0NepXVeQQtvZ8AlZlng55kCpDXM3E5GGpH4/jUkzhirj2UHl1zP4qnRBw
         LOaA==
X-Forwarded-Encrypted: i=1; AHgh+RphtbhsJnmc7h4qgADxLquvWyx21FGU5r9mAABqz/OXjTJ8UHVPuv1Z96+Hzqb1YgqSzX36t51VvA==@kvack.org
X-Gm-Message-State: AOJu0Yzlm99nVnzNjnqC4zajkYxDASnxuyzvajK0GB+goAgYzZ1w8xLG
	WK7ehTxKpwITwAwyYM6SnD6HQjc1V1TYE4mylM4HDsFN7aOQVb0wmMNLAm/+6SfW6+iyVzabrbi
	sCiOwZzPNKVqNsJXG3+Az0Q==
X-Received: from plai17.prod.google.com ([2002:a17:902:c951:b0:2be:fea6:e21a])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:384c:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2ccea35af6bmr7910705ad.1.1783480301298;
 Tue, 07 Jul 2026 20:11:41 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:19 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-10-jthoughton@google.com>
Subject: [PATCH 09/18] arm64: Prevent HVO if the HVO system feature is not enabled
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 964491C0003
X-Stat-Signature: x3n767f1z6ukbs7wepfktrikedanrs1e
X-HE-Tag: 1783480302-448912
X-HE-Meta: U2FsdGVkX1+JLshhqstmTvOFOuQbZPb32bVSYXH5TJ/2qVzjqE/O6LyBySmLmPqFPKBo931r+V44iQkeJ5eEZ1mqgLj2Z3DlYA+QqoquyrP/5ElSGMktmZD5q7IYB/C03iMnguGz5tiQGNEQbGZ/CFYYo2wUbwcNlgLe2LfMbEJios5wnUU+YbjZR0pLj9RxrcSpajuo4foQFZayxXF/FxrV4WYpfIHqmB1q7OA3Iu0bCuW9pRoG2WIrZrBQOQDxXjv+liLA0skpA0IRwvC0AN+fBmI7mTjYkWwLMvZj9QqBRfuU71UCAoCLwOihsGnA4kHKPfpg8SXs8/8q/4vMrDLZ7rBVWOVdh1mHY+uzTL+2rd3DLY6NM93xBSYtcv1JijzFWkjqNsYXt3TVi1liUxIwCEYtRmaOW22yc3P5oeebmExuwLe2IUmd3IGqioJenDPDeJhuGZqRvLP9aC0oyWLgfu3wmQzgVt0Gp5+XHQ+mG5WZJWUYJ/3sRlqdLWnv5w3qxDAnCkRfaFnlp+pC1iT3m2XCEfM/66aUmbXR9elUZajM0KChAkIrX3wB4YvvzpTpCucVEXFpPU+KxTzL7IpuyxPJIe9xY9LeV8Z06Dv9bVhqUkbWM+PI7lLR20GMObHxY8K2zq/TXycAfje6ZgCBOELgITvCSyRw7LIhf5/7BU0FnrvnNar7i2478jgav9LTmYy41mm+M27CHZ17mgUryllzlsrd6CGq/RCpzXP4P19HCMg6f+Yc2hgMhgRATMHpDdu3mJIaTv8yfOCNYOyqtR/aIK6swVWsqQBXCmADz5741jnaT4y4PJcdLf0DD/jD9p4UkHP4h6uXqnNzdJCL3jWoS5c1E0axg2maToXqTRF/Byx7iVQ+8IxRGDgJ3o56XGzNfD5FdNOBHhn2qswq7tX7pqC8KsFOArDSl6isupu5i0UbvS9nUL9hjgtSIGMhCoC2xZDRICJBKdi
 lWLC4DbX
 e9X+hXoQMjik+a3CD84sH06wKttZMr9Cskm3qlnAHBTZloxQKSBN/Wa2BX6yJh+W8OjNTPZ67yIsWvH622kd3vFlMs5XX4iGwQig7xX2cJKyfVnTl1sQniZ4QEy/zUEOaQJX8oZ1x1qNiG2Ief08FIMQwFPn6V+auGSCBoGhAbXMVmgyAnzVqE8NB+38gDCIVxefz2RJ0O24v4+SBArGwOjZXTeFhnVAzpAGvkpgvz4CWFliaSNGWE6Z/3IAlREOAyRCIbDjMt+FKsfQioDN870Yq+czH2Lo7jZ8VN+vCQnqh7AX49u6jrRBna1NVxsRt87bfBXiJPcP51jgk/s9f6ci5w+ZfBIvbpTpn6P5sUd0z4kXJ9nyDBXkKll2Wpn+DXi+MMsY+HibUkkd26h5YgSyyRSzfa31XqkprhM/9TTAmfnF7ZV4zI99bUTwmvUS/iMFNu4eOEtsn2KOhba4AVKgadcWG8guI2PEzMRbk70k6ebKqab9S6u3jMKyNU+7E42++RhuVZZk/w4q/b5cQ8+deSKO/tTr5rOK1r7gbyy1VTGXx9itCBYSLFqa/FyehX6eKDQCcfyEcSqrxz3Tm1+dxstrf0Z0CD3iYVRukVPjPMRE2rRnCOMDVFa8LKqRh7QRgYPuXUOa889M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HVO system feature checks that all CPUs support HW AF and
BBML2_NOABORT, both of which are needed for HVO (as of this patch).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/hugetlb.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/hugetlb.h b/arch/arm64/include/asm/hugetlb.h
index d038ff14d16c..73af7911fd83 100644
--- a/arch/arm64/include/asm/hugetlb.h
+++ b/arch/arm64/include/asm/hugetlb.h
@@ -11,6 +11,7 @@
 #define __ASM_HUGETLB_H
 
 #include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
 #include <asm/mte.h>
 #include <asm/page.h>
 
@@ -65,6 +66,12 @@ extern void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep,
 					 pte_t old_pte, pte_t new_pte);
 
+#define __HAVE_ARCH_HVO_SUPPORTED
+static inline bool arch_hugetlb_vmemmap_optimization_supported(void)
+{
+	return system_supports_hvo();
+}
+
 #include <asm-generic/hugetlb.h>
 
 static inline void __flush_hugetlb_tlb_range(struct vm_area_struct *vma,
-- 
2.55.0.795.g602f6c329a-goog


