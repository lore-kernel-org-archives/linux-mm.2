Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A75D206A7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9C36B009B; Thu,  4 Dec 2025 09:13:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780826B009D; Thu,  4 Dec 2025 09:13:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698216B009F; Thu,  4 Dec 2025 09:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8C006B009D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76204139114
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:19 +0000 (UTC)
X-FDA: 84181980918.05.30DEEA0
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 807F41C0013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xa1tlehD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857597; a=rsa-sha256;
	cv=none;
	b=q2YcyK6I1GN6NHKAJ0XA3qGR1cw0VCj4Vu/qijh3os+G57VkGOIzeTihtPhSpYQemjKQjN
	gYwio3KH1uPKZVyB5AJabVl9RgZIorrYu5wOcDbjgwLDrkCfpKUAkuzLGWP0N6oYMW2gKA
	4GGVuwns9k4i3gb6xzBwsHTiUm3Yp24=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xa1tlehD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RabXc9ZxWPd5N856tl6EMMSdBPz7PelUrbPrIKztc18=;
	b=Vuk+PU58lnV//oO4vUhCVovTJlECV5dlFNv9b5E1Te8sXRLFCbag0ezHN2RSNQv+8IJChw
	XTz3IM9FwGaWDyRolzx9ZP5apBGg2woqbvSl1QTfEXN9J4uo/xpa6+3ILAh7f6RLujAtcc
	6P9oZbfa8aBwi+J+QVRoD07eGSSplhI=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42e2d44c727so550049f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857596; x=1765462396; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RabXc9ZxWPd5N856tl6EMMSdBPz7PelUrbPrIKztc18=;
        b=Xa1tlehDiz0HYmZOcTm6hpp6KoRYUTF8h7Hq9mdPyWMFtbi1JQUXUDfFHtxCAuSeI+
         kpexBc2hlnnYUDmXImVswy97Gk9l3q8bs4HfSRTEhX9wCrYupGJyZ41opF5XVCSo7CgD
         V+3eAWRqk3mH+7kXAKrzoTUlxY/TbRgvPhBUt27G5XMPkD6teqtwBzFBP3tmUDuLvc7u
         d9r0pd7i5NgyND/LH6/nMWgRGyXQelQTZ+AhI6s8MNI8W0K91AfAZ+RxrPeFB6C1Wwuh
         sojD8qD3h8BfuF2+gwibDR+QAgUBczHpkxaEJq62+fmOM/+pcakOG82UEDGMK6p3BiNw
         ycPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857596; x=1765462396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RabXc9ZxWPd5N856tl6EMMSdBPz7PelUrbPrIKztc18=;
        b=LwIg2M3VfFNbNSseq2nnyQ9sjwBoqP+DAYSkvqCDP1glLYIeqafbzrahZXOiiNM3B7
         lcEd0M/3UIWfZwwTOePBOeic7rMOGIv2wZLqzDAlb7ympIgmbTLvZNjYxXoX+LcV/hez
         gf43Di1ElKzaTd+jZxQ6ifJv3D/1uAMWWor8HnmPppevAXZgFj9U9QJ1laBlUi/B/F2x
         J7AypdnQEutM2+V4NxJQjUDMYAMBLHZeS1tQloI/oUQgodJ5gZWVbsFOUfN4pEVz72nF
         +0A8L65DAOoBelyp+fX0fGvHgy+Hk6c3huhAWKOtyPCyJusX7qpHS407Z1MfjdhBhmH8
         Ubew==
X-Forwarded-Encrypted: i=1; AJvYcCVtVlUAA3gq2wtIRLfH4MKiH8yL623l8DEewko27gVdENKfyL+EMHEHAt9ur3Q62xoMwXaRnviGDg==@kvack.org
X-Gm-Message-State: AOJu0YwsjQ461Fo9udm5l2t56khyvjqclZkhhzSpkPBZuE5z9DK+KTMt
	/osGv3gV7nj6Ea8b6yVtLi8QBz8VrM3wb1JeKyRFXpqxDXq/l09B/4Yq
X-Gm-Gg: ASbGnctP0hvR3k1Y+z44IcoCAlLPSzh7QtqtCa4iH44K7loAuIBtjteltAW9qvxRpg6
	fjdPN4CttiR6pFHwOvJxGqTfY02nFLXjRP6cv+YALeomT7BYzmfjov8lCMs3/g3t+IdsghjAoco
	Dwl7c708yJ43DZL6HsR2Hs7/DenAf2rMS8uBJsNgyNoiNNb6mkkPYR7bhDDIgh+vL7Xx5hv6oq/
	ac6JcAIpFQ2YnNBldNFSFp5vbcgvfv0eXRyzcGuhPlNVxj5wYnpZjk0zzvkWEGFyS0CHZGgCgNS
	FLeVCG43Ix2l/jzDn17kkSBwlD2+XC8LwSKaSHKfe+dnWXwMdzplcFUtWrXvUIr6AssWRzaGlpC
	VdxDpZYgAl/SlIe/gnqa0oDOdLqagb8B2t/HLSCFXTLbgybMxUs8GsCeQb+B7ZaEf6OV2LeDrde
	vXXY0PeJGW3sgXSYsbLtsVPdwJkIKhC9EGS5iU/03SJLJrpaAgsux8DcyOpdDnLsOZ+A==
