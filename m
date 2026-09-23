Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BAEC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEF26B00A5; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5146B00AB; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94906B00AD; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2746B00A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE99C4014C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:48 +0000 (UTC)
X-FDA: 85246326816.01.4139195
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3519160005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGvKKika;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I05rx4YQl64YXy5RgmxWIjaoBfZ8MzlGqH9DkYGfJPY=;
	b=bhfC4ktBR4dGVCoCQW7WfstCq7WZ9lvAi71xIB4/9byF186Z2N401ny6WzDzpTCOoTlKLg
	+nhp/u7xOhWDeisMw8gJZJcpYXeVGldRDlGXbcZ1h/vl9rFw+vPFdG/nqFfE5GAi+p+4PE
	X0FIkWgh6QNekcBSjDxsCoOD8AmOR9c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oGvKKika;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199167;
	b=syqPOlKRF+wkshx7fb3r+jLOF0jxHj44TGkgVol2uLU9SjpZB7PC0iFPBd4D2+h17htkLj
	D+f4BiC99fVeBXwZf/hjtGWy0qEDT4B7RCkj9+Vwd14ovOSq8mALyjhrHiXhRUVaqn1pb2
	YUitbK+obl9LXCfVPYpAIdepEL+fHq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC262447A1;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADDA8C2BCF7;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=3Q/WGYCD2V4+Spm/P1lmcpsO7ecYPfZ+PAIr13xEzSw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oGvKKikaOYFs5Ma4mmzfDRa6aQCJwUQIQjkmaR3o6FUuI3i45nQ765hIpbn3IN8PJ
	 eNE6tN6gmIoqW8QX8ihVMjLwVuEPVmrPnHqm38qo7EBhGnKw7YkSbFpoWtwtbLhBbi
	 XNF8eh9RpCYbXwuxF6SFiPqlkYrvaJoxoSEdDkFodEvPBIdR0EinxO8PyZql2Wk3kY
	 7u/R2AFxoJLkkwa9gvNWHPNmkRHRbuw743QF4QLz2WBryMXHkeIqvkPhqSs6rSPFuh
	 tomOPbgkrKqFaOJM2AWQ/jwVsBKun2PnC0uuJCnxZL0NO+WOyw0lJZpWfnV/f1rvUi
	 uETfjkMhZZs+g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FD1C98311;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:41 +0200
Subject: [PATCH v6 10/17] mm/huge_memory: move the racy refcount check into
 unmap_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-10-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=3793;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=h+PSQR1ffInIFUefUIt17YL1Yscv/2dT4X172Kq2ITc=;
 b=xrN0J9iwjrwqLhGirP8N5AQfDTl3N6APTqFL2dMa1Und10j1hlQbs5DqMisUFV8QHMDpllxhF
 OxyT4E+/2+IC3b9IhRgkeLAqnlYnSVM/x410yWjo+ygQPZSgbqM1irA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 1xoto7r4xg485kbzqhbobty9ub7pgpcr
