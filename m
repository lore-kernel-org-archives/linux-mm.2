Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B40DC55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBE16B007B; Fri, 31 Jul 2026 23:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C861F6B0088; Fri, 31 Jul 2026 23:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D8C6B008A; Fri, 31 Jul 2026 23:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8040A6B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:16:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7DDDA0FE5
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:22 +0000 (UTC)
X-FDA: 85051237404.07.EE20C29
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5A86F20006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=oPTdc7GY;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554181;
	b=fXNWaOESE34wifu0lQIFAGeJ3j5Zb+7aJMiZvr0hL3r8pUwFt8SA3ODGrORKWA+wL19M1u
	uhZC+1WdsBv31KyazQDcLLN1wnVdFedHfUpUTyT/ZAapxoJJg1HyFFqDGfoSpFke31sxhO
	TcRnFspEtBr1YjoKSsSkl+V5R+cbSSc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=oPTdc7GY;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa9J/+YO6I4dfQddtw/Ia7wDAxt2roUtbkMuKbEd/24=;
	b=Cq5p/fxVnH+6//Rh7HcXtvX1GMcKovvlZtYE+4/3ArdhKM6VyiO4N1OKeM27CRZvDAaeRa
	p86U7gzPpiG1ghfrDNZqIRmyVEWqya+Hu+2KV3s7FkXs+JZZhS99xPkOrgYtdE8aipCn+J
	76SI9+KKhV2UyXwJT1UzV5jKrOZ81A0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Wa9J/+YO6I4dfQddtw/Ia7wDAxt2roUtbkMuKbEd/24=; b=oPTdc7GY6cMkQue14keVS8PtXA
	XMgVlDpD6bsEpPAG6VEf8wL6uLFYKX3uT+NN7NfkpFJrlur0MchHYWQp/yszM0i7ThzXFFnZKYb2K
	gFjH+MHq/WheyPnqmiZs3EG9FHyiGV/4x9vk2CTpKt+M+361VSCPsqcaHyL0ESyAF7XR4O2EBvjH6
	lGjMyzugkU9m8drjEWEicpM83GwnpbrfJnIIb7hrFcTxS6nYtVEsGV7bSSE6wUHXT+oVOlaOKqyaP
	Q/tZ0yvqk/OTV/1nZEJfJQPRYqQFw3MXudWgc5tm2v38cf5/tmYOCOeMo4ZYH/1ePa5acd/sM5dhu
	UGT4dcjA==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq0CU-000000001Q5-3rhq;
	Fri, 31 Jul 2026 23:15:50 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH 3/5] mm/gup: add gup_fill_pages() and use it
