Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D3A1CFD351
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A466D6B00AB; Mon, 24 Nov 2025 14:17:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6086B00AD; Mon, 24 Nov 2025 14:17:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEB56B00AE; Mon, 24 Nov 2025 14:17:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 736776B00AB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:17:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 334F9130669
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:11 +0000 (UTC)
X-FDA: 84146458662.26.26ABBC0
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 138351A0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:17:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ngpwbeyZ;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oavhXabVAvvtZsCcC1cvU1AnZafkH+SsQyZTTlJRTjA=;
	b=QVoR1JECNrgOjQ9I9R0WiDW2eIJL8jDLaQFPgzR21H/Q5rGz5rn/LGxtxXINUhshajkkTC
	GZgZxdrupAKnIgQtViXV0puK9POuAAKPldnEAYHkrBQOqQI5oSfAloH8G0yoDTds0aBeNP
	C/ssKueOoZx/ihbcI2WJDk7aNvh20tc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ngpwbeyZ;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011829; a=rsa-sha256;
	cv=none;
	b=p+mqZFUdVwoZXlaoE6T2NO6wBJrRIMImbOfYFM+Djrk5nNcReOgwfO5zLAVRG2EKcND9HC
	NqKuYq5Qdud8BmAfoU1VoYJUL8AP/amntROx3VFq5TYgFblBfLfLndHXXECTL2t1kaVOqq
	0tSo/YRLpc1jqUfNZZlR0gNMiZ0r9vY=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7aab061e7cbso5475672b3a.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011828; x=1764616628; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oavhXabVAvvtZsCcC1cvU1AnZafkH+SsQyZTTlJRTjA=;
        b=ngpwbeyZW9pFl/WDJXZ64UZK7fzKBKxGprUDv23CfC+xp2y26aDv0XqF+5KLwuCmGB
         Lncy/ddehztMXGv62+3/eYq8gS2bQf8qaDvoiWz63Yqfm5iwI3SyGpkh8v2cluIR8dtr
         G+qI5/2NAtbrh0a7Iq/SumN4wwbri2Byr/7nyIk7dBfNtckRHmi5vb7+wlyB0144QlnH
         5ku/f3Lwk5GwwszEsH7WIyDxQTKe2vH+OmhkmEEyI5e9zq+FgrrzIdlBpeSTvs1v0Quv
         Z8mRvRwoG+wAu5NKh9I7hqvnqT9DGlpDFC32cuxCzuvYnkEj8sNpvlU+R6LGu1C3qWyd
         04Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011828; x=1764616628;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oavhXabVAvvtZsCcC1cvU1AnZafkH+SsQyZTTlJRTjA=;
        b=D4I1yjIBDcGWV3fUoTGDZmS7DdqXrHK823YOVgt8QAZ4LelWZoItGHP2nT4xEDS/8I
         wXoqO6wdnL1a04eGDOWvj9CPOi02b3acExi3X/1VmTCrRRPtRXmlE4lVaxlUa3VFBqZF
         CjJXvxawokdrnKi68dYfH5VgrbRjVrbl1FcAc81MT38QSs3cyGTNiJxuniMEpCvCCqvR
         bJyqba+BIgXd2wc91T++SLwWDHs83/vQvnNAV73sVigA9ezreb0RoKH0jsF8NWeuX8D0
         mHBD/9e3UWAmYZ7iJsvSZYMim/hYnzmn37czSW5zjL7Gwd/ymG5TheQQyiDyg1kC+jTw
         gIcQ==
X-Gm-Message-State: AOJu0Yzj3EGwMXloLCwytBxQ43vqtstbKzB+7pxslgMP/AceE1ghkrln
	uj0AplRz5WAJFP3XjZF4+tp9UCG/4vmxLPCmLulh2HBkd4MpwIwb2bel
