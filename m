Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1185CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCE88E001D; Wed, 24 Sep 2025 16:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5F68E0001; Wed, 24 Sep 2025 16:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2498E001D; Wed, 24 Sep 2025 16:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB868E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:44:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 400E51DC5C4
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:14 +0000 (UTC)
X-FDA: 83925321228.25.0C0C762
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5EE938000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:44:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJBkUbGY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746652; a=rsa-sha256;
	cv=none;
	b=jh1jtLe1t+uh11mdar+wahnH81i2zWXYd/6TsxbH/M+pEWJFiQGR1HV94RDfzaPPQuXYJc
	Pob0Ka9nmLQowscdIzfdgDM+tDQuKD14Y9TUrV+v9vnyZgmCxjoP+1wcBfgnA2VVWZ3JV+
	HWZDantXOsV+oNb9uIVDzk8QQEqk/EI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJBkUbGY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNokewsZJe0VctGE28J9Sg6BSEv7Rs3SI9ltzwt8Wv8=;
	b=V6yfU5tN3iqPYGGqAA8xuQakMJJNFUsacNtiziXsY6SH0cONPPHAKjEvk3ieOt8r4ITnfj
	doazB0N2xV0SPgi0K9COokIB974Sl+13LY+PTellqknTxHNsD/FHkkf5x1Xcsk0CCJcYvY
	y4i+4e/PgHTszMkC81t4c76H2uWFPCM=
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-eb37d80cc16so299932276.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758746651; x=1759351451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNokewsZJe0VctGE28J9Sg6BSEv7Rs3SI9ltzwt8Wv8=;
        b=PJBkUbGYx2l+I9+0Y7LHyanBZqHvYleX150k3HVopnynoYP+WuQ4fS7s2nEr6AjMDL
         Qilq3JpAUPKa0UsllZk4IjSG+Y60Gs3K/i4xhT4rC1g2XlKUfWBILqWe5LDHTt3JVwlw
         fGjnHk4LDMeu+Vo9Mo0VhUrLW7xKkkQaTMSaRIBj/vUfHsHUE+YASBe0rreZyHjznuc4
         JA4qpVWhH1Htb3ArYGvsbHeUkv2Ee9a9YJHZ6WVdP0baBiNlwD0pwaM2Q3AGiRwpmS7+
         L9g61s0cQ8TP/7kqW9h4pR58BQOaq7LEJFc/z5z/aQgdVjKIPchnJKHAszEaJKnt9tvj
         z1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746651; x=1759351451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PNokewsZJe0VctGE28J9Sg6BSEv7Rs3SI9ltzwt8Wv8=;
        b=SKp8bF3Tja0fRqGaB590ot2zVVGf97FQ4ybOkdq7fa+5z8e2sTRfMgmwjMoVw3GtMJ
         l590+PICfi/7IIiErLNRDIdw64o3irqkn9IGDEn6hEuwVyY7KZZzxcylYCV9ShwPcs5e
         64WT7FjChxa6OFzaykTqpfCeonA1dlyo0zZEgP1nzL0S+R4N2K5gEtkZf38ghla6JhcA
         lXo2BK1u1JRq+arRD5Y3eai0IwEOjNOC37VlHBxlxCxIrQ6ojWgWhWESx/Ke0jXfA90t
         OmY+JX5SwiCt0Im0WBlq+88lciIGavo+dc+DkmaS0pDqem2RDTLnxMgCBGM0dsaNQPzK
         IL0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX6s9yl/1jX+B1F25ouj7c7IZlXIApxSViDFSxd61cdCvkk+ITcYWggyr5pc9bLjZSsEri3LUaqNg==@kvack.org
X-Gm-Message-State: AOJu0YyzdSJDo7x++X6UTjynX+3r9fAE4phatsLvsqlvWhlmjBeAY/ZG
	GDJDuBcsqxUWmdboidGknXN4DsnchgXUneXIazQmqVnoZi+peNufAIBf
X-Gm-Gg: ASbGncuy6rKBlid/R1guvHOkJ6vsMGkwLCS2gpkKX1ZytKyep6D+Rs1GXSmjNFR8j8o
	WCj83CLDmfPno8b9uwSXfkwc7hiwsLdo2piimLtSfWP4gK44kBDRcbUW4uQBPAqrpB5E+kQPHr2
	9Kmc3TtGF30mACVq+SoGACgFIeiW/xIsnoK9Fs47j5XKXCYxAOUwlubkrrcT1+YQOjxxgdXdeG0
	dNWOztZRSC7tpXZd8x/qSqwh16O3rM7E3rBoDJburvh4V565X4KXE2hbCSSvBtP9890OqVcwzMi
	qaUI84tsyrfnk10DBddoRC5JmQIy14xNP1gXEdt4dYV3FHFtVyjWU3U8yVawntAPZL8LDyzaDG9
	Qj8vZw5WV1q88QGmPbsHM6tjfWryk131QsSME2YAwnp1ba8VXksRjr/cg/SpIoGZO
