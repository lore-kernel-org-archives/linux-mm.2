Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BEDD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D706B00AB; Fri, 19 Dec 2025 14:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4446B00AD; Fri, 19 Dec 2025 14:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89E06B00AE; Fri, 19 Dec 2025 14:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A122B6B00AB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:45:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66FCE1A039F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:32 +0000 (UTC)
X-FDA: 84237250104.24.7940C86
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59A4B40010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:45:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g5glzY6q;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766173530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJe7TUlSLTyG3X6lbp3TN7yAGLGf2fYmibniRVXmXAQ=;
	b=dICG/ByYrtNOk5kb6lnLBPoHKibE/f2kgGcxeM35EtUpllClNUFXFGnNY058m/lWfr4t0I
	xt/zsgGaF35iu8hQLD+3E20Ph4rSBzw2OtI+bV82zwfkiXO0RBg1DRlLZeNsUFVknhq1Iq
	tLFZteCr6H44xvrpf0Uq7fyn6CTctuE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g5glzY6q;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766173530; a=rsa-sha256;
	cv=none;
	b=bQJSJkYi4Uv7lQ8cKoswpJ0HoxQqkjPceiITqBfmAAwmYNnB1Bp1Kw14D54B3P6UfDrWoE
	MljtMpBdJPt50ZfGMdRrkTsyH/r4sCxfyh1M1Xn4LG6qvM+zk84g4W2jH9IpxlOqnBE5xJ
	BYoQ/CV4geiliSkpoRvsIIxB3oDrUCo=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d5c365ceso25529375ad.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766173529; x=1766778329; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJe7TUlSLTyG3X6lbp3TN7yAGLGf2fYmibniRVXmXAQ=;
        b=g5glzY6q/+MM8abRj802WYbJHQ4vGMOl7YFA02v5OtjzKfZiVQOouIQSt6ueFz2hkK
         1chy3Z4zOOY97kGKrn5LrlbqG8AzTma3K1aZr/+p+90ZtiHWb9G5e5BAsNA5faIsmPib
         2FjW8UWN9iAmJ9RxfgCyv/6D81/qyGrTJ8UDVhKq4M921kmKtaD+8fLeAckXWG8tjw0Z
         Rog/k/5ifMoKzjS2DUHs91tcQbSSsC/5NLHuIuSSHtC+8jH13nWlt/NEDPE3Zj2SNmTz
         GET5sLE9V2K+dWNBpBfKyrvlNccjTLFgkPX6Xn21JLlbEJDRMBgjLaB9MgZb+WPxZMcp
         4GFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766173529; x=1766778329;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vJe7TUlSLTyG3X6lbp3TN7yAGLGf2fYmibniRVXmXAQ=;
        b=RPFZDS3Ho5fKAtG4Es5gzPEbehUEC1RX7/qLOlVwbSkj+GrV8Evy5Pea1D/gFiaZae
         o88LlgtWeObOOP/O+eg3jT3nbSqZ0XDZ84RqsnJ0aL6HYSIDfj/RKq59rTqcpyvcVAgJ
         iHARuEI0EHCzJFkWprpQ+kOS0UnXctZeEwWOLdOwcE7Rjk2q939YXHGb6O59lemDztDd
         ny+WZ49LUGhe/oZ3JCGzitkZXwfJP1flcDyDycQcH//sSHFy37uqAnl8W0w/QR1JjOFM
         LD7u4Jvgofe9bMHBPSDdbFAtzR2EcsDCuYU+dzL/2XEfV2PcPSfpK3t7m70PhwO8sQuH
         of/Q==
X-Gm-Message-State: AOJu0Yy+rXMB+6ARyRu8V1xsOixCEm1/1LnEsHqZpUpMkvu2K3kyMMdT
	6niY1Jr7vPDNQpFF2bRyJRJoFygmuqXBdhi0l5/ZOGQC5naf1CNaWJPu
