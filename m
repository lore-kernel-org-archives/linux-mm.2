Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA89D2F338
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C796B0005; Tue, 13 Jan 2026 10:27:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA3C6B0089; Tue, 13 Jan 2026 10:27:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8D26B008A; Tue, 13 Jan 2026 10:27:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9072D6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ECBA3B6C1E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
X-FDA: 84327319944.13.F085BD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5373480006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jVbA/nvA";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318051; a=rsa-sha256;
	cv=none;
	b=JyqQ0uBnyQY2/yJ3xY5oVrL5ildDFk+91xIvmmZ8seY/wLd8OU+DRsXstR29BL9wcBqAXP
	Gp1kLIq4NJV6SizVJr3ycopfFBc3DLnLuHQVS5rRR/xK7HOvBReATsTPBCEp5jQdgzOb+Z
	XUP/EaITiN8mhbbNtscB9EMxHRqgS9M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jVbA/nvA";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7xvhn2TPlz5VWFMiFxwpIUDtbjJdgo0JV7hKaMWraU=;
	b=Wz/v3RfHwuWDQCtIHrL1d4PapiaXViTUf56I/d7jc/BXFor4qfKaXWe+dtRvoeerESf+Ez
	Wjh3VcYVuwNhPqEcE/ewcsq3d7SYjS/MuI8TEXlnaNSG70NgRSMLL8wdlr3Fyuc0T4V+pn
	jTXIgypkr5+uxvZNBunF729SxyWK9WQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CF84F6001D;
	Tue, 13 Jan 2026 15:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689D4C19421;
	Tue, 13 Jan 2026 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318050;
	bh=7NAyhkfQbcxTPtt6Wuep4buJLBzXp37MO61JEyiUHsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVbA/nvADP0cj5hfiuCwC6TlLON6/t/yO31DIlKvYC1iFdH9LbvsxLk0sjAUDvqDG
	 voTJWWNodHb86PVFPoavd1lCpIB0J7IMmdcHEsfShFogBolKJ1i8AbX8MAvxsJsgmI
	 3n6qC6Uhn5NllSe4LEWSJwdnlIsUiFGpyiTFOUsGnSDF/GpJUYMt5ZfyCW5p6ACa4s
	 jBz7BYffQ4d7O4qC5bKvKEV8fey4j/onYserdl1kxQNlzAWwrfRH5h0HW6Ru6CEWhd
	 hDLhNkwwuqd0e2rRonjmvZ4ACNbFK9rM+2nVRxadDRz5s55s3dAyMIrsaYYthhtK3L
	 nePNsyWQz9rww==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/11] mm/damon/core: introduce [in]active memory ratio damos quota goal metric
Date: Tue, 13 Jan 2026 07:27:06 -0800
Message-ID: <20260113152717.70459-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: urzfqt94gukfyxgn45xf7sy89ea5fp7d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5373480006
X-Rspam-User: 
X-HE-Tag: 1768318051-726497
X-HE-Meta: U2FsdGVkX18UpoXx/TKQST4kreHUmz4xcwQrY10qQg3Sq+c4avUQHUL25omUbTYpaPC68ocorrDmFCwCqKYA1lUR0Y2ox6Z7iDT8osz4PeBQge0AdGgTvG6tBQlDR3+oelvQaFdtMAKbkWhXs2AvqmGwBj5eJ15MAfnNHgmmLu9AXLkuTGQfIOHjvMn0UCxBDWulbe3PiYhZ7s9YSNrscmdFjkGjW2rmK1OemV/OPN94AB4G0MgPsSa+SRmKbvPlhLwVoiC8Io6RUmRSo867HDI6HaoQBuVsct+XlPySzD4TPZpXhJQ6jZEkqyzXcvTLZB29lBJhz8f0OgSZXiHV1Ag6uEr10JuAUvU85BrbY0eYyuZi+t1/uvPfVvPFtYwAxctY7fUfURPf5hfphvUswTJ5sfJwU1Yfh1rDTW7NjOeeTfJWW2jWeswLCPMe1HdKMTENMMHtm0xQtQrZPn7JexZMMBz8WI9kESnwoeEK3QgnCfjKceNbgVJCeE+4i14nF0Z9pEzkIVK2rc5Mz5f68YytY6kXFWloc9L0vZj0+KcWiIwy0WcXeBx7ZL6dya6P/szsf0dq39vrc8oLxIMs3+hSvWyKwexsr0waci42WOx1gRbtMVUCvFPJIfKGShTrPopjHshbhNi9a/AmVA+qD6znRmTS6yIu9B+gnacQGSITAYLzoEog1rxtaXzppKqLADcbQZZfpQCG9slyrCEV083MLplGfQZVyDKuA+SCEujQ8IJ4rZUTXhURq80Cbns9Ms4Tr09WGFqHMWapy3tN7dAYKQhDfY0tU4d8/hUHVjDjSjH2M50y9ekjm8P+a1hSoLAyFsh+S+Z5UIilDFbQQAVVFqTTYv8WzrJJ2jyENqsUT9La2JVAF7eD6et9VH4n6jcoTSXeQXzgWcKXXc9M6zjJUtW7TDlVwI3CSOOWJIds9SGYheN4s5J3oVlk0v1bv/CGFNCm40ngi/PIGCK
 dK0ZYNaO
 lZBr0OEfOeuyci3pDWb74pTYdGBZIDqCofolzg5HybyJJnoozhimk6vi5eRdBLr6oo7WOdA4qHrgEzy/Un6qF6eT1a70kuykoHKEyfq5cCLiLqjoqhTvHObGKkSNboykTq+Q766XW5vFOPiRC1go8K/0ayQ+Kq2LXlLnyJjHLhE1lEBZRf5YfZo1YIXu1R3Qo04pvy3S0NTPwcEw8uw4ZLnDaxRPw8VgTSX/1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS_LRU_[DE]PRIO are DAMOS actions for making balance of active and
inactive memory size.  There is no appropriate DAMOS quota auto-tuning
target metric for the use case.  Add two new DAMOS quota goal metrics
for the purpose, namely DAMOS_QUOTA_[IN]ACTIVE_MEM_BP.  Those will
represent the ratio of [in]active memory to total (inactive + active)
memory.  Hence, users will be able to ask DAMON to, for example, "find
hot and cold memory, and move pages of those to active and inactive LRU
lists, adjusting the hot/cold thresholds aiming 50:50 active:inactive
memory ratio."

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  4 ++++
 mm/damon/core.c       | 22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 650e7ecfa32b..26fb8e90dff6 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -155,6 +155,8 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_ACTIVE_MEM_BP:		Active to total LRU memory ratio.
+ * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -166,6 +168,8 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+	DAMOS_QUOTA_ACTIVE_MEM_BP,
+	DAMOS_QUOTA_INACTIVE_MEM_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index abda850c28c0..d2ed75e521bd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2132,6 +2132,23 @@ static unsigned long damos_get_node_memcg_used_bp(
 }
 #endif
 
+/*
+ * Returns LRU-active or inactive memory to total LRU memory size ratio.
+ */
+static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
+{
+	unsigned long active, inactive, total;
+
+	/* This should align with /proc/meminfo output */
+	active = global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_ANON) +
+		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
+	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
+		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
+	total = active + inactive;
+	if (active_ratio)
+		return active * 10000 / total;
+	return inactive * 10000 / total;
+}
 
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 {
@@ -2154,6 +2171,11 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
+	case DAMOS_QUOTA_ACTIVE_MEM_BP:
+	case DAMOS_QUOTA_INACTIVE_MEM_BP:
+		goal->current_value = damos_get_in_active_mem_bp(
+				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

