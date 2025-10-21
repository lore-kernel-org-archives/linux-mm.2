Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C383CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1368E001F; Tue, 21 Oct 2025 12:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8898E0002; Tue, 21 Oct 2025 12:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE9E8E001F; Tue, 21 Oct 2025 12:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36CA08E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:23:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBF1EC0481
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:23:53 +0000 (UTC)
X-FDA: 84022642746.12.CA7FEB5
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 004A580005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:23:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WWc5fpj9;
	spf=pass (imf02.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761063832; a=rsa-sha256;
	cv=none;
	b=xwCFCRiWQtceYoZ+fYyGbWm3wglGqud6hEeZYHz3lzztZTXE5OlUCaSNg7QAUXDLwBHKBC
	yjuec+eccGqBYO4X5JMHGyWTxqAYX6eq6/nON9aNifuXtfLcsTjmaO1ukPB5rKYI+qcrAB
	1SCgEHmJ5yoQjTeJxYijp6+Dv/I0+vs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WWc5fpj9;
	spf=pass (imf02.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761063832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+rHjyJNySjOtG/oaWeyGKlZi0ukwWvydylLz+ummOiU=;
	b=h5gbiFwgBdTRTmWa3GwtcwZJeqPMeyFr3B6jhhIXM79ECk6siZR6lgd11TT/Syh8hWaazz
	9b3Y+EV3vFH+cBjIUxl9UJEl5+vybsIHHr8HYYMgmDz0lOAvWGLV2fX9zjkGS58QlPyTl0
	SybRF/SkTcYrvukDaGmadYf+041EcdY=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b62ed9c3e79so4075296a12.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761063831; x=1761668631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+rHjyJNySjOtG/oaWeyGKlZi0ukwWvydylLz+ummOiU=;
        b=WWc5fpj92AgeWZFV8NPWmyScCLVBug8zJhISV/UwZm1nanjGrkuMLLU1iJgkq6ecov
         vuMf7UEOXk3YU5SFMG+PmuNvEY6tXWbvVYwMS/gSj1/w/RhHP7nqyvY6g/lucLmmBtjT
         NBa7RdE/BVitWW0kkRnxXb29+ESn7JIrlaWfGBjwyU54CkPuIFqjJLX5q4KazStTEdba
         SXHGafm/OCf4DNjPYu6kIO+1IUrCQVQyu9dFxipJCFScE53UwSFsuKb8g8mYWnhexO0k
         BJHI3JJQYx1ZiXXbMvUuwZn+W4J8D4ZV+jfDfAn1iRnt3Ph3ST3g7dg5hldVAqk+NYZ6
         G7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761063831; x=1761668631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+rHjyJNySjOtG/oaWeyGKlZi0ukwWvydylLz+ummOiU=;
        b=V0tJK1sP+jIZBV7GhfzWGhtS3rEXce5BKQJIP4TYlIfA37bX8wckJWx+dAdHdzIS6f
         bk97O8lnQxLYJaUvbJ4wmqNJdG7+NEJy+2xeze6eiW/QehhvYnsFcIduBSSi9Aje0SMA
         UFWsscD8IyXjL2wrIEObPwcyjc/A/SCJpO47A6++9nA343OKaUOO/dvL7BFRg2Bn3JFH
         djQrgLp9RYOyOK72DaKmz/GnogBwaxOsU4jo42Ua6IvI//830/QEKAQ18LjZCi0pYsLL
         dYZr8xB32A36ksNBpyUvaTcpZBhLNz8OasdatDixBdXxpMRlYQXKs5Jd5v+WfmQaowOg
         u0sg==
X-Forwarded-Encrypted: i=1; AJvYcCU8SG4X3p9ocNGCNg2V/53OW2Slp3yyuA7DufLpReXJdUr4U6SS/+NLMEoMbHdB72+YDtkq9zmreg==@kvack.org
X-Gm-Message-State: AOJu0YyjneOI1eh1T2D0A29VKGWC/cmjVXk9Z4uYk8gQI+peC9zl8apw
	j2+UPyQJL19tkeZOeF9cJjsmUzjMg7KvdCOt8AWjuSRn7JtFPW8IYEjm6D2o4U8S
X-Gm-Gg: ASbGncsFvMtCCCNjq6ZT01iN+gVOcFDFq1Z9Uvr+NSRMiQ8GiOKmEqeHX3JXeXM70fj
	OnRyddCteL7/0dj2TZXp9sEW89xvkiwtArB7NGgnbYRsOciEXod9dZgVWH8WqkXHb0qmvn/qKRa
	08+NZOzqjLhqw6/bmthrQUE77bHsUsQqMkmbMsbDWw3JLYkfnPyD0qGkhLFZK/s4QzWOwQCsyPE
	q+VQeSXqDdP+VK5Moo4FThVf7QIHa5iPP/QDi0MMcBBgZC+5vUs3mtr95Ho2oFWRL0bl+DDOUYm
	9IYBHLc9QdeXdgYx7H8Nyu9E7rRsRrLVJHRqCOb5CK0Jtmivg9Pcm8GN9SIYPbw+jcxOVV7xi4r
	1zkvj08WRRPEcGWNU2dZ18sFmx8Sbovp7sVi0+mh0vfKeBzVeDFN3p18384mN3jK+nbh5967EWw
	TbxOTTMMlqVbyEI15YgnU=
X-Google-Smtp-Source: AGHT+IHkHuRO/cGncKISQZWD1qXwaE7w5T+jTVF2YE5Hm+JwJpfutTKAmSOGddAAEiei3b1lnpM3QA==
X-Received: by 2002:a17:902:f64a:b0:269:9e4d:4c8b with SMTP id d9443c01a7336-290ca403110mr218424325ad.21.1761063830609;
        Tue, 21 Oct 2025 09:23:50 -0700 (PDT)
Received: from LilGuy ([2409:40c2:1050:6e5a:c22e:8b12:2301:3845])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-292471d5938sm113390265ad.58.2025.10.21.09.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 09:23:50 -0700 (PDT)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH] mm/damon/sysfs: Remove misleading todo comment in nid_show()
Date: Tue, 21 Oct 2025 21:53:24 +0000
Message-ID: <20251021215323.29734-2-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wx4zd8m1t55d7ttnbai8ptx6a6mp4beo
X-Rspamd-Queue-Id: 004A580005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761063831-980718
X-HE-Meta: U2FsdGVkX1+HuPnFRobAyrwtbvqo75Tt8a9MiWimYgcgTvL6oe6f4IFRSO2f87Z38nYxySIfhDZspXHG3sS7ffZOaStofIlgz5lat8q+6LPCJLFUDtcd/DtCFMNL8XNZV6kGabAnuyvuz6WWEiaOXZlmK9i9Vj1kot6bfIpbe/Ky8wqz2OCJ2LdcO4PnoZEuo6s6Ou/H93aNzvRv3zQIOJpzZBBHsQ0zgZdJr6BvW8COHDipB/4ibiZ0VhfMvkJd/CBFluYyr4rIxt9kPe00tmjnMwLpLJwiB3OyUwZ6DfDDycvvY04vsta0f122vNZQ0FXEUcLc9aiiCFDWD/vkzdfPeWo4DSnz9/aqh7meYXCRsJju8rNg17BRPfZStHMNLoObGtoQKaL/kQH+erxhohB26ORkD6/yekCwLrkJfjWbDrWASSVpe5tp5o+udnc4H25Q4f7mpnyWUWp2E2+t+2ljNlpeHI7H/T5bQBX5FyZzFOMlvDcYcAcFRjIyy0eWY2MgVjZ2acF7LDpj8X5/sRj7NOK9v2/kZwXzYxkEuj+zcZNsiGkmoDyWFq+XsoGOaWG2Vf3nO0Tjb14XEJFitZURVV/zY+2BO7grEHVj2XwC90CjG4ztI0GKJ/b7/FHo4EUZWBukPtYJSJb1BeBhLYnJJUblOxlLkuaod7xurYIuGdB/e3/Wz+dGoJp/zLGAWsJZFw+sawtvlnib2NUV0o+AGToOfIeW3r4w2iz/HO0y1pZPmWR/V0aSb7MxNcrhnBXK6lZfudeKCsXqKWqlHswhlzQMJ0mydJoMdjQSEsguOEHRpxm97eNRjAyw9MQ1r94V5Nuz2orf65fJ/MfIUuCRXlaFXvAmqTEHl/O7Q95JYiykYuRc9N37Av1mvY2EajqYaYL/M8ZCMt6HCTS2RR/nlnQyddqcAk3gDs4oh+LCBPLV0PODH2RXEfDSB002F/zVpXqg3RcRq8CWd7w
 hVvzhmJ2
 fYKmiZWlYjz5/JS5WEjnDqiFLEugthT3So+adA2E0KWr+TEeQsQEGMLY5RXGMr/XpYXTGxb4o5GdW1WOEYC9pjaehxmWbnVTla8W2soTSsD5zcQddtPjq9qeDZbFmKDMiPRiQxQqiTes/Y39tj2SjEPtHTcBTqztUZlNiwj2arW9hvluHESxvSLFs+HZ85UjQ9gX3SN7XYPXjne/ofr1iRJLNJUB8hHU4mEb3ZNtk1prUZngFKOZSsYnzDlQWod/2NPt9JYX/NIuFxTSm7AU9AyObnFEZYXudgyjk+xHzMomtXfkYXtjnP3OYVmmgyjT49Rr1Cj6nfD00tdrs3hd4Rmv2FFlF6iCF31GiCECIG+YJCbZtF0aFuJlP5phZd70WqSiFGJJ4QUMKiuyW229Dvr7fJsYjyV9V6YA//zfrgWwjk2MnXOx5xQnuC57crP8z1g+pZkv+6UWwv/g01zKedRUkxyQPfdLso9zn3YoJ8xy2LYGDSHQrNOxVz/cpxD/HS6HjHp98y26ImjOqbTkJZbRyMHOkgPA6LT91
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The TODO comment in nid_show() suggested returning an error if the goal was
not using nid. However, this comment was found to be inaccurate and
misleading.This patch removes the TODO comment without changing any
existing behavior.

This change follows feedback from SJ who pointed out [1] that wiring-order
independence is expected and the function should simply show the last
set value. and [2] checkpatch.pl complain about number of chars per line

No functional code changes were made.

Tested with KUnit:
- Built kernel with KUnit and DAMON sysfs tests enabled.
- Executed KUnit tests:
  ./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests/
- All 25 tests passed, including damon_sysfs_test_add_targets.

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>

[1] https://lore.kernel.org/lkml/20251020151315.66260-1-sj@kernel.org/
[2] https://lore.kernel.org/lkml/20251021010847.68473-1-sj@kernel.org/
---
 mm/damon/sysfs-schemes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..760279092b4f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1112,7 +1112,6 @@ static ssize_t nid_show(struct kobject *kobj,
 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
 			damos_sysfs_quota_goal, kobj);

-	/* todo: return error if the goal is not using nid */

 	return sysfs_emit(buf, "%d\n", goal->nid);
 }

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
--
2.51.0


