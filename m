Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 728B7CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2C08E0018; Fri,  5 Sep 2025 15:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C729F8E0001; Fri,  5 Sep 2025 15:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A108E0018; Fri,  5 Sep 2025 15:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8718E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D21113A6DE
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:24 +0000 (UTC)
X-FDA: 83856147648.23.E1FD5AF
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B7DB100012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MWrqXNqb;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPAOWrCpwpbR9rVPMUrX0Qp8nhk8aV7LnM+BJcLKRk0=;
	b=NPaxK39abTlCmJeuBPaEzEOQYZqkHgiUON343qhzaa98nMZNvLlMKfQl2I6oV10ZAOXpIc
	VXYR3qx7yrR0anKIJhj8o6O/UlEoBjKzgkqHj2Ogi6M+DrLLy53iHIhhqloz1H52FYQZiy
	jQUd/w4cYt+IT0lkOmnQvwjWfu6pt14=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MWrqXNqb;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099662; a=rsa-sha256;
	cv=none;
	b=dP9wrkI5Mg1d/RIF6grkGckZ1Pjcj72mLjmrRB7UFiJovLE+esPdlKjMWOgr9jnTkUNqBc
	M1Cd2DwL3ISqx/9H0e+NSMT2ljOfQMLUUMA7k0/yD2bog/qxT0t01GQJyWu6SytYqYWpUQ
	y2NhBqctWmyZY3n+HFYvE7Zj8rWwvSw=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-772481b2329so2640100b3a.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099661; x=1757704461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oPAOWrCpwpbR9rVPMUrX0Qp8nhk8aV7LnM+BJcLKRk0=;
        b=MWrqXNqbvkDUp78lPTlU17FPBNUlEtml22lqgZRXLSehM8GOhHsVBBb6rujEXrRtvw
         Psg+LCJVgTqUyax3MepKRvQQM6UDFlHMpnIwPxokJgG+XqoE2xiU4CwCMJNvBKmaPSy2
         sEy2yFEyD2prlLPhnb1JFtjfHywKe8oeI4iZVtA4eT7UmHYYWi4+Qr09w7LCVMsES7G/
         H5eLLwuQW6hRS/nQm6nkAvV2CYJXnzOxWZa6MqcpiTkre+9dRU9c01F2o0EpC7Mf7z8T
         Fexlsp9nA54EDLJN2MGeiyjbLfQ7RAB4RNeilhI1nLpXVkYSRpgUkALiLvsgbWKHN5Eh
         2xUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099661; x=1757704461;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oPAOWrCpwpbR9rVPMUrX0Qp8nhk8aV7LnM+BJcLKRk0=;
        b=fXMuFQl5r8NWFFEWZY827vxCg/IkJqs10eolri43gUM7szOk9Upga2awb/d7SLHhAZ
         iWBJCffHaTeCUkV9DbdQ3SSlhZSVwXNoUV1VufNvwYtb7Rb1mh/KRSV8io3Ynqq/eg/8
         /+kNlPz7pvPFC5EkSwxElTDZKYFqioMQzZwTjR0yX9ovA3Y0f46yPeWxpDNIKpISLCzx
         9ejgd1rCCigElJvX5A9c0HSAWcz3WJjtRYw/T0ihCblb7EnGkMlsPj9LfyJCNuQTqNgq
         EKg1dYhtfKyY07Agn8YbVNDiw5FisNixXOpoJzwIp5vSDZ2NMY3XIeHZYJtF9vCJ3m0u
         JkEg==
X-Gm-Message-State: AOJu0YwRLdgqvqwm836w+XL/hvgLIO7uhkTKQVrk2xNeD1bLf2tey732
	9gtDTJIBnJBlHFZ61T0/mY42VaK8vkXtM++w+LkV0UNKSZwkqbPPR/hNEewTGCYpgD8=
X-Gm-Gg: ASbGncsjivmTkRXcKGu/qVcrmO/F3dN74R2ScsJmbwQluZJbsm4uz2BeQpACUse0ctJ
	PrJMHTS5o7JULrSR+IRwGI5URaaYkPUwr7uKw4SezTl/B1z1VHSWBKMuxD8gJND7/tMyut72zi3
	XvMv5Ubcd9HQc/HVrRFhjgG6nLEFVpKs5zWqpi1vHoXQDWke/hhGdQed6t0d4E5sk5vcG4ab7MV
	NBX2rrl5F466wshR/GYPCSQ48WhsxZks3uY7ghpKwFUhL7iaqIM5B8T/Yot2FIodO+Ydkkzw95i
	Dej49/TKX/9PL/a7vgdSW4hm4VUseD294LL5Z75wz0WZU8ko5grAER9py6IvHJenHCjIKBMjzYZ
	/YP9ghOYwezsHRHCSrx03nw3r+GQRmc1u8TnqpxMGUPDdMvvFWFr2M4CDTw==
