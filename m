Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFE9CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 22:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164746B008C; Wed, 10 Jun 2026 18:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1161A6B0092; Wed, 10 Jun 2026 18:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003B66B0093; Wed, 10 Jun 2026 18:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E415D6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:09:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B080B16470C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:09:15 +0000 (UTC)
X-FDA: 84865394670.29.20BE37D
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id F0A161A0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:09:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JtEaE5cs;
	spf=pass (imf19.hostedemail.com: domain of enelsonmoore@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=enelsonmoore@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781129354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I2rvGwAHxdXFYAXDTbR7F5S9Al8YQt73HDRAVWbfbTY=;
	b=yzYhi1Frcpr7tRUTezOVbPyhTajHGg//7AZT5xVB2usZj9rls9iJzIbamWRblKanZz64es
	R0HjDKhXgn/rc0FSQrpvFKhNbQNcDG6AOY8mlYH7iQvafqhCvPSJEZ6+YFs+5KIpDq3gQ7
	dPb1xlriObUMbdRXcN97+y5J/9ZlOVc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781129354;
	b=QKysgxCCFKyf3HoJ3s0B8MUgXEj3E9a8PkKP0s1jTRIVrC4rhdcCg4Hrqt5yS20jl6QBOr
	i/FTq8LxG+U//kIO6Fe24xUQhS0pHXUtfvdC6z5Y6hbjN9uO9jQtfclaEP8VfNTnAPn1Hv
	pWKVgiCVqbD5d2HGfgKD+rLz4/GniX4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JtEaE5cs;
	spf=pass (imf19.hostedemail.com: domain of enelsonmoore@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=enelsonmoore@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-13832028e9fso2609289c88.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781129353; x=1781734153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I2rvGwAHxdXFYAXDTbR7F5S9Al8YQt73HDRAVWbfbTY=;
        b=JtEaE5csOY7rpyDvf6vm4DEqf0nkENscg/SCD+f3lPT9/I0QJDr1XGzbYVvA2KPSN+
         3QJwYcRM5oSLzFAu9b6p//v5l71pWMKknShc+mHpkdiOcwVWHuqkZdHd3qIKJbtuXCUf
         HcYXbIiTfQhkpB4wIg7RpklR6xYREk53EWDyB/F3YaUKfwVccABKyW1xDQsuJvbvl86n
         XCEZP/A2poKQr23P7p/SJSCN3cxzJWN1SD+eHf2urwQ6GHmn/7UBF8eQeqW963equRqa
         8bt5CoZRTerxOJHKKivq5ipTU/3rWbzy49Wvb26Nrg4tgbGQ5aDBOSv5D8OsJtXnQwU+
         ZGQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781129353; x=1781734153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2rvGwAHxdXFYAXDTbR7F5S9Al8YQt73HDRAVWbfbTY=;
        b=kP4EUO2ePh9xewEzFFHFQhkYhjgms2Tt7rJNb/5QiG83ERDpItCSeyvHaQUcJt5aXe
         J5B97D7PA90AhBAbuKucMjqz/Jx5iksvmTvYmEZRX324KPxianqv7eLeRi0DINhN2ibH
         NaxmfCa+MakJS8NN8QXocSSUm7IW3sIAsYYU0HZP+YikGILXIhc7DG0qE6/ZyuOHxfUo
         UAt8+jjQseHkQ3TJ7qU1pgSp4piX9rKS/TduKYRO96rMuZpS8+mP8QT9fjfMAOAVK97O
         T00afsPz9AQbSo24KTV5FPZ1WjQKvacxFoVosV99nolZKS1r601KvvGXy3w1nKFGu9pL
         iePA==
X-Forwarded-Encrypted: i=1; AFNElJ/Q5PncbG/g/rEIpjid14tMLlMS3UJ0wvrZDKqqlKTz2lSnGO8rE+1RNnIX1N55rZT+SXvwrKgxAw==@kvack.org
X-Gm-Message-State: AOJu0YzU/6dHsRIxWjdH0ByBEH51+OcF9E+8/ZhUxUTA/jiKV/bLrADq
	X7TV4bTAHY/d6T0v6Ax8vIDNv1uC0yu/AiH7JltC2U1t7cRDhRlmIBPC
X-Gm-Gg: Acq92OGqSKKiEITyynWHFI56/yHQr+uDOIDSzX7+O/V8MleFxg6xrpzX5f1Tlo3jviD
	L26KvZtWfTnEhk8KwA53LcAiq134pJyj/EVuE/G/2lOoCo69eqCHrfw2s5XK3iqRmWEdhUOBWni
	qmjwco2wdcA5SGaVrYC49+zCblkMZDEq7G9N4cVhQUcpZa3jO3/ibsEG8ZU/hc9WwfSWWnjdYca
	qYBu+4jaBuwiq6+s2n+c7U3nKdUKpRmnJwdIUq0U+ZAX03H5JEUx7EDlBHTIbev8mR5Nom1GjpX
	njioJRE8RT35hMLQXFhmb9Mq8T8bPHvzva29cnXowv8iaN/EMWSNdik6+oGQM1LdD5RSbuMYp8k
	WNRAFS9ZhCiVDg/EQVuSTFD9D6lijCKvIFGOk17tXuyvvCX70ou6qOetOKJ0WviUqUorfX+Poda
	2mqSp3Yd73rpzLA2HFrGScKAdqwjAm2j1pJLlCHjJxpUIGIYgzr7D3II5E0FuXtatib/K+hLqfj
	tHb1bQg+/nYS5btNVmeIesE9wgcyHyIfOtxeAz1ta2iG4kwVfGm/a41f8Yd8Zio4xpvRiJ/2jdO
	hmP5RHgy/ksO0Z+QZH1TxpQFkO/MFbLrH3GC3Xw=
X-Received: by 2002:a05:7300:2314:b0:2f1:496c:94d4 with SMTP id 5a478bee46e88-308045f79b4mr137156eec.4.1781129352542;
        Wed, 10 Jun 2026 15:09:12 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30777ecf9e9sm22167112eec.28.2026.06.10.15.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 15:09:12 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH] maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
Date: Wed, 10 Jun 2026 15:09:04 -0700
Message-ID: <20260610220905.99860-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0A161A0005
X-Stat-Signature: w45of7uij6premkm9n7ngp13t8co18ar
X-HE-Tag: 1781129353-600478
X-HE-Meta: U2FsdGVkX1/9sP5DqWhdPpvOG2DEHUVFoLBZMDW6QdPur3B1AffPiuJvQK8D3aPZDTh6IKxbnK70Xs8+hX4AZrZCpEot9b7ZLTWrJzEBEgr7gcbLb03pc5YMEqmWzYqG3EUTs8hmrxjn+LTOnBnWoloCMXzkN0NSlEDjy2ujY5m0L6OK74NKLUNrSCGSFOoqzYWFdCLcLzzW6m1Q6xBDZxvn06MHWBxcPlpiE1bTxnCVmOs+1dFAPPYqmrg4U9BWS7yodupLWmq2pJbBRfGMMB733NLigIvRumpi3VEOOEDdLv8k2Br+WoVk12OMzfYC0tOUKI+g7Kcj/XczhOYTeMQIcJRwdFspFSEAviVM3YOWCDx2b31yGFkp6HxinvwmCoa/MliuV1dXiTvTmMu2cDvkzhjhE3Y+qPWcW18Y8LXL5UmXPHduae0/Y78cnWyg9YlVldgz5UmOgK9wICzTgZgf201dlnPK/9kM0eSaWuXbKNadI4WcOyfawOXxCaQhtV4OE65PIgWJENY3pj1H20rA9OlfY7YXfd9b7pmErOBqMvgUW6nrlVdzNmP9JBTYFtMAmZsfqqU6K2dKTVw6A1TSXbvoWxs7+jeHqkSx5thRjF5HqmwNtJMwOB7xOZ2UGucdewzBt5+zNkmTqHGoeRBYhyMevZSdrMCgf8szJAZ6On3he5nEE4SSvYpEb3AoC47ZJ+z3Xslfh83IueVuW/1NzIXUTkuhU1MSJcvLlJJzFJZVJfC6S7g75TRt9rrQp3ThhT3SNG9bMN+iYPn6oaDFo0IMmnYH2qjjdr/Ilg29HKNATOCL9DF4s952DmN2BAzgsoQjE+TOv2IV2U6AmrJrwn4VWz0fn5KsNPrJTze5OyI7PMtwtmM9ZPtcX9wv4SOFYMqKwPCHSsuD6lh9f0i7AW5RQumKIEeCO1dQlH14vc4xL+vV4LwnqG/xTCnsTVS6jSCLttY4bJcTK7h
 4GGlQY92
 cyCG3at7NppHSyYFmoe5PLVZO8T8cdZ1IT3QLlLRc8vSN7mhYBjut+ja5lJfNOPmttMvELM+LRSQPpToWnXZmXkcmgHTkP97EufXkmfNm5dYGll6IsRwoMM/iI1G0vh/GEWZ1D6r6AsBSbFcPe2etqivX3nSWUnYjrmwjlyMSkoOG3mpn0XPgR/J0LGpDYKv9fsbQzMAAJQNdLfajX4nsR17I1cm/c3m/QZ00xU40GBJuBkXLHt3S+XEz7JunKwUYjUItuC2AVleFiz0Xm4fKSoZMkuF4CTiYMmJh3v95iShB1/i7FROChK/egG+XM9mFUCsnBKSdKvIApr/rE3VOVWeqTT+ntVdEvvthghJdjy0GOFk+qAYGVh/b2FazvUPl4jVPkyfiy+TJOJ5zh0QxKV1ZEtsmurSQcxRL917YXtpuzxHa2Jo/Vef5iAonp3wF605ntZR/bYnt61Z7QiAJmXYWOp7rEAPpKFTNisi41eAbwoCovdwUu34S2FSAjhhbJOz9ooItI3PynVLco6Un+VWG2ZU7LE5gDwu0oxFDS7j/NfljJO9eOc+YiPeNIsUnXpPcTVh3YBkfTBJnAH1brfEzszuRH0WIC0/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<linux/maple_tree.h> consults the macro CONFIG_MAPLE_RCU_DISABLED to
determine whether to disable the mt_in_rcu() function (by making it
always return false). This macro is not reachable via Kconfig, despite
its name, and is not documented anywhere. Remove it to avoid polluting
the CONFIG_* namespace.

Discovered while searching for CONFIG_* symbols referenced in code but
not defined in any Kconfig file.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 include/linux/maple_tree.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 4a5631906aff..1b3014377105 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
-/* #define CONFIG_MAPLE_RCU_DISABLED */
 
 /*
  * Allocated nodes are mutable until they have been inserted into the tree,
@@ -864,9 +863,6 @@ static inline void mt_init(struct maple_tree *mt)
 
 static inline bool mt_in_rcu(struct maple_tree *mt)
 {
-#ifdef CONFIG_MAPLE_RCU_DISABLED
-	return false;
-#endif
 	return mt->ma_flags & MT_FLAGS_USE_RCU;
 }
 
-- 
2.43.0


