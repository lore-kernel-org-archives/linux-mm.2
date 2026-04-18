Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16678F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768B36B01FB; Sat, 18 Apr 2026 06:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3546B01FE; Sat, 18 Apr 2026 06:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1D36B01FF; Sat, 18 Apr 2026 06:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 484976B01FB
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F3F0B92C5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:03 +0000 (UTC)
X-FDA: 84671371806.26.89C5D77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8A33D80007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fU5Wkbz9;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx2x2JXLBBS2O+yAPtpskFQseB8I8qXGfT1HXmKX5cs=;
	b=ZyQCV5PkZM7YHFZ0OfjMCyiPUZ28jIgWV8CefNAMKH0PPJG1TygDj6Wlq044CzF6rqnCWV
	GKJVIiojRuRKihrEnwjbq536d3k1jkdxA+Z5MIHKSVvyH7v7WtvUESw6YurHjugeFZ+qwa
	jGM+Tq4r1Ys5kASxWzCeAWzHPpp+1d4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fU5Wkbz9;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509761; a=rsa-sha256;
	cv=none;
	b=LCifk7O0LNKVMseBlKXZy3zshM98YPV+bCnID+GaT1LqgbVhRMakEvrahdZlde/h7sO4sK
	+Spn7eDp8IpFXyH/yJVFbVpLOqiBDAxBJQvrUUGy2zj3E2OUk30SCc4HtOveBYFoTnjh3q
	m87oD9+Kb8IQAOCXBPfOV1ju+buggTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 144B660180;
	Sat, 18 Apr 2026 10:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212E0C2BCB5;
	Sat, 18 Apr 2026 10:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509760;
	bh=a4vQJGv5oSnYFOAuEaEUtLL2TvNcolXC7zAnBLawpZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fU5Wkbz9Sja6783ANt39zjljXRh68I8sQh4T5JbPnOi4qhQemlSPv0o9OMbFO447h
	 RWhwPCIk4pfY8epTLLPBtMea9XNdF+gamIZqp3rcgUrVfLZDR7SYMM4XMAkrd9S58R
	 tPRj63i2JmHfnJ6Ojwcfo5JtbghLxY+JApLP8qkTYdwkdTvx9jVagYDCmFVtrg8NHx
	 sUNGaPpQvUdtYus0fKiNYUeRKbSy6PRs/6W6LFFzRiKk0XOpcTnocl2HxPs5nX52OT
	 wW1njXV2z5eBHq5H8yeRkVRmYEJAnC9Z1A+niQzgD2pzAj6s436a3SO1EaMsVusZMm
	 mgmJHq+qGq4+w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 02/53] selftests/mm: khugepaged: enable collapse_single_pte_entry_compound for shmem
Date: Sat, 18 Apr 2026 13:54:47 +0300
Message-ID: <20260418105539.1261536-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A33D80007
X-Stat-Signature: 88gmxeyscu4rbyskugri8hujfwh79opw
X-Rspam-User: 
X-HE-Tag: 1776509761-427555
X-HE-Meta: U2FsdGVkX19ZE9dy7fjILpnFO+jrISXTEoj+S0GUQ/Vo+Ii5UTpdQ9PnBR6S7j7YsEXgOiS7Ef0DbK7QM/EDbgoLnSUR9g53VfYXf5FrPlbHS82Kd8FCzIzEW/NqmssKOcGDseMxRlZoLfva/SNRvX/2AZ84NyQcohj0JzfFq/8L+YYjmsaGpd6AnjgdYGejydkXefzETEgPybhZt610AzcK94VkAXfqVp0AWLiuSMdllMWPYc/oCLBIJMQ58Croz39n3u+F55lR0tZzOPKoj0VUQOYT/NbIFFCAupDVvSR0DW7GxSjMfwdsmRPRr9vbx6Z6TSdm0hhzuy/Q7BJT3KK/93n80pHa6ooksx2AAbEAU3RXG0zR799X8hbpMGBPEZ+BN46IhvCKjgzRVYR9m/UG58/A54+kqf2pYgWX0UEzrJk/IS0miW35WNxSsukLEDaLNAyXPAdsEmJs+kN1XzcvuUkrrzUYNqnUUMG3oaZo6BGcdmRhDomPO+MuOp2AVlQLZT+PBxwg/9O/7yKgPnZEx4sLDmUAkq/Ymt19mzN4JKDnaq2fkxN+Vi99kMlea+8G6PSeUHota16ojKsEyDbh1JW7vY1m/5urkXr1rP0d/9jlNg7QDpcFVhb+DZ2kp/ETqZvt5KxXiCDi/vxHWm0fbLKamSl8QBv8Gh8OyId0Vifn1wZZi0N6SdgG26XhN1XUh2Ypq8y/u5wjv0Jx+L7C81XJnis4lKcSmQiwXk6paQVcl049S6rgqAc+IU8lQU2x7ynVpsqL5/TT9xIUcto0aKSLZFRKdV3Pmp7WK15BIDF4JL1X+my15qP8NeSRvtF2ueIMDNEb0FQGiy/u6BdDpHk3eLbY50sZNVz3cdqyxd8UaUmfMWJRW550OXgbb0FDjMRFYpBdhNINiYhUlnbrzSlU9V19T8Y/f/mWBOuBuJq3Vt1IL4XPeS7cF4nJjEtyP4oUFESV3ccMste
 GqBv57TF
 ImiE9tuiHxGKu1yO78mo6REJozCQ7SetE1ytFpP/DrY4+dbQx70F4juE2NmdED+p3DSE4egaB+f43HlO+fIhzoJhwA3Lmznnfz6xvsjQmBqVK1dpgilQVW6nl+ibtOiqBGmdDVTTGJIu6HkvY64MzZYoiHCdFLwQXt8r6bVCo9+znt2wXgI2TMstRGqChn0PwAgsjMyjB87TiPBdR3OH63pAobL9juEH2DfXKxsqGrnOVvV5FzrKdQStEmgcoLUR7d9sSBdj5oZACvXzrlSLRFXV3/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

A comment in collapse_single_pte_entry_compound() says it can't run on
shmem because "MADV_DONTNEED can't evict tmpfs pages".
But MADV_REMOVE can!

Use MADV_REMOVE for tmpfs to evict pages and enable
collapse_single_pte_entry_compound() test for shmem.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..e6fb01ca44ed 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -783,20 +783,17 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 
 static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
 {
+	int advise = MADV_DONTNEED;
 	void *p;
 
 	p = alloc_hpage(ops);
 
-	if (is_tmpfs(ops)) {
-		/* MADV_DONTNEED won't evict tmpfs pages */
-		printf("tmpfs...");
-		skip("Skip");
-		goto skip;
-	}
+	if (is_tmpfs(ops))
+		advise = MADV_REMOVE;
 
 	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
 	printf("Split huge page leaving single PTE mapping compound page...");
-	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
+	madvise(p + page_size, hpage_pmd_size - page_size, advise);
 	if (ops->check_huge(p, 0))
 		success("OK");
 	else
@@ -805,7 +802,6 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
 	c->collapse("Collapse PTE table with single PTE mapping compound page",
 		    p, 1, ops, true);
 	validate_memory(p, 0, page_size);
-skip:
 	ops->cleanup_area(p, hpage_pmd_size);
 }
 
@@ -1251,8 +1247,10 @@ int main(int argc, char **argv)
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
-- 
2.53.0


