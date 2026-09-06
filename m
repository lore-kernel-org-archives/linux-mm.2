Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FCEC79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F126B0088; Sun,  6 Sep 2026 13:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600406B008A; Sun,  6 Sep 2026 13:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1666B008C; Sun,  6 Sep 2026 13:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2120F6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:15:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 936571205A2
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:15:29 +0000 (UTC)
X-FDA: 85183988778.04.1D6D963
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id CAFA5100006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:15:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GCtv7dZj;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788714927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5XKjHfAZ1qBeB6DtrQ8eKJyiOtO1aHUJGx207Xurf1s=;
	b=ruOkGh3ZILhEdT34/Q7c41PcbXDhuS2nWX6aTqm+/dcdVggrE4a27ZyK7/SMZDJbr+n2Ga
	owZGDQ1sIgdr1qJpeF9KZlp0rWeIvx+/gHsF2BI2h+TQTBhIq8udQG+J2kdodDgmp/TW/L
	szKvI13NvgMF6hOSyBVvjTbcpB5GEag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788714927;
	b=7fHFMx1unO7wenCD5fefD0SBpBrVVy6ppArnZTdURvdBUk/YHn80D9NvlVV7li3v9e86Ja
	znRvml4GJpUWEhhmJBDJ/2xUwiJ0fE/5H0Lt/eaXhVT44DaLKaLxFPbwa2pZaGU5G/WPCX
	1zJu+36AIlrc/nVSGXrDWbxU/YmZUmw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GCtv7dZj;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48436216a98so1730408f8f.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 10:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788714926; x=1789319726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5XKjHfAZ1qBeB6DtrQ8eKJyiOtO1aHUJGx207Xurf1s=;
        b=GCtv7dZjlZNZEqqYmCljpVlYOPTtTByjKHjlPcISyc6JlMMk5XZgqi53ELpRENUiM2
         g8vcSk2Jj65MTHSuJ2kBntdChYU6l2eSMQjCDXbT9uFayvUR1FAeN2ZFK362bNdGfnjg
         kIM6srxWsZ79prlv+FifvPpA5zjnqMp/dGZMceHgR9zfhmoZ9Rcw94zlTBTNoZYlLLAa
         gv4yoP58dN0FcBWhEtACocLAzn9TflEVSPUwU73PMvh8iE+Ntm9y+0l+89Z69fpc+cRM
         wrwPMySvGvz5z1ZA+nqE3d3m7l6I9iOajR9VIk6nPQ5E/o68ip3BXtqX801hy3YU058E
         OGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788714926; x=1789319726;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5XKjHfAZ1qBeB6DtrQ8eKJyiOtO1aHUJGx207Xurf1s=;
        b=rtCiCKteq0aYTwhrH7HyAiakg+m5IMwm+DU6l27rZVy6Kcby3Nm1msqzBXmVpb/Fhj
         kkHrxNKsCv2ZYXHM79aLVwR9aypAwShfFmrD9IbA4wThCoJ1I6O1gErUIudHb2OVzRFC
         Wc8teD6+HBjLFjBmFDeG7wFh+pLxqIYUI+LEEntz1fggZ5Girgs6+/vVOcaVwRohy+lT
         u5NBcqoW21MmFq5XUJpmzJbY3YE+TDKbFJ4wvV2vpQiqR1sSzIq26B7Sw2jdWHVOi1cj
         uEbkJLAcFl7rpwZ+X3bElGR+xY12+XOjOyj8pE+GJLmGwvTC2/1apgOptRnwRtUflclQ
         kbAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJTPJZlPaZq7wA8M9YgI8N/bPDu3oNxddF+V91daEKEKbC7A6ZiarolDxCbzru5i7jNh2KOxxrfQ==@kvack.org
X-Gm-Message-State: AFuF++mvBUYLSKtkBLsgyrrHEHm7TgqIBGRUciKMi1ccYTj0+VD10vOq
	eKSE9gDgl3jL8bkx2vwD85XuJF2yGeDLZWV72L/4HngSbbHmzX7t813d
X-Gm-Gg: AYBFou2LHIz5BMaD/k3EZwnNsyjT5T7OyGc6llBrPyMAyGgJfY9C6L6dxAiPiF8R2ZW
	CgW4J/QH4rinPL7d4BBS93Kydm+uCZpPlazss9gcUYaIgo03OraxPdqLxKHrr+tTZ6vf8/wGOM6
	BHxP57hvERG7KV6PLczJl6IiVN10V5mMKxDAWRhSmh1+RCAxRNOrm/J5cfgs9V7eOwn5CCrbjRu
	RuGQyLw5YZPK+bY3L+/6xHMTT22R0CU9RtMKF4K/YkUVhy5tO80+q5BfIgMH7sPcwrQ2Ay3FcyW
	phgZ1NNQjpLqXJdl7Ep7sGYGcdp27WaFTsF2R9lr53DZytx1G1p3LwMgSFFEL3+ZdhhlAKe2z9N
	2EiwZ2ZPooUZ49XPKaLQoyHr5K0RdfKCL27XhRLJ9l0Xr4iXCWWoekfBJckD7V6qk8oP9kku+Wi
	1rDB65XNphxRKt0+L6hNOQnulNj4D0oR1Mu/9k+Nt6EyHp8JO8ja3H6lPR5CLwhJdXSRBfTCOGP
	Cnk6AV8MKl5RSINOBqKsfmhGapOuTcFB6b3eQrca54A6OWRkGvOFkaVWkSJJve8VQQFg56CAdJk
	lxPnxBCKWgaTydoBD00MY+Nazf+A/1Ha4j41sCvYTTrRVRe/KI+No9mGFXAVLuPXuazex6JP
