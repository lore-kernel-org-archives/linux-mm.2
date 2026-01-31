Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D791D79769
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 12:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E088D6B0088; Sat, 31 Jan 2026 07:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF006B008A; Sat, 31 Jan 2026 07:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE7E6B008C; Sat, 31 Jan 2026 07:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBA426B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:56:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 564D81B1CF2
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:56:04 +0000 (UTC)
X-FDA: 84392256648.05.BFFE3A4
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf06.hostedemail.com (Postfix) with ESMTP id 92487180009
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:55:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769864162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++Kr/SCuQ/RviJPf7zbACDtHVqX4nB9HuifW6Cnh8Ow=;
	b=VZ1ZZDofb4YkWskSgOdb8aEdxaRyjK09tR2hpCN9of8dluZL3NbPo8sEFo9Bq6HZImzvfS
	jW3lNO5iWAG/7dTyxusmoMqm4yiU34VcoXOQpulTbtXgpMa8Cnk6VzbjW71vsNO2PNXsp8
	cQK+yIQnHpwretguAOD5tNe/N0LQzps=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769864162; a=rsa-sha256;
	cv=none;
	b=eEmdxB2C3OG39jwLmdbZSDK9FiFVOgwfFox+3kVvS8o3B12NdwtggtNPi/42gVWLOO1G/r
	kEvyBtnYUvjgNmeUmD1n57XAim0MJxP/IFWQrYsUiq/m7zA25EbisTYmNXPO4eHa7FwA3U
	rWjN0OlRTklssvVDAQhSshruoTy/QEw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Jan 2026 21:55:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gunho.lee@lge.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH v3 1/5] mm: swap: introduce swap tier infrastructure
Date: Sat, 31 Jan 2026 21:54:50 +0900
Message-Id: <20260131125454.3187546-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260131125454.3187546-1-youngjun.park@lge.com>
References: <20260131125454.3187546-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92487180009
X-Stat-Signature: 1br84et8ktmcukep38fxzt4wrd1ib7py
X-Rspam-User: 
X-HE-Tag: 1769864159-542296
X-HE-Meta: U2FsdGVkX1+3vbIa1P5AzOwN3ADBC6Vz6dIOOHVF8d9Y9GdMYOThguSuP4NEO/Iq2er/yleDVsF5lmzK/V9cmj4f6KPaMIRS5/PwPfAkXL+3ulfsWvxSuxCsKSET9orRmTb+odXG40lYLqHnVZIRr6naJRVhhskgxAKuGQvKE5o+EKEhapFMd5zL1az1dTQQ+ENiCboYGSCc4vBPOUtYxt3gUxqV9egdy7NPQtdPpKbrKJs1Vr7+cPYPgdKlv4MySfAtvdKIp4uboYNRn+t4Y61VkxMk2Dy0+Mhu8pGCQmVKoY9HJU00kL9gskEm/k+Naso8scSk3hfo/GMgR2S+201jEiDICQ0oFZfDa/VI+NylHNuDvA0UBYkoXoMnBJEbg4Jpsdqly0pq/ToycxR867hZGlqf51uCO0fNACf7fbCX9wdvkXpvtwLeg5saauaw8GlnxHofx171ALm4FqZU1U3JvN100FKLxwODyejV+foOLR4ZlLQOBZ7byCei8AKvr+CWwB3BhDOmCd3zfR6XoQNRgu3Uc8JETvGlIQCLvi7E4Dq2BSCGGZ98BN1YoHUslPvqwY1dJ2LsUkb2xILj/2Eth8oBrVwAHsS4KHFhijkDds3ywV10DEreigJomUOExCc1EdkcjnDCLrhkBPgs3VU41BuqfQcbMXKy2Ia7RbntFUJmyK5als4hHaOg0fmYlHsWO+w2UIbVFvtgohghcJw/waztZCwgpiEebdBdvVadL7tqKp/Gsb6EgVf8U0gKyGN1IG5l30aGVHN0WHc6OauhxROhQBE42+cf9cfTslNKXvxtGD3in3ruCTqbz3bcMpDwby5LsquQQv/BzLoMmxaX6fRhDmlt79VWa4d67BqKczu2IvmaAsHYdQkHQhh9H/cYYsVRxck9X6nZv07wfW1bP1BEiQA1+mWqfaYF2x8/d7AZ3kTDBUc3Zhr7g0+LvPKENdjwGCUPI0q12DX
 1bKNPzF8
 PcX7sSVskpwmJ6VdMT/2OVkMTOHjsEvhSDQN5Z3rRmUrnlo6pKQLN2yKYR2ejozfceKl/wBP9wZS/uAJEPF1u6I5k35+PnrVD7oQuh+KK1OW5n5p8jsxj1pAXGEgwXUMl64r5Od3a0JnOVMABHQW/ftIYsnLKl9KbDM1a0AKsIgwunkk7azT29Utgtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces the "Swap tier" concept, which serves as an
