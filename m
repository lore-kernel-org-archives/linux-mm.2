Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2581CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9B88E0019; Wed,  3 Sep 2025 20:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391718E0003; Wed,  3 Sep 2025 20:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280238E0019; Wed,  3 Sep 2025 20:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 167A58E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7B611DF2DE
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:48 +0000 (UTC)
X-FDA: 83849669736.21.2CBD433
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 01BF320007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpgcJGy3;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEG4bH5cgwUC7a1orTI7hmUJnz956GpzDiyDWs45yMQ=;
	b=7vYSAbMlXD6TzcoJVGAw8fgTHyOLm6OBDqM1gkhF7J4txJjZ+nx5pSGsw1OfconcHqw5+k
	feg6KQe3Wo2PpovZe6lAx/7HJUwlrFVDhDBxD9xVJZQJl/YAmwCS3RXXtSg6fjKYKgMzMo
	++csmjLSAYegxCQ7hGFBwLN7Gw5R3VA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpgcJGy3;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945427; a=rsa-sha256;
	cv=none;
	b=fjvANExtR7symmbedmC4fSd0HsCfrgt7eJvxtKJnKqmXr4/0BOUD4baN8yUU7UNwiDDFYN
	j+GE02beZLmdZDGaDVyOGCqQiE4wev0i6c9y0zj2XLifmz9SZWupkn187ozkzxwA12s5gh
	bvOPgBXDIrZ3KR0zUPSOqhRBPhc2dwo=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77269d19280so448211b3a.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945426; x=1757550226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEG4bH5cgwUC7a1orTI7hmUJnz956GpzDiyDWs45yMQ=;
        b=GpgcJGy31t9ygc2mBEM6hwCVwVa7D5urZb4Eta9tzNfWo7b4/G1bkE4GDHqFdZlCRa
         T1q8fXIANAjTnK/lsAWXFFWPr2GF2eBQDQvNefB5LtOX/UJRdq0j6cX8b516M7qj/FvC
         H5ctlB9wJOia4YvkmnBYazUpTSmm8za6pXU04owVQ9Z8twTTKjGwpFXmDGIT9pEJ0YaM
         kEC/Pn8MpBBtObF51fYdBRxrx7RS4iekvwkWhBEwFcWDpADTE9j37r0tev27Jd29dwby
         Vm8XRPkO3m+PrOEnx1hUmjSWXPjmUerX6bw2wiTP45XjzGdFgB1RmK8vOAM/1n4AcU0u
         Ct6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945426; x=1757550226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEG4bH5cgwUC7a1orTI7hmUJnz956GpzDiyDWs45yMQ=;
        b=pejTagvkvnstt6rDYCuMotaEYulxEI7aplWsKF0J35dV0wUqQUYCLgJ4e5jtjPNx8L
         YtgigSEJZBB7OwajLJqi+naJmvv6iz0W7BgpFTONqdT9MlbBcg5Tj/XSjlUQ3G6xFW2s
         HEMsbQbqdj3oSisPT2ZptV6cteVPdPTAsbSGTitRvpDRWeRtyrPGrvDZp5YMfra4we27
         KLojpW9fEnhqdPRO20EL5n9ww0lQoScw6FhjPTyoPAeZR3dmMVUQTYzda/IdFPtqeueb
         gIwJYKYAReUycAvhkvpcWqVC627P+O2ugKy61cCz4n00ILvJuHaRrWEUuioHQH7I2290
         bKWA==
X-Forwarded-Encrypted: i=1; AJvYcCXgTnLILykYHfoNreNXLu4hm0y0imH6LTKLyFHB6Ro61FuxO8YllcU9QjJmaBFkYw4DHfaYSQnP5w==@kvack.org
X-Gm-Message-State: AOJu0YxgsoOv1rMqv5ZgwWms4KvSxqhuJUIXCdLGHnSk976aVGRsPkRr
	cV+cxzumW6j5fiqGsSuUnjHagk2N2Y27yg+ldO4CX3V58fFk4D8DC8Yq
X-Gm-Gg: ASbGnctAd9teya0pXVlqEF/DJISzAz6loMNr2gQVYUWkWR/CbF4dUndje+jzAtbedoY
	7DxAhaSD/4DU/I577cm8cz2JRlW8q+le9co0ZqDYLbxImSyS6blHAyBORmG6KVip86iki9kUXTM
	nzZQUMjbmsOQ9Le5b1QDOyoojc58k4QtKUnj5H86nN/n+G6cFiksHI7XuSp4OvYEFtcQLeKJTFQ
	hdKs+oHrOu9Uy7m3MlDy2P8ScCRY14y1X1o40Jhc45nzWryOh5HiUtE1prcriA4Qedz8/mTM064
	Li7SXylFw9ip5tmOAjj/dgpxOEC5UnEI/B1HtyGqS9nn1YlI1TXTVZWSxvVGIri9sepGID+gKuE
	VlkVO1SamrTC8clYbipUSXbgTIJM4MfZSDt0s2hAh+OCO63KYY+HfmC24FqCeWxXlYh4vBG0Y0w
	==
