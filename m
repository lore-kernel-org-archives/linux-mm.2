Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE19260A263A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=j2qaGgP3
Received: by kanga.kvack.org (Postfix)
	id 1B59B6B015C; Tue, 20 Oct 2026 07:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166D46B015F; Tue, 20 Oct 2026 07:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CA26B0161; Tue, 20 Oct 2026 07:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE4736B015C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DAB640144
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:39 +0000 (UTC)
X-FDA: 85342857558.19.0C6109B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id D6B3780009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j2qaGgP3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOATlRclB5ldxSU64tDVzXHk9/aZOUpgsZVHD8H/s2Y=;
	b=MKgavJzbI5Rls9vkcJXaKJcTbB0pghpmS+clFEzgJX4tc0EMYqz1MURzj930FbMtHITu8o
	9qcu6TVV2BY/yXYJJ77v6sbns16guZsFB5NoxuCko8VT1vOkZz6vkvS6NKqRIAXikpgGyj
	m7GrYnMIHOD3HVT7sO2oZMAuKlZxjc4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j2qaGgP3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497517;
	b=WyqbN/qRA3OvqJcBGCRkqkClVb0ccdYRhmS/0P7lS0FZMny7jwl2se+A/aOtCYSf3hhLb3
	bOmfIVRfDvw6GwFLwAxOd5qCDK7PCxu8ssLQ3Jq+zHyiY134FWU9HG5Fn1AtC8j4STeDtf
	0ej+SXqcBbevM90bIcfSqKkC7zMwFqE=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ad2b3b1c02so1262501a91.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497516; x=1793102316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iOATlRclB5ldxSU64tDVzXHk9/aZOUpgsZVHD8H/s2Y=;
        b=j2qaGgP3MnKfFJ8HEvrIQdXl8gItgbM54REiY1aKm0LKJ9MUD6F8qqIebTGS3NRw8r
         3GHXSUYarDzChLkQEuObb/aaeR5Er1/7t+mTjKf+aNQ+o32Lb7occFoiZLpRkL7t8ugn
         xRbtssD6IZbtnFskIcYZl267nnXDZTzdTyKiVLaUZt02MBC7GxuoreMz3X266GBlrcM2
         pWDKXlEo3Rqq+fHtioRdjwP7RayP3IvH5HTa2D/uFiVit8BIogic+Z12L2AkbyWnsH1s
         h+DPG694padouQ4/FloyVxcuX0pnHLCEb42PJeKnGflpoeYscn5gbKl4b09sSN7b2AFE
         8Msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497516; x=1793102316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iOATlRclB5ldxSU64tDVzXHk9/aZOUpgsZVHD8H/s2Y=;
        b=R6+TSU91Q/0UfUhBbdiei1D8TNiaJyoXW7tDT9lxAZsSnSBcFgPzpmU3BWMQHTglZl
         /bee2vl+oTS5UspoCLoXHZa+kInQ9vYaca9NlYYOd1E0O3Qdz4p9FF75GRSMAD9X9mfS
         sWuhv3XekXnteSULs09xsnUHZ1lduto9d5+gtznzEKQ3581JCnl0yBQWK+hsgLtrB4gA
         x2ztoi3kcIOvj5Rma7gFTnp1rtfVgNfiFzfwGDugKcRg1AmMpsYFu2X3RnhmY1ma6XeA
         61OgUEg/me5I4YeVEmwJD69vWa0NLilAjnKM6vD1ezYwg8/rs7fNx7Yt3QsPRFmPQ5oO
         6Kvg==
X-Forwarded-Encrypted: i=1; AKwUvBwziv9/1IHycevo8K+5neMwukqsSFGe440um4ZgeD5jkwg4789Fhc4BnZl/5PHX9byvRlMnIJZAlg==@kvack.org
X-Gm-Message-State: AFq9FYKLIEXruDfM3EIqV0HwZBltH4D1/7/2PVoYcRoqQdN7e50JdHxF
	wVaJnZsBtrMjAjQ1rpBT1j4TM5XUBbgmTuMXWevG5vdr/qCF8BPao4rX2367MNLzEAa8SmsQbJr
	up9DXRuY=
X-Gm-Gg: AYBFou0QF5KYsHwAxeWhMqtOaRsVQ0AfZSV4Oyz6Ez5lMXGEXurmrvF/L/vophqzq04
	pCvysHFsBpEQOtZdlKnC6wkQiAn5ziSSmK1bE9C5fs4ug0Jwgb6yWpD2w4JwHgucv3ziz2jmkls
	uOFw2ul4aeQCBBAmZT98a7K/vOXsmKvdFmIL9rpu0oC0o/nBRxoQ86MBHC95ulZ7Y/zISyEzQF0
	4XdxiUauW6JPIolIiTHc8+kzl7HBUsm9QSR3JKFedaOUyr5Z0wgJ4ngotNpZ+suOZP2ioqcDpUe
	ABaHb0X5WFRhJIzTJTdzWnqKjBQTVoeTulDoCEGvgQQHMLGR4kprNfjSR4IcanWDEgllLqADPVi
	juqP1bQBUbOtq84B1+pZ4X41a+b5kXQDSke0XsUXojUbKXWtZ2NIrMlS8Cq7jDgknHksN5/Yl4B
	ceIkZGXZ06bitZx9Zb9Gp0qR910/KcwZCTDCop0zFZKgFLR5csIahYl92TEtmYNoYCSW3jWilyc
	/JOhfBN2ptShSrgicA7
