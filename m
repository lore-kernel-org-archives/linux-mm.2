Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889DDCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EB38E002A; Tue,  2 Sep 2025 11:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDDCF8E0002; Tue,  2 Sep 2025 11:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F0C8E002A; Tue,  2 Sep 2025 11:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B08718E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:47:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78DB016024C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:03 +0000 (UTC)
X-FDA: 83844738726.18.082D4EB
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5AA4A140004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8wbVDPR;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYuucEV+T24+u0DRFcF+IL1sfMs9QC6miqmiv7tTdXY=;
	b=sufuHH5PbElIxWAWw10RTxd0H5s9WneGy+X44jdwTqf+bLoy1Lt1kMKxwLQaB/Y/HQlQgi
	1mkpEkRNfzgYUKJor3rSQ5/vEgy3RxC6mtXRHSRNJNY9wdEDrZZ2sbDkerYsxLkocU+fIk
	SSMVxrkdON4K5F9nk4dQWdyxPEnV9rk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N8wbVDPR;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828021; a=rsa-sha256;
	cv=none;
	b=8exDvnqbZDzPGcgyZhDueszyU8IQfJ07ch8j0MW3ptAs9wGrAT4EB96KOLse1BDqQm73T+
	E1zEYikZm34gIaahillB54FVYM7MssNNrCGQAmiS4tFb/xlJJFk/bADHN01BqzkNrCZkB/
	9j240Xa2tVQ1ghwwjbBGoq/rpD7fM8c=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afede1b3d05so924298766b.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828020; x=1757432820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYuucEV+T24+u0DRFcF+IL1sfMs9QC6miqmiv7tTdXY=;
        b=N8wbVDPRFOsRX1LnvEVxEB6KDGYRYYvFoP2AU+9/3yWOuR48+MmjeCssIgcWrmdvQs
         D6WoyiapjEaP+Eq/zsieWt6rHhXIMV19mdhPcie1n33O0UNsldjbH/NfDo/3+zCImBLh
         iod2DUdhUtEk9W+M90AfsLnYozw2lrtadJg/62+cae7SKN2t6Tr8nV9c/l3yIGCC6xBZ
         +biJUZ05Grnm6rlEm7BRQNhqK1tzy4iqOl9CqQ9Q9jQsBpKBmRYcIzO6dMFHqP2nud5K
         GlEuL/7u3DVXAdSaPoNepCTAnPtCiS+00YG99LCg7QX6KnfZj/aklPur17ppfOshX9vv
         JT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828020; x=1757432820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OYuucEV+T24+u0DRFcF+IL1sfMs9QC6miqmiv7tTdXY=;
        b=w15q3/0d4L3yXL7qqx7acJdyQC+G+1YKcni/+MJeiIMgGJXf5eBwhzJ8zjnSsHwaUg
         HvJZkWbx3cQ+KsjqpRc5yp1EFbN8Uwo9qNrVh4ONH1SUuc946YOX7ULpxRAEAfdwLX9g
         EaqV+zOe/guw2MV3qas9F/ewyDoHc41iGqwrBmoP0nmdxF3/0I4gK0+7OIQB36600IRC
         MK4pPui66pWtpPoE/qeRqTaJE9p0OSd1cTTZG/p5AxqofvHTDwdY/A3mFpHhdHS0+b/m
         F/BvqeIIxq7Xh6BUPECr0selF9U7KXbHnsx/uVhdHF7a7x/pdXT6DJrtpcURGafTFStL
         R0mw==
X-Forwarded-Encrypted: i=1; AJvYcCWTVd1jedzbB2ii0snq+SigrZ6WtUBSKldhboG6aCi+QpDAw8Uf2gRuRYhx+ZVrLrrYx6xjx2C6hg==@kvack.org
X-Gm-Message-State: AOJu0YxzP5bRFj/my3107RWKWb85/9eH8R6cfjWuH3nNRK9/FxWUIJz9
	E94rrVdpxoImFpBM+pAYkBdApH63xhUSOXsyU8Brm8lGTBvshmdTPgs3
X-Gm-Gg: ASbGncuyoR7Afq83fTQCmVVJYCj4SB0cXdRxgMlNefALAwZNMbX5paxOciYuwL1pBzO
	ARyyQKzMLwJiFso+u/D4ZAnyjX3i0cJI/g10VW0sY2j9cOaAfquomdmeKeZz0opq3plIOXPNTZr
	2QjLs+Bh4f5o5UndOoyl0QFT85lCgOZvw2CR0jjq9P2CojsveqsBUqqoopyJ2dEyHpy6H/ayAoC
	IYk0MGN5BU0KRoRq+zS4aipzljrAgizYIdhG0Cb5gc9/DZFdpQ/YAAdrQzVQvdSGaeEb8QBHdpK
	neN31laQDhaRLkfRhVQTSlIqOkDWrsZZHjZKwUVMiC2w4F/Hq5HhgjX9eUZm1eSgYnAa6YCRkPi
	u3Of+eUgh/YSr8WEEIU63lb43+2OOTp8Igsi8TMhx3Lng3RyUB/G4hmyYARNr+yV6s2J8nWT9zR
	4LVFvbLq7V2exFbg==
