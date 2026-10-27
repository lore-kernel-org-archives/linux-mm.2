Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6113E606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yQ+IWAEl
Received: by kanga.kvack.org (Postfix)
	id 6205B6B0819; Tue, 27 Oct 2026 12:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6A16B081B; Tue, 27 Oct 2026 12:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DB36B081C; Tue, 27 Oct 2026 12:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4E46B0819
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:10:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BED6C160AA0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:10:54 +0000 (UTC)
X-FDA: 85368894828.12.6AB05E0
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37B2320005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:10:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yQ+IWAEl;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117452;
	b=26HxjwbDFoMEOn8M28ZBTINDvO5iEO2CBbKVt7X9Ah3onlzPdggNA3lhCL+V284+sOutGl
	BGyhpz1RuCzxvWL9YOV/tuxS/PNVcL4jWcoK5pc1jjyS/F66OZSLFzOpICIbbPSeXS4/L8
	sXgs3U52t75w1jnIFU2nf+FplVZgtI8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yQ+IWAEl;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMVK9C6kjD2I/C8Mw6stURXeaeBe+UoUZ1aPJYJvbec=;
	b=uTS85PCLq9dUAySVN2t1y5h+S8D81+hOp3DVcrmhVpZWbU6R/THvgzpb46J8F8CYUdktZ2
	m3a3ZkSCSXu/5d8ZIQVQvYKtZUVBUo54f6fjKIBQUBdnoEGn5czyntp3BECztw/5J9ukhH
	UxYsDjoDkirSYclqB7kLpudl9gtaZpg=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso53508a91.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117451; x=1793722251; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BMVK9C6kjD2I/C8Mw6stURXeaeBe+UoUZ1aPJYJvbec=;
        b=yQ+IWAElMsm/hvBXg9MTj38X0bV0RDSBUyB3HZ77gI2J3zu5l8KR5PwU0Ys3tGzOQo
         Es2FnLBuPrvLHCv0h5ZjdaY9eTYtKWNnO76efraHG77ENX2sn3EDYPpK4GyHrUAVa1yD
         w33tGxFhbzy3rc/ROhN+q7mAi6mGXWrpA8Y6ifuPNWf0xUECFbqAXEjsoNmExvvEQL2V
         P3a7pXeaVEuXKlNJJUqoJSn+zoEcni8GklVup4QQSDq6+R+4I/Kaqjt5AV0FZ2dsbWzi
         yP/6RsnNJLKr7JrnD73pQpEZnQrh9xNbHISJ8RK5tO+JHHTawRgafyMCGMR2ny5ppwNN
         GBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117451; x=1793722251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BMVK9C6kjD2I/C8Mw6stURXeaeBe+UoUZ1aPJYJvbec=;
        b=jpebIrksp8pQdTmVS4Fn3GsEIH4zhF9lRttMuT0gtX9T6ygDjrDCElhosiIrTTli1W
         6o437T+/kgXyVgSHkPJQJBxVIypEaZV4DAtRqkxTh2XwpllE52ISU6tuqBJrEiuWHCqc
         GHyfXumCUa8lriuAIw2UBLwdKZ6F8hj3vcnP8okD7SDJ27Cq0c+BP3aFhUIVk20V9hS+
         MHt6AFqZoAZWiEnovqrzyo4uS01XRjZZdcjtPY80K9lOfgPfs2SNKFPyXJFxRafCludS
         PkKtqbCLEWiaDN0wvpYyCPvHWJv68cr3EGD5/strDeWhKy4ghpoGwvUmtTnrYi7XsJkr
         LFbg==
X-Gm-Message-State: AFq9FYJmQWycE9zhDxXbFjH52bzkQNJjGET0RKKFV1eeJM5CS0v4dIyo
	yNlF/uV4NIbhkhyEk5h+g5PC03DOHK057aFTO/vUa6xzOoeru3lGwlRhsZ/XXA==