X-Received: by 2002:a05:6000:41db:b0:485:8c17:9768 with SMTP id ffacd0b85a97d-4858c179982mr14804427f8f.42.1788714926191;
        Sun, 06 Sep 2026 10:15:26 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9d84-5101-9c80-d25b-14b6-410c.310.pool.telefonica.de. [2a02:3100:9d84:5101:9c80:d25b:14b6:410c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858ab73c2bsm21124742f8f.22.2026.09.06.10.15.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 06 Sep 2026 10:15:25 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH] mm/secretmem: Fix the enable parameter description
Date: Sun,  6 Sep 2026 19:15:23 +0200
Message-Id: <20260906171523.3009-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CAFA5100006
X-Stat-Signature: yyhe67xzp8gxhxitx6tfchobnmnt36rz
X-HE-Tag: 1788714927-853904
X-HE-Meta: U2FsdGVkX18oqV+adfDh1xP8ZoLHraI2lXE4CXuQ3Y3o6qZ6HP7arXdK7+nNDAKT8e0vubppsP/e2CDqANWC+t3MstRZhuuBPFbX/Gx490T2B+5U+YlxQqWDojzNG0o3iYp59U/RXSBWKmdrvdxIfQqfyLNoKArrArpPrI3AEx7VSOgGvMGffQbhsmauRt/K/frjhEvuGNs6wT/WTwZUX0vrMvnargSibmiMpqZw0fwlQZrsc2KhPZwo2hBdGNhpMEgVqjuK3sq7OkqlDhIf1yri5TAIwzfcgKZSCeaaZZNpSkQ6cgR7JCXRxn+/zm5oMH8n5jjMJcES1jLhdPVkHADzMKdQXoQnxWUcXihRCPVg4C1WZNGOIIYQFlajqH44A72ofU20KfvBlTEQZwJf0/QQG4Kc8WhFsN+limv4qCgWprLHRCTSl1gAl/9CoMFbFqc2AF3R9GI9hsljJvO2FuSqsymLG2KoEAe7ErOMTDPSYQGDkn+ucJDgyidfp4J6S0Kt57p4bccFWVOeP0qPeMV0iowXr5xKullKY9VfVEmztNPwMnr+etG1q/uVX+utPiWlU2GSQaKywnkqhVSqtZrfassEfFfLUZNM/6gQzIiECjmlPDQNQp9VNEGhKlfmnikTBsqeqb52gVIsKqEPcpqnn+0ZGGQDcnLc7m/uLhtF4+ZWQvozmtDJ7AoalZGGw/ze1KlRvEsoCsq6TIJumZcZilpWK22yaLICTps/Ps+Botp6hbVoZZNgeD/GfDOD3U0h9bQkpNtwHeanZzc0gt71bgnseGx2uquht2OQw4WKpUWihTUNGV+698Rjx5lY6RjkXb4PP1liamoGoRqpyHH1k6rvqgUED5Rvy6H1IRa+KVSq8qe26yDjtCZ66pytksFMFskrKmlg6HfKLOyIsfk3QM0mKLU0HyMbQxQJaQ9lTNd6ps+NIRwVel9Ixaat1u/0QrH6eCRKZR3LXsz
 IIvLers3
 KAtDObfrX66VWdE7ddCLD4uGKYVncMU4lof29Q+UH3kkO6tDjOtjCrOhD+/lyPshfo+E+R19k1RZlpuFoPR5/SYazxZ6pprSbblI/zGKupG3W1HMqbnjpnJjqnoa0+7vWcac7lBV8Gq5HB+mL0AoCUmq/9Za0bdgA5nc/A0Z0cAzh5sbTsEzy0HKuk91H8AQUNYOx4oUVuGo9lEIsU8dxPEoelV/tsvS06S32fOzeF8D66IRHIpppzS8rN2omD5rGtQ9Kbjjo1t5lkKB0vK73El4avFg3nl7v4IxHBq4LF3pJrDB0tvzyAEU87U6A2c5eMJBWW0xnzeCjS3hrSB143ngSu9uQ6pW5ohZ0Dis4dFX9wHOY9Wxgpg9KrblDvIe9/y3QfX22FV94yN1kAbflpfnHO4TCX8uKbKoX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The module parameter is enable, but its MODULE_PARM_DESC() names the
variable behind it, secretmem_enable, so modinfo describes a parameter
that does not exist and shows no description for the real one.

Use the parameter name in the description.

Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/secretmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index 384f5cfc457f..4e32bf55a599 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -39,7 +39,7 @@
 
 static bool secretmem_enable __ro_after_init = 1;
 module_param_named(enable, secretmem_enable, bool, 0400);
-MODULE_PARM_DESC(secretmem_enable,
+MODULE_PARM_DESC(enable,
 		 "Enable secretmem and memfd_secret(2) system call");
 
 static atomic_t secretmem_users;

base-commit: 986c24e0fe44f844b44d365b71ce831947f50298
-- 
2.53.0


