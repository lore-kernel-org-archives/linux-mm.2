Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57498C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 19:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5996B0088; Sun,  6 Sep 2026 15:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57416B008A; Sun,  6 Sep 2026 15:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6EF06B008C; Sun,  6 Sep 2026 15:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1D806B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 15:54:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FD501205E8
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:54:27 +0000 (UTC)
X-FDA: 85184389374.09.3EFB904
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id ADF19140006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:54:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iI6qZzFS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788724465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9yZmy0/7ZEMQpd5WklGz4F0Ta/1vxLOno5MJ0SaNnXU=;
	b=U6JxcMhl0Va+LniOV7T4odTJY33FSiM5Fna1XZkDe5fX1MxITIbGcPcQ5hnJSh20qXf0lX
	UErZCdLc2QdoEis5PJkgV7loH7V4fN94CqQi+hwCgbFGYSsonlacc61IhTrSmOAIkgl5pX
	grnM0OIIzTszpIM68RC4MV8a+lgk5Ps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788724465;
	b=Cx/N2TVSJNVw2wVC3zM3T3wcd4RAAYDEnpxq1ImH/8OlQtC3qCJ8FKpwrdGIy0WlUSXITh
	wQVJWk8bg1lOBmRnz1GUaE5m494dKSbQ3we56K1YVoC8g3Ek7QyTCbZZ7yCR29mRjUQlVy
	x5Y3c2M+9iC9xWU4FXxoyynlhlWlsVY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iI6qZzFS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 384B0601DE;
	Sun,  6 Sep 2026 19:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8A41F00A3A;
	Sun,  6 Sep 2026 19:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788724464;
	bh=9yZmy0/7ZEMQpd5WklGz4F0Ta/1vxLOno5MJ0SaNnXU=;
	h=From:To:Cc:Subject:Date;
	b=iI6qZzFSi9KxMAntjrQEPk/Gb895LQ8iS6PGcc4F5PZR5fQyWizFUbP03kVEKo+7Y
	 T8ypxTxz/g6NjigLIcpAn88r05G8NR5A/Fh27G/zMPYY9UxbCX0vH8KDTeB4tE6rHW
	 wy1INhYckOTm8oEL2OROZqsCDhQ5CU+uPw3VewpLwvIj6PhVRjLEVVy5jk7tn4PTnV
	 BND0ABP+OCdbuyT0HSnQtO9m8vG+lU4Xe43SAuHOEnrVSDcduQ8m3LKitrIwsBZaXf
	 z9YgHyiF0Qlc8mUWZWudc7epnxJZaOxl9OxzY4OTHmXoZCVrHaol2MsZ36q+GlW1no
	 SwpASLEHHwxRA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
