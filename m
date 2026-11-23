Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2F3606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MHRRfQJ5
Received: by kanga.kvack.org (Postfix)
	id E764A6B05C7; Mon, 23 Nov 2026 11:33:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27556B05C9; Mon, 23 Nov 2026 11:33:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C2B6B05CA; Mon, 23 Nov 2026 11:33:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAE5F6B05C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BCD4807D5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:29 +0000 (UTC)
X-FDA: 85466929338.16.F2E6E62
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F3878000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MHRRfQJ5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451607;
	b=ZkkXimGpZFi1mwyAIKvkM7rhq65ddtQ1lIa55KWNxTTv6d/PpN7aTT4LX01hIr2v6Yz8tt
	pUenQYaPRhTat9m7vL6J3lSO1z47XmRY7NcvFKmkTDtGIykGrk+FngMpypPMFm/PHmgsLr
	Srbn171U1wamwJuGgtXGhks8EozQ5f0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9eDeeGHvneVcVHv8eGQt7NvP+yVebJ4M1jCjgOsIRo=;
	b=kzDI2LGIYBac09VkvhOGGr1r/8g4UeEMQ4A/Qf5X+mrw6eKTKZ3KaIHLA40HXScLu2xsKD
	0cb+Lcl9Z6+ssqNrudS0lyarwz5zPoKp5TowgLSPuimHWK0zx3Z6Izq1xO/SiLBoCo5leR
	rLpjAiALB+Q6JWdiAvi4Ud603EKcMbk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MHRRfQJ5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FR+hMBYFdGTc92+lBnUmV6i3ZQeVFjYBAQzvw8UUU0k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795451604; v=1; x=1796056404;
 b=MHRRfQJ5DL0JlWl4tSD2UU5w3myXa04MuxoHRu4N892v1qNS9VlWoVYfjvlqF3B5Fbbivrn1
 41CYtj7vf8uih9IbM1aWPr0ZYCLG2UHK3Wh3X8i3T+3mpb4hHGypsUVBqAGgztUUdcw1/Yej5u3
 93aPJZ7FSeipr5x8t2ySBrxA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 90a87193e6a8bd2f;
	Mon, 23 Nov 2026 16:33:24 +0000
