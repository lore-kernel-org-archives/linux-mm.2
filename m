Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FB6E63CB1
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0E16B008A; Sun, 25 Jan 2026 12:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81A26B008C; Sun, 25 Jan 2026 12:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E426B0092; Sun, 25 Jan 2026 12:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA19D6B008A
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41FE514027F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:17 +0000 (UTC)
X-FDA: 84371245434.20.D71F42E
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5834320002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NZFWmsi8;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oxuyrcl+senacpl825Pc/8hD6orLDCzNPV1cvMYSnM=;
	b=6XDCqA1mz7AmvesjseVH7d44FM52KWinmLdFRY/NnYrxryWwATdD9AHta6U5jgR4LL/NRY
	whj2aG8AtDPJAZUxzXHndmVCIvmoRXZDKhJTIVT6VpTMLPWYf7P7TNHFzCeNiy5kVv4FGf
	R0CvxVTOlunLKtmJBoQN/BPohdV0dFs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NZFWmsi8;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363895; a=rsa-sha256;
	cv=none;
	b=HIjgv7kgXs6D9d2TvCayMiHS4/vfy5mWTHHyX4K7JCzcXJ3az6gVuU8TIFIfSr44fPC3+l
	gCh1Yj5efTaZ7bLjO8ayCIqtxvnlAYsJ0k3a39e/xhjX73Eu63+J5XAo0hQAjFF2NkCMCg
	NGTZsHxckmTT0tbggzNlZptebuyXy5U=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34c1d98ba11so3298744a91.3
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363894; x=1769968694; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/oxuyrcl+senacpl825Pc/8hD6orLDCzNPV1cvMYSnM=;
        b=NZFWmsi8tsEuQhN0Pi12BuyBW9vXiFxMEcMR3wY2Q+eR6mpzzwwaynG1J0J6Yqjjst
         ER7mN0YWDuYHCXs//Y2x1pxvoHNt4rzrAVR1yQqsQl+hm5+e+w9Y59Dql8EhmHjLWm8t
         Vt1+E/NCQfgi4Bfi4G1pvs/VHFbVc9QDG+if5pvz1WAQ6rVN72Jj8CM1sgxKisBHbaax
         micP86UbQrBTkUnBwoR6enC6clcZdebuIE22On3LfgJE1PFKl3vJcHjKd7vh8XGmzUiu
         w8RGZT7utlvYU4VmF3ti3naoDixjeepceu3lK30oJzhDF+QWisR2HAf+RXemyh99EfLl
         QWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363894; x=1769968694;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/oxuyrcl+senacpl825Pc/8hD6orLDCzNPV1cvMYSnM=;
        b=gS1PVdU1G5fN9RxZRn/5VQQe37KTSa7a6If7wK1qXmjUFEqL91y75Ul3vkA/jmZAey
         7qD/hDf8Kfm6QV9zXOZAM3yYykALBu5ZgdiYOJhN5qYaXY9w9RNmkQls1yZkWODZH6OP
         olV89nCFqoXsXDtrJKnGqo7+NCH8FjgiVsj/zPr4EwX6t5J6Ss+D0jEGJz362R5bEz5Z
         1eE/Cg2mktWJs4W3ZrICSyNV3XFnm0vOFJfgdqTRow7s4dNtFHAv5YPlD9MWy+mpjAM2
         pvgGzMMhTThcTkgT41jIVlJ7lqLJDN0p8hMTgdXGK9MRp4J6IikN3dMvOpa+9BBUazo6
         xW2A==
X-Gm-Message-State: AOJu0Yztm/McgNDV098CE9XVZLcgN1Wlr9r1BdBiJJfAlkg1uOSsmdDp
	AZ+TdszYTjkGkJrwTYVJx0NlHT5pLrUD2LkCn/nTfDL7xDzdGWFG5tsC
