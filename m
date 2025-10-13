Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B5BCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0718E0009; Mon, 13 Oct 2025 15:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1442B8E0058; Mon, 13 Oct 2025 15:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E88088E0009; Mon, 13 Oct 2025 15:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BEFF68E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:08:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B87F1605D0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:17 +0000 (UTC)
X-FDA: 83994026634.02.9882740
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 88488140005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CI6xkCv8;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760382495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaKsUlhHVYzGr/qaa9OrQYufYtYEbalh3sXBUEUgogU=;
	b=EZxEikRYUwhbV/EX6zXfCxl32dZ6iv99UouEvp4Jw5FM+ReMQnTRrd16mgmyNIqSLMkABy
	nyDGm0LSFqMMoS6gW7symBqenYYqNiMGQU4QOyyFrgfo95Em1zyB8Tg+DuWcYjYTXf0Y13
	EB9eLo8BjwLf3/TA7d5ctKDI9HRW0h4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CI6xkCv8;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760382495; a=rsa-sha256;
	cv=none;
	b=zwSuh+S2FXTrYnd0rB3j3Iq6mZObf8qR/dtLxr8crTUQXfW+NIJy/S20Yu9zhys6n381Eh
	ikRjhKKcLeT7mCyvAG65MvuzF8NPLdyUUSv7wxh0Bw+vdzcubEXTOesyJN6fsdbcM9lVQ5
	tjdYOLeCPQrvgDkjPdWiWOeOuOtnhUc=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-63bc1aeb427so4588991d50.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760382494; x=1760987294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaKsUlhHVYzGr/qaa9OrQYufYtYEbalh3sXBUEUgogU=;
        b=CI6xkCv8F/1D8luBiJomGZJn4EU2LigiwpLyHkeAiql6IoF8w7aNfjkMwIQ/q0Ue+j
         rrPdg0WqXF+1NmKu6vOqhiZOojYbSi1CUMX/fXJfes83X89X/43D8S5ss0O7RMiDsZkt
         g/9SnIB3knPUwIONzGJ+08wx3dK0XXH2araj/653Xe8yqAgmuszuh13SabM/L9blap9k
         HUQ75q30B8EJzxijtzCcvpp5HFNXTj+kg8T4DbuVVEjY2uTotqe7KjyGc0sLSeKy3Jhy
         t8vE57v54dfiJeFBcOtgO0maFo/QvrRqjJ7D7Cl191R8jj6rumtrWNf4Q7ZFFuw9rvgA
         QC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760382494; x=1760987294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaKsUlhHVYzGr/qaa9OrQYufYtYEbalh3sXBUEUgogU=;
        b=hd4dax9tAAzdFRY9+ljHBUj3gweXjJ/x9vad75KDPLf2JBeRvX1t0friE1X7N6eje4
         VjZ4shk1v8uRpbMaLFqLMKs2EBpII4Ey7pjyzPkgQD3OsD1i4waAwKHQg/zhrrnAhToM
         zBu0/ZTr0+RZwb5acakksp6s5cX34FGRN9GQPH0fm9TXRBY6opfF9ZdLc5avQPffjF6+
         SrVVK305afbepgNl15f2zxcDirLoIb/lJO0u78Q5COpuGfksDtiIxlk9OoSOC1oh7ABO
         un6fcB6AK5IDVNtT/M6y734nOTSVVMK03vDLu8n6Z3UgWRtIwWstM1atdb9W65EQmI3+
         H+Qg==
X-Forwarded-Encrypted: i=1; AJvYcCVtUM/L9Q+uiyQQlqF4Nra1Tk6CnF8CuFGY4jsuxorvUzVgEJaLNQGxL5YUD8dAXeXepqV4/CH+PA==@kvack.org
X-Gm-Message-State: AOJu0YzAEVJrkQvS9CJZG8mAlnaiHFKQ8G+Ymlcwo21pIZ3c2nnZTxnx
	6IfGwAwF9dPv5CjCI4nitkFNwDQIimVFLQvMHoFwux6cb7SnCvP1uisn
X-Gm-Gg: ASbGncs/B2/pO1Oi0lIYtPusAWoYIB6XYuxqmPuzV8ya6m0dVydRA/f2dSCwYHUtQ2L
	KgjBL8rVec6jLLW8vsRm2HUu/QDIxPjEQjFnqdSDxm17QCuw/ge9/bjpJ7fXLS1YUmmyC+ECzk3
	ziRpZlBv5WVE/FjHNy6qqx8I8uGYGMs+aDgG+qFdighs/6/lrjd4HFLxVoEXvmuEnqgJHmLV/ME
	v8Hha84e2yLOVd9wUDPTOkmGs+He0ngoZ0W+GFslPrlB9OfqYAw+CalTs0kn2+Ao2cSLOOYG5Ml
	9mEKp7UfaX+xinj53mGkTHN837RU6G0E+QvL1r9dBnydKcGsVCYMoQKamqkwDk1jx05NQEMEyH4
	SqJ7wNH1BfhusCxE4XMX+GLatTkFDmdjvvARKmkXySXParDWJaQFOmapqhxwl5F32RcgC1cjBPu
	cmf+MyamruUAhCF7Ob2Fc=
