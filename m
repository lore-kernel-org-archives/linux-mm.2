Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3332C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D376B0158; Wed, 12 Aug 2026 14:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817106B015D; Wed, 12 Aug 2026 14:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6906A6B0168; Wed, 12 Aug 2026 14:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 297CB6B0158
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 848FEA0417
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:21 +0000 (UTC)
X-FDA: 85093505322.10.997D220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82E38140003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KS3dleUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560559;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsuAzCSXbbtt4zZiN+g45vPMALBMW/8ac0w9g4buRbo=;
	b=WZhJT9Bua7DQa8igLKZkYMtUw3kOEazFz+OuBo3yqei1pc5DLGkYwNAxqMrjlpvvmNiPqO
	Z/NIwOpzMdT4g809t2ZBtbo4PWGWqxVZPXlhQ6GdcwxJlLMyqxQMc6BGRm3tveyHuYl+TN
	JIf2bi+mrDe08z6M28xNyZPSnvHyetA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KS3dleUx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560559;
	b=lQGSGc9NiRDzMVNlJH4ntmCaJdBjOizZ8zmlAkv/gv4oMcd15IPyLeLMiytgbspJDwQoef
	OoPssJj9jcAke7LmUk5/wcG/rjs3VEvc/NoOOBGTHQhDRetsH7FQcC7RYKk4gDKFm9MIoO
	9ZGj+cBptYSMQ249qWocladZ3zxv7Uc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C60A54503D;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5D00C2BCB3;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=zXydGbi1mCMmauDvoJJ6ITE1co5O8uk8Ha0dlSt9yNA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KS3dleUxCCO7k/8smCuVew9P15AM7rITyvaQqZofT+Eik5XwanhphNO6j45HDUqDw
	 hJR3IMrAPjmyf1KK+l/8z1JNLKwQp4Xns4NhNwpIQ49+igMxRlPND6PvepfqvoVUMD
	 2rTxKrC1NtBWZBkI7D26Vvb90SdegF5xsVk/g+E2HrSFupC5bYRkg//EFvMfSQs64i
	 36LUHd56cOMPcnfEBmfB2Vu+eQppA3CdG5hyxh2fo7cKQTRQkclAp+XLuSyok3Z+VI
	 l9YbB7TLo2R046Fr6nR5LgjrYkWwSVEpfdy4z+pE4oU9BEzkeOYSzX/TGBLbi+WIyu
	 yHUxcoiUHYUTg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E89C5CFEB;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:57 +0800
Subject: [PATCH v2 17/17] mm/huge_memory: count only swap cache refs in
 anon folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-17-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=4502;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MpCncwju9a9pcoRTMcyfhYSBrYb5Nj043YSXcbCJIqU=;
 b=r9OynKAJ2fflZntTFDHvkIHY6aARm7sGNPxnfwN+ppGCckMlUqRUJOe/OYX8WUtiuZR4r7Us4
 CcXkHITqh5JBHq2AI4csVKqWi6BoPtYp917V6byQWQBj7pHWkuVxfbd
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 82E38140003
X-Stat-Signature: bn7r7w6kk9n7x759g4ajdc1g3w9rt6dx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786560559-662394
X-HE-Meta: U2FsdGVkX18wFacCope2/mJnJ0JNcCOz34iUjBKi/aH15ulbc7QSXlpREOPZ3axwVdEMHq5OG1MDytkObGn3iPiwGcgm1VMK35pzECbfDHM7c8be5f0K817BzOKwo6hu4NTRU5aIB5JJ34PCbRNk3LsB1LxX7HiCNe4SLF6Nk1qYEObPcNIsb2i6XUu0OGNIs8xKTtGwSNDoK8elhOLAvImqgxyLku9vatBHS+RobPn/yQThqmHmZJ9SzAGVloX8hfGjSmRPx03Jrpl3gIYM4budPbcfo99HsJHF7rrZ8yZA2P3XhS8ZDIPGhaBo0bM9mdkHJQroEMZLFVW6W5hIKCJvEofRYsBpNMZv6iQVGvVkl4DDeVVPu2qni4G3DPtDOa2su5MjEPjDXWz2Z39OmEhSVUz16tGH2vFdTNIAEcdblNlbgmNZ2251oetWz+Wclus2MbIHG1SjPimXl368NsVvX3/UZL0g1YODFVfj/cdY514BX97/F/6Ag9zI4hBRk85lzKa/LKUPATa88CAJSrzDy5E7NSd9hwjMXyJ2/thYmLBi79+Ny3NzEEroaPrrq0OPnC92ehWVEK1qwX3E4cIoAXFLoOqV+HA7ULM6Ynrj2kzBtmMeMxH2XqNJIKSMP19lSIY+2S7z6SK5Ra2zn/ukv4pVbtxTxSg5hjHYcSoVlcmjYxWiBD4a7PxBbodJCPyxZ64Vcvz6x4oQcVyx/NAACnXIh7RX8ZQBGdbOSzQmnFOEXAOWcDhN1+czKefUoqswtVO09Rae5aNWvLjBhujVUKiAHoFPcVDBtrMkmKkNI+U2HVQq7c7t8fKZU26x6oSl2QD+p19YcnrzkC4HAy2Jvdit4pQkC/oA2t5kw7gJ863F2dWnXEq8XqmtZuCrNixTsv7EVrE2Dhc9FxLbZuL4yFOIfwIJ1lTgtDAhSH67VM2+06atqoabFmWRfvqueFT8LZDTzsaoQb8xO3F
 tvWLoP/m
 6u4rg5m2kSSS22dD2/65KehZG9jv9rBgN81NtaVQjnLB/eb2IxxHY/bpag5CgBUgpsMFVtMsA1xIconBV7RIFe1tiBUFO4Uc32tdMKX4n/kV5ODa1QhLldhI9EHmViGiHEff6OMRK9nvN1QLhTTeLZ4Kh4ll146PhtmVMGU6lERvnmWHo+uqY/HpVQhaT0Kp/Vxa2D3/vNW/woDxA+kaHy9N5Ts95+G9g1MvQoIzJK+U5vTWl5XMk2iImJppdbI+F+CszNzD+yrE/q4XIFh0V3jzNNoNss/+rkCfXn4A3oczirYaE99q9955I5fiVzlVRE/4yiMjCGIOc6OIXPhLGbddzqd665Png495euSgvskNt183A02hn6WxxhAK50Bd2172wMf8HEg1acDR7Fmq24yAyBkMY5sF9A5Jtntdi8E0ctK/s921gDEG2U/Pvbeu4XCFrqf4zeW5mJmCNuI/WGWb/r4wu59hPZYy5
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
index c8ec12f6f471..1c61b7d39cd0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3927,10 +3927,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
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
@@ -4015,7 +4015,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 				    folio_nid(folio), &memcg);
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		if (dequeue_deferred) {
 			list_lru_unlock(lru);
 			rcu_read_unlock();
@@ -4055,7 +4055,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 	for_each_folio_safe(folio_next(folio), end_folio, new_folio, next) {
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4063,7 +4063,7 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4109,6 +4109,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4180,22 +4181,16 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
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
@@ -4215,7 +4210,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 		unsigned long nr_pages = folio_nr_pages(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4242,7 +4237,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
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



