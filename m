Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F03CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7918E0017; Tue, 16 Sep 2025 05:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AA08E0001; Tue, 16 Sep 2025 05:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5125A8E0017; Tue, 16 Sep 2025 05:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 338BC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD4B713BEE9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:30 +0000 (UTC)
X-FDA: 83894519940.13.9FDE089
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id CFFD84001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NRFi6pAV;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX0GE1tFaVdaJ+X5gME1f6NzrpcsI0lAH1DHePnNN9I=;
	b=nFZNAcTug5klxJ4S4QwUdXr7cBY5MobG2JbSFrWvznYDlQJURF3RVHCKZuzLwTcR8SW4lt
	VDD+gpO54A4SBP5tX9J2q/ZA/07L4/KLU1xm97UrLulB+COUB0BsFGYxHjchhmuNa+pY9k
	dzcLSZZMy9F6XkX8baXQMzoZjyzYurY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NRFi6pAV;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013288; a=rsa-sha256;
	cv=none;
	b=bVxThdfsWaAfmkUi5v7BCHNYG5vUChR6km7foO4l5ALxtGgQtHGSvGjXqwxJZwh+FSc29m
	PlyaJFiZg8rmlNTngt/yXo+G3EqEsN+lo2r0W2IbdQ0qyktudhA7TtY4UgRQS+Ipiwjag+
	T6MWu6ZHCIEvy7m7ifFYqEpp4ezZOH4=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45dec1ae562so47335465e9.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013287; x=1758618087; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eX0GE1tFaVdaJ+X5gME1f6NzrpcsI0lAH1DHePnNN9I=;
        b=NRFi6pAVCPkDqhkoqJ7/0d/RFwhY0CRMVG6pdBD0h9a0DxtDWkusyC4tpG+RXkecTH
         hKPSNmU943R61FTWctmmZWtz6buZ414qJJUT5lI4W3co788cMoPzCZ8yd1raCtSQzbGW
         tj0A1mZLSw/MezE9KKZZp6iIE5pL4455TKEPxmGjHqZRv+GjNeMooLupN0pWq/ESZkKV
         hFCQ7KoZjcRrfiMbtViZJeb0T5ivHJNI7rRr2Drskzs0RHyoDsgSUX+Gt2zyKrMYGwh+
         H46bp04CaYB2SBDSIcQYL+7jXMreQDc3wvRLQGAp4rTrZYoP9P7jMs+V9761ofjwt5zK
         BvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013287; x=1758618087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eX0GE1tFaVdaJ+X5gME1f6NzrpcsI0lAH1DHePnNN9I=;
        b=DZTiH1TIsHDNI2W2Kwc3p078X0mBPqu/+KsrWZHbX7UA2x05UVQxRdSREfZ9pBII82
         WCJM8fSMTecE3K5yu4CP59PDnuXzXoQbUz+MQx1AFNTcEQwhBtgfYgDqH9yTyku0AgMK
         BFVZXB2ARDmvMHly5q6WjSeQtrwuUk3ubk5y1h0VU182YqQ4n7Rt9C7wxplb+81pJzq4
         3A7H1xvTVvGthEleYk9VPj9WC+cN4OkUOVCw3w+HDezBzSjPJp1uNWRTLQFJoEcoLCw7
         UVPYEnDS60Kls9QVMKgeZGBahW+goAMKGl/TUZii8SLOyD5kyRlnjHxyglVEBjLsh42d
         8k+A==
X-Forwarded-Encrypted: i=1; AJvYcCUz4yqyPCXqN6Eq3TwLSBsg4aILot0ryaEYNlMn6ITWJoHoXM2FIEeflZ97TfJhRwBsiE8T1qf60Q==@kvack.org
X-Gm-Message-State: AOJu0Yy6zx/I7DewNdkB8v7I1pP9U6isyqkojrFgwG9fhNDuqLNW2ydQ
	JPgxQNVU50F2DQHdz/EBMel0eIVG1ZLqhEzBHo5p46/wWqtjppKE6CTQ
