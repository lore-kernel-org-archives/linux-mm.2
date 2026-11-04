Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2819C606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 04:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BAD96B00EF; Tue,  3 Nov 2026 23:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B316B05B1; Tue,  3 Nov 2026 23:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581696B05B2; Tue,  3 Nov 2026 23:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5966B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 23:43:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EF6340652
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:43:43 +0000 (UTC)
X-FDA: 85396193526.02.2661102
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 93CDEA0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:43:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793767421;
	b=ioFEcgv1ZnVKzIC2hmnRROeIwbbPIqsjcE5KKU21eb+l8hVEZNwjbniQ2IAlLhLxJT4Upc
	ywNqGiNUHDd5BbbFV5er6f79p6BL+wPwxBEaHQ36BH95Uga647hhkNyZc4jYiLoi0/O7el
	lKCGZiPpLSmUtlOOW7rPhjM/sbwT3j8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793767421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0XUH0gtcoBkKHqosi+5P+/MTmOyV/YGt88UhPIW631g=;
	b=qvitLl1IG7r7M9VXcRYxTqV1xjB7uaQ05/wxfuy3snVJsYXaz7U/zWtk1xhQHPxb87zGru
	IX34HBWNMptEH5bhgVZ9fhft4g2yb+TefJt/S+adBXm+slLvHEhMiLEuB5Y2ktkjGi+5OY
	/e00XKogqGQygpN888PmNSenf5BGODQ=
X-UUID: 458b71ced80a11f19a56ed5b684f684d-20261104
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3bee2e0e-85ff-4d58-b4e0-87a722846bee,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:3bee2e0e-85ff-4d58-b4e0-87a722846bee,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:405f2c5e7313ce50f402ddafb8778941,BulkI
	D:261104124328VBS4EI1E,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 458b71ced80a11f19a56ed5b684f684d-20261104
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1016848686; Wed, 04 Nov 2026 12:43:25 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	willy@infradead.org,
	shivankg@amd.com,
	ridong.chen@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
Date: Wed,  4 Nov 2026 12:43:12 +0800
Message-ID: <20261104044313.2099309-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: coa78fn3kdigbc5uug4jxfc6jx37765t
X-Rspamd-Queue-Id: 93CDEA0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793767417-814189
X-HE-Meta: U2FsdGVkX1/RUenGfdNhaJaIt3thP3R6ATBNKobqhA/aogSDEMSqzX0neeH/6AJT/yfcsax7/W6UHZLR9EBZUT/H1lbOrs71HN3ZQh+f4Tg/IkjmIt+X0SiK/qRsIGSpMEHBHsfleL0AXMURcMQVxWgpxROUCKdS9EEhCH+fWH1Hz/81gnOoJZj6r/vSeHqMe+zRqyRgGjrCudnu1dkFwZvGV2sLNTTZwLai2+PlfFT8nVAKJfw2qnyIjzkWIMWmgyKM4JGCtsOn1/9VrG6LVWTahWONI6v5psxNs3BoIrknqRELhEHwKiMBqvgyrglHldNGDZye5E4FXwO0Cu2ImjeyEBWhs0UJOUtsXj59FBPVuUV40cSSpXl1bFohWzSjFiJc0PkqXKw2rYop7/RJvGqbz1zFzA5JeYKRs47NN7hDniIBgSIcYa+eDzayxvcK2UIFX4Iu1+/9FGUdOK+0as7LQ4uuYNsgs+KyZq9ixRQMd0m7NYJXmrVLFZFGyfUrxV7izuJRv+qh7tApq4TRJDVdhqGYctQGyPJhIAwN+v+iKUNdy4wWk0Zip7m10WbbOYzHg0QocgROVJUbvlDhsNz3oZKolss4jsdxrSVRhysh/3AAnhlT9lTHYJWaGn9m0lofFgCSbW7bxqRvmxW6eBrAcPET+1pCxHigS3GgD8ZVvasXyU59MVNa7Lcq49R2OyvScxaXq4uJhp0NY5K9bqwPXkT3epWUVM53hXQiPxKLYqkR8GliEc0nVFxWbcpg9mG2jjtg6gtgQk1MQn1H2mQhpKc7cIeBQjRdbSfpZ9g+4ik41kK91Uw6xPVq5R4KClRBBzRAn9m5N+8k3dtkig/7J8I85070JPmpIReV1J8gVOJMyzVWsJgHJ5uICH9ovlHCPQwqX+uXGqzy5D8/3O8+Pql0WTkcbTlnqVNLWEUnp2Lf+8EFE3Vmn1NRjjOgO+hu5CmCQgA4bU1Zjy6
 ZsQlxQsx
 vRu5VC1biqrEK+dGIx2gu/MNWx6g5q3v+C80U/gEu92SubRN5aqUlu/qauBSLa68Lacco/Bp0K53WN9TzDIPoIQxePYzQWwJYxBF/9bK2eOr/Cscrge/fgfgAQCxPjP7kLZ/l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NR_FILE_PAGES lives on both the node and the memcg plane for page