X-Gm-Gg: ASbGncu7j8dfmC6SHMW81O8s6l2t0lF9vrq6TuGhVec8olHjqGycGdphr1b/VRJ4O3r
	pwMkFINhPIrjaL/LlTA5V2tOTgoBcTeg++hLmpB0KAz8I+hiQoBu9W7fNpDIUGlbtZyBvG73eJO
	eAYwBYF/G/UvTDbrG5uVIlAUlR7Jichpc3oS1MGgyIe42YIWhLvdRpDnLsn4ylMNn5HfgNiAUci
	vUt0woYnIn4+fEPQamnPkyqr1RwyV7GLjkN02avPmmfwq6/1L7GKCO+p91gatFnYibqtMAbhTOY
	bKmL9q9/b0Q2Rq7w5qQrdNEWORNnffnOF9Oys6acRRhJq7oPsHrIYo285NE4veMM5NHS5AsiwOJ
	NbIYZSxee1GY88yiUnoU9i9NnV8rk31g8c1pmUu5xABf7vylsRrnEIx4y1M4E1sBlkAmCTTCGW/
	ST8KyMzdtEsuwuAOPZ5lU71YP/Gjxkq7DqcJqq6LCSOJ+FfM2J
X-Google-Smtp-Source: AGHT+IEEa0/4DBIyOYVlSoSGhkD1FGqCrGz2j/iQmnzJiouWp299MREFaVh1uEO6xrXh4DYlBHXw+w==
X-Received: by 2002:a05:6a20:a12a:b0:342:e2ef:332d with SMTP id adf61e73a8af0-3614edf0345mr13982274637.40.1764011827592;
        Mon, 24 Nov 2025 11:17:07 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:17:07 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:14:01 +0800
