Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 032E5606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DW2igUsU
Received: by kanga.kvack.org (Postfix)
	id EC1586B05B3; Mon, 16 Nov 2026 01:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AC96B05B4; Mon, 16 Nov 2026 01:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC0A6B05B5; Mon, 16 Nov 2026 01:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A78766B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:36:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34FA51604C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:49 +0000 (UTC)
X-FDA: 85440024138.07.FF1C3F9
Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D2A940006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DW2igUsU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WujFsV3gjG0i+ckuCGbgYSpPrbyh9VKnBFOmaysMMYs=;
	b=I64iSAncXlhuONlLoiNLgXDyYAuvL3jSWslo8OzqZ4mn6FpXR22Kg+bp2xMLRlWzqMjZG8
	/fKL1XUZ8RRELH8niBc/QE0Da6c2X5OLyOkL99W3EAYVzLpSwIXYmwWXmc+lceGGSX8vGN
	AZzxBOjYqKDY3jiMYRvIyiKBpaz4jyw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DW2igUsU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.89 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811007;
	b=zfrbtumUH9ADNBl47Ud2TeG42RM5txqzlUBNwVbV16+G0v+M7HNKckx0zbjtC7lUb6a8/c
	PtdOoc4ruGLO+N8bzrf2Ygc7rOL1Z9jnalQ4+pD9asmX3n7+43tQZGirDEEvuetiY89f1e
	wVj0LhRxkwegK3EZveEHkslN2ZGO/5Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x+ILKz6xxEiLKXXwh6DdV6s8+QRN9mKFDeJnW/pi2rE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794811005; v=1; x=1795415805;
 b=DW2igUsUcdPCFUbampoKKGdzYOJVukxdpiESWPBzpP/uohgZr3dixRx2p8TOgm95ukQmNXjg
 PZW5QoCDUrXNlEjvevxeCsh+Ehz83Unx1CEJiGF9oRJ6alKsSN6k+jxwsJIM0Fnu3ZcJ1zRyOjW
 IXk9rRaDpsbGGkf+D5yEngfM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 94084be275281595;
	Mon, 16 Nov 2026 06:36:45 +0000
X-Mizu-Trace-ID: 94084be275281595
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
Subject: [PATCH v2 3/4] fs/proc/task_mmu: don't read young/dirty from a non-present PMD in smaps
Date: Sun, 15 Nov 2026 22:34:57 -0800
Message-ID: <20261116063624.1382944-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116063624.1382944-1-usama.arif@linux.dev>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D2A940006
X-Stat-Signature: mitfkb7p8tzbon4rr8i7newz6xxg7uo7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811006-732418
X-HE-Meta: U2FsdGVkX1+4X0Hu1k8XAVkyf+BgEQbiaJMkXy2UT2UJ+128ud5gg74cz+G0XFhZaNRYibzolqsVc1yibJQS64w2ulPfLkRSpOQrke3sV4mobGgozJcCp5I8zq/vAaPLFnloJrLEa70/B744YurK/HKkCNKDwTWeWYIJVdvNvSyMFse3SSiYlUfTb6TTyPvV2uaSyzK20narHadPfrAMlpuKuZBTP4lsqieRVm1gI+AHde64zCIOYfgWxqztZzLwpg/yFgs4hM9tYVWehQC467EbqYYJAWCM1zOP75jBwpmWEdd/dB9lqjtkx25MUBt14hPWzIv6QlgbFF6/pmXBUCVTcOSfHwp/LhiX4n1n1qqweE1EDmVOBMMsDWBVUmxrh9JhNba90J5DiEbZl8x22DlKSdqh4jIyLZEtLtXCjhXvrBtgOqWNEfeF9t95UvWZhfkJzck/rQ6QnC32uG4aEMHx1iqfzHF2u/aEaGeJnmffML1oAKs5uH7iSAjVGPrxHjXHuBsN5Vx6iF67SoAVvXXHWC9NuAO5xyMFqApJfAEHj+PxUETsSpgDUMHKhU84nKDUnZeVVf1zaSZb/34uxei90sJo+5l0lORa/UT3WzmiIuKhDy2VByzNR+BC/Oo7Z92AJEzrtuKJI5ph0pA3Z2I4+NeEvWiBFcdKZOZ2gN1S7z0wFI7bamJBJ7rDIhFijtw7rN7LRgZIni8dMSM1VVEn/TSb3gYo1quMy3BMGWY85q4rfyueQ1+9yWG9quAkBkxVVWgXQ/ZftzXy+y7k3CceZnR9UO8QgBlNT1Jj2g+Yi7FseTIS7rdfBOovQmg30oxW8zTSOu4JlFDk5awSpowp8KXiDyP50vsRnnaWzk0cNFGPWwcFPzwl20UY93PYphlaRqy5k53tiFIxCCOUAsPXWh9epN2/VDWy05wWgEKVa0YX47dN/TSWLUKakGUqGDEyAhfmpNuBLGpDQZN
 /NeVethq
 PgHPr78nal6e1FO5CrtxDAdLx6HMndMhnunNPDKI82qCOC1leezsBqk5yNTIrDj+EQ1dV74Vocy146ChBxuIP69r5606u3rTEHB0j6yiyiv2JJKbEv746RNUcglYNWmsW4fwXMzQA2mkQSs85Ib5sSeonNJSVn6bqq/qVidQYeTE3HYa1IX3AiwuBc25jk5NltBbzOQhixJBh9IEKMpgOF+u0ivY/h+214C1k8/MG7eef3rGFcqzh2D4nPdN0ixOB4PSGmkEwtRFtFYCJZc5m9lG/z/heXj7MqT81DWy5IpDsjeT0oD20iB7ocxO1iIyd5o6WXUU2AmLvgaQshaEoJIttlX210xTac8bMxBx7hr77EthqCtMjnJcgBo/8ZoXpEOlhH0+zah0fw5jdNPXQdFLVB0ePHjU8Tq76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smaps_pmd_entry() passes pmd_young(*pmd) and pmd_dirty(*pmd) to
smaps_account() for every PMD, including softleaf entries (migration and
device-private), where those bits encode the entry rather than
accessed/dirty state. smaps_pte_entry() only reads them when the entry
is present.

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
index 164b4efc5e093..ad9fdcdaa2c40 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1029,13 +1029,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -1055,8 +1057,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
-		      locked, present);
+	smaps_account(mss, page, true, young, dirty, locked, present);
 }
 #else
 static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
-- 
2.53.1-Meta


