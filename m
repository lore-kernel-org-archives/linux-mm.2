Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7548E95A8B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 13:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B26D6B0005; Tue, 30 Dec 2025 08:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FF76B0089; Tue, 30 Dec 2025 08:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E9D6B008A; Tue, 30 Dec 2025 08:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 525F26B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:01:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3742BFC4B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:01:33 +0000 (UTC)
X-FDA: 84276148866.12.448FE7C
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06FCCA0013
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:01:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UZVvWOqT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767099690; a=rsa-sha256;
	cv=none;
	b=NcMUveOPDS3I837VEmWCXcrZenxHKEJMScGLMfFLK2k9p/PTOW0Ic1cnViy/Xj4OzAOtUW
	s0H3UprkiN9kbY3K3lKCCqdWMEpKm6KWgZpsl4X06A666ExyLZFs/mGRWhOqO6tJcTocQx
	gb5mryxQjbtkPHrXhaikdHUSdAmBlDE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UZVvWOqT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767099690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sd6r7fFYzeNfF/OtYPN8O9blmmF0Dui4bhsgnnT2woQ=;
	b=LyhkmyCX98rqjDxE6h7/gnGR/L6m8jbYAEDWbEzIhqIGKdRnH0W2GBJ4LUHYNSTEIA/c0l
	Uzt+Y5o4Fski1qHCOl6l7OcOYHYYXmnXHj05MXvysVTKXZ8DjXMDjEUGpwYFayro4c+Hzk
	T/3uBu4vsHTHsUvksKyZtfxHjGVGDV4=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c84dc332cso8552292a91.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 05:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767099689; x=1767704489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sd6r7fFYzeNfF/OtYPN8O9blmmF0Dui4bhsgnnT2woQ=;
        b=UZVvWOqTgD0Ts7XUKk4mJl1QcB4qYtmwmCb4J5um1deHwjYQ4Q4QdxKQZK5HUJDlcz
         PYF4lPIa9I6nDAwPwZchsHiVkRy/+5Kjif5ZA40JTDEANGbn/PG1j7qKt+CSwPR28Oxg
         scjkq3FF61kA757N/n1cnUVIa97H+81q1yeKl7f+fF2jyIiCIhWTnK2kQ433Ao5H6KwD
         nwXwMG+aN3mybHzw4330usr1y2E+pSzugx6pHk/1cRKNXO1KIcnqBrVIFTFyas7x0xFU
         Sdunq7y3RMFfGltAVwGRtOo7OtCxT/a22vcmPTiBTdSWShNlW30TVwGtc1gB3f4c3TeC
         ScSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767099689; x=1767704489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sd6r7fFYzeNfF/OtYPN8O9blmmF0Dui4bhsgnnT2woQ=;
        b=laxeKlPrHfssWVAUWs0eKrLlcdVw9EdMUXsZjFE14DbEiauF3e4kcTsuSN/aoEnvZ6
         9XXvyTOepxdGP11yNsg3PbJ4JCPrEXSHA44UrABUFJgavy8tV9daaZlWc0q6nyy0I6Wr
         XhvQFXUhlt05IcPRFIxBiDFmwnkJ9UKkwqbDW/WOgaShpynMkP/DSjSn12/mc3xLXuqj
         j3b5ptP640DNdNlNF4v0/drKb0mVGN9VEUUW3hIS+BbN6BqUhAd0VAmMhsvQRMYzcgo/
         ZNI8D5Qk988SUuCsf9BXNu7GaUWHc0Eeu5y0DGTYKUCV+MZ2by9KvzGnAThbIRsyISLP
         /aAw==
X-Forwarded-Encrypted: i=1; AJvYcCUeD+2ODxVXdjhUI2dIEU6rteHyUJnpoO8220Tf/BYfbdQ/74+9Tm0n1PhkgKHa4nG2mFTxkoNr5g==@kvack.org
X-Gm-Message-State: AOJu0Yz2GcBcfvRPhlZk4l91q99EB6/X/lFODXpHhzPlL0mpcFEPe8YI
	QO+cC0ByykqDVi4k8JtIqZN4dFfq4/XVqCg3P6penjmg+IhBCbwH8hVj
X-Gm-Gg: AY/fxX7t0O2rkJWIVUq/rWjB1goLJg4DT4tiiTIejokoUJt6C795Z2bCl/ZuPnZ3pYP
	FGekGZiJOyeYaamOHZtXyjWoxwn0XMl4XrdMNoOIzkmAuV9TQAtwkVZCUnveBxCHHtxNn/ARe5J
	C3kIBvREWBbRrlVcp3Slj7QjH7MTZ61AZ9L7ec/MVVVQYMato8GRifZmdpuQA7Rlsk70itMFZUX
	NE8BLQJvjO9SjyuQot1nIeR9U2uow3u3EpbGQRSB1X9laB7A0XOUANjQ80dFZPCSoaUZUtIb29x
	tXJJeN5b4btSKf5wdflchlGnUsoAFQ0x60A4ogiBfpb6pElQzRVwnhS9fBaL6ho1TudzIau2yHy
	8mp+VMbFtkyexnGLB5I9udOIuPWnLktgw8Td4T9Z47W+hbcMS9KLi8Cs7WY0kBhrcJAzNTyYaYq
	DV0E8CJCxkHGExyRgEa31+2RwRTM1wM2jt/gXQ/1SLRQI44ttEAA==
