Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E840AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298F96B0135; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A576B0137; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139F46B0138; Wed, 29 Jul 2026 10:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC6656B0135
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92FF74068E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:40 +0000 (UTC)
X-FDA: 85041735240.30.D0FBB0B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id F372BC000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:25:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kJ1yqX7V;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvMqV51cBHSguh2r74rgEuq+XYeSa3cXfMffQ4C1g60=;
	b=Kpcdz9mzZj84RQRTtvteRKjqvy6tYJwphOIhHyw5A8giBw3uVA+SJM3issZWHZU9sGfIht
	9sx/h3O8PR+2HjRXVC3gS7ynSvQFpiUIUZP4gP3crgOl5yTzguQNeLKtUVnkLwYJiGBESB
	q0kuoLI/AD7cHEkVVXYBNMZKOB1hFQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327939;
	b=DeUGDi7QeQDs9qV/5CL7YAyQtEDb5KenAxj3LEd5yOwyMN/kWTMLmX90Xv4pOaB2o3+VI1
	T6VctVVENiEQvUrnqfooXUPBqy1d6DvHMo6ZgjkFCufmu+3tMSD3kg84qDxjIfKAY5CoMm
	nJAY1RVvniDdCh08H7aYdIsrPb1qUbI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kJ1yqX7V;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DC6C168F;
	Wed, 29 Jul 2026 05:25:34 -0700 (PDT)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 95A1C3F66F;
	Wed, 29 Jul 2026 05:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785327938; bh=hgq5q6IdHAI1vFAWZ1TN3HzUB0raxqZRsSM7ujOjO3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ1yqX7VastS3h2ZZnSmsdTqyk49SgzRf0JFdXsKNIxEvAogdwxu0n/YzJamBUrBb
	 Rri0fhBJMSfQ5Eo2do2/O+3BPAfykcnXOxlqzkjfTnudXdvdVni0Z09tMEBzJk4Ymv
	 G7qmJCt3m9EzcAzF/ZtVRiEYU2zPYZ/jEUme79OI=
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
Subject: [PATCH 07/17] arm64/mm: Route all pgtable writes via ptval_set()
Date: Wed, 29 Jul 2026 17:54:42 +0530
Message-ID: <20260729122452.3797443-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729122452.3797443-1-anshuman.khandual@arm.com>
References: <20260729122452.3797443-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ikxaa8z3xyfy4tekm316wdha97fz8gm9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F372BC000C
X-HE-Tag: 1785327938-745577
X-HE-Meta: U2FsdGVkX19cR3i0N3W5IllRvOpcXbj3OCxKx3QR3nX5XTyQgejOfn56XWM1R6jo8ANRQxzTxm5LQwbnfTAREp8KgGMF1nZuq3TPuHAboUYcrRfQIaIhjXxGgYa1O3WdVJoM+uURTjfHJMJau7Y3Kit/svlEo9TEV7hEz8UFOn88wO5sbTIvRPid4q7XXUBcef4daTRiAmm+sGqo3nkNXDg8xuDdNYygY7zqelg+gcoM+5YtUhEghsGoZZYqIkOcvfSO/o33yuD9Gu07SU997JSyV2eWklda0ld77iBa585jgUvX6VvBu6ggrPNtwjTvzE8MLNadaQbMgPuvUrnTsfdyAuVADn4Q+xh0lgscU5uiHVs4QfwxzpCuCS2KLW87AcAAusBEFhMaI95lOwTp0BMMxv+F+KYLHy3mCAXm1Yi0gNHNZSCs+VYMhsmyCUB17h30NDId8L/J0csmowxIKzNI+pEXoAhIwnDIhjas+Kbw9wmUzNDFpbIjxeE0lR0kuXIErBFWYnD34AWFZU0lNEbHyhNv94sAjFz7cJDt0Oe4NDyNdy4CC+MHOV+BMBNDAmnUYEVBzmDX5cbOzIdawAhv5mh5yJmFVyGx0H9/WAja8QWEIzOiqNtA0TjYTowxbCOJ7IV5xBaSkUO34a7T9wWSAZoP6W0I/tFFMNiCEizgfKtAFKOlrBcnBAS6SL8J0QMjfLM3FLRYqwDJv3I1V4Uh9slp4soj/+W4SMYlT4aUEq4tWqCmfunT/a2vTjJz316CL0eU7KJAygEhfIkgBS6q+gpoRa6meJXP1zxqbauFXt2JjQ1JT0xKZ9GsZvUfPNsuiwRqRjc81a7hDgOvQetvvVnUQOD5UaMCjTlOAU3ROtWKAWrSbxOXOQ3Cht9lQi1+St9nvWSU5CxVwC7ZLkGAgqYpM0x5NQuxU6YS8oKHlnYj6wrNhVlK1DBe9fME/XQTEEmh5rvYHfQsK+8
 MAtZ9eha
 yCapa/7mI4LUJRoXjyYYimKYKfhaP3xph+yx99E67EG7qtf2J7rq0OANvCCC6QzhiHHHaNZrB9khX1Ub8SMue0D6QjmQzI4mRyBGhRsDTBM48nz7+qEahPeyVW7fdANcqRkFq6IFa2rSDeA0gCva1ZlZIb6tgmn41Y8GhIQeScZPJznHgYmcx3jwAyOAYExn/XTc3FUjxIlgo+U0DRKnb0hE8rqVBXvFg22vFejxd2zg9xsKgnCDAtMerTiej7CzszyU1u2Cp69qvvs4enl/uGTXqSAAPMfUK9f/Rsuf3BalX5VlFa2qx+XLM10m2MAv77w64tfBpV4+Wr6haa5TLj1FWa1sLKo0tRjU8+LWsGnaeZAX6zzJfYmiTzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently ptval_set() is defined as WRITE_ONCE() but this will change for
