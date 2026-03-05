Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF21DEEF304
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AA86B008A; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E88F6B0096; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF136B0088; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0126B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B43A4BB3E4
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:29 +0000 (UTC)
X-FDA: 84510906858.11.C789002
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0893840005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FYMSt3OK;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Y5LKeeA8RgyU5+f8xemplLhB3jvtiOkltAxSO/TkRo=;
	b=elq/pg1+z9WcUvUDph2oqtyf2uDcTnAh02+QevER7+OWdXX9F5pcR3C5AUf0VR0nuWRBoP
	53BAoWqGzwOMxf5NKFFWVNqlxxP6AJsuvYz15HJfa819TXiFsqf+JHmymQVuJUydsPgcuQ
	WJDOsrVacxIBLCn+rIaNZ8QMDz5av80=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FYMSt3OK;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689168; a=rsa-sha256;
	cv=none;
	b=Hq1CBEhliDWUzw9Dm1R89wsLzCVY2gN09/d9urlE/jNW1u0nbG5dkXWGN4/vxp2T6eOqK9
	jVPB/Xn+qzU73dx4vqg/44djnKItt5VJ3dlrOeqdkf3DZmeuWeLUtvjbeaPIzuBu+N2iRp
	Zmqw/5ydCgrDdBI0Y+n5cbHrxGYJEM4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31E5B441F1;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D48C2BCAF;
	Thu,  5 Mar 2026 05:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689167;
	bh=5/X4eJG+KDqPgy0/cAl7n9bW0ZJjnLYl+8/7GajTl5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYMSt3OKRm2Q/erGqug9bf8DAHBkt2DL6zzKTcvHoWaBbfOocX3WX97d8kmNAHvuj
	 lLoWNXUswuN59Y1esfNNeV4yrTPWR1gJWAhzsiogLPiRb7cYgJsa0a8cxarnHHbc5Z
	 O9Jvv+IAcfAMGv2vrfiFhaKYyRKQy2vqPJgPA5R/dq7wzn8kivgL0Nvgm169rAY1B4
	 QR7wm4t9G62/zAEZ3Jvw0qskqM1DB07SaGEn7LLEYo2Oee3Rl+gYby2fH97hbsrCuZ
	 M9hABnGurlCM4qF5vldHcdy8si3mBsJsDRSoUm1XA31uivM8kD8JK7cYPPfF2HiTpq
	 nbnb4BEAnGaOg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/5] mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
