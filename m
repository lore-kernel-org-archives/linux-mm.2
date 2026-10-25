Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFF1606A324
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 11:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hOcLwRLc
Received: by kanga.kvack.org (Postfix)
	id 163136B05B0; Sun, 25 Oct 2026 07:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114836B05B1; Sun, 25 Oct 2026 07:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029CA6B05B2; Sun, 25 Oct 2026 07:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D66C76B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:02:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 661A44056C
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 11:02:32 +0000 (UTC)
X-FDA: 85360860144.30.D462BF7
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4634740010
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 11:02:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hOcLwRLc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792926150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DUTntMFLiq6jmDgNXYwkRzUguppo4y+O9jg4Bo5aZxs=;
	b=6r0Kq95IsA7EiAaixXK4+6H7bFM/xo33cz3d1fPuOBC7Xk2jJW/JRq5sS1Ubtm7CJp6DAa
	KLBXNzHsFU5IH63XVL6h/ugLlSxSAX0TGmCcoyYVL9P8heK8n78/aaFPW/swO/kPj8ldmb
	cOF43nWQAH61ALWe2xXmKotFxfjFUgw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hOcLwRLc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792926150;
	b=orKhKg+DT8W65QwWF2Y/NFQi8fDCnilfKAoEcVY1uGa8V/h9zMl2SGMOiFEoS41MUCH9Jz
	AtSYYuZOSq3z0XlFkP/6hNt7bObbAMhr9y1cHRti+wJmKa9LspStsepHQz433IL8tXI0Is
	e9HUZYD+0rUPqHjjBNSGhpMvBgrpcl8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=X/BOrxpdGVtIrlELLb4mt5982rZ+vUeqKfafd5dzS9g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792926148; v=1; x=1793530948;
 b=hOcLwRLcAvZjzFQCrySkN+65wjIEWd16wddHMsGgnzIfcURCjbZTW9pLQwNtVMfnOpyrleUK
 1+wzIAGYxolq7EBcoB/g2qA9lwzaQO8dSRg51uU1UwI07vxdwFkj5KrOw/xUtQ4udRX7bV3SdZq
 b+vdjwhbSYMTlZrkMbQK+zBA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eab13870e0a3ee80;
	Sun, 25 Oct 2026 11:02:28 +0000
X-Mizu-Trace-ID: eab13870e0a3ee80
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm/migrate: move NR_FILE_THPS on cross-node migration
Date: Sun, 25 Oct 2026 19:02:09 +0800
Message-Id: <20261025110209.4105994-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4634740010
X-Stat-Signature: jc1ayp3jf91z3b9qamykri4wz686o8te
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792926150-950496
X-HE-Meta: U2FsdGVkX1/IeWwvAEePPtsXnu6AEIr5HUaD6VCJqthdC7q74zdurkM7zmhnlVeAwYuxYQSXMoq3cotaft0ia363Hm/gtP4pvngXjEu87+BXQyd+Cuq4a10DkWBYIcwTZUkLoABq2sF72LRJjOzQtYYVmgfUdt4fkD6DvhGM58KEmJRyAEnWK7cATLctCQkdeAXfZN2H1F0V4sLoC4LmXpibcruuknEY2LUJEoqHrcQLCjvzfokDyju3htAeNn8LezaltDiEw5XGVmogP51hDa89M/KOzt2ErWPYFRkLpuqqqtP/PD6eb0noGmOc/63SbWm5eAV3yxAUC7mUDigZhTdC5l4xwTaHLWGa0dQdqAMjxNREijh2/9dCB3GDxhek65pJohyJ+UHDhHlJttD0lBu+hnUG1W65DYOPxSLvdjdUBK3NvV/6ylXzCmpuYudlQcxDYU051q+0o6QEiBcZdYgkUdgpzJBkNeSmkfYW0ZUGiQy9wVEZGfI/9XcnBAikRaIcsy6NMxFp3nbrXMDy6gv8HN3hi5j7a1elrbFuUXtFOyDPc1du6JILdssQ1ah04kH8jjhUho9Sr4V49pTsY+rC7DvU6NaLxV7JowH3lrhhS1MOUJXbvCCjmKeVFipfLahbaWlYzgr/nIcfEq1+I+kfLwy5bvqcxTItpvqXPPKYB+b/HNZ/j1gJYaKnPL0CvqOe9bMpSmdzevr6COg2OHjKhiqWvl/kjBKXIiCmw6Consa4SZ2JmawbhcnFiTA9LPPx3R2FvAj0saGzhpQjKzkBaFXVCVqjfEcvcO9yQNh68fpJ4yPi1pGpsNzyT5XIHlRTKY5GXYWvi3PGNDmHjOVIiTix/qiHgHzJn3TyOzfBZ8bacVdgf14CEnx9jupT275SmWMZLyJZTvEpyPG+O407YdUCPKMKaegrTwbGueGjhZY+v2BpKEpnvre/RKTEbBkaB4AJYqVaNphfnXO
 fXzCH7SC
 J13oPV9u9rTiutXnrWytmNRmzNZspapUb3CDsZNz9WTjQxUYsSnBIqkcCaBtyj64fuKD1SSpGYGAzEyvNiHOa0usl7mvYOI/sQxP4iz4I+JfBISakbM2BPurEcuYvt462zXXl/rfQfTNqX90dpgWyfH1qMNdZWXYYr/hLZAQTuCKAlje0sgWtJ9YsyI4cxV7iW1qeCz4HVYMn3Wkuhqg7ZYhkmH9XJfqut+AruxcoxkjWnyO66555oEe+YhkAfBJAV9h3AIWRH+ofFNiLZpVWVwVQxxDInlmF6IyT+qaPCUWOUswcctJsBc4wPxAF9kr9TQTfnco8apQCMysEkihEXfwFnbhSGInDn6Tb0EVz14dFQfUMdCPDgD1naQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

