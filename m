Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E177E63CAC
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40A06B0093; Sun, 25 Jan 2026 12:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D118F6B0095; Sun, 25 Jan 2026 12:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14046B0096; Sun, 25 Jan 2026 12:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0C126B0093
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D3831402A6
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:32 +0000 (UTC)
X-FDA: 84371246064.12.2241FD5
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96013180009
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U//iWyLt";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnn5pIpGyxOH5+PjxlLrdlv4INj5zaNmBOfsLC8NtaY=;
	b=kmKQeqsQW2qozAI4BdG6IX8MEoN89Mrg8yj9iaylAY4HUnDPgxGg5WGST+JFULhnVW8xCJ
	T52zW5r+9FZixkxHkGPGfN8SD3owzxoQMSGM4LU690kIxfrAn4lGx2tUDmLVAV/aArpeUD
	EoYoZerL65SlpVTUgSj7LRFYdUmR5hk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363910; a=rsa-sha256;
	cv=none;
	b=KwzIzkk2UJ2afV+IIpFsQOjul74b4NnQ0qhqS0TRLDmbN1dDs0tIhKI/Mry9nTD6QKgPGG
	VoEzGgoEvfVRPr2f7qZIvAMFB9QGCRBAO8VmoxSxjTJtHZKzh783hclbw41e8o39JYC+FO
	u89TtatXCNihW2V4lExfL0LFv6OixSU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U//iWyLt";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8230c33f477so1526563b3a.2
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363909; x=1769968709; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnn5pIpGyxOH5+PjxlLrdlv4INj5zaNmBOfsLC8NtaY=;
        b=U//iWyLt/CT8UeBv+p3FfqAvlSz3e5LKo4jiiyqy9fLLoGmrF1G2ezJwrqYXE9oD2F
         017YdULi/B2LKnW3kHTXJsHeE6IeyOxsTMsFWzJImfIR184pBuhEXFqjLwTlx/HI+h0r
         8BQr5qkhbuHOC+VaCb0JUitFq3hCxYzKfqY80TclDvLrVzef9ZS3lsMcu5eQECuVcO7s
         zjo2pjd9t3ZPHh3pJceNPkuq/YhnXMY6wXwyV693jmi0NBTMCLwJIzcKqHkmDRJyrrGh
         V1qP6aQL8rUJVKNffJQS34JI8c+fOnF9b+drAsd1ijHJzPOKHwHCd+WnzKIFGGPCgGof
         N2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363909; x=1769968709;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fnn5pIpGyxOH5+PjxlLrdlv4INj5zaNmBOfsLC8NtaY=;
        b=RxXFqJLWCarTB1lXPiElC9ZUC0sUpdq6XjyayTsTYWC5Bv2y3YGrWbFC3oRPKflAP9
         8Jl3HkBTGLUO8j1rfRG6jcpKhRv+vM1n3NUfPh5DYtBxBRaC6UhATxLYybY6X/wJvNj8
         VZiGIu44vYh0YVQTp6botiImBrDajrZMkrNgvecTZ0vM6TnLKhLvGgRYY8ZlOlWOPZoa
         hcdyVzsnKZkegfw1MTwPklgl3Rwxf3GmgcOCmp0cle8+PuJtq+1kfuSpQ+3WqkXtlHxQ
         caRzzQZbD5Sc26kblcUzPim0IwRWXJQ/m0myDQJAojJUn9CGb2XRoZQ35ghiSC03ZHnq
         s98Q==
X-Gm-Message-State: AOJu0YzevypLo+rdrK5cVJ3vsysCiioZvn+g56wa7B9fUOSe4I38b/D2
	tx3WqxYBqFaxn4OsF/71y0u/p5qpGrDkT9nb9v6AVAw2DD3amK3/e/4x
