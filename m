Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1EECF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848E66B008C; Mon, 12 Jan 2026 14:28:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3B56B0092; Mon, 12 Jan 2026 14:28:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4176B0093; Mon, 12 Jan 2026 14:28:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 484036B008C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3657C3946
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:46 +0000 (UTC)
X-FDA: 84324299052.27.ED2DD87
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA486180003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NcTluayO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246125; a=rsa-sha256;
	cv=none;
	b=5v6/KobIGnpRCDpYmjeuti4XI1bU43fyqfHVTnctvBaj+LRrfIstyWHvc4yrDjflKd9U4J
	YeMchFlOltHMfQkARHQptlgn6QYkJNUrVRV/znvwO1PDVKk9YLExJZADaN6fGsYDPanECH
	pxRfhofDqzEbOxXVgdTz7cL+D0fsaL0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NcTluayO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw+SyBhpJj8Dk0rbLbmvCfZKQJWCvJPz8EnXuKWjIzw=;
	b=BYe5y977O0Fav1XdeaT52fc3NVbVCJ70WMXEDg2qfFDInDQ/8zK+nBRI4iK0WeNNPdCUn9
	s6oCEqXSTnnDihIecBtBCZw1+8pbCiDiUDCYg56IYsx2ZfeuaIJAhnTzcTE2eBfdpDiiCc
	nGzPrzf34EatR5KnoAwgYrKsDBGPKFs=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b9cb94ff5so9818129a12.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246123; x=1768850923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hw+SyBhpJj8Dk0rbLbmvCfZKQJWCvJPz8EnXuKWjIzw=;
        b=NcTluayOcHY6c+5i4Inbnz7VclGO9Sx7+M2NF/AHGKPG6l5sCDxmKn6jwWFi/JmaIV
         I1MvU8Hgtn+EfqGf8JE/9qFGDaXpvkrR4MW0DE50Gp/fLJoSF5pAIB3UaqA1WGcEHO9p
         1uwJAtk1i4vDZb1N/nH5/WMaQb2K9ONghYjgpPhFUWNuoX9YMJjVfycb4s5EE2aKVex9
         L8/l+eErk9YZQO57kF6tYQRxm769URNhHBH0NQJkWiuk+y3wxu0wi2hddsa5yr8evhTC
         JhLEtbckXbINGvvV/Ar6GXQl0cSxYUPYma02ZiK18ccSf78JkdZD9XFBEo8b31rWEIbg
         mALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246123; x=1768850923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hw+SyBhpJj8Dk0rbLbmvCfZKQJWCvJPz8EnXuKWjIzw=;
        b=tLGI+go2JnVtTDu3krLpFFFgdQYE37mslMZwwRGAi1wRo1g5eBdted5zEWGaBbMOII
         jxwlok3JWBfZWrgJ49OE6xpFtz4EUEaO1PQgxtpDek9CVLAEzjdzKBMBZbALfcyShRpM
         FoJU6KsB/wC2V+naDE2BFsEL55NJ6G+HP+JEahOaW1zIDibmOHqpVHiHdokG3p1MpFWw
         umNxtRmGsOa9F7zYJHGU8bD70K7owEcmOzOIR8zJaRZW3B0cZ0GNN+vSRzkSMIE4VIQ4
         XczXOcmfHwPSAX6sGntkAVjErR5q7ES25yTbsqESaBnWneQ/O+eyCdcNe4WNOvdWE6kv
         8/LA==
X-Forwarded-Encrypted: i=1; AJvYcCVV41a6tPjDO5wmONi5sVzD+N0KE9WhbqCNxKFmbBWO8EX7KhU9GQzDwTsF4J6NAomxXdoHVdr2dw==@kvack.org
X-Gm-Message-State: AOJu0YzN6ycK9oOCdZhlqVgNaU4GTsSoyaGsGKUzudKWF+gEnWLyuc2x
	BK2hYgUq9ZHf1u/3XhLvOz3uE4b0TWVYj0M6Y9BCIMcYl3bfHK4QowZ9
