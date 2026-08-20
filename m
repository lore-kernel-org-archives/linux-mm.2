Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBDCC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA3C6B00A5; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1BC6B00A2; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC4C6B00A9; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 289956B00A3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA88A1C0B4F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:33 +0000 (UTC)
X-FDA: 85122551346.18.7683A40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A187C40008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PI9zKvos;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TDVGp08Z6qbZIImfOQyxLrL8TIC8c0iZwNwogz2CTc=;
	b=t26FGjT5r7DjnwkKhISw7pGTMe7LrzAp9utBjyDvozp/8Z6NLHGyiqvLbs/8p8F/FVBWtM
	mAsGXXKe3Ge79avZcUTV43OdlBo8m4exMxatlWXc3GZIjqIuHfCVO8PTmKez4ueKTPQZaW
	1GepRDFW7vDfi230FtqnrjbtL2MQGwQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PI9zKvos;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252131;
	b=4PLeIDamXiOVzkWrBlekYGy94PrPZ4YEyv2ZLlAIY1QM82M4CI+WMuNcQmHIm+aTkILGlm
	4AxaQ6LweFSoqVMplDsLmJ8qi1/SN54chC3hlVdPyvrcGMNuYE6oaC4LsDxb+IvxtAzomh
	RdmGEk/x8KiLQdeS3UuTfeTRWknjlbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 458C344004;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25F65C4AF09;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252129;
	bh=ZGYahGpoGxsINHOEPB5yESjNQzFn4mBfE6UUR+TK7y8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PI9zKvoskMF9NrHX23aF668zBezcnpW7iL3COEjFXLmSmcE9GrKWJYN/4VYglgF+G
	 a4SBaA0g2d4MKsoMZDtq3OwM4K71lT6wqvT9LQfBRgw7PGONpwyjXUlAO5ZsCKkky8
	 9PQv8ofbbd05AgYZqZqsW1GcATD/5MZBOQcdLLi6E+ZmOYsHdn8i9HrBzz09pO/FrW
	 3CzJiM0AtInGMxFjC3l7WvLFvWxeoe8gpBeYS+AQrC5WSLpksSDyU8npCegGwAwdvK
	 WCfMW9BgwatAKQsgyvln6y6Pk9XU2fPc1BLJE3iciZF/g3GGXE3WjKHKE8+0EGQkAh
	 R84pbu5qBdJ/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0991BC5DF86;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:23 +0800
Subject: [PATCH v3 10/18] mm/huge_memory: move memcg switch into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-10-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=3647;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=eMTqZ8JIOYum5cAAc6MT1lBInID0tKW7zfeYCZgfWVU=;
 b=zneDwfPqwi5R0lmrW6mAO6on1uogPVfixDYLlJBBggg3F+EzpANQSbBxWQBUQSwVBYf61f9bQ
 MEJXBQyjKOwDDrFoG9CIGwod6RCEMf2u+8RLgw5g3/JV3aGig26VYWq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 3yicwyqnzqj6dmfusqpe3ym4iwnfjjyw
