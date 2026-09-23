Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B905C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1386B00AC; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC776B00AE; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627536B00AF; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 244B36B00AB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B43A1C08E0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:49 +0000 (UTC)
X-FDA: 85246326858.15.14FFCF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19A2AC0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PBNDBe/6";
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOslwy4mSqbMCY2jwUkOgvbK3jdWYbaWMr/WVpppkBE=;
	b=Y0Csh5TTU9JjIYoVcB1EtQzoGnmpH+cmPO92YzkyBCnHMQ7jHDzqg180CKI2pZa64yWisF
	2rfGqA+IV07GXxNk5/IJojsDKrzErwrsNc02J0Ffs5qALEyuNgtZztzT59iLHY3v64A+gM
	rniVnHDp0j2yRPUiSUSezpUdav7ZzeM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PBNDBe/6";
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199167;
	b=2e9FS/UcEBzFRXPZUHzlraIIm5C/wYL1tnLYXJDnnrH36Rrt8MhvHUTz2otC+OjfisdxzV
	KwEPx8MwlPRABJoT/qhxVR5cPiQo/Iu6YJZfVqEtS4uyMcGkbiccrlVJMsfPjt9oXLTii2
	yFrO7YFysBajyUNhAT1aMjIctrjBgg4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3375447B2;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4670C2BCF5;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=tCuZEPVVgjW53lTmDy3GfqdEs5Dr1bwfAnf2kMd3J38=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PBNDBe/6RctRVoEiJGVpt1aOYVYLIp7QAPU41UMqtaocb2nihwcFPnLVAWUwr14x8
	 UxrDielLUYnzDWmp1gTL0D+wpe+mx9hdrt1hpt/55OE1ai2WDYZIG8qoAlKeWk152u
	 +blQVHRZe4Era/HGUzMCzvi4SUIvB1ftodyxZWb7XpvazxtUIbTNgKlsY0un+TeOd9
	 uktF2eDk7Ky/JXtsdHzdVcMMhAzavwFzFV+CdiT9kpiqXCi0s/KpMg7QcGJlAWZ+xv
	 MxpGRO2w5R7XtR79nzFjCEj4KS9eF9UkkpvX1t23PCMf+lbnj8Sf2YzvA49SeSw+ps
	 haIVcD0YzkdFA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD923C9830D;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:42 +0200
Subject: [PATCH v6 11/17] mm/huge_memory: move filemap management into the
 file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-11-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=6383;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8pTRgHH/mO2XdrGT65s0vaWhb44uyEw/ZQxVpZoD/iU=;
 b=ltWPhfqdVU33z+Cs4byEFOCxy5U7xMheOpjHCVpuxXGwYl6C2Qgpte23bfCIWbL+UWfuBU2K8
 NptI7VZ2y8SD8Ef9v7Ey4NMv7me6sC4VBcOvfVg6sRAB548Ssydq3Od
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19A2AC0005
X-Rspam-User: 
X-Stat-Signature: t3g5m9d7wtcfkani4reuk1mfeb14sjk5
X-HE-Tag: 1790199166-240298
X-HE-Meta: U2FsdGVkX182g1FpAcAOMtfA0eLylxV7c4SLHI0lYxUDqyw9ImZOE7gQFa2xoCXVzVFicyc8COs8JXc7mLec1KVW4dlw6hEZ/p7sqtF/HrEERrvGGslyZF3NQcs9L4sHhuqF5XRcoSlFqJ5cvIh2arwZy2FwyRY42QyMXBFqq+X7vamjtzz1hH1R/ksag7mmY3x/8sZP+qAIt9E1WzXs0S5wvPaCYPkPXQGwk6YbXqbMJ0PA3WZzYKP31fstqG2YF0HG8FZuq+JxcIOEAbzNlmUYNwOWDp5gHYuLlgxL4svN67Zysnw0O1sBGmyL6ygO7etME+Vim1pnL7qYmV/OeNYId6E9JVCuj2CKXx5nKx9YbqNPi7Pf6ZgTGp0UdxrAalcy5cBbnlzQ7/zsqceC0s8D8nlXPaTN8u2Ff82eZvhcKxaSAD4sPktlRFmV46P6FJNNUBVJdI9nMJgSbVmhusuu3RgwrSzw5WzTzstFWd0QxtQddb1+Loan0I+5fPh1COAjbYpYiaj+49QYySd849cZ/ocutU79NG0gLYTiCPG3N05t45Nx957JMuHMSoo8vUAWgDBtDllU9lAL36QLtL7hpFDrC+pzubDkjfvHTUZaVhKhRamHsLguALyVSD/pZ2PYNMs0R676BROA2SVcI3urmsYxERdIflS1ecSf/0YW4bFvfNZWUX+mQMREhBJ5T1sU34MHt8aVjGqbLaQXp3coM9NPPOvloMPKFrazy5cx1pA9yrYyCrVn25onTRY1Bnar5XT5XT+QzXKQ+zEpyHXdidQURv0FijFf2+3NfVYSbVkWKIPKo1jiNDaK1gSd7AY4/rgUvEgCY+eWiRC70P719MXjgTgBxeUVKR/xuAb2XBM4HdEc4wpXRu0GA5EhSscrurdw7xOpqvErQxC6zMwoqfIQC7t/tbtkCSvUr6asH5KqtoXepZj7vdc1KR/vnAQ8XZVtmIGTGgrNGs2
 2DyPAQfo
 phEHEpahwr+4ddtwm5pHUePfocCXBXXXInsFeZtEDrXKmBkUJrodN+6jyp2C5B2NUoLuLhkHYPW3s2Rv49ocU3t3BguT99+lnWwXb/vY182TLwuMJyGb9UdKPyQCo6B1lcAXVoXXweGDWWoEyqJ+4elP+bJOAIKn/Xn8dG8jtSOdtjY+Ndt4yW7VS8H9qlLIpN9xsRG2T4adoqQChVEw4zy/nLy714EqZ+8WPXwSVRt5cOobdFSpybu81JMuCZ0G2IdgqovqhDA6m5YxZSB79Z1V+K3hDBU8EFmSUpGiEht3Op4AmGriKdULaV1ztLfjr/CORNyXX0WumwqsmMwaeKAWTSOiz/xoNZruxGNCgpP/YBsWlRhOK1nQK7b9Sj2pON9LqZ+81c/m1ICfRZ+a9gDRllfr6e4zQBdVQGhvW9NaPeTIm4pg+PqHx+DlfOJaS8Xsp2B/t7WLvAiPC4ZCJWk6L6x4RoxzIBvAKNHn3jgyo5LF9NbEgHOOkkAxOGUdUMMSSXmBd3kg1UuAhBHwxDG4Xgchrm06Bt/bOjr9mLX/KlQll5km89SA2WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only file split needs the filemap and xarray handling and related
