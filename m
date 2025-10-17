Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6F3CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640B88E0046; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555C78E001F; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8A68E003A; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B83018E003A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71D2BC0122
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:17 +0000 (UTC)
X-FDA: 84008892114.05.26628CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7F0E18000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ClO42DOb;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/CaHm9NrOp7VPwztgIJwyG5LZBFiFKMt2hxjYTl0Kk=;
	b=lmr5Ft6sXOUfBcvLUMEiQdSHEADl2DY6bppX1sSTqlqZDWhSaahaVnGeiydZ/m81Bxy/Z7
	1EE/LbZPFjCMa/aZqsOH+sN6LDDAYM4lowraCvodhA/t9Wn9ifOLibPCWl9KjCslPYFlsD
	JYaFzwaaBhAZVjUw3xAgCh08iXmrHUA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ClO42DOb;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736435; a=rsa-sha256;
	cv=none;
	b=STgkkVi4NDkfT9+rwg7LF3IfvVQlEptr4vK//dmTM0I9JEqIC21nHt1icrf7vJfPv1JR0M
	CBHklcYus8v1EgYgRfyuKA98ZMbhtqjrJwDDbCBmsg1uCstwP+vSy3pKwUbaj/RbV4AelD
	HZP1X01f0pxzBv4jeiWsZtNizyAO81M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDAEE4B3F9;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D79EC16AAE;
	Fri, 17 Oct 2025 21:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736434;
	bh=iAAhOa8iHX+RisUCri+NFUUzCjC4h64hfHQYSXDZ2Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClO42DObtIDHCkighHiBPIiqG1Y9t1yUD0ZftzL3bpXV0fu1iIq6O8AWBs0LzK/r+
	 ibat0Nu5ckvHV+7FS9MbJ7OnU68VGC2GH6TO9uxb449RPNahkSUZ+CB91jLH6VqpmV
	 TFmQ0MG/rUkj7H790bGAUrHG5BuhOHJA4ZIGLBQ3HM3i1ZeFbw2NcuIFzCTmIANMZ2
	 Gdhg7NTkL4Aadq9MuV6C7UMAjDhcQXv/4O+WZYjav9pvKpZ3aXYhzsyUHqxn67DJSZ
	 UgP+NHEAHV6vhiKd6EKMFwYedkzxiHJyH5u2xeEZggrqJXEgG9thQNcms1OVPJN4cZ
	 Yap3I7wPv4x1g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/10] mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP
Date: Fri, 17 Oct 2025 14:26:55 -0700
Message-ID: <20251017212706.183502-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: znjcg9fe5uwsx3w19sij87aku49yz4yi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7F0E18000C
X-HE-Tag: 1760736435-607447
X-HE-Meta: U2FsdGVkX18l9KAqyalZ1LHCN/SJej0FBlV+eA26b9Z4TgyCaZDCzJIcUr4OaZnNMm8B6CaObNryhmUkmfxVmlMjKbRFuV1cZuJFqS9lGuhPne3BDL68vN19mWBEbLpZuC41NKxc05s9YjiVrM8YvI6325mecF5HkRKqvjuAtoy83Z6xa6krB35dHYHDaQwuIJI4+3lAnSK0fSQkMIUeqXb0BHx6wiRSPfLNKk/VwXNExuD+QAhx47YEa7uk1xCbQarrGJU1r7QL+0J2BTAAqJy5N1s8L3nexanD9mNsyfzVYdi6fLl9sRMIdkD5WsKLdVcG3VC6bWBcs3hGSM1b7rHEpt96ZUYYFVBn7unoUKLgBrPmDAB1yatBcr6PcCje30GHQImSNoJl6N28G5KW9VRPYFJmcvsne2nvZuxojnX2YJXrWHUm9PGRj/cetHyF6kXo5PLBCn/3jF7zO8cwoUoa/UNIdYUWsaa1YHdMU5Cs7kCtzCax3B2PUSjrLmngqIC9VNtT2+QwOfOhav1TFZSDAWDlc2solrB6dT8nLnvzvvrstkvjJbnJ/fHoS7Khb6lk0HfZaXpfHgJ0TLfUZh9MYWI0iGI3kFju+lVaoHocNu+IE+nFQwF6mcaPJ7OjhntyW1E3OHisiOrllBLyNNi8UFE/v3rPTAfsDnbv8qecQkV2LDQhADJIN+QKUC5oCrQHLmVwRprFoY7wtB4prrl+BZkUixzJmA5agNoy1v4Fs2aXUckvaucxMCHNrWaWND9Dp/+IBrS7ihLoDOQ3V6JYLOOKaoMVl1Nbv2HPUq3cy3EkZa/wrpIfw8Z6/Vsd6cJvtAU+lhbxpyJCb2iCW9bOBh4RpuZgf5m4FPh6Mk6rslj0EV37oIQNDwcwtY4C2Fke0HNcippzhntWJYrCIP7wFiMOadvbtpAxMcjXtg0QcUE5fPB+VD1BBwU1kFGKhsDVhXvNTXwfwcygHun
 xEPCZ/1Q
 KwbHMWrQaUfIQz8YK1ex7bqRtfCfjreGdYAHhZCjYiDVAHbMVwHBJECYAXCUrEpExfQMHud5yG13SpxN/etQODhoNgHyev5CnRYzz8o+peHp17jnk6Qzw7s/n2PtW1ZgGKtO2AZoEMBKckiVxveALM+o91DHCu/nS5d7GptOc+umqlb8xfMJkDk977biqAwXFyEl627TUs4/wjcmMV5TQj5fjX/ioHQfoafg5/1of5kR2Fp90wyhfQVln3rkRl8WIktfVFcncgIOTvR//k+l22AZHdDbZBgtynMgVjQd0Zg9wIAL0MdY3aKkuHSeOIAk3uoF9LpYKYZ65W/JXTXfCfkOumzzJ2HU2rcnh
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
 mm/damon/core.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dbe48e43682b..00f1686d767f 100644
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
@@ -788,6 +789,10 @@ static void damos_commit_quota_goal_union(
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
 		break;
+	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+		dst->nid = src->nid;
+		dst->memcg_id = src->memcg_id;
+		break;
 	default:
 		break;
 	}
@@ -2035,12 +2040,46 @@ static __kernel_ulong_t damos_get_node_mem_bp(
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
 
 
@@ -2061,6 +2100,9 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
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
2.47.3

