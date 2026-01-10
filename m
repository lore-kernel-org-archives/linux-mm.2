Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04E3D277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5310A6B00B0; Fri,  9 Jan 2026 23:23:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505856B00B3; Fri,  9 Jan 2026 23:23:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432116B00B4; Fri,  9 Jan 2026 23:23:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5216B00B0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:23:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C39694B579
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:23:03 +0000 (UTC)
X-FDA: 84314759046.22.B1C13B0
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0FBEB1A0006
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:23:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WoVrvDAS;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768018982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZuGajgbOhtllK5iA/JMNyngOQnUdopOuJRy7LIg0oag=;
	b=1kVsQ9ayoRSW1biqG98jz/wigLL+PG1QvLec3hLfk45nP2p96SdSc/oMgU22c57qdigA1y
	H2FhBHvezYwc8HNiatUBhl7BjC/9zV5bEn+JeHI6K7oezTRs8XBnDCpd+SfJhCdOZFjGnA
	EENWiTKgbrDs9XEGwWjss+02aXUKUew=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WoVrvDAS;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768018982; a=rsa-sha256;
	cv=none;
	b=PUDU1gWbOcgoT6fCxj9ZNa84ZOzyg3IAi532A6zk5VUJq0roCO20IbFJvC8TNn/Iey2ffJ
	AzQp3+9DXoRtzv1LwmzT65G8M9Ngair33A0dP/ADFSRSD3ry5YJbg2HlnLD7NNe/BCkWhH
	VwzeyWwCGx9LTfBYBOSR/2rOiWy/dLk=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a099233e8dso35592225ad.3
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 20:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768018980; x=1768623780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuGajgbOhtllK5iA/JMNyngOQnUdopOuJRy7LIg0oag=;
        b=WoVrvDAS6KHiSUnM4sEZTXeOHFdWPyFa1kFHj0k5U/ResH02/G8fxEnxc0/NuO+MON
         efw7IWwNYwBxvF5GVcHnAUSNCfb9CcBvcE2t0m2nrOt4DfaTtiz1pG9Jl2ydEsSWs6wT
         DW8eI+YI9Gs0z5uDE/4w7LvFiDZaSUMs8vwuvqGCoaICNLNGl1J3AGlAvXK6302Pa3iC
         5WSFdKrOVn0zMfJVQaf8A28lau0POqoAYdWbf4nxI++R+84H2pzLqZzIXg1BvGdkF9Vz
         lHWhHAULjCZLd9V+8iWJQpKfeJLwKZRpD6v1LPRc9DXNyX7qRf179aryDWZeXyAzB+Ty
         AMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768018980; x=1768623780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZuGajgbOhtllK5iA/JMNyngOQnUdopOuJRy7LIg0oag=;
        b=HeXlLYWpyfNOETCemotKRbIlZi7kTQapGEpcdOnmdEmHwPiLAFtw7SuY9dEsiAmdwx
         nFGeo4e1wsG19BhH8xF3q06PbF8HrHuIK9d5un9N/Ny3QUgFHw6kbe4yElaMX5OyBvPY
         DxYhBrxlKfV03wLye4nbl+QrZbQrz0sRQQbxxh3vQ/abwe4uyZ+aaCBJsOm1YrZRtFLU
         7R/vBvv2SXu9/EsPyN7heZnFJqzx48/5YQBczzJblwRzraoTV2/jMv2+QaZMCrVHO5/n
         OnkcRiLe8V7yfK9XOF0lYXqnFLlEyuF1WHLpYTyutSR5YKCdmjc3GoZ3uFVElNtRapgj
         jHZQ==
X-Gm-Message-State: AOJu0YyjaZFN3Xb6AiRuO/fJLeOqOPIKWhOtQjdUiYPtoSUNDrggK4hb
	3nWgM9yELT0KjhyGn9bjmDxcMJB5RjEpFzjgUUMNVk5ABGNqzZ70Iz713ljeCYa/