X-Gm-Gg: AYBFou1AawEj+K9sJ0F/0ZWplkG2nH5DncQNKfGHLNNOaLfpVNbiFSqpmDpBi9lOYF6
	KW1BYqtUL6rGqWoNQin3rfum5CKIiNK4nKsQEPuI94iXosFVCjliqjQslOKEOtdova/H8EaVsNG
	MjIEfu7JCJfgBBTr7IaRXDxq+vhOq+LPa+8rn6Qck8xOW2cbw0WpNnSFEZaXO2Xo6neoAJ0Osqn
	XjIe6q/6jzWuB6uhAa3CWvBWk+fZV8PcK7ffeNCBXvl3D6U8/YOSpVRjTo5hnwCNzzjs6uqGmS0
	vM0eH/mFobOfDBnbZVxgbC2pQsOJEfG7hdkrZsviIwz5TsJsT5c59bnz8B/LxxbLMrT0j9mA3fc
	wIy/N+TxcQfyYvxjwEN+2zFO9uctwhaORRqjaZe6bUKhiq3mv6zBTLwMCjHX5QGlLKNZPbd5Qdw
	JRKTIFjDgAdXTdb4l8Qv29EIDQa9ne5HCWMWTYNBBYN4TLM0ExsdSZxT4hT/nT4YXuHEmx/vpAk
	v89r6wupxpe9bu05R61+cmkTnSBkCX5xZk7ZfYKxsRcsOHNTjLT84RtnD6h9Yl22j/xIaQIHHvs
	7yXyLbRuRwft7HTzk/Y=
X-Received: by 2002:a17:90b:3141:b0:3ac:9a54:e3ce with SMTP id 98e67ed59e1d1-3adeafb073fmr8492945a91.63.1793117450954;
        Tue, 27 Oct 2026 09:10:50 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae402a0692sm4393099a91.2.2026.10.27.09.10.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:10:50 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 12/18] mm/swap: bound synchronous discard during allocation
Date: Wed, 28 Oct 2026 00:10:24 +0800
Message-ID: <1de96c68db9d3ac83ae485a1eddabcea1a2524a1.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z5om6wcxhsrq16nb5uje1up885wai18x
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 37B2320005
X-Rspam-User: 
X-HE-Tag: 1793117452-146321
X-HE-Meta: U2FsdGVkX1/YvPm6l+zSPSV1C8oj2vUyhBAYxnQvjFUQpy/12JQfSPYSzB+ZBzkAUfieeIJt6zTAjOIPGzpCqlZNe+ZdA8b9ltDMKSs1m54yr30byxqQo7URNrHDMb56cfT5EZp8HOOvXLBGElXjqr0EjE+ZKmT3p4S16+HgunuKK7/dKvwMMZ+J5lo2v87FPQxpqQ2pcHk4OPjLj44zXFUKAvalXAIk1tYVnNc7PZlRI+S00xNx0iCDqZvva+zS8Xu49n3LlxIGnINy/tLo2ZDq5+7wzWxdf17PhblaF6RCW1QaPP7FTurIzTSYpkE9Bhv1L3E//fCg91om3guEEGAHAbxydL81uqBOVEOaq+4V/kAfyJFyP2I1Hq+mVs3ULpEbu76fz0t2SEOCwJJBb2QDI69sp3Xx9uzRm1BoHjB4S3fiytOuf5zAT+TsJvgJZFnsTkGfr3mzE35bBl+BmELHYW05OgWple6LbsqMN+KKNCb/dH/BU+nTHshy7Q6EFgvdBXXuQ7PBNYnTvotARL5MibZorhQd+qNmtUesxOgJU43gq07x9TpQqjFwoB45kpnPSTt/xP/rv9BNRt5Jv0KDI4NUG30eQ0cfc7bt6hNvduPZG7WA49t3iqNKfK89xlHOnrGlV9th6TimLjjnz8cuL0aDeA3Fq8NeKnpJ3YPHPJnntKTo4+NgHqUCwmzp+VIC0Tn1ciF5mBkxd9mfbV6yKAWr2G0P5jp8HfUIiYLCJro4HUsJs9ZuFQI3OWwecqDE3yWmHRiq0B5bp7opEl/aFcoUTVtwfQVBat0CmliywBRvBpejHzH5BNMUYC0fvCwLG5rukVEHKq77Pnp/66hTJuMHMg1BSVk4x/VJEuKpQmWzd3WrhiErhbNPcUycTMpi6HlxZl7uJPRM8iYsWpuJxdLSsBbtujJEW3jGjmEX/gKpONpKNQHyW5nXawnEMlEK1Nv3WaeULbUer5X
 732YXh+E
 6QmIVpS5EzNYr+yFEW2kTUY7MyD+O7qyzC+USuv917XCHFUXS+nRMElh0/brpX7uNcIGLLNiBzsFbgJiFnuJBXKVz65u4CMH6lD33jyjDDtuFtRvyoah94xj2m8zOrfbcXfa24Oo4PpCKvRsxLrhB3eWKFy6tejy2LMGgamlL3vAB/VzH5yc+B1tqtcAK8eCDyEQCE2SE0PTSz6CHOXZbrYau6hdWmcZ+VHpFuyxgq7C3f/e1Ea0PmpH6Ri0Gxb3o35rMlIIi+1JrsW53PB+B+wj6UBr0lQ2z6PrzNVqKFqxLiAe56Piu5KEBdTePWNGEKUXCbtZv6u5ChpV9EKDpcYxloqFgBlNRfmCQavsM5v9KbeZ0TCWpUAS3Gz/EN5ZGhnWg5VCzLaxEmZthF1+ng0qXE0yr6lVvYvamTkudPgnCTu05i424rdJONdBj5etE+Tf6xluB10H6fEBiB8Htu6g2wi8mmaibkXCCZtugSrraJ2WYYsBOF5nbmCdx2a1dS2O+aN5JQfHfcEswyrb9oguifQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The per-device cluster cache lets the allocator select a device before
