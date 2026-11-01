Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C31F606A338
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=hy1f4Vem
Received: by kanga.kvack.org (Postfix)
	id 480C36B05B2; Sat, 31 Oct 2026 22:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4315D6B05B3; Sat, 31 Oct 2026 22:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9B86B05B4; Sat, 31 Oct 2026 22:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFC886B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6689C160900
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:52 +0000 (UTC)
X-FDA: 85384929504.04.CC9F6F0
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id A80E3180005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hy1f4Vem;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4rxIRaCxnrdC1SqVr2USnkLP2QgDb4JUWWHxADVHGo=;
	b=TloLLnrj4/doibGOsSPpB/4aM9ZCt5Sjmfo1qJ5N/LNPrstXvkzQbiGavO1wLFrvudjQdI
	1lHMmlNFcWqvyNNw3UoNGVpqYoCqwL14tGHPUPYvCJpPM9ZkFClaN8L/nvnfDhYyesFAar
	WChas98HwpGTzAafWyO9NGZRXED9mqo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hy1f4Vem;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499230;
	b=hlMyjrdR9lpfcKfSL3atkqjXQEKCMgRM8Pcb1llaFGpih9hySk1sqZY5eTIQ/mVslelj4T
	Nuai9X3BjWkMfzHXn1b3sLzGTWdo2x6Jwyt5AdNODC4pTHcq5xK8WoSy7I+e1Otg86XO9i
	lIrISnWKxlhxvg/dvDaChGup1uslyrA=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f079a63b8so198582985a.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499230; x=1794104030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z4rxIRaCxnrdC1SqVr2USnkLP2QgDb4JUWWHxADVHGo=;
        b=hy1f4Vemlni8z4Le0wpTPLh21IwWjdQXXij4bWsTPh3lcF+AyCAX+S2BsC3L4oeIYQ
         6dtWkFr98sXC8lDjTMHyV6pZjIzWORXj5lRClmVu52bZn8Fb92Dofex0szRlZpdwO3V3
         oXGehBt2wi+0W26bTcg3zU7F28++RLtpN9DE6PDbX9ZBOBdDyRlZeq+4CzZh+t2Seprr
         RsmjVmifOTgENtK80inDelW+qskthflWEB/AaJqeofjG143y23iY+KMNYW+VibpaRn+U
         M7vzqbRxdUUug2LuQaV4vhoEUlrXXz8W0V7QHtJzpSkVP/yFWaZCZaaluFeNQKKCijfG
         MTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499230; x=1794104030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z4rxIRaCxnrdC1SqVr2USnkLP2QgDb4JUWWHxADVHGo=;
        b=Mrngk4eFiZsFWL7SHM2TChymkn12JDsqJYVj5l126cg4tG9UUmUEbj7Nj096KsaWQP
         2bON/19DBhtSF3Ebx3VIW3CmmJwQvpjzY1YHRzH11O4VtsZ1a134J3evJQi34yvX70X9
         oJv63nw67+LHGPv2GINk4/gmxWJCgvN8vsIeZFLNMNgM1fCitSOnBvRTUENnRT/aPUBP
         PXtT//NSi3W/qutBEocn70hxkHhTzfe47namCGyE8VU3Ug4WgKUWtZRhIIdnTWCATEfh
         M441pN3C+TFDZPb47gEvCd+iTMs999dDLp0nz03yzbvETiZPgk9nDlliPTB0YA2Jx6X9
         IKFw==
X-Gm-Message-State: AFq9FYJ28DvBBOnNF0qlZjz5qkmkZ3nSPYRmdkC1vXgsXEuSHVVstyRT
	Ai2UN8BEbnJWIZGushvbaUElq06Ur7p69w8Rl75YoigEN0maFNIZQWcijkWFLt0f7BEUQKxk6oo
	F4JAR
