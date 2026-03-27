Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 591DC10A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10576B00B3; Thu, 26 Mar 2026 22:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1236B00B5; Thu, 26 Mar 2026 22:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDA86B00B6; Thu, 26 Mar 2026 22:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B91F6B00B3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70699160F25
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:31 +0000 (UTC)
X-FDA: 84590226462.27.3D90498
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id DDE71140004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eUmbqBO7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577730; a=rsa-sha256;
	cv=none;
	b=QNeZelv1uVmL79LMKsuZ5akCRNOE7RJ3pHECwejxMGyyDUzMWrCM9RoAzKlvri3wJ6Wtkl
	eSb7nAok8QhES16WakA8lHXcdsjxVl64RC4xftlO7qwTz9vWE6QEiedmvSjFSs4YdKKKCS
	MxrjrcZ/PIxKCpY5X0wDsNQv1Bg1Wmw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eUmbqBO7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTevK4s9bqcsyF5dGhWo4MENNp9vZlr+uy9xAQG2jfo=;
	b=pBcWpYuKW8AlRnhArIoH3H3zxzVqnbrryyshWJqpJUohDify/i/hNGM49Ohz33uLNeBvBF
	PR+3ZbkU99VIE8Z6AyA7HluoTNxWMN5V5fxPzsIRt5KKLasXHNN3DVlHMMNr8d/9EC0Smh
	a/xm1aaxD4W4oq6iTDuoITEq/IcPkWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WTevK4s9bqcsyF5dGhWo4MENNp9vZlr+uy9xAQG2jfo=;
	b=eUmbqBO72zX2904RPuTC7NJzAIMHlr5gcD4RVYygo1GU1dDyzany1Q2T9JuiXvkcB8DQd9
	aunpkimHYmudKZq6kRshELjRaFFsIkn5wCDv9o4AVpLZf/bmSb/rct1ebqgCoY+qovcSBc
	l6ygYvG/M7DXmErg92nyDDfRdBDaJ3A=
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
Subject: [v3 12/24] mm: thp: handle split failure in device migration
Date: Thu, 26 Mar 2026 19:08:54 -0700
Message-ID: <20260327021403.214713-13-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qpkzsrgsihfcmgrarny1xqkdwz8aho5w
X-Rspamd-Queue-Id: DDE71140004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774577729-991467
X-HE-Meta: U2FsdGVkX1/AIbwx3PBEeJEeBoFbtTsir/+nbtY4VKPUjBsJiA4JuA+oC+90tuEPlkXMQcccWiza13xApST0+rfXLz/bBLzYQLYhPxFMWR9CCfDInrIUGB3Kn2INIsU+kvzcaWh3UPIU4SBL4QoYF2ZFTvK4ZEcWMFsAsDMMg4LRT5c1tNmJ/R4g8YNBYEi04ACzY+I1CY/IVJhHFn3Ot+B2WOwTx+WMxUubeTcmcsedmsIfAmPbs/2ag7y5NviiuJc0CmBgLUQ9+fHlfUM7ryOcMMnTGEiuvNReIdUEx8oyWS3fK3eHHg22S31mpW8jp4Y2UCUal3DKdRr8PLMjrkuea7mD38pn7ZOq1mGtV2FBrUSDJxrlViHVYKu83Kem1MB3lxBeZ0y6dnJzebgp19WaGKL7+Ncd/LUWdoT08plE82xKIIDfYLzNfRhKlxuk6g0nw2ap5SLr6N7dY1sWReUJh0N2WhWShR3vqQKIbwFkE3eQB9DamNWJ3LJCNFzq2B7nWdMLu1UoGhTRUxLnj1UfVC6m6xUCBO7uFRtWe6whvjmbQJLB4531673au9Tal27iwv5ki+UF8tokZOB62ZtiibxycPo2wjk5F+q1usXCR0jRxCaROfB55UGSizVojzHPS9GKKGDppRzPI7plHn8Zup22+xMW3fCU9xj5zjpkbHGmoJjjQTxGG7ahC9bQ7TY4/0X7ambLcp91mqvGHGkekuv3vqrbVpFoU1sUg9p9nIDdqaMBb0IPY6jkgg9ejjAeTs7eGIDvxhz58MgNHmj8VcWewUEQETlOGB3WIouxXF8+evb2gIOqQQEI+RwA1aHRTUqrqWnkjxDdLMhmd3czw43hcM21TzaZ2Tv/iXfXTTpztryoe9Dd976JABgyPMs4hDSV09w9Ko4DQnIEmmd8eP6HUMH+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device memory migration has two call sites that split huge PMDs:

migrate_vma_split_unmapped_folio():
  Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
  destination that doesn't support compound pages.  It splits the PMD
  then splits the folio via folio_split_unmapped().

  If the PMD split fails, folio_split_unmapped() would operate on an
  unsplit folio with inconsistent page table state.  Propagate -ENOMEM
  to skip this page's migration. This is safe as folio_split_unmapped
  failure would be propagated in a similar way.

migrate_vma_insert_page():
  Called from migrate_vma_pages() when inserting a page into a VMA
  during migration back from device memory.  If a huge zero PMD exists
  at the target address, it must be split before PTE insertion.

  If the split fails, the subsequent pte_alloc() and set_pte_at() would
  operate on a PMD slot still occupied by the huge zero entry.  Use
  goto abort, consistent with other allocation failures in this function.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 2912eba575d5e..00003fbe803df 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -919,7 +919,19 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	 * drops a reference at the end.
 	 */
 	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	/*
+	 * If PMD split fails, folio_split_unmapped would operate on an
+	 * unsplit folio with inconsistent page table state.
+	 */
+	ret = split_huge_pmd_address(migrate->vma, addr, true);
+	if (ret) {
+		/*
+		 * folio_get above was not consumed by split_huge_pmd_address.
+		 * put back that reference.
+		 */
+		folio_put(folio);
+		return ret;
+	}
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
@@ -1015,7 +1027,13 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 		if (pmd_trans_huge(*pmdp)) {
 			if (!is_huge_zero_pmd(*pmdp))
 				goto abort;
-			split_huge_pmd(vma, pmdp, addr);
+			/*
+			 * If split fails, the huge zero PMD remains and
+			 * pte_alloc/PTE insertion that follows would be
+			 * incorrect.
+			 */
+			if (split_huge_pmd(vma, pmdp, addr))
+				goto abort;
 		} else if (pmd_leaf(*pmdp))
 			goto abort;
 	}
-- 
2.52.0


