Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9FEC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510A86B00A6; Sat, 29 Aug 2026 03:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1F96B00A7; Sat, 29 Aug 2026 03:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7556B00A9; Sat, 29 Aug 2026 03:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1802E6B00A6
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B06F016062A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:22 +0000 (UTC)
X-FDA: 85153529244.19.A59E26F
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0008B16000A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jT7fs1iS;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989701;
	b=wPIK5YUxPpv3t9WE2pizKS0Uwd5d9mvHK2E87ceCNJgg3uMBubWBr9kdG7BfwWNNKqRZQW
	hmaXZNJI3g1GUj+/blMG46RCbVJJ+sz0r61Cqrk2+sou7oZQjdF2uXnV9j8NKwHCwOudCP
	eNb7N2ndiK0uU8DYqucIe/P4U9e3xvQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jT7fs1iS;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQpy6R10A7XgwYtm9Mv+zsa+EQTNg+ZbkFt80LhBXZk=;
	b=o3SBorQKJ0CERIJCd8jFt54hkamuzUnmcDrShszXPDZUq6uWJXwwGIreZpVqZbHX0ohnZI
	JZZpxQCTdPKeJqo+25NTJRz5UdCzT3BoCbhBIVb2L815YrbfWincBfOLNg/ZPEd9lujl2N
	iYcVKEvSvWwJwr/cjsTuFvdoqb3HpmU=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d58efc7356so20789225ad.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989700; x=1788594500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fQpy6R10A7XgwYtm9Mv+zsa+EQTNg+ZbkFt80LhBXZk=;
        b=jT7fs1iSOmVePLSakR22ijYCWRUHXHvDMzQM+eGlpkTgD1yxyHsrr0cJ7OX1U+G3RC
         XANyVvvL2sroWOZSVie+uowqiIGOI7sayai2smrZGZgL+o75Z137WtXPE/jJviEoPtgz
         8Z9hXGln0RbW0wiDVmLwTdcePkHPR9t0Ooi9s/ZTpYPt0uRpfuqxvS8tHNBWJXw1+ydt
         Z/6+dmPwjQXV9zxSji3ICSSUIe5QsZsY0AHwv0uOWX93Ri5C+jtOuX3wa+fH1YUpeTxZ
         KzisDpooHmWcwd0P9qecQ7j7Cso3qKvUYkM9itp+/McWuG0aW1qgSC3jkoSPBowz/MhS
         xYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989700; x=1788594500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fQpy6R10A7XgwYtm9Mv+zsa+EQTNg+ZbkFt80LhBXZk=;
        b=cWkd6wtFz46RReDOUbH0KM0IpuTf3oo7VZKk9YvGmoB47cHDWTs0s2Ya7ZDb18q344
         oV3Vgq4FmJndMpx4DvR1dqS1A2KOQcDu2rd1MaOD9kQTsXtbKF3YtwNfvo3ZSDuS1pBl
         NWJCUvvwcyJH/sX9kOlqjnjOCPrm/QaZZTLEwVSXNIDGw88eGMKQOj4penRalXFSkfoP
         IQAE/dMHpvesDAs4z96/zmtrNE/4bab9+wzWFEjD3z+vVGtthAMCH0GO68lH7cWsYkYn
         4MrOHqPYGRMyt2P/auHabsN863+UbhBk4Dnuzk1zMl/G6jJtePaixGdmCgqy6wJVWMPq
         Ki+w==
X-Gm-Message-State: AFuF++nAXfyxwW0oDMFhuRx1qzndRQ+Het7okKsRiUBBGXFXmtq76jFs
	wNnDh6z96W+yqJFRJSMldAQkjLFDKPz1ImCSJChHLRjZJuW7dB/Y00HB2qKD/w==
X-Gm-Gg: AYBFou0mT/MWqzbjrxahWWcQjkInfzVHE6WoBgCWoQ1DedZiyxcGHtA1XYfntEg3gin
	usgE29p1m/t1beslzh+9thu4UpWRMMbN1Io0Gno5I4RGaq+e8qPCgtLOU4IXDfcwEFJLxun2nMB
	lMpRuCE4jIK2McTyjw7jpzmsVZOG39rDGAC2Yc8mz3TRI0U4ys+0IkekVd5AsANKb3sf6y4fg1/
	N729p4H5eDE3+82Oqb9odl4zw/ICPTg4oFDVAs9OAkabh6/rleVHeBiTBgI9QjMP0mAIlJk5Vi4
	4uwCKsI+n8KKb4tVMO4Vu+mOKSAworj95rswTaWRNmwOsJ3Xl9LqtxjyPZSDcs5UjohXdsWYmKl
	zlRwVMQn85FB0pZzQpp4w+jaOLQdqUjnDQMg+P39Fq67Fc1/cUg2ivbw3C91+kBSdEK9lxmLYd6
	bP/Do2C+WVZnvcNwLRj93T44Px58aBQX3vlDI14ysTSvssqwpfVZH0sufT+CtemcPD5yPTObasE
	Z/iXeMSlQYhPYLbt2q90VjXkWc9Ug==
