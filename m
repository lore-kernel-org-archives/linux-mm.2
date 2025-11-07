Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616DDCCFA19
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938A68E0008; Fri,  7 Nov 2025 16:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B888E0002; Fri,  7 Nov 2025 16:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762FE8E0008; Fri,  7 Nov 2025 16:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF188E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4A6159BF6
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:36 +0000 (UTC)
X-FDA: 84085042272.16.9C10C7D
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 14E121A000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hE1+OLje;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zu+sQZxV/DK1mZF4LzYMVwMmIZV5lUcGvIMy5Jfwns0=;
	b=Z7iXK9BuPlVI2IEy9QrGA9kV4nRVHLxuudIJ0AtDC1weiV99BhvvDOrlizcC7xBSi08fcp
	Ma/wLtTeqb6U+wDivRAL/lgMJvea3FBDzn0fXyoctYCmxCNDoFfMwb/uNqwjTt3QZoTfkH
	dDpIRA2240TH1EQollXTzFDoqz25g4A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hE1+OLje;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549535; a=rsa-sha256;
	cv=none;
	b=YLYoQGQwlFX7wyxEyJHO9/AHxIH3q+OhweTc2j/U2JT9ocX4x9STYDs2dvgTHwnIHd9S2e
	KD2ONShsz8T9Tde9P7mmml7EMGyZTHzj5Acg15YUZJvY8GZbV7WgoAYd75cMb8d/MWiLY1
	Biy3GNy6ufpaSVCZOacXBeB+6tPoCjc=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7866dcf50b1so11447027b3.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549534; x=1763154334; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zu+sQZxV/DK1mZF4LzYMVwMmIZV5lUcGvIMy5Jfwns0=;
        b=hE1+OLjelj/17bsv5Mr95Fht/IYp9xzOlcM56oh2PRe0B+OkvWdAxm+VolsQfZFEo2
         LqPaFidg6jdMqg01bZ3cx/COika4PaXGtwHmW90jiI9EHlPZFVLye6a86UYe3k7qFynu
         MHCaKzmDpqlg6YL8IlKOOLjD64BNIQrYfYKlWOJb2zWmznljqhGVFgbBzeUYbm5awhCB
         bCAoGXeb4gNjqykistqtLHNERPBTqrboe8LnfwH2zGJud4Ms/HXnDKLG//u726S6KhLf
         ZhTib4B4uMWVhdmj/g+eK3zoQKeWQwn7Hn5PZAvaCaZJuL2dMjpzPhHcGrg7kfrzqQti
         8lbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549534; x=1763154334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Zu+sQZxV/DK1mZF4LzYMVwMmIZV5lUcGvIMy5Jfwns0=;
        b=l8rTLjSiVhwz58tqBYzcU8NUPOFj1+nztvGdtrherhdAZK6JP21fPg3tuvlYcL+OuG
         Jt+ik+u6Vog1Ue5TUKHV23EyYs8rFKWESQ8PnT8In7dXbX7cOa8tDYMEH6suFdceS+hq
         e6suxP/hnGbcR8sROZLj8GIJCLypGuXja8lxAxCMcZV0/h4dyoonVcfRKCxJK2LfGSxw
         JOBmVNZVuCusQDCAguw6TgtNvqscgEAHsrGFqlF6Oo0+qhLdwKs8TyanWPKT4lJpbyS4
         d2QFrFkMCNRB7Ctra7b89/ZwvdIkNDCSeGw3qBMMTjd4DQxjxjMRgqb/lFOPXAfXkq6t
         kfUw==
X-Forwarded-Encrypted: i=1; AJvYcCVRWVxuwcHLjqVA1hZ3hKQJLzaSBA0MIBc1UIFaXnRB4U1w8J35BPOVWrVagllRWZjkI13nYlRmOw==@kvack.org
X-Gm-Message-State: AOJu0Yze16eR0jP861YBCnacJ9/GYaZjg3VmTgXbUJ+mjPcb/N6MnAgN
	UD9RHaiD4RTpGR62Hqr4OvHjUcZIFUp+xUJaY0SfunydPUwAZsK/NPi1GSnYVntNK94=
