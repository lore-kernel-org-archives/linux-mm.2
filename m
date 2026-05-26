Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74ED5CD6E42
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B286B00B4; Tue, 26 May 2026 13:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4B96B00B7; Tue, 26 May 2026 13:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290AF6B00B4; Tue, 26 May 2026 13:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1056B00B4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F0D3161617
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:38 +0000 (UTC)
X-FDA: 84810333636.08.A2DF5D0
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id B4CDD40006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MzvKPSiH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3h98VaggKCPQWnZX+cepckkcha.Ykihejqt-iigrWYg.knc@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3h98VaggKCPQWnZX+cepckkcha.Ykihejqt-iigrWYg.knc@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hN7dKQgvYd9nbZsuBceB/G3FfRSci9s4lIdLcy6NsRQ=;
	b=pgoIipyBousLSKtTDmkjoyRb0lDwRbr1UlBAPx0vktz3uzxAJvz81udh8OA+Bg17Y+WY2y
	EznIAjhBFxitPunC+4+YbetTb/8Fn9Gga29SlUtSL2creXh8ED6+8mXMz+7eIDIJfRv/+a
	h9+Ei5CDX1jo6n0curToEoi4tj+cWps=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MzvKPSiH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3h98VaggKCPQWnZX+cepckkcha.Ykihejqt-iigrWYg.knc@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3h98VaggKCPQWnZX+cepckkcha.Ykihejqt-iigrWYg.knc@flex--ardb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818376; a=rsa-sha256;
	cv=none;
	b=lxbNIv7Y2TXFBi4Q++tMqbftsHO6m1WxZWRmMWAjnjNMZM7RLoOFmaMj8xpGeqx8gvTp+n
	lwbZ2falAMRaw7ixdBK4D9ALaHM7hUXSJqrFxnlMGKMgvhoWhHxlOk1tHbfjxPAYjAnj3l
	p2XYxBMrOSnIcgdIF8ZEGgtAwXeMr0s=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4518f777225so7724291f8f.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818375; x=1780423175; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hN7dKQgvYd9nbZsuBceB/G3FfRSci9s4lIdLcy6NsRQ=;
        b=MzvKPSiHFQBcc1PGhF47mCzWOMFymKRckzNpZcz9wlH4s85pKepzYSr6VyMsVRN5nZ
         ZMEC74ZdFKkHF1rQ5K7fOua+KDSPCxi9mM57qVN6iZLMAcnr/UkOjnFo8gBLD5Joh1yk
         s6OJH+848jPcPSmhp+eXQ/or/xk/YJ3RVafG5XMmJGACPd/8YOlNJ1DZxenXQ0cOOKRQ
         2Lzl6b+Uf8UQYd8J0Qg9TLbPBQhI+b13kyaatgnBif7stEaTENxQz5dvZQ6CgReSG9+Z
         uBhIxXqDuEHETnIKY+uhUsX+lFbdKTI4itge7pVmWJGj/CyyfnWlIflRupDv5ujCdh7w
         6Ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818375; x=1780423175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hN7dKQgvYd9nbZsuBceB/G3FfRSci9s4lIdLcy6NsRQ=;
        b=PyzHMxoF+FhUiEIyaIJNd20NXhomlvz6BTyHUNi06HTrE/mUIl+FcES5+sdnUB8+8s
         MlEbxLBrNcSJxHXL6dzOp2mnexvo49W2CwzvBMpvAF+5D2ysL0+3lEHm/KKVbJ/ZjacC
         P8oa1y4HfNxGQUMe3j2t3JtZ5vwFMNNuNAq+WFRDxImOe42+xyhWh0wFYSMyZ43HBLIi
         59Q+vVH4VSnW4JP0JISX7/RbQdanWAo6r1EOsAAuPxzTsNVvW1a2vgsiZcRUtat69pgt
         Jp3200MGKuO8z2LKllctK4edshRLtLdCkX5zHo1En76KtK/NRr+BfLDysz9/gQCpGlrL
         l5sw==
X-Forwarded-Encrypted: i=1; AFNElJ+g1D2XmkZAUxXJiFlNaJ0l09Dcu8oYH59Q+p63+9Cm8MyTIBt4pvh57D7uPLHIilKGQae1IBq4vw==@kvack.org
X-Gm-Message-State: AOJu0YyDdGkEonBJF98Vg5lrhxUhe4UyQX/nivD+3dovGwYdtfTk5tIT
	VhlrOUxwrOLz9xtZZUsD3dYZeYCQno/SRqgKvpNv2OL5XQHra1GWhfqO+574MLyG54k+P1I1qg=
	=
X-Received: from wmrk9.prod.google.com ([2002:a05:600c:b49:b0:490:7e29:9cea])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a402:b0:490:3f7a:108b
 with SMTP id 5b1f17b1804b1-490426c5be8mr278139655e9.16.1779818375139; Tue, 26
 May 2026 10:59:35 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:58 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2428; i=ardb@kernel.org;
 h=from:subject; bh=bcrl0Dq8YQBZ2y6oSLTxv/uZS/MgfYTkD9gOirfShVU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fppn5XvTONsranx8M7mVQs+XJQdo2RuuSWq7JaMf9
 7fh7PqOUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJEXcowMtw6WZR/exrN7YplZ
 UMhusfI9n1W/fnxWF5Br8bb/o5j6XUaG9kh5ycXzfXi7yhR03u2bYfF33raUQN5POWLfbh9Jdln ECgA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-28-ardb+git@google.com>
