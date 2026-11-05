Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A30606D830
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pNEbpqKE
Received: by kanga.kvack.org (Postfix)
	id 330466B05BC; Thu,  5 Nov 2026 08:23:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307D36B05BD; Thu,  5 Nov 2026 08:23:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244C56B05BE; Thu,  5 Nov 2026 08:23:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F33A46B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:23:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89F431A0A34
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:23:14 +0000 (UTC)
X-FDA: 85401131508.13.3814614
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf07.hostedemail.com (Postfix) with ESMTP id 764DD40006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:23:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pNEbpqKE;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYV+yJGTziGTRc1MN/3N3LeRV8A5wid4qIJ9qlqLvKQ=;
	b=KV1nnxSLWfgBD2IHO74yMLa4bE0s0NFXTVGTxwmv5L6h3gXlogykLI2l2mv1tzsP2znjrz
	jKNXpzjvlp9XlpZ/uWEdEX93BwRpwUGIVv60c1zsVdw5t9EGCJpTLqVTUqF1fMSY5ExrFL
	G6yTSPKHwZ8pT6i7vmtrN3VhG2eINgA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884992;
	b=dlX/zvFVlZ1pnGjvhcJ5qsN5+661MEQKUquopPpB9EYjUZgzOpIeL3qvXs9kph4m0jIFoP
	ADfbLC67jUbm4vm6Pe7oAJGHZdCYBMM23kwpvfG3lIf91rJY3ZGDSbZC/YDD4JeU7NEZ89
	WVMD59yCtvCGHFf2oHk7HP6gr503DaA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pNEbpqKE;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kHs8Y+dHA0ewLCbf5W9kyEteQjnWZcV5rBSJAmaEPvY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793884991; v=1; x=1794489791;
 b=pNEbpqKEsgclgowUTesDhTY0wunJFrkLzHRD1yKj3xJHYknfKvR6shR0K+toHbtesw5uXexN
 nDe+QHXipMBmUwoZusfnal6KLUW5a/dyTCA0TghtaQqOOKgjw0iMpH+7GekEi7foH9vseZfj9Ih
 YaUa+tIQ+T6lgT6vTkQ4802Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 878a88923bad5b48;
	Thu, 05 Nov 2026 13:23:11 +0000
X-Mizu-Trace-ID: 878a88923bad5b48
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 3/3] mm/mglru: move lrugen atomic stats off the read-mostly lines
Date: Thu,  5 Nov 2026 21:22:20 +0800
Message-Id: <20261105132220.2233677-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105132220.2233677-1-ridong.chen@linux.dev>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: skueadhatky9eojio5oed3acwgx3h7nh
X-Rspamd-Queue-Id: 764DD40006
X-Rspam-User: 
X-HE-Tag: 1793884992-946255
X-HE-Meta: U2FsdGVkX1+4rui/6MEAYTbWUVp01U3xVP6TZX3ceMV9cO6J2gNpiPnfjOyFtHa0B1ebppIu3mY5Gf12WizCecUXmRnySMOFCVKmxd0XAuK8LN5YpgTvLdI1yDFmjD+dI4VvlZyyXLs+nnzn/3L0H5gMoD7jaySyQrJ+GjAGOIdFUerC1h7JFHY1VrHHwZzgQDdKULMQQjHwIn6hmAnx+EEB7gCyLTCvFj/bgakOwx+hde050WMKTfdIGiBg0zi+yeJx1w6FgqnlxZM6yw9A3IUMxwDKyyrQVS4/rb8dvn2+l4TlgEKgt4Rk+W2yRAObSUE57qeX3l+c8a8Hce7YBJlksb1V0vnB/36HLZHJvRe9ZIrUFll5q0Pt4yCmDNAFqHZj+rjcBjbVfO8kwa2ShnLYCebgn12evd5RW/6IUlSM4bu8AFvibXGjhUD3Zvpjsj3hafmmJEc4Z5FiF2eo1NSMULLT/CWCYGVHd5lMOfSn1oqNIW0o0dMqderuPgWiVUkj0cAnSY7gNhG38un1nMSrgpeuE8jEK1Bu3TjhgqaN/SKuOQYK3WXMWDUSAQsiNKygSOMubyZkc6YHAP50URxeEnfYebowBNj39KME05ufyNsmS3JJEIjPWFFIeIoEG1lV/Q4s36lgZuswGLt8TiimZg/FpyHqOFmn5iZcPtNkFbnbG0607lDH5xYUUwYJqMcEFSespedZBLUIjQoGzQ/zkA1NxG7B7t5SGzrVdgpt1hGsW1jsMOWqab+zyfSZB36Ovneusym3LfSlibz4kq+2LfTvZhjXo2im79Vg4pDLNFHxgLifOssTOTauEmEvFX2THAR5M3sjP0EOQ5x0Qv2l+k2JBBAXVafDVjZfkETJRLBUVXNSyqnWIB6PRQuazOS3IXcjTQ8GSHsEBdKXRRV372HfFAOTn3kquFSEELmuHdek1wicb/4OI/R7nlW7Eeac6wqJoltijVGRzUJ
 Gl0O6KO/
 KBzbogLS+Z3RrMDd2gBICFCol5eCItwfTJP/Mh7SfSb3orr6LT8zbv/eXk3SEu5k2yrphCvtbHcvCsvVzmOKIxyCKXcUMoOOb/+BnaLYRQwvPHOUC5tUeB9VDRhZKOAxouek5l4le9FHWRH0ff6p+ELO4m+gNGEcLoNBvdb9QFWc2T2wBK3Lb213Z8ZO5oHchnqLC+WdRasHe67vKQneKh6HfBu0czyhPmuJifLNUPqWx6ThsUPtS/HsmeBPkDLia0XC3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_eviction() and lru_gen_refault() update lrugen->evicted[] and
