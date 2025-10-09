Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15536CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F348E007D; Thu,  9 Oct 2025 06:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF708E0002; Thu,  9 Oct 2025 06:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4600B8E007D; Thu,  9 Oct 2025 06:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3171B8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50A53BB611
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:38 +0000 (UTC)
X-FDA: 83978274996.23.57914E1
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78004180003
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B+IQ1koc;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007456; a=rsa-sha256;
	cv=none;
	b=k0y5MVi3Qv0S3AYxClm8LJsLh2r3sidQghqT/7zfDOVAgQ7q7DzBd9AffdTP1v14eUEwAr
	TkfE3ku16cUiPBWTtv5bx7k/PkTWsGrBlJmirDwAvm9iK0rl+hjn2w4w2Q4NsFjK5bP21s
	iFrCklN+7QSb+GQthFxFMR6FbIkH0zk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B+IQ1koc;
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
	b=ql3K4d92vCs6SDIw02iT/lH83QB4JyO5FvHMewtf+DPDFztYDC+XMb/FlOGiQKOR+CABfI
	12bXcxNIzqWR6begpsh8Wunpp2fISQBQ34gIUDkgFxapoxyoT/hQDqRAmycT5Aw30B8n7T
	QGDDKzuQpS6hrnHL39ss2HWPJzTMzYE=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33082aed31dso923342a91.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007455; x=1760612255; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
        b=B+IQ1koc8cRpLnsLSMe9m9isqlR3i0HIBCzSDCTHGecWuCSipkCGGDtzPoYRmCz1/+
         gkW6ISHrULzh17jH4KTpbNu2EN+lZlPIecTWkOPNneZTjN3lxWLyZbP6/eWX6BE7gjpq
         jSpS82UXLCtFPLNLf/MvU9d9Wa/Cvb9/f3TB6I3yYi85d6N2vi2IoRKSqgS0yBCJQhc7
         X50aq6q4LDeb9gjo5Yb8Lfb4m0hU9AjnrNWtrU9jJ1MQJWqiABf8/7NrL75FH+DeYbg6
         TgeD0lLFNX6sB4kRwirjcc7NVv9XWDLNDgG6i5vgDb4suJZDBhgomvOlBzz12YpQqnzd
         jL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007455; x=1760612255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
        b=VtKiO7CeL3PX9BQdHJ0j/2k4IV82mSQnBUk9HDA90LFvf5LD6Q7OayvcCRdWx71KZL
         Cbc2MBgC6Elth146vBWh5Sn1lb9Fz6H5lxoobP3aB3gmmWDAWJpdNAA+QfEfX3Gjh3tA
         S31LVsOMvwiW2oHmI2Grv26pSvO5sw4mZW2Zbqf3Mn3Eu7BTdKeV0wNyxmwz+Mrem+n1
         MZGXcwv42Z6cD5adWl1LPrNNmDygOScnDjPPzuE2tJzoVusp/1RQP8n8UJ1rz/IhVFKs
         +Ry3fI/aXYj1TLSxrCP0A/4BVsp9BkpTIZ5sGOLyshvDW3J/gCNt7+paD44QHrAvGqV9
         AEUw==
X-Forwarded-Encrypted: i=1; AJvYcCVrOXiyoIfAaJyKxXJNf8FR1Ki7nTX6SCHmbn2mHM4fjWprnEujKYfObOuyXFT/+BcDO6Mo0VFXQA==@kvack.org
X-Gm-Message-State: AOJu0Yxaqm/78kZP0wJ9wxsoQe6RStW6h0QvFsJA3h4UDHb3scJ6JskS
	gOKfVLXbfBQJryfxkFDFDPOv5sBpR4TZfzPuBubDdUGnoi08bWOFfOI+
X-Gm-Gg: ASbGncvOK75Yr5qvBBgjNU6e+GtY2Ozzl5UG8c9zEpiv3/urHxn2H33b5+f4d2HFxFX
	yZi6D9eutBtOK3GGnzycZb6xo/Xmbz7f66ZTLqCUSzQBtkIwM6w4q7TSBEZpNoxCPN0bUmBTHNO
	pQyt/FborvDTaNL9v4Mu71dPASXUs8R5Wg0Ty0e13R2wcH+2YMK489ZJZLYVJ3uWRoOaksCK53K
	qzsqAWjr0CHYVrKGAldRqUMywsixVk3OONHvXIZHW51niE2+I9Uv73qmpXT0RhDmHN6hyMDRzky
	OZrWP6iRyTVGe+/bE/q4l3V5F8YuR/19IpY7f1A1PFFw90IOAqco1up15Mxh35PSEk1xgufnCJa
	QhEDdBEq9b68koAf3bNR1X+QnWK/WhKXnQ4NjoGr9nTqywgO/f7mg2644bYT/
