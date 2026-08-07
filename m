Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AAFC5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980CB6B00B0; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957EB6B00B5; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B926B00B0; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50F326B00B0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:18:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FD7512016F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:55 +0000 (UTC)
X-FDA: 85075735710.18.E759231
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 85306100012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mGr1d5x3;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137473;
	b=CYQ4hlgSCzQlyQzuSEN7KlDtThOi8RDlMvFOKoBdxP38ljHOJvaIUlWLO7tgCbUbh03Mnp
	fIky9QHAOgBZa2tZpKTXvR7pXKzLNgOhsMO21VAO1UNLpFvy/2R9ppVw8SxNH/MiVmPaDI
	3zpOHA8XE+ZaYGGW8c8iK1Op3a4EwUA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mGr1d5x3;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jm3/io+LHWPsYFEIRyUAon3QPmdx1cltVo7je1zoI9E=;
	b=8o1DZ6BLOFIERWQm64LU1vYJI7PqcdP/VSluhVhovYPR7Lkfc8jEU+0oWdtfj2v5Leg/ob
	+27+WtDdpEh5FFr3/QoATNGHXZ+FVUjHHNpy/KkQw98LWabfIsRDbEzhrQnSMy6hD9PXDH
	ZS2yUiC/4IW8CvCuYa1m0aPYbDv0cSU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60CF44411A;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43203C2BCB8;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=UBCaRIj71EFnMJbiAnbHRp0dByToFm+xvtA3P1554AM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mGr1d5x3h1etfnIFtuyaOzHL0IF6eO7NQdcMYJRX0FRpTXgyb479Yl+VQ0Pf4Qgpv
	 qcqFvrTaL2bWFV9dk66CZk8Dy8cQ9MyowCrqJBxXIKz5SaAur2SPOBmlH7gvzoX/GH
	 w+zgkBZLd8HQvs4xp2XY5AAGvM+P0CRXbP3zcemYwqQAfhLtq6P8Aybn4H8sb6Nz85
	 HU3ZGzOfo6hHLwCo72QYTQJcXG4YPZXq2mDdHYLQFJG4MoT6YYHbLJyxdsn/vGUvGl
	 vT3VZOuZmcXMg2sFYmB/DjPHltOlGfLgJ7lXbTNfmODEKfeKhNDwWIqrrsOOXb9Nm3
	 5eBFu/PWIk1ZA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDCCC5ACAB;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:10 +0800
Subject: [PATCH RFC 09/13] mm/huge_memory: move memcg switch into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-9-689939a7ccc3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=3611;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=suVTq55eCBPCmmmCFw2hiAz9weomIDRQxX0WoFXbtvE=;
 b=xvJl0GoXEACDF9WKcNSCH+92kCsa0Ivw5DsKzRhSxuaiPMjVQolHTZ1i8jjrAajeC55ZBwAgB
 E5Icsv9rd4cCHrKQrHdZzukhuf4/YQWkz+r4D1+hRJjqf+t5at4buGR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 85306100012
X-Stat-Signature: 4gzpzkeor7ks437kkxy9agiuneyx7ix1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786137473-797808
X-HE-Meta: U2FsdGVkX19P95O8Hy2btPdPKI99cbEs2x+U60bxw4JzE79kFJBuZWvekz4YTijeG3Osq18WGEq9zVy2/CVzpRG0YNteLR93lI+znkL6XiiDYiPNQdb2PMbg3DrgD4kOvclGdjRbCTUg51xkv4WYTQKV2AfVYIE8zLlZlHdo69Y19G6I1jD3B5PLcj+24CxbdeIXwZeI8XSjFkNfQe6PRcLYBwv9ebucy3DPaf/QiKvwWLt+3IxtSoSWES82fMLaMPcQzqyT6XX+k0EqmTKqLPeWQO5wuESH8L5YZ++TfF+W5lp06O6BK457ATnSJz6As8VUw5fkXfCpTDRFD4OnZNRrQtCcDmwdjkTM+PsPk42oDOQgIh/d+2NghR68W4NaYF7I0nO8RjrhN6utPep5eXt/OedJncP/+7NOxJ0IqrwywWcEsS8SePSdSZ/SusOO0GRrigYFElA9OXeeqEkcTu7TacPLvgiCmSnCp8kTAd8usC4VwUI3falSh2Vd04DxZXTNsSeIjYScGFuzJ+E8j+khVplKdkF4jGq6FlT0D6qkxUIQ7SLjU1C6D6ixgIyZNFFpSWuZQ6B8fb91+kLJYcvwGrouLDO8jgDlhGnE9eUSMKEN691bzSwkBS4wQfCQu+swjg4ZNVJ/LgSHE67nU4EuUIyM3/vvsFj6hiyX5cCJEqOp9wVT1hes0HTDcZDh3IusqsBd20a7FggZ1sXmTYQyaZAbriGGE0hvnKejpFKtt6F5wFyl0a8U9II8iWFnTOk/h4fk9CZ9phi3xMp9Ai8ISq78e7o71EDQwqw5kB78lqKrrdZJa4hzm8dqhwHqp80CpcvBEvhEJLl92Jcrrwu85phxLoPK9b8Cjfpgo/2lPFRZ+8RisrCO3wCGpAs1Bu4llsGVIH85sd98Z1/dxtHE3CujSb+VL/s5FFdWs6ZjNivrjIZ8laCs5+nS4SV8hI7VhBZfu7sDQQm/X2V
 P9eDyK8Q
 lvF/ouxNlquxbf+FlQUfQNTXYl2VJ0s0fUCjluAOHoYjQC+JzakTcgbjq/7l+Gmx0aSO1FfNqguyG314HDrwBjcXJvsAsA89tuH2cMGIM9thecaRVCsphAPEA6WG4LJeFezZqgZiEeCYJUGiRSM5UQWFyoH7RWybc7zZBMnL/Cx6zi+0jBtVNLF8mDCgsdxn0mA23JwdFJzJj+euDfQL1LHAdKjCppB9Zufbm8lnjLKsPdThVwaBXOqGsy7QaSbhWeB0nff0QOcB8zq+u3hfGGDcafmKKT+evCyUb4VU63f2yn81fuop9EQlaPwaSnTmfPTavP+gbwl7NCWNlxbZoUY1LmifH+s6g8u+hisl12iUfPEumXDwNAa3pgrZ6dw6FpPCs9PeokLOfB0sVQYiYi7EyxywuDay3L0kUCWEKYSOnrsRSIBFAs6R8e3N09Z4btooXV9KCS/cy8wU=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f0ea6e5f53f7..ab2bb29748d3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4068,6 +4068,7 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4080,9 +4081,18 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
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
 
@@ -4215,6 +4225,9 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4246,7 +4259,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4256,27 +4268,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
 		ret = __folio_freeze_split_unmap_anon(folio, new_order, split_at, true,
 						      true, list, split_type);
@@ -4303,10 +4308,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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



