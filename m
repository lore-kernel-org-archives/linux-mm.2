Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CA9CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CE56B0093; Sat, 20 Jun 2026 14:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7896B0095; Sat, 20 Jun 2026 14:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3FCA6B0096; Sat, 20 Jun 2026 14:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFE936B0093
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:17:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 413881C46F8
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:07 +0000 (UTC)
X-FDA: 84901097694.01.D4FC430
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43791140003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:17:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nkMts5M+;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJdnGcYqrN2PZHNQjPn0cMT+HfsR3sWO/K33y7osfm0=;
	b=xOq3xNjaMaIXCdFoynwKl/JZ3WbXB6bzsJ61tAn8s0Q1MSvtkQeLX9bbROvn7Rqa8Z8PVW
	0vy1RWhEymTNvu5Z7SVughasAQ7KnNtDfrQWF9M07tRVwEIRoZP6sXjRVg8FpedhrMd3eW
	anli/e+PGIrim8DsDV4BKanjcKLVpeM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979425;
	b=xOOFoTs5Rt1/tpVcRsvAKnw7tH/xFAAhyNCAmtuG8+xj7mTop4biJoS5JeIOvKnkdsDDuB
	x4eOufOS3y5a5zaNkeiQajPUtWzbL7L7In/ubceC9I0l1nDvXN2L1/ZdCQ9wzEkXd+U+iR
	KzHJ6LqqM8f0grFKhv8Mn2cvgZim8wk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nkMts5M+;
	spf=pass (imf23.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c0c1e0d00bso34177165ad.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979424; x=1782584224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJdnGcYqrN2PZHNQjPn0cMT+HfsR3sWO/K33y7osfm0=;
        b=nkMts5M+MtAyzkzq4WBogjeU1KrK9B/fXPYvBynf3MAXjmpuD+2GEqwZh7dcLVvWM9
         2+zWRUGWsBBpCh/VCJzs1eTyB+JN0enG8y/lm2k5HNEh1fl4FeYSz3fRZpodZPy1CTKx
         +xreArCg3D6jnwzZ5TVL1ek5/x22CIG1hdwvJqizGiThJhmTEcKrG7QQdxkTi+TY33+v
         RFvmaCzXtv8udCmrAbaDQ/IZJPpvONNNfGD9i8vLopsYBqrxyRSGj0J3boIuINlBfVRf
         dIKMrg0rSril6cR4kdfTBVwtKq7gzIA8pIUl3elxKOcOqHl6gJh2UTjlKvNd/LwHwXcC
         aBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979424; x=1782584224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XJdnGcYqrN2PZHNQjPn0cMT+HfsR3sWO/K33y7osfm0=;
        b=VOXCFF75KvlDPQQ/Mgfy4uEyeZYVRkU+XKzeZliBYKL/yzxBQwM1yOFD6Vz165ybN+
         PIlzllCSs2Zp4oETukpCYSZc6iyqSe0KHFTmRMhQaSgf6WfTsr6SMHssf22MJOnk2xxL
         ntXHJOji3RvDesy+J67aWhv6Fnu8db7Vt2e8nCTpYA1GXtNny7IBawBmGtCE5VbAPuHn
         hkq6cE3HJUnjhxYa/mi56iafnrfkMDVamoOeB5OVAj5vqe8sp8VBihk73iMi/cIXsj+r
         94QaSf6d+nIGBJ/0JNTES9e62Du51xNfichJ/cNVVw6GREq+8/I0b+h+xuqsH4qA+QjN
         sPdA==
X-Forwarded-Encrypted: i=1; AHgh+Rpw9WGmEaazB+u+vUcKrwCD2pYXjXQfRBcdsKqaXAk3qqUZHw/MpGiJEs7k6WIq9dKkKwepfWFCfA==@kvack.org
X-Gm-Message-State: AOJu0YxoIirWPRBDepQIIrNA+mg4MkGwCp4NNvUp78T/XLJKjidp3yRb
	wY7KsedakmH8u/ZcKz5Id97KWIwS37KIZu9FaGJhr9xyIAqKtniyblF5
X-Gm-Gg: AfdE7cnXNI6RwKk0rYd59lj98Q7AU96pIU1xbmCxuDfoBXOBF3QTFnMJsprqpaflFeU
	nYI5qEdVuv/Ptt/5+9MTU0jGwSKmeWzWeAZBmPSqzSykBuu8zUVnEbylW2YPw/FWu65cp/hVrSr
	qIEStVdAS3+W+GBr6XsLe5zoMx4dR/iBaay33plYMuYxIqc87CrCZZBqYCw7rTJSX8WeQRtRvhI
	lNEBiERwLJDTEWnWq8Q3uEvqBI4Hsml6YErsdH5xr4yj2AbKqXwj2RXejwLYc+yANa+yKLheXmP
	W9mFODelT/+URjjQB+9qwN/zQpbHGoLjxSk3Q96hFwK+Y3LHCCortZuSGwAV1bpmKx9wCUjseZ4
	E3ZfKZSdptwSrnL0G9XPjr6zrz8QlqpDyYf/BAV+0bDZa2LWi/85pvEcX3hxwnHy9uzYssDdGlT
	wZUNQLsCEpN1K3zmBv7iAFAuCZK4NbePqqTztklavmYrbJ1xg2Gg++y8ruJsdhf62YSU7MQuCCS
	w==
X-Received: by 2002:a17:903:1a44:b0:2ba:6518:a6d4 with SMTP id d9443c01a7336-2c725d7ee92mr81603135ad.20.1781979424175;
        Sat, 20 Jun 2026 11:17:04 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:17:03 -0700 (PDT)
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
Subject: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
Date: Sun, 21 Jun 2026 03:16:28 +0900
Message-ID: <20260620181635.299364-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260620181635.299364-1-youngjun.park@lge.com>
References: <20260620181635.299364-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43791140003
X-Rspam-User: 
X-Stat-Signature: x5my5nwabjshcx8a7dzq8ryeb3joou49
X-HE-Tag: 1781979425-285494
X-HE-Meta: U2FsdGVkX19lpBOkdRpJSOQoDaWoQTgWpB8BJq2qdr0p8tg7rrlMTcnwizSh1WOyX4SSVKqtSuYNekrTV3WQpsUwDb7YgCG2Stp7aoC73FjZ1O3ELnZCOYgP40isuNpp6iqkQFSLbNIMZUyEKbFChRScFAakDWOjPdLx3Bk1XF8MjS4mdCT8NbjKDmVf9QUaXno8djW/QjcQM3xaAZEP5RfDmS0FbyGEqtFik7SEcaakR6/2/HKJfcBmIXMlzQ3kdc50S31mLQe8YDtitPcB9n4Zi6KaRaT8JJykxViaqkJ5vHK2mIvwahufZ+P39H+QAZL7r1aHQLyFWQgPY6OQz8oHa3BN9airwvsBxSk9lGYLZU2U2AW2816DZCbADilQmKoSePE9TLMKHCb9U7GyIRupjpRZJNwpEs3A3lS/x1WzNc85cfiOQoc/QlwFaOOn29DrOpJ3SnqF4fzBqsuIxiFpnfLphn1nx2vHxwMN5xwL1vFsAKXgaPVzyXQxIKeHDNazoqhu7aPfp7oQWGyJ6FdVxZKJ50EzdZce1jrvQFizdAwFFJcFAhEP9xtSF2+PlhmHOZPXefVhcbKUISm7WbuCcweTyrQS/0kdhEyRyFyXFu3nVjk93JUMzN6LTufOu02WEaa6Uq3gdLwrBwgx8h3DIVXBf/zxQAGpt2z9WtnFNiglzv1TB3KDj6XYLEx6EV2QgkWLIiRh/h6I9p7WlS2fTDWfyl1ROu3bXAlhGRDYzT2R8fvjzZKbaGSJ0EaGswtin2zWYPjJk/sbPe0+gIqHmybiM3ckQPVn4QJ9X+TU88HguTRoXhFmz/HuwjT25aZHnN9VLgIz/4YZoxecrD/lpldq4CsK0WGLSMxKOHNil5oq8ejpgQwjh+xkIDv+IJYn0IxmbMsVovQssSQhan7/BX5oSkdl30GOPhRTBlcYdxqY6DJYxo+WFFlShDTHaYfc9gxRpzu7KeCnzSK
 2IigbUe0
 meYjJftKAISf6L1KyNZ6bkkIfHtZ5sI6iYGdeJ0SpsvO5PEACIxijhGVKwKmNBMoQpeF1N0WXExBeNhiXeriSgxOVphsvjBgyycqDdW3hDrKHDyV21Hl8Eineai8zVHhRLE9tBk+NyKfmTiSuM/hESStk54cpOWZzquzohtCMeDvPCRRIQln923lmCT6ituKGBNPd0EWfCuucSRKBI/lWGx//h12sXuUtII8f72yRTNvlyxYH41wb3pJX9yI+L/ZW0YNB0jRsEAuOpLT364d6BxJc3dHjccbuM1CrQqWXxQhfJNiLD4Jduwvn5OVuNRHw4sHjnMy/fHTpjMRaiglrqhMoeVKrv+HX426dGD9R/vXfAVSuSjTvGpuT9AdV2SxGd6oO4gEKaaYGRpVK4HcG8CnO1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce memory.swap.tiers.max, a flat-keyed file listing each
tier defined in /sys/kernel/mm/swap/tiers with its state, "max"
(allowed, the default) or "0" (disabled).  A tier is one bit in the
cgroup's tier mask, so writing "<tier> max" or "<tier> 0" sets or
clears that bit.

Since the current use case lacks amount control, it only supports
"max" (on) and "0" (off). Therefore, it does not track per-tier swap
usage, relying instead on a fast runtime bitmask check.

We maintain both `mask` and `effective_mask`. The `effective_mask` is
strictly bounded by the parent (e.g., if a parent is "0", the child's
effective state is "0" even if its `mask` is "max"). Maintaining this
separately avoids costly cgroup tree traversals to check ancestors at
runtime.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  20 +++++
 Documentation/mm/swap-tier.rst          |   9 +++
 include/linux/memcontrol.h              |   5 ++
 mm/memcontrol.c                         |  67 ++++++++++++++++
 mm/swap_state.c                         |   5 +-
 mm/swap_tier.c                          | 102 +++++++++++++++++++++++-
 mm/swap_tier.h                          |  57 +++++++++++--
 7 files changed, 255 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..4843ffcfd110 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1850,6 +1850,26 @@ The following nested keys are defined.
 	Swap usage hard limit.  If a cgroup's swap usage reaches this
 	limit, anonymous memory of the cgroup will not be swapped out.
 
+  memory.swap.tiers.max
+	A read-write flat-keyed file which exists on non-root
+	cgroups.  The default is "max" for every tier.
+
+	Limits the swap tiers this cgroup may swap to.  Tiers are
+	defined globally in /sys/kernel/mm/swap/tiers and listed here,
+	one per line. When read, the values are displayed in descending
+	order of the tiers (highest tier first)::
+
+	  <tier_1> max
+	  <tier_2> 0
+	  ...
+
+	Currently, only "max" and "0" are supported. "max" allows the
+	tier, "0" disables it.  Each write sets a single "<tier> max"
+	or "<tier> 0" pair.
+
+	A child may only narrow what its parent allows. A tier an
+	ancestor disabled stays disabled regardless of the value here.
+
   memory.swap.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
diff --git a/Documentation/mm/swap-tier.rst b/Documentation/mm/swap-tier.rst
index 0fb4a1153a67..addbc495de8c 100644
--- a/Documentation/mm/swap-tier.rst
+++ b/Documentation/mm/swap-tier.rst
@@ -15,6 +15,15 @@ speed to fully utilize this feature. While the current implementation is
 integrated with cgroups, the concept is designed to be extensible for other
 subsystems in the future.
 
+Use case
+---------
+
+Users can perform selective swapping by choosing a swap tier assigned according
+to speed within a cgroup.
+
+For more information on cgroup v2, please refer to
+``Documentation/admin-guide/cgroup-v2.rst``.
+
 Priority Range
 --------------
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..d53826c68562 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -283,6 +283,11 @@ struct mem_cgroup {
 	struct lru_gen_mm_list mm_list;
 #endif
 
+#ifdef CONFIG_SWAP
+	int tier_mask;
+	int tier_effective_mask;
+#endif
+
 #ifdef CONFIG_MEMCG_V1
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..63259576792a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "swap_tier.h"
 
 #include <linux/uaccess.h>
 
@@ -4244,6 +4245,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	swap_tiers_memcg_inherit_mask(memcg);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -5785,6 +5788,64 @@ static int swap_events_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int swap_tier_max_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	swap_tiers_mask_show(m, memcg);
+	return 0;
+}
+
+static ssize_t swap_tier_max_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	char *pos, *name, *val;
+	bool enable;
+	int mask;
+	int ret = 0;
+
+	pos = strstrip(buf);
+	name = strsep(&pos, " \t\n");
+	if (!name || !*name)
+		return -EINVAL;
+	if (pos)
+		pos = skip_spaces(pos);
+	val = strsep(&pos, " \t\n");
+	if (!val || !*val)
+		return -EINVAL;
+	if (pos && *skip_spaces(pos))
+		return -EINVAL;
+
+	if (!strcmp(val, "max"))
+		enable = true;
+	else if (!strcmp(val, "0"))
+		enable = false;
+	else
+		return -EINVAL;
+
+	spin_lock(&swap_tier_lock);
+	mask = swap_tiers_mask_lookup(name);
+	if (!mask) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * tier_mask is set per memcg here; the effective mask is clamped
+	 * to the parent's in swap_tiers_memcg_sync_mask().
+	 */
+	if (enable)
+		WRITE_ONCE(memcg->tier_mask, memcg->tier_mask | mask);
+	else
+		WRITE_ONCE(memcg->tier_mask, memcg->tier_mask & ~mask);
+
+	swap_tiers_memcg_sync_mask(memcg);
+out:
+	spin_unlock(&swap_tier_lock);
+	return ret ? ret : nbytes;
+}
+
 static struct cftype swap_files[] = {
 	{
 		.name = "swap.current",
@@ -5817,6 +5878,12 @@ static struct cftype swap_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
 		.seq_show = swap_events_show,
 	},
+	{
+		.name = "swap.tiers.max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = swap_tier_max_show,
+		.write = swap_tier_max_write,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 2f382d4dcbdc..712b225509cc 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -1021,6 +1021,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 	char *p, *token, *name, *tmp;
 	int ret = 0;
 	short prio;
+	int mask = 0;
 
 	tmp = kstrdup(buf, GFP_KERNEL);
 	if (!tmp)
@@ -1053,7 +1054,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 				goto restore;
 			break;
 		case '-':
-			ret = swap_tiers_remove(token + 1);
+			ret = swap_tiers_remove(token + 1, &mask);
 			if (ret)
 				goto restore;
 			break;
@@ -1063,7 +1064,7 @@ static ssize_t tiers_store(struct kobject *kobj,
 		}
 	}
 
-	if (!swap_tiers_update()) {
+	if (!swap_tiers_update(mask)) {
 		ret = -EINVAL;
 		goto restore;
 	}
diff --git a/mm/swap_tier.c b/mm/swap_tier.c
index 6b57cadb3e95..98bfee760b8d 100644
--- a/mm/swap_tier.c
+++ b/mm/swap_tier.c
@@ -253,7 +253,7 @@ int swap_tiers_add(const char *name, int prio)
 	return ret;
 }
 
-int swap_tiers_remove(const char *name)
+int swap_tiers_remove(const char *name, int *mask)
 {
 	int ret = 0;
 	struct swap_tier *tier;
@@ -276,6 +276,7 @@ int swap_tiers_remove(const char *name)
 		list_prev_entry(tier, list)->prio = DEF_SWAP_PRIO;
 
 	swap_tier_inactivate(tier);
+	*mask |= TIER_MASK(tier);
 
 	return ret;
 }
@@ -344,7 +345,24 @@ void swap_tiers_assign_dev(struct swap_info_struct *swp)
 	swp->tier_mask = TIER_DEFAULT_MASK;
 }
 
