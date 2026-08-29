Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB5FC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D896B008A; Sat, 29 Aug 2026 03:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0055D6B009F; Sat, 29 Aug 2026 03:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36C66B00A0; Sat, 29 Aug 2026 03:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B653D6B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48C23A0640
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:37 +0000 (UTC)
X-FDA: 85153527354.29.86CFAD5
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8C98A40002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EPC4spol;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHvxeW8lAUpfJ18lPgBl3HLzf+AeoDV2A4HcxkONfAI=;
	b=OGP+zLhFXJnBqSrrbt0oRmJd8nECVBASmxTyKiJ2Wx41fR9BpVNhjQ44DZp+UbfVDbpgl1
	pfWlNKA7jzU+hz2JGCMP48umUkxTQr2zluKUWMAHbseTszCwEvi2NFUhLM9W6dwJQzx2KO
	NzGCA9CRgb8XRaUoUa3uE5LkE6f2vqE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EPC4spol;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989655;
	b=S7paQoe63EtjjzGclo/0Se6/tRmNM04tECauQUIga6c5TPria8EtFv9+khB4YivqYIILMr
	Oaq27nafsp6UHQqbhPlwH+ADx8l5qE+qtPXaTREXrtBR5KIDoG5Ujipvr74NBLX2WTFm49
	7EDNao4TJUIkycDzT9dEdBW+cYMt3dY=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-39675172593so1484440a91.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989654; x=1788594454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cHvxeW8lAUpfJ18lPgBl3HLzf+AeoDV2A4HcxkONfAI=;
        b=EPC4spolmTjnIMnFOOm2DIg6HH0W6Kqy0bJ0EgkfK+cU2MXrkDXuODTiabDwy6OgzG
         ujmar0+1fRV02r3dD6H1HjcYdJj4JNg2q4ANmUK+sA+Kd6hQhIsVbnqQieInZ9tsYaCJ
         gLxtGFYueMWzBhe1q3a+yN690MBoVrnpbV4DxEM+q6ojFq48NtVzPva0j9k99bGXybqO
         evhv5fZ9k+J5e2+ADHnr9cMj6IioSloRK2zIrAExn55mqESkoZm/8iPjVyfOfclM4AbS
         h203tVSc0hk7TAwWLcx/4it6j5Sc/iY8YLgbcMX1IZ1+L5kcAbHW1S26ygVjHxznOgiY
         IHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989654; x=1788594454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cHvxeW8lAUpfJ18lPgBl3HLzf+AeoDV2A4HcxkONfAI=;
        b=dUKP1gdcIXgPY9xD1hkeKNaw86E6MFrbTv6CpS9CEznbaGHJ8z1NHiuW7hGActn07w
         t8P1PVwM2n/ozjo25hd/PEA/tV7mpYDyzPe3jn48ulRAQNkD2KlmaMTHbA/+VjTz4U5y
         MDquqf5K+suiXGNuxRatm7lF5STqxloJhgaBrTTgaeruVeeTBGsFuLAMrPrAA7JUuIWv
         aLoBAcBVlW7h8z4GEd86YruDywqgtMdjpAkDLFLRc4te+mUN7s1HqqZPlgyX/wq0G5tJ
         /iYnPjBy8lJqmGyu7lzUYj+EP5j4NgP6rI0yeYvrI8Fz8auBgp9DNaWwOEJEv2dqlKoO
         llSg==
X-Gm-Message-State: AFuF++mts2Qdd2yNlAwnZPpfttR2LkO8/EaYcXrjwhZ6nJyswgeh9Ipu
	5OEc09xpAnGa8YJ5fUVlqThMUaP+gYzq+ndX5X2G4CCYHhtRblEb8kPFbnsuZw==
