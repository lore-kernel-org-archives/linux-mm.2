Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD390606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Mz7ltB8A
Received: by kanga.kvack.org (Postfix)
	id CE4466B0315; Mon, 19 Oct 2026 13:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB596B0316; Mon, 19 Oct 2026 13:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAAD26B0317; Mon, 19 Oct 2026 13:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 873FD6B0315
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:23:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEBB5140772
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:58 +0000 (UTC)
X-FDA: 85340048556.26.A43ABB7
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E2AA140002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mz7ltB8A;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430637;
	b=chMy2lKahAkPWGWVIYqpnQrBCJ2VZKfBTc/w7w3kDnTxgrr3kbYnw0X5d4/BB7vCAHnwUD
	1WDCrXg++xEE+/G134a/KEpvr3M5j8hTdb0j11rdB+X4mSvgVpUqVi4IFn1qSnw8tAOA30
	JiNq/WNYYKclZu/2U81Uu7qkFHWRARc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mz7ltB8A;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hr7mK0JGcf/BTvqE/DMHAbCOD5CXN72ZoZsomAZGCDQ=;
	b=iNmkAPkTDlo8M2E9+NPYcGUd7BI8chNUnEPjdJZ3hqfnl4box/1Q4OgXDYAFb7TOotwfeP
	Xc4Q9UPnA566sCIMjME1RbsUZxk1iCNRgD+TXI1eroxfluNdS98rAENADZuIfIG3IN3Ve9
	NrlKzCFHGy7jloPi6xXXgQBLLc94kVM=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f36c18b75so117214385a.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430636; x=1793035436; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hr7mK0JGcf/BTvqE/DMHAbCOD5CXN72ZoZsomAZGCDQ=;
        b=Mz7ltB8ANg4CdKULA6hvA/4Vm5wVAOTY1kpYDWYyRa/LS1V3CLtgjF/TzawPJO6Uil
         aL/yKzI6LBQL5C9UVajwm9vlYcwDU1sTS/H5VRTn35fcDLY4z9jzMZmpmfctqesUP4hf
         AlVkbCr2BgBwpijNB8S0yYlGYGySeEL7R+L2A2Ey7tnunMl/6mcmcQvXavGO5uY08sJ2
         EirR12AxhO2m3ZeGG4lChzfKXjS79Fj+I9UDZ5iMxO1xV9IM9Z1ACjPhMpn9ChKunMtC
         5rH4exI1auTYFphMs+tK9xWXhm7S8TelwdYuiv11GUTfH3HzMZUcTf9Q/Zf0s5WIG8s4
         5+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430636; x=1793035436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hr7mK0JGcf/BTvqE/DMHAbCOD5CXN72ZoZsomAZGCDQ=;
        b=Jc7djr2NBslqJ8ApeQrHMAHxsOMdmQqAKnOGyhTYIDqsp/8xlhPGfYak7dU4jkBC0a
         AQkMTFOxbmjC2qjXZyu/UMdlVRGelN/6c7MoFQZTkUnGxLgguJnTcMkkrYuiv+jWVeYM
         UM9+ky+Q8AnNpuit6/IATVq2KQqu1Tx7T79qqkn/C3M0j7U/haHtEj50Y3wlGDLKp5F1
         t9oL2jRkMpRMr1eP3E7EAOb/WEL/wFsnvtkgr4sF53bQKdFx+bZ8LF7zwJ/fjGp9SskV
         c4yNyFZwNKjs0yvwtgmHcbNLp8cjwIdcYnmchRhQ0caQV007KTY4/bWf+V10S0WcbimD
         /iTg==
X-Gm-Message-State: AFq9FYLEcOSBwEpvIZts5tsNGPYKu8e9Zz1r/0a9aUcQzGhyOnl4DmIY
	A1hss10OH1j9DknKrHQCGFpEKqKF4M/rUj6v/kBak1znKAD10kuekaHbxUfPKKvkZS0awh5Fg4+
	f9O1eSls=
