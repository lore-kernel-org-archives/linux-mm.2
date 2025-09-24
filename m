Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AFB9CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720F48E0010; Wed, 24 Sep 2025 11:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681308E000F; Wed, 24 Sep 2025 11:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6598E0010; Wed, 24 Sep 2025 11:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0E48E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F23C6140883
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:13 +0000 (UTC)
X-FDA: 83924454306.18.03EF1A4
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 173304000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CmcboQP0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3egfUaAgKCCcMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3egfUaAgKCCcMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726012; a=rsa-sha256;
	cv=none;
	b=iufH9eWt8fi7qHnxCmAw1kZhbt5SzdOOil5XwTArBAKV3/hNhLQmkAl9yFPbXH5B3BiUSc
	Zdq9tE9fW7eNgYpaFmnZVJwlmhzj+92tsuZqiOWc8jLD6DYXwWMyXmSVEf+4c1Cm+z4gmL
	5fuc1F7Unix3nwKtIuh0JoEMOqM3wOg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CmcboQP0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3egfUaAgKCCcMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3egfUaAgKCCcMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sQ+0/NTgmoYJ7zvD18U+frXGZZeEnJJzFJ7cE/2yig=;
	b=B1MpWuSmdPzkSjHMLZ0ZVHds/ohNTVeQSUF7pIQ2Nbq5Ih9eQ9XlQp7UswVgmYos5CF5jn
	MZTC9kGlPFp+s6qGd4eb1j5h2Lvb3Ru5sZXHyy5Xjx/04/i4k0F0xMIVpu5gsrTyaW8Xjy
	HJdYrasEDnip3gnAEjpv0QhRnhqmexk=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee888281c3so3986270f8f.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726010; x=1759330810; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9sQ+0/NTgmoYJ7zvD18U+frXGZZeEnJJzFJ7cE/2yig=;
        b=CmcboQP0c/6u0a/mqzeBiPKHhGr6uz75pxoo7bvtUhg1J9h12rjfemeCpQI9T6U9bJ
         fkmXgsV2wMK9ODRJrbRXinm73KIM1hTqhSgu3OOfHUMl2xQPfeebD98Cjflre5zMyM4W
         G8amuQqnXBKyN4hb+fEmCnB9Y4BVFt51nsfba0fU2Hl8X7cKNDJVpwfvkAYt12jbqTL/
         muBMN0It9wxv/Y0QdwKixvrMueMr4hwlAeYDBKONVgO1mkngnfDd367r/ewFAZF0AcuC
         PLTcNpn4rdQ9SSewChx2akBLEAW1Bk4nZTW9o4znXgXghDSPZoWitGO8qCTwFK5Ex+iq
         813w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726010; x=1759330810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9sQ+0/NTgmoYJ7zvD18U+frXGZZeEnJJzFJ7cE/2yig=;
        b=f59c0tZ9HC/wgWgY26pJu6LAtITZNJmNZAVAT3AQUCLKLaBfmbn3EoRv0qhNE117++
         Dcr0nmltjvrvvkHO1eS4GUjEW9EioI/wxTWXjcC4+WoaqMzdnayFpe3Xt/lA0XWXYGk8
         LkPF+WM/HHhoVLFdnosef8oAGBoVAYM7CwnFwcVV97Jztdw73fn4XnvKijZ/EHkHiExd
         jqkmOEsMP02ExYL2BM6pPO+6ttKYQWO7U0rijoS/erm9YDcnjDoGrUFyC4sf42dccyWI
         9uwAlWRBXgI53aBJW0Duh4nJ4+vQNlRTx7uqBlB/xES6tUMVDrgNleDjDeRRbdw4/bgc
         hEcg==
X-Forwarded-Encrypted: i=1; AJvYcCXrpx7ys1ypPqCPcxxK5SdSsPZPBpaTafXiSJcppN+Aw5S9+Rxvw+3Dacz9UaDlizr6nGDDNxWLvg==@kvack.org
X-Gm-Message-State: AOJu0YwlA1683QHEDA3PadzFkvuVXTUpjIqUgy6caRoPkakKS69XxWtx
	QL3WU6/pqlAdXO9tH8QgdLoSDBDPrmMfJmXkJGmqLp/4xwHvm70r0/4rBBSaknH1JidzTaM1pGa
	KwQEOKpRYXRyMWg==
