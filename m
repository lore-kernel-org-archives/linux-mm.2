Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 081D6F54ACC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8FF6B0088; Tue, 24 Mar 2026 10:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D9C6B0089; Tue, 24 Mar 2026 10:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421376B008C; Tue, 24 Mar 2026 10:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F74B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:49:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3836140181
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:49:20 +0000 (UTC)
X-FDA: 84581239680.19.23BA442
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id E644F40013
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:49:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TfJGJrnU;
	spf=pass (imf01.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=hank20010209@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774363759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gSh9sYTNfvPCviCi4VjGmuUXLd20wXWnwnWNNQiCwBQ=;
	b=CEvI9+pPRSbjSU5zMsxZFyluIW3S3oGQdDJYpkvNBfHlBgo5fz/FxfgRit+Qr3dGXxZ+Fs
	sQH/8p2z8LUEUZk6b3ugbLFGDAskUUj7k0oFxOSHkR4qT+p1u6gWhcTkZz8PEmX27Bav+g
	5HUZ5ubJHAtgb6dFW1YuoniVZ+DCmjE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TfJGJrnU;
	spf=pass (imf01.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=hank20010209@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774363759; a=rsa-sha256;
	cv=none;
	b=yJ79naDu/UkprnFw7ypW4kvoju9o6Kglt8OhXgWQKJe5DF5MJ7Unri30kYEuM+b47WiRAb
	Iv+9MxQ9Q/Q9Lj7O26C+bJSMyxmTdUYn6tbvkwb0aa9hc3VLiU6zetj3Wv8TcVcL2jzaVZ
	OfWljg2j8k3iRQ8mBomPZXYFGSPErXs=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so12835145ad.2
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774363758; x=1774968558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gSh9sYTNfvPCviCi4VjGmuUXLd20wXWnwnWNNQiCwBQ=;
        b=TfJGJrnUPcDWj13hCiqYqEIJGV27X62YhbRGHyG42NGjGtMVeiraM6FscDgh0xuXOe
         nP+U50TO/Oi66MfVS5LnOdONaJwvsmQhkJdS//RtWzLzOxABrai/+YIa9jbAGnI0222Z
         dVrsPm5EOnwWKUnWNSU7M4YZxAs6e6FQlBeQBKLuPiZZV/csAIjurM47uZmUcDrAy4xv
         22dOaTnB5wxxzFJGjh3rOcFvvDC71qfY2Z5HKjApOycwWNN2gjfSZ+449rRSXsRTWGCk
         GULZQa4Ulsts2VyPufRr0HAi4WO+qfaeAKkhd2yyGGMdrrmiKnJbsmgJ0xB5uhHZReCt
         nGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774363758; x=1774968558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSh9sYTNfvPCviCi4VjGmuUXLd20wXWnwnWNNQiCwBQ=;
        b=IKy19YHlD8UTmdodjbmhy5gEBSJFvq2QtO5SGHmkWmnuzGSqSCfzSlMLlJBLQhPJ0S
         9u1nNyVnWNWl4aDRhrAQImgIQ83PNC2Vci/iJPe70Z7RUiNt88QLWXeF3DkxhXHEx1jC
         ELnsT+Xcvzaw/1/zkZUNg+BK3EA3+Dmc9WndZzgqT6BYSQZJXYDTt0LI2q4Yl/60mlkz
         mt8UUputVbg2pu4nrcCcF2Hj8PhQZ9YiZvLkpjz2d8fuaXth/dEqXtI2FFZRjMnkrE/Y
         EVJYnLgIJB5trx+Yzg4f9jVqeHOHzrSJ3ZTXkR3yf9D/45rHiGx+0XtjeNNZZ9pNoPMN
         KJgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDVFKkqOIwshCit+QGzdjLMFBSygeEjvTBkyLZzgV/2rjfFvhaRKWxVT4bNMQNn9wZ/9i1k8hR7Q==@kvack.org
X-Gm-Message-State: AOJu0YyV/1bXOVADRNQV7YEV9IMjTEKGkpZW6z7bJ57enfmy8368GVOz
	eW6JdDJQVNpH+k+GWFYj6Gq9k1ZUWXnj4qF72XE86gkzSAHbok9Mmtyo
X-Gm-Gg: ATEYQzy1TTsDlNuyHYsP0InOVOVLKt5uMkg/PrrdF7cMmKItUAC/sDDsvqbr77v3hYs
	PF0vEOuFmLvtIRJAQ0/0LlQjZnwPZOGFYdthJcVh3n6wiJTSc1/wh5ZmagjWoviVksg8Fpz+sX7
	6V6E2TR4P6xcQjGmdtvNeTaN9HSEG4akhRKFC8904YpY9f3KcgdgiwytJpL8e0PY6Sebd7LaIoC
	me96JkGApWle92C6eTxlp/qQc69EcqFTgqR5FW8Hsafuy6hk74MVMXFKEzbzCHKa2WAvW+SayJ5
	WX9ebGjz98zBCciuqr5y76q9II7DjPTdiBuscOKlQ2yeEfGCR087YnHtOrAuc716kfK7ytHkWfQ
	/DDaKrVlSHKhwIlmXtr0dQKB8F2mm5sLr40XnCQbvESyEYgfFR4FIsGeDMdNz/jQ/lx31naczxd
	/1Qgfs1dZHMYrAEL3p31PgpIw=
X-Received: by 2002:a17:903:32c6:b0:2ae:55eb:f82d with SMTP id d9443c01a7336-2b0826d751dmr162082965ad.1.1774363757621;
        Tue, 24 Mar 2026 07:49:17 -0700 (PDT)
Received: from fedora ([2402:7500:a2e:a774:5078:e5c1:bc34:6044])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516ab1sm201252325ad.5.2026.03.24.07.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:49:16 -0700 (PDT)
From: Cheng-Han Wu <hank20010209@gmail.com>
To: sj@kernel.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org,
	Cheng-Han Wu <hank20010209@gmail.com>
Subject: [PATCH] Documentation/admin-guide/mm/damon: fix 'parametrs' typo
Date: Tue, 24 Mar 2026 22:48:51 +0800
Message-ID: <20260324144851.12883-1-hank20010209@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 14g9kxo5ynuc3p59q8ny5kuj9xaykt54
X-Rspamd-Queue-Id: E644F40013
X-Rspamd-Server: rspam09
X-HE-Tag: 1774363758-692115
X-HE-Meta: U2FsdGVkX1+J7Uppl8Jyhn8i29FimSeeTzkc2HtOD+sP4FkF21qSjfUt3o7tFXN6v7OlLzvgOgO4/q1EzLZGY3sL8cmCmRPWiLPpMKwDa1LPDSomAAYW7mHw+wJLSIEsu11KnYjZfVZQvBsxlYBMJyjceVCnWnnblLt39100Wc/tRtBSOUqroUrgHlu9t91Zd/57AbLUg0A9TehdE/EdodjIMdBxykBlY4KyJ50vFqpdZaF/cQVxB/D2xwlHKJD1pZzlt0HPCk46e8qrMJoHb/wJdGqK4fhsBpaNwzo4vpeFqalmNWbDiUmZm0S35CvK0G5pK9Jvwkr/fXivWT+Nxr5g5Z7XaOTuoTKK6fQQGkcG8XvAPr2WKM8mf40quqmIe16EIUpcNqX5tEPCdFj2kU97GAKU1jXtKdjBF4Ea7zSGwPGOvVFBojVoH4lxa2eUhgnOWJgwbrIXC9ysejdzdGds+BhObSgyJVkTNtKe5sGpYCI5cKYaB5+IPp7gwlk2ivdYAqilIeUI+utdj+i+pxxrMeomQj5lRahxYUnnaUDLt5+9/0RGYQzTOxxd111FKxFe83Qc3p5BrdiZP7AlG3Q9Cuh9xrFo2ezY5283HHKfhq1kGLtttaqjQFCunSIzJvmTLIZwSdfeIliKkSVOajzfRn+jjwxb+QVVgAeo2fD4+4tD6gABzYsAySSgc4AidOcao15+HI4WDiLFvQMCfAOihVjxlGug/hf2+gzwmSF890xoUj9SnVY2dew+2PVWmqXrpxkFfc7KLOt5EoMp6eNo+gxo+1HnSCpU6sGOrSv5SdKZjB6ollh5/hNClxXv3XZqG8DQEeewKQkPEWFYz+2kwK9W7wAl3uRiKbftIh14lxabZzh27xu34fu2Gc0i4ZELXER1xSDqQQPgmjlGddTiR8L8CAFzgAJUw783W8uQR4MVt+OcD/Y3gKoL0CB9Tybt0le57tTI/mRJrb8
 0E+2BJkU
 wonHVDrCjksurHI2bMxmeilgv1V+/1JEY5U0AGIKYvDleQgm0Ietj35CKZ1AK1juZ9D38zQ+B4cbz1leNojE/5em4zAyK0lMS7+bhesp1Lasi+hKu0T5N8e+sjlbvH2dz/jlcQUwySYPuchggigkBfjXx1DWeApf2nfL7N7N22qP4wKLYvohdso3kfx6pd/20hRQ0Eag3A5yoprbTRn4WKlunTlWYO/FFXwaNDWEDwcj7ihApST7zIQSqdj2Xq8RRJc/AAkLU26DWZRCk4l0Etf9zDccwdNaK8IMhYrXeli+y2gco2/XzEXailAMo2edF2fD8L+O3E/Z4wHkEPYszQAw5ZgOVVnldNLcJ+YXE20L1Ih1BhLIettH93xmEIk4GL9GmaBknmQEW3yJY0sFQgzq47mwBxYH2fGQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the misspelling of "parametrs" as "parameters" in
reclaim.rst and lru_sort.rst.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 20a8378d5a94..4f6a644be2ff 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 8eba3da8dcee..1f54a2d270f5 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
-- 
2.53.0


