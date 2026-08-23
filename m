Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA83C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 15:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394EE6B0095; Sun, 23 Aug 2026 11:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346396B009B; Sun, 23 Aug 2026 11:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B906B009D; Sun, 23 Aug 2026 11:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0622B6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:49:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DBEF1C0FE9
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:49:58 +0000 (UTC)
X-FDA: 85132970076.22.56F918F
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C4E4180006
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:49:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QULgv/JO";
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787500196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C7zkviamvc6bRFbsWtMqYEFSXg4kaO5aw2vbwTFQBGI=;
	b=jPH1WfF6K9fVI5Nm4/Lz6ZU+tYQKz2mlt1UzSJ1OSoRP+4FYqcHsSkeBrS4f8LIerDTAS9
	4qs0Enlsdemzeoj9SVn4kAEogTQ37gSZ5PdrKfR/ZT8xUKu/uIqRNy1QJ6ZQ9fj0XhKB9k
	wgEjZxIuCjUNR40LOcqKVEBtrnZzDoY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QULgv/JO";
	spf=pass (imf06.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787500196;
	b=Fuz4LKTwkMKI+DmCbP+6H0V4IO8otpvndagSZE48Rw/gZgX0EwEZNSaSKkI60B/vawfQky
	SLJZ5IvYWJQksLOc3dM0ebCR3M6v557REn1YN6HjQwTE3rYuv7v7meqxwWVMU5AF08jEsu
	JyB5GCwXmkOvIUxC/aHisuGlwGeIdZ8=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbee3777e1cso1545701a12.3
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787500195; x=1788104995; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C7zkviamvc6bRFbsWtMqYEFSXg4kaO5aw2vbwTFQBGI=;
        b=QULgv/JOQrzbO27YswFATUaftexKlCk0VI4oGVoP2FYwql3vvoNgdyb+I9oD6nvKjh
         c4rbb/gDIkAPFgZ8KNq9EzTbJ6fVMN4luydTiJQHO/KL1voiMYLzmMVBKSbulNiqGB0P
         hBB7ZunxRUrz+pNEXslpJzV49XE4yxQE2mEd6ZG54M6+orPRVq29FVDUhgwZATCaYJiU
         2PsT2FbyZDdtmwE1X3b/pt1w4YnK2eRgasII3n0iLKxBv4zh5wLgWVTWFA6ujvFZ+9o8
         txr5rqUMdQ3lgTf2PjVIj8gVmhQdym1XYdZqCJbCneESFrDVVg5MRxahZIsYZgaExAKG
         RASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787500195; x=1788104995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7zkviamvc6bRFbsWtMqYEFSXg4kaO5aw2vbwTFQBGI=;
        b=CwU2YVDvuArwjKh61R0258671lBsQG02GofYsakopGxnJH0g0zgLD0UMWpK6B2mWgy
         D0l0DLIfv1iQqu+FDmaOtCiy4RAkSszGLEC0lTlizL4H86MG5sEWzl0VECN5DXaY0R0V
         vE0rfZv8Y8TUMqR3TAm1ZlmA8KeO5v/3AOMowj0w8mqjH2COFPVb3AknN8zB61jeoQ/8
         YvOojCsOHxpe2aArAMFx+JET1+i9uT8wAFyLRoOSt3/5g+ChB8E3A+AmfThh3HfpQIq0
         xQa69GH2qlyw5qQLPCbAmM4vfQ7a9u10mD4DJ1IimGZ8vNnjS4fGqr5uOarMhyyRbO1T
         8e/Q==
X-Gm-Message-State: AFuF++nnP6I81Urnve7AOndvkWvTFt++hi4knIEalICRrEqtHr+Rhicl
	QIQRK3LsU3cf6uDtQU2xISRqcBmwkyIhtcieocYb2xCpsMo6UUUOfxIz
X-Gm-Gg: AR+sD12g3HHe2cQ6hGOswXW101MMlBuv9FJVqiv0ufrCYuz0q2DIvh1NnOiyokIsJlM
	uNNWH6H/gn/mFFW1BHh35EJ050bqLQbmceWiwC6IJ9ckQcVw7HLvb4KfDHGUJPDawBK47f75D7K
	GvHorrmVVYXSZ+APhSAR4a+rZ06J0aJ+A9Fmrb8k6m7gp06ASK9jvY287G5SS7l4dVmXh/vrZYQ
	hVsPAnHFZxgnE3C3mdxY9rHdJavkHIpydvRMH+bA9b9X0aNFWgJb+SVKVNCa2URY04bVoJeZZaF
	F8ax29csdjkkc89mpGpp7nTnGulKOahf22d1pd5XKCQZNHBsol7FS+TOz84Mj6XIwSOm15V1vCs
	ergq/UVVpYY1ksrckeFn58tTCThz86wporQ+gEK9/KETFQL3aH7EOX/XKUlp9C+MW5cKDpfEt9Y
	8yF8e/FJ0vIDv76p+ay/koJNzdABroqxUp878hQpDwkQrM4qWZ0Pv5XxY=
X-Received: by 2002:a17:90a:d60d:b0:392:6638:2e6a with SMTP id 98e67ed59e1d1-395c3a49e08mr38286844a91.13.1787500195009;
        Sun, 23 Aug 2026 08:49:55 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e49b5d8asm6765393a91.7.2026.08.23.08.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 08:49:54 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH v2] memblock: remove conditional return with no effect
