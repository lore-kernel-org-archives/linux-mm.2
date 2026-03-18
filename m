Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073251088E48
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD386B036A; Wed, 18 Mar 2026 18:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC5F6B036C; Wed, 18 Mar 2026 18:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F6A6B036D; Wed, 18 Mar 2026 18:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89B526B036A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55FB11A01DE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:26 +0000 (UTC)
X-FDA: 84560628852.12.EA30E95
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 727D2C0008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NdULiI9a;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LyvvsB8h9QhouSf22weZV/t1lxO86Z5/SzpfGB0vfc=;
	b=1Hcm59ySGemkyV75Jgg8IBcLac9GRp5p0M0+njrlsIhC89k4cFKR8t9tX3JmTQzNqXLQPG
	u3jharyRAxZ4jW4Et83lVn1BTw4eE7QAVGC2xm8zzn0Y8x7HCPHGvkBqwk/mOjr3/nNlIT
	DBiSpSkeRyRPCDtBytKJGPAQbWS+jQk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NdULiI9a;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873024; a=rsa-sha256;
	cv=none;
	b=Z9lfdJCRcIVF0m5iVsR2AHxWseLY4GpJj0rG5c+V25u32hcLerSfBywhq5QpzKyyEyZc0w
	USUTNICdIIoM35JvUqTXx2s+Rv8eMtRbTuF51NAJ5WvVJjTLtwDstAjMGZ991LTmR4bdIu
	jgamz8rRn8BwK96oWm5QRGq7kbV1P+s=
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4152698e745so208475fac.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873023; x=1774477823; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LyvvsB8h9QhouSf22weZV/t1lxO86Z5/SzpfGB0vfc=;
        b=NdULiI9a1pdX6Pdu1Cspf/ECVhpUlGGF0s945/XLULHV/8K4lHFO/nDXVMtSXD5Oo8
         +4q3ugW65kwhYn/gSUMRrgft4kfpm0+et1YraG7quEwEgikh5kwPm6phnS4x9OASWLfO
         mIrBrxQCN65MPXkGuM/bPlf9CE9V6hi0deKnGVJDPkSuOaO2JA+poy6BtKEYtc9gwArS
         PgP1FdLJdRJ9xNf6VKuRC4xS+Uox6knzPVbmrbF0qZd9ZYNZC+tiMMeagW6R04XmuR/q
         crFXx+zBHG/SNkU4BXgHiuQSbTbvuZcfQbR8TFlBZc9L/MRFBtErgAX3QWVRYhRkagVr
         ctIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873023; x=1774477823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7LyvvsB8h9QhouSf22weZV/t1lxO86Z5/SzpfGB0vfc=;
        b=bM1t2k4lY2VMY2rxkzywIkBcVtU1D6L5Fli058mPnZzBGRiK9cwQy4DX0jF7LrbFBr
         ulZataq2zR6/po572xXto19rBnFAOgAsu3vPhyCGMPUFFnlMbD8/JrJq1FNCyyKQhT5B
         ntmjE1+Fec/3IwIOEoPITDYi1aEHCogc76DgSnOmwqKW+RaRWvcgMB+yEXKifC7RHG8+
         1d1eLs057ksF++D3YNUZJ52WsMcCDCjWBViTg7nGOAi3FN7GF73WLXQ9zBUJgM7C849i
         Gv+r1vUOYmo2FtcAS1pdPWgbDrxw3nRI9CtPZ+SmS7g/pxo+A8XN8iTo4iINKxspp3xd
         dSMA==
X-Forwarded-Encrypted: i=1; AJvYcCXxteV6aT2Y+zsAlrJnTN3aVNZ1eTj56ErNu8kGx8EFr7ezIU+DXlEKzoFEHgwi1NNW1wrDfqBtGw==@kvack.org
X-Gm-Message-State: AOJu0Yw1I79RWx+lSPXCGMnLvIOBLfV98KBNApFIGMSN3aUkP5M9pceJ
	srjf22xX53mw0Lb8wX8hjUuVKaTQrdXKJsZGDLSy7ZOis3nijh2oDcwJ
X-Gm-Gg: ATEYQzz3ipEbathw25LlOGbXwOxXuwpTQy97UC1ivN/gsHlUVeqWGgP4Pjb/M1sb5fl
	GAxdy/NWWr+nJ1Qq1Kxbgla5ETUd2IoqF6+rV9QjBPjipZylKXJkFuc3s1nM8r3mCXAsnktH8N4
	UykG4CpTvFgwKRo2ZnZtv0wUYaqVtz951rQDA8N8aPChuTLU3ucbPah6FelQCRP0NOrk4l2qdC/
	9gg/s80dcIHklKAKfJj00PbHIxDSEBZ8JwvLrB4hkA3lOOyelkFHdaLZKvsxYUM4aaLt35GPVzl
	YMkp6/+w1h849EvXDe+dz9WbWJrxGCEIpK/tknwh/cuHZA8eWG/viXhWBsWSyvBeQ07dKlZ5A/t
	j8snuUQfUcFVL9RdTzACVw7fR94ihvbbO2XJ08jE4hDb74STsUO5XlKKf7LN17gEv/7a6LypLpt
	rxTBk1q+d5+mof0HGkLLof/HSQ5FeQ+EJFmVVb6nLU/Hwmvw==
