Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FA7606A33C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gep+/6pE
Received: by kanga.kvack.org (Postfix)
	id D2CEA6B05BF; Mon, 23 Nov 2026 09:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE006B05C0; Mon, 23 Nov 2026 09:16:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5DA6B05C1; Mon, 23 Nov 2026 09:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 962106B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21DB3C08F1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:57 +0000 (UTC)
X-FDA: 85466585274.09.FDEF150
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48CE3C001A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="gep+/6pE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443415;
	b=gOouUS3Z7OeRnw4hBZ8dQ4hT9k6LqvOYSSX5T2620zvLaGmFBB+3mzGiRKH0ZD1L1e4L35
	XFNAiZoXFYnMVv3y3QLTxkDAHIh6DKecV0R1a0L8TJpf41k1qVI2HJpR0w3Sp/dQU73R5m
	jY0x1yBZGg4kRSn5/rrjsvCrBtRUT3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iABdfnxFx3EmjF7ws7PA7smuift4fgOpvgTOd+xZhS4=;
	b=uSg38OAG8gvI7t03nX6T5H8Wqnt4DeZ8xCpvfV/FTCveAIGzCobCyAdS0kJC/lsp4dtgAR
	IUOmF+sPrrqNMUk7hAXBiX0r5Tkx5t3l2CFbKfC5Y+s/n+WE8NoWEbiziZ/FXJKFYf24HB
	LJU9Na2adN8fCWcfCj4pY0oRMp0ycgQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="gep+/6pE";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a2761c69fbso2100842c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443414; x=1796048214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iABdfnxFx3EmjF7ws7PA7smuift4fgOpvgTOd+xZhS4=;
        b=gep+/6pEim1scOkT4oSBPGRDH3h1cNb5Tj5GyA8/CGPPP6GqTlqkRWAOID1vfjw7AA
         A3sRcaFvA3RXypks4c6v++Tn1nD1NoTjMb8mFtPExoXRtZoKT/XjsY6Z7s59R3bWdwnO
         ui4NjciOPpvx1JTvhEhOmPKnWGJ/+7eCAgUruKLHxBYnh9MK93lWEOhEKOX7tV5/rCbC
         TxlpA4Obqgkal4UGI8At4CqZZSpJRY5C1PuieisREXsxeffoyxzTgrySvssevRyT33tz
         ta8gZjorCjMufzFPHIj5dAGxlB6/i1md4HEOZY2Or93n6iZozq7D1KsBdf1PUD4JK63d
         zfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443414; x=1796048214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iABdfnxFx3EmjF7ws7PA7smuift4fgOpvgTOd+xZhS4=;
        b=WgzT8ZiTgN3oD6Ki/x+UodXICp6WbJ0gZ9onVyqiuQ7/zNiN4JvN0DHk8ZCaEyEtEc
         B6nebj4WIYMH2XLW21JLPvWSas3vBArjhCBrcajoDMDuPYCYFO/i2GC6KyucHywxCz45
         AyYXv7hbdSsn2hw6whj8YoGJLwdhg43rzKmqvdJmFIDjoDC+5A9+FVQsHv9dQxvZ6a84
         prAuftke2CJOiU/6v+5D6UzMGxFgVuV5GiIUH3MKYy9Iwv8Czz2bTxnXiD1tbOdIyanb
         vUWUT14Nn2ysdw3N904JudyLq/NOYuEXuhuhHjC73ZvHVIg2vH1m/QFmBodZkaJBiZ+c
         VKxA==
X-Gm-Message-State: APuU4Z8IKQR+TeBdcUwyaNUHrtJev23qO8tu9Y/kSWyytNkX4uJJ0gxW
	tl8BSB7pSAEwWtVsl/Hm+eoLZoM7tRHBI6cdy13WiyEjLO/5yoJxBxbEIqt7SRzf
