Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E98B606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Q0vS3LDe
Received: by kanga.kvack.org (Postfix)
	id 9988C6B05B3; Fri, 30 Oct 2026 16:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970B76B05B4; Fri, 30 Oct 2026 16:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F696B05B5; Fri, 30 Oct 2026 16:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5019A6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:54:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7202AC04EA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:40 +0000 (UTC)
X-FDA: 85380496320.08.9C3C96C
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F3A0120005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q0vS3LDe;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793393678;
	b=GA4UU5T2zGLYuHVaf6SLlEREOO0bNopcc8KMnhYt3zwMdG2ZIfDug98cBtEHvzUUUJAwmD
	iQfQSIuek/n7Y5aG978swTAaW9l0H/uth+71gTX7E74ZkFMKbPqL9VDTcyUm9JXoz+H/sG
	Je80FuyBmk+FcU0mDDi2qDGLzGznA6Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q0vS3LDe;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793393678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hWhsFqL4o7a+PlWoQKkkYolvzPkWBNQ122cMEPY64o=;
	b=vLDj/z9IZyLyrJ2BwDFXaP5I7Qc61cmpgv2m7u5gMkzAyBibBvC4tuguqLA/DgnyASem6W
	tS/XtJjbIWpy9FjtGXZoInntdF8RYYahtZYpNwc2mSVjGgIw8dpXyclIGq1fv3sZG8dFB8
	bPmG37RaEB+c/01fT3NtvNRniMMkSYk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JhFjjTfFHwS2ETw6CvldSvQqCSIDUPmk8rGckT9Z2J0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393677; v=1; x=1793998477;
 b=Q0vS3LDemhwAC/nakTJrIhZPQlKSALkwEH+DUCftDKTKOX4nMPm89tRkynmybIJc/zTMWBho
 k489W2wRGzfPUSoYmUvYA1CVZYh6SZSEVQHPZmIPwICTzXDokWMtjJ6xsMmr9rdRj6yBjLR9J6M
 1sH+sn6ug7Lg+3ZbAOVKwGEo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id de517227bb2ad7eb;
	Fri, 30 Oct 2026 20:54:37 +0000
X-Mizu-Trace-ID: de517227bb2ad7eb
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 2/5] memcg: force charges from reclaim before trying the limits
Date: Fri, 30 Oct 2026 13:54:13 -0700
Message-ID: <20261030205418.341214-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F3A0120005
X-Stat-Signature: cg8emcs4ohwfh5c1ohweh58jowryogwd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793393678-921005
X-HE-Meta: U2FsdGVkX19IoC+UVFmsqWLk7jKVzhS1wyBHDlrlTDws+Hs/GibC0G41CROV08v3jt25jggdyFwEczHDM6lPyblsTRXjMXdwZqdbDu7CJBHuuuPZ7wC5EsRn6fZ2M9nVph8+h7xnN9Bb7zkBkxEfMGNREnMJWUFH36yx2VnGCInW4ABVt03Dy6UHrsCVhXCgOwceELxUQK2OkrxYV1hvjz6oYh255/0lUQRp1AC9d6JC+ecoaF1f211H834cSJO44eZkFtED2MqhciQvJecJ1z3UDrWMvZnhpLMYV1YAzBLyv0vIatcUCBCWFDQ3RDzAIw27pdky4WfjYkW+2kYhCSeC6z1M2k/azUU1HuBGBNtTuo7QHxfbyhH2Z4llaGKMBKpj31TKZSERGoQkfnHxjen1wMWlOwHaacm7WRZ+sofwh/1bQX8KvuxEZq9bEi3efIkxq1UbmNkt22Cuw278kYdtjaMvMpF9yAxTZWDCOhN6Pvo5an+sIi5Ml88W2gf/vmmbgzgbv5xLTXzazK/jCh4NHuUPiBaIyNGvopPWQevXj3EK/nvKAxFP6bKCclDmutrNGO0SlZbs/BvFJ9pSU6WlG4FWdoLoZuRYtn0Hij9XBJeNJiVXbHKSmHr8P4J6jCqEOKlQ/xgKvo44ALEPxv/A82/72ZWuN2a3c5v6IVTFDjh4HFqwO7LD6hFy4uqvVgSvw3MhJETREb+I8NXAi0nVX+AvC0bmBqyDkYN4qC48vBqgOpqhcGyFBeYDHF+cpGZybZ9uhahuAbcbIaTpHzbSr/vRMzNV7lfWBRprHb/RERewagLnlSjtHKbEcsPxI9OJyKEuFh0RbYL2xJD7yzuN4VjBsQkbN9wHdtLDipy2jRigbco0w5N+5V4UKJfhEF8yo/XnKVXC7uW5AdzIhOZrijvdESaODPTJOj6OlA2CMPxgq2grfGXB+I7y8v18lopP506lUmXNT2sHmKI
 NBcGPFKG
 ee0rcRsAULQHT4rAbSvEHBttPwGLLayNgrPSWxlN0dXBjsN7tc+XLVtdyl7vi9t+OezDl6ma6YmPBK/yGH2blfy3mwnNwomzpM5ASfeUUupwVzLCdImrbUfKgfIvRc0v5g7XMKBZhcr0hEK5TOoHgPBapegkJKvh6oiczgOBEYtDkQpDgwp/pdKEriMbS3RcdNOEnvBtpDupwgA9DfzSXaGEG5gxsPG3LeXjUZP2qhySBBsVnBsy2X/2bHuu8QNqyHPyLdrCbus5IuASdOCyzQZEYhmpKItWEXn5d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim can charge memory, for example when zswap stores a page.
