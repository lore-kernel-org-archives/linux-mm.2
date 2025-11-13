Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D529CD6E63
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77F28E000B; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19CE8E0014; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E13D8E0013; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5071F8E000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:04:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 205E2C09F2
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:54 +0000 (UTC)
X-FDA: 84105754908.11.16D5931
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 183B84000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:04:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="E/AcQhQX";
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mp9h4HNEk7S3rZCwLHyQrW/gZrKhhrmJFaazM7FtUDc=;
	b=0dVKcI8X3heJwrcsQrl217D/FrdSTPdX0zfrxrCQNuKrvvHCZpxcxur3W4KZqW2lcSQPqc
	OJHI23TAXYVYhSZGcgh2VtjlRb6lKmXYspUT/QOzPy/GClPFqnu0O4H/lfL1ZlFyDI4E7O
	cn5p5aFm9+M1E8CYcocXgqPy94sChAw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="E/AcQhQX";
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042692; a=rsa-sha256;
	cv=none;
	b=dpRcZzSK2bOADpNXDjsIhyYIaePQ4oKN9Xwtc8jBWwRySOoGQ1tsuQZuQ2UZvKJqY5WfCz
	F7tu6mW3RIm6n4lXBInlmCsxfNplYjHZhfxuDk3aOgUgyz1GBbtZ8EA7ZksmsMOM5SUQLv
	cqXzlfjDwlzqpnphyhTi+7o+2GJ9R2Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Mp9h4HNEk7S3rZCwLHyQrW/gZrKhhrmJFaazM7FtUDc=; b=E/AcQhQX2pdX5IN6T2jug9Y4ZS
	b2tdJLqa6EcR52WKpp6Yc9B0j0pUAwSTvElfMO6ti7WLY7NAJcljTRV8h13oOxfNB86M8mo5Rmzdg
	5IsAmtOW4S0+oDjrSZ6IPf/H1byGEUbdXU3As+CEwFWmZVdqEeWEBOuSxiYnyNws3EiD7uLcAYwwH
	X9jr+ITDnsxQz12S86zX0HGF5dx8ZN5fQLKgMBmMD3RvS1biaef27TA7YuXQWX0n6kuN0TPv5j9S9
	Fc9iNMhzCgaV6HaOICjwV4nPWgUaluKHQc/q6xPgax1hYL2MINGaSK4X67Odsmh8Env/GXQBt1hYn
	IaTLXX1A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJXwQ-00000007c8X-3F6I;
	Thu, 13 Nov 2025 14:04:50 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 4/4] pgtable: Remove uses of page->lru
