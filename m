Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF303CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525DD8E001A; Tue, 16 Sep 2025 05:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D67D8E0001; Tue, 16 Sep 2025 05:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4F98E001A; Tue, 16 Sep 2025 05:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29E4A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:09:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC9CD160903
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:09:41 +0000 (UTC)
X-FDA: 83894540562.06.D1568DC
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id D964BC0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:09:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPw7d7Df;
	spf=pass (imf10.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO9AFhAl9ilu83R9AZsAc7oWiIru4g9kqtmWSFQA0xE=;
	b=P5qrw9CDs9T/0Cch6SyuQoOF/fzzGpN8Ysw7DNXwcG/3qr3XmnVmlV9qlRPeDkIYGllDbW
	agoJW48XuEq3+xaF/WmjMXwAmziIaysCNtTq6/w3p9IvxCRiIQz6Rmys4ElI1tSXqbwIBu
	nb7eoCQnARRSVxtPvO0fEOgIp3W1CFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013780; a=rsa-sha256;
	cv=none;
	b=xxRvPfR836+9NhgFWbFm4jAykZxYvVTz35IlBsv9cBHQslNnq9hoLBJi+6ShAmHUlKPbpi
	idf5DV6nocfwfhyMhOpOEJWTA5yJ8OP+/zv5RVhZfNDLTDE4cdRLgWx1USPzbk28cuoOIY
	AGZuYATBJntkmyBLBoMk5AuLKq+D6MI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPw7d7Df;
	spf=pass (imf10.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5607c2f1598so5851236e87.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013778; x=1758618578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DO9AFhAl9ilu83R9AZsAc7oWiIru4g9kqtmWSFQA0xE=;
        b=jPw7d7DfpkTYLpfPv6B6LwJNpPtIJ1NAcvlNoYjRNKiAI5Z0G7c3/tymNDGFSfIt/V
         +49TWpRQubTlmlEgn8BTjTC6fL66JVdlb+BQiYZDCD9aNYNayQU6IUIxutqNWYdm/a/4
         ZhZRvATOrVbYlh5EmRyOn3ZAsdDNumz4lrqF5xRp2CMvmvVhcCWHLBhExArIgijoYKs6
         4t3g6jMeLmd+fykvL21Z6blMZsmoQXfqKzSiK4JzCWDe4SV3/dZrZ61zSyBcua+7dHrU
         jJh5vq8QXCef1u48PpyqN8cxjSByVLdcfJsOvbTjCbIr3o8teQwPPmPCnodosrs+OXcj
         6jiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013778; x=1758618578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DO9AFhAl9ilu83R9AZsAc7oWiIru4g9kqtmWSFQA0xE=;
        b=F55ym//rCxlNS2qHEswdCy8TZmF17aAfiuWd6/fdgcGNFciaI2eD6TE89Z+37EEkxr
         zQuUlKhe/pgAriukdqi5Q0DCBrrwgUP7SL0RSgAhNTWaCaxd1quQ7c1Xr9UWRRRiGs2E
         e5BjScUx1GoA08nfyfLUfOFcKip2fmt5GbY32KC6Czk/x6BvGYe96PxbkJYpyEbNgQK+
         iOU9vFDv68OV+6le2NQdgU2NHiAFUHQPDImwEfhzdBvEQQlpDMyIaR8Gjkui3OjB5Kfe
         f3fix3kOau3zhKhtH70JNR/mJHKKebPu16FgjfJJO2RtqcCkQa3Zdn8wYMM/U7S+YLDD
         oYCg==
X-Forwarded-Encrypted: i=1; AJvYcCXe1Rrxp7u6LG2TVRmBAykbdyes5iBKOq3uanrWChPWq76z9twcuWs1ch/hiQnVdHO7k/SMYdCrbw==@kvack.org
X-Gm-Message-State: AOJu0Yxm7Kmd6ntBipL8Dt1++T7dqzV43dhC5Na/u78BFW6Ing+sFSaE
	PoEcgLIt2JCWwF/fhoYkWhXUn95GW+2vip0CIlBFWgNYkhFLdanR87nKsOJ0X8MOKlLyKM9c
X-Gm-Gg: ASbGnctR5uXRCvYYD55qJKWg9Bf2LogdIprMSj5K1cShZPOnidMgWbltLdVyZe9gufI
	b14YNLUXKlnn1KaOgdligktpSnvubkXMD3MTO+IYCDd1+NFysqJ7y/IFMeN1EyOl8bMw/XJ77X7
	kdsJUjXFQ6E0u8lHF7AsGWz3t6IoWVjZyC6L2SVm4ZL9+kPF1nU2/vq38OkHonxD23LQuhQfDTg
	s5QwOnN5hOtGVSR9EtPX8Eor9SZ5YscxAW8sFyetN9BKEeceU76D+EPeuf8EF3VYrXJvUIAEeOL
	5y5oRm2+sLkjPfAmvelJnUNHtBfonUSIpxUN3IX2Vz9HfOcsR6JwB1h8Pn6sFtd2Nsxq96hbzdv
	6e1RNa0GHi2Tc4WoIuMjOc8qw+8zE2eHCAnhZ7zFNnH61ELj3f1tHSyTo5Uub2yUT4aqWW20dHu
	RU9tGA3b7aD3Vj
X-Google-Smtp-Source: AGHT+IGotFF9hMuk2BHhjmZio101NvNZ9u1/TzQ6HKksgBv+fiil5SUdoiHKC9mTRtqP9GooBIX06A==
X-Received: by 2002:a05:600c:3b87:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-45f2d345de3mr59942395e9.3.1758013288120;
        Tue, 16 Sep 2025 02:01:28 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:27 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
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
	tarasmadan@google.com
Subject: [PATCH v1 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Date: Tue, 16 Sep 2025 09:01:07 +0000
Message-ID: <20250916090109.91132-9-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D964BC0005
X-Stat-Signature: 7g43bqws9nbjdwsadu1ng9j4abaw949t
X-Rspam-User: 
X-HE-Tag: 1758013779-867765
X-HE-Meta: U2FsdGVkX1/O24IJsW4PJYlzK/jLzPGjgSFuA2bPn4+J8ymsLWB0YlKcof+ocB1NYhNGY/IoAadwXjQTHzdrxAGqRHC8YimU+S/OKuhv/whZTn9ABsQXP9ZEqG6i0xU4aCs3vO7R9adxlXv5kZRsBVbZBursYnyMafelMnQH/fI7Wdm8t5zq3dKC8EiKyMqvykTMhTGRXUjuHS/mW2fIDIo6JXioaxj2NtIsHn8VZ7QMCstojkX1lFEzRfsfxp71e/bq5lrFIlHEn7pcwhMRcWRcbyjJ5iKRvi+k0eNKKTWgLl8lmzOCTpZpL8gO5pOE86orpKX89dZYgiCB1X316tMYZSvFGtzCoy6ysfdp11PgR3Gm72tuRHEACmRnkW1tRCKW/Rm3T6lNINYsu5T98VIwE8lSVcwS5CJSgqtr6B4m6geIJFj3sspGEN4cHGTSoPuysp7dKs19cJuhgiibO/2cpIrz9FyFB4xc4OhwLS91lcN9mjNF8rJp4jiQUwXmEqSC+UGJ7vdPxr1RESdCmDnXFjaPp/3Gm9hBW5OX0KRmu+UfOfIoiWpvCl3hJ1twb4Nqvh54+2Bw2hbjeBipU9Eg1UkUPJsVqOaR1lvAnVbZXQ4PSnL/ADkk0nUVFp+HLBVXkE0E6jhR8M6DDb6jkSvmI+UnuNghJGJEyLdLEx6UikXYNczERu3RQW/wiLnjuAqCl7m736+FMVdeEMmS9niMjiwA73piP7DMRSLrG4GXeeHrEKYFZpRMWYZfm1Om9sSJrelptGSRv1pkWYuWzUTsyoWRAdPemzYYcDDm1jRXoVCl1wQXQBMRBgCerm2JyXd25gnfPX8Av2g35s4ORC5beY7Qqd/gmE4643Gki9967fDq3AxaXnl8kwD/u1rOkcqvdBPZnBZAD0Z9kTxcamZv+fFWIqQttkmmIBOOecVpnhRwCn0cx+YGrgzzwgjsFhFkf7QID9fHCNfjnGd
 SUQ4bkRQ
 kKyI3Z3BBO+MFPXdxEyUzGc4Z7yO02R3+1Ow2V7Ze0VwC0UTmabHEsNIImtVPg8e2rwOJqCqOdQjdsodg5tBLGZ0E8lQog7Ql9bGLsJ54PZdl0M/7OZsZRrHE5l+bnLibrKeFk4PJlhjTNn6X2I5DCbd3c23lXullVyU5VI6OzPppttIHHUROvH0rqwceZcIEbBpydWxHBGae+oo5Q2wcyOhL441t707vzfs3edmkryT15W2Tfu3D3ChctoRpa+4hCTDBmI31rfJBvXCKUzgosBuuvj/xdIiAQnzy5KD8nzUMxWsPZX8qQSD9iX1kBLrYL5n+61DoXvkn5cJVzZyJUPBIHyZdRJQpVeQLviogXJK6ridHvLXiK5t77oHMLL07IaS0a297KBGwArwAnAWcMARlRSF0NhHqHxMatedO6d5hr7rCvrUQ7pY/4aK4zhTwnV85hpJo9MgQDSECt7qIje74yYgvk6X7p9tFdDni7v9G3Qk=
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
---
 drivers/auxdisplay/charlcd.c             |  8 ++++++++
 drivers/auxdisplay/tests/charlcd_kfuzz.c | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c

diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
index 09020bb8ad15..e079b5a9c93c 100644
--- a/drivers/auxdisplay/charlcd.c
+++ b/drivers/auxdisplay/charlcd.c
@@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
 
 MODULE_DESCRIPTION("Character LCD core support");
 MODULE_LICENSE("GPL");
+
+/*
+ * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
+ * that KFuzzTest targets are built.
+ */
+#ifdef CONFIG_KFUZZTEST
+#include "tests/charlcd_kfuzz.c"
+#endif /* CONFIG_KFUZZTEST */
diff --git a/drivers/auxdisplay/tests/charlcd_kfuzz.c b/drivers/auxdisplay/tests/charlcd_kfuzz.c
new file mode 100644
index 000000000000..28ce7069c65c
--- /dev/null
+++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c
@@ -0,0 +1,20 @@
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
+FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
+{
+	unsigned long x, y;
+
+	KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
+	KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
+	parse_xy(arg->s, &x, &y);
+}
-- 
2.51.0.384.g4c02a37b29-goog


