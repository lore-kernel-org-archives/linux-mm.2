Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5038CC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 06:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821676B0088; Sat, 17 Oct 2026 02:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2C86B008C; Sat, 17 Oct 2026 02:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF076B0088; Sat, 17 Oct 2026 02:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4EA6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:32:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 986561A0128
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 06:32:03 +0000 (UTC)
X-FDA: 85331148126.19.AB73CB9
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id E075680006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 06:32:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dp6m4UpF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792218721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gFJIItUD6Bm1Jl/9pga1RYfX1oYrLogK7vi+7ExnOlI=;
	b=0D1oEYi43VBnOyqRBAh88AVe4FexsMy4YiQp6qrwkEP3yhuB9wvDZbg2w5hHOmVAdC6/UR
	9VeaM0WTFcoH3lLBO5zO64i09hvLOAz16FTwL1mZXBRebkCpkJB+eZpkDiFHO0qopRqlMr
	iJnLjyrR/ZIhGlhDQTNY0zz5nq7k4Uk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Dp6m4UpF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792218721;
	b=r8BiLj4Hc36iZV2am44V3ouJN0fWka8V7Cs7GBaKEcFnfeNRSVlT2TcFZ5SqJF2IKqzDYB
	KGluzA6qbZR9RNKQW/GnjmXDQzCTf97dVCIjCutH1lBcCTx/QP/xyGkEL6qx1MA4/asRJG
	7b+Dh8mXt5khwt4kIhylyAF5YpklZRs=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-35f1f76ea84so987780eec.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 23:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792218721; x=1792823521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gFJIItUD6Bm1Jl/9pga1RYfX1oYrLogK7vi+7ExnOlI=;
        b=Dp6m4UpFGVsXnNRU0y9hJLZDdHjfPcRk168mSdZ+yhvd/YBS2H0f0oKXvC+9CZYA+i
         YwdClf2+tsxJKM6q5p7FLo7+O8boAfpDoyhpvxlHsTagPFL4m/UoFgijccu425oRdgAj
         U65cm8vnpu5c4v+beeTdCZ83+ILxZLe5uDp9DcYlj7wNLl1iIoCNcWgX1b50rFnOq5bv
         DRFmm4UgkMfXDlVMj4CwbpkduEQHuoDImEtgWjSkL3HHvTypQM2O4HYiFk4yNF2fTwux
         hmtnNk2tWCQ2iNgFtxl8j9WJp2BaWy6f02QtNJkB51ShgxyxErFUR6SoI8egbxlpS1I4
         blMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792218721; x=1792823521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFJIItUD6Bm1Jl/9pga1RYfX1oYrLogK7vi+7ExnOlI=;
        b=lmBgAo5/+OurWleqkiA57Y7gDcMREeeqxFHJrr1+5d4cBzgAbQl5WRSeFMyOh9lYWk
         XsqOhzppxzb1Jci+VT50n3tlTTPlL0UaX6AZWSApPUSrlNbHiRG+5zv4K5/K43xOEk/Q
         WJrvHPiVtNRR2Qb8RT4f1rkzQULPT9xZ3FUkLxxGNu6A18n6udFiRA81ldtYDvbCUR/o
         2yRqx8/FIjEfT2mnOWksr90cTpIEqaLZeV0aVqjU+8HGVBisVWlnuDUkOZXaY+AOW/2J
         sW+n/knkKBnClzMfAvKrTq2jBitR7wMGXidJUwD6sMLJE2HRRVV2z8XNU/je7sW8GcKs
         x41g==
X-Forwarded-Encrypted: i=1; AKwUvBwjVkWc6toNSM6iFEt/6qhREkCBrSMs4yJfz67jdQoih27VobJAkpd0VFVZecJYAFzcUh1R3ehYsg==@kvack.org
X-Gm-Message-State: AFq9FYKjybAaiiwEeGbsTETd1hoeGo46yxuLCxpgMdq5E3lGmr34jAtL
	843Po4k+6IItBY+byfhuU6HsN5ABv/0gQjcye07K7Bv2v6YnNPTSSa62
X-Gm-Gg: AYBFou0NnpNXtGdZIWbm/wUXuTvGtaK15IhsPuBa1jp9Bt3t6Dw+1pJgIlf6WseSnDj
	C7Ny+DuaxlRvIrc/SZ6emvN1LAPmkK//IIJmRhZfTsLnnOxUDqQizPRoDLIPfHPpxJAFzDu+7a/
	UOKlJIGEbPmFXSGyzkicUeW96WRQJA/Xzx4r3LWsvxKtyLCOkiluaozz1qGEP6jVjw5UaYqZsaP
	rGkKjwfeVAZtgRcWUARmObN39c20zAOh6rMg037GQgYWPeSubjUjy0pfDsD/0MssR+h20MKlQmU
	5JDiGM/wtuFyJiObkp2GFdCu4/qgpbJ+Kc67g0z3gDv5EJvcgSyUkbTsjkL+FjvxUcnVM/nZ0Nr
	cg0+iAFjBeP/h/1q6V+/IZ9ndENieOYbe+alhkdi+jIs5bVHBBCMNgUzCHRqUY/S6SIiUfSctTO
	3aHKvIwnJyCSThUYqmwSMftLIXJUZBij0JgVpjP8IfDgsDcCaD/eVNnefkdFou0zdX1J9McAizd
	nKQRX5stbWvxxzhO2KVaDj+U2eATmylehT6P80m4xx2iJgsYWcdqbh4bzYlOKJNNsv+0Y0bZSYK
	7decZ5vvKXsjfyvkHxYov2eztRJbJpFV53BYpQqzmanC31tB/A==
