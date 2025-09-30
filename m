Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12E2CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EA58E002E; Mon, 29 Sep 2025 22:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD4D8E0002; Mon, 29 Sep 2025 22:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5AA8E002E; Mon, 29 Sep 2025 22:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16B368E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1E54C0223
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:26 +0000 (UTC)
X-FDA: 83944375452.10.90AEEA0
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E9B01C0006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cUDGg14d;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
	b=YV3svUQf3dNAzVkd6owM9yJiX71Y6SZdRcEdJ4r8q6QIPPZtibuS6c6DvrPP3dwxIgkd4B
	wpE20DVs32ENPsgieb0xp/p89NxECdTMCv6XHiDOPOgpkPwGYiTTtorKiWnDEhEZqD7uLB
	Mvl8ouYDEGUp7b479xMqIeMWrlbB0Fk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200325; a=rsa-sha256;
	cv=none;
	b=CuEi7SgzNgVkW0dH65vGPvFACx1LpShVkHsd9iDhhJbElT/xLmSB84Yj5NHWglESs9IIPa
	tv8MnRDvvqqCTdhcRnLhXCpUynRoi6Alr9gaCLV98UephPEJuF1h36VWMxNAGbxmpf/1kQ
	U35VhwSBQvTU+K/tFVe1Ejz9oR7mnEo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cUDGg14d;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b5526b7c54eso3329374a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200324; x=1759805124; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
        b=cUDGg14dXd+ZxGh17Fn9E0jtzZYPfUDZZKsegs3nKSI/KNOL0DaurH6Xw35vU2CI2H
         ApJMRCfUBaeVa27inhIVgSfONg9MUxflapyBgO52sroMaZItasxulGB0VMRLSlLM+6vX
         tOpuk1Z6EtCf34/yKpxgMPyyXhUJkXJgsgNdUFEqhB7xnYvUSLkYEoMHR79tFxvwvImt
         EwM/7MliXRDR9JUly0tME1mZIP21IGmKodNuoNDTelfyVDzU6ERI4fsr2ul4z5tLMpb6
         bMCagAUaboF/y+g/8EeKrC3NCKJKQWfUrMlQbuCav62wW4Wyl/vPVO3F4I1RwcE8XDpf
         dDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200324; x=1759805124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zjvk/jwcgtCF9TRiT6Fv94jzQiYOsdOhmjAblUevyNs=;
        b=SBdBp7qIFOeGk1jfbcE7lCfMEIpJ/xMTQRWK66dJVc7GDgsFrror9UUa2pWFf3eDFX
         OjuREgWYPRQ1QhDRgwgLyu+D0wSpOuqjfxQ+FHNG27LuzWITUrNCiroW/0N0a0jE4ttC
         KDj+zpu2mtnC70HNu3AsdJaoF6JpHkX1lP8Mg72d3y7rK5JotRdLxEVBh58T7FzbvOhf
         bfW/2+lLnmRjIyWeB/+NOF9E0YpAee78RH7Us5JuaZudZahbTmeMw/zNjhZtv8GLRjMZ
         jSnLt2az85xP3EZT0HIfvyTG2F4Mebs9WZWWp3f9UezCfpI0K7mWB4hdI382ips7TFek
         SlZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUElMoi+MyyuZYWCYqprGD+fAjNN43nObL9HhHx/lSrGvZYQ7v3YMjrLvcmIPZDDItBBEUL3WWeAA==@kvack.org
X-Gm-Message-State: AOJu0Yw7oeXKhw+GW/r+9KQvpu5dAyCqNPkU+DRXM/4avN0V0WmIF8Eh
	AoarWHhK5/5+JZYagGl8lzZKq0m2zDvGUviMHG9x8sfh+9aobmq/nyv3
