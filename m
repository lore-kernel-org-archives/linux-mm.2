Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B59ECAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0908F8E000F; Wed, 24 Sep 2025 08:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0688F8E0001; Wed, 24 Sep 2025 08:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99268E000F; Wed, 24 Sep 2025 08:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D94E08E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:25:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8979E11ACA3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:25:07 +0000 (UTC)
X-FDA: 83924063454.04.9A373A2
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2EF8180009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:25:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jaZmMF8A;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758716705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
	b=6TKWntT9PMZsMfL50+DUqhWX5HzoQUx+7XAQJunFQ7h/CbWn5I2Goz0bUSUZINzVoY8EP/
	/MZBzYR7vcGm5roE8ftZUVRJ6voXpWBEIJ+DiD4FMUi+1mnEKfaGTR6hGWEVqwuK1kuYDs
	Mn+ylZxPmzb+lsp9RRDbcPRFe9EuT+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758716705; a=rsa-sha256;
	cv=none;
	b=iXcu4v1u8JqMRBt/3U26ODRDELrdq6uK5cxczngLo2GRBIKAOZ3vIwhhtslcL8I/5wJvIH
	rcjPT1U899BvD3XhECKSp6BEtDKynLJc5t/h3T6CBc5cxnl3XeHPmkgoZtSp+PIkSEUXH7
	B4kGSzwTNpGBDUnwLKSLsKQ++dqt7qc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jaZmMF8A;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-329e1c8e079so6052181a91.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758716704; x=1759321504; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
        b=jaZmMF8APNynrGqUm/2qln8vamKkLb0vOdgINYqJxBznccxhKLJEHpOtTYE2jZ/DDT
         UQpqjmWnNFswE8KMA2ZS38gFSOGz4KHSU8UjU41nZPUCKkG/pMNn1BBBUnqmO5vA6/M3
         LrR/fBWnuQKnsalCuGrGLvlsiY7SGI2OULxgBw43xEBhZz2yJ1PfGqcrTbV9K2ooKW0T
         5juq6awF5PkPee2d3kggS9Uxo2CBkSoRiogukThatu3hz8qx5hPzpdAmLANEceAGYbzj
         olPhjs2F739oTenYUJskj2b9VPqu4j46WReDxxwXCxnWo9fEPHkcUYP/ETCQNrh5j536
         sV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758716704; x=1759321504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
        b=XuxpwQOWL/zD6UTcCRyMg6QWVp3AlUHm9KRVuFNpz+069CSkwBjjUocUyhhN+Zt6Kl
         KGpHqIYsxOXpToorNwjZTFCd+c/8sjv596vxA1lWg+3eOOaAg6HW2xZ0aRH8c/oo5YY+
         eWRBEB1Rjuw4SESTFvBxqx71VqGIRQz/rWRFS20k5YUVl4STojaSqCtIwQ+6AbdYJGBi
         b9A2MzqCRcaEyvtsUV+zpOZz1QWhGVnC5vrVWPK7iBL/TJJavi76ghs1gHKT92cKwgtX
         12V4AwHu4ZeD3A0jv8Z87TWIkbw2pX6e0pZ4Ax4dkMM8fLBNhyecr7f+gS0ohIHaVyWj
         Mj0Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6rnw4XVYBPwaC20QBlGkXRnTpar8wwcZ/+ISTFFSxGj3Cg/6NbYU8eUv87SwOu81QpYLbHgXS3w==@kvack.org
X-Gm-Message-State: AOJu0YwaPCnBvi9vHLVeub407o04y7Lm6i4Gftopbl99Gp6TPDaIhJOP
	PXbtghZNmGCYEcIM/h52B9qIIgkGPQxHauSH8OO3I/YluQ5WLHXfZmuH
X-Gm-Gg: ASbGncsHFpkKx/lW72PjbbaKG35WPbP7JVbpCJODu3IPxPgnn3M4xGd7JTSq38QjI/s
	/sBHWRjcltG3Z668SWr1w0Yy6yW+1gpF+/WFKSm/5RUUv/JTLCO2J7akxjwcvBKsGQ+lCUbYzzC
	3GQbto4S6+lu2EZSY3epGiQU4Eh9IKf5HUc7gNxusd/DraewOaEWimAQiatXmnWdXpdQgROESlM
	1IKgw2eCq8vLFEtFtJtkTgGfH7pp4SZiU7kigSVLJWSIs+AU0xwVm5vGvlVta3houoZmaSqrLJD
	TyTI2PsGKc3CBnfqi22FJLZEsP3Lgxr3Mpk1UOxIQZx+DK3qwEe15391oxtpMzwMQLXCkMBsStF
	hUNarz2kFo3TKUqAoTCTvBg7DRGa4ywiySQ==
