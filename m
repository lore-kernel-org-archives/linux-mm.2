Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C68C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71D16B015D; Tue,  1 Sep 2026 07:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22C56B015E; Tue,  1 Sep 2026 07:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38006B015F; Tue,  1 Sep 2026 07:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82E5B6B015D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:51:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9825FC03C7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:51:17 +0000 (UTC)
X-FDA: 85165027794.12.00F79AD
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id BECC3A0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:51:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Lt9Rizz8;
	spf=pass (imf25.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788263474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i4x01+8pMMr7AxtHEkb51u5y7+XhfvZZkj342fN2Bd8=;
	b=LmYSzuwKGifJOS12p7f2kk2ragvUHu5QEcAcjsQEPbp3dnu6bQT8ohQRB+cYgvr7JtG43r
	xhjrIa9rpYqHXJ1fnLUFC4O0/TsgrVzYnh6G57PRI3J5Cu1U7lIriVgIld6ngfg7iSxpjb
	1dkWrpPU2oa5AVLXcdtwk+Y0MjQvnkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788263474;
	b=TFaIRNvlGaf/HFSn0CeCxTNxp3BO2c8jWGa9QFvj30IugobDAYJBVJ7QrjlmsZvJHJxMTF
	LKb8gkodI0vSlelDzXrRBF//NskO2pxGHlNyYuCBwLE5NlZWklISndNDHDcm//kS8i6Ur9
	o8RQhRG8+Utt2DZ0vJys8tS/P1X725k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Lt9Rizz8;
	spf=pass (imf25.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788263467; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=i4x01+8pMMr7AxtHEkb51u5y7+XhfvZZkj342fN2Bd8=;
	b=Lt9Rizz86mkxC5AsMW6sFyutVq1d1Ue2uvC9kl1bSmJzbAUjp+y6SSeVfH21vGs/IFNNY/PEJIMQbhi3QsAs1pVA3tfmR6cUlLGc2D8b0odSpCkJ8TcVongEmEInPiwKXVZOESIwM8K6KsgS7SWaA5PPeXaM1iHua/r01TT7MUE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XA7QMBx_1788263465;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XA7QMBx_1788263465 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 19:51:06 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH] mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers
Date: Tue,  1 Sep 2026 19:51:04 +0800
Message-ID: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kfs8f7hy5jfetxjhmu4mnaghobrqx1wy
X-Rspamd-Queue-Id: BECC3A0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788263473-674633
X-HE-Meta: U2FsdGVkX1+ILqWISg6dBVpSG2Dv92VX8Ew3G6BfMLRQbJ7KvdhFNfgVTDU9DYXQnE1T3+lvcoAUrsi3NFBhFS7lkW1lGNMJw9TxeDBZ2bSlqGIkbpy/VHaXaupjB/wpFP+gcYGIhNReJfPR7uvvEYv0NI2XCFFNrL8ljPRdyAlewiW95fWYPWitKo7B/5E5oG1hEBHty0gW5+LBsbHCdv1I8XTln68MZM6IOm3hEH3ftK4Bi5ekJ9r5p0K45JzCjQ6ZG/pE48Y8tkfVTrCan+M7bK8A5UHdsW9uE7aRqGmgO6WaMKlP+vw+HKaAWvEugvJMP0k21DKaGZdBgvAHGSFn9gWvFI9lp0u3thMzcOk52rhe3Ttz89fEfknNjVvqPfthXYHEDqU5WiCTJrAvChpUivjBb3TYRUbdKSjb6Bh5xM/SJS5d/Fyn9Q5xSly6UjzrY8LmhJo5C1oqI01X+cBnT2synSQtQFaDkvsLcJGjNVcx/S4gnHS0ryB9CPovYqfhiVmrEJ/LCw9ZBb0zleO+b0X9qIw6om8nzK4BWGBMAAwvq4Cm1i5jkePfF9U2WsAbk9InVigTZnPOAYyvLGs0jp2dNI3z3JW6u9heBdxov/9DhSggqKfWRde//pn8Z1m0z5sutaCZ167I5Sa9IvtS1LkLRB6w96tO4GqFuQoXOmqGQYrIAPDXZakmZfc7Ju+FRtD1IC7XkY83nNJzAihVxFr8bocgr8qaiGmy4cPb7FKPwko1d6bF4j/3wGD7SyFGq/sQP6YVHEKggkfItRA5HVK4b4gtDhjXngGf80h/yEpya5JxNq/5iPD6wAV11jN/qE4k79VZaBJC3RzVkaKB71jnaPWDdBpMRQbXZMHzAQWPOH1yGyspKsBcArTwonqfOXxshPRpAskg8NR4/89tZbRCzypVOOZ+yS2/w1qtLE2GbGgH2SBeNA541k9Z+kHumX95TzuzxmghNaM
 NFkRW4Lc
 2CMT8ZLGLVm32iIPFEntfSQjhBMqwfhetZXwBdgwe2HWfzIKWqJwOaBy1zxLSalWX0VLkPXXHE8Cu6bwXwIEJq0L5qPpecanOfvwq7qn5S+i8MCI3FFu1KGnYYKpPzFfAAAM+konYYic67+CiQRNtzEEBT5VViu9gTRdGqtVRbs8Evih2Ruc0Eklu/Dwy/z8lWnjBX+ERaS14qo0VuegB0bzf70cAhZ381OGobZjIqDd10LcD5PJhARLMooG8t4IpXtva+IJXR458MGWcIkFzy1frskeFY8OFP8OO2UTC5WhHqSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With cgroup.memory=nokmem, shrinker_memcg_alloc() fails with -ENOSYS
for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
back to a non-memcg-aware shrinker.  On this fallback path,
shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
valid id belonging to whichever memcg-aware shrinker registers first.

__list_lru_init() copies shrinker->id unconditionally, so every
list_lru backed by such a fallback shrinker (thp-deferred_split,
zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
up with lru->shrinker_id == 0 instead of -1.

Under nokmem the list_lru collapses to the shared per-node lists, but
__list_lru_add() still calls set_shrinker_bit() against the memcg of
the added object.  Most list_lru users are unaffected because their
objects resolve to a NULL memcg without kmem accounting, but the THP
deferred split queue holds user folios, which are charged regardless
of nokmem.  Since no memcg-aware shrinker can register under nokmem,
shrinker_nr_max stays 0 and every memcg's shrinker_info has
map_nr_max == 0, so the first folio added by khugepaged triggers on
every boot:

  WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0

On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
and expand the maps, there is no warning; instead bit 0 is set
spuriously for an unrelated shrinker.

shrinker->id is only meaningful while SHRINKER_MEMCG_AWARE is set,
and all readers inside mm/shrinker.c already check the flag before
using the id.  Make __list_lru_init() do the same and fall back to -1,
so set_shrinker_bit() is never reached with a bogus id.  The stale
shrinker->id itself is left as is; cleaning that up is a separate
topic.

Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---

Verified on a machine booting with cgroup.memory=nokmem and
CONFIG_TRANSPARENT_HUGEPAGE=y: the warning fires once per boot from
khugepaged, disappears when nokmem is removed from the command line,
and no longer triggers with this fix applied and nokmem set.

 mm/list_lru.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..96d02ea206a88 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -666,7 +666,12 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	int i;
 
 #ifdef CONFIG_MEMCG
-	if (shrinker)
+	/*
+	 * If the shrinker fell back to being non-memcg-aware (e.g. with
+	 * cgroup.memory=nokmem), its id was never assigned and holds a
+	 * stale 0. Don't let set_shrinker_bit() act on it.
+	 */
+	if (shrinker && (shrinker->flags & SHRINKER_MEMCG_AWARE))
 		lru->shrinker_id = shrinker->id;
 	else
 		lru->shrinker_id = -1;
-- 
2.43.7


