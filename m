Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90311C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDD56B008C; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E476B0092; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5949D6B0093; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2B46B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:28:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61B181C26C3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:38 +0000 (UTC)
X-FDA: 85227113916.13.B07294E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C0DD410000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Igi3UyRl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789741716;
	b=PqVm2ZLKIeRBigPV9WHx0FTP+Jn4FI4j3oMKrmAvEe6zEG7oLes9KDMFIQeYgK/TusH7qs
	nSoADSiYb8unr4OL7OaJssKzwOGf5CtHbE4IdhA23cLc3ceW87gTFUW4u+dxF1J1cMSg0B
	9XAfCcGMSVi7DLodm2UhRQVOUXx57ok=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Igi3UyRl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789741716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDElM6FF7RUmZ+/ENlqzK5UOqsMZpif0jqIreTeTKcI=;
	b=hDG0x1csxLn+U/D3ileTydGunIRwc8Y7T7oFul/TVcgzSmcG59l8SkYJC1FsuAp+80L99M
	ZceaX49logFEOaejVzHxyT9r/KhqXCQNHa2s9rpVHXhhHop0N/WmE2bWPu2Ld1rGnRbvuU
	MdPqwZ9qCfVM3ZGzLTcZEtCxJGF7Xlk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16804435C0;
	Fri, 18 Sep 2026 14:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7471F00899;
	Fri, 18 Sep 2026 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741716;
	bh=YDElM6FF7RUmZ+/ENlqzK5UOqsMZpif0jqIreTeTKcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Igi3UyRlFW/WKsgtQw8ZOmhcBYN2xquwJjMhs3uktX2GXilu0crpt0zJB0h1av/rW
	 VKrUcQPx02cFjFb9mlC/sueBvyLHxw5zLhnxNgAqbBbWpJkN4lV5h2u2tcQjaq1lUF
	 FoAi3Z5Fit87CP6jpBXJzRetkeO3odXYy37tUDJcgPvEdOCgmV9vREGZHR/7FWhlNd
	 XqQ4/20lvjiigthiqd1LnchkaLmHUX4liD/wv+5Yp6trhWvhqEII/3RiPfTbKIH1yF
	 AKTxjv36CJlPTDCJIPntrS3YHknh9qkGUiLh/oSu2NuqtX+Bl9Gg0e7EpxwZXYDDdG
	 Y886/2P7eWoxw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/7] mm/damon/core: introduce damos_quota_goal->complement
Date: Fri, 18 Sep 2026 07:28:20 -0700
Message-ID: <20260918142827.85303-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918142827.85303-1-sj@kernel.org>
References: <20260918142827.85303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0DD410000F
X-Stat-Signature: reoohbo7a4t47o14743rbxpz4piedm17
X-HE-Tag: 1789741716-487815
X-HE-Meta: U2FsdGVkX1+MWdM4M8P7ZqQ+XwpoXDKdW+2LlyZh5UJoFlGrdB13ekfHMk/3Pv/S8LWa1VdqXae3iX20xW7FyNIaZlzWg22rCbqw/+dO1xBPLbM1v+0oYO7YGuxxeBUj/Qw4rbuq4P1DB/kebN1g+6scaPmiyq4+IF+5+Q43QgxKkgd0GLnP+txks+88x4y0XcJpZh96uW3xdttZRrAJgaSZwqRvSQ4ycFZiZagX1LlRzKHDBTWS+hWLYjOLFEESPvCZprmEc7AYdItr6q0V42HEFIGSZ/S7HDze63MK9DE66U166jDeslpk1zyecCUiX2/yq9LvSIVvo1Pm9ZqfJYwHE/BC8nlSlZefPF/zAkl4eHH4icD2d/yYYk5WLvhxO6zY2ROqKrSt5cE2+lChJgK9eGFrx4dmUGw0kJzW0p5JfV9daLuLCa0COg6UNxxCQU6Ab5P/203nc0pTrb0m+pHqF4dbssj4ZIn3AvFRIA6ZsABXbkMGdGC88Q8clw8j8ZLMY1g67wyrgkrle9e+uUj5UTXKKoc7s2SmxG0jC6uSe7Uql6ftffAqUu58uJeScf5uvsuX/KAm2v+PiDvu+19h5HhVOkpVoyhxfNZYZBNIsZVbVGzppTAKrsl9eIPVDEJkwmFknFwRTyCsgDjss1nIjBtqjOi+WTbOsqK21rv3tzb+2JicCpO2/a+4Gr8CRp4TOpw7TeFQK/rAU6stpOx8CnrA3JBG+qHf1UoqB46BV+6RLBXtIjyq81eokAWU4wROsGPMasTVKmOI/ge6cCFLq9hHNwfji8fCZp5VhVS3jrW8tfUxwVz+biar7mc4a1rmXUSA6n4dk62WOT0YvzaTEiwNLNQw5UP+pwYPUoUN9jRPA9JaM4en0wBGv7JIoP6tRA0DaC2uBopHH/s064yxs3xKm+0tR/Fp8tA1Yry8963xONHpJbmJKwaisNxxxcw4+lIW5zDcLNdg4iX
 bwwmWRQZ
 DamIk3SBmVCrNqVa95fprmri3mgb9mV37Oq5NVPK0jmb0I6m96NZo+UQTfS0de3b86PHrApxKAAm8xM7w9Luol2VRimeV0OK9B5nRGP8XmewaBg2ACrlOUOZcG2uADFvInmtjnLOLhXC8/vlRWeaX9aK7GxMnzd7FLOCPK+c6wF88owlHHgY8YJ2zpL7rec22ig5rdpRYw3RdoaOwCYmV3Z+Nxl7SRdZ46hRGIURqt03i7bYlbGW+64BAk5QQlmvuuGLH5zK+Tr01cZe27EbZx3sl4A==
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
 mm/damon/core.c       | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 844b175120f09..78b227875287d 100644
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
index 4687b909d42c9..98cf6bab9fc6e 100644
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
@@ -3239,6 +3240,19 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
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
+	if (goal->metric == DAMOS_QUOTA_SOME_MEM_PSI_US)
+		goal->current_value = s->quota.reset_interval * 1000 -
+			goal->current_value;
+	else
+		goal->current_value = 10000 - goal->current_value;
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-- 
2.47.3

