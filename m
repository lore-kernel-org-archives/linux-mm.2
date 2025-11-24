Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D7ECFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E638F6B0099; Mon, 24 Nov 2025 14:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A7D6B009D; Mon, 24 Nov 2025 14:16:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A106B009E; Mon, 24 Nov 2025 14:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC8136B0099
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F2611309BD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:30 +0000 (UTC)
X-FDA: 84146456940.10.F00FEAB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 618701C0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=le2V5+wn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011788; a=rsa-sha256;
	cv=none;
	b=02mPEYtpoheKQBgC4vy02SXFnW7Pr20AznXF/uos294q/Wpq7sn478dqAG/d8+zC4rSEbe
	UHVzzBO3RfpDoe9x1iNL5Q8YOX0TFMw978fjsq/hp0o1n46zCedPKwZrRdiDJ2mPnl/xrq
	oYsLhvFK6N6gHyOiafWy9wnmV25qGWE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=le2V5+wn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOxnIY0a99Y52eqXzKdRmg80jUOJW+tE1KL/X+5vX9M=;
	b=ELG8zwHLNuPMMwO8O926wlw2LD1DMvbOAYc5h686vjGHPfaEAlbcXDroQ1JUfXTFxZ+9My
	FSdBdmCzOOZwFSmk4PtnauOw5yrvKEpcO2zdHhTJLPJ3TxKa4p1ZWy8tUjQGJhGi+4M9Wj
	A0MS5bMqgXfEvoG5g1KUHXpofEYCRu0=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7baf61be569so5540142b3a.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011787; x=1764616587; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOxnIY0a99Y52eqXzKdRmg80jUOJW+tE1KL/X+5vX9M=;
        b=le2V5+wnj8JZRkTlVwj6APTGTnUrJBw97U54ShtWDeg5q9k18dkFs+n5JkLs2y5TUu
         flweo3SjOXhJFUYLDSCeN7EPnUF3Rs1ZhRgP4WWfyfNpPp9OZ9LmuFE0ZEhiye6oDlzI
         eSuxfMbeWzLqa/sZx8DC+nTnG021JNentODAGHDprKa1Ew+BVDhjt3T9SAVLL4eStxUA
         uwpr8FdG/85fV/MhKAXEaIzPAUTRb61pgMnejNXUP/3mdM0YcsWPV9S3FusUrR1jzhll
         poTE+IELGXHABttc/sO2AqNHG8BOA/5d66hDVCDxFsGz4Eu/flP4Cg4dSwunqexYnLzP
         G2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011787; x=1764616587;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eOxnIY0a99Y52eqXzKdRmg80jUOJW+tE1KL/X+5vX9M=;
        b=u9DYk7oH5pe+fkSHPs5FqcSYlhJwi5cBjDa7HFf4QX0vuHJXi3Q8d3GaEUqOAj9BRg
         7qAsxuQ19Z3IFioEnW6+v8AeOvXeKO39/P++Lzv5EKlJXmhU9zd6Uzfq9SyRMRGOKFo0
         sPp/e3nKsGWYMuu5YyDbceO+q3yoU3OsfFdZCYWQIAszJv9x8fc9cMV/djrZvjrzBBjf
         I0rYFOthTaeGUSXEelqyUaH1tL7e0nuEtvRBEaj+2kBPVbcVJVY6UTAEti1s0MV1zbSj
         GigKJnKsplpckgg++sfJtZQCH+yTca1bcGQGOe9C0E2yse+drjAXFKGZrpBItuCXw5uB
         lfjQ==
X-Gm-Message-State: AOJu0YxwC/uCaFvs+WzpiSy2dIW6vcJg4uVMS1oQTam05ShnToWW7BD5
	MoEgT62QoxweWl5TJ0+R3Fi/eT+ZO3u6veMVzMwgtYF7kHjMWqGEZepU
