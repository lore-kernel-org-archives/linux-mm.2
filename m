Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128DCC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179CB6B009F; Mon,  7 Sep 2026 00:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12ADA6B00A0; Mon,  7 Sep 2026 00:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018856B00A1; Mon,  7 Sep 2026 00:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D56266B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:25:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F103160697
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:25:37 +0000 (UTC)
X-FDA: 85185677514.04.F42C19C
Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B6C620003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:25:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTYxUOTX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788755135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ai2FLbYhbclFG2Wr+zQUfIp69d1mEso4Wc36mj+ehbA=;
	b=Myd47MTyvkEGb/vzgjomBiuw/Dg4sI4u+f9UCVbFESqdsRtOFYSL5aonn1/pp0U6p5xM42
	Jr7UCugHkXKNGKDOiTt2BUYbNpzOLPbLLpH19vIoq8Q+pznJP52kpmx5TLu+rmjU0c47KE
	KDJv8A4QYQYRO9/8rHZTkOubyxT/shw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTYxUOTX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788755135;
	b=amkoZVlfk6iUaSzNJp8S+04rhKUmwejI8q1P+O7qnIlsPlzH1LV02s7WvKZKmQbBXJP2gX
	atMNHv3NBuifte4YBLnkXbIcG7fprS28u4Uzvr4/C0dRD69v4SPVr0RGZeztQqTEQ1K/n8
	ehqp1ST3zumywBGCXG5RjwM67qpN5WY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mK2et90Pf4XLD3r0uXRQiTeVcL8gxLH+/TQolfNphI4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788755134; v=1; x=1789359934;
 b=JTYxUOTXL1GOPawvOBiUf4pkF8n5ytKR22NHEzOCgWUj42zFrqOXedAn0vV6rG+yJwu3I1Wj
 P9emkQj7WgF9S/c58Hx8TRX49KFPrj2r2RwdezQAw8NyVjU45iIAxVl7IMeElZBS5OjHb7Wly9m
 Yh8mFhAud2C9m7BYBP+BLtRE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f2e3209ee265622f;
	Mon, 07 Sep 2026 04:25:33 +0000
