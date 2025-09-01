Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1750CCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B108E0043; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4008E0016; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BE38E0043; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9787C8E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:43:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6713F85CFB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:18 +0000 (UTC)
X-FDA: 83841251676.13.625280D
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 823E140008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nPqOyXlf;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756744996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBvpSqbqbG4wFXeR5v1aPOZCpZfQ+jFjNgEJ1TDAElY=;
	b=4JKlmoY9WgXjZjf6K+mNgsXNz7xF4rDa0FtXVUF4d0PsgQY+5HXnHItNa8QOqfOFGfh538
	Y7TpahYFwOkUQuR068oNG3fN2xkum8ehS8os6fn9JnDlo78TKCKFAF0YwpoHFEDh2OAvaS
	3xesUnuWGsglyQiyv4KIFIAA+UgiX8A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nPqOyXlf;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756744996; a=rsa-sha256;
	cv=none;
	b=hO4vdmEk0f2LWvk+zJ0CLzdQxvlOQ6hf4YacH5ufarzxD7JDQ43tCJ3vrcx8H91YqKe2wu
	gEdAoxQbVjlzCm8dcyYwbYMOVEv+QwYLCuvCXtDGZLbSymOGx5DN1wKuWD8b0hrukA/wH8
	imXT0YDJwG/DAVE+igFnP9tLQuojuWA=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3d1bf79d6afso1611951f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744995; x=1757349795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBvpSqbqbG4wFXeR5v1aPOZCpZfQ+jFjNgEJ1TDAElY=;
        b=nPqOyXlfr/9pgMjWHtXr8qjxCkHrgd2VICOP+uveYtRhX28U/EYddtDGVvp0JoRYmk
         HquS3i/PucD+liW+4HpKqy0+PKBCei4kWW+C1ky6/uuttd6A6WeCc9yqF9gFeg5cbGOP
         rzkoXJWN3QX4Fq4g84OElG6iyKKarwRgwiRAFzadhdCXF98hxXDmjVSCDvM7ZJsElqkD
         +eESU/bjFXjhI6pPBlP5wFKsQzxWMesQ3y9cHcToD55ZiI9sUJ5zoH/FTWcLI9WUbXXG
         VS9v/yhsbiYPX3y3U77rlp4/8TXYMHWORJd/RDhXdlVjFlojj26YZsA2eZ/ZoBncG/lh
         A84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744995; x=1757349795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBvpSqbqbG4wFXeR5v1aPOZCpZfQ+jFjNgEJ1TDAElY=;
        b=g7Zs9rhfJY4MY/IF2xi/JkCa8mM3kjkV8qvrkcev2AviFn8CBKBuFP4rUWCf/qO6Em
         OgN/lpzeZkrSc3jDGogNyUIncINNMiwsfZvwlwEC5eIUmlvXQb55qL7D2LyS54R1avy2
         MDT2l/dJkAv67okkUIBZtlk2FRo8YkoDA8CRYvm8q55O7HcFMkzBIilhipr562PJB8fQ
         7QnNnXummYf9OnJBojvvvEAXaH9m2UwHrgRur9WSqN/93U84FNNkaneVbEBDuJxdudkK
         UmrXRYuH/jCiqyhkBrx22+j2i2i3xLo/iby2K7Y8+9U9Hzn0naNOjBz5q1C3xHHyKmRS
         +XdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWioMmLYNqjtc2+qfKWINyoqmCnkhv4QotFt/dQvEjtbcsoocVGnjuyAfT9obDD3MqwtqnFTceEKg==@kvack.org
X-Gm-Message-State: AOJu0YxmuhyuU/YAfyceqWnQHXAvGljUi5ZCbw3PuQ7tey3/1zYLvQmy
	11pLbzovKl7XSHFYQTPpXR17ciZd10vdQ5RJoUSFOiJQbTUpMKHnHZGp
