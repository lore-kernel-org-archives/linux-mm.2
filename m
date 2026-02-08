Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FFEFEF06F8
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728736B00A6; Sun,  8 Feb 2026 16:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BF16B00A7; Sun,  8 Feb 2026 16:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F6D6B00A8; Sun,  8 Feb 2026 16:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 201006B00A6
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3C81160640
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:17 +0000 (UTC)
X-FDA: 84422655954.11.EE81BE1
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BEFBA000B
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWNj6KsJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587956; a=rsa-sha256;
	cv=none;
	b=Kb9sIUjPJmJWuyc4yguHpnBuMr5jTzV/1Wg3PDRJu/hKhD3/9RvswTmps353AmUzJncw8m
	S4wPEu2lliPhbKWZBP6QUFxpZsdq+7TJ9XaZGsuWnPnyL4YUXp3Fry/5JWIQJLITPdxLB5
	04YD9LWIKJiDAZ95t7Ewv8VgYEuDnec=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eWNj6KsJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jcq3gcBJps8FZtjddhB+nxOnBeH87BfFsdWVB5x664k=;
	b=50deRxt0lzvQ051u84BI7qw8tjnHOPMXoIbWZ4dI4l5x26SpVG+G7F4Nmuomy4wm4g3Luj
	sMmH/pckUzgZYQ7nSYltA1JYqdz06BE7HrP7JotrbnEL2Iui/vJ/sgmTTII6bh3zqIjPWr
	4PS4/2zLS3FnZT1Zp6iVCKubaCLluGM=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-45f171cb842so2677482b6e.1
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587955; x=1771192755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jcq3gcBJps8FZtjddhB+nxOnBeH87BfFsdWVB5x664k=;
        b=eWNj6KsJd9ZbibK+kEMZ8zNs40oUhu9xj0Ob57FdAzr8iUaTmN9C04fmfTXAAtWcWO
         NSCwhXsLsLfZRnKq9wM1wrH3QbbxMhN3Sxpr/NafAYFeIuaXAE3IL2suYkhhXHROhY5D
         TFpFdUqJQxzOKWsx03NMGgc2S2okfQ0qDRXTwI24LtSQVDzcK74qsVek+WmJkeG3mXWt
         cscYG2d3/8XGyBMVvrUOaAp42YizLKCWdy2+ApelfWrN94VIC750xBaulT2PjslfXmAA
         V8GC0vGBbCZwlLGmhrjY28M5xSG3YTHN5F7QyiDz3yyLACSYX8sX9YHWwIZ3zuqwiJIt
         Mvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587955; x=1771192755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jcq3gcBJps8FZtjddhB+nxOnBeH87BfFsdWVB5x664k=;
        b=Bv4KPA/yfYYXzmPjbsgNnvkycupo0KzyLJmHfyONFGIxwJdj5ef/xYkzy/Cw4G56yQ
         Mb9EqfRpHO0QGMEQDsNnx8ub/loqa0PO8LdZzyRIKZLGpDcejrX8idsEJJAN1cOCzdBT
         FDmsjt6dMbJfp9xAsWqDNfuTd1+5Wh2L6N2e4uRUejcySwwhnZXDrsfCgrf3za3Bwgc/
         EbyP0dc67htJ+CvXjOqkCi0CuHMJbocSJWAIXrG7DansYgQns0PbwKLTfoFWHjzIkhjA
         z9VKiABGNziciwJBCjBr4qoL74+pQXKF56njlIsvrl/PTg0UTpVZx+oDpbG7EOYJNh3E
         v+Yw==
X-Gm-Message-State: AOJu0Yy05zKpKStnIYXSzGlPFraeveATuLMPhE+B0S1RJ1ny0lLwrG6O
	KHaZZtjH3Ea4n/7d7mX5NWW4HPsUlirHwm7TkJbnLxoVDUf0TnXAx/AgG3ZbtmNniUekIQ==
X-Gm-Gg: AZuq6aJmKyttTnlzlTzxqzoyRadK3NUeEU87zvfxTD3m/sckf51euSKSdNnothQWbYY
	rj4Q+J3/olKB1Nc3zTRAK3J+oo8U28i1XxgB8Ku90Gjcj4MUv6eCQfqJD9eaWX1sUN6DxyeuVqd
	Q7cukRs/6nNnzhmtQvj7NaErrkm8QxVYdZKwcLklcIgJftqWT/0Hmb60zOnW42iWABClL/2j901
	HZOjWRzGzmATZzxe/1uooV6x6lU9t/H5k2Oj8PxCMzw6JXD03JkYLRTdtcEK/Wno/BKo0vSANyo
	HoRArpzCkbKsC3/IfzbEqH+rCcNtO/6Sl0awJGLxSt3zUxQrlSZMZK7RSjdUkjhSY2bL7aL1Zoj
	5ZS5w5b6282xnRKNm+2bPgbH5j7RNwi9ZaYaAW9K+XvaZzbyOWPTHF0yZrP/h74coUEhJPv6hFs
	gXnNSXTo8KanB2ihJy59avSDBQSbKBYzQ5
X-Received: by 2002:a05:6808:2220:b0:45f:103c:2483 with SMTP id 5614622812f47-462fcbe429bmr4183659b6e.23.1770587955253;
        Sun, 08 Feb 2026 13:59:15 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462fe9a12f5sm5510710b6e.5.2026.02.08.13.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:14 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 16/20] swap: do not unnecesarily pin readahead swap entries
