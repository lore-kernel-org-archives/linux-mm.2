Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433EC606A326
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 01:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3899A6B00EF; Wed, 11 Nov 2026 20:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A666B05B0; Wed, 11 Nov 2026 20:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2537F6B05B1; Wed, 11 Nov 2026 20:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB4836B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:04:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51F141C3C15
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:04:28 +0000 (UTC)
X-FDA: 85424671416.08.E73943C
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by imf08.hostedemail.com (Postfix) with ESMTP id 43D9B160007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:04:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794445466;
	b=AVLeWZyOkxZTwRSBoYXgJk/JS+buRAgqOpW0Q4zMWn1pE7zQRxo91SJ2O+mRn90oVTNpED
	OT/N4UMoV4oEpiwdh8vztxR2+wKui6Ekm9glN7Uh5Vyzki5xbxAyZ/JMYsP1MdA/a/RWJz
	qCJeXo6V1iFFwSigpxGxijfL1CxJ5FE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of qiuzhiteng@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=qiuzhiteng@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794445466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=godrn0AcTpKNoux8k0g+v99edPET2QoTMO3KwbRZ7w8=;
	b=BN8gicVUmFOu678DkJ6T9OwY0BCxvXvJwXWY26Vg/DXUhFeuuDEnmfiEP2HNTssprIp9EV
	e5vEbaC1A/zpbUTmnVDgeGMr946jY7DmKl9FQpJ10J+79bzXcV4SP3QcYw/VTGVBZly9cx
	ie2TtJPqf5Mc5gExNeyZWOCwzECqrEA=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jQ2GM51XNzVcB5;
	Thu, 12 Nov 2026 09:04:11 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jQ2GK48TJzVcB5;
	Thu, 12 Nov 2026 09:04:09 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id D9B8BDC2D;
	Thu, 12 Nov 2026 09:04:01 +0800 (CST)
Received: from qiuzhiteng-2U-Workstation.hygon.cn (172.25.64.90) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 12 Nov 2026 09:04:09 +0800
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
Subject: [PATCH v4] mm/migrate: don't batch the TLB flush when there is nothing to batch
Date: Thu, 12 Nov 2026 09:03:57 +0800
Message-ID: <20261112010357.2739389-1-qiuzhiteng@hygon.cn>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43D9B160007
X-Stat-Signature: wc6grt84j8w7wnb5y5knd66mcigb5atm
X-Rspam-User: 
X-HE-Tag: 1794445465-273848
X-HE-Meta: U2FsdGVkX1+MRF4XxeGrMxVu2WKQ+bmZjtkOw5fY3Pqb7fc44a3OYg+B5j1KVVsX+D2yhpqNILa5LeQRNOTqJ9urX11qnbotnsgcTyv86djhlaOEuQRMMtPbQwOBtF3x4pCGQt2ONAVngwEd4oJRdjw444gvMdH6e6K6OlWR0mLvv0Ornbz4kcyQSIMiMN45ge5d3SRvKhkyVS3x7ry8CBXStGB02vqLo3AaZY3yNImJFvRvsbdxlLknFi4fVwLw+51qMFy4w0pKMhFDMNg1cjtZ4UuomJ4xzOwAsC72lhMzhW5cdzIjVpxeK0rlxkP1LoMyB6gfm5OBrcE/Ul8dl8VBGEWigRUxp3Ph0i8xAkrdJ+8ImKILE4CHR9HJCpOdeEL/SSxp/Plnt7Mh5F9s+tD6UR9b87XPZ7x4nGUubPpTInULluPrKWO+qPQddBkMLwSV1jlrFVxVL6/dZ8wupmWLPwcmm13cIGkPCrJ+kpOa7yoyImY+iB4JUTz78ivNIMfR5mc1SP5nPM2MP1IaTO2rg0QZcXPFpt8GS/XoBx5Zjz/lfUFK8zh6ezFfbTj8RlrdrX3MH2ILkBdsGOAY56nWAnhnNSkDiIDiEl6j1+kL/J7vw3c4yzpRCvGXWXK8/a88TS1zWWZJjpsD4yV8Jr653w4MP5JhsVfjroFBGIIUjwE60vD9eS9FspJQYedkSCN7QBuHWYF/adq37mg6aQHgTzf+d8VDTQiakbmyg0IeN1BimzeWrXnhtqvbQ4YvjZeSazdWTIR9gU0hpJ64kWVit2iipioD7JlytSvt1wkzDBuF2+tVHDmlOEk1VzxoAjif0SiVQH0sfV+aK7HvOoF4HOtW0SJ/zla1+Ee3P7OqCA+R79qzN2FyHYI2WmdzeSQnmTqO5GO39jD8GRUWHLT6mep8g0NJdGROaOV51+eOGwUpS8IwNntThbHSOFAtPR8wUZPS7826nH5JhoN
 31Ew+lLv
 YB2TGVAiiaIkBjDKbDa+hwRpNzGJOj71EPWy2Oylg7wn6UO/rl9k7ja4StRvb+fHdD8fJgCwj0cb0cg1SbTqoVCI21d76dPHQMcuuYUpwzj8LhNNjAOT1jFaMwr8pmvCJqUou+7qdfe5ySuoKZkOM2GtLAQdsJqftjBkydj24QhUr1rOaVAOO8mLn5IHhjAMcUIUaA2JonxnS2HmK+x3LmJUFXERtpRRAE0TpaMFv2d1/JrwZIy7c9noXeo+ZLg1/zRv4
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
batch contains one small folio mapped only once, there is nothing to
batch, and the batched unmap can leave mm->tlb_flush_batched pending,
so the NUMA scanner's next change_pte_range() can call flush_tlb_mm()
before changing the PTE table.  With migrations running concurrently,
that state keeps being refilled, and on this workload the scanner
often flushes the whole mm as it walks the PTE tables.

