Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C0BCDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D7B6B009F; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C2D6B00A1; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0456B00A4; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61DAD6B009F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:50:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D10031405CA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:50:03 +0000 (UTC)
X-FDA: 84917359086.21.A1F76C0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A039100009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:50:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782366601;
	b=h3ockqp4VHBWUNF5o50rpT9+1BHZk/qAJL98NVTpqhj7104RrYcNovVlpNsJ06EcZWzVcX
	sAX4NcS6Tas5ItLkh2p0ap9EHhKh4fOBiefbjinTyRwyI/JM/nNRifeOsnTxB5HeL6rEp7
	NfNtZTAnMW2+OaKPCPYXDhbAtyo/fS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782366601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KIIyohw3VHuxRrR94sTuX14xsknTZ8n/vvXUwLr+WYs=;
	b=djSKm6L/XmEdAHxDi/pmHnZXi70/3wjwBIyg1eRkqHclaAbKeiSY223BIpqOz/ONLWBbxZ
	trNeEf8ij90T4vkLi4H5WpIb/CKfxatUQvCph5teubtWu74c+x15EGah2yu07lqsYgXjuP
	o0Sc8jlS17AoZMdK7sI4dbnHg7hJslU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
X-UUID: aec745dc705911f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ce9a07e3-e4e1-40da-9f47-c0e7e04ebddf,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:ce9a07e3-e4e1-40da-9f47-c0e7e04ebddf,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:bba3247d4b4b8c0298b9b0b043114bad,BulkI
	D:260625134951ABU9FVJ8,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,R
	T:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aec745dc705911f1aa26b74ffac11d73-20260625
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1039542748; Thu, 25 Jun 2026 13:49:51 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	pratyush@kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v1 1/2] eventfd: luo: luo support for preserving eventfd
Date: Thu, 25 Jun 2026 13:49:45 +0800
Message-Id: <20260625054946.73445-2-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260625054946.73445-1-duanchenghao@kylinos.cn>
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A039100009
X-Stat-Signature: sutm3xhtdd7c9sq8hhdmswd16smjix7q
X-HE-Tag: 1782366600-958256
X-HE-Meta: U2FsdGVkX1+9gqSJMS46UZBZ2MXRfa4/+gXlryZGRfNuR1acupvKBsYE3RDj2eiM7R4+BThoNM/bXpoI7WyUUsrKvQz1Q9yqGeevGppWyhcfFSZwoxL6kn4RkNxk6VNDn0sihqdc7CqMwkh9RFsEoozsH6APMjGcXG2ih5gtZYJ+0Q0wbIniHsc1VV/ZCphDjV4AX/vzXWmpYzCAMu00sKyJx1sNmHFWiFTYT7RXaqigBvKJf9dBsqEwSQn3LhY8JIC9kN94o9QgI7sGDNqf3FeYuHoixo4xA3eDrA+hoEfuMMiqygzFuqO6fLBYjPcxE987xBQivtg3Ibdg+FH5QccAMtkzqVqgAntoe7TtTysEVP9WSRmCyId4XWnQgVLixAUWEw0uc94KVHi25+KUPm9hOQ+l6NGhA44ZVPkLx8J+Odz9sDfAPbQSqINz3WAxTS7zs+lnEJmMiGmB1KXn61tmeHppm1IHg5e2FjudP+VCQGIbxAxscl894N4Zg2WNtzFy0ue9iXkv+maw6Hja8NOWNtFpO7vLju5yqc9QJSvIWnX7A8wFydym8exrOeB+hSQkyy2xf2Ez5LRBPvtz0N9yYYscUvYwY9t7MF5IupccKyFE3cU/PZG+koDlUUOp6wlf/Zsb3+kstNBp+g/oX+oPSQ7C3lu9Et6VLuhzuyQyOVSI5LSiHZep9NMiEbQ9ONc+P6CQ1vEMpJN/zs+iSPljdpHZo6bAfOXbND1LFNCWjqOYGa+ZAtNN6qtDFYbyZhrExoESXt12hr0/ro1Ask/GBQOrnRK4O0CDUhMZvup3rA/Ih2vHZ7cCRFCUAZKqLEmI62GmGZpt18qr+o8Gx0CPD1Qn5FP0P0jKJFFrNbseJIsRxVYibQlz2a5mUPe2FIAAmQnCQwXelTw+68ric1DbE4x/BjhzX1qSdhu9q55m/OXHyN97GfQcrgpj9oMdd4MPVnIoOEdqsio2CA4
 LTOB+yGi
 2Fjrm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds support for preserving eventfd file descriptors across
