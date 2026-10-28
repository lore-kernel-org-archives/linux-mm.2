Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDC8606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hIHs6Rse
Received: by kanga.kvack.org (Postfix)
	id 3F51E6B05B5; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330676B05B7; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F85B6B05B6; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E25266B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E1731C29FC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:42 +0000 (UTC)
X-FDA: 85372926324.18.75F52BE
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE65F18000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hIHs6Rse;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3_0PiagYKCG4WgZUkgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3_0PiagYKCG4WgZUkgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9nw0DB7CsLYp+qBCSaeXNEfAGyso8jZ3gNpbY1bfAE=;
	b=pmh9XSuzyoW+85lA5Jzn5A42bj9Fm4Y6hNICxNZcBnNVjbHtkcCwgIzpEcM/DEzAu4HxOg
	/E6xfffqeoLGdSkxzrbJPDD7g5VDLwUF2qsfdrS27FVpOlfSrmmeGIIi5BBELO/wcTDKJn
	vacqgbHhPry1X9PTWBEZ0AMEQFvK/Nk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hIHs6Rse;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3_0PiagYKCG4WgZUkgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3_0PiagYKCG4WgZUkgSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213440;
	b=lFYVscg6n97SD+rs+jpnlGR7aUmA6MtIaml2GKHf/Cc+E1fH0Du4B6YxH2Yk1B8eYB1Wyd
	KbSKzd4ds6UfEznZWc5YxPZrV+hidALyKo3frDGca07LqszR2mdLbXt+Vb0eAV5+8Qk+aA
	C5hXVyMOrsw7vzZ2E6xXpnyUXmzcvGU=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89f84753b43so1027592b3a.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213440; x=1793818240; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9nw0DB7CsLYp+qBCSaeXNEfAGyso8jZ3gNpbY1bfAE=;
        b=hIHs6Rseu1vwYgep+aXQiZ6SkrvUxKoh5Dlaom+AKDOZJWHhN/xh37e37ffwW7a4bO
         yBx9SxsfUVIBaj6QlZz51sREtq4a/x4tUyR/k6o+IxwQbIkFdwjLd5Bgh4vmoRpOVtWi
         ZWH2HFJFO7nsaEXHy9sF6g4RqNUJZByp3KdG7Ygntw+/m/mlMKKJ4f0y+VI2vjHd9b18
         QYIp5G1g+9Yrs7sSHWfPrrhD4itEpoQmQuD7ee8ZpAHLGO4DmXEAY/mwEoYR82PLhw6L
         SAqziLqROpzVZMQOYA4bg3Xlb2Ux+Z6c0wzzBn0hwYf5hhznGJn/m20nNJNKUegLN45Y
         LL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213440; x=1793818240;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9nw0DB7CsLYp+qBCSaeXNEfAGyso8jZ3gNpbY1bfAE=;
        b=thj0VeRhU95D6WQwvGPGJxFopVhw4y45Te6KflSbrny4Rks0SeCAzLPqkv9RWUGS1y
         u2h7+CuugCvNlXwiAnkAKH01lvkjbMCkbjasLgAVfauJNuMKj8BgT4GrMo1hef6yJCQD
         sb9R96JeNgRfDrFAVrMIQKhx0KsMs4yIrqpvhFjVZOmRDOAMIyaXmgQqKRw/oq26I2FM
         OD/ndBzxFJAKO4D+j69OlzXrq8C1eJ1vnXuS3fVmJntX1v3J600NoVYRpPXkMdqv+KCg
         w0CcI/BcsGRZ1Dd7w7XYjjE4zOVjOZthPfOjPXeHeoEUd5AvQJmCRbZ3LVujQLjf014t
         GCXA==
X-Forwarded-Encrypted: i=1; AKwUvBxKyocOsALDgyID2tcKZmRHmYbjA6gzn9cX825BY33tlsZZFgbkXscFA4n+nWKz5W898ylD93TEiQ==@kvack.org
X-Gm-Message-State: AFq9FYIMuGKr8trbh8WtntedtgZ4bm2GhkVDbSWsZEMAvOjEMnM2WD2t
	6ppqcDiPL/tMg9SiRwXlnotJjP+H+Elhj5oF+W39R3dqOdB6Th4pWoj8c1pYPKX1LEx7PC4+yTK
	V/hD78A==
X-Received: from pfnz17.prod.google.com ([2002:aa7:85d1:0:b0:88e:7f97:e965])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3493:b0:89e:92e:4211
 with SMTP id d2e1a72fcca58-8a6e6efa283mr2539981b3a.16.1793213439488; Wed, 28
 Oct 2026 11:50:39 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:15 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-4-kuniyu@google.com>
