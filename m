Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD87C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B08D6B00A1; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5876E6B009F; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1F16B00A1; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF36F6B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89E7E1401F9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:59 +0000 (UTC)
X-FDA: 85213020438.27.E5995A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7ADB54000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FcwlezMF;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406157;
	b=N6dFDbY64BtyiClF5tymjhAX3RLRna972Yqthi06l8L/FCLz5Fyx8uhhUp/1YXG51OA4ut
	ndt9oXPCMlXerrIc0u8NBTAFDlZ6BYk/UGvKSfDMMCTv0q3ps/3UuAHoTG3v90TO99xmxT
	16zSfBNgsNaAKwnAtrL36Jn24LnNtQg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FcwlezMF;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h33mLIdJUFvBnvNoB8qkrVKb0BhGAyjy5EulIXwbiNY=;
	b=fJUgXF33R41hD6eF9eAGtmLBBztscUtO63sWW7rW0vlnDIVzzigNBlHfuVKb/kYwV2Qmwq
	AltfILfv1aoxz29wQjt1gG+T3KT2Q8++UfiT2wD94XZL73S6nawoD8Zd/k0lUVRke8I3Ej
	cO50En4FkzBMkMAd/3fG2hXeJ2nvLO0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5327143EA4;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32150C2BCB8;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=QtZr5PnzpwtK3QMP+hirTKj5BWjg8s77EwEdpYTWNpw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FcwlezMF8xsDt0tIYvhPwruzAp2WOjlDRU5FMG2DvTxwef1Iaw6adY4BkcOlXcdvm
	 d8VYjZ4rBl8uhoasBlJJD3Y8uUKQrsv4RBit/yYjP47hFtl1kaCALsiOtDw15vf9ul
	 LFShhqUSB9nPhALhJ+Y7Y+cm/l/PrexG74Etx56yVCwYFVAn2tp3p2+W26TiqyzXxG
	 xdakkBZ/DbWIdrDZk9uteCnX8SKYU5n8gNY9H7Xy5/iaSDKnWNUJH8swWRT2K6ezrG
	 3wMBGSqiP5yJ3JIAbk4y63ooORdTsiUE050OPNqNmiDMFbd8m+AEQ0KMnRhEO2GFbw
	 LAjIXcvywuAcw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC8DC88E78;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:49 +0800
Subject: [PATCH v5 08/17] mm/huge_memory: move unmap and remap into the
 split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-8-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=3825;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1AepHMPhtQhcirQKIFtuSgKsIjuLHdIJpzp6kOWU4PE=;
 b=lHpDt8hux/TpdAKSrD8AgwYlgPrsCYAm5NsJFwkw3s3EQTUfy23K+R3Bagt1JACVz0WPUWYCl
 mtOhIVUKypvCswC3oDduF78iBvKXj35nfiqHt6wz3f91m+WWyjS1goI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7ADB54000B