X-Received: by 2002:a17:90a:4ca6:b0:398:bd66:35f5 with SMTP id 98e67ed59e1d1-398bd66372fmr151113a91.25.1787989699843;
        Sat, 29 Aug 2026 00:48:19 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda7c922sm6117862a91.7.2026.08.29.00.48.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:48:19 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
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
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 10/13] mm/swap: remove available list
Date: Sat, 29 Aug 2026 15:48:12 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-10-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0008B16000A
X-Stat-Signature: gpe4yrxpep496ofcgji8fgztsez85jie
X-Rspam-User: 
X-HE-Tag: 1787989700-29700
X-HE-Meta: U2FsdGVkX1/Y0+aFtVTgoWTAKyJLLjecqjIFCgebFB45nJKjp7GyFc0E1/48i+aBwd+mEd6eD4zmpuyVbH7hkLq1/fIMQTYZ9o/LCjxwqQERlgRTkoY7aDVyotdLBUB6HCsiczWunLrSsCYoFAQhMgsnNJdUi0zV89tUE8TL/UIPt5rvLqCr0s7MIjsEHCfEdwahVZqexWVGtsESLKjWsl8f1IwdXEeL6au9yc0bHmIzMv2k2gsuRoMPyp/y2iDTjDU6cTincGmbGkyx1oMi1fd4I2YX8DnKFvaKGl6yCprltbFVHEMuresX8ktWh3YdHGHkp4mu06fw/3th5XqXEUk8dDO0oLK4s9BzilCv+ztSr4/SSM0UDwendEoFMvFUmzKbGhqXs21f0hIaktwwXzU93J+KcdlgKM+KjSeMz+aGXESOD23G6/TE3ANOiqPk4fLj1eHt8/ak2+85blryjhZym7CaepEFpSwHFK+d5bXpfIb0Xceoag6J6TtZ7LauZG2q1Hpxv0O/9cdjOfrMigEN9MpxJrjgPCU/Cs847hPNPWKCYkl5HYnp/mwisgKu87QUvUt/H8lpuD+S12aC8xkLjsInfIqSX4MuW5fJb7y+gAD6XOFX46lMRRGiIuP8dkX5tEKPCArQPL/ZUM0YihtThmohTIHaI6poQqLfoh0Iu5uhuq6QuNd8ySAKO26cOmIBpM5Hucp1BBH3WQWRtTfx+d7SuYh9YW/GDKIvyYqEW0mKdF3OOCerHkVegkZvcycNNyJS0iojsgeGQBiWuIENAREb+09JhiWC2aJBpHk0evcWbNut6eiEwm+ghtatvLzKM4pwM6d/wPl/Lx/9kwXbQqu93VlQssfdFrUA1Bgzh1GuaVOiO+Yjhk8+NeeM9b87ryXchSHSihRJ/eJH84oRz5vMh7R0aQb3DeWNIIG9HFGqr7YS5icZZcoIn3vATEF1NvAOjCxA74XiW6Q
 V4cQqWF0
 Nhq3ed+gpOu2eq4m1VHz3Rsn28ro90obJcc+Vg9bwfQRZQeCEwELRgEG3gEusrewJ1a21/xxl749SGXwc7Wq6PgpB4BSqjaI98nrWZaez9IgCGZnU0AknhibWnLnnvFu6FAXHU+dyhF6kWdnncYKDb9bR/PqkB7oXL/v7iAxcuQ+n1b9VlvTrvvs5PPiIZGHx12ymu3guTa/nGnTPHiT0+oyTdaLsxh+U65u3+4PJTs8EvY3bOihG7eSW0rT4sjjQzgbLV2edGbi42qC8qUVnrFZxsBbkLOGB4OkZfuFtFfkEy6UWA1NltIr0ZHSAKUcTP93wo19BddCvuFrmO538I3V7cRHzocD+We5Occ+Z0ptuRWrBbml2t02O4ZqITZsIbPhiI51kfd9JkAPKiwY5aqPUWK/BHp/dNKpmIc/mR4dG06aMJOb8/1FcSMiVIhKQcO9Hdoa//rLcmiFVOoeJ/wxCv04eJWCx1Mz+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Pure cleanup, no functional change.

After the priority queue replaced the allocator's device selection,
swap_avail_head and swap_avail_lock are no longer used. Remove them.

The throttle path now walks swap_active_head under swapon_rwsem.
Check SWP_WRITEOK and the existing off-list state. This preserves the old
priority ordering and does not select a full swap device.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 33 ++++++---------------------------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 37fe2e4d2774..0c8c1ebcab9c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -293,7 +293,6 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1b7bc968b5f7..e183dfad264e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -96,21 +96,6 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  */
 static PLIST_HEAD(swap_active_head);
 
-/*
- * all available (active, not full) swap_info_structs
- * protected with swap_avail_lock, ordered by priority.
- * This is used by folio_alloc_swap() instead of swap_active_head
- * because swap_active_head includes all swap_info_structs,
- * but folio_alloc_swap() doesn't need to look at full ones.
- * This uses its own lock instead of swapon_rwsem because when a
- * swap_info_struct changes between not-full/full, it needs to
- * add/remove itself to/from this list, but the swap_info_struct->lock
- * is held and the locking order requires swapon_rwsem to be taken
- * before any swap_info_struct->lock.
- */
-static PLIST_HEAD(swap_avail_head);
-static DEFINE_SPINLOCK(swap_avail_lock);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -1583,7 +1568,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1603,10 +1587,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 	}
 
 	swap_queue_mask(si);
-	plist_del(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
@@ -1615,7 +1597,6 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	long val;
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1646,10 +1627,8 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	}
 
 	swap_queue_unmask(si);
-	plist_add(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /*
@@ -3684,7 +3663,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4099,7 +4077,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 */
 	si->prio = prio;
 	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
 
 	/*
 	 * Publish swap_file before making the percpu ref live, then add the device
@@ -4243,14 +4220,16 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 	if (current->throttle_disk)
 		return;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry(si, &swap_avail_head, avail_list) {
-		if (si->bdev) {
+	percpu_down_read(&swapon_rwsem);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    !(atomic_long_read(&si->inuse_pages) &
+		      SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
 		}
 	}
-	spin_unlock(&swap_avail_lock);
+	percpu_up_read(&swapon_rwsem);
 }
 #endif
 
-- 
2.55.0


