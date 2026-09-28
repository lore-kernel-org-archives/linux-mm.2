Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B7ECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8F36B009E; Mon, 28 Sep 2026 07:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AFB16B009F; Mon, 28 Sep 2026 07:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED036B00A0; Mon, 28 Sep 2026 07:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC9D6B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:48:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B42A91C18C7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:48:17 +0000 (UTC)
X-FDA: 85262997834.22.5AC875E
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF3951A000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:48:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UDtqHTvX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bls8dZPU7VPWANSW+YvTvDSY6apZOii86OTWBR5aMOc=;
	b=Wl3XKylWm2eYPQOF6EWj/oTHneyGV92iVQIB5fBtaqpLykNJFe03HY0JnyHta6rAwTKKfP
	09YMPd6P4qRbPo2970zvn9pQhtqMuF5T4FHf58lkU0GoU480OnAtr1CHzA1yqSVrkDPyHl
	JUCJW02cv/qPeHQOOwX6M0GGPKmzkvE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UDtqHTvX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596096;
	b=jmCAMOSmywmvUh01XpxuzZFPdYpw+LDRWSUt91kzVimIDWe5+pOaxufxOGbpciwy6gkbWy
	TEPLcGQiy9BXdA+d2tiXsUUkTY/4jGgaORwuIsTFW1zdxaJNv0KdfTd8Jwt+jcstgMA9rH
	nd9LGrjqfoyczWyUQ7GbAyWyEdCqNwQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tt7LGshuqhNxDtoKCH/LZTI4ttNHcJzRhKME5HBY9Uw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596094; v=1; x=1791200894;
 b=UDtqHTvX165RknbB241mgGwmNCIveH0xUbj48b0WW73B2ZkDKd3SIGsgEgK5BowKVUYYgJJ7
 WtkOKGkzXhYGt2JlGwPlkBAiRhNcMxoApEgwYHA/Wrga7cwyKhqjrh6pgQDfpxO/ogch5XIVfIX
 pTImSctQcfExyTUv9LQDPXRk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cc434b568fabe6dc;
	Mon, 28 Sep 2026 11:48:14 +0000
