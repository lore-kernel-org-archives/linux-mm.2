Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5F7606A334
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FokoqItb
Received: by kanga.kvack.org (Postfix)
	id 986256B05B4; Sat, 14 Nov 2026 09:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90EBE6B05B5; Sat, 14 Nov 2026 09:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFDF6B05B6; Sat, 14 Nov 2026 09:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC206B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:49:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA52740437
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:33 +0000 (UTC)
X-FDA: 85434008226.10.63503F5
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 22DF3140002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FokoqItb;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zsv9HGXHbyLnkcDU2zt1igJ5V9nfJ69+G3P+KAc7LhE=;
	b=0Ukc7ejpnleAtWAHzUsKCzoqZ0hQL534uLkXUnzslLtUjTz4CleqeqZb6M8t6YXWOwDeAQ
	IvwibCjZV6SLFhq5EubhpQ/s9s1BOWSRH+679vjPrqnUAc7V/VIBdQRPdKpBWIPR17u0FS
	hPcGICcSRzdPjFAndRxUxmHLTLknqIg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667772;
	b=2nLdHzpbRuA+uCP89WvrKfZM9/M0LeiOGEjlI9Xt9Q1WvR8jBmVo9JfLNwCmhbKDJaCJu3
	9OHH0yzc2hoar6DJq8u+p+U80m+S+r4uBoWfUF88c0vqhZJYbGTgsmWY456PPNPZAVn/LV
	gQWI/+Q9oxgAUWHvwVs6TgOHS9vgL9U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FokoqItb;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdb628232d2so1953093a12.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667771; x=1795272571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zsv9HGXHbyLnkcDU2zt1igJ5V9nfJ69+G3P+KAc7LhE=;
        b=FokoqItbq+AnGtNE7ehmKfAYHTUECDhR6WKCttpr5bpFCEvcSer0GoNEEMxHejoNNg
         JMNhpeUC9HJB/hC9raSrT+AD+7kiyTAjMTDmqU/Ttsy7OcX7wQ2vj7gwaHDMMLUQjYFQ
         614i0kIA1Kok7+XPbZJsL6HWZANGiuw9DFCheHpXjLJi4qYTfMplnXmVDmj4vCwm62m3
         c9y3e2oef4AU/xN7ujd70tuP43u0pbraLOLdoruHI7UpYhQ3FNb0gTMFdi/RmgX2YuPr
         dFQMfakY1HE6Kopsc2zaC1+aQUYebtMFYknkm9rDlqy28Mnp9+BRPVmQ/K/wD/Q68cN+
         dYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667771; x=1795272571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zsv9HGXHbyLnkcDU2zt1igJ5V9nfJ69+G3P+KAc7LhE=;
        b=nN2gAucy+ySww3QpdOVJjSc082r0AMTNms1o5vGMnjQc2mRi/ETormIJM2odW/WOCa
         AqE4M0kpEpym3OqAUtl+X5EeqgBlmOCIuytYG7BBDRObRmLo1HpCuS3JdbqFBLOOhXzM
         NPbOgkt8yXeasieC8+3uJzaGSoQEnlBuOz8skggaDM3fl/+GuMkMxXFw8yL08eq6r8xf
         kpehJp85dMdd3sAEMMcX+Pwo4TTH7zwk1mfNrVJz+VrWzTC7SzkJ6y1EB1RLh2CSGXG/
         2963jk1lQdnU2NrOgRL8RNcdmYcwPGfKL8J7HQmPltL1Hi6lE9oh5s/mpneuZRe1UhV8
         VDsA==
X-Gm-Message-State: APuU4Z+WhmNU3ObY0tOr5sIqLi/teFeuXLqnJ4Yor1p8V1Iy3Xs8/7M0
	hj3KhaLpKGRmEUQCAQCvvvUxVRY/1/6AtUbGXTM+RvHipa/OCtr54/b6gdzm8g==
