Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABF2CD8C8C
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 11:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4AF6B008C; Sat,  6 Jun 2026 07:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C186B0092; Sat,  6 Jun 2026 07:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9696B0093; Sat,  6 Jun 2026 07:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B97D6B008C
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 07:42:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB823A0439
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:42:27 +0000 (UTC)
X-FDA: 84849299934.22.5517BBA
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4BE2516000D
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:42:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sh2DPYgB;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780746146;
	b=SSEey/1m6HPjpO1uNScAXx5ar0XIGZQkuTg5VN8mq5C+ekP/kULM4DWLpV7RqBrKllXXOR
	R93fPax7V7uxGG/MY6CsfzO57Gpv/1seVsWVLt3P9QWq0uVU3B/KVzOgi4vDkCf7uarEPY
	Mz7EvBR7j1LGP7fJmVmFRT9QDziMywE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sh2DPYgB;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780746146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjLkqSwz++whBKGw/N3/SE9JcCfj2BM6NfCAXyiYS+A=;
	b=DL1JX4tvG522rFjp+HEiXRr7mBjJyHKSFXTvKyAwTaeROzWN5wJw585J+VxZjVFM+0CtqR
	UhEtnQlXHgOAVZAlwFfFJ6S0ZnF7/ENAECAQ1C7FiQTZX7hhH7h+R4e60oY5UIztjvSEBo
	QHvg7f28fJpug9Okb4hKgN6EHZU1Gms=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780746144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AjLkqSwz++whBKGw/N3/SE9JcCfj2BM6NfCAXyiYS+A=;
	b=Sh2DPYgBxZ8VwZuzhQMnbgiEqWZiE+nUlYUyBuWGjT+kloUbH0iUkengc6osoNJIdkfylQ
	2VvpHi5wiK2b60MRk2aBuMRBOwZJgqM692yi3nVONHldLJO6VvfWvE82E63qjiaAN24lUV
	AAcmoIDoe9+TAAZOLPnB+u1c9Vr2Rss=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	tj@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
Date: Sat,  6 Jun 2026 04:41:33 -0700
Message-ID: <20260606114158.3126210-2-usama.arif@linux.dev>
In-Reply-To: <20260606114158.3126210-1-usama.arif@linux.dev>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BE2516000D
X-Rspam-User: 
X-Stat-Signature: ytiy7sknmqkt7tx66bpms3uzug95nmy3
X-HE-Tag: 1780746146-112290
X-HE-Meta: U2FsdGVkX19uyXKf0d1nmQdryJBYLG/50PigsDgeeaQ/9isAaVCKy70x/YIgh+yxnaJaSVepHzdYL0oDw/qR3Tn+j1ycyhlypWzRQm/Bjz5QAbczaeYfbNU8f2L3b1Y/Rv5VoJZvrrXLDAWuKtIx/kZa/ksx5XgN1pf19DDdtDAS1yYS07FryhU+YDwdJYhRf+FoSjpp5rN8VIWfp5DPEDfQZWm0P2EIZMRECnx+CXYDt/kosPjaBQHjrZ/7A1BXeuLnYWeossXMPL1CrfUYskqvp3B+CjOsVaK6iEl5voWLRt5fBYMELDZWnRkF9C+bsCNntWdRQvHYZtCTSOihNSf89jeAS433ZsNWdlGnMiw6vN652avXeZpftCHUoWPLIRiBtACkw8PSmywfS5sIiQ7SohE2s+ES1gB6uRt8xESVe+nHEgYceoKtlEIQ9893+uaH4pRmAjwMs2DAmSiWhs6SaiXjLZM5P2smaF1pGk0PCqc4Lw5QBZKXD7a5g/PSth7mvlxMup2h1ezh/yKxzFXrjiavdPVuGhCEred/ckfUr4HdiuyZpcAjlbupUiEPfXRi4BuAxcu+tNyn/pYilZfY2V7ayisZnBJI6ofPurld+SZ9DtGuoWafzM8ivLtTYVsbx5kZcOIx8aJff9y/TCFNiHG2NRBAJfThrcQ8TGY2fUUNXyHN7OZt0OZ0L4WqZV3js9IKJIC4Cg7fbPer1Dl9SNWpoknErmybDBtyViHxwts54+LlokTe2XpzIM3cRQOkhRgrPncUkIv+UzU9GkSY1dhQ8ojK8Cttjc8q1mmYuSLkUYxrdGe1MOg/JuB2Xt2D6S2m1ILJLoeKn15wHMJy2+9YuAGjNplpG9GaoyIDeaXEz5j06obVWHvsZF3OjJu8nLXAnqfadyJo222aw8ISCG+H/9CMhFI4r9BUGoKw2s3d/0MTqI3bKVW1FMtmue4guWtmmCKWOFcantz
 sIpFl0Jx
 Fzr6W8VqEJsauVBVg+jW6jxmS8jiu/4W06GY2dHU4LFSVZOpbJDLMXgNOJ+p/X970BVfImSfNZOO5TDBcEKt5Ys6OkYpQg9oIvL6ynHox4jVEaXx+dOe/uw17I3Szn4R1ieOYrA68O5RTnoYSGivamzj0VtY3Wc1NZFEVx0q3krr81PYMutOTAPlZVtDT7IJkt/nFWyrh7acZ7pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmpressure() has two outputs gated by the @tree argument:

  @tree=false drives in-kernel socket pressure (mem_cgroup_set_
              socket_pressure), consumed by TCP/SCTP. This only
              applies on cgroup v2; on v1 socket memory is charged
              separately via tcpmem and the consumer reads
              memcg->tcpmem_pressure instead.

  @tree=true  drives userspace eventfd notifications via the v1
              memory.pressure_level / cgroup.event_control interface.
              v2 has no equivalent: userspace gets reclaim signals
              through memory.pressure (PSI), which does not touch
              vmpressure.

The existing early return covered v1 + @tree=false. The symmetric
v2 + @tree=true case was falling through and doing the full lock /
accumulate / schedule_work / parent-walk dance for an events list
that can never be populated. bpftrace on a 176-core production host
(cgroup v2, CONFIG_MEMCG_V1=n, 285 memcgs, sustained reclaim) showed
~16,200 @tree=true vmpressure() calls per minute. Add an early return
that skips cgroup v2 + tree = true which avoids us doing all this work.
On a v2-only host this also eliminates a lock contention path that can
serialise reclaimers on a single global sr_lock.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/vmpressure.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index f053554e5826..c82cee1ab43b 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		return;
 
 	/*
-	 * The in-kernel users only care about the reclaim efficiency
-	 * for this @memcg rather than the whole subtree, and there
-	 * isn't and won't be any in-kernel user in a legacy cgroup.
+	 * Only two combinations have a consumer:
+	 *   cgroup v2 + tree=false -> in-kernel socket pressure
+	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
+	 * Skip the other two: nothing consumes the result.
 	 */
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree)
+	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
+	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
-- 
2.52.0


