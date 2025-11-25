Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A210D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8486B0012; Tue, 25 Nov 2025 11:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FFD6B0022; Tue, 25 Nov 2025 11:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88EA56B0023; Tue, 25 Nov 2025 11:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 774A46B0012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0045D4F021
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:02 +0000 (UTC)
X-FDA: 84149739366.16.98754F6
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32ACAA0007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YODNa4VO;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yriDSUM+ad1aFjpJ92e3as8wKB+tAVJNH4fXWEg+Y9Q=;
	b=ndnJm3oku3DkjLx0whScepOYwFYqqeBqFqywLWJDct53cThOvjAm0eLydUeWyqTM2N11QL
	k+PvPZXTORfHMdxuiXmImSphbNFYRxB05ItEWDZ63NYF4JTdpt+mRpK3ginZkkuiyx9Zbs
	EL/Se1cowMJ84Mwe6nP+BzCD1Kmkjcg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YODNa4VO;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089941; a=rsa-sha256;
	cv=none;
	b=1oMCqb4GNED45DTB5g610eSoBPXhUeJfA50YgzDe+DTR5l8IJFIMbfOjo4JSFyJrnazqPi
	ZPEJUVnsFF+dlqoPibFHb0jMYxEzx/JnBY64g9fhUDCmZkpXsjgU6C0zjgDq7nYQLUWq57
	tL9oE0sROQr9HxUnyxbU8qf52n2R6DU=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-787eb2d8663so327317b3.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089940; x=1764694740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yriDSUM+ad1aFjpJ92e3as8wKB+tAVJNH4fXWEg+Y9Q=;
        b=YODNa4VOoouu4GKRrND0PrHuR931L8EmwkC51/MvR7WPiBog1t9JPfyrrxUTH2tKnO
         0HKgcjmwYvKO7igF1N/jRy6TKZHm8QVYq4ewvWdfO/ryGOVRDpTjj1yiC0iSc09aDR98
         M4ath/PWtTIAVuKIt0M2DdcmLLkVCOqCq3v4fKvcCQ7YdKVRkZv2fJz/6TmVwaXc8yn0
         M3doAe1O16ky+uWlillNUIZc4Vg2h6un1OuhbuQyPgEXoKPtQ+56lVq9kCSIIsJvUuJA
         e3lrU5zYEnERQ0F63pAfut+8UmffpE0N3V5G8FngUSZvL4aDbqxJf/3m1zy679UDFEwS
         5LoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089940; x=1764694740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yriDSUM+ad1aFjpJ92e3as8wKB+tAVJNH4fXWEg+Y9Q=;
        b=KKB1X+On2kwcdGX99u8kjUK/fA3jhQDUqy58m4s6R/CB/jjIlPY5pGgwJUsGzOw3gV
         f8nrF4NG0Hllodon3udYDXUWwEzJolKCcvzryqI6Ursxg4Rnf2NC/daP/wrs8YepUsi0
         NfDL5Ce3mwB+DxXk6JHe6OFPjsKx+giHKR1vihr4SeQ3nUCC3ojiXUNr50zLm/O1HUmJ
         bn7PQYOguqLTJIb+86kXy2UwU9KJyq+BX4XtZQXi5ZY3rv0yT+RbzajsbYOHjokEih3N
         p4Oz3EV7j3aT1vEmQ7Yzas5J91oqxeB9AByNgk7A76kjn9WSqIOD23gOrV1tp7r4ZreX
         P/HA==
X-Forwarded-Encrypted: i=1; AJvYcCV+yT9w8AVU8g++/QsDMbNE19y7mxeCuTmxuaOCSxcLtB09zebmIcQamFl14yExtZsbOQY/WlOltg==@kvack.org
X-Gm-Message-State: AOJu0YxHq0KnWgpuUEc0ofNqv1nqDcGytGjEtwds7rJWl2FMffhNdPFB
	EP0W7r9il5dGLyGJdAzpaiFBj7YqgFahtLjd8ggVgMkkb2AFMFmUcU+K9/hn8X/ZFJw=
