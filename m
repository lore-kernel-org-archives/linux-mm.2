Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE703FDEE35
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D5A6B0095; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74AD6B0096; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A366B009E; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7A8A6B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C38B40349
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
X-FDA: 84690542874.01.A9AE55E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6AFEE1C000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUOO4XIh;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yo83BgfRNp/k6toFVh8JLOIp1keKI6rhz+lUaieWJTk=;
	b=TYwhgk+d3YiMICBiQo4gnJD3Ht0G67GnpsJsYRSXvKzhiJmKsGBnHCbLzX9MgBRwt/4h2T
	bIbWN2u3vXyG9bK2upuorr5r+7KkMhCUQDw+t+SDyeZ6OW+ggmONj+5mhgVWm8yQiZSAQJ
	0MRrQgGyDVQZmjLxXvye0trQxqgCgKY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUOO4XIh;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966215; a=rsa-sha256;
	cv=none;
	b=4189Z6o6epBuQvQHprDVVaNMsPSgX0VAgeNDy0NMxDpatqgPjKJPCsyXuBM28V4a9BFG6I
	ZV7FuWLzb7VlDL8I0H2376/F7q6EAbtxRQbIbGdd+9mVRr85UKHGSmH0uKrhqS0b7rMtyc
	mHnpsMIMKgCIOs+lNbjGmkpOOglivGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F06C44751;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9896C2BCC4;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966212;
	bh=dGjQUlbv1Cn058kOoUOjP+FNqLWNmkWZScyLP4htwAA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eUOO4XIhJW9VvmZVdnTAuOqW2+lBOfkhqHckOacrzons8lqlViUD56KhGAXt4W/sv
	 zHjyjYD36U3liOMlavRvPtKuekNxW4/u5HAVhWzN/dlWL8l5BPxQ1K3UZMTresQQ+N
	 7XlcETn92AfyCV75hi6rsSzarY5h2OQ8WTXbsDlZZ3F7hJdR6x/LV0R6X3vpzsWuMv
	 xHmL0Bfamom4wMFsGTMmD8McFaVMs40rK328sL11fvJ6Xi8tbvwu84PpIv2Cqo7AV6
	 NzxSf+goMGvcsDfx6xZI1YzXriG6sFuXG4t9BJmXHwxxozVdmAxsL59VWvBY8QK3s3
	 xy0OtkeH3nVoA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA93FDEE33;
	Thu, 23 Apr 2026 17:43:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:20 +0800