X-Google-Smtp-Source: AGHT+IFqsEQb7cIi2yGxxJ+MfZzjIIfAO9RpfOWtkftlHXz5t7D+GW6T5K74X995LeYOztbN6pZKuqk/SB6tcQ==
X-Received: from wrty13.prod.google.com ([2002:a5d:614d:0:b0:402:ec26:76f8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f85:0:b0:3e9:ad34:2b2e with SMTP id ffacd0b85a97d-40e4cb6e211mr232236f8f.46.1758726010290;
 Wed, 24 Sep 2025 08:00:10 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:38 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com>
Subject: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 173304000F
X-Stat-Signature: oxs3qkep6ea8afyg17aj7ksxeq8495jk
X-Rspam-User: 
X-HE-Tag: 1758726011-199387
X-HE-Meta: U2FsdGVkX1/dtrUcX8Ty2PRwqEuIRQbfMPcyaqAY7TtkLu5aOSFKatAnN604cEaVUhII10KJYQ251xIZVOI2z2CkvbeLmCeX//m9Kvy9opzY+iaL1ylqdSY53E2zdadnap+r56PfMJ2GsH+EbuagbObmdr5IA3+Htd6kVcGA2n5KLuQCriSeEeSP1O8V61Eqjv46hlrczSCVIciKNv/+aYITQBJrHOwqalfoswpfuaLpgyveRgTwsJny7s0b8ojAbabLttHdJp4aHxF0VrIZwoA6QiA/t2Bpp0P3Iyy+Kn0mBf1Cc4pF1ll8nVkyV8xLRdb640/ys7yocImIwxrCzKPKU3OEfXJBHu7bmTrMXUhBclDQowSwZbeOSOh/xSdorQUwxPUvJEqGnDfGXMedVaG32/Pl9nI7/+pHDFUHMhRBsKRPbk7a1NaKGsSksoH2KgvaMZv/TSFgnSIiEsMv1hbtXq6kgwYMdjWc9j3wX29sLRHW4M9TJhgwFH1RzCBqaPps1BXP4IrLqG2y3yWbr80zJtHFgHO6n/hLbg4KIvThRcvgzqsE860Z7TpkclZXDmtkBy+T4UozxOnNkb/JbWec6fJSkDU0b4S6KecSe3iPELpCMETqv/tLRW3fLu77C/xLfas2wUkCAVPh9EORmY017S8V7RqutWNO+6K/udPTM1SsablxjwZWTYurlG7WI1Ie1zhlB4B7SPBbPti1IWCUfqNQqYT1a32snuX+VgMKAQVNlTVbCr9KDdYvHl2M2UCJdxxBvrOOVNglyggRwavYJoC93wqusChhSzB/UQ+dk0h4X/51HppjrKAowZEooeOjfgkHXTdiSJtpX537EPbrkMd8nB1H7pJvqQmocPJLZUCZJXTM1v9w8f1Zc39RIjcSdW9K0fFXCU1FIZfTXh1wAFhCb1J9PtM6sa13S5oIkypFd+2sdLnnCK3AwMOj9sts8BhDeqbtp4b8i66
 6kMRhxGs
 wARTI8JiBSUEhvgmwh0mFNysFLycAZ7kvoXVagsFA3fr7/hMI0zyzP4t542mucmvBUiJS1K5RaV9acsTXTf55BXuh+57/dEcTE+hL9ylWqc5I3RSGNTQZtwiWozJLNaGBKUk/7j6+CKaeyNLYo3e22Tzm8Y4k1+jNNQcrV45NX/pr5CyFeuUT874laHH1T9eguOqyvXp+n8lKKBFt9zCF66vnQZzvHpt0CRjs0M9TuJKwxjdPm3115d34cEsSGKOdTuiRksD2tTSbskzGglNMDGouj80tjYC8u3o8m0dbpfzRm/ndmQ93NEzaGbdztzTXQqm1Yr0k1F51T4BwiquWaQJeRbcYeI7hYRZOgh63BJVMj0/+ctCiaKXUmpyFepga8bXII8stSTtyTs4saFTb777AE4O6vCums5JgTTlugHeG9mKJ8sg11TYgqWcH522aYAUp9OqRumJQPVYO7uSbwNj9Du5oU/3v9Jq3X82SAO1nUYmTJdy4StI1wDo7hJpKqesFyHYXbcx4alKMOeu30EQwgsYKrfrVV0piHIZojdtAoqdDdt1BxEnwK6xInKq11MgxqfwSTXEP0RyK3m4Sxp7Y/nwWcPd6KXy6kz8G0uJNLnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__kernel_physical_mapping_init() will soon need to work on multiple
PGDs, so factor out something similar to phys_p4d_init() and friends,
which takes the base of the PGD as an argument.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/init_64.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0e4270e20fadb578c7fd6bf5c5e4762027c36c45..e98e85cf15f42db669696ba8195d8fc633351b26 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -741,21 +741,20 @@ phys_p4d_init(p4d_t *p4d_page, unsigned long paddr, unsigned long paddr_end,
 }
 
 static unsigned long __meminit
-__kernel_physical_mapping_init(unsigned long paddr_start,
-			       unsigned long paddr_end,
-			       unsigned long page_size_mask,
-			       pgprot_t prot, bool init)
+phys_pgd_init(pgd_t *pgd_page, unsigned long paddr_start, unsigned long paddr_end,
+	      unsigned long page_size_mask, pgprot_t prot, bool init, bool *pgd_changed)
 {
-	bool pgd_changed = false;
 	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
 
+	*pgd_changed = false;
+
 	paddr_last = paddr_end;
 	vaddr = (unsigned long)__va(paddr_start);
 	vaddr_end = (unsigned long)__va(paddr_end);
 	vaddr_start = vaddr;
 
 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
-		pgd_t *pgd = pgd_offset_k(vaddr);
+		pgd_t *pgd = pgd_offset_pgd(pgd_page, vaddr);
 		p4d_t *p4d;
 
 		vaddr_next = (vaddr & PGDIR_MASK) + PGDIR_SIZE;
@@ -781,15 +780,29 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
 					  (pud_t *) p4d, init);
 
 		spin_unlock(&init_mm.page_table_lock);
-		pgd_changed = true;
+		*pgd_changed = true;
 	}
 
-	if (pgd_changed)
-		sync_global_pgds(vaddr_start, vaddr_end - 1);
-
 	return paddr_last;
 }
 
+static unsigned long __meminit
+__kernel_physical_mapping_init(unsigned long paddr_start,
+			       unsigned long paddr_end,
+			       unsigned long page_size_mask,
+			       pgprot_t prot, bool init)
+{
+	bool pgd_changed;
+	unsigned long paddr_last;
+
+	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
+				   prot, init, &pgd_changed);
+	if (pgd_changed)
+		sync_global_pgds((unsigned long)__va(paddr_start),
+				 (unsigned long)__va(paddr_end) - 1);
+
+	return paddr_last;
+}
 
 /*
  * Create page table mapping for the physical memory for specific physical

-- 
2.50.1


