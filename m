Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D6B1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D246B00AF; Fri, 20 Mar 2026 14:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7DC6B00BE; Fri, 20 Mar 2026 14:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C49C6B00AF; Fri, 20 Mar 2026 14:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88C516B00AF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503A813A81B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:41 +0000 (UTC)
X-FDA: 84567264642.10.9EF824A
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id A468E140007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MW7Uhh2m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3qZC9aQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3qZC9aQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VrqRFYhB7q55kvKhGXyA9CpUY7G4mfRc8hK/Uh4Zfu0=;
	b=in5PAjqI8/ypZ58sit/j84TvHF3m1JNgJ7X8LMoD0pkGg1lsBt8H8CO50uVBLWs/glWmBB
	p6F3lbXSjJn8LRILgJuckQj8L21O2zT5MDnx76ReRaOMl/TjksxK7Mks1lbY1Ma45XgbeP
	23CZssBQ1nSpSvGxyIBl4WXuI/YGTu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031019; a=rsa-sha256;
	cv=none;
	b=hL6hXCI91ARNQ0yZKOQMWyR8KqpL12KAmC3f+ZE4CxmpabCheUoJtIOHGSL7qOKJOoG8u0
	SAgrlzk1yC4DvZ2cQkgNcHeX+2812u9ZJHMzaM0dBBcT6wO3WT/rpSy15pTAxP8ziZy4c9
	ExQPeX42X6Ht0+ffVKB74sDQfgxBkIk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MW7Uhh2m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3qZC9aQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3qZC9aQgKCBY5wy68w9x2AA270.yA8749GJ-886Hwy6.AD2@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439c54e0f6aso1593254f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031018; x=1774635818; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VrqRFYhB7q55kvKhGXyA9CpUY7G4mfRc8hK/Uh4Zfu0=;
        b=MW7Uhh2m7dsriN9MZ/O23aeEu2iGrJAMRQlHsui3I5J1v23SybmxAnCdlMxnXnmnWc
         3/qs5A7elFquWm0wKGK/DJS2d2Gey11/FHAbxQOpYx5BfX02hXebAeK2lRxityfBjepU
         YsrA/vXAtFA3owtN+vQh5ymzAlRj/PZqShWZqVDZvCGWHHLJ4JHYRlR1F6jSUS9h+wBW
         MViFz9jq4FBtPTCzNA6dS2h5U/bkfWfG/MdhGKv5LuX1p09oyV1xsT66q5thHA+61et7
         ozoWDH5oeysINGipWBC0BTcE3/AxS9qpkf6ORypExGZ4vlaB9INO/a/BGgHeeYoBplO9
         4uGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031018; x=1774635818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VrqRFYhB7q55kvKhGXyA9CpUY7G4mfRc8hK/Uh4Zfu0=;
        b=DJNbTsphJPpFv7EhPWUQpQFCELVwY/J3qDRxY27CjkZxQos09Mf8aNXOLbV+3ptHr5
         LNHNsw0jUbNGIIQv8DMiaswa7JWSuFepi4DLaZJud43U1uPnCX/PFxg4mlGmaIdRE6k/
         MdH0BlTQrC7Zqq/J4+8JwASflyCmZ+7Nj3yTVhPtU6TNU3sMvBgVib4p5e5p5GuX3cBG
         +ebLtItKQ6e8tuc6JnoQeJEboQpOQg1nmeaaoH0dU2aMfcWKcb+M1pP8rS72nKAmGsfA
         MaacoXay8+VHa1RlqLwnisfJClaPVZc3Yj0WSG5BKPYW9UmnbUZ8qcrNAq1Uzo+/54b+
         RWeQ==
X-Gm-Message-State: AOJu0Yz6ii9bDO8N3T+N64yWDPx7/5B5zcvRhzwocuC0ysqireOkBaFh
	YTwYZO7WW8ubJUlRoEyT60yfbMpCh+hAokTJniyr4tKARuylTOSRz9fShk6+aTOQ6ynVSYZq6nL
	yem55IDimYsGsmw==
