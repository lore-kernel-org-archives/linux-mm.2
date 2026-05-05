Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEE2FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7699C6B00B9; Tue,  5 May 2026 11:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7186B00BA; Tue,  5 May 2026 11:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398346B00B9; Tue,  5 May 2026 11:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29F196B00B7
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6C231C0DC0
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:37 +0000 (UTC)
X-FDA: 84733775994.17.654825A
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09120180017
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkEti+s6;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIXfyZUJZPSdof5KqpSbjmh+gBcKfo2nAX8OXquADG0=;
	b=rWXRtzP0UrX9ZMXy3A2AaikAGSwyKLP7Z/JZdxPYFyG/akyS+5+VlfmQGJ6Q/h/LnQg1OU
	EKMm+UGJ7swrcQG+Rjq6xvCegRqnjIu0bImR4LNvJnRMrmycM9TIjTqGWEwakvMAItt3dt
	yaEPV6xSEhIAdhZF4UZHrOD5wtXvwCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995576; a=rsa-sha256;
	cv=none;
	b=TvqPJElQ2a91TwibWmJE1btMz71+Ta+T3dMoRy+8afenNqSqdO7TFEun7grkIsyq9rg9m0
	QFk3bKCLunDBE8Vh5WUw4c+02J32zZogf1flYT6Ls8b94OsR+AC1DyFxUmKn2xaz6MK00u
	2WxoEBTD2wSmgx0ulcMdMW9Iy1zRMqI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkEti+s6;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40974bf7781so7071fac.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995575; x=1778600375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIXfyZUJZPSdof5KqpSbjmh+gBcKfo2nAX8OXquADG0=;
        b=kkEti+s6peoK20x0nld8xh98L63Fr+FSEGF5fVtFDrxk7MD51vk04PBc9nJ7qfz+5j
         vgU+J2d+so5ICwQes6avhxQ6z5/J4LSFTe+WjQCK/ZHl6P4joMfqP1cYvRljg0fL4gun
         A4tiBZdrwE3ww6wF+1Vb2TCbs7tqZ6R8BqjQJEml077j1pmemuCXPtcU2gaDeOGxHO75
         lNiPTGjs9upW0C6CMfix9kSoOUPBQOwsJs0PZ9Rq7gQwmpb0ghdtx5kkYJKAlF/HXkex
         BTAZUuGa9isy4viElAiDqZ7Jx13Uv5BswtINZbuHJR3mtHE2pfAm4SzUYPz7lgbPgFok
         wtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995575; x=1778600375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wIXfyZUJZPSdof5KqpSbjmh+gBcKfo2nAX8OXquADG0=;
        b=kNDUexMulKXSia0cpBb4UG2Q+zYUyNn3qKFcEBg9m+1oVxREWTDAS1zZAzyjVmP2Ql
         B3UKXBgSEzyIIoIHWtOIJwOcGocb7IlwIbzg+YA03yzqQj+b1D0Sv+OKjG5ZAPWMTaHO
         3Vq1HpiPwMzoCxcM/KDLwCtCi1RvAAMam5vNa9PAGWZZzDsUl426eyMSFMN3oK5a546s
         OdMm20YWCD8bcZ8VDMuXfr7hnvwjK0WekPGzPtICVi++hGTWKtdB1hiceD/MgoCU59vG
         1e/+ejTmj4ZPp98qLk5MknZD6qYIA/YM0inrYONA3bJzgM/ZoC28auuPm9c6hqp8wist
         pCdA==
X-Forwarded-Encrypted: i=1; AFNElJ/h1WipCCH6J4H9TJkO6DL/gyzUchkrVexsqIAB4sA74StESUytb0A582KAk3Q6XvqsqA1O+sTiuQ==@kvack.org
X-Gm-Message-State: AOJu0YyA9lOt0T/QF8sxw4+DXbki4CMnpXsrvmEDNWo8KMHR+pN3KRTK
	QxXYrMYJ10nhJx77mAvg/7ft14LE+ppTC0x6cFVVBskHbwHkb9klfk6O
X-Gm-Gg: AeBDietNp3UgsFYb17Ba4gLyOMu7slMI2x7TcbvluXM15u4grl8xuSs4J73i3g4RHWg
	xA+v7nIRCy+6v7HoAs7LXJJ1PLumT/kT0AeaovqdxEFpJf40ATbr8R54Wie4Y88PWY5klpVcd49
	b+GpxAaNDPc74/4+tMRSCCm0cQnFZXDeeY/MAbVz3RPKfrBND6lSfVPcBHM7yyXqP+YuIYJgI54
	fw6HFiXBitIQQpChHYUnCm3zdgmFdjlAym1KKSzfrjr3U+R7yvedbxetVxAnNbXZOFN9n/J1uLH
	qtMwgSyeqwzZY860Y+T831EStgz0MT+iXxnWhyO1DCkLF71Th39g6aPtA36GJ8f5DFwORD7Tgxm
	/UnX3iU3pv3yebZ5u6ZICB5+ZaGxYjzqbSUlMMm8EI/DobT9WvudTKJR3CI0wUOFKF2udDr2szv
	dPsDElbN2UQvQm+OIku8Qt/o/vuo2P+MCLi8LV/dn3o6bXVnhfaqpgdeQ=
