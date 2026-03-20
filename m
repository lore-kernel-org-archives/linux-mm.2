Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A041099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7EA6B00AC; Fri, 20 Mar 2026 14:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1FB6B00AD; Fri, 20 Mar 2026 14:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1499E6B00AE; Fri, 20 Mar 2026 14:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 020EE6B00AC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B920A8AFFD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:57 +0000 (UTC)
X-FDA: 84567224994.05.2AF0435
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 14E8A160017
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PeHIahap;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXDVRFVe94PePtevwM9X5WDHivS/1XJN2hp175c5SfE=;
	b=Q2R3YNvEK02+rjJX/a1l8OwuotbFFqpYPxmyb9FNO0G9B8NKIpyO8w+dcMdIzhbk6BMRN3
	H+Dbbnu585M4kYludODELM2GOZ2CkZByVXKQtztWcuHy2HReKRDq5jaT5I4cfIusg/2n3y
	e7ulsaoap/Z2MU0Ob1cnZJbmH7W1jRI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PeHIahap;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030076; a=rsa-sha256;
	cv=none;
	b=hMoiNPKNDA5Bn9bwU++UYKL5E9xYwOm/vyKHNawl1C8NRJy+yF5D5Oqg2RlTOnTxRy2ugs
	/t+i8wLeY+oH2tIQfz1GHMuAojL3/aON6Zx31twWgP3dFEfz9yrLaTW1dzLGVX71O0dFWi
	H+jMKtCEK8Jz/KKxvJZm8pZbvLxZ0nI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A71E60130;
	Fri, 20 Mar 2026 18:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56DDC4CEF7;
	Fri, 20 Mar 2026 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030075;
	bh=IQWNPr/YjOK/b68R1uDz3iksCldtt6DiEoWwwpqjSw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeHIahapRFUfhv4MxV6dbM4uIo9f4A5EP85/jRgebgxMlSUZQ230V1BAGYtAX5wnY
	 AtdaU9tRmjnjK+jB9d55FnBSJneIlvqSPcF9BMVnkMnrPRlzll4EQ0K5DDUfP9DEJ3
	 6xsQR9x7wVQ7DcqTqfPL7EjosB+qHAGqRwHp8apEHDj/rD/dEIhz9aazLEDa39v33j
	 liF/cM2B18Xq7tRiLV/aM1q/RjtYTVkvD33HlnveheU9GMaCWVN5W8e7PEOO0SenDT
	 4HxMxPQGmvLp6zHnELygPPko/YMQWCx9VbEyQd6Qwu7aUzRgpqFV82XU/df4uNkuGc
	 4L1tYelROcJXA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/13] mm/huge_memory: remove unnecessary sanity checks
Date: Fri, 20 Mar 2026 18:07:25 +0000
Message-ID: <0c4c5ab247c90f80cf44718e8124b217d6a22544.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14E8A160017
X-Stat-Signature: y8hadyjazgowdtd3xaow894sgtaps4hx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774030075-799032
X-HE-Meta: U2FsdGVkX1+t5b3NbzG2R5tRvTFcQiTAZMg0BQ1gNuC3At6nnjK2+XgN79fN2yEjTz8OtAChq/mc7rIw4Vdt1qsT0Rx1JuOKwbXFeeR4aWUE9kN81suEm9S3zmBQA+Y6sHDrOmMEqiTkyPUPMBFK7Un9WDYeQkvq6cA4BGL5YGh6qnV0zHeoe0MP1MvVusxGCPItbaep7uo63sJ1yIk6McB23XLJCQ7GGUCkupBuWF6FWiHIbW+mOHZFnulLvE8bdHlKRWXuj55d4L5aYfM5jMiHNberTnkdiB6jHnEtWNFJN6v47zUCNvmoGtAELNWB52M2dXD9cnDqXpFSboFZFIsfise35A6jHVPrS4GHxHLG+/7mgwAUP8+iulYbu13n7GUIQ1twjWn4x4MD3RemrbZzGJiG5gdvmHC7JsyOoRVWpSf9nr+i5iQl2z/FZ3wo/WysQI7ZSn5VEhmFxAV/HTUlJUwAdHSb9z02cenzt8Ya52/noZMM6Wy69AGzmtKfL2rx04ihz0ZVqbBJUmWJ+4yjnD60cnFkN87+OPVgJ/Gzk7gwsva0CdcbPXBAn8lNtn9HBJLGFK21q0mC3YJy19bBEKbcJQg087jPpCQZ5DWkD7phlPnT/1+wBBtyjYY195tjqViCo5JHGnLvijn5N16uCrWaY0FgiLGGKTiy/wlvrCq1BbIOjA55UoHbCE57p03cf466dFWIKw68KbCRL9Kb4zchlB+6Pjuvlj4hy337H713rzgu55px21Gev/NYUDpaXp3A93t1mPa2NLf0y/GheK1xehDnBw0c/qELVrFc1tHuIIuwfakMpWiEklg5KNAcLG/CzbTr6rzS7YFb+/s3YUp8Caj0ROmrmUYpNX+adoLFGnIHTKOZ+Ly6u/F1OIluOEfJlY/Vfqcg8hGy3RLmTNKW6ODAyewDBl4XrynwE1mXNQYHzKvk5ruolmABizKWb2+qty3YbsJCt6/
 P8esBOzC
 GroHrhnOOF0MkDC638+KHFSpcmtv5VrJSOgdogfXpjX3ZM6GGcquoKljQSV9JNrjwB/XQwQ+eoUCwP7JPxNlzXVVuALyWi8EK3hRiykCpp5VgUnNXZCYOF1LIN/88PxNNnLPgU+6ukegieLZDQMDtoIFQcQ70TCFSX6lofQe14lSXqJ9/3MnjJh4k3prljhOn+QdivxNP/9zd6r2N58vlO441mqMZgRee89qt5HDpWzBoCnloWMCb0dqHHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These checks have been in place since 2014, I think we can safely assume
that we are in a place where we don't need these as runtime checks.

In addition there are 4 other invocations of folio_remove_rmap_pmd(), none
of which make this assertion.

If we need to add this assertion, it should be in folio_remove_rmap_pmd(),
and as a VM_WARN_ON_ONCE(), however these seem superfluous so just remove
them.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fca44aec6022..c5b16c218900 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2371,7 +2371,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		flush_needed = true;
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
@@ -2402,7 +2401,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	if (folio_is_device_private(folio)) {
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
-		WARN_ON_ONCE(folio_mapcount(folio) < 0);
 		folio_put(folio);
 	}
 
-- 
2.53.0