X-Gm-Gg: AYBFou0yz7mGfodJBhNcosfpuA8PKiJ4EbFFpauliRED2ocIRkkugsCds/UpUIdNU7A
	R5nOeCnWyoros0z1YnfekMe4G2FNrxaQyhXMGUvQDVc9fPSMFsMTRKLiSi9gFWVIaHWhE8pmpda
	lW3naLh6u0j5YsHqXe7l4Gle9iH5Klb8s230at9GR6rPg1n2yngXQVupeW8LePz7BPg+rrehE8f
	vP/sxfyJ3NtUu6A4wZ0QqeMZkyiOffe8yWJ2Vy6kOLy84xMjQZUxzuR3PxTZwGpeF/1hiBniB7F
	2gY/2Qqe6RDPTrt/ngOX1eAvHEGii2QMOdyw6gVVRXJ0Ku0ndX5aUVjusX0j+kjxaYBpbtmPPLt
	R6nBZ33jAEG4WbDubHwSofAoB4fkejCGMUW0z8tXAcVDM/J7nxd1QmPtoS62IbhVrLArhiELJRe
	IkKmAbt5kHtnPopKDR4FadyNl7qSCTiicXNtafpyZitGP+8EY1XX5DvmfgIn3Cu6mPabxQXDdQ2
	jN9uC5qZwDaWAoQjwqQ2+WK6H0Xigr+GUjktG1iPBtLSJnn1Ec6tDdruMgATxWLLPMeTIkDMe1x
	Au0+imiQgxBGHc/hOsW5sd9DS10pNJV43KfBCkN6j4A1oJmrVUqcNZyBoxEFV5HFUSKa
X-Received: by 2002:a17:903:19e7:b0:2e9:9f14:c40 with SMTP id d9443c01a7336-2ee0d9fcebamr58929185ad.6.1794667770738;
        Sat, 14 Nov 2026 06:49:30 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f862426sm21965715ad.46.2026.11.14.06.49.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:49:30 -0800 (PST)
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
Subject: [RFC PATCH v4 03/18] mm/swap: cleanup and document swap device availability flag usage
Date: Sat, 14 Nov 2026 22:49:20 +0800
Message-ID: <517ab62dc9842b89c39f04f70d96bcc6717a884c.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8kio9438xjd1cs13g6iqx8m175yjxsut
X-Rspamd-Queue-Id: 22DF3140002
X-Rspam-User: 
X-HE-Tag: 1794667771-705296
X-HE-Meta: U2FsdGVkX18hUjVFXQBKR37knrDzHEaeI6YKVgJwuf/qBoNxvDwQ1pZ/SXhGsll84Gzgf1a53hvWygkczephNV1kjjEYkcUHveEY+iWenYSIgPPRRnDtqxpZkhtOMcAkNiA7LKjdAzF2pOlOzXEAvuKytpUz5Wd/qyr4O1YoSdAZPlVwbCyK9hO/OIACXfJ1f+tVstJdBvrcMrHXtCqxPnsoGIB24dFx0eOfo0DAG+ALHjNcKAXufQAKPNtFQCz8vfLgNzySjEMN4ykjSTHCqtot5/8Jg0K2s2N10oVRCfwOX7AifsORUGsj5tNhV1Yxj8VWdXP8InI34v/+Y6ElRYOoLNzXgv1aoyUrAUIHWq/NPWFUZyOXMxE41SugQ0YDoF8se7yl8L1IqjEDhoENlgLBy3puW3gD5pUu/V/LC69Bn7eyAbsJj62KAe9016hc6YHfrXed63bFOr7KKGNSu+UVSZx1qIiGjKuhDdcxofOwXySupehpr54M2jifsyVMvaRfjKEXp1WJV3U0XAlXmOK0tcvZBcSvwn02PI5BjlveW/UG1But13d69JpsVbfk192Z9K1frOfmyOCVOfVWMLbeotLDfPSE8IiF5H57u5fknEvZRs9Hid58oPB3Z51wPnECPf/TPusflD/YbS0a6ksk55OPhUxHMMKV7oqpnMJyrClQyIKuWp8RC7yV3CpMNuJEgUBbrV9wGrcb7zhYL5muFz1kgYLngX0leBnoi/ZVq/5nwGtG+Yggt47JvSDHw0rfQ8DxMUtMgxi8KcOwlYoXHRWg3aqC7/0YubYgqg9BdmUWqHiRXQjY0skLC6H9kQj3LpbDDGMPiztKb9cDRXRllIqT9P/qjtnlpAUyLPfao7kjPyjnCc2FdUEnLCOqu4qb00HaXEBy0k+GJkfAmxY37zRplWkRWUXSiCY0++qGWrwbXgHAIcQjjNyMXsqKGYS2HcI+6u7hAuz7+xA
 FPHaauNa
 ocuND+HYOpjprz2Pxi60Kosq9yiWgyfNnJsHBbNNzUR34JgX3uH1uUuG6E0RxpMofrgVJxAJvsSzh5OZY2FmCkHPSOdjf57LpAtT4UIGsqLsMlPon60Sjw5HTl/9KG2d7B7ZhCil0Oe5P3k2gg2kQkoKMgoIne8hzAU4g0NwVgCZTdGSfigjsSkVkS+v9ayqM1qBFNWw4tArAk7INk7FCH14ev3aOppnAee6itnjAtgSg48BubZutREAvPtCL/6zHi0Lr44k+IMcofun52CGhvEA5nIWYA94XGNEGXhwzR8QNpKV9hMAWjkkITbY+cOV2QzIs52dzMCojUrv4fNyVhGLZIaNaRx6gZqnUEb1iWFq+pKYEGOkA5bwYrBsvA9dopoCNoQh7HTF5byzQaQW7cW4trlI84jEobjWvSng03tVkcDjTLLX4csW0hPriU2P6MX2iaqn9WCb3qdYZ/YHNIITDeTJU+SHH4Qb+
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
SWP_WRITEOK updates into these boundaries. Clear the writable flag,
set the off-list state and remove the available entry in one
swap_avail_lock critical section, before releasing swap_lock.