X-Gm-Gg: AZuq6aITkQsyNUmi18DERqXBPWgO8MtuKpi5ZI1NHJi2N1ZpLLunXIw7WAHqXV+7qjp
	WrMDL7HAYZ2sgWm2snSxjXhDJsu341CatGa9JihXuF61JAttXYySK6QJY5ReT1sbt5/ZKt3EzpS
	+oRpn15jHZBe0Ea7ZIICh9uCO+m4efJzznj0xJYmyM8RVA5Br8B4G3sbM0K4s2ScZjv5bo/PWHJ
	u2IZ2WZXDEtkvoNOht+Dz1ABZ39yvIALcDvNxBf/fc8al7lJ/nA+n00nTT2BD/i7gH3pCqLVZYi
	GHfPspvA9OHL0FpKq8P8HOhmuk6JYENuDNYqYYyk2W6XTUq5+/J13KIghvRiU/dIJlJoiM4zxoz
	GLMrUQSrs+reDr9nqyTzz4sxZNNNz98r1Uxb0ptZdZVADtEu7mJeqG2kcmVqPqag3RBzAkl+z55
	KOtXjC+4lXazCPJTrnqJHnJjx8ajA6sBSItEPPy3drsCm9EETakEA3hA/bkuQ=
X-Received: by 2002:a17:90b:2fc8:b0:352:ccae:fe65 with SMTP id 98e67ed59e1d1-353c40b3244mr1764884a91.4.1769363894105;
        Sun, 25 Jan 2026 09:58:14 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:13 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:26 +0800
Subject: [PATCH 03/12] mm, swap: remove redundant arguments and locking for
 enabling a device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-3-a74155fab9b0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=4474;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VcHfIq9fX/OfsYjH1rKwFGMkjPLRnW2PTE0+Zr1fpH8=;
 b=BCLvnz8yeXU8dUoomn0Bh/gnIRxlBMSPd7NlZBxGfV/XLaOAi1CaL+XqpeFh8CyCoD+yyMUm2
 e04jECMZ8s1DzLOPcw3DRmjDGdjqiRXh9V//ESPOpcaJUiIFnIOlqjY
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: 8xriqur6zfjb7wygib4d614q8akrs7gh
X-Rspamd-Queue-Id: 5834320002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769363895-77254
X-HE-Meta: U2FsdGVkX1/Lp+tVVcD5zyOyB7S4h90RkrAI4xBQ5b93mok+GDhPo3ELOiO2iftm9xeiKq5F72quDCGNF6bRy7YtimuE6iYGM49hntUqBirQQCHMDLkhtDurDRMuo0F4obS3CmOACIX29X4rWJCS8Pf94h3ZGL0JrC+KeHIVBy+1/9YoNRqatvNEcSXzLc+AFB2t4imbJvfTrZBCF4uwgIcKyHzV5tBHeygzAhjP9ilGHfwX/EU+T9nvegIpm+yAigNRcmFzRMHs9DGTbj12QywEfp8awwpDnqOukNkfu96uo+iGNek17Elbfrh2rhg7xbSqjFmqFznIS1hwWepXSE/WlHFr1emfk6lRcGYbhaC4lMbzqlmTx9iZJjVsUkyVOfJKAXKUvn+E24jotReeC3CMmIkcSlID5hPLhUsvEgRBmzancS9CgKcdXzlkfo5p5WKU2ApdGa24GWBoBDv6bXu46A++Fx6F0w8mx4WKC6neDFQQgMqu2epjTXyVGEK2pQW3RpthXaZo4CctsFn/vt7VvR0BlQGMhDEwrUgHnuy+kJJX7LjQ39cu1jJL+vMFPZjTr73Qj0YyMheEnYdeOOG1T6lMHqU3bRE4BNqJiXR6wFwGB56E9BRSvnHExZEKJ3RVLqkvL+Faqo7OsKIwlC9VRNQUosXtkjAecAsKBFtwxlgvRfN/AS/QLO+UEVWcujwNWAZhk9ROlYS3w1Pmx3k5f2LaEMtnw4GB9JKO3wRd/zIpMItZ5EHLwnlTurtHraD4zqNMo1ugdOq1SSwem2H2bWL/AM2nsNb6g8LoYE3t4MQumGbboInFQu42tF7ku42N089QpMEmvNxE3X6PePv6Iojn3tq3TCi4Dhh8IgAj2+TrGuWCU19OwpX434duHSdhxaDr+sipaI3SGjPdv55Eg+oiT60ZGyW9HbZd5i7UKK68vtsMx13sFKjc3sIGS0BvqO/vqDkVmc+cT0q
 Pq40UVkW
 pcZU8gz6M3J7+DqY4uDDyU2SPwDe0bNyGVO1TJ8x/j5ghqQiWzzQKTyasP0jgrGwP+QiCU4OdoLvfs9gPH/cxm2h64eV+d7z1R3yGpkm5dj6kAT4g0kdnDbvuoMC+bTG8qOfjgEj1vtmvbeS/H7pro6wp/80Jczhd1qsSZfooYenT0ndnW2kAS+Csj+XCb5eAcOji8lyqauPsNeSA/QnopI6T9/fAQkkwIXuIE2knLfAoOyPAe8LeUKu+WCGFMau2U6RXr5SO9/oWmVIm1DUfV5t8UJr7UW9MLagtsl8CT+CbA/F2/9ahlNgDmJCWVmqwn1jhMcwFKbtRvB7J4XnM3QwHXcVhDakpNeXIkAfdhi5iJu6cDzznwDIlPYUJudRQt5JPIr+FbHLA8LrGt04wrbM+MePqpdEr6L3M3Wgrz5dlcQyBvM3a9sztdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There is no need to repeatedly pass zero map and priority values.
