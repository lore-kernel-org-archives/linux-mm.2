Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA875606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8stvVUt
Received: by kanga.kvack.org (Postfix)
	id E4D856B00EF; Thu, 29 Oct 2026 16:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE2A6B05B2; Thu, 29 Oct 2026 16:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED5D6B05BC; Thu, 29 Oct 2026 16:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5FD76B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:35:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28F8DC04D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:35:01 +0000 (UTC)
X-FDA: 85376818002.29.CBA2A87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A0E28000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8stvVUt;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxYr7Sm6OEegxhd0iVI9DwNJDZ8ymD/S/fyvDRwEbZs=;
	b=E2GzWTXRx40r5TQA2h7/8JOqw2W3CyOJAJDWzRVcg3AAARiejQv1b4dNXhJAsxGksELZNo
	FRk3ZEZ4whxrr80Bdb7doKYMdkjJnnqmMVhhqQk8hrB8duL7/y2/gWhe3D1a6FCtXk4trX
	TP+e0sV+WwQi+Q1MyEUsUEc5Do8e+v8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306099;
	b=kGKYLr/sFDxhIQZkC5v2Z6/wswDm7rYpFKz6dbfhXUvrqv0jvsLllx8Hykc5Rk5WAj//7v
	b2MG5qB0sbksPYeo4+YtbJx/Z4rYZmzWvrBlLy6cOfGDWRKIpYHoX5khauTpWLbDc/pk84
	kbCrPBksyyO8II1teCtWb5knQgYrTew=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8stvVUt;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F189F605CA;
	Thu, 29 Oct 2026 20:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3413D1F01826;
	Thu, 29 Oct 2026 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306098;
	bh=KxYr7Sm6OEegxhd0iVI9DwNJDZ8ymD/S/fyvDRwEbZs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m8stvVUtaQ1zzXBZo9b4DXWtjQAwfK94PwzaJ/eyWlctn2jfEk/kIccDZT4yzRzTV
	 xUwhkYp4JFgiEQbnWZ93UJ8mt2S+Web/7pzGe0SpkYI6oocQZiPLpHT73hP74roi3D
	 Yr+BUk3pE/quR4/Ig1StPmT2uOE6hcTPcUKEVJ/Lv5UMx5k4G06IaFelmWSX8rEvzA
	 ylUcnc1dGEcjLRHd7oeEGKeFW/1BtT4p1adLyRlFCZ+tJKXJz8Wd3CUiSLA5LptqrQ
	 Lopmi7EvwC7Ts8BZAb+MLwTj6XScPpqfDLchayfM4KgiBF4iArRR7JwJRL9P4FDqwX
	 OjQa5upyhqaBA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:01 +0100
Subject: [PATCH v2 06/47] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-6-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3722; i=david@kernel.org;
 h=from:subject:message-id; bh=QdrOe18hQtm70tC+kr29IxB4g7ljmyzLHze5efGpjA8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer22pSz/Yr2rC1Wyzv75dSO/9zxyjvv59K06tKJoq7
 jFNwXtbRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABOpqmNkOBziF+Ztzcv74uOs
 M8/99SO2irj9uWaeLBJ/3eKDe2PYO0aG15ob3G0e/LRW1gmRjJv2v3bv/R1bGjMeL888u3fdBef
 zDAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A0E28000E
X-Stat-Signature: pik9zkam4rpmzes98o5ei1biekuniziz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306099-304944
X-HE-Meta: U2FsdGVkX1/GtHy9d3ixx80jD6dtvPOO7iWJpDHEvcWViryLxp/GDoX74DQ1ng8nWoDeGBexAeDg4Mwzf38Sm2oFoTKBs7qucuX0qhBGF65dUZ/3ucFF3WL858se7Td5/spZHTufXe0xML/he1M2vJEByiwA8y2l8UJXWngmO5nc+WfLdpolKesVBk8Nok8tUlZIORRh1fsHkdwi3J6vQQpn4LI7RqsmKT/O+gKxCfRlBm3HF+0azNL5SX+k9vHdXeHPho19e+2DFjFumpdH18kYSOzLme0lQ60pPRTvHq4Dwond7+m3MU0+LtjRyO+EmfZxtnRUQJlcEyZ0pGf4MyeIsL9QvAfAhu7TUupqKVEtiYMBJ5l4oSOSL7j77X+kayaTz9/ndXRL3k8wSptFeTyKMU+0lkX7TAsZLbS3BUDWoZLzOEYR4vCoGa4weTDqdDYAK4Re4yQU/U9J44PkJejkgckQd8rtbWZNJwwFg/SweQyxHMUHAZjdSWNtf5e+cXQnQjw/C8AJSefJLK3yMps5jRb4LR2O3YmiHdQomXWgCYmScqnzulJmmZ2l3b4bKLWIHmt2QJA8reh2nOeRpdNGmR7bzOiyyzPYTcVC4RftDCPlQ+nfbMjSv6ZqfGiF1y2K4UEpRvc6EZh3s+CUlTbxE6s5pWpdh96KdY8q41s8+XK7pDbxxBXqxr6t8GMYVV6M3FBHrKU7WPbgWtBdZ1W5Ecb+HuhCveFiWgiPEDuBoLWdlnn8J7+7vF0SL+NaMSj5q1dpGw91F4FjfeHkvuJSV+d/cxLwZYMp8rJkEkToWdmN7bYTGfHRj+VwoX12kozNwoNz95URFeZAn3lIjpa9M/OG0HbsYRhNr2LMTFHziusIlhQ6E+QpO2Wvg5Nl2DxVx5xqTGU2GUlTQ8DiIMjT7viFwiFPNVvw8IGytQfxDTM9rQH6Pj0QSMwq1N/JG0LqpBgUd8ncNkgOW41
 gE67HNSc
 CHb6ebP4kKu/94D1FEGcDG9YQqqbHZ9Ab94rTQ2EaSyEI+S6+S3ya06WgmKuHZjbmWDcnQ7rnyP1qgMtSaHjS5xGwbopSq9UGJLlf7bdNcDC86pFkXYpLgVYrAH6LUPsBwkmak6SFYcfo9epKEVzDHzFNJsUYGmXKGowj0QqdzzyXXYvVbTK3BgOoXCfZeDlAHGQaidpxHH2HbQ6hgsMNAgzzlA9dog3VvyHc0WsP4hejPR988X6gojFxRMoGIWIVfwthdbwtPTLZjcqPSGblMvntOGaTj/DFY9EHXpS88xxDL9zkAbQU7sGKuScdbquGKSRDdbGg2/mL97BWNxpUJr2TrDEYRMzsJGYqYDiNQemULCM4uSkIHDIOYzidRU89HywrPdnjsceA9UTF8hgmZt9268pqU/Obe/lh2nvNr+tggBDkVsvSfEXdLHT7kPay3SWWTznqYP5bv/X823f3OW02X4RxCLYOMMJLlFxHurrwAO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