handling that device's pending discards. Issue discard on the selected
device when its free-cluster list is drained instead of waiting for a
global fallback scan.

Do not drain a discard list that freeing paths can replenish. Factor
out swap_discard_one_cluster(), isolate one cluster under si->lock,
retain CLUSTER_FLAG_DISCARD while I/O is in flight, and return it to the
free list after completion. The background worker keeps processing the
list.

Each call to the device-cluster allocator handles at most one cluster
synchronously before retrying allocation. A folio allocation can try
multiple devices, so this is a per-device-attempt budget. It bounds the
amount of discard work, not device I/O completion latency.

Link: https://lore.kernel.org/all/CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 149 ++++++++++++++++++++++----------------------------
 1 file changed, 64 insertions(+), 85 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0a16343a5b03..5c26682c0bab 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -585,6 +585,26 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 	return atomic_long_read(&si->inuse_pages) & SWAP_USAGE_COUNTER_MASK;
 }
 
+/*
+ * Serialize the allocation on single CPU or globally to avoid
+ * fragmentation and make the workflow easier to follow.
+ */
+static void swap_alloc_lock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_lock(&si->percpu_cluster->lock);
+	else
+		spin_lock(&si->global_cluster->lock);
+}
+
+static void swap_alloc_unlock_device(struct swap_info_struct *si)
+{
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
+}
+
 /* Reclaim the swap entry anyway if possible */
 #define TTRS_ANYWAY		0x1
 /*
@@ -982,10 +1002,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * which could give allocator hooks and failure cleanup reserve access.
 	 */
 	spin_unlock(&ci->lock);
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	gfp = (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
 		~__GFP_DIRECT_RECLAIM;
@@ -999,10 +1016,7 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	if (si->flags & SWP_SOLIDSTATE)
-		local_lock(&si->percpu_cluster->lock);
-	else
-		spin_lock(&si->global_cluster->lock);
+	swap_alloc_lock_device(si);
 	spin_lock(&ci->lock);
 
 	if (ret) {
@@ -1092,44 +1106,40 @@ static struct swap_cluster_info *isolate_lock_cluster(
 }
 
 /*
- * Doing discard actually. After a cluster discard is finished, the cluster
- * will be added to free cluster list. Discard cluster is a bit special as
- * they don't participate in allocation or reclaim, so clusters marked as
- * CLUSTER_FLAG_DISCARD must remain off-list or on discard list.
+ * Discard one cluster. After the discard is finished, the cluster will be
+ * added to the free cluster list. Discard clusters are special because they
+ * don't participate in allocation or reclaim, so CLUSTER_FLAG_DISCARD must
+ * remain set while a cluster is either queued or being discarded.
  */
-static bool swap_do_scheduled_discard(struct swap_info_struct *si)
+static bool swap_discard_one_cluster(struct swap_info_struct *si)
 {
 	struct swap_cluster_info *ci;
-	bool ret = false;
 	unsigned int idx;
 
 	spin_lock(&si->lock);
-	while (!list_empty(&si->discard_clusters)) {
-		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
-		/*
-		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
-		 * pointing to it, or ran into by relocate_cluster.
-		 */
-		list_del(&ci->list);
-		idx = cluster_index(si, ci);
+	if (list_empty(&si->discard_clusters)) {
 		spin_unlock(&si->lock);
-		discard_swap_cluster(si, idx * SWAPFILE_CLUSTER,
-				SWAPFILE_CLUSTER);
-
-		spin_lock(&ci->lock);
-		/*
-		 * Discard is done, clear its flags as it's off-list, then
-		 * return the cluster to allocation list.
-		 */
-		ci->flags = CLUSTER_FLAG_NONE;
-		__free_cluster(si, ci);
-		spin_unlock(&ci->lock);
-		ret = true;
-		spin_lock(&si->lock);
+		return false;
 	}
+
+	ci = list_first_entry(&si->discard_clusters,
+			      struct swap_cluster_info, list);
+	/*
+	 * Delete the cluster from the list, but keep CLUSTER_FLAG_DISCARD
+	 * set while the discard is in flight. A percpu cluster may still
+	 * point to it, or relocate_cluster() may encounter it.
+	 */
+	list_del(&ci->list);
+	idx = cluster_index(si, ci);
 	spin_unlock(&si->lock);
-	return ret;
+
+	discard_swap_cluster(si, idx * SWAPFILE_CLUSTER, SWAPFILE_CLUSTER);
+
+	spin_lock(&ci->lock);
+	ci->flags = CLUSTER_FLAG_NONE;
+	__free_cluster(si, ci);
+	spin_unlock(&ci->lock);
+	return true;
 }
 
 static void swap_discard_work(struct work_struct *work)
@@ -1138,7 +1148,8 @@ static void swap_discard_work(struct work_struct *work)
 
 	si = container_of(work, struct swap_info_struct, discard_work);
 
-	swap_do_scheduled_discard(si);
+	while (swap_discard_one_cluster(si))
+		cond_resched();
 }
 
 static void swap_users_ref_free(struct percpu_ref *ref)
@@ -1536,6 +1547,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	struct swap_cluster_info *ci;
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
 	unsigned int offset = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
+	bool discarded = false;
 
 	/*
 	 * Swapfile is not block device so unable
@@ -1544,15 +1556,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (si->flags & SWP_SOLIDSTATE) {
-		/* Fast path using per CPU cluster */
-		local_lock(&si->percpu_cluster->lock);
+restart:
+	swap_alloc_lock_device(si);
+	if (si->flags & SWP_SOLIDSTATE)
 		offset = __this_cpu_read(si->percpu_cluster->next[order]);
-	} else {
-		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster->lock);
+	else
 		offset = si->global_cluster->next[order];
-	}
 
 	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