try_charge_memcg() forces these PF_MEMALLOC charges, but only after
they fail at a limit. A charge that fits still has memory.high
enforced. That can make a task in direct reclaim do more reclaim and
sleep longer later, and kswapd records overage that it never handles.

It is also a problem for the next patches, which make kernel threads
queue high_work. The worker charges memory from its own reclaim, so it
can queue itself again. With those patches but not this one, the worker
queued itself in 118 of 284 runs in a VM test with incompressible zswap
data.

Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
memory.high, as they can already go over memory.max. Drop the
PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.

Other effects:
- As before, the check reads current, so it also catches interrupts on
  a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
  themselves for swap over network, so the check can't be limited to
  task context.
- These charges no longer charge a batch or refill the per-cpu stock.
- MEMCG_MAX still goes to the first cgroup that the charge puts over
  its limit. On cgroup v1, memory.failcnt no longer counts them.
- high_work can still run again and again when there is nothing left
  to reclaim. This only stops reclaim from queuing more reclaim.

Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0e484f7f823a..af95a4574a0f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2762,7 +2762,6 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 	 * when it rechecks the overage and simply bail out.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
@@ -2787,6 +2786,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (consume_stock(memcg, nr_pages))
 		return ret;
 
+	/*
+	 * Reclaim may need memory to free memory. Let it go over the
+	 * limits for a while rather than fail or OOM kill. Doing this
+	 * before trying the limits also skips memory.high, so the
+	 * high_work worker can't queue itself from its own reclaim.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC)) {
+		/* Find the cgroup this charge puts over its limit, if any. */
+		for (mem_over_limit = memcg; mem_over_limit;
+		     mem_over_limit = parent_mem_cgroup(mem_over_limit))
+			if (mem_cgroup_margin(mem_over_limit) < nr_pages)
+				break;
+		goto force;
+	}
+
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
@@ -2809,15 +2823,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
-	/*
-	 * Prevent unbounded recursion when reclaim operations need to
-	 * allocate memory. This might exceed the limits temporarily,
-	 * but we prefer facilitating memory reclaim and getting back
-	 * under the limit over triggering OOM kills in these cases.
-	 */
-	if (unlikely(current->flags & PF_MEMALLOC))
-		goto force;
-
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
@@ -2913,9 +2918,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 out:
 	/*
 	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
-	 * requests.
+	 * requests. mem_over_limit is NULL if a PF_MEMALLOC charge fits.
 	 */
-	if (!raised_max_event)
+	if (!raised_max_event && mem_over_limit)
 		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	return ret;
-- 
2.53.0-Meta


