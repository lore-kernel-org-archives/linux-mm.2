Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A485F606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzRS1V51
Received: by kanga.kvack.org (Postfix)
	id A25B06B05B7; Sun, 15 Nov 2026 16:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D76C6B05B8; Sun, 15 Nov 2026 16:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC5F6B05B9; Sun, 15 Nov 2026 16:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5226B05B7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:00:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBD1880850
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:00:02 +0000 (UTC)
X-FDA: 85438570644.10.A06465B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1BF8680007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:00:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzRS1V51;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794776401;
	b=1eEIsGFKEK03Hwm9CFk5zI8Qdok0F7Nl+15AHKvwQXamjejfsLrze746lieeMtplaZSv2D
	9jLVWgtOYTUSAvmr6RscW1eRGMwXW/pM+Ln8vkRW7vO6lcUt2wTy2wOJBzpQ2UV6XbCxeV
	ILv1V5uGTsRG9WaoI261C+rDPSYBaSI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794776401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+bR5cBurono24Kw/wb/TbttycTR3O4Q2jD2NlUXMHg=;
	b=uzbJ8pG4/vW31V4VGhVIHi+vHh6CJ2Jvt1lsckwz7SbWj+zBYyfVoHjIYCIPY7dWHCMJHE
	2835Nk1fOPm8mZjCkDEAZZakIftUUh5r8zy+d3qQLWL6pvnRl5HimDUE7wWfCC7bJFWjjS
	9Rh7206zUMNrA09TxSaZHDf00sk/RcE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzRS1V51;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D82362458;
	Sun, 15 Nov 2026 21:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154A41F000C4;
	Sun, 15 Nov 2026 20:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776400;
	bh=y+bR5cBurono24Kw/wb/TbttycTR3O4Q2jD2NlUXMHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gzRS1V51pltUaGQ4clealxmv+V5VlpuxsykAnivxRreKaD5ic20+Pu+EjDTnilpIS
	 QICOE3KhDr2nwmNf1Y6+bnsw3M4GMmbwKcruWOBqCYRygaZgqmtzHinhQDl/I63sG9
	 xz5tI/W5GRrnMKiXOo1vD5XZhZ6+2oOVUn57pIeBS0T5GxUzRZQH5d9ZKFbUVlTIkc
	 2soeI8WV9qapMO56490VxJO1BAlyUYTgWsn80tiCDKcVmKA6GjNx+qyvI8UTvl8q0n
	 xwF+oME7WmzjhG4Hm0LlIT/RB4ULgXGYIv2cW364RuiRTe+Mvi0U7pZBjMBqZMDpOA
	 YdPD2menGUUZA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sun, 15 Nov 2026 20:58:21 +0000
Subject: [PATCH 2/3] mm/memory: do not report OOM if insert_pfn() races a
 huge fault
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2512; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Kb306QFNS082In8qH6Nh+EfDd8c/5dSFK4umAapy0uE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ+yTpxCM+ta522yuXs32IXY91zdfN0ptezpjqcO/42x
 7E0TfxFRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbyZy3D/ygG6ZuM5pH/RdtZ
 rV8eebwwNu+FyPlKs2M37C5wFJVvmMLwP5GJIYeT9dSpDy1LI+/Ulzu1HaqM3e0eXqFUybS7vug
 TFwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 1BF8680007
