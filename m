Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A1A606A331
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gOKGLvIO
Received: by kanga.kvack.org (Postfix)
	id 1F4A56B05B3; Mon,  2 Nov 2026 08:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5606B05B4; Mon,  2 Nov 2026 08:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DCC6B05B5; Mon,  2 Nov 2026 08:29:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCEB16B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:29:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FD74120C80
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:29:57 +0000 (UTC)
X-FDA: 85390262034.13.B7748A2
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf11.hostedemail.com (Postfix) with ESMTP id 73A5240004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:29:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gOKGLvIO;
	spf=pass (imf11.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626195;
	b=HDqWAdgvjw/N4HhWBrqYcH3PkRKlij5tljg8KAxAEidsXFmZq3miXez9/pVM4DbCtx15y3
	V0eTYHmhNxX1/rzD6rM3NisfE6wMO59/1UB2/zfEF4imJMo/XV3U6V+bV4A1TsXn3/aP+g
	AFx5rAOgQc4mlwRxFDBHZWcTv/f0U5Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gOKGLvIO;
	spf=pass (imf11.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWVE/AqRKRaVNddmv6NG+nhnU89aW+d0SMAU+Uuclug=;
	b=UEFERQjFaN+lTZLZStzCW1DAqrIkBlj2pgBBogVZl0qXZoXMjbMX70g5qkpErU+FmJL7dI
	NJnAJjydb2dmSsNQi0DA2PwwJp/0o3yle2yfoO3deR5BsvaApCUMR8FsDN0nN7aWH1N5HA
	wiDjOoHGMaIrjtdUbZuqzC4YlcMiNuI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oTSssby8yHdQ2jW4COWEzOnQpMmBT2IW4EkQbQx53ao=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793626194; v=1; x=1794230994;
 b=gOKGLvIOSmkS2OG+LA2rWuw8FXD4Vyi6jCqX/OUMEy3h1wFH5gMa4b0sp28yMfzkngp56N1p
 4k1YsUvgYns2foURZFG18EpK7xFQK5t5Ndl8wwk3wNCRHGjCMNrTOVfc+oi8WCCxdw8PQAD7d34
 zOYyIyLx4OpILSV7czNcJS9s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d9179c91a3ca1243;
	Mon, 02 Nov 2026 13:29:53 +0000
X-Mizu-Trace-ID: d9179c91a3ca1243
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: xu.xin@linux.dev
Cc: acme@kernel.org,
	adrian.hunter@intel.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	alexander.shishkin@linux.intel.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	byungchul@sk.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gerald.schaefer@linux.ibm.com,
	gor@linux.ibm.com,
	gourry@gourry.net,
	harry@kernel.org,
	hca@linux.ibm.com,
	irogers@google.com,
	james.clark@linaro.org,
	jannh@google.com,
	jolsa@kernel.org,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	ljs@kernel.org,
	mark.rutland@arm.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	namhyung@kernel.org,
	nico.pache@linux.dev,
	oleg@redhat.com,
	peterz@infradead.org,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	svens@linux.ibm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	xialonglong2025@163.com
Subject: [PATCH v2 2/4] mm: make folio_walk_start()'s locking asserts scalable
Date: Mon,  2 Nov 2026 21:29:27 +0800
Message-Id: <20261102132927.301921-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102132416.300084-1-xu.xin@linux.dev>
References: <20261102132416.300084-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ngdjqgokixmu7c7tu4ns1cjea3hkrkn9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73A5240004
X-Rspam-User: 
X-HE-Tag: 1793626195-820352
X-HE-Meta: U2FsdGVkX1+hMp1sSufKbrQcOGrQJ2+BCGKD/Mz740UW6HbHxBecTuoey1hdbiPhGIkW899ZG9QW+ePyz1AuAMThgQHDegoxTVKwek2Oly/KCAub1MAeWLR0DQvZjt72AsEEXbjsE29uPjbi1mY9JkbaLfwD2/PX6fHudvML4LxzyQv0buvU0PW5DgZATcIQKyQNWdi6kg/6IL8CXe199T3snEYgBopu9xZp8tAtYQ5hMmpICG8RvRJ3NlPpqjXSKzpFyT5vZgY7/w5trGFd0k2ROZaMjU8ep+EhNhROt+4wqzMwcUSapkkIWHMo2BYUSfqpGaOy9y8qRURZilVD+3InFQIs6nVzgRyPBU4K8BExtkNfVcnEPWqYgO2WIFRgDBMPtxdjry2R40VGF0ScjumePt96b3gr6/g/XxoruF7MSkaqG1tlHEP3e8vf3lT16R/3yR2l5UTGjo8WaEwQxeEqThss9zpborDmUkDpvY5MW0+PdwpFhvvM5YXWbb29YKV6HhHg6REM5CGtL/0/Dhf0ya8qwRUJsHlfHo/5NjiWSih/CCq4+V9CpUnz6x0rMdHZAMjz6hy23Q3NJDmwhaywBA5LBSNnXu0hfgBvJWbxaiQaGD6Mb0OQmw78Bt7O452ATyJ5iFBVNrjXvdzFXp7bSAs+O3XWF2ztZgWo4wm7jVzaBhbcIoMD43XYD2uToCapZOfNoA5lnzM3/7jzEorrdbQMyicAe863ePoSD9giCi6Q4b44hZDswEy6iDZK3EOKl1gueEFtBxFcb5i7pCuGZTmLBRedJATzxzANw/hdkNAa9AEgvgDM5JxoEGn6COC6n8xHJZuwwksMIoJplJJVUHlfuJgtfrH5U0FVm5iXNP++GRQvJuCdSoNyITwhfh3ETrJz2Vm7SpBH+mdWT3DVQ7NrKShu9O9IPoRaTJSfUwhFtFvJMQtkbBxhr8bmAwTP0QC9fuAHjQtxi3w
 O+tfKik1
 u2hKtOVYQkvDWAyaV0ErFYtnr8nmPxOh9GoyDEA8WPtE0LzZvw00ntTYnLpXJOKYJboX0OZbjLxpL3t7B8WgzbUYcBoYixf0Y7A0HrEHgnQXHAm0fz9C2msv46sW+MpcxvdGsIqfFYiUqn2gUV53MSa30JR2xhEvR9s6BYdXJdvgkeLEfC+2NQhInOlLkBGfvkPz9nn2mZpVbJJJ54pbWZnPv+gNNuhPlEcOMrdV6YYAd07h5Lfe1/NDcK7ytpUy5aCTZsKzhW29BmMt16cKQQbtHAEzmUG7RPMf6dE3g0uO3S4AfCApOk3S/bms5xlfapVFIJjPGKj8LPdWatVAGx/SMrBq5Axrvix+N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xu Xin <xu.xin@linux.dev>

Add an additional member 'walk_lock' to folio_walk to indicate
locking requirements for the walk. Similar to commit 49b0638502da0
("mm: enable page walking API to lock vmas during the walk").
But no change is made on any existing locking behavior,
all existing folio_walk_start() callers are currently still
under mmap_read_lock() protection.

This change is prepared for the later patch to enable VMA locking
asserts. folio_walk_start now operate under write-locked mmap_lock.
With introduction of vma locks at the next patch, the vmas have to
be locked as well during such walks to prevent concurrent page
faults in these areas.

No functional change intended.

Signed-off-by: Xu Xin <xu.xin@linux.dev>
---
 arch/s390/mm/fault.c     |  4 +++-
 include/linux/pagewalk.h |  1 +
 kernel/events/uprobes.c  |  4 +++-
 mm/huge_memory.c         |  4 +++-
 mm/ksm.c                 |  4 +++-
 mm/migrate.c             |  8 ++++++--
 mm/pagewalk.c            | 10 +++++++++-
 mm/rmap.c                |  4 +++-
 8 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 46d828926009..968f128a5232 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -412,7 +412,9 @@ __context_unsafe(/* folio_walk_end() not instrumented */)
 	unsigned long addr = get_fault_address(regs);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	int rc;
 
diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index 1c397be0d092..455428eaf1fc 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -184,6 +184,7 @@ struct folio_walk {
 	};
 	/* private */
 	spinlock_t *ptl;
+	enum page_walk_lock walk_lock;
 };
 
 struct folio *folio_walk_start(struct folio_walk *fw,
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index caf444762a27..3e3927109ee9 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -507,7 +507,9 @@ int uprobe_write(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
 	int ret, ref_ctr_updated = 0;
 	unsigned int gup_flags = FOLL_FORCE;
 	struct mmu_notifier_range range;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	struct page *page;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..62ec81396c9d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4816,7 +4816,9 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 	 */
 	for (addr = vaddr_start; addr < vaddr_end; addr += PAGE_SIZE) {
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
-		struct folio_walk fw;
+		struct folio_walk fw = {
+			.walk_lock  = PGWALK_RDLOCK,
+		};
 		struct folio *folio;
 		struct address_space *mapping;
 		unsigned int target_order = new_order;
diff --git a/mm/ksm.c b/mm/ksm.c
index d6f736a1aa2f..d4fc0b0965aa 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -819,8 +819,10 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 	unsigned long addr = rmap_item->address;
 	struct vm_area_struct *vma;
 	struct page *page = NULL;
-	struct folio_walk fw;
 	struct folio *folio;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
diff --git a/mm/migrate.c b/mm/migrate.c
index 875079464930..89662d5bedf4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2301,7 +2301,9 @@ static int add_folio_for_migration(struct mm_struct *mm, const void __user *p,
 		int node, struct list_head *pagelist, bool migrate_all)
 {
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct folio *folio;
 	unsigned long addr;
 	int err = -EFAULT;
@@ -2463,7 +2465,9 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	for (i = 0; i < nr_pages; i++) {
 		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
-		struct folio_walk fw;
+		struct folio_walk fw = {
+			.walk_lock  = PGWALK_RDLOCK,
+		};
 		struct folio *folio;
 		int err = -EFAULT;
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index e6493bbe6919..7d85289fcb87 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -910,7 +910,15 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 
-	mmap_assert_locked(vma->vm_mm);
+	/*
+	 * Other locking modes except for mmap or vma read locking are not
+	 * expected.
+	 */
+	if (fw->walk_lock != PGWALK_RDLOCK && fw->walk_lock != PGWALK_VMA_RDLOCK_VERIFY)
+		WARN_ONCE(1, "walk_lock is not expected!\n");
+	process_mm_walk_lock(vma->vm_mm, fw->walk_lock);
+	process_vma_walk_lock(vma, fw->walk_lock);
+
 	vma_pgtable_walk_begin(vma);
 
 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
diff --git a/mm/rmap.c b/mm/rmap.c
index 1131b76bbbc2..6e3bc2acd1d7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2862,7 +2862,9 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 	struct mmu_notifier_range range;
 	struct folio *folio, *fw_folio;
 	struct vm_area_struct *vma;
-	struct folio_walk fw;
+	struct folio_walk fw = {
+		.walk_lock  = PGWALK_RDLOCK,
+	};
 	struct page *page;
 	swp_entry_t entry;
 	pte_t swp_pte;
-- 
2.34.1


