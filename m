Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF22D606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xpe+hRiq
Received: by kanga.kvack.org (Postfix)
	id 928566B080F; Tue, 27 Oct 2026 12:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8096B0811; Tue, 27 Oct 2026 12:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0006B0812; Tue, 27 Oct 2026 12:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D67E6B080F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:08:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 821EC160AB6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:08:09 +0000 (UTC)
X-FDA: 85368887898.18.FC9AAC2
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id AE0E4A000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:08:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Xpe+hRiq;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk5sKJyk5V7wJVcqUwHINdY0qu+x+arRPxXrQCPNZAo=;
	b=6owSF+sv9++Awyz4jDCmJ0l1jGkajiEV/EhUBxX3AAKmiR9I1litJIYxET5NANn7BkucAo
	K8JUF9frBo+NMq42DJXTW2mXxEjMUbsuynMqw/KwjHZOSoCXqVfVHvW/JR2VeGtNV9Q5gs
	xlBt7c0oRpOcfR8aSQCzUKkCB1zDIFE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Xpe+hRiq;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117287;
	b=m75VZGWKfn0GmKOjJeu1XrZ1kSlF/PYEm3t627+ogU5pi6A9bbbaa1v9Ri6btsdkN7JJi0
	km75hwWPfL8ZP7glykJB8f0y0RZW6iWlb0xlotawAeH0WqfUkAMtHs+dtVSi8A3Ku/2cXI
	QND0btFc8vai1vVS5ubBuWikDh8B+ow=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so54996a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117286; x=1793722086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wk5sKJyk5V7wJVcqUwHINdY0qu+x+arRPxXrQCPNZAo=;
        b=Xpe+hRiqk7RiW0O/L5hBAs64xF2JYOYl213RjtZy3VuWfzPbNs/Xe4Bx1wqtcZyu0+
         KBMXb3s9ojGZQrhbj/4IewlgasG0R7lRRX9aj67Sj5FrRMdEB74wkddIXFZP9FPUNhVz
         pQFo32AVtl27Pp7/xjFx/sEx4njSv1rLLwX02FWtORpxliRJ+fxAdxhY2D/3VQ9EGWD7
         r90MpJuuKqWarB8lkeU4Bhz3tYjIZdR2lQ9GhUW3UABcw9jvoH0OsBdHRg2yB16DH7wL
         hPpyx/LzZ9vlKBMYdcqT1fKyNZb0PZqBsMg5PQVbajb9qv2SSppkHifEyPGusZLBhBlH
         seGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117286; x=1793722086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wk5sKJyk5V7wJVcqUwHINdY0qu+x+arRPxXrQCPNZAo=;
        b=GYmQHYFQhg95b6or/o/rzvrMX9y7pZtd+wz7STPyfD/S2rSFlZl0VC4PPqehkRuoqt
         RR4h8Uo53Phu0iWu2slb6v1P8ikoUFSUC8ZYUguaksX8aQOv9lNaYRJcWONT2AJkWLlM
         yrcD9utYzR4bHbAeCIAWmnrJVSUBnx3XzNMqHKX4EL6aKzulmLhOvzYpm+LFVJoIhCIx
         Q4EjUG7BlqXyQQIdlEY6koeIzlGMaOJ1FkJZPD4aOR1oUFIpMRl0AJuT5espvcRMmosg
         cR7tImxJ4yyhehlGDxfILet9ncF1sOd5IxWy8Xxc1OaRyXVCpymQq87GORxWXWi3POt2
         tKTw==
X-Gm-Message-State: AFq9FYIqnRqJY8f8Wuuix4vcOA32YUiAkzcBpejA7yvHbk/sybMvi88J
	B8i6N2pP2VJMxDkiyxz16+84LViu2/COYqQoypErGCmT+LcrqA3j/FqJq4UgOw==
X-Gm-Gg: AYBFou1Mhllztva9AhBRZtPEJBUBHup8dysS+ulRF6PkwlDuF3SeqGMGxkOIcZIC9xd
	UMYq7SWmrT+87J2llN4+3LmpD6wV/OdRl9Oslo/Bu6j1e4FQt6kndR1VSEhC22+7XN9WTdfKQWN
	P5nckOURzpxlMub9J3/hvwirPTUpszV0FDPZlYxOSAFgeqoNRYqgVY1+Ue2mA06oG3OQAmPhbIC
	4Z4g4+8CtaX43aRfHTGrCxloW+N4GRpgb6TCMENojsUu4ctnLmUmEN3g2Uv+Rp3HpgsvEkc6iFs
	DurT8Iyv4UANcH2AXt1SnBLRPCIzIfyhJD8oyb6Cpgbt6//HsrSYSy5fH1XNUfcm/ofuFl1Psd1
	2gg7Ire+rHRz7UiKILbL1bFpHYsb2DHhOmkAnb+1GyKx9T/Zd3MigLRRYNCbeZ8UruhyXL8M7/M
	hJjngAlpoTMsmaZVeRlZHQEyu+nRi2B0pSuC7eoMzdZY7ZGWoZRafAovfpZPwXYy5NPC5jPmOyP
	AL+EqL+6D+Gs0kn6TM+iJjZO6SG+Od25OsY99s6aD2FXX6AP3YSZ4waThISNjLc0b+imjwvWPKA
	AV2OKUQgCpbkf28yzGw=
