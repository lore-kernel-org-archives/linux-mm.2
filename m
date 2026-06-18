Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A2FCD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D866B0092; Thu, 18 Jun 2026 05:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD9F6B0095; Thu, 18 Jun 2026 05:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114CC6B0093; Thu, 18 Jun 2026 05:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 086AD6B00C6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 172B9A0650
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:55 +0000 (UTC)
X-FDA: 84892491390.17.4FC7337
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5218B140008
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wk3cM3De;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdbarJPqjC55LTRElMsZwxi5F6G9ivMOr+PAq0++WHk=;
	b=gZ5Cf9ihF5/o+1kKfoZDdxpnWM4kxKFcpGgIHSKffZ/f9j/HfFsPbsIju93UZB31Q6WG44
	5C7ml1OFPF4jB/l0W/woSkCQDxWSuZ/RwCwJNGS/NyUe8ky6BfEfqCu1BOOqYyTgd28EbG
	Pohbx18OmFce6mJ9D2h8JojkHZMKK9Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wk3cM3De;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774513;
	b=tszoCU+ePJGJFO/95/QQ9gQY3DmXFRYWCBP3ZcSE1lt8g5xm31i9JxgK/XXUMxY1PdKqVp
	1PQy4kq3Xl2ZGScxghfRC4G/m8T/axLWRPnOLxIEgBJjJkcmZ0S4UMVLxlTOT2nfT8ts7f
	v3QjFRXe/u74SoQJGktblZSDL8Ol4Ow=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774506; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=tdbarJPqjC55LTRElMsZwxi5F6G9ivMOr+PAq0++WHk=;
	b=wk3cM3DeXo5c0OYVPJ1XCc4BYIpRivWcRPs4v0THxHvIvn+FSu9cOW+rTcVp8tqyiCRcTgbN0uAEUoaz0PWAYQv43ENIYJ7QSKS5J3brWTrV7VO01cvgj19EgJtrNLX2+RVaua+VppfPDtL5sUY0i1qXtqQOlkiiRDfhJaEQXyI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56TK4t_1781774500;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56TK4t_1781774500 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:21:44 +0800
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
Subject: [PATCH v15 2/9] ACPI: APEI: GHES: use exception context to gate SIGBUS on poison consumption
Date: Thu, 18 Jun 2026 17:21:16 +0800
Message-ID: <20260618092124.3901230-3-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cba6akobgyghkujjxm83ky1qmdehpr8e
X-Rspamd-Queue-Id: 5218B140008
X-HE-Tag: 1781774511-791421
X-HE-Meta: U2FsdGVkX18M15N77lmUN+jjd8WmHWB2kKZ/4exQSci8NFYB3lbRoUIAMEZep5KCYnl8U6xiJYsoWIUnOLtdxoBH+zszHCCBDwO9FoC8COW72o3vYKrrViA6+GWdZsGyDkqXIUmJ8ot+iR8kUowakUKsjGsIKo4nYA7yneALd8iZrax9KWokN2rdH/tmfvZG/gclXy2Y7Ibigx4RhboTyFMyREsr6deHDc3Qpk9HDBkSHA/Jz/tz71KCCKVOEpaPVnKwTnUZBwAMi5Rz1tne1kgpANs20AgEY8F0vk3a/6nsSV+mErXQ1dpejT7xKoQoJUcEuQwuJE+wWNHzUB9LQ+ovCRVSJ+moKYDH7nGYrJf2+pxqAvUHbiS315a2RL33ECW+7SuYAO3o1NauCncsncI1kQadGr/uHFG+7b/bjF2jZyzLatKSC/TeGuuCvV7owm4Iij+/mifC1cL4KsDaG8zyG99w2P3PmFe4wATUmdBfi6CebAHQwb51H0kN6d6TiwL4tdmGbWUslhdy/qsIlyk9Bt/w7n1adhtiglQduhBhTqOXXi0V9L8duiQxO5LOw6EF0pCaTdMekSm0awNUwAR/4/qtVqP7DJPnWElB1F0NbGpy7vd5sF4cn0znMaQrVXR7FWlG4at9/3z2Gki97KxpuOy88gbRmG3MIWybQE49l8A/Z9XLYPKq6B/T6z/KGvDQimRKh8rZ5oFSRDE/auSdnEMAOOy3DVbaJ6sOQE42Vv7OZHFqWv7vt4Oz08Z+wqQoan58JmEVEjuHpZ7R2nG7ZAuxLgwjvAnAdl2/b28k2HFOgbIxnlc3AFpB8k0B+je6O0CcRr6fgL/Y6Fxxu/sY1wrpxNvF+uHa0yIj8uabc5mpLL/lPq38Mobk1WQz+OHQdNcBeXpctX0SsuMxqTJLo+m0nAvW0VXDfwXJuNiQ6e4cZ1h8MJx/oqNgx/HT/1YeGINQCkc1+hbf2r1
 ExEwHrcs
 DkV5noXDFKMcyCohzXAtGAYM/BvwbjTmc9r8MN2UCphqWgziJrK6trmk2hwmJXAc0c1KLadPSYkIdFRaWOd1B44da/v9aKl4juqagz2rUHOs6NHV4PBPqk11ynXSUUvIMPgh/DYX4dlTkLIpSmFrgGQJW1HBvp24pLLKJdok4hebIBaNnC0+85l+bCwGtKnfeaHx+XW8FAh4og4XfZN6hoNuiq3ArsKfvs4b9UcWh2sMPevWxFSR7tsCca6JUzPu5mB/4SdU6py6dXmIpiDveDAhqMx/X0MFHR81T2vXEHMpPGEj8ZfpPcIL9H9CE8zmL7rHoIHYUB2JFvm8=
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

    enum context { ... };

