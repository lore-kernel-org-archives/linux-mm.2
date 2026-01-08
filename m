Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43303CF6AB4
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 09:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75DEC6B0092; Thu,  8 Jan 2026 04:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B216B0093; Thu,  8 Jan 2026 04:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DFC66B0095; Thu,  8 Jan 2026 04:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ABD76B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:36:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1186C25A9
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:36:25 +0000 (UTC)
X-FDA: 84308291130.29.CE4729F
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id E78E8180002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:36:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=InFiAS4D;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767864984; a=rsa-sha256;
	cv=none;
	b=vwJ9o5VDpopIXultBjYpBpujC1nY8OwHVEJM1wxQ6YX4H3nbcnBtIMuxtKiJXI+w+VNqPZ
	epYdsDDRaE5eaX3tzOQpx/ULdUNfbEfiXPsNlfzdDWVI46GMk0bqTrVKvI6a8jodQxbzVg
	0p7JLyWXoiNb3VSebEaFHYZhp7TW+O4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=InFiAS4D;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767864984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=miqdi3JWBKoxNnDoIDRRY9WTssFbqfALy728r5SCWyA=;
	b=j6b0tox/fwCDHoyBGlnCyzAq8V1I22EJVobqzcYdrBtPWuqcLMP61IzrDChgZYvLmkK6sA
	MIx5/o/oaBWUl8d4B0JdiPCQRI42cgHotzwKPQ2fvNAU8HENzbVDSYBsKIKkROWzQngMVn
	+xEfLWXJWfsbhPt2we9tLZGVfd83+K0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a09757004cso29821155ad.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 01:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767864983; x=1768469783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=miqdi3JWBKoxNnDoIDRRY9WTssFbqfALy728r5SCWyA=;
        b=InFiAS4DKhCQUU7M+7ZvOgKa5uRLzHE8Lk7CM9p8MKVQZn9Ejwko9yfwAo+wGZFJHJ
         R2aZi2GfghRXCYsZoYqG6dvI5dwI351Ds/MEVOleP+Q7f6WoBdCtLksNJ6VUOKelQYup
         CqxDnThJ3fi4W9F5j0Z8nRc8uabdXZqqF7NkfLFbPWDpz+9hE88us/GYTkcHNbpIw272
         ixjJnkXfzpQzbnhxDnSGnwHednYsw9O1go8zH40aJJtwATOEz25AcGkFUaJDNunvAXfg
         kCCKRKmP1GfiD3Gxb/7W+AqCDSVHtKKILhKoLmDpD2gMKxH0FhHO+nJ5UAvjY6rcjFF6
         rkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767864983; x=1768469783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=miqdi3JWBKoxNnDoIDRRY9WTssFbqfALy728r5SCWyA=;
        b=nDybJA/DWAaNemjEnhW/aXjqo4S0S4dchKlK+IG31fpGZqqXYjO45P8xX/jX2p9UJt
         CdSRIiZh22QublRqeElStGu+/kY/zUUUDDvontsp5TsSFaTc+SdNDtsJYBIlDQUyFTRf
         /AnH+ihJy6CWE6UWJV/LxVyh/zZicyut8a9BQc3nNqZYQZrv1nBW42VYfUXr/Mrbq2CC
         u1VMODuJuJEXypOOYpN3JL9wQI2yEGFlSfXhy0f9K4AyNxrQYCFpNCUJhj3Qdmyr+R16
         6sTOzWbWZNbun5aMjgNCxk7pFQj3gchlWJ5AI8vAClXq8a8FNKcF06cIfRu8HxM0dUFD
         N1dA==
X-Forwarded-Encrypted: i=1; AJvYcCUO3+61J6lxzuuc7E53KiOENS03Dc1KSdGYBSRqeXPeKz6FkE7rDBYMhy9E2rCPaHIxfEEYNK/Vlw==@kvack.org
X-Gm-Message-State: AOJu0YyNhZ+kCUUSOq83AjWmUwlqZNbNnwNxutXm+RJDpHv0ZhUR6DUc
	5rhXtKFw51U4gN4zX7JFXn8BZNPJv2y6tf+UWurU2hJqXKAbRkKdqCeT