X-Google-Smtp-Source: AGHT+IEVx2SUdnlXnTbUzYeaXXSinO95wJgf+dR2LlFdFQaVChU5ZU3mt8Ll6c0HJcL8428E5cqOnw==
X-Received: by 2002:a05:6a00:848:b0:772:5d0f:6c9b with SMTP id d2e1a72fcca58-7725d0f6f0cmr23220397b3a.1.1757099660578;
        Fri, 05 Sep 2025 12:14:20 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:20 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 02/15] mm, swap: use unified helper for swap cache look up
Date: Sat,  6 Sep 2025 03:13:44 +0800
Message-ID: <20250905191357.78298-3-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B7DB100012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tjok9addq35eqbqgji97tqrppapufc6i
X-HE-Tag: 1757099662-243274
X-HE-Meta: U2FsdGVkX1+fyoayhiPaspSVYhTt8BwHH7j/jbHjHIMaJ3oOcBYfyNmbwwJRfAO0oJdEHe6sDwcyx/GHEnvhC2pZDVXu8oZVs2CXH9Ey/46VCnYRpBbkbRBoBlNc9cwD+ghQr4Che5P5AxF7Dm5LQRQgTP7/NwMkGk7K7TU2ReAWaVco2bhKEJGqw7ITJ34O8tFcTpX84AG2O8kEIRjBooRHt+4xt2KJ0xX98SCQCVADUYCWf5XUcOxhUlERz64qOPKz2cnUPnxRrNgApVCGUpFnFYUSPZITksWuWy6ymp3qMqA03gZCSAbq5Wu0W/vLtebdE7/CwUE9P5ZQmczyXwjfkxQ3vEpzjxL9CA2b6FYkajGd6htO8xlT1ADZ+Qy2iHjCMg7PJp/cfG/R5iCgepetFLtuLGmftDa8yVvaA742o9KJo4m4Tf9gBTTcLiSjhHccZRhlch/c8StgqbxpJe1RhL1RSIi6qjjCGbVd72sJ2K4Jef2y2ATQ6d99SBDczsx5+Zy5wWdGqg4q2RcSV4eo48rhZe8ViFDKD13455kNWdz1q86Bd8PyiLAb9YDPzf40Xrs+1LxbPMI9ZqgaQ8OsH4bH51fUxd8pfFKiokJXhJ9NsCIIycZHdzKRh/ilDJDFWhN7hHh2aK3yd0cZj1VHbrGAANvH7dWdV7BBXk+x0bSTwEOGtO3fBnb59qXgDhbcju9FaKptlk6SduIik3jVjZsVsdAsyfMfAfboTsJ3bj9cy1lRSY2ACTqY6Mft+GpIHZKE8zKXW0jjfZcs2llyLNSGSqmKL6Y4wDDoaPRjsvDujC6CZv4ntVH3slZqkSUQUoVTG7pME1GUpBUXebfXfdMsrMrvxrp6KbziAHyA/p+swfbzo7J8oTW/Xn6O6R6dkuDdrJdnPu8myovOzSS/wrOfr3Np6n6c87jvS8YMh/zaI4lhvhC46AMBlLkk0giUtCTKPSAcDXi1u6g
 nTS9Lrz2
 1YEu1ndT023rJjcIJ8CQCXCNnUPiCIRjEvVw1m/no5nVb3ICGVMe6D5HwWELb3Ycn49bJvkM2BGEwMTpFK/4iEGVzATQiVHu+ywNFlszASfKBNAdHywTanaWAi+BmpE9+Ai6tLKR+5IYhfKOWBU+75wtetwWWo3lHPtv45wkVbLf6Uaahxru2CrYH6sFuntX3BhN4sgGA7uXMhSIpLE2o4rLIUh100OwXJWyWVEaCjWISDdewum8Wl9tKPqE5D84R/1XauDrclmvG2kU/D04osuky5KDZKucKwY1DqJRY7heZE9XxnXXqYNYW+Omw796SbwOBz186cIsnLFVH+y5aWTVL8/YQcs0z19lImANjAvWN7thW84X+JOSrbUQrxmbkseCbf+92mLDyWi6wV5Df4En2qUZgmtnRbbCVfRrOMUM1OTZODygvbjZX4c+xLRBi4dhJtsmwQcHQNNU0sUdrbVXIO7uj5fmp5jntdgwMiWOVsks8w6s1mWHmeFNFYV6nLpfb+HhiA3kQ8odJNlA+wnF0F4u0kLEQf5hVlDlCm9FV3ItUUptrfozSKKpy+L3DTQ8RWqz/ORNmOR55hGszI6jnnn+OW7vjPNr22iE/E09ZRN2cefUybkdtzLGfbWi/S4JLcowl6HT/j2PBsPjeISwuXfpK5JVRbOCgaH/8v+w+w70=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The swap cache lookup helper swap_cache_get_folio currently does
