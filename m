Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C1BE92733
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CDCD6B0088; Mon, 29 Dec 2025 09:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B4E6B0089; Mon, 29 Dec 2025 09:54:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E4F6B008A; Mon, 29 Dec 2025 09:54:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEC416B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:54:49 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA7C91413ED
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:54:49 +0000 (UTC)
X-FDA: 84272805498.28.9D3E0C5
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D214440002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:54:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767020087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
	b=0AC5nQQ6phdV5RiRkGPtdV0+kgp5BC69rCOseVxaycV/aI/8qBCemnCt6BbDyl/TPDMDk9
	1GaXT2Xr7zwMYSrpavv06Ue8fyNXuP5lSd7gOMkcHT3ohWy5uyeC7nEG2B6KCJD0ug//G9
	CAE/dGAVXZA5ZJ6mZ9t7Ho5tnMEZpxs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767020087; a=rsa-sha256;
	cv=none;
	b=6IJHbCYsWOlpH7YXPQuADoGykw3cPHp2gaLaLaZXZw8wmKJghEcvhK9G3HW8s2s4G2FcYC
	j5bhpPcL6sPyiSLnCl+zQFjHG4cAnBuAJoNkUruCvSv58ujRIC/apsBsMlLPvqHnRyMs4g
	hA1rwZM/EPDBCjhLfFDQdzJKa/3NM4U=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso7178354b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:54:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767020087; x=1767624887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=foHDr6tTVVg2N+oq2ubI3TwM6NJy7Osy+6nFP/DCYQ8=;
        b=Uz2128AaYO9oNxksJ2HXPZ9FLsLPqIvKcaqEhaa0YNs6JWFu1D2q22vykM/VbH3BkU
         Pqm59Bruv4fYhxxUA0MOWvWSs5e+gS8F6td9SB19Tkrq2PY8DScLyygdn/XCXA3LnRcS
         BcIYBK0m3Uf4IGQqVhIACKvd1M7N0jkpB8Qc7JDyYc8Fg1rlq/YXoyzPNhifqSUYHVF8
         F33tcvFADu8y5FuBhawY50pd3k3gCrpHYQGBxv7SHb6u8bzRDeXiESbWFPjCv3YgYB8F
         bR6tE/gcxbGyGRhWJeSdiXPmmPzcZvFyUUVCOru4iPC9hYEOJ1giDJxRmjVBol2Jq+O7
         fYvg==
X-Forwarded-Encrypted: i=1; AJvYcCUj0tNn1E5x9rhq42uLQaIfSHAEJ/C58jnKyqjAJgqjREn389gPrM7RVuthACCW//PnUFxR/ISINA==@kvack.org
X-Gm-Message-State: AOJu0YyzJI7uTKner62egNvcVkXtErXT2Q0Val3d1MshELmY17mAET/u
	Wi1rqWl4L8F+zB4GMGgKqcEBx7qm3WjRBYKH2bNDpWS+vqDavRhJGDtg
X-Gm-Gg: AY/fxX4VJzQOmakyBuyVgtmC1VQWGSCjfLZykNuFaSXswMlTxCcevQU73LWEWWzjbDq
	Z/ABwbxCLi5TFW/OKkQygIYxgWOoOVvlMxWMFhUHW+oXwK9gi/Kqmf2kyU6rwIz6k+5qlTFvjKr
	xSjmZu1rFlbNMI8zmOIXSQJGC2msyumnMTVVRWaZZCUGOhGYwG7tPOHLJ5pg1sO5aYICzz4t2Bz
	wH/JKzlfATJua8kbHpceSQAjWoqOBRFmS1VOiSlCs3u6zqaM5aUKdYduNG1WYw0D5ZbwIt9X/W4
	QCHI4SvS15TCSXfNSsEs0XuHrKOUNgsQ0aRtexoC0PKM33YNgK57Nj5tcOeIu1F5JKb26So8xJ3
	Ma9h5/QJqp7XX7fxtV3AHoQAXp3i9JovVhNjVs2V00DGnlGx9/xGu+432rfAWXI/Va9x8dgYqOi
	ygfeLdls4ziumCkax/fnXYyz7mAhF68AE=
