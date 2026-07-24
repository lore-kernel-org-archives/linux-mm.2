Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915E2C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CADF6B0095; Fri, 24 Jul 2026 18:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2386B0096; Fri, 24 Jul 2026 18:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A506B0098; Fri, 24 Jul 2026 18:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29B3E6B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 883824019B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:24 +0000 (UTC)
X-FDA: 85025044608.14.267606D
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2F821C000F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JEt4ua19;
	spf=pass (imf20.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930542;
	b=TTLpO32sb1bjzoke1B/fiAS6M05RPGA2YMG2Hw5JIlAvt3e3qEMEzC8cRjYOyBLuLUUVXV
	dq/SnTADPIpUKN6E09ZUDMmbTGXlZCEY7SveYKawrHXJrGUMgOffzj/WkHM0kNfAqKva3K
	uDLcvpvEy/QAb1xeB1WFH24FVvIFUXQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JEt4ua19;
	spf=pass (imf20.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNz1nVhQciAPDe5/sp7R44bDI4wMfSaLt+M5kzutlc4=;
	b=1pm5dPTWn2Qn7QWGryUk6LI7s/cmPL/w/RskBcKV0lnhbM0W57yxYk2iC7bak8IFZmMYW0
	rANhZKO1RkVExn7Ulnw1eLjMduIge1Fzj2O9Zcq6ZvFT51+56z3NhMt9/yTu15aqSlgKGX
	MLI1+Fksv6k8il08u5+PPIE8Ud7+Ukg=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso721859a91.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930542; x=1785535342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNz1nVhQciAPDe5/sp7R44bDI4wMfSaLt+M5kzutlc4=;
        b=JEt4ua19jaIb1v7OFp3bGdx1tp9l+UUZ4camzwHKNF78UZedDv60ypeitqHdmcc3/+
         eiiTuY+RQSenhgh18FETYOwHdbk+qw3rKGfHSYBu5ds7JVhs0DDZlLHfgd4W4VXadWKa
         3lvDSFjfxvJCFuVPk2QCsEwv4BzX5LsOZv3xqswBhPwktQeAhMZHW7pxHcRUJgnt6i6s
         pfPHAHn9A5AjJO1InPXt0jaZtvKr/+uj0nFN2M1xdnBdS92b20Dbn5JEa8aiBIV+xxEX
         u4GjpQnHpmrSoNCfWgJi7Ah/gdD5y3OkcvEiCaxB5LsaB42hJtk8OK2zk2WbMLvK6w0a
         WpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930542; x=1785535342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNz1nVhQciAPDe5/sp7R44bDI4wMfSaLt+M5kzutlc4=;
        b=g37YzbyFU9z3XWaa91WrYJkqAAT2TI7SBXcK3LkJadyrjXJR8LD6JhBe6t9aCaFOfD
         LgoFC0tBAHQebaQ4LbbZPBL2ZY9mSv38HwnohvIBzhjjwiNu8n3w5bJpX2dsKsrJwaHP
         3Pzm9hJIDlAd+vTEBwucv3p2fbd2hnc72KGwVtY4xcH6joBnKxpngWyPwUo90Ipqm8UM
         zcj+56K1uwqAnwb9K1Hh7inP8vRvMFoOEjoEXe+PEgfMMThoegRVTTHOOrunL0K+gPlZ
         2SWrhccicB+FPmb+r4uYtIcxYMIN4YndU88gGwZpvVWAHpb+qYHa036KXAXzdGUx6kuH
         qKuA==
X-Forwarded-Encrypted: i=1; AHgh+RroupwtVWJ7dvMieUTQs8fUZAu3yUMOyeaxiGwAOY7L8q7IB7JbNJW4Pthz/Xdu1unJL0J95ajoUA==@kvack.org
X-Gm-Message-State: AOJu0YxKdsQNBqcJJA+5Ikb44CJfUJNM23aoCoog4JubGu3zs+Y+BVFR
	Zx2FJDDK76TxA4QxWy1tJ6JWebNEAtIDzwoH/0PtFuDa3ta7nnqo90uN
X-Gm-Gg: AR+sD12h5NailfstOJSHs+eHwIJCy+hWINbNmRtMXZgBJRXVj8DippNCDqTGsQKVnIz
	4zk4HhzLWvz7HYhfBdUB+OAkQA8E4vFBpvyauVpNDmdPCHc26uD9rGpIw3IXiduMCSAfL7l5ovR
	z27iEdjsaSWUZM8oGQlbap2fmiy3xz7D7xZYJzbbiDC5ZRUM49D0hOZ8/XITJTAnMgIQ56zCYGc
	o7MujatlnTIoycq1CukdFwm31DRXgXnwnv4BZ+o60yzTEi7y4iEZWT/QOFB/9X3ZGWMjmsi/4AN
	ueP65Lb29noNQI7U0+zpvCpXRowXSk9aPwFfHgxNyYeCY/cSiRaOh+3a3T1aFfRP9Dt8ZNPSRUp
	73lI5ZbCpCivMcjPzLsQS7fhG6CS/OxWPlNlCcaAf4WCVAxg6PlrbCWcmc0KfJecB4M4AlYN0Hm
	C3F674TB/gpW4xMsePtUAmKkTBtZ6rxzqYtFTFaHTUJmU6tJW+3ol9loa0iRux
X-Received: by 2002:a17:90b:1e46:b0:387:e0bb:57f4 with SMTP id 98e67ed59e1d1-38f2978d427mr191838a91.37.1784930541375;
        Fri, 24 Jul 2026 15:02:21 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:20 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 3/8] seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
Date: Fri, 24 Jul 2026 15:01:42 -0700
Message-ID: <20260724220147.214396-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qgherbi9qpskjh3yx3mwa3qm53eagcpz
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A2F821C000F
X-Rspam-User: 
X-HE-Tag: 1784930542-899217
X-HE-Meta: U2FsdGVkX19otRJ0fZ5pFu/HLUEb/5OBPY8gG6PKmyLP0MQsWnH5RWMG1p+YH9ze1oLht4MYaQuGeWYz/UQZYDql1a3wK/2wFREvZQgDv+yM5sJrkiChyqSSA0xaLY+14at2j1yEpyg0o32C8OdWlOP6UC/J3TNhrbUxRUzogmXFNnJ6+tpV41W+wSaTfAJ2N3124UUqoV0nUHJh58rmyDQi0MZnBlteU7VlX7PI9wyduMFNMSKjNyEePf5y9BFCNwpgYcODWagP8WfjQYJqRmcYUlF3U0wgyxATYtKK5CdoAwHU53oxiXAmdkiNdo3+lyIEF9YrD9smOvoaLYbF3qCh+Y+6n29LCJreXasKWqb/76EvEbGQn296WRKbYL8fbes8Z2Yu6ayj5MTOnrue6BGIMXgNrxY1DyuHjDrMu4vOAHTtiFEojpRo1ob6n3yhvlIkm7xpAd+5wPC+/H0qN10M1clOJB/yXQbFR0nxs5zSea3nz1CIvzfgMFonBVEIJXaK8x9taH2e/l96S300pAOjZbRnJlrWVns2HuKlmRvDapyRIxu/egfCMQzK0jF80e46gUG95QOdNRljb8aVSHV/V1WcCAn8hywf4i0E2MdKz5dLueUO+EKRNccDH92oh76OnucSayIDZFRiZNoOMKah8G/uiyo6AP1zrkfzyhhcbNo0zZk5Xb85JH3+uBNEcfuz2hXUayk/u15sOJzpfsND3qbRX1hmFOXoLaYTxH+iyHO6d31474R2oDWgyRR2Jgn+xB/yGEr3vMlxMOMeT6sxRh9t61aGEkAzQ9cvtHA7ae7zxX34IPTwD+NvPeVsMnPBYMvJVGBV0ubDuimXdWGW1lrfenHxCwFMC4ziC61C8Tavu9e6ZzSumKOCrwcO5IaidnHIwXWL1MNFAgt1Q3wLMcV3lgvbbkDW9eo7vTCfUicp/rKMU9roWnralZ/lBven3PnzVeIj3dlpafL
 mDRyUlfo
 Ids88IyIEzbSZlinC5DVBTD69RS9LCSHX9BLcNoqKiEt7cgdAgH8j3Z6Bv2RZldyF2tpn+xysO0+Gsrbcw+8+HIROM8Jk5H4UqqMRy/T679QaNXdfWrk9umR+CN2Umbb6J/UTOCFT72ub7mcy0q2aPptms2WCHqnd55x0FG0TMoXrbedtvyy5Kofv2iSrmIUOHqKyQWC9Kv0vlJ1rwWvi+4+mcAvrpNuGcedIzf4IZiif4JC/amBJ0FKjajsPf/t4O+Qu+ykobTWxL6J5mf+vkKRGel4uv15Ev5RxaevscgBHPe76S1QAYuJI4FVYiT4GiFm24L9zvIwWSbFHuwhclWTPh6CQSUr0pO2LPgCdvtyweiF3HjLBY+nOzf6vTk9ptv5iNcvsJXF+HvsKaxOkIGeTX2ONmSXm/oq3u1y+ea+UDqu72EmfbvgrnXYLIuFaz3v20H7JEIwUECwLo4Z4VMXZMmmcDZlHMS/NtJwW2W04xh9GV3R/tI73U+8rYO67psVzeG8R+ht9K00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

SECCOMP_IOCTL_NOTIF_PIN_INSTALL maps a supervisor-owned @memfd at
@target_addr in the trapped task's mm via vm_mmap_remote(),
PROT_READ, MAP_SHARED, MAP_FIXED_NOREPLACE and VM_SEALED. Because the
mapping is sealed, neither the target nor a CLONE_VM peer can munmap,
mremap, mprotect or MAP_FIXED-stomp it; its contents are immutable from
the target's side while the supervisor retains write access through its
own mapping of the same memfd. The install needs no target-side
cooperation, which is what makes the feature usable for fork+execve
sandbox wrappers (Sandlock, Firejail, Bubblewrap-style) that have no
trusted post-exec window to install their own mappings.

The pin is just a sealed VMA owned by the target's mm: it persists until
the task execve()s or exits (a sealed VMA cannot be unmapped piecemeal),
and the kernel keeps no per-pin bookkeeping. A supervisor reuses one
region across many redirects.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/seccomp.h      |   5 ++
 include/uapi/linux/seccomp.h |  34 ++++++++++
 kernel/seccomp.c             | 126 +++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 9b959972bf4a..a91d1fc8a2b8 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -16,6 +16,11 @@
 #define SECCOMP_NOTIFY_ADDFD_SIZE_VER0 24
 #define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST SECCOMP_NOTIFY_ADDFD_SIZE_VER0
 
+/* sizeof() the first published struct seccomp_notif_pin_install */
+#define SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER0 32		/* up to @size */
+#define SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER1 40		/* adds @offset */
+#define SECCOMP_NOTIFY_PIN_INSTALL_SIZE_LATEST SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER1
+
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index dbfc9b37fcae..d3249294788b 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -137,6 +137,37 @@ struct seccomp_notif_addfd {
 	__u32 newfd_flags;
 };
 
+/**
+ * struct seccomp_notif_pin_install - have the kernel install a sealed
+ * MAP_SHARED mapping of @memfd into the trapped task's mm at @target_addr.
+ *
+ * The supervisor owns @memfd and the kernel installs the mapping without
+ * target-side cooperation. It is read-only and VM_SEALED, so the target and
+ * any CLONE_VM peer cannot munmap, mremap, mprotect or MAP_FIXED-stomp it.
+ * @memfd must be write-sealed (F_SEAL_WRITE or F_SEAL_FUTURE_WRITE, -EINVAL
+ * otherwise) so its bytes cannot be rewritten through any other reference to
+ * the same memfd.
+ *
+ * @id: The ID of an active seccomp notification on this listener,
+ *      identifying the trapped task whose mm receives the pin.
+ * @flags: Reserved, must be 0.
+ * @memfd: Supervisor-side fd for the backing memfd. Must be write-sealed.
+ * @target_addr: Page-aligned address in the trapped task's mm to install at.
+ *               If non-zero it is MAP_FIXED (no existing mapping may overlap
+ *               [@target_addr, @target_addr + @size)); if zero the kernel
+ *               picks a free area. The actual address is written back here.
+ * @size: Size of the pin in bytes. Must be page-aligned.
+ * @offset: Page-aligned byte offset into @memfd to map from.
+ */
+struct seccomp_notif_pin_install {
+	__u64 id;
+	__u32 flags;
+	__u32 memfd;
+	__u64 target_addr;
+	__u64 size;
+	__u64 offset;
+};
+
 #define SECCOMP_IOC_MAGIC		'!'
 #define SECCOMP_IO(nr)			_IO(SECCOMP_IOC_MAGIC, nr)
 #define SECCOMP_IOR(nr, type)		_IOR(SECCOMP_IOC_MAGIC, nr, type)
@@ -154,4 +185,7 @@ struct seccomp_notif_addfd {
 
 #define SECCOMP_IOCTL_NOTIF_SET_FLAGS	SECCOMP_IOW(4, __u64)
 
+#define SECCOMP_IOCTL_NOTIF_PIN_INSTALL	SECCOMP_IOWR(5, \
+						struct seccomp_notif_pin_install)
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 066909393c38..e894af0e7c78 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -37,12 +37,18 @@
 #ifdef CONFIG_SECCOMP_FILTER
 #include <linux/file.h>
 #include <linux/filter.h>
+#include <linux/memfd.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
 #include <linux/capability.h>
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
 #include <linux/lockdep.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/mmap_lock.h>
+#include <linux/sched/mm.h>
+#include <linux/task_work.h>
 
 /*
  * When SECCOMP_IOCTL_NOTIF_ID_VALID was first introduced, it had the
@@ -1823,6 +1829,123 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
 	return ret;
 }
 
+static unsigned long seccomp_install_pin(struct mm_struct *mm,
+					 struct file *memfd_file,
+					 unsigned long target_addr, size_t size,
+					 unsigned long offset)
+{
+	unsigned long ret;
+
+	if (!VM_SEALED)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Install a sealed, read-only mapping. A fixed request (@target_addr
+	 * != 0) is MAP_FIXED_NOREPLACE: an existing mapping yields -EEXIST
+	 * rather than being silently clobbered. A request of 0 lets the kernel
+	 * pick a free area in the target mm.
+	 */
+	ret = vm_mmap_remote(mm, memfd_file, target_addr, size, PROT_READ,
+			     MAP_SHARED | MAP_FIXED_NOREPLACE,
+			     offset >> PAGE_SHIFT, VM_SEALED);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+	if (target_addr && ret != target_addr)
+		return -ENOMEM;
+	return ret;
+}
+
+static long seccomp_notify_pin_install(struct seccomp_filter *filter,
+				       struct seccomp_notif_pin_install __user *upin,
+				       unsigned int size)
+{
+	struct seccomp_notif_pin_install pin;
+	struct seccomp_knotif *knotif;
+	struct task_struct *target;
+	struct file *memfd_file;
+	struct mm_struct *mm;
+	unsigned long addr, as_limit, npages;
+	int seals;
+	long ret;
+
+	BUILD_BUG_ON(sizeof(pin) < SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(pin) != SECCOMP_NOTIFY_PIN_INSTALL_SIZE_LATEST);
+
+	if (size < SECCOMP_NOTIFY_PIN_INSTALL_SIZE_VER0 || size >= PAGE_SIZE)
+		return -EINVAL;
+
+	ret = copy_struct_from_user(&pin, sizeof(pin), upin, size);
+	if (ret)
+		return ret;
+
+	if (pin.flags)
+		return -EINVAL;
+	if (!pin.size || !IS_ALIGNED(pin.target_addr, PAGE_SIZE) ||
+	    !IS_ALIGNED(pin.size, PAGE_SIZE) || !IS_ALIGNED(pin.offset, PAGE_SIZE))
+		return -EINVAL;
+	if (pin.target_addr + pin.size < pin.target_addr)
+		return -EINVAL;
+	if (pin.offset + pin.size < pin.offset)
+		return -EINVAL;
+
+	memfd_file = fget(pin.memfd);
+	if (!memfd_file)
+		return -EBADF;
+
+	seals = memfd_get_seals(memfd_file);
+	if (seals < 0 || !(seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE))) {
+		ret = -EINVAL;
+		goto out_fput;
+	}
+
+	ret = mutex_lock_interruptible(&filter->notify_lock);
+	if (ret < 0)
+		goto out_fput;
+
+	knotif = find_notification(filter, pin.id);
+	if (!knotif) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+	if (knotif->state != SECCOMP_NOTIFY_SENT) {
+		ret = -EINPROGRESS;
+		goto out_unlock;
+	}
+
+	target = knotif->task;
+	mm = get_task_mm(target);
+	as_limit = task_rlimit(target, RLIMIT_AS) >> PAGE_SHIFT;
+	mutex_unlock(&filter->notify_lock);
+	if (!mm) {
+		ret = -ESRCH;
+		goto out_fput;
+	}
+
+	npages = pin.size >> PAGE_SHIFT;
+	if (npages > as_limit || READ_ONCE(mm->total_vm) > as_limit - npages) {
+		mmput(mm);
+		ret = -ENOMEM;
+		goto out_fput;
+	}
+
+	addr = seccomp_install_pin(mm, memfd_file, pin.target_addr, pin.size,
+				   pin.offset);
+	mmput(mm);
+	if (IS_ERR_VALUE(addr))
+		ret = addr;
+	else if (put_user(addr, &upin->target_addr))
+		ret = -EFAULT;
+	else
+		ret = 0;
+	goto out_fput;
+
+out_unlock:
+	mutex_unlock(&filter->notify_lock);
+out_fput:
+	fput(memfd_file);
+	return ret;
+}
+
 static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -1847,6 +1970,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 	switch (EA_IOCTL(cmd)) {
 	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_ADDFD):
 		return seccomp_notify_addfd(filter, buf, _IOC_SIZE(cmd));
+	case EA_IOCTL(SECCOMP_IOCTL_NOTIF_PIN_INSTALL):
+		return seccomp_notify_pin_install(filter, buf,
+						  _IOC_SIZE(cmd));
 	default:
 		return -EINVAL;
 	}
-- 
2.43.0