X-Gm-Gg: AYBFou3gD1acBDBNQBTOv+b1r16touA9/01WSIxnDrfB4aqlvmk9QYOJkO3wxQquuS3
	tVJeg0QD9O0EVDfjjDb9nN702TeW8/7OAZKppTT3cQJkTwA40olm+LHBvZ6i9l7lJ5XbasqxGu0
	FFmcSvyTJ1WDmIPB+Pl011qs7WD/e89udsUWIpWsuR7jHn1Bx1a0IEzAJRvHxkzTTBEEA0asFIv
	7hAWvScXAVz63LdN8Le1prsO9g4gwj/HN+kOtrjqnI+w/mQohkTdk5+HHTp4GqBUt4yQ2XCMbNz
	xBT5Ctf4np9+Z7w/pBfBZvwW6K6N1UDQKu/4AEUhDOTSkZHWLnf8avSQ6WatiV2/fvvqvq13nzs
	2ILzEqfPhKXbfEaIm3cpl2c9a93Wt7oN6oEXDSwi9BqH6xYHeX4H7ddo52N+gL5HBeyzyrNkj+O
	ZqyOgsQHDZeGAdl59ZE9ZxXVLOAzdXsKAEoTkowlmSToddal1UumhOcUFvKamdhPs5y0Q6WZfsp
	P/jxYkM5UHYfG3SWYr+ShoDoi+4
X-Received: by 2002:a17:90b:5108:b0:398:9c00:29ea with SMTP id 98e67ed59e1d1-3989c003c23mr7250051a91.18.1787989654371;
        Sat, 29 Aug 2026 00:47:34 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398bd356f80sm172493a91.9.2026.08.29.00.47.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:47:34 -0700 (PDT)
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
Subject: [RESEND RFC PATCH v2 05/13] mm/swap: change the swapon lock into a percpu rwsem
Date: Sat, 29 Aug 2026 15:47:26 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-5-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r6ghr6so5aim8ms6oddcb7edztk3h3ca
X-Rspamd-Queue-Id: 8C98A40002
X-HE-Tag: 1787989655-219123
X-HE-Meta: U2FsdGVkX1+cBnMBTh+Hi2uUvH2RVW5NdAm092hFva8LF20M6GFq9itTVFK2buU/5b24EzEYtdT4LPPp8RZxbF+L5uYZYBPM6+gBuTgxWwLWInCvUaLCtGPPcC3iswZJeO8AkHKHHHhx82ps26vMli2lzqbWOQU1VGgqVOd2AxNsBTfCOW8pVdnaO/q1r042aaREdeRGRBRIk0xE4uYhIKAhiQb3EFQRi3rqiazBAmzs/fbI4NYhbypFSXR1XhhK7AgVOHbtri4OkZeRoFgElpc4QsglUuQkQPASOKkJVTJRbmRP3KjGqjVXJNwsxTU4jbG09X4WQ4p0NWhu3MyMPnJPs6sssdx4JhuteG4yx+x9AeyxcVArvP7Z0kzWlN185Ve7N5XvWRaqam44lVJyJrKNLCw1lFHvMrlMtOxnVsn65W2y0SJ01W5BMum3N/W4ALSclM82LOJ0kbjX2uPsC8Zumq16ykAdDGBxqv4fgAZWQ8oPcZzmqKYxmasTC5aSL3Bd2bq0uWHxSgxAB79PBoDG1Rgx+ESIFjcpi/zQYe/xr+OkNxQPbiVn/yY1+nExzuQheU8XYujWuEs9+U+vAK5uZ1on8wKgEYHlFKP44iJyhiTY6TCnidurbCbXJs7SiIG+W3xzHciGLZaaFU2L2Hpr/JEjInMkJuXZSs7s6XoFEMeajhDtthQjonMR8KWmBM/W8orDF9Wa8/YqXHUfDYa8g/JAlyuZ8iA1MAAlNVjqMzU+AexZPtAjREtBmQZ7MVZmeDMkXdCN6d7+fN3MYlGy1jF76PNCur0WKKnAYqKTc6NKfWVtBz0kJqRt4Zn4FtwIJQai3M+RVze7f19w7/bdqNKbryH50+gtFXVzJJNV+5Nca0PiqPgiVzBbivpxKPUu9KAa90bCtmThifZ6TwDjGRj0WNReLDVrmQrUt+ox8gKuq3OH5+T3m7CNJdKm2b3R5LXCTOGVfFRmPnD
 5k7d5HYN
 K0EENIGLPfz9YnXFIDGqTS9JCG7thL9LCWzyUD0zD7G0S0eR3GdRZfcy4wMkkrh0J5usJraqSLR59gooTDf3EWPpt7ZmPbp/cDl5tCb2V22PkOcuOyLkDQuTWhWsJfo/zaAxna3jqAAazj7hTGx/LTzrzsLFXmpcB5QAI96GtedBEMuBBpbYAol2EuZRRkusHnT8kO+QdFt4CLYV+7vTocVSlu86XmhTh2V6RLINZcML3Y8n5rw/4OY7P+VGxN6pORAXSZCBnHEKt7f8y3gjRx7KhlmMXFmeHsv8tgtlEonXduugdRG12abuF4tHrRLIWofdVurPw8odjmHHHBBwTduPzxHjbcj6S0eqC9Qf+Q16hNQzB6umkkWr47sfgyr1AfGKuHx0n232uCEkLN2TtjiRyGvIsox5bnA6HZbFJ4HX0ze7ZcezTIna1P3TOVEF89j2lhjhEQW1Wqpl53SptmUBa4li44Pbmdobj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Reading swap metadata is a common hot path, while swapon and swapoff