Subject: [PATCH v3 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-18-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=20744;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=o84OpWXB1jw3q+8P1SWDt5xur29PoKfAkoQZg5MRGnU=;
 b=Rc5hMxyabCrYaKu5dbJIvtTYpYR/7TSXXdNmp7udJJaWHZTuFqmCRe7D+eQTu4iXwBUUTiFfu
 +m7XZWUfhvOBjZdudWffxqNL8gGOGTTj9vm/6gLVY15BKgNijMQGYyI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 138351A0008
X-Stat-Signature: 9qs3amz3j19ua6ffqodrwyf5q8w5w35g
X-Rspam-User: 
X-HE-Tag: 1764011828-78946
X-HE-Meta: U2FsdGVkX19BlW2Q0ic2nJ3L2am/4Ty+n+UkrSaJw2Hr3F+Hxe+J7CNDqpKZN958oAHsfOz60EC3SrMbyxeJH/FxsZ+YjwLDQx1g4pEpDHsM9/WYyhPcw2PkBXCrblOEX7No5nOEFQt6gZOGVuF91nQptwXB1wWGpepvhOOzo9LkE6Tt3iKephof8VbnINgEa5wBuQCwFcY4nannoMw5zLiiJuhlO/3VrIsNu0uZQBsKR9YX9GaysDuRCsptG3OQZUCqXguhngg5P3PB9g8q0+4dbRch1VvToHT784k9+mTlOPJpTD6z/qCGKXdCUrol5p2o9VgRLuDoXgM9KsvkMK4+/MWQZ52Hj6vzRplbzTHxrIpw7uVHv6GXFz56DizbjmGf9Gf/VKHAcKIbqjcHe/mWCnySuxwtLXE1wCBCsdWN2+x99iNNIVfCMkqhvPnRN47kU25M4E4/3sjGD31LEFMaoSJ1zcYj3mF9/a3hjhbEzOKwmNggPrrUchI26wdpfqc8KzSqgod8NZe3t++Mp7sxRM+PWYdD/6i+sM7zWSNYarwMNEXLL2ThrPecedmVOdZ+tdKOcgo7xtE/2nRqeVxYVoy2r2PfVOaxAKEKBlzNPEy8cilw2xOhhf+77zV/dwqrxYkqopMHl+mV3AC+7INkxJoT7ZgjAAeprKwzizAlxv1KF7Zo/91B5iBhUvVDjNIUvenlbk1A4jl7kjNZsmTXMsLuDgT/KcQSyubq7isBLQa07vy5vqsjuC8ixABHn8aopDIJefY81EYIAct0ACuGLIjhoAwm44yrWRA1/2lCJTfZO/4Uf9dSP6jVzBhqfH5WN3i+6T50nxQCL3rZAUZegau2BjVD740UGdpd693o6Fs7VqYB9Cy7QZ/YmBbc/qmKR4V9VY4rQUOQ+H+GukTR3mlAX2CVrw0eX9rSbccR8qSkVnGZHz6MIIfScYho/LLew/dU5g+UlKA7oCs
 8S8uGE5p
 ZuzYSuH1mATcNQd8CmaUQ8D9NUrzjUS8df1ADp1m2fnixcIhucamucKlPbhAZ2j2vT52MzhQ9Oz8EM0NGDRLqQAh/UckxlQ6HrExkgWU+lV0l7A4ijyrqpZIwHKXvbyPAEZo6cRVOt5Wq+eKX5wiEkKhGZIShsQVbCXusz9agW66YQE5DFDj9wqvB+63cUfpeBVAB+FvVuM1GYHpNjwwp5Xsz0zyihRseblv6w/nahy9X5ndpgqNQ4y2LsMTnKLQk0g/K9m3r+nPqLt7aOn6Eu/MuhyIDXewJSa+4nMen7pVIJkeeYhg8HvX1n/93gU4dETRVN5NpQ52skg6xRIrqzVNJclbJzazo9hOHvmARydieWFWeDVtovA6KMCftmnPZuZt338b3U+kmyO3JNwSpgEtPga5c2RwuiL/jwdl9+KoDLReOGgX5UHkhwTlu3CWcBa2YucVqe6B2p7xpau94FCQyUV7+7P7h4wQ6HFdYJGhD0Y2yDyKEM59Ltg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now, the swap cache is managed by the swap table. All swap cache users
are checking the swap table directly to check the swap cache state.
SWAP_HAS_CACHE is now just a temporary pin before the first increase
from 0 to 1 of a slot's swap count (swap_dup_entries), or before the
final free of slots pinned by folio in swap cache (put_swap_folio).

Drop these two usages. For the first dup, SWAP_HAS_CACHE pinning was
hard to kill because it used to have multiple meanings, more than just
"a slot is cached". We have simplified that and just defined that the
first dup is always done with folio locked in swap cache (folio_dup_swap),
so it can just check the swap cache (swap table) directly.

As for freeing, just let the swap cache free all swap entries of a folio
that have a swap count of zero directly upon folio removal. We have also
just cleaned up freeing to cover the swap cache usage in the swap table,
a slot with swap cache will not be freed until its cache is gone.
Now, making the removal of a folio and freeing the slots being done in
the same critical section, this should improve the performance and gets
rid of the SWAP_HAS_CACHE pin.

After these two changes, SWAP_HAS_CACHE no longer has any users. Remove
all related logic and helpers. swap_map is now only used for tracking
the count, so all swap_map users can just need to read it directly,
ignoring the swap_count helper, which was previously used to filter out
the SWAP_HAS_CACHE bit.

The idea of dropping SWAP_HAS_CACHE and using the swap table directly
was initially from Chris's idea of merging all the metadata usage of all
swaps into one place.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   1 -
 mm/swap.h            |  13 ++--
 mm/swap_state.c      |  28 +++++----
 mm/swapfile.c        | 168 +++++++++++++++++----------------------------------
 4 files changed, 77 insertions(+), 133 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4b4b81fbc6a3..dcb1760e36c3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -224,7 +224,6 @@ enum {
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /* Bit flag in swap_map */
-#define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
 #define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
 
 /* Special value in first swap_map */
diff --git a/mm/swap.h b/mm/swap.h
index 3692e143eeba..b2d83e661132 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -205,6 +205,11 @@ int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap(struct folio *folio, struct page *subpage);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
+/* For internal use */
+extern void swap_entries_free(struct swap_info_struct *si,
+			      struct swap_cluster_info *ci,
+			      unsigned long offset, unsigned int nr_pages);
+
 /* linux/mm/page_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
@@ -256,14 +261,6 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
-/* Temporary internal helpers */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry);
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr);
-
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
  * used are valid and stablize the device by any of the following ways:
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 94b6d368e3e8..2251ab8e569e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -211,17 +211,6 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 			shadow = swp_tb_to_shadow(old_tb);
 		offset++;
 	} while (++ci_off < ci_end);
-
-	ci_off = ci_start;
-	offset = swp_offset(entry);
-	do {
-		/*
-		 * Still need to pin the slots with SWAP_HAS_CACHE since
-		 * swap allocator depends on that.
-		 */
-		__swapcache_set_cached(si, ci, swp_entry(swp_type(entry), offset));
-		offset++;
-	} while (++ci_off < ci_end);
 	__swap_cache_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
@@ -252,6 +241,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	struct swap_info_struct *si;
 	unsigned long old_tb, new_tb;
 	unsigned int ci_start, ci_off, ci_end;
