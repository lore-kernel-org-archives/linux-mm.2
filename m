Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047AFE63CB1
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E586B0089; Sun, 25 Jan 2026 12:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F786B008A; Sun, 25 Jan 2026 12:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409C66B008C; Sun, 25 Jan 2026 12:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 34DBD6B0089
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDE9A1B03EA
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:12 +0000 (UTC)
X-FDA: 84371245224.14.462F6FE
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id EFAB61A0002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BqnUjz1S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363891; a=rsa-sha256;
	cv=none;
	b=Rys0nnwoMQKpbEe9+cUaul6MNlj9SQ3vTXP72uQ2eGfFgE3GStW+ucWLaB6p6aM6vdL2+M
	5/eQsbFsSuHm3x2b3tuussJJU0Xf56hoqyiNjFSGr5r0mkGEpKzNOiN9xGa+A60d73OX7R
	xnJxGOzgny/iOOqfIGs6hNNWquXaSlA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BqnUjz1S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHlSAs5DuvtfLFcO72y/SZVl/BNUOfJD+/3/mENU6eI=;
	b=ucW1bNxCZXvnp8xpOG1OW7nWf6bHfUX8MBtKs/CIc5P8wbkcnDEipCm32dkz5013rHKeAP
	XBTp6UxTHIK6dO6e5gFIydXfPlsGYXyjSlQHawbYjzOAZhkYcIw6lCP+xxm2GKg6rkER+P
	/Vmud3KFV2JFO7MMYJpV7Eu9f09UTkY=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-81f4dfa82edso1605829b3a.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363890; x=1769968690; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHlSAs5DuvtfLFcO72y/SZVl/BNUOfJD+/3/mENU6eI=;
        b=BqnUjz1SlmiXniD7oHGkFgpmZzePEGi+fL/hYS+U1yvtOe5Uc/WVERWjEH5wEB1t1m
         m0e8w+dPHEg8nCLfd9hiUykJikR8gBUPrmAagM5zCHZ/QHKaHkBxG2gq/7QA/nET29Di
         gaQO75K9TXP/FjM8KSq8UssgWg2HAdTZzJ2WH8SAfQPXTnXky39EQZ9gKRxRH2WkxeGO
         6CFOksubbU9d1DXhbTdBNRhePThy/C3Sk33tyK8NB2JgwObZfFpJ8bpFFWxevNg53faQ
         47UClaz8KpdVqvVgLmIULnFQb34h2Z/CtrowAD1dfD8Jtud+Wt95H8wEHQGCn6c2Z/vY
         ilnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363890; x=1769968690;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jHlSAs5DuvtfLFcO72y/SZVl/BNUOfJD+/3/mENU6eI=;
        b=M2V31yAgI74aNS6V/lT1E0dJvOZeXya1+igk8ihGvXxUHlH9owvlQxXcfEBzmNpprQ
         iI2foBfxpwn3T4OJ850ukCG0xKctY0GUQhcsr4zEuKhCTFEJpz+/o8xeBp9o9zdqixnt
         5e76QGWqs3lRWmXSjS3A5fQEXPEU3GUObR2k/OhD0TcEgFUSlrAxkKEDF+qZ1BlA1Itz
         H3IEjxUDZWzZq31Njjby3QIK0PR97iw21gWzimevl/66LPCNSWpCa4EUZtxS9lPbyr9x
         ZVuj7rPYFyJEFzc4rU4AKQgaxoxHfForrhTU6vVh1X6GgPLRl58nOsu0k8PatlCsTfVT
         aGog==
X-Gm-Message-State: AOJu0YysbghrN37bzfs772Va3QCMZYhLpZKlCp/Ol/ykry5WNu23Y2RU
	6d55Qtd+PLiyWkuEQyMh6s8xxLOkOadLqCSmQtdgNYDVGgDc19eAgaNN
X-Gm-Gg: AZuq6aL9LANMtvoKn3Pa7vdkrqXNlRggztltJgtGF3jM4YlYWw3ESg7y5+1eoBGOw8s
	hVntW9v0S+LGLWS7orgveoetWCkuGv4YYuvOsRh8plpmbfDkRK+1YXLiKQcsa81dO+eEih1Va4F
	WLANwaU9bChhLA06V5ZVyIuRtm85pbi64ceTijKgHiHa4YOj/dbM9bzHg7QziptQ07t7ssPTCFG
	8N6fo8L1deF1ho2UFFvEj9igtQZodWEVGtNdxs5LQ/DMPcFMGy3thS5w3MEvPwjKEesEIAVHmPQ
	Vc3/fvHgKRDS/IX8wW+93yeykLnGXZmsw+JKI64TjbejLUyVQNyh1Fx/Y3p1yqimeVxiLreK+IE
	ABuSxnqXdyJdCNdLev15CitlA4Q6thrHgCz8x7NJL+n29duHeODy4PIbxoIm41A8c8ghRELXZXO
	lNe78vCH67hcrHmDKF7E+LmhBpHzt0pHbmeIUMG+MrtMIRIYRRiFq9ycZ/52Q=