Date: Fri, 31 Jul 2026 23:15:38 -0400
Message-ID: <20260801031540.2742891-4-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260801031540.2742891-1-riel@surriel.com>
References: <20260801031540.2742891-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 67affhqhgddn78fgbhcwz9zbggmydzes
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A86F20006
X-Rspam-User: 
X-HE-Tag: 1785554180-15057
X-HE-Meta: U2FsdGVkX1+NMS8KufTeeGMgCX5No/6Z55TaDIdNPQ9VVUH3mRGFUizSKmm4II16VMw5oOfB/cc4xNcM0PQvVldg339CGSpeIWr7mosJDRWKKgWtampTZClhcfUIFtl1F8OpZWrOt6NbAbYSyQowBu1rGkeCy98MnuqXWLy7S91cuxX+zJ7/6D/WjtnLRHj9/kctoV1ZRcPWT6MmH5uno8yOFJNzywL/w3YXb0+sh/k/ici+gJvplaJdJ8zflVewmXNapviZzVgiHxdgCknNJ1+IqA1ZNy684zXjM1MWCgXkwbILj/iGWBuySHKy/7imOELdIx4gP3T09JllH6UhZUVK/uqXAPsDPbuVKnyoqyf18LLsWVa5QYCt17J52D/gqqI1rFxGzvBYQ8D2M9i9p+wZ+J4qY54qCXW34PZ6iVFFDf4d5DPH3cUy5Sn/VOapedRn6AyEJ0slqz4WHpdAJM81ubT9Ui4+GRIjm8rZo9FgROpMInGwPNnKfY/whNaN/VLMbQufBaaHuJrHIRCPv3yiVR0imphDWe/h6Hho/l6u9nXS/FKdQxtQ19lvR/3+jkeDObfvxzKMg9IqpsvNIDZVRq15Sbmr6Tl+k4FqTU5CdN8220YZfhpr+bPqMWh7NC1kIQHzAI7lbMl1vROMmipp8m6byjhwEiZuvzF4AwrZNpnLYDBbvENsgoousLcRW2SIHH/CPdSX2W6Ip04ktCj+5hQmEsFWx0hVVqvdBG8fcoGgT0fXXyOL0GumyhMN9xzxohSnmOJtbFY6w4+DCt6kcHMz9pgVZ2lxQP/oy3DhufNSxW2oraoUmfZogzLi+MzsWSTTzgxP/JVbxsRHWXNGS63humLwmkkJgVRbCduo1Di24XrnOieKsbA4/ihP7dn1pbTgSwibhigxcaj+lwaMxXVcCB9RsrL8hts/1IQaW5nWimBKFcplln81ZV0xbY0t2RKLWVdwB2GraOv
 Pa3IfDR3
 zk1ds+DopCHxJ70vhWU5GoaQ0kG9lq7zgn7MDp/11G9GLB/Od9XtE1JTYDDkWjyuNpmkYm3Og//ss7u4+gXG4gvuBmY+4d6QBa91we39KFcJT1mRZ3yJpdyJzVx9C+nwZqc+zLDbDRmdwJNJjChPJhdnkpEQmwEP5/HIBLko46cQAcLNkFd0xPaeSJIe2hB9bHYL5hpIEx4HemYUYSxlcSuoGw/Z5d0cFjKMwt3aoGvQVtVs/vDxtJ3fiEtpVkAvlU+LhJ/0tqB04mKD3sEZy0EkSEYDaI/BwZKucckuush3BwijwvOQR83MRWNwby+LFo3Ko4jF6M99HnWn/U5vN5PdaCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_huge_pud(), follow_huge_pmd(), and follow_page_pte_commit() each
store the page they found into pages[0] and flush its caches with the
same three lines.

Add a gup_fill_pages() helper for that, and call it from all three
instead of repeating the loop.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 053da43760a2..b6d508a44ced 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -633,6 +633,23 @@ static long no_page_table(struct vm_area_struct *vma,
 	return 0;
 }
 
+static void gup_fill_pages(struct vm_area_struct *vma, unsigned long address,
+		struct page *page, unsigned long nr, struct page **pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr; i++) {
+		struct page *subpage = page + i;
+
+		pages[i] = subpage;
+		flush_anon_page(vma, subpage, address + i * PAGE_SIZE);
+		flush_dcache_page(subpage);
+	}
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -678,11 +695,7 @@ static long follow_huge_pud(struct vm_area_struct *vma,
 
 	*page_mask = HPAGE_PUD_NR - 1;
 
-	if (pages) {
-		pages[0] = page;
-		flush_anon_page(vma, page, addr);
-		flush_dcache_page(page);
-	}
+	gup_fill_pages(vma, addr, page, 1, pages);
 
 	return 1;
 }
@@ -747,11 +760,7 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	*page_mask = HPAGE_PMD_NR - 1;
 
-	if (pages) {
-		pages[0] = page;
-		flush_anon_page(vma, page, addr);
-		flush_dcache_page(page);
-	}
+	gup_fill_pages(vma, addr, page, 1, pages);
 
 	return 1;
 }
@@ -854,11 +863,7 @@ static long follow_page_pte_commit(struct vm_area_struct *vma,
 		folio_mark_accessed(folio);
 	}
 
-	if (pages) {
-		pages[0] = page;
-		flush_anon_page(vma, page, address);
-		flush_dcache_page(page);
-	}
+	gup_fill_pages(vma, address, page, 1, pages);
 
 	return 0;
 }
-- 
2.53.0-Meta


