Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F1C606A891
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oayyYlMd
Received: by kanga.kvack.org (Postfix)
	id 6C8526B05B7; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678CE6B05BA; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5916B6B05B9; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347BC6B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B78C840130
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:11:07 +0000 (UTC)
X-FDA: 85441320174.03.BBD29EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D1ED14000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:11:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oayyYlMd;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAt5aWJop6Pu0d7LhLCZqFYPYEr0G+2IZf0ofUW/gfI=;
	b=vWamNeBDltralBYSeN3hB0IV9arA3eo18W+TQQzxqO7Twf0SKY+rABqGTRjcRdchqZEK6E
	0krhZ3N9qFprYnZ1oj1agI9SrxUFIzf12+BFq5TuDbaW+KVuTbwzi0I1TWviRF/SZdE9GA
	k+85BrVJnUjTumJXSs0rP4fFjYrHuQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841866;
	b=GkwqW6eBcV+EDvCcOQDGIG4KLwHAyrN8SCE9QEVdz/M8+U2pZ9wqZBR97A6pMCzR4QlMgN
	CkL65tuj9Cc3S2FYRU0kckVlL927MiZEdlAlYx8DpSBeBoTDHOnpZ5QO82dhMldAdMm7AH
	h0PEpwgA9SMvP29Ze+FBdXZFY0GLnEo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oayyYlMd;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 421A640B19;
	Mon, 16 Nov 2026 15:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7801F000CC;
	Mon, 16 Nov 2026 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841865;
	bh=qAt5aWJop6Pu0d7LhLCZqFYPYEr0G+2IZf0ofUW/gfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oayyYlMd88BXip/D3W6vthiAlG7kS+IGPEYdh21vy2cV/fVfMXJCA43m+oCZtobUL
	 P+CfAPVxdXvma8HtULzj6t1wKCV7joPwPSdNCc+FrDxV2XWMDyrNVcs+I8k9DYk2Rc
	 nMkGPtKwhtoofcNlLRO2T6jqGFXONOduUOjLvQaXJj11q+3Ut7HE4SMUb0M8+6Hu/P
	 qEy4pje+8RPkAjLmfdYB1J7nnXMOQfV9HyHmARnmC0+758o7WqaA3umI2Hru9KIcyj
	 4lKIBH0ERyhFHeid6tv5KJ0Xw1BBxyjtMeqEJlOK5Bi831TZR3dzXX34H44Qz48Dgq
	 vjTQvtf9h9Jqg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/paddr: add KUnit tests for addr_unit conversion
Date: Mon, 16 Nov 2026 07:10:51 -0800
Message-ID: <20261116151057.81692-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116151057.81692-1-sj@kernel.org>
References: <20261116151057.81692-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D1ED14000E
X-Stat-Signature: 1s5b9ticyki7z3jti5wo5ehgio71nax9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794841865-537025
X-HE-Meta: U2FsdGVkX19A4mSyZLPktkSbBicZC4ZMtA/Zi0HgMC/yFBdoWrQGk9IRc5Un9r49n0bVMXj3QynZW6QC6t/b6Akb88hzoTS3BmfGPz9bVRAZNyxqa7Qw0G84ghzzSAA0I42IPwF63ConbhSE1/lHlz9CZ4H0haGVnqDO425eB+ieH+ZEFI0mdt3xqTS5PLU7L3sO7PXmCIIhNIX5y9j2iNy0HN3cUL5Ae/2UGXUuoXyAQrK4cSPv1gVxzmWb0p1bUq+kbYiw+brs8DvWJqZBtunXxn17S7lr/APia5256s9DVnaHJTK8lxOsO920lCQ2LM59LPZ/LLU91GapHTFr7okghClMWei/guT7GqxDm3WNZSuxmr/TzO/ScS3LUexkC3qDng/aBIqwIWP3bcafbwJTKN8FWLv/J6JvEyyRx9m/vLf1ZossuqwXXM4MPUt5VVX7iIIWymZQD6yQYpNJM8eeKN5tagxmDylwYjPi8tIN2Hn63Zv0cNQtbw4KeTM35OZfEKdBhVkrvsgetQKC3ExdVn3ZQ7H+gH44EtpaxREIGlCF5H1fx1CJc16Q1Df2WN5064umAQzEMVogx3vCMz4AfphU/izDAIsQJ7BpDImyrxcdi/BHU09UqxzHmDF2cKAooW5r39DnvKotTXuKZOWiZUQPv2NA9oe7QhWx2g2/rpLHQNyUKubeilsQZjsuMrsEVHFWlkgHP4ubn3uVxB8Z5d1A9xlovfUk+Jboiz0ngZU3MaWQGQy6A1Ql+nX90iyvLpfgyd6U1/DHcg4kPga4rN48KRZ6vlbz0NXzYK5oY8VUa4gObyGWfgsb3lsEJ08y53Vt01v96j/I5Rk5PvaYeNiy25a/DTIDU4ImCpjdI4N6gfJ4D4N1LUnvuKooTmJMWR/63rqWhoP0bqBueCJ5Xx/GwqYBAHZWxopQ9apEzYYrmn9VaD2YJ7MIkAnWHrObCP9ZJWzKtd/9SJq
 bUItfHUI
 FEtSSi8rI85z7dBMYdoLIXm3ByPLoSI23QfSysdU3lFEAzB5XI/FfIlIIUS72LETnwHlgUGUB9gPQSo20XVxk5OdtCUR7zy0u0xGCQlUvJZ/voqySgffmbc75MtGDwUIbl4o89QXPsyEgoun5j3kKAeWQFwMCRX90UzMPblh5J38P309gr8xS7CdH6/3Usp1YbyiQr16CY++Sk3E345uHm0rogE9euZgKGR+WGb+ZKH1x0xKvW5E+ucWZPPCbnsugl8haesqsF4xCDOnxWigM2VDCkKLBvn/5+ilW2XMo883ospY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