abstraction layer for managing swap devices based on their performance
characteristics (e.g., NVMe, HDD, Network swap).

Swap tiers are user-named groups representing priority ranges.
These tiers collectively cover the entire priority
space from -1 (`DEF_SWAP_PRIO`) to `SHRT_MAX`.

To configure tiers, a new sysfs interface is exposed at
`/sys/kernel/mm/swap/tiers`. The input parser evaluates commands from
left to right and supports batch input, allowing users to add, remove or
modify multiple tiers in a single write operation.

Tier management enforces continuous priority ranges anchored by start
priorities. Operations trigger range splitting or merging, but overwriting
start priorities is forbidden. Merging expands lower tiers upwards to
preserve configured start priorities, except when removing `DEF_SWAP_PRIO`,
which merges downwards.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 MAINTAINERS     |   2 +
 mm/Makefile     |   2 +-
 mm/swap.h       |   4 +
 mm/swap_state.c |  70 +++++++++++
 mm/swap_tier.c  | 304 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_tier.h  |  38 ++++++
 mm/swapfile.c   |   7 +-
 7 files changed, 423 insertions(+), 4 deletions(-)
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 18d1ebf053db..501bf46adfb4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16743,6 +16743,8 @@ F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_tier.c
+F:	mm/swap_tier.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
diff --git a/mm/Makefile b/mm/Makefile
index 53ca5d4b1929..3b3de2de7285 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -75,7 +75,7 @@ ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o swap_tier.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
diff --git a/mm/swap.h b/mm/swap.h
index bfafa637c458..55f230cbe4e7 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -16,6 +16,10 @@ extern int page_cluster;
 #define swap_entry_order(order)	0
 #endif
 
