Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A929CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 811078E0029; Wed,  8 Oct 2025 21:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F6D8E0002; Wed,  8 Oct 2025 21:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D4C8E0029; Wed,  8 Oct 2025 21:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 460F08E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE29A13BEB4
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:44 +0000 (UTC)
X-FDA: 83976916968.09.7B0E4C5
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4804580007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=FzyvM5NV;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAFzin3ivjrQZj/QpZ54jF9jkkD8Fld75BEMN783hL8=;
	b=RGH3P3KOQhNYUsNVXHSCxDiZYQW22+KlYjbDoD1CsHnyKyKmIVl9KmqzK9lXOaXMRrBt1P
	wxxCR6bkjwJQXwx8Qzu8HsB8fCgD/M/FeEQPVyGx7QpLQh27pQbACtxj3mcpUX1Bemzx1i
	ZEmTaXRChfsFfud9WLbGZ/7GmAHtfIk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=FzyvM5NV;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975123; a=rsa-sha256;
	cv=none;
	b=5DDN/8K8ieR8BbG3uuapRh9Y+g58+xJn+hjIocKltfTi9XIPTTBHQXtm8ukoYXg9/Pr+Ng
	FaGYkl5NyZQkV7AbWsglpZAXP8fa422rVjedrNlmQKA3fz2zGI3apYk5qxIcPXkQkY9AuV
	yERu4bE7S+7SPsX7Z+KoJ2L53I86Bxo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27c369f8986so3827015ad.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975122; x=1760579922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAFzin3ivjrQZj/QpZ54jF9jkkD8Fld75BEMN783hL8=;
        b=FzyvM5NVHbS5gMLf+Db5QzUY2XxtkUfyO5i5vaH0U1/BE/dcu/TXty/XvGsdhVCO3n
         50QRvxFkGOrzl5+hJhHvvO8fhWKiDUnCf+iLo6ibDd5MaMr5gWptUG6iiqgQ54DyIPBu
         FjJKPF8dXmRhStxmDzUMc12TVQ+yh+7twZ6AKz8MMQ/47Z+Y5F7BPU2ahNGF0GJmk5W4
         ImA/XKFmVBT8JkcZ2hFO0f0eE9WSdqjxdZ0IeEtOb+y4TJlK7ECFkGnsYeJMZhbbURk6
         FB+y2qEs6sCuL2Eni8gIbYEYSYrnX/wb6eG08W8bXsOWgix2KwNeS1t87FV01CR5j96F
         oyaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975122; x=1760579922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAFzin3ivjrQZj/QpZ54jF9jkkD8Fld75BEMN783hL8=;
        b=B8vblWnVRoHvwNMH3GuD0f80okcwj+lO17SyceOWjKJZHfiQdEWY+2m02jDSi9Hw1W
         gCQggJZw2mbBtZWzQTHd06izka0bt3ItLBAxBo8JPb/s4Kt7IHWNaSGLn5irVsaFSv14
         m7k7sLHyEc7nwvSycgGObUcM6Kp1JFODEFloNkiU+nAka1BNuy6p/1m+LBIVk/Q4OWP3
         QihwtHI8xJT9PWh3h7gQcGefY6rFswBxyEC6+3J+hlEG/15GIO7ZpsmM2yQNxxSixf+M
         tbmzecohHYuB0NoNlOT7v/7V0kKU4sYznf6LxEPMG9NY2kIzROARuRkEwKsp4YBKTuWm
         Qt4g==
X-Forwarded-Encrypted: i=1; AJvYcCVu/aoeHYOudj+G22aZnH5mjbjYmmbggMvUBQqwdSeKPTzYnSs1RZKzYuw7MX5BPPXRV2vhbQvxjA==@kvack.org
X-Gm-Message-State: AOJu0Ywdv5ftqUO+bGq43q5fkP7rhk0etT+MvYDyAq9tnrAg7ZN6bbY5
	6PBU5h0ZERZvxLFVpTdGB6PNcfjBgWq5nyRoKKhM7Ja/qIWKEad7rc4dC/PIlLr2zms=
X-Gm-Gg: ASbGnctYW1gi8Pwm7FHtaX8iy+zr85F5AyT2jNiZUV4AIkIgKcieOMAjJmDYAGnY+Ji
	DC6z/TaQi5q30wq+gLrRbKFD1WVmdeIH52/usknfFZe1iDYQ0c4S0PARXrBktXuI4tbPyS3WRqO
	eBUYLCKWsfxq+qn1EHWm7+ZKE8bs4Xa2QTpkO9UKl2XeAvldhxyBHc04rOCQTezV2D9MTczjq7P
	+xOvPLGeUImET9s5fbOousbrmNKanuPsByrgpLMoElSXO1hssdQJOpSUQJBqHJz9xdulibCeF2m
	8WUDp4EGoKVZMVuvol/cicundzZxYpIXGW+UgQJZsGkS9m2dOI6ZVSNYpA/YyjP5ViCKwupiZVE
	0lJCcuwjPNGnBARRI3dmf+OKSxq3xHPMApYfom3bsBBMJKdtUYfkgVSYPE/iAXQ2Cw83uJd78a9
	gEPak=
