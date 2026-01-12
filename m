Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E5ECF45C9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE656B0095; Mon, 12 Jan 2026 14:28:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DA96B0096; Mon, 12 Jan 2026 14:28:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60086B0098; Mon, 12 Jan 2026 14:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A38B46B0095
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73250C3A3C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:51 +0000 (UTC)
X-FDA: 84324299262.12.AB2D9B2
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7BDD94000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f7GkAomQ;
	spf=pass (imf11.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246129; a=rsa-sha256;
	cv=none;
	b=g4muZtd71/NzuTax5MS/yqdXJ4KDEo52Qto/UkJOcyO4dWj8V6QDJkphefSTJQzHUkkmKA
	2HDosvgFrfw65US1mj1ytwZyqNwprsgqIr3G+acOt3sNwCD9cohIMfGHg6OTBlOGThAxj5
	PgjA2uJ4gmyEhAo21QqdJq5mZQ9Xm2k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f7GkAomQ;
	spf=pass (imf11.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scWvVJzBtZkgblH2r+AxXX3I8YFcDE4LdHFKMGvKaXc=;
	b=DhG+PZe1YtP4RvZrOAk2GtpvkJefrs7v2BKA66CjLQfKbLJdWMy4yP2sl4oZGNnhX782Qj
	0b1TeWdfWSecbObqZwpKdUxAbFGmFLTJx5FRyBLplNfB4AXiI2YfmGxqw2orH3gIgnas0H
	Kl59MHCNCjQZsrxA8XyLidHJBDUSZSk=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so11321556a12.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246128; x=1768850928; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scWvVJzBtZkgblH2r+AxXX3I8YFcDE4LdHFKMGvKaXc=;
        b=f7GkAomQGysXwoOAYqlROWKuY2y68EGYbyvjfIo2c1p5eFyXDHvoL3UjehaQ7bc0LA
         G4u31XT2faryx5VLoDRZLmBCeaJ1AWRDURerhDvZvkLa0FlTVFnot6UAgH6YVcobo8PZ
         Bqi+NySlddDDnDhjva2rGDeR2JzALD3vNq11gb+jNXl0VYjQTF2hGUAnCTX7+usMqk+5
         GCdU4JISjPzW8uAO0nh6u/UuCda9M+8ywNO8097GHWGK1DfRKmWI7tpjfAtwtZD7cxIV
         s9sL2h8lHBFe5CnW5Svl9Yg1r2rzZtLJpwTvLn0ZdXq+ImBq4PeUDRX42UZ92eGcpJZ2
         rVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246128; x=1768850928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scWvVJzBtZkgblH2r+AxXX3I8YFcDE4LdHFKMGvKaXc=;
        b=UaMYytSosjjb08XqOZueUuop8PCNb4XECzuN3RV1+Dtt87oW3vcS74Uy9oWwIaSXLp
         DdnDRPYtq3aXppMlZiwnAjRpLn+Uc4gA3lKfXRf32vnmCK9XQQqZ0LY+aWEPGXq+d4bL
         GEpmKlyBcqJyFzu09wupAz0uGWSW+K6mx7Z1kCaRX63sBVF6O0HU59YQdcZXkvB1lYQs
         SCwYz8Kr8PiGfC3xVOPUI6pzNTU0UoAkarknsRo551j/Sk9MffNLNpcvOJZgOEpgmAo/
         mKDKKEpBO2X9BY3ySO7F8w3SThV78Im7Pe4627kkJ1kIq6wl+xRxpNvECC5hsPt0VZBN
         4ryQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2IPFaUMyOKw8MJE5He3TJ/xg89ctn8DSJaNhQdTPmUu0O9K7gD282XNSXlzVYWp5Ki4Q8eW5cTQ==@kvack.org
X-Gm-Message-State: AOJu0YzCs43h2MS8lj9DyqeRmudHPSvowZ4d3zWLx+f+j7A3OEHKikOP
	ZqgwPbof5ZavRyckDgSnRDeKLwbchVDzdoZ5rT8lR619RxZTVoAynGbU
X-Gm-Gg: AY/fxX4vICJ9XQtldFNjC2Ey6RXjOyPgylGt/L9C9UHBgLqks5LLURDDxIYS4cknu7S
	qnD68mGARajQ0YKo0454NHBG7K4hK/xku1PjdnDeaOwS4sV2e1StOov97KsM9qLlBJs8mpuVL45
	tTqwkUb0UzDtGBiSHHH9gAK9MDbKczXZkpppesR3paf3UARXemkPcFyC/0H3ev813Kg1mj7PEtT
	6BdBqekhCgNblMNByuKn5arEs401bQ6Y1rp4GGWqECWbAE+eJSx8MHqmfx7yGGQK2Kjpad3l13s
	qrL5CdbOYjJnW2WFwPzdWVkjq+zjmiQnRLhRrptcnd7VI/o/QJsskmK6WgExWkD8oydWs4vnXLI
	l6v4ZTGdkYwbwAUQA7LfTH13U7wQ59bOMVc/in6mRtFUm9eZdwb4DVen9C9FlXva99+780SLyu7
	bAn9o/Dnyf48xeczsoZ6J1WI96CM+0+cor9FE5EkYPcvThWURD6w==
X-Google-Smtp-Source: AGHT+IGPfeGvnJT5nmBAHSLDQSoFK40ixCTsrNs53O6zDl7hozUe2ok/2s0XG0MJ5qFaw2WUbDeLwg==
X-Received: by 2002:a05:6402:1e8c:b0:64d:f49:52aa with SMTP id 4fb4d7f45d1cf-65097dc6439mr18130109a12.3.1768246127869;
        Mon, 12 Jan 2026 11:28:47 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:47 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
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
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 5/6] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
Date: Mon, 12 Jan 2026 20:28:26 +0100
Message-ID: <20260112192827.25989-6-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kadxfncuxrxy9n6hasxpmrsix4xezzdo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7BDD94000B
X-Rspam-User: 
X-HE-Tag: 1768246129-532441
X-HE-Meta: U2FsdGVkX1+Z/uvTLOArwpjWvPVq8xcU/2+u+WWo3QdAidHmfTJgWOdCh/EtX8PzHOhYxGwiTlIerfxWfMw1e2eg++k5ivNeRrVr64c5PHLGvG/aQ9wbPfXP/Nr1S0rjxKY4ah2M5yuxxidQcL39oxWPNThsusyox6AqfI38bmPU0oZ0ibinWfTFdCdN70/IefFSgmZt0t4eGsQ1Wa5VULCYliqXXy0RGdAmiOqq087K/6f2HCpHU9SEgA/lh5z4BXNAJlOVivTXMR757z9d9sed9yL9flEBGMoUzBSStkZX4B4GNa8PSG2jppe37n5TiUy1drvx4uv8QGuGVrRg8ndSSKyeLWLMoUQ2v/MMvK6Atr3C314mJ46uIcclmbSmDXsTmSFo4/rzLbsrrQG9Y09OIZQ0V8FXxPs1INpBusWj9tfj2WuqX4MQecoau9SF7f6sVe7XZIVhKrZE0ot5cX9d7wE2P1/Vh+m5JFOO5hMVHmm0pl461FW5im+I54NGoJ6k8JjNAEkYEiY0VqzIzo75lYw7U9ni+dt+XcvrboefDc8Wol/MYZqlnSc19BP9+B5Z7bLim8t3L0dlNDNcIdvaGcqzEqGuytzE1Gpk5R14GI2QvPQlshGklhDP2kWKLrWBghCQsXX0NH4ln5H6KmLqW8vAZVy2SmQFTORrmBYtFU+UhF4nfv6Z6/pbpQpjwZ9rmwT8eVVswxcbpaDffznImt+8uu3/xyfPGtpzO1gKT36Xq5Gxu+bOUTzuJc1LQTSrSioVmOcRxGw51klAEs8wWdGept7TV/bcnLCqPqxmVWvidM5wSsGONFRunVaN6AVUTH1udmJy+wVCt3VlbnM5I997PPEGaWaNe/e1fWydLn5HyAxGcfGWEJN2bGJGcEMW382mAkvAfwU4N8IR+x5kWPRTt9d2xQ1JpNlx8hmzcmsB7+2xgR6f7OksE7MXKm01QV6UuGxL8hQrsep
 9FdbkXZp
 /pFHfeoGO8JBh3Aj2t2v5cRLX4KOC63dQtyN1G3df9K9Ht/zl24gh7Gzgqd+Ay04PA0GJTlkgGGsCATFSpAxsQ25FR6/c2qZ9SphDwmLrTK3J7CexN4A/AL1cZSKDegHr2xZyHowQhEib57VPBSM3K5VwETeBi/vUyHHLcb3xPbAMz2O8QtAZmdu7bF3rXq1x4mhx02WdlzBX5xvEHo3FqJwQQzM/abNNx79qEto16qyG1dHU4vzakkWv1ISFQMGcYsbILPTFuZsMMLcJWKV5vEAbxgOn0b9WfxfIikU9F+K3Ri3CaLfeB0ndebRSymUlm9Pl6c6e9NSczdVO+5GKx+GTQxDjfZIaKXNEPI+YSkS1HpNVcJ9vKd1fM88pKefAo1PcHiRoZx+HlXUTXMkkCVFdYKiewicFKYlgEVc9buYZBjRquV5LrSbKoUkdR/lOG+Tc+M8QgRS6jFOX74ZOgw9FMUoUHlJn2E6QFvg7OApzkf9PxtCi8AfIdQQ0mvp06zOUPJzLhK1MfLfazyny4Nbc/tJqO8DmjimjQT5cAImFUVqJu5TSny/9HKbIwenPymNxZccLlSluaEYX7U7td135zA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Use pkcs7_free_message() instead of kfree() on the success path of the
  pkcs7_parse_message fuzz target.
- Dropped Ignat Korchagin's reviewed-by due to the functional change in
  switching from kfree to pkcs7_free_message.
- Restrict introduced fuzz targets to build only when their dependencies
  (CONFIG_PKCS7_MESSAGE_PARSER and CONFIG_CRYPTO_RSA) are built-in. This
  prevents linker errors when they are configured as modules, as
  KFuzzTest symbols are not exported.
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
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 18 ++++++++++++++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 24 +++++++++++++++++++
 4 files changed, 48 insertions(+)
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
index 000000000000..b43aa769e2ce
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/Makefile
@@ -0,0 +1,4 @@
+pkcs7-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(filter y, $(CONFIG_PKCS7_MESSAGE_PARSER)))
+rsa-helper-kfuzz-y := $(and $(CONFIG_KFUZZTEST),$(filter y, $(CONFIG_CRYPTO_RSA)))
+obj-$(pkcs7-kfuzz-y) += pkcs7_kfuzz.o
+obj-$(rsa-helper-kfuzz-y) += rsa_helper_kfuzz.o
diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
new file mode 100644
index 000000000000..2e1a59fb6035
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * PKCS#7 parser KFuzzTest target.
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
+		pkcs7_free_message(msg);
+	return 0;
+}
diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
new file mode 100644
index 000000000000..e45e8fa53190
--- /dev/null
+++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * RSA key extract helper KFuzzTest targets.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <crypto/internal/rsa.h>
+#include <linux/kfuzztest.h>
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_pub_key)
+{
+	struct rsa_key out;
+
+	rsa_parse_pub_key(&out, data, datalen);
+	return 0;
+}
+
+FUZZ_TEST_SIMPLE(test_rsa_parse_priv_key)
+{
+	struct rsa_key out;
+
+	rsa_parse_priv_key(&out, data, datalen);
+	return 0;
+}
-- 
2.51.0


