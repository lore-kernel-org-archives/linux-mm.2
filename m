Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBD2CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9A08E0007; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE398E0005; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766228E0003; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593688E0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:20:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F141160725
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:10 +0000 (UTC)
X-FDA: 84017492580.24.C0BFF17
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC92A14000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:20:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h28PtLuG;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760941208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ct2YqQdJvROl/g3jIPAKaCWvNR7oTLxHMVXkR7TJaA=;
	b=laGLc78Wr8gOYS3yftK/344swjRl8cZO4zTU6tJy0aQAJIeFIoo7K8Di1+LKdC9UqGN6Sd
	okWVAvSJ7oasx0Mnb2ZC/6/KViROvG0oLFU3tygEK4lTYlLEP+fFCrj3pNQOM5cQqvlH+8
	FQpcvjNiVYWD1Pbx+uGtft96x6QBm6g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=h28PtLuG;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760941208; a=rsa-sha256;
	cv=none;
	b=or1wvLVZsW99R2ZSbQSg5c739LQRlUZaKlOXA4XqpiTGrDO1T5z6W5tQHG4CVTUu8K8c6Q
	Iq1AXLvR2+0WNAri21lOqgCm/AmZgOsSHFFJtuN26595+WeBVCNbOh6Xv5SZmv+MsnWRJZ
	zYPq6AmavDSozO8wXN+1EtGtg58Krac=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/Ct2YqQdJvROl/g3jIPAKaCWvNR7oTLxHMVXkR7TJaA=;
	b=h28PtLuGnIU/WvrFYkgPPOyODJS74s7+FHdEPy6qq2Mnnv9InM7Mbrr2786sh6k3o/aVhclKz
	2RYYvULN/Cm57Nk/Fqq2KjvDMppVyv3HEH3/dg5I9Qe/DsbV+77esLlKyocFF6JQyyjjYMqI6bz
	Ov2xVQjDUl64lNG1XNW0j64=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cqlcc6vpmzcZyT;
	Mon, 20 Oct 2025 14:18:56 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 3674918006C;
	Mon, 20 Oct 2025 14:20:04 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Oct 2025 14:20:03 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for pmd folio
Date: Mon, 20 Oct 2025 14:18:45 +0800
Message-ID: <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DC92A14000B
X-Stat-Signature: 7nzu78p6u1mmszepunk1t65ibbcwa8q6
X-Rspam-User: 
X-HE-Tag: 1760941207-942868
X-HE-Meta: U2FsdGVkX18Cbb6hOn+kmg6siFXRs4o3sW46TSPicWyVkpbHHs3zehtTFO6nk3ZRfkR1jsWP7mfErerK5ORX9AvMVUgU9Jw+3UJk8yfHIKkacv80CvIj7qdDCL7HpaPZ7oWgyN+FpSRf+NeexAxzILTf0qeB/ib6EC3PP831go0PscXgpJVMcIwClLfm/T8jfkKM4d9t4bMQ28QZa2SfbZOgsU2HFqKMd+U3pt3QG4Rfr9A5Eq5Bl752Ifp/uRI/Q0BBA6xqLOF0TJSny6GTR+2Wvw+0UejLYmfYgQIKQ73p/+CudOPu1OJaC6ekjVp0BEQFV1TRTBAsblvA+zd6bejSFrGLRVbwN8drQyb3XOq+0D9Z4SNjAXQ7CJa2LieiVsgIOCEs2zbzJVTajwgya0tAGk8Jj84XWMvDtHa36+TVqaCZdZWmPlpw4BCdhXKNfIEPByTVfWgbc3XPKBs2HDjKQ9JTH0gBLFzG0B8r+7rQz5QwzKD3pCv3PZgvAuzbbumqVFAhJ8fUjyqYvqzLWSsfnMjE8zJVzICkmKwvo2Oqn0XiDwEIQIwUDSNRy09o8G6RHU6U94XPikWkOu3kiYKoPdZ3w2L1LLzCd4rqVhKj8O5ykzEQ/ve6KCOiGqUt0OcUFS0AUUzgDHZCsouNVmMcXjl/lAXkl4ANVgZgx6FUgSN0XrGy6/7Y2+hu/cNM2JzhJPfYtWiKOVnpDaGxxwTqnMcQd9+S3utfapfWRyKGFWF/uYYKLhaX35uQtZh1eN1kugFTNowb/bNQ2ovUEWiwracbIWB3MB0Rpg8Kn1Kt3QVM5AnYBa3IcTnMz6jTbbPLyvlfgcA5Q/6+0SHPojpxS5dta6ujoeVdr6kFhjFAoGxo0YhO+30S1j9bS00zb9nk2i9E7/sE+n+jqKlN/g3A9Vgs8GXzeiCgbX4LfxcygmXWoqkxIR5ycaucBbWdFs7H+vDeRX9ZJHgqX2C
 xnQGbcE/
 31wu0u8Gh19Vja4XwX3zwFoiHu2WAgDD1ALfhnAOuIyt4HmvVkFYuJrKmhlym74C2CO92EJxgK1BTNofjVk8+JBUxa5SKHFJeh7JF5y8jdHMf+duB4gDvIoPeEsrcOjg/+R8V1DuM7lCD4TJqFsjAq/vaU3F04on5J5cJ5yZn6CC52AKs2Zf2Ih/xj1Zvr7eEQxYrjrWZ10DLY1KIIfkqINErVmOsv8MrDqA+J1mjEshsoEBEmuqtxCeyrb9wEr1kAIbRLZ1nbZncKXOg97G9Jgl8HXNzqZG3qVSvy/iEbjNTzEESluPg7wWesd+kPp7zJe1GjRScGrwXB98oHuZIzV7eh/GR6EQxROaqjyxy3OclKao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_needs_prot_numa() checks whether to need prot numa, which
skips unsuitable folio, i.e. zone device, shared folios(ksm, CoW),
non-movable dma pinned, dirty file folio and already numa affinity's
folios, the policy should be applied to pmd folio too, which helps
to avoid unnecessary pmd change and folio migration attempts.

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/huge_memory.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2764613a9b3d..121c92f5c486 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2477,8 +2477,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 #endif
 
 	if (prot_numa) {
-		struct folio *folio;
-		bool toptier;
+		int target_node = NUMA_NO_NODE;
+
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
 		 * data is likely to be read-cached on the local CPU and
@@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (pmd_protnone(*pmd))
 			goto unlock;
 
-		folio = pmd_folio(*pmd);
-		toptier = node_is_toptier(folio_nid(folio));
-		/*
-		 * Skip scanning top tier node if normal numa
-		 * balancing is disabled
-		 */
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-		    toptier)
-			goto unlock;
+		/* Get target node for single threaded private VMAs */
+		if (!(vma->vm_flags & VM_SHARED) &&
+		    atomic_read(&vma->vm_mm->mm_users) == 1)
+			target_node = numa_node_id();
 
-		if (folio_use_access_time(folio))
-			folio_xchg_access_time(folio,
-					       jiffies_to_msecs(jiffies));
+		if (!folio_needs_prot_numa(pmd_folio(*pmd), vma, target_node))
+			goto unlock;
 	}
 	/*
 	 * In case prot_numa, we are under mmap_read_lock(mm). It's critical
-- 
2.27.0