Subject: [PATCH v2 3/6] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DE65F18000D
X-Stat-Signature: f4qsp6xnaoiss4dwpfrpy4r3kcawzb3u
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793213440-385215
X-HE-Meta: U2FsdGVkX1+HRPRW7JB+BKgzcD68RbS1/Vz4Nl2hDc2Zp6WaSD87AKbKyCUu8f5XTqCzZzVoWwGeXlJJCGth9srm9gls+kPC9CbEeq4B1vAFQ2SEtKRiMvK6TbX6M9BnTkmAs6Lzqep7Pls4DmdehvIbJd5i2UluEBFe2jWU+//6VdpzHMrkG37zeCfgTornaXxkRJ40bNo5dFRTLb1R3SH7WNjk4JOagWypLvvwdEQw+X08+D6h9zvfs7cYP3bUHqi+f5WnDEg6WdTAw4MoBjejSIJzWurdF8pKTrV+zCmxiG9OOupMkv7czqVzBoRv+XOdL0T7JsZUamrt3TTT19Awzh8CtGJ7+CkPX/qmqJXf8RNFEOqSDosjbFWOTwzuqJWi9QMepH/3N8TC5xn88lG8OQEr1rqjK9nwsdzw2y1AJDYIBKd2hGAEvs5wiEg+cwAxqUgQbEwIr9cvN4Su+8UDrd4dG5o5yKAy3ZpIcYaryTuDIgE10j63eKV4tQav73OGRyUjpD2Ew0bQsB08cI6AvuwCvtTVfrvf/ER/f37fqiGfpbzCRDbQW87iOFjWCH1WqAr+XmsaA2lejrqXXjdjEDXBrBv9ZvCxpOi3dmeNIKWnpdu76xyGCwNtL3uCrtGk2aLKfeDMdYdKctXYPjEZ8RgYWaFdgRn/Q7+urLYoQx5ow2ga4XlD1qWSPd1CBEkSA6mqO1xQz1NDtR3LCW+PKoAKuaRK+tO3mmZpj6XDDnInFmntm1hKoF/6ekcQUsTmNAw5NCCDPgtgxZjg3F8pkLNoAuVFRg2ZhP/qyPP2KJO5nQhlNfsJh0IdPGVjQjK2iczNMzt1+qigHpOJ3uM7gEPEFrOFJbBThMRwtTDNDNmFu14zm9HtkaEOFJUOHEFsdXAI097HdEwR9qj/9p/27vq9qtUsr75cuYmTXyfBTEE8uk0jZkCC3wxW2ZAEMr0lafoA+6zAzwGZCJC
 LSPcGKG2
 cn9Rguv/pJsLT6E9lNFlXzNNSZ/FrWN9YBAK+0m6piijNs5pWNhgJyq7MtH85nCvgcTt0JPoB6QHFrSi9Gq7FD4GnRTgpT5OdSqzJhml6wdgjhIe8UTPbW2P1omNx11Q1RlaRMSq7ti7j2aUxP/90iG8mNhuQ4SNnEyi5uR1AFmR1cu9aTgXzySfQ2GHw+MLJ4JNZNOdQC78+AKnNn7yLPxfAvyGAhioIKpG9zkiwrjvPRT/R7cygbQWgVSd619IKhX7PA23qvP2NQ403K1Qhrkd4xa6mrbGzIRS/LRowcKIJG1nSVsK1RZpBGvoNAArKKluYVDZCF5kL1o4BsqkymHrBQ9juqbnvyKGuApHkHgmvwMuumTW1oLTxyhW0AFuoTv8VJYX2xxsuBtqi1biTZp/r5XyaCkoosWSQGLJBGqMCaAckjTGhZ7/vye1ZK1hJhmc3s6E2LE+bQdfQ71Ef9nHdeUQi8r/+h+h6innC/+Oz028cEKdmd09M+DlbKqBssYyPmXtMWBnvMjEdFjw0ggyY0WXE95FLcxF4c2wHYwBAbytIuy4l0FjLbKNzPXsVOvVKzEFAsFVQa/JPTDY20/2DHFPgP1MOpd2zTmVXpS6PNU4IetZPRB94jl++RsR0c1kff2x85umCPQigZIWzd8dFTJfLIK//eG+I+jogX8tRUYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In consume_stock() and refill_stock(), each per-CPU stock slot
holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
consume_stock() (!stock_pages) or trimming a slot in refill_stock()
(stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.

Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
failure, and insufficient cached pages (stock_pages < nr_pages)
are all slow paths.

Without unlikely() annotations (when building without FDO, or
when an FDO profile does not cover a caller), the compiler treats
these branches as likely and inlines css_put() in consume_stock()
and memcg_uncharge() in refill_stock() right into the middle of
the hot path.

Consequently, the fast path has to jump over the inlined slow
path and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6666acc9cee8..a04b44656b38 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2157,8 +2157,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock)))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2168,12 +2168,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages < nr_pages)
+		if (unlikely(stock_pages < nr_pages))
 			break;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (!stock_pages) {
+		if (unlikely(!stock_pages)) {
 			WRITE_ONCE(stock->cached[i], NULL);
 			css_put(&memcg->css);
 		}
@@ -2273,8 +2273,8 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2293,7 +2293,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
-		if (stock_pages > MEMCG_STOCK_HIGH) {
+		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
 			memcg_uncharge(memcg,
 				       stock_pages - MEMCG_STOCK_LOW);
 			stock_pages = MEMCG_STOCK_LOW;
-- 
2.56.0.313.g2479322e68-goog


