Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5713BCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41F28E0020; Tue, 16 Sep 2025 12:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B195A8E0001; Tue, 16 Sep 2025 12:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F218E0020; Tue, 16 Sep 2025 12:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7D58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:02:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A4E313A229
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:08 +0000 (UTC)
X-FDA: 83895579936.11.462C06E
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 458341C0022
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:02:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZsULIjp6;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038526;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcEphP+ICQn2G6iNahIPkKAJNc9HmOiqOSMT0ntzzdE=;
	b=gaPs/xxgeTSUHWu9vCDMi7MVDQaRgBqOlh5c05Hoz3mfyT/C9ibmCkvjXX6a8O+GlljxyJ
	34irmUY1Mqv8i/JlzPe+lCCEjRn/KXst/PUPYz7xeazoMtzBEKbffUfb4IWyBoClCwC4oj
	nChWZyeGZjNSm2fnThxpG8iYPIEi/jM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZsULIjp6;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038526; a=rsa-sha256;
	cv=none;
	b=BNH0OVImGXXVOPCTGd8F8Tn8a0kejFyAiI62oiUBhemIJbPNQxZThpAq/YEzmwWczWin+Y
	Qke6EJlbvfg6yA3Vc9lokwr/dNc9Ar4rVr1Qd96qa4szOViYbcYpRLXyOix25N3qLEXaQC
	7RnMhYZNdpYD+rHerIdkLfzOy2cZ8wA=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-746c0ee5d77so4369822a34.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038525; x=1758643325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qcEphP+ICQn2G6iNahIPkKAJNc9HmOiqOSMT0ntzzdE=;
        b=ZsULIjp6tEj9xAbtrpfoLWO9IXZQodVkWUBYxjxxB4Q36WALbPjdVoV+l6z36/cSgH
         L/WwzqF2gZ5cRx4pIWuCT5bL6j0tRHoezEDs8O+eFrXy00V680jfhfSpg7DgEc70JesQ
         FcxOJ+W9XlS8rUZpOlqMgc44tT0AqUUvv0sd2Yk0q1drB7v21qtP4YkXnI3AvX6fQQZr
         CDaBjcFPWsFPpxkQWypvn77PS/kfxQyL6kiruUSHXFE4xFzACL2LP9xLIU/P5lzkNXY4
         3nL0KCl92R3FHypy+hKqxcEpP8FiaC8AC9Vna7P/WFAQs/s7wgQZfTSa9a4NUhv9J846
         4RoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038525; x=1758643325;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qcEphP+ICQn2G6iNahIPkKAJNc9HmOiqOSMT0ntzzdE=;
        b=wPHOJ18Jhke7zoaT0adIknbrWsNjJJb0F06fBYE3uKU9/G85v5CfZoZT7LXQhHYrvO
         VGRLPZn5BXYVUy7gJOGelgD6KI58JIoz3srn4Dvh9E7BdXQ2nW1k40Vql1HQ9QE6cg0y
         55y0ado4zmWOX557B1ZeAGJW1kSf5cKcSdWTBW5zNB71Cj4Re+jQIGwq2UoetFX8AEEV
         d+460Pov2RsRYq5exp8lLdGpxSBn29nEMgnhgVmKb/ihv8qXkQWqHVI5LS2FXk0qNKgQ
         qpE91f+V/vQzB5nNO7ldEUv1wK/gAp6FTKTpo+CI8FYTtzffhrZvvqShRL00TsZ+4fhI
         7drA==
X-Gm-Message-State: AOJu0YxIRXv9/FqiAmyRzI/9FU83VVk4YZXLh9dkA+Gz++wd/Ahe1/uH
	QAjvRlaG3U/uVgrnlKRzdz2/d2YgN8C0Cdh1V7bd3IcZ0SmMWmTvI4Vn
