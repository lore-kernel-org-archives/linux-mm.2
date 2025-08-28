Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A8ECA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE788E0008; Thu, 28 Aug 2025 03:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47648E0001; Thu, 28 Aug 2025 03:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36078E0008; Thu, 28 Aug 2025 03:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0A908E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B1E81DEC8E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:15 +0000 (UTC)
X-FDA: 83825352870.14.21D7300
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 862DE18000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X/LnzlzG";
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhhrrRkb4F3PyX047v9pUxx2LHKmYVjN4mot0t9leaw=;
	b=WQiwacShGFetuvWyS1ea4HwZ3RWbQ0/CumOzwCtbGLIUEh/0m6GBsN1twTUxuGt2crzmz1
	PgAOzCjlZJPw50bwxEvC1EmQ4QLjNSWK0kgW5sH6cdEWjWpWawm0nnHrKusQ05d1GBD3Zu
	1v149MRmH0MbxgoK68MP+T57BiBJysE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X/LnzlzG";
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366453; a=rsa-sha256;
	cv=none;
	b=xAiCEtnjXvXFBrJpCoc65wf7wCcLj8PuY8uwEtHIXyGCM53vxqnuJLTAV6FlrAr6LrvZuk
	B5Z2Q4dz+ggTaYffvPPta8mwvkXO6YfKo0wZm9uljxAJdZ3OdKvkiPdqlJ+8SmvFvMwvaN
	E3zVpkHPubb1pNqcC6nqjpK6bC1RaW0=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7718408baf7so659360b3a.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366452; x=1756971252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhhrrRkb4F3PyX047v9pUxx2LHKmYVjN4mot0t9leaw=;
        b=X/LnzlzGvCfILzw833R4NKFEq4rvF11wgNS1bU1cOtJRrXbIwS20CaqwrUzcg+mcmU
         28VzXO0ROX1d344X6m+bFgmcFz5Fd2k6h0AthHApKqM4HIgT90cCi+v7NtDDK/r4/iUI
         Z+c6+y10IjGRJwpGRO5qgsUS1hyJfz3sQ/29SdY7GveKi3nEzuy6019cIiyJsb5NDqhk
         1GGKC78As3hW5C6FuEtUFEhk4RvY0GcScBltp9gjq1/bZxSFoWa7FNW87dPNc1b9Ur4b
         T1qFWvFbqrSHGLCZAf9x8Yav+8PvkYwuhReAW2493itlixRG8yUNpPJqZDKVPWSfjZdk
         22Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366452; x=1756971252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lhhrrRkb4F3PyX047v9pUxx2LHKmYVjN4mot0t9leaw=;
        b=s+BhOmtiBre3ZyKQFIymWw4epka9SnZM2bhrWdGBUq/j8oSLgyWZ9IEj3se/kMaNTv
         eXsUrOSMjHyqavU+Yyeu6eglFzJckSLywYwLQekBbQIat+yrZtcgboqXdJfo3bltEtIh
         ENYr4mRQiYGsKVmE0d+ZQNVUu2f8yx9+9Rdz//MZVEr8VNjUmeXS3+71yfc8wb0c7h1P
         o6WivliFPKTLyTEToMLsh3SATbV3+/WwEZQzhAsFXuD5/upuQZxKncIuM0XMZnIjC39v
         VnOLQxS4hct2fnKnU4pJx8Kefiv/POx/ccAHUK101iZdWf+rArirb9M186751RcDA4h1
         pHQA==
X-Forwarded-Encrypted: i=1; AJvYcCU9fDQjKUcUan1EsZhrI2RovVfyPZfyykMG3RB7Xku8JCzLDlH1zjJsdRpeBfJ2CJT9NWMWdwr84Q==@kvack.org
X-Gm-Message-State: AOJu0YzteOp+ZjtXgZkREnzsHXouqZBH0l0zyM9O2CRb+55jstNbked/
	XsihgClN89GmPsSBo/rr7KGpRvcvhYHWd/E18FxhuPD7DuroE0YOIkaj
