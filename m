Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E438E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oY5yG45o
Received: by kanga.kvack.org (Postfix)
	id E8E696B05C5; Mon, 23 Nov 2026 09:18:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66556B05C6; Mon, 23 Nov 2026 09:18:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CBC6B05C7; Mon, 23 Nov 2026 09:18:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB8B6B05C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:18:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 351D240735
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:05 +0000 (UTC)
X-FDA: 85466588130.24.D4A17C6
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 52532120006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oY5yG45o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443483;
	b=Sx+d9uFmymqwJMvNSsAlSQJVRc3qPTuqBZelOCAowzhB1vJgNLbMlLbG85v+vUKD8dRQO9
	BwIJFPlDbujbvCobRBysmpWPHowg+q9p2sYdYlURtCLt3vmYMhXZ3x1YSh9oKVWgAkqy5s
	Im5wKiqgIYzMTWtCdlFSw4l++K70GvQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybF47ocCWvIcKUYoyrk7fg1lx4d/sG4pX4J45rdUS78=;
	b=fFoKJBt1iv91tdFdv8RfWxW1NYw36tuq2xggE/iLiQnl7TeNI5DeJm4a7DALXKkrLgwL9o
	BO5Nk/kQVVzpfi7S51+pnTGGCknD2G9mQkQCRXRIv1qPFV8n4/hd2qgyJVwxu78x8MOYcu
	dQx3YGuZHFWaWljnmAhA+/T98CN1pLA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oY5yG45o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1b244fb7fffso2997790c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443482; x=1796048282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ybF47ocCWvIcKUYoyrk7fg1lx4d/sG4pX4J45rdUS78=;
        b=oY5yG45odwfIaf1WlK6ivfQ2WkuQY62astVdzcpELxNJjBkOd3QiL5zmAYGlmd4+5x
         RX89GsSzL19gU4SeTv3mpxz7pChidD+juzgcFjHYRWfddoO94E/DTSUx8b8HyNvhHbUK
         XPDLu1/o+pdvQ+zt9/1CRXbPFSYljdWR9c3VEp8Nv4Yy1nCUVhDUNsVwhZ12HGShgWVY
         3QpwYyxB8iNTlUhlEWsBKDpIQcfXIw9Vr782uieoz4rUkal3YvDhcVIHiiFiyAANzI2g
         OcRq/TqUYMYtzXyDp3g2Zj2+F28Uh0fTblgMisijCncou/tA9T5ZpYpiW4+QVc0sIdEM
         KLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443482; x=1796048282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ybF47ocCWvIcKUYoyrk7fg1lx4d/sG4pX4J45rdUS78=;
        b=wS6iA3pmHyS4KYqhj9Px0jPZfpjZCj9IFhn52qhQ7Ed0boN0+9Glyn9vmKAkwp1Xyj
         W0vklOic2h3IljCAgKYwz3d83MdwcG1W1tKD/dtPRbd1Fm0tGeIRD8hCUnmWplgp5CGR
         2uW9Q70kHzvNiBeb+1xaPUgkleOl2nez27qjmJD4DEWX1e+gSUWUrCxqBEoZnp7Wxu+f
         QlDYUTjYTC0qMUnQA9ezYuHtoA2ccp2yDwMG9TGrNT9S5wFoNfC2P6qL56jwfAxQVwlw
         sRGXT/csDXogPlFjt3ZFlA0TfeOUXer0FCCn2ezdECnaTyR9o6Ks9oLVB9Mq5hCWnoGV
         1M7Q==
X-Gm-Message-State: APuU4Z/sW3w3MhRSNBRFyVvAcHQhqVjWycyDG8IRkZrSPgMexm4VgaqX
	cUIJU79wT/MPVOyCIB4hcM4nFOCxK5eMwN6SfK1czbxxLOxBNqWI7FFnMx0uk5yD
