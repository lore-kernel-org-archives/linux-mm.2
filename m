Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D3ED35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1522F6B008C; Wed, 28 Jan 2026 04:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E16F6B0092; Wed, 28 Jan 2026 04:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB5F6B0093; Wed, 28 Jan 2026 04:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDBC76B008C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:45 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A714594FE
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:45 +0000 (UTC)
X-FDA: 84380852850.22.A915A54
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1172120006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PIEcEaQ6;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oxuyrcl+senacpl825Pc/8hD6orLDCzNPV1cvMYSnM=;
	b=P0oc32/r1s8pwfO3h1zPdnBPurV2newplkN0CNYJwC5RBPKvYzcIjs1VwmdpzriZ+F6VWQ
	wCoixs2t23ZyF6nRc/A8VG75e8DBcx12tU7HdbNuhBJSQzQtnDp32MtDzmRedJJLBWBdkf
	/qaIP/Oh2Fgn+GDdjkKAdYkAQqv94uY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PIEcEaQ6;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592643; a=rsa-sha256;
	cv=none;
	b=vaeBQjSVP84HiiLUGHPGPtDwNEaYDzndd4l/iR5aPQ22RlYD0Q6TmdrAoZtJ5NfxCuVGmj
	bqcUVZZwEithgqOlUQAxFA5T9ajmJ+FnLfohgcOXJ+2jPzlpcOgkf+sM0nhZ/lh830PWob
	x4E/wIo7uwtjq8Si2hmUfBXRcc8uKLE=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so5756331a91.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592642; x=1770197442; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/oxuyrcl+senacpl825Pc/8hD6orLDCzNPV1cvMYSnM=;
        b=PIEcEaQ6jjS1RMJtebZzbYCbbK3z9xppsmrORPw/iwRba3+k86uTRXVBLdKAawYaXd
         Gr3TDypYGKK2AqYuoPVg4TRqGjmA+DmFQLDDDP8nC/mxTzw+nJWvhtdOwLjH3O+sPa4a
         /VHLKcurKPXPjg+PJLBlTG8Y40GIGEL/NxbeUwP0kbVisRIDSBNWOxofKCJyC28EbEH8
         pTPaxZ36JNCN6LlsfCymBc1+hyHFn0v8Ir0+sPRxnKsTuPCrYcTuMcVJlZcJHi19PyZ1
         C4+JnmQAlZqKwwM7xPWCp9wgl3sufv9YheoCuhxOcXS2zQGnrqEcoS2nUBqYpCG/JXs9
         VXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592642; x=1770197442;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/oxuyrcl+senacpl825Pc/8hD6orLDCzNPV1cvMYSnM=;
        b=kETT70G1w3gsHTUpWlD9gd4srA79qNGuOSPX2IgAULO22tDP+SUqamj6kQDPTV8b1H
         bpUEBwkTI7y936JEAh2kNSFpMclYYEJLdnv2QMkq3K5sQp7sIqML1sQyH1tTdVF8unpW
         zzPelZnl9pTkvZsvEJPf5x+RkB6Oq7iSptBfrP5tLJDMJOYoFnmqEo1P6IsWArqltcnT
         iedEXGsWCanQS+tsjrLXdy4v1OPmMGUAybxWiO5Ef/F+r66n0PPd9bkUkmYlNK9lzv4K
         V1HegW6DFVV/tvX0cmjY+5YasS9nHMKPH3njdC19682XP1FWyz0QAxFJKEklWDS/WOv4
         t94w==
X-Gm-Message-State: AOJu0Yx9AjazCW45GVwG8pzyFQQirzeZd4HQ2TxlpNZE2HVLQcqPsg5P
	ze49LwxqFVrqEmeKHS1QuC0W60fwH+eBExcCXziHmZ2MxnUian3+dQwb
