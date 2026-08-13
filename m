Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8C9C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7422A6B048D; Thu, 13 Aug 2026 06:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719986B048E; Thu, 13 Aug 2026 06:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656866B048F; Thu, 13 Aug 2026 06:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4081C6B048D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:49:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC7394063E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:38 +0000 (UTC)
X-FDA: 85095925236.15.7A83B46
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7E8E320003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:49:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618176;
	b=JOUY5g1a4z9CF3qhgOYrNDajVqcKUPjpYW9QPClXvDI3SaOgwNsQ4alzm+ZscdqOxTpFLD
	YCxptc/cVsFfGmz1ki5kbFfQwTWxEhr9GFwdClpnfFxY8XOgThXNQO5d+RH66JDD6da4sT
	yaGRati8J8STBUkD5MKyJCku3tZQWpY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ENIbtlgrQjSxtRUgCimJGhlVmz9vLW3h37g5EuGFMFw=;
	b=ZSuN6FXDzaE2Mo/xWRrXCF86frgjvCSPduUg7JlTBBPbQZDdDhnHFggN5x5PQ6cha3eb6e
	fzA5RZnl2ZXXyENjPcpV+cxcyUwwEaKC7qtXYTdT05Qv2Z+gVaQZbqirhPI1H38UIQillo
	O2nqaI3ioz62CV9PIGpYMBfthB4ekYA=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 3ab4b3341ae282f7;
	Thu, 13 Aug 2026 10:49:35 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 04/15] mm, swap: refactor free_swap_cluster_info to take swap_info_struct
Date: Thu, 13 Aug 2026 18:48:43 +0800
Message-ID: <20260813104857.3450386-5-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E8E320003
X-Stat-Signature: xznwq3cst8wsh7c395fptxq96s38i3xo
X-HE-Tag: 1786618176-250452
X-HE-Meta: U2FsdGVkX1/cNbULxZypbSblnM1cZlaxai84kQ6LgKhThc+x/bcnIG9EmIChDYZvw2LxbaYmfpChrL36HF2tXw4lGl1KhLdsxxE8L9qjNma9uYbH7RQZS3q5Ip12x9layTr1UHk3tZe79nn+RHTy3Ls0yk5HVD7+bJlzdla5Xs8jaP/Z5zuUjW3ovLl2YW/SH2HcVSTg/nbO3n6sTcyZLCLi9o2KhxfCEk0YiEnOwwjBN79p1DbXWeSW/v3Au8EkFRFU56vhtNlynrLPUFAG7XyenpULtQEll6qzqXqCLmJQ0DgxtLJe2+yovlC0mXV38WQR2PJMUJqoeRAmNGY+7M8gebdA4cQUTLw/ETQsz/OcKIVajhbj7cbFnurQFh0zKFC+zRPSoV0RP9rrHdYVZtoDTCLClFxM22QjCqQ1YL4fvAMtfA2mraY4rkcZT3wEOWWwulVuVexGnnXeOMeUjHm1DtN03Umo/InnXk83pLp5mpVACu02T8/uTKyQ07nHwN7nIpSr/IZAH5795UDS5/08487IWA/CMUVVxzfOQuaojDeQ6vXK+BmHd22iUzT6heyZvSLle8OBqvfDHC/i6SML7zjVcPJQT7tkbZt7vnhZYCTkXdoDhaTL0bdiDgLVUO5clgRFDUaUfYEguqdIlXGtmXUyNRptTekQ+NHWHT20mWOQFYorPJajDkvNLsYZRu63797XFcSIGCPI8PqKFQpNWRmKLS9YBJKN7gmi63EZkiXbPEvuBZJVsvkDTazQUg/DMVQlpmPYW9qinvixUxg/CTlkT2+i3iwXKfQsTQfdtUMMT7hffHn8GfA5H4Xh7E+B987hRUZdfZmSqrzcXWO65ByWIm58y5D4YOOJ8eRcPH+Sob24z/dvOQhNhyWZ35XQrLTFasOsIuHqMpBy72k+aLadMGq0YcgtqSlhhFTEvKEoV9Gb2VUlEtSfE0/iZVSp2LvuWDdlFtiscte
 GF0LfZtZ
 BM8fuQiFmLklMKkg2XaJCoUdd7b0SwloBC+VA1GzNPZrfKLio1lbvIwzqHejqiZ1k19lGYddhCFBPh8VEaByezlIKJMrEM8amSrgBPP0hVIpdZdT2bqlXbcUleivODiQcV2gZX2ZlSNy1wcK8QbWiLQ/EdHGAldy+fqrPLthxDEYn9kf3aLYsJXMZfxIH9hNnF+sw2Vr/Lo8MurJ6stLywQdrLQtMyLQWt75NwdxKSf1HQWIcnmAS2PfoApQ+F91Rgt0pdfH+dWX5uhjhbTHVHls0fF8CNTMoiKyc/eYnle1bdSgsIPJDc/FvNDqfjXbxuLsHVd4IvO9MyxqdOWactiSCtKqEsBB2VsTn1Ye0MKSGAc51Gtttjgv9wGcOFYSssNMOHNNOQoUus0z9kLxx5iUq6e4KH+qD341rcOY/S9J5f6cZ904IKyonB6i0PjnovdlV5B0wWB7+rtAcK5VMCcUV3AUwkbey5a/50iSewAR0v5cR3cMVibwbWRj3wWSv1fqe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change free_swap_cluster_info() to accept struct swap_info_struct*
instead of (cluster_info, maxpages) directly.  Extract cluster_info
and maxpages from si inside the function.  Also clean up swapoff:
remove the snapshot locals (maxpages/cluster_info) and move the
p->max/p->cluster_info clearing after free_swap_cluster_info().

This is a preparatory refactoring — no functional change.  The new
signature will allow the xswap path (added in the next patch) to
access si->flags and call xswap_unmap_clusters() from within
free_swap_cluster_info().

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 22db5dae3639..4ce30e9ecdf6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3047,14 +3047,17 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }
 
-static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
-				   unsigned long maxpages)
+static void free_swap_cluster_info(struct swap_info_struct *si)
 {
+	struct swap_cluster_info *cluster_info = si->cluster_info;
+	unsigned long maxpages = si->max;
 	struct swap_cluster_info *ci;
-	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
+	int i, nr_clusters;
 
 	if (!cluster_info)
 		return;
+
+	nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	for (i = 0; i < nr_clusters; i++) {
 		ci = cluster_info + i;
 		/* Cluster with bad marks count will have a remaining table */
@@ -3093,11 +3096,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	unsigned int maxpages;
 	int err, found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -3189,10 +3190,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	maxpages = p->max;
-	cluster_info = p->cluster_info;
-	p->max = 0;
-	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 	arch_swap_invalidate_area(p->type);
@@ -3200,7 +3197,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p);
+	p->max = 0;
+	p->cluster_info = NULL;
 
 	inode = mapping->host;
 
@@ -3567,6 +3566,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	if (!cluster_info)
 		goto err;
 
+	si->cluster_info = cluster_info;
+
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
@@ -3630,7 +3631,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si);
 	return err;
 }
 
@@ -3849,7 +3850,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	free_swap_cluster_info(si->cluster_info, si->max);
+	free_swap_cluster_info(si);
 	si->cluster_info = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
-- 
2.54.0


