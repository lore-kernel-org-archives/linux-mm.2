Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BDFC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC476B0098; Mon, 14 Sep 2026 09:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4FC6B0099; Mon, 14 Sep 2026 09:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB5F6B009B; Mon, 14 Sep 2026 09:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2203E6B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:52:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0487A00AE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:18 +0000 (UTC)
X-FDA: 85212507156.19.F60DA86
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id DCC041A0003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:52:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gzbKM8Ca;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gzbKM8Ca;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393937;
	b=GOAWMmXyTJzQ+xHeOUDkZiG4Qep5KyOcT//HXViZeyJlLY6gIMUWo4Q3j/gVrlE8/5j9Ik
	k/3e7VJ3F68jZDIsRAP6CQhh6exP8Hav54ADVsLvlEy4X9oEjeSYhNxDdVVQLDLn5NJwLs
	mYcp2Dba/+QJvbbudQCDzI6cFD10jtQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvR7yrUSwk1xcghd++XGcB+fD9fDR6mY3VUkLEOBRnU=;
	b=PxNfGXqWp4VCOFfmbk0+3JY+6s8U5+vh7TwaiR0SLw00R2gijPtS2Bb7ALMj9lmkMJVr4y
	9QioXLLK+NY+gYAnhoaDXnpZ9t3WVqpS7xqHJjxLQIcuhpHXp2rdLLhFW0Eq4ECZhSmIbS
	pG2arnIpgr1qaedFuNXcI7e4hILg/XI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 544C41576;
	Mon, 14 Sep 2026 06:52:12 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B236F3F882;
	Mon, 14 Sep 2026 06:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393935; bh=yv6552mFvvf13JAoUBxhYSH5LMmG+s9tUQsoS51fbNQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gzbKM8Ca28zZ5K6P5ERV+/fCGpEVK/cv9jlKFw2gr9//PfYHgZprGWfo191uCCc6z
	 Cf7m0v8/apWMpqmmgMHBA6J9VkXnoRe1GIpcuZ12FSGnPYjHDPuGZmC5Cob7BBesv6
	 pyrAeo+x1fR1GNNgGI02k3iSQRVZhxr9ZAy5zTgQ=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:33 +0100
Subject: [PATCH 3/6] arm64: convert between HW PTEs and SW PTE values
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
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
X-Rspamd-Queue-Id: DCC041A0003
X-Stat-Signature: zi9qm39zoyh5k98m33jzubt6fu9woj9t
X-Rspamd-Server: rspam01
X-HE-Tag: 1789393936-688493
X-HE-Meta: U2FsdGVkX1+ng8DqohKqlVfmASAxo/C1CyBsIdED+kr1AzqBllV2Fjq4zueYaiWvjF3zodlyUx7AVUCZ9uzHtRI7tAu24xgpuKOXG2dRaF07LnEX0e3TSttJT4dKg5t3iBW+HRat/LedzPIy9D7pTAfus8WE3zvl0oxFJLZRdgssMQ++w0TBq7XCfWyvjg2GgFXj+20OUOpmiVadb4pBnGESFyl1PiN6hPbH4tnYYKhsMZOuoE4We/F6GniF8l4R3wBqzXJTWp4OcyYs5SPcYGlADm39ItF6/jxKiA0jm3UzKZ7FD271TGzvTlTaxDf+pleX9NxZnWO9zaea1X6A20Gb20WGvmBqfbcuqEMJr9CFnY/cFzRE702EzESCs9JQ3r+1wmd+6IjQyh5wYE29VbwWqQAnaHuj/Q0NNb5owQ1jxMP8eNwGAG2T1Y/hCGqm6M4Fd1DlK6G8hZjUkmcecLkIEgLIC4DcWghbl0EVijIjXI+5nyHMl+A2wzyIpmnoklyxTr+B7LpzjIRAXJ7d+FER151COy86IZRW4OY6CrchJQiMarIgCjq7/rxRkN1U1V0XmY0rymYkyRBzYo4HOSN4ZaYJL4Pqyorf918YKsNgXy+R5XEnQS1+IYwwTsygLpPhFBkfxpPHBh2gSFKxF8N6kPiztzRU/uWNM2AOfrnmpn2Cx5aJyWivI0+yejEn/fYf5SEMSufXhBwExfDgBqDBHPyUSyvAEMEtK7yRvtP1kPET3qzErkbPZgE5QdlONmS/F4CnfjhyrxQakZSqQY1D0qxtXFkPj1QRRzG20riUewqlHmo+0r6FsEPatN2MAuhKprfhGOaGxpROzP0Umn3+XEGwUlP9B9KMezFfBQKm5OiH+sYpUwUGADNzt8L4dIj55f34/8lYF51Yic4yNntUj7+aMtfoBeIlsAo2BMCBlzh2/k3H7aULA741sd6wE+PVWuOgj9vY13Fxfbk
 RoYdljRw
 eg2ycvWBv23tgMZUQy/9SbsLBrWMo2EdsCop7HsMkytFAneAY6jtXSIrf5NhFey8RqO8khA5Q0a1ZHzx7kVGyx0prV/izuMk5dVO8kGiImAvrS2qNnr8Fp9rDGTKmRSYt3dJzKD+pGUf6cTGmjTQFuFlDQOL5D/E7cz9pcCq/Q1j2UJpIlY59dKApQ6hyUyMV/ycMyP4WJ6+Qd+3WnzD0JcwoVXzzxJjTfbBepPC6+G8PlOXLAbkNFl6TmkCLo3GgD+iwLOQltDy8DwLQ6Kq1yVHBFptw2kYte0tdxHximOw1DpHwcuWFd/R/10JAgc8fMyL4rEJ+ghjw4K8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__ptep_get() returns a SW PTE value, and __set_pte_nosync() accepts one.
When HW PTEs use a distinct hw_pte_t, directly reading or writing *ptep
as a SW PTE value no longer satisfies those interfaces.

Use __pte_from_hw after READ_ONCE() to obtain a SW PTE value and add
__hw_pte before WRITE_ONCE() to form an HW PTE.

Define __hw_pte for both the wrapper and alias configurations so the
same accessor code works in either case.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 include/linux/pgtable_types.h    | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4768ec59de555..67c4a6179e154 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	WRITE_ONCE(*ptep, __hw_pte(pte));
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte_from_hw(READ_ONCE(*ptep));
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index ee4eace5c3e1c..b5862a16aa497 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -9,11 +9,13 @@
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
 #define __pte_from_hw(pte)	((pte).__pte)
+#define __hw_pte(pte)  ((hw_pte_t) { (pte) })
 
 #define hw_pte_val(x)  pte_val((x).__pte)
 #else
 #define hw_pte_t pte_t
 #define __pte_from_hw(pte)	(pte)
+#define __hw_pte(pte)  (pte)
 
 #define hw_pte_val(x)  pte_val(x)
 #endif

-- 
2.47.3