damon_pa_phys_addr() and damon_pa_core_addr() convert between DAMON core
addresses and physical addresses using addr_unit.  addr_unit lets 32-bit
kernels with a 64-bit phys_addr_t monitor physical memory above 4 GiB,
but no test covers the conversions.

Add a KUnit suite for both helpers, including a case for addresses above
4 GiB that is skipped when phys_addr_t is 32-bit.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261109-test-damon-paddr-addr-unit-kunit-v1-1-bd10bb87be98@gmail.com
- Shorten config prompt.
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/Kconfig             | 12 ++++++++
 mm/damon/paddr.c             |  2 ++
 mm/damon/tests/.kunitconfig  |  4 +++
 mm/damon/tests/paddr-kunit.h | 55 ++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+)
 create mode 100644 mm/damon/tests/paddr-kunit.h

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 34631a44cdecb..a33f21c563475 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -65,6 +65,18 @@ config DAMON_VADDR_KUNIT_TEST
 
 	  If unsure, say N.
 
+config DAMON_PADDR_KUNIT_TEST
+	bool "Tets for DAMON physical address operations" if !KUNIT_ALL_TESTS
+	depends on DAMON_PADDR && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the DAMON physical address operations Kunit test suite.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation.
+
+	  If unsure, say N.
+
 config DAMON_SYSFS
 	bool "DAMON sysfs interface"
 	depends on DAMON && SYSFS
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5b773012a8764..e89cb14ee17be 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -479,3 +479,5 @@ static int __init damon_pa_initcall(void)
 }
 
 subsys_initcall(damon_pa_initcall);
+
+#include "tests/paddr-kunit.h"
diff --git a/mm/damon/tests/.kunitconfig b/mm/damon/tests/.kunitconfig
index 144d27e6ecc5c..9279f0c82be7e 100644
--- a/mm/damon/tests/.kunitconfig
+++ b/mm/damon/tests/.kunitconfig
@@ -9,6 +9,10 @@ CONFIG_PAGE_IDLE_FLAG=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_VADDR_KUNIT_TEST=y
 
+# for DAMON paddr ops
+CONFIG_DAMON_PADDR=y
+CONFIG_DAMON_PADDR_KUNIT_TEST=y
+
 # for DAMON sysfs interface
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
diff --git a/mm/damon/tests/paddr-kunit.h b/mm/damon/tests/paddr-kunit.h
new file mode 100644
index 0000000000000..9839cc2330712
--- /dev/null
+++ b/mm/damon/tests/paddr-kunit.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Data Access Monitor Unit Tests
+ */
+
+#ifdef CONFIG_DAMON_PADDR_KUNIT_TEST
+
+#ifndef _DAMON_PADDR_TEST_H
+#define _DAMON_PADDR_TEST_H
+
+#include <kunit/test.h>
+
+static void damon_test_pa_phys_addr(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(0x1000, 1), 0x1000);
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(0x40000, 0x1000), 0x40000000);
+}
+
+static void damon_test_pa_core_addr(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0x1000000, 0x1000), 0x1000);
+	/* The conversion rounds down. */
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0x1fff, 0x1000), 1);
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0xfff, 0x1000), 0);
+}
+
+static void damon_test_pa_addr_over_4g(struct kunit *test)
+{
+	unsigned long addr = 0xffffffffUL;
+	unsigned long addr_unit = 0x1000;
+	u64 pa = 0xffffffff000ULL;
+
+	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		kunit_skip(test, "phys_addr_t is 32-bit");
+
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
+}
+
+static struct kunit_case damon_paddr_test_cases[] = {
+	KUNIT_CASE(damon_test_pa_phys_addr),
+	KUNIT_CASE(damon_test_pa_core_addr),
+	KUNIT_CASE(damon_test_pa_addr_over_4g),
+	{},
+};
+
+static struct kunit_suite damon_paddr_test_suite = {
+	.name = "damon-paddr",
+	.test_cases = damon_paddr_test_cases,
+};
+kunit_test_suite(damon_paddr_test_suite);
+
+#endif /* _DAMON_PADDR_TEST_H */
+
+#endif	/* CONFIG_DAMON_PADDR_KUNIT_TEST */
-- 
2.47.3

