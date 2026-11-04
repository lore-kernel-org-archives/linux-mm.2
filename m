Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9648606A32F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WGk0gsBy
Received: by kanga.kvack.org (Postfix)
	id DEA7A6B05D9; Wed,  4 Nov 2026 08:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1636B05DA; Wed,  4 Nov 2026 08:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF306B05DB; Wed,  4 Nov 2026 08:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEAF76B05D9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:09:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53C4440724
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:09:56 +0000 (UTC)
X-FDA: 85397469192.19.E5F379A
Received: from mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4434240005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:09:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WGk0gsBy;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797794;
	b=P+yFIYN6NcnernHg/pRfixw7QehkWZaqO3AG82jX62mJ/oLhZiYKc+dqWoBroHZavMgfdf
	GYV6zFAW2hNFZUmdcv8feP27649+a4YwkmkxLl7fQs3I9G/k64IEO4CkqfVjyyMbgZ6wcW
	ycpd+H+fyp4dZh95Hy1K+cFChPaOaFc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WGk0gsBy;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoW8AaaH7SuVML2GGh9qhcZQMupR/EpkYhtYLlwVTrQ=;
	b=4Nu7/rZgDi0unVTGrZ9iNwyvNYPus5SrQ04I/UKCu6ArsphiYu47ik7Pf0Y4/wPxBqwZuv
	WsSP2BwAQQfboXH4haI7kVc/MARDJ8YgTpVyhcmYqt3vUf1aivVEWA/2uwbyVTiECMAPVR
	JerDCUYrMn4gg1+xGRoXSbOk0bmkM2A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k6t2SMCBubq6DQa12rUHkyNAtuRpSIKZLV979qtmD3g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793797793; v=1; x=1794402593;
 b=WGk0gsByCVg8HIOfmHpmV4/1nUJkMzwp78iGwmVfBesyI2X3Ci7UdmKkEwrWqk/KeVYj9lym
 aUkmcRHixGfk0iAebVLey/a7ZgAOHACN5JJGMohAwvAxNUS2EF75gFEX5EqXWI7Dw9Ndk3sJSxk
 RH54oIIdO4EgfdhIRlFDVpC8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b3114da408d4d2bc;
	Wed, 04 Nov 2026 13:09:52 +0000
