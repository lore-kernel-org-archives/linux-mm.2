Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACBCCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9570B6B010B; Fri, 26 Jun 2026 06:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E766B0110; Fri, 26 Jun 2026 06:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C3B6B0112; Fri, 26 Jun 2026 06:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65C006B010B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:33:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0271CA03E9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:33:03 +0000 (UTC)
X-FDA: 84921701088.17.CE2339A
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C5D71C0009
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:33:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469982;
	b=VVWJkuK4gnve8kgnP/9aBziJ9Wnty/cgsUxd1HPXr48eHEPFnrOdSCFA4b73oIyKfM2VhZ
	tQG5H3jUdFBXAi4ObjWI9wwBJbZdqydP7bPnZSFgVfwZsHmD3xgvnEXgrhs1kXPUVHfZKe
	w7Abjah+rviShgA4X32BUnugRRn1haA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8gMFkrXfKqxSdfofXJDNgc4lAClOuImmq01pKN/JDNA=;
	b=4yhwPGhF3E+iTW2VKEH40AhBcwEBVI4Zm/Jt5OW27StSsnHyCFjWd2fPxwE6MjQsbopqmF
	fHeTX1JRy6w47tov7nd17dbp6LNvTjUDpZ3rnqbOb71PeFD2dvBHnLHonfVkUHeplV6JiV
	RO11z9T9zucqhzitl9maNQvBrf7v4Ts=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id CF0FA3EB86;
	Fri, 26 Jun 2026 10:32:55 +0000 (UTC)
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
Subject: [PATCH v2 8/9] mm: percpu: skip the per-cpu node walk on single-node systems
Date: Fri, 26 Jun 2026 12:20:57 +0200
Message-ID: <20260626102358.1603618-9-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGdhs9xuqAzUROmmsJvsJjXlJZ0qeTIQWv1SwQGarWmGYIa0sFgvk5TpQ9jfrltusvZoPk8YdWn3PZEEalLBjdfHMe7NqNuZrhxSoChbVpy5Nep8byl3DHWVqDvp22mXFzlNO8942ydLlAkQ+L6aO+eIgnDvtvprJXn6Gk9sJGXK+ptPbEvnkFg0hCg1QwOx0jFi2oA3CD11zGmtPZ3Qj90hnJeuAwCdkM5UQT74WjOHTYJqjH6/g55DRp4gxglIvoWlT1Dy8heeGbvllTWUsmkWwtaP9Gq6rx1FN35MPiV+ZgrCHBylug5kSysqz4Bd4NnZNgsc26P0Z686fWBs04NGZ2L6BOqlCYjKvy0RPl7Thgt+4EKQYopbxzDs7aRSVnv8Om2E7KFTJqyW49SFwExedbRztVQ3o3Mx42iJb/e5jWK2J2HP0hZ8f6iwzaeOrYp24wuOmClFvrWLD0Vl4qKtHrID2ph3in0idGpyU1i+AnVA9ZmliVPBjveNKHVapt32F7vtuOo5Gr8AZ+yUGd3ELG9ZiGkMLsESU6QpYSR4Z+V/fA2nWJNczIPh54RZtlsCY6gKvvfZI+HtGQP2Mil6Dk60YBYJdUlCDWI2Ymw0Ya/Rwr3g0qWeGny0xO8mX/7X33UudNXMYp14pkhpFjJdky320ibKb7wdMNa3KUXNA
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Queue-Id: 2C5D71C0009
X-Stat-Signature: czecrdwj83ss5y97u9rejock1ncihxwi
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782469981-68721
X-HE-Meta: U2FsdGVkX1+eJCgmzYahSzhv+cScyrP49+r9P5TZsyIoEELiBt644SD5dx4Qjkvm+m3yS08LjpyvoTSg97YmaClH5lT1kfCCLmFdIAfSlmGZH/F1KMXMWUhHlXCIw7G66tcO+2th7zmmrWOyOKg1lGMFQYAUuBtyz25r6wUeer14pI1+3kUuNpLtse7xPCXbbOaAof960fRynw+HmadwG+CtBgaxVkXGehw17hRUmax9yTRY30phaq2E8t/t7r/P6v76HZVbo8bhNfIoywdN1CvnMyum1H5ONkyNyQkgwdHtieTfP3LqF2usOV6RegJmAf5Ftx0Za7+16exrg11vDmXVXT9+/2mHcAT8jC3dsKbf311nDJuA/pdtS6/s7QmCJp22HGU6jNtJ3LL6EDm6U6JMwsL0OyLfufYlYXedPUDtnIwXGRqU8wdILoKYPlMEWGEr5gCUNdBKsS0D3i2xRA8pB+ATnjtgc/10xHLVSr2t6aJ2BbgQLQgQjkRJmj3Di8PLy5vrSnS1s0jeRUb2TwKjmAjAHHgeFlE7qaoVHFjgk5Jun6hFksEYQJ5qR2f29MgydGCxTx/q/2e1+AQg5hQAUv229TvL7upCNxFysUX3Hn8SHNWYgcNz5eC83RCveBF9pAFiEMrsWzgrVVjS/L3vVtfwObLq3OewyMU1NpHOXwLC9nV1wLbGh8IrfBBQR8wo/vK2pzN3NNH3TsS2qUpSd3DvF4ICaie9YA3EslabaTk/MvW0MSfJYFi0nsqL2is/oAoJGvWC7LLqn1Afh5oyo/HCCJQhVS8oK3HwL+vj8/5y7bDEKz+alb819EnwvGawUVWimFj4qyQxN+d+P0IUeNT5hP8V/0lK9U3/lGBUodFfNDWNU7d2LKT7lpyMTA+7h473qlfVVukO9XhUOiS32R7ny9wQpr7NxmYy9YLT6PrY+oXJjeRLY6GAH1rJyEFkd2/vvwLQjqHPikz
 HhHUdekX
 Ym2VQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_memcg_{post_alloc,free}_hook() determine each backing page's NUMA
node by walking the chunk with vmalloc_to_page() once per possible CPU
(plus the obj_exts vmalloc pages). On a single-node system that walk is
pure overhead: with only one online node, page_to_nid() can only return
that node, so the whole allocation footprint necessarily lives there.

Add a fast path in pcpu_memcg_accumulate(): when nr_online_nodes == 1,
attribute pcpu_obj_full_size() (payload + obj_exts metadata) to
first_online_node and return, skipping the O(num_possible_cpus)
vmalloc_to_page() walk entirely. The result is identical to walking the
pages, since every page is on that node.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 9224344d4b8e..9a735d01b23a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1689,6 +1689,18 @@ static void pcpu_memcg_accumulate_obj_exts(struct pcpu_chunk *chunk, int off,
 	}
 }
 
+static void pcpu_memcg_accumulate(struct pcpu_chunk *chunk, int off, size_t size,
+			     unsigned int *node_bytes)
+{
+	if (nr_online_nodes == 1) {
+		node_bytes[first_online_node] = pcpu_obj_full_size(size);
+		return;
+	}
+
+	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+	pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1705,8 +1717,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
-		pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
-		pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
+		pcpu_memcg_accumulate(chunk, off, size, node_bytes);
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
@@ -1748,8 +1759,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
-	pcpu_memcg_accumulate_obj_exts(chunk, off, size, node_bytes);
+	pcpu_memcg_accumulate(chunk, off, size, node_bytes);
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-- 
2.54.0


