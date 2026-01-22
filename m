Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C90C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4053A6B015C; Thu, 22 Jan 2026 06:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD6C6B015E; Thu, 22 Jan 2026 06:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF6B6B015F; Thu, 22 Jan 2026 06:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 172326B015C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:42:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D29BC1402E7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:42:57 +0000 (UTC)
X-FDA: 84359413194.13.7863D95
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id F29E640008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:42:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJvVK7YJ;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769082176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okI60bxoR/3oEcZE7d2ieJqi+BFEqBLMAZE9UaRBOF0=;
	b=sFLyvaxBCaZaROhZ1Io0XCB8gJGmh9Qd55TvguI+CXKFfVcNaOshWqhfP4xBFspABWfW3V
	akgetb+9ZtgE/2BpWXndi/l7c7rTzAHQbYL8ThqIKY36r6RBr52N4tR1MEKRs/i+WfbA9k
	ZA8IVmJa3PIzltqy38Ld3CiS+bmsw+8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gJvVK7YJ;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.195 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769082176; a=rsa-sha256;
	cv=none;
	b=HWwkNM9hxSoD2Z0kHgbm38nm1yZsh9QT1EgIuN8PXF+gfb2eBy4QAGyv41YpNz08ouZSHq
	3jJVGLhZ/gSkCxTjGmneWoWZSAE1e1F63eEifJRPt3zzT76BuFJ6oQyBaSO/v9hp880TbA
	7JJ9PomzJxCYBpuQyWZLekbKkn5UNGw=
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c635559e1c3so37462a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769082175; x=1769686975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okI60bxoR/3oEcZE7d2ieJqi+BFEqBLMAZE9UaRBOF0=;
        b=gJvVK7YJylKx58E7fEbEJGYDtQ7dgZxCgF3pvKR1zWUSLE2qQ7Ze/0YgmOq4IAf8z9
         tbk3acyaFoRTJ/hQWvg/UutITyVYcF0wwFCoaJu/dDQq3BEmDSGZTtFrxacJVcUSUlJq
         SVYdEwgMXuO6AnJ/jva7RR3cK/zM6H+6jt3nAAugNeqeRpXUPyXWInwGxOgDz5zgwtVf
         B4uMME60T16wA75w0lSYvEzsAlgv6+q45eRyT3xYwBbH5gkulYwmCrL7K5M9E/Ap+Ttl
         b/zuh6YaQvdYmx/qthu+r0KWn2cQUbk/wty9fPOX2V1yLGyrJV6/tWE2jX8SVlVGWNkG
         ndlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769082175; x=1769686975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=okI60bxoR/3oEcZE7d2ieJqi+BFEqBLMAZE9UaRBOF0=;
        b=EnQepOpFqTu6Ol4gcnET4sbm3Iu++2yfcRXd8LWN2g3dt836zIYG1aWpPfpasrJLHM
         TptNb99Q2UQoTGAoMTmeqnva1+1xBT7SLaFVm76UutnCLYGjjUlHnNqOdjct22ZATS1s
         yxLtlt2BfrgsDt/TwOdwZ259TXCfDD3WKltypJAtfrkbItpcADDYd0QsIsNvcf6D0IvT
         YOsogKckpj5Wlbo4oo6G2utBy1/b+GnxFtLUkYZt1W+GEMx4vBo0KJ65YV1xMI5Ln+GE
         ydtDLZfNZ1GT4kR8ltkM1nHRfWDSuzg9FNg5Gqvsz9Sx/kdtVntA4wCIl2b4g+nOosRE
         VHUg==
X-Forwarded-Encrypted: i=1; AJvYcCVNQLPHOmfLqyUyMiT1V+SHVYrNi3x/CTk+4/456xB2QAUZBr2mw7UmPzlHHhm2OJbM8F6EJY8OlQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0xagPm8A7Gw2hYNe1zNSMt+oL2DqJQobyh+6v6LTKjWwnPM8O
	nDv5TOC8gRJjF1AYNwQtN5oHgAHQvANcQWxSchYcYjrwUQ9V62zkC2Ki
