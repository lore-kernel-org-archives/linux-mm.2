Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6156C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A116B0098; Wed, 15 Jul 2026 17:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041B26B0099; Wed, 15 Jul 2026 17:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87986B009B; Wed, 15 Jul 2026 17:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A45386B0098
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16549A02E0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:42 +0000 (UTC)
X-FDA: 84992280324.08.FE74CA6
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 473491A0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kX3k6J1Z;
	spf=pass (imf19.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150440;
	b=O0xLeg+pJcKy1qznniG7/zlnx7ocdqoJYUPgV1gmDQkMhaS9AdiO/Rkcsbe1LG0mO2Sovr
	2azw4dnwvDvCMZt2r0XGHyEI5U4z03HkT8Q5bY8oTXF9k7pZS/zikW7A4u0XNVhBpag8Oq
	pAnFerVvMpOjNouJVPPk1w1fRAgAKFE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kX3k6J1Z;
	spf=pass (imf19.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTYN1EdnS3u+jFml+k8yDF3B5yGEfxNc1Hkem9/96js=;
	b=W8ti1zJwU+/bXmxMn/pWMnsZPjhoZTuBUP+BZ5NuN5gOdOgAt7yiwWa6Dps4DvjAej9rmw
	hoXVckqNhm7oxU88txK3CCbvOMFzdxvKSkwKQF3rhFYb6Z9vsuZ04Xh94grktjM7BMCgV2
	tQ9hxED/MNVyRzI7+c9v1q6lv0HxOoo=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c89636920a3so1542407a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150439; x=1784755239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MTYN1EdnS3u+jFml+k8yDF3B5yGEfxNc1Hkem9/96js=;
        b=kX3k6J1ZhtiUbygWxurh38SZbUwhQP2BYHXe/ShTwGounRjZY5oJ3Ysf3Wa3gxhwfS
         Flaf/Kq8UjGB3O0BzkfVKWOWMuDzbDj2uIsCZ71dQ/cjzO27JtgbYO7aHAeerFLAl4bn
         6+eTmzi11f+3QskzFA5Zu2RX6rmAY9JL+H1kBm7WF3T3klhmoDvzT+8Y0t5pz2vfgEDS
         Qb8uPq7cxmhDjC+wWDnhqZNAb4bB2Gv79oYVj98XLBMxyhAocXKA5jPaG45V75DmmUDe
         w9HTHul19D/0YUZ0l2yQvLXpeNGGiHtiu8E2JSn5zAvvSNmqdcM9yYGOytwl6cE8qNPD
         CbBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150439; x=1784755239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MTYN1EdnS3u+jFml+k8yDF3B5yGEfxNc1Hkem9/96js=;
        b=TNDglp6cOPnTlK8mSTmuD2NPKhgL6BfolVTjBgCmkZpuiGV2cMRsMdUMwhUkrPN7nY
         yC07Hf61Uz03YCo29K6gXZjOil357VZDW/LtRn/ALPSsYHSJt2vBK63w3oQWZI89jHHu
         BArIjftwj3llXEr72R1xc1npRkgVyPglJqlWkTeXmdvbtxcM9Iw7jjBzkeWTvpHtzqSI
         b4D3xUriej8zUKqILeAT6ocO0HUCwpAbIJZ2i2eMq5dj4XOaVVFZdjs5pHAOlymR273p
         CTLQxFmyqkIbYgKd39HohYajxcQVm1Mnb3D29lv9KLnJrUPuyT2reF29mkFjCfpKTua8
         2ApQ==
X-Forwarded-Encrypted: i=1; AHgh+RoatwzKNr4reyYBGgJdljB1TrSdCehB28o26q6InIkfimZQJqL+hO/uWio2FcfVD4fJ6wORIBn1lg==@kvack.org
X-Gm-Message-State: AOJu0YzsXQINDR1AOyRgM0c1i7v0GGK+qEpbb2YtjXmoqIF4DNdf4t32
	c0QBEF+4G6v0BFeK5diRNd8G4PSbb6hK5lh2bb10RoPlfq5P9O4O0VRN
X-Gm-Gg: AfdE7cn50eAX9byYCMycmti9SFLfKzU0d0i0zy3HXaCBd/8lNjVYhDF0KgTYaLq4Rzc
	q085i42drvuX/OxY+YF5wQd8J0Sl6B8fTq0FCt3wRcO0GLpX7IByYagMJ447HJSIV2TznK6dhE3
	iz73uLkNNkklzkkiJFgkuMPX66DlzeVqoIB6gJTtdi9hgSA89+L4U1L9llSV0/5j5OtacjJUX1P
	ooZYpxUbXUjE3FxzyjDjJFqS8OGruGcNM7gffnHNFV/ITfN6+ybaepCsX/mnTZRyXzXVaUTFk5q
	0QFl/crorqAc/5gHK6y3tge7xdlFI7rhdOoHxNvndkz6lcA522TnT5+gzsgTwH32ISOTUSfur+Q
	XIqgV3q4aDuvDJNpAu4wxoctliW7e6yogG9xUBiBgRTJqgaKSUPnNQPzcjudqKlu0SvAvFEyna6
	+7ap58+0I//bJVpsPj49mA5h3t0ejX/55gWNbsj9GfMoQj8l8xcU5Q6U6qWw==
X-Received: by 2002:a05:6a20:431a:b0:3c0:b766:7500 with SMTP id adf61e73a8af0-3c110bd8c49mr20507246637.68.1784150439126;
        Wed, 15 Jul 2026 14:20:39 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:38 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 3/8] seccomp: introduce SECCOMP_IOCTL_NOTIF_PIN_INSTALL
Date: Wed, 15 Jul 2026 14:20:02 -0700
Message-ID: <20260715212007.2382846-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 473491A0003
X-Stat-Signature: qgozdchfh4r4fcj34jzo7qpzwj5ghaes
X-HE-Tag: 1784150440-817536
X-HE-Meta: U2FsdGVkX18Spv5yJZXX6NYzkZXcDGnzaI+lk9AtWxsHJt3htunJjhupfm4OJX/lBtLR1JOGQ1fSlzxxEJDxorDhb1tAMEEG9HvGc/F0B31fMvUvuKoPs18fYosl5Yi3+oZq6cAfFO1jgNkAYthEy2lviNpJG9PcFYs0FmMvHaXSXLv/799isSQT4kgXePv/zBR/kmUjgf11hrO0egsSN4HEAIa6q1pu0fi8wg4U0LBN/1G211himlsHcQVPGrMWzOycyNN5FxpmiuBspJeZ1OefdDdy1+BTJztZGDMOfQhAAS4EXCB7t0SJcPNr/nzEC/wdltpPpw5Eg3IY/g7onZWaH2Bm21CMcW6Dy0b0rMyI0dMmmTdYJDNcBZqq5ABdjpN2rd4WEVVTRQUEORrB8KcDVul7ahM95mh7/GQ44m5PSg+jDoyh29vvAVIdFxyen8C506/YBhikwhXVFNz/rqx6GA83DAgDPzK8j0wexZHg7jM5pJISz+tcpD/CqPNWmft+gEE7MqvIjs2ggVOPFaCakIYKpldZvOTJr9MGEdUPd654AoADfcOSNWwFhsXoG4U064PYzM2oTiXLs2W0F8PrnJfeALTMTdegKo4pcFlvZZNptfGUYjPKgZN01zBKN+01Lm9pWBc5n1kE7Bm+Ij9rbNXP7MJVvyko1AS1frAHFyDLxxUbkFxsGJjaHwZjPIyV34BLtEMpCDU1Yf66wgnT1+YYZeZao4Qu/OzE//vFEPVq5rMUcKelw0YK6KQ5fsXrUFWak/BsootI0wWkFnLGVo5Jx7ZfCZdFUXKw32qaINsfFrFHkU3pLetUEcLq7fRPMR/v7O1TBEbjFQlH8kIH5SkxBgfWN9DVaHgsUE+a89sv5pFoaR++tHVHnIiwpnBgQtUc/34XjwmMVg/UI86P5lUjc+FT1h4lnVpLO9x1dwjNlDu8XUBItqYX2d5t8UNTriwpaPZvI0P6G7s
 aENTTExy
 /0jo1GxdrR6Dr1j2GEOL2PHfTGhqvlctwXyESdWQpbYMU4ls20pl1y+mvNz6W33VNJ/ua5CcvWrCQatq6SNPN21kXxDTjMBaKllEb9220R6Ea7iAq3Ci0QPxB16CSKPWpDURAinT5+8gzMHR4EkWIGZ2iRzCCR6BgS++G76MdvMOD1frJCSDCza7V4+EFLVEvdaTLCFW84O0XiU5BoMzbzuA7GhdRs82Fy0RMSB7DnbUAJbXX5SRGg9ZBig4s9H47ToIJ6zTgjXYqf8rGvYWSFmFYRuv3HwFE2jVlf5o5czXr7sCfPnXBzFsXZCq6ARvKdAEFbjdzJOJ/FzZgHgjDQUR0GDQUlk/nJIx3y1qMBIW+x3M3NC0Y8GhDR1ROvj7oc9jkQRStokExzr9KCjkXD11UYTPbj8QOWKBYGYfzK6ERnah9WQjmQySvyOdYSAGD/PY72nPpbGxdqvCEKtnk1e7O+g==
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
 kernel/seccomp.c             | 117 +++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+)

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
index 066909393c38..12135c5df9b1 100644
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
@@ -1823,6 +1829,114 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
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
+	mm = get_task_mm(target);
+	mutex_unlock(&filter->notify_lock);
+	if (!mm) {
+		ret = -ESRCH;
+		goto out_fput;
+	}
+	addr = seccomp_install_pin(mm, memfd_file, pin.target_addr,
+				   pin.size, pin.offset);
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


