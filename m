Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AE5CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FAF18E002D; Mon, 29 Sep 2025 22:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2888E0002; Mon, 29 Sep 2025 22:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A4D8E002D; Mon, 29 Sep 2025 22:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36F698E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 012F6BA3B5
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:18 +0000 (UTC)
X-FDA: 83944375158.14.3E073CA
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2173020008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQJQbBzN;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4BKEfc9ax2ksTKKBAwbjubQHvBiDjA54WMJGQTptLg=;
	b=wc92xMmPeWX3ApQTq0NE9H2fdlpbzVUN6lJqWt1v6fMoESbVCn9Oz3ZLVBQfxbzUxQ7CJq
	kNvho8C/rS8rvV8lD4dy+Rv4oQUNW+crOA9WBdVXWZtHhnzNLGQDhQDskbwh4x4SWZBlo3
	BMq3WykLk65r/0Fs10wxiDR8bsXi0a0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQJQbBzN;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200317; a=rsa-sha256;
	cv=none;
	b=3Xyed6pBfNvzVGMgs0WI5lGtFSd1VdDtIiQehLH+KpHZtF0G40s9A5n+UYX9tdJxgBKtda
	qrvlHqMBhVaO6xhq9utB+SHHo0seQ2Bzvb46kgm2MSUR6vmY1u/T/OzZDRkiYp0R204uhz
	jDs9L++72a8Kba/CKJSKe8gF0bfiVoU=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-78118e163e5so2786769b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200316; x=1759805116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E4BKEfc9ax2ksTKKBAwbjubQHvBiDjA54WMJGQTptLg=;
        b=GQJQbBzNuD2r8KpumsT5QtUL19YKT3Q8teoCnvdchLrCgi88UmNhske3EGttADMmt/
         A5WQlMEBLNyczxkfnTTQSs+BmmapaZcWNHX7uYiUO98BH7s7G9Y3QvRnlw4+KytJvP8Q
         UeWcVljYpCoE4QKFmsMVJa9GBKeThsMhGWvKAkZU9gi9fUFK49IHj1ntX75j6yVKG3Qu
         A5LETA72E/YYt1wG2XtYywNivXmQ7Y1UGt36Jqs8/a9rb398ZWDArLg/zHbKvxjtnf4S
         KV20saYzSspSistC00oDMOesX4sP2d8sBRLsefqdRbaOL5FLFOD9EGR/SQDEnEi5FecC
         knQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200316; x=1759805116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4BKEfc9ax2ksTKKBAwbjubQHvBiDjA54WMJGQTptLg=;
        b=qoZS8BzBcAPFxi6vkGJv6jyp+1WcCYMA0vjRZV9adX2uMM86FHlcPSnu7WVyRMCxiw
         leBaUktLPJbe2cwRYfgTGTRV4V1wbzpQmPit62ZxsZDi5WP7783A/M0dAsAipgFDFjlZ
         3oYRntZu4WSLDfd4zvL709oDRplfGFV2+TMvHnoS5lDRtGcpcmqQY6kMQK2syEKg5yNH
         rOqaR1aI6OPRmhPFXsoGSiE+peZQNt2mOwJANJ5aJ7pORQAmRUo75peyHPTEE5naKWo4
         b8H4kT6s6keeYmbgoQOkHM5eRg7JRGK8xKXAVY/ARm12inBL9iiD/bHAqawuP6EaY8+7
         4lZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYc7ZC993q5Z+Z07FTslODfCasVOM953k5O+UZGtqbA7j1I/1G0F071porgKTQ+Kz4r8T8knWTQA==@kvack.org
X-Gm-Message-State: AOJu0YwmGxPxO4QQmhe4mKGjBqsaiIZKIew33P+xI5hiUwpuNMFjujSb
	qRScS5fzd7z/RJDbJs7/38RzKNtz4xRl6qmXIfAQxpY+IIFJ/5N7CRaF
