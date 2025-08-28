Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C9BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7128E0015; Thu, 28 Aug 2025 03:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6D98E0001; Thu, 28 Aug 2025 03:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F3F8E0015; Thu, 28 Aug 2025 03:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF9D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E978CBC944
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:53 +0000 (UTC)
X-FDA: 83825354466.28.E97187F
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13B30180003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ru/Kjaja";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEG4bH5cgwUC7a1orTI7hmUJnz956GpzDiyDWs45yMQ=;
	b=aePyzXXzPknBQ0TQusUiEMBodB7+MrwcwK2KlWKZs1aNk61FNs9e8pGIyxTTVQut8uzQDT
	wH0Z3ra734nZrtez9jkzN/zWMyacDJj+SJHekbWm4Mmi2Ei2ntVFdHwAgiyOAqHkdEvAFJ
	fVk41PQZrzBiXXH+4DWkFlISqOCG0Hg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ru/Kjaja";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366492; a=rsa-sha256;
	cv=none;
	b=tork9+MZnBiFNKsp0IN9F42d7T5tIXvGzqumsUuBBKaH0gm0Hts+rgtLUeWPGBcwu9PKci
	GqfXeMAr3DBUNZEmZVD7WaB7kkDznmzUi47kg/DkngeU8MAdGl12rapdS8ekC6RWO00LKm
	/yHOgdUEBsWBXY/S7KnrxwxsK1Fhzic=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so546576b3a.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366491; x=1756971291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEG4bH5cgwUC7a1orTI7hmUJnz956GpzDiyDWs45yMQ=;
        b=Ru/Kjaja3XHwkJv/esJ6Z9pP1SUcbHeibnS64cJjWQbxTQqOXXT9Y7HXL9c7zJyjFn
         R2iawXwxbgdnolgjzURSNr1uYG2N8FjFpzpPcsCVgf7dYk+Tg53jyxhZLykcZKfPXmr+
         Vw1WSYYobGIKYmCpwTB4M5CrJdJrbGrYv+c9Y0L+9sApeUZQ7iZ6lIrNGF2EpcJTD3sT
         WYUab/RUWKi+mD6SJBsh00HtQgWkQXNxKitgD648nufHKNxUX2vglUSBcZEZy5vNccOA
         gMR8BTdoajSSbeV9QogUQbIuA9zvFbBjG+7ktZUGQkOGeLUPwVcx8WHjjeJAst/oy6NV
         ZEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366491; x=1756971291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEG4bH5cgwUC7a1orTI7hmUJnz956GpzDiyDWs45yMQ=;
        b=ebLIFUcUfq2eIL0wnTszpfWPggaKjqpbTKgIvXkhWxgur04+o9TqObbFXOvKZQ6MCS
         8oyGU0yZmnYnReImTxL3WNnNXR495tEjISfJBgZZexnRbqrsYIcK/IGvI5WzimGPWFBl
         ge+I/Xb05HC7ktd/ObW8AvB8wuAAfSTAgnBjd5Mz9AaftFUYQUE5y0Pz5tH3jR39UR2C
         7Ztl2IpSm/53PU+HE2n9t+s0JTOaXuzUsFS+aiZSPweh25ACJCwLizXnxeo8RAY8bO9/
         g/yAU6owFUiXU2Ss6U3jcaa0E5mTRyUcNYYYZ2FXtwtHg2VvxlLkhKQkDkpC4JycbUqO
         1ZvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFxRFuAAYkD4MnPLEzKpzgG4JuB3DbviTba2sKQBvybEjVzx6slXh5By3fwQOjW5sNfl5or7xFtw==@kvack.org
X-Gm-Message-State: AOJu0YynWUJLsLACl5+sZhIm2R/hv8jT1Ro6VCMqiQRL8hXOW1VGa15f
	CxacR5LMiM9o2oUJ4qAlDkK18gRpjP2WiVpaRE9PB8bfrEVJSafq6ohb
X-Gm-Gg: ASbGncuuop/Bkb5SYF40jkApw0v/mpTVbAGo3/8/ohDeUdrMOWFgFp02k9CwZ2CSWyf
	XO/FjUp3n0jajakWAZtUSwQQbWsaAXrzE7kFCHzBphtez2Pf+eNLqe/QTuARUXBgzPojDqO/gPd
	JZhbTYT0neh+SSiRH10gwg7I8hU3yHud/cd98Wj7ooINIizLngqajwGXAxW9Ie+AW33qyuiRShd
	8fhsoEsfLCL82/jHfw+Nm7bsuigZYczhEQ7BeSiF9TVpwkosRP7RrzelNp9P50kUcXjlsisHO8K
	52wCu04XwmqMOLGfNYixHjA5MF9hO16kBO6UIlH7/Svy1ptdkwI/KtpUtelIE46KrITpmQXjL2p
	liuh7FbAiLOzbpFhgiApfez9ma1PEWudxtVdou9C+BMwbH8mPUMlIyRvblMa4P5VUt0OKufk=