X-Mizu-Trace-ID: f2e3209ee265622f
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
Subject: [PATCH RFC 2/2] mm/mglru: add tracepoint for inc_max_seq
Date: Mon,  7 Sep 2026 12:24:47 +0800
Message-Id: <20260907042447.2450663-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907042447.2450663-1-ridong.chen@linux.dev>
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wf8xaxeq7ym79jmmzz7bnze8q4a7ey7d
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B6C620003
X-Rspam-User: 
X-HE-Tag: 1788755135-175562
X-HE-Meta: U2FsdGVkX19rnbunyF+68Zg2WKkk+//KTsPxoPiPsMdhAnD8txKpFeql8j/s5JO7VcAlWBb0YSWJm7bsJz6Y2jX9LmwkR2sbs3hOWnhxvsDZnCiSlIS9OxM7a5KLWKNWrZeAGFQCOBlTQGxle0h2gsx/BR1iMoxa5zSH6PYk7L1bBYHHfp1fYJysWXSasdAJ3zhUQPPxuhuvM23Qn9oq9LmQyO37OiuZedrCoHRIqfsukiyV2GACQMjZHtAHymzcNwWv76aVgcSEgdqaNW73HnjC61VBjx+LcWOsl0Mk0w3UU5irJK4MNiVK0aNgvC1bzo3fAu1NlhNdBnX/jnIPhVK0FbkLEmS1loEKOA3FtTL5M5iqK+s342hql7x3u+oxMQr/92z9DmKB4YTa6fk7eDhJHi+6Nj1/C9OhEYoIGlU33frCftdkzIB0cVNhDn8sMSozsIFd++Dy0yDyT3ik3fHiJlQat/58wssk+iT63ocpx5SYfr/dgZOp6zIU5B2A42Gnj4N9ctnzl79vfYJ9JttR5MeVzeaGSwHJT9DjkAndil48Z/x/cL6t08S02HJMZK8L3C5ezc+5t6Uh1YPayal02cLvjH0AfgN6v/hjFFlTNP4ngZACiWTDzv0+HWHeVy5bxu47QVxWsb8W6XJpWRSd632GiUUqXKrQDENJLpTQI6eRA9BQg8At/SsoVgWeMC2h/+pQ92QWud3E2NNGqiGfJHY9Nm5SqMcO2PzFPBC7L6OKpP33S798MU+2RSlvvIztetA2AYv34XdCl5Oj8YBuwmVSqxc4cNt/dKCwWaPqk4J8elFN2ypiwSKocUty7/cAOgyFctE18ekB3OpMkHNcqi4Y+EHbh73ZcgpCEE/xjOm8wvoqwkTLY6iTgZRZgM1DvdUBlP1IasvesquJZgSBVBJIYGNU4WDmtV1z6ArItrf4KKq0kx0uOkrXKXFycQSUVU1vmgRQROyW5hm
 /TXApHrb
 BMuZSkqaO4YRZO63jizPMySL3ffkIaLe6hMxKiNHqj9j6EAKNzJLMURRRBoBBrv3VyrDm0GS0Kq/lz0EZSA3+STJnP9u10zHG/w7BzVfWna8N2j/KvOmVnwgwuttPqsn2yb6kytnDe8EKychZZUIJb8un1zAhDzv6c3tKe1eNuPKCSOln+UFNP9cigXtJS3B8rYJk1SOVTzDJsdlmI9AoNWeUElG9+ihE2XLeHanc7SarybeN33ZqcXhW1LVqXrCIofMvHKu9WXg1qytQiZTBZYn0vMw60A9vzMTDVYjs32TIbbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
youngest generation. There is currently no tracepoint on this path, so
the moment a new generation is created, and how the min_seq of each type
trails behind it, cannot be observed as it happens.

Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped, with
the memcg id and the new max_seq alongside the anon and file min_seq.
Paired with the mm_mglru_isolate_folios tracepoint it makes the full
aging-to-eviction window observable per memcg.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/trace/events/vmscan.h | 30 ++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index a0e3cf75294b..ab93c2f4b318 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -439,6 +439,36 @@ TRACE_EVENT(mm_mglru_isolate_folios,
 		__entry->max_seq)
 );
 
+TRACE_EVENT(mm_mglru_inc_max_seq,
+
+	TP_PROTO(u64 memcg_id,
+		unsigned long max_seq,
+		unsigned long anon_min_seq,
+		unsigned long file_min_seq),
+
+	TP_ARGS(memcg_id, max_seq, anon_min_seq, file_min_seq),
+
+	TP_STRUCT__entry(
+		__field(u64, memcg_id)
+		__field(unsigned long, max_seq)
+		__field(unsigned long, anon_min_seq)
+		__field(unsigned long, file_min_seq)
+	),
+
+	TP_fast_assign(
+		__entry->memcg_id = memcg_id;
+		__entry->max_seq = max_seq;
+		__entry->anon_min_seq = anon_min_seq;
+		__entry->file_min_seq = file_min_seq;
+	),
+
+	TP_printk("memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu",
+		__entry->memcg_id,
+		__entry->max_seq,
+		__entry->anon_min_seq,
+		__entry->file_min_seq)
+);
+
 TRACE_EVENT(mm_vmscan_write_folio,
 
 	TP_PROTO(struct folio *folio),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 771fe6827939..3c806a57d113 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4065,6 +4065,10 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+	trace_mm_mglru_inc_max_seq(mem_cgroup_id(lruvec_memcg(lruvec)),
+				   lrugen->max_seq,
+				   lrugen->min_seq[LRU_GEN_ANON],
+				   lrugen->min_seq[LRU_GEN_FILE]);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
-- 
2.34.1


