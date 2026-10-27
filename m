Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC5E606A334
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DRV+Jxka
Received: by kanga.kvack.org (Postfix)
	id 7A3446B0731; Tue, 27 Oct 2026 09:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77AC86B0733; Tue, 27 Oct 2026 09:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690BF6B0734; Tue, 27 Oct 2026 09:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 468C56B0731
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:05:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DA58120A4F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:08 +0000 (UTC)
X-FDA: 85368426696.21.58D61EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C609A1C000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:05:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRV+Jxka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOndbVRJ8DlxLXPbni7eywyb2hjN3LJE2XVVvD2ZGUc=;
	b=uju+YL9iMf+ODNo97hVOMKnx6quI+JYLubh36GlYsEPUCIg4qh51ePgR4aCVmPk4Pdwpvk
	Va5EsXc793aMGJsGqlSr5y+1pMitJFYPx0KaXM3GnpV0VsnqB+5h0VuHKy7xXQxVPPt6o4
	VzLO+OHYw/n6glNt9c7e7FBhsrlAKQg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DRV+Jxka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106306;
	b=XYIKt3AsTpW/Uc5zgZ4kR3JcbjNMDZCzJdcfy9P3fCXIw3FKbnztQ1SzWI/hdJPnIk+E9K
	i6GnoaydB2rGgBoZiBSWwawYBopE6ENt5n1iwPp0QN6IR4waUUAb3kdSwrznJYJaTcdU/t
	EdkHRNZlgD5GWl4Q3eI2xY8U4MTbMgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E64560A58;
	Tue, 27 Oct 2026 13:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659E11F031E2;
	Tue, 27 Oct 2026 13:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106306;
	bh=bOndbVRJ8DlxLXPbni7eywyb2hjN3LJE2XVVvD2ZGUc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DRV+JxkaSnvJfTd5npTEX91RuHdUI+/15K4QT8r9upXL2PSDNr+9/jr34zrpahYG5
	 uN3UQsxink4uLO7qQ4uXsXtnNzrOx+xVfUtPE9TN1elqlki6KKd3LNlgVuBRgNO9Y1
	 szrO2Bo1P6qmCmlITy7JsrVG5+nc78XQ5u789Gs43D8axI80R8krX3gExauIf5m+Nh
	 ev899EaswovRcIHaPeQwYbMNHYLiIXjgiFbgw9Ukbicpma2WlGazOCpqjUcGXU3djc
	 82MJ8wMfaKhNwpS35Y8+9cfWE5TxG3djF101jUGOg0Wr4a8OgBCjFaE/Q+E2x8O11U
	 49Dd7GOQptb1w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:18 +0100
Subject: [PATCH v2 13/14] mm/shmem: fix accounting of swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-13-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4468; i=david@kernel.org;
 h=from:subject:message-id; bh=N6/aWIHU6WVoyGGH6bIqCWQy7AqZxJDPZKDhGMQWtQo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBSKNQ90tKu/r3eu7VHizHW2x47OTnYUvLPKXutbZ
 r7UthO+HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEwkmofhD++v+/K/SmULNX5p
 mTYGH5p7a03xqhX/vl7aY7HqX9auoIMM//3Ynz37ERa0VpbtDo9A5nKWpYW7MyzWFf574/BH9qX
 TOy4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: C609A1C000C
X-Stat-Signature: rgkjui9ags7y7jnqhg6h8rmgrty9nkn5
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793106306-201869
X-HE-Meta: U2FsdGVkX1/QyUo9Avscir40I4l4ZJj6f9KODs9+K7Lb8yq2CreupBtCN83bHRHAgoo0MwcZr1VW5PtOEw1Y+BTxYN18q/h7bnV04zbZJg32Aga68/vUbxUYlkQRkUNKNA66Zf3CvKB5nKuebwmwJOKTb4nen9h8Ddub6CKrTAGnUjTTwhV620ddBsX43bJnk7T0rUoZKc9ctAN1jLkhEYwUPUv+wJcfvM6YH60wUjlBnHj90KBlLOXBvt8vM/4JiISDy+SHubqowKS/ikCT0XlkRR56tvkp3Rjwfo8BsDwqHv16PK4wLh/gqqnxwrcLmscfPH0ecXvMopnrSoluQURRXt3qq4YFUd4nlU5WkpwP/Rt0cZT/ULkRVDc8bT8LqOlfoXHqXaj8S25nW7V78UcvuxYBSm/ZZS2iXfTaPKhRAZuhap8T3FJZWGEJAGwNW/LZTDy/zd034vggifeXhmWdxvC0MVmiLF0v3xdTihBjk5/OShrNdzJXkSP0MFwmvx+QDEdKIqpLDNBhLbII+sxjblnMnf9PtQfeej1JJntfl+aMmYR3PFBTH+0A5HiHMC6X6x2HjI2t+34MRX9mWEmlpYXZ1jdCsdPBtOP2nx9RrNoJ6yoynEgXNOHP3nPySW1DATgi6ClRU3TdlYnr9yS1eZw1RdbuvfJhLOxd9iI0edrxtzmp5oNhR5J/wKASjcYbsIMg7W3lMR8iySPKwLswa2v6HvNxx3DkxZCHmE5T+qYsoRdTkd9C5HwBGrn1mXUCsB4sz9KIxY7bif6KBAgCqBE+wikkVcqVBGoMOoS7bBTqWPoeMOhW6cXgcsXxBJA8Hm8oFKbbdwgjIJ5er8rorjeQF06VIjHEjrClsIHjKdtOFyV3tKJsk4NxyJ0rc2mqV3Wr9sgfIM4BPdeLI9GV+QFMyK2BbNTFMQ10SuVHPiKHItBmmrXcE5VYyE137mScGrLh33khqM6gyzd
 9Ol0iX2j
 p8awI6qXFBD/XSyNJ2QzM6EtdDDSfM80RtAhbOxVmKpq33TcJLaMDjkxRimLkjAtZcKjlQi6cdu4Cy5/1qj6zXP9wAeLE27JeuyZGnTVCB1i3j9i2rpPqyleGwzONCkFujDIeUvJ2i9mBk+nFa8etQr15Bt1KpJbuchX/NC5PbKYB6e2oBPjhf5Sv3t/fo2rwSizyDn2o5ZVMNk9MjX6fiaLh2mtTc0AVHw4UVLTQBolhGq/yURDLf5P+jiycUrrq/8K+qjLltIHDtH+n40Mzvm8XqsbAztN2YmuHUxE9Sqm5lF4l2l+xQ66abdXgL5H3GWzb16RWMT4RTws3OJmlBffZHlKXJ1dtxNkctQ6EK0Rjna1sw8JI94d9ymtmAnFAClx7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A failed swap read replaces the swap entry with a swapin-error marker in
