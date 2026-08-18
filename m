Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B094C5DF85
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD686B08C3; Tue, 18 Aug 2026 00:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556EC6B08C7; Tue, 18 Aug 2026 00:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A976B08C3; Tue, 18 Aug 2026 00:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2D906B08C3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:01:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 883CDC0A80
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:06 +0000 (UTC)
X-FDA: 85113039732.19.A3654A8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2D58180007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RwYiQyZ1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fznq/o2YShbuayKM0ksE2LhKkcoysixYwDK2OVdlfbU=;
	b=RDOITvQ9yA0fuN/+wTYaFaBuTnBsBm5tv3Ja5/WZTloK3g8OO5WL1p0GudJWzu1b4zr044
	fxs9aUQAkPvMtfr0JMvfmVHfxGX0ShOZa/5Jv0fu8NwdVCajE1kPbr1ugvhnZNfsyewiy8
	hUMZPRMDYdt3IEKExWcLSOp900YSWcQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RwYiQyZ1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025665;
	b=cZ+3zXR2epJ/ehk8w10ln/XgQYAa+QAPwlUfFZCF4tDgpKpgY39KaA0EL7rzGY4wmt2UDy
	mqnQMbWtbNUEo8KOFeL16m0TGR5XfBdzlT3ldgyYJrO0uwq8iSIGNUqVYEiMTejVfdJ2AR
	3WlrfWzQUljItjJscsB2d6q7t0W510I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B6A619F6;
	Mon, 17 Aug 2026 21:01:00 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18FEC3F66F;
	Mon, 17 Aug 2026 21:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025664; bh=+IOKlajyDGmq0sYEfpdSj8LTjC//Z3kh760ik0Or7T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwYiQyZ1+Gm65Beru//SBDmjn+yw3OE19u+NNLDDYSJEmLRaTwxULRvx1BeUbv2jK
	 RMrPw8oBILsTv6WNVwRvec7ZHbG3DUf5WAPvJbhSBJcW8jGsVmR0JNTmxttvAgrdYU
	 j6l5G+LrXUhY083h6l2N3RQI/Kw9J2+W+viSZqTY=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC V3 5/8] sh/mm: Stop using pte_ERROR()
Date: Tue, 18 Aug 2026 09:30:38 +0530
Message-ID: <20260818040041.1891769-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jcnr8a9wdq8rxzn6zdkc59ceiumy1hm5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2D58180007
X-HE-Tag: 1787025664-694936
X-HE-Meta: U2FsdGVkX18r0emTQpOk+iF2yuXI5hgcm5VALDsBamYqTCwkW2UOm9fg3ppmW8F1EsUVoxcUfC/QIVwuufB/T75zX4QfKK3CZ2Qti83wLVGLlPh0k1+Khwi3KbByAy4jZCA9B+HVPYo1CTKCaLZbBKLyzrICcx6A+gMB3M6D895/4+OvZVM13VKxFiBrQSFT82dt/WEkGJU07Vc+CdLVyH2S49nesWp9oUhCmQTSjuys6poah/nvZWn/WiaU+MrxbemvsVGwVDzbqiCZDh1T2rY9r6xwoG8hdbsOMuXX0w3fakFZPIS09G/QsnXUGbSGRwRQJceBgUVnbJLB4SIUwVtq/iNQCA/6LAp4xmocKgGNDICBNVdp62DCR+gpEIv2Z+25ByHiDGnZPvt98Af47Gl0H6fDMbsCYXk2tqNNfuoJZj1s66ci1bQpRtF32VMZZmtLR+8SN1x5mBJfO0H/QHR23P5L1kwIh7Y9U2ncEAKhtz9zbCTJpljyX1DFjUACqZMVHx0bHoaBU465G9m2KnsaZJC96qr2/xyOpgjUjn+aeI6996XFLjLm9v1G5MjXDSnOZodVw/NE98lWKMrPrepgXWTlL7Iv7dDC2mR+GrZfOFJmMpc+Q3+YmJtFszmIO98aV12UuapugEJ1/GqqXydNNlwBwc3GH0z4eN8pGw4Gc7LexeiMjkhDky4acmgNfWUx4mSSg/h3gPd3tRjpUeFWj+PJJPc9vqz8Ogk/2GL56TD0GOTUvft0nUn/AstE6jMMQaruUXq5Mlk6yIzQnwiGUGqDRCqWBwAyYWkyUStVmvm9wSBCMJIGGIJ+r/h6n6ye2s98WhBx83LZoN0KaElrdax5I3WKmQLYh57BAT1iGp8nk0/0sApF166E9vLOgznCKSIT33I1YrwAGGo4TQOlNjzaCM68Czd8xNJ3brIB+21DEqhiPSormMCquBa1976vUjb4HfhRSsPTzRx
 6CpB7geF
 cmBn7ZlkAwVsJYF7Z4b663f9KfVVIi4DVpMSYo/BHYSTJcR64rXirzgfFaK3duOj3Eqhix0uNW+AkP/uWftS8/Geai6no4gxlzNpXfGZGM8i1T8qt1A5eclqj6YxvI08BKygwVl2Bjo8WZEjeRPSTNZndHAseLqKA7RRI1gSfeZJ32N4M+WasLzsNlxwbtNa9ZGJw7YNWfUnzwvUeTWr408mVuHdZkZazssXo4h580zI2avwgL4FM2gXlumHW03BNd6vkF9NlfwUhJBo+dkaaPy0KSoTDdqTH1Dh6fYdoaBzRLXiHzRwvjgvH1sO7ybA/pZsNA5BNCHNVFazt3GjPgLXCX4QFITqSx1bRuC+2YwqvqyRFRXIcWdvY1pqdRmj12K5SsMHODn317EDKbJfj7uSqWRC4OjgYmf5GSl7pDrQRz9hGT8snlShx2ndrWvC7+Nwl6YueQa4t/k7x70yQEcq8i3SW/o5L5xOit7TGNvY71g1Y3K4hWiRVVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps in
eventually dropping pte_ERROR() macro across the tree. In this new printing
__FILE__ and __LINE__ has been dropped because they are always the same and
don't really add any value. Besides ptrval_to_str() has been able to handle
different PTE representation with and without CONFIG_X2TLB, which helped in
unifying error message printing.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in RFC V3

- Cleaned up the error the message and used ptrval_to_str()

 arch/sh/include/asm/pgtable_32.h | 5 -----
 arch/sh/mm/init.c                | 6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/sh/include/asm/pgtable_32.h b/arch/sh/include/asm/pgtable_32.h
index 5f51af18997b..c8eb9a7a4c4c 100644
--- a/arch/sh/include/asm/pgtable_32.h
+++ b/arch/sh/include/asm/pgtable_32.h
@@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 #ifdef CONFIG_X2TLB
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
-	       &(e), (e).pte_high, (e).pte_low)
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
 #else
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 #endif
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 110308bdef01..9466ae6f9f16 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -84,7 +84,11 @@ static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
 
 	pte = __get_pte_phys(addr);
 	if (!pte_none(*pte)) {
-		pte_ERROR(*pte);
+		char str[PTVAL_STR_MAX];
+
+		ptval_to_str(str, pte_val(*pte));
+		pr_err("unexpected set PTE at %lx in %s: bad pte %p(%s).\n",
+			addr, __func__, pte, str);
 		return;
 	}
 
-- 
2.43.0