X-Gm-Gg: ASbGncs0qQtc91R5jUm6hgAUzbzl49suKpgD/3xGGSiEIIJk9T9Hnip0qnofkDk729k
	5/uXi+EHnJpIoVFkZ1Ks/dJpM1RIzetC9iEaib5ZtOY0xO/ZQfGJsdLrA5qXPlZt/f0Gf1yMkwb
	T0Z9FBangO2CRGiX+5xXHIGGfchXth+jlRf5aLIssplYFASSsw3XskyvRjy6T8f8YSpbom9/iq6
	IvG0G6T8VR74noXLIwRawUwbXmAA4cjG1b5qImDpgpvfvpxNd0W6L1JlS1ZXWqSYnNnpq2y0k+2
	EIvoJs7pKmmJ44VSRYdkwwijR4EpTDUBkNzw/ar+FzrwJtscAzv4dv1D3PCZV82cDe4FcW0v31U
	TXOQH3JFfGeTL8zq1mYsvHFZ/WAyh0CSPlCOaxn2KxJdlSE051pSyY2zGhzOBE1HszEJAJR3bCZ
	n0HlSC6jSNiuo=
X-Google-Smtp-Source: AGHT+IEQuyQ0WfSSzPcc+c258KMZgmg4lZ9MhFnyLGeSTv6phqmEXsURuXiHXbyU/qbGHk1KY6eV1g==
X-Received: by 2002:a05:6a21:3296:b0:2b5:9c2:c584 with SMTP id adf61e73a8af0-31772a179dcmr3208370637.26.1759200315810;
        Mon, 29 Sep 2025 19:45:15 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c557418csm12399859a12.30.2025.09.29.19.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:15 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
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
Subject: [PATCH v6 11/23] sched: add per-task context
Date: Tue, 30 Sep 2025 10:43:32 +0800
Message-ID: <20250930024402.1043776-12-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2173020008
X-Rspamd-Server: rspam05
X-Stat-Signature: zbszzi1megf79ruah6o5f4nj9mibbr99
X-Rspam-User: 
X-HE-Tag: 1759200316-609882
X-HE-Meta: U2FsdGVkX1+Jmza2HJjaKd9nalsxgNmvJKfynm9qggCMj9Nq/MlojGFCqGI101aCRiQH27UTXbQLMrs2jdScHqy5yMOiLBPpSFdhXq6f5m6wlIQzU8eKih/H/A2Ikhr2Jz86F8bFSNTQ9kjzyVszybv0xQQftDxNXxwv2aEBB1SQKTYrnx5+MmnTE7bapEKhjDTSiNUMpPH4fdwE412jnOPj3wa2JFdYbQ1R+o/xGkgpWH8y0Inacz9lPKXvRmq6Sc7anj0afjwaSp8UYVC+Yg5zs0ttLy2K3DO3jSnpQeKbiZF0b4TiRowdYpaRrjfPWO38vGZ3aiFEoTUUeXL7nxxAGfXQvrDTWbZAV0d/C398NFPQZsFglgnHFQElH6NC+w2nwkb6DtyasrZ3eiVfpsQa21LSCK+ATm7bkixOKv4h37V+Cl3AT/Ml6bBR9xqNeXtRUJde+xizQLjmB3tnO7LtKpzPOwAhTENePYrnjgB2Vuz7dWFGidqi9VIkVKyG9WePeWeyXgvMRSodrK3+DMF9XJ+doIY1oM4YphOxmFjzqpoKWhzsr59WjGSP5xFbWXzdbVQMgfwWwf4IDHStmFyEisNTVW8ZaOpr6kWiNH+QDeK/rUIeyBVASsA0g86k4dZOl0vRQxqf2Bh13/V1IthmpJ78qUEYuh8km13UlDTIggA+/XTXWbjRzw8nwofG1DFqDh5dpoqCb5zjAeZro6ti4QlWpLDynS+bR8MJyVVvMLayej5FqBBTU+MCso4A6jTA3/1TxSE1CO4tTo+mZ2m8A+PGZ0QgchlO4jesCoKKRaJcOi6+MMiF+AOg+TRPTzs3IxKdHoSqRuczpE4n2sETiqWBKb7T63ZMSz+ruyCmFj9Ts2RDqVES6YFjOYCk1iEwMFOuL+0A+4v05QMBT4/A8slJBPH/vfWi8uuKub34ollLb9IukskTy/IAWJfkPTezFeag9AClVEWZ2rt
 cIJ6fpy0
 BbBZsh2dkeaqBQwRGhSK0QkMfIOFgahgSLknidBdT6InAkMsCZIf/gVFPqa7sOvdnXJNwoDm4nJrErfun4j/305HSuKBJH7TIECmIhXULjfYCBNfSquZ5cwWJxMNVMm/lbujf8iJJYsdJH650ssbhML2jb2YHVp4QsewKI8BnxRfPvcl+iFt1g1q3iB4e33hHNnP6O97bsB/zEk03aYDCpA3yzXUrx+d5mgvTwX1GgFFbuVgtf85Ou6VBR5ruiVNnZZ068upT5qRr4/XLqb3swWuzj7OGFidwvbRYArlDp5VW05++dCG0WrmzIGk+WxsUxWY7hAmRZXOLsgql+IBDqZQN3hsHXeCS6M1wQciDPv63RUnRbGz0QA4OnxP0yaPOolJ+NK4tx1uuzUN7RNcHHv1o4irlfpBcD1Oj9ehllBpHAgCwuVGsz0uk3nxuJDXI5JJ2T22w2ngOvVzIKIhbvrRVyfoGg9pMiq8Cln2TenNv+RFGnKiXkS3n0sGNytupdoYs/eecad04LjSSqfSGG2huUqDEC4YH4jXZ1MmiaHPXGLLD2amy/1bzK2xjxnNeG7HM18s8WwDHVJQ3AMca2bSgtxGzcT1ZSC0dRmFWOrmw2THqni3y8d5wPR0cnxBMA+yV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce struct ksw_ctx to enable lockless per-task state
