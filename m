Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255EE1099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210B46B0158; Fri, 20 Mar 2026 15:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9726B015A; Fri, 20 Mar 2026 15:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE5C6B015B; Fri, 20 Mar 2026 15:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 036876B0158
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFB44B6E9F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:50 +0000 (UTC)
X-FDA: 84567426300.16.B10AAC6
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D824C000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U+kqdhZf;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY7NTF4Dm0MfL8/0ZISsKMQQ1GHAv90xIRFAuLv54rc=;
	b=TO5g9x+4cqa6vQ9Uj4epLC62nloY3AaAxfytAjLl1aBSkE9c7SLyJIyysTp2+cREL6rKtZ
	oyorsYECAc4MbcpLlG4gCoQa2ctyhxjCdzRm0BwEK2TXdOOOm8uF5T9bZfpEteJOR/x9OI
	nD1du3J87eqhaodNbO1cuOtxEJFQGj0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U+kqdhZf;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034869; a=rsa-sha256;
	cv=none;
	b=VXKbzADMNf/K+3FbY9h3M28PHwQ8JvZ2JGMYpa8l9ZzVyBBlMISTsq7U3oHU8n0a8HKVg8
	K61sa5UxSozfPldZbRQU3BhllSYNl3352DELKe9gtXVlw0fBhM0VMmV6xfHsgE20TW7RWp
	wr3beViCV9XuYxO7ti1x+kewrUNcqTQ=
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-466f1c3c627so584191b6e.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034868; x=1774639668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY7NTF4Dm0MfL8/0ZISsKMQQ1GHAv90xIRFAuLv54rc=;
        b=U+kqdhZfBx79mEDk2i/Sx690l6TbL7x9/H4wYMFkI68HfqjetGpvh+rtBWRLK7WTTf
         n/CN49shVn+2tdkwCtNlnWmfiIC3BSpXFTS6+ykBILLKp1/XkbepOlAIKyiaDOFlyoYi
         gQTzRTRSSHVAlgBlo0hQs7y3gPxnlVdRn3NfJmgCMYm79V9gWghKp3tWp8xrNAdnawJj
         lyp6qi4W9EvX652SBTMbecmQBrznIJMu4vhpJFDyVwr2Ewi6dIT+JighihXAfgx0I+lq
         C3wH1MKX6g4LYd5K0k1SlqF0ZZytxq/jzrYBjXGjqE84+bLjEqjY9CmtvLiVe/mrrJI3
         gmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034868; x=1774639668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KY7NTF4Dm0MfL8/0ZISsKMQQ1GHAv90xIRFAuLv54rc=;
        b=Mce/S4wdVidpDCeXeGlparsU2O6k/QLBYn3/2L3Qk8xG9Xqh+VX9vD5MnTQoblJELJ
         h5hH0c75Hlv+0SY6HwVjFmQ6pXAclN9ca7ioZYRNzH3/zHJbeQjdNoGJhSubd3ihE2i3
         4IfuifN3aI1MplOKNTNcP0PkP4HwcA6xHquV2CaClu6r94s+sfZHZCWBp25MzW8iEhOv
         2Yj8pK4ZOvUDLarAoyTuuFouz/DFganfGQ3Q/mSRjM4i8UenAOSrViTIajMwxvxN36uf
         FSY8OenS1TQW58RXYwSdsGQsKV6UE7yVFoW0QMRSP1/31D+KAU19NPDBIfk3hwDWQmTX
         iLCw==
X-Forwarded-Encrypted: i=1; AJvYcCWERRAKrH6YJYO5cyw9O7wnAMNbLIro5weleL9VHzbtoSCmqpGnxQAOaB0ecBLkQyafEW9cx4YBgQ==@kvack.org
X-Gm-Message-State: AOJu0YzRqhmwnEFKCMr6xi7r9CHrduz7wt9upHOjgDCYS3Yhf0ExlNde
	crGLZBN7oPGO99FxlTxVsOD1j0fkvESfXRpqssHDA0X45qnxOWMwB/NS
