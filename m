Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FACCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757518E00A6; Thu,  9 Oct 2025 17:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692FE8E0002; Thu,  9 Oct 2025 17:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582F08E00A6; Thu,  9 Oct 2025 17:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8948E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:20:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE3A013C131
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:53 +0000 (UTC)
X-FDA: 83979845586.05.E43332C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 211E4A0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PZ2h/KzW";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+J0stjj98pfR4GPmJkP8P6oZZKtxPV2VX8+bV2U7jA=;
	b=gkvaCSGok0lL0RXbKwAbbhmdlPuAdTeFW0Fl+LVCHsew86mKizCsQBLHUq8gAiT90kGVTn
	PjaKHkwYsCP23xBBAKHlScqiXUc4nymNlEb314BeEdhPijlDblbEfgISO4qcY8SMwnnZrb
	N2XyTnguukecSWlZVzfunFcuig/s0PA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PZ2h/KzW";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044852; a=rsa-sha256;
	cv=none;
	b=tiwfWuSIvDp3SCCU9NGPiWgMHKUxw/iG1tuSRB8QTX5hviv2MEbhTzLeeT7sJbLJKEBLut
	je3JLM8GqrTY0NZS3wSLqJUEU4nRBhAuDn+rUkAAK1QXFvMqiIWfY6aPVM45DweKVR7yIo
	axRULoOA0FCPuLS/ifYML4VixFpNFCo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 928C76242A;
	Thu,  9 Oct 2025 21:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DA5C4CEF5;
	Thu,  9 Oct 2025 21:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044851;
	bh=MELVaEdB76EUyKbmw0NbQ1QbyTF6YUPeLThLKL8ekdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZ2h/KzWkitVsziIxgaErvpPM9viuTpu0shAGsztfn/w1g7LyXyWlYKhhdz5QPSa7
	 qORE1jFoMNu7CtMBFlwtcu7CzXU4nc4FCaFs2xUBnclVOpdOb8AeIwe2mgJgPX7mha
	 197naWxHrdYB1uxa7Lr9cPe0bIUluaWJK0jU3rf+nHrwpUy/6SNlExHp1l6eiDwXQl
	 Ujo30TV9LJPaaQ50xinRxP8TXoReG7+YYOrkXHcBZ8LuAdLGn2BvQdX0Tg4pGDvw+j
	 43W2tj0aAnNgMFp/Pqjc/nPdKoAAU9i78kGGVNzwIHUvI6bANiF5RSBLmd0WyR3IIO
	 WMRnrlpDXHdGw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/10] mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Thu,  9 Oct 2025 14:20:35 -0700
Message-Id: <20251009212042.60084-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 211E4A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mq6gty5g7ay95sd8xkn5du8qci4bp4rz
X-HE-Tag: 1760044851-920364
X-HE-Meta: U2FsdGVkX18ToP3EuKBQa90rfyUYsJs/C2HZqroUAmDvUTRovmITD+rlRfNkivf4kEyTrDnh3vUruzTyJ48APqiSfc6lS8U7CkUUb8eQzqS3Ln/DcdXtKym1JuJXqQpLYCE1gxP5JB/4Yz90EzyetwaQWtTQM8XSgBdu1+MYJu+aVp2mdgkLObOb/9zB+LAIsq5eF1dKotKDxk5uaD/FzDlxzrHZPdhEhfadetGjW9B4gZhq1ZLgV/SHoeRVWLtp0ZLe6c4R2El1svbewnpXZwyipPhEkNw2yVR0fUMsUnLR6zxD9Qd49X8TlDk3EN8FPxSeUMLuBMJvu9IAtJ9Sgg4kbaql0uEn62kcfVI9iQPAIrtX6a8xyraUNFBOjf9vxgLh9BITCVdA5EmIsbWU431WIQUU+WKutkRkZ6GhpcQ92P9LPKRPjW+Nu88l/04JzmgDcx3kV/BgcVzSuLomOUUVkdr1X3IdUE4e4NOU3Rvy+mGvpu3pNQg3DNZnfLK0JuyhelzK4fPiK7HTBXw47tZBmuwMbiG++zmQsade2MmNdLkaZ9tMQu7pnGXcYXoGrtJ0My145wS02BSH4l56LCOSZ1Eu0kZg2DLt7SHP9iAy0fb7MdLgXLMAPSRzMdJJEu5I1TXHu1itfPiaoRtLjdR/jrx5w42oK/1PAQZWNedlqEKpazKd10e8sBT18ilWpMhM3VReUOeJZRA14Q9NLsXoVl3Z9gncD8S3yO0/6AngKM4h0QkRtwsv2TVfGco2b2QKZleTLvE4GpMDWxB9qOUgtPOalrsK7kOkh3rpanvdcwo1FGzzzHLXReq5gsZsYX8pZOts/scCwCPbqRABNxx6F+SRawunlH0Wzl+6NvG1kWXx+60qK/sP1o6i1LJ6S4AABdxEgBiJX35VufPRulsxh/rYkBmHRnlsXcW4MBaaZub4gUu/quK8uOIo5QwzCIKE2qcBco7cbTZHUgO
 sHcouzui
 99/3DeIPsXyK1apn8qeoZ5r/xcgA+UfAKXX5z/qELrQoKnYx7Fx7BzVofvrJHfUeM+Myh8xXkrrsv1P0qGj/Cvx2Zs08BZGlrpCxeJ2+K5z0ghADeI6j/SKWqAED8JmbIIQUBqEoPD5HtCxUiSJ9jILOGzIyO/sM6tLdSLRv1Z4Nc5USOm8yv3UpHlLl8gEpGozB9z8Lj+KlYt4B9nAo6MzLrRt6JpIxljoWkHMgKTX/qgUYKb0u3SgcV3nNqwieJWBYFJXTYgT+iaopwRy9Qb5ca4jCdPgQbKnL/dyQeGFEEFDF/i7dTG7R6EPaYR/8owbjUAElLvtVq1k1cLo2+1q3wVuAzKrTH92xK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the handling of the new DAMOS quota goal metric for per-memcg
per-node memory usage, namely DAMOS_QUOTA_NODE_MEMCG_USED_BP.  The
metric value is calculated as the sum of active/inactive anon/file pages
of the given cgroup for a given NUMA node.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 93848b4c6944..1eacf78aa358 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -10,6 +10,7 @@
 #include <linux/damon.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/psi.h>
 #include <linux/slab.h>
@@ -2032,12 +2033,46 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 		numerator = i.freeram;
 	return numerator * 10000 / i.totalram;
 }
+
+static unsigned long damos_get_node_memcg_used_bp(
+		struct damos_quota_goal *goal)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+	unsigned long used_pages;
+	struct sysinfo i;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(goal->memcg_id);
+	rcu_read_unlock();
+	if (!memcg) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 0;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 10000;
+	}
+	mem_cgroup_flush_stats(memcg);
+	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
+	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
+	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
+	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
+
+	si_meminfo_node(&i, goal->nid);
+	return used_pages * 10000 / i.totalram;
+}
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
 		struct damos_quota_goal *goal)
 {
 	return 0;
 }
+
+static unsigned long damos_get_node_memcg_used_bp(
+		struct damos_quota_goal *goal)
+{
+	return 0;
+}
 #endif
 
 
@@ -2058,6 +2093,9 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		goal->current_value = damos_get_node_mem_bp(goal);
 		break;
+	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		goal->current_value = damos_get_node_memcg_used_bp(goal);
+		break;
 	default:
 		break;
 	}
-- 
2.39.5

