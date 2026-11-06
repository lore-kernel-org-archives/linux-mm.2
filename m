Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E153606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6A76B05B1; Thu,  5 Nov 2026 23:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7747A6B05B3; Thu,  5 Nov 2026 23:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6630D6B05B4; Thu,  5 Nov 2026 23:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 304546B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:16:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E89BAA8296
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:16:49 +0000 (UTC)
X-FDA: 85403383338.07.2FE324B
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8266100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:16:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793938608;
	b=Z4Os9n/4ykhwmex2mBjSk62NW90OvwF8ZbOdbSsQXbj3owIDndr8vJ7eJUtUrvMBs3LqEC
	9tfrwWLdxFN1/GbFRxQljgefnAl/unJmETM++jnjO4f7BQKQLhgA08TLfMPQqSkmpUQVGu
	0TIcCQM43cIOOqJKl9BZrykgJBurCyo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793938608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=+7h44Ealm8F6r3GvegvUhK6yyPzSxh+/wV8eDBiBA7I=;
	b=LD+qeNWEhoxJoKomuxN5eroiHsSMpNNGN5RpSF9RTH6XY1qhCG/+89BOVJ24CgbAsDw/Wm
	VI57LCc0neCMOhveK5Jrwu+VMuZWyD4KbsyengB1E+OUn7/PPtUON0E+f6RNkTdLiYW9j1
	adIFgYR5FnNok3p5Z0jRSvJyLlbpARw=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jLQqD42rzz2tcQf;
	Fri,  6 Nov 2026 12:16:40 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jLQqD2D0fz2tcQf;
	Fri,  6 Nov 2026 12:16:40 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id DF15016E7;
	Fri,  6 Nov 2026 12:16:31 +0800 (CST)
Received: from qiuzhiteng-2U-Workstation.hygon.cn (172.25.64.90) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 6 Nov 2026 12:16:40 +0800
From: Zhiteng Qiu <qiuzhiteng@hygon.cn>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Alistair Popple <apopple@nvidia.com>, Xin Hao
	<xhao@linux.alibaba.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Zhiteng Qiu
	<qiuzhiteng@hygon.cn>
Subject: [PATCH] mm/migrate: don't batch the TLB flush when there is nothing to batch
Date: Fri, 6 Nov 2026 12:16:28 +0800
Message-ID: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8266100005
X-Stat-Signature: t9dz8rwd6i4p6etiidkxkjbrsfah1ntd
X-Rspam-User: 
X-HE-Tag: 1793938606-672758
X-HE-Meta: U2FsdGVkX1+3sKagq0XzPyLg4OhilLRFCp7DFicvNqUnU8jBAVqhJ2dq0ZQDc5YGaDJKjTSNHvqVFio+CNl0trxfnBU3fXC2l5KyZN1F/Nc5SmgEdbFdl2KOaqrvGVcHuhNp+epaiwvQjltYwJn2ReQhVHeFq8fvxaRZ9K/gVEq1obv7DM4XrPU7yXVMhbr0yT/8UtrpXHTSQsIEzeuziAnVLbtGNB3yl7oQFL61qCCb1AG4nSM2LnZL/f/6m7ko3GjD1SMGsRrTlBLvBOv7/KndMMYdGBbZs+6HE/Gkr5NxTjLymfMNXs2/uFxjQjoOQqgyZnmJlpnFa010fc1esZFlpvE7DicPFWbKzqBbvawac9wYuPLHicmnf+ixoTSJhsJBv2N+FMQK9vf7705F24JEhePYDA8MM3nWCF6vTw65cT39TfEi1pXGuFkpW0GPDQCgGD1eoxyaID5TQd1kiEx5dcZM1DLkflzdXM6lmxa8nLKC4OmE5znnb0VpxPblmNKgFWkojRfuPoTo+wjzL2opBR4VnoDM48E49d+fagjezA9WOsBio8Z5AfoBRtTk5tjR27cTIHcBvBvh7tYxrOrOr6mWtZGxG7ySEd80t9ox/OWFmpopMXRXaKZAIB2KSeB7k1IMDlNTBkB0aXEQilGBiNkSCTTqV0eACrwhbOKjvzADOVcIKM8nPi5m1QAaSK+Zf6RLCnRYyxat7BH775SRnAXsbzDGMqvMkA3fKgov7xBMEVgdOeLEppaMhiFIZP/L5L3ggJanFSrpGbPVJlCI6OO87p8nFMj5E6w7ESbE9PX02qwaKujwWAqW2LFjuY3TJsYh0yBcBEyPflCb6Q8Znu8IBScBNVV4jlFOG0rvPJjq/D44haeG9Tmz5nzi0ZRxeDzDCAbGWuXmFV2JuH9lOoJhcEabc/1fGZquC4PV8k2vs0DoeX1UQ6RMgbWBOKsC61VUbPjoCAGx82z
 8pqykArk
 32X4cJfyYv9XDp38T0QAmgvCvQPd86niQLkPAp9VIa+bVTujCN6d3Km/EVoMTgaDbxIiXVrEHSjJE7RcbDzSp7iqpr4pf45AybxebUmPu/0FVgEBA3CUunaw8lr9jrpzKaBTE4r4VQfTSq6mu/vX6gGiWNWayJUDrD9ZDKb1lC6sntb3ynsCo9AQUQUi4fA6jLEiVTOECpOoNAAs6vPyomVZAZ2NTfrTl9mW1mdNLk6E6Fd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 7e12beb8ca2a ("migrate_pages: batch flushing TLB"), every
