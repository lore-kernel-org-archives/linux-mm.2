Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63FCCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26026B0095; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6096B0096; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13BB6B0098; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 942C76B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 125AC160BAF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:53 +0000 (UTC)
X-FDA: 85317514506.24.525CC48
Received: from mail-m16023653234.xmail.ntesmail.com (mail-m16023653234.xmail.ntesmail.com [160.236.53.234])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16FCC160006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.234 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOJ6nCm+Yvbx+lE4NvbGcmI2zQ+fYrupQ8q+SeRfQDo=;
	b=byKpyBw28X1YUUAHq/l0mZOQ6DKfxiiYOqV5eQhJvE1YTnGWrnbH9D14fvh/wOka1lzEcu
	YF2ElU1rvwSfVh6IG0AvpxZ1qs/oSrNWHw8D4zQa2wB1fw4Bdhb1F8424qLaGiRSRnuRFz
	7Q/Ykp8kQ5GzBpOsPpGWBepgkKZ+wyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894111;
	b=L1vDvrP+A5le764ExSOES+1aPNRUU2lYPUcC9TC9X/mtnCt3VFPCpcDmOlKyg02y4dn/O6
	yO7AYPd4YoBH3JYFZT0WWgOYc7e62RLgOoxeIl3rY7rGpw9+F1gzrzglYAlxM/87zsSuTN
	xu37W66Fe5qknOtRB9923rN+x0hszgo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.234 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407eed;
	Tue, 13 Oct 2026 20:21:44 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v2 2/6] mm/page_owner: add bpf_iter target "page_owner"
Date: Tue, 13 Oct 2026 20:21:21 +0800
Message-Id: <20261013122125.843451-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa135362adc0229kunm0bc94a6a5251
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQ0tCVh1LTU8ZSx8ZHklKT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16FCC160006
X-Rspam-User: 
X-Stat-Signature: 5r6eqcp5rp75593ocz837omrx8ejamqf
X-HE-Tag: 1791894109-23993
X-HE-Meta: U2FsdGVkX19dSWSTvGV5HmgZbADlwzuFgaZKOHZSUKwbesbLrQ57hZNXUDYEV2SjRSLW5DPo+TZvS6VVJer1bPN0AV3SJWcHuPuv18hZ979imxvK/VNxmdJaASJETTQEc7JXo2Nh76sb93aYL97waIW92+HUoFesonHQGoxHpkCDEEWJaXGrssMMZs7kbT/AbJDpJ0xdilbH3qLCPeTnQu8AJCDBvYOpp2CTTrwLf7mwElMHTAnIgiAfeZ2A7Qg0VzhdYNqLqS/1P1Qg7beMufOp1j8V/Ec3ngLIcqVxiLCUedXbAgNwIY13NuXnksfF6KAJ7Woumd/9/lp33t2Zbq624Iv1CFL/BOXuAg4p0gTXQsQjQb9TF9+q7CC96hap5ZWTf2NnTCIanFwdm7kcvl8d4tbsP3iUxHa/qvrJ0menUWTfB/xsQ8dThYQ1SI58AzkVbDbeVj6RjgJrmNe4ZML9ULTNPov5nTQ4UY99UYiJGXN4424nYJUOMmjBz3Kq8BhIGOzRI76Eemn/xz7QKPC0tPLvtyA1Naz9pUVKdLYnNiQls/LeVu06ITb4RZlnHgQvpUfIvrKgW2rdm6JP0mVlCu5982JJhxZ4hZGO1icGGDTRKwtz0u1kec6b0jxhNJCw5zUCZq74wK2Ghj7FMtk4B6+7xGuu3EWISyYDQfYVMXG2qhdU/Mhxauo++sAfKEV9NhaTXSFvaJhxdbdz2/SBFC7VMpmEQDuWIS02gU5wEV4XczgkvFWsgalqxSpN/xR/2QZ8fIlHg6E4KH3LHzHe0mF4X8uIiUoMFjVYl39xg10cLCUCUqCF5EYcQiWDk+7ERYPvdeZwUshLZIBI7HWJAn+TisFaHErOXseuUUzewmJ8Fd8KC2tX5sbdG8vLqI8xp6e89I3YLJ5XhgVYX+vCcy7xKFHBHKQluWytxeO+V008YdOVXWWBd3rM6rzt0g2pzSHHoHOmIUn05Ay
 pd6LZTEJ
 kvW5+2kZ+JfDAyU7TGOsXxbO1UASYzdUJy/25g7KGc3i/YI9FHxTTzOqv/6zZEu+5HWmaGA3XtmR168SwjRudJy952LupTqBog7MxlOW3FnkkDu6eRa7oFimeYCBtVF1ulBG8x9nBRNOSWEaObKKjy5kwBbjqCuATOXDdshaifb3/8Io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register a bpf_iter target "page_owner" that walks the pages eligible
