Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF05C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1B96B008C; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D522C6B0092; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBD16B0093; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 962C76B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:22:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13FC01A0426
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:19 +0000 (UTC)
X-FDA: 85089052398.10.8C83EEF
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf15.hostedemail.com (Postfix) with ESMTP id 297C3A000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hu8LDQuZx6ntJh2r6iUjCQ4WU/68a3EW6sVNFRDhEEE=;
	b=ZO7AuotgLIG4PtvcKzA10SgVHgPWETdMJt38RihmHUliGiX8AnrDzsh/uI4YteQfsPxlBc
	FSY/JEf0G1v+OnDvYjiUb330C1BAl0J5HCChC84zUObdIN4vCL9NuhvcEtWlk7kyT1PT95
	PBPoj1PuPEbaYrHRxPoP9p/QVkGSXso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454537;
	b=Edtwr+mCgO1Apen3XpvBwWhdsU2nKbp+Z0DdJsf37uNQzQrklVyigyRiRA0HsYsikjlEGh
	+Cy3WK9YPvJUHKXZSUrzgj1v8/9XPfH866F7FCfihz9GYGy2dDuAkXvwPQZ6qEaRde1HT5
	hopxFnLNSJSVxvGRj5i3Ap9tXnPbglU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 11 Aug 2026 22:22:13 +0900
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
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH v3 2/4] mm, swap: only allow swapped-out slots into the swap cache
Date: Tue, 11 Aug 2026 22:22:07 +0900
Message-Id: <20260811132209.2862708-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260811132209.2862708-1-youngjun.park@lge.com>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 297C3A000B
X-Stat-Signature: f4k8j4ooc1kcm4jqekbzxt855zs84sou
X-Rspam-User: 
X-HE-Tag: 1786454535-291234
X-HE-Meta: U2FsdGVkX1/7lMRMUkz6YWIRo87+JFW/Hj3J2tyaqfUJFbI2VT8jmZZrjeI9jbddga8I3NRXFVVi3yvTW0rPY2PIJtE39O4o+BuhNRCx7D4r9+ytz3nu1L/uiDnEsExJvQVNnO6EnHgbA4PMODzp1VnDKxLsf1jG4sD7FiULf93oJ4k+oR5F6DfloUVi+ZFVtWyUXhK+JP4DjSdrFg7CT4BNxWgmPfv6C6hBBmhg26Il+Yx7EzIEiBxoriV8yxaJC4twTuCFyaO+UdfhsYwNMAwWownGnO4oif1nE5+gOUPyKLN55CVQSNYjBoxlRxa3RAqsRIO6y7sxv9Y4Yd6b3+bQnE6x6iL2vqtxIqHjK4tyNkPhyAkFkNkZVqFRREiIsyBeA8Yq2U+mjx+dj9VRYosh5mkj3AeBy8VWQoJlX5eJds5i2tei+0gCL/JMpJeDh69WAi8an9XZZPbRPRPOTkHZzXdUhylbf8rsvD/gaiZ55LUugXsBzlvHXoWg6JxKRwc4IoYrwZKAiqO26QPojXjCJyJFGzFu1E66jWWKxbs3vjtGeIxYPvgzE6XgjaO8IMgfBhWD2DH0yB6nL6m5Lcuex321jIWpZ4J3yDaqmn+Xm0FcK8nxT8tdOstngLSTKQVgGmWmBZPwH5ts9VYt/fSNh9AjmyPv36jaqmQwD5CSiVGjetFrQkIncLAtK7VSZld9aBCTsXuoWF+i2ufLyJj3yAqJR500TrhgzA6k/i3tbP69cFoPjP3kf+haokL6cX0vLQKm/MCWw/DQo7R06mKbKEkJiajAz6vaji4efWvfyGtmx49NGCzwE3Eph70st5ys21vQGAiKylcUKi1Foicnk7xMpE90BZeWqHuijxMjI5oIA6L8p9TQ+CjPYXJRzTzNwF/k1EOvm1+WSKBvL7YykzER2x/g6uq9xKLwic0DimWHpQLrXBS89Cfa/64JXgSggKMxiOuw+hOSUxU
 r/Rmjygi
 wxT+E4pQXQBxlFn0nsvhk/W2S7sNdhdRJMdR00hOxWQGD4TtzssQK3mfQIBCza6RzJ+/TE3DlVBhdxNddISaWf9IbrMZhfinu5ywQq3nXQh/LdqVNmT9/0Qc8k6oloEi1uLeHlzeqOpSQ1HnGJRj+n5oGgd/jJOUt71Wfo0yo4uIWKiwBEqJGFPI+WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__swap_cache_add_check() turns away folio entries and slots with no count
and lets everything else in.  That is safe only when the caller owns the
slot.  Cluster readahead owns nothing, it walks a raw page_cluster sized
window of offsets around the faulting entry, so it can land on any slot.

A bad slot gets in.  The check reads the count with __swp_tb_get_count(),
which shifts the count bits out without looking at the type, and
SWP_TB_BAD has all of them set, so the slot reads as SWP_TB_COUNT_MAX.
Readahead then allocates a folio and reads the offset off the device for a
slot nothing will ever swap in, and the folio entry that replaces it drops
the bad marker.

Readahead used to be guarded by swap_entry_swapped(), which goes through
swp_tb_get_count() and gets -EINVAL for a bad slot.  That call went away
when the swap cache checks moved into __swap_cache_add_check(), and the
raw accessor there does not do the same type test.

Require a shadow entry instead.  A slot dropped from the swap cache always
gets one, empty if there is no workingset value.  The type test runs first,
so the count is only read off a countable entry, and the check as a whole
runs before the folio allocation in __swap_cache_alloc().

The large folio walk in the same function does the same raw reads.  A bad
slot cannot be in its range, but the range is not pinned, so a slot freed
and then taken by hibernation still trips the countable assertion there.
Give the walk the same shadow test, the folio check folds into it.

Reproduced with a badpages list written into the swap header by hand.
Readahead took over four bad slots before this patch and none after.  It
needs a crafted header, so a normal setup will not hit it.

Fixes: e1e6750df3b4 ("mm, swap: add support for stable large allocation in swap cache directly")
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swap_state.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index b76eb3d876fd..6341f1bfffa2 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -181,9 +181,14 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
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
@@ -196,7 +201,7 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb) ||
+		if (unlikely(!swp_tb_is_shadow(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
 			     is_zero != __swap_table_test_zero(ci, ci_off) ||
 			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))
-- 
2.48.1