X-Gm-Gg: AZuq6aIiOIb9jAphCPsPB8d+zmvqG7vddRvt7uPTTl0JiYbFQrU9UQQdkKHFAD+IukY
	OsWHD1uwU6Rsa0yNoHizOjNG2LEokOrEgMU5RiCWaujzq7f+23ZudLF5Jc/32xOUkcQENpQZSry
	DetTk6F9C9U2J1RJlfCy9XY0jwU3xF0V5xS0l0EieH1pjJc5DrPiwhPZJXUsXTYXRJ+P/TS0G5w
	hOJnPloG2inKCVqfbN5CRG5bI46PI2gyis7ujqFGiQPR5n+f25n9ZJhV3WwVTTsJrVojT18JY8H
	K+p/jk4OfpeJzIJoaPVMzYhVjpvxmAqO9Cl/nbFx8dIx0b63o9yxnh1m48m2uZ14asxFrmEWNVJ
	xPA3hSWDMxBVBEMcIJmnUT1tzFxup8Kii2t148L0WDrk1yL+Q4Mn7McgQGRd2+HHXctN3y3ISgx
	Yvc1DEni0MynfY8L+mXsSUTgFkYRM=
X-Received: by 2002:a17:903:985:b0:2a0:c92e:a378 with SMTP id d9443c01a7336-2a7d2f1fcc4mr28151765ad.7.1769082174575;
        Thu, 22 Jan 2026 03:42:54 -0800 (PST)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a773d4e5basm74393005ad.94.2026.01.22.03.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 03:42:53 -0800 (PST)
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
	Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v3] mm: optimize stat output for 11% sys time reduce
Date: Thu, 22 Jan 2026 19:42:42 +0800
Message-ID: <20260122114242.72139-1-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260110042249.31960-1-jianyuew@nvidia.com>
References: <20260110042249.31960-1-jianyuew@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F29E640008
X-Stat-Signature: zbbueqk73mocngnf3un7faqo1qdhwdft
X-Rspam-User: 
X-HE-Tag: 1769082175-111949
X-HE-Meta: U2FsdGVkX1/hOxn4JiaAc+csgwOSbkU+VQc3SWUezdt38+FTvyXmQoGe1Vybhllu0gN1roBSNkgOphNqwKoGjh2UPf1WsvjtGHXlcf6vUTcLmxPDSAull/+egUE5ygBULMBNWmmESyzE243yNVoaCyBqudUkKbxQ1kqyCaZTeJFHs3MrWGGB743/P5IVQYdIn6oSMEl3ZEFaCLH8KwcdwNbC54GOJkrklw+3SyeSAHU1Vu6epZKpf/CaZburTqmM/iMbKqVl8ba77Kq2t/sEbHydIb6ycteQo/jDxQ2k17pqn+J+AkDrjAeaxfmjXiZ/ZBtSViGERNrGox/fLaTz+5qEFrp7l8fFekNm03q08CKFZpU10Zf6rn0GwTn+zUaBL+FPaB0T+8vbsLKR9SlpKZGTbLJ1mVfSsojwzS+Th0lLfBAUvIkPXv6gZoil18008e425gJzG4jcsCKTIx8Mtd2K79YvC5bccbdPJIrFfYWcfjcCzPsVstcaCwvnytjjK4/eHv34PzIc7G0p+1u5SuQLDg+dKPdjTjiXe/8LmAklYgBh+31CTayjN7eq+gp8R025hs9fLM/EDLQR3mWY1nI5jwCecziDK9OROmnSUk+EUHGSoi/QHIFdQ8/MVKwOdw14+XfGbwwM9z9zRqjnVjblFpWHgyHC5dpit8tZZRhF7YEhDpP28Lk6qpON8MstHiep/jx5iGMT5Ur2E1LvhCy3Kl2ecA7sT3lKQc/EVIdXKmqrn3fD1BZNmi9XK839YrofhINKeFk8swUGbwBaqcsVW3bhOlMNCfiqHZaZtw13i3YEAObFFcFi1Hn29s0d5KazO22VMVHSrZJRoDCvuXmlAeIus9u3T72V1FJ/sQDfOrXfbIB+1K3WWC7R6GophKJjpD9KgLSzIApbB2r+oHqakcmUIfcVZ5kMvj894d2jNhX76sCtxZ70NOM6TqI+LE+qUVx6EifWIqlMgZg
 80a8IGvj
 bTX90F2sR0ZpfbsbdzZ541ulUxngjV60gcUw2tEJ2SgzxWZvUqiErhpJhAY3cTSWHJc7b8CGjoXm2O1ojN3hGPiNGjX/pD/e8APs3w5FrwXlHnC3Rkqh4LL48hxIF2MJCRR80uhSKCCpPXjJ8hPrmn/FkYH3pz/cDArJIsZ7QO46ShlUR1Ny5XrnN9+Jhr67rqw78umo8JgN/hrN+4DBRoiGjPJ9xg+zYRzGQ2+VOvg7Burl3pFvHSi67R616Se2nFkhcjm0HOLV29bqD+k4NOq4U4BhHE8BR+7pOztBU2C9vKWFd1vBH42ktHhvW0pkYjmoOi6ehkkO4sCCVWukP9D+mNrdjd0F0d+FR3MGWmZDTkEhv1lWh00NZScl5CxWvj3UaAkj4/oJQLi1ycHRctjafRXfK3f7WCa+SekcnbnjjFtgcklOcqll8gQ9GogDn8rREdfsYSGUVvFFwhedFPaqYlWkCc2fIhOZVqy76xDe8rC0maYtA0al+Dunw4AFEGGMbqR/7EuR0X+PO4MOZivJAXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