X-Gm-Gg: AZFdTZcF6hfPO3kFajh4oJjRd2tOUBC9+rfEanwTWFKx7kLjPuR/vkjeNWKugmYERCh
	8OAuPTyFZqKgRpY/7VfCBpUmLDuPV4F5QdAd1gAK+p90RUx8Dp2mlnFlMYAdtpdWVftsz3OYNdq
	W2Ok0Dk4S0Vy5mIE1ojqYju/ChNsa5ZRFXYyaAzbvaltttIdpBtjcTq8f3mcujUbMYqOWm98Vne
	O41AhHie9z+cYloo6xR5WuNCpG9osag2BcDLug9CV1oiuLo6Pe1OlTHdgcmo/9IOQdfgP2hLj0l
	KvQVNJ5JhWGAu1rTee6HIIUNyu1bybMK9IRxVhcIA/whB29k88f11eZ5rD3WCRCcBtBscYD7AdY
	1WAv1k7et+RbiMk32aZC7Cj7M3Jv5zH02jUTmSIbJS3xOc6DLQIdsky5RIxEzUbZjh8thNkvv8A
	9+Bh8jPLEkNRVlLc+VOpr6LLoXvpBRwAYf8ejOh39+IRU9K4Fctb5zG/MzfAckah3Y9dbKWwvn9
	V+3VqqIkFf0hwQ1bzcOPWkpcRQDxHDIKl5jp5e2nRxGl3A+XzsS+v5iZ2HMHnbN2zOz74cBPL9q
	SaiHfNSEb0nUDokE/iqdoJ/R47wTaultC/z/DOWl4mApgu02CxBbqqCV/G/3Titt290S
X-Received: by 2002:a05:7301:53c3:b0:380:f8fd:d19b with SMTP id 5a478bee46e88-3856fb693d7mr13310163eec.38.1795443413871;
        Mon, 23 Nov 2026 06:16:53 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386b9bdafb5sm3063417eec.9.2026.11.23.06.16.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:16:53 -0800 (PST)
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
Subject: [PATCH v5 05/19] mm/swap: change the swapon lock into a percpu rwsem
Date: Mon, 23 Nov 2026 22:16:42 +0800
Message-ID: <4f355219f202e5fce9e8dac7dee75f3ea7c51d4e.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gooaqyuzhzkffyzjmc4qemmb533895z8
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48CE3C001A
X-HE-Tag: 1795443415-925714
X-HE-Meta: U2FsdGVkX1/e93hwxFBPQsEfmtuQ+FKYFCreTw8SmBU81JUeDvGrS433mLGHTrxVCgxS9R6WGMrEwO1UWmeKLAzynQJl2zXCMTRJLTh0tTCeYgHm7jgZJuacsCP0oageiz60RfIOpXOG7mK69VGtCy13wzUsrlbqU3hZFIiO/NkqvU6LJSm6oho7n90TXpIVztiiK5RNuz/F76EQvqnbnWQ5YojgwI5jV4E9MVF+8EHKZG6o1idM7H0I6W/emzliSxPP4Dtycmesflw88nez7h0RRoUDaLk0H0EtvMxpKgxOp3yJfnKEJESyu2Zcj2B7McbfIn5zoKJIC1+zBca5Hau/e48NmaRiup6pNW+nTDsN8RttWyjL701pjjiQPNhpQBUVYMBid18HfmIMUJUcZqfvoaOc+0ofKQMkkz8kfRH7y8IOXv/aKbowKF1vlROog4sBMe0Ct1QctaBckmPUx2/3G+Db8dWuGlfIdMGekZDF0D6030jwxDfWrI3s/hexH+bAEdf843UeFCNFKivJUudwmdo027tPzgop7LfJ8geH1DCz0oUxEZaMEip4lPxe+TPril0NyeJ2kNQ46pxh0QtHMyZVj4mDmIj97h6CJWX/aBxSS3O1j+JywnEeuZbQJHj1592gvZciSFdWLqSycIJ0/iSOXTgV0aXtRPh6ZrVhCPuqdQ+cDrXGATQulQ4TBV2ylzFmuG3aowTYCClODIF6M6e8VH00Yd+BsYISEDlZDOq0jiYuSWL3+wDsHJsxYrmvedh9i/pYo5a1F5RpDBQ8IrjnvpE3qV3AbeiKX32n3hoJHYscbmUDB+MD2xRcidOoK4COLa4VkffBn5CkQLajVIvF2nufBoqvOPoIZciFwtNOx3YKOsutvX/4xhgcUZ7FLRC38WsP3DubPZAnAwv+5rEgUHSySpvEGRdgKUeV6gS2Yl+WfMVuOZZreXaA9rmKMTOTcE5RPoCo4k1
 ktRopA8Q
 PjnODwrV8+6+E7hS25hXwutv7FU7okdUlJExzMcRzRxXAsmFI5Jat0VWaUD9lgcQ+xKO3YHcZGfJME+7Haqm4vqCZjCFmcrIMPeY2iu85EfdsxGkiGh7xdmToLCJE7dd8DbU20cpuustMINfHMYar+EY6gsG+q2VfDtPD0lhNcLHLuMMaeJ5us4NUGbV8ogdU//dQR+OLCV6LHwDA2Vl9m4KYbAgtirwvmeLrDjHTt6i3PGtPCN1aeuLmb9dQ4L/qz4w2/tS3ugDp9ugX43qGbqNmdHGM27gYbjyU+OLsVDZ26cQKCUOAPGI6nq4rBFfmlc77Asm6wIumLA0Mkr+8E9ZkgitKJAV6KI2TRUolT0diG+75eX4R+NVD7fHuKEKoXf+GwU9eiznWFBjjh6PibepBuUKl2H8asb+KmpdKsyf/roA3rr4Bd1o/PspJR7izutpaPIERcQUILr2QrdSSbkB3osrN30EbHMb3MR5C4gAIA4avJ7oeD8vd6gycHivQ1IawGDmCYYM0oFIwWrwKmvUmDhjmIKBv069dWJX013cVUp1WR3nkEu4VrmxU5XlYfmboodL1tmL5KLFahdql0bsenEL4gQXG7ta9QtsWTMxtaxuTwse7i6Tw8dgfmsvvHY5R6Li+R4bdOKOGotjqrdEpr53AHM4XSbUL/X348XaK0WT2xr8u3R1FuJQCNf9htXYExdnAas4xCQa1Monv3cx7SxXn1F9hIEjuAgiHuyeJHxVVGIPx0Mp80w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Reading swap metadata is a common hot path, while swapon and swapoff