are costly and very rare.  Convert the existing swap_lock spinlock
into a percpu rwsem so that readers can run concurrently without
contention.  This is a first step toward cleaning up the swap lock
model and we might already see a performance gain for existing
readers.

Also update the comments in swap_info_struct to reflect the lock
name change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/swap.h |  10 ++--
 mm/swapfile.c        | 115 +++++++++++++++++++++++--------------------
 2 files changed, 66 insertions(+), 59 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d9e535cd07c5..7b8ba0d1903f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -197,17 +197,17 @@ struct swap_extent {
 /*
  * Swap device flags, except the ones documented below, all are immutable
  * after exposed by swap_device_enable, and until the device is freed again
- * (SWP_USED unset). The exceptions:
- * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. Once
+ * (SWP_USED unset). The exceptions are all protected by swapon_rwsem:
+ * - SWP_USED: Protected by swapon_rwsem. Indicates the device is inuse. Once
  *   set, won't be cleared unless all reference to this device is freed and
  *   swapoff finished.
- * - SWP_WRITEOK: Protected by both swap_lock and swap_avail_lock, clearing
+ * - SWP_WRITEOK: Protected by both swapon_rwsem and swap_avail_lock, clearing
  *   this flag also waits for all current cluster lock users to exit so
  *   checking this flag while holding any of these locks ensures the device
  *   is safe to use at the moment. Note: clearing this flag doesn't affect
  *   pending IO or async requests, it only prevents further entry allocation
  *   or new async request (e.g. discard) from initiating.
- * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
+ * - SWP_HIBERNATION: Protected by swapon_rwsem. Indicates if the device
  *   is pinned for hibernation.
  */
 enum {
@@ -280,7 +280,7 @@ struct swap_info_struct {
 	spinlock_t lock;		/*
 					 * Protect cluster lists. Other fields
 					 * are only changed at swapon/swapoff,
-					 * so are protected by swap_lock.
+					 * so are protected by swapon_rwsem.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3847717f4d1d..173375a7a215 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -57,23 +57,29 @@ static void move_cluster(struct swap_info_struct *si,
 			 enum swap_cluster_flags new_flags);
 
 /*
- * Protects the swap_info array, and the SWP_USED flag. swap_info contains
- * lazily allocated & freed swap device info struts, and SWP_USED indicates
- * which device is used, ~SWP_USED devices and can be reused.
- *
- * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
+ * Serializes swapon/swapoff (writers) and protects the swap_info
+ * array, nr_swapfiles, total_swap_pages, and part of swap device
+ * info content (see comment of swap_info_struct).  Readers
+ * (allocation, /proc/swaps, etc.) take percpu_down_read() which
+ * is cheap as the hot path.
+ */
+DEFINE_STATIC_PERCPU_RWSEM(swapon_rwsem);
+/*
+ * swap_info contains lazily allocated swap device info structs, and
+ * SWP_USED indicates which device is used, ~SWP_USED devices can be
+ * reused. Protected by swapon_rwsem, but reading could be lockless.
  */
-static DEFINE_SPINLOCK(swap_lock);
+struct swap_info_struct *swap_info[MAX_SWAPFILES];
 static unsigned int nr_swapfiles;
-atomic_long_t nr_swap_pages;
+long total_swap_pages;
+
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
  * check to see if any swap space is available.
  */
+atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
-/* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
-long total_swap_pages;
 #define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
@@ -85,7 +91,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
 
 /*
  * all active swap_info_structs
- * protected with swap_lock, and ordered by priority.
+ * protected with swapon_rwsem, and ordered by priority.
  */
 static PLIST_HEAD(swap_active_head);
 
@@ -95,20 +101,18 @@ static PLIST_HEAD(swap_active_head);
  * This is used by folio_alloc_swap() instead of swap_active_head
  * because swap_active_head includes all swap_info_structs,
  * but folio_alloc_swap() doesn't need to look at full ones.
- * This uses its own lock instead of swap_lock because when a
+ * This uses its own lock instead of swapon_rwsem because when a
  * swap_info_struct changes between not-full/full, it needs to
  * add/remove itself to/from this list, but the swap_info_struct->lock
- * is held and the locking order requires swap_lock to be taken
+ * is held and the locking order requires swapon_rwsem to be taken
  * before any swap_info_struct->lock.
  */
 static PLIST_HEAD(swap_avail_head);
 static DEFINE_SPINLOCK(swap_avail_lock);
 
-struct swap_info_struct *swap_info[MAX_SWAPFILES];
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
-	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swapon_rwsem);
 	while (*i < nr_swapfiles) {
 		struct swap_info_struct *si = __swap_type_to_info(*i);
 
@@ -128,7 +132,7 @@ static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
  * for_each_swap - iterate through all allocated and inuse swap devices
  * @si: the iterator
  *
- * Context: The caller must hold swap_lock. The lock may be dropped during
+ * Context: The caller must hold swapon_rwsem. The lock may be dropped during
  * the loop body but must be re-acquired before the next iteration.
  */
 #define for_each_swap(si) __for_each_swap(si, SWP_USED)
@@ -1371,10 +1375,10 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	/*
 	 * Guarantee the si->users are checked before accessing other
 	 * fields of swap_info_struct, and si->flags (SWP_WRITEOK) is
-	 * up to dated.
+	 * up to date.
 	 *
-	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * swap_device_enable(), and smp_wmb() in swapoff.
+	 * Paired with percpu_up_write() in swap_device_enable(), and
+	 * smp_wmb() after clearing SWP_WRITEOK in swapoff.
 	 */
 	smp_rmb();
 	return true;
@@ -1459,10 +1463,10 @@ static bool swap_sync_discard(void)
 	bool ret = false;
 	struct swap_info_struct *si, *next;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
-		spin_unlock(&swap_lock);
+		percpu_up_read(&swapon_rwsem);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
 				ret = swap_do_scheduled_discard(si);
@@ -1471,11 +1475,11 @@ static bool swap_sync_discard(void)
 		if (ret)
 			return true;
 
-		spin_lock(&swap_lock);
+		percpu_down_read(&swapon_rwsem);
 		if (plist_node_empty(&next->list))
 			goto start_over;
 	}
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 
 	return false;
 }
@@ -2275,7 +2279,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	int ret;
 	struct swap_info_struct *si;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	ret = __find_hibernation_swap_type(device, offset);
 	if (ret < 0)
 		goto out;
@@ -2299,7 +2303,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	si->flags |= SWP_HIBERNATION;
 
 out:
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	return ret;
 }
 
