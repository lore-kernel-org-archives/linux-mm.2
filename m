Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA99060A2614
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zXYrEhbC
Received: by kanga.kvack.org (Postfix)
	id F14E26B0806; Tue, 27 Oct 2026 12:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E946B0807; Tue, 27 Oct 2026 12:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66216B0808; Tue, 27 Oct 2026 12:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A81576B0806
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:04:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADE16160AAE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:04:51 +0000 (UTC)
X-FDA: 85368879582.19.5347F68
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4665A0012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:04:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zXYrEhbC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MYD44DcHjEZ2ajshlbEu8zM2l23xxTluRkoB1K/Gu4=;
	b=WQUpvaug6uvnF8yzVQP1H5kd/M4H3CKoByQTbQw9zU8hVdrs8CFV3ESSEz6vPJAYRUhhca
	dUsaC43B2jpxGQxBVTgq99ZMTF11QQH3yjqz4Oms1Vm4taxRa2XlaibVXdne914TjKh0Cy
	41vPi/0ER4vL53FuD5glRs9NBic9Aeg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zXYrEhbC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117089;
	b=o/dvzlkhPC4bd5oPJ7QWTUVMi8bNmXGxV06cZ9njIxInCBs7IGUzn5LXwgyNX58qLpNoXn
	p9PSEjgW8XnqFPd7PQgjCgrCnuICN2bSQ5FTalEdrpZoCeDYJV1fekGHJej1Bh9Y8Z/Xj8
	voZBCcH9eBy3Qr23pY08NugfGugHE1c=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac7c7b3a90so30602a91.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117089; x=1793721889; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+MYD44DcHjEZ2ajshlbEu8zM2l23xxTluRkoB1K/Gu4=;
        b=zXYrEhbCV1GWPnqMi301AuPWYN15xHg/FtTpV7ao2XlpJpz5gUWA6V39HIpkAHIlyg
         UjDe+8N+Yk225lvYumCz75aVkMDAi6ptbbdI0VChINKq3KD916WD9vC1v7W7MubJSAN6
         UEft+3vN60ZKzcVGmAojkq0EmdIL16zI/tecDogEbkkoDHClyJ+XIUNLIzzMib/LKsL4
         f0qBdJPEV954I79Gt3s+gmJquRLDtSGV5Z474oWIn5+MT5J1Kkl7U4ny08gFoVcjvQvk
         fcnFpRqsfo+NDthnQJFMD6w9uFqyB1V2Rf+EBswvqE7fGuwqzMxDthpUAveygMzba8Z4
         tP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117089; x=1793721889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+MYD44DcHjEZ2ajshlbEu8zM2l23xxTluRkoB1K/Gu4=;
        b=Sz8hNYsJwL33jCKQk0waa1Jps4SS/tag+ow/NjG9xmfgLB289eBpkdxY9kZ54G7Fde
         lhJkipEB372Wkbxxoq9T642rIfl3+bMstTxf0KOrnqvSQ7zPFZXlGtP4Hxza85fFiUhW
         lR7g2H/+v3za9OEHqHjeQIKdrfYS7P1PuHuGRVLR+x/EWJpHqEdO0US+ACVPh/aSQ6sG
         4uTf5B+vOqspFcTEU6N+32Wum4i3SgarERw6fWxreIhTmyeBSsjOnXYwZWrAZgjYQXbY
         F5LQcxVie/1Jdo0tnwazCZjwJqc3ce6WhT7Z5yobsmYMSvOa8VB9HcHKU8M5AOjLHgGt
         sTrw==
X-Gm-Message-State: AFq9FYJaKVl6g9i8m1kJbihFc3g13CtvFpb/7wP5SEdlkTrevbFa6/iM
	gN63VJKwPjaAjxgyoimSbuFbTMPOk7BvLjNDi0Br2WbEVQ2/iQVfElA3GT80Pw==
X-Gm-Gg: AYBFou1D+G955MwXV/nhgiTngNSNJ1FCEaFpXGgQLAh9pb5OrC7qp9Vg7y66ozY3Hws
	znMZBzAGGIJC6WWlJl/NAH6gfDK/o8jdS4QOM2clOCDCvk3Mjp8O5VU6Q3XZzbdmS0TVwVJTzEB
	t7rQVALEqi6tnSbXn257T0z/IDc6LG/WOizv23Y3NyMSMdnuSJt1+mki+4hUa0hbyvSO0/6SQZc
	D6r/lZqxuIbA7cUf4ZNfD1J7hyal3HRdijA/kv337oMp0xd9l1Lzh+trIJr9PqXbwb6wDZMIEjx
	UMSLpsQvf4VoJLieIdJu+SBK2MHNw2mKr48O6I1IHkAQ2Brwo5MGCQEgfaCDocmcZYkdLFPEdM7
	vinjISdRkW+MBt4hk7XYaKhCfdA2syY+/RDasSohTMreylfRehpibjBKJiJxt8L62q925M3EVVH
	bov02bQkZXgIWAhol1aZFvGvToSBV02n3E4h/U67yt56sn0D7EJHPsiGAv6LkwFtmdBpXnIsJ1w
	7RdbI3STzg7Uj95KVhx3pfqfGjVPz2O8uGb4aO8ewnHU8VM+yP9I4JM+gnmaKaBKdGFAuyULeRz
	vXHKX2oMAUrIJaT2sYg=
