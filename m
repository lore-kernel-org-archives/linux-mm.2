Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5312FC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9B16B00A5; Sat, 29 Aug 2026 03:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759966B00A6; Sat, 29 Aug 2026 03:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647AC6B00A7; Sat, 29 Aug 2026 03:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A46D6B00A5
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD35DA4124
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:14 +0000 (UTC)
X-FDA: 85153528908.04.0E82379
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id DE24880003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bkF8vMhF;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNuXN9S7i6TqJ8ICcOb8D2g40X31e66OWo2XPTKLXSs=;
	b=alqCm1kIdbT69cZDBJIxdKKyTT/yqGcv/F0k5omzl787394RVLt7GWgJfQhTN3Fy4v3aoJ
	5Ee3a9EC5KLEp8yQJTjb7h93ywbbbb6JKYymZfi4kNdEwVYWccaG6JomG5NfXkUEcIdxGY
	qiu2yvhNaUpuB81oXqcZpjcG4N6U1aE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989692;
	b=V3+Yn5fz50zgEKdB7MyM0THiy8B54h34erlQZlCfECiAmbFGC6WDcJu5+M5HvjsQRrcNWh
	7C0iWccHohXWXTAQZaxEaiSpCljHVVSeCh0OMmUilBVn5cTPEuUlvUwvFzuQRWy1j/8BcG
	WZmlkTSj9K+D8hiZAUoF+kLVk0yatEk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bkF8vMhF;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1767949a91.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989692; x=1788594492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNuXN9S7i6TqJ8ICcOb8D2g40X31e66OWo2XPTKLXSs=;
        b=bkF8vMhFv5gBgWf5JHtwpXBwvNYghd9LFj6AVLKDRPEzMZpoQY6TW+CVz54ekEl8M6
         qmJ9On3WJZezvsEhV1Xn8cF7iRtb237146a19TxlQyuv2Rvxkz8tbViH3eF4o2sm08hd
         6hAUk6+JIXWgiJGPPtL2lXXq3rcPA4iMDABNCBDHix/cbJlXys8DojWjp2D6vtjjgBJ9
         Cjv28vttNONDGKyKLFboikPL3f2V4rFzxA48Y6+U22t8khbtREqooMhhTAnUCqBkt9fR
         aLxphEbekBfg2+X5yzLFhMjDdj+hj3eUdnqT5pMtx2ede396Bj3OYEqFGUTDGHqCe/WU
         87Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989692; x=1788594492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNuXN9S7i6TqJ8ICcOb8D2g40X31e66OWo2XPTKLXSs=;
        b=HaTaX2PYqxKRNcA1vQtjEaVPyUI9XbjLbA7M7IXxPTy8/tjwOjxJSw8a15VKzVgygt
         n38+M4VgAxKrxw6cBKTIwfwAlmSAQaITq0trUh7bahXyKKeQ86ASOqtz2IrKPnPSeUKF
         isToxa/+LV8eqjJ/EHsZdU9ey/Z3y9uMg1e/slUKGy1tUdH7vxLArdfBaSh2g7w1ahfi
         Josy2EKejqOpiS6lIXwuB3FrGYfs73hFoRpb0Za1ReeWvjLFglJtVOKyUAMBPMo9p3JM
         4AonwsgELvGPEtk+lrq96/pJH+6wuCwO0brqLB9IxDQkf3UgNQOMK6Exqrv8KHDK4hnB
         NMFw==
X-Gm-Message-State: AFuF++k+2lKaGntumB/DAB9aExQn7qyBwHonf619VBN58p74KmlzlZKz
	p9cW0zxCyZZhI3NvrLHIQVRpCRvZ+BQiXj19RNzigy2qiYgUPlAn2OlK1mcY3w==
X-Gm-Gg: AYBFou1xcaJMzcGDfUjDsxJ3/wZPsFZv1bAPi2XEnOcIC4CRcNa22e6DiHhZDmEUy8H
	4CU0Rqt+c+wCRSLUZN8nbpCQRtbxMwpQPFV19jwZPGKlVHfS6hV9UQKZO14nAPhuaA7deHaFrcB
	Z0Zxbd74Jxt7mtZmFQunnOujiAFZu4cBytLiUGWaekemNP3lFoyAcPihPcLZU5jGhJBEIFXCYV3
	Xkn4JpI19ixmgJ+PqzMUyRhoZdfTvdvF313Cnmncg9TmNgLxuUyVx57WAHCB3ODXhM355x1pOX3
	cQf3b3JIUk4ygizEROmchx7VHPgm3nefB9lHb5RcGCDmG4aplwTo3uMnka2zFLOBlR4ej+8ycQy
	4Xo51e66+4Q8PDvC29s3cJBZW1eEr+Q5CizOlNLvyABwRbGLl6qRmNgtXNWvNHAdgpP80GucbOO
	3hHPb7pCN9cZ7WE84hhNB0hhvBZsdAd4pKCX/7Htr0YLe54pg/7je5HVF2yFDWdk+9X+8mGVEzP
	0qHU0toF8Lc8L5x3YASoCbIejtJ
