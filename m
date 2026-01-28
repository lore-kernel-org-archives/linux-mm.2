Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E6CD35690
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5631F6B0099; Wed, 28 Jan 2026 04:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D6D6B009B; Wed, 28 Jan 2026 04:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B446B009D; Wed, 28 Jan 2026 04:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED196B0099
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:31:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E94AF1A0544
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:03 +0000 (UTC)
X-FDA: 84380853606.23.57CD5E1
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id E475B4000D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KgsMIo43;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBjV8XyXDLoEReDqKUKA22e4GI0fZeu23FHRrREbJdM=;
	b=5Y1LjOattK0BfEn85nIQ5hKt/oIVAymWIJoPe5mrX8zZ/OZ1B685Vn/YMuo1bj0LubB/Mf
	qpF0kpB4oAmoi4KDduc81j7rd2i+XScFCECMiBUzs3vpBh104M/nQS6A4XMpFsfunCbwu1
	IAd0pEVdmMSVTqjFjUW9dblKIWSwJo4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592662; a=rsa-sha256;
	cv=none;
	b=2XOQdT8axN1kcokzl4ZCuEvtww7aAv+rsLWraWPr0/S4mS3IPkyqjO2cnNXQtt7k6wYBVe
	nhdhKc+umZY2B3oq7fYPeQuWWDNJIMQl5N8hsxH1QV9KB4XcRZAZS8rkwyA5yXM6H4EKTl
	1yLNnBdnt69u+l5khFzeRBNtvY1bYXY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KgsMIo43;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0c09bb78cso6206475ad.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592661; x=1770197461; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bBjV8XyXDLoEReDqKUKA22e4GI0fZeu23FHRrREbJdM=;
        b=KgsMIo43wi0FMUopEjOwCAEC3ZdullyPFO5zZQWpuuQlGSV4/vDY0aDP0o8ROzQmFg
         yoQJhbRtqqKmiGXf4uQbxsKE5BAcD1RZl6/y8zUzIwrRT2loe0hBV6iM7nbbkjHiVsF1
         bhXDZWQUe9h5U1GsUgc+CRye653r0MeTt4tcAih42VkJt7U811H0gqvTyIoDbrjILtON
         IWELZd2aEEefnDMnf2X9jc/ry7qyy2mCLMcJj4taPn61pcPPjrJKgJooo+QEu7dKwcd+
         1ZqDtL5TTSpBa4ByJslNBbfR15Y+DD3VN3p/Pl29LOaVa7JM3b4MVJcUWrV2gkYxGDxP
         fnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592661; x=1770197461;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bBjV8XyXDLoEReDqKUKA22e4GI0fZeu23FHRrREbJdM=;
        b=R11zRjsI81UoFUul0hZYtrp0g1rYXjk7OzOfZaUIEAqtla0Dwr8bEs89PokNVXMgD8
         wmzPscJ0ORkOevaO/A/zUY/iBNHUlZz5DuVPKtdYJxtyH+0U4tyj4PTdzyJzaSGQfXH6
         sTa+V4/nbUEKSp9LinJG/x1CK6Ve/uWGnuY9KcP6LGWSK0LCtb1o4YXNiOO9LfPD2aVV
         X5wcIAo+PK0M3KaeDu/K6J5hLZ5dRgfEFdlGkKRXKGyKan+g0v2kuRMoF9v2aYvLVryT
         fdcIJn1Df7VxIlcsw5qdInezaSmKuMehTICd9HDfhDH617Q6HVoPqD6cCHWPgGugljus
         QHkQ==
X-Gm-Message-State: AOJu0YxBPP8+reqoI5Giukdch1khuC1tfl63xd5ZSLa3tbqCq1XVmUf9
	pTSp95fkQT6gvRtOANqOIEQQG00RxQHBa2YOVjjKK1s/VAKi7ktw7zps
