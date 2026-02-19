Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F33C531E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27AF6B00A4; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29DC6B009B; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE23A6B00A1; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 804846B009B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DC901A05F4
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:13 +0000 (UTC)
X-FDA: 84462832146.14.938176A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B0FB140017
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mdqwLoRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544531; a=rsa-sha256;
	cv=none;
	b=CPSDYwDGBgqswdeC0NCeiE0lbdcQ8chcllt5ai3nMghrl24gsH0mgkmkY1Hhs1pVbvXu4g
	CTseoFIAUZJoZXJB1YeungwMGYg71M7qVVAByRgFd4opHWkJKU+5j3tjNzzzlDmVBuua73
	76fUKW/MCsKMhqPy4sbgUyN60VaRc0w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mdqwLoRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544531;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2UD0S/B4EGyqB0yVjx08bWABAcAHN2Ll4O3NORaRAQ=;
	b=nwMRFcrulJOjmVIsH9wXBtF8vEEeUuIuYQr9FFHHrK7mqewLhghiweU+WSfq0ouiTSMHzY
	64xJZgJ0mOSQC6QXv5ANNDsZz5wrOX0ByPyrxaxjwXEYZUd3CzgwviiIR2u0zS2aMoGUxH
	vDbV6zeEsxMEnpTS/JUTWyHzcdrnc/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B40244539;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE002C2BCAF;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544528;
	bh=XphCFHReTLerRTmQ62E7k3tj+ws8vNIKhOrrRBsM1to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mdqwLoRAkSEFaKH5nJYW4cVLC+sLaPjgd7tmmPIXVPooYnwsbygV1gv6tomQodj9N
	 jO714FjHDyMkiCkBQZLpEz0D809nXyLNDbtNZUhd99XA587oEMu1OIZ7IWBztDpWjg
	 7l/OUQxVr2UVAbaoj7nEvQawvxGJwkt/M6Y6LYN/g1Kn0FIAeGlToAdnsjp6f/q7L+
	 Ug+CD9rx2u9idWo3v3o4hSIvx+3K4cYtqKbTkXdc7c4h5USVZI77vlNDo/v5kKlAX6
	 utsmjLEUdr9zGPsEx7K/dj+dbgOBaY5lsR31hO2mcoJqN4vhs48c+BkHmHsgiZqRzu
	 yqm7kL5/WB+ig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E568BC531EB;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:11 +0800
Subject: [PATCH RFC 10/15] mm, swap: always retrieve memcg id from swap
 table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-10-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=4319;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=WsZXml04ASUgTsoFPs4VOCkE3+G9dotFosGt0KDSdnI=;
 b=8PUGQy+iLDj47T0eAJnEPkBbFEpbjpdotOGd9HFhFodXjiH7rSlOJhvBygk9dElK56junzS5k
 sewBlHU75avAo5d1frQoohXdWvj9c85coOf+rZoeyzNWabyjMYaOOeT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: zywu3yegt4btc1q9yop8gxt7m1fqzbzx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B0FB140017