X-Mizu-Trace-ID: b3114da408d4d2bc
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v7 6/7] mm/mglru: add lruvec_gen_size() helper
Date: Wed,  4 Nov 2026 21:08:16 +0800
Message-Id: <20261104130817.849089-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261104130817.849089-1-ridong.chen@linux.dev>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r71n3titmon99auq44ehdfgbnskmjrqb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4434240005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797794-599721
X-HE-Meta: U2FsdGVkX187QwAW1g15ZVv3cxa3hG+2/t9MM7zt57HMVFIwaPEHo2bwBMzb+jM44KerWEpXSJDM6YiF2M2E+WvG1XPntnBCW9gjzXJGUHPlH4e7es/ZCO9gThmc+GIDWVWUhCGn6LTDQz0F2SHwfOVYBPdDbeDcv/vNicnDojdN6Y1CP1BPaxD2oa0U/uD44HmdXZS+L17W6g0YCMg3i8zEOVzefQ7bcsncfGLJouu55+mL5DZEBlEGPHAuDzZ7SdZ/QmMKFB129v/St4GkCoj/Q02eKELEQEa9nxzBLCFBz8XBDjllJGhMUoGAhTkIMoUyRAWztNdd13l1skFxJLhMDawWBFZnPJVpID6BXEKmJJcv/wMENmPs0eI8VaPhAmSxWT6dZ97qznETssU8sgum0BvHMDi/Eovs/QMRvJT6Zx+bKxuz16hxaFrNV5gRw83lWF8edrO68tVbsc2J+w8joP0wq2tqRnc8VS3J9IQJ8U3FsE6x6+T4N5cRAVD5BZfJCYOwYW+HGMRIh9VGuUNneZEJs8MDXzImXAK11iY9zUFd9taTE96ywydUuVAeN9MErZQKp3vTMB5+F7FqxyvsAx3GuN/312qHF8rDnxY4F50+bPo2ptdbQIjyxsu1Jkj8fE2BQ2Wsz/8uiFHpE1iJzd+famwtKtigxCEDK462WNwGP8aH/PCKXC4wP9Gw5BcbP7qeGZp8kU6UcC0XE6eZStTiypTcGI3a0t5C6cdXD2HnGG6PR4c7pC0nX2dyvBAOJ29yhx5Ixo/OBF8qwReN98b30PiTnDD3uJ8CPxe4M/TArQa1COUG40V8J4I77jS23DsmMErPtgIgw42K+J+m2qjPoB4kWu1huP5YL0OmrjN4jiNbKSm8HxplHnAHWVGN6CNf6msXMHYPfFy/hU6D0W04Wf6a5QtYUBenxXPBBNyVDdGVAQc7fXBmxh9VY4xJOLz6nsI97ykZHeL
 S7SI0VJD
 a1pasYNhxnNw+Zu/SbkdIjG8NFFOcxfRlg+XaTtQHsQdpHOr5sT30FtKXbXOgfy3wyeef/nw1+IS+po9luFxSF12/m6cL9e7unOyJJvBPrd8CjzxG8pxwWjNlNeRRdXtQTqE5CNdwDw6YBOwBPgE7fyQgXdkfNeUd06WwK+yjvDbKYK1uXZEXS3h+9dANKQrzAM43L+az+Aj3OwWJ2bbHp8QwKYOXUQD2mss49l3sOxOEyKY4keO1aBlg4z6RU516YL1RZTtU9GNKYeV3wokvsfhNY8mnvjYTeb5/rUaIcbqONO16RSI24Zb1M/tBA0WSh7ZWEK32nE2WMjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

The number of pages of a given type in a generation is computed by
summing lrugen->nr_pages[gen][type][] over all zones and clamping each
per-zone counter to >= 0, since the counters are updated locklessly and
can transiently go negative. This loop is open-coded in
lruvec_evictable_size() and in the debugfs lru_gen output.

Add lruvec_gen_size() to compute it from a seq, and convert both users.
Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
header, can use it as well.
An upcoming tracepoint and the MGLRU swappiness rework will also use it.

No functional change.

Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 18 ++++++------------
 mm/vmscan.h | 16 ++++++++++++++++
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 379ac3b148e1..d05050ac49df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4194,18 +4194,15 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+		for (seq = min_seq[type]; seq <= max_seq; seq++)
+			total += lruvec_gen_size(lrugen, type, seq);
 	}
 
 	return total;
@@ -5687,20 +5684,17 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		seq = 0;
 
 	for (; seq <= max_seq; seq++) {
-		int type, zone;
+		int type;
 		int gen = lru_gen_from_seq(seq);
 		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			unsigned long size = 0;
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
-			seq_printf(m, " %10lu%c", size, mark);
+			seq_printf(m, " %10lu%c",
+				   lruvec_gen_size(lrugen, type, seq), mark);
 		}
 
 		seq_putc(m, '\n');
diff --git a/mm/vmscan.h b/mm/vmscan.h
index adb22e80d760..c6b583fc7493 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -3,6 +3,7 @@
 #define _MM_VMSCAN_H
 
 #include <linux/gfp_types.h>
+#include <linux/mm_inline.h>
 #include <linux/nodemask.h>
 #include <linux/swap.h>
 #include <linux/types.h>
@@ -115,4 +116,19 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+#ifdef CONFIG_LRU_GEN
+/* The number of pages of @type in the generation @seq, summed over all zones */
+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+					    int type, unsigned long seq)
+{
+	int gen = lru_gen_from_seq(seq);
+	unsigned long size = 0;
+
+	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+	return size;
+}
+#endif /* CONFIG_LRU_GEN */
+
 #endif /* _MM_VMSCAN_H */
-- 
2.34.1