X-Gm-Gg: AYBFou0FCq/osGggx4jTig5tFAX2QFpv/9KUt9XFMODkHUm60Gvwng47iwGteCIdQ32
	VWxYADkXN/Thxapan5BD0PGYPOl2oSLGCZAf2GBn148GZ1LvKooRkIYjULvyCqQLVaa/YgAkFdx
	sCQJHqeortaHEidnSrNvRV9IEiDx4uqvPGGJZopXT4JuVwz2g5TkCdIx12Zbwr70+wafZ0+Z97f
	JKP5QVet5NwnVUvsb70bRU6ZXEBykVW9YEZI7agbmQCuvPInJxQuR3VtN8E3k4epvtfcE3mWEJG
	PYe71mR2j2mtAAc+Frnco2KL0e+IOkHWiU0mu1c+IWAutkwv6bc7xIpRqwcjN+2dom6NmHUwBVG
	4xLMTUBNQ3BnsNMNeuDA1mfuZSZZYRkuELka6hH3fW7jggORuXVKt3OZCM81FXmIqok9ynyHwwy
	6ka55rwY34b3SdD5LkRVUfIrI9wfF3u7dYzmZvqP/epBpOt/VZIEr6lAJSn5Tzfx0MdrFNFupEs
	8nhkQqDiEd5Gv4gbc3PJmnNQMuSTtCjBAo0X3Q3ubhjtnOMctsTV8LM4oOg
X-Received: by 2002:a05:620a:1d0d:b0:93f:3bb5:545c with SMTP id af79cd13be357-93f3bb558c1mr691193385a.18.1792430636279;
        Mon, 19 Oct 2026 10:23:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4adb28c2sm14615385a.0.2026.10.19.10.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:23:55 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	jiang.liu@huawei.com,
	Bessel.Wang@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v2 4/5] mm/page_alloc: keep a zone's pagesets when it goes empty
Date: Mon, 19 Oct 2026 13:23:44 -0400
Message-ID: <20261019172346.3344005-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019172346.3344005-1-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bfsk5sa8f9f8retxsi7qx5r439pqegzs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2E2AA140002
X-Rspam-User: 
X-HE-Tag: 1792430637-904054
X-HE-Meta: U2FsdGVkX1/2SHuIL8NH5YZT9bmEl+xU/ANS4NWHmIbeXsK3OKVuI1dn9aHzVIu2LapSjG5aYLQHe2lCuYS5Cgn1pSFo11M/p9zbxqk54hxiAvdwizP/wxRmflNmE7PyeSIJtz3yap7gh116ZAeXrG3mIyTIlVBKWmAdkqOHY1cYSukoUyd/V/toy1zlwDBpS3GVMHr550C21nOeppg5P/l8XME0yBtvM7/Nwcaa7RiLz+qyyb6xibxfvCxqOyzQP7u2raUvJohSRtNW4hqAP8zMnPKIDZYkVnOfgOK4ArE8HPcbFuO5LT7pddyo28DFkuvLpruUWfFQl3htKcgsANZ7R5MZhEEwFrZJBq2Zv35biFMNHYJwajM7Hc3mHKsn5bb6DU+FTSh44pF6XyCbXU3dnFBE7IGeV2ye8xWinQoPvWHtHl7lJJC9pMsGYByVLTmZAvYaPYyMs3nlRqC+afD43epP6NhV+/AZ8Y1c/QWSE/GRr9zcBXJQvZXcPbCxg1QJn6OZdB/Vh6fUeT6yFXozOGK8dZ525HqsSYop/7aOwhZ2UmW2MtdnqZ0u7xi4ymuw5uyoFb/WJOhr4co5aPdPBLslBKwQwowiR+FaPW9A5zu2mtL3pAcZ1h/FrNVNIPRf5tFjz2GIdqmAuf4MtI6adV1vJvytDNEblZzqeSKFTYQzodswUn6SY/VtPzfNu5ppbobklY9Wg/X1BwcB9CKN1vnqW/X5PwaouCcEnpIvXnNcLaVwBmcAy4Anuvr4eeZABXyCSQQnYHALP6cbHq6IYo1cg1dwCZmBDSz91GDllwFP1Fro8s9bzhEbH3tZ82Ibcw5b9+4/1WG4qValB/IYce/VniOtUCYWe9O3iI23gOjvCamu2iIE4ChDumDkKcjeqUVur0FqfqP6Wo4t9Y4MAQ1GuhOkb2v95i09PoWYEf4ahgBq3eFidx8YB/wrXzCOz+gfqs3ZBIvItjd
 Nay3EA6G
 xUEOIWAOJOD+ZDgCPi14KVGJneSUJTjkMFaxTRzRepIRZUJTUp6+fTB007kqJ+NDgdYhGPdnZ7dJ7YBsk6jNPIZLqeyRKUmbbXVAACj84JqsR+FrvqZxff2j5ocLz05qPMroJPhOUdASUBaYIFyCSN1uJBlwYqevRbw+BQnyMBc4VaNsm5JBNCyDER55bzKs4Lyo73IIpcw181JtMDunCOI+vh+3synHqLodImsoknQHwH1JKn8xDo8WbXeKuaW4kpgTOqckjkN60Zw+lhi4uMoWh83XLvJpccD71+w1x0RwSxIv34zDQqFCpP9c+9JhISfG0pkKmZGxEzS5e67zPuZm/8pN262oMdt/fRm47k9/+NCUUJhlQURgHYo18W1RLD360rcagAGncR11HFhSJKQA6tHmlVxYoL0UjYZl6bM5oO3Q4Ze+Dank1lqedvMYORfQ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When offlining empties a zone, zone_pcp_reset() frees its pagesets while
