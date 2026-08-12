Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CF0C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8400E6B0132; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEC06B013A; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3266B0132; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDD896B0132
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11D121203FA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:20 +0000 (UTC)
X-FDA: 85093505280.08.8C585A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 091A04000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F2cecEpr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzJm0uAy5qEWPT9tK9vArOcp8Rbr/PvokaYPchQXHM4=;
	b=T+nF8w4lXMpOGRZ3KVQUkSCXKiBZ4myT0sUUs5rKPwwVJbbW+r3fsV/2ZqHMY1Q1aOqzos
	PFzC6nVBnIgmU8iklaKm3gfMkJdu+WSuDRM0WeOsYirh7VBWlaz7q6uQpr4xgp8nrxxpzl
	pLRGZt7DtrAuFc3DA0RF+yAKlTY4CVo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F2cecEpr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560558;
	b=WgZ2xUgvfuNUn7YEUadX53uBcw3LKu8ik4THuRL/prHKIDY+1pwjuoVFjBx71WqcrBJFGf
	PcOnMXpX390P8oEQbqLIdoZPHhSG6l0CBPwD2uNh6ufTYTr0mdZCz9kmKR6FScwC2VjQoT
	Oc9HcPPpKdHzk3D/CT5IVTCvf9AigOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 51DB544FAE;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32B71C2BD05;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=gUgU7p9/XKgxy5w5HwlPQPYR7Sjykv+trHbewH8ttzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F2cecEpr782HCcD6qVCIWuvQGOIlXiHqGX7ZW1yPnjnJkno/N+Q5WzUonAEhXWY56
	 PnogP1qLMFj5GNcih+/V/cQwpuAQjDF8ppL6fhBhz6w9aCFNLT5NEOVmQXZc/1TusN
	 IwXoLaaf9fyvoLQavdk4ERVydOhcuwoIUFSAEoBscwRSi+bM3Q+4inwEQQsNLtGYwa
	 yQoC7A9bUDc3Lc81X2yaVbp17ymJaCspBi0nb1hf99vB8RDuuTjrdRV0id+Bl0azQG
	 NmorKlGZ/FT+kyFnutAgAirXuyI5Lo5iCEfxgY+4nyZs0Ojr+S8ckmhK++XhElQVv9
	 0v4uG/E+mqwKQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF96C5B56A;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:50 +0800
Subject: [PATCH v2 10/17] mm/huge_memory: move memcg switch into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-10-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=3647;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=AzBipzrIrYUu4ErVD0k6sxdH5I4rv7p4DfaxH4DeNi0=;
 b=jes9fwJxP9M4s7VNl5IMSEwvhWGCAngoxTYzw2AMWzpE4sUG2+1FV5Cz21XD+FqLpHDzkFdNb
 bz7yQ7uAQ/EADuXC8AGATRok3JFPaGDoa5WuCjIQVCUevuKr1mCw9WC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 091A04000A
X-Rspamd-Server: rspam07
X-Stat-Signature: t7h8q516d5ds845z5pekkbz94w8jehpd
X-HE-Tag: 1786560557-40848
X-HE-Meta: U2FsdGVkX18nlvxgAzb2H9Ujh2QEC8fScdwU/KgPCk+5TEwamIzTI7SwrRSEPrmyNI7un1AXJUJymzJQNtR/NWf7YJoVX1TO5WsKLd4lmD6zgGy5Db2+xdG8D24zZrMFVm+qc8kDw1cUUR0f9n8sn8HDJwrlLt7vUI/jSxNpeIUBTf7biBByoOPEzGWLbfGkHrgd1ITT+wmg172+TL1GRwPWBFrFirQE1Q7D1UJ8abJTCvQx7z3/kJ69INZtWdsx0DcUdv0l2ZP7igPVFod6Hs0KZZzXGKZIk911jVllxiYAvnJG85r0DES5bgk+cDE6yZrJEVgOjLxqMcss+sHnGTQzloWCl9QHacYGPDsOTa80Tk4JbuQB1l3dzvKIErVWVs14OdYZhaMrEsTm93bVnV0bKa14ieYsBrUntjvakAKTs2HOIt2XUnhhHehqBbBri0bYDGldeTgALoMs7YKiX2oMCmxA5Y03JIYKLufDb5bT6e7I4E2Apco8JsZV8OKVagbDuaxigqyZApHAZmYInafWsMZTC3vlgHkWC8eBWadY5rZhwYHtvl4TS5P5E4SIlEt+uoz9onu4Z8UrAtImfrOGENPHvz/YzUDl09M8rnYJUvyCa0gtjI1jdJ7kBdE/B3BerwdLdyOeh7XjmgA1GW2sUcU5I5m8CU++Z8/NMEMrUyMDoLmPv8FKoukJU0Fnn/9NQ6Dm7ffM2qDWcQKtdXyEG0cKTqSQLceIC6srDQHtZ3rP0R+0rygdGvf3EdNvh5jw5OSSnfrkKs4TnKL3VOybeGZpK76QbN23aFRRSnKpX5lS9PZdHY2IWtbBA/5kPe9t8+d0pKee6toaF+9Ow335X914dnHvViQ5SwxD31329d57oyPSteo/g9ilyzquev+I5OqRC1LoSIAZAUJz/8H2LQtiOXbUd81+lF/Ok7MYvrt4qtzImnFRDeTEfIZvF+NRdYnl7qLuRPw+HoD
 w1dCXp/j
 uo6OSdv+9o4v5Q+3wLoYrgK2QpmAMbMeFwfz/CsnCsOFme8Y/1HUPDH7yPoZ25LCd+/Jk8SgD41bsQb4+BSFKiCaqiZ6I6PxenFf8j6YfplQ0ZV4RkISl6aTo1/IiEo/+U0FyGLihc+n/cUiKpjiXUllyqhQVoWR1cVciaWJCGlciEP7zoKCXx5brcpERfNCkvO3ozGGTvfU5wlMQKx1fZoOofZms0ooM3XbfuG5wehzVh/RFnGx1AFxtCKpZeqwe2lEo4TlCMb9LBj7pKeRjQwn3nqIOLMAa6SkbYCidVadJTczrY576KYUdNVfBAZD2uLRYTfWUeb4TmaF2xxas4T+IHMTVF0XHN8HbRbd97WL6+bITUcphItjZL/NtpZMKztZtKKzF8s60689iZmZq1kKVVDQr/amkICi5G6L9vd4e9PkwRFmcmtJbIQhT/GiduYxnD6QMLBxM9OLI3PI0WZZ1r8Q4hkYh/yUo
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
index 1a3ca2606c60..29b46f039d1e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4076,6 +4076,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4088,9 +4089,18 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
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
 
@@ -4223,6 +4233,9 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4254,7 +4267,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4264,27 +4276,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
@@ -4311,10 +4316,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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



