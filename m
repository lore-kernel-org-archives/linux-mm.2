Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 068C0CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C2D8E0017; Fri, 19 Sep 2025 10:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B666B8E0016; Fri, 19 Sep 2025 10:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F158E0017; Fri, 19 Sep 2025 10:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8731B8E0016
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E47A1606CE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:08 +0000 (UTC)
X-FDA: 83906305056.29.1D06158
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55664180002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=luN4RWLm;
	spf=pass (imf06.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kKd/JXPbzTz5+ezoQ1J+mpBYdbScAPUDVkzXIQoH/8=;
	b=rsb0iLGzZpptxW0YKbFKWMt99SeAaevw/ki8zrLqHYXQrxCOCT2OxUx9wqRe/9f/9un1uo
	3bbGFTdNEENGqLmkPjuoTv6VWSM4G4CCRwxhmbvEN435pTI9j8VqBq33rt6lxXmhcotLTw
	njhhWz3IMfG2Ol1brrMfEm9b5BW6yT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293886; a=rsa-sha256;
	cv=none;
	b=0qDe48IPJkq3sLj1BghOzMBuryAfaBaaKvfMJi3h51EO4ptJ8nZOZEamnPJN7zsEvx687o
	ipbHVRaDeuIYKVy1p7E8gg+4UFFjFdZNJfEo91171xE0rFnwf8VKsgJYfWjtM/sfy3Sct6
	jMRPuu6kZyE3PAqoP8S6Q5LhHpnuNFY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=luN4RWLm;
	spf=pass (imf06.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b9a856dc2so15463325e9.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293885; x=1758898685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kKd/JXPbzTz5+ezoQ1J+mpBYdbScAPUDVkzXIQoH/8=;
        b=luN4RWLm3+QA/9xOzSQ9fu94C8r2SEyaLgiJHQPf35ESoViqNQJNmXK24l4uFMClVt
         B/Vvd16u2MgChmacABNLJZEE1yT0bMmTslOg0rev9FZI+GlUfDTV4Cq3GybDyly+FHrW
         /8BaFPoNyGDNsI8+dneI1GKnHdc8mgD0etz5HItBmnMKv/coZ3Zi8pYeVsTWSboLVDAq
         viGvIeR1w0Uff2IEJ2esDD/vQ6FpBFEG4up3IerahxZT4lfGP64XSibbDIUwbbZf5qKR
         AYObhlKiwbFcaE2qy58ENjwIMfeLXZ9KNHnaKLjza8zyn2oW8rYGfl7n9b1tJwUJq8Gd
         sZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293885; x=1758898685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kKd/JXPbzTz5+ezoQ1J+mpBYdbScAPUDVkzXIQoH/8=;
        b=iYBV0tAb1cHEoSenPacsmtN5BdeniQgRzpBXG69m9nMdhrfFF6JBza82hxDkb6rOXd
         JxwCkt5TU94z0PfxdPAD8DtshMG14Y8iN6DEYLWxqjs9mjBdFVxhWmiLcqIVNohlusgI
         9Cw06FnhpqtYNH/4zzf8yTPcNb7wSefzhrOy9+cdiIIPqgSma8xEp5/R52GmdVUbhF9o
         vSCKOke29T9YfinpMOuBQk8fHbb7mrdu43055fcFfxwkQtcCXXkT5vqlJbAhh+fE1NMC
         2YJwCuqRH899fAvNVgDlPGfbzCiLku+raB+gWSf0o41vEFjsFEsjFNklyx+O1OGZB8wf
         Vzqg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/D3rIsWLSdghyt4ecs7yvZxTrxkPNx+uKDElH8sX6IhNgIewiH3qsCiGAL6JjFYfRTucO18YtQ==@kvack.org
X-Gm-Message-State: AOJu0YwdW0XfrBAgDHpkX4HSQZF9h9Yi/cT09WqXPi4NADGAVZp6Q1Qu
	yjjAeV5UDeFUfWYwmrXtCmauDwZHHIEh5PSqB5vsYKVCbbYFUtWgdkKV
X-Gm-Gg: ASbGncuH37lSRqrilXuF/sjm2k3SM0qbpLnT8C2faAGzzZbU4FPhHp1ikBlrcM03U42
	ZghSCAAYsMUVZgKEN//P/UrCwcqadpB3K2fO4IU/oTrmNYZ9bPZCSzpunXRjA6BXfyadWg9TcoP
	eCRvx6Wai8NpJ97EcmgwmeGI5jKmZVPYvS+/LQ46lfvrJKBjW8tsaqF4smmgOOFaXpKpQAwqEYG
	aJNL+KWzZLz8U8OiNv+jp+39Qz1ii0eVo0mLOiOmwRKT75QZ+q1m3UXWW3krPCSb2I8cCQ10aBo
	BAkoJM7oLlzMhyhacyYKB/QQmP6D5ey9VtgbomldXPndAZ+SOG15hDSSMJpJJgSDICIzWJmmI/w
	3ehLK+xKhxWhOK/OfXKT73IyjCTHVwAfH535PocHopwI3FQgrQaLrB6P517jdQQdkKrK4VilCa9
	g+mGAQvbthszTxywk=
X-Google-Smtp-Source: AGHT+IGPZQtZaXpB5KQ16hieOpy0bgFcG29LZPkxphuKGCWvRd3WuhUNDUxdZ3+qFBNVj+jHlwKp4w==
X-Received: by 2002:a05:600c:c4ab:b0:45f:2919:5e91 with SMTP id 5b1f17b1804b1-467e7f7e36dmr43014905e9.16.1758293884348;
        Fri, 19 Sep 2025 07:58:04 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:03 -0700 (PDT)
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
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 07/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Fri, 19 Sep 2025 14:57:47 +0000
Message-ID: <20250919145750.3448393-8-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55664180002
X-Stat-Signature: s7an9mattfa85mngxfyswza9xa3f1xdo
X-Rspam-User: 
X-HE-Tag: 1758293886-11069
X-HE-Meta: U2FsdGVkX1+ERvc99DXMhCQajAWtOiWIhPP8nqdvfUZIO9WdgSDfm8Rb8kiWyiQW/cvLX/mQr28TcuMeT8KKb6auOrW6Sdt6FjBFuQwbNsIpG+mNfl5P/cscJum0EeZJKg01T6+gCcbYfX/6Ax+4PxzplvXkBdLRMtCTpI6M/tOBKkbysqJVqN30u60pvy73RN5mVIJuHLC1tRwpeIaYVQlLW/P3EvTi4m4P5qHnuiGLGODKcRCsUDtK6o5gqj63stU6NOs9nhsjXoRpU4COMVimWKrpNqWgeszZyQ6yGrGAymg5wpMjZNQpDPVOgsTE4BnrzrZTul31E5oJJ5bDRPzY9po9vc4e3vhBBvm6L0ThlTYE3hy8Y4ga7WAOHNvK+RvwdNvDCLsdJtgFHvr0mrviomrwJ2xrQHcPQQgY1PhntY7yZtKe/Ge0shLPBmEGtf+SpFO5Sha//+wUyQBMWMFqdKGOwrE2YcJXwSMfHLpBDsk5nExYxQ81iaDWptSJR72Ld04ek9nN8CY18dg0hkkY5El5cyvvMkuqpZxfxLoHXNZLPXMRtjYHxuDIZZSBV3/wxvu6+/YtNvXCJN2OrJliJkf1w3ZVWAgWZFfOyihKlpVpZE6KGVev21wiXGT5CHvYQalnaqYdrFxk7aN3PYsU9Y+6nCY6Pv903iiGRIns4tj/0tIIdzi0lzxV2zY0+WOlYo6ZQxro49AUByVbsog54bj4WjuLpUN9tILirDIY0/9Uf3F1IIQFzOVkCdqBalyRb2a34IIcJK1a717OKquYrKMWHTJTS+XE93aQrFMe5w1BLkLXfmflI41+Xq7N+FVQ2+4DJA0y4SLs4RdTqEFq/2w4WT1SKZwO3bvFYkAbi47JBUitc6Gkbid4kWrQLC4rHOcnRxW2qaTw70L16dF7kRm2410prgvEgW+kOJu+ic7XXbqcQTiDuq4BujtiLPQkvimzClTMFJg8zh+
 Z9BBdwUf
 ioxmw/p4IVPnl2Kyf/541bnxVKNrfF6oOL1FevG/rNPOEVg5OWXs3/S478eOqv5KNvfJd8QseCHDom2pRL7DZAFht6boVw33y7MeyZiTAJDxeSp+6UY5PfQSXxiGGn/u0T7E+C2FBGiFBFTywUMXNkHwEXyij140DAUxN4zCYqQfzSdMI9XtRepZxBu1c7vFLRJgWOfOZkBghapOEE7ZfWMgNuUNborBVxrZlO/UxCyAXK9sRJQez2iG+RLzPrbzM/DXvfaA+AMp7MdM0rZqjQ2KLG+TJJNDByZ5rr7GOpDqNgvQEt/5MOU0Y4f4gr3th9InppapGhgSC7F5iI1k8ZpOelhNhmUTkEyIWaQUwKt646s0sRucl/YwxTPzCRAQLx4Rv5x/2NxX5DmARHRTOwtY3Rpv38vUJCIw3jJOWastZHI23En8XBvUzgzAjqqu+n/ayNhN7q7m4jc1t7yeN4y5170Cnppuykk+lRRiojappt5vNefsmbUOsDHLxYW3NSqDQ77HooRR0+ACzV7ICagaqZA==
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

The targets are defined within crypto/asymmetric-keys/tests.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

---
PR v2:
- Make fuzz targets also depend on the KConfig options needed for the
  functions they are fuzzing, CONFIG_PKCS7_MESSAGE_PARSER and
  CONFIG_CRYPTO_RSA respectively.
- Fix build issues pointed out by the kernel test robot <lkp@intel.com>.
- Account for return value of pkcs7_parse_message, and free resources if
  the function call succeeds.
PR v1:
- Change the fuzz target build to depend on CONFIG_KFUZZTEST=y,
  eliminating the need for a separate config option for each individual
  file as suggested by Ignat Korchagin.
- Remove KFUZZTEST_EXPECT_LE on the length of the `key` field inside of
  the fuzz targets. A maximum length is now set inside of the core input
  parsing logic.
RFC v2:
- Move KFuzzTest targets outside of the source files into dedicated
  _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
  Ignat Korchagin and Eric Biggers.
---
---
 crypto/asymmetric_keys/Makefile               |  2 +
 crypto/asymmetric_keys/tests/Makefile         |  4 ++
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 26 +++++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
 4 files changed, 70 insertions(+)
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
index 000000000000..023d6a65fb89
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,4 @@
+pkcs7-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(CONFIG_PKCS7_MESSAGE_PARSER))
+rsa-helper-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(CONFIG_CRYPTO_RSA))
+obj-$(pkcs7-kfuzz-y) += pkcs7_kfuzz.o
+obj-$(rsa-helper-kfuzz-y) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..c801f6b59de2
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,26 @@
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
+	struct pkcs7_message *msg;
+
+	KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
+	KFUZZTEST_ANNOTATE_ARRAY(pkcs7_parse_message_arg, data);
+	KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
+
+	msg = pkcs7_parse_message(arg->data, arg->datalen);
+	if (msg && !IS_ERR(msg))
+		kfree(msg);
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
2.51.0.470.ga7dc726c21-goog


