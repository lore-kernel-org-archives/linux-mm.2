Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27B8C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D45C6B009B; Mon, 14 Sep 2026 08:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0602E6B009D; Mon, 14 Sep 2026 08:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90CC6B009E; Mon, 14 Sep 2026 08:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAD826B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:30:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 130B0120404
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:58 +0000 (UTC)
X-FDA: 85212302196.29.75C9264
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE5A3140013
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GVJTDJL2;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsHDceZzlS+Rh+iWWqSfagDmXjRCcCnvqYJsO8T0XHA=;
	b=JpVq8wgP9d2gdkhfFHLAbh8bTJuvs0PVZAhgfnU9S7PehGNgnmJKJzVhEEJNyDj1e8ZueW
	1WdtPADf+7Sjgg15AWuU+awGw/TixWE6BnbP2uxn3zjW5yWpD88doNSBdLNJ5Ju1r7cwkj
	SXjLuaX8Oj0BCnCuS8/BoBw7qsSIw1g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GVJTDJL2;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389056;
	b=0zGGhimldwNoyTI9MIfbbO2/pFp/C7rF4iEKxD2/GqXydAOwKS7DiYdHiPdZ8qah8MOb6Z
	UybXhOQ7w+ArmLgnvTgYHX53BvYwaKat86ceyVm5SurUQIrBJ2J2iIIDfRGTsfddplZVQh
	+L1BxAmv11G27SJIp2BqjoJ2Jzp4/Fg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JTBS0CwwRKFBvKNpf3wbmiqAAg6MPp22qwqUFuq1B2o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389054; v=1; x=1789993854;
 b=GVJTDJL2915Flj6wf/6Lv7y0b7wdhpheBMW7zSIRfz+RR4pZ7mRf2y6yKUM++BlUeefTpgG2
 su2M/c/JmtPjTqi8CS8jbAjB098jzXgkTUOIRRodhDER6D/qouHY6HJ0j4kGCNNQV7tkDcoR9yy
 Z8VZtq48Qu4sSi6FMzuqtleM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e87265f35c0b6f38;
	Mon, 14 Sep 2026 12:30:54 +0000
X-Mizu-Trace-ID: e87265f35c0b6f38
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [RESEND v7 05/29] riscv: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:55 -0700
Message-ID: <20260914122950.3283997-6-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE5A3140013
X-Stat-Signature: 4omzex7pfcre88xqwoefp17xmk8w5ywz
X-Rspam-User: 
X-HE-Tag: 1789389055-866061
X-HE-Meta: U2FsdGVkX1+uLA8F79JmWvjJCe3uRwypumdsaFBzjwXJ+pBkQt8074QCZ/4xyyh5kdxWc0kquv1T50h6vw8TJZprrccqX6guTnVT3Ky7VIKFRVDnv1l16rmwVyXck9ONd8/6jhWvSA994jGijBnh3pGbAzpXzRCL+8yH+DNjcff7w4VZNULTw4YVkTNL1+s8/8RmxE5uutgrxE+JtnDVnkpNwtGygZ48xeYjZZi3ulK7gyzJPQJ7TRfGxszSTnD0F35J1Faybi8IaOCaJ7UbrtpbW8iz1ZG1ZN6gU8p1uNyH7XrNXuBGg+vcNa6OYkKG0fF7vrd5S5FBebtR/la/pOVkZCgLeV3Qqxd5wTAyxx7PrtELBPbkQZNWPoH98gRnFgES3AM5M3CNWe7STULx55mW2vBrRK7nrKNybNKRbloK8dIzeM5rzZ4YLySKJeZ52LKsFcfhjwsWrI9KgLjIs2kV1JAbUo9sPpM7zmFSYWnv1I6YjIw6z/XAjA5ALR7L7ONPfE/ZWmn/p5WoKHfUpRbW2OzyYNj851/qskDqdqGPzVP4BUkhbAnlAf0oKtJaxUZknJLDPLssqoHh6n692z+/hkqnpEDy+Qdis+ixnu873DwRo2XoXvCCWVHOS6iddUymDAvrMQUvZdsfYZAJ3uQpSZufb5K4Ri0U+PzzWHX4ds1qG4e02fsclRJAzLqUsWFfXq/aDvMlj2ZZfsiI9ArNsVWmcDw0RQsyic34HmgfqCxLb7dOLWzJi/KZI4zGTkpG+0jV9Yz1zHAKfux8UJkfXwzKk2Fba6nd9nRoXUx3+M0yWuftsH0BIZ7eT/AIujQrKI8SinLnvgXCf/CfxTR7eC+dZ1cibrrEuAuLCfJ5Il0MU//R/GiADlYKJJ0H2d5HLNz4gpYaUOt4AcUfucbSJ7qTBmgHleXJ8WIjqyc2TcOkUm21ITIuco0zra2qkXjRmLEmBCNZErSa4wl
 jAeOks2F
 2OkgJrOrKBOxdENBryRhKgVEMiHPxV/KO2gk2LUY2lE8a7sBhiAA96F60Zen6yzlnwqqFhCRHawc5gpUu8tMjk776jX/KbsBEBDF7e5Bhb9I+DawFw9/v8G0Z60KeYVeiRE03qACLehfAMx6zyVu5Z/lNmlALBpxTq0DeMEBqvArEuCmydXxA1Fc/ZyxeT1PvPmjXt8j7NfX+PfUl+blKwKotOH2q3/zOpYixpAlChaah5Rk1kcJrlgCoHz0uw3fjt0QvHgbhtW+Eucd7smZ8wvFM6SDvzfCcyY2zMPHLrZLB2N20cXGZPU86Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

riscv encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse _PAGE_SWP_EXCLUSIVE.

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/riscv/include/asm/pgtable.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d48f90140841e..b644db16bda94 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1219,6 +1219,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pte_swp_exclusive(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
+}
+
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
 #endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
-- 
2.53.0-Meta