X-Gm-Gg: ASbGncvWXPe8IL2hvxrLz+2LvjHONe1YSN0Rb4R9ucY/S8LSjCjn3sWr8RNPpdDeRGO
	nv6V4Zhxw7i9Ryf1YGSN24KSzRWmvxV/lRgcQK6f/eup/LgFEriPZ7l9z9ESH6Nplq+ZooMXlCc
	R6iUZbxnmZSjDj6apX/uS+xl/509LxGP6EEN0ZDXt8U65uEOTQpFDcN5gvJ1B/u3ctvveIJh8pq
	Hr8+dyJAd7xzvjBTuh04rii3kY7bKch56s12KxhB7yiCUU5IzWowF6NHHZfLnpPesMjVldAytb2
	hWC7w0G8i7tr9hyBG1vtqx95YfUmVOQ9JZ0rU7caRdK80NTSJz4RfPLKJn9u+jSLmofawPGUSTn
	nAhEbHxRfgrVtmLMy/vSuKhw1Zzn2XAFr5mq6VDCdToWdJwC4qcfhzeL9mZBHoRRjOd10Dogdzg
	JXq9kvFnS1vn4SQhGlml5yu30i9IlEGRpQ9wKTCqxAWbxe3ujH
X-Google-Smtp-Source: AGHT+IH2rOQ7eWjFBbbc/91093MxswZ+bcVKJjX3xC+3hLOctGc8E18g829dn1xUDBoO5jNLcrGkVQ==
X-Received: by 2002:a05:6a20:7f8f:b0:35f:aa1b:bc02 with SMTP id adf61e73a8af0-36150ead3e1mr13261971637.26.1764011787031;
        Mon, 24 Nov 2025 11:16:27 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:26 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:53 +0800
Subject: [PATCH v3 10/19] mm, swap: consolidate cluster reclaim and
 usability check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-10-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=4270;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aUyVC2as+Gs9TiZQkBGnriVQMvOjS3mdGW8SaiNYelI=;
 b=6jf8DU9Y71Vc6lenDn92r1r5/qxPu/KMRxJuU4xK4VDA/xkkD2eazk3yHm0sPCCjy3iWn+QOD
 XI5kgQyF/tUDszPynUPDa5uCNxVhoVjJzHIDCiOXwAJ2FLfISQSAbFW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 618701C0007
X-Stat-Signature: tiwhtbwe5i17z663kb8qqt8x83j9ewjz
X-HE-Tag: 1764011788-580557
X-HE-Meta: U2FsdGVkX18ZOx5uehg/Ug342XIU2pEkPfKSjJwV5Kx49xoK6SzmJTjwul2XcjCOO6KAgRh/sGRm1rVywtJicz5IZylE2EZoR0QBBAPnH98P8+lKdSsNLYqEi8vidllRGYR2YcNGPmII7sOBTpWJhC4HLnpWQpYjPx98ufgIQUCZKF5u4NSokfM0ZWplvcJIWVFfjBzMZoGCuGMeD2n5hZslbqv3nQ667MRpxC7Pe3V91KQ54b9543HgjgPHWSgnzsKh81jyOGvKAkhGMcSyZwM/ZvTA7br22/dQonBhFxLossSuVikWd4N60aYqBoviHEJEHyrOyRw6DEzdBpP6eGtmE6HHiW1YjdQ9GP4hsS5SXRpfxKje7efEO08jUQeOIK9cWGplxURtlG5UzpMSyLI3qNcIlL4NhXPJhhrAlGhFNUEG9jc+Fhl1GsBTZEZooeU5kFJYslD5sca0YkL6brLnVqmM4yig30PJy/FeqkR4Zj5vGbNGfXiFIcgh5ZbE3eZP8BMKPV5OMgBH2avdXnJEnI/td1LFuSXHbVxiIuu7/RJyAtrAvh+dlZmpoSoJXI4Uh7MED+QrBv6xchWR79wTu2vQImkJPIQhUF03UefNF15EvhrC2eOGyTYUrCblwnE/D6bFKqVnIiL8FsTR4o5uy6oxJLWB8wZ1o8qWDvoFpJ8QMEf9Pls+CkiiO5FRDzRlZ9CxFa3SFvw6wXqtVTiZ9nExe0WgF9AnWsaWg31yYq0fQkY22hHRV4epAhbzWxWYoApn5H/MWBALGxh3E0s7/4IadNcTVy9tlncvaSZZtfF+MuhtkXLyEX7w5VdVRBGj5R/d82IVDXH/stTBG+MA/Q5xxwGYKtIFLClyl/eyOFHFd/UERkYmJTUGJmhvZgXOfJJc2O+1g3TcmZ9je9fYH4I39AMPsuB0iG4BZwvDFIRs+TF8sD8VjnOydBoW/lPLBjbYTJRR+P53knx
 E79KNsAH
 RrYedXVD1ceNRHGPVTo8M8Vf3aRw43TZ0SB11xLwvBiKVo6IIwihwWlViTBUkCrRC2AaO5cwCfIdfT9jq9YVHsri7NjTcFpxZuUS7IErWAuxy/Jve0wDirI9dsivPuO0AaHM5C0vuXjiViDDBkO2nN7s2QO8JnXIGg3yQy9WeQ+IWGfziaMrj+Df+QnVpVsq+KFyC5/vGuunzgwFGjUR1V/Z82rQsCTwy/zv8PCFcN2Yua9L61yK9VsyfU677KTpt7kBVpoDiWdirxjGgjJzupmn8MP2FSOgRjSRbJrrfRpKn4St5IvTY9Gu/FAmtJZT5ffUv0wxiSXNAS9OPMV/wdfmiWd+xXsByh1THpjGb+kJLXzY3+Ob4QdIUu0/L14fMFKa2B0yJAHIKclVtxNNa6JbzWucyWyFXkCT4bcqZdGr0coSf0fwa5DdVHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster cache reclaim requires releasing the lock, so the cluster
