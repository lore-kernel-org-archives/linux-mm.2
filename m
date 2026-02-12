Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 500D6EDF045
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E466B008A; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6E56B0093; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C896B008C; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31FAD6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3EDB13A9C6
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:30 +0000 (UTC)
X-FDA: 84434812980.08.57AC8A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE71B18000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pd+sLmUp;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq0Ys6eKSO08tz8KzJ1D0w6mVS4DEE1KYkuDRTL1jWs=;
	b=M9Fd688vjt+7MI2GZkss0wWteBQnQ4cWyUUWFGbIotVxQdR9Vmnye/UuTMPtxD+5zJKZEf
	MewL7GEbvxSEi1Bg1m5B5mIV0zDryAq/wkEYB1QtihkoGjQLrravEPgjK6yLuWvzFWQPpw
	9VHnZtCuUfiF012iXHtrONWEGAXAn+c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pd+sLmUp;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877409; a=rsa-sha256;
	cv=none;
	b=uuZNYMIqC74+BRa3sRUbvHFE3gRp3wzRYz4sDzIVrEuUYyM1EcvWF4q2kSdbnA1aLeuSY7
	vkulGBb4QRs7qCC4l+4jPeYLWNby3fmho715nmuNjACXvnggoKFzJyX2SL/RyS0cMSjgN+
	/3hd+okQ+rQ+Qv5fseWqPQbx8VLll3w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE697444BC;
	Thu, 12 Feb 2026 06:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9692C19421;
	Thu, 12 Feb 2026 06:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877407;
	bh=UnAHQtsdX7p+D49YqSMSnEWB3831nfvi4I6dPZDhfFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pd+sLmUpM+PD4V0GXXyk4YwJtLnBTXKa68QhML5DFMBULxaw5RGwWQuIzAOgPbcK7
	 cD+rA+9wVI9jqOu/ICCWjHI/UInjVN2+EWkfpleAvEXB45cDmKiz2ospLvAH41HrBC
	 e7EyzK4vuTpnPksxKXmkAFNYf83bccDYLL48WnbI7b1YDQWV/okDFgQvybHjRXCbhs
	 HqEWsE987AVU+AVqJAEHdn164zBoqDmrMCBoCLan+NnP2co882Zu1KEKx2QRVDCQPP
	 XqC0G8Q6e6s/ENME6KNk+7Cz3WQH/l1QCZfIOn0mx6GYw9ojIDZB0F4agoIjPkE9/C
	 8i1+cjCd4MaZg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/5] mm/damon/core: introduce damos_quota_goal_tuner
Date: Wed, 11 Feb 2026 22:23:08 -0800
Message-ID: <20260212062314.69961-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212062314.69961-1-sj@kernel.org>
References: <20260212062314.69961-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nxr5a8kcxtywfeut35f56rnr6dqt6r3e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE71B18000C
X-HE-Tag: 1770877408-302055
X-HE-Meta: U2FsdGVkX1+5P5PRhSHnlPblv3AnrVp6QotyxiN7GDQQ6ZCQaAg88X/g93O7ToNaE77oe06PghQ2peNpUGWhkzyMB3yOz4E7D4AkYbo238JZXw0asXhG/QAN1DXjsiGJ171VoeBn0QyOji9BEvp75c9AT5+GIPrt+vVzFwaGyAmvr4yGQ/bkm83uK/JGTUNzUXkheeOtzot+2ZH/uRuaQ86nTymuTDygQCbxQosTfUkweBpO8tYwJ2w/Hv+jDZN9mF0O6G1IvhbEOD1JtsUjk4dHKWRkGs4XlMIg/gyOnvouGT7UMFBekuis7US0rcToHdm8iNtntGqufqd7ZVDtc8qbDqRWvWEFUNK8oepF6YLoE5XWMFURzBITRdpadmEhwE9pE8bZiMJqsRBEhHZDedjmqA0rjE4NcJk91CKd8GbosaGmIwGo0ZzucFM92NuSUW09LhYA0rM1wGD2jFazRkAPYIbaUbfhJUI669ywfrxmk6/ppTvBl/9to3THAIDyCRUHXKTEfFfJIIrll0hHmGb+Su8TQ+R5PDcorHRjsHCnDT/Dt8I7rRxAFXdMxbor/2n+CURHCstGmu7ByycpPzsFyUYn4+RR/JRQpnwzTE2aTZeYyRp4klQrZxKrzDVJeSGIYIaWobP/oEsqd7QKdE+3j8ocfCE3y5VKPHjWE2H9vuUn1K3Ydw8wU5wkJpjtSXnDNr+vv5iC8dtHXD/VU36/EoCDPOprcr6iPt6uHsuWzfwsVWHxqD35gUQCK+s6S2KKHj9BZIFuQHiSyiyVMDf+irsT4MlyVc+uaFipNrLi32MOiKA/Br3nsRuC4nIeJKlh8Gg70Go2/yKngkwmMrgVcWA4HovOSJDRO84YOH59EiawinzPcBzFudgWMvmaiiuirujd1Wfgt1Zzxk6upy69az7g5hxkIfahMgtJsI3Hp5YApIra2pH8TnVqbVtTCJqSv5ypupIxo9hnw7u
 UP/fmTJ9
 JtVUj2QFGVbqJoFXEh6YbLBHlHt55FaPK3VrfFtcMKAEPtdmZPxE/p62B0A6DtmqTuUS+sn0VcaE/EKoXxGxfABZMejGl1Ph0KssVMFi98Rj1xyMMWAUOGJsUwIukpT0knGFGSWhBFqZrG/JgnsXeAareXVgFZbFzJeubGBRMR/xj7VrqfPvb1AFt0XQ0bZie9oVWQCFlFA92xnfoNNSyt4bapYwVT5BlNgNzYOgm3cec0oCvU3H1ybND4NGQmi7KP471K/qbboe3d8ZUbAbJmZh8+cH3YJts8usyvq/zT7Xh+TNiAkvn3O2vSkEFSOyw8h6H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently DAMOS quota goal feature utilizes a single feedback loop based
algorithm for automatic tuning of the effective quota.  It is proven to
be useful on dynamic environments that operate systems with only
kernels.  But, no one fits all, and we got multiple reports [1,2] of
cases that the algorithm is not optimum.

Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
specifies what tuning algorithm the given scheme should use, and allows
DAMON API callers to set it as they want.  Nonetheless, this commit does
not introduce a new tuning algorithm but only the interface.  This
commit hence makes no behavioral change.  A new algorithm will be added
by the following commit.

[1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
[2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 mm/damon/core.c       | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a4fea23da8576..25345b5f821b9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -213,6 +213,14 @@ struct damos_quota_goal {
 	struct list_head list;
 };
 
+/**
+ * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
+ * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ */
+enum damos_quota_goal_tuner {
+	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+};
+
 /**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
  * @reset_interval:	Charge reset interval in milliseconds.
@@ -260,6 +268,7 @@ struct damos_quota {
 	unsigned long ms;
 	unsigned long sz;
 	struct list_head goals;
+	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
 	unsigned int weight_sz;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0ff190ed8a599..1c126d910fe62 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -405,8 +405,9 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
-	/* quota.goals should be separately set by caller */
+	/* quota.goals and .goal_tuner should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
+	scheme->quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST;
 
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
@@ -860,6 +861,7 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	err = damos_commit_quota_goals(dst, src);
 	if (err)
 		return err;
+	dst->goal_tuner = src->goal_tuner;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
-- 
2.47.3

