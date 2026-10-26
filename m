Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7170606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=OrKYnxEs
Received: by kanga.kvack.org (Postfix)
	id B65E66B05B3; Sun, 25 Oct 2026 22:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF7B6B05B4; Sun, 25 Oct 2026 22:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7146B05B5; Sun, 25 Oct 2026 22:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B82D6B05B3
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:56:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD81C1404F6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:56:14 +0000 (UTC)
X-FDA: 85363263468.07.DC06B74
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9DEB91A0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:56:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OrKYnxEs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792983373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jHIZUyy+nrraPKzddPkSGZdeuR1XIOOSkmgtrJ5LEE=;
	b=KzdiWLNUOGNQxmc1QqIYT2ayx/nsYDyttovaxSPJp8dlQyhX7nrB7YpJvrhj55p96AfhBz
	T5Zjn4uWXJsBMfn2UmAQuxXRU+VhA+cEOrEsolm0JDDs0VPsa7+IvFgeZp+pmaAq+8zX1u
	xJ2BBZVqgK4SV1EpRU8EAjXXPYOVzxk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OrKYnxEs;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792983373;
	b=hfbwWHvWNmaj21tTNhnB7krcFFN0HS+fVjfQCPeoTZzzSMSwHmHjFXrWE32eHsDyyIYXuA
	YSuJDsWUIF40ZHCXXJxZeuGm50qPOVv8Q8z1N56lsjASK2JXxJUgi867YPSCxWMrpSXpg7
	K5hEV+PgaI1LcelCIpzHEKB03oVzqFk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792983368; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/jHIZUyy+nrraPKzddPkSGZdeuR1XIOOSkmgtrJ5LEE=;
	b=OrKYnxEsHqMpVeFouusziiY7JQzGeODdvJfETHohRZBd7TzhrvvHScZwu/quJ7AEi9EjHDSxD6LmxQGhN7h0IV5ftE2RxuqwR3PF1KiSTBS3ArK2yPMLM5kkm2tYZbLHoMkRPWXNnlieGPUsi/YSU8iRDfDH0VJD2RoK5lpyspY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XDRaMi9_1792983364;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDRaMi9_1792983364 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:56:05 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kaitao Cheng <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: [PATCH v2 2/2] mm/migrate: refuse to migrate folios containing hwpoisoned pages
Date: Mon, 26 Oct 2026 10:55:52 +0800
Message-ID: <20261026025552.1427901-3-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
References: <20261026025552.1427901-1-xiangzao@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DEB91A0006
X-Stat-Signature: cq9q7aqpjn869mg3r48tyb31rj1fsky3
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792983371-701509
X-HE-Meta: U2FsdGVkX19gWFYuURc9/6sThnmOXbdb3Tq8g9Ii5A2o79OntzLq3IRzgW+F/TvrPruZTQFuc7y4hnpTd4ydNurH5qnMO1XeXlzRfRvR/gpyPEc/J+vGHb3MgcbXkGBifnnKwwDnj/y2TyCeHhQiRaNPV/s3eOTouxO1ybPsb7La+3vVRWtGrqK/y6rf4S1NCHgSFZXijTYVh7JkM4yuBrmtlQGiXNFIy76vJ51oKzm7kjh2nyhFAK8B3e12Ss35b4lEjKur6wfmh8JB0/C+qOq3r5Zc1FmZJJ+OrJDvwmrkP+C7Va2/f7yp2qlAYx0l3tp5m+byKViuPf1388YcTX93S7SztJGbW5cnZGBvJybWzY7KiG2u5MCLPWdzmBqQV5bqOOgh9H+X7vA/lXaYPWeFeTG6VUIWwAVN6wty6uUk9huDTN+EoUR31AbaTAKoxTDM9K+C+D1UWQdns28s3AvaC7R3ptIM1R72Q1wpOuD8aOK26aWVTzFD3RZJxDfjn1Ls+Y7I4VdQIYwLggpGeCa+2A2hgsFkswYdFYGDNU+niJ7Izb2/T/CKc+95komFSe70dXqPyFwGTMg7L/b7TSkvCinFymxK1Zff+OR8mppmapKEBjcj9a0AgIWXcddAeRmVK9P1HgZ1pGtv2mCC8a+WCu6yxPbMYc6BrHyw7aCLIDM0FBQvXFH4H4ZADjWsyo+3W4EQ2Zo1vFOzcDRa4U+uyRGM2QLnnKegJEVKpJjhR3rxrzESoYO0w/pEMyDt3H5wF28fUn0gxyVq/2peJNkmv2zjKsSDKamsAmjlppX+gLwQ3B+RqTf8xA+L1mRRi4Nj0cYx5YvNjcaeIszjnV1omhxezkMDSdjXNZqJxcMPKO7dNxFmiABhq65CCV9RDllcHSaCZ5YCacYkmCdLkeGpWxFzsxqk32qk1F1Y2lSkbus6MmmFfKX80+8DJAp+oDrxFUm+62xdIMp+2Ze
 Sj/B7/6m
 wBVcygqKh7MjRYbjvVcHeQUkRQu24hIBkhAt5+nBJoOlTL7gOyPzMDxsLQju20clluS0VjEAlpe4vSRiKryAdGqWyzJLo3qH2wnT2/RAsH6Ch/I+C92qJ+AvvaWxvBjy69ULF37p16i0geFvSUeCVGKar6My5sIUJHumPKM1DuHY8ImHYm200Nadll0R5X6kA0vzUaNLsSohQF2drn2xbjkGuv06tJ5j3IE6AYlS+OHWcbvppAdyD0BdsJp8XYDzZJxLzcQHSuI8cVytlxSkRBWOHJBmSyPAZ6h/m9miOemzCVI+WDThTEX0dqzKMkUEGUDR6LrU/DVhVqykPsocl39R+0Hkj5tV2GsKQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All callers of migrate_pages() without their own poison handling -
