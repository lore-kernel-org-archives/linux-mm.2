Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB26C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E1E6B00BA; Wed,  6 Aug 2025 21:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE5C8E0002; Wed,  6 Aug 2025 21:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25926B00BC; Wed,  6 Aug 2025 21:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D09AB6B00BA
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AB921606AB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:32 +0000 (UTC)
X-FDA: 83748269304.11.B3E0EF4
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id C89698000F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZxVKsShO;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehkeScdrauztu8T9he2tGLB8hND8bPPz6tbPB+5xOmw=;
	b=AbChlMe4CLjFfFoXANnXLb0qqOon4A7Yuk8kkTmodXjo7v/B5z8wWXzNQ3nKKj7xon5A1B
	NPaV2n3mNJic2xRIsvQ3imwCvFcbApCR4en7Zpom0xe69qT+v231qkNogbujGNgdBSf857
	bxtNj2kC9ITVjgE+2d2UFlUV8FTqfvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531130; a=rsa-sha256;
	cv=none;
	b=0IkUYn3t9JCJmCPxre+6ak2F9AUPYMPCRvDndOESavUu2WImMJttkMcYGH+Rf6qpxESmxo
	ajCkEQ9HYmWFO86zO7fOMnTuqv6d1CVuhuWjjFa0syA82oyFdtQKY/XjgxYFIuesoWQhUl
	MZMfghNEBN9eCxuijMB/g7WhTOcvQF0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZxVKsShO;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4af14096b9eso7602451cf.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531130; x=1755135930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ehkeScdrauztu8T9he2tGLB8hND8bPPz6tbPB+5xOmw=;
        b=ZxVKsShOIzt0akuPrC6tgAmLt0Po6hXRUA3TYEzzXZ+ul4DCzobCnNX7l63riGE/1r
         XFuHq4Q4L1FGPKyjEgUAKF4zjHdzwINjZnj26MOjbWrzi5AB4DZ6bD3OnMzLaUBICoZW
         P09g0p5Igyz/3wN7Xg15rfK/W7Mpt2VWBseTlW9rKvlYFqYdIJd25JOKyhXzraqmg/zX
         1pddIVCPHyN7oHBCDCqmc1SR5radRA3+nR/TQUaJr+ocnrm2AW3UV4chkdpq5AKOADR3
         2cS90+XkyRofLw4Bjl0T6e6jYktTue7GIshz8+yXsvSMiM+db4eiaoD/cqf88uceuSik
         hXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531130; x=1755135930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehkeScdrauztu8T9he2tGLB8hND8bPPz6tbPB+5xOmw=;
        b=XR8Y1DYPp0F2nM4g7ug5GEtPTNoGCLhmh3mnCYXQrDuNJhoEOgeLt3g+B0On7Ue+dZ
         SAdD4ERceEPoFw+DXNWZ2BXmZ5vm0mK9EwcHeBe2cA0j7CAe6w7sMEitKQNcY2x3Yocy
         ThlGg08sxGkxQ1Rh5uwPlZziWn3b0bPgm0onZY6LDXtHvxMT3pbymnCxQttGfEoLjcZJ
         IrHihfRPh3zrxIYO/Q16OMlUGBvVamUxCYS3vCSiEVfFiJSe3tBvLg3sp/M64TX92Aio
         OodyAXf2QTbpLkE6vceRbltxneNwmb4s8ESoxuRdNmuKIeAOAR+udwusSJ+KJ3E8IQ+5
         1wpA==
X-Forwarded-Encrypted: i=1; AJvYcCWxSzA8mA8fIvzdlXOlwp6CuiYqCEu4gA2QflIba52D1ILwuCB0YdOhRUN3y4Xg2QpzwS2ir86t2A==@kvack.org
X-Gm-Message-State: AOJu0YxwhhZLGYCbVr5ohL/DK2OEd7gFwXty2h32zQP0bnHevU5JpWYA
	Au8I9Ig0+7v+xd8IidKKTCIXez0F9aXzMKuFYv767WGa/ep+/jvw2WcaOep8J8xBTKs=
X-Gm-Gg: ASbGnctAHD8TjSqAhhbIlgO0MPWW7jkkkoB6CFweZpNIuXTSBIOPF446IfM2MZ3Own9
	SVXCdei2/IrurLdNMWGIm/GMqYacYC7wQyTyPyxlPLu7VUxWk8xEexOPsdvQ9bSHQXZ7WeTQUOL
	y4xS9XvrRgTEjFtyu2TIChAkeaR3C5UjGomOX6eHpgrKobcjHjFrbE9iSurJ4Kf3YGtNaASSEKD
	BN1+a67SLVL9F+raUfritZ0e2SGwS/QmhBDwpoYJSsmUTYX2UGRBpTBKLRvu7gJ3UUgKTqwPjU5
	pIFwkP7e0F4o7zTS7F3A907UqDOUwR/Mmk0U/nTVpyaVz3HAPJzxQuf/Gw75Pj2CR5RJmQlgeZa
	f5eZQnZRXZnfUBLo9WcSIda3tM5YnQfQ+pUHC8ethMdKgaF3fZmV14R/LHTBJxCCb5uuLN6Qg3M
	ZavFujoFDHS8Os
