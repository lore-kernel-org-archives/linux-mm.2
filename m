Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C38C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CE26B008A; Tue, 14 Jul 2026 08:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854056B0092; Tue, 14 Jul 2026 08:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C9F6B0093; Tue, 14 Jul 2026 08:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 371BA6B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2FA8A033E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:15:39 +0000 (UTC)
X-FDA: 84987277998.11.B1E2577
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8BBBC0017
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:15:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=bm6kt+pb;
	spf=pass (imf10.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031337;
	b=2hgAMyQIFq8OrNK3EuXwtokyWlbW6zY9S+CxpKdZpwWXPHH2w3c3cVhx8OgrQJvpFhd3P8
	euEZgePOtvG6/3bfoH/uEMhyHVl/5Y33aig1dVfNxc2cUiLJkIyIacsIxkAMDlv8Quga8V
	XLgiTULfHjpXviOhVTS2BJH57vcHm/s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=bm6kt+pb;
	spf=pass (imf10.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajWSzJC8ZX5c1v8s4BktWV/r3nVerPCf8q26E0mJDVo=;
	b=R+9nVoMiyurFd6+nSWSr6+LT2Xh6XRxoQAdYlULVss8y4AJud6nvcZgRZRJQIFtSQLdo3X
	ij8ThY5nPS6m02aOU6kOenirBHzE7vnXX4R4hIkx4zP2eRWeyfeClk2fIn2Lu8bqrBXIu+
	Lv1i/4tZNEJ374j/XUQt/kxprkRaqcM=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=ajWSzJC8ZX5c1v8s4BktWV/r3nVerPCf8q26E0mJDVo=;
	b=bm6kt+pb2YDJ5eFS0HrJFxTuF9vH6LOkgpTUnkcRQTtLsSA/bEK9RLS/PrwpIVrNghjNzIqy2
	SFBNTEKjWgbRLxSRRmvtZukmApB7kuHnmFJIgDjsFRX+4lgotpouNZW4YA5qOASCYC6UFRzhqnM
	2uuiYcIdTBtzmE4M9vyA7OI=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gzytq1bcMzYlJxV;
	Tue, 14 Jul 2026 20:15:31 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 14 Jul
 2026 20:15:31 +0800
Received: from localhost.localdomain (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Jul
 2026 20:15:20 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <yuanchu@google.com>
CC: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<weixugc@google.com>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<willy@infradead.org>, <denghaojie@honor.com>, <baoquan.he@linux.dev>,
	<kaleshsingh@google.com>, <tjmercier@google.com>, <tao.wangtao@honor.com>,
	<zhangji1@honor.com>, <wangzhen5@honor.com>, Zicheng Wang
	<wangzicheng@honor.com>
Subject: [RFC v2 3/3] mm/lru_gen: expose oldest-generation page counts in memory.stat
Date: Tue, 14 Jul 2026 20:15:29 +0800
Message-ID: <20260714121529.2237261-4-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW004-1.hihonor.com (10.77.232.85) To TA012-1.hihonor.com
 (10.77.199.132)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8BBBC0017
X-Stat-Signature: uyqboaigqeaf3wdzhprob8zsx3xqyci9
X-HE-Tag: 1784031335-219585
X-HE-Meta: U2FsdGVkX1+mXCAiic7j36Jpd0hTX+lj0cr9cN7kD3C5IM/NQLnHqQ+LeMk5dSJPaPaGm06rYiV9sXYYZGR8EwQYA2d6Egrsu8TJyyHY1+CPc6gkvVZa6ePyIkRPyo83vGqKEK3G2MpECbsEkk9UKgzdZLonw1XMKyON4O48Mq8HlSL4Wmogy0Y4A12Zx2IB71NeFAS+nozPATCbD0RHQXft0G4ss4deUaiC9l83U+lWIJUWiPWXkTgdldnhg0YaWkBz+AAaXNICtV0373gZAsO3jpogn2riZ8UkVYVF0wfhIg+hcJqCRVTWAJYOOzCGMJArsJzBoznmqcvyPmsNET4bUXIpPlsgKAoNDYQz4O3EnNmRUfak51lOTLPp3ZAmXft40nehuQoo6UFyiMdkhyhhRI1j/duqNNoAA8isWfu5ACJKWxWoLOZnrkBNjSNL6iP+URBlYbaYSBCHCZKcz2Ue3DQnI7W/rWkbBt2DY/iTLwJKZlIVLi92NahQ5A6vdLuz6Mtsgd6aFRyJutUX7qHMwciWfF9k8M6Nvwuw3SS2u/rwohlSU7PiGz+8tboIRNVV6oiJWCa5fWCbhe1GSR3rYDc8ZLaY6PTRTnw2VB6vm4VGohw1Sh1RpM2Lug3bYjiVWW2LKR7XJl4O/bfyh8EZFjVYct+aLFP6RzEp7ZVg8iMMsDzvT9W+kstObrYZyg0aFzPZigC9rbnmPKJtR82x5qEkhEmbu2YD1x6/enGPYmkrTRtwljIMVASa+ZO2rWj1TijlP2yeNS8ce63TwwUmXqiVIhD/kaFE9I7sFZiFxKJ3vuhaaVn5lvm43Jov/ocBhoEwx9o06po/vkZF5IW7EWHGmPkioRcfV31hfBOK75EZcXErJ7J3ASNsA6gd+SEe9LSGTTjaI/Uv2fzth2OnLZgNG1zVbRVjukbmIOXCI8HH4HQi/AEQRO9kWt+XZXK6N77cn5oaSmjMJVw
 gMf+sQcT
 E51JNz/yQXPrD+mBIo4G5tk0Lz/6NYHx4E0Nz1LksKtuC7RXXgtfJ0+Cf9UKbGhUjnG2A1tbOF4sL69SYtZL+OFM7HMPBKrLo6SkckIw3Vf5Up4ev2u8UdMA8sMx2PYpJ1w8/DBFjoTU/aMtXlpOb1rirX1C3a8vcPWxlpTw0y4dUQmFvyB3S+o0GQvxWRTn/uvRmgJC2kAbe3FTAwxSs/MqZielDdd9BlKkCOJEKMVxjuFG43aw+VLu/jEHebeZYiZ4DcYOzP8sbSx/CljbWepcy+ERS6GnmamkmNk5Ht5wET0gkJoCNP6F/XTFf5FfFgyEiMKkv2b9BpKXPwnlszne1zixwYlfPz4AfBH7DRYabKIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add nr_oldest_anon and nr_oldest_file to memory.stat: pages in the
oldest generation (min_seq) of each type, aggregated over the cgroup
subtree and all N_MEMORY nodes.  This is the observation half of the
proactive-aging loop - it shows a policy how much anon/file memory the
next reclaim can evict directly, so it can decide whether aging is
needed.

Computed on demand from lrugen->nr_pages; no per-page maintenance, no
hot-path cost.  Paired with the AGING counter and workingset_refault_*
to confirm an aging pass took effect and was not too aggressive.

Gated by CONFIG_LRU_GEN; reported in pages, matching the lru_gen dump.

Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 ++++++++++++++++
 mm/internal.h                           |  2 ++
 mm/memcontrol.c                         | 24 +++++++++++++++++++++
 mm/vmscan.c                             | 28 +++++++++++++++++++++++++
 4 files changed, 72 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index f42ac6dddbf6..a071175d11be 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1658,6 +1658,24 @@ The following nested keys are defined.
 		the value for the foo counter, since the foo counter is type-based, not
 		list-based.
 
+	  nr_oldest_anon, nr_oldest_file
+		Number of pages in the oldest generation of the anonymous and
+		file types. Only present when CONFIG_LRU_GEN is enabled.
+
+		With MGLRU, page reclaim starts from the oldest generation
+		(min_seq) of each type, so these counts show how much anonymous
+		and file memory the next reclaim pass (or a proactive
+		memory.reclaim) can directly evict. They are aggregated across
+		this cgroup's subtree and all NUMA nodes, and are reported in
+		pages, matching the per-generation breakdown in the ``lru_gen``
+		debugfs file.
+
+		Proactive-aging policy can use them together with the ``aging``
+		counter and ``workingset_refault_*``: a large ``nr_oldest_file``
+		with near-zero ``nr_oldest_anon`` indicates file cache piling up
+		in the oldest generation while anonymous pages stay young, which
+		is the condition ``memory.aging`` is meant to rebalance.
+
 	  slab_reclaimable
 		Part of "slab" that might be reclaimed, such as
 		dentries and inodes.
diff --git a/mm/internal.h b/mm/internal.h
index 96add6cd4627..959d376c02a6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -636,6 +636,8 @@ int user_proactive_reclaim(char *buf,
 
 #ifdef CONFIG_LRU_GEN
 int lru_gen_age_memcg(struct mem_cgroup *memcg, unsigned long nr_gens);
+void lru_gen_nr_oldest_pages(struct lruvec *lruvec,
+			     unsigned long *nr_anon, unsigned long *nr_file);
 #endif
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c6a969b56878..016194cabd60 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1733,6 +1733,30 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		}
 	}
 
+#ifdef CONFIG_LRU_GEN
+	/* Oldest-generation (min_seq) anon/file pages over this cgroup's
+	 * subtree and all N_MEMORY nodes; see lru_gen_nr_oldest_pages().
+	 */
+	{
+		struct mem_cgroup *mi;
+		int nid;
+		unsigned long oldest_anon = 0, oldest_file = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg) {
+			for_each_node_state(nid, N_MEMORY) {
+				unsigned long nr_anon, nr_file;
+				struct lruvec *lruvec = mem_cgroup_lruvec(mi, NODE_DATA(nid));
+
+				lru_gen_nr_oldest_pages(lruvec, &nr_anon, &nr_file);
+				oldest_anon += nr_anon;
+				oldest_file += nr_file;
+			}
+		}
+		seq_buf_printf(s, "nr_oldest_anon %lu\n", oldest_anon);
+		seq_buf_printf(s, "nr_oldest_file %lu\n", oldest_file);
+	}
+#endif
+
 	/* Accumulated memory events */
 	seq_buf_printf(s, "pgscan %lu\n",
 		       memcg_page_state(memcg, PGSCAN_KSWAPD) +
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 805e29c499c8..3800f0c4f1f5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5935,6 +5935,34 @@ int lru_gen_age_memcg(struct mem_cgroup *memcg, unsigned long nr_gens)
 	return ret;
 }
 
+/**
+ * lru_gen_nr_oldest_pages - pages in the oldest generation of a lruvec
+ * @lruvec: target lruvec
+ * @nr_anon: filled with oldest-generation anonymous page count
+ * @nr_file: filled with oldest-generation file page count
+ *
+ * Reclaim starts from the oldest generation (min_seq) of each type, so these
+ * count what the next reclaim can evict directly.  Computed from
+ * lrugen->nr_pages[min_seq type][zone]; eventually consistent, clamped to 0.
+ */
+void lru_gen_nr_oldest_pages(struct lruvec *lruvec,
+			     unsigned long *nr_anon, unsigned long *nr_file)
+{
+	int type, zone;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	unsigned long size[ANON_AND_FILE] = {};
+
+	for (type = 0; type < ANON_AND_FILE; type++) {
+		int gen = lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			size[type] += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+	}
+
+	*nr_anon = size[LRU_GEN_ANON];
+	*nr_file = size[LRU_GEN_FILE];
+}
+
 #else /* !CONFIG_LRU_GEN */
 
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
-- 
2.25.1


