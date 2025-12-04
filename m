Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C365ED206A7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890F36B00A0; Thu,  4 Dec 2025 09:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7803D6B00A1; Thu,  4 Dec 2025 09:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620E86B00A2; Thu,  4 Dec 2025 09:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 453526B00A0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 024391A0128
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:20 +0000 (UTC)
X-FDA: 84181981002.04.02BBD0E
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id E25E4140015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DISJXV6D;
	spf=pass (imf26.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ekn2DBIpCkQXanmNkedEYdcryjYDg+bStsY06P8Miig=;
	b=DOhE6Pbxw3iJTYOKZe8ppLfORgIZUGTynZ6cxYV9lszVNHGg3+A17K2EeCrHixOPmeSm1P
	kiX6B08hO9uY6Pxgitu8NQ8iS9CBcpxw6C/OD4ZrUkuOLOQd6jrxIJqs1SYxWb0NuP3bqp
	xw5GxHLR6Defkr2utGprrLoFfm0Y220=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DISJXV6D;
	spf=pass (imf26.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857599; a=rsa-sha256;
	cv=none;
	b=lp4CPw0a3IQSyxSbovLP7NnwsUcHGXVz2a/lWAX/5l2Cqh+Gqy1Ua0mvHmSrQC/pIQUb6V
	dWtjywwORMXOK2XjBmqpw4EUb1SBz1TVV30u8RW55IQnSGWd0JWVFy12lEqDrFiclvGQ0S
	UCw1XXDLkBv9Il5mXYHyNnjRtBXGhFg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so9111325e9.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857597; x=1765462397; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ekn2DBIpCkQXanmNkedEYdcryjYDg+bStsY06P8Miig=;
        b=DISJXV6D1S0xaJUCB0iC1p2qeJAHXHYGMV2Gynf8yJm4eKNtIWXYv8xn908p8gZJNo
         +J3kTQ5pY8vtQJijm7Le63kkDdnOpUrGej0YHXMjwrM6mKs3kdC5o9V7mzW/M7yzihcy
         lA82ST7fjvsz21/2Nzev0s1j5jQtVofQ3fJqhsD/88orFJhP+31Z5c0zLrJCldwvw7wP
         clNz9nqfZen/URjNRz63GeeThi2pqTpBjv8PG8eXS4/FBBUxTEdVk76HoegGok7aU9eG
         GiDWN/T+HyQ6FJKiFP39M8l6eVs3ZivTqCClCpCgjupdRT636wQLJ8fMLO/UDOQGwGlG
         24SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857597; x=1765462397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ekn2DBIpCkQXanmNkedEYdcryjYDg+bStsY06P8Miig=;
        b=Znld2Fy3tuEsm82e8YUhabLf8FYMRdyzu2QO7dPyJOeeRzb1LlPizoCZnpxdwDyG5J
         1Gp3iSLzP6siG+gW5yzIbrJfcQ0/Fd70LlI0Twx7SQpX8e3itO3cHKbG4+Q/8D1yVhN4
         4PIULGSLobIjuO0Doq/iQOITwiTOsRmmxAsy12pY+v6seZNdt2xjN9S2HYZc8TA7qLrd
         +YQi3f719BFqRa6xZVj2Ohghxf6wdxQjin/tovO1iSkoIU9Dda4/iYLeCSitWZ/doIi2
         nME/KCQOuSG9YMwr+Fs+kj0Tx4QDaiN/AE71m3TxOtahVoxzCohyh2IAO2Ah6/cYh/4E
         RE4A==
X-Forwarded-Encrypted: i=1; AJvYcCVaK7WmpOodoce1VjeFov6RIn1mo3v51+c6jXEtTPHJe/kOhKneeivSla+KkkGQb0gHIx+aBkPmrw==@kvack.org
X-Gm-Message-State: AOJu0YwU67kchqThFf8XBJh2QK5yU+9ngAhqf+xlzlxo1NiQnGd7nQCe
	rlWvM1aNlRtnKZUxLsWbAukoPq4OJDIgI39pYV0JhfjKrgi1T8+Kawri
X-Gm-Gg: ASbGncs15k298shhfNONlqSg1rJ8JrzbgbrUL97vfohzQ+Uw8GktJlEQ6nawc8o7L9c
	u/LBBV7F+uQP9wJu/ZbCjJBIUQwcUJK7ubOA2eg29DGHqX/BC5VcXgm4VxBYK02aPZwdHIzWC1i
	DnreDheTVfvqu58hJ7Okabr1nG3DQFKlhXfnhJNMuH+Lzmmehh+CEllSZ5W/WYpbNnGGC2Bu36B
	51q0fzsYuMlfyjcq+UkOElNcT6FCkfgS0CTxp4DcXZ768dK86O7xb/+KlIwybbgkkE/ZDPtY4XX
	jPI0tDc9sSENxAqxL8XwrZyNDxV1hnBiuq5kvEcT2sq4y+0mwLFqyMzDS04G3Ev+rKTTCVFj1Gu
	l5YWX6UjZT0LF2F8fBNsFZjMgThaec+IvNFRUzI7MYY2G3Sk00rxc0FElAyJ0Ti1ivWHMsReZ2j
	IVdbh9onLzNyrjaIiX7003/1ZFtf2tOlA9EOMxcYsu/ZnNs6DruyFyshulcSZQv29zJQ==
X-Google-Smtp-Source: AGHT+IF0jf9L5DYl+1CaWZ41zHsxhPYhONOE+2bdn2S71mNR6t6KEufMrADSOSJwyHdeDKC7Wy8upA==
X-Received: by 2002:a05:6000:144c:b0:3e8:b4cb:c3dc with SMTP id ffacd0b85a97d-42f79514872mr3363210f8f.3.1764857597333;
        Thu, 04 Dec 2025 06:13:17 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:16 -0800 (PST)
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
Subject: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Date: Thu,  4 Dec 2025 15:12:48 +0100
Message-ID: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E25E4140015
X-Stat-Signature: 1oxhcao65nt9drj86rugg6xj55ppbhp4
X-Rspam-User: 
X-HE-Tag: 1764857598-544429
X-HE-Meta: U2FsdGVkX1/pFne4dr/ebrB0Tw7qmXxHaVQEA0BiILyc4hcdKXf6jISq01sRoxDRjIETEC13RWR1ekWoDMPJEYKK88pugLBD9zFpX8HNpHIeiBApv9Sr4v6WD9XCEHYH5785gcs2D66S+oPfSuNFlg0WQTNXdHDZakLiJiY27EpLMsAMyXDm45FPqubqrn8VFTmZfO/HGT6O9iDlJv+CF90gcDjIXItnzscI931PlSLlFDv8uOCsJowwjBI8rwXufJHBAXf0oW/VzWLzOSouJ/MJnbrpfCOI5Xo9jWpNN1gRBwsqGXJSMx60sUc6dNtcSxzeUm8WDbJLKJ5R8asT9vIZ2bKe7Y8PHkg/FHtH4onvsB+W+vhTzaXVjIdO9snzTFzjWqTtRlj+Ut2KxxSp87KrlYqUWzZlPHntAWWQcEKF+XTAQlrYkNAvT54bJMu95ge/Q+rPEJ5r48kmBDYm7BjCfGon6OzvUSvjrYT/fFuyy4MHG/b1GY4g39SPG8fwC1pUYoRIRpVPeuIwdKefnFjurRWm8I7SnVv5LW104xivR4pT6suDEPRXjxO/cqaYs6mPHCe6xRgoeRBDF7MeJEB0L2IMRA6O/EcZvhVvISDjHbsiLbWRWI3qpjxWZXiebRmP0bYo14oZwKlTXAHs9urGajhzYflvR6qmYA7V4zi3/oIJuQZKO9cqCvA9zA06fBM6FmTb+8pORoO/deURtfLj/fm8ZN9xVUuKtEbhUnGI+K0l8gnRX0SQghpwgCEnpKRFEISR/7eb0YhsG+bMhMfCqh8awQieOzUJOepLAzR7ICkIGQsp4ryi6q6kySbyi38RYo7PhNLiUDCfKB0Gc2JZAd8TxyX6z9TMvVJKASxZJOB4EQRvS4stw5DuvgxsrzdYETkwretYGJsb2erFN4FzosgfZu2tByVg2c4uaOrkdiaWJzcDbu4rucu6zAHjVLcfS7aaOywER+Mwwp8
 Q2b51j8/
 KXgDI2rH/Lw0q9wmz2WPMLLh+TVldZmfXv8/HMnlo1OpTDie2x/p/ofzEz2ac+LR4DdY/qWkstDRsAvwc+lWXL59Jb/TMvsxzdmUMWFqPq9APA8ciGwIVL/9NfpV/WzS324mhg0bVwkrdAqH6g3WafjiRmMcoi2lrtUIxjfMmU96DE+N6RBhcDuWlUO3FnhjiQFPTcQo2D4j7+dJt2J3/YOa1WEevyI//Cn609uzBBu6wC7wj4hdD2YO2g0j9w1PbI9/TzIXxM+hrXS9hkt2kYj1/3xS6PH2ISW82Nt4FsTol0d0G3q7zNLHmV/3cKTCIRA0CELzoZIsKrmcxuY2qmsTcT3BP4Zi4tVT4N24kcHZsWMmNuTvyh0u+LHq9OF9khxm4AU1FEyTmCipbY9KdQqbyYo4SxjdUI7pvFDYyJbxatT3iyBTot55q7eOi3erILoE+6zLZ5e0vWlZvbGbAhFGxPiX7C9V8B/1oVvQ8Vz6mbqGwv2nYwOtKEl258rvNod4UqteBxI+RpZTVY9qLpu/yTC1/2jsxdrhccdSrSKYbJ+7qg6WkftFJgNJnCH+Nj8LISRZhEpk/Ympe167IDPRKic5OclS7WTBUrWfadbiQXZwqrnjzgbKA759kj+QjzAtBWFOR0AubC1eLqW1EVHpNNkJCV+2TM3BiOFI8dFvPckvoIhGlFTh104pVflTwMQbkfylqD0Fbh2oCG+nCaDChuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
file under /drivers/auxdisplay/tests.

To validate the correctness and effectiveness of this KFuzzTest target,
a bug was injected into parse_xy() like so:

drivers/auxdisplay/charlcd.c:179
- s = p;
+ s = p + 1;

Although a simple off-by-one bug, it requires a specific input sequence
in order to trigger it, thus demonstrating the power of pairing
KFuzzTest with a coverage-guided fuzzer like syzkaller.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Remove conditional inclusion of charlcd_kfuzz.c from charlcd.c, as
  requested by Andy Shevchenko.
- Update auxdisplay Makefile to conditionally build charlcd_kfuzz.c when
  CONFIG_KFUZZTEST=y, as suggested by Lukas Wunner and Andy Shevchenko.
- Foward declare parse_xy in charlcd_kfuzz.c.
---
---
 drivers/auxdisplay/Makefile              |  3 +++
 drivers/auxdisplay/tests/charlcd_kfuzz.c | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c

diff --git a/drivers/auxdisplay/Makefile b/drivers/auxdisplay/Makefile
index f5c13ed1cd4f..af00b0a173de 100644
--- a/drivers/auxdisplay/Makefile
+++ b/drivers/auxdisplay/Makefile
@@ -6,6 +6,9 @@
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_CFAG12864B)	+= cfag12864b.o cfag12864bfb.o
 obj-$(CONFIG_CHARLCD)		+= charlcd.o
+ifeq ($(CONFIG_KFUZZTEST),y)
+CFLAGS_charlcd.o += -include $(src)/tests/charlcd_kfuzz.c
+endif
 obj-$(CONFIG_HD44780_COMMON)	+= hd44780_common.o
 obj-$(CONFIG_HD44780)		+= hd44780.o
 obj-$(CONFIG_HT16K33)		+= ht16k33.o
diff --git a/drivers/auxdisplay/tests/charlcd_kfuzz.c b/drivers/auxdisplay/tests/charlcd_kfuzz.c
new file mode 100644
index 000000000000..3adf510f4356
--- /dev/null
+++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * charlcd KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+struct parse_xy_arg {
+	const char *s;
+};
+
+static bool parse_xy(const char *s, unsigned long *x, unsigned long *y);
+
+FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
+{
+	unsigned long x, y;
+
+	KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
+	KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
+	parse_xy(arg->s, &x, &y);
+}
-- 
2.51.0