X-Google-Smtp-Source: AGHT+IHDLjwCmuAnP5Vi14ZMWLeQeHOJop7Yqiiag3q+GLo9vvAbZuBNctTPzCghs1ZFkZDLl1I3UQ==
X-Received: by 2002:a17:907:94c9:b0:b04:2f81:5c35 with SMTP id a640c23a62f3a-b042f817f8cmr743278466b.34.1756828019499;
        Tue, 02 Sep 2025 08:46:59 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aff10eb1ee3sm986916066b.19.2025.09.02.08.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:46:56 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 5/9] dma-buf: heaps: Add support for Tegra VPR
Date: Tue,  2 Sep 2025 17:46:25 +0200
Message-ID: <20250902154630.4032984-6-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: akxt8tsj49ug936qaqqy69cj6b13ya71
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AA4A140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756828021-861142
X-HE-Meta: U2FsdGVkX19mFCx/77Pxkep2lIEhxqQO+kTKP4SqcKPbrnOzeNrP8DKP6TMSsVRAnKXrFfBJIAfCkd6Kf6ePf2LlO7t7bDeii8aO95vZ6Bnzhr+tm18qbf0CK5Hqsl7xI3GG0jn34qFWb/sbolwrdld4t3islgZRv1qWTLZc9E0t/n2AjJ90EbHriWPn+tPzO82ftQumNXuIKmH/eKmSjWEhyCk1TM++V0/rtDfB9h02k386Pf+OCM7BTrkyGVkoPgqeR9QvAY87A/4MeolBC1H7O9xx9UQJNzTqGDTrUTN7xNKVwQAk3oLT9D2mmbICdpaGiSm/kvHNbijCl/+AKrlUYJB8HPHQyLJz4bZbNmhi3htm3sm+GMd7WzE++aDxwWr3/CqNnvpatt78ir/x2QOC6iaRY6NKi82PC76ELxBEb5CUbjZ58CcKq+DHfNS3Jfnyj3oy74qPkvAP4d0JuT//h3sDAFdAsES8ZqDm/DCPiDAfLQhHfylh549xrd8yZB7/6WpMBZ0+rlqlXD/y9GnGjNsKszc4/bumjSsgD5J5Qj7JwQXuiPqwuLHPehRgm1VHmqyldI4tgTVCq5OH/O30wnzYFvCZcwZX4dn7IsP+UEx6EEfnD83Q5e8oupHkpTT9PDOQAQtgYpdod8xB9/PgVUrN+ekok3V962WZJZUiwpc3/xeDiEKRgf+lKDgQMJegguoPFoF1ZbiSONgdyfLALPKE6333Ohe0I87kFjhyoMmb4UgjVsFalvR3rqvxSywT9b1LFaY3x2e4WGGY+eX3fIZxCDbEeuPH+mlBY2TCdqSnPT6F6KNp5JSETqu2rNjnlRXLYZ6tmm1b7VBOFyoK3iqX3ONPKAD0mEEh5mpwdcSeL5tD8m6WHoBvyJPlOS/9ToLi/mqnTtAxp2mg60lw7K0q1DupJvwC7e+SdjfRS1ajFxWp05LnrffysWxx1WK0+HoK2QK0oGHOxie
 8F6bg1vk
 +sOMfvvnOhve+PbbA69gZtejgUwzd/b1KFr69kIqha3cPiN0CziJzgircxwpVQz8vYswuh1ZbRmtTdzQwz2y4KaIvBGfVqrcuo222jkFs0c7fTQI151WtlH3V7CdVY1X80VjLrDKaQkvkDHcnMh/KTYdOJHVoGy5hyZL+0iYiG2GwCTKZALmS4HyW/iEHuA3sPI9M9TyMfgE8ZBHsMj9l5/NJZlXuorc39EwBjnXMZjBDzqG18W9GjJ8CNmgvgliKxl8H8hWUgYhgt8iyoZsUHQOe1ya0t2YyE5xdXhY8SLDMldQeowy3oUY/p57PrI7anUl1VDLXX8c9sOqskPoIpFs/rb+Ki93mjfXaw22Z5hoSCtLScGsnMbob0Y8eiff0VjQ+4dUOIbYE58SH4NfGvVDYn9svILbYdtKGkc7VAFB4kYMaQHbWWH0a/9sYjaNSTcN8RNvaqNYyF6CHKT7r3S0OxUnuTen4cOXb1D2wijlGCKeVp96fnDpE9WQrjn7618h6povEYmvZ1esOOagx5TwP9C53tOPL4Av2qzwAlVNuurmEUwcAa5eSry5tV0f5qjBm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

NVIDIA Tegra SoCs commonly define a Video-Protection-Region, which is a
region of memory dedicated to content-protected video decode and
playback. This memory cannot be accessed by the CPU and only certain
hardware devices have access to it.

Expose the VPR as a DMA heap so that applications and drivers can
allocate buffers from this region for use-cases that require this kind
of protected memory.