X-Gm-Gg: AZuq6aJQlRqahnTwnMLefrqpNt60BCdkmgQSA3hw/x6CIr+ziing/Hsh78qh4tpd8kG
	8+HQ8ejCJTSQsO8c8oJ6771uHFr49HN2vfawA3tMxg9smjqAWDuq6VpmFVFbxVkC/Jziabx/9Xb
	UhtpwJwVFQJLMnzqXAfKEBTK09H8BpR1923iGliNK44yBuM4nymszL9cn7F6W4fQKO/vinfef6N
	aFnUqF9vTpXNWo/bd3ZPB2YfL1sKz5z2TzhTvcHjEfmLGAV7l5yYDRBuIMc+UUBwEj5JbeJNzw7
	Jpg94ZNAQSSNj2GprHazSwMh3Pnq78MOYwJd0gUG1SLc5lR3XkmV+DGFj9IwutVBCg4X7L4dzNp
	fGEV/FpnSo9lvylTnzaKg7j151BNjZ4HjIEhsst81vNPnTIs+iotfy/qojmp/5bdoE3CWsbiumi
	KoQt18kNRQbMEsYyhuePfGUxUycAy2U4xwpDpgy1mbq835YlXL
X-Received: by 2002:a05:6a00:4649:b0:81f:9a5b:e8fc with SMTP id d2e1a72fcca58-823412f82f3mr1913955b3a.54.1769363909394;
        Sun, 25 Jan 2026 09:58:29 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:27 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:29 +0800
Subject: [PATCH 06/12] mm, swap: implement helpers for reserving data in
 the swap table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-6-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=8400;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4fT4YuQVwXd0BVzfEj6WLA1Z9x9x2nMJyWoNmCPj5xw=;
 b=TpUkgudnYLmqTnl6Pa5LFXR+VM2YIcaeBS5a2Q34muNpI/zXkuLP/+e9Vvc5T9NyztUZWZ6h1
 5OPJ5B730QCA4O7CR/08fSidaUy1ugaaKpJop0MiU4yKkCoKOLC82Qi
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 96013180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mn93esqqknaxj3ryjpc7fio9uieme649
X-HE-Tag: 1769363910-128901
X-HE-Meta: U2FsdGVkX19gcpOU7KT+kKWenfGlQdA8rIbir5lw4m9n573xT9ZR/hUW0gXvzRrM+yew05psqf33QD/WTvY43zm89P8a3KbtQaT9YmO5jtaCoyk1NryofZaWnDTvpgAGfrhKxYEClzB/ReGyMvB8QFF/olj7gcbEky2RGy90ZiDzk+im9lxSw2hwbB0wlChxnVpR9FlgNingsm1aTAe7uy0LdEQp8Pj9H+4Kpi1yh7KTL5H157Mc7xvSaaguyD0dS+0BnNkBJDCP7QSG5NXHR9rpEX3rGiYhtRGeyfsq4iAziLWA6b8iivbDhFfXMpX+r20LgU0iG998PcqlWUzf0eEh4ufG6g5IVd0Vly+8QbTqfDxfqr4Z5ScNDynq8VDSf2LNr1WIwUIgHmLCEddvaQSUmxlStnSjqpL019npitYBF0iMVa0a9IA9kLfZoD83EEJPr0xu1rggWQg2yrqe5KktjvE1qy0AhlvUdmBvyKmD141sJbkhq+aQfWWQhBA1YIYYK6vlbAhFIB7K1CmbHTk4IF3DOve9Bl9RslrE44g+4qZXUFKjfNhqTSfzCZEQt/EGm554zBwJ+JasZmae7K8jK5q4Bkls6sI2REZ6kV5ZbShwFT9t8jCh/5HPbNT/J0GX8Ri8xZ92biyr1pM02Cah2LJ5KjDUChhBDXOWe9TWI01kXnkjPEZCQ6HT/vI+bYI9Z+XtCeZ223684Cr5tinkozoSHH2rn8OM+sAFmzqcqWxNqYYglVxuKuGZ34T5Kzsfer4eRFJhgcxFsRx+IPuXt5KbnsLaHDosyiRVbKO2oqi3u/wmAemHadGwjUP+JCBgCHP1ns3McpCFnONlDy/dnUN6AMEgIcj9Iasbg8vBexcaNCvVoEvtT2SMtCVMm0a9rsRr+0HjhTwPQt+x3KGeJPPrB+/Naw6x2T7mh1+0Jx3gCUHjbrrjX1Y4tDBhmo9O0sWQvXBmk6u25pd
 Rlp4+L+l
 27tz+Tv8UG9BwthWXAGjImb9lVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for using the swap table as the unified swap layer, introduce
