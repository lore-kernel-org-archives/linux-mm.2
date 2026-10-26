Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D02E2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=VuXym00R
Received: by kanga.kvack.org (Postfix)
	id ED3256B05BA; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABA36B05BD; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C881B6B05BA; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93ABF6B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7F6E1C4121
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:27 +0000 (UTC)
X-FDA: 85365496734.25.B93C068
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1FE9B1C0005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VuXym00R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3_5DfagkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3_5DfagkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FbknuYB2KaKiO/nAwNHeWF6UfDvsJ7xQW+UNHo6NJE=;
	b=EwFUxjOUw8WdJ4bvhWnjrpM/xhGwohiEfJRPFxk9AAY/LsOS1n+FIMSIPySVUMTyqHuRYQ
	k+ZTlB3s+RsX3D92GKT8tiAv4RPHK7vNswJXkvAj41oOuXG2H8nDRsSeooX67XyoSYzpob
	aScTyZyggWUo1zJ9+3W/LjYtvhH9C3c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VuXym00R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3_5DfagkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3_5DfagkKCPwxevyrwelyksskpi.gsqpmry1-qqozego.svk@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036546;
	b=6l0UWeGoDDQRIFOMUvz74iX5j/+W4cf7t8wUe0KdrodkSpK4SQAHCkddrrpZ3Oa1L0J7DL
	Xe4kUyYYTdvtFWkL0gUe8TFaa75jWp90GryBt8aC0cIJWz7ESuh62orQM2CMpddiPmo+Ye
	raQEbdNzI8C2axjDOWN+3HEYE6x064M=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2e8c76334fso292562366b.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793036545; x=1793641345; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FbknuYB2KaKiO/nAwNHeWF6UfDvsJ7xQW+UNHo6NJE=;
        b=VuXym00RzExrjWCchOw7mDjnFokJcrc1XHELj6ftPHqwAuukhNCjiV7lku5A7wGGRe
         lj739j/Qn+XXG3azhTtRR7jyXfii367fTHLgP2OJzlG9zIiNLo5EIAQexpxJ9LgCg2tn
         DoT4z1hU7B00SQgO4HQMU+UBnlwgExAdAwN4rIwWmDEk+BGFIFRkXAkI7TUzrf1Achk5
         KqnANnr76oqVt7Iiqcz7RJk4pi7HtuJmDSobJuska413/WGsUpx+B1/izEnl3+Z36yig
         C0tiD1Jm2It/1rGTfpJeak4Gp6Iar8Vz2SWmFqRpAAoUtn2Qp67M2bHSbmbetpUjygIJ
         zXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793036545; x=1793641345;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6FbknuYB2KaKiO/nAwNHeWF6UfDvsJ7xQW+UNHo6NJE=;
        b=aerZjArYfNH4DOFUnjfDYp60eQoBBOFhCbPvzj5hwoaZMtV48d3z/2ftZel3FEPktJ
         quDYTqHkTfqHBjzeydQwlXZ6d0NxnOhzSbnK7eMvRfLhij/2WP6pE+Fo+SIvnlhb2g3X
         7P2EsvVoNTzRb+APPFP+RbhTxwGyYYha7arfxlj4X8DMPjeJgvE4UoQLD01pDmjrE2B5
         ko6X9vgE0OoWVrsxQmfguCvEUOhX0XdjqlKZcP7RaAb8mQwHvy1Nmdn71+lKrMJW7vIv
         JtPaE9xF71tvx4Xr2O5K4L9G6nk3a5CPHtUVFYmUlWZl0kXPSV2IQp7qIx92qr7pSVFa
         ZAFQ==
X-Forwarded-Encrypted: i=1; AKwUvBxiFxm/Hs8RG+x5YF420vQe161wl6IsQS+nV7sJjtKiDfDAb49AHu0xgMw7UN/2JR63wJj0dTy4cA==@kvack.org
X-Gm-Message-State: AFq9FYIZOckWMPOTsaX9HytdoEki6SD1NvXg0GwmZCnLdXQiVa8MYZkh
	5ETtrBZBXD8Tr2hyWH9X87AXCJsvcGWs1EXr0G62j44p9XYUPQ7h3aJysSy5hTGttI7a7fwugoj
	AJZr/csmrodQQUAIjiw==