X-Google-Smtp-Source: AGHT+IFBhVfd3ImkbRQ1IloGsWBUgFU5Df7h5cqnuIbTMvarMUXtsFQQeUiFKUC5r40L8daNYaG13Q==
X-Received: by 2002:a17:90b:1d83:b0:341:2b78:61b8 with SMTP id 98e67ed59e1d1-34e921a3cb5mr28705610a91.20.1767099688601;
        Tue, 30 Dec 2025 05:01:28 -0800 (PST)
Received: from DESKTOP-LBGNL84.ugreendc.com ([209.146.12.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d4f887sm33584130a91.3.2025.12.30.05.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 05:01:28 -0800 (PST)
From: Wale Zhang <wale.zhang.ftd@gmail.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	ziy@nvidia.com
Cc: lorenzo.stoakes@oracle.com,
	david@kernel.org,
	baohua@kernel.org,
	matthew.brost@intel.com,
	linux-mm@kvack.org,
	Wale Zhang <wale.zhang.ftd@gmail.com>
Subject: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled codes.
Date: Tue, 30 Dec 2025 21:01:10 +0800
Message-ID: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06FCCA0013
X-Rspamd-Server: rspam10
X-Stat-Signature: uqokzi3dwmkxy9gpirwyezt1csrpmk8q
X-HE-Tag: 1767099689-246274
X-HE-Meta: U2FsdGVkX18UE7IKUESHtalw6oJ6R6whl1on55m23O1MunqSFNU+UNARbcOikPwW8XmRRN1xvIIh7kLztUEVmjChKY5Xy32+BmIgISOJRgqLJG4NRbyOl4WLpPSmzPAfti1OgfzTL4GmxTs2sZoEnmq9P+hFdAq4vmB17OzmPBIwowijaQLNobmDUDilfZ8i/CQeiLJEZ8Yc2LJBwBU/bWhPONomzoq4trtImmzBZ2YagcYHFSF4hEVcZjsK2Df+x5GHnTk64JM/3ClyhqyH6TdgWmnSQhm+F2UsUE66F+OcYHdThsXftC3k9zpwaNco+nb1aD81r8qvm6qa4bMaKaROYgPRO36KSAKifOeePiY1N0LvlNUIdkflP43p1lHoYgmr6ekBcvKd1GIxujvlhF8JOnEttJQp3Lu1bBqa75FcUbT5e+KmzgJerRtBIrAge5ufoJbBKR+9E9NNLB/hJWNzDRVErfjiJf9nPWn8cyjxFZvkMc++iokLtbYTQSJp+X0pEB+vBvMvdstIYYlwGWDhgRid7C2WFguvqrUqkJyWInS0N0Pz8z8jyfNcbDfAynoNYW5AYxLafDVxkcKWrXx/8GXkr/9KNBW4gtd9xfCXrzAee4MTMFm99THcF+MWe7kQRzs1p12rH9snqMvI38+QXuUpPZf/J2YhMiVqQHoKQcEvrXtyCjZ8l015G7aVa1zLDq0IoLobvjQI2jrshBn3TSm1D8W2Fw0bZurcL+fXiLi2HMaPiJth3pgOz4ASnhmTK+h1nhlUXDDQyg8RCh7sR4oTCcqi1FRmr92dHMzGl4mvsBZNXAzePdjNCP2l0BTdSZCjHg69ltMUgkJ1xxWPqwutS2dB5z4EDzFd2pz0duyF6Oj67HfbhF2fdMlTtFM7QOEa2OsEG0/RG8dmPQPAYQbk+1Vb2NNq5mq10SwCbv8lp3W8UMJYN/lbXsg6H/1cPHz9FF0CmD2oMJG
 Jf2eRS3L
 jCJQIgWu4FL9AqL4aeIag4XbtAbyhyUoXN9Up/zL0C7/XgrEcqRjG2laws01Un275PzNkKGDwRmZBxuIUxgdTyu7REyKy6Z4rrW7e5YUzwlqlQ+D6AsAANur6aWaOFmygFtSeHOj21ltGl0zJ+INTqi+Bvcc+hpewlGT/Awyb/ZFducvwp8TrhL5DZt5vCsIwuWTGdnjogpQnWciDGPolqBo0AN1oE5eHLNRTonIzC0ziQSTugr/2G2ZX5RDA2q8biiK6W/LnkGuRGCPulUyEApiaIRJFkA1sQfvHkVSxxXq3f3EjVdSkVdwz3BRlpr+eeF/Ki7Y7VnKqpw7mIC/c2quLqU4vnwG2wxBxzKAh5apGPgICTKMPuSMEDx9Qmw0vLSIpX5xM7F9yHH51sMdvsLhmBY2mwO9D+5oPfCPP9e6OPePHgqwbqWQKtZ/2jrno7DJlxU66xjcHAvkuc3ljGDtfQFMNkabnghrRxtr4BsMW8dcKjA6MsbW6gi89VFN73Z5m9S4hYV8MfgY4bEpYsOPTHTcoCHmTHouWX9m42kkh8InXu7gk6FrBm6Ik2nReTHX0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/swapops,rmap: remove should-never-be-compiled codes, included
folio_add_return_large_mapcount(), folio_sub_return_large_mapcount(),
set_pmd_migration_entry() and remove_migration_pmd().

Link: https://lore.kernel.org/linux-mm/CAHrEdeunY-YpDC7AoTFcppAvHCJpEJRp=GTQ4psRKRi_3fhB0Q@mail.gmail.com/

Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
---
 include/linux/rmap.h    | 17 ++-----
 include/linux/swapops.h | 12 -----
 mm/migrate_device.c     |  5 ++-
 mm/rmap.c               | 98 ++++++++++++++++++++---------------------
 4 files changed, 54 insertions(+), 78 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..44dccd1821eb 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -354,33 +354,24 @@ static inline void folio_add_large_mapcount(struct folio *folio,
 	atomic_add(diff, &folio->_large_mapcount);
 }
 
-static inline int folio_add_return_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
-{
-	BUILD_BUG();
-}
-
 static inline void folio_sub_large_mapcount(struct folio *folio,
 		int diff, struct vm_area_struct *vma)
 {
 	atomic_sub(diff, &folio->_large_mapcount);
 }
 
-static inline int folio_sub_return_large_mapcount(struct folio *folio,
-		int diff, struct vm_area_struct *vma)
-{
-	BUILD_BUG();
-}
 #endif /* CONFIG_MM_ID */
 
 #define folio_inc_large_mapcount(folio, vma) \
 	folio_add_large_mapcount(folio, 1, vma)
-#define folio_inc_return_large_mapcount(folio, vma) \
-	folio_add_return_large_mapcount(folio, 1, vma)
 #define folio_dec_large_mapcount(folio, vma) \
 	folio_sub_large_mapcount(folio, 1, vma)
+#ifdef CONFIG_NO_PAGE_MAPCOUNT
+#define folio_inc_return_large_mapcount(folio, vma) \
+	folio_add_return_large_mapcount(folio, 1, vma)
 #define folio_dec_return_large_mapcount(folio, vma) \
 	folio_sub_return_large_mapcount(folio, 1, vma)
+#endif
 
 /* RMAP flags, currently only relevant for some anon rmap operations. */
 typedef int __bitwise rmap_t;
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8cfc966eae48..d6ca56efc489 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -339,18 +339,6 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
 }
 
 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
-static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
-		struct page *page)
-{
-	BUILD_BUG();
-}
-
-static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvmw,
-		struct page *new)
-{
-	BUILD_BUG();
-}
-
 static inline void pmd_migration_entry_wait(struct mm_struct *m, pmd_t *p) { }
 
 static inline pmd_t swp_entry_to_pmd(swp_entry_t entry)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 23379663b1e1..13b2cd12e612 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -195,8 +195,8 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 		return migrate_vma_collect_skip(start, end, walk);
 	}
 
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	if ((migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
 		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
 		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
 
@@ -228,6 +228,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 	}
 
 fallback:
+#endif
 	spin_unlock(ptl);
 	if (!folio_test_large(folio))
 		goto done;
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..81c7f2becc21 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1232,7 +1232,7 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum pgtable_level level)
 {
-	atomic_t *mapped = &folio->_nr_pages_mapped;
+	__maybe_unused atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
 	int first = 0, nr = 0, nr_pmdmapped = 0;
 
@@ -1245,16 +1245,14 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 			break;
 		}
 
