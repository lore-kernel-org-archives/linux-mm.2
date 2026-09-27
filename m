Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9486DC9833E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 12:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FD846B008A; Sun, 27 Sep 2026 08:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9152B6B008C; Sun, 27 Sep 2026 08:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78DCE6B0092; Sun, 27 Sep 2026 08:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA556B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 08:05:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D489AC0A0D
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:48 +0000 (UTC)
X-FDA: 85259413176.02.FF89B1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B58EC000A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:05:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRNjgOxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790510747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCUk6L1aWaPzrTTzvJ81KlDjiL0II5tx/S//2fpxpwM=;
	b=amM3zSIPd/4jlNfFmbqobyyQ8DCgcZF1hNrpqnmVKLgH7UUSj+rv9JNVmsVrZKKeRF0rtk
	/5GcXodXxUIrzczJbel1L5XiCM8bPDP7hLa76VBPiGeCiX1iOXesWJHTtoccDsEr7e3HLb
	MSURf1CBHuU61k7kj+8nX4D7DXADK3s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YRNjgOxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790510747;
	b=RZ0nkn74LyCjjnMmVzUPmE2y/Ky5HV6twR21+5VIlXwSZ2ukrwmkzn5Uglj6KmcuadpvSP
	mNiC0PeWrnlcW9PNU/yW0+s4dKoEbNBaiz6IhRoxESPPUi+euNyEu9G+B/q2vvU4ebLtXS
	RIZ/jKXlaoDt1nI0IfzrdIGDQpunyfg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9559660D78;
	Sun, 27 Sep 2026 12:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EEA1F00893;
	Sun, 27 Sep 2026 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790510746;
	bh=nCUk6L1aWaPzrTTzvJ81KlDjiL0II5tx/S//2fpxpwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRNjgOxQDn+75I2Dx/utQk867cR4sElrSKVNMiaXhXFdaWAaOp/FF07qOkMaD+XZ5
	 tzZMdD9bQdFYEmlzZH6Ehz0SWHjKX56+/sKssQ+Bkru9BMY6k7Vq7OxdbcusmGp5nM
	 mx9KbeTW1JMLavmpD7C5/RcQ+SixC/LKVzfdwPVZde+XAwkDurisbaLI9BfGO/FQGE
	 oVQ4cE8r7/KDT6JPjb1043UKZCNPUsDBSPSIxt3Dgiok8ezaWyWFs9hwlOkSt6Nio6
	 c6QCyVI7XQW1/VITVaMDrq5OEE3OmCo//9y9Vm7emXsZxa7Zk5FCYP+q8JSlDpZoOG
	 nB4cWwF++W57w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 1/7] mm/damon/core: introduce damos_quota_goal->complement
