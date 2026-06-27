Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D53AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 01:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AAA16B009D; Fri, 26 Jun 2026 21:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4129A6B009F; Fri, 26 Jun 2026 21:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0776B00A0; Fri, 26 Jun 2026 21:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2356B009D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:22:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A4691A061E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:55 +0000 (UTC)
X-FDA: 84923943510.01.4B6AE6C
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99B97100006
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:22:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eNhR0OPK;
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782523373;
	b=SwRBcseHqNyN8dDeJrwcu7O7XFbQdgCFP9W3zN2kQuHir+unAlpZmKmHQ7fwQEEdMUH5to
	5UVA42CZ8guRzT9i2GmqvpGfVL4pHctp0i8/TK67z355+YOaxSEZUj37LHySZRhtYKqz2R
	7rwsId8WZeAZT3sFVu9jizQtYzbCqRM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782523373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxxBMw8gFEfs376EipY0Ourc1Enx4n+0AlFgEEal9Tg=;
	b=gIZ367zuKGKtPfehul+/pNt/ONCFPjRXNiJ9eD7YyBAhTE9pxEtkXXeuGAi3w7DQmDZBCk
	7+ro4dnAMB78CueyZ+t4Q8wOHBDE/EO/VvxzdoRLCp+Nx3wTaAgx/THzWjzLGaqB9zMvQl
	kHStrYaGacsezNtF0nsLCmkEA//1dn4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eNhR0OPK;
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-139f1dfc9faso33389c88.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782523372; x=1783128172; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxxBMw8gFEfs376EipY0Ourc1Enx4n+0AlFgEEal9Tg=;
        b=eNhR0OPKUXD55lF9hq+k/YJEMFFT+3QHaTxFMjkVPL3zgsZoA3AAYw9mq6PPMU4OqE
         DlDSzqItkW91mKZNmYq0G5KYEPAJ5FH6HXJZd9MARC9b5cr53DwXMWPh6wCTOCdirKEe
         KBpg8dD2GfG2r/gWAOAr55urb+Rox2rpSs07jDMwJNXg/xAvQWqyqMkzgdIdZN4KPz2h
         piLViD32oxeqvMjmsL+ycKWUmV+BwymgkXXn2HEpu11LlaG58wc+U+FAYSUW1DwFWC9o
         yY3+y72KBulRME/GOwSoqTmI25jB47gkkt1vRwliom+pRBSn6/YLH13u6tsmnzgAjbU2
         9fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782523372; x=1783128172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gxxBMw8gFEfs376EipY0Ourc1Enx4n+0AlFgEEal9Tg=;
        b=tJhWK/lJbWIEtZUI4uRv5Vb23u2qK9oBB1Y4eIfnJ8T8v+qVyTSetqjT9CAVtb457P
         tQKNcnw5s/35xAgdtdp+k5fVLiUv7pkGC2fbzt+lMJ76pGT4QraFot4+ABXTfuBNjmMd
         s28bUHYyxS9JxTD5lZM2AAS2sfICUH8FppP4iiagengad0eVtu7v2+WafuaI85Czz6m8
         VvIgaMyb4uIZudmGEpuMvaSFJ5fsiMDi3cHkr2huxMVi1uTXs0Zlqic/VphzmVEq/Gjo
         ff/mwy4b4MoWT4KTIN/AafQAmIv6OLtFnKkRF+9qncSu5Xf//pzvfiaeV4Za4WEYfgNz
         PsJQ==
X-Forwarded-Encrypted: i=1; AHgh+RqHLXWcCQv5LpVFgvbGbPDyb4uFNOoq57DGgRvgYBuiuUDLKU4sjl88rJv7TRWFBHMlbJM0kC8Bgw==@kvack.org
X-Gm-Message-State: AOJu0YyZDju/mbKs6LPl2Q7rIQ5wV9OzxJWALnskDz8FzfBiI1z+hiAT
	uow7X+CiDFAe+/FlNhQfbVhW06dD8L9UfYfV1cj1txkvRXck3fK3Wtuo
X-Gm-Gg: AfdE7clBLFH1BWaA9Ptf6TK21pV6ZLA+/QITNAwlw/jngAWbhmUhTZb/AuAkga1VODG
	gaxv9M5ZqvnJxvcwou31J6X99trLhd1Mn1uTgoqv6DWrJgjw2tuU0Ml9pedohaOrrSbEl0nTvx7
	ZEmIRRMdqRYA4zAHyxnXhvAlksUCE04Iq8hnGLfAXiZS8L/ONYlijJJB9NW1KSGo4/YX/iOA8ZS
	/NDnqZR3Mkn9ipuLtVf5UzK3l1b1eyn/PBnf/86SUYOwJ7/jTeCVYVFMaOgx3nxfuxYwUfYtPdL
	8bSwzEJfoMSS2Zkh1m85GKPReSzTs3TAiFekEOtpQinHhAWbIEl/XHmcErC5el6ddyhat+GOxee
	iAJH7yCJV7xOkEderzgEq3nkFOm6VjGDZY/02fdgnchZ8ZtXZn1MabqTE8gtM+9coM2rS2l7mPl
	aKo9oFpO1UjwllphGIYeTE4RoxzdAeZ2fgIjdaAXnpLx1o5VVb
