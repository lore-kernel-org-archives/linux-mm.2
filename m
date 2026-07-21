Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CD6C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD51C6B00B6; Tue, 21 Jul 2026 12:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC5D6B00B8; Tue, 21 Jul 2026 12:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE85F6B00B9; Tue, 21 Jul 2026 12:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 866676B00B6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:25:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28A2F1C00D2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:34 +0000 (UTC)
X-FDA: 85013309388.10.D6F75B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6FDF7180007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jx7peZSS;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9b3WZj5jHk25VpgAWHevsEUQUuyXouMqSw6FbCmRVA=;
	b=wFvR0iZa+Hgphdzz/dMDLsZmjKoE7U/dfIl45pwXGFVCxYGX+Ad7KakxWdq5pW1SpaHgCP
	njuxcPHgKnzJ4Rnm7S76w/sDUF548ry+eHIjFQxJoYXz1WAKaS2xr6ZebLvoozeDfQ7O6a
	TVDcHRNFs9R3qKGRiduzveMoCkfJ6es=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jx7peZSS;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651132;
	b=cuqjvJJzqcGQSyPeMndP3QNabKEJdsTJPN2sqDhf43YA8e4a+NGrXaPf8JHi8RGjGgRynA
	fxB092xpNFJ/pidNstNlkNuThFNjnrY2BO2K4cZkq0bipi/VGsrkw+vhce0QYKInv8WGTc
	U9uOte5tJKpwS1NdIAHslcOG9wg+P4s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAAEC4065C;
	Tue, 21 Jul 2026 16:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5F81F000E9;
	Tue, 21 Jul 2026 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651131;
	bh=J9b3WZj5jHk25VpgAWHevsEUQUuyXouMqSw6FbCmRVA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jx7peZSSKvswuwTjFsyRK77utMba9/sCwesbc/K9+fo06K9IvmzAvdGGlzz4Bu3fc
	 kRKEjA55dkExDBgUR3eWzuAP3KFhmC65OnYn0JX6Rb63B85Mk2fdWPFYHZRUgZpMZL
	 zlLlj7XeXkjC9+s1pM1Hed8XCHEw7tNfTI+8Lj8iqVnt2FdBx9up4mA01kHjw6PzSt
	 KPGhKTDmAHLsnzBYf3G3vI2ctycqdIWtI0Cq6KpqDs0IOEVdaCU0ES2h6ZWx4uoHTU
	 g5XHwTUTgLxS/p9LTyr6WLkzgsMqv5j6Mn3bnGDGFFNsOfxexutYnMPmPPdK+Fjq0d
	 PacCIqlk4dtdA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:39 +0300
