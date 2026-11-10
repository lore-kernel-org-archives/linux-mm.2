Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A8C606A327
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qC2lCYTq
Received: by kanga.kvack.org (Postfix)
	id 158AA6B05B1; Tue, 10 Nov 2026 17:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131F46B05B2; Tue, 10 Nov 2026 17:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13C26B05B3; Tue, 10 Nov 2026 17:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D28036B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FD35A7432
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:19 +0000 (UTC)
X-FDA: 85420712118.13.A8E0FFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94A8FC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qC2lCYTq;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351197;
	b=cUaGM7JE3DEBqg3kASonCryXI6ztz/zCf3BFG3gRg7EFjJoWZXOQoEQgdr7t1eQqb9XYLn
	h5zXaZpddHq+XtpBrPmi//McMTZKy/C5dHK8QzcTqhZPmSOcVKIbI2GwgfDXlrP2p+NPU3
	CdNgMtqeuAOo5scr6/P/QkJcMUigSCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YKuoqwoAaPxLHaoVZKbkD8zKUqjOEfcUIp+jI3fn2M=;
	b=OyOYSuE8rZR4XZE0SmOaMIXIJVsuAmlFfsJkbhFIK4k8ptLk9eZkPc+WVLKAiIBA/3YUXh
	kgiRPehH/KbNkCUXnwM790u89CSw0RlRyAGouHk2ay/COmqCQ7se/wVGwDMvlybYXEviNL
	Bzbxgi1PN58JNIBZP9DcbvMDyVIZs2o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qC2lCYTq;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADF1A1BF3;
	Tue, 10 Nov 2026 14:53:13 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84B6F3F85F;
	Tue, 10 Nov 2026 14:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351196; bh=nxj+Mt125iEK/vat1Tr1w2hJbRHU1d6dQuW9cP6e4wA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qC2lCYTq/rJbEzdyRKkRwJUQURHuUI0KlvkUZdajSZbzywIaWhtpF+g5BCsYk2eFb
	 AFDB3nbHuiYRZAn+DKiNzOiuX6+BPdZ8RmE3J+GGgIiucODHG+M2149Cabue1EGTY2
	 POm8af7wiilC0sVaK7A6WKcVoRboDyWwUr/jpKf0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 10 Nov 2026 22:52:52 +0000
Subject: [PATCH v4 2/6] mm: gup: clarify a reason to check pte/pmd in
 gup_fast_pte_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refactor_gup_fast-v4-2-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=997; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=nxj+Mt125iEK/vat1Tr1w2hJbRHU1d6dQuW9cP6e4wA=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq86BSIKAa1p/fqPhJCtV8HDJc97wAZexHXTSDa
 ya0BysbIUyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavOgUgAKCRBt1cPRWsUx
 M/36DAChg5tSjgS+3k4FJIkhNk03nDYc2oUXdJQXLCd2BfzEKniH8Lt/cav31TzxeLzfpsOgcSq
 JcwkZgByE0k9LaglVNcLyoL56Beh3BViFyEsk02PuDujhfgMBhrk4ACv67PI1GCuBsm2t+HrnwU
 VBcUaTxS2Saja4LvnIGc0NdoFMPvvTKoU43hep9lhZ3eH+OMmZJ89SYorrVZqUJCI7KxqgWU5F8
 WT/YJC0SFI3AGlmImrXMry32gLRC1tUcVCcbxNo+OEGkEhDHSofoHwpFDMK5JBGPPCby5UbX/lA
 bDwE+UowWlp2KtT/aEThlNkUwgdYkNEG4dbwQemG4grs9d9oU/yw/888zKQLojwJr7l10EA40LC
 iLmwvcUnvhojC3NfldoIr9jVcNeT/+pjE/TL5L6moxWewlHpYu7eOHCbJx2ovAyaTawbgNd8AbR
 wsQIBCBHyxeYHCOrRGpzLXU4XVLVfac/xgUu+vL3v7ww0b57H5XrRN9zn0UJk2xkdD0jU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: 94A8FC0003
