Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB7ECA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 14:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376D28E0146; Tue, 12 Aug 2025 10:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E778E00B0; Tue, 12 Aug 2025 10:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DB98E0146; Tue, 12 Aug 2025 10:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7228E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:13:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9292160351
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:13:26 +0000 (UTC)
X-FDA: 83768298012.10.445C132
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id F19F320005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:13:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OKF0N0aI;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755008005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a0qIlZAnbmsEop7bXptIK6g/iAVRWR9GRGYEwk+FqxE=;
	b=Mh8UrGZK9Z5McUc9h6DQd1OzfRa/tr41yD/y+5lEJNpTBwnFyjb9arLoKweDFZwHzcQewJ
	k5PGKdvYRll0p3FaDYKzVv+gZjHMa9ahuktnHfMK9UynjeBiCs+kLhjU9rHlczUi4RvwdH
	+XRGJgob519Y8ekZZOb3ilp5ZzPf5tQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755008005; a=rsa-sha256;
	cv=none;
	b=A88k3M7Mo92FBOu4cnfR8VWjOyB35m9+ITldRC/GG6iHIVt86GhI4eH0HFZlotGJnLTexM
	+6QUupSpFOlVst0bUrj8eAl6xS++HtszfaF101v7m0sW5ZGgeniM76mDOY+xQGkCLUJh4w
	3lP+74mqZA2ip7LnuxAIDz4s5cDJtlQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OKF0N0aI;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b429abd429aso2997354a12.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755008004; x=1755612804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a0qIlZAnbmsEop7bXptIK6g/iAVRWR9GRGYEwk+FqxE=;
        b=OKF0N0aIqDvORQ+LhUy2Q61MHSdoYnKC0KLkN5Eqd2OXhkUdxcAMsd0RlbAUeF/0Ro
         U2cQhIi7P7EJGXvEn6OL3SWmUls4v4U3QMw3/Ig79t5XHN30P885yV3nfRiD5T8q/AcV
         hNWjU/FXjNad4NRuumB9zXuu/QtbA8thKz0RhugF01igxeGegtYMHPoFc5BlOhscb/Nd
         ghQiy/NZ0QSW7Vv0SkztdNtsg8CcYYCz5v+ixLUGfcIcDYG8yNy0Wn2v/TpzZmNO3Rx4
         pp3yvHoboY69RrzThrz5odEnF5muIX9Ne80Jk5zmy0jflt1U4kIHXRFn/hgGRu8OaaGu
         CMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755008004; x=1755612804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a0qIlZAnbmsEop7bXptIK6g/iAVRWR9GRGYEwk+FqxE=;
        b=mUC/lPwY7t4daOrS2XGMkyuplc01e6G8et82JzjWXVYaqceNQLmBrd1RY2PsimlRLg
         11VuWzA8TtuhwcxWxjy4lBlwGySzDIt7uCTe2ZBUoQKyiSDr3Tjpy6mxymjM3lgKyYgi
         jlvZPKg3E0bxU3RbzKCQLtDRC1LVcQ+kSk0RGmUnCS3y7sheAkoX1Qsl5/Am3V1g/MpR
         gpo65Nq7Vk+3yahdiM7xNrzWDfdv8Nu1h/GB2LILWYX0Qcgb+K3Gso2p5FO1VoCak2Zw
         J4pKEBOhbn2e/d0m5wx7rzrWd4fvAymRPZGKM8yaP61eW3YEqMRkyt/0UzQin4HvNXaR
         8q6A==
X-Forwarded-Encrypted: i=1; AJvYcCUaDFs6/ewasyTGhUtPsJsKvVphTYfoA19w3CgZYbQJ52xIX8jB+7mLDC9pp7kyHmNN56UfYcKjEg==@kvack.org
X-Gm-Message-State: AOJu0Yz+k8O1voSK79Taric4DR8VLB/lUcYaCxSeDsoXGBAc4K1BdBE3
	xmhqBa42bkl6luMuzpfuYFAdY4vSBgNPIcGH5Tv3mXfnrFX5IzumPwWU
X-Gm-Gg: ASbGnctAn5FTH4LC9+JfguPMzMQHgFnGHmb+C0LSuPa6NRCc9gtJ8OELyDDFxyxAAl0
	xSTnVld9Wyj5pk+3AGGcKGjr7sLTQUlRe7soQwl6nXa1Ut6Df1+QVvQqTgV4gJFVc1qAGcjjm4j
	+fg50W5zSLPmOrFIax/q1ax8Iyg/Sh4ZEMA8lcDIIiltbkDeqBG/Thd403LeFFeQueTR75i0W5r
	3DZwUndIJV8h7Zx2++JMFoIYyrs6zkEgzIbUiQAX4cTipxDt4PWgJvNUdJNdB5CyBKUKWzPopb+
	VyfJN9h5mUIoprle/7y0c4eyoZtMNyqekeDOo+KwoHUK+vkHGQEH6X2ntU2Pg7gbalLLLD4NJ+Y
	NetPDyUfg9MhyQFMY