zeromap is similar to cluster info and swap_map, which are only used
once the swap device is exposed. And the prio values are currently
read only once set, and only used for the list insertion upon expose
or swap info display.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 48 ++++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53ce222c3aba..80bf0ea098f6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2652,19 +2652,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned long *zeromap)
-{
-	si->prio = prio;
-	/*
-	 * the plist prio is negated because plist ordering is
-	 * low-to-high, while swap ordering is high-to-low
-	 */
-	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
-	si->zeromap = zeromap;
-}
-
 static void _enable_swap_info(struct swap_info_struct *si)
 {
 	atomic_long_add(si->pages, &nr_swap_pages);
@@ -2678,17 +2665,12 @@ static void _enable_swap_info(struct swap_info_struct *si)
 	add_to_avail_list(si, true);
 }
 
-static void enable_swap_info(struct swap_info_struct *si, int prio,
-			     unsigned long *zeromap)
+/*
+ * Called after the swap device is ready, resurrect its percpu ref, it's now
+ * safe to reference it. Add it to the list to expose it to the allocator.
+ */
+static void enable_swap_info(struct swap_info_struct *si)
 {
-	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	setup_swap_info(si, prio, zeromap);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-	/*
-	 * Finished initializing swap device, now it's safe to reference it.
-	 */
 	percpu_ref_resurrect(&si->users);
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
@@ -2701,7 +2683,6 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -3354,7 +3335,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned long *zeromap = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3470,9 +3450,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
-				    GFP_KERNEL | __GFP_ZERO);
-	if (!zeromap) {
+	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+				     GFP_KERNEL | __GFP_ZERO);
+	if (!si->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
@@ -3541,10 +3521,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
+	/*
+	 * The plist prio is negated because plist ordering is
+	 * low-to-high, while swap ordering is high-to-low
+	 */
+	si->prio = prio;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si, prio, zeromap);
+	enable_swap_info(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3574,6 +3561,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_map = NULL;
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
+	kvfree(si->zeromap);
+	si->zeromap = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.
@@ -3581,7 +3570,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	kvfree(zeromap);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)

-- 
2.52.0


