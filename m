Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFCFD29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70366B00D6; Thu,  4 Dec 2025 14:31:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21346B00D7; Thu,  4 Dec 2025 14:31:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0D56B00D8; Thu,  4 Dec 2025 14:31:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75FA56B00D6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:31:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DCA0133050
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:31:05 +0000 (UTC)
X-FDA: 84182781690.01.0E93256
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E6A2A0017
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:31:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ef20TYC1;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeUUnUTgOhElk0LOsWkR6GIkfqMFk43LYBQi8AJ9ASc=;
	b=ac0+wgdRTv9fNmDEb3Luxt+jMhK2HAPIo2HnKE7tYPlTRQQOIKXtkS8k54svargCvOhgGx
	Ulvvji4obMxpUS6YFv+oL6dtTTagnBixqWRjSVzCFWYjxhVH5Msv+L/NzpAnw56odmeYmX
	uiS4J/adLgXEAdprxKttOevjYStuqII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876663; a=rsa-sha256;
	cv=none;
	b=HGqK2yAczdO6w5Z8f4qmTG9nAVsb9jYjFLINdodp//QQCj1TuO5BVZXsphb1s74n+N5YLT
	Dgd2Se+h9YbxDK2wD9kDAxE6t7alnSNZEeAxQnK6d8qkPq80U0o/unbZ2ABeytNj+WhfVu
	ChZKdgnqwx4dUk6TOy9LoX0QuNRX5KU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ef20TYC1;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso1121240b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876662; x=1765481462; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MeUUnUTgOhElk0LOsWkR6GIkfqMFk43LYBQi8AJ9ASc=;
        b=ef20TYC1NYId8j/qPs3YFeFtHeTRd/tQXPnGgext8/9BSQq/v6cDLtgpY3F0AlGXfY
         K3nMhmTOlBXflQr27O4vku01gh+Tu23EIY/aeVva/s+YAFj+ErpBloyvQeXA8UYGHpBd
         /wPfEJLY1iLvN2LrI952JJEqSkq+KCE+g6wJQkDwAYsZW910UzGNyW2ycWasvoACXO88
         HzCICc1yFIVLpSABJRZr9CBNUbrLes9oJJzwPDTUUtiGYQ+ES2aj2PwV9YL4TiHDc98V
         FyTs7ikn2nZ7/oamEX6E5Cu2Xyn5VT/LBuQXai/AAgAcPP09OgkBZWLwtdD9Ga+qDrKn
         M11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876662; x=1765481462;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MeUUnUTgOhElk0LOsWkR6GIkfqMFk43LYBQi8AJ9ASc=;
        b=Yr6DwMhebAiiJzI4ubl8kOPtRb4RLrhYT/9iToMk/BtZ7F1g0ksmSIlI6dGHY41VIQ
         S5C2+PjdJnmqL0oEJ9gWmGeSCYk9E75nB8keTZCXWL+P4lO12MqcoqNwVziOXUWL9wjy
         npuRxi7Gju9vkLaJOqYwWEqRYbD/8Sj0Q0rF8CYe/NZB93ct4q/xofRB5vpGIDTtcDqq
         BS2KaTyrbylmZ6scEQGpxMImL4TgIcNFMN9fJPRhB03An1MTtSjLwG2DQY0I3y4N0jtp
         pBdVZDQJRD/ITEg7PeEdd84L8hS3bHDBA+uE09/sKxfAiTlZE73j7K6XlOm9uMl4DQEE
         ugZw==
X-Gm-Message-State: AOJu0YzApAEKlofNzxY3oQ8hMKZ6Lp3QaOfdmSh0ZvYQ4WzrDxTOmW5d
	tCBlJXAHpyxBAZXsQsJkOmcuRr7iQGqBJ3Y1N+/dthDrSMKPB2N+k8ocPq0M80dO8S8=
X-Gm-Gg: ASbGnctKCE9pQIGvQ4Eh4EfMVBs7qG5EdONg7buFuJ2zkBQ60nCZamH9GUu4SpsVgWz
	/LKD75qzuTzEpTcktyN2yFZyMpwkeewyYSv30pAUu3z57k8nZjFOjzwNn/gOjstv5zqNWs8Jr/I
	d544AZG85IW7uUi31nAuVuIxSysf4bfUnklY7JsHcNkHM2Zd9ct7/N3btwOUgeOK/Y6xEIHtF33
	FYmt31ue0uiTpOtGdKlZfvxEPJ9itNolRdOGYoQHox81w0FBObJ5AESgGw2Ocq0NZ/SJitNAETJ
	YUVVLsMmBXiWEJD4c7dilguOO6rVhhAFu0kRHbHTPSWkxKbEzRdlG/tuvDNgcZ5ZdlYseHlN2cM
	IB/JR/KVnQRPd1vYu+QmgZyFbDUAUL8lLLtVcis62KT/NtPDHLhcwCTG0I0w2hCh9DlV5Acyttm
	iMPMQJPLTPGDJ5p/FPYnpyuMMnPfaKUBH7+lYdub8ECF9N8czb
