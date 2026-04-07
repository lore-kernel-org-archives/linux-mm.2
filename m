Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C32FEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67DBD6B00A5; Tue,  7 Apr 2026 10:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5435E6B00A7; Tue,  7 Apr 2026 10:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431826B00A8; Tue,  7 Apr 2026 10:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8996B00A5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:55:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 015BC140850
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:55:48 +0000 (UTC)
X-FDA: 84632059218.20.4E29179
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DE8CD1C0003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qKViqKdN;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775573747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra3YL28ifItPyJZiMzQ2cfn2q2yJfzaAHaehBB+uxmY=;
	b=TnebuTC5FzjNwwKLy2UfKwWC9vIwOT5HZ1T3JWFNuWzTodU1nJcvslY8Dqe7ZSFlLgA+Lz
	erivlfd4WAJyQHr3lNW6ylXwNNxKN5IPwfkO7JTJr+DJe3zV6Zv8f6DxKLsT8Y4xlcudHg
	Nc4u3FGe1kylwVo1wDvBOUysESPz2FU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775573747; a=rsa-sha256;
	cv=none;
	b=2f7tRKSFFXxrhyorid5su9Iqr5BanTEYbcyi26jESTZ3mDXOMFzUtyiaVcSTYSHgawqks2
	pdWGS/IQYYj/qJNko+jQ/pbU3BjfWHOelhSUJOHzIxhhcL4F2mFBDqLLsCAM/FX4MpBmem
	fMv2Gwj7VLr5W6jV6IM+yjXZKKq/MzA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qKViqKdN;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E378543977;
	Tue,  7 Apr 2026 14:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB0BDC2BCAF;
	Tue,  7 Apr 2026 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775573745;
	bh=Fv9PtzN7xCSTNsq4ANj8AT1swf3W60piN2PSJ2CQe5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qKViqKdNbUTPQihtHtm1YVs6+OE/BmF1bRVTdVUeBbqshZPcUsmBWB/POqBPmhTi4
	 Hz/pt9Xs46mhPrQ3ILw+Nm7UHZPtF6fjBoE1mNur97AaHB9X+yeoU8E7HhLuWM1EZM
	 ObA2ayE7aX6LpG3e5R8ewXHVNc3s3ADDCtqY7L5wz3+dq3vC4QGPQkJ+gh16zEC+QE
	 nVlGDc0sw9b2HPKiU8Rjq+WJ4te1fzZc9OsgegPqBAi8E7Usrr/wWs1rwIMOLRp5r4
	 XAeLqyow15dqL/rmw1LJoDYf37JzoOzwuT00PPRhlzoBTlsM5SkxQVh5g1+XJbeA/7
	 kUDZyuZ6CmiRQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC60FEEF49;
	Tue,  7 Apr 2026 14:55:45 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 22:55:42 +0800