X-Received: by 2002:a17:90b:1cc6:b0:3ac:c005:cf07 with SMTP id 98e67ed59e1d1-3acef3d6405mr8699700a91.42.1792497515587;
        Tue, 20 Oct 2026 04:58:35 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:35 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Tue, 20 Oct 2026 19:58:15 +0800
Message-ID: <20261020115824.823278-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6B3780009
X-Stat-Signature: 475rusf1r1defqyuz3eodzn4z5i6gk7a
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792497516-217794
X-HE-Meta: U2FsdGVkX1/acmAoZf2Yt1HsNeBhR0+5E7tnKEGP2ip8EyW7DX6pk+IrZQvufoDxgiwWZZ3GlyixxC7C2JNquGcCF7j6OmOF5mNE85dkcw+ymlI6e8qmh0oB+vJJiUhejxg9PZ5XcT0w60ZNgbAbRTMk2LMQkeWKkrPserOgsFhPzN6BXVc3QSGQQKxM0HqcVRiU5j0W1ydfBWeG3XfSPvOf/tB/GsnUrEXOJjgqo3rY75RGUYOFzjvZf2kSHzaOQ5PbGtzN4E+8qDK+K0TXYmgQE/mJnZrhns8Xh42q0GCQnuaqJ0TL6pdTwLqpuKaFuAqmyJlateaZVg19bo/xQB+S38kQycXvsJyluN6liKLm3shvA19ggPJRR35yPMnIxvNaeEBkqCia0pOiZrlhSJdpyCe1heUUk/plGEPomwpNSyvqOTpSoDpdEUtHxDm3eCPBCJ4eq61o1JuLAdloCcNu3rMaL4z0wBZzeFezhQUhtuo9Po+YB0CIWMqly/rPuv9Lf/XKk+NvLcj+qLv3G++GzOe3jAXNZBZ5ivzWDoy2ErDJQlsk0xhF9ECYzgHJEuljNeaZU1wbNy6aGIxbN3eViNwbPhrwxh9WN2iImBO394oNunfHJU4nKua4UZ7C07WDKnTqgg+DhRCuFV4Y2JjeXG7r854ZtKG1PDhJ7kYG17l1Q3spbk8UcGbOY5av3ioS0LvXarDBWLW38DgmMQFYNRWsiAfoxwS0HXW39Yr4o5shZyFAa1FzseQLPeSVL8GLIwiheiGQHhLhNJQ6kmzvgLXQudazLef1d2VqHwXeCuZtue/r9kiiExzUvhJIBj68nxA3ixYcLiWvq8dWp3VEX8YGp3eLMWVSbku2H+Yv3GPFms8m/Rm77HQTtWBgIXuqdmJo/L0SyLLovVa9DBE83OX0pFqfMh/39nX0NN1ocPUrUbP+rrbndS6sWFKNzIDpQtiibcEuZAv+UxE
 aYtyEJQT
 V4u+vgTRnO523ank28mLjELnzSwCuMHDUcswZwkjb0BLJ5mQDpFXIK6GEVejkdyssZ1LQRjI8HyCde6bVrZpeiSzZFp1Q42sfDzJylZxCzUOODsc8xkCBVUuKT+4YC0k6ZyoZjWs5JoG1NzwEWU9IFeeMfOXeX1ZLcNwATYG3DcHyOQ+J4zsSnm3zzmE/23Jllim5wEJ9UTVizkp1+SX8IdyL6Rl1vCw3i36nLx0TgOjkgZxoGmDJTqj34RiSAFN45ic1A7dnDdGWlbPcjP3FONfScVPsUkuo/QXME1ymfI3IKMIc9SbbX9Ox9ETwVxS0HHpWiua/jnvL4ieQhj4dHxUoTsx9PRewkCSyxL5k2VXKlos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The new head page is already tracked on the vmemmap page list before
remapping starts.  Passing it separately gives the remap walker two
ways to refer to the same page and unnecessarily complicates its
interface.

Use the page list as the single handoff mechanism for the head page,
removing the redundant state from the walker.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 8b3abb562599..164e93e980bf 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -25,7 +25,6 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @vmemmap_head:	the page to be installed as first in the vmemmap range
  * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
  *			or is mapped from.
@@ -37,7 +36,6 @@ struct vmemmap_remap_walk {
 					     struct vmemmap_remap_walk *walk);
 
 	unsigned long		nr_walked;
-	struct page		*vmemmap_head;
 	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
@@ -208,10 +206,13 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+	if (unlikely(walk->nr_walked == 0)) {
+		struct page *head;
+
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		list_del(&walk->vmemmap_head->lru);
+		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
+		list_del(&head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -220,7 +221,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		 */
 		smp_wmb();
 
-		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
 
@@ -289,7 +290,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @vmemmap_head: the page to be installed as first in the vmemmap range
  * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
  *		responsibility to free pages.
@@ -298,7 +298,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      struct page *vmemmap_head,
 			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
@@ -306,7 +305,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.vmemmap_head	= vmemmap_head,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
@@ -547,8 +545,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * they can be freed by the caller.
 	 */
 	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_head, vmemmap_tail,
-				 vmemmap_pages, flags);
+				 vmemmap_tail, vmemmap_pages, flags);
 out:
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-- 
2.54.0


