Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79606E9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19F76B0096; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD97E6B008C; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B140E6B008C; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 947B26B0092
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 543C413A0C5
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
X-FDA: 84455031864.11.B8FD6C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42F55140016
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mnL4P1w7;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v8Qor1p7CV3kpnFtnmWuF8bwdkshVrZEo+NTz5tl5E=;
	b=B0qp5o/SLUlOjW8w7WYbKPkichGBXUhUERsIM0kgwIA6Eo9vYO2ld4dr5G3BM136SHRCws
	iwqNRYCxbUnRrfqK+1u/a1A9EURLTt7HofE507qHUgTwkwc3cwlAvw1E4DOe3DS4t/Pcb0
	nuo8FzKzf0956ARAtko4g2O7hTI8drE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mnL4P1w7;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358810; a=rsa-sha256;
	cv=none;
	b=0TdqHW398CWWAJP2kW0xAD3zoxoBv2hmLL9x4tkIjyhquuPdd5rYCab0b6UtZKuMMXB+ca
	zbd3k+tsKSyon7aGkRdvmC20Nz02FZuDHXQRFQteSu8DsrEv9e2mqB6+uheHf9Z2Fum0gk
	ScqRTWX+FWKSN6ty1s8t2i4Vq4CkhR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BDED443FF;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 027EAC2BC87;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=KjN4Ur2B7QTWJCpQhJuDPDSjA7dfJDSlU7kJLSeey80=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mnL4P1w7MZpA8O74DWDaAAKa0gX8kAoHB+S7sz2flKiBEXrq4Vv1iIGCaxttPdgGd
	 6SSfrcvgMQnPhfp06g9kvxxnbYybhB4uu7Gg2paaF5JZSAeq/dUi1mp4zMh8JLsdJi
	 dMPfPpTeF7+WTtkvM0zhKrWSi6ecZxguYQphzhqxiWjWiMBKF77yxkazzZxQw0ZzXF
	 EgiHAo3rt+YKpuiuRaWsTr7DzT6rinaEK0zuuCbWqckgqaObwOA6rbVw5rCzNsWZ71
	 6MaktsNGj83Iy1/pCAt1hx5tOmspKJDWfZNspzVqifTDolzBjdJy5wgKUA9mabcwFI
	 RUa2rxtscXnVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4C4E9A044;
	Tue, 17 Feb 2026 20:06:48 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:28 +0800
Subject: [PATCH v3 03/12] mm, swap: remove redundant arguments and locking
 for enabling a device
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-3-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=4474;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7v/yOoUm+JKrDy/cUABunBQ64SLCuHCZ71QcM/9ivnk=;
 b=pe7JYHGn/ycRyxgjvXfgwIlVdmMo/7yYX6nZc5R0wASNkiT41lF4CipymFe7E/R78JWzygbk2
 rfrQGO4XYH1CvtT5mQhICq1K9z8VGrFEWknTZcO7tflKC4tAPK7m94m
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 42F55140016
X-Rspamd-Server: rspam02
X-Stat-Signature: c4rx3uokx8az4an875ozc68hcu5z7k4p
X-HE-Tag: 1771358810-705652
X-HE-Meta: U2FsdGVkX19l/Bb7KLj1gsCWBVOCyXHgmbIN6bKNHk7a6w8bko4UXIhtm8ThcS5NUhTJEAPDMPNOG+8cW76t7lzc9rL5lqzKGYmlYpWl9axuka2Kau47KjHlfFGTlQLfPIvEIudii5xAVFJw52L0eQzzboCPr9ARZUjSL977LQI01BODCxi92FSffvpCF7UZ3w/M7aW9xEAFT04dLmKoOHFTCz6RoUo1nviR3BGPjQ+GebJQumgEaBHI/ZBaekD+DNzBgTfHd1Y/C68m2FXZuF1CDch7phZBBbg7oUA0al0qbjD7yO/zHGv07ZrG8z3tXAoML6449Juvu0KndpybExquL+LrCU9guFKThWICGSu8AuLhc4iyvX0ksBvKH2NI4J/ZHq6oQVocL8Xq2TWINiPpyetnJ6c2VCHu9u0tlhY6L3G4uSX1yww/BkOXJ4FgFN6WEPloVfmCBvIbqNI4/bUl1Ph5atsb8qjTPsxDx8vUfEQSFiJ4e/u2GQYeatD3OAg04wsbHApApkb0EXdkNMLhtWDJvViBQ80bS4kIxaLDu5L7D1gyoSfCNISjM94ysz48h53uU8IaA2yP50XLgDr8UFC5x3LMzpQG6o1GuXKFmvWocy93c+EaOV9QiuEROSV8/qMTAMsMiMvbJpNonIcU0089q5NV+bkexx6nsA7Gu6aCSmOBgnUzMJe2lHKl1Mbf5jVIuRXH3+4Febn8lxpP+brXlqbyH+k+A7xrX5bse7tpecpo1dP+FYHVOGByXDM3PLr6+EiiAf80lC3eoSumfU+TgMI8nPcknwwfqHrk3n9Poeir7SHC3wasnswj3tE/oE/cfP+Uz+C2Qx/hmEHoOC6X28I1R3vCvtioTWe97IH8PZvDlFEi697ba4Q1/ND73iE3aLPStALv/e0021+LypAX2E0QaZzdhWIjAOc6BM4UAi3DXCJ+B516C/3Y3gewR9Cf3Orkil1Idfs
 632uVGtx
 3ZNz7iNNdprj2MVfMbfmuv6BWw6prSj0HH8FAqE67g9uYQzahyDVH6Oul19RlZ5kXOrbZIz9wVIjsLDyOdRfQY8Wc2qnS5I3CJ5vg2ll7uL1jPrnsE65eqwLqxPIR3ILa76rGoKGn07NotqjEnc/UNZFjWnBIXy20YAVGjKslK07GMdlDgKRGp3FkSoG3j2p2+yDIY8YhAza/7iqmT2GXEqi1oDoVx+dUYj6eG2bqwj+V61cl7xElozxsnB6MjAn8hAfoie03kmtjkrdTmxmlccgIGqr2XQUtSB0DKREAJNPinL7pssw3R1wbtF9OjdllxTdmZ0sBQjty+goIJDtoR/2Vvt8oVgWRPDsyWXMtvPEInCvWHxnjVyfk3A==
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
index 8fc35b316ade..fb0d48681c48 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2663,19 +2663,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
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
@@ -2689,17 +2676,12 @@ static void _enable_swap_info(struct swap_info_struct *si)
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
@@ -2712,7 +2694,6 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -3365,7 +3346,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned long *zeromap = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3481,9 +3461,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -3552,10 +3532,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -3585,6 +3572,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_map = NULL;
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
+	kvfree(si->zeromap);
+	si->zeromap = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.
@@ -3592,7 +3581,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	kvfree(zeromap);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)

-- 
2.52.0