X-Gm-Gg: ATEYQzwkIpn8VsCti0X9a0+T01oY/XuZ94bPwOqzjGVj/J32qV8vnerhVhOriSFfVFl
	GkHYVsaKRwOX8ht4fWSAmeBrhncZNjVcVyB9f0QdKmEjmziwNJrheZJriEFGWiTX+Q9gt2tsS3y
	oUvJeNLEKYiJnuG++aJd7bPbFG+hBhx8/ODErnITK81KHtSCetqQ9KkV8FHMiELYZXNo1X55IUR
	eWy1CSaQuVpp1TtB8SII5wLerk0eQsQTDhxjimJbA4nYeXVq8KtJOa6O5oT460Xi8n1kY5mQ9vo
	YLSI/1h0g3t0SfWEwR3VHn9eTU5SGG4GwKh7EO+kAS8vWf+7pEiVVmLs+YZIaczoMVQMWeOYt8z
	2il0krpd+rs7n/2xmpRHUQIgjfoPNBH/KGJWiPMuVi7rjSC4rocYeaLl5uh9JU+aNvqf2aLM8+/
	4IkoqsG5g4ilIdZdzVu4EUHhAJRQX54iaQlvdpzkS98P3o+g==
X-Received: by 2002:a05:6870:45a6:b0:3ec:4f31:42a with SMTP id 586e51a60fabf-41c10eff5ddmr3006039fac.7.1774034867967;
        Fri, 20 Mar 2026 12:27:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14d63aa9sm2729687fac.10.2026.03.20.12.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:47 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v5 08/21] zswap: prepare zswap for swap virtualization
Date: Fri, 20 Mar 2026 12:27:22 -0700
Message-ID: <20260320192735.748051-9-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D824C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: itjrq77onq3twkc4zuxsdwyi1qr5tfhg
X-Rspam-User: 
X-HE-Tag: 1774034868-250212
X-HE-Meta: U2FsdGVkX1+4qjVMB+iZ7x6zGERMpVRxcDG4j9JYOoDIJCsNKw2gGA7IEt/kMgnmf2XXPu3g/KlOzd+VQrkdKv1jOv4wZrEOWt5w8Qszs8qznwle0UpFMJkx4I7f0fUMjEmOIdasPl2nDf8ACEmzewNWGi62NCJ8OcbhPbHaQa2c02p4QIfALwzGolUY56wVymm1Iy4V+uraVVFAuARh3izu5yB96sGrlw8MNoegANTQyM7ySZ58txvCox/DdyhZo9FWden19lpgiUKtzPm6y7e5Bel0WwPcGolBg3HZ/sMdEwG3tKMfIIclslEysKeQlywE5lxZ07GnSWnbAo8bAPoHQKLMp5o7BaiH+EhUZdhI9Y/RYfde3qjfzB/yfmDgfHja6usCsbUycb0w0TJjvCGpdVCtL4l75GhXmMMZRfHgIF/mbFMMGsgTRzL86ou3yIUQPWHBJPM5AOqts8ViQv7Fp7LK8uGkzj3cgOB82Hi0QM0Y4ucB4w5o5vawj86HIFpfWj/XeyJXglgmOh7d0aj+EU5JsYgOAaisEbbZTlN4JTJ+tEzhsbfz02Nty7tXSgYY4hgHKhYa6wOVzCGXNyKyBqmTjLEmpeLUm1R51DE1DWR+LNMi72Ze3lPSSIE+DL4vtHlow1cbKvyzDP7g3n23lvhzofUe9zlBgrnjOCKw58l7MtT4QIJj71WQT0rPIXIslo62r+HIKgx8/j0hvr5G3Pefo7QCbqqpV9U35v1Cxl9GKjmxWFSguqyVr9A02vNAkMQSCAwT+eTa5zryzxDG6+hyekJujR+ofECLQ/e9Xw6TOHnV9Ypipsqdv5Ea0vp8ErsIQwmEnk0S4woGaBccyqENw8Qy2gPr3vSbO2zLiZyQ8iJDyHnVpks0SfDW5eS/HNEfGyK2mN9s7meJx21Fc2UmLXkPF9Y811Qhkmhdwb1W7Q4wxGXcY0dL4XNH4l1X7VrHCk6nkBeasWK
 cFxjadME
 71pBU/M49p8ABAnayXxjRU+l9A8De644etM906Y+dMOa/mSceGjfWH0hFgkK99xilyr6oA4s80qIlx5avNSfEE99O8e+IQ35JMbzHcs1naW2LYZ47ZSP/NOrrSr9XGVD03kmCMWSut9dhqwNWUSSWMmJWeBNcMZJyQJdTFy7PV2Ljuj6vKdgARa2Z07uQMl3QKc/eg7X0gnXZAhLuMX1E3TJfVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zswap tree code, specifically the range partition logic, can no
