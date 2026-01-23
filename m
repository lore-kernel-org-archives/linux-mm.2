Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5D9D74EDE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC646B04E8; Fri, 23 Jan 2026 10:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1760B6B04EA; Fri, 23 Jan 2026 10:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BA96B04EB; Fri, 23 Jan 2026 10:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E98CC6B04E8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:01:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEED61AFE55
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:01:52 +0000 (UTC)
X-FDA: 84363543264.04.B1A0376
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8BF7A001C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:01:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HBrSjfLb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Set9gO/ypIAbsARkMT+qR5jxMJl3CCIAGoFSSuhdA4A=;
	b=DcxLR9BXvIMtbgQEUzMTSvNoOOOPXxXWDaKgYnd+TZtfOP20EkWTmkaJHaOjt3qCr/zX84
	6/Ja0Uw2sYpBuDN22XIfXg/Sm7EzGgjHrTWg9Y8GIIXUBlh2P9NJLn8DSfAmp8dWToD+Du
	CxVVrEaHRscVLL5/JjPLqtwISwBlh9k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769180510; a=rsa-sha256;
	cv=none;
	b=m2LKZXiHaN7s6sAPhV5E7U2nbrKy8E1IzH8J14zpIgSMR+hpLPAbyWH8ZlUDZKKRjeQ43D
	Hz5ZDv1DtRm6IL9nk4ZM/jAoR82c6Kd4g6C7dXenVO5n1hP1a0rrKZ8mKxF0YGV48BeUzA
	0ohUxkIEoq7R/Xa5GhYWTZdL4tdoh4s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HBrSjfLb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2a0ac29fca1so16951625ad.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769180510; x=1769785310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Set9gO/ypIAbsARkMT+qR5jxMJl3CCIAGoFSSuhdA4A=;
        b=HBrSjfLbGHqKADo9NYFkQCOJuQiDJZ4y6lSMN0NPHguBCYKkbcfSAYQdb9r3OnKX+9
         HulYQVKV5yYVbYwBzGhbmZiLasTlwRBzSbAv4qhdqYF5ZLL21K66vDxGArKUbYFcm18b
         kKnsPXjVPg538xA8FRdFrcToB159wnMLOBLvMGN1tiENpncwcFcGuj6aAbGgZxdD4dnm
         10EBf7+i13FEScCJsRN1vnmnH+iJ8rGJSIaPX3jqbP3ex08R6mIerjLPcvf3g7K5Vk12
         mhhhHs3kZbSFl1VowoVFlxn4SI+OT2+/zWOXiZ+UK189EmvVqEpdL3mtuAdnFIuV8t8E
         ld0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180510; x=1769785310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Set9gO/ypIAbsARkMT+qR5jxMJl3CCIAGoFSSuhdA4A=;
        b=lKgH0BoUXRJjMMTL2FfwkKhvuqoexAyCw+ddIexQGWb98cSZfacFEDiuxL5bRultHj
         KKkeMtJVSyARC8EV0VGTTDx2HS/tQCIwG0eGkwk/VEDMaPTS1VmycmmZgJvYILnR3eq3
         7fesLxnRZzrdK0K6JyTYgAr7qgxCY5PnmILtbJ0D99/hbtKC8ORHDt5GQHfGb5aK8bMS
         k7hp8WIh3YzJ56BZMZGvE5Rwrj9mruLupmu9GlfPxs7FQH96dv0v9zBCnI3nrZE7ubEx
         nyKlt5lTp0JscpUoqEs+PAUZd4InbF5eiSCYs2YwjNgY3cbEg8OQm/hAvKFiNRV6diBJ
         hJEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtsX0a8tEgFiuGp1i0FGf9DhqqyUHUN1Myfq9E4w1U9grJu0E1ROB3QHPLaJRRMA8s18ScRuuB2A==@kvack.org
X-Gm-Message-State: AOJu0YwSW6kKMD1v3HEzi6f2avPINu/6HmWHwEeDL9zCeUHOBTmriEAN
	Re52x2SV1LM5HkUMtOg3GfAjaEv3dPynexgFuHiq73rcfVo+hiN1p+sq
