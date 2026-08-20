Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC7AC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556F06B00AD; Thu, 20 Aug 2026 14:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507196B00AE; Thu, 20 Aug 2026 14:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF886B00AF; Thu, 20 Aug 2026 14:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150866B00AD
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C0DAA2C06
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:35 +0000 (UTC)
X-FDA: 85122551430.01.B8E3A0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B4474000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Omn759rG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwU9RVbG1BrBrdNzjO6igtoH5RS1CGpbdx4N9t90Y04=;
	b=qyLKjeYagl0CZ4gke/oZNS8Dn420unWKdDrmiLb7jGfahTeGH6cIM3Whh4nR0JAqUZmH8z
	LlHSlVl2BJujeSB7pFRVseNamRKlzGk0FWgsv8zCJfe19/3/OLZniXXzZeORtIeX2P2CLm
	lnC14ZW6m3YIgjtrbmPmocCu1tcGYdg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Omn759rG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252133;
	b=kg7EbfCUM5Daey65bjgL/1DPjbxi+RIZzCa3bwXC9gqLllAUy3OyosoLrQImhQDLitKSl8
	a2jXFDI41QO6nEGW932nuu6rT5WpaQnuJ/ZUcW3k0uLK5ZfzWNSINK3J/ReCnBe9L9cV0C
	CwdpqpcZL0nLcjOleCqRa8Wjbe3fE0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 782F245037;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56433C4AF0D;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252130;
	bh=SWtLgMu8GvUawbF95kE3Xr/LCFZlkb7lXy3FF4qxH2c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Omn759rGwGCH/Yu002GtXsO3kH5oCUq0cfePxXsf20jOf4JLWB+zBobOrRKDnwZGA
	 rNQcbmOxvyPIwE7WbnKbaCwas1x1wqGoArS4gd99g6eGnmHoEqQ3qHYbDjkWJbgs3B
	 h/jjSkowmD0G3EQ0DPZco4p75raoQpterjcdsyVxgrI+ImJS+OdkhTUB1LCHGQUy0Q
	 mSkAlGERLROwGzpYTjg2Wb0mrKJ9iMnoyXvlZf3YvMuYgl+XMw94cNNfSuc+oeWXYj
	 iKlHfLkcUpy2wzTM6GB/8ThFy5GL7cM29Bmz7gFIFMkzYCYyIPwKXlEltGybfLLdUd
	 kt9bZ50/ghquA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFE7C5DF81;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:31 +0800
