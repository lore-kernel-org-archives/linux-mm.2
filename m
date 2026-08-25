Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8475C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57166B00A1; Tue, 25 Aug 2026 11:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9924B6B00A2; Tue, 25 Aug 2026 11:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859B56B00A3; Tue, 25 Aug 2026 11:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53F526B00A1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:33:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB63D1C193B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:59 +0000 (UTC)
X-FDA: 85140184878.03.523CE79
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12DAE100005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EW8PDoHu;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+G2HY1nMuhTy8GReU5FQmdFCwNyu4BLzojPY+0AOwU=;
	b=oRc1t7y9x2u33PN/k/wUranEVYQkEj/lp4yDBTmpBN7w1pY0+lbdlfjc6ntKCA5bYFnhqn
	R+nVZNm5+GjdObXjcG0CV3fegibW7EYLECsiMPsbjSVBWdYy5TGYyg83PaqUhLSohkr3Na
	QFEC+f2U26c4ls1W3YfkRMQHX3pvr4U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EW8PDoHu;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671978;
	b=AyWHLHS8CmNf0ePBJG3+hDLoCr+Dxlw4vDBL4Uaz7bb2S+5lBTA3giIiNo1d5ccqPnx3DW
	KJVpNW9kXCdz/hmSWfJSdVJCola3WkP0Ahs1zLTtt9gzek6SH9rWh+25RvUMDn9QJbTqNL
	Z9l1nnSdkIOFvM/p7ey9vs9MH6rGAB4=
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-44aeefa1c00so1173328fac.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671977; x=1788276777; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e+G2HY1nMuhTy8GReU5FQmdFCwNyu4BLzojPY+0AOwU=;
        b=EW8PDoHuM/d5I2ylGurlpAiwTfu/juNvUG9MdRp2kYPP9NQbGwKNnacU6k0ciKtD23
         3u27VM+1Ct98l/V4rEo4L73fBqVwqNJz/qvTqbKyiJPWSs2GmnfYcLlsHNvv3oZjbj2Y
         BilzP0zXbdiliyTNGOfXDNg44JiOToGRdazfr4aksLkmtbZg2tyJiK7/hpnf1/aibYDS
         JkzvpcVkCTmj8liLZkhRTIT8BocF/Gw4UPNKmgD/XWQ2ouKa37wzcWMnGK2MlxBYa4I5
         P1WwQdbzl3eg4H3iqPAfkh5at22JSJPmNfN6XTum+z307Eh+d0gqqhgZroud0Z/3Fmr5
         zpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671977; x=1788276777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e+G2HY1nMuhTy8GReU5FQmdFCwNyu4BLzojPY+0AOwU=;
        b=H05lDyxXvhRn1VN+UDDHtztDYOtfMy+06ysSZdWnd5eRKVz/fSosVAkvYTLntYepPp
         RPKIF0E/st03zFyZzKXKBJX4qrPt632PgB9CrJs+cK3hDSg7MSb0JLTVEEa6/L7v6gyx
         4x+/aDHnk/Zt4Q/uziO1IMlXbn87SENFev8z0Grn2Kn9rjr3GQA2mtmw0qkQTG/aO0ZG
         fBSEnr6QTPUQzM5TPJAsAxDJlaM0IIYN2ASKMhGGvHDkf629wCOmi/Vzs2S2KfmRyWF0
         mAgiVJbEeit99e3HZyHulBFrZsjcZserd+QQ4/HSrbEelQ9Vzjs7IRXgrQCggJ/YHGJl
         DfZw==
X-Forwarded-Encrypted: i=1; AHgh+RpDkpUwCDybz9y6qYwxXkEhwv990sMfMXC2x4de97FojPZopDmnnlg0DPNbSvWeiAViPcMxzzvU1Q==@kvack.org
X-Gm-Message-State: AFuF++knJwNDi+Cfl4IPJDTUTRhhRJQfpHfBJ1n1pQ8+0ChP/cr+5ApD
	/taF5lE3j7AUCiSDgf8ZmRZ5Yu31TWQKVDJrosAcngTmIwE0sTQxcXwA
X-Gm-Gg: AR+sD11jFTqru3uKFkSTO0VL93o/QIO3/apZZE9FngBkjmE9tO0SGdPIxCOkgutPy5E
	VVbW9/899Jaj2b+sIvffVotkD7x2Xsr/9iu/VMlm2MPTQUeqV0x9n4XfMrQmqoL0XNOmqfBdpnR
	C1cQXrP/lWwWT9sIOuuhzMOVfpA/JM6C7rOHuP9f3HExRdRtqPkRq1HKJVeLv3pXQPClRr+qYw7
	Qhv8AegNGfSfDjyTTVX+z1SqvoNWIQcMKWuKgThYU0t+luPCBWmRFDiKUusISfVzksb9IJ1xKqp
	27VxrlIG+A6zdtdlm08v7/Lh6wGPtG6J3xnwyAiF7+Wvs5e5lgpAMQh/YZsUHx2jcKPLscV0DK/
	ZT7QB0+8iOGoUPibfWyVor0zmqkPVbV+/wJ862mKM8BEJMjNIYSEyiaJpIZ+yh0ArUojVOAmm8d
	x5f5DXebaIR3WWcK/O++LiHdxlCZRges5WMr6Lt/lJ/dh3nEqncCjR+QBcq+2PFfHHdROOIuCHQ
	A4stCqRSg==
