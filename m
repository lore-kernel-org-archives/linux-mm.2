Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06337C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0847A6B00ED; Mon, 13 Jul 2026 13:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB43E6B00EC; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43566B0128; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69C316B0119
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1B5640131
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:57 +0000 (UTC)
X-FDA: 84984433674.26.3A572FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 000E72000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RO0uB8Ak;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963616;
	b=cpfZSvxsB+KG8ZVXK0p6Tb7x7c9/xVHSiUn1eJvLsL3Tgp/YSEG3RCEEri3DkGmHZzkssK
	8TYGe6BkHv8Ia+NaKRtIma8Jv9DVYvGC7ooA1w3A/OXVrHsJPdXMpuvTcTLp0Qy4KKNQgL
	PPp5rbesIWTZl+cBt1LVtTFYzVLyT3A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RO0uB8Ak;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963616;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10N/ACSs+C2O6d+64axsEd5c0UwGUSRdnJD6eHo/knA=;
	b=ZadpJbsWfVp7IuBQ8zdHUIREY6qB94wf0NnjnLOQlWtBqdYSly6FI2GPrPuxrgityS2Z4L
	tvH6+CBrVcOSbaL5ZnpSHI4LRHPviyA48KatP8eWpDkGq+/JVQC6FsoahK3ypaQUxZ9eQT
	g249IjS9I7hdQko4EB9sjOJwJhSnCGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 262B943ACC;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00E63C2BD05;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963615;
	bh=aRYM02wEbr/o6bgrCnlzBlc0T+QJvdAK2GhDQkdgStM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RO0uB8AkoELV2kiI6BadjvnOQXoW2C+tf/R+j6wi3OSQR4O1QZGbqlYSlooPGFZRY
	 ZDVDAGQ5/M0v20oHj1B8eoBwj3+FS2g95ep05fMlwi9bFT5+VWa/2/R3FMJus5Y3Jy
	 +pEV63YPcxiD8ViklpWckWAM0bH/TYBDqrNXO9xpv9T+yQ22XrJlI9G4MqEDyVg1iu
	 tdfXzMwSd8zKkhF4MjIqJmjNv7IbWqdwNjQb70PG8ZQDnyMHcqjeYv54sP/3+HsEdq
	 sJXUgPFFy/m4sIbRtBqvNwHhrrEHDhA0oOmGFcUduYfeqdJiZ7VAh/Fd3AkmBZE20d
	 vJ1l1rnyrST8w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E24F0C44509;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:44 +0800
