Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FFF60A2625
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1BA6B06C3; Wed, 21 Oct 2026 07:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370FE6B06C4; Wed, 21 Oct 2026 07:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAC86B06C6; Wed, 21 Oct 2026 07:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DABD36B06C3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:25:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7F6C804F9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:59 +0000 (UTC)
X-FDA: 85346401518.08.BC14427
Received: from mail-m128248.netease.com (mail-m128248.netease.com [103.209.128.248])
	by imf17.hostedemail.com (Postfix) with ESMTP id C985040002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf17.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ND5EZj7JQ8YayZRBZb3U+AbUZ3EKzLPLjchuk2el9mM=;
	b=1FnPVQODx8xQPAjZM52xYO0hegzKigddGGSUP9uGNr2bGnGHRK6wTIPsUWBYQ5hOOojEba
	OO5KRSG3DqEVYVvdFecwSlMRQeekI/oLVMKpjF4vG2WD9bB6oBzAp5AwDfWxGh4fXPVnwl
	BL5LgZCje3ItbXTo52JFrAea3/HjGqg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf17.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581898;
	b=Ywfpwef71uHYilAtNd4P7kLDtNKE8dQtQEmzunCulh0VRPPWcoWobPkHNrk+culkp1mYoP
	7hUBwRJ0DNcvgVUdYTfsG5z/uwfNmV/isrUEQ2K3dBYwIc+1Mq5+Z8wXsYG6rQtqlE5Mog
	wUF6CYlnHxGGfvY87sV8oPFEJpUBULA=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151a8;
	Wed, 21 Oct 2026 19:24:52 +0800 (GMT+08:00)
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
Subject: [PATCH v3 3/7] mm/page_owner: add bpf_iter target "page_owner"
Date: Wed, 21 Oct 2026 19:24:33 +0800
Message-Id: <20261021112437.1799213-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e34f8690229kunme08c1fd526acdc
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCS08YVhlJQh0fTE9IGRgaH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C985040002
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: miexooqi5x9ckxsmffk19s78k5tyzpr6
X-HE-Tag: 1792581896-353799
X-HE-Meta: U2FsdGVkX18tK7EgB8Vym7pdSHJCzkKDbhsmNn9yMHxsJ+SeW9jdU01n2vfAh3Giq953sVyBCyOeFUuysH9lXd5nuESgE3xm9KdQS30fyiwLfa+AnHXruOIIK9SpcMTBYOcgJvz9b5xYFwgZB6CkES1DsAJLgOIdXblMCFp3P/TQRhYlcuSDNjjYUtr7XlrK9rYs/AH4v/se+/UzmYVV47yNAro4/UlgCnfvHCHDNu7EW602Cxr3HZnOvKWMDIeaG9CRNKpYA6RK2qwKH//saVeifHYTKgIMH/aQcvbLCukYlYAjzNBeCERafiZXtUlR5/k0M3+7Gf1na6DXGBmcwEz88vN1e0MLMQz3JwL84kr4ZefN00s3+ojA6HA7cITLOPaa0WB80M85HwL9o9MoRqxxKfd7EM3gSXKWoxEsfmMwKO9Z2/ydaci/AtMPhfLJyCLLioDcKuAMQm8TB+n3DpXxghSPrNKVcJY+HimCN4KJqRpiqNhFeSwQbiLf4T4dUZWwcQcCpYvu8cSw0pwBZCYSyTlqdhojOenzP/fybBKSJjOCTmqyHKR0ZDQaLnqFASY+teq5saucGksEOvbFHIjmra5d1NKFBw5+d/oe7xNIyS41ZDMe5Na8XsY+QDod5hLk9Ps4BT02wKhbaH2wlhYjGNHeyLr8SyCv4720zsma7/njXMZSU2xxOYZKIAqzcR9laW7Smio7Lts+NEhWYXpejj1XdJpSOvdCvkXFbyA/CR2UULMXXK4oifpKWbPaTs6C+ICNqn5qU9vucd+wwyzX28grwLpCuDEIii8Oa5XmugiTSIu9EG6T9TRngzYDQLnGrIkO4x864pspQnDlbmN3RLrQkgG166Uf+w7NYJGTVX9Aougn5QJ2lPO7/ZhnChyVyr7pwmU07wevBCHqY4WhyuksVs+gWMYlg7IEyprppzM8323/77yJkV0SVIDE486zVY4VImSiZ7+tE8q
 WS22BU7d
 Lknc8n3O5VahLz3QzHaNbqhIOuj/Y3GpAoSGn/3OMOvy3XOF+LIkjROH/aLfZqQqqpmozS/7f6DeiXniGdkbs81SiuP+mLRJV2G/ZE4VuRrIeT/xn9pWHozMX/Hc7tA6rOV0JDFPMkKrdmcw8BU0Lc69CwIsPsZWVe86Bo2Ji6ds2NGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Register a bpf_iter target "page_owner" that walks the pages eligible