X-Gm-Gg: AZuq6aKmjkzEEaUdLBcMmuyLFk8vev0rcVmzh45jQ5K25X7NxOP4bHrTGhoBgiCba20
	sWbP5+f9krk6fClpn+flfDb5UfEol8lS668dWwz/NmGqewF8911TFsrpS9iz4ixwg+pl/r9MtUn
	KI/hDi094+5AK7GrH6nWBKF1eTs8EvEtga0xo84UIQPWBy4sssK/kexY4WpGc8ifQ53V4oSzLi7
	+XojeOs2smBpvyCsQbZB9TCSd1p8MUP5r8NMF06VIkMRWqU3Lts9jXs4INEYG/YbiQWqZQjA+FH
	tzbGaHZVt2wtBtHBmvdjQ7mjAtqeHSfd+TH9JNTSoUSvq5h3hXjEhFuHusC3opnAWzJ8MPdHSsq
	yrj+b8VSPEof1UyNkzQ6Mns4CrdlhSPBZyc6Mo+GuOq6TXyjClMnoNreFB5ah6xxamiHh1AwgIf
	X8h8cN0qqCt+D8VAqJwI2QVV6oInIgjQoOwKWsfNeVepAvqpUJ28rHXEPFQg==
X-Received: by 2002:a17:902:d512:b0:2a0:9238:881d with SMTP id d9443c01a7336-2a87130a499mr48464525ad.15.1769592660621;
        Wed, 28 Jan 2026 01:31:00 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:31:00 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:32 +0800
Subject: [PATCH v2 08/12] mm, swap: simplify swap table sanity range check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-8-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=3805;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=xEm9vmKYs9I8cGuUNSJYWeygrYtNmSS9LIdq7v6ecsc=;
 b=CUVi91qTEx9seoLd4nVc/dyAm11X+quXmPpT9xgVXUnFcUQM1MsVopybAyeIimWtDj/4ioUTd
 65YlGEfRcVhDQPepEaODn3lzB2foec2pXntqtIJ5Cqsb8HJ9ymQKWUK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: E475B4000D
X-Stat-Signature: 5afx5u881tfz67irzcjh8e57btdw17yr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769592661-887575
X-HE-Meta: U2FsdGVkX1/ngy5+TkR0xKxJaolvi6pgue/7nJyFu+Gr8MFk4R2783RUse9k20jktTNwSru3qN6rogiyEvD0RDxC+MDH1Zl13Jf20ibyWH+fJtoLFTOVPnnV4QHfe4VlnFUvcR+Tzn2vHC/iVzU479OWuz3d8MDfWbwy/DzH37RXZersD0wksxQwtEfZ1TfAJY3vMq4fksw7Sjo/mx3rI0LOS7+3DhJ3WvMEpFHzngw6rcc4Dv1tJPogZu4cW+xIr6LvNXwmaLStdVr9ZuyY5DVEik2g8wttjjMqbiKaQYa3FQJqEk4WGzwTXAl8iEtBAEft3MA+XI5vtSM6KimL8iP/25Y4Fw6UiZhIWel7VYaMHrQnN+Ur5WhnFtvCFYS3EZ90TYYs6kWuR9Dbf9d1Aq42DlM2pBtvjQ2zyKJfKEk8CHDvG8AqZZ3oBwkSs8vVO6NXU6la8hZ+pwJtJdIyCjsqPjXf0TxLeETixKOPrJiL2g+vFg8HE7a3hsA5k0ClIWh6l702PRB0H8KJtAN1Nv7gUVjI1O06DTC8plGYzSTPI0njj+1/2Khhpt3eQ1RI5dZPuwU6PjRanzzxxf/Wtu07ycNhXdQn+bkym2rQpbR3cpC4obAuuhqivQTvRAfa+o3YVSx9BSLv0mSDCoEKETI87eCgUYSenuLuVpQ+dfF5SuDB8sYIp7iyvcPeBoyXrHfz3+SrJmGqthYORX3TGvlPifKbxwVD9XiFT/jx/vm57gF7smh9kwttY8pmOvt/WG4qaFTzPa53VX4UJBj1TEfrmoJgNZw20hJEWN4AfzijanQHit5VldwVlUsgM8mcnPlV/zBah65diGJyc071jzdSBjIOIe660zX+SsFpnQSs9SrY0v7OgQkd+8amh68MuGVTXMINzsIOrZXcXiiSj8OaRip27SAI8Mx7GEf0Kp4S+vlxq0PMeyDG2dVK/huRc/Ho/2dOfGlrQ7FkZLv
 xUcqivBQ
 IhfUda0qOPXgpf5RuoHnQUcpAC1xPcvmZ/fZ67y6N7QRZZQ2eE/2vO6VRXo8zgwJwkTeTwZ7udn1Q4cF0/Tu6ivBjArh0KRg78jphiYSQTYdXYsk0SeEKNLvFdo4HS98/l4qF6wRGrnvWOzOOctPJT/E5JKn546M8yz3KdqbX6dlbNswVKonVNJK5uzHP+pyK7ak3P2L7Gheyw/xqsf5YMTw+3W3ORyo/QeRUAyazt8PREE1JGWrXmYqauqbVRlMwLapqHoG0sOI81xiP8ClT0SHPi0/7UjqHvNJm9AAp7grX1JmUKsM7JU5I+aP/QBHasVT7IlNxV1Vy2Ur+ALwYns09F/oBYnhY+blFlRPHptuEiTsrVxGYNhk/e7g/dD0Umj7UZEBxAfgliO4dTUitvrBi5K9ea36PUvbN6xIAaj8VY07EnS6oYN64WQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The newly introduced helper, which checks bad slots and emptiness of a
