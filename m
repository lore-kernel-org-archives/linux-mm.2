Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA7ECD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A274B6B00F7; Wed, 13 May 2026 09:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF206B00F8; Wed, 13 May 2026 09:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914406B00F9; Wed, 13 May 2026 09:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81E996B00F7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E4D286EB4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:32 +0000 (UTC)
X-FDA: 84762458424.12.173D41B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 54B1340003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=L5xOp3uP;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PXFCj0/ECPhuZwScmmiKfqjkOg4F11/Y6QM4pfwtxE=;
	b=1xWMifLy9NcZYI/vFy0VMnsIjKyYqs76P2beIH5d3TdEO3dRObtn7e4j5QDaPbSrmD9yuf
	LjjOd7pHOjaCeRoFlIbLXfqfIFNxuflXtv5ShNILvmPJSU5fKfvvGL7tNuhR1K6MrGbUdj
	d9qbqQtrjru5yTlqePd9+K7IGn9Wj7E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=L5xOp3uP;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678490; a=rsa-sha256;
	cv=none;
	b=5+sh96V90kvgiinTAL9SWdekl1BpS+jVX7m9o1AVp3FnbU1qmPLTSkzjWd2X5O0f8EPGFt
	DAon7lwo2yf0fJ2rz6LC92SqvITGQB5oZCHcNZOh18IruDV3hcWvykXSRUj6s4adQtVZwH
	W9tKvh7KRSlSMvX8bX7VUo1xFX6jAww=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so4150564a91.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678489; x=1779283289; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PXFCj0/ECPhuZwScmmiKfqjkOg4F11/Y6QM4pfwtxE=;
        b=L5xOp3uPQOpNVBXTGmbCrwMjgfZSjiFpFDXNhw3b3ZKplSspBbQ6VnSy781yeyZE2N
         V0zXkDzOwHXF3rc1Cx/Uf1tynzv+s7sHXOEu2yS8L0eZ6U+z82NAEMdl5RZxDnC7ztvQ
         zIC8WZFOWJeqTaRc9pfOLACYB/nkIEhRuSrb702v3oXFWPnCNelIJ53P5lQryxc814EQ
         ODRbB6ulBcX0g47hObSuQAbuO/KbUqZRZl6FCw4jEAXGXKlE6ZMMQ64zjcNzWp4MMv1M
         jDQgOH7lMsAEZY0cNvQsUTHEpAOVzxs2CwV0SsVF/OkSTEAbYdDfeaszJyKhQlS8LbeK
         exmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678489; x=1779283289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3PXFCj0/ECPhuZwScmmiKfqjkOg4F11/Y6QM4pfwtxE=;
        b=mNQQIIyB4MbOjGf5vmIRZ4hYOsjRZWTccobZxq0188/KPeYom/7wjaGlY3+huMVG3P
         FpD6E+7MB6Y1Y8YjQ7SpLYZ9Eq91/8b+E3x2rqOpl2cU9aUcEZCESUALQOywGMVpwuY6
         KWy7BfTxTp7CCTCDApGqBIJ8QI8GSk4gMdycsKVBLxTcb/u1Ay4/0bOQIm0iOT4QlL1r
         4cXw6L1csP3b6OMZZLVgbXZ/XeX08TUrwzayUFiVr7r+8uSeC1xKaAiXL7Bq9A5qhe17
         AFGk0q+rgr01mAkv/g58f1gxXN8Fo7OZyKX00t4xOJuWMmuNUBP1xv7gbKfcUerG76ke
         j0/g==
X-Forwarded-Encrypted: i=1; AFNElJ9jezcccp15Djy65ScZmMjTYoOKHiuaP/Ns3N7RNxbEsMRTxtnm4751Rl1LLgshYk1myxv1Lwiq+A==@kvack.org
X-Gm-Message-State: AOJu0Yz34AJtjcvWaeDddPqAzQmmBtrpJ2lD+U4mWlW+TqLddaKaL/xC
	nzUvhMTCZjr/4nVBoi0hHS95yhlXpiUxyE0dGbT2uOIlxAnJ9pR9PLJG+5k7PrqkFCo=
X-Gm-Gg: Acq92OEs6DiVBFjfpsGd3zTftbc/eASQNoTRFbe82L1brz6NTC0nDZgVkHhWshcqjrl
	3ubuT2+CgaV61H9c/8oO4CO/SqRecGSy6u+3MJPlFENR5Y9TsaEs4KJ3PyZawvjZTNwjwRRsLZv
	PXCLJ2IAZiy1iJ7ua99RpHT1hax4FIfUQ4ikvtyYNEFeLFoPFukN9eknL/Hrw/NUNTRbvhBmhay
	YMhsCoMkT2S3WjiPV98S7KEM5V05KNhnS4OHZ0oI/ZngChwpIbr/OvoHsvFv9emEshJHDGwmZwl
	yKQHSlY7ijuGakDlKz9uQy1mZcWH2JvcQ0PL375ML2oIO3P1Txp5CiJCu7UDyWec6gmalcWRQJ6
	A5D7NUpofPUX2j1nUB+H9YnA8Jkq+jv4uWkCqzB/Jj/zymf6fk72En7ED1Mhegj1JELAtIqLQvh
	d86vl9bJ0Py/sdyyWOuoACjBwzHVt3jmPqDPpzuQnGdkFk6V5S4IVUI0awOYbH