X-Gm-Gg: AZuq6aKVLI/eqvff0cwEvKn4Dz4ySGB8uF4tpG7eKd3/XxkTgwmcy55gCr/DnYy6hVS
	jVnrLJFr4Ww35O9xuhh0VF53hE68fE3dyIlZFDeVTvnR11/+drzah5Ci5eoJLxNsfR5KXNPOgyl
	CTyKKgJb5bSFLpc32cfV2/iukoH3sz8bv2U9Gzw2mVYTJbu2gfrviy1DyGN16jWSQt0MTutKDuu
	bFWdg2IwP78C+2ggHRumHrWiX+RlriekYtn3PrKe7ADMynGF4VFAzQPeDGvEWh2wCenUTvCa9e6
	nMV5TmaF013fgXW6ISvZRIhNA6xhy69ZwnJG+tsVtnTKtEw4NtyyN19Gb3WaAXhXrmksFLtj9xt
	kKdTkENvmGc0ZUpB84eUppOVqWs7IaCivSCvSkBJX7vjGs+pc0yt4+EMo58xrjjfX2qzBdfBUjQ
	ZlAF0X5UXvPZvHz8/+Ww1JCsAqwAg=
X-Received: by 2002:a17:902:f647:b0:295:86a1:5008 with SMTP id d9443c01a7336-2a7fe62504dmr26429375ad.38.1769180506366;
        Fri, 23 Jan 2026 07:01:46 -0800 (PST)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fae9b5sm22297685ad.80.2026.01.23.07.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 07:01:45 -0800 (PST)
From: Jianyue Wu <wujianyue000@gmail.com>
To: akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	inwardvessel@gmail.com,
	Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v4 1/1] mm: optimize stat output for 11% sys time reduce
Date: Fri, 23 Jan 2026 23:01:08 +0800
Message-ID: <20260123150108.43443-2-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123150108.43443-1-wujianyue000@gmail.com>
References: <20260122114242.72139-1-wujianyue000@gmail.com>
 <20260123150108.43443-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8BF7A001C
X-Stat-Signature: edzrzsde33pmo6n58uafzjn6jgf8si1q
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769180510-682508
X-HE-Meta: U2FsdGVkX1+wmXhctyNth8ixZxEhVBr+8kE7Aw9cSEYttdGWZs+1MH/uyXeuNU7uLsWnuo4u0V5IGIV1yXuoveFaBQbTMVb1aleUUNU36n+Q36DbFptBimuvnuZWilB1kWlM0uZ62fZ2FVfreJyriS+GMgk3JonwMs9EK8Ic8kF2rwA2W7i//7t1Qk2Q2XdL7NYPghC4kPzGRJOY5d4FYygGslotPXDvW7k61b3s5wy4VhAczl1362q+/dyJks0qRAsN22iTLbQUjEBNuDovpOfZFxGgeE+OcD50Fjq/NhDRC9iy3GjGZXICl4U7qqunlmCg2tKQL8Ga99+H11bS0EIi8GogfCu2mad4si8dBU3OFwpwH0/Wzuj2SzTLUNrHkW8CKLxi6xFdTyv6hDLTyF4d15uqvyni7CtzyV+t7y5Qf1VnPRZTWyegWRzvHNq6vP8LetVQv8fQEghN8DR/m+CDjktOLc1rnuYIFgqUAvjjar00/6I1zudNC/Ls+hRh5oaGhvqhuZ9Zw3CdYBRNtKPP7YOT3ga5lP9NaOfh5ooa/5p9T9k3Agj4VM6waav/0JtS4tpu+vEw82scPqF1DCo+rLk+XHXpCrTa7csn9ZC8faeNRuyUEovbb/uUOQTkLgzV8S5oTeXWibAybbEXykZ+FT4OYOiJQqILkNY8rHZ2UPgS6ollEBnR/6o34kVyzGWP/uncFpqwLI3lINlbEDky5esHACXxPvgqh0CQD4vzRUG5vA9rA9RNA7C+Wf6AJZRUl53CK9MGe2QsKweWEaY4vs5EhtXT4IfdUgsF42GKRDu9KJM3/3z3YYXEHjYYvGXtWexO8FlruVS1oufyn5Dqha5CqTzoIXE0pu8NCzSnUbgcveR3Wf7fQolKaBpr1+zZdo5XM7KCE0wcaMyaYzWq0OQKQ0MatVOA/wxvy2fPJ0wonNkLFIprQpYMdWdpKKpfHp+tgj4JKOYuReA
 GraX4R2p
 l9dQstjI5tEym61Rphg9wfhIWW5xMC/H0VqS1KB8hJUajlcypZiss/2QuX6sDhabtEW3ip5S0RWDrfzT5qnjO0w/NzDti7Avqwr+zISMc5WZ3vAnAobRauym4K7iXOJ9m4pxIyz8XNDjx3L13M+Ti+xDSh/rYkA/qPA1olu+5OzcmbLu4FObT3rpfQz+hBcTeW426bDxtSV7L/6+p+z95Ek6wrNRgLMrYbSyus0U+igYIrmNRVMnP7aElO0VUy7p2kd/P7CDZTdroAWwcyiQb61y/j5x6B+PqsyXCShZMNFuhC8yAWg7jTz7klPHWkNEAzakYJWnJ0lN2IaBOOhGdaSZY6WZQ2rerrXLZtwWX7yqvM6U1ijGFAVd8HrL//i3zZMC2I8bBocN5bo+3OQwcjIo5A8YoTc9VXfL3urohT4xlBlyCHRcBu0+jeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace seq_buf_printf() calls in memcg stat formatting with a