X-Gm-Gg: AZuq6aKyZl4kqEIB3tOTqbttxUZkHG7JRUxHthdclkejpq7JVB7OCzr4jMPRQByRuLT
	clDDkNmYkX0rwVMVZcJ3ITdP1GWpXrXTZ/3ry3yXv925qdG4Sj9EP3Zq3qYQ86TBG3dDgXXMI4f
	84uJ7KcWbCR3i2j5OvtAju7UkJyFcpSAuQM6pL+QWNswqrmG3ntphDjwyXvzHh8OWejwXl6BWYU
	gV9Ca2uBEL19e3jZG2uKm9v31h3LRihJXzxIcxJuNKPxgPb5yTMiOFtQ78hVEF98YITS/7SLGus
	q/V4057DNMNiyvkvb6rN9uGbOcoZt9oxVBpMogVZIFMYbR0GzaTC3YSezxjYXT4xt8ZHHfiQdKK
	diBjh9AXfqICyGmTegCtINzWva7dVMWb0khFz/2Bgn3XGfhDbpOrOAiOZPSbCRyo+OXODuC2dd/
	GqtxjOSclJQJ0EcDHjgyyuRM8DPh4zuKeVK/jp4NXoVOR0/1plXLDmQuKUBdw529QAd/br
X-Received: by 2002:a17:90b:4e90:b0:353:41e:1f51 with SMTP id 98e67ed59e1d1-353fedb0be5mr3633981a91.32.1769592642506;
        Wed, 28 Jan 2026 01:30:42 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:41 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:27 +0800
Subject: [PATCH v2 03/12] mm, swap: remove redundant arguments and locking
 for enabling a device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-3-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=4474;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VcHfIq9fX/OfsYjH1rKwFGMkjPLRnW2PTE0+Zr1fpH8=;
 b=CQrft73Ff5GcHeRS8vzyEB/f+sEs/xHE/r5jDb4Ns083oBkMezObNd7E2wwq5X9CTKIjbkW0B
 eKFr8GD68ifBUl+KzxNsh+DrqCCW9DQzGcIPm6yThuqN5PlAbYBA+YZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1172120006
X-Stat-Signature: xa8dpbqn7bedpwidkikobr53tpjyoeir
X-Rspam-User: 
X-HE-Tag: 1769592643-744872
X-HE-Meta: U2FsdGVkX18WDtNTz3fTOuvqCRvgOJgrxuK7Qk9leWcsOg7xe4K4V4Z/qdqO8Tb31ci1hMjPQ51D9JmY8cSRKHfzW1bDMEDvi5pjp75TTtfm5eKK4Dn5J1eOrUGJvmTG37EFgSBAJ3mTZnFV7gQq0GxBH5/V0jrjHjsmZEy2dYpyiFnS0jzMvG5Iy04zpe2lfzIfuMJI3bIGz+WIL6WTH/I/k9NUx3A/G69uoku32uLgKCQY6CwhHt3PpSJLqHKINKNdz4GMmNwUqVhycPLGcGI8cjPU0SSXV7qLzV+lWHzSSZ+NLRndu2nGZ6znL2GysaeFuMxKhj3/dKSwzeR6p489SXxe4byzE81ntBwgA7eEFcbG3B3ltubYQOpVKtHjr4gAS2lQHfUL71n6CB5tGX7Rbp/CRyZR9jzxoX3tXzvYGrTMQatQBvHNmUgOlC37AkRvMQudS8NMmZLUrbD1bfzBDPEbuKAiUIDcWgSZE5QtFl3pK5U+kxCFlae0UxGnVcnTH+rWEZ5pVBdGfqHfehiL3nZ3A5h74ESgjlcfKW1nNRKN+5TGVwfO4f3MTAQnAgmaj5sE8cPd47nmRWQ6rca8rx6vwDSi7mRyY5nhSzixKlJkDnFDMtqcGQXwpLnYD9QpadoQLjdtnHYxMBosUTLzx8aRl3iLxctONGBhIgqZv7JsafuJAABKBjMzeK6P+d18kuvlcEde6QI5AOtyz2xA1IRho/9P07/WnguqK+bIdsbHY6PT8UGL9dhBCzLJcyyHE7Aw8+HNECbVoG3Ox24C25WDMJ7GdTf3UkbwtXrafv5uKTHkjlGJkH7g9RhArWZQWf9xNSik8RTDLM3n/5+p4ETRv5ZsR44VbsVRe9ftML00ZbKGkaEZzotXxZBGkhWFHw4b5thTkUpEB4dGtP14QLgOL7LcknRXk7HyrnsRVMOp5lFcJLn3NBlaRxWMigNx4OwhUR40NjGDhNV
 jyr8v8n5
 ae+0R5VJq6VG8fsj8y5Fw0jadxcGgLj+75uuh/MmDJE84Tgo7jJ6JUxnmChOe5Yg851Q8BPvuDhPHJUJsyrks1SoDHoogjQK7QKAghJH60jcVR9+d2qra31L/Sd8tZFNlENAmFcUP8r4FkSLmYEqjor3FtXJR/jK/1UwN8eLLcTUzCUpVC5wmPcHyhGqopbz8b8mkoTCW789uv7k83tLSePQvc2PCelviZiZFLjnO9SHkmHqN2F+8H9LjqGEivmaE5VAVGgWnV3JryNrTc7neBwmQ1wBx8EFsroKvXhqdO8ksKmiRMzpPq7mqEmIQbwJxxzXtewcwSAE4VIY/7OSYqWY9qoUKRMefITw4OBnqCUKSCj+Fi2TJGUxFzUikTkDOZucGOXrxWwmdvnNykPY2X8VIy9RSK3piui+85xWs/oqpjlyaVeINAKQnSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There is no need to repeatedly pass zero map and priority values.
