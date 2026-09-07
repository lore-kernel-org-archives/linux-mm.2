Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 648CDC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5866B0093; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEBB6B0095; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBAB6B0096; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 398C16B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B4601A0274
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:18 +0000 (UTC)
X-FDA: 85187760756.20.3FBAE9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 942EA40009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vnsvxr1l;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804736;
	b=55g2TtZGRw9LDTi9OSqRKdJCEx8Kgo0hoKNJIlRWGmYJiRb031R11wNWioiLDaWtCYDtja
	Q0TqAFRXFYkrkKWPPtbXuPgQCGbe2bQZGlis6gdP6oFb3wGwAlXcx+67Qpu0ooXaBLYLsO
	285zmSKBSUUn1FNanr4B8saPgu3JU4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vnsvxr1l;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804736;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QsZevCPCMuYXEsgQ1n7vkTXaeQ08iPoWoPIgD9fZ4I=;
	b=bguMSqBgE+utMioSdFnFceIp5LBPQcjjsUiKiM6nu3t1kFWwLh8QJ3025AxnLvsUsxj+4z
	Gnta6UCsbK4gFdgEuR8zBSzcwISP1g73Tlz+/mcmuXxw0iUKBL4Pt+pLxKLN4FybGcppv0
	LlVdh3CWqbAD942QSd6MADm5KnTsjwM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B97ED44084;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AB93C2BCC7;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804735;
	bh=IDfifzVDX7G7viE/LmtLdKn2cI+UIgXIHfXd8smD3lY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Vnsvxr1lDgoBQYmwSW7VmkoH0LieQf/XuGfeoZD+IFvPZdguA4vmaBSM2MAoRfpJ0
	 OkbelQ3BCm8a6BHNv7ltdRq6Y1M0ovxrjBx3TItHcx5TZ36t6wetsdKJglF2AyAAHj
	 ZJmIZuyxCwKROjJyqt+hPAMbz/+dv2FZ55GPy2LGgZRF+/O5PcvnLkYR7NcBxDItww
	 VTcmH2A9psbf18Sxb32BdJFh5TZ4zpScwzMEl+FnJ6BGOjtemdaU+KQ4UbB9jmMLTo
	 gM81XRkUSVSu0gBLhRHtlNDAVrZ9vqGDgweoeZ0h/oKOxjwZF20wMe4kd3mVamYW5U
	 XYuY6BKT2mTIw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8335BC79FA0;
	Mon,  7 Sep 2026 18:12:15 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:06 +0800
Subject: [PATCH v4 02/17] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-2-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=3844;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aGhq09lUEoI1Oa1/if3OnIL3d1mjAB+qZOuhjPWgUVU=;
 b=IgkPvdneM1y3bgJTUhiPdjWb48wjKoHlWdkkNqF1r1wiKRZLuWU65Kn4eAoRSqeHKKSeBqVUp
 ryz8vdoT1UgBpwk0feG2osMiY5KNHAXA14oC2JxPFUuaJPHtJSKWAGs
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 942EA40009
X-Stat-Signature: uxpi6jzsti4ktxmu3qyyhmrputx7by7r
X-HE-Tag: 1788804736-440743
X-HE-Meta: U2FsdGVkX18YUsYh+K26LlA4vimM4dJtDfeHUVaycdN4RtS2xI1vDdutEZHvCN10loBgeO4JEyaqcrfNZwLtGUSE4G0XEF2IxNIoY0C/dXVWsNztc/nUesRCXokOYubS/y5d086jYCrMkYjF7N+UQir+T4DpfRwCh6zHB9c64EJ+Da/+8BSPejwpF2G9kATQtl9mXirkCsE1pD1JovIYD0mFfA9E+uBTvHoEwRgkYlFbXg0e9FcQycP8sUSEe9S6XWkrXT4QTCzrHd6fQKSbiCmEl2GjqzdAbgUTJJrY1A5vr+hYOa1kwcAzUrieyzbTxjIf2H8DtcU/MNEECEsgDfPBDhlVUH57b5hNKjMejz1l8I4JPGsz0bZ5vlqiUf6f5ev8LZkE+1qd0x0opQEygNZ84j5fZ4Iv3CwQDFtf5tTgiTHl1H2PBirDpZouxmagfHDfrmfgQa/QT4/PWhkaWjO2s0cf06GydIVvp5owvISrkc5d+bajDSzmI6VHyedfTf8HH3yVtxG8WZU/rdOn1bEk++i9uZtYkiMcD5dOrjvepLkd8XgeO6pywyVvDAC9uCgISr+OaqDJ9n7KbT43FEl/uCOzWy/yO3owm65j1zuOXIXhH4A0rj3BWxn63xnjhiSeDc+J5PyZS3FuFuQaxEvEk2N2jRyLr9ZksQ6IvovqeO9Ppp5kzexz0vrRQsnF1MzoKLx1G18O/Eivp2aD3hZ5MnO/U81xE9LwP4zLgiRoYQJHoIfUmHrPXTikoYaL+IgJoikAcHyhKeEiWkv9z0ZLbcs1G2iripkxwJMxxK4lDHDaPvtDOP0gc5IJcPVmKxOLTLw1tAxkyQM0lBGQzrRkcTsMgdivN4kFhbRgO3RuOPxPEO5Jaho2dAKU0+gbzM7ckT33DECvK3ahcBMYL4tDuJsg3uTVk/OeAxaMuZ+gmWAihzNi2cFG1j2D1gDz3cfRIY6dke9INm0cCqK
 zUwzlA/i
 rKEfZ3/LJMQGRauMkgvp8gE1F78ye17bOZrqMyKHZ2GPKwk82rP85bYmarraTRKGV+NjWY+Fsv/9LYnsenYY7BiwY9OdfESTv1bf7GuktgU8t3bMSQtocTHn6Voeg8UCNDG3ASPIdBRPEi7w6QN8brjYcnvAebkZk1AmnmrUjwFh0MqndIg1ELC76//QRHKR98t3DZ4phS81xGWFPMANKma71rJw9eYDUb+5zjNnzRBVGiiAYHHAYLZ9hOMxgA+4B8Vh/beTJfIMankZB1GPJO3rt8cLEZhFsrT1EZMG9gHKY02CoshzZHISpGv1bCS+s5d0xwv7Q4ka8TmUbu1HNKuimPC7Em/6/aWXrx/2O1nLP3bQbzUbGxknpNd5Z68KnhGnL9NmBpaVk5PI1jLETtbqp9qFHKmqYyL0PU7RnjTkkdHNi1/RzRuzz3UnQyHQ/crXAquLjE9kEB23JVOHI/U7uTZXbVefjXvgWEPj3tvYO9kIQAwmAXEWhChaWs8ePApl30P34O9jKh3n4WqbWmYozOMT+5SsAkLK9wfCV/9gED5jVCUaFNeWmyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A folio in the swap cache cannot be split if it has a mapping (shmem).
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen
and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
rejects the split and returns -EINVAL without unfreezing the folio or
restoring the counters.

That error path is buggy, if it is ever taken. It leaves the folio
frozen and stuck, skews the counters, and fires the
VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.

Check for this case up front in folio_check_splittable and return
-EBUSY before any state is modified, so the split routine always backs
out cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining
about.

Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dd66c6ad5af1..09cf40357557 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3929,6 +3929,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	const bool is_anon = folio_test_anon(folio);
+	const bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3937,11 +3940,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3952,7 +3955,7 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
 
 	if (is_huge_zero_folio(folio))
@@ -3961,6 +3964,15 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -4019,14 +4031,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)

-- 
2.55.0