readahead updates as well, so callers that are not doing swapin from any
VMA or mapping are forced to reuse filemap helpers instead, and have to
access the swap cache space directly.

So decouple readahead update with swap cache lookup. Move the readahead
update part into a standalone helper. Let the caller call the readahead
update helper if they do readahead. And convert all swap cache lookups
to use swap_cache_get_folio.

After this commit, there are only three special cases for accessing swap
cache space now: huge memory splitting, migration, and shmem replacing,
because they need to lock the XArray. The following commits will wrap
their accesses to the swap cache too, with special helpers.

And worth noting, currently dropbehind is not supported for anon folio,
and we will never see a dropbehind folio in swap cache. The unified
helper can be updated later to handle that.

While at it, add proper kernedoc for touched helpers.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/memory.c      |   6 ++-
 mm/mincore.c     |   3 +-
 mm/shmem.c       |   4 +-
 mm/swap.h        |  13 ++++--
 mm/swap_state.c  | 109 +++++++++++++++++++++++++----------------------
 mm/swapfile.c    |  11 +++--
 mm/userfaultfd.c |   5 +--
 7 files changed, 81 insertions(+), 70 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..10ef528a5f44 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(!si))
 		goto out;
 
-	folio = swap_cache_get_folio(entry, vma, vmf->address);
-	if (folio)
+	folio = swap_cache_get_folio(entry);
+	if (folio) {
+		swap_update_readahead(folio, vma, vmf->address);
 		page = folio_file_page(folio, swp_offset(entry));
+	}
 	swapcache = folio;
 
 	if (!folio) {
diff --git a/mm/mincore.c b/mm/mincore.c
index 2f3e1816a30d..8ec4719370e1 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 		if (!si)
 			return 0;
 	}
-	folio = filemap_get_entry(swap_address_space(entry),
-				  swap_cache_index(entry));
+	folio = swap_cache_get_folio(entry);
 	if (shmem)
 		put_swap_device(si);
 	/* The swap cache space contains either folio, shadow or NULL */
diff --git a/mm/shmem.c b/mm/shmem.c
index 2df26f4d6e60..4e27e8e5da3b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	}
 
 	/* Look it up and read it in.. */
-	folio = swap_cache_get_folio(swap, NULL, 0);
+	folio = swap_cache_get_folio(swap);
 	if (!folio) {
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
@@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
+	} else {
+		swap_update_readahead(folio, NULL, 0);
 	}
 
 	if (order > folio_order(folio)) {
diff --git a/mm/swap.h b/mm/swap.h
index 1ae44d4193b1..efb6d7ff9f30 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
 void clear_shadow_from_swap_cache(int type, unsigned long begin,
 				  unsigned long end);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr);
+struct folio *swap_cache_get_folio(swp_entry_t entry);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
 		struct mempolicy *mpol, pgoff_t ilx);
 struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
 		struct vm_fault *vmf);
+void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr);
 
 static inline unsigned int folio_swap_flags(struct folio *folio)
 {
@@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_entry_t swp, gfp_t gfp_mask,
 	return NULL;
 }
 