X-Gm-Gg: AY/fxX4KWBsuUL5Um8hhMzQwVY4tIrrRDy0NBZ+kvwhnM9/zy3ZdLOsPOgCVJA3Wyxt
	Oz8BuvcXIoSXel7oQzdnQPHV7R7OTL6i5HHSw+h5ZBCXRmtieiHPgfo9433uD+biCPlv0KLFENL
	vM44T71orKW1McoRvI3QgI3VWAMU1Y8AsZ6MBj8K4szpukMmHz2pVB91Rp3g1KZ+Uw36ay7v7ag
	Y88VHiJLbZdFc9Mxb/NulNOynlB5BDnXRG+T4SPpLATn6MIPRKg5YeWGjLuWOAMz45Ek5Ko+NQE
	w8TdqQcKxrcDCcviAeGb0MV8v2x08d6uIABgFmdQ5U9+V9hfAC0hQEbM7/1QwwVAGuRDq/jtYXW
	oHtOANXL6OTpQ/uo5vleNa2DCzAaSqrbqdkQRfNaYk0UfvULzdcz8g9pRTcN4OSEgr4wmMzhXCV
	9viQnmrssAdHUohUnKAlYwmlI=
X-Google-Smtp-Source: AGHT+IHSReaBoY0payJlLNXxYuXOcysW/4kuuotsiPj+TOOyIlWaCgj/F8BpW7CjLFi/EpDUUEbMPg==
X-Received: by 2002:a17:903:1b4c:b0:2a1:3cd9:a734 with SMTP id d9443c01a7336-2a3ee49cfc7mr47710045ad.43.1767864982383;
        Thu, 08 Jan 2026 01:36:22 -0800 (PST)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3f3115682sm37460985ad.55.2026.01.08.01.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 01:36:21 -0800 (PST)
From: Jianyue Wu <wujianyue000@gmail.com>
X-Google-Original-From: Jianyue Wu <jianyuew@nvidia.com>
To: jianyuew@nvidia.com,
	hannes@cmpxchg.org
Cc: Jianyue Wu <wujianyue000@gmail.com>,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: optimize stat output for 11% sys time reduce
Date: Thu,  8 Jan 2026 17:36:02 +0800
Message-ID: <20260108093610.212023-1-jianyuew@nvidia.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E78E8180002
X-Rspam-User: 
X-Stat-Signature: gf13o1yzhpkaohwm7mbcfwd3sfx7ezwo
X-Rspamd-Server: rspam07
X-HE-Tag: 1767864983-425619
X-HE-Meta: U2FsdGVkX19o2oVLOt2IlEVi46e2O5HK0t9rA3S3BH/3o/M0Mgybx6wym8Su4AeRmdREQbqsOSJ5Qepivc34YVXfHS6rZN7e/JofKFEAifq9gmlFKTMRK7kwmlzjhF55WmVZnKArswiOzEJdBtLoonsjlYj3oulg7uW7ZLmyVyjv0SYcPK5rTvWB6KjiweOKQ6Iv7t3digh+S6cg7wNfAS03V8GK3ZgIfiHM/TcgoHW/eShAzgo4LhGI99HbouVntVPvZ38m04t8gndmeiT0rQOARXOG98eH+CXWhclM9eEaRQJm5Wvb79FiuhHtVW+8pn0/1swwXf4qCEleRcdDDjXmn6vivLPhxxXen/7sb4gKIcsMcosGBYFTXPCfkBfr5MtgZ90wXpdx60aqNwBBW7gQkSaYVfwq4ZrBpTW5LTV7FPePFPHPQqlalvkK5o21UGsYkGkmf/MET69ySlUMpdoEus+6q0dByxCcuK/obEBe7U52nnNbqo0OyiHoFF7EUBJ0AxhW1qGh3VgnEyt8LUe1T8tSI9wn7Lb+mnQYjy+vOnLcmzK8mD2ENvp9vkQw9upQLzTCPxvR1ul4YDr+xf4g9vXu3tLQsTf55DnvxQnwvaUHk1ik9ncn+tSZ51a61YGsTJwh538OQ4XRsX1RIPfKzOPFw1tAMCZQ5qMbdaGDBa17pmOR3mkttG745WjAMrC++UL64h9lkTMdHzGNc0XN0SzzoJg1ZFDcvKUt65GggKasAKWkJkKu8jvr7wS9QNjbsvFoekH2gbrDSpzKjPjtqJevCkxXyheDDQ/pHTZPUWzu/eczI+QCHMz1Mj4Dizzjp2vwWO951698RkoDPM7vhG7eeMHvrdrMgM8J549O1HTWQaz6nVB5hMUT4DlwqgtIiQHcWNcPfEY5NGHVyF5Ht3kx0RoZrGsmTd0qIe0nsWDwSIv2PydIP5gAs28RQDb8jeyQ5hKg8+plCVb
 Ju5Kmg6x
 M4hM7U38Z0vXbzWQU7yUAi7cxe0n93tyfHLB7/knVUmXJFZylIx2GkZYp6EESK+S+nFBmOMDsOcaM8RV8f8JUpGuIYxgwk1MTlSEHVoohWqNRxwZf6M/uZ/BFA5ONMYiRk89ND5U6LFYFezrse8eDTB+YNKwnXIGaPFvUUACfVbRMiiinB2IBF8pegRSx+siXM5x2gHMH7zH+0HLQQE6o9+MGLwspYZ+ZVp4kc+lzLC26iBLAn1IBtpy9wI4EZnw60ecDgRmKkuS/rcqA7yK1ZXmxV4b3bc2aPZg5lRUG0T+532V74w+bvxL1Tg6RdcCKr4AbBAIXhpOB4GRLcHmf4UWvFQW7Rv64Tr08T20YfBaxxIZoP6TDGhOUctRDWAuuO0BLph0Tyj3tTxsJEdYlU2C6fbsY4vvSxqdNmPqn3UaHaFr/24+cF9MTgyIjzaxFmluCryAtPv4VuBI=
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
Signed-off-by: Jianyue Wu <jianyuew@nvidia.com>
---
 mm/memcontrol-v1.c | 97 ++++++++++++++++++++++++++--------------------
 mm/memcontrol-v1.h | 34 ++++++++++++++++
 mm/memcontrol.c    | 87 ++++++++++++++++++++++-------------------
 3 files changed, 137 insertions(+), 81 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..400feb798aec 100644
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
@@ -1795,25 +1795,33 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	mem_cgroup_flush_stats(memcg);
 
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
+				    (u64)mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+								  false));
+		for_each_node_state(nid, N_MEMORY) {
+			seq_put_decimal_ull(m, " N", nid);
+		seq_put_decimal_ull(m, "=",
+				    (u64)mem_cgroup_node_nr_lru_pages(memcg, nid,
+								       stat->lru_mask, false));
+		}
 		seq_putc(m, '\n');
 	}
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 
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
+				    (u64)mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+								 true));
+		for_each_node_state(nid, N_MEMORY) {
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=",
+					    (u64)mem_cgroup_node_nr_lru_pages(memcg, nid,
+									      stat->lru_mask,
+									      true));
+		}
 		seq_putc(m, '\n');
 	}
 
