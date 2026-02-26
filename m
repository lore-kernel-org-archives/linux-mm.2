Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787DAFC5933
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D834C6B00A4; Thu, 26 Feb 2026 06:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64426B00A6; Thu, 26 Feb 2026 06:33:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66B86B00A7; Thu, 26 Feb 2026 06:33:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B34A16B00A4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E382BD1EA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:55 +0000 (UTC)
X-FDA: 84486398430.09.2904BB9
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id D4251160002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=urU1JU88;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYA2+HQ3PTBt5D8sdrhOr6HCB84Kriw+faUOIzAxMpw=;
	b=oEwaBaZoSrBfqP96vfUem0U0/cPW6blIzb9YoIDRkAs1vZnfO39+U7Eb1bT/YYgJ18sbcU
	stofcGioTSroTdGx5K3uU7m7YgY6RNiiPdR1GqqUfC6O0yOPbc5Df/C5dNYzTIS8e+kSCc
	hg02wnmaaMyIFhdsGcYJV27jKvqAscw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=urU1JU88;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105634; a=rsa-sha256;
	cv=none;
	b=Z+6LjvPzsxPy4vS473PNMCoatLTbqoBnLFz+RbHVQFxV66HPxTS05qc+6Qbhlg3VaV6ETP
	NSw5+sIEHffOHM1+3j3AvOH6GSsEQwaUObIqFqda5rb+HytukIK7sK8zhOPBMTB214sPLB
	Q8UCjV68GeK/m+WF7T3pIFAFnrs5WMU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VYA2+HQ3PTBt5D8sdrhOr6HCB84Kriw+faUOIzAxMpw=;
	b=urU1JU881GY7kjUvIyBX3z3Lqlmyk50JU6TXPEMfQliw0OxBspGKG47gwOqyYchKYjdhOS
	4MCdiw06/6qjaNTE/dJI2QINH/BZD+AyBh9OYXNlQ7Q+2vDLHhiRiXwTsCMMVh0aAiWh5C
	T/IMdVB4xvM/4LGbijfTnkgoLXbW/+E=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
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
Subject: [RFC v2 09/21] mm: handle walk_page_range() failure from THP split
Date: Thu, 26 Feb 2026 03:23:38 -0800
Message-ID: <20260226113233.3987674-10-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4251160002
X-Stat-Signature: or17kjaq1d9h5xz3qdz8waoxcqh66pyb
X-HE-Tag: 1772105633-436686
X-HE-Meta: U2FsdGVkX18jTxAWL4Ia+5lzcCUuuO/GUK0CcU/rV7pc6DyZF+mbRFrKbAxPQfCXwuWmazUsoykWUzyQ5ZHJhzexPKtwpuDKfJxCl+77WPqeUr5RvwdL2qxemOq4euWl/S/j0ZfZCp0PrTvDasB/2z9fE2KjtGGuvCwa3Lz2LIyCUWopnuIAi77YsHajaUjHeruTUL/1nDv+1kQBu5fIOIfPKXKB7/rYcLbQM//G0mst8JsNEvBhyB5Xf5xDlAF2r3RjuqRXjfJgJ8xC+7rbhshdrTluq+Y7maw62YJinaPHhhNKf/Mk3fcDZuPE0R6SIh/vn9fK6gZpJEk1O1lxxSjeeOPDcRscsTOtvzbdluPbhPHdMyulxDRQL5X9HW7tS0uOsoVrO7IUQE/Pqv/G62g+lQYQ0Xfq9+jYiLaW1ARzDvPn1nCntyx2FG7GKsiNB0FR6PLMy+p6r3Xb3g6xmW+PQc6CH/7bztA9TlDWaFbZvsZj4uTcqYoA5wEKFsq8M/zdFzqmQZOUeb0P7axGjRlDAWQ8XLbZtA+UAbIsXSBeD35fiiBVI8pl9vRv5vTdgojUMWw/8i7nxx/zksYDsfab+3JY7hos7NzE4jl5PxSxDEbWhYSp3abBS5tJWOv6zNdZXBceWjmBvVLDyfLA7qbFDVp8JAatpMPK7rCv06JkNYDcNyRn6SmJjeZIRmzsvPpxPVrNTiHKAFEya+E/T7SrPU5RbXtunhA7fnq4v6e5Fxuppi4Z0lDLT4fTyzLmbawQd78AyBOatKL0zEZZAIxgdZASZ+9QYfd25du+DaM9mDseSa/BFssRX49dGHLKPv2v5dwi5YFDSNKx+dz/1N49uRyvrUyWjFMDABf7Ta8unNwzPlFYfUWueQSZiKFIhC8WjK90a9SG1dprFDXYfzNFebyZvKn2osL6cGc5Ogu3A0sdK3SsDrWkMt92e5cXAJYIxZBXnKAarfCfvKO
 BVkCOY0O
 S35cMo0uvjscwEeCzXECcMTUDQD4FPqYP4xWTZSKSaCJZSuXi2LuyeH5B3dkLf3n1ch5G1sg7G51q2KTnFYEoNonBkvMO70nTJIVY8Z7K9QHot2XMF2T6+KjZ35u/gDF2/nrkjIwTYxvml5zrKAmLx5mslTxkMmKN//SGihWZe5vDN6VJ3Rgdp6JmrHrNH5GF+GNFvGi6OaK4i50MFs0HlUE0UcgVghvyegbZ4V/15Niwvj99ILSBDxsSxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_pmd_range() splits a huge PMD when a page table walker with
pte_entry or install_pte callbacks needs PTE-level granularity. If
the split fails due to memory allocation failure in pte_alloc_one(),
walk_pte_range() would encounter a huge PMD instead of a PTE page
table.

Break out of the loop on split failure and return -ENOMEM to the
walker's caller. Callers that reach this path (those with pte_entry
or install_pte set) such as mincore, hmm_range_fault and
queue_pages_range already handle negative return values from
walk_page_range(). Similar approach is taken when __pte_alloc()
fails in walk_pmd_range().

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/pagewalk.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cfe..1ee9df7a4461d 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -147,9 +147,11 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		if (walk->vma)
-			split_huge_pmd(walk->vma, pmd, addr);
-		else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
+		if (walk->vma) {
+			err = split_huge_pmd(walk->vma, pmd, addr);
+			if (err)
+				break;
+		} else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
 			continue; /* Nothing to do. */
 
 		err = walk_pte_range(pmd, addr, next, walk);
-- 
2.47.3


