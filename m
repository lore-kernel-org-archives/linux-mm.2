Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D138606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H9sXzbHp
Received: by kanga.kvack.org (Postfix)
	id A1C3F6B09D0; Wed, 25 Nov 2026 06:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3F66B09CF; Wed, 25 Nov 2026 06:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8962E6B09D0; Wed, 25 Nov 2026 06:52:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 648B26B09CD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:52:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7FCBA8CCC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:23 +0000 (UTC)
X-FDA: 85473478566.10.D3B721C
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2129F1A000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H9sXzbHp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607542;
	b=BQXV6myZ0ReTg1GAI6SnvJ3Fb292o6EGn6BBvUQ3Ifsj/L9v/MN7Dxp4HP4dAbbAchVKhq
	aJe+4qvCGdydV3K0bu/PJdRjSYoIooSHB/KVEsPCa/azc9O6/L51/8bdA9RPt0s0hkFHjj
	1dBZpGWB6qo3X+7trtOoFHFCvuMUGw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5p0IEx85MBCR2rMVUw/i2xVs3HMBBruqecig4Rl8eII=;
	b=jE95iCxp4U0HznW1/ruUwjsjA3tvyPkUX0JsKbdTfpZoc3ZPT+bGBO/oNI0QlaVgCHiJ1V
	tFqZPotT48TSex0AygfzzzmZLpNhnIyp4Pmkf1X6PGvu+ResVLHGAVQljQZ8QrGVpXSozW
	3V8q1Tlc+bTDLU5gq6Dy/R63X5blMJQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H9sXzbHp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l51AocTvCZiNsdm2yvtVssGtJXg23uBwouU33MbK/tk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795607540; v=1; x=1796212340;
 b=H9sXzbHpOrt7N6isZz85TAo1KM1NEpj31DBDMComqrhvVdrPsNIsZqLd3bBqDhuxdF+SJzle
 H8scmjsxXxrwrVpIsGYO5UeJwAaavMzPmnFtWGrwhDaKBEVRLJn37kKVQvRzRrD8ZM6+f5PhgPZ
 5bBXI0rDkJphQhZYqFeQbTjI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 18911eca4fa8caad;
	Wed, 25 Nov 2026 11:52:20 +0000