+static inline void swap_update_readahead(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+}
+
 static inline int swap_writeout(struct folio *folio,
 		struct swap_iocb **swap_plug)
 {
@@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info_struct *si, swp_entry_t entr
 {
 }
 
-static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
 	return NULL;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 99513b74b5d8..68ec531d0f2b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -69,6 +69,27 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
+/**
+ * swap_cache_get_folio - Looks up a folio in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * Return: Returns the found folio on success, NULL otherwise. The caller
+ * must lock and check if the folio still matches the swap entry before
+ * use.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct folio *folio = filemap_get_folio(swap_address_space(entry),
+						swap_cache_index(entry));
+	if (IS_ERR(folio))
+		return NULL;
+	return folio;
+}
+
 void *get_shadow_from_swap_cache(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
@@ -272,55 +293,43 @@ static inline bool swap_use_vma_readahead(void)
 	return READ_ONCE(enable_vma_readahead) && !atomic_read(&nr_rotate_swap);
 }
 
-/*
- * Lookup a swap entry in the swap cache. A found folio will be returned
- * unlocked and with its refcount incremented - we rely on the kernel
- * lock getting page table operations atomic even if we drop the folio
- * lock before returning.
- *
- * Caller must lock the swap device or hold a reference to keep it valid.
+/**
+ * swap_update_readahead - Update the readahead statistics of VMA or globally.
+ * @folio: the swap cache folio that just got hit.
+ * @vma: the VMA that should be updated, could be NULL for global update.
+ * @addr: the addr that triggered the swapin, ignored if @vma is NULL.
  */
-struct folio *swap_cache_get_folio(swp_entry_t entry,
-		struct vm_area_struct *vma, unsigned long addr)
+void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
+			   unsigned long addr)
 {
-	struct folio *folio;
-
-	folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
-	if (!IS_ERR(folio)) {
-		bool vma_ra = swap_use_vma_readahead();
-		bool readahead;
+	bool readahead, vma_ra = swap_use_vma_readahead();
 
-		/*
-		 * At the moment, we don't support PG_readahead for anon THP
-		 * so let's bail out rather than confusing the readahead stat.
-		 */
-		if (unlikely(folio_test_large(folio)))
-			return folio;
-
-		readahead = folio_test_clear_readahead(folio);
-		if (vma && vma_ra) {
-			unsigned long ra_val;
-			int win, hits;
-
-			ra_val = GET_SWAP_RA_VAL(vma);
-			win = SWAP_RA_WIN(ra_val);
-			hits = SWAP_RA_HITS(ra_val);
-			if (readahead)
-				hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
-			atomic_long_set(&vma->swap_readahead_info,
-					SWAP_RA_VAL(addr, win, hits));
-		}
-
-		if (readahead) {
-			count_vm_event(SWAP_RA_HIT);
-			if (!vma || !vma_ra)
-				atomic_inc(&swapin_readahead_hits);
-		}
-	} else {
-		folio = NULL;
+	/*
+	 * At the moment, we don't support PG_readahead for anon THP
+	 * so let's bail out rather than confusing the readahead stat.
+	 */
+	if (unlikely(folio_test_large(folio)))
+		return;
+
+	readahead = folio_test_clear_readahead(folio);
+	if (vma && vma_ra) {
+		unsigned long ra_val;
+		int win, hits;
+
+		ra_val = GET_SWAP_RA_VAL(vma);
+		win = SWAP_RA_WIN(ra_val);
+		hits = SWAP_RA_HITS(ra_val);
+		if (readahead)
+			hits = min_t(int, hits + 1, SWAP_RA_HITS_MAX);
+		atomic_long_set(&vma->swap_readahead_info,
+				SWAP_RA_VAL(addr, win, hits));
 	}
 
-	return folio;
+	if (readahead) {
+		count_vm_event(SWAP_RA_HIT);
+		if (!vma || !vma_ra)
+			atomic_inc(&swapin_readahead_hits);
+	}
 }
 
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
@@ -336,14 +345,10 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	*new_page_allocated = false;
 	for (;;) {
 		int err;
-		/*
-		 * First check the swap cache.  Since this is normally
-		 * called after swap_cache_get_folio() failed, re-calling
-		 * that would confuse statistics.
-		 */
-		folio = filemap_get_folio(swap_address_space(entry),
-					  swap_cache_index(entry));
-		if (!IS_ERR(folio))
+
+		/* Check the swap cache in case the folio is already there */
+		folio = swap_cache_get_folio(entry);
+		if (folio)
 			goto got_folio;
 
 		/*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a7ffabbe65ef..4b8ab2cb49ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -213,15 +213,14 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 				 unsigned long offset, unsigned long flags)
 {
 	swp_entry_t entry = swp_entry(si->type, offset);
-	struct address_space *address_space = swap_address_space(entry);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
 	int ret, nr_pages;
 	bool need_reclaim;
 
 again:
-	folio = filemap_get_folio(address_space, swap_cache_index(entry));
-	if (IS_ERR(folio))
+	folio = swap_cache_get_folio(entry);
+	if (!folio)
 		return 0;
 
 	nr_pages = folio_nr_pages(folio);
@@ -2131,7 +2130,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		pte_unmap(pte);
 		pte = NULL;
 
-		folio = swap_cache_get_folio(entry, vma, addr);
+		folio = swap_cache_get_folio(entry);
 		if (!folio) {
 			struct vm_fault vmf = {
 				.vma = vma,
@@ -2357,8 +2356,8 @@ static int try_to_unuse(unsigned int type)
 	       (i = find_next_to_unuse(si, i)) != 0) {
 
 		entry = swp_entry(type, i);
-		folio = filemap_get_folio(swap_address_space(entry), swap_cache_index(entry));
-		if (IS_ERR(folio))
+		folio = swap_cache_get_folio(entry);
+		if (!folio)
 			continue;
 
 		/*
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 50aaa8dcd24c..af61b95c89e4 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1489,9 +1489,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		 * separately to allow proper handling.
 		 */
 		if (!src_folio)
-			folio = filemap_get_folio(swap_address_space(entry),
-					swap_cache_index(entry));
-		if (!IS_ERR_OR_NULL(folio)) {
+			folio = swap_cache_get_folio(entry);
+		if (folio) {
 			if (folio_test_large(folio)) {
 				ret = -EBUSY;
 				folio_put(folio);
-- 
2.51.0


