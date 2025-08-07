Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD07C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C030D6B00A1; Wed,  6 Aug 2025 21:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2D86B00A2; Wed,  6 Aug 2025 21:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2EAB6B00A3; Wed,  6 Aug 2025 21:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91DE66B00A1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 558ECC07DB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:05 +0000 (UTC)
X-FDA: 83748268170.30.FFED6EA
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 715D8100004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LNJqiYQ9;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGbUc9NIm29yqExnh12PfmLPkmHzH5fwphyzTE2k18E=;
	b=w3upKOsBfRUftevoT9VC/azzxIR8wAMPbvE+0uu+0zEdZkSjGCTDFvo57uvekXem8V9s5+
	PnPdkM9opRPp6SZ318FTHIX7rRmPlhr1mKGYXXIwEEICkU8/9yz4UQ/QyEvNByoVwRbbgu
	7QAOcQQGcHMTc4pwIzdjKexrpZ+XMlI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LNJqiYQ9;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531103; a=rsa-sha256;
	cv=none;
	b=SjokSQlJQJdnm9+4ZgrgkKGYW4emGAHl9d4HspBgM5+99hp6k7qd6wYQcIqQ2y7CUUtG1D
	78neJAp7kNWmB0kbNd4ip3Cd4V57O1p0AGXP7m/MO2J/lBqWYoG4v7V7qP11RGsBx24Znv
	WsPZVKoWmlQl7DXxUUct2ZsvD8jd7kI=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70767eef931so6723136d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531102; x=1755135902; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PGbUc9NIm29yqExnh12PfmLPkmHzH5fwphyzTE2k18E=;
        b=LNJqiYQ9yoCJ7ofCx88Wf1r1rvoXjt/t1d1cXeRfr8ZYTLTwgPsoHjLjhDFMlGPWtX
         SVNzrVNy2L3kkSRv9g/yQqkWM4eX4f55o1whFqyvm96bKoTPStwAFCTT8CGccsK/a4Ya
         d+yYsmDc3YX8paTPlxb5E+K+C72t8TUb6aLsVHtposNjFlgz6ln59RyvgxtLrdR+Yix0
         6x74JV3fZSWPosbN2DxoY2BtsGETZCzyaWBBE3I9R90HKBVl3z1S9AxSpM448pXFuaIr
         wig2ZwWzysA+g04XMOGxor1a89jSqIm6if17v2rIkQwGk117f81KJu4+vb50twohR7He
         oyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531102; x=1755135902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGbUc9NIm29yqExnh12PfmLPkmHzH5fwphyzTE2k18E=;
        b=ClUsZXh3GmPG9xx/mnuMvWu9IxfoHLiTnKn9TsC7xc/ZmRxrJm0Bqr+8KxM/59BOCx
         alxt0oJ4i1eDFvjzCnHUFB1VMumuhs6uuCfVoqug91WW3fNjjLIqD5d0TW90XVTyANcN
         dNyB03HPQxis/3cYlE0lurJsDV9QD/M4poNK7m8kXvyOdZwGcWSAOBdVlsYPhIwxZA90
         yd0JmgWXD4M5mK0Q/O344LO1TIElm/vz7V/HShcoatl0Z0v3aCVMKn7nFUSgCTzQq37t
         ZNIZj6xAFrXbK3sR0+K80kqs4X/HP7Myx+eB1uLooFNx8cowclzB/NVNRQXcAP3n7mST
         sn3g==
X-Forwarded-Encrypted: i=1; AJvYcCUNoKtDbZpCNZISHhY2czcGopBwbtU7vPoB5sy5cuqXvv2CoBFEoS9IMUCCwOyzu5Btp8c7MJY1nQ==@kvack.org
X-Gm-Message-State: AOJu0Yyr20cCuqx9XCWdVuj9c3IMziOnYcv4I2T7iocDEhLXKiiEGX/D
	aJ//t3HSaMJD28Tadzqa3CtKOKaoUZvJxBhKF/w+uhc9yAZdxgXq/N5gdVKzXzoK6y0=