X-Received: by 2002:a05:6871:d607:b0:451:fbeb:e9a6 with SMTP id 586e51a60fabf-464443cbc91mr6041524fac.0.1787671977026;
        Tue, 25 Aug 2026 08:32:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463831397bbsm7562679fac.4.2026.08.25.08.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:56 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
Date: Tue, 25 Aug 2026 08:32:36 -0700
Message-ID: <20260825153238.2695446-11-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k1gynw5o6w61br9krjnw1uwr38rnapbc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12DAE100005
X-Rspam-User: 
X-HE-Tag: 1787671977-707048
X-HE-Meta: U2FsdGVkX18ljX50dl9G+6K23MC0VX9XHtTsAgIqxJCkzPXLR8ePFVT2nSZYWZmBQ9z5xTcfUMakhEIJZckf0VqakI3T8K+3QUSxGAAmpCD54wAxzwBrTBZTbxx926m4pHtjT+eIvH36AqceasRCF8gsr38Kio+EtqzFl58k2N7cC7TbIFyGoe8nIABk8HBuiCbqWznPhfxcO/WtJeH0PV4mWZ+16ZcwxVETWfuDhrj8MYvygGj4+VjDTQQ8B8oFtOZK+kCTT6IQkzT7KJcibQLjuxZHgSOVjOkElgynzzpcBw/xyDYPvyP5dM4NSwGIjnOxtCfjsJGBN1YADxfu9SKWUtvEub2OXzyJopIiysu4+zFUiAGAnzn91L2fzPyZ2YmA2XLIgirWxdRmx0lXfwhhjfqt2WlMddBWZ0l17E13ffjGZTNPSvLVIl7G2pcpXppkhUxfUxvhRJehOKZSXmqPTBlpfcMqAfc1aT7Es0uqmdYhrpROpxZfid8hkAgN6sCbUE9LUq1QwWgmepUjls0N9bBRwyXCump7mRRn4W/u62SKQ6XSCaVISvuSh/Cy8hq+CSkPLGnlLOq2/mhHbyDRoJei5dTgLQxpvyDjZnLSh0ZE15+VMDLAnFtsZ2fVFB7B0pBDFdV5cmyMExCYEN22k5d3yQNb/hZ2FPAmfVITrOqPk7u981gMhuLwuwViOwxsd6HxCwWh6PELKxGCiRmFsROoQhcNp0SqR3hxNGRZ6HbTF2R2I2E8iFoZTrBXE+H3uOe1RswiSWemMKvUmTflXvZMp7WkIqkqVXxoWSP2Iak3sT31bLcXMmbADLzKLCUGiDh/ScicObHqpvwK+aBXdT+wWRp2k8TD1+qsH9IvE8ktcIb00NIBTINQy04VUBPckQ7xDyuYrmD+J597E9p8uKx1UvQryk59MrOwAKszy3KU963QV9WmdXZqZ9ILDTHHR2c0a/ER1znrRY1
 K4m0MVar
 iZ8xj147aT/OMQFgncg9qe1jmiRBILigxD0pHD6usD56Nakt8ucTkNqe2qmYxVN5Xd9nJl/pynDdzfcppnT9ISkPS4Ex8IaKEzd52mHFiX/dcg/a8mnbIU7uwQjdBDTtaPycxxdhrTTxI0UDe5HVVSgJG2AbIY8f9O5oB1BLNKBJ7uYuxVG2UiTiiFJOBzIFeeufa8WfwD+CUdP3t4f9ROi8ijao4kXXxIZhfvcpTRRP+xZuQ5v3EAa+kCUTP4UaAdo30//LWoP+6AGMDCXjQ1sOudpOsEjoF7EvUtGTwDn2nykyUZGEZl3ZrEwduGxDNvrW/YDQiLhORpbpfrZR89Gi5p/O8dmuY7jcUibHhqJoGNVpaHFv2xFBa+PRmTc5w94YdF4/xo8h5qqxRBFqlKZS0C1GluUcQI1okGo3hS9YDA9YVwp5LE5m87vdu4gyMEkHGm43ZcrxVdULeoIOKDnOzu4cTllSlrOUGbB9yX6xAmiHsEAgVnrpEKJbEN9muxRGKDM6D52EUjAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop allocating a memcg table for every physical swap cluster that only
ever holds vswap backings. The table costs SWAPFILE_CLUSTER *
sizeof(unsigned short) per cluster, 1 KB per 2 MB of swap on a 64-bit
kernel with 4 KB pages. On a vswap-heavy workload, where zswap writeback
is the only consumer of physical swap, that is the common case.

Such clusters never have their memcg_table read or written: vswap-layer
charging records on the vswap cluster's table, not the physical one.

