Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00152D0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F686B0092; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6706B009E; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4826B0092; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6F66B0092
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A4DA889BC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:37 +0000 (UTC)
X-FDA: 84149740794.17.6007774
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86FCCC000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UcThxnb6;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoq1KHM//ceWZHYzHvP2GAeyKGu/ekSRGep2L5s8MQE=;
	b=Zp55ZN0SDUm+fGSZsMjjDhcVef1kmOSDiZGb9dJNIiGe1aRoXhRTW+ujwmXlNsuG5aGbWo
	Jctua/TSmhYmLDfqeTVO7tiThH8mdCVWLnURX7k83MWy5GDnppXt7DUUPAtKh6JzpPuY/5
	Fe3VMinyuKrrx5sBqpbhFOy1kr5aThI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089975; a=rsa-sha256;
	cv=none;
	b=d0LTa7TPdkpt6FaYZ6wilW7cEORGoM2dXL2UKyIrswTH6XUc6shqByLN89uOUl7AJXKl9i
	KBQC0XdSeJTd3EiQ7gmYeRede0IMhLqj8qBfuqL3pah0O0s2FLR6+lUeU2pyNZ2oPdgOtu
	ZH6cu3ZRHktt5wIyaNS9b9d6jdqhHKE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UcThxnb6;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7895017c722so54442037b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089974; x=1764694774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hoq1KHM//ceWZHYzHvP2GAeyKGu/ekSRGep2L5s8MQE=;
        b=UcThxnb6EwDcELvwCoE3B+YDXdK+e+AcH4ZJHpSYfCnJa79KRISnwlCvYiSRDxuyMZ
         Ks0PWYmca5z+OsZ5fwrK0gVQaVi0knqA/WDap37BPgmD3UFCDui/LEgBOiDq/i/5aSyS
         4Sgq/IFds2zOscfYr2Yx0TteZSgtObcX/ZMH+8/oWJWElUiyBQ6IFq0V7w2ZsmqNuu1D
         2Py3ju/FaD3Kxv+DUouQTunMGnUqkXvyg3G6+JESHdCuwDXsnGYk010HJMz57NRoOBte
         czsoCrrvOnzwdxY5/vcQ+7xFOUMbJpptDF+nT7Ltfc23W2DPHVeKz5sRSV51NwJvJp7r
         pvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089974; x=1764694774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hoq1KHM//ceWZHYzHvP2GAeyKGu/ekSRGep2L5s8MQE=;
        b=T7Yk6Rx1TFGPbC50FJpLzdtxo2CNd/x9Bv1nNZ7e7WjtNyhIN7vshOJIpFLey0Xsf3
         YbvqEjkqL9ifZ+KdovKcB6/6c/A8QbeNCGxNOS3Sy+XmP4/rP7PJvH4XlIcWPqicjFj/
         Zq5gBKAqmH37e2L8Y3Qz6QLvb/JpZggBccvHJY/5vwEFiwQga71G9CD48jU6GIYfmbmU
         XCR1uKxDL34OCPHbrpU9c0mjmcZd+rNpIdTdwD+pxoxij3guAHww1vRAIK6nH641tNYK
         J3QLWhlvvA1k5mOxwDQioDmA6us/LItDBSahA22aSfeFbNyd51Esx2WEs8+ZF7fqlPnW
         Oqbw==
X-Forwarded-Encrypted: i=1; AJvYcCVSR0kuldHOVOevfqcxGqMPJk3jcmg5wMkKeITmBbsYRYpe7or2ZrhL+aGOTxGXJVWaCL5cTKj1xg==@kvack.org
X-Gm-Message-State: AOJu0Yy+PUoK1kO92PZA1r2dbl6Td7jSVAF51yB6no8Zrwt/xEPvLKA0
	hAkHqEG4UBGR7n9L2ynwIb5Rg77P3834T424hMuDJnsdL8xBdrCxX2vmwnbJPbAHkVY=
