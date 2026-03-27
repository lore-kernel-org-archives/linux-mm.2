Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC0A10A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1556B00AF; Thu, 26 Mar 2026 22:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299396B00B1; Thu, 26 Mar 2026 22:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6896B00B2; Thu, 26 Mar 2026 22:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC156B00AF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A073D8D656
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:20 +0000 (UTC)
X-FDA: 84590226000.17.D030190
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD6B740007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NTJcN7VC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577719; a=rsa-sha256;
	cv=none;
	b=NnckWVQmtv17yF+0J6xbjmR/GKad7Z7/+2o6oz+es/MgGOGiP2DEnozrUtsBfiz3yyosou
	I2fbKPcC6GKtNF9Ti8HbCqDMw8zdl1CqtHtEAluT0Bumxx8h5UHtwczLrUIyRlIVBA236Y
	GI1JSPEF6hU2Wf5gQKXR0OK+Op/jrcQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NTJcN7VC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OmEvrhLT+taWsJJPLmmWMkCHrhCtqMj0PAwSXwnE8E=;
	b=s1CYnEiFmfspsHWtwr4jGaC88rLqU5D9iICBb+VdUXXtfmxujwxvQxjaRB0uujps8+CDuU
	guFmktG0oj66CTnIFIs2daTOLZ8ofZxPjfjWsR8MWVr//uzEtJ8EaF5Coxb/H4Xt+m1Sgw
	RI/lMmNKDaFxq2rTxHrflFwQILAoptQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5OmEvrhLT+taWsJJPLmmWMkCHrhCtqMj0PAwSXwnE8E=;
	b=NTJcN7VCFrbbYw8QV6DmQtslK9s9YNMNuM3BLeJdPk9ev+oaHPxhCblvvx8mF+jryQcQ/A
	wg7YpJu4lEnBQjk0VtVknCzS7c33o5merk9llHuNz4qXtYAm5HOn3BSwWdYd/7vyZ/q4XM
	aKuuq0sNgUbjhFWLQf7XvGWk7bo3EeE=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 10/24] mm: thp: handle split failure in mremap move_page_tables()
Date: Thu, 26 Mar 2026 19:08:52 -0700
Message-ID: <20260327021403.214713-11-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zyi33g8wwbq3qcgd7zzyoo6i3bi4chu9
X-Rspamd-Queue-Id: DD6B740007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774577718-171061
X-HE-Meta: U2FsdGVkX18KRHXMCPxQ1sxU0JKCNXTp0ppXFKsTk9xnIkp8f5xJ1ZPXHpqnKgBa2kAzvTx5nQfvRxvkYHCSl/kjH48ND8+qTsQkZ/JvwmQTgWHw6MnuOsDUfZMG8PSPbKcrO2Av6JE94wXVHGvbxUlPNIBe87G1+IWDoLbXaoIyJ+d9Q9R6VAHpjiansXmW9oaGNHQ6q6Z3FXOr2zQU/24sL82em7P2ZZjDHM9Wb3IoOwpK4nSLMWwNkmZlWGRh2eH+pEqSA3FN86lvEiTrjtj5oIxUW/qF06rA++5qW+b5b8bF7Ot4oNGsoCqI3mcDqLh5YKgnxER3es6yOi4anBLwhK/Opt9c60/ESeGVngY7uS9osEkzh5184+3Yuk9E+mk+hjpRahHWCmtbuVF9SzLZAsAaIwg8VWNeropAZpthGnfdGXI1EuK9qr0FQckJjxTyJnwtAJABXhMEcuQhvOmZE6YO9Mc5IfPAkp0yHrhfXkbfF51FoOk0IQNcF//cn7QbSYS4doHIpqFG9rLgGZmHxV0I/2v523lQjX6yCajQ1D6TPwF9x28Xflt6OZjWBBpmAMgOGXL7xipK3SdnY4nnkoCn2/sxtF3rrOGGtdfkMKvaasDIG+6yuyG70y10lp63HwxVlUAwf4YYhrpQV9EVYaX1/1GXS0PLM5PdCWO51cg0ceqUUAfaN6wOAeZ8euZ48jVp1lZM2JjHkENSWk9RI60ZzFLnp58agi+NZPEW7hm8pybl4Y63onvdkBnLfw5Ngje/Z+h/dXCReuwDGLJGq7FGM9/8DbpCHoZpt6q4lDdBinOBSlwCGS4JDDhKCcrEG01PNNyxuE0b+DnbhW90MM0hSCs9rRLUD6BmlgBZW/XpNJVGwXrneJfiRpfbeXQLh15KYuQOU2uy5t4gnuomwXt96RxpNKVqZzWoTXZ/z6Y0AFbH43h8tjJnGA2C8mKQtz+El0lOpQaY8mY
 cqnwunAN
 kbmwmv3fBObk2HAToR/OMTejV+gh+FAyIak64l2ukSVo531Rj6TVUE2VoA2B8KAt2VTg3SOruCHg0RjixZlEF2vjvHO69x4Jwt6+Q6W1t1h5Vj0r2zcYaqfxfU9aAxrCMFah6Ov8zC+Jn39BMrFS3+I32IB0RR3PEVLamgpKrr4edPO59JZbKUi2FiCC8b5QN0a9PvuYTSa72zBRUsA9RA0o0Kur+FoINMLvus/IRAQG5c0D7gcilMOWrRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_page_tables() splits a huge PMD when the extent is smaller than
HPAGE_PMD_SIZE and the PMD can't be moved at PMD granularity.

If the split fails, the PMD stays huge and move_ptes() can't operate on
individual PTEs.

Break out of the loop on split failure, which causes mremap() to return
however much was moved so far (partial move).  This is consistent with
other allocation failures in the same loop (e.g., alloc_new_pmd(),
pte_alloc()).

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mremap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832b..2f70cb48f6061 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -855,7 +855,13 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 			if (extent == HPAGE_PMD_SIZE &&
 			    move_pgt_entry(pmc, HPAGE_PMD, old_pmd, new_pmd))
 				continue;
-			split_huge_pmd(pmc->old, old_pmd, pmc->old_addr);
+			/*
+			 * If split fails, the PMD stays huge and move_ptes
+			 * can't operate on it.  Break out so the caller
+			 * can handle the partial move.
+			 */
+			if (split_huge_pmd(pmc->old, old_pmd, pmc->old_addr))
+				break;
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PMD) &&
 			   extent == PMD_SIZE) {
 			/*
-- 
2.52.0