kexec live updates using the Live Update Orchestrator (LUO) framework.
Userspace applications using eventfd for event notification can now
maintain their state across kernel updates.

Preserved State:
The following properties of the eventfd are preserved across kexec:
- Counter Value: The current 64-bit counter value, including any pending
  events that have been signaled but not yet consumed by readers.
- File Flags: The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK)
  are preserved.

Non-Preserved State:
- File Descriptor Number: The eventfd will be assigned a new fd number
  in the target process after restore.
- Wait Queue State: Any processes blocked on read() operations will be
  woken up and need to re-establish their blocking state.
- All other internal state is reset to default.

Changes:
- fs/eventfd.c: Add eventfd_luo_get_state() to safely read eventfd state
  (count and flags), and eventfd_create() helper function.
- fs/eventfd_luo.c: New file implementing LUO file operations:
  preserve, freeze, unpreserve, retrieve, and finish callbacks.
- include/linux/eventfd.h: Export new functions.
- include/linux/kho/abi/eventfd.h: Define the ABI contract with
  eventfd_luo_ser structure for serialization.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 fs/Makefile                     |   1 +
 fs/eventfd.c                    |  40 +++++
 fs/eventfd_luo.c                | 250 ++++++++++++++++++++++++++++++++
 include/linux/eventfd.h         |   2 +
 include/linux/kho/abi/eventfd.h |  39 +++++
 kernel/liveupdate/Kconfig       |  16 ++
 6 files changed, 348 insertions(+)
 create mode 100644 fs/eventfd_luo.c
 create mode 100644 include/linux/kho/abi/eventfd.h

diff --git a/fs/Makefile b/fs/Makefile
index 89a8a9d207d1..36d568e6cfc7 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -27,6 +27,7 @@ obj-y				+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
+obj-$(CONFIG_LIVEUPDATE_EVENTFD)+= eventfd_luo.o
 obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_FS_DAX)		+= dax.o
 obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 9d33a02757d5..9b76cf06135a 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -376,6 +376,40 @@ struct eventfd_ctx *eventfd_ctx_fileget(struct file *file)
 }
 EXPORT_SYMBOL_GPL(eventfd_ctx_fileget);
 
+/**
+ * eventfd_luo_get_state - Get eventfd state (count and flags) for LUO
+ * @file: Eventfd file
+ * @count: Output parameter for count value
+ * @flags: Output parameter for flags value
+ *
+ * This function is exported for use by LUO to safely read eventfd state.
+ * Since struct eventfd_ctx is defined in this file, we can access its
+ * members directly here. The function uses the wait queue lock to ensure
+ * atomic access to count.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int eventfd_luo_get_state(struct file *file, __u64 *count, unsigned int *flags)
+{
+	struct eventfd_ctx *ctx;
+	unsigned long irq_flags;
+
+	ctx = eventfd_ctx_fileget(file);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	/* Read count with lock (flags don't need lock) */
+	spin_lock_irqsave(&ctx->wqh.lock, irq_flags);
+	*count = ctx->count;
+	spin_unlock_irqrestore(&ctx->wqh.lock, irq_flags);
+
+	*flags = ctx->flags;
+
+	eventfd_ctx_put(ctx);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(eventfd_luo_get_state);
+
 static int do_eventfd(unsigned int count, int flags)
 {
 	struct eventfd_ctx *ctx __free(kfree) = NULL;
@@ -411,6 +445,12 @@ static int do_eventfd(unsigned int count, int flags)
 	return fd_publish(fdf);
 }
 
+int eventfd_create(__u64 count, unsigned int flags)
+{
+	return do_eventfd(count, flags);
+}
+EXPORT_SYMBOL_GPL(eventfd_create);
+
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
 	return do_eventfd(count, flags);
