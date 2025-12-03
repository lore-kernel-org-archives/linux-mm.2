Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854D8D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 03:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B106B000C; Tue,  2 Dec 2025 22:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBBF46B000D; Tue,  2 Dec 2025 22:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF89B6B000E; Tue,  2 Dec 2025 22:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFDBF6B000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:34:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31DF013ABEF
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:34:57 +0000 (UTC)
X-FDA: 84176743434.24.5BA56A1
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DBC4180012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:34:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mkT4H1Gb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764732895; a=rsa-sha256;
	cv=none;
	b=FqomYXdMzd86WZXXvK82+d80s6ryRGiIXt0vjtjRQ/pG7MiipojLbd+eKUQqLFRRtqJDr9
	unFD3aKcRaKD28CNE5li9ebdTpxGS/DKDBC3fW02nSnkNlO/ptJ4eE4L28Ju9pGz0MV0VC
	oSmcYtSK5KwEhpUuFznSsX6Fugm930I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mkT4H1Gb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764732895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0+Z/geAOU+bcXyh6hKUuppk8xu+w6gIRfaBxFJD+qE0=;
	b=mPGHpbYvZTVUWwjCstE+Yw3hjyUdSKp2jcuENWIcfJZxCNav5ao3PLFmFjGfqdqf4ullYm
	R2Gb6LDZKIsgtC5jZQNrPlUj9VVBNfWpNTGGRtdOahFHostFRtJJOi3Bv24Lvi4edcIsnx
	9OvD+/YIz+uk7oG93B9DnRN5gOwPcIU=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34585428e33so6494620a91.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 19:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764732894; x=1765337694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0+Z/geAOU+bcXyh6hKUuppk8xu+w6gIRfaBxFJD+qE0=;
        b=mkT4H1Gb4NSlrhNX5Syzy9UdXBFI7qszruJmcfc2lGMYBr3hdZVJKo+zRMtRSjPDOt
         OIqhAJSQk+MtiiMOznKea3/U+5DQuw9cCDZ/u8U3Bi+He9zaCt1DYFDqPDD2+k+9Is6o
         dSmQuitoTVlor1iHvgG4Y/jWNdDW4zJi/ccVbBAAgRf+meC8iKT3rFags17RhvEBpdH+
         hf9BA7jV2MqlmijV2RmAEEriJx62zWykzTYPNl9RCO9/XnFx4QIt6vaKQclO5UCqvNS1
         7hzVjuORT+/FKPL/QTLyvAoNE+ij3jJm87bZ3rWzBBkh2swayCx5R+vckJGxMoOGrZCo
         pxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764732894; x=1765337694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+Z/geAOU+bcXyh6hKUuppk8xu+w6gIRfaBxFJD+qE0=;
        b=WgCkQpVcCeLaMb6OygBIQs6PIuPD2x4/H4pa1GANp0TBHXV4+iessWpN/4CMHuoVfy
         YJS3Q+RnRrrpRV0gyLXNGP2uLkkaYMXXUedhdXY6kcnEK8lHCHN6OivE41Hc7ye7/Y57
         km4Ej9mt5rjY4qrUEuJohUzd9U/FJYmwcmzdcynKLG1oCuvbRbBGZ4OK999zWbdUJStk
         DmjF7bRBLxiZkcnbPlgmDVn2gsZdMcQ+fCwMOj8mP3gar859FHaP2p1MLcUUxI7TRUA0
         iOpL9kus6zSx1dooNed8bbBLxtrr1N4fh63uUkbM5STbZV9N9WA/Kmgf1+jH375/+Raw
         UE5w==
X-Forwarded-Encrypted: i=1; AJvYcCU1OuVVAnan4GTfvxw/nNvJt9Z099OMaWfbtQ72Uoue8KOwfT5q5JBy6AiFUN37mvz5IUCIXtYHjA==@kvack.org
X-Gm-Message-State: AOJu0Yw7ynVnX0n9GWzKgEoPY2+AP/WMnHgItYx9HJr6pAFATBwFjseB
	bw8GfknE26OqB9PqSnzR0O9fnrYIgtXclAQHvuPYmWsrzN6vYu9tu9m3
X-Gm-Gg: ASbGncsc7T/pXSiT+8ruTDmuM7SUu1ozYVh9vQTk59+5zyMZaT+AUjZVragn7xp1vQw
	QCoYlkEoOW9Vxc0fjZSY6o/glqlFsi8TE2qltGGOJUrSojyp+tpnVrD/1SBX7pq4oK1Qt3np+zW
	+HnAOvhP81ZXEHdpvEpuB3c/cW+W5NzQnrzsWPF5sggiXQC2EjR/G6tCWfZVpVDLu8xU0MvDV5L
	37PFHF96Zr2R9a0Runmjb7nIs2U3Wxuio2FQJqQ6bW67LIBiVDqOi9nA016onCmYZfaSD4UopWm
	8hPW9xyVAVdJlpqNsEJxr4a8+NQogmNcKl2AjjvXTtyqEmbQz9hgmFGupC8Qi/bbUxYv6kF8s7T
	PHZJOgtwsxyHjbO3MaZRU0sGgmro/S6mfazfr8NfYVvk69kMaHlaBg+4mBSp6OOCz7Oq00+uR97
	qCmPZn6WUIs+oJEQrYG92ty/c=
