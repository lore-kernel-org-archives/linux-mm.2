Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E9ECAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17FD6B000C; Tue,  9 Sep 2025 21:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7566B000D; Tue,  9 Sep 2025 21:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD606B000E; Tue,  9 Sep 2025 21:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA7D6B000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:00:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D6E459AB8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:00:44 +0000 (UTC)
X-FDA: 83871535608.28.B33B3DB
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5AE6C8000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:00:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XsgQSKz4;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757466042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gYtIMNwewtfHP8BnvSKdl88/khkNxOHcpB9SEjCgTbM=;
	b=7z4Wu79Lj+vcLpOOxXQKgUCem6CU27yN5EM3jS/fokzBYZKPIq4L6gaYPP/DX9YWia9Gvg
	he2DLHu7gkiWDajwxp0dXBx8lZk4+FDtbfsm1f+KhGEUEzpvdPsLA3PPzRu/4IFaWMZ8Je
	6edGR/Iko4Gj3Sb3qn+VaZ1bLhvlu2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757466042; a=rsa-sha256;
	cv=none;
	b=S+9kWBq57SM2UNqxJ+yRP7xl8aBLsRR/IhCyVzu/1KNo73cvDKkVP1Mn6UybU95bIFV3Pa
	nIHoIDEXbmI3vcqBiiK79t+tzFZKF6FC1gdErXYjsmrxLVUlISLOrB5hck79gPxM2ISFBO
	hRYVod/tFNzH33eCilNOY66sibrPvfc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XsgQSKz4;
	spf=pass (imf02.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2445824dc27so63294155ad.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 18:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757466041; x=1758070841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gYtIMNwewtfHP8BnvSKdl88/khkNxOHcpB9SEjCgTbM=;
        b=XsgQSKz4ha377TnOX2yIP/mFhkBsPJkhWGkXqCnSKVkMvOLWAgsyexvValUseTkoj4
         5lo93oUrX6BxmNA+7QFVXi7fgq3XlvjXUa97I0dsbtfbI1+mRfuvaqsylRe+7NiLRAm0
         +zzqX+NMDEn57GqT2CL1h1sm7x+LLMDIUXAvYxit84oqCoDonj/+vu92TcVAtV5k6neF
         SbB3h69SDPtq/KsUy1w431acCalwnj+1kbaBNZLixZ6pLWeQI+FOti/DpczR/vEdp4b9
         bw3sXcyYu6gUTe47kQwki8bygfRHYvEnZlTPcqh3mmGTFRajOHi1QiQeiiWFxjAk/zjr
         CX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757466041; x=1758070841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYtIMNwewtfHP8BnvSKdl88/khkNxOHcpB9SEjCgTbM=;
        b=Wzvo5GDp040EE8zGppmjKXKfrLpVs/quB82WZwnZUj0VqKHt+QT1dvLovWVNMH+DJZ
         XIOyw3p6MYMmJtKwbQxrrlL9AWjXpR9JdX1euq1PDMUSecbZquDQhrRVm9Yo28o2Xah3
         +hQt2ZJKdHoAXK2FTsl9qwredwV60y8rr9nMruMn5WMkR5yd18XQpUH79JjS7tN/iXOd
         gilG7nA+sUyOHDrxIToIaIry77HCBA65hLQK33RZ8lEHlXHvKF9Mz38jVngGAs5gKK4Z
         sPzyZ5Cd+AV1xj/0TuiL70xXigldfzrM3YnGeI2sGit/HHrKw1DqYZZpzGNONIIpNP1m
         bkFQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4gUEWxVXCdh52y0FsPwWI6M1vs/NSIPSKsESj0y7hvDzV8Yeto8HEDZCLL9GYdgmWJLt5KNifvA==@kvack.org
X-Gm-Message-State: AOJu0YywoLbboa0HMdj6GF47qkZlvKWtz3bgtBA6xZ/NMn5y1W7hDyeH
	umw8jD7dc9+FJCmA5G4JcEW1Two1NviJxGhrWKiLdEr6rfQLTUh2qurZ
X-Gm-Gg: ASbGncvOJ9fs8DY0UeKfRdKunC/Bdw9V5WwzqwQMYo01tV/jgHFyjgKw+CgMN/+sDvN
	BzpXJ1dRlsb8qWVLn+OsnWV5R2uXdRAloagk2AAwiJvTPafT6kHYkWXwF8DBCAwxLqXNXoi0Dkd
	2epL7CYdfYK2Frvl9RrRG9Ay8sdd50Rw20qh8BkEso/NaZKblg8xE9vtpl2f57R2DsfPijKhJRu
	C+0V+c9KgMF383abPhvdFTE9hp+ISNx33BraMPuhYbyCx1Dfi5C3+mLYXz4xcvSa2Io+CSnEJl1
	DbSfcnh5Ir/+1ePMoAfVGECghEO50bH9QlxkogCRRqC7pfxalXQLrOhBtDCNixeCxbbyc48eTJO
	7OKWxVydhQA5NMIHUcxdzECb2kxHObhD6WfM=
X-Google-Smtp-Source: AGHT+IHsFSeEMBKM1x7ICE5JA1RNKFrxEW/Kh9/xTIxKubK9qJVAkBvLbRYdXVICltIthH9H1/yuBQ==
X-Received: by 2002:a17:902:f68a:b0:24c:9c5c:30b7 with SMTP id d9443c01a7336-251736df08emr188158855ad.47.1757466040977;
        Tue, 09 Sep 2025 18:00:40 -0700 (PDT)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-32dbb62533fsm416564a91.25.2025.09.09.18.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 18:00:40 -0700 (PDT)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: cl@linux.com,
	penberg@kernel.org,
	rientjes@google.com,
	iamjoonsoo.kim@lge.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	roman.gushchin@linux.dev,
	42.hyeyoo@gmail.com
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rgbi3307@naver.com
Subject: [PATCH] mm/slub: Removing unnecessary variable accesses in the get_freelist()
Date: Wed, 10 Sep 2025 09:59:56 +0900
Message-ID: <20250910005957.54108-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwinwsd6tjhdx8ng37bimagd73wc44kg
X-Rspamd-Queue-Id: 5AE6C8000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757466042-930710
X-HE-Meta: U2FsdGVkX19smyNG9kUqUTHiFrlh8AFoVPd4bc4b8YmDudquChPpCy5vPhrXJzpzgxrt5UjA+XuYJQio7rxadAexYwk9bMyC304Bkc0Em5w/5cBM5CqYlzv1gPSVC0QQfIFQx6rMs+CluLG7GbCJMsK8Vfz6Db5SeZTq8ck8+DP2xq755roFuHPAc3I/Sbg7HllYb5MBiCWTcuijK9d954mrui2lUWVcHlpXCZDTowNssa5fiMpQ/rkfFw0ebFKVid1SyIr71XjeGUGnRqfPguFpkgjq1cUELzLQe33ExgBWkblK3BG7AUeZwUlu5vnA4VxCYpocuUNnw8vMhe82CSE3XC0Q19Ae20MW6JLOu558wEM/JV6/fHKMx0ByhIvTwW4/tsmSF6A6qGHSZYBnmRMVvHvCe1ygSMVFrjSdQnQf5P4jJs1CC2cgnpGM6XyegEKjud9BFMQ/tWmpTNrf2gVS3n1i8KsZC3AibUMBkLvc1+viWOBCiJGZYVN8M2kjzZ+vCHNxtK1oWNjsblWE7d3ZGdZNO54QVp3/GIhXMIbdr8rS8tCDVGy27z4pmzoP0wggzHxIcjWAuh1wln8IaIp7SmkbyfcB8M0zE1rHMNIbmXD9E6jIQhsN0OIxXq0CkGS37tKkfB7ncnWANVBVL1RXOAngaKwOmvrsAH+LsEXc2HOYJ9hFuF9yAM8bKwoOxZXLcvaVczzpAp6xDhe3H+S7mAQB1bg1W+ZpwObjsOJa8/Yf+yF2Nu5KtuNbAZ0RW4/vwU/RgmzdYv7UXUObX4rDhm+G8XgDIPWPTB/RYKcqxCV+LQnYZey6xgIz/OzQInJn2Sh7iELEYtm3sFW+jYanHU793ZoMowTmE4nbefmx9GUyotlhi4yRTkqjWtS6xK6iwjWCKXrAbP9ayZvRd1eCefh6KTPCCeibb40ctFL3peWGSo8duiHlsdOpMLghfyGxVdqhRj/90pEbqpj
 gFMS0avL
 1q6P9gNxOUaNWrRZWww73oOKVqvzJanM4zen3APRS7lekVQCCIuqrQsi9AoRIv5s7A0ZtGTBmeeIanu9J/4QTjCe3ixIPa8hiZ3+TddP6spBAjsB342I8l0OGuxEJt+QUfloT68+f0Bmga/gE4Y2SSSCjjPNEirsVTEZhDyR4LTn2nBZ68u8w0LGeYYcpk8lKaAIzeNYknn1zHzpRtzXcsAZnfqerACZXh4EcaM881rxzYlML9lg1D86vW0FZ7Vjf/ANGZ5Qpcc1mNW0bNVNhmoUkKDuYxxB6LFwBer81MW8MgjJwxiASJbNzPFeSh9tHTkjcP3Xza1igb27kCZ0/jyp+RuWViKTMdFTba8dvlQ38oYDXyo7pX214bv/AgbthXdl8/ikcmjLIcQuldrxFgbWccM7wbjpO7NZ1IPLuLKBYmd10op9RD7FxTi8gFO67wQ2XokZiA+hTkknn4XIcT6EnF8gLgQltML3bKVc+rDQpynf+4/uZsk71dhFyALNsRCdpmsf+vdVJl+qcWi8rizn3xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It pass a NULL pointer to the freelist_new variable
in the __slab_update_freelist() function so that it don't have to re-fetch
the variable values inside the while loop.
Removing unnecessary variable accesses as shown below
will reduce the code size of the get_freelist() function and make it faster.

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 mm/slub.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d257141896c9..2e305a17a9d7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3654,27 +3654,14 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
  */
 static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 {
-	struct slab new;
-	unsigned long counters;
-	void *freelist;
-
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
 
-	do {
-		freelist = slab->freelist;
-		counters = slab->counters;
-
-		new.counters = counters;
-
-		new.inuse = slab->objects;
-		new.frozen = freelist != NULL;
-
-	} while (!__slab_update_freelist(s, slab,
-		freelist, counters,
-		NULL, new.counters,
+	while (!__slab_update_freelist(s, slab,
+		slab->freelist, slab->counters,
+		NULL, slab->counters,
 		"get_freelist"));
 
-	return freelist;
+	return slab->freelist;
 }
 
 /*
-- 
2.43.0