@@ -1879,17 +1887,17 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		unsigned long nr;
 
 		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
+		memcg_seq_buf_put_name_val(s, memcg1_stat_names[i], (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "%s %lu\n", vm_event_name(memcg1_events[i]),
-			       memcg_events_local(memcg, memcg1_events[i]));
+		memcg_seq_buf_put_name_val(s, vm_event_name(memcg1_events[i]),
+					   (u64)memcg_events_local(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "%s %lu\n", lru_list_name(i),
-			       memcg_page_state_local(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		memcg_seq_buf_put_name_val(s, lru_list_name(i),
+					   memcg_page_state_local(memcg, NR_LRU_BASE + i) *
+					   PAGE_SIZE);
 
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
@@ -1897,28 +1905,33 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		memory = min(memory, READ_ONCE(mi->memory.max));
 		memsw = min(memsw, READ_ONCE(mi->memsw.max));
 	}
-	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
-		       (u64)memory * PAGE_SIZE);
-	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-		       (u64)memsw * PAGE_SIZE);
+	memcg_seq_buf_put_name_val(s, "hierarchical_memory_limit",
+				   (u64)memory * PAGE_SIZE);
+	memcg_seq_buf_put_name_val(s, "hierarchical_memsw_limit",
+				   (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			       (u64)nr);
+	nr = memcg_page_state_output(memcg, memcg1_stats[i]);
+	seq_buf_puts(s, "total_");
+	memcg_seq_buf_put_name_val(s, memcg1_stat_names[i],
+				   (u64)nr);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "total_%s %llu\n",
-			       vm_event_name(memcg1_events[i]),
-			       (u64)memcg_events(memcg, memcg1_events[i]));
+	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++) {
+		seq_buf_puts(s, "total_");
+		memcg_seq_buf_put_name_val(s,
+					   vm_event_name(memcg1_events[i]),
+					   (u64)memcg_events(memcg, memcg1_events[i]));
+	}
 