X-Gm-Gg: ASbGncvU59DaNV2Nq0HS3Q8o3vodPWThVyiVVjYbay3Q93VvHEfdQqInZqtEVWs1Zw9
	M+Bxhoqwdc9YTwdDfMCjmQQ6Gd5F7rld9Ik9kTyN/OdYi92Ft+t7wIUczYjMRUKHV+TzpdmGf8X
	X55U9g2VKHTkQeItR5lqPmArhhZ0VdvsaUgPtS39BO05THQ0t29wNBW0ZmFBEpY+Uce8efOOyl1
	rYJ5HHyZ5EN3JoqcyLHqTkCkVYtx1xEjB9d3W/UIgT0ayiBzECRB0uybnF3mbod4jWMmHto0rho
	qbcHY8csSvxTdgLbO8zdKitBYrrHn9MbxU9uka/Ne4tzfgXN3e4WagfEisX/su2X3qL0kKYKuzL
	XcRHRAOl/AONGK4CP99Z/NFStXQ4+tmJ9jLsDO/+wqoc0IrPqXfKvXTkrJ981e0zsg8Oi34Q0Sw
	9F
X-Google-Smtp-Source: AGHT+IFfp8YXgNuQukwwqsnxDRX708PqLBqQKd9UC8iSffGPe0+X00XIAI7NxbzgZKbYcTueKMe0YQ==
X-Received: by 2002:a17:903:3bc5:b0:27d:6777:2833 with SMTP id d9443c01a7336-27ed4a986c5mr179688865ad.47.1759200323854;
        Mon, 29 Sep 2025 19:45:23 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed68821d3sm145446045ad.83.2025.09.29.19.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:23 -0700 (PDT)
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
Subject: [PATCH v6 12/23] mm/ksw: add entry kprobe and exit fprobe management
Date: Tue, 30 Sep 2025 10:43:33 +0800
Message-ID: <20250930024402.1043776-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E9B01C0006
X-Stat-Signature: ewdkbu6wcbggf3sg7igy7eqi1amh5j8g
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759200324-735167
X-HE-Meta: U2FsdGVkX1/f7fTzj6cuUNhP3PuN4c+C3X7LnEyO9gnkl3OMVrXXFGwBK0KWeWCYnbU7mK7Ex99ezpFUBi7xgWJ7WQcJdItAEexpMo7m4g8f0vL/icR3+1oX15kYmrYcdC/fNRzXasF1FnzA7bhbgRAU7iH2fxBXfbnugzRD5dLRcwMqdublwAREq8a4fcpzaUDyl7IC2p1YVcG9BQrhSuBmAGt0kzFW4XXisetM1yBTZCHr5oEZIAxGoVAnCUuGmxbO3BhWYRz7pctGgEMU6pgCLo+YGBongIQumAPfmyH9wYbmygqwiTqA/oHZSohhmZbLdQ6OlHrFQ9vU2EUGiGDrKvLoWuIM20ysBnn2VJ6ZpNRC5PYWuMdoMDpGW1mnGaR/n/4XtyRlX45WIS82e9rpWxq8tc1jGESjOndYUexZV9+MdNqyh4kY6Lb4JDIxNWXJCT7qG1/vZ6sSqgps/9Mbv/ozVYcT3xouOpeiDl1+9T3QKWvvUug7T/o/rkr1vomDz1p3oEscir3Ni7Kpus0cRj+bePCyHjhjkeDdWTxkmEQLOsbBvHv1ddjMG8n5y/S65Uy6Bw4t4Gb+l8OXBtEIFVcGS0kreaepfSIN9a+kftEWPoqQwLHt4dPJQtUVpNr8pNB5VPOPq2q53OpsaLYVdcSfGP0M4h4/2sfAWM1cEGxfMbUljbb+cwBv031O2rnz+pNoKue4Ii1sNGadpoZaaNyKjz1dWgNQHI5lbWUNnWLsGagrPV3ggjqoLwPSFMajZEGUsPPjn4X8lqNKPBOxg1PQo6KJ0hU5vG6E0LfmEBc+r1QwXQxOSN9EA/ChFUpNh3R0pNPafS5+JY0N1OZovNMgJrl+qjrn8+lxnBbo8J/bTGIAQitJkSsy0z/y5RsewQuMvrfAMF6ViTPfY7dIHJcM8RerJmpakEBoe1kjJfqT2GN09Nh2vlYga1zhqdFGVIQx40ingTvRiz2
 /hTcCaSA
 FPo082kwXyzgHqrn58mluPGn97X5qi0CClkwdfL10xSdL7PesF8NJhYFdpM7EMIII2GPcA7hSEO4mw5jFEIf9hrBAWPYx/RbyKomJh/zFXLGc2RMTUvlaeVDg3EXEMnXez5x//2+S4pp14b8AW7FR2wXQXq7Cam8EsiHNkvW1SuMCVaiwiFxuWyhOWq2uycuW3/hPbe+QmZYvjhm1tnfxyuvy6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide ksw_stack_init() and ksw_stack_exit() to manage entry and exit
