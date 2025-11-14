Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0416CDB475
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0328E0010; Thu, 13 Nov 2025 22:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91928E0002; Thu, 13 Nov 2025 22:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE32A8E0010; Thu, 13 Nov 2025 22:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BCEB8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:00:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39A9B160216
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:39 +0000 (UTC)
X-FDA: 84107709798.03.FD8BA15
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6C5FF1A0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:00:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sxv6FYy/";
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763089237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=h5w6+LZgoR3alv7dlBy1EbbCePfXsTLLFM+wNm5NoxU=;
	b=M8MLmKIpod/mZftm7O+tgQ7EqRe0lYlzl7JOHeCwKQhQdVB0pDg2LfxktKQUABpkUCRcUA
	Vvdbtz+VAXub/8ObzBKGSCNTzAWdT1GKypcf5dhTqoqUkSogJG2LxRNpNwMO2Wap00E8+e
	G/SOvs3Cw1aIMjDOFdH4iK5eBRetBxo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sxv6FYy/";
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763089237; a=rsa-sha256;
	cv=none;
	b=LBVMGpqT6T8N0ulU5cxuSvxU3fcERwGf11cSZ/zV+vWf6SO664AyNF0rsysPZMIchcaRqP
	QwkPLm6spNnayRCyjEEpwoY3zGoxgUdB6z+6+0Azg73i2GgW6poFKWisAcEof3SY1F0bUJ
	0l6W9Xd8QZpNpDRP8F8rds8FWdzkZ7o=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b736fca06ceso4072466b.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763089236; x=1763694036; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h5w6+LZgoR3alv7dlBy1EbbCePfXsTLLFM+wNm5NoxU=;
        b=Sxv6FYy/BqIgAMb74rLkBbzJ6LssNU5MtEnLVmFa2qGaVRKtZBmwTjNJZzd/RbJDSW
         O/qig5JEkfXno8IhwrGoVGEpSx6e182Gira4W2c06abYItyBMoEqrrin8NliuLQHnv/n
         P7D2uNd6ZLDoQQZalIlOSCrGeLjuOg4sRpfxKQkGW5V3B56WlX0bFxeuxPuZOaJhfuCo
         UvjzAKkGROhvcD4YxqgxIWopKUYkvzTfex+TwKHyrS4frTSH9fWKf/vPzxjoIADBHsh+
         BfodC3ja1gIJ+zW4qlHOsNAVC7fXZe4Tl8fnQl7h/4k5E4SZAXTKDqxVCQq+jnOroLE5
         DVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763089236; x=1763694036;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h5w6+LZgoR3alv7dlBy1EbbCePfXsTLLFM+wNm5NoxU=;
        b=vY91BEpbyuPKUXqWjLc1jmoOINjySOoRZyvLGdNAnrHLJKJ5+AF0uO23GIrBquvrKl
         KQqykI3AfURgo3zRwSnJq4AOEg2sizyNY1uFwG16L0lO+F2vhBsTgqAFV8mBOpeb7QiG
         hQPiuJLgdYI7tBWa6tbL/b5v5gJN+aJqKiujqbTiT/8/WE4KfG7fVzU1SWMl2p3dKbAm
         SbnpoLTBOgqBl6YaEESEWuBLTsYG+o/7h9uguHydDFuXYpEXXCOiBRkEiqh+ULQIe8Xn
         bl2b74L5qW8I68jghT1HbxOytLERWU1XkvUKWvojlo0OJ1Jjk9UvOH4LLv4ccuAKUPCO
         d2Sg==
X-Gm-Message-State: AOJu0YxQkSi4RTIF8YPD79AlPGnZaELc2FZuNwQk1U0h6X3lcKh9X4+c
	gKgE8H6rEOCqwiMa3zcIIZX2Aok67vl12qR+JyKvRsNvkj96qcNG82iO
X-Gm-Gg: ASbGnctHKZ5EREiZ147sk3auH0MuvRqfP4lTjRXBhbC/T+0xZDvD4IWzAocuKmDe9fD
	FqrxVCYlONe0Z9zV2I7NEE1fQ5+Htt8oZ0L8oJ+EOfEFUrRJTqD7f4i4H5CUGbmFGuQlEgYdetR
	PGXGxG2w4EqvAM04V/FpyvTbbRpnhI+Z8Xe3RWM5uni9gWkoodq4GrWCgQiP7yLIqEfrouRUbOu
	OCPH+1aAIG6qrReLNXf2wjUjNK5MiBDY6pCp6qZNHDmP63yfjIxFy1FsYf5Ol+eJlVec9JWN12e
	z3Vg8asKPygmWlUecQtMs9QBnM3uL6vavJErfGhSO9bksCNY3OJKk05aHqAgrhbyYy3BAg9QHji
	k3oExMZITBrHlzdx/4aLis6HDibSVUk+pmNB8USDzdSUUDo/3zdBG8J4ago2PNioRfOMhiKplAY
	CBhfHG+qX2ZiHrRf+7V7/TjnIN