Subject: [PATCH RFC 16/18] riscv: make set_direct_map_*_noflush actually
 noflush
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-16-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 6FDF7180007
X-Rspam-User: 
X-Stat-Signature: u3di1yozwezc6afqxhq931i66fq746e4
X-Rspamd-Server: rspam04
X-HE-Tag: 1784651132-290498
X-HE-Meta: U2FsdGVkX19P6OAOq+oVZKRGeQo7xhp1IYfebg0M8XTG0c1UIvapN/t/jD0EdHYUAxyITLIgaOSo/BOqQtd8jLLLNJXL1Ib0gEWP+WgmZSSNkBQcZGfOi63MmUOD/dejD3K9tiaF8xCD9XievIs1+/oT2FUmNS3lYcx/dX0wms0Ng+47lTv74aRBNEs0DhWq3VdK05unDFmHHysgvehrIfwa/ZG4knW75XmavWDo4QcMGNncFgS1GDgbi8+T5kgLMNF+bn1qTT/WFh8nEp2XGZUF2VeSKCPaHuqwXfiw263MfTka4SXL2Lqqk7dY4X9bi5qoTb2EvnHfkMOmjvzxfKOrEL6OPIA48pgxdWZsILbaMFZQgH+UsQqhSL2/luvGaykUkRJiCTSQ/CxKrHLYAGU+nU/s5qyEUENREmyoPJCVMcYwI2TxnddmlIssuKuPLeO0MdCcuKDvJKI+skEo2Z/YcjApcWFgmTrwTiCy4eU1MJnKlKSWq9PeURKmViSJwgXshuEPBnfGdJ1oFexCbfo/5EKtRf0V6EKHKCasAs+X/tU/ysfXw+IXLp5exjw5L0KHcZ0JG1YviLczbQI7zkpNnBM49QLfBnyUllxx3qcJkQTdbvrdT8ahWGXWHsi/mhVH7raKbDtaYy1D/GoJLankJW6UQgeZalGSnOSFuKywT6/004vDxQYKxowOw97dvEJpA2dL+FiILBYUEElJH+69vgx5+3VLNR0AfijL6ZV6nckhDEMZG8QNSQMQXoaoY07y8wkI/C6JZBHKcWFIpM3lNJdH7FMT64Q81obCu7NXvZFYwnJSLg5LaqWe7pvV70191s3lFiNpUTh4aGLGv3G9g7hs2gjUzx4S357cGVOhKqGrP1OsiYIDnk+IuAXv31/7dzJO0qYvKoYUrFe373Kb1p0NmHP67J0boBNiGK5SeS1eaQMWFXkExtLM0dAqy6ZmtzCdai5qWyOJjXB
 /1x7VKCv
 U6o5VRiyVIBA2+VUnU545ERfUjm+rYcioDCUn5Tw0tXxrMzYuji/2H5TWckun++VUfIpyPhFM0x1kwhpJrS8UzAv1qIM2ONpv0gJGPl9moxob0LlvzNQHllrz2hO0acqj2pcdBhSCiLC8K2Z3IkjkJZC0bBCNmWgg/23tmbavcunUNI8oI81M1XxXRtw2d+b6tAUC0azfJdjkRNlRAI2wW1q5+JQtpNK9+HvaFyBDB12AZ9ijY4PCry+gGFsWY5xzqbvAy9YAsKVc8ghNPf5VQq/BVdHj+hLgvKW5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

riscv versions of set_direct_memory_{default,invalid,valid}_noflush call
core CPA API (change_page_attr_set_clr()) that actually flush TLB after
the page table update.

This was also the case before the conversion of riscv to use generic CPA
core, riscv::__set_memory() always flushed TLBs, even when it was called
from _noflush API variants.

Switch the _noflush APIs to use __change_page_attr_set_clr() that does
not flush TLB unless there was an error or there was a split of higher
level page tables.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/mm/pageattr.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 677f42a6750d..66a20fc3d805 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -199,32 +199,46 @@ int set_memory_nx(unsigned long addr, int numpages)
 int set_direct_map_invalid_noflush(struct page *page)
 {
 	unsigned long start = (unsigned long)page_address(page);
-
-	return change_page_attr_clear(&start, 1, __pgprot(_PAGE_PRESENT), 0);
+	struct cpa_data cpa = { .vaddr = &start,
+				.pgd = NULL,
+				.numpages = 1,
+				.mask_set = __pgprot(0),
+				.mask_clr = __pgprot(_PAGE_PRESENT),
+				.flags = CPA_NO_CHECK_ALIAS };
+
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 int set_direct_map_default_noflush(struct page *page)
 {
 	unsigned long start = (unsigned long)page_address(page);
-
-	return change_page_attr_set_clr(&start, 1, PAGE_KERNEL,
-					__pgprot(_PAGE_EXEC), 0, 0, NULL);
+	struct cpa_data cpa = { .vaddr = &start,
+				.pgd = NULL,
+				.numpages = 1,
+				.mask_set = PAGE_KERNEL,
+				.mask_clr = __pgprot(_PAGE_EXEC),
+				.flags = CPA_NO_CHECK_ALIAS };
+
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 {
 	unsigned long start = (unsigned long)page_address(page);
-	pgprot_t set, clear;
+	struct cpa_data cpa = { .vaddr = &start,
+				.pgd = NULL,
+				.numpages = nr,
+				.flags = CPA_NO_CHECK_ALIAS };
 
 	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(_PAGE_EXEC);
+		cpa.mask_set = PAGE_KERNEL;
+		cpa.mask_clr = __pgprot(_PAGE_EXEC);
 	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT);
+		cpa.mask_set = __pgprot(0);
+		cpa.mask_clr = __pgprot(_PAGE_PRESENT);
 	}
 
-	return change_page_attr_set_clr(&start, nr, set, clear, 0, 0, NULL);
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC

-- 
2.53.0


