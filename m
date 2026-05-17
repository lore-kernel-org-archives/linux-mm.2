Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D0CCD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1202A6B0098; Sun, 17 May 2026 11:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031546B0099; Sun, 17 May 2026 11:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78576B0098; Sun, 17 May 2026 11:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EBBB6B0092
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 277411C1220
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
X-FDA: 84777322224.23.5149F98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1EEE680002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOPlDJuG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DizocAnPYSLVxWcNU7KP1hpaTp+dzyT2+Pf/yufTr+8=;
	b=MYt9ZEA/WVl7SfUqObVUsA+YXi/oKq8RdAWTafD9wO89NYOhsuGf1BCUFJ3p/C/XcW08az
	xlxX0W13GZ5DtZltt0TjVuHLq+3PNWTsZZQvYFRaey7mlgssdkgUQaGRy3wM60ugj/rg03
	prQVHrpxcYwTrR7At0nIG+m/3/unxh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032390; a=rsa-sha256;
	cv=none;
	b=nTX9aOWwQFPCtbY5NZiQwpwW+8JDQPaMV3ZHw2pUotAV3tscYiXBhjcXNZtFOpg2ST2nyr
	dIpPOHhLrgNejY23bytCf0q/xWJtcV47zMYR3G9Z/cqNuGZayr2tRH54FIMS9To3g0GOEz
	vMfBdMcMtC6j4inmt5z0UU58L7ID2fI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EOPlDJuG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEED1445D1;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAA8AC2BCB8;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032388;
	bh=fxPLjjzwJE4NXFx7tLD197c2NXECqvzlGTxAHCYE6GU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EOPlDJuGeeEyDz0OW/9Q91adKgWYZWC1OXt7zQvfyDsT36rt/bnGAXo7D4LSpQbFu
	 fu96b/dC7zAP12ChyZwJtok7lZgv0ZymZubi58KZy05gnOQ1KNemihF8Ce/cEmD4fd
	 7LXdoETeG4qwygyDGhtQg1RK511yTU/8+on0fnDpgClxTM8jAh4TqbroqEV6AP1fzh
	 b4T+mA2XkL+qZdTcblYfGIUTdrow4GaLmMgObnGHJTy1DauQR4yEi/FIiKumMimOHQ
	 Gxrr18S/9EOb2eat152D7y+nCInNP5roBnfmUiFw66Lrgq6S9WeiJFL3ckPBxt4ydG
	 4iy21RmpdG57w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFDDCD4F4B;
	Sun, 17 May 2026 15:39:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 17 May 2026 23:39:42 +0800
