Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CF7CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23498E007D; Mon, 11 Aug 2025 13:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3958E0060; Mon, 11 Aug 2025 13:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3118E007D; Mon, 11 Aug 2025 13:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 793EC8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:21:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27A221A02A1
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:21:35 +0000 (UTC)
X-FDA: 83765143350.08.0827DAD
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 459B3C0002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:21:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TIqYmxqg;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754932893;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7dP24dMk2MxdJIZqIqscUPVY/qEbDzRaJ+4erSqRyE=;
	b=vFZMnyRm99H7XdPOBKRGz9ZWnuugIMp/Mh8AEfuT1eEhOXxCB1jvUQlTYvGxyBrdEbyCdK
	5EGaCHuNEKvKGkn2uU6HDCkEjwJEaVXcsnz4+Z6mK/UHcPoDWLlsbtCBbD6wh+bddbbvpP
	r8MEUVTtWKDtrYtu0cxCnLyzrC+vmYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754932893; a=rsa-sha256;
	cv=none;
	b=jZxdHWc9mZ2YRfe5bqd1Odb0gtuF55wxEHSiMHWHd76tsJcSEUxrMWcbK408XuI23YORHb
	6YCSLqYgn6UMYCYyAOcLokYGZkPMkJEJ6SsTkj7mEJSw1/w67EKoD/z7iUMmiXzI8C1ecY
	IJ9al4QM0ujyfTQG0Vj6N+csjSAAzvQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TIqYmxqg;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4209a0d426so4617470a12.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754932892; x=1755537692; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I7dP24dMk2MxdJIZqIqscUPVY/qEbDzRaJ+4erSqRyE=;
        b=TIqYmxqge5cGAhwEiyI9NC14N/69+ksceV2/v/V460afUx5MAxBH9vtsQK9WzsJkoX
         qI9Le+NOud8ASRU39p34T5QQaRTjc1mjW3QnqjJ1RiSukNQtBb4sqT50EiRNBPes+VSr
         JbTQBPut3lnRHSD7XBy1CUCgV7fkTgTe3umBIIEOaFTLr7Qgohecjiz4r6I/zwEqUI0Z
         G3/Ca8Lx8I/PUir3Eq3IZuweVbWeeoP+kP7LoY12tdbRGJhC80+d+JWe/JOEKGdGMmoa
         srdArTf0p6+xsxSDzWOg0M7jJk+yKV/QZevNcuyzJPzocBbc0UJwnq9pHJEXS07vMtfC
         pkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932892; x=1755537692;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I7dP24dMk2MxdJIZqIqscUPVY/qEbDzRaJ+4erSqRyE=;
        b=dVmHemC6nHq42Bk33fM8o14ewzTOjkLU3quDPqphmAzMf63HpmaXdFHvmPa27G0yNi
         mc1VnBcxHw+07Ihun7udj5fpDcsb1Zu7/MoRXjuXPv8TCIamcmNy5x2Ig6QWKZS8L80r
         N6dCxrkLo4Gq1iOCZm/k7t8z7RZFTM/ozfw3nFUYVCgbkuY4Xco6gjgibcnLuwNzBT1c
         u0sJYBpRBWDrTPx+APqNSIuyJ5N8E+R1lCrs8XtaQ6JqmVN05UenOsATC0e5t1FOLe++
         SR/oSSaXeF9/E6lUKkIly2ZAPFC3aVpsQUdCWFQDuXIj3myp8O1+ECjQXR5N/xEFYur4
         U8AA==
X-Gm-Message-State: AOJu0Yx13mEcThsKQCFZd4yUjkRtrsnTgEjsHsIIbnpDI0dcYb/cf4Qa
	NcuqR81AxG0654ktklUo2GCkNni6wR1xnhznCLcXdoKfnYVqlFRLhjpAV/B9UT89p98=
X-Gm-Gg: ASbGncuxE5Y5eRPmcQ9+tEBbc3pcAB1HQ5RTduG76tBjpOdBMDT6VMipLfpH5UN7zY0
	dxwGsR/C66EznKO3dbidK+rpGZ9VwFX+qxLpglVjcxTPE7sMlRbNug7ODwuy2FCWk8MlVTK/AGS
	0rFGKu8QxaB4m+Y8ndqandiBkHiVX7tQYcHV1Z86VDYQey1VXL936C+ctS2G+SqsiXmmejqw+9I
	KjivrDxfsrNm0+urSw88DC8/0OsCzhvqCu4MeZexZeVyG725fhFXEBs9zvruW48DtrKSRcSvsJt
	ulOJ7Ek1EFITKWHLqHNlod8e/8d8W0aKVTjFNwfOA7u9IdXI2k/61AeAd2pTOSEeayD+aPUo836
	s0sOdktRnGApHHhXqyzYrLza8JeY=
