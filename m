Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D444D606A337
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gmjhWrAd
Received: by kanga.kvack.org (Postfix)
	id CCD886B0809; Tue, 27 Oct 2026 12:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7DE96B080B; Tue, 27 Oct 2026 12:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E8A6B080C; Tue, 27 Oct 2026 12:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 843AF6B0809
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:06:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2895140A5A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:06:19 +0000 (UTC)
X-FDA: 85368883278.29.9C79DAD
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 31F47180010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:06:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gmjhWrAd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qII63eC0LU7E+F5t8Bg2YK08YX0cPPryRBRU+kP6RuA=;
	b=tsoDrJ7b5cveqEFP1nhzSxibd+chdrlUUVYzc1Di4t0oGMuraJtMdv1JJbBZ7EL1vk5248
	BdHkGeLG6xOrSFK0/sZHCHvX4nOmE4xXA0Adeh5mcfJPhcg3azyBgfzKDQPLXGpthE7zhW
	k03qIo1ehHtf3LpdNckb79Mm9OpZ3ik=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gmjhWrAd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117178;
	b=DYtayokSm4NYPzRCAyaEFbFyZetUdzJjllEdj9ZMftHW/ITCLi2MJLHfzAQJPyF2N4W2bJ
	a+vB9LpjdNYgFVMWURgELcCwNzc8tJzIlRmE2tC//WeQpelTjxgmV8V0LT0HjjaYZQg5+y
	mS2ElOHtjiScWbviD3kMoFoSmBBu/gA=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a064dcfcfdso28021b3a.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117177; x=1793721977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qII63eC0LU7E+F5t8Bg2YK08YX0cPPryRBRU+kP6RuA=;
        b=gmjhWrAdRxfVnroPJF1jdOpIGRZsft7kepP6WacEJdNX0Rpfe8FiXx8MII/Mu0+T5u
         igL6sL3dx2VuFY4Cqzyj7iO1NcZP4uq1lcmf+uA6KDgTukHNpER28K9uSS2QCD9FebHl
         Z0mLNtwm0PZzfb4on3p5LzlNJzKjbSYP0RTk3u+swJHBJvkiwcLQLmLa+ixcsJEs9Q8k
         5By6vTHg29FRkSo86pXvnsdjNOxVelCjfugpHNZItoWzmwvfe6m4MHfErNsOq4+b33VX
         VcdpK+fuF8muU/pDOtl+Kcw69v8JgvfjSjP3vLpE1cI1+xJrM1s+DtPq+YAK+S0focul
         MIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117177; x=1793721977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qII63eC0LU7E+F5t8Bg2YK08YX0cPPryRBRU+kP6RuA=;
        b=zdEmAFVstxYhg2asubBJOulHpO7jzf+D+fp4fu3RkbhEoTXLkGRKZWetmXyTYBjqK7
         IRVshMTHDb3IVcgPsgsqlEP7zGdjCJW4dIFp/ZAiEoQPtrNIv8n8HIZpuxsw6cxOMaij
         catYj4S1YhrXWwBa0OIsd4EjX6BPzfx1OjK7i2F2ZFyyUeJ0dixrKQeyfYRQqmsS0hsk
         Ur9Z3LrkHTOknAvYByWPygsyGq8S851KkV5WLfGCdLR9bTieQiaFrDhtLBonA3iVVIXA
         TXZJSRGjURvEkpDPIdD2ur5Z7FqLVpe9CZ+8EH+jGnc6pujXKhlu+uiaOK2qSF9q/+bz
         BXNw==
X-Gm-Message-State: AFq9FYL6hWs9jyO88c6AgtFxVs8faQM4Dk+LTKXt2eHPSMO+nqAtdmHA
	RoKGfp4exUv2YziZBM/JZenS53GSdz7c3D1gLBgQPorZA5fizVmaTIi6OpGspQ==
X-Gm-Gg: AYBFou0bLPG/MbhtE/MOPK8wlptW7U9cURN14G79yYE7yhm3rMLhSxevO3qT8L0VzMr
	/Sd5Dcirw02YuwHSoPbLbPKKXZM/RSoAMyp4e+A8mlbqr33LjGYzh1Paa3/IjlVzsN1rC19Ap94
	U/PilrZnHMi1VKtOgbw/9AwKbL6phwimafn4e2nKG0waP6UG5slwO7o0i+FMVlZ/P+iucSqEOkr
	suNuGNZhLnNRIyhuFv4KvZVKcGW+HRaKm3FFYpGD7mi3xGHzQCdQCfFp3EQgBqK1q7eWZKreIwS
	D2nMOxCV3WJ0V9yPubbi9q+6NFevBeC22byTSIh8dUhuq/JrSjKjpeIFqzUzL5XWfIyNbI94jPj
	kdeQMfEL4CP2ji0Jsnl34znqN4K9MzrH66oQfzxVT+ozloW70TVHHQ63sjAP0Ne4dKZDbutwAtI
	bFf4958fjVVqs1qpny3sl+JkcoigyAfuYe7eun097P4uxkzwt1UDW76k6AlEz/rXg2vIuWbUBSK
	0jtlbNm1poIpD5oJTHhHSi/wG3GEdcMClj/46lBLjuAiaaBscQlQSfy8nZug+FonrL9XDFxi7Zh
	d4J87W/wgCDQklNQ43M=
