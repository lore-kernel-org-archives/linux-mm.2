Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F5CCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781306B0088; Thu, 11 Jun 2026 08:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731B36B008C; Thu, 11 Jun 2026 08:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6481C6B0092; Thu, 11 Jun 2026 08:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F72F6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:57:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D49DD4064B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:57:11 +0000 (UTC)
X-FDA: 84867632262.27.91B17FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5D1084000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:57:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nNazy/7c";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=geNwV4XsDcpW2nLuNQos/NDgwcU9+p+h0p71pBEkqdc=;
	b=uxf7MBXClWDzD+6FifbmE4wZwivQ1vM8e6IJZE+6cTxYjQBsX0/ED6oxj0I+UA+RDprsXG
	Z0uP5gAziiXDH8ZSwg6/lD/PdYTMyIqQLKe2nRNik7LvQ121381Anypqbi55olVPfy6AA5
	aSCpZxKFX4WWjX8C8GRgH7V9VrnXBww=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nNazy/7c";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182630;
	b=6DAxkNhRmTMCDLzc4JDzGdgPs+mHyr8L21bCDbqmGKyJLBt/5H0knEGkH/kvboc7UMeY4J
	W/w725ShiKuwa8ZANRhbzN6KTnxmRqx2+4ac0X1rAYqo9thPS5NxO9Kkx8hVPG/4TtnDZw
	a3W4tzJ1gFHwh12YUOEk3UOxeY7gt7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD9546001A;
	Thu, 11 Jun 2026 12:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E5C1F00893;
	Thu, 11 Jun 2026 12:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781182629;
	bh=geNwV4XsDcpW2nLuNQos/NDgwcU9+p+h0p71pBEkqdc=;
	h=From:To:Cc:Subject:Date;
	b=nNazy/7cpWAhMsGMZlG/ZznSRm6J7bfXp371Q8zmoJkEJWAokjfzD9k8J+LG7tk2b
	 N2o9B//dFurcQjRQqqjjwo8tXElpWAt1rrbfIM8+507W8El7JAA0VnzgkVqfOFPK//
	 OvRLWiVMeOX0O94sVIHJEtTGmE1I+T/cw3XruxlZlKAkjovqHp87erfzqmCveCuZQ4
	 SBHHCR+55dw4RLRS5eE+WHgizUoTrpUE9rp387H/ZNalmljdajI+O4zLkIJ5vd461t
	 GVrDtLHenw8CNVJ3Yx73uhq4C3/yrX+9jrDWqp0UBo4QHwP/f4eK8ZhQ0tIHEMWhI3
	 B34t1OZ76bnnA==
From: Arnd Bergmann <arnd@kernel.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] mm/damon/core: reduce kernel stack usage
Date: Thu, 11 Jun 2026 14:56:57 +0200
Message-Id: <20260611125704.3386176-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D1084000A
X-Rspam-User: 
X-Stat-Signature: 47m9e5dir5sn89w8hxkpeh6mp1roeqye
X-Rspamd-Server: rspam09
X-HE-Tag: 1781182630-548301
X-HE-Meta: U2FsdGVkX1/EnKYoEYF7c882viTBdyAXP6TKxH0aKywPpGac4x0hbIyTvdM0+WCwA3YE7MmKDVJa0qJuZgS0ztJMyGiJ9oi+c6Kj1RQrlXAysJr9UPJPvAtju5FcaKrJSlOisudopks8O50w2vNtz7pnqBMnVXSLRHoCTCNW1jBoHokt2KPzNMtptdmL7bPWHGNmc6dsgt5AYtu/aWw4gCvbReuFtllX38NCio0WvjdDvRAvbb0ANIFR/CZsQHMgtookznyyG8AffUMUPmaVkSm88k2DVirEpRlwQFgqdxKwN2xxALOnY4QoqcxvoK6wejAUt/NH8K3JfPeO4LRevokpKcI/Oby7KuV8Xj2Bsspr4jkJbzQ+aKfvzZRC4x+4+YvlFXbCFX5LPBo1nUuNTFVJFE8rgGqM2Nj4aNpkAKVaJmVZQYV/8n//iDy6wvLahSF3GeGhmolRZIfv1fs+KdBzGJ0h75nLxYLZxSsrqW2XVWaEA364Vhlw6Tz64eR+yLQTLUumZDsPAXOHNDZzSJgYauPAWuNMNuImirxV0Jn4Dkr8McgsRNinOo/GS6Cm8/zokv0BYof1YlRxzhAlxFT1b/FUmyrrBmWRFBvxfC4O0ytuiwgFTZCqGup9kdhKPeMi6OZpNgGZTfAX+Jr7pqT85DwO5H1KWtZE5jup23bSQfoZQcmQpIxe8zQcitp7nCzFElyPCPlsEAiSBhDVl6jlO5rg1/S7VEBv7EkBz/e9jwGJuz6jd56s4VcS9eZYmSfC5d6SdO0SGAo6X1Wkj7Eu42jK+hW6ahl0BHMzOIWJF/IdL7xLHH4ANZAT65tcir2Dyu7b4aaB4fmEWvXZmO9FAObbnXIHJB64SiZO3suViKPmZvk4LAZY0TPT2WXPBH/JI+KMXVVLNMrZHgU3Oj2ReXlYU2Mt/YUVjxKX02nw5VgG7UOnrZwFTPbITJkKB3dTZzLajfAyQfpyrcP
 4Ma8+btD
 p6ebh6fm0ScnCo2W0nGk+TtFFDwl9GFVcSBkd8iHeLqSgSZnfVmoviCkotYTmVspWzYd8zQ45wJr1RRHWzoQGp2RJGcXqcbdJb0uoZOyxRUBU+L/Xuor92ksjAaojeVySJypeSyBKSj3UyOVVQmowm49Q7Zz3ux5/YGJHMXiE1vUpMdA3K7MIAVxKRplU5e1d2Qxe0fMzMFb92XznWoX+xlqQXlmQVnARQj5JdYihcAEWSSgR4qOZLBX3iiL/v8yqvEtPM11zIGyyhKiJx6YriMQTS2hXy5uvfHNHD7I8NyhXkEmLW3Yi8N0mJwnE1SjSpYO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

The main thread function has recently grown to the point of
exceeding stack frame size warning limits in some configurations.
This is what I hit on s390 with clang and CONFIG_KASAN:

mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
 3440 | static int kdamond_fn(struct damon_ctx *ctx)

The largest stack usage here is inside of the kdamond_tune_intervals(),
so by marking that one as noinline_for_stack, the functions individually
stay below the warning limit, though kdamond_fn() itself still uses
hundreds of kilobytes for some reason.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 265d51ade25b..69f38c48ac08 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2002,7 +2002,7 @@ static unsigned long damon_get_intervals_adaptation_bp(struct damon_ctx *c)
 	return adaptation_bp;
 }
 
-static void kdamond_tune_intervals(struct damon_ctx *c)
+static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 {
 	unsigned long adaptation_bp;
 	struct damon_attrs new_attrs;
-- 
2.39.5


