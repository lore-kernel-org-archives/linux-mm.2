Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BDCDCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA406B010E; Fri, 26 Jun 2026 06:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED19A6B0110; Fri, 26 Jun 2026 06:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8166B0111; Fri, 26 Jun 2026 06:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAB356B010E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:31:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FBBA1C4F20
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:31:58 +0000 (UTC)
X-FDA: 84921698316.18.BE14308
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id 785E1180008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:31:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469916;
	b=nFxvW9qRmLG3BgqcC1BVTPmN9I/2LE9LKCL1wSKFgwu6beGZyVh6cqDCpE0JLfHtL8T/e4
	KupDOC3q7ER8YvctqxtsB4Um5ht8LGMw4HpGGric4bjIeBAo6vkF0pidkTeIY4avampKRd
	XTiyV5BOb46TfrkgVI5VSdAS/vaPnLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=feMg3YYhmApFYXf9YCd71+2IbIDv7QrEx17UGULv4zo=;
	b=4TUvuqrMGxRY9G0l1uE8ucI+RnYCsbaYy0UUJxOURiAuvqt25f1zzJNerlcDjaYiKVcXXn
	FLkq2VI4ehXSKEUn9LPlieA0GMCAJv5EmGHFo4xldD9BMjnVBY3+1oT9bcWKPEQAYVtfsd
	H+1ly2p+e/yrhAwxI9uAJoBnG/Lpr4I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7D70E3EB9A;
	Fri, 26 Jun 2026 10:31:50 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 7/9] mm: percpu: per-node kmem accounting for obj_exts metadata
Date: Fri, 26 Jun 2026 12:20:56 +0200
Message-ID: <20260626102358.1603618-8-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGdhs9xuqAzUROmmsJvsJjXlJZ0qeTIQWv1SwQGarWmGYIa0sFgvk5TpQ9jfrltusvZoPk8YdWn3PZEEalLBjdfHMe7NqNuZrhxSoChbVpy5Nep8byl3DHWVqDvp22mXFzlNO8942ydLlAkQ+L6aO+eIgnDvtvprJXn6Gk9sJGXK+ptPbEvnkFg0hCg1QwOx0jFi2oA3CD11zGmtPZ3Qj90hnJeuAwCdkM5UQT74WjOHTYJqjH6/g55DRp4gxglIvoWlT1Dy8heeGbvllTWUsmkWwtaP9Gq6rx1FN35MPiV+ZgrCHBylug5kSysqz4Bd4NnZNgsc26P0Z686fWBs04NMKCEmzctbyNgqaXJTfn5uNKc5IUDzosj4HWtZOxrYbWPFxqqaUUG+qSrWfvEKK0IK/jKDmnEy4ZvLPuFTlSk3AdCYTzQiA4x1P58y82IIQ8vKqKXJ2dpcvzkZLCHlE6UZeICAAVBU5cSm+DnwqXLFC/OCrRgR1Sj98vGzRwgV1MX5T3cxz7vmZNcz1KQJSj71DDb+cy496Vw5swT8RTUaqI7LRWiPt5VeIG1QEJTn15eremc6g6lm6C65WZNG0NqtE5mt7+AZ+oETUsY+Ks9f5wZq8mBW/e/qwEG7QBmzXcfWd0Aw4n9segjMmWa1qiWG3mahatef6M8nKMJwCoZUg
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 785E1180008
X-Stat-Signature: enj11itcox8mr4wmcp6nf7gfzfxhhzgz
X-HE-Tag: 1782469916-34071
X-HE-Meta: U2FsdGVkX1+cMgIO/5FoRP2cYNUQOwgt3XZ1VqnvD9NtWFlIeAhPwiKdXsHsHirn3jy517B7t2SkzUysvUhjsXBmPw3pQYlYLA9JPHctM3PuTiH0O+vFV27aIhznoBAXUycLmMQjeHiDsONfrV6Sm3Ynmc1v1lEJAuleneaub68TByfEJ5Ckh73S9ih+Vg+eLmTtBTjf+wzXlYzzmCI3mcFvmZPeZm9/u14jZNHAPdx5AIk1WikCDndbpvrsbFX39ZlldS2pmzjyglXnqAMmXsdRFfijnnvjnwae8gOtEVigXVDsrUPZgz7ZMXUEaxSrcfKoHs3rygtUJ1ZeBdhQFav6cmvkVaQyLtaSrFizw/g/tytAzK/6eoR7kHi8WEhpoB/Sk8lJf5qvCMo/jFEIbaB7mcMaO1RftIEjschJncJuNR3tmKJShG7WxYeSDgjnHq1P+xALs7KQ6ZFJkGFaPYhLtcpfo9ECp9dXKx3zKPoNE/QrHXF1Kq9R9gGg1n49PFv+s95SfxW3l3u8K3X7/opora3wd27kAaV5lnvUuvQnd+PAIqLA3KyQ07B2osECBJwoaaoNS0013gAqkKHd2MZLVBR4vq6XwiYod+5AKePAcgdPKukCyu6AeepLkTQa0uZQtRznl+J90bJAZT/75x9Ixmldmwl4f/dtNSZ957EdXLjGS5d6LZ4PeVErXXEKeVVmQY/hKHDayVuWckx5PVqo/hMZUVjTtzgam3+zIhx+VgF2UXx5hXicL2AapISRZYvvDRUs+pYo74BOHF3zyeL8qFsQlRl7QQAF5STHbmIgiUU16lSFmMoMAOYdBIJ0wO8fKUlx65Jy4mnCXWlytBP2V8+KiDvEUfQZ7iGQmg2SxkqpXi5J2NcqdHnnaVgcjQs2Y4Tve8Zwt1/4nfj3lM3wMH1oqDycofS48erjZQMybXg+/cAt7C0aTwcPO1A61Jqz4cPjsKDsrQ2Hn9x
 ur27iVlT
 ytCc+/FF1z7qAPPUjf2xI1upeLXfHjyjz9L8CaT68k7nKoSV1sBS2xJSAjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Account the percpu obj_exts metadata to the correct NUMA node. The
