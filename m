Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA88D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E22A6B0011; Tue, 25 Nov 2025 11:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA1B6B0012; Tue, 25 Nov 2025 11:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A86D6B0022; Tue, 25 Nov 2025 11:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42BEA6B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14C014F03C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:01 +0000 (UTC)
X-FDA: 84149739282.07.8A6BF92
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C514C000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:58:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZePwHhSq;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVXlOcghSkBH1UGo3jOcilbAwCQIPzNeYGCZyURm31Q=;
	b=cXH7q4qM7cP5qeJIO62NFgpiDcjqu7xUZkm+jCB46h2k97Sz+LDK/iH463wHBI5xVmfXNW
	HZPVWImI9l54gcSMdXd/DTjHA7i8Z/D81ylaOLgFSqKMCqlVFKMvzyko7PpXSTKR30emYX
	Knt5DZ5pubNUHsOHz2MY/9YMC8HZTwE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZePwHhSq;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089939; a=rsa-sha256;
	cv=none;
	b=Ifj3jrOIBaXr1JsoN5xyaKSCmCRmAGesi0qudux0rBpnwyA9wfOP3e6hsTmyDIJ6xJ6Jua
	hKhb+SQdDhnReCgl/hESbvHscc7xPOkGecHTdVXbwBWk8pF++at55Wut6m40zjCQdggDO1
	iwJQ9uyBlsSxijuvtVDfq2AD4UMz2NA=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7866aca9ff4so58651487b3.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089938; x=1764694738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVXlOcghSkBH1UGo3jOcilbAwCQIPzNeYGCZyURm31Q=;
        b=ZePwHhSqXv8WCPaUQtU610uB6ic2ZtMQsiZqiKgx4dR+UYPEpAybvQnsWs+pVZwuI3
         QQyr2RYWH5wZQhYGLhR34eSUI6SmC4o8iIB9LTpSxgYvT7DGbmHn9/bqRk2HDFS361sR
         kNb8ZGuKqcB4x9sLOkC40yANQ0sC3EEzUhPSZvUV6tQmGYLxe4UvYLse+BOgPnAdHawH
         epbb5/181azUMqql/wyzu4XSnFk7kDONbeLlJNzvpQEYSeVaS2S4bE+oSafbO8SPrKZT
         xRb/FoFqUXYB2bnLAvjpyeBhxAjT559G0nqDjNguSyvLAirsi5ZNg8Gv2T5j9DP+OhKE
         8DBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089938; x=1764694738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZVXlOcghSkBH1UGo3jOcilbAwCQIPzNeYGCZyURm31Q=;
        b=Q3s6AQBY1alObgRvRQt2AZQxmdPpIQkMhe+KumBXt4hgDYBGeGkhsNaoO7mbiJS4iR
         ldbUytU/0oWPBNQAo6R5Rnb/mHYG85pvnnA1r5N7ZL5HnhGar2w42dXoQZrRZJfK95gF
         WD80J/jvSdVkKrEBlfI8jWNDGY0CWyymAkoDo6FlXzifKLFMpwSWJ9O2Zt/jrso9gjID
         u1k939C3tBGk1DA5W/GM5FQlYbBK0LcxcjlhcHHeQK9DM81P3SlPv3+ZDvDoMj3uy9n5
         UGylVc9B9lvBH0NhUXs91t2jjxkpkl0CjuZyBc4tr4kk8yyC0F71gf5sV7gqBVK4g2RO
         AbUw==
X-Forwarded-Encrypted: i=1; AJvYcCUYWdtix/K0+FqqaGXUI5uw05PxgdThm5032zmTk9w7FWpXsrGEpGqn3vIQ38OpMcrV7muN6U9Yyg==@kvack.org
X-Gm-Message-State: AOJu0Yyp2tVtQyXCaaiDp9aj5luYiFA9pCsemwJyoQoMGp1upRHMs4Ch
	/4Egjjz4pl1KOKXbNxDLUmrMYCIL7liKNqZAXg0uIcIRSqCzabdDirL1YltG0+wYjBM=
X-Gm-Gg: ASbGncv2kCA43dV4M7lDRs7P3uiIbvOavpyc+hMBlRe0fwGWzTqBO1nEbjiTaSRMvI8
	IkgEyXVJFbSAQxNpAVUnAY3PuhdIYsg74nrN5831eZc9yAojmk2hsenp5/Q8QUSTboQC+cQ8DZu
	firvB+1cDXDtaGiJ8qEe9ak9f+HljQS5Jh+X7EeXQbwLXmK+m+E6RLx2sIyMMgHbApUHOGV2Wln
	L8JfHdS0o3qjeiXOBdtyXiNO9UXPv1T5/DN2zWVcu5bXGGwt178U5gttNcsxPt22/NlXnupB1T+
	07OUvHon6GuBJZOQXIbDKk57gs5tbdUGfq7lYnlcYt/OlL72+mmJ5/U7Bc3f2htJA7+JaVMA23X
	UwHhCNqmB6pPL+0W8t11+bDoD/9IeMArn3gctObdZvmA2GbeahBjM+TXf2OUwaZF+pkUG09u6rs
	eQSLD/47Le343t2FBJj0x2v+a25cw1AymawKIhBw93XUDZTOWHpODDmVblth4PThHM