X-Gm-Gg: AY/fxX4Sa7PT0+GLR/BHCSzD6NiF2M7ZrxYnJrZaSrmT7zH48T7rb6zo4nMnFQWMhUb
	H4k5eKokkyTuinh907eIsiJnCoLOG+EJf9Mg4jWbj6DnOwAYoeNijhomKQ82GZ8ERraNvD3P/fz
	bj5WwtCS/HyXt7xdW+4I+XZV8MV8uIF/GkzZDn6Z+8j+9dO/B5gVOa+I2ceJshrIHR1ordpVzEd
	1HHzmOsaiKoBOSutg+oX9Y/4B4wxU8b7uKHJYGuxjJs+OD5DbCY/P4ziG8Ke6j4JicZhTOdM8H+
	vabLv+ubvCE9FZzjnQyL6R2FeSqBUKqyF9fQ92hiaBIheeJ2cdKPlPHxYM6ip4KD7nhnCtqLkNT
	duPyBPIsODVnxGEjPIpXBqlQmFlLB6UQK2Y2PtEJvd4rRDNhmMjCnejOKJsvPHnf62bMx3jy9+1
	BGyFfYfF7Bz5f05ljL7VAfkjJ+TGc/NRQLq7+xsv0/AnBm4CqbnA==
X-Google-Smtp-Source: AGHT+IFpEfk67Wu3s+my7vAAjgYzI8tk25YBO54kBfzlkDE0wM0gQSWTlCzqTfS+7VeyIp6Wy6teeA==
X-Received: by 2002:a05:6402:1e8c:b0:64b:6007:d8dc with SMTP id 4fb4d7f45d1cf-65097dcd890mr17558013a12.7.1768246122989;
        Mon, 12 Jan 2026 11:28:42 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:42 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 2/6] kfuzztest: implement core module and input processing
