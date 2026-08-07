Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E7DC5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC306B00B4; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42EB6B00B6; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD0D6B00B4; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58DD46B00B3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E69F514017B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:55 +0000 (UTC)
X-FDA: 85075735710.09.1A50179
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 062E7120003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHr0xwRl;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137474;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gz4apGJAcxPi02AJJ3X2uJ/BGrvOAU6fKQ3TIe+lMcY=;
	b=wsjhbthXNMLk2v9NNovrv83t1oQZC4aUJs1jOId65vA9EO/CEOOc2JZsQn28TDrBVyq7d8
	nwRjDteZE1ftZIv6vkQpw5lgUsbeI84N4m9espWe+FwkbeT7Acy+JtvCUUzSQIbQY00WLL
	YXGrAC/vdeHulGbJPgBJ0yI6GTxqy94=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHr0xwRl;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137474;
	b=0ASE/AdBt+LGj+vn5CZRTrk6fAlWN4dY2wcoz3Z1S53kFtTnWyV7lo/83+YkUm0sr0Q/2L
	MQcIzCpfd8Ry76teim/8O9MvKEsuKOsjBRr9MSWyAw45Vdf4Q5DOmCTQk+ebs5NDLqxIQG
	Xm85w5kGG920/J7CNh17GQDodPgaTdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A764F44F4E;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 892FBC2BCFB;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=yvf2N/efdIKEj5X5qDj9wcYMNlN3bo6H9UHt3Cv+FOM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YHr0xwRlJAM2p4ts4Fur2Lgd6hpmWZC7vvWlHSnsJ4NNro1NR7zusHJ1BKTLwVvoB
	 Zn0yJXpc3arFNNff4GPvRLGl3jJ35NXQ+8vaEW8POA4xMQ8Po3ShLtGpJ5ZajNknIr
	 8NK7dTrAw86F2wCpgpXx8YSOtxcKidIBo/yzF88is1Qj5enLdobNGDu1BqzhlJE/z8
	 devmNl6/SYYoyZuX0wtJLhYasRCpoFxvBkvnFfgwfhwyHOXzg7v/qr8B58yWqnW++y
	 t3S2cYhH1ORxquiUf5bcMDlFpAOo/Kw6+nLzQx6Le9omhcXTX+EKZP0oDRzRKBgDh/
	 uIo/GgswsB8Lg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753FEC5ACAB;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:13 +0800
Subject: [PATCH RFC 12/13] mm/huge_memory: lift order-0 restriction for
 swapcache split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-12-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=4236;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7SjtfqfZedSJz4xGQv/+c/6mWUxdnqqN70J6iR/8Q6g=;
 b=OM9J+C2BnomsrB8R3lY++FWH2mGqLYGpQGghKyKGjk11dm3+MVvTipZ8Nt/+n8N1vq2htd2d0
 XDBmdKu+FeQAWv/dgW9asdmXhB8LBOKbhdDqSlFssXLP1nG0ZS3AyQI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 062E7120003
X-Stat-Signature: nx58ged65hfy88mjk944cj3qpa653o8e
X-HE-Tag: 1786137473-183388
X-HE-Meta: U2FsdGVkX18ArDsD3G8YLFdd2wWUmT/snvBwdRVp8xaw6eedhPdi2SU9EXx9x1bhOSjj5VfvZ+tXira63ta2E3r93XPqiTuRkoZX4/zr4nYQiMYe7oK0Sg6UeBtOjBx9DQ9JjPCy3o+MITrfgKATlDJE891ChLc2VsB3aby1sKH9qHBP0lXtnstjmHqkGsB63F53IUpwPOJ4x1uqG0Nw1yrVM7wwjqTLSmo0CTDz4BjXa9a2wCaWWBL0ESWfpphvPo9J6fjbQ425z9/2emxGkktHoLuI6+sFDGz6mdcKBbr3Ir3s+R1CvJfr8DFdgUi1uX4MMMXgPY+CrXigfakkwsZ0gTUAfPa6U2+VUYogLbbQD04M5kEbcj/FDXK2nbLaobyXYVRWcQsnH8F7lT8ECAob97QZKt3OchsHTcK3woQXlRWDTGe9Ipe5l5e6u8sIew1ZXoFiS8a/4ImNHhnJ7eDecuU+YC54Fo6YbO1E0t61KIdvIDsVwub1BOp+SgIXDZAo8JslPXl7ws/rq8b3GLGYBrorxVoJmr3QHwQKhe8u3sbTSWSLZIMoeG0iwgXh0h7AWSswc3XwnmYM8AWoAyEABbfHh6XMfMFe2JTY8TBidclb4T/Nz1zLReexNJYvB5J9+4d9x1tAe8q3J1Fx9Jt2hTF7uab7qjZGO1zsZnL3TE5W/qDrq2coGNAqoxsKzpw3zWq7e8ScxnF+GVT8sbILGTZcu1/xoD7D/h/CIBHN5C1/kuw3Hg50b1oVOEVV2h6kYnzEC29ARJPVxaXuVSfbPO7U6WBleiYyEtF92E3f/30ErQHaPnUEy0LhUrS4TzeT0MCMOvGKDNUh7m1AkOFoPsiFV0Yrj2aGWOsZt2paYWBdRS2SkySYiWTdJM46jyiDdkJxxjTsrPvXUkblttfwRqcHCFvzD3k6USpYjppBmELVe7kTwR76C/kLPghn2qdKLRWpzal5J3GAQc2
 s2alb6Sj
 N1Jw15SHX0BTA8UTtFyeCE/jeV2UwVg/rzSm0E1evHgGx8iE3btCB4YbZfqQyLB5nd/vN1m4OtZbGTovoLSD/UmHqXC7N2nzy2DYdnpuZtX6N5bfh3KhkBmT63126OuU9peWc9e2oscNEacmnpbVyCTXIeB0fUW3yz5XRmBNZUdDgbyyY445MwwQOJERIjyDIozpu3ho32BU+vkpuIju5cBDacGOGNSP22Bezh0V8osZadvaoe4dbzBAn3DKD+qXnLqaxXc7y2RItP8U/U6vj7Y53B2awbowFmVcAES3VLKdQum5raGRJHHh+erp93jORuAuRc3nUOayh14Y8ZiMaF9TreBaAW3Uh+Y35L8OREFRRnliJSAJois+Mrjc6tUr40zgrwZpKxunuqBtoixWO7qh2y1aYqzacXX+LZe/AQQUiLOAeH1aXckH1jBSb8Y0TqVHX29gpImcFu90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The restriction that swapcache folios can only be uniformly split to
