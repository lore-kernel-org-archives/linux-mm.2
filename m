Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3691077604
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C016B02D5; Wed, 18 Mar 2026 14:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15686B02D6; Wed, 18 Mar 2026 14:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B045F6B02D7; Wed, 18 Mar 2026 14:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1EE6B02D5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:40:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 372FD1BD70
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:40:17 +0000 (UTC)
X-FDA: 84560048874.30.0E4E9DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB4FD1C0013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:40:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBznw79N;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773859215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yHJzwltQNdeSeKsW9c3OXnlxWq0c0DREDTQEe0Y0haE=;
	b=6EPnmC2nKBDUyXmN9wDGNHisyqZtzCjk7ZLh7rrbGW48xpdm5Js7Nxm1Ocu7SeSIgfIStd
	iygHdVww70KS6hJKlQZYjfmeYCYXkR6rOs5zjPE0CMa+FqKywQHrnS7/WPc9ZYZYHAebhJ
	WdrZKrlS/0aKGq2EQQOjEA28qlsOTkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773859215; a=rsa-sha256;
	cv=none;
	b=3qsihEF5ndQbt06M+1kU+sdx22XR3uCBG0rn0bh2M390AL+gRelJ1JRZi2ZE76qe9pa9Vi
	u4Ezmf2gULpjiSkY3ABB70O/rO3Qg73rPTwb1SiG8DKZtUcU45JdwDVRi2xYPXN3kGh+wO
	Yc/vhA2xHo2iVtsb5bhExp1G6itlJl8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KBznw79N;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C53E60103;
	Wed, 18 Mar 2026 18:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07C6C19421;
	Wed, 18 Mar 2026 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773859214;
	bh=4eaO4k7qDAfhmNFlz4m0Z+1y1kj9od+IKNtEkD0bc2U=;
	h=From:To:Cc:Subject:Date:From;
	b=KBznw79NJWQf505ci3L/JWi/WsMsWPBTjpFNIDsPRY9b3t6cXgT4Jm/hiD7rRqvNZ
	 cknAgZkLDGpUofaa/vzpdbWnbBzdDYh0chlRKPMjphlG66jHWXOP9dMV8cAsa4/tiL
	 rVvA/+UY1qieVwLTTuacCsKdzQDfT+XSW5VW63UNtpF8iBy+IPIHvcmVIUM/usZWLA
	 tLPFgzzxilqNnMzfSvgakuD9M3PE6GjtXJ8kuICt52lX36oFB+Yzk6uZ9vJ5xU6eRC
	 R0yvZUWWAdTzhib8XXwAE1AKMr/PcDyKoN8eeXGSGaKVh/eHei5oMKJ1JA2Ms4JAgs
	 0rUXE/4v7X0rg==
From: Kees Cook <kees@kernel.org>
To: linux-mm@kvack.org,
	Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] fs/tests: exec: Remove bad test vector
Date: Wed, 18 Mar 2026 11:40:13 -0700
Message-Id: <20260318184009.work.411-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1192; i=kees@kernel.org; h=from:subject:message-id; bh=4eaO4k7qDAfhmNFlz4m0Z+1y1kj9od+IKNtEkD0bc2U=; b=owGbwMvMwCVmps19z/KJym7G02pJDJm7PvZkOeVsPvjERCFu66m1x+6+2vhnc22d9fQ/m9fW/ 1eoexW0vaOUhUGMi0FWTJElyM49zsXjbXu4+1xFmDmsTCBDGLg4BWAi108y/GZbLuaaURM5fWPd rpQmni1HJ9aUpNfHF4YZyM75MOPhs9uMDN3eG7c1LLr+9GBVXNIJla4yy81bO88cdYrfvcR0xkW faFYA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gonjwkpcqgfu5dcu6h43mt36jshyc9eu
X-Rspamd-Queue-Id: CB4FD1C0013
X-Rspamd-Server: rspam03
X-HE-Tag: 1773859215-158682
X-HE-Meta: U2FsdGVkX19HDK3fN4KrCV7hf3DT2s6PyUgV/EoaWbP56bJZGwm1Qp6mqAVSms/MRR26ZUwyvvrLEyNSprm6DSAzOqDZn1GCu2jdhpkZH4/DNdyFzjAJgmbFKc6p96i0wfsZS3OaWejuo7Xjh8mawH/2heX5pcrJA2Wypnn4CkzRZnqmTZgdaDHZ6F3uoMANvvWeJjV97EbPcPPg93/WtD2eRCdyS6ZyJZUdQbmOx23vkTYUArPSBj6ipghAciYCnUpLnYE+ctxjvGmq5tE+KEU1KmkTcCT26LPhEWpe3su1KNP1oBDEzzmv83fvAQrKUt4wqRnfvD7lSmbXQcdlYDrzVJIbDTUQFRFH78jPVEnsa5cirBDJ97il+ZhAtafvRpWR9eyw26dlECGxQbq0YpdjEwimqxDLsmFlGHTOzEW3SmBMYUgoKi9cnfZjPiTy7c2BGzH51DHhaJ1ETHxp6Km0OpJryURzP93sLizxAcZZIn14seD1zuU17SRbmL9aiJ4BCd+WK9LdwqkzstIlOHWm/j706lPm5s5WImgR+HKBPntVhK7HYWkZRrJRPWqByo11fASCogx3jhWC/tsc6I0/qnL5Li2uoaw3cwaS7LJdx1nlcJf9uATILB/y9R1YIVLE66ye+Fw1C/jcUsF4+wQkeXAunku9nrviUhoX2abuD4C80UWn7EULNcFwDphcB6fCwYLogWnXz9oDGCBbTjLJ511MAg3Hf4dnwFn7DeQ1V9QB2Q82ucirQeiDosc3X7dLekITYpCKUxfwYD5ZlTBHOxXAWCZ1ZWdNHtPQqKGDmAAbzwRxFLZvUEA2r6PH89EdrybP9mvFa3BGJpLyDjFxEHV9eZ/mq3/9lMeIWjWhBgCPd5/gYzn4CmIPpMwNoxGNBiKZ2weOLb83MujcgRkd8VYJ3iQpB5y5uGTynIYJ7HDkzfzIKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop an unusable test in the bprm stack limits.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net
Fixes: 60371f43e56b ("exec: Add KUnit test for bprm_stack_limits()")
Signed-off-by: Kees Cook <kees@kernel.org>
---
 fs/tests/exec_kunit.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
index f412d1a0f6bb..1c32cac098cf 100644
--- a/fs/tests/exec_kunit.c
+++ b/fs/tests/exec_kunit.c
@@ -94,9 +94,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3 + sizeof(void *)),
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 *  + sizeof(void *)),
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-- 
2.34.1


