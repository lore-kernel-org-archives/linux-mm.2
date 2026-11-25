Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6E7606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D2ahuUqC
Received: by kanga.kvack.org (Postfix)
	id 6022B6B0AC1; Wed, 25 Nov 2026 16:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA1B6B0AC3; Wed, 25 Nov 2026 16:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9546B0AC4; Wed, 25 Nov 2026 16:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25F436B0AC1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:27:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D74CA0140
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:37 +0000 (UTC)
X-FDA: 85474928154.17.B906520
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4203140004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=D2ahuUqC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642055;
	b=eVEiPD/JwjhVI9hY5zTcPvTKiRMIdE/CosnDYVqSKe2GAEdN0r4WijB512Gfbwgm4XtOZ4
	Kb5bAeyFyFqOfEUP1prYqF4oooZW824MkysL12r+oXmT0s83y5F3p2agdrYasPkZ7m3JOh
	G1YwMBLZpDZqr0s4E9flHD1m6of/+IA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7FSQ1Jz/1Wt3kKZfok7AA+pWSrm3HTw9n8AOhAKasI=;
	b=u5/t+PU9SBVFSYnK5BQnhm2PyKCtONl70MOEJR0o2VPHBvzG4elFdRrBQb/8hv79WYibTp
	+hGWmrt7ZoLQSuot7EZQus4M4mN0v1BFV1PdWAAMkBWZgzkljU9fJ93OO98gnfn4kry1KL
	j/R0jhXNSqPktUOncSVsQdHBtb4TYw8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=D2ahuUqC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-86298f9267fso3355741a34.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642055; x=1796246855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P7FSQ1Jz/1Wt3kKZfok7AA+pWSrm3HTw9n8AOhAKasI=;
        b=D2ahuUqCd1EoI6GkfzFI8FWPMQW0Rr10Iq5ojBw5BXVqDID5VXl4goRYwDRWdolmpa
         w/6O+OXhNM7oev+Kc2sNuJkDAwY6fgN6E7avO3CZWPH7P/T9JzL94hUMgNPyf8AFyyUE
         US9H0YIAsXs4hG8XWkYnXiSyjcGA37VO5VepAcftjNLtRaWN5L45+1AISjLUm3g291gO
         x0gvefXIxIfB5WPIVjXbpTY5EZJ2eId0MCek967A+8sdvVx8gH1tCZi9TWBp6WHUPM23
         4tHoFQGI8nPdPeZ0ehJNFXyfmcEhLY3V35VU9xjzZnnRmThpYFCbuFEG5D6mtUaQaa1N
         +ypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642055; x=1796246855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P7FSQ1Jz/1Wt3kKZfok7AA+pWSrm3HTw9n8AOhAKasI=;
        b=LvVyFVvMlo3PWmGlFYu3u2YCkhIcuHLPDnqYc4Lx3xxcGvJy1n5Aodg4tZcQUcAJ1c
         NIPGGl+5Qw/mgKK9g5DXZTe51RaU1mhdL3ga4mSjuObQf7f2nswjt6C09S2NsxHQyv+o
         zJlo6Te5vL4tszOvhCuCYXLaRKg1Ji6YygbRAJ971y3Ackd+pbnv7nK+ED65slAXdI0X
         5kbr2PYKEGxhLmX0h2qmb6JxdHjuoXERwSRQMFj8dr0Q2ki7eFgds1fvH9nExUZy5+BO
         tA0g9D9DLrDSPQ/agSo6+VRpfF4Bqdw4qnYM4qvUqAIDcWwjzJLYB08pKyu0SzLcwXkh
         ypEg==
X-Forwarded-Encrypted: i=1; AL+hErFUH0PIACswdFGi0dF91YKfkBVi1JZZQGiEP896EaDhFjqD+LinK/PdDX3Nkb2s4m9Aoqsrl2z0mA==@kvack.org
X-Gm-Message-State: APuU4Z8QIbJJagVj38UhZZNKe/7/vnTfgl9FAloL6iWpdqTOhiIYaNAf
	d+AZUIXCJHNDD54j/3GBFfqg/PGTzyTsM9DX3wr/mfQ4+U0oZDbz28b1
