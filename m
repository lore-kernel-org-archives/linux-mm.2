Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0008C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942B16B00CC; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E32A6B00D5; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9B56B00D0; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 467D36B00D0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:03:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE5D5C03C5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:45 +0000 (UTC)
X-FDA: 85170653610.03.B6D026B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 446A840002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:03:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LodVKFzm;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397424;
	b=RTCBZz55gQQQ1ZWQACkpSWph0x/dsZ4FcZUxeEY6XslZRxleLbYqNAIXoM/sLozdRVulRR
	zPwR5xAHyGCfMUNQRKVE8GJj/EwUHW/gAjHEvs/saieI3UZlSVSHaNB5qxEk3MddZv8jz2
	yCW2I8NIn8gX9HW2NrfLunp2iE5p9XM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LodVKFzm;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+KFNc38yAs5cF8y2PPkR2gfi2v/4V0wSG+v466VkTs=;
	b=4obPzniztW6x2c43uXUAsZjAPZEkhIj3jkcnHz9ZdOHhkjf+znrezeaw4EBPw6IbbmwZqi
	ugI4y6nSb8LkP7Y7+kzZQ9NCn84u+7okxOtuUgqEiSfsfmGn7I5bj9redl2ryhsvf1BOvu
	xTUYtX3R6ugliv/k4G6L5LB2WZLio8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3A8043E9A;
	Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611081F00A3A;
	Thu,  3 Sep 2026 01:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397423;
	bh=a+KFNc38yAs5cF8y2PPkR2gfi2v/4V0wSG+v466VkTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LodVKFzm7cPA/XKyLRrziPacDwGJLlxAjosgz7vkLzndAd43UwGSSmeTy3nRv2M7/
	 P6Lstm9ApfK3wchi1TzvLIWDnUw4W2iM5ybBascq3HepMB8FEbtGlopObj8r9LweMG
	 LaSH7hLz0s1lSfUaTG+bgYyPiZFhCuyvAOGGcRSgOVvq+0OkH42gIyECD34Uzw6Xvx
	 +Q2MT8DiCFKURE+bUs4iEZnP9Ce3aFeFd06bLbXhJe31queYCqZM0u7jc1ZFAt/He+
	 vO+lzpR02gxrpahg8y4YHOto7X8/N5J72vykyibw7X9QMZeneaPHd2OrjbT1AERYWu
	 UQjWF0VZiOpJA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] mm/damon/lru_sort: remove unnecessary damon_call() param validation
Date: Wed,  2 Sep 2026 18:03:33 -0700
Message-ID: <20260903010334.93622-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010334.93622-1-sj@kernel.org>
References: <20260903010334.93622-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 446A840002
X-Stat-Signature: skh9f33dcx84t5y87e17kwiu4hyhx35g
X-HE-Tag: 1788397424-845946
X-HE-Meta: U2FsdGVkX18TmorYN+cMBdC5H1z8oAJgKRqzQczciOP9E1SlRtOqTfSZTAng7bnB4kIfUvcfuDSO34k4s2zheXiuSj1fWsHJvQ+w8vFVOudkbG5iIsRXqW8DUr0ulh7lXetqbef/eNfBY1QnaSma7D9XpWviBMfecE1UF9vvpSYLAttQeh3rnjpVvVaxCKUKVt6s4q1QXl2VTg+LYdsy5rgyaGJTt2ER4kH+5ajVraF6wrRVwzRfXH67f9p2HQplaGtXAO3BBrEjVs9OR+J3sb3KdF4bdl5/kmKmWFHHZUc+q9wDh1KliKsgO67vZkTP/w+3QTdmZ2E94TKHe6foGZ2phgzTCanrFn6Q7F+Ct0qspMJ/xW8p1r6Fl47vJGYOpfoaXraexBeYgwBTWzCkbJqPZHJKKcnqn6vEJJU70H/M4JFh9PJm3z8O9cc2+XvzBmPs9F4CrXYXQNWuvRg/bkcHek+y1YsasQjbd01FUGldHEuhcP/4kH/sBh9FKECwAKFaTnDWbvpbNUA+Iw5M2zIg+NVBG0ifRBVdeZcoT/gQ+7IKqmn0wTRWkWvNlQQ972K7U25/ObjqtJzJz9U3b9FHBYKTBG9882eUL+hEsU1MrbCBld4M+6GvYXMxODKXJarAhlNMVPf+hiz5msHkIj5d2dldkSbLINbc5F4Fjv7p49A0p7FOAX8cROcrIaGkeq37h+haur6s76qwKKna4uXPScef9giLP03C3+es5LPwnKokAH/DBPNgOYk6a5U/fLU7CGVl7HBDeiRkFRb/0PfNTAyEzj3bPKtPxjs8P4Y2V2Sjr3JkiIFkSGaZJvf9HvG7c/lE+W17WmzNhE24ytq4zxAjGz3ZBhsHOmxYKG+3sgesBwKQlOKl6VciakVmKXioRTRpfwx39psxwDjgPE2Q2il8AcVYqEF9ykBJy+1D+PLsxkMx0d4OX5zaMx4fo31QzOIODUD+x6UCPK6
 5btkqn93
 IpqILhFrNdcGXRwPTm/ISfef1+1r1QZM4Eb1nD+nxoHZwjng5O+lMpFVn9gr4LeHcK//Gfe+n1uEF+PYPPWsm4ychX9IVKOj/uYJ31nGM2te/hnAVuM6ezKsUgJ6w5jvc53m2W6IV4Mm+8N7wWDRRncYZXn/GJspODGpSsgAxUbJHOMksVubXMpD0FWFalcI6Xz3Wu9Zr/8OSphN3rbWPpYNj4oB8DhogE90acuDxq1PtEy6nKtSypmJxKbyOFxsr6gwFTdMb/2/oShWxh8xYgC5k+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT avoids passing NULL or unstarted damon_ctx to
damon_call() with its own validation.  The validation is no longer
needed, because the DAMON core layer now handles the corner cases
itself.  Remove the unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index bd847829a9907..f25ee7326e87c 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -346,8 +346,6 @@ static int damon_lru_sort_commit_inputs_fn(void *arg)
 	return damon_lru_sort_apply_parameters();
 }
 
-static bool damon_lru_sort_damon_has_started;
-
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -368,10 +366,6 @@ static int damon_lru_sort_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_lru_sort_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -422,8 +416,6 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_lru_sort_damon_has_started)
-		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

