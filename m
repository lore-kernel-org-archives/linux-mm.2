Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F3DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E7B8E0006; Thu,  7 Aug 2025 11:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BDA68E0001; Thu,  7 Aug 2025 11:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC778E0006; Thu,  7 Aug 2025 11:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4158E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:27:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA52682AE6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:44 +0000 (UTC)
X-FDA: 83750341248.16.F0672D8
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id E61B2140007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5QLPLjQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754580463; a=rsa-sha256;
	cv=none;
	b=Ot9S/AygnwpquGxzUOd0LBp6hzH1Pve7Z2lQBD6ndJBMHuLcHwlIWKx58k1v/GhVYidGME
	qZibybuXE7bBdW81qYIDpVKvcrt1C2siA2ILRMER92Z4pb005TCLV2UAXOZM1WW/nWzODa
	qij0tVynZ5IKmFZsZZqRsCOa7leWnbc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5QLPLjQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754580463;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W378C/ui4Nn48kbx7spSyMZJiPUfI1BuYCUSwKTLg+w=;
	b=64XPnjMHH/NyEqxDQSJneHqanXCgp19R7t4USxucqQgyHXu71cCvIuRZzP5XBWOL0M2ifi
	cs9n9ijm1mIZpyJG1nKwF3YMhvmP+HivgZDyrH+cCJUTBXiVvBgZIU+tGmV6/FZ3Hx2Zvz
	XPDVmChuuaxAH+tgvAimj07i9DtXdVI=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76bc61152d8so1194896b3a.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 08:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754580461; x=1755185261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W378C/ui4Nn48kbx7spSyMZJiPUfI1BuYCUSwKTLg+w=;
        b=T5QLPLjQhSlQUoSPsp1l8/1jx1hBHiZtmA28KmDAO14IVHchHoUkFBOe9HziL6PvFs
         z4q+gnDJwmewiCq5Tygnn1H4uKmDKf3xd4JK4e26ixwkV2h8SvvqCtBtu5minpeO++Vd
         xMw0k0gWBtpU9vGk/hpGPTvqe0mZLZ5IghkRFphv9dmlz2A7mlZF8dKp4GYaIJzGSqa+
         wKxJKyUV+0nX6j8tfdPteej2oJFtSPUGGXFzbbAqDnn3snFy2W+YiNQl4zM7HzN2PweH
         Y5SAqyTfcwaszE8YdrQtOAFXhvHqMe5NHw8+CzQu8l3eidtaKH41/PQvxnnGQPnzy1Ac
         TFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754580461; x=1755185261;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W378C/ui4Nn48kbx7spSyMZJiPUfI1BuYCUSwKTLg+w=;
        b=cbzO936xROHzc2OGG/F+MbGZScKL6eJ/QodNiOI5kfGVrDyH270tQCHLaTPuCWpXwQ
         +tU1zTgERQ6X8oXuGuwsn8ffunZXYEL4ELDWSaneLkqqtyW6E3BoBsjTeGsXhpYSLgLM
         eac+odHDMD6PE+xKsWBR1XratrsLP94mEt0JrIQFC7/pRLxB/gVUR56xydo7mEmPWNnt
         DzotB1DLzI1B9n1OjV1cKJ2z+wB8GSCGGwssUif8J0NvYb7J52DHw4hx4ehzf8XG5wsJ
         XacrR0mdOtXFqiYZe0aR9M57kHla+jpVszaMuxQKiw9L5EqnvcmG8VJNzbyZ83bNCXDO
         vo9w==
X-Gm-Message-State: AOJu0YwIk0ef6DbfzFHP10vuT2a1lHVTXSeXEbd969JprcIpdq7R00/2
	Y8pf8I71WpjpyzrAo3/bvwXnUmYXrna1Ff2LDpAds95b5Cw94pEb4DInn/i3G3OK2Yc=
X-Gm-Gg: ASbGncsC7eGFxuq+Hypi0m/vZMaUzAizNuaCVaW+JpEy+Has85L6CJ8k19V84ghSF3Q
	22O/goDCCOcZeA4ggU7eF5h0DLq/zamBHE3jxsoAzVe3ToiMa/95qSqE7gKGnXB36cd2noZwd60
	bFRVQYTrJByZccO/UymlHmYRexvejP7SGilBdR4oQ/JSxna4HtdapzhMQjdpSnIcsNaGVIdpsvo
	26iBzodZs0YRp45ZfMzp5CllAyvzUfMa2AvSr06OK65DBczowzoHtnMIK26SeWVu5Z+JYIzJBpY
	5r18nkGFQcl0PS7ZYAzlKgVlNmNGZuoVvHvSH4ZK3jV0vvgpH4h3w1jL3eHSizHQbGUUwyn6/Vn
	umQhd7VUDHAY64kC3aokXyLAhhiY=