Subject: [PATCH RFC 06/13] mm/swap: remove swapon mutex and update proc
 reader
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-6-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=3465;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=j1za3Qxt32KGithzma37GogOBsyq+U5KkuqTTp+siv0=;
 b=wBkRluP9NMxSP0zuqKH8cLiWSuMS6fkcqfGHdt2jZ/pxZPZ6RGda/q03nFgRLUVaj+2Z9sKKn
 QtVt3wfBTDqDBlDPBmqPdBWzZy0yFqPYxzgd2KLccMc/PEZpPkWAGkI
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 000E72000A
X-Stat-Signature: 1jx34tig89psd1g7wdn6oe6tysg6d35o
X-HE-Tag: 1783963615-585334
X-HE-Meta: U2FsdGVkX19VayFDH18cfuUuwr++8yRM8byiTWqaCC6OD6VZ1cF8VdhbUyPPjoGcYwW5OJMIF89UU1RJ4Kq7HqLxKKFPdISAFj/evkSSFdOFupAaX4NIFTIVIu83OfR/Clvptll+nHbzUVuRy2GHQnfB3FGXcg9Bp18L6MS0PwMZmCi6jhdWwDlbTpsdpUyGUzJHhoyWh3Pf6WO9Way7htTbMGZubBkD5obDlkgh1Kunzj6RyutYZNlaKG712T8+LiYQyLNyu0+q1uIYPcH2UFH0///0E8/IiWITBxnaKI/wvRd3/OMmsc+O68MBhFqv+pJviF+xvnzqFcFUPOPdXzQU4mkmyup4hQPlWqs5tZ6HxByMH8JJq5GOIY4e32m7lyAlf1WomLBNDLcfLFkuYM5+XryDPZoofJwGa7W8SUuXv6jhrF2m3MD1X4n5wEKbEya2QWn3Puvh6pfkMpaAOB+h7+4oTC3XPw68LPbpdK7yIvNEdGm+q7h721y/ijCkHzcoCKREBsqgAVNRriwH5gtavgYcsmPEIYg0FGPhS/gbTKSdCIxpp9Ko0oB9mEknbU+56Bhua0H2lxKrF+I6FQkuzvttQESuyCgewJipfxkuwnwibkmrlbDYeveM6D/aCgG9AO94J0YOefjCX45y4ta9ox6KdDYPW2j5J+mfbvFVCU/jgi06uwzocYywvzoO2EDqSIk22oBBV8QYA2cOm4y+YtNhndmru/2/8HzlstFdbVyN8+oMET3WJ0e8scUkosqkQMzZG7ToeYCrgEXsLZXHC6lKxv4IJIf3/kj0Gic0VtaWpIOCpS/k1OE2rHJ0aHxb04UKWKdzTTGXodoB2jr2Ym+VhkSz1XDlYNPAX5h1IWq24fBgDjCJ/WKed0lxqw7OC3hZsxLRCNYCklABJeZkSkd+AbZ91RR4ppkjGAydK6AGCRboyNHOeSGQryaMTiyRMye92JOHnOXR7FC
 NvZTnKOG
 bgKT44kVUK9tRt8k6N4JHo5bE9qYjwPlQlL9bCM58rWn45FUKkmPKGaTmEUpmpSiTSVIlHx7K5bSMAf2mPJd3iK1/rsCm+MNfGlbY5+RtlqPAwjuzmzx8fJ9ToCvxCRSiXbKSvw6iAMGR4PpqEo3gG4On4AYNomBTNzNvBRFu/25pzD/JcQwLfy9ynCo901TT/+xcou3QOQfxe6pIyRWNdquB18+SKf1UobL71v4DaHtEgSFY486ZF0cQs1TUE1Dfg+fZRKwFMl7BYwMgo/uQkzSdlDRePOYTEJ+4q97oAiNG3MhZK1Lvn8XCLXsaMr0sEiiUFYvsN8Z/sjRVZKAC+nLhtWBYDvcqcs91t8FAmgB10hjMRvY76V+rMEFbupl1jDicQEzGTAXQtYNBQ2ACCPCi3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now that swapon_rwsem protects all swapon/swapoff-sensitive data,
the old swapon_mutex is redundant.  Remove it and convert the
/proc/swaps seq_file reader to use the rwsem instead.  Also convert
the swap_start iterator to use for_each_swap() for consistency.

Also adapt swap_next, it needs an explicit SWP_USED check. swap_file is
not reliably protected by swapon_rwsem, so checking SWP_USED is more
accurate and stable for filtering in-use devices.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d75fad161ba5..8b073569d1d9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -140,9 +140,6 @@ static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 
 static struct kmem_cache *swap_table_cachep;
 
-/* Protects si->swap_file for /proc/swaps usage */
-static DEFINE_MUTEX(swapon_mutex);
-
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
@@ -3156,7 +3153,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
-	mutex_lock(&swapon_mutex);
 	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
@@ -3171,7 +3167,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
-	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3217,20 +3212,18 @@ static __poll_t swaps_poll(struct file *file, poll_table *wait)
 	return EPOLLIN | EPOLLRDNORM;
 }
 
-/* iterator */
 static void *swap_start(struct seq_file *swap, loff_t *pos)
 {
 	struct swap_info_struct *si;
-	int type;
 	loff_t l = *pos;
 
-	mutex_lock(&swapon_mutex);
+	percpu_down_read(&swapon_rwsem);
 
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+	for_each_swap(si) {
+		if (!si->swap_file)
 			continue;
 		if (!--l)
 			return si;
@@ -3251,7 +3244,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->flags & SWP_USED) || !(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3261,7 +3254,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 static void swap_stop(struct seq_file *swap, void *v)
 {
-	mutex_unlock(&swapon_mutex);
+	percpu_up_read(&swapon_rwsem);
 }
 
 static int swap_show(struct seq_file *swap, void *v)
@@ -3764,7 +3757,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
-	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
@@ -3790,7 +3782,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(si->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(si->flags & SWP_PAGE_DISCARD) ? "c" : "");
 
-	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 

-- 
2.55.0



