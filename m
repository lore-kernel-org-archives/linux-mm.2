Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 656FDC44500
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B806B00A6; Sat,  4 Jul 2026 19:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE226B00A8; Sat,  4 Jul 2026 19:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DB86B00A9; Sat,  4 Jul 2026 19:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6AA6B00A6
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 859411C804E
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:07 +0000 (UTC)
X-FDA: 84952661934.03.F0C6C0F
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3013140004
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TTrCA0wO;
	spf=pass (imf09.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4ieKVIWYtjITdsZQG6XsoZ4fXWdYpY0XZnQZWHxe5E=;
	b=6I4OmYNQ93c+0VGHxuvtwQTaBN6oXe3Hp3jBXHAdj2oWGaSXRSL6UjjnZofHBC9jx/TMB2
	dHETFAeXL8Dn7nk6ykCnPXDnrMzY+iMEc7oX3IfqvH+vbtH0CAFoRsX5ZMACVpDmikCtUt
	71OwynIOptK19UJPAvmVnVWlVaM6cyE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TTrCA0wO;
	spf=pass (imf09.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207145;
	b=a3hvD9Rq4KKX9K//ncg1Ont+tutWPb6C8o6N553q0bJ9sYPglFQO+CkM4ONgXFjN68qm2j
	Saoyo2mZ89nvov2nC0AnllVNFjh2FmsKlLoWLXMpkgv9bHTHUlurSf4QEPkBdbFnaGY816
	rcfTVbvipiSqrNsfuXRwo/58df8cimU=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ca1479dfe0so20002845ad.1
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207145; x=1783811945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4ieKVIWYtjITdsZQG6XsoZ4fXWdYpY0XZnQZWHxe5E=;
        b=TTrCA0wO6UZHp/ZyP8WI9a38YDowD/rsALmn4HQVbIOYKvZwo2C2bgb8KOW6XFFaNS
         70jpfUBuUgpaxSg7bk2KXYL9ImONckuSMM7ufOyrqptSxqdrzADtb+znUYgH8bir+Jrj
         /vYoCe4kA0rnePABuey3Fqzv1YUkPr4y0txHLogPwTNiLqWmfJl9SGiL9wWu3xsgc0vY
         1gFo3S1Wmz/c9K3+894SQGarOSBTFzpkaurHVZSXT4yjKE9ldaVqvuc/foSpDuBZ3mBc
         t3ew+5ZVDxmP5wiWQFE2gD94bNdvAIiN0CvBwtIzwp1zLScXmQvg9CbHXeXzfHMFnd+S
         NJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207145; x=1783811945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+4ieKVIWYtjITdsZQG6XsoZ4fXWdYpY0XZnQZWHxe5E=;
        b=pQkLGK3GtNzZiqy7JcYL+xcb/lZ/+qTwwQ9fb5gZXD/Rr0ks8yJeCGWWa5WsWRorvD
         haed+M0Ah59VMk01XUnjdFtv6jhTwpVWBEdQM41a1C1tH5RUFGfTnjSmcr6uhVGPPodm
         lSxFw0QMMAfrOOjE7p1iVD7p8CQ+95/yNH0mlUVbCQd27qqzp8F9VNSCAC5LpwFh2wxZ
         QCs2K1AWkaQ+39oM8KLBKB4PU17p0RnYa/TbIb2vvy+3mBCJqVsD67FzyB3RP5T+0AW5
         CDPWIykW0gEmYQLaKvUr6XzaQ1T2tha30bxc5wzwl5q0Ys8PkN3qSplMK0ukL3E/gQV0
         vvVA==
X-Forwarded-Encrypted: i=1; AHgh+RrCKZ+T9kD67CvgtXhmRdqFfjzbAcX/5fniYX7uHpubaJwRxr0mnOF1kJuLOWqyAOGLCRz8vd9Few==@kvack.org
X-Gm-Message-State: AOJu0Yx1Ua3zpmORGvFM3czz24p4GLqblQanZvw2cPSUH3kJV0rZVXwD
	2lHSnHCv1kkbM+Dm9hIcZZNXnkSuHNhBHZCHrZDoOr+nbD5Cv0QkG8O0
X-Gm-Gg: AfdE7cnamx4oz3SkasErDbWvzjAf4cvhZVWCxMNmGErui9M6neMr3QUyab4Md6FjB/v
	B/mWxwStVQ4mmnnftGrDnDg0cfLYRkScRBeDkFPaMP0SoVIf6SYKp6dSp+UmNq/oyA/sAMvLvSN
	fHJDy1ef5jGO0A2SdPlrQ7WHNbFuE3VLrEYVu/WOm76KCmAG7e8Lngbjy7Pu8E/jD4Xu2ebjcjK
	LvfJ88RLalWWfeGu8VewJrocm82VyG7+ETaqAEjy7xYZ03KMWVidCqJQWD/r60PiQkkNL/SOule
	efDUCGSZ8wl9pZf74EC/2KHv7A4i4BVQEIXzDQQTYLz6idJwK6zwzB55q0zvA3C3eeaT8qdL+OZ
	72lvw9JAY98rLiavvZkZxEwlws8BTVQ1gAgOzpWtPeXGOpT/i9ilAyuFqX/iXViVjua6/GJQpVl
	uwou6QsooyH186V88Xtq0zRoSsg2hJnMBn8N5PerHdL+mzMB9Akw==
X-Received: by 2002:a17:903:9cc:b0:2c9:e86e:a9f5 with SMTP id d9443c01a7336-2cbb9e4cfe1mr46314435ad.18.1783207144512;
        Sat, 04 Jul 2026 16:19:04 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:03 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 2/7] seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
Date: Sat,  4 Jul 2026 16:18:26 -0700
Message-ID: <20260704231831.354543-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xe55rohp7ugr1wsjpqmp55b46d3wk9i6
X-Rspamd-Queue-Id: C3013140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783207145-584326
X-HE-Meta: U2FsdGVkX184Cx3xzGoAciChYjWRaQ9YVMtfCjK7rdhH7rlfQq17t4Y3DZb9izs6UAzaUVFJWNAwzDFOWZ015fof7lCHMD7OpHAAVrwSLZwck1dVU6sAJoK+L4QB3yXPR/XIsEM1XrXpVdmvrmhC3l9mqQopN7J3XBpF0Iq2nxQnO999LF0VNqJNSS6uWOQgJV37rz6vMjIkA82Y5VHc0ykyYAASy+e/hJ7mH7MJVaXAUNDO3ZMscy2I+HNst6QQI4Ta3+PMOn+tMVPnMuPPQw8BA87Y3RG/MZ9AE+CcaKA4Ston7H7k8aa4e/b87bBBiiJafgjHL1WSaiMOUlLC4K99Xo76knUZh9awBTISlLA3vjUSP8EeWo1/jdfPaYVf1UJwk9e48glLQgMtIFp/Odt+VZMdEHwHdRdQCHidQ7wkT4zACPT+EVF6ZfkXgwIW4ziQXlIGE+7AR8SMn6c4XEtD0x4uDvJdNbDAuBQsq8JMCRtWAFxTWQhLH8P6JyRvtIerbwZWyf8HeMgIkYtfAydiA0Xmre6DO/qWGUlA2Z6ijxsKYzG5WiSDPQ92yn+0bJaSvZRPBDPCeZ0Ko351Ky/YXs3VTqZCP4ACVU3QKNIexU1TcaIqukw8gUEwzyVpwfgT70vhzANTf6zFz5z9nDC+pCFxTTIbEmoDnJ3g7Yc4bWU7sOFjJRhcEC4mmmyLt2lEnVPWUUS4vQnLwOjQ+X5Ux8uk0FFCC0MHPjm0waDy8Y2sYK/GQPCMplUP6HigPECp3ohG3fzW/7AeRVbJAG0K7jdMSSApJ8sLR91svc7wUesglTtssHn2IbfwQyZn5bskq+aeHunjYgR6SrPgr3tSGSF6SDmGOpNDeamLw6NaK29tsCA44zUnaoT5hADNqI7QuCFqK+tDfpnWHCz+KmqkCEqSQPaYV4fRxRzQREFlIO+6jU5N3/F5orvVoOmbqr3GBBcoUD5HwzbQHih
 +IvqlDxT
 ENLkAAtT5taw6OqXa7RK4bVChFc5QL0LTBDGfvLvie8gMJWg8D/LJoJDr3L7e1/X9oNwV9mwUXswBUo+KaeL+DFAI2YtByBU8PnHCESGDc2CTiK/OCJHzoKSUEMSqi4yXbCl3pRzd45leLnJ0fxl0F1RxFK4rX2IO+7uYzwfN3LqMwCypF3LFxO/nmMqUEbRF21VXvMp52R2X8z4VCqDo6nHyrJ/7s2TMr05KR9xs37gt8jOk2y8XdqSV9nm02TvaIjTTyV8GqI61Xwn+ZGKi2OVNV5lRPUbsAhwrp2JLP+tf8sEpKyeADPQW6zrnuZCclptXGPqT1dHaiST+pyNpfv9oBEwHN6ZvzZX+zsIVDvoB1j7+gwJ2VHZPyYUS6871g4bSxx2aZT8sPI84xylZ8vpKJ05cO7Y4RUptvtDrMP7P1T3LshgikUQTpG8rYBA4/bTRTW9VL5Koya9q92fXAih0LqG5KQiOELN6uf90KOAGwmX/Ian2bc5faz4VG2TGtZyTfao62PysTXs=
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
 kernel/seccomp.c             | 121 +++++++++++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)

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
index 066909393c38..1c0b3bb71379 100644
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
@@ -1823,6 +1830,117 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
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
+	if (!VM_SEALED)
+		return -EOPNOTSUPP;
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
+	ret = vm_mmap_remote(mm, memfd_file, target_addr, size, PROT_READ,
+			     MAP_SHARED | MAP_FIXED_NOREPLACE,
+			     offset >> PAGE_SHIFT, VM_SEALED);
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
+	addr = seccomp_install_pin(target, memfd_file, pin.target_addr,
+				   pin.size, pin.offset);
+	put_task_struct(target);
+	if (IS_ERR_VALUE(addr))
+		ret = addr;
+	else if (put_user(addr, &upin->target_addr))
+		/* Pin is installed and sealed; we just can't report where. */
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
@@ -1847,6 +1965,9 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
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