memory_failure() -> ... -> filemap_remove_folio() can read mapping->a_ops
after the inode has been freed. Once the folio is deleted from the
pagecache it no longer pins the mapping, so after i_lock is dropped
e.g., a concurrent final iput() can evict and free the inode before
filemap_free_folio() looks up mapping->a_ops->free_folio.

Most callers hold a reference on the inode, but not all.

Documentation/filesystems/vfs.rst explicitly states that ->free_folio()
must not assume the original address_space mapping still exists.

Fix it by loading ->free_folio while i_lock is still held, similar to
what folio_unmap_invalidate() does.

Inline filemap_free_folio() into its remaining caller such that
delete_from_page_cache_batch() also just loads the callback before
dropping the i_lock.

The bug was found by code inspection and has not been reproduced.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 59c66c5f8c4f ("mm: factor out page cache page freeing into a separate function")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: get rid of filemap_free_folio() entirely; improve patch description ]
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..906b013c11eb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -227,18 +227,6 @@ void __filemap_remove_folio(struct folio *folio, void *shadow)
 	page_cache_delete(mapping, folio, shadow);
 }
 
-static void filemap_free_folio(const struct address_space *mapping,
-		struct folio *folio)
-{
-	void (*free_folio)(struct folio *);
-
-	free_folio = mapping->a_ops->free_folio;
-	if (free_folio)
-		free_folio(folio);
-
-	folio_put_refs(folio, folio_nr_pages(folio));
-}
-
 /**
  * filemap_remove_folio - Remove folio from page cache.
  * @folio: The folio.
@@ -250,6 +238,7 @@ static void filemap_free_folio(const struct address_space *mapping,
 void filemap_remove_folio(struct folio *folio)
 {
 	struct address_space *mapping = folio->mapping;
+	void (*free_folio)(struct folio *folio);
 
 	BUG_ON(!folio_test_locked(folio));
 	spin_lock(&mapping->host->i_lock);
@@ -258,9 +247,12 @@ void filemap_remove_folio(struct folio *folio)
 	xa_unlock_irq(&mapping->i_pages);
 	if (mapping_shrinkable(mapping))
 		inode_lru_list_add(mapping->host);
+	free_folio = mapping->a_ops->free_folio;
 	spin_unlock(&mapping->host->i_lock);
 
-	filemap_free_folio(mapping, folio);
+	if (free_folio)
+		free_folio(folio);
+	folio_put_refs(folio, folio_nr_pages(folio));
 }
 
 /*
@@ -320,6 +312,7 @@ static void page_cache_delete_batch(struct address_space *mapping,
 void delete_from_page_cache_batch(struct address_space *mapping,
 				  struct folio_batch *fbatch)
 {
+	void (*free_folio)(struct folio *folio);
 	int i;
 
 	if (!folio_batch_count(fbatch))
@@ -337,10 +330,16 @@ void delete_from_page_cache_batch(struct address_space *mapping,
 	xa_unlock_irq(&mapping->i_pages);
 	if (mapping_shrinkable(mapping))
 		inode_lru_list_add(mapping->host);
+	free_folio = mapping->a_ops->free_folio;
 	spin_unlock(&mapping->host->i_lock);
 
-	for (i = 0; i < folio_batch_count(fbatch); i++)
-		filemap_free_folio(mapping, fbatch->folios[i]);
+	for (i = 0; i < folio_batch_count(fbatch); i++) {
+		struct folio *folio = fbatch->folios[i];
+
+		if (free_folio)
+			free_folio(folio);
+		folio_put_refs(folio, folio_nr_pages(folio));
+	}
 }
 
 int filemap_check_errors(struct address_space *mapping)

-- 
2.43.0