Preserve the existing swap_lock critical section across mapping lookup,
hibernation checks and the disable transition. Drain cluster allocators
after dropping swap_lock, retaining the device-identity protection
without holding swap_lock over all cluster locks.

Document the flag lifetime and locking rules.

Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  29 ++++--
 mm/swapfile.c        | 205 ++++++++++++++++++++-----------------------
 2 files changed, 118 insertions(+), 116 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f..0fa77f5679a2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -188,6 +188,24 @@ struct swap_extent {
 	((offsetof(union swap_header, magic.magic) - \
 	  offsetof(union swap_header, info.badpages)) / sizeof(int))
 
+/*
+ * Swap device flags, except the ones documented below, all are immutable
+ * after exposed by swap_device_enable, and until the device is freed again
+ * (SWP_USED unset), except that teardown clears SWP_ACTIVATED after draining
+ * allocators and live references. The other exceptions:
+ * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. Once
+ *   set, won't be cleared unless all reference to this device is freed and
+ *   swapoff finished.
+ * - SWP_WRITEOK: Protected by swap_lock, si->lock and swap_avail_lock.
+ *   Clearing this flag is followed by waiting for all current cluster lock
+ *   users to exit, so
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
@@ -256,14 +274,9 @@ struct swap_info_struct {
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
index c69a924acb74..6485c8020d3a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1268,28 +1268,23 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 
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
+		lockdep_assert_held(&swap_lock);
+		lockdep_assert_held(&si->lock);
+		si->flags &= ~SWP_WRITEOK;
+		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	}
 
 	plist_del(&si->avail_list, &swap_avail_head);
@@ -1299,21 +1294,21 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
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
@@ -1369,7 +1364,7 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si, false);
+		add_to_avail_list(si);
 }
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -1421,7 +1416,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	 * up to dated.
 	 *
 	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * enable_swap_info(), and smp_wmb() in swapoff.
+	 * swap_device_enable(), and smp_wmb() in swapoff.
 	 */
 	smp_rmb();
 	return true;
@@ -3140,58 +3135,88 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void _enable_swap_info(struct swap_info_struct *si)
-{
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
-
-	assert_spin_locked(&swap_lock);
-
-	plist_add(&si->list, &swap_active_head);
-
-	/* Add back to available list */
-	add_to_avail_list(si, true);
-}
-
 /*
- * Called after the swap device is ready, resurrect its percpu ref, it's now
- * safe to reference it. Add it to the list to expose it to the allocator.
+ * Mark a fully initialized swap device writable and expose it to the
+ * allocator. The caller must have resurrected its percpu ref first.
  */
-static void enable_swap_info(struct swap_info_struct *si)
+static void swap_device_enable(struct swap_info_struct *si)
 {
-	percpu_ref_resurrect(&si->users);
 	spin_lock(&swap_lock);
+
 	spin_lock(&si->lock);
-	_enable_swap_info(si);
+	spin_lock(&swap_avail_lock);
+	si->flags |= SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
 	spin_unlock(&si->lock);
+
+	atomic_long_add(si->pages, &nr_swap_pages);
+	total_swap_pages += si->pages;
+	plist_add(&si->list, &swap_active_head);
 	spin_unlock(&swap_lock);
+
+	add_to_avail_list(si);
 }
 
-static void reinsert_swap_info(struct swap_info_struct *si)
+static int swap_device_disable(struct address_space *mapping,
+			       struct swap_info_struct **swap_info)
 {
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset, end;
+	int err = -EINVAL;
+
 	spin_lock(&swap_lock);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    si->swap_file->f_mapping == mapping) {
+			err = 0;
+			break;
+		}
+	}
+	if (err)
+		goto unlock;
+
+	/*
+	 * Refuse swapoff while the device is pinned for hibernation.
+	 */
+	if (si->flags & SWP_HIBERNATION) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	if (security_vm_enough_memory_mm(current->mm, si->pages)) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+	vm_unacct_memory(si->pages);
+
+	/* Serialize with the WRITEOK check in isolate_lock_cluster(). */
 	spin_lock(&si->lock);