-		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-			nr = folio_add_return_large_mapcount(folio, orig_nr_pages, vma);
-			if (nr == orig_nr_pages)
-				/* Was completely unmapped. */
-				nr = folio_large_nr_pages(folio);
-			else
-				nr = 0;
-			break;
-		}
-
+#ifdef CONFIG_NO_PAGE_MAPCOUNT
+		nr = folio_add_return_large_mapcount(folio, orig_nr_pages, vma);
+		if (nr == orig_nr_pages)
+			/* Was completely unmapped. */
+			nr = folio_large_nr_pages(folio);
+		else
+			nr = 0;
+#else
 		do {
 			first += atomic_inc_and_test(&page->_mapcount);
 		} while (page++, --nr_pages > 0);
@@ -1264,22 +1262,21 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 			nr = first;
 
 		folio_add_large_mapcount(folio, orig_nr_pages, vma);
+#endif
 		break;
 	case PGTABLE_LEVEL_PMD:
 	case PGTABLE_LEVEL_PUD:
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
-		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-			if (level == PGTABLE_LEVEL_PMD && first)
-				nr_pmdmapped = folio_large_nr_pages(folio);
-			nr = folio_inc_return_large_mapcount(folio, vma);
-			if (nr == 1)
-				/* Was completely unmapped. */
-				nr = folio_large_nr_pages(folio);
-			else
-				nr = 0;
-			break;
-		}
-
+#ifdef CONFIG_NO_PAGE_MAPCOUNT
+		if (level == PGTABLE_LEVEL_PMD && first)
+			nr_pmdmapped = folio_large_nr_pages(folio);
+		nr = folio_inc_return_large_mapcount(folio, vma);
+		if (nr == 1)
+			/* Was completely unmapped. */
+			nr = folio_large_nr_pages(folio);
+		else
+			nr = 0;
+#else
 		if (first) {
 			nr = atomic_add_return_relaxed(ENTIRELY_MAPPED, mapped);
 			if (likely(nr < ENTIRELY_MAPPED + ENTIRELY_MAPPED)) {
@@ -1300,6 +1297,7 @@ static __always_inline void __folio_add_rmap(struct folio *folio,
 			}
 		}
 		folio_inc_large_mapcount(folio, vma);
+#endif
 		break;
 	default:
 		BUILD_BUG();
@@ -1656,7 +1654,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum pgtable_level level)
 {
-	atomic_t *mapped = &folio->_nr_pages_mapped;
+	__maybe_unused atomic_t *mapped = &folio->_nr_pages_mapped;
 	int last = 0, nr = 0, nr_pmdmapped = 0;
 	bool partially_mapped = false;
 
@@ -1669,19 +1667,17 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			break;
 		}
 