X-Google-Smtp-Source: AGHT+IFC13odZspSVqGRoywijSg0VBbkFQPkMFOijqia9KTXZKXwmvUEM0W1W0I7XOEEhq8lnQYbLg==
X-Received: by 2002:a17:90b:2249:b0:32b:cafc:e339 with SMTP id 98e67ed59e1d1-33b5139c4f4mr8493028a91.36.1760007455151;
        Thu, 09 Oct 2025 03:57:35 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b510fc5e6sm6727834a91.6.2025.10.09.03.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:57:34 -0700 (PDT)
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
Subject: [PATCH v7 07/23] mm/ksw: add HWBP pre-allocation
Date: Thu,  9 Oct 2025 18:55:43 +0800
Message-ID: <20251009105650.168917-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jpip6z1cc3ayrnoidgohgos8zqxy4emt
X-Rspamd-Queue-Id: 78004180003
X-Rspamd-Server: rspam09
X-HE-Tag: 1760007456-801392
X-HE-Meta: U2FsdGVkX18WMie0u11fZSEweCyTEup/WYOnBx1k6tUU+vzMDxcgpgdvVvccMXeSHM+/zwDsD2ssHjXZJ2ZiF5bD/WzRg2ClykTRtqGwCK9yZmHkrEoYlYbHqFljsfZmOqfyQZC0aoOT0DFPGYVt3ObzlDYcjXaqUaZxFlTi7T8cLNHneGmgHPzWd1pMzWGzX2JhRI3e20A8JczYat+G7t1m45kUKWutJps+1L+H1iBLWMOlh4nLShMib07YpsaiDwqiCiEvztFp9ku1n1dWT4giB4dDiIymLLrsi6wSUk4TEzjfOuRACO/5E1LDyoBdXqWYUpyU75BfiI6FfN41Cl/7+RgucXVvEzA58eCJ1vwZ5UJUgCxjfJXiZINxX7vYwHzH87BTWgN+pIJaYp8tcyQIwkGV1oPALStPV6Ctvw0PaWCXAtB+eoMyMI5LERoBqzx6WQT0AijbcV/1BlxOe9dsiSzaAd2EdZ0bp3/6B0aI56uZtwb49Syv+IHPBjMlzYhlyZAASWnzwPBaIF/Her+BRwE9M/JsKfkGQ3yurg8CEeOCN/JCgnkp9qj8eEI4fpVRCsVGmVUkc3V2+j0yTNnKcMmYTFoiM6+JLGvIptVFBf1ffduNvjvfQunahvH/toiMZ/gCKBP7mmTBjBwOGhyNA78zsA1TpnF8RYBUWsuToOgIVUWz3pFkFYnTneOsed5zh8ZmpA9kAVG+cDgRt4eZUrqxOyrmhcc5oHpG+AFh7YxcIjGCxDzygw6C+cH5EepZ+PcqXAOaCxCbhGNq9FpVBhdIsWVQ0u5t+8l2r3rdt8l8Lcw4SMP7zeVPBQprRQagumWb/iLGxqe6qrSZtHdhWYLUSx70AwQA5T7qK1EnN/qfUDJPLmLNtghzAwhv1AY4WzUIthIRy37mcwmOvPTQGxU6CMu36iYASx3YTVqkUUZ6DQ4d5wuHxDqVGtMF3t2HaMJskR5JxQSgbgx
 5CaWVrgk
 ScGB12B5N3PUvbjpj9c4Sme2o3koUmeiYlC0M2fK8DugN8CqWy6gq1vgl99kQ4/RFwD5/dNYhHyUKNqsERtg5DOnayQzPCJWFGVAsesOg+FGYBML5Vbjq/qgZmWSEBJrbxUKd5MyJet7g9xQ92cLE5mHNtyc+aw9naIIoBcHPP6a09AujOwB9wP+lINuxscI4kAuQSbuDT/nfQWEqeCvb/e13SEk8dlwArJ9BAwqxoFJWoiZqAkvjqIRIl3/ikQaM9GtA8vCj1+xnjTJdXo7uG0RTtEjrXNz7Yo6LER5fD1JBRS1rvnLTcgt69Yb6NbBxnVT7pCyRnEKqVOqo85gsB8j96tVdu/9cv8pBx1JNvKfY+n7BFcee/CyyLYAob7gPg0xDaThzOTib2rSztW9+klTc84GHnWV+sHjXP6h2fBbut3j3YCUrFYjLvH2ZKQfaQlRBJZ9Yv/EHeuTFnWZirEJXEs01thb3jf152ScXUTFxOKdQ+dU8eiEVNnLiRmOVxmj/j0IQAld9/bkbTkzeHJ3we7obK/cPUiD8excLtulkfw0WF1SJDRGoprC+WIyHwGLSXHQw1NxOlg5LZIXim8d7MQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-allocate per-CPU hardware breakpoints at init with a place holder
