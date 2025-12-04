Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF70D206A7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CFF86B00A1; Thu,  4 Dec 2025 09:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A586B00A2; Thu,  4 Dec 2025 09:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648436B00A3; Thu,  4 Dec 2025 09:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9B66B00A1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 181D8129E0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:22 +0000 (UTC)
X-FDA: 84181981044.27.D2A7AEB
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 379A014000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C5caJYG3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857600; a=rsa-sha256;
	cv=none;
	b=K+6XBw+Si2lTPFguwOekiJCzCqDY49keMyw8iCNeMaDCbnagf4Q85EdL/84Gu92mx/82Wn
	tucAj6h5bpCNvSKfSWf8HSmGs+ILGfvFyojOvlCwj4vCGwCbPtVwWA3AGvqann3zN5OWDl
	lqFmbwH8Q2aeLPt+msbGrp0ROBNuBCA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C5caJYG3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGnt8bTKaac1K6msaRLVltkt9xGbtE5aMKqhuya716s=;
	b=OolbjnkpYrr2OmMiDXZTG7tfJyfzAGHmwmtA7QAGXiOyo/ZWq2rO8R7hmeMiP+fJdLZTUt
	jJQ2SsAIakMLHzWLN6g1nVaPdm+HjwgNisWPexPfUB4KCYM5Lu8OTaqyVJ63QXjwi3gm2E
	fdeqm0oPX8kudwzaxv+ETTGVsD5D1dE=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so617206f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857599; x=1765462399; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sGnt8bTKaac1K6msaRLVltkt9xGbtE5aMKqhuya716s=;
        b=C5caJYG3tE7si67fBNl70Azm1lg1snkAC1UmiO3sOXn79hhd4MYAuA+KTnrWtaYaue
         xNeICm1wHAzub/OHa+12Sqrk/sIPSlu2BKFYLUyri2DVGPYxAdJbNYD/iAS0qNF5GP7N
         uPwT7iQfsUbQzOlVyWvDqyZVZb8OM+Db6jrhJYFdpBDw6I8nzfT7OsR+hFyWgVWZKanE
         Bos6zFFOWUkjG+WQj2rfqajQtOLDPMMYvcQA57zfQfj59UZqPQ576L4x5e4Dv44J4Jla
         ETiwQekwGcb48j+Z/ePsjHbW04XhifEZle1EmaZat8yCn3tbyjFAfA/bLNJvRwzm28Ko
         nsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857599; x=1765462399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sGnt8bTKaac1K6msaRLVltkt9xGbtE5aMKqhuya716s=;
        b=UHWHeKrXCjF8cBmIm9QWSDXfADyFW4UL9nfyhjMBAA2YT4svbWLHy+8pI9QOTkgbtq
         E+HMAN28rhDwLAdcpjMYboHExltShwwy08ejuYcZK3zLNuJQBJNypLRYhC55JX6HBecY
         6DX6ab2tE9rK8fNR5Txx5cGPN29k/dAmm4Bcvmt/cObNStvXr8tfORhD7sKDjlVHLlaK
         N5QnDopjftDQy6+E62pecwx462w7vOiTRaGj8rkZxoJc3YyKbd/TWaLBVVYZl1xcIb7/
         HL1BHW3MIqUn0TZmJedu1ewJ0qlJaDdoljqpYqfHh/kthUG66v/zT0s1YWagH9uwKgOq
         vdcw==
X-Forwarded-Encrypted: i=1; AJvYcCUAr27Ww1P8cN+5h2NM0J/ZKu4xqtnK+SQ1Lply5chD3ngTOw+Q74Mdp4VpAOORFOimr/N+tYXY4g==@kvack.org
X-Gm-Message-State: AOJu0YyHCIc0ePMMiE+yrHrSM6RcF0D5rNRhLJwQVQSo+bzQvh53/bFw
	mpT3nzr3/8DPP84gelxhjqSMshQDjp7RxfckIcOhHSHybcPllfGEdK79
X-Gm-Gg: ASbGncsZik6EDfJvOzO/25DQzn8w8gNxjztuA6e4j6of6BDCX+Gy3UTDgxC6SKYsTVH
	BwrUvkZe700/aPLqIcxLfLbukSj2IiuF/UGNtmBe46ZD75KbniuaSGjiP1xZCjqwi2N58cwI9nD
	HEWe87mJUw+N1uvrkM1nSEf1XeYQ/cnjYEEkee6K9EE53TUBp2sdxBAun0Sj1gWaUEOcw5AFrCg
	8kTkUw8IhvozTk+D3VcLgEfztdhZTBzlBwbe8uB9Ory2/6nBoHX6lX9Wu01yEUuZ8T83K5BmvNG
	wl7NIsanF3YrpQMEa8+r0xyicJrOjlmrgfzps93j539UByZDx2Q49fpJS4EoKH5LBjKZEywhAbh
	vTMACk3aOfdbWlGDWYfx5r/jK8W7fsCenTuPgp2uIRGchWMcj7o/3FjGLv46A6/Ac+GSEZUCiKW
	iUe3qPkdBG7hKs+gJfaqn4GYFufi40fjYbsngTfD++JXaMEOlGE+P3PpLmYsIBb9W+3A==
