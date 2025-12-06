Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B83BD3ABD6
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 01:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512916B0336; Fri,  5 Dec 2025 20:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3116B0337; Fri,  5 Dec 2025 20:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400D86B0338; Fri,  5 Dec 2025 20:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFEE6B0336
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:18:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5816130FCB
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:18:12 +0000 (UTC)
X-FDA: 84187285224.25.AF167F2
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id E88DD160015
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:18:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aa0KI5lm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764983891; a=rsa-sha256;
	cv=none;
	b=51h38xYcppESLTll6PYARXPesdZ1KWquCpJfC4cR5nZTqpalOUzG2oLY0QJ2Oo2+LjTOke
	GJdLBOW6oKquEYEV59S7Vp/ghmvfnlXCkCh4zHd4U5/pFsvBg+oHKKQ3c7phmyVSks5y0B
	88Qyi3pFwD9zHC2rIGJQ9seXPKGXbpA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aa0KI5lm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764983891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IAX/oOkxrywzWDIxKOdKl4z84YNY9koHwOweb+G4qdY=;
	b=LXeizTJylby6R4cJors0ie1DzfwB93hvwIuFuy8Fkex+eC9MSvN9ReqG56gcNOtoYEoWOb
	1gmFtEINFfQafYr074hgAGtUOv6kQKKrDe6dvy1VPNPd4jF1lqg679ApiSawvQD8y7jZsI
	tKajS3PKyaSm00ye55hNuEOXISyw/rw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29844c68068so36409925ad.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 17:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764983890; x=1765588690; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IAX/oOkxrywzWDIxKOdKl4z84YNY9koHwOweb+G4qdY=;
        b=aa0KI5lm33HF4KTR/y5ilMobhPCUAdeMXmNUgjIEu8sFDfY3FRL1xm85MEY5L3H99k
         2fQeeRLMfMAKjF1f2tlDMzEle2/b7tEN//q9OVzozduy4lSVrmyGu9gFfylOBPggXHUg
         jzr13HS2OgW142GQxWvbRdoDq1CPJkz/H1swR9UURVbWi0T3Hif4cmUnpxCvU2zNjmgT
         BI7l+nqfkAk6pVIFY6CjGpc4AwAHo/8hoC954z0jDvfBR5vAqiu7Nti30WftTp9Y3YqI
         BBO6OdocGawsdykM5Zbwu7Ca86ZqxFN8I/DebhIxKUh/e3hIWYG7gvms+4BT9FBTCytG
         nIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983890; x=1765588690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAX/oOkxrywzWDIxKOdKl4z84YNY9koHwOweb+G4qdY=;
        b=CTn9fREbu4pVt8cZiH6g77wMCCMWXhTzKYDeR8H4az5DVqGMDtxn6HxDS4TPyeJxfA
         6K/GmKFcV+ziVVb0q3f/h4ESbzrK99gzqlaZRFw9Ik7bccWIFLxW1pEqnx+iCwdczAyE
         ax0uuItDdZmwI/mqy4HNpA5kz4VJFDrmbeKLxTSXKSWuteDSSqzuy/NHEaMBkERR3Arw
         F2MS/s00Fm/XEKK8881QPsPM3ClMcuSEIKIZdF4a2z53aHJvmALrZ22AKITDuwdAhirL
         Yv/u0w/T67VnKT9l1VTQWNdV0hAhy1il7PNnJ6IuWG8b5vH7LD+Hg42vUpEnpS0D5wsQ
         KKww==
X-Forwarded-Encrypted: i=1; AJvYcCUUzxwMungZML3QguLMuVJyrn3yeflmXtc5w1rUV/2MDU/PmS/XDxK867S7GTrTteJax8ci4j8abA==@kvack.org
X-Gm-Message-State: AOJu0YySfeN0ojI2ddvM09tDMkZ3T1Yrf5pE0HOSuE4WDQlNCxYOZvqR
	y36avpQCzO2ZYnMIOSXO+q7SrNQOjbwIo2w+gQQYwZkOZuy/EXme3goh
X-Gm-Gg: ASbGncsPULu7/GoZHwcYP+KEcMzdfQTg22YxpSZUkg6US7KfQZqekfMkqYqzXjiLqWe
	czp5s7Z9/nQ0e+dIubfR8cwWrX+QKTlNDS7fnO26cSqFqoBz0qt1MtKbN19m3+8mlo60vyiWokm
	0f8Y72UW98Di5dAB9XpqEYCl2jOf0UU5oDm6eD9AA9VSsikac12hsQliN4BAbFg0fB5vzGfWVja
	b87THH97zliUz0CCKEEElZv/p94oLfDO0jOztPIYPERVlj66oQ9dxbDmK5LXcnH4XjMbJzyqbU3
	O1ZKP84UmpoTfmo2QB+kVDkbKHm94K1GdtPUo9Wg27I936AKLEq6/EFN5r/CXwysdOiOCdanUy5
	CWvPNSMM0ask59IS9o48LziGX/Fn7rL4UX1r5zCWftbB/NkqFNCofiwvHiOT2TOhVfacbVhMhL0
	VeBySZu4lXQEpy
