Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE106CEBF86
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5788E000C; Sat, 15 Nov 2025 18:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3659D8E0007; Sat, 15 Nov 2025 18:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207C28E000C; Sat, 15 Nov 2025 18:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0470E8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE3C91A086A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:22 +0000 (UTC)
X-FDA: 84114447564.03.ACD22B6
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 09433C000D
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Xa/F181N";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249661; a=rsa-sha256;
	cv=none;
	b=g4c/KT16SclAXe877fMFBWwDCoiqvplMqmofNKXA91wfxXkceY2woPS4cg+WvMX9R+K2TH
	3DRmBaaDg/fC7xWVFo4L1TCrOg74pChOj+soEq9+jQHfAag91nba8+hjWYyg4uIKXZ3+j9
	SND779CwqdyqJUx25uxeOewoJ7nA0Zs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Xa/F181N";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23di5vng5g7PzO6qdci6haN5BnqYj05Ou9mnU5YCuOY=;
	b=3ndYuHjRokdUW11opIvu5oDsVQh+mEm3esbwFB3CZQb3kePKiwsRyKeTac99zKlw9W0tHV
	h83HtB7qnp+kRxSBweftcp5R8ZaVHxbJxcwhQ79kxUTKUdNcQAFXLGZKy+e4ZZ8NcFA5ur
	IpoPhDyVY+SVsoLa2nvcDodfCw5lyUo=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-786a85a68c6so31779477b3.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249660; x=1763854460; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=23di5vng5g7PzO6qdci6haN5BnqYj05Ou9mnU5YCuOY=;
        b=Xa/F181NcwF7rftA3hUHupnDYI+gpWLvWqBPmNCQ/fQlxsxyFlQh75ehCBFDDlrD8G
         N1oPN/N7oRaumRZ5tcH74slkCTbnXfSqnY/kZAi4gXZCT6/eAe48p3TDYTntUxs2bs29
         b0KscheDKOiSNFRmKqpmogmzwwgqet5JHYdqMAhWwGEdPg7+0vmKgtSfV2B69B5EhuQT
         H/5A6iQ/QoR/udZ/fuqMzug+b2pYePeTdjNDBN0khQcM7WOGn7Pl6la6XxJKL+CLc2OQ
         0Zi/IOa3X7Xlk1b91hdNDsD5moco9V7Zn3ZxYElM0jHX0Rdw9q3MrVxESRcOmU/vE8CM
         FDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249660; x=1763854460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=23di5vng5g7PzO6qdci6haN5BnqYj05Ou9mnU5YCuOY=;
        b=SPw0NtHgFSpvvH7dfmracnqX22PjUs21TGh18xYNfXCQvNV0jH0u48wplTi8l/apNc
         WUXB+BTW3BnlWkGRZTEERUUeC+FcTcPIlMRvvCY92qfIljNzzNHqvh1IdrJ8CcP88ylp
         7J6+CuFCP6+uKI32uPUyDrsXokmOZOjKgUMaB4biuychJ5/PeNp4w52bQnB8g0s/aKmi
         lqZQfBLb0Og2YmAUUUwitNpn+xYcOk04CvgbA2lODf3jUQtAvWyBqr/vdU3wMk0gsClU
         sYyPrQnxavEg16+x6r9fH4hwB4wxRl0Mzs7AQk7fm58fLw0Ya/IcNnvC9+Ippk9wxjmN
         QZaA==
X-Forwarded-Encrypted: i=1; AJvYcCVUIdrDaS1oPs1QyIEJh8wqzVfa9mVyhbPFJzZwOiU6HFwkg1RlTj8hAfEIE0wO7EyQtyhfBZSsIA==@kvack.org
X-Gm-Message-State: AOJu0YyvhuJKTVIe4kov99Q8V/Qlhc8cOAaeJr9AbGZ3Cq+RHZn1e+90
	aMp88OSImsX4OI0CF/qWNIDjLLJ3+8GQ+6o/HU2wHBZXJNS8I8TsDDtHtrUMolezjCY=