@@ -2317,11 +2321,11 @@ void unpin_hibernation_swap_type(int type)
 {
 	struct swap_info_struct *si;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	si = swap_type_to_info(type);
 	if (si)
 		si->flags &= ~SWP_HIBERNATION;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 }
 
 /**
@@ -2346,9 +2350,9 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 {
 	int type;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	type = __find_hibernation_swap_type(device, offset);
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 
 	return type;
 }
@@ -2358,13 +2362,13 @@ int find_first_swap(dev_t *device)
 	int ret = -ENODEV;
 	struct swap_info_struct *si;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	for_each_avail_swap(si) {
 		*device = si->bdev->bd_dev;
 		ret = si->type;
 		break;
 	}
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 	return ret;
 }
 
@@ -2393,7 +2397,7 @@ unsigned int count_swap_pages(int type, int free)
 {
 	unsigned int n = 0;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	if ((unsigned int)type < nr_swapfiles) {
 		struct swap_info_struct *sis = swap_info[type];
 
@@ -2405,7 +2409,7 @@ unsigned int count_swap_pages(int type, int free)
 		}
 		spin_unlock(&sis->lock);
 	}
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 	return n;
 }
 #endif /* CONFIG_HIBERNATION */
@@ -2717,10 +2721,10 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	unsigned long swp_tb;
 
 	/*
-	 * No need for swap_lock here: we're just looking
+	 * No need for swapon_rwsem here: we're just looking
 	 * for whether an entry is in use, not modifying it; false
 	 * hits are okay, and sys_swapoff() has already prevented new
-	 * allocations from this area (while holding swap_lock).
+	 * allocations from this area (while holding swapon_rwsem).
 	 */
 	for (i = prev + 1; i < si->max; i++) {
 		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
@@ -2841,8 +2845,8 @@ static int try_to_unuse(unsigned int type)
 
 /*
  * After a successful try_to_unuse, if no swap is now in use, we know
- * we can empty the mmlist.  swap_lock must be held on entry and exit.
- * Note that mmlist_lock nests inside swap_lock, and an mm must be
+ * we can empty the mmlist. swapon_rwsem must be held on entry and exit.
+ * Note that mmlist_lock nests inside swapon_rwsem, and an mm must be
  * added to the mmlist just after page_duplicate - before would be racy.
  */
 static void drain_mmlist(void)
@@ -2994,8 +2998,7 @@ static int setup_swap_extents(struct swap_info_struct *sis,
  */
 static void swap_device_enable(struct swap_info_struct *si)
 {
-	spin_lock(&swap_lock);
-
+	percpu_down_write(&swapon_rwsem);
 	spin_lock(&swap_avail_lock);
 	si->flags |= SWP_WRITEOK;
 	spin_unlock(&swap_avail_lock);
@@ -3003,7 +3006,7 @@ static void swap_device_enable(struct swap_info_struct *si)
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 
 	add_to_avail_list(si);
 }
@@ -3016,7 +3019,7 @@ static int swap_device_disable(struct address_space *mapping,
 	unsigned long offset, end;
 	int err = -EINVAL;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if ((si->flags & SWP_WRITEOK) &&
 		    si->swap_file->f_mapping == mapping) {
@@ -3051,14 +3054,14 @@ static int swap_device_disable(struct address_space *mapping,
 
 	end = ALIGN(si->max, SWAPFILE_CLUSTER);
 unlock:
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	if (err)
 		return err;
 
 	del_from_avail_list(si, true);
 
 	/*
-	 * The swap allocator doesn't take swap_lock. Looping through every
+	 * The swap allocator doesn't take swapon_rwsem. Looping through every
 	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
 	 * the updated flag and that no allocation remains in flight.
 	 */
@@ -3172,7 +3175,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
 
@@ -3183,7 +3186,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
@@ -3202,10 +3205,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	 * Clear the SWP_USED flag after all resources are freed so that swapon
 	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
 	 * not hold p->lock after we cleared its SWP_WRITEOK.
+	 *
+	 * The write lock ensures the flag clear is visible to lockless
+	 * readers of swap_type_to_info() before alloc_swap_info() reuses
+	 * this slot.
 	 */
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	p->flags = 0;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
@@ -3365,13 +3372,13 @@ static struct swap_info_struct *alloc_swap_info(void)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	for (type = 0; type < nr_swapfiles; type++) {
 		if (!(swap_info[type]->flags & SWP_USED))
 			break;
 	}
 	if (type >= MAX_SWAPFILES) {
-		spin_unlock(&swap_lock);
+		percpu_up_write(&swapon_rwsem);
 		percpu_ref_exit(&p->users);
 		kvfree(p);
 		return ERR_PTR(-EPERM);
@@ -3396,7 +3403,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	plist_node_init(&p->list, 0);
 	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	if (defer) {
 		percpu_ref_exit(&defer->users);
 		kvfree(defer);
@@ -3829,9 +3836,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.
 	 */
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	si->flags = 0;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)
@@ -3849,14 +3856,14 @@ void si_swapinfo(struct sysinfo *val)
 	struct swap_info_struct *si;
 	unsigned long nr_to_be_unused = 0;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	for_each_swap(si) {
 		if (!(si->flags & SWP_WRITEOK))
 			nr_to_be_unused += swap_usage_in_pages(si);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
 	val->totalswap = total_swap_pages + nr_to_be_unused;
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 }
 
 /*
-- 
2.55.0