may become unusable after the reclaim. To prepare for checking swap
cache using the swap table directly, consolidate the swap cluster
reclaim and the check logic.

We will want to avoid touching the cluster's data completely with the
swap table, to avoid RCU overhead here. And by moving the cluster usable
check into the reclaim helper, it will also help avoid a redundant scan of
the slots if the cluster is no longer usable, and we will want to avoid
touching the cluster.

Also, adjust it very slightly while at it: always scan the whole region
during reclaim, don't skip slots covered by a reclaimed folio. Because
the reclaim is lockless, it's possible that new cache lands at any time.
And for allocation, we want all caches to be reclaimed to avoid
fragmentation. Besides, if the scan offset is not aligned with the size
of the reclaimed folio, we might skip some existing cache and fail the
reclaim unexpectedly.

There should be no observable behavior change. It might slightly improve
the fragmentation issue or performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index cb59930b6415..bdbdb4a4c452 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
 	return 0;
 }
 
+/*
+ * Reclaim drops the ci lock, so the cluster may become unusable (freed or
+ * stolen by a lower order). @usable will be set to false if that happens.
+ */
 static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long start, unsigned long end)
+				  unsigned long start, unsigned int order,
+				  bool *usable)
 {
+	unsigned int nr_pages = 1 << order;
+	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
-			offset++;
 			break;
 		case SWAP_HAS_CACHE:
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim > 0)
-				offset += nr_reclaim;
-			else
+			if (nr_reclaim < 0)
 				goto out;
 			break;
 		default:
 			goto out;
 		}
-	} while (offset < end);
+	} while (++offset < end);
 out:
 	spin_lock(&ci->lock);
+
+	/*
+	 * We just dropped ci->lock so cluster could be used by another
+	 * order or got freed, check if it's still usable or empty.
+	 */
+	if (!cluster_is_usable(ci, order)) {
+		*usable = false;
+		return false;
+	}
+	*usable = true;
+
+	/* Fast path, no need to scan if the whole cluster is empty */
+	if (cluster_is_empty(ci))
+		return true;
+
 	/*
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
@@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
-	bool need_reclaim, ret;
+	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON(!cluster_is_usable(ci, order));
 
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
@@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
-			/*
-			 * Reclaim drops ci->lock and cluster could be used
-			 * by another order. Not checking flag as off-list
-			 * cluster has no flag set, and change of list
-			 * won't cause fragmentation.
-			 */
-			if (!cluster_is_usable(ci, order))
+			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
+			if (!usable)
 				goto out;
 			if (cluster_is_empty(ci))
 				offset = start;

-- 
2.52.0