X-Mizu-Trace-ID: 90a87193e6a8bd2f
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 4/5] fs/proc/task_mmu: don't read young/dirty from a non-present PMD in smaps
Date: Mon, 23 Nov 2026 08:32:10 -0800
Message-ID: <20261123163301.1568240-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 4qoe6qzhzqj8krk4j3e6stymkwnd9cex
X-Rspamd-Queue-Id: 2F3878000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795451606-536065
X-HE-Meta: U2FsdGVkX18ZCxzvDVWgr9JYz6iTy3DNKCDurifyiLxnpV+9d3n3cxtKM+bBGk/MsYfVVsdsQ0b4N2OlZ9VKpIttX8FdRBHoLbdUyGlqJC+O49GeBHQWDANlsElDqaF0uF5px4KEu7denxzrq/mfqD2PkiZi1YOiJojpHMfVfJmDjpOk/UlQntXNwSkWl459itiITirWlCt0L3tfsZ/xRdwVZiPq0iDsUQVITCDAcPzz2+ZtG7eIpSNdsxlYPn1RnO8aUBig/jL/HBO6hhC7MxDBAQr0Na+tzQnoLaKJQf9aATCNDq1ZCjk58D0vjj6PGOQP3Si4tRyEgUFoazr/RssZBSTizfJe040MSrU1DXcTczaH+hG7hfblCEp5kQm+Ob4YyEKeZ6e3sK7YcEZJ9fVp4efMCgHFIe3MtGCN4Lpw9Gfl7t20bPg+RrEqYdlqN7xu57fgBJ8BxFC1p6d7sHivIehu9pEyH7WjoJlbKX2Hltq4jjfOE+xS4DogQzmS7MBcJmwO323wlNwb2nh2mwcwZJvldDHCUgo1XctPtE9G/XlRF196bJuGVOh2H1cZ603NpVGnrM8ibPpwxwcqoREwCAecOIVGMAsJIq2s3R0lk2l3yKkguZE6LJ9OF+sbxl6HqjddHPE8kTyGSU9O5ZDhy5NYnJJc/z+3fKBQD0dZlcTEhP+axfNacfxB3jgV7M4XLeM0ikV0zqCCHedAQUC+jMLt/iUKVzKgBUJVL6f6KXZiUqM0HFkWgxN7ds/wol+hkhyoyfwcK2MtcXCUuJq2w0qagFWPoMqDG1aQNB8YGPkjGI1+q+74YBluKqumiQtHKbm4l1uf9hXGxMH9CXYtVOrgFmt01aKQImpEX5kCjJpHbK/vQIKoPclB6jqUpp0l1VkZ08cTxTXzxWpL8QhQThYyWzMesZawhCXZFC/isJSbidOsQiFcsvpPKUVCqYkhdKJ27nIOPmMfBXs
 4yWZM+Ds
 4G7S/oiPc3hYf38gt9wJPdVWw2yHsS55YzIsLpEzk1wSBOgp+EtrwAH3xxyZoZN/dj4B4QjmZYUfmzTcDjLsZF8CT7YtAxQlFLBr1A+gn8/ObmNGOiz6UvxH7oLS/A/+um8V09LFfU+wBtWMm6/VsSJADtBMFKsF7D6WW14c76cqh75OGhVQtUI0Nk9cr/SPmHn8oZBmpFPCQ6gJtcrCCameIfAxpFgKgV1nLmrM1e8qoXrmuO9nMDcJ2w90o4iZAUtCZYU2B4f5fieK0ioCEVbGX7fI5jP6ufQWdDD1r4WQnIEnLFDwRbPHVSxetF7ALN+KooeIqb7dPUX7el9tcg4aEdAUfMmKA7hRdCY6Ln/e4PJeLYIfJTcacpoJgsE9hhlXVsLelwGQMg2J+Hgiykkj8WMkrRAB7xKJC3WCdD2s7mcAqwQTBPJPzZ1XY1/RwZVaWpSn4NVylPU/cfk7GS+i4QSrefeBVCN5BtsEtViujJnJKt073/diBYYCK63E+SWxz3+R3qKUyFGOl4C6V9QzPYF9dVYEXgT1vVNT71S3TY9h4Uya/pfmE+CqqHgA18M0QFFwZiQGfDhGMUzp7MjqV2n/pPdSlZ/oqdFKc54HsApNl3MEWJqEM4urdoiARo2KL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smaps_pmd_entry() passes pmd_young() and pmd_dirty() to smaps_account()
for every PMD, including softleaf entries (migration and device-private),
where those bits encode the entry rather than accessed/dirty state.
smaps_pte_entry() only reads them when the entry is present.

On x86_64 the entry's offset is stored inverted across bits 9-58, which
overlap _PAGE_SAVED_DIRTY, so pmd_dirty() returns garbage: a clean 2MB
device-private mapping is accounted as 2048 kB dirty, and lazyfree
accounting is suppressed. pgtable_64.h also warns that the hardware can
set the accessed and dirty bits on non-present entries by mistake.

Only read the bits when the PMD is present.

Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 fs/proc/task_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 105c4998eef48f..34aaf80cd46cc2 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1020,7 +1020,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool present = false;
+	bool present = false, young = false, dirty = false;
 	struct folio *folio;
 	pmd_t pmdval = pmdp_get(pmd);
 
@@ -1028,6 +1028,8 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return;
 	if (pmd_present(pmdval)) {
 		page = vm_normal_page_pmd(vma, addr, pmdval);
+		young = pmd_young(pmdval);
+		dirty = pmd_dirty(pmdval);
 		present = true;
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(pmdval);
@@ -1047,8 +1049,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(pmdval), pmd_dirty(pmdval),
-		      locked, present);
+	smaps_account(mss, page, true, young, dirty, locked, present);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
-- 
2.53.1-Meta


