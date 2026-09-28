Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA080C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D635C6B009D; Mon, 28 Sep 2026 07:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3ABB6B009E; Mon, 28 Sep 2026 07:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C517D6B009F; Mon, 28 Sep 2026 07:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A034E6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:48:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F96A12017A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:48:06 +0000 (UTC)
X-FDA: 85262997372.24.8D3BA3D
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf02.hostedemail.com (Postfix) with ESMTP id 28C168000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:48:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=elYM2Vvg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6pX0duRrCn4P9VhozmS56Or9vQze5T6+PQnMmArHWw=;
	b=5/IupWmyDzXS8wMKCOgtjKLfQZfWJBfV8jYSwebzlHK2Lcv8xfxRoBRIU5fmAOIuarmTM1
	/td6whFnHF/kEb3J2wcVz4ruNvHTkPqZr56aHYG0//gPmhpQXelTfjO59YPYPZrsIi+IkR
	aRDHwmVRmKzB015lBKJvDyHrlHt8Vsw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=elYM2Vvg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596084;
	b=aEstc28bupJ2NunPhZWJWkZWLBq2lS5MgOp1kOTu4om1Ke0XiwKJ9D8qwZRtB80YH/wnrD
	sUtkCZxDuOx2osbWrqnJMrC596+gHUb40Fz7PXSTkHsL1uXNvw6jFSmpas+Umji1DIq5AK
	ei2PxSjMGeijTPQ0I25FHLVMtxknnuY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wh39Lb8B8PZ4mAQMySeGjNr5Tlgc2XnpQJa5hI542jc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596083; v=1; x=1791200883;
 b=elYM2VvgCQStkDbYGUHIc0hifBg8NOp/mA3BexKDxBQiD9YkbrBXCK3A3n0izXT6aEfubkRj
 D3UdTodj2jBlDoHixNa+1Xd70ZhMt3ELMIiDxqVzvAw7CaAtrmkpdHFbcTj+V3jLum8yGhrFhmx
 DANDqMBq0YMcqgpGy8RpTxyo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a68d3de41c786f1a;
	Mon, 28 Sep 2026 11:48:02 +0000