X-Gm-Gg: AZFdTZdztd+YXDuARQZHFoGyz1xIlPhpZFmiIvCHMOBXOP9ABHH+U1st+bE9JF6JOZ3
	Gq8Z78s5d+m8CRqNugtoVQmPZ5abJsqKsVqWjmfkHHg0t9CA6r8cttZ8m2cDCuotMz8c/JYvp5r
	hlBZB18d26ZKMgIRY/ZZSpoHq4TqL3keRtGI3bhl4msku3RaDPfGYs3TegpqYS/dHbEVqWWD9qc
	cft9v6cD9TQQco/r5T1bAQQf/FXoG9kG1Fz4zcObSGXLdomQOI+gv6iInDZdVVYqRQlfWA/AenX
	huntf9eSSC0nMUJ+I381Oc3OmvkhtmtEDXaAB8ljrtmvpF72aGi4rKu0dbia2amtuLdIHWqFYl5
	80u8jkwi+g8DkeBLFtTS+hvfBfwLDB4UqGCEWmHeYVo0ujKY47xi56fhjE4DsieLGdvetQWRrEv
	oYdb/SO/Ktt+WC6f/mF1PwnKWNPx+8SeCalL3zoM9drPca87LKDfLQQ7tLjy46R9pkwJ52wjmxP
	4eHXUU6AbKKIuBJs3BFwU7O0awFLDYjuvvhuRwzYuXFJLCq1Md+2+seTCum6cuj/M/3lJv/l2wu
	lkySnyQrER2RLxrqpzQv47AeLbgsUk+LFgR6BadKjUtibktGS7ausUS48PWm2hCNOFsgbQE9emT
	dpIDWbv1dcZcrow==
X-Received: by 2002:a05:701b:4587:b0:1b5:1a7a:2ebc with SMTP id a92af1059eb24-1b56f87ab60mr4253583c88.16.1795443481741;
        Mon, 23 Nov 2026 06:18:01 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55ff0e4e6sm21509155c88.11.2026.11.23.06.17.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:18:01 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 08/19] mm/swap: change back to use each swap device's percpu cluster
Date: Mon, 23 Nov 2026 22:17:21 +0800
Message-ID: <8d0a8b9726974ec0dc73d2400f817c9ebe193c47.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52532120006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: etyp5chwrhxncy4tydksrwtzig1ka9j4
X-HE-Tag: 1795443483-852918
X-HE-Meta: U2FsdGVkX1/1Z99UrfZG1ioaKXxY+yRBQz0TYWHQEMtSGwdvZFj4gwxrzRQjghMcTMMUid+5xRZCVZ6OQF3tBjFHbRvsKs7Ze4K4Xp1MEAnJyfTUm3UqUmIN0aqYR4rp0yc61IHrQtP7wSjtgdq//n7KmD1Jq/AAfjxLvMRBYHQ8rqmR3sZocWBCih1p2cdRO0GOtAu/ndN6IbRyecynngPVbdpec6U5NnbbZVIj9pRe103UiA6cXfBhdZYHe6Xt9DOYI716pbzcJa1uUVXzDmLT6HSulCD77NL9z9NOSNd1bHdog214pmF6i7AzD7xdOSxwavyFU8V1pbIXYdmZsoB/Bsvus1TZAx4uBC1OUViVSwQ4iKPjEycAehYHXOfh59EA5S8urVk9lgw2hRd03aTMw9Cnh6dr9SeIRqvGQQQOV0j6Z7LbPe743/O0lKo8QaDlVDBA1vZEqsoP9tv5UgKnt4sOqBk3Jhc5bTK20MaahcB3er6sR2W3L2hZ3aMp5w+TDtAwJGSjNfqm2wetWoWeqPI8hGoI3PKuU2QZ5UINqob8x0MPf6e6F82VkGQyMMSuIG0I6u/nL+qKygR7+GlBvtW85F2LWkWqIkUSYOfHsVOi4R4/YNlFxRWf+Oek8s1IRjHbY6hlY3Gp7Qc9Et/CvwpvrMS60GkO7KCB0Fv2b+tJ89BzgQKD34K0IGWblJ8qSKn2Ji7h3jfy372g3XPaCIqE7ZCCh2GTNBcH2idnbzs3wk/dn/fESu4shQskCoI6bxnyXwjd0rdHn00RxBEsE2Q0WefoP1y3L4fbxCWt1Bh7M1MmkDjupTFK0mmh1zzzSGAXpYYBT0UUCP+8e2CqXR4Z19CQJc3vVaj0lMCRVBsA9WQlJjXvFDwxX8mGKUKRoMBIWg/8AOF66GrZi6tmelvDLUSJJOtDfquNUTDs6kSFQduM19NvO3cXSS8BZpygt+9sX3u3uDm8dIs
 o+stJEBx
 lsts9flfpaf75RgCuSfiOXUqzORSIlPAm1d6Xp+eVyknjU0D0lR+QgBdWjYE+jA2YjePctMBdW3/5XKS66ZXJK0AiexreiN6Oyr+qpcnMh4h43/a1qDgLKBo1a3B4RbaZ0qo1moghWztJl3rqGaCQ40kiiYO+l8RqqDpedkZdhE/ngHNjX/blV18a2Sb95MFYmN27QSFLXwo2pDNySTO2Jbj20rLCuAhCzUfvtT6WGbNzZE5iPf9Xek9XjhXZKyVFPQyaY/xnjDGXI79ckzgUZSznftzDhmgzKNzxZgLv+qzrkAShy2UeshYBrRFpVAqquxtj+grJ9OQdrpu0b1iZzhgdAWluP0CTk6bIh4Jv4E7VLCOnpRKAMDjAJD+jXP3YNQUStvUv4uP/lpahk1ObRQ1rbfZgXL/bgAMew+qzipOkSYhg1KHCjTLXXIauheTql9CjStQOZ3/jxPmTlJJgvFyb3MIkXc++EzgHVgAqlibG+0o4z6T+FhfS8/oL91FITNdYySs1iwTmyZIyOoQOnGqwVe0GDt8USVSCZot3CF/rmqplsy32iWN2AZXLUw7ikG/MsUgRTOnWUCca23TOL/St9JW/LM01tfOK+YgRkp+7gdg1wAEeRjJC3ymFRG9NY3+ACP8uMIfVqxX6+cT8n28EhtMVMszxJvjUZjhgefzSHdcssCa/S5CY+luX6faLyso76+EJI1X5vEVU5mopZ88YeTHfp8rH63js4focQ8Nr3v8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Youngjun Park <youngjun.park@lge.com>