Date: Mon, 12 Jan 2026 20:28:23 +0100
Message-ID: <20260112192827.25989-3-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA486180003
X-Rspamd-Server: rspam06
X-Stat-Signature: 5i3hoqiayatrm4x3xnj5op4dw1ah4ynq
X-Rspam-User: 
X-HE-Tag: 1768246124-659593
X-HE-Meta: U2FsdGVkX1991XbdtnOUSJmGBgp04gLGjGV6IdCEKVU/RaYSRvtLSVgadj9Twh3Weg/WJEYLurmSLp7ZsJn7jZUQRYnOri6Pkz/MusUuad8SE0UjBcpRp45MQBgtDMei0UKL71pDtL2ARYUKG5q6/nWxe9B0HLaEepAUPKEHlPFSjtau9Y6lkHxUjUVlOY9B6b0PPfuh0uf+P6XKd6gJLvfw/UX+4xXw666dwPetxOGQS3ZhfSMOSLQ1PeW4OLRbVXxLT7+9JJCw9OUFb9HzRPu6mRyfXcSef4lrn8C75u+bwQx8uo/Rze3tTuWB2hyAJXQBsEjrsqljVKOKc2D16Yvg3nMaBIglK7YHVROOzDpKW5eReYyclzx/LT1NRdYdLMOw6thIiLWPDrTkhmnAhdGry2BMulnGPfT7qAkn2uPhNho/jUPcCfOu8sc7XcpxNCfgBCP0v+JDuD0CQJ/cya5q7QgOiO8iZFnhcngFYpAG4Nlf1lhdgpF0Mx82oGc9ClmdJfYIsAaLylkzZ6cRMdqWBLaC23JUzy0oVXYegzie3nGazL6Zb64ZXZWqneLEjmDN91Cix8OA5RHvBC4xVU80o3WgH6CB/vCl+H7KMCGxPOECbx2BovcQWEjeTErZ7CyENLrnQ2OWDDMUcKaskDcfBItq4n1e15+7Z90WxS6jWoOu9GwsmJgf6yIjFRamaknXI6S+fGyqX4ixjNLO+FPgaPnrPE5ANLPfBdp0LltZUaWxozbt0X3e/9w1eK0iO3aRxNk4eI+7lukCSCDtd5zK9QW+Q2nOJEljBw70rKQWn6VL874AcFJHFnwWyw1wjEonaTAM6Cr9ad+IbgYMKHaKHwoB6r8Q87YHsTq6ULKDOwx5HCL7Q8JRGOQgQnpELx8dHL+P8Cl2qILreKBmdIzpSRmIVAnfac+s57FJNQfLYd6Rb2FH0FdesO7JIG/9YhVyoqsIxOveL9/bs9c
 Ph0WSJgX
 PzFlm40TCGE7qaQdmDdZXVftNG01b/t0prNISiA8/nyvKq1m822HSBNKvaxcYILblEgZcfwV9RS0/poputWntq4K2bOnqFy7I7Yrx0Edbqr95E+Vb9wjsr7U36PEddaKGjZGbRvKrHQeZNHxq7x2YMCAicjKtkJK4qj/wN4t6mVmqHAl0U+VJCEt4cL4u5s8yzxxQP5rTIivV5OPoLsQQJL6LeOtaSPA2744bO7VebFAXnyjZ0EFNbZ27s2YzrtLMvemiLub7wUozmPLPt0bxc/13R08mysFrbyJHC0dOPQjJFqCqufv/JyDFRRLvlU0zJOFVsdynm/MIyTcZgkw7YSMbFuffczylR2FX+1IU9394Roo3Mu2O/VgpR5DfT1kGFwCwuiNP80ybZ4vXIVthXPSwzjC+RaUaJvJgwQPCFAvYB5VrfeAenpLCLhXHjHND8hPZM3zPQnTPHyJ8pkwLspTzyVuU010BXZIOnsXYs2X/KhPXPooYlMRV3cz82D3pGgIZaH+HiiijJ4vLG9QoDPy3UAsuv4PRirBsszqKgE3J6dkXajrq8puVg9MZ0TyIt1gOayrFVCZFv8H1jJosRnaFOfXSZY5EkBk2gF1OL4JAZE91ZilpUvMSJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the core runtime implementation for KFuzzTest. This includes the
module initialization, and the logic for receiving and processing
user-provided inputs through debugfs.

On module load, the framework discovers all of the simple test targets
(FUZZ_TEST_SIMPLE) by iterating over the .kfuzztest_simple_target
section, creating a corresponding debugfs directory with a write-only
'input_simple' file for each of them.

Writing to an 'input_simple' file triggers the following fuzzing
sequence:
1. The binary input is allocated and copied from userspace into a
   kernel buffer.
2. The buffer and its length are passed immediately to the user-defined
   test logic.
3. The kernel is tainted with TAINT_TEST to indicate that untrusted input
   has been fed directly to the internal kernel functions.

This lightweight implementation relies on the caller (e.g., a fuzzer or
script) to provide raw binary data that the target function can process.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

---
PR v4:
- Remove parsing, relocation, and KASAN poisoning logic to support the
  move to a simple-only design.
- Remove the '_config' debugfs directory and associated state tracking
  (minimum alignment, invocation counts) to reduce complexity.
- Enforce zero offset in `kfuzztest_write_cb_common` to ensure inputs
  are passed down as single, contiguous blocks.
PR v3:
- Handle FUZZ_TEST_SIMPLE targets by creating a write-only
  'input_simple' under the fuzz target's directory.
- Add implementation for `kfuzztest_write_input_cb`.
PR v2:
- Fix build issues identified by the kernel test robot <lkp@intel.com>.
- Address some nits pointed out by Alexander Potapenko.
PR v1:
- Update kfuzztest/parse.c interfaces to take `unsigned char *` instead
  of `void *`, reducing the number of pointer casts.
- Expose minimum region alignment via a new debugfs file.
- Expose number of successful invocations via a new debugfs file.
- Refactor module init function, add _config directory with entries
  containing KFuzzTest state information.