lrugen->refaulted[] locklessly with atomic_long_add(). The arrays sit at
the tail of struct lru_gen_folio, right before enabled/gen/seg/list:
with LRU_GEN_STATS=n the file type counters share a cacheline with them.

Those fields are read far more often than they are written:
lru_gen_add_folio() reads ->enabled on every LRU add, and shrink_many()
walks ->list and reads ->gen/->seg under RCU. With frequent file refaults
from several CPUs, every refault invalidates that line on the CPUs doing
LRU adds.

Move enabled/gen/seg/list next to max_seq/min_seq/timestamps, which are
also mostly read, and put evicted[]/refaulted[] in their own cacheline
group at the end of the struct. This grows struct lru_gen_folio from
1360 to 1408 bytes and struct mem_cgroup_per_node from 2176 to 2240
bytes on x86_64 (one more cacheline per memcg per node).

Tested on an i7-13700HX (24 threads) with turbo disabled and the
performance governor. 24 files of 128MiB on ext4 on brd, read with
fio (psync, randread, bs=4k, fadvise_hint=random, buffered), all jobs
in one memcg with memory.max=1G, so nearly every read refaults.
IOPS, median of 5 runs:

  jobs      base   patched
     1    270537    274303   +1.4%  (sd 3.7%)
     8   1461025   1466293   +0.4%
    16   2455629   2508001   +2.1%
    24   2707720   2823776   +4.3%

A custom random pread() test of the same setup, with this patch alone
against base over two boots of each kernel, shows +2.4% at 16 threads
and +5.9% at 24 threads, and no change at 8 threads or fewer. With
anonymous memory on zram, the refaults mostly hit the tier 0 counters
on a different line, and there is no measurable change.

The gain grows with the number of CPUs refaulting into the same lruvec
and needs a fast backing store; with real IO it is likely to be lost in
the noise. The patch is mostly meant to keep the lockless counters away
from the read-mostly fields regardless of where they end up.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mmzone.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6442e662aa4f..eb84af674e23 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -551,6 +551,14 @@ struct lru_gen_folio {
 	unsigned long min_seq[ANON_AND_FILE];
 	/* the birth time of each generation in jiffies */
 	unsigned long timestamps[MAX_NR_GENS];
+	/* whether the multi-gen LRU is enabled */
+	bool enabled;
+	/* the memcg generation this lru_gen_folio belongs to */
+	u8 gen;
+	/* the list segment this lru_gen_folio belongs to */
+	u8 seg;
+	/* per-node lru_gen_folio list for global reclaim */
+	struct hlist_nulls_node list;
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
@@ -562,16 +570,10 @@ struct lru_gen_folio {
 	/* can only be modified under the LRU lock */
 	unsigned long protected[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	/* can be modified without holding the LRU lock */
+	__cacheline_group_begin_aligned(lrugen_stats);
 	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
-	/* whether the multi-gen LRU is enabled */
-	bool enabled;
-	/* the memcg generation this lru_gen_folio belongs to */
-	u8 gen;
-	/* the list segment this lru_gen_folio belongs to */
-	u8 seg;
-	/* per-node lru_gen_folio list for global reclaim */
-	struct hlist_nulls_node list;
+	__cacheline_group_end_aligned(lrugen_stats);
 };
 
 enum {
-- 
2.34.1