This slows scanning and keeps mm->tlb_flush_pending raised longer.  On
x86, a migration that unmaps a PROT_NONE PTE while
mm->tlb_flush_pending is set gets true from pte_accessible() and needs
a flush too; with batching, the resulting arch_tlbbatch_flush() is a
full flush.  The two feed each other.  In one run, 33% of the
migrations overlapped a scan pass, although passes covered only 9% of
the time.

On a 2-socket, 384-CPU x86 machine without INVLPGB, with v7.3, a
120 GiB anonymous working set on 4 KiB pages and 384 threads (three
balancing on/off pairs per kernel):

                                     v7.3          patched
  throughput loss from balancing     13.0-16.5%    0.5-6.3%
  TLB interrupts per migrated page   202-210       12.7-13.6
  average scanner mmu_gather time    ~90 ms        ~6.7 ms

The mmu_gather times were measured in separate instrumented runs.

So don't ask for a batched flush when the batch holds a single small
folio that is not mapped shared; try_to_migrate_one() then uses
ptep_clear_flush() for each PTE it encounters.  Large folios retain
their existing flush behavior.  migrate_pages_batch() computes the
flags, since it knows how many folios it is migrating.  PMD-mapped
THPs are not affected, since set_pmd_migration_entry() flushes them
regardless of TTU_BATCH_FLUSH.

Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>
---
Changes in v4:
 - Compute the try_to_migrate() flags in migrate_pages_batch() with a
   helper and pass them to migrate_folio_unmap() instead of a bool, as
   suggested by David.
 - Go back to v2's check, limited to small folios, using
   folio_maybe_mapped_shared() as Zi suggested.  folio_mapcount() would
   stop being a good hint for large folios once try_to_unmap() batches
   them better (David).
 - Shorter comment (Zi).

Changes in v3:
 - Use folio_mapcount() for the check, as Ying suggested.
 - Cut the changelog down.

Changes in v2:
 - Pass the try_to_migrate() flags directly and use single_folio in
   the VM_WARN_ON_ONCE(), as suggested by Ying.
 - Rewrote the changelog after looking into why b99a342d4f11 does not
   avoid the flush here.

v3: https://lore.kernel.org/r/20261109122915.2150586-1-qiuzhiteng@hygon.cn
v2: https://lore.kernel.org/r/20261107143456.1590658-1-qiuzhiteng@hygon.cn
v1: https://lore.kernel.org/r/20261106041628.1177963-1-qiuzhiteng@hygon.cn

The table was measured on v7.3 with the same check as v4.  On mm-new
with v4, three balancing on/off pairs gave a 1.9-2.9% loss and
13.2-14.6 TLB interrupts per migrated page.

I re-ran the tests on v4: mm/migration selftests 6/6, LTP move_pages
and migrate_pages 14/14, 30 minutes with compaction forced every 30 s,
and 4.5 hours of NUMA balancing racing with fork(), MADV_DONTNEED and
move_pages(), 4 of them on a CONFIG_DEBUG_VM kernel, all without
warnings.  Splitting partially mapped 2 MiB THPs during NUMA migration
still gets the batched flush (0.115-0.120 TLB interrupts per migrated
page), and 64 KiB mTHP and a MAP_SHARED mapping shared by two processes
behave like base.

No Fixes: tag, as this is a performance trade-off that has been there
since v6.3 and nobody has reported it as a regression.  Happy to add
one if you think it should have one.

 mm/migrate.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index cb699ea59d33..8eb14b0a5d73 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1218,11 +1218,28 @@ static void migrate_folio_done(struct folio *src,
 		folio_put(src);
 }
 
+/*
+ * Batching the TLB flush only helps when the rmap walk can clear more than
+ * one PTE.  A single small folio mapped once has nothing to batch, and the
+ * batched unmap would leave mm->tlb_flush_batched pending.
+ */
+static enum ttu_flags migrate_ttu_flags(struct folio *folio,
+					enum migrate_mode mode,
+					bool single_folio)
+{
+	if (mode != MIGRATE_ASYNC)
+		return 0;
+	if (single_folio && !folio_test_large(folio) &&
+	    !folio_maybe_mapped_shared(folio))
+		return 0;
+	return TTU_BATCH_FLUSH;
+}
+
 /* Obtain the lock on page, remove all ptes. */
 static int migrate_folio_unmap(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, struct folio **dstp, enum migrate_mode mode,
-		struct list_head *ret)
+		enum ttu_flags ttu, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
@@ -1344,7 +1361,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		try_to_migrate(src, ttu);
 		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
@@ -1835,9 +1852,11 @@ static int migrate_pages_batch(struct list_head *from,
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
+	bool single_folio = list_is_singular(from);
+	enum ttu_flags ttu;
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
-			!list_empty(from) && !list_is_singular(from));
+			!list_empty(from) && !single_folio);
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
@@ -1924,8 +1943,10 @@ static int migrate_pages_batch(struct list_head *from,
 				continue;
 			}
 
+			ttu = migrate_ttu_flags(folio, mode, single_folio);
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
-					private, folio, &dst, mode, ret_folios);
+					private, folio, &dst, mode, ttu,
+					ret_folios);
 			/*
 			 * The rules are:
 			 *	0: folio will be put on unmap_folios list,

base-commit: 56b90edee105e976d4870b9a048e6965dc0eac56
-- 
2.51.0



