Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504B8C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 17:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30148E0002; Mon,  4 Aug 2025 13:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9BF8E0001; Mon,  4 Aug 2025 13:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8FA8E0002; Mon,  4 Aug 2025 13:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B249E8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:24:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65B9E5B7A7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:24:55 +0000 (UTC)
X-FDA: 83739750150.14.7CA450C
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 709484000A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 17:24:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nlZBO4Cu;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754328293;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVDJaCuMrELPMFvvynT19e8hRXhozD/bO9trI2Q8I4s=;
	b=vKCWi2WsePpWJOzmO8JTHrg5SX/dwg0XZBgrlrBUpuwzVTX+760SWPARKYOquVUtUbgQwF
	leV6TYMEIIYDI1j1GOBcDRCa36uG/g80AMzO4rkz1el4ElycMXAJg9g/63UMOnJ2MJ/kCr
	iNr5PYX3dEu7l0bkU4KuzVkelxeWozw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754328293; a=rsa-sha256;
	cv=none;
	b=r6j3p8KsB4hxX1MXjtUwzOezqzlxqDSvPNUD0iX9CKVXyDQ4JOxIxYUcM0bR4/mNABdWTi
	J6LMg0aTVMlhOjXNZdacMuk2Hu2RBTEG+kpYTfqvjWuEHYqweAZEPDZd/ykJfiYxxIkQx6
	D+pp3jkCxeseESO4OlKHOEhigjrTg/M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nlZBO4Cu;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76c18568e5eso366920b3a.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 10:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754328292; x=1754933092; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vVDJaCuMrELPMFvvynT19e8hRXhozD/bO9trI2Q8I4s=;
        b=nlZBO4Cu8pQBL0sk2Zkn7l51Ksf+7pbXBEyqEgT2IkKGxRYhOSAFUoZ3htD8S4KWBl
         tf1lDJPAz+l4wO9fy9eidZWDkI9nTrbLLUFe4AxXAnS/P7CTafq2q1uw7iKyNgeA0IUh
         ztdJGp9Mj75L+D5fLm38WC2/gk/r51tW4k96ZJN/7A7V+Cwy6he3jOc2YQ3eTitiVAx+
         rsyalhDNZgHvcXH+KGPntefLE2TnOWt/wNY7P5yqZgSZcDjLip2R6SBaL4l+pGShmUGb
         iu+n92kTU0fxnexsUfhdY+qEqrPddDbmN9RPTsO0qNBm+IYAEMfaEkfQ15G10JF2dNGW
         sfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754328292; x=1754933092;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVDJaCuMrELPMFvvynT19e8hRXhozD/bO9trI2Q8I4s=;
        b=bnkUZpuGxttA8ecABWUcAyI8u8zegi+Iek4nsUCM2ifGF0P8svqflQN+cHsqvYOHyp
         LKAEkKJCdzs/lieSocKUPBQjXCgRumFHbSjLqvIvVo0WMul7Oxf9MwupBm2ViobbcZ7a
         3Diljy52TCO6t+8/wZ6nETHr2WptP89Js4Jq9BWKFOLYf4z7uf1WVH3tFa+tSKAhF6ox
         fA4URP75ALN39Vt/qILs3PpdrcTFEWN0UNUpREcqUFK5XQRZmrGFND4RvqoVK1kzz6c0
         i4pIJODQ5L2ljTky4WPeUJWi1pcIEYpp2hDua0b3VjXT3FEmXWC62vtEQiOBDgsvpguD
         CwgA==
X-Gm-Message-State: AOJu0YxMU1SYjduIbvPREeQBm/EDIpCsgw0Jvpk3dlPZtsH0/AmqrHfR
	HiJSO3WRBtKV1aUgYC7R10xairYF+hRIMBdRU+Y+ve3Ob6U/CHp6oUWTd+BU3BZj9UE=
X-Gm-Gg: ASbGnctcOKHQhvkMZn0bGyoVzI+TJJw+SyKrjEvOo0QrJPrB7xw4SeW/Ps1Hi4PKyke
	gyGXN/wsFSbxhUMTIGC3BB8O+CD3EWxD+JQtZBTOTsouQt3mnoJJCXPPPOaILTdCxA57OTLiLlS
	xfXAzoKMjLGIugoUpepHnw/UxCFYvH/nlEbU0PK9+rozdgURV2KKkSDWdwYm9php1GVkLRD4Feo
	7TOIlRjniM7OvxT5Jxp6SN4ng66HgK3L2Vst0jn7V5fWBM4kK2Lva/76dSQf0ixMmBdFZ8ze80E
	ftLmZeR+JHvLZu7Fy4XaYIP8R/HJIYxkLRQagHd921FNkRLwIXf25/xjt3mfg+02W/1wubzpKIq
	gWm9QIhln2ShEqp3hRgFv+d1FwOM=
