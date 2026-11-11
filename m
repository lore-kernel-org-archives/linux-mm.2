Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91439606A333
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ol4gTM4U
Received: by kanga.kvack.org (Postfix)
	id D177E6B05CC; Wed, 11 Nov 2026 06:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC81C6B05CE; Wed, 11 Nov 2026 06:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90326B05CF; Wed, 11 Nov 2026 06:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95BBC6B05CC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:39:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3484F80238
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:22 +0000 (UTC)
X-FDA: 85422642564.05.4FEB9AB
Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1DC1BC0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:39:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ol4gTM4U;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397160;
	b=hbABdDWOsfF7rC+dq/K+iChn3HbTA8VUupzT3auefooqecmakaDB18cJVOa665UX1mM6Jy
	q5I0mmdkHxJPdN8xunBkbIRlV7qJyMnk6Bm/azR2rMUUwxu+IsNbIsjolm9AW8MXzbVZoK
	jSgx1VLHXtM0xD0fcX6H8HZwk/cXDtQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ol4gTM4U;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2saoVbYFwvaTsDZ1OYoBWs5gUVifzn045/gtvbvuIH4=;
	b=DrVLnSZo7Bo3xaEwpBzpm8fjtkKOepOEEUl9MGflRUMmaKtspTzIGc6u2SB+ry9Z8Q0ri0
	+T6MpdDQRu+qoYhitwuHlWV1LDiLz5Zi2uMFnE3RXVqAtOEU44MgVf8bf+7w8sZmhoHx+g
	brvl9EK7TGdrgQfEfJ/LkE8XE9fo7w0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RMq5jEADKeGNruhLoquiDuSfixBjLOzms6+A0cUPnr4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794397158; v=1; x=1795001958;
 b=ol4gTM4U5KHxFLvbS+cFMtU47Q7/IWQU1DlbzZnCaIGuqvVwK8Gm6MEkpVq4G7ECizDEl9E3
 uqh1sQmp0WJI5PGBncqlTXnpqiUpo+twikOuRi1Oi/DbxH7fR16Pyb9NWc8P1ZJinvi/KAEdaFq
 TeNsUe9L0cjn8h0t+pXt6vpw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2797f348b581f3be;
	Wed, 11 Nov 2026 11:39:18 +0000
X-Mizu-Trace-ID: 2797f348b581f3be
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
Subject: [PATCH 2/3] fs/proc/task_mmu: don't read young/dirty from a non-present PMD in smaps
Date: Wed, 11 Nov 2026 03:38:30 -0800
Message-ID: <20261111113904.650722-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111113904.650722-1-usama.arif@linux.dev>
References: <20261111113904.650722-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1DC1BC0003
X-Stat-Signature: s4y3co75juq5ebfafhuopumi98whq3np
X-Rspam-User: 
X-HE-Tag: 1794397159-716458
X-HE-Meta: U2FsdGVkX1/AzSbTJ8p1kUSwYx7HOue3Awo/obw76qlYyGjT3jzoNPDQt349z1wAtwyn1mkP6HH4F7J23U5YHHSRlDzempU5Z7ytSEkmG1MA9bJMDcFuGeWWah+q/yOXgsFkYSpMwh2fosDE17qTmoD+xXnmxI/d15ewcl/V6UMMtRjSXcjt06PT+tmDSzFN082cEAs19ER8XU3BBRAQBj8Z/YoDJBD4/QxvsU0DhcwDS3Q8YJpLuQapQmsouIKJYkvQ8bC/eAR5ZPLO4S5ccJ9iGI4Ml0yDDopDwMstDJXKFGPnE3k+1bg/abeFNx4pS/83WhW9K87Ud61oy9ZB18AETHW5HCehtw+Vk6rYtg9LtxlIYGohqgXBr0Oq6IHlHPcwmGYJYHmPgfAvWY4I+lW/iYiO62mtU7arI/3rYnSF6lduCDM5gudkSdItjDC8z+JlClZVLyes4jvcOAiQLeU9JiCqUQuuUVYGJ4Tfuo3UKiyQ7+Bn+jZGjYXd74y7FIs9k00GDe+aufRMidezvakVVlsk/BHhl+jzqxJEsgkc7m4+JGWmUkYNjTXHDnv99hZO6MMgrPhGcL4BvfwdS9ufC2hEvTfSvkG2k3d71B98/2iJc+ll6l2GHENOG2g8YgTTIBBxyngu4Tsxo7i3jyPtJl9FjewIZL+/0qZaJ6qizKqHt2/BmSp8o9bNZGPC6x8KLPZC+L+/GTq4mepzOVWDa92JwywOaZCoBkR24ntYTMeqtlqjEvQCwd6dVVLVufc9ZphM9L9HQ1QaXRZWi0IDSqO6VMqh5AcvEKMB4RGTKwY96/df0fQcI2QJ1AuHD4AQArPemx1SDRk7mEgq0xkSrAfHbfo0b+eLXlVTe6I004LjcDIBHaEAQJJI25rHprEYFR8vvFRdI9tGv3yXcYedI4pLCA4xaj/WQ52l+62j1+IhD68vAMiFQn/niaX+YVU9WmRrsJ2ob/RZoUu
 mFbbGKoo
 e6Hx+f/qYElUiC2mH3TmpS0hmzEL/8Smk8fmv+jpGMncs1vPLQ10/lp4xvXtldz8+VNFEhJ9Tnzg/+6UY/eOwiJxNBD1zPrQqb8KQeYVPPpqLWQXegZqLY8Tswhc/dLchnBUYUEFZgU203emaRrLQ6NdEjdlHJtOM2gyOAJ9z8t5euS6nvkEVwXB2sfPSu+VhdJEUsHhr+mbd3tc9bwKjUf708mSiz598aPv1sDBmj1xki9czYkjXspTN2dTH/fh8Tle/97fp97NlVn1wqW6pCjlXgQSOmzJQ6fGszhnNB0FBuYDzCr7P7MhQ8o3twLWQWLRo/6MbI+WrrZy+GP6mxA0qy4hj0JN0tzNQ4kmVUG6IjwA6oiwubQLzWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smaps_pmd_entry() passes pmd_young(*pmd) and pmd_dirty(*pmd) to
smaps_account() for every PMD, including migration and device-private
entries, where those bits hold part of the swap offset rather than
accessed/dirty state. smaps_pte_entry() only reads them when the entry
is present.

On x86_64 the offset is stored inverted across bits 9-58, which overlap
_PAGE_SAVED_DIRTY, so pmd_dirty() returns garbage: a clean 2MB
device-private mapping is accounted as 2048 kB dirty, and lazyfree
accounting is suppressed. pgtable_64.h also warns that the hardware can
set the accessed and dirty bits on non-present entries by mistake.

Only read the bits when the PMD is present.

Fixes: c94b6923fa0a ("/proc/PID/smaps: Add PMD migration entry parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d1..c0d391186c2b8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1019,13 +1019,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct vm_area_struct *vma = walk->vma;
 	bool locked = !!(vma->vm_flags & VM_LOCKED);
 	struct page *page = NULL;
-	bool present = false;
+	bool present = false, young = false, dirty = false;
 	struct folio *folio;
 
 	if (pmd_none(*pmd))
 		return;
 	if (pmd_present(*pmd)) {
 		page = vm_normal_page_pmd(vma, addr, *pmd);
+		young = pmd_young(*pmd);
+		dirty = pmd_dirty(*pmd);
 		present = true;
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
@@ -1045,8 +1047,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
-		      locked, present);
+	smaps_account(mss, page, true, young, dirty, locked, present);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
-- 
2.53.0-Meta


