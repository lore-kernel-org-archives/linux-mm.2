Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD09E9A046
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F186B0095; Tue, 17 Feb 2026 15:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ECB46B009F; Tue, 17 Feb 2026 15:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA8C6B00A0; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE0A6B0095
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C11C160323
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:55 +0000 (UTC)
X-FDA: 84455031990.06.9790FC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6746DC000E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uf+6IuFp;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVVaxFeCEXdusQ44RxyVZKDIk3A6JQjpN0A+3oZBhdA=;
	b=6yhczq+P0rLnli/0X7f7dcIMbIFDZVlEEsfjNSyqwZT6reJGqT7eyDkg4G7Mur23z0FmlR
	7PEsNgAY9P+wlDjH0j7bzUdBE/J6RW59B6C35vPPXtK3rhHrYqlmJL+5yqJ/4KuAy+CvUX
	dcK5NK8f02tNGT8iAw23LTZz1RBIWRo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uf+6IuFp;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358813; a=rsa-sha256;
	cv=none;
	b=sFAAMsBfgKv6YnwzTsvNEI6jio5a+n6aiCy6wNEbElIVIfJ/b+rNQoTSw02mcg9VMIml4d
	whm/YzbtoEDJMt/WiNCfKz5Os9xnmFZA6XOa7LnBwf3japX1NIlXYfCXGBdUdc2ZRQ2Btw
	AeGeJEBgsp4UI0jVg2jR6imM6HT+m6Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07DFF4457A;
	Tue, 17 Feb 2026 20:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D58BDC19421;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=lkvo+r1Vv+yQtg/HXKc6w9CnaZkujAHTcZpC1b096Ck=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uf+6IuFpHtJne94zrrs2xlJWs3MSS3E/gZ4EdCiQEqtvleG8W0EmB+L31ASBC1YIQ
	 A7E/dpoQprqvm10lCSpXYMaaW30OEFfWk6eg1VUTyjvMdLVQ/JOudC4Rd3rWasIFrb
	 IuWUm+BtkuH2MhCQocLtqb1iKzbg1bcZK4DiG0lKQMpfgGn3SlUiMa7bm+j0iJCY+Q
	 J64VFOc2RBjMUnEgekJUCoyLZZBqxM/Y8t4gGT5GehAAPrFCdDmUM9yeX9mvCZqC4V
	 3zceMK6Br7PqU45q7vfobL4afDDI36/oL6RN/OZI8qTuvLsGqmUhUmlkxICDa/hhux
	 IMRK/yaEZp8hQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7519E9A03E;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:26 +0800