+#define DEF_SWAP_PRIO  -1
+
+extern spinlock_t swap_lock;
+extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
 
 /*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6d0eef7470be..f1a7d9cdc648 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -25,6 +25,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -947,8 +948,77 @@ static ssize_t vma_ra_enabled_store(struct kobject *kobj,
 }
 static struct kobj_attribute vma_ra_enabled_attr = __ATTR_RW(vma_ra_enabled);
 
+static ssize_t tiers_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return swap_tiers_sysfs_show(buf);
+}
+
+static ssize_t tiers_store(struct kobject *kobj,
+			struct kobj_attribute *attr,
+			const char *buf, size_t count)
+{
+	char *p, *token, *name, *tmp;
+	int ret = 0;
+	short prio;
+	DEFINE_SWAP_TIER_SAVE_CTX(ctx);
+
+	tmp = kstrdup(buf, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	spin_lock(&swap_lock);
+	spin_lock(&swap_tier_lock);
+
+	p = tmp;
+	swap_tiers_save(ctx);
+
+	while (!ret && (token = strsep(&p, ", \t\n")) != NULL) {
+		if (!*token)
+			continue;
+
+		if (token[0] == '-') {
+			ret = swap_tiers_remove(token + 1);
+		} else {
+
+			name = strsep(&token, ":");
+			if (!token || kstrtos16(token, 10, &prio)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (name[0] == '+')
+				ret = swap_tiers_add(name + 1, prio);
+			else
+				ret = swap_tiers_modify(name, prio);
+		}
+
+		if (ret)
+			goto restore;
+	}
+
+	if (!swap_tiers_validate()) {
+		ret = -EINVAL;
+		goto restore;
+	}
+
+out:
+	spin_unlock(&swap_tier_lock);
+	spin_unlock(&swap_lock);
+
+	kfree(tmp);
+	return ret ? ret : count;
+
+restore:
+	swap_tiers_restore(ctx);
+	goto out;
+}
+
+static struct kobj_attribute tier_attr = __ATTR_RW(tiers);
+
 static struct attribute *swap_attrs[] = {
 	&vma_ra_enabled_attr.attr,
+	&tier_attr.attr,
 	NULL,
 };
 
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
new file mode 100644
index 000000000000..3bd011abee7c
--- /dev/null
+++ b/mm/swap_tier.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/swap.h>
+#include <linux/memcontrol.h>
+#include "memcontrol-v1.h"
+#include <linux/sysfs.h>
+#include <linux/plist.h>
+
+#include "swap.h"
+#include "swap_tier.h"
+
+/*
+ * struct swap_tier - structure representing a swap tier.
+ *
+ * @name: name of the swap_tier.
+ * @prio: starting value of priority.
+ * @list: linked list of tiers.
+*/
+static struct swap_tier {
+	char name[MAX_TIERNAME];
+	short prio;
+	struct list_head list;
+} swap_tiers[MAX_SWAPTIER];
+
+DEFINE_SPINLOCK(swap_tier_lock);
+/* active swap priority list, sorted in descending order */
+static LIST_HEAD(swap_tier_active_list);
+/* unused swap_tier object */
+static LIST_HEAD(swap_tier_inactive_list);
+
+#define TIER_IDX(tier)	((tier) - swap_tiers)
+#define TIER_MASK(tier)	(1 << TIER_IDX(tier))
+#define TIER_INVALID_PRIO (DEF_SWAP_PRIO - 1)
+#define TIER_END_PRIO(tier) \
+	(!list_is_first(&(tier)->list, &swap_tier_active_list) ? \
+	list_prev_entry((tier), list)->prio - 1 : SHRT_MAX)
+
+#define for_each_tier(tier, idx) \
+	for (idx = 0, tier = &swap_tiers[0]; idx < MAX_SWAPTIER; \
+		idx++, tier = &swap_tiers[idx])
+
+#define for_each_active_tier(tier) \
+	list_for_each_entry(tier, &swap_tier_active_list, list)
+
+#define for_each_inactive_tier(tier) \
+	list_for_each_entry(tier, &swap_tier_inactive_list, list)
+
+/*
+ * Naming Convention:
+ *   swap_tiers_*() - Public/exported functions
+ *   swap_tier_*()  - Private/internal functions
+ */
+
+static bool swap_tier_is_active(void)
+{
+	return !list_empty(&swap_tier_active_list) ? true : false;
+}
+
+static struct swap_tier *swap_tier_lookup(const char *name)
+{
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (!strcmp(tier->name, name))
+			return tier;
+	}
+
+	return NULL;
+}
+
+void swap_tiers_init(void)
+{
+	struct swap_tier *tier;
+	int idx;
+
+	BUILD_BUG_ON(BITS_PER_TYPE(int) < MAX_SWAPTIER);
+
+	for_each_tier(tier, idx) {
+		INIT_LIST_HEAD(&tier->list);
+		list_add_tail(&tier->list, &swap_tier_inactive_list);
+	}
+}
+
+ssize_t swap_tiers_sysfs_show(char *buf)
+{
+	struct swap_tier *tier;
+	ssize_t len = 0;
+
+	len += sysfs_emit_at(buf, len, "%-16s %-5s %-11s %-11s\n",
+			 "Name", "Idx", "PrioStart", "PrioEnd");
+
+	spin_lock(&swap_tier_lock);
+	for_each_active_tier(tier) {
+		len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
+				     tier->name,
+				     TIER_IDX(tier),
+				     tier->prio,
+				     TIER_END_PRIO(tier));
+		if (len >= PAGE_SIZE)
+			break;
+	}
+	spin_unlock(&swap_tier_lock);
+
+	return len;
+}
+
+static void swap_tier_insert_by_prio(struct swap_tier *new)
+{
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio > new->prio)
+			continue;
+
+		list_add_tail(&new->list, &tier->list);
+		return;
+	}
+	/* First addition, or becomes the first tier */
+	list_add_tail(&new->list, &swap_tier_active_list);
+}
+
+static void __swap_tier_prepare(struct swap_tier *tier, const char *name,
+	short prio)
+{
+	list_del_init(&tier->list);
+	strscpy(tier->name, name, MAX_TIERNAME);
+	tier->prio = prio;
+}
+
+static struct swap_tier *swap_tier_prepare(const char *name, short prio)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	if (prio < DEF_SWAP_PRIO)
+		return ERR_PTR(-EINVAL);
+
+	if (list_empty(&swap_tier_inactive_list))
+		return ERR_PTR(-EPERM);
+
+	tier = list_first_entry(&swap_tier_inactive_list,
+		struct swap_tier, list);
+
+	__swap_tier_prepare(tier, name, prio);
+	return tier;
+}
+
+static int swap_tier_check_range(short prio)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	for_each_active_tier(tier) {
+		/* No overwrite */
+		if (tier->prio == prio)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+int swap_tiers_add(const char *name, int prio)
+{
+	int ret;
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	/* Duplicate check */
+	if (swap_tier_lookup(name))
+		return -EPERM;
+
+	ret = swap_tier_check_range(prio);
+	if (ret)
+		return ret;
+
+	tier = swap_tier_prepare(name, prio);
+	if (IS_ERR(tier)) {
+		ret = PTR_ERR(tier);
+		return ret;
+	}
+
+
+	swap_tier_insert_by_prio(tier);
+	return ret;
+}
+
+int swap_tiers_remove(const char *name)
+{
+	int ret = 0;
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	tier = swap_tier_lookup(name);
+	if (!tier)
+		return -EINVAL;
+
+	/* Removing DEF_SWAP_PRIO merges into the higher tier. */
+	if (!list_is_singular(&swap_tier_active_list)
+		&& tier->prio == DEF_SWAP_PRIO)
+		list_prev_entry(tier, list)->prio = DEF_SWAP_PRIO;
+
+	list_move(&tier->list, &swap_tier_inactive_list);
+	return ret;
+}
+
+int swap_tiers_modify(const char *name, int prio)
+{
+	int ret;
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	tier = swap_tier_lookup(name);
+	if (!tier)
+		return -EINVAL;
+
+	/* No need to modify */
+	if (tier->prio == prio)
+		return 0;
+
+	ret = swap_tier_check_range(prio);
+	if (ret)
+		return ret;
+
+	list_del_init(&tier->list);
+	tier->prio = prio;
+	swap_tier_insert_by_prio(tier);
+
+	return ret;
+}
+
+/*
+ * XXX: Reverting individual operations becomes complex as the number of
+ * operations grows. Instead, we save the original state beforehand and
+ * fully restore it if any operation fails.
+ */
+void swap_tiers_save(struct swap_tier_save_ctx ctx[])
+{
+	struct swap_tier *tier;
+	int idx;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	for_each_active_tier(tier) {
+		idx = TIER_IDX(tier);
+		strcpy(ctx[idx].name, tier->name);
+		ctx[idx].prio = tier->prio;
+	}
+
+	for_each_inactive_tier(tier) {
+		idx = TIER_IDX(tier);
+		/* Indicator of inactive */
+		ctx[idx].prio = TIER_INVALID_PRIO;
+	}
+}
+
+void swap_tiers_restore(struct swap_tier_save_ctx ctx[])
+{
+	struct swap_tier *tier;
+	int idx;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	/* Invalidate active list */
+	list_splice_tail_init(&swap_tier_active_list,
+			&swap_tier_inactive_list);
+
+	for_each_tier(tier, idx) {
+		if (ctx[idx].prio != TIER_INVALID_PRIO) {
+			/* Preserve idx(mask) */
+			__swap_tier_prepare(tier, ctx[idx].name, ctx[idx].prio);
+			swap_tier_insert_by_prio(tier);
+		}
+	}
+}
+
+bool swap_tiers_validate(void)
+{
+	struct swap_tier *tier;
+
+	/*
+	 * Initial setting might not cover DEF_SWAP_PRIO.
+	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
+	 * Also, modify operation can change only one remaining priority.
+	 */
+	if (swap_tier_is_active()) {
+		tier = list_last_entry(&swap_tier_active_list,
+			struct swap_tier, list);
+
+		if (tier->prio != DEF_SWAP_PRIO)
+			return false;
+	}
+
+	return true;
+}
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
new file mode 100644
index 000000000000..4b1b0602d691
--- /dev/null
+++ b/mm/swap_tier.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SWAP_TIER_H
+#define _SWAP_TIER_H
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+
+#define MAX_TIERNAME		16
+
+/* Ensure MAX_SWAPTIER does not exceed MAX_SWAPFILES */
+#if 8 > MAX_SWAPFILES
+#define MAX_SWAPTIER		MAX_SWAPFILES
+#else
+#define MAX_SWAPTIER		8
+#endif
+
+extern spinlock_t swap_tier_lock;
+
+struct swap_tier_save_ctx {
+	char name[MAX_TIERNAME];
+	short prio;
+};
+
+#define DEFINE_SWAP_TIER_SAVE_CTX(_name) \
+	struct swap_tier_save_ctx _name[MAX_SWAPTIER] = {0}
+
+/* Initialization and application */
+void swap_tiers_init(void);
+ssize_t swap_tiers_sysfs_show(char *buf);
+
+int swap_tiers_add(const char *name, int prio);
+int swap_tiers_remove(const char *name);
+int swap_tiers_modify(const char *name, int prio);
+
+void swap_tiers_save(struct swap_tier_save_ctx ctx[]);
+void swap_tiers_restore(struct swap_tier_save_ctx ctx[]);
+bool swap_tiers_validate(void);
+#endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7b055f15d705..c27952b41d4f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -50,6 +50,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
@@ -65,7 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
 
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -76,7 +77,6 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -89,7 +89,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  * all active swap_info_structs
  * protected with swap_lock, and ordered by priority.
  */
-static PLIST_HEAD(swap_active_head);
+PLIST_HEAD(swap_active_head);
 
 /*
  * all available (active, not full) swap_info_structs
@@ -3977,6 +3977,7 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	swap_tiers_init();
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.34.1