macros and helpers for storing multiple kinds of data in a swap table
entry.

From now on, we are storing PFN in the swap table to make space for
extra counting bits (SWAP_COUNT). Shadows are still stored as they are,
as the SWAP_COUNT is not used yet.

Also, rename shadow_swp_to_tb to shadow_to_swp_tb; that's a spelling
error, not really worth a separate fix.

No behaviour change yet, just prepare the API.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c |   6 +--
 mm/swap_table.h | 124 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 117 insertions(+), 13 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..e213ee35c1d2 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -148,7 +148,7 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
 
-	new_tb = folio_to_swp_tb(folio);
+	new_tb = folio_to_swp_tb(folio, 0);
 	ci_start = swp_cluster_offset(entry);
 	ci_off = ci_start;
 	ci_end = ci_start + nr_pages;
@@ -249,7 +249,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
 
 	si = __swap_entry_to_info(entry);
-	new_tb = shadow_swp_to_tb(shadow);
+	new_tb = shadow_to_swp_tb(shadow, 0);
 	ci_start = swp_cluster_offset(entry);
 	ci_end = ci_start + nr_pages;
 	ci_off = ci_start;
@@ -331,7 +331,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	VM_WARN_ON_ONCE(!entry.val);
 
 	/* Swap cache still stores N entries instead of a high-order entry */
-	new_tb = folio_to_swp_tb(new);
+	new_tb = folio_to_swp_tb(new, 0);
 	do {
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) != old);
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 10e11d1f3b04..9c4083e4e4f2 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -12,17 +12,72 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
-#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
  * 1:1 map of the swap slots in this cluster.
  *
- * Each swap table entry could be a pointer (folio), a XA_VALUE
- * (shadow), or NULL.
+ * Swap table entry type and bits layouts:
+ *
+ * NULL:     |---------------- 0 ---------------| - Free slot
+ * Shadow:   | SWAP_COUNT |---- SHADOW_VAL ---|1| - Swapped out slot
+ * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
+ * Pointer:  |----------- Pointer ----------|100| - (Unused)
+ * Bad:      |------------- 1 -------------|1000| - Bad slot
+ *
+ * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
+ *
+ * Usages:
+ *
+ * - NULL: Swap slot is unused, could be allocated.
+ *
+ * - Shadow: Swap slot is used and not cached (usually swapped out). It reuses
+ *   the XA_VALUE format to be compatible with working set shadows. SHADOW_VAL
+ *   part might be all 0 if the working shadow info is absent. In such a case,
+ *   we still want to keep the shadow format as a placeholder.
+ *
+ *   Memcg ID is embedded in SHADOW_VAL.
+ *
+ * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the page
+ *   struct.
+ *
+ * - Pointer: Unused yet. `0b100` is reserved for potential pointer usage
+ *   because only the lower three bits can be used as a marker for 8 bytes
+ *   aligned pointers.
+ *
+ * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
  */
 
+/* Common SWAP_COUNT part */
+#define SWP_TB_COUNT_BITS	4 /* This can be shrunk or extended if needed */
+#define SWP_TB_COUNT_MASK	(~((~0UL) >> SWP_TB_COUNT_BITS))
+#define SWP_TB_COUNT_SHIFT	(BITS_PER_LONG - SWP_TB_COUNT_BITS)
+#define SWP_TB_COUNT_MAX	((1 << SWP_TB_COUNT_BITS) - 2)
+
+/* NULL Entry, all 0 */
+#define SWP_TB_NULL		0UL
+
+/* Swapped out: Shadow */
+#define SWP_TB_SHADOW_MARK	0b1UL
+
+/* Cached: PFN */
+#define SWP_TB_PFN_MASK		((~0UL) >> SWP_TB_COUNT_BITS)
+#define SWP_TB_PFN_MARK		0b10UL
+#define SWP_TB_PFN_MARK_BITS	2
+#define SWP_TB_PFN_MARK_MASK	(BIT(SWP_TB_PFN_MARK_BITS) - 1)
+
+/* Bad slot, ends with 0b1000 and rests of bits are all 1 */
+#define SWP_TB_BAD		((~0UL) << 3)
+
+#if defined(MAX_POSSIBLE_PHYSMEM_BITS)
+#define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
+#elif defined(MAX_PHYSMEM_BITS)
+#define SWAP_CACHE_PFN_BITS (MAX_PHYSMEM_BITS - PAGE_SHIFT)
+#else
+#define SWAP_CACHE_PFN_BITS (BITS_PER_LONG - PAGE_SHIFT)
+#endif
+
 /* Macro for shadow offset calculation */
 #define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
 