X-Google-Smtp-Source: AGHT+IEamBzCLObwkiGLLGjo5JGU8d4itd/AyRlsHyvnDLGXoFlCi/QE16Hobk/uQUsVbow0Br5ksA==
X-Received: by 2002:a17:90b:380e:b0:32e:d600:4fdb with SMTP id 98e67ed59e1d1-332a95c804cmr7926585a91.18.1758716702994;
        Wed, 24 Sep 2025 05:25:02 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3341bdd63c1sm2285996a91.26.2025.09.24.05.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:25:02 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 07/23] mm/ksw: add HWBP pre-allocation
Date: Wed, 24 Sep 2025 20:24:40 +0800
Message-ID: <20250924122448.9101-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ie317fenyx6no93ii66p3rko1nzuoq13
X-Rspamd-Queue-Id: A2EF8180009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758716705-234314
X-HE-Meta: U2FsdGVkX1/LIB5VdHl83PbIc4bL3l7b/A2QVUG20I1qtIVKkk67o8mse/ZvWymxFyf+cmYBtFPxFMJR50lTqo+6BOicXeaekDnkC5ahGwPlzByMbkRQ1NxbJYvUma7COQ5fE55p/zJWBwePgyToLuCbMTxv8Lhv76HM4A9fimJvrE1df6KRV0y1riwkGHYgAvXQjWwt8UraEuAY7AdGtQzq9v3i5E7QcNCsUQOFyQK5oxEEaifqsGSbQOp+FigjKiHQzgWikh6SVCrVzTPdLosc1fnQK7M5yc9JZQOnBA8ha5uqIBdbmNAKDYkM6oGPpcOwbCqIuLOMHJ/vjOhgLdTlFXu8NClRIC5IIHlpEOmHnTVZsyBMGtN39Ppolyu7GP2Xx6xCiN0UqZ2nG0u4sJAJs5NrDtURzjJoukvZh/7nOned5uAkLmXYGeclndJr4U9MSFENBQ+5Sac2DyXg3P7obmCh3/RuXOLXEhHc6kAol+brX4INNZoWycU+Q7hMH0+vkTaGirv5ESR6QZ9T7IK6RAp3NCgbQXi6tNYetktx5T3P6Y8pNZhrp5OU5Rt5IstVKcFbR67ndQfuOOKmSB29ruupaLFghOS8DIfWH569Mhjr8zR1HD+pxcwsyG+iqAk1IHJeG1B9dN/6W2jEfas71m4sj5Hbcf8gLUVjwtSgUThtOqBNQNx1M9eg/4dOjZvMjiY/L2ruK4CXYWJULoSJp4PvuhZdxX4kA8K3mjIH4WLoEGpasInviAmK7O8xncHf+h7Uf+qwkSojykgDyDZ2w4BBYD9xNSQ5YUr5n695P0Pw85cKBSBgllnRnpjlDdgu3/ogr68YOKETEpHDcIkDz4olHF+kzXZt3bsM/qcnpEeY97A9BbDq9MP0dznnGFQf6FCx67ogLb0Ob7XipNFaaQMIPmPfMLFRdqfsVtLDg/u26tIyPFUXLkkNm2962UhbvzxHZLPSpRZxyX6
 BVDzZpRL
 5d7GAGcO/dHfx4qKWMCRC/YaGLH5p7t/BKyN9Lf6FzOAK601SssIoWYtm/p77167/ot9u6wKjnMbxc+Efot6pGRzTUZPZjIxL4J8p0BGhxw/jxUtftM8hKGmaLfKoEMQ+qhUUG3WAGraZ+WM3lnOaNeq5E6Zb/lFEzWmyVtfXMU4lzu4Xybn0i3BjUktSZd1cJAKSA7MKPvtSmDi6LvzYmNENd36HgY42He6R4KIGJl4GyyUTPCC2S4cU9Hclzkg/tBTebFcgNoke2kLyLw4W7XSFuJuu6WpUvvGO2CkPOiGWaJKTZN+QYnO40UymMFMOSvayGZpGW/4tJ+QNQyqPHxsWT/PS21NVPzN2yeMDy1bJkw7VRvt7JY93o1f7FEjd3nQI9PG9OibNQKOezTYNRvp8zH2f0Rh0cTgERDlRe4caIi9rhm1orjWztChFE5uw1MIQ7dS4z24z78y6DYVQ1dNbuMbqnsajU0Y3j8/ew/qLWUSHKu/GWfkOxc9sUvV/jQj7WdfQ9Em/gmc6I1eBp9WKSSI+HpBhiXZBgpobyF6wIlPAZaOVds8k7/1sxQzbNZVQPyzSEGWr94gpdDLrOAxKiA==
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


