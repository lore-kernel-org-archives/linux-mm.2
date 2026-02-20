Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC284C55ABC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 12:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180DA6B0088; Fri, 20 Feb 2026 07:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1618F6B0089; Fri, 20 Feb 2026 07:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BCE6B008A; Fri, 20 Feb 2026 07:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA63C6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 07:42:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F1D61A0175
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:42:52 +0000 (UTC)
X-FDA: 84464799384.22.9682A1F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id A242D120007
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:42:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="b/eSpyAk";
	spf=pass (imf29.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771591370; a=rsa-sha256;
	cv=none;
	b=W+92CHWscYz6nZl5uodsiwZkk03yb8KrEiVOgFcsVP9MQ77exZtZxjXbDBk9pDwTzR+twT
	GnGGVB5Gzc6ZELd50riGpKcEwdlOaedsNxu8UM0KExKf6KSungYiozvjCSjzmm/BNbERGM
	4z4ys64DUcuNry3J10wVR9vnUm7MYJI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="b/eSpyAk";
	spf=pass (imf29.hostedemail.com: domain of sanjayembeddedse@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=sanjayembeddedse@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771591370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YUKllnwoQidCF+8PfJZeXrieG2MX2j2TwvAmx1Ac+no=;
	b=DVtAWmds450mJE6985ace4c56hqWSOSxBx/OnD9Uynct+c5brAOdibN1Ev7z9x0V9H4fcn
	SJonbcoCsFeMmTryFXvtqh+khOdhFwLhZ9KAdtlVr75AMeZXivv24fWmZBe1ix8CzmYKeM
	aORHfINSQI6oeheyF//ktUQoRG9PfEE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a91215c158so13875965ad.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771591369; x=1772196169; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YUKllnwoQidCF+8PfJZeXrieG2MX2j2TwvAmx1Ac+no=;
        b=b/eSpyAkE8furJ7hlBtGz8tjxnbby/gr6XKIWlG9SWDwJw3GVFfeXFzSEFjvPoq2vy
         gZsRAkn15Bcwo5m9Od1m3AQPe2Qmi+2LwqEKDAL44c6tYNRAAel/4NtDJ96L9A0519EU
         91gYcLpLEjD58EtXfE2T7t8rm7nq69gO4wtgCUd7nfdYimAFhgZlGhNPBOb0jd3oBFRj
         TPK1V6z5UlE8kO6jOVQFCzcxSFCy9dmeMxL+lJqS18ZXl9NNwE6uZxpeo43PJH2P81r6
         DRKGJAlX5Ef2kJLQCyrAxBr26JgFeQQdlhCi7NPtoyZtENPnXAW+oKeygg8bicSaoH5p
         ub2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771591369; x=1772196169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUKllnwoQidCF+8PfJZeXrieG2MX2j2TwvAmx1Ac+no=;
        b=xAoN0d0MMALVYP9em6Lq8xI5sVmqfHDwrJp9A1+jUZT1l+0Y40uBqlyXuvl13PTAYe
         lqhzOV06QILgVD9dJ5fNVxqDk6mUK9MxBOydD1HJGE0JdARpVz0/h1NljUJvISpLqGCi
         k3ifBD7ZY33AOkGHlS5699/fWqy8ub57B63L5G7IsidGd2jhg060J5LftOuRsvvjlh7Q
         QJ2QW148kW9Kb1Mbt9DZs77khNe6QzjYbY+N70rYNu56PWGN1kwLBaPtlAM8WCuvzS7Y
         cOwiP/WU4LNaZUOt22NSkTsmYMhn/HOIqxCkRfPXHK4hZ+AdlNrDC/7IGDzDKkbRfxqk
         GLZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLx+p5Y+/AgaJOMOGlKkcReIE3hLQSq3Q3An5tKRtPrmaDdKHoaq18hhUf7h3e7W+3CzG8+ariUg==@kvack.org
X-Gm-Message-State: AOJu0Yw4WLylraAvZvdo4tMe5BwRa8tWBUyJTjyjo8Ghb6Z5Wlqsicb7
	4A/lpVd67tDB1lTxfd6WA7bmBH6e9RrGOc352ynuZ+ZLeGDxIZmXrgrg
X-Gm-Gg: AZuq6aLVIOy2PPiwgYslTBl9FEIjnj5QrBsom/WpXfMH8sHd5KQmgwGd4836l9irmXC
	21OzeL49cg4mJDJNUYRNywfSBMDbZguFRm5d/qopG9BUR/kBJSjYwOrEH/rMX4UZulnOlblg2sB
	jCmck2ksNGDsYrucQhAYQvGc7KQ0ZeUjZN24y2BbKPHthXFkU9NCjmx5nm7jwrelb/QXjp1dTVW
	cIzgkhWx/tDDygv7AlTx2eYP2iwze6XOVE6tbtaUyoy2xoQPiGNB8qF1yASQ/XIaPoUPFpen+DA
	aB59odyPc8MHArcgj6wsbqfcV34Uuc38wfYkCHs3d/ZRdciYCcPEGjHmuqWgTUIDroHZo1LkY7V
	F9/th9EsMPFB+wngca9XWhPQt/sWKFXXJYGjog3lIi6pCU3lm7lMVg4Df3pdBycfjq7R0EKA+pA
	7lFAVCqo/lU20qaRWpZx8/hbU/Wl98oF6Ch2WgobWeMumQyG2t
X-Received: by 2002:a17:90b:28ce:b0:341:2150:4856 with SMTP id 98e67ed59e1d1-358891302f8mr8246072a91.17.1771591369225;
        Fri, 20 Feb 2026 04:42:49 -0800 (PST)
Received: from hu-ckantibh-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3589d8e3e73sm3001661a91.15.2026.02.20.04.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 04:42:48 -0800 (PST)
From: Sanjay Chitroda <sanjayembeddedse@gmail.com>
X-Google-Original-From: Sanjay Chitroda <sanjayembedded@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>
Subject: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
Date: Fri, 20 Feb 2026 18:12:43 +0530
Message-Id: <20260220124243.3264133-1-sanjayembedded@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A242D120007
X-Stat-Signature: mn8pdbfqfwda4ximwgdufpz8go9dcknw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771591370-359800
X-HE-Meta: U2FsdGVkX1/ANQjG5pmHwbXsOxBpgQMKv2HYYMDMo5PaWbqWcKo2RefdYyL1MUZYT04SicHs2YcxLQ0g/wwL7ggKMeYNI5LOeXUL0CTh0QVMXZe4EAmmB0J7TuwvRLLGgR+wn1O6SKJUofgh2EMPfWN8WiWxWoDlPetVzGdst8jIubbGj6LV9pC/I2ZOWKkpWrKDYUk484vrJmeDreJ83BafI9WkNu61HKB6Ptax+/TKqZhfMPxwQ41Eo7r1A4OMiIRavZ9dSa+Qd6PMBqZLtTaXPGNcaOQjBLbwViEYCOZfrlLavufo63evn2GQY2/WrFIdd3OgU4n6T16v1HCihslzYMuyBn50mGMpDmT/IF8VB8VTtfmyN7EMf/SQnS0wYYvvzddqIhb8ci+YbVVdWxKkFZnNR4XM4HMjvTsKedJGVqQEuVVuNKTcFmMsQ5l+53nM2sBuDtoQ49x6rlLBvHIoqmI1lCoylLGtwlMtLUE4XBon/OLAYB0UNjUIh8R69/s4IZm/nFx6wZalJiu8pfhQJz9Vilta0V5lGi0GZQOClqRiuu0+3WUAcqIc6wPBOz1omgEVEggB1RHMU4vWi0QNrhM8yChZpbW/4+aENw8ml6SH/ShOgAaYxLx8GRCjLFca17qWVVldN24gjfkS4NZA/ZX83WjcBkybH0S+L4asH/UKXvaDSXfeXXyCm0JmUQYwbcnHerPb6nC3wc3Wo54YNHCr9Gk4ad/CnN0mQNofKi6JTPZ9319ldhwVJ8qDvvILpHFzokvNqk+bq92R5p/eikd5ZSEXwDYGgw1ylLezVssMEuMRuRLyXDWHP0/mqq0c1kFvyQsJuuYnO/XSIP0UG3DFV4MTBxIYnuplqrWtPm/1Zh0UomAxjZAs4jwnneXBY40gn3xqcxSP4jwzK3QFkwHEB8trshRVgwNvmEzczoGlC5XK7RticG5CiA8qzX5KQeelnNSz2T5qm1C
 4nM6BxCI
 xI4TXYbR762ChRw50mbW6Fw9161Evo5SdeoWOymrlrv47Ktd5oy26qHTzHN36tDfiq8DhP6xYXf58O9tnhj+qmZAbP1Mh+0BCAtmzkIQ6mClcY6CF8pIF6JUrr272CaF50JRX9Cka3jKC9vzreLaoUrppShfdPJm+9BJWJiC+56uNdiVGW2gClcB+ySJ1quO7CJVcFFe97pRzqkFVOpFtb9VXu97hVGyH3Xz8G0hbOxF0fzfGBYG2obP2bbRTgZIjpRTwOYyv6t4jLPWwFS6hzAjX6wT4RGVnjoBzp40Zpm1QIeYaP0+iFaLmudqwMlEMnBV1s/EvIXVy6t4lV5/FTjHsINpXPujBP/4YKQgSnVvtHC9X43crLY/H6uiBA028WCuczeCyz8aLZqF/RvYnd5aMP03kgAYlPnau
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

The ksize() API is already documented in the public header, and
Documentation/core-api/mm-api.rst pulls that canonical doc into the
book. The kernel-doc block added to mm/slub.c by commit
fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
introduced a second definition for the same symbol in the generated
docs, which makes Sphinx emit:

  WARNING: Duplicate C declaration, also defined at core-api/mm-api:521
  Declaration is '.. c:function:: size_t ksize(const void *objp)'

Remove the redundant kernel-doc comment from slub.c so only the
header-provided documentation is emitted. This keeps the user-visible
API documentation intact while eliminating the duplicate-declaration
warning during `make htmldocs`.

No functional change.

Fixes: fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
---
 mm/slub.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 865bc050f654..3f58a485e95e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6309,18 +6309,6 @@ static size_t __ksize(const void *object)
 	return slab_ksize(slab);
 }
 
-/**
- * ksize -- Report full size of underlying allocation
- * @objp: pointer to the object
- *
- * This should only be used internally to query the true size of allocations.
- * It is not meant to be a way to discover the usable size of an allocation
- * after the fact. Instead, use kmalloc_size_roundup(). Using memory beyond
- * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
- * and/or FORTIFY_SOURCE.
- *
- * Return: size of the actual memory used by @objp in bytes
- */
 size_t ksize(const void *objp)
 {
 	/*
-- 
2.34.1


