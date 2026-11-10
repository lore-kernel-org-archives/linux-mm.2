Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7BD606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Naspeqem
Received: by kanga.kvack.org (Postfix)
	id 9BD536B05B0; Tue, 10 Nov 2026 17:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994AA6B05B1; Tue, 10 Nov 2026 17:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2036B05B2; Tue, 10 Nov 2026 17:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE686B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05E5516016B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:17 +0000 (UTC)
X-FDA: 85420712034.27.CE43F2F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FCD740003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Naspeqem;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351195;
	b=i75361cZYeAbWaoUAIPwZx/xJsNXHGwz35mwDDCK/X5I4jtNLLg0shmfOM+0KO54vQ8ddk
	bPW6WfBAnvm9GrKcLCmm+KhvvJthTvuH4DWLTGYJagBw4L126Z3ukA00vyfXV3YGwAqcgX
	kiJbSCptrp8aHAx9JrCICsbJpURv+BA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Naspeqem;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpNbtuPAByFmfs1SZ0VPEDSa+rjep9K3tD5D8ZNStNU=;
	b=dviKqbgDV0f+qbbs0Nw0Tl+CNMviAYUEaNE2CWtPa/zi+oHCc9poYwLGlVbADxS+sqeuRV
	SXsbUijHD+zNUInI+mBBKtml5/GaxoOA+Oz3/BjUQoYAUEIT+zisIeweQ301ZpfoOWQvID
	OvqyuAhdI+DOWsxkdCj7g9wBH2lqW64=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3288514BF;
	Tue, 10 Nov 2026 14:53:11 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE97C3F85F;
	Tue, 10 Nov 2026 14:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351194; bh=un/IQBbksKXsB3Pu9IX4OmSWdn3NPEIzpFQoRSFYVs4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NaspeqemBgPiDtjDssaFV0lv9CsQ3xLiFOGP7avtVwuP/9uooxstfLCgEErCDpxEY
	 k9ZzP7Cj685xVVuHXNpsGc/f7LkUK9yr9aA1QbEoddKhbT/ZCeucizo3VKyDBDGwSA
	 5fhBlk7X8X0bRkBq1zdzeNZoroFwCF4+4Mx8kQIY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 10 Nov 2026 22:52:51 +0000