-	_enable_swap_info(si);
+	del_from_avail_list(si, true);
 	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
 
-/*
- * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
- * see the updated flags, so there will be no more allocations.
- */
-static void wait_for_allocation(struct swap_info_struct *si)
-{
-	unsigned long offset;
-	unsigned long end = ALIGN(si->max, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *ci;
+	plist_del(&si->list, &swap_active_head);
+	total_swap_pages -= si->pages;
+	atomic_long_sub(si->pages, &nr_swap_pages);
 
-	BUG_ON(si->flags & SWP_WRITEOK);
+	end = ALIGN(si->max, SWAPFILE_CLUSTER);
+unlock:
+	spin_unlock(&swap_lock);
+	if (err)
+		return err;
 
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
@@ -3236,7 +3261,6 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	}
 }
 
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3245,7 +3269,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	unsigned int maxpages;
-	int err, found = 0;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3258,44 +3282,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3303,8 +3294,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
-		reinsert_swap_info(p);
-		goto out_dput;
+		swap_device_enable(p);
+		return err;
 	}
 
 	/*
@@ -3364,13 +3355,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
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
@@ -3792,7 +3780,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/*
 	 * Allocate or reuse existing !SWP_USED swap_info. The returned
 	 * si will stay in a dying status, so nothing will access its content
-	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 * until swap_device_enable resurrects its percpu ref and expose it.
 	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
@@ -3960,7 +3948,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si);
+	percpu_ref_resurrect(&si->users);
+	swap_device_enable(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,

