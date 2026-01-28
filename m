Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA904D35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DA76B0089; Wed, 28 Jan 2026 04:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DED96B008A; Wed, 28 Jan 2026 04:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9DB6B008C; Wed, 28 Jan 2026 04:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1ED36B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8815713B223
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:38 +0000 (UTC)
X-FDA: 84380852556.20.27057DD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 83C7D80011
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KS8WfrQW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXkKpfW2fKRP2DHBX2nOhkvpUQvYM7wlOqYMZBE7moY=;
	b=ziRuzcv92Z1x9ja9JZfqXES0zggev9N0KuoFvdDc28rIxQPw0gd3svs3weOoVkeel+J1Aw
	VkpiN0UMzINtyS09faALXrHIWF69Rh/GE8sVK/0HAcl/BLKUAglSM9m/JTDkdYOT/YJiBd
	IJQvnRZPzX+iuyJwMniOiCaShtY+5y0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592636; a=rsa-sha256;
	cv=none;
	b=k+KG6Io9CH2V9QKEKyY9You6wWkkpigC3HsNebj0juaGVZYaakxQ0cE3P1Jwiq/yKuj8jp
	WO00/eU5zSYFhfqfW8n1bzvcQfc7AUz4pmSrms7nPpsMJ118d7KFqd+KMSEg+cvjEiGz/U
	tm+kT92Vt7WVXfbgDWKxhZPRaM5j3yQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KS8WfrQW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81f47610542so3539243b3a.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592635; x=1770197435; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXkKpfW2fKRP2DHBX2nOhkvpUQvYM7wlOqYMZBE7moY=;
        b=KS8WfrQWcH9p7Kd1TqkXbjyeuPsB7vMUw8TzMN3uuI7aYDRJMvZcspmDKdRZXynqUt
         Hr24CB3Y8MsEbOQPw4O+q8A8gCTGYF9DognGkKKwrjOy/OEHxqz5EKPsps8LRSbQUhky
         NXHCJvHuu7RQMKxn4eUI3vpAK2i3dnj+NVTLY4yKmcoS9oiw4/xbf6pHYiYBs7SBjxU6
         Xn0H1uvFL0j3Xjg9+RyIzJ2OUceFC5m/f6Epss1OrALrOqOQGu6OIvbburwJDXaIMDZk
         xuijHKP34aVf5YoHFtLSb8rkx0otFV4UGIVpL9k3n76QDELuYl5bHGg9yp2m2ahCjkEo
         WEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592635; x=1770197435;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JXkKpfW2fKRP2DHBX2nOhkvpUQvYM7wlOqYMZBE7moY=;
        b=A/Sa+8Ac8AsvevUIMnEx6Tf9w8Ood0qbpIyBfO7r425X7chvAPq+IzLlwEfOeBByiD
         OoPvjiRxEX/AT0DW9dWd2cOn9Lf4LO8vx4KBqjNXl7G6TtfdToD8takepAE4eUQaMZ2V
         /Sb/hA6IKZ1NS0EfnfroPSGTf7zKhDkdOXU6G962f4Rbl6W8mNkxqh/jZqCXX0s9FzLY
         cZhviIXr6IG4ucGlFHycxEGU/iibBBtFVSTaM0m3eO0lAqUbHLMbK0pUmeCYZVS6SAo7
         Gv5EYAGwiq0Mga+qQ3DoiOX3fN3ipRjVzr+JQsmnL4Q9Wb9z84ADgKCxJJ3FWBvmPdqx
         kAVw==
X-Gm-Message-State: AOJu0YypcLEgMVTka8aviJ4JywwNNY/z9eC4SvoFJr1KMikgysLUlkEk
	+DKSjSiv1nHd2Rrg4MO7UJzIe0dcoCvpabJblvUx8xhV+N+1aL5q6Lyi
X-Gm-Gg: AZuq6aJqFtc/OO5bckHX7OLeASRBl/9BzEL3IeC5ntJG/qSmK4KASvAQO+GfqFA524r
	2rVw38gIm9A2PWNKCQx4Q30DU7fyZQwvRuuZW5J+ReCo1JqMAEdNSeABErWJTxF+ecoBtJhrI3Y
	1QeeSHAjYeCQ+iRv5R69zUu4dPBJpa1X+AoIWHHmEjms/GDs9VqqiBq/ZxpyRgnQImI0usn9akb
	C4ZMkVLqYG5MiiY/Yq4srVjw0+szhPDog69sZEiBRwd+t6wGcOhqV6Tbe7SvY47rdQ4oxn6LmIp
	F3oJtoR880EC8c/77C4x2bRCI8FAgM36V+/S3GDJftyfP37keVubjnBOANBokqdIZxjMrXHgu7s
	YLZcnfwxFROvIev413HrasVqGKdp/1En3exlJe7ADuMfOOtLNskQe0yXF6PwqENfKPrRb5LLmRw
	PB+g3f5R7OPqTCpLQEQidSkTp7cQ86uEyP6wmfyjf3peezNKQ93MudE0FqWq90hSQhZVKH
