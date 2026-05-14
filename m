Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59364CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA416B009E; Thu, 14 May 2026 05:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BB16B00A0; Thu, 14 May 2026 05:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1696B00A1; Thu, 14 May 2026 05:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 740746B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:48:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A44B86EB4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:48:17 +0000 (UTC)
X-FDA: 84765549834.08.BFB249D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7194840002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:48:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5P1tf1z;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778752095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rthUTr5aJwvQN5dfFdn+hJiV/8yC9qvkzflD1RrG+LI=;
	b=4urR204sunSE2j9SldzexrtFxj2vsX6ah/h3h1tWAkqFJmmHqBzPR/WV4ni9qCrrXXhoU1
	QieHR15VjRaS+RSEiKQDdHhDdEMf5DAdbDVO6LRW7aivVs0YNnF+H8uTZ3MkimSisT9r6c
	MG+LZRCu0EqD3jscpNYocc4Z1Y2QW9I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5P1tf1z;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778752095; a=rsa-sha256;
	cv=none;
	b=q2f9wIcV6OO39NO7C9qUzq4e6bZh/hPo8Fnasrmc1lbK4AVfAjeSjYQ7k0q/3ZjlXcarXU
	ou2P5QcrwvDLHyXH9tyZOb70U/0gwWYy5v6c1qNJZ7aDuk4wodwuZPhYYApEwIV2FAIcfn
	YHNMB8G7OPjAWaIiXQeZxUUaX+yyDc8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 638A5416C9;
	Thu, 14 May 2026 09:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D0FC2BCB3;
	Thu, 14 May 2026 09:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778752094;
	bh=AEHi4W1KYEHg5rYUZUzuQLRkxgrazZRzZEYJFbF7s0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N5P1tf1zc+VnBLRoPwRM0m3YsEvODOJnOvibUMU1l4XpRtPV282SDJZ/UzrQ3pqPc
	 sra/P9xVOfTy9VyMXR/GpDCQFisxTIkZl+lLttjCwKB7BWkSQd7VH8LzyKTSgh+8a8
	 1yqPznsu3JPJ4zbSyyQIXfsW26ci1DRpAagv94golItxIAVrIv5itLSNpLtFPUqLnI
	 8Ajw3u/npObg+junqsF6VXGIxHcIZ9+3g7svaveRjlPk3yVJORvtWjB22ftzparr9P
	 oqEL46psrgIebXIqi+FqLw0TVULOEIn4fVex7e5CsUsj8eaN+xy1anVuvUMEq/BhMZ
	 G3IGWGDHLjcbQ==
Date: Thu, 14 May 2026 10:48:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/hugetlb: avoid false positive lockdep
 assertion
Message-ID: <agWZsPGYid08uU6O@lucifer>
References: <20260513085658.45264-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085658.45264-1-ljs@kernel.org>
X-Stat-Signature: i7gsxmh3xsxj7pe1ign1kb3obxdtf6et
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7194840002
X-Rspam-User: 
X-HE-Tag: 1778752095-932890
X-HE-Meta: U2FsdGVkX19PYRh8zHT3ut2YbYnj/Ir5aIryMZMX8q/i+mZ6oAKLUZtj9VUTRXBzNKXt+TL+WvYBQxD1mW+K9SCFg+uYZXvSKTxBPRdeGMtmELhctAT/4BGG1B+Ykk7R8rWmVWJv2nxiRIB80wiixrBv4NiZQ2mWfG9j+I0wZS6BrVw/zysRd1I5tEeK5HPily+a8qnhr66d2W7Caby6O07r+1Rl7uz3KeCQGOm1y1UMR1EP5q+UKvFHiEfhLOWCZpCUT9OR5oq10rGFg4v8bcHie2mrdcVldOT24V4+dx66IvCUKlXmJqwCGBBKpzRYeNDNN6bcQMxyNUyibOx/oRPggAo9CuJcUtjXaft/Irq2vzrvHmiZgD/a5L3RWshRabnbZD9+8SfFYB6NS/72rDCnTMl0mrLBXsZZHDiFFcHMcezECfffihRqNrftNaRnCfHxAHONWGHHs2v7JQoRGrOJtPBuwmtQBvXj4bnEcYeHLYXNUS0FQufdsePYx8cGL7nZYCYpmpl0YLmnA6ncR45hKDc7BE2VyMFDDqBkdkasP4mj/F5hOHa2DDCOYZLqfHZKVP23aLtDqN+nigBzeM2dE2nXC8Q2vzIDtavEAEWMpAiZeKs13Rg5gNivfYMW7NaGeIlgzGWXHRBsNoYzXDScNhaUExX5JPdk7byBGUkIvo0StiSuEA2blfLX0TQ8P46Jp0EfR3GobTFMFzq2CpTvbZ5mmZVjnbu0LP3jG5mX7gmMobFpNeYZAQIT4yx8b7A1riqXCC4Kukjp2XqCS+ZgMgeGErsGu1V/5VDHVn1bSZjRWZUUC70G1IRuHTUIhTsqW7TV917vjf24isI1yS79DNCsZlZ2asDqFBkQqZTuvmdV/DG5QUF8CgbA4+T+UMy0IJzo6RS4JyCJli6xNEmusgsHTK8DTUfrPA7EhIx6V5fCLp/76Vy4pih2YhcA/ajF0JJAgUpctnghK/z
 /c509E5K
 gd5g0XS65EUR90vy7LAS35p1p1c2Nam4cEVXPIEYzjzw8TeNk6KOdQVXkHzIPqX0Dto/SUSBCqiiAU/FzHvtQPXTKDL67AvNMwDZAgu3mO2eestMf5/naXdgf2Cz0w8KD89uUbcfGgy2+TUaiHHMmkQvAhOwUSgWn/N/M9pjjHDzvUp1p/nIjcDfFDAq5CDvW7AFbNo8eaelEhqHYJVcw2+d8w8pvDVEXXVwiJmV0YKui46UzDepHJEivScLQkRar98+6oU2VnRYIOe15gz06F0zW3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Could you apply the below fix-patch to this?

I had forgotten to account for the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case.

Thanks, Lorenzo

----8<----
From e7f25943f72bfa224508ffe2bff526d3daab23fb Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Thu, 14 May 2026 10:45:38 +0100
Subject: [PATCH] fixup

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/hugetlb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cfb7cb2e9806..4b3849d9a3f3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -118,6 +118,9 @@ static int hugetlb_acct_memory(struct hstate *h, long delta);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
@@ -6971,6 +6974,13 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 	return NULL;
 }

+static int __huge_pmd_unshare(struct mmu_gather *tlb,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		bool check_locks)
+{
+	return 0;
+}
+
 int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
--
2.54.0