X-Google-Smtp-Source: AGHT+IFopuiQlwhkYcY6L9G8/wk66sE58pMCCXKa6Jg6gb+DGlh9Pfbxl9B/SDORPgDwthkus9CoGA==
X-Received: by 2002:a17:902:c94d:b0:242:c66f:9f80 with SMTP id d9443c01a7336-242fc37288cmr4463315ad.53.1754932891475;
        Mon, 11 Aug 2025 10:21:31 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89769fasm276685055ad.107.2025.08.11.10.21.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:21:31 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 1/2] mm/mincore, swap: consolidate swap cache checking for mincore
Date: Tue, 12 Aug 2025 01:20:17 +0800
Message-ID: <20250811172018.48901-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811172018.48901-1-ryncsn@gmail.com>
References: <20250811172018.48901-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 459B3C0002
X-Stat-Signature: j1tms8ep8m53hmh4pjxwm7zriw6jiyeh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754932893-812080
X-HE-Meta: U2FsdGVkX193IdeFnNwWnDMQ0CwS40NPjfuxFfRHt+SuI8e1EmAjsjL1lSA4Zb356CargsXomB+smvSjShK/7a3/sEbGD6JblypgWKblmuxn+uM2xTF43qVVi4AKHJ4/6BZUV/KoyiGoRo6q1elIVzzzyUfSm18iPRj9vNkMjo5TuPjU58FMHXcEq6wmWFJMWNl9LIajghthZA1H/KAOzySefAPy8NBn2sf1KhEI/8/meogkexQDfD5xVcWbTscVVusY6ob0EnbRuD2lVl849LTXCLbdo2OWyXPwXwyInjBSWp3OeRC5MCvAhWA/x0xSEURSOcTCbq0ygja0X6JgRs/zVQ8Q8QfA82tGgg5HZ8qhXpbxRTwVIuQQQjtilreSQGIUk8XxN10JiX/S+XTFU0g6HitV5j5uRtxJgU0ZTSHupkd/dbKDc9AasuCWQLOHuHKYZqzVTLx4M1g2zXEyeytP3TbiJ2DV/Ms2ZrmfvA2thQ6GFksWFWSWG73pBskIVbjPWusijFcbg3G04unKpJGs0XFwCgMPZKkxqIOQiow2ryKgdYWIRlyrCTie4W/aqeuNB51F3nnHktEWMOVN+pQuVJBUbvgnLX3Jxd6b3Kwk9ZIvAbqaQZn+OavB3DCQLvQG8U2MjSrYGfRK+taNi2gNrOREH4KqxmMlDzXTQUmxNZakWBxmCE1DXdkWidRWtOlFFFrnFetJPsJuwWyTuXcbqbDw1vF2PU/hZTKdkvJzZ9nIv3OPMzUwRg6CksWQiGCLWHuKeR20I2IHRkr1ysm32gPLEA8c/vLgBgPni5XNTMheNvEyzw4R786TgvlC9dywdV259Ni/8Pkhmo7x02R5QA03v2wl8Mpg0zLNcwABdic4obIl+6Gat8PIqiYG6kg/8KXIWCY0f0yhJ2DAqPJ3xS3Skx1tzhBbjO/tiYclU+vxa9RRze//7wSFjDhyP6mwxUFtdH3FxkvzYxw
 q/Bnfuhd
 zPw9d6yWJ8HufslrGwrzDFCetpq2hGOSEEdpMLigWqvPAD5RVruUOz6m+I1TNy5+2xrw/+jsAeLpaQJtzFpovHDOj3jlV8uezF7bDo+1GSW6NYw16KT8mqL9LlRCcVWNL1t4R7xalsVwVkQZ9I7ux+8fKLi0SZSeD53XBseM7/j0EZeuIavf+bx39fQSCl7U6oAk6bKeReH8xg8NHu27jooSnmMWcUsAdBV30jXBcE81tOMJ1kDhW/ahL41SdAMTfqjHGiKjUOYwYgOaRrilizEDxqojfWWZlry7B5uR1pac6/7cD6gxtIJ9BVX4Hxp3tYQtgZka+ZNmbCwgXR5QknLhFs1GSMedwYT8F4x2uKQm36/0lKpIZj5iMc6EUdsNWvop0sL2oGxVsJqgSGJE8/AMWzapPLrP+Nk6itiIkdVSUFmRG+CTFJY40qP2ouBSNfL4zGChXbE91CQzw16f3FliYATY2we8t8VnGK/v3SKHLLCMB1qypzy9HthfpHkqlGFqzn8iWmZ+oOguB7Nwuvx7wk48251CcpO+KjjY3Pz1KK8j0shi6Nh4WMomajROOKiMG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The filemap_get_incore_folio (previously find_get_incore_page) helper