X-Google-Smtp-Source: AGHT+IFfHx/DyyEDIZPDCoYw/3n9uD7qeNZ0V+Fhh7xlgQ9bh5fuD8z6iLxw4co+EZZ8rITY+p1tjA==
X-Received: by 2002:a05:6a20:7293:b0:35b:d302:e7be with SMTP id adf61e73a8af0-3640375de1bmr4860549637.2.1764876661594;
        Thu, 04 Dec 2025 11:31:01 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:31:01 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:26 +0800
Subject: [PATCH v4 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-18-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=20781;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pqFC+9PY37MQVaXQsYUS5RYpdyliymttf/rG5+As3Bo=;
 b=ZlnXEoVEzNNHF8sNLb3RMAAjk4FyGVb18P4035YMYSs5jHx7qtLNX8ZAKB8swwtf3Dk4rkwyb
 Py56dbiqFx2CB7VUOL5tegXugCaQ9/YNwc43C9AqCdetIcrmmxLoxoI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E6A2A0017
X-Stat-Signature: 9swdttjwueypyxa77huzsaqr1j1hrps4
X-Rspam-User: 
X-HE-Tag: 1764876662-49945
X-HE-Meta: U2FsdGVkX18pQTohscm1NrRk8SeXlhVCwVXlkeqkbsVJRnnbz/fKD7u83LQkOaXIefesOErWfnaim/VYI3DZlhp8PS2qpWcGqhViLmW2/nkhx7o65SZB2KHvD9vRuWNHlhuMqDiKGT0Q83QXPfs1JC57DCdVpk0rHpDkfhQ73Yo8O2niCyG8HVbBq0HDwS2YftA6OnHAI/IZTpKvyt1gANPjxeSBhMBWZ3eFe1JBzJKXFjHy6Edh3uVvIAhD4WLMcRYXdcogT+gAK45M/9w21s7dY1+qD6lPJVveeY631nQ1+O5T/NNdJdssQXOmYiWsUhwip058Hcj5w0b96DGrrPPJG2Y2D2QR4zzB/nvq/+B3jl1E2N2t6X2XGmrY57hGKVRItZ5RBxlBkWSkOArqG6Mra9RAsBUshtyjEneIoUKYyA9HF4X3yYDOyBNXFsEZBOWT+afjlJjFw0DS1SwTXJONiTkzBaD9ODofXuqQlV8+Cs9XwvRpO0iPFUQgiQ5Na7DuCTwXEux8H2AZIkQKEaWZxNks5n3ZH3GIPV4M9wjlcdxVI4W8KfvJTMmxPYNw9A5RTlAweYf8gbfeEq0405oZ8XCbwadEVitw4021UKLXYIBUtKeUfNz9yAaVelP/iUx8+o2m+iOTAMq3T6n6FLm2zHxCYYy6yUaueEPVRbHnV/ILDKMJoLffjI+22G9RSTm36lno208MlpCvqcaDNl7wImbsB/ps4CcAjaCNzl8+LE3cdFOWTGWMBcUtaKNA0aXjxiwtBEGilcKNhZML/kAExsTgPGl1ZsXLMA/ib8JAtkbciJwD8QXf8Q6xPn7hKNR2ongF/FW0kNGToWvDzMV7isAHWQMIF5hh0+L6MT4crQo9u9dCMpt345umbRks2K7yxrcvvmn4U9rcRd8tS8tU6B2HP6TGR136xiAJgM26kxhTwjLGQz8KWbpCQeQ3rxX+hxeqT7J8Wbua7TB
 DBGiU4aB
 CZSql6VMszCFfW/d5BFqFvOslYekHdkA5DTYq9hIC+jpLLqJhP7y3LaSBzPt1fMhpw2nTb3lQvKjDGZEAXzgvNNslBUa4eJVWPdo46M9RCLRhNXXH3oc4uH5Ts9wh5x54YvK8ede4yafCMxyQPdtPW6M8TVEqBDUoa7byiw8E3R7fZCUu7OC+cJc9dJw71+vqC4f7fKLBfqbrXt95lJGVX3xHUHvxOPwSeZqKtNNQFagZUdSuAGusDdkR7aY9Gf5zEgWN1/4rdI27T+Aey6+Ej54vjZiMHg0hl/+CTbPOaKdNGUfxfh8a+0O97hUhTXCFELKWne9avR4WMPR8XahthwxflkyPw3LYgVDs/uPPH8s28+6h2z06CXqtGVjTiuWjP4N2OMwBurvFnVVJeREUb8XPTeFcetyK54rN47AzSpDma0C4wQof458FM3kVH+bXfSPbAhpqNnFgSKM8MFz3ofIAmA==
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
index 6bf7556ca408..ed921cef222d 100644
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
index 979f0c562115..50ed2d7f5b85 100644
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
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
@@ -1012,8 +1003,8 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan--;
 
 		while (offset < end) {
-			if (!swap_count(READ_ONCE(map[offset])) &&
-			    swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
+			if (!READ_ONCE(map[offset]) &&
+			    swp_tb_is_folio(swap_table_get(ci, offset % SWAPFILE_CLUSTER))) {
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
@@ -1115,7 +1106,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		 * Scan only one fragment cluster is good enough. Order 0
 		 * allocation will surely success, and large allocation
 		 * failure is not critical. Scanning one cluster still
-		 * keeps the list rotated and reclaimed (for HAS_CACHE).
+		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
 		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
 		if (found)
@@ -1450,8 +1441,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
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
@@ -1459,7 +1450,6 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 				continue;
 			}
 			/* count will be 0 after put, slot can be reclaimed */
-			VM_WARN_ON(!(count & SWAP_HAS_CACHE));
 			need_reclaim = true;
 		}
 		/*
@@ -1468,7 +1458,7 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 		 * slots will be freed when folio is removed from swap cache
 		 * (__swap_cache_del_folio).
 		 */
-		swap_put_entry_locked(si, ci, offset, 1);
+		swap_put_entry_locked(si, ci, offset);
 		if (batch_start) {
 			swap_entries_free(si, ci, batch_start, offset - batch_start);
 			batch_start = SWAP_ENTRY_INVALID;
@@ -1625,7 +1615,8 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 	offset = swp_offset(entry);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_offset(entry)]))
+	if (data_race(!si->swap_map[swp_offset(entry)]) &&
+	    !swap_cache_has_folio(entry))
 		goto bad_free;
 	return si;
 