X-Received: by 2002:a17:90b:4c0b:b0:398:9c0c:7c72 with SMTP id 98e67ed59e1d1-3989c0c7ffemr6904606a91.25.1787989691567;
        Sat, 29 Aug 2026 00:48:11 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396ddca5bfbsm6255487a91.17.2026.08.29.00.48.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:48:11 -0700 (PDT)
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
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RESEND RFC PATCH v2 09/13] mm/swap: add priority queue for swap device allocation
Date: Sat, 29 Aug 2026 15:48:03 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-9-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aarfdnqqbh6ujm1mas8bdkj6mkehp63g
X-Rspamd-Queue-Id: DE24880003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787989692-271353
X-HE-Meta: U2FsdGVkX19EU3me+xCugdUrhj7vLvFjMNo4Wd8mWW1NJCGmmJDd4EmgvJf2iEOP1jcqMQ2GvTY+OlD/DDkriHc1P9cdh7r5ZcZ10vd+CJzVgI004sOqa3d53PApGVRQmf8sKJCH+WXYvJFyyJ37N9SDlDPFUwVrrC3Lbyk1mcMos+6GfcDEzH79VxAz/WM48KLkv6z+Acp6kq6dvDePeDI4UkyAj5BHEV3y5Wn9vfJbSpodcSt7Sx4GIeqX08bxGeIlcUXpo8rUo1SPBIAWHRj7qB8hKs7g1SxBEuvo1y/ZRfJPQ++FFHyURNOxqUmAjWxDp7VhUGc/sQLwDLBo/PhRjo8WcnDstNDiS8aSN9UYMKSrc0+gWGWpLpbP8NXCr8qYTP5k0KtnnZA/TeNMntSkVDj8iwc7eJzxZIGd6lJDag0ksg3GgDb/1p16XtBzSTAu0KOUgKi/FCA3MxTzYXVjuZnT72tw68fj4XOl3w8GlVhIpeGipbOTYTSYpKqlL7RTW07NV2ujCDI4522fvG2UYjMln1Fl1kQ08N1NU8Z/3J/pQqX53Cwn1bhug8ewK74+LXzhO5YJV5vGlTWUfmzsHg4ZUYo0H70mve1/cEdUJYeMGrrVNYm9kyCVYtPeZkPUfnaqWsFkjCFWqH67IA71A8b/ScgNioj6EiBuHocrNuOWNlkR1kUdd5HfSqc/9zxpGlxUolVTSXrqeKfb5doNIVJ713holnNHMtusQyo6mFFvrQSjULh2nLn9oxxX1XvJH/6ZSgFVVUYC2BQxK7fk6Z2T5y7UcEXRtICzfcyOig8g2oPBQu+I+LCkunbp2NmxuYG5p35PVZfB73hlbpfscWTvW5aeOctgu7q6TH4r1XSnqqcf9SHweYAmtD/Qy6vqPZ5qDMpfAxE6zaShfZB/GWlWqe6ZFq+2EqYlEFZd29IbtyQ3qWYDNxo18487NoOiwCbi++nrTbYPiW8
 qHCeUwUc
 Gid+k3yWY2L0bJ/N3XFqP9fFVpxQMY+kllpgmrPmrvCOYVlM6aGXnl+T9DzZBBCWa6EqNKHV6dgu6/O03pJ2bcztg6yok0DP4cHf5Cj1dLsD1l+0vVT5IwzldS+8G4iEp6+aAnuL214XCVajiPxSJXPsbLPJeqtMkkkRUAircu/QrsX2Xmlc55W8TTs2GtWgajWjSxpovE2ghioJrJrL9LBp2LvkG1tnCYDP9ucw2zYr5WZFF03O2y8xzekEPr38gSMUNKBWPOWFkGiy5toZBX+44LHK8GKwf1yDlnnDx/LuUsxy20Uy040+sXBAVSQtFIFWVUr+8v2gF7Z60rZqaoMF7KZ+t2IhZEHLGwsYszNN0Ji1HNSIl0bqup20AKns9slcquacDQ0JwliKLTYqoOOcgRjyf5afgvYlRLUXdqW3Ov0SxdpQV8CwipwybiNEs6T+XLpSIDJtCTj8AfSnYH/Nvyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The swap allocator uses swap_avail_head, a plist ordered by priority,
