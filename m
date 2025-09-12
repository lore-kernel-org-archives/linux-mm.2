Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3FDCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CCE6B0024; Fri, 12 Sep 2025 06:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324AE6B0027; Fri, 12 Sep 2025 06:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC7C8E0005; Fri, 12 Sep 2025 06:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C83F6B0024
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4EA8BB35E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:15 +0000 (UTC)
X-FDA: 83880185550.26.47CCD08
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1E21240008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XGEPxkHf;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hza3KqRNKGSLYWfBSKXFsxDeH0DXXBXA3429C+Yqz2A=;
	b=BylTGKAr8zG4D/v+J6qpono8/fg2PhvgZINQF8adTZ2QIQN1Ivp97R+bMThehNv2z4ayRW
	3LtZViNT51u+oWP1wDmULz8TmYthHTTpCduZTxGp+7PvdOdeUDCppTZ/mabBtkg61PMlZ4
	W+TgdiPZcV8XivJckQrS/ivW7ul9YXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671994; a=rsa-sha256;
	cv=none;
	b=K0Bn8LdQRSV8lgMZ7v7iFAI6Idx37RH0aGH6RYpWtQgMSn5iU9hRPn1WcdCno6jC2S/mXc
	KGn+NXKylFFRpk8YTKbCejRnGcbBhI9t2USIZkZu7bHAU6bHfgNDtL6VNk3MqzsdIuKDom
	hqofgrN3mPxFHqiKClyxz1gMYf0rvAg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XGEPxkHf;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24cb39fbd90so15150335ad.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671993; x=1758276793; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hza3KqRNKGSLYWfBSKXFsxDeH0DXXBXA3429C+Yqz2A=;
        b=XGEPxkHfPvXtGwFSaj91YGvg4zvLPiojxNNzT/3pvDWzhSeHJLkIPlDECMJFGNm6tF
         A4OdXOl0SPI4c050bTkDM0rOGOOG/TpO4nS3dLL61hvHrSSUisKzTg0n8he1RZhsssUs
         IaSFkm28BpxxVTjcRNkjK5tnn6+NwCCOltA0JOeFV7NL0qRwz7sxb37g1srYeqPI3/AS
         Ygqk6faf+q/MSsuDceNnBHdYqHoJBXtF++072tIjrk9FTlGl7UUUV3loJPhdVVROia/G
         F7rervm90rdORcr5xSsLpjA/d/uJmNqKQZYR46YtyRCgsNs+NOvKkI43g9gSkxLbWE7Z
         MiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671993; x=1758276793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hza3KqRNKGSLYWfBSKXFsxDeH0DXXBXA3429C+Yqz2A=;
        b=TzqLhJuDram8WFVcA1OJAZKpQ2Vw9rEAEkd85fRKqY+v0iGRiCrloyFm1hx4wpRKWy
         Y5kghfNX07Na9KRlErIqn+RZSrTY4p7yt9P/E7XHoicEFU9tCo9hZ4di2NzScwibXEIq
         7SzI4kiDFZswbo3gGNdjc/vNYmRocgg2cWszS8bPyvSkdW56EhTYOiPLP37xvQWxVZC2
         0KCAVgHQsIeI5TprwwjVKiOkRB11AErMK+PGBK3Aq1LjLnW8SjnAxCzM1Y8CuaiBgQLC
         2ZiI5STm4M/A0lv8SBL+JH0uRFMlRJXRV2lD4iQKrgTHJKEXvM39EUGoqIc8Tztlh7Jh
         yviA==
X-Forwarded-Encrypted: i=1; AJvYcCUVkQUV2aXdlbra9VUgvfOzJj6GIBcu2UslphqCCZENA9hRi5Gq4K3TgCLw9NJoR7+qcib+JDF0pg==@kvack.org
X-Gm-Message-State: AOJu0YxWpYCexJAuxBV14gdvg6X80Dyn+xCN3igGvfETkZUauCVSw0eD
	/dXbjRT1IFTaEWsxvPjHyzvl9EuEQlIqSFWdzwKoee4CYtLVrpuj4DhK
