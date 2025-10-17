Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CDDCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB058E003A; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A680E8E0012; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E8A8E003A; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB6FD8E005A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8CA71198B4
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:17 +0000 (UTC)
X-FDA: 84008892114.22.BCF1BA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26E2112000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m1sivf6R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYPVeZuWCzp+HwD9WQWv+LAOixFu3Wa8MNSPu6XQJ6s=;
	b=RfKVM2ntto0nn6cp9+9OWfUi55AalsxbFllZngLklc8Y+DUd1E32V83go9QlAtDgexQBiT
	61P5hoGq5Q5wYkdDhq18E7c67GUYgVpCf98c/MP5eip/MHLtU5nLeX3n2/l73+jsz4cuCg
	odurbzzy7NKyhzVyQ/e8SyDZQ1Dkbhg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736436; a=rsa-sha256;
	cv=none;
	b=EZeWoYaHwwN5W3SNMUQ2Aw2CLumGPnxEzMMyebPNneU/b5ZJlTx+RaeCN6GcdxiY8exu3z
	4LkKk5kdEAkR9p/ytG/Xp3oxEdtHplQ6SIXHekMnsQHNTBZDn0GNCzEUXU8HIU/XG/SGKz
	jRzNuNSZw7jKNjxxKKc/grvqII718rE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m1sivf6R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 959B6645CB;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309B6C4CEE7;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736435;
	bh=r1QRmbQ0ckNwsPpAqp/NhFI/Nrd0yqfQwVomPU13aMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1sivf6RmIIQvpCVclfSkMGi4RwQqfkkqwO/EvMqrM3e6n5P0vuBS65Lruodm8a+5
	 t1LNAPUE6FG8euuAYXE6vUvVNSbSuiGSFrW9WArIO4o3tkmf1J7534dVJmdoohiYcJ
	 LZcDqyHKiQurrcu5H1bhVpM0kqV8EtlQTPkaR1vH0HIqo2e1UVbjQL3D+5FT7tlnOY
	 XeHSY9ogCR6P0jmgyndjG86U+5F/HkdIuYHJDnWPaTFbsmoyjo/HxKMJXH3CkFRxwa
	 gaqrrtZgDC6JGqgx/bjdmpV6xSXN9cJjdShYRc10I7J1p2ggtGrm5/cHFsduYzNYB7
	 +WkS7PnxXomhg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/10] mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory
Date: Fri, 17 Oct 2025 14:26:58 -0700
Message-ID: <20251017212706.183502-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: jao5qmfmba3ycsyj9m57di5zzemxg163
X-Rspam-User: 
X-Rspamd-Queue-Id: 26E2112000A
X-HE-Tag: 1760736435-26138
X-HE-Meta: U2FsdGVkX19DvgfnR8m5lcyj/zvajdgKPSAywjWwdoq6icxriX9+JHiij65/oQrDBkgHQvZr1j7Rn8ZUHBXspetcoZG1XlHL9ItTQFMgaMvaXvHpFwATd+yrUdZebl/IdAFov7bzBOfH2lUC2skVM/FTM6xbumvEtnLnniwV8JuOrzXv14QodYZnDmYMlfKseTkvJzvYsEL6/mSz2xqf/4ysd9j617dIIfNoKgOT0dAYicf6XqeIxN62OGj9tW5BgO7yu9wzTHMTLfFTeYZMnG74LERGPRkp5kkuFv2u64Os8EQ5lpwr+/iV7UpBdG/faJmASa/ErT9pzZGvqBTWBOsh7bZ7criNqW+OKks+TOxiNzMdbCTyYj/d6MlM42y/ph31nJ8Ya254trAHMb4lmHoJNsqkLPv2CaCQ1yxybkHyGQ3JshjGzHCHdoyMR1RTc6u37D/ymSFCaZ+fVhL+/c6RpUbKDmJdgJJJ5pxukllXlgkCa+7ycb7ImsA4KQizvXMYv5EuNTm7V5nctNYYC/QktTOWMtZT7vyC9OoBgXYG1swCHwFXj2XJW4WPmNI8SYROkCBp7rfcPt43TV6bfK9A9bNJIYly9W2bdSNl6uijbMY8xfGmd7zGx46K2M8xyZwYiw2hCka9zdzEN/a/++u75IFA70312tuWdFHbppzDOWp48Fes4Rgr7AV9/j1PHhmiht6BzzRFrf8zblnQJte9x29ijLZqDFC12kHaYjqHfm16HG3zu/kqtR9Q4U/2FnF1oz+Yb9XG/ld6qfQrYNLiCWrlNWcMqI42C5V1aPVbG62aSn3VlytiRJh8qh4k+9m2/KgqG07koFdDemBLaOeHDuXS1wIiHzIuQm/J+kdAjupdEeHpY1Hj3tsclvOWqhwchxWG4S+ylsPI72GxmkUj0QvmE5B4yTK75yq+4ciS6JIlu3/5aZQ8+fWk/jaiCNtpBi3dx8oox9tJh+H
 9bA+nG0Y
 Mo7E7/zJhhXdW6dGm+6aXpSoXamUhYvhcAdSeO4/3WDP9qrSm18jQgNeuUkqhI8uB/A7srKQkIrfTnjS8SW/tUQo/G3EM6QLrwxw8VhYLblsOvRcTQFPGN+c2XgzcgG3I64OHG4L/CVkI33qTc072YDSzq0Lu9oPwM9zqvVUxgIc+g/LM2erbPPYUl7D8V9N/nnnR7/c9tkZLgOyWvYyBx09bmJv1wa5ozGNOK50L0cXRLpHWsvD2FdP3VfopEUfdOcTOuXDiSXHwfPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a variant of DAMOS_QUOTA_NODE_MEMCG_USED_BP, for the free memory
portion.  The value of the metric is implemented as the entire memory of
the given NUMA node subtracted by the given cgroup's usage.  So from a
perspective, "unused" could be a better term than "free".  But arguably
it is not very clear what is better, so use the term "free".

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  6 ++++--
 mm/damon/core.c       | 10 ++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 862531f1a379..9ee026c2db53 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -148,6 +148,7 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_USED_BP:	MemUsed ratio of a node.
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -158,6 +159,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_USED_BP,
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
+	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -183,8 +185,8 @@ enum damos_quota_goal_metric {
  * If @metric is DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP, @nid represents the node
  * id of the target node to account the used/free memory.
  *
- * If @metric is DAMOS_QUOTA_NODE_MEMCG_USED_BP, @nid and @memcg_id represents
- * the node id and the cgroup to account the used memory for.
+ * If @metric is DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP, @nid and @memcg_id
+ * represents the node id and the cgroup to account the used memory for.
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 00f1686d767f..82546d138a5a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -790,6 +790,7 @@ static void damos_commit_quota_goal_union(
 		dst->nid = src->nid;
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
@@ -2046,7 +2047,7 @@ static unsigned long damos_get_node_memcg_used_bp(
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
-	unsigned long used_pages;
+	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
 	rcu_read_lock();
@@ -2066,7 +2067,11 @@ static unsigned long damos_get_node_memcg_used_bp(
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
 	si_meminfo_node(&i, goal->nid);
-	return used_pages * 10000 / i.totalram;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+		numerator = used_pages;
+	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+		numerator = i.totalram - used_pages;
+	return numerator * 10000 / i.totalram;
 }
 #else
 static __kernel_ulong_t damos_get_node_mem_bp(
@@ -2101,6 +2106,7 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 		goal->current_value = damos_get_node_mem_bp(goal);
 		break;
 	case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
+	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
 	default:
-- 
2.47.3