Subject: [PATCH v3 01/12] mm, swap: protect si->swap_file properly and use
 as a mount indicator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-1-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=5423;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=OErUm6YzDXG8MUnIOgrfhhtTdULgZJzpg5xc2rcjJG4=;
 b=KefXHGVHQAdLFCFWu9nqJfG3nJH7rws2nW9hIB7xb9Nm1CovW7LHFC1ilWbZagYgRGOgXBJ9F
 i0WZsakiuEACJSPGsYv8bIL3j90aQTgfDsJQPU/voTO/wk/Fe3jfE8U
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 7ndgye6yf74uajtk3oekd9ifzccshzu7
X-Rspam-User: 
X-Rspamd-Queue-Id: 6746DC000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1771358813-661233
X-HE-Meta: U2FsdGVkX1/ngE4d6AbTs2plPVzMhAocR1sip8axijO8Vdk/bdX1QLzkUUo3RzjKd8CbtoRMwLGJw+0d0lp+PNnmyOyMJv+5XYNTNwVsSbbIm76EEqe5C4nIkylqsmete6naPQ67nxoPUTTiXJup6OpIArcKskZG/nrKlto5v/X178iLkEl6NTqvGPJYaGBb42fVvM1AHbZBSk84qkoq0K4RtkCcNVkJma1JEiH+gXl/q8Ez995Y8bcqepEz40fwLgT4QXMbiJzwlTtBkGMdYfviMLRJFmFlpGa0IX11hoGolS5YU2/2TcjycYVb2NPfoYHgBykKwyW/muDeFs9VHY3PrOFZXfERcxkx5QOkXPyqUHBrV8NLQtsJrYAEXhw7rTUfI0MQZA9RO3UMKIWpZgPLwngxGMUOER9Hj17USP2HL+xSqC/dK3XVqtRsYJrWZ03rsWzQG6daShE/hpceDDMA0WBGsyMoX3w5B3JHBi5oKGuLfY+p2BO4XDGcSQisLkWNL5GYVk4ofBks4UHrP1DFtguentDmN7ZByVq73VBrm1sZbauvNLIUWIP3JTfrhIp518ASsF+TaSEU6nR5sElOXvAYjcVoIY41BA6GW4OF823X5fOIeI7b/OJ0WbaCfMY1w+R4HeCp2o6uvCB8BYrVZw5y7BTMVhRozZXl44JkHMJ9TNOJlSBEFIXuEFrEc+x1MOhLH7is8A/14ww5qmkjapo4JmUl10hepJ5Kps4XAPr7cNPMTLU85pP40fg9MiuYyKz3+mzsaz3fNXHRz7ZILejw9CsNJF7M+wZm0D03dGEmlqFnyaix1hqH37BMkl1bzE3+wXsxkn7BkFak/Wg60PImpfyQZBpR1wmY/Frbzq14JvkLX3KDSNRjeTwRiJupyXz28foNH1M7zKaOxz0/Dr1RgxKB1y6RR/5CWXq5bm+vDAaeswz3+ZIjoKDXg0x6gn1rt8Zk9bT6j5d
 rNjy13ev
 WUOqO708kDGE8nMAYekWOFBk/OI/Di975digGkJBKYiYoD5AIv8kpEm33OdeIAK5Br2D7aImiDQ9nhUCl7K+YWG+DI94eS6JWhJ69e1s5hVa8WLO3KY4MdVOpn9NZW+aA3iMV0UvdOX+/+segcxpmQ2eN6Pu2yZViJb8RTzWki1fcf+vdjdRAq5PSlpH1bnRqxDAhoB5Xu5HNv+S7cbOytfSGxAXFgV/16Y97958rYVxcWo6w09/JQQxA5giuMzGLMpc8bVg/mKfsgxkrxs03xALgpO+Bw7rvr6OCEbLEEJFRuzj5TWLGIEdJJUTFMQMmK5St1nuwQxkAPFC2jB5LamEMzhP4Uk8U/fPFyIUZdNia67Lmj5XFlogfqlK0IPu9CWNoVMe1opB04HW9apRs1LY5v/Zmf8HaIAFt
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
index 32e0e7545ab8..25dfe992538d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -110,6 +110,7 @@ struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
 static struct kmem_cache *swap_table_cachep;
 
+/* Protects si->swap_file for /proc/swaps usage */
 static DEFINE_MUTEX(swapon_mutex);
 
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
@@ -2532,7 +2533,8 @@ static void drain_mmlist(void)
 /*
  * Free all of a swapdev's extent information
  */
-static void destroy_swap_extents(struct swap_info_struct *sis)
+static void destroy_swap_extents(struct swap_info_struct *sis,
+				 struct file *swap_file)
 {
 	while (!RB_EMPTY_ROOT(&sis->swap_extent_root)) {
 		struct rb_node *rb = sis->swap_extent_root.rb_node;
@@ -2543,7 +2545,6 @@ static void destroy_swap_extents(struct swap_info_struct *sis)
 	}
 
 	if (sis->flags & SWP_ACTIVATED) {
-		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
 		sis->flags &= ~SWP_ACTIVATED;
@@ -2626,9 +2627,9 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
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
@@ -2646,7 +2647,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 		sis->flags |= SWP_ACTIVATED;
 		if ((sis->flags & SWP_FS_OPS) &&
 		    sio_pool_init() != 0) {
-			destroy_swap_extents(sis);
+			destroy_swap_extents(sis, swap_file);
 			return -ENOMEM;
 		}
 		return ret;
@@ -2862,7 +2863,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	flush_work(&p->reclaim_work);
 	flush_percpu_swap_cluster(p);
 
-	destroy_swap_extents(p);
+	destroy_swap_extents(p, p->swap_file);
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
@@ -2952,7 +2953,7 @@ static void *swap_start(struct seq_file *swap, loff_t *pos)
 		return SEQ_START_TOKEN;
 
 	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->swap_file))
 			continue;
 		if (!--l)
 			return si;
@@ -2973,7 +2974,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->flags & SWP_USED) || !si->swap_map)
+		if (!(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3390,7 +3391,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap;
 	}
 
-	si->swap_file = swap_file;
 	mapping = swap_file->f_mapping;
 	dentry = swap_file->f_path.dentry;
 	inode = mapping->host;
@@ -3440,7 +3440,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	si->max = maxpages;
 	si->pages = maxpages - 1;
-	nr_extents = setup_swap_extents(si, &span);
+	nr_extents = setup_swap_extents(si, swap_file, &span);
 	if (nr_extents < 0) {
 		error = nr_extents;
 		goto bad_swap_unlock_inode;
@@ -3549,6 +3549,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
+
+	si->swap_file = swap_file;
 	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
@@ -3573,10 +3575,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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