-bool swap_tiers_update(void)
+#ifdef CONFIG_MEMCG
+static void swap_tier_memcg_propagate(int mask)
+{
+	struct mem_cgroup *child;
+
+	for_each_mem_cgroup_tree(child, root_mem_cgroup) {
+		WRITE_ONCE(child->tier_mask, child->tier_mask | mask);
+		WRITE_ONCE(child->tier_effective_mask,
+			   child->tier_effective_mask | mask);
+	}
+}
+#else
+static void swap_tier_memcg_propagate(int mask)
+{
+}
+#endif
+
+bool swap_tiers_update(int mask)
 {
 	struct swap_tier *tier;
 	struct swap_info_struct *swp;
@@ -375,5 +393,85 @@ bool swap_tiers_update(void)
 		swap_tiers_assign_dev(swp);
 	}
 
+	/*
+	 * When a tier is removed, its index (bit position in the mask) becomes
+	 * free for reassignment to a future tier. If a memcg had previously
+	 * disabled this tier (cleared the bit in its swap.tiers.max file), the
+	 * effective mask would keep that bit clear -- meaning the new tier at
+	 * the same index would be silently unavailable, an invisible cgroup
+	 * constraint left behind by a tier that no longer exists.
+	 *
+	 * To prevent this, OR the removed tier's mask bit into every memcg's
+	 * tier_mask and tier_effective_mask. This resets the bit so the new
+	 * tier is accessible by default; users who want to restrict it must
+	 * explicitly disable it after the tier is re-created.
+	 */
+	if (mask)
+		swap_tier_memcg_propagate(mask);
+
 	return true;
 }
