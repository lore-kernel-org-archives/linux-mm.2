Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65867CAC5A8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 19:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAE48E0006; Fri, 19 Sep 2025 15:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DA38E0001; Fri, 19 Sep 2025 15:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331598E0006; Fri, 19 Sep 2025 15:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2C08E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:52:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD565BB6D7
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:28 +0000 (UTC)
X-FDA: 83907046776.05.8836028
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 10F2C14000B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YZ9U1E1x;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758311547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNokewsZJe0VctGE28J9Sg6BSEv7Rs3SI9ltzwt8Wv8=;
	b=vPnrMXwVhqtUL478SXq2W5cVJA+w77a1GKoTk2Z2afLjagORObCHtYzhocmrt97HGC/MEl
	3xFg5566BahacDzc9J8ZXsME23zeKnjXLB6ymFMqXTuelZzHPx5HQ8CEOw2PpKEvi7ZS2K
	ikAaMRt59gsm/Y+vN18F8eWoDtu+KP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758311547; a=rsa-sha256;
	cv=none;
	b=60Uuei6o2/A/1A11D6wxVvPR+1I7J31EkJ9tCNRVTqLHVUWxa0xNd7JOCKFQPOXzCjO1Qq
	Zu1IE6BiRM6IcIpj/SomYV5HJoVeU4Fz7uYChSahboOo3cecqKvBeG776NqCEZ8VtrfbHp
	hNRLEdU0K3z9UTPKp0FjvyHj1HOS4eg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YZ9U1E1x;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e970e624b7cso3378449276.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758311546; x=1758916346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNokewsZJe0VctGE28J9Sg6BSEv7Rs3SI9ltzwt8Wv8=;
        b=YZ9U1E1xEeOzuLFvS+mp3YT0y5gXXDPtv2cBCZC2xmOxkJOxLBtJSnQ7Ol4UeewZm7
         MBXKQVaGMcvsRZ6utIF8W2B75TU2Uf/+Poxw1Z8Vs7fBE2rPxq92Q1Pqc+GvCqF162QN
         BTwgzjMHgr1ksKNwkM5Vyyj0cDZnEIuUc9Z9xk2JC3k7lZV5YOllAFvanOqazLDiDBoO
         VymHxz5T1haOFyswffY89flR+NbSAcxwYUA+RbGIaqZg28ptpqdKtZWyycbP+/RmAm58
         X8aVQfZNB5z6hwaCVyBjcD1a7BlUFcZOmsj2LLXmc5AYfQED3ZixPWZERYZGr2ZbyiMI
         I8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758311546; x=1758916346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PNokewsZJe0VctGE28J9Sg6BSEv7Rs3SI9ltzwt8Wv8=;
        b=QIVjPBbkFK6Dn0WW4DMNl0r53srT9Ft05HCgLgYeWCsw4vaNNgm0LdAODQ1QjruWIJ
         d64b6z0EMUlTEru0YhkIHN+3mZGWXWMCPDQPTRrUW7bFp5tSNpyimSEbf7jJWbWjz99D
         RtgvjMbzBegUzfDXIrSUbEkCGFp5sL3Q35hrOfm+MZ5Weigqq6BPE/+9tQ7hysWqYeIP
         SuXlXECfaCevtYf6c9rJiAZ5ZWMCGaixae8A7OJf/k0XsPxzV7X2PlS4+sjXtKX2zgPS
         LGuBaiD3JCBhZvzz/EvRp+MECOyYdxRytlzoCo/qoNiu2v9LbxybCsO/s0SmDJN5J82j
         fsfA==
X-Forwarded-Encrypted: i=1; AJvYcCV/oB65h6lq/OhUrCriotBSrcPQurv+Ht36YQ/R4AZHTY6V9xE4WqTuC8OOaZIoi7b6Q9+SV/kRlQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0vy4EZkn2ymCbEIaB2lLdJbCXRazO3ggL7n7kf6cZkteSP9h6
	c9o1wDX2iZPtFK9Jyw+7SXJU265gLnj0XOL8H/CLUDLTYqyykJXBppxE
X-Gm-Gg: ASbGncv2up114lYk8+jCao5z7WWxRgSfX1GoFApi8HNCWhtPZpPUSosHDjEnLvTyKjB
	G7ricEK58N3tpGnYXvqcwHdhXQ4g8uQ0psbSgupTXq2KKE9pZ6HoaEDtt2bkfp+syLmg/n2Bt6p
	4ovF8xHcz91KJZ+j+Z8O4LJIGPlE55fhzFTkO1zAviiECTlVKN0ByPl3wKWvxVaxKgeVYjqbx8F
	oh28N8EA04c0cg3jZ6oMTLevRbRlqh7T3QN0rgYJr+zUgqLPv4EZqjwA0vidAMZg8wYE0xBIGNO
	zhVfCF5J5WTUOXV6GTvSNzU3Nl6dviZ7RyayW9p7VlhQRzDETwSvfxe3ILVwdMTLkEcHybcWE4o
	U+N+QVkL/sOUjM7zbGFxvcv78Q2JHPhJ9jKObGoqdTjXWt0dPRRac
X-Google-Smtp-Source: AGHT+IGiHhqEEGk8maRWdeb2WQIByD25ZoDI5E5e1pECrjiWUHQigM38gM3n9qWST+GwllEBBEo01w==
X-Received: by 2002:a05:690c:9506:b0:733:aa00:3860 with SMTP id 00721157ae682-739708ca5b2mr60891147b3.23.1758311545864;
        Fri, 19 Sep 2025 12:52:25 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-744a3110618sm1682767b3.13.2025.09.19.12.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 12:52:25 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Fri, 19 Sep 2025 12:52:19 -0700
