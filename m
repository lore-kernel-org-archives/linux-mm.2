Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE6DC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F75F6B00A3; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783886B00A9; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539CD6B00A3; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3F26B00A4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 192F6801D7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:16:00 +0000 (UTC)
X-FDA: 85213020480.22.D07EF21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18B6A18000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ispodhHp;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406158;
	b=4BscyH7pvr2dhkm7asuk2Zppn4c44qaSwPjizfom4F1L/a/yPLMgTjM1CaoRC/odSuRE2C
	e/BfKtO2z9vTXxqt6E25eSjEg6Ng7FOqLebPuUzzHAzTh+syIcnRkQjDdBo0ZlJNKt8InO
	Dla/QI//JbTzZzSKvsrff8hES/tlmgU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ispodhHp;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MELiKJKdRU+8/iODCXCiPRsTZxdlkO9aT2e+UrPVY8=;
	b=TWoLf4hh68Eac4SDVydE4D3nFzJKldjmBOiq4ghN+L/fnKncWfjNGOsWjYY3NTM6pB+5us
	We2b1/87C6ObylhqrXBGFt4hsKx/IQSWbDW8NhACJx4NN/iFUZvIGDD1+jSWPnnIRFy9Te
	idMBjF9e/9AFrGuJi9/8rpzexD0yj4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF36843F04;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0517C2BCFC;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=5CNc4rR/d/ayE3OXIw+55X5cvbIF2S13xm4vRPvnuRg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ispodhHpTVtBhqvKEMp/TbPogA/+Xfn99xJR+fwHUZnrb+D5bDBASkB0PKdwxHNGv
	 0Q5qzzcEhjqcndZUxfGwiXeyTuTuPygnQSDNme1GdLe6j/OWK2W/GgkYUDURItxtqi
	 zzOrAjJ4HHCdQic36R8sjsjpBpw1lBglKCqRD7qGIxDetiyUDLxkLNmg0zvLJ06uiR
	 NvAweatRntvDtQQG4mpZQbpp36dS06wDG4OqZAMBWSSiwNT1bVZ2jv2+Q1FFF/kFTb
	 9V8FATxGiGy3M81jDpsyjxHSlYQcCwODu6+eayGwchR6Iddtzsv6MisHoi4beJsjTP
	 zUo/XgR8+uFKg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F00EC88E72;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:53 +0800