X-Google-Smtp-Source: AGHT+IGqYgaN1YVbRBRIlJ65LL6blzyWcpm1/jVEKqTrwyRimKIgHpEcS08wJGhbX5ipdDSbTol6hA==
X-Received: by 2002:a05:622a:1211:b0:4b0:6965:dd97 with SMTP id d75a77b69052e-4b0915b344bmr63499471cf.44.1754531129758;
        Wed, 06 Aug 2025 18:45:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:29 -0700 (PDT)
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
Subject: [PATCH v3 29/30] luo: allow preserving memfd
Date: Thu,  7 Aug 2025 01:44:35 +0000
Message-ID: <20250807014442.3829950-30-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C89698000F
X-Stat-Signature: irrdhz47omuw3x8ef3xzorrkq8qjopxy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754531130-366820
X-HE-Meta: U2FsdGVkX1+kkagThTkk7ESXZxXdMonIoqKbK44a0kCjr56m056Yf7spH8d71YEQuikCEbmtMBaYgdUuyfk65yDz5v8EiAJnjU5RXBSulpYAsUU7WtBskZ/Geq9xvyAxmHxBMEKVuX99mdVTIRbm00hsVi2WmdLyCtUMk6H1x+/vIsfV/HfOs+YLqQG5DnmOQxL1gdVpmoPI+f6qmC0p7jDScG1mNX4jlcnejFgY1sViHLZOXpo0VgK2NJ+aXF51gmw81rUYijdAwKj8/2rBSPYMdYqA9+/Oekewz/t8K2UNptrIEVXL5Q2tbhnK9rN2VaciOJ8rGkus4gDWg1tT3XwsnB3kuQgenZ1GJzEA1j5/YPFrY99Sa+gI0RxSMrzR0kXu2hFOi0ed0cBVcJDrKPibdGvNh3ghYpxu97vNJCoHsQU+WrRnwHb2Q3yXSQAh4DuM0ijFd8EG912yxbn1ArMWBDz9rCaBRi0T57l58NSYtDM3eHKWHU5GMbHvp26swpb5J5SPNEBC3617VwlQ+QFeUl4EzsrQhOgmW3Zg9Cr7++PVpOC7bVGGWlID3W3T0J8GXkBuv+Me8oHz8F6WddcGmHwH2SZSBjH1cBQnSg0O0TAoXe7WBZGmdb9npDgx7RnyVpwgWi4HvggXM7L20kt5k9IQkEDZ/nibKqppAJ0YnS/tgli25J1LysokIVlD+6+bAyzLQOCp4gNxF923spDyKbzCVL0DsClasMMN9GR8hWJtjumiv6iw7JKPqccvMfsfASzkkVOyTyX2mHxiNjRdwUxyk0idISi6el0iGZ8RXMsutBiZGuY/fcFelLYtU8d27kyRVA+VoF2YSDwSqPGlOjrWFqSAudAxPpPzOJeiAnPeXKJ0guMDPDYPbWys8sbwYPCBjv1CD55M2cOia261A7egcOgPbC9JPXipcej0U32zRRL6jhCSZhb2azoH5hdOaHi43ito2JcuxMu
 xuIYs6il
 Pnq9f3xELUQamJAmgG4CSPcjxdm79Y0o1jD66H4VpsKmELZFo8lZg5uDnLCDiSX1VTMRtAGheCZVlNpFfI5x3N5i6dI2saaoYLzE44vaFI+Lxr02Syshn0dXkMCigNlP+3011sma+BFoDIQQdsxLe4q5yLPeRR9MwTzeSRWAAZC8DI9RK9cB2SC+d8z/fZOvmtmcUS3+qILE/gYBVbp8y7MIZKnjwHiqnsGFDuebtGziMpTKfNr2QbpU6GPyicjL6MvZAMP/AJiRtiDZfavo95q0OuoLzVfrCQo4vyErmvabEY3sA7QqYky6/IfXaAGhm9wp13wueaxUpaP7vnQ33UB7NwBF4Nqteh7TyEuLrMNR7kmdQYM1CTfvCMtQ/wwSINrH+ZjPj3e22KT9TEeH0D4UQLz5mWa32Ym4/+k8IfpT/vCjGC78hJ0RX+oj7/ZuB8DR+OGxT017z82uO3WQEPjHP/Rf0XEEg1rOYUk6Pe0DgINh+V6BmEdYFr/Ncwal4pZxr
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
 mm/memfd_luo.c | 507 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 510 insertions(+)
 create mode 100644 mm/memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b88b77977649..7421d21672f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14209,6 +14209,7 @@ F:	tools/testing/selftests/livepatch/
 
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
@@ -14218,6 +14219,7 @@ F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
+F:	mm/memfd_luo.c
 F:	tools/testing/selftests/liveupdate/
 
 LLC (802.2)
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..0a9936ffc172 100644
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
index 000000000000..0c91b40a2080
--- /dev/null
+++ b/mm/memfd_luo.c
@@ -0,0 +1,507 @@
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
+static const char memfd_luo_compatible[] = "memfd-v1";
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
+	unsigned int i;
+	int err;
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
+		kho_unpreserve_folio(folio);
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
+	fdt_folio = folio_alloc(GFP_KERNEL, order);
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
+	if (WARN_ON_ONCE(!shmem_file(file)))
+		return -EINVAL;
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
+	 * The pos or size might have changed since prepare. Everything else
+	 * stays the same.
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
+		memfd_luo_unpreserve_folios(pfolios, len / sizeof(*pfolios));
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
+		/*
+		 * TODO: Should find a way to unify this and
+		 * shmem_alloc_and_add_folio().
+		 */
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
+	.compatible = memfd_luo_compatible,
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
2.50.1.565.gc32cd1483b-goog