X-HE-Tag: 1771544531-268649
X-HE-Meta: U2FsdGVkX18nsoJVKnA4UFWZT4+q3+j8wr5bwzskCfHjiWvQ87sSaItflMSKWGGPk0JYfi/2luRpUMDFnUKNOj0I4MiYgSk7Ccz7tCKZz8nDMsLoTV1NPWkFmraI4KUrGKBQZE1Aar30QciDmBuWxcsaUauQZTi+Abwg/daKmS8JpCNKD6pile0/2bA+LnNkxLxPcj1VJryjyjp7gUorx9RxhKdIpkMHdpEFhsDQBRpXTRukm4xElIgeoF/FHRH4Eo6hDT0yFGoDCnrPlewLGUcnISGK4J/b1C7xR8GK76W7Ft+jNSfoptnIBZdB7CmEQQoNKUjOYRZkDSTPqkxuQqNJLdx1clkfWu5osQP6DbeXO/lto/Z7TSl0ryNntXqSEapuOKqwiNvCcYVxS2rDF7Y3DL7QhKSA4Ft9o5XonrQvL6SmxEUuX7Wsbrqt9QEwi7OxSzhRoUeZCVX5bFLGGBfBR80YnhVuCt6rqfajWo3hoC5hAeAVDzROLrfpu0hBCCO3jHZb1vMNu4zuJaVct67d/KT+ym+h4QFvhA16Sp6aIz+q1Hl+V9+eTwZMBts84IW9F79/CMoaszv5bmiUVYIdPEvdB/30BN78zE/EbYKyDrUESkn5X91YNCA8OKETT6N7hPRXaHwhbQkQ9G6KEiURtYP1hcFX3ewVaSpIdhPE32d1easSmEdhKodELAiGYc8cWlinuapaMTNixTjLpwUNT4+NwhuylRQQQh5M4ep4h1leno+CySqwGIbfPF2P+sQCNxkgncA0R9andJJz5jRKNOgnVWWffK2t5tlyOmxb6dvue/8PXvUVZbFINPCsn60qQ2rh4MRshSljOjko4Asdqz5XJKPnuzlQ28sL9z8RdkYnMpgr05PjJkDw+KFbUCprykdfb5hiWsOxdHOMYr0uVA7qx75lycAfmz1ERccNuuyCE1s/yp4KiNdqtDkCGsrYYRXPL2T76Np4vjd
 NmK1/ftq
 REcV/sBV2rG9zkeRE0Mhhjpoet6WoIhksKvu0IBxiE+dq9Ld3XPwLluMYxq13X/0nxLsaSET9Xjq3zzO/bNlzo3bMLl2Dj6NTU+31Up0lhh4LJ6bFjpBQPjaBp4UKxM22ghovRO1ADF8A0IM7LGSLlDzheRjSTlqyWwjvthj+ROUew8Bm52ubHqqftOv9ogFp+U0SGuni84d+mGrHELupif8M8K1B3ZJ2qLaWK/fy0vcqYA2zghsPSW5v+NeqjLGQTExCP6t6yRiXzogzHVUtPxhljsnSBEUxXfCGvM3c3OiQclFAsptVUoi+oq/WWr7Aa+6R1dstMHS+B1QfWmcI1wtO1JOlRiEfgc0VDYH6kQu/dlDpVP8egTx20nzKtH/rpO5om6JOedI/hCDLGL/voiv08Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Transition mem_cgroup_swapin_charge_folio() to receive the memcg id
from the caller via the swap table shadow entry, demoting the old
swap cgroup array lookup to a sanity check. Also removes the per-PTE
cgroup id batching break from swap_pte_batch() since now swap is able to
free slots across mem cgroups.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 6 ++++--
 mm/internal.h              | 4 ----
 mm/memcontrol.c            | 9 ++++++---
 mm/swap_state.c            | 5 ++++-
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0b37d4faf785..8fc794baf736 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -667,7 +667,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				  gfp_t gfp, swp_entry_t entry);
+				   gfp_t gfp, swp_entry_t entry,
+				   unsigned short id);
 
 void __mem_cgroup_uncharge(struct folio *folio);
 
@@ -1145,7 +1146,8 @@ static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
-			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
+			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry,
+			unsigned short id)
 {
 	return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 5bbe081c9048..416d3401aa17 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -452,12 +452,10 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 	const pte_t *end_ptep = start_ptep + max_nr;
 	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t *ptep = start_ptep + 1;
-	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!softleaf_is_swap(entry));
 
-	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
 		softleaf_t entry;
 
@@ -466,8 +464,6 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 		if (!pte_same(pte, expected_pte))
 			break;
 		entry = softleaf_from_pte(pte);
-		if (lookup_swap_cgroup_id(entry) != cgroup_id)
-			break;
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d9ff44b77409..d0f50019d733 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4794,6 +4794,7 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
  * @mm: mm context of the victim
  * @gfp: reclaim mode
  * @entry: swap entry for which the folio is allocated
+ * @id: the mem cgroup id
  *
  * This function charges a folio allocated for swapin. Please call this before
  * adding the folio to the swapcache.
@@ -4801,19 +4802,21 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
  * Returns 0 on success. Otherwise, an error code is returned.
  */
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				  gfp_t gfp, swp_entry_t entry)
+				   gfp_t gfp, swp_entry_t entry, unsigned short id)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
+	unsigned short memcg_id;
 	unsigned int nr_pages;
-	unsigned short id;
 	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
 
-	id = lookup_swap_cgroup_id(entry);
+	memcg_id = lookup_swap_cgroup_id(entry);
 	nr_pages = folio_nr_pages(folio);
 
+	WARN_ON_ONCE(id != memcg_id);
+
 	rcu_read_lock();
 	swap_memcg = mem_cgroup_from_private_id(id);
 	if (!swap_memcg) {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index cc4bf40320ef..5ab3a41fe42c 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -251,8 +251,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__swap_cache_add_folio(ci, folio, entry);
 	spin_unlock(&ci->lock);
 
+	/* With swap table, we must have a shadow, for memcg tracking */
+	WARN_ON(!shadow);
+
 	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
-					   gfp, entry)) {
+					   gfp, entry, shadow_to_memcgid(shadow))) {
 		spin_lock(&ci->lock);
 		__swap_cache_del_folio(ci, folio, shadow, false, false);
 		spin_unlock(&ci->lock);

-- 
2.53.0