X-Google-Smtp-Source: AGHT+IE4uc0kIaZtRBQYGaQoH3to5Eg9jPzvbBDhGlfu4MuOMb2Pfzzzpg8Iz2AK/9zDwCCU/PsgyQ==
X-Received: by 2002:a17:907:7f9f:b0:b0c:b51b:81f6 with SMTP id a640c23a62f3a-b7367b70208mr138486566b.43.1763089235827;
        Thu, 13 Nov 2025 19:00:35 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd80a20sm288456966b.46.2025.11.13.19.00.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:00:35 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 3/3] mm/khugepaged: unify SCAN_PMD_NONE and SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
Date: Fri, 14 Nov 2025 03:00:28 +0000
Message-Id: <20251114030028.7035-4-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251114030028.7035-1-richard.weiyang@gmail.com>
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C5FF1A0002
X-Stat-Signature: f3w8mt11djt7hto5d6u5wohnkfg5ktd8
X-Rspam-User: 
X-HE-Tag: 1763089237-144781
X-HE-Meta: U2FsdGVkX1+o8rhv5a2heJyRjm6N3Hd7mYPd/6pOiBkfj+E5Fz4gnN3s7lVElSXgnTmMyVHHzzM50qeOb5OQp8PKjXNoc/C3rTS4F0I+dHJJGAtKOvYubrmFtb3U0zcQY8YjwNcJc+0nhDacGLx4Qiw5i7pfz2L4QIc2TR2xKs9NrXninue+x5iVHS1ufAR9EPP/C9PqhSeKQD/tx97W8wKv8Yz5xxZspygYTrpuAWRufIWOha5zfvzbI7pjpM1jkWuY3ul+2qfjvGmckf4KuHfu92r9+3MnmHiY1cZqNHF3ODeQ+f2ysyGE0fa8+RPwKI26LiA7Nh/Uc4xWuKtkHIQT+1x2hXYeRIzwP0IjNW39FbxH2il7Db3TbiYCCzfHK/OqGsZ8wGQsQA/Zu7eh1U3MWUoVYLebv/AuezhQ9UMtAzs6MvyLoEyzPtMw404iSCflpPfvfnhn99A0SqaF3fl5DukxgvMxMZ5aaBnfB8ec5UFUj+v1NIAD6Z/fyoQDu/3tk4D07uKXyGPxpkKNvK3mVH0K5wsBdEoEkqdPoqoAEvDavWH6S3iagez0HjFYiafaCNgf4EwWpB1GwT1ha5GTOrZLG6wFUpSfgBEPR+ypsEykbfMWoy1tn6T/acupn7fvb1fY8Pgo7QxjCcJHMDnef4qAF6SygTEc1vQmAZRxTkzHQnfR3mCU2SKLOPymfsIIQUN2fpywMeaHZmp8dnmDsm0kbbppI40eGthBR2JaqULyFIkLYPfKi5ybAbBUMXQpn6lJgmhj9ofCS/X0Vgn7QZvxWzd8opcsV5om8N3r1oVcxMaFsqtXHrEiCr6vcrJQ3VfdHfXsjU9aRsiH4J2IeTVyCo7PG4pBjEDL3pBAp0Ql8HEYG/z8rqcjibKpFQ1VWpluZtHk5YF3yLBXzJkRVs6qRVzdyoLZboe2rELVZCL7JzjzCbSMbcmr8DFBxs+dtTUbhRNcif7+2Fo
 8p3M7cYm
 fxipiJzDluuZPv2ASXcSbOPazxUqTjmj2udJpFQ6NxEhpognKKJFtdUEc+WAt2dplXuUMC4qCEvARgQMgKoLsaVrUY2iS7buC4TYrp6dYjqYnk+6UGdLPZfpUZ3ec6V4yGr9paGe1ZAhW8VCr/G9xPWBVEmgss19R6sCtLjqDnnyDFwTQ8qm36MiSZ7GREDy4n+ujRSbom9gCRq1eT7RTau8njtdL+cIRYxJkVeX68n0Znkp7yOk1wkPlq9SxZWBjckuQ6CEugrzBh6DJ7vVUVksadRmmtOsL+T4+Mu99cKO7Bbo5UhAS2SOHyijaEgZqi+xIUXFV804pF7qWo+10bFm8cxdbyNTn5COJQUWNslMfRkfnV1KR39NTddBBQ1IWX7qE2+I99hOTnm9LKnOi55k3xI5fhrgkt4tl2gJcrK8N+1Um6mxZOnssRkx+rJjdd2LKL9pNSKbNMJjFcILvYLiFVRoRBez++ILYk781eMj1T7RLcjGGni7pZkj+F/cOaXli1zHAURZme4CHvCK0fQ9e9lLzAdRs0UGcJCcTswR6AenUTQc7Q/E33KQ8yGN3nxnvlQ7BuArsvjTa7Uy84mXKISYHbHXUCt2x6T++cuq9abQ7JjqJWAI6uXplz1NmGN2p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current hugepage collapse scan results include two separate values,