X-Received: by 2002:a17:90b:5827:b0:3a8:32f2:f4a5 with SMTP id 98e67ed59e1d1-3adeae78010mr8643146a91.53.1793117286325;
        Tue, 27 Oct 2026 09:08:06 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4066cf2dsm4279314a91.16.2026.10.27.09.07.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:08:05 -0700 (PDT)
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
	linux-hardening@vger.kernel.org,
	Baoquan He <bhe@redhat.com>
Subject: [RFC PATCH v3 08/18] mm/swap: change back to use each swap device's percpu cluster
Date: Wed, 28 Oct 2026 00:07:41 +0800
Message-ID: <b4d13a9c14674803424b419645db039ce0a6c72a.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE0E4A000E
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: o4kjqg8zgahkzrodk6b6mqacroeacuau
X-HE-Tag: 1793117287-341726
X-HE-Meta: U2FsdGVkX1+QnLBbMIRes7DKBGEJTQWiPNidcdZi+7kWB3mZZ0jQLwcvo+xJqKKGqlxUCqI8mYdXuzHa8Z9jLozf9POu1bJcGzKNubEcHmD/Fvd1GlJG0cVu7z9fenDNh5QkcwK1jnJX83Ebh1guNrk+9MaL9orcTOnVZ30rIZgcWYe81B9I4xu4MJxcauj7mGShuMa+8LBVIeE6yJj8NF3Cs3+M12op0G4UyWsUHQty22Ig5t5S/Wt9R9lK1u+Hr2gT+I8lnz9lRxqUG5nvXqL/ZuXfjIJq1oR9neulQAUIUmHS3muqnLsfCZEk+5JFf3Gm8QGTcc1aLd6BLXjgvwhrDTKdYbb7n0Oi28US++uFx5+0s4WShf/y4WdiTOQB5uEhKqH88leepsDiRWV6KcF1hkv+YRfTtEZN7IhhT5q6Zocc7+zkwll4ctf137LSfGXpwrgNVNl0kMekPOQQz4yxJJ2LeWW/FqhxV41lOlRMtJDmPQoZ93sW4Lfc6VX+60Q0OodomWnMHiYUnavmfhtpoUnCdHCuBczC8at78jQV5YbBnnVB5OZP0StcBsj/6sUz6hWvm5y5LO+hW6moIABsbPl4KmC5G1ABnlpLWRndf4BKegjyfyB824CjITa9EYCr3yV6jYEerYtkrENWymb7wQ7G3Fwcc6L4U1o6sRM/peLnVZbPUIQJ30UDwbvVfCUcvtzv18Xk01B5qriJ969LfCAqr1vsjJE7rSF7bvaiTH7HLEJXQdf2s2xOCyrCJt9VFhMegfuA5EZcshROjdS8ctwjvkN0DEPdY9RG01WtXJyxL8Uf+rfp+68IEuhcMmuiCMaWAtD5Yf8jKE/oG/j60BtiFkQR5UnTQTvDgmHPqc10c+ak8mXSGm5lHN5Hjhm2QGHJ73fUegwHZTy56IfckBkRs9dRHW8BYqrKZb+1kxUrK4hkSL0LBfbdK/AE+1eAjHi/a1/NtFSq8hX
 zkul9Y2f
 c+srRHHdRGcL5pHmFgv6rH0pcZTcT3/1kK3Pze1lqG7uYgp1CbsrJbRqU4hG9cjLpLbvT66An6lqi/c3iZ3SYXXDvCEPzjLoxDjw8+cWggUwwc2o9nEAmqGKEmpWGHRAOaHXTis+YaNOuhSDCTa+4NQL8mMdB+AlUwg0Vze1OWmj817bkEawL2ltbpLRstAxrHCqhnerI2kmcSY3bAYGk9Jqi41EVMbkjb1FHANsUK9bV9kVVexBJ1aiq3e8yFYDjdKuurlWraPX7QUqyHzuFNbWgS/34bbTL1i4fcRJhA7ho4GfRXQHPtdiXbvzz2q4tlfZTTlTjylUyp9l/5Nq3A5AN3KPF60Qgu1KkMjCj7RbZF9HweNg+5zHBCIjXGsKYXbK9TaCuOKV3RH7XP4FjZmboriS+UywPUqC6GTw7jg0tSClt4cwV8U5awRQRwGmBe6jakslJORWUCEwKuxxlDcojWNZfmzpZ7Lb9e9/Edely7aRJywULrHE1bWORapHZeHvBbhiNzVaK8wqymszCib4Epd6P+hln4gh6SLK6OAeGhuBDb+bgREQGkw==
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
   above device selection, all allocation users must stick with the
   default allocation policy.  This fundamentally conflicts with
   incoming ideas like swap tiering.

