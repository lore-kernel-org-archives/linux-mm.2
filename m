Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FC1CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB166B00A9; Tue, 19 May 2026 11:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1B16B00A8; Tue, 19 May 2026 11:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7AD6B00A9; Tue, 19 May 2026 11:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC3626B00A7
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 984851405CF
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:38 +0000 (UTC)
X-FDA: 84784526316.19.BE1D566
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9104E140018
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cgEkmrYd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Sn8MaggKCNExE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Sn8MaggKCNExE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfDfE++F3RWl/ExerU/oKoiEmKgLmIzVBxPm6lUCPRg=;
	b=SiUIx9CKg40RHhqx7PC9r5mYk+NYI7Nsj8z7mlR7W3DC4Xja7GAPlBwmGOgJnhet4e77K9
	4duoKijof0g3dvvdI04YMNQkgB6rD3g35Nq4hEHX522XijfOjvSWvO3Lq+rIJW8aNV7rkc
	4gQZubm1aQljMqmjJTkLpS+zkEOj4mk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203916; a=rsa-sha256;
	cv=none;
	b=i0c4tHkJBH5620IihtMgvr5KPnFvZxMrUO9DsfhyanFXQ6cjaFGshA62cYaXBudCFc/G3d
	3xl29jIdLEETSVRavUZXgwoPBlaUFn8GWYb/1Dbe0AD5CDwz2z512r5YYLiSj/1rW6jtGN
	DXaNNqQFT6OHG32FgahZgVABbTa/++k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cgEkmrYd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3Sn8MaggKCNExE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Sn8MaggKCNExE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fde68e420so34484935e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203915; x=1779808715; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfDfE++F3RWl/ExerU/oKoiEmKgLmIzVBxPm6lUCPRg=;
        b=cgEkmrYdGcgJp992NZ1oeF9Fm0BEv2RaGHPS+hVHFCWnweNnxpUNMIMlAXzFpaLx2Z
         NMvabVqgAjroh8V+ksKS9/e04d3ZZQ29j43EqlvlIXm5imI5BEbWU+2Vkqshp+XuIIyy
         /mHkITGfSgKrpIBO8OzHg3V29eOiH2ZXANUXi3QEOvXcfw2gc5tarCPu7+pDv9TL22Pd
         8P139jzgwCJiYsLWsBs5s8a4jRHQnMnuD3wpYL4JFpUsK8BMfG8DE+g7yyykfIyjX9jB
         EpyAVPdyTrgufx6qQ3Jh3hXpm18rdbl8HJsVfSRdCtFpLq8XP6OOdIuuMYXkzF2IDE+B
         vqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203915; x=1779808715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfDfE++F3RWl/ExerU/oKoiEmKgLmIzVBxPm6lUCPRg=;
        b=A/FlgWYiE+nPmwb3TElgS6D4tsTWdBFxgrPUSPFdz2qesX6BkMT3aP2sRonhJb9/41
         s7wPIFOFu94JkNstM4h8h2QKUmfhm41xu0ZzoSO1AVH+IoHcAw3cHaXqEFtvCGUCuYqe
         qcw6G3r17tF5Pg0G6vf9EDAZdkqy8AFEBSkX7vLXfCJvuD9md0MMt6G+FAWA/aPnGjiv
         5QSgdKxDON8duL8+Sjp9xtdDazL60fk8khJHniI24xUmtTsFaMW6xcFloZNMgV5lA3W+
         k5LRo4mqLl7JWe1D6Mvv9Uky4R/pGEIL7o+T4qqu42zEyLa2V0l1VI/g1jiaUIDtnfHB
         lu2g==
X-Forwarded-Encrypted: i=1; AFNElJ9EV9MeBEB48eH7YgeiyOoSntbSDuWmRgw3RG8/ExKvzn5lFRVbjM/5eFvMJ58kilWYovIyLMi/Bg==@kvack.org
X-Gm-Message-State: AOJu0Yx3h/m8BmwHl6r5jU2fopFFrechrpT0Im6TNLJFqKiVrOju/B0T
	HdBXvVHtln4NKZ4mmCs73ea2UoBU9OBMqdKotX306RyBSxy9iKDcEXI7xNqOgj5DBi2yEXhs+w=
	=