the page-cache and subtracts its pages from "alloced" and "swapped";
however, it leaves their block charge in place.

Removing the marker during truncate then subtracts from "swapped" again.
This can underflow the counters or make swapped reach zero while other
pages remain swapped out, causing swapoff to loop without finding them.

When installing the marker, subtract only from "swapped" and let
shmem_recalc_inode() reduce "alloced" and release the block charge.

Make shmem_free_swap() report successful removal separately from the
number of swap pages freed, so removing a swapin-error marker does not
subtract from "swapped" again.

It's a bit confusing, but replacing a swapped out page by a swapin-error
marker in shmem_set_folio_swapin_error() behaves as follows:

Initially:
	alloced=1, swapped=1, nrpages=0
Calling shmem_recalc_inode(inode, 0, -1)
	-> swapped = 0
	-> freed =  1 - 0 - 0 = 1
	-> alloced -= freed
	-> alloced=0, swapped=0, block charge released

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4ece296a1ccf1..2800dbdf031c1 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1177,12 +1177,11 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache. Returns
- * the number of pages being freed. 0 means entry not found in XArray (0 pages
- * being freed).
+ * Remove a swap entry or swapin-error marker wholly within [index, end].
+ * Return whether it was removed, counting freed swap pages in nr_swaps_freed.
  */
-static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, pgoff_t end, void *radswap)
+static bool shmem_free_swap(struct address_space *mapping,
+		pgoff_t index, pgoff_t end, void *radswap, long *nr_swaps_freed)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	const softleaf_t swp = radix_to_swp_entry(radswap);
@@ -1203,8 +1202,10 @@ static long shmem_free_swap(struct address_space *mapping,
 	xas_unlock_irq(&xas);
 
 	/* A swapin-error marker holds no swap slot, so just drop it. */
-	if (nr_pages && softleaf_is_swap(swp))
+	if (nr_pages && softleaf_is_swap(swp)) {
 		swap_put_entries_direct(swp, nr_pages);
+		*nr_swaps_freed += nr_pages;
+	}
 
 	return nr_pages;
 }
@@ -1358,8 +1359,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
-								  end - 1, folio);
+				shmem_free_swap(mapping, indices[i], end - 1,
+						folio, &nr_swaps_freed);
 				continue;
 			}
 
@@ -1422,13 +1423,11 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 			if (xa_is_value(folio)) {
 				int order;
-				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i],
-							      end - 1, folio);
-				if (!swaps_freed) {
+				if (!shmem_free_swap(mapping, indices[i], end - 1,
+						     folio, &nr_swaps_freed)) {
 					pgoff_t base = indices[i];
 
 					order = shmem_confirm_swap(mapping, indices[i],
@@ -1449,7 +1448,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					index = base;
 					break;
 				}
-				nr_swaps_freed += swaps_freed;
 				continue;
 			}
 
@@ -2385,11 +2383,10 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	folio_put_swap(folio, NULL);
 	swap_cache_del_folio(folio);
 	/*
-	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
-	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
-	 * in shmem_evict_inode().
+	 * Let shmem_recalc_inode() reduce alloced and release the block charge
+	 * for the freed swap pages.
 	 */
-	shmem_recalc_inode(inode, -nr_pages, -nr_pages);
+	shmem_recalc_inode(inode, 0, -nr_pages);
 }
 
 static int shmem_split_large_entry(struct inode *inode, pgoff_t index,

-- 
2.43.0


