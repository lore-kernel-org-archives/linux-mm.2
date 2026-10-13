Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB744CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7406B009D; Tue, 13 Oct 2026 09:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8EE46B009E; Tue, 13 Oct 2026 09:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5BB6B009F; Tue, 13 Oct 2026 09:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 837A06B009D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14F5780BA7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:48 +0000 (UTC)
X-FDA: 85317647856.11.022CEBE
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0979218000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UStBtHps;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjixcbED3ts0uuKv90viwUqQi3IeZsIPKkcIyXiKrxk=;
	b=Ej4ZwngekMCCpD3+GtjYyOU1bIfuilDLZb8Z319/kmin6yMPpNZkPIngnw/aO+Zm0vGXds
	OtUfxmG06TrGtnIRyCsILxyJ8KOyA+fC6xTwnDceN1z72ssSZji5sO4E8O10nOAPFM+wjf
	sx92CYbOkOfJ7KXCiakGzu3ibsoqVuE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UStBtHps;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897286;
	b=6hvVtwmJ5BJojgEVgIJeZ88NSZmpOA7yqj7WN5IzN3pMi7SjFge6/NVSRsS5uMsFw2R3Qp
	lXUFV4VMhdRE83Gpq8sdtk66c8eTB2yk2wUTcZGwfnQSWWU9JC/KyxMQFT/zPcwsLUsBeJ
	CGwRVGcKx8NeLsxfx1Z4oXt/0eVnVR4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FCVJ8SXRn0tZTV1HcFTggppi9Q6Q0r80nrilbAeBeVA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897284; v=1; x=1792502084;
 b=UStBtHpsdd2Kv0cnXCGfhWCETymyo4u4Aq8qZt6K4HIkh1dnOns7Kc6IlDY17p7F3ClQ7RPd
 xvfqnzzeb2/IhHn70mx8C9mhyi1Ui/OuNsDnelNfyGnk2rT/3YBVH7LW5pavuMqOsQZzvOgU9kB
 L2iF2U4jk4XuCtnviwZDvk1s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 320e4235ca64a28a;
	Tue, 13 Oct 2026 13:14:44 +0000