X-Gm-Gg: AZFdTZdAqNUtwSLq/vLm6dpe+GXxTqjWOixylrMESK6w+Syh9CEuPj0azLwiTtGPE34
	8RfH9vJf5eVyLB76T+7qoRuduMNpqZ/tGYocCG0WRSYghWHwa5hNvLc0Z2MjGqttzyZ9gzKGSs0
	FIIOt6GV9iaHAUhEvZ6Y0qd9ATMk6k6Ja9aU1syKu5WgBqhZ40uQGzvGckObI8xamtatigKquGO
	2FJaI2QV5Kolv60g2RORo7+/p8fC9F0yIcTAx3Pekh2/CiBC6trRKBtAwCnYuSjayVF6WuOfCSi
	wpuB4WhoJVD/jPVMs+fMdDF67WnX9Yu7HiPtsCRPRJG/1vA/MdOB8+mdxHG+ceIVX1V1irIqp52
	EHFU1O5HW+ibTNtzat63yDBKwukzBlKAM4qg4FViRv7Gat628uRwraVRtHSceLus64R/qRtFyRL
	LFf+rxbnC50BTU2tFRIsplVU2rRgP1x+0tMRVenJDkq1my4b/64Mdgpf0wQaaUy98LqhFZcWOUq
	H1Jn+o9FvZ5vPCp2pb+8VEQI8+3UYjACQzIrKuXeqNlk0apA48gFY0iohlfnd8wZHZ13IfwIQPz
	sUNxHZoy/JY3lnzWnzfKOki0oIcdBflffIs/gdIL21fKL3xt6btKztFSXl94
X-Received: by 2002:a05:6808:6412:b0:4f4:d7:b16d with SMTP id 5614622812f47-57a0bb5c52emr20134661b6e.60.1795642054839;
        Wed, 25 Nov 2026 13:27:34 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57a35655a5bsm14871329b6e.13.2026.11.25.13.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:27:34 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 3/3] mm/page_alloc: disable IRQs around the remaining pcp drains
Date: Wed, 25 Nov 2026 13:27:27 -0800
Message-ID: <20261125212730.1128631-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
References: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C4203140004
X-Rspam-User:
X-Stat-Signature: r1jzj68sp8sjns7o3zdjbn3wnh6gbojf
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795642055-110229
X-HE-Meta: U2FsdGVkX1/tUP562AQlEdLloOLoxf0yxTektUOOv2V0o5jQ/KpEAU6LsZE1in1ZmosOmWNjLDG2lOiRlOKQ383ROxv6kBVJ3bHQe3YSeGEYFAFvEwLGjprAlIptTjk9tjlbhHoKftiaczDl0fj5cd1CCTwQpC4dxVUq02H3ZfrhuYkuHSFUP9Bjy5Rd5/l71FjFQzAB/mJk0wtq0dtR20I/VFZ0y5DnfM83GRyUWlUXqntRlAa/fJ/617aKGVnL511HN9TvvFIlSSw3ohsHUqwI+5b/TMvOPT/1I0gbzON8WBaS2DiDX11BpEBYmGX9RZnNFFKdnVhCdBE2FJRb4VgOsmjMH3Gl/QQ4QUqrhHIbo7J7zHPvRL/1k0HEeNH10Cw1sgb8vIc8AG+68vf9QnUNJqBkWbLTYRFfj3Jkuvz7ZLBBmGEyUGOqMKjpLz/uFLVc3Wl+bQ27dsQCTXvGK5TBT8DR/m23lh3wer3sgMlam0I9oIvAPU+mptOB0+NZLeDAeLIutKVOYt1ersuMKtcoIgRclQH/JfKHCdcxlrCM98Mo+nkfaKu33jDgL2+Nlw2bkj718jCzG80rzVCXoqZ8Q5G3iy/DmmMtdXLJtHlYDZK4LZ8Ilw9/ndLDOV5jvReMbK9VQlpVKzLF9LH5GGa19MW7bInH5F28ifUDQMjywLcQb8LwLWaAyvj5rDEtXQR5qvU5SaBcENFSwbh0ASAKuQHn/Jf/at+fbtSphmL4reSC+h019y+qcz1PRib6eklr2gxdvpwNKndZKCuThURA1jg1kXu0bTCtB5cocTdvd58s3lqxBxmpfxv6rMOWMhwrCwmn1ASTUpFXFHPZbCZTDcqcBNyG5oefns7Xexvg/89bz2IG0lG29T8SZ7xu8h99d632dGlYpz96XfQBFUQ/cc8bBYhnQtsA9wuMinI1LhjMm16UGN5BCQ3Xv1nCIBiXYbHLpDSJfUd11OM
 wi/tuTxa
 iIgwy7Lsk/Drzo/CGAoTO6c/OfMyZrDGwVm5IzJteJQX9fl/iYuoXlDq008XhHEymxBHOzsVasznsVUpz1ytCBi1Qfm1hndJYBkrGV2+bf1eFxSrjZwiARIH5BORdTdTDONi6evgVFr+zhQZUfDDKmO16MmKvGlvHY2pDxjkpeSlpnwxi5EANZ2BIcXsaDaZYHiiOkshpP8YkMbpe22jqHcxWQwl/QJzlPw1HuAyA9wEtdU7wJhACy91HxMJJeNhQ+1/lg7Bnt+dFlAjdboACtnR3nsRIeAfwRm67tC5ozt0ObVkokL8Ud7uxnuZ+GT0IAFP+6KZkfkBfJL9W97/4txOity4IBUIfb4k/ZjUI9H7Yogdmvy6EMrKKDf4TTeY/dTSN/OgEhG5YV1XWUvAfk2GQ8t6Eti5bE3F9MLPAaUyzCVVpaijeXOU3oTR6TdWVpTZJZu5Xrn+U9jiTCakHwI6QscJ0+nmqgBkjvW/mZtztiANlj4bjeKniaJHRLtzcr/b2VQhJe6lQit+q10xT2+Ksk63cV9jk6rwKJzl/AKsCvceVtMvjoCZFzpURc3noD/uq9qSxi5CW3UFPF6yil0R7H2e+Ww1SMe/YA76x3eUfOEUDkalDUUXCI6nmNRejYkYo9LcfXJbKxAeg0MrlA3jn4wjcngR7b5fvH/YPnbMg4XLX/dgjxy8faIPSVoOIOSTNMWfuVcab+EFkatp6gAc1qJr7d/CXKTZAAAiqPNFSVoS8G5GmK1dKZ6WOdXGZsMa3xonKtCdKbgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

