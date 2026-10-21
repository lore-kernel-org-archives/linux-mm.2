Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE1F606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=pRs1uIBU
Received: by kanga.kvack.org (Postfix)
	id 9AA786B0198; Tue, 20 Oct 2026 22:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A966B019A; Tue, 20 Oct 2026 22:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849836B0199; Tue, 20 Oct 2026 22:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (unknown [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3726B0196
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:40:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 563231A045F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:40:01 +0000 (UTC)
X-FDA: 85345078602.04.86CAC34
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D2B5140006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pRs1uIBU;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abLwrGFXoJBlnSAGPYLFFR7ZpE8C/Ap31b+sTibNse0=;
	b=PYoqUgP1Qb8jy8IA+ICHztbsgSQWsaaz6NKAcNXzOUjPkSYXJ0p0k0Ak6s5llBhwzQrYgc
	YRhEW1E/WUO6Ljgsr9lRk1/96GDDQqvYmHBW+kdgK+pZjh67dIxWIA/6EAF2KPMXIDWpVc
	aHeVoD53m8LIFo0xNEMbu9sXux88uTU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550399;
	b=3cJEbQVEU0I22GlrMKMD78gvMfLpFtiXox9t4yQJdGdlx8XwA3IhWEqwSzRogPoc+Ujd9f
	2YCFo9OxGhKWpxiKhpXxqfXrt5GntT02toVZdS5QedRKEysbnxmJHDod+GxW4W1CxklWyo
	CiAv+8m75G3Irm8F+dH9+7wQqQpRdis=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pRs1uIBU;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93e64d52949so25157685a.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550399; x=1793155199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=abLwrGFXoJBlnSAGPYLFFR7ZpE8C/Ap31b+sTibNse0=;
        b=pRs1uIBUrk5SHxhZ8AWIX4LyehzkftoDliJCKAtXKEuvHayAlBxIuPMWPWJ90jeu//
         EThM7z7xMFAbDwyonz4/gyPRHZ9t/suNU6P6q+8OeXuiPMcW5XjXoqZFTwigSsNnBlYj
         gOICAWeh8LBd8rGBJaUP7W99CrgKKwQ+aizlmfTZhLbOip10Ss/md+0qucYOd1tM9y9G
         7rfjVeg6aDhXdsyTCr+zC9YlJaCq3Pnn2E38g7+lV29MfLVgmbQ7CuXwimP0MpnIfQN3
         OotJajMU0czvaQfpjShE32Co0udjAj9AcUVvbJLhNhzD1mM2pZS1BJycUpCxV1h0zMo1
         4kLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550399; x=1793155199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=abLwrGFXoJBlnSAGPYLFFR7ZpE8C/Ap31b+sTibNse0=;
        b=gnUXrhfsJf0q95QbceCIaW6PCgsV4jvt44ON8s83Pv/2GwJzT7+y3AB51Rw4dEaWgl
         ty+9qpQ/6ZMQHv9a90Vogqw3gHYtpBy8amKfYKbThS+50wayftPpBkW+0ofjHI2HX2qf
         CAF7VDdp0Xa0ILmp+9tOXzBY1ug23Fca/LL3H6UtXM4fSTov+8bYvn5J8c/a+iiuV3i2
         8OVFM9skntUYmx/bnMT0LTYKzgkzUFVsmLyatgKIIid97NyZiyZUR5ro8rAI4Bd7OYLd
         yqW0LDuCker8Phm9v/tMKt4fUuYy9grYogaLemhwyGSGkDxKqHnhZCLPTB5qBOBopbf+
         /uYA==
X-Gm-Message-State: AFq9FYKJAfp2HtsFtAniUpOeBzK1jV6HckUGPLyheeD6MzXpZGrQtbhp
	uKqUFvyC1BDFZ2BCBiGzDk7ppDcUAISSnp8ilpI3TfvZLXRqxCA6EsC7r7oTZ/H9XHc9/YOfIbT
	7GoDz
X-Gm-Gg: AYBFou1PsQuxodv35jgOU0REF7pJLLdOBD57LqhbFOZ8RK69fSucHrSP0eq7HrtUIxI
	dlrmsn546cJH63yA/aK7lRkbgVQXn1K3i4yt2Dggqt11XMUsq+O7di/dD9/Ouovv28ap8vyXFIv
	J4fOIdmWLGN3GvgthjMUPmrDkZ+ZE7Alcas28zKRYzi9Zp2O487DU42FzH8MNTSRFl/WwRa8MkR
	bsUF0fX8p75RB6GyZeMYFCJWKYLgUYBf0NiciiNWgCB3Xi71Dga3b2ZO2xy06LirDezFWbSoAT9
	q6vDlrgXpLrTA6blIwasd1K8/89Y/V4QWMEAnYWFyNMHW+FAmnUUM6JMYmVxU9Q/P6+n9T5ejRh
	qBVnzGY4E4mER0i2KA8vZG45bSau5mbPY0jkyH9GXefr2ZSvYHEegQLimIoKro3+c77X/H1n5tv
	J1YDmerFVXvjHfcZOvyk8QU9BPmX9/KtHxr9MWHgdY+h8Fh/daj+ETS6Ku+mzFACT/xL8klg/W7
	gZ1rr7AL/dxoXavkkwUOGggkpy6OsWsHuoXfElC5uQZ1nTYDpuEj59aM4W9ndBIuSANEtQj3LwS
	uuI3VcFqIxx5stZQ7ZAMYaI3GzdZnpyEbUNsIioZVw==
X-Received: by 2002:a05:620a:3187:b0:93f:1823:308f with SMTP id af79cd13be357-93f57fe8708mr199104685a.81.1792550398715;
        Tue, 20 Oct 2026 19:39:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:58 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 8/8] mm/page_alloc: keep a zone's pagesets when it goes empty
Date: Tue, 20 Oct 2026 22:39:40 -0400
Message-ID: <20261021023940.1940971-9-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D2B5140006
X-Stat-Signature: e9qbak3gpznrkpdmkmuqgz8wkhod5qr9
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550399-300418
X-HE-Meta: U2FsdGVkX19LieAqXImtfHerd0P7XYktYxsE5sqKKQ0AeTqS0cDbuO9+mcMuWHOlppbw1ldcLsf6bWWOeaWR9X6Yq11TlmnNwUtEvr301uR6egvYljQEGJhgn3A6QtfnV4+VdiQ49FiUTT8tC6L4ys3UFiiVojNJzhzFsggLp+vPkcgIkotIT/IUw6cQOM1n4jrXF07ydL8vfJXDEuYxmSwXRmSLNLqYbwBra1ta70H5TxHd1hbHGh9NYJUV5VjEk5saU1RXmRkKpIm3JnOzEqwMY2aL6uN8CZxE4Ngbk5WZAkLo/Q8VNWBy/GPKWn1AAubNVt81T/up6tPm0lo7fUUAGtU8nAp1B3Gk0ajLhbw43dkLbq8FhHvlmhZ4DOOJlUGEG9Dix+q1xxlC2ANjwWRouMmCn1DQGJIN4lo+BQG4g/gBKsB9t9mpYalJu3aVeHj3ZyPJWP4H4TP9XqXs1AR5nrKMkkc2aLCbKWQQc656bNOHL6GwU6BS4wNcZzUPFMZK2yxbqBCOlHsyr07IFGx/eHC9ABrXG5wf3I8KNGyT2M07zi9QvK4leSYqutktT5x4/L9t16lftKDjrt83mihjmZ4WdfWMaILCEdabxCrF0bLwblkqflHvkCQcUxWSn8RggQWy5B9Yb6K41rZSOA9Z4COVx5kRB/q46HrzYsKq16HyYWOr+v4EzX6mgtSWazj2iO03S8GCAAZv7vbl7r1BDlXEOC/NLHTVvVUHfumDcUHIGOX1F+TESlnCfqkoZERUulRKGRxz0D+7QOh3p7kx0w3f9IYdZCj2vZFINew1nP3ctKq0JBIH5k5w+urzVdQfq0D0a0QS9elXjCFohZL9Q71/+tYiZCyi0FKQTHt2WkiXBDQyq0aCFLX09Txmtvl3r360o48EvMFYWlePSkj+76Te+jbI7+GlcoVUrGJJyDXInsaG3u35Kstr8yhSUpGFOim0UbwS0trpvee
 ZsFzv9th
 trb6ByrhMAUmbKUsER8RzPPj/aSH9lhavumML1wTs2ux4sQyNi4qfwrxe1NyunERpb50exQoBJiP2D9WcDOb2As9cBig4EUqtwySOP30kZ32YFH0wN4GcJ8CSdZ7kPtt80bv6IP7Ja2GIsQfjFWeiZmso9Cp7c/du4VkJkAyl0KiPXIUaEe1D6BzNOLFgsz5FGiFJA7vwQYNYC/NBGdq51JHhzEkhR79Ny9U4OjB+2Aami2p1tNAgsrtm+EXy9v1RRBkdiV0BzHBziKP0ubN66wRO/sygy5nmYDogCKZUqdo+Wiuh3dOrbDc3XiEnjTBS0aIEfR95kweXBxe9wVDGSOm9qDOLiVqOO9vA6QZZc5T67HZ/gtsBN/CQFg8k2kzsb7JrbiYkn40PCgPPUu3TeTdOA4HFl8UN2GnZNBAiKaSHRx4qVFmtc1hBxglE6UcRaXhJ
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
across the offline, it used the freed pageset in 6 of 6 runs, and
rewrote a new allocation at the freed address in 1 of them.

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
index 96ae09c8099be..dfca77764f1fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6369,6 +6369,12 @@ void __meminit setup_zone_pageset(struct zone *zone)
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
@@ -6465,9 +6471,12 @@ __meminit void zone_pcp_init(struct zone *zone)
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
@@ -7749,6 +7758,10 @@ void zone_pcp_enable(struct zone *zone)
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * Keep the pagesets of an emptied zone: refresh_cpu_vm_stats() can hold
+ * one across cond_resched(), and nothing waits for it to let go.
+ */
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
@@ -7759,12 +7772,6 @@ void zone_pcp_reset(struct zone *zone)
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


