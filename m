Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12007CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 05:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77CD6B0088; Mon,  5 Oct 2026 01:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00986B008C; Mon,  5 Oct 2026 01:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8AC6B0092; Mon,  5 Oct 2026 01:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 841526B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 01:23:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECD9980131
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:23:31 +0000 (UTC)
X-FDA: 85287429822.17.6C44E77
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE925100003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:23:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I9IJYLy8;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791177810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8/bTdhBqp1lsrYcXQ9GT4z4PRpfui/LQPvU3nWaP+zo=;
	b=tvBQ9JA0RZZ+tWqr9fsu4eTZUuvbL0AHOKhNnqaXVNyBiLsWSi4J6WiuBdOQZaqEEdLkoi
	cP3WQ7clp+3sEpDFKb0fFNADC3Dv9su9hnOqhZZDrI7a3cUFxqbTaD2BPuRspAt+i6QN+n
	wIX0N/XXYuU6HCdZO0oa3riSmE0sAyg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I9IJYLy8;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791177810;
	b=qqEuec9vdsS3uhZk/O/gsxJllU2yc+fTh79l8qDTul/fPk2rKfzV5tPFVfVdNxyaMZBKB0
	aZdn1dgYGQz3ULWh1ws1h5xa6VGGubBs4ygRb27NlVei3EjC/JTrOCB6IpJHS3n1Bknnp8
	WhEspocFntmtdUZ7xoUJktvQIw34GlE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HvCCfJG7Kj4AzwyPWL74XPayQRFxzYMNbzWN/592PQA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791177806; v=1; x=1791782606;
 b=I9IJYLy8QzPqdAqyDxJCc6wp3NlWaRvJhXv1CwRTO7cwyvygY6Wz3tlHvmZXqCJp5fn+6QbF
 ytbQ4NAXlmav/Io2IXiwS/il6SakYlN9bvsDelrEfdo3RIpUalHw2/bAkC6pc3Kbo/FFYKJD2we
 wcSYS8TnIKMvAjxvWCXbwtTQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0fbe826855e32b70;
	Mon, 05 Oct 2026 05:23:15 +0000
X-Mizu-Trace-ID: 0fbe826855e32b70
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: dave.hansen@linux.intel.com
Cc: luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	riel@surriel.com,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	nadav.amit@gmail.com,
	thomas.lendacky@amd.com,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	brendan.jackman@linux.dev,
	jannh@google.com,
	mhklinux@outlook.com,
	andrew.cooper3@citrix.com,
	Manali.Shukla@amd.com,
	mingo@kernel.org,
	stable@vger.kernel.org,
	toshi.kani@hpe.com,
	david@kernel.org,
	mikhail.v.gavrilov@gmail.com,
	pfalcato@suse.de,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with TCE
Date: Mon,  5 Oct 2026 13:23:02 +0800
Message-ID: <20261005052302.43042-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE925100003
X-Stat-Signature: zqgekyccsrk81wcfqz1r3mn544i5af54
X-Rspam-User: 
X-HE-Tag: 1791177809-434967
X-HE-Meta: U2FsdGVkX1/1I/nGctX3c/TmuD6AcZY1coE7uBRITHWHS/IpHtsAFMFH7RDk0hYjXBa7ofGNNpWMjcw7+Rfd6+Nbxl0PI4UVBfCFzMqJgLx8tGYK7SIf2DBo9l/0iU5WtsyKqL0EO6e1pGU/IMnrZG1XWlA/7g0NT8SmxsofkGhkAbc4SkiVwPFo5HBCgB8RRJTF5cTlOVc2Pec434zCphoByhrwqEOFWjBS0yJMLuR5qMrg1B9yGMS0TOwESj4DC+anbIaoWgtp5tsnDv5kWlGO2IlKb6aWYFkpwUIsn+6+56z+KRTlrcjhbcCnxEabO1k8O0pShJOH1nKjHnod6fTyqsnWipoII3LBJAUMTGbZf32Ks32RFoh+tvl6lIopws3IMTNxVYl1oyumum0+vX/PP8EC20yh6gsc4begI4QuIpqlRnRNuRbTAy6EjqVBikoYEj2Ip6TXp++49r/aAfs8MXTcZ7QjE3JyR90So3pLJ0blF/aUT3JmAllsqm6P+6xEgXxEo/OTLiDhXipGQTz1IyghcCI1hKqGMMVPPZK2IxbWdHhYKWj5tXaRqOa6erUwqdjz5VwqwSKsSXrAK9KIE5sMrcJrr096LUtTqkU80nu8wZE5IZVh4fN/y2ScQwOzCu25CqIB4rpSUOqteYAV2aCj37VdgUIxV+W3G+c3qk99N5eYV11Z2URkw+f87+BbRdy5kjzcaqsRZBvMz6diH8pLeVA3AusUovme/Bb83p+TcffNCIM4ZRn0H51niIYFVHCmHh3hV+HlQkF9OE48UNuoueNTuau1jMr9BoUDHnFwfDLN5SJV5wCd2m6btueb4QY866xuBB0LcQ9P3H+XA3EIXxxdm+S3rwe+dQBYKYkrsNhSX4qE9FtPKYNGsbvI8glQxXWC+UqvEXG+h+52aK3CWTmlL+B573LAf7lY1POz92KS1Ak28mm7oHRfReP81W40gsI4cL+qIae
 S2nZBN2/
 Ej/iMASG0kLUPbS9VjBSvZ82VFkQFXfxFw8lRNbH76w7wvC/fPInDsUMVSHdvndf8c3sx0UgaRL6Y8DLaBnAX0I4Q1iTB6N2aedGBVpnc5LPfsJbhYokh3lkW7COeZ36UJoIcPbaJNMYcmdECeotz4MMLQixOHeVN1PXxchDZZrLANSEE3AfveeEw1mQf+wT+snJC0XjNwFf/CqJFBsDwAn6ZRMr8VOHLFumCW0fcV56Z7zxolD1t9cgrc6gHgyOhQf35lIpWxJ8uz6YozpvaKSKkeNLBYuEjvqkLzlSCgn3TA+AxJdh33r5luwktlCfHb2QxdF+J+hWBOjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pud_free_pmd_page() uses a single-address invalidation to flush the
paging-structure caches before freeing the page tables. With AMD TCE
enabled, this only invalidates upper-level entries associated with the
target address. Cached PMD entries for other addresses in the PUD range can
still reference the PTE pages being freed.

The AMD manual quoted in the commit enabling TCE says these instructions
remove

  "only those upper-level entries that lead to the target PTE in the page
  table hierarchy, leaving unrelated upper-level entries intact."

Even with all PTEs cleared, speculative page walks can cache present PMD
entries after the earlier TLB purge.

Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
the single-address invalidation otherwise.

Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
Cc: stable@vger.kernel.org
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/mm/pgtable.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 4a105f283cfb..6b7fa44f1bf6 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -727,7 +727,16 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	 * via normal page walks. Make them unreachable
 	 * in cached mid-level walks too:
 	 */
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
+	if (boot_cpu_has(X86_FEATURE_TCE)) {
+		/*
+		 * With TCE enabled, a single-address flush does not invalidate
+		 * cached PMD entries for the rest of the PUD range.
+		 */
+		flush_tlb_all();
+	} else {
+		/* INVLPG to clear all paging-structure caches */
+		flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);
+	}
 
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		if (!pmd_none(pmd[i])) {
-- 
2.49.0


