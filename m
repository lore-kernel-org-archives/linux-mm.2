Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B0DCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DC48E0139; Tue, 14 Oct 2025 10:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E398E010A; Tue, 14 Oct 2025 10:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117158E0139; Tue, 14 Oct 2025 10:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA8DE8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:50:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA8715BDA4
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:16 +0000 (UTC)
X-FDA: 83997005232.25.490F0B6
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id C7EBE4000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nYfnMevU;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaKsUlhHVYzGr/qaa9OrQYufYtYEbalh3sXBUEUgogU=;
	b=FyH9qb+4mtNmriVmvWCe84ZkKOu7DznkV9dpvekLhjwatrWaAe5W5VFbYESAYdFjwten6J
	Dyh9+9WRBcWPx9+D7FNVAAULUzI29tYrxElLZN2PJLR4mr2AtXTuPB5N1L34XykQQmWzQ8
	xUskEw7RDgdgWCHv6DfaIw7/s/GAhQs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nYfnMevU;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760453414; a=rsa-sha256;
	cv=none;
	b=N8X+XevE+Iq1Ch3QMgaYqIhzBlmQnhey07vmzvcJwKVLlske5j8sfB7QLYUzd8vAQKRh07
	DiWcvezhYNYsOkaSQmJMR52mH1KptmXKMc0/JvlhrvUc9FCHKLJ6xWdaJs0tzkzU8+/m3n
	vpJ7cuGnWjp6nsnZ+49J/kdPOcoy3K0=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-749399349ddso64822357b3.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760453414; x=1761058214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaKsUlhHVYzGr/qaa9OrQYufYtYEbalh3sXBUEUgogU=;
        b=nYfnMevUmB30Dei3nLG5W3iF/NKxju2EBWm8x3fBR295C6J0vu81EN9g1jnMG6/bEb
         XQSx5gYZJ/0pFImECvfD6CsPwa00LTyYcE7+6gcEt6AxpDCGndPAzaqjIFtvRO22jQkO
         tqmCUYljWPI80nT/C0j89QS+FhxiQyBBarcotOLxWjolSaea/gH0tsoF8cZru7SygNmP
         YJm0SjawazzmvsGQipIYJSPZg56uzrWJByF/p9WQW2FlQuMCBAatQKtn8pTtqR76+T7E
         8Xux4pA+qikZQUKO8yt3YDVAvcILlDKM8n67LDD8s6bOCcn3QxkdEM1tG6yy61Bxnbm+
         x0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453414; x=1761058214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaKsUlhHVYzGr/qaa9OrQYufYtYEbalh3sXBUEUgogU=;
        b=wnS1hlhTf2uILvtSgcAZUvav3hbelXnuyA+nnej5OHB90QDQUnTMvSI8ldclao09mr
         M8QLMcJS1huOIosJeFIG2BPhXKXiXoNlg4lLFBno1pFevZwIX4IqeZZIa12MpRxh3rf0
         E33VOsg9kN+zCOeScQcZlkHX9kutUU6DTibA0uUkoG+de7Mp5drN7W9n2TauEp5Ab/LY
         MIpOMwaiWX7CSgnncWno/opXzY6kc5EIUR6sQK9mLLb9i8T1t6D5U+Quk2bkrW4i8p7U
         jqegPZzkfH8DOxQ/2kAd9OfBiMMK/Tnv5yQuCrVUrr7ZrURwvneADhKY5Xwxs5bCmSQR
         g34Q==
X-Forwarded-Encrypted: i=1; AJvYcCUtrJ8tKPY5pk56L1yM1a13iWkY5myxFSVVhuk0DSIshrVnfGmwKuRxRmHkxm6B+5fZdfoeA4ZcQw==@kvack.org
X-Gm-Message-State: AOJu0Yyph3GoMuxBRguW5yF576RyP6Ax1WClWwT5PpL2Gk8RtLFfKtDM
	wbgVeB05Prvlp8IwrMXk88vLezftZ24zMpm1hL631/1TqZD6X6SrkyNe
