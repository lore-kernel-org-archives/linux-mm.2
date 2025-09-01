Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD894CA1009
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ABB58E0002; Mon,  1 Sep 2025 12:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE468E0030; Mon,  1 Sep 2025 12:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82A28E0002; Mon,  1 Sep 2025 12:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD1028E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:43:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DD75BC4DD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:14 +0000 (UTC)
X-FDA: 83841251508.07.D423F0A
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C5F1C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lSvhuRR9;
	spf=pass (imf22.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756744992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMtkoie1PzFbZ/9GVFEn9qZYkcpNtvbFVewJfLAvroI=;
	b=CL89sf7iKGYBH8a/y/TNXem7hU2hX19FnBT+u/1K+x177ityMyJKikKinMoK1jnbzQgxeN
	nubi+9ViCcsi42Vt8zUodgfbQ9AP4OZL1aw5uKdR1f0F/+yZiWyE4bVQFikCiGf6nldVmU
	Fl1sNfn0x6BBQRkoZc/FrTqPdXqsAds=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lSvhuRR9;
	spf=pass (imf22.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756744992; a=rsa-sha256;
	cv=none;
	b=1c35d6WUlaJ3APnzJeFRcpSKbKvM5LDYPv4TiECbA/aby06tYGLZ0rsJ8OLIVYq26kDoQV
	e7/vvV+56vHM1Z4cbM3iMtClNF60E72dzHYa1ESEUKY7QXlD+aykVsG9In1x2/m64wcRUd
	ZqnRkgolcP9gVABc9wySgMiViHYPjLM=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso30644865e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744991; x=1757349791; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMtkoie1PzFbZ/9GVFEn9qZYkcpNtvbFVewJfLAvroI=;
        b=lSvhuRR9xtIpt/IppOdRqDO7AX24IuQi7mIHWtVcFGHqQ8xffKsuE1+2WwAP5jbRTp
         kfZfWlk9/3+6Xas2vprP67Vo7uB/bhPzPdn5tUFJd2Dq/DmLyuBLqifgD2CmEUA5Cfml
         5vk6KeEwfP+xuIa5MXOG9sLWU7dtBGEEkV0ZNFKSU2sGWyNgc1y15Xz1ilnQuXgSF4xA
         XPPL61Qe+CLOSA7bpv5D5k7JLz6NNsYUTrwNla/4uVLY1AFdxwHi9pH9+YLQiD2eWE2E
         Zjy2KGPZAquAAneX2cDxncT6Q/0pJL871nggH70NPwsiYEKCo3t+xBRs6vUBONTJMTYV
         YpGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744991; x=1757349791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMtkoie1PzFbZ/9GVFEn9qZYkcpNtvbFVewJfLAvroI=;
        b=FZCpcPKSlvbyhn8WzFHuSGqKwYJ8ROj+kkLWzdvQVfyfdNVhC9Ln8k5/mBd5PuZ6Uj
         5y5SntadvRO8ZUmZJ+a15hBX8TdiIPf+L8R2HBBFoUPJWOSLZW1sDOyR35tP7NGCwjBI
         Ty0SW115wSIZ/nbl+ESRdxT3QWA3jqRc0wctvRadiCZMPpG+TLHHKHvi4iiIqtC+1BeW
         b7YHoddiPeJo+6BAOBkU5DoOq/toPSjKHZcIhrhE4zXlXR4MVY8bVvpZmaBOboyg/waF
         efMbl+UG77RGQwtIZa7pKCQirru3kOfFTK7Y1FtvRBClACPLy2x7jKDrj91h5fk8qXfq
         m9EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDs0StPjoT4XT9V+/XqsOEngWPTqZPa2O+mBuwDgGEWFtQ/9wjqDlirgiHDU4f1sU+AvqaARD8vw==@kvack.org
X-Gm-Message-State: AOJu0Yzw4sfbv1GaexSP7NHwceOA9L/ajFd1faUYQb0uWqhDTjhlMJ2Y
	xADKpdwJkj4vQMdks8/oC9mNVvp02E3tvFEe+jFqY3yK+cw4uJkdufWP
X-Gm-Gg: ASbGncsqnb4bV5SjuZaiH2vEQUQKdVHI41C9d09hVOY/AO33PNoOMSgUT+Kd7QgQsot
	PKitOn33avcFXODXGeQVWEL4J/Su/DIfyjlIAUaGQTJADlCBcg4KmGiq7r7dPKhtnxn0k6n0Nhn
	CX9iMw/C55Qz7wLoWhh+ySUG9DoAnQn2lEjbiKmMw+yEsuoSrh/SOB1ebs9ZftI477INiDE+B6S
	LcZkMcnrS8xbdsWvQA2nj9aKDe5qDvBVgOcRJanvN4ulyCRbjm3ssRbEjVU/ppupo0/puJvz9yM
	vdlj1XehFIkcVWkVe0QTVDJQDc8ePs91sXYJqZktWh72kfQ75wR5NxsAKp2fWtZUaeYRng0Gg5O
	hBb9G3buKBoE7x+5EcA+enyGSHybi4CaCGEAlYcLEqM4M5jz1vcq01n2dwOqQjyoxStKaaoX0Yu
	WHr3wg5iTrCj7BcFpGeA==
X-Google-Smtp-Source: AGHT+IGpM9bd6W7FkfsOwYPD+t+MlaqBnshvtZm283Cr6UHrucbgXHfgvmEeeRzAnIY+IYjLZ+c+6A==
X-Received: by 2002:a05:600c:3b8a:b0:45b:8935:16bc with SMTP id 5b1f17b1804b1-45b8ee1788emr25495035e9.37.1756744990976;
        Mon, 01 Sep 2025 09:43:10 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:10 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 3/7] kfuzztest: implement core module and input processing
Date: Mon,  1 Sep 2025 16:42:08 +0000
Message-ID: <20250901164212.460229-4-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C5F1C0006
X-Rspam-User: 
X-Stat-Signature: pyig4moar8dg1zqgje8t9ge7rjqbgexh
X-Rspamd-Server: rspam09
X-HE-Tag: 1756744992-271251
X-HE-Meta: U2FsdGVkX18ExsLuwKqFeq29gItxczCk9sCtF2wI0nkLBsd4Kl/22UlwxjEgt4VPUyLl3hZUEb2A2WiTT+7c9zutFQofm6kT3ZXvaTaMLAuC6nLMKV4EuJO+A0VlWrMhuLx1cds6NiLBoPgWUoiQ+daHf+CQ0wX/xFV17umoNQpQoeBu98m8uWR1PMfLMiPlS4Uk7UKeVDB+w9u/UiW4VDpMMp6EgUGR61FPiusbbEi8P4V5wKra8YeZaHdnHzddSTZpO+5nN9gOloXqGBCbY5DWVml0CbY1YNV8Vf5DRLxS9SsciwDtqXz3kR0NMkIEx1pmQQI36Fwb8/I8TN/QT9IriveQiiMn5s15WZgSQotpcVvrEXl4tOm1Mb7NtcXaSzQlkOwsVSkqPCvz7o7WCyxrRMolGslI77eckUpu6uM5VzbgAJAfPQC1BItsYCC8RoktYVTd9duC8q+Zf6WtCQ/KbVedtMqQJgWYTpViq2NcMRbl9wkMmY+8ySJAlN6rwn/vVwUA/AYpTWyx8/c8ujvmv1w/hzpulS8kHe3HOcV3nCqUw/fCIhDyuPi+K9ZAdQhjnEggk+Fav6K18+0iQHhQC30/8zzUchzmPxK8EI1RkdZqjXMdXNfDUmQJ5lrfSVTK6e4W+mb8lTczSOqABFQktTwQeyr/graf0UAhKOwHkwAjeKDC+XNXj1QAANZxfhGo7NdYk045lp9ataAHxXUjQr5aQ/jP5D2XY8FhyEaRyNT38r/Q8Cs8+6yJX7WDJvnC3gU3yLWP82WmD7xeBzyfeHadOCcffZKgMWlnpIShaMEdS7pkbOEETJL4ReU6nfCKUQpr1R1bdFOq2uP9JiNGPUih/FXENCLMVlHV4DqlignamZnVVIknqeCTu+NVNinaP4x53D5P2bgMoCfA7u6A82xQSzK4XM5a0qKOoqLMjDHA0QwW+dxS4RXiBfkUq5/l9lwKylqBrGt+G+G
 hb4P4iWR
 nA9vYgVzL8lO9csjUNrw5eApcY6GLxC5kzaC+FNHiHjlcZ4g5SgRDFuAQqnk3LGTHAbp8xlyydLwhI6BgcRpQkJH4vea4KZhbCav8ckXNrlB4r1Tck44GEEWKo2E2SwioPB1A/DzV2t4QCqbySIXGYH5As1DasSOnIuH0Skd9etSYdY1hgPw+dfS8jNV6t9+RDkqPH82YVtepRSl+SHNCT4aJQKT2u8vNCoPdP6b8UaAkxkvOpjATfAi0AaVjhbfiYlK/a8qNdN7OTysPR3Ff4UIT/UfnMJIgQzRiPfX6zCRLKwSDT+soHJDJBTgYB4LUBi/1Q1lcEgCxL9107ow743xsZ4cOJ9SllCZ053qZNBOI+6DTIIdNviuykyuCyqRYAnrn35U4N4SN8oK5U9F82zXkx3S8PcvytXQgRfmCgQpGncQaRN3adDD/Gdj2/KZWr9YD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add the core runtime implementation for KFuzzTest. This includes the
module initialization, and the logic for receiving and processing
user-provided inputs through debugfs.

On module load, the framework discovers all test targets by iterating
over the .kfuzztest_target section, creating a corresponding debugfs
directory with a write-only 'input' file for each of them.

Writing to an 'input' file triggers the main fuzzing sequence:
1. The serialized input is copied from userspace into a kernel buffer.
2. The buffer is parsed to validate the region array and relocation
   table.
3. Pointers are patched based on the relocation entries, and in KASAN
   builds the inter-region padding is poisoned.
4. The resulting struct is passed to the user-defined test logic.

Signed-off-by: Ethan Graham <ethangraham@google.com>

---
v2:
- The module's init function now taints the kernel with TAINT_TEST.
---
---
 lib/Makefile           |   2 +
 lib/kfuzztest/Makefile |   4 +
 lib/kfuzztest/main.c   | 163 ++++++++++++++++++++++++++++++++
 lib/kfuzztest/parse.c  | 208 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 377 insertions(+)
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 lib/kfuzztest/parse.c

diff --git a/lib/Makefile b/lib/Makefile
index c38582f187dd..511c44ef4b19 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -354,6 +354,8 @@ obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
 obj-$(CONFIG_OBJAGG) += objagg.o
 
+obj-$(CONFIG_KFUZZTEST) += kfuzztest/
+
 # pldmfw library
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
diff --git a/lib/kfuzztest/Makefile b/lib/kfuzztest/Makefile
new file mode 100644
index 000000000000..142d16007eea
--- /dev/null
+++ b/lib/kfuzztest/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KFUZZTEST) += kfuzztest.o
+kfuzztest-objs := main.o parse.o
diff --git a/lib/kfuzztest/main.c b/lib/kfuzztest/main.c
new file mode 100644
index 000000000000..c24350eb1fca
--- /dev/null
+++ b/lib/kfuzztest/main.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KFuzzTest core module initialization and debugfs interface.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/kfuzztest.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ethan Graham <ethangraham@google.com>");
+MODULE_DESCRIPTION("Kernel Fuzz Testing Framework (KFuzzTest)");
+
+extern const struct kfuzztest_target __kfuzztest_targets_start[];
+extern const struct kfuzztest_target __kfuzztest_targets_end[];
+
+/**
+ * struct kfuzztest_dentry - A container for a debugfs dentry and its fops.
+ * @dentry: Pointer to the created debugfs dentry.
+ * @fops: The file_operations struct associated with this dentry.
+ *
+ * This simplifies state management by keeping a file's dentry and its
+ * operations bundled together.
+ */
+struct kfuzztest_dentry {
+	struct dentry *dentry;
+	struct file_operations fops;
+};
+
+/**
+ * struct kfuzztest_debugfs_state - Per-test-case debugfs state.
+ * @test_dir: The top-level debugfs directory for a single test case, e.g.,
+ * /sys/kernel/debug/kfuzztest/<test-name>/.
+ * @input_dentry: The state for the "input" file, which is write-only.
+ *
+ * Wraps all debugfs components created for a single test case.
+ */
+struct kfuzztest_debugfs_state {
+	struct dentry *target_dir;
+	struct kfuzztest_dentry input_dentry;
+};
+
+/**
+ * struct kfuzztest_simple_fuzzer_state - Global state for the KFTF module.
+ * @kfuzztest_dir: The root debugfs directory, /sys/kernel/debug/kfuzztest/.
+ * @debugfs_state: A statically sized array holding the state for each
+ *	registered test case.
+ */
+struct kfuzztest_state {
+	struct file_operations fops;
+	struct dentry *kfuzztest_dir;
+	struct kfuzztest_debugfs_state *debugfs_state;
+};
+
+/* Global static variable to hold all state for the module. */
+static struct kfuzztest_state state;
+
+const umode_t KFUZZTEST_INPUT_PERMS = 0222;
+
+/**
+ * kfuzztest_init - Initializes the debug filesystem for KFuzzTest.
+ *
+ * Each registered test in the ".kfuzztest" section gets its own subdirectory
+ * under "/sys/kernel/debug/kfuzztest/<test-name>" with one files:
+ *	- input: write-only file to send input to the fuzz driver
+ *
+ * Returns:
+ *	0 on success.
+ *	-ENODEV or other error codes if debugfs creation fails.
+ */
+static int __init kfuzztest_init(void)
+{
+	const struct kfuzztest_target *targ;
+	int ret = 0;
+	int i = 0;
+	size_t num_test_cases;
+
+	num_test_cases = __kfuzztest_targets_end - __kfuzztest_targets_start;
+
+	state.debugfs_state =
+		kzalloc(num_test_cases * sizeof(struct kfuzztest_debugfs_state),
+			GFP_KERNEL);
+	if (!state.debugfs_state)
+		return -ENOMEM;
+
+	/* Create the main "kfuzztest" directory in /sys/kernel/debug. */
+	state.kfuzztest_dir = debugfs_create_dir("kfuzztest", NULL);
+	if (!state.kfuzztest_dir) {
+		pr_warn("KFuzzTest: could not create debugfs");
+		return -ENODEV;
+	}
+
+	if (IS_ERR(state.kfuzztest_dir)) {
+		state.kfuzztest_dir = NULL;
+		return PTR_ERR(state.kfuzztest_dir);
+	}
+
+	for (targ = __kfuzztest_targets_start; targ < __kfuzztest_targets_end;
+	     targ++, i++) {
+		/* Create debugfs directory for the target. */
+		state.debugfs_state[i].target_dir =
+			debugfs_create_dir(targ->name, state.kfuzztest_dir);
+
+		if (!state.debugfs_state[i].target_dir) {
+			ret = -ENOMEM;
+			goto cleanup_failure;
+		} else if (IS_ERR(state.debugfs_state[i].target_dir)) {
+			ret = PTR_ERR(state.debugfs_state[i].target_dir);
+			goto cleanup_failure;
+		}
+
+		/* Create an input file under the target's directory. */
+		state.debugfs_state[i].input_dentry.fops =
+			(struct file_operations){
+				.owner = THIS_MODULE,
+				.write = targ->write_input_cb,
+			};
+		state.debugfs_state[i].input_dentry.dentry =
+			debugfs_create_file(
+				"input", KFUZZTEST_INPUT_PERMS,
+				state.debugfs_state[i].target_dir, NULL,
+				&state.debugfs_state[i].input_dentry.fops);
+		if (!state.debugfs_state[i].input_dentry.dentry) {
+			ret = -ENOMEM;
+			goto cleanup_failure;
+		} else if (IS_ERR(state.debugfs_state[i].input_dentry.dentry)) {
+			ret = PTR_ERR(
+				state.debugfs_state[i].input_dentry.dentry);
+			goto cleanup_failure;
+		}
+
+		pr_info("KFuzzTest: registered target %s", targ->name);
+	}
+
+	/* Taint the kernel after successfully creating the debugfs entries. */
+	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
+	return 0;
+
+cleanup_failure:
+	debugfs_remove_recursive(state.kfuzztest_dir);
+	return ret;
+}
+
+static void __exit kfuzztest_exit(void)
+{
+	pr_info("KFuzzTest: exiting");
+	if (!state.kfuzztest_dir)
+		return;
+
+	debugfs_remove_recursive(state.kfuzztest_dir);
+	state.kfuzztest_dir = NULL;
+
+	if (state.debugfs_state) {
+		kfree(state.debugfs_state);
+		state.debugfs_state = NULL;
+	}
+}
+
+module_init(kfuzztest_init);
+module_exit(kfuzztest_exit);
diff --git a/lib/kfuzztest/parse.c b/lib/kfuzztest/parse.c
new file mode 100644
index 000000000000..6010171190ad
--- /dev/null
+++ b/lib/kfuzztest/parse.c
@@ -0,0 +1,208 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KFuzzTest input parsing and validation.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+#include <linux/kasan.h>
+
+/*
+ * Enforce a fixed struct size to ensure a consistent stride when iterating over
+ * the array of these structs in the dedicated ELF section.
+ */
+static_assert(sizeof(struct kfuzztest_target) == 32, "struct kfuzztest_target should have size 32");
+static_assert(sizeof(struct kfuzztest_constraint) == 64, "struct kfuzztest_constraint should have size 64");
+static_assert(sizeof(struct kfuzztest_annotation) == 32, "struct kfuzztest_annotation should have size 32");
+
+static int kfuzztest_relocate_v0(struct reloc_region_array *regions, struct reloc_table *rt, void *payload_start,
+				 void *payload_end)
+{
+	struct reloc_region reg, src, dst;
+	void *poison_start, *poison_end;
+	uintptr_t *ptr_location;
+	struct reloc_entry re;
+	size_t i;
+
+	/* Patch pointers. */
+	for (i = 0; i < rt->num_entries; i++) {
+		re = rt->entries[i];
+		src = regions->regions[re.region_id];
+		ptr_location = (uintptr_t *)((char *)payload_start + src.offset + re.region_offset);
+		if (re.value == KFUZZTEST_REGIONID_NULL)
+			*ptr_location = (uintptr_t)NULL;
+		else if (re.value < regions->num_regions) {
+			dst = regions->regions[re.value];
+			*ptr_location = (uintptr_t)((char *)payload_start + dst.offset);
+		} else
+			return -EINVAL;
+	}
+
+	/* Poison the padding between regions. */
+	for (i = 0; i < regions->num_regions; i++) {
+		reg = regions->regions[i];
+
+		/* Points to the beginning of the inter-region padding */
+		poison_start = payload_start + reg.offset + reg.size;
+		if (i < regions->num_regions - 1)
+			poison_end = payload_start + regions->regions[i + 1].offset;
+		else
+			poison_end = payload_end;
+
+		if ((char *)poison_end > (char *)payload_end)
+			return -EINVAL;
+
+		kasan_poison_range(poison_start, poison_end - poison_start);
+	}
+
+	/* Poison the padded area preceding the payload. */
+	kasan_poison_range((char *)payload_start - rt->padding_size, rt->padding_size);
+	return 0;
+}
+
+static bool kfuzztest_input_is_valid(struct reloc_region_array *regions, struct reloc_table *rt, void *payload_start,
+				     void *payload_end)
+{
+	size_t payload_size = (char *)payload_end - (char *)payload_start;
+	struct reloc_region reg, next_reg;
+	size_t usable_payload_size;
+	uint32_t region_end_offset;
+	struct reloc_entry reloc;
+	uint32_t i;
+
+	if ((char *)payload_start > (char *)payload_end)
+		return false;
+	if (payload_size < KFUZZTEST_POISON_SIZE)
+		return false;
+	usable_payload_size = payload_size - KFUZZTEST_POISON_SIZE;
+
+	for (i = 0; i < regions->num_regions; i++) {
+		reg = regions->regions[i];
+		if (check_add_overflow(reg.offset, reg.size, &region_end_offset))
+			return false;
+		if ((size_t)region_end_offset > usable_payload_size)
+			return false;
+
+		if (i < regions->num_regions - 1) {
+			next_reg = regions->regions[i + 1];
+			if (reg.offset > next_reg.offset)
+				return false;
+			/*
+			 * Enforce the minimum poisonable gap between
+			 * consecutive regions.
+			 */
+			if (reg.offset + reg.size + KFUZZTEST_POISON_SIZE > next_reg.offset)
+				return false;
+		}
+	}
+
+	if (rt->padding_size < KFUZZTEST_POISON_SIZE) {
+		pr_info("validation failed because rt->padding_size = %u", rt->padding_size);
+		return false;
+	}
+
+	for (i = 0; i < rt->num_entries; i++) {
+		reloc = rt->entries[i];
+		if (reloc.region_id >= regions->num_regions)
+			return false;
+		if (reloc.value != KFUZZTEST_REGIONID_NULL && reloc.value >= regions->num_regions)
+			return false;
+
+		reg = regions->regions[reloc.region_id];
+		if (reloc.region_offset % (sizeof(uintptr_t)) || reloc.region_offset + sizeof(uintptr_t) > reg.size)
+			return false;
+	}
+
+	return true;
+}
+
+static int kfuzztest_parse_input_v0(void *input, size_t input_size, struct reloc_region_array **ret_regions,
+				    struct reloc_table **ret_reloc_table, void **ret_payload_start,
+				    void **ret_payload_end)
+{
+	size_t reloc_entries_size, reloc_regions_size;
+	size_t reloc_table_size, regions_size;
+	struct reloc_region_array *regions;
+	void *payload_end, *payload_start;
+	struct reloc_table *rt;
+	size_t curr_offset = 0;
+
+	if (input_size < sizeof(struct reloc_region_array) + sizeof(struct reloc_table))
+		return -EINVAL;
+
+	regions = input;
+	if (check_mul_overflow(regions->num_regions, sizeof(struct reloc_region), &reloc_regions_size))
+		return -EINVAL;
+	if (check_add_overflow(sizeof(*regions), reloc_regions_size, &regions_size))
+		return -EINVAL;
+
+	curr_offset = regions_size;
+	if (curr_offset > input_size)
+		return -EINVAL;
+	if (input_size - curr_offset < sizeof(struct reloc_table))
+		return -EINVAL;
+
+	rt = (struct reloc_table *)((char *)input + curr_offset);
+
+	if (check_mul_overflow((size_t)rt->num_entries, sizeof(struct reloc_entry), &reloc_entries_size))
+		return -EINVAL;
+	if (check_add_overflow(sizeof(*rt), reloc_entries_size, &reloc_table_size))
+		return -EINVAL;
+	if (check_add_overflow(reloc_table_size, rt->padding_size, &reloc_table_size))
+		return -EINVAL;
+
+	if (check_add_overflow(curr_offset, reloc_table_size, &curr_offset))
+		return -EINVAL;
+	if (curr_offset > input_size)
+		return -EINVAL;
+
+	payload_start = (char *)input + curr_offset;
+	payload_end = (char *)input + input_size;
+
+	if (!kfuzztest_input_is_valid(regions, rt, payload_start, payload_end))
+		return -EINVAL;
+
+	*ret_regions = regions;
+	*ret_reloc_table = rt;
+	*ret_payload_start = payload_start;
+	*ret_payload_end = payload_end;
+	return 0;
+}
+
+static int kfuzztest_parse_and_relocate_v0(void *input, size_t input_size, void **arg_ret)
+{
+	struct reloc_region_array *regions;
+	void *payload_start, *payload_end;
+	struct reloc_table *reloc_table;
+	int ret;
+
+	ret = kfuzztest_parse_input_v0(input, input_size, &regions, &reloc_table, &payload_start, &payload_end);
+	if (ret < 0)
+		return ret;
+
+	ret = kfuzztest_relocate_v0(regions, reloc_table, payload_start, payload_end);
+	if (ret < 0)
+		return ret;
+	*arg_ret = payload_start;
+	return 0;
+}
+
+int kfuzztest_parse_and_relocate(void *input, size_t input_size, void **arg_ret)
+{
+	u32 version, magic;
+
+	if (input_size < sizeof(u32) + sizeof(u32))
+		return -EINVAL;
+
+	magic = *(u32 *)input;
+	if (magic != KFUZZTEST_HEADER_MAGIC)
+		return -EINVAL;
+
+	version = *(u32 *)((char *)input + sizeof(u32));
+	switch (version) {
+	case KFUZZTEST_V0:
+		return kfuzztest_parse_and_relocate_v0(input + sizeof(u64), input_size - sizeof(u64), arg_ret);
+	}
+
+	return -EINVAL;
+}
-- 
2.51.0.318.gd7df087d1a-goog