X-Gm-Gg: AYBFou227zVgq0d8Yc2Opc9abyeUzupPobhKf7AhS9fdKqqSScfnujlGzPEVTYHNYwD
	yUslf1tlsJUXzwUdJlOIC7glCmGahF0UESUBs3m/4Khvw9sapxtWRTvdUSyvOzrTZNh/R695EKB
	a2DDOumqEloOs79u6DZAL9E1qZo6aIyUjSbdGll90DNFEl1MElnjOQqrlPyfuRv11/OWAOPmd0g
	Ddoetml/FEHbv6CT+a1LyvC8LRk7VLqFzMZ6mMwAZ3xhKfhiwEdiJEKWoslfyTFlDju9N8L0cHs
	GN6hszpx0/BnnvRtLa531wPloT5+RoN0bsZUn9faSIIJUCN9O2TcOXVp5zs7snax+dsDhdE5T5/
	RYhQvCOk1QdCEVvJH8klj3hI1h61jThra+Hoc8xjFMH+ILlWugnc7yIjIko8uX1ubrGJElAlJAE
	1rSiyDzUGejAWeysTcbFbg/kTnhS6UPcxyJy466kMF0Ye1kv4Zupx28iqGW5Ft6qzUUfJA2oCRs
	Gbe87AA0SCSrAfIU38873bqdQgkZlNfSVtdSxBC4DqXoxY/yxvGtYoevtQGC9O6oGYYaKbNkWgL
	GWyKrv+Fc2sQS1im0zEC4OyuF+t4Oplxu0RvS+7OUHoNWTqybNjFhBKw/4vfMokyhdd0EvEGB0N
	Ees5nkYK9zw==
X-Received: by 2002:a05:620a:29d4:b0:943:f4a1:7bb9 with SMTP id af79cd13be357-944216efcc7mr1061645285a.18.1793499229856;
        Sat, 31 Oct 2026 19:13:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:49 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: [PATCH v5 02/12] mm/page_alloc: keep the pagesets of an empty zone
Date: Sat, 31 Oct 2026 22:13:30 -0400
Message-ID: <20261101021340.2251928-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A80E3180005
X-Stat-Signature: xxqhezxdengnmndj1uzybft8xbzfiyma
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793499230-502180
X-HE-Meta: U2FsdGVkX19cuRyTt5oVBtmq36GNN+mJZfRc83IusWGc+T5Bb1ajMtB91YKQHxLL2pRmTNDapwG2Yt+r+Szog0xO4hX38/Iesh9f2rbJzZWs9EEJKi3jvpsNWY3gr5Fie+1pKLxai0DTC0jPmbt45q3rs+hFcwMeyHqmN7OgFWM7kWEcS7ZgGRe6omUpLEap5zjV/y/KK3wJL8XjEM3r+8ZPPHCADPirNQRuUAkaxReQbpVo1gTzo7Ka/Dzz4PajHPlYdZJiyBW+WdhDSFH846wH5Z2Y3B9gIu+lBDjyn6dTGDpmGG/Q+o9P8p2d4S5tML8Nj05GHrdlK4dKwzE7h4p1esW4zpOtKG50FLUV2bCjbHSma5OBf2wyAWBD6bK26c8YCGygVR4RL64r2hdF6lctv5UGEmEt2vYScLBZ5NhKfWly50uI24jmj4DAfv2hSqbWRn5iBg1hodAqFXURGcIavWnrxMJMt/no5kAR4qd/wvyW+2wM2YjyZCGce+d5vlBoo8/BFBdFI1ykj6eSLpo2lU9367NdTu7QkEKZOEhuMhWnyM9TIZaB4OSkbJ3a4QsVa/wAZSEoYea0CADsEO1RZQfyfuWNVA5H6v63MSUl64O8gRD3vbBD6RTsMtZNsmjbWKybt2sGoenSzlrQQC9lorUxFjnvOaj1GKKBeb3dU6cejYhOKigf7xb6yeFJwM4Rlmj3ZXSD3fJJLOGZmq0lPIXb7cQIXixjr986zSuqcnemsjXiYkjpfPMbcsCr7dI44o/QRhB5j3tLsdCXiG1bqWiirdntkElObLq/yPD/aD63OBb2V7MhhjcxhfmYT7UFOn4oNH28qN0FNH8Nz+EmDUOdJcKcl2BRsIY0Qp9Kpsj5oFwUpYHsydcODN0PhjnoWlSH28gmi/oYwcPC5UwvqmAylM/mvP9qSNdPmhO5yyrYDrguOBhPTh0sxP7HfMifjpYzGuPDFitL/NK
 jn2P3GtO
 j2z5kPl/E0l1ps8ngB7tbeirVMChx2ywUFL6gHBGzVYhQqw2jIG31cz5OI3G+8F9Ike68KFcAYQJWvZBfJ9l+FAzyiDYgZMR0aKh/oGipIoNnHqU6FFbhSPJjmM6NKqnrTna7xXOIAe9JLzhR4o/CX0dwzllXX56GulBb3cIqA8kE8TlO8VAiekLWQKXWN091eWY71igKyjjthJhp7QeGuUhhoxezeh4zFrLc3DYjZSA3ycI93giJ2P7+TOxeevC5zE/79k2txU3ghBhQKzts8A+fEIvAS+JR2NpMecVumFm9vUVUNJpXw/k812pUupGh6B8R6vf7SsjfLcTsGsx4UTsdLyOF4JEgJDNlBDKGCiV964jct6aPT882g8E9KFO8FnoMiPwt8GAuDBJKZrohrsGYj7fhCBcnlw0oEwo/Akd5rfHX0zQBA+Ql3Y64JQzO/3Hm0bfh/x6tSkr0nS0XNic0R1KwtE2NC77add2NsJBGsteo8WHsSEjZNXqKewkppeF4z8DnnjE5QkEmDeX2r+H7M0ManIouWZkLmH2wGTI9t1cr+UTuibADNyyDcMKoAVhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