to select devices. Devices at the same priority are rotated with
plist_requeue(), so every cluster transition serializes allocators on
swap_avail_lock and repeatedly drops and reacquires that global lock.

Replace device selection with a priority queue made of immutable rings.
Each ring contains devices at one priority, and each CPU has a local
reader that rotates through a ring after a fixed allocation quota. A
task-local cursor keeps a retry walk stable even if another task updates
the shared reader between attempts, so each peer is visited exactly once
before the allocator considers a lower priority.

Disable task migration across the retry walk so queue selection, quota
accounting and per-CPU cluster allocation stay on the same CPU. This
preserves per-CPU pacing without making the sleepable allocation loop an
atomic context.

Keep the queue structure stable under swapon_rwsem. Full or disabled
devices remain in their ring with a tag in the low bit of the stored
pointer. Serialize tag writers with swap_queue_update_lock and pair the
lockless full-pointer reads and writes with READ_ONCE() and WRITE_ONCE().
The in-use counter carries a separate off-list bit so full-to-available
transitions update the counter and pointer tag consistently.

Publish swap_file, the live percpu reference, queue membership and
SWP_WRITEOK in one swapon writer section. Preserve the writer-serialized
swapoff lookup and disable invariant established earlier in the series.

For large folios, try every device in the selected priority ring before
returning -E2BIG to request a split. Do not fall back to a lower priority
device merely because the first same-priority device is fragmented.

The old available plist is still maintained in parallel in this commit
so the transition remains bisectable. It is removed by the next patch.