lightweight helper function and replace seq_printf() in numa stat
output with direct seq operations to avoid printf format parsing
overhead.

Key changes:
- Add memcg_seq_buf_print_stat() helper that embeds separator and
  newline directly in the number buffer to reduce function calls
- Replace seq_buf_printf() in memcg_stat_format() with
  memcg_seq_buf_print_stat()
- Replace seq_printf() in memory_numa_stat_show() and
  memcg_numa_stat_show() with seq_puts() and seq_put_decimal_ull()
- Update memory_stat_format() and related v1 stats formatting

Performance improvement (1M reads of memory.stat + memory.numa_stat):
- Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
- After:  real 0m8.909s, user 0m4.661s, sys 0m4.247s
- Result: ~11% sys time reduction

Test script:
  for ((i=1; i<=1000000; i++)); do
      : > /dev/null < /sys/fs/cgroup/memory.stat
      : > /dev/null < /sys/fs/cgroup/memory.numa_stat
  done

Suggested-by: JP Kobryn <inwardvessel@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/memcontrol-v1.c | 84 ++++++++++++++++++++++++-------------------
 mm/memcontrol-v1.h |  4 +++
 mm/memcontrol.c    | 88 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 123 insertions(+), 53 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..5efea38da69e 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -10,7 +10,7 @@
 #include <linux/poll.h>
 #include <linux/sort.h>
 #include <linux/file.h>
-#include <linux/seq_buf.h>
+#include <linux/string.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -1794,26 +1794,39 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 
 	mem_cgroup_flush_stats(memcg);
 
+	/*
+	 * Output format: "stat_name=value N0=value0 N1=value1 ...\n"
+	 * Use seq_puts and seq_put_decimal_ull to avoid printf format
+	 * parsing overhead in this hot path.
+	 */
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-		seq_printf(m, "%s=%lu", stat->name,
-			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-						   false));
-		for_each_node_state(nid, N_MEMORY)
-			seq_printf(m, " N%d=%lu", nid,
-				   mem_cgroup_node_nr_lru_pages(memcg, nid,
-							stat->lru_mask, false));
+		seq_puts(m, stat->name);
+		seq_put_decimal_ull(m, "=",
+				    mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+							    false));
+		for_each_node_state(nid, N_MEMORY) {
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=",
+					    mem_cgroup_node_nr_lru_pages(memcg, nid,
+									 stat->lru_mask,
+									 false));
+		}
 		seq_putc(m, '\n');
 	}
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-
-		seq_printf(m, "hierarchical_%s=%lu", stat->name,
-			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-						   true));
-		for_each_node_state(nid, N_MEMORY)
-			seq_printf(m, " N%d=%lu", nid,
-				   mem_cgroup_node_nr_lru_pages(memcg, nid,
-							stat->lru_mask, true));
+		seq_puts(m, "hierarchical_");
+		seq_puts(m, stat->name);
+		seq_put_decimal_ull(m, "=",
+				    mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+							    true));
+		for_each_node_state(nid, N_MEMORY) {
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=",
+					    mem_cgroup_node_nr_lru_pages(memcg, nid,
+									 stat->lru_mask,
+									 true));
+		}
 		seq_putc(m, '\n');
 	}
 
