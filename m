Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E502FCFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3721F6B0026; Sat, 22 Nov 2025 17:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F19D6B0027; Sat, 22 Nov 2025 17:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B83E6B0028; Sat, 22 Nov 2025 17:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 050366B0026
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 920F2130A54
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:01 +0000 (UTC)
X-FDA: 84139671882.10.D162803
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id C24D940008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:23:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GUFWjcpf;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850239; a=rsa-sha256;
	cv=none;
	b=Pb5tndkLoUw9gub64vIthlvxi4AqwRekTDC6fZLvGpKMMJwrFVQKQBBGTkXkPnEXRQ5/t8
	pztKcO8IB/WQaNt79jifTy+CCJOTJW1pEM+8+sRyiNp8NZg+jsxZlEO+Q2nKkx66O8qU4a
	dvbBCigeVIGmWzzayAapcv0n2qOB0pA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GUFWjcpf;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNqa2AMoTm2GXKVPNq5SENNKpDOhG7qaiAonHBUruqY=;
	b=Q35o+HeoMwd4q+RDlNX1sDIFtXDK1PNVIkUC05AVnNgsvWIwxLRA7wS14MOHMKhUewBErB
	tEfc6XvLkSzkTHeOGhy2+2EonHETLOehBll4oer4FrHMjSpfLlsES6AZWyOZ4Z4bIt0X82
	qafBtJpRR6RSWtGa05maOMhzwUAfBu4=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78a7af9ff1dso30356937b3.1
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850239; x=1764455039; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dNqa2AMoTm2GXKVPNq5SENNKpDOhG7qaiAonHBUruqY=;
        b=GUFWjcpfqIT2rOPhaDpvLYqd0MyQcAlXHgUpXcgj2Hln+N2SBXX/gPufMIe17FbdNs
         JakSJjvqurqg9kf2G3ZX39YfE97klCP0VfIeCZMWvVzvHgRYLlfH3tkP+tgQTi3CCJAs
         Q8wC0vy5Sy+kpohJKIbmbSM4Fq3756jWnEVbAFUp2t5GOX/D+UPzWds5aGMAGbgLvaNz
         Z7yeOg7eQVKCF1dKC2KiisKFAYfAMuw3dpeh4xJoVeE/NbjWBR+C/w4ax1u/uUO5L1qm
         0k8PBEl+ZHfH0xDu92ALDNVXbhrfu9Vo4ZzBIhMX7lsgSJMyWxrgsFh9XdgWCuWbZNyI
         OMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850239; x=1764455039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dNqa2AMoTm2GXKVPNq5SENNKpDOhG7qaiAonHBUruqY=;
        b=SjROGaGpqxOOD3I+X+tjKrXwg6LbRSCYnbBS9ALelHLDWsbJ6PdnVVGsqajQ9iwcVp
         bMc928Uonuj0CCHezElVOYSqQfF7Wmbwfvjn2W2arqUMT06+2lw+NPvhF2VbTRnRQhfa
         oWifQgOEaOgD0e+PJbSxRDMsG2i6wLnJ0mcTJd5xIlLXCj/jnk+xOm9AqRgzNpoK15eR
         IHLJdLAYNKXTemmIRq+hIRndxxPFKr7zb28RjTBtDocL6eiBRy54ReCR8pPVTpYQOfCx
         HhR5d6cIvkZOdEpDsc5rdNQDl+BZH73Fy0ijKxwT8PfVb0FWXvzddILvWoD9L/NVtorp
         XK0A==
X-Forwarded-Encrypted: i=1; AJvYcCXAknizanclM20/pxoUOe3tPG16/B2uZ7DVjcMUk5dq8p55J8Im2GJZ9U/WOMJGIqCFi9/rlzvAIQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0WWqupLQWxZdizu4tXqi4bO5QNux2Ul4+jKrIjbF2MvkeM0EM
	tQss/zOw1/DKOnCyoG5My4ekVUXHKaneJw2LjKeoKRA2eBltTHIPfyANQ6Zg1XRbWS4=
X-Gm-Gg: ASbGncuFwCBYSOOyK0JGhEKD6IdSluD/Lp8UuMSkomTFSiBAYt6f0Pi+Yp6SI0O2jtj
	+5cZEAv0lmaJ5yWTxA6eEnbpDBUT8RwcXIDNZOiekHxWJELEn7xId/83pd3MUKNCp36Allj+hRC
	6uv5ILJevUjef4JhcLX/JIJ/VR/VzPjhEWWHk87EKnSsKiJU2oxMKdkI6gVRBxX5w/LlQ7JMTbV
	k3rVOum1CVW8F3LcB2j/usMWlwabOmByEsXrOYqfpC+CrkrQJKP8mZD9GNPtpQPIYeUCAEKl2hF
	vJCQKE8WwaVnGGVGg89ZShAqYD0jr4E5n9MLHVfL9DZdf8SS73CIMQmwt1+pABzGSeYChIuh9FM
	JOz+3LTK2Cic1xFzgKXyWjREngOE9EMAbjAucHivVAqejQvPg83NIddOHKERSxGn5OQHObKdlq8
	MgPlBof/qAcJemXunbkYgSWsUpq3v9AWaatMGyrStlhI6Owz67H8scIkUUXdZcfesyUDHZUAkbo
	GRZavQ=