Message-ID: <20250919195223.1560636-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
References: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 10F2C14000B
X-Stat-Signature: 4ckhiroekr1ki6ks46f87f89wyux93qh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758311546-18326
X-HE-Meta: U2FsdGVkX18MxvqUO6EXnZRD61fOazyARbMmn6yYqc22xFPpKMiE7YehWanxrqRNwZ8waTJb3Ys3o/yNL6JNeZmLBXsnkKJl5S/URSHfbSw1jC3aa4fyGbsm00w2X76suGlg0Um4LchHavlrraLLzfNkqkYSd9Tntb26C+0mYlcsXjUXbCIoxkiwJv0HuMsGSz0Loovok+dzsyk0IyLtVuyXuKKFw4yQ7UeLCnZUexC74uktzzHLmIG4GJ/6pBAc8UuRCOIScx89PSIyNYpUbkGO/SS+WoLycuO4sr/wIgdQ4XFf2bUrNMsHQ8LSS/zCZVLNqn5TlM7rG/sAMCO4+CJWXgcFE6UQ9BNludwKaRDtYYYS0xhxTYt2CeVjn2p4I9PQgUDTtqu4hokH/fciyZoElt+JbP5GKDzkM1yaDwTbOvHo5bFbSgnG0/9hDTd9GJDXEqdX4KT4T+OE32GMK5hlwXPAvsWkU67r2i42t/kQPqRLJTS99LPuUqB4P3VIA2Oq2Kcuib9LGU2GNFcBuex6Xrl0hjRDhiJOhgJkT7SNvl+kAIKDt4GjXi6+VeO+FTNn/FstaeQQzsC17YEB/SqklkTnHlHQEMxpH7frY/HzzDQX31gUO7Wu5Ufy1T0OGKz5ouaFD2VGfUmIQ2lQDjRx32cW95BantlICjeAMeR7oQbgHKzUxdYcXxTZB1na9JHlSThtfnaTwY56KAb2OQmGrQRK2Bso+6da8mYQKpLswk3hMXBuzok8h6ySIzzisYDt2z7ykQ7x0lFtS4RKyvvUAComYdY0m4lQj1jbgao5XqlPo4ZMYBbHrPcu5vsJ3v8/2p9kIF0JwG1nTOuYVYGtpjJcEj56BAmLzmUvsHZUZfJ0EJSev6Z3mhndEd1C9/DLmsQ3HTlIbsoMeda6TgnOXsMoTE5er3VU3xNutOst4Pz0xdSHPGA7rjclMyhZxt49YsbGy938hNmxXST
 N8X6V8Ff
 zZtHmSOxEDuQahkHGX095FEw2dpkm5VzYPK/z6SvxoQMNs1g8790oIeg/5ez1axKzO8BSB25ElNXp8f5JySWfdKkPo0TLW9ZJWElkWTY1pLnHy16RkyRgInzfF/fjtyCCKZqKZY/06wL3rnnu8PN+da2n3v3jnsXxgnsxc5MMS2GLdcmM4mwx+HmAWLwwMIt/56vAlglGERr5iFh7Rv52Bl7lLspb7yxr7B6A4dRmc9rC90nC3sG44hhzg0CWFGSNVv6Kn00mvBaB/q9pWWrBq2hdemm3Mw4/G4sJYKJqVwZUY7NQM/3UDNhlyH9R+zVrQEQGWr1TLNlIKcWTpLXU4MDXajOLi026SabbJVlyKxp6smfzoTdHMxGxSI9lzzLrJ64y5k1N26gO/OP2BDhb9C1eY2COh10HMdbPpowO1p8Aeh+c6Da5ahQeJ5F4RLvLe6NScep7JLvrPwWRkWDJ6WNH4lmFZYkTtYvNYgGAqbgK0bfnhEIJ7f7oVXmH9JYRomguKRkNVgcp8tHEOQsnz3zpgHfWt1RNQTaCPzSXPYGT1WKPyo5qP1+0VejIa9WSEokWQawhbRkhmNI=
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

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     |  8 ++++----
 mm/vmstat.c         | 26 +++++++++++++-------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 5ebf26fcdcfa..63c72cb1d117 100644
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
index d1d037f97c5f..77e7d9a5f149 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2561,10 +2561,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  * Called from the vmstat counter updater to decay the PCP high.
  * Return whether there are addition works to do.
  */
-int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
+bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, batch;
-	int todo = 0;
+	bool todo;
 
 	high_min = READ_ONCE(pcp->high_min);
 	batch = READ_ONCE(pcp->batch);
@@ -2577,7 +2577,7 @@ int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 		pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX),
 				 pcp->high - (pcp->high >> 3), high_min);
 		if (pcp->high > high_min)
-			todo++;
+			todo = true;
 	}
 
 	to_drain = pcp->count - pcp->high;
@@ -2585,7 +2585,7 @@ int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 		spin_lock(&pcp->lock);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
 		spin_unlock(&pcp->lock);
-		todo++;
+		todo = true;
 	}
 
 	return todo;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..1f74a3517ab2 100644
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
@@ -839,7 +839,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		if (do_pagesets) {
 			cond_resched();
 
-			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
+			changed |= decay_pcp_high(zone, this_cpu_ptr(pcp));
 #ifdef CONFIG_NUMA
 			/*
 			 * Deal with draining the remote pageset of this
@@ -861,13 +861,13 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
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
@@ -887,8 +887,8 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 		}
 	}
 
-	changes += fold_diff(global_zone_diff, global_node_diff);
-	return changes;
+	changed |= fold_diff(global_zone_diff, global_node_diff);
+	return changed;
 }
 
 /*
-- 
2.47.3

