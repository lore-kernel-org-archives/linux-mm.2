Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 482C2CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06D66B008A; Thu, 14 May 2026 04:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7216B008C; Thu, 14 May 2026 04:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC866B0092; Thu, 14 May 2026 04:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7356B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:58:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C5991608D0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:58:40 +0000 (UTC)
X-FDA: 84765424800.17.CBD2485
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 447C240010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:58:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nVIpRwXF;
	spf=pass (imf04.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778749118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=71daxRLec4jyhYBAvxsKNAYEmlfTLs3LqROItb0Etew=;
	b=LwEAeS0RzCYo93GZN6YJlKmgErncM0O5jJ+LKWNesjN/55lFWEh9lvO+Gg/7tarAtlKsnE
	MA1eHyuJUniviVeNDb0M6oJU6w2YhExt6nBhrLRtHtqDXweJ2m428hFEBrnBz0Cnq2bP7H
	MKYxpK0Jyc5OyomHxRrfXiIO1Qx9Pv0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nVIpRwXF;
	spf=pass (imf04.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778749118; a=rsa-sha256;
	cv=none;
	b=JnPS/6/JhWiGVz3KYJ/ZnDnhI1pOVwjdGrJpTdx5u511h+UT+DIZFUftqmKGb47K6GKijH
	INmSbJo+zzLpacfJ6OSFE1ueU1nnxDbt/j0jYwYcjCsjWgF1SmwW3uwOsHZfHfC7EZYORT
	NM8FcjLLFDlg/XJv8iA0hq+N6rElMOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778749116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=71daxRLec4jyhYBAvxsKNAYEmlfTLs3LqROItb0Etew=;
	b=nVIpRwXF2bayTanxg/F32tyPngv3o1/mCGuBtHPUjfYatIIn2szaOvrl6AIaOy5TwH7J6G
	Qy2ISDfGZAx8nIZBtScls34NVnaSb83jFva/oyZMPo01TV24mGOZNP6PyM0R0Hzn61K+G7
	bnUuyYdzVrzkZS2tUP462of/uGAAdbg=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm/memory-failure: Use zone_pcp_disable() for poison handling
Date: Thu, 14 May 2026 16:57:54 +0800
Message-ID: <20260514085754.84097-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 447C240010
X-Rspamd-Server: rspam06
X-Stat-Signature: jrk4hjnmfw5izntyadmbup9m3f4gdkf6
X-HE-Tag: 1778749118-941937
X-HE-Meta: U2FsdGVkX1+boKNwbMHDG0XJ7JUUCg1JHPJim+EuwXKdAlPxEBGE9w4R9lTwm1JADbxqS1LJ8X5p52wgX5hYZVAtG1y78BSzjLC5qGoU+1OknWkRH0+nKh4ZgU8g0Icvh0h97CXyr7/6YT6g6ZiJgOkX/3jm4mfXzLgUHadb7r5EvI+KFyKe0IxdsuiJKiDoC8toDEP57wheNp+R2fgQybbF1zWgDy/wU3FqCb8Q9SNRrT7wUUigZNttw1B48ubzZz8EH5kr55M6U7bonQg2euD5h0d/VaY20d3VlRG9wvl+tjAd6Z8Z11LyDDbOBsdS93QA1IBzu1Q7BiwBAmMPBFK7gsdUkESkIDL3Oca1E9rfCZzZlTtXW/0tDU4F17g6HytQ4TpDzRDJr5La4OZg45Th2wYDydwW8Wlnxvz+mkRlWEEnsrR5yZNph/x66TVqRk3GHBo61heXZTG2L//DL2XepEGayiKuPmGAOI5CBxJy4UtZZkXH/2J+wLrJhmdYpGqm0T1aU1U2mDxewZFQGnjAUhIr7b8VhiG6VXLHVWeoljng+rs2fZ5RDx9KIjZSHMel3kqvMmzllPyYNSPw7kKPL6GAZCrJbrb3DC2NIbouIhDOdWULwCks8Mtk1cZKDyUn+KE/uVAhtJQi88PF/hJw7G5ZDcuzt31l79go68vcYc17UhtTXaLAftsfz5anqCD2Ob2gj02JHy2hjiUylVCrpn1K9lYwHEB04FjXwIaMNd8ElvLWkfZ8YZQJ9YrIc6RnfVT/JskQM4uoTcNWUgIjc7iG8fo0uZQHNO94onss2TdIo//SAOaDT4BW4hltqQMswWLrWNKRBA8h6iM6xFUKZJniauRT7CzLUgv2SgWhkkl+ormlkJvoXVAc5u9sv00daE2r5QnJViCtzGbcPQ6irWkZG9PinnCChXIjPydcof/zMeigFed0VRb4i4mdGOtzeKJ+fF3hSo65iJu
 KLmiGN13
 4A2Cy4tkCD44OlxC86cmV0zBm+nnT7FjueW/xSEmrrtUrVI3LiPJ9COrdibyvyQoBSt9k9tyMLeWSGkgTsLBMYReHXGzL0Yr6O5VSMBfE+Q5NRvKymA53PJ3Jo/9t/12KUta+yxSAqg7nx3DpveyF5JFVvaVBfIZRqkiSdjXuIqnVMQE5IGt0xtPneyuiq/QbvxqWAT7qXiwOWc7OFhJ0QXjGrp3ZWHV2vSR412z/E3KnhXnrgnHORNtqa9DJcnx5huDOzw+z8qe47aeE4h1QzwRo9czBuZdWwXwSj2D9PYFD8Y2S+K8oh3kdww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

__page_handle_poison() used drain_all_pages() instead of
zone_pcp_disable() because dissolve_free_hugetlb_folio() could restore
HVO vmemmap pages and decrement hugetlb_optimize_vmemmap_key. That static
key update took cpu_hotplug_lock through static_key_slow_dec(), while
zone_pcp_disable() holds pcp_batch_high_lock. CPU hotplug takes the locks
in the opposite order through page_alloc_cpu_online/dead(), so the
combination could deadlock.

That dependency no longer exists. Commit da3e2d1ca43d ("mm/hugetlb:
remove hugetlb_optimize_vmemmap_key static key") removed the HVO static
key and the static_branch_dec() from hugetlb_vmemmap_restore_folio().
The dissolve_free_hugetlb_folio() path no longer reaches
static_key_slow_dec().

Use zone_pcp_disable() again while dissolving the hugetlb folio and
taking the target page off the buddy allocator. This prevents the drained
PCP lists from being refilled before take_page_off_buddy() runs, making
the page isolation deterministic.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/memory-failure.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7e..b9619d43173b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -172,23 +172,11 @@ static int __page_handle_poison(struct page *page)
 {
 	int ret;
 
-	/*
-	 * zone_pcp_disable() can't be used here. It will
-	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
-	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
-	 * optimization is enabled. This will break current lock dependency
-	 * chain and leads to deadlock.
-	 * Disabling pcp before dissolving the page was a deterministic
-	 * approach because we made sure that those pages cannot end up in any
-	 * PCP list. Draining PCP lists expels those pages to the buddy system,
-	 * but nothing guarantees that those pages do not get back to a PCP
-	 * queue if we need to refill those.
-	 */
+	zone_pcp_disable(page_zone(page));
 	ret = dissolve_free_hugetlb_folio(page_folio(page));
-	if (!ret) {
-		drain_all_pages(page_zone(page));
+	if (!ret)
 		ret = take_page_off_buddy(page);
-	}
+	zone_pcp_enable(page_zone(page));
 
 	return ret;
 }
-- 
2.50.1 (Apple Git-155)


