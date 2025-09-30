Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A90ACAC5BD
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E108E0029; Mon, 29 Sep 2025 22:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE498E0002; Mon, 29 Sep 2025 22:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7D18E0029; Mon, 29 Sep 2025 22:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65D238E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:44:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E4E11A03B6
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:59 +0000 (UTC)
X-FDA: 83944374318.20.5B21579
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 349B14000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:44:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ReZj0bT2;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
	b=RRzQBqXf9Y9/hThy5Ixb5FVzLFXkfNyQ/QKGK7WVh9s/hmv2dl4YqA+BJPiXIhPTmVHcC/
	TeCERHZp4zChCAIauwZ3pl/ROEG6tIm8+7rNVl++unU0QJfyUiP1o+1dl+lDDk7BSuN7f9
	Qzz1drO7g95SECdIt9cbP/cLII3vtF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200297; a=rsa-sha256;
	cv=none;
	b=PQow2SSac4DF0oIUnMqG/NtkplUt8+BnrtJQCha4UXLASZ26rRDlJGf1PPFurQT8e1M7ow
	Sa0XEffOyu9Jea8jJ+S3fBXxLaIfBeKcsDEXXFDyb/ldMT/qGcn2N8p7hPNw49aTuX0FCV
	9DFEfp7lvGLpHBgunuCv1QSRZVmETEs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ReZj0bT2;
	spf=pass (imf27.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b55562f3130so3778039a12.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200296; x=1759805096; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
        b=ReZj0bT2jfuQG6KR6rm1LcAeqX2NgAMuMF29Eo5w/Z8Ra3e/kN4UkMDoF7nDTwUXZY
         PbO9vTmTLsO6fREAiQg1aZVy4K6mpKAk1s3pu1ZPdtaBpSBZwZDFtbs1aLJyk3x/Cx64
         FU9M74f6G9EVs1pfvfw86SRJnpjTS0F+Ng7SSMkBTh8kXj+hoo7Q0J+GHk3Tk4Lnze1Q
         Z3fKmTonsZzviSrNx/4YDwAVn/PJ/I+MChVcVswT2Kwg1iS8GagRLHlFIZeyZKEX2z6o
         HkeqhhCpWD+OlUdBV9NVkmKih8U2gFCSkVM3/ue6pJ8lrH3nEA0G+HgBDrCQ7ezgXhMS
         fE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200296; x=1759805096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NW3rnfkFZjd7Zh69vJKiLybxjQ5f/0P49rVAWgM4UU=;
        b=Yb1ROkBcJP4231xW0jrmvRn89V0J2VidpYAPJhK3dxM5bUOIzTWhqJVws3R9n6SpP7
         0QKlbX68rDkGDE2UQ6PNeN6BRxShHxQ5PNsjC7XKA2iRdlImjC4uDNKDA0v3k4BTS2hx
         RiOfuGYdm4m5z7wBC7C7TA8TSRdahYyfbPPTNv7QYijyuBPGSXd2Y+54Nup28Jz9Rjc6
         zL+uMJpdz/6xO22yUeHlh1OctBXtyt2oNm7fx9uEzjkK4P78+N4RfQM9LfcU2Reo3rGe
         1c8rFaGGRpgJ+YmhJ5i+kfrueB3GKNYLIXsMKQtVyYyy1ksaUm8bUvhD3mq6zkQlUThm
         57BA==
X-Forwarded-Encrypted: i=1; AJvYcCWJVaAQTvU0h7fAx76QD+wqxKlsXMkGfZtoY0vcpMosm+AZeCgEzEMrjfPkw+oA2sKJDvdgPcP5BQ==@kvack.org
X-Gm-Message-State: AOJu0YxhwaXQM2bHCo9FVZsp10q4b5Hb39/4mUfKFlexGeBkJB8ds7Yy
	8SAv3s8FN5QU2LVWE6f2M83b69J0hWjtg37ziieEc3R5ratBDeT5Lu1E
X-Gm-Gg: ASbGncuPA9UoqDPxtj+PbSsYjF5QT3EzwSz0v1SFvWaXvhs1HCs1R4kO6xVhEtwJPKJ
	gMpraHY3VPdg29cyZ/Gqpm+PjUOGIS55jcmDeHZfFjiT8AIatO7RexSiCHlbYF+FEwH8Df6FfFF
	p2IVtrlqYLw/+ZZP6/2IR2UH1fgPOQf9qxTKL86YTDOcLwvkCm6ozsRUr6LWmbvD20lgoQm46Yj
	6UWv4b5hVLrmhdfJ2Pv/ZgcNY7c3T+Quagu64YVx/5tztoXU7R3GyTYNxdNK6TCoDBuU+461aA/
	pdhonYSRWydUaR7P7ISrEv/XJsXVglFoLtOJq/hz+sKuYVU1BFBwnnSg0tPPff5bigdROfWBVT+
	Hld3jF1HMDiJptskMZ116uhYd6JvfIA3nlg7NUujBoLRITXpivS71tk1Z2SkvCsp3hQ==
X-Google-Smtp-Source: AGHT+IH29Thtb5D6YkJakO5t9BTsEfGfbuz5XXYNk5kI0v7F6fpI1sv279aA08He56DkC5ZrjPjoLw==
X-Received: by 2002:a17:902:e54a:b0:270:b6d5:f001 with SMTP id d9443c01a7336-27ed4a0d542mr209110885ad.23.1759200295846;
        Mon, 29 Sep 2025 19:44:55 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed69952b3sm145098075ad.96.2025.09.29.19.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:44:55 -0700 (PDT)
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
Subject: [PATCH v6 07/23] mm/ksw: add HWBP pre-allocation
Date: Tue, 30 Sep 2025 10:43:28 +0800
Message-ID: <20250930024402.1043776-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i6uixw9gwxnt4mkmdedkeofsw7p6y4pn
X-Rspamd-Queue-Id: 349B14000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759200296-206148
X-HE-Meta: U2FsdGVkX1+LsApvJFSOVL2Vcx0iwfY86jciYazJCFwzLUUX7TFhGmLdNwn5Qyw3lsDKFxhLbou76AAcnbCqEU6Gc5yLNAaMolRqMCAXaLZAm7j0FgLl632UT6IyBcVygeTgS7ovziB3e6AgudflvP9VV/PjY0uhFqyGeq+Nh6gLeurssMNhk2/khw/GzwfBJ07OyQaId+y+sZ3qSFf10lRftYiqEC/vkG6tQn2+EMYMAAaQ10xomBOSODGHXCol0qYTUIeZurpappXNpVwTpBIeYJjuxAPzWiPO6XadaK/9IXNW6bGLqFlBsWo4hnIaWCgt2Nayd1YZaQtaedijfueC30pzx37Q/wXKgsnrNQV6tJVCID5ThsqbpyZicA/EJPKZtq7vUrMIc8tY/OyPqvyAWQ/oeCsrE75EFC3cPrX+J9ZQqEpkNjzHFuDA9XHbKiWwiMOfsscSqzZ66z0VNCEFxtnZh0b6uOnrPxx+VSGrQL/U53LMlTFulG8N72TacltOJl+ARDMp044PUpZl17P7UFHUXd6QWYcaqHBvIDRLcpuVKdsxeWizByDmII/Gp+aGKdOXvhca3qAowf38RJmM0O6QLBQiqJ1UCRowwx3au1HsNBiWqmev+beaD7wDHTo7wh9T3HFittpZcWFKoQErdd5SuIzxrR6gDeyTH4bVPG8TNaHRk4G59elXxXYVj8+SpkwWmFELldruyKr6dNDLcYCZGAbc+Ra35QIBaHaTRUVhQka/zdIH3Kh4zWFnqmRD8iSf/FDSaf0jvLvn2Kt5qUlKbTPAy1j+aiPdmI1BfFuKaJBXSzp7WS0kpjQB6ZK7DudkvbEQKPBpi5IM64N3SmM3yIS9fjnBGy7VCGWX30foKoCXDNFuKUSGqnK/6KRj463ToZK/Qp6XYt4BXL2Mp/mkkByjQ3W5n2Qcgpbb5viNsaoCMmA3x27H3945tRlZZTEGoWqwMx8cBhU
 Ux6zckeh
 OmFGHuL4gTasXZ906oVbUyn/lkgpl27BJYHRPQzM5MbRbQ5UhpWxER4kdjJGOfcnU0NVmKc85n5EiAGuiIejqcAhR04r19dwE1H9XED4/Qb0drd76JtIQA8ksElnUkVc7lh8tJzP4lm1KbIs+jSaziaaho9J7sqLlWTAIQ5/8MQdtytxZ99hQwSHttd6Zit0cQVtaR8G4jJLb8Nk/BirARfij+0WvQYLiT+5+uixKc/vH8zclTYxYHfot19+yzBdqhzkdlMzEociQeyupb9LPTBjmNbJejcEDSeVxYTHcIbJI8JWy3Z91ROM7Wg6IEtbmmNW5EpY0AN5exCbGgYD0DSPjbaRTUG9bwF3Y1oEif6odvYCV0Y/MnUrWy2UuLbbNPrI/dKg06b7uaYQgi5ouPP6FODlsWZKt1cw/K+Sy927qLBOfOgxR4b40n4yUjdg5ibhi/2f1whsFwj3yb8IzbdDjfnGKxTAomjLs3yxl9H1V5QZ6BV8Kq7ym/IHTkRo6YGu4yBvGeCXvqOd4KZv0JawRy0AhQhmyh2V0ptfVs5JWz81dxrHobayI/rcVHEUabeiuRg4GNGgO/pYk3OAMDeP2/Q==
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


