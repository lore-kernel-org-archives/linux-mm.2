Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B72DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B116B0111; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D1F6B0110; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2D76B0111; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9926B010E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:48:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B02C44011A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:18 +0000 (UTC)
X-FDA: 84933230676.21.7F8FFC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1330C180011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMyUZu0P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744497;
	b=nwYv/HGOxewndI9t/rlyPuKcaRnV5wVeKTB74qUyNi7UIz4okuh3zrrN+peZQVwCNeuiQy
	TqxlNS5tbMq76hVRbJGsRVbAHkrGm91NYJJBzxBSzDkGEgNVwruPuVedxIodE1ptEi9ZCd
	4yIhnjsSuuh7C7Bv+ctXIgmOqICoT1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yxnk7FH9lXDjwhbBu4C9JlpZuxnrq1wW91k5ivVgec=;
	b=kf8IkKJ2eMLLDMZL3q9ZbxRweKW74JXP+EnOvUU6FJ/kCC+Jya5v+lGyfRhE1tBIH5wvAA
	YlHS8ZDpCvuiir31Y+S2Enz4f9Gl3ptJWEUz1yRoMKKQoLKIej6dZWrxE+qyiFiZeSKcV2
	V52uGP5c+chispCPg5FpkHuzGm4WAe4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMyUZu0P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C3A641A5E;
	Mon, 29 Jun 2026 14:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40991F00A3A;
	Mon, 29 Jun 2026 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744496;
	bh=2yxnk7FH9lXDjwhbBu4C9JlpZuxnrq1wW91k5ivVgec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMyUZu0Pq+zo4eZxxoOn74Zaolckd9dEMMSeylV8rzYmiroI1kZ4wcYPq/MU9o5hZ
	 srmTi+u98fnrttnQdAe+GWjGn1JiL3E07ud2xkZHVNae8eANx8qvT6QCiKMPmg64pD
	 N6W88poOrLhdIp98xHQlxQnqhiXmBOxEnrGv+hiUIfzPZc56sLd0g3VtdEvG2UQhGP
	 n1wAKtILukUZvQTNEK4VWSDBjJFa+Wq3Qn08JPhiatvXCFz9/Ubh1MhKHubeTsx6A5
	 1kzT6vsmV1qVjudSgDiBZPt+0WTXylwIpsUtaG5v607jb3m3CXug34sHJCLUns0ESI
	 A8s1oOLcvgrqg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cheng Nie <niecheng1@uniontech.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon, 29 Jun 2026 07:48:10 -0700
Message-ID: <20260629144812.134159-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144812.134159-1-sj@kernel.org>
References: <20260629144812.134159-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1330C180011
X-Rspam-User: 
X-Stat-Signature: wscdpb8poyk5isyiz7fgrs3y3da833gp
X-HE-Tag: 1782744496-76447
X-HE-Meta: U2FsdGVkX19eVSb0B9IcQQpPVUngAwlMSUdRmCQc01uRK1mAXDel5rVwcdxnnVOMS+la+CANzzxjNVhFieoY1hfh+4MHu3tEeiAAybO8xbQSC29ZsNnjqKZZTEuR+eLCnT63WvYLS8tAtlDQ+CRZ+knxi6agyUNsXNbgugpKZcnyQ3FmAbk0z3snww2jJ/v7OhotW5ie+p3gXbIsOlsep0MzQQAr3wlFGQN2Ro185c2zUcdlzrNjog+E0UTeUXQPHzf8aJClKGPu85GhGKFCGK/dFDj/KqgtNjpgNRvAYX/0crbzcWjeiu7sePX+Q1VitbUr7x31RnTT/RZ2pAdGtvsiSICjPOD06PP9C9Z3yc5nR91lT23QcO0MLsAQc+agECYccf8FfisL8H5zZJvMvcx+iRedJpAbvBg8Yk/VKea9tGz/YM4sa/6oVx31ibi4wc6N1CaSCY9XaNHDqy18RL+BepYFrKsoKKTLYH1GwhSETHChEhw7xEmWmxl4wDvPpMARv4Pzd5hqLZ+P4wMN823WaX55wjNb4/s3+YcK8T321rc5hEL6vjCwJ+8vQjwPIM1Z3dZocXRy8rVjpKEgPBQ5eRl+xiWEMIyU0PVhTnDpSo5MfteQ5IXWYHFv+3bb1ES2KgeLfyFiHHOj+TJRxNKcNKP+2W3SsJO/OLq+YAj7uknPyd3Zqf/OsX+CWzHuYYzTIKtXuQRLqvGwHHLPEk400Ix4RN2de1SzHi5VWPwJr9zUXIZ0su6MoxdUAjVkqWXK6V2b2x+xGo9uxqYsXPt16czBAY759rnEST87vU5Q/Ze2S7Hs/L8VBA8DIq8zUFgKA+pbst6xRIZcaCb6/uuZQhyaBPqBxuxUT3m78EqCMryZ/IbN/fW+wMheBUCSyc55BLl0bzq/oBVCNRBJGqSzPq24YeFgNYr5YmiucCNUjKK0O+XEG4ETbi1WF+jlSsVkmTjUVWgIU3gGdwZ
 VVMJmKtQ
 a0263OtNgHn0NCvKvHY7dNNxVObP9QI7ta8gGni6d7gQexKZZtP8BI4Bj0rgmINNzmmXWZuZqOMhupf+9FNdCleOU5wUvO8/at/kZKu1s8iAdU88E74wW7sXcOeO4gz/Zd4lWB9YEpolvQ7g0bGZZeu9Wvgn9akog9mqVE/ivsw0ZEyOXtuWoGB+y3JoDAO9hlMyOU7Q0QJb/y5KFSIVzzsnbxKYTYuA1j/JpUrqoGAUzIbF9a3hEFgkp3SGm+SdAO8ua6itRjheJ9AOxyPl0X12kyUsqEaWkwY4PjUIQWVOsgxvyAnyDwqH3V0fEf/ln/yk2SK3gPNxoNEcSApPt8aXsmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cheng Nie <niecheng1@uniontech.com>

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.
This makes memcg filter staging and follow-up validation use the
written path correctly.

Link: https://lore.kernel.org/464AE12D4BC6B6F4+20260601090519.240482-1-niecheng1@uniontech.com
Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index f6127081dfb2e..c197ab99bcc0a 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
-- 
2.47.3