X-Rspamd-Server: rspam12
X-Stat-Signature: m1xywfkzr9y9q5b4ijxahwhyrh9igrur
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794776400-619679
X-HE-Meta: U2FsdGVkX19hovWzwQ4gDYQzaPABUq/zToU2BUGZEA5kTcwyyVQ32PGbC1qKLZjoX/ccmCbnG9cp/IsMK1elsDva/9R05ky7A5ToDmp5j5j9z0t2Zc+IbuKLf9X578tS3jL3EaZNaksdAIlf1qBVMVFCvBdUdrQgqPM2mT0aOqiuKAI7ORXIyO+DocDZHivrujHrYjFvzMTWOpYpeB4lRrla+mWTfl2r2zz7aNfq64eFN5wBFL3OyATt9cipJ4kHsKN02JS9RHAsFmrw4eKXYNkxLrkKSqSsSATrumucO0aUjUqBvGcQtZ8MyIlUxCjheWLjw/h6aTALRPzJcfAS0RXgLqpVcwFHJx0k/Cz/9VLFnmyzjNMKEgNG8M52Q/LQ0LKVoo6mdLtPeeR6krFjW3ypavxYjeQCvyiSel/HBs3hTwVUfoA+NY7hYvBBKzNkdM/VcTmrFlhNLrIXh4JZ0yPfDd2OKEpyBcC/8vk9tSkuxdmIvtWPuKnBtEj45bC0xMWR+lCfUKbGiWEeIg7a/gbu+Pn0gRmidgiYFwL2A+exLw2Fxk+HrzBO2AlPpAEtlrsVIyRoMKgW7mSHZYMvbDx8NSMYO8Zox5qWowoeJ7cBVMzYgzCZSvSwZQBfl9ZrogjwDlghO9ay+VHqIX0vJNS8K9snsnwrGybm76xq4DXkxSuTl6GcR1N6D8pvFUusQCqActf0Ub+fGdzj8sDZr0msy9hgPGbTVy3rygDRXcILADpkbrlM/TwV3sK1Ylw9oV26w2sOB4NGXqCyGPMZVnkg+bT9/p5wepwcvekeOw6IRS4Zwo/GdOvM2zBOsuyy8jTIbcGoMJdi69QwLcsAxWHLW0nRE4L4MQmW4Lo3g7tA3Gqdx3JcoZQi0ShODrojQj+Zn5spXaLo9tnK4K1LisInvxJryUf/h5f1P/9xa+1CAM6VnthPdgNcunaWXCZ3FnElyeypMqlOq/IWVAh
 JwQ9z3Rv
 iOVZfTHFsrYge3VsgQW5xI6HPEZ9G2ctKNelr1CZJ4F8YOJUSTBk+k891In8PCh9brqxRVM4c2rgkHf+vW4LkMAAaSEi8eE6X/iNv4Dqt+dUgpQZLN0TnIDtot1M8xH160tHQ3SnugHcJEzo92Ppnaz0onO3hxy6p+1Hc2Pm/wOd6W7wI412cLAHJyJxrCCI5dA6z0f7wn84w7HbTJjXb7jAn2ypcRTXxGDBdrNF9rr0ElTTnFyL+c8YP6HXV2QDo9k6iKWrKc1DTVqlGvh64sBAR6W4hRPhOA0G5ZD6VyOQELyHfJgXqqjU2xq0Ej+VLzB+iienILoEKfKLXEcxaHTaDyxoQVvEjgGnDqFCtm96Z7fEfN+09YPl28XQiXTUWusaviNA93tnIYYIeUVkMfAZzYD8n6FCemMJ+7/mdFbaDMaiSyZQqC1oVxY/BqpODCiJu1JgLn+wCp/UP7KYZtZGkPVbo9TgYGUpAz9TnYtGD9i4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eliav Farber <farbere@amazon.com>

A driver that implements both ->fault and ->huge_fault must anticipate
concurrent use of both.

This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
concurrent with faulting, as that only holds the mmap write lock and thus
does not exclude faulting threads stabilised by VMA lock.

This is not currently safely handled by insert_pfn(), however, which
obtains its PTE entry via get_locked_pte(), and treats a NULL return value
as an allocation failure, returning VM_FAULT_OOM.

The issue is that get_locked_pte() also returns NULL if the PMD entry is
not a page table which can happen if a concurrent huge fault installs a
huge PMD entry between __handle_mm_fault() observing the PMD entry to be
empty and insert_pfn() being invoked.

This can result in VM_FAULT_OOM being reported incorrectly.

Address this by proactively checking whether a page table allocation
actually failed, and returning VM_FAULT_NOPAGE if the NULL indicates that
we were raced instead.

The same assumption is made in insert_page(), however only DAX implements
->huge_fault and can reach it, and it serialises faults of different orders
with its own mapping entry lock, so it does not require a change.

Target the commit introducing the first driver able to do this.

Link: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Eliav Farber <farbere@amazon.com>
[ ljs: rewrote commit message, trimmed comment ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e03110906aa8..cff39eccfd42 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2866,10 +2866,17 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
 	spinlock_t *ptl;
+	pmd_t *pmd;
 
-	pte = get_locked_pte(mm, addr, &ptl);
-	if (!pte)
+	pmd = walk_to_pmd(mm, addr);
+	if (!pmd)
 		return VM_FAULT_OOM;
+	if (pte_alloc(mm, pmd))
+		return VM_FAULT_OOM;
+	/* We may have raced a huge fault, if so let the fault be retried. */
+	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	if (!pte)
+		return VM_FAULT_NOPAGE;
 	entry = ptep_get(pte);
 	if (!pte_none(entry)) {
 		if (mkwrite) {

-- 
2.56.1