X-Rspamd-Server: rspam12
X-Stat-Signature: aapz31guhpcecor7jiygpuzsadqwizmd
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794351197-315788
X-HE-Meta: U2FsdGVkX1/T5bTOk/CE6ug3aW9wgq2FuwoRRKGujABHwsa7MaefOoH3/XqlMkCk16hpEIJAVLuIQ2pWCkD0zH+eFkeWdGQtFW6pR9NBWsJLYJrEUI0ibi7nLNThYul0/5HenSPFm5tCI8/cfmP4S3pJ8Nvma2RPHnj+LY+F/3WK/uUjN6bh2Gx3c32CvmGRHAKUbwWgNW3Y12w1oECJc18P7iaJR8CANImoG8IqoA+8B1YlCufy7WG88quJnXsSBlf4ztcN8IS7Z4LoXTab0qiaRyXXSnA+58IYeLrcMs3h1bFV/IgUFhykjQdZVeK1t/jsEP4jThaeFlkYGtgOjLZzirYd+UqexIsbZab5dd+05KSGwqeWaR1aBWyJj/5BXrjBvYzCXPsxhydyrGKaitJUowuKu6XgIwFrGB1BSPIC2QetmquD+jx8m2Vi2K5b+bNyJ16j6Vi6OC09Qs3WDM0kw9mcTPJT1jKmfE4kKxWCNjGNRRHIZmZbg2DPV1htrgkAQ7LDHwDwV0uyGoXEFC6QDAk/wQqLJ+KCVksY9zdfCpZyQ/H8+IEkBRuW0MecldvXwscrSJyfgBwsEM5RzH3ExWU97M0xK1qf2IJ32ZbaZT4zSS2AVru3I0C3v3zmy//4S8KH/sj/qJppqTG56adZBGHeWKGNK0w3WEVxUcNGvfOubIpmEPGZ2Ug6A+v2mOQ7muQISDrTApF8pwoPQmYsPVyiWYpu3bTZ10vry9SATXdYi7dk18DH0zKbQICp1QteXUdWcTbmxFAIt8ijpyXCFjOAboYe8Zh9m5QMrV96lUonQPKr2nnAoetc6lLWU/KLrLG4h0ONVOJvBkOxVOifjPKUZ2QTZpkWRCbiRfLhgHrYEyAX+1gizp681pMlGUYYLaM3MktPdbCpQlZj3gBNZQp/GedacGNzQJoxSf+GgXm5VYbk4HNHam9c0FV3LJ0SzL76GX+PxGJvru6
 pMuSMkp5
 0heeKYH7vk0meWxkAOodz3CN7JlNzs6IV/iMnQf+04TpV0urpmrkht6OQJQcBodCK4K4P0xj2YwYAVkvIMa5io0TYjly3DLILr7eh+xGb2lhCHA8yH35q2HpI02D1B9r6x5WAtJ7scqWD3DFyaulhn454wmWVfPGkXGjejCfTEEMK3GhaizFiK2rSTZ0bFNge7xknfGm846ycthR846BHlPhm5TSdxBfsLDYetOmfoPP0uCmn9eXn8Pt3bKBg6Fk7HA/s0nPM8poNnFvhAFIHbspRv50rMg8Fuy6q7eRuU8J3Z5ULkvGXXiA9oksUwubG1Bi5c6VWCN/s3nj2AWN2tyLCbEz4pLZbGwbl2W7rJnpi9hOffcWoFskX3ODaMZrGMl8P5k56NI6JHNvq8bu2U1WT8K4FiZgwwAOw8k2Z7jz4ber2D3vYETvUek7uBFuiIEwHVMmO6d8WO4YfK5e0Uto6njp+RDSN+dlpwuYFbrrQ7ALISLnNV46bgP1QmigEj7ao6WvAF8TmqLqNXsymL2+6iZDSgC3HoKUi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Clarify a reason to check pte/pmd in gup_fast_pte_range().

Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2ca5..00dac03093a4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2885,6 +2885,14 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		if (!folio)
 			goto pte_unmap;
 
+		/*
+		 * Recheck the PTE after grabbing the folio to detect concurrent
+		 * unmapping or protection changes such as by KSM.
+		 *
+		 * Also, recheck the PMD: THP collapse can detach the PTE table
+		 * while its entries remain unchanged. Checking the PTE alone
+		 * would not detect that we are walking a detached page table.
+		 */
 		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
 		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
 			gup_put_folio(folio, 1, flags);

-- 
2.43.0


