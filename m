Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20B2CD4F48
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B076B0088; Mon, 18 May 2026 03:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F28F6B008C; Mon, 18 May 2026 03:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E17A6B0092; Mon, 18 May 2026 03:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01C836B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:35:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDB478EEE2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:35:04 +0000 (UTC)
X-FDA: 84779729328.03.9558EB2
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E90BC0016
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:35:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779089703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IU+/YzJrnoflpTGPuD1FM9/pv9BoeC1hQ+/UaQ/53II=;
	b=g/nRicsaeyJYaYVv7LiwjrygNImhzsy7HSt7RbZi800rzeJmDJEQy1ijsY4/zYq/r2PvpO
	IeWveAJL9uTvGVLzW87fuxAk4Ih9mTOeklQGh24DbH0KJNpi1MyNdUAKqjeJ8xF2wrK7nS
	bTLLAdsdA34YJp7+6lsTn3ofNhhUK18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779089703; a=rsa-sha256;
	cv=none;
	b=z5Y7Y0bhQ5Hl+ad5533UkKyhhFtCV0Hv0yOvWUSqoRAmrLu5p8V52hmokOkRi1gdjSmSs2
	pHwzeKhyBaXvhLA1ci1HhGB5W1gb4mlf178c8oHDw+SCtr4EaA8s6McQgitHvfmFIDcSUH
	Phwfn3psFVqHwlImiSdKwB/zClvSTmw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 18 May 2026 16:34:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: [RFC PATCH 1/2] mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip zero-filled page check
Date: Mon, 18 May 2026 16:34:54 +0900
Message-Id: <20260518073455.2495934-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518073455.2495934-1-youngjun.park@lge.com>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E90BC0016
X-Stat-Signature: un48si9sb9gmyqtgbszqymfzporcf861
X-Rspam-User: 
X-HE-Tag: 1779089702-125735
X-HE-Meta: U2FsdGVkX18IH4J79+SNkdQMZo+5/Q39hRiUAku01HC2cXJyAZNMhE8KMCP8mjC2hvaeH5lPulOpbNRBtdxeBvrZ7GsseCdH8fDf/lmhs7ZsvpMS9GwTY4IrS1lHm93OUwoIYhI9HkA5i+O74LDLJMNz5zmpSiPGQEzFr9hghFJR8RehHgordBR76agn5dXMfvYAk6yfzC3zkz4zH26spE1fRKhW6iCJrYbGk2AFz9um8i0wQ4dy/2appHOF4zuwOrUZlbNt3J3t8HjPLpbgBD5dMQaKs9IhyWKYrFdi/aoH5fMVnyLYLukUzjVMpz2wn8Jnyg5VycaqdF7nsvE2G6err3Ibcx0iJfw5+rfxbo0olTQUzs1V40y/gxGxJGIurHK6ujKzIE8eoToYTeG+IO3egoiddYG5+zxKo1dyf+Kdro252KOSsEQnZLzd62Y4fIWEJEBHKssbBO7iqCi9kPsajqi6wGOuRQeyOlfPXQgSQBOp2hmDWWSkBYfwEAzXcwgKx0fXLyyQIfkcgGZQfVIp2DIkqkVdJVPmA1d0a/KLr/iACbjz84Zsvte4K5bzX+tsQUjYGdC0QWhfFBwFJN5A1tpqGVWHPnW6fA/vONJ88G0ouH+d9GzkYe3weA/N25VDwHqRGwQN1KasD2CSHYgML+RIH7aeNCtcmsbWaB0/tg0ewKkke3dHVVNMFpo40jF25iFZON59EU609yKxKADT/Viea02s8zGCYPulutY3+dIfKuGdapAyqioCkTMPNOY6HNK43be5yJbmh0IM+s3MFNKXIPY9USOHAyN4e9xh7buNItBa+tPYNXrTfKJOoothZgHcm6HkSF8zg/vwOUzKl/UbbRoV4yr7bpqlfhqYxnH6BxQ9AVNmkPscWDpQZbK1iC1z6+HwA1P94xb+rBTBkNe9BvlXZ4mPiNoP2m+VsA9SpHn4yntm9qKoelKYl5jLSCKSjb8XUnaxNa6
 aJeTUB6a
 awm5t2l03VOWdvZ5XOEpdZHzQOWgUoMXc+44a2bmmmUGAIIbHcNzmS/ZuxV9vPnYZ23ncTgZWqJi49zPtn1FUAIFNpoBMK0OYFoUgtx3dzw0SJAaTrgpERCWvkxOMPZvk3dW8HYGV5+ZJZQhZcuemSnY6yfcJW634McPF9q6J+OLkrGQhMhN0TiLCoczURhPEpAeHBcfMOpCu105s2zqjf6Ml5i+7MtbJXcae61ZE8uS2y5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The swap layer currently checks if a page is zero-filled before writing
