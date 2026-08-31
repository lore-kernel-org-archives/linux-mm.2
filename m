Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EAD6C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06316B0095; Mon, 31 Aug 2026 01:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FC66B0096; Mon, 31 Aug 2026 01:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58796B0098; Mon, 31 Aug 2026 01:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 725F06B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:43:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C84821402A4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:44 +0000 (UTC)
X-FDA: 85160472768.10.4BE3936
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 157A5C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:43:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bOYCZ7KY;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788155023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJYurZV77Ugv5OPsFiZ0YfDrbpkWpLq/Kkn2WQCklUg=;
	b=rHBax53/+mFH1Sd8nMRyc5z4wwzkiw9ANawkisv8LijFLquGkRGqsjSkFT67kG8ipfaxOr
	4XZpNXvGdTgvYVOIAHCXq09rpYIBZAtaIW4lD0rfNkUoezLvU+ifCu1SBBiNVtvgPakVGe
	q/0h/ZLvt14XyXgBOxs8glBvsdtF4eA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bOYCZ7KY;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788155023;
	b=i7f7YX7+mWY9H39u8E2hCv0Mpfn3FX9+sAkSa+fr5BTJW5Vtoag84tC768ytHLdDb2Vp3a
	DZukmGeqggPPYpuWmi2AKoXuuzY7uvYVMlptxE3buB0/KpOqVAyfmcoF+ffWGM5glde50H
	/42T7hxkOLPw7nAmurrderVFtuoYwMA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81995176C;
	Sun, 30 Aug 2026 22:43:38 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85D1D3F85F;
	Sun, 30 Aug 2026 22:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788155022; bh=QXu4QCgmr2H1ZCNmIiMG/ZtqTETXJXvgk4Bv9ZBGY20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOYCZ7KYkGWJMwi9hv08o8CPIK1B1PpAWsT/CWN6Rgcfw95970wz0SYilqsTPRRdM
	 jy771f4RrMqp3RlkJj0jL31egGOxLsKMhmyO6mjoCsqu3qGWanVlVBYExkolRR0f08
	 s6ecC7ZYicemVZWC8wmn+aaVAZnWZ7DbjWG2cN+I=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: samuel.holland@sifive.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH 2/8] mm: Stop using pxd_ERROR()
Date: Mon, 31 Aug 2026 11:13:24 +0530
Message-ID: <20260831054331.625505-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: px46z3466t9ybti3b9mng4dsybyob8nf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 157A5C0002
X-Rspam-User: 
X-HE-Tag: 1788155022-192807
X-HE-Meta: U2FsdGVkX1+h5JO6i3o4cjFIwagbTe/hx8JKmh1hpwOuHgdr+vsh2YsZS6RXSDHT+nLWu9xDG+AnMiGOVIoa+o3mweYANT2ctXTgkTZq43v1UPbkI1hzNEebBNrNXek/lyda6Zpf0MyzFAmkNK3qNLs+lwIqc25MVivpDY3+vP9cQjVZqbQpllJAlYAjB0uDLN6QPBsx8L0KSEUfi3GOPlZbeICExmiB4clsCJjQrm3pJG/Ng5LSSqJapR6ZX+Et1y6EK+awWCRWtgu12kzo06Md0L8y92xEQ6LrRCJ22QIfIJKTAorD4QUHSimTpHCCgVtBhBLb0+A5X9hzV/9W/5eKMxgKgIRPqJpqPLEsrYIGKfOV+JhEufuHOpAnDwoq8KbsSMWd9YAR7vBjQGwLJO2rV2VObtzpiwEEfbFrB18ldxy/HSwF4iKGaFwkcNX1yr5hnm6tnPxjtd16Rf1G49XcdZJiBSp52+QbvYuGtGtdYOFUyLmnnRYH8fLgF3QzArYg4S2+lucaN2swzMusuOXsnyr3Ano/LykFeZbPnJXiw7EOppzFpXwXocwWyg7DfEyj1Pvmqp866EK7XLIFmtsJ10CNRsvcFgZK3JN8OKRl2p374pOGaH+shZIOt2LF3Sh4zWwJoBTdVTFZMyprRbyaXu3dPEOBUes4yBlDDoqVUV/emf+6Mp/nHhd53M/ep49/zwkSP1lHpsm+RG2Rzeo9rZCEnR5BnxYuljclSxOgFKky5oBP/XPiOEgVJpIhUHfpubH/BmVe9cTEbD4jlCj/Alg2180rVQQAEi99sMHpiLuS3IbhCqol/PKaCfkJZM9q3yFn+qZJ5E/pWRu1SjjG5hlgPONOJEJGS3kdnyyZZ/5zUlUNjdkqYwM4M5mKUsdJ3jkZjdi4J6QwYpD0tOhRwlGHH0nU4aNZGd80VCOnnsqNjEelf4XJLV3nYHjMDhSUNjuq7k8obFdOC43
 oFJIoXXe
 +lYw8QycHzWWRfobzd8PvcXHhFeLFo7DUkptQ7AjZv76geGLT2pnXETHj/vtwe+n/AQahkSZDfgbVK6uneJ3r4LshCqGGQ6IraEQzXoRTHuDsUMFh+Uvm3aLKZ6DvmUYZ4OyrvxBRUxVnMkpcjXbF8Nol+qnxAHGc71zcJ93F9WOFbkQq55jrbRsgNEcg04Qnx1q+ErrKdCdoH3Q6FbkK7LtyQowMRqs8QEIE1U++q1ydpB9p/stqKMYTKTAoGbR4aKOWf7qieoIeCNdGSKUmso96gHuMBGBq4paVX1aPPBQURNYZeRx8AXRzZELfLhEcY0TMwAJXBtUTWh5Qj+4nUQQgbra8AxpZvvEihN8fX5u4Zi3Xsuy+9N9HI1DV712sEumi6jH6zIT8RE6SVwJRX3ySCqyVIclcY6ehRNlAQIaIAtDz0x73UST4XVujneuFlie3yzN0mw83mW+ZUjKF0nTR3VyYItNdc977Z+sApHTsTYSTdHvhjlG9cyAoNkLn+9BIaYCNcvAKe8LUleHDsklCB92Ffq2zEcd1bwbcSxOfDdLiBI0x2sFQbQ==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V1:

- Dropped including mm_type.h

 mm/pgtable-generic.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..224c444cf45d 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -26,14 +26,20 @@
 
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
@@ -41,7 +47,10 @@ void p4d_clear_bad(p4d_t *p4d)
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
@@ -53,7 +62,10 @@ void pud_clear_bad(pud_t *pud)
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