X-Received: from ejczw1-n1.prod.google.com ([2002:a17:907:e001:10b0:c42:73df:9346])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f585:b0:c41:e75e:5889 with SMTP id a640c23a62f3a-c46bde3a942mr794298266b.33.1793036543707;
 Mon, 26 Oct 2026 10:42:23 -0700 (PDT)
Date: Mon, 26 Oct 2026 17:42:17 +0000
In-Reply-To: <20261026174217.603114-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026174217.603114-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026174217.603114-5-tarunsahu@google.com>
Subject: [RFC PATCH v3 4/4] liveupdate: Add KUnit test for the feature header helpers
From: Tarun Sahu <tarunsahu@google.com>
To: loganodell@google.com, alex@shazbot.org, dwmw2@infradead.org, 
	seanjc@google.com, Mike Rapoport <rppt@kernel.org>, will@kernel.org, pbonzini@redhat.com, 
	jgg@nvidia.com, Pasha Tatashin <pasha.tatashin@soleen.com>, arnd@arndb.de, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, oupton@kernel.org, 
	baolu.lu@linux.intel.com, David Matlack <dmatlack@google.com>, robin.murphy@arm.com, 
	maz@kernel.org, Alexander Graf <graf@amazon.com>, joro@8bytes.org, 
	Bjorn Helgaas <bhelgaas@google.com>, kevin.tian@intel.com, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1FE9B1C0005
X-Stat-Signature: 6hf659cyw6edxsf6gn7736wuhcok8zqw
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793036546-936368
X-HE-Meta: U2FsdGVkX19bAg1/0x3gXLk+Ij2WDXTYLfdg1Bp+ZkxZPN7OZXktMMdpGqr06hM6HkqFT7PS3ciEMnJ82+hBX8ZUGytUBHRHhfK18DKohfOoTOsWIoxRWgmg+vMgAQaVIl2MG5NQnfHsE6oYuJZ7EZ5vG7GUIiTUoe1O2yUHmaeACc9Yw1nTKwMLwD9rpEyCMAZ8rRW3rgZDWqeHi+qZFaXdCtEZpWdL+SDXSAJZ3o2kLiCawcuuihXOVn+OyI07UgMl1ihZVdpOkUQnpVcQeVKfZK5D8cuYOUZEQyX5Sp+wtWGmIuNFiFr+fqda07Iy5acvMWCvLkryDOQi4hz/FCaiPoutgFBizaZ8EBnjKpcYXJ6jjaHDRZOGnyCxOtw4Pn4DTbnJ2ocWWifH2z75lqLGUWGBjPVElB0woji1UQ+uj5LF/Tw6dZ2g1rk3AnaeGDomFpeSCR8SX+ov+lXwhCcFl4Ka3uOl2/rbzyYd0Y6kbwjoCPX//SdrYmV3fDBreUv0a5YhkoE6DlgxQ4M+TxPzGPL3F7o92tXSQQqUBE4lqy0wy6k86t4ZMV8lZaoMiWCXwM0QlQJ81woDfEukvzIy8a2gX+IyTZYrtGOMti+vVZHLkWLW8yW9aQkC3PQHKYAXd+pDjNuzHIwe02jbFLDlG9nbqH2xNjIQXU0BjIxieDbfZnDVlW0v6rbGqst1k+jhm093ie99yBMAEQNodxcrH2mgPm+qrXjILXfdmAcSSkg9I6ist72J+3w+bdRwUtYmNtDaW3zpaFK2lo0aEw1AjRs5IubmCWouVx4bEmQDsjrOGS6zFUBT1V4aE3CFOe7s9MLPTybbWPDcRs9MA7wKnnXPcNndXrAM9TvbOGElQuHl9iSjBohMXwwpUEFiJgGhhNGyT7VouSWt5BL1L7lzmg26y1X8sMFYpyYA/LShgk3xywMyQMDumD/VrCsRb398FT87VNSF4guuIpz
 cCSG+vHl
 0F23afKpxqa1+Pop56ue5c+NprZE8E9x2ccErkO+0uvPDguulyj0eC7ezca1bbqbTDl5JPxAcC9CuCgGtPP94WSMG2adM9uje8zWEW/P8uvpz3jaGJf6AtXIHbeiaYtRKkLpVb+PmRosnIgoKZCZeXoXdhaZDi/2qvU64tOSPJ3S7cngPW4guG3s8W312z9PbOBlNBWA3gk5BXhZFDnRs+LpGWHGEdYgNl6DYrbxxVGJMy/TFD7aqOjUFu80dMdxdG7n5NLvnDcgheU0h/zLCBNQhLwMYSzNDwZ4Gvx8hq8OZ+IEI8/RKNs3SoGjCiSo9c+FplUF79yI3zQW88xGuaLirdy1l8zjcrDuWh9QcdyjZYd6jKbV1yhaDZeoTgERD+q7LoHvdXX/GFmfwxo9dquJegRjF5WiH7Urg3/vIzQHg87utudeCFKPoqMdLPGB7gdJpycS1yCyfWTjPmzf4JOl2++xBCBkcOe4Bdu5CQ90CamL8v4PB+oZerUevMhRwDOJLUnz/WFSaladVN6ZBE49wdN03k9EvT/uHsK5XhjkGVypgLdjaJYysjanM4a65RQ0OZmGNDCiPe6RluslU9OCm4F+Cd97d2wBl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a KUnit test suite in lib/tests/liveupdate_feature_kunit.c covering