Date: Wed,  4 Mar 2026 21:39:14 -0800
Message-ID: <20260305053918.83786-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305053918.83786-1-sj@kernel.org>
References: <20260305053918.83786-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0893840005
X-Stat-Signature: fc5i467drf3ix6uha8bc3abgq15ude44
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772689167-590784
X-HE-Meta: U2FsdGVkX18kVt2KFPyuXv70PEpGIUml0S8OjEOK+Qpl/X7hVmZCipxANxyO7BF0p68iLJFNMv3/e8kMl8N1AhKyMMrPkLQAa2Ph4KLgdhbUGWABvtqoHn7SITea0JR8yz6ZrrYOEX4fhWQgtS8lYSvjAlbmlpzUNTti3xb27N+taVIDNCB/KwV4PYas7KdNeB8AFGGZGT9iUeRoWNNuQTGIdCVRn/aX1eUbTP8oFVkvYmCcTVouvAEHeP6y+mncxVJqkPz3ooQZnh7XVI2oJtuqVCbpNp2dg0D1x0N1a3wRSXtDpCu66ruNvRGLUF88X5IJ3J5YR+kOZl0jc5ZnMXxiyG1GfwqKqWGY4qWqNa7fqPbjVmECZ7hxV8ehFjp9IW5MWQ2apHAc0Yl5hH1rlM7K4sFE9gNnQ/zdpY9orfZEmnnQ+pc+Cx+cN8TaoLsdZTXNYN3D+yiGU1exA5WdPlbwj0WqlbLjAdXMhA51GYtr7dZOS8yqYYMZhXqQBhRJ5OvnIpIcXOG5RlUfDIIgfhk2Djk3AKg2zczVDs/85xL5XaM8UoMiZIxsRs8iXokDZrpY2n4zf9prWKNl4z49ijjhpcn/8xcyIaM+/fPbdw9aq5TcYM+gMBZj6BQHl20IVdi16pPswlOEriTJ0wP5CJVAhh0xWFo1AYNv97ilbBjPi3F73e1ERc5C1SDw21PTUd0xIUhBPfvtaPXW3J7uGQ1D18QjJitqM8gKL90lvSCdKMpYBYOAxKra5McwoxEA7BT2993UYvBXdLQ2r0ousdDGCNNEj6O8W0/AqjM9JvVffW83xhsSY8QNsClefQLxBiFeZuLJQxDEkArZsIad9Sf6MQqRq6kyB2lPh1kCReUzA0UcxgtZCZQnj3wE0aurBDTbNHhdVkRnaoMeEHp7Sjh5trwCjymLG3CtR+D2E6EvFt8S/sBN9mLjKFaYBYto68af+u5MblFnecimjmx
 sH4WdvQg
 VT1x2yiiCzg0IruUjYbS3KK3Pzb5WLP5TWFMNxFmlm8tSC1eXxMveAlnAvTZL2EWOTd3ZOv4j5u5TI5iV0gIO5Lj+5yaNpHKsJ/ylv987ltTB2pB2u45ptfJNvj7kPKN9Mlw19Bi4/zKHp4gu46vHIwb00mMqpcnnZsgbR6VIRlUCgZoPgrPpqKl+WmSRjnlsFtVTXwMUaq3+iGVFG0cAgP3PIP+XcY4NlmrdS8aUS13k+VWMLv7ftSNFFJqt0zmonYJF4eCuoXKXVPXXEnGZAaZM+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_find_biggest_system_ram() sets an 'unsigned long' variable with
'resource_size_t' value.  This is fundamentally wrong.  On environments
such as ARM 32 bit machines having LPAE (Large Physical Address
Extensions), which DAMON supports, the size of 'unsigned long' may be
smaller than that of 'resource_size_t'.  It is safe, though, since we
restrict the walk to be done only up to ULONG_MAX.

DAMON supports the address size gap using 'addr_unit'.  We didn't add
the support to the function, just to make the initial support change
small.  Now the support is reasonably settled.  This kind of gap is only
making the code inconsistent and easy to be confused.  Add the support
of 'addr_unit' to the function, by letting callers pass the 'addr_unit'
and handling it in the function.  All callers are passing 'addr_unit' 1,
though, to keep the old behavior.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index db388d05cac3f..38c7a919f9bb2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3052,31 +3052,44 @@ static int kdamond_fn(void *data)
 
 static int walk_system_ram(struct resource *res, void *arg)
 {
-	struct damon_addr_range *a = arg;
+	struct resource *a = arg;
 
-	if (a->end - a->start < resource_size(res)) {
+	if (resource_size(a) < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end + 1;
+		a->end = res->end;
 	}
 	return 0;
 }
 
+static unsigned long damon_res_to_core_addr(resource_size_t ra,
+		unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(ra, addr_unit);
+	return ra / addr_unit;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
  */
 static bool damon_find_biggest_system_ram(unsigned long *start,
-						unsigned long *end)
+		unsigned long *end, unsigned long addr_unit)
 
 {
-	struct damon_addr_range arg = {};
+	struct resource res = {};
 
-	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
-	if (arg.end <= arg.start)
+	walk_system_ram_res(0, -1, &res, walk_system_ram);
+	if (res.end < res.start)
 		return false;
 
-	*start = arg.start;
-	*end = arg.end;
+	*start = damon_res_to_core_addr(res.start, addr_unit);
+	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
 	return true;
 }
 
@@ -3106,7 +3119,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end))
+		!damon_find_biggest_system_ram(start, end, 1))
 		return -EINVAL;
 
 	addr_range.start = *start;
-- 
2.47.3

