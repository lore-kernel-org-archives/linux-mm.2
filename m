Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498B3F55107
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1626B0095; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A5B6B0098; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDAC16B009D; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB7186B0095
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6243D1BF7E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:10 +0000 (UTC)
X-FDA: 84520318260.21.BAEB1E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C34BE1C0002
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdleRt+2;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAG2IrI+jY23GwK72qKpuda0QOlgg+UNIbgIw1iT+2Q=;
	b=VPnE729F78kveFve2Vhw2o6jR0JQFulfPRVggIxnUv2cXR2wAmsV+jeVrykZ9KWn7xyesM
	MmaBbS/okrZcaxb47yMg6P2aaKfMNoE+yaeZV2ZoqBfseqJIUmCslt9Mivkn1yL9mW9QLH
	j3/jaOQSGNLN+JOv700R4SNv9ZQ4Ha0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdleRt+2;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913248; a=rsa-sha256;
	cv=none;
	b=B/T5L5QnlnSHq6E1/2N+ChsNO7YnwVqnqF7ChDs12t6WxgSOFs8CYOAtMVcKHHOrqtN6je
	P7QN7VWziw7U3oAoy7KO4WicaaqcrU862czMAXOJavZV2I5u4iJcr2gZPvoirEq0d/kZeD
	tnyp9FWLH3LkeDXpy/SKEdK87pvetdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 017C24402B;
	Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E28C19423;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913247;
	bh=lhgKVHeTPuqy/SKtOJv2TodL0/GOZKE7UoJkbwMyV80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdleRt+2SbvKj/v0G3elyQ10jHVItn2AczI/Bu7TjjQMtbuBMreodArxjoL/tC52l
	 u31lNGbXHtoNLuMoeZAtrQ240j8obE4QTZmqokndT/qIr8LTjU1CLKq7idcKXt3QZ1
	 LKDjImG4K8W2yxL5GElLV/FBdI4GM6aQY5cUtCFrgNjMIMlU1w/MKNLwq7rJoC1zrO
	 B60M7MK1uy5OpA4DDGnNuvzm8Rp8KCfmWwLc62fcghBYaqPkEAfwAzquzOhNI/MIUn
	 ffeackEVTkbp4zXkeXeOFDh7hI2xgpX0+GyJl9gISJ78uMcxMb95SXRlIdx95+/08Y
	 f8YCJGAzvbHPQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/core: clarify damon_set_attrs() usages
Date: Sat,  7 Mar 2026 11:53:51 -0800
Message-ID: <20260307195356.203753-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C34BE1C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: 1f4mh7a3rwnd8tuf391sxxoc1zixst3x
X-HE-Tag: 1772913248-23628
X-HE-Meta: U2FsdGVkX193kU4fQUgMclK6Hw3zD+UiFmLDP3bNp2zRSHoGdMB/wfz2sWjIkxd99ZMDD1cIlNdp2+CklG5zRaqkuYarlJnB0JljfCkAgQ3TEy4hKJ3AaKj6kdajYkWtVrAvbh4rjFazRNSJZ3VMOS60cXZdy0Bv3Ymum0Y1Qevp7Rcs7tNLj2vE6p4V2i+fUWdWR/gAcuv9yyS2OuQGr8vrzhLl3r/IEjLMCW0L2rKgKG0pZFkFxqaN23garpktrhHixTkIBhbAba2BN7KB71+ftli/+z/ODH8rbt4xcng3QXzCsZhNdKl3hTM6QlCflQxvnvcB/X5zFKNZg3mzK0/Tul9Be5ZyoMay1NjUvw6sJ+en4kw0As26o6O6PmnyaWaD3KKvdlK48vlw8L6dKIXR89PCXDPmjhFn5wUnRDNyOSbOJX9gxbCZfUVh/NIYt9XZtBhmRr+CSgeZlG1+yixQw8/nED4sQTJGyKmIljfOf8xBpgQxo6ISJaXP64bkmp087VkpLwnshBxk8uA5LeCSZYtc1NejqKOjtZN7wZNxWZ0xOsg8mZj7fE9WE7Cnx75uHDbf+0voihzKdO4Rm6f9v+38Se7F6git033RGVxASaSdBlWY7sJ04mnTFRymTS5EKEK08M/y3l9vfbd6Q1MDzUVAMH6V02nQ6SBrbpo5m40T0/Hyg3grvv/x0iO2epVh3alprELmnHoX7E+CjShvlYtC9qKYApkVP+/Z0ZAeFL4YB9z4vclwRKLB6mCGB8msV1sV/cSGMy9OT2uiclvsWkrKwk5PJaXc6cOAYJSNyiXjfEBwVDAYuz+P3/FXryoTBRiEQ/kS5eOXkYWTTZ4jHbioVOZ7igdXntmOLy+gVvKAFZJNYpmp5/IVyGRoXarTLvjmV8spZOiulNVpvevGtVvKClu/F2OwW7hEHkoHdCN4IjPqt58UvGisOiHSaPWpwO8pS3yJBw2xfA7
 V352fCel
 L26PC0fbLAzphnzbmK/17h7q9QJotmd0QAj40WqW638M9gJkaz95SalriJkfHr/fV68UnHMByvn3qDVzN2fb2cL6ICswNGYpmG/Izz856+aDmN4NBYTxZsr3gvVLC9Aczg3UpU2Qeau9leI4xPuRhoBlNCpBXwWYTA/aK7oqO6Yul9c4Jv6wGggxglBacVI/GFNS/pxZcrDhHdRmgyNXcSoHBe4VNER6Q05Om4dZlJ/Bo5LuVGjcwB1rT445elNGbXHSeUp0cVai2M7TBWTbI082HSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_attrs() is called for multiple purposes from multiple places.
Calling it in an unsafe context can make DAMON internal state polluted
and results in unexpected behaviors.  Clarify when it is safe, and where
it is being called.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4e931f7380477..7f74982535aca 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -751,8 +751,16 @@ static bool damon_valid_intervals_goal(struct damon_attrs *attrs)
  * @ctx:		monitoring context
  * @attrs:		monitoring attributes
  *
- * This function should be called while the kdamond is not running, an access
- * check results aggregation is not ongoing (e.g., from damon_call().
+ * This function updates monitoring results and next monitoring/damos operation
+ * schedules.  Because those are periodically updated by kdamond, this should
+ * be called from a safe contexts.  Such contexts include damon_ctx setup time
+ * while the kdamond is not yet started, and inside of kdamond_fn().
+ *
+ * In detail, all DAMON API callers directly call this function for initial
+ * setup of damon_ctx before calling damon_start().  Some of the API callers
+ * also indirectly call this function via damon_call() -> damon_commit() for
+ * online parameters updates.  Finally, kdamond_fn() itself use this for
+ * applying auto-tuned monitoring intervals.
  *
  * Every time interval is in micro-seconds.
  *
-- 
2.47.3

