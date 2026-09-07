Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80864C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3768B6B009F; Sun,  6 Sep 2026 22:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CFC6B00A3; Sun,  6 Sep 2026 22:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2038E6B00A1; Sun,  6 Sep 2026 22:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED88B6B00A0
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:55:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66DB012064A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:25 +0000 (UTC)
X-FDA: 85185450210.26.F3AAFE8
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67D1EA0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uZZiQlT+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788749723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ofdXXvMHfMCj/KcpZ8XsU3v/quzKGU2UDn6FslWE+Nw=;
	b=UpJSAlibrECbbumLflJ1KFdy916BewrQyuyEv64FgIRK/oqjPu8idTwbfxv1axO1wuSJhv
	4HNznckOk07DTWFkQA6Jc8S1/+yxF6hXlsdsYMUTkRdPx7aw9it1oiJm6Id9+g0B6SC4ZF
	/tmFS2GUAJtP/OGHNbk+pQezps4oZXM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788749723;
	b=OOy4u0q1roJ++kOkYQCGq6lxDbp/WwxGYI4RRz6kNU4ztKhopaKsVMCw0DYf6HIW3FP+Os
	SBVvqoXC+lFN6s7ZJfQ1EQYWAyNjTdDuL7BGLzHXislZ0xqfCGhKY0zaG5BjZAf5CrTTCG
	D6WRIOA1fWDA1xb9wHro8U27kgw80vE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uZZiQlT+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MCtc53OvC78dPVDjleIyZtuN4ZTyv8ZI6/y02lp/l+A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788749722; v=1; x=1789354522;
 b=uZZiQlT+PEkOYqWyEgxkbAAO/FhvqxqZ9kFMc8T0hqET5nCFArsI8gB8mnijRKcz3HbQIVPe
 mRRyFUZnI6N3R6IGcjfjOC2Zl0vNyVD3SnjbgGkRLFAugmNJp/6SWbQmR7/49IxIPX9WrqyxxIE
 JFyU4T5qBohGutVP6IV2hx6w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cb267324da5e0b08;
	Mon, 07 Sep 2026 02:55:08 +0000
