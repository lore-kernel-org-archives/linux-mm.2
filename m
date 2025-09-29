Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48249CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D502F8E0020; Sun, 28 Sep 2025 21:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2098E0006; Sun, 28 Sep 2025 21:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B6C8E0020; Sun, 28 Sep 2025 21:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 961F88E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66939B7497
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:50 +0000 (UTC)
X-FDA: 83940493140.14.41506BB
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 983B14000A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="OTEfPKf/";
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwXh0/kKCu0f+t04ISmoQpHfND/zfxsioOU5iAk15yM=;
	b=fCjroa9tfcuiXxyMAacA7598EnMuIrmZJtidMqQyB+H/J/wkhDirIsfV6A9j/v/ErsqVG3
	hpHZmREyrRn7aMxCBOQ7csGbqRva6MMjj83X4CuC0JEespaPKyKkx2rAPhoWGfvMGwXj70
	eC2HBMD3R6VkpVnBEPHi4EMNGHpbdVc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="OTEfPKf/";
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107888; a=rsa-sha256;
	cv=none;
	b=o9dcoGJ+DLcrxtxrEXHaAW8V3rXef/riH0CQHOZykgJ5sluA8Nwfy7XB9eSZuDX9zeVU8U
	WLAHukd4cUCzarx6TpZAcCltVaibgnnHMSndgIJs6Z26qzLtcB2nIPepKweLlTa9qU9WbC
	QehjGgDm2Ys5dVE92A4yvButLdNRJwk=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4da894db6e9so37102281cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107888; x=1759712688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pwXh0/kKCu0f+t04ISmoQpHfND/zfxsioOU5iAk15yM=;
        b=OTEfPKf/fpEf1Ajyd1rhFcG1bxa/b+GjF8gHuGUrfgZl7SOtoSmihrYTpkYvftvnWT
         GuNEezbq1QvGpmUsFnmtg63UPFuZEoc0epGMIQ+xO+io7Q/Ak3QU7onyE3xMD5BC9Zpv
         eT9DDG4/p5GNaid12LTOjm/4bU8VToyTMA5PdFG46nnhTUxC+E/8KOYiOYtAIYwkw9Qq
         N6ME7vzBTAPvf7pOUlbtI4uVqRALYJm8Yo7RKnsoo02L6ry3A4NUL5zd+lA4BM7NAwIf
         6sPrxYkRBZUl3GFqGe4o06FQnUwInzEztsm7tkRgOnq+Fb/vgCLKtsdg5TYZAKHAtCjn
         ncPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107888; x=1759712688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pwXh0/kKCu0f+t04ISmoQpHfND/zfxsioOU5iAk15yM=;
        b=GFsQrhEXyE60a7lnUq3FaMDW9qGISXrnHB7rrpZoY7KdrcVEULoAWDREcppIzaEHFr
         uV4YuwZs8w91CHhiLpEjGArwqfEyBRwgB1SESvKE3ma6EKXhBKxT+vuGrXwFAFia1psm
         aWsUC2z3SLLspJMvyyfQrmF3kKz5ZIl2xhYSLddPDIPILtCSBdzr/WKkZJTAC7g6/lBa
         HmCuXXa2OOo9q1Yn41XzwQXZyirxhAz3Zf0XR0RsDY2rpOuOR8CYcwh2NYhnn9p8fRmY
         GaH0f2UrFkjx3uUyQVsrj4vlTUmnKq6Dz0FMflahlh5Loqk7Ib2bAHmt8wip7Z6IWIr1
         WgPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSBvFBF+zczfQEAdst2uk3DTeYZ9iRskjddP9iO+3QhM7KDYQoMl4Yb9N9DtEnLTYn0eZCRMvVBQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+CY9bnNZPySELjvV2JRWDkuNpIIZt2FBJq+9OnK/fiYJ9K/zz
	ziKxvnHPCNt2IBGL+E4X9vq6/7IJt85yIaCQPHng5dYCByO0Tl00/tqFjTSsyKnVnrw=