probes for the target function from ksw_get_config().

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |   4 ++
 mm/kstackwatch/stack.c       | 101 +++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 850fc2b18a9c..4045890e5652 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -35,6 +35,10 @@ struct ksw_config {
 // singleton, only modified in kernel.c
 const struct ksw_config *ksw_get_config(void);
 
+/* stack management */
+int ksw_stack_init(void);
+void ksw_stack_exit(void);
+
 /* watch management */
 struct ksw_watchpoint {
 	struct perf_event *__percpu *event;
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index cec594032515..9f59f41d954c 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1 +1,102 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/atomic.h>
+#include <linux/fprobe.h>
+#include <linux/kprobes.h>
+#include <linux/kstackwatch_types.h>
+#include <linux/printk.h>
+
+#include "kstackwatch.h"
+
+static struct kprobe entry_probe;
+static struct fprobe exit_probe;
+
+static int ksw_stack_prepare_watch(struct pt_regs *regs,
+				   const struct ksw_config *config,
+				   ulong *watch_addr, u16 *watch_len)
+{
+	/* implement logic will be added in following patches */
+	*watch_addr = 0;
+	*watch_len = 0;
+	return 0;
+}
+
+static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
+				    unsigned long flags)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+	ulong watch_addr;
+	u16 watch_len;
+	int ret;
+
+	ret = ksw_watch_get(&ctx->wp);
+	if (ret)
+		return;
+
+	ret = ksw_stack_prepare_watch(regs, ksw_get_config(), &watch_addr,
+				      &watch_len);
+	if (ret) {
+		ksw_watch_off(ctx->wp);
+		ctx->wp = NULL;
+		pr_err("failed to prepare watch target: %d\n", ret);
+		return;
+	}
+
+	ret = ksw_watch_on(ctx->wp, watch_addr, watch_len);
+	if (ret) {
+		pr_err("failed to watch on depth:%d addr:0x%lx len:%u %d\n",
+		       ksw_get_config()->depth, watch_addr, watch_len, ret);
+		return;
+	}
+
+}
+
+static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
+				   unsigned long ret_ip,
+				   struct ftrace_regs *regs, void *data)
+{
+	struct ksw_ctx *ctx = &current->ksw_ctx;
+
+
+	if (ctx->wp) {
+		ksw_watch_off(ctx->wp);
+		ctx->wp = NULL;
+		ctx->sp = 0;
+	}
+}
+
+int ksw_stack_init(void)
+{
+	int ret;
+	char *symbuf = NULL;
+
+	memset(&entry_probe, 0, sizeof(entry_probe));
+	entry_probe.symbol_name = ksw_get_config()->func_name;
+	entry_probe.offset = ksw_get_config()->func_offset;
+	entry_probe.post_handler = ksw_stack_entry_handler;
+	ret = register_kprobe(&entry_probe);
+	if (ret) {
+		pr_err("failed to register kprobe ret %d\n", ret);
+		return ret;
+	}
+
+	memset(&exit_probe, 0, sizeof(exit_probe));
+	exit_probe.exit_handler = ksw_stack_exit_handler;
+	symbuf = (char *)ksw_get_config()->func_name;
+
+	ret = register_fprobe_syms(&exit_probe, (const char **)&symbuf, 1);
+	if (ret < 0) {
+		pr_err("failed to register fprobe ret %d\n", ret);
+		unregister_kprobe(&entry_probe);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ksw_stack_exit(void)
+{
+	unregister_fprobe(&exit_probe);
+	unregister_kprobe(&entry_probe);
+}
-- 
2.43.0