X-Google-Smtp-Source: AGHT+IERDnLFLwOhzCzxM3fAOB4m9Q5P8T4LaKuBCRN+Nt+F4adsNxaxUHUrlib3xIGvfpKFuuE84A==
X-Received: by 2002:a05:6000:2306:b0:42b:3963:d08e with SMTP id ffacd0b85a97d-42f731967f8mr6489489f8f.22.1764857595783;
        Thu, 04 Dec 2025 06:13:15 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:15 -0800 (PST)
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
Subject: [PATCH 08/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Thu,  4 Dec 2025 15:12:47 +0100
Message-ID: <20251204141250.21114-9-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 807F41C0013
X-Stat-Signature: 1cj8p5x3ww46t4obdgj915hkagpknbyz
X-Rspam-User: 
X-HE-Tag: 1764857597-823541
X-HE-Meta: U2FsdGVkX19XReneqWnrz+mrAQP7x1pxaO6Hdy3RDtlEizL/kHAh5t86NJNTPDZhH005f7zSSO00mUyFn+vTiO/0IauiB7QDzBrogNv/iJYn7sdtOO6BzET7D+71g8qbVRzd1gwhoHwvQSXl6yhgcbDasRvMILJK6WE1x7JUKVNF6lXrgRwk1hfUOc70kx3hQgafnVBGYHZYvjxNtc5UB+sY04o7a2lovpLohqqgETtLgygkHNHl8vKuaZxBSBsnJis2XlNIvUQht9ok0SGMurBXf6eNYa6KHqcTxcS5iu6c0p9BqDoP5pEXx7T412S3KxxT7/Bp8MYsVYotcuREz3xvCazFiP7ZQF5Ih9NPH/IneBFcmeo/jB5hSYNB3AiTNFsoeHCIsUlYsvrHo4DQ/LgwAlcyHPdbFPqtAX/AXsejTDP35IJSxpqJGIALr8KL3Rk3iV9cZSZBTdcfGF47RHw6GNsOdq0eMpbaSS17dXW5tsvKvq7u0Kbpf5GzhaA2QacqqaN3EuSpHmvIofn+o6/TKGFTouYlg4mFOtCF5y+KDtsdivoU097ZOk+vq1+F9hIEJ23PbC6YHMwPO0gJf5GSL8wHk0TpniIrPN5MxWF9A8rCxoWx+55WXpGkKLSYArYPEf2m+U6rJl+cvST0poqvM35agE5i4kJNIe5t+zoNItGuZpOLaFpz9xcC3HeptIDeGN0KO+pIF2UIxXkRX839eFVmX4NMVcpQxbpp2lEiwJpCvISJJO4hu8jkz0wXve7pLSRwbHsQDKxKm7ooe2ieHtjrdeUHkbVja7sWP3vZVjpcZIu43JDlKWjz0nUvy5KW5vPEEtFhg8SUjfwOd6yK59jSMlb5uDJCOuxiNeqpmmEixQnzY7Ru7crrYsaePO1zXswhkGyouisU/zFxY9DZWcwMlyux+bWgJ/eCCJ8JterdWMhkeOHveuNfrDS5b3fgxsEt8fGFmIXIYPu
 cnmNgaHv
 iFpThXmDlR5sO0LtcZyu8lOJQk8CJ76GwrkaO7dmVmU/5NPuiaxYwWDYnJNggs6aXdCsIuDPye+q2U0U0cKwlBHDKDlx+MkDCxGV5ypiywR0dmL+7xOIKDHwfRqnoe7dsosmTYrHvT62m9JvlR1PDXtYhyTOYSptCB8K0ySFtXgrJ9l1C/Y7VoVkrSRRlG40ASb3duSaIf16zHBHJYTUz9G3+VfPleHFeYSPHduAtbYYIbGb1TEDFvfE6saWXKT+iB/UWsR1qXqpkTGoi4QeW3f0tsARCyiZOaiLdoCCHBnM8JrsRm8OFVlloCNjfb3deJUrfo2kX3XRkZkqABp33NYir0/QC1heb7K6frWsa6F2W9bOJCuJjFhvw7clMYNIgsBGhfw3HBikGkbHB9H/vNtXIOjh2eqKRAkg8oZYqVfqWvjRBF0a+VuTxPIk8MNj8aifEw2tqpXUOlrfJFXK5NwADPu9zgW9BDyFpzJC0mcS7pFbN6b7gJV4cx8dQxc/nKaAJrlZZROq/Nerpg0hfuZco/ApUwy1sa06ES3kO38oulmjZkMBCDQgnBw==
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
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

---
PR v3:
- Use the FUZZ_TEST_SIMPLE macro for all introduced fuzz targets as
  they each take `(data, datalen)` pairs. This also removes the need for
  explicit constraints and annotations which become implicit.
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
 crypto/asymmetric_keys/Makefile               |  2 ++
 crypto/asymmetric_keys/tests/Makefile         |  4 ++++
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 17 ++++++++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 20 +++++++++++++++++++
 4 files changed, 43 insertions(+)
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
index 000000000000..345f99990653
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PKCS#7 parser KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/pkcs7.h>
+#include <linux/kfuzztest.h>
+
+FUZZ_TEST_SIMPLE(test_pkcs7_parse_message)
+{
+	struct pkcs7_message *msg;
+
+	msg = pkcs7_parse_message(data, datalen);
+	if (msg && !IS_ERR(msg))
+		kfree(msg);
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..dd434f1a21ed
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA key extract helper KFuzzTest targets
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+#include <crypto/internal/rsa.h>
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_pub_key)
+{
+	struct rsa_key out;
+	rsa_parse_pub_key(&out, data, datalen);
+}
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_priv_key)
+{
+	struct rsa_key out;
+	rsa_parse_priv_key(&out, data, datalen);
+}
-- 
2.51.0