X-Received: by 2002:a17:90a:c2cb:b0:34c:4c6d:ad0f with SMTP id 98e67ed59e1d1-353fedb04e4mr4505185a91.37.1769592635182;
        Wed, 28 Jan 2026 01:30:35 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:34 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:25 +0800
Subject: [PATCH v2 01/12] mm, swap: protect si->swap_file properly and use
 as a mount indicator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-1-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=5423;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=KCJ3euqA2qAaRKKZ+5BOjIB6OnqWy66OxHgNUHCngaI=;
 b=yUDffmpYnq0E0QTlzeFqQIlUHmu6snQJuTNpipCSscvVCs/a0w84zEQXy7hojSBMeXeMrbeiT
 uuD5ZksxBlFCx3xtlmgpeUcAp/e/Q7vCV0UdfEg0XIrukAPUSaAbqkI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 83C7D80011
X-Stat-Signature: 58sijs1x9xnhu5ag74uidtfyknnq6xec
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769592636-676359
X-HE-Meta: U2FsdGVkX19YrpwveZur+qb+rdPeWRYPOZrImjrM3sciqMsp8DeMGgSad7QRN5ISoHqI1JirbuJuVFDSvMROiXeJhtB4nMsHWFrwaRkMw640FIgBUOMTF5vdr6Tozr5lvVSXVBL7K+p9j+3xMAVkAdHRT4n9AU6YHiyZxrzISbTe07h/aZ0AoaMUmqlLjHZHPGJkLomJpGVHqB7UkP6TJinAj168AiAoHeI7REkeAQZyC7DOyZkMMTvWP+UjyQztH5FhtyyVjXlkmTHWTh+MkRo9rVEzTGlhXgivh22mv8cXXJGOTwfVNJ47cXk/hU38K5pYhPPxXdDMoJ57JMhTxjlBLhce4y53aI14ULM5cGwyGsMC4C3NZX3yc903TDAe9JSbTzEpGcjenlTgJj9yi/63CxgwnFB2cNVZlNYcxLEHXiuM+1MxQ+4nvYpPOM84PGbkXZZo7NH0JIOb/vesxw7NLc3cc8VzJqob6chwer2jBgQncVHrAgUO4OwLVKZwshoS2zrzPF6I3XVjJ9Ii96IUqVZwn5k3W/ZE9U03G+/Y4NEl/5hTR041i39HF6i3oeFYN2LfY5YaMmks4kLgFFLz8MHr/VjVM/fo3TIbHfOLlr0hNgXc2tUqk4H41t/9k4M9AVA4gIFzv3JPazAHywhflRsQWnA7ef5w0xEZTXZPzfi81yR65KxOQAyw/Bcc175tByhYemH5tUe22oB7B1e2i+XhbIoH1XFGABV2ASK3gXoZySlGyr6bkWGx70EWPpzlhdoZkql71vJzdj0AWgOciFCUwWSKW71bo4n62MtapLh6A9Efh+Q1J85U33UMbvMTA5YWb+Bc+GTJz1+X6EVBaxqgcG7iwUbItflybxNs2qhtxikDyE/7W0QImZ2sfGdfDo9yRs8y7AiA2hOaj/6Vp4FzkEkiO14BzYSeA/fh1MRbq9qtFI+fpolfRk9x+pXE539z09JLJwjVS2e
 Hc+RnIQi
 +q4lJbB5xOfcDNL/0OCr5RNzJ88GRSCwzS6dUcgv+d7pIbsLDVJn2NPmrXVnVp/ls8dCnKChVynuujw7P9meJyv/ZzzGa7vsg6KBk8Lu4CIsMEfCeULgdeAUVKK9mDPrHhxy43UYtuNmqzyqlE11875U7eHS/HPtV7iZhwIHdxLJ8+kh6IJ4AQ0QRB2MR060fiFFOCTL4jQk9Pe8abu+T3tpAzbcDnFSVZH7OaSAgeS1tlPEuT8P93ZLi/bbs1CvQQO96Odnr7rGa98+3TIcdxiC0ctH909E6s68qq+DJhuPenu+pODhGqzH8bG776K7iWOm+lXvvvf1hja7zXzp5qXOb/Y9L98SRXquYLjJBOtOUH/Qn0v9YFpzkKwU8TVa+1ucdATnZau9JWaCnXkoDWBgIlsYK6BboMijrz/VhvzqkdfqGapAlbupLHcj1vmxYJXcByIBqbvYKvHSMu0Uc5tQumq0IhmplPDN7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