X-Received: by 2002:aa7:88c6:0:b0:81d:d666:72e1 with SMTP id d2e1a72fcca58-823411e00b6mr1765829b3a.10.1769363889653;
        Sun, 25 Jan 2026 09:58:09 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:09 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:25 +0800
Subject: [PATCH 02/12] mm, swap: clean up swapon process and locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-2-a74155fab9b0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=8467;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GJOWST4EwFrMORO0TdNo6OHVZqB7RqYtXfEdQQZxN/s=;
 b=1+Q0vMwGlsfOLBPgZnFYykSZjHWaTml+SZM7kwZ5syYpPD+PnO8XuyTJXA8RNo2mdHC+SJ0hj
 soclkuBW5DXDg7uHf8r+yXfzeah0MBi6BWWAr3uvZo7zxtFLbxbMiri
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EFAB61A0002
X-Stat-Signature: 6ogfdhr9w6kwempggquo73t5ywnj33hp
X-HE-Tag: 1769363890-155758
X-HE-Meta: U2FsdGVkX1/L50octJiI1FkgnfNQU4fb7FROIFhx2Sc6QRU8xz2lMsrCCxXVx/9i2ZtMDvdB5EkI1yawE40H44Uya3RgQq2CX/2Eevrvz/BiLeNxufadxiSJoXp+mRcw8KPPPV4FuddDAbk5dOBI+TdAgZLGCE/KuMMDFwRvehOC9RQn2MoyaHNKvpHCHDmJKkkjgdWdQaz0n/HSaj9eczsnJZRC3A5Zb6jyJIt4l0u+jb9Z2YiLAYF16k1vkkrBdnrzoVceX0dOal30RLLHCUha+2aQFKanDxgR5ExEWjPvVBx9NeziakXZAhxriVjK8B8INFIPbM6kXGu+nFu/jsepalirgX8mGZPDylQvK3PZIjM1Fn4Uh1vEYIrDf9C/hpQDR/EIUwBOYLKbFvOyygmUIOUldiUA8rbOu/42lq13bsm0/hieCqPDd0t4MBoawtfKWsVKRxy4PzsDgUgDJW2LWqjO5O+opCP2h+YO2gSoBdLeojk/XS39BG4y6gN/+yGtkMHV/z/FQMonSnbbPcVOZD/2ss6qG+bU2B11Eq78KM+6x0nKbmDWAyzPIGFe2XheEqjhRZx/9+vHTWDSjc2RNMiXRKc2g/+/rlRmwj0uexN7SZt1deP6nfbKAQiPV2uE4Me3oIWr33yhqFK136/J2xAaetgquCfTPmM4S2BqZxuqjdZz4ERMOPzv/Gm/mhqeG2cSDFThl7xbCdEpqf/BhuQJ48MciS2730N5InU9UinYTtJ7cgz0W7v64K/XmuR8tA2KgGJwRNCL/DdjKhPUHxqFcDgH1e1rilxNea4YMRflogOb2BTiSh/YghnmZPrPshjZ5hvs/w87Iu8lTxaw2xSVDDkQMQxPwfrOEMy/9q90L7Y5cDFapzs0dokJZoTlpSUf/E6iT7LtbI/eqPXWm2oEBt6k1PnTiiOavxXd1wA/62dySDLBtShGssasygnqwiF3mkPSDQYYX1H
 /A+zSJg4
 YObg1zWKvhg0OpjSMWSYEodQysq+7NPskRI7+3bNavnvq/EidGN9Qve72fo4oCD9j5J9opMBC6wdT8Q4AJby+CTASMLOLJkDFhzhdaF7CyxoqQychRwKTkXuVV4JzBvY5iADftPGHaIol6L8Yrt1Ht3eszuW6nUTDTMdDOyiO0IW2TSAOWB3WGIY6wvo02OA8XG+MT+xmkuCwmkuoMYUkIJim8jKHF2+2Vof2Cg6Q2uQhxvy0uJXPdfDyLh3Nicpn1wSak7iGih+QHpUCFYaCTHMFCq/5CAGZY9mWkttZQ5/z2MMaC5jNrSN9Ukw23g4vN+tP5LXyJjgmn4Wkc9vuqNIP2+vynf1Pn65159ORvyeOJ/eKJaYzwcnqXBoIo5D/LUOdk38cyNsR7hX46AxRotlobUZJBqkreF30K+6KbsmvzjP0zGimZaavoUOV2MpISXGjwD90pJ/VrRTnFk1Avp8YepmFLRkWLCI0OpvDYPi49EuUmIVQgBsENwVjGkDCdSw/qH1dO9ykU/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Slightly clean up the swapon process. Add comments about what swap_lock