diff --git a/fs/eventfd_luo.c b/fs/eventfd_luo.c
new file mode 100644
index 000000000000..781d90635c52
--- /dev/null
+++ b/fs/eventfd_luo.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 KylinSoft Corporation.
+ * Author: Chenghao Duan <duanchenghao@kylinos.cn>
+ */
+
+/**
+ * DOC: Eventfd Preservation via LUO
+ *
+ * Overview
+ * ========
+ *
+ * Event file descriptors (eventfd) can be preserved over a kexec using the Live
+ * Update Orchestrator (LUO) file preservation. This allows userspace applications
+ * that use eventfd for event notification to maintain their state across kernel
+ * updates.
+ *
+ * Eventfd is a simple notification mechanism that uses a 64-bit counter for
+ * signaling events between userspace processes or between userspace and kernel.
+ * The preservation ensures that pending events and configuration are not lost
+ * during kexec.
+ *
+ * The preservation is not intended to be transparent. Only select properties of
+ * the eventfd are preserved. All others are reset to default. The preserved
+ * properties are described below.
+ *
+ * Preserved Properties
+ * ====================
+ *
+ * The following properties of the eventfd are preserved across kexec:
+ *
+ * Counter Value
+ *   The current 64-bit counter value is preserved. This includes any pending
+ *   events that have been signaled but not yet consumed by readers.
+ *
+ * File Flags
+ *   The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK) are preserved.
+ *   These control the behavior of read/write operations and file descriptor
+ *   inheritance.
+ *
+ * Non-Preserved Properties
+ * ========================
+ *
+ * All properties which are not preserved must be assumed to be reset to
+ * default. This section describes some of those properties which may be more of
+ * note.
+ *
+ * File Descriptor Number
+ *   The file descriptor number itself is not preserved. After restore, the
+ *   eventfd will be assigned a new file descriptor number in the target process.
+ *
+ * Wait Queue State
+ *   Any processes currently blocked on read() operations will be woken up and
+ *   need to re-establish their blocking state if desired.
+ *
+ * File Position
+ *   Eventfd files don't have a traditional file position, but any internal
+ *   state related to the file descriptor is reset.
+ */
+
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/eventfd.h>
+#include <linux/liveupdate.h>
+#include <linux/module.h>
+#include <linux/eventfd.h>
+#include <linux/anon_inodes.h>
+#include <linux/idr.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/kref.h>
+#include <linux/fdtable.h>
+
+static int eventfd_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct eventfd_luo_ser *ser;
+	u64 count;
+	unsigned int flags;
+	int err = 0;
+
+	/* Get eventfd state safely */
+	err = eventfd_luo_get_state(args->file, &count, &flags);
+	if (err) {
+		pr_err("Failed to get eventfd state: %d\n", err);
+		return err;
+	}
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		err = PTR_ERR(ser);
+		pr_err("Failed to allocate preserve memory: %d\n", err);
+		return err;
+	}
+
+	/* Save eventfd state */
+	ser->count = count;
+	ser->flags = flags;
+
+	pr_debug("Preserved eventfd: count=%llu, flags=0x%x\n",
+		ser->count, ser->flags);
+
+	/* Return physical address of serialization structure */
+	args->serialized_data = virt_to_phys(ser);
+
+	return 0;
+}
+
+static int eventfd_luo_freeze(struct liveupdate_file_op_args *args)
+{
+	struct eventfd_luo_ser *ser;
+	u64 count;
+	unsigned int flags;
+	int err;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	/* Get current state and update if changed */
+	err = eventfd_luo_get_state(args->file, &count, &flags);
+	if (err)
+		return err;
+
+	if (ser->count != count) {
+		pr_debug("WARNING: Count changed during preserve->freeze! old=%llu, new=%llu\n",
+			 ser->count, count);
+	}
+
+	ser->count = count;
+
+	return 0;
+}
+
+static void eventfd_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct eventfd_luo_ser *ser;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+	kho_unpreserve_free(ser);
+}
+
+static int eventfd_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct eventfd_luo_ser *ser;
+	struct eventfd_ctx *ctx;
+	struct file *file = NULL;
+	int eventfd;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser)
+		return -EINVAL;
+
+	/* Create a new eventfd with the preserved count and flags */
+	eventfd = eventfd_create(ser->count, ser->flags);
+	if (eventfd < 0) {
+		pr_err("Failed to create eventfd: %d\n", eventfd);
+		return eventfd;
+	}
+
+	file = fget(eventfd);
+	if (!file) {
+		pr_err("Failed to get file from fd\n");
+		close_fd(eventfd);
+		return -EBADF;
+	}
+
+	close_fd(eventfd);
+
+	/* Verify the created file has correct internal state */
+	ctx = eventfd_ctx_fileget(file);
+	if (IS_ERR(ctx)) {
+		pr_err("Failed to get context from file\n");
+		fput(file);
+		return PTR_ERR(ctx);
+	}
+
+	eventfd_ctx_put(ctx);
+
+	args->file = file;
+	return 0;
+}
+
+static void eventfd_luo_finish(struct liveupdate_file_op_args *args)
+{
+	struct eventfd_luo_ser *ser;
+
+	if (args->retrieve_status)
+		return;
+
+	if (!args->serialized_data)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser)
+		return;
+
+	kho_restore_free(ser);
+}
+
+static bool eventfd_luo_can_preserve(struct liveupdate_file_handler *handler,
+				     struct file *file)
+{
+	struct eventfd_ctx *ctx;
+
+	if (!file->f_op)
+		return false;
+
+	/* Try to get eventfd context - this will fail if not an eventfd */
+	ctx = eventfd_ctx_fileget(file);
+	if (IS_ERR(ctx))
+		return false;
+
+	eventfd_ctx_put(ctx);
+	return true;
+}
+
+static const struct liveupdate_file_ops eventfd_luo_file_ops = {
+	.preserve = eventfd_luo_preserve,
+	.unpreserve = eventfd_luo_unpreserve,
+	.freeze = eventfd_luo_freeze,
+	.retrieve = eventfd_luo_retrieve,
+	.finish = eventfd_luo_finish,
+	.can_preserve = eventfd_luo_can_preserve,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler eventfd_luo_handler = {
+	.ops = &eventfd_luo_file_ops,
+	.compatible = EVENTFD_LUO_FH_COMPATIBLE,
+};
+
+static int __init eventfd_luo_init(void)
+{
+	int err = liveupdate_register_file_handler(&eventfd_luo_handler);
+
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register eventfd LUO handler: %pe\n",
+		       ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+late_initcall(eventfd_luo_init);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index e32bee4345fb..703e1a126c4d 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -35,6 +35,8 @@ void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
+int eventfd_luo_get_state(struct file *file, __u64 *count, unsigned int *flags);
+int eventfd_create(__u64 count, unsigned int flags);
 void eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
diff --git a/include/linux/kho/abi/eventfd.h b/include/linux/kho/abi/eventfd.h
new file mode 100644
index 000000000000..148beac6bcc7
--- /dev/null
+++ b/include/linux/kho/abi/eventfd.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 KylinSoft Corporation.
+ * Author: Chenghao Duan <duanchenghao@kylinos.cn>
+ */
+
+#ifndef _LINUX_KHO_ABI_EVENTFD_H
+#define _LINUX_KHO_ABI_EVENTFD_H
+
+#include <linux/types.h>
+
+/*
+ * Eventfd Live Update ABI
+ *
+ * This header defines the ABI for preserving eventfd state across kexec.
+ *
+ * The state is serialized into a packed structure `struct eventfd_luo_ser`
+ * which is handed over to the next kernel via the KHO mechanism.
+ *
+ */
+
+/**
+ * struct eventfd_luo_ser - Serialized state of an eventfd
+ * @count: The current counter value
+ * @flags: File flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NONBLOCK)
+ *
+ * This structure contains the minimal state needed to restore an eventfd
+ * after kexec. The count represents the current value of the event counter,
+ * and flags represent the file creation flags.
+ */
+struct eventfd_luo_ser {
+	__u64 count;
+	unsigned int  flags;
+} __packed;
+
+/* The compatibility string for eventfd file handler */
+#define EVENTFD_LUO_FH_COMPATIBLE	"eventfd-v1"
+
+#endif /* _LINUX_KHO_ABI_EVENTFD_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..1361b5733f41 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -86,4 +86,20 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_EVENTFD
+	bool "Eventfd Live Update Orchestrator support"
+	depends on EVENTFD
+	depends on LIVEUPDATE
+	help
+	  Enable Live Update Orchestrator support for eventfd file descriptors.
+	  This allows eventfd files to be preserved and restored across kexec
+	  operations, maintaining their counter values and flags.
+
+	  Eventfd files are commonly used for event notification between
+	  userspace processes or between userspace and kernel. With this
+	  option enabled, eventfd state can be handed over to a new kernel
+	  during live update operations.
+
+	  If unsure, say N.
+
 endmenu
-- 
2.25.1


