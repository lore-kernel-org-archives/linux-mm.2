Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA15C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C956B00AD; Tue, 30 Jun 2026 17:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CF06B00AE; Tue, 30 Jun 2026 17:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CA56B00AF; Tue, 30 Jun 2026 17:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 295BF6B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:40:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96147A0147
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:40:56 +0000 (UTC)
X-FDA: 84937899312.09.369CEFE
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id EF2BAC0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:40:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uISF+VpU;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782855655;
	b=Jjo2BfT+XySFu3P4nBNbn3o75NcT58XTIG+hJyW7qpusHf1n0vbdSSYVpwBISU3Be7VvXX
	sYMHDVs5sOimlLfIz+WVlgQe7XJIapyVy6bHUOU9nngEmY/42GaDAokLb3/9uezugzAA5s
	s3dYUuLbHdH6y2y67cWLlfUv9b7nyoI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782855655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mHInMxAaQ2bUuLOe5OFmxM2p3fvBID4+2UNGvlrGK4E=;
	b=CM9MEfTPPvgkjC1qFQXnRfWoA+ZmzyPL4qrv5rTWw7wSux7KqQFTvFGZbm7CgD1LZE1AvZ
	Zvs47WJ3pHTkfX+6U3PZP99Qkj9H/GENAxVcbxpJPyy7nJg7OzO0eFl8VH8De9j4FnjmpW
	265DOChgPnhqEfQ1mo5nOgEiOjE/BT4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uISF+VpU;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-516d0db9372so40372321cf.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782855654; x=1783460454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mHInMxAaQ2bUuLOe5OFmxM2p3fvBID4+2UNGvlrGK4E=;
        b=uISF+VpU9upYUBjYeFhlXeU4C8v5j3TYuKM8/kiYAkG6kVvR+dwivZoPG6j03zhvis
         HxPEgVde96CzjiMKLKttL7k3ilbzEOYDjDcXZjvGcFiKDJOYtCQa8aaBVSS+DfbOy8u3
         +q5xa+hsaIbTdm7OVwlFYxLBurDQ39IVXbiNYiuyncP+K5GlkOaO7UoIz9UC+fPyXOpC
         OoOYoMSpB9b8LIMTqeS83TTZqvQfb6ous6fGtKsTDLfvGZf08LX/EzBJXV31s7QYMSd6
         JogNjuy3upKI2J51FejdMyF6n+KKb9oaoD3fNW1LEeADA8YLlt1jNJZZudHSp+sJ/Mb1
         B6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782855654; x=1783460454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mHInMxAaQ2bUuLOe5OFmxM2p3fvBID4+2UNGvlrGK4E=;
        b=Msx1Qz5KewzgZ4VD/G5s9Z0YD2mdFrEgZxbtu0P3DbgSfzSfWUY5p+cHfJommtkjdF
         vCowHb4P3k7zUlgI/ULQR135XWlmHmtRaBJW7P00JElLuPnZ+KQjetJCCQyXXO3dbpg4
         uFyaCDImR6hGRCs7NA6+WASNnPJooMAoDuZAzHcO4wCEdP3Mg9d5zq92MHGk4VOVuLb9
         7+qbkscQ9avuFDeGm0mDqGAYSnAL9bFaDFhH1/nNmNRVHw82jYzpu/9Cop88Zg8xiLnF
         HygDRUwjWNtEEgejSXa1wA7utLGMTMXJ5CJco8WzRpBGcEEWqjREkvGnRfHEoHcP7wgO
         KK3w==
X-Gm-Message-State: AOJu0Ywax5x6niHxVVV0zasRq1Sw4zYqSEvxkyNxAapG27L+rHtorkEe
	WpyvJvSZBPuMeiyhXkYLAX5Pa4syEcCRNnb2f2LgHweqcuArJDb82YBtckgHoXpQOrcKNSfdxYG
	fpb3z
X-Gm-Gg: AfdE7ckz+gE3HJMZifUMcsRhdGl7INkuqQiNlkroVJoUSskyTYyal4rKQg9LAF07+b9
	2qVfP07s0RBI8E9V6q//35d0MxKWnJwKYDYgRCKxbNBFl+oxTVjdWurH2M044F3kprOICkoZkYY
	n48h2PuWnzXgOi0u02j5SYQXU6cYQ8TpJF7UIsBejSehP/DqTLfh8BDKV5UNifQNFygtV2WPrFB
	6R7Nb8KUWjIwsFA8LkhrkHHfN/24ALHXrt4o7GS4tMKtR8eTzKOwRYn7z3ADezsc93sNbpfPiBb
	vDHtzGYU2tV8XNmc7UUqurwqpYL5egUs9XmpHUft3hbrMkVOb6Q8Kpopm/vhQkRXmNM5mCnMCr7
	2FPqk2fGqo+15ht+733pejr9MXF85+50UvZvGoS1W2NPUVM6u/zlI1Ft6/VwWcI70VXNsJNqL8+
	mJ0gqgWMmQUelDChKJx+icks8jH4pIT4D4EgYXls6MTN8j3SGuhd6L34udukxCxbvi2bJ284X3H
	jbqu+F750KL
