Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DB8C5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009896B00A2; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23B96B00A9; Thu,  6 Aug 2026 15:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E603E6B00AA; Thu,  6 Aug 2026 15:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C14E26B00A2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:06:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F5C81A018C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:43 +0000 (UTC)
X-FDA: 85071776286.13.3993D98
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 61078140011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELNJSVEb0cDVmfZSys7HhB1zosWpvnVgY3FW6j61yJw=;
	b=1PeYVVnM/TGTKHf0qm9cjnqQe266xzD/MWj2CqbiUW1M4Qro4eNCErpVqim4h0xrj4ykIS
	aSDnyTkLEoOWgUTZj614GKbo6grZJnN7NDMmMhiilVITbHfyKtYyd8DkWhOJhH6J3/rMT/
	oLuInNu2mhSPlR+xdxmnQFSHzNBdtOA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043201;
	b=45cPfVsGKE1uHMFFMTkLv2n/gKBaeNMu39VS8db6+TKhhWlFS7VF940+r5OZCWbZeNFbU9
	B0U6F4gdb48CX/lthsKai/bj5hl4GSO1AUoMmHbwQnXq7qqXznbcggDbqwI2iWHJgvKPF7
	iuM3scoC7lCY5SRHgkN2CigH21VQRyY=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 7 Aug 2026 04:06:36 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mm, swap: only allow swapped-out slots into the swap cache
Date: Fri,  7 Aug 2026 04:06:35 +0900
Message-Id: <20260806190636.446205-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806190636.446205-1-youngjun.park@lge.com>
References: <20260806190636.446205-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: gmt5599ftsywmhz3rj9wndxfdghyapf7
X-Rspamd-Queue-Id: 61078140011
X-HE-Tag: 1786043199-473862
X-HE-Meta: U2FsdGVkX1/uZxv/0zjLf6IqFh0K2WZgl9XWpp8utJRcK/rrn0Uwz+GTTHcGzDIKP2Vw0NlQIUBIBgfHw6S3i6OHj3ks6C6nqh+LtrQ7Fz08r1L9TXjYwZVaTmU/j0aPRBRSveD5FOpIgQFvqCT493l/J8Hq7w39UWOcjXlzYr7jO6nqS/9SNmdSIVGF3z15SxktdlCgmrijGn56h1xWld8tQ5anRUBaEgeUOYxiN/UtONCrLJy8YVT6iL9403l0ug00XDTZt2CvpNDBR0FmwtINhcedbWrgDvg5CRC1PNdA1HsPru3Q78s33/f7QwB/B4uPJDjdGQF2RqXzQ6PhGQXkjTlGQVNhywyuVJjAmAIJ3kuts/HbhJOuqsB9eZPEsxQaTiiJiJvZIczxx42xFTjiTNcwt85p/jCDCwL506TTxSojvGdorasoy7sNfMmXJnD5xy2OLISxPa9aDtCEKlSJIklPaSPKT2/xW1vRf/ySW9fJYf8V/7OpimdHud+BZZj4kBCsFvNIdsWirqjAYzJ/sAn4E6ay+VOyD+NnCl7vHS0Tzj/BkYzPCiBBlHRB+RotfWf4TuNx7PJ16R40aujdZjZ1yB5fMY//bmgRqF9iFv5AD9yRZgMBB7V18/1UXAJKwLMqQqB5+2arFuhfV7zFqOersEo5pcUQFKoqpvHFWKCVFAfWp4TLpUf/gmvpFxWW7dLJihUQWjk+3+Rk3ApiNpz+Cejc9U1Ti5HZlDQvA5D4PthckHRTOaGKdch9y7cbhm2qLKFEkM8p35xY33i63+42QRe4w9KVfTGb7RjMZxVHhNgRNwho0U6EEEt2xWAydvhEy6q5fQJi43VIFEJrMY7wRaWx951oDKX02r1yVL3Y9y+1MM4Qo+NHMgQE54hDvyp5BB/WUnprmMHhmgRXZN5HRd5d3GHyNUg3dPeYSSFmwvsHbcELQOyyRSm5t3c2/Et3pi8mm6cBupx
 qR0Nl0Dx
 RciiNMV47CLECuSjW1KXggPxkPT5+CRH+5Kku9TXl2chaFEBh+8WvTTnboxSFLJAcF8WlevSi5fRku9UXXbpAWHEvucE1/zNyl2ln8jip7sr3Ac8Pvb4g9hMQFpGhWbiYPYloauyKKpGTavgWFFODiroATG1HVy7IRqX7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__swap_cache_add_check() turns away folio entries and slots with no count
and lets everything else in.  That is safe only when the caller owns the
slot.  Cluster readahead owns nothing, it walks a raw page_cluster sized
window of offsets around the faulting entry.

A hibernation slot is not a folio, and the count test does not stop it
either, because the type the previous patch added has the count bits set.
So readahead allocates a folio and reads the offset off the device into
it, for a slot that nothing will ever swap in.  A bad slot listed in the
swap header gets in the same way, its count bits are set too, and the folio
entry that replaces it drops the bad marker.  The first patch keeps that
folio from doing harm, but the folio and the read still happen.

Require a shadow entry instead.  A slot dropped from the swap cache always
gets one, empty if there is no workingset value.  The check runs before the
folio allocation in __swap_cache_alloc(), so readahead now skips the offset
without allocating or reading.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swap_state.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e64..9f2cc5918713 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -180,9 +180,14 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	old_tb = __swap_table_get(ci, ci_off);
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
-	if (!__swp_tb_get_count(old_tb))
+	/*
+	 * Only a swapped-out slot may be brought into the swap cache.
+	 * Cluster readahead walks raw offset ranges, so it can land on
+	 * slots that are free, bad, or owned by hibernation.
+	 */
+	if (!swp_tb_is_shadow(old_tb) || !__swp_tb_get_count(old_tb))
 		return -ENOENT;
-	if (shadowp && swp_tb_is_shadow(old_tb))
+	if (shadowp)
 		*shadowp = swp_tb_to_shadow(old_tb);
 	if (memcg_id)
 		*memcg_id = __swap_cgroup_get(ci, ci_off);
-- 
2.48.1