X-Gm-Gg: AY/fxX5UPWcZa5bIMAyPc/cbBsaBrphMSxU/J1JviMgX1jED3P65EIdPjCQHLntuBGT
	sum5uherec8pfd2BMGBgr+SbHe1kBHnXeF7PuueWqfO5LfWplxv2YhEzmI6EIh0bCIAb2q8vG3R
	b9J9+Byh48Ih6G/h4etv13GVufUoEW5kwBjPr86t3T2MLMIe9y29JV5fKZNx5IoWT0WfHObYs0F
	qzBFC5LJHMfF4oMj05cN/fPUesIhccaMHLqRMvhb8SDeqLwfq4LutKoBcnrLZYFsl642w0PjQOy
	kptXr2U8R3qzvgUNkgrCPvC0LY8ejf1SeeadKowYpp/znPCUCAgS35/67kuzOQJVVwfJsRu/mww
	zonl/Qz02oIkgAyWkzlsKJHpmmTLKeIX5uyEl1q+vgHgnYXlLmwbiJQMDS3vj8RuRQU0lFYgYYt
	Ckt0DipAZxJFHV5w68RoZSwqXMl8Km+NbwVhcK9jSzTRcN3tsu1q6k
X-Google-Smtp-Source: AGHT+IGyP70mQedU5GkPxMY02O8grCvS8qgRmoNGheDHQnYEgWaWJw8AmLLhPaICPuifjoyXraitXQ==
X-Received: by 2002:a17:902:cf0d:b0:29f:b3e5:5186 with SMTP id d9443c01a7336-2a2f293d13bmr40116945ad.56.1766173528751;
        Fri, 19 Dec 2025 11:45:28 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ceesm30170985ad.91.2025.12.19.11.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 11:45:28 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 03:43:44 +0800
Subject: [PATCH v5 15/19] mm, swap: add folio to swap cache directly on
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-swap-table-p2-v5-15-8862a265a033@tencent.com>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766173451; l=18723;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ljO3bAI9+CcPRr1+yVdxPpxrgKCXdZlXBv6eM2iyJP8=;
 b=Lcref8/LZ6ecnxIakmh38uBHpEsdGDYwJNPEjAlf1uOHslPegk93cBsuOAOFevJHFIggYfeAA
 jlAmX6URsH4CDhqhoGTqKM3fmuOGGoI4kOpuQqIXOU00KcdcdVplJ6x
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59A4B40010
X-Stat-Signature: k17yus8gepo7u3ro8qmus54etq7zeici
X-HE-Tag: 1766173530-247416
X-HE-Meta: U2FsdGVkX19FfxjlNw46v9TCpNgI7Hmz/i+AwcmEHgq3nth4+MrCXY9pvZVjcV4u/LEOGiAUhNaQh7h/vbBLEtX7QJeqm7nP7Uv4yyfSpc4f+Vgyu1R3DtK2i5bBqFfmNUifYR19yMxGFTsX8QHZFX5T0pAXrCI2/pmL5uArsEvVyn8P/7pxb+dwJRoNXkhs+WBQN+gOJxj02zhXRCxmrx00BQjJaoLMmkjZzjYxUlk3d7Phexg4/vx9iYfvxe6F5RIcxD+BZz5o5vMz3zKEjM1mxxszoh8ECA4pDPpiGgZ1Pa/cn1M+YKk8fzeAKKA2CFxYQPqEd+0p7G5Rkk9rpTA/psHWIY3IDISdxuaI3qlwgRDd9mXvLDX7Sm2JU789XnRXNaHqPONHiFOiRzprnlvXsU2VWOkjY4cJ3E0tPV8WEvzXybdVwfWlC5Y0VLpvQX1IZnpNboqa0KZpicFAUOBNHDJEc0+yQ0VcrGPM4FoUW3kTEwEVnytmUGeWNZF8qNY+U9HK8ZXlq5KPDPSYXZTfQy1kFdfjtHUPIQQvrx+fDKqP7qn+95F/S6llfYzP9Do+aYu3QdX4l9mcOWSaCBIbXmYCzRo1BZSoLDq8f+r62b0sYVM9FR9OplaO1F+q66Vyn8tVwa31bTHcmlvTdZewaXBu8WNnqlQiH0cCHV2amTVgGDiSQkxubaALurfFh3AoMDg2ccLRihAP++gXXJIKZiKIH/beFE+PAX721kDuGDHNIlw9sONjjB0yjRGurpwTweMmDpamhBLJCuye7T7oAcJCMquFIxuKH2uLvtTTFID0FgoqzyrtXxbs5qp//TcuZBQ9WzCeIQmyK2QmjV22/mlBLbKuZTA4f45oFm8tFwRgBA5EnowQrnB0sLC/BTOp25cdyPEI4imdABZuLQSmd1Nm/2x3km7LNy9M+UZrm4D2NAMoBnxMX22PhAcU87noT0CzwGwfl2Wendr
 rEbnwrL/
 Fcjpt5+HdHRHJFyB4YjJNQ2olXhtwq3Bqt37nI7crXrAXcSbgTCHqhhKXRJh6APlvVGQFSvoKEq0EEhkBXFbpqDMbVVkxFfWrZyHZ90BqNCLu8nWKFS+p179EFYyI4JG6pw8QGOP7uRQDtC9Y5tfTJMdF7tdC85uuaUVtMejka5VNRQ9GHK3CLz2MO4O8tbFfIdkHvhsbn4K0HviyvwXP+cdGhmj1lG8AB76A2Rqv896S1Gi1xPNNXPTDnQNYEig6HaETgU41VZwOdvuVYLsBakXdcvAWAJqVBFXU9MmXVgVmkYqSktMQo/0/o2GjLaSNvS1dnED01VZMMOVtXcDaXpYDX2EX8fktr4LCENHXOX7qRUTdndeywG5yX4xuYmYyZarEGxgwDYt5FE3DZ9G1HCIcFq1Y6OxSJRI2qsodBN81sOxo/xRkYqn6Uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator uses SWAP_HAS_CACHE to pin a swap slot upon allocation.
