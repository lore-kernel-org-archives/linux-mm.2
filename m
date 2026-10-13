Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF37CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A303C6B009F; Tue, 13 Oct 2026 09:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A088A6B00A0; Tue, 13 Oct 2026 09:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944F06B00A1; Tue, 13 Oct 2026 09:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 764916B009F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B4E5120A32
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:58 +0000 (UTC)
X-FDA: 85317648276.07.B06517C
Received: from mta1.migadu.com (out-219.mta1.migadu.com [95.215.58.219])
	by imf30.hostedemail.com (Postfix) with ESMTP id ECA1F8000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WsU6N/hc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLXzjvxcD9/EilXhK4jHrL6cayflPGxzf+ZkJwMpjEg=;
	b=xydJlhuvM/3/gLqKxZ2NnOWaCTKFLDmLTKDkcgDPSdZCv8Y8ZJ2GHh4zDAKjVPv9zN7Rqr
	z0MVRkcdj6p2raBOcGnOSOBtGj4oL03KpVGXSN0kEMDoSzSXCqvWvRnPIi6ctFWJhZbYw4
	YW8IW0qdFtF5mYjUB2Bp0hl8CMRgI4A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WsU6N/hc";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.219 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897296;
	b=Hn/yq3tulx+mEFDsyb1NIbqnV52jt/qO+UCado7YrNzeF7tR9aj5BVwzKato8sHQrd+u+y
	ejPQW/l47c9rPY/jolSt/Bxsi9dAlV0FkY2Vv+RoW75O/59196OK7n8uAHK1QsEddlwkt6
	6bdKXiulqY4BNeojJFxhgWkRCDNOxXo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vBSg1QkKVy4BttTL6yPnGCNW6hVkILXIMHPxGW5nELA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897294; v=1; x=1792502094;
 b=WsU6N/hc2sC7uwnFSTAPvEc2meOej7IlBokFEtkZr0E2eZ9tAXGEGKLM7D+PiTfg5qRWzAHV
 FFyeQmYXM/uH7Dau5BMnp4q1jrcfcho5U+eg5Iwk1HS0rsdIsup8sa9lTkDGySG7l9AdnAiNb/O
 oTUKe8GoFXySefMAgnJ/q9Vc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 208741b0836346c2;
	Tue, 13 Oct 2026 13:14:54 +0000