protects, introduce and rename helpers that wrap swap_map and
cluster_info setup, and do it outside of the swap_lock lock.

This lock protection is not needed for swap_map and cluster_info setup
because all swap users must either hold the percpu ref or hold a stable
allocated swap entry (e.g., locking a folio in the swap cache) before
accessing. So before the swap device is exposed by enable_swap_info,
nothing would use the swap device's map or cluster.

So we are safe to allocate and set up swap data freely first, then
expose the swap device and set the SWP_WRITEOK flag.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 87 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 521f7713a7c3..53ce222c3aba 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -65,6 +65,13 @@ static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
 
+/*
+ * Protects the swap_info array, and the SWP_USED flag. swap_info contains
+ * lazily allocated & freed swap device info struts, and SWP_USED indicates
+ * which device is used, ~SWP_USED devices and can be reused.
+ *
+ * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
+ */
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
@@ -2646,8 +2653,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 }
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned char *swap_map,
-			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
 	si->prio = prio;
@@ -2657,8 +2662,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	 */
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
-	si->swap_map = swap_map;
-	si->cluster_info = cluster_info;
 	si->zeromap = zeromap;
 }
 
@@ -2676,13 +2679,11 @@ static void _enable_swap_info(struct swap_info_struct *si)
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-				unsigned char *swap_map,
-				struct swap_cluster_info *cluster_info,
-				unsigned long *zeromap)
+			     unsigned long *zeromap)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	setup_swap_info(si, prio, zeromap);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
 	/*
@@ -2700,7 +2701,7 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si->zeromap);
+	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -2724,8 +2725,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }
 
-static void free_cluster_info(struct swap_cluster_info *cluster_info,
-			      unsigned long maxpages)
+static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
+				   unsigned long maxpages)
 {
 	struct swap_cluster_info *ci;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
@@ -2883,7 +2884,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
-	free_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3232,10 +3233,15 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
-			  unsigned char *swap_map,
 			  unsigned long maxpages)
 {
 	unsigned long i;
+	unsigned char *swap_map;
+
+	swap_map = vzalloc(maxpages);
+	si->swap_map = swap_map;
+	if (!swap_map)
+		return -ENOMEM;
 
 	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3256,9 +3262,9 @@ static int setup_swap_map(struct swap_info_struct *si,
 	return 0;
 }
 
-static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
-						union swap_header *swap_header,
-						unsigned long maxpages)
+static int setup_swap_clusters_info(struct swap_info_struct *si,
+				    union swap_header *swap_header,
+				    unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
@@ -3328,10 +3334,11 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 		}
 	}
 
-	return cluster_info;
+	si->cluster_info = cluster_info;
+	return 0;
 err:
-	free_cluster_info(cluster_info, maxpages);
-	return ERR_PTR(err);
+	free_swap_cluster_info(cluster_info, maxpages);
+	return err;
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
@@ -3347,9 +3354,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned char *swap_map = NULL;
 	unsigned long *zeromap = NULL;
-	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3360,6 +3365,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/*
+	 * Allocate or reuse existing !SWP_USED swap_info. The returned
+	 * si will stay in a dying status, so nothing will access its content
+	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -3442,18 +3452,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vzalloc(maxpages);
-	if (!swap_map) {
-		error = -ENOMEM;
+	/* Setup the swap map and apply bad block */
+	error = setup_swap_map(si, swap_header, maxpages);
+	if (error)
 		goto bad_swap_unlock_inode;
-	}
 
-	error = swap_cgroup_swapon(si->type, maxpages);
+	/* Set up the swap cluster info */
+	error = setup_swap_clusters_info(si, swap_header, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = setup_swap_map(si, swap_header, swap_map, maxpages);
+	error = swap_cgroup_swapon(si->type, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
@@ -3481,13 +3490,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		inced_nr_rotate_swap = true;
 	}
 
-	cluster_info = setup_clusters(si, swap_header, maxpages);
-	if (IS_ERR(cluster_info)) {
-		error = PTR_ERR(cluster_info);
-		cluster_info = NULL;
-		goto bad_swap_unlock_inode;
-	}
-
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
@@ -3540,7 +3542,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
 	si->swap_file = swap_file;
-	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
+
+	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
+	enable_swap_info(si, prio, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3566,13 +3570,18 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
 	swap_cgroup_swapoff(si->type);
+	vfree(si->swap_map);
+	si->swap_map = NULL;
+	free_swap_cluster_info(si->cluster_info, si->max);
+	si->cluster_info = NULL;
+	/*
+	 * Clear the SWP_USED flag after all resources are freed so
+	 * alloc_swap_info can reuse this si safely.
+	 */
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	vfree(swap_map);
 	kvfree(zeromap);
-	if (cluster_info)
-		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)

-- 
2.52.0