X-Gm-Gg: ASbGnctLFje1Sye/to30jxpYqlC/59tHjUyuHOBnmncHWN5kPiSjE73VaX4n4h0udkp
	81XnaqG2326eyXCgbiAeFr+JwhJYur4kih6Cp9ANjjoiBGJOy7p7Yvaep+mV2WOq3gFnBvZYJ4q
	8gfxVSrpoEElbXBgru+ywgPQR3JGkXxplmzquGAKsFUjWxcGp+/F5gOrbQUDWtwKxVCWD9gpQxU
	AIvO5L0Y0ivkCcbCNegzu303kvISnZID5twDkS5uPU5Dm1/I+7xbk6IPusZA98nMD025ObpmDQt
	ttzZ+kZjHVh08IUKPVqamm2IowaP98T/TtseNJ00EWLuJ+n9D5BbQCwvNHSxZhzLIuxUD2g4RF4
	YxgXW1Y79C+SQcBECfUuEboNmRKEiYSvJiGnFfc7zBFcEX37DbjJdHeJAckGOEZzSf+DKHdlKiX
	loLzTpfCyZu0aTLPi3/WmTI2HuR4co
X-Google-Smtp-Source: AGHT+IFKo5JULDcPmqclDIOUfq+BI0sCVaxhFcUfvTCD5F0z7DntK34OPynj2UmgxgB5QgJJz7ystg==
X-Received: by 2002:a05:6000:4210:b0:3d5:9efa:fbf2 with SMTP id ffacd0b85a97d-3d59efaff51mr3979157f8f.22.1756744994954;
        Mon, 01 Sep 2025 09:43:14 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:14 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 7/7] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Mon,  1 Sep 2025 16:42:12 +0000
Message-ID: <20250901164212.460229-8-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 823E140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ewom5rou5zsbarpi55if46h18dwr369k
X-HE-Tag: 1756744996-760835
X-HE-Meta: U2FsdGVkX1/hUPxqTDFRAjzcGKWbNYm16LRo9uboOPQez9PcHiJNyUNoq7siCiII0K+SvcbDI2Ai118by+pYfs7bVSunnbkVLf5pML7Y7M3jTZN/9c6t0cn7+BuWLv1FLd55gSDgp9kDKsAnAKlblRRCsJO312TfsBl9Vd4Ok9/HPmWOGwjvtnIpDUWDU2zAZpP854JxLaSTeeiZ+z+RbFULFiv0EglspbtiyfYwo1ic1FfI9WPLtiDEhEF+iD1S+3NBAD8Xl9vHnUFx2RA43EqkCPDWEQcX3ca6rX0zkHcO+P9Zbl9bdCtl41IYjngoYSQxwkOQUcnLULyyH38XKj/Al971jxmWm3qavVRFwGR97fpv66hgwfINK0y3xHG4M39oEjaUm9c3kvyeimlwRLDuK0MRHyZcE8cuErrsUSyetcuGnN06DjD+S+LRjI8QH66qGHPG6/etxzUeTK+vdfvElsvdHc5b22IHZRqMlN9MqRTdvwdJqRAUifURKGNmuSCjZ8PdwZw/7iwk2EpcDHZGPcm0rfzbuGfClbRZPuUA31poI0/LRFnrlBVPsFqebY9iS6zxhHmc7ARiZMY6uNF3T/dcZD3VL8i6r887y0PvvqxPQw5pCW6HidnAk8geFK7Nm4iFawXODc6eCcv4awKnSOKnHX0MF5/Ob6wEsYirvTGDvmxtWKUqF0l0d6PRqpceV4AUWCzQipzaalhUN+38bOwl4BGMb//m5IFR/WhvhU+f3vwltBkwCzNZgdGoK4a4CNOg+/Y2X3uz4z+EHnJxbR4VWprjVJ+xkcAYAfNa6j7Y2J1JnlQ2zwy4Y8FTTBzDW9N3xADH7woqEhI915nPtCwo09rJryIv2NPK0aLh0VbdhIRBvtlAAZ5BWeDQla0wWwtp7lVuq6x4g/bdGNyyXailH/q16qezMubkkH3ysZ+RU9uUAlaqe8kHwtFea0wWNLY61zLFHSWfIuK
 kWUW8CZ0
 9O6prXnO64pkiRs8TzHkIszXctNiRKvPf7iFe9zaVh2c/iBVIzBNAd6BFJwNx+QfaiaYh0cD61Aw0WbVuMQvFCZwpFUy3iQqnBqdelrVTx/+JAvZVy5p6p9ysOFQ+lLMCaArv7f0JX3VLrpYRoOrmku1wywjmvm28ZkAxUDkyCuMilNEEE9Sn4Dr6H6bRaUQH0jJnihPdGID/KYyZnB4PhU4Ex210zE74yJAtkoYHpQUUwUGde9lblU2LN9i48SokrRGemH5oKeg0uMk26B7dvAmwG4etBdG6adjYsUz3yggjJUFsfqW44w0pghxNq7VEEOAVRKA9IImGbj5N7510dHg7lNn7NUw1Rx8h2DwbW5kDxpc8mqFAFTBdkbWzf58qeqDAaBfOgvfC1cdNNPCPX5QuPeki1uuG2RlpSMWOzpG2A8Gck4VUL3DCqCL+dJDCR9i6pOiTmol9lmk9bTa+JITE6C84zZO72SnziaEUBxfLUQESKHPflIm06v2CdhIhY+Onm8r9dHYe6Iw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
