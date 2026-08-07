Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C2CC5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870286B00AD; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846236B00AF; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623686B00AE; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAB66B00A9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CA531601CD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:55 +0000 (UTC)
X-FDA: 85075735710.11.15EB2F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84D25C000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnw4koTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ4RltvogMVxD6f6K0iaqMdL4sDym6zEVcB1BXq4qUo=;
	b=3uUtKPVPJjWHmPdMMGHdGWoHzQL/q8++N6Ax2rolAAvjqgXetUdQFm0VEj+7UNoWB2DkBQ
	9I/fsx8NnFU6SP/tJyKv+OqT9opyVM4OOPmglePoGbBRAMEBe63zdgYk539Ka5exrmUBm7
	wAKMn+IowZiAPad2kpdjDD7fTxh+Eyg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rnw4koTF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137473;
	b=keNgYXIYiLrMJWfIFJIoN+oHvSRRw5vRYhYHeD5OX1S69wGEXJdYC8+S3xwZYe7j3mj9go
	DnOgZBH1FqOmKKHGEp0m6OnrcC2JWxDb98Jk8AIZx8SuMtNWKEIVVMhzNaz2cefDNduCW9
	5Sj7B96zRmnablk3kysmMxsjetXFMB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A5AB4406A;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AE5AC2BCFC;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=BwmezivhFVZFocDKfY/PmLnAxu2FtilBaiVrvwrRpYc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rnw4koTF8epW9Q1mSzbuZ8ArLfRr2Q6HICHPDg3ZLhwNlM+qYKNU1dTYKhoVaDrKi
	 8IbtgyCSRbN4h38FYNNIgAgRXPgRRD4S3sSdyZ7rer2mWxVF8Dnx6fXsS2a5nwHHpP
	 +7blL5SrSJWmG6hTQi7Y2kgz3/MN20D95pCmf5PV/tSoYKYk8G+BJgmJ4O7csPY0zY
	 jEXJ8vBiG3WqSmwlH0wsXmvG/kDYtjknvhGaVTxH3MDP78yyf6N8T4dnUQTYIdM2Cg
	 Ab8b8br20QrjvDiX+pOQX5w6B5DWuQ0GboDJVZCtUnoaVEciRmZu21r6LDlsKMkhvV
	 URttBuRfqFD6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D41C5AC7A;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:08 +0800
Subject: [PATCH RFC 07/13] mm/huge_memory: move unmap and remap into the
 split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-7-689939a7ccc3@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=5093;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XdpcGLla7dWDxeaeoUQbxCu4Vf8PJ1zdPwmIqbBmjvw=;
 b=m8CSiewgW07eR4+Qa5gk6AQA4FGk9moAjQP7hGwJYLKKjrcBJIRoRtpKFRhbyMR95L58hhp4c
 ZxfbxvL3ITQCN2kJFkZqySU9ENT7pO4q4BKg/XlN1LYjBS8fDoFbxLI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84D25C000A