@@ -1879,17 +1892,17 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		unsigned long nr;
 
 		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
+		memcg_seq_buf_print_stat(s, NULL, memcg1_stat_names[i], ' ', (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "%s %lu\n", vm_event_name(memcg1_events[i]),
-			       memcg_events_local(memcg, memcg1_events[i]));
+		memcg_seq_buf_print_stat(s, NULL, vm_event_name(memcg1_events[i]),
+					 ' ', memcg_events_local(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "%s %lu\n", lru_list_name(i),
-			       memcg_page_state_local(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		memcg_seq_buf_print_stat(s, NULL, lru_list_name(i), ' ',
+					 memcg_page_state_local(memcg, NR_LRU_BASE + i) *
+					 PAGE_SIZE);
 
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
@@ -1897,28 +1910,27 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		memory = min(memory, READ_ONCE(mi->memory.max));
 		memsw = min(memsw, READ_ONCE(mi->memsw.max));
 	}
-	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
-		       (u64)memory * PAGE_SIZE);
-	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-		       (u64)memsw * PAGE_SIZE);
+	memcg_seq_buf_print_stat(s, NULL, "hierarchical_memory_limit", ' ',
+				 (u64)memory * PAGE_SIZE);
+	memcg_seq_buf_print_stat(s, NULL, "hierarchical_memsw_limit", ' ',
+				 (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
 		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			       (u64)nr);
+		memcg_seq_buf_print_stat(s, "total_", memcg1_stat_names[i], ' ',
+					 (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "total_%s %llu\n",
-			       vm_event_name(memcg1_events[i]),
-			       (u64)memcg_events(memcg, memcg1_events[i]));
+		memcg_seq_buf_print_stat(s, "total_", vm_event_name(memcg1_events[i]),
+					 ' ', (u64)memcg_events(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "total_%s %llu\n", lru_list_name(i),
-			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		memcg_seq_buf_print_stat(s, "total_", lru_list_name(i), ' ',
+					 (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
+					 PAGE_SIZE);
 
 #ifdef CONFIG_DEBUG_VM
 	{
@@ -1933,8 +1945,8 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 			anon_cost += mz->lruvec.anon_cost;
 			file_cost += mz->lruvec.file_cost;
 		}
-		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
-		seq_buf_printf(s, "file_cost %lu\n", file_cost);
+		memcg_seq_buf_print_stat(s, NULL, "anon_cost", ' ', (u64)anon_cost);
+		memcg_seq_buf_print_stat(s, NULL, "file_cost", ' ', (u64)file_cost);
 	}
 #endif
 }
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..b1015cbe858f 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -4,6 +4,7 @@
 #define __MM_MEMCONTROL_V1_H
 
 #include <linux/cgroup-defs.h>
+#include <linux/seq_buf.h>
 
 /* Cgroup v1 and v2 common declarations */
 
@@ -33,6 +34,9 @@ int memory_stat_show(struct seq_file *m, void *v);
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
 
+void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
+			      const char *name, char sep, u64 val);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..136c08462cd1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -42,6 +42,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
+#include <linux/sprintf.h>
 #include <linux/export.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -1460,6 +1461,53 @@ static bool memcg_accounts_hugetlb(void)
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
+/* Max 2^64 - 1 = 18446744073709551615 (20 digits) */
+#define MEMCG_DEC_U64_MAX_LEN 20
+
+/**
+ * memcg_seq_buf_print_stat - Write a name-value pair to a seq_buf with newline
+ * @s: The seq_buf to write to
+ * @prefix: Optional prefix string (can be NULL or "")
+ * @name: The name string to write
+ * @sep: Separator character between name and value (typically ' ' or '=')
+ * @val: The u64 value to write
+ *
+ * This helper efficiently formats and writes "<prefix><name><sep><value>\n"
+ * to a seq_buf. It manually converts the value to a string using num_to_str
+ * and embeds the separator and newline in the buffer to minimize function
+ * calls for better performance.
+ *
+ * The function checks for overflow at each step and returns early if any
+ * operation would cause the buffer to overflow.
+ *
+ * Example: memcg_seq_buf_print_stat(s, "total_", "cache", ' ', 1048576)
+ *          Output: "total_cache 1048576\n"
+ */
+void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
+			      const char *name, char sep, u64 val)
+{
+	char num_buf[MEMCG_DEC_U64_MAX_LEN + 2];  /* +2 for separator and newline */
+	int num_len;
+
+	/* Embed separator at the beginning */
+	num_buf[0] = sep;
+
+	/* Convert number starting at offset 1 */
+	num_len = num_to_str(num_buf + 1, sizeof(num_buf) - 2, val, 0);
+	if (num_len <= 0)
+		return;
+
+	/* Embed newline at the end */
+	num_buf[num_len + 1] = '\n';
+
+	if (prefix && *prefix && seq_buf_puts(s, prefix))
+		return;
+	if (seq_buf_puts(s, name))
+		return;
+	/* Output separator, value, and newline in one call */
+	seq_buf_putmem(s, num_buf, num_len + 2);
+}
+
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	int i;
@@ -1485,26 +1533,26 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 			continue;
 #endif
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
-		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
+		memcg_seq_buf_print_stat(s, NULL, memory_stats[i].name, ' ', size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
 			size += memcg_page_state_output(memcg,
 							NR_SLAB_RECLAIMABLE_B);
-			seq_buf_printf(s, "slab %llu\n", size);
+			memcg_seq_buf_print_stat(s, NULL, "slab", ' ', size);
 		}
 	}
 
 	/* Accumulated memory events */
-	seq_buf_printf(s, "pgscan %lu\n",
-		       memcg_events(memcg, PGSCAN_KSWAPD) +
-		       memcg_events(memcg, PGSCAN_DIRECT) +
-		       memcg_events(memcg, PGSCAN_PROACTIVE) +
-		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
-	seq_buf_printf(s, "pgsteal %lu\n",
-		       memcg_events(memcg, PGSTEAL_KSWAPD) +
-		       memcg_events(memcg, PGSTEAL_DIRECT) +
-		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
-		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
+	memcg_seq_buf_print_stat(s, NULL, "pgscan", ' ',
+				 memcg_events(memcg, PGSCAN_KSWAPD) +
+				 memcg_events(memcg, PGSCAN_DIRECT) +
+				 memcg_events(memcg, PGSCAN_PROACTIVE) +
+				 memcg_events(memcg, PGSCAN_KHUGEPAGED));
+	memcg_seq_buf_print_stat(s, NULL, "pgsteal", ' ',
+				 memcg_events(memcg, PGSTEAL_KSWAPD) +
+				 memcg_events(memcg, PGSTEAL_DIRECT) +
+				 memcg_events(memcg, PGSTEAL_PROACTIVE) +
+				 memcg_events(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
@@ -1512,9 +1560,9 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
 #endif
-		seq_buf_printf(s, "%s %lu\n",
-			       vm_event_name(memcg_vm_event_stat[i]),
-			       memcg_events(memcg, memcg_vm_event_stat[i]));
+		memcg_seq_buf_print_stat(s, NULL,
+					 vm_event_name(memcg_vm_event_stat[i]), ' ',
+					 memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
 }
 
@@ -4544,7 +4592,12 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
 			continue;
 
-		seq_printf(m, "%s", memory_stats[i].name);
+		/*
+		 * Output format: "stat_name N0=value0 N1=value1 ...\n"
+		 * Use seq_puts and seq_put_decimal_ull to avoid printf
+		 * format parsing overhead in this hot path.
+		 */
+		seq_puts(m, memory_stats[i].name);
 		for_each_node_state(nid, N_MEMORY) {
 			u64 size;
 			struct lruvec *lruvec;
@@ -4552,7 +4605,8 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 			size = lruvec_page_state_output(lruvec,
 							memory_stats[i].idx);
-			seq_printf(m, " N%d=%llu", nid, size);
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=", size);
 		}
 		seq_putc(m, '\n');
 	}
-- 
2.43.0


