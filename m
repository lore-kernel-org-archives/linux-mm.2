Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76CDFC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402866B00A2; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3936B00A3; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6906B00A2; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E66486B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 622611201F6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:59 +0000 (UTC)
X-FDA: 85213020438.08.03AB800
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B0FB40004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hau6a+Ux;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406157;
	b=zjaW7gKJ07HnMB4+i5nfyRdiPSHs9TFVljWhNNHeQAa+82CLsyqPThIzHMg5XSzncuBise
	uoCw7wJtGaP3ani+sO4GOcmUiVV+bfuGhIl0lc+w4nRJATBBQmrah+UOEec7M24S0043XI
	k7514cNW+5cbXvmeXLZV1LG5BM9D5uo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hau6a+Ux;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8maKxk2Bk5zyub+hj64d82IrvVntvNWj8n4ss0vuAdY=;
	b=wAK/ZFgOO7QeMn7M9UAcYOniSX3q2DvB3Exxp7evsmlno8KOv3VxNgSC3hXlAHbxfwPh2S
	4qKVqk43tpbwAJpkM2zjqaWWo8sz/dDB1mKuWWQyWHXBM/aMte8KsT9ZmMOdfSCqfLs2rW
	TpgtlAzx9D9KweFuJlGPWtOeQUM1kCI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB30433C7;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BC3FC2BCFF;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=XXmFu8FHxp+9q0wq8evTBl08FOOinwleYwb02Vqvh8c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Hau6a+UxEHuh7Utut+giSkDOd/tl6AStxx++hPJqNL3YyNLC9NVRWGGboJoqUkZ33
	 Lv3cm8vTFMTyLZgOMns5//blIRuxsmM9f0MUvQXMKqeyb4AAIPlIIrCJsM6ZYjsJyG
	 XXlWxQsfM3uRLTPtIRLswK3dXDhE1GewK5OwfGETMw5bjTjuElSYhnvqsJlHOVuZM5
	 ElKEEYOp8kgif894YCujkdPD8SL+6zqshKEVr01E5kPbocTqgZtqNLsofa80Ysxzo6
	 MroXN+7I4xyaatuRdc+z5IyLW2oku/vjQuhBX1XmZJjvt8SZyPxCINRWP0tIDIP3ip
	 NZPCnjh4Et7kA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F79C88E73;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:48 +0800
