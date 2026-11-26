Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C757606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U1VVpJka
Received: by kanga.kvack.org (Postfix)
	id 56ACF6B05E2; Thu, 26 Nov 2026 06:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5421D6B05E3; Thu, 26 Nov 2026 06:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4577B6B05E4; Thu, 26 Nov 2026 06:18:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 270A36B05E2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81D841A0F9D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:33 +0000 (UTC)
X-FDA: 85477022106.03.0C46C6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D6D9920008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1VVpJka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691912;
	b=INdtwwhZzaE5lW6zV4FVXxcoBJAiyYOvm8ST5nQck+cskh8FYobDhGTotyRdG8J7ZO+EFr
	G383frnpV4dTP5AXzEJ+4Ig94n7lqnoyECbf6An6znp/S2R7XC/tKBRrAIk4XjsbDL6ZeS
	1zzOIj7RShTmD8KyiIaSIVfxQjSGels=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kg22a2UjYNlx3KcEJrs5W+VCDk/0O6wvkANb+XJaCbg=;
	b=h3QNkdlpNWOOfDymgmw2Uk+6mlRzRXE6S3o9gmchlcxxzW67Y2lwCIw/IrPV7ybDl0SX76
	+0KJElLYZU0FB5lzrHKJVwjL3RdDJpJvQzF6Is9fF/+Jj2hGu1H4kNwQZluVEfolTRX/De
	zcx3+e4wWnKaUfmz4axYMm9ws+pw6mY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1VVpJka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65EF760D55;
	Thu, 26 Nov 2026 11:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CEE1F000C6;
	Thu, 26 Nov 2026 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691911;
	bh=kg22a2UjYNlx3KcEJrs5W+VCDk/0O6wvkANb+XJaCbg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U1VVpJka7QLxUE4YaYREp3+OZWOG8ko4HiNqynewu4AeFyUfHQhn7brmfvorU4jMj
	 o0uUS0QKMHz7GfMKQUvJ//XlEAtzumhJGgjIerOXA4rAWfrjf94Lowsrzo2OyspNRk
	 DVyvxbUGMXY0K3/SOKAXMB1cBBC2Z/1CexvNi+4DB8g4a3/OjW2gS8R85cVmvy+69O
	 qZUhYEGVTvL2AxEnooJqUb6ERwdNe/eEjnNDxMWp5QYBqFBgbBXumoo1jNxHCpRuXl
	 WfdpzZtlXFLcqOaW/kvqMfWLQkJEJileeskY9GGqfARZEurJKKDSbEPqrmKJnQ8b4h
	 uPm1ZG1WRQisA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:38 +0200