X-Gm-Gg: ASbGncvkUeDiWRBAK6Mci2PB09nma92hH2sl5/rOeCAAJfB6l+Vdb3qNyQFvbL9AC3O
	XgvqWdIhVHSB5BEllHfEpfHwiEWtEhHlIVytdHEaA0KIj1It2sFf4+QwFgY5RYrY3LeTcdhtL/t
	PwuvMeEq9KJqsMr3dEzjdSUIk7qkJYYNrEd+BIwPysHPURkeoSWGUdUmuyivL8W63hZUXYOH7Eh
	mUrNR93wu/ap1pJ5NJfCFWE4gimhCKiyRJb50VZR3ZjbHtS5gCCWqgk16AW7QysCZnhxNJGeUVj
	xNtVIdq62CWaqoWjBSMMXLN537uFiTSYdUZKYgGrA3gSTRpUIH9hQ3YWty9x2Ah8qXiEvRYlMIy
	yVqkUP1iytJXCJhBSUihn0JG2W7Zq1efmSMmZ9zJ1upa8qtSgJ2pJMe6dtYCQvbhXxpE49V2beF
	Gm6LjJx8O5DhJMn2r+bS+QoTamSrIlt5gbgNAE/GRh+hmV7dvn1wrf7LhvpQWhRwmSysLeRd8i4
	RE=
X-Google-Smtp-Source: AGHT+IGM7GGVoSfxCAXkl5wg3aMgKhNb9HlP4vsUOFssrEUk0d2XFcXQJwhzNmOgejiMFvAK+iBZcA==
X-Received: by 2002:a05:690c:4c08:b0:731:817b:4d73 with SMTP id 00721157ae682-78a8ab3014dmr159149187b3.14.1764089940135;
        Tue, 25 Nov 2025 08:59:00 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:58:59 -0800 (PST)
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
Subject: [PATCH v8 02/18] liveupdate: luo_core: integrate with KHO
Date: Tue, 25 Nov 2025 11:58:32 -0500
Message-ID: <20251125165850.3389713-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32ACAA0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7b4wsurshfinzwircty3q7kqmh4o6d13
X-HE-Tag: 1764089941-461174
X-HE-Meta: U2FsdGVkX1+ZhDyeMzktaEzwZrXi/iVPJFFuQtEXAL7oeN/SjRZyL4aF6wBXE3i+3W15+VquVwNEH7OkmfHqM6sIzcflJKYet8Qn72IEJHuHkAMgBabocS326dgSs/3/YynZZeo4US2CKfld8En+jTBD/UBEGlmzB3YgImgDBMV8708htTRcGpAdpMM8nXqdEuVzZlHSZKDEo7bD90prfEZ6ShT0UOl0nZU8qKn8tAbXK5W1MCKrefSkPbpek1S2EwdLQ/Vfsyk23QZlh3PoCeb7HewtulVIeJJ02MvycH41s2TIrwK4rAuy80C9BW/NrPRNxchtEiSCkRiXRpaBuuAinJuXAu1RRHRnwzpVSwUHPcINILXr5jnRJbeG2iWAXU9U25oOWMtigTYQ+EqR46XzV0r75y+V1Ctk3JG0y7ZrpEmJ1ESAjZoTmXvUvKndOI2q4GxeH14g5v+ffRT4MtcHJ0AYoPOC267ldoCFfuPGzpBGFUWgvDVs8YQtvZr9dZwfurvSw5pnkaKnSqyXQ9tzw+vIz9HPMU4sMj9mqzoeFVI2ODDGr8WxbnYpUVZprLCOl8ZKGb9PdsRr3dZpFzkhC92S1TOiI+DPOy8tZMn4iN/FhfufeQ6o4HLVReStdK36KdQUdyJu65QX/drX8SxTfR1fkKDe9IxGDQvzWCsjr8Fb5mshUzFkavh16b0J8+Ukj1kEcYRt0W7ZPJZ4nShmq5Qawb6JI5Pz3ZOwrckV7u17tR9CZALcP6TGNQoRRg/ulyFmLWYjYJ4j60RoBnesIcNa5ZfUu1tzOnoAtRCz2KDoE3hv/ak/EVjrshhkZPTVwHIlMH1saz+1uRqEBpqBdxswLSL0yfFssxOrHdqsivEiKHLs14mIlLc/ccgtq0ue7Qfrfk/3JX8ak0pR2RB0ABMcAhf2p3R07GI7HyRhvNNV2s/oayYXTWrFlWnQ7Pvb7SPyfMAjCTKsw3U
 a41O/94+
 7om6U844/FVXMIeSlMX7rUtvGqdgQ/LdrwoDEMuQQ92ACCRmFy2gcXJh+52ZU+ssRvxe1v71L8xdnEyHIR21SHXNANqCjWKybqNRS+bbD0YwuRp6jcfyfRjw3dRmHiVTe7HFBQ88Cz4DlFVGMW+oa92hn08T+iqGdPCTmGYXqHajBSPTfjZmo43KTYPhlTV3OvTol6SFUJZpfFutCXr67b29NDbPP4Y/uxf91D+NfNzEkn/Fgko6wj/Ladv0RcLxkpmzYAvuUpau65F9EjLv+FqaJ3Wy8yLqQh5+vQB2/FQ5FF3/hMghBrN2rRlJsce15nP3eyht1N9pFzTgVJHypgYG4ZdBmrGLorngCwGYuwPOHaCJE9ncwZr6k4/ufUN2Q6ex5VjxgsI3vEFaJho5X2zlLohNLjDjAafOo+IL5XZt4PeUnBXyNxr+3jmmNNgbftCycWZPzdX+S/jNDyd8gfT7nMD4ulrLUHzVncNWQyOc5S8kghEZXjy44o6qr6EHDdyam
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate the LUO with the KHO framework to enable passing LUO state
across a kexec reboot.

