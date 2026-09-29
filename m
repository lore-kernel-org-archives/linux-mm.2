Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC59CCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 12:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64946B0088; Tue, 29 Sep 2026 08:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14FA6B008A; Tue, 29 Sep 2026 08:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AA36B008C; Tue, 29 Sep 2026 08:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99F966B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:05:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B08E51204D3
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:05:37 +0000 (UTC)
X-FDA: 85266670314.24.9C74D24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB644A0005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:05:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g0qkdzdz;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790683536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IeJBDf1b417jy+i11l2wZ8S+9jPVVEPLf0gsDfp/frs=;
	b=VA6fkWQ8+To7D3DblraaUtiYd3Gfr4tXeyUY/XsaSwZu+wsLkgrQT9h6Emyljtgi2vfCLZ
	iqrOOUROl7wOrsJyJPBxEHNyPg1Qg+5JcfAY7NSogIWXvstgDowUm/6HQUsXdSZNGO6jMd
	XPPcnUfqZlfO+uVJHbaAZKRYyQXJ9j4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g0qkdzdz;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790683536;
	b=DYdcRPfa6jVsWRCzCf6AG2d+PTQOHhc5FVAsPpPJaRaCcwee3X5ZkNmOLGjzqRa/qLUtZl
	1bgavHlRaRsUb9DpxKWwSwK5ZP9Da4b1mtJQHbhG530xeKw5QPDSdlwJDO+ooqV3doWIQx
	SxkS5w83P1EII2Ccjk0adiTCt5RpOPw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17EEE1476;
	Tue, 29 Sep 2026 05:05:31 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D15D63F86F;
	Tue, 29 Sep 2026 05:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790683534; bh=vUuie+qDqthHWW92rj4hGf4q1VZUQf2gLO+ErZoFFLg=;
	h=From:To:Cc:Subject:Date:From;
	b=g0qkdzdzbsZeKr8noK/9BvgTQud9GeBvwH5RO9Gme6oQ8sI2NE6BsYFg8ZKPPBfci
	 7mLGsbZeU4mu5SC8BFqCJcrOzw0OBVESwX8bzh4xrEb7iaqyU3gotcutZ8Q0cHMPSe
	 m+WO6RXfTBZ3ySRefZOIAp1o2kNWXmR9FO6IBvNQ=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [RFC] mm: Add KUNIT test for ptval_bytes_to_hex_str()
