Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2237CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D098E004C; Tue, 19 Aug 2025 11:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D058E0007; Tue, 19 Aug 2025 11:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CA48E004C; Tue, 19 Aug 2025 11:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69F998E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:01:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19EA21A071F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:01:50 +0000 (UTC)
X-FDA: 83793821580.08.93C56D2
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1723A80027
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:01:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qwdx8DTV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755615708; a=rsa-sha256;
	cv=none;
	b=Y+Qb7ztS0uzJYg/IHI64n8p+9fbjrYVlagDyTIKNLr/u3K+IOqoChwOYKEgy+6f6ZRxXyC
	PZl8PVNg4H1A8cU8Rbx1umsTU8obcTmuCVmEGzMQlBGuygDnkMm7f0X6i+oe202lhYA4G0
	8ov9xb8hgBqEuNm3QHhb93f3UVMi9Jc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qwdx8DTV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755615708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/JmL8IAOx+wIVBxooeoV7bygpyZ9jyJFn3rB73ucFgc=;
	b=5u1JbJ2qB/okE5kNVYUhPImVg9saf4nSt320cKM7HtZ7sBdsTm0XVvdMFLwOKq5TCbnCWU
	m43j0RkXj9kL+A/U+2MPzwTfMwbcxPfi6AwLwAeajnP8XM/eILf+k4R8uI0CuSDdX+Pm6r
	d809jj7qYBpEHzd6aGRhsJ+WijPQb4Q=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b472fd93b4aso3350366a12.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755615707; x=1756220507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/JmL8IAOx+wIVBxooeoV7bygpyZ9jyJFn3rB73ucFgc=;
        b=Qwdx8DTV460C9uoqe4peR1eLdl+x4Vn50CYjWWV7ucbIOiBekmtxlCM3Jv7rxg1MqZ
         QwH0mJ0XO35vkj8oom3GO/iHw8k/PbLCvLAliDvRwRs+8snZLq9afo8aHiLTYSNk/WVR
         F1DgvIohYGlEawAszZGPiWoTva+v/3fhNI+M+L4mdTFLwAJZZpKqB8RlajM9QDozgylZ
         dUS7/xe3jrbevY5PrTvlx+RqmJF7JD+Y26sYoBj5hSBZasWmwznBCGo5mDym4nfb/52D
         JlooU34yjOuiOwE4EJ05oEe3aOnwdNE6oxcvxw8BZ/ImY6YdCblfR1RryZwyEAkco9iD
         AVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755615707; x=1756220507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/JmL8IAOx+wIVBxooeoV7bygpyZ9jyJFn3rB73ucFgc=;
        b=t7RzD7f4zYJ5od3EU1R6YMhFXPpvhAcivAGk0DT3dHdNY/SkOFJ7BT7t0cjl6RTnLd
         UBAzWSFZI4kdQ/Gab9UeGydJBPVXPxGhk/Ll1WA88qenM31EPolfwY6DsnIC4GbLPhJl
         hJmuiNwpLr0/rcmd5n5+U4eTjUjvBUy/CHm+/TGDZi2/yaRigwCEErwUQAlREyMQSdVF
         SuPSii8Jt1pKRbxHHf9YPaLaxrpsCU+VxPYj4EStgXZuRLt/NF3ggSDNuFcTS+Q4Mbp7
         87s9HSQ/rhN9tRRY05cAsKA2i8REonD0X25DYWPYbqWvDAR0YCpYTA+OdIyE4BUwMzL7
         w43g==
X-Forwarded-Encrypted: i=1; AJvYcCXd7+TKWWHpJELwyesryqqC3P8Sf5DXqI0hHk2QpO+gM8/Oi2WsgXAvf8laB600R8qPamM1bEOn+A==@kvack.org
X-Gm-Message-State: AOJu0Yy8gqliZBoqLIaz7Q6h+8QhCYfMmPxkoYABe7o1Cm7bNrsDGeYZ
	yvj7VzpcWz8xFzoikXbRiZ8BoHTJboZDD8ulvo3QVMyJXPE+xDdT3ayk
X-Gm-Gg: ASbGncuHmn4eyOap9OcUoExs7o3A/HL9YJTFCnckZDsJVZ91Xe4pB/UA5wq4ir7fHov
	yGsmDDYiySKeFA7kS0FE96PSbuc0FQnj5+sFHg+aqI5DzHWqeWjNWDEhamGDt8J8SUhrbMOhPvX
	KZk1WtkK0wHLbEq0RCfa1eHmhalPEprcE2KQfxTC/PGnIl0el0OOx64Mozw6LrI3IbqD5LIGoI8
	cmkLOI9lFEZJ+tVMC0qoymOorW/2FlagmUAVtRxwTkTlzpt3qyIsZaC8g6fJjGoaoRTOUvaQFn/
	V97e2607XvwwOcivzaosakHbMYdpHGOVlLpGR+10IRJtHU7lPJ98upJIfYiknUM8jhG/D/ZstUq
	jRQuNmdsIdWPEbob8
X-Google-Smtp-Source: AGHT+IEgp3hx06AeX/BhzhG30RJ+DaVX+u/IGmamucRk1iT/x14SlB07vl2cBagw0A+feOfOTWzbuw==
X-Received: by 2002:a17:903:98c:b0:242:9d61:2b60 with SMTP id d9443c01a7336-245e02a22edmr32444735ad.6.1755615706534;
        Tue, 19 Aug 2025 08:01:46 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d551493sm2724147b3a.112.2025.08.19.08.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 08:01:45 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 00:01:23 +0900
