Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE45DEF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6596B0092; Sun,  8 Feb 2026 16:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108D16B0093; Sun,  8 Feb 2026 16:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E5E6B0096; Sun,  8 Feb 2026 16:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD1FE6B0092
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:58:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ED4CD6144
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:50 +0000 (UTC)
X-FDA: 84422654820.25.14771A5
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id C3A981C0011
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=az5pt6bH;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdck4kEatqeWpIk5x4ugOl36FqvjbgCoyttMgxaBORw=;
	b=2ebXdtMdAGy+olyHcgKq7puPKP9z3p7yGoZknqWpy72fCkfi3XgaZGPkfqS11EzLAny01J
	P+ZvJWwQGZV/JUbCL/WDmXeyN7U3MKBNKOtxntx8paBhX5uV4EsZuztf29VRqyGiIaag1o
	rWP9EJc+P3sxzhGGZE89zN+kY7VbIC4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=az5pt6bH;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587928; a=rsa-sha256;
	cv=none;
	b=X9R4IkzxrGEITpwhlW5ZWdtMaY+YpyORL4aXdoEsW94sXUyGOJoMctYPn3zd2sA7UO2FuE
	9obuqUw33VScFMrNGnq6lloxHdi5bEeGm7Ax8Sde6BqlZLpmney+j1ETvcDBx2Ga1X+pPm
	O8QGblaujemfzN8EHwq3QkVv3s9j04I=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-66307e10d1dso2095798eaf.0
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587928; x=1771192728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdck4kEatqeWpIk5x4ugOl36FqvjbgCoyttMgxaBORw=;
        b=az5pt6bH0BXDrPfTdl7TdjDikvosG5+teOaHzvB/7TX3tmN52caedyXdbICXQvFITO
         VHgchg8FJweTOOZs255n3kMmlcf77tjqG9MR0nnAspy8oVX4t4KCQnevM/HiUUEr+8C4
         5QyJG3HYqxLmhWCaP7jM7ZUjsppWIcz8Nmb/Rfd92ClYiwPqy3/HC2T0dzCGVZU8wPPm
         BHe8xO+QQHgDHiF0dVfczdjxDN3qYbnk8RYcphaKOZEhzy667pExFz6eTKt5u5WG/VLo
         CLKiLMARZ7HNqSzPw/rlxFSjAHHRN9G2nNCSdMd8Fs94Yb6a6o14Mn3rjSwkgknqSMhr
         QRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587928; x=1771192728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bdck4kEatqeWpIk5x4ugOl36FqvjbgCoyttMgxaBORw=;
        b=U7Gy2ZiktaZgdrLCduhmsuar0vx37ANPow9nItIBZCDxAdYVJMiM/ex1zfTVAR3NLA
         IXBxTt7d5sz90JFxsUuS6xSn7ZJOoCKdWFNTS6pxdGJKt7MdQDeti9/h7S2bt3SYggmv
         XVRKg6cj+aqnp2QNI0joJmnu9Tufg+C4orJfp9thhUjhCOTuz+tlVUIQrEfTY5hTO+sH
         bvPgSACgGt3tUeyUqS6GvlvXAQBzJMSxmSjlHl+LhwTNo2ZytlGXQHQsOWxWt0ggX6xI
         +iVGuviXLCOfC6/y6fw0+DH9vk2oWG0aAhCWsna4U9nNFOJzgNzZpVGL+VNYGmKuWCoG
         rFiQ==
X-Gm-Message-State: AOJu0YymHyEMwIOtgj6yxaXgpybG1ur1OM9ga6EebTn5RwcczPgUD5B4
	KE/1FRjz705aMi2c4OSZbsE7IuFz/sTJQPke7ENEyXcjIzro94joH4aqhbv9hpY4grm3+Q==
