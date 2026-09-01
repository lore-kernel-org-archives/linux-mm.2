Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90BDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74BA6B0101; Tue,  1 Sep 2026 05:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06326B0102; Tue,  1 Sep 2026 05:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13B36B0103; Tue,  1 Sep 2026 05:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B24956B0101
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:13:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C2001A02B7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:02 +0000 (UTC)
X-FDA: 85164629004.01.82D7223
Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	by imf20.hostedemail.com (Postfix) with ESMTP id 333941C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:12:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=irU2sJO9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZhgMMAx9AT70H0W1kmDjsQfIKT7wc1OtXlOqMfwxLg=;
	b=ietCfIIc0oXmdenIRnRr1z0/mqj/nMGrbCv518HK9D5Qu5gUv0PNeDOJQMxHOBFSNDiGzm
	m7l09HcFvsO8vX98OHkfJihfeXnjjfLhnv/Zk3Z3mNxQKZvHxBVjPsyD0r6nNPkMU8ZNAf
	IwQI2hRQyxGh8F2wwheiyMln08Za4Kk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=irU2sJO9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.6 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253980;
	b=DDCaWjVn0kS0RSpuKhTcoKF03D2Ln7uQTjv8+8Q5ZohSL8T4dSXRlrrLwCtVhweiqS8Sl+
	A/WTKYVzPQbB9ZEnD6FOVYLW28yHzqyIDf+uFfqIdJoDtvggqXMvqqILENRLm/4885TKiT
	CH0KYwSODklUPcbQKr7Cs/Xr0LeBKg4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kaupwl2CerM+wcHSCXXaFwLigAE3E8c74QApBbEU49A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788253978; v=1; x=1788858778;
 b=irU2sJO9q4WUJoILGuRTchvv90VDGfFzrX7swFprOZS1WtztcdnKaSoZVz/BNamTFcR8oQdd
 Sb6IEq9iJkws2UFE5KgXWKdaDwItzXwWCn1zAAoWIjiy9hxR82tLy8OmGyvn35qdm8N8/DGQCib
 YeyCuuGdmZX9TgfQ60U62DZc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b5c480e00ff4c702;
	Tue, 01 Sep 2026 09:12:58 +0000
X-Mizu-Trace-ID: b5c480e00ff4c702
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v5 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Tue,  1 Sep 2026 17:12:18 +0800
Message-ID: <65cf410fc9e281bc1de00e938522e5140eb49499.1788252038.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788252038.git.zhuhui@kylinos.cn>
References: <cover.1788252038.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fj6qdcqthcy7ghuzft8qk5agh93nxuoh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 333941C0002
X-Rspam-User: 
X-HE-Tag: 1788253979-658335
X-HE-Meta: U2FsdGVkX1/kKvSy6jXoMeoqP2+yOPjdxtSrJkg/MZrHczozrMy3D1AmYaZ8AbV0yp2oJzKhlMAsVvkPlUUQgqRjebZEXS3ENGfRR73UieKZNn2EZVhIX2GPkGBjv+WhN9dS+YAjt4Y+PYhrbK1PHU990/mrWU/d3jUp+Nr3d0g40eYFk7+NVFrcqWfI7TiPtzzLq8HtVasKeLYyh9gl1BA0Fru3R6P/g3aJof3t0Exvi2/22Bn0/7haz9k0cy3HURZn0qdgPOaBPaw4QH5V4E3i1XhTQZC+mmjpiXFtYOXS+lD/XueL9ZAoGvbguNM7G/Mu4S5Vbp0lGvV4i+PLyxefkDNFvuWBUXFUMiij0XFQunQOCmW9AOXXPsQ4s4BAeFpwqPvYjorPmH+79scRUj0NQz5JA7RrKu2zWt33EIgzWOd3iy9u6brK6HHkLrvVclKwNZEL7Ks2tA3ppCaLFbcnM6HDvmD9QWOo5ZO97hjK7iQyuMcX/tLun5doXharc47cqQzEhNJno29uK6vk0xntjot/QvHYdPU+3U4rpXiimMgAbffAgphWFEkoGF1lkVcEkkCatrZeffzrynYarc5Dn0OluMWPVkX78PSIgHGwONI6m/5HVFc5k+RCtgPEPZU6NIIrCpD7BG7Zh4fUhF+qCoYg9P6/XewNuVWbPKoJly5HJj/jjKiyhQdR5SqI2BETiTFjmg0Okmtn3+YibDGzqEKAwJRF8HkaJpiFyoHrmWntRALYCmBweqboAw9dDaw09qPYl03C/iJqTm9TjAgxFKx45FSMhYALosc7mwljosm4XWKU5wwQ9/V5rojBfimeVY27TtRrdco7nQeMt5Gs9Kf+FSEIrAq37uqRfEeewhbt0gaV3bfzMHIFHpMi3qxhHtL+l3MzDcO+Yr0g4iNjqIdfcU3LibwBe2YmElUOtCtkT5JcT8iMJr0XM6in3Gcm8KSrSpF9PnWge4z
 oWZD2Te/
 TNFnrvj7AQ9cTPwaIEPqipLhxLUesWVBmhQ4+28bxYatpp/F2PKklY2HYh1xm7XN6FRkAjAq8Q+pt6zEJX/9OANZBlEgu6GVibLKloMcpYUNvlio6M2D3pvfOIVqhZJIDykzqTWP/AppAmolDpzGz5Ov0VrwUboRyW5ELbxnIh4Hv7Hw2YYOd/fgaI+G6kYyIk2/sSx0ONaVGawWOuDrHhcK2lLdDt3Il7PJi3LTOuMpxoro8B0PjySrnfEK4kK0bw/W15AzGZJ4myjhf2H+2yVAbSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

MGLRU evict_folios() isolates folios from the LRU without updating
the NR_ISOLATED_ANON/FILE counters, unlike the legacy
shrink_inactive_list() path. This causes compaction's
too_many_isolated() check to under-count isolated pages when MGLRU
reclaim is active.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using
the existing nr_isolated which holds the original isolated count.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..98226bb021f3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4892,6 +4892,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4954,6 +4957,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
-- 
2.53.0


