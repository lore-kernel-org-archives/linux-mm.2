Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4971C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E04B6B0148; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668B76B013B; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383B06B013D; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA62A6B014A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 052A680407
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:19 +0000 (UTC)
X-FDA: 85093505280.03.21A0FF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E51BE4000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m50VsuX2;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560558;
	b=NvjDuRxBJxNBxv0/1RmNattUPPPYpDQwOLfE7H4392r13umu4s7Jj7Mb5B6vnhVvhfj/hy
	p+QDDGjaZngvo79EghC26/4YIj6OLzjI7St9ZTuBrAmeW6E61e0BPt0y19BWzHQJt+VmWq
	/OWTjnnYT5/BH1nkqyAxca6lte/hj/s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m50VsuX2;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8pR/vb7iTVRhXUWM5NCBVvyMABHIc4ITuH/8n9csnEU=;
	b=2ELi/g8rf2x5eQsGGYcJaM/LVa5j+m4ClU47LlJA9EyxyoNIk7/tX5hqXqhgxnkp5ZgSUr
	7xug6zrEIbOQBgw0L4ukU6J3hRYRdm8EmoDh6CSnjCcXWQV+U1Fm6JToe0zhir77/Acp48
	k1hxQqyJqLl12oDoWvPaFL3VOxOa2lk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 880F444FFC;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63782C2BCB3;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=QbSz+YQQTZ6xFRlXg9OLDeF2jL1LpsveeyExaTayi8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m50VsuX2K2+BX0I4HvRVq+4MGTgtmUFgXpq2HjeojGqPviH3bwowMTQL9j/cZp9si
	 5VIG/SoFHfzERUSTP+TLSwIYMLi7YmUmoRfkUoHEzS3xCVyHa5Ai4m1avYHViZrY41
	 mEFOIIYpRRsDidBPO4KM+RGrxSWdlQ8Of3oLQUWE/v2Ac+ggRHMXwDdvlbxyQeSDwd
	 IMTpTOsOxlzKJRSCyRPdG7xf8+kWNvTeYZGVA1FkpzcUrlgeB5sMmRvie2jLRhMFAu
	 OFEUe+HfbsPXFNS2UyY/QrxVQg8yNR9LZLL7V83uQ48THuxgxy8O+5jcRTc5F+h4y8
	 3Mbfw4vbCOObA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E8FC5B572;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:53 +0800
Subject: [PATCH v2 13/17] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-13-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=3118;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=flVoHm9M5zKLwjUGNriGa0pMoxT0o6QzUJyZyEIqxUE=;
 b=7DHyK/rZjLlMvKwFURyay/2aB1cvnHprN4cS2TRJ0VbuKTx3rnETMs6xNKZNVSwG7/cUwtAo+
 nFEEiTDxTajDsVPW9H95QIQFjwo4VnWNJEkdNJQRdrnRAMEo+g1QN38
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: E51BE4000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ed1ah1fs5h9qp6gjccqpyjt4t6mjzdfw
X-HE-Tag: 1786560557-546649
X-HE-Meta: U2FsdGVkX18Ze/2FL5ftTw15Sil1TgGnzFModdE3mmogCnNSWZZOKF27o2Qsgmw5SBhLODa3aYmwQX1DZjQnMKdNzd7s8D8aqeVC8la9EopD1HAIwdbEpY/3UUqnjMKze3998P/N0ImkRWyFTTwhuWoLT9y/nHJ5rr8BT6ghyPN203cdZKNTM3cisAgCULCK9ExzSNbAembcCOR6oonZUtOh5oG644pYPw2LM+zF+pN4Phyny/lHAzgv5LtfXFcdmyWDhvgQF/mdWJX1jS7E5nKogCNXjn4UL+9q3QynmuDaRH0JwN6TP+YZDIlCUSPyS0sHd0FxMXqqNsXSOi6YyheUrZNLcKUlnl5gaXVoSuvJ58JvS4bj6IeMR7eADPN3U2bju4yyejEKkJvesPC//3M65UOtuZJmaROPTsP/C0YVo6j+VA7LuPVPRsPfNPcHNz4rs+5CfzE46WCscnF+h8ZxSCiJrTG3XoKvu2r9D6MFtNMvur5j7u4r0q/2LfGEuf3L32g3NXkqNimKrplC/2mLihPpOdvdQhs0EkNege+dSbdF+G/nscW83tLjdFqwVzYdj7tDc00ftacyNt7lFblrfxtX+i1h4bJb1db8JThT+Pq0RkUrvhkfyP8mSqvMK4PB9BB2KP1Azs9XZ1CzpCtTGbOsIRlfAG2hVFcogT7Gva+4b+lao4JcLdaf9ZWhLTj4HOOKQ4/D0TcUJY8g+RQ7abhdEbiH4zT+JIe9joLV5NPyLx2VF6H7FaM7PSPg8aV82peThS+J5nE9+0vmZGI/1+/Wc6jgLtqBuGMEe/VHU/jeX9fRSe/rys5SY5bgUouCO66ltOAY0IeAMNsZhZGb82/rrqTiWi1V6OqMlKkvcbPJSLZW3z6EEZDoGOmQW0DQdC0A8y186EehzNfrwpp9fhZohDC5/UUsPHk8wpW2YQJeZBCkftYaeyLZOP6r4qMNUcoceaeTY1wzI1J
 VybjHpI5
 Sgrk91KDC/UFcm26NPV+ydyx//9GT1fWmW/SPYnFQ8KnCXojWZGbAN8dXK5EGdVVwhppoI6sibh/v+aAzNkKStw22NAe4MUjMYB4hE19VXYnr+KgOwja6xjKzyhP6EogIW+Fw7XdgiLTuJEPpzEn9bIIwduFPb7tl54ekNhCDpZEVKzdsS55w+ZuuVSvyqnmh3DxueWlat17kPdEsEMsFy52J9V2pSqEHMNigwR/k6voJ6ZSACloWgDwEcv5jf84xZyQKGJTNiojoojgaIG+aRKSnKdAgXCIJn7YzZ6Z8+0QRuUmmXqjG5YXJU0ZSk9ZqQRXRDfkplJrllDxbza5TmD2qynDI2dWPfct5VJUlfDUJQGg4Lh9iz8RJQLngBFDRDlYUcUWCDajEEJfm5rT9UhAKX6Dd688bKAp16eZbCJrdK2fe81jcrgQxus7kGE4b5WSj7RR6mgfk3+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The only caller of __folio_split_unmap_and_freeze_file() always passes
do_lru as true, so the argument and the branches gated on it are dead
code.  Drop it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ce02608b37f4..72e7d24139e6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4097,8 +4097,6 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
  *             smallest order of the after-split folios (non-uniform split)
  * @split_at: in non-uniform split, the folio containing @split_at is split
  *            until its order becomes @new_order
- * @do_lru: if true, add after-split folios to @list if non NULL, otherwise to
- *          the LRU list
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
@@ -4110,8 +4108,8 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
  * is returned, @folio might be split but not to @new_order)
  */
 static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int new_order,
-					       struct page *split_at, bool do_lru,
-					       struct list_head *list, enum split_type split_type)
+					       struct page *split_at, struct list_head *list,
+					       enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4206,9 +4204,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4226,8 +4222,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4253,9 +4248,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
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
@@ -4339,7 +4332,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						     false, list, split_type);
 	else
 		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at,
-							  true, list, split_type);
+							  list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing

-- 
2.55.0



