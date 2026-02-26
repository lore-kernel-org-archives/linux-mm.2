Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F85FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A208F6B00A2; Thu, 26 Feb 2026 06:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01CD6B00A4; Thu, 26 Feb 2026 06:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925516B00A5; Thu, 26 Feb 2026 06:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8EE6B00A2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47911BC24B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:50 +0000 (UTC)
X-FDA: 84486398220.26.0452A81
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id B3B46C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=udE+houD;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voiqUydpep5c50p71jeWeFdopCgnIpO6zR1blEnFY9U=;
	b=lvqKrBbs7nHPf8R62cfcjN74aiZWS4Knh7QcKbvvkk8Y4avoTDIM6VCaChRkHe2U5eZ1gF
	w0PEksP21HsBdVGtSb4/v/rEwJA3U4+MqlzuRdilBR3qpl3hjn9p7EjDF/PBaj7WTtHbil
	+FxpGfJCoDOvmP0qhvIyxCJwr9bw1Pk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=udE+houD;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105628; a=rsa-sha256;
	cv=none;
	b=Q3cbmZlBl8xD+sIjrsoWoPJW/Xzm9V0BzlIrYCFHx2MUDZI7ZRy2Oa+iKZUb2Me1uH/23w
	zgRFWU1J6BJkLlafzrSKbKO7qDQjiAHVYB9ox0rfinezpLmlBh9Zj/eKmNiW+hhy3vHs0C
	MiYzWz0gaEOE5l0u6D8EoPX1l5o4nTY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voiqUydpep5c50p71jeWeFdopCgnIpO6zR1blEnFY9U=;
	b=udE+houDLGseN1f6IYvibBzYYzpJnrx63S12MifUCk13f0DjLpLexn7cLE+r93BBzXNqZW
	GMm8b+RjhZzqazJYt7NxsX82x6AVbHVcuPZhuNhuFnkbnvwr1QnAXR2LjKKpKiQSa6Xdhz
	62qhsCiwM2CIlMTRP3nK9ID7G97Ovc0=
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
Subject: [RFC v2 08/21] mm: thp: handle split failure in follow_pmd_mask()
Date: Thu, 26 Feb 2026 03:23:37 -0800
Message-ID: <20260226113233.3987674-9-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B3B46C000A
X-Stat-Signature: 9d9sd5mywmqw9hxda8r8rx638w1dousw
X-HE-Tag: 1772105628-623825
X-HE-Meta: U2FsdGVkX18ZH4nBwOHBvnvc7PMqclam9YhZ5/weJJzBpRlZYY69z7GAT5LiQR3XKOGPbCPxXwGvGaz90GXX1HNg9lkM+o09BOCiZqMqJwR5IwWLrjfaHbBeC54mlK7mc8qPsvqyUaEvyiOUPcgMs293I/lIegnDuCXlvkbZ2s+eU1VE+AC8h7y6XuDFY5j3Z+SZykizKLHWWlRyWWvhcJoZ7CmCzpnSQGAdESdbOQX9AeEwnO3gged58JFJ2vMrZd9IHlBs9xqigs0pRS9NOB2QXQdD+FyhWYH9fUH+JkD5MPzZJGmTD4eVk61LiFAJiplM9pp0/19oIjmr3yOkvCgA+ZXXAiwPCoSN3r8wfWL91rhImxCB/TKdudMwoUPUuhpn1CyEF48i/+ZfVF6S93Nk/AYYZWyYHeJujNZGkym831Q6B93HjF//4M04BozZ4QtJNJw9OdTiZYhHyCp5K6TIsDDXFiUSRw3CN6FEz5pVEbwP1HC4SDLLBRMsHxYbXoVTEtNjJM8a3Foi7Jy64KuSekXnDVfBcCULO9kwCj2XNIQ4XCLmiTeP6JBGjJY17wx/hQznGLQg92GRvWa0KseoWGnKVTYI+kqIfCQtLmQkQnTF8U20EJSuOYHOkkdTIgoVHp9MegC6QGjhHlFMPGZRlRcUDZg6ODtGcdMiIXQg8s0J4+6cxEkEWWQImoVRZajO92kt564ZdQO1tL1r7SEvCIo8bMqefMX4BQuHtp2MHXt96Ss4klnrC3//c8+gP879EsAR1OQtm89WTjAFBcUTz9sS4U6+fzZQLRA1rsudDgCAfezm4soMFnnu54WpBQF1ysmw/cPDN6mUUaX+zGBGVCLRmyzbsFtAJKlj1zU01FJ0O9ZRhpcG7DRr57b4fyyXKaZ82PFfkqeQP6nhu/NmizeMNBpog8owBho+RoqqKZnK//x7SUORUucVALSkl6sZTv7lCEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_pmd_mask() splits a huge PMD when FOLL_SPLIT_PMD is set, so GUP
can pin individual pages at PTE granularity.

If the split fails, the PMD is still huge and follow_page_pte() cannot
process it. Return ERR_PTR(-ENOMEM) on split failure, which causes the
GUP caller to get -ENOMEM. -ENOMEM is already returned in follow_pmd_mask
if pte_alloc_one fails (which is the reason why split_huge_pmd could
fail), hence this is a safe change.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/gup.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee738..792b2e7319dd0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -928,8 +928,16 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 		return follow_page_pte(vma, address, pmd, flags);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
+		int ret;
+
 		spin_unlock(ptl);
-		split_huge_pmd(vma, pmd, address);
+		/*
+		 * If split fails, the PMD is still huge and
+		 * we cannot proceed to follow_page_pte.
+		 */
+		ret = split_huge_pmd(vma, pmd, address);
+		if (ret)
+			return ERR_PTR(ret);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
 			follow_page_pte(vma, address, pmd, flags);
-- 
2.47.3