X-Received: by 2002:a05:6870:c188:b0:42d:8229:ba3d with SMTP id 586e51a60fabf-434d0d61313mr2042459fac.11.1777995574917;
        Tue, 05 May 2026 08:39:34 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:8::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-434549540b2sm14234808fac.6.2026.05.05.08.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:34 -0700 (PDT)
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
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 17/22] swapfile: remove zeromap bitmap
Date: Tue,  5 May 2026 08:38:46 -0700
Message-ID: <20260505153854.1612033-18-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 09120180017
X-Stat-Signature: pd1der3zcfbypqkzf1fykwxctypkfo41
X-Rspam-User: 
X-HE-Tag: 1777995575-130369
X-HE-Meta: U2FsdGVkX1+IcxDDicv+71hkxkANwTzHVgQspV5Wqih94OlvdeqGbFcfYIsbxlMx+8L/5Ic+mUleobD8/iejRQkaSebH0aNDba0eqiqfzZkR0/rqy2sTixQ0v9eqpdUVRCLnphuitCvSujVU4HPhhDGN6qRrutcSDEN+jiFZ1FWwhUyK2Lz9Qqk2fqho7EFk+erQOgHCKvh3b8+/FBzclnO7q6EgtNSqqC2Xk2M51CTvf3dWdYDzdLOIWuwR5ZMD3WDiBbl9Zmum2HRrJwyJ7mHWsVsDv8LYNtNN9O/Husd5J1w5gjAC0m5MYboVzysnRqcYgl/bj6/ITz3YT8Vry4vOnSnC7bzoRUiRBealtxn5h8sk1XnhSWMXubhaHM998cjq96GMeFU7sJL8ugYs99znU/oKcP2TUlbsro6R/LJ9ucYKrMvTaaX908Y8k86dtiZk1jKx5MtJ59rfL51fwPCUF80LzTa8vAWmYyOMIPlho0VUKv6rRCBHwRMIAaUerLBMeODUJMlHZ9r/CQwq1McZ0rbqdcZpfx8l2Ajq5B/qmYw2a8wZm564bbM8BMT4oIv8aXiHpZ0k935LAmtsBy8wyznPMl3brdo4wPb8XrhXS2zmCBDD82c/Rbl5w11HHLs8v0uRMTU68xyaPTLZ3y16wORhNapdKMiToRXLWl89GLWshvQ74OLq/bkeqX17nxjAb7tN0Xjo/ds0LlfjqHtFvn7BMyQIAFplNYsha5S74CU4TBO4Ew4HU4CDRViaJ3yBkPw7Xj5TnHlCA8X0+GnWswFjunD67vFZeWb2Jnreeg9+IoJE5EOLDWdp5DDifOEu/TAGEEg0B7rzIyO73hbdJ+lYWmqplyRHDKhoW6xxEbchZmv50SxiKzJdI6hL1YBi3sshOqXtobIaxb7fau0r04B/kKXTyyGYr0Es6kUl7FTJIqUDruMopDpRFSCPfvgQnl0JrC4TESQJo7k
 2n6mfaSw
 ZVKXMI8BCJKvTsXWtstog/L3L8DiC3d2cruoPb629cb+3T81pXCAB4W2KYrwYupABtDa8o72cZ5cgqdAm9zCBtiW0qCrbuKhuDJvtmnbCGt6kPayZ1B10AImOXYsNrS5IP/G8X1M8sX+i2SeTiUxeSXK81APJ4OcZg+HzG6Ymt6sfxePq2WsKefjctYmR/aKaU1J33S3Oz9N9HZS0DErwSxea6F7U26OT+UXXGEauqEx4MS79eEZ+kVLt6uadMirDtKbs08DMmFuY+0axT038Z5B3eSsp5cgHVYgPJG6nPNnzslYZ5JdvTe9WQVzh+/V0czKoDc9R3CWm/F98+DucGOiHfXa4O/+Os2b1ThMlc61YHU7s8ziHsbYbI+tOTVpakuyECAi7ZyjPf1RhLGdZDiZ7bF+kroUzl5qeR6c0hLJajfDUdrZP8pnT583yEtJRc01AzaP39ieOhnr79k2JSU4tDWSHBgNcs2CsTt8wSJFmss+QgZ73Att2J8VSgSSZyb5BI1698ubpeNYe5AF28IkerHK27x7JTQuu
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
index 12dd9621b637..4d152fa811f2 100644
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
index c6a91c657877..ce1254733e96 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2276,8 +2276,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
 			    unsigned char *swap_map,
-			    struct swap_cluster_info *cluster_info,
-			    unsigned long *zeromap)
+			    struct swap_cluster_info *cluster_info)
 {
 	si->prio = prio;
 	/*
@@ -2288,7 +2287,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	si->avail_list.prio = -si->prio;
 	si->swap_map = swap_map;
 	si->cluster_info = cluster_info;
-	si->zeromap = zeromap;
 }
 
 static void _enable_swap_info(struct swap_info_struct *si)
@@ -2306,12 +2304,11 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
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
@@ -2329,7 +2326,7 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si->zeromap);
+	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -2400,7 +2397,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
 	unsigned char *swap_map;
-	unsigned long *zeromap;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -2495,8 +2491,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
-	zeromap = p->zeromap;
-	p->zeromap = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -2508,7 +2502,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	vfree(swap_map);
-	kvfree(zeromap);
 	free_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -2972,7 +2965,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	sector_t span;
 	unsigned long maxpages;
 	unsigned char *swap_map = NULL;
-	unsigned long *zeromap = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
@@ -3078,17 +3070,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
 
@@ -3155,7 +3136,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
-	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	enable_swap_info(si, prio, swap_map, cluster_info);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3183,7 +3164,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->flags = 0;
 	spin_unlock(&swap_lock);
 	vfree(swap_map);
-	kvfree(zeromap);
 	if (cluster_info)
 		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
-- 
2.52.0


