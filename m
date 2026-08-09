Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC16EC5AD4E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 15:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33BA6B008A; Sun,  9 Aug 2026 11:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4A46B008C; Sun,  9 Aug 2026 11:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48726B0092; Sun,  9 Aug 2026 11:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9026B008A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 11:01:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7AD7405A4
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 15:01:33 +0000 (UTC)
X-FDA: 85082044866.05.84C27F3
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67EEA40010
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 15:01:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786287692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bW3pyjxIZk+evPk8vS10AmOTCrkMraZL4FUFaCOxIxI=;
	b=JJb8YAj9Pm7cgKWUkcXviDPsCVAMYUExhTRMqeSn5Z0Od9Ygpbmz0Uw8PYK1ZIMk4+GLqb
	2GDNsD6Onu18yx43WC9EJ3M+VatNRpcrFRQvR+J6KL9TQyqk2hv3Yq+vTxb4mf0gprZaa2
	j8FIj0Iwn2wvGDKDJ1cR2igLA544xY8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786287692;
	b=BU4FQ4JOCv1dtN7uFqUd54hsdxaOMbkGn4XIBUrVdyosxI94ahccjlxxmcIPsjrQkPq4AR
	X7KGjASd2PyfoyJ37wxU0nzS69vfZmb/CCTDbNzHPcIr7enx0jrLMj8XnYOLwkPlR9IYIH
	K3BYUnWphqlMq1WQ/qVHTmWYxTBW/B4=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 9 Aug 2026 23:46:29 +0900
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
Subject: [PATCH v2 2/4] mm, swap: only allow swapped-out slots into the swap cache
Date: Sun,  9 Aug 2026 23:45:57 +0900
Message-Id: <20260809144559.2104856-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260809144559.2104856-1-youngjun.park@lge.com>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ic7mangijftp84qo1t59rjeaggqdob7k
X-Rspamd-Queue-Id: 67EEA40010
X-HE-Tag: 1786287691-672514
X-HE-Meta: U2FsdGVkX1/cAmmeCZq7qja/FnUCDnBg9FNIrlvi1UJUgjK4kElnTJ6VZXox8+KhXKfH/n5LLoWxM+arIh/cxfaDHw9M3c5wgdkbkpVqS42etpcYmqQ2oRBzVTvL2eZxgF/mIqBnqIb0VO1139Ld1EdPy5LD5Ft8GWRIwt70j1RkLwJV7fayGJNYLn6R/Si1RqnzOuFMaSsa/631JJgcPGqzwbGdqZwujiq+Hn7APWW4iDyNa2PEXfpuAHrJLSzqBPmWMheEVkCcqiH5bf7/VZ39ns7p/O8ajR6AlULcOWZKpOcvm0a5WVy1fedzEGz0krePJyj0lJISa/o7DXALH7GxAUbbpaLHz35aPi/j7TsbshN4c+sSHENQ61wu3ZPceRcLIeUVbrbWcrMXNPyFiuxNn/GG3fGqu0FeMfIkWgiEca9UODjPm9ydkF2RmD4aFWRLXyfeJWYlDNCFyh2aOCwV/7KhS8NX1S5cr9E8o9SPzH71G3OL3WHn8AjEs8gchyWBI0boLXccCxbr+amu0Oa7fRPKe0oFR0SyUuTRO+Sjqwf0Iqy4BF0QAp2zyqwQsB/2oh/qz6mUawWcc9o2186LZEjc34Xx5LETLVsDIJbfSJ792jyQP1O0VxrMH5qdXnbKbneK+jPAzShv44GUOndGE8UgUcFuuQLENmTdNlNK4fZDwqyfCCFwXJRCjSE3e4OIYjYHWmNrXcI1fkV981QHwk9tmoAJvW0WizKIr3Yzu2EZPtx4CeyPLEURRzLS2u0CldFkixW8cLPF2Q+LoCvtvyOzCJui+REGvkJCl+pEFZTHKzwbuwYP2Si6yhcaSWTvbrNrzIENGx2HyV5zFhw1EUbAdWYAP2ItdkOmY8xbsqTs6L10t+0jPeFmWVgY9XB1d4A7CNuQrAoFd6EWA61hfRjT7T8xF1wh3eRec8PriRDfKaq1PdAoY4B7wLjL8MRC7latehTOGxmwZOc
 ZlOegxal
 R6cn8NizLlzwr75rGAkkqVhrlLqzVELPjjNgHi+yk/gM1FtUnw4pJ729VkzV2VOiuAPr/ghnSZSHJaqgyMKF/dwyBlnBd0dRePXZupcaz4haKBwf7+nmP4g8CgzUjTFbgK/jy2ZlZPeO4R50ax0C9nlOZzfp5AKAiCAiP
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

Reproduced with a badpages list written into the swap header by hand.
Readahead took over four bad slots before this patch and none after.  It
needs a crafted header, so a normal setup will not hit it.

Fixes: e1e6750df3b4 ("mm, swap: add support for stable large allocation in swap cache directly")
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