are costly and rare. Convert swap_lock from a spinlock to the
swapon_rwsem percpu rwsem so metadata readers can run concurrently.
Writers still serialize topology changes and exclude readers.

Preserve the atomic writable/off-list/available-list transition under
swap_avail_lock. The device-selection and cluster-allocation paths do
not yet hold swapon_rwsem; the priority queue patch adds that allocation
reader protocol.

Also update the comments in swap_info_struct to reflect the lock
name change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  10 ++--
 mm/swapfile.c        | 126 ++++++++++++++++++++++---------------------
 2 files changed, 69 insertions(+), 67 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0fa77f5679a2..717387e16a2d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -192,18 +192,18 @@ struct swap_extent {
  * Swap device flags, except the ones documented below, all are immutable
  * after exposed by swap_device_enable, and until the device is freed again
  * (SWP_USED unset), except that teardown clears SWP_ACTIVATED after draining
- * allocators and live references. The other exceptions:
- * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. Once
+ * allocators and live references. The other exceptions use swapon_rwsem:
+ * - SWP_USED: Protected by swapon_rwsem. Indicates the device is inuse. Once
  *   set, won't be cleared unless all reference to this device is freed and
  *   swapoff finished.
- * - SWP_WRITEOK: Protected by swap_lock, si->lock and swap_avail_lock.
+ * - SWP_WRITEOK: Protected by swapon_rwsem, si->lock and swap_avail_lock.
  *   Clearing this flag is followed by waiting for all current cluster lock
  *   users to exit, so
  *   checking this flag while holding any of these locks ensures the device
  *   is safe to use at the moment. Note: clearing this flag doesn't affect
  *   pending IO or async requests, it only prevents further entry allocation
  *   or new async request (e.g. discard) from initiating.
- * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
+ * - SWP_HIBERNATION: Protected by swapon_rwsem. Indicates if the device
  *   is pinned for hibernation.
  */
 enum {
@@ -276,7 +276,7 @@ struct swap_info_struct {
 	spinlock_t lock;		/*
 					 * Protect cluster lists. Other fields
 					 * are only changed at swapon/swapoff,
-					 * so are protected by swap_lock.
+					 * so are protected by swapon_rwsem.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 56b75770d320..7a97cfd8d009 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -57,23 +57,28 @@ static void move_cluster(struct swap_info_struct *si,
 			 enum swap_cluster_flags new_flags);
 
 /*
- * Protects the swap_info array, and the SWP_USED flag. swap_info contains
- * lazily allocated & freed swap device info struts, and SWP_USED indicates
- * which device is used, ~SWP_USED devices and can be reused.
- *
- * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
+ * Serializes swapon/swapoff (writers) and protects the swap_info
+ * array, nr_swapfiles, total_swap_pages, and part of swap device
+ * info content (see comment of swap_info_struct). Read-side users
+ * take percpu_down_read() while inspecting this protected state.
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
@@ -85,7 +90,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
 
 /*
  * all active swap_info_structs
- * protected with swap_lock, and ordered by priority.
+ * protected with swapon_rwsem, and ordered by priority.
  */
 static PLIST_HEAD(swap_active_head);
 
@@ -95,20 +100,18 @@ static PLIST_HEAD(swap_active_head);
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
 
@@ -128,7 +131,7 @@ static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
  * for_each_swap_info - iterate over all allocated swap descriptors
  * @si: the iterator
  *
- * Context: The caller must hold swap_lock. The lock may be dropped during
+ * Context: The caller must hold swapon_rwsem. The lock may be dropped during
  * the loop body but must be re-acquired before the next iteration.
  */
 #define for_each_swap_info(si) __for_each_swap(si, 0)
@@ -1309,7 +1312,7 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 					     pages | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
 	} else {
-		lockdep_assert_held(&swap_lock);
+		lockdep_assert_held_write(&swapon_rwsem);
 		lockdep_assert_held(&si->lock);
 		si->flags &= ~SWP_WRITEOK;
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
@@ -1441,10 +1444,10 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1529,10 +1532,10 @@ static bool swap_sync_discard(void)
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
@@ -1541,11 +1544,11 @@ static bool swap_sync_discard(void)
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
@@ -2349,7 +2352,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	int ret;
 	struct swap_info_struct *si;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	ret = __find_hibernation_swap_type(device, offset);
 	if (ret < 0)
 		goto out;
@@ -2373,7 +2376,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	si->flags |= SWP_HIBERNATION;
 
 out:
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	return ret;
 }
 
@@ -2385,7 +2388,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
  *
  * Look up the swap device for @device/@offset and atomically transfer
  * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
- * all under a single swap_lock critical section. This closes the
+ * all under a single swapon_rwsem writer section. This closes the
  * swapoff() window that exists when callers unpin and re-pin in two
  * separate operations.
  *
@@ -2405,28 +2408,28 @@ int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
 	struct swap_info_struct *old_si, *new_si;
 	int new_type;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 
 	new_type = __find_hibernation_swap_type(device, offset);
 	if (new_type < 0) {
-		spin_unlock(&swap_lock);
+		percpu_up_write(&swapon_rwsem);
 		return new_type;
 	}
 
 	new_si = swap_type_to_info(new_type);
 	if (WARN_ON_ONCE(!new_si)) {
-		spin_unlock(&swap_lock);
+		percpu_up_write(&swapon_rwsem);
 		return -ENODEV;
 	}
 
 	old_si = swap_type_to_info(old_type);
 	if (new_si == old_si) {
-		spin_unlock(&swap_lock);
+		percpu_up_write(&swapon_rwsem);
 		return new_type;
 	}
 
 	if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
+		percpu_up_write(&swapon_rwsem);
 		return -EBUSY;
 	}
 
@@ -2434,7 +2437,7 @@ int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
 		old_si->flags &= ~SWP_HIBERNATION;
 	new_si->flags |= SWP_HIBERNATION;
 
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	return new_type;
 }
 