X-Gm-Gg: ASbGncu6WvEfVlvRPh5dV1SRA55HGnVFKSkm0jG8bxPYPY4ByepYqTuTz6N44PR0wSH
	ZUffxg1xQKHlXbzxn6Thva3lPYY776OU+6orU1XKF5TT9yCeLEeQLHdlRo8+YE8QhSlSBMM5nbu
	s8inxQ1q2/HwE2gr+qfEVaXor10zGPX5vOqDPv1End3zl7+vAmzKYtT2ytP9EowHIO6CN0wMQmf
	H5a9ZJe63jHY3LwzhcL4BwEatsQaq/JIHKaL8rDiX/T7UC6rpZERMNbcAqsAP1f2dZJnr+fyenE
	LqwfSZW1M4gqFSP5DjO7SYjZ+xGrCD8gmR7k/TJ+c4U/nO5N1i0YBRJ1fKULzPWuGlvsmr732Dq
	Exe1QIQPGCcz1SyM/pUfASql9nosrAw/+eL5MX1AouDrZYRIAKkZtpRTyKDAv
X-Google-Smtp-Source: AGHT+IFW8MIhp5lAtNEt+uw+DAmzNYmf1p0SiEn72vtOqZ4l+f/YrYQksgLtRZc7uoqAe8mYBAPXtg==
X-Received: by 2002:a05:6a20:914d:b0:243:a52d:7a70 with SMTP id adf61e73a8af0-243a52d7b0dmr6549481637.3.1756366452260;
        Thu, 28 Aug 2025 00:34:12 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:11 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 01/17] mm/ksw: add build system support
Date: Thu, 28 Aug 2025 15:32:34 +0800
Message-ID: <20250828073311.1116593-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i1pdqzfx8ookiyynjyngk5sicu6tpaum
X-Rspam-User: 
X-Rspamd-Queue-Id: 862DE18000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756366453-58430
X-HE-Meta: U2FsdGVkX1+cLmv8FwLzZ9u7X9eX2y7/yAmyKsniOK7gn4lBTRtt2HFmEelK9F6hP3mFQG7p9wbZDPakoxiwegnP27nCS2Q0MOg8L0aU4u4Y560gSWzlnsnejLM/qhbnqVERvftlKBUeZfS6HRgq9wZ4tLwiL63RzgE1ueiJRvEFp91HW0iT3egaJrz4crjfVIP5LQAeIv+ZnVkoy4PptcQ0aIYpZQsPlis508AvC+oRLvMJ56ux2EvlfF+ZDQTEkXYtLayY3ibOyKyn/f0iA6+oGwBpkhAfalVXypMW34dSgiE78GBE9yqU6MkqkDkJzVRnj6gKcUQ5PaJh8InXaWGff3tJBhOoR01cEux8A8j9iZF2BZM9GurZ0GGV7gXX/mH5cp0BkWW7ThEXOjglwV3XE4zfWz0vxxfwdKeQKTuM4OrL8qwn7zgRFEEWNAgmRPlMj557yusaTBOW5jB7iofkRY4L735eds5rdblMb6Xe6lLwO3YAY22h1jvH8LsrlrWucpHz+Fn8Gx4Xbcy4NBqIk3B3lrMLCpeI6YkUggLwRWEc7clHC6AOF08tBMaCbm+zWgKasJSIJwSCk4ouzROIjm08mDw15Fud2n174pv7I62PaVT5HKu7C0d9WKNKsZdy2jwkVx1AwailAsQ1CDnQ0LLmJxz33T1TZQ745A01ujB2N2oDbNA1c1F16FIJTSZ37pkIflHFAMJkd3NGFPPFjHQXLgEd2J7J8XeCswBV6lJbveeSwGoIriPj5upzAfN8P415W/5Ker9mE9APfMZn6AW/GfljpgpYGVslBQz076tdCsBF6minNQoLY4++dQ/vM6xySFCey7YJ9+00H9BO4Axea0kpU8Gqp3JYh6yJFL7h2Phbc0NFGCKzSvHhDZjFrOz25MaO7awQH8Lj6wKA9hN5jSMFboXBU2OuG9ynmWEjtjqDvB/k+pDfVLb/RwSeV7PNHL7YWX4BO3A
 n2VPeygV
 g2l0rCaFDOz2lNUUBm7U2aJG9NOwgoUCLsoGj3XIc1KbLid4tdQ8bqQGecHBVGV/EWWWHHL9JRnKPrbimOKxCvzirnM5hkYylKX5m+XZq0wGpUBqZKJ6wCGbH2fLXtVC0Gjs36npBKHLcXggK31iwA5vIC+Gk4Xxg3zIoB6CCBcC3axFvqiU8ZoBPrCyk0ixIQhSZCJKIhiFFgLJPH90hvM0xgFzvg1bNlhOlmpYv3TIGueGAXiPBFTP4coxgrpFfkgpJLmOYoucOAuCpOE6CHU7P7bpkj0NN1yYn/6rEgVmqUA9KAlV1TCq9tXmNM+Oh9A093SqVDIYCmtVe78MvRLoSgaMFHrlKJi2nnArEhPUB7k+Cl9s3mdCvb7Vpw9zaHzYTh3GuEU/EsxVi2a1wDq/1zcUgcrfTVFiLAZjTv7R0f+nNEU/njY7cr9m2ffT7Dcsv69xFfQ2XrEoyUQK1AYw2jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Kconfig and Makefile infrastructure for KStackWatch, a real-time tool