X-Received: by 2002:a17:90a:e187:b0:3ab:b764:826c with SMTP id 98e67ed59e1d1-3adea898711mr8493030a91.12.1793117088477;
        Tue, 27 Oct 2026 09:04:48 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae406361e2sm4290903a91.8.2026.10.27.09.04.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:04:47 -0700 (PDT)
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
Subject: [RFC PATCH v3 03/18] mm/swap: cleanup and document swap device availability flag usage
Date: Wed, 28 Oct 2026 00:04:21 +0800
Message-ID: <c3a660c13ec9a98af8a496b5f9139e73eab5aa3a.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4665A0012
X-Stat-Signature: aa7w841utfqmzfwz3mttqnaxx1e5946b
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117089-289399
X-HE-Meta: U2FsdGVkX19PyTSLx+OGiv3JfnyVYedlqRqa/pMbm/nNUQEua5IEXfba8u/J21syJjXfEbEsWVkLfkznF5vkgZ6yiXPNmRXFQleZzokwNilhw7eHKM0ZCEBlsUfZ/CXjTWMHMAgGIKF9BhoSIhq9P39rvtaz7x8FRxUbBXuaQzQvp2ldH76k6m8ZrzdPQDYi/ucNADuvNBNFpfyF8K86GzhI91rKKXAJwZwnYDtmPHWL0/73wgmYAkeP3ZrCaNzH0yXb4+fO6QCLhkd/Mz3F2qOmC0hrvevhYNLh+Qn0mQkcR6djiMFX5Q2Nkc+DWayym8liB1Cl1bjRShn904v7ri4/FBC9dHjh8yTJE8mfHHZOtlH9ra+CmuU8LMSZ+l8VzI6FDZXPfGwTBnG8LTuz0/sR6xPYyuf9RMXdQb4EnKPgMH3usvNWekCvB1H+ri2UqmCocrvdb8XX9B9vf2Vwe6LLbNQeR8goFEdyhIg305AsDv5SVRDxWA0D4PhNhREZXtNutWW/aYYlDVB54Vwvc7nHnnmU8mpirpAWJfkLPaSVJc+hY8/cOMY8UZeNEledlQ8TAtZMz5aJINHRpngMdA3n+kRE3v9Bj9tTf7Ig7LFRnqBTAZv+WkbBDGASE/wDcZlC47CnpXdVlyjDe4CBgQh5mohvN7mkfUlkrlqyZupznz7ajsPx0+ywt655rQNiCGSlrMScc3070BpiLY8+DTPmgDCa5Q8Q7TV328sWJpB4etZyDxTKH4BefOOQast57bUbzhuuTexJ82Xf6E9QC5Ad/cKXJYk0V319iVfQZ+Rf6AwnAT9g2SBHTwJP8Ti/lJHFoWEZ3h9guI/0dnLtOBScZmfAH7YnZ2UmXfgfN2aiIRGZJYke6F3RNGaeY5+4xiCCDAnzY6q89il1556tMKNKg+U3VBwhLXwx+Xzj6ykwOT2yzSQsRiBaSMszL5w9ltXzoXlymxj2YQEl4oH
 SDA8uX8B
 yYBvt7SG87tnWsfZOGCdc6IVQmxoecPl+3fRLZfXi9k+MvfGtfjO61yXUQ39cKWPlJAowQUU7bxtRUiOUFjA12Xfb2FUJq7Lki3B1LdVv+R+K6MUGh70y+jiMpRKiCUa0vDcRB8YclqI6cgd7aBqATMRvnyQXimQDONPLESd21kQpGfAlQSLvH+lNr4gPUEeAwk/bNlUVkfs+tg9H7EPCPEhmumkl6UyaT2JTFlar9WEuPXdyFR2hwuO00dRomkBhfigof6E5Ts3tFsVxMOzKElTFyisd+FKSx5zSFKjvRI9zySiB2CtpEi5DXLNiMaaQ23bAK3gM2DAV+WZBGK2yrsGxOeVQ/x+MWLnHzZcAzxXtwMpPz9hpMghWGdHWYTgxeCDo8xJtF+VckzZTE7UB/nRCbJTBXx5qaSMQBSCLbi9bB8H6W7mrlcYYUJwv+9CulP9bWxBovCoZF5EEI9quiXThmjxv/p4/Oq/W8jW5LC+Vo/gtUQyWD08RkUkTGZanpTki
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Rework swap device flag and metadata handling to make the writable
publication and disable boundaries explicit.

