Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6AFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EFA6B00A6; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E7C6B00AA; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625A66B00A7; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31CC56B00A9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C87D1C1881
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:16:00 +0000 (UTC)
X-FDA: 85213020480.05.E8C49EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86F6CA0008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XjDeKl8y;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406158;
	b=PQE6bVdjva0GIVgLqNiWux7wnmeBfd9yRUNzyzIp/TlsgvFm+IhYnkUGqrY4pNXRV4wpx7
	Ly8jOD1tnI4Pm8pzADYIM70/+G9J2l1Q2/l8MxmPE6yQqKfFr+eaWvk+CY90aJlVqoeaWb
	JpfRyYfvqwEbgMmlg1O7BQu9IzMT1Uw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XjDeKl8y;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX1TQZhWpf7hxFoVQpitBTpLPYkKPxpOL95ARnjvHvU=;
	b=eneKeP40KhHP14zL9ua569KPN3+IHLuEmR4qM++E77q1C3S59OABmyUvIzm9ECj5JMMm8h
	2O230po3oxAa9AlWiZjbWhIbVEKtnlcz/9SMJubhsXsIBaqo6Pix9mIH+NOIGe028w50oI
	u3vQhgAZcOqkLlXyUBvbnTM830SJAII=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC92243F2E;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB7E0C2BCFA;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=TThUiSzv0IeiGg3Zm+rPoMl7tKqpff6Xjqe3H1+p5es=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XjDeKl8yMLVTIdXAyHBkwlQjVv9zIGksMNFtdT8NaxO4V6eJKlW2fMVjubAU/U8Ka
	 CI2NhegFvkjBQP+Z0Ri2/Dcnw2cp8MBUS7TXxzBueHY72hm/MO9LEyubZQ0djEvYNq
	 UxSdXqML2scEI+ArkErU7e9lPQaYMOa5GM9n802SvyREFca+Ul+etRj8TJ1LwnXR+A
	 co8hZ8CJ/knh+ZEAXssC5eNSuWonfkylg8G4eDLmLMWH6jjrD8NO9ZIjOuY2jkLdFl
	 fVsFof/2zDdNsEFQH5x+tdO3hGZYzbasqv69SuxGwPImO9kxPTZ7RwIaIIsWphHelc
	 mSQf378SVeJbw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5444C88E6F;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:55 +0800
Subject: [PATCH v5 14/17] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-14-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=2493;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=m/gjZObWp8hCab6M96EKaw8DHAEZ6xi7L6smiR7GbzY=;
 b=rnXVgY74a30UHXc+wyXVoP6EU8ZLn0d/jeMbScPXNNuqGMhKenNKy3TiLHdK9+2njQQvoFhc9
 nEGmzGkbcZZDqomGRYto19YmQIXqwIwaqH18VCglN9jyhtOIWHTo6tD
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 86F6CA0008
X-Stat-Signature: yh1eh5oaeupgi8ac73iqsatf6eigdirp
X-Rspam-User: 
X-HE-Tag: 1789406158-879715
X-HE-Meta: U2FsdGVkX1+2IMbHxfEOSn6DUH1+wWREjIVdRmFS0K1XJUalv3EN+k2TbBAKrqZzZOdO5RnPKWob3R7wujbPMWYiPWJZ7oRNBX6bxxL2xCoNjkQGMIJ5cU7Ayc+lm6njRg9l9oFdrDdeYpwMbS8ExWwtyhp/jmive6MynEEcdZApSKGKoL09gcqpjvCnmOpTUkuCXi6d5QBeFHXSVttBkpFXWff23kpLAhiBHkrs4m68kqlmeQUym6jr3bPnUbdYkDQSqWm+6gT0kERx4qlJbwEd7Mt0o0L1P+F4sOdRmWt1f0qfH6Z/+WKT53DbSS7Os8VF43EidtYvDrf4VDQ8p8gzcqOWn5Mv32r7+/TExtYHGGL5fJxNACLK6k6nSBmOJbGMiYbbWBROPLEAOOecxIaZU2dwtp2YrBBdvgKzRdBTg7kcheOJ2B4ccpoquhCJXPFqTF+GWp8jHz17gskIfv89yTDCNagsM1ilMg08ifYsvmq6OOQ42zsmiTAv4feviQywndHeWZK03VHoijn6MbFFM8qxvxALkWn1kCTsbhwWnN6e2QbVNAXLIRQEkshb+z740VjUh9jeOCRhyLHdOSNpLTkICp+ujavh53fOHd6BRZhd7Tza8gy7rHZIYll0wAfPjw4olIwDmpcAv4mv71TKmZt5JrLEv8rxXELMCh+u4gJOaDMjN9bo+VANUpAodTaMrn3sJWkiHN5Ygssx2BZIg26Y4/0+Ke+6RaQIt+Z1AGd0Nqv1HVlP+uI7O/86tqRqBDHM5Wew7/lSrSUPFtxIHxUSLGVHA3MCOTAe7Q4XERj9nqgnu126SpeHdL7WLjcS2aN1TyjqgJux1itm4efiU3EGlpjkKzS0DSrmaVhIUCDAyc1tc3W8fyT2IUYj7C+ObLVCC+5UL0D0FaWTcGcGyY4sw3IvfeVYH0jf1rqKwkx2enPZyqdofhu3uDqndTZuxwNU7HrDqeElbj3
 1AaSxS6X
 YdjsJbY6WfqyWAO8Vk2Ul5hrrhDML31kRNjPIFDIfFx53jUPpGHVq3i/KtGtOl+YwDtCG57Btg23FXt2ydJFHwL3fEWS9PphhPCkJq2it7pkV0/e8CMXVU/IKdTG3sjm2A9uDvjkMDYl+L1JB1j9FgZjHD2JjiiRa9A7mCZy8b0heYhYQdXTnbRrOQZX9+gMWN0PfPq+ND/2wvw1J1Bp1vVur/uRLAvjoD9ojkCYWs0zpIboKP9Feb5dICOWeRITBkpoNIvLz+N9skHFLUWSt/S6pKxnCkkd+YI2JfbifPdo0oDnrhyca3aAcVhech9uquBQnzcm3ARam5OIIke81+FzX2K53icOYOu1o5s0ZAbTZ3878MooPJCtJwFKlbReM8J8Bz1njXxQ9+pSiHQqL8eYl9+8KExSqNHmHev692hhLB1AzYAgcAKLTYck9KRpOzBLROjdnXM18TyRtaQ3jvS1WsIxt6DXWJSwpcoPgYviWp2AHU5IlhDpx0TO/PEiIoEX6URJCc6XGZmLUb/HjiDWp8cMjk0BBcvMfZWm72D5G4AbGfk3r0T/9bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The only caller of __folio_freeze_split_file() always passes do_lru as
true, so the argument and the branches gated on it are dead code.
Drop it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 169832e2a866..b134acfe1542 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4134,8 +4134,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		bool do_lru, struct list_head *list,
-		enum split_type split_type)
+		struct list_head *list, enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4229,9 +4228,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4253,8 +4250,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4280,9 +4276,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
@@ -4362,7 +4356,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
-						true, list, split_type);
+						list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing

-- 
2.55.0