Subject: [PATCH RFC 1/2] mm, swap: fix potential race of charging into the
 wrong memcg
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-swap-memcg-fix-v1-1-a473ce2e5bb8@tencent.com>
References: <20260407-swap-memcg-fix-v1-0-a473ce2e5bb8@tencent.com>
In-Reply-To: <20260407-swap-memcg-fix-v1-0-a473ce2e5bb8@tencent.com>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775573744; l=6871;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=8waYhVG/zmYZKbTD5LXs0veHtD/HsXryyRZUBo5GKyE=;
 b=irCjKZJcfH1APdFUGYgGW2UOdJ94anKzvDXlkVQVoeRoDu0PD7sDKOyFiX0KbC3RdeQzjyai6
 YgLFnp1vTe9BhgDMcWBN37tGPiBPT9o90xyn/zf486gb5TKWojQBGk5
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: DE8CD1C0003
X-Stat-Signature: 514djdeti5i4cc9m7knz9pt6tnjk8ijp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775573746-657492
X-HE-Meta: U2FsdGVkX18Ybd1xOcgq5wa9jC1xvbkCq1V4EFig4SbKozCLvYeWZgELE0lSxSYAm+f/LQcie1WdBMncrhN93yHHqD7miFi8zUIPd3CafctMUZ9IgftyUKmt9YG8q+M6On166jDG92+S5mNjjof7eFZPuaQzin2byXX8qHBqO28593f3CfmAua2jqrP6LoPAgB68v6MUpQEMjgcau6/5tUjL02X7Vnp782fTQpoNKYXITe68uj4l1H/2bgFlQIueKPe3rHR9pm5nMxfyijAjP70AtGgK6RVMy2U7CXj6U6r/oCAMPDSYhSMZsp7zmpjibQGhG+Xs0iBN4qyryOGmTFub1HJikYWtIBvonLCqiL3C7qEOC3sRcy7gvIaop3RreV7Cz/5eeOHAwOMcDMBcKsaX7qwMosJTV6LgBLcV78h28Aep34vdAp3F2/GO225cTNUsXnK2oJ/TLn2+kGfREBqh1Qu4VQGiyFARytgNcsfzl9Vp8fOe2LXT7GgIk0P7DbKzkveAViW4g9t09wF0bz/cZBVK/77ZvyK7/m/j8XmXbzIWaS/DNt9DthjfTLhcsmp0Vlxnga7tf6RlMTE+xT1CftTtZUZsMAwbPT/z68GiZGuqjb1OGy02KASBDzwh7lxh/9UbcVJaKAetZv/KuELffNv+i95cjZV/sJ3e4d6P330ijOKUoVgPgMhBR/804erNCAhJQaIFXlqz2ty23f296o1laCSZ6HvIXh2j5JqkHO52+uNFrYUAz7Jn76bzcIrZ/UwKXV+zpc7el1FKlA8Z/7+68OErdHfhHrzr/KwN5rV9roEaxL9uuJCvc8XN5Y6B90BDw4e9Het5w68Rc+GIC0RHXu4tJmmECd8pJGn4IH9Zlwp0DerywzED1oIOkzF+0Ql0m5i52ezZTpbuV1pA5ofbdFK0bUWeapADWqB3nCgt1f1XXsPBPeINMB+cr9PUNTrwSFqnbbQLIlI
 RjNUzuqP
 s5V1pryvVZHV9nQXKUzppm/0BWTai3V/hEZtdNt1dDzWP7Jo8Vh1Kf5pvFGgRN7//XAFFI86eMecnxcobncrtLjxnXwviHIESpIEEMXQQl4sU8nc4oKneq1y5DsSJVyxQwxbDyOOm0rbRf2eMXIjMSsVPJhQuodCIIVEXRW7BL4ppB0nq8e/NBv0Fu836Xd09UB0hDv0EMb9lSE+n/BSmG2r6nooZoRoTpyDjMpH+r+srP89nZhwn/5s1TahKE8tX71+REyHyijK3R0WfURf6gAhOuhXOE8rG/pG+HfT34rGgJ3jXQfYMsz3n/NLbWB96LKL701BGp0cvugVY2ljH2AEsfLb3Z6bYV7qzuexoAULEYPcB+3muhwdlUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swapin folios are allocated and charged without adding to the swap
cache. So it is possible that the corresponding swap slot will
be freed, then get allocated again by another memory cgroup. By that
time, continuing to use the previously charged folio will be risky.

Usually, this won't cause an issue since the upper-level users of the
swap entry, the page table, or mapping, will change if the swap entry is
freed. But, it's possible the page table just happened to be reusing the
same swap entry too, and if that was used by another cgroup, then that's
a problem.

