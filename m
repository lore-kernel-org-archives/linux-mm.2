Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76CB6C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989016B013A; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C87A6B013D; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD1E6B015D; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9EE66B0148
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24809A28F0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:20 +0000 (UTC)
X-FDA: 85093505280.14.F78585F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27D42120005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9+ZKlHk;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOHmCYBMn6EJKsA07FnkOAsX88cDhj7ovyecd0V84to=;
	b=dNt0PD4KTE9t6gmiKuQpiI3h/oJv+KfOcgWKuPw5YbAWf7cMujQwH5+j9jJx8TtlBJsNTY
	DEMBfa/iY3BEjHwEvaRLFGKV0/jJqEKRxYq4mrLkZEmqpxLxKnMOkVWiK013csDZvGyZyK
	ISI1KMkBRQ7qylfQHFCzkD0miBJ+rxM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9+ZKlHk;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560558;
	b=fc/Nr9PmuUR+K8lEy8c31xyy5ITTzyD2Fds4bG4B6CVskKr31PR6pT4eCBeJ25rGJZ85Dx
	DmSs5m0nq3q1fIqbNeQGvcOK8mHQ9etEvTpIEJAheXOQ3dcIpa5mdWNJc1xm+QUeL37uS3
	RfIjubpoHCRrPFS2D4Ao3KB9FV5NQB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A215B4501C;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84041C2BCF4;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=Owm7OReCxREHcvnBXseOC6h5BF9QRvQixpox1aW734k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=T9+ZKlHkYjQyXsEwBEpwBtV0Om0LkMfS+sCRWSdVQyTJeMkMXexVhNs7gtAwziBNx
	 eNX2rKav3ZHnD9OPFM42kIyZEmru0ZB2VtougF8mz9HgBHNP3uyxnW2SkdCSQW14Rb
	 cXmXT0mrL0RK7phwkhHAvR4ZlC4fC5BG7yke1sPcc5dH719Q17Il5IcSrSCob4OmIF
	 6SkTyTcUSIchYiXmZVb4oow8rmOLRsMQjVRr83tOJ0TT8igZRVgwwshEEFQZNlUI+M
	 g+6cuquy3Y/20bDJo7qCJM8M1sXfL5clfsF39mxUM7qFT0tK9t9Q1Mw950KXf+Rx1f
	 yt4zUYjGplG0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711CFC5AD5A;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:55 +0800
Subject: [PATCH v2 15/17] mm/huge_memory: lift order-0 restriction for
 swapcache split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-15-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=4239;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7dsbDsudI2n6mDwR1IdM39EPBRK/NxojqOiTK462nZU=;
 b=c4rzUnqjWf2UO0CXc0WhA8Ig+vZoZxuMwxsTI9vQE01fd/QsHjYctk+jycsH4U3c7Yfgh+u01
 zMHvm4b5o83AcjwKuTg9ljA5ByH5F6u2MneiiOA9vL348+KgChDbBSA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27D42120005
X-Stat-Signature: j5g954tpgghzeopwqzmonem93zekazq6
X-Rspam-User: 
X-HE-Tag: 1786560557-37192
X-HE-Meta: U2FsdGVkX1+92n4rXX4UM88au+J5TI1D1IzX8yFvp01BEZ2NxonidYK2qxfUm0z6PbhKPQqyIS6YzeJAmdAs92YTbu0Mzo+VQ+o/TBnhzzWGpZ91yLoaXXIge6hxOEg7kORg9j//IHMfG/zuIKj7O8zjg9us7xFAlNxyEHWXqRdt3RLg5P/FnFZor1bTd/Axkoc8GxQ/smVoEqffzIywZ1KpEaQ4cJT6Ech6rv8M4846YSajUASVQVM0m9jyJ7EszSe601XPR45EAbPuhJ7aBlX1IAhxdnS4xddGzxFWNEo34qCPdZK3EAX5xrtQ7u5T2y4YyoDiIcM6fD37NL3L9+poaqDPc9Fh8dq9pJHifV3XsYO1WMHswJv/bSPUf4jwth1OK0UmR1qbkM2YLZA0w4KzMsw3GxfWx8LFaWkhDF9t1w4UdDomSQeO7zEwQQZQdlSmQXdbgzSndEPBaEbia8fZADnInkAQ8dSC50MmlrCr4yEWji25RhgiKaTBB+4quOXN+y89JpCPruZk/EQ36KvLqRyobq8lHqUvHTkeMuqAzMGMA7IkC6cpFMLVhrfXG6ajHg5htwIT4cT4otnstj0yj1Ak90DhliQD5nipqOBK8pAk5jt2nyYmRU4eXgVFsfHtJSshO6OkNxwmXsDFCdEhYMC7Eg90P+Yr1+2srgWbYH8wpdfFBVYHs5ltklQPbGdfJE89QJTfVNY2fNf2e38eBzMsekbGjyY9uwkBW4Jz+T4CZdmp89T3+HcRe3DCiADRgPn8kiovF/VyjonyQ/SEeIgEpEBAaaIld/qSkgLuPPnYdFNOnl70gPa//mIEkuzawfpaBkg6w+IHbzR/kWuk+x3gsAY4xsHsH9vx4u0ARa13HELrYS6tUJPew7lY9Z/UcZCT8BWpxk3l+3LW1E8/nY0EeB94v3By+2+eCv6iJu2zNled2WY+iiSXcV0NyP4Qu/bRgQUbuNYWeyH
 xhPN1tQa
 Z//78h1j3KBUWSryw8RP9FIzfSRuOmX2NMn7Ih9d33q53Vooi4cduMyXvpavj3kNrU3vuWVlI+TbnXZ1g2kBU7JKWHHADQlpnaJW2RfuEBFUcLrOwhoy49VpV6e8rBmI2U7xlGCDpwTAmQgSnIXHzVIEnP/MmTN9Kv/Cg0nxFZr/XRrFZt4wJfXw2nAEHkRcyUEUGcxasHIa2k6wWTfrWO9FSXDX2CYvphdh3rmGsoJPlmPuWmLtRB/rlxaqRINCoeZTyFenyj+Yzx5C7IqimnAldNypvJohKmRrYmQYNlErHyhNuQLhHC8sWNSQJ7S98/+EY69pX8sRJkQuIDvWiA95wmU9JP5Km/KGpcUqyzG9l6TheTS9XFGa5aJDu97TVb+4Bg8NYmZRknnZE56eL3IEjBIKGp2tVlMtyf3kssQhHS7kSSwQcyX8EFUAwfLxnFRmazAp6TIE6GTK8qy4kjBgB4CkkwY0aMaco
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

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 503e3bd84cad..317e5b63d44b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3809,6 +3809,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct address_space *mapping, enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
 	struct folio *old_folio = folio;
@@ -3823,8 +3824,8 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 	     split_order--) {
 		int nr_new_folios = 1UL << (old_order - split_order);
 
-		/* order-1 anonymous folio is not supported */
-		if (is_anon && split_order == 1)
+		/* order-1 anonymous or swapcache folio is not supported */
+		if ((is_anon || is_swapcache) && split_order == 1)
 			continue;
 
 		if (mapping) {
@@ -3899,19 +3900,13 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
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
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
+	if ((is_anon || is_swapcache) && new_order == 1)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -4411,11 +4406,11 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
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