X-Received: by 2002:a05:7301:428c:b0:359:525f:74cb with SMTP id 5a478bee46e88-361a195b342mr2373779eec.24.1792218720406;
        Fri, 16 Oct 2026 23:32:00 -0700 (PDT)
Received: from LAPTOP-97G9G880.bbrouter ([106.51.148.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36082a7b33bsm22374749eec.24.2026.10.16.23.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 23:31:59 -0700 (PDT)
From: Karthikeyan KS <karthiproffesional@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karthikeyan KS <karthiproffesional@gmail.com>
Subject: [PATCH] mm/damon/sysfs: make next_update_jiffies per-kdamond
Date: Sat, 17 Oct 2026 06:31:52 +0000
Message-ID: <20261017063152.994182-1-karthiproffesional@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E075680006
X-Stat-Signature: rkhk1x7eq9a4cndeupgp7aei1mfsmma1
X-Rspam-User: 
X-HE-Tag: 1792218721-633862
X-HE-Meta: U2FsdGVkX185BbbI4B9XxTHpcS5TM/0VbgAnIsQf4CcciCNxUU5I/o766THOXAeBZSTxlmxelhMbPN945XtVv7c+02vVXoMf/nOo0LKHFufaEPORFr6WLls9pQhUziencVjcd2AvEc4twICzmRQYg+5woh5be/PtzRdNZeVCPDZVmyQ7fFza2OwlTHdXR/wHsZprR5zlsjR5Gq7gwS73GR7TvBjS6369GbRowY+QSt4pog8QLPIjR/hMNQpYppKSsd9xEj0eGvFeadbi9T7jJ9U0nAfUKCqunpwLnegSVt5pm9F54UiMZAXypVplgtJFEHXGuWLzVT3KdoMdnBwLLSvXUCkW7VzUDl+1iFucMA3hXGRQQOKIQ7YEhv+8EAx6iI8ZnUVJhRGJyXuvr8rF0+ReO4rry1DQyPop3xvv3Kw2teEHk+oU+Dow5d9cmh93keLkgNhzRXi/eFLruUKuaigBwGjN0l8ZLlD24GkV5jgnI+mp3v7C8+d17B6Og/XtcA8efO3A3d+ArvAxuuAwvkpwOw6nQdXRLqNLktQ7S9Pm1tn+dxC+1Q1F1fogDoTeYVKMchGHdPnC9uvyvoiHh7DaqQ6qoNCwPoLx/2FOEJfXQM25ex+IfmAS+4vlzYm4zRXiTWH7Xmvs6Gz/0SFTF1ttFy7uusv0NTxyJFdUwt2oJX88mgcBfM5MjHnXzVN0qiBqUZuqtWCefB6+deGs/JtKpmtOrD4OUDhNUqiDZ6Jw7leVB1FaTejMWRk3/FHMSqA5zGCj69uXV+RRyJjKRVsu+aEV7qPrtdgBnWwMLOFXIqsyZlwVgsI0wSaT03eq6eMllqQZTBu7PKTTLiy2Cs/vHtooQXKavcBG5C4pxNTi8ahioR1xhceJepys/f9v6b9LPsOQrOaahKpMppAHVwKFUuPYU/ssFGDFfjvy+tBKC3Nlmnopf6l++lMoW17qpKraVi+PIR2FJJkqkfw
 M0kALmLe
 PyOnn9EYdessNWfNjQM2jkIy2n/bJm/MGsmY3nKwY2egWaYj1+ogoCCtyTgGJpV6qySDrninRei2cBvYf+akEagYBZ0cM1NjtiU8AJZKlreCPAGYlPbJs6z9Gy0EJc7dO0EJDG16Ac86MactQlfO4oD0RUGchWPAdMmkNuxZxtfAU6g9EydBU3IT6BAAXSmNrgRRjrcyTOK5AI4k+Wuyqte0kwXNGpMDaV42CzvephPSl2NNfHwN7ck9j2MeookMLgrPD35zSYyh/YZ9ZbjMAm9LV5BHGQ4S3pq5VXzDBzMrCazPDzzZ9P+9681WCZXrWFzccdHxvIXre/yUFFslTGQPvtpC077l4g6eW1vQ5OSfe+vXD8v/F8gjhix5CmWRmpJIbjX8HijmLYMwR8i4mGAw8PKhrZ7iIBmp2I8VXhq8HIHOBoJBkIE6LJaMbhlSaRmDJGIjgSt4jAQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_next_update_jiffies was a single static variable shared by
all kdamonds, so with two or more kdamonds using refresh_ms their
threads race on it in damon_sysfs_repeat_call_fn().

Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
---
Testing notes for review:

- Found and confirmed with KCSAN.
- Repro setup: QEMU (x86_64, 2GB RAM, multiple vCPUs), two paddr
  kdamonds, both refresh_ms non-zero. kdamond.0 watching [0, 1GB),
  kdamond.1 watching [1GB, 2GB).
- On the unpatched kernel, KCSAN kept reporting the race on
  damon_sysfs_next_update_jiffies, again and again.
- Ran the same setup after the fix, KCSAN still on, nothing reported.
- Tried the same with vaddr kdamonds too, could not repro there.

 mm/damon/sysfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 160292f077dd..872b89f58bd1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long damon_sysfs_next_update_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,18 +2216,16 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
-/* Tracks when the next periodic re-commit via repeat_call_fn() is due. */
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies,
+			sysfs_kdamond->damon_sysfs_next_update_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->damon_sysfs_next_update_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -2274,7 +2273,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
+	kdamond->damon_sysfs_next_update_jiffies =
 		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
-- 
2.43.0