X-Gm-Gg: ASbGncsvXUzVbnWWsr72iGGS5Y6wtfCJ0wMH3ZI4R7KQEdUkSPpkZevPzhLlGm2nQDm
	cYUAEV85FLx6GUDwSCeatF6a1HPIXypl3eNIukDpuFfQNSbdkKXf09JxrdnuN7SYtyX/Ac2CBBm
	zUJfZ+8iqvzbhl+tiHQ2XIjdgqxDrRnZ6FYkunfJrPs85TIMmwND2ix4cBD0/fJOCFWQGpUC6Ic
	2HhoGbWF5tiCDii04c/sITeZ6aV6vq12TkggNQcu4Jr0x0BlNmYRQvsYbE1V+joTx551HNsbchg
	GWlMQljTgeeR0OS7MqlXzsEdDu4s5CSxJdgB8H/1sRLOkoegMlSsZoinVJD4pV15+i6OZlyDzcS
	orsKayLjlP4iv5bzZLorzCb/3sBrsS8GNIyoQwe0XRwP7ClHFzG7iarWY10ZDxG61x3htH5e0Z3
	m3tNHCP3tBWlzBUuPUEA==
X-Google-Smtp-Source: AGHT+IGRP/eMVDf7zXMK0pi9Zti3NauS9lYe/VmLc3i8GoMpiU6Y/BcqSpE7f6fMLGjBIl3ZckzaXg==
X-Received: by 2002:a05:622a:1b07:b0:4c0:983:9436 with SMTP id d75a77b69052e-4da48e74a08mr188378531cf.34.1759107887482;
        Sun, 28 Sep 2025 18:04:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:46 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 24/30] luo: allow preserving memfd
Date: Mon, 29 Sep 2025 01:03:15 +0000
Message-ID: <20250929010321.3462457-25-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 983B14000A
X-Rspamd-Server: rspam05
X-Stat-Signature: bwe6hcrxu1hizun3az6bqfw5q8ny5hbi
X-Rspam-User: 
X-HE-Tag: 1759107888-50544
X-HE-Meta: U2FsdGVkX1+9baFDnZJklsdChPXZUtHLkeEd9w3RMNBKhiyqK4BE3QjjI6J/x58OgpldH26ZrYC7TAPbU7KChCurzT/AbEeCH3DIWODUxK7O4TnVotMzF6R1xUKvljjYBvlQdodehXkTRau3y3CNstQlJiAR35ZL5DKO7FgUHscooSvMeYCAhsjKHnH2FKC+nXTbgP3A6d5e2QzouRNvkVegZ9kBA6k3p7n+xQ69IwcRRfpQvyDzyghw2sF8diw82wXa8JYtYeuHiRVcqF6nbMYEXnunF9I3R004dD+iLXFAlNp39kqsjH0TSl1Re3hRgIuQnm5Qpofsnjn5Snm330gknjQZ3MQU3AFHWL3Nc1VF5y5vIZBsul42ZJgier0b9/u5PSEQmRDtty1ujG2sAEzSC5VoiuTtnT7YEjqumdvYf0ELSYBxpIWFUWqrUKXFeawvN+YgtRxhBliHpv64mK0SW5uz3pliJN11j35ICOY0coCBGb8n2p06c0tLXLlZ9rv13o/lLjO4EBCmDNB6Di4pxEhfIg8E7VN2NAWTHBg4M9U3P37NXeyaNTHipR0BA7O5un8t2hyNpkS6cXZ5eresCvKi5/VJMuU7hWB25aOw3WCMM8J5D1gHMstxcZYKYHfRIDPQxkMd+p2tFdWQ16NzHge4jcoQeIQ+/q57YLlaP1yV+7aRmfBrfSJRtIlmqHtq+BUfshgK1gwNCB5BapWyoNSNmCyFNFOKzOHrgkidH3FPKFh6mqy5ipXFNvWF3fziVlwX/O7RqL6/r+8iFvppylw++P+eJMuh/oUzvPXOrRWmqRnfIptzp2VhVPJFC0Ao0sIPsbG3XKvdvjXlmoVMsPWrufpOoE4gJe1L1tr+V50gdWe5q0hg2XELAIegXm6+kCdVv+9o7JRBprt4oBZFB9ku/FlirYVbZ14uX270MFMmP6YMWaPHpzvMrbeiyiWWZg6PBDxaCg3LcHH
 i1202WZN
 l3MyODYE56YidFd88Tw31IuYqUKG48nUUnatSX/qoyKiGVM3RwfJGBGYRInr+gSWGlnf3CbYfJtypWWZc6rfNfifpJOfyV3dAzFP/IuZfnkUf7Qabruc+X3++StqT44GYpN7GqTsXDSWdVUwj47zqaIN5S3oYMoWEeSc2PJZMoShblDzQx8bu0u/NRo23g1Csoenyk69/lzpvtqNXS0Pw5c72jnf3p310Na8NLIUC8KUjpYta6SsF8uRnk6KBK6nxPUHrYpWrRQ0L0pQOj+7tjdtFYYU2wyx9BqiUXB+8WCrHAvGv0SycQXaDGL53hwnOK0iR08GEiUajbPg1QSW/PVTRwHv7lpO2C0HqC2D2GyT2KyyXCN8uBMwdpMreCAuOBGD4eu6/I7Y+xJ/PI5RgCqPuT0ERm9X8DUltlwS2n9KmAPidjS8naJWgVjGKFVDMckARvlXPVxPuEFT80kKMUZAacXDJDOswqE8b12Xahuk4r9NGS8wU/H0Zwgy9jO1pu3T4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