MIGRATE_ASYNC migration unmaps with TTU_BATCH_FLUSH.  That includes NUMA
balancing and memory-tiering promotion, which migrate one folio per call
through migrate_misplaced_folio().  For an order-0 folio with a single
mapping the batch holds one PTE and there is nothing to merge, but the
flush still changes: on x86, arch_tlbbatch_flush() sends a full TLB
flush to every CPU in mm_cpumask() instead of invalidating that one page.

On a 2-socket, 384-CPU x86 server without INVLPGB, a 4 KiB-page,
memory-heavy multithreaded workload takes about 200 TLB shootdown
interrupts per page migrated by NUMA balancing (v5.15 on the same machine
takes about 11), and balancing costs it 13-16% of its throughput.

Skip the batched flush only when the batch cannot merge anything: the
folio is the only one in this migrate_pages_batch() call, it is not a
large folio, and it is mapped only once.  The rmap walk then meets at
most one PTE, and ptep_clear_flush() invalidates just that page.
Everything else keeps the batched flush, including PTE-mapped large
folios, folios mapped more than once, and the batch of sub-folios
produced when a partially mapped large folio is split during migration.

PMD-mapped THPs already invalidate their mappings through
set_pmd_migration_entry(), independently of TTU_BATCH_FLUSH, so their
flush behaviour is unchanged.  On arm64 the batched path only defers the
final DSB, so a one-PTE batch should cost about the same either way.

migrate_folio_unmap() cannot see how many folios its caller is
migrating, so migrate_pages_batch() passes that down.

Measured on v7.3: 120 GiB anonymous working set, 384 threads, 180 s per
run, three A/B pairs (numa_balancing on vs. off, same boot) per kernel.

                                    v7.3            patched
  throughput loss from balancing   13.0-16.5%      0.5-6.3%
  kernel cycles per hinting PTE    1.18-1.22M      0.28-0.31M
  TLB interrupts / migrated page   202-210         12.7-13.6

Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
---
Notes:

An earlier version decided on reason == MR_NUMA_MISPLACED.  That also
dropped batching for the split sub-folio batch mentioned above.  In a
test that splits partially mapped 2 MiB THPs during NUMA migration, the
earlier version raised TLB interrupts per migrated page from 0.13 to
16.1; this version keeps them at 0.11.  For 64 KiB mTHP and for a
MAP_SHARED mapping used by two processes, this version behaves like the
base kernel (TLB interrupts per migrated page: mTHP 2.2-2.7 patched vs.
2.6-3.3 base; shared 31.3-31.5 vs. 31.2-31.7).

The earlier version behaves the same as this one for order-0, private,
single-mapped memory.  These results were measured with it:
 - 192 CPUs (SMT off, 192 threads, 4 pairs): balancing loss
   3.1-14.7% patched vs. 7.4-54.3% base.
 - Memory first-touched on the remote socket, threads on the local
   socket (6 runs per kernel): no regression in time to convergence or
   in throughput after convergence.
 - 2 MiB THP (2 pairs): no difference, as expected for PMD-mapped
   folios.
 - A 30-minute run with compaction forced every 30 s: no warnings.

With this version, tools/testing/selftests/mm/migration passes 6/6
(including the THP and hugetlb cases), the LTP move_pages and
migrate_pages cases pass 14/14, and the scenario tests above saw no data
mismatches.

There is no Fixes: tag.  This changes a performance trade-off in code
that has been there since v6.4, and nobody has reported it as a
regression.  Please add one if you see it that way.
---
 mm/migrate.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 953af633ec..0f3404c3d7 100644
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
@@ -1344,7 +1344,18 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		/*
+		 * Batching only pays off when the rmap walk can meet more than
+		 * one PTE.  A lone order-0 folio with a single mapping has
+		 * exactly one, and on x86 the batched flush turns that one-page
+		 * invalidation into a full flush of mm_cpumask().
+		 */
+		bool batch_flush = mode == MIGRATE_ASYNC;
+
+		if (single_folio && !folio_test_large(src) &&
+		    !folio_maybe_mapped_shared(src))
+			batch_flush = false;
+		try_to_migrate(src, batch_flush ? TTU_BATCH_FLUSH : 0);
 		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
@@ -1835,6 +1846,7 @@ static int migrate_pages_batch(struct list_head *from,
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	bool single_folio = list_is_singular(from);
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
 			!list_empty(from) && !list_is_singular(from));
@@ -1925,7 +1937,8 @@ static int migrate_pages_batch(struct list_head *from,
 			}
 
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode, single_folio,
+					ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,

base-commit: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
-- 
2.51.0