X-Received: by 2002:a05:6870:ac09:b0:409:77a9:f951 with SMTP id 586e51a60fabf-41bd3f3e873mr3474315fac.11.1773873023263;
        Wed, 18 Mar 2026 15:30:23 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2d4cb20sm3817722fac.17.2026.03.18.15.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:22 -0700 (PDT)
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
Subject: [PATCH v4 17/21] swapfile: remove zeromap bitmap
Date: Wed, 18 Mar 2026 15:29:48 -0700
Message-ID: <20260318222953.441758-18-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 727D2C0008
X-Rspamd-Server: rspam08
X-Stat-Signature: 45jkq11dw6h1ccucm5io5b3w8sezhtsy
X-HE-Tag: 1773873024-123959
X-HE-Meta: U2FsdGVkX19Hp1yreWDc2MB/dEiWY+mgG0+J5cshHZD+9DI8NAzuEnFeGAiHlnen1RxLaRMQN/caqSTDEl0vmng3kUHlsR3PM6phqmAzp3oAXvqmetY9OQKuKo5TOrDLAUvBfw+QW4cfgqFVNE0K+ddzuzuYo2uiYgzpwQE4po6W8+Z3QlY8BtOTbLu3I177zUGyFNTK2TUNK95VErqDytku7gOKAE/Y/kxbqwRUoFzMPef0jtmQ8k/YQMwYKyOvcNIwLiO7xIvZYe3Kmkv61CXAaYNreT20cR/fr+KPv8MKgM4amv20Gi5sZY+IP1qxWXTV95+VQUrx1krRNtfd0JhmlWP9HncfoEiXr2E93vh+87U2twzIYiAVJNL85icqtm9Abd5Ej1nPcSO6HMh7uJ0RJ8MPgku5Vd6aQiahNfVw4W6iWU3O1F0Lvlr1Q1EcZI3DkQ2coSqZvLCL7yoNO4SpcD41sByvdsgpRb7LBEHh7sE/PghF9JJKh2SVMxWTpvcKT5Pt2sThQPfw6MjQH2kOacJQY91pMzxKoK5kSzJ4dOdD9spQw/L7mEnNXTXPEaNUrVfXt8cReLnaJNxBQt7qg+EoXbn8EbUMin+yWq7UfP27YHg/eKUQ6kybXOHMJq7hlAj8Htlky1+lmL5DoMGiGwFyd/BgkXH2bp7exBnzRvocfw2dETR+Q02/LZp4QlecCIJDTITj3oAs5QVvJZuTYZ0fH0HoudqALi3byBbuML408bNRY45kPGbO8N5PZZgpk+1Ahxa4BW9pn7mwbFufyaTLgiURh8ZOMt3i9C4ScSsXsV94QtnIA1YjHo+CELbr/x09+vzblhVyH/ydnZxlCGCgnw6SILwCH2M2YGSrwb5R04e2IsQgWce/zImXs3SskxRAD45ZC5R8YY0SixcIwDbnVJVJJZPvck3RegLtSDqKpkuzfXhWgs+MOifkByWb5txgyKqqUz3okG6
 sMtfC19P
 GmBQlDx0/vWctiXjogI83OYff10FOZr0uIBMi6fhfwUDTRjKIhEiwFPcHUH9GdcBIKZH7fkdDOwwrq38TkX4NB0ixvutliPZXRAiYiRZgn1e8E6eWMJF85kVUQ5c7AaTMKm1CiJyKh3kR4RWWcboBuq/7n+rqgXjTSxeuz/x9C11zjIQzWWsmcy8faA/khmZNmSzzwj6G2tD8GDOb1hnKyTaTkzJEQeU6+83Xz5Cn8ck9OMDP8Hi1eOfZEAB1GPbJ0wsIfxim7fk7bsSU6zQh4+O6isA0OIAHeeFVNtvY3mwkiVTsLgQuAbW+NvNsZsFVFrezPjrs81UgZJ0HenE5zC2CEJd411jdOY1Ja6mpoZZEM8F5x9gL7bCDfHHBNF9BzXdjUDDusXKQkILBFhqAALD1WWli0ilP5LkVt3cJgFmDAN7LNDUWExNw7eFFRiG4yf1rga5o6HieiiSSB3klLD5KtOY3MoE14zjly/IO4Ru++IKAHm2E495uY0Vp4Xa19BOMukl6JWYOYh7RECs7jKLubP28YAjVUVc/
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


