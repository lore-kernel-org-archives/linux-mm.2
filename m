Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C43C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62E26B0253; Tue, 18 Aug 2026 08:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13246B04A2; Tue, 18 Aug 2026 08:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28E56B04E0; Tue, 18 Aug 2026 08:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B91356B0253
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:49:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50A7240C19
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:46 +0000 (UTC)
X-FDA: 85114371972.07.AB6F5BA
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1065AA0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oqs48NcR;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787057384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wA6o8d+hBviKHNGygSoXC85OkJ9sbBS3QYnjmaygKkA=;
	b=01UbeJibx3pXsEeArc4KXuHJHJkukf7A4w2n+S7wul3kPR2xW1KZzHSRnm+wy6HeXqPiL0
	0Dg2Zh835OifSnvFHuT8C/pl90DJUmH8qX3cLziCgjnaaTbIMiBfz+bJSa/KlWBrIMDeNA
	l4MbvXhjwI2lQ8V7epoBkCAcVjksl8w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oqs48NcR;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787057384;
	b=7Eesq6xn9AyChUZ9BLNugGZ7FEk2GksXHsE6qhhoaJq59VJIMN1rEc+5xJZfZruWeeEQdF
	5obpo/LFKbt+VKsohDWbZazPo/yUeMBfYAnJMUanXgVQQxjH2UW67zeEWj0YQx4d6gh3EM
	XUt07ojRVCy0xSrnSbPC2QVqYEfX+WU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fXiXs/GuwkDQORi9Tljqe5tR50GgCD+UJXW/sn4Xzy8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787057382; v=1; x=1787662182;
 b=oqs48NcR4i1MvXruzYG2DQcZR34+64YOKRBYo17BJPLLYmlKJvNFuDwutMnrVcPNPuEBMLFE
 0gvS71LCxdhKky0CpybXuFCIK8kLZxII+GKCHHAjkBPO26EbTQEYNQI5+AW2+Me+qng9/c3qGcY
 9EgCl8/vgD/nF5wIetEWo9cA=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id c43fdcd8a3688fdf;
	Tue, 18 Aug 2026 12:49:42 +0000
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
Subject: [PATCH mm-unstable v3 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Tue, 18 Aug 2026 20:48:56 +0800
Message-ID: <8488e685f584e23c164e00a761c00c1104474815.1787056208.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787056208.git.zhuhui@kylinos.cn>
References: <cover.1787056208.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1065AA0004
X-Stat-Signature: u76ruyqg6ohdj614ajqjkkn4bydpbg9i
X-Rspam-User: 
X-HE-Tag: 1787057383-904777
X-HE-Meta: U2FsdGVkX1/x/LwhYRYCzcXiLFq3v3KAHolbdEttvAVcW7gznw0WSCHRMycgJH05NZjaQ0d3J+cBUCSuQ+giBqiLJvY7+PH2Rgw/CW99m6BrxQTFINVdumEVX51mDzqYro+Ox3iq/R6RtduXZq0toVQPK1TV1LbWv/j3vTOBpxqgARAcP9ebP8yzAItJzyehlD/W38DzrrfrwY2EC8VMEK1Uk8Gi4eGGYxSKAi4v9VAoqK2HWMD3z2CTEudtHABhreWq5a6bbhMSwFuT1MIIf+EDeEcb7OH8ALbZPd+zQT7ZolO33UJIYnn7WeEo3E08ktUg5XEwGabarKAWdCRVDRzJZ0enq09qgkDEp1BzWvv2MLT8KmsMhXrKBFxY/JWRp32sqtu5fKhp9pXKyVFqtwqVNXTWIphC2JUbcTkAllonCuanoM32GkJCWonS3ipKIOkvnZvVkuLexd/cFfzFGIFrQpGzhciGTpQAy5wdqLDngXNJ0KFd1xnU2BfJvbAY/qYj02jtVysO+uxDAn1S4evUJbq4OkE5Tn0xBseH0F5rLxKmpXDps3nYrkWo5uqqI2N65cOhjThk24Fomp5QnstFgZSE1H00pMhLJriz6Ycd6B6GGx4GmLLJxtiouGmpHkmqdrtN4FzbwqlxQruOmA3KyXXKqPg+y2k7SVnq3805apkRTa5z3IWSJBv9g1wR/2LBG4I+gNJfk1yYmy5PU2NlRQoLtIJoqIXoqMIXE28CelZiHSm2Kcafhpo/MyoqSmUkTzashoP0Eq+YH6DQr+l+lfmvHMiioLtBg6M47UE0xE0SCJybj0ASbgdfj7x4Qt2OE0rQZuPQ1m1MAk1r6OYhZ2gIUxjXON1HkSjnFj4jmriBwQPcRqRiBYcNqmLqgP6K52AiI8r/vmRquEjbKZkIi7Fg4KU8KNY2CPYgEOW0zJhmVVMEf3KnTOLLsZ+7zweasnDv+bvwvaUV9cI
 g9S5LKbf
 W4Robj0XBB/Mcy1W/UZqNZyNeUvfse0HRDh7t7yqM8+xkuZ7nblhket0SKwgSwRHGgrBBUV0VuQfWxUZ8sumvRAcRhTK/PiEga/EUM5zAUG3KTTukOm5NYJ8Hxu2r+0HEKdfNIAFoovU5fOvOHWZ+Lh2ArfDoWZHMiCl3udNqCq7Shll6cornNUs+zk9zDzf1lp3F0Zp6N8fNbkIEg/FbFc6v3fQ4wFjX4H1pFaBXYHArazoRxXHA7clEFLyzV/PHsw0v
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