X-Google-Smtp-Source: AGHT+IG/Xpf1V10q4as3omd8fCWUSSIhwxXG2nccEzJUjb74z58QvX4UZ04y2ZngrrltvPo2fNxGNA==
X-Received: by 2002:a17:903:3d0d:b0:298:33c9:eda2 with SMTP id d9443c01a7336-29df5e1b1bemr7213565ad.33.1764983889620;
        Fri, 05 Dec 2025 17:18:09 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29dae99f006sm60542625ad.50.2025.12.05.17.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 17:18:08 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: sj@kernel.org
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	lienze@kylinos.cn
Subject: [PATCH v3] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
Date: Sat,  6 Dec 2025 10:17:13 +0900
Message-ID: <20251206011716.7185-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E88DD160015
X-Rspamd-Server: rspam10
X-Stat-Signature: 4hc6ob4sokto16ms6udehfan1i8yoe9g
X-HE-Tag: 1764983890-974318
X-HE-Meta: U2FsdGVkX1+Jy8UKbtDyxpy26MjraXhUHtU5Ev1Z0SYRya45csg3Rb7Qu+xeHpx3RJ3ub18GIZxWI8Jmjtj8BpoNlzPpbFgrYuQ9/dGEdF0eZ28KnGUdhmTntUDzv6mFaiGXXiXGO2sOkWd5aMtEI2lPx5fIHG7FnlkOv/b3zGepdVJUkzcjc+Hq7Fy+Yjkk5QocjIcIzfz3vWfo1IQuWONe82NuvZV1tolYkP21heR419eGodGG/RpdWoRfBrzk3roS+0sxh7mrG7FGsW57NgoX5yJuhh4Axbx9+peRC1ZwF/D11BGRsJvJO4pymk8sQ04SxjkqWXEpgiJrnQKmxhzDtwr0TxGbBL/61iMlIg87RFcAXsp0BYkJ6whdYGR8urUaM4Wre0MKTmpCMXHniz9boBd4ucgq+ylnMdgOfLId4y/ZehNkogCVqyLF5LWU4zCGLn/xJg41rMMLvijyE7Dfa66B3v0ytJwgPVlfg07//o53ea8X456VHOBQ2M/X4TaeXOj0hrxCUicZmlt/IX8Faj/siE/CPtF3SnBxreFf3fB5trmzyXP9PbZaOVIdWIIXD/Z68tLWVYyZ/z9BUcHAcxuqH17sfXu5KGVx3P/LKOVaf+f8494vT45XjRLqrC972mFkYcEIMqYb+o2k7FyMRDfkchRK9evAuJIvX2PaX4lfAk+Mx3UKH9SDAbQjDzc0ZlUwi8xRFasnna+PzRqgzroLB78XCFc1LeSkixkxMEVNZ577JMDV7YUiTNOGctAS+8roMYysa8vARkjpay9co12S2pKJx+FJQ0uR/LdpMybAMFXZjykYBbd0viGCwQBut3j81eSOXLn3MoJf/DB2mYIY8vaCSMWWIgBEvstCYfPB8A6yETpL0jg/o1DTIU38SuFfui5s0gEseBy3uQ1JLmH1niuJk50+OMx4znYGMYuHC2walWNomylOz4KFg6zsOKY3XCCReMHWIwZ
 N5GkETLg
 NGIR/zKeMYgANT7pVrxIxffnHxZ7C7m2yvDq0ONX9bjSFtaBXqALKvKPcfosgrBZpRLuOFcLc8lV78/3/PJ6dAvrgA+BQF/GrNYPLvXEzozsqwkJYbodr34d7UnEYVawhTefgac8movOhiNQ1LdGIEZelOaN0d9QoFxeO3iLHzQFGFj515YNnrxmMq2n6tgTPVjnEN63HL41cv9LFo7S+KdKohd/R3UugU7YgpAXXA69Bo0rAc5vyHsMB/lyTsZeKK0hK2ZuE+RP8TQ7pE093OdGyb9dkp8NkPFRMvNBDHiOET6atq8Y3qO+Ai5JJkpgtD5WTqjNT1PEhsxFDS6Xg4fT6yc9ONMnLDs0HkoQ2r+iPlyHBgErYdZ5eCzOqo2e9vhikaGUg5vIdlEaO+KOi+3uuMCAJlhtCiIV3ydvh2cKurZ4ehlNRj1xqBSznQy33K6e6EDESVu/8BqqKNDbUmbsnbYyBf3N6G3GA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_stat_build_ctx() function sets the values of intervals_goal
structure members.  These values are applied to damon_ctx in
damon_set_attrs().  However, It is resetting the values that were already
applied previously to the same values.  I suggest removing this code as it
constitutes duplicate execution.

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
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