SWAP_HAS_CACHE is being deprecated as it caused a lot of confusion.
This pinning usage here can be dropped by adding the folio to swap
cache directly on allocation.

All swap allocations are folio-based now (except for hibernation), so
the swap allocator can always take the folio as the parameter. And now
both swap cache (swap table) and swap map are protected by the cluster
lock, scanning the map and inserting the folio can be done in the same
critical section. This eliminates the time window that a slot is pinned
by SWAP_HAS_CACHE, but it has no cache, and avoids touching the lock
multiple times.

This is both a cleanup and an optimization.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   5 --
 mm/swap.h            |  10 +---
 mm/swap_state.c      |  58 +++++++++++--------
 mm/swapfile.c        | 161 ++++++++++++++++++++++-----------------------------
 4 files changed, 105 insertions(+), 129 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index aaa868f60b9c..517d24e96d8c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -452,7 +452,6 @@ static inline long get_nr_swap_pages(void)
 }
 
 extern void si_swapinfo(struct sysinfo *);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
@@ -533,10 +532,6 @@ static inline void swap_put_entries_direct(swp_entry_t ent, int nr)
 {
 }
 
-static inline void put_swap_folio(struct folio *folio, swp_entry_t swp)
-{
-}
-
 static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/swap.h b/mm/swap.h
index 9ed12936b889..ec1ef7d0c35b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -277,13 +277,13 @@ void __swapcache_clear_cached(struct swap_info_struct *si,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadow, bool alloc);
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
 				     struct mempolicy *mpol, pgoff_t ilx,
 				     bool *alloced);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
@@ -459,12 +459,6 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-				       void **shadow, bool alloc)
-{
-	return -ENOENT;
-}
-
 static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 327c051d7cd0..29fa8d313a79 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -122,35 +122,56 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry)
