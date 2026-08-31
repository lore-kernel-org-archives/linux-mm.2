Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1F1C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944496B0095; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D7D6B009D; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D6F6B0099; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E86A6B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE2D98014E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:06 +0000 (UTC)
X-FDA: 85161731172.27.97AD225
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D9E2160012
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxqPaCWX;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184985;
	b=6qTA+z/hN0sDT1XXzSEkVwJOY7IH2b2S4S0b/uBZ8Sgkwmp1tR6vTpZzxOoslOkxKfsVUn
	DpYzuibijDYNS2IAGDnrw2xDFrPTmGh8rIye42aoPCrRW1xBXFD23qSHbEt/gwBP2oQ8Od
	YFNvmR/s5l8jSI8/rMDnBS/GHJG3vB0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxqPaCWX;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	b=u0rdO+66mUPVsirRLuFdDTW5ERh8oxbL3N0fJb+ySad3RsKdAbjZKAv/ExueIfZSRBvA0B
	dxfmTCT7OGd56tiVOX/YZkhFntbvAB4L1VRDo7NWcVIZ0xxqZXQbQLCzHjuAX0hl67VArp
	Q5gHsK+Dt7HJYiKH21lGNRkP6e4SpWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B90AE6020C;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5421F00A3E;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184984;
	bh=SLM/iGuOERBTFxu8mql/4ATf4p59p9Me6R2GTZoj17M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxqPaCWXz36XYrXZs36tURpnzE1QQPLIHZn2GbhatQy2eK0bA553g1f0VORg84K/2
	 5vKwVliPAEhIA0mNE2KhbbBvOjRZJYBjNDvZ+FAEBoIriAFNJBEqWG6XwvuayoWSYk
	 9XxP809cm+ltP4wIzZn7B2EMMcRVPJXOU25t6/NDfITTCZ2HLNkqF5EVmlgZ1TSnbC
	 dueUwMJrECkZvyiEgx7jatMUkCH0mP0AWwHQREdJstM6/nOZVMKFOFW2ZiGz/JDyTd
	 le31dNV1yajdLVpUTGIErxG5kD0ICCh/glTX1Uq4tDo5VofEulopGIAJAMi6UnxPJt
	 zSg9U0vHUYMMA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 5/8] mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Mon, 31 Aug 2026 07:02:44 -0700
Message-ID: <20260831140254.72004-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D9E2160012
X-Stat-Signature: okwnwxix8s4s4bmcj5jefy41iata7xwo
X-Rspam-User: 
X-HE-Tag: 1788184984-469295
X-HE-Meta: U2FsdGVkX19rfeCybB62UaGkR3zAc+AN3Y9bvwwKSdYk/Lz+rT4WJOEnb3lqb+WkI6WMVjpyPbXp6G4PfoEtOJN1V/swNiCWxRPx941zasQVoInqC9HnPpZNEmvX6t2VUVRmUiCUq7oxluFPRSt0os4enhwtvo4/GR5rtQ/JWp8ASL+PDKkQ106mXJM+CEB7enXJ9Xp3qIW4lB1WFmFMDJxj91/9bHepCtr1shXsX1FQKGdxtytfoKoRu1z7/7EYPLZwur+c239KNXABnwlXvjczV3tm2mWrWG/0LQp1EzaKuB68v2ngri46+WpLXBsFbYYILx6NXn/pAfU0G0W81skLa86dAC0Qua910kmZnNFqqVAmPbra3WbX0wOxG1culrl4sJW7bQBjBBhlSK6oY4O5KeroadW7uhOMRMPFjLQuqTBmIhLoy0BD/AP4aUFvk5+K1cQ9VWyJ1mjOOXD2s5uVZT9Af4qEmbZ8vqFuVHjGgxisjXFG5U8XU0P1qidPUqBBrQYq+yXybO72AtBw4MFJCLG4mCeStZDgEN5zlSVlT+1QmonG2ohUY81qI1hQvdsJMvB4UrfJNxt4jWrl/qj/FI+gZs6sbAhSMT36ucIqu7Tim7jR3QBxayEhNkwfCntL3atW2fIGnWqP9Y+1jFq4QCEGImdt0gcfix7jxKNe3NlV908EH3fTduWtIQDrzZWS4PwG57b1axxR0I+Q803AjcjqgTQP/1teRPKVzO+YR8I+U2jx1ZGJLEs0dptUTKhU3/1w2/ndo/P+1QHeh1pna14sLiV4oKu0FVx80lxC01Dv4vbY1EpQtOXOCzMVxOoKPLLZtsslGoPstmraWfNq8/quEnL+auicDb/trZKGA5G4VrfAidDLGROqdFyKs3gX6FXP0w46YwiCVxJ7Hu15BIM2awMzRMwCXT02f5opvbgaz+Jbl/ELlzoQLpibG3gbL0NO6nvKXvoL+uW
 PMOuWWt7
 BfW7c5YHAH9lUBPFLfHXKH2diKBnRNbX2Ty6Y3JetlqsOPwGH8FivUr9oCYRga/rwZkPM3cBuJHcj65VhLs6AVvD4L5s8je/WBDKLICA1yEMwsCCFohmC9PAI/wPGPmYN7HSD1FdNjaDzhlq+1f/DeoOvZLHlAvSznAvONgsk4GmGdxM/oFMv1uKUBVRvJISIyrqV+cz80NQmhr8GVqnEfaFea8LvX52XH/2Hba2Z0wqYjxStKYPetDRnB8P3ZyGnrje3pAwLGvNuNDYCrxergwhSq+ggIctNqgb3qaeqjXFxtn6KMuuMd6QTzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For applying DAMOS_MIGRATE_{HOT,COLD} actions to a region, DAMON virtual
address space operation set (vaddr) calls walk_page_range[_vma]() for
the region.  The pmd walk entry function, namely
damon_va_migrate_pmd_entry(), collects folios of addresses of the region
in the pmd.  It starts from the walking address and advances the address
by the size of the folio of the address until it goes out of the pmd or
the region.

Let's suppose it is for the first pmd of the region, and the region
start address is in the middle of a large folio.  Also, the next folios
are small.  Then, some of the next folios could be skipped.  Fix the
issue by advancing the address to exactly the start address of the next
folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org

Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4b0b5edf67952..c8c32b2ae0402 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -669,6 +669,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -681,7 +683,8 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3