Date: Thu, 13 Nov 2025 14:04:46 +0000
Message-ID: <20251113140448.1814860-5-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113140448.1814860-1-willy@infradead.org>
References: <20251113140448.1814860-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 183B84000A
X-Stat-Signature: 68kzp1ajnj3g7hwy1rnec3p3ebbwucee
X-Rspam-User: 
X-HE-Tag: 1763042691-479733
X-HE-Meta: U2FsdGVkX1/a8nbMBqHkDCTohRPSR91fzwI+ht8p+30yAnmEFIX1oMHSHgFAkqdjXvMqF2PRjlQzb6iVXQAHjNdIGsndm5h8Ev9fQNcwdNHvKjAHuGaOTDzwcsl964Q2Qk8pFgxckBNI399hqsJgVmCPTQuo+Mu9lcIO38sZe9RbPi0TsiOVB6oKp1wI3e8QlkVH2D1LwSXHOgAD9Aao33xkvUxnq1uJxvYQ/SuoqkSY+/ykcdBD14EA8Kb9rX47Rfx3rAykym1iWcurSfcI87QZR2lYdqpUsoUQvR3Ul5+bhtWuLRYDWKHllGVNeCbWgqTezZ+DrOMZXKqBGr9e/vLAPwTaI5SX1BDzbbOIIP3VB7I5RGZdtv0gSBfmkMz37seaXr+/7vpj0mlsXSkKo1gffO7DuPNOYpnAff6uHBsj+IAvDDMjrKqU00A0dvgIfUj0CXTjoP0YmjnRdB1j382CkZjSsbZTrefqOCW0fGQUmLgK5Hij946yadYjOJG5lkiMPUtyGSuTVjiG6eYVByuSTOQZWqxlMsX/5MmjVQFyX08tFrO2q0jqfghP8RjzYrX4Is6r7EBh85U1dqHd2Xf5z+IMCkjW8i02TP7tpxelslLzchn2yyvrQ03ZoQalFxEl8DFvMhKCi4nX5NBzHL5YGLo6ytYsxJl79KWUSlBlpeppFih5nNkyCPW6QYCSGwiZWg7Hr81HZkyTydfdhGnbELXSR9yf9yqMPnkmAIqeMW+Vk7nagTAOQ0bce4T983Gemhju7f8E7AZpmCR5yZqUq48qeZZxfPXtUM35hq2cpzaQGQbKz8JgHVPwHF7dxfvJ4iMFZwK0pxokyeNZUfx8DdVKgX0pA1FAyssPlGsHlMkJw2xtQcJhkIC08yZpOdhV9IpG7VCFUxY72j5/6xUYI9NiV4FTVnAhYZZh9cWWD4eANBNXh/3HvxUGFYi7f8ju1AT8yS3NVL7BVeW
 qMEKDHHr
 Km2BegadiBVd5gxJW4bgJpnpt2xba95BXUZ4rl+SLCJ/fmHaj+e4VZqEUaJXefdzY6OiF5fJ7uL+rSPfDiDzfDncKmQPORJlshYVi9TI2QGjqydyR9UTysnGPNASoVgD6pSVAXQEZZfVJUphOA6+fm+KMjkP1XhXmFaRvZ7Y1rmsCighyEZOZNC2ttAwj/q/bk/Jby/4A3xDAWOgji2pog8P9x8fKW2SDqT0TJCtqGp6Ue+IjaGyR5P3AKUWS6Se6yNYKsDFN+ky/7n4eSsqRNmRPcbrc0ahvuixB0SXEFjuLSAAE5qZRu/j39QNWxjqOy/Fdstcl94UsOyzrfuai4J/deD5XMIlGm+FuCsx6i7V3uvM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use ptdesc->pt_list instead of page->lru.  These are the same bits for
now, but will be different when ptdesc is allocated separately.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h |  1 +
 mm/pgtable-generic.c     | 24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a0f4bd6099cc..5e08c4a41777 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -602,6 +602,7 @@ struct ptdesc {
 TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_head, pt_list);
 TABLE_MATCH(compound_head, _pt_pad_1);
+TABLE_MATCH(lru, pt_list);
 TABLE_MATCH(mapping, __page_mapping);
 TABLE_MATCH(__folio_index, pt_index);
 TABLE_MATCH(rcu_head, pt_rcu_head);
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 597049e21ac1..a3990c04b31e 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -166,13 +166,14 @@ pud_t pudp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				pgtable_t pgtable)
 {
+	struct ptdesc *ptdesc = page_ptdesc(pgtable);
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
 	if (!pmd_huge_pte(mm, pmdp))
-		INIT_LIST_HEAD(&pgtable->lru);
+		INIT_LIST_HEAD(&ptdesc->pt_list);
 	else
-		list_add(&pgtable->lru, &pmd_huge_pte(mm, pmdp)->lru);
+		list_add(&ptdesc->pt_list, &page_ptdesc(pmd_huge_pte(mm, pmdp))->pt_list);
 	pmd_huge_pte(mm, pmdp) = pgtable;
 }
 #endif
@@ -181,17 +182,22 @@ void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 /* no "address" argument so destroys page coloring of some arch */
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 {
-	pgtable_t pgtable;
+	struct ptdesc *ptdesc, *next;
+	struct page *page;
 
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 
 	/* FIFO */
-	pgtable = pmd_huge_pte(mm, pmdp);
-	pmd_huge_pte(mm, pmdp) = list_first_entry_or_null(&pgtable->lru,
-							  struct page, lru);
-	if (pmd_huge_pte(mm, pmdp))
-		list_del(&pgtable->lru);
-	return pgtable;
+	page = pmd_huge_pte(mm, pmdp);
+	ptdesc = page_ptdesc(page);
+	next = list_first_entry_or_null(&ptdesc->pt_list, struct ptdesc, pt_list);
+	if (next) {
+		pmd_huge_pte(mm, pmdp) = ptdesc_page(next);
+		list_del(&ptdesc->pt_list);
+	} else {
+		pmd_huge_pte(mm, pmdp) = NULL;
+	}
+	return page;
 }
 #endif
 
-- 
2.47.2