the vmstat worker can still hold one across cond_resched():

  CPU 0                             CPU 1
  refresh_cpu_vm_stats()
    pcp = zone->per_cpu_pageset
    cond_resched()
                                    offline_pages()
                                      zone_pcp_reset()
                                        free_percpu(zone->per_cpu_pageset)
    decay_pcp_high(zone, this_cpu_ptr(pcp))

decay_pcp_high() then reads, and can write, memory the percpu allocator
may already have handed out again. With kprobes holding the worker
across the offline, it rewrote a new allocation at the freed address in
2 of 3 runs.

Keep the pagesets for the life of the zone, as pgdat->per_cpu_nodestats
already is, and only fold the stats in zone_pcp_reset().

Commit 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes
empty") freed them because onlining the zone again allocated a new set
and leaked the old one. setup_zone_pageset() now reuses the existing
set, and zone_pcp_init() keeps it when the node is re-added, so nothing
is allocated twice. The pageset address stayed the same across repeated
offline/online cycles and across removing and re-adding the node.

The pagesets take 320 bytes per possible CPU: 30KiB per zone with 96
CPUs, 160KiB with 512 and 2.5MiB with 8192. A populated zone already
holds this memory, we just no longer give it back on offline.

Fixes: 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes empty")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75a440ebcead6..417c427b196d9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6356,6 +6356,12 @@ void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 
+	/* Reuse the pagesets zone_pcp_reset() kept. */
+	if (zone->per_cpu_pageset != &boot_pageset) {
+		zone_set_pageset_high_and_batch(zone, 0);
+		return;
+	}
+
 	/* Size may be 0 on !SMP && !NUMA */
 	if (sizeof(struct per_cpu_zonestat) > 0)
 		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
@@ -6452,9 +6458,12 @@ __meminit void zone_pcp_init(struct zone *zone)
 	 * per cpu subsystem is not up at this point. The following code
 	 * relies on the ability of the linker to provide the
 	 * offset of a (static) per cpu variable into the per cpu area.
+	 * A re-added node keeps the pagesets zone_pcp_reset() kept.
 	 */
-	zone->per_cpu_pageset = &boot_pageset;
-	zone->per_cpu_zonestats = &boot_zonestats;
+	if (!zone->per_cpu_pageset || zone->per_cpu_pageset == &boot_pageset) {
+		zone->per_cpu_pageset = &boot_pageset;
+		zone->per_cpu_zonestats = &boot_zonestats;
+	}
 	zone->pageset_high_min = BOOT_PAGESET_HIGH;
 	zone->pageset_high_max = BOOT_PAGESET_HIGH;
 	zone->pageset_batch = BOOT_PAGESET_BATCH;
@@ -7728,6 +7737,10 @@ void zone_pcp_enable(struct zone *zone)
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * Keep the pagesets of an emptied zone: refresh_cpu_vm_stats() can hold
+ * one across cond_resched(), and nothing waits for it to let go.
+ */
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
@@ -7738,12 +7751,6 @@ void zone_pcp_reset(struct zone *zone)
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
2.53.0-Meta