Subject: [PATCH v6 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-9-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=3248;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7k2CuT+9M2FqGXa3ZySKsRX9m55VQUz1CgD9CNT+STo=;
 b=e/0nGIlQGEkN6o/HRZO9n+5h03rf9bHKDu79HVK6nCYp4pGnYmPaCq6k/aQjhVK8Aw5NPQkMJ
 zSzZha2E9UhDciN1F3iY4n+z7KodZliU0miGrxSPt64XWXCf/TcS1U8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: mzcdngyyc63b6r4bqgnwin9w7pdaygm1
X-Rspamd-Queue-Id: 6AFEE1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776966215-51834
X-HE-Meta: U2FsdGVkX1/17gG4z0Sk+o6k/PcuM2svzfGDX7CjN5OT89HpZmJk2JONPb4jgRhlCjnAg1grke6E0gS6+T53k2G6jwW+eU2CR00w/u1HM6AXn8cec0CU0lTRX/vatsEJ2Y+YBHWJJanCa92C34hsPqL8wsdeUWCRs8tqWefTue3Tb4o9gRZ0oXq+gqie8TLMpU68eUeYVJx18HSn5yc/e+cVxzwqI/6PK+63IbzN6wEbYLyvylEkLq4NyYqKdz0AdOp0U3nD81YYQ/dNIC2xQLijvPFexhopGlZqIJEHx+aFoC3LJVTEcdlTY/X5JwKslgbkT0WSXLq/OoeBoxVxjdvXjuAQ9A9NoWaKkxMZGr3Q6zv3HQ6QExzKFtthkip5qGt/jzbZkOmiHnWT04ipwvcp1iAjB7/r3awsBm+dEntfajRCj5pyIcxwdjsdLzGAbLc37THrwji3UdLMEXGf5WEKNv6XmYSf6FZcQcJ7madUDbPwpMXvztXezqi1u7K0qYECiZZ0PIT2pWFICBTPdciten8/WZbhfPfX9X1WuZ0jdcbkPXCMs9Ell715gVktRQ+fjnnFFsnuJM9idSoEgNmXhC3Dk8LmPAMCxBppQsJziNd4Sd5YC4xNYjUvAiQld+ALKFI8a4o55spraKjE1YaUCjtYCDutoL5GtkyZk0BkXr1riStjq8opFFGB1oL22ylhvi0eVAP0mgJ8EfuY6HxLjRe+rFjs8V/l2dMaBzISSB6puedmhgS71CTD+J3epgdczXmw9yPWEANFsvHfcO6Y/vXaLGDBAxgfJROvYWSt65fk1m30S1n5z4ySucd26EYDwE480vKtQsNvXPhOBauyQE32jUMTUnGTuLHV62g7oZSKjwmAadpxVAEZml5YbcxVy4ITEQf/8C2WOPo+zsQUtyDZPgnheF58GQ2xYAcxAhO0cB+wRdw5cHrXN+PJR/mzsjihpz17F9jyl/0
 0VF+5Qdv
 C0pJ5Yr+5i/p9YplXghh7ns09Vo905cHeLG+rZIeWn6ODCXda4ziAVrlDOVF75fFJcpUUmnaZvFw7d8t1DU+90w0ezwJYZgMUC/v3cSgDG0ALgBV9tUanpuzpacw+XpN0dSKjZmJu48FgoeImBNgGFDCLM3dVWVfA7aWu4zqR21XKC5fScRByIqXswi1ppLLoDylq7a56+0k+4InNW3/+H5NHx+7f1VHeLye0+H2mdnavnhX9hv0L+ZLGBW4I3gFSRF/DoiH+/I11bFn51nbmvHWLq99EWEu0Ix0tKCReRHCxioErm7F842H1wLQczw6zRa5wIUlrrxNtLjoJp0IDUmq+eyb7gK/T7uFfOCzeqv1wKeRK/1cP5McN2WBmC0Z7DQOjg0DU3a3V5m3vFRW6ojs5qrBi555U4rcNfohulf8bbsh3VkYxCTTDRrLTO0YDRLMpd9IYwxWi2cP+aqSIol+pvdZVhgnzZFzqhvmzifwEUsOoNKOgeMN4QZokB7D3s/PA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently MGLRU will move the dirty writeback folios to the second
oldest gen instead of reactivate them like the classical LRU. This
might help to reduce the LRU contention as it skipped the isolation.
But as a result we will see these folios at the LRU tail more frequently
leading to inefficient reclaim.

Besides, the dirty / writeback check after isolation in
shrink_folio_list is more accurate and covers more cases. So instead,
just drop the special handling for dirty writeback, use the common
routine and re-activate it like the classical LRU.

This should in theory improve the scan efficiency. These folios will be
rotated back to LRU tail once writeback is done so there is no risk of
hotness inversion. And now each reclaim loop will have a higher
success rate. This also prepares for unifying the writeback and
throttling mechanism with classical LRU, we keep these folios far from
tail so detecting the tail batch will have a similar pattern with
classical LRU.

The micro optimization that avoids LRU contention by skipping the
isolation is gone, which should be fine. Compared to IO and writeback
cost, the isolation overhead is trivial.

And using the common routine also keeps the folio's referenced bits
(tier bits), which could improve metrics in the long term. Also no
more need to clean reclaim bit as the common routine will make use
of it.

Note the common routine updates a few throttling and writeback counters,
which are not used, and never have been for the MGLRU case. We will
start making use of these in later commits.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35e3352a53e3..74255efc4ad9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4578,7 +4578,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4628,21 +4627,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4664,9 +4648,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 

-- 
2.54.0