X-Received: by 2002:a17:90b:1b0d:b0:35f:b5df:453 with SMTP id 98e67ed59e1d1-368f79cd1dfmr2775567a91.22.1778678489114;
        Wed, 13 May 2026 06:21:29 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:28 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 52/69] powerpc/mm: Drop powerpc vmemmap_can_optimize()
Date: Wed, 13 May 2026 21:20:17 +0800
Message-ID: <20260513132044.41690-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p5t6ktn8uz8dfs6ydsbmzgdathai3mrx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54B1340003
X-Rspam-User: 
X-HE-Tag: 1778678490-521456
X-HE-Meta: U2FsdGVkX19bnofhVjeULsMQ8MTDNnmz5tna+4hHnG7vwIcbfA9ENo4XlhpSFADwQLZynQccRifY4jddSOcaRVxihNheAGQbRpXk74NK2AADkkKUKqcizn2VZ7cMlcUJ7hYNVOwqMi+2IAkQvjeKgRFUI3m5mh8rzKP7ISn6nfxRp4xgbodRwVj5ParxiTA0vBdzLDOpY0O1gwcTojZoFnJlBJmO8565CMDgI2UqvC+cMduldemlkOU80NxWyJDJIskMBEvYmM8oblUNMDTYrKDziGe9cpS7wgH0k45Mn/thRcA09kI1/tKX3eKujZfZHJMrgbZOIqWXTybfa71Bwo5aIV2cnu+TNxpA/xhPDQj/J/dx/6E/fPtLGPs0tf+If0B3kcC9aiGCuYMhlq/yDVxW3SGuK0yOShDA9tpCnvNFKaXgAQX0FzQWLpOekjrxOG1/7IP+ee2ksgK8mEJoID8FsfxTArNL+qJyAwSyDGe9EvAhePMnEcrcZ9xicMwbEA6XlxqjhR4RgoTo0ng4QXKLB4ADtM+2wdPbf3x6nVsaIwFWY+iJjU/q3gqkvvD/1cKnP6RLXUOb0HhKycy+9sVn/fPgqDMy8NPaIjbeNm4bNs7SEuOlnhrDFM2FjTO07QAgdYQnXhuT4hlQmReRL3T0pBKWuo8MjOEoNoVOVnwjFbwOfZ205VjuvEtXdvEjhcqMWDbzubEs7z7hvQHcR09dO4Keree/iQjQBUKzXkaU5QA9hO0ZZ/I62a7P39XJ+w1ionzJHh5AgnQgzQiwVjiUUE+KfbTQZx3TTvIE2QrFcPLGnWH3yyiZxxGtY9ONBWjIVmDL03DXqD8i7nlSpIUuqRFSXwdYk0dktIpCTll0HLHOAJL/9l3x35p9/3y9AtJaQy2HIzm0RReTMsaZrmjC4rnp7KmFcCpIvXh+U9zx4PMrRyCvEow0p4Y2eesFS+wo+CYs4erTglRP/FZ
 AUMIm0qK
 9LRX3uqKMmw3op35hmFLujGLVW6AKzV9FbJ8WHm524rPopxk5qN7XnPON5LXhuOr/NlRhGyQkDpc2EPKCkrgBeRoGhgk2Szop6TkKs9D+tk8T0NB/JtMDAg57WCyeuZK3oSmIHySgnwZwvss2VMQowT6MMLh96BeNjtTyJli0OxTsrf+wy7ax3oU1qd9F6NEIQqnAIU8txsl9lHuqt3fHaQ/mBfhYOaGIdqEBC0RDwLQEuURrwSihnMmd0HE46zYP4+NX7tWlqVVFAnhEpk14jEeVYIMIr7kRqZtvgBPJSdAQgMwYMZQhjv2tiztxPhnkf4YzmQfSi5NnVW7An6crMmprwNDuPZtwrKwF82ze7PyqpEyaV9Pr4/NmdRSvgt/jQkWJ5k18wwUHAPTw6bq/aoRpHGzemmmRILducLAJDf2MHuVnt0dze4/eVeUD1BhNMFdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PowerPC no longer needs an architecture-specific vmemmap_can_optimize()
override for DAX vmemmap optimization.

Whether the optimized mapping can be used is now decided in the
architecture-specific vmemmap_populate() path. When PowerPC has to fall
back, such as on Hash MMU, it can simply clear the section order there
and disable the optimization for that section.

Drop the radix-specific vmemmap_can_optimize() override and rely on the
generic checks instead.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  5 -----
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 10 ----------
 arch/powerpc/mm/init_64.c                  |  1 +
 3 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index 8452a2714cb1..df67209b0c5b 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -351,10 +351,5 @@ int radix__create_section_mapping(unsigned long start, unsigned long end,
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
index 4c3d027c823c..2f8783b3f678 100644
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
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index b6f3ae03ca9e..8e18ed427fdd 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -283,6 +283,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		return radix__vmemmap_populate(start, end, node, altmap);
 #endif
 
+	section_set_order(__pfn_to_section(page_to_pfn((struct page *)start)), 0);
 	return __vmemmap_populate(start, end, node, altmap);
 }
 
-- 
2.54.0


