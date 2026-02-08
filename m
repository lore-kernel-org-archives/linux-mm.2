Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 427ADEF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721D96B00A7; Sun,  8 Feb 2026 16:59:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3706B00A8; Sun,  8 Feb 2026 16:59:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489096B00A9; Sun,  8 Feb 2026 16:59:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 321726B00A7
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F209859CE3
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:19 +0000 (UTC)
X-FDA: 84422656038.14.FD8793B
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C2F740003
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiBCUqW4;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdV+3Aw+NBxu35sOMXTrxQg3lkskWJESSW2tnr6DOts=;
	b=xnVoXNAJwz/ye9kO4IC5NCmd3S3/scrYqB21ewc2E5UUgqZgjlAHXA72hjZBJolFG1mkMM
	q6cSM7/WRiza2yU6yOF4b2X4aV4nOenBQS3HR7oCQ3L6biWQx8c4mvwwLwv6jgLddXWuV9
	T00PPkfm6tp97kbX24r1tzq1NQm6T3Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XiBCUqW4;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587958; a=rsa-sha256;
	cv=none;
	b=TNb3no2Ws6fQiaqgrJPhK54LXURcaL4CGpsDfvQczUZGnAW3dYCtwWPVCuUDydxSGdLcz4
	dMh5s8a1qUayP6544Jm5Z8xfi5GmHSZwQmcHe6DIq4v8rmd8TXoxo6TXHp4AYxj0ed46lh
	eNDhd0ECTGuI94QYdPQLrf7N15GGoiM=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3f9ebb269c3so1748854fac.3
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587957; x=1771192757; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdV+3Aw+NBxu35sOMXTrxQg3lkskWJESSW2tnr6DOts=;
        b=XiBCUqW4TF5X9xOqZGHg1T0GwkAzj1iLF5k1xCM64K33vG8+Rkfz0wjj3DGpc54PoO
         yKjvSQs7M2BGDx645fYDUJFLkSw3TJNLRfmBVo3ZMtXJmmRWl6uqnNdaMh1/XMCW81Kp
         2HuOe5CkN9TylovQh6mmnXg8KEut6w1mVCNDzdWPqSOlWXqZX2l2cwo7AsGbsGiLAk4A
         HMDegOidilBRkdyCiF9smjsPLxNgCAVFzpZMvix+6MK1z8zWn8V90Pc6QpHIuJWYFkeH
         vZdacdr177mWDD/bshDimVywK/PrAEpq/m5CZ+YLWLQ7G76Tb3nXd/SJVDIY7+1IZfR9
         BzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587957; x=1771192757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YdV+3Aw+NBxu35sOMXTrxQg3lkskWJESSW2tnr6DOts=;
        b=doIQJSQUaQ+gPzYYpERYCAotA5padJIvlf4/pc14ThoWLpxyCNL+C0DmaaVrYMcGWT
         Yo0DOKJ9aueXjJ6beeWnQi42ectVF2Flv0cDG7YgV104Hp35yv74YEwms/O7z+5jowbi
         o74uc/IXqEc8YFNeeSSvzX2QOjV8tRF0wPFBTKERvCanQDJ2NrfkidKxTN2X76IlH5UZ
         Q4QC/SD9m+ailmNICtV4OuYhlg3uXo78//ClpUrytdOJr6/MiBrtD+PtScWzg5Y7RLmp
         TxyfOoGIW+x7KlTT6Kr+0mUCQqht1hylQo05bCbL/Hfs7PlQr0DKjVwb6BwKpCslwrgt
         w9qg==
X-Gm-Message-State: AOJu0YzR1O28UucQ2URGC5/4yacCRgqBfryFu7a0vy7A8M/bw+r7SXCW
	ajcukFjrzNjZUK4wmJ16Z2JBTpxYSufQ96NY41ljY33EF+EIenaMlDLy/9FihA==
