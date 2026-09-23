Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A363EC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4046B00B0; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515856B00AE; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3689B6B00AF; Wed, 23 Sep 2026 17:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 031C46B00AC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A8E61C036F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:49 +0000 (UTC)
X-FDA: 85246326858.04.1E7413E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 888F440010
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9xNylgK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199167;
	b=CSVctqKCCSYzKAO9xhadBDG27CtZ46RU/gr/fcSy0sltg9w0lnecNGQnyoRcNMW3dFeFPN
	nPSM3JYiuwLmQT0HjQ9X7xHQV3HDf220EQ69tcPmT+hHbFNY36UctSfqyqTNFgqJRQj3/p
	YAUQ7tYkNPzV1y4nczeZwagFTOJQCho=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9xNylgK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMRa2QBbHhjHakfWYkjqGAtM8ddz8VArXjGXQ8Vy+P8=;
	b=uPeGVsPt8hi/JTzPHfKuTGn8OGsrr9o0+QWm5I2njJh8Y8i4AShWe8vUWHm8o+8xBgzW3K
	WrTZEY9d9ldxamBEjx+hSWNVZkVKjpK9BZpUo3LdZpMsDzhv/FwTscmb3pEG9S3ajaqFzE
	YIiCldKEMsQv3RrsqyFhGGjmfRtAyVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15D8C447D4;
	Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA119C2BCFC;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199164;
	bh=ZDf6KklUL1VJiJN35meAQReHtETf/ilTmtshGQq/oto=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=i9xNylgKls7bTuzU/eo6aSagb2pvXGi/fIn63P5z4zUY4YYVjwS5uZhTHjb/eQJ9V
	 qlCcVezEyplfnMUQCcyNjYVUM6htc+3yeYTg1AJVQ9HnC9fZb4ZBenynVSS04hLwpr
	 qjt1IYZT8NR7tg578FnJg+e7sgJNxbjk8gnyZZFTIbLOaIUqVwkHK8plHkWsXbW98G
	 gp6yNsyV2DyNyLti5ntQeNfA8g6Aoe2co9v+NkJJKdglCBLEbDYQSjX9gQXevDMW+t
	 9Id3oWmCGCbpKilFl5izs6E844k9QYG0IIe8MyfvXcn6W7to3hV55WNn4dtvF5IUoE
	 fmjLWwk1yOEPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E6EC98304;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:44 +0200
