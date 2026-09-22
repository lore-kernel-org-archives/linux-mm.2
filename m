Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3E6C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E776B00A4; Tue, 22 Sep 2026 13:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465D26B00A5; Tue, 22 Sep 2026 13:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308746B00A6; Tue, 22 Sep 2026 13:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEF296B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81623120583
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:00 +0000 (UTC)
X-FDA: 85242093720.22.1D9516D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D40CB160012
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:32:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Rr/9WR4u";
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbY1k2+sdM/x8N0JZzx9NYdW9GEqUwxxbqwApeCQ1KM=;
	b=0jeNu1bmWtnQQ5EsKVNTHxYPFeVvwI0zWtYdUs7tE1hZq0kbsZtiO8fOSJpsebUANM6u0X
	zwaIYCghaxJuGq7N8XuYT2c1H+O40pPAtXwCb7MEysD1aeuduT+0sJ2b5yW10CtpJcSCvP
	uU/sM9Z0qw7lDukY3YEpxLpU3HJsErQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Rr/9WR4u";
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098378;
	b=f47P9IMjaPuT13xVdutRz+Rt67U9vv/alLOtj7Zn5NhIknjW69HD5Ulv4RK4PS1AyYpS2g
	ymrdRs58Obnx9pcyWnIAkMRnPBEGwbV3t0R9bA5r9I3RHL9Hea6EExfJy19eFrQ0o/vp2L
	1injPB98FRdGEmO0YabQworfF2bGm3Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CC811576;
	Tue, 22 Sep 2026 10:32:54 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 633063F86C;
	Tue, 22 Sep 2026 10:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098377; bh=xTJL2byDqGx0AB4Z6L+IiKln34gIro0/pV4Ued2u1UM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Rr/9WR4uGteoys9nZHG7+FeU3UTiy8Locu6YSlv8Os75MOwYw1jqPExvnMg9LRzUJ
	 2y6T0AwNdB9W5yWJSKEUKDK4zrqxaAO4cewAugA1YMhbN8da8UqEMmzaUGtYMbZYGI
	 8EZouveWU4RVVr0bxL6+D614EYrFlIzanIIkQzLg=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:31:57 +0100
Subject: [PATCH v2 2/6] arm64: use hw_pte_val for HW PTE atomics
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-2-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D40CB160012
X-Stat-Signature: iyf974n1e85cwxup1x5b1cjem99w1e5x
X-HE-Tag: 1790098378-63231
X-HE-Meta: U2FsdGVkX1+KV4wACUCJb9XTQE1gQk90A78zGww8VYmaJLJ5x44qwZ1HJCRHcxtzCxPEnMnZZyfMv/hG0tRcQdVnfYLCdADD51oiaKIl7kWUFco9Z30yZxWFdG+cTJRPKj3YegEGhew4HczLikpewuBIzEoVpZXgqcFlBAXmonStsufOmt86nCxUI7AH++XMnBuUhlo5Sqlj9FZS1Ttt+jQ4yVz0Wt4CVpVW7HH6alybaHi4h00a8gChWYmaKDhIxBgMfePYb9wUQGpjXhxjtVyejxfbxrmoeJtkU1Y7i2MmgWh0AZ2zgoW/ACGvJYELhYm2M4DoYAUF1Ohz3qQk+gJ4T7Rg/yDcSV9hqMsml5Q7rRV7l9BXpB+EctSnWFM+1BF4Z6Z/gNdGI0yLRBsK3DgUpga3UavIFPdanjGfbP5Zzt8BtXrzd4Ugc2mp6GpQBpb+asvAJegn5PFeK6kCNaYieHGg/ycqHr0s85Re9/zVJq2hUK+szZ9/ZmPtIOWalbwPvOJ5238Tr7RuDY1X6HOQQb7XCiJAzkQPI5jcwqsAM5f6JmB7I9O5mnJ79gjR2cYDV/mfo2a3tYao49v1pX/tslRUZ4sl5WjvNIoqcE3N1n45M/684PKaO1gmhVfZSFpDN3wAHDfhliQRun+nUJTaEcpdlvyT7gZFZ5X1vDrh4xL9s6ZSx4phu6Tj5+FSRrXD7bS566MHlIUGOy22Bf9/p4Z+j4sWlq69y6mVS6bU4/VpHnZnBa1Cq6+j6GM3gbJPx8rJJZRnVkTyEQQLslYy48zD+YYwU26VSpIE1r9zwSIHSj76CmTfytCA9YCqemnsFy5qLihGEY4yVDt0qAgUdKgTmyP4OIHlxqMIrZYTMnJ/7l1k4mwpXLQldYgDSSA959zv1FiRGUEZhVNw85uUaQ8lOGkfF1z3JYAk8TB6J6aN0klTwuk6tTlVWf6/y9BPpnUL/yn22iIkcis
 +Mx+Runi
 2km2Ty2WC2W6r4S9a2NLQQbWGKBYH/CSTniT13Cny90hdhyR6aQqN2zn5wekj7utIzIVDsaW3wgWdneTU7IA29ipSiUMtNmVNFCc5UtpP9963ngj1EcZbSGHO64fbzR3/MafkXxQOQrge1RQo/R0wg4ENLF2rvSIkcl+sCZolRD8DDFbYx3bTlmUhtchqtpSjOqpVpVo8pa6Iq7B26CsMNr/sjy3XHcSqZdZhdtMWuKkro1skBNf3RLIu67vhHq367johxG2TgCtjGNf6RstbwOvXiPd56y7tMBu3Ict4mJP90hO+iejgDa4YFnZnF5GnWcSFFAYU7japc9lJ0UC9jNKo9yR0GjxH2gbzS5f6knQdGqER7lr1mqKuXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The low-level atomic PTE update paths take the address of
pte_val(*ptep). That assumes HW PTE storage can be passed directly to
the SW PTE value accessor and no longer type-checks when hw_pte_t is
distinct.

Use hw_pte_val() for the lvalues passed to compare-exchange and exchange
operations. The atomic operations and their ordering are unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Chagnes in v2:
- Remove comment change
- Move hw_pte_val() to generic series
---
 arch/arm64/include/asm/pgtable.h | 10 +++++-----
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 652ce413be389..4768ec59de555 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1303,7 +1303,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
@@ -1346,7 +1346,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       hw_pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(xchg_relaxed(&hw_pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1422,7 +1422,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1460,7 +1460,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1830,7 +1830,7 @@ static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+	if (!try_cmpxchg(&hw_pte_val(*ptep), &old, pte_val(new_pte)))
 		return false;
 
 	/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index b77f4be88e3ea..3322f4e7174dc 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*

-- 
2.47.3