X-Mizu-Trace-ID: 18911eca4fa8caad
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
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 1/3] fs/proc/task_mmu: read the PMD once in smaps_pmd_entry()
Date: Wed, 25 Nov 2026 03:49:57 -0800
Message-ID: <20261125115014.4014507-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125115014.4014507-1-usama.arif@linux.dev>
References: <20261125115014.4014507-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 4wrmw7nymo596owifnct8de9a65os4hs
X-Rspamd-Queue-Id: 2129F1A000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795607541-674877
X-HE-Meta: U2FsdGVkX1/t/f6cDeI7b3lqNlLM2tFj72WZKGnZX3D5NJh/oDlb1aL5dYhgl68XVOghIs2OmSzUiqSZNz4Rt6bXFGXil955FmVcDvqs7ecIFEI5l5HzsixxSaGFlrHru7h0iPojrBuBYeqqG1hq9q29AuP/Khh1wD4tfVprZM+J3Y5FgnE+CAueJz/D/td5B1QATHGDp7AeaYCImwhnG7eojeI6rgwZqfSiotJMVzEZtMJqzKV5fKnSbWFteUDu2R7pXNtq4Yh/F7UWQy1ODGQ/fq8e/smxsNacNlwvgGb6iQKkM+1c9by0bcSTXzZz0RTW+D0/UuJ53IfN5z2pVvFqfF1Ngkn3Zf9YrNim0rKI/lfRk9X1B4skiSjLZASucxPaLY3x8AEiQiQ7gc8AKwu6gj0vaIUDFX5MLs2C3VVYG6XZpnC6PmBWAxd9LVraNviQUjxvQ6F2/++2QFNa2FeZACP4GJG69gxN+pt8xidZkQIPYsApQbw6hHZBkj7XFccSfKVfc9yXEL5pOOVXJHB1ClL1AGKhOHkjWXpqW0A4ewgeNCR8VQLapiD+gZyom6ToGNYvMOiYpJAl6xWv/+AdE7p6gEG9E944250+GYJGrqeXnPPDqn9g7uXXRQgpCVbYUy065ujlBi3K88evhyLa35YGH+e5WV7jof2pH86eLLiSZkZ8nT0trSjSz7kPXphV6MMpCdhC0RCSJfohQMPLhev8HwPbN8HIStl5/G20N4WGxUwN+0XLN7NehxnwO9jRU5K+qxkq3xyTtiE+kGLZUvhN577qTbFArd0lulaHri1g1mH9UtF0Ys3WfvRFA0I7dwon+xhua+RSbmECNPEBQNqcKcxHQO6Lbr5o7lmOGT7mMRC9nYORvyhhHx3NXBnVQBXEdwPpriIIYge1ubcvs8UtQ4+yRUxogD/PTFStkJmg2nJ8ah7AQnAQc2vUmvVU7oiFa6Gegm553z7
 NLmItadc
 M+PcZoAGll3ZoKrT1/xuVbChn5f6mUQb95XehcC11homAUCKzJchUiQbbBdx1S9X4gzeNjKxsq2YizlkH/wMAPo5iYae/m8L+DluIYQ7au6pz21bmM4j3WrHIo0t2Y/T7cJQEi0bMtZ5EsK7j/I7LTfBiRWzg49/ovfPQ1mFPwbcYDZbWNc/4txA0BG6PqksVl8kS9xTiEOmooyb4Y8vwSm7Astw5uQixIk+fUmM51pO+RDgSsuWoLhwbARGI7HZS27Sf6yWCh/qMFtbIxgschdG12k8cfvAZIduCoD5Fz3nClusPcKvY9rXIjADrPy72NP2m/5m7cZkxhdGxlYLA1sWIE/XwklOFUVDVn1KidoXhmPPDawsZSRLgzk4uCwR1xJH7p4C22b124mV4/DuOlfGpTuRCkQ2kMktdHCHX5EcE+OI8yXjUluNxNgKjd4ChW7Jd0YAI/0eQW3TpBm+y7CJMGpQyKDsXJuW4R+Kmlacv6DE+pGOJFEuDqAsRHSoYVr5QpJpgd5su6yvoYSqCcRVhs/35z1S9ak5kb1bwM0vw45mZ7T3XQUW/2rZfpPj562va7UrRnti/n/01zLIR0xMAsKJOBoSTvW50
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
into a local with pmdp_get(), the way smaps_pte_entry() already does
with ptep_get(), so that every test sees the same value.

No functional change intended.

Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 fs/proc/task_mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d2a524c6ad4b93..cb5e335bf05da4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1022,14 +1022,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct page *page = NULL;
 	bool present = false;
 	struct folio *folio;
+	const pmd_t pmdval = pmdp_get(pmd);
 
-	if (pmd_none(*pmd))
+	if (pmd_none(pmdval))
 		return;
-	if (pmd_present(*pmd)) {
-		page = vm_normal_page_pmd(vma, addr, *pmd);
+	if (pmd_present(pmdval)) {
+		page = vm_normal_page_pmd(vma, addr, pmdval);
 		present = true;
 	} else if (unlikely(thp_migration_supported())) {
-		const softleaf_t entry = softleaf_from_pmd(*pmd);
+		const softleaf_t entry = softleaf_from_pmd(pmdval);
 
 		if (softleaf_has_pfn(entry))
 			page = softleaf_to_page(entry);
@@ -1046,7 +1047,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+	smaps_account(mss, page, true, pmd_young(pmdval), pmd_dirty(pmdval),
 		      locked, present);
 }
 #else
-- 
2.53.1-Meta