printf parsing in memcg stats output.

Key changes:
- Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
- Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
- Update __memory_events_show(), swap_events_show(),
  memory_stat_format(), memory_numa_stat_show(), and related helpers
- Introduce local variables to improve readability and reduce line length

Performance:
- 1M reads of memory.stat+memory.numa_stat
- Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
- After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)

Tests:
- Script:
  for ((i=1; i<=1000000; i++)); do
      : > /dev/null < /sys/fs/cgroup/memory.stat
      : > /dev/null < /sys/fs/cgroup/memory.numa_stat
  done

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---

Hi Shakeel,

Thanks for the review! I've addressed your comments in v3 by moving the
helper functions to memcontrol.c and adding kernel-doc documentation.

Thanks,
Jianyue

Changes in v3:
- Move memcg_seq_put_name_val() and memcg_seq_buf_put_name_val() from
  header (inline) to memcontrol.c and add kernel-doc documentation
  (Suggested by Shakeel Butt)

Changes in v2:
- Initial version with performance optimization

 mm/memcontrol-v1.c | 120 +++++++++++++++++++++------------
 mm/memcontrol-v1.h |   6 ++
 mm/memcontrol.c    | 162 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 205 insertions(+), 83 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..482475333876 100644
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
@@ -1795,25 +1795,36 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	mem_cgroup_flush_stats(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
-		seq_printf(m, "%s=%lu", stat->name,
-			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-						   false));
-		for_each_node_state(nid, N_MEMORY)
-			seq_printf(m, " N%d=%lu", nid,
-				   mem_cgroup_node_nr_lru_pages(memcg, nid,
-							stat->lru_mask, false));
+		u64 nr_pages;
+
+		seq_puts(m, stat->name);
+		nr_pages = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+						   false);
+		seq_put_decimal_ull(m, "=", nr_pages);
+		for_each_node_state(nid, N_MEMORY) {
+			nr_pages = mem_cgroup_node_nr_lru_pages(memcg, nid,
+								stat->lru_mask,
+								false);
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=", nr_pages);
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
+		u64 nr_pages;
+
+		seq_puts(m, "hierarchical_");
+		seq_puts(m, stat->name);
+		nr_pages = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask, true);
+		seq_put_decimal_ull(m, "=", nr_pages);
+		for_each_node_state(nid, N_MEMORY) {
+			nr_pages = mem_cgroup_node_nr_lru_pages(memcg, nid,
+								stat->lru_mask,
+								true);
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=", nr_pages);
+		}
 		seq_putc(m, '\n');
 	}
 
@@ -1870,6 +1881,7 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	unsigned long memory, memsw;
 	struct mem_cgroup *mi;
 	unsigned int i;
+	u64 memory_limit, memsw_limit;
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
@@ -1879,17 +1891,24 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		unsigned long nr;
 
 		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