Subject: [PATCH v3 18/18] mm/huge_memory: drop the redundant mapping
 argument of __split_frozen_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-18-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=2730;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=C/KWMIc1TIGmzytCo1JZzeZN1wb37i566yMOyV+S0h4=;
 b=pofJaSAoZPdagM0AwrC0JaDfa+6zRFpa+ZSDQm5WY/uffAKQWRp+Grd+4i7g3llomauI/M5sO
 ei0FFMii7viDibexOhjJv3emPk+9DlA90cruEMHWMOU4KNGEX7o7opn
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 8B4474000B
X-Stat-Signature: 9ctoz3yaaqqu5xenegzttqj3nb95xy6k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787252133-157190
X-HE-Meta: U2FsdGVkX18zSavePGbo2xyyu8QmB2WbBGMyrV1XkU9fy8NE8brd4mDfA10GUmDM/y0VwBVhIUxRJGze2VaMDhXeo+zRxKprL3hXjZe6c6AmIoOaPtrX97hbxgDl/NRE5HsSlzbhhnxwFaKtXhTlMM17pdefvU6WmVv/jxAUET7+b2cIM6VpJa4phnFvYlXMEkvoEaXIs/gFHFKgc60vSExlDBm1a5COGj9GsAB2IoNQ6KMJS5pWZJugj6syyNcNf8/FYaHNiT/gj7ZAmcGil+p8mZs3oiMy+yBgdpfccqzmb9b2xZh3Lrphzgk98HAMGVfmBIyndwbYC0YjkoGfq9OB18j0nCBSW47ojNQ5Gan6w2VYqUmFWXAxOjniOLFA9Yzps1WYC8p+RpRu/QDorXcA1nx5WoZAGpwfmip+PQ1bQydXObf6j6aMW0ShjT2XMWkm3D+NWvOINVZMm+DdoXog5xhxol8ndkcdlbU2T1wAx6g2w5/tu/HPvsvRSoQN7+w2qu9NfalEr1ZsQ0EaqXMmN4QLRYT7w75V9igJwqVFG8/RhS3x9P7bpCS+mHkqX2ML+V34QenQ1a8/JbflgPEG+Eu7Njfv8yy9ZHHMYBgcbPiNa2wNbBnycJz/gI7OjFOD3g3RaDMwnmi1FccN0fdTMjbhINj+vFHtt2nkEEXJyw7+ku76zeHXzi5+9puAq1BA8IrtaHbpHwLuUKHFpUaeYdId/OetDlUx+8hDwcwqDmmunTIU8WH75pMzyZ14CV8JhE7jtVLXpJdXHGJolMsB3eWoyGGMXk6GOwHr2vKOJ3pMnjpmKDOFDyB3DfaKYpZPFZ6pCj34Yp5OMPf9tSLfREQdGCvXKXfwidRRblvbC4OE75cYJR/hlXsNabjk0N1QcLNlqElxtyAjWmtbvvBReOWZ7eycEdLL+BOTHZ+ULOIyup7gg7wqc9H+eKpenIyAfj9QnQmyTJfB7Xp
 M+iGOST8
 Sh113f1zWjTJpE+rTxNEKWbIqPHmgOXEX7NC74YUZowgcEZsiv5kvTG+jHeQSFCIFNC7K3rVMPhUNzU7PJWuieQ8TafbYGHyApGAriPHEe7YXAAAqdKEdWgT2rk0YJC1CaXhQ510qoLelPqMwPpqKJmOQyQzIiyFmEcpi8N/TF2jrgtfkNMdqFatxF9z/hIi+dQ2gWP1TVePO5T31xHzguVCWv57cCh15h0TqHVFgGA1xDnMjiwKatWpvx1tIk9jQSRSyRHQmAbigz6wYLjGxHQBnux2r/xI97a4cZfHAice2250DWFvVLsw33FJnMOqU8vr5pCw2L6nIPx1zeMoFXKz8jHJLjMrH/nohnLEPYWUeYA41mDjYxXaGR54lqnSX7XUTpvLaAjY8Yl0ot1zJZj0Kl11Zb053DbOE2SDJiCzQNoahivn0Uend7rfMVIN6sHzkfc0HNDmZJP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The mapping parameter only served as a non-NULL check to detect
whether page cache entries need updating.  The xa_state pointer
conveys exactly the same information: the anon split helper passes
NULL and the file split helper passes &xas, which is non-NULL iff
the folio is in the page cache.

Use the xas pointer instead and drop the parameter, along with its
kerneldoc entry.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3e4c0fac7ba6..cc9f7e0d4194 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3761,7 +3761,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * @split_at: in buddy allocator like split, the folio containing @split_at
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
- * @mapping: @folio->mapping
  * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
@@ -3794,7 +3793,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  */
 static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, enum split_type split_type)
+		enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	const bool is_swapcache = folio_test_swapcache(folio);
@@ -3816,7 +3815,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		if ((is_anon || is_swapcache) && split_order == 1)
 			continue;
 
-		if (mapping) {
+		if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -4030,8 +4029,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
-				   NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL, split_type);
 
 	/*
 	 * Unfreeze the post-split folios and put them back to the right
@@ -4185,8 +4183,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = folio_lruvec_lock(folio);
-	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
-				   mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right

-- 
2.55.0