X-Google-Smtp-Source: AGHT+IGKVZznmIqdsFJZx8tzz7DJSoz4ei3n/x9I/qNdC+q4k/iJfPtD5Rz6uSZJWfuK81E5v5oz3Q==
X-Received: by 2002:a05:6a21:6da6:b0:35b:9ba2:8cd5 with SMTP id adf61e73a8af0-376a9ccbb8emr26989418637.56.1767020086734;
        Mon, 29 Dec 2025 06:54:46 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dbcb6esm31557603a91.9.2025.12.29.06.54.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:54:46 -0800 (PST)
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
Subject: [PATCH v2 1/3] mm/tlb: allow architectures to skip redundant TLB sync IPIs
Date: Mon, 29 Dec 2025 22:52:43 +0800
Message-ID: <20251229145245.85452-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229145245.85452-1-lance.yang@linux.dev>
References: <20251229145245.85452-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 939e6m6oq4hpdf7ca93adzjbr98xzc3i
X-Rspam-User: 
X-Rspamd-Queue-Id: D214440002
X-HE-Tag: 1767020087-116874
X-HE-Meta: U2FsdGVkX1/hBCIU4HAt1sVWk2wXKGFAOuvtIZtQ5rtAUMLh6iiMuJfmxVgSR7RtaiGpBlYYZ4+ApfguxUZOEvXkM6beMOH+HpEdPhQDNJd0fWMhWLsPi+nOvaDcoIizVGC0jHVCZrceAdQsNIk8fVCfBoV/GH10UEtI+MiRatlcst8TB+JfF2P4LuqG1k3s6ifZs1f+pVpxswL0VgTELuw/5oCPIOhKe3n4Pd/rx4maCCzfwxHSVqWERGuhu+0fmgSf3Ae9gSEO/urATDKdPRZqSB46MA/yEvLVA0kOk3ZPeKatfxBBFxpXVIK5zqyP+NmVUJ4hpOhvqaF2mYdCUguTAzk3c6b1dzZhhgs/dTn2JIlaFt9HhyMoU85nGITox8uValdBx1PfUtUvVPH+cVx3pJHVLINJjUzL4nMljXKHZWrZRPbd18xmhBliLR/y+mzvNIrYQ6ZjXYnb72rFMzi6gc9/VaJOZajnDfIODG6gq06lvIYYMCU9w/Re9tjZDFMt4goJiofFQPgDpfUPjKesmLOhPKWqiL8OMAS27ntsJar+sWLHqMqtHeYujIVLfW7nrESEty32EicRbE3XdR3I4GzVO8MHxB4FUDtoDJTgOFKt67KrpDz+8Mk09MZspQyEEL//0VxhR2mZpwvQ6Qm8wh8JvTdBOuWYR/HTktzUxQoR7IdA4D9gCOouLrel8jnV+HlVbm9rl3NByom7V2cnisRfYq4fnPb3ZPJwwClI0r09I44ip2E7a+x6K7qFRTaNmnmTkQ2DWvwUVGpe4vIFUjqwF0ps3njKMizPgt39CvNMIn6VZzBGESUT2zk4OwBb3Bl/cQZ+2YWSTfLS648zMIbzzAkQn7HKpxgiUpIsg7fo6ZZRj4eLjFRTF0tDuk4fxwl1C0gr6d03kgaZiYnHmPp+VJ28uhkn6hp8eEVLwVtyPijlYs7oWPsfwM8fE6NRnxS0vbVeQzrXRpJ
 YVaDlAjY
 9XHFuBUjsv66OXvkh04Zh6n7dOS9KZa823eWr99L+MtNeg+vyouAZ5OWyXrP0fRXH7bJOMXnLrIPU50N9ch+H0FyRtlAx6GWqq5RC9SloU4yBa0/yFpPSktyC0YCSenklB92q9lkQg+1xWhh71w2DMfrbHnS52/2UZ+8/LRWaMigiFKgrAFBNVEsjKrhN1+ep/nmhQptP4gnRF0AfjZmWtjs7Eald04/ZDTUZluZYpba9lqUVRwCUDHBqSXBvEKinTUjNCKH2hdug2Ruu9WjNuOYiMaNWHHbP80NpUrU2gy5NXPwY5owwAwYI1kT7P0RPO7oT1QLeDwT/mSS+BckDWfDX1EcIIFCcvYTeiVf/LUsYRSKGjH5law6xCfAfMzpLthNq/kOUsmX+sAGiFvVhy7Jf40ReXPoZ+Pp00H1L/FA/QSOA6N4j8KC93282zxXoU442WkIOSeMw4Ccz/Ld9o/c8LQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When unsharing hugetlb PMD page tables, we currently send two IPIs: one
for TLB invalidation, and another to synchronize with concurrent GUP-fast
walkers.

However, if the TLB flush already reaches all CPUs, the second IPI is
redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
completes, any concurrent GUP-fast must have finished.

Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
their TLB flush provides full synchronization, enabling the redundant IPI
to be skipped.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4d679d2a206b..e8d99b5e831f 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -261,6 +261,20 @@ static inline void tlb_remove_table_sync_one(void) { }
 
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
+/*
+ * Architectures can override if their TLB flush already broadcasts IPIs to all
+ * CPUs when freeing or unsharing page tables.
+ *
+ * Return true only when the flush guarantees:
+ * - IPIs reach all CPUs with potentially stale paging-structure cache entries
+ * - Synchronization with IRQ-disabled code like GUP-fast
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
 /*
-- 
2.49.0