X-Google-Smtp-Source: AGHT+IFzLqONdmoMxtvQP22Mx+4CTT73xksgrCrTHrFT5fvQtJf9pzYLQiDyCLe6HMYfhVNW4vvqQw==
X-Received: by 2002:a05:690c:4c13:b0:787:ce99:eaa0 with SMTP id 00721157ae682-78a8b580502mr146674547b3.70.1764089938106;
        Tue, 25 Nov 2025 08:58:58 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:58:57 -0800 (PST)
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
Subject: [PATCH v8 01/18] liveupdate: luo_core: Live Update Orchestrato,
Date: Tue, 25 Nov 2025 11:58:31 -0500
Message-ID: <20251125165850.3389713-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C514C000F
X-Stat-Signature: 5jrigi18whguubpprd6uo1uxckoeks3m
X-Rspam-User: 
X-HE-Tag: 1764089939-63473
X-HE-Meta: U2FsdGVkX18LlLuIs1wPL06gp2arUFGqlb1MWgo/9hTBe6TtURqEQdsReU1+edAmnQCcJGErCyQWZRRGeF4YpzXK9HN9D7F14uoyK1B5hkmkqTpU6iugVJnLwDTiFEkgyO6VRQxQPbny6gXE/IWAxZXnZQiKG9BT3zj8EK7FdE8o+qxBO4iMqPUNeDmXav2Ux8K+2zoql9k3iWWdZso6rQAq6bIDcCIUuujWEhsxsG8kCMaG8ZWkOygvXG0tNBnS5CPGmfJ6+rLI/BEC/QeM8AOkDBgWJR7a7mN5R1a130HqwB+lUOewqP8IShr9gu4Wvk1BuuZo0qCFwzjycByO/iBElrhOknAj5TWDSTljw0V/vKbl66SGQ6v1kvtfKDvyi385bz7BatmuzY+Yz5Bh037hKNcmKXCcyp4+uLczQjshSAKK0cRNTe6gF04bd9buKR1Hqg2nANDWDdbuN2vJhzvvoFuAVhsJ/JmbZd4XhtrorojHEkzrZip61ZMA7VWr804DVCL/nxmCZvX18AL6XnvX9biEESLltEvSAeNLvKxeqdbrdT7QSI3TvM/M14BW/YnPJcJne7XX9MYXUEmcOHfE3iK7nYxPslyfD49VZNc95Bboj43X1eAZuZgaZW+RfaR0WHqEHRCsIPpwuK9yJrGtjKNgecS+0L8RSrtzWXzat2QpyUR1k3NBSPqALOwTni3ggi+rFgmx1Lm9sJtLupMLS/oJlQhUetKA8W//Gd0DPjdjbkfkx9liKHA3CX22ACkdZwspVLS3rauW32Q0NV99KzSrCno9E18p1ncZRtqSIEN7OHnwahFz4uVBgPhJ9nQf+bW8U9Ixrwkkex/J/tPNdjO2328cTZ/lW18/8nOGb+wefoS1i/bTyXz+U0vkXUVelNjf2NpgsDTof7l2HzG6PIOiAZhWlwbxhklBXTR7xYjJ/Vh/km747cpO4MdjiFGPInDfcm+BIFw2uY1
 HHzKgDHT
 lkwX4DxmIgisoZ4y7KsgpI2mOTZN4RPomR36t1N3DSbqZSAEYCh/b8w9Hy7pS8Oo7k8Oq/LdxplPB8qifCuQY7ciVUwGh01LOBSHr7kHFLUJc9bNaqb9GXzdoGMTMS9TrOmuyqB5DHDX8GyfpNUw7nd2yOG5xBYw4Rs28tjQuVkvet/MprkilJ+L+E5sP74VL8hGtFE+TS88ZoGvoP6RV/cnFad29dIFWXCUR11UscIvefzwwTaa4NdBEMLzmHz6VJWxyStvggyWG84RAAJGukRNNWVODbJL6VC8qVMz7j91L2fhjCTKOJ/5vsVpE07Y90UbU2pPlOxeuRsrVe7Vx3UCd8WtLqnc4/8MhzKTvBr44eppLrLuz+vw88yrBphGhNlzo/dkoQSvvvbrN/M7ounnMYs/9POHcj+a77p2GDjBLtBw=
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 include/linux/liveupdate.h                    |  35 ++++++
 include/uapi/linux/liveupdate.h               |  46 ++++++++
 kernel/liveupdate/Kconfig                     |  21 ++++
 kernel/liveupdate/Makefile                    |   5 +
 kernel/liveupdate/luo_core.c                  | 111 ++++++++++++++++++
 6 files changed, 220 insertions(+)
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
index a973a54447de..9b2515f31afb 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -51,4 +51,25 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
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
2.52.0.460.gd25c4c69ec-goog