X-Gm-Gg: ASbGncsuWNZxbIajk5jvAGNmI9KHlAI4vDA4adVYhvpZrU2tOyGPtV5BjzLh1XHu7qV
	5zO7TXbPA9Z5uv1Ckweb9twR2zoF8jgYtlC3cZydX57rDarjvGvUbeHdG3XqDpRBVN7XthwdBmq
	6VA3cORbiw5KxsuyemIcbWiVVVrdho/2l9tlT8I0x5FUSX9+cvWdJ/LwzWKj7CMUR+OUfJhrX50
	HKo9/VWtsR4TlBaF0D14Mh+aRVBp5z1i3f4h5W0bMjuDEW14uNQRrg6QSXg31z15pRWtxkfBveH
	zxWzVJGnknkVwAlsVokwtCrAltPCo0se7IRNdPwf0Omkuz+CUDuZfsQy1ExjEM0Lj5j5KNfNr8c
	SXVWlrJ7162xC0D+GWPmldXKWu2BBtsSos1cyL0XaRQVJ+fug0fXLr1V+UzEPznuLovM4P2adLP
	e2/0bIbnxrIztiCzJxSo+hnTYIowLo1zkrrLQ0akIogjTGtbYn9GsWnu16M/ipX5T0wX3Yn1C0h
	p+wO+MJqLUJ
X-Google-Smtp-Source: AGHT+IGkl2IVxRZTWeoOPperMhisjG1fXbHj29RAaasJvCOsVAl4Mwy+BOKFhe1CUBjQYDl+bzz8kA==
X-Received: by 2002:a05:690c:9689:b0:784:841e:c044 with SMTP id 00721157ae682-787d54521a4mr7498967b3.59.1762549533932;
        Fri, 07 Nov 2025 13:05:33 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:33 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 01/22] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
Date: Fri,  7 Nov 2025 16:02:59 -0500
Message-ID: <20251107210526.257742-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14E121A000C
X-Stat-Signature: rnqc7wpfdxozws1kpaknguk7rqi538g9
X-Rspam-User: 
X-HE-Tag: 1762549534-475722
X-HE-Meta: U2FsdGVkX1+iv3YleZQXyJa2/zN4w5+z1KlftywS4E3UGuQLP1/dFRUmN9fMwojqfkpmZZSID2b3bRmRXMcpFT8h1rnRKa/0B6dUgFCBgeP0ZQZqhEk8cHagkrIoRMkuhlo5FoVVbH3XZmI5Rbi5woHWHtjp3b6pZ5RNCTUhrIxPIc6gB4LWMn2RUNQlX1/VlqLz79XA4Y65g44P9QfakFuE9Hr7NOt4CoYzR4Qcrxb0iqkcLs6pbcbL2qGwuE+Bam8iXmB+h7Hj9E7WvDv5Jj7nUUknGqIjGFlULUixgy2lmvBjupXFXhMviyIDmTbjQdCgB6tKNv4t0jb3M2euBEq1Jf9fG+XSVH2TuO2yT/Iv9DAuUwX0QihxWEjiOfJrd2j4TX3ZAQ+wf6/I+H3qP4XYE6YIyXuc+P7+RkMdOgDA/Hxuby8/O7nqYQiJQMQHZDar+aKjPg61Kg7a87kfF9lwAueYWiB9Ny0wT9COzxH1kgcBl+UrhRtYr3CiO8kRU/pJrYmyyuzxOOiAst9u1FWNzwat4gIOShT6ImEjyq9VH37fWwUQrSN0F8FLLklEmOM0izGxgb82mmWrXx4Wt1uzyA7W2htUGMeUAak9Choa8QIbfHbEIhFv6zLz6rIE0jX6t8Y2+sbw9967bHBPmDJuf040rLxLtcJKaW+Rl/7EgJGAkmTmne6x1ZZlDGaDEetPU8PCzIYKMYLTBxVZVSYazSU3BDd7ziJGmQL0/z9juTgb3rYsUVW6bNcRLZ0qNOTheAUeirUPj3lePRrLecxkMmUWZAjSaC+LKazz0QbYIEWHF+Y49xYThRGXwjgJTSNAStZDZrJr5CwxgXdcvRKELBvRYlkDzyiFHMqdyRiMsm+2Z4UIdoDrFmyWIC+7uq2DQSB3wroYnA3JONjgU186hIzYExvepcmK70GDr+QnDkTlgvgdUMuK39NO1iyvZEhj3b+zZuCVleU/nNl
 shlFui4N
 7j8Irr37ILm4f6u566gutqvuxS9FybOhurej8pVw3QYbaTCzAPTjNVhBvoO0AhQsanWAdf69HmzFrHy0UrylbkLiKg+2Wg+hlSX9hgq7lnhD5bl0L/hmxmMUauWeuxYB4dfiP1TaWUv7CDZAUnQTibmRfQ7k2jeu7osXhDrZ66w5cws0mGsfScJsAMkE+xh7ZtYS1BAY6oYszJ+wm4QkkMDPrrm7+t14c49nR+p9ablQV2fRkrIYt7Habakz3P4Zdmp0i1RZ04bZFbUtkr3jqw8U3fptZkdU7CCeRAV1FaRS5yDxMzcMigdKFI6Szix0nj+v8W4KybZp715AXtr5W8qFpQGpIz7Y+2+pDT8pvOZJYVZichDf8YdZzWV7EHXvwSGrZALHkam2cTLgXB+zmRW1s/3Iyp3feoUzt9TEFrloWnTc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce LUO, a mechanism intended to facilitate kernel updates while
