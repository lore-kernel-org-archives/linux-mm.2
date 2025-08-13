Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E774CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28AA900072; Wed, 13 Aug 2025 09:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9A9900044; Wed, 13 Aug 2025 09:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1FA900072; Wed, 13 Aug 2025 09:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7333A900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C23A160372
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:45 +0000 (UTC)
X-FDA: 83771839410.20.42102DA
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EB7640005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k7Y6qOtO;
	spf=pass (imf11.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqDz/RTemVf8hk/fnHnI91a5xRvLZSkfIpeLZw9SlZs=;
	b=8WebVW+I07t1fFaW8oB27g386+qJbzKW5S4+wB2Z21dYLlGlVSsQtQlsPN2wyHVq+dXczz
	jfSH+VPIIwJp9C961V2Qo/yoMdKy+nORFucWQLU4dkcTZH83HhTu4KN9Wd8AHNYNX/OUe2
	MlVpuEX8I2kkPTStSPgIKH+pURGc8B4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k7Y6qOtO;
	spf=pass (imf11.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092323; a=rsa-sha256;
	cv=none;
	b=sTzn4gDRW25xrIr5RICJjR3LPmJBSu4tgcLQ+aBpqVLHdL+jEI+Qi2jkonQhdskLHEd1KP
	bgqfX3p+Jz1poA1c6edbqz96N4UBPoKVo8BHQFRRsFGhrlCQQbORqdM8T4y9M4CixSnqO2
	AuCQcYMKvaNKzeRYDfUo+7dR0A7Lhl4=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b7892609a5so4155580f8f.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092322; x=1755697122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqDz/RTemVf8hk/fnHnI91a5xRvLZSkfIpeLZw9SlZs=;
        b=k7Y6qOtOJOqAUxeW20wzBHUh9z+oCiXYpF29cip5xAxLHn0MPHEwKABdrLx+eMMSmX
         ucspVQn+1KhQKiWmt+txwED29DbJiVOhfvLqPuZ0XVbqr9m9QWI48tq4Gwr4mdriOHM7
         uAUS5WAuA6yz7YICaF+66gnEdqL1oCiestAh9ijp13rOZxzwHp99jm2lPqNUYxLp8kIv
         apHNdumAsPuxJZXO86oyYNuOKYvRooMdFAdj8httF8ezfztmeJ7Hkq7+zUvi74NjTkcN
         OHQwnUkE8sSYUEHzVYWjNquzne37/JHsk7E99UrR0rMksaKslXajM8vFHY3CMW4bXLqX
         5v/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092322; x=1755697122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NqDz/RTemVf8hk/fnHnI91a5xRvLZSkfIpeLZw9SlZs=;
        b=C3nPTlQHti0FybYsnYv2m3u/cvIi1eB7x2IPfTs584DkB+8Nh5PQCji5eKgMb0hvWW
         bthGw6IicbYg7+g1DrRooiUElupN7QLWvnpNiS5ELrrbL0S7cAT7fgc5f6+x0PQHWM6v
         8/nsV+FZ+qHOhh7akOXVwrUsh+ZB78I/Q02ryAop/GH5SXlPgJ7eCDNdL7ZZFS4Q98/w
         1aHZTLEGwCagO0LUpD1tNsUOBknA/HgwQ5YrxmWSFprMJoLhBbqGM3KabWL2YMIsYCgf
         0Tr3tv0eRcO8HeyxryvUt1OPe5pjGXiR/e7EpKO+4HFPF8/cusZis7tSTUh4BcPwYeE4
         vuvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQmtnjMvge/4kzL7kp6Jllef8sshzGRLx/v3Ee4yrdFrMfI2CyKXwPJywIqVcweGTcoLMWM0q+wA==@kvack.org
X-Gm-Message-State: AOJu0Yw5dV1xn/uQ+jNl2UX+LIAOPsuOQU9gJE2doTohzoOyPC85boZm
	6SOi1GUseCG2JzR5QV1Vvz8JW0gTnoy/AiOTr1qdp10YTOEpi4LZAAbrQa1MrYQtoOPT9w==
X-Gm-Gg: ASbGncto+S8XjM6E/mmIz6Cwd2KyiPZZMe86bPVNN+InkaFrrJM/QqF79DY0sgq2our
	f+MqrqOoXNm2cdq29x+5ZNBxAKgOkmfa6Iw4symSxy8cSdrWSPzfv8lj2FT8B40UnpMLt/v59iy
	T63p4e8NQJmvYkcz2IckpNC6cQKQhMLa6metOmt1uTWKz1jlJFUAEjAQjqfX40RrzTWH1bQZvRS
	2rEhULQqrD/i5qKsJFf2zgmX8U3p617v9huhdy0CCzlX5h2wVWER8NcYjJ/l94qiZ/YiheGOBvB
	bqC+2EECAU9ot02AKLKlATMJC3j4LOC7Hmz5j9Q8Pno8G/HVI1b2brgkn3tLbNgZVcIWLLaH6NA
	/ZU164Ji4a4CJaSEHgpKNH7ORMcbRgWB5Why4isHP30Gc66iyxUbSAdDyPzy/hMZURwkv17lVwc
	f2Q54sKFKr6gq5qX4=
X-Google-Smtp-Source: AGHT+IGKke6LjQNxg3psbIRPw8246iMbv8THZ+fYA644g5YUiVc5QrmNXJbLKniBxb8JhdUcLxhU0g==
X-Received: by 2002:a05:6000:240b:b0:3b8:d08c:cde5 with SMTP id ffacd0b85a97d-3b917eb47ebmr2500162f8f.43.1755092321515;
        Wed, 13 Aug 2025 06:38:41 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:40 -0700 (PDT)
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
	linux-mm@kvack.org
Subject: [PATCH v1 RFC 3/6] kfuzztest: implement core module and input processing
Date: Wed, 13 Aug 2025 13:38:09 +0000
Message-ID: <20250813133812.926145-4-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
In-Reply-To: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eh5r5zrqa59ukqk3mzzfxw1xmn88dea7
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EB7640005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755092322-229782
X-HE-Meta: U2FsdGVkX1+4upfRgQtkufUfElzkWLEZsK8sJSNy+aGN07wRdMF9VCXhoL6fEJUU8lhe2GadnIWNwZV3OUN6oRa/pacpava63yOYdvr8UJOTfGG/HAlJljctr93tOozffxH6glhjnbRrIFnBgb3Fl+PtY4AQYTcpFdh9QnDIYeQqk3FC2HNUI2D7BYNW6F9TH1zYipD491+EiwBlQIoFjrvT6HlWa6lrkEooll8qLuiOyVSCp17fsvPQLXhjaff6AcCsG86P2lrIvyuc0Ep5VLtcoofvEtYP/VV2OHZms4WbPofRamxIT7Q6KmMFqKFC5ThK7A1iKL/VaOg9zWlx06LY7axdJJeOnzM6Lk2EYmEiTz9e1su/pm9od5SMBH0T4Yku6PN+Bh4mR5DK/DpbRBj6vWIokwvK8xuBVYpnEhVXaLKcB4SD69xUUDAf9JNTq3HdXDSRgK08tH4AuPuGsWkR9nfUdbwyp+Q5t8GK8cuiMSRy1Nbp6r5FUSbbLBcuJLYwp/kkJMVy8cFyrBQyMipzoUQZ3O7dQz+ZlFDz+2StJ7nAA6skjg5KK32g7rdc8eJ+u9x+AFG+pFOJ87IGWcImObK1DGOjJptzA8zEAUE1r7ecUazDQPupsFrpnsWEbCQbwrdfq0kq4PMa9cTuVGDxhV6iXfqBfY7nSSID1b0ssD16LZcKcLJRuy7NPVZWMd9gIPyqX/5BbOGJVNBzuxDStfvL5D6U5foQDiVUq8tylQ03N7GetwIrTnFWLzX/gZouh/MgfX+hIxMASSOfXBTYDpQb1Di8RCmDgS050WburGjB+F72rLsgtd55PCGDj4SG6LYAYyQ1Ls8JxXAou5DTrZqdmRDch94MHZ/uV6cIUQ1TLUvydb3h4hyyLFXzPPLv2Uhb/48ODTJwGGOyMV+hWML1PBEaXzEz+vxTJ8PsongaVjz2CQcUmNDAmWIpzytshxhjzRLXB/dRmQ4
 oyHME5Lj
 6Y7FCw5tTy+HqaPgTvCCwvZydA3v7KKG0H4gu5bXZsEw9g3wcJNeeoqck5cr8KQSSQhWY7+pMyUEXmJjMHjqsEF+1F+uUeD4ZsBFVOu0jU8J8I2GaI/+g0ObLAww8FnmF7C2y59VOsUSKtuEmbk3rXlmdpW98JPHop1MenTMuh15GE+wvCZhFd6SRYmdUAlanZRBCjxmxZeyILOf0WJopgvbWiUiwmcRfowu1ahftyYYbFm+olGB9cCS2MAAxSxxieZzoYZxfcoE9QeFuTA4yVh4qj45yTTfZRuGe3E7t5IzTvFALD5/HJXa36a6HCoOe4JsbOmqOMck8zRrEpG3M0tpAEDecGxhqJsHHQ/uwa1JoFo1uQVmhqgiXXFt0hyOd2S6uh0fw8M23T9vgMA9o+yJjWG4t6pxsq/RtWHY4mxE0IA2BvTTas2yDxwfEuPxJ5b/S
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
 lib/Makefile           |   2 +
 lib/kfuzztest/Makefile |   4 +
 lib/kfuzztest/main.c   | 161 +++++++++++++++++++++++++++++++
 lib/kfuzztest/parse.c  | 208 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 375 insertions(+)
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
index 000000000000..fccda1319fb0
--- /dev/null
+++ b/lib/kfuzztest/main.c
@@ -0,0 +1,161 @@
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
2.51.0.rc0.205.g4a044479a3-goog