Date: Sun, 27 Sep 2026 05:05:25 -0700
Message-ID: <20260927120533.50484-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927120533.50484-1-sj@kernel.org>
References: <20260927120533.50484-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3saq8mun4zr8aiws3c3ee6txp7sgoifh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B58EC000A
X-HE-Tag: 1790510747-200064
X-HE-Meta: U2FsdGVkX1+hsCLJTNi904mz4H6e9r2wZYd5TF/NZsiphKtHbo9DyDU30OepgbbVmxH6Z7/KadVzj0pVwp8LFZlTOUOYKbmuzF5RjA8C8eOCJTUP7n39048zB3oRwWi40bHO8njso7U7PUqnj4ynbg6WssCny7VaM9PxB3ojXSZck/C/yvN3jzcSOa5hAHhHcv1Jim6O8cLrIdBIfr09mWK1wPwpS1i6NjaIHI0wwzcdenCd8pcvLpv8XZpfukaCRG5ZzGi/oxgZ3fjVybjEi9CJNnnxP8ekzJgWGpvg58xax4vDbpiI+VtR89wk3H7Tv8okynAkx8uPUT7Lf8i+hJkeviV2xyC/+7ZHnv1cDZ3ybJnDq23ox5WmQv1W1PawBs5AgzCmntY4GnjmCoh0iSP1COUvbtAOOtY9ODpi2rTceGL8VSLORtVQtxHm7PFORIrlMJJfSdTP26Z+Zi2lNu9Z6y/ZuHSgTDY5lV+ENHt0AULooVyoxJndRSVZxN8LI4WxH4S8KANHz4o1dSHfwdxYuNcxew2RYUe1wLsOWHo6OKZ8lpKLzjOikXN+8ODOL18CBNpE24FHNfJkmlScWmfhuCDsgq22L1O4L+7bnChV8oKT4kAaqDn2veGyzOdh/jPhQA79jyfFXBYLzNrG9SyAj4RdMdPBW12AQYLQTBrB7jZReytCVZgoHjiR2IS8gvZm1VM9RFjCeOILtvBsDF/n6DtbcDQMADqdKm3BQG8wyE7DfqExRWbWg0Cgc5QinJHg4LhuK0Rv7+N1TImSOMZFjko/fJBQBrjFXU4/yPEez7eMfDM/m46EhLgcueqc9HLp5Kp3OkkAJqlL5jppKd1KRX+eNfLCbsbAQtJ3iKWWLX8vNaI6hIVLXMAI+eLwiPJYz9MWbnCz+Q/bzs1UXo6NxpXHAZ90IB1/Hv1B0KzJIvOHWnd2UIOh4+Iw34PhcDPv0qLTJMoaKxNtQ3V
 B/3kcvAn
 lq+1k9tPBYyHJCoBnR5TTJE+gYHEsyfV4eINIPW/UMoodSTtPwUeb0SDNSdEReN4zZNf/6d9IjFQgaeevbnMFtdqI+4OFjX326w2b3C4qA2rENcaBQj/2npcQQHm4GisRJVeDFNERZAr0RRxlQdtGDSkxfUYNllBl050EpKPe9cjP95MSEopdg2B15WYDrs0bBsgyFg9MI/cTNpE0z5d5a5HSqbE1CuQYK0dg1ivwlwK3KjH5gWDbq5GoNcg6/c0y60+H3LdflQuOlA4lUsO8+7oPrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce damos_quota_goal->complement for specifying whether to use a
complemented value of the given goal target metric.  Add the field to
the data structure and implement essential core support.  Handle the
flag in the quota goal commit and current quota goal metric value
retrieval.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 844b175120f0..78b227875287 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -175,6 +175,7 @@ enum damos_quota_goal_metric {
 /**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
  * @metric:		Metric to be used for representing the goal.
+ * @complement:		Use the complement of the metric.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
  * @nid:		Node id.
@@ -197,6 +198,7 @@ enum damos_quota_goal_metric {
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	/* metric-dependent fields */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 733025b36745..270ce9c85a2c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1224,6 +1224,7 @@ static int damos_commit_quota_goal(
 	if (!src->target_value)
 		return  -EINVAL;
 	dst->metric = src->metric;
+	dst->complement = src->complement;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
@@ -2960,10 +2961,18 @@ static void damos_set_psi_current_val(u64 now_psi_total,
 		struct damos_quota_goal *goal, struct damos *s)
 {
 	u64 last_psi_total = goal->last_psi_total;
+	unsigned long val;
 
 	goal->last_psi_total = now_psi_total;
 	if (last_psi_total != U64_MAX) {
-		goal->current_value = now_psi_total - last_psi_total;
+		val = now_psi_total - last_psi_total;
+		if (goal->complement) {
+			if (val < s->quota.reset_interval * 1000)
+				val = s->quota.reset_interval * 1000 - val;
+			else
+				val = 0;
+		}
+		goal->current_value = val;
 		return;
 	}
 	/* uninitialized last_psi_total; make no effect this round */
@@ -3255,6 +3264,21 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 	default:
 		break;
 	}
+	if (!goal->complement)
+		return;
+
+	/* updte current_value to complemented value */
+
+	/* for user_input, users set complemented value on their own */
+	if (goal->metric == DAMOS_QUOTA_USER_INPUT)
+		return;
+	/* damos_set_psi_current_val() handles complement flag itself */
+	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		return;
+	if (goal->current_value < 10000)
+		goal->current_value = 10000 - goal->current_value;
+	else
+		goal->current_value = 0;
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-- 
2.47.3

