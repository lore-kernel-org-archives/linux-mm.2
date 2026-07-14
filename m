Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD92BC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008BD6B00BF; Tue, 14 Jul 2026 13:25:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4A46B00C1; Tue, 14 Jul 2026 13:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D727A6B00C2; Tue, 14 Jul 2026 13:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 854D36B00BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:25:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D14E6A0520
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:01 +0000 (UTC)
X-FDA: 84988057602.20.2C116B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2BB4010000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+kxTrnX;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYfKvJYN8Ofzx4ZcF2C0yaTq6AqCLt0T09rDQbFZEtU=;
	b=cEmxuJAW6okY9o+nvRfvtDSavYlZaZ+zB0pZvu05Gp+PV4sBBV3lROMidKR0V1CBwqxt3Q
	iI4/kPYgDqcn85uPNY0NdBplgb1LLuXRl/YKwDTST5sXVN0NhwFTfUOuoFHaNzhSFXXoDQ
	D/VJnOL98yxZgi539lccdKa2ik3cw28=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+kxTrnX;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049900;
	b=X31pRrMcF+WQY3MUyFSVrHCYh5dtylpIeOgP2WC5X7wCencXPhGM0ja5wH0YstYBFCtmdY
	s7g1d5cRv9ab2vz7HzHULpRbwvk7mzE9SCt+UfYitFRk+LADKnZCVDYdHjhc9mDvvBMChz
	TKzeOeusG6BmJqpI1StXulfyQgXWdYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A00DF601D9;
	Tue, 14 Jul 2026 17:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DF91F00A3D;
	Tue, 14 Jul 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784049899;
	bh=BYfKvJYN8Ofzx4ZcF2C0yaTq6AqCLt0T09rDQbFZEtU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A+kxTrnXg6Io/GxtciuQ8gUMV/UHNsl8xfZDXmio287Uq1eq0AB/sirE9DHnMeL55
	 spsQknwWtzixnvri9S7+b1ZoAHYYaoFXquGjVStimNk5YfB9wHH/WVtgglXU3m54/D
	 7HYTFusEKpmBvCPbd4aZRaHdwPEMj/1rc52yjuPKNBmynU58cfrjReDxBCNQAsOKf9
	 l2V7BFZBr3kQwXUAKTXb9gQvLFdPLqECx0sI83DZqFtL0EoaGwK8xDcM5AGefLIoII
	 BpcW0cq5ehnHH5qa1pzpq2VMVA3bIawmGGCJt8ifvxADVJGyqCLUEF07ptVJjY1LZi
	 IRz8CTEyXAAGg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Tue, 14 Jul 2026 18:24:24 +0100
