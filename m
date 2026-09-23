Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4257DC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF076B00AD; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F756B00AE; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E576B00AF; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86ECC6B00AD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FA46A3EA0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:50 +0000 (UTC)
X-FDA: 85246326900.16.DE48F37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E80C100006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOapASXf;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199168;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjsg2IG0pEb2+cP8FQxvg5g3ZBs65p/JqGTu+07PJYs=;
	b=AxBr4DVIbUVgh7GXq+Fqjr8sG+NabSc9WOx6iDkhdA9QTiWKlh1xYTFOivkfPN2Jlk/akH
	Vk8ZqMjn8+JJhgTX84Wgq5i8/Yms2n+maQvLJQqDcVqdLrfXNOZ1PY4Bc47pnfpajah/s0
	CZLoNM5m6Az77Le+3reacmHpO1FRMd0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOapASXf;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199168;
	b=Bj08QTxIrA6c6vGvhdgv1MUE2jsPsbWCTVqgdd9iS8YlxolwyBo2Zb/pIQrJ5qFyNpJNZy
	rqgk4uR7DEhZANQPDXLNf0nEGiBgj9J/rEeoJXiu1ITJWiJIO4F147l/w9+Yg/OadZikqo
	16OWJZ0VBtsrHMAFMZhjxvq3W/pEZ1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F2E5447F5;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30CC1C2BCFF;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199164;
	bh=YBEVbbweHYfcoloA7VJ7yXPyt9Ai7rrUfs3rNGNaTv8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WOapASXfKBBRREDikSE4WTSa2o0hMgvZbcTfUaa3EndgpzHW1rHJx9zIoF645FM3b
	 mhuLhyFpnzwqPOmUfQuxMJkBtIiDexiB4p95un25TiJg2JNCS02z8xGyM9jPx6rwym
	 l55KZzT4ulwSrg9N+zXPk/zRi10Rfhlw03iVvOvDxfEDk/EyzYnTc8+Ozsmo0R2oad
	 DeFWX/H7TF5ruyGOYnwBhJq1k4jDmnk55lktJEp57MEQLaEPqto2lkESCNRI8nLQW4
	 q1xZaPtuD5tf15XQNi5nNquRibA2eBZYeJf2vubkgWLrifGT1YBMESM6C+xR3sZo1Y
	 aeB87J9ndtY4Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D012C9830D;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:47 +0200
