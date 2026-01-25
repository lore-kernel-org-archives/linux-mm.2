Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB76E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A866B0095; Sun, 25 Jan 2026 12:58:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC016B0096; Sun, 25 Jan 2026 12:58:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB36F6B0098; Sun, 25 Jan 2026 12:58:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDA146B0095
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:58:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D52CD3573
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:36 +0000 (UTC)
X-FDA: 84371246232.04.1F2B4FB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 803B71C0003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzzKFGml;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FByi9ivqPJyIjI850sU//sSIfdwjIzLDbOJYWWeWKFE=;
	b=YrRKhA59RGYOtSDzEFdJKrPMqc2RK3LGP8n8QieXRLTXeXOWPYVDJZTGjWCENCrxjJYSQ7
	lBkADMcy+i+1dphii00NmtllNfepz5rZ0Ss9AywpqP2RaIh24uwKgGlyTUBU4/i3zaoaJi
	HfZ9t6o/tdxWjhgn+jl3Xs+7Pv+qH1o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzzKFGml;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363914; a=rsa-sha256;
	cv=none;
	b=MDLMnZcnAchtquE5EiW2yJiEvp+s0VauvB9hPwzm9CArvzew/uJu/3go0f0e01X6dfs0D5
	I1B9Egpu1o5h2VKpDwNbER1a8y1S7DAI40gE4NYdhTeT+ga51LygTPMoHPgeVhFgS0qX/7
	8llfonS5PsJ1RfseVLKGdCwCd7YnTEc=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82318b640beso1214560b3a.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363913; x=1769968713; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FByi9ivqPJyIjI850sU//sSIfdwjIzLDbOJYWWeWKFE=;
        b=CzzKFGmlpaKm0qrKBmPrjQQQEC12dqvE9decR0vf8cgAGDovDiNopdYPJxQkvn20ZY
         ScKCYgl60jNifCzKjoWvJJNeBAF6iKFx/Xuh6ytDKsJy2F8Ekob0jyJU95dAR1YdzBcx
         6pcHezQcHqKKMbVSnlcc+PgyW/OYIXApJ4N20b10ODkedr9yFLateqAe04KP1raZdN9g
         c6tYXW8eW+AxDAiLik0VW3Y7JbwtNVMHuYdopCA+v9oS9Y2Vfsb8+zSQG4Ocv7ma2vV/
         2UJkLZbvLJPgSsNmfwcfOrt0Ax+VkGOKKq9s+2+KJuXImwt1jprhseQIZLaavn6TMnlK
         LYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363913; x=1769968713;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FByi9ivqPJyIjI850sU//sSIfdwjIzLDbOJYWWeWKFE=;
        b=NlYhbByzePaW4WISVJ+tg4egb3MzTbj0C2IaL9PYkm51EXQriJiVrb3YbNneNHID86
         e0nIh0FBGwpAAvsx7dhvBO0DV/gjulh5GG7QWwR9Dx/7YxJ2a0mBgvPVdgf+k5phz1JP
         VqstURbFITm+mzl4e/HsP5vzMz3P34muLEPgBT1sJl5JEDcBUJmpMpGhtHb72bjMe0lr
         4cQjE8vOpJzuo90QsMs5l2MOcU87CtHdcoWGROZATlcrRrqLu/VZN0+3sxjaEE4HOOVG
         pShSZXsx2WKgJCza534i8GSpUdpJkyuF8MjWS/uTaQd4jP1UZkefEgRVzrwwhxNilJLt
         pKIw==
X-Gm-Message-State: AOJu0Ywz8Uyq2Sctn4K4O30BehN8GGiJRlp7jlqkavnFndrVS0Dfylmi
	/wby4URMNex1SohOmjnUORYP2CBgHCw+ydF1n6B9eyt0apanAmr67vjt