address, which will be retargeted dynamically in kprobe handler.
This avoids allocation in atomic context.

At most max_watch breakpoints are allocated (0 means no limit).

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h | 13 +++++
 mm/kstackwatch/watch.c       | 97 ++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 983125d5cf18..4eac1be3b325 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -2,6 +2,9 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/llist.h>
+#include <linux/percpu.h>
+#include <linux/perf_event.h>
 #include <linux/types.h>
 
 #define MAX_CONFIG_STR_LEN 128
@@ -32,4 +35,14 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* watch management */
+struct ksw_watchpoint {
+	struct perf_event *__percpu *event;
+	struct perf_event_attr attr;
+	struct llist_node node; // for atomic watch_on and off
+	struct list_head list; // for cpu online and offline
+};
+int ksw_watch_init(void);
+void ksw_watch_exit(void);
+
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index cec594032515..1d8e24fede54 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1 +1,98 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/cpuhotplug.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/irqflags.h>
+#include <linux/mutex.h>
+#include <linux/printk.h>
+
+#include "kstackwatch.h"
+
+static LLIST_HEAD(free_wp_list);
+static LIST_HEAD(all_wp_list);
+static DEFINE_MUTEX(all_wp_mutex);
+
+static ulong holder;
+bool panic_on_catch;
+module_param(panic_on_catch, bool, 0644);
+MODULE_PARM_DESC(panic_on_catch, "panic immediately on corruption catch");
+
+static void ksw_watch_handler(struct perf_event *bp,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	pr_err("========== KStackWatch: Caught stack corruption =======\n");
+	pr_err("config %s\n", ksw_get_config()->user_input);
+	dump_stack();
+	pr_err("=================== KStackWatch End ===================\n");
+
+	if (panic_on_catch)
+		panic("Stack corruption detected");
+}
+
+static int ksw_watch_alloc(void)
+{
+	int max_watch = ksw_get_config()->max_watch;
+	struct ksw_watchpoint *wp;
+	int success = 0;
+	int ret;
+
+	init_llist_head(&free_wp_list);
+
+	//max_watch=0 means at most
+	while (!max_watch || success < max_watch) {
+		wp = kzalloc(sizeof(*wp), GFP_KERNEL);
+		if (!wp)
+			return success > 0 ? success : -EINVAL;
+
+		hw_breakpoint_init(&wp->attr);
+		wp->attr.bp_addr = (ulong)&holder;
+		wp->attr.bp_len = sizeof(ulong);
+		wp->attr.bp_type = HW_BREAKPOINT_W;
+		wp->event = register_wide_hw_breakpoint(&wp->attr,
+							ksw_watch_handler, wp);
+		if (IS_ERR((void *)wp->event)) {
+			ret = PTR_ERR((void *)wp->event);
+			kfree(wp);
+			return success > 0 ? success : ret;
+		}
+		llist_add(&wp->node, &free_wp_list);
+		mutex_lock(&all_wp_mutex);
+		list_add(&wp->list, &all_wp_list);
+		mutex_unlock(&all_wp_mutex);
+		success++;
+	}
+
+	return success;
+}
+
+static void ksw_watch_free(void)
+{
+	struct ksw_watchpoint *wp, *tmp;
+
+	mutex_lock(&all_wp_mutex);
+	list_for_each_entry_safe(wp, tmp, &all_wp_list, list) {
+		list_del(&wp->list);
+		unregister_wide_hw_breakpoint(wp->event);
+		kfree(wp);
+	}
+	mutex_unlock(&all_wp_mutex);
+}
+
+int ksw_watch_init(void)
+{
+	int ret;
+
+	ret = ksw_watch_alloc();
+	if (ret <= 0)
+		return -EBUSY;
+
+
+	return 0;
+}
+
+void ksw_watch_exit(void)
+{
+	ksw_watch_free();
+}
-- 
2.43.0