the Live Update feature header declared in include/linux/kho/abi/luo.h.

The suite contains two focused test cases:
- luo_ser_hdr_set_get_test: verifies DECLARE_LUO_SER_WRAP structure
  sizing, header initialization, payload pointer resolution, and 2-bit
  feature flag setting and retrieval across flags entry boundaries,
  including out-of-range queries.
- luo_ser_hdr_truth_table_test: verifies luo_ser_hdr_validate against
  all rows of the feature state truth table (absent, optional,
  required, and reserved 0b10 encodings), as well as empty supported
  tables.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                          |   1 +
 lib/Kconfig.debug                    |  16 ++++
 lib/tests/Makefile                   |   1 +
 lib/tests/liveupdate_feature_kunit.c | 118 +++++++++++++++++++++++++++
 4 files changed, 136 insertions(+)
 create mode 100644 lib/tests/liveupdate_feature_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d1b58271989..dad09961c275 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15191,6 +15191,7 @@ F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	lib/tests/liveupdate.c
+F:	lib/tests/liveupdate_feature_kunit.c
 F:	mm/memfd_luo.c
 F:	tools/testing/selftests/liveupdate/
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 134b15a44625..d8208f3f4515 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2906,6 +2906,22 @@ config LIVEUPDATE_TEST
 
 	  If unsure, say N
 
+config LIVEUPDATE_FEATURE_KUNIT_TEST
+	tristate "KUnit test for the Live Update feature header helpers" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the Live Update
+	  Orchestrator feature header helpers defined in
+	  include/linux/kho/abi/luo.h. It checks the feature flag encoding,
+	  the flags array sizing, the source/target kernel validation
+	  truth table, header initialization and the payload size checks.
+
+	  The helpers are self-contained, so the test does not depend on
+	  CONFIG_LIVEUPDATE and can also run under UML.
+
+	  If unsure, say N.
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 3cac3b63a752..2f1f1f765617 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_LIVEUPDATE_TEST) += liveupdate.o
+obj-$(CONFIG_LIVEUPDATE_FEATURE_KUNIT_TEST) += liveupdate_feature_kunit.o
 
 CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 obj-$(CONFIG_LONGEST_SYM_KUNIT_TEST) += longest_symbol_kunit.o