order 0 dates back to when the swap cache was managed via address_space
mapping (swap_address_space).  The old split loop only created order-0
sub-folios with a fixed stride, so non-uniform split and non-zero order
were rightfully blocked.

After the swap cache switched to swap table under a cluster lock,
__swap_cache_replace_folio already gained the ability to replace any
number of entries for any sub-folio size in one cluster, and the old
swap_address_space locking and limit was removed. The restriction
became obsolete but persisted through multiple refactorings.

Drop it now: swapcache folios can be split to any supported order with
either uniform or non-uniform split, except order-1 which is not
supported for anon folios. Mappingless swap cache folios could be either
anon or shmem, so for now we just simply forbid order-1 for all swapcache.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 39c91c8e5bc8..dba53fbb93a8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3797,6 +3797,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct address_space *mapping, enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
 	struct folio *old_folio = folio;
@@ -3811,8 +3812,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	     split_order--) {
 		int nr_new_folios = 1UL << (old_order - split_order);
 
-		/* order-1 anonymous folio is not supported */
-		if (is_anon && split_order == 1)
+		/* order-1 anonymous or swapcache folio is not supported */
+		if ((is_anon || is_swapcache) && split_order == 1)
 			continue;
 
 		if (mapping) {
@@ -3887,21 +3888,14 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (!folio->mapping && !is_swapcache)
 		return -EBUSY;
 
-	/* order-1 is not supported for anonymous THP. */
-	if (is_anon && new_order == 1)
-		return -EINVAL;
-
 	/*
-	 * swapcache folio could only be split to order 0
-	 *
-	 * non-uniform split creates after-split folios with orders from
-	 * folio_order(folio) - 1 to new_order, making it not suitable for any
-	 * swapcache folio split. Only uniform split to order-0 can be used
-	 * here.
+	 * Order-1 is unsupported: anon folios need subpage 2 for the
+	 * deferred split list, hybrid shmem & swap cache folios are not
+	 * splittable, and a splittable mappingless swap cache folio could
+	 * be either anon or shmem, which we cannot tell apart.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache) {
+	if ((is_anon || is_swapcache) && new_order == 1)
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
@@ -4372,11 +4366,11 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
  *    GUP pins, will result in the folio not getting split; instead, the caller
  *    will receive an -EAGAIN.
  *
- * 4) @new_order > 1, usually. Splitting to order-1 anonymous folios is not
- *    supported for non-file-backed folios, because folio->_deferred_list, which
- *    is used by partially mapped folios, is stored in subpage 2, but an order-1
- *    folio only has subpages 0 and 1. File-backed order-1 folios are supported,
- *    since they do not use _deferred_list.
+ * 4) @new_order > 1, usually. Order-1 is not supported for anon or swapcache
+ *    folios: anon folios need subpage 2 for _deferred_list, which order-1
+ *    folios lack, and a swapcache folio may become anon once faulted in.
+ *    File-backed order-1 folios are supported, since they do not use
+ *    _deferred_list.
  *
  * After splitting, the caller's folio reference will be transferred to @page,
  * resulting in a raised refcount of @page after this call. The other pages may

-- 
2.55.0