X-Stat-Signature: rhhqte784jw1zc43oh6nz76u1xsk3rxr
X-Rspam-User: 
X-HE-Tag: 1786137473-560644
X-HE-Meta: U2FsdGVkX1/a35k8s8AYSjtC4wcmFRtFzIuXMkV49JTa+ainnYw1vMnhF4gdaCXEdLQIkduyemZjKB4RbvRGjPr6wKCPjAiZxSug/kXzRkMmsQwkFpO15OO8Rvl056JQC/laic4uqF5053Hkpa8w3V1TkwCWG48UJpSbIX+uKcUuZr6QLXChkqgvmxvU0+jIFuUlV7KM0FFMvhmfqLDD1ygJwIbnLTb2h948HeFns1GaMSceiEqjTGCDTw9nmtHoKklPN7zCuh48d5rVaQl0PbpjUfylG7BWxhaMTcVgQOp/JKHE5fEz7HEqHOQeqEI8qB/FvHiEb/ruW0NBEYr1TbNfJWZp7Lys20UiH1QZYquSIeYr9kHh+lX1+tSO/U7EboC6A7d9oQmZF9qroRIEfCCfThQkHIaWebWDk18XBrJD4wRVvkX1GRwKvZQ2Wo7oqaz2KZ0gz6IWrTHSWDCKrx63O1jERlFkJjt2lwM1NkNVwT4fO/FtwnUOH+H9BvbNFi3l+J9umzWY43Ik2wUm0XyV69NqVpojNGMmXmQcrVPDnCKmvefo6+tA5nf8RCcCPqL6+g1cm/7KTEDTQWbSO6nB49sb1PDWpPoY+MaBaPHyO+G7y3oPoU7t4DVKZ29ri1NjNF0/kWhKcvG4mnn3CcYga3CQDOfLihp9iyAxZ8nO9R+wjDVdIceH98Fvbuois+gFHOYutsQkEtIlDRRQG9oBsnaos4A5KGpXxsbu7DPcyDgHCm8mj4THnlBriQp58jFl7hbHgkrjtE9U2SbSkbXrPXc7t+Xtk2+BFSZm73EksUHyBg2iELslDlreS8Cw8PM2/7AJ9JKr79BrMERQECwAw6frqZlYFVxft9muGeH1VC8h8PT4kRqMTIWVtjXP8TS3pm9IL1aQIssqipMpYBT5Wjt11oTX1WR5aqNSm3JPKwido0FMmBORsXLfzokmKs14Sg5H4FGGkuuQskV
 KgQeyAbT
 mR3k9uKJEYjcgnnUnM0RqMa0+Kv6gklzICH/gzWPlkWtpUAsVNHh0jHhYOYz39etWo92u1kKb+uoDYmBaZTULyJK2INtjZUrI/EvodaNSdkSDoUMmP9dCwds57mCGIzauxLaqqvXNWLXH49P8Oz1h9HWcJIqMfCqx/qDe3KobCyhF0C+eFfuqk5DJ3oNmXoaXL4CM5CJd3sruWFvpPzuI+dqcV6DUKXJUTq5KSIcSIjTl8CVq1YsLYz97Bs9lUjBxW+dr/Djw0b6suhS62ZCHxvbMR/z6TdVoi1R2fXIaLyYnNx4k/9z3cD/DZXKneFsSDqOh7oKSq35QpuHnuWQjlsrwTtIO+kGFMFMe28PuItFOiMHble89YMe2M7nW58ngSl7rz+NVyzjLQeM2SvEDgC8isANrA3FMXN02BQcsxWTmCFdgojjXXBuXMyup/dKY47hby7HCnFFgd04=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72f5d0d24127..c0115841d1a0 100644
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
@@ -3934,19 +3931,23 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
-					      struct page *split_at, bool do_lru,
-					      struct list_head *list, enum split_type split_type)
+static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new_order,
+					   struct page *split_at, bool do_lru, bool unmap,
+					   struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio;
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
@@ -3971,8 +3972,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	if (dequeue_deferred) {
@@ -4023,15 +4024,21 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
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
+static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new_order,
+					   struct page *split_at, struct xa_state *xas,
+					   struct address_space *mapping, bool do_lru,
+					   struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
@@ -4051,6 +4058,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4175,7 +4184,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4263,21 +4271,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (!is_anon) {
-		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
+		ret = __folio_freeze_split_unmap_file(folio, new_order, split_at, &xas, mapping,
 							 true, list, split_type);
 	} else {
-		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
-							 list, split_type);
+		ret = __folio_freeze_split_unmap_anon(folio, new_order, split_at, true,
+						      true, list, split_type);
 	}
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so
@@ -4360,8 +4361,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	return __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
-						  false, NULL, SPLIT_TYPE_UNIFORM);
+	return __folio_freeze_split_unmap_anon(folio, new_order, &folio->page, false,
+					       false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