X-Received: by 2002:a05:7300:f602:b0:304:d75b:f5df with SMTP id 5a478bee46e88-30c84eb7db9mr7021813eec.19.1782523372367;
        Fri, 26 Jun 2026 18:22:52 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:fe0d:366d:f00:1840])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c9e9214sm22883437eec.20.2026.06.26.18.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 18:22:51 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v4 2/6] seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
Date: Fri, 26 Jun 2026 18:22:15 -0700
Message-ID: <20260627012219.1079851-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
References: <20260627012219.1079851-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99B97100006
X-Stat-Signature: r5o9brcpa1knh7mgfyppm4norauy5qkx
X-HE-Tag: 1782523373-682302
X-HE-Meta: U2FsdGVkX18BJERjVxWysKkD2Qq591jDDSazTdpOvBoJQ/juwxw9DE37KEjMr31bJhSNzgxtNPIdyzeSpDoQSvYCfToUaxFfkj46UfILPAUZKoKM7IjOvKxXYSO/m/uc1ebBHOAm1owZamWbaWCake3Xb+cPtjO/0WvV3FFpcwlfhgTPrW0kcQ6SHubpUIH/xEyDPOBlUmxQP8GxcozSa6KgBh4Z0rY30uGIYthujoG5pqt6EeW56uTxQy4scs0+d5uBkUWvv8bgAt3S54EMv03jAIYq5RN7/jR3crZPGr7FKm66OueMLiEwOSN2t4gSMATYQPmwtVdwX7ceJLsGvea/j9RskRKxPoVqTUaPn9ZApM/Wi0Yv29MgTT30OvBUmA6TP+w9ei8XNZkbKHBD8sdE3J0k+cAk8i/Yz0MqBYEJsH9aW2pLqtZb//Hz434MnHdCvO1yoKnZntkAOEoNMyJq10R5CDmVxVU1JCUspSAJmGvr1bVlww6eAZnuwc7/fPw51XOu9xZtk7A3bvSthuDvNNolXY/DheR6PYL1dUZvceicANenP5aihItSygS/l/Ag2yMduWQyRiPLcbO8Tw8wgJnbe0Dce9rtXXDtnYb5ZkbkefvKdJO4FhT2RMnmirNa04IBnPQVRdrW0954h7cU28gQCoUaecToAF9N3iB7TA5LDvBMkuEfEgS/CYQocceoTAQbVXg6myu0/769Pi1++qnGnJr3yyA/v2c2tmuC8y3vdlfqHQ6cD4TtDsfeNFaYQcaPqeJxyXZTKyUrSATSHv2IxY3ysyCMaZSF0hx8XyaY8RMZUi7nzwQ3ljhcqvZLO9QtPGhhA6cKWnzNz41324qQcKdOa42xLUaQ3Mq769LFdDW87JxpFXSsTb47JS73b6Hyw8LU+zt1772vfUQw4DyejsH7uHeCdiHe3BlK36rMDFeuiSRYr9WYrj8Pl6eGK6uFqYMB3+pNsEk
 8V2RTvVa
 jZ2WMzXzVPsjx10+GfLRi2D5zq5rHP9+uMfmpV18fECzK0OhFIQmIKXipXOZ01aqI04t51oBbO8ZKAoTm2DQbMaVRN4EiS7idupnEuoZwSGlEupinc493n6DllcUF+wEefUrd3zNmFyUbnEp1gl/QdqztkBCujLAsCnUb3fTJaG9/oPOLm8VY5TD6YSiNXIdWXkvHSw/jFvqt3xPUjEhxQ16We+wP+1TYhGdmSAxzx2mJwXk9ytegdaUnncN7xMkUwZk7EBrQfgHGSg3mHxRFQd7I+X0yDN4bqvYdjByjJiJioMFLscQkkNezBibCx8gFBadRm3mHxl5UjI6eSqfWaNv7K7ukxSkBfZIuUTP/hqWMJ3OykP17P13984uYgmiDaTYQHwBfO0UNd0XjZmnyZ+BKs7V9XB0yQhk0lrgrwXlkGmohpoKjnnRgXT2nsb+tqRhqJzDB3YmaKbFRqVwfZNqNiWNogEFT6MGTmHZta+a86sgVqy0wOw+xxs59L7MKxLL4YtA5TjrObnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