Subject: [PATCH v5 03/12] mm/huge_memory: move THP gfp limit helper into
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260517-swap-table-p4-v5-3-88ae43e064c7@tencent.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
In-Reply-To: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032385; l=4383;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MR1heGhcrCQDpIR+H9UupQ+NXKwJ5c9dggOiT/gkYv0=;
 b=Emcc+GvxCXEovYTFHNrqxOtteQvH/LOh+8ha3l+YBgxzoEMWjAynaykgAVWZOwERL2/UrSAlo
 +rDZv5p2h8pA8VBjuNTk20FbhJOsgd75ajpE0c9jJmykcpK6nrgQ5E0
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EEE680002
X-Rspamd-Server: rspam04
X-Stat-Signature: hsxi53p6wxg8ikmysbkm8qdbt1cx5ogb
X-HE-Tag: 1779032389-477063
X-HE-Meta: U2FsdGVkX19MjTqTxPZjlaiZ5w/VaEeVnc0DdkligxtJQXqVrszMM1nrBtYILgPVr4SdUbBgZJGU9jWAoPP+lH+dhu/PuLbT4or40A8TyieMSpHYqsUcHmBu29w1EoNx5pCUiXuwDq0Oir15rMqv2jQEK5eYkcdWglV0lt+stK2mUVGX3DdX6p7cRzA45rYIGLkfNiswNO5LnsawQr+M4g25vgV4d7PDIlwG21pBihZ2Bi2TP5RIz4Fw/WTLPU0bqFimqZFVTyw7/30zJETYrJ8aL/40r1l8oPH/KBXDGNBNz5rl/rLMytmmfdwQ/HmH1rwvMH7ZUz0w+XQjpaaulsSGTuebkKokGWn8ai1RO04DzIczcJy6AGNpsQehAo1ckGU6MibPazl9PniwwWKYhmoI5Z6rc4VmWsLvOqexBzK/huYnRcR7ACqD2rSkMJhPRs2LPp5K6nWqPyQoPS6f7cW6+gDHHEg0OE7g5o56Pa0ox0F+cvoUD4U/+Jep/cjrCZgnH1NUa7NRVSRv9SMmgEcl4U8RguX0oxn9bDAho1lO4firynW/Hq8jNm4l66yx8a/RAa3qkW2u00fYMjwMKa0tNsaBQxdkE3pNjWmXwyOVdo2USi+EqveN5tr754jzlXDOD/Y6QO2GclUL/iOBL76AyDVKnuX+w4stuoeBv2heWHUOhEOqP4RICZpxGK8oYaryy27K2F80/BVtGZbrI4IZBc+zbfTLeQjAcV3DUjDlYf0oKc56oINeePfZg8s1bvw3tVzhFB6FHoTrcE+VI+aAJ7KOXasfblDYkM30c2DLoZ7teQNHdaja06CBh7KDWLNOvy8RXTqQyliz99WDi5MwTa/IOMy5nbvLF2EjORDRti8MOHmctSBoWdOIQVjBqKoUv7VMZlBwW9Vuxb5B+ZMo72QgS5Zt4MuMw35Y5BsSn9QLRMIPQCvpV2CHORRHkZH9xZuKWlr9wQwRpNV
 LYJCizFa
 Kk+42kPwTggKisoieDhcZhX+1TFJ5ebhKaUOtYMeefQYS9jEjoa0GQWMN1GQonEm2tS2wIO4qiYkD5SHPKp4tgPuMUY0eceufTt4yNmFb9NXm4S+3HZQcplSrAnGJW4hSkBz41YuofgwsT4Qxs7Ej9LZK5cFQnZoaCCq8F4ZwUgS93fwbDHefU6fiOLRoh6Psaqxc2ZoeD//KZ/g8CLEXRvDiAbi2o+MkFoQetZk1Gfy2Xz9VPx+8bkGUKFDxwX2IeeFOQpIaBjjmngPuqjxVweKxYRQGyHjjRZv9cE8nIJjF8peimjy7ly3PN7i4RGYe95TbQvN/lIPp3xc5UnN4erlRS4ViKDP2cv0v8sGQnKBAIXOl7S18r++k+kL12vl0lcaM4xB6b4loUDl8DW7NZWuiiJu/Hk4ZEgAcBD5VeLl8x94yb8m0rfdW4HmtRHtqf4FQdc6gxjSlkor1awSCMdl4BQUGPIiH9I28oLbAZ9R6Y0QMT8zQzVQo/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem has some special requirements for THP GFP and has to limit it in
certain zones or provide a more lenient fallback.

We'll use this helper for generic swap THP allocation, which needs to
support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
is basically a no-op. But it's necessary for certain shmem users, mostly
drivers.

No feature change.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/huge_mm.h | 30 ++++++++++++++++++++++++++++++
 mm/shmem.c              | 30 +++---------------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 127f9e1e7604..edece3e26985 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -242,6 +242,31 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return true;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some shmem users want THP allocation to be done less aggressively
+ * and only in certain zone.
+ */
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
 /*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
@@ -565,6 +590,11 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline gfp_t thp_shmem_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	return huge_gfp;
+}
+
 static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long orders)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index bab3529af23c..6edb23b41bac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1791,30 +1791,6 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2065,7 +2041,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2141,7 +2117,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2548,7 +2524,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_shmem_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {

-- 
2.54.0