X-Gm-Gg: ASbGnctAniLceXMbFkdoxszpMuGJ76YiShX3s2qIyPmM7Irze9KR/Rsogp1gjx7po7l
	KohWowfisDzQg96UpM6xC628Muvf9IdJshxfjkSA59Fz26JTHd17yjD65AxRTWN1ca1po0IfSIf
	Re06WgurfkrnGYeCrpWpeKJ2kCWuwwLEYJL19D5NZoODSUmS2eBPnd5BzfGGfOKjEogR60na/wi
	IjJofthGH9AUMJxW8Osc3JozC3Q7Bykb40w4rqleCTxFRM//hdKlpiZKoP/MA9I+9IQT/bpukM1
	8hpK370Z+ag/f1nd9QaVbC7R5GrcnpYg47yiEalxF7uu2xE6redWcz1xTEw+irCk3jrtsCiuaxm
	C/yOzy61Or1RQoye4aO1cOH6i9w7Qvexh6Lk=
X-Google-Smtp-Source: AGHT+IG7f8OaGED6NtpM7NPcRiOM1jQkAe90+ggoUOI4OH0YlfR6qug9mcoSa6nxv/Hl/BMuWG/tLg==
X-Received: by 2002:a17:902:c407:b0:24c:784c:4a90 with SMTP id d9443c01a7336-25d24cac4e3mr30450705ad.1.1757671992780;
        Fri, 12 Sep 2025 03:13:12 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3ad33ed7sm45397685ad.102.2025.09.12.03.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:12 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
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
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v4 15/21] mm/ksw: add test module
Date: Fri, 12 Sep 2025 18:11:25 +0800
Message-ID: <20250912101145.465708-16-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9e7n5ygmdinwoqnrgdkehjs4ex4pfhii
X-Rspamd-Queue-Id: 1E21240008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757671993-750500
X-HE-Meta: U2FsdGVkX181CFd8A3bWdOSZuJ6o2NhrC8SmbVlA46wxUYB6s975mU+rPCoR0jyunyMD9CpnKELjhAkTB+p8OXoTgHRDZhcSUGfoLgwYnXsHUcgXGOAIeaUxZXQeXBhvRqe6TP0Wd6hYWDs601gl9ILn/JNhb36HkgAv9WjsikDraa9LQtjYlPqnUb3GGjhJEn8GCrdBjMoaPQpS4X79Fbc3Sv+hWlp195jP/so1QsxoeJ+kUKI0FqeW5z3JCks+J+iAAkkM6MLwuEpuO7FsJU1I0ViJsO6uVaQm9G100mEbJwWxFZBINTWKfBV84ZkXlR5EvCLXuHJuN1DGgAOdjCOzFOPWHCTulenY0kF8wHLEw8zDJD+T/ikU3t5Ev5f3gGdoI0Xfmojw+QCfVf+YuHb52pMrvNxb+gi91qpvccnx5DAKKMUlvC9Kh76WfcgmKYi8TVdeWBS6vfRjrt6QZn2ELw6PE6h1whlMFB1lOmO7VaZCwldm4Bc63gI+t3rQpNsLDnUMbxMwyoGmLiCiZCfCs3Imo9CTZkZGdplhTzuAzvpht1Tjl2SRSHr61k80hihHtE3HvJm7/Tmz/89m+yTZxs0PDvgUNEBHrTHM6f9xYMCSNh96rl2hp4lAo5cdnwCi9r0RamOvIxBMY2//gbY9RnrfXOZVieWR9RmHY85cGwUultfXjZk56BbBvCiLC2G4eb8YSkx3RSpWK4qOXFGDVEKqbOFb2b2+4O1WotTFyvHIuXy1NXRvbHTvnLuU+V1QjLwJmljJifinGLIxzAVr3mqD/Tj0ORV523oQtdyndBsSKLqfjqx2h6iqfLVUd9uTW09m2bu4nyq+zkfbVoEDCmcRohpC/1cbzkG/F57+y6SAPPTDBOPacRfhzlUxj2zF+Er5/ANo6I42sE2haEYAuOFayIVoSrTtzbHip4LzTGnq1V04jaBjrnETpCCHAt95P2OpftM+GFm8zKK
 2yxorl1X
 eD0oPzTRTixwZdVGwBEPVs6lTVKFScOga1qPL+9z/NelR5mMdizvDNxbpQ/CXWn3RBClyigj4GKnml0dYOC/5vEZJMuMrDz7WRYqlwbS6MYsSUswmFdf8+ZJiwS5mCoJ+NCkbd12q3X+5k9w96lz5Yz8uRHwOIZ4VeEcSRzabxg22K1blbYm1hlOr0lliu0qgFgx5jdnhfW81xI4hQQKLan2y5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a separate test module to validate functionality in controlled
