Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C4DFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD306B009F; Mon,  4 May 2026 05:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7DA6B00A0; Mon,  4 May 2026 05:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A393C6B00A2; Mon,  4 May 2026 05:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 86EC16B009F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A7941202F8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:43 +0000 (UTC)
X-FDA: 84729225126.23.08A4860
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B956A0002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=BqTtpk+C;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ZanvYVfs;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrS0k2Drv80OdaJ1YmUo8BOgCdISFvzkHUaFnv4iGkM=;
	b=fihoX7bd6Kg9d9YVETzkl5TuzHcKNB+sl208/sDLlXYdKIRc2JK+NmkKVcJzBAZ9i9AiH7
	jHiktZyJXxo0Vn1v79UgF8xxIRSRfG6kob64wkl4vmpmWA78KJrGMjCkEsvLagw0ssG+q5
	6/LLgLMiP5YM3+DJlZ102NqYMD8vZ7s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=BqTtpk+C;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=ZanvYVfs;
	spf=pass (imf25.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887221; a=rsa-sha256;
	cv=none;
	b=BNU6MgUVCwp73vCLhve3cpc1kqUy85npU0GgwlmPmkn2PtOILsvW4X/CmhzFGDhUf98kpb
	jKQhtqNWvnZsqeQ0j3VGvtVgRFdgkXukn7kmzgfpskMvB1rmnrM16YfXiaE0Ct22Rliofq
	6ymNOnX2V9yLb5W2GwJXRvh3M/6Dmx8=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrS0k2Drv80OdaJ1YmUo8BOgCdISFvzkHUaFnv4iGkM=;
	b=BqTtpk+CXBSv6WfgRGnKdP1smf/6qR/nWC5fL4wYSSvJxXy7s4NFkunXA3qfZLfKUsavGv
	+wWq9EV1hah3Ei3nPcAx79AIcSZ3TyR/mBlC1+p00FxtQ5KObA4ZCuFlDx85ejGxU7UuiJ
	hdLrvogkSvos2xghKe2i5Zg0/+3dTwMhgb/xDUIQfGz/hiBploTjsyScRo9K3Lp063ksFZ
	KzgVsVr3Wz1txl6BZ4AYTQWPMD8nC9S9mrHhWkoN7NIsQukE0LAQCDjOiPaHKUWEQNa4HQ
	+4ImbazmNQDpitSLHA2xSNSI6H6qGMn2BzEBX84vIbkUnsWP6iIGtvp6ILTFkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PrS0k2Drv80OdaJ1YmUo8BOgCdISFvzkHUaFnv4iGkM=;
	b=ZanvYVfsjTNqFNMSVnatHHJiQ1Hha7pnJ5tAY/2b8uIVYGIg3BEt/sK+UwR+ADsManbVrj
	jvpfybI/ZMvglgCw==
Date: Mon, 04 May 2026 11:33:27 +0200
Subject: [PATCH v6 11/11] kunit: uapi: Validate usability of /proc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-11-712d3d526d97@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=4066;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=TauxOYpi03qFPcnNm3AqoC889sKpf9SoQTyDHbRy9hg=;
 b=1hWzT6507OnOzELkr3kP6C8GS+SfvKLQdLpAiBvyOpYn0JryvJmarJBk+xXRskvu55bxKdheG
 G3cv2zqewfuCaw+z7LMh9TYx3Tv2oeaAUW9Qr91SEgKS00S4V/4Fr0G
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: ehnp3m13syfem78xa6o7pkmnz5jjjuer
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B956A0002
X-Rspam-User: 
X-HE-Tag: 1777887221-791663
X-HE-Meta: U2FsdGVkX1+XGw8OnE3wI+29xeh3PZCV025s0yRUTfbn/s4SZPbe7a8qT5ZM1eF0bzgNCuGlQKsqTCoRRptUzDngoIa5LwsHT2U9BHz3wJmrRi5mwSKyWQu1OXrGwSUmWoTLuXjHVyg9VApCxw8WiOHurilup2EMzMsckfWe9+QEX7b7eJ9CNbZvUBtrfIlLNcvSITdG0Bh7zLeIFNFzlFZ8/Ytc4ruaCioJLoAqeRR8Lrgkz8YJkW9hxL6HPUoJ7hOAx85mcjLwS2hUmhh8v4YS3CnmeXXJOuWvdPj1hZg8BvhkYuIDtxUnJvgRvnm6qG11P8WReZg/nxk+j2p5aN5HrOY983DLMY9fechScqnj+UyJgHFM8QQfUPsIMy8vm9g8M8XPFTNN4eXrb/j4esDbPJi2YKf1wIjYxGioFyq8XKw49aT8ZLeeJkiStqYptxAdH33n8wfZdpkcLESSklwVZ5fqq3tlVSqg9c93YCW3/BuZcr4NSqYZCXZsoTbG5b3+QUf1PtngjQNEIT1MGyikcC5C/xE+CwB+qYB3tqt579/Y0P95itBYbUGBi7tIyFxVoxNjChVqTsyWcURJKdr9pK+8ym+iubCbik9U8MXcbEcvsUUWMwyjQaX6W9C9mAbkh0q8GolWg9g+uOr1Ep0v2hKD3JUWjEhYxNE33V926pWYl7ihYVotN0LK+8QCtjOGrguqBIz9UHY69jnp9v6C3fK9e4pv4R0zBbXH+sAL2V60HJnfT0as2Vu1KGwjpkg7tjTdFfVE73OCRcVaTF1pMUoPhk28mZLK8nLY73hznG2cFu2kroYCfP6uSiQcZOweae/YhxmBO8nwDcO5Js3qM1NQJG/f8nf3IvxjDwp9VIK/pBJNrxfLrwzFwXksm0Y/GUZ1IVb71zFHXEpJhh3aLYTK8/+Q3mg5hsHc+wxf5rhglysrWibP7kCCE8E21wsFfH8xRclzakcGCa3
 9FWKb0E0
 PU+Q0WgVsViPO9PqWl3NPpIVKOEByH+mNtId5SJenfCDWUDrU010uCdZYi8fh3u0bfYgEVAOjRpljPnrBNdEDHkiDgrOBX0DPlMKgcSY8nOzxeFoIPYwII0F+gB5lWMp2vTTp0YTf8kpTEJMmtajzPNJQE2D23MtAg/o/06EpcT61BxVxlv5OFm1ETfOH257wC1bFUxXvPBxKwp2hBh2ZDr+H8wfzyw1N0bvel8DE4h9LS0Nipe1VQqrI09610dymRrOwE5Y/R1dqVhJhzbat8pDb2FvBNRlEz397LMUuYKN8nOs9IrpCP+FYIlU6Ow5dwmVsIy1xvjON+GKgGpm5iscX2elEsyoQtYeH2ulaVbgs5dZezocklROQkcBeZVURqOgfN+FGrD5INBMfr7EskXo4OuYH9KJPVn5Nzd8lPGo0hHYTNb6Sta5wog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Show that the selftests are executed from a fairly "normal"
userspace context.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 MAINTAINERS                 |  1 +
 lib/kunit/Makefile          |  9 ++++++++
 lib/kunit/kunit-test-uapi.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 lib/kunit/kunit-test.c      | 24 ++++++++++++++++++++-
 4 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e8cf9fa7aa9..693aafe4d3f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14400,6 +14400,7 @@ M:	Thomas Weißschuh <thomas.weissschuh@linutronix.de>
 S:	Maintained
 F:	include/kunit/uapi.h
 F:	lib/kunit/kunit-example-uapi.c
+F:	lib/kunit/kunit-test-uapi.c
 F:	lib/kunit/kunit-uapi.c
 F:	lib/kunit/uapi-preinit.c
 
diff --git a/lib/kunit/Makefile b/lib/kunit/Makefile
index 05991d69aa70..1a4af6b66524 100644
--- a/lib/kunit/Makefile
+++ b/lib/kunit/Makefile
@@ -29,6 +29,15 @@ endif
 obj-$(if $(CONFIG_KUNIT),y) +=		hooks.o
 
 obj-$(CONFIG_KUNIT_TEST) +=		kunit-test.o
+
+userprogs +=				kunit-test-uapi
+kunit-test-uapi-userccflags :=		-static $(NOLIBC_USERCFLAGS)
+
+ifdef CONFIG_KUNIT_UAPI
+CFLAGS_kunit-test.o :=			-Wa,-I$(obj)
+$(obj)/kunit-test.o: $(obj)/kunit-test-uapi
+endif
+
 obj-$(CONFIG_KUNIT_TEST) +=		platform-test.o
 
 # string-stream-test compiles built-in only.
diff --git a/lib/kunit/kunit-test-uapi.c b/lib/kunit/kunit-test-uapi.c
new file mode 100644
index 000000000000..2e75e57865e3
--- /dev/null
+++ b/lib/kunit/kunit-test-uapi.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit Userspace selftest.
+ *
+ * Copyright (C) 2026, Linutronix GmbH.
+ * Author: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
+ *
+ * This is *userspace* code.
+ */
+
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "../../tools/testing/selftests/kselftest.h"
+
+static void test_procfs(void)
+{
+	char buf[256];
+	ssize_t r;
+	int fd;
+
+	fd = open("/proc/self/comm", O_RDONLY);
+	if (fd == -1) {
+		ksft_test_result_fail("procfs: open() failed: %s\n", strerror(errno));
+		return;
+	}
+
+	r = read(fd, buf, sizeof(buf));
+	close(fd);
+
+	if (r == -1) {
+		ksft_test_result_fail("procfs: read() failed: %s\n", strerror(errno));
+		return;
+	}
+
+	if (r != 16 || strncmp("kunit-test-uapi\n", buf, 16) != 0) {
+		ksft_test_result_fail("procfs: incorrect comm\n");
+		return;
+	}
+
+	ksft_test_result_pass("procfs\n");
+}
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(1);
+	test_procfs();
+	ksft_finished();
+}
diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
index 126e30879dad..b62e24fb9c55 100644
--- a/lib/kunit/kunit-test.c
+++ b/lib/kunit/kunit-test.c
@@ -9,6 +9,7 @@
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
 #include <kunit/static_stub.h>
