Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE84CC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E456B008A; Fri, 16 Oct 2026 01:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE2B6B008C; Fri, 16 Oct 2026 01:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCEB26B0092; Fri, 16 Oct 2026 01:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 914616B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:28:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88FEAA02C6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:18 +0000 (UTC)
X-FDA: 85327358676.17.3CC8647
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id D10D3140003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UxA5YihS;
	spf=pass (imf09.hostedemail.com: domain of 377XRagYKCP4q0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=377XRagYKCP4q0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792128496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1BwP+lE50kzIYlwSLzl3kyosGMcVYA6qJzXgYspyIw=;
	b=uiLsy3pEtm5bZx3bvub29L0nJlpVSTBbm6WCjRvWLAFwyrUu3t1TseQqJkRrOEWFzm8Fjw
	R2FGPy8niUCrzBcj7+CxFRN6r7PWld3he/LfbM+/sHQKAGJWdYL942C0pBmXB2pygy4OgA
	fL5gAfcCXD+05E1Npi4kMxwoKP5ObgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792128496;
	b=KujOCtzu+6p/J9Z86TYo90vwk/zbgDNuXK2IKJ2N3+RNHL63b6x7CLtJiVS0EZDXWWG0NQ
	Jd7Mdvy/loOhy9g7Ep62EfGQje5OefrZqGkhe4445pkj3Pyv5wdh/FdQBj1Mt9EbQbWGP4
	gzOs+imEOG1I45ZgFbE73YUyJkjAYuQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UxA5YihS;
	spf=pass (imf09.hostedemail.com: domain of 377XRagYKCP4q0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=377XRagYKCP4q0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e818ca61bfso26536275ad.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128496; x=1792733296; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q1BwP+lE50kzIYlwSLzl3kyosGMcVYA6qJzXgYspyIw=;
        b=UxA5YihSiGPnX1GE1yKHaE9Wup982f/i1PjWIJyMMhavUCZXBkxYYAYlHtrunBj17i
         fZ3o7YC2wZyt/4zeJ6aL21e95I4hEEhK957hrLNUIw1LgacrD4QFP4v7WObwq7MIYLiX
         JXkPk1TLnV+Ro3efe5XgdOA5qFQhhTyHni9Qbr3kPTi/pJtWKBOzrsfcv1zvepM//RLd
         J9FFNQNc22VB3lX9oeslWz3j7dv1/WPuoKjSf8c/hIR04a0922gLBNe3g04cMo6RnkeD
         fMwqicdlFL3leEpovyE6pFRxzpBx2DixKmp4yOc81mSGGVWmIsG+/Xg86wkzHxlLOsja
         T9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128496; x=1792733296;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q1BwP+lE50kzIYlwSLzl3kyosGMcVYA6qJzXgYspyIw=;
        b=zYMoifFCwEqKOGzCA9YBft1SittLsoUMAG6ERwT2WMU/zcmjdz7FHftLn5bfQ5+6rf
         9EPWJjKWSo0SBPoFNrq5dUadoqlTITWkjaiCrQ3liHHOpLqVUrCFqP7SudOlLwyFkWge
         XVBe820wSpi808gHziUIv4ggeCzk4UPww6Cbv9eA4UYVUQmPsYnLPxCHugDcjmtFhwwu
         lgmKmJY93YiQ8K1EEGfEED3DAOaqDglXREucGM6RVJrujUd/fwUEvfx/9GHCCig4Cj6F
         PX1qLoJ2aodHXansahYRhC97ByYrq+wRRCeJzlr32AwFe/Z8VUE1af8j0dwwVM53u6Xk
         n26w==
X-Forwarded-Encrypted: i=1; AKwUvBy7qjVCshmXroABTTOAeUs2rD83wTH13uNo8HW/7lOEgxWiDsXfdXe1ftuEbhIA5y53ag32rVVM+Q==@kvack.org
X-Gm-Message-State: AFq9FYKwPSmz/YCaLC1jpaOveTaOsmOQ2xjpL+ouNxOawVyskscoiFIo
	UobhWc5ci6L3wVC/+qjHhvrooPSGQ94+kCz7hy8F5tsWkf1iXPYV+zwBIuG/79c3OgSUVZfBkU+
	pcOm+MA==
X-Received: from plje19.prod.google.com ([2002:a17:902:ed93:b0:2e5:e061:9fb3])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:124c:b0:2e9:5c55:c477
 with SMTP id d9443c01a7336-2e95c55c800mr44184965ad.4.1792128495239; Thu, 15
 Oct 2026 22:28:15 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:45 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-2-kuniyu@google.com>
Subject: [PATCH 1/5] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D10D3140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zp3ejz169pef9xm19ch58bf5epbn4zg7
X-HE-Tag: 1792128496-339356
X-HE-Meta: U2FsdGVkX18btKmxrbVRfoT9T964u57YpfZTxEmRgYV+wCQQHRYdlH4IZzoqwCJ6pBZbi/3biPEoR7PiqceOVauom11KC0tH0xJuj9kSYLy4JSXi4po1R9o9ukHXft5Kw5PehstW4FV7tkjnB+XjN1DO0WJ8CCdpCUkY3wh/x8fc/XwwZRK15+C/dg8NJa+uaK5Gjs4n7AxD5qB0toCkvb/2qONunnvHxu98pblD6ouOc5F4ytHJ9qxp9VJaut3/U35JvMv9jthl+Sqik8QBkURbl0WioghErTg1SR6YgUlIvEgD2eLsVHHNgbNhvRcQTv6XkJUcHNeZHMCsrv64g8kxVCUCybSJbpoaMUJljUNUVxWnlDsHGMK6nn9p3fqmBzYTmxKZNSvexXMDBWt4Jx3x+yzlw9dcs0pVvDwDM0I6m1eajv9+15mZVF+lIiDe6LyZZMZKb6j/3dJoi6nGczusZBItnV5ty0KO1pqn+/0B3OFCNwXMXD54udSaPA/bMp46EnszvCy0SBOoj8WwQjiAlBY63KTIhefSrHlSc0Dx2eVgDy7r7bLKyMGxywWGT+xx14yIK2A6/87iSmlKKwYYDSk3KdV/ke2zgbz5+c50ota0sQoYkejOvhNWG/zXhBZXAl56ojGuMx2uEAY9j1azAqLLBKpmQBF2u5jOuDOhD2mwCP9InCzSBWPFMrKbOMkp+n4pEmSe3LFxbncIdX+A2HNmQOQ75oZssiE/r4qKXBzBvK/+RbqQxUYxYwZqII5gWAOAPBanaJz3qFcMWzDalXnrvSE4kdNg/J3hL0JC2nwmp2PIqHZGUAj0UmlE+lBLJwG9AheUqxRHL25lqkxzYzjuGIMcsYJUiC3QHivHC8IDbm0ea9N6WBgayOY66zkCVfRITiTDleQ7GSI37NJ0oof4oUeiZgzC+5PzwfCqAZ0D3FQXwhBBmAUYHv1Fvm2wup5VQUVGjwsSYaY
 5ccBd+WM
 84vTSx6N5rFhCvL6uLtFwlU1ClLG7RjJ2haQoIj58dpGURSrjJZ/Ek4dGoYL0nHpOBJblR1LwUwe0FaeKpgnleOusjQTX5d0jwZwyuLPlhZ7BDc/TdvPmkQwiisNf6uX0++Mlg7yFb6Ii3S0e7E21i7wb2ft50UJA668U9LHWlP6mG90qoP5cfkEhUlzwZcPSNjqWhJ7oEgyXJdssGJspa1mM+EHG9fLSRYy0kMNEPSCbaxpUf4MDRK6NpTNnaullKPW9jUhs1pOsG9LUxo5h+biw7ymQ+nc1TLEsLHcfgUQZAVATFTFg2h6SHJytj0oz1OYIAecp52NQLtY4MXrZWKEhcdVsshi6Zr6Bwovr89ZkpvsPQmluh6MMT29IrRL0kH7VnpU048DhfYGD0xkHaKBAI43h+1uMthkf0pc6bPhhO50kB8MCItr+z0l+8xP0T3GfutOchTFMiJfk2nAkIXgLVGCt09a02giEqUYVcUlJS1bIGzQdzstlUBernqDlz3tMlAeTsEQwbgcN/gKsXe53pfkLnMvtHr6Pjly1E87SmLzQL4RYits+esj0tVmI0R6ehnJgenlOLx+N1dZtFwg9dJZjAtcaKn2suSgUxID2iiaNNX71oxUfjrYyacIQzkwRDxytGHhKGwZKASI1OhCmJ7KsnLKrB3vT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

this_cpu_ptr(&memcg_stock) is always modified under
local_lock(&memcg_stock.lock).

Unlike is_memcg_drain_needed() under RCU, consume_stock(),
drain_stock(), and refill_stock() do not need READ_ONCE().

Especially, in refill_stock(), READ_ONCE() is used twice for
stock->cached[i], which forces the compiler to emit two volatile
loads from stock->cached[i].

Let's remove the unnecessary READ_ONCE() and eliminate the
redundant loads in refill_stock():

Before:

  cached = READ_ONCE(stock->cached[i]);
   4c 8b 80 88 d7 bd 84 	movq	-0x7b422878(%rax), %r8
  if (memcg == READ_ONCE(stock->cached[i])) {
   48 3b 98 88 d7 bd 84 	cmpq	-0x7b422878(%rax), %rbx
   0f 84 86 01 00 00    	je	0xffffffff817d01e0 <refill_stock+0x210>

After:

  cached = stock->cached[i];
   4c 8b 88 88 d7 bd 84 	movq	-0x7b422878(%rax), %r9
  if (memcg == stock->cached[i]) {
   4c 39 cb             	cmpq	%r9, %rbx
   0f 84 7a 01 00 00    	je	0xffffffff817d01d0 <refill_stock+0x200>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..c268a7864547 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2135,10 +2135,10 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	stock = this_cpu_ptr(&memcg_stock);
 
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
+		if (memcg != stock->cached[i])
 			continue;
 
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
+		stock_pages = stock->nr_pages[i];
 		if (stock_pages >= nr_pages) {
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
@@ -2168,13 +2168,13 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_stock(struct memcg_stock_pcp *stock, int i)
 {
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
+	struct mem_cgroup *old = stock->cached[i];
 	uint8_t stock_pages;
 
 	if (!old)
 		return;
 
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
+	stock_pages = stock->nr_pages[i];
 	if (stock_pages) {
 		memcg_uncharge(old, stock_pages);
 		WRITE_ONCE(stock->nr_pages[i], 0);
@@ -2254,11 +2254,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	stock = this_cpu_ptr(&memcg_stock);
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
+		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+		if (memcg == stock->cached[i]) {
+			stock_pages = stock->nr_pages[i] + nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (stock_pages > MEMCG_CHARGE_BATCH)
 				drain_stock(stock, i);
-- 
2.56.0.212.g129ede20d9-goog