X-Rspamd-Queue-Id: F3519160005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790199166-44325
X-HE-Meta: U2FsdGVkX1/zs3rmJi5kRWM8ExAQdtzl8ZZ5qjuejfIQNr8ZGRA9aPP2NHS1ZDFhgwgj7YrgiWpxlqxPiktAaEq0I6swHg+OsRdvmenY4SrnEpWYjP3rVKDAyFgEwtKsLzc6WpcqN1dxJ+MrDA7Qfzu9Z49iwt+JBCRyh11bZJuseNVZW5R692oqGAmgND4SY7ZLb89OWe/Jwtv8J5VwNzSGciyDyuftHPhX30KSkc+VWXJJKcA0g6QwFWSm0vS4odPpLiqnjau5wmY5UAXtzYokoX7elzrquRcXTVbGQetzmiYMTd83h4B+bqRNZCqysrP8SgudRoOM9el5PwdorQ/qxAKf9LDuyt7iqooYMgJ8DrkVaWueNbjGAFtKWXg4CuUmS50tl7gLWCNqMci5BAD4Lqt1lDekQpUExpCr4ExFLOdBU6eluTz14Oj2ovHNdYBwPKHLzyK+VJvt3X9g2wzW4S8FCJlOfZq/mZ5dMdw44oKKm9R8uddJV4TsM/4vmhDwoeLeNlMa2N8C75v37BIgpaGLQaQN6pxjHOAeUn49pKesmNorHzb4v5HULABHroQCubTmh0j5XznDiw67q7sDmwqfwuTTn0sfW77vfTT7Q8lcwVpiaW5hsvkTrpU1BEirY/sXflRHkjdFSPxkrFjBBCIIhP5mnuj4e1mlsGmaZHYdaauHH1wLTmbnwGiEvBgLF3cUKUs6S3851dfSeTvidPJCXwMb9guZ3P7vwPDpTi36aM3TYuUD6gQfMGnrPuRMSs3Umm1C6QTvTELjlolnizCqzqgzc+5QLkXkmFErLdVVN3mMxjo4kQKdAi0BDtq1tPXD0iwfHLI/tkvcS48+2MV0rHN93teLwyrGkrwjGHfURZh4DFrunHDTG4ImDDoxlVU+PxP2ZwHNQ1kSb5Z3SBRqR7/gN4JU6iJXGjFOHjZOjwsbYNeaMe+hCyAaAj+W6Ep+B+HpssD2YcS
 C5YFhCIb
 4bk2K6wIbbu3QHk+/jQfJmeDJ4n749Dv/CB9wNFnRZi6FyyWEXa7tbVGEHtvQVW1NRti2JuqN/xJRTAA78qs8P9N3KWxIHrfmtyJr4jiVbjonH0lO2R+IkzeYbGbmlkzd73MpfP5PlgbIOToFkgu5K3mt7N5xXzfd970Pcdin7IztriuO340KmQs0vhAgqPt1gyloazQlpbU8f3rX7HRbI1ZQYsD0ceeY3mumdAmA/96+ywj0d8zQ8HJrVA0gKVCk7wlP9pdlm2thvtahu+efEgdElOJLDwoRQgEo6z9/hukpZaxIZNioZzRMGLuWldNit8sNpqvdZlN+YTZqkcGgN/E5Eep/ctcULilFbNR1Sz5VB+MuiyRg3ZswMBIqwJU2bnV1Dd747hnJkqgdwOWj94tJxOxleHwJgYF6D0QKyRyQNKCqOdShlIi58r2JDr/hA7mAyBm54TQ1Nj9oSAV03hjnzAlogclbPVZ0Gq6lPCK0V3vvbJDuHbSIg5KuzpXhXvYAh4Z1uxZQJaQti0zRxEzOc4QWhoPE0/h2/s3BTOSGm970+VSbrWG5zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The check only exists to avoid the expensive PMD-splitting unmap of a
folio that cannot be split anyway.  Move it from __folio_split() and
folio_split_unmapped() into one check in unmap_folio(), right before
the PMD split. All split helpers get the same early check without
repeating it.

unmap_folio() now returns -EAGAIN if the check fails and the split
helpers propagate the error.  folio_split_unmapped() drops its own
copy of the check: it works on already unmapped folios and the
definitive folio_ref_freeze() in __folio_freeze_split_anon() still
catches unexpected references.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fa74fada0659..d738b25f50dc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3538,13 +3538,22 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 		split_huge_pmd_if_needed(next, end);
 }
 
-static void unmap_folio(struct folio *folio)
+/*
+ * A return value of 0 does not mean that unmapping succeeded. It might
+ * still have failed, but remap_anon_folio() must be called afterwards,
+ * for anon folios.
+ */
+static int unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
 		TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	/* Racy check if we can split the page, before we split PMDs */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
+		return -EAGAIN;
+
 	if (folio_test_pmd_mappable(folio))
 		ttu_flags |= TTU_SPLIT_HUGE_PMD;
 
@@ -3558,6 +3567,8 @@ static void unmap_folio(struct folio *folio)
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
 
 	try_to_unmap_flush();
+
+	return 0;
 }
 
 static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
@@ -4028,7 +4039,9 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	if (folio_mapped(folio)) {
 		need_remap = true;
-		unmap_folio(folio);
+		ret = unmap_folio(folio);
+		if (ret)
+			return ret;
 	}
 
 	local_irq_disable();
@@ -4122,7 +4135,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
-	unmap_folio(folio);
+	ret = unmap_folio(folio);
+	if (ret)
+		return ret;
 
 	xas_lock_irq(xas);
 
@@ -4326,15 +4341,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 	}
 
-	/*
-	 * Racy check if we can split the page, before unmap_folio() will
-	 * split PMDs
-	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4373,7 +4379,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-out_unlock:
 	if (anon_vma) {
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
@@ -4421,9 +4426,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_freeze_split_anon(folio, new_order, &folio->page,
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }

-- 
2.55.0