X-Google-Smtp-Source: AGHT+IG2D+B4sYEjYqHTfYtptXhLnt1g1J3431Y1pnRWZqcWdGLQKwHj4/A4KlwSUJg/qQlrRp74lA==
X-Received: by 2002:a17:902:d58d:b0:28a:2e51:9272 with SMTP id d9443c01a7336-290273ffcd2mr61826225ad.48.1759975122096;
        Wed, 08 Oct 2025 18:58:42 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:41 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 01/18] mm/ptdump: Replace READ_ONCE() with standard page table accessors
Date: Wed,  8 Oct 2025 18:57:37 -0700
Message-ID: <20251009015839.3460231-2-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4804580007
X-Stat-Signature: 5p9am755umzmtc81pqtkfc95795axc1h
X-Rspam-User: 
X-HE-Tag: 1759975123-892693
X-HE-Meta: U2FsdGVkX18fY5hwtkrGK99AmKOGcCEaMOrPs4wB1+FRFtB+tPpzZITxLHi6AuLILThivxo7w3UmlCv8LIcG30U3Iz0sH1tG/TnTaxNMSBt9AZPpkI3NmOEWyMU4ggLYrLaHEANrthS7atZ34YdjAVAPeGLUOMFX1eZ3ciomAFp+FlPN+bf/Eb7DH28MGpLncBXw7qjM6Mrzs/ZPlZ0rzGZf5rL8LkhiAORAWc8B6S5yLHZeVYqBux/fUtlXe1WuAXDrOgDPQvsKqJIwzeWIYbybyUkLYfyj80dW8uzcZ0iGOyluFOf81E53pwWMeJcvQHNNt7uqC8k9D3Nok9pWwpnIS8VOLa7zyZkbDlMAA8qg7kmH8NzeWm2IDRQmBwMYsd7TQDFs6eq7rHv0uAMigXng791GJz/+ujOe9VVF5tsNFiUeu8rvsQqMnQVowrkkvLEw4yy2khjCwg5xel8p8SnQkYLQ1tQP697alhJyIbbjvOH5RvzGgKAUPOGCOuBQFXvTU54tYjCcserQDFahffnP7hK38TL+V8zGAO9jvtQ7ZcJXrrtgAMpMJyrqMQVMR14tULBVn9MoBDAkm/awMHftGDpxf/arRUzVUjtXWmWb/MNXjYRZ4VharwH0NtW2YZRK7fgRaoRsdYDhrcBaWQgR4ybAf5qqpsypV9VoHUOR5h9wEs45yAPKGhDiiEbRS0iEBJQpG+gn6tZiugLSof8EOEG55vh5d1lmGCXpZhhwIF1h86slxmCVThhxFTepCjGAcs2TeFDYDmL2sZlI0d21qcheYuoC5KJr/QoOmp57hFHW6Qi8zGjo3Yu1evx1/V8IGqDd16V83T8/hNAkimpln+Fn51jm7Zk65Z/DbOL9lbTCiqfhpdtlYIRmVf0sMpKQMutziABLSxcNIBcutYl0OhQJ5gYM4UdRJG6cHRrhLTSS2Cak8ND0G4AQN97Tzyu8ZkMmjHadZzAQQAG
 zpDuHTGG
 o0+zrQtRW98NM/SMrBUmcNP1l1uOIA/MSBv2iX3y8dgl26DjFgnNNg653nXLs8XUmRihMulHkDRhBvnnNdOXYCN2eSLZ7CuZY7lNwEQ5Y0tgk0ewKUwLRimoMSURKJtS1g4Jjoja0jaxEY/WPwZK5++GHYXEih/+ZrPsQdRIqSGEj6Ro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Anshuman Khandual <anshuman.khandual@arm.com>

Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
anyways default into READ_ONCE() in cases where platform does not override.
Also convert ptep_get_lockless() into ptep_get() as well.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20251001042502.1400726-1-anshuman.khandual@arm.com/
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2 (taken from LKML)

 mm/ptdump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/ptdump.c b/mm/ptdump.c
index b600c7f864b8b..973020000096c 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pgd_t val = READ_ONCE(*pgd);
+	pgd_t val = pgdp_get(pgd);
 
 #if CONFIG_PGTABLE_LEVELS > 4 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	p4d_t val = READ_ONCE(*p4d);
+	p4d_t val = p4dp_get(p4d);
 
 #if CONFIG_PGTABLE_LEVELS > 3 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pud_t val = READ_ONCE(*pud);
+	pud_t val = pudp_get(pud);
 
 #if CONFIG_PGTABLE_LEVELS > 2 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pmd_t val = READ_ONCE(*pmd);
+	pmd_t val = pmdp_get(pmd);
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	if (pmd_page(val) == virt_to_page(lm_alias(kasan_early_shadow_pte)))
@@ -121,7 +121,7 @@ static int ptdump_pte_entry(pte_t *pte, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = ptep_get_lockless(pte);
+	pte_t val = ptep_get(pte);
 
 	if (st->effective_prot_pte)
 		st->effective_prot_pte(st, val);
-- 
2.47.2