Subject: [PATCH v4 1/6] mm: khugepaged: ignore MADV_HUGEPAGE for shadow
 stacks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refactor_gup_fast-v4-1-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2302; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=un/IQBbksKXsB3Pu9IX4OmSWdn3NPEIzpFQoRSFYVs4=;
 b=kA0DAAoBbdXD0VrFMTMByyZiAGrzoFKj+16o9hXh+iUvEHeS696tCnaqaDSUDfs1FECpmRVLO
 IkBswQAAQoAHRYhBC2D4JLdBTO4WHWknW3Vw9FaxTEzBQJq86BSAAoJEG3Vw9FaxTEzJH8L/RG/
 GMcKAY3gf4lDO6k+Jv4GEaHmFyeXBxNLmNNLozApZhPm5IciHwHh4sb0lxu/xavFXG3HTlnVki8
 Z2XIBuByoh9A3B+94eKje0gFUpwrgQVAKcY17A1AyVsitX9bKb53Jy5nhOy9QxQK+UBgxMO9oXF
 RHtHcvDgC1SJEwguVlxtR0XrJgDKY8V8doZwX265BjQBeIDN4CsZS3oGAk/W47Ng/TdeEG4g6dN
 keZePpipeNEplpw5PJG17iIHdzNh1de21HwHetf7CkPcihUhddB4yf7U6NpVZm7uDqwjrrhrv/a
 bP0qDf2TCugS1HPpymyhCrM5FglEOE/S8JQDaFPrpo4LO68HT9MB1qQFkLPRkrQirmlNhDzAXMC
 xjHpS9MHl/Cq0HmFFbc+aHM5rXShBS6MkNN0vbKW/MXNxwrRidXrbT2Cw/Ew+oohrjsvlparj2V
 xxTdFp4gDR2oUUw1bQCdYyAKDqYnlUhv4mkt5mogmPcaX9/LvL8AUDH8t5rA==
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ne5ypjthpywg35jrqhneiebcu5er6t31
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FCD740003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794351194-768227
X-HE-Meta: U2FsdGVkX18Lf68xwDsOhCRJxxM1hHZ6atxRXG7IepeVj0rna57veYb8Chnl2zoGZZ9/+U3GD/TezqyoAi0we15L7g6EfbtBILEp86L/lie0jepfJVvjhaSkxBrQmY6vdYDopvSDbO7EqhNlCm/WUE6JDLHu/GVcpYst4D7d2tW2Pg09C2UkqNHuZEzsWGmP+P1kHr2/4+OOPE6szg5m3Bt+BByE4MpGRSscXfwFVfp60StB2BIsOGyX/xjnpkgbsXir8sepwMCEtObgm6O8PkFKNeGORgNLy1zOfELy7U/y261gWPErj3mvVEwcZFIQo320zuKIdzLKrAeT0/SldRXa0Szh1TxEoCtqFR0B7oPsuh2iGRtnU2L94pF2xwdl1TxyBd1W/KaFX8xNdJjsmeqFCDB6T/HSCsYki0rpbjsEmSUzkCg2/vdV53v1TstahCnjD3dZ0O3iPNeTi4c58fMMjoJT++h6skfBkHoWuD5CzpzifrK00UL4zi02km/UKvA2ARa9OshbvurGboULbeHGoeJC32ccmaXBGAiWipAFwsh86j711ST7Lt3V+cEc6lK4eO7HFHJpz8ILJMc1a/w5/DIvlsDAsLymRBBJ1aDuNfjxU/GdBdmCLkBtTzHboO2VxgnTPO29G7/MZbBKo21u6mK9ONiRAiqgau6J5egtFzUixWC7UDbmVp0FSV6OOFB1mV4+NXh99CMXXwMXAtebLlpBWuIjtC+uchIJ4uCzPRtzO3N08bmW+Q+572CpQUpBiWD4f1mKc6x0ggdAuVs4mXuE1Nzlvo5IR8KKDf6qNH0aHwe/wFq0iX4awItdeV820723xovRCOyW7Dxx7Pi8uI+1pLNAvX3AxIt+2oDAsrr6GXp7t9anbXEOV/53AN0I6boBV41vQ1T7PYOcYqmTT/6GHv+KQT130DPByioe/otMps43ODUn9jcUzB18YgeAb6UEU3AC6yvKFDx
 ia46bpXA
 R6zQpcjWUBUII9RVMNOkTkQccsQDSg4cgdkXoYywHBKlWIpcqq2W7v2zeT6Y7IJXd3ramqllGMTjRwvxO3yUdl/J5vDcV+Okl4H/trHszdfkDsUBIDg0PiHv29bYIihEIL346dsiDkCd2mpcUB/Pq3sjo7Xpo5G0bo0oMxhpAloTaCTk1ZCqtwKFSbyN1tZw9N4vCdr+nTB9WQhiXFe+F133LHpo04KaB2+FwKkoeZKXhWG9CF0amVg4q3d6GJyeqVmnhuo41nEDT+uRTw1BoVTFeItW4/5iwt8ad/OMcmPHmMSya9nqGS8NRiuWH4XVga6Teo9RD/MnuZ0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

commit 3efb9800557b ("mm: do not map the shadow stack as THP") makes
shadow stack mappings default to VM_NOHUGEPAGE. However, userspace can
still clear this flag and set VM_HUGEPAGE through madvise().

Allowing large folios in x86 shadow stacks exposes a limitation in
folio_pte_batch_flags(). For example:

  1. create a shadow stack mapping.
  2. apply MADV_HUGEPAGE and populate the mapping with a PTE-mapped
     large folio.
  3. apply MADV_DONTFORK to the first base page of that folio.
  4. call fork().

In the parent, the first page remains writable and anonymous-exclusive,
while the remaining pages shared with the child become write-protected
and lose PageAnonExclusive(). These pages can still belong to the same
large folio.

On x86, writable shadow-stack PTEs have _PAGE_RW clear and _PAGE_DIRTY
set. Write-protected PTEs have both bits clear, with the dirty state
preserved in _PAGE_SAVED_DIRTY.

When FPB_RESPECT_WRITE is set without FPB_RESPECT_DIRTY,
folio_pte_batch_flags() normalizes PTEs using pte_mkclean(), which clears
both dirty bits. This loses the distinction between writable
shadow-stack PTEs and write-protected PTEs, allowing them to be grouped
into the same batch. GUP-fast can encounter such a batch when walking
across the VMA boundary created by MADV_DONTFORK.

Since there is no practical use-case shadow stack with large folio,
ignore MADV_HUGEPAGE for shadow stack mappings, preserving their
VM_NOHUGEPAGE setting and preventing large-folio allocation.

Fixes: 3efb9800557b ("mm: do not map the shadow stack as THP")
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: <stable@vger.kernel.org>
---
 mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4bbe319ef86f..510e66d82379 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
+		/* PTE batching doesn't work reliably. */
+		if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+			break;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		break;

-- 
2.43.0