X-Google-Smtp-Source: AGHT+IF+QIPDkZ8c3ehnwAu2ppYoebnLrM6KhSaO+IvE/8Ir8krSEKQs+zG84x7hnCz9/ff0vwyg5w==
X-Received: by 2002:a05:690c:4b81:b0:788:1846:875d with SMTP id 00721157ae682-78a8b48b5bdmr59359977b3.29.1763850238778;
        Sat, 22 Nov 2025 14:23:58 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:23:58 -0800 (PST)
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
Subject: [PATCH v7 01/22] liveupdate: luo_core: Live Update Orchestrator
Date: Sat, 22 Nov 2025 17:23:28 -0500
Message-ID: <20251122222351.1059049-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C24D940008
X-Stat-Signature: nbe69af7a7wzuawm185yooyr7oi3xux5
X-HE-Tag: 1763850239-760402
X-HE-Meta: U2FsdGVkX1/gQ3Mai9AZRZ67+hmgpJ/4I/7TBFujC7P/RW62wGE+pJDG/YrpW3ROYphC5maywfZUwqJaLFb0T0d1MM3c6yV9adSseZPGa5JJ+EZ3+pWiJt2w3ae/eZ68/Bo0EmQCeVrX6pD9gGhHWr6PWK95n0iOrZyqry1hGyy5jbJSuV+PrEROLoMtExVTSIyXEJs+YOReXolw8w0YBwdOrnbGm+wxG2Zp6XNTVQWpnJdSRqDRlZBLgxoXwTBZIPFw/ixq5REWKfrLgY1btBqQp9d7+822KKSiEuzLtJEWbR3Dncu9tH0kKPf0lzynw62zxFF2LmTE1KlLRjr4EEvq6bwsjLnj2DmsPKy/fx8v5ZlNHhZy79z7erq+Q7Y2gcSFM5V8FCAZxIZtBvQJlLCQvH+OyNzHj4qqgMU99BCPEfJUMpAL0w8LdLpILW72hzcwi656eNuD6I5heIui9DXYAWng24/jUOoqYlde7xSPskclafgABADlbdnJ3NfcduQIF0DpHyM56TxROIJHLmHleg3vleOI3yUTVn/5W5thGiT693/zB05BJGSOmilFbOpf/mH2adDZEAVx/M7s2jBLr+sUz6hB5tQILP7BFVsMnVd7Q33kSWxtK6P6FsMyiz0SCsNE0UBsEjy3NxTmpB2Kz3Cnk4rDl59e8qgjYRz70E/w2q9T0nm57Im3fwEiIb1mEO7+aV3ld5NCqX4BAlXNRvz8nBw3+v9evlq8ANwIW3HnOqPcELJ0KdIYFceWw+7QjSG8ggce8KUIAuFHuAsrRbjAQxP5wEj1+EGWyZ6feqoVq3LVxWIUCFNW/6vxm8eIkhU4HgtvAEGL9Xj7LXEbwWWKu1Zx+49qsPNRYkClNkS4eHgK5LzhJtv0Vz0hRFqrK6rNYb7Z+Frrgc8iDD49Q5zgCuJfGmxIPpVa3y2DPj0hsC9C6kU6M2lcZ04M7rebB6Lg1Un6XHTr2AD
 Gm30yqNy
 K0FbO2VTc94GpaqQPvKdLmYxKdH7mKuGNztR5eEbnweG3mXdeDQiYpVtzhWlFq5zVEfH5jMcUbqrkyvbE6J5L4f5vIkbpTjL7FkBbToaWa0zzrSJqwx4rFH8yooyV5ipu3dXccqEP7tzmTv5tBaeqhEVZoa/zBLY75zsQjFV+hiWdIzO+vwuzxr5MaavMsmSZR2IW4RDeAj/4ytlF+IrIFBR3LEWvd8kEhuRJZzd4z5BimqQunbmD9IM5jImROhhnu2A5JG8gD9NmAT7LW8cNQvTCTXfYaWxIhiEboEqcwQqtTKmzTnsWU3RYFUgKeblY4thtBPXhSkOlC7IUkcfVKO0I35u9nPE6DKBDaSbNEnQfV6YFLi1GNUnWMqpL8+p4MYXOXujtjCv8kGpVBn6MQ3YTNbzBIAXRDqX4L0nnxp7Tspc=
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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 include/linux/liveupdate.h                    |  35 ++++++
 include/uapi/linux/liveupdate.h               |  46 ++++++++
 kernel/liveupdate/Kconfig                     |  27 +++++
 kernel/liveupdate/Makefile                    |   5 +
 kernel/liveupdate/luo_core.c                  | 111 ++++++++++++++++++
 6 files changed, 226 insertions(+)
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c

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
index 000000000000..c6a1d6bd90cb
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
+#include <linux/list.h>
+#include <linux/types.h>
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
index a973a54447de..90857dccb359 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -1,4 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2025, Google LLC.
+# Pasha Tatashin <pasha.tatashin@soleen.com>
+#
+# Live Update Orchestrator
+#
 
 menu "Live Update and Kexec HandOver"
 	depends on !DEFERRED_STRUCT_PAGE_INIT
@@ -51,4 +57,25 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 	  The default behavior can still be overridden at boot time by
 	  passing 'kho=off'.
 
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
 endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index f52ce1ebcf86..08954c1770c4 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,5 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
 
+luo-y :=								\
+		luo_core.o
+
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
+
+obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
new file mode 100644
index 000000000000..30ad8836360b
--- /dev/null
+++ b/kernel/liveupdate/luo_core.c
@@ -0,0 +1,111 @@
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
+ * LUO framework itself is designed to be workload-agnostic. Live Update
+ * facilitates a full kernel version upgrade for any type of system.
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
+#include <linux/miscdevice.h>
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
+late_initcall(liveupdate_ioctl_init);
-- 
2.52.0.rc2.455.g230fcf2819-goog