X-Gm-Gg: ASbGncsHub85X5FljXvNoAF1lad9/C7FCTRgvRRRlpVOZrhWkzkRtnwudaOimY+7rd4
	NnRjdmDf5f9K7vm09WfNqPQpbl719xy1YA++TU5qGpYR+9LNG3MfvkQSHnvs17vH6Idb6CngvYl
	93E712eUWtLFQ/Rnq47f7ede1RPfdZH8lvf3huwwpRvRqqFsXuGEDIVcb64H0ORH/Ck3afDTpAU
	yX+jUEsqC7t8ejU/Tvdkq11M/ZkvVL8Pwt0NnJf2hEILeVDlc0IsCEMvgd7LLTsC6LNIhSmolNN
	WmS+hG0JSAaWfWjSDabpFLnJ0Cn8baZdLfyBCB67r+tIPH6oqyB7P0M/kRQym1HntXSo2/Sv7I3
	Ma0plOrMMhBhUH0xt2JOoOPhCgBkMZ8ks3NL6C5cC+4VGACNrzvPpiVIGMaX9pZXyvSrjQwHclg
	FuzSMRyOrZYcym
X-Google-Smtp-Source: AGHT+IG2n/NHpVcAaXg5EHw4dc3YYrb+NR1PoqvgF/4Vk6fmqtkHTLLVFsYSEsS7jOvVstvSyDq9qg==
X-Received: by 2002:a05:6214:4015:b0:707:71dc:a382 with SMTP id 6a1803df08f44-709795f878cmr72338246d6.25.1754531102077;
        Wed, 06 Aug 2025 18:45:02 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:01 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	witu@nvidia.com