+{
+	unsigned long new_tb;
+	unsigned int ci_start, ci_off, ci_end;
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	new_tb = folio_to_swp_tb(folio);
+	ci_start = swp_cluster_offset(entry);
+	ci_off = ci_start;
+	ci_end = ci_start + nr_pages;
+	do {
+		VM_WARN_ON_ONCE(swp_tb_is_folio(__swap_table_get(ci, ci_off)));
+		__swap_table_set(ci, ci_off, new_tb);
+	} while (++ci_off < ci_end);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
 /**
  * swap_cache_add_folio - Add a folio into the swap cache.
  * @folio: The folio to be added.
  * @entry: The swap entry corresponding to the folio.
  * @gfp: gfp_mask for XArray node allocation.
  * @shadowp: If a shadow is found, return the shadow.
- * @alloc: If it's the allocator that is trying to insert a folio. Allocator
- *         sets SWAP_HAS_CACHE to pin slots before insert so skip map update.
  *
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
-			 void **shadowp, bool alloc)
+static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+				void **shadowp)
 {
 	int err;
 	void *shadow = NULL;
+	unsigned long old_tb;
 	struct swap_info_struct *si;
-	unsigned long old_tb, new_tb;
 	struct swap_cluster_info *ci;
 	unsigned int ci_start, ci_off, ci_end, offset;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
 	si = __swap_entry_to_info(entry);
-	new_tb = folio_to_swp_tb(folio);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -166,7 +187,7 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			err = -EEXIST;
 			goto failed;
 		}
-		if (!alloc && unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
+		if (unlikely(!__swap_count(swp_entry(swp_type(entry), offset)))) {
 			err = -ENOENT;
 			goto failed;
 		}
@@ -182,20 +203,11 @@ int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 		 * Still need to pin the slots with SWAP_HAS_CACHE since
 		 * swap allocator depends on that.
 		 */
-		if (!alloc)
-			__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		__swap_table_set(ci, ci_off, new_tb);
+		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
 		offset++;
 	} while (++ci_off < ci_end);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
+	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
-
-	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-
 	if (shadowp)
 		*shadowp = shadow;
 	return 0;
@@ -464,7 +476,7 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	for (;;) {
-		ret = swap_cache_add_folio(folio, entry, &shadow, false);
+		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
 			break;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f812fdea68b3..de0f4c1352cb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -884,28 +884,57 @@ static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
 	}
 }
 
-static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster_info *ci,
-				unsigned int start, unsigned char usage,
-				unsigned int order)
+static bool cluster_alloc_range(struct swap_info_struct *si,
+				struct swap_cluster_info *ci,
+				struct folio *folio,
+				unsigned int offset)
 {
-	unsigned int nr_pages = 1 << order;
+	unsigned long nr_pages;
+	unsigned int order;
 
 	lockdep_assert_held(&ci->lock);
 
 	if (!(si->flags & SWP_WRITEOK))
 		return false;
 
+	/*
+	 * All mm swap allocation starts with a folio (folio_alloc_swap),
+	 * it's also the only allocation path for large orders allocation.
+	 * Such swap slots starts with count == 0 and will be increased
+	 * upon folio unmap.
+	 *
+	 * Else, it's a exclusive order 0 allocation for hibernation.
+	 * The slot starts with count == 1 and never increases.
+	 */
+	if (likely(folio)) {
+		order = folio_order(folio);
+		nr_pages = 1 << order;
+		/*
+		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
+		 * This is the legacy allocation behavior, will drop it very soon.
+		 */
+		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
+		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
+	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
+		order = 0;
+		nr_pages = 1;
+		WARN_ON_ONCE(si->swap_map[offset]);
+		si->swap_map[offset] = 1;
+		swap_cluster_assert_table_empty(ci, offset, 1);
+	} else {
+		/* Allocation without folio is only possible with hibernation */
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
 	/*
 	 * The first allocation in a cluster makes the
 	 * cluster exclusive to this order
 	 */
 	if (cluster_is_empty(ci))
 		ci->order = order;
-
-	memset(si->swap_map + start, usage, nr_pages);
-	swap_cluster_assert_table_empty(ci, start, nr_pages);
-	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
+	swap_range_alloc(si, nr_pages);
 
 	return true;
 }
@@ -913,13 +942,12 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    unsigned long offset,
-					    unsigned int order,
-					    unsigned char usage)
+					    struct folio *folio, unsigned long offset)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 
@@ -943,7 +971,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
-		if (!cluster_alloc_range(si, ci, offset, usage, order))
+		if (!cluster_alloc_range(si, ci, folio, offset))
 			break;
 		found = offset;
 		offset += nr_pages;
@@ -965,8 +993,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 
 static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 struct list_head *list,
-					 unsigned int order,
-					 unsigned char usage,
+					 struct folio *folio,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
@@ -978,7 +1005,7 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			break;
 	} while (scan_all);
@@ -1039,10 +1066,11 @@ static void swap_reclaim_work(struct work_struct *work)
  * Try to allocate swap entries with specified order and try set a new
  * cluster for current CPU too.
  */
