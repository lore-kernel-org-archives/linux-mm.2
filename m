Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DFBCCD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 00:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4804B6B008A; Fri, 19 Jun 2026 20:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458826B008C; Fri, 19 Jun 2026 20:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3468F6B0092; Fri, 19 Jun 2026 20:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11D906B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:36:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B594A027C
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:36:09 +0000 (UTC)
X-FDA: 84898424058.18.3554840
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7914440003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:36:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o1MftrW5;
	spf=pass (imf04.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781915767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l61wqrGf66LLbRNZjHAl/GibXycfmnzPDWP2VbrWWo=;
	b=bVTbhIF54mo9DcWR2q2Fz9CTdbd9VLpBmtwgAbbWt3W2m0wtOI4XK+KGBp9D1SNug1g9D8
	aaxYSpXlrg/EMpCQgn/ICjhXYxIK2D5vHP7VFdBj08NG4IUN+81zLenGmt4vbDZQrZHQOk
	/YhFHhM+Lbf4ddXXavZl1CNSm5fytkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781915767;
	b=sY1sBlPFyAPEAAqiLn802zAFiZaWJEMwVErjSBT+jK7uRWMglGLZ0HiPtZG/9Qd/y5LWFE
	CV1zPhDIiY56NllMBLJFbuepq0BTtNkyeLT4r1aH8p73cr4atQAar4jIUTuplqmHbPhs2+
	+lE0YW9Px1YSBCJhU2JXE8Z0BEcydkk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o1MftrW5;
	spf=pass (imf04.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49241dbf9c1so11564155e9.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 17:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781915766; x=1782520566; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3l61wqrGf66LLbRNZjHAl/GibXycfmnzPDWP2VbrWWo=;
        b=o1MftrW5WmCNjp/wHPITw6LAA7Qy0HJEf51+EuoAXtRZrzHvGZpRNR9kHYodU+REo0
         JgR2AaRb5H5fwDf7bHr2fKziB1icDoYUyqGEEgyo6id9tekT+SnHGfNDM9ik3uuZdbOv
         C2rV5JZ/JZrIlJHl3XBZ2XuVZ817zHgkOa3tC4grfVHdknbe/+dXvyjOX5H2DMIyMpfX
         Nxiz0S2SU/aD7vqTE/359Z7qSVDb+r8KPmvRu3rkRjNHPH3m8z/DA+geazoLIozMdtd4
         2Eh6CnftvlkGZWG2FF5H9uIbTwkTn13qiVpfWoFmatDQuoKgw1SJfOAP2BeTXsvC4udO
         Z+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781915766; x=1782520566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3l61wqrGf66LLbRNZjHAl/GibXycfmnzPDWP2VbrWWo=;
        b=BfjoUiTQXql1SqwqkaUns1LjrVS05MrqbQxWQgRebsigfVqctOaSgUJxjZP+l/u15s
         bElHZY+wm8PFZpiZVK1Z6NGAcM8e8Bjnh4XfbUWWRUCY/cogFmzpYJCFv6RDMGhXF2jc
         br1DJmyQ7wr2onbK3v+rho0y3CuT7BrGkQ/PTef2T0kHZC/K6Gjl0vWolCIh/gOKEbSq
         Xezy06svceo/DyNb7PqwR/0/d1VxDHk8q7Dv4HZzrUbxxAwRG75cGFUbtK69izvO0XnR
         rPHiRt+JIMWsBt36cX+GVQ7AtJpMwFkzZgQ8FHr6cdzlTf+YcGwYPin+rvWvwU3SbYBS
         yGgA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZATUi2+R25waS+Ia5xe+IMK7w3yr6sgVlOkGfuJ7mtMr8MwUS6Mr3cyiZkwCv57pTjpJhtvV8aQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4GTdw2fhlIJQKVl9+ksAHSeCDz+ZsPZZJx+0ZFgXzCC91MKS1
	pVI4bQcRplw/OSt3e9CmVzdvDQgBQnPaPryWi+ynX2mgR65nva1OZ5u3ecmtJP44boo=
X-Gm-Gg: AfdE7ck+3yyxtFwvGbHB1tiHpX02LlYiptgNP5vDAkc97TD03jtbxIyHhIefOiCtXP+
	bKvqi4yIpb4hJGVlw6mEyHfTeT4wvfooiSDR0Xlqx0NpkydKwhwHY5+VGMCkx7iPZlRDlhDxDqk
	vYVMD5S1Nk+qGe2QDfTB0KtDw99Imd5i7Z9oLXX4S3sMy//lAjw3K/fr0VUHskBMW5U0Gb/VOTV
	EtjJjYHj731sGp3DewJwny5Bh+39FmC0KPeMhcOp80OVBzglxFWk0agVbDYNpwkRdismMwXYIQn
	SmH2dYA3TngzoxLm0Z64qJPGloqKhE+YMAqeHHfRjxLJtZcbjzp/00KwciFxr1sQ6akrI1iYkk+
	TrHF99Z69UN0fLmylncVI5X+1dS4l04YpghaEMg7luf3YP2SmO+UHMRcvjOKjGzx8WpLEO52tbA
	jyQm8biOWLMuk=
X-Received: by 2002:a05:600c:3510:b0:492:4161:ae9d with SMTP id 5b1f17b1804b1-4924161af05mr83964385e9.8.1781915766153;
        Fri, 19 Jun 2026 17:36:06 -0700 (PDT)
Received: from user ([104.28.163.163])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492494497ffsm22020185e9.11.2026.06.19.17.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 17:36:05 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia <yahia.a.abdrabou@gmail.com>
Subject: [PATCH v2 1/1] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 03:35:57 +0300
Message-ID: <20260620003557.243313-2-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260620003557.243313-1-yahia.a.abdrabou@gmail.com>
References: <20260620002614.83004-1-sj@kernel.org>
 <20260620003557.243313-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7914440003
X-Stat-Signature: b99uy6rd7f5oobn5kjoerzksuzgjii7u
X-HE-Tag: 1781915767-730415
X-HE-Meta: U2FsdGVkX1/NumX9jgI2Dvw9d4pPHIzfqQQAOO0ArSjO6MlyTqLi+tt6dtKCg384sAB7hET1XRSPN14pWh1anBdXeAYENV+f+Q1QfBRq7RMPr3f9ocAD4K53DMPmIlObIhScLAuVhzDjmALwcx0GI0iwP97kyXQg3o/LpmU6D2khfI/ZDwFPFm+rUbMF9wAQ6wieXlOcCpWcSs35b8N9eq0YPbiKuZY5xA6sLy3rUM3bxFe5doCWHvY3ew4pH7jxviGRWZCJcabFLbDF8Vko3/XassCunGHBkdaip32D/fVf1hB0o2jq41CYqhaP+zfRkA7M+S2vrbmZlWFua3EyMAie21rgcN7qN4oRoOH8eI4Sh+oWq0Oz7uxxgjXpkAMZm/CWuFDI1Ia0UeMyFGxRepXODGIJKkxTAkVa6Jhw3jCW0Vfh51djiC+cz7MJkCBDKMTstu6Ic72yseRbjGqVgrsQe5tcpWgQav/6SQkqgk2XdrVdLvlb4QXllBeHmuazXtlMeVnvzRJa57Hd8JB/y65mCDSZAUK1QtSA//8wxQum1Uk4APJ9ZnsM0AKsze7ceAPS36YUI973dKgjqMoEz5ZoX8RQMKMwekaWCnHaX4cifqo2PmT7uXWGk6QycUt9VMepLC14ldmc5HYJmvVT/bjyLEcgu8H5WrcKu+3QyVZF13IWUDs1mkPp+vrzLdkn4EBYFxFUMo8c6H2ejQLpdNgUXq85kUzRXVHj2LTjramxQp9Iarwvpoxek4Nh5rZ0ZjkMTN8VnNGZ8H8+/+Pdp+7l3JtS7J/lw2eOEKW0qPpOVZOPFiRMCfFBxEmLHNIn+vz1BvcECImx0eingWb5eX9kbWfgZfnjJK+v893xW7ngxmCyRQZobT9tsHSmJon/pLcIr6ElT8ukMFS/Lpi58UYbOUh3v+5Zk5ceVuR7pRWXPvbZhFj1Q3khzKtL/+Ro6F3GXpZdOX0OJKqJTOQ
 fpD9Fj/5
 aQKBWbGr2keKQ7CRjkK3/9wtBZhtY6cLDlDPQw9b2ynYnceFwwQ3qoMKf240ZcrDbWzOCAwp4aIy85LAnDSkgUOqo9omIDApNvvXyMTdFnRlFyCpYHp/7vlBqjMzk1KfdqokQpXAaqiZsHNcYkkNjPQmM0l+0VBkUiveyXb+HULPmqzisciIQE1+s2CpbZqtt0hP9DZ2xm4BMX9GmKAFJ9VT6KC7OoSYzbuU+DztvkbssWd5E5AvHsCELo/u1TMujRWPKhAOqJXis5QIqyxyRKQiO/mV6OGg85G0v7qpeUjsQ2X5C/2HaKic8eWO+BKWP+TN5Dh9PAri6gIh7/HUNw31mDbfLYaudXzoiH8JXA4FGTA/5jul8ZjFRJee3hfujtL+mQwqZK2KCYTPplWXHiF/4pVT1uxWkCswKHGV3vCzuPhMXKYkHFyfeZ4OR376z5ERCZHNyqzO9AfIULGIlDfdiZOuKZdOvn9z3pdI1Syw0TM6grBDX0cvQJ5pkg6fZ92CQMLxmWHyx/AE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: yahia <yahia.a.abdrabou@gmail.com>
---
 mm/damon/reclaim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index ce4499cf4b8b..6601b08996c6 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -478,6 +478,11 @@ static int __init damon_reclaim_init(void)
 out:
 	if (err && enabled)
 		enabled = false;
+
+	if (err && ctx) {
+		damon_destroy_ctx(ctx);
+		ctx = NULL;
+	}
 	return err;
 }
 
-- 
2.54.0


