Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51353C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5FB6B00BC; Sat,  4 Jul 2026 14:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384D66B00C5; Sat,  4 Jul 2026 14:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6E56B00BC; Sat,  4 Jul 2026 14:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB28C6B00C0
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6279E12034B
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:50 +0000 (UTC)
X-FDA: 84951887580.18.5C57A16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC5D140008
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5ZJUxpW;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/v/dE+FlmtwJgj5yRteS0MOxCozSQuxW5M8Uj1RzSo=;
	b=WDIz5Qwu+vLWvJqO0V/9GmkoTcH7+LKMvP3tJlX7sFT3w1PnmPmh4StUlzKgf5Z0HwfWdF
	lcD5St3jm1eYysz7k1MBAbjBLyo9YA8leJZ1+3XcZeqpIBcuhGazA5c9vJi99CfFgb7cLo
	SFRUYzwamtloIsH392OvLtVUFg2EH4k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5ZJUxpW;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188708;
	b=5UA+1qCu8lVYYLX5LDtOZil6aEV+cTH0i/yqDRpGo7Tq46mCA5JDC17Ee59/Z967rbNkNM
	0O1yLH/VPd1AGaxXd2ybodL157WoTb120wng0mqEUsa2D6H1yw8ZnbEyBKoQVKmFcWUJP9
	63Pqm0BLpL4D2Aj5v9rU2Q7D1BKiftU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C5986001A
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D7F1F00A3F;
	Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188708;
	bh=d/v/dE+FlmtwJgj5yRteS0MOxCozSQuxW5M8Uj1RzSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5ZJUxpWz862HugfoX3aFjblmAT973RDwU1aVjQ/Q7JOJ19iIufweaC8WF5ef9w6x
	 EXlmDtjp5nwROCpEyb1pmIEOxFPCIFm1f/Ml18c4ntIBh7FF7keFtZizhdxvPluorR
	 Ih0C8Zn0dgWnCWf3zlpVzb2bGrZ8C7mDH+A5Lwrn6Wp1ngUtLm+nVUywYGi99B551o
	 iUG8qjkKnRjUYvouHuXiLhfw1NlnoHynBxwOcpjNOmiKgSty9VtVHYz6raltLA07zS
	 MvEKxcicnY28RVv+eiYgYJXY3qx69ZS7374EofmWivo+imw1wrVm4evap2Bxjfqzip
	 KZXaPwLFE/veA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/11] samples/damon/prcl: do not stop DAMON for damon_call() failure
Date: Sat,  4 Jul 2026 11:11:34 -0700
Message-ID: <20260704181135.132956-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k4azm71f5h8bpyetfebc9qfogribwcei
X-Rspamd-Queue-Id: CC5D140008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783188708-642364
X-HE-Meta: U2FsdGVkX18mOlev1+2lKjgm/QNKq3dPavYKiQ2TCWTBYLcz20aMQM7XYnBfxrTOVrwU36CBIh3f4HPQaR0XMYDoB+aCpkq4qQq/xWTxayBgVN4XDNeWNFocdG5PpOzCtlEWWywTt93kaqqnomiGXHu2PWAAEqRXSdW14NpxGOSwoiQ6AYaagbo0F3FxLCM1sNW1Otnu+mLOBP8H2YFqUDs3u7iYmo4yhojXqsIBHUCDOSezQFpqi2IkMZc+zgzK5faGKkh+j5BNO2LhcCLsexwDRyB5k0DGonjMT2Qb/u5ea8dk49xmJKSlPh7LVvEvmJ2S//hYcYtF2YNJB4W4lwNGkNvkKrY1gx7KsIlY1jxbOrGobvhCo6vRf1hBTFfeuU9DflUirb3R2604q/3bInaPZ86Lb0iFWscspo9pdmp04nyjNL23If8pTIclzE/poad/wsqQ+q0ZxVr1QLRiolLUfSpCQGjR/R4tN5raYW0zg6VetQfNo5p54dNsMerKMpvaIz3+9ST6a61/sKXheRz+wJBxWp2pMIkpw/yPUOGl+rnRU+zGgb4tVgARP50DDcdlDGVpUnO9JOUPkjQyrBqGsAV2eV/qzDtrDjTY7aMRFWL31FStB9cRTeUidn6CtlWc08CNCg8ziVEslIZ7EhzUpY0+TD05NDtkPeIw/s8s2OxLgv03Ivjo9j5uu/sMYcGGrB0OifFPZ0bHixHBlC5/uvM5jTg+TEooMVVgkfQDviw4nvGz2X1wmRsNJEn0UodZchLZXjzcJYuG2ugd1gwAXdS74AMEXapaWyyYPk4V+LUKPLKAQBbiwkadDNksumix2YVo5fiQE1btS+0h8+DwvtUi9fdZ+HTsUTJspPCmlSOvKcs7pQ3zkWXkzkr8eSPq06DetGJBsqfewUycb8305dQF5BW6oTBjoSBLmL+nxdoDnDV48/H0KNH6WokI2PHXo3gfuDWPF5LqNQO
 jLEhIoId
 NvvzEZvItZvVEdA2umgeg1j/8lTNGTCumfQ5TJz4eLyTmTrbzxUU6PepFWfIslB5fdGyCMCv4woBgJMJZBbF9mmBx0sxQV1b+NNboiiUuu1mbJJBeIHR5KFw6UK4bsfKws0Fl662FnV2h8YJDHI+/bVPuN85h3k16p/Z3c/XCscIOauXze+4GXNc/14WGxCz/OJlvtHka4Q8qXUqP8/xHc69YFNDDbFwhRe/7Q+oVuIDmC4kYWEu+DpF/OUfLtFVcDBjPMwZwDpyq//tDDicd/tDyPQ7Soj1rXWNJyf65SaLUumVlI8aemJuEL37he2zsDrdthAqBbre33Q3Xi2rJyVDxnnUnnEFoqak0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() failure was causing the context to be stopped, but
asynchronously by the kdamond thread.  To handle the race,   the caller
had to stop the context.  damon_call() is updated to do the stop on its
own.  Remove the damon_stop() call from the damon_call() error handling.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/prcl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index edeae145c4a8a..842099bd62286 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -113,10 +113,8 @@ static int damon_sample_prcl_start(void)
 
 	repeat_call_control.data = ctx;
 	err = damon_call(ctx, &repeat_call_control);
-	if (err) {
-		damon_stop(&ctx, 1);
+	if (err)
 		damon_destroy_ctx(ctx);
-	}
 	return err;
 }
 
-- 
2.47.3