-		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
-			if (!nr) {
-				/* Now completely unmapped. */
-				nr = folio_large_nr_pages(folio);
-			} else {
-				partially_mapped = nr < folio_large_nr_pages(folio) &&
-						   !folio_entire_mapcount(folio);
-				nr = 0;
-			}
-			break;
+#ifdef CONFIG_NO_PAGE_MAPCOUNT
+		nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
+		if (!nr) {
+			/* Now completely unmapped. */
+			nr = folio_large_nr_pages(folio);
+		} else {
+			partially_mapped = nr < folio_large_nr_pages(folio) &&
+				!folio_entire_mapcount(folio);
+			nr = 0;
 		}
-
+#else
 		folio_sub_large_mapcount(folio, nr_pages, vma);
 		do {
 			last += atomic_add_negative(-1, &page->_mapcount);
@@ -1692,25 +1688,24 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			nr = last;
 
 		partially_mapped = nr && atomic_read(mapped);
+#endif
 		break;
 	case PGTABLE_LEVEL_PMD:
 	case PGTABLE_LEVEL_PUD:
-		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
-			last = atomic_add_negative(-1, &folio->_entire_mapcount);
-			if (level == PGTABLE_LEVEL_PMD && last)
-				nr_pmdmapped = folio_large_nr_pages(folio);
-			nr = folio_dec_return_large_mapcount(folio, vma);
-			if (!nr) {
-				/* Now completely unmapped. */
-				nr = folio_large_nr_pages(folio);
-			} else {
-				partially_mapped = last &&
-						   nr < folio_large_nr_pages(folio);
-				nr = 0;
-			}
-			break;
+#ifdef CONFIG_NO_PAGE_MAPCOUNT
+		last = atomic_add_negative(-1, &folio->_entire_mapcount);
+		if (level == PGTABLE_LEVEL_PMD && last)
+			nr_pmdmapped = folio_large_nr_pages(folio);
+		nr = folio_dec_return_large_mapcount(folio, vma);
+		if (!nr) {
+			/* Now completely unmapped. */
+			nr = folio_large_nr_pages(folio);
+		} else {
+			partially_mapped = last &&
+				nr < folio_large_nr_pages(folio);
+			nr = 0;
 		}
-
+#else
 		folio_dec_large_mapcount(folio, vma);
 		last = atomic_add_negative(-1, &folio->_entire_mapcount);
 		if (last) {
@@ -1730,6 +1725,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 		}
 
 		partially_mapped = nr && nr < nr_pmdmapped;
+#endif
 		break;
 	default:
 		BUILD_BUG();
-- 
2.43.0