X-Google-Smtp-Source: AGHT+IEtnhMrUSu5118Zgn8Uo8thtKK4T5BkpLanD30f6H9lZNNw/jWP4/TLi5rcPqT6btfdPKJlGw==
X-Received: by 2002:a05:6902:4088:b0:ea4:121e:bce5 with SMTP id 3f1490d57ef6-eb37fca9968mr1214255276.35.1758746651438;
        Wed, 24 Sep 2025 13:44:11 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:58::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-eb38393d51csm8111276.27.2025.09.24.13.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 13:44:10 -0700 (PDT)
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
Subject: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Wed, 24 Sep 2025 13:44:05 -0700
Message-ID: <20250924204409.1706524-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
References: <20250924204409.1706524-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EE938000B
X-Stat-Signature: f3oibsif8ar95mdygmhugwmezyjx7omg
X-Rspam-User: 
X-HE-Tag: 1758746652-207369
X-HE-Meta: U2FsdGVkX19C7c/TrxLYNs6mEk5BYPppCc+/sIIkEZ+D5PhYwVHi2xTeRifKGHzT5sOuQjTYHounhs45KZW/TXuP0CBf+GH/be3s9nx+fVVM3hfyUZ7p1tZdTBGJLeIU4E4VJMXIfXHbDpp7pi0g7Ig7tGIYT9rs33XEkZiUMkbxqvvT1G6Vf01bZNCRr2gObk4T6iWUU7hwKVKsEo6cPqXfUAONbXUBt56kO++5x3o5Pkbk41NNCTMBSCZ5QPGj86kNx9OyuJPBKIKj4x79AS3qIPzsz4wrHXwNwGHkKUkwN1mz8TU2DaogWDL4qRmaq6JAPLfNhnZ94l9AhBTOvTUo90BWY/cevb9+OdeiNoKVTchCwZ7eb41bpR1lLFbuhNBaWTYigCcIY4qEfdijnMraCaMZYvN3OiDT2g8GRq2CjcwuWRfbPBs8HUEeukvq618qY2np31u6qTbFODznJvKKR3xs6ypkyAJVn+rG/h4dAqonRncHpKfZEWFkfA0in1ul1r8/mp6G/1YNbAw6smBtTuNVIdpd4v6FXFnjbSn15OLADURO1DhBCvS0JD+eX0xVnPvvAYpvo6FhN5kvEA36qNllXQ545eV6tvRxeuFUXdTJXyIAV+BU4dyGD4GDnIhoP3aKx7+M93XsDnJ4RI5fXIVpyMoc3SKUAl0qu0iCdiNxagPNoz0UeU/QIjf39LS2Dc5QJYIOtB6RGw25KDTMHHP0F2WcAhfvl5FkUSqAmpc81+ZZdOs0eYWC5coaYJG/OKj5bMFW/exc8vz0F+qi8IFyQeTNatDePqPIk20hSE23K0klTXMghxwCGh8yG6EIOKMG4u/kUIt0dCXNApdXriGx9I7aHbz4JSmZKeY26NvBnW0VkLODZRVjuCV6d/aED+URxaGeD7DGlcbdf+uEQ1mjkCy4G/cErPuTORnVJAEs24tw6vmE12QhHUVPlRHt89UKjv94shmXH0w
 iHRdiJFB
 w+dvECLZBdPNaIg+2gaWrqJC0M7osMpPPweDKML+QyOee72s9ibRj/hwS3whraVgIN8nb/Q/hI9JwdIuQ/h2LElPFwYqtMlCwx12Vfx+NhewFgUU/mNvl1OuWSgXNKWuYvGQXaz4OHVtaAd6b74tWG7rHbfjkLEGSUgyyLLXTXADtkGIumLHg/DRdfM7Dj9KfGM5+a6Esa1HBd5muGGzA+odFyq7JXN69EMdF+/cImoBYjBM+Jqm/oeF2YcG2jpiIFfyQPFBMbO8TA4gGFBaVOf290WamaWe+kzfYSTKjHfS9kkJcg9u20AsSyc/72PG04yQEisISpL/NBOGnIFGAYzfmDJBsIPheMeCUYRMFBlgqPq2dD2tcv7EGaovlLzUckvSwqoQF40TTa4ziXEbPMVASgMbx7g2AA6v1TQ0GE9Rbtb7zmusWQL7BlvQNqxWoY/sQtvAcoTphp2r8fiweR2j/iz6s5JoGauU4bs/jIEDag23uHf3ILCm3O5YZ+MNIccA/D8jxG5LiNLgM7Y19BAVBgqAZU2QpCbhG7RkPN6So3jC3vB2LxusUlHkGnWCOXMLSkTJQ5CtKovs=
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

