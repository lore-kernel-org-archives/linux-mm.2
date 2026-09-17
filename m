Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E491C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22DF6B008A; Thu, 17 Sep 2026 01:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3D56B0092; Thu, 17 Sep 2026 01:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9B16B0093; Thu, 17 Sep 2026 01:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2916B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:40:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 208ED1A023F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:40:40 +0000 (UTC)
X-FDA: 85222154640.13.AFDB153
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 148B21C0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:40:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pay6ww/B";
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rp7muEkHmsTx3rB7GRNIl8qJbCesgIC7RdDPevH+yq0=;
	b=mvGSiiNmT3y5b/uixcP7IDAyyIgZ/vw5QPzc2qdFVZAq1t1lfUzf2p8l8N3/kP3y9psZd+
	o/6CXR0nk9fzsPlxgdtNsIDj7msdmU7SY2CWsrYquDpuwjlccBCK1AkPeT0PatA8A3Zf8d
	KAvfq9d8k+RAnDW2pLrqcs8odevyC9c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623638;
	b=AkceeRcJ9XKvFEcbV5AL23KReQ6MC/+JcHgFF2SI2At8t8OC+aNKOXLep3csb0RgjKHILn
	kMo1H1eku6Fs5zrYLU5Ojjrpno3fO3m7xFgvyt6ushM6+0HK9KmBORxYUDbfW8ICY3MymE
	5C7N3mdKuSNumD5DAqBKZ1sw6DFCnvs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pay6ww/B";
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5cYIixR20pZ41MM/JZMhsmLuC7wrwh8fwwhI/LOf6y0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789623636; v=1; x=1790228436;
 b=pay6ww/Bia5KhJ4XlU1/8O/lISA35cULXkteBnAcWlStmuT+LwzYKiBN2jB4nT4XBB2Fohdl
 s2lQr7Bcc9F5RgJP2MppryNVeXkbR97DzhLf+7TF7C6hRX2FKckJ7s0WuIrAjp6xXVVtf3wXv9J
 NuhaO6lVwsBnc0y66od7lSz8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 21436b97f924de40;
	Thu, 17 Sep 2026 05:40:36 +0000
X-Mizu-Trace-ID: 21436b97f924de40
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
Date: Thu, 17 Sep 2026 13:40:15 +0800
Message-ID: <20260917054015.23553-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1397e4g3rsmibuxqcou4f7qfg5xspeug
X-Rspam-User: 
X-Rspamd-Queue-Id: 148B21C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789623637-6797
X-HE-Meta: U2FsdGVkX19IElgHPtFanm6DIrshhWvfsfzVHO59vwObfZPUwrZ+x+aTUbMsUezCVW1EmzYjntW9BzxgcnbABEPdERJRTfHMBRL+GESCCTxl6qoloURnTprLIYjjdycAupA5hkG9pHwCCxJ9vOHLbRxkrBIh3rA6U3Dr0WunWrKRg7d5p0gXea0hDZXW9OtgxAgejAEAMq5MnX9ElVC9kQp+CReNfSuSlOHHuhaHwYi/IwPE96U0mtAA7YTPcwFV8NSww1TMKgWCJ3iFYsmBFVILT/4IuJvDUyYXTsASkOUWtFKu5+aB8/HG6oly8pmFwSmYAD9u2eG2OVdfNDBRcUQ1kNX/+GLkD5+ft6Xz69UawyFs+I4upTh+01Ns8Gr3cEypDN0G9wzatikTDt0TOP/JyHGxvceTRyWFGC5IW5PvTn/7jC0B5ZM9GfSX4MuBVElqRWmfOyQdn2RvaUJn4VPWa6Csa3ZYd3NFC2W04edJqXmVyoYSihj3FcG3mRl97GzgYMPRCD5bhk/r3gdgaTLhI7rZCcTywadNUz7X8hLYuU4XOdNjmgSXCjZS2188ztM2vcuyHhB5R4wGJX32rBKf4rzIht69xQKZY1bIQTRULG6wkXXLEWQkJ/hApCVJAI6ZjYkSr6hwLmyIBhouorFwQM+YJ/TlmSC7jG0gnBsj3qrHp6f4kP7ov4zFQ9fPl0BcJqm2CQH95bY0Egmn+y7imlJX70l3yo51NVpD5nXPiL47oD0sPS4rDIaIyU/xSt8aySiqHHRtnxv6bmNdqX8SZ9pVFNIMi+i4Hw2NjpTxlwRmummjffZUBoJY6IvQPUFSwUf1xFypoXTSDZXZASflrc5O+UY15ZhgRuJE9RaIjV1J8Y/aHKooZlSD3w9Q2jFxGmYgvkA5Txvb9+FH2rntrG4K1+cp+bb0Z6C97x6Ad1UpmgCtgr52NQb4vPPtm+9NIRwFqiCrfg2ccs1
 T6a9Zd3k
 1QMl7MdWEwMgPEgbGX6mMul7Xozf6D1nlyEApMU9uuSLSg6ZN1wUsYR8rpoMTiX92hbFc3fmuudgaqYYA9E05PT3MMyD9kQ4hTfq2EoGzI6QZdO66j50DqtwuXDKbdOka0pjJVsp8bqIZKRAhRNEs0ObWD33c6IahNI4HysJjksugPSvCTZnIfIS7iR3ObuFkLIRj24h3sCJQaIKvJ42Yx/PAi5frRBkKe1mu0Yfy8sW74g5eW1358Mlp6YroTcojDjvQF1ngrqXSlrlj7owRsDRBhEwGrEC5Y/NLRpPyB1HrgMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Whether a PMD has a deposited PTE page table only depends on whether the
architecture requires deposits or the VMA is anonymous.

Implement this rule directly in vma_has_deposited_pgtable(), avoiding
mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
to withdraw a page table that was never deposited.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Simplify the pgtable deposit check and rename the helper (per David) - thanks!
 - https://lore.kernel.org/linux-mm/20260913051942.40889-1-lance.yang@linux.dev

 mm/huge_memory.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 30b7c63b0e35..bfd972b997f9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2521,25 +2521,13 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 	return pmd_to_softleaf_folio(pmdval);
 }
 
-static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
-		struct folio *folio)
+static bool vma_has_deposited_pgtable(struct vm_area_struct *vma)
 {
-	/* Some architectures require unconditional depositing. */
-	if (arch_needs_pgtable_deposit())
-		return true;
-
-	/*
-	 * Huge zero always deposited except for DAX which handles itself, see
-	 * set_huge_zero_folio().
-	 */
-	if (is_huge_zero_pmd(pmdval))
-		return !vma_is_dax(vma);
-
 	/*
-	 * Otherwise, only anonymous folios are deposited, see
-	 * __do_huge_pmd_anonymous_page().
+	 * PMDs in anonymous VMAs always have a deposited page table. PMDs in
+	 * other VMAs only have one when required by the architecture.
 	 */
-	return folio && folio_test_anon(folio);
+	return arch_needs_pgtable_deposit() || vma_is_anonymous(vma);
 }
 
 /**
@@ -2579,7 +2567,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
-	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
+	has_deposit = vma_has_deposited_pgtable(vma);
 	if (folio)
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 	if (has_deposit)
-- 
2.39.3 (Apple Git-146)

