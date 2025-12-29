Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28166E92724
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7FD6B0092; Mon, 29 Dec 2025 09:38:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF696B0093; Mon, 29 Dec 2025 09:38:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B24A6B0095; Mon, 29 Dec 2025 09:38:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAA16B0092
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:38:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F82213CB12
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:38:21 +0000 (UTC)
X-FDA: 84272764002.08.D8D5C2F
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A2F0160004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:38:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767019099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
	b=uOO2EebkwO0gX7ooghCjf7Fxxya1u+y260dDnW84roYb14yy+TBaH2GM+VKKGiuYsIXn/L
	Xod63F0JmUkKS8/tlU8rx8wRvcps2nt5LLmcq8d/77PGv/zPe8dbqEmQrwQq3s0vC5sDw+
	lMIIUuClI/z5NQPDWmm0TfSBYAR3Mpk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767019099; a=rsa-sha256;
	cv=none;
	b=BhvUdtpr3bO73+S7+S/RBsMVtpIvelAUVUa3wuSi7s1cH6RK0ky+or2eFGuP7+ifIFoULK
	LnE/Om0/OWAAW9MhpWpftmHUOvt3xTDRlhqMsypnofPr12P1XywGcMg44HW3Y+nKkgyK6l
	jkaDHV3GXTmPLP2yFPbzJiR65TQ2XMg=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a099233e8dso75181735ad.3
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:38:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767019098; x=1767623898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K2pBV4vyT2c4GBUcrUp/G3rP2JcNWZOiRH8LtGLdyis=;
        b=lkYZbdLYQJuBd7tLrGAbDimamDRLalaPdcTJavxb+VwE6VBb0POiijNv7wXPQSdK0f
         J7ZtNwvdzf5QUxAHk0KE0CyvZ45xo8LhbXdAcBXt/854KrxpDyWrA/WIIs1zw7nl9kc3
         1N03a6CS2PHfp1fGgFI3Y94bQ8Fpt72Kcx/SaM3HeMfJm/EsS5XuYVJhsqq8Ps+BLtw+
         7s5FGeXPJbTSG3V+L8dlcXQMIZgONAtQi9QulCmV1UM0dAYOFzqa6ben4l29yuivjytg
         s1l9E6dlWFMzI235DSYx+ZNS517L/LyjhuyClErBv0aaV1t+gGS98nF2QHdueOC9A66M
         SCag==
X-Forwarded-Encrypted: i=1; AJvYcCX6aB71eond5FbacCLdUcjNxBStTHWRJIl7a1hKfhoxXiG8YMFYgaxUt0rOp8j5LCx/Zl4qJFz0IQ==@kvack.org
X-Gm-Message-State: AOJu0YxXRjah8JiOQkJDy8H/WD9E6fnAuY/WncerRVhSwC2NxMxa88iy
	PgeIxn9fYWCVWRKghx2QBJYNfmJtRnR5n1hs/YFTDegrbRa3Q2m9BW62XiD7Uw==
X-Gm-Gg: AY/fxX7/FyQcuQQD3uJS4jO63h/qEAFLmNyvaannpZDLtOEJDx9s8otzv4znAxif4cx
	Ky6IYUQ+fAl1FVVhmVSn2YYySzwgE00HTCaLYOZTucLSmEnsT9tDh5OGVkbUShnIWlBRS4Gtgon
	UnkjC3pOC1Qfauj9RF6vbJHyRKuJ9JW2qjnzJM2RYBCdm7OZUixeyul8/FtCDmfz/QCPOLswLee
	hT5feUZBAQcwyNvi+fg7mPcgdhwfaA7hqyH6RlH0DadX1qR9qgyfTh5ghDxSHn06o3sL5L1/eAt
	9NUEMaZaK3uuK+nKhC0SmdimlV0sSHzyav4acqOsyucixx/4rJK4MEVWp/6TgNL6KYUx92qeMR+
	ZInCEIdDLY4qxCG1nknQXwE/Xxd6Y8Bz5AP/w6+uE5qHb3g1Jbe/bqWRAuBl28rs+HhTjqyIlUg
	jlW40DP/ARd1xMA+5Q9rUO
