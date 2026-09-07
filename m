Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C513EC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D7C6B00A5; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E6A6B00A7; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954D96B00A6; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA666B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBE8F80272
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:22 +0000 (UTC)
X-FDA: 85187760924.11.9068FF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E02A44000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pg9LUZlo;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804741;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D58ri7qkLrmp6ZRuJal+MqpvSXKbqzGnj2TxDAR7kzY=;
	b=heTJsF0Ohfr26lmB9KW1Dr7NEDw6503UxiJudWuN6zyEp1i5RBNiWxvqxFdAO7lTyKMEMQ
	Xbc0KAsKTe3gVtkTYiCieGnaNNUS0JdY7u9WBplZPb+b0OBaIS0luyJtHRwohjEc+enduz
	q8hM5hZt3GRMiBm4gM0qtnfJRBRhslg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804741;
	b=BwmUSUhCY2X81si3dwmW0VUcSbfxeORPb0eSP9/tZ4gX/8c7oy3nf1GW9y+qFVKwF3l6qd
	9SjtR0McwfWgn5Nqgs3b8NcCNhD8n5uv7qpBk8FLbyOW3OjnHV/AjIFlFe5rkpkSAhKRYx
	VL0hayhSFIxo0C0Q0xVDOOPj7AMP/2Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pg9LUZlo;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B9F7444F4;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D7ACC2BD01;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804737;
	bh=CKnadc+7pWXJlgz4J8xzzvddy/Ve8PJlE6DTq8avhuU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Pg9LUZlohuQ3KwhtKtfYnhOTWDqL0C9cHdWVObXskUDJonNpsGphwSFI9DV96SVma
	 mi/zgru98Z674Ak08rySE6ghTLnOvbDdtrfoFObjwe7bX9U0aNEwrVLtwpy9W8InxS
	 eEtjnSCOoct3xMdJr/mjTILWXeOKsydV5ej5tDySUu04mA64JlUbxfBiDNad2QbqfA
	 S8wqFiB8ounwkKbN/qIDR7ZwporiTWUnlAVq0Ph06J2IcpDryY4k+cXTWXF0Js3nJH
	 lgBh/HFpRO7dLHqbl8y+B/gfqlqcmv0xj1Qj1sWfJq/tNO/O7/cP8bs10ZnZV9x1r0
	 foesTlInjm26w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27046C79FAA;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:20 +0800
Subject: [PATCH v4 16/17] mm/huge_memory: count only swap cache refs in
 anon folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-16-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=4303;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=x2XvuBUmjQ9RNkNardz/nbyUAIqiAzW7DbxwXCBxFbw=;
 b=0Gsh+74RbR9mPQw8kiFGdkSNC+du48fBuP6BSEuvvogqBLljdob48chw7eBIYhZ2o7By15fSR
 +JdLUcoRtWQBC2dRnrWTaaESvHKWcD1NTESkgxQ6SsuNAZdHCnkXlus
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E02A44000E
X-Stat-Signature: 751ugbzx7jpgp3wzz3tbekhx9byf937g
X-HE-Tag: 1788804740-325310
X-HE-Meta: U2FsdGVkX1+cRpHuvIVMnNfDc8NJHndKeoxyTySvaouL6MnG+KhLM6eoD27qP1RcpPla0wDDl4jxNpdcmQqe4EgWFR/+Z93G+WLVyLX4AhW5phSuRk01Z0MwYUDm9O7Bj40TODG/xLv/COBWLA0tDyz8K/fevErnnkm/wDBi2xGyKakuScB7lrmqMje5QW2WyaLq/K7CJ3VBDqBu2JQNM2aLffY1LEo9qHZayMdl37uvNxxlUKUNiNwh3MzhE8N57EqGkApRnD+f1g7VXbDTu2glehppEIFfguSuFa/X3b5uLPq+xEOoXIlqrZHzIWc6lKqA+b0lZDPYpKEYTK1ywz1yXEGX+d6ClpI93FwH04v20JM9e2CSoM+t9jkTWGuKNkQ7lSVc9jhadDNLRbO9CNZ4BKLOOngGujF2FXz7yRfiemJJoycnKCP0H84eB5vQQjGhFEhhRMq75nAUpySP7ly4tCPlCNJAQ+OiZNwnLuYauL9Y67zvd26D4NTJTqvWYNGbLyBup5eQoY4Pv9pI908LTCGLH+4Sitp54d1PE6XSuXMzjqElPV2uDp84O9TsaI2Arpu9M3O4XhvY8Td1rtySTv9e4VuaM+jlcLxfq1IGEsYZ5nbRnIfpyK8NQ5FJtaEhJeyeNw7S9KOYAkSTm0CnYMQBnpl5WzpnH+stTrm8zQdcJHfph1kaKfTrWvckU1nP230cgQ9VyYkc/rJ7SuCgUvX3hiH5nhFWlpbNiDsGh8llsHADKuIhK8jSeUk6mWY7yuHnsDP8GzGo0tcS562GgwwvADgbvq7RGc5wbTRTr4JKAiQKGBHV1tSgtJBLlR+1D40/79A7ydVOQrs+JZ9Jqjxj9yB4A4qVgwwtq2S3xhcjGihizHqTt/KaQSEMzIiqZW7LEN4SH15bg8jL9jMeL5t8KjsHGRuDcSYmAuZOIzoD0rxb4S0efYGrmIwrYihHJPDb64gTNFOGnLD
 Lcd7OYzG
 mpOSGuVnF0I36Qv7ZcXbZWqXbs+L9dYRrZUJB2e+zKR3kjVysGr0Osr01kIAqJfNi2ulf5MI+HCioYJVYyuQBKsVhhFkUxcNFaPZGd9WWIkunxAJuK/aTUFW1kPv2T9fxWwvr2KkGZzJb3jTGAn923b3+s1t2Qmj/eSwe1cUzMiTRTewp+upBYoZHZQckPNzWtbTV+9tD/JCj/A1WaEy/SZZ+6HtanMvHZxCIOlfnvwMJ1FBjyCohbCxqHsG6W6DiKqdJxa2CcB1huwcrQxHS19B3rDee+vUbUX+rKnzWNFGLtwkVptzo6S7YaP1X25feh/y2WeX2FaSGQnSnk68hHnQLopUS9g+zefJiJifpvs3hxdm9JtL/eJpOFhyP1FY2LC0T3qJ5Wuj9dDx9W3EfOatna7b+yV2V9CJWi5kMku5GTuMx0r1QMdVw6JjxdE0RMPAC9qH4nJDK3xprd7+TQ6lLx5B6Vmv6uCEvmh/fDchF6rpcdDWfuz3sgFvD5kVQwomF3hq8GNMNKFDzRh38vrVkNtsjlrTuLT4r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only __folio_freeze_split_anon() sees anon folios and swap cache folios
now. The file split helper only handles page cache folios, which hold
exactly folio_nr_pages() references.

Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop
the anon check so the helper counts what its name says. The file split
helper now uses folio_nr_pages() directly.

No feature change.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f2862556d715..661b1c747c33 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3989,10 +3989,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
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
@@ -4034,7 +4034,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	local_irq_disable();
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		ret = -EAGAIN;
 		goto out_no_split;
 	}
@@ -4075,7 +4075,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4083,7 +4083,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4112,6 +4112,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4182,22 +4183,16 @@ static int __folio_freeze_split_file(struct folio *folio,
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
@@ -4221,7 +4216,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4248,7 +4243,7 @@ static int __folio_freeze_split_file(struct folio *folio,
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