Date: Tue, 29 Sep 2026 17:35:30 +0530
Message-ID: <20260929120530.3394073-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB644A0005
X-Stat-Signature: 8fpagfeec8c44585p66uwny1ax5eik17
X-HE-Tag: 1790683535-140341
X-HE-Meta: U2FsdGVkX1+5xMsVWIFsUk3HfhQHn5rtohFuYglEcgCuJ5Wim7R8L/+B0M9O6qepsfOGTjvrm9KXmzlstJXYoltbHElxgZKBf5L2ChQIimsCQLamXBFLGUSo9GMU/Me29FIo7kzKalvkwvRkNI7mgMxu/8hsC7cVJwufD3unOdzJ2jJP+gMWIidKzSi3O7GvRkp+q9ItRBMnWebALjzG2yEV5IPABC4v4mY9yao/Jnh3vNjmd1UaERfjzXmoegU4FI+HtfxDethD19Tc8uzC+WG0kTtS3D0iTzpSGTwQewhiez3OCXn1IQoY7PIZv3UaANznhziDKArFTPN7rJAoJl8oB6/PBRTubuHSI4oBgY3hMKXcKcZuklAipLHxENzdFbO//EUxFAku4tgU7AOxh5pnEfs+OMQZyhaqt6DEZ7oWREJuUe8qpzCObzo4m+8fsgiOwJR+eXuJYC8j0iHhbk5x/3PaPF3x37QpHn1v+e2xs0KqR7ibuNDuzGNwmMpVa3i2rCOlDSLJzP08aZZYUnS/YmoGQ9YBuiCLjav3Hse8EDWYZUCkkX0IXV6z3Groo43YoDL+fwN8JG7jhQjgonmNtYtIjPJnKT3f/yFPNGuw9T8Hk45hVmsbSfRrpLTq7LmZA5Takrzm/8T+HuZ3l27OYZGKEW6GwIZZy7Ku+ftNKmJvKi5zEsLcYJBqMTUFfCdbxrDNAlM20QaFLaTvCn5WUmlQU1vnN4cANOi/Gz90ntsy1A5RH9e4PbZB7f2xNMA3+T3cBPcj92Rv1Omws0SNJ1z4kSkQbbWDVoQ9EkMmkwYMWXUrT/sURAjQ0A9EiX1KSX4id/HKaeULcZitxAdhDjOMMpfnMuaCLudyeDilOUR6BS+QvL7k8zP6bMdgLJpH2iISPPLcSOacX3hZTtGywgTveUUffTwdUyB86i53yNDjW0swBSsJ76DY93/Bw+xu4cqs9nu/pP3GXXs
 Ktaste09
 PfSdpjQmjiOPIHbLoA3KzVpdgpLPPtPfkcMANl23bALzDk+nmC95WOoPHK083qZLdy44OQY3BmkEhPnod2oryh9OCqV62/UdWr4ymC2vbaphf8RtRVnOyB4lYxM08bhzjqepMOocGUGmlzB8+b7E3U5gntwgByK6Weiu4nA1hgf0fIT/Znf1fk/ksKALwtcCAyPFKpTVwqxeb58CQIvTnN/23kR/UYpRW+xK7DuJycZTOaWsIeUdSl0GgcZQwk0LKWRJ+uzjnCid27uQ5LVE9GeY7hrrm+jqItLaGwCCFobP4pAbLzr6V3ekraUvgm3OmLQathLMavPtISDenYHzECchnBlANImHwQGYbwli6U3Z1ZJoCR6WKQnJXKjmhQps4FOWCmF5gmFeQOyju0l+6X80ggbwb6TNmsFh44acCYEJHey5yw+pqdJuMm1SrEa4ZVu69DmMN+YPbIvQ8LN9HcAKh56pgsoumNZlI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit tests for ptval_bytes_to_hex_str() to verify conversion of 32-bit
64-bit, and 128-bit (when supported) page table entry values into printable
hexadecimal strings.

Add a new PTVAL_HEX_STR_KUNIT_TEST option to enable the tests.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v7.3-rc5 after the following series

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

 mm/Kconfig                        |  11 +++
 mm/Makefile                       |   1 +
 mm/tests/ptval_hex_string_kunit.c | 111 ++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)
 create mode 100644 mm/tests/ptval_hex_string_kunit.c

diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acbf..f68bf26b98c83 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1511,6 +1511,17 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config PTVAL_HEX_STR_KUNIT_TEST
+	bool "KUnit tests for pgtable entry string conversion" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to check that ptval_bytes_to_hex_str() is able
+	  convert given pgtable entry value in bytes into hex strings which
+	  could be printed.
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c665..d08b8bd01917b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,4 +147,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_PTVAL_HEX_STR_KUNIT_TEST) += tests/ptval_hex_string_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/tests/ptval_hex_string_kunit.c b/mm/tests/ptval_hex_string_kunit.c
new file mode 100644
index 0000000000000..45c203cfb49ae
--- /dev/null
+++ b/mm/tests/ptval_hex_string_kunit.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <kunit/test.h>
+#include <linux/pgtable.h>
+
+struct ptval_str {
+	u64 val;
+	const char *str;
+};
+
+static struct ptval_str ptval_u32_tests[] = {
+	{ .val = 0x1234abcd,	.str = "1234abcd"},
+	{ .val = 0x4455aabb,	.str = "4455aabb"},
+	{ .val = 0xccddeeff,	.str = "ccddeeff"},
+	{ .val = 0x12345678,	.str = "12345678"},
+	{ .val = 0x87654321,	.str = "87654321"},
+	{ .val = 0xaabbccdd,	.str = "aabbccdd"},
+	{ .val = 0xaa44cc66,	.str = "aa44cc66"},
+	{ .val = 0x11442266,	.str = "11442266"},
+};
+
+static struct ptval_str ptval_u64_tests[] = {
+	{ .val = 0x123456789abcdef0ULL,	.str = "123456789abcdef0"},
+	{ .val = 0x113355779abcdef0ULL,	.str = "113355779abcdef0"},
+	{ .val = 0xaabbccddeeffaabbULL,	.str = "aabbccddeeffaabb"},
+	{ .val = 0x1234567812345678ULL,	.str = "1234567812345678"},
+	{ .val = 0x0000000000000000ULL,	.str = "0000000000000000"},
+	{ .val = 0xffffffffffffffffULL,	.str = "ffffffffffffffff"},
+	{ .val = 0xaa00cc00ee00aa00ULL,	.str = "aa00cc00ee00aa00"},
+	{ .val = 0xc0ffeec0ffeedeadULL,	.str = "c0ffeec0ffeedead"},
+};
+
+static void ptval_hex_str_u32(struct kunit *test)
+{
+	char buf[PTVAL_STR_MAX];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ptval_u32_tests); i++) {
+		u32 val = ptval_u32_tests[i].val;
+
+		ptval_bytes_to_hex_str(buf, sizeof(buf), &val, sizeof(val));
+		KUNIT_EXPECT_STREQ(test, buf, ptval_u32_tests[i].str);
+	}
+}
+
+static void ptval_hex_str_u64(struct kunit *test)
+{
+	char buf[PTVAL_STR_MAX];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ptval_u64_tests); i++) {
+		u64 val = ptval_u64_tests[i].val;
+
+		ptval_bytes_to_hex_str(buf, sizeof(buf), &val, sizeof(val));
+		KUNIT_EXPECT_STREQ(test, buf, ptval_u64_tests[i].str);
+	}
+}
+
+#ifdef __SIZEOF_INT128__
+struct ptval_128_str {
+	u128 val;
+	const char *str;
+};
+
+static struct ptval_128_str ptval_u128_tests[] = {
+	{ .val = (u128)0x1122334455667788 << 64 |
+		 (u128)0x123456789abcdef0, .str = "1122334455667788123456789abcdef0"},
+	{ .val = (u128)0xaabbccddeeffaabb << 64 |
+		 (u128)0xaabbccddeeffaabb, .str = "aabbccddeeffaabbaabbccddeeffaabb"},
+	{ .val = (u128)0x0000000000000000 << 64 |
+		 (u128)0x0000000000000000, .str = "00000000000000000000000000000000"},
+	{ .val = (u128)0xffffffffffffffff << 64 |
+		 (u128)0xffffffffffffffff, .str = "ffffffffffffffffffffffffffffffff"},
+	{ .val = (u128)0x1234123412341234 << 64 |
+		 (u128)0xabcdabcdabcdabcd, .str = "1234123412341234abcdabcdabcdabcd"},
+	{ .val = (u128)0xc0ffeec0ffeedead << 64 |
+		 (u128)0xc0ffeec0ffeedead, .str = "c0ffeec0ffeedeadc0ffeec0ffeedead"},
+	{ .val = (u128)0xa5a5a5a5a55a5a5a << 64 |
+		 (u128)0xa5a5a5a55a5a5a5a, .str = "a5a5a5a5a55a5a5aa5a5a5a5a55a5a5a"},
+	{ .val = (u128)0x4455445544554455 << 64 |
+		 (u128)0x2233223322332233, .str = "44554455445544552233223322332233"},
+};
+
+static void ptval_hex_str_u128(struct kunit *test)
+{
+	char buf[PTVAL_STR_MAX];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ptval_u128_tests); i++) {
+		u128 val = ptval_u128_tests[i].val;
+
+		ptval_bytes_to_hex_str(buf, sizeof(buf), &val, sizeof(val));
+		KUNIT_EXPECT_STREQ(test, buf, ptval_u128_tests[i].str);
+	}
+}
+#endif
+
+static struct kunit_case ptval_hex_str_tests[] = {
+	KUNIT_CASE(ptval_hex_str_u32),
+	KUNIT_CASE(ptval_hex_str_u64),
+#ifdef __SIZEOF_INT128__
+	KUNIT_CASE(ptval_hex_str_u128),
+#endif
+	{}
+};
+
+static struct kunit_suite ptval_hex_str_test_suite = {
+	.name = "ptval-hex-str",
+	.test_cases = ptval_hex_str_tests,
+};
+kunit_test_suite(ptval_hex_str_test_suite);
-- 
2.43.0


