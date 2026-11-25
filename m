Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1550B606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qsV0H+Du
Received: by kanga.kvack.org (Postfix)
	id 75D096B09CF; Wed, 25 Nov 2026 06:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF9E6B09D1; Wed, 25 Nov 2026 06:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538FA6B09D2; Wed, 25 Nov 2026 06:52:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8696B09CF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:52:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D32840EBB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:26 +0000 (UTC)
X-FDA: 85473478692.05.B72CFA9
Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	by imf31.hostedemail.com (Postfix) with ESMTP id B166520005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qsV0H+Du;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607545;
	b=TYUCdpJCHOm081WXSC7hKWn/i00tk729cTsKpgnuGg6vW5D2FZHFmOmTpRsaDZfoBbru1n
	feBWL60VYNvY1SyhvZb3CB5Rcp8499C7WdqtRDZf1mj1+LrSumHXa5OSbHrBrvJm5t8TD/
	b/EEbRkqfFqr4Lrb+XvfAad7BIfI8Fk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liDtjMCYWCVrpCiVXsPu6BPJfflyuRnHj5CWksRn/08=;
	b=pD7V+uA+yVB7uPqeSKvy6thTAoAQTPq3S/A40NqOUrZ9chk48TOYtBUyH5wZ8oPKP6csKn
	Y8qho7pjwN27nCoyQ+GdGvp8Ocy8xEyAK7BWqQOFcw53f8AKPIvHFhQ0sWAZ+KsVT2CaIa
	iFgHRrDVRvGC5qvmjkRu8aCBMKnBepA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qsV0H+Du;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.79 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x1fNkb2uruRr6K+ePqbhT3N1TY6nC237qiyCXj/fHh0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795607543; v=1; x=1796212343;
 b=qsV0H+Du1bSLyjc/3uRBuEtZ5JX5kwPH/tVg2Qq6WFrvNJCK9y3+RYZ2oeZVLpPyIoF/Ga0X
 EqGJK4NPXVejWAG+sRUeS0OuvSkDj5KYYKOteH7kqy8TYlQFVQeVgjLxjpEIuV4deI6m+fgT6cB
 7cxDgRcQIyTqLQMozAnyroL8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7eece8749f71e3f0;
	Wed, 25 Nov 2026 11:52:23 +0000
X-Mizu-Trace-ID: 7eece8749f71e3f0
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
Subject: [PATCH v4 2/3] fs/proc/task_mmu: don't read young/dirty from a non-present PMD in smaps
Date: Wed, 25 Nov 2026 03:49:58 -0800
Message-ID: <20261125115014.4014507-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125115014.4014507-1-usama.arif@linux.dev>
References: <20261125115014.4014507-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B166520005
X-Stat-Signature: geda6gh39jdw36ozn1i1ak3e9chjxeb9
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795607544-674422
X-HE-Meta: U2FsdGVkX19TuIxxsk7Sxf5m/QuXCA4icTs+PoU29YL0isnK+II4dii3ySaLRPfUBbAIqpQ2dhNKw7z/WOwI8Nh1kgx/ADD+OqEgGcTrnhYVdeGORY966UAPn4yAVBcD1/rxzk5AZ+iiAZRt5g2ijVQx/A7LeHbC0pTz6MQaNcDaOIvBnQtjrQocK+H8gqAfOJ6O0/Qxgd/Sd2aIQ7Fm49TM6ncNkTBFbTu7gGrbeHFtz9kdCSpOIywOsP5WZv8+6M2aHNk+dzsTaTeG2HXBtG9eypAht1ODYb3oDukfHJ3wcRUn/mAA30KvzguuW4MbaJXgKxOOjP5jkc2yywK+cr9u53e1SLj0G5PjeNRDLi/90KtU9otw9J2s+LVxFvwnAajt4XDL40KSuvQoDJYGVE/X7s8avVd/qndC6CxjY/j96gdn26aPiNvtp8JVq1buCY3veNkIw58Rew8K4umt+6rGZpljhoNTqT+CiVZWmSn+TmDtzAYdHlN/z5rfVBY16eIRucSqlHtgEAOvt7LONXyeb7QT0099WMB+cFjdr+NBva8fgYkujmuOiYw29rNbOYiWlczBOI8pmkvBcVEpuan3LQe99ov+yWoPdleJwFWPlyXVnh6BxOm+eGywlDz9LP6KnjzR1MS9gXvflL9tJN4oHEwgRDe7hOCkEvsx83m2aY8gAvEIZg3wDUCK736jAF71+xb8AV1QxBmPvalkX5gGgRZTmWw/FBiOvfl1QysZqedQprV6POU6rYOZO8jCjelU+Cl6LouqPEMbWTvz6cfW+JaAfkHby17CBjagAX/7hrTU8ohCG09Pn5M06IOQUw+rgC7DTyLkcCOc5n9K/BcAF7gRJBS1hk9Xu/ZuEF8qXaUrPOx64DoIx718UguOGlpkbpwc7GW+OCF6ffB3cIQYQeRIo40yFdYycjoUgHvGLlmG8JjVIi2xjWCyQuYv0u2mprXZzedXWq3PBS0
 u7xGl7GP
 2bwT2ObBEnjJggWHm1uEn9iGgoh0LTE+1sTE8VFXer6uykMYmYYqdHL60Y3VEt0hjzSvFL7nIOiCqFeAZEo12Nequ3r4918oWrSEakb2+jkHn4B0CmhKlDD4ESyoqW4yoO6sI6BlfE5zkgw/ZF3/BneiD5TTdk8ivoZBCS0AZ1CYfBlEDb+rSPuLu9rEDpRAoNN4djm3SthokmeiihA4d598HgutTD1WJt60A+xhNH+jJWqSuGzONKHLbHIHJF838qEqas+JyiAbLDTxMWltDG2yI9IYL3Uk0saf8Vpr9opa7s9QRFfV5FpBmw1WhVEnDHv8dp9cDQtVf9Ft0w8YjZpSB0MKMhufiFMu9q3QaIPHP3SArkqhCL2Hyw2Fj0BG/hrP4Eo+q8l5t6cCBiC/Erl269KOWzph1DxFbsfqmPy5/qtnHlQp8oGg1CjhFSolJplGW5tzr5FhtKtBjKJmayX7bj4jCQ6QpIGgGM/g01LmzjcoWO0q/kOur2ByRlkRFFOrthH2iakOUoR5izc04x4jzcT3eaR53Nq/r0Zat6x6tTk7E/zrJp7Hqt2R3j6SJbkflIsovIYsG1HtK3nWR5uqObxK/SpsFTJelxYs0qDJrj403JB1yhwFrpQ==
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
index cb5e335bf05da4..cf1732935c73df 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1020,7 +1020,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool present = false;
+	bool present = false, young = false, dirty = false;
 	struct folio *folio;
 	const pmd_t pmdval = pmdp_get(pmd);
 
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