diff --git a/lib/tests/liveupdate_feature_kunit.c b/lib/tests/liveupdate_feature_kunit.c
new file mode 100644
index 000000000000..fc9d2de263d9
--- /dev/null
+++ b/lib/tests/liveupdate_feature_kunit.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the Live Update Orchestrator feature header helpers
+ * in include/linux/kho/abi/luo.h.
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ */
+
+#include <kunit/test.h>
+#include <linux/kho/abi/luo.h>
+#include <linux/module.h>
+
+struct luo_test_multi_ser {
+	u64 val;
+};
+
+static_assert(sizeof(struct luo_test_multi_ser) == 8);
+DECLARE_LUO_SER_WRAP(luo_test_multi_ser, 32, 35);
+
+struct luo_test_one_ser {
+	u64 val;
+};
+
+static_assert(sizeof(struct luo_test_one_ser) == 8);
+DECLARE_LUO_SER_WRAP(luo_test_one_ser, 24, 1);
+
+struct luo_test_zero_ser {
+	u64 val;
+};
+
+static_assert(sizeof(struct luo_test_zero_ser) == 8);
+DECLARE_LUO_SER_WRAP(luo_test_zero_ser, 16, 0);
+
+static void luo_ser_hdr_set_get_test(struct kunit *test)
+{
+	struct luo_test_multi_ser_wrap out;
+	struct luo_test_zero_ser_wrap zero;
+
+	memset(&out, 0, sizeof(out));
+	luo_test_multi_ser_wrap_init(&out);
+
+	KUNIT_EXPECT_EQ(test, out.hdr.size, 32U);
+	KUNIT_EXPECT_EQ(test, out.hdr.nr_features, 35U);
+	KUNIT_EXPECT_EQ(test, LUO_SER_NR_FLAGS(out.hdr.nr_features), 2U);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_size(&out.hdr), 24UL);
+	KUNIT_EXPECT_PTR_EQ(test, luo_ser_payload(&out.hdr), (void *)&out.ser);
+
+	/* 0, 31 in flags[0]; 32, 34 in flags[1] */
+	luo_ser_set_feat(&out.hdr, 0, LUO_FEAT_REQUIRED);
+	luo_ser_set_feat(&out.hdr, 31, LUO_FEAT_OPTIONAL);
+	luo_ser_set_feat(&out.hdr, 32, LUO_FEAT_REQUIRED);
+	luo_ser_set_feat(&out.hdr, 34, LUO_FEAT_OPTIONAL);
+
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 0), (int)LUO_FEAT_REQUIRED);
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 1), (int)LUO_FEAT_ABSENT);
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 31), (int)LUO_FEAT_OPTIONAL);
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 32), (int)LUO_FEAT_REQUIRED);
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 33), (int)LUO_FEAT_ABSENT);
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 34), (int)LUO_FEAT_OPTIONAL);
+
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 35), (int)LUO_FEAT_ABSENT);
+	KUNIT_EXPECT_EQ(test, (int)luo_ser_get_feat(&out.hdr, 100), (int)LUO_FEAT_ABSENT);
+
+	memset(&zero, 0, sizeof(zero));
+	luo_test_zero_ser_wrap_init(&zero);
+	KUNIT_EXPECT_EQ(test, sizeof(struct luo_ser_hdr), 8UL);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_size(&zero.hdr), 8UL);
+	KUNIT_EXPECT_PTR_EQ(test, luo_ser_payload(&zero.hdr), (void *)&zero.ser);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&zero.hdr, NULL, 0), 0);
+}
+
+static void luo_ser_hdr_truth_table_test(struct kunit *test)
+{
+	struct luo_test_one_ser_wrap out;
+	bool supp_yes[1] = { true };
+	bool supp_no[1] = { false };
+
+	memset(&out, 0, sizeof(out));
+	luo_test_one_ser_wrap_init(&out);
+	luo_ser_set_feat(&out.hdr, 0, LUO_FEAT_ABSENT);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_no, 1), 0);
+
+	luo_ser_set_feat(&out.hdr, 0, LUO_FEAT_OPTIONAL);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_no, 1), 0);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_yes, 1), 0);
+
+	luo_ser_set_feat(&out.hdr, 0, LUO_FEAT_REQUIRED);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_no, 1),
+			-EOPNOTSUPP);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_yes, 1), 0);
+
+	out.flags[0] = (u64)LUO_FEAT_RESERVED;
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_no, 1), 0);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, supp_yes, 1), 0);
+
+	luo_ser_set_feat(&out.hdr, 0, LUO_FEAT_REQUIRED);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, NULL, 0),
+			-EOPNOTSUPP);
+	luo_ser_set_feat(&out.hdr, 0, LUO_FEAT_OPTIONAL);
+	KUNIT_EXPECT_EQ(test, luo_ser_hdr_validate(&out.hdr, NULL, 0), 0);
+}
+
+static struct kunit_case luo_feature_test_cases[] = {
+	KUNIT_CASE(luo_ser_hdr_set_get_test),
+	KUNIT_CASE(luo_ser_hdr_truth_table_test),
+	{}
+};
+
+static struct kunit_suite luo_feature_test_suite = {
+	.name = "liveupdate_feature",
+	.test_cases = luo_feature_test_cases,
+};
+
+kunit_test_suite(luo_feature_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the Live Update feature header helpers");
+MODULE_LICENSE("GPL");
-- 
2.56.0.307.g5fe7bd680c-goog


