Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E147DCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5778E0040; Mon, 10 Nov 2025 11:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D278E0003; Mon, 10 Nov 2025 11:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C378E0040; Mon, 10 Nov 2025 11:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 250658E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:37:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE32313890B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:15 +0000 (UTC)
X-FDA: 84095252430.24.C76B7C3
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06ABB4000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f8vz7NFh;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfQWKEWM8M6Sp/kqVVWTo1Q3rJtTZ9aAiY0lp7l1vgw=;
	b=VM3JgSKQM2P9jhkXnHHb7XITsOxbPftW3peVqm/Hc+DdjVCRPg1BYv3AiaQ7jnqrjI4jwr
	nUg/bKpVhasnP4HCio6s5pfVGqNSybU1eEffRtETZRNHNntV16LeksFJN4SK55EDiNCmv4
	fvQ45PTspbLHqGkz5TU/jcEqr3rMIGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792634; a=rsa-sha256;
	cv=none;
	b=aOHhP1ndsgqwFyj7qlXwyZgdVIgBU+T8ZgCuTUIkrVjMxAXB+aslr3psjWr9j8z++Ru8ld
	jZ0tAAu1ZKmZjPu4pfBbIhufegBsnJPHphBzaK7PU7avfQIjr0OssqjEEfP2sxxyMecQ5L
	7aK7IuMJT9B1YCNMl67TxhGgji5hxkY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f8vz7NFh;
	spf=pass (imf01.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso2413034b3a.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792633; x=1763397433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OfQWKEWM8M6Sp/kqVVWTo1Q3rJtTZ9aAiY0lp7l1vgw=;
        b=f8vz7NFhKNePabMSewsASX2NJDrNea+zyqP5Z8AOOcHsSnbxbnXIwOpmzKBntm90BA
         E3AT3lAaplJQMaZpzocww874bpH7nTBW0CZqNukkIsuhpip8JzBQX13oSIusHsog3QeM
         zsm5IJGeU5dThfCFs1gqpkkGLaFw5MbYWzRVSFMt1WGxDA2hkofPtQCKj9D+eo+bOvJc
         TGFGnSwY+KFeKoxPbpTAIK4XpZNi9kBZk3m8OQbCWytnF2UhbpLZj04dLr51UWlEuKPa
         r1KWmm+E1ayX0PoNhQmB/TQ/sOKvDXJF1kafRj5prQ3xkfks1LG12Hdmpz91xX//SlQl
         tgvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792633; x=1763397433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OfQWKEWM8M6Sp/kqVVWTo1Q3rJtTZ9aAiY0lp7l1vgw=;
        b=smbFbFCI4Eu+SqhgOREINVMBsjEtf54ZY7nBU/x4IiIK4U2UWgKfRVeZIxUVC80HZ9
         L1JyiDQ1oCnkPxyDhiJSoIKEtviafFlHUyAQzoSLQJuzxbd2PH3nwMcWwUJ2l+8b3JXL
         xvfoahXpym74BRypz5dYEIlV/CHnapD+fA7ZmtYLKG9mC4+wgcRNadvdMk5wOIo3iJGK
         JQBY94AjXhqU1/2/fqD1+qksIcx2ewmUWpa3tkEvYeSU8McmjaWc2SZ628lctGqtC/03
         CP7QKq4f40XSx6C3x9zL2G6E1i0gDE6/Pz74RAZaffyQV/lv57/T9+233y93+0CBGKdc
         NRkg==
X-Forwarded-Encrypted: i=1; AJvYcCWWooGormPLL7vgxK10Xj/Fz/K0ioPIa66gDN0/fGw6rrZlcpOfNoxc8VUzfrC702Xb/RsTYaU5PA==@kvack.org
X-Gm-Message-State: AOJu0Yxps1IbqJwUedG8mKBa8g7zaj+liZkbJVP1Qd1do8OucAGS1v5h
	YroCuiT1Z8/Le7qtLiccBhBSGK9s8k9n5/sl6zlehtqxkS0sS+ga7YAS
X-Gm-Gg: ASbGncsB8q8+YRlqXbo2FjlSQBh0fdbt2y1FvTk26NEslxxmLOdZCZIATScvRIaeZrO
	w9+9WlK9IAAMrXyRdjU4BGXZ8HGUk746enku00eWZqB3t5/eFyHB72mmX4vKkvDr5zyh9XpxeTX
	onXkkbBTMs/a2n3wBP2lwUNO5ljgdW4EazkinJIsVO1bFkOe7NvOYwbQ7LnNL+0IyLUzRSOjwEd
	jQxRnupNVEir4UZs8oWRVx+ry/8avEhTFWyJAOT+72aEQKYbTNkxn9gUGD2KtPGOyfrKvn+Eaih
	Vq0OpWL0WEl7fM1jn0K3/+ewjI+QCqAUKup4PB5Ma5X26z7Xg0aBw2JjWO1l3KKfMxOqMoB/0T9
	G3TVyYlnIg7eDle7cqprZXu9RUJFHmi802SG73Ea7Y+7es0IamiND43w+Ezel6SYcm7s9b/8VNP
	bUZjed/ZWMA2qI9jir09YgBQ==
X-Google-Smtp-Source: AGHT+IHERHOBNDq56+F7J5rW3t9aw2ypcpu6OwOvG+DJGpa6Vz1ez0X0Vnm2nUUH/tERSMimjoOmZw==
X-Received: by 2002:a05:6a20:5483:b0:342:873d:7e62 with SMTP id adf61e73a8af0-353a2d42046mr10346355637.29.1762792632699;
        Mon, 10 Nov 2025 08:37:12 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17784bsm12559855b3a.47.2025.11.10.08.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:37:12 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 07/27] mm/ksw: add HWBP pre-allocation