@@ -2452,11 +2455,11 @@ void unpin_hibernation_swap_type(int type)
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
@@ -2481,9 +2484,9 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 {
 	int type;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	type = __find_hibernation_swap_type(device, offset);
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 
 	return type;
 }
@@ -2493,13 +2496,13 @@ int find_first_swap(dev_t *device)
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
 
@@ -2528,7 +2531,7 @@ unsigned int count_swap_pages(int type, int free)
 {
 	unsigned int n = 0;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	if ((unsigned int)type < nr_swapfiles) {
 		struct swap_info_struct *sis = swap_info[type];
 
@@ -2540,7 +2543,7 @@ unsigned int count_swap_pages(int type, int free)
 		}
 		spin_unlock(&sis->lock);
 	}
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 	return n;
 }
 #endif /* CONFIG_HIBERNATION */
@@ -2866,10 +2869,10 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	unsigned long swp_tb;
 
 	/*
-	 * No need for swap_lock here: we're just looking
+	 * No need for swapon_rwsem here: we're just looking
 	 * for whether an entry is in use, not modifying it; false
 	 * hits are okay, and sys_swapoff() has already prevented new
-	 * allocations from this area (while holding swap_lock).
+	 * allocations from this area (while holding swapon_rwsem).
 	 */
 	i = prev + 1;
 	while (i < si->max) {
@@ -3007,8 +3010,8 @@ static int try_to_unuse(unsigned int type)
 
 /*
  * After a successful try_to_unuse, if no swap is now in use, we know
- * we can empty the mmlist.  swap_lock must be held on entry and exit.
- * Note that mmlist_lock nests inside swap_lock, and an mm must be
+ * we can empty the mmlist. swapon_rwsem must be held on entry and exit.
+ * Note that mmlist_lock nests inside swapon_rwsem, and an mm must be
  * added to the mmlist just after page_duplicate - before would be racy.
  */
 static void drain_mmlist(void)
@@ -3160,8 +3163,7 @@ static int setup_swap_extents(struct swap_info_struct *sis,
  */
 static void swap_device_enable(struct swap_info_struct *si)
 {
-	spin_lock(&swap_lock);
-
+	percpu_down_write(&swapon_rwsem);
 	spin_lock(&si->lock);
 	spin_lock(&swap_avail_lock);
 	si->flags |= SWP_WRITEOK;
@@ -3171,7 +3173,7 @@ static void swap_device_enable(struct swap_info_struct *si)
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 
 	add_to_avail_list(si);
 }
@@ -3184,7 +3186,7 @@ static int swap_device_disable(struct address_space *mapping,
 	unsigned long offset, end;
 	int err = -EINVAL;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if ((si->flags & SWP_WRITEOK) &&
 		    si->swap_file->f_mapping == mapping) {
@@ -3220,12 +3222,12 @@ static int swap_device_disable(struct address_space *mapping,
 
 	end = ALIGN(si->max, SWAPFILE_CLUSTER);
 unlock:
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	if (err)
 		return err;
 
 	/*
-	 * The swap allocator doesn't take swap_lock. Looping through every
+	 * The swap allocator doesn't take swapon_rwsem. Looping through every
 	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
 	 * the updated flag and that no allocation remains in flight.
 	 */
@@ -3339,7 +3341,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
 
@@ -3350,7 +3352,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
@@ -3370,9 +3372,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	 * can reuse this swap_info in alloc_swap_info() safely.  It is ok to
 	 * not hold p->lock after we cleared its SWP_WRITEOK.
 	 */
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	p->flags = 0;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
@@ -3532,13 +3534,13 @@ static struct swap_info_struct *alloc_swap_info(void)
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
@@ -3563,7 +3565,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	plist_node_init(&p->list, 0);
 	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	if (defer) {
 		percpu_ref_exit(&defer->users);
 		kvfree(defer);
@@ -3999,9 +4001,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -4019,7 +4021,7 @@ void si_swapinfo(struct sysinfo *val)
 	struct swap_info_struct *si;
 	unsigned long nr_to_be_unused = 0;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	for_each_swap_info(si) {
 		unsigned long flags = READ_ONCE(si->flags);
 
@@ -4028,7 +4030,7 @@ void si_swapinfo(struct sysinfo *val)
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
 	val->totalswap = total_swap_pages + nr_to_be_unused;
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 }
 
 /*