rsa_parse_priv_key to serve as real-world examples of how the framework is used.

These functions are ideal candidates for KFuzzTest as they perform complex
parsing of user-controlled data but are not directly exposed at the syscall
boundary. This makes them difficult to exercise with traditional fuzzing tools
and showcases the primary strength of the KFuzzTest framework: providing an
interface to fuzz internal functions.

The targets are defined within /lib/tests, alongside existing KUnit
tests.

Signed-off-by: Ethan Graham <ethangraham@google.com>

---
v2:
- Move KFuzzTest targets outside of the source files into dedicated
  _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
  Ignat Korchagin and Eric Biggers.
---
---
 crypto/asymmetric_keys/Kconfig                | 15 ++++++++
 crypto/asymmetric_keys/Makefile               |  2 +
 crypto/asymmetric_keys/tests/Makefile         |  2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 22 +++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
 5 files changed, 79 insertions(+)
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index e1345b8f39f1..7a4c5eb18624 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -104,3 +104,18 @@ config FIPS_SIGNATURE_SELFTEST_ECDSA
 	depends on CRYPTO_ECDSA=y || CRYPTO_ECDSA=FIPS_SIGNATURE_SELFTEST
 
 endif # ASYMMETRIC_KEY_TYPE
+
+config PKCS7_MESSAGE_PARSER_KFUZZ
+	bool "Build fuzz target for PKCS#7 parser"
+	depends on KFUZZTEST
+	depends on PKCS7_MESSAGE_PARSER
+	default y
+	help
+	  Builds the KFuzzTest targets for PKCS#7.
+
+config RSA_HELPER_KFUZZ
+	bool "Build fuzz targets for RSA helpers"
+	depends on KFUZZTEST
+	default y
+	help
+	  Builds the KFuzzTest targets for RSA helper functions.
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index bc65d3b98dcb..77b825aee6b2 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -67,6 +67,8 @@ obj-$(CONFIG_PKCS7_TEST_KEY) += pkcs7_test_key.o
 pkcs7_test_key-y := \
 	pkcs7_key_type.o
 
+obj-y += tests/
+
 #
 # Signed PE binary-wrapped key handling
 #
diff --git a/crypto/asymmetric_keys/tests/Makefile b/crypto/asymmetric_keys/tests/Makefile
new file mode 100644
index 000000000000..42a779c9042a
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_PKCS7_MESSAGE_PARSER_KFUZZ) += pkcs7_kfuzz.o
+obj-$(CONFIG_RSA_HELPER_KFUZZ) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..84d0b0d8d0eb
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PKCS#7 parser KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/pkcs7.h>
+#include <linux/kfuzztest.h>
+
+struct pkcs7_parse_message_arg {
+	const void *data;
+	size_t datalen;
+};
+
+FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
+	KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
+	KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE_SIZE);
+
+	pkcs7_parse_message(arg->data, arg->datalen);
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..5877e54cb75a
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA key extract helper KFuzzTest targets
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+#include <crypto/internal/rsa.h>
+
+struct rsa_parse_pub_key_arg {
+	const void *key;
+	size_t key_len;
+};
+
+FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
+	KFUZZTEST_ANNOTATE_LEN(rsa_parse_pub_key_arg, key_len, key);
+	KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_SIZE);
+
+	struct rsa_key out;
+	rsa_parse_pub_key(&out, arg->key, arg->key_len);
+}
+
+struct rsa_parse_priv_key_arg {
+	const void *key;
+	size_t key_len;
+};
+
+FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
+{
+	KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
+	KFUZZTEST_ANNOTATE_LEN(rsa_parse_priv_key_arg, key_len, key);
+	KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_SIZE);
+
+	struct rsa_key out;
+	rsa_parse_priv_key(&out, arg->key, arg->key_len);
+}
-- 
2.51.0.318.gd7df087d1a-goog


