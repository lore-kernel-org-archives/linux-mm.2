Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D92C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F136B00D8; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1456B00DB; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C836B00DC; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB6C6B00D8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29C86168A74
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:44 +0000 (UTC)
X-FDA: 84958527528.20.E4E801B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9D4EC100013
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EYnsi/7l";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJKL9EayamVjhe1Npp/S+XhWMj93f4Odi2+yyGbNAgU=;
	b=L7DdWoNlZv/IJgE92SM88laSJAMY7uMh9t7FKAbzqs76oVZSk5A07uQF1d7HIxw+BLF29G
	lUszzzOPGTxwjTOjmYCDqBCj2RoJKh6hBonAVIoF8SFWpHeLM6d8c52XylcFaCpFLrW70I
	yQ6RUCja+lRq8uxRRokLkAxq9dpk7KA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EYnsi/7l";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346802;
	b=R/E4jook/qkKsLB849ptvRrBVyhxw2nkVC1JIeprvPIx2ow44QJl8Rng0a5M7ByUxWbb/E
	JJf4O0JKJsCfvlXsdIPptKIasybTA3IPQ9phe5Dh6i92FrHdyAOdH5lkCzOzBVfCKYRJEU
	a1Z3iePgVumfM+Mp8y1d31F0M9liYmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ACEC600C3;
	Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5631F00A3E;
	Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346802;
	bh=uJKL9EayamVjhe1Npp/S+XhWMj93f4Odi2+yyGbNAgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYnsi/7lQZk75h0SV8wYhQTZqr4/UE/7hSj79P8G8kQAW5S3GW5LySUcks8jymzal
	 cUVUlAA1tSa2+9qEXoJOXe7yT9ACOgCt6r+pCKrEFP3AW/fIug80/CUbo70UrzrCHV
	 SHN8J3xk1dqDyWJtTak5Umb8nlzrsJydNrE7iuwMfnfr5wQFlP/ewtXE+zFQfjgk94
	 sukhgPZ0kc8Kv1xOVtmxR6d3QpwMFKN2Qd9sKe03qQyzkUDRqHs0kyRkvuPEUWNr3Q
	 aJZq9cX0t5wTiMlGCeUFf//57E9xMC0K2m0KjyfdxnAvqMSmgKQ7wXQ03rEChD3XD0
	 EsJg21Sa1W2Dw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/11] samples/damon/wsse: do not stop ctx for damon_call() failure
Date: Mon,  6 Jul 2026 07:06:25 -0700
Message-ID: <20260706140628.87414-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D4EC100013
X-Stat-Signature: fwbfj8bufo4nr4mj4esroq7sx6ryzxuz
X-HE-Tag: 1783346802-117937
X-HE-Meta: U2FsdGVkX1+XyaK0V6K+U18gNH03AQygctGctmx6Tc2UBi+pPZWRgvi/xcAjl6C8m6gfkoBTohX5G3Ju84zYVpgr8VVo9weXrvqDR1yL7OTtvu5omjE0LYSmpJh+oK/1xAIXg66fYGN6Ez51s4vT079bn6KWY4eFmFH8Rb1FV/1LJMamdLzY0reBkJAr93mG54Hhbf7y50L71H7PpD+zC6vX2A/lx2DOjQlmRCtJuStbhc/rbC31oSMX/rhoAdFTwJ6IZgSyhJH0mZoWVpPcbn5hY+2ioYwz8B2Ij/Q5NYriPccXz4r8FuuZsXhN3yX4FYwNbANCRO7dgHZxRUTZE8RwS5VqEwtG4Y+J1Ce5QbUDUsTdcMl2e30deP4Y/m6E+4RjVIRLv5rBgHuN/ssm+EUN+QCxf2NEe8vxPAhG1jTHPpZ3GuHmWcizmfQ0CIBYmmzDDCxTJJz8yb9GB7rVzg/JIHEGUvcsyWtUna5cjRmQ9QBAh/V0WyWP8K13uqV8OokTKlo0e1k4De7FkbfrRCPqjy7eSUaUwgNKKiO+sjhuQryUUztxmMscAxjcIo8DXsZfBMVh/u267/hWX8JKiNagX3FvMATu8SBC1UEn7rSLCiJ4jrXVJCU7lnmP38kWP3/ZBL94Z0Djmm7SQmzrmd0rg+aEjxmxmrkcZXkUUI2FZxZyKrpW8UqkdTWUOkvRuHmxdZQhtcRbU5eDf597wTkESlAi/qnYy4RTJcg8tttuHlG8M4lAbZcO7G3Jon44oxz21x6ApOz/4wIzxc5/cRd+pbM6BJAZlRijFSpAVe/Sa4kEuLfqlnNqHaGVl/Mul+0sG+hxLtrM3BvSGJ9UY7JHnEfp+/GgZ2A29Apd5/LznbSm8mi5uTH4UXGV41BlYpDfJ1eToOxsTJiIfffBg5y38fzsy3q6FG6N9UVMrkNuGeBYbr/CLNXp68mq4QcBwTe6UQtIaszsprQHN8t
 A/8dV74q
 P90+8dVpuu1bnbFuzYCz67kz4g8x8y+LssjWum9Sv8QGtpLddcDa9jfpmtmgsS8w4EdjBSMShiQrqqYLCmZbrU/+SFlZXdMXjkf4gfKySX2xoHFldlCYdlLhI4/1NL+ozczC06S1WrEAySiC940+2d27bUfTkWFmnFbnr/7QLtWwkgUJ5xdj4Q7RFozBUOJTymhaVbaX+uwVy59A6m46DXq/PQWz6eHxx1bGbHQP7uNBOOwAXDgRjhSUgkkUK87uo05ijroY8GG37p3nb2Nmz2G9l5g==
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
 samples/damon/wsse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index ff5e8a890f448..37fd5da201588 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -93,10 +93,8 @@ static int damon_sample_wsse_start(void)
 	}
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