cache folios: filemap_add_folio() and filemap_unaccount_folio() charge
it to the folio's node and memcg, while __swap_cache_add_folio() and
__swap_cache_del_folio() maintain the node plane of NR_FILE_PAGES and
the memcg plane of NR_SWAPCACHE.  A folio in the swap cache therefore
carries no per-memcg NR_FILE_PAGES count: shmem folios drop their
memcg file accounting when swapped out, and anon folios never had any.

The cross-zone arm of __folio_migrate_mapping() moves NR_FILE_PAGES on
both planes unconditionally.  For swapcache folios the memcg plane is
empty, so migrating one misaccounts it: the destination accrues
nr_pages that were never accounted there while the source counter
underflows.  The wrong counts persist until the memcg is destroyed,
but the aggregate in memory.stat stays correct, so the drift is easy
to miss.  NUMA balancing, migratepages, compaction and memory hotplug
can all migrate such folios.

Reproducer, on a 2-node QEMU guest with cgroup v2:

  1. create a cgroup with memory.max = 50M and swap enabled;
  2. memset 128M of anonymous memory in it, so reclaim swaps most of
     it out;
  3. fork to raise the swap entry refcount, then fault the memory
     back in, so the resident folios are swapcache ones;
  4. migrate_pages(pid, node0 -> node1).

"file" row of memory.numa_stat (bytes) after step 4:

                    without this patch      with this patch
                      N0          N1          N0          N1
                     0 (*)  51691520         0           0

  (*) the source counter has gone negative; negative values read as 0.

Keep moving the node plane via mod_node_page_state() and skip only
the empty memcg plane, mirroring the swapcache exclusion the NR_SHMEM
handling in the same block already applies.  It accompanies
commit 4eef27af2932 ("mm/migrate: move NR_FILE_THPS on cross-node migration")
and commit c5eef2e03618 ("mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration").

Fixes: 0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and NR_SHMEM counters")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/migrate.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 28a8d7734735..bc60f6587d1b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -690,8 +690,20 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
-		mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
-		mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
+		/*
+		 * Swapcache folios carry NR_FILE_PAGES on the node plane
+		 * only (their memcg footprint is NR_SWAPCACHE, see
+		 * swap_state.c), so move only the node plane for them.
+		 */
+		if (folio_test_swapcache(folio)) {
+			mod_node_page_state(oldzone->zone_pgdat, NR_FILE_PAGES,
+					    -nr);
+			mod_node_page_state(newzone->zone_pgdat, NR_FILE_PAGES,
+					    nr);
+		} else {
+			mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
+			mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
+		}
 		if (folio_test_swapbacked(folio) && !folio_test_swapcache(folio)) {
 			mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
 			mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
-- 
2.53.0