X-Mizu-Trace-ID: cc434b568fabe6dc
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
Subject: [PATCH RFC v2 7/7] mm/vmscan: pass scan_control to mm_vmscan_balance_pgdat_end
Date: Mon, 28 Sep 2026 19:46:24 +0800
Message-Id: <20260928114625.3609130-8-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF3951A000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kwjca1thmig5bweyw5mshpm4mkre8ynq
X-HE-Tag: 1790596095-883130
X-HE-Meta: U2FsdGVkX19bIoRD7cdtOizMVCF/TX54ggkxdwbcZWa0bvSZlX56WNh354raXgufNhXkYMvFOtpNNHgLqb7VKlMkQxmyZ5nG1ChA6yyuJvDoXGC4a2YNu+We+c0/bp8/StCrhJZMnJZiJdlMHA7372Sbs22WP/oTMp3aNqxxLcF5OhaCJIq7xFWtPG2/71fLUK4CGszp0fcXV50FPIz63oXhC0BNnOOHbPCD0PiBOAvg+i8cIZrD/UtQ8RM7oq8k7NLgBPedqntUrXUNUzDAHkvXU13i5M/7j3vMaw0RtEA1PCRDWK9OWK1w5/EYWPeeZGsXcp2KLFVMn/thh2Del0g6XIQy7ej63pAo0QHXx3s/n65XxMFhctbuwc6NmnKvvKjZIP3l+8NcqMXQ3zCWbxI5L87xmnLg3JRJer9rpyR7rextm+BP4fXo5bdfkzwxWY7et6YdXORsOsWCi4625d7+i6c9M9pttuVemE1CUpjSc8ETCvNYr6aa9kv/z9FR8tsfkKorLC7lq7MbYQAxDhLFpKeYGRcKt53u9R0MjyrWbi8xvLWuVx9MKdSA3rgvvHXlqTsSgB2aSzR3UHRc9rK+KVwfuyfi9+Jxnuo8m6OvRrr4Sj0aGokcdXYZPa8A+/LUT1vEb6Q1ZVsnctjduzeXJQu63/ETjHPErDdZY1yTTiLuLfesAiZsgtDywrsQFupXMQjSz9DgunM16IszlKTzQFT2XUtV87K2GF7yHLkTjhZUJO7NGXH1152+XWCFvLvwaupnN/NtothcbvDKeg7nT5zSsz85/yDDdmdDM+/J+yxeozvp85rHvrk6CzNPjo5N1Zh0DXt1JTD5WsBCzCyoolVL6E2/WpfIyxRsVGZxnQXq5UVxe/QXhT5lSZ9xBotn1R+79XEYHgQkU1NZiq22LJsUf4ijeu1otxTTT+PxhZ+3LCVWyh51mzClTT5KIARgC6KAwBqkz5EhWUP
 P2g06e1c
 zVAe96cde8u3ZY67UfUiOXPpGTtCE0B4150CrYY/fa4mZyfd89CfediMIb1CEmnCrbUKbjLaRZo+/PFg0wSt5YIdWSeMUovxfFafQoZkCEQklDpqEbfxcThOqj7hgXfOiYNjqoxC7nBSONPufnRwJ4x6pk8dzzCkqYQxc3QBirTdJN8DTJLlVUxs6tzEBc5b9ZQRsE4Z5Vdm9GLRPePkQ0zSrLLicbchNUzPrYjz6GknEwra3Cf/5Mr9S6wPcYbp6v7S1W676NMVQVETe+UHPt6b3+7MknK1OXH1SI/iljxLzxuPuMcyXW9hXh0CwqIMF0qMgQ4Z20t5I462MNU9YsXhMOlAvGng80vFMnhrr/4IIPbLYEk6/2uXlytunyB7LmjNx43svuEWytawQXFQIa+F0XY/be3tJ9w2nrpzMy4GN2ytQViGef19YUhfgjTAB1gCvTX5jLO3a/MDlmQG/som7qU9WM1DxpGMUivFZ78qcN7+Q9YhnTL/ewG3mViK6mIzp+NfNL7oeJGR+j9kmCYTWob8EsOFeCeDlVaoKsqbStrI6Byx7wXhmV/bUfuzY3aHuW2RX7KRUTZqCS3SNmhw3CbPYvNPOEjjkBEtT2sBrQl42cA3RR8Rlin6ygO4uNgkSkrSVlgmOTB3dGhyYFmLp0hNuIH9vgRutlbOakWyq822B+tLL6ybrW/xMQzJMd/1c2ChrQvvkFYw/l+aYpqzahc91sQbj+nvh/KQbFyIqdok5zfTNzaek2aFOaAdZRba3y1tcaF/D2XfoCo4SXeC4Oe/q8Idgo6euBqd6YtRiXd1G9di5KyMaaTjJClLGiO5gJXgCROa4OFB+7XcT2xZeJL3dOXYFAjC/xmZ5Zefa/qIJAXpTG5BagvPhZ7kbiy8bKNhtQ2tdIJbYHyjJMdtGECmSBlzQYD/eyZfxNaruh8L2oHN+rWDPfVhLBSuvjksQq5KKfboL/mhrARGJqSQ9L5m1
 EHaoxA+D
 U9soJBMHRA1gawZje8jXNqR2bvT6u917BBTsk/RBrynzl9qCncv3s/brPK3FEMTZl55CJvzltxo=
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
mirroring mm_vmscan_balance_pgdat_begin. highest_zoneidx stays a
separate argument as it is a local of balance_pgdat() rather than a
scan_control field.

The exported event format is unchanged.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 9 ++++-----
 mm/vmscan.c       | 3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index 04f285e77659..c27bc7cc6063 100644
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
index 6ec84390ee2a..52d90a32091e 100644
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