Subject: [PATCH RFC v2 25/54] x86/mm/pat: add cpa_is_direct_map()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-25-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Stat-Signature: s3aoi9ywyotu4hdy7s5dtobszgkxodf4
X-Rspamd-Queue-Id: D6D9920008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795691911-929265
X-HE-Meta: U2FsdGVkX185h0tp2RKgFL5qJEUlgeOIMK/6Vyb30XLHsodvYi43Yb4sZSbfJDquP+2sNVHYYC7b5rlO39QuXZRy0XTiX/8LQGX7tOFFSRKpawY1S43CidhQuwnQBrfxE2cwu6N8WQQWFhZ8ASkCD1o6Cpsbzds/XPW007zCk8Kt2ON8Gk1Fr/ykpDFAnpa8LJ/02w58ysNTYNGGNoXXf9mqFTUN5lstNB40lHXZJpSjoCYI58T63NIzGbi827hlJ96pAfSZ2ouwcGlLEaS2+dNRCEJFZB4mnOIBtXpChSpYFbpx5lcT/OyXPEc9GwwJ6jJBc/1RihX9Iam1h/dlo2CgKEmDC/qtreFlH6ok37gtTHqllEdVvJU5uYHJSMGCTQVwMKl4/HxO1xcF27MOdfRWjDOM0l+bZ6ZSHkTTQL8Xv+vXac1Z8Q4O3TuQvIx9XyI6cnkYyaFDtNc/umkZLJYbt/+jbdKbJUCHtJb24Da8q3EK6z78Qz89AUHfN9QtaQVoLrNKyModYMPnpkGMCQNKNZhkt4XxaqL/V+nSJbSHItp86/I1Bd6QS0WM4MQbIUHTL431BLwjCdOcB42AZcBdxwhFuXJoK1u8HJ2KWl4bBlsmI3Ib61YF62ebhAjwZZzYXfSB480Bwo7OovY8bLMerNbAw2Xs8rmtbSfVR/8IZXpoXtfbNN+UMuuhyc3QsQS0N11COlSvpwU4QqC13NyiwNpgL3+kciHc0OWskdc1PKgJOXAbX44m7f9WaYFLFmMpKVS5rhR07jM4gXk5hsGbbmQAPtPD3UVnfw9i7oFqfZQV7/LDy0jA8vHj5xMY4sDcBlCzjIVDhGdnSG5LmDiA4qHTVqqDCDz4w+yIW3YRoq5DKN8MRfVIX5jWZYOQec4t5QmOBgpUC3nX8OoV9xVzXlS9FI/EzPcDHmKG60f4DhfbZEky8Id3qyXouYXHPgkiZdHPIs57ZWCm8bG
 bGxOFBOk
 dvhdr4chZUvLPEPzanNZ+lD9UZh1t+8NqO5bEpTkVKP1J3Wdzrs/VmVN9qdERkXQWO6X7Hs38Yj4Halm+L8/1qPsWMZWxlZRxKamsjfkFb3DilGFRCUKwiKeBaaOkPcWXS92Y4aRoU38+eaJYPGdac+ksdYQLYTF46yooI9N4bLd9fIDYXStu+AfwuUs3+IOw738Cq6UKnUOorKvqCGXuHvl59Oi71q9C9HJHg1rc6gNHwAmRsSwAtSOyxVJ8NBSR+KzYKVA4+Qv8PVY+qOzT850m01usNnw3AEWlnvzHcp9e4x3nfeBq88Lwf/zsgURdTvlWNrmPx2qJ+3IhY/CYRtcRXuiNQbRGSJDTdGThEqFBBRW8OMfLxWwRv2miWPw8VnOXC6DDATl1dTo1lig9U+GQw7px4r/44rrT4nV2+orQGSybmIBigF+tOq3afCFedwWRTG1Ys+cXZQgUm6D7IL30+scTMGrfmOQepAby3icozOa7SUZDQyOoyfOCfdO1dWfwCyCJjtXaC34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CPA open codes the direct map range check in five places, and the generic
CPA core will need the same check.

Move the check to cpa_is_direct_map().

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index f4d3e2d9c3c9..cbbc51be4de7 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -245,6 +245,12 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 	return addr >= start && addr < end;
 }
 
+static inline bool cpa_is_direct_map(unsigned long addr)
+{
+	return within(addr, PAGE_OFFSET,
+		      PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT));
+}
+
 #ifdef CONFIG_X86_64
 
 static inline int
@@ -1224,8 +1230,7 @@ __split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(pbase + i, cpa_pte(level - 1, pfn, prot));
 
-	if (within(address, PAGE_OFFSET,
-		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
+	if (cpa_is_direct_map(address))
 		split_page_count(level);
 
 	/*
@@ -1375,8 +1380,7 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 		}
 	}
 
-	if (within(addr, PAGE_OFFSET,
-		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
+	if (cpa_is_direct_map(addr))
 		collapse_page_count(PGTABLE_LEVEL_PMD);
 
 	return 1;
@@ -1423,8 +1427,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	list_add(&page_ptdesc(pud_page(*pud))->pt_list, pgtables);
 	set_pud(pud, pfn_pud(pfn, pmd_pgprot(first)));
 
-	if (within(addr, PAGE_OFFSET,
-		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
+	if (cpa_is_direct_map(addr))
 		collapse_page_count(PGTABLE_LEVEL_PUD);
 
 	return 1;
@@ -1887,8 +1890,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr)
 	 * one virtual address page and its pfn. TBD: numpages can be set based
 	 * on the initial value and the level returned by lookup_address().
 	 */
-	if (within(vaddr, PAGE_OFFSET,
-		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+	if (cpa_is_direct_map(vaddr)) {
 		cpa->numpages = 1;
 		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
 		return 0;
@@ -1977,8 +1979,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * mapping already:
 	 */
 	vaddr = __cpa_addr(cpa, cpa->curpage);
-	if (!(within(vaddr, PAGE_OFFSET,
-		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
+	if (!cpa_is_direct_map(vaddr)) {
 
 		alias_cpa = *cpa;
 		alias_cpa.addr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);

-- 
2.53.0


