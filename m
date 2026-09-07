Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6883C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4B46B009B; Mon,  7 Sep 2026 00:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854526B009D; Mon,  7 Sep 2026 00:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7440A6B009E; Mon,  7 Sep 2026 00:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADBE6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:25:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0D35C0615
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:25:22 +0000 (UTC)
X-FDA: 85185676884.19.F816139
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9C13E160002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:25:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UVCP0cdg;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788755121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SMDnd2euroklJBDqLgB0Q5OSlo2AUC9hlRSousElk8Y=;
	b=ZX3DV3IwjKhiDNET1NVyRJTs++SoKOoe7pw1MbMUSIt5xT2vwC/z4UbBLeIiMfGP4PNTF5
	/jk7YoD7bfVHLx5gjQJxrm81wJGySYjaEheunbQjtliSR1lwyXqYkADqi5K7Y63z58vbZQ
	j74+KYGR5LyQUAWz+snFsvOMALSaVrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788755121;
	b=ZH0LQlzisxwID5kzZvgv+a5SHfkMACngm/SYwsZUlulDWCgs/uTln5kFiPfwXltnOpFtZ/
	BnRcUBykA6y95cqAud0eruROz6kU3FvkWe7PwV54WorYUukNQ6RW41EKQSe1uxZzZTJR/e
	XWA5oUNEhXfu44ndBeg/SuAVTaI8ZCk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UVCP0cdg;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wrEi0IGqv2yk5i4rOkFtPT9EzmwLrTae/tEdHh6Nk9w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788755119; v=1; x=1789359919;
 b=UVCP0cdg8F9A6AEDfl+JNr/VXO5ni2NBRpMIRV+SJyLZJ4zXgjt5l2fdDkybsjoPpLjnchQG
 9zjydrXsOgt6J2fGOothQf1NG6S9DRy5DU8sN7e//4Mt6rkla7hlGoYlxEECv/ZURpkXhBa1NUD
 Nh+5we06EsoPWOnamzRjIwLQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0a9229bad07e1de1;
	Mon, 07 Sep 2026 04:25:08 +0000
X-Mizu-Trace-ID: 0a9229bad07e1de1
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC 0/2] mm/mglru: add tracepoints for aging and isolation
Date: Mon,  7 Sep 2026 12:24:45 +0800
Message-Id: <20260907042447.2450663-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C13E160002
X-Stat-Signature: 3ttbgeo4b37ox69qk3ygxjop9bzsfsc6
X-HE-Tag: 1788755120-828206
X-HE-Meta: U2FsdGVkX1+XPSWMT4uijKf2NQgSde/WmwJOPj1iyAahImKteigCZpl82fiLzzobKfYenNkpGYym2eaJcXJErjFfGtUce0NmUsIU5WVI2ZkyWly7riBzlyva3ZVvzBjJhsCPcO9Tg7QrYnH5fJccxDQxohbsK3T3LbRWPsN3yBMgKB98LXrA/FclbBss4vZ4rhYwOZXFxs7j9GQ54MWG61D27qwYPatCslnuLPMSPYO+/IQ6kmZr9SZPQVKX/CzXUNr2oIheFxDYFu6NqABkXAnx423EqwbNucol0oHzgJZ63AnU62k3mkTDjRrJzgkKpR+C8W5c8X4bsq4aFB+c3vQ8dle3IdQnNp8LQdm4DJMQZ3Qwx8pjhb0B+c2mg8BnVHXj1vb4cmznuhVFJp8WX2y3yiojHa9CArImiR2D2Y4oUdbZZORKcoFKzT0yN2rc976kH/AJj04MCfXmuKGERlpjClCnvyW9X2PpOHotI58Sa5a1yAXFH3FnKFaJbOeh7LYlYXYhekxidLFJzF/5ZSFUCeNBRWh/g4ZXfCIff+XEVA7IDJAl7SBHIteCFGwijZYxxfl4n6jhmMHKhpLWRfqbNiuufujZMe7Jh0/MH7gnIpU+bv+i+wvu3lEn6XWIK65GrMtESZhOGgQIhOI6rERwLXVz2Tjo9s8XAssZ6+Nw62+V4mUsUZHkF/H6FQnYEmHvaabhdkvqHtc9X9RCDVOW+Uu4EgYLsjlzO44tQDJsAu/8AptaC62QKpWQvsnlngpX2DIhidhxWMY62SbraV5867pnhzH82cI1d2L4PQUpdQRSo4qmFGX3dBGdShEVrreTeBPuEAZlFlb24WaFlbTfJZkdgYrsE6VDfYVXroMJNU9bu31utpS7j6rldSfUXvXnOeYxzR3/epIF+VltscdJSmPLgxCaQ76aqiM3Rv+uXac/gckqzHXJpsaPiq9ES9MBlhTiWi0q0nLPjjl
 eiOPHLKT
 e9mBhLdhiPlNU2prtpCMnPTL19Q1inTa6Vr864CsCgctky4hpfZ1Pw+uEGWynHHZo/lpgMWjTUsgZmh1VpxuI426rA5dx9unqRrCAwLMn9LQzPX2Xm0l9lWltfBdQn1W4gsQ5jLG2j9J+6qjRwRwEB1vf9GEHFXpZVCYyAgPdJe2VDgNDD9muHVbp5Y9wgO8wgmt2yhyuNYaEx59pAoJSIPtAYkPODvXwF4HA22KI7LBlgpMc/wHbf1htqqgn5kLxlafT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

