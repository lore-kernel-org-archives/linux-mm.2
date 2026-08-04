Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D681C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08DD6B00A1; Mon,  3 Aug 2026 23:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44E06B00A2; Mon,  3 Aug 2026 23:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C1B6B00A3; Mon,  3 Aug 2026 23:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 869296B00A1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 092BAA234A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:17 +0000 (UTC)
X-FDA: 85062224394.16.49A0D88
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 43FF51C0007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DFpcwSIi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLDW1MKsRg3YxabDjaQCuEM3DeM9EuZ/ZJJJqQFbzN0=;
	b=PUkXA75YO+Akr728DJGj8GUQ5UCm8rnHBRknibGyH9XfK6Vp2Atc2G3H1bNGecuTlxanSh
	U64yQiHBkDYb8I0UR+w6vUzdnZZtK3OX2wACjJYxd1aU84B82t7IdgSePosIaIY2NgDjFZ
	wJZIhwp5sCB4yGhZPhzZGqpDm0oqwRs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DFpcwSIi;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815775;
	b=D3ethhKaneTtLy8KyAmgaFhZaD7LN8h7j2TD8PCtYc7yg2FFYVT+YD1q+F1abaEjqNbySm
	XPAWwXv/AdEb6x46FvSN7dDkDCZtSzFzp+2VhG+w3lNMt8N9rCh4EgCelofmsgOT0UqGj3
	oFzrqZZsXB4wN1gQvsJBmhskDXlT5d0=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ceaf8a1265so49304355ad.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815774; x=1786420574; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qLDW1MKsRg3YxabDjaQCuEM3DeM9EuZ/ZJJJqQFbzN0=;
        b=DFpcwSIic0pMx26/6xnlff3jQoACMoc0wAilr/SJw1QNWT8MhiJDJYRQhKzIXEbNRe
         mdRmxku4EszS+BvnTsx5RDO0uojW+Byq9/m9YGzGNwggPRcad2ZLeAJJqWd148yMGf6y
         bwbRp6STzhxs9Luw4uSA29kGg2fRynTmWOclEr9dhlLVRsEzGAbdM1LtoG0xLOZX/Dey
         vPuil+sFkYkAtL3FFxM0c3y76i9rDOhXvWztoUvlMSmHSpPK1LWbI+86Pfx34xgfXRX5
         eCpWen74VIgBIkAPAwhhwjAIOdj7mPzap+VxPotprLizaOB/RFUs/lr+fSu+eN6b6aSh
         3k5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815774; x=1786420574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qLDW1MKsRg3YxabDjaQCuEM3DeM9EuZ/ZJJJqQFbzN0=;
        b=kjsoee7QNr7ci8z1qOh8TgxKQe63L+SOkeMF1yoy3OyB1QukKRJCbGpaghI5A2BbGh
         8GG8nh9hHwspVmG6pda74vltAjkxQpzJmwMeXyEmfVhfj8QJwPfpV6fA9yH+wXYkU49g
         9vdDE74lQwNRrXpcEPgdGICbkSgAQciIw8YnSvASPxU5YYENNhigH34R+/wzfrjz7jmQ
         yP5QdkI249F9FXNB+e5x9MMfi8bmeyz0UO7DvcyiZQ2lDFVm4PzpLxwCN7W6t6Fi8DDh
         IGT5K/nJVNh9Z+OfwgxjdFwl8BUx2Hcov6Vht+e7CW+BmjT9ZpMAN3fah6UpzR5GgakF
         t/BQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJOSs2veQLluizSXJzxRSl5+p5lmeTcPBBkwf+HLhqJm4OMOlz+FfpUuBkA947s44IzXOCs35LlA==@kvack.org
X-Gm-Message-State: AOJu0YzX0+EBDgtSltPqs0pCsmPr7+dTChq8MBCekI43rhO0BnxeHPiz
	L+TFZHDYWrD48M/2cgb+BF/xirK8QAOWzytzWp48vGKauOd19edNN79agSqKs4oF3GA=
X-Gm-Gg: AR+sD102bdWKmQD3ZfhZQge5Cm+Kbr0JBCpfS6olv0mLqPrM7eU4co5tDt11DrlkRzH
	Ol3KYqbxNjEjroITA4wZEqv2nReHnjG12TMK/6wIRPu4PTEo21lpIWSA0sGbLdv1WSsE3nsrMHh
	Swp7dLHW32Tc871rwPnmztcnW0xflV9lHQbmk2bLRm+TRbYKf/BJw0hdbOXipSrwUU55Uh0h1id
	1dpcNkhUOivG6LR+k5j9+3R1gqB4E1dFkNt463VHnN7gOVVt2IeOo33zhefinJsdXncIKEEcTG+
	rqZZdyX0qiAaKdKCKqDzRDft5d6DEkrgAsxMQbWlbhvHSUxA3fYAva0AHO0T7bQro7KWwOyw7fe
	+XD9CxcUGzvCLPUv/ynK2kk3GA3RN1NmRvOrdBLqQgmtXJiTOUQ4UAWraTYBZl37TPTLdq1F0ed
	9B0qyZIelg6A4Dq8GdzFGJpV61jkP/Pp+82MSC4Invb0dEEC4ZnPSl4ULm9GR9sy3NyJgg/xgCn
	rqo4EuV