-	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "total_%s %llu\n", lru_list_name(i),
-			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		seq_buf_puts(s, "total_");
+		memcg_seq_buf_put_name_val(s, lru_list_name(i),
+					   (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
+					   (PAGE_SIZE));
+	}
 
 #ifdef CONFIG_DEBUG_VM
 	{
@@ -1933,8 +1946,8 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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
@@ -1969,10 +1982,10 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
 
-	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
-	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
-	seq_printf(sf, "oom_kill %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
+	memcg_seq_put_name_val(sf, "oom_kill_disable", READ_ONCE(memcg->oom_kill_disable));
+	memcg_seq_put_name_val(sf, "under_oom", (bool)memcg->under_oom);
+	memcg_seq_put_name_val(sf, "oom_kill",
+			       (u64)atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
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
index 86f43b7e5f71..62652a3c8681 100644
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
@@ -1485,26 +1486,26 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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
+	memcg_seq_buf_put_name_val(s, "pgscan",
+				   memcg_events(memcg, PGSCAN_KSWAPD) +
+				   memcg_events(memcg, PGSCAN_DIRECT) +
+				   memcg_events(memcg, PGSCAN_PROACTIVE) +
+				   memcg_events(memcg, PGSCAN_KHUGEPAGED));
+	memcg_seq_buf_put_name_val(s, "pgsteal",
+				   memcg_events(memcg, PGSTEAL_KSWAPD) +
+				   memcg_events(memcg, PGSTEAL_DIRECT) +
+				   memcg_events(memcg, PGSTEAL_PROACTIVE) +
+				   memcg_events(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
@@ -1512,9 +1513,9 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
 #endif
-		seq_buf_printf(s, "%s %lu\n",
-			       vm_event_name(memcg_vm_event_stat[i]),
-			       memcg_events(memcg, memcg_vm_event_stat[i]));
+		memcg_seq_buf_put_name_val(s,
+					   vm_event_name(memcg_vm_event_stat[i]),
+					   memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
 }
 
@@ -4218,10 +4219,12 @@ static void mem_cgroup_attach(struct cgroup_taskset *tset)
 
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
@@ -4247,7 +4250,8 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 	else
 		peak = max(fd_peak, READ_ONCE(pc->local_watermark));
 
-	seq_printf(sf, "%llu\n", peak * PAGE_SIZE);
+	seq_put_decimal_ull(sf, "", peak * PAGE_SIZE);
+	seq_putc(sf, '\n');
 	return 0;
 }
 
@@ -4480,16 +4484,16 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
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
+	memcg_seq_put_name_val(m, "low", atomic_long_read(&events[MEMCG_LOW]));
+	memcg_seq_put_name_val(m, "high", atomic_long_read(&events[MEMCG_HIGH]));
+	memcg_seq_put_name_val(m, "max", atomic_long_read(&events[MEMCG_MAX]));
+	memcg_seq_put_name_val(m, "oom", atomic_long_read(&events[MEMCG_OOM]));
+	memcg_seq_put_name_val(m, "oom_kill",
+			       atomic_long_read(&events[MEMCG_OOM_KILL]));
+	memcg_seq_put_name_val(m, "oom_group_kill",
+			       atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
+	memcg_seq_put_name_val(m, "sock_throttled",
+			       atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
 }
 
 static int memory_events_show(struct seq_file *m, void *v)
@@ -4544,7 +4548,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
 			continue;
 
-		seq_printf(m, "%s", memory_stats[i].name);
+		seq_puts(m, memory_stats[i].name);
 		for_each_node_state(nid, N_MEMORY) {
 			u64 size;
 			struct lruvec *lruvec;
@@ -4552,7 +4556,10 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
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
@@ -4565,7 +4572,8 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
+	seq_put_decimal_ll(m, "", READ_ONCE(memcg->oom_group));
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -5373,12 +5381,12 @@ static int swap_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "high %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]));
-	seq_printf(m, "max %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]));
-	seq_printf(m, "fail %lu\n",
-		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_FAIL]));
+	memcg_seq_put_name_val(m, "high",
+			       atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]));
+	memcg_seq_put_name_val(m, "max",
+			       atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]));
+	memcg_seq_put_name_val(m, "fail",
+			       atomic_long_read(&memcg->memory_events[MEMCG_SWAP_FAIL]));
 
 	return 0;
 }
@@ -5564,7 +5572,8 @@ static int zswap_writeback_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	seq_printf(m, "%d\n", READ_ONCE(memcg->zswap_writeback));
+	seq_put_decimal_ll(m, "", READ_ONCE(memcg->zswap_writeback));
+	seq_putc(m, '\n');
 	return 0;
 }
 
-- 
2.43.0


