Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7195EC5DF82
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1C66B08B4; Tue, 18 Aug 2026 00:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7790B6B08B7; Tue, 18 Aug 2026 00:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A346B08BB; Tue, 18 Aug 2026 00:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3483F6B08B4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:00:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D866C0A6E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:55 +0000 (UTC)
X-FDA: 85113039270.30.77FEB8D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id C38BC1A000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:00:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VDNAxtBQ;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM75v8+kPfngk/1Ka0bGUaMg99Ev5p21yXzyy++1ZNk=;
	b=7ROWFmc0N1OFg/mhW88hWR+h4bWT8ZfsIvOkfKNohupoSrQU3cjyN2EH1DxSPV1FmU53G1
	oNbkQ7cvk785y1SZKwlghX0r84+yFWvP+iKQNzoC8CxJHK2U5WemJAn/Lb4nNAAk1JSCLq
	T8K1FBslZN2b4lP7nPJIuE2GCkbMvDo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VDNAxtBQ;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025654;
	b=4tSECJi/8+FgA+VWA6VAmx1OJ6tefLBlkxFT5VjbKvathHtX1dvXfl9BIaYBXm0Lt+M2jm
	pFIt9WxWFCkUNHXFBCRlM2jyQhgnq8vKyuoT6aAgHDSFbl7DfJ5jaUvhQzXuli98S5c/iz
	mtZKFwZkSC96Q1mzLpkT1Gbuub6BGaE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABB77176B;
	Mon, 17 Aug 2026 21:00:48 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99A093F66F;
	Mon, 17 Aug 2026 21:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025652; bh=EW78rNPYlnbPGtLiZHGicUsrFYH/KtTsRTBqboGjipA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDNAxtBQQ6wScTg+OmzQo2WjWBv2oQBrkhEacV04Y3s26ulIQqhAxmubkmAsBCt3f
	 w3LPVMcpAj+Ej3fS+wnOSSmNgjfpsYRDC5rFye16er5IS7LSHQbdaBR0hhnKSWgJXq
	 4kIN7sNYMnv4fK6l0sbc5HmTfSTT3PeHiEXsbcH4=
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
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC V3 2/8] mm: Stop using pxd_ERROR()
Date: Tue, 18 Aug 2026 09:30:35 +0530
Message-ID: <20260818040041.1891769-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C38BC1A000C
X-Stat-Signature: 6bede57js6e3985bxbcehm86mmzdestq
X-Rspam-User: 
X-HE-Tag: 1787025653-600094
X-HE-Meta: U2FsdGVkX1/xUQeieYhc+2Wszi63EcNcKeGv4nWIvKwH9hMxhOBDaBV90fkpqFU+VnRul+tGw9fZVEg1oIVfSx65Kwecn10rAcl8sl321cZi44eSvgZiw7nS9yrlYCM8mtkibpykLH9kmVx1KSbIJCmDvXLABfbn0+MhB9CCTkAj3b9MvFrxhox7txFNWosCeGmWvIcOfgnIPeXku/mwdbItdFvFYi+VhrRkqPazrfXLznid7gRkzv2hyjquW9NPAW5q1jDCHBh0AWgxpxHWzV/ivW6yoBuqW6Nyh7ZRloW/kcR073iY8PBqcaVGfKsJbLGOdUaNjH0OioFg9lHc8+VlsVrqfK9Bavx5MHoFw4HMLv3fZmJEA+Pu0U6vFOfmpJaSiGD/hUMeoVsZkYGGOPXCDoVAy8ejuJ+YeThoJ2uDXNJpWUduPAmkmLkrqSIA2O5jDa/jFwuWq+mSw/EcCes29RrwmDibapEkmR8SX0SnXONZwX8pmNnQXBUh9h3inJOHE8mYmTPinsZRb9udC5g4tYYbCenHLNWhFAUm0YH9zqvghTAb9qAlLlOau9o7FazUmBGjmlex/6MvuDs3KT6jqN/AEwArKCb8rqQ0u0714BQ8eUkwfYTimCh7nmAp8L4yCJ2sz/iRzIMzJJkSBj48C9tR4XboSyFYrFiPBfHM7F1IKLUzGvgHrYW9lDL6dhzOj5cq6Yo2b/ImptWfD/fd7pkL8P2pKLZt5EDJttCClFSqQw9iS4fLhe7VwJrvIrFRbGZ031G+7ma5McnIRU6beKX5wgfOoVr4ZUK0MBkgkEDHiPg0GEjEPbbNGO9/I7viil7crivT/sCWS1ifAkLaQSh3fRM5fAAOBiGSy1X11BV+iIlOIowvnNB5HW9tvX02/oB5a0LWX3xhg3LiTddQbrAh41QzvmIeUwmZbv54H5aLWTmx/xWK1s9iSXvLsw8InqzHVtW/07Ay7qt
 7+0Xglnx
 15eCbcYvB3PcdOtM5CcZd8jaguK/Aq3QtH4+PhVj6zo+B5n6zx7fwNw7nldisN73jhmHbPABS6gAns6vBrWG2HGDaT+yaAMeidDsu+kzJ4Ks030KNELG+w0dpe0RUUt+EYgdIl3DJ9rq+hENyMnJhuQiDvP/aIGgxgFPtIA1slBNlOSpjRdzUucPtTxFxcqZ5qaK44GZUk/EyW10wPEaX4Q9Dj7bIbaGqlA+qE4HCE1NhJLJ/6rS0PemlCDre3xxXVgp89pi6L8d7KO1XUx2i6OGD6uxerIXIHllLkt2m+808NqrHD5FbHn24PCylyRJKUQhVQr8zUU2eE+xYM9xiBCujlUJBdT1E4n7OxnXn8IuA6ffcObaMtXK7lJRr7RaU9revTrQxKdeDNkEKqiiAYYUQJH5H6ugoLlEGtgf7zmE3EBAQTbMNhzQSpcYhB+h7y1ZPeIMB1lb+FywMq2rLUgZ0C82F3Lf2o+qJtVFKc/5X+8xF6buVLelVBdN6vIqksUvkdp941ZWeXQDN21guaI0ouDDNjiJpei3/RpCDu8/SlT9Q3IkH+d6TDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pxd_ERROR() has been used in generic mm just to print the page table entry