@@ -35,18 +90,41 @@ static inline unsigned long null_to_swp_tb(void)
 	return 0;
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio)
+static inline unsigned long __count_to_swp_tb(unsigned char count)
 {
+	VM_WARN_ON(count > SWP_TB_COUNT_MAX);
+	return ((unsigned long)count) << SWP_TB_COUNT_SHIFT;
+}
+
+static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned int count)
+{
+	unsigned long swp_tb;
+
 	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(void *));
-	return (unsigned long)folio;
+	BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
+		     (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS));
+
+	swp_tb = (pfn << SWP_TB_PFN_MARK_BITS) | SWP_TB_PFN_MARK;
+	VM_WARN_ON_ONCE(swp_tb & SWP_TB_COUNT_MASK);
+
+	return swp_tb | __count_to_swp_tb(count);
 }
 
-static inline unsigned long shadow_swp_to_tb(void *shadow)
+static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned int count)
+{
+	return pfn_to_swp_tb(folio_pfn(folio), count);
+}
+
+static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned int count)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
 		     BITS_PER_BYTE * sizeof(unsigned long));
+	BUILD_BUG_ON((unsigned long)xa_mk_value(0) != SWP_TB_SHADOW_MARK);
+
 	VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
-	return (unsigned long)shadow;
+	VM_WARN_ON_ONCE(shadow && ((unsigned long)shadow & SWP_TB_COUNT_MASK));
+
+	return (unsigned long)shadow | __count_to_swp_tb(count) | SWP_TB_SHADOW_MARK;
 }
 
 /*
@@ -59,7 +137,7 @@ static inline bool swp_tb_is_null(unsigned long swp_tb)
 
 static inline bool swp_tb_is_folio(unsigned long swp_tb)
 {
-	return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
+	return ((swp_tb & SWP_TB_PFN_MARK_MASK) == SWP_TB_PFN_MARK);
 }
 
 static inline bool swp_tb_is_shadow(unsigned long swp_tb)
@@ -67,19 +145,43 @@ static inline bool swp_tb_is_shadow(unsigned long swp_tb)
 	return xa_is_value((void *)swp_tb);
 }
 
+static inline bool swp_tb_is_bad(unsigned long swp_tb)
+{
+	return swp_tb == SWP_TB_BAD;
+}
+
+static inline bool swp_tb_is_countable(unsigned long swp_tb)
+{
+	return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
+		swp_tb_is_null(swp_tb));
+}
+
 /*
  * Helpers for retrieving info from swap table.
  */
 static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_folio(swp_tb));
-	return (void *)swp_tb;
+	return pfn_folio((swp_tb & SWP_TB_PFN_MASK) >> SWP_TB_PFN_MARK_BITS);
 }
 
 static inline void *swp_tb_to_shadow(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
-	return (void *)swp_tb;
+	return (void *)(swp_tb & ~SWP_TB_COUNT_MASK);
+}
+
+static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
+{
+	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
+	return ((swp_tb & SWP_TB_COUNT_MASK) >> SWP_TB_COUNT_SHIFT);
+}
+
+static inline int swp_tb_get_count(unsigned long swp_tb)
+{
+	if (swp_tb_is_countable(swp_tb))
+		return __swp_tb_get_count(swp_tb);
+	return -EINVAL;
 }
 
 /*
@@ -124,6 +226,8 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	atomic_long_t *table;
 	unsigned long swp_tb;
 
+	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+
 	rcu_read_lock();
 	table = rcu_dereference(ci->table);
 	swp_tb = table ? atomic_long_read(&table[off]) : null_to_swp_tb();

-- 
2.52.0


