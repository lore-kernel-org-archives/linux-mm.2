Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53EDDC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9396B00AB; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C803D6B00AD; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B962F6B00AE; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8934E6B00AB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F3711A026F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:35 +0000 (UTC)
X-FDA: 85122551430.10.676B5CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 202924000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aZpC8W66;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1hPc0W+mXuIdJI+GANOB4ukTEmJYn8LOCRYZ0fYRFU=;
	b=xZvpwwBvkFUMVdFQnVKFp0vUjNR0R1i+HKFb8PTK35shMcvOfQfJisymnbiyVKfCJsEb5N
	yFQ/yLffEt5p4tcACtzKGrCQq4INa6MVsqDXXOzYQfCSykGWZdBOzZe9uv6s1+M4MwAyI1
	E7fyzUZjVHzzpeG6Eg5wb1YEUSYpUZ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aZpC8W66;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252133;
	b=CdSHR4BVcKehS5I4a1Ma2MIB83+C0gUFONC0qqFt5DOJKgakAy2dh/0MC5Yz/Am0eu9iDR
	5PmFAjEGv+Fpse6VDshZYgR4LvUmJ5jd/cFerBWRK0nrzPqCeBatEOnuZp/DbQQ8h1gsjq
	gUuZgbD1CkqeBKz0nI7Ry8SEOGwPikU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E53D44F66;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DB0FC2BCFF;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252130;
	bh=1Vp9iAi7DIBv3YUqfa5ynWvIwCbIw7QgrLewvsEwF+o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aZpC8W66dfNf+SamEGN4vhzqHHK8YgSt2tWjjhzQY8ctF7cG3iTDKQvDB/veT/h0Q
	 1KIDjigFwhJCKOL0syroAZBU7d/j+4BnWHgcyavwOYC7VDHlvpicWxNfLSAdjs83Fm
	 BjGSfYX4j8P5j/dQw3B6vem4qOCpS0uJZtJi1nXcD0e29HGSQJXQkjPIGyisYWLD0/
	 cH54Vt2AP9k7946vIADiSgt7MkSqZYbASbJZb7DaI+OzeefcrSo2vE9LZZEg9rYOFp
	 K2neksMCrJBqva5TGl73nm0FwVL88SD6O9YC0APGurE/d3IRxwo+f+7rxOYOq5q5N5
	 bKN09TjR5amFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20209C5DF8C;
	Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:30 +0800