X-Gm-Gg: ASbGncscwFwUbJZWY2bRjDCN2jaAdP6WZ9052LVyKrZF4P1SXL6PsX7JdYhvspkhcF7
	COlEs9OCK6UPg+WSPtTeNZSHt/tvTdJsOy2QGIopNW/aRLPfNQcAWuN02J/xvObnR4oUlSFgfZY
	GJsmEoltPIQC7yq88Jh+NL6Mvw86YdwALPI4OnhcwisrbI51bvyMQ0rUbziH8sUZwFBFscI03U/
	vklJ2Zza3ETS6hxDEZJnro2ng4fphHfOYvlkcXHAg2Bfdd36MHLUmKHDdp95YdaGEzEqW9I0LIM
	EGikcqCt+cfILOouRCHdFNwndHcKQGmW9Apau2Rv+7QfO67DskWWI2CK3TyQBRYCn22ImOrEMBx
	0
X-Google-Smtp-Source: AGHT+IELVtFRC6Nki4vFxd93AiETiEyoU50dddSTirN6BjBYWWFVae4So0375D/Ao7WW2cQMIoMTcQ==
X-Received: by 2002:a05:6808:1507:b0:438:27af:3ff8 with SMTP id 5614622812f47-43b8d86ef79mr8425509b6e.7.1758038524551;
        Tue, 16 Sep 2025 09:02:04 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:02:03 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v4 08/15] mm, swap: cleanup swap cache API and add kerneldoc
Date: Wed, 17 Sep 2025 00:00:53 +0800
Message-ID: <20250916160100.31545-9-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 458341C0022
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wo8ge875f1x8i3wn7bwqjzbt84qci8ws
X-HE-Tag: 1758038526-173997
X-HE-Meta: U2FsdGVkX1/G2j51TyNaC1an3O3QdpdpfoMUjQE6kcJYKACouo9RMfh35z8/CHLbZdAn526+cXpqPCF5OxF4q654+nzeBLzmj6zZ3ArfIHyUYF2HBCOAleZLzyzYgn4c2YMQhEFSnK0pX542oH7E8VBNPXfCkX8T2LVtokTfPloCFiETTJY8GJrT3zMgdE0LQjO11aK/BzUo8CNqhtKogt3fhimtLPFGaZNRtTRKsQdS54RAmRj7lcGVS4WeVn90ihhtQqOQ/XTS6HGMYr+IEwipjOpMMMLozuBP34M4r9gJ/o+rpetEcfmMFu8eyPDV/q5T2sFlaKp6b+9iXUghaH287Aplin2olv92UdqSPGeX2VtTBP8icLnO0yyfFqSfSOxJzoZCMr9A+apePzkYzeaATVxLUfVUcSb497gp7r/7bOxyFxUuz5grR+ej55rLoHK+esC6ygtRkC5dWXDk1ALUM9+WhJJtQRexjoWBhWraY8J4NQRm3OdMNteLwhcN4+7WDunI5XPk/9oY3TwYRYZ8N9wmm0+eMkqgvg24hMx1OGN9gnH7tjBVjvp8QNY/xnAviz0c7Pc7PQtxRQdTHi2ohcRTzJPtl1WYQFqY7N65OWwaUo9WtO+E0+T/2DgecjIv/x7ZFBpEpbyERszg3ixG5A8IMZG5+ghgRkbCfSkcyRCNFrc+11d+lUIBU9mnd2Y/LSjRKSYDduB2jWHWC86e7f7eoiN67MNK9CHLF86IpfUvHS+FQKqM3LFdyGBGpLKXyEmWOIJyiYXBVG+ZZf4Myp39znTSD6VCCjmPKu1+GOlKlkS7CQZKJIoutEaa4p2i4QN+ayR0NFP4zMQ7SvLK1hdzOvskHQZdk88dzpf1P0++IBlFgoYMlkF17c3MO1eADQE/Obp2XsMRPrNs5tptdAV8dMPPq0B1d2Uzy8lnMkPh+ja1/KAES6KMLHXUct2UHO1Hq2MpCX1/Avr
 oKn934nP
 D9crW0BLsvcTCYru02afgg1Ocxe8SpTEv9sj8tHtsT1yYNWvKK8lCNAjwZdFCbEvDZmoSTKaIkbVrd51bH3lb20JElxec0HdrpVWfMFm0hryAwI7QPGmMu9CcnrmT3MUfDD2rtFCmCpJDVRM91spFZXN+r3t/1hzTWLtwZnD6BqZtGZ0x5Ulq3E0zFOhsSLlDB1fixQ/bajJsoRNDQf+SEwwpnnPjy6JkyCDjWuErJe/Ns7MV/JjzaqPp48VhidgkjF5esijB83btskkjt07A5IXOPVxQH38nERynSic0kLZKmzFusKQYzwzyYWFWWdxB10kw4fo/L2x4gDl05zGjXhgvznwc0AfJFcqRPesbUF9ubQZPOZuSxnp99SQbHDcVumbbjr/icXFNA+6SyAFFeMgwKWhYbWLJIaNT50j9hozkgz82ruCJDIJTyVcBzxeiAQTL5dSU4+Q6O4T09QE2aYddnroao31osPWYOWVzyDNrN+oBDBPDldzW8voqHRRYB0gb2EdvQIgqT3UANLKmQdQ/Tb24nXXwIYwUD8hPHQVosdCRMzOrTAtivR6aB4zlrwe8ovDL+1uX09vRSUQfF6EkM7MMImKnJFcziE75ZTvTzoQAaMZMK7lqdd/ZXiySj+oe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparation for replacing the swap cache backend with the swap table,
