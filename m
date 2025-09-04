Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9DCCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA13C8E000C; Wed,  3 Sep 2025 20:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D784D8E0003; Wed,  3 Sep 2025 20:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EE38E000C; Wed,  3 Sep 2025 20:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7CBF8E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:21:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E7B68684A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:21:59 +0000 (UTC)
X-FDA: 83849665158.15.5DD0238
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0421C0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:21:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evp7WdKe;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945317; a=rsa-sha256;
	cv=none;
	b=qPoBeeXAfYQZIflGmIeIkmBpfQIGvPUZVlbywOXvhg8XP0A3r8nY0XkfOQEGERuBMHcoct
	C3IU4cnEoAyn2zPLJ9O7tpDCREQNa9a0r1syxrgMQQozmW7G5bhU4uO8XQIXJ1Dw2t4SF5
	I5m5FvJiuCiF+7CdfNfGfv1qiA9VKhg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evp7WdKe;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhhrrRkb4F3PyX047v9pUxx2LHKmYVjN4mot0t9leaw=;
	b=VqDUQvKXsr8utms9SYgIiZY2qqdLeU2snxVeNoUrk4kEkgJBzY2v3MXDw7bh50OCm3J2bB
	wmWPFWn7VMCD9dLx5iPZ9595jF35jn4SZkAbwFKIQVoQ+CvptGyO9DSlftdD3gzH/7ITgq
	X+uOEZhWsZdcIFjOLYf8/DTLUiYjwIE=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso406809b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945316; x=1757550116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lhhrrRkb4F3PyX047v9pUxx2LHKmYVjN4mot0t9leaw=;
        b=evp7WdKeH17fo9Mi78asIc6eDFjxDsUNKdVdW/HdKofX0Q9r3becgpWtQnHvd+MCpY
         NHyj+cTDw9Kn7PXofrOh8pnj3lZQ7QstAo9LpvGkLuPf/MHT/LLCQKSuLzbHaQPbGqi3
         jmvDBBsSvXJFYSgYSNpASMn2B/NxUUycZ4jjdO7ltvcsyMWwMpLCxcfUho7loC6tUjoW
         EuKzywXWWO8f2gzdJGPnLhZjePvtONa45bCeY6BDDMPMICMvWPrJCkjKzqqBpvFRuDbP
         6X/+ILdskJqrXhbDSARmrJN1ym20Vh4w6lG4lVqEqXIGzZjmQ951feU+JakVklMh/ZAL
         tPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945316; x=1757550116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lhhrrRkb4F3PyX047v9pUxx2LHKmYVjN4mot0t9leaw=;
        b=abTlymDzfzQ73YHnv1WwXGwLGlup5xRJ8yHBmtf0sEsTgH1WCGyBY4TL2GjTJ9HZH4
         45SBVDlW7PWf3Y/RssXaYpaLnzPmJnHP/SrqpGM3gZNwyFSXWBnflRvlHsUi/eCa4sc5
         CUoNC5K1jwPF4c9S5wQwkxDgXbmK1tyF2EEPHUZzrxajigDD0vvLN4UNhBX9Gl225MJl
         PVb/bXqKyc591+tYsbX2TlJrYmZ2haX+YSDxpFbd3II7+iB4iW6yvup857oQj3L5p9sQ
         GGc6M0B+Mi5XEEh8yP65ztpPbGy7CGFKCiVt14jw4CSmUj0/TKx4hWIV7YUQv+d3Bdv8
         GmKg==
X-Forwarded-Encrypted: i=1; AJvYcCWGrqf/VtWYvOPOZ3JIghwAoYoAfEduZk8Zg9KqLzHtWe/qtxsyqszkwYo+HKJ5ffrsB3stw7rDyw==@kvack.org
X-Gm-Message-State: AOJu0YwuqgDXJtbeiG4A9waMC0je8XcEao3hW+vjGuUKW6Pz+3ETY21x
	jFWgl3EL1PT5Wk823FxQm6j73a2ZY/4PuftF2rLDAQ9CEIsIvCi4UhmI
X-Gm-Gg: ASbGnct0Pqrtm9sFRTjUsdnW1gc7qTe3D5MmPStUODFxaVvQF0Iaj2aENtKgGnD8ewk
	bcbAh3M6HqGggw9aQoe8zHTZhPLu+g4cLyn2d4eW7vmrw4nrocnhGp5jZlUneZaxH4aOuRC807O
	rWqh/WHptrAVFKTRq2AIUJWb/aeMVsd4MAZFJJ6uHm94Fu4NmpoOaHtWas2nqOYTklipbdH+Qw4
	qIyq9U7ILHkDKzTnShjwIboihaDdC/f6eq6HOxZoRKxzsmssyjh0VhpL9if5p13odBAuFpHZC5X
	Tj5F3ceI+VhOG7RPYl6k18T5reT9p9AwpTx0lUiXZQdNjeZeEqsviuVj9WBH2g42aNk8iRQAC90
	LU5daQ3fVO3pN4wuh/I2ih4ODYQwyvoOerpIZdV84TRvvHRXd8dIL4GCGpqeeXLA=