X-Gm-Gg: ASbGncuo4vGU7Ol8hPObp0cdM0Mu3nYBO+A2g1N3UCzCmuCx/3uKplYzNrvweDPE9Tp
	NMoVYXpYU8JWPk7TD1CIJ9KImZ3akwyzizGejyx2IzQU766pIwIFJ3IZit06h6PA7RpGgn0kixV
	b0CxyQbBOdYTenb9GELp+l96LTZlgnZ6Gxg0xEcSzjaxNfgZJoIz70nZxprrWHOP1Z+T7TN2dOY
	1o9sHrxM73zZ+wLyaU4JuaNy3SrZuoy9vBp3ifOp6cjOo/iKMXDSX1+4t+XOfwtc1ivl8X9gY1c
	4Aars6t3CTWL/zNwEGYkn0WZW9y4F+ECPjqrdLO03kpHlTqW5r0C+m6eRlcbSHbAPpt3BV7+gp/
	gHOaA0yrSTd4e1E9+YXFo4I6qepnOCBJU6VNkqzochOyZH5aQUs2yvumwqtNooPDU9Y0/n6HTiJ
	DWYtwI7KPmtoPmL99d/9KCCQ0=
X-Google-Smtp-Source: AGHT+IG4rWU9dUsfNI/GTT2ZfR/FJQxnX0XoO3ls2sTIzkMGJlfRV3ER/lT2KNe6XIHz3tv6/6a9lw==
X-Received: by 2002:a05:6000:2001:b0:3eb:86fb:bcd9 with SMTP id ffacd0b85a97d-3eb86fbbfb9mr4536453f8f.12.1758013287060;
        Tue, 16 Sep 2025 02:01:27 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:26 -0700 (PDT)
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
Subject: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Tue, 16 Sep 2025 09:01:06 +0000
Message-ID: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFFD84001A
X-Rspamd-Server: rspam05
X-Stat-Signature: 1uddznnd9wmna1hmcesgz47ifyafhfg9
X-Rspam-User: 
X-HE-Tag: 1758013288-918967
X-HE-Meta: U2FsdGVkX1+QJl0oW55nU73dDKGi0X/IA/9vdA1vhPn3BXQYru63L6L1/1RQFjhbagxFPjN4TydtfIVGNyn5P0SpO/MvBagSves44ek+ku80lDU7G8M9TQBLAd2d+PhGRFbkmZ96+5kObdM0IdOtwXyuAvxqiQDCTtMqZyuU6KzBax4HimlfWUIEntjVSZL5jZBT9fczAXVatALYamT3wMR2PxAP4aghNPIne3m8OOs9hTJORmIhQ0NlP8rGrI/MlkAmbvMIC511wray20WguxTWk79mnzxOY3i+Fou0cN/EpJNVbqrsT0xerOqmcrNo+WhTVaK0iOJpCaokn0oaKCXOR2SbqhhiTKH6Ero5j+ARnHw1QxrCrVf3FBKoyOK5RBTjTGJzb6ID42914wGYJ32LfoP/F7X1owR6fjUkrjQpTZepH9fqE6U0+rJqTKuZSz1lCXSLS1cpqu2cUnTVezqzf+tcYynMUd2dwQCbZhhUOcO83L2vH146fQ/mXMRsrbYwp5HOlMQsIM5xEULATIjiMkkz64ZUxshhmT2PJLv54y0Xx0OoMoi5ZOFXFMlAa5BUF0y/3yrVIv9XzUVdeTaGPbLk/wcF5vXL01tc8J5gaBc+pdrNlwMM7VVefgvBZ/b+dHXjH9H8Qr3ynQISV39TqWR7oVCVpK0Be/Xqnw7wqns39B8s4OQJy8NSR+1CS298F6qEM07ilcFYZcq7ldydwcdrY2wKe+KxJaOWVrUTrzNCy9CM4Ap/qk+Ent0GcseeueOb/JanS3Dm00OYfbKsCG3FCi9KU/LULrZx8ZD0NbHgpGr8qkuW9l2cETIjp+IJ1RRXlzdiVU1j5KaG4oHBayHgVYwDLDpQ13+UcAtT/cb1q6o7Ng62Z73Wh4FCYssvtX/AEAhnLljCFFhlLIkWudhS4HYCfR4Q937+jsaMGIKShMyqD8qcTp/0bWZSs3xTP2AA/nXietnyhYE
 XLGeGISE
 QYL2XFEVIvq8quITyaxyP2aPBqFvSV+WzNHd6onXGbQ2CKTChclb3ek92mVNbAVndvxBn/7zAWCS1LVpr7AIyNQyMpMFzxLYSxu3qTJJEK0vpK7nc19dkZ+xgiCXUiigzZ33k+ZvhrSJKIFhvOWa7RQ0f/Y57NyOOhnD/Xk3wAGVnJx4FIInFkLCDvyXpifC6q7ZdCIkdfh52W9g17OK95J2fZ+e6IPUjfYVIzi5rf1YdNj1HW2mS+MpOGUTT4k2VO9AKJ9Sj5cWrjAHT/85ZUugU5bQYFKrl2va8tOhPG+NpNHh8cXltNSZi1qd21wM8RMME0GBro81EfQ/teec6UX5wrWh/2SRSOwqFLZGDRsDaEA0eIiBSVsWX5D4uUOXhihCH/uJDoghLR5V9tZo9GQum+MtbqwhOwcQm3m8wo/YEcp/gT7QJQkmCyQ6uYzI/frU7fg5bXBqsGI+zIFkFAjfs541eLtU8jQHSrHph7YqupKrZs/ybPgbQ+auKmuldLR8d8Krs7Ayw15g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
