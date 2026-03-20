Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228941099B39
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F056B0169; Fri, 20 Mar 2026 15:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF3E6B016C; Fri, 20 Mar 2026 15:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE9F6B016D; Fri, 20 Mar 2026 15:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1826B0169
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:28:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE9AEB7C79
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:05 +0000 (UTC)
X-FDA: 84567426930.29.7ED8B36
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2113A14000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:28:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmG4RCL1;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LyvvsB8h9QhouSf22weZV/t1lxO86Z5/SzpfGB0vfc=;
	b=zIuAIy/WqJFQWQbQnz2UpGX6U0tVvZFwzd7IhWFUHspi2KdEh61zDK/mxW4e2sWB7/dMch
	iYHdrak4xWIKVDdIzlD3K9E+RYYkpzgQwmMDsmxD10fJgknE0uS5BcovNZRx7TIQhX54N/
	SfbK4rlWuO72kNqvvTFvedM7FDYjlgY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmG4RCL1;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034884; a=rsa-sha256;
	cv=none;
	b=S5kBEpLoJI/TFetckURsnBWpCeU8RfUqg4ONWtD7hGNTr3yfMKkbqg80XJotFiOOQprt01
	3ylT4NOLD8jHKac8psRrnVvK1tLYEa9FWaVhrtWzJZjBQhSrrfz5IjdaT622d7OaUAHYSO
	OGDpy58WVXneAMZq+0mlZ8eKeUszEJg=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-67c2045c0f7so978117eaf.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034883; x=1774639683; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LyvvsB8h9QhouSf22weZV/t1lxO86Z5/SzpfGB0vfc=;
        b=AmG4RCL1AR7Qu5ZDPiZ2vkHk4it3SPogkTZWLTt1lrFhKRYld0L/L1SOXK8rosInhD
         pIRuiGjMmZJffrjHzLReyR5GCPiYT/wW1/VW/wAMZN8A/r43BB1o70oqA1ICu4QFsdYh
         qjNy2XJzpr0UCTup4rL9fd7uAluqArP9mER5oXFwYvsQ0ireAIwNdetQzvvCz0Iqr0Qa
         lup1weVYaKWVeLhBABJmjbWVZsLq+vSQo7Tl1c4/kIybSIHriViKcyTViwbu+j8GZVf+
         8GqnKJQsUYkndfbLW4e2kAQ8MkX+4r28AhoGUhtZzDCJKxyIXA6B3sKHaOfB3y2rUOrm
         QS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034883; x=1774639683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7LyvvsB8h9QhouSf22weZV/t1lxO86Z5/SzpfGB0vfc=;
        b=mFhgnVcdB2yjPEmX8YaAXkdpdBr/upzxVRFV6SqLKqVJB8BdbRgt8Hob2vmwgnnP5v
         eekoVKvSxDOw9AJJn/8puJLx+5W045A4nS0tvpQY4eITouhnWrx6I/V7z/mfQIKQqXP7
         Jh4knIPvCN9fkww9bpwHKnUZ6uPKFT1o7XgTCHWH09ZMjhzSim9q/YwlEe5a4w+f/RVM
         aFxnqISURYMKSsUDntPj+NiUYQcwE7M/DdcGnpc7FhIcsPCYqHibO5hM7mcrqzHu8eLP
         Cl+v5P5vUVK7Fkz7vlDKuMCmX0o/s9cmuSZFx69ugcuxTmYFzr0vUwmRMEwUt8PiYQrh
         r3Mg==
X-Forwarded-Encrypted: i=1; AJvYcCU1RhDChZGuYU4EbkUKBDhANd3ZTuGr3vJFzVmEQ1RZTdA46br6cR0u91O/Ez1Km7e2EFv6q62w2g==@kvack.org
X-Gm-Message-State: AOJu0YzIVPX0nh+cTwPUCUJh4IM2l3SgT/o/K+kv3sukMpO3Ko6lSW+O
	6apVhtppxbl7fGkjKm8Q9JJduwKWBvZNrELy0rwY+WF7LoAHC5y119GC
X-Gm-Gg: ATEYQzxREbuEeEoLOw//rssxMYLqmQgLO6kU+/xl61x8wdFdNbE5gbFPcdfdmvpNLPU
	K7gNnEIKLdCvdNEG8gxSohJfnjOxV4CMQJZ3GI8zxce40IxBbFYtG+BUklqI9w5zqOUidHfbCW/
	jgsojbG+DYXpiWU3LKj3UgOA8z9405a26qGU4XFPLdF3Whgq9NGqMVyxyqvKrFTJpdDIjt4eeJL
	KPVkOuMOCdbvJEUWEYFQYBhZ/AJF6KSH9AYSBIFCZCCjBxV4VIrTMFzaM0h9TowV1ZYkw7ukqSP
	sZ2Q797ur2RSH3lAv5D3Vw5AJdk+JVyoim7vbtXolum08vJ/WNhCKBwnoLAFxu1DEdQCy4I3ZPA
	bzGS7sGzmWF+1DLrv/yLmNXZ+a3pAMOIeGINuXed13Asyt/z7hk/X/+SCM3G3ZRiW6cbghbVP14
	1dbr9yNTFpnJssmpAvl2YCP1OKm2Ef/YGX28JSz4GoRYKchg==