X-Google-Smtp-Source: AGHT+IHRT5ELRk/Sa92iZBCL1/be7hEx7q/BlsCMtTe8yujnS/awxHGt04gM6xNE27+vWJ2mZc4/Ng==
X-Received: by 2002:a05:6a00:b95:b0:76b:d93a:69e2 with SMTP id d2e1a72fcca58-76c44a08e0bmr118401b3a.19.1754580461253;
        Thu, 07 Aug 2025 08:27:41 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce6f319sm18430540b3a.18.2025.08.07.08.27.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 07 Aug 2025 08:27:40 -0700 (PDT)
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
Subject: [RFC PATCH 1/3] mm/mincore, swap: consolidate swap cache checking for mincore
Date: Thu,  7 Aug 2025 23:27:18 +0800
Message-ID: <20250807152720.62032-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250807152720.62032-1-ryncsn@gmail.com>
References: <20250807152720.62032-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E61B2140007
X-Stat-Signature: pxq6gh1g1ji8kfb7i4wsubjbay8i6a4s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754580462-32175
X-HE-Meta: U2FsdGVkX18EgP2IzK0ukUdWX9C7D71pO60nMIthb5L+CfSLQCvus5Dw8WDd1N0IcwDNjH1Y1enh+ek/QPWHSQVcRCx48Te4d1uy9QLPrtFeGENv7HZ8jockse2az6RQ6bBccE3iye8U7e8xB2EuAYuyE75gRxKw+yz9p9n9a0ZnrctaBgKbCMu120EhnJ15Fuoz+Xv6vYbOMD6SNMcGj1Gym7tpnXiVFn+AIAAq8CsAe92mdLN7LOTCcKM+XAugTEiiRUsKLTa4PSVNZfBKx5RGU7AnFHHjxYtw79MMxZfAgkIvaNCuW/Dzz6c3BtkKHuPpgw/sXFwE95oHq8xx3H6SwCccixWrPJm3Ah8jR3QHPpZVgB8omckni6N0P7aCv5V2s6iM8o3V7nv6qJho0bOWJJ3izIvluWLhZ7qAuGUnGDNTrMxT6ka5pz1wKF1AX+7oFVOEcV7iPQDnW/mwmiMXXURLaUsczegVSPUvMSyFD+zQpAlAln0jX42xIj0ZfmqeFyIkePMkS/ZpOSYdBUr9XSmXDN4uYAYMe11g//zAzhVr5EA2DrmrsVc6Q5a0fQfpNyeFLF3pYMb1zLSAHiUo8GvwePuj4ovfttyDNHXnsFxTb2EBNSAawTtdKNKLHrlR59fVADGXxrL0kKPc/3CAR2DRz85uPXNk6pUis140Y4mLSn/f+ITGU0vhSY/VNqfHO+OAcoxH6uZ4oLv9mKSsil4+b0CELS6aQdZ5W73TM3q4JHiqb6JTZYPb0SWepnOFarVtfWBdbCEWFUo35wMu/ejiFEW0hYwF1F9l82Q+xatIBfPMoWeb8MHVpItKqZGf/2//PyQzS4ycwTaW0Z5Kt6NgX+w6/q4byQlzzOa7eN6cjnQoBaiSrWQhzwMTTkKXM3DWhyOzX0UgNE28DUccOS2b1xlSR6KFRj0A9ttPCFjIxXoAPiZAfRhWwkfYjZ9Gc2hVaEyUZvzHGAc
 ZmuS8Q0Y
 GkFVNX2JOazYKeyI7gmqsKyuUyFeqgCBamZDJSZdgdNlXBNZtuL6XZEZ+LdLqXexXVagqs7hOA3K7AHx/Y+9broBKjwP8CVYF301jrLojDk616Pai7clZRLT58XuXk1EpNdkhOzHMtMgjgem5ywQT0whi/sOxml5dfykppL1HNAr4lILrRy9WXy+ZkD7/KsTv0aK6n5fDry6QHZmudKevzMaBweqAqQEuNseT3FolhNkqQe52ia5+RbeBCt4GTWi8baDHSH4wn7nAuFnXdq1kzvdYHIAxZWdHZ/bY3nuN/b25hNap4SI5spuFWK35XxRVbujqxU/6moWecIOR3TBkM9GXzzNDmUWWEJYBExuEk4SwzG/3sbX6FwEMQtmLsj2FgMtFsvrHV0JPYCzpo+NovSrYHsxmz5Yl6+ngpJK2cYsT6ZRoriXLn1koikbbrMDNUZw4qb9oRXx/JB2zGNovuLlO8VlNsKjGz6QJLizu4WWjIHO9fPqYzkvX9GF9q05vO4nVQQmIe9uELPkcD058satyv0V+KSDxdXwhKAvh7GNFXYJFWgQmXem2Xasw6qpU+X9L
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
index 10dabefc3acc..f0d3c9419e58 100644
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
+	if (folio) {
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