Date: Tue, 11 Nov 2025 00:36:02 +0800
Message-ID: <20251110163634.3686676-8-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 06ABB4000E
X-Stat-Signature: 8uysxw4icu4p4d7ju9kffzotsndedkc6
X-HE-Tag: 1762792633-851767
X-HE-Meta: U2FsdGVkX19K9lrU5t8UsK1gomya05pmUxWMuKr/WnUYLV+RJYYQoqaZb+dDpb3aRXEdrh5DuQCuXBw/VsARl6VS8dVa4B9SzQwkLmc+6ZJ6Fku0StMikFs904ka50VqR6L6Eh9yFT4noiXNmpbd9soWT+nLXJhIRt9ZG4KKoOB4LckDqNxeWbwxdWxGdNRiawquXRB0r5lqeBSXIUp5qEmOBb/dyBhNUgL7ue3scNjsdFpBF/260t1VaSLcXI//uPEDYbQcoaJ69wq/QH6AswW+ts/w2Y3dxQuwRnIUMHKWRIEMyPPuEDSBATwvbpA3B1JupSdO16e3fJc90hqdLvVJWNd7l4lJVMUZCOLjvUvZGzQaBWHO7bUxpm+NYP3iWICQv2YYxmRHpoIyDfk29jKjG3yqLjLop67faVIMhpzlMN0To0LmBwC2YRVGUEaTHKihfcKNtKbXocfj14ID1HIQ3M596Xn9AKXcxpkOVRk0r4bBou2ya5bnzCIfruZJoUMa7Vo8VuwVQprASUMqcqYnyj/CWt23uTzs5LYJfd5ztKM2chC3+5lebqLQz/BMeQgLrWIYYocWCnDxJUqdVzTbzhdFo0oHagIsjsP0FzHZnbQeRa5LbLZAmAS1IfgihjCyfSC6vjFWJK1I5VxRK/CACSj/p9y+BZYl2FJeMVyZ5jS2T9YpwQv4G0h+cKvDIcMqYzlq7cAwCIqx2J1lOCwOvL75Ei89WVP4ZkyJ76OWMDtg+0m4EPQovd8iOrZnR/jjk0da9ozpFYw8pStrjaspAmXk1vNM2VoX4Fa/vM2kEiFwHSxmY/us547iU73ks+VXzz4E7VJ8yCshzf3btYR0OZVapiJAyTcE98QqiRDUnTQ0F2/MY8eMtRi++f7uJdd3LO1bIEksDzdKCYlS5rRrZ+a/Lh/zy9QD12F5IQw8XMGTHOKYbD2r1U85Ceuf/9irOJpT51ODgs9+Wd4
 eXWULPes
 8WfuKtHb7UoU5cleoaIl3Y5+UjZzRgYxV5dL6PyMMLNkkHeKdk8AuWxLj0nQduMD8rYN4MWP1itkBrq043D0EUEglkTKF88f460Qjpm/6Z+z0TMVjc8GACGHCGWZwnzGgYmn1D6cqoWAhkKfX8PHdy56qY1Glr/P2700FuUbr2qoFAstLL0V/XTgjGwajbVlzsxoLpbj+2Jfp9lg1h+2XsF3mB1IjcHsaZYqYEfJpNSfP9AbtZeIhXJF7VDDcIpLEXOlJG+hdMijzHsmKiXdDYnQMM2bHtLUsHlBmuwSGd9ygf0InCtBp9/TqcpO4vwDQvMJE1yobGEuxFm2eLzeOPxBmC2yM31V/G7cdqzZW+iBSgcKEUDnHdhgkAXkV9KEd8I8ZQn9LQRIpt7wG7Eu4RnuJ5swk3qAFLnkS5PsyWrIFagV8sC2Wsv7ospz3yFx7T+lpodid/cW6DrkA5sLeienqw/EaDFS0d4/ie3gSlIKCxI/8zJUiEWrBSoAOSGOr/dFrY9Mj33vEcvrrb8Y2OP6+uKZk3vfLdsFS+FMLLk5zM7WSeoeBMdfxNr1Rg8dDxv7SlxnP6cNS88Ipxw7VP8wCVA==
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
 include/linux/kstackwatch.h | 13 ++++++
 mm/kstackwatch/watch.c      | 93 +++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/include/linux/kstackwatch.h b/include/linux/kstackwatch.h
index ada5ac64190c..eb9f2b4f2109 100644
--- a/include/linux/kstackwatch.h
+++ b/include/linux/kstackwatch.h
@@ -2,6 +2,9 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/llist.h>
+#include <linux/percpu.h>
+#include <linux/perf_event.h>
 #include <linux/types.h>
 
 #define MAX_CONFIG_STR_LEN 128
@@ -38,4 +41,14 @@ struct ksw_config {
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
index cec594032515..4947eac32c61 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -1 +1,94 @@
 // SPDX-License-Identifier: GPL-2.0
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/cpuhotplug.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/irqflags.h>
+#include <linux/kstackwatch.h>
+#include <linux/mutex.h>
+#include <linux/printk.h>
+
+static LLIST_HEAD(free_wp_list);
+static LIST_HEAD(all_wp_list);
+static DEFINE_MUTEX(all_wp_mutex);
+
+static ulong holder;
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
+	if (ksw_get_config()->panic_hit)
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