X-Received: from wmba2.prod.google.com ([2002:a05:600c:6dc2:b0:48a:5c24:d305])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:34d3:b0:48e:6db3:ff3a
 with SMTP id 5b1f17b1804b1-48fe63270fdmr290761875e9.16.1779203914736; Tue, 19
 May 2026 08:18:34 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:25 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3142; i=ardb@kernel.org;
 h=from:subject; bh=oIF//MguREFG3HyKwOy+szVys8PN/RKtASFWmsHeRws=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7qyjai6rA2NnuvzBPcb5HcUWrJeV8kP0p63Z/GDyg
 rrEP3UdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCIftBkZnt9bsqtX63WH7NG/
 r+plOE+Kat8O/Px/l8Tn0Pv1vFYc/xkZlu6eNVN6it3sFw7TGMSfrdvezmPDmlIWMfNT3b8Tb5/ UMwEA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-23-ardb+git@google.com>
Subject: [PATCH v5 08/13] arm64: kfence: Avoid NOMAP tricks when mapping the
 early pool
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9104E140018
X-Stat-Signature: c1hrdpsmhaxt6iw769ztbtm3kuhida1o
X-Rspam-User: 
X-HE-Tag: 1779203916-247701
X-HE-Meta: U2FsdGVkX1+O5zDv+DY8qwUixjoMky0QdwGiv2GuDo14h9rSCXvQemmQvlteVxyQ2hVeDsfS1JK/gUmQxcL8q8a4mLG183XMWpA14YoIOxy5lUpiDXN8JeA51+IRGoFTm/1Do6hBPclpKh/sbPMcnMDBVGYWJbHvKsSTplcREL+ZPV7HGA1F/9crKYsqjmd2pQ01IFkoWd4J++tmRNHl8kzwndc6t2e93nhNNmn0Q7OC2JafkTlIsNuz/BSvUJx2Fb7zwgHoiQ1mQAU4OQDPYo1oa6nkwFEPH/14ErrWprJLoNdXYmCzuH0WX7cmIXv/8afExKZ8OCga/H/dLAgRtWQSvp4ICuu4IFQmiFaODJgkOeas0OTMzvUO6vb0SW7Fud475WmvaPlcXgcHLGAQKBNhVOr9aeKBveiW71ou3aHGP2gWiH7VjWjuqIS36//4e+YHuXsD0/RkAy99LjeCNllCK8yh64ZRJRdazQ2QxMOIYkNCAZsgX91Rjs6S01gqZ5Dy2q4WuyaeEppNg5iOrqZZd7wRgnhoToh/1tp3KH6RfVn5bTvKz/7Qc3lCrKqlHwIjKfXcW7ycG1djSIlQFAeV/FQMHHWpbJrViS9LuH3xHx5DgDtRgfeWSjB9NihGsodsCqaIJAiAV1CeLfayT8zI+JD48FwtiOWq1LGaZzhvPNJ/UGn1Mt+RQcdeJFPwKyx60YFDw6sG2w91+28oYP8O+u72I/rOwx9GL2w2i9usEQoVtfkthUBgCX4ngaNwVJJNrnA39Sa0j48lm2AnsRV9tkOKWLtdQTSJ7Z7tfwRZwfzuvnpLQKxSzWqjvZtvanvRioyMaXxUAzha4lTiKjaoh+BCX9mfSuJnIsEHF0vVkWdFDZd97HygbXm6b6FUgTBNMtc1PkF4MDtsaN/HDk8jJ30nPbLJkYx/YkmNlkbcc4w7UbyGsrYw/ZcaN95D0Nr7WiAybaKnOCYeRRd
 r5U+weiF
 gYcultYh2k82sVLk6NyAFHqBQ8oqkGxzOhLubnSPWhv1QeMS/f5B/bSh4bg2y9qiW7OC8A3Hh6UmQSh13kdkbaQ3yLM3036hXeqe2/xZdZMboqehVImdThbKUNwmqHjyhUIt+Ci2H+rHle2+WnP7qKTPba6Cd+h5cz79saA6JIUAZHQ3USnIpz4X0xD09R8fWI8nAKWe8Jo01mAoAAUcOXpqYM0YFJ1VXXcY0aKY/6LMI0cFOHo3roKHV1mILESNKT4sw8bP6QGX8Zm9OHqE8JjWzFbBMY9s+MS/o/LK5JbHeENazKxWZMAX9SMW0Eqhc8UG8NsjoGrZk2Ic/HObohOR57tLb1ecgCnUJpwMnD/VU1LL1/CmAn9YviNQaVJd9c7tjaE6pugza69HxBhsk1vFADQ5NXNIP+9bjNf67HqFH/W/MqXTx1zDPaRYjdj5/76gaKRmO8X6eob7tUV4iTn6P5eSkRj0GNQlELvNGeUwCroD3GYxEYqTyO5Ynh1YFV8FPdp798da2ouo0jr4XPj3zO0IL+2nO7CA1pQT9OZ+4bkPS0n19QBSQTmBCJcR8U7j9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the map_mem() routines respect existing page mappings and