X-Gm-Gg: ASbGncsIlmVkuPgbNQzZuRQuXHwEPoaHILrmNcW23oG25HschfDIqKWSJM08tYDL0p9
	MIJcHgH0rQUqdUx2OKZ3Utenv0ViVpFcKeDmggrYSEM2QHzlsN9WmdcbrRCiejslGwymhXz86cU
	sqRW1H/jbY3vZqQf6w5afu6PMEhV7WxOSZwI37DdC1bh3qYG/Wwyhww6LB0Rp3t9kuvO1dfTQGA
	Im+9VUPgEjSjG9ohNOXc0h71MEDT2gi2/AWWgicG94M+IX/heuvGjzKf4VjFS/x9jZVLnBOBGSW
	5pPB38FhsaHwQeQUR7lJlbmHwpe2sondHCkydyfmHnPsKC6a3bMccE1ThhqF67e1PqT5H1+F9mb
	dsTyXqoMJKam23fC3gi2lCYrbRAVslXMdKwv11f4ARQhjJ+u119+jC4R6jus14hcV0hNCeZpwWO
	nvCn6KGgnCGN6p71JdXS5pfrM2Oy3T6hY8I1C1E40QMUv9fp9i3jdJw89KZ1JIUydVgiqnR1nPw
	M3luh8=
X-Google-Smtp-Source: AGHT+IGhyqko2XNGAQ+MbliOV7Q7lZRrugm5nEIedcDe3Hixtd5DaNp0Tw4exj+v0JxhFqTVbLupfA==
X-Received: by 2002:a05:690c:45c5:b0:786:45ce:9bd3 with SMTP id 00721157ae682-78ab6f345bamr29492047b3.34.1764089974430;
        Tue, 25 Nov 2025 08:59:34 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:33 -0800 (PST)
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
Subject: [PATCH v8 14/18] mm: memfd_luo: allow preserving memfd
Date: Tue, 25 Nov 2025 11:58:44 -0500
Message-ID: <20251125165850.3389713-15-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4ztqoxtg3uenogqsgzxpkd5o45e9ezf1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86FCCC000F
X-HE-Tag: 1764089975-883205
X-HE-Meta: U2FsdGVkX19ziHZ6U4UCINvuPKqkLwZHGQGvZrgl1Abf5I53AQk0vybF0M5xfZ1jx2wHtEbN5sPG8IU+eSOmjW3jG+DW69Ydt2BTDcN8oxuK2hXyZsEg/S27bKKPedenAjrurBsez5VBQc8q6A2jWeGKSm4sgtAM+HfNonQUSSKgVUpBXZlLJ6vldnAj1Ksd9cSO0GtWi+xUdTAfAsNB90+zhnLnHTsrvJ03+qm/8sl02JcIhT+1NNaAmtX9ZSWbxNfYYHYMMEscjln8avn8o4GBTAi7mmRTWBaOM4Np4490jfsDx0HDt68wNlTrQqjrGbqsXPudSmD8xaln5ej1ss/5d+UvOzGTHdl2q6J5uYGPzXuXWMdSlyqWqIIbkML3cUE77yinm0ja7PQkg6Qyz0QzWBh8gD2qyqWpiDiyQOVOHpDcN+ZgC2Z3QzFMCFf/REIhpkse++SpWmOowEIu/yrc7vkckNQXlEGNujJ0Jg0s8nYE/QXl8j0Clt+3rSzCrgXB/CG4u4MNCgov/366ah7uLkpajp48JNjshzOUGy9pMv9VyGiFjucDsMeAe2qo9aD1V6exJSJXOKZOsmUN41fQcmEoINqPrrzelLcHifPZHa1xt8XmHWO4jDRyuONCMlweQORM8suaV839NwWSuCp36rNiRbm/Ovjw+CLaD9yfQ877DnjcezfeOzHVUFkWiRjTFZVtWRaDPn2nwJ+tT0HO4YZRYvvEvGBkyn294gmVlC+df9Wwu7Pn4VCOYCreApOt+uyfFfp0OXp6lamODAiU4ETpKHBAgaz08S4kuADgseLlrwdGNWGN46t5AbS55HXqOExFlGklVIRG8y4cy/KQy1NYDmHUIagq408btL/HVYDF7EisJqoG2pFguAcQhxlJyGZ+CCPVM4lcGS7acAPSfVG6OpqLzgMiCe2FqX2CDXHZZge0Hsps/YgVgm/gJkTp8gaDu3yDRerV+kP
 +RwXix8j
 9OiE+a6JKSpgn9VoYLuMMSe3XlHeaxBkUhndkiWq366TrY4J58uSta7arD6+4YprXTm2w3dTde3/yw1PeSiM1vMyaeVQl0ytApYMxS25ODkXVYNSVQl8QeZo9vT/3drXeWlpqu7Qf3lGmbDrqMwO5pcRWBh20FyL9cWkoR3NWgJsFV0xoWLlj9EV+I2WEecYX41DvK1pUA1Q+mGLag/ZAl+FWkDkzhnoZvy0fb81FfRX5i/7EmeeOUc2dmvKf60Rjm6nEY+N01mmZv89rNucjHnGsTbjWIFTqWoprBLEtwu9Tya3fK+Qf8npcrvn5kV0Q/f2Ml+Sxk1KHbDpKRJtI1JaWgIJW6OPF8225ZMAF7MDuTCqlPzF3rkfSbvHX96tOjiootTVEdTJId2j3yNihUZL94moFUc8abb/qvOqeyUjYXBLo3LY0Ccy2uIs3T2FWG42y4pm9A7z/96kdmg4CPg6YrZaf4gIcvUkD3cUhkDongZI=
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

