Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09385CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8EA66B008A; Mon, 28 Sep 2026 06:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF14B6B008C; Mon, 28 Sep 2026 06:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B5E6B0092; Mon, 28 Sep 2026 06:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB3B6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:58:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2193614017E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:58:30 +0000 (UTC)
X-FDA: 85262872380.07.9025975
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A3DC180003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:58:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M8x1d1ou;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcmXusX46ZnjGCZm2P00Q/fqv8H94b2EYQaPdurCD7I=;
	b=ciECvUSzO39hYMbNYYCfdyyz5F5tgc2wlP8J0+YghXQ76jbfE1fBH8hCFGc0BlHd1XGgZT
	98ouF5cxjLEnMi6BAc1VvSejjk36eZfWCrn5rIKY2CqQJWQbgGSU09zNoUIlqOhPLcH9C+
	JTSfwWkJkil5OU8/+8FhpRltBaaqI7E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=M8x1d1ou;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593108;
	b=yoN40qi+AZ5tSnVfyYpsDqzFppXRORRu+V6D2/F/WfY8fkU76MRjLUHDRJrNIdmqUlSny0
	eI466BR7wdxLw3e8sUtvX2Jq7GybZwvKRF3Qq/yhff/oHfXl3xDaNylzbhbIf6jpehqNpE
	K8i10JGEkcjZMhYPknpRirAY8Hl2LSI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790593104; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=DcmXusX46ZnjGCZm2P00Q/fqv8H94b2EYQaPdurCD7I=;
	b=M8x1d1ouPFBpUXpzNewBFmFR2j/rI4ARYONZTMWcrHetJ1rv74TCq5HRBvCFDGzvDR8Iqt3cIiiTFkZ5A64XJ/KWcV02+B/MOA897GwXKNyK/PEv7lxY05lEFpf+jSMelKTvCRY6f3zExcj3F/KJSmd+CkJ6UfYiQ9lCpRIvHCc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XBma21L_1790593102;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XBma21L_1790593102 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 18:58:23 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: xiangzao@linux.alibaba.com,
	david@kernel.org,
	vbabka@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	kaitao.cheng@linux.dev,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/migrate: refuse to migrate folios containing hwpoisoned pages
Date: Mon, 28 Sep 2026 18:58:05 +0800
Message-ID: <20260928105805.1215770-3-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fenkqsi3mo7xam5396oj4qwtai3osmh3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A3DC180003
X-HE-Tag: 1790593107-899769
X-HE-Meta: U2FsdGVkX19aelKpVUctBXeh1OXXC2PZt/r5j5WZIjDfHfcjU7SpGx8C4G0WOIDrhljO+FMkt1r39MZqZQEkdQUbsAG2nW7k5ekwtyqdcRMCQC4feeXww9SRmit9acgquvQHfX9/VhkEGEt96udPDBQrAD5LEAa8pwSwQj3rJ1Cg10Ul/2vQTj2NS1VSKYffjhK6RrzzeOOKiIiOrS1gvIsgwAzorjqrdEUdTDVZU6Hn50O9IkBVuf3wnRliVrS1NvRoLn6yP8lvT7Tq2ErF9FficDT+Cd/fhCmk25U47xcmbykoUkm3vdsXyKS8xy6dT6H4YB3j5jpaSeEo+XuJIC59bHAGQODX2uptYqVuOujuLOss1EhkdVd9mReH1UrE3rb937Gxx+e8RWPnJFhtoBrK/WSI+iX6Bdfyvkv9VZ+FMmj02ql2Zvi6V3LA6O5l5XSGIEwzwVDpZiWcyG+any5Pvkz7y/SWF8H1Jpyf3bHF09QpXrgxmFlFDiPJMfFywnm8lznBl8mxwOA7f9Bp7RPam0ZrBWYSkLJC1Zwpmq7BAYPeiRt4VSIyDfCSJAkQrkSgn6d9QjniYoUKrhiSfVMzGz1TRVVl4JA0r6h1IdoV8AQoFv5zFnphFuK6cHFMOmK2+sC8dMyflHCTNBcWE77SPY78jQJ2BfApqpf5fzuumJ03CKofwaQHblv8BseBlanZhwgT5iaHtBWab2auiZK+MMuzZhQf2XOjobevMd4zssmJiTOWmfIovQRby3p8NCb5TiJMPjwUwUC4pR7XzN0s8+hyiM0JJQZTE8ukFDTwE0erM4FEY8EGX5rELN/U0yC9+roN2Ip6LB7Gj+/eWq9JYKjDkwtp2K1ZHw2APAQS++5qoDYSoBufZTYVpRhK7SjHLOgnlxQzsXYmu71mGLqVRw4BGXHGTdEPKlm55NEb1o7ddaCtvIgb3LjF9LtHiGdGzHoau22NzOtRnon
 dPbLJHX1
 qFgltthlJD/GZkjGooAONh+faQ2beY/X3W/yMUmDNwEJCzssRAPVvIN+g29Q26UXuNELnQXvcY9aytIdAbyfcgqsIMJxuYgIYJzpWnBvzCHLeeODP8Hp4EO7ZKFBSQhxIXE2J/Z+NIcTiI4Eu6moP5ZcjHkZw58JVS3FJkIceh5NlAPIHlcDJqZdPywcX1Qm88IOBWHXMIJ9WzP1gLR/6mGNG/CTyk2QMCRqY3xYkKozfkNw3+yZs82rGuZU05b5qrEVg7GiE9uCBPM8s2UTdSuJ8jOLneQs32/WQ8oKanJWX596IPuEAwwKEWdjK/Xu0LsWb212rsnJuSFiaNjPBtJ3ikt9tryrgZPWC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Refuse such migrations in the migration core, with two checks:

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

