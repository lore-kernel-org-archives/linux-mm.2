Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7305C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71EC26B0088; Fri, 28 Aug 2026 07:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF936B008A; Fri, 28 Aug 2026 07:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE7E6B008C; Fri, 28 Aug 2026 07:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 393766B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:09:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3EA4A3C0A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:09:52 +0000 (UTC)
X-FDA: 85150408224.03.71535CB
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E93BC0009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:09:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RdniU1/D";
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787915391;
	b=Y5ruoN7SzceftrMZBp0fQFVlG2rNfMCkQYIoQmkJstS2NppRLWDN5PDZ67Hye8aJ7b/EIK
	3LMC2/py9HQL2rQQXWImEcDKJ0V2IHhk0dupvRGSisdBuaeqn86zW9x0Gv20GA6jgFy6ZN
	5z4I0C6eSX7fUShhrseTsiV6XSpEL/c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RdniU1/D";
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787915391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oydDuKh0otg5pEbKAftRi+l/Yz+usCBDeY+4MJ87tE=;
	b=bS02h9x9aba/BTXe6UbiJrvKtODVL2x0uX0HY85damSUiJm9tbbwAI3OCXlhyrdx+Wm/O/
	9Jfj9uyKo2A3NGe+PQgSqedoRWWBd+waC4CuDD3WkPQ1ILXoUGVMbFfhY1csFfmKbUz4Ht
	b0/k12u6Ok97YuCGmp4c68ZPIQj3Ap0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OoHGgjSfWYpB05+fSb88E0ID0/HP1IBQpVIbX01UjGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787915388; v=1; x=1788520188;
 b=RdniU1/DbmPn0VtQ3oCjn/aSXaa7PAma4T34fwwGoPs1wOs9/MxtRHlPwLGmp3p7HTMZXCTB
 dZULfLBRB0RxyIlVbkElGGqIghNQtBlA0tLz/nSxP73dpOULj/+LTh7zOtWmcdbG1nm08/VATDj
 NeAv7aqxRVWu6e8lf73YbtNY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e93b957396df94b6;
	Fri, 28 Aug 2026 11:09:48 +0000