D128 pgtable builds, for which WRITE_ONCE() is not sufficient for single
copy atomicity.

In future this infrastructure can be used for D128 to maintain single copy
atomicity semantics with inline asm blocks.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 11 ++++++-----
 arch/arm64/mm/mmu.c              |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 030ec3582a0d..1106977e0ef0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -85,6 +85,7 @@ static inline void arch_leave_lazy_mmu_mode(void)
 }
 
 #define ptval_get(x)		READ_ONCE(x)
+#define ptval_set(x, val)	WRITE_ONCE(x, val)
 
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
@@ -385,7 +386,7 @@ static inline pte_t pte_clear_uffd_wp(pte_t pte)
 
 static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	ptval_set(*ptep, pte);
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -856,7 +857,7 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	}
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-	WRITE_ONCE(*pmdp, pmd);
+	ptval_set(*pmdp, pmd);
 
 	if (pmd_valid(pmd))
 		queue_pte_barriers();
@@ -921,7 +922,7 @@ static inline void set_pud(pud_t *pudp, pud_t pud)
 		return;
 	}
 
-	WRITE_ONCE(*pudp, pud);
+	ptval_set(*pudp, pud);
 
 	if (pud_valid(pud))
 		queue_pte_barriers();
@@ -1003,7 +1004,7 @@ static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 		return;
 	}
 
-	WRITE_ONCE(*p4dp, p4d);
+	ptval_set(*p4dp, p4d);
 	queue_pte_barriers();
 }
 
@@ -1131,7 +1132,7 @@ static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 		return;
 	}
 
-	WRITE_ONCE(*pgdp, pgd);
+	ptval_set(*pgdp, pgd);
 	queue_pte_barriers();
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d5b6eb544216..1127917c554b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -76,7 +76,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 	 * writable in the kernel mapping.
 	 */
 	if (rodata_is_rw) {
-		WRITE_ONCE(*pgdp, pgd);
+		ptval_set(*pgdp, pgd);
 		dsb(ishst);
 		isb();
 		return;
@@ -84,7 +84,7 @@ void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
 
 	spin_lock(&swapper_pgdir_lock);
 	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
-	WRITE_ONCE(*fixmap_pgdp, pgd);
+	ptval_set(*fixmap_pgdp, pgd);
 	/*
 	 * We need dsb(ishst) here to ensure the page-table-walker sees
 	 * our new entry before set_p?d() returns. The fixmap's
-- 
2.43.0