Subject: [PATCH mm-hotfixes v3 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-series-vmap-race-fix-v3-2-b812eccfa0f9@kernel.org>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
In-Reply-To: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2859; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1IRMkBuBSJn8c0dhLGk5dFenOrN5JSkDTuylzdcXQUQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLCCs6x5etcWPDhb4c5X+Hv5b1Xc349/WTx8ort+4YT0
 yXsZVYt7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE9j9m+B8ld9rf4Hmdcmzz
 8kB317VWRsGfPI89nX/E8NeTTrmkaE2G/9HXsroSfPSfSCpkf2OZzvbr7yzG+tCfR6s18mKfGs9
 OZgQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2BB4010000C
X-Stat-Signature: 9tezwx16rie8jcr9sjcm9bah76k9smf8
X-HE-Tag: 1784049900-857974
X-HE-Meta: U2FsdGVkX193v9fmW9yQJPqqIKcMA27LCl4SDSAePjCFE4WPnNB0f106ilrFtQyD6nfCN3LTDVEZrQRV22ocMS0WIGy6j+enY32DJrp7orYrQHi8gZz4W9wo/bksqimqMWwg0MwT40hOiUU3PzL9IprUj8aE5unnxkbN1L2GsRIRDz/AlB+j+vKbW+8LCRkUuWbP66+GZOt0cX14hdOE16KR2aHkTy69g6JeqkIlnDZgUIHvWMm96AxQ9tfZLMj5qPq/wjAUyGUnqfrXtE5cezOwTKvdOujhO63TGDJhAtFIt3kMRj1dfniiLoZPaxHGgpko9i0bvhsCk7aXMcDfXfKIZz/uQKwEbQkbl0DQ8CTViut/ze1TfBb9ooJuQUzkL+VUM7DXWPGPFr1V+z+OMIRs1mmPBCpxO3ymmTLbX27s4ePPSuFQJVdj2+MnwXirzw4HintLDsJS8BonNmVwd0oKQvBA0r7Xt+Ked5ABwyvrF4YLTuxioEAnpeOUV+45PyKfC8JlmG4HPDHPoYFmvsZCKnW/V2fu9cfResgfLYnkm02fQSvC3rZt9mKHzHGYbbytmtFg3jjt/dBDeZX+1addh4vFTGWJD4Abv/u/eChuBpGD6WFtwIOa/UkiPbHkZ/lKbE7B0Gco2RJP4z+9BDtJUW/ESkMkbPjnluzuNQOKRSGQBZCDZOxpIz2VLBRGC33EVtW9lxM0fLhv75IU3lesKIhAITW12Wdmi5w8GvHlnUAZlQDMleYrIyNMfHebj8rb6mSPpfwod0I/vHjulY2AQ/8cwBX6ApbbUSV6QkAJSU6xRZETF31wlgb3pxYHwNRQ6pp21EhknWCv8Sv5YUak/8kuXkpjXqmrpZT3X7pjGRiM5dDLGrhKEh8WsMfFvTokIURWtYPqriUsGuYBy0tw0RhO2Z65smBbOxt17KdW3AUzNz/xGZe5lj3JUTcU9BGx22KTbZhTjjYgYCn
 AuxFPByh
 yaUhNuX2diRPBYY0uQy/yW9CeUkHxzAaVlH2eKCuticzEAATo3EOGwJdtAI8nYtLBUt2q+EiusBs58kUx28pPCJsRZ9cflyEH6wVRbqSDH8//j8NBHuu/NBFvlXAAmN85kQe+bB2vpCFA+hFYig1sSItBtRPVyoYfh4dCr+pr4RkJXs1h9OT22mCrm5YypHWIrmHUBRWsqUPQjWbS3sSmVIHaZagNAVZu2sSPo7M0yI3hCsqkZh8EWoZKOe2t/n2oIrOUv1tleG5drLduEHZ7Gr9P3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86 implements page attribute modification using its Change Page
Attributes (CPA) mechanism.

This tracks properties of ranges such as cache mode through x86 page
attributes, and as part of that logic manipulates kernel page tables.

Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
fragmentation") ranges of kernel page table entries can be collapsed into
huge page table entries as part of this logic.

As part of this collapse, it frees the page tables which the collapsed
entries previously pointed to, and it does so without any relevant locks
being held to preclude concurrent kernel page table walkers.

The only way this code can be reached is if CPA_COLLAPSE is specified, and
this is only set in set_memory_rox() via:

set_memory_rox()
-> change_page_attr_set_clr()
-> cpa_flush()
-> cpa_collapse_large_pages()

Notable users of this are execmem and bpf when manipulating executable
mappings.

However, this is problematic for ptdump as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

Resolve the issue by acquiring the mmap read lock on init_mm which prevents
a concurrent ptdump as it acquires the write lock.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..4c4b8244502f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -436,9 +437,16 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	flush_tlb_all();
 
-	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
-		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+	/*
+	 * ptdump might read these page tables, so avoid a use-after-free by
+	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
+	 * write lock).
+	 */
+	scoped_guard(mmap_read_lock, &init_mm) {
+		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
+			list_del(&ptdesc->pt_list);
+			pagetable_free(ptdesc);
+		}
 	}
 }
 

-- 
2.55.0