Subject: [PATCH v3 10/30] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
Date: Thu,  7 Aug 2025 01:44:16 +0000
Message-ID: <20250807014442.3829950-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mxrhawiwzpoy1u4iurbqxfy1p19sa8kx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 715D8100004
X-Rspam-User: 
X-HE-Tag: 1754531103-209272
X-HE-Meta: U2FsdGVkX1+ZoJr6u0LPMMXuM3aiC9HPn1TYkhu7WSEUh8zRxCfIaSIggUFMbwFPXsvx0aoYMThNAs5IIxYJpnQ6pmWnGwGKipGo0Wn0VjxUvfitYBQCdjtzEZee/oTrDdZbnmOeUZgRr/bjbOrCnbIy038gS8Op7ZcRFbjWkJOtGfBtNHPsgbhbfZWkMAGOf3U0CaT8+PLgP7ZVlqJE2wmcCcWSfl91lGNQEN+6RQAm1c29ZaOtFGjeaHtF3L0E80faktnfqj0ilb7OvQ30I3QG9HwC8hijoMw4++iBtPEL11FUqIpCyp3p7QXJ/aj0xCJ8/VCLY/bffO8bdu92vh2KU0U+tBWKdQE/SgSnUPvWGyLX1jK54WDdPtM0rp1kuiUzX7YME7w3q0WACwf3ts1BQ3tprYMBw7zCnSZOPw5S44mHqw19uLBvdvv2KsSQx/8swgkNRWPJO7SC1lc6mbRKzgtp25sXjtvDJwhLrebhWcDMcYA4kIa7A/jg/8SfFIHyx7D80XhyHpl09lFudpf56tSZamxDxo10FrI7BdpgvMQEPALW1sF4VDQ+jEFLbGpR0LA1rtbD4JBOvk/98nvZ+yqjXzGdZFoAcm3dDTHSLt1KRXsOx9hOsZrk9L2e7Q72g6WOMUckDnTbnxm0go00jCLzw4bxsThaLRR+in1MSItdWqlMdIAFz/cswPa8cZQ1CAOLh0nn/GKa+fWHCNmBbxxEjLgdDwEBM2LywD1kktsLEZMs6FLD5Yzj6bQ1oZvGUNzl8aONLL9gGckmJuDgzsTA1RP5Tyc+Rf8zUdBhbFE8HMtZyjxzQ1GzesV0TcA6l9hlSbk9DzaUliXznYGPxuqFvxBdWloGMXy3Rk5y3E+GsZMJO/f/OE+RDarV8tWAaAW6jS6yr74tHIcZ9Mr2pOJ3U6aDWEfIlvmr96f1a6BUMbcgzTwe6lUdfgb38Asey0KpinEUo8bBDDo
 ZHEBSAbS
 GtLdNtxK9PMGAD+bsSxhH/JlIWglN2e06nG2o+S7FCN6dv6Cqkwl7Nf2KFqqvswzG05QdU9gFvaUHpcpv/gHWnhfXc+lIsNZ1YOl0qLKs2SVf/Q66IJjPYOXNxaeWUX5pGyMdQAbIPoka88RQwGZJIyyvhSUW+r4WENmgR/StLv0zth3bHldklBViolpg+wXIk6iGLws1xhIiS1ZhUKvrbTRuV5XIaZ0FXK6g80hmPQF8n3bzfW5eWAKI8y4qt7zmh+iFHyQXvH3anEq455kv439E0HFAfuzmOklPDbcpK23k/lT2thvwyVI5K5X0xXTHPn3qaVyfEUtsi9mNo1DLqOiH9NYxAumLeeBiXhBbB7jC2ri9/JxuPW83xthPN5ifOJka55l4LxGJdgyin7s7lki4fucXlUFmDFB2zZsATOlnGZ9Q6mfd4tT0d99s9vzSNkEqKiSBAqRLXuCw0plZ0On63nC7TUmza6Z3X3Ai5AOlKXxr+vp2ZPtbUw==
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
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 include/linux/liveupdate.h                    |  64 ++++
 include/uapi/linux/liveupdate.h               |  94 ++++++
 kernel/liveupdate/Kconfig                     |  27 ++
 kernel/liveupdate/Makefile                    |   6 +
 kernel/liveupdate/luo_core.c                  | 297 ++++++++++++++++++
 kernel/liveupdate/luo_internal.h              |  21 ++
 kernel/liveupdate/luo_ioctl.c                 |  48 +++
 8 files changed, 559 insertions(+)
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_ioctl.c

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 406a9f4d0869..d569459a2320 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -383,6 +383,8 @@ Code  Seq#    Include File                                             Comments
 0xB8  01-02  uapi/misc/mrvl_cn10k_dpi.h                                Marvell CN10K DPI driver
 0xB8  all    uapi/linux/mshv.h                                         Microsoft Hyper-V /dev/mshv driver
                                                                        <mailto:linux-hyperv@vger.kernel.org>