X-Gm-Gg: AZuq6aIwvAFE1lGcdXmEYKKAHXPJ9Wvb4oSa3q6wFUGm+n0k1h8SgxMliRWXdFKeGmB
	NR1I38t9gchaa2BNNiOJmv6AVlBqHci7AlWqZU10oy2c1jyEflabS8iWqlXprR3FjyxrRP49EOB
	A9IfQImsK4sUdSNfxFViudQOhil6osSytwVPRj84s6DsvY+1YiD9IvFiyZLFuqPJPgjbEu1YAtR
	0OtOoN4mchGntrmT4aDlFzJHf8CGUu8pC563SrUcyxXvXurTQ41WakQs5qCPaOERXlXKN+IQ+Sh
	m3rTIBg8UPTaBYX/PZRy0rrUSnEE+XICe5mUMYQr+SjPQHz99kjUKZoKPqcZHfHr7N4Cc9Jt87/
	plOt7wMemEcXg1fOiTbKkT1Q8k49+LgEnyAHRJ66ompCwiyvqX/jsuXvGNxEfaFjF62Ib8lxXiP
	6jcT5yd0iJvjKRXf/R2sbP71+rFdzh7z/zbt+zKjmG8pY=
X-Received: by 2002:a05:6870:829e:b0:332:8989:4ef8 with SMTP id 586e51a60fabf-40a96ec6c37mr4495223fac.31.1770587957178;
        Sun, 08 Feb 2026 13:59:17 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a99355b7fsm6268799fac.8.2026.02.08.13.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:16 -0800 (PST)
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
Subject: [PATCH v3 17/20] swapfile: remove zeromap bitmap
Date: Sun,  8 Feb 2026 13:58:30 -0800
Message-ID: <20260208215839.87595-18-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f7od6w38m4ahzaqr41w94987okr413kz
X-Rspamd-Queue-Id: 3C2F740003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770587958-612105
X-HE-Meta: U2FsdGVkX1+t9LhjqC4DkALcFwPPBMijhEd02/5xMQqgrMLz0xlYPvdcn4URSbCxvSe6ioGaIFLGN1Y3sXsANXIKKMvGgPhKCAFeWnuNpLcr/ITYVtfF68KjE36iqupueuV72gjrFqsA7kFgZy4RzC2sIOhpxv/fGa/nn1kBr3q6ws6DdMJ19oNSQ1c/VgSH5AW639qXCgUsYxUfQcqF0ZfV4V4iawd89DhamGIKLjXO+DkBx6PRioIUukU4JJNnPh64ENvsXsJRQTD9HsBaNYzTi1zyr2Zdeh0l1Ugb0Krnf8X1iVQrHYFEF1jAKE94aYiVSSABf/M+c0uyOf0NuhPCnmkqvtvJS1XJfaMq469ZwbAoQlQjRGZV6DRgnqrVhWZuSKHqpSbDOm/q/k+C/kVyD35VyahRazM31vpAFOr8eSJjaPg+rCJ3cuzFAuUcmDR7MEsB0L3BnlxoH+qWf1UttetKtWLk8uOXsltAqJII4yoWzt/WEnyogJ6zokegWhb5UyafLAlJywj2/pcTEmiu8xDDcGn/QKEFBAKUSrznpNj7Gix4sDuztcEINvoyhTjRL5w4hNReG6rXr8zGASRDIzXcYAnYDFvNKR9cY98fOl2bjejYb5HY+GEM6WsvLHsmTCirEojo417eYoN7zLAmN3Cf29FaDRP3D/aPlsy29fMaYraaS8rC6H7Gu7SOedccCZdo70+vyD4BF3fP8UFGhltqeJcDCvnF0lSGy/KTetx0iTcEHLaXyEvjsR1sycqCjrNiF2PPZwUx6YRuLcX1K/K8mzfyO+DmqOZJzsjteSUDTiTaSpVkHMojd/foJDZCZ5MHwmYCVbHz7Ggszd3slVdHboEDedHgIF0mC8bCc6LBc43o8sZC1LUf5NmjowHNJBWb3m14MEX5q5bBO/M3q/Be1ge4KFCN3B0sdUDO8lD0b1b1L8EeDqx2KrarxxKWgk2P4qLnOCy5Ogo
 P7ms2s/F
 hMW8C1Yuhhr7d1FsYmdXar9ZOkg9noH13TAAjjTGGV/Nuj5RKQLqUQYAFldxWyS366FeH+8xe31TGJhgsdKHSfZ/vYc3H7f4JlwqT80XmuLvOniPJVNiVCM45c4wu+QqnQvgh4UdReuBMPCShLo9g5H7p2reT/8Fj29IPNnVgRIcNHVHIzdJpcHC6XIvQbq85NM/6Y9DTNZ9ROdl9PVz+AB3RUO0elKdn5Up0QE53uZOfQ2+vOIDUQQKqY11dymuVGymDsdAJeWtJ8PBeqSbqEM3qgNC2NIjf/TxYwmegV3C8mEPy/cGJXhMZpBdkQJnb/9byMLW8rkpojnh+ui5l/BzcsRYIGgzArztUuqzVwpaqD/EB8T+kxEM5HFgdSAmYeVp9jkwJGUlGn8g/G5SnvCtRUQ6HzzT0L3iTd0bp7+LUA1Ivsil64xXTFdPJQX8gJridvDZc7sVB1yzOd6Qt/QvA9fBKbBHxvpu5RGRbbsdU+enUQyivLPi78L684/rTveoUz4YU75dIEIc/F9oA9yqLJQw/16HM+0ap
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zero swap entries are now treated as a separate, decoupled backend in
the virtual swap layer. The zeromap bitmap of physical swapfile is no
longer used - remove it. This does not have any behavioral change, and
save 1 bit per swap page in terms of memory overhead.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 30 +++++-------------------------
 2 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 54df972608047..9cd45eab313f8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -260,7 +260,6 @@ struct swap_info_struct {
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
-	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1aa29dd220f9a..e1cb01b821ff3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2317,8 +2317,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
 			    unsigned char *swap_map,
-			    struct swap_cluster_info *cluster_info,
-			    unsigned long *zeromap)
+			    struct swap_cluster_info *cluster_info)
 {
 	si->prio = prio;
 	/*
@@ -2329,7 +2328,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	si->avail_list.prio = -si->prio;
 	si->swap_map = swap_map;
 	si->cluster_info = cluster_info;
-	si->zeromap = zeromap;
 }
 
 static void _enable_swap_info(struct swap_info_struct *si)
@@ -2347,12 +2345,11 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
 				unsigned char *swap_map,
-				struct swap_cluster_info *cluster_info,
-				unsigned long *zeromap)
+				struct swap_cluster_info *cluster_info)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	setup_swap_info(si, prio, swap_map, cluster_info);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
 	/*
@@ -2370,7 +2367,7 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si->zeromap);
+	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -2441,7 +2438,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
 	unsigned char *swap_map;
-	unsigned long *zeromap;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -2536,8 +2532,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
-	zeromap = p->zeromap;
-	p->zeromap = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -2549,7 +2543,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	vfree(swap_map);
-	kvfree(zeromap);
 	free_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -3013,7 +3006,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	sector_t span;
 	unsigned long maxpages;
 	unsigned char *swap_map = NULL;
-	unsigned long *zeromap = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
@@ -3119,17 +3111,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	/*
-	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
-	 * be above MAX_PAGE_ORDER incase of a large swap file.
-	 */
-	zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
-				    GFP_KERNEL | __GFP_ZERO);
-	if (!zeromap) {
-		error = -ENOMEM;
-		goto bad_swap_unlock_inode;
-	}
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3196,7 +3177,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
-	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	enable_swap_info(si, prio, swap_map, cluster_info);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3224,7 +3205,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	kvfree(zeromap);
 	if (cluster_info)
 		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
-- 
2.47.3


