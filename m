Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397DF606A329
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oysgkm+n
Received: by kanga.kvack.org (Postfix)
	id 33AE86B081D; Tue, 27 Oct 2026 12:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312A96B081F; Tue, 27 Oct 2026 12:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200E06B0820; Tue, 27 Oct 2026 12:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F19526B081D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:11:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96AE3A77D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:11:40 +0000 (UTC)
X-FDA: 85368896760.02.B1EAA69
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3F56140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:11:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oysgkm+n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcQvxtAuURaL5AWAfjg2aSch6uIdfFR8kJ2WNXGe70s=;
	b=sVS2ZzYEPlHhVOHV1A36J5DSdlRvAPQ4YOwj6J55vHWPPnOemQGdpdwsxBB/Fudu6KjtUq
	Xgm/KnnEP9q8hahAYRG2+2fyh2XurU1rB/aU3Xh3tLUzmrMxZ+2BExJHxv/PKZ/ZOzTnC6
	5ODCRwHk6AhEkfCXaVsif6D3VbDY26M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oysgkm+n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117498;
	b=7Tqg43gDbp+drsEe1LwSA0SUqzY9HyuNeC/xESEuA2bbPg/xraN8+Z9PwT6PPwcNUhai90
	wIvMJdm83afQBW6ZUvcF59Y1SWkNJHO2ehe5B53tH9SLs8T2zueMn80Dg0k3nLqq5eSB/c
	AlW+8QWLzWblXjxVKK0cwkPy3nR9RBs=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso93728a12.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117498; x=1793722298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IcQvxtAuURaL5AWAfjg2aSch6uIdfFR8kJ2WNXGe70s=;
        b=oysgkm+n/PX2WyioFolWoKpLSDAaN1GBhzK8p5ieOGCDD4bjHLmCbJoVFpGMcCuNld
         aTX2LJUr9nuXpxNDgjfPMD48n0H0T2LanteBstAOaQLJKDnx/pzeHPzJttS3JYYC1q51
         GV/4PJOfCdfjOEdFxWnq9U21wFrmSvmtS2YO5fR6cPFYLRZMbK211tS7Jq7EJzGd5L1P
         C0HFzd/Z8xZ/zmtxKuOTE0x++grrWfrzw4nbm2JnkH4aBKOKq2bcs9M8i6lbmUp4V17B
         d02PYSYgCQ3Ys2yI2n/1n7XQ4UdEhCH3DKv1aFCKVy6boTDXIZs5v0tSC5PjJ9d8A9je
         W7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117498; x=1793722298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IcQvxtAuURaL5AWAfjg2aSch6uIdfFR8kJ2WNXGe70s=;
        b=2BCbcylMxtqRqhK9k7CvEuPiM7W1Lb5sCckw5s9InjOvkZnJR+gAnrRiZkI1rFPZlE
         abEScuO9ARrmJvsizlMrjyEHFhvQZrnx3FnKIgw30p9413986j0rQdeMxWC9dHggdPAo
         x5vrKULTeEw9RlzFovFMvbid+7sFnJoZvcDJynKVHrLOFC5EZdb1lvgmiJKMY2Z5eZ44
         Vb7bBT8BJFjRtJy+GRxiLPrYvXsNDc4WQrZDdeVWiGAJsutr20wjsJTCaW6KKhYYWn1h
         +li3ktC7VTVOwCOGb4UmEVQ2wmmRBd6TLLxYPDakhBHj39nay+dyCNAnwLOELF3Bvh4V
         biIw==
X-Gm-Message-State: AFq9FYIsupBz0Ly7lSEHjGbV/rAdB4jOUr84t6z0oOcr2W7aKHjEZdNF
	7OfOcLGWYkAkSmsaZD1AAoSRH7bLKSEqGSGBENpyfk8vEYIEBR9nztZLFgvF5A==
X-Gm-Gg: AYBFou3JStrP7U347ITO+wlsptzPitIYvVbBks3LIiHx0pSPEkbL/17Mh/JhFsg9o2o
	XlUjPjiU7z0pYeo+Z9n2YlF39oFCkfBawrUqWHyV+8qdQeSNJLoWiYr5Ucx0z+aBXIt84EEr4CY
	5feJj0/qvfQhIKi9aP6S1aQSy7PbKkgaA2qDonLyfsC//DToW6YoreT7KOzwnau9pxa+7Sqj0/p
	KTG7Wspr7Gh5j2U1ibQphDB7bK4soH/XP7Iaa1JLmxm2Tmsodr1J5W5zpsgOyQ4NDpujn8l+P3s
	OiN2DUaeRHc3nnSF+6wtb0CRTukwLXoaGU2xlw9AVogm/H0cJbe7RkH5Ql88otOr7WHNEY/1Jc+
	KhlqiIXIpJidYl3UKBo/9F8KDPcKBVF3K6E0/FPbNyVfOBgTWuBRI2ZdMyqBCo/W1NdY9ylVjc2
	fQ3DMFqZje1GPrZbUHOA8udjHMxZW4L4walCDKkns9aWbP3gZa8erBysF6yCmAdkB/jLOyBcA54
	RyUm739rqg8ZvtY3xDs1aK5rt515tsCUWID69odm5YY2nfa1VkYh6Q3fgUuOJENYm9iWVIU0O8v
	atOqXg6othgnhg+cgHQ=