X-Gm-Gg: AY/fxX6j08+yhPsINHbzrBaeosurToPifNswnRhK6NCs0w2H+3xB/T0OoAJXDtlqouy
	ew6zwS9jOM3Pc5RaeyW42bHQ1AN8ugzwvCcoHf47JLW7R/O8arCH1MMYKEyZu4GfE7rK9FQOF4H
	xB+edur+tqyunljk6p1hjpm83MLUdQ+CMVW/54l0RNYhlFUTUGanfzPjaHg4FNTnLaKbniglUwb
	kZw6IeMPw707SBPj2mHPb8vHPZBL8wK8YaK/Mhkn3wRG+OKrFAsh/eQon3YQmMipDcO3capVU5r
	Trh7dGUcSZCGQq0UlwKXXk8uB06iWdRDcRQPknrcWjmbQe6sesuetpX2J+wZ9AiMTJBhLLgsnXV
	/V+Bhl2bVSVVBxLC5mXv2WANfyi+ApGNBd+j7iraWhrLTvuiZd4nWt14Zzdzj08tilMev1Sr77Z
	SOgAh99pbPIzMlSg4AYZY7Tlw=
X-Google-Smtp-Source: AGHT+IHOi+Z2IIX+mSe99ACWUS+CbiL3EtzLQMARp/J1Q9VpYjl9eOEvoew72+57710MLHfqzWZXWw==
X-Received: by 2002:a17:902:cf05:b0:2a0:97d2:a264 with SMTP id d9443c01a7336-2a3ee49015dmr104360085ad.37.1768018980237;
        Fri, 09 Jan 2026 20:23:00 -0800 (PST)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd4401sm119131145ad.92.2026.01.09.20.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 20:22:59 -0800 (PST)
From: Jianyue Wu <wujianyue000@gmail.com>
X-Google-Original-From: Jianyue Wu <jianyuew@nvidia.com>
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v2] mm: optimize stat output for 11% sys time reduce
Date: Sat, 10 Jan 2026 12:22:49 +0800
Message-ID: <20260110042249.31960-1-jianyuew@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
References: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0FBEB1A0006
X-Stat-Signature: kfy51nngduy7gddyd5k1zrtoa733t4ot
X-HE-Tag: 1768018981-350607
X-HE-Meta: U2FsdGVkX196iPWavu9TF68a8ohncfJ+p6vlfn/wbSeGOJ/s5QNG1+fhNom2nQfy2tHkj/Nos8zu1+JC/VJMaOjwpiiVMkG3Vq9VoPb43Z5emLrjcX16pJAbCr/DsBITeJRD9Qia8b0zkW+PGgULjowh1XubqOEfW8vbfX03sVFdA9mSKRHKSCErwE0ixNjo5I1tC39BLvhDDHHDMVu3Sc977JxI7vEkPCOykBVRgF9FrOiTmoPsr/y2HTzYsbd7vPmJe27z3MvC1cbavn03ogDUd8R8JTFFCfQTQyQC5d309UVrWL0tzQq0nIfa7/SCjfsklNchvcwPLArF93CVRMTVOsLF5M0KHgl1O4tusBGHZONo84RjCVhJgFmtSUjrHvljaYjYqnmYxiF31DQTvxElNNQ0KGRAU1TJ1PE6bl4q3O9Q/CrWimjMPzeJtUbLSMIsC+mgn7mzeBX066RiLzbijGRB9z6ISf9TFFTrAJsSXY1uT5TTpADEf4vF/wx2I0rbzrTt5pQ6khSJaD6/sqxp3ueZXwvtyOyT3O5DVwgg6F8/tTLbselRp+k/RXVK4AEoXigHk8OFXWzXto93eQTfw0JFKVfjnia/fsdEQZoRgYTVg7A2qXbzqy67ARJkNY+E57iCfsOGUog4vF3qzHt604l8b9V8KG0jFowW3RwHhu/02c6ly/do3Twpl09mOKfXDeSmEt60nV2GNSZK/cRkJ2TVwQYR3UZjXu1BDvAGy7D1mDJg8GCqBf08RGD335kIHZ7UY3BstqTMi9KgRW2A7+gBbPtcJyYkF5bCGiJ7VdlRTBKJ98ckg4Zl4tQSGbdMbU39VfEbZjJ+ONR9ZqKBf1JJ8rtnD/Dkjx+KR9UwbkKQubUzdARdGHztgdS1MWoXdAaxvdEvF1YKZgUqTyUmIbuJGtwXQJ8RyWc950MGibKCri2kusu1ruPONOTj65ysdoy15ieIC3N84D5
 lAWdKjro
 UzEkjJIvDzrL6b0Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jianyue Wu <wujianyue000@gmail.com>

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

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Changes in v2:
- Fixed indentation issues
- Added local variables in helper functions to improve code readability
  and avoid overly long parameter lines