SCAN_PMD_NONE and SCAN_PMD_NULL, which are handled identically by
the consuming code.

To reduce confusion and improve long-term maintenance, this commit
merges these two functionally equivalent states into a single, clearer
identifier: SCAN_NO_PTE_TABLE

Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/trace/events/huge_memory.h |  3 +--
 mm/khugepaged.c                    | 23 ++++++++++-------------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index dd94d14a2427..4cde53b45a85 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -10,8 +10,7 @@
 #define SCAN_STATUS							\
 	EM( SCAN_FAIL,			"failed")			\
 	EM( SCAN_SUCCEED,		"succeeded")			\
-	EM( SCAN_PMD_NULL,		"pmd_null")			\
-	EM( SCAN_PMD_NONE,		"pmd_none")			\
+	EM( SCAN_NO_PTE_TABLE,		"no_pte_table")			\
 	EM( SCAN_PMD_MAPPED,		"page_pmd_mapped")		\
 	EM( SCAN_EXCEED_NONE_PTE,	"exceed_none_pte")		\
 	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2ee5048b764e..40f9d5939aa5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -30,8 +30,7 @@
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
-	SCAN_PMD_NULL,
-	SCAN_PMD_NONE,
+	SCAN_NO_PTE_TABLE,
 	SCAN_PMD_MAPPED,
 	SCAN_EXCEED_NONE_PTE,
 	SCAN_EXCEED_SWAP_PTE,
@@ -934,7 +933,7 @@ static inline int check_pmd_state(pmd_t *pmd)
 	pmd_t pmde = pmdp_get_lockless(pmd);
 
 	if (pmd_none(pmde))
-		return SCAN_PMD_NONE;
+		return SCAN_NO_PTE_TABLE;
 
 	/*
 	 * The folio may be under migration when khugepaged is trying to
@@ -944,11 +943,11 @@ static inline int check_pmd_state(pmd_t *pmd)
 	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
-		return SCAN_PMD_NULL;
+		return SCAN_NO_PTE_TABLE;
 	if (pmd_trans_huge(pmde))
 		return SCAN_PMD_MAPPED;
 	if (pmd_bad(pmde))
-		return SCAN_PMD_NULL;
+		return SCAN_NO_PTE_TABLE;
 	return SCAN_SUCCEED;
 }
 
@@ -958,7 +957,7 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 {
 	*pmd = mm_find_pmd(mm, address);
 	if (!*pmd)
-		return SCAN_PMD_NULL;
+		return SCAN_NO_PTE_TABLE;
 
 	return check_pmd_state(*pmd);
 }
@@ -1013,7 +1012,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
-				result = SCAN_PMD_NULL;
+				result = SCAN_NO_PTE_TABLE;
 				goto out;
 			}
 		}
@@ -1187,7 +1186,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 						      &compound_pagelist);
 		spin_unlock(pte_ptl);
 	} else {
-		result = SCAN_PMD_NULL;
+		result = SCAN_NO_PTE_TABLE;
 	}
 
 	if (unlikely(result != SCAN_SUCCEED)) {
@@ -1270,7 +1269,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
-		result = SCAN_PMD_NULL;
+		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
@@ -1544,8 +1543,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	switch (result) {
 	case SCAN_SUCCEED:
 		break;
-	case SCAN_PMD_NULL:
-	case SCAN_PMD_NONE:
+	case SCAN_NO_PTE_TABLE:
 		/*
 		 * All pte entries have been removed and pmd cleared.
 		 * Skip all the pte checks and just update the pmd mapping.
@@ -2832,8 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
-		case SCAN_PMD_NULL:
-		case SCAN_PMD_NONE:
+		case SCAN_NO_PTE_TABLE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
-- 
2.34.1