X-Received: by 2002:a17:90b:3bc7:b0:3a4:ca46:8d44 with SMTP id 98e67ed59e1d1-3adead5841amr8687511a91.18.1793117497589;
        Tue, 27 Oct 2026 09:11:37 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeb83b408sm8706780a91.0.2026.10.27.09.11.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:11:37 -0700 (PDT)
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
Subject: [RFC PATCH v3 13/18] mm/swap: drop swap active plist
Date: Wed, 28 Oct 2026 00:11:14 +0800
Message-ID: <2ef61349ebae2f178e5dafff2ac31d80ade23ac3.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3F56140002
X-Stat-Signature: phhkwwibz3xwn3db3dzmexckdgafpxse
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793117498-879054
X-HE-Meta: U2FsdGVkX19kwi2Vrm9LgIWj2lkRmu8Hprd1D9X+IV6o9F1XG0xkZapBSFERUUVgscdqPzEMJM0w5EibAb7vO4qavDlwXhHsmikxRp8lK2cV6XcygB150gNT2/pO8xMQ/B9di9lCczWmfNHMVhwG4Ob6zH5H3OxnWl3WCmtOw05MRZ6fUUeKzibyqlzJ0r1yaKAJuekXPPOLLRFK0Cnu9c1mSVArtFm556QLrw46BQLRLvQtLERVMiJChkgiYnR4kbAl27ki2SnLPZXKhfVxw17IE6yxaxts6VaIxbT/po7yHgo4C6IrYJ3hXj9+dl/82cTWfZ/w99+5WzhaNeWB2knZ2u5eHhu8aHb5I8RGwxz9Lby91fFkyHckhREpUXAEKg0immplZPszMyvsv07rzV2OiEUqjiUIjyk2mmR4eTzFPmHEelk6aAZ83slPLORbmYw9jtN3jWBsLfnmla0QeTYDUHrWx7UdbYWKtOzNDCKvXVtgsML6rQhZIFMdUnPm3mrPlRg1GT9KPhjN2HKNEim1iGByZd/AH0+zOpMXtsLigl5V9qJFwbaNarHlvbo9xUHh0Yej6iXLFhMysIySsIvHBT9DC4vVTq+qdvQrLL/NMenQvHRV1qZWYXXp7bciuy39palGDwQosECCFG8q/j9OvUHlMQnzliSNvZFIE4yQs9GMd5knWV6ZXUNqmKuK1DaXkmInChbGULtM838rcIBuDXYN3KngUuQgFuEUPLTI3gSYvXJNHdKpufBMTKwVeyWstVixjkZl09xMMIMT5koQReLXrtMQJLft2T/CJoQWDKzyPGJmKSVEnzaFfz8z8Xi3iuS1QbLxyshWt0q3OIF+vC7jpeWtzsydIQrJAvAbUxrnxGXKH+XDvpnOF6VHNZRB2OE1tAktNj6Rz0JiVhc4lDhYBgLHPja3xefHkXN+MAK9OZ2kZPVDArre7641t1lkiU3T07l39ZZS49K
 aJZxtnty
 2OOmBs/d0uXI6GRVJSVq/BznTLbSmvmbPjHAFAExKTenKvrA9ed2ww4KLcLiJ0VGFAgbhkE5dvS+a16eO+ehmlxlXSF6LNNEXd5i8DPUvWDzlDI1hwXL9I3ZsCix422hB4WaBOe9A8TD5U+paM9nsWnzVQ5bM1ecBSBnSrGO+VQWEoVeNOiFYFndkyaE8LtVYuWXCn7wDFt2HXH1u0xYoU6oyYSwn3cp1qVyXpLXARCN73mkeFlZEjgYTGMisFQVrBcCwE6sEUi6ahmrVXuqlxuZLypPaVKFve3SVtjKTvwQoui5f8VnLR+3GMuphIPK52rjw8kD3OT1zA1uwvpVNou1I99rTRh8eZ9S9QJRZmcl+XVT2S9bwB0/h8I5lt/M/Hhc7C+HLNoVxQqBhuopkvR3/v21Mxkjq9OmaAMbF55CU2nqVJQwDcaew5OOX6CDcKq1oMwF4QFbci2sA0HdsdGg/ZAvN2eKCM9ewqVP/za8UBbS236CToEvAmBk1gG2XncMm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Remove swap_active_head and the associated plist_node. Device identity
