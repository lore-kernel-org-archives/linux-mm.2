Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEB8C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E636B010E; Wed, 29 Jul 2026 10:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF216B0119; Wed, 29 Jul 2026 10:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C7F6B013F; Wed, 29 Jul 2026 10:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DAB66B010E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:54:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF4F91606B0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:48 +0000 (UTC)
X-FDA: 85041735576.19.820CF95
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4EDE580012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RazQNAce;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327947;
	b=Ul1Et+mbM/YP+sIArVCJkrCRU1Umi0RosWmjbkHU1r9xIz9hbPj9rvuxdy5OiBZ1J78dv7
	i7+mzcWLfB/KpiHY1rLbxN3+LOtyHFWDNxd+JxJlQT1tiYTnKuVQtkG7DY0SNfUD3h0Ytg
	NNFL4QyWDrBy2mqd6DvoGlAmRX3X9+8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RazQNAce;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jo53haVio1VlnrS6alJTUrd8+2Sz484gQrvanLZfOno=;
	b=rPmm/kexsa2DJOI14lzp54ZtH2wAS3AkRZPR63KA7m2irnaTXJdqzzvWYN3HmSganXD8Ez
	0RhgUwRg2q7mkC1OJAmz4TaVXi7PhGC+WbR+OEESZw3i1E6nI42cqKc9IL3aE4Xr5M7Zg4
	spQCtGzh9BVHbWdudakWN8Nf9UuKMtw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 685201688;
	Wed, 29 Jul 2026 05:25:42 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DA3563F66F;
	Wed, 29 Jul 2026 05:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327946; bh=e/tbyb7uuGOwzaIiWg/gKtdSiKpAp+82nFGZ+nCk/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RazQNAceO0MYDyrP5zeJqA93wHPK2RgJ6USACg5ZxgtqU0RiLyvBmQ86CGFOOkgV2
	 aLP4xDWQnJYkgjpAnSi2SVOQBeB3qrlb+wzjF0ernImZBdwDGYl1XwSISjYY576f/H
	 bMbTnxPAN7yZ/1dYSQzhgpR8fl0OVgp1WZtr/YRQ=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/17] arm64/mm: Override read-write accessors for vm_page_prot
Date: Wed, 29 Jul 2026 17:54:44 +0530
Message-ID: <20260729122452.3797443-10-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4EDE580012
X-Stat-Signature: 7jarkuy6fpdzdami9356hngh83qz3hws
X-Rspam-User: 
X-HE-Tag: 1785327947-189373
X-HE-Meta: U2FsdGVkX199fr24mofxbjeaYVGndYs9u4PHYRFf/Ke81CsVFnad94s1q/BLksv8jtUWQX9yvkttXJIb60vZaK3Iu+4/udPccTnxARJuu/QlHJsdhDG96KFWZhmuLKqjvMIK80sw3CYMFjXcmEeSz8QngpqFn827IbY209sNm+1UHMYSGowNjXIzM1KjfimiYp9/M8LRS+E7Itynq+JrXvDdnAzAZYQhvrUlJrI9bl+L5zxhg+l9Gghw5kwQqdlgkxK1up/lDckmfwSpoIgz81N2LP1fTfVHdDQ7rYNRXCPBRq6kIxIatPQHYW7nrnOLjVYeN3b2HRnhPDpQxzEWEb8hTzV59daTWuKBXK73KVMpOs7+IHra3kZ3cC2cif5rToYlwMnBZTLzsjFNqknRXyVzwNA1+cl9v/01EHHQkT0bzVZ+Ss7/rzpBkwvvTjJ4al4Ay52/RMVG+tXZpa4Mim+JI8nRyOyYOGUFILyl6Wqq3ArEwEfEFh43/4SK9MLoswBPWzvD7o8Cw8cyW0aO1HHxKnA0vCBGsaCc+/nRn+ZlIND36/ynv+t2wGwYOUnUW0WAuq6nrL15Y0KKDwv1V2XHvidRlsvnNSeaI/lKC2KBgutf7zkOprfD9isWhztNp0X0YRNyFvBPnJUuUMceB44oUNOy92JPAy2m38yhJJsaZANEWbweXkUWoP2eH9Ny3ZZ2CFSie0BevmNOvC7qfoNmoEDeapug9ZhdKzEVBl4INPV0QRGUP++a391PwxatoP8NZqcW6anVEye048cDY/tSoc7nXw5zTdIIzKJtrUQNB2fU+LMqkloCu7vVHY40v+lz8lQ2Rth5qrbU4I6B4IE4pMZiLtGifDxsx0GrPHamjRX2pPkTksleMcIwm53eopx6/K41mvdZhPfucGCVVmVbWnsdIn304ic2OajmOowzh8jqFEiC4e0B23JKwwa0ysUDDhhRRF1OXuDfDP9
 I7+Kr4U2
 HWVsTfPzRZjn0fV3B74qIPJYRYMDR4Bf+51z1BpJeeqLBQ8RBq5pvu7pthk3zzeoQslyIn1Z6eNm4auwpwF17Kcpo8K7d4PW4tk+XTjMEp76w5J+O/+Kf1DbGoSaUQUgVntV9ZDp2cXVHzjOrGrMGnvAxxyxjlAwsybXxSzlPUI7mlD9yut7o6RPYq/hAC41D1c9mR33eQna47GDZTsExGs1dyG6HMYiHBTObp0VTyQYBRZExlicFQcqvtzXF+BC/On6hs+llEWOtfbDncKvWLIUbK+N2IJSIbKJLU3iPz7KMJrBbRsUtiAfry9ijA+9RhkZ9d5ybN9MFf0v+FEcTJZNbdEnVJMR09oJNb4ZXkoiAZpcFejbtfEAhxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Override pgprot_[read|write]() accessors using ptval_[get|set]() providing
required single copy atomic operation for vma->vm_page_prot.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4efcacec6f01..39635f9550c2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(pgd_t *pgdp)
 	return ptval_get(*pgdp);
 }
 
+#define pgprot_read pgprot_read
+static inline pgprot_t pgprot_read(pgprot_t *prot)
+{
+	return ptval_get(*prot);
+}
+
+#define pgprot_write pgprot_write
+static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
+{
+	ptval_set(*prot, val);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
-- 
2.43.0