contiguous granule sized blocks with the contiguous bit cleared, there
is no longer a reason to play tricks with the memblock NOMAP attribute.

Instead, the kfence pool can be allocated and mapped with page
granularity first, and this granularity will be respected when the rest
of DRAM is mapped later, even if block and contiguous mappings are
allowed for the remainder of those mappings.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 25 ++++----------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7cecd25aa83b..224fec6ce9d7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1067,36 +1067,24 @@ static int __init parse_kfence_early_init(char *arg)
 }
 early_param("kfence.sample_interval", parse_kfence_early_init);
 
-static phys_addr_t __init arm64_kfence_alloc_pool(void)
+static void __init arm64_kfence_map_pool(void)
 {
 	phys_addr_t kfence_pool;
 
 	if (!kfence_early_init)
-		return 0;
+		return;
 
 	kfence_pool = memblock_phys_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
 	if (!kfence_pool) {
 		pr_err("failed to allocate kfence pool\n");
 		kfence_early_init = false;
-		return 0;
-	}
-
-	/* Temporarily mark as NOMAP. */
-	memblock_mark_nomap(kfence_pool, KFENCE_POOL_SIZE);
-
-	return kfence_pool;
-}
-
-static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
-{
-	if (!kfence_pool)
 		return;
+	}
 
 	/* KFENCE pool needs page-level mapping. */
 	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
 			pgprot_tagged(PAGE_KERNEL),
 			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
-	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
 	__kfence_pool = phys_to_virt(kfence_pool);
 }
 
@@ -1128,8 +1116,7 @@ bool arch_kfence_init_pool(void)
 }
 #else /* CONFIG_KFENCE */
 
-static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
-static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
+static inline void arm64_kfence_map_pool(void) { }
 
 #endif /* CONFIG_KFENCE */
 
@@ -1139,7 +1126,6 @@ static void __init map_mem(void)
 	phys_addr_t kernel_start = __pa_symbol(_text);
 	phys_addr_t kernel_end = __pa_symbol(__init_begin);
 	phys_addr_t start, end;
-	phys_addr_t early_kfence_pool;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
 
@@ -1156,7 +1142,7 @@ static void __init map_mem(void)
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end) &&
 		     pgd_index(_PAGE_OFFSET(VA_BITS_MIN)) != PTRS_PER_PGD - 1);
 
-	early_kfence_pool = arm64_kfence_alloc_pool();
+	arm64_kfence_map_pool();
 
 	linear_map_requires_bbml2 = !force_pte_mapping() && can_set_direct_map();
 
@@ -1195,7 +1181,6 @@ static void __init map_mem(void)
 	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
 		       NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.563.g4f69b47b94-goog


