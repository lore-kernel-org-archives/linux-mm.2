Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F21CC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550946B0093; Mon, 27 Jul 2026 10:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAA56B0095; Mon, 27 Jul 2026 10:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB876B009F; Mon, 27 Jul 2026 10:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 076A26B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:35:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85614160460
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:17 +0000 (UTC)
X-FDA: 85034804274.08.CE5FCC9
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id C30C720005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jNWpqChS;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NM59zTITSAnSgD8fALdagpl6xYMLVePtK5I+sk28JTE=;
	b=gmefijp5yPngV9JT4IgH9IpgiqKAuy8ipH0hqZc8NV+pfQdz7/tSAHmz9oU7+h/iLhV3WK
	OXC++46LD42fGd+dm79oMFC1Lh0YTcDS8+ECFnIRto/tMw/UapmTxQ3IpOjRO+dwmPCaGG
	IT1OaKhTHMWglz42MFeR9c96if3rR1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785162915;
	b=rkmnAkVfAE7gaehqT6yaMXlulnZ+tTR3cdsJvaRQ5Qp/IcMGNbnH4bZhRfYNd8tUKJRKdz
	bi8n49tJ9vclZ0uP6BS+nrSs7RVkoPO1cfkd2bqduXiaJ519HoiV34xHwy7LMutJc+/NAO
	w8QU3fxfbUyyxViA09T+eE9bjAQll8g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jNWpqChS;
	spf=pass (imf13.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cad68425a7so4039795ad.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785162915; x=1785767715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NM59zTITSAnSgD8fALdagpl6xYMLVePtK5I+sk28JTE=;
        b=jNWpqChSGuTpWl6mSN4xIYfLFl7VNxCByJdPlA35Pr6U6JSABEKXTKNL7bOQ4CCIeb
         yrz+EbSl0IDEaTUObn3BE8kn2Qb5awJNdLn1PmLG5U+GAcvLh568sQZiVYZ64MLQIm+H
         cbwSD8+Pa4fxXrtxz6zpvXyLIrsgW6Fu4D3lO2JwyeGdztW9BMqrU6NNQkvssihgO3VY
         xOj24io6mgy9D7T0co1TAjCiOXkOKnm60wE2YxiwrYr2b77/+B6E7axnsVwdH2TWhcYe
         ZN2HsOctLM4/BqnkUs13nb2PjAO5QZnNknMGZvl1cCar0Lej7jVfgph2qR3NaGlGRRZH
         ScSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785162915; x=1785767715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NM59zTITSAnSgD8fALdagpl6xYMLVePtK5I+sk28JTE=;
        b=ag3T7pv/hQViW1vUBudBRlqWP6o5AyLbPjVqcS1gMX4YYeRe81LiLU2kzgJj1AimNx
         yeYAsTRpz+2qi9VZhPuQV5dUtvwJasy/+413FoQ2ylNlx8AgRxKlGH5DOZOWTd2B0ROD
         J+etkWbsHecKGF0Yw8X+K9P+6PCt+9Iy1o2oSBLvlIIIL4Ib4CVpxqlBOyK1MkwPSDRV
         sA1OxxJy840pYJmH5UHj5wa5eMAnrYZUx3NYPfz+RnC8Yja9FbWkJ/uUXBdtXiG3xFMZ
         Ow7osPXQHJcZYLwzSElf4nI8pEhk118yq3f5EJyjLCRGDHJmVVN9WIRWFtQYm1CJHWjN
         TaUA==
X-Gm-Message-State: AOJu0YztJjsoDi/QwaBITxPXnbZXY9CSZd3RJjyOq2rCmdip2SvOSn5F
	6A2dQ4HHNt95IduP1ecBjqr+fmM7UxBEm9YAunDSyMSxCpSQUGDgjF1aa18EuggcrafXjSsh
X-Gm-Gg: AR+sD13cD0ma3qSbdOIkvhu/8G1qBUPhRaQfFJfw/7BEmf1gwuQENaM/DK3YC5Mc7sk
	fDAoTs/0SsXHFUiNyNt3kJkP4vaGknIVAC35tyvEplnFS4t58an5BnX53xxkycx4YH5srJ1xQrk
	Wq/p2MvFW8BwoW55SdKkWbi2/ahgXFJBb5Pbo1YKoRIlK7A7ZPVZz+4lNwX7pSIS2MFJrQqWADO
	cSRolUPrbkbeI2x+VY+Xcnklotiy49luiGKzdWSY2l4t01J7APPtorBR5nyFNPB0/x2kb3NdUeu
	MqCxcotSX2XP/4q00mZBLz63jmKEdVzyGqcRIeHn10wbZ84/PnPDajZz3CSos09F78Lo6Uxn2TC
	U9haHmx5owbufNeuIsH94lV9QhR231z799pO6GPXbTG3qVBRGWRhuVWKUbPOzqOyCh3MEAMqPu+
	78XJbb7JCfZuxTFNPkXHNjxFffPCNrjFZunKVNN8xofiNuHbkK9xw3iY4uCJQwT4hUQsWALlwiI
	Cw=
X-Received: by 2002:a17:902:f710:b0:2ca:d344:7743 with SMTP id d9443c01a7336-2d00baddaddmr3424865ad.7.1785162914572;
        Mon, 27 Jul 2026 07:35:14 -0700 (PDT)
Received: from debian.lan ([141.11.42.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7d5297sm36877485ad.56.2026.07.27.07.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 07:35:14 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	jannh@google.com,
	yang@os.amperecomputing.com,
	rppt@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: [PATCH v5 1/3] mm: make persistent huge zero folio read-only
Date: Mon, 27 Jul 2026 22:34:24 +0800
Message-ID: <20260727143426.1077133-2-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
References: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C30C720005
X-Stat-Signature: pji789g3ccua6jjtjrn39zh17skcrxia
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785162915-228189
X-HE-Meta: U2FsdGVkX1/INdE3ZmnsTVvWRDNvkaZzYnAipE6que0cmtNw+LnbAkEMlT59fONuw0xIuqxOOub8Ug9SMIIewUsNU8mHnO70Aq7zUFCibCjAdrh+DqyAM06W/x9a01gIk8An50txonU6kV46RwSwNWWNqgQDu38D4GCfcIkDdRav6pi6Pevtnwbd+MUeOuXlrU5CEDW7MCSWIIyYtZZ1vzvIiiWExlhWiO+azpeFYVTZhzjZ6kiNxpW0OHbfe1wrZL6ImLszzQw2tuYYYAxm13T6fTLF3vU2ZaGzgFGb56LFEDgcgq+jR0WgBX8I1EHFGzIeyk4xRVyZYVKPX/cHomgXvDHFGTw8wx+AmKVEGaB27t2hD0gURfNJO8OOSRLU99aE3zOjpDexe8oyMcq4CA0pDiHHoTbZIS+i7fwdLBOcMVo3ulbBpX9EMp7mBwNKcQdTKpEWi1n4Ialmuz3MwttE8Ci4yTIg0jAFi5Xz5WJev8LkRXRBNfgo3tAtcU21nfhgNr2ZYmDrXM9RsbfUsLM8Hoh0x4ehP35/IYLrZrX5wQB7mWuta+sV89lEjzoCMv1v6NQo0KVjGV1lrFtX/4R1MqsVX3IS5Pml3Yh0Jm//ePlvQ9CwqrESvDYAXWOspboKP+OiTqhII1US2mW4y4lIGbTx+D6ebBTvt7ElBJu1LOSiblqflIKhQHS6q9l/Sv/LBVjS/otZs8MFxt0rEb8VeNq6ZYckhkyXk3wMF9WHZczgYaRbpXWqIO7CtEXuFUJDGvi5JOp+fUdLkXUxBLFCFu8zD2qkP3xKGMvcy8R+fKehtnUTWKVxWRmdQqSLKo4EOXQC2GHwV06XzcBD5McLF05oFSJUtK9HMNRsMQn2kBURIA+0LU/9s2um4E6TgjfVrWHLIJsyunH350FlD6alOBdd8Ycf6InhbwiuRfZkO81pUEVIrsxr06jy0+IHoHHU8OFw4EkZTS9xuGt
 DLk5FN0N
 JHPCRNCtp4ZXK4OhRiRPYO5LfiR+RgVn6hou23xUja37JaVNetzgcoDqagpayKCOaqB21D4KtO/MIibNsMIkINIh5oepQjeP1NeD+vV1wSBqHmieTz6gg0rGfht6qEvZO4kAgNRJOCODAvKnPlUjE2RRY/kdvT88pG/fHFtl45LCAslMJ4UtWmQ0ZS3XgXdWkcmimQMqUX/aPsIyOAvmq2na8F9FKniSjEWvS8QbNk4UL2fSrrB+2FEnjrl9Ujf5F/tZeAxDylYbSVP/9HiwyURRcSgLoQhlD98X0ejCALRvyzVKZ0UoHc/etDuc+DZASgftAeXUYAPidchBD3QXFWjPyKIvkVjcvG0Vd0xCsUnXFaixSJ3c6GLjasc03efrIq6HBRINz6PotDlfiUJh5TGn/bHladLX+S0OcykUXw1Pm1ztxnUSfjlL86G4oUIXHRcFjLE5ePqGxI0y9i/zotbZu4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the persistent huge zero folio read-only
in the direct map turns such writes into faults instead of silent zero-page
corruption.

Add set_direct_map_ro_noflush() so mm code can make a direct-map range
read-only. Use an address-based signature to match ongoing direct-map
helper work[2], where existing page-based helpers may move the same way.
The helper is direct-map specific and leaves TLB invalidation to its
caller. Architectures without direct-map permission support keep existing
behavior through the generic stub.

The folio is allocated and zeroed through the writable direct map before
thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
from hugepage_init(), which is registered as a subsys_initcall and runs
after SMP initialization. Stale writable kernel TLB entries may therefore
exist. Flush the direct-map range immediately after the page-table update
so they cannot bypass the read-only mapping.

Treat the direct-map permission change as best-effort. Architectures that
do not implement the helper keep the existing behavior via the generic
stub.

Inspired by Jann Horn's read-only zero page work[1] and follow-up
discussion[3] with Yang Shi.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/
[3] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 include/linux/set_memory.h | 29 +++++++++++++++++++++++++++++
 mm/huge_memory.c           | 16 +++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..e83ced6a3827 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -40,6 +40,24 @@ static inline int set_direct_map_valid_noflush(struct page *page,
 	return 0;
 }
 
+/**
+ * set_direct_map_ro_noflush - make a direct-map range read-only
+ * @addr: start address in the direct map
+ * @nr_pages: number of pages starting at @addr
+ *
+ * Make the direct-map range starting at @addr read-only without invalidating
+ * TLBs. Callers must either ensure that no stale writable translations can
+ * be used, or treat the permission change as a best-effort hardening step.
+ *
+ * Return: 0 on success or when direct-map permission changes are unsupported,
+ * or a negative errno on failure.
+ */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;
@@ -56,6 +74,17 @@ static inline bool can_set_direct_map(void)
 }
 #define can_set_direct_map can_set_direct_map
 #endif
+
+#ifndef set_direct_map_ro_noflush
+/* See the comment above the generic fallback for the _noflush contract. */
+static inline int set_direct_map_ro_noflush(const void *addr,
+					    unsigned long nr_pages)
+{
+	return 0;
+}
+
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
+#endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..4425ae5560cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,8 +40,10 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/set_memory.h>
 
 #include <asm/tlb.h>
+#include <asm/tlbflush.h>
 #include "internal.h"
 #include "swap.h"
 
@@ -932,6 +934,8 @@ static int __init thp_shrinker_init(void)
 	shrinker_register(deferred_split_shrinker);
 
 	if (IS_ENABLED(CONFIG_PERSISTENT_HUGE_ZERO_FOLIO)) {
+		unsigned long addr;
+
 		/*
 		 * Bump the reference of the huge_zero_folio and do not
 		 * initialize the shrinker.
@@ -940,8 +944,18 @@ static int __init thp_shrinker_init(void)
 		 * that get_huge_zero_folio() will most likely not fail as
 		 * thp_shrinker_init() is invoked early on during boot.
 		 */
-		if (!get_huge_zero_folio())
+		if (!get_huge_zero_folio()) {
 			pr_warn("Allocating persistent huge zero folio failed\n");
+			return 0;
+		}
+
+		addr = (unsigned long)folio_address(huge_zero_folio);
+		/*
+		 * The folio was zeroed through the writable direct map. Flush
+		 * after the page-table update to invalidate stale translations.
+		 */
+		set_direct_map_ro_noflush((void *)addr, HPAGE_PMD_NR);
+		flush_tlb_kernel_range(addr, addr + HPAGE_PMD_SIZE);
 		return 0;
 	}
 
-- 
2.47.3


