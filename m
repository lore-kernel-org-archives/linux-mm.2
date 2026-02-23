Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6529AC624D6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 03:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839DA6B00A4; Sun, 22 Feb 2026 22:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E74A6B00A5; Sun, 22 Feb 2026 22:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D586B00A6; Sun, 22 Feb 2026 22:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C48D6B00A4
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 22:36:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00A4CC296D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:36:37 +0000 (UTC)
X-FDA: 84474309276.19.1B43BFC
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 15488C0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:36:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q2MdICJu;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771817796; a=rsa-sha256;
	cv=none;
	b=qhF/rhn0TxOFnLeoW3iUjERun+yyVixWmEwMaT0yyO464/cMStWlDSSBt3In+NK1sm1dJg
	v7xd60ZCuJ5rxWxCcRUPt9Jm38xN9jz3nubPSZb3RSeAEKuS6DVLIIz31CnoDZGk7+4pLN
	a8ukAYYUkjBI6oHLamg0eQTbHIgVYx4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q2MdICJu;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771817796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y+UABCdhx+1FSB4k0JrJcnKXm4mw68KgS4c8CS3QDWE=;
	b=OwaztpIe6B7nND6+ZJDVPEMcT0u/6m/qi0LIYoqv0Iu3glUVZOq6Hvw8LODp7hc6UbvV0S
	gYQVX84riGm5g4gsC85kSsiKpiOyA4cteaE9p2tyPPq6cB/7Wd0v+9z4y59CUrgTKlp59M
	xfYYVRIL7Q/wT+upHhZqP1zlnvPoawo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771817793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y+UABCdhx+1FSB4k0JrJcnKXm4mw68KgS4c8CS3QDWE=;
	b=Q2MdICJuuAFuOrJ4291ahoJPC33A1NEyQ9jPeOkHw+pdk0RcfqXGFzbc6D0hQqbOiJtac5
	slpPEzARrM0wwa6cLvRU3b27xnTsdAxrhHSRd25v2gFlD3nTfh9OSOOLhw1dGrATd/AkrR
	AjMq0PUsznCG5VdVH6A1PXZFT9FvAZo=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	peterz@infradead.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu() when batch allocation fails
Date: Mon, 23 Feb 2026 11:36:04 +0800
Message-ID: <20260223033604.10198-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 15488C0005
X-Stat-Signature: c54k73956iiom4f31wmcmad8a8d956oh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771817795-896770
X-HE-Meta: U2FsdGVkX19LWp8vTihobi5wJ7JPdR40L+J+nITAJWdAKYzJhRszQBLoLCMY5RKq34FXb2wtQznWmGMtjDK3ORQ2l9LjUSE/e6ieMdBpgSI0hdtXSl5gK2iU+k7AsxxTZEr7VRtoVcPsxe4yAEhJJ1ZQC3jr0ZTCJHPcRlwybIkQ65lGOF/uTpDmNUBu8q2G6hBQ5ywgUd4jFEHIgJODWlfGLlKUa1ENKJVQQEKWSpuY0tonzQEikB7Pa/nyfjhoXhVCu0y2iOaGN/tFQR7XSPUphY5/GOSvCnvagUvtr8MU3ZzZVnXPwTBjUQY1OSl5yy23DR2vbAZ5yjvsaqgu1JwTpChIgCl7o6BKZKSDCPwUPS6JIfkSYfgDawHkY/rQ/r57CYgILaLAJxAVdSmp4Ti3rSTagz56u5aPw+qBV0uhSLanMhK2QaJcebGYouh0/Eq0KdEuwetcpgU/o7JAVd1tgQBWVDLgoZdqnOX2iZ9m15dU1moRtAECmB95wQJ84mwy9qIVAPUXrhNTDpJemovlEGf2wofFwNKvaIq11Hlx1AJQzXlH8UrQzfqbQrnPf6JUBJMbM25rDAhaYxyUEyxLJa4SVTgPa0q7SowUYHcKAQM4wJgzow3wCBNO55mS+i0glzVp5npIwVseJDTnwptcB7EbruY7doJLnSBXIQ23Xa6ySSysgeHpA8FF9CNHeWqpFmzDr/IQJPPPrwPK3JjvSOzJjpGSn/QNzq11ZRFL+jq6iv3ePLCtRKEXuew2ZucSqBztwjW1FJ9von+YR0Ycm+Ui4+NCgVrgt8NiPyqHHIToDJaItufLJ1IPOYBnJwr/N8vexg+MlH+jih1WXqUDwYkhfLown6gMfnbn9zlMLOKEftXDDnwkUFi2Npi6C+WuspDOuevCUs6Qgk/mgyIldZYlWFhARTEFg0UV7cg5nt9o81BuZgOPKZfrBiG5qexHmz/a3eVVOyT0tS6
 uetvKgQC
 09G1re93etzuv6VfAOpLl1Y2PoaoLELNfGT+cXUYjzVHgdM/4aYcM0pF7y9x0jmKqxMvswNXD2nIEkG0OKQSfMmYNrkVitmlQKV8XEE0Cn84QWDNxtBKKOUOwWiYC2nZ05zWkCN9nYMdgvT/YGamELZRgGJplaEOv2bcNVsq4YxEbsQ3/4n3rzd5K+rLnKCPUJpQpPe16NXiJ4d/U4g0FTjFnOn1/RLteayqXmGxkTPBMu+TaghzDro2uHd8+lDn0agXN6qY6p931nChRjDDwI5E1IQzdHUjEmBckSGLhLNiW8tRIYcgoJu1+RkvC6XdOrQkbR5Y1GfY/xGW/RiaBV2KnB1c9tSulre8lvsvQev94rBA8o7ZvxRfY+oKXS1Rmf7T+EK3Wrduthb3qttGum6BjsICObt7JPdcb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When freeing page tables, we try to batch them. If batch allocation fails
(GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
batching.

On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
process is unmapping memory. IPI broadcast was reported to hurt RT
workloads[1].

tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
(e.g. GUP-fast) that rely on IRQ disabling. These walkers use
local_irq_disable(), which is also an RCU read-side critical section.
synchronize_rcu() waits for all such sections to complete, providing the
same guarantee as IPI but without disrupting all CPUs.

Since batch allocation already failed, we are in a way slow path, so
replacing the IPI with synchronize_rcu() is fine.

We are in process context (unmap_region, exit_mmap) with only mmap_lock
held, a sleeping lock. synchronize_rcu() will catch any invalid context
via might_sleep().

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/

Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/mmu_gather.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index fe5b6a031717..df670c219260 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -339,7 +339,8 @@ static inline void __tlb_remove_table_one(void *table)
 #else
 static inline void __tlb_remove_table_one(void *table)
 {
-	tlb_remove_table_sync_one();
+	if (IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE))
+		synchronize_rcu();
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
-- 
2.49.0