Message-ID: <20250819150123.1532458-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 1723A80027
X-Stat-Signature: 17nrrg1j7pfn6o14h7i1utnmop466bat
X-HE-Tag: 1755615707-388638
X-HE-Meta: U2FsdGVkX1+Mct77eF0CIPap1u4TpwI7bobuY6VHG0hT6ah7tINg358hriJdlK7X55jLTqBlApqWLhVky8mzKKyQmxy4UisYOXpgUc0zWxzNTA4HUl4v+NOrc302vY1CLN4gtEoqjPsUZOf5Y3dVFuzxDnFVr8cfgfAn8z2mDEzsq8GpxtxmWFEwBZxdr+uIRHRXCSdZimWVL4BJKst3AW1AsNwiCT7DCZB1EgOdghdjLmXJT2xfdG8lJvac5o9xk3tth2EZ2mCP+3420qHRm1QNLe3exiUUCtDkkRVQW6YCxJSrGVav5dtRs/gpRMEJBLmQYqynMUxjamAGwxX375Xr3gLqZMjO2ssXD4hE+6aAmfBVA0LyGa3yMGvEaDig3uqHHLYwU2dRkarxZOGMostnyaPMCwvi036H+C7tI0N04XapQ8XpBDGqiPQJ/Kcju/kKfTRhYMRCasaia8aSAGOE0vqND+5gwNznyI2QpXom1KBNjnYZ7+3zeImWYhsVV0x9RUDWgqh/f1c3XWslllQ9MCD+raLCgmQ/VGryPTvl8wpZ9nvGCMLWzv5QfFGeFG5rtxVPY5XTZKtNuOJlZX5YpsiRKP4a01x0zZSgUT7hSxAy8WzyJiKHjToEP780yIEHsCpppDk4jeV3m0mv8+e0mzzlpMKYimFF03DC1UAf7cuh+A0eFuuJSjyZWyNRTLqij2QnBkzo4iZ+ZA1eqM5x+CWFpnMYQ21VpQQpUnN8ONdx3eIqIW5sw43QZcQZtZlr10yJMlYxWoqrMDjpohr4FH+8wRgxFTjpp/ZZI2w1/knbByyEQ1yeZFh9BQ0nS1pdy6tWOdZUXd9xrvyXvR3UbpmRi4gZh3lLs8rLtbCJQArW7bBeDBqs/ylVf9eZKf7n6JjB819ptmSkQj5y+rJennpXPDz9Ksi9iIGF1m7X2o9k6gPsKOX80x6dI9vduq2kMttZuwnc5n2FU3G
 iVfEwGZ5
 groUBU/zVpUIyGLPKnLFn4CqVLYz0iKn2eMuq6A3VAwEBYh+3DgQ4yZvvIfnCJ3FpAm1/us5QRqr8V2S3YIj8mVFBudln4yxd5uwtfHFoz1jK0qBVctvT49UElP9vLF82JualY49nKZiw9ikpnoEZDymknBT4vmUlnHD4j0WS/WEE1YDsluOWJFhU59r0UYmtvE9pAbyPiOniVlnfpibivSEqPYByJ297zFhrFsoUqhx9NcXEPobIcQHlfZw4oRdJkW9bU0i/0Vfo5H96eWh9DdGWj0BSN6A+QUzMY5EdPTuoWmKgFdJd35EMOOvbrvsQwlTbJKFmG3qmRh3uqKYfKgzFl3XO4TfeqT7wlT6q+reoipgwyHmpCk9aqjL52N564qS6w5a2ct80Pd8sfnyFxJbZ8T4k4A84QmoW/WE5/3t+JUKviEpvsZriyN7etbmLZnLvqRFYTcSRm/eWrcgCnkenYDaQe7e4SEh0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
include/linux/jiffies.h

/*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
 #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

And they cast unsigned value to signed to cover wraparound

 #define time_after_eq(a,b) \
  (typecheck(unsigned long, a) && \
  typecheck(unsigned long, b) && \
  ((long)((a) - (b)) >= 0))

In 64bit system, these might not be a problem because wrapround occurs
300 million years after the boot, assuming HZ value is 1000.

With same assuming, In 32bit system, wraparound occurs 5 minutues after
the initial boot and every 49 days after the first wraparound. And about
25 days after first wraparound, it continues quota charging window up to
next 25 days.

Example 1: initial boot
jiffies=0xFFFB6C20, charged_from+interval=0x000003E8
time_after_eq(jiffies, charged_from+interval)=(long)0xFFFB6838; In
signed values, it is considered negative so it is false.

Example 2: after about 25 days first wraparound
jiffies=0x800004E8, charged_from+interval=0x000003E8
time_after_eq(jiffies, charged_from+interval)=(long)0x80000100; In
signed values, it is considered negative so it is false

So, change quota->charged_from to jiffies at damos_adjust_quota() when
it is consider first charge window.

In theory; but almost impossible; quota->total_charged_sz and
qutoa->charged_from should be both zero even if it is not in first
charge window. But It will only delay one reset_interval, So it is not
big problem.

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
Cc: stable@vger.kernel.org
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]
- not change current default value of quota->charged_from
- set quota->charged_from when it is consider first charge below
- add more description of jiffies and wraparound example to commit
  messages

SeongJae, please re-check Fixes commit is valid. Thank you.

[1] https://lore.kernel.org/damon/20250818183803.1450539-1-ekffu200098@gmail.com/
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cb41fddca78c..93bad6d0da5b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2130,6 +2130,10 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
+	/* First charge window */
+	if (!quota->total_charged_sz && !quota->charged_from)
+		quota->charged_from = jiffies;
+
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-- 
2.43.0