decay_pcp_high(), drain_zone_pages(), and drain_pages_zone() also call
free_pcppages_bulk() under the pcp lock, so an interrupt can happen
with the lock still held.

Disable IRQs after taking the pcp lock and restore them after dropping
it. Note that we can't use spin_lock_irqsave() here since
drain_pages_zone() takes remote CPUs' pcp locks, whose holders keep
IRQs enabled and may be waiting for this CPU to answer an IPI.
PREEMPT_RT keeps IRQs enabled.

With zone->lock contended in a 128-vCPU guest, tlb_remove_table_rcu()
callbacks hitting the fallback went from 1.5% to 0.1% (the two previous
commits brought it down from 93% to 7% and then to 1.5%).

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0e669e206d371..f2cbc820f24b7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -178,6 +178,9 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 		spin_lock(&(ptr)->lock)
 #define pcp_spin_unlock_nopin(ptr)			\
 		spin_unlock(&(ptr)->lock)
+/* Like pcp_spin_unlock_irqrestore(), for callers that did not pin */
+#define pcp_spin_unlock_nopin_irqrestore(ptr, flags)	\
+		spin_unlock_irqrestore(&(ptr)->lock, flags)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2599,6 +2602,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, to_drain_batched, batch;
+	unsigned long flags = 0;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2619,8 +2623,10 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
 		pcp_spin_lock_nopin(pcp);
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			local_irq_save(flags);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		pcp_spin_unlock_nopin(pcp);
+		pcp_spin_unlock_nopin_irqrestore(pcp, flags);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2637,14 +2643,17 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
+	unsigned long flags = 0;
 	int to_drain, batch;
 
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
 		pcp_spin_lock_nopin(pcp);
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			local_irq_save(flags);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		pcp_spin_unlock_nopin(pcp);
+		pcp_spin_unlock_nopin_irqrestore(pcp, flags);
 	}
 }
 #endif
@@ -2655,10 +2664,13 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
+	unsigned long flags = 0;
 	int count;
 
 	do {
 		pcp_spin_lock_nopin(pcp);
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			local_irq_save(flags);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2667,7 +2679,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		pcp_spin_unlock_nopin(pcp);
+		pcp_spin_unlock_nopin_irqrestore(pcp, flags);
 	} while (count);
 }
 
-- 
2.53.1-Meta