X-Google-Smtp-Source: AGHT+IFVYiXk5nYF/khbmrTEYSILlLTUA9ybwIqxEMQ2lhYq37r8kAhdhR5nVQny3eugczv3xuUyrQ==
X-Received: by 2002:a05:6a20:a10b:b0:243:50c7:24e5 with SMTP id adf61e73a8af0-2438fad31b4mr15697853637.7.1756366490914;
        Thu, 28 Aug 2025 00:34:50 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:50 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 12/17] mm/ksw: add test module
Date: Thu, 28 Aug 2025 15:32:45 +0800
Message-ID: <20250828073311.1116593-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13B30180003
X-Rspam-User: 
X-Stat-Signature: tc8tc1jm4x4w6sckzzqz387q8kn4yjdn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756366491-259896
X-HE-Meta: U2FsdGVkX186SlPcA04POBUwThjtMLpxlLEQSLDIh/mWNx8Z+MjoFl2ZKfsU0P409hpCEZGRVsYP2gLnGpc1ZdnCeoujukgPML5RTN1oqBFEQO7p8SlbLBicYEuHKvPAFw7mqom9OgX61gV2LYFNVijdCMKXsNaPvPLNShkhVOh8rFsEPbA4Dc386lSUQ7zJZkENPPBg1lQU5SBOVMp0yWnRt/yz9/eI6b/NSZbsR8q4Ha4oHHNmeDflmMKSK7GhCclRYgvJaIwDgcQ8tb5GK2IcTO5rT4UfTzOnSz/xidV4wJd3iw64dbTHVXZzcjPVQD5cx/zQ4GPXNzG86Af4DPZZe2JA28rec4qZgKlLDGtZVx5uuiRSfMquwOgnQnU8RIF7GTvTYOTdelvRv4pbMn367BEVG+53uLsQYAMdxmxYqCaKJhJYL3n2dippQYCvVIX/bAiee6bcs5/qvuL6XKL8s+B95UUefS6wrAGUTr/MQrc5Os/zxJ8wiXq3yPmMFD1MDhdXB9ud/AC0tD77bTyBSZ9Vmxt8ChsGFWpXAEWTwp++JMKeRM87ShYFdffZiytBmF1Uhu73quGQvtE13bRAhNWseY85L2XkML80/7RFyz7XXqsKcZVQja/gRx7gBy4oXUCEM26QWM6NieJXuUV/bUNZHJ+wgXYaKGLjSyyR66eYaGvUVbwfgDvAFMmMI4EK9xP0HFD1fi5+hpMANR5CsmjeDPxPWzCSppTsxreVmSl3xn5JotcFfhTCuv0oGVgeJvZCuxcWH9Ntt45T8biznQ4ndxinmqmY77D9+US83HL3pXjp3I11O0cmVwTI5CV0SyG33I4ia2Tbj6Urh9HqpYfCrUZ8F4vsUy0c+4LgbOreZlAQ5wis8K36CytZXE3CSZF51HgPvDIGL9EBQ6pENORQbpZ0icpCwNzp1H+VilkRTmISFlZR5+H3TKBME9/10yyw/bCN7OODML1
 bAw5pkl7
 5kOh42yDpWm30No56RV/jJtoC6Ryk/UoK/kI1rAN7hvPQmOn61wQyedItUZp5NMzqypGtiWUoBZuXQBkFrRFg/L7min8DtOD8WH0byrhsZxZor2/ZeFUCxQx2YHqEJ62KxOU5k932hxNHdoUKRYiDW48MMbckGFvGWho5RdzQrVvsKUpOk6anvqvAanKIjDY5kh1utrw6Gf7C7c2MaKEkctV00gl06cYNlWPE3FS0UNWAFSeqld1RqxE6ciHlcgf4hV25NOj1IA7dw+j4mjEEBEs7Xqvd588WLQdn8nJSwcYMg2LcKNZQn2MokHdm9ga1S4UCzqj/+1UqHnSdzrInk8xsIBKvZ9YRgwHZRZPhYeZpnVjMOT0bswqPFxNNNTllXqhVRKo8LGlV4wLhRRsCPb3h2MNDMectPJj7YZVbwXRNyYwHAj/9c+9NRvUsDAUYV8I+c/xPjBgvXKSpN4xyI+GIDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a separate test module to validate KStackWatch functionality in
controlled scenarios, such as stack canary writes and simulated corruption.

The module provides a proc interface (/proc/kstackwatch_test) that allows
triggering specific test cases via simple commands:

 - test0: directly corrupt the canary to verify watch/fire behavior

