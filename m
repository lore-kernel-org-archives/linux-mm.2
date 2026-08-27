Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11EF8C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4F96B0088; Thu, 27 Aug 2026 15:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097996B0095; Thu, 27 Aug 2026 15:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1176B0096; Thu, 27 Aug 2026 15:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3C586B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:38:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43310A01AD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:38:43 +0000 (UTC)
X-FDA: 85148061726.15.0ED4123
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9DD59100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:38:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hCsiLOyl;
	spf=pass (imf05.hostedemail.com: domain of "prvs=692fd96f3=zcgao@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=692fd96f3=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787859521;
	b=3XoOLOAtQU+/PAfu3ExiVFdPGO7MbF3Ex6ZhOK+CIoE1SezpIQEbi/Sbzc6unRNauKv6Di
	+MFkyuw1V0WUwAGC1mnkGcsghXaPlYV9XT6TagpTFNFNHQ/FBv7yuFdnkekpadm6/04nmr
	Q1cSQSicfvSjZP9cZ1FrLwjVYQ/HpNE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hCsiLOyl;
	spf=pass (imf05.hostedemail.com: domain of "prvs=692fd96f3=zcgao@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=692fd96f3=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787859521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oLAeOmZrtq36A1IcHxniw47pbRoh1qR6Um5nSXbPo1A=;
	b=3hG837e4anWiHTvQoBPxtwSUU+G4TRuGqS8qJxfOd6l8VNzQrkEc2a1F3bY72seYdnGw/K
	hf0p4o7H0/Lm7wyDW2eAYf9hXjeClBOoNblsiHn+36QWe9WKvgppHrNjbf7wzxLPEJJHrY
	6Uc0Wkz2w88w1IZHZJPuEykLs6lQK10=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787859521; x=1819395521;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oLAeOmZrtq36A1IcHxniw47pbRoh1qR6Um5nSXbPo1A=;
  b=hCsiLOyl+1eFhPEde8t2Og9IkW9uWVq5hs+vkeT9lE9JQtPE5vAyYUcO
   ThR2du7WELtpMrAPfWVmB9YknRzuT2VHiDcc5n2ixCQdlespNtc2vgA7D
   zf2Sp51OwWjK+/CuBX0imL240i9uEDVEPiXVQ5aPFWP+i6YVBRJm8q5Q4
   blRfMJGm9IYr2aWsRKL5rPJ8PYQcqXr2RD5clwkzS696eqgIDL0hn/8Zn
   9wrBfBUBu6iJwt3s1aezDFMyf2ya5pNBPjKKUsHoCGpxktPhfMq7+1VCR
   EHy2wWNfqH3Mze0QOfXWaItP+VaXXlN+dp/R4NkyV1LXJ2BXlp6wVIskx
   w==;
X-CSE-ConnectionGUID: ZMdiy7luSDy5KUaN1uRScw==
X-CSE-MsgGUID: LWv9H5gNTwqEPlTS5WdLNQ==
X-IronPort-AV: E=Sophos;i="6.25,247,1779148800"; 
   d="scan'208";a="26951848"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 19:38:39 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:24810]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.27:2525] with esmtp (Farcaster)
 id 2c62c1b5-ce79-4e1b-b168-d99646deb830; Thu, 27 Aug 2026 19:38:39 +0000 (UTC)
X-Farcaster-Flow-ID: 2c62c1b5-ce79-4e1b-b168-d99646deb830
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 27 Aug 2026 19:38:38 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.170.26) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 27 Aug 2026 19:38:38 +0000
From: Nathan Gao <zcgao@amazon.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <baolin.wang@linux.alibaba.com>, Nathan Gao
	<zcgao@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm/damon: use a page-aligned sampling address