+
+#ifdef CONFIG_MEMCG
+void swap_tiers_mask_show(struct seq_file *m, struct mem_cgroup *memcg)
+{
+	struct swap_tier *tier;
+	int mask;
+
+	spin_lock(&swap_tier_lock);
+	mask = READ_ONCE(memcg->tier_mask);
+
+	for_each_active_tier(tier)
+		seq_printf(m, "%s %s\n", tier->name,
+			   (mask & TIER_MASK(tier)) ? "max" : "0");
+	spin_unlock(&swap_tier_lock);
+}
+
+int swap_tiers_mask_lookup(const char *name)
+{
+	struct swap_tier *tier;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	for_each_active_tier(tier) {
+		if (!strcmp(name, tier->name))
+			return TIER_MASK(tier);
+	}
+
+	return 0;
+}
+
+static void __swap_tier_memcg_inherit_mask(struct mem_cgroup *memcg,
+	struct mem_cgroup *parent)
+{
+	int parent_mask = parent
+		? READ_ONCE(parent->tier_effective_mask)
+		: TIER_ALL_MASK;
+
+	WRITE_ONCE(memcg->tier_effective_mask,
+		   parent_mask & READ_ONCE(memcg->tier_mask));
+}
+
+/* Computes the initial effective mask from the parent's effective mask. */
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg)
+{
+	spin_lock(&swap_tier_lock);
+	memcg->tier_mask = TIER_ALL_MASK;
+	__swap_tier_memcg_inherit_mask(memcg, parent_mem_cgroup(memcg));
+	spin_unlock(&swap_tier_lock);
+}
+
+/*
+ * Called when a memcg's tier_mask is modified. Walks the subtree
+ * and recomputes each descendant's effective mask against its parent.
+ */
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *child;
+
+	lockdep_assert_held(&swap_tier_lock);
+
+	for_each_mem_cgroup_tree(child, memcg)
+		__swap_tier_memcg_inherit_mask(child, parent_mem_cgroup(child));
+}
+#endif
diff --git a/mm/swap_tier.h b/mm/swap_tier.h
index 3e355f857363..e2f0cf32035b 100644
--- a/mm/swap_tier.h
+++ b/mm/swap_tier.h
@@ -10,22 +10,67 @@ struct swap_info_struct;
 
 extern spinlock_t swap_tier_lock;
 
