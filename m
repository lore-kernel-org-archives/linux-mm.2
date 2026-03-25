Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCEBB109C04D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F62C6B0089; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4318D6B008A; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7506B008C; Wed, 25 Mar 2026 13:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB2CD6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:55:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA969160A44
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:02 +0000 (UTC)
X-FDA: 84585336444.06.6BAE0B1
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66ACB4000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774461301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4iwt7iOnwra1jGnQCcvOsgDqpx5fOQttjG9nILk+TME=;
	b=MwrjezO9BkMB1JngSjFNhgXS+yrnlwOr0czDo5PmAIDSHyZmGoFjQnMFLfBswIXg45O6nJ
	tWfr09arz5hUTNnPciTYJXJ7jit1ZTevjQ62gvEMrnSXx1sBq0Fq5hJVvEPRYUgU6ch8LA
	QUiBMoA6LK337iQbtOuj81DALOKnLNg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774461301; a=rsa-sha256;
	cv=none;
	b=eI6uXsjwefe2HaeHtBO2oeMgiYSxnQ8tjepDIGc5Olm6JbGMhfRKxLQrVaId6cFWrkA0h7
	E5BiPz+Jqh2TOGkCDpvBDWGxJs8KuQziHOktYMr65IElesgtiIt1KHXsqFLVmUkpoQM66w
	5Nx/8Cklac8U4bNnHctODLMF3dveXMQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 02:54:56 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
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
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com
Subject: [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
Date: Thu, 26 Mar 2026 02:54:50 +0900
Message-Id: <20260325175453.2523280-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325175453.2523280-1-youngjun.park@lge.com>
References: <20260325175453.2523280-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 66ACB4000D
X-Stat-Signature: mkhy6tk1bfs9ehmtk3uzyeohrpq93jga
X-Rspamd-Server: rspam06
X-HE-Tag: 1774461300-673019
X-HE-Meta: U2FsdGVkX18exhqdWgYMkBEz81ExN9mpS9c1zDytBMIYEQR+308wl7mZMlNaPuZLYs21kPmng3ExYHrNAyqxMNQHx5ORm6xCeKXvGnuND+U8KRlKQ+U3ZjW/1V9ypbJklOapbf3f8tyf9BNwstAyhIAblOksZ290ukUIQChwqWz4XIppsCR6FuSH3s2BV+xcXRKleLW614mU0qhD9iwKYVZT1QIc+OPNsAR7HSI7rcxC6q+PNqDzVDBkD+1/B4oQxIFe5HZmZAvDvkk6J2BV5TXf7n/AKD6CJwjcgWdX5VzYGZQBjcNPAWiGZxzkbVi/3A1fLzxqU2iP4354kmI/BfFizOJhJsXhZ0o1DA4UZBD0Q7PE9TEMCIY+1mXc003m70WqH98qOAn+QDtT8P/mnKv6qP5TfmkdTtkXj6FhDmEq8Meszl+pU7CzMUbQdedwg1J5Lt9C3bf7iJP6LKJPFPN6ivTQbwiGCC7BLfuWC/gpdXkuPyrA45tSEankjuhrWLLG5zVbu7MeIQpa4m+YY7XFsavOgGh1uRSryrM+avfv4r5dmI1VQX2U21xhf5qgviqRtZoOvirRoKj59VNanJDLbhAYCjX2ze908cOp+2uvoj/MlVUyNiy6PWbNicwd8r8NAQAwxWgyfEVP1vcFOo99fgsnwRG9t6V8UVZ0oQDWH77dp8PC2Uuhvx/HZeL7bDKUHZcIhmiiInP5XifXw7978XaH2q2rztfTMaA56h4JHn66eWG3jYhk+p3/zBOxImkh/ay8Jng/vtYOjEUBnzJv6VoVwBvicJg0SxbYTo/zxuuh6V1zTQroqrBbpXd7aZaw3ZP2JpWQi+EJxeIMbS8eo46Pj+XA9ssRseTOQw0/4AQfkoX8/o+5AV28h4JJwi2OcXtR7tqmcbPgFZSjRwDviEE1i5s+l7WBSNUbmoEszI+Y3ekZogoesyeAEXrwuVYWhcQKQwWT6v+anJS
 BGwAu1SL
 x9elEpTYEaRqZ7c1G5yuA2mSo4BF1ZLO+WVdvLIgqRC5nnF1jTpZWNG5We93GsqSbb3nn6o78lnmjiWL0/SnPlY4jRHIZ3rhLGgIdZhV4XNd6j6aW2gT7kMihisA0Y1XC9cTC4Wpj7FDPIZvOsDaGro3cUzaHekaLddVGq0gvUxZU0JvCKk7ZwbtYNA==
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
Tier names must consist of alphanumeric characters and underscores.
These tiers collectively cover the entire priority space from -1
(`DEF_SWAP_PRIO`) to `SHRT_MAX`.

To configure tiers, a new sysfs interface is exposed at
/sys/kernel/mm/swap/tiers. The input parser evaluates commands from
left to right and supports batch input, allowing users to add or remove
multiple tiers in a single write operation.

Tier management enforces continuous priority ranges anchored by start
priorities. Operations trigger range splitting or merging, but overwriting
start priorities is forbidden. Merging expands lower tiers upwards to
preserve configured start priorities, except when removing `DEF_SWAP_PRIO`,
which merges downwards.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 MAINTAINERS     |   2 +
 mm/Kconfig      |  12 ++
 mm/Makefile     |   2 +-
 mm/swap.h       |   4 +
 mm/swap_state.c |  74 +++++++++++++
 mm/swap_tier.c  | 285 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_tier.h  |  20 ++++
 mm/swapfile.c   |   8 +-
 8 files changed, 403 insertions(+), 4 deletions(-)
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 76431aa5efbe..f3b07f1fa38a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16916,6 +16916,8 @@ F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_tier.c
+F:	mm/swap_tier.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..b645e9430af5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -19,6 +19,18 @@ menuconfig SWAP
 	  used to provide more virtual memory than the actual RAM present
 	  in your computer.  If unsure say Y.
 
+config NR_SWAP_TIERS
+        int "Number of swap device tiers"
+        depends on SWAP
+        default 4
+        range 1 32
+        help
+          Sets the number of swap device tiers. Swap devices are
+          grouped into tiers based on their priority, allowing the
+          system to prefer faster devices over slower ones.
+
+          If unsure, say 4.
+
 config ZSWAP
 	bool "Compressed cache for swap pages"
 	depends on SWAP
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..db6449f84991 100644
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
index a77016f2423b..fda8363bee73 100644
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
index 1415a5c54a43..bfdc0208e081 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -25,6 +25,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -924,8 +925,81 @@ static ssize_t vma_ra_enabled_store(struct kobject *kobj,
 }
 static struct kobj_attribute vma_ra_enabled_attr = __ATTR_RW(vma_ra_enabled);
 
+static ssize_t tiers_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return swap_tiers_sysfs_show(buf);
+}
+
+static ssize_t tiers_store(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    const char *buf, size_t count)
+{
+	char *p, *token, *name, *tmp;
+	int ret = 0;
+	short prio;
+
+	tmp = kstrdup(buf, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	spin_lock(&swap_lock);
+	spin_lock(&swap_tier_lock);
+	swap_tiers_snapshot();
+
+	p = tmp;
+	while ((token = strsep(&p, ", \t\n")) != NULL) {
+		if (!*token)
+			continue;
+
+		switch (token[0]) {
+		case '+':
+			name = token + 1;
+			token = strchr(name, ':');
+			if (!token) {
+				ret = -EINVAL;
+				goto out;
+			}
+			*token++ = '\0';
+			if (kstrtos16(token, 10, &prio)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			ret = swap_tiers_add(name, prio);
+			if (ret)
+				goto restore;
+			break;
+		case '-':
+			ret = swap_tiers_remove(token + 1);
+			if (ret)
+				goto restore;
+			break;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (!swap_tiers_validate()) {
+		ret = -EINVAL;
+		goto restore;
+	}
+	goto out;
+
+restore:
+	swap_tiers_snapshot_restore();
+out:
+	spin_unlock(&swap_tier_lock);
+	spin_unlock(&swap_lock);
+	kfree(tmp);
+	return ret ? ret : count;
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
index 000000000000..62b60fa8d3b7
--- /dev/null
+++ b/mm/swap_tier.c
@@ -0,0 +1,285 @@
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
+#define MAX_SWAPTIER	CONFIG_NR_SWAP_TIERS
+#define MAX_TIERNAME	16
+
+/*
+ * struct swap_tier - structure representing a swap tier.
+ *
+ * @name: name of the swap_tier.
+ * @prio: starting value of priority.
+ * @list: linked list of tiers.
+ */
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
+#define TIER_INACTIVE_PRIO (DEF_SWAP_PRIO - 1)
+#define TIER_IS_ACTIVE(tier) ((tier->prio) !=  TIER_INACTIVE_PRIO)
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
+/* Insert new tier into the active list sorted by priority. */
+static void swap_tier_activate(struct swap_tier *new)
+{
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio <= new->prio)
+			break;
+	}
+
+	list_add_tail(&new->list, &tier->list);
+}
+
+static void swap_tier_inactivate(struct swap_tier *tier)
+{
+	list_move(&tier->list, &swap_tier_inactive_list);
+	tier->prio = TIER_INACTIVE_PRIO;
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
+		swap_tier_inactivate(tier);
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
+	}
+	spin_unlock(&swap_tier_lock);
+
+	return len;
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
+		return ERR_PTR(-ENOSPC);
+
+	tier = list_first_entry(&swap_tier_inactive_list,
+		struct swap_tier, list);
+
+	list_del_init(&tier->list);
+	strscpy(tier->name, name, MAX_TIERNAME);
+	tier->prio = prio;
+
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
+static bool swap_tier_validate_name(const char *name)
+{
+	if (!name || !*name)
+		return false;
+
+	while (*name) {
+		if (!isalnum(*name) && *name != '_')
+			return false;
+		name++;
+	}
+	return true;
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
+		return -EEXIST;
+
+	if (!swap_tier_validate_name(name))
+		return -EINVAL;
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
+	swap_tier_activate(tier);
+
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
+	swap_tier_inactivate(tier);
+
+	return ret;
+}
+
+static struct swap_tier swap_tiers_snap[MAX_SWAPTIER];
+/*
+ * XXX: When multiple operations (adds and removes) are submitted in a
+ * single write, reverting each individually on failure is complex and
+ * error-prone. Instead, snapshot the entire state beforehand and
+ * restore it wholesale if any operation fails.
+ */
+void swap_tiers_snapshot(void)
+{
+	BUILD_BUG_ON(sizeof(swap_tiers_snap) != sizeof(swap_tiers));
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	memcpy(swap_tiers_snap, swap_tiers, sizeof(swap_tiers));
+}
+
+void swap_tiers_snapshot_restore(void)
+{
+	struct swap_tier *tier;
+	int idx;
+
+	lockdep_assert_held(&swap_lock);
+	lockdep_assert_held(&swap_tier_lock);
+
+	memcpy(swap_tiers, swap_tiers_snap, sizeof(swap_tiers));
+
+	INIT_LIST_HEAD(&swap_tier_active_list);
+	INIT_LIST_HEAD(&swap_tier_inactive_list);
+
+	for_each_tier(tier, idx) {
+		if (TIER_IS_ACTIVE(tier))
+			swap_tier_activate(tier);
+		else
+			swap_tier_inactivate(tier);
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
index 000000000000..a1395ec02c24
--- /dev/null
+++ b/mm/swap_tier.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SWAP_TIER_H
+#define _SWAP_TIER_H
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+
+extern spinlock_t swap_tier_lock;
+
+/* Initialization and application */
+void swap_tiers_init(void);
+ssize_t swap_tiers_sysfs_show(char *buf);
+
+int swap_tiers_add(const char *name, int prio);
+int swap_tiers_remove(const char *name);
+
+void swap_tiers_snapshot(void);
+void swap_tiers_snapshot_restore(void);
+bool swap_tiers_validate(void);
+#endif /* _SWAP_TIER_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ff315b752afd..03bf2a0a42ac 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,6 +49,7 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -64,7 +65,8 @@ static void move_cluster(struct swap_info_struct *si,
  *
  * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
  */
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
+
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -75,7 +77,6 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -88,7 +89,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  * all active swap_info_structs
  * protected with swap_lock, and ordered by priority.
  */
-static PLIST_HEAD(swap_active_head);
+PLIST_HEAD(swap_active_head);
 
 /*
  * all available (active, not full) swap_info_structs
@@ -3890,6 +3891,7 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	swap_tiers_init();
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.34.1


