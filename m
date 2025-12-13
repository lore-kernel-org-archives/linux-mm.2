Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38C08D59F6F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901956B000E; Sat, 13 Dec 2025 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2606B0010; Sat, 13 Dec 2025 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A10F6B0011; Sat, 13 Dec 2025 03:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68CA66B000E
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:01:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22A85C05B3
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:01:36 +0000 (UTC)
X-FDA: 84213703392.30.246571B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AB401C0011
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:01:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf21.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765612894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6zyZqpXGOD7PQXCX/qi8XAI4ssAYS91zNYfhBfwbL38=;
	b=lQgAVAB7vw4UTLL64z4rPESmEYIMb4kJlzyw56nuFtU0c3yFazJW/myswTIln9CbKM/Byc
	1o/BppOlUfvzWQagbdCGkX42AozRAIyI925BJvGMK4rojwd1gRzdxzptHlQf6St42ZkxSO
	muv5O5cVivFm6TtK0Fu+BeX7lkXeUtE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf21.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765612894; a=rsa-sha256;
	cv=none;
	b=QRhXfuEE9ve3Pk5uN783dxMhH5LX53H4n81oIoZR7c0mSbWCr+ZsE3ZcKEihRWQtHzuUrW
	nnMx9Tub/ndrWSXIaXJSIBPjJ9T28+196QP+9GnCk32ZZDxc4wdbKNGL5RApAwlBZDJ91i
	pDvMwfFJH5tx5FSfUeOdpaErilDlIw0=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297d4ac44fbso9700195ad.0
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:01:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765612893; x=1766217693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6zyZqpXGOD7PQXCX/qi8XAI4ssAYS91zNYfhBfwbL38=;
        b=wHDo9pq/Qw3Sel0rwNt1r3K1YkiCy9TRBP7xyNAX/bPR6vjTOu1Oc4snKJ9akPJEzE
         nUJMNBISWMsqteZXPsUjsOeHVM43TUy8sfz/d++Is2/Pd5yrSRCr4Gs5bYjbDFzTKB4x
         Q+uyirmjlpBijg+nBINMXAW/NnrbTh9XGJk2Hat5HaP/a/JIm6r6bkdmSz5HEoDQgbHp
         +ms/5EsMTXLXS7xhXS65jXwKbvpBDS5FU9UfWrL3NXaYfwIuQrI5+/bpij3jJhG4+uY4
         XZ2o5EY/1FwhARlMdUCnQ5H7LKVfJ6dzVX0zYFcqAUbvnGxcfLom1ujeLF/1iI+Qggi2
         4qVw==
X-Forwarded-Encrypted: i=1; AJvYcCUc/HuHm1KX62iZ9deFA9CeCWMigKA++ZJRv+RXPQiSLnkmkMzBDTgkVzJFJyFY2wErLlvBSGHMjQ==@kvack.org
X-Gm-Message-State: AOJu0Ywy9rZOULaOdpqNx0fGJiQWURd49bFLx4FFG6dgC8IwmMTVGCHs
	VRVT+ecsjEP70ky+g2bK1T/LLj5evHHc3C+uiiqHWsUwNAEaiY3aqEa/
X-Gm-Gg: AY/fxX6OS6o00tCkIuIh6ZzO+2NRSLwNmdUWZy35vboHg0obaq5OUr8mHKf9jXKs4Ql
	vVWF96x2Woh4L5z+nv9h2awLt2hmkKSNxUAEYQqX3S9tJODb5fHiE2MB37zSYo0yO+IvXasmsiq
	gYldyWkDt2dA5ZOmdb/0ET/TTSoCFK/u4Je/xpo3e6ZPZlvlK2Kz7j7FF/6/PJIJUklkzugSBrz
	rRW/FfJAe1LLOMFX7oysugOP45t3VVXjLLR+5p+fTEaBvLJ19UbGAsKd6MelPvWQ5nihso7FrEn
	D6ssW7Ir+FYOs8XSMTznQva27xStzOYD25xbEEFmEuzfGPpoN63cyismG9fqLeRJ50GWd1+U0wW
	+PuddNMP9swaDk2T3ffDwenIgX8WbBcosaMC4p9YUSfjNELGD9hXHL1YH0D2OXM7LCnYYNGQBxF
	odxuxRMEPbldLuNoI4XIwVUibx5/r04KleEDMk
X-Google-Smtp-Source: AGHT+IEvzQW8UzoOcTZBNcUeKF5AlG/hKLmPQTyZebSEYXQtt07g7PJxjlFHqOPOoSkuSiaptW4vAg==
X-Received: by 2002:a17:903:2ec3:b0:295:4d97:84f9 with SMTP id d9443c01a7336-29f24eea3b8mr45731115ad.26.1765612893191;
        Sat, 13 Dec 2025 00:01:33 -0800 (PST)