X-Received: by 2002:a05:6a21:a109:b0:3de:74ee:c045 with SMTP id adf61e73a8af0-3e7af7e9aebmr7586844637.7.1793117176871;
        Tue, 27 Oct 2026 09:06:16 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a0d983ebsm306033b3a.0.2026.10.27.09.06.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:06:16 -0700 (PDT)
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
Subject: [RFC PATCH v3 05/18] mm/swap: change the swapon lock into a percpu rwsem
Date: Wed, 28 Oct 2026 00:05:48 +0800
Message-ID: <d7120017ded998ca722ed78e1995f0d1af82e88c.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31F47180010
X-Stat-Signature: 1qseem77sfgw3ccn4wn1bqh7h368a3rt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117178-985518
X-HE-Meta: U2FsdGVkX18XjZhkP9YRz7/C3KMUq+SmEHNg9qCi31Tj7ryfpWmUV5g7jzRmGrxlvquDnZquzOmF4jF0czT6iFwPoyXtdAVkPNV5kThuiRMlaItcbx0sbrMuo7pu8y5nPxlrw01tT+eLRw8BvpbwRKWQSuIsOVnR2bKE4Iu/wM9wLlYSPYUYk3n2vlN1Nj0V7h46cwOhzpB+cdcQqtHE9Tmud9WC2Wda7uwa9IkbAKDjZ0nngzg33nZWXkC2BC1xGLXCiti6vYzqMO3bbf2VCK4RuwJD7DBIJgkcMK1mfvgtE3iwNr7JGYqiNXU7jHsBK2Z2Wf5f+4cCVVcl6f0DelzPMFMtR5s94zjKP+jjNrb4iopiB2YSLtleNfRzjcbRsc4GdHwrbvFO+0nrdK4MEQKyx4qzMl+1vyAJasGR0r5nsNez4cbWdg6slaVRfBDkP8gM5v7fiHwR1Gl6q0+gSFhrGJDZStv3C5s08pK7/VaXgGP1MtYVSGc4sSYwqdNe7UNcX8Fp3PmOD/T0eGAjSneSMVq3XGjpp9iGDjsGAL2H5JjLle8H0N6/cddrPByqPaIN1e66++kmkNdMoRZs17/g3tapKTJcOGozi3WI0kvV+QjwGUAuwUTg4SPAzEd1zgPiD1P+G1BBNQoABfw33XB5GgO5FDdwLdu6x8FQTB/VhwyQHikRPQBPcrxA4M4AehrgFuiU5fH2tk9z/yF3WK8pq3ApuUM38tFsAvD95gsDsACL2YuL3Ra97nCBphxE9ll5UY/GULFuV3ui+bT9G6xh/GhF4bsf22go1hSFr7Dl0/Rc0cQFqy0ZYV+87D5OOUfcky7E5nrr5r/k5DDnb6XzKX40YueM0BUL8C661VhIKhwd2T3+iqd1Xr2kqVdnXa5IMeOWnAiGnTacY+J/k3Bf4ALsu+tw2kwFt1jrvmtUYGOf/0cX00bLQszZC9/P2QJBkvzcL5uIQghzq2i
 SrwkP2vq
 DiqStoVGj8M/gn+jTzyxoST6ygby4wmiGO6ky7yc1fBEyeGpeMKhuURr5aaV6S40d4nlRvu27XaDf2/ndsdiqwjiIECUn/03AKXlx6igt3GDtucKb2pcpK3ZRbRDb7AZBhW2n0P4RLOXoFqTqZigifLVBGEHwEBs3Qg6TdOCdw4pZQpm5tiTzffL0M5MBkmLS1Wndp6+DwSLS/bW3P1oa5smovsmqAGlJ+B+5pdLpGqPQHvG3DnV5JEprL4W1KJvyTXJKBzyuVhg54moaRkVZxl5FlqmKgGEUeNHTgGFAPGSbODDVXCDmHaGs2s8ORJOdxX1aLSjmwAsg2OM7DPzWtVDQLQoP+5Tyh0YO7B7289k5M2KtlcMho1Soxk7R9xGuGoOUW7aRruDgseTGJd0lg8mbRkG6LIQ7DFzf83lNri98JN+zu0p9IR1ihSQrRtI/yswthc/+VoFHUksBRUUJurAr4p+XiiK9dpigUtBOAYOo0nu3hijeuzf/uVspIaxHyJT7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  10 ++--
 mm/swapfile.c        | 129 +++++++++++++++++++++++--------------------
 2 files changed, 73 insertions(+), 66 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 66b8e602178d..80a14a8daba2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -191,17 +191,17 @@ struct swap_extent {
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
@@ -274,7 +274,7 @@ struct swap_info_struct {
 	spinlock_t lock;		/*
 					 * Protect cluster lists. Other fields
 					 * are only changed at swapon/swapoff,
-					 * so are protected by swap_lock.
+					 * so are protected by swapon_rwsem.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b72f4fc3e811..4ffde6827d44 100644
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
@@ -1377,10 +1381,10 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1465,10 +1469,10 @@ static bool swap_sync_discard(void)
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
@@ -1477,11 +1481,11 @@ start_over:
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
@@ -2294,7 +2298,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	int ret;
 	struct swap_info_struct *si;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	ret = __find_hibernation_swap_type(device, offset);
 	if (ret < 0)
 		goto out;
@@ -2318,7 +2322,7 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	si->flags |= SWP_HIBERNATION;
 
 out:
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	return ret;
 }
 
@@ -2330,7 +2334,7 @@ out:
  *
  * Look up the swap device for @device/@offset and atomically transfer
  * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
- * all under a single swap_lock critical section. This closes the
+ * all under a single swapon_rwsem writer section. This closes the
  * swapoff() window that exists when callers unpin and re-pin in two
  * separate operations.
  *
@@ -2350,28 +2354,28 @@ int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
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
 
@@ -2379,7 +2383,7 @@ int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
 		old_si->flags &= ~SWP_HIBERNATION;
 	new_si->flags |= SWP_HIBERNATION;
 
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	return new_type;
 }
 
@@ -2397,11 +2401,11 @@ void unpin_hibernation_swap_type(int type)
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
@@ -2426,9 +2430,9 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 {
 	int type;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	type = __find_hibernation_swap_type(device, offset);
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 
 	return type;
 }
@@ -2438,13 +2442,13 @@ int find_first_swap(dev_t *device)
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
 
@@ -2473,7 +2477,7 @@ unsigned int count_swap_pages(int type, int free)
 {
 	unsigned int n = 0;
 
-	spin_lock(&swap_lock);
+	percpu_down_read(&swapon_rwsem);
 	if ((unsigned int)type < nr_swapfiles) {
 		struct swap_info_struct *sis = swap_info[type];
 
@@ -2485,7 +2489,7 @@ unsigned int count_swap_pages(int type, int free)
 		}
 		spin_unlock(&sis->lock);
 	}
-	spin_unlock(&swap_lock);
+	percpu_up_read(&swapon_rwsem);
 	return n;
 }
 #endif /* CONFIG_HIBERNATION */
@@ -2801,10 +2805,10 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
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
@@ -2942,8 +2946,8 @@ success:
 
 /*
  * After a successful try_to_unuse, if no swap is now in use, we know
- * we can empty the mmlist.  swap_lock must be held on entry and exit.
- * Note that mmlist_lock nests inside swap_lock, and an mm must be
+ * we can empty the mmlist. swapon_rwsem must be held on entry and exit.
+ * Note that mmlist_lock nests inside swapon_rwsem, and an mm must be
  * added to the mmlist just after page_duplicate - before would be racy.
  */
 static void drain_mmlist(void)
@@ -3095,8 +3099,7 @@ static int setup_swap_extents(struct swap_info_struct *sis,
  */
 static void swap_device_enable(struct swap_info_struct *si)
 {
-	spin_lock(&swap_lock);
-
+	percpu_down_write(&swapon_rwsem);
 	spin_lock(&swap_avail_lock);
 	si->flags |= SWP_WRITEOK;
 	spin_unlock(&swap_avail_lock);
@@ -3104,7 +3107,7 @@ static void swap_device_enable(struct swap_info_struct *si)
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 
 	add_to_avail_list(si);
 }
@@ -3117,7 +3120,7 @@ static int swap_device_disable(struct address_space *mapping,
 	unsigned long offset, end;
 	int err = -EINVAL;
 
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if ((si->flags & SWP_WRITEOK) &&
 		    si->swap_file->f_mapping == mapping) {
@@ -3152,14 +3155,14 @@ static int swap_device_disable(struct address_space *mapping,
 
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
@@ -3273,7 +3276,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
-	spin_lock(&swap_lock);
+	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
 
@@ -3284,7 +3287,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->max = 0;
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
@@ -3303,10 +3306,14 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3466,13 +3473,13 @@ static struct swap_info_struct *alloc_swap_info(void)
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
@@ -3497,7 +3504,7 @@ static struct swap_info_struct *alloc_swap_info(void)
 	plist_node_init(&p->list, 0);
 	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
-	spin_unlock(&swap_lock);
+	percpu_up_write(&swapon_rwsem);
 	if (defer) {
 		percpu_ref_exit(&defer->users);
 		kvfree(defer);
@@ -3933,9 +3940,9 @@ bad_swap:
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
@@ -3953,14 +3960,14 @@ void si_swapinfo(struct sysinfo *val)
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

