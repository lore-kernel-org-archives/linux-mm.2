Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FBEE606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C486B05C0; Mon,  9 Nov 2026 07:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A63D6B05C8; Mon,  9 Nov 2026 07:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46DE66B05C9; Mon,  9 Nov 2026 07:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17D1B6B05C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:29:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2044A6FC2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:29:47 +0000 (UTC)
X-FDA: 85415512014.20.DF6EEAA
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF43A40004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:29:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf12.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=plCEH9+gyrwSswtybTbWFM7xts9szEf9C+4KT3VZf9c=;
	b=tSdGLHffq9w+vKJobB0f+N+RGCl22zV4ZMWXXnOUVUZVEuVrdvLwAG6vhPeT7zaZHzr5Rq
	CtHYlENafWFUpajrMTylQzKkyxPOIiD1686sfPEdvY87BB8Uyk1IZNhScOYa0hHM8g8mbn
	wyCI94+A8T2PTnMPb3MFQxIa1ygCLBc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf12.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227383;
	b=lPRcDihvsa+++UVdiCwxOAEuWznuQmZ3MBr+lrpD7suOqTKObdBYUpoMigtlfQgicyE2wR
	vFDbvH0vWFUc7EG/P0UCHcJZ+Qa1iT6QL6uGMiXN2uUCKRI5jhQqLy65URHTV67YMmBdrq
	lWDiir9CI3jNyiWbXOvTXoyhzebV3ME=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jNTcZ3HyqzwHY2;
	Mon,  9 Nov 2026 20:29:34 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jNTcZ1NPyzwHY2;
	Mon,  9 Nov 2026 20:29:34 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 32BFD116E2;
	Mon,  9 Nov 2026 20:29:30 +0800 (CST)
Received: from qiuzhiteng-2U-Workstation.hygon.cn (172.25.64.90) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 9 Nov 2026 20:29:33 +0800
From: Zhiteng Qiu <qiuzhiteng@hygon.cn>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Alistair Popple <apopple@nvidia.com>, Xin Hao
	<xhao@linux.alibaba.com>, Dave Hansen <dave.hansen@linux.intel.com>, Yuan
 Zhong <zhongyuan@hygon.cn>, Shifei Ge <geshifei@hygon.cn>, Jianyong Wu
	<wujianyong@hygon.cn>, Shijie Huang <huangsj@hygon.cn>, Yibin Liu
	<liuyibin@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Zhiteng Qiu <qiuzhiteng@hygon.cn>
Subject: [PATCH v3] mm/migrate: don't batch the TLB flush when there is nothing to batch
Date: Mon, 9 Nov 2026 20:29:15 +0800
Message-ID: <20261109122915.2150586-1-qiuzhiteng@hygon.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261107143456.1590658-1-qiuzhiteng@hygon.cn>
References: <20261107143456.1590658-1-qiuzhiteng@hygon.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BF43A40004
X-Stat-Signature: xoj7h7y7m1z4dqg347f74fbig1dyjxfa
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794227380-777537
X-HE-Meta: U2FsdGVkX19vYlMbVAEyap/jyMkKt1bBrf//WfWGqpRJhWLZTTv25gd8GcgG7mSdCmxqAz9aTTk/1BoZiRZhzJKjOiDDQaO1V6QDsZsEgHx/gT8H6k/QdFJA5MKKbE7U3QvLv/yq6ML6xlH4YgwYH6t6aK5K0u9TZ6z7UDhASPGB1rN3xoCVmpsNbIb1+ZzFnLYh2ZFhW7hOMcbzhJKLcaeaScZENT9ZbU6Uc9vig/hkCitosAEFziPwqi/JEIjEHmluhRHz+W2vdN9wa6nISzr0aOfi6ubxJww9MIkPC+FpjD4GwvaUieR1ShIVEX6k/hBgat4gLNIkfMSAE6KP2+1BS/qOakbBw9MCZfB+j1RScov066GtLSOzq1iJK+LszDu5CwX0Lu5ybJy5xoia+iHfO4IDc0k0vKd1mZAnF5k8/+Wg5Xj6OSq/r3uSBQcQPyL2sMXwIsPmUCN0D8P4eTd/bDMVIZKK5OmBEqMu1oNZ3Tn04z/iSHtaJ77Ffm7NPoM9dLkfLq2vnyVL6Zt9sLSXMH3G4Bgmu5X1SfCOE3iQaN17HcDWir9kPQ5AYjvZjL3wCIbweyeZVsNvrkNECEhM1hwthkSiiKwyBBuUepDQBlvMbPD+RLWWkK7N18hAp9Wr18yp5auFDgfQT2Y2sK6x+7ggJ3XHT3neFsQdiZvK155VruRdnkbLbaSmeJkuonVY3KwNRbpD0Uebuamz/cxa3qgEhwI7Wo+F+3ayJdtdS61lUoaLIpd3hDmFSfqrrksX919yehRs7vhBULQM0SUEgf8hkpYohwFsOr9Sm0ew8WTeXevJ2gMCxiytL0BLJ1ANdhy4B9kq33Inr/viAAqN9dtZo1gGZdM2+/eS0sninGyRnhNJrZ9fWPkHSZWXKHpNgYr2ASR3vz7qXhCaz93gC/Ie1nJdrOfP6Gt6TAzv0J7lfeyCvtkRClpjiRp+mdnegfbUBa9gSX8G7ju
 uueV09t9
 /s2T3jraxPRkomFFL1ypWf5TfPT41NqE5tKtnjNTrRbjjxHq/FTqASKzwp+r+zPr1QeAx+NE+JTlud4fippZZQ2K33KtNGbCM3VDd81oPqSo7LlzJVbYA7XBu2PDtli9PMZbvSShKqDKx4jxL7pV3NXfFvqA+IEyJGzn2u4gzaD+80A3UWwc+wcpXmjWemLH8rFcFgVwTC1VQEJXxt3ihS0q2qqKWLtG8FvS+qBahFiaxrsqbgpD7ioeB3sh3D3O/AgQz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NUMA balancing migrates one folio at a time, but since commit
