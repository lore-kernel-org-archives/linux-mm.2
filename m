Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE95E9A03F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317E36B009D; Tue, 17 Feb 2026 15:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8F26B0099; Tue, 17 Feb 2026 15:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7AB6B009D; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A92196B009F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F0E81A02FE
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:55 +0000 (UTC)
X-FDA: 84455031990.10.01F82BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3CCAE180004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nM3O823Y;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358813; a=rsa-sha256;
	cv=none;
	b=DrD+uRgVHyX2JDmCKIm9GwUoqLRPndM44i0R8bxtSvnaHvQc6XihXiB4BpKADthASkqdkB
	7GrJfPk37V/5MFc23oe+AQw+jLk/WqUZL+sIGoglOzV3UWy/a3u5vtdO5/t7x34cKk/80Q
	MAaNSSLVT3V0plAr9ZeXOIpYaY3ell8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nM3O823Y;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358813;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEe7fryeVOHARryDvGCR2p1UjKA6M3cMJZjDPVwNr1A=;
	b=V+6Kf33uEFsXYk3UAvJxFEYtlbTjOjPYiAvMsZ16n4KMI3qUY3AWj3yWsNDI9GZlHVlFJP
	dtOyrOMsnNDjoFrDJ+0gJ/7ZI8EVZ49R9wfXmycib4fRt5OMHYvj93rqTsPbaOF9h5CXWc
	Xre+cNyJUUarvQd9m3QkYUlx1dpUWxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4B4544574;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4AAFC2BCB8;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=XrJFj0aiyesCR8sfr6EgT7R3o4kY+o6mZkv/nmq+d2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nM3O823YPdawuA2G1F7lk9UBV6WVzpxkN6nXhgdNdg6no0Ztv0ZBaZqFwWToVMzWV
	 nVdkVCzmEb0jfrmoCRBy07ZwYDrW2yq3If5vUTzXTVEsYLe42Z0XVDne3XR/ez3Qoe
	 pwL3b6kquDjsL/M5AkLbtkSTnXFcgy5CLmefvj51aa7kmCnT4Tds+Hs+ksqHx2IGay
	 XMS+9kQJ9EbmlASdJ6GfRhOaHgpnTjHLn27QL6BIlRN9AN4Dp638owi0rJVQ/ROeBx
	 Y6U6U8rPv0VSwOBmhDIFch/LVhpn2JDEVzlCsu9tQkUqGFFOa6XXp0VoP6CN4HBWb1
	 /jOxETzpkMrSg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA73E9A046;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:37 +0800
Subject: [PATCH v3 12/12] mm, swap: no need to clear the shadow explicitly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-12-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=3144;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Q0lBjSShyhdY2RwLncpL2hL+mRqIuErD7BuuaEl7Tog=;
 b=8HJd87buS9O2RDjBJVI/JPFWqAGjZ/tZ8SHZCwdUyevLQFXEz7hNeBSGpP8VDEko1e2W88Cbr
 f75J32I17ctAjc73AYgXB2x0BXnap1ldmE0AEALFXDI6Mv1JtT/gaRx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 3CCAE180004