X-Received: from wrbee10.prod.google.com ([2002:a05:6000:210a:b0:43b:3cda:aa8d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4021:b0:43b:566e:fad2 with SMTP id ffacd0b85a97d-43b64242eb2mr8417634f8f.9.1774031017657;
 Fri, 20 Mar 2026 11:23:37 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:25 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com>
Subject: [PATCH v2 01/22] x86/mm: split out preallocate_sub_pgd()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A468E140007
X-Stat-Signature: 856uwc66mu1cck5dzbm7p4jb1p4cc487
X-Rspam-User: 
X-HE-Tag: 1774031019-295515
X-HE-Meta: U2FsdGVkX194uJOpUlTBXup4/W/WcSMzarnlPiI7DljoCakMcYJVmDsdbgXYDpufEsbUx7GpyY/R6TZam7Nxk4PE+0n0EoPNMuqyVc8B87D8xr/RahrvOINLKWL/RH1k7/bR8jg3liLXVGybC0ZvFf10H+D6uZidKcfAk2R1GDp6lrAaW2CnPRPKNYvk10hOPZiIeF/isMJrLALatZA9IRcxWvInRREvjwsBe3APARLFJRWbp371HxcBlQisotwLVKIm5NEjxuKuSIq/FszLhC1uDkynB3LOgEtn5+je6Q7P/eodnhaIhlFkDKmT9DXU4mW80mhZ73UARJB12jHyrWPryAX6vVkIJoNPvA8V4kVEcjTTwgjFsXRSv+pLDTey79Q8QYmtCG1vpvcoAn4osKMapgB35z2BhpTzuUcbMmHeV1A0ZKS6rr16yGkb+sd7jgKxjflq4soBeP/G6Hk92M4GXE1ufY7RuNtngK85wxtkXkfCNzjvSXzxkH/8/As1gLMJTEJNYYI/bce5EWk6cIZebIKe3DI/x2wwGryYjSC2/6vzgyKgQpF7EnA+QgcSt/L51XU9QCe0biE1TQF60IGh9qH4MHBR0whHFYskaVMTAq4aHKMd9S+fU9RxMWis15p7KoEnpR/G9yjy9AoMiECRVgUJkDLkaShQNDhfX7JYjUyQMPx+UpGGvbGxqT6E+Tu1G7dZNPoicSj2y6kopSAdE0Cw8gHVGOkOnOrv3EatR6zDwHnfYn0MxdsLsuHg31vVDFCc+z6NiTv2aZWVaY92j8Wp1NnHhxdQcedgj3E7Ad4B4kJ1W0L/wseAwOB0cwYcXvP02Dqo5YWPsuNUptrGlJOw8xMttYX/3oowUA6Q5JgbyhPFhyOkxwLcnZRJTISkI1JjPbVwMYRHSYCWP2ecM1tiqS06V6d7IarWcyMarFqZr0MXpd2IUvFZ4dptPFlu/PabiilR1h5586u
 G4N0FQfL
 +hhjOZmGwnRULXEtcj2lSTsINGtiFN9oi6UyYb81DNeCvj4PQwOvRPwE7KVDKg5vO4eIgzP7h+jwCg20Debu0bQw6j7YKi70Kgf6j6pVjtxAH2jC9l98c19kSbEaaK6ByXeUqIIm/OBQZ0Ol2Qj0bBIOOF+rrezXxD8cKHLYhzGGzlvLJEGcy5dzrSiftYzi9ZBoPKT55hWcDI1LEVZY/7ViLbiN2Al6BF9onCWG7s/GK1lheFxa6QSCxtw+eTqQ0zuUZ6Ph3EC9JkLoWihOeddyHkpkuXI6FLZdhfbeKLA7uLpLb/robMTgharBVtZTtHahS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code will be needed elsewhere in a following patch. Split out the
trivial code move for easy review.

This changes the logging slightly: instead of panic() directly reporting
the level of the failure, there is now a generic panic message which
will be preceded by a separate warn that reports the level of the
failure. This is a simple way to have this helper suit the needs of its
new user as well as the existing one.

Other than logging, no functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/include/asm/pgalloc.h | 33 +++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c          | 44 +++++++-----------------------------------
 2 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index c88691b15f3c6..3541b86c9c6b0 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_PGALLOC_H
 #define _ASM_X86_PGALLOC_H
 
+#include <linux/printk.h>
 #include <linux/threads.h>
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
@@ -128,6 +129,38 @@ static inline void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud,
 	___pud_free_tlb(tlb, pud);
 }
 
+/* Allocate a pagetable pointed to by the top hardware level. */
+static inline int preallocate_sub_pgd(struct mm_struct *mm, unsigned long addr)
+{
+	const char *lvl;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	lvl = "p4d";
+	p4d = p4d_alloc(mm, pgd_offset_pgd(mm->pgd, addr), addr);
+	if (!p4d)
+		goto failed;
+
+	if (pgtable_l5_enabled())
+		return 0;
+
+	/*
+	 * On 4-level systems, the P4D layer is folded away and
+	 * the above code does no preallocation.  Below, go down
+	 * to the pud _software_ level to ensure the second
+	 * hardware level is allocated on 4-level systems too.
+	 */
+	lvl = "pud";
+	pud = pud_alloc(mm, p4d, addr);
+	if (!pud)
+		goto failed;
+	return 0;
+
+failed:
+	pr_warn_ratelimited("Failed to preallocate %s\n", lvl);
+	return -ENOMEM;
+}
+
 #if CONFIG_PGTABLE_LEVELS > 4
 static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, p4d_t *p4d)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f985..79806386dc42f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1318,46 +1318,16 @@ static void __init register_page_bootmem_info(void)
 static void __init preallocate_vmalloc_pages(void)
 {
 	unsigned long addr;
-	const char *lvl;
 
 	for (addr = VMALLOC_START; addr <= VMEMORY_END; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
-		pgd_t *pgd = pgd_offset_k(addr);
-		p4d_t *p4d;
-		pud_t *pud;
-
-		lvl = "p4d";
-		p4d = p4d_alloc(&init_mm, pgd, addr);
-		if (!p4d)
-			goto failed;
-
-		if (pgtable_l5_enabled())
-			continue;
-
-		/*
-		 * The goal here is to allocate all possibly required
-		 * hardware page tables pointed to by the top hardware
-		 * level.
-		 *
-		 * On 4-level systems, the P4D layer is folded away and
-		 * the above code does no preallocation.  Below, go down
-		 * to the pud _software_ level to ensure the second
-		 * hardware level is allocated on 4-level systems too.
-		 */
-		lvl = "pud";
-		pud = pud_alloc(&init_mm, p4d, addr);
-		if (!pud)
-			goto failed;
+		if (preallocate_sub_pgd(&init_mm, addr)) {
+			/*
+			 * The pages have to be there now or they will be
+			 * missing in process page-tables later.
+			 */
+			panic("Failed to pre-allocate pagetables for vmalloc area\n");
+		}
 	}
-
-	return;
-
-failed:
-
-	/*
-	 * The pages have to be there now or they will be missing in
-	 * process page-tables later.
-	 */
-	panic("Failed to pre-allocate %s pages for vmalloc area\n", lvl);
 }
 
 void __init arch_mm_preinit(void)

-- 
2.51.2