This patch implements the lifecycle integration with KHO:

1. Incoming State: During early boot (`early_initcall`), LUO checks if
   KHO is active. If so, it retrieves the "LUO" subtree, verifies the
   "luo-v1" compatibility string, and reads the `liveupdate-number` to
   track the update count.

2. Outgoing State: During late initialization (`late_initcall`), LUO
   allocates a new FDT for the next kernel, populates it with the basic
   header (compatible string and incremented update number), and
   registers it with KHO (`kho_add_subtree`).

3. Finalization: The `liveupdate_reboot()` notifier is updated to invoke
   `kho_finalize()`. This ensures that all memory segments marked for
   preservation are properly serialized before the kexec jump.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/kho/abi/luo.h      |  58 ++++++++++++
 kernel/liveupdate/luo_core.c     | 154 ++++++++++++++++++++++++++++++-
 kernel/liveupdate/luo_internal.h |  22 +++++
 3 files changed, 233 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kho/abi/luo.h
 create mode 100644 kernel/liveupdate/luo_internal.h

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
new file mode 100644
index 000000000000..2099b51929e5
--- /dev/null
+++ b/include/linux/kho/abi/luo.h
@@ -0,0 +1,58 @@
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
+ * Changes are allowed provided the compatibility version is incremented;
+ * however, backward/forward compatibility is only guaranteed for kernels
+ * supporting the same ABI version.
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
+#ifndef _LINUX_KHO_ABI_LUO_H
+#define _LINUX_KHO_ABI_LUO_H
+
+/*
+ * The LUO FDT hooks all LUO state for sessions, fds, etc.
+ * In the root it also carries "liveupdate-number" 64-bit property that
+ * corresponds to the number of live-updates performed on this machine.
+ */
+#define LUO_FDT_SIZE		PAGE_SIZE
+#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
+#define LUO_FDT_COMPATIBLE	"luo-v1"
+#define LUO_FDT_LIVEUPDATE_NUM	"liveupdate-number"
+
+#endif /* _LINUX_KHO_ABI_LUO_H */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 30ad8836360b..9f9fe9a81b29 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -41,12 +41,26 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/io.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/luo.h>
 #include <linux/kobject.h>
+#include <linux/libfdt.h>
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+
+#include "kexec_handover_internal.h"
+#include "luo_internal.h"
 
 static struct {
 	bool enabled;
+	void *fdt_out;
+	void *fdt_in;
+	u64 liveupdate_num;
 } luo_global;
 
 static int __init early_liveupdate_param(char *buf)
@@ -55,6 +69,129 @@ static int __init early_liveupdate_param(char *buf)
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
+		luo_global.enabled = false;
+		luo_restore_fail("The incoming tree failed to initialize properly [%pe], disabling live update\n",
+				 ERR_PTR(err));
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
@@ -69,7 +206,22 @@ early_param("liveupdate", early_liveupdate_param);
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
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
new file mode 100644
index 000000000000..8612687b2000
--- /dev/null
+++ b/kernel/liveupdate/luo_internal.h
@@ -0,0 +1,22 @@
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
+#include <linux/liveupdate.h>
+
+/*
+ * Handles a deserialization failure: devices and memory is in unpredictable
+ * state.
+ *
+ * Continuing the boot process after a failure is dangerous because it could
+ * lead to leaks of private data.
+ */
+#define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
+
+#endif /* _LINUX_LUO_INTERNAL_H */
-- 
2.52.0.460.gd25c4c69ec-goog


