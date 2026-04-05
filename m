Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AADEF3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736886B00E6; Sun,  5 Apr 2026 08:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D5F6B00E8; Sun,  5 Apr 2026 08:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623736B00E9; Sun,  5 Apr 2026 08:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 527D76B00E6
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 223D0C32FB
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:17 +0000 (UTC)
X-FDA: 84624505434.11.CF3475F
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 49D691A0008
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eGJeCbUm;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eGJeCbUm;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393895; a=rsa-sha256;
	cv=none;
	b=Uy0ayRsYeiko8UCFKEZhNjuEh8/vCfHT7NYj0+39SVxOOhaRgB27PioDlMbuZ6K/o7xJ+W
	S8N6kjiXGNepykIpjCjMnM9L2wWNHGgJaokHAq2GvsyA20DrU0sJsCZ31F8mzTdEQNKAdX
	QTzVWfddO2ZYPb+GiI4KT+CLwn3OD8c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwisMsoot6phm5Bl4goqnbBJk52l8dQLV+Q/Y11L1i8=;
	b=YW0Ocg1w3GwifiE9+FTJrgYMhpwYtoxtOBdPsDnmJkiuOvzsfXxnqzHlEscgS4pY/O5suS
	qTnsQjzEcmSqg2lTxRqqE8nM3ry/J8hla8KQzv6KBDmtFED0fMW2FNptPicZbHUnL0FAO8
	ynvWIusCjJy7KOSm6vu1ZgfFugDPcEc=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35d99bae2ebso2819869a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393894; x=1775998694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwisMsoot6phm5Bl4goqnbBJk52l8dQLV+Q/Y11L1i8=;
        b=eGJeCbUmcxBfs12xPNstF98eN5ErjehjqjrPvjPhVg6m11y85GrVrh2r0g0WBRstwz
         x8r2CZlic+Yp34WxAXQPiYx8/8AuHtZDQVp5w78WmDjWUmil9+TohRxYWcW0tSsOgT5M
         xpSa1weKGLdyF8RDwcHLhHDRB+t0CI/RZITR7MVZSJUOZmVSM4WVAQKsX6RRQxq6M8DM
         J7UbjxaZy8YkrPBfDdoM5vGTdoMCAslN4NWJMoUcyoY6v2e3C0Dl6hJOgrM9XlvBjDG5
         iPNxDTz7qiatwd+ZuRTVR7TBfDJHD86kGuJs/XtVVsGAYss9K3Z6gnmyc+1QsTzN2zut
         BS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393894; x=1775998694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwisMsoot6phm5Bl4goqnbBJk52l8dQLV+Q/Y11L1i8=;
        b=Rj9N7GBBDZkgGbl/LDWsu4KXQWc4JGYovNLglcFpWc5nTJ6EVyoJVbilKPq9aHAQgL
         GFqZkYPnwJls7ZB0T7jBbYe69qut1k0RU2mwcqZ1C4pSQjf0AoUMEGqTFNUUgi47+oJB
         J6RS/KqIszpEH31zSlL7OsClJC3rkiH6+dX8XOtcylhB/NUiiHX0gptg2v1zD6xyaQy6
         TvT0WVE4IMTy+rASKrtE9OHo9Y4bM213ziTRANjQrZKe9PL9z8Hx2/gfdOSc11xUMYdD
         eE+77SKmsyUSVHE9f8ZBqrdffhUzzdq/7V+Q+CD+7PQegPVsYiLMbs6/0WEjQzTG6oL7
         69gA==
X-Forwarded-Encrypted: i=1; AJvYcCWElRX1qh5JsezJDFD3rVBrpQVxOOldE5WkxJhwz+/3BnM1yhdDHDxMczFLklXM644snLj+fYWHhQ==@kvack.org
X-Gm-Message-State: AOJu0Ywvc1GfUoUzu8cr7CdrIgPwjA9Lr2eRrwYDUcMFycPo3SkeUKVq
	V0DJl6HkX7aocqgRAXK/+WdTgTOeobDqIKFgU3kWpwPL0OtFAtUBZUStLlOR5GXt5NE=
X-Gm-Gg: AeBDieuMKCIB+jUTL5FNbv1R0f0V/fh57G53p8wIYGeX64ATHLrOp43aT5RYEJFlwkv
	S/xyyrLseErva4IrujMZ0tnWFSdAywovXzlcDR9wv4iuebmlGJXILuTKusPlMK5MblHae5NgjTP
	jCvous1T92Bhtpvv3s/szne/o5Ox4JpWFngrOaj6iBp6Hct73pA6hr2WRN041ZBrNTDDLUicV+3
	bS1gDUW1tI/Hp37MkX3brD9VQ0lVK8lPIxZxPhQWkyRImbVpzijUzPTIBK+amsziBzyGSXck446
	rKAMv8W155UvZ7Tjgxz7sgnFNHFuFLvZGbB/n7Tz3Abs0inToQDAH7dqTszls8psN6PB1DMqa9k
	CktRI2b3IM62tq9SEmkC8MGoq1Y8FQ784ZBkRF7ZIvyZLLMGB+12qJTsujpNvF6iGow4FYyr/pt
	w0/jHAzRHgn2Y1Ah9I/t5Jb+2GicAr4hCCAGK0hh37zRvzmTkmQLoX3w==
X-Received: by 2002:a17:90b:1dcc:b0:35b:929f:7e92 with SMTP id 98e67ed59e1d1-35de68ce5d0mr8629035a91.18.1775393894073;
        Sun, 05 Apr 2026 05:58:14 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 43/49] powerpc/mm: rely on generic vmemmap_can_optimize() to simplify code