X-Gm-Gg: AZuq6aLpwocCedjnuQr2hhawIvPN2biJMqgejTIdNbct04q5922xO7qIsEGqZhRHs9V
	K/Std46IdzT6/WjmArYArxO9uHEsM7bHqw/2uIuMqmK3Pr7iQltCBI3p7G5J2eh4sxc1550CKq/
	ax6AcD5uW7wnGA58g1fNVW11MCD67FtcfA6qRUpcAU8RTB6HzFDxLgDLYA2nL85ilOWRfiIEOUL
	L9a3bZclx/6A0S8j2kJG8PIdqGIiONbbMVri+8LcTMczW2DM+aF3lAkq+iS/R0Qzk+pUz0mo15g
	MkW7yKY+LE2bjXfRWlGx+vPNMvPbm2GyEarBnYy9ECMozN5vYao+Y0ZBtB8dP74Yfv9XQH/QFv1
	SNVhpMweb2qddHTOQsCQctA1EorkQ2vWk454S65wD3eM81rsZxNHMzE1RFfwfKjdBCFH/lZfUfO
	cDbqhRUuGldN/FblYGxTg6j/2xnFNg0Uaq8M3LzAtHiBA=
X-Received: by 2002:a05:6820:986:b0:65f:6655:9db3 with SMTP id 006d021491bc7-66d3262bbfamr4616076eaf.5.1770587927690;
        Sun, 08 Feb 2026 13:58:47 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-670c3849609sm832927eaf.0.2026.02.08.13.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:46 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 02/20] swap: rearrange the swap header file
Date: Sun,  8 Feb 2026 13:58:15 -0800
Message-ID: <20260208215839.87595-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3A981C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: or1jm1r6izfzfuye8kmsyhn5ge5auk56
X-HE-Tag: 1770587928-618476
X-HE-Meta: U2FsdGVkX1/9JzAFFYiBsWqX9SZH1cm4ZKy3JppmJ+BNFEaf6iikR0FeHo6SdTyZeW8+Qc84ZDbL6PhzxkXRMIKtjdX4rKHxmIV/h6/LvEXioF/r19Z9i5SCpOQBv4XmjoL1jB+Fh/Ds/ds+BZy6nxeep/vSYjnD7vxBCPYfMqMtTl9BJ5/4YxEOEPEd/oTj4cBU6vlfSNJ3NcgC7cWJMX3dYecDUk23tgNCUvkFLBEHBGQW6gEh77jKFY0LNJcdFELmggPL4HFvC39uFS7GnHEmAW2Bby4vBLsqyAJXiYuzrp5jvPnZADkajsUudjssJjHDf2NZnp/dVKKnPV+OSfL9b4lbAgmWT6XIH21d3KUoVAWsTLkFAu1dJhrOxdfac6ZY4odIEsdLPjg7VhtBjbZnNb0LrUfTD1Cm/o+xs2oY9VhAbqxjmOT5YI21/9WWH7dhfWPfyHJH5LwvYfcNkteRievIHSPsiSflobNdghL2wqTxaiXhNa9rEa3UZ0XeaThfvP5UykjTlUAxDFIUYxmdG+LT44VfWuzQM06WGQxL2olTEnaaiy/Zn7IxMgAHKAEEqvqaQPfQ+Q4BFkXly5vAiuwPG30ArTImg+K4y5Wkyw3P1nZqQoyoSgovtZaP8FdTLca3sH+9nbvycyy8e/xkR0j757QdgX89TBST9icVh/wY10YzWoAYNM1FyuwopFJhKVfB9ugcqvFE+bIyVyuzP5yJfO5C0kIOo1sCHBdxdEvom4aZ8qZIiGQTmC5gugbXHg0tect6CooZC0wE21GncawJils/coViwaxwHJzW69FjvPdtik7baPW56o6bR8Ii6X0TPOaEQwSdbZqV2CcOc7rVrc4ryo6KM87MV/cu1VMMv9TjZaJioeOSVmC7LkJi5gWZWqliP/9tmpm3Nt02K6zkxO5o/fQYfHi0O6hjRZaSjj448aqK+hp71tjLE0CAgjjd8xjzYyotNFD
 D14gLFyz
 q+/nOkdkacsFelMt3xVkK6Wf9PALh5HhIKLByk53xVDhPjVy/lWSMYE/Dptc6ePFbq21kncj9EEGNgdIbYW4mQomVbTybYa8Ho6/iSBulFhXMaYL7gPDhhKGu08tbvAQGvCMzvvwIyIbW0IPOhCpChpynvKs3DqGPGkBpLAB/XT4pZkPCcRWGsra0ANrPnAikJj1wCS05oj0JA01Mh0PVaxRDHh7hVU9yTFLh1pUFmHVTrnSPaQpBspmZn62LTmVL9bTeDOqhUE1YKATTPc2JbDAW6z6PEL110bBnZtH5r8ckaXbQg0Vea5D7quknJ+Hf9jBvcvdCcXbo9eLB+wNYBLs4Cb4QymbInfQpglxZA+f6hK0hFryMIn0syuUUHCskqY8COWjA/WGrJ/MaNb3v/K116SSZb2amG/DLjm6zCT/VRNFHQxbgoxb34c0WomB4ZmI1Y56K+LquI1LVh3Q/aCqAE3AyY7cChZXUYLEsnEA1w6lTcT1Wyzn4kD+m3nigAW5vPEywIFpKiBiETnWTSXcHjJuXV4K4+UzKzI54s9QZNXBK6lGdQFgI2tnS8dYVwzSF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the swap header file (include/linux/swap.h), group the swap API into
