Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03590C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C456B009B; Wed, 23 Sep 2026 06:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973AA6B009D; Wed, 23 Sep 2026 06:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861EB6B009E; Wed, 23 Sep 2026 06:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63CE86B009B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFBFF14054C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:06 +0000 (UTC)
X-FDA: 85244619012.02.F18B345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4F908180006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLsYsRuH;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Le0M5MU2vZNaokYjxTmQGl7234V19KAd0AEz359SlAY=;
	b=DwDtlzH+ekYt5rx69n68XmYZ0aRrzI0QxLCO1kUrWLHM0cHx7ttEOxpQYkdVM4sK6SjGhb
	uhsQNHYZXzNgUKEogdMp2CBmVZMonHtYH/4quYw1megrtF11E6NLvmGeXbu3SW8S0y943s
	VRf+lrQI0Xb3/Z/Y5i6JZpmWFMij2Y4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLsYsRuH;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158505;
	b=yhS3VotLPiqLt0RbS8VtYMGgyPvYymSjzyaRYT7e06pqbTmtfbOfcr/uRHuBny/O2oM3SZ
	Red4zC3XOPpz/wMW+xOL6gjQGcgyx/BzTj/Hd0GTK8iPloPuiWd/q/X1xjQdtEweMgcM2r
	ouI1E4+rfQpD89o0KNWfMpwjLyT8PlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5139601FB;
	Wed, 23 Sep 2026 10:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5D71F00893;
	Wed, 23 Sep 2026 10:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158504;
	bh=Le0M5MU2vZNaokYjxTmQGl7234V19KAd0AEz359SlAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLsYsRuH3maXMLxmsRhxQSiF9J5/Gx19cMgqQyWx4F82RCnG5QdLrzPQBS77+m3fQ
	 WHlqZ8KDbcYIkq8UZFDvvbUaNQcbXrmFRnu5VqdlAMFF61GFwQXbE4EgrtmDBW63qa
	 7a6mKZ9LYajFcXr21026JxtlCkXI88nsCIO9T1nGQBvgOkBe0TRxZvN86gqR9Eoyd0
	 lnoO3vwu1j6IwIaqxPCQJB0u2tE60W9gdghX2t3A0OAhmST8VqDpoi0vaMKBVFX5uT
	 +xcRAPPiIQiWpeECHM0S+IGUFbwqWFb2X+kvas0Z0vajqSnYTh7vBEYHgMUzlnvZfu
	 2Z1P487s0yx4A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 1/7] mm/damon/core: introduce damos_quota_goal->complement
Date: Wed, 23 Sep 2026 03:14:46 -0700
Message-ID: <20260923101454.5748-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fgjdjrxictm7ztzmdtybnqaikb5y5h8u
X-Rspamd-Queue-Id: 4F908180006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790158505-706211
X-HE-Meta: U2FsdGVkX1909XF0yTc0Vjko8nnkQpygPCcsQrKhiFtNQWqkB/RDNjfIcrcHGKFFoM4J3I4GuDoNnMxa7KllYcwlkF0NM/msuRQsERLHwbx6fvs9mNqNtjFnVsjOPcOpoccf8X7mgsZRCYCKCpv+gpjvaiB5Y6V4I2EYPGonNNA62vj+HmOqimSJCEQHabT0+5ciVtpajN1SP6Nxum4cp0p09k4giyLKYzqygxZBa61iLSu2OMGUGIcUwSKCdPVmewMQNsCNxl7LUGnXCcsJn1bkOaPa8w/qzBxp3fkU0KdrMwmcVl4kIb3OasVLh57Picraxp8xV8AJtBK11EyBZyZVDayLMT0nqDDAk3BVfRjXEm8f7frTi6Ta5xVoTE1X5QX0JAQgFqqoF0axWz+jFTy0v8UYI0yWVKv/D0u5u8WE8A/JvBLRMc0lFU2PAJBZMq7VRvJRN2xdq8ArJqeCcJrXHcqfWA6nHsO4SLKH+FSr04N5oE331MjKyakLjd/++mrSEQlNnocB/G+O2Gd/hKenfnmpwmsVMg2nSSyyyheaFatM0lNfHNz63mB04gFlgob218q16N9IyI4pocOJrw728hpc3NMayX+hKenV0xptYf97k/qiNkJmzvym9hElvzY64DRSnD6JF89Gix0CIKu1ZiLo+5F27Hm7EXYJdPyWMoHbIspA3M/pehyMve63wk7xHZeV63CmDHVsjc2rFRJmggshxHC45ZRMlx8tbcgsa9sSTxj8+8j3uWAVRRVKJlMv5Dyx6KcxEM6sMoVCU0vQqkSF9ILNolen7DRLGxribvXRgAWoIw6OGZOGF5km6jZ+Zfi9dc0Af1z6GUJFdVCXEQUclN0urOO8pkNcZ8xuYWDWXcnHKEqr89Qo6LibLwvVrj3pDrMYr9EphPUk8wgMscRwhIcnJi5YlOZEKjSXTP0iXsr05kvWp3Io7TQE3r90yu6GMKKk1C8eTyC
 FuLOhQdX
 5g02vitcAODY5RKrzzlCvhLVOkhH2a+KlcZ+r3jNpdnkZ7QwTpe6I11FtL+9wGI9NqwJuSno28tRgp87/6yeuIzVDmlZPbf8ZvN4HwZjPs86Sy0ltl/cmZ2yo9bIbouTwWxynTllRDp0918w0cfUPpR1+5InM38yX+4bHyCiNVTiX1Lkuuhh2x4U4UZMM1mpXSePWTgYxgJS/WN/rZloLgZ4Dh7uI4tdZzr81ZKmJCEFJ5zIHXXCwS7neWXumAY0sRDyks6LSoxqePmLQZLnGKtbW1A==
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
index 6a29dc2ac8db..42234839ce29 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -169,6 +169,7 @@ enum damos_quota_goal_metric {
 /**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
  * @metric:		Metric to be used for representing the goal.
+ * @complement:		Use the complement of the metric.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
  * @nid:		Node id.
@@ -191,6 +192,7 @@ enum damos_quota_goal_metric {
  */
 struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	/* metric-dependent fields */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 566960659e4a..836cf0d0de6f 100644
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