+	bool folio_swapped = false, need_free = false;
 	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_ONCE(__swap_entry_to_cluster(entry) != ci);
@@ -269,13 +259,27 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 		old_tb = __swap_table_xchg(ci, ci_off, new_tb);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
 			     swp_tb_to_folio(old_tb) != folio);
+		if (__swap_count(swp_entry(si->type,
+				 swp_offset(entry) + ci_off - ci_start)))
+			folio_swapped = true;
+		else
+			need_free = true;
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-	__swapcache_clear_cached(si, ci, entry, nr_pages);
+
+	if (!folio_swapped) {
+		swap_entries_free(si, ci, swp_offset(entry), nr_pages);
+	} else if (need_free) {
+		do {
+			if (!__swap_count(entry))
+				swap_entries_free(si, ci, swp_offset(entry), 1);
+			entry.val++;
+		} while (--nr_pages);
+	}
 }
 
 /**
diff --git a/mm/swapfile.c b/mm/swapfile.c
index dd1a138ae265..eea904dc08d9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,21 +48,18 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
+#include "swap_table.h"
 #include "swap.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long start, unsigned int nr_pages);
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
 static int __swap_duplicate(swp_entry_t entry, unsigned char usage, int nr);
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage);
+				  unsigned long offset);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -149,11 +146,6 @@ static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
 	return swap_type_to_info(swp_type(entry));
 }
 
-static inline unsigned char swap_count(unsigned char ent)
-{
-	return ent & ~SWAP_HAS_CACHE;	/* may include COUNT_CONTINUED flag */
-}
-
 /*
  * Use the second highest bit of inuse_pages counter as the indicator
  * if one swap device is on the available plist, so the atomic can
@@ -185,15 +177,20 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 #define TTRS_FULL		0x4
 
 static bool swap_only_has_cache(struct swap_info_struct *si,
-			      unsigned long offset, int nr_pages)
+				struct swap_cluster_info *ci,
+				unsigned long offset, int nr_pages)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned char *map = si->swap_map + offset;
 	unsigned char *map_end = map + nr_pages;
+	unsigned long swp_tb;
 
 	do {
-		VM_BUG_ON(!(*map & SWAP_HAS_CACHE));
-		if (*map != SWAP_HAS_CACHE)
+		swp_tb = __swap_table_get(ci, ci_off);
+		VM_WARN_ON_ONCE(!swp_tb_is_folio(swp_tb));
+		if (*map)
 			return false;
+		++ci_off;
 	} while (++map < map_end);
 
 	return true;
@@ -248,12 +245,12 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 		goto out_unlock;
 
 	/*
-	 * It's safe to delete the folio from swap cache only if the folio's
-	 * swap_map is HAS_CACHE only, which means the slots have no page table
+	 * It's safe to delete the folio from swap cache only if the folio
+	 * is in swap cache with swap count == 0. The slots have no page table
 	 * reference or pending writeback, and can't be allocated to others.
 	 */
 	ci = swap_cluster_lock(si, offset);
-	need_reclaim = swap_only_has_cache(si, offset, nr_pages);
+	need_reclaim = swap_only_has_cache(si, ci, offset, nr_pages);
 	swap_cluster_unlock(ci);
 	if (!need_reclaim)
 		goto out_unlock;