move_pages(2), mbind(), NUMA balancing, alloc_contig_range() (CMA)
and long-term GUP - can race memory_failure() the same way compaction
does (see patch 1): the migration isolates a folio and clears
PG_lru, memory_failure() sets PG_hwpoison, then fails to pin it and
gives up with MF_IGNORED, and the pending migration copies the
corrupted data into a fresh folio that carries no poison marker;
the userspace mapping ends up silently serving the corrupted copy
with no SIGBUS.

This was reproduced on v7.3-rc4-75-g62f4c998b297: an order-0 stress
workload running madvise(MADV_HWPOISON) concurrently with
move_pages() left the poison flag set on 8426 abandoned folios in
a 180-second run, identified via /proc/kpageflags; 698 of them
were subsequently migrated, and in every case the address then
served the copied corrupted data with no SIGBUS.

Refuse such migrations in the migration core, with three checks:

- migrate_folio_unmap() checks at entry, so a folio that is already
  poisoned when the batch reaches it fails immediately, without
  allocating a destination folio or unmapping it.

- migrate_folio_move() checks again immediately before the copy,
  because migrate_pages_batch() unmaps a whole chunk of folios
  before copying any of them, so a poison can land in between.  A
  GUP-based path such as madvise(MADV_HWPOISON) takes its
  reference while the folio is still mapped, i.e. before the
  unmap, and memory_failure() sets PG_hwpoison before releasing
  that reference, so a racing poison is visible by the time
  migration reaches the copy, unless the injecting thread is
  delayed between taking the reference and setting the flag.  A
  hardware MCE can likewise land in the final instructions
  between the check and the copy; on x86_64 folio_mc_copy()
  additionally catches real-DRAM corruption at copy time.

- __migrate_folio() and migrate_huge_page_move_mapping() check
  again after the copy, before the mapping is transferred: the
  debugfs corrupt-pfn injector has no GUP or PTE ordering
  constraint, so it can set the flag while the copy is in
  progress, and only this recheck catches that window.  Failing
  there unwinds exactly like a copy failure.

All checks fail with -EHWPOISON, a permanent failure: the folio
goes back on the LRU with the poison flag intact, for reclaim or
a later memory_failure() to deal with - the same reasoning reclaim
settled on in
commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list").
The hugetlb path gets the same checks: its unmap-to-copy window is
single-folio and much narrower than the batched path, but the
checks cost bit tests.