X-Google-Smtp-Source: AGHT+IEMJdOeJMx+xTId9Thyyjc8t+c/833z/+Pc+C2dEcmpgQvsqhWujJ1IvXCBC68SjG4gkHMkIA==
X-Received: by 2002:a17:90b:3f8c:b0:33f:eca0:47c6 with SMTP id 98e67ed59e1d1-349126b9a16mr1081318a91.30.1764732894142;
        Tue, 02 Dec 2025 19:34:54 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-be508a1142esm16011198a12.19.2025.12.02.19.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 19:34:53 -0800 (PST)
From: Jung-JaeJoon <rgbi3307@gmail.com>
To: sj@kernel.org
Cc: Jung-JaeJoon <rgbi3307@gmail.com>,
	linux-mm@kvack.org,
	rgbi3307@naver.com
Subject: [PATCH] mm/damon: Remove duplicate attrs.intervals_goal at the damon_stat_build_ctx()
Date: Wed,  3 Dec 2025 12:33:48 +0900
Message-ID: <20251203033350.14629-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DBC4180012
X-Stat-Signature: r5mfm13z9r54y9xk7hc8hdgja7wnqirm
X-Rspam-User: 
X-HE-Tag: 1764732895-644793
X-HE-Meta: U2FsdGVkX1+SxmZeI5MSaJnOX7oMhokinMyz6Bc/qWHk4nmfM5Mjz2S9Q13Ki684hSwomi4gb9oga4MclK5OISrlmA1yQ2i1+Ve0Ey7VEa7acV+FZgJG23FKdDTsA10SwAk/6flDqPmeWo2sMPJRhdPrBs3bUBjtOl300m49UO4zEJN8uvu7r6Kr+W+dcdi+zGa4baZAc65r5SFzn7PPWbVrXnd8wD10gUQiNUTxlKf2cO6f2eOtgZNP2n8xckQ8n7upMMfKfetWaosUHu1BJa4/NbZMnjtrVWEZmsUkGZ0i2Cy0zfctJDQz/9AZgueAN257QMzag8YzRICz9D1JinwLeCoKTemqWCThyjzl5C67slYKEoHiDsj6M/9Pxp9G2HRFvsFvomoqY+9MTGQUp/KIojlHuPMKRS31jZrhpAZlyvy7aQu1mpdgj0Zf39+Q2q8J9r51AauGfVRsPv2MBVJv/8/Ed3WHnnpqC+bOm2Tu88koJ64wIQdNBwtu6ugqAqdTXDD7PF9VQLJkP89is163Xc9TNS38Ab7KvCvW0y/QX+4Ej4wZ4k2Vv2f/YlXzwhTjcZe8rbtst0Ig7s7oBNcuSTFt2wIkcXquLSH2QnKp4XE5Ma8ocqV+Cl7yLBVVbgB3ptRaKfE6DIwqckvCCz8oUnHPjaUS+r0O9MVwTLMlb/hitBAZdbOZl/3GUM/gh1Y0+efJmqv9jWsCoWyDGxpYsSWSQmxGyH4avLMVkJff6kJmzMUroEnQuTomjW08W9RKK0DGS8LqctKbrdBPwVjPrVLTLHM83UCYphKl1jDaTuUeQxPXegfJkEgV8QJcFetZoO4ZjOBHCz2TCKDmtljVJn3RPLHzkSDV2k4eMdtjz9zK3OywlNo8uP/DojWZJVOCMcxeiO6XCOLEe6dbkkjzbSbrp8rll7u/C2vUjdCrLeEFQHBKLiY4/me8cpnxTCoG9Pxd3mbax/a0GaC
 VWBfCqLX
 RkKxven1DeCYS76PMTnza9iIHRXiAVkT8b3mH1GFg4IX5P3eGDYMfJY6vaXxIKYCVi3f1x+POmLO2F58xE7Cw18+IZ8Es1DBmmdnrNXUMOUK6ruJ/VtZDnG1fiRdlUeYzA9h83FbZWMbYOb8PknXeVdhO1ZUZNfmAcpS8YraHOIW8Iz1F01yX1zqTxzKzO7IcHqOIhVnRqDvPpiNDAQoJhxzi2KlEoc3ZTdrnhkp49NxzKTdV52V8TKUBZ0HqA+03UMYLw2+S/Axgi7+Ep+g0Vo0m7pWVCyFv7rzU/2mFH2aTRsO1O1ZVEAHL4SVwF87BnpflHcLOVh7bR7b9uiuSnDVdcJLa0StBW708qd/slh21UsMkBDf/ndaH/ku17wCN6E4HvBp7F3y2GI0VPKCIc/La9fRW842l3HuEN6pfU0gNQjZ+hSDdA6aNJeqWegSB/BhYiwPWQMYPbeA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000307, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_stat_build_ctx() function sets the values
of attrs.intervals_goal structure members.
These values are applied to damon_ctx in damon_set_attrs().
However, It is resetting the values that were already applied previously
to the same values.
I suggest removing this code as it constitutes duplicate execution.
Please check the modified code below:

Signed-off-by: Jung-JaeJoon <rgbi3307@gmail.com>
---
 mm/damon/stat.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index bf8626859902..51dd29685915 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (damon_set_attrs(ctx, &attrs))
 		goto free_out;
 
-	/*
-	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
-	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
-	 */
-	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
-		.access_bp = 400, .aggrs = 3,
-		.min_sample_us = 5000, .max_sample_us = 10000000,
-	};
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		goto free_out;
 
-- 
2.43.0


