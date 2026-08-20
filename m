Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E6DC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7D06B009F; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889D46B00A1; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7777A6B00A3; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 323F06B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7FBE16027C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
X-FDA: 85122551262.19.F751546
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C970D120003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRHn2lWN;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252129;
	b=26vOW1wK77m6WoEXJvZluIWIpyVZLKqACVpAWZqmHwjE2t7r/9dcUDOAx9WfxITk0eJqRR
	kxjNN+sEkJQWLTTLjUl4Sn8VBWJBTsYQ5Ln42fi8VgLlpBid/EBtQcWyHYMdzir5m9Pd5d
	NvEzhiv6GEVfaPu4cnf4+5wgwONsNUY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LRHn2lWN;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJG7rLx8dyh+WlNlpGcN/lZUTedxDi7mgcSXEHRaGME=;
	b=J47/7W/51Z0KkAKslR3jYOwW/3VZQ9anXO5BjqnjzDfcerpKJiH/nPz4KefZVeBgrpKKmo
	UUFL72/lvK+xqdwOfNqkkVyGuJkjBIk6lnLAMEGARkBCN794KCSV8ohHhMHUIjXhWzGU1e
	8YsQ9ZTW04UnKTHHgEv/6zFHBjB9EtI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F45544E59;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50412C2BCC7;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252128;
	bh=JvobTG9I7QZbRCAH/9qqa05jBi0cwM7PQ2k7NS/kQJk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LRHn2lWNvYoewOgPgKxsoDMwG91xtiDZmys2sdye37e7S5ZZvHG5J3D35ZmMXdx4S
	 t30c2bEFzQ+s5iSkt4AtUjsjETIpKfeJHOd0hSH2rFh5YMGsFuZWPPABUi9nIAAYvw
	 X/t6WhVCBNGaYuQsoerOE3YLdP/N9ri4OGTmnvlbk/L9b93hHeXNm1KJcYKchEptrR
	 W12P5ZC2g88GFE2vSAhrCxWJcdJPUWVaR7Gie6hmNm7QNdOJAFKSo+7tMW12aYjQYG
	 UQ7H5idyFH6qAcX27C85cbexAQgQNXGX4/SITx6kbqw64tAHi5/9gvYgcr1u5yNZ9I
	 5C0DGjbp3zKSQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD66C5DF85;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:18 +0800
Subject: [PATCH v3 05/18] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-5-9b43f5163238@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=3691;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=n6EfNzAc4w/2SwnSy/zj9BR1996opKhXS3Y2Z4MVxpM=;
 b=PDeSmX4GhPuxR46o2+iAjFz0/oFyjGkew1yVAX4RNe/9A6IFfXMVfEN+GSC/O81uKVt9ETwO3
 pzawe+Rwny4DnpunJo84j+vprqwIt1h8eBuAS/PuqSt8AETE38huzdC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: C970D120003
X-Rspam-User: 
X-Stat-Signature: cpbwsxxes9wt1jcec8zgkedu8fgpkukp
X-Rspamd-Server: rspam06
X-HE-Tag: 1787252129-711246
X-HE-Meta: U2FsdGVkX19eQrIjB7liejZs3uPBeJSLl2rVvkwN+TcE9wHoxIZVGbKn9tKSzz1gvxfxwEwposaKknozm7CCOKJuK5aujj5nS1HSis7dswlrCMgtJ/fEtVS+6huib4F4l7fG1A5EKNOjmi8Db5uBz3x+r7OpR96q8FJ+Bb2/pRvImhUMbytM5rJ2NKgD1jtCY2q7rQEA5IgSdq5bvS14zEEaovluC1Xpz6LHdP+UQxuBRxPqP2RLR6PQaLtx0bqBNNCOmMnuQs806mPFz+BaDWGWGsRVC32G6M6sewLNEgJ9BKpf8tXWd+LNrqWg8v/bFJ8RTnYgaDs51QD0PiDzLsiqtknD2ivduCyNUMlcyGGj7b46RF/Ji0pUblICQeSxGPMXMFxbMOZuBaOh5MLhWrFSpEGqzipMEHNZxyRUn3yNLMs6FHEpyUla78MyXqpke8NsSxPL+iVk0/G2vgkJIcWoNHsPDThT6jQiu8pNnKiM3ZhyTlY7jehoJY2vjBAJrweGtBJMu9R7fBpE/u3eVMbX+dWqr2ZIBAFVJ2WVGyV0eSOiLUlF9/Db6ec3ruVGA135Fb7wHan/0wxlKmnlR1mPRSSfK6z7vJ3BMNnF8bHtAWhDWg5kkcjQWX4mwWwNtYjad3XZAz92OdA8oeTYkPP9MJ8Jr3kyGlNVpGxRQRYIbxuunfDNqL9v7wh3QqbYBxWDPWfL8fjROsiu1mvUSb46FYwoDdOEOxyVJm2Q3j7ksiIowegClSMB3B+ngJmyPdbR1ioqvkZAGL9XoKUorB+Y0h/1uyaSSio3hrECeu1rkTsSWnVBX8PsbMhq+ylmmRdqrIc0eS8fnWnEcOsddIQKGPn0Elf0kFyQYbNjdtTQBXB7BLoRlnzRca8KeZZPbOnAKmsmxchJ33Y7H92rmsqDpKotGoCeCqnuNStREEuIzwjwYHf7aVnI84+QcVF5lsfUc/KovOU9tDbB9DN
 Fm+CbR3u
 /F8fGyKDwpH4d3ON1kd+pXRH+QoDnprhhqcMipHSeMacEOzR2cEecSfq5HW7bkZjWy25sqhI/vLXZOtkKd1B01kA3RnFY7dbpSVRYngkS9rjuR9khnhm51Wsy4E/ZWFV0XanT1sVqkNIMdp8tsBB4c9CT4SMgBJmj/nJWHeef22dJ2+8w30GRCv0xsaGZ86ZqHEgoWNn6dbw3TEXVnjhXmxugky65W6jitn/Qem7EhCZu9RT7n54nad3eWHKzXXylfvrOwdynrKGvD+0hnl5+0fXKbbH2hCcmLl44NeXlziyWvzgZO/HGtTnuEo/+pAXsk1UV6kb1ayvJOJD37MBDuTPyHwLN+dzHuhsZEVipDFjc6CmUUf7qilxsCdonA6RruVQHRXZCCkpQyHNTD/chPg2M/XwrXewg8dVR7D+GXOWuf1/2y1Ub4BdhX7WIf25QyDEcLJJ47q0H3e5RRYf4azlZa0KGxANO928q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper splits a folio whose refcount is frozen: the frozen refcount
is the state it relies on, while unmapping is arranged by the caller
beforehand. The old name caused confusion and people may try to call the
helper on non-frozen folios.

Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3fd6757c14c..427e14d7985a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3755,8 +3755,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 }
 
 /**
- * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
- * two ways: uniform split or non-uniform split.
+ * __split_frozen_folio() - splits a frozen @folio to lower order folios
+ * in two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3795,7 +3795,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
+static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, enum split_type split_type)
 {
@@ -3989,8 +3989,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
-				     NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
+				   NULL, split_type);
 
 	/*
 	 * Unfreeze the post-split folios and put them back to the right
@@ -4053,8 +4053,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-				     mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+				   mapping, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
@@ -4118,9 +4118,9 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
- * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It calls __split_frozen_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
- * preparing @folio for __split_unmapped_folio().
+ * preparing @folio for __split_frozen_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
@@ -4223,7 +4223,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 * __split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,

-- 
2.55.0