clean up and add proper kernel doc for all swap cache APIs. Now all swap
cache APIs are well-defined with consistent names.

No feature change, only renaming and documenting.

Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/filemap.c        |  2 +-
 mm/memory-failure.c |  2 +-
 mm/memory.c         |  2 +-
 mm/shmem.c          | 10 +++---
 mm/swap.h           | 48 ++++++++++++++-----------
 mm/swap_state.c     | 86 ++++++++++++++++++++++++++++++++-------------
 mm/swapfile.c       |  8 ++---
 mm/vmscan.c         |  2 +-
 mm/zswap.c          |  2 +-
 9 files changed, 103 insertions(+), 59 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 8d078aa2738a..2a05b1fdd445 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4525,7 +4525,7 @@ static void filemap_cachestat(struct address_space *mapping,
 				 * invalidation, so there might not be
 				 * a shadow in the swapcache (yet).
 				 */
-				shadow = get_shadow_from_swap_cache(swp);
+				shadow = swap_cache_get_shadow(swp);
 				if (!shadow)
 					goto resched;
 			}
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6d9134e3d115..3edebb0cda30 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1127,7 +1127,7 @@ static int me_swapcache_clean(struct page_state *ps, struct page *p)
 	struct folio *folio = page_folio(p);
 	int ret;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 
 	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
 	folio_unlock(folio);
diff --git a/mm/memory.c b/mm/memory.c
index 5808c4ef21b3..41e641823558 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4699,7 +4699,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 				memcg1_swapin(entry, nr_pages);
 
-				shadow = get_shadow_from_swap_cache(entry);
+				shadow = swap_cache_get_shadow(entry);
 				if (shadow)
 					workingset_refault(folio, shadow);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 410f27bc4752..077744a9e9da 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1661,13 +1661,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		}
 
 		/*
-		 * The delete_from_swap_cache() below could be left for
+		 * The swap_cache_del_folio() below could be left for
 		 * shrink_folio_list()'s folio_free_swap() to dispose of;
 		 * but I'm a little nervous about letting this folio out of
 		 * shmem_writeout() in a hybrid half-tmpfs-half-swap state
 		 * e.g. folio_mapping(folio) might give an unexpected answer.
 		 */
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 		goto redirty;
 	}
 	if (nr_pages > 1)
@@ -2045,7 +2045,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	new->swap = entry;
 
 	memcg1_swapin(entry, nr_pages);
-	shadow = get_shadow_from_swap_cache(entry);
+	shadow = swap_cache_get_shadow(entry);
 	if (shadow)
 		workingset_refault(new, shadow);
 	folio_add_lru(new);
@@ -2183,7 +2183,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
 	if (!skip_swapcache)
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
 	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
