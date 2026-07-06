Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82867C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4F36B00E7; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E9C6B00E9; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459726B00E8; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BDE36B00E4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 74D6D403F1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:25 +0000 (UTC)
X-FDA: 84958559490.02.9CDBD1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0410180006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U54HSCwV;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347563;
	b=uRdCMWZ097+9XQlA9S3asdZxxixV61wNDOG6CqOsYicqCFfnLJoqlUp+snlE/U60CzmrQg
	lj753TN/FIH1ENe19bHOhyX4znaibUHCfHJw04UuQDV4OEbo7Iiga+U5yb1muJcYsxZIxx
	iG6A98mrsZmgpJrfThkGm16mw+V8F+g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U54HSCwV;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEatb2PqGWEsTMpIGK5NyiCA2DZolTzT+XVQuw4N5Ko=;
	b=DTha2znL3uctqXZ+QR00g5/SeHVm9ibskim+mCZuRos6s9W107mktNYISyax70iOhUVBVF
	dsVN3wy9Da/XvRAOdnHh8TL52FWunlPEAdyD2PFJSu9WV2ucIEHb87Pln+PGK+VlFofDnN
	/0QhzW7SBBsIQVlyXqK1fc+toArtHSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7665C61831;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265FA1F00A3E;
	Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347563;
	bh=QEatb2PqGWEsTMpIGK5NyiCA2DZolTzT+XVQuw4N5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U54HSCwV1AMqJmZfzHAzGot2ucL3pXqXJ+pqpC7+P0zdsDh9oRt9iQI9Y4jc2lUtg
	 wRqXtsuXMO7xZ3gSTqnfDJUHmGzpW/RwJ1MH54EcnMThzmWajXmf86MkAgHUSOT1fw
	 2TKd7ejKz2wwd7iZQsySVHTEyoBh0qK8nGjhgUxyFh6FopVzyyDCTGbQNR4Eqpd/zu
	 bmtsJhPh9C1ayQ14vHWxYyRh5SxqH7KPUtQo1IRmx4tRVL2jrDkxUsIXwMG/5Rg2mx
	 Iah5dQjVA2YShZu2PNUnV1FxlmFPyhsdmcJ9/nr2NVlA7wNXK7FJLNwn0n5RpVYv2d
	 BhNhqoT2WMbJQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 09/16] mm/damon/core: set samples in apply_probes() if probe weights are set
Date: Mon,  6 Jul 2026 07:19:03 -0700
Message-ID: <20260706141912.88445-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0410180006
X-Stat-Signature: 71hksk84rr158he9za11t868ntmuc7yp
X-HE-Tag: 1783347563-877969
X-HE-Meta: U2FsdGVkX18MhjnHGsnhBkwN7hGarGVIKkmfLSXWY5aSBbfgQZB5l4RN/i1ueMTeqH9x9JSRDMHJKjsRUx2FJy9Qsy5W1oalDpCxG369YKxf/g9dw6n62ecy4j/zRY8aq9Bee4mn9l4f8a/DcAvhSgBoSNDqpaEcBW6FcOMS9EfqFuyKNopVW5iDLXY+5F+bnyzCyxEEq99WDBXRdAhlwTP2l3ZQ9x2ANef+5by8TrbPl1pUzyjiUMFDMx8yhziyOitm45KSAvJODAaHKr4s21FMl9vz0TTn0B3s9ItIy5KMc67A6bsy1mCu1SQRWuSDginiK212VeICe73CPh+1ErUlR09tVKYc8lj98JuYqoi+oAorhZc53YFLLUnBfrw8120jraztgOTiKavVtEifkTwSstOSOQ4fgaOStSG5ZgSLQ1ikr+ihTvaXtlwQM+YHPL9lytkU1aftQ0yarJbwR4nuiATeOb4pRgTtGy/B/22km2Pv+4RxDtU0+ADfzj+3Gl8HbY+qSkYNTs2e7z9Lj/J79nlOUd4JsG4N4cYBT114IF4TtM+Lb+HXOAiyDiktMnViNuXD5tOMzg+RZi7uNrck5kjk1KWXxaxHdD8B/zybOis9ld+BC9ECVYEkFBUL5KnMT9sJwnYqEDX7sxJT78XN1FNhV2SXTL9F0PqRyZvxYKyrl4eCO5iDwz6dCIISqTl8ttK/2DNJluhGMYREpdwcx2xF1kIaocuZesYn0/ZLmvARxtccQ72CLuymnADYj7Dy7ZfkZz5R29O9bBbZlXN6U+mz92Jgy4lGW4GvIN8J5JnTm2bGkO8LdfokdEHexSotI9saygqi7BU/TnBxf3xicekTxkxa0xEewHJfZg4o8FK8c5VRj+YzKKG4v9EabBWZxklp6Z5fH4JMNx8pemcRyRuVZgj3FijnCCYFlk4TAb1LN/RovI+yXcA/FOZHhkiF4cf12uf45WR7DSI
 hcMHtCaj
 44IeI0b32sFhquI3TJa/e76NXyIr7mWejeO0hQdPCxqH4hpf0Yc+UyZzpCj9hcZ8MrB0/Qj5oF26dTQ6p98twxOkH97dRwxKYjk9zcbVqs8rflRmknK+e0DVsMpq8zb5NIC56gKLLci4POAZ4ZrqwnfxW/xI5Bv3F2zNcCRXMpFgQxi9a3LqIbQ8HZuH22YNQXFQBPGjJGgbegQ+bQ1F8ZBtYglaNExk5svH+CbCQVAvVXZKZDYteODt9dwBXR/xS/IwBDhx8vyD/vDMC+aDn6QqOxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, the prepare_access_checks() ops callback is
not invoked, so sampling addresses of regions are unset.  Ask
apply_probes() to set those together in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ad0f28469e633..71008ee6ca243 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3728,7 +3728,8 @@ static int kdamond_fn(void *data)
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false, false);
+			ctx->ops.apply_probes(ctx, access_check_disabled,
+					false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