Date: Mon, 24 Aug 2026 00:48:38 +0900
Message-ID: <20260823154840.3793140-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6C4E4180006
X-Stat-Signature: ec98zp9zz8aqfdxwc8q3zdw7161nndjb
X-Rspam-User: 
X-HE-Tag: 1787500196-119264
X-HE-Meta: U2FsdGVkX1/dNk6jPFlN2tPuoxDRYqBcci8jdXXyTs1LlZJP27LmZjP6zIsRpk1nf7lcPIwJJ0SonzBv41eZYWfxXf4UtKnpq8fumiMrKEng0B3DYl+JDraEj6vARvxbIhpZxbOAvQJ384j9wv0f3u+rnMdIWB/4Z6Sg+ERHr85yIOuLKxb8ocDHheBCNnob9sKzTzvzlWm6Kr7X6Enc6isLh3eEm+8y+0T9tVwIdbuDpVqGtPrF6X9ozV5rsuKkHPzgMdqsEfw3WrwsuTrXaxYiwOkuzSb5LsrRNthllOVdQnZJF2noU4saNx+s8pIOqLUZV6+/8PJnIuNKpZM9eyfsqVLqVWZPWQD2EsM7L+HC7W4BHM0R0Y3JnDX6WDSn7yKDfVf32HSgTlQ7R+I1WQxnmurw51thlyEBJRoCJScxpz64AKsHx3zVgMSZQL2/3KUfKYc/kneKerVbaKuNFJgjLLSeHA7Uj3Y0m9AtxpUwmhUMVvXQ/YSqkOdaJr1ZeUv/n7spPfzU532TbfpXbFevfGQsKqNRza1sTMTUdLZvbS3telVZhXtrp7RVipw4Ksx7E/FlWLyvUczTM22o4VF9NLqCB4XWxm9NQlR8kC+dB0R/u9vbruC5CUybuNJWxZMnpBXEJkrpWjmCviCcb6Y5xdqSLpacomk1PBPIntYESCmCkVVSu8RQb9MnxdWfEwtf+pRvLNAipF6MGpOfgEFWQ9/do8dmFrKeFVKxEFkZeRcoK9s1rTgYM0Vpytizwt8mySFLyftmO1oEpDzYGd3kuAeHtCCrqt53XMJoeqOcS+EGK2yCGSFWWh3WanCuTByzb3DNgo+f3doluPQQU+y3LaAp547X+NzDrrSfqW3T7bCPBcMt4aymsOdWANZk+0VK4gXV55+u6AHMxI9ZtlA7kvWnM106YfnPPBsGAiwHTeLoPIB3iuRbPOxJzE+y6CjPvAEQte4yYiTG4l3
 lvEv3QYv
 AZJB/Q+1kJZELxEw4mwDXQ4pfoXl6xjatBhTu/VEdHtCzowHGzLkh0yATMk0wQZ/BP1//hBpT6vRyc9LrAguRw7nvDeBtk3hTfr5wIUiUnuz3WErQeAsnaRV5wW5/VjtV91SfpnzIf58ukVmAzfvIe5/bTCxgTBDzklhtkdQcAhtp3eNcEapvYOMolv3G9Ykfo1cnBVLVbGn87hKXeJbsgf/hLO/txU2mDvcWkwwHy4BBH+O6lpbLyBj2Y6q08dVsDbNjrNKH2o9hk5UmhbNsiPd5/5s0I9eCpiUyi6iPlaKSwrDw9Bh2UmrFGWKbS9hM9A3r+bdg28p6MVM+E4CzbcwaVkAD9eFqEgkQXlVWOnnXkJiVIIIaz9ek5rZl7C7oM/Nz9ek5/Vy9PixkChIyj/BXKbIKlxMTxehb6zpO8MG+YWf7Kxk5Pixokw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
The memblock patch of the treewide v1 series [1] is posted separately.
You can find the Coccinelle script in v1 [1].

---
Changes from v1 [1]
- Change base to memblock/for-next
- Filter only memblock changes

[1] https://lore.kernel.org/all/20260723184538.3888637-1-ekffu200098@gmail.com/
---

 mm/memblock.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 43e036f3e11a..9a31781923fb 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2613,15 +2613,10 @@ static int __init prepare_kho_fdt(void)
 
 static int __init reserve_mem_init(void)
 {
-	int err;
-
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
 
-	err = prepare_kho_fdt();
-	if (err)
-		return err;
-	return err;
+	return prepare_kho_fdt();
 }
 late_initcall(reserve_mem_init);
 
-- 
2.43.0


