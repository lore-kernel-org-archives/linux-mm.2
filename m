Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 366D2D3ABE7
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 03:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3046B0347; Fri,  5 Dec 2025 22:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85C7A6B0349; Fri,  5 Dec 2025 22:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725476B034A; Fri,  5 Dec 2025 22:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4A86B0347
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:09:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB9CA13ABCD
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:21 +0000 (UTC)
X-FDA: 84187565322.14.ED2A8B0
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf19.hostedemail.com (Postfix) with ESMTP id 363151A000C
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764990560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpEvM5QA3+28q85zNJsdqsm5CDxo4uLtsD4iFf1UZ1I=;
	b=wktNQlAtJ0nVu3CMmjZ0Os3x+wt4gMQnpWWXBfdWIahKDwOTnOOix2o6KvMdBvWtMZVEUt
	ayfxbwmZYK8WT/gQ8SEUrTonQTeGuhURsKhJ62RIr2+Ej+iud6bfsbv7ZjZw6OEWBMMxPK
	A1mq8TBmCKrcYmNp5xiL9brL0ZZ9Rxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764990560; a=rsa-sha256;
	cv=none;
	b=n4cwdl5Yxf9a7nk1oQNLsuDCabIPpvyI+4BY6/KrDFCzgsdyYnVMgiLexcPvZQ2e0ywwuJ
	b00PcJnnSjjTDOV4o0ZjDqB3Xe/uTmsI4oqi8G1CouRx4FAXXY5JbJlG4Fg+qSv5iRWGJ2
	5aOn5EEJghuSWkEhWyXzek9hH/o19Kc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4dNYB4093Rz9v56;
	Sat,  6 Dec 2025 04:09:16 +0100 (CET)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	tytso@mit.edu,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 2/3] huge_memory: skip warning if min order and folio order are same in split
Date: Sat,  6 Dec 2025 04:08:57 +0100
Message-ID: <20251206030858.1418814-3-p.raghav@samsung.com>
In-Reply-To: <20251206030858.1418814-1-p.raghav@samsung.com>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 363151A000C
X-Stat-Signature: tiy5f18k38gif11jm8thumkui79eeeek
X-Rspam-User: 
X-HE-Tag: 1764990559-112548
X-HE-Meta: U2FsdGVkX18XabhEqyHEE2sM9HYVNXGaidwa24o2KQE70i3aJmY89szDTpx8+PTeVNcXRDNg4XTVqSKB4iEmHF/ehRx3KRZfkdSO5m6DNYN2QdNH5N9Mef+vKN++9OAmNJ5Ask0nwh4WgDAtYZOhFcjf2iHBPB1wW7nwWNcIQyQ5e/3B5CsL08CN3Gc9yVGEgp4iX7MqsxmKroFdoPxSQxKby7Vehi5HGamcs4XGJjDPnLZPUgwqfXO6ADM2FmikkMv24Opzdk2WIR3R6a0b6NN9lQohxZnxebObf9Kv4oUXlR6mRego95HuNMpQGyFcjybk3isrrHgrurRw/BwoEYVdKQ6ZVckPibcslbWyRdNoQl2t2AtrAU0HAOYLiSO5DjKfmyCEeobSGuTpu5hcSLXTwyeR4VlhdJl4y4Ww3ZWkrZb7JWGNy12Z0dfEJ/oyZz+ph+cqcwA0hMwCgwO2uLi/LfX5TQ2tONktt4XUuEDmiVC4UUksm80mI95WlRikvhB4ZfVtxIXzVvSVsOJSabJ46O2MFMSPvqJ5bh+NKc0Kdw2IQqKiTbxmwrEWcIumRoM9gnRWx4+KBa6HnDGgV/EIa2yDDbF+PQNtNKAr9AS9xAboBRSnkVaYsk7yJPdxRDU8ryzKL64lzmKF5FtMxjqz2hax8kKikJYX+ds7ZqdEcNcqpIw8IhC4ZG2sp+84zRNPedQp7LJ3SDqXl1yYiYBsyScHHNmhF6+k4Cx3nL5HnxXyQssoakLneRtVCnrpCrNyUeFq4ww2KyAgR3e1UrD956Gek/YROsMY4hPorEoVhxuLTgAM9mwgeLnSiT8kHc+C54hP9XxMStp3TXrBYoFpJmOIO7BpvPSljeGw78+AvyYI3DcDBaEn6bag3s+ZZultDMAiwearRYRVWWCgFNIdFRieXRSR+LyqKCsoBc4/FD7KT3n6B5IBaavLPSajVDsUOsdEq/5Nwuor9I9
 Bh192yXe
 HR4iqp232xtpHMli+dxqYcaegKUJArH8yIRiakIAOrmaPFJeYCcsi3zyY1ZQC7of/SEIQCZsU3p8jUoXvWo+eB7jeo7oz3BOttKTGyXaBhFLl+u/M3WyICPZ8fqpg4kdZx6OchXriNp6isyTDAEJdY/AWVayGlUZNrfXX3IZ7dPSiPk2nXgecUUPuIIMNWJyaMYV9+6lVjT5G46fbR2JVB7dDYu4u7bIogTCr37q9sAK2VZJVCb+Wuh9EWrPk0T5aeFnZEBM7fCGYwQY0ej5ovHk48EOfzylfj9Iwkq01FPjHxmbt38ViKvpGNlEoZ7h5J3uqH4LAmoWrT7zvGf9C+eoKByJ1jSM6Q9CGWiBysnOFqAx7z94kkL8KI3LJJMErtSiifqt/HValtr7/CwnrxTNe9ws1a+O9MKMLRhFVRxxe4dwGRcako9b38qwnlPtB7QOYwX+igCFUFdIrYEVk0K0uqSYXzWvRyLz/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When THP is disabled, file-backed large folios max order is capped to the