- Account for kasan_poison_range() return value in input parsing logic.
- Validate alignment of payload end.
- Move static sizeof assertions into /lib/kfuzztest/main.c.
- Remove the taint in kfuzztest/main.c. We instead taint the kernel as
  soon as a fuzz test is invoked for the first time, which is done in
  the primary FUZZ_TEST macro.
RFC v2:
- The module's init function now taints the kernel with TAINT_TEST.
---
---
 lib/Makefile           |   2 +
 lib/kfuzztest/Makefile |   4 ++
 lib/kfuzztest/input.c  |  47 ++++++++++++++
 lib/kfuzztest/main.c   | 142 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 195 insertions(+)
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/input.c
 create mode 100644 lib/kfuzztest/main.c

diff --git a/lib/Makefile b/lib/Makefile
index 392ff808c9b9..02789bf88499 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -325,6 +325,8 @@ obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
 obj-$(CONFIG_OBJAGG) += objagg.o
 
+obj-$(CONFIG_KFUZZTEST) += kfuzztest/
+
 # pldmfw library
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
diff --git a/lib/kfuzztest/Makefile b/lib/kfuzztest/Makefile
new file mode 100644
index 000000000000..3cf5da5597a4
--- /dev/null
+++ b/lib/kfuzztest/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KFUZZTEST) += kfuzztest.o
+kfuzztest-objs := main.o input.o
diff --git a/lib/kfuzztest/input.c b/lib/kfuzztest/input.c
new file mode 100644
index 000000000000..aae966ea76b3
--- /dev/null
+++ b/lib/kfuzztest/input.c
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KFuzzTest input handling.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/kfuzztest.h>
+
+int kfuzztest_write_cb_common(struct file *filp, const char __user *buf, size_t len, loff_t *off, void **test_buffer)
+{
+	void *buffer;
+	ssize_t ret;
+
+	/*
+	 * Enforce a zero-offset to ensure that all data is passed down in a
+	 * single contiguous blob and not fragmented across multiple write
+	 * system calls.
+	 */
+	if (*off)
+		return -EINVAL;
+
+	/*
+	 * Taint the kernel on the first fuzzing invocation. The debugfs
+	 * interface provides a high-risk entry point for userspace to
+	 * call kernel functions with untrusted input.
+	 */
+	if (!test_taint(TAINT_TEST))
+		add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
+
+	if (len > KFUZZTEST_MAX_INPUT_SIZE) {
+		pr_warn("kfuzztest: user input of size %zu is too large", len);
+		return -EINVAL;
+	}
+
+	buffer = kzalloc(len, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	ret = simple_write_to_buffer(buffer, len, off, buf, len);
+	if (ret != len) {
+		kfree(buffer);
+		return -EFAULT;
+	}
+
+	*test_buffer = buffer;
+	return 0;
+}
diff --git a/lib/kfuzztest/main.c b/lib/kfuzztest/main.c
new file mode 100644
index 000000000000..40a9e56c81ad
--- /dev/null
+++ b/lib/kfuzztest/main.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KFuzzTest core module initialization and debugfs interface.
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/atomic.h>
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/kasan.h>
+#include <linux/kfuzztest.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ethan Graham <ethan.w.s.graham@gmail.com>");
+MODULE_DESCRIPTION("Kernel Fuzz Testing Framework (KFuzzTest)");
+
+extern const struct kfuzztest_simple_target __kfuzztest_simple_targets_start[];
+extern const struct kfuzztest_simple_target __kfuzztest_simple_targets_end[];
+
+struct target_fops {
+	struct file_operations target_simple;
+};
+
+/**
+ * struct kfuzztest_state - global state for the KFuzzTest module
+ *
+ * @kfuzztest_dir: The root debugfs directory, /sys/kernel/debug/kfuzztest/.
+ * @num_targets: number of registered targets.
+ * @target_fops: array of file operations for each registered target.
+ */
+struct kfuzztest_state {
+	struct dentry *kfuzztest_dir;
+	struct target_fops *target_fops;
+	size_t num_targets;
+};
+
+static struct kfuzztest_state state;
+
+static void cleanup_kfuzztest_state(struct kfuzztest_state *st)
+{
+	debugfs_remove_recursive(st->kfuzztest_dir);
+	st->num_targets = 0;
+	kfree(st->target_fops);
+	st->target_fops = NULL;
+}
+
+static const umode_t KFUZZTEST_INPUT_PERMS = 0222;
+
+static int initialize_target_dir(struct kfuzztest_state *st, const struct kfuzztest_simple_target *targ,
+				 struct target_fops *fops)
+{
+	struct dentry *dir, *input_simple;
+	int err = 0;
+
+	dir = debugfs_create_dir(targ->name, st->kfuzztest_dir);
+	if (!dir)
+		err = -ENOMEM;
+	else if (IS_ERR(dir))
+		err = PTR_ERR(dir);
+	if (err) {
+		pr_info("kfuzztest: failed to create /kfuzztest/%s dir", targ->name);
+		goto out;
+	}
+
+	input_simple = debugfs_create_file("input_simple", KFUZZTEST_INPUT_PERMS, dir, NULL, &fops->target_simple);
+	if (!input_simple)
+		err = -ENOMEM;
+	else if (IS_ERR(input_simple))
+		err = PTR_ERR(input_simple);
+	if (err)
+		pr_info("kfuzztest: failed to create /kfuzztest/%s/input_simple", targ->name);
+out:
+	return err;
+}
+
+/**
+ * kfuzztest_init - initializes the debug filesystem for KFuzzTest
+ *
+ * Each registered target in the ".kfuzztest_simple_target" section gets its own
+ * subdirectory under "/sys/kernel/debug/kfuzztest/<test-name>" containing one
+ * write-only "input_simple" file used for receiving binary inputs from
+ * userspace.
+ *
+ * @return 0 on success or an error
+ */
+static int __init kfuzztest_init(void)
+{
+	const struct kfuzztest_simple_target *targ;
+	int err = 0;
+	int i = 0;
+
+	state.num_targets = __kfuzztest_simple_targets_end - __kfuzztest_simple_targets_start;
+	state.target_fops = kzalloc(sizeof(struct target_fops) * state.num_targets, GFP_KERNEL);
+	if (!state.target_fops)
+		return -ENOMEM;
+
+	/* Create the main "kfuzztest" directory in /sys/kernel/debug. */
+	state.kfuzztest_dir = debugfs_create_dir("kfuzztest", NULL);
+	if (!state.kfuzztest_dir) {
+		pr_warn("kfuzztest: could not create 'kfuzztest' debugfs directory");
+		return -ENOMEM;
+	}
+	if (IS_ERR(state.kfuzztest_dir)) {
+		pr_warn("kfuzztest: could not create 'kfuzztest' debugfs directory");
+		err = PTR_ERR(state.kfuzztest_dir);
+		state.kfuzztest_dir = NULL;
+		return err;
+	}
+
+	for (targ = __kfuzztest_simple_targets_start; targ < __kfuzztest_simple_targets_end; targ++, i++) {
+		state.target_fops[i].target_simple = (struct file_operations){
+			.owner = THIS_MODULE,
+			.write = targ->write_input_cb,
+		};
+		err = initialize_target_dir(&state, targ, &state.target_fops[i]);
+		/*
+		 * Bail out if a single target fails to initialize. This avoids
+		 * partial setup, and a failure here likely indicates an issue
+		 * with debugfs.
+		 */
+		if (err)
+			goto cleanup_failure;
+		pr_info("kfuzztest: registered target %s", targ->name);
+	}
+	return 0;
+
+cleanup_failure:
+	cleanup_kfuzztest_state(&state);
+	return err;
+}
+
+static void __exit kfuzztest_exit(void)
+{
+	pr_info("kfuzztest: exiting");
+	cleanup_kfuzztest_state(&state);
+}
+
+module_init(kfuzztest_init);
+module_exit(kfuzztest_exit);
-- 
2.51.0