-#define TIER_ALL_MASK		(~0)
-#define TIER_DEFAULT_IDX	(31)
-#define TIER_DEFAULT_MASK	(1U << TIER_DEFAULT_IDX)
-
 /* Initialization and application */
 void swap_tiers_init(void);
 ssize_t swap_tiers_sysfs_show(char *buf);
 
 int swap_tiers_add(const char *name, int prio);
-int swap_tiers_remove(const char *name);
+int swap_tiers_remove(const char *name, int *mask);
 
 void swap_tiers_snapshot(void);
 void swap_tiers_snapshot_restore(void);
-bool swap_tiers_update(void);
+bool swap_tiers_update(int mask);
 
 /* Tier assignment */
 void swap_tiers_assign_dev(struct swap_info_struct *swp);
 
+#define TIER_ALL_MASK		(~0)
+#define TIER_DEFAULT_IDX	(31)
+#define TIER_DEFAULT_MASK	(1U << TIER_DEFAULT_IDX)
+
+#if defined(CONFIG_SWAP) && defined(CONFIG_MEMCG)
+/* Memcg related functions */
+void swap_tiers_mask_show(struct seq_file *m, struct mem_cgroup *memcg);
+void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg);
+void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg);
+int swap_tiers_mask_lookup(const char *name);
+static inline int folio_tier_effective_mask(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	int mask = TIER_ALL_MASK;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (memcg)
+		mask = READ_ONCE(memcg->tier_effective_mask);
+	rcu_read_unlock();
+
+	return mask;
+}
+#else
+static inline void swap_tiers_mask_show(struct seq_file *m,
+	struct mem_cgroup *memcg) {}
+static inline void swap_tiers_memcg_inherit_mask(struct mem_cgroup *memcg) {}
+static inline void swap_tiers_memcg_sync_mask(struct mem_cgroup *memcg) {}
+static inline int swap_tiers_mask_lookup(const char *name)
+{
+	return 0;
+}
+static inline int folio_tier_effective_mask(struct folio *folio)
+{
+	return TIER_ALL_MASK;
+}
+#endif
+
+/**
+ * swap_tiers_mask_test - Check if the tier mask is valid
+ * @tier_mask: The tier mask to check
+ * @mask: The mask to compare against
+ *
+ * Return: true if condition matches, false otherwise
+ */
+static inline bool swap_tiers_mask_test(int tier_mask, int mask)
+{
+	return tier_mask & mask;
+}
 #endif /* _SWAP_TIER_H */
-- 
2.48.1


