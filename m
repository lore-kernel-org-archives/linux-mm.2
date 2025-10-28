Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29BFCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 06:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DD880123; Tue, 28 Oct 2025 02:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F25800E4; Tue, 28 Oct 2025 02:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0545680123; Tue, 28 Oct 2025 02:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3E19800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:40:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74946C03DE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:40:29 +0000 (UTC)
X-FDA: 84046574178.07.8333B25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5443C0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:40:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761633628; a=rsa-sha256;
	cv=none;
	b=0gbrUDBLAJAvNdoWbITaBx+7k68+zzcHZf+ZRVl4MNjZrglZOB3Exq2q0LB6AhG1rHbj8B
	Wj2GagSGiZgWYM0gfm0xnNu/tpn2RMzig7ZNBDKURQOUlvGok8MD8ttTzSp7Ib0RyPLjNb
	vZFg3VPn/9qeArEurqqu1bpG3ARepHs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761633628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Gib7w9/Uv8x6admdPu841V7rBSvfwIccTBUvFietYn4=;
	b=e/+nmXmKpeXHSWBrl6Cc2CXg0IscACxAYYfnfGZX3MdlZdczyGa8ZTVU4nYzKqEbNwQpRi
	WrSm7e+a5nPXrvSACsZ/wpcLjj6gz3nzPiohWhUFQEqhviQG7QA96Wig6rmXxwwlFdWk7Y
	94g+/Kt0n+K8FNyMRn7lDPLBKPoKNkY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE26D168F;
	Mon, 27 Oct 2025 23:40:18 -0700 (PDT)
Received: from Mac.noida.arm.com (Mac.noida.arm.com [10.166.150.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4C06A3F63F;
	Mon, 27 Oct 2025 23:40:22 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	stable@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org (open list:MEMORY MAPPING)
Subject: [PATCH] mm/mremap: Honour writable bit in mremap pte batching
Date: Tue, 28 Oct 2025 12:09:52 +0530
Message-Id: <20251028063952.90313-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A5443C0003
X-Stat-Signature: d47rq3zbhywdizir3oj8ppdjif9ng7pb
X-HE-Tag: 1761633627-380867
X-HE-Meta: U2FsdGVkX19OZinA/hm5pOLYF/LlagwIA5c1jgVq+UpdI43WhOxfsbVMxQrCjzzv2PL4dAG8qkHXW9nBw9ri/QokD1OLqF9SdV3UGYMBobRf18E+LtnMGoYK/LxJdxqjeeg5Rrt1RjC1e2rdb4TEwVSUbY+GWJ0tComnb8OHLWu5jKfKGonn0XZChMFQUPuTCzVARacZwg8oJz7g1aaoyxIJLx5vI1MKrPg1MsI06cFH/Vyc5WQ+HHroJ0FpCi0nr/TQsrKDNDQQuVJaK8m8ruf6KVLqoNgfepPI2fGRvM5gJL896qd6lChRmXYVz+KnT0y6R1mF3krIkNPCAdedo7hWduNtsef1XiPmEKK4Kr3ZAdAm8zGW0zLiGhQLeyq7QsNTocpzkcYm96cKQ605Sul6l58EpIDXz2wn8N3ltKcZWWqRZL/pbuMTC3E07q739sJMOU6X4Irmx7InkXGppvnwLGjgxEmHg/n+PRYOLrKvNqoqsrUaLxvFmynYDgVwVOL2wf5iZ+0reOYxDksR3mSM0iv+VAy/kGeODvU4sJTCOYazsSZmYSx+lNaxEOVYS1lwB+GCEHOKwInR2ALm94UMlsFo96fVFuu0thf7El86Uy2KCHl16/PuSO2FzH2wgQF+DwWE7pR2SdyIk97/3VzoHS9sssz3JNh0wET3K6dvFBxnnFLr0UfK/BYpPSZTDlNgJmt5uaIcpIFisBm9Eab1YEfvgELU4VFCkAuQaBskdUG3+APgXeTI81vWbDf2ORsptr/sqKmjWm6WHbooppOzQhUZQ04EQDSgU3fSV8zexvmKQtlj3Q/BXh78Btxk1tSxAvhJo9TJmkfOzHnj35q04SskkQ/SGq/XnIceO3nz7wvNSfWmN4Z5NtwUcG+EjdsIubvIRyZZwOlh4B69ap697dHGEfR7Uxuq7Kj3zy3vQk7waT0MM43AGk9gbWdEPyA6xr3U4CCFsCbjnJU
 EBxQC0cP
 JVRpUXtaNAd8HmU1G4lR5XdF3No/c5+gQ2yVh609o8XkgHA8snv3nnxGFIpYizDIcGxw7BeGP6ZSE0WYT/L38SwrQ+kbNjod2faJiKnQBe3ag1fuHoeiP28iqFcimAUVchKlzyfQuNYPofl8vAyD3ezqOG3kWh/SslLe2SemSWORzbJO4LCyZV5mo7pBAOOIDN7K9ad+/C4ENOpA43onNCLANgZZEumW82omdygZTSbGNRAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently mremap folio pte batch ignores the writable bit during figuring
out a set of similar ptes mapping the same folio. Suppose that the first
pte of the batch is writable while the others are not - set_ptes will
end up setting the writable bit on the other ptes, which is a violation
of mremap semantics. Therefore, use FPB_RESPECT_WRITE to check the writable
bit while determining the pte batch.

Cc: stable@vger.kernel.org #6.17
Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
Reported-by: David Hildenbrand <david@redhat.com>
Debugged-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
mm-selftests pass. Based on mm-new. Need David H. to confirm whether
the repro passes.

 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index a7f531c17b79..8ad06cf50783 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -187,7 +187,7 @@ static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr
 	if (!folio || !folio_test_large(folio))
 		return 1;
 
-	return folio_pte_batch(folio, ptep, pte, max_nr);
+	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, FPB_RESPECT_WRITE);
 }
 
 static int move_ptes(struct pagetable_move_control *pmc,
-- 
2.30.2