Subject: [PATCH v6 11/15] arm64: mm: Map the kernel data/bss read-only in the
 linear map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ikob7mq1qkqteng3gjzbuemfm5xt39di
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B4CDD40006
X-Rspam-User: 
X-HE-Tag: 1779818376-351384
X-HE-Meta: U2FsdGVkX19HV2FMSw3+HGxFfV3Z0/VYgEvmLuXB/VHmPvyJ5hRpcyOL7OuZwO483V4EBpOphrzpuL2YFpYX33cLlnIeXPoGqn/QMk/CKe6Cbv3b4jR9e5GYRCTHjA7wYEBf73bzwbRYgcsvEZA7PvMC/H/mXC2c8prZqMHLTIGk7vl/sMA+AUDvrwUQUnJQP61U+g36bodKIFMg8GzHotP7K3CK0yEiyDaAhzgEa79fUsjgLE+nG3aet6iMsr5lTXZBcE0okitv89LUUhItFZNgolp1vO7BCYjYxp59j39CU5LxKNni4CfPClslt6FFvubsgvdk3Fg7gInHgHipHtTDjnBaRXx3JPqbbysQEW2/oMy8MLgpPnK+/OPamgKTmNfuj+AQJX7lR4OfyiZq6Q5NtOiRQibjhgr8G1tVSOI5YchwvWycR7txxR8udxuittL4UKimPOC2doC07LVvOpMD8N1kp9jlH52BKTpz0V9mSilF7Tg2iWRGFROJ/I5MMSUxhC9n6OxM2Cdhw6Ih+Fc8VHUBOcQhUC4AIW3mVaZSJNGoLCuIsBfffVszqEV7xpGFHRSSuOuXiieaQsKKuJqlsd+F3ZI+5XRXfdgTc+ojex2qIpxN9fy0mfrTBZZl2geO6js9tXDsca9HFuvTYjVHpBgwkfimqClNDeEa/k77pKM2g+P/0WidQJ4XGrDm060COUxHpctEG+sNzYpVCEDW4BT0TwtIVPUNomm1U91WWc3wbMjJIbggFdIV1BHkMDuL+6/G63M7zGomggegn3B2AfwExKxGgs19VF4haPk9Hex5JSktBL7eG+haAC7H5/VJ46eqVtdMVzzbP3/ILBuurb55NbRIPmVOCkjq86fWnn8ow8xHAlgGYWYRoePxIIWSTNiz36D5EPRmotgnhO5A8qvwDLH1Iw/XcvpjE3Fhj1uEsSnvt19ywhjhTeLsE/mNl69rKVI487QjWCH
 OFo7fAx5
 3Gkpx5f8jI3Xtkw2egfVE7bDqxsDcfDck8bLIZLgjqt0qU4BRaX+5LzNk7MorrGYRa9anS1lr3ybew+bt/kiPyqi3d7AZ+fvx+Idx5K4E9jszV6KfwfFVQBFRsUQx+KnWuRHu3K6PmeLu2GkZnvlxdyLsuQXGCgHp3XxAeG6gPqswjnpSr9PlHQJ5x+Gd1JnIqsPpVNFPhb/T0l59vO/BDrOUGTBh26klbC+oE9XMtdf0L7UNwAWLFBKjr9if08LvaPYBLiZVYUm8iQcPIkmmz9Bo0MtzMb6Ce3GA+Fg1gCkc9JPvtR9CZ0Ts4byhBN+dwZPkSv3yOiqIEEzATa8mQTOVgXloJc9OvdehVGP23wdUWbxLnABS2CeVMkQ8uPfUtsoi5vtYJbLB+tSeYI94T0hpsIu8ygjO8jXFYurqnB/Ypatx5SHkYXrGWs+pwl0rnqN4yMzJOMGZ5w8moYcqMeksSapGmr9PnBkukAk6EIi0RGMx+7dwLgjqR6N29ShSicwXvvugk9zkU4GtztRPdY7sNTsrMCSLxH9/q/UQByOVFT/h+HWzr4oMfHw741oEDqq/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

On systems where the bootloader adheres to the original arm64 boot
protocol, the placement of the kernel in the physical address space is
highly predictable, and this makes the placement of its linear alias in
the kernel virtual address space equally predictable, given the lack of
randomization of the linear map.

The linear aliases of the kernel text and rodata regions are already
mapped read-only, but the kernel data and bss are mapped read-write in
this region. This is not needed, so map them read-only as well.

Note that the statically allocated kernel page tables do need to be
modifiable via the linear map, so leave these mapped read-write.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b20c76b8381d..e7ca53d20b87 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1138,7 +1138,9 @@ static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
-	phys_addr_t kernel_end = __pa_symbol(__init_begin);
+	phys_addr_t init_begin = __pa_symbol(__init_begin);
+	phys_addr_t init_end = __pa_symbol(__init_end);
+	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
 	phys_addr_t start, end;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
@@ -1171,7 +1173,11 @@ static void __init map_mem(void)
 	 * of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
 	 */
-	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, flags);
+	__map_memblock(kernel_start, init_begin, PAGE_KERNEL, flags);
+
+	/* Map the kernel data/bss so it can be remapped later */
+	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
+		       flags);
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -1183,6 +1189,11 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
+
+	/* Map the kernel data/bss read-only in the linear map */
+	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
+	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
+			       (unsigned long)lm_alias(__bss_stop));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.794.g4f17f83d09-goog