for page_owner output, with the same eligibility rules as the
/sys/kernel/debug/page_owner read path.

For each eligible page the attached BPF program receives the pfn and the
page_owner record, and can freely filter and format output.

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

    bpftrace -e 'iter:page_owner / ctx->po->pid == 1 /
                 { @ = sum(1 << ctx->po->order); }'

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- Drop the page pointer from the BPF context.
- Enable BPF_ITER_RESCHED.
- Fix the bpftrace example in the commit message.

Changes in v2:
- Drop the scan->pfn++.
- Fill page/po/pfn only when v is non-NULL.
- Implement page_owner_seq_stop().

v2: https://lore.kernel.org/linux-mm/20261013122125.843451-3-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20261009112308.240769-3-zhen.ni@easystack.cn/
---
 mm/Makefile          |   3 ++
 mm/page_owner.c      |  32 +++---------
 mm/page_owner.h      |  47 +++++++++++++++++
 mm/page_owner_iter.c | 118 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 175 insertions(+), 25 deletions(-)
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
index 8e72a85c663c..ece3b69a2579 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -14,6 +14,7 @@
 #include <linux/sched/clock.h>
 
 #include "page_alloc.h"
+#include "page_owner.h"
 
 /*
  * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
@@ -21,30 +22,6 @@
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
-	struct page_owner po_snap;
-};
-
 struct stack {
 	struct stack_record *stack_record;
 	struct stack *next;
@@ -740,7 +717,7 @@ void __dump_page_owner(const struct page *page)
  * must advance scan->pfn past the hit before calling again to resume
  * the scan.
  */
-static bool page_owner_next_eligible(struct page_owner_scan *scan)
+bool page_owner_next_eligible(struct page_owner_scan *scan)
 {
 	unsigned long pfn = scan->pfn;
 
@@ -1221,6 +1198,11 @@ static int __init pageowner_init(void)
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
index 000000000000..0aa7695bec82
--- /dev/null
+++ b/mm/page_owner.h
@@ -0,0 +1,47 @@
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
index 000000000000..529b2c4a589a
--- /dev/null
+++ b/mm/page_owner_iter.c
@@ -0,0 +1,118 @@
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
+	__bpf_md_ptr(struct page_owner *, po);
+	u64 pfn;
+};
+
+DEFINE_BPF_ITER_FUNC(page_owner, struct bpf_iter_meta *meta,
+		     struct page_owner *po, u64 pfn)
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
+	return &scan->po_snap;
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
+	return &scan->po_snap;
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
+	.ctx_arg_info_size	= 1,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__page_owner, po),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		= &page_owner_iter_seq_info,
+	.feature		= BPF_ITER_RESCHED,
+};
+
+BTF_ID_LIST(page_owner_btf_ids)
+BTF_ID(struct, page_owner)
+
+int page_owner_iter_register(void)
+{
+	page_owner_iter_reg_info.ctx_arg_info[0].btf_id =
+		page_owner_btf_ids[0];
+
+	return bpf_iter_reg_target(&page_owner_iter_reg_info);
+}
-- 
2.20.1