Introduce swap_device_enable() and swap_device_disable(). Move
SWP_WRITEOK updates into these boundaries while keeping availability
updates serialized with swap_avail_lock.

Preserve the existing swap_lock critical section across mapping lookup,
hibernation checks and the disable transition. Drain cluster allocators
after dropping swap_lock, retaining the device-identity protection
without holding swap_lock over all cluster locks.

Document the flag lifetime and locking rules.

Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  27 ++++--
 mm/swapfile.c        | 207 ++++++++++++++++++++-----------------------
 2 files changed, 115 insertions(+), 119 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f..66b8e602178d 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -188,6 +188,22 @@ struct swap_extent {
 	((offsetof(union swap_header, magic.magic) - \
 	  offsetof(union swap_header, info.badpages)) / sizeof(int))
 
+/*
+ * Swap device flags, except the ones documented below, all are immutable
+ * after exposed by swap_device_enable, and until the device is freed again
+ * (SWP_USED unset). The exceptions:
+ * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. Once
+ *   set, won't be cleared unless all reference to this device is freed and
+ *   swapoff finished.
+ * - SWP_WRITEOK: Protected by both swap_lock and swap_avail_lock, clearing
+ *   this flag also waits for all current cluster lock users to exit so
+ *   checking this flag while holding any of these locks ensures the device
+ *   is safe to use at the moment. Note: clearing this flag doesn't affect
+ *   pending IO or async requests, it only prevents further entry allocation
+ *   or new async request (e.g. discard) from initiating.
+ * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
+ *   is pinned for hibernation.
+ */
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
@@ -256,14 +272,9 @@ struct swap_info_struct {
 	struct file *swap_file;		/* seldom referenced */
 	struct completion comp;		/* seldom referenced */
 	spinlock_t lock;		/*
-					 * protect map scan related fields like
-					 * inuse_pages and all cluster lists.
-					 * Other fields are only changed
-					 * at swapon/swapoff, so are protected
-					 * by swap_lock. changing flags need
-					 * hold this lock and swap_lock. If
-					 * both locks need hold, hold swap_lock
-					 * first.
+					 * Protect cluster lists. Other fields
+					 * are only changed at swapon/swapoff,
+					 * so are protected by swap_lock.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cf8c0999655c..4adcfbbb3730 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1207,28 +1207,20 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 
 	spin_lock(&swap_avail_lock);
 
-	if (swapoff) {
-		/*
-		 * Forcefully remove it. Clear the SWP_WRITEOK flags for
-		 * swapoff here so it's synchronized by both si->lock and
-		 * swap_avail_lock, to ensure the result can be seen by
-		 * add_to_avail_list.
-		 */
-		lockdep_assert_held(&si->lock);
-		si->flags &= ~SWP_WRITEOK;
-		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
-	} else {
-		/*
-		 * If not called by swapoff, take it off-list only if it's
-		 * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
-		 * si->inuse_pages == pages), any concurrent slot freeing,
-		 * or device already removed from plist by someone else
-		 * will make this return false.
-		 */
+	/*
+	 * Force remove it only for swapoff. Else, take it off-list only if
+	 * it's full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
+	 * si->inuse_pages == pages), so concurrent slot freeing, or
+	 * concurrent list removal will make the cmpxchg fail and skip
+	 * the removal.
+	 */
+	if (!swapoff) {
 		pages = si->pages;
 		if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
 					     pages | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
+	} else {
+		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	}
 
 	plist_del(&si->avail_list, &swap_avail_head);
@@ -1238,21 +1230,21 @@ skip:
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
-static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
+static void add_to_avail_list(struct swap_info_struct *si)
 {
 	long val;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
 
-	/* Corresponding to SWP_WRITEOK clearing in del_from_avail_list */
-	if (swapon) {
-		lockdep_assert_held(&si->lock);
-		si->flags |= SWP_WRITEOK;
-	} else {
-		if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
-			goto skip;
-	}
+	/*
+	 * Add the device to the avail list if SWP_WRITEOK is set and
+	 * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
+	 * SWP_WRITEOK first, so the device won't be re-added after
+	 * swapoff starts unless swap_device_enable resurrects it.
+	 */
+	if (!(si->flags & SWP_WRITEOK))
+		goto skip;
 
 	if (!(atomic_long_read(&si->inuse_pages) & SWAP_USAGE_OFFLIST_BIT))
 		goto skip;
@@ -1308,7 +1300,7 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si, false);
+		add_to_avail_list(si);
 }
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -1360,7 +1352,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	 * up to dated.
 	 *
 	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * enable_swap_info(), and smp_wmb() in swapoff.
+	 * swap_device_enable(), and smp_wmb() in swapoff.
 	 */
 	smp_rmb();
 	return true;
@@ -3078,58 +3070,87 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void _enable_swap_info(struct swap_info_struct *si)
+/*
+ * Mark a fully initialized swap device writable and expose it to the
+ * allocator. The caller must have resurrected its percpu ref first.
+ */
+static void swap_device_enable(struct swap_info_struct *si)
 {
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
+	spin_lock(&swap_lock);
 
-	assert_spin_locked(&swap_lock);
+	spin_lock(&swap_avail_lock);
+	si->flags |= SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
 
+	atomic_long_add(si->pages, &nr_swap_pages);
+	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
+	spin_unlock(&swap_lock);
 
-	/* Add back to available list */
-	add_to_avail_list(si, true);
+	add_to_avail_list(si);
 }
 
-/*
- * Called after the swap device is ready, resurrect its percpu ref, it's now
- * safe to reference it. Add it to the list to expose it to the allocator.
- */
-static void enable_swap_info(struct swap_info_struct *si)
+static int swap_device_disable(struct address_space *mapping,
+			       struct swap_info_struct **swap_info)
 {
-	percpu_ref_resurrect(&si->users);
-	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	_enable_swap_info(si);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset, end;
+	int err = -EINVAL;
 
-static void reinsert_swap_info(struct swap_info_struct *si)
-{
 	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	_enable_swap_info(si);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    si->swap_file->f_mapping == mapping) {
+			err = 0;
+			break;
+		}
+	}
+	if (err)
+		goto unlock;
 
-/*
- * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
- * see the updated flags, so there will be no more allocations.
- */
-static void wait_for_allocation(struct swap_info_struct *si)
-{
-	unsigned long offset;
-	unsigned long end = ALIGN(si->max, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *ci;
+	/*
+	 * Refuse swapoff while the device is pinned for hibernation.
+	 */
+	if (si->flags & SWP_HIBERNATION) {
+		err = -EBUSY;
+		goto unlock;
+	}
 
-	BUG_ON(si->flags & SWP_WRITEOK);
+	if (security_vm_enough_memory_mm(current->mm, si->pages)) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+	vm_unacct_memory(si->pages);
 
+	spin_lock(&swap_avail_lock);
+	si->flags &= ~SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
+
+	plist_del(&si->list, &swap_active_head);
+	total_swap_pages -= si->pages;
+	atomic_long_sub(si->pages, &nr_swap_pages);
+
+	end = ALIGN(si->max, SWAPFILE_CLUSTER);
+unlock:
+	spin_unlock(&swap_lock);
+	if (err)
+		return err;
+
+	del_from_avail_list(si, true);
+
+	/*
+	 * The swap allocator doesn't take swap_lock. Looping through every
+	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
+	 * the updated flag and that no allocation remains in flight.
+	 */
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
 	}
+
+	*swap_info = si;
+	return 0;
 }
 
 static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
@@ -3174,7 +3195,6 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	}
 }
 
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3183,7 +3203,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	unsigned int maxpages;
-	int err, found = 0;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3196,44 +3216,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		return PTR_ERR(victim);
 
 	mapping = victim->f_mapping;
