Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75134CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 05:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDCA6B008C; Fri, 16 Oct 2026 01:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748316B0092; Fri, 16 Oct 2026 01:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F966B0095; Fri, 16 Oct 2026 01:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31A056B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:28:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6CD5402F6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:19 +0000 (UTC)
X-FDA: 85327358718.20.4CF5245
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id E334F100005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:28:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rgZD2F5S;
	spf=pass (imf14.hostedemail.com: domain of 38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792128497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ka7IOJqjFZQU0cr0Ja82jGg8FVBRQylVa+iOg0roN5c=;
	b=a4v1Euc5/DNI5EtBv91yNOXka+LiwV/fyGuZBMTf9Ps0lUeQmxGq/hQy1PFDzkYMUrcsCy
	OzRltwnDh26mBEExVSyLjsK+Iv4q463xLoS6ktM0GxDQhbVE9io+wCMNqQhcQFec1R0+H0
	XMy3uHVA4TZHvuLH3zqNYCcW3VYflyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792128497;
	b=ogdJvSThn2viSZbdX+KQy6WlWxSBKfRkG3lwkSTxmZqQd1fN3+PAgkFUN5uEJTamJWwXEY
	CZn9bUnn2a2YzTddekCZ0pA3UQ9adxLI0r4mEZbz/qjqD76XgfHqWL3DfcRlD/0HikCJWS
	Ii3AgmHMtrWec0goh495VErTDkEe5bI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rgZD2F5S;
	spf=pass (imf14.hostedemail.com: domain of 38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=38LXRagYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so4162041a91.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128497; x=1792733297; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ka7IOJqjFZQU0cr0Ja82jGg8FVBRQylVa+iOg0roN5c=;
        b=rgZD2F5SPaKW9j6f/3QqD18xNlsupORy09OKN79sXnvCmFf+k+gDDAIsXIpWhz5v4u
         IDXkNNudkz3HbpZwLGlGt50sKiI4kyk4OeiAcmc4OjporUpQsVC/PqdX47hBcOJiTkK7
         p++8vOYhh6rOxlhEJTBq43SRuZkeaqdrTJBizao6/GNImKGGGC6X3e/3jBG8b0xnM+Ph
         4BS6cdZvp1k8F/qfVMCnujv6amCZ215YQAAkNi0QuawKXZBftvFRuyAvOtqyPOIYYiZ0
         7C/pSQnwjLHGhSlPnFvU4dUqrUOUQQNZefdPqG5Wd7FnTOh/f9kpqWsqWMTLEFOPxxy1
         G/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128497; x=1792733297;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ka7IOJqjFZQU0cr0Ja82jGg8FVBRQylVa+iOg0roN5c=;
        b=MC0gfEgmFUoCG0M5m/m1Ng/AeP5k68ZJj/vmjn0c9zJ4aQ6MajHfq4efi91P0WO9Xm
         m2O0BWGafhCJsQwAljRFY2SLWjrRpGIRTgtCzwkMUiAf/P9NYYyYQgM0pEEhwBEMp6uP
         6Sn1csB7WGyf3jxzUAh85fnn2c0wZCKT/ueVXq3uKY47dxYcTGkax6smlY0JOFYGEG6p
         6rCo5aDfe+abhflvkkFCZg9tCY7phmm6MK7IYDH/CPW1KDkpF1S13zKw88BIvK210VW4
         mQepzFSpsBFUBoyIkolLHbn1YcJiHPNJpoZhz6gsgUKIafC8oURG422EVhp/vBtTjlbo
         QvsQ==
X-Forwarded-Encrypted: i=1; AKwUvByQftTLOwTcuaZtqpVt7t5tmJdY2XLi3C0mOhGP2zoi/X6ETDDzobFCv+JTJBfTsDNGkkPdxqQzZQ==@kvack.org
X-Gm-Message-State: AFq9FYKaS7Z1jsJVLjziIZE69Ls/DaS3GXeZh6hPeD5ZRd3LcikKMPLL
	GxB7e7Eiy0PAr+koX4Z9joz19xJoFudDOpJn/2ewQIWZY3av708BoabXn0QbNiMmWWHqRHF9BOO
	Fu1q0IQ==
X-Received: from pgbdk10.prod.google.com ([2002:a05:6a02:c8a:b0:cd6:688:c1d2])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c87:b0:3ab:d26b:c2d1
 with SMTP id 98e67ed59e1d1-3abd26bc3demr18378897a91.11.1792128496210; Thu, 15
 Oct 2026 22:28:16 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:46 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-3-kuniyu@google.com>
Subject: [PATCH 2/5] memcg: Reduce nesting in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E334F100005
X-Stat-Signature: snwg5oj39myhs94wd4a38iz754uz7tfw
X-HE-Tag: 1792128497-796131
X-HE-Meta: U2FsdGVkX1+rMwjBIKSxkpB7r0FY7Te71W5lvyhWSIv3XcL/g9Mkk4XhV0Rkw5k+xxYYbSBkCLx1JCiHvdm+EZKEyP52tOkr8SZJDeetwR5d0sR8mHSGp+OXPN3O8gKepIuEGfwInLeeY7NNT8yfgN3EVg9qt9AcY/VsCVUt9yJyGbGEML4rgSdG9hyy8LonWpkRcoRSXC37kWbkJ6uISPjce9S0gzrwGdY66NLZh19e4pxrZuKx2onw22qiJCgBpvVAc992t8IACf8LUl2j7WHM9Yj46PLbXB6o0Q2ozGAWrH1iFRBFTdBlAsaxIbWu7FDjI3CZMsLsuVSPZcnulxAyeHtyp+Rve/3SnePVAGR4tTNoXxorSR3r5vvsWuJ/fsQeXoRhpdd3mjYUBLVmNTrRiq9ywfWyvhHxaTo4Ugp61NU9C4XhZpVpjupQf/dGBXEtJfDWfmyZEBc4EkiIIURaGR6oc5zI5MArcUwhLEdLF6+9i5TpW1mJ0mXpmBGog6ecadNRuyBXtX8fpqo5lbu/WrUojKn7EKp8ENHhCEe2XsJyfIMKvYdoKy5DgDYh3ASTlM9Uml/0MDoXH9keX7+cpzKRWsFfjp4KOcHvYCcd3Zy2uPPHzBQ7tvKSMuP/8LIM0h36yFVKJZTRZyWAXwZrAKbIbkxBlTaaGmif/EzGu6cjzqmwSqrSYpssz+xilTUrYV6FEmm394ig4JTHTWUhZPgGfOqtn+nUW3opL/qSEAPTtWPMXi1zYtH0jYfad0IHSJhe1cNYsAiseM6Z9oIG815fvYiZfrGz52DiIpQxhtbLvuIcURKzjD2M5NJsMjPOktt4ABPdF7ftYsSQbwDmd2Zy3ex81ifxv9b4xFZ0t1m1rByJ/P4PQ/HDGPTJjkG6iPBF9T0cyEK0ndFf+GgQQL7wsfInuWOWDxwB2BHZiE9tGCtjRtZyBOjWf98OBvJbPrz07J5BcdFPjTJ
 MgEdzdDZ
 7AEaq9XfedB5FDbWMhooB3VECl/d8YigacJdxmjlJzNTYkYWo8XEl5fSu0iE0bXzq2NCBG2zyEPTzNz4RNFYaRZWdmTCnn1dYVfwgkjjGAgpe5HrD659E65LKZ2pZR6KNoyad7LTETIP+cx18EpUWSlcSw0LerBJs4yZdLLHG4z4DG1DUdbj4FjdzegP1DKlimGWdiO4fBHdDLd+47DcWeOvaclh3YPDYtVuTdqTMQHlmRmOfCkisPZXUNE9X9X7wpKuQ681ThabTZypU+Uzbs97zVSQ08BrvTku0iTmRE7X5M1LHPRkZIatBsF+Slx07o1u3FMv+L2hxhhDoSSQ61bg+A4vPQZ1C70EQtO7T+cqlsPGZVo+AM1NpNktcI6kQl8xsBhlTmu/9zIQ5nMU/915o9ymlWRsQJAITfNlWZjP+Pz4/7X2jp+p84oyflumPHdpQmRPjV7kVBS7wP4W1qCAeasyjM4oVW3qQBrbe6KfmrX/DzJ+GCtOGh54hOCwA0nvLdqi47IIMrm+nOXn2bb9AEj06ONMm5Vvlhqz0aizjOhPd5f5UEgZq0IzZoWu2sqbtg/ndG2Sy1nXC7N6EXsuFIz5t8cLYDqTz3kFJC/jgcc80FtBdoQjdgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch adds more code to the most nested block in
consume_stock() and refill_stock().

Let's reduce the nesting to make the later change cleaner.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 59 ++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c268a7864547..7c722a593cb5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2139,15 +2139,17 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				css_put(&memcg->css);
-				WRITE_ONCE(stock->cached[i], NULL);
-			}
-			ret = true;
+		if (stock_pages < nr_pages)
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (!stock_pages) {
+			css_put(&memcg->css);
+			WRITE_ONCE(stock->cached[i], NULL);
 		}
+
+		ret = true;
 		break;
 	}
 
@@ -2229,7 +2231,6 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	uint8_t stock_pages;
-	bool success = false;
 	int empty_slot = -1;
 	int i;
 
@@ -2257,29 +2258,31 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == stock->cached[i]) {
-			stock_pages = stock->nr_pages[i] + nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
-			success = true;
-			break;
-		}
-	}
 
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
+		if (memcg != cached)
+			continue;
+
+		stock_pages = stock->nr_pages[i] + nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (stock_pages > MEMCG_CHARGE_BATCH)
 			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
+		local_unlock(&memcg_stock.lock);
+		return;
 	}
 
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_MEMCG_STOCK)
+			stock->drain_idx = 0;
+		drain_stock(stock, i);
+	}
+
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
 	local_unlock(&memcg_stock.lock);
 }
 
-- 
2.56.0.212.g129ede20d9-goog