Allocate eagerly only where the table is known to be needed: every
vswap cluster, and, when vswap is off, every physical cluster, since
all of its slots then map directly into the PTEs. A physical cluster
otherwise allocates on its first direct-use slot, and skips entirely
if it only holds vswap backings. That deferred allocation can fail,
though rarely.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 85 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 66 insertions(+), 19 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3b10173cddc3..8c80544a7d25 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -471,7 +471,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		 swap_cluster_free_table_folio_rcu_cb);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -494,7 +495,14 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	rcu_assign_pointer(ci->table, table);
 
 #ifdef CONFIG_MEMCG
-	if (!mem_cgroup_disabled()) {
+	/*
+	 * A physical cluster under vswap may hold only vswap backings, which
+	 * record their memcg on the vswap cluster's table, not this one. Such
+	 * clusters defer memcg_table allocation until they hand out a slot
+	 * that maps directly into the PTEs.
+	 */
+	if ((!vswap_is_enabled() || swap_is_vswap(si)) &&
+	    !mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
@@ -565,8 +573,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -579,8 +587,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -857,7 +865,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1079,7 +1087,9 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    struct folio *folio, unsigned long offset)
+					    struct folio *folio,
+					    unsigned long offset,
+					    bool *nomem)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
@@ -1108,6 +1118,24 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Lazy-allocate memcg_table on the first direct-use slot of a
+		 * physical cluster.
+		 */
+		if (vswap_is_enabled() && folio &&
+		    !folio_test_swapcache(folio) && !mem_cgroup_disabled() &&
+		    !ci->memcg_table) {
+			ci->memcg_table = kzalloc_obj(*ci->memcg_table,
+						      GFP_ATOMIC | __GFP_NOMEMALLOC |
+						      __GFP_NOWARN);
+			if (!ci->memcg_table) {
+				if (nomem)
+					*nomem = true;
+				goto out;
+			}
+		}
+#endif
 		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
 			break;
 		found = offset;
@@ -1117,7 +1145,15 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		break;
 	}
 out:
-	relocate_cluster(si, ci);
+	/*
+	 * On a discard-capable device, relocating a cluster whose memcg_table
+	 * allocation failed queues a discard for slots that were never used,
+	 * which folio_alloc_phys_swap() reads as progress and retries on.
+	 */
+	if (nomem && *nomem && !ci->count)
+		__free_cluster(si, ci);
+	else
+		relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
 	if (swap_is_vswap(si)) {
 		this_cpu_write(percpu_vswap_cluster.offset[order], next);
@@ -1138,7 +1174,13 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
+	bool nomem = false;
 
+	/*
+	 * In rare cases alloc_swap_scan_cluster() can fail due to
+	 * memcg_table allocation failure. Short-circuit to avoid looping
+	 * over the list indefinitely.
+	 */
 	do {
 		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
 		unsigned long offset;
@@ -1146,10 +1188,10 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, &nomem);
 		if (found)
 			break;
-	} while (scan_all);
+	} while (scan_all && !nomem);
 
 	return found;
 }
@@ -1170,7 +1212,7 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci, GFP_ATOMIC)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
@@ -1196,7 +1238,7 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 	}
 
 	offset = cluster_offset(si, ci);
-	return alloc_swap_scan_cluster(si, ci, folio, offset);
+	return alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
 }
 
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
@@ -1303,7 +1345,8 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset,
+							NULL);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1347,7 +1390,8 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order < PMD_ORDER) {
 		/*
 		 * Scan only one fragment cluster is good enough. Order 0
-		 * allocation will surely success, and large allocation
+		 * allocation will surely success unless the memcg table
+		 * allocation fails, which is rare, and large allocation
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
@@ -1363,7 +1407,8 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	for (int o = 1; o < SWAP_NR_ORDERS; o++) {
 		/*
 		 * Clusters here have at least one usable slots and can't fail order 0
-		 * allocation, but reclaim may drop si->lock and race with another user.
+		 * allocation, but reclaim may drop si->lock and race with another user,
+		 * and the memcg table allocation may fail.
 		 */
 		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
 		if (found)
@@ -1586,7 +1631,7 @@ static swp_entry_t swap_alloc_fast(struct folio *folio)
 	if (ci && cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
 	} else if (ci) {
 		swap_cluster_unlock(ci);
 	}
@@ -1969,7 +2014,8 @@ static bool vswap_alloc(struct folio *folio)
 		if (ci && cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(vswap_si, ci);
-			alloc_swap_scan_cluster(vswap_si, ci, folio, offset);
+			alloc_swap_scan_cluster(vswap_si, ci, folio, offset,
+						NULL);
 		} else if (ci) {
 			swap_cluster_unlock(ci);
 		}
@@ -2836,7 +2882,8 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (pcp_si == si && pcp_offset) {
 		ci = swap_cluster_lock(si, pcp_offset);
 		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			offset = alloc_swap_scan_cluster(si, ci, NULL,
+							 pcp_offset, NULL);
 		else
 			swap_cluster_unlock(ci);
 	}
-- 
2.53.0-Meta