X-Google-Smtp-Source: AGHT+IHxDahYGwa5aI52HyW8cxdFR6RMIDSPOdl390+QQfG8ySHaxkFn6koa/YtHAqSa67lSItxZ9w==
X-Received: by 2002:a05:6000:2510:b0:42b:3a1b:f71a with SMTP id ffacd0b85a97d-42f79800f02mr3172811f8f.23.1764857598697;
        Thu, 04 Dec 2025 06:13:18 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:18 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Ethan Graham <ethangraham@google.com>
Subject: [PATCH 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Thu,  4 Dec 2025 15:12:49 +0100
Message-ID: <20251204141250.21114-11-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 379A014000A
X-Stat-Signature: ntgeocf3it8cppy9zzu5g4jyuisyxtbm
X-Rspam-User: 
X-HE-Tag: 1764857599-596348
X-HE-Meta: U2FsdGVkX19H7f7qwbcAOD8lkZj6wCgceZjmmsk/gSkOi9jL882vr2NAYXAbrxJaSILBwJwr3JNeRh4afsoxGzEGIlCA6CHd4/xymQEbLWW1RDgMWrDQgpj7zC4i4gGcQwNNd1yI9GnLvw6qJYHnz18Csnsk/afyvyGerPWOJLz/XrQ8w0h+ZsmbN46d7AyDJ8g3FCCjCPo0XFIE1XrWAT4CMDmnzqmBRtOB0TcckxycAxwABAuu8+VPY7ynpuZ6UtVPA/yxq0rIBbedpGTDquFc1Ga12wknVODtkEP+vTTFSq82auXFRpuveigw3Y9roH1YMDX03zVX3SShoOobLUXiIlte9hjhd2tIELnl0IKuIGoBkr0jLFON1qGBa3NvVOpXMf5O+BfPRc0b3+CEEux/BiyCOqBQZDgFFBafKLnkv/iolktaJ4sB4FDSatRC6XI6FWuAB/u6E3kk+8k6WwFuTKy00Ey8dnqsFy/K4OdC1nUXAwxZpRA2LZrXQUoR4qTtmkfkUx6e/a4YVGTYLB8MqjzCKFzG6QpbYDFZJVvN5kLeV35yb42tovGdczLxjHTp/agXf31M+JjJ5vFWVv7e3dnMWJj5S584nx+8fjdGfxWEo0Mqq2Slt6i8SkzkqZaf4pFEXVmyxyU6lipFAUn1c6aHdEPn/GIcR61N9W9kc+ONRNRKEi3QRwXVXLUpZbTIFwk888fHThVA7Sk0b6ACle+HIihGqUAwRb70ZhnOr1Yvgc1QGBRB4kEAPJ4Ne0Ndr5ckLMdAaElSvs9/DVb/gw8epPX7kYToJ55PGbsHAAVfM3/skZR1p+5+2EPnTRGpVHLXm4XZ0/JiFGx3qFLPVSxCFLfVEkPAowgF9RFTgvYtRioK7tAy0o39E3dn7OgqoQlQqhPWYo6uAG/gl5x+rFZ9Z5JASUBGGCSNUE2QaO58Bm/1+38cDx6ZXSplfimoLOIGRcMQzgptWim
 nqYTcTTA
 2xOUmMPI+jrTUZLgCV/cvbDP45JbLmsK4FD0SIAUBy+eRY52Mgh/wB+279ef/2IZKWyeMmLObBEYoj4fe8wjdU8AXEdP67sVM9cWqXZn9m/srR1TbCnx0X+kvpD75dRt+PaB/TDNxeBAuJHvsi4Ap+C1v5dBqG5YOnMBff86NPI4xZgY9PmVmg+LDSq4IxiZBZlp3mCgHSnROCvnzwwpbv1eqSv49eGgq+ZDFYZz0vCL3+sJn+SpAA2zfUGMO/nOvc32ePWroz2VaiBIUQUIguoHCt/AyyxTeNxrjUqDFDK6PsT/LWTHg0FCrsGpLxooobteiuwzt7WZIosJtGGDfWJuaaeVTHWkmzHAKbhO3dm4aw59wM9GmN20l77NhEtwV+8/4EFn+TcsyA9skw8gFRxHUp6FTdMVOUyOKEsaPBFgJCcJrHHuQWcN2a4w2sEIwHFwTfazBT6f6tW1bMIgvnqjcXY3+4es3/8rBfO64DDJ3hDczffKdT6a8OWH6qpMt5cBfvG0H6PHR1oiHwx+37YkUBQ74qRpsAoaE9+LtrsWTaMpHIJovus9IO7CDwyggmT4oxH8cFxdiO5akOMMLAcBGnyqNF6Ke+Ui/EJe6EQBLMkVwEMdH+rSrhq/Lf6r5ZyFt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Update MAINTAINERS to reflect the correct location of kfuzztest-bridge
  under tools/testing as pointed out by SeongJae Park.
---
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..3ad357477f92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+F:  tools/testing/kfuzztest-bridge/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0