+0xBA  all    uapi/linux/liveupdate.h                                   Pasha Tatashin
+                                                                       <mailto:pasha.tatashin@soleen.com>
 0xC0  00-0F  linux/usb/iowarrior.h
 0xCA  00-0F  uapi/misc/cxl.h                                           Dead since 6.15
 0xCA  10-2F  uapi/misc/ocxl.h
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
new file mode 100644
index 000000000000..85a6828c95b0
--- /dev/null
+++ b/include/linux/liveupdate.h
@@ -0,0 +1,64 @@
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
+#include <uapi/linux/liveupdate.h>
+
+#ifdef CONFIG_LIVEUPDATE
+
+/* Return true if live update orchestrator is enabled */
+bool liveupdate_enabled(void);
+
+/* Called during reboot to tell participants to complete serialization */
+int liveupdate_reboot(void);
+
+/*
+ * Return true if machine is in updated state (i.e. live update boot in
+ * progress)
+ */
+bool liveupdate_state_updated(void);
+
+/*
+ * Return true if machine is in normal state (i.e. no live update in progress).
+ */
+bool liveupdate_state_normal(void);
+
+enum liveupdate_state liveupdate_get_state(void);
+
+#else /* CONFIG_LIVEUPDATE */
+
+static inline int liveupdate_reboot(void)
+{
+	return 0;
+}
+
+static inline bool liveupdate_enabled(void)
+{
+	return false;
+}
+
+static inline bool liveupdate_state_updated(void)
+{
+	return false;
+}
+
+static inline bool liveupdate_state_normal(void)
+{
+	return true;
+}
+
+static inline enum liveupdate_state liveupdate_get_state(void)
+{
+	return LIVEUPDATE_STATE_NORMAL;
+}
+
+#endif /* CONFIG_LIVEUPDATE */
+#endif /* _LINUX_LIVEUPDATE_H */
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
new file mode 100644
index 000000000000..3cb09b2c4353
--- /dev/null
+++ b/include/uapi/linux/liveupdate.h
@@ -0,0 +1,94 @@
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
+ * enum liveupdate_state - Defines the possible states of the live update
+ * orchestrator.
+ * @LIVEUPDATE_STATE_UNDEFINED:      State has not yet been initialized.
+ * @LIVEUPDATE_STATE_NORMAL:         Default state, no live update in progress.
+ * @LIVEUPDATE_STATE_PREPARED:       Live update is prepared for reboot; the
+ *                                   LIVEUPDATE_PREPARE callbacks have completed
+ *                                   successfully.
+ *                                   Devices might operate in a limited state
+ *                                   for example the participating devices might
+ *                                   not be allowed to unbind, and also the
+ *                                   setting up of new DMA mappings might be
+ *                                   disabled in this state.
+ * @LIVEUPDATE_STATE_FROZEN:         The final reboot event
+ *                                   (%LIVEUPDATE_FREEZE) has been sent, and the
+ *                                   system is performing its final state saving
+ *                                   within the "blackout window". User
+ *                                   workloads must be suspended. The actual
+ *                                   reboot (kexec) into the next kernel is
+ *                                   imminent.
+ * @LIVEUPDATE_STATE_UPDATED:        The system has rebooted into the next
+ *                                   kernel via live update the system is now
+ *                                   running the next kernel, awaiting the
+ *                                   finish event.
+ *
+ * These states track the progress and outcome of a live update operation.
+ */
+enum liveupdate_state  {
+	LIVEUPDATE_STATE_UNDEFINED = 0,
+	LIVEUPDATE_STATE_NORMAL = 1,
+	LIVEUPDATE_STATE_PREPARED = 2,
+	LIVEUPDATE_STATE_FROZEN = 3,
+	LIVEUPDATE_STATE_UPDATED = 4,
+};
+
+/**
+ * enum liveupdate_event - Events that trigger live update callbacks.
+ * @LIVEUPDATE_PREPARE: PREPARE should happen *before* the blackout window.
+ *                      Subsystems should prepare for an upcoming reboot by
+ *                      serializing their states. However, it must be considered
+ *                      that user applications, e.g. virtual machines are still
+ *                      running during this phase.
+ * @LIVEUPDATE_FREEZE:  FREEZE sent from the reboot() syscall, when the current
+ *                      kernel is on its way out. This is the final opportunity
+ *                      for subsystems to save any state that must persist
+ *                      across the reboot. Callbacks for this event should be as
+ *                      fast as possible since they are on the critical path of
+ *                      rebooting into the next kernel.
+ * @LIVEUPDATE_FINISH:  FINISH is sent in the newly booted kernel after a
+ *                      successful live update and normally *after* the blackout
+ *                      window. Subsystems should perform any final cleanup
+ *                      during this phase. This phase also provides an
+ *                      opportunity to clean up devices that were preserved but
+ *                      never explicitly reclaimed during the live update
+ *                      process. State restoration should have already occurred
+ *                      before this event. Callbacks for this event must not
+ *                      fail. The completion of this call transitions the
+ *                      machine from ``updated`` to ``normal`` state.
+ * @LIVEUPDATE_CANCEL:  CANCEL the live update and go back to normal state. This
+ *                      event is user initiated, or is done automatically when
+ *                      LIVEUPDATE_PREPARE or LIVEUPDATE_FREEZE stage fails.
+ *                      Subsystems should revert any actions taken during the
+ *                      corresponding prepare event. Callbacks for this event
+ *                      must not fail.
+ *
+ * These events represent the different stages and actions within the live
+ * update process that subsystems (like device drivers and bus drivers)
+ * need to be aware of to correctly serialize and restore their state.
+ *
+ */
+enum liveupdate_event {
+	LIVEUPDATE_PREPARE = 0,
+	LIVEUPDATE_FREEZE = 1,
+	LIVEUPDATE_FINISH = 2,
+	LIVEUPDATE_CANCEL = 3,
+};
+
+#endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index eebe564b385d..f6b0bde188d9 100644
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
 
 menu "Live Update"
 
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
index 72cf7a8e6739..8627b7691943 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -3,5 +3,11 @@
 # Makefile for the linux kernel.
 #
 