+		memcg_seq_buf_put_name_val(s, memcg1_stat_names[i], (u64)nr);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "%s %lu\n", vm_event_name(memcg1_events[i]),
-			       memcg_events_local(memcg, memcg1_events[i]));
+	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++) {
+		u64 events;
 
-	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "%s %lu\n", lru_list_name(i),
-			       memcg_page_state_local(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		events = memcg_events_local(memcg, memcg1_events[i]);
+		memcg_seq_buf_put_name_val(s, vm_event_name(memcg1_events[i]),
+					   events);
+	}
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		u64 nr_pages;
+
+		nr_pages = memcg_page_state_local(memcg, NR_LRU_BASE + i) *
+			   PAGE_SIZE;
+		memcg_seq_buf_put_name_val(s, lru_list_name(i), nr_pages);
+	}
 
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
@@ -1897,28 +1916,38 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		memory = min(memory, READ_ONCE(mi->memory.max));
 		memsw = min(memsw, READ_ONCE(mi->memsw.max));
 	}
-	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
-		       (u64)memory * PAGE_SIZE);
-	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-		       (u64)memsw * PAGE_SIZE);
+	memory_limit = (u64)memory * PAGE_SIZE;
+	memsw_limit = (u64)memsw * PAGE_SIZE;
+
+	memcg_seq_buf_put_name_val(s, "hierarchical_memory_limit",
+				   memory_limit);
+	memcg_seq_buf_put_name_val(s, "hierarchical_memsw_limit",
+				   memsw_limit);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
 		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			       (u64)nr);
+		seq_buf_puts(s, "total_");
+		memcg_seq_buf_put_name_val(s, memcg1_stat_names[i], (u64)nr);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++) {
+		u64 events;
+
+		events = memcg_events(memcg, memcg1_events[i]);
+		seq_buf_puts(s, "total_");
+		memcg_seq_buf_put_name_val(s, vm_event_name(memcg1_events[i]),
+					   events);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "total_%s %llu\n",
-			       vm_event_name(memcg1_events[i]),
-			       (u64)memcg_events(memcg, memcg1_events[i]));
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		u64 nr_pages;
 
-	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "total_%s %llu\n", lru_list_name(i),
-			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		nr_pages = memcg_page_state(memcg, NR_LRU_BASE + i) * PAGE_SIZE;
+		seq_buf_puts(s, "total_");
+		memcg_seq_buf_put_name_val(s, lru_list_name(i), nr_pages);
+	}
 
 #ifdef CONFIG_DEBUG_VM
 	{
@@ -1933,8 +1962,8 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 			anon_cost += mz->lruvec.anon_cost;
 			file_cost += mz->lruvec.file_cost;
 		}
-		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
-		seq_buf_printf(s, "file_cost %lu\n", file_cost);
+		memcg_seq_buf_put_name_val(s, "anon_cost", (u64)anon_cost);
+		memcg_seq_buf_put_name_val(s, "file_cost", (u64)file_cost);
 	}
 #endif
 }
@@ -1968,11 +1997,14 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
+	u64 oom_kill;
+
+	memcg_seq_put_name_val(sf, "oom_kill_disable",
+			       READ_ONCE(memcg->oom_kill_disable));
+	memcg_seq_put_name_val(sf, "under_oom", (bool)memcg->under_oom);
 
-	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
-	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
-	seq_printf(sf, "oom_kill %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
+	oom_kill = atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]);
+	memcg_seq_put_name_val(sf, "oom_kill", oom_kill);
 	return 0;
 }
 
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..46f198a81761 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -4,6 +4,9 @@
 #define __MM_MEMCONTROL_V1_H
 
 #include <linux/cgroup-defs.h>
+#include <linux/seq_buf.h>
+#include <linux/seq_file.h>
+#include <linux/sprintf.h>
 
 /* Cgroup v1 and v2 common declarations */
 
@@ -33,6 +36,9 @@ int memory_stat_show(struct seq_file *m, void *v);
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
 