@@ -2422,7 +2422,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		folio->swap.val = 0;
 		swapcache_clear(si, swap, nr_pages);
 	} else {
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 	}
 	folio_mark_dirty(folio);
 	swap_free_nr(swap, nr_pages);
diff --git a/mm/swap.h b/mm/swap.h
index 30b1039c27fe..6c4acb549bec 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -167,17 +167,29 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
+/*
+ * All swap cache helpers below require the caller to ensure the swap entries
+ * used are valid and stablize the device by any of the following ways:
+ * - Hold a reference by get_swap_device(): this ensures a single entry is
+ *   valid and increases the swap device's refcount.
+ * - Locking a folio in the swap cache: this ensures the folio's swap entries
+ *   are valid and pinned, also implies reference to the device.
+ * - Locking anything referencing the swap entry: e.g. PTL that protects
+ *   swap entries in the page table, similar to locking swap cache folio.
+ * - See the comment of get_swap_device() for more complex usage.
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry);
+void *swap_cache_get_shadow(swp_entry_t entry);
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 gfp_t gfp, void **shadow);
+void swap_cache_del_folio(struct folio *folio);
+void __swap_cache_del_folio(struct folio *folio,
+			    swp_entry_t entry, void *shadow);
+void swap_cache_clear_shadow(int type, unsigned long begin,
+			     unsigned long end);
+
 void show_swap_cache_info(void);
-void *get_shadow_from_swap_cache(swp_entry_t entry);
-int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-		      gfp_t gfp, void **shadowp);
-void __delete_from_swap_cache(struct folio *folio,
-			      swp_entry_t entry, void *shadow);
-void delete_from_swap_cache(struct folio *folio);
-void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				  unsigned long end);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
-struct folio *swap_cache_get_folio(swp_entry_t entry);
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
 		struct swap_iocb **plug);
@@ -305,28 +317,22 @@ static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return NULL;
 }
 
-static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
+static inline void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	return NULL;
 }
 
-static inline int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-					gfp_t gfp_mask, void **shadowp)
-{
-	return -1;
-}
-
-static inline void __delete_from_swap_cache(struct folio *folio,
-					swp_entry_t entry, void *shadow)
+static inline int swap_cache_add_folio(swp_entry_t entry, struct folio *folio,
+				       gfp_t gfp, void **shadow)
 {
+	return -EINVAL;
 }
 
-static inline void delete_from_swap_cache(struct folio *folio)
+static inline void swap_cache_del_folio(struct folio *folio)
 {
 }
 
-static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
+static inline void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 0ad4f3b41f1b..f3a32a06a950 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -78,8 +78,8 @@ void show_swap_cache_info(void)
  * Context: Caller must ensure @entry is valid and protect the swap device
  * with reference count or locks.
  * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock and check if the folio still matches the swap entry before
- * use (e.g. with folio_matches_swap_entry).
+ * must lock nd check if the folio still matches the swap entry before
+ * use (e.g., folio_matches_swap_entry).
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
@@ -90,7 +90,15 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	return folio;
 }
 
-void *get_shadow_from_swap_cache(swp_entry_t entry)
+/**
+ * swap_cache_get_shadow - Looks up a shadow in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * Return: Returns either NULL or an XA_VALUE (shadow).
+ */
+void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swap_cache_index(entry);
@@ -102,12 +110,21 @@ void *get_shadow_from_swap_cache(swp_entry_t entry)
 	return NULL;
 }
 
-/*
- * add_to_swap_cache resembles filemap_add_folio on swapper_space,
- * but sets SwapCache flag and 'swap' instead of mapping and index.
+/**
+ * swap_cache_add_folio - Add a folio into the swap cache.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ * @gfp: gfp_mask for XArray node allocation.
+ * @shadowp: If a shadow is found, return the shadow.
+ *
+ * Context: Caller must ensure @entry is valid and protect the swap device
+ * with reference count or locks.
+ * The caller also needs to mark the corresponding swap_map slots with
+ * SWAP_HAS_CACHE to avoid race or conflict.
+ * Return: Returns 0 on success, error code otherwise.
  */