Measured with the workload above (180-second runs; the count of
abandoned folios varies between runs with the race rate): the
unpatched kernel propagated 698 of 8426 abandoned folios; with the
pre-copy checks alone, 0 of 9711 were propagated.  The post-copy
recheck closes the remaining injector window.

Soft offline is unaffected: it sets the poison marker only after its
own migration has succeeded.  Memory hotplug offlining is
unaffected: it filters poisoned folios out before calling
migrate_pages().  Reclaim is unaffected: poisoned folios go through
its own unmap and skip paths, not migrate_pages().

A check at the copy site was previously proposed by Kaitao Cheng,
for the hugetlb path and for move_to_new_folio(); that discussion
stalled over the remaining race with memory_failure().  The
GUP-reference argument and the measurement above address that
concern for injection paths, and the post-copy recheck here is his
suggestion.

Assisted-by: LLM
Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260707090136.52904-1-kaitao.cheng@linux.dev/
---
 mm/migrate.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..208a3991ca06 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -749,6 +749,14 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 	if (unlikely(rc))
 		return rc;
 
+	/*
+	 * Recheck after the copy: an injector can set the flag while the
+	 * copy is in progress.  The mapping has not been transferred yet,
+	 * so failing here is the same unwinding as a copy failure.
+	 */
+	if (unlikely(folio_contain_hwpoisoned_page(src)))
+		return -EHWPOISON;
+
 	xas_lock_irq(&xas);
 	if (!folio_ref_freeze(src, expected_count)) {
 		xas_unlock_irq(&xas);
@@ -881,6 +889,14 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 	if (unlikely(rc))
 		return rc;
 
+	/*
+	 * Recheck after the copy: an injector can set the flag while the
+	 * copy is in progress.  The mapping has not been transferred yet,
+	 * so failing here is the same unwinding as a copy failure.
+	 */
+	if (unlikely(folio_contain_hwpoisoned_page(src)))
+		return -EHWPOISON;
+
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc)
 		return rc;
@@ -1222,6 +1238,15 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	bool locked = false;
 	bool dst_locked = false;
 
+	if (unlikely(folio_contain_hwpoisoned_page(src))) {
+		/*
+		 * Fail permanently before allocating dst: the folio
+		 * goes back on the LRU for a later memory_failure().
+		 */
+		migrate_folio_undo_src(src, 0, NULL, false, ret);
+		return -EHWPOISON;
+	}
+
 	dst = get_new_folio(src, private);
 	if (!dst)
 		return -ENOMEM;
@@ -1376,6 +1401,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
+	if (unlikely(folio_contain_hwpoisoned_page(src))) {
+		/*
+		 * Recheck before the copy: a poison can land while the
+		 * batch is still unmapping the rest of its chunk.
+		 */
+		rc = -EHWPOISON;
+		goto out;
+	}
+
 	if (unlikely(page_has_movable_ops(&src->page))) {
 		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
 		if (rc)
@@ -1521,6 +1555,12 @@ static int unmap_and_move_hugetlb_folio(new_folio_t get_new_folio,
 		goto out_unlock;
 	}
 
+	if (unlikely(folio_contain_hwpoisoned_page(src))) {
+		/* Same reasoning as in migrate_folio_unmap(). */
+		rc = -EHWPOISON;
+		goto out_unlock;
+	}
+
 	if (folio_test_anon(src))
 		anon_vma = folio_get_anon_vma(src);
 
@@ -1546,8 +1586,13 @@ static int unmap_and_move_hugetlb_folio(new_folio_t get_new_folio,
 		was_mapped = 1;
 	}
 
-	if (!folio_mapped(src))
-		rc = move_to_new_folio(dst, src, mode);
+	if (!folio_mapped(src)) {
+		/* Same reasoning as in migrate_folio_move(). */
+		if (unlikely(folio_contain_hwpoisoned_page(src)))
+			rc = -EHWPOISON;
+		else
+			rc = move_to_new_folio(dst, src, mode);
+	}
 
 	if (was_mapped)
 		remove_migration_ptes(src, !rc ? dst : src, ttu);
-- 
2.43.7