Date: Sun,  8 Feb 2026 13:58:29 -0800
Message-ID: <20260208215839.87595-17-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4BEFBA000B
X-Stat-Signature: 9jnhgbh9djqbkjzmohc1h3gyn8yfykxu
X-HE-Tag: 1770587956-205766
X-HE-Meta: U2FsdGVkX1/VW/azTjFZEazLVgsoW3visKugyGd8LwZQ02eABnCN82xbVfnWz9gdkUJAwS/0wpZQB3BrtVxh9dzNqYeMA6qtYH+lQpHtp+3ObHFIiG+c4BPyXPlVitSohRa4xQ8hdKlPVvyCxNXtt82B5kf3EFKfEvxvTjNrYLclcgOM718x/XTrZx4zqi9S8kS05tQkVKklJVKSf5FOJWANAB+/zbPts9lUuV5rheKR/wY0NHhD7docRBu9ZH/coWWEgOKj/E/q2UKisTUzjkqGGXDUQvyWWvUy0k5pOZ3GuJqneqcUPDeaWirzwrDgTYBKyPDxMMre6Kk8gXvA3KHPS3+0sdSvAePpflNuhJ0p33QE/cu6UAatlEY25VVsZMeXxKuyFUI8ngskSLo0JVkMKjJY8vx9QZwjPtwiheGqQSP7X/vujBnUcIvK4PbraPcQ7Hx4xWofmB7t3J2Vh0yUnc0YXG2ZGt9Z4k7mDg8KB7xd5SkXnjKm+Jo/IVVAI2r5seskAxzkbYq7NScUtIjJ9Q5Ujcn7Kp8FaE1NbVswN/YzdGS4AwrgUb03Ac2UJJ1C09kJYFPloCmiwIe0C/vNT5rs7r6SEzcTatL6hBH29EWAiD03h0Ogwxh3hbaJFW6FfZ62qD8EKHN0f9fLfFq9XBoU9mtJh7KFLclFGDlySfpPqodDCqb3RcxTUsVtPtS6l6lsjjL7JoCpXSvHHK83Vo7sKmlKiJ1Sh5J+BvWc1af4GMgyp5WVlih1d7GrJgs2w8RGKLmJkdaQm4pHy1OqXccrEWUOnFaHmLtuAbLEc/Nb1+/ZNYMfcuy4p5wO1MIC3Xku+ZVPYDyNuJrn7/Pk7Cc69XAybzecwDnx22+vkDq5EIENqvBVRIAr15UVGd/u2J3eU2s/n3cj5AadJQ6nuVp4cmlWtstwYgolumdLcjfmzGjLEaBy4iiqVCziBvug+dcdqxuKEuuYLhQ
 UUdbPQPN
 J2/iGwV3QGzEOsn0yQJhZ8flXkdtx1V8TtQaXp6pwM8yuPSp2hDEG6elhAZ8eQcWzhEwizSZmhT1cdlWQCH5jhCMfSejUMgIpZoLbK3xwfcQoincwuH4PEdbQm5QulRDOWiyLpJKZJQf7fbQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we perform swap readahead, the target entry is already pinned by
the caller. No need to pin swap entries in the readahead window that
belongs in the same virtual swap cluster as the target swap entry.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap.h       |  1 +
 mm/swap_state.c | 22 +++++++++-------------
 mm/vswap.c      | 10 ++++++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d41e6a0e70753..08a6369a6dfad 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -213,6 +213,7 @@ void swap_cache_lock(swp_entry_t entry);
 void swap_cache_unlock(swp_entry_t entry);
 void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 			   unsigned long vswap, int nr);
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ad80bf098b63f..e8e0905c7723f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -553,22 +553,18 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		pte_unmap(pte);
 		pte = NULL;
 		/*
-		 * Readahead entry may come from a device that we are not
-		 * holding a reference to, try to grab a reference, or skip.
-		 *
-		 * XXX: for now, always try to pin the swap entries in the
-		 * readahead window to avoid the annoying conversion to physical
-		 * swap slots. Once we move all swap metadata to virtual swap
-		 * layer, we can simply compare the clusters of the target
-		 * swap entry and the current swap entry, and pin the latter
-		 * swap entry's cluster if it differ from the former's.
+		 * The target entry is already pinned - if the readahead entry
+		 * belongs to the same cluster, it's already protected.
 		 */
-		swapoff_locked = tryget_swap_entry(entry, &si);
-		if (!swapoff_locked)
-			continue;
+		if (!vswap_same_cluster(entry, targ_entry)) {
+			swapoff_locked = tryget_swap_entry(entry, &si);
+			if (!swapoff_locked)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
-		put_swap_entry(entry, si);
+		if (swapoff_locked)
+			put_swap_entry(entry, si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
diff --git a/mm/vswap.c b/mm/vswap.c
index fb6179ce3ace7..7563107eb8eee 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -1503,6 +1503,16 @@ void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si)
 	rcu_read_unlock();
 }
 
+/*
+ * Check if two virtual swap entries belong to the same vswap cluster.
+ * Useful for optimizing readahead when entries in the same cluster
+ * share protection from a pinned target entry.
+ */
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2)
+{
+	return VSWAP_CLUSTER_IDX(entry1) == VSWAP_CLUSTER_IDX(entry2);
+}
+
 static int vswap_cpu_dead(unsigned int cpu)
 {
 	struct percpu_vswap_cluster *percpu_cluster;
-- 
2.47.3


