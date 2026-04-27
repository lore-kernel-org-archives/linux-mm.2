Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9866EFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A446B0095; Mon, 27 Apr 2026 11:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052306B0098; Mon, 27 Apr 2026 11:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1F66B0099; Mon, 27 Apr 2026 11:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDEBB6B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:37:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77B44A1C85
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:46 +0000 (UTC)
X-FDA: 84704735892.17.15F1DFB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 883E3A0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VqzVl+L3;
	spf=pass (imf25.hostedemail.com: domain of 3ToLvaQgKCGcFWIG+LNYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ToLvaQgKCGcFWIG+LNYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRW0Zv+9eSRHC2Z8bSw9fwUsmK+GqZsuc2Bm/mr5lio=;
	b=SqxPR3DvmIyj7kd493x+G75lLZuSdf0z7UFWXc0HnomoZ0qPNgbclVxQR8EsWOLiOB2Di+
	dFBGoAhKozPN5hsXs9KYuP1J/Zc96pAz8Bng5k5tgO9tzba+e7IcYoGwyhlvk9hP3EklrX
	w+EQuqVq+WZeoOpEQb5owKc7iJLPJ10=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VqzVl+L3;
	spf=pass (imf25.hostedemail.com: domain of 3ToLvaQgKCGcFWIG+LNYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ToLvaQgKCGcFWIG+LNYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304144; a=rsa-sha256;
	cv=none;
	b=IPavFo1OIUzMbsfh7R7aJFqyzQ6FxRKZydoDj1r8yJfl5BQx1SWymHlUVG1wCvxWSXgSAc
	I/XbC0bitp+SohQBzFjGKa81VG69EEmmh6WFYDk9E1edHTLy6Ivm0Fe3/RayRysJLVcCnw
	aprmRRGuZ6g7EhqmP11LwxRD3jhztjs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a5adc12ffso39024535e9.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304143; x=1777908943; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XRW0Zv+9eSRHC2Z8bSw9fwUsmK+GqZsuc2Bm/mr5lio=;
        b=VqzVl+L3ChO0nj2YoPG1ZYSCw/eEZyPsP6s7ncv5Sqxv2HSk9xVQkkFNIgvUiO8XP0
         WZ8MWr3qLXILgwJ0vE3ZiVV+u53ZBrvUQ3PV9l8s9KEgAO13pq1GFdv3d0rQJ8WjCkXE
         z5KVRu2mZltadj0bSEnV3g/GgPR2OD1ucMZwnY9GwcHSMoSMHTTlq2bN9lMVuIEMnzs8
         HGCURob0WgS8w/gPaH/6Lr4bwDKp8Mz8RnJTQ0g69h8dsz6QL+vT09sqNVMDSUhXm39g
         oiCFbsXigseKGNEbiKfdZ5vQxPuGyGZQT/LMaTspLMMy2eXcG7FNaqA4g1QA9RXU+BC3
         ebYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304143; x=1777908943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRW0Zv+9eSRHC2Z8bSw9fwUsmK+GqZsuc2Bm/mr5lio=;
        b=fBuGdtfyn/n77uLewWBvUPZbxqajCbDwvJS1gTYWpJQHBQuugJ0rLQygkMoTLEFhCn
         yFX+fUpcCUNBeMTg8Zm3vNnt2JORGm+WzORoevAiP11uQkQ6jDsUDFTxmz2ilzVWtHw5
         Kw06kiSOTT3Rn2lSiXD6Hl6TEn6yu8wtlU19Q+ORsPNOPA0/PPrhOQiwCeHgWA3RFHPh
         rF8lequWHdLyJEw7kdDXfavCRyexuPECtNEcygSoI6okk1h4TSzsBNQVt400ato/wF0B
         C664XFx0v3ATUqxwGiklgof87LkDODdlG5diMDgXnkZxqNhDRBCDyM8fiUl88KSBtqF4
         TeKg==
X-Forwarded-Encrypted: i=1; AFNElJ9fn3QjA6+vQobtFa5apzT4Yxb3U0P1bkKgRczEV0lsC1bjBEKmUMnYNmwSJNeMRKuHhNFiczQUWA==@kvack.org
X-Gm-Message-State: AOJu0Yx6Ysb5E3vZezguGR5fqtYB02XuKoa3l6Jm9CHhe3U0BVQbmyst
	0/0mRD9ELFENjGd4br4NerZbwLq+3WaHFwICglfiKJjxs0gKIBtxTNLTUlPzLOv892UIa8PqZQ=
	=
X-Received: from wmi26.prod.google.com ([2002:a05:600c:21a:b0:48a:591a:7a7f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6085:b0:488:936a:6220
 with SMTP id 5b1f17b1804b1-488fb782618mr560638815e9.21.1777304142771; Mon, 27
 Apr 2026 08:35:42 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:25 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3127; i=ardb@kernel.org;
 h=from:subject; bh=j6jBQGBWye927YKYtEIXGLmbEkQZrSxTUWO+ZEqsDOA=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E6tZbZSRzXSOd4Kz7RcrfTl71zvelVlQ7kjb6c7+6
 +/LvbZ3lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgImcesvIMHmRmfnsqu7t5Yc4
 f/yT6uhbkVjgOtPMoPXVglXVv166rmL4H7fu82/15c+rukSuf9ApCKp0mWdk7517vtF+nva/d2u e8gAA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-25-ardb+git@google.com>
Subject: [PATCH v4 08/15] arm64: kfence: Avoid NOMAP tricks when mapping the
 early pool
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 883E3A0005
X-Rspam-User: 
X-Stat-Signature: gfxqkp4hjttgp8g6jdh8qe1fjjztecnr
X-HE-Tag: 1777304144-233556
X-HE-Meta: U2FsdGVkX185Xe158iqjgGwxzwqWnATFQDKd2q5AZboVZ7R6QXoI2Ha7oIJtTqUPYQ2v6EZowdpyp6QG1po07AD7NuVENtaoTNK26Xv6wk6Z8cukDfIX+Frp7H75Ua6VxG6WJ/SzX8CSuHKDrrG8EO0hwrQcAKSB+iJXahpirOvBjbG3LyqvdRAg1skK3AgmAYwBpwp/fM2LVzQHpihnNNgMJjxgsD4bCOwNCL53aqcBxvTjiaYQq/vd+aMH45/66r/6Xor/yjGA6anOr9ulfU80JXD5rQJ1iDrWZpj0T9V1S+l/G6sTZZTB8rFMqscvVkavKezpLx/+uym4MTY/38LuN4+5ujjWpa0q/zYIrR86MBJgwEB3OYRIXKCPE6jqgth4jJby7qNg6rbgDcOyJdKXJoz03KZc4h2tMCMAIQqX74pmyIUC3VxdAyFJevENpYejmQvhr0gPH29p3yvtEwkNMfRVtoTWGNoOqXQlL3oPBpcwEuQAxccp68+VVBSTdenAACAlGMo2VfYUOzD5RrOd1kVdWEOaPLTA8vlFoFRCID0rzDd9/AA2acxgtwH+yscWkCSXHGbpGRkdsO+3vtkBw+CHaoxsAALBI4luQUGfM8g4d155AE2d5dFdBhNevuLP8mc+W8Z+l9DYjP8o91rIUokX3FlFYmiSlvT2YLsJepJ5X7qeTTKOYNOjJjhtJjxPFIac4Y2g1bMKl+7llkwJMEQi9GMTueKxV12j8eT51RSTGgt71uXQPFoESBBPvs0mfxqojcXV/BpFewjqLTXGbbGHlTD05Tf4hU+9OQaJ8E9qyBHC/tkYpiXWZLwZjDDwcKYPHdRILaXI4R2qcszClZCrto5+pnEyDkXfIExEIDk4KD3BJDEofmmTA/U0U/S5EmnJbeq9EGnLUq7TF4sY4zRAsmxbqrFizIrLlFAPzHvSr4NW4410sWOciD8+RsTrMGYfC3S9DOvJImB
 0L5JasRS
 OX5HBLI62cOFhPBV4BX6kIqGIiBFKKHHf7oJ5o+pmhebBGnCMybCN3PIqey4y3W4FhrOjMug2mLMmXyGu+L3b9SuTfOwUWV34OJWBU9bziExCiMt6br9pXtSm6ebPpPtKCYRtJsXlhCoMG/gT4GeKD17Q7VEL1i2ASgCSqFMD3vfxA2SvHcHLYIDyLQwXsS/UzeJLkbxrpi/3ko8dd+uMAIVbBVDaWhoGeUpaRnKTUAeWyhfCgeY/hGQq+6my+tNVl65raX8DXkiwuYXUgdX1pjHBJig1SQp+POzLes7hQAghd/W2S5O0ynfAGRG5E6lszc220H2UruMVrVE56qzqpMYOi+7g0uQnzl5nyCFkK1PXmvC4ypf+0/ObI1arfP45L9V5C7hSff2NeHSo+gmrRuuCoQ+wjn2PhzHqFW67dHxXK7iF/3uoge2/DnTELzlKjENMtbs9eCK680TXFaeaW/ag6twhngHYa/wTdNSKl2qlN/tU5GJ/riU1kzTgA8WVu2T55CEjkc/yE/yDVEaMzOE5R57SWYEJchaBeJTTRwvOVlioex2S9MS1H6aSJGUbHDTS
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
index bfb2f1cae724..4eab40f4aa6f 100644
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
 
@@ -1194,7 +1180,6 @@ static void __init map_mem(void)
 	 */
 	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


