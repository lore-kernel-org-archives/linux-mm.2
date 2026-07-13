Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2571C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5E76B011E; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15706B00ED; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59126B011E; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 534406B00EA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC1FF8BA32
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:57 +0000 (UTC)
X-FDA: 84984433674.20.1AF7394
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D07F380007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owDRiqNh;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963615;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te/MxBsdveVICgVtw2+ImFjYxXCxPKMmOLqsIzyDMiY=;
	b=a3oAfGy3CytWo5+H1ije0wNBrWmOwZiEKI3VZLR+SHX2G2NIl63XQEyciMh2sRLtZKxsMF
	FH5/oJG7glvq50b3ENlEJBoXg7fG7yUBhI00bviCsWDkGZuSFpiEwYQKiuq84plg/G9dLx
	jM7KVYsLHQzMtZPpB773/O+R6kIDiHQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963615;
	b=fRflz9Id8+hsDBCl40Y/1O9fFkG7eZOOWx0pn+4Qeyi1XwjQzBItdkxjj5hPu43zKGtUko
	FEP7WHAmAG3x8SVjVGKpdW9MdrpfFgxUpYQydL5a+ZpI2addkjXoqrrApmXV0xKq35dtuQ
	lZtMmlPiH5E34Iv4+RB2QP+s8yMpD1w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owDRiqNh;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15FDB43ABF;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D63BFC2BCFC;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963614;
	bh=Alfa5R7cuPoITFX+rbarbwLG1+I6hT50bFmqlnb/xXI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=owDRiqNhkPISIr/+9c3MPxYnCxFfajBExfW0QFiJLtSuVw/7lCfhn5bLJ5Q4nfiXM
	 16ev8ogax2mMrmepZQQm5LmAEsyM4lt0wxr58v5dmsA50BRiLF2mM4C7eGkPf5uMGQ
	 hgs8gYzGGaYRwHDfb5c+6dVpEcr6tG5DosMhwy2ko8LkE207qJiaZhbYNVodyQ7Rvr
	 5MRDMJNs1UNhtla9pTwBshAwsITTdujxoB1VLZ4JsFyrNe59IwntF196FXqiXlKLHd
	 YG4ke/NC/ekRz7nHvQKBCEnQq0bs9ykfQB9wkUow46v16huSeuBNFjBmbEOg09Amrl
	 ZRXufPtERmqGA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33FEC4450A;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:42 +0800
Subject: [PATCH RFC 04/13] mm/swap: introduce swap device iteration helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-4-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=5272;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ypbKQldXEjwRE9cbv1ZROZRw4f0vEb/XoGPlY7YD2wA=;
 b=Uvd2+nXpHDCFssiQ4RQhSvh6jVc3zRB9V+1OBBAkp00UiXNZVUy6wcAZNAxW1K8zUWd2HjZH/
 O2m747SWr55BHSHZYq6lR93oeK05RAcG4eOeEF5viKvmRqRce6bESNv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D07F380007
X-Stat-Signature: kyaoxhsseeq48tx1y1w3zd51skmtmywn
X-HE-Tag: 1783963615-515115
X-HE-Meta: U2FsdGVkX19iqrubJy4f8++IBoByNY7xjA67bXGxd/oNx6KNJ2IVWL/TvFdR7KPy2h6hOvQgyhrViOZsLiXPbjex9C+0Rsv5AQkpVqjWiZlqehyRCkNNmnUump3Btdy3TeU6HzLwMRClHnJ6zHbcyZCRAWek9LxoxjzQQYcQ/i204qc1Z4aEDg0Igm3aYBYSr6TcBU/fdPUQJ8uOnrOb8yZ6aqze6wccRQcdcFLyLYuLQPGuVZRPN4GYcm7xOIpVs7VstzUjxTw4AfCsL3xWPF6FfZzKJl00aITzUkuh8AJ39A7i5c3y2rMoH5cluk6gckmjwiWnMdDACabTl6io2La9s+CsA4JrwN9ZPHVAsXVufhQ9pmDR9+6vzS5BB8C/zacQY7cJMHQa/8QwLiFiYA9mRy4TR8Kp+4xCL7XPRtgw8mLbZrzxuYhWi4ktf0Yw1oGHQlPZGJaANaBV4AQPYo6z59MXWOnsa8f1GiYCMHgdlcIRFpDglmpOCTH9nObDEivhnFz0p+YACGbcgdA8RQwyvlqY468qXdgZwx2QHzjimz5ZMWfIki66UX2IhZ7IyAS9bfbHFKcKTCAuC3eHDSUs8fje0SuIUYJvE/MrSdQlN6n6bv3oPyAU4JDiVtiT/7V9k64m/WPTGTXbyILi3aTmVXAjhnbf7eFYC83srnWfBvo1cvZp6u6/Kn5m9RG1dmlFQ1bHtlmmMx9rLKv9NrhqFX3F1ozmOpLHwsajXOuQlUWEgHp2plDEqPl7wHIIzh6ezekkeuQigPeHZkqLsLKSzcNXKnIU9JkPRuAoPmXBggwk+0ql+diqD2oAHlpRRG5qUjHzYzdytvEfehPCXAQDvy81eVlKrhcuyj3xFssAMpo92hcUOH0o4tpZWN6MmUjGGgGktDrZZnmI5bySuALjZiS+Bu8Ko/kCckds3nrZl9gu1KCLRQwtAGqHSE+UtZkO2yhKO7yU40OjAgo
 EFo9cqth
 IiTtjQBfhgNcV4a/f7mhrTDFsJxq9jA8CV40H4FBpjFBi8IX3SFKehv7nbZ4z1H2Am9lIm6sPVpHZ8mcy+D1k1svMivZc27PPW/+PeaL4ZYnekOvZ+jL21f/oxhNkHSxs1zICn5Tol5UaW+dMNJjdd0hJB47ih62shVI5oAZ8pbYRM8Ebda48Y1MS8cP2qIRp6f+mhI7AV57s4kd8JlpTwnbZbT9QbLRdylHkAJJmNjr5ToXx+qGyW2c9NiSi7yTK6D+YspikLIqFBo7RwBMYQAwiGeL8i8MvsPlUTjVWxATsxW1Git2INDstkbzOg84UUL/KPS7uCWiUVj+n7o18CNiPzd6cQF1vCCE2DSuC7B4kJtp/EJ+abUjgBxNiXmmtyqfVhJjekLevdHvDK7ABVPH7KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are many users that access the swap info array just to iterate