7e12beb8ca2a ("migrate_pages: batch flushing TLB") it still unmaps
with TTU_BATCH_FLUSH like any other MIGRATE_ASYNC migration.  When the
batch contains one folio mapped only once, there is nothing to batch,
and the batched unmap can leave mm->tlb_flush_batched pending, so the
NUMA scanner's next change_pte_range() can call flush_tlb_mm() before
changing the PTE table.  With migrations running concurrently, that
state keeps being refilled and the scanner ends up flushing the whole
mm for many of the PTE tables it walks.

That slows each scan pass down a lot, and mm->tlb_flush_pending stays
raised for the whole pass.  On x86, a migration that unmaps a
PROT_NONE PTE while mm->tlb_flush_pending is set gets true from
pte_accessible() and needs a flush too; with batching, the resulting
arch_tlbbatch_flush() is a full flush.  The two feed each other.  In
one run, 33% of the migrations overlapped a pass, although passes
covered only 9% of the time.

On a 2-socket, 384-CPU x86 machine without INVLPGB, with v7.3, a
120 GiB anonymous working set on 4 KiB pages and 384 threads (three
balancing on/off pairs per kernel):

                                     v7.3          patched
  throughput loss from balancing     13.0-16.5%    0.5-6.3%
  TLB interrupts per migrated page   202-210       12.7-13.6
  average scanner mmu_gather time    ~90 ms        ~6.7 ms

The mmu_gather times were measured in separate instrumented runs.

So only ask for a batched flush when the rmap walk can meet more than
one PTE, that is, when there is more than one folio in the batch or
the folio is mapped more than once.  Otherwise try_to_migrate_one()
uses ptep_clear_flush() on the one PTE.  PMD-mapped THPs are not
affected, since set_pmd_migration_entry() flushes them regardless of
TTU_BATCH_FLUSH.

Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
---
Changes in v3:
 - Use folio_mapcount() for the check, as Ying suggested.  It counts
   PTEs, so PTE-mapped large folios are still batched when more than
   one PTE remains mapped.  The only difference from v2 is a large
   folio with just one PTE still mapped, which is no longer batched
   either.
 - Cut the changelog down.

Changes in v2:
 - Pass the try_to_migrate() flags directly and use single_folio in
   the VM_WARN_ON_ONCE(), as suggested by Ying.
 - Rewrote the changelog after looking into why b99a342d4f11 does not
   avoid the flush here.

v2: https://lore.kernel.org/r/20261107143456.1590658-1-qiuzhiteng@hygon.cn
v1: https://lore.kernel.org/r/20261106041628.1177963-1-qiuzhiteng@hygon.cn

The table was measured on v7.3 with the check as posted in v2.  v3
only differs for a large folio with a single PTE left mapped.  On
mm-new with v3, one balancing on/off pair gave a 3.2% loss and 13.5
TLB interrupts per migrated page.

I re-ran the tests on v3: mm/migration selftests 6/6, LTP move_pages
and migrate_pages 14/14, and 30 minutes with compaction forced every
30 s without warnings.  Splitting partially mapped 2 MiB THPs during
NUMA migration still gets the batched flush (0.11-0.12 TLB
interrupts per migrated page, same as base), and 64 KiB mTHP and a
MAP_SHARED mapping shared by two processes behave like base.

No Fixes: tag, as this is a performance trade-off that has been there
since v6.3 and nobody has reported it as a regression.  Happy to add
one if you think it should have one.

 mm/migrate.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index cb699ea59d33..011cceadeda9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1222,7 +1222,7 @@ static void migrate_folio_done(struct folio *src,
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+		bool single_folio, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1344,7 +1344,19 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		enum ttu_flags ttu = 0;
+
+		/*
+		 * Batching only helps if the rmap walk can find more than one
+		 * PTE to clear.  With a single folio mapped once there is
+		 * nothing to merge, and a batched unmap would only leave
+		 * mm->tlb_flush_batched pending, making later page table
+		 * changes in this mm (e.g. NUMA scanning) flush the whole mm.
+		 */
+		if (mode == MIGRATE_ASYNC &&
+		    (!single_folio || folio_mapcount(src) > 1))
+			ttu = TTU_BATCH_FLUSH;
+		try_to_migrate(src, ttu);
 		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
@@ -1835,9 +1847,10 @@ static int migrate_pages_batch(struct list_head *from,
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	bool single_folio = list_is_singular(from);
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
-			!list_empty(from) && !list_is_singular(from));
+			!list_empty(from) && !single_folio);
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
@@ -1925,7 +1938,8 @@ static int migrate_pages_batch(struct list_head *from,
 			}
 
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode, single_folio,
+					ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,

base-commit: 56b90edee105e976d4870b9a048e6965dc0eac56
-- 
2.51.0



