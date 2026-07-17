Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A09C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 05:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11ED6B0099; Fri, 17 Jul 2026 01:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1CD6B009B; Fri, 17 Jul 2026 01:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7EE6B009D; Fri, 17 Jul 2026 01:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B589B6B0099
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:30:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13DE1C0415
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 05:30:20 +0000 (UTC)
X-FDA: 84997143000.27.350A93D
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0F897C000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 05:30:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ECyRo5VN;
	spf=pass (imf28.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784266218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=36ZQDquEIblWlclEPzlW5WX9ajSjC3KeMbCh3AwoOQk=;
	b=4dzJIZdtKjbMB8AGw8ma1l4kEfkk0t9qtnEBY9MEer8wDAcIDEDumHZuVSQqOyTTRfhs7I
	NYU/CNIMm/eyKGdMbHfeu8KppMYtzQLYiIUGIYML4DG+6zU78SaPoXJ+4/+8CBFUVNjZq4
	MHGmvP9EKbFltEB81MWBcFnfodYLKtU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ECyRo5VN;
	spf=pass (imf28.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784266218;
	b=DTCuE8v/EyYJOMxsxZkvI8iNLht+gCfXhbF9S3xEVI9r4hlv3J6Dvbm/MM04I3eXpKjgUN
	CH9zJ4PAYcCNDnArB8fCKOfV1NQbaQxCDm+RAxNvOFGA7qf5A1Tbb/gZqPDnKxX+7OehSf
	p9jds1mHVKCgu9ComK3OujZLKqCZkY0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784266214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=36ZQDquEIblWlclEPzlW5WX9ajSjC3KeMbCh3AwoOQk=;
	b=ECyRo5VN0omOVANxqKnks372lZPZyJ2z+xrdGKWUJUMA11MLKW9YfG9UzGqld6eiHkDnIk
	XwQNqBsmGgZnQ5ZUrGixjXwq0zRcpb1kGy6J4Uwq+xblst+MryUI2OJMBv5aEJU9LL3htS
	Lryklz64uUixVU1lYubINNHlse+p5z8=
From: Hongfu Li <hongfu.li@linux.dev>
To: david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm: add missing alloc_percpu() NULL check in hotplug init
Date: Fri, 17 Jul 2026 13:29:38 +0800
Message-ID: <20260717052938.58447-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F897C000F
X-Stat-Signature: gpqet418wdn4eahiezysi8jkx6apy9zn
X-HE-Tag: 1784266217-457422
X-HE-Meta: U2FsdGVkX1+sAPP3n4mQh31iqRB6N9qqkVZI2tGJv7iD7VL4a8HdKhb9Y4D30mC2zzFexco+9uuMrKsGFQ00JRekOp200BLSa35LtV+f/S51eE83kImqMsrQcCOk4EsJ6PpqiQLry3CJJqBv24mIZz0CanySwyVGJAEklY2vgZfTmJTyu+bwEf34G9rIneAJcUH1vCwmp45GG/CnZJCfXoHl/OvbWDe/mjzKiHUYmJxWU5p1zZ+kDMWPryJX5ufpv1izM62D12UdgKjBhgeJzfSl+EGvN/v5LTIVMKXqk3ECWjLsVA2u1ASNWGgxDEIkwAZCPJLRXDPF34aqESOClAlT9Vwn2IYPVikNMe2ooCwZqcs3EW2VV+eRxd2nvJVW4wDlPR7MhVSPui5e9oK2/rOCYs8rXjxhGoi5FJNQ8Hr/XtdCczVo9eqypsQ/Umg42tegxGjXI3qyD5eksvbgrnVfb2A42JhVDMH40JIALU78v7Ik0imRiy3mtj7gYEDobkUP+U3Zha1qRlSnoXwKrYc4TmNE6uhHCC2AhFZYg5kAzmNmGY2VQ3v/mMorwmaTvpVkeVz7lROhXXU+y3UeODtnRSK21j+4vrm52ip8ewKwgL37Fbky1hnHyUxkAbm98AGYmkmJyVJANLBXAPgHsqIdVwMPJm6hU1pFRYm0FU2AB/OJ8NsPRGPGGZ1sXxASSY7Lrkgx5blZIR3bNwJ0/8T20WxbxL46GvOyqPWjKec7rWt9PyBpJovOge5SjB3VB4BbPFzPfUjMymQkci1cDVIttk3FusQhyHTyvQPbVTT4Ymd/jnEbsPqIdpEsYt9gVrfT23EBSd/10nF8Kch/7J3aYI5RqZdZTWlpbCemtwhzQ5AG6eZNVZGc9TfxQ/S1gTuCw5CGw1Gz8uERUwZzxpL+YL5z2WI5O7seCEZoLIgtEM1S5E0tCe+C4dJTfguA/aA/vZP+vI2MWIB9gLx
 x4yZ8AC/
 Iweu5D2JBYcg2e5fgDPEz2SGPO62Cjoc+MkPquU8FVQ1gfaiMNaHObftG83lmTlq7Eq0W3tG6AvADt6nMewghEVLQyge/yRez6cRfoq+E6uDmmkqdxWGEBF2lmvexUqf//M7sZlEdvWjQhr63wTFOO5fxeGAnWoSdGWK2rEHXH9ZerkXsceuvCHV9cVn/zfLe7DAnnSuR1KDVbIknYz4UBHtslikfdLvnVSJj9fw9wvDUyBp6NKk7OOn/jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

No NULL check is done for alloc_percpu() when initializing per-CPU
nodestats. Allocation failure leads to NULL pointer dereference
during later memset.

Make function return int, check alloc_percpu() result and return
-ENOMEM on error. The caller chain already propagates this error
correctly.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            |  3 ++-
 mm/mm_init.c                   | 14 +++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..f04b915678db 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -289,7 +289,7 @@ static inline void __remove_memory(u64 start, u64 size) {}
 /* Default online_type (MMOP_*) when new memory blocks are added. */
 extern enum mmop mhp_get_default_online_type(void);
 extern void mhp_set_default_online_type(enum mmop online_type);
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+extern int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..8b137328dcf0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1263,7 +1263,8 @@ static pg_data_t *hotadd_init_pgdat(int nid)
 	pgdat = NODE_DATA(nid);
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(pgdat);
+	if (free_area_init_core_hotplug(pgdat))
+		return NULL;
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..24770947a66f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1536,7 +1536,7 @@ void __init set_pageblock_order(void)
  * NOTE: this function is only called during memory hotplug
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
@@ -1544,8 +1544,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 
 	pgdat_init_internals(pgdat);
 
-	if (pgdat->per_cpu_nodestats == &boot_nodestats)
-		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
+		struct per_cpu_nodestat __percpu *new;
+
+		new = alloc_percpu(struct per_cpu_nodestat);
+		if (!new)
+			return -ENOMEM;
+		pgdat->per_cpu_nodestats = new;
+	}
 
 	/*
 	 * Reset the nr_zones, order and highest_zoneidx before reuse.
@@ -1576,6 +1582,8 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 		zone->present_pages = 0;
 		zone_init_internals(zone, z, nid, 0);
 	}
+
+	return 0;
 }
 #endif
 
-- 
2.54.0