lookups can use the writable swap_info iterator without ordering.

Keep priority ordering for the block-cgroup swap throttle target by
walking the priority queue under the topology reader. Choose the first
unmasked, writable, non-offlist device with a backing block device.
Check WRITEOK and OFFLIST as well as the pointer tag because disable
and full transitions can temporarily leave an unmasked entry.

This read-only lookup does not consume per-CPU allocation quotas or
change retry cursors. It avoids making the throttle disk depend on
swapon's swap-type assignment order when devices have different
priorities.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 59 ++++++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 17b8ec654ee2..bfca46e1fbc6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -261,7 +261,6 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5c26682c0bab..7b3520ce1e41 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -41,7 +41,6 @@
 #include <linux/completion.h>
 #include <linux/suspend.h>
 #include <linux/zswap.h>
-#include <linux/plist.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -90,12 +89,6 @@ bool swap_migration_ad_supported;
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 
-/*
- * all active swap_info_structs
- * protected with swapon_rwsem, and ordered by priority.
- */
-static PLIST_HEAD(swap_active_head);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -3423,7 +3416,6 @@ static void __swap_device_enable(struct swap_info_struct *si)
 	spin_unlock(&swap_queue_update_lock);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
-	plist_add(&si->list, &swap_active_head);
 	add_to_avail_list(si);
 }
 
@@ -3443,9 +3435,8 @@ static int swap_device_disable(struct address_space *mapping,
 	int err = -EINVAL;
 
 	percpu_down_write(&swapon_rwsem);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if ((si->flags & SWP_WRITEOK) &&
-		    si->swap_file->f_mapping == mapping) {
+	for_each_avail_swap(si) {
+		if (si->swap_file->f_mapping == mapping) {
 			err = 0;
 			break;
 		}
@@ -3470,7 +3461,6 @@ static int swap_device_disable(struct address_space *mapping,
 	spin_lock(&swap_queue_update_lock);
 	si->flags &= ~SWP_WRITEOK;
 	spin_unlock(&swap_queue_update_lock);
-	plist_del(&si->list, &swap_active_head);
 	total_swap_pages -= si->pages;
 	atomic_long_sub(si->pages, &nr_swap_pages);
 
@@ -3801,7 +3791,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 		 */
 	}
 	p->swap_extent_root = RB_ROOT;
-	plist_node_init(&p->list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4211,12 +4200,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
-	/*
-	 * The plist prio is negated because plist ordering is
-	 * low-to-high, while swap ordering is high-to-low
-	 */
 	si->prio = prio;
-	si->list.prio = -si->prio;
 
 	/*
 	 * Publish swap_file before making the percpu ref live, then add the device
@@ -4342,7 +4326,33 @@ int swap_dup_entry_direct(swp_entry_t entry)
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static bool __has_usable_swap(void)
 {
-	return !plist_head_empty(&swap_active_head);
+	return READ_ONCE(total_swap_pages) > 0;
+}
+
+static struct swap_info_struct *swap_queue_first_usable_bdev(void)
+{
+	struct swap_prio_ring *ring;
+	struct swap_info_struct *si;
+	unsigned int ring_idx, dev_idx;
+
+	lockdep_assert_held(&swapon_rwsem);
+	for (ring_idx = 0; ring_idx < swap_queue_len; ring_idx++) {
+		ring = swap_queue[ring_idx];
+		for (dev_idx = 0; dev_idx < ring->size; dev_idx++) {
+			si = READ_ONCE(ring->dev[dev_idx]);
+			if (swap_device_masked(si))
+				continue;
+			si = swap_device_unmask_ptr(si);
+			if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+				continue;
+			if (atomic_long_read(&si->inuse_pages) &
+			    SWAP_USAGE_OFFLIST_BIT)
+				continue;
+			if (si->bdev)
+				return si;
+		}
+	}
+	return NULL;
 }
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
@@ -4366,14 +4376,9 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	percpu_down_read(&swapon_rwsem);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if ((si->flags & SWP_WRITEOK) &&
-		    !(atomic_long_read(&si->inuse_pages) &
-		      SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
-			blkcg_schedule_throttle(si->bdev->bd_disk, true);
-			break;
-		}
-	}
+	si = swap_queue_first_usable_bdev();
+	if (si)
+		blkcg_schedule_throttle(si->bdev->bd_disk, true);
 	percpu_up_read(&swapon_rwsem);
 }
 #endif