Subject: [PATCH v6 13/17] mm/huge_memory: move memcg switch into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-13-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=3709;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=yE5eu4lNBeWc96ndYU7jpzh4N9fRuY9dY8qKr7QXzUs=;
 b=IcJ3bl74clci/tOWp+x2uWCjpK7cQMm1RWbh4/TQ1A1LxhoxWtE6pwFJFItArBlnSms/Fm8R1
 77uxr2R3aH6Bs9C4b4uad7QTI2Zn+4yCPdU4GPZx/wWtw+S01ccME06
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Stat-Signature: 8fxq1efm87p1fkostr11g7rgim4wnykx
X-Rspam-User: 
X-Rspamd-Queue-Id: 888F440010
X-HE-Tag: 1790199167-440543
X-HE-Meta: U2FsdGVkX19a6C+A5ZQKPFDMJquKtz3NMsyNXgHTEj5F8UZlHtm02yQ6OdV/hltMeN+V4MWOmmDYU5oZG6q67DoaG9l7qbqKUou1Wth3jt3Hifm5GMSgW+5kkVVoGWNWDlSjMyLUxbxFXosuf4IgJn6Jej+wHjVsgvNBLjKfpSdW1qGphqumouQgdZ4Ax418zPgPJZcWJuAWjPMxUJh1By5LcifDbbRwT090N5L1iC2nOFJeaSdFuFiOxkaoFv7Y+Ajw1cqmUG1AU2U3jyt9plJ7gSv44HQWMasNHTO6SN9vPL3vtxUPQsRcA0a1RvM0l6ZMdNsxBK3UHNIIXbta+drCwIpa4a1K5KMFGxAT3b62UMEGHc4PEfdVvakvodhAVjppZmbQcRana5loXYYsWWpeBEy+FNdyLVaw2aZ5L5KYZddiXqP8V8e+8mbge4cWqrYtXfTl/zpz4pwo91RjWj2om59SHB4/crriUCbQAETicogxf8ClKMfzZQI1qLtOey2FTqIa2+ONcVynpT+j42wPTwDJX/c/G1Rjjy1WZ6XHKq8AFQmC437xjBZEN2BLUx4MnX6ghOmOknwaZ0ZtADuqYEyatmmYb5RP8yj1fH3q7p9RU9U3r4BUVgsZqWFTH9wv1wJpfVVcCk9BFaM7iZMt9mZjFEnL8Gjn2KqI9NnBTgaJ91Mh6+2/LdM1oR2gs+9eTM+rUkwLFZR+5WoDJzeebSWygPQk5wIcRwZy8zcMPrpo5gRh/iW51PeQ6fDiD3gAWpl1PuQP9Rp+Uu5fJg9emnXMoLS/GUHns3qgwPA5qk+rDCauBrRuIBBH4u8FBLlw69ey5B3Imu6NXa2N9hOUVtCOLl4PQd5HMKglJ72kBASt9JLK/vdhrZJ6NSYafPakYYq89MlvuAxVmsifHQH77fTiH5g/A2z8PIzJv+8rYBWw+5ZBqGfXD5ao5j0E/5/iPV2QAZBAroRzcLn
 r9QrjD08
 j6Rk1worSOBt2+Hd1rAwxjPnj8ByJMLspMAlpqSGqSKGlOAwAzEcpuWjm8nSRBHFbEjJMRGOMmqszfzlZwInMCa4OQAZhLVkYMyswie9ozNeqkA5qYY1hLgTcykxLMclpgFQ9ipzQkjTtwfrZmf2Ir4v01eIEnZJidAPIJy4qi2fGIJAOafVKB+Lt9xP2uqeGyKRnl9Uj8INHtN+i4+4tkoG/+EJLuscpN0Gq+QusrbVRagBGTmro5hCDj8z3VkjvEM3+Mwia6i2J9gvb1N1J0jXDPgR8EphLxO85gurPxGL3GZvGSdBLds7JLevTWXzVr7oEnhdBJ4EiH9eZzEzf63q1ly7aQU1TC25AA5AMeD0tg27iIAzUUXNITdfnrRdVBhNlz6xIX04/6kc9bVL0/eRnnBDn1YYzIYkZbF/2dbPmBjPoQ4/VfoZuEvMNJp7hL7NIxd/1UOSWP7d/7sP7mO4pYvd4JDd/l0J2PS0A7aqks1dfBhy3MuSRsWiwyTGomdwPTPIWbhVFC/qcX7p6ozhIAICDiYwF5HqlceZGS6aak3BEw8d6pnny/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The xarray node allocations in __folio_freeze_split_file() need
to be charged to the folio's memcg, so move the memcg switch from
__folio_split() into the helper.

The anon split helper and the after-split folio freeing perform no
chargeable allocations, so no memcg handling is left in __folio_split().
Rename its out_no_memcg label to out.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 62e2879cd3b4..8d43ee243b27 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4142,6 +4142,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	unsigned int min_order;
@@ -4154,9 +4155,18 @@ static int __folio_freeze_split_file(struct folio *folio,
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
 
@@ -4288,6 +4298,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 */
 	i_mmap_unlock_read(mapping);
 fail_free:
+	/* Restore the previously active memcg */
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	xas_destroy(&xas);
 	return ret;
 }
@@ -4319,7 +4332,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 {
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
-	struct mem_cgroup *memcg, *old_memcg;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4329,27 +4341,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4376,10 +4381,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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



