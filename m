Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B0FC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6715B6B00AC; Sun, 20 Sep 2026 03:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621B36B00AD; Sun, 20 Sep 2026 03:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9166B00AE; Sun, 20 Sep 2026 03:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35E236B00AC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAA311A03EB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:38 +0000 (UTC)
X-FDA: 85233297996.23.87C1735
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8005180002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888957;
	b=FFsjO0/buyuPeh7tm/8arP81rgKKmkG3MW9PSKxlkJnStIMM9FPLPhKP8YqLlCuFWbYsmQ
	CR6tO1WRUh0ej+bU4zLhKxdBcCHWuogf6582zMS8TfnZgZHfX4HNicVfLYzB1QawZtArrQ
	czBztvXRWf6NIT5e0Ax6lLc3wAmkqC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5WjXyHkEtbNHlG2TTyrTitMJHstc12djYJevXdkDWzM=;
	b=QFJPeam9jHGfKNDevGmzqc1igbntMQ2AO6CA5GpUkBMPxsI1EcLDI72yKxUpAGQFgSrj7e
	H8fP+DjZj1+Kx+s7wpnqiIAXwJ7boFytGNL/1tsxhVOSoBRwO/Nf9Hs0mAT8R2J11QCWux
	dOCx9n7flsAd7NiC+H4Fj6iuXC6xwdw=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1be899513a32ad78;
	Sun, 20 Sep 2026 07:22:35 +0000
X-Mizu-Trace-ID: 1be899513a32ad78
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 15/17] mm, swap: don't gate xswap on the physical swap free count
Date: Sun, 20 Sep 2026 15:20:41 +0800
Message-ID: <20260920072043.430390-16-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D8005180002
X-Stat-Signature: c7qcbkwxyotw35c9drmfkhhjqp31rru1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789888956-779037
X-HE-Meta: U2FsdGVkX1/PqvDIZkztubkVXUEn0iCW7Ba//zywimPEQXwOehHjedtBUHWKu+eeTVqzs8v4gBXY/3SH3bn0Zw02VKNQ7r8+582zZ5aAzc6n1Bxgl60PwiYYxcbJgcxKpA/f0lKJtScIrlDzmMYW38B2HiHTAftsf+T3MQWSBSiNM6muKADU3Ct5nKE0S/Rg7v20zLqnySqMJLodU0IM5ppyW3SFVcVDx4X+FhZnDNrQeQktHaLARtY5YPL7KoqU2uek5leOVpLxfhsiKldVnRjewXdNHG78jd6YCJhqNsIXKVeVu0DqcBSKcXvn7ZS4nxvlHxe7Flyf8vIdsn4JPR7OedZS0sgmVgMnQfhXTkLtfJeXwp+wWR1kuKyg3FqpVL/RCZQ+Ug5JYm0iOPn8xCB5Tc7w+MjxniE7NDs8WChhI13PNuvu1Epw3gC0WqrxXXor1s5I42j6doNrwyswwwr+nGS0crFq0uFrVF45xL/vBBc+cpp0IEAoW3XRpbNwB4Coms1eHRiWnzks9tGo4/jqEt1kdQ1Liodd3yQKVEgPKO82K3xRj6Sa3Yfef/3Q1Tuv1XAo04unuBQG2IPdR1D8t+Uf0IqrP9t7UL82IwT0foC4wZycQ/wK6VCP448mT61th0WDEYNpqZPfZ81GKf18nJ0jG8zcIDbk30dd7LpkSzqxsuMel17DZHEzR5u9ujuAbxXFV/oyVPVh6m7y6NHZ0TSSkBINJd5FOri1H4U2wcoJ6oAkWPoQZw/P2vy6HoVTIHbxLymtGHPJTg++LKmab+plKNLxI0YaOKHPYpNS7j5bNtCPhKPl7own++HSoxZCJ6crrUQm7ouoej8nGUwc1L5WTam3YoaanUFG8q4I4Ug6OHnYXDfbrtxan5TxUiKStiZhZnDtmWhq5O8U30vxFuBfj4FRdNMmvD9sWTYvQjRrcRkPtyfSUvQ583FhQSOgo5O4RmaFpSWOsUf
 tTYVje6H
 LNqbWT0K6kX4/k5rfpcrKjyeKQYp9+aKfgK4htkC52nMtRpCoPNCCo7Mc7JsY+YinW963urqdFz3fJzBtiOOns2VM828+TEjVw7IkcMW5EkyZ+uL2tKYMVjQgh5SV4xRlnVXb0uClGlutuSnK7wUWPj9TB4UnvQfNf7cgF+/9rZbWAGdEVskQ+D5Psp3fwd80t66tgl5lxYHPMHY1O1bUEuTs/lsM1U7OTfNTE4gAiBawJNhJySJ2mS4fwx8FGhCAUyHsdxo8Zr2asZxbrRxnQL9GgLER6gF9YI0N0hvSgDEak1otV4ZooWNrQo3fq0/5Tajghe3Zbqwiabac/MV7UP6yloe+ssVAIlV/TtT4rSBc7/AgojEXrun5R/UxXnh9GmTK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap entry is charged only when it gets physical backing, so a