in pxd_clear_bad() before clearing those out with pxd_clear() later. These
pxd_ERROR() macros have been provided by all platforms which basically did
the same thing.

Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
page table entries thus completely dropping dependency on platform provided
pxd_ERROR() macros which can then be dropped off later on.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 mm/pgtable-generic.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..f093e2474f4f 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -13,6 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
+#include <linux/mm_types.h>
 #include <linux/iommu.h>
 #include <linux/pgalloc.h>
 
@@ -26,14 +27,20 @@
 
 void pgd_clear_bad(pgd_t *pgd)
 {
-	pgd_ERROR(*pgd);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, pgd_val(*pgd));
+	pr_err("bad pgd %s.\n", str);
 	pgd_clear(pgd);
 }
 
 #ifndef __PAGETABLE_P4D_FOLDED
 void p4d_clear_bad(p4d_t *p4d)
 {
-	p4d_ERROR(*p4d);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, p4d_val(*p4d));
+	pr_err("bad p4d %s.\n", str);
 	p4d_clear(p4d);
 }
 #endif
@@ -41,7 +48,10 @@ void p4d_clear_bad(p4d_t *p4d)
 #ifndef __PAGETABLE_PUD_FOLDED
 void pud_clear_bad(pud_t *pud)
 {
-	pud_ERROR(*pud);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, pud_val(*pud));
+	pr_err("bad pud %s.\n", str);
 	pud_clear(pud);
 }
 #endif
@@ -53,7 +63,10 @@ void pud_clear_bad(pud_t *pud)
  */
 void pmd_clear_bad(pmd_t *pmd)
 {
-	pmd_ERROR(*pmd);
+	char str[PTVAL_STR_MAX];
+
+	ptval_to_str(str, pmd_val(*pmd));
+	pr_err("bad pmd %s.\n", str);
 	pmd_clear(pmd);
 }
 
-- 
2.43.0


