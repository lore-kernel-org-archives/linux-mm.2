Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F50DC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E02D6B009D; Sat, 29 Aug 2026 03:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8905A6B009E; Sat, 29 Aug 2026 03:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A75B6B009F; Sat, 29 Aug 2026 03:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEA66B009D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB42DA065C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:28 +0000 (UTC)
X-FDA: 85153526976.07.B7E4FB6
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2AAF41C0006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OwdA+R7B;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajNLhdeOa3qTi7x0+Rqx535kN8WB+xlcS2id0wkaitw=;
	b=PNLRso8hauDh/y6dvwGBsenvanurcZ8XV0F2r5om2SJGDRBcjfopAIlk60U/QRwe/wu3td
	fbXthOZJf9tgNfoctLTdHVWCY+nDeVkg0f1wSA7SQZAg8JzlHUNvbJYp06yGjUeIwbbTRu
	4Rk5P05r1GuD5GMZGPUj2xe44vVFnLs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OwdA+R7B;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989647;
	b=HodY+bGr7xgRlyipTAglzNhTQvrvJMCuFFi749AsclPzlEB+N9i+LdJxkw/c6WBA30k+mD
	oZ8lM0kWIkPXdE8Zx8xtEhP/VVNpp1yGYlKedNnXF+ogKf6Le1NZrPipp6k0UsKq1oahIQ
	w/WgLkZbOtlR5OgYaBz4Z/3BgPk5WAY=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so620664a91.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989646; x=1788594446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ajNLhdeOa3qTi7x0+Rqx535kN8WB+xlcS2id0wkaitw=;
        b=OwdA+R7Bd00TxdELde0rGIKn6pC86VQpwKhWWrDe1R/MWqpvqbPEaBpDSAYl43dnQn
         af9zu9G4hk6WAj+m6HmQWci73NKYdx3KQ+0QpcY7W0wp1GFe16EFq4t+dlsEoGnnU4Z1
         fm/cYjM6/8Jq0ae9tDpfa26T0HmrlKWUx0qnwe+5vkilbSGtTCcoygM5+eSO1apnKK5/
         Qnt00asrcVwOUWpGIVkcAYISxQlXNmtzyrH/W7FuoHc98j5Npe5WL4BMYs7jenKepHaZ
         LPIbZsGH/4Qi+f+rL2HbAozL17DI9QafiSL3kgJ6TgzzZP+FNGSj/0UzG0eCwY850TkO
         LXvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989646; x=1788594446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ajNLhdeOa3qTi7x0+Rqx535kN8WB+xlcS2id0wkaitw=;
        b=XzG0K06PSt8BGtasA1a4wF6HFCGOP/BCPkT+wemyPlTERCTzusue5FG+MNDECQYlha
         GyWg//XLmfL7c0vSmhZE+LNxQjtaTYsUHZTKt5Pj0RPXwKMYN/lgtnmcdInIWCZQX5gm
         uunSlfYaF7mxy/MNzXGM8sxvOB2DIiHa4zSf5C0GmDrgGstJU51fgFHK2DpT6N6lrNkh
         J9vj2W8tX2iy8EXT2mwSU9vzkDUEyXbS1VFxONY8/eqM6OPGTKrqkY4sULKzNByG9pVq
         DmanP/rOs4Iq6Oe39g6eJt8YABrQAFV5RE6uvSPe+cHfzR+dXh6rQeQoBA5w/Rj+sBx4
         aHJQ==
X-Gm-Message-State: AFuF++k05CZz609Nl0sWAKgBWn3E76xdxJAMerBkmPfn3p7PnLI87CGS
	lnpByatjz4Y0J9DYA2029isKyBA252h06a4ifS4K+RXypILz7utJcq0tLoVIYQ==
X-Gm-Gg: AYBFou2EMj5vKOk1jjjmjBgd1XW0VxXGc4ZSpD6+iVQZiOI9DI4gjeMT7YV43PsBk3M
	N0N9hUSDodzUawmsXQMmdY46tlE0j6qwKnDgDXUVDzsyIgk1QVlfD6I8lDHE/mylpxNFJYsZZIJ
	iVQ57bKf/VWM+gg55fS6teTWX99DcuRfYheY+ET5vSyjjuYxez+5cPqJttY4QbbdnY7hYGY/gzL
	jowu0G7Gt0nCX4yInpkYic4bHLMpQBFNGQVimFbgHU5tVLbEmUHp/Bi7X7KoxB/iXiSht8hhfZm
	TOMtWzqzIKVTvwi+hD8+DjZWUiWH7khY9obP86npeVDP+EOHSWEcPMXzc5/gEzMAURCnusdz5RD
	VG3NsyS4aFk1F6FPn4cIJ3HTdnaRA+m7o7F4ZzEtyTglvDT/2uKCT62slc5Gz+Q8/kyHRzWvH11
	AJUFBeM1Ul0Mo63KzuZOhuehs8v3NGYQBRlaunonZUPsxNtbbt5AO31o6sIyk+7YenyzUeiS+LQ
	lyPGb/OXy93LwBcbHpku6DbOphb