X-Rspamd-Queue-Id: A187C40008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787252131-793438
X-HE-Meta: U2FsdGVkX1+jKLYnh1j3i5czECbn6rTXLiywGOOe+c18KcnniPNmQ0ne6W4bupYEsu7kJhy2iP1yVNg1f9cA8p6M1+QPrRZWcpZBbOqsT1kow7RqxWNBruhHrTfmsdp+Ndl6opZsMgooBXJHMLupI1+2QmeeE1kNGRd3qp/OZW90nlOkOYtq7DKQunRmOjgGcc1O3N1Kpmm6IULkx0xfMW2EmQKGdDcQjShEPi6p2j8Sja3NtcJPizZ8qNXBEhOdiz6ej7820hcXN1ctDNVW999uE3IMUKp1PsSOIOgwU1oE9q6bts+g/8fuhOKAXEexf9wuSRdhDAtROMtOaW/CNeiwPs51VT8z+H8zqRQWFPBD3KtrAT2YhvAwu6yJ2FHrJzQZmWujsyTizYtPOw1fMjzl0BeJ3d4TUGrmq1Ntd4ZYVIh6OTM3zF+Rxfv5xhPVj32eNigc2CZamFRvWDPE8eF3DL+5WFrslifetbsW9PefVdppKrTQR+MQiFfQ/d6wPfdd4fvJFcpC7bf5VaE26GsKEhHZazENTUG9BAqqMtIoVAwhTePkLyjJCWNKKTl3SwxbFGH5zHstW0c31BAkTDVSmhLYm0aspTsAG9izEuxqN2tdWu9AMClQHtZmLxm6Y+oKvUkVb/xlGQK9qNDyG+xzym6xkViwP4PkAFiifhT70D/NLBXq70Zxq+r89RsSSHt6HOCoPl4gX1Zdor4PuBWJUuspu0j7JZFPXQdoqTl6E+GjrRlJcHjixGsrnRYGWSWxJQRgVrAHRukmATBZl3JZpmroSAJDnTVk4iXj2LsP8LYEEyLMpau/L9s8bdDU3HhAU4ed1h1n09K7N0CiFkuBypUQ7O4WRAQNY3lRF2rS7US3CmlnXDwW7yp5KzmeDpqGW8YOr/bwWLb12nvpuU9C1vaD5gAMliCP50ojlSnj57N4YP1DWPjAbgbs1so8+ne4BKBKyy0N4kJgchB
 wdz9wiB1
 HMb8QorOVGNN7G4wnHB3mz0/QX65CW3yrRUA+pnYAzZQ0folIkdqlmwCHIRlDg9YcF0BvTTFl4HZTaMlPoYTViuqerOp7GqRe8POaDNyIzD1SpngtbQNWV2HbVlkVS8k/YlPHwyFPxrxz85QDnmJ4TpnqGDF3Z/dtgKvalNu4F/JEFUGYAjKgQMfds09YsdKUI9aVoIMSKSggsbMoCERQLfJfJKeUtX336cT3rOOeFxvztDO06fhsdA7bziPNpvYw22cUgGHQTIeUPcaTbbSS8gINsLfR5MZ4uVbi7hwe5TkLbkgvhYhMstD0LaJgiZ9H8tDpGTwVohf0VUuERZMFepUPALgfcMhOzkn/xSOAyqjg1zFXrqI/R4DuC/IOBauBlpKhdesilx43AKda7O+dmIkH+4A05IK4XmnWJwI7p8qzSKPgOHY9ecDyqLfqzDmgMP4YWTMh0Ls4PdfcmX0dtKRl0NpjqINj3COO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The xarray node allocations in __folio_freeze_split_unmap_file() need
to be charged to the folio's memcg, so move the memcg switch from
__folio_split() into the helper.

The anon split helper and the after-split folio freeing perform no
chargeable allocations, so no memcg handling is left in __folio_split().
Rename its out_no_memcg label to out.

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1ee312cbd438..3029cb1f07f3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4066,6 +4066,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4078,9 +4079,18 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	if (new_order < min_order)
 		return -EINVAL;
 
+	/*
+	 * Switch to folio's memcg as xarray node allocation can happen and
+	 * needs to charge to it.
+	 */
+	memcg = get_mem_cgroup_from_folio(folio);
+	old_memcg = set_active_memcg(memcg);
+
 	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
-	if (!filemap_release_folio(folio, gfp))
-		return -EBUSY;
+	if (!filemap_release_folio(folio, gfp)) {
+		ret = -EBUSY;
+		goto fail_free;
+	}
 
 	mapping_set_update(&xas, mapping);
 
@@ -4217,6 +4227,9 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4248,7 +4261,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4258,27 +4270,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
 		ret = -EINVAL;
-		goto out_no_memcg;
+		goto out;
 	}
 
 	if (new_order >= old_order) {
 		ret = -EINVAL;
-		goto out_no_memcg;
+		goto out;
 	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		goto out_no_memcg;
+		goto out;
 	}
 
-	/*
-	 * switch to folio's memcg as xarray node allocation can happen and
-	 * needs to charge to it.
-	 */
-	memcg = get_mem_cgroup_from_folio(folio);
-	old_memcg = set_active_memcg(memcg);
-
 	if (is_anon)
 		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
 							  true, list, split_type);
@@ -4305,10 +4310,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-	/* restore to caller's old_memcg */
-	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
-out_no_memcg:
+out:
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);

-- 
2.55.0