it out. However, some swap backends like zram already perform their own
same-filled data checking. This causes redundant CPU cycles spent on
checking zero pages in both the swap layer and the backend.

Introduce a new swapon flag, SWAP_FLAG_SKIP_ZERO_CHECK.
When this flag is passed during swapon, the swap layer bypasses the
zero-filled page check and directly passes the page to the backend.

This feature is implemented as a per-swap device flag because other
devices still benefit from the swap layer's zero check to avoid
unnecessary I/O operations. Userspace can now selectively apply this
flag to devices like zram to reduce CPU overhead.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h |  4 +++-
 mm/page_io.c         |  7 ++++++-
 mm/swap.h            | 12 ++++++++++++
 mm/swapfile.c        |  3 +++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6d72778e6cc3..30282019a758 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -25,10 +25,11 @@ struct bio;
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
 #define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
 #define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
+#define SWAP_FLAG_SKIP_ZERO_CHECK 0x80000
 
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
-				 SWAP_FLAG_DISCARD_PAGES)
+				 SWAP_FLAG_DISCARD_PAGES | SWAP_FLAG_SKIP_ZERO_CHECK)
 #define SWAP_BATCH 64
 
 static inline int current_is_kswapd(void)
@@ -215,6 +216,7 @@ enum {
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
 					/* add others here before... */
+	SWP_SKIP_ZERO_CHECK = (1 << 14), /* skip zero-filled page check */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/page_io.c b/mm/page_io.c
index f2d8fe7fd057..4b65ea19801e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -265,6 +265,9 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		goto out_unlock;
 	}
 
+	if (swap_skip_zero_check(folio))
+		goto skip_zerocheck;
+
 	/*
 	 * Use the swap table zero mark to avoid doing IO for zero-filled
 	 * pages. The zero mark is protected by the cluster lock, which is
@@ -282,6 +285,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	 */
 	swap_zeromap_folio_clear(folio);
 
+skip_zerocheck:
 	if (zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
@@ -563,7 +567,8 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	 * that an IO error is emitted (e.g. do_swap_page() will sigbus).
 	 * Folio lock stabilizes the cluster and map, so the check is safe.
 	 */
-	if (WARN_ON_ONCE(swap_zeromap_batch(folio->swap, nr_pages,
+	if (!swap_skip_zero_check(folio) &&
+		WARN_ON_ONCE(swap_zeromap_batch(folio->swap, nr_pages,
 			 &is_zeromap) != nr_pages))
 		return true;
 
diff --git a/mm/swap.h b/mm/swap.h
index 81c06aae7ccd..299e1200887f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -334,6 +334,13 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 	return __swap_entry_to_info(folio->swap)->flags;
 }
 
+static inline bool swap_skip_zero_check(struct folio *folio)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(folio->swap);
+
+	return (si->flags & SWP_SKIP_ZERO_CHECK) ? true : false;
+}
+
 #else /* CONFIG_SWAP */
 struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
@@ -471,5 +478,10 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 {
 	return 0;
 }
+
+static inline bool swap_zero_check_skip(struct folio *folio)
+{
+	return false;
+}
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a9a1e477fec9..35cc33698b78 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3658,6 +3658,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (IS_ERR(si))
 		return PTR_ERR(si);
 
+	if (swap_flags & SWAP_FLAG_SKIP_ZERO_CHECK)
+		si->flags |= SWP_SKIP_ZERO_CHECK;
+
 	INIT_WORK(&si->discard_work, swap_discard_work);
 	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
 
-- 
2.34.1


