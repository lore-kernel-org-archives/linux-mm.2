Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F70606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FH8yPKmg
Received: by kanga.kvack.org (Postfix)
	id CE1456B00EF; Tue, 10 Nov 2026 17:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92AE6B05B2; Tue, 10 Nov 2026 17:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81346B05B3; Tue, 10 Nov 2026 17:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8335C6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:44:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A2691A0188
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:44:36 +0000 (UTC)
X-FDA: 85420690152.23.E51B855
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BAC6120008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:44:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FH8yPKmg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794350674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pW9oDqWW/PRcNxLLod97kMD+KHWBIi6BHP/J0nIg8/Y=;
	b=uUHmGSQApDp//gTJxvdWq7cec6qDTabhYRmmgaeTDdZI9YSj2xsCe6bJkwCO/NVKEkiEvN
	4NqyGghBd95ugNP5/j+0QPksJ0e+dem14NcdUjiWkOrse8wpHcprPG7LeSaqUdppwRrAwI
	YeadIBqWYt5rullG5H9xD1T8OnbSPg0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FH8yPKmg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794350674;
	b=mhAnz4sh6+gfJRc2RRtL0J5NThQakUQQRV0xYZWL9gCqf49cji/DHqmQnnzI1ub33pAqQu
	9VAalsMM3bZfIzfpypXH5PvdB4nhkFGPr4cgPr6p+84HwKPAvigENlJkqhX6oIZGgJuEZu
	A56yrjGpzM8YfJoMbjc6CE0cAeKKFmU=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b331cad3cfso21280127b3.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794350673; x=1794955473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pW9oDqWW/PRcNxLLod97kMD+KHWBIi6BHP/J0nIg8/Y=;
        b=FH8yPKmgYQQYgqyT6FL7tgEer6BQBYdXmxgOrH9cSXWQsCDnB9ocLNK1yOLN5jHZ5h
         iDflIOmdJMVX3S9Vxdo8mNRgeCVd6lgEKIhasZMPEgjNzRoIfzyJisp0nSc869TftbJC
         qiOtKpQ1bk6i3yUbsBOtA/jfi6IluUA1MkyZ2JAPrKhlLKxbgpAZlW0RYzfNK1l8SrqV
         P3zoja44wdDLz+rkXOorsdYU+wsmGpxP3w9U0u68G82qXhSy4Rhk8HLuAu2vC/Mztf9g
         SSTK+WxrUAMlAaKbJ0UpOgIDzAM1dxdx+aAEUj9Cs1gUulnOoxhapIdfTP560/oNK+Nb
         vy2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794350673; x=1794955473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pW9oDqWW/PRcNxLLod97kMD+KHWBIi6BHP/J0nIg8/Y=;
        b=TWtz8evKRedZtp9NTmE/1qKMF7HgncF8t+0VAh7MhxOtTC/jUwQ+36eqF+2B/NzC+b
         APts9O/lfsHGZrWOQg4hjmvS36OFHSDBE4mhp8TNdftfM4TnQmaotEYmiObjsuxDrUWt
         mrg01uCnhIITOk753RWG9LBxKkoLqy7y6+1uOkKowPZPC9n6w6mNgRkwMXkoHMbGHWCD
         xc8wHAoGQNjD3wk99zyS8jWCw95q/rVOWFYgEZmYcHG6rZ9v+Oep3mfAQI7khi1AlyQy
         kAR1BVfXa+XaOqjb4tpy+7zoU/CHa0g6PlkqM5CPo7QK9RF+S0QIOflNAftaD0zYBGab
         Mc8g==
X-Forwarded-Encrypted: i=1; AL+hErGWF6SFrSM6/4RSMY24ktYivb3DXF1xcbvPUBC6yPocsY/2tQLcgkhMvo4ekdmwI2RdilPhRCU5sA==@kvack.org
X-Gm-Message-State: APuU4Z+kM5HdAaDSTLiI5j3AvhylELMjRO7NVk0clS9x/EiCOzRXNZbG
	qmxNIVy3rrElBrcghECFqfCM7Xwk01562r8po40akSe5sL6Eqdi0kQJo