Both checks fail with -EHWPOISON rather than -EAGAIN: -EAGAIN would
leave the folio on the migration list and retry into the same check,
while -EHWPOISON is a permanent failure, so the folio is put back on
the LRU with the poison flag intact, for reclaim or a later
memory_failure() to deal with - the same reasoning reclaim settled
on in
commit 9f1e8cd0b7c4 ("mm/vmscan: fix hwpoisoned large folio handling in shrink_folio_list").
The hugetlb path gets the same two checks for symmetry and defense
in depth: its unmap-to-copy window is single-folio and much narrower
than the batched path, but the checks cost two bit tests.

Measured with the workload above (180-second runs; the count of
abandoned folios varies between runs with the race rate): the
unpatched kernel propagated 698 of 8426 abandoned folios; with
this patch, 0 of 9711 were propagated.

Soft offline is unaffected: it sets the poison marker only after its
own migration has succeeded.  Memory hotplug offlining is
unaffected: it filters poisoned folios out before calling
migrate_pages().  Reclaim is unaffected: poisoned folios go through
its own unmap and skip paths, not migrate_pages().

A check at the copy site was previously proposed by Kaitao
Cheng, for the hugetlb path and for move_to_new_folio(); that
discussion stalled over the remaining race with memory_failure().
The GUP-reference argument and the measurement above answer
that concern for injection paths.

Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20260707090136.52904-1-kaitao.cheng@linux.dev/
---
 mm/migrate.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..bdfd490dd8e8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1222,6 +1222,18 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	bool locked = false;
 	bool dst_locked = false;
 
+	if (unlikely(folio_contain_hwpoisoned_page(src))) {
+		/*
+		 * The copy would propagate the corrupted data into a
+		 * fresh folio with no poison marker.  Fail permanently
+		 * so the folio is put back on the LRU for reclaim or a
+		 * later memory_failure(); it was not unmapped yet, so
+		 * there is nothing to restore.
+		 */
+		migrate_folio_undo_src(src, 0, NULL, false, ret);
+		return -EHWPOISON;
+	}
+
 	dst = get_new_folio(src, private);
 	if (!dst)
 		return -ENOMEM;
@@ -1376,6 +1388,20 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
+	if (unlikely(folio_contain_hwpoisoned_page(src))) {
+		/*
+		 * Recheck before the copy: a poison can land while the
+		 * batch is still unmapping the rest of its chunk.  A
+		 * GUP-based path takes its reference before the unmap,
+		 * and memory_failure() sets PG_hwpoison before
+		 * releasing it, so a racing poison is visible by now;
+		 * a hardware MCE can still land in the final
+		 * instructions.
+		 */
+		rc = -EHWPOISON;
+		goto out;
+	}
+
 	if (unlikely(page_has_movable_ops(&src->page))) {
 		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
 		if (rc)
@@ -1521,6 +1547,12 @@ static int unmap_and_move_hugetlb_folio(new_folio_t get_new_folio,
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
 
@@ -1546,8 +1578,13 @@ static int unmap_and_move_hugetlb_folio(new_folio_t get_new_folio,
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