This reverts commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
allocation fast path").

The global percpu cluster causes several issues:

1) It prevents efficient swap allocation for users that do not want
   the default swap device policy.  Because the cluster cache sits
   above device selection, users that need a different policy must
   bypass or replace the cache. This complicates incoming ideas like
   swap tiering.

2) It can bypass a caller's preferred device policy. Consider a future
   policy with per-memcg device restrictions: memcg1 can access devices
   A and B, where A has higher priority; memcg2 can only access B. Memcg2
   can write the global percpu cluster with device B, then memcg1 takes B
   in the fast path even though higher-priority device A is not exhausted.

3) The fast-path / slow-path design bundled with the global per-CPU
   cache is problematic: only the fast path uses the global cache,
   and the slow path is forced to rotate the allocation list.  This
   complicates consumers like discard.

Revert to per-device percpu clusters first.  A later patch will
introduce new infrastructure for a high-performance global
allocation path.

Suggested-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  13 +++-
 mm/swapfile.c        | 170 ++++++++++++++-----------------------------
 2 files changed, 63 insertions(+), 120 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 717387e16a2d..c8a5684b2f4f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -241,10 +241,17 @@ enum {
 #endif
 
 /*
- * We keep using same cluster for rotational device so IO will be sequential.
- * The purpose is to optimize SWAP throughput on these device.
+ * We assign a cluster to each CPU, so each CPU can allocate swap entry from
+ * its own cluster and swapout sequentially. The purpose is to optimize swapout
+ * throughput.
  */
+struct percpu_cluster {
+	local_lock_t lock; /* Protect the percpu_cluster above */
+	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
+};
+
 struct swap_sequential_cluster {
+	spinlock_t lock; /* Serialize usage of global cluster */
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
@@ -267,8 +274,8 @@ struct swap_info_struct {
 					/* list of cluster that are fragmented or contented */
 	unsigned int pages;		/* total of usable pages of swap */
 	atomic_long_t inuse_pages;	/* number of those currently in use */
+	struct percpu_cluster	__percpu *percpu_cluster; /* per cpu's swap location */
 	struct swap_sequential_cluster *global_cluster; /* Use one global cluster for rotating device */
-	spinlock_t global_cluster_lock;	/* Serialize usage of global cluster */
 	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4fac894f8c2a..cd2cb360f274 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -145,18 +145,6 @@ static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
 atomic_t nr_rotate_swap = ATOMIC_INIT(0);
 
-struct percpu_swap_cluster {
-	struct swap_info_struct *si[SWAP_NR_ORDERS];
-	unsigned long offset[SWAP_NR_ORDERS];
-	local_lock_t lock;
-};
-
-static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
-	.si = { NULL },
-	.offset = { SWAP_ENTRY_INVALID },
-	.lock = INIT_LOCAL_LOCK(),
-};
-
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -523,9 +511,10 @@ static int swap_cluster_alloc_table(struct swap_info_struct *si,
 lock:
 	if (!locked) {
 		if (si) {
-			local_lock(&percpu_swap_cluster.lock);
-			if (!(si->flags & SWP_SOLIDSTATE))
-				spin_lock(&si->global_cluster_lock);
+			if (si->flags & SWP_SOLIDSTATE)
+				local_lock(&si->percpu_cluster->lock);
+			else
+				spin_lock(&si->global_cluster->lock);
 		}
 		spin_lock(&ci->lock);
 	}
@@ -610,9 +599,10 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		lockdep_assert_held(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		lockdep_assert_held(this_cpu_ptr(&si->percpu_cluster->lock));
+	else
+		lockdep_assert_held(&si->global_cluster->lock);
 	lockdep_assert_held(&ci->lock);
 
 	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
@@ -625,9 +615,10 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * the potential recursive allocation is limited.
 	 */
 	spin_unlock(&ci->lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_unlock(&si->global_cluster_lock);
-	local_unlock(&percpu_swap_cluster.lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
 
 	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					     GFP_KERNEL, false);
@@ -749,7 +740,7 @@ static bool swap_do_scheduled_discard(struct swap_info_struct *si)
 		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
 		/*
 		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster could be
+		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
 		 * pointing to it, or ran into by relocate_cluster.
 		 */
 		list_del(&ci->list);
@@ -1104,12 +1095,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
-	if (si->flags & SWP_SOLIDSTATE) {
-		this_cpu_write(percpu_swap_cluster.offset[order], next);
-		this_cpu_write(percpu_swap_cluster.si[order], si);
-	} else {
+	if (si->flags & SWP_SOLIDSTATE)
+		this_cpu_write(si->percpu_cluster->next[order], next);
+	else
 		si->global_cluster->next[order] = next;
-	}
 	return found;
 }
 
@@ -1210,13 +1199,17 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order && !(si->flags & SWP_BLKDEV))
 		return 0;
 
-	if (!(si->flags & SWP_SOLIDSTATE)) {
+	if (si->flags & SWP_SOLIDSTATE) {
+		/* Fast path using per CPU cluster */
+		local_lock(&si->percpu_cluster->lock);
+		offset = __this_cpu_read(si->percpu_cluster->next[order]);
+	} else {
 		/* Serialize HDD SWAP allocation for each device. */
-		spin_lock(&si->global_cluster_lock);
+		spin_lock(&si->global_cluster->lock);
 		offset = si->global_cluster->next[order];
-		if (offset == SWAP_ENTRY_INVALID)
-			goto new_cluster;
+	}
 
+	if (offset != SWAP_ENTRY_INVALID) {
 		ci = swap_cluster_lock(si, offset);
 		/* Cluster could have been used by another order */
 		if (cluster_is_usable(ci, order)) {
@@ -1230,7 +1223,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-new_cluster:
 	if (swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
@@ -1283,8 +1275,10 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 done:
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_unlock(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_unlock(&si->percpu_cluster->lock);
+	else
+		spin_unlock(&si->global_cluster->lock);
 
 	return found;
 }
@@ -1440,41 +1434,8 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
-/*
- * Fast path try to get swap entries with specified order from current
- * CPU's swap entry pool (a cluster).
- */
-static bool swap_alloc_fast(struct folio *folio)
-{
-	unsigned int order = folio_order(folio);
-	struct swap_cluster_info *ci;
-	struct swap_info_struct *si;
-	unsigned int offset;
-
-	/*
-	 * Once allocated, swap_info_struct will never be completely freed,
-	 * so checking it's liveness by get_swap_device_info is enough.
-	 */
-	si = this_cpu_read(percpu_swap_cluster.si[order]);
-	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
-		return false;
-
-	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
-		if (cluster_is_empty(ci))
-			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
-		swap_cluster_unlock(ci);
-	}
-
-	put_swap_device(si);
-	return folio_test_swapcache(folio);
-}
-
 /* Rotate the device and switch to a new cluster */
-static void swap_alloc_slow(struct folio *folio)
+static void swap_alloc_entry(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
 
@@ -1842,10 +1803,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
+	swap_alloc_entry(folio);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
@@ -2251,31 +2209,14 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
  */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
-	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
-	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
-	struct swap_cluster_info *ci;
+	struct swap_info_struct *si = swap_type_to_info(type);
+	unsigned long offset = SWAP_ENTRY_INVALID;
 	swp_entry_t entry = {0};
 
 	if (!si)
 		goto fail;
 
-	/*
-	 * Try the local cluster first if it matches the device. If
-	 * not, try grab a new cluster and override local cluster.
-	 */
-	local_lock(&percpu_swap_cluster.lock);
-	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
-	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
-	if (pcp_si == si && pcp_offset) {
-		ci = swap_cluster_lock(si, pcp_offset);
-		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-		else
-			swap_cluster_unlock(ci);
-	}
-	if (!offset)
-		offset = cluster_alloc_swap_entry(si, NULL);
-	local_unlock(&percpu_swap_cluster.lock);
+	offset = cluster_alloc_swap_entry(si, NULL);
 	if (offset)
 		entry = swp_entry(si->type, offset);
 
@@ -3253,27 +3194,6 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 	kvfree(cluster_info);
 }
 
-/*
- * Called after swap device's reference count is dead, so
- * neither scan nor allocation will use it.
- */
-static void flush_percpu_swap_cluster(struct swap_info_struct *si)
-{
-	int cpu, i;
-	struct swap_info_struct **pcp_si;
-
-	for_each_possible_cpu(cpu) {
-		pcp_si = per_cpu_ptr(percpu_swap_cluster.si, cpu);
-		/*
-		 * Invalidate the percpu swap cluster cache, si->users
-		 * is dead, so no new user will point to it, just flush
-		 * any existing user.
-		 */
-		for (i = 0; i < SWAP_NR_ORDERS; i++)
-			cmpxchg(&pcp_si[i], si, NULL);
-	}
-}
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3325,7 +3245,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
-	flush_percpu_swap_cluster(p);
 
 	destroy_swap_extents(p, p->swap_file);
 
@@ -3346,6 +3265,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
+	free_percpu(p->percpu_cluster);
+	p->percpu_cluster = NULL;
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3690,7 +3611,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	int err = -ENOMEM;
+	int cpu, err = -ENOMEM;
 	unsigned long i;
 
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
@@ -3700,13 +3621,26 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	for (i = 0; i < nr_clusters; i++)
 		spin_lock_init(&cluster_info[i].lock);
 
-	if (!(si->flags & SWP_SOLIDSTATE)) {
+	if (si->flags & SWP_SOLIDSTATE) {
+		si->percpu_cluster = alloc_percpu(struct percpu_cluster);
+		if (!si->percpu_cluster)
+			goto err;
+
+		for_each_possible_cpu(cpu) {
+			struct percpu_cluster *cluster;
+
+			cluster = per_cpu_ptr(si->percpu_cluster, cpu);
+			for (i = 0; i < SWAP_NR_ORDERS; i++)
+				cluster->next[i] = SWAP_ENTRY_INVALID;
+			local_lock_init(&cluster->lock);
+		}
+	} else {
 		si->global_cluster = kmalloc_obj(*si->global_cluster);
 		if (!si->global_cluster)
 			goto err;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
-		spin_lock_init(&si->global_cluster_lock);
+		spin_lock_init(&si->global_cluster->lock);
 	}
 
 	/*
@@ -3980,6 +3914,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
+	free_percpu(si->percpu_cluster);
+	si->percpu_cluster = NULL;
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;

