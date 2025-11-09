Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C960FCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 18:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363988E0016; Sun,  9 Nov 2025 13:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33AEB8E0002; Sun,  9 Nov 2025 13:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B138E0016; Sun,  9 Nov 2025 13:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE528E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:07:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BBEE13BF7B
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:06 +0000 (UTC)
X-FDA: 84091850052.05.CADC767
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0670AC0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r4l6bBR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762711625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXKtenz6DaLMGUShcrB400tfbTGBqWhLKx1FA2IPRio=;
	b=I9yTMxxPKwcMjyamFyFM3U3UOvHwoHlQ8xsJStxgYfFL8qXPvx/0cG4qDCPRjvpZkqWGKl
	khH+ge/i+Q2sYhKYs5RDcg1YJ4j5i9IS2eNjYaOObVKzFs1yHh+85gYV+oQh4hCC0PjbAY
	YHOoyqAk2uQ8Nsm3elHdTfw/9kf3Z1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762711625; a=rsa-sha256;
	cv=none;
	b=l5HsnjUPbgi1IFb+XkFF2/e6HyE7OjTmSk2lNJ68i2f0iClxWMlwsZmTNIZqNnmUhv/Kl3
	4mg1KgbPkdVi9b5gbh0ZqG2caVQdQMh6Xqplf4PX2SviOn1kB8xk7ruEjbDZjB0KeQFPHv
	2ooiVXVfCOWD2Tq9lnvSkT/PPD8EAHA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r4l6bBR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7949F60052;
	Sun,  9 Nov 2025 18:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F22BC4CEFB;
	Sun,  9 Nov 2025 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762711624;
	bh=Rsfmd7zbC+kSZ3iat7Z+yufKodHJKLHaalHhwgTU+L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r4l6bBR+x/wYLFdBSbtrGEd6woZznOFVZnH0r9s2erJWpuz7nykmFQVCQpBbw0PHi
	 kBR6AJir9BuoO165Hel1lDGlfK/BIcg6S5gINxdT7rhP0fBX/nyAEUVlS8lJKw0Sau
	 IJNrXe4OD7939BXLdQ8qB9qMLdPMw3QM4EQFodO2PPj4qmoTr6tG9z1u8daz/GGBIJ
	 wLzSxhLIt3s7zxeHLaCuXB2ghbY4o5Mo9P4rs+A+HTZa5H96TnEWQLZq61NM1NAk3A
	 jrNv2m1xnfwMfiPoZWq3tdUYE+jpmmGcmg4dP/kQZUTert0ZpVnmANvFht9GimNVB7
	 EwgZihfV2WUtw==
Date: Sun, 9 Nov 2025 19:06:59 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 2/4] mm: Fix benign off-by-one bugs
Message-ID: <831155f02bec5ed4ef2be1d427ea18c46446c127.1762711279.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1762711279.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1762711279.git.alx@kernel.org>
X-Stat-Signature: xdehytsqx1631g5yqwtbji8jjzf6pino
X-Rspam-User: 
X-Rspamd-Queue-Id: 0670AC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762711624-917146
X-HE-Meta: U2FsdGVkX18xJbnd60K9eZV4rcceNI8JlldTbYCPuJuRv53BNiCcL0jicbNoi6R48c61rWdWCUFMn6jGKv32hvqnvtwnOahfA0i1mkRuN76HrTdV3XXN6RBkBFBP+2jJRP+rtq1UZXLhjColgOeo5S0kMSIhJPjP3pC9nWEh3lc2vyHb1Espj3y1dS9/RWXrXsaZ7Xdza/Y0cpinoYuZf//2+uXnoZf2+FO+XqS5z1kkCeq/hBg9gLdVqHF8lKqdeWU+bsfRXTZcOmpcOvZ9LWuOM218gaQdZMJ446xm2LK4hZWqR5U0UZ4NOSNad/+eGb6EVhrdWD9EVLROUI8t9Xuc522zf5/K7y/Iew0K/0vTKJu1Lkr7M/4iZRxE23yzviVbAHN6A+jDvC1MruFIitj8GPQqqsd+PYvoHIGfusU2VJHlgZF2zpxatzpgGgcIfWt8Vx39hLY5R0u21t+WumYuWA8Iq4zeO2YsDSPjnwPyuqUAqGgF9Mby/7CPmUnT5WBoaURfNQ54UVREEpZt603NfVGg01UOITeAJH95l1qFhwyEOs1uCdBBCX1chDZekiuHmZPDHzjhWKHiQapiYNb8YtEnw6uHI8JyZv1+IIznMfuk/dyRgDiKntv2r7i84Qu0teOmiOqCez6Q8qRJrXawASIonrHJRTrlmWIuyMzyYC9OhicFLI2aujnnBTdP6Y2GXaUxTl57C4SXvSjCWF26y8600WDV3KNEqZSmtlvidmFPdFgV9RlbuPS2vQSrMCm/xXBxQKP4cb5UTlNx9snUBPF1lWBzpug83h9ui9N7pGkDRR6fFLynvYCA2Q9U0nMwsNUtSysm0HCOnr708LuAtmfYvd5dilW9yeCBOZPnDeaxJRu2TMnNw3unGOs7XyRLDUiFgLPzEJ8ZnUAv4m92mvRGUPO2RJJb9bEvChs2nHK8TA0Oi+bDfHWLlTwB1QQTy94quZRoTPcK3z8
 0cldM/Y8
 /kMDJ4dMGBolnjKDHWgGMwdTyZb2qZ0p39kbhonJ3GX56E/DKvmSUohy7XHW1eplo/XhJysTLOGe6TSCYXYUsYxRHhmfJbLF/QTg1CpHjz/CvBzklRA2WDErnUDoiFMLvqRJXDBeydwYskbPTGlgiGIfc17iAsxF+sg1x/V1Fk3M2X20f5SWyiD6nlU5W6YflYQ22E4mnlfTVmcJU7S0PauiUxiAMeiYCTxdm3luZRRWmoLYiJrx6jm4wHT+paepbsTvHwfmZKCBOQDeuQ+xKOWni4Csor4Iq+50hnwH4GqmpivXILke0nLUGu0Agoeb/9gh27+9UN70RD/bi9HoWs1GVwjxMnRv8Od+6ZWKSlb13vpzeKzGWlh32/TEhXexg+OOg53V0NFhuYAkYuC+BMEIu1kUKnsFx/G0Fgp5x3IjSwC+sxMCskCLIxjWAKM19Mtdes4PSiaCTI5iKIwjwTwADLLiNqGBW44eImRx3hJ5tDMahSupLU5eHaZrfFakRhm/TsUm0JPgX0e/o1zRV4aGxEaF3n1zBiWTl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We were wasting a byte due to an off-by-one bug.  s[c]nprintf()
doesn't write more than $2 bytes including the null byte, so trying to
pass 'size-1' there is wasting one byte.

Acked-by: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
Message-ID: <515445ae064d4b8599899bf0d8b480dadd2ff843.1752182685.git.alx@kernel.org>
---
 mm/kfence/kfence_test.c | 4 ++--
 mm/kmsan/kmsan_test.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..5725a367246d 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -110,7 +110,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
 		cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
@@ -140,7 +140,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Access information */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 902ec48b1e3e..b5ad5dfb2c00 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -105,7 +105,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expected_header;
-	end = &expected_header[sizeof(expected_header) - 1];
+	end = ARRAY_END(expected_header);
 
 	cur += scnprintf(cur, end - cur, "BUG: KMSAN: %s", r->error_type);
 
-- 
2.51.0