Once preserved, the file cannot grow or shrink, and all its pages are
pinned to avoid migrations and swapping. The file can still be read from
or written to.

Use vmalloc to get the buffer to hold the folios, and preserve
it using kho_preserve_vmalloc(). This doesn't have the size limit.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS                   |   2 +
 include/linux/kho/abi/memfd.h |  77 +++++
 mm/Makefile                   |   1 +
 mm/memfd_luo.c                | 516 ++++++++++++++++++++++++++++++++++
 4 files changed, 596 insertions(+)
 create mode 100644 include/linux/kho/abi/memfd.h
 create mode 100644 mm/memfd_luo.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 868d3d23fdea..425c46bba764 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14469,6 +14469,7 @@ F:	tools/testing/selftests/livepatch/
 LIVE UPDATE
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Mike Rapoport <rppt@kernel.org>
+R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
@@ -14477,6 +14478,7 @@ F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
+F:	mm/memfd_luo.c
 
 LLC (802.2)
 L:	netdev@vger.kernel.org
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
new file mode 100644
index 000000000000..da7d063474a1
--- /dev/null
+++ b/include/linux/kho/abi/memfd.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+#ifndef _LINUX_KHO_ABI_MEMFD_H
+#define _LINUX_KHO_ABI_MEMFD_H
+
+#include <linux/types.h>
+#include <linux/kexec_handover.h>
+
+/**
+ * DOC: memfd Live Update ABI
+ *
+ * This header defines the ABI for preserving the state of a memfd across a
+ * kexec reboot using the LUO.
+ *
+ * The state is serialized into a packed structure `struct memfd_luo_ser`
+ * which is handed over to the next kernel via the KHO mechanism.
+ *
+ * This interface is a contract. Any modification to the structure layout
+ * constitutes a breaking change. Such changes require incrementing the
+ * version number in the MEMFD_LUO_FH_COMPATIBLE string.
+ */
+
+/**
+ * MEMFD_LUO_FOLIO_DIRTY - The folio is dirty.
+ *
+ * This flag indicates the folio contains data from user. A non-dirty folio is
+ * one that was allocated (say using fallocate(2)) but not written to.
+ */
+#define MEMFD_LUO_FOLIO_DIRTY		BIT(0)
+
+/**
+ * MEMFD_LUO_FOLIO_UPTODATE - The folio is up-to-date.
+ *
+ * An up-to-date folio has been zeroed out. shmem zeroes out folios on first
+ * use. This flag tracks which folios need zeroing.
+ */
+#define MEMFD_LUO_FOLIO_UPTODATE	BIT(1)
+
+/**
+ * struct memfd_luo_folio_ser - Serialized state of a single folio.
+ * @pfn:       The page frame number of the folio.
+ * @flags:     Flags to describe the state of the folio.
+ * @index:     The page offset (pgoff_t) of the folio within the original file.
+ */
+struct memfd_luo_folio_ser {
+	u64 pfn:52;
+	u64 flags:12;
+	u64 index;
+} __packed;
+
+/**
+ * struct memfd_luo_ser - Main serialization structure for a memfd.
+ * @pos:       The file's current position (f_pos).
+ * @size:      The total size of the file in bytes (i_size).
+ * @nr_folios: Number of folios in the folios array.
+ * @folios:    KHO vmalloc descriptor pointing to the array of
+ *             struct memfd_luo_folio_ser.
+ */
+struct memfd_luo_ser {
+	u64 pos;
+	u64 size;
+	u64 nr_folios;
+	struct kho_vmalloc folios;
+} __packed;
+
+/* The compatibility string for memfd file handler */
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
+
+#endif /* _LINUX_KHO_ABI_MEMFD_H */
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
index 000000000000..4f6ba63b4310
--- /dev/null
+++ b/mm/memfd_luo.c
@@ -0,0 +1,516 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+/**
+ * DOC: Memfd Preservation via LUO
+ *
+ * Overview
+ * ========
+ *
+ * Memory file descriptors (memfd) can be preserved over a kexec using the Live
+ * Update Orchestrator (LUO) file preservation. This allows userspace to
+ * transfer its memory contents to the next kernel after a kexec.
+ *
+ * The preservation is not intended to be transparent. Only select properties of
+ * the file are preserved. All others are reset to default. The preserved
+ * properties are described below.
+ *
+ * .. note::
+ *    The LUO API is not stabilized yet, so the preserved properties of a memfd
+ *    are also not stable and are subject to backwards incompatible changes.
+ *
+ * .. note::
+ *    Currently a memfd backed by Hugetlb is not supported. Memfds created
+ *    with ``MFD_HUGETLB`` will be rejected.
+ *
+ * Preserved Properties
+ * ====================
+ *
+ * The following properties of the memfd are preserved across kexec:
+ *
+ * File Contents
+ *   All data stored in the file is preserved.
+ *
+ * File Size
+ *   The size of the file is preserved. Holes in the file are filled by
+ *   allocating pages for them during preservation.
+ *
+ * File Position
+ *   The current file position is preserved, allowing applications to continue
+ *   reading/writing from their last position.
+ *
+ * File Status Flags
+ *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
+ *   is maintained.
+ *
+ * Non-Preserved Properties
+ * ========================
+ *
+ * All properties which are not preserved must be assumed to be reset to
+ * default. This section describes some of those properties which may be more of
+ * note.
+ *
+ * ``FD_CLOEXEC`` flag
+ *   A memfd can be created with the ``MFD_CLOEXEC`` flag that sets the
+ *   ``FD_CLOEXEC`` on the file. This flag is not preserved and must be set
+ *   again after restore via ``fcntl()``.
+ *
+ * Seals
+ *   File seals are not preserved. The file is unsealed on restore and if
+ *   needed, must be sealed again via ``fcntl()``.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/file.h>
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/memfd.h>
+#include <linux/liveupdate.h>
+#include <linux/shmem_fs.h>
+#include <linux/vmalloc.h>
+#include "internal.h"
+
+static int memfd_luo_preserve_folios(struct file *file,
+				     struct kho_vmalloc *kho_vmalloc,
+				     struct memfd_luo_folio_ser **out_folios_ser,
+				     u64 *nr_foliosp)
+{
+	struct inode *inode = file_inode(file);
+	struct memfd_luo_folio_ser *folios_ser;
+	unsigned int max_folios;
+	long i, size, nr_pinned;
+	struct folio **folios;
+	int err = -EINVAL;
+	pgoff_t offset;
+	u64 nr_folios;
+
+	size = i_size_read(inode);
+	/*
+	 * If the file has zero size, then the folios and nr_folios properties
+	 * are not set.
+	 */
+	if (!size) {
+		*nr_foliosp = 0;
+		*out_folios_ser = NULL;
+		memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
+		return 0;
+	}
+
+	/*
+	 * Guess the number of folios based on inode size. Real number might end
+	 * up being smaller if there are higher order folios.
+	 */
+	max_folios = PAGE_ALIGN(size) / PAGE_SIZE;
+	folios = kvmalloc_array(max_folios, sizeof(*folios), GFP_KERNEL);
+	if (!folios)
+		return -ENOMEM;
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
+	nr_folios = nr_pinned;
+
+	folios_ser = vcalloc(nr_folios, sizeof(*folios_ser));
+	if (!folios_ser) {
+		err = -ENOMEM;
+		goto err_unpin;
+	}
+
+	for (i = 0; i < nr_folios; i++) {
+		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		struct folio *folio = folios[i];
+		unsigned int flags = 0;
+
+		err = kho_preserve_folio(folio);
+		if (err)
+			goto err_unpreserve;
+
+		if (folio_test_dirty(folio))
+			flags |= MEMFD_LUO_FOLIO_DIRTY;
+		if (folio_test_uptodate(folio))
+			flags |= MEMFD_LUO_FOLIO_UPTODATE;
+
+		pfolio->pfn = folio_pfn(folio);
+		pfolio->flags = flags;
+		pfolio->index = folio->index;
+	}
+
+	err = kho_preserve_vmalloc(folios_ser, kho_vmalloc);
+	if (err)
+		goto err_unpreserve;
+
+	kvfree(folios);
+	*nr_foliosp = nr_folios;
+	*out_folios_ser = folios_ser;
+
+	/*
+	 * Note: folios_ser is purposely not freed here. It is preserved
+	 * memory (via KHO). In the 'unpreserve' path, we use the vmap pointer
+	 * that is passed via private_data.
+	 */
+	return 0;
+
+err_unpreserve:
+	for (i = i - 1; i >= 0; i--)
+		kho_unpreserve_folio(folios[i]);
+	vfree(folios_ser);
+err_unpin:
+	unpin_folios(folios, nr_folios);
+err_free_folios:
+	kvfree(folios);
+
+	return err;
+}
+
+static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
+					struct memfd_luo_folio_ser *folios_ser,
+					u64 nr_folios)
+{
+	long i;
+
+	if (!nr_folios)
+		return;
+
+	kho_unpreserve_vmalloc(kho_vmalloc);
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		struct folio *folio;
+
+		if (!pfolio->pfn)
+			continue;
+
+		folio = pfn_folio(pfolio->pfn);
+
+		kho_unpreserve_folio(folio);
+		unpin_folio(folio);
+	}
+
+	vfree(folios_ser);
+}
+
+static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
+{
+	struct inode *inode = file_inode(args->file);
+	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_ser *ser;
+	u64 nr_folios;
+	int err = 0;
+
+	inode_lock(inode);
+	shmem_freeze(inode, true);
+
+	/* Allocate the main serialization structure in preserved memory */
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser)) {
+		err = PTR_ERR(ser);
+		goto err_unlock;
+	}
+
+	ser->pos = args->file->f_pos;
+	ser->size = i_size_read(inode);
+
+	err = memfd_luo_preserve_folios(args->file, &ser->folios,
+					&folios_ser, &nr_folios);
+	if (err)
+		goto err_free_ser;
+
+	ser->nr_folios = nr_folios;
+	inode_unlock(inode);
+
+	args->private_data = folios_ser;
+	args->serialized_data = virt_to_phys(ser);
+
+	return 0;
+
+err_free_ser:
+	kho_unpreserve_free(ser);
+err_unlock:
+	shmem_freeze(inode, false);
+	inode_unlock(inode);
+	return err;
+}
+
+static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
+{
+	struct memfd_luo_ser *ser;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	/*
+	 * The pos might have changed since prepare. Everything else stays the
+	 * same.
+	 */
+	ser->pos = args->file->f_pos;
+
+	return 0;
+}
+
+static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct inode *inode = file_inode(args->file);
+	struct memfd_luo_ser *ser;
+
+	if (WARN_ON_ONCE(!args->serialized_data))
+		return;
+
+	inode_lock(inode);
+	shmem_freeze(inode, false);
+
+	ser = phys_to_virt(args->serialized_data);
+
+	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
+				    ser->nr_folios);
+
+	kho_unpreserve_free(ser);
+	inode_unlock(inode);
+}
+
+static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_ser,
+				     u64 nr_folios)
+{
+	u64 i;
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		struct folio *folio;
+		phys_addr_t phys;
+
+		if (!pfolio->pfn)
+			continue;
+
+		phys = PFN_PHYS(pfolio->pfn);
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
+static void memfd_luo_finish(struct liveupdate_file_op_args *args)
+{
+	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_ser *ser;
+
+	if (args->retrieved)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser)
+		return;
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser)
+			goto out;
+
+		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
+		vfree(folios_ser);
+	}
+
+out:
+	kho_restore_free(ser);
+}
+
+static int memfd_luo_retrieve_folios(struct file *file,
+				     struct memfd_luo_folio_ser *folios_ser,
+				     u64 nr_folios)
+{
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = inode->i_mapping;
+	struct folio *folio;
+	int err = -EIO;
+	long i;
+
+	for (i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		phys_addr_t phys;
+		u64 index;
+		int flags;
+
+		if (!pfolio->pfn)
+			continue;
+
+		phys = PFN_PHYS(pfolio->pfn);
+		folio = kho_restore_folio(phys);
+		if (!folio) {
+			pr_err("Unable to restore folio at physical address: %llx\n",
+			       phys);
+			goto put_folios;
+		}
+		index = pfolio->index;
+		flags = pfolio->flags;
+
+		/* Set up the folio for insertion. */
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+
+		err = mem_cgroup_charge(folio, NULL, mapping_gfp_mask(mapping));
+		if (err) {
+			pr_err("shmem: failed to charge folio index %ld: %d\n",
+			       i, err);
+			goto unlock_folio;
+		}
+
+		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
+					      mapping_gfp_mask(mapping));
+		if (err) {
+			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
+			       i, err);
+			goto unlock_folio;
+		}
+
+		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
+			folio_mark_uptodate(folio);
+		if (flags & MEMFD_LUO_FOLIO_DIRTY)
+			folio_mark_dirty(folio);
+
+		err = shmem_inode_acct_blocks(inode, 1);
+		if (err) {
+			pr_err("shmem: failed to account folio index %ld: %d\n",
+			       i, err);
+			goto unlock_folio;
+		}
+
+		shmem_recalc_inode(inode, 1, 0);
+		folio_add_lru(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+
+unlock_folio:
+	folio_unlock(folio);
+	folio_put(folio);
+put_folios:
+	/*
+	 * Note: don't free the folios already added to the file. They will be
+	 * freed when the file is freed. Free the ones not added yet here.
+	 */
+	for (long j = i + 1; j < nr_folios; j++) {
+		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+
+		folio = kho_restore_folio(pfolio->pfn);
+		if (folio)
+			folio_put(folio);
+	}
+
+	return err;
+}
+
+static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_ser *ser;
+	struct file *file;
+	int err;
+
+	ser = phys_to_virt(args->serialized_data);
+	if (!ser)
+		return -EINVAL;
+
+	file = shmem_file_setup("", 0, VM_NORESERVE);
+
+	if (IS_ERR(file)) {
+		pr_err("failed to setup file: %pe\n", file);
+		return PTR_ERR(file);
+	}
+
+	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
+	file->f_inode->i_size = ser->size;
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			err = -EINVAL;
+			goto put_file;
+		}
+
+		err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
+		vfree(folios_ser);
+		if (err)
+			goto put_file;
+	}
+
+	args->file = file;
+	kho_restore_free(ser);
+
+	return 0;
+
+put_file:
+	fput(file);
+
+	return err;
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
+	.freeze = memfd_luo_freeze,
+	.finish = memfd_luo_finish,
+	.retrieve = memfd_luo_retrieve,
+	.preserve = memfd_luo_preserve,
+	.unpreserve = memfd_luo_unpreserve,
+	.can_preserve = memfd_luo_can_preserve,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler memfd_luo_handler = {
+	.ops = &memfd_luo_file_ops,
+	.compatible = MEMFD_LUO_FH_COMPATIBLE,
+};
+
+static int __init memfd_luo_init(void)
+{
+	int err = liveupdate_register_file_handler(&memfd_luo_handler);
+
+	if (err && err != -EOPNOTSUPP) {
+		pr_err("Could not register luo filesystem handler: %pe\n",
+		       ERR_PTR(err));
+
+		return err;
+	}
+
+	return 0;
+}
+late_initcall(memfd_luo_init);
-- 
2.52.0.460.gd25c4c69ec-goog