Subject: [PATCH v5 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-12-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=5796;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bKr9eovHFefL9hi9tubKoHjBzPEs3edNnMMyZanSRW8=;
 b=C0vUEdDIAdaS6RGWbkKTPC9cha7NRzG4/Bvy54IXTYpY+Hw2UGkCwgHGGoLCRywIxUbOdKKED
 si1gFwiTiOADbx/CvUmVkZO0GnOz/+4TJgFoko/hoQcUhJJfaCbJf63
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18B6A18000D
X-Stat-Signature: ebnsoutgpf4bwdnpc95iyuqqa988fame
X-HE-Tag: 1789406157-429274
X-HE-Meta: U2FsdGVkX1/j2rZganF7T2RSmh0HqF+XkVMZv5ROQbc1QeBd/led/H/bYJt38L2+amOiU2prGrS8UNAv8Ym0d2SCjJBeaCEw0bIT/rkn8Giu4j/zFGHPOoNgKoEPfRxkdKG77fM9LcpH4mqVdlWYYoaQwsADyt2CKKTEzSZI7Fa9eSqfZU21wLMIqPdxvSXQsTN3oha79WOICUYYRMd5CpCqaTuRfAfOKJrBtSBJNivnHy7yLZO+q66/xucn2sqZDkMCEcFbSCYXXDDLLMx1QPdT7GnCnNa70OcHAueI461NOrEB8sMOtyknHrlrb+Gm5QHhhJg4Q5ZpoiFK2MQHWZQ6Cb+qA3KGRvkoqAVjwFx6hORBQSuCmqsTVOzhEX0uUBu2dkHZ7SUSDcaTHMG9/2yoMM0TWW5HwkYzY4SNqab7G6o8Vp2rSPoUvFDlRIBkYsq3b6+D+nN3utSBVMrHTVf2A/VVr6DUv0A1ruizro9Nxee9cvK6WuH8XKP4lvNP6UAlBWhwYwCMGbRXTAGMv1f9m++FUS5KVPO47mKIKvsqiukW08O/2MYaI3vQ8eVBC4xWJjNBv0aTVoCdsyIjb8WcszKKNtctFJGmSbVoFxgKiKABKR1wgWmoIIWZtkEc93QSLiJe96z9xE8W4Tzqlkuib7Yva3q4EmCyJ2RJ7UwUv9eaQs/yZjr47DxYQquY1+n4ZPvx0KSFxEM+mG154VkyF3HLyAJh3UDWxRsO9n2pzmBzDFUB02aW4xgq2QzO0E+rxfOHGM0YBgTM1/PwmY44cq3wd17/CJ0riIpyJbh5nLiV6IQ9RTlbPoo1EOnbTDd5SIrYVvZRbDOgy/vhn4/+2j6jAHSpftOnd5QR/T0xwogopggRwCtWxmbxwxQpzicHdw99apSFmbVmBOTJfySVfCqzl3F/GtM39yszJT5bcpogRmC8RXGc8kQ9CCNNVeNXPH/rig8gPPSt03t
 jQNy87TA
 hgXFVakWBdf215m/TXKUxb/MI4BVh8irtT9u/95+KYGi0TMlUfTwFyk+kOcutck9v78GNglNo1s/feAU5XqT9shrAwaJJ88nSd+BqVvMZtZmvAKh1QdiLjgDKYC6VVmnaoYrbxG0OimuuFi+HVgipyX9pZFkmznMHucLaz1QIF+otfU/hp13KUlMXaQY2ZSpK/e6hXbVJaql4CFK4JSc6NHkpGASM+xk83uvWxg6pN0VV8B8r/N/E/t0at5Nkv57wh5jJ5Ik6n8k1SZbFUI8fUC35cVhjxUYQREYdIdruqNxauyFMMi7PYvtT9VEC/LJ3xBvtGtrcT4X1uzFmJefZ9FCGyfM4jEVkXc4cJCSinP93KrrTJ2nRnZnGnWD50Z628dHJNeAhrtuJTdZyOSltJYO5r1pemd0C8F1N3IS1WK0j9u8566FshxPPTz8alC19Z6QcM89DFTjpoljB4nayayxCuWJNd5aGUJYH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only anon split needs the anon_vma, and it only needs it to unmap and
remap.  Move the folio_get_anon_vma()/anon_vma_lock_write() pair out of
__folio_split() into the anon helper next to the folio_mapped()
check that already gates unmap_folio().

This makes the anon_vma conditional on folio_mapped(), which is a
behaviour change but should be fine.  folio_get_anon_vma() returns
NULL whenever !folio_mapped(), so an anon folio with
folio_mapcount() == 0 used to get -EBUSY from split_huge_page() and is
now split instead.  A realistic case is a THP that has been fully
swapped out and is still in the swap cache: swap PTEs do not contribute
mapcount, so it is !folio_mapped() but still alive.

That should be safe and right to have because:

- folio_ref_freeze() below still rejects a folio that picked up any
  reference, a mapping or a GUP pin, in the meantime.

- A parallel split is excluded by the folio lock.  The anon_vma
  write lock was added to serialize split in commit 062f1af2170a
  ("mm: thp: acquire the anon_vma rwsem for write during split"), when
  split_huge_page() did not hold the folio lock throughout. commit
  e9b61f19858a ("thp: reintroduce split_huge_page()") later made the
  folio lock a caller requirement and added the folio_ref_freeze()
  scheme, so that has been covered ever since.

- Unmapped path is already exercised by folio_split_unmapped(),
  and the swap cache split already runs well for a partially
  swapped-out mapped THP.

- A !folio_mapped() folio cannot become mapped meanwhile: mapping it
  requires the folio lock.

For mapped folios the anon_vma write lock is now released before
__folio_split() unlocks the after-split sub-folios, where previously it
was held across that loop; that window is harmless as the sub-folios
stay folio-locked and referenced until it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8fc1dd5b8354..a4c2e38f4a6d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4029,16 +4029,38 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct swap_cluster_info *ci = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	struct anon_vma *anon_vma = NULL;
 	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
-	bool need_remap = false;
 	int ret = 0;
 
+	/*
+	 * Unmap/remap needs the anon_vma, so we first take a reference on
+	 * it to prevent it from disappearing, and lock it for write here,
+	 * letting unmap_folio() walk the rmap with TTU_RMAP_LOCKED.
+	 *
+	 * folio_mapped() is not stable here, but it can only change in
+	 * one direction while the folio is locked. The mapcount can drop
+	 * to zero at any time, zap_pte_range() takes no folio lock. It
+	 * cannot go up: swapin, migration and uffd move all lock the folio
+	 * before mapping it, and fork only copies PTEs that already exist.
+	 *
+	 * So if we see the folio mapped, the worst case is an empty rmap
+	 * walk. If we see it unmapped, it stays unmapped and needs neither
+	 * the reference nor the lock. Anything else needs a reference
+	 * first and folio_ref_freeze() below catches it.
+	 *
+	 * Note a swapped-out THP counts as unmapped here as swap PTEs do
+	 * not contribute mapcount, and they are splittable.
+	 */
 	if (folio_mapped(folio)) {
-		need_remap = true;
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma)
+			return -EBUSY;
+		anon_vma_lock_write(anon_vma);
 		ret = unmap_folio(folio);
 		if (ret)
-			return ret;
+			goto out_unlock;
 	}
 
 	local_irq_disable();
@@ -4096,11 +4118,16 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		swap_cluster_unlock(ci);
 out_no_split:
 	local_irq_enable();
-	if (need_remap) {
+	if (anon_vma) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
+out_unlock:
+	if (anon_vma) {
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
 
 	return ret;
 }
@@ -4295,7 +4322,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4326,23 +4352,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
-	if (is_anon) {
-		/*
-		 * The caller does not necessarily hold an mmap_lock that would
-		 * prevent the anon_vma disappearing so we first we take a
-		 * reference to it and then lock the anon_vma for write. This
-		 * is similar to folio_lock_anon_vma_read except the write lock
-		 * is taken to serialise against parallel split or collapse
-		 * operations.
-		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
-		}
-		anon_vma_lock_write(anon_vma);
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4369,11 +4378,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-	if (anon_vma) {
-		anon_vma_unlock_write(anon_vma);
-		put_anon_vma(anon_vma);
-	}
-out:
 	/* restore to caller's old_memcg */
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);

-- 
2.55.0



