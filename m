Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63895CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B417D8E0070; Fri, 31 Oct 2025 13:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA958E0068; Fri, 31 Oct 2025 13:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992508E0070; Fri, 31 Oct 2025 13:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 831DB8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:01:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09C3C88BF5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:01:40 +0000 (UTC)
X-FDA: 84059025960.13.CDE3B34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59C3DA0006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:01:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761930098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=zDleg4Mg/E7jKipTuQZM26MqfRH8PXTsxP2sSTdHnok=;
	b=L6u5f5P05yzcWDOtmeTvf2mZtWuwc/Fcew5sIl8e9GpmHyUCxRYctGk70HRtINJe+OTPi2
	3MNIxWmshwozDByDCT2ws6IbglCXXlc7oKsZMP6Mjv0tabtazmgOK9t5WeT46BpFl1i4O9
	XR6HzbjyFJKCzZPLgZdZjw2t7AvrtQI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761930098; a=rsa-sha256;
	cv=none;
	b=m/HcaEQuAMXwMTzFZeD2NVXK9kqj/rMBF52yBRhU74HDtBarqdA9pLOPpz5A/0MkJG+hwU
	D/cb8P9YksEP2WPE3+hHBkdtNlrCmUT3djJWfs3UfUPr/AxW6u0Fjllh0Rzcgpi2EpVnHS
	HZLmHiiHjHuQQs/Bg5FP1VlNC3d7Uco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C352603E1;
	Fri, 31 Oct 2025 17:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020B1C4CEF1;
	Fri, 31 Oct 2025 17:01:35 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] mm/huge_memory: Initialise the tags of the huge zero folio
Date: Fri, 31 Oct 2025 16:57:50 +0000
Message-ID: <20251031170133.280742-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: khiybuyjczdpjm33rnz9g4jn4zfcf7wq
X-Rspamd-Queue-Id: 59C3DA0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761930098-287010
X-HE-Meta: U2FsdGVkX1/wCTnZsl6eodllvQ0PZm9vEwEHUMHi0Ul49I/eXrZWJjkOTbh4xz8nwSitIp+75A/RzolzyMyr+dKC4aXd/8gSpqjF8YOUrvF9qjho5v/xuQjTF/Lmx4XJ8ruAPA0iF+mBBOiUEwK8sJKcWR938LweQvkxa4Wm3uvsmkJgZe42sKk71vqjuiANI5T0/2z/pTTw8nDbixMsh2CoTo9ogarOQz1kzTsQcHMHWYdpD4vmUqzKrTvEzrARfk9P6BsSSKYGObejWf1TQvf1FW4PQjsSihT7QqTqOkB7fySBrndwvkx0mxQqy+C0J4DyYG+GdcXEENT/BbKUPhbg+szUcnUwXxVJjPFXKUeJKG1vRni6XbbgXzQ1QGXdLKi6RxucXzBKr1u3I/D9/EkYDu1XOlITiay5EpIHkPpkkHN/hZyCtvAbtTxB7FmnZdkuOFxcPU2G1lvNnI+EjCAzXjGh36OqqlchrfhPyWWcjKW+S4Ug3WAAS+4eWplOxbCHP/HwMz4Ejt7GQ6Ej3hgL/NDiA1Ax3Bg54lG9p8zqC/Q9rm8eZImlyQ+w2x/8T4DtiJB5lb/nRRdBb3jPsBOOsWRi4d06v9qNC1WoWclVJJHzq7r1ij7ydBgUdrdWr7rUGzS7wEttrDD0rk50wHNdNMMnNooHAJ555E0xJa5r/EUrzf056+qNHMT2SUvJNyje7skcaZp3wBCMuLolyjHhKm/6SP6ryo8R8BpMtainZJiFCab8PcClyyWKXczbQx4dPI+7VIqQLWqlLcZR73SRgmJVX7iA8etJAnmeiAwx+RbL5YmAw9l6PEhZOlp/WeeY3mltLBRg2n1Uqbtce7M1kMOyNN8+3X+g7hqj1RRbRaKPJVYs6NNn7ohXLlP2nYC52T6xJXqfVKRkieaRT5RYVlXMeMVsZTwRBK4pfCHnQ+o0Mpzs204yEc0PIos6fXfCXmtEZRW9S59h8tw
 2cdVbR2c
 lm8iZFDr+9wwUNkFQaXUeuKFivHvCgmLuGWZNWnxEe0MBaeRhohGPtAc9s8S4YBrGm15iNT/HTW3HEnQ599A85V5eOHsmJ/KWLkuymfnkaIIIZTpdzvIoceYKC2//xfEL1QRQnvSiT5DWYwVRSA+3MRuEXcuGEm0UTHxcBL0wA6XxIDN9QOozR/dZ6u8uFSwsmoe6h0ViwGVROquqEaaDzdl7YE9Hv+F+VM7U1ia22s5HdlRTqpRHZ6Sf2vSnM+mtwnN+9NQt8ZFn/4pg81kgfYp078v4SuLOTyEZNEnqhZp/B8Ylo1L88FMZ+zQ0TsKhwnc6kbLHklR9cpBerDXvn3k2ZzjEOOzcFh6TnFAPM6WFfW8cUa7MEqxP+LLC0kEojTPo/5sNn+oPnu3Gi0tuwMSLdY3Ded2in36sTbVeZzYW2ADZ+S7F0PzDEPKai5+bV+pN7CEc3ElCVysu723mxnmc+BD1+AZBwzGRXREkVg5mn69armtOt3ivob2gd1TF3E/z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64 with MTE enabled, a page mapped as Normal Tagged (PROT_MTE) in
user space will need to have its allocation tags initialised. This is
normally done in the arm64 set_pte_at() after checking the memory
attributes. Such page is also marked with the PG_mte_tagged flag to
avoid subsequent clearing. Since this relies on having a struct page,
pte_special() mappings are ignored.

Commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero
folio special") maps the huge zero folio special and the arm64
set_pmd_at() will no longer zero the tags. There is no guarantee that
the tags are zero, especially if parts of this huge page have been
previously tagged.

Allocate the huge zero folio with the __GFP_ZEROTAGS flag. In addition,
do not warn in the arm64 __access_remote_tags() when reading tags from
the huge zero page.

Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>
---

It's fairly easy to detect this by regularly dropping the caches to
force the reallocation of the huge zero folio. I bundled the arm64
change in here as well since they are both related to the commit mapping
the huge zero folio as special.

I don't have any preference how this patch goes in, either the mm tree
or the arm64 fixes one is fine by me.

 arch/arm64/kernel/mte.c | 3 ++-
 mm/huge_memory.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 43f7a2f39403..32148bf09c1d 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -476,7 +476,8 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 
 		folio = page_folio(page);
 		if (folio_test_hugetlb(folio))
-			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio));
+			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio) &&
+				     !is_huge_zero_folio(folio));
 		else
 			WARN_ON_ONCE(!page_mte_tagged(page) && !is_zero_page(page));
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..b7498e51282a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -214,7 +214,8 @@ static bool get_huge_zero_folio(void)
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
-	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
+				 ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);