X-Mizu-Trace-ID: cb267324da5e0b08
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] mm/page_counter: avoid integer overflow in effective_protection()
Date: Mon,  7 Sep 2026 10:54:44 +0800
Message-Id: <20260907025445.1836238-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907025445.1836238-1-ridong.chen@linux.dev>
References: <20260907025445.1836238-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67D1EA0006
X-Stat-Signature: n9a8mrxzp5z7pauiiydxwkp8xas1x6ak
X-Rspam-User: 
X-HE-Tag: 1788749723-927421
X-HE-Meta: U2FsdGVkX1/ZwmUyo+RkYu/fitxck8BbAVEf2mhu2+2xw8JXa5RTFTeRRmnm6qPf1OngTEdVzIVJSvzNKdC6ly80UOtg94K6i2Q4cU/dN/2aDSjTRroQr0gjW1aKAeYZ6imNgHaG69V9vWQbQi4hsdUASAHZ0Q9eSsYqCcwWB8ZGG6c4WQzhkw8KpMO7mvkGzk6FxedTJLxwCjKqGi5y/c7N07Nqf+/XWdVMZDoSAE9svGA5eAVYQoWWaqHxfX8RZCvz4eQdKq+JOoaXhxUH7+GSiBG9EHm40S56b2RmVZmWziGdq6g3+2NRuM1a6sy0GA/GXGP5pQ169PMjSuU29vHiXmfQJSZMjkMunA+VlsbB2V3uMRPW8VY8wqa2/jl2YFTdIbjHhQWRgAfNwvrfuuRSYvR8hqUZoX3o4pb3u0kQu8e32XHSTKuK2a9OCCl2abMO8AxIRJz5J7TN3vX3AWmRYtSbc7Au8QUFPgdPiYZfFjMk6jGsUispjB0RvAfY+zCtSyyEn+KQP97ZRiPdweBJ79yo0ITE78mzuaMIvzps+gITpiVgIcr0CgWcE7fTdciFKyQUlrLLEKOJhjChqhsYsnd1phgE1whxFE2Q9b1CZkrNyWjJ91inuAOPoVr7biVcHtT2ConqFYKK/ZoGfJX8H3wMgZOdo+EbmDEDOuXJUR7Eagv1FoAAhk1IRu0HxLIqFQELfBq2lsfq5/0qayTO12YT+p3i9qeuLCuM5ypDLPxxrvNPEgXKzGi0qBbIslYksbkNE5WaFlqWXccFow2uZPYPx6kUWxib7pd5XMCDBdPHFkSo1VgzzvVjF5fbftJauUskzPECR9hdeMWeeAYnEBrgPFnmGx1Po3qK76CJO4Q2ZOeAE/Wm1EWJ6u0L/RwLz+D2DDZxdum7Wfus3Eo1oq2qNbIoCOQixYal5ifmrjp8U5/bjqQJclGultuNE213a/TVjEDXY3WmnCG
 AiIjkj2+
 KrjUBsqONVIHdyTuisTJ6s2+nXsJo96zGPK+cPJ9a2rDMAy4J2a32oAOzLuzZ8HOU+86anrCNTFo46DlnFu5ITZJ3Ujsn/cRolcoEHuoC7s2N1I8zmp+TePpPF44YUeS/7tJnThi/IvUMVAEqG1PRHhUkmzM6YYE7jpVdIwYFZL3HbS25MMhpeGRiwn2AFZ0LySUNZ61b10CTd8rRCng6U08qusY8VElaVAIC2F6T2c8uyAPmoQWBLcUl8yqqfnwIa01TyexO2fd8FdP7NGbZdW6llTcJrw8XdliWLB9wG3ieqCJ6TKhzBl8U1ECau0cq2T5hEr04C7D1EcpizIw2dGloBKcH8KtZm4fyAELoL7PIXNhaJjJSy1RwEdMVS1AkBXMbRgHYyRWujsCHXDu8VE0ifalQebM70DB5G4Aa4+rB3blH54wf3doOcoV6X5HIBceozbsyXPJm2ZuU/SIh6MeH1IrsGLdH6s6wcLS1vyytMU5mppkSBMSiNFDIU/okEQU8iaKtlLVUq19i+8LGSzgf0shqSJQr/loHx+Ll10J0H6g08F3rnXVRxhuAuMwyPCLmdiBNoNlOtqHSSrOCo5BWmYQWM6ree+HPt3I28wO0vAHEUNj1rQ+PughTSDTwkWJ7iu3//f9AnYdcMbO1cDwJL7b2wREOADpBOmnIA8Pj36ekV9p7lEdbl6CT48OTKUQciko1rwlGjZSHFrjgk+oojiBR3EGSi7Dp4DFkfy1tZ0Nfc/YdCYTicXZOuxCngSQ8BWnhMwDbb0eNRbdnhJ4afPFZNTnS6BqEFe5M+T46JgFI68FyWPmz/IwxLnJwaAy/qtLOFkhG21CnjJEczRLiZe3kO9hjtViz2mKFYl3WosxKOka2SWdHCTzLtL4CDldLib/gb83pDIajOlqo5z/Aso/bMJpXZKRCmfAdixGHbVDS1kDQrXZHQsaDz8WJ5+PoSMInbL0oUK3LVPEQ9VO99Jof
 WmrJQlKv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

effective_protection() scales a parent's protection by a ratio of page
counts, e.g. for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

The multiply is done at unsigned long width before dividing. On systems
with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
protection value and silently breaking memory.min/low enforcement.

Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
usage and parent_usage are not read atomically (a child is charged
before its parent), usage - protected can briefly exceed the divisor,
making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
the ratio stays <= 1.

Reported by the sashiko review tool [1].

[1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1

Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/page_counter.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127a..ea0d1646cff85 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
 	 * otherwise get a smaller chunk than what they claimed.
 	 */
 	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
+		return mul_u64_u64_div_u64(protected, parent_effective,
+					   siblings_protected);
 
 	/*
 	 * Ok, utilized protection of all children is within what the
@@ -397,13 +399,20 @@ static unsigned long effective_protection(unsigned long usage,
 	if (parent_effective > siblings_protected &&
 	    parent_usage > siblings_protected &&
 	    usage > protected) {
-		unsigned long unclaimed;
+		unsigned long parent_unclaimed, parent_unprotected, unprotected;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		parent_unclaimed = parent_effective - siblings_protected;
+		parent_unprotected = parent_usage - siblings_protected;
 
-		ep += unclaimed;
+		/*
+		 * The usages aren't read atomically, so a child can transiently
+		 * appear to use more than its parent, making the ratio exceed 1
+		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
+		 */
+		unprotected = min(usage - protected, parent_unprotected);
+
+		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected,
+					  parent_unprotected);
 	}
 
 	return ep;
-- 
2.34.1