-	spin_lock(&swap_lock);
-	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
-				found = 1;
-				break;
-			}
-		}
-	}
-	if (!found) {
-		err = -EINVAL;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	/* Refuse swapoff while the device is pinned for hibernation */
-	if (p->flags & SWP_HIBERNATION) {
-		err = -EBUSY;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else {
-		err = -ENOMEM;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-	spin_lock(&p->lock);
-	del_from_avail_list(p, true);
-	plist_del(&p->list, &swap_active_head);
-	atomic_long_sub(p->pages, &nr_swap_pages);
-	total_swap_pages -= p->pages;
-	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	err = swap_device_disable(mapping, &p);
+	filp_close(victim, NULL);
 
-	wait_for_allocation(p);
+	if (err)
+		return err;
 
 	set_current_oom_origin();
 	err = try_to_unuse(p->type);
@@ -3241,8 +3228,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
-		reinsert_swap_info(p);
-		goto out_dput;
+		swap_device_enable(p);
+		return err;
 	}
 
 	/*
@@ -3302,13 +3289,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 
-	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-out_dput:
-	filp_close(victim, NULL);
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -3730,7 +3714,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/*
 	 * Allocate or reuse existing !SWP_USED swap_info. The returned
 	 * si will stay in a dying status, so nothing will access its content
-	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 * until swap_device_enable resurrects its percpu ref and expose it.
 	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
@@ -3898,7 +3882,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si);
+	percpu_ref_resurrect(&si->users);
+	swap_device_enable(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,