X-Gm-Gg: ASbGncsgUFLeRUe5H9iegeJX8VuZTFnPdy++rT0bWxkgMXppbCHYUy5/9Wn2NekILYM
	+J6BeUigvCGwK5IAL+hcQVGLkOui60UZ7JBKyrniSTsiTR+HTr5zSo1dgvpTRY3JZO8ajCEkYQw
	Ccgf/B+/EFm+URkWAcbxXXtyLi/hEjU6aH+8B+iZHJilBBKGxJVpY8yy6jl8W/HDWSJmop+k/r0
	ZQr7QinSVy4ErxoWKgDNENTwS+B+tqtOQdfezIl0U6LV7qV3SubVz5OG5BQSIzA3GY9aKXkj01a
	IH1Mwg9BwkwCVyspwAEmYjc+A4X9BWer5nHdg9imAHdUHrWPYE5ioiH9MUFSVJtG74G9xHpwVsO
	eYRMPjDM4wPHusInQ0sJ5kTq9VnYwUY8j+NE87LFwClZdXfzGY9R8DjL5RW7y1sWYLMeteYHfHE
	7msgb1Db+II94aTj5ZfyhhrdEM7e2VZNaorm+DW+E/glIocda05JCY+fcLQQQjb8PP2Mt10MvPz
	cevr+M=
X-Google-Smtp-Source: AGHT+IEUj2RUJjPsfBfXOnD3CReia59JiFjPNPh1BEz+Ns8My+i3Um+tr89GzjAojwVUDuStxu7XSg==
X-Received: by 2002:a05:690c:a1cd:b0:784:883c:a88d with SMTP id 00721157ae682-78929f3d937mr47983967b3.52.1763249660013;
        Sat, 15 Nov 2025 15:34:20 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:19 -0800 (PST)
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
Subject: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
Date: Sat, 15 Nov 2025 18:33:48 -0500
Message-ID: <20251115233409.768044-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 09433C000D
X-Stat-Signature: bj871zx68cch34m4epqb413b9eo66goy
X-Rspam-User: 
X-HE-Tag: 1763249660-246110
X-HE-Meta: U2FsdGVkX19/rwM9FKhvPrDqrdsThUoJmaemnrVsXQN5GfBjHcs3sR6+ka5jOwlSaK8CHjhZPKluEOXeQKtR77iDDsSSmn2j70ku8Ea4gyh+gaLdNj6rglirLdKRDi0l3L6n1b9eLasZUgi7KGZJ9UxLcmvLEAmSXiRP4CqA/nqYLvQvuiezQ9qIsyNxpSG/AJJqrxkt66iziKQZcbiwfX3l/7DSY8cI0UaohcWWgvrzpVbxYzlzONU7yTUax+7fKD+qsJ/5XR0TN8f4XRHxb0kKNoFRfdObnAFgFLhEnpSr2MrgTGTRBBxXw9CWor8CasoiApyDIS+mH26AN/V7+AVgXx1rrQmGKHuqH6A76/GgqMI3wQaOw/oj8DXHv9kVL/5F0uR83EScrepyF2/9vmreqQwB7Jn4JilesM7LEj59JHHWp4vpx0gEdSm9gkLhGNczS3I94Aq1nF4GOUkcXcalP8fX+e0CoAGgn7OUxPAIhFa1Px1z7fFjSHKBABqk3+aupn3upWTdoGC0eDd0POuMc0TNA3HeZBuUPbWkQEFFqIRftPx82k7rIaCHEs+Bt3dt4BWE5atKyg2vdPX8+SoTU+tPsvxjcyaLPc/WE0fq1GwiQ6qloPccjXAhUaNrfUiVZko9SWSKVDSnyxe96obGg/JMzlbXH/WjwOE1pfpL0O2NIJGVBs0dFPAm9H85nmK4VONXoOlPn0iVgmjNTUKlIG1u5IXbQVZn8F21bIA8vFuwa1fPn1BJ3d8+62P92+wmFzhF+cjGV/6dysugYDQQRJnredvmtrVpLy6Fu19gIW+J6v4fYqacw3xubuYX35pQxucygYvnynLyI+4A8WDs584oRHoviJsh/Mbqf7ZUDwkJcMRIr4tyjiFwAcCCLdobFrrsyUaBsFtlR+xF90mb8+tuFrzAa+005ah+7/PIG3DyVqQasWOwpw6iVGsNdIJ9yyrH5NhYZ0CQYTn
 ASZdr/r/
 aNZLIPoUQJPEkzfm+qDRpFMiewNdtwhV1hnxyegc2+d3v8cboMweJyWGPWzU9D5j0ZaFvHceoMikakn+uMxXg8E95n4AzH+ae6rLRizye7USXWdtOQc2JR9zR8OVG0WgeXIfSZB8WQ9XUDZRyMJevhPOtbDx1Awl+CgRsANqRbonOzM1WxZ4SA84wiQwyQ6Rf7Ny7t/YJuUWBvdafksbcZ/1NsuvKrmpofQf3RUnoQVslWzJNl6QIqBTcwIuKmjbf88IddLljRcC+MNZnWBkbk2kHu3YZD4GYZsLcOkz1t5Qy3qu3ulAmWkfu6ePZh3ggoTPMO5734d3Tx6h8oSBtYffGKXGsJMyu7B3LxKToERi0HrnBU5KlgTFAQeiqLhGVtKIVS73BgjX4Mtszw77hWHTe8Hz1O4HZKP8t3ZkS0jtmecTVbJugphwk1R00CdAesWchYytB5tZLd0cWdZ3h8yllkhdTIxPlbpSV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate the LUO with the KHO framework to enable passing LUO state
