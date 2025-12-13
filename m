Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA0CD59F6F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24256B0008; Sat, 13 Dec 2025 03:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB026B000A; Sat, 13 Dec 2025 03:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA596B000C; Sat, 13 Dec 2025 03:01:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1386B0008
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:01:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50B581A04FC
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:01:14 +0000 (UTC)
X-FDA: 84213702468.02.981BC32
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C84D16000E
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:01:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf08.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765612872; a=rsa-sha256;
	cv=none;
	b=TOd/PY8NLKDlzTBaumesuelgkI/ng8WnZPEo1pSDq6fzUZzKDNYhrpoiIKUa47OhQznRsm
	Us7O6d1gjOW+BLDknmY/4S69HnwET6ihmO5gTZACfF2XOCpz0A6ngAUnUXQJl9EwOEf5mG
	e6dE0VlfJZ28XhEP+VTdXaVSKWmxMG4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf08.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765612872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IKeRxMOvOPVkMEpeJrhYXUzwhdbko1M2EXmC4O4D0Xg=;
	b=TyC6PuATGieGQt+8dCd/NUx8yIf9kEVaCQhm1mZRNsDDJlLsR8iXZCSnKgYsnyKS/PRAvB
	awTJZ/gTScTkYG1jbPMVBoXvv+SZaamf0oQFd/fcR5HVw/AQHQSOgQzmlVXoAP2mE4mjR6
	I6QfqjhtQSr5So11Uw49JRgKGuTpfKk=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso7954225ad.1
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765612871; x=1766217671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IKeRxMOvOPVkMEpeJrhYXUzwhdbko1M2EXmC4O4D0Xg=;
        b=Sx4DxPfajBSFnot+Os/epgkyPNjfUpKpAG2zhEQF9S4ytRIe1gIjuNQyGe7bz/bKZl
         cMP6KM+D4iS3r+bPuVPKIIOdHsybxlHq+00T/ztLyqB+eUyG+d81a7wRAmuKrT6YtzTq
         BpT1mJ7+QKDtaZiPkcAiyizm/AkzgID3ttVK750iFiA1cNR8rYt/xSz+FoMjeUs9sih/
         sbMZ36sIdLLhc9p7jOS2L/P015kcZ6f9gbJvF9PVld2ZpfaUz8Wr/CKbJ2n5kjhw3T5s
         ezvVI6cFzdT7a5kcq4h4Nm4Frxk2nTipCWCspPe0RrvRqKpS4cFg68eSOOHq0g2TLIeu
         CX2g==
X-Forwarded-Encrypted: i=1; AJvYcCX6OWocb2EpfvNfJIZiH7WXnIlcL0VkmLW5Epwq/XzYK4N0uKwftr32AtJhVY1NVEMCBo70Y1oSDQ==@kvack.org
X-Gm-Message-State: AOJu0Yxk7GbxDTPcD8O6LJwv+2tAR7w8ehvtH0lnSNv33d/amto/WNvU
	rNy2VGeoteOQyWfZEZHhA6U1rzFodxUDw+Q3qK8FD7yTR6qQGDZk18mT
X-Gm-Gg: AY/fxX4MyP6l5tvE0WfyIAQb2BzDS4LWfHsHYdvwGWugVYeEHznviqi8hJ9WQoH6myV
	+2mr92gs2B0OttVYXhmLtL10kRbuFyG6ODys4bsgL5KTlbSwKofujKORzjZZiZ1JvGVvyDpzW/U
	YTjr+Q9m8XpA0GloUABcTANA2dkB/AEqbsadkfi+3kvPklEfdMTrao/psRC/jnC6nbBfQs0BfVZ
	N/wCTJ9fgtUpkufCq4n0PfeUSIgNlqVhtKxgXfviTGiwnxA01HOMbnLY4ro2w5g2AFtXii7IkJS
	JFcBZtc0I3vJTEpNYKiywXt6m/GdBOz8JPkEAu2cc9b3SsiCItY8NrX8WeQZHBYgjqZ6jYf6Pcd
	u4c3OR7URs+799d4r2LNclov9E+wPxwDhVtU1KoqKQzrGmG4fY1g1MgCgkCJOuZEImYt3oYWWsm
	9q75gvuHQF7aEHcX8WEjbWPsoR5w==
X-Google-Smtp-Source: AGHT+IF+7XHnXgrhyzygY7I1rYSWeg9b2h4e3tV2K6rz3wu/Ladawz1GxFoLm3IkAXfgeDDX1CPE4w==
X-Received: by 2002:a17:903:8cc:b0:297:f0a8:e84c with SMTP id d9443c01a7336-29f24386514mr51433605ad.52.1765612871142;
        Sat, 13 Dec 2025 00:01:11 -0800 (PST)