X-Stat-Signature: 1me7geojqhcih5gcxscxrj6fupc1j1fw
X-Rspam-User: 
X-HE-Tag: 1789406157-859335
X-HE-Meta: U2FsdGVkX1+8UFdx9ZuZYH07ImdHubJ8aBim7Ev1ycP74SV0FLEqq0ToxjP2Rjw7Qd86rPXuNOJmJk5077QidNe8jVMyWVRGCFZaVurp9fYDUN84wBxBA9wW4jONjeot/WYKHNc1PdLDWMKyE42MHT7Bo1rEL+iPXVfpwQefCUpkTYENAgN1yq3iDEroh95ZzhEWHZFG8tHMCepkR8MT8RV/IBvpZnrJTvDcTFvqDa9UWtCYkbD28GkWICvHF5k/ITnmjIuAn1+MB8cJ10mq3Rt7kFOYC4mORLbNhB7i3MqD11UmspZXrhiIT8zqx+/f30fdsNBlmCaobrVCC4ZVNU2ByGy8JpcK5zjgN4bmlwu8wGQl61Dxvy7MmhIOf1ANrStnoScx2Dznb0+0dZwpgrimN4m9KzuQhQ0/JD9m23wzaltMKRGB3lRokDK3Ud5dH+2dVV600sI3vkdjfFTKBGoFu64xOll/Spt97p91embKw1azlK1GqfioUUfVib6eYaHvd2giH7k2S7C2JLROxZ9AChVsPn3BehtKP3mKnjmeBZkj2FJBhBMlSqTlRbgw26dw9g/U0VJCr1doB0/500DQ6Fhov7zLHKgZ8N6SNlZhu3SzbxjtFBoQo7PlOwGuH+j5+iQe6AaLv8GwZVCzDITKoiEoLFx1IfdFk5UEvZrU99BHdgAo4bvrbvU8OKSeKX0jUoK31sKhPmJhMtJqDbqMKISVRjePeGua/kl0zme6oKkbH6WeptBPMI9LA31n23t3O9jL707DJhjZILBzS8kjagVfjUygQ2Jp+WtSi3Z9fr7HYhA5/vV7RM5nZljvxgU8gZJ6+BwmJszY7X7YP1g+9Z8+uaVGPHJ5la1J26mv1DEpzUrtxooU/adXxAYvskHQns3ytrflD+KZGxEm1p+nx/nXy32zidR8gwTICVtimfcFxth6kSLu6VkFcUxdfVn8syzv3TlaCXQfxk3
 HRT+KEzB
 lymalzoYQl6HvzjycKYl9Zs//wdYzq6ryBwZuhZnHmQRB29C/Sx2uS4H58i+8x1QZpAp9XGkpKgzOyCoG9MHETRj+xMA6L6fw98a5+7ZqfPcJvFEmnEmGFqJl0WOXR2RGdV0bdehc/4qd9zp66R9543gGU+4F6nfRaGLd4/ZYLkSSqEwHS2JAagXabDfdsdZfZU5xELrWPl0IFdXeO3PNiGQXspy6DdYRjO21N3DdpJ4h6KTTnXWxJOfKA2O3MbVBpgHRuh0Tr+n6wnpkWBC5rtOgsbVAzypMaxFsbS4jK9vmyoRLf/zOczyhUM2bklF9y2I7o4DVdVL6s0L0Y7Q3L4Cg6/7lRyt7KTttVH2kQSxVJTgf4YMVtH3ZkY7RD700UsNYDfRj8Ed3uLfU5o6sd34x+4fIaVmuJ7SXfWYM8pYIzpNEqOr3z0sZfkx8IoO/lHd0zsnh8j0BzspCrCBHklGPN9RaywyS2I4xe1PYaVw1iGtFSlVya2Kj2mNl6mfqGZaG9ugoWQUizBDAm6PPLWJ7ew9rU+PxoU3hODUZqgtAqvPRr0zuJytxfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for further cleanup, move the unmap/remap handling from
__folio_split() into the split helpers.  Only anon folios need to
be remapped, so remap_page() is now only called for anon splits and
the anon check in remap_page() is redundant and can be removed.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5ba3bcdfc42d..1749905ade6a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3641,9 +3641,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -4017,15 +4014,23 @@ static int __folio_freeze_split_anon(struct folio *folio,
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
+	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
+	enum ttu_flags ttu_flags = 0;
 	struct lruvec *lruvec;
+	bool need_remap = false;
 	int ret = 0;
 
+	if (folio_mapped(folio)) {
+		need_remap = true;
+		unmap_folio(folio);
+	}
+
 	local_irq_disable();
 
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
@@ -4074,7 +4079,13 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (need_remap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
@@ -4106,6 +4117,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4190,8 +4203,11 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-
 fail:
+	/*
+	 * If we want to use try_to_migrate() on file in unmap_folio,
+	 * remember to add remap_page() and adapt it.
+	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4231,7 +4247,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4319,8 +4334,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4328,11 +4341,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so

-- 
2.55.0