X-Received: by 2002:a17:90b:1806:b0:398:9be8:ea68 with SMTP id 98e67ed59e1d1-3989be8eaafmr5958988a91.21.1787989646053;
        Sat, 29 Aug 2026 00:47:26 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a14768dcsm853443a91.4.2026.08.29.00.47.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:47:25 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
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
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 04/13] mm/swap: introduce swap device iteration helper
Date: Sat, 29 Aug 2026 15:47:17 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-4-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d7nrubp3goie91mgdiu6kkkab84sxw8d
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2AAF41C0006
X-Rspam-User: 
X-HE-Tag: 1787989647-449246
X-HE-Meta: U2FsdGVkX1+DC6YLTc2H0bjLiPhg7G0IK1eWNV9dzZ4WRGz9oqaGBiOk/wQHOPiOXnmpxW9bSBoi5+JCbICGwridbC6ENy4/rpWhPTOsd6vMF7KzF4hRH9M3sb4BXt6qhNg2m6qTDq1nSHyCcm06YW35VCzwsDwtcZRu5mS3AShWdtIotJIB0oaMy6/ASBvPZBaKQpCRWqkbNICRBT8agvsN/2vX9z4qCuzm4aZG+N2XKiu/+RoaSYrFy7g+3r3sOrBdQEyODZx1M3yfEVnNf8fwkYp2I1gZrHbtqa09tR3QDenMpGuE5OFtykPrjveb08KjraqgJa/GXZwGER/vn8LXCVTQmMG/MBt0GKMmGJT+CNAdaYpg0/SMuP1TzKSxsHl/v6Gdcff1EZRdwskYUjnElD3d0TOYvhcee8Rmx2f9PXAF/ngF5hThI7C8YHjEmXj7GFNuWZKYi5cXUXRA+/vf0tXXAl9ozN1gvyGepeXZuhd/9uX60jxqMFfMLZqO517D7fWKEMIKBm3DK4xyOLX1r57wquiQNtxjvELmbo/s35ukObvSupjGB4bO7WXObYzGO+0mzddAIJpPMzmunE4oKGLcqQuQ0j2dapTGsl7fF1Pl1gKe4wxdLQsjvwHiEZsSMJKTTFyqML6Cb73mFZJmRZwev2XP+TDdmmWEkYmK+Uacfb6jA2fQCuD7EJbIquLeb6I8RIsWH6/BhG5Whi5YIePJ+cIqQi5T8TDUbv2Go1wf6Mu/B28uZKYHJj1a8PorY6AVBBSp/diuIgtAORdtFP1vHql1F1bwP+HGHc/R8AVqOPfo06ugysSrAaFIQgZl5VFFUTSW+jhVQW1v18T2K2VVxpOvuofqv7VFfWWeHOecJhTSHLY0obwdx70eigaDYoholNeeOMiwNbMl8dHI2aZJ/cyId0smzglBJaG+2tgoU9nxL8wATaAVTwapTOc/uAE2YcCXs03GzXX
 E/VTxwyU
 Dsu6/JtQzoB80AvvE2rkOFowduiVtVgAyiF1/FzklOUgKlqfP5vDM3d8C+ke+yjkOiHjfR09wsDRBb++PmHi3xmeOop75JymTxPPT8thZouGZriBvq3rK73Moxt7nEWJRTbXHiKYnG16FBCs5ppdJrQ8y7lyU9DFLFmh+OZ1IEs2hj4cGlYfDufwe2XB07vCYGtDcykdxDSDBuZ6D7cwNvenljlUdRo543j9GjtFeFHjfgfplnbaCDLNRdkI7JuWPPbW0pqppBaUQuy/Ze1oJASBYFyRT/sB+AcEmHAIjT++VGSw9dmSEaNcSJXgUMYc0KiXnmd7pe/Cl3J+/AC6sBT4AJPAWO7W/voM1MphQ5A/XihHrPPW3NMhiTDzSPU8GFFM5SZ1PkyayjjqRYrVVfk2TkGwnOtdjWZy+VmUJ7XfDFZUB3g50MtLBwk+OHCUrNw9wJ6x2haPQRpBpsuleTizWRHPtzUU41NOG
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
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 mm/swap.h     | 12 ++++----
 mm/swapfile.c | 77 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 90a551a88df6..403574a7fa8b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -107,16 +107,16 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
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
index d7115b9195a6..3847717f4d1d 100644
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
@@ -2210,26 +2238,18 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
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
 
@@ -2335,16 +2355,13 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
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
@@ -2830,12 +2847,14 @@ static int try_to_unuse(unsigned int type)
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
@@ -3827,14 +3846,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
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