X-Gm-Gg: ASbGncuJ9FDturErcSuBDvwHIALsaBWiORaIe1nFJP/TpEpS+ouHTrFUaZG86qrxNln
	R9JBVhb4eo9Cp1HT4DzJwzdDXl1EEWxOWd0/7Ig0Zvr3KB4jEKJ+ieg7PPkxDvGimQ+AzRR2OWA
	WTwK5Si+U82HWqcvRpz1dI6z5QNtLm2J2r5f8oJriEovYyle4RY3JUhBsp/TO+8N80mNqi0uQ1p
	Ccw+R2b9p8nACKOWHmTaNhAdtmqk3pkhyr8mhgoiRbtee328JSgP253dYMqmu/uepxhosL0YKdm
	MoEtBGVmtgk9KBERQwa81nhMDzanOgOxTQwgEpOn+Bf78leztqUskpE5wM5TyfdKbvkaIP1JTtW
	AdZ/eViulQGSc4m0v2b5hizZCoYF2rYZ7V5ily0outjWtl08HSKF6Yj/7aRFbqFsq2TwQVWd0L6
	18NEfeWwmm
X-Google-Smtp-Source: AGHT+IF24AJ/mCnHHT8gWUZWqNOL84P3lZeFu7B9AvcqJEw2IIOt8BRDcj1YLWF4MZHoT7gLYf+rwg==
X-Received: by 2002:a05:690c:3687:b0:781:5636:c1fb with SMTP id 00721157ae682-7815636c367mr7065537b3.38.1760453413642;
        Tue, 14 Oct 2025 07:50:13 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:56::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78106e34136sm34138527b3.25.2025.10.14.07.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 07:50:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v5 1/3] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Tue, 14 Oct 2025 07:50:08 -0700
Message-ID: <20251014145011.3427205-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
References: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7EBE4000D
X-Stat-Signature: onmhsmtsqj8r97xh9zi1jn3d73ifz3ga
X-Rspam-User: 
X-HE-Tag: 1760453414-487412
X-HE-Meta: U2FsdGVkX191Prv21q5261oQLKhrvIULFUtp6Z2yjfCpIKlDHvRvNqKX3TzFIA0MLQrr8jJQnS7rdKig08QgId+p4HwJAeRcZ5cPn3TnFeWRdjeb32hbRVLxX92Gj3EQFU7109hsh8yzuxICtRmnHQCCnya6zFe0qZnSTgQihb2OEN23ws2jXkWzV63nugztaiTURA2aZQBJkUHzH9Wx9lVOYufGkbZo/CJ7AggAdvQoAW/tgyJcnMeNGQlXwudwsFCxHP8WL3Mg0UMMB6jf6SUPaNFTFkwKbmpyoXBVS73aXLwBPt9HZhODlcMmOug0kVAI68W6lH/cb29DB5T9xBjYDIFLSla7BNr0MKedkjBXyGs/LcpmSJ7M0gpbGlR39Fz+eJ7hXuR4kudvN4p7qsCgXgfAHC12ZQT0gMYm2SoXGYqeR7MbKCTAzKY3Q6nSA7yGOGZPEgzoyvEJl8qtSk9wmlBmiSyuaST8WiLybF98ZDKmJpixQJzmqLn8L79K5o9eDOBbB6tsoJd1rUX6CcMWcp3S93rRxLc21SXwvfmKUG5ngkEe1XK07UfxuOVV2oDDcSX5GZHf5XEfngvpYphitlktrNu+QWF9CiXaBKMGyhtGn6BKWkPn8MmcmPd7kykZ4LIV+dRFXKCN7XU2vR6u3Pig1lwQVWG2CPUidcoCqTVWwYK3i5KR9asJJ4Ayzt7kgv3Gy5qHd1GeK+yhmqamn5fyUuKRlA/OboBNd3ZqJnvQn6l07CXnb+FfyYVW7/h86Kb7oRSm2CH56DGohf9WWbu9r0eA2Fde7Ig703gXCVYntKgHlZ50Cj+162CshHlv/BHDaCUTPpvKXn/QyTrvLClb1AhvHhZgl4m/JS+0AnEJBxFzU/Lvi+EcmCOT1ATFUlHZjRmcBQ3IGkhZBKJM9jyiFfq7i8xt7Q5byJizgVE6stjNHjk987ESX5YbgzS8ao/u2qyGgZBeueY
 fge1pURA
 ua8AFjhcEMqzP3up8E879zoMZZz1rTcWTDkme4+ZZizayW3tVBQJnLnsH4p7T7o1wEz8YmjwGXMT7juHecp1mro+cJkhSCJWwG/i0WHTXFt5RyYuop5vTko/jUVh0sQ4N3mlOr4rbQGI8/ZIjG4JXMRh7WJFBo1UMK7aO8HGUttbi64PkvPmrRvZBuM1WVpqDNxECfdSil+mt5OMse4hPUEdBdptk4Pm8bA0vIltjSuh4/ZfzttFdtKM7rj6YOmjttOUGUp85SrZGv+RI1s+iff6dvX5fpg6Cd5yeSYGegtieK0w+riJgWoOo31POOnssogTdA64aITSMeV5KBAbdGjvQMjBC6YlPM1HhGuP4Zd1IhEvuuWO0qDzC6W7QwqoSpwD2q+blg8XrvaMqbHD+xjXvCfNXnsyCZ7dj/cPOuVyTucvyGPnwMzxnfrPI5q/pLppH2jJixFkL2rXYjhcUC6WitzNxKdYBfD06GrKuWEZ4A6n4j8K2b6b/POl1fO2muo4kSFpP0X7iMc+fwJcgII+Psdqv7eDY1i+R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, refresh_cpu_vm_stats returns an int, indicating how many