variables.  Move them out of __folio_split() into the file helper so
the helper is self-contained, and simplify the parameters.

No functional change.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 102 ++++++++++++++++++++++++-------------------------------
 1 file changed, 44 insertions(+), 58 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d738b25f50dc..24073f75e87b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4110,16 +4110,42 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		struct xa_state *xas, struct address_space *mapping,
 		bool do_lru, struct list_head *list,
 		enum split_type split_type)
 {
+	struct address_space *mapping = folio->mapping;
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
+	unsigned int min_order;
 	struct lruvec *lruvec;
 	pgoff_t end;
-	int ret;
+	gfp_t gfp;
+	int ret = 0;
+
+	min_order = mapping_min_folio_order(mapping);
+	if (new_order < min_order)
+		return -EINVAL;
+
+	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
+	if (!filemap_release_folio(folio, gfp))
+		return -EBUSY;
+
+	mapping_set_update(&xas, mapping);
+
+	if (split_type == SPLIT_TYPE_UNIFORM) {
+		const int old_order = folio_order(folio);
+
+		xas_set_order(&xas, folio->index, new_order);
+		xas_split_alloc(&xas, folio, old_order, gfp);
+		if (xas_error(&xas)) {
+			ret = xas_error(&xas);
+			goto fail_free;
+		}
+	}
+
+	i_mmap_lock_read(mapping);
 
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
@@ -4137,15 +4163,15 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	ret = unmap_folio(folio);
 	if (ret)
-		return ret;
+		goto fail_mmap_unlock;
 
-	xas_lock_irq(xas);
+	xas_lock_irq(&xas);
 
 	/*
 	 * Check if the folio is present in page cache.
 	 * We assume all tail are present too, if folio is there.
 	 */
-	if (xas_load(xas) != folio) {
+	if (xas_load(&xas) != folio) {
 		ret = -EAGAIN;
 		goto fail;
 	}
@@ -4172,7 +4198,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
 	/*
@@ -4224,9 +4250,19 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec_unlock(lruvec);
 fail:
-	xas_unlock_irq(xas);
+	xas_unlock_irq(&xas);
+fail_mmap_unlock:
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
+	/*
+	 * Drop the mapping while the inode is still pinned. @folio stays
+	 * locked and present in the page cache, so eviction cannot free
+	 * the inode yet, nothing past this point may touch the inode or
+	 * the mapping.
+	 */
+	i_mmap_unlock_read(mapping);
+fail_free:
+	xas_destroy(&xas);
 	return ret;
 }
 
@@ -4255,11 +4291,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
-	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
@@ -4306,60 +4340,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			goto out;
 		}
 		anon_vma_lock_write(anon_vma);
-		mapping = NULL;
-	} else {
-		unsigned int min_order;
-		gfp_t gfp;
-
-		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
-							GFP_RECLAIM_MASK);
-
-		if (!filemap_release_folio(folio, gfp)) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		mapping_set_update(&xas, mapping);
-
-		if (split_type == SPLIT_TYPE_UNIFORM) {
-			xas_set_order(&xas, folio->index, new_order);
-			xas_split_alloc(&xas, folio, old_order, gfp);
-			if (xas_error(&xas)) {
-				ret = xas_error(&xas);
-				goto out;
-			}
-		}
-
-		anon_vma = NULL;
-		i_mmap_lock_read(mapping);
 	}
 
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
 	else
-		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
+		ret = __folio_freeze_split_file(folio, new_order, split_at,
 						true, list, split_type);
 
-	/*
-	 * Drop the mapping while the inode is still pinned. @folio stays
-	 * locked and present in the page cache until the loop below, so
-	 * eviction cannot free the inode yet; @lock_at is not enough, it may
-	 * be a tail beyond EOF that the split already dropped from the page
-	 * cache. Nothing past this point may touch the inode or the mapping.
-	 */
-	if (mapping) {
-		i_mmap_unlock_read(mapping);
-		mapping = NULL;
-	}
-
 	/*
 	 * Unlock all after-split folios except the one containing
 	 * @lock_at page. If @folio is not split, it will be kept locked.
@@ -4383,14 +4372,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
 	}
-	if (mapping)
-		i_mmap_unlock_read(mapping);
 out:
 	/* restore to caller's old_memcg */
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 out_no_memcg:
-	xas_destroy(&xas);
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);

-- 
2.55.0



