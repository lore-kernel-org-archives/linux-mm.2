Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0FAFCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6688B6B0098; Wed,  3 Jun 2026 06:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615596B0099; Wed,  3 Jun 2026 06:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504DE6B009B; Wed,  3 Jun 2026 06:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AED26B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:47:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D899DA0305
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:47:06 +0000 (UTC)
X-FDA: 84838274052.25.12A9D86
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34303A0010
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:47:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rOGK+hjB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDivKNl50/oglC97Ig2qp3GHfbl7ogmTnLA9RISadv8=;
	b=5Kc9GOKmTEOeaYEDlOgZq0aUhyNMk5BrPAX750o8tak+RLUeI+BxBK1FMakX8uzg7o6zuu
	Mai9KbLrrRGZCDgGur6RswBRWDqrDiuBrVOPb2lpnZAEHKSBS1KGQg57LVaQMQ8WmnwcFO
	sddkspQ8NveDxD5sn0ki1kmcRWl+uUg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rOGK+hjB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780483625;
	b=F7UhzzD7i9L5qBBA5BSvjElIOCgRT/PR9T1fYKbDnAlte3977b5rIgol5rWxf51GMUBeu4
	rDet0BMrMhyzV3kC8mWAT7zaE3qOV1wZ8pIUG4sQ12Euafiq0bMy2CTqYax4/5jgud1fI5
	zztRgJuPzPMUM2AEF2NXY9K8waKt2Xc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780483623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uDivKNl50/oglC97Ig2qp3GHfbl7ogmTnLA9RISadv8=;
	b=rOGK+hjBTX7M1kHbQ2XvvKqnp1jett+Tj8n+9qKo5Zv3H4e7/UqA2vmrI/T5yoFdeZuONF
	s03n+ItMVdgigxDknLtYsctpJUmvx/njkgApQzgszPqIMOlLBj8XDhudjTBEYQHD+s35v4
	Luvt6hhSwL3O36lOBXhUgAHFcCyOKYY=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: rppt@kernel.org,
	david@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [RFC PATCH 2/2] x86/mm: restore large page mappings for secretmem
Date: Wed,  3 Jun 2026 18:46:24 +0800
Message-ID: <20260603104624.36390-3-lance.yang@linux.dev>
In-Reply-To: <20260603104624.36390-1-lance.yang@linux.dev>
References: <20260603104624.36390-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 34303A0010
X-Rspam-User: 
X-Stat-Signature: becuc65ibxx61zyqzjansgheang3hge4
X-Rspamd-Server: rspam09
X-HE-Tag: 1780483625-976934
X-HE-Meta: U2FsdGVkX182eamgoIjI6g5OD83Dv67mxrcOjtKww8dqgqUISxgYp04YtBMeVym2dlzXBMbZHsWXA1G/gbfiuzcRQ0ZxlNg0L0D5LL3sjtkLQrEgHRqgaQ61KESyNk28Pww3g2yqpAYglLqoYCSWs+QVtMPhuokmLJCSNM2hnVKao1TxG0RPARE/pylcPvFfap0y+F+N7TKyDMfuqeluiES4oGFp506ojXyQZ8z8OWNl0JAVDYivSvYNV/6Y8V5h24sOskiC6xEi9F6IRJOW6MVMMVivV9bz6u4pd0sRt0XY9j9jKm5KSvm3SWV3tEnlBlizosNRuv3raM0XLN5GJyXZ765IO9YBxx99yTE4LrBFm0BFQ33UpXveqJ+wG/R2d2KUDVuMToPV25iueDJ8SsA7fHXcwHbJl9HlD7cRWNiJg+836GRmuBDhuLphuRMRxy5ppz1ZEAWaTiwSrc/LwemrUp4yRwPtmCBoSVVAy+QIijBcTIuRSE2+KFEhnpsnBmIuK0ZIJKCfIH8495H/liHs7vQKpbPasEFn5xTqalolS5tBDa0orPnSng4m+boP2tej9mYRPu+rsGXQurzUc7UtNxJqa37cZGv4iUHLTpzLulesAVqnWTChN8G+dfJ8Lig/pHS6v0smFf0ybP0qKOrSm5HqPNUwpRc9DGsCkRH6ca1WXo2AtDyf9NHderjy86HiZSf1tPVvJvoc9RDH+1k5o1c50jBc2Re6QB8a6r1fZPuMp5uF7e8WI1nYcAp7nZ+pLnCyLYPQHTp1A9UNCoxiW+cPZYon6B4tMuI0KTcU7dJPQZF2EiAk4ZLFOB/fmA5U2VGTogbg7SDjGWi/M+KpcTKxzfZ+Bo1FNfoOV84P1HbQ2ATZtQneqXRSVhN/PjiTRyToGCOq8EbX0uASHeQHKGwV+vnjJ+uSFYF0PMrsfcFFOWx4cGMPE60GwVVmuSGYkfKafXJ1QX21Odn
 0eIdAGLI
 jSvqxjcoSowp10oI3443fYy4oZXfv5h7OncMNx/SiSTSpBzn1+08B8t1XwBVOmJNZN2q79dBMt5CgBFBI5csgHWWgxamRpQ+8c11QEUz4LavnRDhKEELbNWfOMqmBSpSAlH7B3f0q0LX4KSw6Ot4N1Cc6PHCTl6auYacaz6TCVBq09igPbcTS+gHxx6Dr51MqmPoIw9r+R93CfcyImqqh0sl2F+q4W0NcdpyYI1/DFi/midOTslw1DXhmZPHkC81V0Ko4nUTQqQlXRmanlaURYQpfd6f0JWf7RrK1Gk/zJ837imU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