-int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
-			gfp_t gfp, void **shadowp)
+int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
+			 gfp_t gfp, void **shadowp)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swap_cache_index(entry);
@@ -155,12 +172,20 @@ int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 	return xas_error(&xas);
 }
 
-/*
- * This must be called only on folios that have
- * been verified to be in the swap cache.
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must hold the xa_lock, ensure the folio is
+ * locked and in the swap cache, using the index of @entry.
  */
-void __delete_from_swap_cache(struct folio *folio,
-			swp_entry_t entry, void *shadow)
+void __swap_cache_del_folio(struct folio *folio,
+			    swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	int i;
@@ -186,27 +211,40 @@ void __delete_from_swap_cache(struct folio *folio,
 	__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr);
 }
 
-/*
- * This must be called only on folios that have
- * been verified to be in the swap cache and locked.
- * It will never put the folio into the free list,
- * the caller has a reference on the folio.
+/**
+ * swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ *
+ * Same as __swap_cache_del_folio, but handles lock and refcount. The
+ * caller must ensure the folio is either clean or has a swap count
+ * equal to zero, or it may cause data loss.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void delete_from_swap_cache(struct folio *folio)
+void swap_cache_del_folio(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(folio, entry, NULL);
+	__swap_cache_del_folio(folio, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_folio(folio, entry);
 	folio_ref_sub(folio, folio_nr_pages(folio));
 }
 
-void clear_shadow_from_swap_cache(int type, unsigned long begin,
-				unsigned long end)
+/**
+ * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
+ * @type: Indicates the swap device.
+ * @begin: Beginning offset of the range.
+ * @end: Ending offset of the range.
+ *
+ * Context: Caller must ensure the range is valid and hold a reference to
+ * the swap device.
+ */
+void swap_cache_clear_shadow(int type, unsigned long begin,
+			     unsigned long end)
 {
 	unsigned long curr = begin;
 	void *old;
@@ -393,7 +431,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			goto put_and_return;
 
 		/*
-		 * We might race against __delete_from_swap_cache(), and
+		 * We might race against __swap_cache_del_folio(), and
 		 * stumble across a swap_map entry whose SWAP_HAS_CACHE
 		 * has not yet been cleared.  Or race against another
 		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
@@ -412,7 +450,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	memcg1_swapin(entry, 1);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6f7a8c98d14d..51f781c43537 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -267,7 +267,7 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	if (!need_reclaim)
 		goto out_unlock;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 	folio_set_dirty(folio);
 	ret = nr_pages;
 out_unlock:
@@ -1124,7 +1124,7 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	clear_shadow_from_swap_cache(si->type, begin, end);
+	swap_cache_clear_shadow(si->type, begin, end);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
@@ -1289,7 +1289,7 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp)
 	 * TODO: this could cause a theoretical memory reclaim
 	 * deadlock in the swap out path.
 	 */
-	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
+	if (swap_cache_add_folio(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
 		goto out_free;
 
 	return 0;
@@ -1759,7 +1759,7 @@ bool folio_free_swap(struct folio *folio)
 	if (folio_swapped(folio))
 		return false;
 
-	delete_from_swap_cache(folio);
+	swap_cache_del_folio(folio);
 	folio_set_dirty(folio);
 	return true;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca9e1cd3cd68..c79c6806560b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -776,7 +776,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__delete_from_swap_cache(folio, swap, shadow);
+		__swap_cache_del_folio(folio, swap, shadow);
 		memcg1_swapout(folio, swap);
 		xa_unlock_irq(&mapping->i_pages);
 		put_swap_folio(folio, swap);
diff --git a/mm/zswap.c b/mm/zswap.c
index 63045e3fb1f5..1b1edecde6a7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1069,7 +1069,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 
 out:
 	if (ret && ret != -EEXIST) {
-		delete_from_swap_cache(folio);
+		swap_cache_del_folio(folio);
 		folio_unlock(folio);
 	}
 	folio_put(folio);
-- 
2.51.0