Link: https://lore.kernel.org/20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com
Link: https://lore.kernel.org/alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330
Link: https://lore.kernel.org/77d6da3d-10af-49a1-a356-72aa8b462e85@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/swap.h |   5 +-
 mm/swapfile.c        | 526 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 464 insertions(+), 67 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index aa66d8454186..37fe2e4d2774 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -201,8 +201,9 @@ struct swap_extent {
  * - SWP_USED: Protected by swapon_rwsem. Indicates the device is inuse. Once
  *   set, won't be cleared unless all reference to this device is freed and
  *   swapoff finished.
- * - SWP_WRITEOK: Protected by both swapon_rwsem and swap_avail_lock, clearing
- *   this flag also waits for all current cluster lock users to exit so
+ * - SWP_WRITEOK: Protected by both swapon_rwsem and swap_queue_update_lock.
+ *   Clearing this flag is followed by waiting for all current cluster lock
+ *   users to exit, so
  *   checking this flag while holding any of these locks ensures the device
  *   is safe to use at the moment. Note: clearing this flag doesn't affect
  *   pending IO or async requests, it only prevents further entry allocation
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 79ecff2d0bd3..1b7bc968b5f7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -55,6 +55,7 @@ static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
+static bool get_swap_device_info(struct swap_info_struct *si);
 
 /*
  * Serializes swapon/swapoff (writers) and protects the swap_info
@@ -160,20 +161,382 @@ static struct swap_info_struct *swap_entry_to_info(swp_entry_t entry)
 	return swap_type_to_info(swp_type(entry));
 }
 
+/*
+ * All available swap_info_structs are grouped by priority rings, the rings
+ * are ordered in a queue by priority (higher prio value = higher priority).
+ * The allocator iterates and rotates devices within each priority ring.
+ * When all devices in a ring are iterated, it goes to the next lower
+ * priority ring.
+ */
+struct swap_prio_ring {
+	int prio;
+	unsigned int size;
+	struct swap_info_struct *dev[] __counted_by(size);
+};
+
+/*
+ * The ring is protected by swapon_rwsem so updating it is costly. To make
+ * the allocator and other users skip full devices faster, the lowest bit of
+ * a device pointer is used to mark it disabled (temporarily unavailable).
+ * This relies on the natural alignment of struct swap_info_struct.
+ */
+#define SWAP_DEVICE_MASKED_SHIFT	0
+#define SWAP_DEVICE_MASKED_BIT		BIT(SWAP_DEVICE_MASKED_SHIFT)
+static_assert(__alignof__(struct swap_info_struct) >= 2);
+
+/*
+ * Serializes queue content mutations and keeps SWAP_USAGE_OFFLIST_BIT
+ * consistent with the masked state of each device pointer.
+ */
+static DEFINE_SPINLOCK(swap_queue_update_lock);
+
+/*
+ * Swap queue is protected by both swap_queue_update_lock and swapon_rwsem.
+ * Only swapon/swapoff will take the write lock, and modify the queue length
+ * or any ring's length. swap_queue_update_lock protects the content so
+ * devices can be masked easily without taking the writelock, which is heavy.
+ */
+static struct swap_prio_ring **swap_queue;
+static unsigned int swap_queue_len;
+
+/*
+ * Each CPU has its read iterator, so the queue itself will remain read
+ * only and the CPU side reader rotates by iterating the devices
+ * periodically using the counter.
+ */
+#define SWAP_ROUND_ROBIN_QUOTA SWAPFILE_CLUSTER
+struct swap_ring_iterator {
+	int offset;
+	long rr_counter;
+};
+
+struct swap_queue_reader {
+	local_lock_t lock;
+	struct swap_ring_iterator ri[];
+};
+
+struct swap_queue_cursor {
+	bool valid;
+	bool ring_only;
+	unsigned int ring_idx;
+	unsigned int offset;
+};
+
+static __percpu struct swap_queue_reader *swap_queue_readers;
+
+static inline bool swap_device_masked(struct swap_info_struct *si)
+{
+	return (unsigned long)si & SWAP_DEVICE_MASKED_BIT;
+}
+
+static inline struct swap_info_struct *swap_device_mask_ptr(struct swap_info_struct *si)
+{
+	return (struct swap_info_struct *)((unsigned long)si |
+					   SWAP_DEVICE_MASKED_BIT);
+}
+
+static inline struct swap_info_struct *swap_device_unmask_ptr(struct swap_info_struct *si)
+{
+	return (struct swap_info_struct *)((unsigned long)si & ~SWAP_DEVICE_MASKED_BIT);
+}
+
+static struct swap_queue_reader __percpu *swap_queue_prealloc_readers(int nr_rings, gfp_t gfp)
+{
+	struct swap_queue_reader __percpu *readers;
+
+	if (!nr_rings)
+		return NULL;
+
+	readers = __alloc_percpu_gfp(struct_size(readers, ri, nr_rings),
+				     __alignof__(*readers), gfp);
+	return readers;
+}
+
+static void swap_queue_install_readers(struct swap_queue_reader __percpu *readers)
+{
+	int ring_idx, cpu;
+	struct swap_prio_ring *ring;
+
+	free_percpu(swap_queue_readers);
+	swap_queue_readers = readers;
+	if (!readers)
+		return;
+
+	/* Distribute each CPU's swap IO fairly across devices. */
+	for_each_possible_cpu(cpu) {
+		local_lock_init(&per_cpu_ptr(readers, cpu)->lock);
+
+		for (ring_idx = 0; ring_idx < swap_queue_len; ring_idx++) {
+			ring = swap_queue[ring_idx];
+			per_cpu_ptr(readers, cpu)->ri[ring_idx].offset =
+				    cpu % ring->size;
+			per_cpu_ptr(readers, cpu)->ri[ring_idx].rr_counter =
+				    SWAP_ROUND_ROBIN_QUOTA;
+		}
+	}
+}
+
+static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter,
+						      struct swap_queue_cursor *cursor)
+{
+	bool rotate = false;
+	struct swap_info_struct *si;
+	struct swap_ring_iterator *ri;
+	struct swap_prio_ring *ring;
+	unsigned int dev_idx, queue_idx;
+
+	if (!swap_queue_len)
+		return ERR_PTR(-ENOENT);
+
+	queue_idx = 0;
+	while (nr_iter >= swap_queue[queue_idx]->size) {
+		nr_iter -= swap_queue[queue_idx]->size;
+		if (++queue_idx >= swap_queue_len)
+			return ERR_PTR(cursor->ring_only ? -E2BIG : -ENOENT);
+	}
+	if (cursor->ring_only && cursor->ring_idx != queue_idx)
+		return ERR_PTR(-E2BIG);
+
+	ring = swap_queue[queue_idx];
+	local_lock(&swap_queue_readers->lock);
+	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
+	/*
+	 * Snapshot the starting offset for this allocation's walk. The shared
+	 * iterator can move between retries, but the cursor must visit every
+	 * device in the ring exactly once before falling through.
+	 */
+	if (!cursor->valid || cursor->ring_idx != queue_idx) {
+		cursor->valid = true;
+		cursor->ring_idx = queue_idx;
+		if (ri->rr_counter < nr_alloc)
+			rotate = true;
+		else if (ri->offset >= ring->size)
+			rotate = true;
+		if (rotate) {
+			ri->offset++;
+			ri->offset %= ring->size;
+			ri->rr_counter = SWAP_ROUND_ROBIN_QUOTA;
+		}
+		cursor->offset = ri->offset;
+	}
+
+	dev_idx = (cursor->offset + nr_iter) % ring->size;
+	if (nr_iter) {
+		ri->offset = dev_idx;
+		ri->rr_counter = SWAP_ROUND_ROBIN_QUOTA;
+	}
+	ri->rr_counter -= nr_alloc;
+	si = READ_ONCE(ring->dev[dev_idx]);
+	local_unlock(&swap_queue_readers->lock);
+
+	if (swap_device_masked(si))
+		return ERR_PTR(-EBUSY);
+
+	si = swap_device_unmask_ptr(si);
+	return si;
+}
+
+static bool swap_queue_find(struct swap_info_struct *si,
+			    unsigned int *ring_idx, unsigned int *dev_idx)
+{
+	unsigned int i, j;
+	struct swap_prio_ring *ring;
+
+	lockdep_assert(lockdep_is_held(&swapon_rwsem) ||
+		       lockdep_is_held(&swap_queue_update_lock));
+
+	for (i = 0; i < swap_queue_len; i++) {
+		ring = swap_queue[i];
+		if (ring->prio != si->prio)
+			continue;
+		for (j = 0; j < ring->size; j++) {
+			if (swap_device_unmask_ptr(READ_ONCE(ring->dev[j])) != si)
+				continue;
+			*ring_idx = i;
+			*dev_idx = j;
+			return true;
+		}
+	}
+	return false;
+}
+
+static void swap_queue_mask(struct swap_info_struct *si)
+{
+	unsigned int ring_idx, dev_idx;
+
+	lockdep_assert_held(&swap_queue_update_lock);
+	if (swap_queue_find(si, &ring_idx, &dev_idx))
+		WRITE_ONCE(swap_queue[ring_idx]->dev[dev_idx],
+			   swap_device_mask_ptr(si));
+}
+
+static void swap_queue_unmask(struct swap_info_struct *si)
+{
+	unsigned int ring_idx, dev_idx;
+
+	lockdep_assert_held(&swap_queue_update_lock);
+	if (swap_queue_find(si, &ring_idx, &dev_idx))
+		WRITE_ONCE(swap_queue[ring_idx]->dev[dev_idx], si);
+}
+
+static int swap_queue_add(struct swap_info_struct *si)
+{
+	struct swap_prio_ring **new_queue = NULL, **old_queue = NULL;
+	struct swap_queue_reader __percpu *new_readers = NULL;
+	struct swap_prio_ring *ring, *new_ring = NULL, *old_ring = NULL;
+	int prio = si->prio;
+	int i, pos, err = -ENOMEM;
+	gfp_t gfp;
+
+	/* Swap not usable here because this is swap, just reclaim cache. */
+	gfp = GFP_NOIO | __GFP_HIGH;
+	lockdep_assert_held_write(&swapon_rwsem);
+
+	for (pos = 0; pos < swap_queue_len; pos++) {
+		if (swap_queue[pos]->prio == prio)
+			goto add_to_ring;
+		if (swap_queue[pos]->prio < prio)
+			break;
+	}
+
+	/* No ring at this priority: insert a new one at pos. */
+	new_readers = swap_queue_prealloc_readers(swap_queue_len + 1, gfp);
+	if (!new_readers)
+		goto failed;
+	new_queue = kmalloc_array(swap_queue_len + 1, sizeof(*swap_queue), gfp);
+	if (!new_queue)
+		goto failed;
+	new_ring = kmalloc(struct_size(new_ring, dev, 1), gfp);
+	if (!new_ring)
+		goto failed;
+	if (!get_swap_device_info(si))
+		goto failed;
+
+	new_ring->prio = prio;
+	new_ring->size = 1;
+	new_ring->dev[0] = si;
+	for (i = 0; i < pos; i++)
+		new_queue[i] = swap_queue[i];
+	new_queue[pos] = new_ring;
+	for (i = pos; i < swap_queue_len; i++)
+		new_queue[i + 1] = swap_queue[i];
+
+	spin_lock(&swap_queue_update_lock);
+	old_queue = swap_queue;
+	swap_queue = new_queue;
+	swap_queue_len++;
+	spin_unlock(&swap_queue_update_lock);
+	kfree(old_queue);
+
+	swap_queue_install_readers(new_readers);
+	return 0;
+
+add_to_ring:
+	ring = swap_queue[pos];
+	new_ring = kmalloc(struct_size(ring, dev, ring->size + 1), gfp);
+	if (!new_ring)
+		goto failed;
+	if (!get_swap_device_info(si))
+		goto failed;
+	spin_lock(&swap_queue_update_lock);
+	memcpy(new_ring, ring, struct_size(ring, dev, ring->size));
+	new_ring->size++;
+	new_ring->dev[new_ring->size - 1] = si;
+	old_ring = swap_queue[pos];
+	swap_queue[pos] = new_ring;
+	spin_unlock(&swap_queue_update_lock);
+	kfree(old_ring);
+	return 0;
+
+failed:
+	free_percpu(new_readers);
+	kfree(new_queue);
+	kfree(new_ring);
+	return err;
+}
+
+static void swap_queue_del(struct swap_info_struct *si)
+{
+	gfp_t gfp;
+	unsigned int ring_idx, dev_idx;
+	struct swap_queue_reader __percpu *new_readers = NULL;
+	struct swap_prio_ring *ring, *new_ring = NULL, *old_ring = NULL;
+	struct swap_prio_ring **new_queue = NULL, **old_queue = NULL;
+
+	lockdep_assert_held_write(&swapon_rwsem);
+	if (!swap_queue_find(si, &ring_idx, &dev_idx)) {
+		WARN_ON(1);
+		return;
+	}
+
+	/*
+	 * To shrink memory usage, pre-allocate new smaller data before
+	 * locking. Failure is fine, swapoff will release them anyway.
+	 */
+	gfp = GFP_NOIO | __GFP_HIGH;
+	ring = swap_queue[ring_idx];
+	if (ring->size > 1)
+		new_ring = kmalloc(struct_size(ring, dev, ring->size - 1), gfp);
+	if (ring->size == 1 && swap_queue_len > 1) {
+		new_readers = swap_queue_prealloc_readers(swap_queue_len - 1,
+							  gfp);
+		new_queue = kmalloc(sizeof(*swap_queue) *
+				    (swap_queue_len - 1), gfp);
+	}
+
+	spin_lock(&swap_queue_update_lock);
+	if (ring->size > 1) {
+		/* Shift trailing devices left to fill the gap. */
+		while (++dev_idx < ring->size)
+			ring->dev[dev_idx - 1] =
+				ring->dev[dev_idx];
+		ring->size--;
+		if (new_ring) {
+			memcpy(new_ring, ring,
+			       struct_size(ring, dev, ring->size));
+			old_ring = ring;
+			swap_queue[ring_idx] = new_ring;
+		}
+	} else {
+		/* Last device in this ring: remove the ring. */
+		old_ring = ring;
+		swap_queue_len--;
+		while (++ring_idx <= swap_queue_len)
+			swap_queue[ring_idx - 1] =
+				swap_queue[ring_idx];
+		if (new_queue) {
+			memcpy(new_queue, swap_queue,
+			       sizeof(*swap_queue) * swap_queue_len);
+			old_queue = swap_queue;
+			swap_queue = new_queue;
+		} else if (!swap_queue_len) {
+			old_queue = swap_queue;
+			swap_queue = NULL;
+		}
+		if (new_readers || !swap_queue_len)
+			swap_queue_install_readers(new_readers);
+	}
+	spin_unlock(&swap_queue_update_lock);
+
+	kfree(old_ring);
+	kfree(old_queue);
+	put_swap_device(si);
+}
+
 /*
  * Use the second highest bit of inuse_pages counter as the indicator
- * if one swap device is on the available plist, so the atomic can
+ * if one swap device is unavailable for allocation, so the atomic can
  * still be updated arithmetically while having special data embedded.
  *
  * inuse_pages counter is the only thing indicating if a device should
- * be on avail_lists or not (except swapon / swapoff). By embedding the
- * off-list bit in the atomic counter, updates no longer need any lock
- * to check the list status.
+ * be in the available queue or not (except swapon / swapoff). By
+ * embedding the off-list bit in the atomic counter, updates no longer
+ * need any lock to check the list status.
  *
- * This bit will be set if the device is not on the plist and not
- * usable, will be cleared if the device is on the plist.
+ * This bit will be set if the device is not in the available queue
+ * and not usable, will be cleared if the device is in the queue.
  */