Received: from localhost.localdomain ([45.142.165.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f05287fa3sm53149155ad.5.2025.12.13.00.01.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 13 Dec 2025 00:01:10 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC 1/3] mm/tlb: allow architectures to skip redundant TLB sync IPIs
Date: Sat, 13 Dec 2025 16:00:23 +0800
Message-ID: <20251213080038.10917-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251213080038.10917-1-lance.yang@linux.dev>
References: <20251213080038.10917-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C84D16000E
X-Rspamd-Server: rspam10
X-Stat-Signature: 7xyhzckb1porsqhre69nq86i7fcbxzua
X-HE-Tag: 1765612872-749830
X-HE-Meta: U2FsdGVkX18dsq0BhxjxJDoF+m8WzaBmhtP/OIT0UM6kjrzc4ELzqWWI4GQ3Bd67x6bdg5fEt1BAVcFZoO1IpuxJLFRrweHl0FvVCLznC9hsT09g3Q/m14JHurzo89ySK4+rNo4psiIfdR+o0Dyu7bdvkK3cGxaJuHtBAzOkmEx/IAiINoR1Iu0uiwX/sIwcv8P2k2ub6VfPqG7lmfVItlqTOf61LUUkhZVPfKML3/FWZO4PKUiTJVUU6Ehkpj2GvFHUTdUfSEuFpOlAXuKmx96fa/WqSqr1xMsdna9YaU6EBrFTKqj+jHM4bEZzZ9pFwZgatMx5UGnAPWCJ7NzjWicxGoSNes4W7RXYuYrklDCxri8ynYKA/1T2OsyKQxBKbhQT8Bce0S5JziVybEHFLctJEc+JpXSqgsf2M/Nwx846XJTGS7R+TpA4KCo5jevLmGcet/mRWDo/g593WPgVPg9+MDUFvOuvKilelL5MCHWVOHLGjVqH9yhPJTrxcFJkBqfTK/9IidNotARbvkEeGjepucReUZI+ZGkggHK71wG57LbUEO9TsHq0RjzdGSX/pys6Japcyt1zLL9jqjSQ2bsTyD2o3tglN0D7KJriySCLfZce2gybuZkw771CXXKE24Dke6+j1MDq4jNWVJJzFsQvbpWBEufsw+PSipOAUL7vqxcflcYPaa9WWBFj08/i+elsR345CeW99vhl4XSmo5+uHCVp9zNmmA+7EDsXTPmisCRIKveOBodAd+M/ATKRnGp/K/vXyG8Rz08PBM7ZvIsbqWk6fdoyMO87qlJMS56O2wYwDaRVfZXYtQ8E7HL4CHCTyI9EeDbAVRTwgIsSJpd9OInXpBdPYoNMxbc9CjSIx+g75mpTetAAyUDTp+tbQNhknDrT18T1e7dlyeP9QoNLH0jtzVlYgAK6aKBbtVzDrfbyqBh7j/7CXuw/STvo2ZilnT8PfA05Nr36yTY
 bUvmT/31
 zowzX+3aHq2BbgS4QUcDbUYEP2zNFXGGg9EONRUF8pFd4h8LLaVaDAschoz+jZOgv4loWS2BxDiSkx9wz961777okI4EV/qHchbS5A5GVMT1Ku9u+bG1RbUr08zKM3CueHTvxjArxYCUIQzKtt6zFVp60+N6zJGN+onYyY5xcYNuH+1BlcsJwOdDjqH0ZUD2sVR8duvarYTzJBkFiYrdEYJMKm2zSlZ3ISaKRseCJ2fffZXWpTOQeBL7CfYR5ojJ7D2w8OioW53L17ZdYPpKlJs6IvQqKNrABpTYpsNmLSoXc0bts71CqASuRVWP7PB9etVDAfmX+5BpUrmvRBRGqBc6d1YUjn7NUpPMps4xUB9hkxxo5/16WzLPA57fcpyt5O3G2AFNklh7QCe8vDCjk9I3X1J3pqQKw+FmskXL3kdqJmQGejs9RDIkn0jAUGmvCr7nC3lA6WZq1ezesrZ9MB1peig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When unsharing hugetlb PMD page tables, we currently send two IPIs:
one for TLB invalidation, and another to synchronize with concurrent
GUP-fast walkers.

However, if the TLB flush already reaches all CPUs, the second IPI is
redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
completes, any concurrent GUP-fast must have finished.

Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
their TLB flush provides full synchronization, enabling the redundant IPI
to be skipped.

The default implementation returns false to maintain current behavior.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 324a21f53b64..3f0add95604f 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -248,6 +248,21 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 #define tlb_needs_table_invalidate() (true)
 #endif
 
+/*
+ * Architectures can override if their TLB flush already broadcasts IPIs to all
+ * CPUs when freeing or unsharing page tables.
+ *
+ * Return true only when the flush guarantees:
+ * - IPIs reach all CPUs with potentially stale paging-structure cache entries
+ * - Synchronization with IRQ-disabled code like GUP-fast
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
+
 void tlb_remove_table_sync_one(void);
 
 #else
@@ -829,12 +844,17 @@ static inline void tlb_flush_unshared_tables(struct mmu_gather *tlb)
 	 * We only perform this when we are the last sharer of a page table,
 	 * as the IPI will reach all CPUs: any GUP-fast.
 	 *
+	 * However, if the TLB flush already synchronized with other CPUs
+	 * (indicated by tlb_table_flush_implies_ipi_broadcast()), we can skip
+	 * the additional IPI.
+	 *
 	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
 	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
 	 * required IPIs already for us.
 	 */
 	if (tlb->fully_unshared_tables) {
-		tlb_remove_table_sync_one();
+		if (!tlb_table_flush_implies_ipi_broadcast())
+			tlb_remove_table_sync_one();
 		tlb->fully_unshared_tables = false;
 	}
 }
-- 
2.49.0


