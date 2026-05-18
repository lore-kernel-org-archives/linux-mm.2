Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 625E5CD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C146B008C; Mon, 18 May 2026 04:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCAA6B0092; Mon, 18 May 2026 04:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B123C6B0093; Mon, 18 May 2026 04:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD3F6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:50:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C89F1C0791
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:16 +0000 (UTC)
X-FDA: 84779918832.27.FC4D870
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A62CC0006
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xP2rOROc;
	spf=pass (imf22.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoNLybuMUSeU440nlltv1/CuGYWJcpqCWHdxGW4hf3M=;
	b=L4dEUW09oIap8ypjmC+frjuT2Gh4ulHH+0k2q6nV4FLHSfmrCC5qPaimZVat3WqKyYfRWj
	AL/8XUQX6bptVp7Nk9JAaF/AR90G96gqCMJEWWaj6hHYHIXwzg1BrRiP8NloOADc6C61/X
	ekB/f1UoWMQ+bx89V1qdiNDEYz4wuTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094214; a=rsa-sha256;
	cv=none;
	b=BpRdHnxZXkp6O9eX96RXB09FYgHjcIaIUP19T7HIQOMzwXjCqLnThqJkvIsQuH/iGdkUS/
	LSJqvD+vLT3yc9MVi36Db82bkxxxg6M0RzpTGX5sbCQgZkYhDYirnsctij9DimelVXLHt8
	BPjHxzCn3JmqPOuk9ey4VAN2wweA2sM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xP2rOROc;
	spf=pass (imf22.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779094209; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=UoNLybuMUSeU440nlltv1/CuGYWJcpqCWHdxGW4hf3M=;
	b=xP2rOROcyWq0VP5vlF3d2TJfJw3hiU6kyOhWlrObbNhQfZ5gSfreVI35SsZKD1e4ywilrwW13ACTXIx2fCQwnHXYWq4iYwIy5hdNbeVznf/Bya3lGPLM52zn77mqbRK1FPL3Sj9J4d/891dHxFIKwPviovj57dABGFKR+xx6P9U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X36F6m8_1779094205;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X36F6m8_1779094205 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 16:50:07 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v14 2/8] ACPI: APEI: GHES: use exception context to gate SIGBUS on poison consumption
Date: Mon, 18 May 2026 16:49:46 +0800
Message-ID: <20260518084956.2538442-3-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A62CC0006
X-Stat-Signature: rjim5ake69dtr6retnfa54mic6mdep3f
X-Rspam-User: 
X-HE-Tag: 1779094212-889131
X-HE-Meta: U2FsdGVkX1++bNof+BHtWFFdI7Ra1wyoew5sbJBz5+wt6zsV0VktYmqlZTM1g4KBkXb8xb4jQQM9YACpca4LgdVaiWsZ1Ue92h8F3DMYyp1GoeNw3vxymOOUGHmLeQGb7YXjXALhMuH1JUYJBCMpOTqc+GelUT+GCQJfWkZSlQQirgsPYe5NsaLe4+b1T33yH4cPcdpzvzdphofwFnvnxW2PAPfpT3cbeqF97+n6A6UxszyohqsATX/FUHTuxAF2MxYkjnQ1Q2ZS+93H70tJJMD6PwPX/VdNNRfZXw9Y7Lp3lgDwXb+g7+NrwCpbSx91eLJtt0kSGsyB16V9Lgbzaolh0mh4otJ7Z6IeHjwglBDriLrbpgnn9vvboqTrjuDqoMXk0FAVtdegAlP1wdoQsislamwEkPeU52yrN3yPjQhjN6/hZVfJfH5hrAokG546jqJs2bVs4xpz1DINdTl6JKdw9I6vrUqpHTvWXb7CGMrCtwMEhzd6CgdPGuq0ytyTp9OQgqbP0ytyMFg86L6mLWC9t91byjhL1LR7rp5kDa3smsNp3WI0l/b/UvHhVsjhbStr2To1yE8sD0m7j7xXN1YosST/nFWX0SFQAZiRC0GwPVJv43ogA372DgmYIN+8zr2XNNRFjIdlHApEWEfwwCvHSArqXTVmICvghWuVoMTDVlz6A95A3u+++KF5CcVcDvsTrPQZpy2wuaobfqETjlfdjwyl1NRNG0qwPwdKKPTmYh1unFbtqzZmzLeMy7RdoW2vPuuY1NXcc/PMHCFaxo0duCY9RCg0xOHICz5SWTbjbq7JyHj0x3eCTy18/HIWrlzwINEbnXiqDcGRYyDdu1n76tmnH65Nc13x7e18XxajjkLw5cwiq1XM0E3otvebeDuso5Rb5s5paBW/+ojlL1RdU/d7ftzrikZmeRlrAvOgnHdzqpb8FpFxGZalhZUHpL8WBuaHinoNTlOgnTI
 G1wo1Fca
 x45LWsdu1ZB+wxCVr4NtKqDaR4CsGjTzXQ5EQMz2mUfm+iVqMnu5T86N+ptZXtJXZV+k/vI5LnN9AznbYOV1DxcFVFxSge/1f8JyN/9GYqS4s25YDDZkC0ReTi7sY0I4s9bZ+hmQZbj7XDCMvPHYfCBb+DM6TRSPVoMMJBtzEWIeuLubClI2AjMOO06KhJhN/C3YaV/klhgTwz/7A8RoKnS/Rh7oJSEo/IMOC3XSnIWyD9tE0xWF/7ImK6was9akInJiEt4vwFowzxI3xNwXQ6nZvjZJKlVn8YAXEW3H6j8BfAvD/ufjhx9o0Ya6fFUbth9gz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a GHES SEA (Synchronous External Abort) fires while the CPU
was executing in kernel mode, it typically means that kernel code
itself consumed a poisoned memory location -- e.g. copy_from_user()
/ copy_to_user() invoked from a ioctl() or write() syscall touched
a poisoned user page or page-cache page on behalf of the task.

The expected behaviour in that case is that the faulting kernel
helper returns via its extable fixup and the syscall returns an
error (e.g. -EFAULT) to user space. It is NOT appropriate to deliver
SIGBUS to the current task: the task did not directly dereference
the poisoned address, the kernel did on its behalf, and the kernel
is able to recover.

Up to now ghes_handle_memory_failure() unconditionally promoted any
synchronous recoverable memory error to MF_ACTION_REQUIRED, which
ends up SIGBUS on current -- regardless of whether the poison was
consumed from user space or from inside the kernel on the task's
behalf. That kills tasks that should instead have seen a plain
syscall error.

To fix this, the execution mode in which the exception was taken
must be captured at the arch-level entry point, where pt_regs (and
hence user_mode(regs)) are still available. The estatus node that
later drains the error in IRQ / process context no longer has
access to the original regs.

Introduce:

    enum context { NO_USE = -1, IN_KERNEL = 0, IN_USER = 1 };

and plumb the value all the way down to the queued estatus node:

 * Add an 'enum context context' field to struct ghes_estatus_node
   and record it in ghes_in_nmi_queue_one_entry().
 * Extend ghes_notify_sea() and the internal
   ghes_in_nmi_spool_from_list() with an enum context parameter.

Then consume the recorded context in ghes_handle_memory_failure()
for the GHES_SEV_RECOVERABLE / sync path:

    flags = sync && context == IN_USER ? MF_ACTION_REQUIRED : 0;

i.e. MF_ACTION_REQUIRED (and thus SIGBUS via the task_work path) is
only raised for user-mode poison consumption. Synchronous errors
taken in kernel mode fall back to memory_failure_queue() with
flags=0, asynchronously isolating the poisoned page while letting
the faulting kernel helper's extable fixup return -EFAULT
to user space.

Paths that pass NO_USE are unaffected:
sync is false for them, so flags stays 0 as before.

Signed-off-by: Ruidong Tian  <tianruidong@linux.alibaba.com>
---
 arch/arm64/kernel/acpi.c |  2 +-
 drivers/acpi/apei/ghes.c | 36 ++++++++++++++++++++----------------
 include/acpi/ghes.h      |  6 ++++--
 3 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 5891f92c2035..40d4a2913d51 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -409,7 +409,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 */
 	local_daif_restore(DAIF_ERRCTX);
 	nmi_enter();
-	err = ghes_notify_sea();
+	err = ghes_notify_sea(user_mode(regs));
 	nmi_exit();
 
 	/*
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 3236a3ce79d6..6f265893cddf 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -529,7 +529,7 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 }
 
 static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
-				       int sev, bool sync)
+				       int sev, bool sync, enum context context)
 {
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
@@ -543,7 +543,7 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
 		flags = MF_SOFT_OFFLINE;
 	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
-		flags = sync ? MF_ACTION_REQUIRED : 0;
+		flags = sync && context == IN_USER ? MF_ACTION_REQUIRED : 0;
 
 	if (flags != -1)
 		return ghes_do_memory_failure(mem_err->physical_addr, flags);
@@ -552,10 +552,10 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 }
 
 static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
-				     int sev, bool sync)
+				     int sev, bool sync, enum context context)
 {
 	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
-	int flags = sync ? MF_ACTION_REQUIRED : 0;
+	int flags = sync && context == IN_USER ? MF_ACTION_REQUIRED : 0;
 	int length = gdata->error_data_length;
 	char error_type[120];
 	bool queued = false;
@@ -910,7 +910,8 @@ static void ghes_log_hwerr(int sev, guid_t *sec_type)
 }
 
 static void ghes_do_proc(struct ghes *ghes,
-			 const struct acpi_hest_generic_status *estatus)
+			 const struct acpi_hest_generic_status *estatus,
+			 enum context context)
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
@@ -937,11 +938,11 @@ static void ghes_do_proc(struct ghes *ghes,
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued = ghes_handle_memory_failure(gdata, sev, sync, context);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued = ghes_handle_arm_hw_error(gdata, sev, sync, context);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
 			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
 
@@ -1190,7 +1191,7 @@ static int ghes_proc(struct ghes *ghes)
 		if (ghes_print_estatus(NULL, ghes->generic, estatus))
 			ghes_estatus_cache_add(ghes->generic, estatus);
 	}
-	ghes_do_proc(ghes, estatus);
+	ghes_do_proc(ghes, estatus, NO_USE);
 
 out:
 	ghes_clear_estatus(ghes, estatus, buf_paddr, FIX_APEI_GHES_IRQ);
@@ -1297,7 +1298,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 		len = cper_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
 
-		ghes_do_proc(estatus_node->ghes, estatus);
+		ghes_do_proc(estatus_node->ghes, estatus, estatus_node->context);
 
 		if (!ghes_estatus_cached(estatus)) {
 			generic = estatus_node->generic;
@@ -1335,7 +1336,8 @@ static void ghes_print_queued_estatus(void)
 }
 
 static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
-				       enum fixed_addresses fixmap_idx)
+				       enum fixed_addresses fixmap_idx,
+				       enum context context)
 {
 	struct acpi_hest_generic_status *estatus, tmp_header;
 	struct ghes_estatus_node *estatus_node;
@@ -1364,6 +1366,7 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
 	if (!estatus_node)
 		return -ENOMEM;
 
+	estatus_node->context = context;
 	estatus_node->ghes = ghes;
 	estatus_node->generic = ghes->generic;
 	estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
@@ -1398,14 +1401,15 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
 }
 
 static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list,
-				       enum fixed_addresses fixmap_idx)
+				       enum fixed_addresses fixmap_idx,
+				       enum context context)
 {
 	int ret = -ENOENT;
 	struct ghes *ghes;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(ghes, rcu_list, list) {
-		if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx))
+		if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx, context))
 			ret = 0;
 	}
 	rcu_read_unlock();
@@ -1488,7 +1492,7 @@ static LIST_HEAD(ghes_sea);
  * Return 0 only if one of the SEA error sources successfully reported an error
  * record sent from the firmware.
  */
-int ghes_notify_sea(void)
+int ghes_notify_sea(enum context context)
 {
 	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sea);
 	int rv;
@@ -1497,7 +1501,7 @@ int ghes_notify_sea(void)
 		return -ENOENT;
 
 	raw_spin_lock(&ghes_notify_lock_sea);
-	rv = ghes_in_nmi_spool_from_list(&ghes_sea, FIX_APEI_GHES_SEA);
+	rv = ghes_in_nmi_spool_from_list(&ghes_sea, FIX_APEI_GHES_SEA, context);
 	raw_spin_unlock(&ghes_notify_lock_sea);
 
 	return rv;
@@ -1552,7 +1556,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		return ret;
 
 	raw_spin_lock(&ghes_notify_lock_nmi);
-	if (!ghes_in_nmi_spool_from_list(&ghes_nmi, FIX_APEI_GHES_NMI))
+	if (!ghes_in_nmi_spool_from_list(&ghes_nmi, FIX_APEI_GHES_NMI, NO_USE))
 		ret = NMI_HANDLED;
 	raw_spin_unlock(&ghes_notify_lock_nmi);
 
@@ -1606,7 +1610,7 @@ static void ghes_nmi_init_cxt(void)
 static int __ghes_sdei_callback(struct ghes *ghes,
 				enum fixed_addresses fixmap_idx)
 {
-	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx)) {
+	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx, NO_USE)) {
 		irq_work_queue(&ghes_proc_irq_work);
 
 		return 0;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 8d7e5caef3f1..646cd5c3c0ca 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -33,10 +33,12 @@ struct ghes {
 	void __iomem *error_status_vaddr;
 };
 
+enum context {NO_USE = -1, IN_KERNEL = 0, IN_USER = 1};
 struct ghes_estatus_node {
 	struct llist_node llnode;
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes;
+	enum context context;
 };
 
 struct ghes_estatus_cache {
@@ -135,9 +137,9 @@ static inline void *acpi_hest_get_next(struct acpi_hest_generic_data *gdata)
 	     section = acpi_hest_get_next(section))
 
 #ifdef CONFIG_ACPI_APEI_SEA
-int ghes_notify_sea(void);
+int ghes_notify_sea(enum context context);
 #else
-static inline int ghes_notify_sea(void) { return -ENOENT; }
+static inline int ghes_notify_sea(enum context context) { return -ENOENT; }
 #endif
 
 struct notifier_block;
-- 
2.39.3