for debugging kernel stack corruption.

The implementation is located under `mm/kstackwatch/`.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug             | 10 ++++++++++
 mm/Makefile                  |  1 +
 mm/kstackwatch/Makefile      |  2 ++
 mm/kstackwatch/kernel.c      | 24 ++++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h |  5 +++++
 mm/kstackwatch/stack.c       |  1 +
 mm/kstackwatch/watch.c       |  1 +
 7 files changed, 44 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..c2cc8c7b595f 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,13 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+config KSTACK_WATCH
+	tristate "Kernel Stack Watch"
+	depends on STACKPROTECTOR && HAVE_HW_BREAKPOINT && KPROBES && FPROBE
+	help
+	  A lightweight real-time debugging tool to detect stack corruption.
+	  It can watch either the canary or local variable and tracks
+	  the recursive depth of the monitored function.
+
+	  If unsure, say N.
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..665c9f2bf987 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
new file mode 100644
index 000000000000..84a46cb9a766
--- /dev/null
+++ b/mm/kstackwatch/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
+kstackwatch-y := kernel.o stack.o watch.o
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
new file mode 100644
index 000000000000..93379a0a0f7e
--- /dev/null
+++ b/mm/kstackwatch/kernel.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+
+MODULE_AUTHOR("Jinchao Wang");
+MODULE_DESCRIPTION("Kernel Stack Watch");
+MODULE_LICENSE("GPL");
+
+static int __init kstackwatch_init(void)
+{
+	pr_info("KSW: module loaded\n");
+	pr_info("KSW: usage:\n");
+	pr_info("KSW: echo 'function+ip_offset[+depth] [local_var_offset:local_var_len]' > /proc/kstackwatch\n");
+
+	return 0;
+}
+
+static void __exit kstackwatch_exit(void)
+{
+	pr_info("KSW: Module unloaded\n");
+}
+
+module_init(kstackwatch_init);
+module_exit(kstackwatch_exit);
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
new file mode 100644
index 000000000000..0273ef478a26
--- /dev/null
+++ b/mm/kstackwatch/kstackwatch.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KSTACKWATCH_H
+#define _KSTACKWATCH_H
+
+#endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
new file mode 100644
index 000000000000..cec594032515
--- /dev/null
+++ b/mm/kstackwatch/stack.c
@@ -0,0 +1 @@
+// SPDX-License-Identifier: GPL-2.0
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
new file mode 100644
index 000000000000..cec594032515
--- /dev/null
+++ b/mm/kstackwatch/watch.c
@@ -0,0 +1 @@
+// SPDX-License-Identifier: GPL-2.0
-- 
2.43.0