X-Gm-Gg: AYBFou3B1jAX1Rp6IhWTUai3xWanVKJSigzpL5eQcO7o4JKQaUzhhUSjLsAmhQo3hYz
	zpr0SfVHFsbR1g0jU9EOfh0tbzGuDS4JSIZQlfIzwST99puD4XIiYx63/AAoftfSIAgGJjMYSf4
	5QK3Y2vi2K8G+M0zey9UMLgJQRM5hXvZ8xGsy3+z9tvpv5yEDCpogfRMHD8dfSOQ0rWg5AWcym4
	LieB/oQNA9BUmQ2M/J8Ui+JX3Xz0k/5MzvmuupuTWfqG/yREpqhebpfzAbMSLP0A3sDMKkX9ceb
	LU0SzYMXiMjhr8KvGz0FT9d1pKGIPqBMyaUQtr+xjiS/39U8CjbL87VCdxVKm3Lip2YwOCcnQhk
	WPyVYnk9WZrsmlIYYG81JufsAkT02ZSFM4pm/M3sqtkQRQpRz29fQzxAUHlXuJElcX2QnqHIklI
	bXgxrtcMYbR7oZPPcPUd7rJ8oc5FSECUjF+mfG24IzQ+C3+ah8ekOq9ytgxQ/gS4qIEmLqWgLEk
	ayoaYCD0YVMzfQoF98VcjfTBFptDeYBgcAmli1cDWMhfHg19mWRz4fmHc02ynAAYVrX7GlGl4/Q
	IvITXj6iZHjogVyKei8JOat4v3FNh4c8KoR/oZEk+UU1GNH3elTmSh5v6+gT
X-Received: by 2002:a05:690c:9e:b0:8b1:233d:7054 with SMTP id 00721157ae682-8b3a817a567mr6432867b3.32.1794350672973;
        Tue, 10 Nov 2026 14:44:32 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933a06cfsm30224987b3.7.2026.11.10.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 14:44:32 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their kswapd watermark
Date: Tue, 10 Nov 2026 14:44:31 -0800
Message-ID: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BAC6120008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gyfyheyomh3t145xd6gunbi393wj6ure
X-HE-Tag: 1794350674-285318
X-HE-Meta: U2FsdGVkX19WJZdTwNgETtAcEcPjuUS1dF3ORL6ZlIuPVepOPXRdxNiL18esUcJzG+iozkLwESzLkbi7YLG0sATtf53MGWmREIFarBv9F+fmeo5wVfwMq1c0q00vOrhbxC/o7iNYW9H3KQzsbHX6dKorcdKovQIvYS1JBTHwjddgO7QvKsQvPHPEh88EQ5ZhB+OHsyD3SZXapTPNf+ULP8RSVZKJ2wh09wmPt/ACwwU7CP98mirlmFcz/NYe8RB+Eg/8qWhRVSxt2kW0Updrat1s/d1SYr7ZSgiMDRz6Mv/+2IoLizrFcGVSgmxNTcn3BuuvjZFJ6EzvE3+vHf3ylTiL+z+FtXirWlQPDuabpqEsBLWW4Dd5aK9EQIZARjer9bJYyRrYK8bLrqlThNGf/GnY0yLFKBIwOLVnjZczgNyp1USTyr49BmUhwiK+O5ln+pa0ZIquffRS79kzxwEgjvKUPZcj3g7uevy7nPur488LtKlN2cIl3XOxTen+uWk8M9/35WNhmFWj8C64wlVaj7a5ZPSzWCx3e3jJV55xg9rNNnbrYa5cvkZDFbKdZ2zKAiBAGZ/CFVwurzTJA1OXzlXxnB/z5ySguzeGxeu6Y/z4TvGZUDU7yi49sD8BlObyH2C+1EzJQKwnhtlpY/Nou1GrdvxRVIz+AeDnI2uWHdPOgKb1YKm0W9v4bjwz5xKcmE6hCC3yZK40LtvuJRuyjjoYilQr//MPLI2VLUDTEJa6ssMljrdxOZDk2Y1lwT3Pg4vWJ1R+1767R73117LG7nsUKNry4jUWa+feeL2TgF1uDby+m8NI+4pE7gtbiollqs1v4Rxkgc586f/a8aOm+/xrxOMf5vRH4vmFru7CXbqzzqHJ0+t4q4TKgZ6EWGKY1j7NpqBpJSKMQOWpC3aFpP4bdwVZdbZJZSxgct4hkKafLUgMcq/EmzHEIz8KxMfCMJP0r9rs7oHIwyde1dS
 wf/0kyEx
 q5a21Lex2JPSouKEhIsdq03YlCGD7O8G8HvmOp2kcnUfNdPeFypW8IbjEGtTPr49lmfi+vB/AtfoJhxzpE/+PWK8n2vRJQ7mh7UxquR2pmXEYeAx476+5GhRC9JVc3CrZ3RDmimF5R9M6OZe4nbh/TwxMLYGEfQ9ugO8/+ipOTzDTXgJdpYkL0GqXwg33g5uGAnVJf5UI+THRje5LXCH00ubZxachs5SlPEBVZjNBwpj85bRxJlqKAuwSkmozGnSJdvZlU3PI+6qaay1az3J1/epwbBiERL2GYMo40WFSpNarPWBPg41/sC4NlS1uJSirjfH4Y9z02EwzxflCj078MalyqSOIamLmILQMe7JHycoYjwX93IMuHJbUkIr2CMCb507TfyFPkoV61G4+jEKq52bjK7+3ZhLPSjTY7v+Omo9nrWndQ5OiOzx2P24G1ib1uSei7ZOFfyGAi7oVGKK9oPh0e8oacoFInAXVxzNtCwj2tw/Er/GP/NzvRFQdk9yrEmd5xykThJivXDKBXhhy+8fd047g4TDcazqjsP6qFyXbxuYHRhWrI3AlWRt9L1DomsKh4gyRJGYa7ZmjNVWt5RNiXGHW+Q4VsiJYOlr4axmsbw+X795mRWX9btQJIEeuWI5sI5Q3gKTVd9xkLKTEvjqlnIsI6BcUE2hPv7bTPmHLdbIwqurAjhk9wdqlwx7CP+pP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