was introduced by commit 61ef18655704 ("mm: factor find_get_incore_page
out of mincore_page") to be used by later commit f5df8635c5a3 ("mm: use
find_get_incore_page in memcontrol"), so memory cgroup charge move code
can be simplified.

But commit 6b611388b626 ("memcg-v1: remove charge move code") removed
that user completely, it's only used by mincore now.

So this commit basically reverts commit 61ef18655704 ("mm: factor
find_get_incore_page out of mincore_page"). Move it back to mincore side
to simplify the code.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/mincore.c    | 29 +++++++++++++++++++++++++++--
 mm/swap.h       | 10 ----------
 mm/swap_state.c | 38 --------------------------------------
 3 files changed, 27 insertions(+), 50 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 10dabefc3acc..20fd0967d3cb 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -64,8 +64,33 @@ static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-	folio = filemap_get_incore_folio(mapping, index);
-	if (!IS_ERR(folio)) {
+	if (IS_ENABLED(CONFIG_SWAP) && shmem_mapping(mapping)) {
+		folio = filemap_get_entry(mapping, index);
+		/*
+		 * shmem/tmpfs may return swap: account for swapcache
+		 * page too.
+		 */
+		if (xa_is_value(folio)) {
+			struct swap_info_struct *si;
+			swp_entry_t swp = radix_to_swp_entry(folio);
+			/* There might be swapin error entries in shmem mapping. */
+			if (non_swap_entry(swp))
+				return 0;
+			/* Prevent swap device to being swapoff under us */
+			si = get_swap_device(swp);
+			if (si) {
+				folio = filemap_get_folio(swap_address_space(swp),
+							  swap_cache_index(swp));
+				put_swap_device(si);
+			} else {
+				return 0;
+			}
+		}
+	} else {
+		folio = filemap_get_folio(mapping, index);
+	}
+
+	if (!IS_ERR_OR_NULL(folio)) {
 		present = folio_test_uptodate(folio);
 		folio_put(folio);
 	}
diff --git a/mm/swap.h b/mm/swap.h
index 911ad5ff0f89..1ae44d4193b1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -64,9 +64,6 @@ void clear_shadow_from_swap_cache(int type, unsigned long begin,
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *swap_cache_get_folio(swp_entry_t entry,
 		struct vm_area_struct *vma, unsigned long addr);
-struct folio *filemap_get_incore_folio(struct address_space *mapping,
-		pgoff_t index);
-
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -178,13 +175,6 @@ static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
 	return NULL;
 }
 
-static inline
-struct folio *filemap_get_incore_folio(struct address_space *mapping,
-		pgoff_t index)
-{
-	return filemap_get_folio(mapping, index);
-}
-
 static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	return NULL;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c354435a0923..99513b74b5d8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -323,44 +323,6 @@ struct folio *swap_cache_get_folio(swp_entry_t entry,
 	return folio;
 }
 
-/**
- * filemap_get_incore_folio - Find and get a folio from the page or swap caches.
- * @mapping: The address_space to search.
- * @index: The page cache index.
- *
- * This differs from filemap_get_folio() in that it will also look for the
- * folio in the swap cache.
- *
- * Return: The found folio or %NULL.
- */
-struct folio *filemap_get_incore_folio(struct address_space *mapping,
-		pgoff_t index)
-{
-	swp_entry_t swp;
-	struct swap_info_struct *si;
-	struct folio *folio = filemap_get_entry(mapping, index);
-
-	if (!folio)
-		return ERR_PTR(-ENOENT);
-	if (!xa_is_value(folio))
-		return folio;
-	if (!shmem_mapping(mapping))
-		return ERR_PTR(-ENOENT);
-
-	swp = radix_to_swp_entry(folio);
-	/* There might be swapin error entries in shmem mapping. */
-	if (non_swap_entry(swp))
-		return ERR_PTR(-ENOENT);
-	/* Prevent swapoff from happening to us */
-	si = get_swap_device(swp);
-	if (!si)
-		return ERR_PTR(-ENOENT);
-	index = swap_cache_index(swp);
-	folio = filemap_get_folio(swap_address_space(swp), index);
-	put_swap_device(si);
-	return folio;
-}
-
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists)
-- 
2.50.1