Subject: [PATCH v6 16/17] mm/huge_memory: count only swap cache refs in
 anon folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-16-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=4430;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bHk44bYsClavSrL0S+ty/yMpowjsaEA3StLe+r4XKwY=;
 b=adVtrlDV113daGntojhWEIZR8gAlsfZuiqul4V9XPviQqWQ9DSI+VL0Hz5+JkAEMIkQQng25i
 /kyStc8n+qFDd4H8Y+olbsnYpS0MeClcqmmEsaj8hkNIvq+wsc06lg1
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: osabpof4qkp1rf61kdoqdfd386bu4rcp
X-Rspamd-Queue-Id: 1E80C100006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790199167-571422
X-HE-Meta: U2FsdGVkX186ebuAJ6jtIsKupn0UrC3assUDiuN5XqhfcgSVqewrDEGCaHnYXDd4u7KGAxbCEtno4AubNGmaxlzqJ11+mLGKAmFPFSPogoGr6JDm0mtEun4C5FHbz1SXLUF1TVjeJFd8SFOUhOtV1BsZ/2FAq3DjCxXPqZo7NDEvCgp8N2HTxf8qweVyi05ck76T333Q/y4PFo5jrpQfd8ampEnQvV7+XgVNhhfboxHCA1vYbVmAi5w6jENPVO7wupOhYluDRXju0gPEXcODVVweOiXYztT+Jr8um/atp3Daj7dZ9g1VWTQz1RC4DGYd+mOhsdJNKLEeMtSu8ajGX5ahlWyiaHryhWjjBuj//um5ZsA8ZT6pWFER7Jqy18kirOOZFHV3PZpHn3mAZhF/23vcvRYTewgUoollrF4R3o9G3C9y5OI7nf2aJOvLDD0bX8vzC8PZFbXQ7Me+JKpVApXoXiQon7p6P4fufyT2vTM27qkKL3Ms0hrAjyv2HaCiF+oR1bytOlKMIGq7GNFt420bqDbOBkyXSaZSZDTdunCkX7bp4qZd1wJ2QY3oiiCU6+yZnq1HG+vlPyB4B1nbgDGavIr8fgh9cI1f7AvYDI/c2xPC3/pUAcEE6Ln6ppEZuFbQ/I7qCA1OPz9I3z97Zpl3nFdIeQ92dXPyUrMZA3/lGptC9zbGz8aJaioDPME3IDs/f9YqQCKnYYGiQlEl7lW5zxOYGlxOryirVJffMhrLma1LEVc+1icnMs/EG4Z0zSprzXYqd4IOIoWMwMoeSekzIvfELzXtU8Az0rAskke/935yw/cOQfYehozOpqP3wAwdA4E6CRzJ/fkjmteoV86gfU9s+pi3gQouvbVHI3lWdbDUM+mIL8R+XGvPa0zCgTXNqzqJGCUa414RnZN4QERZ7HXbqlBumBWMtLWCv6rVWQRTXRm7/sfNBkz0Zd8oG8tHfmZAMNgW7dGd0Pq
 LdFequi4
 Gga48+Rmy7MeYn3XH04QxOCwKbcSBGho2cGXcWyx9P5OUAXZRmxX/2hG+tbtWVCKqvrU3lf9cjH9JuYUP1JGDIoXvh+FY7qUUghq0kERE/gyY/GBNWS7g0tKMCtg3klOhd1xwwPjJDc97p4OfVo8OsZ01ifqhKTA7dHVnvJJzWF980uvI8LFPXkeQVi6kwtZDFpF1uVl9qJBRkoSY92rk9tl/COPWB8YxO7mCNnckxK/3SkyYz3iDRlGN2Vs0CmjkiTT9KFhaa7CKa+mEg88dbRibUGMuPJKV5gVILQfmsJnfjZfc65aQOQS0KowAUkuLe6FnTM/rivZNpXkFi19kmgjn3WM4cD4p/E1QGeY5cWAicQPJIycUw+4jgtktbEAPYv292tkNjr6tYri/BNm90/0yYcUNoXl0mbRvml3MuvNSbaXKSjSDqaH0EaY2yyXHso2s54CibhnGB1gVZFyH61JZI5EMQFjtmddGPWoZrkZYGB5qHUUsEWVpvuyP8JKIdvxUAD2hT5HfmSZF4zUk729Gb5P/v9s3s7mlfrotd+6IlBJHr5BQZmg1pw==
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
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a98f447ae78a..d31c1d3d1f8e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3997,10 +3997,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
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
@@ -4067,7 +4067,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	local_irq_disable();
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		ret = -EAGAIN;
 		goto out_no_split;
 	}
@@ -4104,7 +4104,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4112,7 +4112,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4138,6 +4138,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
 		struct list_head *list, enum split_type split_type)
 {
+	const long old_nr_pages = folio_nr_pages(folio);
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
@@ -4211,22 +4212,16 @@ static int __folio_freeze_split_file(struct folio *folio,
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
-					NR_SHMEM_THPS, -nr);
-		} else {
-			lruvec_stat_mod_folio(folio,
-					NR_FILE_THPS, -nr);
-		}
+	if (folio_test_pmd_mappable(folio) && new_order < HPAGE_PMD_ORDER) {
+		if (folio_test_swapbacked(folio))
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -old_nr_pages);
+		else
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -old_nr_pages);
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -4250,7 +4245,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4277,7 +4272,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);

-- 
2.55.0