This helps development and validation of KStackWatch without affecting
normal kernel operation. Test module is built with optimizations disabled
to ensure predictable behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug                  |  10 +++
 mm/kstackwatch/Makefile           |   6 +-
 mm/kstackwatch/kstackwatch_test.c | 118 ++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100644 mm/kstackwatch/kstackwatch_test.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index c2cc8c7b595f..7fdf7b03d458 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -319,3 +319,13 @@ config KSTACK_WATCH
 	  the recursive depth of the monitored function.
 
 	  If unsure, say N.
+
+config KSTACK_WATCH_TEST
+	tristate "KStackWatch Test Module"
+	depends on KSTACK_WATCH
+	help
+	  This module provides controlled stack exhaustion and overflow scenarios
+	  to verify the functionality of KStackWatch. It is particularly useful
+	  for development and validation of the KStachWatch mechanism.
+
+	  If unsure, say N.
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
index d422f0e114dd..c04c0780da01 100644
--- a/mm/kstackwatch/Makefile
+++ b/mm/kstackwatch/Makefile
@@ -1,4 +1,8 @@
 obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
 kstackwatch-y := kernel.o stack.o watch.o
 
-CFLAGS_kernel.o := -Wno-error=unused-function
+obj-$(CONFIG_KSTACK_WATCH_TEST)	+= kstackwatch_test.o
+CFLAGS_kstackwatch_test.o := -fno-ipa-sra -fno-inline \
+                             -fno-optimize-sibling-calls \
+                             -fno-section-anchors \
+                             -fno-pic -fno-pie -O0 -Og
diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
new file mode 100644
index 000000000000..bba2ab8530ed
--- /dev/null
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/compiler.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/prandom.h>
+#include <linux/printk.h>
+#include <linux/proc_fs.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "kstackwatch.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Simple KStackWatch Test Module");
+
+static struct proc_dir_entry *test_proc;
+#define BUFFER_SIZE 4
+#define MAX_DEPTH 4
+
+/*
+ * Test Case 0: Write to the canary position directly (Canary Test)
+ * use a u64 buffer array to ensure the canary will be placed
+ * corrupt the stack canary using the debug function
+ */
+static void canary_test_write(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KSW: test: starting %s with u64 write\n", __func__);
+	ksw_watch_show();
+	ksw_watch_fire();
+
+	buffer[0] = 0;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+	pr_info("KSW: test: canary write test completed\n");
+}
+
+static ssize_t test_proc_write(struct file *file, const char __user *buffer,
+			       size_t count, loff_t *pos)
+{
+	char cmd[256];
+	int test_num;
+
+	if (count >= sizeof(cmd))
+		return -EINVAL;
+
+	if (copy_from_user(cmd, buffer, count))
+		return -EFAULT;
+
+	cmd[count] = '\0';
+	strim(cmd);
+
+	pr_info("KSW: test: received command: %s\n", cmd);
+
+	if (sscanf(cmd, "test%d", &test_num) == 1) {
+		switch (test_num) {
+		case 0:
+			pr_info("KSW: test: triggering canary write test\n");
+			canary_test_write();
+			break;
+
+		default:
+			pr_err("KSW: test: Unknown test number %d\n", test_num);
+			return -EINVAL;
+		}
+	} else {
+		pr_err("KSW: test: invalid command format. Use 'test1', 'test2', or 'test3'.\n");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static ssize_t test_proc_read(struct file *file, char __user *buffer,
+			      size_t count, loff_t *pos)
+{
+	static const char usage[] =
+		"KStackWatch Simplified Test Module\n"
+		"==================================\n"
+		"Usage:\n"
+		"  echo 'test0' > /proc/kstackwatch_test  - canary write test\n";
+
+	return simple_read_from_buffer(buffer, count, pos, usage,
+				       strlen(usage));
+}
+
+static const struct proc_ops test_proc_ops = {
+	.proc_read = test_proc_read,
+	.proc_write = test_proc_write,
+};
+
+static int __init kstackwatch_test_init(void)
+{
+	test_proc = proc_create("kstackwatch_test", 0644, NULL, &test_proc_ops);
+	if (!test_proc) {
+		pr_err("KSW: test: Failed to create proc entry\n");
+		return -ENOMEM;
+	}
+	pr_info("KSW: test: Module loaded, use 'cat /proc/kstackwatch_test' for usage\n");
+	return 0;
+}
+
+static void __exit kstackwatch_test_exit(void)
+{
+	if (test_proc)
+		remove_proc_entry("kstackwatch_test", NULL);
+	pr_info("KSW: test: Module unloaded\n");
+}
+
+module_init(kstackwatch_test_init);
+module_exit(kstackwatch_test_exit);
-- 
2.43.0