through the swap devices to find usable ones. Introduce a generic helper
for this to prepare for dropping the lock convention.

Also slightly adjust __swap_type_to_info to allow access of swapped off
devices by moving the sanity check into its only current caller, and this
way makes more sense too: the only caller is __swap_entry_to_info, where
we should never see an entry referring to a dead device.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h     | 12 +++++-----
 mm/swapfile.c | 77 ++++++++++++++++++++++++++++++++++++-----------------------
 2 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index b51ad3071a73..08a782f3d5ac 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -91,16 +91,16 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
  */
 static inline struct swap_info_struct *__swap_type_to_info(int type)
 {
-	struct swap_info_struct *si;
-
-	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
-	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	return si;
+	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
 static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 {
-	return __swap_type_to_info(swp_type(entry));
+	struct swap_info_struct *si;
+
+	si = __swap_type_to_info(swp_type(entry)); /* rcu_dereference() */
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	return si;
 }
 
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a4701692d330..8faa4e7c32bf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -106,6 +106,34 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
+{
+	lockdep_assert_held(&swap_lock);
+	while (*i < nr_swapfiles) {
+		struct swap_info_struct *si = __swap_type_to_info(*i);
+
+		VM_WARN_ON(!si);
+		(*i)++;
+		if (flag && !((si->flags & flag) == flag))
+			continue;
+		return si;
+	}
+	return NULL;
+}
+
+#define __for_each_swap(si, flag)			\
+	for (int __i = 0; ((si) = __swap_iter(&__i, flag));)
+
+/*
+ * for_each_swap - iterate through all allocated and inuse swap devices
+ * @si: the iterator
+ *
+ * Context: The caller must hold swap_lock. The lock may be dropped during
+ * the loop body but must be re-acquired before the next iteration.
+ */
+#define for_each_swap(si) __for_each_swap(si, SWP_USED)
+#define for_each_avail_swap(si) __for_each_swap(si, SWP_USED | SWP_WRITEOK)
+
 static struct kmem_cache *swap_table_cachep;
 
 /* Protects si->swap_file for /proc/swaps usage */
@@ -2197,26 +2225,18 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
-
-	lockdep_assert_held(&swap_lock);
+	struct swap_info_struct *si;
 
 	if (!device)
 		return -EINVAL;
 
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-
-		if (device == sis->bdev->bd_dev) {
-			struct swap_extent *se = first_se(sis);
-
-			if (se->start_block == offset)
-				return type;
+	for_each_avail_swap(si) {
+		if (device == si->bdev->bd_dev) {
+			if (first_se(si)->start_block == offset)
+				return si->type;
 		}
 	}
+
 	return -ENODEV;
 }
 
@@ -2322,16 +2342,13 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type, ret = -ENODEV;
+	int ret = -ENODEV;
+	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-		*device = sis->bdev->bd_dev;
-		ret = type;
+	for_each_avail_swap(si) {
+		*device = si->bdev->bd_dev;
+		ret = si->type;
 		break;
 	}
 	spin_unlock(&swap_lock);
@@ -2817,12 +2834,14 @@ static int try_to_unuse(unsigned int type)
  */
 static void drain_mmlist(void)
 {
+	struct swap_info_struct *si;
 	struct list_head *p, *next;
-	unsigned int type;
 
-	for (type = 0; type < nr_swapfiles; type++)
-		if (swap_usage_in_pages(swap_info[type]))
+	for_each_swap(si) {
+		if (swap_usage_in_pages(si))
 			return;
+	}
+
 	spin_lock(&mmlist_lock);
 	list_for_each_safe(p, next, &init_mm.mmlist)
 		list_del_init(p);
@@ -3802,14 +3821,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 void si_swapinfo(struct sysinfo *val)
 {
-	unsigned int type;
+	struct swap_info_struct *si;
 	unsigned long nr_to_be_unused = 0;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *si = swap_info[type];
-
-		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
+	for_each_swap(si) {
+		if (!(si->flags & SWP_WRITEOK))
 			nr_to_be_unused += swap_usage_in_pages(si);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;

-- 
2.55.0