@@ -1576,6 +1585,15 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
+
+		if (!discarded) {
+			swap_alloc_unlock_device(si);
+			if (swap_discard_one_cluster(si)) {
+				discarded = true;
+				goto restart;
+			}
+			swap_alloc_lock_device(si);
+		}
 	}
 
 	if (order < PMD_ORDER) {
@@ -1624,10 +1642,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (si->flags & SWP_SOLIDSTATE)
-		local_unlock(&si->percpu_cluster->lock);
-	else
-		spin_unlock(&si->global_cluster->lock);
+	swap_alloc_unlock_device(si);
 
 	return found;
 }
@@ -1818,36 +1833,6 @@ static int swap_alloc_entry(struct folio *folio)
 	return ret;
 }
 
-/*
- * Discard pending clusters in a synchronized way when under high pressure.
- * Return: true if any cluster is discarded.
- */
-static bool swap_sync_discard(void)
-{
-	bool ret = false;
-	struct swap_info_struct *si, *next;
-
-	percpu_down_read(&swapon_rwsem);
-start_over:
-	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
-		percpu_up_read(&swapon_rwsem);
-		if (get_swap_device_info(si)) {
-			if (si->flags & SWP_PAGE_DISCARD)
-				ret = swap_do_scheduled_discard(si);
-			put_swap_device(si);
-		}
-		if (ret)
-			return true;
-
-		percpu_down_read(&swapon_rwsem);
-		if (plist_node_empty(&next->list))
-			goto start_over;
-	}
-	percpu_up_read(&swapon_rwsem);
-
-	return false;
-}
-
 static int swap_extend_table_alloc(struct swap_info_struct *si,
 				   struct swap_cluster_info *ci,
 				   unsigned int ci_off, gfp_t gfp)
@@ -2149,14 +2134,8 @@ int folio_alloc_swap(struct folio *folio)
 		}
 	}
 
-again:
 	swap_alloc_entry(folio);
 
-	if (!order && unlikely(!folio_test_swapcache(folio))) {
-		if (swap_sync_discard())
-			goto again;
-	}
-
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);