The ability to preserve a memfd allows userspace to use KHO and LUO to
transfer its memory contents to the next kernel. This is useful in many
ways. For one, it can be used with IOMMUFD as the backing store for
IOMMU page tables. Preserving IOMMUFD is essential for performing a
hypervisor live update with passthrough devices. memfd support provides
the first building block for making that possible.

For another, applications with a large amount of memory that takes time
to reconstruct, reboots to consume kernel upgrades can be very
expensive. memfd with LUO gives those applications reboot-persistent
memory that they can use to quickly save and reconstruct that state.

While memfd is backed by either hugetlbfs or shmem, currently only
support on shmem is added. To be more precise, support for anonymous
shmem files is added.

The handover to the next kernel is not transparent. All the properties
of the file are not preserved; only its memory contents, position, and
size. The recreated file gets the UID and GID of the task doing the
restore, and the task's cgroup gets charged with the memory.

After LUO is in prepared state, the file cannot grow or shrink, and all
its pages are pinned to avoid migrations and swapping. The file can
still be read from or written to.

Co-developed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---
 MAINTAINERS    |   2 +
 mm/Makefile    |   1 +
 mm/memfd_luo.c | 523 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 526 insertions(+)
 create mode 100644 mm/memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e99af6101d3c..a17e4e077174 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14433,6 +14433,7 @@ F:	tools/testing/selftests/livepatch/
 
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
@@ -14441,6 +14442,7 @@ F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
+F:	mm/memfd_luo.c
 F:	tools/testing/selftests/liveupdate/
 
 LLC (802.2)
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..7738ec416f00 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
+obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
new file mode 100644
index 000000000000..221e31c1197e
--- /dev/null
+++ b/mm/memfd_luo.c
@@ -0,0 +1,523 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ * Changyuan Lyu <changyuanl@google.com>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/file.h>
+#include <linux/io.h>
+#include <linux/libfdt.h>
+#include <linux/liveupdate.h>
+#include <linux/kexec_handover.h>
+#include <linux/shmem_fs.h>
+#include <linux/bits.h>
+#include "internal.h"
+
+#define PRESERVED_PFN_MASK		GENMASK(63, 12)
+#define PRESERVED_PFN_SHIFT		12
+#define PRESERVED_FLAG_DIRTY		BIT(0)
+#define PRESERVED_FLAG_UPTODATE		BIT(1)
+
+#define PRESERVED_FOLIO_PFN(desc)	(((desc) & PRESERVED_PFN_MASK) >> PRESERVED_PFN_SHIFT)
+#define PRESERVED_FOLIO_FLAGS(desc)	((desc) & ~PRESERVED_PFN_MASK)
+#define PRESERVED_FOLIO_MKDESC(pfn, flags) (((pfn) << PRESERVED_PFN_SHIFT) | (flags))
+
+struct memfd_luo_preserved_folio {
+	/*
+	 * The folio descriptor is made of 2 parts. The bottom 12 bits are used
+	 * for storing flags, the others for storing the PFN.
+	 */
+	u64 foliodesc;
+	u64 index;
+};
+
+static int memfd_luo_preserve_folios(struct memfd_luo_preserved_folio *pfolios,
+				     struct folio **folios,
+				     unsigned int nr_folios)
+{
+	int err;
+	long i;
+
+	for (i = 0; i < nr_folios; i++) {
+		struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
+		struct folio *folio = folios[i];
+		unsigned int flags = 0;
+		unsigned long pfn;
+
+		err = kho_preserve_folio(folio);
+		if (err)
+			goto err_unpreserve;
+
+		pfn = folio_pfn(folio);
+		if (folio_test_dirty(folio))
+			flags |= PRESERVED_FLAG_DIRTY;
+		if (folio_test_uptodate(folio))
+			flags |= PRESERVED_FLAG_UPTODATE;
+
+		pfolio->foliodesc = PRESERVED_FOLIO_MKDESC(pfn, flags);
+		pfolio->index = folio->index;
+	}
+
+	return 0;
+
+err_unpreserve:
+	i--;
+	for (; i >= 0; i--)
+		WARN_ON_ONCE(kho_unpreserve_folio(folios[i]));
+	return err;
+}
+
+static void memfd_luo_unpreserve_folios(const struct memfd_luo_preserved_folio *pfolios,
+					unsigned int nr_folios)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
+		struct folio *folio;
+
+		if (!pfolio->foliodesc)
+			continue;
+
+		folio = pfn_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+
+		WARN_ON_ONCE(kho_unpreserve_folio(folio));
+		unpin_folio(folio);
+	}
+}
+
+static void *memfd_luo_create_fdt(unsigned long size)
+{
+	unsigned int order = get_order(size);
+	struct folio *fdt_folio;
+	int err = 0;
+	void *fdt;
+
+	if (order > MAX_PAGE_ORDER)
+		return NULL;
+
+	fdt_folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, order);
+	if (!fdt_folio)
+		return NULL;
+
+	fdt = folio_address(fdt_folio);
+
+	err |= fdt_create(fdt, (1 << (order + PAGE_SHIFT)));
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	if (err)
+		goto free;
+
+	return fdt;
+
+free:
+	folio_put(fdt_folio);
+	return NULL;
+}
+
+static int memfd_luo_finish_fdt(void *fdt)
+{
+	int err;
+
+	err = fdt_end_node(fdt);
+	if (err)
+		return err;
+
+	return fdt_finish(fdt);
+}
+
+static int memfd_luo_prepare(struct liveupdate_file_handler *handler,
+			     struct file *file, u64 *data)
+{
+	struct memfd_luo_preserved_folio *preserved_folios;
+	struct inode *inode = file_inode(file);
+	unsigned int max_folios, nr_folios = 0;
+	int err = 0, preserved_size;
+	struct folio **folios;
+	long size, nr_pinned;
+	pgoff_t offset;
+	void *fdt;
+	u64 pos;
+
+	inode_lock(inode);
+	shmem_i_mapping_freeze(inode, true);
+
+	size = i_size_read(inode);
+	if ((PAGE_ALIGN(size) / PAGE_SIZE) > UINT_MAX) {
+		err = -E2BIG;
+		goto err_unlock;
+	}
+
+	/*
+	 * Guess the number of folios based on inode size. Real number might end
+	 * up being smaller if there are higher order folios.
+	 */
+	max_folios = PAGE_ALIGN(size) / PAGE_SIZE;
+	folios = kvmalloc_array(max_folios, sizeof(*folios), GFP_KERNEL);
+	if (!folios) {
+		err = -ENOMEM;
+		goto err_unfreeze;
+	}
+
+	/*
+	 * Pin the folios so they don't move around behind our back. This also
+	 * ensures none of the folios are in CMA -- which ensures they don't
+	 * fall in KHO scratch memory. It also moves swapped out folios back to
+	 * memory.
+	 *
+	 * A side effect of doing this is that it allocates a folio for all
+	 * indices in the file. This might waste memory on sparse memfds. If
+	 * that is really a problem in the future, we can have a
+	 * memfd_pin_folios() variant that does not allocate a page on empty
+	 * slots.
+	 */
+	nr_pinned = memfd_pin_folios(file, 0, size - 1, folios, max_folios,
+				     &offset);
+	if (nr_pinned < 0) {
+		err = nr_pinned;
+		pr_err("failed to pin folios: %d\n", err);
+		goto err_free_folios;
+	}
+	/* nr_pinned won't be more than max_folios which is also unsigned int. */
+	nr_folios = (unsigned int)nr_pinned;
+
+	preserved_size = sizeof(struct memfd_luo_preserved_folio) * nr_folios;
+	if (check_mul_overflow(sizeof(struct memfd_luo_preserved_folio),
+			       nr_folios, &preserved_size)) {
+		err = -E2BIG;
+		goto err_unpin;
+	}
+
+	/*
+	 * Most of the space should be taken by preserved folios. So take its
+	 * size, plus a page for other properties.
+	 */
+	fdt = memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SIZE);
+	if (!fdt) {
+		err = -ENOMEM;
+		goto err_unpin;
+	}
+
+	pos = file->f_pos;
+	err = fdt_property(fdt, "pos", &pos, sizeof(pos));
+	if (err)
+		goto err_free_fdt;
+
+	err = fdt_property(fdt, "size", &size, sizeof(size));
+	if (err)
+		goto err_free_fdt;
+
+	err = fdt_property_placeholder(fdt, "folios", preserved_size,
+				       (void **)&preserved_folios);
+	if (err) {
+		pr_err("Failed to reserve folios property in FDT: %s\n",
+		       fdt_strerror(err));
+		err = -ENOMEM;
+		goto err_free_fdt;
+	}
+
+	err = memfd_luo_preserve_folios(preserved_folios, folios, nr_folios);
+	if (err)
+		goto err_free_fdt;
+
+	err = memfd_luo_finish_fdt(fdt);
+	if (err)
+		goto err_unpreserve;
+
+	err = kho_preserve_folio(virt_to_folio(fdt));
+	if (err)
+		goto err_unpreserve;
+
+	kvfree(folios);
+	inode_unlock(inode);
+
+	*data = virt_to_phys(fdt);
+	return 0;
+
+err_unpreserve:
+	memfd_luo_unpreserve_folios(preserved_folios, nr_folios);
+err_free_fdt:
+	folio_put(virt_to_folio(fdt));
+err_unpin:
+	unpin_folios(folios, nr_pinned);
+err_free_folios:
+	kvfree(folios);
+err_unfreeze:
+	shmem_i_mapping_freeze(inode, false);
+err_unlock:
+	inode_unlock(inode);
+	return err;
+}
+
+static int memfd_luo_freeze(struct liveupdate_file_handler *handler,
+			    struct file *file, u64 *data)
+{
+	u64 pos = file->f_pos;
+	void *fdt;
+	int err;
+
+	if (WARN_ON_ONCE(!*data))
+		return -EINVAL;
+
+	fdt = phys_to_virt(*data);
+
+	/*
+	 * The pos might have changed since prepare. Everything else stays the
+	 * same.
+	 */
+	err = fdt_setprop(fdt, 0, "pos", &pos, sizeof(pos));
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void memfd_luo_cancel(struct liveupdate_file_handler *handler,
+			     struct file *file, u64 data)
+{
+	const struct memfd_luo_preserved_folio *pfolios;
+	struct inode *inode = file_inode(file);
+	struct folio *fdt_folio;
+	void *fdt;
+	int len;
+
+	if (WARN_ON_ONCE(!data))
+		return;
+
+	inode_lock(inode);
+	shmem_i_mapping_freeze(inode, false);
+
+	fdt = phys_to_virt(data);
+	fdt_folio = virt_to_folio(fdt);
+	pfolios = fdt_getprop(fdt, 0, "folios", &len);
+	if (pfolios)
+		memfd_luo_unpreserve_folios(pfolios, len / sizeof(*pfolios));
+
+	kho_unpreserve_folio(fdt_folio);
+	folio_put(fdt_folio);
+	inode_unlock(inode);
+}
+
+static struct folio *memfd_luo_get_fdt(u64 data)
+{
+	return kho_restore_folio((phys_addr_t)data);
+}
+
+static void memfd_luo_discard_folios(const struct memfd_luo_preserved_folio *pfolios,
+				     unsigned int nr_folios)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
+		struct folio *folio;
+		phys_addr_t phys;
+
+		if (!pfolio->foliodesc)
+			continue;
+
+		phys = PFN_PHYS(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+		folio = kho_restore_folio(phys);
+		if (!folio) {
+			pr_warn_ratelimited("Unable to restore folio at physical address: %llx\n",
+					    phys);
+			continue;
+		}
+
+		folio_put(folio);
+	}
+}
+
+static void memfd_luo_finish(struct liveupdate_file_handler *handler,
+			     struct file *file, u64 data, bool reclaimed)
+{
+	const struct memfd_luo_preserved_folio *pfolios;
+	struct folio *fdt_folio;
+	int len;
+
+	if (reclaimed)
+		return;
+
+	fdt_folio = memfd_luo_get_fdt(data);
+
+	pfolios = fdt_getprop(folio_address(fdt_folio), 0, "folios", &len);
+	if (pfolios)
+		memfd_luo_discard_folios(pfolios, len / sizeof(*pfolios));
+
+	folio_put(fdt_folio);
+}
+
+static int memfd_luo_retrieve(struct liveupdate_file_handler *handler, u64 data,
+			      struct file **file_p)
+{
+	const struct memfd_luo_preserved_folio *pfolios;
+	int nr_pfolios, len, ret = 0, i = 0;
+	struct address_space *mapping;
+	struct folio *folio, *fdt_folio;
+	const u64 *pos, *size;
+	struct inode *inode;
+	struct file *file;
+	const void *fdt;
+
+	fdt_folio = memfd_luo_get_fdt(data);
+	if (!fdt_folio)
+		return -ENOENT;
+
+	fdt = page_to_virt(folio_page(fdt_folio, 0));
+
+	pfolios = fdt_getprop(fdt, 0, "folios", &len);
+	if (!pfolios || len % sizeof(*pfolios)) {
+		pr_err("invalid 'folios' property\n");
+		ret = -EINVAL;
+		goto put_fdt;
+	}
+	nr_pfolios = len / sizeof(*pfolios);
+
+	size = fdt_getprop(fdt, 0, "size", &len);
+	if (!size || len != sizeof(u64)) {
+		pr_err("invalid 'size' property\n");
+		ret = -EINVAL;
+		goto put_folios;
+	}
+
+	pos = fdt_getprop(fdt, 0, "pos", &len);
+	if (!pos || len != sizeof(u64)) {
+		pr_err("invalid 'pos' property\n");
+		ret = -EINVAL;
+		goto put_folios;
+	}
+
+	file = shmem_file_setup("", 0, VM_NORESERVE);
+
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		pr_err("failed to setup file: %d\n", ret);
+		goto put_folios;
+	}
+
+	inode = file->f_inode;
+	mapping = inode->i_mapping;
+	vfs_setpos(file, *pos, MAX_LFS_FILESIZE);
+
+	for (; i < nr_pfolios; i++) {
+		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
+		phys_addr_t phys;
+		u64 index;
+		int flags;
+
+		if (!pfolio->foliodesc)
+			continue;
+
+		phys = PFN_PHYS(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+		folio = kho_restore_folio(phys);
+		if (!folio) {
+			pr_err("Unable to restore folio at physical address: %llx\n",
+			       phys);
+			goto put_file;
+		}
+		index = pfolio->index;
+		flags = PRESERVED_FOLIO_FLAGS(pfolio->foliodesc);
+
+		/* Set up the folio for insertion. */
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+
+		ret = mem_cgroup_charge(folio, NULL, mapping_gfp_mask(mapping));
+		if (ret) {
+			pr_err("shmem: failed to charge folio index %d: %d\n",
+			       i, ret);
+			goto unlock_folio;
+		}
+
+		ret = shmem_add_to_page_cache(folio, mapping, index, NULL,
+					      mapping_gfp_mask(mapping));
+		if (ret) {
+			pr_err("shmem: failed to add to page cache folio index %d: %d\n",
+			       i, ret);
+			goto unlock_folio;
+		}
+
+		if (flags & PRESERVED_FLAG_UPTODATE)
+			folio_mark_uptodate(folio);
+		if (flags & PRESERVED_FLAG_DIRTY)
+			folio_mark_dirty(folio);
+
+		ret = shmem_inode_acct_blocks(inode, 1);
+		if (ret) {
+			pr_err("shmem: failed to account folio index %d: %d\n",
+			       i, ret);
+			goto unlock_folio;
+		}
+
+		shmem_recalc_inode(inode, 1, 0);
+		folio_add_lru(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	inode->i_size = *size;
+	*file_p = file;
+	folio_put(fdt_folio);
+	return 0;
+
+unlock_folio:
+	folio_unlock(folio);
+	folio_put(folio);
+put_file:
+	fput(file);
+	i++;
+put_folios:
+	for (; i < nr_pfolios; i++) {
+		const struct memfd_luo_preserved_folio *pfolio = &pfolios[i];
+
+		folio = kho_restore_folio(PRESERVED_FOLIO_PFN(pfolio->foliodesc));
+		if (folio)
+			folio_put(folio);
+	}
+
+put_fdt:
+	folio_put(fdt_folio);
+	return ret;
+}
+
+static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
+				   struct file *file)
+{
+	struct inode *inode = file_inode(file);
+
+	return shmem_file(file) && !inode->i_nlink;
+}
+
+static const struct liveupdate_file_ops memfd_luo_file_ops = {
+	.prepare = memfd_luo_prepare,
+	.freeze = memfd_luo_freeze,
+	.cancel = memfd_luo_cancel,
+	.finish = memfd_luo_finish,
+	.retrieve = memfd_luo_retrieve,
+	.can_preserve = memfd_luo_can_preserve,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler memfd_luo_handler = {
+	.ops = &memfd_luo_file_ops,
+	.compatible = "memfd-v1",
+};
+
+static int __init memfd_luo_init(void)
+{
+	int err;
+
+	err = liveupdate_register_file_handler(&memfd_luo_handler);
+	if (err)
+		pr_err("Could not register luo filesystem handler: %d\n", err);
+
+	return err;
+}
+late_initcall(memfd_luo_init);
-- 
2.51.0.536.g15c5d4f767-goog


