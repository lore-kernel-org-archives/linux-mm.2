Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AC6F99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980B26B008A; Thu, 23 Apr 2026 06:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9329D6B008C; Thu, 23 Apr 2026 06:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EC26B0092; Thu, 23 Apr 2026 06:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 767526B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:38:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F643160583
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:38:59 +0000 (UTC)
X-FDA: 84689472798.10.AF8FD61
Received: from smtp186.sjtu.edu.cn (smtp186.sjtu.edu.cn [202.120.2.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id D31A72000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:38:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=NujBjdf2;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf13.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776940737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=guoMfYtjpmamC1Ec9ODblTtPMA07s6o47tveRP/v+5E=;
	b=0htSmE06mR4Nl/OmO1/oRdh6PZey8UB12mFNk0X7AZ6CS8QwfxE6xks+6NdfwZ+H8gMj/n
	mDyAp3s8Rd5nh57d+dB8lkl3uaRF3zo7d2PqMrxBm/c02vyd8jZglW30zoDSYv3c2AtHBX
	c3G5aFc3wNpOEeRB3Yq6Bev8867Iys4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=NujBjdf2;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn;
	spf=pass (imf13.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776940737; a=rsa-sha256;
	cv=none;
	b=EUIxEI2Qb77p2sQJbCwRNEmxa8i0hPXas59tO1PuMp9yuGGhX7adSmTS+uXHEJmYWQmGhH
	mG1wJ7m55m0+StD4WXq1xC3evFKQyQBe7uwTViDsDt1moy5DipF7UKc2s9Hmt/pDiZa1dF
	Z6J/yyl7Dqx/wMYxHB6w6Moa5Nzprzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1776940730;
	bh=WoAUdJzUqsQfgh5VrXLb9IfmlbZi+FOYG3Sa/+HhqJU=;
	h=From:To:Cc:Subject:Date;
	b=NujBjdf2PIB7JhAebhgFkq8k4puxf6qTa1Hb3qohXDMTaQnJBZy71UUZ3u0YdNp+2
	 51O3t86uCae8QBRn6x4nJbaxtAYmLvligv4lQhjogqTxv1spKZkQgE6OpFAIfunVnq
	 le5JKYEYgung8Yz6RfPrLI+4WEc3hFywTuzYhd5Uos9bsaIbuKfrn+951h7YvAA5KF
	 5ephRerTHac5djhFRjz1W24mQe9yozT45CHo2gWO9dvRxfVu2meJ8bDAdPFoGLyWoV
	 297WD0z//86RxG8jnFax663mj1OXkMKfpBcg4Emnvy4NgQ6ThrZYx97Z1fFkvGw0s+
	 EtUDiD6FWeUxA==
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp186.sjtu.edu.cn (Postfix) with ESMTPS id 77D9B2FF4AE;
	Thu, 23 Apr 2026 10:38:50 +0000 (UTC)
Received: from dynamic.ipv6.sjtu.edu.cn (unknown [10.180.122.86])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 1E9C637C8F7;
	Thu, 23 Apr 2026 18:38:50 +0800 (CST)
From: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Subject: [PATCH] mm/vmscan: add balance_pgdat begin/end tracepoints
Date: Thu, 23 Apr 2026 18:37:53 +0800
Message-ID: <20260423103753.546582-1-b.suvonov@sjtu.edu.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D31A72000B
X-Stat-Signature: 99tjpsbk5p6qtmx78p4c6niu6ipxfwsw
X-HE-Tag: 1776940735-659365
X-HE-Meta: U2FsdGVkX1/MytvzLuA4uB9QPc28fvZpeJmvxuZIZzn1WplCBNmhdXrLZtCWM3mfFDVmzZNwHg36KhHKbuDMatU5NNz8cMEu7pyCMHweeW/S3kmzTXvgbgpEp7bezGci7zEQ7AqQGpDwjGgy0Hfw8S2RNHrDRkYwoQX2kXwvTl4Dodcgh0QJtaqY7Ns8W0lMo27sXA6eDPYPoF/c9ReUlXLp6/Tlaj3CWBYSX34diq8mRCgi6v/idWz8BL1Cit/FTK8uHtbldZBcLrrMTf//mhnmzuh0IHhiQegxnxlTieCKc46qYogawAYRq2GJdNC2p0cCjpRAFVKr0QtYdgZOtfa/gLXsybo7DbPThrNYh53YoyWzKpHapv7X765Xk8mDxhHYvTOGpK07T14qYRdkzRlxLz4Uc5RdAeHKoj1IkTGtHkHTYjqm0aRTNjby7bFUcs/do3sPLo+mzOMsrF2Z9ccyLSjo10mJhzGdGc/Bb/CGSumKyiRLrfDegrOdeyDmXdmJm6mfoU+sphybumjwuBQH8oud+rKTDAOcwiF0Jhm/Yli175lCFDwYcV+LpHaCw0LKIZL2ZigaLfMUOGLPX7y2feyMdHS+e9klLavJt9arrUA6EWZPu955QcbS7/zpY2SZsOs8oPm14m3J0S1wdowFnj665Qmq5xecsAzpIZXiN6vKFzo6GMPXAdQzE0YKhYggE8U5zZIKQOMBDcIgBAd3pQ54+ogV/8yPQw+AKUr46mL7Iaq+SIJqg/e6E13TXeiROJC+xukbTbUNy/1WUYyoV9KZAcaAOm2h4PkAhfXnZOdx6lTKt6LmjNN+WzvglXbLsED3fHDpmxT94hkOAr3v1N+PAIc3B7DlS8cwvUVhOybP8Dq2T9v6iAzN51IHs6CNwDWfj/XekjHsSB4+wkk0ES6SfH0dRBip/Ky/FwDzF6Tc2w7xo9glUqlrOE72xNco1qg0gk9FLf5uw3n
 KEXitVqk
 tvf702AvFzG6eIh095TuGVNcTbPzwLXkEzeZVatGnDJs2DIVu+1JEdib+pBAItPEr/mOiCORyQ7S4X9SzbsQQRjyX8G+k2FM5S5Rj18VVVIh0nX9/3DQTeGSos3wDts/LqllYDYcy6xfb3EnBcs+hldlmVk8+fNI6lGPs8b39FQPRx9ZFTZU6Afb9YXMg3W9S0Vhi1eSPxoKohz0T/ih8xY6v1gk48aSrPtqTPTMNafMF9n8suXnv1sfiLTHm4gYbgDw+2Ri1AJtlKJUCZIy92OW0kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vmscan has six main reclaim entry points: try_to_free_pages() for
direct reclaim, try_to_free_mem_cgroup_pages() for memcg reclaim,
mem_cgroup_shrink_node() for memcg soft limit reclaim, node_reclaim()
for node reclaim, shrink_all_memory() for hibernation reclaim, and
balance_pgdat() for kswapd reclaim.

All of them, except for shrink_all_memory() and balance_pgdat(), already
have begin/end tracepoints. This makes it harder to trace which reclaim
path is responsible for memory reclaim activity, because kswapd reclaim
cannot be identified as cleanly as other reclaim entry points, even
though it is the main background reclaim path under memory pressure.
There may be no need to trace shrink_all_memory() as it is primarily
used during hibernation. So this patch adds the missing tracepoint pair
for balance_pgdat().

The begin tracepoint records the node id, requested reclaim order, and
highest_zoneidx. The end tracepoint records the node id, reclaim order
that balance_pgdat() finished with, highest_zoneidx, and nr_reclaimed.
Together, they show the requested reclaim order and zone bound, whether
reclaim fell back to a lower order, and how much reclaim work was done.

Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
---
 include/trace/events/vmscan.h | 52 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  5 ++++
 2 files changed, 57 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index 4445a8d9218d..b4bf7b8def1f 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -96,6 +96,58 @@ TRACE_EVENT(mm_vmscan_kswapd_wake,
 		__entry->order)
 );
 
+TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
+
+	TP_PROTO(int nid, int order, int highest_zoneidx),
+
+	TP_ARGS(nid, order, highest_zoneidx),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(int, highest_zoneidx)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->highest_zoneidx = highest_zoneidx;
+	),
+
+	TP_printk("nid=%d order=%d highest_zoneidx=%-8s",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->highest_zoneidx, ZONE_TYPE))
+);
+
+TRACE_EVENT(mm_vmscan_balance_pgdat_end,
+
+	TP_PROTO(int nid, int order, int highest_zoneidx,
+		 unsigned long nr_reclaimed),
+
+	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(int, highest_zoneidx)
+		__field(unsigned long, nr_reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->highest_zoneidx = highest_zoneidx;
+		__entry->nr_reclaimed = nr_reclaimed;
+	),
+
+	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->highest_zoneidx, ZONE_TYPE),
+		__entry->nr_reclaimed)
+);
+
 TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 	TP_PROTO(int nid, int zid, int order, gfp_t gfp_flags),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..b2d89ed69d22 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7121,6 +7121,8 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		.may_unmap = 1,
 	};
 
+	trace_mm_vmscan_balance_pgdat_begin(pgdat->node_id, order,
+					    highest_zoneidx);
 	set_task_reclaim_state(current, &sc.reclaim_state);
 	psi_memstall_enter(&pflags);
 	__fs_reclaim_acquire(_THIS_IP_);
@@ -7314,6 +7316,9 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
+					  highest_zoneidx, sc.nr_reclaimed);
+
 	/*
 	 * Return the order kswapd stopped reclaiming at as
 	 * prepare_kswapd_sleep() takes it into account. If another caller
-- 
2.53.0