X-Mizu-Trace-ID: a68d3de41c786f1a
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v2 6/7] mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
Date: Mon, 28 Sep 2026 19:46:23 +0800
Message-Id: <20260928114625.3609130-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28C168000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tnikeydqicjgng3fxtnj6ndctnmba9mg
X-HE-Tag: 1790596083-52927
X-HE-Meta: U2FsdGVkX19AEzl7Md3eKk4T8h4Rl9g8FW1AJAon28QVQkvnjrcN7lomqJ9lZM2sTvtAekZu49K7nsZ4qCZaqparoXBACCqH+4A9zUMvL5puFyryb2i2to0LhD4ThjqufGgS3XVscrso2vvhqeUwUyS++8c7JY0UBZRJiwhX5AOtMS0rnAS5zlFwPq0ocMPJpACzNTFmJ+mJnFBsSxe8YpWETYUbYZbaRgSOuyRHSt7fWv9KJl9YlH19I9CUYdZ2hEPsfKb7W6oz/85JIHQ+Zfup4QdAlKEj9C66t5RIfUl3K17lBc9ZeFTNeENmIVg+wVnYBQ3fl5P/fJQItWbsQnTnTPwzkz1AszW0Hyhk9tKW8GEBscgZ1mljYJUvYR4myPqGKc9xHrjWnSBjtSFUvjRfXTxSXq6Xy6J8Mx4pOrfGR1A2KISWsMQoXzXJdDmtTaFN7BmHopfYCbhr3Yd5o897a2CYDaiE4i3YLqZw31z6RJlqnZBSGBRqUoCyYUGTxdeK7oYjw2F96OJ15ur2KaPq51Ja5gt5+dzJP0L5ZonVTZ6Z1QCP3Oj7O8PFW4kqaKztsXhExAkSkhX5VKYs2m911+UNS1a1CrrbGtEj7igGyWAz1xF9W82IBIu3Hn7n8p68pcqeYIX8fxfUyF7uDaQTmKsf5kf4E+ICr1+TdMrMVz4B/K3aT9wqW5LTWlLJjz+unkye0xE9ruUUMmDmH9Z60B7ECK2ZJy1ZRPZofTvbsD1v65OHLWCUAsJ6ZyUWcyrusmpyIRcWxebQEO1NZCRM5HfjcT0EIwa/IAChb/7xuztd+SlvO5AtlJn1TBptDkfOix2dRmtE5VEwTHmV1GjVNEM8RCY7iU6PhV5K+MORWIMIs9eivohZoZL1rtL/m6mCk0szdiCzQ1SQheEeN6Ex/9qZlzKR6KLPVDgxpgCjB6UftxuZqRY3Iw/cPHzSRn8/Mk7aqHaL0mjWkee
 u+Uh+cnA
 iD+kdnoWz0OMrn0DSHzo7LVf1EVhsxjOucRuOZg0OEwDfmJ3VLcRUMdDMKDlxy30VdGW1uUeq2v1R3fNnd3fV+KjEg5wrWlIK18NvppLWy3z5qTscQzIv4xxBOS9c9gbZn7KNpZKMCeHUKxwizhdXhhkypcQsWx7av7XtAC4/1iMoLNoBs7cT2lGTEox2JInL8l0ScZwZvDTci7X6Flvjvf+NiQM9TK+01wswDUti/vVhIL3A5LPG4tANBMSM6Cf2hG4+rHFxGsOawJO1H4WculxV9eNM6ydM7mwIkG7W9qzHgl9+0OXyPZbNaqKiEWZrf8oH2BveM9w3nVO+inXeNy1UWsYpcUTA3eBlvb/4mRh8HhUK2gM0YkYc7RyrNV7gas9L08Ga1qe/LLm79nDRE72Ohe68BvkHSnBHqbc7QAp29FB4wu8JD8I8sj5yA58PUgZunUW/8ikBnoaiVgDVbcA0IJvBcALLHEqyqO/JXkgaq9zyHw/03hRiJgTOsS3PU7rkjm78QOF0YKNwGcsuhdITkBWJPLapHtlRR0VjrrkVzH5GhDodpBRdrx0ufYOPb/PYU3cuu/Heukqx6WjmjYKZh1GpLd7eOkt9OrVE49HNDyyDrjPrt8e7RDLDnQzGEOMUP/1YeoQi8vogRMYMpV5rYwGVeI/qBm3+W007iBrvv93PdH2CensFio+IEeMd3BOynCVd8YJGwxZm3Xyu8yi7fC+SbBJelpOxN7zBOn18BZvzJugWyiWkCUwOZFJuaIqofHIM6KTHMhNP5NN07miIj8wa8Hdx+od7464/Us7RwTAQvfzUeqRan5pA0LG7eJMgP5rWg+KfJhz2Yohq2CkHFQZATGdyT69Pwdr6GWDxBQXBaWsaSiz1p4iMfhuxonZKgentQgpw7ORKacfHPY8odM7J5EkvaTTRfjElB5PzxTuI6KQFBbsBaJ5M3LqhrmgO0bBFU7Te4oC7q74ssoqww0FP
 b4EZRc3t
 w9FJhcT9ChT2+DU1YQyyS/sf7DwX94nn+EwzdK4XVxEA80ai5vgE8Sr9mCoJnPdIFYJIGZAsCmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

reclaim_folio_list() passes sc.nr_scanned to mm_vmscan_reclaim_pages as
a bare argument. Pass the enclosing struct scan_control instead and read
nr_scanned out in TP_fast_assign, consistent with the other reclaim
tracepoints. nr_reclaimed stays a separate argument as it is the return
value of shrink_folio_list() rather than a scan_control field.

The exported event format is unchanged.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 10 +++++-----
 mm/vmscan.c       |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 9b4a86fff37c..04f285e77659 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -418,11 +418,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
 
-	TP_PROTO(int nid,
-		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat),
+	TP_PROTO(int nid, struct scan_control *sc,
+		 unsigned long nr_reclaimed,
+		  struct reclaim_stat *stat),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
+	TP_ARGS(nid, sc, nr_reclaimed, stat),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -440,7 +440,7 @@ TRACE_EVENT(mm_vmscan_reclaim_pages,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->nr_scanned = nr_scanned;
+		__entry->nr_scanned = sc->nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
 		__entry->nr_dirty = stat->nr_dirty;
 		__entry->nr_writeback = stat->nr_writeback;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 030f14740cbc..6ec84390ee2a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2183,7 +2183,7 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
-- 
2.34.1