X-Mizu-Trace-ID: 208741b0836346c2
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
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 7/7] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
Date: Tue, 13 Oct 2026 21:13:09 +0800
Message-Id: <20261013131309.2790253-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z3egkqrq6ianwonfzr35sj7y5kmgm5y6
X-Rspam-User: 
X-Rspamd-Queue-Id: ECA1F8000F
X-Rspamd-Server: rspam08
X-HE-Tag: 1791897295-437830
X-HE-Meta: U2FsdGVkX18t3GOIvjFNrtQCQcRsfja6ZHLWN3nYLcJAr93ME2HfgFat/hLeOPg+0pF8VslCGdtXe9jYirMxAUlQucO7EBl4FGcbEOq+sopP/pdnry51539yFUb25sjk3teEFeXeesqNXrUGlpg08X+5CLUrtoSAMH5S6IFB3IGpmcmW6rs14YHiTzOQe5qJZvFjmT2cGAvU2TF8ZjKQnShjGFBog63k2z6ykR09cdFwLIDbJMwnBM+W+G+MDkl/m93VD5LgzlUxadvanHHOxk7yudh21+Nj/nlI/y6yIkCYEI3bf3RCZiKZgbraU1IBjU/hdfA6H9rPz8XnPG+AKTcFcNZjf/+o9LOIdMfloqyQqTgGkmV+tWONzjqEYapcNdAj4iRLeb3YDOC0o7JDPDWH797uxOPVLd9JR7JHh5XsojGmw4o7Z/cy2bDGWTu+Xv8DSq8yNq0zQxuCC71/wu6AdJN/XXcfetxBmdpkfx/czMugZg7Zg0V20hQnXjBoWF3AKnz0olKudTvkMKYcGEH4oH6nHy5809FfnhgbYAoLvaj//tPPVNTCj9u/U/cbl1rr3UboqnNoUKBC/L6KFWILB7AmGHT2KPLEa8kd4rN+6ZG6R5+0Sm4QeTuwt8mMBURtQlexNHlJhCUn5uGP1wJOKWyEEuOWOGtV8A2AKKsDDGkK2GzFQGgcNaOTYxHH4+nD9Y+0A+RDbYWsGG8DCx4cw5q6kxhMZOhIUTySEKmVH9t7cSIepnYSp8ZDWgy2M8YIZqr5g31yvRx8bpJiik3hXzeSRICbYcv7wbWOyeDwh75JdoaS2Iruyd+Q7rsVIg9toNPNSZrmcVp0/WZ8LjYWFhXLcVOHX89ZdpJn51JBTQ/WV6l9SogwrTk28xJaA8bOI+0jZe4eTJSKdXEfpdcN/LSby2u/0X6VAIt57Zcqk2sMdrFWQb8aS6qW/Grg5SxkULq9LfCEwhQoNyE
 cAxitNS1
 t2jnm5hWy8psAowZGNdJ7cSXNxCLfsyTQonQS6d56yBw+q9omjtWwnSrV+vRYkXUA5I3e8/CqlV07zBsfzcVe60nvhpsPDvbsuSMS+zG9Y5iX9QwAZHeftxgHbmGpr38VHXpOXgNOVd7mWx9CQwx1M87ZVR/u4v4F9RHdjOLl0TS8nKgwEx0RoOarC9lAZYfmmCIDXvK+jJ0HCwzwFwlVrstdA/XaYvzE1V7UHSRSrQbTBIH730/wnYQslQJqmvFxVDg8YODaOtzeFZrGH8FxaDXVGOVQeNTbpV0OAaUnyzjFr4lnfAZxfOMrqHxYV0Rt8zFQgjz3vbzIHUFYsXePKFEV67nmH//kJMC5n03ISBboIU+74leXqr2t5SwVrEOU/Wcvd0QDPcIqkEScsgS89LY0x9joAGxJQdtXA7UKnxjS8Qn/vphspNPQXHoWCmT9FoFCoiKD2Vv9g7ChO8q7nW9cF7U7wjXPHKhxg2b+WptDcVwdeHRf+Fl0sVyRDAz2wJce0rlC1/njSmjkei2mR6qTar2yrwypTQrOsahQNqt7Uoj2X2pUmEpb7yTg5zntKH9M8a35ie8dvZ/hlS7hjO17E2KwkshjYSoCOpbjVa0OizT3kNzyOhC08Uc+akUrRM5Uifl+QP0Ea3Fw1ZFpp/+RvV7hXYRO/DiLf5GEOEE6ckAp61oeTWgWsVMuGJBTW8DESpa1W1RC0elHbdn5REJjhZh5LF+Ng7GgPZzsl+lFnyQKxitQuiYbk1i4iSnuj/9tMZkt4STChz7tDjrdWwFMAm8RQLheM7hweHAkkIs4SV4JRrRhkL8ug0oc/ZAmr/tcCbgy3dG7MeBNj/49yeA50qtm9xZfF8abQG9GuyAwoTswoDFZHEFZTBNX4O6xnymuwuw275gqMhADlcKKUpJueeJzG1DtFqVroHUs/MGAXn8p/AD5zTpl3IMY4D7AoKoNqDLOHNtMtcxEiLUq7jWbfAXo
 6m/SIJWb
 mFhZAGx8daHYEAEkTwtS6ZvogjCkCN5chVMG2Y5Y/eUHJbsrV1zdecY35EC7ug4yH17y/AWiBao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

balance_pgdat() passes sc.order and sc.nr_reclaimed to
mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
struct scan_control instead and read the fields out in TP_fast_assign,
consistent with the other reclaim tracepoints. highest_zoneidx stays a
separate argument: it is a balance_pgdat() parameter, and
sc.reclaim_idx may differ from it by the time the end event fires.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 9 ++++-----
 mm/vmscan.c       | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 96e41f444924..10b3cda1c435 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -124,10 +124,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
 
 TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
-	TP_PROTO(int nid, int order, int highest_zoneidx,
-		 unsigned long nr_reclaimed),
+	TP_PROTO(int nid, struct scan_control *sc, int highest_zoneidx),
 
-	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+	TP_ARGS(nid, sc, highest_zoneidx),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -138,9 +137,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
+		__entry->order = sc->order;
 		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_reclaimed = sc->nr_reclaimed;
 	),
 
 	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3278dbe47bf..561e14dd490c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7403,8 +7403,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
-	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
-					  highest_zoneidx, sc.nr_reclaimed);
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
 
 	/*
 	 * Return the order kswapd stopped reclaiming at as
-- 
2.34.1