obj_exts array is vmalloc'd and its pages may reside on different nodes,
so walk the vmalloc pages via vmalloc_to_page() + page_to_nid() and add
each page's slice to the same per-node byte accumulation as the per-cpu
payload. The post-alloc and free hooks then charge / uncharge the
combined accumulation per node, so the metadata rides the same batched
account_kmem() and the same precharged page pool as the payload.

Folding the metadata into the shared node_bytes[] accumulation means each
node is rounded up to whole pages only once, across payload and metadata
combined.

Note that there is no need to bump the number of pages to precharge here
since we already use pcpu_obj_full_size() and the same reasoning as the
previous commit applies here: we waste strictly less than N pages.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index e9d2d3716b99..9224344d4b8e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1672,6 +1672,23 @@ static void pcpu_memcg_accumulate_pages(struct pcpu_chunk *chunk, int off,
 	}
 }
 
+static void pcpu_memcg_accumulate_obj_exts(struct pcpu_chunk *chunk, int off,
+				      size_t size, unsigned int *node_bytes)
+{
+	size_t ext_bytes = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct pcpuobj_ext);
+	unsigned long ext_start = (unsigned long)&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT];
+	unsigned long ext_end = ext_start + ext_bytes;
+	unsigned long addr;
+
+	for (addr = ext_start; addr < ext_end; addr = ALIGN(addr + 1, PAGE_SIZE)) {
+		struct page *page = vmalloc_to_page((void *)addr);
+		size_t page_sz = min_t(size_t, ext_end - addr,
+				       PAGE_SIZE - offset_in_page(addr));
+
+		node_bytes[page_to_nid(page)] += page_sz;
+	}
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1689,6 +1706,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+		pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
@@ -1731,6 +1749,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
 	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+	pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-- 
2.54.0


