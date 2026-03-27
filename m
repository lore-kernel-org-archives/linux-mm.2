Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FCC10A62D1
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE846B00A9; Thu, 26 Mar 2026 22:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD61B6B00AB; Thu, 26 Mar 2026 22:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13926B00AC; Thu, 26 Mar 2026 22:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9BE6B00A9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D40813C472
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:06 +0000 (UTC)
X-FDA: 84590225412.20.48B52F7
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id A789120003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c+UwEtgW;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c+UwEtgW;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577704; a=rsa-sha256;
	cv=none;
	b=B2zNsUTl8FZEFNdXydV4yZpkigJdHhswhDJuTRPCzj8j3ic25ZswQG176dGFUrtLsdYE8e
	UwapbLM7+PxxIl7nlT6ojTnuBfNZvn6I5cU4kkIjA/CnMVZO2C/H+PIwMaVVeINdCAqbwE
	D7bdsKBleDuVk+l66md5IgQHQ7b81kY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giSfT9S4Y3Fs6MBCHHOkpgsjb4flU8mTLfNnlsB/wxU=;
	b=dxBokh7qDr1iqF3vLzNQ99OxNMIXSBURxI+QJ2ZD0O5FiBhlRJvIl/refkYaSkDh0hu4Sy
	FIlwH4UCeMOHUk94eLOPCkcNotJjCp5UtM6zfe8fXjvErFye+8KPN2Tkt464MHBEzfC4KJ
	orOWkFh04zztwmvCLJPGM36qUN1zRzw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=giSfT9S4Y3Fs6MBCHHOkpgsjb4flU8mTLfNnlsB/wxU=;
	b=c+UwEtgWwyc5ExZqiso+pcfyt+iKbZ1QmoTTRB8NhGDZKpUwyzQzLx5Oi6hXFvtdq5ago3
	ODRA0nas4eR1mjjEDHyY5MY9At3yhrqG1QJr6rpr5PRO3un578DMuu2R03YOspCxOxZ+jD
	EPix5NId6vnIBtCHcU6MJtVrfHvraLA=
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
Subject: [v3 08/24] mm: thp: handle split failure in follow_pmd_mask()
Date: Thu, 26 Mar 2026 19:08:50 -0700
Message-ID: <20260327021403.214713-9-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A789120003
X-Stat-Signature: ypdzgfyqj9omuwejizkcuhjr4dpatiin
X-Rspam-User: 
X-HE-Tag: 1774577704-304169
X-HE-Meta: U2FsdGVkX19HJijJSO8HxY8L4C+zjcCjw9sFAyVSTB1qMZc5iCQemkFvVWuAIH7k4PXdUQFhKUWm0muVGGtNfpyvOqOaNQ2NJYdGbLeB3J9ps4NZlGZzZ0lnIHZqm36vsrDYOcbWnc6mZp54RPfivb/M2WOrp6ABUEYmh4InUJjDb9NOhjAk8nbf6FFzi4INYCQ73gbfKyck6dP7YFFDwcIHKgSsO3GZN+gTiygtmaUmb5colVOYzryaXeWF7YfdRfoyBxRXmduflFAbb2+zzztWVBUVHLQuliPFyhtdLj80UGIMx9qTUEWSlHwtKr/FoivRI4kfktPDZMF1+mO8q/y1lN2HBD1JmnkT1Uvmep00XvXycac12us9Ukg8BRvXGo/ajoKwDgOEz0W8h2vwocU7Uf6KGMYe0tMhfv686iQsAmqy8O4TH0hJ15Nh0ifEk1nXVCnBiyVHxE2XAfIfdEaVpvWuWXIyebftkawiXnvqseu3z06gjClDNT4LAw9OgQRBw1ZQFa0fJG1X1oDUGWOrjHoANrHf5F5QoytJWOZi9W0Hj6GH0XwmNWB4GcKcyMsGF0r+Wy3heUZL3hFdof/0l4/pWWTPhRWsBNokUEoinkcAFHqJgI4LTcuPygV4C8U7uafBxep1unR5VXkO8P+/N3oLWVOJZsFl9/3/pTNfPN8bdFFg0qq23IYduFoYCzZfXx1SQ02tT36LUj5HipS1HIXqJvDS6/WQTxiVk8OWrvFEb1h702FQYvBgspzk5s6qQo8cOq9R5Ws6xuUnHgKiqO9gFbO/P0zOlalRNr2ZW4MBjMC4xZvStuCukmUABZ5BoE0JRspBA5jr7jCTEM9W5NdkoIzS64Sla5rMa2alT5pdQ5XFqd7ox1ac35UGCPKlO/xvHDnyfOqXgMMH/1WvEzoO0ZbyXovV2W6b6UQxWobteO8faF3Ege0HJeMGRcmI8UJeedBNTUeFNm0
 YwbnaA6h
 26TtrcQkYwI3AdIKMkt58indM6rHdhJ+1DYRnDmH/9Y6Op7MtOV6QXudNFm93dE2mo6nU69HKDAPTAF1i/Z1EciV9WuuLMwT6G75dhtShVoxf4uXsfoOlNdpuN9cyEtNgoYyrEQZmUBkiXEXh4xGPggPdDzMOOySG+am8CT0vMIRewRCDKJXuQOuXQE4/uTRPp7K4qPh9GONPebNDkaljMz/3L0bm58BFc7EEv59OL2xZoFWxX+aXV2Ahjg==
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
index ad9ded39609cb..07c6b0483c322 100644
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
2.52.0


