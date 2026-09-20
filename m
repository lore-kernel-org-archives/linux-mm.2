Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14209C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1726B00AD; Sun, 20 Sep 2026 03:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA3A6B00AE; Sun, 20 Sep 2026 03:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF386B00AF; Sun, 20 Sep 2026 03:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3F76B00AD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3C161C26A0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:41 +0000 (UTC)
X-FDA: 85233298122.14.A83A063
Received: from mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 10F9A40008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.50 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888960;
	b=ftcepW5zcQhr79aBeD2OlLOSr3qAQIQzNBUdWOngIiyUOlPz188dsRenH/XF4t3XlUcg4Z
	M5jLmCFqyZo8pvVT14R+OCVc9Nm2HFPUaRmDmKJIPQWe12SMuQFylAyhYXyDJW2/CjLZed
	gg6v9q11zLikdLSiv6SXv8j98hByzYY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.50 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CTBWerYPsKQWXnhAue3hwJbBnagaTRQA8NolSBXKAbM=;
	b=qa6aQ00UJFRyqVjRndCY0IKH89Bezi5NoPiXoIUhT8CbF1E2EUzor3qqS3s8Pffpk0SMkG
	N08fM7CfzT9tFVr1rxwmQCao84xsrLAJ6+hahXFfM5/NfsqhAdh2oARDppXCJ69l+ojyrs
	wQCKdjfUqtYcEYOAb4gF2nzhh89eGvc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 2f361a8a0dc5fc5a;
	Sun, 20 Sep 2026 07:22:38 +0000
X-Mizu-Trace-ID: 2f361a8a0dc5fc5a
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
Subject: [RFC PATCH 16/17] mm, swap: do not retake the cluster lock when uncharging an xswap slot
Date: Sun, 20 Sep 2026 15:20:42 +0800
Message-ID: <20260920072043.430390-17-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10F9A40008
X-Stat-Signature: bwrexbjg3mby155hsshai76391thejou
X-HE-Tag: 1789888959-76831
X-HE-Meta: U2FsdGVkX1+KjnvtLttqOVK4iyuH/K83txMX9pEANTm1Ua5KWIB7kFSENSvVdferGbyuYzmiwLEsklZ8S6i5dxIWMXg7ny1siopDRMhckSkvyjGr7au7vJYY+Mwz2pev1rWwp0hhyEOBuIPWS7HRKi543Nf/HdLDlaSzl5cfzTrGs9EzNIFhchuzjwFxWTlNx3UhbG/NnkhEPkwR9sroHO36X5WGvOTsVJJ2NTjh0EfcK9EBkbgsyyaprk5wL2BfNDLFsa/lm75wqM1V1Tr+2GfRnYbkTeGG7OCxEp0i8YKKgKdjFTHSjcev4OJhMMP9f4NttW2BODHIZHoK7ze7AEm7zBnLipCBB32RrMDC96+YowjbhBAyVXZin5RG9nfqk5XnLyP/evMAk3X7tf7lpDFbBFxGvf/lefW/Yrbcq3rMmzBqyEDuz1Gg3nT4bd5so/05wJsna4dZkylNFNzlsoVwDMDI211Rp4Vil0yj1MSe4RvvhoqVqCV5Epi6JMlADzD3raGfvb7z026SPubhbOexHrrovS8WzXGhZcjMX7o2H+IlSjhFJOWSOsxoKe+h1+PkNAIbpg1yb075adc7lftGbAM11uc0M5LKvXtmwePtGW8wDYE7D9xqUnkhF+G3uyLOEbMlUcYT8imf2OZE0eqA8DVKlwqyjX2hEqkfl05P4IVZXnpkt2t++t5YCTC6DqvdB0yxUKSh2GCVmiw65XVmTCT/TpKqJbumn3evPp79RKE1rk6vtLIa1R5D9zZqYLVK0oBtf/gVpLCZ2cjbYSEfcBQeN6zJBecQ5bZq6Ss1/kcchqmK2wLB9oJgk1IFOXllIe/kK9kDW/rHVGdSFz2lgHoEaY0KVDmq7p/rqZ1RB8n/aWKOeV3SbA/bOTEeuObC8bFUahlEK7WRcUN6Dsrwuph2jGCOL4eSNyd+Qyl9/LiuiX313iOXqdYf5WQZvkRrJbfMc6ly4J0HOXp
 V68XD56+
 tbfl+nexn13j+pG+9LZPKk4H96mCu+OJDkiqRAe2LYZxyVoOz3UZuvgYt/S06imcn5GnFrLwbfl9xH4x/wwypY54FrJeobMlGBkXZIKktjLwddtUt4lgzL4Rs3M2R1EGImLKPsehy6Dab7YeBs1dGhkLfCDo8ZVta7AkuNfE+wiI/x7OSF5HDkE42/UQsMZkydUoGYDaOFV/HpuXyf7PtZKc3j3jB0dteY697q/So8hz1Sb3qIbwfXixKCpGhIPMTu90w+Jvk5klGHl9lf9+b/AqLHZhEpBz5nic142Kmc/qaxEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap_release_slot_backend() runs with ci->lock held. Its callers free
the slots of a cluster they have locked. It called
xswap_backend_uncharge() to give the swap charge back, and that takes
the same cluster lock again to read the owner out of the swap table.

A spinlock is not recursive, so it spins forever. The swapin path hangs
on it:

  do_swap_page
    folio_free_swap
      swap_cache_del_folio
        __swap_cluster_free_entries
          xswap_release_slot_backend
            xswap_backend_uncharge      <- spins here

Read the owner from ci directly instead. The lock is already held, and
the cgroup id is still in the swap table at this point: the loop clears
it after this call.

xswap_backend_uncharge() stays for xswap_backend_free(), which runs
without the cluster lock.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f59dc74f574e..7a67c2ff4e89 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3172,6 +3172,7 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 {
 	swp_entry_t entry = swp_entry(si->type, cluster_offset(si, ci) + slot);
 	struct swap_info_struct *psi;
+	struct mem_cgroup *memcg;
 	swp_entry_t phys = { .val = ci->xs_table[slot] };
 
 	WRITE_ONCE(ci->xs_table[slot], 0);
@@ -3180,7 +3181,14 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 	if (psi)
 		xswap_free_phys_slot(psi, entry, phys);
 
-	xswap_backend_uncharge(entry, 1);
+	/*
+	 * ci->lock is held here, so read the owner out of the swap table
+	 * directly. xswap_backend_uncharge() would take the same lock
+	 * again, and a spinlock is not recursive.
+	 */
+	memcg = xswap_entry_memcg(ci, slot);
+	if (memcg)
+		mem_cgroup_swap_uncharge(memcg, 1);
 }
 
 /*
-- 
2.54.0