keeping designated devices operational across the transition (e.g., via
kexec). The primary use case is updating hypervisors with minimal
disruption to running virtual machines. For userspace side of hypervisor
update we have copyless migration. LUO is for updating the kernel.

This initial patch lays the groundwork for the LUO subsystem.

Further functionality, including the implementation of state transition
logic, integration with KHO, and hooks for subsystems and file
descriptors, will be added in subsequent patches.

Create a character device at /dev/liveupdate.

A new uAPI header, <uapi/linux/liveupdate.h>, will define the necessary
structures. The magic number for IOCTL is registered in
Documentation/userspace-api/ioctl/ioctl-number.rst.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |  2 +
 include/linux/liveupdate.h                    | 35 ++++++++
 include/uapi/linux/liveupdate.h               | 46 ++++++++++
 kernel/liveupdate/Kconfig                     | 27 ++++++
 kernel/liveupdate/Makefile                    |  6 ++
 kernel/liveupdate/luo_core.c                  | 86 +++++++++++++++++++
 kernel/liveupdate/luo_ioctl.c                 | 45 ++++++++++
 7 files changed, 247 insertions(+)
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_ioctl.c

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 7c527a01d1cf..7232b3544cec 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -385,6 +385,8 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xBA  00-0F  uapi/linux/liveupdate.h                                   Pasha Tatashin
+                                                                       <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
new file mode 100644
index 000000000000..730b76625fec
--- /dev/null
+++ b/include/linux/liveupdate.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef _LINUX_LIVEUPDATE_H
+#define _LINUX_LIVEUPDATE_H
+
+#include <linux/bug.h>
+#include <linux/types.h>
+#include <linux/list.h>
+
+#ifdef CONFIG_LIVEUPDATE
+
+/* Return true if live update orchestrator is enabled */
+bool liveupdate_enabled(void);
+
+/* Called during kexec to tell LUO that entered into reboot */
+int liveupdate_reboot(void);
+
+#else /* CONFIG_LIVEUPDATE */
+
+static inline bool liveupdate_enabled(void)
+{
+	return false;
+}
+
+static inline int liveupdate_reboot(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_LIVEUPDATE */
+#endif /* _LINUX_LIVEUPDATE_H */
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
new file mode 100644
index 000000000000..df34c1642c4d
--- /dev/null
+++ b/include/uapi/linux/liveupdate.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+/*
+ * Userspace interface for /dev/liveupdate
+ * Live Update Orchestrator
+ *
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _UAPI_LIVEUPDATE_H
+#define _UAPI_LIVEUPDATE_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/**
+ * DOC: General ioctl format
+ *
+ * The ioctl interface follows a general format to allow for extensibility. Each
+ * ioctl is passed in a structure pointer as the argument providing the size of
+ * the structure in the first u32. The kernel checks that any structure space
+ * beyond what it understands is 0. This allows userspace to use the backward
+ * compatible portion while consistently using the newer, larger, structures.
+ *
+ * ioctls use a standard meaning for common errnos:
+ *
+ *  - ENOTTY: The IOCTL number itself is not supported at all
+ *  - E2BIG: The IOCTL number is supported, but the provided structure has
+ *    non-zero in a part the kernel does not understand.
+ *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
+ *    understood, however a known field has a value the kernel does not
+ *    understand or support.
+ *  - EINVAL: Everything about the IOCTL was understood, but a field is not
+ *    correct.
+ *  - ENOENT: A provided token does not exist.
+ *  - ENOMEM: Out of memory.
+ *  - EOVERFLOW: Mathematics overflowed.
+ *
+ * As well as additional errnos, within specific ioctls.
+ */
+
+/* The ioctl type, documented in ioctl-number.rst */
+#define LIVEUPDATE_IOCTL_TYPE		0xBA
+
+#endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 1379a4c40b09..e1fdcf7f57f3 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -1,7 +1,34 @@
 # SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2025, Google LLC.
+# Pasha Tatashin <pasha.tatashin@soleen.com>
+#
+# Live Update Orchestrator
+#
 
 menu "Live Update and Kexec HandOver"
 
+config LIVEUPDATE
+	bool "Live Update Orchestrator"
+	depends on KEXEC_HANDOVER
+	help
+	  Enable the Live Update Orchestrator. Live Update is a mechanism,
+	  typically based on kexec, that allows the kernel to be updated
+	  while keeping selected devices operational across the transition.
+	  These devices are intended to be reclaimed by the new kernel and
+	  re-attached to their original workload without requiring a device
+	  reset.
+
+	  Ability to handover a device from current to the next kernel depends
+	  on specific support within device drivers and related kernel
+	  subsystems.
+
+	  This feature primarily targets virtual machine hosts to quickly update
+	  the kernel hypervisor with minimal disruption to the running virtual
+	  machines.
+
+	  If unsure, say N.
+
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index f52ce1ebcf86..413722002b7a 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,5 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
+luo-y :=								\
+		luo_core.o						\
+		luo_ioctl.o
+
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
+
+obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
new file mode 100644
index 000000000000..0e1ab19fa1cd
--- /dev/null
+++ b/kernel/liveupdate/luo_core.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: Live Update Orchestrator (LUO)
+ *
+ * Live Update is a specialized, kexec-based reboot process that allows a
+ * running kernel to be updated from one version to another while preserving
+ * the state of selected resources and keeping designated hardware devices
+ * operational. For these devices, DMA activity may continue throughout the
+ * kernel transition.
+ *
+ * While the primary use case driving this work is supporting live updates of
+ * the Linux kernel when it is used as a hypervisor in cloud environments, the
+ * LUO framework itself is designed to be workload-agnostic. Much like Kernel
+ * Live Patching, which applies security fixes regardless of the workload,
+ * Live Update facilitates a full kernel version upgrade for any type of system.
+ *
+ * For example, a non-hypervisor system running an in-memory cache like
+ * memcached with many gigabytes of data can use LUO. The userspace service
+ * can place its cache into a memfd, have its state preserved by LUO, and
+ * restore it immediately after the kernel kexec.
+ *
+ * Whether the system is running virtual machines, containers, a
+ * high-performance database, or networking services, LUO's primary goal is to
+ * enable a full kernel update by preserving critical userspace state and
+ * keeping essential devices operational.
+ *
+ * The core of LUO is a mechanism that tracks the progress of a live update,
+ * along with a callback API that allows other kernel subsystems to participate
+ * in the process. Example subsystems that can hook into LUO include: kvm,
+ * iommu, interrupts, vfio, participating filesystems, and memory management.
+ *
+ * LUO uses Kexec Handover to transfer memory state from the current kernel to
+ * the next kernel. For more details see
+ * Documentation/core-api/kho/concepts.rst.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kobject.h>
+#include <linux/liveupdate.h>
+
+static struct {
+	bool enabled;
+} luo_global;
+
+static int __init early_liveupdate_param(char *buf)
+{
+	return kstrtobool(buf, &luo_global.enabled);
+}
+early_param("liveupdate", early_liveupdate_param);
+
+/* Public Functions */
+
+/**
+ * liveupdate_reboot() - Kernel reboot notifier for live update final
+ * serialization.
+ *
+ * This function is invoked directly from the reboot() syscall pathway
+ * if kexec is in progress.
+ *
+ * If any callback fails, this function aborts KHO, undoes the freeze()
+ * callbacks, and returns an error.
+ */
+int liveupdate_reboot(void)
+{
+	return 0;
+}
+
+/**
+ * liveupdate_enabled - Check if the live update feature is enabled.
+ *
+ * This function returns the state of the live update feature flag, which
+ * can be controlled via the ``liveupdate`` kernel command-line parameter.
+ *
+ * @return true if live update is enabled, false otherwise.
+ */
+bool liveupdate_enabled(void)
+{
+	return luo_global.enabled;
+}
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
new file mode 100644
index 000000000000..44d365185f7c
--- /dev/null
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <linux/liveupdate.h>
+#include <linux/miscdevice.h>
+
+struct luo_device_state {
+	struct miscdevice miscdev;
+};
+
+static const struct file_operations luo_fops = {
+	.owner		= THIS_MODULE,
+};
+
+static struct luo_device_state luo_dev = {
+	.miscdev = {
+		.minor = MISC_DYNAMIC_MINOR,
+		.name  = "liveupdate",
+		.fops  = &luo_fops,
+	},
+};
+
+static int __init liveupdate_ioctl_init(void)
+{
+	if (!liveupdate_enabled())
+		return 0;
+
+	return misc_register(&luo_dev.miscdev);
+}
+module_init(liveupdate_ioctl_init);
+
+static void __exit liveupdate_exit(void)
+{
+	misc_deregister(&luo_dev.miscdev);
+}
+module_exit(liveupdate_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin");
+MODULE_DESCRIPTION("Live Update Orchestrator");
+MODULE_VERSION("0.1");
-- 
2.51.2.1041.gc1ab5b90ca-goog