SECCOMP_IOCTL_NOTIF_PIN_INSTALL maps a supervisor-owned @memfd at
@target_addr in the trapped task's mm via vm_mmap_seal_remote(),
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
 include/uapi/linux/seccomp.h |  54 ++++++++++++++++
 kernel/seccomp.c             | 117 +++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)

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
index dbfc9b37fcae..cc34188f8aeb 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -137,6 +137,50 @@ struct seccomp_notif_addfd {
 	__u32 newfd_flags;
 };
 
+/**
+ * struct seccomp_notif_pin_install - have the kernel install a sealed
+ * MAP_SHARED mapping of @memfd into the trapped task's mm at @target_addr.
+ *
+ * The supervisor owns @memfd. The kernel installs the mapping into
+ * the trapped task's address space without target-side cooperation
+ * (the target need not mmap or mseal anything itself). The mapping
+ * is marked VM_SEALED at install time, so the target and any
+ * CLONE_VM peer cannot munmap, mremap, mprotect, or MAP_FIXED-stomp
+ * it. The mapping is read-only. The supervisor retains access via its
+ * own mapping of the same memfd in its own mm.
+ *
+ * @memfd must be write-sealed (F_SEAL_WRITE or F_SEAL_FUTURE_WRITE),
+ * otherwise the ioctl fails with -EINVAL. This guarantees the pin's bytes
+ * cannot be rewritten through any other reference to the same memfd (for
+ * example one the target reopened via the supervisor's /proc/<pid>/fd),
+ * not just through the read-only pin itself. F_SEAL_FUTURE_WRITE still
+ * lets the supervisor update the bytes through its own pre-seal mapping.
+ *
+ * @offset lets one memfd back several disjoint read-only pins.
+ *
+ * @id: The ID of an active seccomp notification on this listener,
+ *      identifying the trapped task whose mm receives the pin.
+ * @flags: Reserved, must be 0.
+ * @memfd: Supervisor-side fd for the backing memfd. Must be write-sealed.
+ * @target_addr: Address in the trapped task's mm to install at. Must be
+ *               page-aligned. If non-zero, MAP_FIXED semantics apply, no
+ *               other mapping may exist in [@target_addr, @target_addr +
+ *               @size). If zero, the kernel chooses a free area in the
+ *               target mm. On success the actual mapped address is written
+ *               back here.
+ * @size: Size of the pin in bytes. Must be page-aligned.
+ * @offset: Page-aligned byte offset into @memfd to map from. Zero maps
+ *          from the start of the memfd.
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
@@ -154,4 +198,14 @@ struct seccomp_notif_addfd {
 
 #define SECCOMP_IOCTL_NOTIF_SET_FLAGS	SECCOMP_IOW(4, __u64)
 
+/*
+ * Install a sealed memfd-backed pin in the trapped task's mm without
+ * target-side cooperation. The supervisor owns the backing memfd;
+ * the kernel installs the mapping and marks it VM_SEALED. The actual
+ * mapped address is written back to @target_addr (relevant when it was
+ * passed as 0 to let the kernel choose).
+ */
+#define SECCOMP_IOCTL_NOTIF_PIN_INSTALL	SECCOMP_IOWR(5, \
+						struct seccomp_notif_pin_install)
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 066909393c38..fa0fb3c960a8 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -37,12 +37,19 @@
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
+#include <uapi/asm-generic/mman-common.h>
 
 /*
  * When SECCOMP_IOCTL_NOTIF_ID_VALID was first introduced, it had the
@@ -1823,6 +1830,113 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
 	return ret;
 }
 
+static unsigned long seccomp_install_pin(struct task_struct *target,
+					 struct file *memfd_file,
+					 unsigned long target_addr, size_t size,
+					 unsigned long offset)
+{
+	struct mm_struct *mm;
+	unsigned long ret;
+
+	mm = get_task_mm(target);
+	if (!mm)
+		return -ESRCH;
+
+	/*
+	 * Install a sealed, read-only mapping. A fixed request (@target_addr
+	 * != 0) is MAP_FIXED_NOREPLACE: an existing mapping yields -EEXIST
+	 * rather than being silently clobbered. A request of 0 lets the kernel
+	 * pick a free area in the target mm.
+	 */
+	ret = vm_mmap_seal_remote(mm, memfd_file, target_addr, size,
+				  offset >> PAGE_SHIFT);
+	mmput(mm);
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
+	unsigned long addr;
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
+	get_task_struct(target);
+	mutex_unlock(&filter->notify_lock);
+
+	addr = seccomp_install_pin(target, memfd_file,
+				   pin.target_addr, pin.size, pin.offset);
+	put_task_struct(target);
+	if (IS_ERR_VALUE(addr))
+		ret = addr;
+	else if (put_user(addr, &upin->target_addr))
+		/* Pin is installed (and sealed); we just can't report where. */
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
@@ -1847,6 +1961,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
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