+luo-y :=								\
+		luo_core.o						\
+		luo_ioctl.o
+
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
+
+obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
new file mode 100644
index 000000000000..c77e540e26f8
--- /dev/null
+++ b/kernel/liveupdate/luo_core.c
@@ -0,0 +1,297 @@
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
+ * The core of LUO is a state machine that tracks the progress of a live update,
+ * along with a callback API that allows other kernel subsystems to participate
+ * in the process. Example subsystems that can hook into LUO include: kvm,
+ * iommu, interrupts, vfio, participating filesystems, and memory management.
+ *
+ * LUO uses Kexec Handover to transfer memory state from the current kernel to
+ * the next kernel. For more details see
+ * Documentation/core-api/kho/concepts.rst.
+ *
+ * The LUO state machine ensures that operations are performed in the correct
+ * sequence and provides a mechanism to track and recover from potential
+ * failures.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/err.h>
+#include <linux/kobject.h>
+#include <linux/liveupdate.h>
+#include <linux/rwsem.h>
+#include <linux/string.h>
+#include "luo_internal.h"
+
+static DECLARE_RWSEM(luo_state_rwsem);
+
+static enum liveupdate_state luo_state = LIVEUPDATE_STATE_UNDEFINED;
+
+static const char *const luo_state_str[] = {
+	[LIVEUPDATE_STATE_UNDEFINED]	= "undefined",
+	[LIVEUPDATE_STATE_NORMAL]	= "normal",
+	[LIVEUPDATE_STATE_PREPARED]	= "prepared",
+	[LIVEUPDATE_STATE_FROZEN]	= "frozen",
+	[LIVEUPDATE_STATE_UPDATED]	= "updated",
+};
+
+static bool luo_enabled;
+
+static int __init early_liveupdate_param(char *buf)
+{
+	return kstrtobool(buf, &luo_enabled);
+}
+early_param("liveupdate", early_liveupdate_param);
+
+/* Return true if the current state is equal to the provided state */
+static inline bool is_current_luo_state(enum liveupdate_state expected_state)
+{
+	return liveupdate_get_state() == expected_state;
+}
+
+static void __luo_set_state(enum liveupdate_state state)
+{
+	WRITE_ONCE(luo_state, state);
+}
+
+static inline void luo_set_state(enum liveupdate_state state)
+{
+	pr_info("Switched from [%s] to [%s] state\n",
+		luo_current_state_str(), luo_state_str[state]);
+	__luo_set_state(state);
+}
+
+static int luo_do_freeze_calls(void)
+{
+	return 0;
+}
+
+static void luo_do_finish_calls(void)
+{
+}
+
+/* Get the current state as a string */
+const char *luo_current_state_str(void)
+{
+	return luo_state_str[liveupdate_get_state()];
+}
+
+enum liveupdate_state liveupdate_get_state(void)
+{
+	return READ_ONCE(luo_state);
+}
+
+int luo_prepare(void)
+{
+	return 0;
+}
+
+/**
+ * luo_freeze() - Initiate the final freeze notification phase for live update.
+ *
+ * Attempts to transition the live update orchestrator state from
+ * %LIVEUPDATE_STATE_PREPARED to %LIVEUPDATE_STATE_FROZEN. This function is
+ * typically called just before the actual reboot system call (e.g., kexec)
+ * is invoked, either directly by the orchestration tool or potentially from
+ * within the reboot syscall path itself.
+ *
+ * @return  0: Success. Negative error otherwise. State is reverted to
+ * %LIVEUPDATE_STATE_NORMAL in case of an error during callbacks, and everything
+ * is canceled via cancel notifcation.
+ */
+int luo_freeze(void)
+{
+	int ret;
+
+	if (down_write_killable(&luo_state_rwsem)) {
+		pr_warn("[freeze] event canceled by user\n");
+		return -EAGAIN;
+	}
+
+	if (!is_current_luo_state(LIVEUPDATE_STATE_PREPARED)) {
+		pr_warn("Can't switch to [%s] from [%s] state\n",
+			luo_state_str[LIVEUPDATE_STATE_FROZEN],
+			luo_current_state_str());
+		up_write(&luo_state_rwsem);
+
+		return -EINVAL;
+	}
+
+	ret = luo_do_freeze_calls();
+	if (!ret)
+		luo_set_state(LIVEUPDATE_STATE_FROZEN);
+	else
+		luo_set_state(LIVEUPDATE_STATE_NORMAL);
+
+	up_write(&luo_state_rwsem);
+
+	return ret;
+}
+
+/**
+ * luo_finish - Finalize the live update process in the new kernel.
+ *
+ * This function is called  after a successful live update reboot into a new
+ * kernel, once the new kernel is ready to transition to the normal operational
+ * state. It signals the completion of the live update sequence to subsystems.
+ *
+ * @return 0 on success, ``-EAGAIN`` if the state change was cancelled by the
+ * user while waiting for the lock, or ``-EINVAL`` if the orchestrator is not in
+ * the updated state.
+ */
+int luo_finish(void)
+{
+	if (down_write_killable(&luo_state_rwsem)) {
+		pr_warn("[finish] event canceled by user\n");
+		return -EAGAIN;
+	}
+
+	if (!is_current_luo_state(LIVEUPDATE_STATE_UPDATED)) {
+		pr_warn("Can't switch to [%s] from [%s] state\n",
+			luo_state_str[LIVEUPDATE_STATE_NORMAL],
+			luo_current_state_str());
+		up_write(&luo_state_rwsem);
+
+		return -EINVAL;
+	}
+
+	luo_do_finish_calls();
+	luo_set_state(LIVEUPDATE_STATE_NORMAL);
+
+	up_write(&luo_state_rwsem);
+
+	return 0;
+}
+
+int luo_cancel(void)
+{
+	return 0;
+}
+
+void luo_state_read_enter(void)
+{
+	down_read(&luo_state_rwsem);
+}
+
+void luo_state_read_exit(void)
+{
+	up_read(&luo_state_rwsem);
+}
+
+static int __init luo_startup(void)
+{
+	__luo_set_state(LIVEUPDATE_STATE_NORMAL);
+
+	return 0;
+}
+early_initcall(luo_startup);
+
+/* Public Functions */
+
+/**
+ * liveupdate_reboot() - Kernel reboot notifier for live update final
+ * serialization.
+ *
+ * This function is invoked directly from the reboot() syscall pathway if a
+ * reboot is initiated while the live update state is %LIVEUPDATE_STATE_PREPARED
+ * (i.e., if the user did not explicitly trigger the frozen state). It handles
+ * the implicit transition into the final frozen state.
+ *
+ * It triggers the %LIVEUPDATE_REBOOT event callbacks for participating
+ * subsystems. These callbacks must perform final state saving very quickly as
+ * they execute during the blackout period just before kexec.
+ *
+ * If any %LIVEUPDATE_FREEZE callback fails, this function triggers the
+ * %LIVEUPDATE_CANCEL event for all participants to revert their state, aborts
+ * the live update, and returns an error.
+ */
+int liveupdate_reboot(void)
+{
+	if (!is_current_luo_state(LIVEUPDATE_STATE_PREPARED))
+		return 0;
+
+	return luo_freeze();
+}
+
+/**
+ * liveupdate_state_updated - Check if the system is in the live update
+ * 'updated' state.
+ *
+ * This function checks if the live update orchestrator is in the
+ * ``LIVEUPDATE_STATE_UPDATED`` state. This state indicates that the system has
+ * successfully rebooted into a new kernel as part of a live update, and the
+ * preserved devices are expected to be in the process of being reclaimed.
+ *
+ * This is typically used by subsystems during early boot of the new kernel
+ * to determine if they need to attempt to restore state from a previous
+ * live update.
+ *
+ * @return true if the system is in the ``LIVEUPDATE_STATE_UPDATED`` state,
+ * false otherwise.
+ */
+bool liveupdate_state_updated(void)
+{
+	return is_current_luo_state(LIVEUPDATE_STATE_UPDATED);
+}
+
+/**
+ * liveupdate_state_normal - Check if the system is in the live update 'normal'
+ * state.
+ *
+ * This function checks if the live update orchestrator is in the
+ * ``LIVEUPDATE_STATE_NORMAL`` state. This state indicates that no live update
+ * is in progress. It represents the default operational state of the system.
+ *
+ * This can be used to gate actions that should only be performed when no
+ * live update activity is occurring.
+ *
+ * @return true if the system is in the ``LIVEUPDATE_STATE_NORMAL`` state,
+ * false otherwise.
+ */
+bool liveupdate_state_normal(void)
+{
+	return is_current_luo_state(LIVEUPDATE_STATE_NORMAL);
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
+	return luo_enabled;
+}
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
new file mode 100644
index 000000000000..3d10f3eb20a7
--- /dev/null
+++ b/kernel/liveupdate/luo_internal.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#ifndef _LINUX_LUO_INTERNAL_H
+#define _LINUX_LUO_INTERNAL_H
+
+int luo_cancel(void);
+int luo_prepare(void);
+int luo_freeze(void);
+int luo_finish(void);
+
+void luo_state_read_enter(void);
+void luo_state_read_exit(void);
+
+const char *luo_current_state_str(void);
+
+#endif /* _LINUX_LUO_INTERNAL_H */
diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
new file mode 100644
index 000000000000..3df1ec9fbe57
--- /dev/null
+++ b/kernel/liveupdate/luo_ioctl.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/liveupdate.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <uapi/linux/liveupdate.h>
+#include "luo_internal.h"
+
+static const struct file_operations fops = {
+	.owner		= THIS_MODULE,
+};
+
+static struct miscdevice liveupdate_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name  = "liveupdate",
+	.fops  = &fops,
+};
+
+static int __init liveupdate_init(void)
+{
+	if (!liveupdate_enabled())
+		return 0;
+
+	return misc_register(&liveupdate_miscdev);
+}
+module_init(liveupdate_init);
+
+static void __exit liveupdate_exit(void)
+{
+	misc_deregister(&liveupdate_miscdev);
+}
+module_exit(liveupdate_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pasha Tatashin");
+MODULE_DESCRIPTION("Live Update Orchestrator");
+MODULE_VERSION("0.1");
-- 
2.50.1.565.gc32cd1483b-goog