Subject: [PATCH v5 07/17] mm/huge_memory: move EOF trimming into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-7-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=4114;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ts7bWTM2eMacGjQUWD5NIu7YG58EfZYRRZU/elImP5I=;
 b=vrfo2CDuxED+xLqydKpyoRBo7l5Fjn42gdwXH3C3ECxIr3CfRa3G1kpC+7HTZ8AW5SaXirZ3j
 z03Qj9W9sWSDi5TLZB7e8xwv+WCGq66Nfl5ni651f8fOrmh8l9KIfFp
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B0FB40004
X-Stat-Signature: haef96iq955bsaydg6dmdyqm93dpnjxq
X-HE-Tag: 1789406157-363848
X-HE-Meta: U2FsdGVkX18s+x3n/I/M1brIkWiOjTrveIxQZExiz7rk4Gxj1Hs5DbHaKzKNzsjRZpib4QuoMHLi86mMqmbaurD0lQbRuVq8l3/H4WnZg+F9UFX1LQqF76LTKBwqXFjTbdMS+2InNeJOLbcGcU45haZGOQkadawNSNab3V8tXU2A4rgZ4azGVCRsNGwvIVLUN/ilzpErEwY3FiYWJsWi5VHAmgRod4HyVh076hOuAyXcH9htTRySc2bu1kZYalIsUypqeZwAPG4Ylq89jV9p0VaVHBk5ztxXTLlCE+WpZgn2Z9Svxq7xuCowpl6o0E5PcZM13ZvGQLeBE8PAdKIg+QiD78f+S//zt/0AcLxAWW5yRazQQELqXwJMYbFEo/J4qF+yjKw0G1CYTsU5ifVW/OZRdjRCBtdx657c2i8MUPF3UcTb/kD5iwHyLPkgmpFYUNDh9s8AakXSXMa3D7YdbBE0HsxSL+BCa4c6E0db+tj07lNBCXMJv4mrQcKLU3gYDb9ZbCuwGYsrbbbePYq6sugIMxj4nvSFihMb1EZ8bFZDwzVFsrQgMr4w1Mfl2iP5e3ACd6hGpNBE1L41MFomT+QNhp+9d5cn1NOX2S7RhpqogIuqvc920D/RV+ncXdPKeaYLXgGOXH2TM3R9h+ydqP2bLtUzPXZ7L2nw1VB4TqNSMEZrR7SmAxqOI4x8aanft7JMc4z9kiyIsHKHd7qegjgUspQCVpugMMG5ECoJVbQISjZ4cdF0zy7SekGojKSh7WDDjxcUJAOmoKZQCWmJcX22YKuxDhYlyvSQ3cuWH4mF6x2bc5NV/ZoqfSXF0rSYk4ajnIlLEHp77sWT2m1o4UzmT69tBFzs6t7K/X7F5fvgOQSuLyCZp4gdvrMQ4JA2zJGEFieoTIDGk3PvJHkjo+Y1QA89Kx+VqTpPJRoQVQSjleyAXropbYM/rhtPgwt2boFr7F3d4+ZEY+vr5JO
 pfMJ+Pd2
 Ww2zB1/vOqmeavQ67FLvD4+TO9rXZKfP3NGVHzj5MDThz2+ejDqdw4no13tVKdUJ1vauZWi2NUQbtn+7PzJP0kIC0e/Ud8mEtjbXZPGnNiQxKcwdAPl4NsyPs+pd9Tqn9E0zvTdY9Cp2wj2fuesVz/3n/2nnZBS72fk72HC0T9ctnERNUPkLNajFxxY3H26gDuIeeZO1GgwoU/IAoV2pQ0bUF+AJUTltpVyZ8lLq+bgdpM5j5RYOJA/hVGycBG6Aedjt4zLZkhuUfZKC8/jSlYhYPcE6TV1Ogxp1nV1/g22df6ZXvDf/I6LxQN8hhBAxrwTbbaKwTfT2kzIMT5eIa7XHpI5wtPATZ4ayKhKZ/VH+xBpCqZV0rrI/ji/HvrwNb4scPfxeipM9lUbHVmpqHdufm6daw0lbbl9D3n0MSDESdj+Ukf7mCngXgn6uFdMemMkDoqt3v9w3y11OUtuj0ChcEo+eyinvggxtRkJCRIUEMIA5eFayDbQ9cOKdR0xM8DgcyoweZ5f0Maf8y0jbTPsT1bjEigWmlRJMU0VKEciWFiLrCi05QhqqgBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of receiving @end and @nr_shmem_dropped from the caller, the
file split helper now computes the EOF boundary and trims pages beyond
it itself, as this is only needed for file split.  This drops the
redundant parameter passing and sanity check.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d0e2f1801d6f..5ba3bcdfc42d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4083,16 +4083,29 @@ static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
 		struct xa_state *xas, struct address_space *mapping,
 		bool do_lru, struct list_head *list,
-		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+		enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end;
 	int ret;
 
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
+	/*
+	 * The loop below may need to trim off pages beyond
+	 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
+	 * seqlock, which cannot be nested inside the page tree lock.
+	 * So note end now: i_size itself may be changed at any moment,
+	 * but folio lock is good enough to serialize the trimming.
+	 */
+	end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+	if (shmem_mapping(mapping))
+		end = shmem_fallocend(mapping->host, end);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4157,10 +4170,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(
 				new_folio, inode_to_wb(mapping->host));
@@ -4181,6 +4193,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4217,9 +4231,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4296,17 +4308,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
-
-		/*
-		 * __split_frozen_folio() may need to trim off pages beyond
-		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
-		 * seqlock, which cannot be nested inside the page tree lock.
-		 * So note end now: i_size itself may be changed at any moment,
-		 * but folio lock is good enough to serialize the trimming.
-		 */
-		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (shmem_mapping(mapping))
-			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
@@ -4325,11 +4326,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end,
-						&nr_shmem_dropped);
-
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
+						true, list, split_type);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;

-- 
2.55.0