secretmem can ask the architecture to restore large page mappings in the
direct map after a page has been restored.

On x86, set_direct_map_invalid_noflush() clears _PAGE_PRESENT, _PAGE_RW
and _PAGE_DIRTY through CPA. CPA also clears _PAGE_GLOBAL after the PTE
becomes non-present, because that bit is used for PROTNONE.

set_direct_map_default_noflush() only restores _PAGE_PRESENT and _PAGE_RW,
so the restored PTE can still differ from the rest of the direct map. Put
back the missing PAGE_KERNEL bits before trying to collapse the range.

Use PAGE_KERNEL so the restored PTE keeps _PAGE_GLOBAL when PAGE_KERNEL
has it, and does not get it when PTI clears _PAGE_GLOBAL from
__default_kernel_pte_mask.

Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/mm/pat/set_memory.c      | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..f9e94bcd83df 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -89,6 +89,8 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+void arch_try_collapse_direct_map(struct page *page);
+#define arch_try_collapse_direct_map arch_try_collapse_direct_map
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..b118619fa83c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2654,6 +2654,33 @@ int set_direct_map_default_noflush(struct page *page)
 	return __set_pages_p(page, 1);
 }
 
+void arch_try_collapse_direct_map(struct page *page)
+{
+	pgprotval_t mask = pgprot_val(PAGE_KERNEL) & (_PAGE_DIRTY | _PAGE_GLOBAL);
+	unsigned long addr;
+	struct cpa_data cpa = { .vaddr = &addr,
+				.pgd = NULL,
+				.numpages = 1,
+				.mask_set = __pgprot(mask),
+				.mask_clr = __pgprot(0),
+				.flags = CPA_NO_CHECK_ALIAS };
+
+	if (PageHighMem(page) || debug_pagealloc_enabled())
+		return;
+
+	addr = (unsigned long)page_address(page);
+
+	/*
+	 * set_direct_map_default_noflush() only restores _PAGE_PRESENT and
+	 * _PAGE_RW. Put back the other PAGE_KERNEL bits needed for a restored
+	 * direct-map PTE to match the rest of the range.
+	 */
+	if (__change_page_attr_set_clr(&cpa, 1))
+		return;
+
+	cpa_collapse_large_pages(&cpa);
+}
+
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 {
 	if (valid)
-- 
2.49.0