The chance is extremely low, previously this issue is limited to
SYNCHRONOUS_IO devices. But recent commit 9acbe135588e ("mm/swap:
fix swap cache memcg accounting") extended the same pattern,
charging the folio without adding the folio to swap cache first.
The chance is still extremely low, but in theory, it is more common.

So to fix that, keep the pattern introduced by commit 2732acda82c9 ("mm,
swap: use swap cache as the swap in synchronize layer"), always uses
swap cache as the synchronize layer first, and do the charge afterward.
And fix the issue that commit 9acbe135588e ("mm/swap: fix swap cache
memcg accounting") is trying to fix by separating the statistic part
out.

This commit only fixes the issue for non SYNCHRONOUS_IO devices. Another
separate fix is needed for these devices.

Fixes: 9acbe135588e ("mm/swap: fix swap cache memcg accounting")
Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 53 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1415a5c54a43..c53d16b87a98 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -137,8 +137,8 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-void __swap_cache_add_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry)
+static void __swap_cache_do_add_folio(struct swap_cluster_info *ci,
+				      struct folio *folio, swp_entry_t entry)
 {
 	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -159,7 +159,14 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	folio_ref_add(folio, nr_pages);
 	folio_set_swapcache(folio);
 	folio->swap = entry;
+}
+
+void __swap_cache_add_folio(struct swap_cluster_info *ci,
+			    struct folio *folio, swp_entry_t entry)
+{
+	unsigned long nr_pages = folio_nr_pages(folio);
 
+	__swap_cache_do_add_folio(ci, folio, entry);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 }
@@ -207,7 +214,7 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 		if (swp_tb_is_shadow(old_tb))
 			shadow = swp_tb_to_shadow(old_tb);
 	} while (++ci_off < ci_end);
-	__swap_cache_add_folio(ci, folio, entry);
+	__swap_cache_do_add_folio(ci, folio, entry);
 	swap_cluster_unlock(ci);
 	if (shadowp)
 		*shadowp = shadow;
@@ -219,7 +226,7 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 }
 
 /**
- * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * __swap_cache_do_del_folio - Removes a folio from the swap cache.
  * @ci: The locked swap cluster.
  * @folio: The folio.
  * @entry: The first swap entry that the folio corresponds to.
@@ -231,8 +238,9 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
  * Context: Caller must ensure the folio is locked and in the swap cache
  * using the index of @entry, and lock the cluster that holds the entries.
  */
-void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
-			    swp_entry_t entry, void *shadow)
+static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
+				      struct folio *folio,
+				      swp_entry_t entry, void *shadow)
 {
 	int count;
 	unsigned long old_tb;
@@ -265,8 +273,6 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 
 	folio->swap.val = 0;
 	folio_clear_swapcache(folio);
-	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
 
 	if (!folio_swapped) {
 		__swap_cluster_free_entries(si, ci, ci_start, nr_pages);
@@ -279,6 +285,16 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	}
 }
 
+void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
+			    swp_entry_t entry, void *shadow)
+{
+	unsigned long nr_pages = folio_nr_pages(folio);
+
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
+	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+}
+
 /**
  * swap_cache_del_folio - Removes a folio from the swap cache.
  * @folio: The folio.
@@ -452,7 +468,7 @@ void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
  * __swap_cache_prepare_and_add - Prepare the folio and add it to swap cache.
  * @entry: swap entry to be bound to the folio.
  * @folio: folio to be added.
- * @gfp: memory allocation flags for charge, can be 0 if @charged if true.
+ * @gfp: memory allocation flags for charge, can be 0 if @charged is true.
  * @charged: if the folio is already charged.
  *
  * Update the swap_map and add folio as swap cache, typically before swapin.
@@ -466,16 +482,15 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 						  struct folio *folio,
 						  gfp_t gfp, bool charged)
 {
+	unsigned long nr_pages = folio_nr_pages(folio);
 	struct folio *swapcache = NULL;
+	struct swap_cluster_info *ci;
 	void *shadow;
 	int ret;
 
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 
-	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry))
-		goto failed;
-
 	for (;;) {
 		ret = swap_cache_add_folio(folio, entry, &shadow);
 		if (!ret)
@@ -496,6 +511,20 @@ static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
 			goto failed;
 	}
 
+	if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, entry)) {
+		/* We might lose the shadow here, but that's fine */
+		ci = swap_cluster_get_and_lock(folio);
+		__swap_cache_do_del_folio(ci, folio, entry, NULL);
+		swap_cluster_unlock(ci);
+
+		/* __swap_cache_do_del_folio doesn't put the refs */
+		folio_ref_sub(folio, nr_pages);
+		goto failed;
+	}
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+
 	memcg1_swapin(entry, folio_nr_pages(folio));
 	if (shadow)
 		workingset_refault(folio, shadow);

-- 
2.53.0



