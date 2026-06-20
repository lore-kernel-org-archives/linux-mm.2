Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6970CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0496B008C; Sat, 20 Jun 2026 14:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A16D6B0092; Sat, 20 Jun 2026 14:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7C86B0093; Sat, 20 Jun 2026 14:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 149836B008C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:16:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DF041201CB
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:16:56 +0000 (UTC)
X-FDA: 84901097232.06.1863FB9
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C07140005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:16:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hrLs013N;
	spf=pass (imf07.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqZzVql8FFtxQrj+HBUYcxO/Pzzfu2IxHZz+7Ww15C0=;
	b=jBQgIHgs3BQRSrj2X+a2uFS3AxZZ+g+OnNmZnPy6gy2L7YZf99G+I70ucpGc4LWHiDh8f1
	tmHbR0iHumIMR0NAMinUYHaYelpeXbS9HnNKW/hrFe98Sdxx+h1ijNGEAqVzzBmuqVeO+/
	EBEHktvc5d5PerSC8YqK8/i72eERcj0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979414;
	b=5qoAmlgXJK6Ax1EsV3+w2yyY0CshGfAdXDaPP/RYaubnlPr9t+qu8zC+h+7GdWRluQ1CI2
	om5ycOofHDzR+05j+1+zN4f3asP9SviPoBx7KaGB7F5kE8zErgkjSlboAnOmpzUTdLuwf8
	/bHFPcD0AJL+BumhUZ9ZGP+hcS+iqN4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hrLs013N;
	spf=pass (imf07.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c0c1e0d00bso34176175ad.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979413; x=1782584213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqZzVql8FFtxQrj+HBUYcxO/Pzzfu2IxHZz+7Ww15C0=;
        b=hrLs013NmvBf1NKunsaezJZub8YcbaWQo1/ZAL2iqYm1cWlovJkeorIuBEGrTbk6wz
         7o81ehniH58VpNPFUI4F8HNzhFjIKnfyWszKuc5Gfikv2fpcpP5TZd8ZrNSDtuTLzPbG
         BOLbCcjKhg6iFe9FA8pnToUe+Fa0k61YmDWAqDIQHbrkOc/rGIadTa0215IhEz0cwM4N
         sqWMNORqE9tQ2CCtfpY5MD73/WiVCCIraMffTG0KQMoERyTvTQ2V2Ro+Ce+PaOL8v7Bu
         6Il8+qorTV705fAO811m27eCL/9azsKuvL6v+JbgpUb9EGTkhzIt8iNygiGxIWZfh6Qr
         jG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979413; x=1782584213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqZzVql8FFtxQrj+HBUYcxO/Pzzfu2IxHZz+7Ww15C0=;
        b=o1yrHdaBPyKSOkLNP+gow9yW/H7jixXKmdTqD9CdZakrMmBkxvC07PkWLSEcdqwPOL
         DB2uuCHraf1CMU/Q7vMyioFaMlWhNnSDtt/5eGMGyqRPe38WNWAM4XEzBH3qJp4yxwrM
         K8fOAt2d8aNe+448W3ezqts7YE1CKKOK+3iq59sbh2LjQ9ejlDEOuNei6NI5CrEB0JGI
         s3ILToZyMaQENatGe2lPM/ZF57rRTjQ67yqSzQYrLqAcUybCbyHCwnhWWlV1vn4VrrQg
         xmgfuM+rRNktMnmbIjFyyD8h25xpT4X5s4ZOi8ZXzCpxI2k6cwrC2sJH0K5ZjYJEuIof
         mlBg==
X-Forwarded-Encrypted: i=1; AHgh+Ro6UAdkIlqeS/juKbm2sWc/ipCrwlcbqTM8RQ+S/N10sSKx/EYdKNQz9biZJY7zLM1n4au1aBevmg==@kvack.org
X-Gm-Message-State: AOJu0YxBf4NQLVBxJ51Q33/6lvcrQCBtSfmN19M/d9p9Rw2CcuGo2ngX
	TQrr0+elqXiFXtizScebxtYYWquMhc0/s7fOJxSOkdXW7sPUqQvAVWMA
X-Gm-Gg: AfdE7clvD/abz4h6/IH7up/h4/C+NG9VKB45kQNR0aoXT/z1zUYVbbb0MRSOujY9vJG
	i+YaIhXGO3JMh05PYZPGeJS2a+Sm9W3cj1QlotSKuRJUoeF4PlhhpIQsE3bgPym+gjqYn7UG8Eb
	AqiztL/FfZk/VpVRPEKa7E+LuN0O5YRQIqk83XXyVU1Y2O8ogz0IInF1RjDGXTJg7MPD499psb9
	xoQPzLSYpI9r3m+LvqXH3X7PFB9RrcIIVJmMDprMaZ4QyR5WluEXcS2MSV3BMuxOlN4Ih8fIsaH
	paL++DxxBnohBrSM9Nt/fRN5yy/X5zRykbKG9tfek6d+xFE7G8I7Y1KSewghDHGZcfXdW4SwmJS
	NPEcSQB1WXDzk+Q6uAPfflKpfbnwbHEdSwyd9vP8CZ9m2sQPf46JJSx+Ben39fXY6WK0dlHIyww
	guWoVGPPwEvh7HeaPYj8vEjHOoKGB9EYTjUrwCm9UQPo+W94WoQBKF9HkLk6gdWX6rA5ZJkqf5v
	zK6SZWVp3aM
X-Received: by 2002:a17:902:cf0a:b0:2c6:cbcb:bc77 with SMTP id d9443c01a7336-2c725db5fbbmr81085355ad.28.1781979413256;
        Sat, 20 Jun 2026 11:16:53 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:16:52 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
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
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v9 1/6] mm: swap: introduce swap tier infrastructure
Date: Sun, 21 Jun 2026 03:16:26 +0900
Message-ID: <20260620181635.299364-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
References: <20260620181635.299364-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C07140005
X-Stat-Signature: 6es7ocbi9c7tbwf7hq7hkqt13g61y39z
X-HE-Tag: 1781979414-150353
X-HE-Meta: U2FsdGVkX1/5xubItXOnq0ouO098BJ12xnOl+tyrYsqFYoeTFmQEn1fn3PvTV5KglG0Zc9o8IBUG82yldtJ3j5cykjhYhwagKEXleiZ0SN0QcxlI7tOf95AGzkm7RpnlP1yc/XG73IqmtUevQK5Bj/wX9fR05IANTFX75OxkveWPgMNReHQZqIkm4v2awqo1Z8+ysyPbuyHuNI23aXwJ0/OYbSHMcfTx9gJ2D/UI/ZeHbEY0BdekYXPONVuoGwAF3rAuEY3BYp7QKqVgSTwcYA5fP7F3wARMbiTSsP7+U/URdlIGkkbJeRF4xgg1nPxc9zl0EAAH2upg6l7wwJYSbkqw1ImPi2QAt8ymB0REWFDl8aDh8+QBP8E8Hqxx2PpSQLknjquAqj5e57JDUmI2r0yCq/Bh0l5HDN5w0yJVtIrUZkTyRht3ZsxqO28eK3z2nce1hEluSlJx1Gp+Hs4Rod+IKLFIKGGBYbwyq6l3wz5sVXpUfA4lfmrzL8/AsPRpBTMMN1wxyaQ8oK8okM56GDgIE2ZLevxv0ZqyNEBYg/1TUPj9fDsesl89CnSq0sfVmAeJQRKEsJWqkD4WX4oMYqcEey1yOzhH4ZvR8Wc8H2w2yYnguYEnUN1GTtID0oRvrqoNsgN0kMQp8WNOlagxA1+EDfaxDdnvWwPCQpLPDBos4lmUuhk7HvkF7HZibMIQtuBNbq6T4b+4yuM1I5Y6PyvBXZQaCK1UYs8FbWNkPY34Ah4yIB/dOO5uQDTFxxiMm9QUBP+RR5bamL+UWkWHfc7YCMODov2qaqOinPvjCTpDi5cb80HTcGTmKRzZdCwDDoOt6rYrTPLHEJvI9N0moem2rkbY9/U0WWAKl9xCO2jNoA4d2MsLvKIs5qvIfYm0IhcmM954qvu7nTGdonDjLY1CgHuVrx/uFwuealtkUi039G4kCl5P3wsYVKqJV4p9HVudG6B0NekojWn/jjd
 XvkrXEcJ
 6iPd3f7qvdW2yigGTdk0DOh4dLZB8KHNUz2wRrX44qn6xndviOa8E0XrRlZNUfFrFLkUa1doZZJCc3swWgVtTukXOxA8gEc7PxJgcfvvrKFd99Z/6obmKHDIHpBjV6oFQkR2SY2VYlF/qj6EyeOvlZdtLgl0BMwtcNwww5MDy5Dc+Y0EPBsxPlvojlwoIT/OKgomfypWWXu4yBqYeet4KygkPvcHACXWo3cvBFlliDaqdjWHilOw+qM/pEsrt7p9XFlZ1w3FCGEHKKLiEZGXNz3FE1xfl5VWwIkgL/nW+M78yPXrcZBql3COo46gxRNZuheSxPXodGfrJ63Px9umXNSv6uS4Z+YgoWdZ+o1s1ZHP90ait03fCfa+TtGIzG3gE5XSkNiLdbXsMs0o4xPQykMuoaA==
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
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 MAINTAINERS     |   2 +
 mm/Kconfig      |  12 ++
 mm/Makefile     |   2 +-
 mm/swap.h       |   4 +
 mm/swap_state.c |  74 ++++++++++++
 mm/swap_tier.c  | 302 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/swap_tier.h  |  20 ++++
 mm/swapfile.c   |   8 +-
 8 files changed, 420 insertions(+), 4 deletions(-)
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 65bd4328fe05..d1bb3b4b1e1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17060,6 +17060,8 @@ F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
+F:	mm/swap_tier.c
+F:	mm/swap_tier.h
 F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
diff --git a/mm/Kconfig b/mm/Kconfig
index 776b67c66e82..5343937f3da9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -19,6 +19,18 @@ menuconfig SWAP
 	  used to provide more virtual memory than the actual RAM present
 	  in your computer.  If unsure say Y.
 
+config NR_SWAP_TIERS
+        int "Number of swap device tiers"
+        depends on SWAP
+        default 4
+        range 1 31
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
index eff9f9e7e061..29cb1e778285 100644
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
index 77d2d14eda42..d6c5f5d31f63 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -34,6 +34,10 @@ extern int page_cluster;
 #define swap_entry_order(order)	0
 #endif
 
+#define DEF_SWAP_PRIO  -1
+
+extern spinlock_t swap_lock;
+extern struct plist_head swap_active_head;
 extern struct swap_info_struct *swap_info[];
 
 /*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..762d9ca6ad5a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -25,6 +25,7 @@
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
@@ -1007,8 +1008,81 @@ static ssize_t vma_ra_enabled_store(struct kobject *kobj,
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
+				goto restore;
+			}
+			*token++ = '\0';
+			if (kstrtos16(token, 10, &prio)) {
+				ret = -EINVAL;
+				goto restore;
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
+			goto restore;
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
index 000000000000..ac7a3c2a48cb
--- /dev/null
+++ b/mm/swap_tier.c
@@ -0,0 +1,302 @@
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
+#define TIER_MASK(tier)	(1U << TIER_IDX(tier))
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
+	return !list_empty(&swap_tier_active_list);
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
+	struct list_head *pos = &swap_tier_active_list;
+	struct swap_tier *tier;
+
+	for_each_active_tier(tier) {
+		if (tier->prio <= new->prio) {
+			pos = &tier->list;
+			break;
+		}
+	}
+
+	list_add_tail(&new->list, pos);
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
+		len += sysfs_emit_at(buf, len, "%-16s %-5td %-11d %-11d\n",
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
+	int len;
+
+	if (!name || !*name)
+		return false;
+
+	len = strlen(name);
+	if (len >= MAX_TIERNAME)
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
+	/*
+	 * memcpy copied snapshot-time list pointers into each tier's
+	 * list_head.  Those references are stale, so re-init every
+	 * tier before re-linking into the freshly initialised global
+	 * lists below.
+	 */
+	for_each_tier(tier, idx) {
+		INIT_LIST_HEAD(&tier->list);
+
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
index e3d126602a1e..3f7225dbc6cd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,6 +48,7 @@
 #include "swap_table.h"
 #include "internal.h"
 #include "swap.h"
+#include "swap_tier.h"
 
 static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries);
@@ -63,7 +64,8 @@ static void move_cluster(struct swap_info_struct *si,
  *
  * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
  */
-static DEFINE_SPINLOCK(swap_lock);
+DEFINE_SPINLOCK(swap_lock);
+
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 /*
@@ -74,7 +76,6 @@ atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
-#define DEF_SWAP_PRIO  -1
 unsigned long swapfile_maximum_size;
 #ifdef CONFIG_MIGRATION
 bool swap_migration_ad_supported;
@@ -87,7 +88,7 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  * all active swap_info_structs
  * protected with swap_lock, and ordered by priority.
  */
-static PLIST_HEAD(swap_active_head);
+PLIST_HEAD(swap_active_head);
 
 /*
  * all available (active, not full) swap_info_structs
@@ -3988,6 +3989,7 @@ static int __init swapfile_init(void)
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
 
+	swap_tiers_init();
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.48.1