X-Mizu-Trace-ID: 320e4235ca64a28a
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
Subject: [PATCH RFC v3 6/7] mm/vmscan: pass scan_control to mm_vmscan_reclaim_pages
Date: Tue, 13 Oct 2026 21:13:08 +0800
Message-Id: <20261013131309.2790253-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gngteucrm7hgtmejm1je3b5pc8qu8dia
X-Rspam-User: 
X-Rspamd-Queue-Id: 0979218000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1791897285-885377
X-HE-Meta: U2FsdGVkX1+wSC81cCYl96hb8/9J9wU8W6dlBOeKbYnepL60LKl+Bg5OheovrWk4kOYT/xvXaIN8U4zNwluvZD/e/3XF62LFv8CSgoSdKFAbnOH3mdSQcrEfcCFFsfaSD5aFon3Ccr+90HhUnXf0iwwj8cJ8X0E8ZvM9WNc5J/XucrQOw/cqcg3wVddGlYfXsTdkz8TxI2+FFRBPOa8YgMSsgNsEY0ZDB8ASvHF61Mnxk5OO94wDw+yWEG5ZfttHTjsHqpAtw4YuVMuykvK+FYBGNEmmSCsjjj0f+j6FI11Be6WKXqOhQQBZZMFwAP/Jii0/77s+mMu5dcNStaL3wv9cZ7uBxr8V8YNqjD+bbPEclhVaBS37ZXfrjBro45yr4UqweP8wqX5GQhoqUg8RuLXxhigZh8SogeHOquBAOMEmTP0CEQ/KdxuAbOodLZD48ISpLu877cSvVP67uV7x31dYMh3/xBmKfzKh5EQLkENDd8rYDPSbNhoTb/FCWxyDluOKMH5/2LaZ7qlb5R1x7Mt7dzeGjkD9q1ywfMz+K6NGWPSALA3hMJinKG9NHC29FYqryClgPMbMCkaezq5RAm+z0yvHgZX7d8n7RNZL4dtaFHFVxY9Hw1tU5YPd4t7jWmYnWXwItJM3QJAt22L2ReHjfbER9jWJLwXE2I5JUv2HyWPG3kSthph0urxwPhU9GX19y/sFcR8lkTCGLsXmnbnKlzvm10N+K9jjcYiWzCi/nhShV9cTbK93nDyCZHJN0COhxWBCLEpHo0mQETsNIIdRkDzDEdrIpIK96BFRBC3qviU3KMAmMtzKDOhYa5vRlTFPLPPKxaT9uYXPa+46LeeFfGxuzlsUUicb+OgDkuXGHbBAubN8GdFhvgh18QczYCr48v8DAa//w9Ratands78/RE2E5/mOMwr6D9Ct9fzRP1MNrdPHeuJEQRny1vWUtVYuYuaAvbe0Xkz1Dqw
 0wO/yLVl
 PBPcTqydB6cRsEfNTc3Bq8R6P5geUIZYZPxdT0IouCQ0v6QHInKgZzZNhEUOYD81uw1PqUGyPEwTVOvAnhzgDNKldLDtrDwHXj/IZl6nfrUzC4ExV6G0hJiR6xNtKT3ySYsejV3OKpvzWXRSL3ZVJZ3bmmJAqpsk4LpknFjE2IhqiiWKl5ECGswjANKfAeAZQ+/pvOP3uIrQLJ84wgtjeiyBnUMN6vz1Kliv/JTZekTWhbAhc/c8hjJ+VF629j4l+YVKUQJgvYpR13DFPt1/4VAykCwf/E1y+ARgq34hJjULo3G4+C7ZmT3I/Hj3Z8MZFf76b6yL2Fu22h16xv37f2HVv6m2vzzlYIhDNKUaxAdZGjkuFLYF+q866Pj1ZIPxaIFCP4gr4FrR34WvuXgc1SOSmYWsIe5NrRVIxYivRRcTPuE3mZxuH3+akvIIuwX6RoWp7MfcGGVuJr1yQdew3pjhNCGfvcGPav76Ch+Tt+0iPlaq2EDnhaOVoeDExLjy10yj6ayalohJ45UjZSgBJg8mFT7Qb82YBk/8rzAlrFz19arNKexvizvEZTT4190mMh6cXUsUKL60eLEZq9+mRuGVgRI0F9xANofnYHbHMhBFPB0NQWVpt0zmnk25y2CDaybXJrvHZLdIgvndRKU43us6MhSWEnhblJWjVZ6yOdATDdyADScuYngDtpcZ4b8Py6fER1G7uCcIratPoU4CILS7KGdPTzP0Y/zUNjv/Hthnw1v/WF0+LoptSPWI7o+awkr8jmevIdEfqZ0Q+NT2Dp42b/pVZTnhvC4rhAQrDJyVuU1IhkiLEBzdzsZ1i5kPpiVKkGzOe5TrWfKueIWzan9IP/3uS9YwOke4Mru0DUPt1K0SW4v1+Qr7aZZxRRpcNgqs+ZZcxU7dHX5rzKyaeHUOCjZKN69v8+iwaFaoXOgvEHMr8YW6QordcOpFaChwMYShXbe3MGRzwR7SWcShVd23M+JZX
 rKvuFn/X
 YFEjf+i2x1BAMNn/vNFT9DneMzL+ncMuHM50q0DSBR3XcauayYsNBaywtUMJ0s6P1YbVfcoKRmM=
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
tracepoints. nr_reclaimed stays a separate argument: it is the return
value of shrink_folio_list(), which does not update sc->nr_reclaimed.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 10 +++++-----
 mm/vmscan.c       |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index aa27cb9524bb..96e41f444924 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -418,11 +418,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
 
-	TP_PROTO(int nid,
-		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat),
+	TP_PROTO(int nid, struct scan_control *sc,
+		 unsigned long nr_reclaimed,
+		 struct reclaim_stat *stat),
 
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
index c25ba910149d..b3278dbe47bf 100644
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


