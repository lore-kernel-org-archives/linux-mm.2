Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652F6CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031D16B0027; Sat, 22 Nov 2025 17:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009AF6B0028; Sat, 22 Nov 2025 17:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A876B0029; Sat, 22 Nov 2025 17:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFD496B0027
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 790B61A0234
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:03 +0000 (UTC)
X-FDA: 84139671966.22.DAF61C1
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1942100002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dlTbZHqI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850241; a=rsa-sha256;
	cv=none;
	b=u2jibSp10hSjtUgHZX87cQ5utTQBgMjZxGBsHTrVcsRztG9uDei0P4ObcBa6uCM485H4gB
	27U1vJuhnia3WnZkRYEVhb0OhC/rBXifSRdEv8OyNQVI1LbskdEnFGj15fv5QlZaF5Z3u1
	qFigW2+2zB4Z/RRJTo9lBw0SRBcRWw8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dlTbZHqI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ou+OqCZKXj1OdOlQOs0wG/rcVUwC/PJeGlhuLikCmu4=;
	b=kWZJ/FCc6bmkj092LdsQTXjyiY60wVpq8EaI5WCoAU32jEPM9NUEl0DbBn+LqnaIYelGVx
	sK1k7kcONRwuoZUvX7oKEX2tsKsK/UlVLLM16gPAOtDuu4Fj9yR/3B2CELIT5Ek+bX93w4
	ZpMScrKwaJ6nSFt41P0mEVUeYmc+iwQ=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-640f88b873bso2736369d50.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850241; x=1764455041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ou+OqCZKXj1OdOlQOs0wG/rcVUwC/PJeGlhuLikCmu4=;
        b=dlTbZHqI57W5fX/jFEGcO7HcjrH48aDErBtXBKsXSBEAVAGgZm6IhSzTOHrpECBrpE
         mogXDZkPguv4JC9T+/l5stJ7eUXr14TrteQkSks+QqaaVvtRuuWqj/wGIqX8g9mrxyFO
         lOuOp/pP9TkSuVyC1g8bXjgpvYJj76+DICtHMmoiF4mEPlsCb1CKZ0xdgUgAww3gIIro
         3tQynTG2t+DE2I7mFOQpo+Y8AETcH3gp17HumXNZ+a9cyRmO21VaC+lj8B3QHGb6ccLf
         f5saCyzHPyrjIgC/kdjSkeSIO12XVcRTL84Cv+Lb6eK4C9UR17OTdo3OPcIcGOvokYs+
         tcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850241; x=1764455041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ou+OqCZKXj1OdOlQOs0wG/rcVUwC/PJeGlhuLikCmu4=;
        b=P4MtDkff81rcQTs8hEr2uPIxDODg1wPSF5WPVNHHXRivL2aMDnQy3jJR2S36tmTZaN
         z3UoaruWAzSZVESvfmYzDDIkz6fsGaljHzKZ8bdYSX65Wh7jI3+SgPaLNg1HgXcKs70S
         gAtDxlShbbCjqOwYFmuw9vGooKTudD6U+Lrx38jaKjXTKTgDty4wY16NDybwf//k2U9i
         /y+aqzoc1Tg9gYviGUOuO1xTxsctafbBJS97FgAPe6ReMj3k7nTx4A5jJMGqUzKzO/4l
         bfRKDCW3lg36uHiU1PKc6hkCTFKb6V937BKotMAS5DI6164xrl5Z5Fn/HlLDw1ufGZQJ
         Rwtw==
X-Forwarded-Encrypted: i=1; AJvYcCVe1kWaDxjHveTD9wf3z5PX6ziKmY8xr0Cl/7YpyHhSgsrOyQc7KP379bCKt4PHOSZHe4m/tCB58Q==@kvack.org
X-Gm-Message-State: AOJu0Yxv3WNPXPlEGN+4v7GKrK4Yi27eovJC2akHLz93/pChgm8uNbp7
	TsuVU4DY4Z9+HmMhVG5PzZ62xjxQOqa93+KVaXqIej+uVEE4d3mbNQke+lPRBQBaOZc=
X-Gm-Gg: ASbGncvI7Wb0dlulusZ+1vkJ4On83i3pEi0BbAbSl5/zmLqeeMwg+aEWbjoaHNXMxXu
	J2Yi93Qk47YZTsC8ME/WEFUaxNMRNWKj5p2Q8soLYYc+EAxQfXoMy5I0t5YBd8VBi9iqIvbhUs6
	wG3WrBmiYRuAhRCyXWXuqecC4YPOI6+ExYkBEHprtV5ftIEfBc0Qi/1T5bmhrJhuMtJmIeMuXYw
	9yixboUH8dRRnBwtn/Atu9qO9kMz5LkhklM3O5pC6qj2cRnwQCCLy62wgPYCJtSKWo5fb0s2Y2N
	ljzSb+fpHasqWY6Ftfr4dKkAmJg5h+gRl4NXbcraVU5W1k//sGo3foDsSHa2UCCgdAlIFZ9AlFj
	KfnE9pUOjhjGQFSF6Fm4a8UhpTk9K+7UL9U5Dpwx8RtG+jjFu4vYhbAvpZKb8eMrtGMR/m46Cg5
	k2qnL0ahqwds9KAh2PrIaOR973HTPggPfh2Haj/557u/wbQpm/Sp6Lj0iC1RbroTyFlOh1VbO6x
	dVUyEQ=
