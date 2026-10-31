Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CCA606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lbl527o9
Received: by kanga.kvack.org (Postfix)
	id BDE146B05BA; Sat, 31 Oct 2026 05:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB58E6B05BB; Sat, 31 Oct 2026 05:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB716B05BD; Sat, 31 Oct 2026 05:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E53C6B05BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:41:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F10840939
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:51 +0000 (UTC)
X-FDA: 85382429622.14.91BC060
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5BC28140003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lbl527o9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pk0QLLT1Q+glqpVFAufOCE2fluI+upxsW+zJulW4Xl4=;
	b=E3yc4gs/L+jmKZchbIPDu3kq3AtdMdcLrphn1LLAXOu1fH99IccYT8t4YGrA/KB1NeJJv0
	pV+3z4eDRoJdHk/YeE+RZRyAmCpfD8tRPgkFDUtf9QjP6N3k7RDh5kO4EMseIWoiNvY1q/
	v55fdOUigDwehQrc1mIinAEuN1/vU1Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lbl527o9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439709;
	b=Of6fBmTXLh7gV8rpv4EScJ3RjcFQ6+Mrf9Xb7E7p7jeC9M364F56puJamh2e1n+jMiWSut
	yAWgq2M0gSIRfyp0QhHCVfHhZmUJROPJ+xNMf1wCFs1/qOhdCvKNwfRqvGhi7MCBni27b2
	JAMULMJEn6oLsMckkdBQnrmPMMh/7v4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8265E43826;
	Sat, 31 Oct 2026 09:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7991F0093A;
	Sat, 31 Oct 2026 09:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439708;
	bh=pk0QLLT1Q+glqpVFAufOCE2fluI+upxsW+zJulW4Xl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Lbl527o9fziAQSRkGpoSu4N4ka4xN731O3fNIdNyi6kqdlbe5h08IsprSo11C3roe
	 ofp10Jv8nYAFvTJKLaP1mqLSidYs7BkoGZgg9aBmgsp6uqG9qdwIVt5LJreRCqPI6v
	 Hx7VFgFmD0llMSqGuDChfPADJVvMoO3bcZCVYroETGsU4XGDqymjHOnryqHGAjTS/L
	 0eAbVeKiMYxK76pyvy03nlquWkXULALcNeThzo0bl/RVilf4a6UrP1cHJPnSOrkRX6
	 i8/vSB8uHp1/pjA0zcPlotFxhii9quFUe1FNT5rgm6F59KAMDRX4KeKYr1WxzT6Xbd
	 e1mCgFMg+1/Yg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:35 +0100
Subject: [PATCH v3 06/47] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-6-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3817; i=david@kernel.org;
 h=from:subject:message-id; bh=T6HQDq6d9/zve4RkO1HUzXLGKE6ZrXgEK0unyQlfFbc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk893D97VojlKnlL498xJWf23Th6YNa58oVPlXi4Y
 8pmmf4W6ChhYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiaw0YGR5EMs8rVN4ofoxH
 41ijvukkq46vTNfueObeOx8vu2d3mBzDV0mB/TfZJ6n+OSR1e9kUadn/pt9MrjnWmAdIiHWsLBb
 mBwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 5BC28140003
X-Rspam-User: 
X-Stat-Signature: o5sua735thm6nc7dqbbanhk4bnuhfeaz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793439709-512647
X-HE-Meta: U2FsdGVkX19Iov7byfXItJ5hSfnLbVtSHF7tT2mUq8ePpvFMZBvy7t6a4XaoUf2Y44rDOxCZaGe1XQuOMR6SF51JftfSQJWl+qE/dbrZWwnhJ+y1fB2JAKsMhpBJp0JwWiX6UnyxjxGBwdwwRzas/K71+BoLAX5zvDUq1/evedSPF6n4jAzxalnohcsLpzMMFvwK2DPXnEb2aRN8z6A82eC38nTUwLXg55HFjjy5PkLjl5Dpv+0w6Z5xoIhcow3oruDz/ifxuYRioR3Rs8lP5ULCT/+LlfTh2ttFtXZnX+h0OqGAta46hV4iq1mqwN570Cn4Vf/FwKZ8obSwbK2mfV6jCeHynu0GS/g6mzEZf/IhNIUHX9Yd303eSZiqO3nrRiqCh0yOCPMmSyrdd9h2Qxi8synnOGpUFxvzsTX1mJVMA0n/SWe9dbgP+3mcLXHiN/bLJZ0R3bYp58T5Kw+gd6o9959DcLLvPIp09PQi2XRxQKHKE2glWQD9qosKeY3MYRMj6cJZTnOSFwPmzh6v2hSxJccG8hN54Ew3QOmvEErwBSA4aXeqzsH02i54Auag6jtEJCsSqCE4Fe+ZlpI7min+0CuLDXAcM9taDxQGr6o3WEO/0Y8ah6VBPeAOO576Mj//DSUSih2x/q79SBG70FTbX/8SEw8dc3FIlwP6EJkeBRXLdCPz5YOD65ib2j66IsNEm5520iPXr4EVUMpf4OYaGpFvGxxpNhBoz5pwRK4hsNayIv9m+Ao9LTohxxeEIo4MxlYWPUrkLh29GXNIb5jCNMaxaW+bLiJaG5mMkVp81TFB2KnKNO+td5Le74CAAcIVBP7aTakhzmnl6E9joSPSoqSR0TfPs0incrnEB6tZMDTFy4/ZKM9X3mcNJEn8Prv8diiXzeCZvFNrhtHsNTmjHaNi7iH7AIpKhk7IfhNj9yFun6RqHIX/DarDMihfZG7cuKK5w2T1j1DSe72
 lhDMYFkO
 LPjBlo03KX2Qn21XsdqcmbyOpAIl8g6kIHGZtmqU3gEr1iwahqX4TJFwChB8VuHbTUYdkiYkW/HiwnTx10eHE0LCh6jdOFQxVn+a77/Fnr9g/F7sKzC/mEAPutsOV8axKt7VlEwhlKMHsD2aniQ7yqtxf56U1fjByCSgUdErhnh/ywZv8dj3GzczO43Vt2ZtzCB4Hkzd391yLmrEaJ3p7accCyiDBCtwRIPX9r77SsLaoUIqUSekWQvV2BLSKTszt6BMML2e+r2eqq7Yw+IAxCs4LhvrfXfJvd6qelqwC5wI9YdtmxYBxdR3UfmK7V2/hufVpKE++S2SP/NnEbXvP6vRXYn+mlbAys3oaWPp0jVyVimZJ8Xtuqs8zxtBRfBZ22sMTjlb1n8mzhi+3iBy8YC2Y60rVdjhQ/TrPN6hOgL0SkjATlhsxbENDofAWHDyfRzempTbWMlwgbKKpEGdJtFeDkVaNTUMoNzbrnV8OVjZeWAC2lfkFcToJK6QrkoI7DHhWJrkUGyWvvI5Tvz/ersuJkvduv+Wp7x6WbzHYCrrzT+Z0Z2jYkTwEON4e/uImFWAW
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c6..906b013c11eb3 100644
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