v1: Initial submission

 mm/memcontrol-v1.c | 120 ++++++++++++++++++++++++++++-----------------
 mm/memcontrol-v1.h |  34 +++++++++++++
 mm/memcontrol.c    | 102 +++++++++++++++++++++++---------------
 3 files changed, 173 insertions(+), 83 deletions(-)

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
index 6358464bb416..a4ac2d869506 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -4,6 +4,9 @@
 #define __MM_MEMCONTROL_V1_H
 
 #include <linux/cgroup-defs.h>
+#include <linux/seq_buf.h>
+#include <linux/seq_file.h>
+#include <linux/sprintf.h>
 
 /* Cgroup v1 and v2 common declarations */
 
@@ -33,6 +36,37 @@ int memory_stat_show(struct seq_file *m, void *v);
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
 
+/* Max 2^64 - 1 = 18446744073709551615 (20 digits) */
+#define MEMCG_DEC_U64_MAX_LEN 20
+
+static inline void memcg_seq_put_name_val(struct seq_file *m, const char *name,
+					  u64 val)
+{
+	seq_puts(m, name);
+	/* need a space between name and value */
+	seq_put_decimal_ull(m, " ", val);
+	seq_putc(m, '\n');
+}
+
+static inline void memcg_seq_buf_put_name_val(struct seq_buf *s,
+					      const char *name, u64 val)
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
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..52dde3b8e386 100644
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
@@ -1463,6 +1464,7 @@ static bool memcg_accounts_hugetlb(void)
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	int i;
+	u64 pgscan, pgsteal;
 
 	/*
 	 * Provide statistics on the state of the memory subsystem as
@@ -1485,36 +1487,40 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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
 
@@ -4218,10 +4224,12 @@ static void mem_cgroup_attach(struct cgroup_taskset *tset)
 
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
@@ -4247,7 +4255,8 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 	else
 		peak = max(fd_peak, READ_ONCE(pc->local_watermark));
 
-	seq_printf(sf, "%llu\n", peak * PAGE_SIZE);
+	seq_put_decimal_ull(sf, "", peak * PAGE_SIZE);
+	seq_putc(sf, '\n');
 	return 0;
 }
 
@@ -4480,16 +4489,24 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
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
@@ -4544,7 +4561,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
 			continue;
 
-		seq_printf(m, "%s", memory_stats[i].name);
+		seq_puts(m, memory_stats[i].name);
 		for_each_node_state(nid, N_MEMORY) {
 			u64 size;
 			struct lruvec *lruvec;
@@ -4552,7 +4569,10 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
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
@@ -4565,7 +4585,8 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
+	seq_put_decimal_ll(m, "", READ_ONCE(memcg->oom_group));
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -5372,13 +5393,15 @@ static ssize_t swap_max_write(struct kernfs_open_file *of,
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
@@ -5564,7 +5587,8 @@ static int zswap_writeback_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", READ_ONCE(memcg->zswap_writeback));
+	seq_put_decimal_ll(m, "", READ_ONCE(memcg->zswap_writeback));
+	seq_putc(m, '\n');
 	return 0;
 }
 
-- 
2.43.0