cluster, can cover the older sanity check just fine, with a more
rigorous condition check. So merge them.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bdce2abd9135..968153691fc4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -459,9 +459,11 @@ static void swap_table_free(struct swap_table *table)
  * One special case is that bad slots can't be freed, so check the number of
  * bad slots for swapoff, and non-swapoff path must never free bad slots.
  */
-static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
+				      unsigned int ci_off, unsigned int nr,
+				      bool swapoff)
 {
-	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned int ci_end = ci_off + nr;
 	unsigned long swp_tb;
 	int bad_slots = 0;
 
@@ -588,7 +590,7 @@ static void swap_cluster_schedule_discard(struct swap_info_struct *si,
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	swap_cluster_assert_empty(ci, false);
+	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -898,26 +900,6 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 	return true;
 }
 
-/*
- * Currently, the swap table is not used for count tracking, just
- * do a sanity check here to ensure nothing leaked, so the swap
- * table should be empty upon freeing.
- */
-static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
-				unsigned int start, unsigned int nr)
-{
-	unsigned int ci_off = start % SWAPFILE_CLUSTER;
-	unsigned int ci_end = ci_off + nr;
-	unsigned long swp_tb;
-
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		do {
-			swp_tb = __swap_table_get(ci, ci_off);
-			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
-		} while (++ci_off < ci_end);
-	}
-}
-
 static bool cluster_alloc_range(struct swap_info_struct *si,
 				struct swap_cluster_info *ci,
 				struct folio *folio,
@@ -943,13 +925,14 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
 		WARN_ON_ONCE(si->swap_map[offset]);
 		si->swap_map[offset] = 1;
-		swap_cluster_assert_table_empty(ci, offset, 1);
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, 1, false);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1768,7 +1751,7 @@ void swap_entries_free(struct swap_info_struct *si,
 
 	mem_cgroup_uncharge_swap(entry, nr_pages);
 	swap_range_free(si, offset, nr_pages);
-	swap_cluster_assert_table_empty(ci, offset, nr_pages);
+	swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 
 	if (!ci->count)
 		free_cluster(si, ci);
@@ -2769,7 +2752,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			swap_cluster_assert_empty(ci, true);
+			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);

-- 
2.52.0


