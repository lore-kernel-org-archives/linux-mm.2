Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E633C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A83606B0096; Mon,  7 Sep 2026 13:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34B06B0098; Mon,  7 Sep 2026 13:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923B06B0099; Mon,  7 Sep 2026 13:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69DF86B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:04:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC1CAC020C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:04:07 +0000 (UTC)
X-FDA: 85187588934.03.1D7FB7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 762CA180015
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:04:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AqLQYXbK;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EvrEEOMq5Q8SO0XgN8y2BpwwzJurxJLVntxkjNABWa4=;
	b=tYum61ZU5Ji9TeSn4Nfk6jcbeByk115IYhkw7kbajDmkt/ERXod/sPS1Z9E6MxeFjaV7Pe
	hUE8beUv5LcJV6gM6vRHmueCW4sWDaFCDoIQOcoqzA6KTIw5m5gMmphX4U38TBOiFzo51y
	JWPAVZ2qXLSPm5FwKOu1eCVH8j1Jvpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788800646;
	b=Z/X+lP6zWjIqx21VxTQSOghfUI0J4ixPPSoyC6ziPsLPC7WroO6GAvsT4ZwnnXhrbwLqiK
	T94Zo63tZn9kTmW7QA/Ta62bIodqMipATyQeQOlEcBAsSvXs7xbhFP9Mb97dRaNia86Glo
	6MJ3Lp/aX2N+eDHdv2AYms8ryDJiPzo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AqLQYXbK;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B41060207;
	Mon,  7 Sep 2026 17:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C5E1F00A3A;
	Mon,  7 Sep 2026 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788800645;
	bh=EvrEEOMq5Q8SO0XgN8y2BpwwzJurxJLVntxkjNABWa4=;
	h=From:To:Cc:Subject:Date;
	b=AqLQYXbKd70NwZm4KHuilLL0jYtbDLHWAXuIWodIdBdO+1DQQF0PSpDYJcm7udxm9
	 ouQxzYVgqWsk+Epp+RWOmgnbIDgWeXueoWSlgx+b2svEghbgTrrFZSkZnF1r2DsfkN
	 qnkmgUTVwdmgKKE7TnX7amoPNWUmnZMOloJLmO3mzg7J/Y3kL6KghALj9CfGG5t6BJ
	 CzMF+62xCEMOKVKzRHcNFp+6tzsj+qx5wOf5/JUXy8x9P6SuAlmRUnAmUfjjnqHOkX
	 DODaRnJSfCiIKkeo1/+TsOX7rV3mhyRILi33ySH1mMF7KA4j3n9dQB3tyRpIjHYq82
	 G8unYZCFa+0zw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
Date: Mon,  7 Sep 2026 10:03:56 -0700
Message-ID: <20260907170358.100168-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i4niwgsrrx8gzdu93aa3fjj8p6i76qc6
X-Rspamd-Queue-Id: 762CA180015
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788800646-594594
X-HE-Meta: U2FsdGVkX19maH47OAgyqJNbWJnseef4FB17JtbEwj+Bu5RMGY/3xlvqUnvHjzsXqharLQNawyismuhaaUYpVSqJsp8YjFNZWw/vSw0LxEbO2TUa4fbdzoo7WgjOcAJHp53/RI88+riIxvhAST9RSsEGP4XAhmVbaWs6A5YFnRLJI6XqqAbyk5gLxekZryI4jvNskANahgNq+jKixW8IdtzSuLMga+k8ZRTI/G92cIoFm0U2WJ0N7pj58ZRw54yi94cmOKOT12pTaf6qF67N5ik/m/P+SQN7wX5ver0TZOYox0lcLn20qx2YZRi+mghMeoMOttuRNcOEB9fUa+13RPBkj2f4X8WMlV8qHeTXP1hjSVEjW/leqbAy/iiehNoc6xb/yhklZJhqFz6khuygSbW7ZX4WS2gKXOMzgkZHzyUqGSDCkdKIrB8brQsbAdsGc/7BBxWUJYpqAsnzSRdT2mf6q8LRn4cSbuNAQviyqtFfqcQ+LP5HuvaEKZb0fQm7F5GOI4r/xSC3aynPsSHS5+dP/+054qrGJXhnAL4PB5/6+4XgWBDlWD0z0rYjJVj/Kj/zqLXowHebY3v2S+nIpmHn9/y2h+/rJQ4hUB2RNNNvsYJYa6pOqmHrwSqKBjiM4II2Vgrvxgx/KeuxcO68Xyci9PVSF0Hd33sDzHCfj9bpajnsAxOxYLcLpBamrI7As6hGod7aPApjyDrxaI3Zs8vdrp4d1v3owiV3jyLsuAvRaNntRnjEthLeE+V/MDafvz7EwVNxrMsylGqwFtcdm4jQLR5j9HqyRtJx/Uz9xjXJUvvPiCyVFCsHnu9TbCxbe6ZbULlDJORke06uiokA2vTU7OS5/7L16vPwolNnl1Kzqoq2ZTOEcwUdf5eMEwa76XMZoT2KJAUre2fRHEyuCIIu2q7L1knP+bNFlnmG9YlbqvJ+X/8Zlnsc/Gd/KefmpDM21+PUftV3CkmR9Jb
 tbfUdcCc
 s9KPWBw1wtwn23kUqa6BuWoL+yv7qZW8Y6wEXXwEI68OY9ZeTebbQcB84giUPJaNL2IOV4/hpa9wq74dJTPrPb1qgixHtDaNuTDclsUOHXl9TxgxpJE6leMUj/OxpLvpZUI+sNekyqPZEwWWpAu0psnbganEyC/fzplRm5LWDJHxP3wy9z+Pj92aOKKmMRPFMw5DP4cCKYB7ahTQcl2WjLpYv4vkxNl6qXi+DltrZpI7KNiP5enkzNTzknhwUt9xUJKCZlByzK53ipcrEZAZWYwNm3A==
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

Changes from RFC
- RFC: https://lore.kernel.org/20260906195417.103263-1-sj@kernel.org
- Drop RFC tag.

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

base-commit: 13eba1898080a8a54c60710322909fb0a4d35e84
-- 
2.47.3