VPR has a few very critical peculiarities. First, it must be a single
contiguous region of memory (there is a single pair of registers that
set the base address and size of the region), which is configured by
calling back into the secure monitor. The memory region also needs to
quite large for some use-cases because it needs to fit multiple video
frames (8K video should be supported), so VPR sizes of ~2 GiB are
expected. However, some devices cannot afford to reserve this amount
of memory for a particular use-case, and therefore the VPR must be
resizable.

Unfortunately, resizing the VPR is slightly tricky because the GPU found
on Tegra SoCs must be in reset during the VPR resize operation. This is
currently implemented by freezing all userspace processes and calling
invoking the GPU's freeze() implementation, resizing and the thawing the
GPU and userspace processes. This is quite heavy-handed, so eventually
it might be better to implement thawing/freezing in the GPU driver in
such a way that they block accesses to the GPU so that the VPR resize
operation can happen without suspending all userspace.

In order to balance the memory usage versus the amount of resizing that
needs to happen, the VPR is divided into multiple chunks. Each chunk is
implemented as a CMA area that is completely allocated on first use to
guarantee the contiguity of the VPR. Once all buffers from a chunk have
been freed, the CMA area is deallocated and the memory returned to the
system.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/dma-buf/heaps/Kconfig     |   7 +
 drivers/dma-buf/heaps/Makefile    |   1 +
 drivers/dma-buf/heaps/tegra-vpr.c | 831 ++++++++++++++++++++++++++++++
 include/trace/events/tegra_vpr.h  |  57 ++
 4 files changed, 896 insertions(+)
 create mode 100644 drivers/dma-buf/heaps/tegra-vpr.c
 create mode 100644 include/trace/events/tegra_vpr.h

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index bb369b38b001..af97af1bb420 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -22,3 +22,10 @@ config DMABUF_HEAPS_CMA_LEGACY
 	  from the CMA area's devicetree node, or "reserved" if the area is not
 	  defined in the devicetree. This uses the same underlying allocator as
 	  CONFIG_DMABUF_HEAPS_CMA.
+
+config DMABUF_HEAPS_TEGRA_VPR
+	bool "NVIDIA Tegra Video-Protected-Region DMA-BUF Heap"
+	depends on DMABUF_HEAPS && DMA_CMA
+	help
+	  Choose this option to enable Video-Protected-Region (VPR) support on
+	  a range of NVIDIA Tegra devices.
diff --git a/drivers/dma-buf/heaps/Makefile b/drivers/dma-buf/heaps/Makefile
index 974467791032..265b77a7b889 100644
--- a/drivers/dma-buf/heaps/Makefile
+++ b/drivers/dma-buf/heaps/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_DMABUF_HEAPS_SYSTEM)	+= system_heap.o
 obj-$(CONFIG_DMABUF_HEAPS_CMA)		+= cma_heap.o