X-Google-Smtp-Source: AGHT+IGniJ0lx0Qlax8eOfu84RbBgv9hJ3X1mPcI10TaxeI90rF9axLNnX5byim17EjKyI1ryfWq7Q==
X-Received: by 2002:a05:6a00:3a10:b0:76b:e144:1d91 with SMTP id d2e1a72fcca58-76bec4be949mr12302420b3a.16.1754328291655;
        Mon, 04 Aug 2025 10:24:51 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bfcb26905sm4194530b3a.123.2025.08.04.10.24.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Aug 2025 10:24:51 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 1/2] mm, swap: don't scan every fragment cluster
Date: Tue,  5 Aug 2025 01:24:38 +0800
Message-ID: <20250804172439.2331-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250804172439.2331-1-ryncsn@gmail.com>
References: <20250804172439.2331-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 709484000A
X-Stat-Signature: 4mogruipqr5gs8tssuec15q5q94jsymh
X-Rspam-User: 
X-HE-Tag: 1754328293-626057
X-HE-Meta: U2FsdGVkX1/FmV7nkd6MQALLCNQuTG5Y8eTPLFZ5ziRQgvtfrbXP5b86vJWXKvxXEyGDZK2DZ7rb0PuEddYptBavZrIkAwJ+5KRuTuZBdEL1ku2jrnRaKBDXhQaL0S81zAhkIufmF0GDt4a80e/oxOVxYo+nJeIxeK3LheCbW8KZ/GXq8l2X0kzOScRaisCgzmPMReeAGNQXZhTBZfumDKftObslYjcVVrMIuv5LO2vgsajN4NyUMFR0qg1N6wlVOqhCubi6Kl5Rp9NUZTie0VrAm8534s+iLwDH6zcMYwMZXq+PwtVi8weEgBKqOnTlTcUVvoaovSxdzFHS+vgL2AeWvBW3U2hP0v5/P95lT1e5K6ezl5fJ+lg9gPYqny2LwTKL3FH5/52DzOBU0H4q5z4ljJEyozsUv0XVxMBTGTabw8dJVsrcEyFUcXtvovxCxpyF9wTESPscnljMFJn+qZKCmP12RZkp8bHn4Pds3JZ6tbcKs4Fs1bA8Qt2cYpBadYRGRbbUpQoHqsqFq/BnEOzakUOE2If7MVIZNAgt/pZtp8PPJspaq5n4PxSHBC/WbSIPPYD2M5kKyFOhUE3V76G3RXruqEg4bJzgpsJQnSg1rYu2Ar3khjt/RWaJAKDnV8tS3a39cB/4YTLSorUC6H3JC+1Y60Fc6kHAkOA0p6t47We+KcpfEvVRy5gVj/vDAPGKjW9eH2yrwVucQzcNsglGWmVEAGFpYmgEQvE7NIXUE5uOOX6Pt6ppEDdelD5LRxAbBM8InKOfXblvFL0+0+nRMjxiFun/StcB0DwILEU7By5DnBY+6joh/lr9lzMIpi/L2zSIkmdk6b+FpNiIaSWxK1Pnw28iQP9r2vqJQHi7vN0wjxMNMg6pzsS36dHqqxfeevmXwAkrC4WRzeOrn5Krg32sg2Th0fXrY9oc+YjXl8Dy10SOjEwBRBrW2Z3j3S0u56cOhGjyhTZ90Zn
 Z31GMNct
 mHeFZ9XNyM0HQXzl+cKH8bb4flxSKWdFfD2luzaskw3AIrdxirZEl5eGDbsBeeGWu5il/tqayctCHIFUNkN814NB2UQjlwZtiguBm8Hsw9ANJYNxonaeprBSdfkNaF7imzatla82Seoz5iNH1nMJi4iGQon9W8DB/s512V5FcBThD3GnrdTwK//LGLbpz7hDY400DQNyIn8M5/8rmzlOhegJPCiu2hWCfcUCvxXRBZXiefRtF6OejS62I0r07dq4K0OQcjGF2pHyR6q8npAuSiy20JJfjP9gWL38fr4PNTiQ/w2IyFvdBa0Y0jyHtnUJ3u9x0VEesuBanjiDvBL35I7ieKynGK5Fgvfdh92GnTplV3H9bDe4Npm4ilLIwP9Si/UnDcs0uzi3PNol9PvY5bvoG4W46zbsYytLvvmWTbxNquCoPCC2QAILWclf7dFvGSFwWHSgDBttXRCWFnYVLYV3MhBUnphWdkRgT2el7G7WDsafU6y6xQ2JKtaeNxfcbPWGKJcA45wBpZiPCX4R8YwmOGXIeG8y9L9vp/Qi9FlS+6cQXAmKvg1Nqhd0uLl45sZcraUlkS/60LfrEY+Vgq3zPuDCEt2eSAqfF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Fragment clusters were mostly failing high order allocation already.
