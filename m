Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD841C624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D116B00AA; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDAE6B00B2; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57236B00B3; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B34D06B00AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:07:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F6C3160392
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:32 +0000 (UTC)
X-FDA: 85170663144.05.2F2EF6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84CDA16000D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFpq7ydF;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397650;
	b=gUyAqv8u5EVvg9v5i3GtVNrN8R/sQVLq8Wa2H+IVq3MH+IhdAV0nAluPArulIvdU8y90ec
	a5lnUzDfc39/1R6oiroqUAf5zsAbS2MQhvUCHxtCrLe4Uy/YDsP9gr+Fvkqva9y1FC/eM+
	nBVXSylRApxBFlcpWioWtuzgIp9i/20=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFpq7ydF;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ydKZfv20XDA9Yk9OoF1itUqqkZNlBOcLwEjFDoPApk=;
	b=Nvpcyl6NFvff6TUtZtaPmu2FK2ZqwUUdPUGpokRPuCtrtdSb4lzUZ9F2XxCL+mcOo2TJXM
	zXzFZQVjxxxUlVw2v0ZTxCiqTV/DuBDWF6fICUR7GBQUxdm5leapyPAX0QKut3yIwrzpeT
	/vLBqACx/hITCDoPOgn5imiitTEUYc4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C626600D4;
	Thu,  3 Sep 2026 01:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24981F00A3D;
	Thu,  3 Sep 2026 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397649;
	bh=3ydKZfv20XDA9Yk9OoF1itUqqkZNlBOcLwEjFDoPApk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFpq7ydFn1Minqtp55XyMjj3pSEJhDIwAj7dFNpnIob9o750wJrG+nUBvaCfKCnfU
	 5PEXUWzW0VPiL+oNaRTPewGgzudX0SCkoWkyA2SO9E/Fhr5UM9qucdg0QhxlJ+0Q5K
	 YHRSI4JdVUBeeu1rkiQ2c8+dCKR1YST6BwlZEg/1rpyAm0p8dJNnWH2nHorKbvfyEJ
	 5d8VBJmmH1njt2/hlqUWUGQVAKQ8YKWNZYL4Iqe1STd6rNL/O5jWv2cg6mZUnrRvK8
	 qr78Pk0qmA/vDx91IqIwpDEyytAZdI1O0KuOYo0e4FcBh9Z3q0NRxTSC6/uDB2D9Uk
	 WhaOzAM2qvH6A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
Date: Wed,  2 Sep 2026 18:07:20 -0700
Message-ID: <20260903010722.94244-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903010722.94244-1-sj@kernel.org>
References: <20260903010722.94244-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84CDA16000D
X-Stat-Signature: 5zpiansmjd17ozz5mzab7wru9b9ueb5t
X-Rspam-User: 
X-HE-Tag: 1788397650-894493
X-HE-Meta: U2FsdGVkX19bwnoAF2b8yk2FZxWux+Ul2Dn72Dybk35dVDe0DZAuyqHzJMOjuBVueYVDx9R4ABBBETJyX8MbLL69i3owmTmUeHbPdHFy7BorTd9HbwOifsvw7IF7GJrcD2zq0aXr0xWnEhnr2VTFw7pE4Mw8jaoGGDYtCr8yMhHZjTIx2xtXq72n3W1fxA9wgqrSGioeB9WiStRAXyag2UfPtxUFeoU6pqkZhHlqEA66UBTQ+5PCsW0uqFqYMtakyvjMsohdTkSo1RGQrfwZyqHwlvhMdFOee0MPve0m0BUs75q0rQMKIX2EcT2A1d2073rtNspBZNp/gcuOOlnKAmUw4cC25psBV6S1CH6IX2RAME19ae6s8rm8/tz4FrgHGbIvQhkp54jq0011/kMAF/8tVDQ6D9NFmciW6qvX6fsFem8qNjmAUWMTS3S0+jxOSu8VkP9RavEqBUXziKq8MVmsn0Z3ZG+1f8hOsxqLpZqtVMPmLAoaj7lIP4v6jlJ8oTmaWidbV4vsi3YvwY1lNfLVYfHa+9Z6x702mNV2z8yXNMCjGGJ84Bd9jddkHzQQDmBOHUojDC0YByizo0/eR4L0khu58duFM0yOtd+C9aVTZ7DyDyzhxWhw7fbLQPPhvA/7oYeScy91qF9AJU1iFGHRe2DrbiW2ZcnKzTiJlLCAn8f788vJDrl6d5GSKM2UkCav0nImbkc6hR9lrZ2um1eOQiu7qfy7b4039w+HR20BpxIrJ8bysxcKf5zp7lvHAC5isB+QLQ5VIbG2XKHqSxJNeDicFPSftrtxHUAk4ShU4/DA9f5rqmmJmkU7aLz/AL4rwhDAfX7+dj+ybal0NOG98p3Sj8o2yKIxhD7Mcbmkr1R/LG9Ld4ppcj1HhjE8gy4kFWmMkS62Y745fxTduF003OTThJPGsESZxtSYYTdaFMcSVDGpvcy+w/tP+ttaxKTTh28WdOr8AKalucq
 RJC/pF37
 iyjO0BAohWyd9KkEcriQDdoEMi7H0l7X/cHv05X4fIAAQZAmf7RlZHX7K5ZnMrB//o00e/gW3A9DW9BQ6iwh19MwTKku8HOXVXZlRIm1oTJj3Orx5SshbSBjPzLZhsI73AgCaXvBTlu/CIEyWX0aCcbdiccbp8xi1csMVHkDxtfXroINnwYfGE19/HOISwP7/zMPuagNt/ZnLoNDhzvGL49TZb9QLiSyOrlpZKMlABUfop0cTOYrHbTo0PBncrWotNikS9hKmdq0CrwBedQnEb7DuBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 06befa61c427e74319781e6f35a364cfc32dbae8.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero
target_value.  The corner case handling in DAMON_LRU_SORT is hence no
more needed.  Remove it.

Note that this slightly changes the user behavior.  It still disallows
active_mem_bp of 10,002.  But now it allows other >10,000 active_mem_bp
values. Setting >10,000 active_mem_bp makes not much sense.  But it
doesn't cause critical problems such as memory leak or crash, either.
Arguably that doesn't deserve additional code complexity.  Just allow
it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index f25ee7326e87c..ad8e86dd3a93e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -233,8 +233,6 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 
 	if (!active_mem_bp)
 		return 0;
-	if (10000 < active_mem_bp)
-		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
-- 
2.47.3

