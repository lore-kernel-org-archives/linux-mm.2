Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF5FC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C376B019D; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925606B019F; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813806B019E; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 608AD6B019C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D40A31604EB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:11 +0000 (UTC)
X-FDA: 85094868222.30.2773C9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 43F8B40002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJoGGSdG;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593010;
	b=fvAyWeulCglUpqfRABI4EnRK2bboJyYv/9T178SVUpQoGgY+RPnhK+42k5s75kO0RbD80x
	7fxh95Sg5/jOXGaYQnL7RJLQUwyQQ6MTUUeorXRtr6lu2Ek98u7DKYgCLyNWIzHVdfT9C2
	lqc6dQrgVcALvKEt+zgQaYqMJ9juQVQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJoGGSdG;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9oXf7EAMULfNbhY5cYkXmrBshcuP/mpp00wWMiTWfA=;
	b=35Hn4BiD2YqIpE7NlaMj5+1wQ0KXLc9FrPhILSW7l80ogz3SHJFueRYj6oWSDY5Befhe7F
	oq3D+c82DMnM6nB2dqBs0fucPiEamtgCTaCUo3PO75j80ZzI33BT2NBHjNZGpPoS6hm8wJ
	e6aPcXphEY4INnexHy/Xs3idab+gaiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 120CD43836;
	Thu, 13 Aug 2026 03:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05661F00A3D;
	Thu, 13 Aug 2026 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786593008;
	bh=c9oXf7EAMULfNbhY5cYkXmrBshcuP/mpp00wWMiTWfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJoGGSdGaEjb4GhhyfrN/DoXc4RJ8drILlJO9rtj/6VSiBf5E350SajVv0HD7Dsn/
	 kivaaLfRnNabpYQPi1uHU6nMutuuSvoqzhK3UieLdJb2v4whSYLf1pHgqRbXfa93mv
	 rgpFFMK25+A76cfUDRiOlFBnP+eL42WhFwclzR6QhI2VcA0Su7ANfIzoNn60XU2M9s
	 xNQ+I+bJWMBVoky87N81qfDWJ1hV4tdhdX2Dn/XyaY79wNvlioBm1tQllB643agRp1
	 EuQS5htblur55P9VnQEqKfOdOvJ8T3cKDxlboiZfngUq+6msFNHcPF5zbsVniw3rNi
	 uh0OLA851Hvjw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/4] mm/damon/core: handle NULL ctx parameter in damon_call()
Date: Wed, 12 Aug 2026 20:49:56 -0700
Message-ID: <20260813035001.97364-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813035001.97364-1-sj@kernel.org>
References: <20260813035001.97364-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 43F8B40002
X-Stat-Signature: 39rjofks755pdhkpam3spmkbwsrmwwky
X-HE-Tag: 1786593010-353978
X-HE-Meta: U2FsdGVkX1+/qOCRW2sSz8Qw6tpLi2JABLaXGZmMUcxx5v2Cp6m34OlaPCO4QL23BlKXTw0WGJ4j0IUG+q+zcrI4PJjGWRpWFzDX2rFo73HmxBpB/I4h1ASF4/yYZm4P+IdZaGCcCM1dV4h23IeUMg/jefE/Gug64BrIYffGgnrUu8/AfWUaRCvFxT+FaOGFh4fCtjiBTLxBBMcG5WaqEDj1E+McVee8O2/P5Lzy+Uj++Y9svcEA9WncVQyU1Rvu+rypVVnzWNM6NdZ33Cx322W/CdIShE9ODKQUi35aYtYMAerzer/pZrb71Pt6kGS2z7NtfODqAbVE2Lr1eIw6dNpRCx1VD6R80ADZJeOeJIwVc1pGdh/siDD1muiUO17XRUrCO6lJqY1LoeRp9f1h8SNjEjEu0TENkrGWh8U9ew7aonWOKbth1ukmqk/usaPNdYJ2tveSdRSMah+bVXDtZOBIGXodDddC50LV/9DskNO2J5dVhWyGsj6Jt7pQOib8BHyHwe9wQMmunyyv/4Dwvd3TC4qTUV+f0LdT3CRAb0FSKOicXENJLXGyThSa8lnGMwJlp97YwNTCAJO3Q4iPKb+oqGzgMrBQj9FtT1VjhWNP0LZ77BmZnKDggHVHWLqQHOQUiUfFhM2MTDb/UaPEg7X81k+kkg7T9x6k4f3RJNChWj2LjgZWYbqxIU9GZnW8p/O4R5gBx8RekdnPawD1onkNV+S7HXo0GKMWQkdZ84q177HKAsFZLY3Emt8xVOx12MRr57MRXICm728SLHcL1W1PA6UbgGebzs8sKiBS/bhphVvyRUIqNihTF3xux3F/KP/uJ1AuGfnDrSy4LcC6Jmvbm3XSRwKZBZtjybdOQnad++Tl/nR2mK/1CrV4PZTITtvdFUp5CyEGTiVAxV+IPUiWQI9fPPHuwWUBCKTpaG/+MQYlPthYgPiDYmZZcj0EG/x+DqzfWEFDqd4xAde
 vWHHbSv0
 lGTqTifHddnTXyvlAePTMVXpQnFq4r5aooNWjR/MteZ+GvwVQFVKmRydwlKvtmTv2cxbsZAu/DPcsS5MfIrze4NiDAHgjLw1lkXAj7EKFpAH8OaKxqD/rrwB/7scMYtdAom+oMfUe7rRndPJw80GkkGE1Y/rUTkPP8PQyY4b7YglwLOfDZWecEswa/zw5YTL+4FRSLGmnR9s4MhkPDn7TZLpyG7UmyrRLUrG4mvjmaGYUIG+Ya0IX3TaTjcTJxZc7MFbosREEwDsWAD7Nr9QTZAyzcQt0Bpb3pKFgSPv41RW54ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When NULL damon_ctx pointer parameter is passed, damon_call() could do
NULL dereference.  The caller is responsible to avoid that.  It is easy
to forget, and there are many damon_call() callers.  Meanwhile,
damon_call() is never meant to be performance critical.  It uses mutex
and completion.  Add the NULL pointer check inside damon_call() so that
callers can pass the parameter without NULL checks.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 92631a36d7b51..5882f9c94c47f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2188,6 +2188,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 {
+	if (!ctx)
+		return -EINVAL;
 	if (!control->repeat)
 		init_completion(&control->completion);
 	control->canceled = false;
-- 
2.47.3