Date: Sun,  6 Sep 2026 12:54:15 -0700
Message-ID: <20260906195417.103263-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADF19140006
X-Stat-Signature: wxfxke8e434gmqqmjcnzg8ihi4yaa7pd
X-Rspam-User: 
X-HE-Tag: 1788724465-100919
X-HE-Meta: U2FsdGVkX1/VPiDJ7stP5N2AwnGB+8SNb2ezFjoZfaHZrJHATKzDGwIEyhSGUVHPXBpJVPOSwjcuVLIpVcKn/wNjsMsE4J3g+EYIYzbshUJj/RPxyAc8eU2uUyX4HUmN246guu/GzG4nihg84Tcc0/u6vGxZQS25MztvjR3ac06a3w2iXdTywe7VLkV4/h77L+ISqy2tPWZVicJqq4mrjpQ0mXqFcjvWZiwhFRFMtW29lBZoGyBrOSzqQNGYXj6S0n3pSCdHc55NwOM7//EuDxpxAwuk1xySRsvG/Mp6wclD2X0F6ZXqH6Qjb28giBKjR9GLPUBKIJaXCVSOQLfUg/tx1RpWux7/CrGvcp7XbW9JqJiBlwIG/YHXagnnImTpCAJT9nLTFr6AORVLUJYngsu+L4PCIXCmlH0YXM+b0yqCpns0QlrLzH/1RWC5hCmyEDexDodwYgKvmj3vM2AEzB717jPyFQQ36KvrK7MHKm92etZtjHkXa/WB1Ds9D0oDWJasiiqog0NZpE79ac5O2bshvrqbIp8aXoH1qk1VdTVohOOzD67S4/BvY0I4qyI4xgmFdzJDAMfHd4qWoV4YrxlH7QlMrkp8kH7LW8kzyo2vfAtmhV0cp09ppfeB6UXm0OZPhzNC++N2gA6faXDrvq/+hBbLgdBImgP7TAERuSBDZpf4WJfYoXrvJ9AlLdgsLbMY2Pb4s7zheH3pyNIRp185ici/s+ramqP/W25RKvbY5U/AEtmsT70xC+EnZuuhSC2ao8UL0aWPjJ6fhgdp2VOqIJrGCWGmAXPFTowNS1QD3wl2VeI3mR6q/WSPCVSvB5RrwUAzOc/5zrp4KzGfdrEBr/rLQFhidECu8/bA0iFukC0EBKObwd6Jw546CW115qBPWrZQ6c4BpTlEQHvCWXONUSSQ2AJ+hSyuszQVLCPqlBumJiapXDRDBP7j9qYQQ6PAU+ZjKYb6T1Jco5O
 mhAMewa1
 6SAu4uZ+NKz9YzXlB3l60KfLwP9CpefpvNsLPbfpAKsit6kQeHno+9M2l+DDybrnt022De6OVxIXM9J1nO7lzxKNPMoVpQ6l0tp18+Rogo39MBduYtRaNWUGZQ8LcPQ0FLfsxHVEF/JOHMixLzAG6u4CBQb0FCaN/OJ1uJyYmSei2BW9xDfjEz0wlBswuHVhOMzP2BvMRAWWV0qpHFvryC2hMtJZu4yXAie7M8ntu5ozIhVt4w+TwPiSGrV75v+ek2j/PnrE3/yk1f52xiKpVqdaVtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_hugetlb_mkold() reads the page table entry into a local variable,
unsets the accessed bit in the variable, and updates the page table
entry with the updated variable value.  If hardware updates the same
page table entry in parallel, the hw updates could be lost.  For
example, hardware-updated dirty bits might be lost.

Avoid the parallel updates by clearing the page table entry when reading
it together, using huge_ptep_get_and_clear().  If a parallel write to
the memory is made after the clearing, the hw will see the page table
entry is cleared, trigger page fault and wait until it is handled.  The
page fault handling will wait for damon_hugetlb_mkold() due to the page
table lock.

Because hugetlbfs is an in-memory file system and hugetlb pages cannot
be reclaimed, no critical issue is expected to my best knowledge.  But
definitely this is a nasty bug that should be fixed sooner rather than
later.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260830160545.98969-1-sj@kernel.org

Fixes: 49f4203aae06 ("mm/damon: add access checking for hugetlb pages")
Cc: <stable@vger.kernel.org> # 5.17.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index f884d3f78f30a..91a0d441c1f94 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -283,22 +283,29 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
+static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
+{
+	unsigned long psize = huge_page_size(hstate_vma(vma));
+
+	if (!pte_young(*entry))
+		return false;
+	*entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
+	*entry = pte_mkold(*entry);
+	set_huge_pte_at(mm, addr, pte, *entry, psize);
+	return true;
+}
+
 static void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 				struct vm_area_struct *vma, unsigned long addr)
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(mm, addr, pte);
 	struct folio *folio = pfn_folio(pte_pfn(entry));
-	unsigned long psize = huge_page_size(hstate_vma(vma));
 
 	folio_get(folio);
 
-	if (pte_young(entry)) {
-		referenced = true;
-		entry = pte_mkold(entry);
-		set_huge_pte_at(mm, addr, pte, entry, psize);
-	}
-
+	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
 	if (mmu_notifier_clear_young(mm, addr,
 				     addr + huge_page_size(hstate_vma(vma))))
 		referenced = true;

base-commit: 99151e55d0d7c8c2b2cfdef93e2504bf2461106a
-- 
2.47.3