X-Received: by 2002:a05:622a:1f0f:b0:51a:8c97:fb93 with SMTP id d75a77b69052e-51c1090a30amr70785981cf.60.1782855654010;
        Tue, 30 Jun 2026 14:40:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c10a0eb16sm27011331cf.25.2026.06.30.14.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:40:53 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	mgorman@techsingularity.net,
	hannes@cmpxchg.org,
	vbabka@kernel.org
Subject: [PATCH] mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
Date: Tue, 30 Jun 2026 17:40:39 -0400
Message-ID: <20260630214039.2263562-1-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mudpfyf1iky19389sm9sit9s3udwrxpf
X-Rspam-User: 
X-Rspamd-Queue-Id: EF2BAC0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782855654-858424
X-HE-Meta: U2FsdGVkX1/0QaKrxf+FNXokJsoWQBafJFz8oGsxlIHKowC+9F29pULOKH34tmAO83eNeaU9Iczbd24GPWQJdPpA2ouKubaIcbMC6Li43eaSSD8iAjl0/9zavAGW9tBhJkIszx/FVMs24ONDWYgyBhV0X6NqlF3TWcDVTXTWGIlGtvkqmU1PLSfa2eq0MrNy39E3xUNx90W49uDlU+YAcicYIjIe4cJQJfIEG+p1OpvdAaiwdggaiI6IX5NGj2H3S6LQG0Gn6DljA7lS1wmoda1ri2T4SPSYCyc58UX3ZixQmJ3olQ6pnwmiHdkFymsSnNyz723OwrHgmSe/SES5SmA0Dwgnu5JG2a5YV0626LIjMavXGbi4AKL6Kswh141X5yHxhDU7u+KOE5MYI6JyLVHUb/mWvZQelE8nXb/fzW0lFqb4SH1NmLXODIjKzkKmD3po/DWm8l07xfw1bT3RBMlitFiyc5fV+YSY0G4+aLvfl8HWup7HjHH3xDRXZPyEpgl0xCchZJrBVYjMW8SpdmffRCjAw3I43x3OIOp9/8XDTq8pus+idYlFBKDcirSg86dYaGm298k2y+1AO/PhPI0GXi8Twx6UgmcXVcSmpKxcjCd9jpbTLczKLHzNr6p8uG5JMEJHkQmgOVZjQ8fUMrcNjlMzBSZngiFHNifFvUM5wtHk0mcqkYejftjsRWa+Ug8Ojg6MNoYjv+rZFvJ9YZaHDWTeKLNwNwjvmLhSRXv9WCmvEoY29BN5CWdFHVV1njY7eyVCXPN3Aq0Fm39jeddEpkWro+JiRkflSOTILMwNFHhUvVjr7rU+u3h4GGC8gH2XU+Umy4JLnNw9B6hLSx6Vd7nj3dj4yAy3TvDOjJWn4L1R+ANEkFcdv7CLZQwGkh6YXPyzoBvqKHBW3gI6hGUslJBR5f6fCBj7C6jahAehh5Kj7iuKgpEd+fYdDYU7Z9Vp82T7KWA5Q0DJGnO
 NtjWCRwT
 C0sXyfVRG7HiWKP/3qOXLH2hRIObuDSa+PGHkSlGBrksAW0dnchFhJIEqZIZi0VoYajkrvZCIJ519wj0bjNW9biG1Hu8JsXDgvWr0Ou4KFR9okwRSk6UEcq6ImFTTOegZxnZPd93C/yUQvFWw2PFT1TkBfthKuQ4U32SVdP61ho58xaqXulhIUchYXD7YdfV3JRaqmRHU0rctarCC8F7XFl1RHWi+0BHhOe6+VVsNLMiqFJiYaAdOfod1J8p0xDqLu5eukDbB95+qYtMIjq2/54Mt5O7lT6CPDPBnsZhqGgn/ZRdnxLY1ttp1TojNmnajwC5eM+pmXcdF/mzeLt69B0YRkBoJlrXWvfB3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We miss a failed allocation check for pgdat->per_cpu_nodestats, which
results in a NULL deref when we offset into the per-cpu area.

Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing
at boot_nodestats so a later online can retry the allocation.

hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
already maps to -ENOMEM.

Assisted-by: Sashiko:unknown-model
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
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
index 306ea5c13f54..37fd64ce144d 100644
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
+		struct per_cpu_nodestat __percpu *p;
+
+		p = alloc_percpu(struct per_cpu_nodestat);
+		if (!p)
+			return -ENOMEM;
+		pgdat->per_cpu_nodestats = p;
+	}
 
 	/*
 	 * Reset the nr_zones, order and highest_zoneidx before reuse.
@@ -1583,6 +1589,8 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 		zone->present_pages = 0;
 		zone_init_internals(zone, z, nid, 0);
 	}
+
+	return 0;
 }
 #endif
 
-- 
2.53.0-Meta