across a kexec reboot.

When LUO is transitioned to a "prepared" state, it tells KHO to
finalize, so all memory segments that were added to KHO preservation
list are getting preserved. After "Prepared" state no new segments
can be preserved. If LUO is canceled, it also tells KHO to cancel the
serialization, and therefore, later LUO can go back into the prepared
state.

This patch introduces the following changes:
- During the KHO finalization phase allocate FDT blob.
- Populate this FDT with a LUO compatibility string ("luo-v1").

LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
logic (`luo_do_*_calls`) remains unimplemented in this patch.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate/abi/luo.h |  54 ++++++++++
 kernel/liveupdate/luo_core.c       | 153 ++++++++++++++++++++++++++++-
 2 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/liveupdate/abi/luo.h

diff --git a/include/linux/liveupdate/abi/luo.h b/include/linux/liveupdate/abi/luo.h
new file mode 100644
index 000000000000..9483a294287f
--- /dev/null
+++ b/include/linux/liveupdate/abi/luo.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/**
+ * DOC: Live Update Orchestrator ABI
+ *
+ * This header defines the stable Application Binary Interface used by the
+ * Live Update Orchestrator to pass state from a pre-update kernel to a
+ * post-update kernel. The ABI is built upon the Kexec HandOver framework
+ * and uses a Flattened Device Tree to describe the preserved data.
+ *
+ * This interface is a contract. Any modification to the FDT structure, node
+ * properties, compatible strings, or the layout of the `__packed` serialization
+ * structures defined here constitutes a breaking change. Such changes require
+ * incrementing the version number in the relevant `_COMPATIBLE` string to
+ * prevent a new kernel from misinterpreting data from an old kernel.
+ *
+ * FDT Structure Overview:
+ *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
+ *   This entry contains an FDT with the following layout:
+ *
+ *   .. code-block:: none
+ *
+ *     / {
+ *         compatible = "luo-v1";
+ *         liveupdate-number = <...>;
+ *     };
+ *
+ * Main LUO Node (/):
+ *
+ *   - compatible: "luo-v1"
+ *     Identifies the overall LUO ABI version.
+ *   - liveupdate-number: u64
+ *     A counter tracking the number of successful live updates performed.
+ */
+
+#ifndef _LINUX_LIVEUPDATE_ABI_LUO_H
+#define _LINUX_LIVEUPDATE_ABI_LUO_H
+
+/*
+ * The LUO FDT hooks all LUO state for sessions, fds, etc.
+ * In the root it allso carries "liveupdate-number" 64-bit property that
+ * corresponds to the number of live-updates performed on this machine.
+ */
+#define LUO_FDT_SIZE		PAGE_SIZE
+#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
+#define LUO_FDT_COMPATIBLE	"luo-v1"
+#define LUO_FDT_LIVEUPDATE_NUM	"liveupdate-number"
+
+#endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 0e1ab19fa1cd..4a213b262b9f 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -42,11 +42,24 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
 #include <linux/kobject.h>
+#include <linux/libfdt.h>
 #include <linux/liveupdate.h>
+#include <linux/liveupdate/abi/luo.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+
+#include "kexec_handover_internal.h"
 
 static struct {
 	bool enabled;
+	void *fdt_out;
+	void *fdt_in;
+	u64 liveupdate_num;
 } luo_global;
 
 static int __init early_liveupdate_param(char *buf)
@@ -55,6 +68,129 @@ static int __init early_liveupdate_param(char *buf)
 }
 early_param("liveupdate", early_liveupdate_param);
 