+obj-$(CONFIG_DMABUF_HEAPS_TEGRA_VPR)	+= tegra-vpr.o
diff --git a/drivers/dma-buf/heaps/tegra-vpr.c b/drivers/dma-buf/heaps/tegra-vpr.c
new file mode 100644
index 000000000000..a36efeb031b8
--- /dev/null
+++ b/drivers/dma-buf/heaps/tegra-vpr.c
@@ -0,0 +1,831 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DMA-BUF restricted heap exporter for NVIDIA Video-Protection-Region (VPR)
+ *
+ * Copyright (C) 2024-2025 NVIDIA Corporation
+ */
+
+#define pr_fmt(fmt) "tegra-vpr: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/cma.h>
+#include <linux/debugfs.h>
+#include <linux/dma-buf.h>
+#include <linux/dma-heap.h>
+#include <linux/of_reserved_mem.h>
+
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/reset.h>
+
+#include <linux/freezer.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/tegra_vpr.h>
+
+struct tegra_vpr;
+
+struct tegra_vpr_device {
+	struct list_head node;
+	struct device *dev;
+};
+
+struct tegra_vpr_chunk {
+	phys_addr_t start;
+	phys_addr_t limit;
+	size_t size;
+
+	struct tegra_vpr *vpr;
+	struct cma *cma;
+	bool active;
+
+	struct page *start_page;
+	unsigned long *bitmap;
+	unsigned long virt;
+	pgoff_t num_pages;
+
+	struct list_head buffers;
+	struct mutex lock;
+};
+
+struct tegra_vpr {
+	struct device_node *dev_node;
+	unsigned long align;
+	phys_addr_t base;
+	phys_addr_t size;
+	bool use_freezer;
+
+	struct tegra_vpr_chunk *chunks;
+	unsigned int num_chunks;
+
+	struct list_head devices;
+	struct mutex lock;
+};
+
+struct tegra_vpr_buffer {
+	struct tegra_vpr_chunk *chunk;
+	struct list_head attachments;
+	struct list_head list;
+	struct mutex lock;
+
+	struct page *start_page;
+	struct page **pages;
+	pgoff_t num_pages;
+	phys_addr_t start;
+	phys_addr_t limit;
+	size_t size;
+	int pageno;
+	int order;
+
+	unsigned long virt;
+};
+
+struct tegra_vpr_attachment {
+	struct device *dev;
+	struct sg_table sgt;
+	struct list_head list;
+};
+
+#define ARM_SMCCC_TE_FUNC_PROGRAM_VPR 0x3
+
+#define ARM_SMCCC_VENDOR_SIP_TE_PROGRAM_VPR_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_SIP,			\
+			   ARM_SMCCC_TE_FUNC_PROGRAM_VPR)
+
+static int tegra_vpr_set(phys_addr_t base, phys_addr_t size)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(ARM_SMCCC_VENDOR_SIP_TE_PROGRAM_VPR_FUNC_ID, base, size,
+		      0, 0, 0, 0, 0, &res);
+
+	return res.a0;
+}
+
+static int tegra_vpr_get_extents(struct tegra_vpr *vpr, phys_addr_t *base,
+				 phys_addr_t *size)
+{
+	phys_addr_t start = ~0, limit = 0;
+	unsigned int i;
+
+	for (i = 0; i < vpr->num_chunks; i++) {
+		struct tegra_vpr_chunk *chunk = &vpr->chunks[i];
+
+		if (!chunk->active)
+			break;
+
+		if (chunk->start < start)
+			start = chunk->start;
+
+		if (chunk->limit > limit)
+			limit = chunk->limit;
+	}
+
+	if (limit > start) {
+		*size = limit - start;
+		*base = start;
+	} else {
+		*base = *size = 0;
+	}
+
+	return 0;
+}
+
+static int tegra_vpr_resize(struct tegra_vpr *vpr)
+{
+	struct tegra_vpr_device *node;
+	phys_addr_t base, size;
+	int err;
+
+	err = tegra_vpr_get_extents(vpr, &base, &size);
+	if (err < 0) {
+		pr_err("%s(): failed to get VPR extents: %d\n", __func__, err);
+		return err;
+	}
+
+	if (vpr->use_freezer) {
+		err = freeze_processes();
+		if (err < 0) {
+			pr_err("%s(): failed to freeze processes: %d\n",
+			       __func__, err);
+			return err;
+		}
+	}
+
+	list_for_each_entry(node, &vpr->devices, node) {
+		err = pm_generic_freeze(node->dev);
+		if (err < 0) {
+			pr_err("failed to runtime suspend %s\n",
+			       dev_name(node->dev));
+			continue;
+		}
+	}
+
+	trace_tegra_vpr_set(base, size);
+
+	err = tegra_vpr_set(base, size);
+	if (err < 0) {
+		pr_err("failed to secure VPR: %d\n", err);
+		return err;
+	}
+
+	list_for_each_entry(node, &vpr->devices, node) {
+		err = pm_generic_thaw(node->dev);
+		if (err < 0) {
+			pr_err("failed to runtime resume %s\n",
+			       dev_name(node->dev));
+			continue;
+		}
+	}
+
+	if (vpr->use_freezer)
+		thaw_processes();
+
+	return 0;
+}
+
+static int tegra_vpr_protect_pages(pte_t *ptep, unsigned long addr,
+				   void *unused)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
+	pte = set_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
+
+	__set_pte(ptep, pte);
+
+	return 0;
+}
+
+static int tegra_vpr_unprotect_pages(pte_t *ptep, unsigned long addr,
+				     void *unused)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	pte = clear_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
+	pte = set_pte_bit(pte, __pgprot(PROT_NORMAL));
+
+	__set_pte(ptep, pte);
+
+	return 0;
+}
+
+static int tegra_vpr_chunk_init(struct tegra_vpr *vpr,
+				struct tegra_vpr_chunk *chunk,
+				phys_addr_t start, size_t size,
+				unsigned int order, const char *name)
+{
+	INIT_LIST_HEAD(&chunk->buffers);
+	chunk->start = start;
+	chunk->limit = start + size;
+	chunk->size = size;
+	chunk->vpr = vpr;
+
+	chunk->cma = cma_create(start, size, order, name);
+	if (IS_ERR(chunk->cma))
+		return PTR_ERR(chunk->cma);
+
+	chunk->num_pages = size >> PAGE_SHIFT;
+
+	chunk->bitmap = bitmap_zalloc(chunk->num_pages, GFP_KERNEL);
+	if (!chunk->bitmap) {
+		cma_free(chunk->cma);
+		return -ENOMEM;
+	}
+
+	/* CMA area is not reserved yet */
+	chunk->start_page = NULL;
+	chunk->virt = 0;
+
+	return 0;
+}
+
+static void tegra_vpr_chunk_free(struct tegra_vpr_chunk *chunk)
+{
+	kfree(chunk->bitmap);
+	cma_free(chunk->cma);
+}
+
+static inline bool tegra_vpr_chunk_is_last(const struct tegra_vpr_chunk *chunk)
+{
+	phys_addr_t limit = chunk->vpr->base + chunk->vpr->size;
+
+	return chunk->limit == limit;
+}
+
+static inline bool tegra_vpr_chunk_is_leaf(const struct tegra_vpr_chunk *chunk)
+{
+	const struct tegra_vpr_chunk *next = chunk + 1;
+
+	if (tegra_vpr_chunk_is_last(chunk))
+		return true;
+
+	return !next->active;
+}
+
+static int tegra_vpr_chunk_activate(struct tegra_vpr_chunk *chunk)
+{
+	unsigned long align = get_order(chunk->vpr->align);
+	int err;
+
+	if (chunk->active)
+		return 0;
+
+	trace_tegra_vpr_chunk_activate(chunk->start, chunk->limit);
+
+	chunk->start_page = cma_alloc(chunk->cma, chunk->num_pages, align,
+				      false);
+	if (!chunk->start_page) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	chunk->virt = (unsigned long)page_to_virt(chunk->start_page);
+
+	apply_to_existing_page_range(&init_mm, chunk->virt, chunk->size,
+				     tegra_vpr_protect_pages, NULL);
+	flush_tlb_kernel_range(chunk->virt, chunk->virt + chunk->size);
+
+	chunk->active = true;
+
+	err = tegra_vpr_resize(chunk->vpr);
+	if (err < 0)
+		goto unprotect;
+
+	bitmap_zero(chunk->bitmap, chunk->num_pages);
+
+	return 0;
+
+unprotect:
+	chunk->active = false;
+	apply_to_existing_page_range(&init_mm, chunk->virt, chunk->size,
+				     tegra_vpr_unprotect_pages, NULL);
+	flush_tlb_kernel_range(chunk->virt, chunk->virt + chunk->size);
+free:
+	cma_release(chunk->cma, chunk->start_page, chunk->num_pages);
+	chunk->start_page = NULL;
+	chunk->virt = 0;
+	return err;
+}
+
+static int tegra_vpr_chunk_deactivate(struct tegra_vpr_chunk *chunk)
+{
+	int err;
+
+	if (!chunk->active || !tegra_vpr_chunk_is_leaf(chunk))
+		return 0;
+
+	/* do not deactivate if there are buffers left in this chunk */
+	if (WARN_ON(!list_empty(&chunk->buffers)))
+		return 0;
+
+	trace_tegra_vpr_chunk_deactivate(chunk->start, chunk->limit);
+
+	chunk->active = false;
+
+	err = tegra_vpr_resize(chunk->vpr);
+	if (err < 0) {
+		chunk->active = true;
+		return err;
+	}
+
+	apply_to_existing_page_range(&init_mm, chunk->virt, chunk->size,
+				     tegra_vpr_unprotect_pages, NULL);
+	flush_tlb_kernel_range(chunk->virt, chunk->virt + chunk->size);
+
+	cma_release(chunk->cma, chunk->start_page, chunk->num_pages);
+	chunk->start_page = NULL;
+	chunk->virt = 0;
+
+	return 0;
+}
+
+static struct tegra_vpr_buffer *
+tegra_vpr_chunk_allocate(struct tegra_vpr_chunk *chunk, size_t size)
+{
+	unsigned int order = get_order(size);
+	struct tegra_vpr_buffer *buffer;
+	int pageno, err;
+	pgoff_t i;
+
+	err = tegra_vpr_chunk_activate(chunk);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	/*
+	 * "order" defines the alignment and size, so this may result in
+	 * fragmented memory depending on the allocation patterns. However,
+	 * since this is used primarily for video frames, it is expected that
+	 * a number of buffers of the same size will be allocated, so
+	 * fragmentation should be negligible.
+	 */
+	pageno = bitmap_find_free_region(chunk->bitmap, chunk->num_pages,
+					 order);
+	if (pageno < 0)
+		return ERR_PTR(-ENOSPC);
+
+	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
+	if (!buffer) {
+		err = -ENOMEM;
+		goto release;
+	}
+
+	INIT_LIST_HEAD(&buffer->attachments);
+	mutex_init(&buffer->lock);
+	buffer->chunk = chunk;
+	buffer->start = chunk->start + (pageno << PAGE_SHIFT);
+	buffer->limit = buffer->start + size;
+	buffer->size = size;
+	buffer->num_pages = buffer->size >> PAGE_SHIFT;
+	buffer->pageno = pageno;
+	buffer->order = order;
+
+	buffer->virt = (unsigned long)page_to_virt(chunk->start_page + pageno);
+
+	buffer->pages = kmalloc_array(buffer->num_pages,
+				      sizeof(*buffer->pages),
+				      GFP_KERNEL);
+	if (!buffer->pages) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	for (i = 0; i < buffer->num_pages; i++)
+		buffer->pages[i] = &chunk->start_page[pageno + i];
+
+	list_add_tail(&buffer->list, &chunk->buffers);
+
+	return buffer;
+
+free:
+	kfree(buffer);
+release:
+	bitmap_release_region(chunk->bitmap, pageno, order);
+	return ERR_PTR(err);
+}
+
+static void tegra_vpr_chunk_release(struct tegra_vpr_chunk *chunk,
+				    struct tegra_vpr_buffer *buffer)
+{
+	list_del(&buffer->list);
+	kfree(buffer->pages);
+	kfree(buffer);
+
+	bitmap_release_region(chunk->bitmap, buffer->pageno, buffer->order);
+}
+
+static int tegra_vpr_attach(struct dma_buf *buf,
+			    struct dma_buf_attachment *attachment)
+{
+	struct tegra_vpr_buffer *buffer = buf->priv;
+	struct tegra_vpr_attachment *attach;
+	int err;
+
+	attach = kzalloc(sizeof(*attach), GFP_KERNEL);
+	if (!attach)
+		return -ENOMEM;
+
+	err = sg_alloc_table_from_pages(&attach->sgt, buffer->pages,
+					buffer->num_pages, 0, buffer->size,
+					GFP_KERNEL);
+	if (err < 0)
+		goto free;
+
+	attach->dev = attach->dev;
+	INIT_LIST_HEAD(&attach->list);
+	attachment->priv = attach;
+
+	mutex_lock(&buffer->lock);
+	list_add(&attach->list, &buffer->attachments);
+	mutex_unlock(&buffer->lock);
+
+	return 0;
+
+free:
+	kfree(attach);
+	return err;
+}
+
+static void tegra_vpr_detach(struct dma_buf *buf,
+			     struct dma_buf_attachment *attachment)
+{
+	struct tegra_vpr_buffer *buffer = buf->priv;
+	struct tegra_vpr_attachment *attach = attachment->priv;
+
+	mutex_lock(&buffer->lock);
+	list_del(&attach->list);
+	mutex_unlock(&buffer->lock);
+
+	sg_free_table(&attach->sgt);
+	kfree(attach);
+}
+
+static struct sg_table *
+tegra_vpr_map_dma_buf(struct dma_buf_attachment *attachment,
+		      enum dma_data_direction direction)
+{
+	struct tegra_vpr_attachment *attach = attachment->priv;
+	struct sg_table *sgt = &attach->sgt;
+	int err;
+
+	err = dma_map_sgtable(attachment->dev, sgt, direction,
+			      DMA_ATTR_SKIP_CPU_SYNC);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	return sgt;
+}
+
+static void tegra_vpr_unmap_dma_buf(struct dma_buf_attachment *attachment,
+				    struct sg_table *sgt,
+				    enum dma_data_direction direction)
+{
+	dma_unmap_sgtable(attachment->dev, sgt, direction,
+			  DMA_ATTR_SKIP_CPU_SYNC);
+}
+
+static void tegra_vpr_recycle(struct tegra_vpr *vpr)
+{
+	unsigned int i;
+	int err;
+
+	/*
+	 * Walk the list of chunks in reverse order and check if they can be
+	 * deactivated.
+	 */
+	for (i = 0; i < vpr->num_chunks; i++) {
+		unsigned int index = vpr->num_chunks - i - 1;
+		struct tegra_vpr_chunk *chunk = &vpr->chunks[index];
+
+		/*
+		 * Stop at any chunk that has remaining buffers. We cannot
+		 * deactivate any chunks at lower addresses because the
+		 * protected region needs to remain contiguous. Technically we
+		 * could shrink from top and bottom, but for the sake of
+		 * simplicity we'll only shrink from the top for now.
+		 */
+		if (!list_empty(&chunk->buffers))
+			break;
+
+		err = tegra_vpr_chunk_deactivate(chunk);
+		if (err < 0)
+			pr_err("failed to deactivate chunk\n");
+	}
+}
+
+static void tegra_vpr_release(struct dma_buf *buf)
+{
+	struct tegra_vpr_buffer *buffer = buf->priv;
+	struct tegra_vpr_chunk *chunk = buffer->chunk;
+	struct tegra_vpr *vpr = chunk->vpr;
+
+	mutex_lock(&vpr->lock);
+
+	tegra_vpr_chunk_release(chunk, buffer);
+	tegra_vpr_recycle(vpr);
+
+	mutex_unlock(&vpr->lock);
+}
+
+/*
+ * Prohibit userspace mapping because the CPU cannot access this memory
+ * anyway.
+ */
+static int tegra_vpr_begin_cpu_access(struct dma_buf *buf,
+				      enum dma_data_direction direction)
+{
+	return -EPERM;
+}
+
+static int tegra_vpr_end_cpu_access(struct dma_buf *buf,
+				    enum dma_data_direction direction)
+{
+	return -EPERM;
+}
+
+static int tegra_vpr_mmap(struct dma_buf *buf, struct vm_area_struct *vma)
+{
+	return -EPERM;
+}
+
+static const struct dma_buf_ops tegra_vpr_buf_ops = {
+	.attach = tegra_vpr_attach,
+	.detach = tegra_vpr_detach,
+	.map_dma_buf = tegra_vpr_map_dma_buf,
+	.unmap_dma_buf = tegra_vpr_unmap_dma_buf,
+	.release = tegra_vpr_release,
+	.begin_cpu_access = tegra_vpr_begin_cpu_access,
+	.end_cpu_access = tegra_vpr_end_cpu_access,
+	.mmap = tegra_vpr_mmap,
+};
+
+static struct dma_buf *tegra_vpr_allocate(struct dma_heap *heap,
+					  unsigned long len, u32 fd_flags,
+					  u64 heap_flags)
+{
+	struct tegra_vpr *vpr = dma_heap_get_drvdata(heap);
+	DEFINE_DMA_BUF_EXPORT_INFO(export);
+	struct tegra_vpr_buffer *buffer;
+	struct dma_buf *buf;
+	unsigned int i;
+
+	mutex_lock(&vpr->lock);
+
+	for (i = 0; i < vpr->num_chunks; i++) {
+		struct tegra_vpr_chunk *chunk = &vpr->chunks[i];
+		size_t size = ALIGN(len, vpr->align);
+
+		buffer = tegra_vpr_chunk_allocate(chunk, size);
+		if (IS_ERR(buffer)) {
+			/* try the next chunk if the current one is exhausted */
+			if (PTR_ERR(buffer) == -ENOSPC)
+				continue;
+
+			mutex_unlock(&vpr->lock);
+			return ERR_CAST(buffer);
+		}
+
+		/*
+		 * If a valid buffer was allocated, wrap it in a dma_buf and
+		 * return it.
+		 */
+		if (buffer) {
+			export.exp_name = dma_heap_get_name(heap);
+			export.ops = &tegra_vpr_buf_ops;
+			export.size = buffer->size;
+			export.flags = fd_flags;
+			export.priv = buffer;
+
+			buf = dma_buf_export(&export);
+			if (IS_ERR(buf)) {
+				tegra_vpr_chunk_release(chunk, buffer);
+				return ERR_CAST(buf);
+			}
+
+			mutex_unlock(&vpr->lock);
+			return buf;
+		}
+	}
+
+	mutex_unlock(&vpr->lock);
+
+	/*
+	 * If we get here, none of the chunks could allocate a buffer, so
+	 * there's nothing else we can do.
+	 */
+	return ERR_PTR(-ENOMEM);
+}
+
+static int tegra_vpr_debugfs_show(struct seq_file *s, struct dma_heap *heap)
+{
+	struct tegra_vpr *vpr = dma_heap_get_drvdata(heap);
+	phys_addr_t limit = vpr->base + vpr->size;
+	unsigned int i;
+	char buf[16];
+
+	string_get_size(vpr->size, 1, STRING_UNITS_2, buf, sizeof(buf));
+	seq_printf(s, "%pap-%pap (%s)\n", &vpr->base, &limit, buf);
+
+	for (i = 0; i < vpr->num_chunks; i++) {
+		const struct tegra_vpr_chunk *chunk = &vpr->chunks[i];
+		struct tegra_vpr_buffer *buffer;
+
+		string_get_size(chunk->size, 1, STRING_UNITS_2, buf,
+				sizeof(buf));
+		seq_printf(s, "  %pap-%pap (%s)\n", &chunk->start,
+			   &chunk->limit, buf);
+
+		list_for_each_entry(buffer, &chunk->buffers, list) {
+			string_get_size(buffer->size, 1, STRING_UNITS_2, buf,
+					sizeof(buf));
+			seq_printf(s, "    %pap-%pap (%s)\n", &buffer->start,
+				   &buffer->limit, buf);
+		}
+	}
+
+	return 0;
+}
+
+static const struct dma_heap_ops tegra_vpr_heap_ops = {
+	.allocate = tegra_vpr_allocate,
+	.show = tegra_vpr_debugfs_show,
+};
+
+static int __init tegra_vpr_add_heap(struct reserved_mem *rmem,
+				     struct device_node *np)
+{
+	struct dma_heap_export_info info = {};
+	phys_addr_t start, limit;
+	struct dma_heap *heap;
+	struct tegra_vpr *vpr;
+	unsigned int order, i;
+	size_t max_size;
+	int err;
+
+	vpr = kzalloc(sizeof(*vpr), GFP_KERNEL);
+	if (!vpr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&vpr->devices);
+	vpr->use_freezer = true;
+	vpr->dev_node = np;
+	vpr->align = SZ_1M;
+	vpr->base = rmem->base;
+	vpr->size = rmem->size;
+	vpr->num_chunks = 4;
+
+	max_size = PAGE_SIZE << (get_order(vpr->size) - ilog2(vpr->num_chunks));
+	order = get_order(vpr->align);
+
+	vpr->chunks = kcalloc(vpr->num_chunks, sizeof(*vpr->chunks),
+			      GFP_KERNEL);
+	if (!vpr) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	/*
+	 * Allocate CMA areas for VPR. All areas will be roughtly the same
+	 * size, with the last area taking up the rest.
+	 */
+	start = vpr->base;
+	limit = vpr->base + vpr->size;
+
+	pr_debug("VPR: %pap-%pap (%u chunks, %lu MiB)\n", &start, &limit,
+		 vpr->num_chunks, (unsigned long)vpr->size / 1024 / 1024);
+
+	for (i = 0; i < vpr->num_chunks; i++) {
+		size_t size = limit - start;
+		phys_addr_t end;
+
+		size = min_t(size_t, size, max_size);
+		end = start + size - 1;
+
+		err = tegra_vpr_chunk_init(vpr, &vpr->chunks[i], start, size,
+					   order, rmem->name);
+		if (err < 0) {
+			pr_err("failed to create VPR chunk: %d\n", err);
+			goto free;
+		}
+
+		pr_debug("  %2u: %pap-%pap (%lu MiB)\n", i, &start, &end,
+			 size / 1024 / 1024);
+		start += size;
+	}
+
+	info.name = vpr->dev_node->name;
+	info.ops = &tegra_vpr_heap_ops;
+	info.priv = vpr;
+
+	heap = dma_heap_add(&info);
+	if (IS_ERR(heap)) {
+		err = PTR_ERR(heap);
+		goto cma_free;
+	}
+
+	rmem->priv = heap;
+
+	return 0;
+
+cma_free:
+	while (i--)
+		tegra_vpr_chunk_free(&vpr->chunks[i]);
+free:
+	kfree(vpr->chunks);
+	kfree(vpr);
+out:
+	return err;
+}
+
+static int __init tegra_vpr_init(void)
+{
+	const char *compatible = "nvidia,tegra-video-protection-region";
+	struct device_node *parent;
+	struct reserved_mem *rmem;
+	int err;
+
+	parent = of_find_node_by_path("/reserved-memory");
+	if (!parent)
+		return 0;
+
+	for_each_child_of_node_scoped(parent, child) {
+		if (!of_device_is_compatible(child, compatible))
+			continue;
+
+		rmem = of_reserved_mem_lookup(child);
+		if (!rmem)
+			continue;
+
+		err = tegra_vpr_add_heap(rmem, child);
+		if (err < 0)
+			pr_err("failed to add VPR heap for %pOF: %d\n", child,
+			       err);
+
+		/* only a single VPR heap is supported */
+		break;
+	}
+
+	return 0;
+}
+module_init(tegra_vpr_init);
+
+static int tegra_vpr_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	struct dma_heap *heap = rmem->priv;
+	struct tegra_vpr *vpr = dma_heap_get_drvdata(heap);
+	struct tegra_vpr_device *node;
+	int err = 0;
+
+	if (!dev->driver->pm->freeze || !dev->driver->pm->thaw)
+		return -EINVAL;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	INIT_LIST_HEAD(&node->node);
+	node->dev = dev;
+
+	list_add_tail(&node->node, &vpr->devices);
+
+out:
+	return err;
+}
+
+static void tegra_vpr_device_release(struct reserved_mem *rmem,
+				     struct device *dev)
+{
+	struct dma_heap *heap = rmem->priv;
+	struct tegra_vpr *vpr = dma_heap_get_drvdata(heap);
+	struct tegra_vpr_device *node, *tmp;
+
+	list_for_each_entry_safe(node, tmp, &vpr->devices, node) {
+		if (node->dev == dev) {
+			list_del(&node->node);
+			kfree(node);
+		}
+	}
+}
+
+static const struct reserved_mem_ops tegra_vpr_ops = {
+	.device_init = tegra_vpr_device_init,
+	.device_release = tegra_vpr_device_release,
+};
+
+static int tegra_vpr_rmem_init(struct reserved_mem *rmem)
+{
+	rmem->ops = &tegra_vpr_ops;
+
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(tegra_vpr, "nvidia,tegra-video-protection-region",
+		       tegra_vpr_rmem_init);
+
+MODULE_DESCRIPTION("NVIDIA Tegra Video-Protection-Region DMA-BUF heap driver");
+MODULE_LICENSE("GPL");
diff --git a/include/trace/events/tegra_vpr.h b/include/trace/events/tegra_vpr.h
new file mode 100644
index 000000000000..f8ceb17679fe
--- /dev/null
+++ b/include/trace/events/tegra_vpr.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if !defined(_TRACE_TEGRA_VPR_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TEGRA_VPR_H
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM tegra_vpr
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(tegra_vpr_chunk_activate,
+	TP_PROTO(phys_addr_t start, phys_addr_t limit),
+	TP_ARGS(start, limit),
+	TP_STRUCT__entry(
+		__field(phys_addr_t, start)
+		__field(phys_addr_t, limit)
+	),
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->limit = limit;
+	),
+	TP_printk("%pap-%pap", &__entry->start,
+		  &__entry->limit)
+);
+
+TRACE_EVENT(tegra_vpr_chunk_deactivate,
+	TP_PROTO(phys_addr_t start, phys_addr_t limit),
+	TP_ARGS(start, limit),
+	TP_STRUCT__entry(
+		__field(phys_addr_t, start)
+		__field(phys_addr_t, limit)
+	),
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->limit = limit;
+	),
+	TP_printk("%pap-%pap", &__entry->start,
+		  &__entry->limit)
+);
+
+TRACE_EVENT(tegra_vpr_set,
+	TP_PROTO(phys_addr_t base, phys_addr_t size),
+	TP_ARGS(base, size),
+	TP_STRUCT__entry(
+		__field(phys_addr_t, start)
+		__field(phys_addr_t, limit)
+	),
+	TP_fast_assign(
+		__entry->start = base;
+		__entry->limit = base + size;
+	),
+	TP_printk("%pap-%pap", &__entry->start, &__entry->limit)
+);
+
+#endif /* _TRACE_TEGRA_VPR_H */
+
+#include <trace/define_trace.h>
-- 
2.50.0


