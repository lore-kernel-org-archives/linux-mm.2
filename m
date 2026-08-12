Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36B3C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BF76B012C; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD85C6B013A; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3466B012C; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13A296B0130
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F6B51A0410
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:19 +0000 (UTC)
X-FDA: 85093505238.05.36BDE4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 69CF71C0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4e0tfFY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CbgDNaqWUlW+9m3+VCQloSWZ5PxQ74IXQTXwqgpR1o=;
	b=M8gvEEVA6jb729G0YH3TsOxLt2xaO7DKOELVNJrHmnON87LzxoO0R9C5CSXon2tAVhdb+N
	zXEqh19gpPhAsMQ0N1IuRxLBAxd8F4hrlqYRuNP8xoNbozC7fLMjmC0KUjhoQvNbWML5V/
	3FRtish8swSxVazGwDn+MA/HJCdKU5Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4e0tfFY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560557;
	b=G9SJTCu+g0E1h++4Uf/tqunLds8aZwKZu3ziM2RPmYdtwNwuJgb31W81Wh10n4py373BGq
	vB8rLyimlKv1UyPtkevXOUKzWsxAY/TtXhmNzfRqCrF5GAHdM/5zTJNXTf7ihfKCI0TviR
	9lxUPYGmL1/Y/Sodskc6J4OVeA58+bE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FC9A440B7;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12637C2BCF7;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=13c9mdJfe6/pTFRb8RTKL8PVg3Isrl6dA7icVDAFEf0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U4e0tfFYoxdCuOspk2h3yyUZovB1vgdDQgTSW+nZhAujmuLMn++PCHC1w35xme3sA
	 GjkMXrRxgrU+Q/lEnvEHLOYKop32+LZs5sUJvwBrEsLdzw40ks5Um7wTbxbczxuouv
	 OZX6bEQ9ciKG/PU58+l7SNv4k7Svbcgbs+Yl4J99cGl1y7UGwBwGIPjhvj1L1sR6gr
	 8jWWDzydoFB/UUUJ7fW0Zq5826h4S0KsR68h8xahAM/PpDPuZLDpEYbgts+/UMKMjU
	 kkAN+Qrxl/3wiAkbsuJL3JiwbbyKyOSsACrZt5fhmAnXVRbSpYEyh+fkHdqs1xqCGr
	 qCUBKpxlHV4rQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FA7C5DF61;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:48 +0800
Subject: [PATCH v2 08/17] mm/huge_memory: move unmap and remap into the
 split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-8-d2ee48c6aa49@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=5602;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=JtWm25Dng3Mhqkcbs3f3Xwf56RRf8KwYB3EpO59ZokM=;
 b=INsZYrdAKljYMMdiEFr1eEUKBxnFmja12VRs97CQi/tVlEjpCg2GFaxG0LDMQC+l32JNFp5Tt
 GQVahCVb+KaAYlEBqvcMDK1kOB45i/Jiz2dtSIGig14Y92NW0hvM+zr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 69CF71C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: bsmkn6cdtwzhf5pzqe55fmcyum6g1zqk