X-Google-Smtp-Source: AGHT+IHCF7ulcRqtzOcwLOSypYkVBjLtTayORGayA5ndYRP3Xnuskyn2V4s/3SPUaOLMHR0F/AXzvA==
X-Received: by 2002:a05:690e:164f:b0:63c:db25:6406 with SMTP id 956f58d0204a3-63cdb2584d8mr10560890d50.42.1760382494512;
        Mon, 13 Oct 2025 12:08:14 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:73::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cd9524284sm4219891d50.10.2025.10.13.12.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 12:08:14 -0700 (PDT)
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
	linux-mm@kvack.org
Subject: [PATCH v4 1/3] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Mon, 13 Oct 2025 12:08:09 -0700
Message-ID: <20251013190812.787205-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
References: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 88488140005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c8fbuswk7d8bwt3ffj4x1pn8rcpds6iu
X-HE-Tag: 1760382495-638638
X-HE-Meta: U2FsdGVkX1+oWo3ln0bqCpV+yvynalT1m3ljUY/llITHqrmPkB9rDyI5J99NgKU9bEaeIM90F76emTjGYXV6meRkd/RjPz4MS9jK1yqABB2DN//mftf9STiNqJCVLn7NAKlb5LYq2XSFdraLOldxEr/HHH++gj4kKlfAiOAKDQmjNZ5nAQBpSwNop0Ilvlzl+x1yvhLQWgkriuQYZWBRzAuPTmCyMit0FnjxlepI2yHjDRjtc2BpN537tDcq3ssRA4dZd8Vs3KnVt645tTjRBVuHQBPFyrIHidsLNX6lagrS6BugVPjL7LWi7v4OjILDoaDqbykrqfj26vXItGqJLFQduVOYXTgYidJvbxoiFw0i+lxt7M9mtln/kp4wB00ep96Ja7kHE5V16cKADtfI/5ZytanKsadCoYwA3yxtqkXOc+I7EzmodbnE5H/6Vc8hPLyoVK9F3w0vsFKfPV5G9/afv0pzjEa0roU2jHD15yXIxL1OC/Ga/0pkyjzcWXUFhQV34cmnJXVCVTvlQyA40syzqUZ1J4ZuQpuEMxY0jDTu1+6OyW1ohfJZf3pX1/AhYc8oZjTZSl4IiI6dsC1B9VvmqPJ+weIizIWgmP8bU6gm6gUBLShJshZ4Uq+CtSwfevYCol/QpUh0bwtPHfnO65eVXwymb4aitD/OhJ7IJkGIJeSAeuENPIRGjH/gxwoVl52Qzo0gTP/WgoCPy6zHHN99KOzvebvquIaaQTCwVrK5dN8y820ajrPZ5vEsyMebVDUpeWXzLiYFLWhbPptwKJ5MAzQQR9vTFKNhQKLBV8nD3gtatH0wZIOTc+8JtLxNxQJ1RCo5bHQwjRGIVpTYhesG9tdtNJbPCfLJkmJfZ7Hopt4KSn9glPRnuFDMm5KCPKISfWWN0wHmxS/6pGQVdVF/IYApT0YKxFOTqkgKoxeaVNLcAWAKs77XtSzxlooHXg2FlyKWQbWBV+v7yzM
 Spx07llF
 ur8+/Muqzd2tFoYuVkkED2k6to5mms0QUy7oDAL1AAAXnL5V/GiMVSrHGTQP0UR8bktx68Jq/WDh5Y4B3SUNruYd3GirsbLayX5fx0HfHlwmJq8d9FT58aWrnmiQmVg9gcX06kGlQxNct6F5+IanL4tiNw/fNNdizAnokHG995EGF6yn9cTjd9I5dAxcD1SfoJLcZoXTLXjxh5TE9F+RoVRHdrn2lu2T7J/tYPR36UQmyTcDVR+dQmdU71MpvKz32/mU6h9cidcTrVg4RNJbwBC0sIgOv38gDDYOJl4TShKNebHPoSV4FM+gfMJhKwxAlj8GnS5TBEkVRwilLSl9G2CtOgRj/7/17uVMOVIWyG1skRgYI+wcIhGzK/V21Qe3QXKoRYM5sCaOsMdqXRDimgr7wr8uGDyicO+mx+ArNCvS/jIH+XDtVGdQFg0YWGsPkjvXgGtshAadae8vtyAJE8C28R9KiQqQyHvPu4SYQQYkb/05l6P5bMkTpS1xpiycNj7ngfpAifjIEff8NQSJe6Be7Mw==
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