Subject: [PATCH v3 17/18] mm/huge_memory: count only swap cache refs in
 anon folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-17-9b43f5163238@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=4442;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=TgKhkDQrFrEKVN/TkYCZhsRocqLMR143+q4KiemUWkA=;
 b=3dJobk7dFRk7m9rm1E1L3nmEN9fHa8TbQflgudEQNEGDJmF5szk2IpfMrxAoOfjSI+ZlLN2sw
 xs7d+tsMjj2ANRfh3Y/tPn/oaCQ72rNh8px1QsyCt5KumYB04Idu06a
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 202924000C
X-Stat-Signature: fcjo6z3cx8dkxugmja5oy6smg15zrasb
X-Rspam-User: 
X-HE-Tag: 1787252132-964426
X-HE-Meta: U2FsdGVkX181U8MSd7sQZlcNg5LoS4KojnmXSe4VXeKnVgNmn+1FRGMtbi7vko6+QigqZ5gneXXC7nryYCyyDPpLDV67JkMhMe/NTm1b4ildJiTBKBaFjsg9ZNhkgnCvXCJgk7StSwJ6jXis24H1gEoSYV+kT/a2OEK4FNFxfAF/q/33lIDqYqMVNSKipl6TXX0lpQR2VdpqauOQQtmL38STEMr5hUu7zegRhxvyvnPk7pai8CcSD2KCnEgYAgCio0u7/aE513+UfHrc0UHC1CDdHtDzgW/HXAqh2Uwej4KZ6+19ObWjfJ4ootaalnbEs6SwF5WBrGVfEC07IkPhSKQDMqBmRjKJ74hNZMstkSvlpLNrl9mHfJKIhzxTDh2DerW3wsXfmgv37+sMCSb+ob0p/eFlEXNk8Du3nskHMbRq08KQ691pkFt9RfhDwZ7VrnooovGB03cmf5MXQ669oPePuMPDO+EmQd6dB+Zv/ebjclN8KIHiJMdzebIlgPYVvS8sekH1ibbxWA+qVvVl4A/VucDL9U3aCyawV9TRrso+Sj67Tzv7kx38yRI8eyDfnkTuwvDZD1U/k3PVCd/3ETAkt7Y/13ce4V7T6PBHhwWx1J5lKl1/4pL3uN8izAQB1Te71ZHPILaoEvHCT2tMeVk19H5gxF0aibz490Nr2NPwNP4LRIoSjBq8cqBJsp4wOt8sTVAqSQW68YV/cF4B/zCAvRI/tf6rgXdIzNe8zqeNKx5W1KCe4XjjGKIbHCXaBnoLeptdnbCA9T4OktdQ8qC/xeNFegSeeaBQLDvMWPj9XJ6QT5ZiKanDrlnr2mW3vEE7egUBOLmpFSJpz2+zZ7gEZpA/wakHYQRC01bB3D4HWGRAaSZOo+i5de7LoGxhNPnPvd8KPuTYUoET+Y2SGNUEIKPrMpKPSH7e7D8PpGwLnp4nosZKV/SlYKl+SXM2fnefw1jyMDJ4n2h7ezx
 Nc3MJuIB
 zCcdwNYFp4sb+vPpzOHpluyCm6t0wY56JTenkO9AUDGLPVVljdWgv3P7vvqwNxHX92AvkAt+CQYeqOUoVf4JKfya60+MZKzok74WNY14pn3g9hS/mUeYvf0DU2nP3xKfhqoVRAx0mw3dg0zUHcqq/U1uEHAL+CuWgMbPk4QqrrkS4Uwz3s8rjZdFgFOCrP9b6vf4zeaIrkz9r2II9zyx9wZU6AANq8gwcmjCb+lSbM1NoEJffu1gfCdMB/JECsdLtPNLsitKWUAR9l6CITq42Z5n6tZ5TDcB8pSuxW3sA6ywwqXaDTdGTQaq9EdfiQsvjVpRvayuU3t9B6BjqN4zHdGg0XSsMkTCye4gzt/s4R85SdI5SRV3KCFDne42GylBiJ4++y34SLQjJ0UJcaTKZsLnnuN3/o+8XBvhv7y1KxOqo4j5uvt4chUCDwKmorfb2NfZ95wontdIJ9Mz8kZ2tsBo4cUmlSKv0egky
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only __folio_freeze_split_unmap() sees anon folios and swap cache folios
now. The file split helper only handles page cache folios, which hold
exactly folio_nr_pages() references.

Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop
the anon check so the helper counts what its name says. The file split
helper now uses folio_nr_pages() directly.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0a971ca48151..3e4c0fac7ba6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3915,10 +3915,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	return 0;
 }
 
-/* Number of folio references from the pagecache or the swapcache. */
-static unsigned int folio_cache_ref_count(const struct folio *folio)
+/* Number of folio references from the swapcache. */
+static unsigned int folio_swapcache_ref_count(const struct folio *folio)
 {
-	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+	if (!folio_test_swapcache(folio))
 		return 0;
 	return folio_nr_pages(folio);
 }
@@ -4003,7 +4003,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 				    folio_nid(folio), &memcg);
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		if (dequeue_deferred) {
 			list_lru_unlock(lru);
 			rcu_read_unlock();
@@ -4045,7 +4045,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4053,7 +4053,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4099,6 +4099,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4170,22 +4171,16 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 		goto fail;
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, old_nr_pages + 1)) {
 		ret = -EAGAIN;
 		goto fail;
 	}
 
-	if (folio_test_pmd_mappable(folio) &&
-	    new_order < HPAGE_PMD_ORDER) {
-		int nr = folio_nr_pages(folio);
-
-		if (folio_test_swapbacked(folio)) {
-			lruvec_stat_mod_folio(folio,
-					      NR_SHMEM_THPS, -nr);
-		} else {
-			lruvec_stat_mod_folio(folio,
-					      NR_FILE_THPS, -nr);
-		}
+	if (folio_test_pmd_mappable(folio) && new_order < HPAGE_PMD_ORDER) {
+		if (folio_test_swapbacked(folio))
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -old_nr_pages);
+		else
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -old_nr_pages);
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -4209,7 +4204,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4236,7 +4231,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
 	/*

-- 
2.55.0