X-Google-Smtp-Source: AGHT+IEr/C81GB/BuP4Yk9gK7yApaaYJOMu3ISoyiOcC/P42G0UqOztnrGwzfHBNa2zOn5PIjEynzg==
X-Received: by 2002:a05:6a20:9187:b0:24a:b2eb:6676 with SMTP id adf61e73a8af0-24ab2eb699emr1717825637.17.1756945425818;
        Wed, 03 Sep 2025 17:23:45 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:45 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 13/18] mm/ksw: add test module
Date: Thu,  4 Sep 2025 08:21:10 +0800
Message-ID: <20250904002126.1514566-14-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01BF320007
X-Stat-Signature: kcm6b1o95bp1748tncwz1egg9unx6aig
X-Rspam-User: 
X-HE-Tag: 1756945426-194710
X-HE-Meta: U2FsdGVkX1/hBlx2Mswz7edBE+j6t/XzsUWtSJy3iIcT6Ik8mny0MQR/4oBZurcqp1LPFbrytXjs+v4vWjru948eDj3tttWjamp8/CX0jK/EQAPP/7Dd5QJK9EQH0npA90F88EDdsSC7WfqffwKQtWTha2kO8qRUSR7l84fVcIWyop78imb9pEGe/w3klrON9BMWhyL/CU2PW+NDcwMQziyUCJXDImmVF5tI8RFq7FvTMgbW88RYO9V33pJwj1qbJQeSKKF+ru/oqQ2rtPdGGTGrfc6t7d00jbiYsuEAmrcPQmdJdtygbJ1YURzJeGNYqAB41LntbzIoN5g4oYQfB3Oq4g80Dn1liXoTARcq0yg59DMWuyePdZxB2ShQmnJUqKb0+dZ/cPQADRq3NYv4wUVlDhAbKwVfQgDruEgU6+peyvrAsaVGNwjL2VOujSxitoZjfBzOXZL8okhn71TZclUIQrw1rT80s2wh1bR9ZnuGwi7fK8ntRD+yd2bEouCmeYpYMXB5ZMF6O0H4HEeIFb3FtsxG4sTJIWRjkf2mtexYJwXHNMSwBv6/Ug3q8kfAkLw4ourmNa3Tm4f9v59kDSVcXMjiamAI5OUsSxaE+/FHTxA2VGE44XdR/LrXIjfVRvKK9vIycSOwPnFdcyi3XDcAIbK5oT+dsCH1l4+6Fk6BCHLyBoY/w/bkAHAa0b0gkU7n9gS7cHHMbGwdXP1dyrUtC9+wmlD8nSEg0esDNT7PVkdOVccabCX+4FCyolXXDFP6SF3OmmQ0luYjDj3dTQX1AEkmlARlwyRKoJYBm0paX449/y5mYfgh0KRuPpFTmGeNgmDfsvanxmaX8pgEvS0A5gdPiDlHZtht8hXQHdu+/6aIsrY618wi8rLqThcvloA8svYZwJ6lXhSPYxaR/zrEF433DclTLg8YgBtx4eCr1GVhH7e9WUX/QnhEVWeXkNUPmBpbpfpTJ9vP22G
 UWzPlrga
 32MtZtQMOy0D3DUWlGwHWm16eCUHDrVigYWnkGcs80EEIPMAc6YQMKyGZ1Vcf1ofn6isWhWGxhn0AyFwGDXeN4kK0Fc0putFhBzlQLApvPvamrEP2lAP19UNd5tKST9oO40VCvGb/2CgggTx7CufODxhTvoNom/zMCe0qCEYHm1Bx9BefoJZVYRvluyZNKfi9xM53EWpyyhIf0q6WYvh/qUj/iyz5kj9aVTMxwbZXBVCxKM++jhHMsY2irOn0dOZbN4vsIwofFlFFq0zzTj0N9xpR1C/HN7J2l92ibhv2kIbi2slcKKgMmWsR0SU02XL4lTm1lV7FQ3Foy/Otp1ijeDKPyVzs+8t47Na/tl4hs371nkNcArTcPJ5uNKHmmmPTbRXbNoil7nBrHUN9rXwkE10O1vVfmXB/pjXAPMbohcP6cxWZEC26SWGR3NLWtYyfX3bapUdyH+xRhdmhAjWC1Yxk6Ghgd5+SoLCL
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