+#include <kunit/uapi.h>
 
 #include <linux/device.h>
 #include <kunit/device.h>
@@ -914,10 +915,31 @@ static struct kunit_suite kunit_stub_test_suite = {
 	.test_cases = kunit_stub_test_cases,
 };
 
+static void kunit_uapi_test(struct kunit *test)
+{
+	KUNIT_UAPI_EMBED_BLOB(kunit_test_uapi, "kunit-test-uapi");
+
+	if (IS_ENABLED(CONFIG_KUNIT_UAPI))
+		kunit_uapi_run_kselftest(test, &kunit_test_uapi);
+	else
+		kunit_skip(test, "CONFIG_KUNIT_UAPI is not enabled");
+}
+
+static struct kunit_case kunit_uapi_test_cases[] = {
+	KUNIT_CASE(kunit_uapi_test),
+	{}
+};
+
+static struct kunit_suite kunit_uapi_test_suite = {
+	.name = "kunit_uapi",
+	.test_cases = kunit_uapi_test_cases,
+};
+
 kunit_test_suites(&kunit_try_catch_test_suite, &kunit_resource_test_suite,
 		  &kunit_log_test_suite, &kunit_status_test_suite,
 		  &kunit_current_test_suite, &kunit_device_test_suite,
-		  &kunit_fault_test_suite, &kunit_stub_test_suite);
+		  &kunit_fault_test_suite, &kunit_stub_test_suite,
+		  &kunit_uapi_test_suite);
 
 MODULE_DESCRIPTION("KUnit test for core test infrastructure");
 MODULE_LICENSE("GPL v2");

-- 
2.53.0