X-Gm-Gg: AZuq6aJPxKirarjkq0VCLUIKxNKz4UXLqtQpTJBfSrrNKJ1mZj5QW+eUkn9V3pZqnID
	GGENpJ6pC3ng+zPds9Le6hesRngiP3tVEQMfJqOZ+5FJXnAbOJ5HRbX2iKRlrsjrOr+EI7gXjY/
	Nk8yYYH7PML8TkbqgETwQ/ogtCl/UopgHIu8PtJeNRI/Pa50rRICVd9GPo2dglz6cn3h5807Djn
	lIelAK4r04ZgOKFstdrwr+efZJRTfJDWjTb9VTff8qW3Tf7mwRbZlVbKjX2qHBiMNV/Zxjs30KF
	zyvyx0g0RNwyKsiQd2QOkc3TFFB0F//8ERfCYm4JnWnnPBb57X971r/3GwSdwV+QlNgHUluzhzv
	OoHUmr5ogKvE2lP/pzK49GJEa+ttC/WTThB+g9Z8VVCFq3/DY8Q5t4zotQ9gNqgf2duIBaDsWHn
	kHSmiA39y0lrq/jBLklAKj0DqTEMxgK0waZqO4B3vDoOB5YXxa
X-Received: by 2002:a05:6a00:4143:b0:81f:4e60:1c67 with SMTP id d2e1a72fcca58-823412d954dmr1785767b3a.67.1769363913484;
        Sun, 25 Jan 2026 09:58:33 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:32 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:30 +0800
Subject: [PATCH 07/12] mm, swap: mark bad slots in swap table directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-7-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=4470;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8m9COjsQHMkFcnP8SRLKraCOnV7wwqbxj9agW6bIMxQ=;
 b=SpWzpfa4WqhuNM3Pe4jfaTwdbufTKN2DF7Uh2F/b+DvUK0vdZtXufwCirOKUf4gLbdtTA582W
 nhqSZ5cuQ0KCPQShNbDFuSBFTHpqPcHDcRoLKJH+OQU4wOUZsjuiCEd
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Stat-Signature: z7f4q7u17strm7txz64otrxh4zmy9nyz
X-Rspamd-Queue-Id: 803B71C0003
X-Rspam-User: 
X-HE-Tag: 1769363914-307122
X-HE-Meta: U2FsdGVkX19da30w/cwtsIiCvWmNK1mAAyN0MzkozaIZrQ8tu0A1wyJ8u3Fp6jIlC/+OeX7OYwhupCUD4QUaYC6q7ggidN+kVz72gWrfEvHahnMFyR9VL8sDUkdwqfP37atVdjwd5i5xXry6Bree+DKGlGtYe4+8ol2Gm/aOarFfCNqZLvoHmGZROhbmQso/sOmIbYeCg5Lq9DnRZSubPHyNoQzhiTBEEyMcoswl5EiEhukcPXdJ/gE4qJw66uwWV2t6oDDXFFkJDjIOL/zSR2Pz6/jHiYrC1RUCV9Bxzx+EcKsCg7hV9qVp1k25nsi1LDTTw6fTruQiQT/A6T7nHygEE1+9XaAjlx3CNOm12I+b1u1oK7bM3lLauHLg3Pw1qoowoZ0MHaKQruxzz/KQknPGejyXeNXA8CYWc+q/I+1nQBEHPCd/KcPgWLl5gYbg49+53UpK81LQBMp2dWiiI4BblZXSCkDUYGVwM0Qt0IdO+kRfuiSePYNavzEx0UWEZGL2oHA93Q95Xy/appDsi0KtMy+91foWZ+npSiTiRxacscPkzrRX3f4C85Q4SVbfMYqVZ/Wa4UomgvvRSX17weS6cB/nuMZl67XgaAXLGTnRzEb1dI1tZnDWUpOWnrQI8i61BMfkjSktZPD0wHc7bTt0opk7ZFi0Ts9nN0N+45SGfYk0fyKmiGmWBQQCxaSGBG7eRFvdmf0y0PE6AeblKLBaX5kpLDIDu97eIh3wZFn9g1wJ0YsnBlFf5BMIMsCe4/QUarH8NOjJwRPDU6CmS0e+GE/HpyfBpqC2/7y4wphCDLwCIm8QeiIRM9MLQmLIdu6ZprlO/6m2u0O2qd9Hewde4chjeEUHSuHwktnB2B4IoD1raXF5o8ggSbGGKDqP8DVbazfR7eRyi1j9cYMkU+IIveT8LenL0oK7VPXaHetmMpXv/KWoSaTOHDjDomsULaNYXsADuUFvhMtnVzv
 u6FDBWj0
 5FZG9oKSy/21hmG2+IMI5S498YS4SjCNnSY54e4nUAGrKzpuXCfUvowbTtwBbE6ZsvkjG/nCdBxeN1T7LXTHhB9T3/FKQ7WRPbj3BnFGMCfrOujSqSXAd8v0+5GG6Tenp3YTU9NioGvEh7YgysghxSZISqZwsoBug7qdFwYtE4tI7KOKUzNFgSPN6PlEUykd0X8sfF2/HV4hzrfk+iwLvl7oOWkHHpnfOZQMiHOc6ysiffmQo4SMK0VhQ/I3PBsffG5tZ1udUhofdlPTsYvVfdXJtkBrPFlQZ2viinPyZte75MwrtP/roiXJ81g3p4hbcHVQNBhB2y57ccysZpiTec5A3AnWBBzI4KYeVsMVhMvlnot90iYv/XLKh/aGqRAeq7HfMUOL6ht+o2zPKN6F7+Vv4AZQvgwjpNNi7dzLJuI/yIwBsyMrqwsDdUQNohNwlsEGRw1tkaLVc3hz0rpvgD4KeWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparing the deprecating swap_map, mark bad slots in the swap table