longer easily be reused for the new virtual swap space design. Use a
simple unified zswap tree in the new implementation for now.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/zswap.h |  7 -----
 mm/swapfile.c         |  9 +-----
 mm/zswap.c            | 69 +++++++------------------------------------
 3 files changed, 11 insertions(+), 74 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e1..1a04caf283dc8 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -28,8 +28,6 @@ unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
 void zswap_invalidate(swp_entry_t swp);
-int zswap_swapon(int type, unsigned long nr_pages);
-void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
@@ -50,11 +48,6 @@ static inline int zswap_load(struct folio *folio)
 }
 
 static inline void zswap_invalidate(swp_entry_t swp) {}
-static inline int zswap_swapon(int type, unsigned long nr_pages)
-{
-	return 0;
-}
-static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6b155471941c9..0372062743ef7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2972,7 +2972,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
-	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
@@ -3615,10 +3614,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = zswap_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Flush any pending IO and dirty mappings before we start using this
 	 * swap device.
@@ -3627,7 +3622,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto free_swap_zswap;
+		goto bad_swap_unlock_inode;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3650,8 +3645,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	error = 0;
 	goto out;
-free_swap_zswap:
-	zswap_swapoff(si->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
diff --git a/mm/zswap.c b/mm/zswap.c
index a5a3f068bd1a6..f7313261673ff 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -197,8 +197,6 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
-static struct xarray *zswap_trees[MAX_SWAPFILES];
-static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
 /* RCU-protected iteration */
 static LIST_HEAD(zswap_pools);
@@ -225,45 +223,35 @@ static bool zswap_has_pool;
 * helpers and fwd declarations
 **********************************/
 
-/* One swap address space for each 64M swap space */
-#define ZSWAP_ADDRESS_SPACE_SHIFT 14
-#define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
-static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
-{
-	return &zswap_trees[swp_type(swp)][swp_offset(swp)
-		>> ZSWAP_ADDRESS_SPACE_SHIFT];
-}
+static DEFINE_XARRAY(zswap_tree);
+
+#define zswap_tree_index(entry)	(entry.val)
 
 static inline void *zswap_entry_store(swp_entry_t swpentry,
 		struct zswap_entry *entry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_store(tree, offset, entry, GFP_KERNEL);
+	return xa_store(&zswap_tree, offset, entry, GFP_KERNEL);
 }
 
 static inline void *zswap_entry_load(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_load(tree, offset);
+	return xa_load(&zswap_tree, offset);
 }
 
 static inline void *zswap_entry_erase(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-	pgoff_t offset = swp_offset(swpentry);
+	pgoff_t offset = zswap_tree_index(swpentry);
 
-	return xa_erase(tree, offset);
+	return xa_erase(&zswap_tree, offset);
 }
 
 static inline bool zswap_empty(swp_entry_t swpentry)
 {
-	struct xarray *tree = swap_zswap_tree(swpentry);
-
-	return xa_empty(tree);
+	return xa_empty(&zswap_tree);
 }
 
 #define zswap_pool_debug(msg, p)			\
@@ -1691,43 +1679,6 @@ void zswap_invalidate(swp_entry_t swp)
 		zswap_entry_free(entry);
 }
 
-int zswap_swapon(int type, unsigned long nr_pages)
-{
-	struct xarray *trees, *tree;
-	unsigned int nr, i;
-
-	nr = DIV_ROUND_UP(nr_pages, ZSWAP_ADDRESS_SPACE_PAGES);
-	trees = kvcalloc(nr, sizeof(*tree), GFP_KERNEL);
-	if (!trees) {
-		pr_err("alloc failed, zswap disabled for swap type %d\n", type);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < nr; i++)
-		xa_init(trees + i);
-
-	nr_zswap_trees[type] = nr;
-	zswap_trees[type] = trees;
-	return 0;
-}
-
-void zswap_swapoff(int type)
-{
-	struct xarray *trees = zswap_trees[type];
-	unsigned int i;
-
-	if (!trees)
-		return;
-
-	/* try_to_unuse() invalidated all the entries already */
-	for (i = 0; i < nr_zswap_trees[type]; i++)
-		WARN_ON_ONCE(!xa_empty(trees + i));
-
-	kvfree(trees);
-	nr_zswap_trees[type] = 0;
-	zswap_trees[type] = NULL;
-}
-
 /*********************************
 * debugfs functions
 **********************************/
-- 
2.52.0