When a page cache folio is migrated to another node,
__folio_migrate_mapping() moves the per-node and per-memcg counters
that are keyed off the folio's node: NR_FILE_PAGES, NR_SHMEM,
NR_SHMEM_THPS, NR_SWAPCACHE and NR_FILE_DIRTY.  NR_FILE_THPS is not
moved, although __filemap_add_folio() charges it to the source node and
filemap_unaccount_folio() takes it off whatever node the folio lives on
when it is removed.

Commit 0b52c420350e ("mm: fix shmem THP counters on migration") added
the NR_SHMEM_THPS case but not its file-backed counterpart.  Now that
ext4, xfs, btrfs and erofs can all have PMD-sized page cache folios,
migrating them via NUMA balancing, mbind(), migratepages, demotion or
memory offlining leaks FileHugePages on the source node and underflows
it on the destination, in both /sys/devices/system/node/nodeN/meminfo
and memory.numa_stat.  The global value is unaffected, which is why this
went unnoticed.

Reproducer, on a 2-node QEMU guest with THP set to "always":

  1. read a 256M ext4 file through a MADV_HUGEPAGE mapping while bound
     to node 0, so its page cache is 128 PMD-sized folios on node 0;
  2. move the mapping to node 1 with mbind(MPOL_MF_MOVE);
  3. unmap the file and drop its page cache.

nr_file_hugepages in /sys/devices/system/node/nodeN/vmstat after each
step (in units of PMD-sized folios):

                    without this patch     with this patch
                     node0     node1       node0     node1
  1. cached           128         0         128         0
  2. migrated         128         0           0       128
  3. dropped          128         0 (*)       0         0

  (*) the counter has underflowed to -128; negative values read as 0.

Without the patch the 128 folios stay accounted to node 0 forever, and
every further round adds another 128.  The same happens to the per-memcg
per-node counter: after step 3, memory.stat of the cgroup shows
"file_thp 0", while memory.numa_stat still shows
"file_thp N0=268435456 N1=0".  With the patch both are 0.

Move NR_FILE_THPS together with NR_FILE_PAGES, using the same condition
filemap_unaccount_folio() uses to take it off, so that THPs in the swap
cache are left alone.

Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
Note: prepared with help from an LLM-based assistant (Kiro, claude-opus-5.5).

 mm/migrate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..d55f576a2579 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -700,6 +700,10 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 				mod_lruvec_state(old_lruvec, NR_SHMEM_THPS, -nr);
 				mod_lruvec_state(new_lruvec, NR_SHMEM_THPS, nr);
 			}
+		} else if (!folio_test_swapbacked(folio) &&
+			   folio_test_pmd_mappable(folio)) {
+			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
+			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
 		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {

base-commit: bd1ecbb61afefc6a8b876ccbc31e9228b44e9eab
-- 
2.34.1