@@ -1646,21 +1637,12 @@ static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 
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
@@ -1670,10 +1652,8 @@ static void swap_put_entry_locked(struct swap_info_struct *si,
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
 
@@ -1742,21 +1722,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
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
@@ -1769,7 +1741,7 @@ static void swap_entries_free(struct swap_info_struct *si,
 
 	ci->count -= nr_pages;
 	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
+		VM_WARN_ON(*map > 1);
 		*map = 0;
 	} while (++map < map_end);
 
@@ -1788,7 +1760,7 @@ int __swap_count(swp_entry_t entry)
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	pgoff_t offset = swp_offset(entry);
 
-	return swap_count(si->swap_map[offset]);
+	return si->swap_map[offset];
 }
 
 /**
@@ -1802,7 +1774,7 @@ bool swap_entry_swapped(struct swap_info_struct *si, unsigned long offset)
 	int count;
 
 	ci = swap_cluster_lock(si, offset);
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	swap_cluster_unlock(ci);
 
 	return count && count != SWAP_MAP_BAD;
@@ -1829,7 +1801,7 @@ int swp_swapcount(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 	if (!(count & COUNT_CONTINUED))
 		goto out;
 
@@ -1867,12 +1839,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 
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
@@ -2026,7 +1998,7 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 		return;
 
 	ci = swap_cluster_lock(si, offset);
-	swap_put_entry_locked(si, ci, offset, 1);
+	swap_put_entry_locked(si, ci, offset);
 	WARN_ON(swap_entry_swapped(si, offset));
 	swap_cluster_unlock(ci);
 
@@ -2432,6 +2404,7 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 					unsigned int prev)
 {
 	unsigned int i;
+	unsigned long swp_tb;
 	unsigned char count;
 
 	/*
@@ -2442,7 +2415,11 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -3667,8 +3644,7 @@ void si_swapinfo(struct sysinfo *val)
  * Returns error code in following case.
  * - success -> 0
  * - swp_entry is invalid -> EINVAL
- * - swap-cache reference is requested but there is already one. -> EEXIST
- * - swap-cache reference is requested but the entry is not used. -> ENOENT
+ * - swap-mapped reference is requested but the entry is not used. -> ENOENT
  * - swap-mapped reference requested but needs continued swap count. -> ENOMEM
  */
 static int swap_dup_entries(struct swap_info_struct *si,
@@ -3677,39 +3653,28 @@ static int swap_dup_entries(struct swap_info_struct *si,
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
@@ -3721,7 +3686,7 @@ static int swap_dup_entries(struct swap_info_struct *si,
 			return -ENOMEM;
 		}
 
-		WRITE_ONCE(si->swap_map[offset + i], count | has_cache);
+		WRITE_ONCE(si->swap_map[offset + i], count);
 	}
 
 	return 0;
@@ -3767,27 +3732,6 @@ int swap_dup_entry_direct(swp_entry_t entry)
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
@@ -3833,7 +3777,7 @@ int add_swap_count_continuation(swp_entry_t entry, gfp_t gfp_mask)
 
 	ci = swap_cluster_lock(si, offset);
 
-	count = swap_count(si->swap_map[offset]);
+	count = si->swap_map[offset];
 
 	if ((count & ~COUNT_CONTINUED) != SWAP_MAP_MAX) {
 		/*

-- 
2.52.0