rsa_parse_priv_key to serve as real-world examples of how the framework
is used.

These functions are ideal candidates for KFuzzTest as they perform
complex parsing of user-controlled data but are not directly exposed at
the syscall boundary. This makes them difficult to exercise with
traditional fuzzing tools and showcases the primary strength of the
KFuzzTest framework: providing an interface to fuzz internal functions.

To validate the effectiveness of the framework on these new targets, we
injected two artificial bugs and let syzkaller fuzz the targets in an
attempt to catch them.

The first of these was calling the asn1 decoder with an incorrect input
from pkcs7_parse_message, like so:

- ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

The second was bug deeper inside of asn1_ber_decoder itself, like so:

- for (len = 0; n > 0; n--)
+ for (len = 0; n >= 0; n--)

syzkaller was able to trigger these bugs, and the associated KASAN
slab-out-of-bounds reports, within seconds.

The targets are defined within /lib/tests, alongside existing KUnit
tests.

Signed-off-by: Ethan Graham <ethangraham@google.com>

---
v3:
- Change the fuzz target build to depend on CONFIG_KFUZZTEST=y,
  eliminating the need for a separate config option for each individual
  file as suggested by Ignat Korchagin.
- Remove KFUZZTEST_EXPECT_LE on the length of the `key` field inside of
  the fuzz targets. A maximum length is now set inside of the core input
  parsing logic.
v2:
- Move KFuzzTest targets outside of the source files into dedicated
  _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
  Ignat Korchagin and Eric Biggers.
---
---
 crypto/asymmetric_keys/Makefile               |  2 +
 crypto/asymmetric_keys/tests/Makefile         |  2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 22 +++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
 4 files changed, 64 insertions(+)
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c

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
index 000000000000..4ffe0bbe9530
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_KFUZZTEST) += pkcs7_kfuzz.o
+obj-$(CONFIG_KFUZZTEST) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..37e02ba517d8
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
+	KFUZZTEST_ANNOTATE_ARRAY(pkcs7_parse_message_arg, data);
+	KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
+
+	pkcs7_parse_message(arg->data, arg->datalen);
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..bd29ed5e8c82
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
+	KFUZZTEST_ANNOTATE_ARRAY(rsa_parse_pub_key_arg, key);
+	KFUZZTEST_ANNOTATE_LEN(rsa_parse_pub_key_arg, key_len, key);
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
+	KFUZZTEST_ANNOTATE_ARRAY(rsa_parse_priv_key_arg, key);
+	KFUZZTEST_ANNOTATE_LEN(rsa_parse_priv_key_arg, key_len, key);
+
+	struct rsa_key out;
+	rsa_parse_priv_key(&out, arg->key, arg->key_len);
+}
-- 
2.51.0.384.g4c02a37b29-goog