@@ -779,7 +776,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 
 	spin_unlock(&ci->lock);
 	do {
-		if (swap_count(READ_ONCE(map[offset])))
+		if (READ_ONCE(map[offset]))
 			break;
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
@@ -809,7 +806,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	 */
 	for (offset = start; offset < end; offset++) {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
-		if (swap_count(map[offset]) || !swp_tb_is_null(swp_tb))
+		if (map[offset] || !swp_tb_is_null(swp_tb))
 			return false;
 	}
 
@@ -829,11 +826,10 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		return true;
 
 	do {
-		if (swap_count(map[offset]))
+		if (map[offset])
 			return false;
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		if (swp_tb_is_folio(swp_tb)) {
-			WARN_ON_ONCE(!(map[offset] & SWAP_HAS_CACHE));
 			if (!vm_swap_full())
 				return false;
 			*need_reclaim = true;
@@ -891,11 +887,6 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
-		/*
-		 * Pin the slot with SWAP_HAS_CACHE to satisfy swap_dup_entries.
-		 * This is the legacy allocation behavior, will drop it very soon.
-		 */
-		memset(si->swap_map + offset, SWAP_HAS_CACHE, nr_pages);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else {
 		order = 0;
@@ -1008,8 +999,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (!swap_count(READ_ONCE(map[offset])) &&
-			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
+			if (!READ_ONCE(map[offset]) &&
+			    swp_tb_is_folio(swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1111,7 +1102,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		 * Scan only one fragment cluster is good enough. Order 0
 		 * allocation will surely success, and large allocation
 		 * failure is not critical. Scanning one cluster still
-		 * keeps the list rotated and reclaimed (for HAS_CACHE).
+		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
 		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
@@ -1442,8 +1433,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 	do {
 		swp_tb = __swap_table_get(ci, offset % SWAPFILE_CLUSTER);
 		count = si->swap_map[offset];
-		VM_WARN_ON(swap_count(count) < 1 || count == SWAP_MAP_BAD);
-		if (swap_count(count) == 1) {
+		VM_WARN_ON(count < 1 || count == SWAP_MAP_BAD);
+		if (count == 1) {
 			/* count == 1 and non-cached slots will be batch freed. */
 			if (!swp_tb_is_folio(swp_tb)) {
 				if (!batch_start)
@@ -1451,7 +1442,6 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 				continue;
 			}
 			/* count will be 0 after put, slot can be reclaimed */
-			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
 			need_reclaim = true;
 		}
 		/*
@@ -1460,7 +1450,7 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 		 * slots will be freed when folio is removed from swap cache
 		 * (__swap_cache_del_folio).
 		 */
-		swap_put_entry_locked(si, ci, offset, 1);
+		swap_put_entry_locked(si, ci, offset);
 		if (batch_start) {
 			swap_entries_free(si, ci, batch_start, offset - batch_start);
 			batch_start = SWAP_ENTRY_INVALID;
@@ -1613,7 +1603,8 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]))
+	if (data_race(!si->swap_map[swp_offset(entry)]) &&
+	    !swap_cache_has_folio(entry))
 		goto bad_free;
 	return si;
 
@@ -1634,21 +1625,12 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long offset,
-				  unsigned char usage)
+				  unsigned long offset)
 {
 	unsigned char count;
-	unsigned char has_cache;
 
 	count = si->swap_map[offset];
-
-	has_cache = count & SWAP_HAS_CACHE;
-	count &= ~SWAP_HAS_CACHE;
-
-	if (usage == SWAP_HAS_CACHE) {
-		VM_BUG_ON(!has_cache);
-		has_cache = 0;
-	} else if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
+	if ((count & ~COUNT_CONTINUED) <= SWAP_MAP_MAX) {
 		if (count == COUNT_CONTINUED) {
 			if (swap_count_continued(si, offset, count))
 				count = SWAP_MAP_MAX | COUNT_CONTINUED;
@@ -1658,10 +1640,8 @@ static void swap_put_entry_locked(struct swap_info_struct *si,
 			count--;
 	}
 
-	usage = count | has_cache;
-	if (usage)
-		WRITE_ONCE(si->swap_map[offset], usage);
-	else
+	WRITE_ONCE(si->swap_map[offset], count);
+	if (!count && !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
 		swap_entries_free(si, ci, offset, 1);
 }
 
@@ -1730,21 +1710,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 }
 
-/*
- * Check if it's the last ref of swap entry in the freeing path.
- */
-static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
-{
-	return (count == SWAP_HAS_CACHE) || (count == 1);
-}
-
 /*
  * Drop the last ref of swap entries, caller have to ensure all entries
  * belong to the same cgroup and cluster.
  */
-static void swap_entries_free(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      unsigned long offset, unsigned int nr_pages)
+void swap_entries_free(struct swap_info_struct *si,
+		       struct swap_cluster_info *ci,
+		       unsigned long offset, unsigned int nr_pages)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
 	unsigned char *map = si->swap_map + offset;
@@ -1757,7 +1729,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
+		VM_WARN_ON(*map > 1);
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1776,7 +1748,7 @@ int __swap_count(swp_entry_t entry)
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
-	return swap_count(si->swap_map[offset]);
+	return si->swap_map[offset];
 }
 
 /**
@@ -1790,7 +1762,7 @@ bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	swap_cluster_unlock(ci);
 
 	return count && count != SWAP_MAP_BAD;
@@ -1817,7 +1789,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	if (!(count & COUNT_CONTINUED))
 		goto out;
 
@@ -1855,12 +1827,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 
 	ci = swap_cluster_lock(si, offset);
 	if (nr_pages == 1) {
-		if (swap_count(map[roffset]))
+		if (map[roffset])
 			ret = true;
 		goto unlock_out;
 	}
 	for (i = 0; i < nr_pages; i++) {
-		if (swap_count(map[offset + i])) {
+		if (map[offset + i]) {
 			ret = true;
 			break;
 		}
@@ -2014,7 +1986,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_put_entry_locked(si, ci, offset, 1);
+	swap_put_entry_locked(si, ci, offset);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -2420,6 +2392,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
+	unsigned long swp_tb;
 	unsigned char count;
 
 	/*
@@ -2430,7 +2403,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 */
 	for (i = prev + 1; i < si->max; i++) {
 		count = READ_ONCE(si->swap_map[i]);
-		if (count && swap_count(count) != SWAP_MAP_BAD)
+		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
+					i % SWAPFILE_CLUSTER);
+		if (count == SWAP_MAP_BAD)
+			continue;
+		if (count || swp_tb_is_folio(swp_tb))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
 			cond_resched();
@@ -3655,8 +3632,7 @@ void si_swapinfo(struct sysinfo *val)
  * Returns error code in following case.
  * - success -> 0
  * - swp_entry is invalid -> EINVAL
- * - swap-cache reference is requested but there is already one. -> EEXIST
- * - swap-cache reference is requested but the entry is not used. -> ENOENT
+ * - swap-mapped reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
 static int swap_dup_entries(struct swap_info_struct *si,
@@ -3665,39 +3641,28 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			    unsigned char usage, int nr)
 {
 	int i;
-	unsigned char count, has_cache;
+	unsigned char count;
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-
 		/*
 		 * Allocator never allocates bad slots, and readahead is guarded
 		 * by swap_entry_swapped.
 		 */
-		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD))
+		if (WARN_ON(count == SWAP_MAP_BAD))
 			return -ENOENT;
-
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (!count && !has_cache) {
+		/*
+		 * Swap count duplication must be guarded by either locked swap cache
+		 * folio (from folio_dup_swap) or external lock (from swap_dup_entry_direct).
+		 */
+		if (WARN_ON(!count &&
+			    !swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))))
 			return -ENOENT;
-		} else if (usage == SWAP_HAS_CACHE) {
-			if (has_cache)
-				return -EEXIST;
-		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
-			return -EINVAL;
-		}
 	}
 
 	for (i = 0; i < nr; i++) {
 		count = si->swap_map[offset + i];
-		has_cache = count & SWAP_HAS_CACHE;
-		count &= ~SWAP_HAS_CACHE;
-
-		if (usage == SWAP_HAS_CACHE)
-			has_cache = SWAP_HAS_CACHE;
-		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
+		if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
 		else if (swap_count_continued(si, offset + i, count))
 			count = COUNT_CONTINUED;
@@ -3709,7 +3674,7 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			return -ENOMEM;
 		}
 
-		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
+		WRITE_ONCE(si->swap_map[offset + i], count);
 	}
 
 	return 0;
@@ -3755,27 +3720,6 @@ int swap_dup_entry_direct(swp_entry_t entry)
 	return err;
 }
 
-/* Mark the swap map as HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_set_cached(struct swap_info_struct *si,
-			    struct swap_cluster_info *ci,
-			    swp_entry_t entry)
-{
-	WARN_ON(swap_dup_entries(si, ci, swp_offset(entry), SWAP_HAS_CACHE, 1));
-}
-
-/* Clear the swap map as !HAS_CACHE, caller need to hold the cluster lock */
-void __swapcache_clear_cached(struct swap_info_struct *si,
-			      struct swap_cluster_info *ci,
-			      swp_entry_t entry, unsigned int nr)
-{
-	if (swap_only_has_cache(si, swp_offset(entry), nr)) {
-		swap_entries_free(si, ci, swp_offset(entry), nr);
-	} else {
-		for (int i = 0; i < nr; i++, entry.val++)
-			swap_put_entry_locked(si, ci, swp_offset(entry), SWAP_HAS_CACHE);
-	}
-}
-
 /*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
@@ -3821,7 +3765,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*

-- 
2.52.0