-static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int order,
-					      unsigned char usage)
+static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
+					      struct folio *folio)
 {
 	struct swap_cluster_info *ci;
+	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 
 	/*
@@ -1064,8 +1092,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, offset,
-							order, usage);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1079,22 +1106,19 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order],
-					     order, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true);
 		if (found)
 			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
-					     false);
+		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
 	}
@@ -1110,8 +1134,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
-					     usage, false);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
 			goto done;
 	}
@@ -1125,13 +1148,11 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		found = alloc_swap_scan_list(si, &si->frag_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
 		if (found)
 			goto done;
 
-		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o],
-					     0, usage, true);
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o], folio, true);
 		if (found)
 			goto done;
 	}
@@ -1322,12 +1343,12 @@ static bool get_swap_device_info(struct swap_info_struct *si)
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
  */
-static bool swap_alloc_fast(swp_entry_t *entry,
-			    int order)
+static bool swap_alloc_fast(struct folio *folio)
 {
+	unsigned int order = folio_order(folio);
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
-	unsigned int offset, found = SWAP_ENTRY_INVALID;
+	unsigned int offset;
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
@@ -1342,22 +1363,18 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 	if (cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, offset, order, SWAP_HAS_CACHE);
-		if (found)
-			*entry = swp_entry(si->type, found);
+		alloc_swap_scan_cluster(si, ci, folio, offset);
 	} else {
 		swap_cluster_unlock(ci);
 	}
 
 	put_swap_device(si);
-	return !!found;
+	return folio_test_swapcache(folio);
 }
 
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(swp_entry_t *entry,
-			    int order)
+static void swap_alloc_slow(struct folio *folio)
 {
-	unsigned long offset;
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
@@ -1367,13 +1384,11 @@ static void swap_alloc_slow(swp_entry_t *entry,
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
-			offset = cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE);
+			cluster_alloc_swap_entry(si, folio);
 			put_swap_device(si);
-			if (offset) {
-				*entry = swp_entry(si->type, offset);
+			if (folio_test_swapcache(folio))
 				return;
-			}
-			if (order)
+			if (folio_test_large(folio))
 				return;
 		}
 
@@ -1438,7 +1453,6 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
-	swp_entry_t entry = {};
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1463,39 +1477,23 @@ int folio_alloc_swap(struct folio *folio)
 
 again:
 	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(&entry, order))
-		swap_alloc_slow(&entry, order);
+	if (!swap_alloc_fast(folio))
+		swap_alloc_slow(folio);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	if (unlikely(!order && !entry.val)) {
+	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
 			goto again;
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (mem_cgroup_try_charge_swap(folio, entry))
-		goto out_free;
+	if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
+		swap_cache_del_folio(folio);
 
-	if (!entry.val)
+	if (unlikely(!folio_test_swapcache(folio)))
 		return -ENOMEM;
 
-	/*
-	 * Allocator has pinned the slots with SWAP_HAS_CACHE
-	 * so it should never fail
-	 */
-	WARN_ON_ONCE(swap_cache_add_folio(folio, entry, NULL, true));
-
-	/*
-	 * Allocator should always allocate aligned entries so folio based
-	 * operations never crossed more than one cluster.
-	 */
-	VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, size), folio);
-
 	return 0;
-
-out_free:
-	put_swap_folio(folio, entry);
-	return -ENOMEM;
 }
 
 /**
@@ -1798,29 +1796,6 @@ static void swap_entries_free(struct swap_info_struct *si,
 		partial_free_cluster(si, ci);
 }
 
-/*
- * Called after dropping swapcache to decrease refcnt to swap entries.
- */
-void put_swap_folio(struct folio *folio, swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci;
-	unsigned long offset = swp_offset(entry);
-	int size = 1 << swap_entry_order(folio_order(folio));
-
-	si = _swap_info_get(entry);
-	if (!si)
-		return;
-
-	ci = swap_cluster_lock(si, offset);
-	if (swap_only_has_cache(si, offset, size))
-		swap_entries_free(si, ci, entry, size);
-	else
-		for (int i = 0; i < size; i++, entry.val++)
-			swap_entry_put_locked(si, ci, entry, SWAP_HAS_CACHE);
-	swap_cluster_unlock(ci);
-}
-
 int __swap_count(swp_entry_t entry)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
@@ -2072,7 +2047,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 			 * with swap table allocation.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, 0, 1);
+			offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);

-- 
2.52.0