-#define SWAP_USAGE_OFFLIST_BIT (1UL << (BITS_PER_TYPE(atomic_t) - 2))
+#define SWAP_USAGE_OFFLIST_BIT BIT(BITS_PER_LONG - 2)
 #define SWAP_USAGE_COUNTER_MASK (~SWAP_USAGE_OFFLIST_BIT)
 static long swap_usage_in_pages(struct swap_info_struct *si)
 {
@@ -1221,6 +1584,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
+	spin_lock(&swap_queue_update_lock);
 
 	/*
 	 * Force remove it only for swapoff. Else, take it off-list only if
@@ -1238,9 +1602,10 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	}
 
+	swap_queue_mask(si);
 	plist_del(&si->avail_list, &swap_avail_head);
-
 skip:
+	spin_unlock(&swap_queue_update_lock);
 	spin_unlock(&swap_avail_lock);
 }
 
@@ -1251,12 +1616,12 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
+	spin_lock(&swap_queue_update_lock);
 
 	/*
-	 * Add the device to the avail list if SWP_WRITEOK is set and
-	 * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
-	 * SWP_WRITEOK first, so the device won't be re-added after
-	 * swapoff starts unless swap_device_enable resurrects it.
+	 * Mark the device as avail if SWP_WRITEOK is set. Swapoff clears
+	 * SWP_WRITEOK first, so check that first so the device won't be
+	 * re-added after swapoff started.
 	 */
 	if (!(si->flags & SWP_WRITEOK))
 		goto skip;
@@ -1267,21 +1632,23 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	val = atomic_long_fetch_and_relaxed(~SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 
 	/*
-	 * When device is full and device is on the plist, only one updater will
-	 * see (inuse_pages == si->pages) and will call del_from_avail_list. If
-	 * that updater happen to be here, just skip adding.
+	 * When device is full and marked as available, one reader will see
+	 * (inuse_pages == si->pages) and should mark it as unavailable and
+	 * set SWAP_USAGE_OFFLIST_BIT. If that updater happens to be here, just
+	 * skip the rest.
 	 */
 	pages = si->pages;
-	if (val == pages) {
+	if ((val & SWAP_USAGE_COUNTER_MASK) == pages) {
 		/* Just like the cmpxchg in del_from_avail_list */
 		if (atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
 					    pages | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
 	}
 
+	swap_queue_unmask(si);
 	plist_add(&si->avail_list, &swap_avail_head);
-
 skip:
+	spin_unlock(&swap_queue_update_lock);
 	spin_unlock(&swap_avail_lock);
 }
 
@@ -1298,7 +1665,7 @@ static void swap_device_inuse_add(struct swap_info_struct *si,
 
 	/*
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
-	 * remove it from the plist.
+	 * mark it unavailable.
 	 */
 	inuse_pages = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
 	if (unlikely(inuse_pages == si->pages)) {
@@ -1342,7 +1709,7 @@ static void swap_device_inuse_sub(struct swap_info_struct *si, unsigned long off
 
 	/*
 	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * add it back to the plist.
+	 * add it back to the available queue.
 	 */
 	inuse_pages = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
 	if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
@@ -1365,41 +1732,44 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
-/* Rotate the device and switch to a new cluster */
-static void swap_alloc_entry(struct folio *folio)
+static int swap_alloc_entry(struct folio *folio)
 {
-	struct swap_info_struct *si, *next;
+	struct swap_queue_cursor cursor = {};
+	long nr_pages = folio_nr_pages(folio);
+	struct swap_info_struct *si;
+	int nr_iter, ret;
 
-	spin_lock(&swap_avail_lock);
-start_over:
-	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
-		/* Rotate the device and switch to a new cluster */
-		plist_requeue(&si->avail_list, &swap_avail_head);
-		spin_unlock(&swap_avail_lock);
-		if (get_swap_device_info(si)) {
-			cluster_alloc_swap_entry(si, folio);
-			put_swap_device(si);
-			if (folio_test_swapcache(folio))
-				return;
-			if (folio_test_large(folio))
-				return;
+	percpu_down_read(&swapon_rwsem);
+	migrate_disable();
+	for (nr_iter = 0;; nr_iter++) {
+		si = swap_queue_get_device(nr_pages, nr_iter, &cursor);
+		if (IS_ERR(si)) {
+			ret = PTR_ERR(si);
+			if (ret == -EBUSY)
+				continue;
+			break;
+		}
+		cluster_alloc_swap_entry(si, folio);
+
+		if (folio_test_swapcache(folio)) {
+			ret = 0;
+			break;
 		}
 
-		spin_lock(&swap_avail_lock);
 		/*
-		 * if we got here, it's likely that si was almost full before,
-		 * multiple callers probably all tried to get a page from the
-		 * same si and it filled up before we could get one; or, the si
-		 * filled up between us dropping swap_avail_lock.
-		 * Since we dropped the swap_avail_lock, the swap_avail_list
-		 * may have been modified; so if next is still in the
-		 * swap_avail_head list then try it, otherwise start over if we
-		 * have not gotten any slots.
+		 * For large allocations, try every device at the same priority,
+		 * but ask the caller to split instead of falling back to a lower
+		 * priority ring.
 		 */
-		if (plist_node_empty(&next->avail_list))
-			goto start_over;
+		if (folio_test_large(folio)) {
+			cursor.ring_only = true;
+			continue;
+		}
 	}
-	spin_unlock(&swap_avail_lock);
+
+	migrate_enable();
+	percpu_up_read(&swapon_rwsem);
+	return ret;
 }
 
 /*
@@ -1713,6 +2083,7 @@ int folio_alloc_swap(struct folio *folio)
 {
 	unsigned int order = folio_order(folio);
 	unsigned int size = 1 << order;
+	int ret;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
@@ -1736,7 +2107,7 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 again:
-	swap_alloc_entry(folio);
+	ret = swap_alloc_entry(folio);
 
 	if (!order && unlikely(!folio_test_swapcache(folio))) {
 		if (swap_sync_discard())
@@ -1748,7 +2119,7 @@ int folio_alloc_swap(struct folio *folio)
 		swap_cache_del_folio(folio);
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		return ret ? ret : -ENOMEM;
 
 	return 0;
 }
@@ -2921,24 +3292,29 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 }
 
 /*
- * Mark a fully initialized swap device writable and expose it to the
- * allocator. The caller must have resurrected its percpu ref first.
+ * Mark a fully initialized swap device writable and expose it to the allocator.
+ * The caller must have resurrected its percpu ref before entering this helper.
  */
-static void swap_device_enable(struct swap_info_struct *si)
+static void __swap_device_enable(struct swap_info_struct *si)
 {
-	percpu_down_write(&swapon_rwsem);
-	spin_lock(&swap_avail_lock);
-	si->flags |= SWP_WRITEOK;
-	spin_unlock(&swap_avail_lock);
+	lockdep_assert_held_write(&swapon_rwsem);
 
+	spin_lock(&swap_queue_update_lock);
+	si->flags |= SWP_WRITEOK;
+	spin_unlock(&swap_queue_update_lock);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
-	percpu_up_write(&swapon_rwsem);
-
 	add_to_avail_list(si);
 }
 
+static void swap_device_enable(struct swap_info_struct *si)
+{
+	percpu_down_write(&swapon_rwsem);
+	__swap_device_enable(si);
+	percpu_up_write(&swapon_rwsem);
+}
+
 static int swap_device_disable(struct address_space *mapping,
 			       struct swap_info_struct **swap_info)
 {
@@ -2972,10 +3348,9 @@ static int swap_device_disable(struct address_space *mapping,
 	}
 	vm_unacct_memory(si->pages);
 
-	spin_lock(&swap_avail_lock);
+	spin_lock(&swap_queue_update_lock);
 	si->flags &= ~SWP_WRITEOK;
-	spin_unlock(&swap_avail_lock);
-
+	spin_unlock(&swap_queue_update_lock);
 	plist_del(&si->list, &swap_active_head);
 	total_swap_pages -= si->pages;
 	atomic_long_sub(si->pages, &nr_swap_pages);
@@ -3060,6 +3435,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		return err;
 	}
 
+	percpu_down_write(&swapon_rwsem);
+	swap_queue_del(p);
+	percpu_ref_kill(&p->users);
+	percpu_up_write(&swapon_rwsem);
+
 	/*
 	 * Wait for swap operations protected by get/put_swap_device()
 	 * to complete.  Because of synchronize_rcu() here, all swap
@@ -3068,7 +3448,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	 * prevent folio_test_swapcache() and the following swap cache
 	 * operations from racing with swapoff.
 	 */
-	percpu_ref_kill(&p->users);
 	synchronize_rcu();
 	wait_for_completion(&p->comp);
 
@@ -3721,11 +4100,28 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->prio = prio;
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
-	si->swap_file = swap_file;
 
-	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
+	/*
+	 * Publish swap_file before making the percpu ref live, then add the device
+	 * to the queue and make it writable under the same write-side lock. This
+	 * keeps lockless ref users and /proc/swaps from observing partial state.
+	 */
+	percpu_down_write(&swapon_rwsem);
+	si->swap_file = swap_file;
 	percpu_ref_resurrect(&si->users);
-	swap_device_enable(si);
+	error = swap_queue_add(si);
+	if (error) {
+		si->swap_file = NULL;
+		percpu_ref_kill(&si->users);
+	} else {
+		__swap_device_enable(si);
+	}
+	percpu_up_write(&swapon_rwsem);
+	if (error) {
+		wait_for_completion(&si->comp);
+		inode->i_flags &= ~S_SWAPFILE;
+		goto free_swap_zswap;
+	}
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
-- 
2.55.0