Date: Sun,  5 Apr 2026 20:52:34 +0800
Message-Id: <20260405125240.2558577-44-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 49D691A0008
X-Stat-Signature: guttgg8edaydqyxq9rczhqdia96bubj6
X-Rspam-User: 
X-HE-Tag: 1775393895-888237
X-HE-Meta: U2FsdGVkX19NOVoDA1ny0JfZcmeUsOHiMFCKKTV+AKVMX0iZNmDZ7gwhbWKm51C/AU9BVyv2LJVW+kqIFJBt7LqjtlsRwfcTqIRrmpfVl5zlSdmQ4J4Vt3qyCYAHpuO2GnQoixyBjuOA+JPBCmUKY4P4d5KHYfDwvomkxGrjdXNnvYq+YHunZS9yYe2QojuzxeMZZH92Ak8cQ4ZeyRGJoPEr27++kqVom3wIiFMAufMRhf9peNfsUhPT8BmuL7OORyXC7lqMMgUfVzNpMkh+dnHnWzVT2onyW/BGmYvLQTNccW7A2dxXocxlUssXWqVY45QbE7+rHb3ivF8e/iOmdNO1+kX98B6jlkSkiU9ZkMeRzqzCo2gn6HAeqbSYwuuwHqaaTiOn32E+lo5YmaBxjvvfqpvuFQEafsVgSwSzR3ds5aMDlAuL4bbv30A7hD1VLAB888yY0e/aRV17GdEbWY7btX3CwU/vZRD/hglXfCeeleeUymSCztEe2ZuVdMfQaFA6+gggIhgl2/3FnXY683p0en+Qp+MlIObvKq3lEbADoFxKLCCf4yzBOH7kezpjHmm+Q2FesTCKnlbl0VVrLFvnLaWvtBIK5KsrzL4jyylAjAYVInkr9VhUKrKJRZLv3h+1npPK44yezKC8/W5niBtg9s/0PELei1m4DGFQfw+T+Ai8eIYqKwAvamkGQnOuSS2U6EvPHrEzOWksnl3kaDu0OghdQMHa7fkcfxAzw3XYB6YaHSphS/eFSST0aMxQLAbUib5K3K+4hMCI6sun2dg98T2L7l5+6JE5ss9ivk1tqSZ9jSHMUlJ+0RyyBRRg7sZPsKxYVTkpiAT4RNWvXC3mhOQWN+mIFQnD/RzRUKHsK90kQthoAme/JLqJPlZTwAaXeYEOTEaq4ge/iw28sPk/AqfHmqQq04Wgo13nA2NByba/ySygDkHfEnOB/hBzm2aNI6YxSVz6U3sUdOV
 7hLkplou
 SpiOHurCo7hJ5yMLBrTkE0DhBFNnWyJKAwvkCvDiVneX80Oj+bOCOdQMqvNZuZWWT3vWzep54fBJCXK0DHtKblfluFueTCmAL3ViDX+vNYgKRs6UtljHgTlw68eJMIYMm6j2WhZhVym82VAOGHWfW1EZMy11W7yLw8RNfQP2eYAvtCicTKhq6dK+qsQ+8cuJ3LX8snSJLuK+vRhmO9Bdk+8D35Jr3Fkh2WDdJ/TwweCQvr/9xxmQRYZPH/XLzfNmWfOIWwiQxutab7xZWBBqcSrCQrEkEplsrZnDPYu8DYKO3HVHjlbMShHquqsN0mA5ZO5Qiw4DgsDMn18rw3SFvtUB7F/MBmPKBgv0wC8KMUd3fTfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The goal of this patch is to simplify the code by removing unnecessary
architecture-specific overrides.

After unifying DAX and HugeTLB vmemmap optimizations, we can rely on
the generic rule of vmemmap_can_optimize() instead of having architecture
specific overrides.

In radix__vmemmap_populate(), we can directly depend on
section_vmemmap_optimizable(__pfn_to_section(pfn)) because the upper
layer (sparse_add_section()) has already set the section order correctly
if the optimization condition was met.

In the fallback case for Hash MMU (!radix_enabled) inside vmemmap_populate(),
we reset the section order to 0. This is necessary because sparse_add_section()
may have optimistically set the section order assuming optimization could
be enabled, but Hash MMU does not support it. This ensures that
section_vmemmap_pages() calculates the unoptimized page count accurately.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  5 -----
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 12 +-----------
 arch/powerpc/mm/init_64.c                  |  1 +
 3 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 2600defa2dc2..18e28deba255 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -352,10 +352,5 @@ int radix__create_section_mapping(unsigned long start, unsigned long end,
 				  int nid, pgprot_t prot);
 int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #endif /* CONFIG_MEMORY_HOTPLUG */
-
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-#define vmemmap_can_optimize vmemmap_can_optimize
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-#endif
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 714d5cdc10ec..36a69589fae4 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -977,16 +977,6 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 	return 0;
 }
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	if (radix_enabled())
-		return __vmemmap_can_optimize(altmap, pgmap);
-
-	return false;
-}
-#endif
-
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
 {
@@ -1126,7 +1116,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	pte_t *pte;
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
-	if (vmemmap_can_optimize(altmap, pgmap) && section_vmemmap_optimizable(__pfn_to_section(pfn)))
+	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		return vmemmap_populate_compound_pages(pfn, start, end, node, pgmap);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index 8f4aa5b32186..56cbea89d304 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -283,6 +283,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		return radix__vmemmap_populate(start, end, node, altmap, pgmap);
 #endif
 
+	section_set_order(__pfn_to_section(page_to_pfn((struct page *)start)), 0);
 	return __vmemmap_populate(start, end, node, altmap);
 }
 
-- 
2.20.1