for page_owner output, with the same eligibility rules as the
/sys/kernel/debug/page_owner read path.

For each eligible page the attached BPF program receives the pfn, the
page and the page_owner record, and can freely filter and format output.

The po_snap record in the scan cursor is taken inside the page_ext
RCU window and handed to the BPF program as a copy, so no RCU window
is needed at consumption time. Torn reads remain possible if the
record is concurrently updated while it is copied, but this is the
same best-effort behavior as the read path has always had.

The target is registered from pageowner_init() when both
CONFIG_PAGE_OWNER and CONFIG_BPF_SYSCALL are enabled; a registration
failure only disables the bpf_iter target.

Userspace tools such as bpftrace can attach to this target like any
other bpf_iter. For example, to count pages owned by init (pid 1):

    bpftrace -e 'iter:page_owner / ctx->po->pid == 1 / { @ = count(); }'

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v2:
- Drop the scan->pfn++.
- Fill page/po/pfn only when v is non-NULL.
- Implement page_owner_seq_stop().

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-3-zhen.ni@easystack.cn/
---
 mm/Makefile          |   3 ++
 mm/page_owner.c      |  33 +++---------
 mm/page_owner.h      |  48 +++++++++++++++++
 mm/page_owner_iter.c | 124 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 182 insertions(+), 26 deletions(-)
 create mode 100644 mm/page_owner.h
 create mode 100644 mm/page_owner_iter.c

diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..d7307b5a964c 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -115,6 +115,9 @@ obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_RODATA_TEST) += rodata_test.o
 obj-$(CONFIG_DEBUG_VM_PGTABLE) += debug_vm_pgtable.o
 obj-$(CONFIG_PAGE_OWNER) += page_owner.o
+ifdef CONFIG_BPF_SYSCALL
+obj-$(CONFIG_PAGE_OWNER) += page_owner_iter.o
+endif
 obj-$(CONFIG_MEMORY_ISOLATION) += page_isolation.o
 obj-$(CONFIG_ZSMALLOC)	+= zsmalloc.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 56c75a669a6b..617346a4ab22 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -14,6 +14,7 @@
 #include <linux/sched/clock.h>
 
 #include "page_alloc.h"
+#include "page_owner.h"
 
 /*
  * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
@@ -21,31 +22,6 @@
  */
 #define PAGE_OWNER_STACK_DEPTH (16)
 
-struct page_owner {
-	unsigned short order;
-	short last_migrate_reason;
-	gfp_t gfp_mask;
-	depot_stack_handle_t handle;
-	depot_stack_handle_t free_handle;
-	u64 ts_nsec;
-	u64 free_ts_nsec;
-	char comm[TASK_COMM_LEN];
-	pid_t pid;
-	pid_t tgid;
-	pid_t free_pid;
-	pid_t free_tgid;
-};
-
-/*
- * Cursor and per-page result of page_owner_next_eligible().
- */
-struct page_owner_scan {
-	/* resume point */
-	unsigned long pfn;
-	struct page *page;
-	struct page_owner po_snap;
-};
-
 struct stack {
 	struct stack_record *stack_record;
 	struct stack *next;
@@ -741,7 +717,7 @@ void __dump_page_owner(const struct page *page)
  * must advance scan->pfn past the hit before calling again to resume
  * the scan.
  */
-static bool page_owner_next_eligible(struct page_owner_scan *scan)
+bool page_owner_next_eligible(struct page_owner_scan *scan)
 {
 	unsigned long pfn = scan->pfn;
 
@@ -1196,6 +1172,11 @@ static int __init pageowner_init(void)
 			    &stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &threshold_fops);
+
+#ifdef CONFIG_BPF_SYSCALL
+	if (page_owner_iter_register())
+		pr_warn("page_owner: failed to register bpf_iter target\n");
+#endif
 	return 0;
 }
 late_initcall(pageowner_init)