+void memcg_seq_put_name_val(struct seq_file *m, const char *name, u64 val);
+void memcg_seq_buf_put_name_val(struct seq_buf *s, const char *name, u64 val);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..0bc244c5a570 100644
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
@@ -1460,9 +1461,70 @@ static bool memcg_accounts_hugetlb(void)
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
+/* Max 2^64 - 1 = 18446744073709551615 (20 digits) */
+#define MEMCG_DEC_U64_MAX_LEN 20
+
+/**
+ * memcg_seq_put_name_val - Write a name-value pair to a seq_file
+ * @m: The seq_file to write to
+ * @name: The name string (not null-terminated required, uses seq_puts)
+ * @val: The u64 value to write
+ *
+ * This helper formats and writes a "name value\n" line to a seq_file,
+ * commonly used for cgroup statistics output. The value is efficiently
+ * converted to decimal using seq_put_decimal_ull.
+ *
+ * Output format: "<name> <value>\n"
+ * Example: "anon 1048576\n"
+ */
+void memcg_seq_put_name_val(struct seq_file *m, const char *name, u64 val)
+{
+	seq_puts(m, name);
+	/* need a space between name and value */
+	seq_put_decimal_ull(m, " ", val);
+	seq_putc(m, '\n');
+}
+
+/**
+ * memcg_seq_buf_put_name_val - Write a name-value pair to a seq_buf
+ * @s: The seq_buf to write to
+ * @name: The name string to write
+ * @val: The u64 value to write
+ *
+ * This helper formats and writes a "name value\n" line to a seq_buf.
+ * Unlike memcg_seq_put_name_val which uses seq_file's built-in formatting,
+ * this function manually converts the value to a string using num_to_str
+ * and writes it using seq_buf primitives for better performance when
+ * batching multiple writes to a seq_buf.
+ *
+ * The function checks for overflow at each step and returns early if
+ * any operation would cause the buffer to overflow.
+ *
+ * Output format: "<name> <value>\n"
+ * Example: "file 2097152\n"
+ */
+void memcg_seq_buf_put_name_val(struct seq_buf *s, const char *name, u64 val)
+{
+	char num_buf[MEMCG_DEC_U64_MAX_LEN];
+	int num_len;
+
+	num_len = num_to_str(num_buf, sizeof(num_buf), val, 0);
+	if (num_len <= 0)
+		return;
+
+	if (seq_buf_puts(s, name))
+		return;
+	if (seq_buf_putc(s, ' '))
+		return;
+	if (seq_buf_putmem(s, num_buf, num_len))
+		return;
+	seq_buf_putc(s, '\n');
+}
+
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	int i;
+	u64 pgscan, pgsteal;
 
 	/*
 	 * Provide statistics on the state of the memory subsystem as
@@ -1485,36 +1547,40 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 			continue;
 #endif
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
-		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
+		memcg_seq_buf_put_name_val(s, memory_stats[i].name, size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
 			size += memcg_page_state_output(memcg,
 							NR_SLAB_RECLAIMABLE_B);
-			seq_buf_printf(s, "slab %llu\n", size);
+			memcg_seq_buf_put_name_val(s, "slab", size);
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
+	pgscan = memcg_events(memcg, PGSCAN_KSWAPD) +
+		 memcg_events(memcg, PGSCAN_DIRECT) +
+		 memcg_events(memcg, PGSCAN_PROACTIVE) +
+		 memcg_events(memcg, PGSCAN_KHUGEPAGED);
+	pgsteal = memcg_events(memcg, PGSTEAL_KSWAPD) +
+		  memcg_events(memcg, PGSTEAL_DIRECT) +
+		  memcg_events(memcg, PGSTEAL_PROACTIVE) +
+		  memcg_events(memcg, PGSTEAL_KHUGEPAGED);
+
+	memcg_seq_buf_put_name_val(s, "pgscan", pgscan);
+	memcg_seq_buf_put_name_val(s, "pgsteal", pgsteal);
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
+		u64 events;
+
 #ifdef CONFIG_MEMCG_V1
 		if (memcg_vm_event_stat[i] == PGPGIN ||
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
 #endif
-		seq_buf_printf(s, "%s %lu\n",
-			       vm_event_name(memcg_vm_event_stat[i]),
-			       memcg_events(memcg, memcg_vm_event_stat[i]));
+		events = memcg_events(memcg, memcg_vm_event_stat[i]);
+		memcg_seq_buf_put_name_val(s,
+					   vm_event_name(memcg_vm_event_stat[i]),
+					   events);
 	}
 }
 
@@ -4218,10 +4284,12 @@ static void mem_cgroup_attach(struct cgroup_taskset *tset)
 
 static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
 {
-	if (value == PAGE_COUNTER_MAX)
+	if (value == PAGE_COUNTER_MAX) {
 		seq_puts(m, "max\n");
-	else
-		seq_printf(m, "%llu\n", (u64)value * PAGE_SIZE);
+	} else {
+		seq_put_decimal_ull(m, "", (u64)value * PAGE_SIZE);
+		seq_putc(m, '\n');
+	}
 
 	return 0;
 }
@@ -4247,7 +4315,8 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 	else
 		peak = max(fd_peak, READ_ONCE(pc->local_watermark));
 
-	seq_printf(sf, "%llu\n", peak * PAGE_SIZE);
+	seq_put_decimal_ull(sf, "", peak * PAGE_SIZE);
+	seq_putc(sf, '\n');
 	return 0;
 }
 
@@ -4480,16 +4549,24 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
  */
 static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
 {
-	seq_printf(m, "low %lu\n", atomic_long_read(&events[MEMCG_LOW]));
-	seq_printf(m, "high %lu\n", atomic_long_read(&events[MEMCG_HIGH]));
-	seq_printf(m, "max %lu\n", atomic_long_read(&events[MEMCG_MAX]));
-	seq_printf(m, "oom %lu\n", atomic_long_read(&events[MEMCG_OOM]));
-	seq_printf(m, "oom_kill %lu\n",
-		   atomic_long_read(&events[MEMCG_OOM_KILL]));
-	seq_printf(m, "oom_group_kill %lu\n",
-		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
-	seq_printf(m, "sock_throttled %lu\n",
-		   atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
+	u64 low, high, max, oom, oom_kill;
+	u64 oom_group_kill, sock_throttled;
+
+	low = atomic_long_read(&events[MEMCG_LOW]);
+	high = atomic_long_read(&events[MEMCG_HIGH]);
+	max = atomic_long_read(&events[MEMCG_MAX]);
+	oom = atomic_long_read(&events[MEMCG_OOM]);
+	oom_kill = atomic_long_read(&events[MEMCG_OOM_KILL]);
+	oom_group_kill = atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]);
+	sock_throttled = atomic_long_read(&events[MEMCG_SOCK_THROTTLED]);
+
+	memcg_seq_put_name_val(m, "low", low);
+	memcg_seq_put_name_val(m, "high", high);
+	memcg_seq_put_name_val(m, "max", max);
+	memcg_seq_put_name_val(m, "oom", oom);
+	memcg_seq_put_name_val(m, "oom_kill", oom_kill);
+	memcg_seq_put_name_val(m, "oom_group_kill", oom_group_kill);
+	memcg_seq_put_name_val(m, "sock_throttled", sock_throttled);
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
@@ -4544,7 +4621,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
 			continue;
 
-		seq_printf(m, "%s", memory_stats[i].name);
+		seq_puts(m, memory_stats[i].name);
 		for_each_node_state(nid, N_MEMORY) {
 			u64 size;
 			struct lruvec *lruvec;
@@ -4552,7 +4629,10 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 			size = lruvec_page_state_output(lruvec,
 							memory_stats[i].idx);
-			seq_printf(m, " N%d=%llu", nid, size);
+
+			seq_put_decimal_ull(m, " N", nid);
+			seq_putc(m, '=');
+			seq_put_decimal_ull(m, "", size);
 		}
 		seq_putc(m, '\n');
 	}
@@ -4565,7 +4645,8 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
+	seq_put_decimal_ll(m, "", READ_ONCE(memcg->oom_group));
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -5372,13 +5453,15 @@ static ssize_t swap_max_write(struct kernfs_open_file *of,
 static int swap_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+	u64 swap_high, swap_max, swap_fail;
+
+	swap_high = atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]);
+	swap_max = atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]);
+	swap_fail = atomic_long_read(&memcg->memory_events[MEMCG_SWAP_FAIL]);
 
-	seq_printf(m, "high %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]));
-	seq_printf(m, "max %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]));
-	seq_printf(m, "fail %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_FAIL]));
+	memcg_seq_put_name_val(m, "high", swap_high);
+	memcg_seq_put_name_val(m, "max", swap_max);
+	memcg_seq_put_name_val(m, "fail", swap_fail);
 
 	return 0;
 }
@@ -5564,7 +5647,8 @@ static int zswap_writeback_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", READ_ONCE(memcg->zswap_writeback));
+	seq_put_decimal_ll(m, "", READ_ONCE(memcg->zswap_writeback));
+	seq_putc(m, '\n');
 	return 0;
 }
 
-- 
2.43.0