MGLRU currently has no tracepoints of its own. The scan and evict paths
reuse the classic-LRU tracepoints (trace_mm_vmscan_lru_isolate() and
trace_mm_vmscan_lru_shrink_inactive()), which predate MGLRU and carry no
generation, sequence, memcg or swappiness context. A trace of a running
system therefore cannot tell which memcg a given scan/evict belongs to,
how far reclaim has progressed through the generations, or when a new
generation is created - so how MGLRU actually operates is effectively
invisible.

Add two tracepoints on the two paths that define an MGLRU cycle:

  - mm_mglru_isolate_folios, on the isolation (eviction) path, carrying
    the memcg id, the type scanned, the effective swappiness, the
    scanned/isolated counts, and the anon/file min_seq and max_seq.

  - mm_mglru_inc_max_seq, on the aging path, emitted when a new youngest
    generation is created, carrying the memcg id, the new max_seq, and
    the anon/file min_seq.

Both live at MGLRU-specific layers with no classic-LRU counterpart, so
they neither change nor duplicate the existing tracepoints. Paired, they
make the full aging-to-eviction window observable per memcg: aging
advances max_seq (the leading edge), isolation consumes the oldest
generations, and the min_seq/max_seq pair on each event shows how the
generation window moves over time.

A sample trace, with the classic-LRU tracepoints left enabled to show
how they interleave:

  mm_mglru_inc_max_seq: memcg_id=1085 max_seq=7 anon_min_seq=4 file_min_seq=5
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=17 nr_scanned=17 nr_skipped=0 nr_taken=0 lru=inactive_file
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=17 nr_scanned=17 nr_skipped=0 nr_taken=0 lru=inactive_file
  mm_mglru_isolate_folios: memcg_id=1085 type=file swappiness=0 nr_scanned=34 nr_isolated=0 anon_min_seq=4 file_min_seq=5 max_seq=7
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=64 nr_skipped=0 nr_taken=21 lru=inactive_file
  mm_mglru_isolate_folios: memcg_id=73 type=file swappiness=0 nr_scanned=64 nr_isolated=21 anon_min_seq=7 file_min_seq=8 max_seq=10
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=64 nr_reclaimed=21 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0 priority=4 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
  mm_mglru_inc_max_seq: memcg_id=73 max_seq=11 anon_min_seq=8 file_min_seq=8
  mm_vmscan_lru_isolate: classzone=4 order=0 nr_requested=64 nr_scanned=10 nr_skipped=0 nr_taken=10 lru=inactive_file
  mm_mglru_isolate_folios: memcg_id=73 type=file swappiness=0 nr_scanned=10 nr_isolated=10 anon_min_seq=8 file_min_seq=8 max_seq=11
  mm_vmscan_lru_shrink_inactive: nid=0 nr_scanned=10 nr_reclaimed=7 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=3 nr_ref_keep=0 nr_unmap_fail=0 priority=4 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

The two mm_mglru_isolate_folios lines tell memcg 1085 and memcg 73
apart, and show one making no progress (nr_isolated=0 against min_seq=4/5)
while the other evicts and then ages (max_seq 10 -> 11, min_seq catching
up to 8). The bare mm_vmscan_lru_isolate lines above carry none of that
context - they cannot even say which memcg they came from.

Sent as RFC to get feedback on the choice of tracepoint sites and fields
before proposing them as stable ABI.

Ridong Chen (2):
  mm/mglru: add tracepoint for folio isolation
  mm/mglru: add tracepoint for inc_max_seq

 include/trace/events/vmscan.h | 77 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   | 13 +++++-
 2 files changed, 89 insertions(+), 1 deletion(-)

-- 
2.34.1


