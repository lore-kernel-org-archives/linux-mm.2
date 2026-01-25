Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94623E63CB1
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF016B0088; Sun, 25 Jan 2026 12:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F2C6B0089; Sun, 25 Jan 2026 12:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A646B008A; Sun, 25 Jan 2026 12:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE5206B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B8F513A1BA
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:08 +0000 (UTC)
X-FDA: 84371245056.28.024C28A
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 660B44000A
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nlSuNCRb;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXkKpfW2fKRP2DHBX2nOhkvpUQvYM7wlOqYMZBE7moY=;
	b=X4z9QJ+mXG4iy7aNJOmpMTs3e07FDja0svCLMWpBbqWq4KoretVOq9MYYhLnDrCJGqqf7i
	rRTgp76tJxh8y5GRtZqyK/2w6XUY3jT3RH1YAIMLwXFFefBIq5JxUrIAqHqsRp3PRy/IMH
	t24/GSJW/kErZbN0HSzmVfH97eZ1HBo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nlSuNCRb;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363886; a=rsa-sha256;
	cv=none;
	b=POOuWLeKF5XmHjrlWCi6cyYzboh47EL4HCR5cNWuPkQo+StDSnAi/CfZy0a16VrmnlrOiL
	/0sMroHEIxx9dnEIyF2BgPbxmBXlXN81mDNUoDdde+q3U1W3uvL1VwzyqlJWjcK4yS9X/z
	1eYuvp0CN8aVhQcI6auCrwTu31oZnAE=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-81f4ba336b4so3828575b3a.1
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363885; x=1769968685; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JXkKpfW2fKRP2DHBX2nOhkvpUQvYM7wlOqYMZBE7moY=;
        b=nlSuNCRbA8roFqNStUj33TG/PxQ462GC45UPHwT3MpBANg9C9CshgJmN985uNnT1D0
         LpLXiBEEW48yDLJFt+8LYWdNWDYqkFw+rj3VYOfIZFS2DVs9/19EXVd4lhdJSNGInBAz
         CTI7gl53PPxfPgp2BQvjpDpSH49dRtbccPtycVNb6WjtfCSYpJ/wVjC9S+jzEDDQQB3H
         oRdVphVzpbrn9JbJdfU17jyNU6c0DHclzhKfpiN1ymECS39T7JS4vk/I1efkw/5lcmXC
         Hl10nSChN8PVE0yUzoKLh/l6hEvcSwRGhKC3B9zGE5zQ4rJ4fBhsIc8YJziZwZ98EtjY
         bYeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363885; x=1769968685;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JXkKpfW2fKRP2DHBX2nOhkvpUQvYM7wlOqYMZBE7moY=;
        b=AnO9YJVpz59FShyjZ+f4U4nknhuredzFqfDjrxXG4gh530tHQatNL/Xs0pF/8iKQqF
         Rk3UHD5QavAj9GyvnfnokFG04RpH/eo3kKwZGigPQo2TCywXroUnKPNEP2elfewG1pdl
         MQ0W5pKWgsMwBHW0s4Tywg875MrPT9gGvHEUYvmatoX8hedLYPEPI2db87WRYeOVirsD
         NvIdR+njgujoygKP6hYdLJs3gIMAZgiazZjnRAk3ZkrbNPxwcS0/LiRo1CMqY6DyPmzP
         tjaFcTtxwWsBKd0/J1E+xoLJDC4ae3yKNlqLiPf7aU3A/bYcO+s0Bv9GaXJAMgGrp71Z
         yKsQ==
X-Gm-Message-State: AOJu0Yz22uUHj/Ey6S5H34NciW5xcXPQHYk+lIz24Ow8/UtG1ELz61QJ
	fl2FVQgw8Z/MJj86OI1YG1RZ+hHHSzKtRD4RS6zUXN4sD8v4nHiKTJ/I
X-Gm-Gg: AZuq6aJwyVYhIp5gwB+13M9AjxBnDF9FMczSx/HEpjptt4xBkQTf6KkN5bCw2pnI53Z
	5XD/KgB0tJzuK70ER1CPMA9UCmw6oQ8TplBzCRhmJKCrctLurAh7gYOgdam97GF+Ut//3yzjcau
	0x1IcxtxiaVcJTWhXjiBDWHBWh/4QbBRnheAvGQFoa+ZO4X3BqUlNMlx3yK434SK/yGTVeyeHXH
	TI5D9OgthyzNJHvnyJi9bLHXANqF7eT31d3WfoIYaPFf3vcZFupCX8FijjnLSddcXj57RKGgUEk
	asjDXmMH9AHeeDODe77MDXk3v6feA7WK1F7KHnYwUIE1o9LyiUWa1ndoaj7Z4vCCu8vVNq/CJDV
	+jhZKJTlnKzZcduOegXK/bNKDPydHxrpHlLGn0IkyOStfs09V2FbhVt2XVNrQdwKTd0U5idDzb7
	4SQlxiKSM0cXvfTuoOQ4QPUEDQXqpINcxC9Uuzsy44S0HK2aEg