tracking. This is required because KStackWatch operates in NMI context
(via kprobe handler) where traditional locking is unsafe.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch_types.h | 14 ++++++++++++++
 include/linux/sched.h             |  5 +++++
 2 files changed, 19 insertions(+)
 create mode 100644 include/linux/kstackwatch_types.h

diff --git a/include/linux/kstackwatch_types.h b/include/linux/kstackwatch_types.h
new file mode 100644
index 000000000000..2b515c06a918
--- /dev/null
+++ b/include/linux/kstackwatch_types.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KSTACK_WATCH_TYPES_H
+#define _LINUX_KSTACK_WATCH_TYPES_H
+#include <linux/types.h>
+
+struct ksw_watchpoint;
+struct ksw_ctx {
+	struct ksw_watchpoint *wp;
+	ulong sp;
+	u16 depth;
+	u16 generation;
+};
+
+#endif /* _LINUX_KSTACK_WATCH_TYPES_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f8188b833350..6935ee51f855 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,6 +22,7 @@
 #include <linux/sem_types.h>
 #include <linux/shm.h>
 #include <linux/kmsan_types.h>
+#include <linux/kstackwatch_types.h>
 #include <linux/mutex_types.h>
 #include <linux/plist_types.h>
 #include <linux/hrtimer_types.h>
@@ -1481,6 +1482,10 @@ struct task_struct {
 	struct kmsan_ctx		kmsan_ctx;
 #endif
 
+#if IS_ENABLED(CONFIG_KSTACK_WATCH)
+	struct ksw_ctx		ksw_ctx;
+#endif
+
 #if IS_ENABLED(CONFIG_KUNIT)
 	struct kunit			*kunit_test;
 #endif
-- 
2.43.0