+static int __init luo_early_startup(void)
+{
+	phys_addr_t fdt_phys;
+	int err, ln_size;
+	const void *ptr;
+
+	if (!kho_is_enabled()) {
+		if (liveupdate_enabled())
+			pr_warn("Disabling liveupdate because KHO is disabled\n");
+		luo_global.enabled = false;
+		return 0;
+	}
+
+	/* Retrieve LUO subtree, and verify its format. */
+	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys);
+	if (err) {
+		if (err != -ENOENT) {
+			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
+			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
+			return err;
+		}
+
+		return 0;
+	}
+
+	luo_global.fdt_in = phys_to_virt(fdt_phys);
+	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
+					LUO_FDT_COMPATIBLE);
+	if (err) {
+		pr_err("FDT '%s' is incompatible with '%s' [%d]\n",
+		       LUO_FDT_KHO_ENTRY_NAME, LUO_FDT_COMPATIBLE, err);
+
+		return -EINVAL;
+	}
+
+	ln_size = 0;
+	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_LIVEUPDATE_NUM,
+			  &ln_size);
+	if (!ptr || ln_size != sizeof(luo_global.liveupdate_num)) {
+		pr_err("Unable to get live update number '%s' [%d]\n",
+		       LUO_FDT_LIVEUPDATE_NUM, ln_size);
+
+		return -EINVAL;
+	}
+
+	luo_global.liveupdate_num = get_unaligned((u64 *)ptr);
+	pr_info("Retrieved live update data, liveupdate number: %lld\n",
+		luo_global.liveupdate_num);
+
+	return 0;
+}
+
+static int __init liveupdate_early_init(void)
+{
+	int err;
+
+	err = luo_early_startup();
+	if (err) {
+		pr_err("The incoming tree failed to initialize properly [%pe], disabling live update\n",
+		       ERR_PTR(err));
+		luo_global.enabled = false;
+	}
+
+	return err;
+}
+early_initcall(liveupdate_early_init);
+
+/* Called during boot to create outgoing LUO fdt tree */
+static int __init luo_fdt_setup(void)
+{
+	const u64 ln = luo_global.liveupdate_num + 1;
+	void *fdt_out;
+	int err;
+
+	fdt_out = kho_alloc_preserve(LUO_FDT_SIZE);
+	if (IS_ERR(fdt_out)) {
+		pr_err("failed to allocate/preserve FDT memory\n");
+		return PTR_ERR(fdt_out);
+	}
+
+	err = fdt_create(fdt_out, LUO_FDT_SIZE);
+	err |= fdt_finish_reservemap(fdt_out);
+	err |= fdt_begin_node(fdt_out, "");
+	err |= fdt_property_string(fdt_out, "compatible", LUO_FDT_COMPATIBLE);
+	err |= fdt_property(fdt_out, LUO_FDT_LIVEUPDATE_NUM, &ln, sizeof(ln));
+	err |= fdt_end_node(fdt_out);
+	err |= fdt_finish(fdt_out);
+	if (err)
+		goto exit_free;
+
+	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out);
+	if (err)
+		goto exit_free;
+	luo_global.fdt_out = fdt_out;
+
+	return 0;
+
+exit_free:
+	kho_unpreserve_free(fdt_out);
+	pr_err("failed to prepare LUO FDT: %d\n", err);
+
+	return err;
+}
+
+/*
+ * late initcall because it initializes the outgoing tree that is needed only
+ * once userspace starts using /dev/liveupdate.
+ */
+static int __init luo_late_startup(void)
+{
+	int err;
+
+	if (!liveupdate_enabled())
+		return 0;
+
+	err = luo_fdt_setup();
+	if (err)
+		luo_global.enabled = false;
+
+	return err;
+}
+late_initcall(luo_late_startup);
+
 /* Public Functions */
 
 /**
@@ -69,7 +205,22 @@ early_param("liveupdate", early_liveupdate_param);
  */
 int liveupdate_reboot(void)
 {
-	return 0;
+	int err;
+
+	if (!liveupdate_enabled())
+		return 0;
+
+	err = kho_finalize();
+	if (err) {
+		pr_err("kho_finalize failed %d\n", err);
+		/*
+		 * kho_finalize() may return libfdt errors, to aboid passing to
+		 * userspace unknown errors, change this to EAGAIN.
+		 */
+		err = -EAGAIN;
+	}
+
+	return err;
 }
 
 /**
-- 
2.52.0.rc1.455.g30608eb744-goog