X-Google-Smtp-Source: AGHT+IGdJt3lkU5juysv6cnzuaDtBicBqS5Uo+6zRrWiZ1emfZCDgGtYUFWFKyKinXKOayvqccQJSQ==
X-Received: by 2002:a17:902:ea11:b0:290:91d2:9304 with SMTP id d9443c01a7336-2a2f22052f9mr332042505ad.4.1767019098192;
        Mon, 29 Dec 2025 06:38:18 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([45.8.220.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d7736fsm279669625ad.92.2025.12.29.06.38.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:38:17 -0800 (PST)
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
Subject: [PATCH RESEND v1 3/3] mm: embed TLB flush IPI check in tlb_remove_table_sync_one()
Date: Mon, 29 Dec 2025 22:36:57 +0800
Message-ID: <20251229143657.76968-4-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229143657.76968-1-lance.yang@linux.dev>
References: <20251229143657.76968-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 3wdkxqsxfeqyznmtbu7eqq4qws536stc
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A2F0160004
X-HE-Tag: 1767019099-913333
X-HE-Meta: U2FsdGVkX1+RGb9Rm32RdmaIHFNeCZQRT7ilSzRzmM011onpPA5wNJfENB1GauK2GY+DJJj6uKtnUHehCdUEowizYDJ0eFrNjG3YVvVJRS4ZqtlfL7VSFu+hip66Ip5tnTRtn0FEgoPc2WkKncvLlfmqZSFI7BtkhipURbBNuimGrRLQaizGbtJtTPlDRfCVlhQ3cW26/84GOFZGb/gfZ5vyDFYnTnbR8qkywrX014Hzps89pklzDhaFfmEbIZT3c2J0F2Zfp0BVr5snTJ1cSBpfPcs7Rg0n/Qn4c8vNVb2d3QCFnm8K2RjOy48q6tnex48+hCwHiF+fWuTd7sQU2SlTcfa0X4ZSIJIuJrBPrOmYhUoQg6v+706Ma9b9I6LJgXMxbdaVU33XslMhPZVZ+VeXkb/YHa/KRcNTJae+Zs6fpDiFd3VH4r+aN6+5HIIy8GpjydH4sId2LRoBCYW0b4+gUe6cSBINL/t3m98YKcv4N8e4QwJMGn3mpIsNILp+6akCaEtL0MtD6UmVQcSkArMiDduTD2aERCCiKPg0v2BXXfeIXxev/6+PwOS1ERGGfSNqqu7Vsm/3zHD3QBal3RTvs9Q3yM8SOqjU5FnGPPJiLe/7LU7xHxmyLv6qWaX1+kbKxTaFT6y9bKnWgJNdCqtND6qB0TCvBi4diz7d82j6uI6GAY4JROiCOqiX5xOllPKuvTonNrV7lHCZfhj+80DRZwjJaO0mzDwR3ypYQevhwUZqqcXj+xS3OehlBd/Ie5EGSadePugJQwUbfAh2J1Bl9Cp7I6qanXq/q+QxboOym1rDWk/RDGdPcF5CPi8mRpuAPIBR1mj+KAJ1S6OgxquyjFB3bW7jDv4kLN0SryTMaUvzkoCRUyT7l3MYOcKsX8x+/rQXqgv8K0LKH38biSIgk/4aSTYb3CcLT+x2w1TAvyCeXDHMMWxa/AKoQTWQsajzNTUQUOA+zR/VuEN
 ATUDwhET
 qsGb54UtVxS8mZd6v2fDNZyk4eBLeWuUju+qaM+LezCg/giLz18A0ZftBdu1P2sV4PojbQGvh+Rpuh9X0lu2uggnwfZYRy/DV/FobshdGHWBfgXcKrCFD9JvjiY6qPcF+gPFOpfRFWKK+Reh64ve6ox0wj0phBccGed7Himcm73naeuDjLQ0WlkmLWK27K7etVS9m+OyQJi3FTKOYFzmpvkbBB4eVgnC62rh83FrERAwdGRp+4D471JNmd3QmkSdLgg59xEwgb4TU4HwFtqp0rD0blTZzgpWPGWBLJlC+U81Q9yERqkML7qekdOhmFtWkP1CW9RjElSGP7eWaSvfINo4o5wue+mXM3exBCjV/HyQlvtoHyqias5OFVpE4CkyI5aYxqJC/UrSYFua7TVKmGvN/bjI8d4RZZgav1+rbU1V6Lx048FM7GLw7nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Embed the tlb_table_flush_implies_ipi_broadcast() check directly inside
tlb_remove_table_sync_one() instead of requiring every caller to check
it explicitly. This relies on callers to do the right thing: flush with
freed_tables=true or unshared_tables=true beforehand.

All existing callers satisfy this requirement:

1. mm/khugepaged.c:1188 (collapse_huge_page):

   pmdp_collapse_flush(vma, address, pmd)
   -> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   So freed_tables=true before calling tlb_remove_table_sync_one().

2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables):

   tlb_flush_mmu_tlbonly(tlb)
   -> tlb_flush(tlb)
      -> flush_tlb_mm_range(mm, ..., unshared_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   unshared_tables=true (equivalent to freed_tables for sending IPIs).

3. mm/mmu_gather.c:341 (__tlb_remove_table_one):

   When we can't allocate a batch page in tlb_remove_table(), we do:

   tlb_table_invalidate(tlb)
   -> tlb_flush_mmu_tlbonly(tlb)
      -> flush_tlb_mm_range(mm, ..., freed_tables = true)
         -> flush_tlb_multi(mm_cpumask(mm), info)

   Then:
   tlb_remove_table_one(table)
   -> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
      -> tlb_remove_table_sync_one()

   freed_tables=true, and this should work too.

   Why is tlb->freed_tables guaranteed? Because callers like
   pte_free_tlb() (via free_pte_range) set freed_tables=true before
   calling __pte_free_tlb(), which then calls tlb_remove_table().
   We cannot free page tables without freed_tables=true.

   Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
   (CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d
   ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional").

4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro):

   Same as #1. These also use pmdp_collapse_flush() beforehand.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/mmu_gather.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 7468ec388455..7b588643cbae 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -276,6 +276,10 @@ static void tlb_remove_table_smp_sync(void *arg)
 
 void tlb_remove_table_sync_one(void)
 {
+	/* Skip the IPI if the TLB flush already synchronized with other CPUs. */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	/*
 	 * This isn't an RCU grace period and hence the page-tables cannot be
 	 * assumed to be actually RCU-freed.
-- 
2.49.0