zswap-capable memcg can keep swapping out through xswap even when its
physical swap margin is zero.  mem_cgroup_get_nr_swap_pages() would
otherwise starve anon reclaim with memory.swap.max set to 0.

Return PAGE_COUNTER_MAX when an xswap device is active, zswap is on,
and the memcg allows zswap.  Track active xswap devices in nr_xswap_files,
mirroring nr_real_swapfiles.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  6 ++++++
 mm/memcontrol.c      | 14 +++++++++++++-
 mm/swapfile.c        |  5 +++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7ceac868a885..540a48f203e4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -391,6 +391,12 @@ void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern atomic_t nr_real_swapfiles;
+extern atomic_t nr_xswap_files;
+
+static inline bool xswap_enabled(void)
+{
+	return atomic_read(&nr_xswap_files) > 0;
+}
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1d35b7ae8d70..7646e66bc5df 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6035,8 +6035,20 @@ void __mem_cgroup_swap_put(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
-	long nr_swap_pages = get_nr_swap_pages();
+	long nr_swap_pages;
 
+	/*
+	 * xswap charges physical backing, not allocation, so virtual swap is
+	 * unbounded for a zswap-capable memcg and the swap.max walk below
+	 * would starve anon reclaim.  swap.max is still enforced when the
+	 * backing is charged.
+	 */
+	if (xswap_enabled() && zswap_is_enabled() &&
+	    (mem_cgroup_disabled() || do_memsw_account() ||
+	     mem_cgroup_may_zswap(memcg, false)))
+		return PAGE_COUNTER_MAX;
+
+	nr_swap_pages = get_nr_swap_pages();
 	if (!mem_cgroup_disabled() && !do_memsw_account())
 		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f848c6edc6e7..f59dc74f574e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -189,6 +189,7 @@ static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
 atomic_t nr_real_swapfiles;
+atomic_t nr_xswap_files;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
@@ -1425,6 +1426,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 		/* Count active devices, not merely those on the avail list. */
 		if (!(si->flags & SWP_XSWAP))
 			atomic_sub(1, &nr_real_swapfiles);
+		else
+			atomic_sub(1, &nr_xswap_files);
 		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	} else {
 		/*
@@ -1486,6 +1489,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
 	plist_add(&si->avail_list, &swap_avail_head);
 	if (swapon && !(si->flags & SWP_XSWAP))
 		atomic_add(1, &nr_real_swapfiles);
+	else if (swapon)
+		atomic_add(1, &nr_xswap_files);
 
 skip:
 	spin_unlock(&swap_avail_lock);
-- 
2.54.0