X-Received: by 2002:a05:6a00:761b:b0:81f:4f74:2246 with SMTP id d2e1a72fcca58-823411fa543mr1939435b3a.16.1769363885303;
        Sun, 25 Jan 2026 09:58:05 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:04 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:24 +0800
Subject: [PATCH 01/12] mm, swap: protect si->swap_file properly and use as
 a mount indicator
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-1-a74155fab9b0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=5423;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=KCJ3euqA2qAaRKKZ+5BOjIB6OnqWy66OxHgNUHCngaI=;
 b=+gz5DUR9sRm7/DlBjNBzpGMqXfRha1zGai1p/b3tbjYg8aHCenc1uarNGtadbcM3aoVmafff+
 2wiceVFdUL4Dxgv2A1SJdkzRw26+MZR2C8HV9/QumIzrQcZay8aRMDm
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Stat-Signature: erm7iateha8eqbor7ak61n9odn97sse7
X-Rspamd-Queue-Id: 660B44000A
X-Rspam-User: 
X-HE-Tag: 1769363886-30110
X-HE-Meta: U2FsdGVkX1+SyhdeHOF05IbLQTNYjFQENCRv3DSe13rV0rOU5cd+5x3z0ch9fgk/NwSqiBUJ1gQYSAktyBcwlvxVm5UR7jlzwzuTb54/vwVX1Ej26BkggEhsiB5t3nzYFXWvl/OKFUUAXVcJYIi7+RtWh+43xO1N7PXGzuR/818J0bnOVZDDBWkXWp+aNv46Lw48WmBYs8lUdhy86DvYXMNx4Mfi1YzFRiZI+2KO4fwjJTIYZBf60SwA9xhGLJa0qdPb5nVZXmp4O501C2FDe2cIDJvyTngVQKc/NZ07/oOJrLanOmXDG232Hag75nr4G2OyFWlSoDMdmPBWSYVT68Ajyde6TvpceSfwtzc0Y2En+g50gNDGIo2VV4zRXG2X2crzQxQrN7TRF3KZf7M0cum6/jZRa6GI2P74Oe9c2bePO3cdrEIIdMou1AxEf1HrAKwhjxIcFLOOd7wdUcb4kpuSZGnpgkLiNtGBu1sF8MaTcRiNx4txo9LzzMrOPbG+7k6MndCm+V5wvRe+eXk2ds80mzw5aRTZ190pcLBGyGUyh/NUbB9aIS1BqcUZDULjYeC9WgteotNTCppDeJYz6SmUT7xS4H/2DkR2Qy/5VYrgUB1kITTeiY65pBOaKE/W53ohzmaw6tuNQByPRmR3zENbrPb+OrKSHI0O75QgpjpXAqvn0pC88DoYUvD/QWG8CDk6JDzClNStanDMbHc52aN5QbAFrisb2kLQXredCQF1q5PqtOyIsfXsKYXwRqb2H+yH1k+xtRJ+rhdfA0LyYZzobx86au1KgylrMAh45WvDURkT50E6ZpQeLoPtiDW0XN5c8nmfosV4iLJOibgE12VfxmT9QUbmgbFHlwvHwkkwKinylXgmiQiE+7/aHFBPW1RfoZKEb2C1a57TfscQdGRkwHuTtdNKodypOfHV2aQegkFq3/s9pJoB6MZY0PT4kAkhjHzGR/9AA56o7ZM
 hGufgTsL
 HK3MIMh8eeomXSgpr3GjAZuCQO4o4A+0yPYU41v433Z4hyQLrFQYGdpLVBmu59HE549VOluHo3nEFVI8s6cdcm0Yrr1KRJ1bdlMs6u9PHy4OAEOupMiXG3lIp64hllO8k4rvnH1v+BIkhIKCAiT7jJZY4lu25ske0XUCjad4XAso0PjScL8U7IYlulGLUAmTEHxgJA+BFlS8beCeWZiJPN857NFkzFUoPPEK4GDYIHfi2CHcOGPth0KN/Wf7/NjUv1AjcNYVodeGmpCFojjUhhG8W23mFm8Ox+hQqMp0tqvB/P5qtA+09kHKvVonhkqfqHzdMubLDUq375OXlI+hC2lIIrxsLmxLPWxWiQKyexde8OF8NiHHE2Oj9tP1bntpGlJDXXJrY8I0ehJSLw8odwwKPvCsghb3akPTILyKy0gwPnhgecLa3nCSHE3cSNqzdan/o5Vgro+sXZediq0PXj2DbF6coCM316F4i1G5DmALAt0b9Rcgb1bqTzRxM6NjTf6jDzc63Ht6jWwcPJ7VXD8+MdkCQSTxeqA4CpaK7osUWf2FJqD+nE5muhJE7fgrdIOMo
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