Received: from localhost.localdomain ([45.142.165.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f05287fa3sm53149155ad.5.2025.12.13.00.01.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 13 Dec 2025 00:01:32 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC 3/3] mm/khugepaged: skip redundant IPI in collapse_huge_page()
Date: Sat, 13 Dec 2025 16:00:25 +0800
Message-ID: <20251213080038.10917-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251213080038.10917-1-lance.yang@linux.dev>
References: <20251213080038.10917-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AB401C0011
X-Stat-Signature: p88n6xstdf4fb16t4tsdikmfnym34xk1
X-HE-Tag: 1765612894-845252
X-HE-Meta: U2FsdGVkX1/cJDH/3m2f3UevN1XaYGAe+tO0jYfx1q70vjmlcuakhhPs6OTbShEZuS+VFfZVXqz5vTdcjsuALb8lRUe6Ihy3EqWjtWCme2BfX52KhACUc4GXLtxdwlIYezMYNvJLLnGMJ6lLZIveznCL0Ke2fj/K4Nk4dUeRF0KXFe1MIOLRgchDCxOK4BWc0GhpwAn8scceXyHjwRGlZR23vjFDZ2DdsGde6XEGsQUOOjopCbeW8pNl61FB7SjIg2wQYX6hhJGN8OrINldy80AbYyxk3YrhBAgobbON742y5iCub9gcYJEE0Yjw4O8vnPhzw5FrMQE6iKbgYF0IySl30mtMq7D56BwcmHNBQwfWgUHaBumj6Fyo767kbW0QKpSImhKvoWLse/AEaBRKpEdvttcuGd5G5l4jAyfovXrR3tvu6CKpl1qMqbeGZb0G6uemRnVoLg03r4jlhs3fCSY/kXXcu1E/EeZSbCg8z0bN5vB6/lE8iCVtkCUM9E45gb8p72XW3U69hyt/qDt/m/Dl5AeqaaGKZg1YT7Q38//H3MkIxCcAAj840GBygVgYDabAyRThW/SaVgm53sz7ndk+xZrFeFsCfKQUID9UDakknQP7UEK/BJDSpU4xquVd8Cd7TPdJ/6k00Ce/aS/giLLxM7TYh+JPClQ5kw/nQv/sD80Ek058Ck3aS2evt8NkRR9w1mIZ6ooQ+rGxi9eDuC5ubPeN4wzakRIcLm2CJ7pDf5wZ/7xpaGGaZemcE2e6fQxZ7IAdynv8+8egErJjxv1QaVEe2FDulVsqTeB6he8p4QYF5adcnqubkmzZaIrubwyR2gsR8io3tkyQsL515KnnQqnp9n3Ao7cT/vk5cAmtZVTEAY+6iYUtbHxkIvY0KmWPyKPks6iEC63R1vMncZtoj1JiYc31B8Z2/e4o4RGIKxQNbHDUUFXyBhirY4RCDzA2WLnnn6rcSTqXhcF
 PASP0OMk
 bV9yD82VK/tIdAhoV8OecvKVFjj7R5rF4M7xhuKLb/3Eiqw8UmQEQcJavxCzFkcwCD23j7FHEeWMklueJO1qPbYXF/5b/gXzE5QynGGk7eUDs4quMUeJsYcLnkBg8LsHY5fh5mZMazcMwQTDVz6h8P/EtoiQ7hFjW7E22nHTwpaoLZo9cxRdHntCaHcQjIujVfHz1ITu+VklScrm0Px3wLRQLiVRjSHx7e7ZQeEBDMKamyV3Yw/2Fc/QQGmhH/F/1dFs7pPaE26RiV1I+aBhiToDiB0D3hHOvhUOyNcjXyUeOSraFo62dThW4bbQ62+u34T02/IoXSXE4yr9ggcza8UY66DEdw38FhKq329dEc4DUeBWA9HTyGvlTh0XbwT3C099Mu1UGvgyDJmmg1hO+tcHjYcmUt0NqO4YgDPCgIG+z15A+jFyEyE0n4THdZkHxukhvNMBJPsdpS+O6HFPdENT0bqUGOmVUrZjF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Similar to the hugetlb PMD unsharing optimization, skip the second IPI
in collapse_huge_page() when the TLB flush already provides necessary
synchronization.

Before commit a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
unconditional"), bare metal x86 didn't enable MMU_GATHER_RCU_TABLE_FREE.
In that configuration, tlb_remove_table_sync_one() was a NOP. GUP-fast
synchronization relied on IRQ disabling, which blocks TLB flush IPIs.

When Rik made MMU_GATHER_RCU_TABLE_FREE unconditional to support AMD's
INVLPGB, all x86 systems started sending the second IPI. However, on
native x86 this is redundant:

  - pmdp_collapse_flush() calls flush_tlb_range(), sending IPIs to all
    CPUs to invalidate TLB entries

  - GUP-fast runs with IRQs disabled, so when the flush IPI completes,
    any concurrent GUP-fast must have finished

  - tlb_remove_table_sync_one() provides no additional synchronization

On x86, skip the second IPI when running native (without paravirt) and
without INVLPGB. For paravirt with non-native flush_tlb_multi and for
INVLPGB, conservatively keep both IPIs.

Use tlb_table_flush_implies_ipi_broadcast(), consistent with the hugetlb
optimization.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..06ea793a8190 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1178,7 +1178,12 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
-	tlb_remove_table_sync_one();
+	/*
+	 * Skip the second IPI if the TLB flush above already synchronized
+	 * with concurrent GUP-fast via broadcast IPIs.
+	 */
+	if (!tlb_table_flush_implies_ipi_broadcast())
+		tlb_remove_table_sync_one();
 
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
-- 
2.49.0