min order to avoid using the splitting infrastructure.

Currently, splitting calls will create a warning when called with THP
disabled. But splitting call does not have to do anything when min order
is same as the folio order.

So skip the warning in folio split functions if the min order is same as
the folio order for file backed folios.

Due to issues with circular dependency, move the definition of split
function for !CONFIG_TRANSPARENT_HUGEPAGES to mm/memory.c

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 40 ++++++++--------------------------------
 mm/memory.c             | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 21162493a0a0..71e309f2d26a 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -612,42 +612,18 @@ can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 {
 	return false;
 }
-static inline int
-split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_PAGE(1, page);
-	return -EINVAL;
-}
-static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_PAGE(1, page);
-	return -EINVAL;
-}
+int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order);
+int split_huge_page_to_order(struct page *page, unsigned int new_order);
 static inline int split_huge_page(struct page *page)
 {
-	VM_WARN_ON_ONCE_PAGE(1, page);
-	return -EINVAL;
-}
-
-static inline unsigned int min_order_for_split(struct folio *folio)
-{
-	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return 0;
-}
-
-static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
-{
-	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
+	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
-}
+unsigned int min_order_for_split(struct folio *folio);
+int split_folio_to_list(struct folio *folio, struct list_head *list);
+int try_folio_split_to_order(struct folio *folio,
+		struct page *page, unsigned int new_order);
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
diff --git a/mm/memory.c b/mm/memory.c
index 6675e87eb7dd..4eccdf72a46e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4020,6 +4020,47 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 {
 	BUILD_BUG();
 }
+
+int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order)
+{
+	struct folio *folio = page_folio(page);
+	unsigned int order = mapping_min_folio_order(folio->mapping);
+
+	if (!folio_test_anon(folio) && order == folio_order(folio))
+		return -EINVAL;
+
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
+}
+
+int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	return split_huge_page_to_list_to_order(page, NULL, new_order);
+}
+
+int split_folio_to_list(struct folio *folio, struct list_head *list)
+{
+	unsigned int order = mapping_min_folio_order(folio->mapping);
+
+	if (!folio_test_anon(folio) && order == folio_order(folio))
+		return -EINVAL;
+
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
+}
+
+unsigned int min_order_for_split(struct folio *folio)
+{
+	return split_folio_to_list(folio, NULL);
+}
+
+
+int try_folio_split_to_order(struct folio *folio, struct page *page,
+			     unsigned int new_order)
+{
+	return split_folio_to_list(folio, NULL);
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static bool wp_can_reuse_anon_folio(struct folio *folio,
-- 
2.50.1


