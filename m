Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F3EF55107
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594D86B0098; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569066B009D; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9A76B0098; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2B56B009B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DED781601C1
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:10 +0000 (UTC)
X-FDA: 84520318260.17.6ED5067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 466FD80004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrjNkbKT;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9a3BVPLklVNwfTcjSIIIULB0S4jBchrAO7b10qYxcqM=;
	b=y+x0ubxWTM9wlJM0FS1ul0IFebRZdLcCC6prpuoD/G27zL6D08+f52dOeEqmM697D1Hh7A
	qlmS3B637lIwyx72t0aT/ftmcFPN0HX+3115vGNve8igA7cDkx2bTZEQaX+nKYOr2o5CPr
	jgdiAP/U40BWRUH4Nf+OLC6Tt2WYMMw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrjNkbKT;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913249; a=rsa-sha256;
	cv=none;
	b=DaLee1qhc1m1jInKJL0UlQkVTINiZVhHTUR77oyuh8ZMEUD1Eo87xk2TJny2helhQgCwBg
	X1LlaLr3+TTvCfK9wwzKih/Cqo+ND/7dVpAsWoFbGCsKZeKv0EMJAso/vXXmuVvnhEU4/O
	hNUWJTTK/yBE3Jzwzwc/lLV+ONkuw2U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3612E4456A;
	Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03937C2BC87;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913248;
	bh=B5+v4ahllGQlugFTnl7kA++eThswGO++aezsc7tYPRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrjNkbKTdGzq+yhUwe5axGBJFPzytHOMQFxyeAh0qSdkRKr0X4KexLPHlVpSXlAW1
	 MNDZfm/0LjewDrAXXM+OawQCbXuLMTUzYXbFUlxXgFuhjU5lIN+rbkac8HawPOJeAe
	 j3cj2CQbZYUdrE3qihZeHzkQEu+PxWJl9+Dp8zQWJpi8QsQuvhq533W6iI7lO08wX2
	 QfccwoG0XrzSWFd+FaAJkRme+NbCw4B7fTLVNesAwZmN8LbMiSJmAZJZ1+xlOZNHLG
	 ytGu37IMAkzbL2ijIsUyofz5pJyhr7k2bxsh638k6gQOXMuuKc/xoOgQeoxhDmRIwX
	 aIWMzn5k066aA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon: document non-zero length damon_region assumption
Date: Sat,  7 Mar 2026 11:53:52 -0800
Message-ID: <20260307195356.203753-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: edj3qu64piscz3x1trf5fo9myn9aibsb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 466FD80004
X-HE-Tag: 1772913249-752274
X-HE-Meta: U2FsdGVkX19f5cgd7dFeY7DcPOzJAsqQedU1s+QAx5hsn4sr6tqen1+aRm8zj+S4sh8q/VTUQodKiB3aF5y6N2IhRqS0KHCPnB7/U0ZL1oYlmXmeriBlAuwnldrqmR4ArwHLpIjnyz3KHHpjQZazFEbTTA9tm048YMxTQkcysbjMbY6ZENRbvvMjjtmeyQxKT47riz/+qToHmIzKt9V0j+FJeuQwrfzAWz0IFzMrCP4EtnAhjR96sqIcfplYRzoTw7YmjQEa/YPD8JSyi2VGQQAZy4pm+9BZZvwPl8Va5sY9Yw49df7wGv8CltkaxGE5YuhdzDg91dX2ss44yLnt9SScEma0s0Kpi+sd8KthQziiNizIhs5wTuG59rYiIWzCHpirAENHKeMjQFvRAqqwcVB6QCEFbSHdac/LM0rXUzH2KKSS4B95Y1z9g9rWh1zjKuQqTTxLb/CHPTmyFvda5Z1rMlocUOO1OZ75xm3SGrZFL5dnhH4r+G5duXh0aZ6wQYQDUG/HmnMjAULd1Ac9JIV6qxQGmzut/Y/4X6vATOC4SlseVev5n9tGxZLWYgw9+x98ZUCwU+g971ojmWBy//RMG05glTrIUu0FznV8WeEJkFWzKtTgo7qf3QCl9GK9C2xDYUyZlMObedw05jJVSDY1ms6i8fgZxPdr+RB9Qqgoqr8ZGsrcGpw0RePV3wM85ywnXj4ay/NgTKPrku+9CZ1Y8uBx1DYA0S6tmNEKJHz+IUTJ/JVm2QSuN9A9zZ0GiBJnrzhglTr9S+ex+TLphWmU9qXDBkBf1LgFFaI056FlbTHuFxnTL7p7v5VU37hjlOxGMSu2EyFFEFo7LkLlwIkTiRJl6/HghHnnMkX/mnM6LOKi2T+Iq5BfA+pZSHt4qo9xeWeD7fZvF5M/ATBeYHnrO+XSLkrvRUGfA84HvusxL2brR/ldbhQEcqXD3ya6vzw4o/59iyaLh0X/QoZ
 ktGd3GkJ
 UFXjDAwUw3AWSbvZQ3538XAYBrbnBHGkmQxsP3UinOBDz0R3A52GWQweyEQF1vJnmVDdTtnwaQSOMIhSkUqQDKU1XwfMqbETpLA/8aqQ9ZID+QSE9Ef815K8Mi0TQpdv5ULyk4q6/q8wrqSPlcFKIErvdE77SrbH0dHzLgqDPp+qmloMjWj4d6LHWJahyERVu69wH5AhRIqF0BFPG7Qhvc/lgXBvghj2EYXCT/lmXR2UuK5jWriGU2wnA0fnfbRzfWqfPBqNIWoLKgPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON regions are assumed to always be non-zero length.  There was a
confusion [1] about it, probably due to lack of the documentation.
Document it.

[1] https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org/

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9a88cf8d152d8..6bd71546f7b20 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -55,6 +55,8 @@ struct damon_size_range {
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
+ * For any use case, @ar should be non-zero positive size.
+ *
  * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
  * increased for every &damon_attrs->sample_interval if an access to the region
  * during the last sampling interval is found.  The update of this field should
-- 
2.47.3