When the last memory of a zone goes offline, zone_pcp_reset() frees
zone->per_cpu_pageset and zone->per_cpu_zonestats. Nothing waits for those
who found the zone populated and still use the two pointers. They take
neither the memory hotplug lock nor any other lock which offline_pages()
holds, and some of them can sleep:

  CPU0 vmstat_update()                CPU1 offline_pages()
  refresh_cpu_vm_stats()
    for_each_populated_zone(zone)
      pcp = zone->per_cpu_pageset
      cond_resched()
                                      adjust_present_page_count()
                                      zone_pcp_reset(zone)
                                        free_percpu(zone->per_cpu_pageset)
      decay_pcp_high(zone, pcp)
      __this_cpu_write(pcp->expire, 0)

The same goes for drain_all_pages(NULL), which takes pcp->lock, for
zone_pcp_update(), show_free_areas() and the readers and writers of the
zonestats. If the per-cpu memory has got a new owner in the meantime, it
is corrupted.

The pagesets are only freed because setup_zone_pageset() would otherwise
leak them when the zone gets memory again. Keep them instead and let
setup_zone_pageset() and zone_pcp_init() use them again, like it is done
with pgdat->per_cpu_nodestats. Their lists are empty, and their limits
have been calculated for a zone without memory by the
init_per_zone_wmark_min() of offline_pages(), which is what
setup_zone_pageset() would come up with as well.

Fixes: 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes empty")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f1048168c90c..1850a41f24f7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6308,6 +6308,10 @@ void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 
+	/* The zone has been populated before, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/* Size may be 0 on !SMP && !NUMA */
 	if (sizeof(struct per_cpu_zonestat) > 0)
 		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
@@ -6400,6 +6404,10 @@ void __init setup_per_cpu_pageset(void)
 
 __meminit void zone_pcp_init(struct zone *zone)
 {
+	/* A node which is added again, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset && zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/*
 	 * per cpu subsystem is not up at this point. The following code
 	 * relies on the ability of the linker to provide the
@@ -7680,6 +7688,12 @@ void zone_pcp_enable(struct zone *zone)
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * The zone has become empty. Its pagesets and zonestats are not freed: nothing
+ * keeps somebody who found the zone populated, such as refresh_cpu_vm_stats()
+ * or drain_all_pages(), from still using them. They are used again when the
+ * zone gets memory again.
+ */
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
@@ -7690,12 +7704,6 @@ void zone_pcp_reset(struct zone *zone)
 			pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 			drain_zonestat(zone, pzstats);
 		}
-		free_percpu(zone->per_cpu_pageset);
-		zone->per_cpu_pageset = &boot_pageset;
-		if (zone->per_cpu_zonestats != &boot_zonestats) {
-			free_percpu(zone->per_cpu_zonestats);
-			zone->per_cpu_zonestats = &boot_zonestats;
-		}
 	}
 }
 
-- 
2.56.0