changes were made during its updates. Using this information, callers
like vmstat_update can heuristically determine if more work will be done
in the future.

However, all of refresh_cpu_vm_stats's callers either (a) ignore the
result, only caring about performing the updates, or (b) only care about
whether changes were made, but not *how many* changes were made.

Simplify the code by returning a bool instead to indicate if updates
were made.

In addition, simplify fold_diff and decay_pcp_high to return a bool
for the same reason.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     |  8 ++++----
 mm/vmstat.c         | 28 +++++++++++++++-------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c..f46b066c7661 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -386,7 +386,7 @@ extern void free_pages(unsigned long addr, unsigned int order);
 #define free_page(addr) free_pages((addr), 0)
 
 void page_alloc_init_cpuhp(void);
-int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..bbc3282fdffc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2557,10 +2557,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  * Called from the vmstat counter updater to decay the PCP high.
  * Return whether there are addition works to do.
  */
-int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, batch;
-	int todo = 0;
+	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
 	batch = READ_ONCE(pcp->batch);
@@ -2573,7 +2573,7 @@ int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 		pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX),
 				 pcp->high - (pcp->high >> 3), high_min);
 		if (pcp->high > high_min)
-			todo++;
+			todo = true;
 	}
 
 	to_drain = pcp->count - pcp->high;
@@ -2581,7 +2581,7 @@ int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 		spin_lock(&pcp->lock);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
 		spin_unlock(&pcp->lock);
-		todo++;
+		todo = true;
 	}
 
 	return todo;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..98855f31294d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -771,25 +771,25 @@ EXPORT_SYMBOL(dec_node_page_state);
 
 /*
  * Fold a differential into the global counters.
- * Returns the number of counters updated.
+ * Returns whether counters were updated.
  */
 static int fold_diff(int *zone_diff, int *node_diff)
 {
 	int i;
-	int changes = 0;
+	bool changed = false;
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
-			changes++;
+			changed = true;
 	}
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
-			changes++;
+			changed = true;
 	}
-	return changes;
+	return changed;
 }
 
 /*
@@ -806,16 +806,16 @@ static int fold_diff(int *zone_diff, int *node_diff)
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
  *
- * The function returns the number of global counters updated.
+ * The function returns whether global counters were updated.
  */
-static int refresh_cpu_vm_stats(bool do_pagesets)
+static bool refresh_cpu_vm_stats(bool do_pagesets)
 {
 	struct pglist_data *pgdat;
 	struct zone *zone;
 	int i;
 	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
-	int changes = 0;
+	bool changed = false;
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_zonestat __percpu *pzstats = zone->per_cpu_zonestats;
@@ -839,7 +839,8 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		if (do_pagesets) {
 			cond_resched();
 
-			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
+			if (decay_pcp_high(zone, this_cpu_ptr(pcp)))
+				changed = true;
 #ifdef CONFIG_NUMA
 			/*
 			 * Deal with draining the remote pageset of this
@@ -861,13 +862,13 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 			}
 
 			if (__this_cpu_dec_return(pcp->expire)) {
-				changes++;
+				changed = true;
 				continue;
 			}
 
 			if (__this_cpu_read(pcp->count)) {
 				drain_zone_pages(zone, this_cpu_ptr(pcp));
-				changes++;
+				changed = true;
 			}
 #endif
 		}
@@ -887,8 +888,9 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		}
 	}
 
-	changes += fold_diff(global_zone_diff, global_node_diff);
-	return changes;
+	if (fold_diff(global_zone_diff, global_node_diff))
+		changed = true;
+	return changed;
 }
 
 /*
-- 
2.47.3

