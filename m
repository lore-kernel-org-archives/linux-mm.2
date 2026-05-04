Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F32FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE9C6B009D; Mon,  4 May 2026 05:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAE36B00A0; Mon,  4 May 2026 05:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23E76B009E; Mon,  4 May 2026 05:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94AA76B009D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 568D81A0385
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:42 +0000 (UTC)
X-FDA: 84729225084.11.9B502B8
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74613100006
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NC+00Yvn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YjAiuNtu;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft5tjVlJemnVxdKrQOWR07GWUrenfDbo6YKiLlRQjYg=;
	b=4EFW3t8fdEHZYxAkr3CdsPTSWkcWhZdvasgXxIPOLqWC7sG54LZrDiVGEJOV9o0YRo//Vf
	iGM/0pfeJs9m125sxU4JVxQNYG+llWKx14NNUAj9jNMjcJNJAhihDdSqTJ8Z5xFN50HYIU
	wBJtrwacS/rv/TVEUsIUHm+mIjoFpBk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=NC+00Yvn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=YjAiuNtu;
	spf=pass (imf05.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887220; a=rsa-sha256;
	cv=none;
	b=GpTqHFkOXM00vyyxoe1Lw4+3og03+9/1zm80jfTGi6mjCKVSK4oipXw6itFxqjakqE/0LS
	vhXeF5lG9Pyxv9+PeP2u1/7JA+3KZhWHl3ewALl1byyOV1UQiQBBumLkCY4DWxf+0dsIBD
	tpNtZsrLG3HxqOCNgUp4uRGaNdWxdp0=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ft5tjVlJemnVxdKrQOWR07GWUrenfDbo6YKiLlRQjYg=;
	b=NC+00YvnEebssrgHehzlz8bX7d+X1xp33wCP3F4/hOYN8p9eHYVnXdW9p4aP28p0zVsJt9
	KeKHZP/hTwB7uHL5RRZhma/aQBpVrdIOJh1JTyz/NAxYkUX/wdjJdZYhI8xbOZJHmUdQa6
	NOimy2qPsefv3aMws9u7uUwsUXTWN0MagCH2NggrHygMmRa+2AdYfvPKVvUA88IDNb1aQy
	Z4UF9aa9F9JaaLJtPRjudkod2k2pqxoZu9KITzPUWycNwzWDJTGBV70ah0fZbcD1owZru8
	jzHvynCd/7HagURExUsddqcXdodk2pS0roZJu0rMOXpXX/Qce4KiKQ4KwZvlQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ft5tjVlJemnVxdKrQOWR07GWUrenfDbo6YKiLlRQjYg=;
	b=YjAiuNtuewrsNsYXNQ5rzmlr51bXN+FcRHyyKsBkqi8MmLFxxEc/o7iKpcKU16CH1ILplT
	wmFhEZ+1YxCEjKCA==
Date: Mon, 04 May 2026 11:33:25 +0200
Subject: [PATCH v6 09/11] kunit: uapi: Add example for UAPI tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-9-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=3560;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=X2NN2sojneity7IMySlccOZ5k53NgDydZFJmaouxqdA=;
 b=d+F6BfdlzPGVKpRtvndevjxQUwuA2kdiKjOKE+xclSjrFppN4PZlwNeh8L5VMEutjdqDzgLmY
 LaFBlIeV+GPAc2hVsx4yFUiV9oZx8OMoKI//hL7q4tmqR6l1KjH9PQg
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74613100006
X-Stat-Signature: imr1swud8tst6pohsxz9gjqynhoyn88h
X-HE-Tag: 1777887220-147275
X-HE-Meta: U2FsdGVkX1+p3EMhe0QyBlU/12WQLL78vLZg9WdouYvcCH9bMtfBYvqvfqfrcFqddauJhU34KYc03c4ppoIcMt3go0U5YBEoBDSGeoUvnR0fLv9nNQECnfoFOEWGsG/o8dXUR6Xgx1kntyvqOwmg//Be/dh3z8YMSyyeJf2G8wopikl3k+wn6KoIiR9SH2B1l7QcTdLAfJkARbFCOUPcCZrBx6ejJ/hZlKXwbr/683g5u3N2cWwolWNKI6kBCfkQZYpH+qimBowvJR4eMQcMmuRDY6lUmdbxarHysHmYtJEDVYBmLSzQspCMyfqLM75tlWJd3QuL2R+vggfcsp9YKEk61NbuGJEWUuw95eJhyz1vj1yEWu3t589z6LjCz+7pGkVPAVuA5kO6PTrvZUtN7FrGcx5zD1X1RIyZGA1oTwjQ4Lijv6X9L6fDTpOPXVwa+lUPsbj82PMjIdv+hqhr8NCwhLZgwvLgoBT0PiAfwbLC1Lh1234rL4uXGm3dpHHAnb3aRCU0mgXAAKmIm0pkRuPDm0TG5rRa3IXV/Y7GJ1tBJLR4JCkioBIQ9Xq3tEfbP/sXB/doG5artZijuW7AXmgmW4eOzCitg/KJGr4jNILERwVzxEkfNDC7xI7Y5S6BCkpdjqpfTnYOvyrXlXrsDBPJLCtot0oYVTPhNMmLc3Rsk0CXa5yT6pe2L+WIp3YIADz3Tj6IVGsMexLLRSmCPybzhQPbrIqo1vmTwcDSwjpbn/mckZYNwn12CzLhNnI8fYbaOfZeUsM/mC1E3g0USj34OwL7s2+XaDmeVJwS6lHHBkOEyGl/wS2eKIGDbyNOzjKlOW0yFiTV2ZCB648Z+Pt/fzBhK9jZZUO/ISMLcvsvABHxIp9zDJCRLy/raGgH33aFY8Zfw3FD/X4lqBe/HOz4AD2fxwDxWb3USXQ81JqyZVHnY6IrJVrQVXKUZaqwoxNoQB97CqFlX5HiWmf
 kQeKcRVW
 W6Galrb+YxvFyZLXrpCXr+qxWfLjxlnf7IJL1Cd88ZVaNpRrQbagRsaOKNKBC1AVAUzB2whdrwLSVFj1JZeeL7EsRW0VOiXz4F/UOmS0COoltcGNcsDTty5KAqVvzNYmK+13pBJEn8BfNBHPbV2WkJvmjl6S+r9qR5yl1EeVOHl/XGZeIYZqYrG2BfOcZBfbmQ7xg8aQv4Kugk5yxdxJQNXGiC6TXVVosqdepn0W1A0npLQX5ohfICcYeDKEgEFS1SzCyGAo1qkYMeSqKwhyM9pzvKDTknj/bNZNK6P6/O5JaJ0uBLi9E5/wjJ4M9zNQtYAjYBYI8CbvywYzoYqaaaB3Rt1+FCrBS189eBq4IQjdj6ZyMxKd3y7ahBDcimvadFAWEBh3dbpbCrGLuDUfBF0LfSw1VwH+p5+D9msoEjROHv9CceL2ao/1LDtKtDl4IdVXY4mdE+fHka3ze4SPJS3g7XEjZifbK7qEBgQQzO2/UB1FYfb846bNUEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the example to show how to run a userspace executable.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
---
 MAINTAINERS                    |  1 +
 lib/kunit/Makefile             | 10 ++++++++++
 lib/kunit/kunit-example-test.c | 15 +++++++++++++++
 lib/kunit/kunit-example-uapi.c | 22 ++++++++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e29ca56f7334..b7358d89df70 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14399,6 +14399,7 @@ KUNIT UAPI TESTING FRAMEWORK (in addition to KERNEL UNIT TESTING FRAMEWORK)
 M:	Thomas Weißschuh <thomas.weissschuh@linutronix.de>
 S:	Maintained
 F:	include/kunit/uapi.h
+F:	lib/kunit/kunit-example-uapi.c
 F:	lib/kunit/kunit-uapi.c
 
 KVM PARAVIRT (KVM/paravirt)
diff --git a/lib/kunit/Makefile b/lib/kunit/Makefile
index 6059621a2d32..2434470e9985 100644
--- a/lib/kunit/Makefile
+++ b/lib/kunit/Makefile
@@ -1,3 +1,5 @@
+include $(srctree)/init/Makefile.nolibc
+
 obj-$(CONFIG_KUNIT) +=			kunit.o
 
 kunit-objs +=				test.o \
@@ -31,3 +33,11 @@ obj-$(CONFIG_KUNIT_TEST) +=		assert_test.o
 endif
 
 obj-$(CONFIG_KUNIT_EXAMPLE_TEST) +=	kunit-example-test.o
+
+userprogs +=				kunit-example-uapi
+kunit-example-uapi-userccflags :=	-static $(NOLIBC_USERCFLAGS)
+
+ifdef CONFIG_KUNIT_UAPI
+CFLAGS_kunit-example-test.o :=		-Wa,-I$(obj)
+$(obj)/kunit-example-test.o: $(obj)/kunit-example-uapi
+endif
diff --git a/lib/kunit/kunit-example-test.c b/lib/kunit/kunit-example-test.c
index 0bae7b7ca0b0..febabc995405 100644
--- a/lib/kunit/kunit-example-test.c
+++ b/lib/kunit/kunit-example-test.c
@@ -8,6 +8,7 @@
 
 #include <kunit/test.h>
 #include <kunit/static_stub.h>
+#include <kunit/uapi.h>
 
 /*
  * This is the most fundamental element of KUnit, the test case. A test case
@@ -489,6 +490,19 @@ static void example_params_test_with_init_dynamic_arr(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, param_val - param_val, 0);
 }
 
+/*
+ * This test shows the usage of UAPI tests.
+ */
+static void example_uapi_test(struct kunit *test)
+{
+	KUNIT_UAPI_EMBED_BLOB(kunit_example_uapi, "kunit-example-uapi");
+
+	if (IS_ENABLED(CONFIG_KUNIT_UAPI))
+		kunit_uapi_run_kselftest(test, &kunit_example_uapi);
+	else
+		kunit_skip(test, "CONFIG_KUNIT_UAPI is not enabled");
+}
+
 /*
  * Here we make a list of all the test cases we want to add to the test suite
  * below.
@@ -514,6 +528,7 @@ static struct kunit_case example_test_cases[] = {
 				   kunit_array_gen_params, example_param_init_dynamic_arr,
 				   example_param_exit_dynamic_arr),
 	KUNIT_CASE_SLOW(example_slow_test),
+	KUNIT_CASE(example_uapi_test),
 	{}
 };
 
diff --git a/lib/kunit/kunit-example-uapi.c b/lib/kunit/kunit-example-uapi.c
new file mode 100644
index 000000000000..5875b0d680d4
--- /dev/null
+++ b/lib/kunit/kunit-example-uapi.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit Userspace example test.
+ *
+ * Copyright (C) 2026, Linutronix GmbH.
+ * Author: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
+ *
+ * This is *userspace* code.
+ */
+
+#include "../../tools/testing/selftests/kselftest.h"
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(4);
+	ksft_test_result_pass("userspace test 1\n");
+	ksft_test_result_pass("userspace test 2\n");
+	ksft_test_result_skip("userspace test 3: some reason\n");
+	ksft_test_result_pass("userspace test 4\n");
+	ksft_finished();
+}

-- 
2.53.0