The reason we scan it now is that a swap slot may get freed without
releasing the swap cache, so a swap map entry will end up in HAS_CACHE
only status, and the cluster won't be moved back to non-full or free
cluster list.

Usually this only happens for !SWP_SYNCHRONOUS_IO devices when the swap
device usage is low (!vm_swap_full()) since swap will try to lazy free
the swap cache.

It's unlikely to cause any real issue. Fragmentation is only an issue
when the device is getting full, and by  that time, swap will already
be releasing the swap cache aggressively. And swap cache reclaim happens
when the allocator scans a cluster too. Scanning one fragment cluster
should be good enough to reclaim these pinned slots.

And besides, only high order allocation requires iterating over a
cluster list, order 0 allocation will succeed on the first attempt.
And high order allocation failure isn't a serious problem.

So the iteration of fragment clusters is trivial, but it will slow down
mTHP allocation by a lot when the fragment cluster list is long.
So it's better to drop this fragment cluster iteration design. Only
scanning one fragment cluster is good enough in case any cluster is
stuck in the fragment list; this ensures order 0 allocation never
falls, and large allocations still have an acceptable success rate.

Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio
only:

Before: sys time: 4407.28s
After:  sys time: 4425.22s

Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:

Before: sys time: 10230.22s  64kB/swpout: 1793044  64kB/swpout_fallback: 17653
After:  sys time: 5527.90s   64kB/swpout: 1789358  64kB/swpout_fallback: 17813

Change to 8G ZRAM:

Before: sys time: 21929.17s  64kB/swpout: 1634681  64kB/swpout_fallback: 173056
After:  sys time: 6121.01s   64kB/swpout: 1638155  64kB/swpout_fallback: 189562

Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:

Before: sys time: 7368.41s  64kB/swpout:1787599  swpout_fallback: 0
After:  sys time: 7338.27s  64kB/swpout:1783106  swpout_fallback: 0

Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:

Before: sys time: 28139.60s 64kB/swpout:1645421  swpout_fallback: 148408
After:  sys time: 8941.90s  64kB/swpout:1592973  swpout_fallback: 265010

The performance is a lot better and large order allocation failure rate
is only very slightly higher or unchanged.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 30 ++++++++----------------------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2fe6ed2cc3fd..a060d102e0d1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -310,7 +310,6 @@ struct swap_info_struct {
 					/* list of cluster that contains at least one free slot */
 	struct list_head frag_clusters[SWAP_NR_ORDERS];
 					/* list of cluster that are fragmented or contented */
-	atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4f3cc712580..5fdb3cb2b8b7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -470,11 +470,6 @@ static void move_cluster(struct swap_info_struct *si,
 	else
 		list_move_tail(&ci->list, list);
 	spin_unlock(&si->lock);
-
-	if (ci->flags == CLUSTER_FLAG_FRAG)
-		atomic_long_dec(&si->frag_cluster_nr[ci->order]);
-	else if (new_flags == CLUSTER_FLAG_FRAG)
-		atomic_long_inc(&si->frag_cluster_nr[ci->order]);
 	ci->flags = new_flags;
 }
 
@@ -926,32 +921,25 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
-		unsigned int frags = 0, frags_existing;
-
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							order, usage);
 			if (found)
 				goto done;
-			/* Clusters failed to allocate are moved to frag_clusters */
-			frags++;
 		}
 
-		frags_existing = atomic_long_read(&si->frag_cluster_nr[order]);
-		while (frags < frags_existing &&
-		       (ci = isolate_lock_cluster(si, &si->frag_clusters[order]))) {
-			atomic_long_dec(&si->frag_cluster_nr[order]);
-			/*
-			 * Rotate the frag list to iterate, they were all
-			 * failing high order allocation or moved here due to
-			 * per-CPU usage, but they could contain newly released
-			 * reclaimable (eg. lazy-freed swap cache) slots.
-			 */
+		/*
+		 * Scan only one fragment cluster is good enough. Order 0
+		 * allocation will surely success, and large allocation
+		 * failure is not critical. Scanning one cluster still
+		 * keeps the list rotated and reclaimed (for HAS_CACHE).
+		 */
+		ci = isolate_lock_cluster(si, &si->frag_clusters[order]);
+		if (ci) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							order, usage);
 			if (found)
 				goto done;
-			frags++;
 		}
 	}
 
@@ -972,7 +960,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
 		while ((ci = isolate_lock_cluster(si, &si->frag_clusters[o]))) {
-			atomic_long_dec(&si->frag_cluster_nr[o]);
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
 							0, usage);
 			if (found)
@@ -3224,7 +3211,6 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 	for (i = 0; i < SWAP_NR_ORDERS; i++) {
 		INIT_LIST_HEAD(&si->nonfull_clusters[i]);
 		INIT_LIST_HEAD(&si->frag_clusters[i]);
-		atomic_long_set(&si->frag_cluster_nr[i], 0);
 	}
 
 	/*
-- 
2.50.1