2) It can cause priority inversion.  Consider two memcgs: memcg1 can
   access devices A and B, where A has higher priority; memcg2 can
   only access B.  Memcg2 can write the global percpu cluster with
   device B, then memcg1 takes B in the fast path even though
   higher-priority device A is not exhausted.

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
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  13 +++-
 mm/swapfile.c        | 170 ++++++++++++++-----------------------------
 2 files changed, 63 insertions(+), 120 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 80a14a8daba2..1a1ed9d11ad0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -239,10 +239,17 @@ enum {
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
 
@@ -265,8 +272,8 @@ struct swap_info_struct {
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
index c531e0c45073..2035513d3c61 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -146,18 +146,6 @@ static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
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
@@ -570,9 +558,10 @@ swap_cluster_populate(struct swap_info_struct *si,
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
 
 	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
@@ -585,9 +574,10 @@ swap_cluster_populate(struct swap_info_struct *si,
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
 
 	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
 					   GFP_KERNEL);
@@ -600,9 +590,10 @@ swap_cluster_populate(struct swap_info_struct *si,
 	 * could happen with ignoring the percpu cluster is fragmentation,
 	 * which is acceptable since this fallback and race is rare.
 	 */
-	local_lock(&percpu_swap_cluster.lock);
-	if (!(si->flags & SWP_SOLIDSTATE))
-		spin_lock(&si->global_cluster_lock);
+	if (si->flags & SWP_SOLIDSTATE)
+		local_lock(&si->percpu_cluster->lock);
+	else
+		spin_lock(&si->global_cluster->lock);
 	spin_lock(&ci->lock);
 
 	if (ret) {
@@ -708,7 +699,7 @@ static bool swap_do_scheduled_discard(struct swap_info_struct *si)
 		ci = list_first_entry(&si->discard_clusters, struct swap_cluster_info, list);
 		/*
 		 * Delete the cluster from list to prepare for discard, but keep
-		 * the CLUSTER_FLAG_DISCARD flag, percpu_swap_cluster could be
+		 * the CLUSTER_FLAG_DISCARD flag, there could be percpu_cluster
 		 * pointing to it, or ran into by relocate_cluster.
 		 */
 		list_del(&ci->list);
@@ -1040,12 +1031,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
 
@@ -1146,13 +1135,17 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1166,7 +1159,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-new_cluster:
 	/*
 	 * If the device need discard, prefer new cluster over nonfull
 	 * to spread out the writes.
@@ -1223,8 +1215,10 @@ new_cluster:
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
@@ -1377,41 +1371,8 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
 
@@ -1779,10 +1740,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	local_lock(&percpu_swap_cluster.lock);
-	if (!swap_alloc_fast(folio))
-		swap_alloc_slow(folio);
-	local_unlock(&percpu_swap_cluster.lock);
+	swap_alloc_entry(folio);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
@@ -2186,31 +2144,14 @@ out:
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
 
@@ -3188,27 +3129,6 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
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
@@ -3260,7 +3180,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	flush_work(&p->discard_work);
 	flush_work(&p->reclaim_work);
-	flush_percpu_swap_cluster(p);
 
 	destroy_swap_extents(p, p->swap_file);
 
@@ -3281,6 +3200,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
+	free_percpu(p->percpu_cluster);
+	p->percpu_cluster = NULL;
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3629,7 +3550,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	int err = -ENOMEM;
+	int cpu, err = -ENOMEM;
 	unsigned long i;
 
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
@@ -3639,13 +3560,26 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
@@ -3919,6 +3853,8 @@ free_swap_zswap:
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
+	free_percpu(si->percpu_cluster);
+	si->percpu_cluster = NULL;
 	kfree(si->global_cluster);
 	si->global_cluster = NULL;
 	inode = NULL;

