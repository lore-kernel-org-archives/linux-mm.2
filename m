Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE359C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8491B6B00AE; Fri,  7 Aug 2026 17:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1266B00B0; Fri,  7 Aug 2026 17:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 672746B00B2; Fri,  7 Aug 2026 17:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 386E76B00AE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85F3F801BB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:56 +0000 (UTC)
X-FDA: 85075735752.27.4005302
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82D19140007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUKih9pt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137474;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFtvTL9qzzK/FusvnzDJBx/0j1nzvS6Cd1yBvKog7FQ=;
	b=w14yc9yPZtrF4BRhzHDnjF9oCz0XmiR3XP60QhJg3GUg5WWiyrz1iup8ffEW00+ZtECZtS
	x1q0j1SyULBQX+9tMjUrZvTBDUglNo4x/41iX5L35KKsaZJgPQLIjeiN/arAzxCJCXc/LT
	iDEHcfX4mwPSI4ExdMdkINWvGwl13Mk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUKih9pt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137474;
	b=oNzaYf8beqbFFvJgQ7GqcCmHdYfq0Ec6sHaL1v2P/LXr5ngQVAPuluCfXJTaE52WGxqHK7
	+hjyNo3eoU9zuNHLIxOmTh7IS/Zdy6sde74F1IDsSfinielrcg8EeB4Zbl32OQuyxEnK0u
	PxPqkXJUb0q+AcTV0xAgKy5bLyBVF3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC75A44FA3;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EAF3C19425;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=wdQnGoGIB9o4VEZAXvUmfNak2doCNqndMD3WezFuI88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eUKih9ptdiudblkV8V+3RVkR3OewHsd5hg1v2hdCthshCJ5LsR21pApOTFbGqeXFK
	 phaOC0Mfm4bilR+bSRMqbImDlYNYVYVae1PrZkCIP25F2rl/cK2WIoLsw0bV3Ys8W1
	 u4iVjMXlwDKP1BcQlz3oKLzLTc82aVwBZnj3xYMxtho1HYhqpdrR5IAnM01a/Wsrd+
	 XwfPSmfxhIQnvxxzdK5Z0iKeuH4gRKt4P2iHNuyB15J4+7K8P+05Tw51dsnnk3tz66
	 BJ6BzWy++phWTutZ7LbgkF6C6IKqIi3qyEo+iSsckJU5nggZSJovugjkURc7raTWre
	 LGFeVT5vpgjcQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C21CC5ACD1;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:14 +0800
Subject: [PATCH RFC 13/13] mm/huge_memory: count only swap cache refs in
 anon folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-13-689939a7ccc3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=4434;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=6txV4z9147MCY3v3Y112JpwmGarss54hNdYDLN2lhpw=;
 b=XXdvVVkJnsuSqgAphHl1AuGTvhydbgaE1nQ6pBzl6XSvLM9/V7veYYRMKGOANAqlaGxgJnV1b
 LerXbuHpQtTB/9FMV3d50V87DM7K2D5+CgItBEfmSefWnMWMgXfF5CV
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: k33wn84peqxz3h18zipx8486kix4qmjq
X-Rspamd-Queue-Id: 82D19140007
X-HE-Tag: 1786137474-602989
X-HE-Meta: U2FsdGVkX1+VfzXxsSWiRDt4DubQmcaUmJbP74DcpDn0ecEReB2vu0KzvRcQR0VXJTVtgGNxz4UziZZ3n3kB4LRFhPuOzlPK727hfoHpfl78M2+w6PnvkEI7PTtktoLj6CFKFdafeaWsJyk1FsCbwV471cxBTEQiueNXcOWO+XFenHgopWpBXisv9hz6n39YAdjvGFFOT0N75/EwgsyAFhQIDIWm5qNnIfMs2MJNi/DZFLf1y7W6jwibwf+iKULv5VJc7aJJ2Nb8CPa6vjWwuqG1eMEg9x8IGHMoVm2ZBPB4emAvqXWVk8QDzuJ8MVibj3+Se7EnNy61/UUBk2eoviAcwx5A7fizhT+VJX88+9DqdQzbfS5XO7WdjUJnmMw+fVMVxzknrdrplbpItQjOOoZuMBM6kRWcFc2NLUkah84AgrI0jOm5AzdBOilW9UwZz9P/HbGMFeTSyr+3WTz+tL2Nz3I3lOTIWkOiKzyg/h+KqcajlLjY2w8XELMj+ee8xqi4klT57xLlwlIzKAuK3wWysHbqwhrxylYchZHTWhhUalLgfWhsB8VxZnJAmIcKciUA0xrSYOGXuGN/amgvufJseuRijp/NaugOX1A4RPrm1obFoh6qvvIuS0yDxNPL77hVVFFhP9ftTaJ59gzM/kQhE84DxQTMufne8BmDDoZmIwzV/68mROlCe199FdjJWRu/4OoTfZvi4/V0xxv2eOVM8AX4MzupV5J3KlnHe5AN6ysqBqvIxzrrypefwDBKng+LjCfFz8oSPFAcdamxWD6XoCDDM0YqSHkelqQyLZv3AZ8DduLhPv3it+GEeUCsf3dzoMU1s6Yi30MhcSUAl2tD6dILiEHo0TBOzXKnVGiSrejYYa79C5g+LkrVEt5SLqmE24e1VDKWfqjr/cxLVo9BBLLkhhlZvab2qu+QinsIIr61uTulIBy53ZEFr1FpD8uvLScGZjNJeL7wax+
 gBESLpu2
 4kSMg8gJMn8oDqi60s0iSWq2JkCLgwlrHfSoKfX9qNMcYIkTOPK5XeGpAUk/+CfNXWsm6qo8Q+7CXp2YkZO3RHg+dRKK/8YwmlNWTPwQv/IGEBGVVLu0J6vmps+3gyF8iiY1HtROQtv8llUAo5Fxnj5Cy0gAYwnDmAZuIRjnfr0VL2W+wJe9mwl2LskZ3zseKFoP6Bqejhy0QXB3STK4sQx+yCjOKAx95iePI8pItyO02KAjttZ92R+XnRwrn+WcRP7qlT00oIGKaI+8a7OBNOn0rtzAlh10R23ZwMgrA1JnSM0fsE7UMXAatIaf0Bc66etxw+K2+pyGXlrIZ9lqvVG85XPNDsow/B9+hp99K6X9v5ZvrGDY42Vkyyjuum7mEcQ3+z+e4n4WEzYFgIbZEqQU9NtqX/1GmUwy+yCIx+GfZqhNUfcT3lVkdt4uhS26jluAxAw43NAW75L8=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dba53fbb93a8..0d70ee3017c4 100644
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
@@ -3984,7 +3984,7 @@ static int __folio_freeze_split_unmap(struct folio *folio, unsigned int new_orde
 				    folio_nid(folio), &memcg);
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		if (dequeue_deferred) {
 			list_lru_unlock(lru);
 			rcu_read_unlock();
@@ -4027,7 +4027,7 @@ static int __folio_freeze_split_unmap(struct folio *folio, unsigned int new_orde
 	     new_folio = folio_next(new_folio)) {
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4035,7 +4035,7 @@ static int __folio_freeze_split_unmap(struct folio *folio, unsigned int new_orde
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4064,6 +4064,7 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4135,22 +4136,16 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
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
@@ -4175,7 +4170,7 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
@@ -4203,7 +4198,7 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);

-- 
2.55.0