and plumb the value all the way down to the queued estatus node:

 * Add an 'enum context context' field to struct ghes_estatus_node
   and record it in ghes_in_nmi_queue_one_entry().
 * Extend ghes_notify_sea() and the internal
   ghes_in_nmi_spool_from_list() with an enum context parameter.

Then consume the recorded context in ghes_handle_memory_failure()
for the GHES_SEV_RECOVERABLE / sync path:

    flags = sync && context == GHES_CTX_USER ? MF_ACTION_REQUIRED : 0;

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
 include/acpi/ghes.h      | 15 +++++++++++++--
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 5891f92c2035..fa74f32c6e8c 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -409,7 +409,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 */
 	local_daif_restore(DAIF_ERRCTX);
 	nmi_enter();
-	err = ghes_notify_sea();
+	err = ghes_notify_sea(GHES_CTX(regs));
 	nmi_exit();
 
 	/*
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 3236a3ce79d6..2c39adfb584a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -529,7 +529,7 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 }
 
 static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
-				       int sev, bool sync)
+				       int sev, bool sync, enum ghes_exec_ctx context)
 {
 	int flags = -1;
 	int sec_sev = ghes_severity(gdata->error_severity);
@@ -543,7 +543,7 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
 		flags = MF_SOFT_OFFLINE;
 	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
-		flags = sync ? MF_ACTION_REQUIRED : 0;
+		flags = sync && context == GHES_CTX_USER ? MF_ACTION_REQUIRED : 0;
 
 	if (flags != -1)
 		return ghes_do_memory_failure(mem_err->physical_addr, flags);
@@ -552,10 +552,10 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 }
 
 static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
-				     int sev, bool sync)
+				     int sev, bool sync, enum ghes_exec_ctx context)
 {
 	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
-	int flags = sync ? MF_ACTION_REQUIRED : 0;
+	int flags = sync && context == GHES_CTX_USER ? MF_ACTION_REQUIRED : 0;
 	int length = gdata->error_data_length;
 	char error_type[120];
 	bool queued = false;
@@ -910,7 +910,8 @@ static void ghes_log_hwerr(int sev, guid_t *sec_type)
 }
 
 static void ghes_do_proc(struct ghes *ghes,
-			 const struct acpi_hest_generic_status *estatus)
+			 const struct acpi_hest_generic_status *estatus,
+			 enum ghes_exec_ctx context)
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
+	ghes_do_proc(ghes, estatus, GHES_CTX_NA);
 
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
+				       enum ghes_exec_ctx context)
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
+				       enum ghes_exec_ctx context)
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
+int ghes_notify_sea(enum ghes_exec_ctx context)
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
+	if (!ghes_in_nmi_spool_from_list(&ghes_nmi, FIX_APEI_GHES_NMI, GHES_CTX_NA))
 		ret = NMI_HANDLED;
 	raw_spin_unlock(&ghes_notify_lock_nmi);
 
@@ -1606,7 +1610,7 @@ static void ghes_nmi_init_cxt(void)
 static int __ghes_sdei_callback(struct ghes *ghes,
 				enum fixed_addresses fixmap_idx)
 {
-	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx)) {
+	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx, GHES_CTX_NA)) {
 		irq_work_queue(&ghes_proc_irq_work);
 
 		return 0;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 8d7e5caef3f1..8460707ea4b0 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -33,10 +33,21 @@ struct ghes {
 	void __iomem *error_status_vaddr;
 };
 
+enum ghes_exec_ctx {
+	GHES_CTX_NA = -1,
+	GHES_CTX_KERNEL = 0,
+	GHES_CTX_USER = 1
+};
+
+#define GHES_CTX(regs)	((regs) ? (user_mode(regs) ? GHES_CTX_USER \
+						   : GHES_CTX_KERNEL) \
+				: GHES_CTX_NA)
+
 struct ghes_estatus_node {
 	struct llist_node llnode;
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes;
+	enum ghes_exec_ctx context;
 };
 
 struct ghes_estatus_cache {
@@ -135,9 +146,9 @@ static inline void *acpi_hest_get_next(struct acpi_hest_generic_data *gdata)
 	     section = acpi_hest_get_next(section))
 
 #ifdef CONFIG_ACPI_APEI_SEA
-int ghes_notify_sea(void);
+int ghes_notify_sea(enum ghes_exec_ctx context);
 #else
-static inline int ghes_notify_sea(void) { return -ENOENT; }
+static inline int ghes_notify_sea(enum ghes_exec_ctx context) { return -ENOENT; }
 #endif
 
 struct notifier_block;
-- 
2.39.3