X-Google-Smtp-Source: AGHT+IGv0Jx86DoXMDOrUyjPpfPEAsH8ifMU/xMBIpbPH5AuwQ76YE98CDe3gaBbQQj+tqsd+VcU6g==
X-Received: by 2002:a05:6a00:2306:b0:76b:fd26:162f with SMTP id d2e1a72fcca58-7723e367f77mr18894886b3a.20.1756945316384;
        Wed, 03 Sep 2025 17:21:56 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:21:55 -0700 (PDT)
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
Subject: [PATCH v2 01/18] mm/ksw: add build system support
Date: Thu,  4 Sep 2025 08:20:58 +0800
Message-ID: <20250904002126.1514566-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A0421C0007
X-Stat-Signature: h6nh9pypet3jx6cjeo3wd8igd6dibgbn
X-Rspam-User: 
X-HE-Tag: 1756945317-745008
X-HE-Meta: U2FsdGVkX19P7/5Dfz31kG6XpFIU1kJZQshSbGm3XKouuqlqmH4S0E/aOXiMGVvqLFSrzHYhb4pkd5hH33n8IYlARa5+QfKi5G/IUqYcJcpK5Kx1c+Ra2Z1IM/U9SjpdbNa/timKk89xjF1qcxvQK99CpdH3ZGrcbTbcl8Q7DHfJfcnJVEE1AhNhiE0MNgmSsjy7P8Jwc0S3dlhl6AKzpmjdT+jk+jSpZ0inELOr0eWv01jThpqfA24JWLZD4DbkNxFkjLJ198HZhswuvclk1CusJDo+7vlqeIAiV4QRQYx178i2xDNe/RW/nLI+FbHWnXyunxvagdpai/dTI56rbYaKiFLSlD6Dui3CdpJogdvgVaXewI2NOTz3QsLT6Lmyv1A6DCVBZ8rpoOYCYPY9Ai3n69o2vTK1K41Q8TPgoVtzgRUoe/iIfwoBd37vTbLa+hfGiKD7WiPtgZ4lsOnGoc8ew+IuoZJIxeMc1GD9OAcQWifgBbHsjR9UX7i+bNqXnnx2mkiIRIUpnLzJokFcRQKNWpyqO9OXfCWbcuc1/vXqSMq/9IkacatnEqCXhHU3gw8Rkbv5vqmZBeClDoHOABch/zjvUq8iF3ehZmA0W72nknX6olx31PRRjqBgxyp2mWP9rEfhrRWaXwrgEZU3cx4TV+ozy2Vm2TW+qHcoaIC+1KA8nIjSYf5zjM+cvxqkZaLpmNPUiLgy3FF6bEOUyi9zE9OBJBw0gGAMluvFW4bMyqDVc21drgWf2E0uD9Tn1zRurSc9Rpl+UDDEJ/PCAN3pV6SI0FX7qlcdI4z9QXzT3sq1udr3XgPBLZKIFL+rNDGN+bQoATxVeqyVCaXe6cF83kL0C2WRiNczPa9+l+XCBdUUPy3FpQ6xpfqhfJ/tKTPdezI4kjENJ/XqdlBEtFeVz2QZJki/i2EePgGwQFQ/K3i9su71z4ZyE+IaTJ/H+GG2gdD69tRlL16HV6v
 H40eRiLt
 iFiHOlQ6Y0Obac2+0nuFXOmEUgkKKAKrd+m9w2AMSnYP+3jPYhn0LAxLrC41Pd2WSPc/jbJeUlQpMxOPOi0KlZhMbERd80kqcBh/A8BkZqMsUucff6lirVrKHziGaqcivSxhOf4M3MnQpuAHtNSmfrZsqNIgjATnzP88VHV06vDNUS5hfoYpQusL4qlRktpBrvnpnttlqnLR+m81mcP8Ou9beOY6j+kpI5FgnkfDtowEDdSD6JaqRZSmTiHd2aiKSD/Lq7rmEZIjiNCLsd/ikZNYkSO11H/HHmXk+6w+ToJSApRiyg2c8WG5n8QuMchkgf3H1U7DYpyfOtskK+WU+xoG0JFHLfJLIN0OMrA4plk9ta9TbnO8AazmebN/rgDHgc4QVPuru4Q3udNu9yDOtMQTjZ5t9At58Ta1U9XpgTErKv2uNyv3mz0WwZLIZ9LA4lEpSHQu0tFVqzuGrpbUsR++kjYes1WAdR+cg
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