X-Mizu-Trace-ID: e93b957396df94b6
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/page_counter: avoid integer overflow in effective_protection()
Date: Fri, 28 Aug 2026 19:09:18 +0800
Message-Id: <20260828110919.1324028-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828110919.1324028-1-ridong.chen@linux.dev>
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9nxgz6e91t64tqygwaz3y6eowqan1wrg
X-Rspamd-Queue-Id: 7E93BC0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1787915390-814277
X-HE-Meta: U2FsdGVkX1/l0mftjD64IHLBI47IfBk9rBF+2wom3bUV0Kiv6dRLxdmMkTH3++BlD5Jn2aAWzuK3f06tBPkHAXVVR5ekzpGGVqaq97iwGshPcrpMGIQReVvFnUjKQu+xnS7mMKQCapTVFJ4TshnMkG/2OH+FmW+hnyt0gaVQLg5WoyUg2E5wN0AXMOF89scEZYjJ1MplWJCPY3hII2cAdi7HO1S5aSimHfX4HjRLlOd+hxL4c6yaH3r59Huzl+8misVHDxBzy8FoD20g40tjeQJgjy8IDXLgyuDrinIib0rZx0EBkMgybo6Ar7m8AhLklk75/vMjvPm/xFd7tmAQde9HkB1Ay0mXp9F1Wd/Qxq/BvNyZkE1IHUMvmyKwYfu1jFrkAFGpC4pOwn8kxGEH9h0eJDvDwLB/XjeCwx6JVKwrv4xHAXMSnew1UzhgAsdmiUPolsowgN9QWmoUSp7qC4kNwI8UfBH1rb9hwSgFldVo14ryxI1Y+AF4AvQYoUlPY3JFB0SCwT3S+b25pluzCbdKPhlqI6l6A9TeuHK6XWs160ZaMsjdofRsz4Vpf6yPP3v5FjO1xK/X3sL+GX3TwbJWqArx71g1fimD4bjfu4h3NWh+UKBywFsbChfOSpbhy73kH1jU1vUvZGu2r4vuALr2TVKtMgWIw9CE1kAYCYmS4s1/WmQl7krJP8Hf+Pg78MPIFrFMLW1bhpPOL7nCYPZjpwwUpq2IP0H1AYwSgkX59bv4Ljdf0B6l3u7bsCOslwsmeHbs+ym6LJULqHNT93v/jzJAuYyfHtvi4w9zQsXsWjakSrFOmwYO91EaO29rVBV0WKSqlMrJIe3Vk6go2gD3XORdyMyLN97X5meMJqGqJTrZOgX57e6iaoN4Hkp/EsC/XgOMRWffc4ybXi8LLX0c4ivfLRLBsgamv7Czdz1nRVINxgFx2repW79M6CFaOJAmuvVGPaf/rcFQEDp
 WWybR73v
 nAwHhWGcEPx0N/9noeztAZUdU1Jpbclak8C3w8OERv95+2AeRBV/3BRKOypS+o2FZZJt8M+FPhP0KxwuD1RQZUvHLqbIBxOlp0I+DXCS5VZKt2I9DH17lzyY0Q+5ZuQKNMmXBAxaSaokNjVO+yt6kVckGKIZ10/Z7YzvFA06Y2NqyTs/Xs3KlLymhQRLkNysCRLAZXcVeprMO3/TK0pEzj2HqxPgqrEYZMGL/GQ1nht6ElkW69K9egX8l65u0/H0a2l2lcVt664uSkEdveoCw5Rjh/nVZQCj+jpKWD3yNm76wwJsPL9G3gtkK/eqZHh4y3yQLMqp2kifQ+L3SO8bWPZ7U4wqrQD/JGQ14Gj/jLE9JN/1AWa8+7z88onmfzrNTo/1Fvs4Xb/QjXLUp/UcZ0NmHainquvKD65yuLSu9uzZb/KbSSpCHLIXtg62abK6otUJM7eexSczpZNwgR1Yp9AhWTZCssEUdGVkngzTLrLEVjFfmdqIljzahDl7jPnOUJxK33R/A93PFtoL2tIM13gmR3H1IBdSI21lSL4X/KEnmFURJ4MmW5qKUsxaXc9jt6VJDxTbrNlA0PE2lEX+fdKtsHlbnHX4bHLx+8nfMamjQXTn/qnTKfH5lgeBrEMxpIDFQ+HRtL9dnXLaGUnH7I86tSgx6e3DNitVAR/0CrZt6CdrFI8rfB3WaVmp8VKJkecPJbUmkzyh6V5IJm4rZ1G3XJvEdgm0hsVfIo6aW8h5zVBGbXdqve4Gg9aVR4IpVeFQQcc96uUy3HNnzGdy8TVb+H+RDwsMijvkvCamGX1tjgw/FictgquulkDMj/ctzHgCRrWXDj9IYc7BEaDwoITJBTKxmA4puDXo3nW+U0/xUNzJAa9x2KF8OWZ593UBPHWJz8BKXY59B3LnceTH6bvrr9p+Z8YT3AF4p
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
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/page_counter.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..e8bd512069c5 100644
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
@@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
 	if (parent_effective > siblings_protected &&
 	    parent_usage > siblings_protected &&
 	    usage > protected) {
-		unsigned long unclaimed;
+		unsigned long unclaimed = parent_effective - siblings_protected;
+		unsigned long unprotected = usage - protected;
+		unsigned long parent_unprotected = parent_usage - siblings_protected;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		/*
+		 * The usages aren't read atomically, so a child can transiently
+		 * appear to use more than its parent, making the ratio exceed 1
+		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
+		 */
+		unprotected = min(unprotected, parent_unprotected);
 
-		ep += unclaimed;
+		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);
 	}
 
 	return ep;
-- 
2.34.1