too when setting SWAP_MAP_BAD in swap_map. Also, refine the swap table
sanity check on freeing to adapt to the bad slots change. For swapoff,
the bad slots count must match the cluster usage count, as nothing
should touch them, and they contribute to the cluster usage count on
swapon. For ordinary swap table freeing, the swap table of clusters with
bad slots should never be freed since the cluster usage count never
reaches zero.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 56 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index df8b13eecab1..bdce2abd9135 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -454,16 +454,37 @@ static void swap_table_free(struct swap_table *table)
 		 swap_table_free_folio_rcu_cb);
 }
 
+/*
+ * Sanity check to ensure nothing leaked, and the specified range is empty.
+ * One special case is that bad slots can't be freed, so check the number of
+ * bad slots for swapoff, and non-swapoff path must never free bad slots.
+ */
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+{
+	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned long swp_tb;
+	int bad_slots = 0;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !swapoff)
+		return;
+
+	do {
+		swp_tb = __swap_table_get(ci, ci_off);
+		if (swp_tb_is_bad(swp_tb))
+			bad_slots++;
+		else
+			WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
+	} while (++ci_off < ci_end);
+
+	WARN_ON_ONCE(bad_slots != (swapoff ? ci->count : 0));
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
-	unsigned int ci_off;
 	struct swap_table *table;
 
 	/* Only empty cluster's table is allow to be freed  */
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
-		VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_off)));
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
@@ -567,6 +588,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
+	swap_cluster_assert_empty(ci, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -747,9 +769,11 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 				       struct swap_cluster_info *cluster_info,
 				       unsigned int offset, bool mask)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
-	struct swap_table *table;
 	struct swap_cluster_info *ci;
+	struct swap_table *table;
+	int ret = 0;
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
@@ -767,13 +791,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 		pr_warn("Empty swap-file\n");
 		return -EINVAL;
 	}
-	/* Check for duplicated bad swap slots. */
-	if (si->swap_map[offset]) {
-		pr_warn("Duplicated bad slot offset %d\n", offset);
-		return -EINVAL;
-	}
 
-	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -781,13 +799,21 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
 	}
-
-	ci->count++;
+	spin_lock(&ci->lock);
+	/* Check for duplicated bad swap slots. */
+	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		ret = -EINVAL;
+	} else {
+		si->swap_map[offset] = SWAP_MAP_BAD;
+		ci->count++;
+	}
+	spin_unlock(&ci->lock);
 
 	WARN_ON(ci->count > SWAPFILE_CLUSTER);
 	WARN_ON(ci->flags);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2743,7 +2769,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			ci->count = 0;
+			swap_cluster_assert_empty(ci, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);

-- 
2.52.0