X-Stat-Signature: qxd4sjn3rtp9su1o1h6qsqunpcm9thxj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771358813-581905
X-HE-Meta: U2FsdGVkX18g5pvPytuQVll3Z/kLquoMQ33u5gBD/iI1iUqXZ6Wo5tatFwTytZpyN12AaAe5blzgEJNoe/dH0Wi+u3N9XUXw4d8A6J6kkLGq2jsPCjw3TScYU0lLC1ZeC29Lxp36jktvSWjqQ6xTngSlAmAwQvLi+e9Cgan8f5srA3c0eklRx4zgxmpDX4QDa2k03Q1jD7CL9xDa9b44bdkTHOzG6OYyhAgpcnazF75ZlGwEGxuslkY4GyIedpFowmfFzzILwLUur3Ts1I9pXxdNyBAtSXSJCIl3TTR6A8RnxEabhCiDOr5Wwu/Gb83fsbhLdtFmGWYpzmFtMg90mMgBbz8uzwIl1oOAx58Ozqw7NtKVuYdRKaarH24h86ZDdjIZ9Ti/9QRsBDD8xkhsQaYXHnYWjNUHsTxfc8dhzJ8b69qBY//w2F6Bof+cE55YgnlVPfuBQiwK+RrfR2heRcfB0BdJSc9j+I1w+NzKxpHyE2hDVwojVp+6DkvotxF0LRmxz8uClCnggVAd82o2Ks2iCQblA4ICThVoeDip38wejTq6sOzJBTNjcKQ4EnB8MUo/7eOoR7EQut6AzcEgxKOkFMxwxCAl5sDDh0JWIsDn1+UX3bdlmgpWKca3MCD76qQveq8kUjbcbWsL8ZlYy37DlAhP2bzmWZC1vsqzhWWq9oZPUD56cLX7gwBEpyTa+fT/cA1ipRA2J9m76otO6XQXu+dfv9rGNENKO3fVXPdEHqNudhmlMkjf+EVzCYFFJQwK3DoQN6uN9ZywrwcVTZXHzqrvAQ350Xb/OI8EaUTvL3yCHD2eiGy7iLA/GeT249KQsv0LAeaKX1iRdibF8c9HEQ5YrCX11mQoZdsEV2acyXGwQFzLIHXY182ZEG/790RDVWwCuZgFJAl+MYZWNzmL2lOEys+VUVkg3mOL+uepGW3oHV6u5zcyCGSuPkbE1yumBLBWv+nRvDT1P7V
 hw9KE8Al
 XBdfkbCKZY97HDe0D6LDkk4JKe6bHXCmn4B02SkLm9Ay7KNEjxbbcYRFZ6jJBEJKY3DJpAMSPpKyhy3B9DmlRS/LSWkOLKImbPbx7jXs4VIcYwrtzhh+yfIDIyoZiNKlgOQvy3dBOUw9SoUxky+hiFZiqmyAZkr5bsFRbXcsDg/qB/gdkY3yOc0F4vAVpSR8vWfpFs0F9wvlg74Igjan3/JeZE0h0JTgkO/8XQXZ9Ko6YJNf+HMymftAJUjLyPza+Bo48z98OrnIkcaxBthqcak1Pkj9o5ZWYoSYVTD+Tk/KYPR2vV6nI42b2Hns55A7d18F8t2qHtGa0xGeIqkkjYEAqe6lm5WRsNgr+/Uk7Fe4afWY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since we no longer bypass the swap cache, every swap-in will clear the
swap shadow by inserting the folio into the swap table. The only place
we may seem to need to free the swap shadow is when the swap slots are
freed directly without a folio (swap_put_entries_direct). But with the
swap table, that is not needed either. Freeing a slot in the swap table
will set the table entry to NULL, which erases the shadow just fine.

So just delete all explicit shadow clearing, it's no longer needed.
Also, rearrange the freeing.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  1 -
 mm/swap_state.c | 21 ---------------------
 mm/swapfile.c   |  2 --
 3 files changed, 24 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 9728e6a944b2..a77016f2423b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -290,7 +290,6 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index e7618ffe6d70..32d9d877bda8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -350,27 +350,6 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	}
 }
 
-/**
- * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid, all in one single cluster,
- * not occupied by any folio, and lock the cluster.
- */
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
-	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
-	unsigned long old;
-
-	ci_end = ci_off + nr_ents;
-	do {
-		old = __swap_table_xchg(ci, ci_off, null_to_swp_tb());
-		WARN_ON_ONCE(swp_tb_is_folio(old) || swp_tb_get_count(old));
-	} while (++ci_off < ci_end);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
diff --git a/mm/swapfile.c b/mm/swapfile.c
index dab5e726855b..802efa37b33f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1287,7 +1287,6 @@ static void swap_range_alloc(struct swap_info_struct *si,
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
-	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
@@ -1312,7 +1311,6 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	__swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0

-- 
2.52.0