/proc/swaps uses si->swap_map as the indicator to check if the swap
device is mounted. swap_map will be removed soon, so change it to use
si->swap_file instead because:

- si->swap_file is exactly the only dynamic content that /proc/swaps is
  interested in. Previously, it was checking si->swap_map just to ensure
  si->swap_file is available. si->swap_map is set under mutex
  protection, and after si->swap_file is set, so having si->swap_map set
  guarantees si->swap_file is set.

- Checking si->flags doesn't work here. SWP_WRITEOK is cleared during
  swapoff, but /proc/swaps is supposed to show the device under swapoff
  too to report the swapoff progress. And SWP_USED is set even if the
  device hasn't been properly set up.

We can have another flag, but the easier way is to just check
si->swap_file directly. So protect si->swap_file setting with mutext,
and set si->swap_file only when the swap device is truly enabled.

/proc/swaps only interested in si->swap_file and a few static data
reading. Only si->swap_file needs protection. Reading other static
fields is always fine.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7b055f15d705..521f7713a7c3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -110,6 +110,7 @@ struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
 static struct kmem_cache *swap_table_cachep;
 
+/* Protects si->swap_file for /proc/swaps usage */
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -2521,7 +2522,8 @@ static void drain_mmlist(void)
 /*
  * Free all of a swapdev's extent information
  */
-static void destroy_swap_extents(struct swap_info_struct *sis)
+static void destroy_swap_extents(struct swap_info_struct *sis,
+				 struct file *swap_file)
 {
 	while (!RB_EMPTY_ROOT(&sis->swap_extent_root)) {
 		struct rb_node *rb = sis->swap_extent_root.rb_node;
@@ -2532,7 +2534,6 @@ static void destroy_swap_extents(struct swap_info_struct *sis)
 	}
 
 	if (sis->flags & SWP_ACTIVATED) {
-		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
 		sis->flags &= ~SWP_ACTIVATED;
@@ -2615,9 +2616,9 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
  * Typically it is in the 1-4 megabyte range.  So we can have hundreds of
  * extents in the rbtree. - akpm.
  */
-static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
+static int setup_swap_extents(struct swap_info_struct *sis,
+			      struct file *swap_file, sector_t *span)
 {
-	struct file *swap_file = sis->swap_file;
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
 	int ret;
@@ -2635,7 +2636,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 		sis->flags |= SWP_ACTIVATED;
 		if ((sis->flags & SWP_FS_OPS) &&
 		    sio_pool_init() != 0) {
-			destroy_swap_extents(sis);
+			destroy_swap_extents(sis, swap_file);
 			return -ENOMEM;
 		}
 		return ret;
@@ -2851,7 +2852,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	flush_work(&p->reclaim_work);
 	flush_percpu_swap_cluster(p);
 
-	destroy_swap_extents(p);
+	destroy_swap_extents(p, p->swap_file);
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
@@ -2941,7 +2942,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->swap_file))
 			continue;
 		if (!--l)
 			return si;
@@ -2962,7 +2963,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3379,7 +3380,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap;
 	}
 
-	si->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
 	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
@@ -3429,7 +3429,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;
-	nr_extents = setup_swap_extents(si, &span);
+	nr_extents = setup_swap_extents(si, swap_file, &span);
 	if (nr_extents < 0) {
 		error = nr_extents;
 		goto bad_swap_unlock_inode;
@@ -3538,6 +3538,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
+
+	si->swap_file = swap_file;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
@@ -3562,10 +3564,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;
-	destroy_swap_extents(si);
+	destroy_swap_extents(si, swap_file);
 	swap_cgroup_swapoff(si->type);
 	spin_lock(&swap_lock);
-	si->swap_file = NULL;
 	si->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);

-- 
2.52.0