scenarios, such as stack canary writes and simulated corruption.

The module provides a proc interface (/proc/kstackwatch_test) that allows
triggering specific test cases via simple commands:

 - test0: directly corrupt the canary to verify watch/fire behavior

Test module is built with optimizations disabled to ensure predictable
behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug        |  10 ++++
 mm/kstackwatch/Makefile |   6 +++
 mm/kstackwatch/test.c   | 115 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)
 create mode 100644 mm/kstackwatch/test.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index fdfc6e6d0dec..46c280280980 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -320,3 +320,13 @@ config KSTACK_WATCH
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
index 84a46cb9a766..d007b8dcd1c6 100644
--- a/mm/kstackwatch/Makefile
+++ b/mm/kstackwatch/Makefile
@@ -1,2 +1,8 @@
 obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
 kstackwatch-y := kernel.o stack.o watch.o
+
+obj-$(CONFIG_KSTACK_WATCH_TEST)	+= kstackwatch_test.o
+kstackwatch_test-y := test.o
+CFLAGS_test.o := -fno-inline \
+		-fno-optimize-sibling-calls \
+		-fno-pic -fno-pie -O0 -Og
diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
new file mode 100644
index 000000000000..76dbfb042067
--- /dev/null
+++ b/mm/kstackwatch/test.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/prandom.h>
+#include <linux/printk.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/uaccess.h>
+
+#include "kstackwatch.h"
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Simple KStackWatch Test Module");
+MODULE_LICENSE("GPL");
+
+static struct proc_dir_entry *test_proc;
+#define BUFFER_SIZE 4
+#define MAX_DEPTH 6
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
+	pr_info("starting %s\n", __func__);
+	ksw_watch_show();
+	ksw_watch_fire();
+
+	buffer[0] = 0;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+	pr_info("canary write test completed\n");
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
+	pr_info("received command: %s\n", cmd);
+
+	if (sscanf(cmd, "test%d", &test_num) == 1) {
+		switch (test_num) {
+		case 0:
+			pr_info("triggering canary write test\n");
+			canary_test_write();
+			break;
+		default:
+			pr_err("Unknown test number %d\n", test_num);
+			return -EINVAL;
+		}
+	} else {
+		pr_err("invalid command format. Use 'test1', 'test2', or 'test3'.\n");
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
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n";
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
+	test_proc = proc_create("kstackwatch_test", 0600, NULL, &test_proc_ops);
+	if (!test_proc) {
+		pr_err("Failed to create proc entry\n");
+		return -ENOMEM;
+	}
+	pr_info("module loaded\n");
+	return 0;
+}
+
+static void __exit kstackwatch_test_exit(void)
+{
+	if (test_proc)
+		remove_proc_entry("kstackwatch_test", NULL);
+	pr_info("module unloaded\n");
+}
+
+module_init(kstackwatch_test_init);
+module_exit(kstackwatch_test_exit);
-- 
2.43.0