X-Received: by 2002:a4a:e90b:0:b0:67b:af79:4c1c with SMTP id 006d021491bc7-67c22bbb20bmr3072207eaf.2.1774034882969;
        Fri, 20 Mar 2026 12:28:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c251a58dfsm1621782eaf.0.2026.03.20.12.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:28:02 -0700 (PDT)
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
Subject: [PATCH v5 17/21] swapfile: remove zeromap bitmap
Date: Fri, 20 Mar 2026 12:27:31 -0700
Message-ID: <20260320192735.748051-18-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1pyn5aii4kjijnf17qomdkx1exjjg9yp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2113A14000A
X-HE-Tag: 1774034883-341641
X-HE-Meta: U2FsdGVkX1+g4QrrrbZMLKw8sUHhdjPA8+h39vpNMTkeIEIUMdy5xEgEM6hMP2Gc9ioHHKALEE4m8kdvaDZyH0rB0S7n9KTVFUZz7W+I5+oS1VdIIUcnQEaZF5hie9KYmdTtAcumCDc2jPF+Y5hB8f6GLbsMS79qIqBwfclTyRcmmiq7U5VCHs61+aK855xrR/yZNspwsfviRAswj5EWjfKggQuIHdA/5lGmNXbSFbuQkbnJTQ+Esz9XU34UviWc8XO01x0OICQFrlMg8ihpzg1YEukPAHAVfB+ErOw7BKosxMv1/Q1o0fbjfvhhaW7Vfwcp1l8TRb62YGWafCL3wctcLYcNiXe25+sAh1BhaTmYA22v2HVMUJowN4+oyzcLdPqtu2dz5zMmJ+s7rfKY6giz2ONff7sBxg759wU0AXJ7svHASUbnvzdlFBDwpVsvnxxUNnSwITPxjrecuZkqSe+7043L5xPqqyyHVUzr2MeTmATME+pbgG/a9ubcmZavV03HQaf5kR0DDGIhdPuau5+Q5DrDFV1Jn8Rl96xHcJhfOLUeKQ+4IzSo+NmELl5Rupc6VIpiPn59RiZ1Jup9RYYr0OwkT4kVzfLJybR8df6oUXblA4g5vX439l5JOJs19vEQkDew+ist0OZ1Zd5zSG+msfFCacta4aTSO7beqNp82mH8Lt6/i4D/A66eYr6+QQp5WcAO/rNN6JXNRlhSuUuxxtadxKwXNdb7SMzbEEIqIu0FsBT9S9N4+MhNoyrP/zT8nFqExlrxi+IX3lkjZcpAumTipjLvf6906UA5lBibHSVS4RGywv09fgmmGggoKC/drafhhMJAXA3gc+TH5jjeBTSi+2S9f50AQpbAW3sVlBRNOkE8w2JT85W5GDajdZQTHpHU6SL/c358DefUWckzQb5QUWmu7nzPhc4RGWrfo/8mkkUvM1sbUHJE/14QmGgw3dLRlb/EJE9H+A/
 V7EBevr/
 g7HdIGt1nY+gaLG4UDrBOCxbXDKwsZTaJeT8bWT9CLWW/aMpQ3PqdKiDch1OIS3naY9so3PTMDc9fPXBHiZasfAk1dI0r/uoRBlat2YuXwjtjbMptiBGzmzmZ+8dbZZm0eGBYJfv4yrcbc05+6nz5cYdlREkLRuPro1GKe0jxxntlLn+TvKV9gMC08fXHFQtPKDF16Iq/Mv30FzVmF0QgZ88aGGGUqvB8vm1TQja33VhawxBrpn3KcK3lng3mXBeahwn/+VbBsBcDgK0A4DBBU5kMPF8mw50RhANtOJv2t9CXbKUtPqRmm5nQhJqlO9XBRJO0WPqdbeQQo9diQCua6ve2NKSJ3ExOXGR5Y6AKi32xiJmb6ZifQQ9jkEzf+Znd+nwCLWNwxfHxugvEnxVmGaQ+MYfvOqj0DcvQ8dzAHCmJ4tgJkC+pQq5v66GIwloXPJ00gL+D5S3A2iw4WJMZsHb5jhywSRjZb80YyCoiYqgeycEB0K4HcqveQiLcvkA9Rlk95LNyiqg4BOtC8CT8f9SS6v79GZcj2GBD
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
index fa73696733744..cc1ca4ac2946d 100644
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
index 32aa080d96a4d..aeb3575df8a0b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2320,8 +2320,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
 			    unsigned char *swap_map,
-			    struct swap_cluster_info *cluster_info,
-			    unsigned long *zeromap)
+			    struct swap_cluster_info *cluster_info)
 {
 	si->prio = prio;
 	/*
@@ -2332,7 +2331,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	si->avail_list.prio = -si->prio;
 	si->swap_map = swap_map;
 	si->cluster_info = cluster_info;
-	si->zeromap = zeromap;
 }
 
 static void _enable_swap_info(struct swap_info_struct *si)
@@ -2350,12 +2348,11 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
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
@@ -2373,7 +2370,7 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si->zeromap);
+	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -2444,7 +2441,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
 	unsigned char *swap_map;
-	unsigned long *zeromap;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -2539,8 +2535,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
-	zeromap = p->zeromap;
-	p->zeromap = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -2552,7 +2546,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	vfree(swap_map);
-	kvfree(zeromap);
 	free_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -3016,7 +3009,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	sector_t span;
 	unsigned long maxpages;
 	unsigned char *swap_map = NULL;
-	unsigned long *zeromap = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
@@ -3122,17 +3114,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
 
@@ -3199,7 +3180,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
-	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	enable_swap_info(si, prio, swap_map, cluster_info);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3227,7 +3208,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	kvfree(zeromap);
 	if (cluster_info)
 		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
-- 
2.52.0