X-Google-Smtp-Source: AGHT+IGfZof8qUF1IkZZI7c6YLOTPv1WiDaxFjl7jw8fTLuhBRkKSr+RcqIexB8nICTyaMONoMz9vw==
X-Received: by 2002:a05:690e:d08:b0:641:e826:bb71 with SMTP id 956f58d0204a3-643029b20e8mr4919920d50.0.1763850240618;
        Sat, 22 Nov 2025 14:24:00 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:00 -0800 (PST)
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
Subject: [PATCH v7 02/22] liveupdate: luo_core: integrate with KHO
Date: Sat, 22 Nov 2025 17:23:29 -0500
Message-ID: <20251122222351.1059049-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1942100002
X-Stat-Signature: tqe935jyxeckqnwne88cfg67mujrx7oj
X-HE-Tag: 1763850241-758147
X-HE-Meta: U2FsdGVkX1/+sreNNOhU2L6alXjwgbApQiEzBbLRhfF9PZ1uMIBUekZydll4FAjxW5J/BY4wkZ0Cd7vgIyabulwifYbOTgtxPsNCYlU3GUMzcjq64iSwF3ZMWNGInMc3+B0BTNc7qB37WDJLWFWloyVcm2Y7xotoTkr6TBLicPVhn0XSr3dCovKIZpy9IWCVvgkRurUZwoLe45osUClNwR9pxoDxMERHvXrrSe8OmIXDTCcdpy6MdHO3NycjyU2PrtHnZdE+DPtT2ce7326YhOm7dC/n5yyh5C2J1a4IvVSyrfWDjcyr3rGYkxqSE3xmNRNUf4q9Vljo9ICvFAirPjBUkXteiAusIcGBwp/um8SrfwZsHV2a6nrS7Zv6i2ZqYCUGH7P3DI+jJ/8krWvEUTORt9ATttKvPFul059WGMoMWszX2ylE9PLC5uiSG9Zqhbv987MDGq6IuWRL6cMYe6/sxzM2FzHrxOWEMkQ3H274PWCOYJRK7/iWVev4rkLv8In+eo3S4lI/xAkGjbGub0zSwA/enqYgs5TfdXfXvjNKCm8PqX0clVOty+GBcqTeoNYD1x/fjN9ZBimVVksGzYIVXjelfDe/YxCaw/M4di6PoKW2hCmK8d7PVX5p214xrpUJ8/oytj6e/3ZMx0apCMUVJ7nez3wF8zEXKmX5syguWmp4Xqr7QDbzbnxBO3O5lCMsYFEr1tiyvwA0IdzKmGhU9epAy7m+E3hDv05eet1OMGtwY8JzRtNA7Ygf5XGkdDvaBpzfJgwTG2jOPwvSQ62CI/gZVZ8S0S9RPin+TTgOvpRN5+OxG9mVyIJg7Ps15kkz4AoJi/ETFAozrzHBelQ43cDvC3qVZ9UwmV9lrz0lwYodpTQtRl+zW8P1n0NziQli3z7JZRjQsUCvRo5D/DIZryFCS5l/b+Ikg9d/wy1xrMXjr6Up/wmekodIs2t61aRg0lx3hUyCPwpADAx
 V3WRMZCK
 LGRRFjE7ma6f3oh/4kudL7PdVp4kaJatJ6PB4LSL8Om3H/0FvGQjytm9Fq/GHoYo6xG82mG0S3us7Kpr8QNzxYd3H8Vr1dlrVIFBlhKomzJ8wvkeUFvQzlpLF2VoMU1MJ3fvn+qmtPDOtyBF8Z2bhOSCjP+wVkbotZFwnlOld1cbnMGhrmHSeu6KRnZg+6uiMAXyk1AGui80lYGGrcDYAyaXZ0eIOG6t8a2UJEEgAHySHGwS2AzflSodGqOUstbyxbnCH6gi4oQ0b9YgKgsanxz0wqRTul7HCNdtPFMHpsIsIpMkdKGlE3H3+KRs5NhgpWWs6JeUBVE3tNfjb9AfT5xB5NtLnycIT1lJOfgBbLcLE31OQLHKMMIa9kmAF1qMDKFURtV/iEbHixI7/drfY8+BgExVVwTVXTGF8w510NQrQpYiK2Ti+R777+WkK/+aSAW22cB4OFo5DRO2fZIQZ+U3IMD+4gnhhx9Ok
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

LUO now depends on `CONFIG_KEXEC_HANDOVER`.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      |  54 +++++++++++
 kernel/liveupdate/luo_core.c     | 154 ++++++++++++++++++++++++++++++-
 kernel/liveupdate/luo_internal.h |  22 +++++
 3 files changed, 229 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kho/abi/luo.h
 create mode 100644 kernel/liveupdate/luo_internal.h

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
new file mode 100644
index 000000000000..8523b3ff82d1
--- /dev/null
+++ b/include/linux/kho/abi/luo.h
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
2.52.0.rc2.455.g230fcf2819-goog