Date: Thu, 27 Aug 2026 12:38:21 -0700
Message-ID: <20260827193821.46115-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.26]
X-ClientProxiedBy: EX19D032UWB002.ant.amazon.com (10.13.139.190) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DD59100003
X-Stat-Signature: nj9373ww3o8ycfoim5poqdramk9r7n58
X-HE-Tag: 1787859520-265369
X-HE-Meta: U2FsdGVkX1+YBRjP5g5dDAyUQdih0nCwg0f1G65aPTRjHpSxWOw5QrRbv+vBFao43/0yKSfyR8jXGxNneAk6jDcZIWFNFu7jiEpyU9UZI7hQ+E+dAp91ZtdWUfamezc4OyWY5+f4VXfhJYIjVcQXIdM3ciBFzIvtxWYRrJnWtBwECyJdFRaK2wAap26dJjc/hBdKPx0l3cxNz2g8cFZ4Guj5cwT9pbO62dOI3rl/tr7FxWI3bQ3ueOAgUcbcRFFux6av/by9kqSDQdISelkBIKtQpBDr7OyXd5welBqyMU80ZzNw4nO2DwRin5qj0BNbDxuiIkZDeY51HbBo2SOhCP3Yg6shQ0dMoIXHEr6Q9gn8PipVtpgssD20xS8dvTDd9e2VEYg720MnSA7hSAGXpgteKH3SbFNB754Fg79uAHuL76bHp7e1A8HuxofYQyPWY0HUWODLse+fvyHCr39BK07921nnrPGBG4UyajvKnFl+P63ZzanY2uy8DzaAbAeA1p3b9R9Yv0rTCQfdCnLZ4f+XXd7OuO+w5ssMjn4zGEi1exmDEjn8L1oyswRHdZdz8KFhVZgbmNxSH7TAuX3kIcXKQpY5xIl6w5aDBLTpBgEgu2vYx9BGzqYz92ldiF99hZavFHaWaaGvJSF7nFk8WmDh5RUzMmEoAyUxzL8JMi/JL1UwdYuJg4fAnvGJ1ZqMbEEunwFYPAdNez8iiSq8/dAUBPxU/Te2OKB5IieKryyhrZBhgQG+cb8mbs1qWQ34E6eSePm5nzMaMFPpTML4omICUqs5Fq3i/u4Abk11TO4uuaYskJEnCaIYw7QHJjQ4nwC5RRU5VLF/u2oytcLxJ0pJLcnOpueu7o3nsxreEIhiq/HynvpxNOxFnQbg1KTX4Om3fzdrTGOczfRkqZbD1lcBAZfgY4aEzW9V11RiVu4d0VVKPS6ATTrqhfN8ZyHzTuL2wR17HfPvYDZw+JG
 g07/Wb66
 8ZY9/S5M9c4gYJdVShp4fSL62+7lxHJ++O6D6Z6DOp0FF9T5jrS5tf5WqCIrdIzhze/R4cRbssv9us/7tF5CVaSPfXLdtEbeuKTm9dhgiOX4H4cbJ7LDoT6OqnE7tU3effHwgHwbNijtRYEluliuIxolg9ka3GX28y8gUW//jAw9CC9Qn08QbvnV2ERwzxFJ8nrKLi+WYR+tbRYbuOWwedDdjcRiyxce7GG+4q3mCzKmqHopbwCGM+IVGOBTOYWz2I6loy/OeFqh0NoahySOpK8qV1vk74GAPCohrwn8ipT2lPD9RCDyTQSxtJX5UUQiWWQGRx8jJwy0Dg94BWMsRTZSzX5bBhdij1x2CBqcvCOL9JQ7o3/kB+QMl7x0w9qzmWkfjXNjWQGu8BurW0lzmfUMZ8eWFAluOVLmNgEE+B1EuWx6rn7NmwUjiz/vjKzSrQur9gI/A+R/iGxTYZpjuvuXeN6W0pP4tbMVO+kwk2RlDHRfD14t8VjoXOkTlWLuWyn/UNbKCW3qDBk6o8zaxlJiWPUhsuRqVtzQ1nYBDk/1aFZwHXevMPNV2oqgmQ94wXrgfEI3HTKTHB50LJBB8+jrABehoGbd5WqpB10nOfVJWi2f+MmAAtTs8utl3QXysQ08bHzLJsoh84bE7d8VaM164poH4DEa/gK+9D+6ap7qQBQhLr4BpGDdGzDDKTBNx+Kt8YqFO8QL+fXRlrM8p+bXXIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__damon_va_prepare_access_check() picks a random byte address within the
region and stores it in r->sampling_addr. There are two users of
r->sampling_addr in vaddr.c that pass it into a page table walk, and
both use it as the address of a page.

  damon_va_mkold(mm, r->sampling_addr)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_mkold_pmd_entry()
        damon_ptep_mkold(pte, vma, addr)
          ptep_test_and_clear_young(vma, addr, pte)
          mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)

  damon_va_young(mm, r->sampling_addr, &folio_sz)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_young_pmd_entry()
        ptep_get(pte)
        mmu_notifier_test_young(walk->mm, addr)

test_and_clear_young_ptes(), which backs ptep_test_and_clear_young() on
arm64, documents @addr as "Address the first page is mapped at".

For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
clearing of the young flag for large folios"), the contpte helper walked
exactly CONT_PTES entries from the aligned-down page table pointer and
used @addr only to pass down to each entry, so an unaligned value was
harmless:

        ptep = contpte_align_down(ptep);
        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
        for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)

Now the range to walk is derived from @addr instead: end = addr +
nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
page of a contpte block, the sub-page offset puts end just past the
block boundary, so the round-up lands a whole block further and the
walk clears PTE_AF in CONT_PTES entries beyond the sampled block. Seen
on an arm64 guest running the DAMON selftests as random slab and page
table corruption.

Align the sampled address down to a page boundary. It is the address of
the page to sample, so this matches its intended meaning and fixes both
users in vaddr.c.

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
---
 mm/damon/vaddr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2c1c1952c008d..e26e426a56af2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -360,7 +360,8 @@ static void __damon_va_prepare_access_check(struct mm_struct *mm,
 					struct damon_region *r,
 					struct damon_ctx *ctx)
 {
-	r->sampling_addr = damon_rand(ctx, r->ar.start, r->ar.end);
+	r->sampling_addr = PAGE_ALIGN_DOWN(damon_rand(ctx, r->ar.start,
+						      r->ar.end));
 
 	damon_va_mkold(mm, r->sampling_addr);
 }
-- 
2.50.1