X-HE-Tag: 1786560557-572413
X-HE-Meta: U2FsdGVkX1/ng2fZyy6Mcr+kxxRRP31g7pl/iHHnhXRa2ugoAuxvtuSlj7KYvuU/ZNcYM0zb6HhLC5xlEhFjYHXgQmHJYUvXVRT92aoJAInfbxNEJIyEGeV/w1syKyBOYkWcxoIIghOlx0x8SZxPTvAMoWZMC4JdKL6z1uGOmlXaistwX1p8p0SrN6aKXE7kmv2B0/vaUC5/6WSuTAGAwhpZpj7AA7rzgsDECCtSkvzG+/6Mr53xb1SziW9iIKS8B1cL7YtRp198lrog7hoSl6gx6Ph+CWfxer9Yl4tzbIqyHLlw8muigVMBpZB6LgM0teAESvQqyXzdKTflZJUWCX/DJZ+b5LdEjoY/6RJVwaHEoVpBffXP1KLlN8t9cGYHpPgvv7/fpKpflkfjyo1m3Xzj43w7tulYDgW8C2RkWOnY9d3/7zIfzaMka1cZ96xhW5vwtLltZMM2mx0veIqVf+FGrTkhMISk1zWsLQbLUDXUgde92LgxYLYSxNoqSfTuM2qNRJTziFjFaJ23vQY9hRO9P4WRduLOZ9CsGsOmcoWBj1cr8fEhoXpv/DV2c9uuH+KxJKbn1S9TQqv0c92L5FY8JiI3FeIh7noPLJw8rtrrQM9YaD2YFnD0s/PxD8m7wkEWYWZvHGtvp3tDwJynPUzowZVvVBjCZCO4JG2AnQf9s/ieXjqwsMC4yTDu/CdDlcO6ZrQ9hfWV6cbmhaPDfBl2rUxNXQEQa+6e7v6ct0/6NyVC0CIXCbrzieLXOM7etZAtDbZah3BeA3RZTMg4fRKyvuhT1RKGDAV3X1gzt8iUdaCtDvVYOOxMwhRfn2ddIX9TsYX+8XGj1ee63eTZiCUbXhZPQAlKvxkbgcQYMevQczztCSfdz5slDpg/OmI+lu3IL0a6TrNbQcFPw95bi5gijJFzVrDVO26x84xT+Qemrw9uH+9XtysGVNrg2pvR9Bpygf/osc2wWzAwuSQ
 H591jt6F
 Do0XW1SvmSu2U4T6+HbcSOnfnU5tOVZGTJ5eB87/jwwWU7KY86Uog09Vv8UdlhPBzeIvBBIgunt8sjVdcTBGWeghPikjJoyspMW0hX6BjJvDv7gmuG+3IHjlKb91bueE5Z8rBBnK3rnphd0yPgieTGESJTmpiTSUGoak3YezCGvjRbI2Rvif4u7PqaJ5x8pbFt2syFRSzmeNIpQip5mplvjunoRzYtC9dFki9il0l3eZ/tlNIHsMrMYwUR3Bc9hO3AA0dLFegSoJzKYV52pbK29fCMYoCiHZV1OjFl3JTWb6JsjWXzBDBmZ3MBps9Ad/CECOkgF20PaTYpgoV6b9BZpex44VfaCa6smq1WCCi1yxmEs1u8IXdV1SOY6s79XJWLWdMRDbXJSh039lppO34JFApSBLabvgPoLIbsA5QJcYoJ5I5Hiu08Woxab75YN2/DsK4GMwXzOa91FqyI3V5WxjYaCi3+MDv9tW2
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
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 43093b9a5bca..aa10a13bc255 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3589,9 +3589,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3945,19 +3942,23 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
-					      struct page *split_at, bool do_lru,
-					      struct list_head *list, enum split_type split_type)
+static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int new_order,
+					       struct page *split_at, bool do_lru, bool unmap,
+					       struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	enum ttu_flags ttu_flags = 0;
 	struct list_lru_one *lru;
 	struct lruvec *lruvec;
 	bool dequeue_deferred;
 	int ret = 0;
 
+	if (unmap)
+		unmap_folio(folio);
+
 	local_irq_disable();
 
 	/*
@@ -3982,8 +3983,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	if (dequeue_deferred) {
@@ -4031,15 +4032,21 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (unmap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
 
-static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
-					      struct page *split_at, struct xa_state *xas,
-					      struct address_space *mapping, bool do_lru,
-					      struct list_head *list, enum split_type split_type)
+static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int new_order,
+					       struct page *split_at, struct xa_state *xas,
+					       struct address_space *mapping, bool do_lru,
+					       struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
@@ -4059,6 +4066,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4139,8 +4148,11 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 
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
@@ -4180,7 +4192,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4268,21 +4279,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (!is_anon) {
-		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
-							 true, list, split_type);
+		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at, &xas, mapping,
+							  true, list, split_type);
 	} else {
-		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
-							 list, split_type);
+		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
+							  true, list, split_type);
 	}
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so
@@ -4365,8 +4369,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	return __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
-						  false, NULL, SPLIT_TYPE_UNIFORM);
+	return __folio_split_unmap_and_freeze_anon(folio, new_order, &folio->page, false,
+						   false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