zeromap is similar to cluster info and swap_map, which are only used
once the swap device is exposed. And the prio values are currently
read only once set, and only used for the list insertion upon expose
or swap info display.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 48 ++++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53ce222c3aba..80bf0ea098f6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2652,19 +2652,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned long *zeromap)
-{
-	si->prio = prio;
-	/*
-	 * the plist prio is negated because plist ordering is
-	 * low-to-high, while swap ordering is high-to-low
-	 */
-	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
-	si->zeromap = zeromap;
-}
-
 static void _enable_swap_info(struct swap_info_struct *si)
 {
 	atomic_long_add(si->pages, &nr_swap_pages);
@@ -2678,17 +2665,12 @@ static void _enable_swap_info(struct swap_info_struct *si)
 	add_to_avail_list(si, true);
 }
 
-static void enable_swap_info(struct swap_info_struct *si, int prio,
-			     unsigned long *zeromap)
+/*
+ * Called after the swap device is ready, resurrect its percpu ref, it's now
+ * safe to reference it. Add it to the list to expose it to the allocator.
+ */
+static void enable_swap_info(struct swap_info_struct *si)
 {
-	spin_lock(&swap_lock);
-	spin_lock(&si->lock);
-	setup_swap_info(si, prio, zeromap);
-	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-	/*
-	 * Finished initializing swap device, now it's safe to reference it.
-	 */
 	percpu_ref_resurrect(&si->users);
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
@@ -2701,7 +2683,6 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -3354,7 +3335,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned long *zeromap = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3470,9 +3450,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
-				    GFP_KERNEL | __GFP_ZERO);
-	if (!zeromap) {
+	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+				     GFP_KERNEL | __GFP_ZERO);
+	if (!si->zeromap) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
@@ -3541,10 +3521,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
+	/*
+	 * The plist prio is negated because plist ordering is
+	 * low-to-high, while swap ordering is high-to-low
+	 */
+	si->prio = prio;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si, prio, zeromap);
+	enable_swap_info(si);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3574,6 +3561,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_map = NULL;
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
+	kvfree(si->zeromap);
+	si->zeromap = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.
@@ -3581,7 +3570,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	kvfree(zeromap);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)

-- 
2.52.0