diff --git a/mm/page_owner.h b/mm/page_owner.h
new file mode 100644
index 000000000000..fda83be69275
--- /dev/null
+++ b/mm/page_owner.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * mm/ internal page_owner and page_owner_iter declarations
+ */
+
+#ifndef __MM_PAGE_OWNER_H
+#define __MM_PAGE_OWNER_H
+
+#include <linux/page_ext.h>
+#include <linux/sched.h>
+#include <linux/stackdepot.h>
+
+/*
+ * mm/page_owner.c
+ */
+struct page_owner {
+	unsigned short order;
+	short last_migrate_reason;
+	gfp_t gfp_mask;
+	depot_stack_handle_t handle;
+	depot_stack_handle_t free_handle;
+	u64 ts_nsec;
+	u64 free_ts_nsec;
+	char comm[TASK_COMM_LEN];
+	pid_t pid;
+	pid_t tgid;
+	pid_t free_pid;
+	pid_t free_tgid;
+};
+
+/*
+ * Cursor and per-page result of page_owner_next_eligible().
+ */
+struct page_owner_scan {
+	/* resume point */
+	unsigned long pfn;
+	struct page *page;
+	struct page_owner po_snap;
+};
+
+bool page_owner_next_eligible(struct page_owner_scan *scan);
+
+/*
+ * mm/page_owner_iter.c
+ */
+int page_owner_iter_register(void);
+
+#endif /* __MM_PAGE_OWNER_H */
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
new file mode 100644
index 000000000000..938cb42ab7d7
--- /dev/null
+++ b/mm/page_owner_iter.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+
+#include "page_owner.h"
+
+struct bpf_iter__page_owner {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct page *, page);
+	__bpf_md_ptr(struct page_owner *, po);
+	u64 pfn;
+};
+
+DEFINE_BPF_ITER_FUNC(page_owner, struct bpf_iter_meta *meta,
+		     struct page *page, struct page_owner *po, u64 pfn)
+
+static void *page_owner_seq_start(struct seq_file *seq, loff_t *posp)
+{
+	struct page_owner_scan *scan = seq->private;
+
+	if (*posp == 0)
+		scan->pfn = min_low_pfn;
+
+	if (!page_owner_next_eligible(scan))
+		return NULL;
+	return scan->page;
+}
+
+static void *page_owner_seq_next(struct seq_file *seq, void *v, loff_t *posp)
+{
+	struct page_owner_scan *scan = seq->private;
+
+	++*posp;
+	scan->pfn++;
+	if (!page_owner_next_eligible(scan))
+		return NULL;
+
+	return scan->page;
+}
+
+static int page_owner_prog_seq_show(struct bpf_prog *prog,
+				    struct bpf_iter_meta *meta, void *v)
+{
+	struct page_owner_scan *scan = meta->seq->private;
+	struct bpf_iter__page_owner ctx = {};
+
+	ctx.meta = meta;
+	if (v) {
+		ctx.page = (struct page *)v;
+		/* @po: hit-time snapshot, no RCU window needed. */
+		ctx.po = &scan->po_snap;
+		ctx.pfn = scan->pfn;
+	}
+
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int page_owner_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq = seq;
+	prog = bpf_iter_get_info(&meta, false);
+	if (!prog)
+		return 0;
+
+	return page_owner_prog_seq_show(prog, &meta, v);
+}
+
+static void page_owner_seq_stop(struct seq_file *seq, void *v)
+{
+	if (!v) {
+		struct bpf_iter_meta meta = { .seq = seq };
+		struct bpf_prog *prog;
+
+		prog = bpf_iter_get_info(&meta, true);
+		if (prog)
+			page_owner_prog_seq_show(prog, &meta, NULL);
+	}
+}
+
+static const struct seq_operations page_owner_iter_seq_ops = {
+	.start	= page_owner_seq_start,
+	.next	= page_owner_seq_next,
+	.stop	= page_owner_seq_stop,
+	.show	= page_owner_seq_show,
+};
+
+static const struct bpf_iter_seq_info page_owner_iter_seq_info = {
+	.seq_ops		= &page_owner_iter_seq_ops,
+	.init_seq_private	= NULL,
+	.fini_seq_private	= NULL,
+	.seq_priv_size		= sizeof(struct page_owner_scan),
+};
+
+static struct bpf_iter_reg page_owner_iter_reg_info = {
+	.target			= "page_owner",
+	.ctx_arg_info_size	= 2,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__page_owner, page),
+		  PTR_TO_BTF_ID_OR_NULL },
+		{ offsetof(struct bpf_iter__page_owner, po),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		= &page_owner_iter_seq_info,
+};
+
+BTF_ID_LIST(page_owner_btf_ids)
+BTF_ID(struct, page)
+BTF_ID(struct, page_owner)
+
+int page_owner_iter_register(void)
+{
+	page_owner_iter_reg_info.ctx_arg_info[0].btf_id =
+		page_owner_btf_ids[0];
+	page_owner_iter_reg_info.ctx_arg_info[1].btf_id =
+		page_owner_btf_ids[1];
+
+	return bpf_iter_reg_target(&page_owner_iter_reg_info);
+}
-- 
2.20.1