NUMA restrictions") makes get_page_from_freelist() skip any node with an
active kswapd on the first pass through the zonelist, so unrestricted
allocations don't immediately consume the memory kswapd is freeing.

But kswapd is also woken for high-order requests. With THP defrag set to
defer, each THP fault that fails on a fragmented node wakes kswapd at
PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
the next failed fault, so it stays awake much of the time even on a node
with plenty of free order-0 memory. This means those order-0 allocations
get directed elsewhere.

This was observed on some Meta production workloads running on 2-NUMA
systems, where processes with a preference for node0 allocations
continuously allocated order-0 pages on node1, despite node0 having
hundreds of GB of free memory.

Only skip a zone with an active kswapd if it is also below kswapd's
target watermark.

On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
and defrag=defer, I ran a process that prefers allocating on node0.
With a fragmented node0:
- Before the patch, 68% of pages were served from node0
- After the patch, 100% of pages were served from node0

One remaining gap is that since this uses kswapd's own threshold,
unrestricted allocations can take what kswapd frees above the target
watermark. The current code already lets such allocations drain from the
high to the low watermark while kswapd sleeps.

One potential solution, as hinted by Johannes in the discussion from the
original fix [1] is to add some kind of fudge factor (for instance,
wmark_pages + high_wmark_pages - low_wmark_pages).

But in tests that I ran in a VM where the allocation demand outpaces
kswapd, about 4% more pages landed on the busy node and kswapd reclaimed
about 15% more, but kswapd still finished and slept. So let's hold off
on the fudge factor until it becomes an observable issue in workloads.

[1] https://lore.kernel.org/linux-mm/20251001164131.GB1597553@cmpxchg.org/

Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
Suggested-by: Daniel Hodges <hodgesd@meta.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Added a Fixes tag and separated this from the other cleanup patches
- Check zone_watermark_fast with no flag to match the call in
  pgdat_balanced().
- Calculates mark outside the zone_watermark_fast check to match the
  style for the other zone checks.
- Wordsmithing commit message to explain the unaddressed gap.
- Yes, this is ugly. I have another series to clean this code up but
  I wanted this to be a feature-minimal patch so that it could be
  easily backported. Things will be much prettier once those are landed.

 mm/page_alloc.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8532af052d74b..56121c3f9c4a7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -45,6 +45,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/sysctl.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
 #include <linux/memcontrol.h>
@@ -3799,6 +3800,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
+	enum zone_watermarks kswapd_watermark =
+		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
+		WMARK_PROMO : WMARK_HIGH;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
@@ -3866,16 +3870,21 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		}
 
 		/*
-		 * If kswapd is already active on a node, keep looking
-		 * for other nodes that might be idle. This can happen
-		 * if another process has NUMA bindings and is causing
-		 * kswapd wakeups on only some nodes. Avoid accidental
-		 * "node_reclaim_mode"-like behavior in this case.
+		 * If kswapd is already active on a node and the zone is below
+		 * its kswapd watermark for this request, keep looking for
+		 * other nodes that might be idle. This can happen if another
+		 * process has NUMA bindings and is causing kswapd wakeups on
+		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
+		 * behavior in this case.
 		 */
 		if (skip_kswapd_nodes &&
 		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
-			skipped_kswapd_nodes = true;
-			continue;
+			mark = wmark_pages(zone, kswapd_watermark);
+			if (!zone_watermark_fast(zone, order, mark,
+					ac->highest_zoneidx, 0, gfp_mask)) {
+				skipped_kswapd_nodes = true;
+				continue;
+			}
 		}
 
 		cond_accept_memory(zone, order, alloc_flags);
-- 
2.53.0-Meta