X-Google-Smtp-Source: AGHT+IFgK5KRRqi8Qvf5NAZ4PCDhsz+QvcKxV1nn7l8sqcD1xBfuhyD90pduF5AubqT1xPb72OCNDw==
X-Received: by 2002:a17:90b:55ce:b0:31f:867:d6b4 with SMTP id 98e67ed59e1d1-321c0a3ce48mr5270805a91.10.1755008003647;
        Tue, 12 Aug 2025 07:13:23 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3216121ec0esm17978865a91.10.2025.08.12.07.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 07:13:23 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH] selftests/damon: fix selftests by installing drgn related script
Date: Tue, 12 Aug 2025 23:00:46 +0900
Message-ID: <20250812140046.660486-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F19F320005
X-Stat-Signature: wtradspxfpc6yi56t8h3cqmi3i4ez3wz
X-Rspam-User: 
X-HE-Tag: 1755008004-228803
X-HE-Meta: U2FsdGVkX1+94y7LVQpb/zN8kdzo/0J09vIBs2X/gfwaitCC/saFQ541MjBP/+y30OXHQIUmbT5rpraiNwmhVJ8huhZTOMSLmJJe8u15xMz6nIsBorRftRCOGUw6M/R1TPSBKND7HghklolnhVhecOMM3rVsfwUAJZbRmiHg+gtBA7zURzt96/lLJenQYdYJ0uGLIyh2SXm+dJunpCNWVLZrQ8AnK4wCd2d46uVxomrajCqqoLsvuFrRgyEfra3yeHDPPPhUyAmgmxraPuQ++1hu2LUXB5EjDXIoQBgB+4D6fvKZ7HlEEY9OtGyuriMiRJEhOs87oxsyZ+02KTznunlJOTnRh68yBdIlH8R62PgnwiGQ9kGRpxo4Y//FkNG6RSiiZorTRt3nR+yFcvPMzJw7JI/NBg/ddoqhed6hyiMvQXdf/gl79He08IyAtVlB25Yz9SmA3mmzhDc5UAC8jMaQh951ZbwVRub0/Y7jM0lNei1N8Srmky1HaX/clIqWtZDJS2bso4hh02g0SDiqxY/616kaL8FQOaGWZYzr3Ol1OeCR7xXvkT7BwEayyDMCXgFQ2LCWTTux0w7KRpeNjzOpWUxFuyFSmozlEpsXyxUyN6z4mQeJH0i1EYRd7pISGC7aMYq0Z5cVTgEGPg83gu7Pd44sKR7To/waqR6vLDvzHirKTp9KzaIMZnCsP/Y/WCnMDq5GoLIIxxQDwNUFlgL2SPZ+A5vjpoLKunL6Lh+Gfof8kLSagurYyrUiP2kr3TafInakdnfl/w8JqMBqA9dWxN0IIdI0P2VD95bhAII2MKFbaw3fVXT2N8CHbvicIWYetcjgEKQUvXoAPSzHM4Ut/aGu948gALbhq1xDwJlZydup8WEEdiYSFBsHY5usd2NVlum8nIFMt6G8bdAics+Ss4cnSvGAI30uYRDrNqDx3oU3P1IAKfYVFzK7i5mCYFqIXiUymww6qpZS87z
 vCaKMywZ
 boQnixevAss3C7ytWruleVVAqNulxjpXM6yD7m73TNTh9pM67urIHM7QSiXAnJ3FgQ+/thoTTA4cRMKrJiFZ6r4+Dw/sWQHPG67+0PADj5ccPAzvIMjXvXYRQec4OPIKxxOI/vZ3M7Q8EcqAn6+PSeUos1zBM0z1FHWs2sRXIHohQZXS2yPF38BvJspMXx4UQEdAHQiNK/0CE/IZ8mwrbDfXx/cE/HlQ8n88MmV5giP7Kc7G0t3MwIqmRIDEnSMKnmZz9tzZEzvGAy8aQgDrKG2TmSE+5TVxBTDSxXpFB3pS5oA6ybulkO577K85HY/8EE1Ax7rBSRdzjKUcW1F9XA4VsOPE47HAuEUWivU3EHNS1aMY8rWTOEpXMNGA+5j+MtAzqrBoA51etiUuWtM3m6TqgF7yOxZQMfM8TYuSxC/JyNrBgJBUxK/NK7ufpk/RXjC757nU21K8VVT713FlWc/G5wP49FCv2HOn/IqrhHQeAheE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is not installed while kselftest setup.
It can breaks other tests which depend on drgn_dump_damon_status.
Install drgn_dump_damon_status files to fix broken test.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
---
While setup kselftest executable environment and test this patch [1],
I found similiar issue. Honestly, I don't know exact solution for this
situation. So I just make a new patch. Sorry if it is wrong direction,
then please let me know how to do next.

[1] https://lore.kernel.org/damon/20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com/

---
 tools/testing/selftests/damon/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 44a4a819df55..029de547f31c 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -4,6 +4,7 @@
 TEST_GEN_FILES += access_memory access_memory_even
 
 TEST_FILES = _damon_sysfs.py
+TEST_FILES += drgn_dump_damon_status.py
 
 # functionality tests
 TEST_PROGS += sysfs.sh
-- 
2.43.0