the following categories:

1. Lifecycle swap functions (i.e the function that changes the reference
   count of the swap entry).

2. Swap cache API.

3. Physical swapfile allocator and swap device API.

Also remove extern in the functions that are rearranged.

This is purely a clean up. No functional change intended.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 53 +++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df687160..aa29d8ac542d1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -423,20 +423,34 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
-int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
-		unsigned long nr_pages, sector_t start_block);
-int generic_swapfile_activate(struct swap_info_struct *, struct file *,
-		sector_t *);
-
+/* Lifecycle swap API (mm/swapfile.c) */
+int folio_alloc_swap(struct folio *folio);
+bool folio_free_swap(struct folio *folio);
+void put_swap_folio(struct folio *folio, swp_entry_t entry);
+void swap_shmem_alloc(swp_entry_t, int);
+int swap_duplicate(swp_entry_t);
+int swapcache_prepare(swp_entry_t entry, int nr);
+void swap_free_nr(swp_entry_t entry, int nr_pages);
+void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+int __swap_count(swp_entry_t entry);
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+int swp_swapcount(swp_entry_t entry);
+
+/* Swap cache API (mm/swap_state.c) */
 static inline unsigned long total_swapcache_pages(void)
 {
 	return global_node_page_state(NR_SWAPCACHE);
 }
-
-void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
-/* linux/mm/swapfile.c */
+void free_swap_cache(struct folio *folio);
+
+/* Physical swap allocator and swap device API (mm/swapfile.c) */
+int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
+		unsigned long nr_pages, sector_t start_block);
+int generic_swapfile_activate(struct swap_info_struct *, struct file *,
+		sector_t *);
+
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
@@ -452,26 +466,15 @@ static inline long get_nr_swap_pages(void)
 	return atomic_long_read(&nr_swap_pages);
 }
 
-extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio);
-bool folio_free_swap(struct folio *folio);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
-extern swp_entry_t get_swap_page_of_type(int);
-extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
-extern int swapcache_prepare(swp_entry_t entry, int nr);
-extern void swap_free_nr(swp_entry_t entry, int nr_pages);
-extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+void si_swapinfo(struct sysinfo *);
+swp_entry_t get_swap_page_of_type(int);
+int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
-extern unsigned int count_swap_pages(int, int);
-extern sector_t swapdev_block(int, pgoff_t);
-extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
-extern int swp_swapcount(swp_entry_t entry);
+unsigned int count_swap_pages(int, int);
+sector_t swapdev_block(int, pgoff_t);
 struct backing_dev_info;
-extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
 static inline void put_swap_device(struct swap_info_struct *si)
-- 
2.47.3