X-Received: by 2002:a17:903:26cf:b0:2c9:a9c0:80b6 with SMTP id d9443c01a7336-2d052428130mr120815945ad.34.1785815774133;
        Mon, 03 Aug 2026 20:56:14 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 07/17] mm/sparse-vmemmap: move vmemmap_get_tail() before PTE population
Date: Tue,  4 Aug 2026 11:55:25 +0800
Message-ID: <20260804035535.2846016-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 43FF51C0007
X-Stat-Signature: bhjksb4a9rgwsmop5ab46ptf4crewphi
X-Rspam-User: 
X-HE-Tag: 1785815775-673239
X-HE-Meta: U2FsdGVkX1/rRi/1hB6bXKQ8wh6bXdqQEotJtmrvqrDsTFJEKyiSPNrK4gWoli1JtQr5MCxUOTQ0YhMRTXeuqMTNHPeGbNsaKefOOy8OmndSqG0P0rk7chAzguXKv11F6oS4Lfz7TKErZy9v69i/kwSCt6Jt7uVqnCkagurZbJNblipvRqhm9MdzM9s7FoCScd19dV3HACWAy9ZInoab26cBIcaEQJJVw/1GufDrcjPPiGYZdjRGOSLoD76uWTBpADHkP0if5wUIDWSdAiKYLEbpD+xw40pTmyQ0MnTv2B0AUmm1jsP9uwy5K3nYPR4PLJKa/suKEk9sI1vzZm53Y3CmFb1Y8rSfl+Z2oqZ3m+fM7slfheZWXU6VVUVYGINxRwF2tpOU1i19yW1yfwjeStabHsxH8JodOQmTHp8J2y5rBP3/ZBeQu3pOBwWGqpmVpma3SYmgocWVPKocyOMLB3owqRJQsVCdXBLu6DoF0/kePRKQB2YMmrU9qqiIEc6oqiFj3IuSsucN1tGO3VbhFW4FwSk91khZfUyf1aRxtWcizTAITpiCAFSKLes3IvTmS6JeJEzH9BLI+JFxiAAg4yZzl5CrQHDYpZwvxsNoaj57pVveTYsgZTD+wa3hXQ7SkbAnIFw/cynTA+x7Q35Ek6zJH8tmxkcHVuKDPlw8FFOIMdbuyuJtkUdmdbKUs0nssYRak6Xs5hx4qvE3nRNA/qRSVnJbWQDfam6a+DOQRpMCi8kCf+2hzUWJwSjx8jExDjMahlXQPl4ertLI0kqM2DhelkctgvAcVMRMSt4BOtyFefgn9D0X53p3N+8TvfhRD2+DRn1Pwmezau86oWaHdacxqZNEN1vscPN/n/fUZbuji05H0PELKt3zUYeVVH9+RgjNHECvaEOxCLQZO0AH83JDXANcRFM++gQU+IaY4mIY+Pa1zHNLDeFnI9U7SYLE87J5lIvsPCqCrX5NP4u
 kDmjFcUa
 3nUrg6cGTgD9wwH4Qu7XKCf2QeldHenvKLu9k3BLKEOg6StDZO//2usMyrTUWy600rRw4ZzXX+woKsbJB1WWDOzfUl8OdYCSiXVOrdaVxh38hzUD92T5MYHi16sWG+aTYTNkndXlW7lAw4SidrISNURqFEgoHJvUBFhczD3MmuXrz28Lg1pYtBk3L2BXKCmy0pO/p50lvqhFJ4MNQTpvxnYesmlm7eiX9BdKgrP2qSxx+EQkHBDfw831FaKFCWdd9qDemL4sGpCqXQiEEi7qY8W2r34Mg/n7toBjdopXGzm0z8OwIV/TzFlTokojunzXHWhllLOCL/jofyRLi2XPdKR5DePVm+Pf+7dd4MFBb5cVUu2GhqRonADbvLpgpt964lFekul1aC6yaJ9a53g74m3w3gi6ZE2O6i7fKC6kWjddn9SFIdgs417080A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A follow-up change will call vmemmap_get_tail() from
vmemmap_pte_populate(). Move it before the PTE population helpers to
avoid adding a forward declaration.

Move vmemmap_alloc_block_zero() with it because vmemmap_get_tail()
depends on that helper. No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Add this new patch to move vmemmap_get_tail() before PTE
  population (suggested by Mike Rapoport)
---
 mm/sparse-vmemmap.c | 78 +++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b7abc5494bb9..b770fe2428fd 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -148,6 +148,46 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+#endif
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -181,17 +221,6 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -323,33 +352,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
-
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
-		return NULL;
-
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
-		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
-
-	return tail;
-}
-
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
-- 
2.54.0


