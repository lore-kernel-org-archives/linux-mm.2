Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CE2F433CC
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 00:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29AE6B0005; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9EC6B0088; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C88B6B008C; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AFED6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:22:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D7878C158
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:02 +0000 (UTC)
X-FDA: 84662516484.08.CDDCE5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 89FFC140005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KR7dFtol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776298920; a=rsa-sha256;
	cv=none;
	b=N8KARK/hpxc4CSJ6zpoCHhX602gO+4mNcN22puyDIc3LcEzuACd5HcaUK5+7O+/hYr5/zj
	l9UEF5Oyl/vItUikJ+iXkxcY0na22j+TlwI4Pg/zyZ6ELYbqz4t8CLOvZGzefih4BJxEIL
	1006ZNKPC6VqtTD2DTJHt45MgTdposY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KR7dFtol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776298920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sFboVlqhXU7c329R1vpVRGNhfS21/nkba0oenxk99jc=;
	b=S6qKuLOClfccZyyKJSgpIrPBYCj7DGdxr4ZrwLNmZhauawfffo3SvXKGh1EVzMkBftPoVT
	mlRf6RsUrEVQGPsFdGnaWgZGsPTCQjZthVU9ZNdd/MQdGQxxdXT16c0CQDrLkwfIdzS20S
	ENe530dWOxnaSJg++mt2dvcm/VQkA/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC6D344060;
	Thu, 16 Apr 2026 00:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CECC2BCB9;
	Thu, 16 Apr 2026 00:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298919;
	bh=oAz4P2Xf/vMXHQmZ0zMlkiiML8XeygCzQMESdno0b8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR7dFtolv76LoMS4QdAmmx6dkibmmtpjYB7wsALDytuBX/USmNta5JsKJoX1Xd5Gx
	 XIAzFMC1xwjGPHYLAD7pTRooT2nNizetTkkLtBvgaS4uAybHdZ2+xIE/jOk8QQLvBr
	 HsxCSycHu4YAetBYhg8/w78znAJqPKtQKLS7PFbnJeeAotTFcelLtyA1mKoHAvlIfq
	 XPbcYs/Z1Pm5VC4h9SATiew+LIL1RD1YmtrsoNZ3cvpJWyrfd7cWvm9JzstA6Lch5h
	 96Dj1htYEw5Kngtaz4DaAlJCLyhC+3mXJl9px/FPxKodCWwTGD/NuuCKtWBhSs1fPK
	 pN6Vk++rTg4Hw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Wed, 15 Apr 2026 17:21:46 -0700
Message-ID: <20260416002149.87090-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416002149.87090-1-sj@kernel.org>
References: <20260416002149.87090-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: e36ozs9ia9n7jdeqbgys4j8w8tqkr3fn
X-Rspam-User: 
X-Rspamd-Queue-Id: 89FFC140005
X-HE-Tag: 1776298920-558079
X-HE-Meta: U2FsdGVkX1+jgTXWW77ehDPXWqIZ9M2w+cdEEMISzjU7VkL9mZqvYVDyaC1Yyrw3L5oMf3p0lnmWtYz9HitK9TtGvMQaquZQgFSpQJehyia40NDgFhbHW4SPRIG1CCkpb2PTtC6MDWJPeGbdaH1TQOoLYPxFfZuepesTOb637p7V18FWZWZLpudPZeDD1qwx8pn3yZqnxofKhs33UOxwxpXKVbeNbCupXouhXrod516EaIG1KEJJKAWgPKT+PCp47l44glUbT4iiJ9VDAbMiPPIruBBIapF5bQtxJyYOgUl/gBI8nI9Z/tyYAP7BQCf8CTlcdNZGp3D3t4hRTPNzcQYwr0ZNeraPsf0mMwhmpWo5ivT24/DGYPTDlmhA5pjAaa/3JQRzSA4IhruGHeTFJX3aV9Mx0wFzEj23KrZyIc3T2LCI2vKjzLQXjz3xmyuIVx3+Bqpj4OybAQMfH8WSFxO3jXe39BLxhm/0O2DH0mYaY0Et7ic2EPdwy+UipcdZhhDHeZ4N6iDZf4rsy2McIege4KIX52Q0w12nd2M/wmb3MPf7SHxdPx4pEhku5ae1pPd+Tj+BGMfoD0RY6Tq3QFe8EyHLoyHPCBX3o5eYf/HwaeDAEUYuIXLo4HINCqaUjfwhta3b01aG1XWeLMfKKEFpb5qJ23WFrMeKuVzkEom5abD5Bggae4v5ge+52UJ7yPjNEUEkHpYgEr1GcipRtN0ghpmVL+iq2M89o6z+zFlmQpP5W2vw6rx1bXS+R8j92qSMBjiuLM7b3huXmTIJpWsNJsJiqyISmg3w1nvtAMRvJfhcH9krAnKS4Wq3M/zgcENIfH9+LoHRQbAQPvk5yY18nkn4wVNnsULwt6M72orpTuuxZ7+PzyeQWo95FtRXLveEiJVPlzrz9ft2mqrhzE+EKsTO339rOhn5nT1M6lKa6AhEFeyVigaNYfxKRtQ+nY2j0VQ579ku0NpAhOU
 mmwIqZ23
 O8ZRJSCdA89ode1XyfoesnpnEUyr+tGgtralna3SpPHa4sXiAGfZlNcUjlob6d6fJDMcLcxcNrxnwfe1dqbWOR+QV/00UgjVAn0d6xt+Lml31tBfZtpWY7NZWQJPL/APtQHq04MqL16IWcYvPjFQGD+S1cbleidM60qH5TrUnFIkIgBVWSvrg3oJq8whineoUsvzqafX07yElq5ERNUQd8tqX2Nc2+ZgXNhWdWaCXmIEJbzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Knowing the pid of the kdamonds can help user-space management including
monitoring of DAMON's system resource consumption.  To make it easier,
DAMON_SYSFS, DAMON_RECLAIM and DAMON_LRU_SORT provide the pid
information.  DAMON_STAT is not providing it, though.  Expose the pid of
DAMON_STAT kdamond via a new read-only module parameter, namely
kdamond_pid.  This also makes DAMON modules usage more standardized,
because DAMON_RECLAIM and DAMON_LRU_SORT also provide the information
via their read-only parameters of the same name.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 99ba346f9e325..4901e9a7c3398 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -44,6 +44,15 @@ module_param(aggr_interval_us, ulong, 0400);
 MODULE_PARM_DESC(aggr_interval_us,
 		"Current tuned aggregation interval in microseconds");
 
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_STAT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+static int kdamond_pid __read_mostly = -1;
+module_param(kdamond_pid, int, 0400);
+
 static struct damon_ctx *damon_stat_context;
 
 static unsigned long damon_stat_last_refresh_jiffies;
@@ -260,6 +269,14 @@ static int damon_stat_start(void)
 		damon_stat_context = NULL;
 		return err;
 	}
+	kdamond_pid = damon_kdamond_pid(damon_stat_context);
+	if (kdamond_pid < 0) {
+		err = kdamond_pid;
+		kdamond_pid = -1;
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
+		return err;
+	}
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
@@ -269,6 +286,7 @@ static int damon_stat_start(void)
 static void damon_stat_stop(void)
 {
 	damon_stop(&damon_stat_context, 1);
+	kdamond_pid = -1;
 	damon_destroy_ctx(damon_stat_context);
 	damon_stat_context = NULL;
 }
-- 
2.47.3

