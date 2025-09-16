Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5CACAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980328E0018; Tue, 16 Sep 2025 05:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9300C8E0001; Tue, 16 Sep 2025 05:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784488E0018; Tue, 16 Sep 2025 05:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9748E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28B66C0937
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:33 +0000 (UTC)
X-FDA: 83894520066.15.44BF05A
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3891210001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IUNvPvwy;
	spf=pass (imf05.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54a6vrNAUJqXpuCeRFEgTKA2RP5sTalC0x0PuLBwSM4=;
	b=HaF2qTeactkaoaRfED9PovBJPivdEFNVcoXJBLaWfRoRyarZ6+mdWBfwlXz3dfiXSqIcAf
	LLzup94PggNLqVzW8ttsxyvxD5QJfgufi4ENKz550wJrx3y4F2QBAvM0/v0l3Da0oPP5O1
	U5Y5f6BpzEsy3xMMF3Kon5esnS/GUUM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IUNvPvwy;
	spf=pass (imf05.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013291; a=rsa-sha256;
	cv=none;
	b=ahuzcAd9nlnJAREQG1zyGTwICF4fO1hUgf6MO9VO3ENUbO7CsufikpMIuhOcMDSF5BYOJj
	wQYFI877bLY1xm45Ka9dv9Vb8hqJWS967/aMIXDOXiwgICCB3d3sVr1tC7bT96ka5N9JQM
	6uECBMLxhzyrGRJQOTJvwsyzHTZJHCg=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45f2c9799a3so13442725e9.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013290; x=1758618090; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54a6vrNAUJqXpuCeRFEgTKA2RP5sTalC0x0PuLBwSM4=;
        b=IUNvPvwyP+Mo832rtnXHTwKv9+OGgEmAWiUQ1kGrACM+4lKFCNzDP32cWzuG85yS+k
         VoOeTttXRPeYdL+FzoXAhWu/NqH2TVpR5Ov35+7QRjykFfxyIEPEIm5aqxHgVl7uKiFO
         SMwOcVfejhJYuCo6wsb632ps+9F1vmTyswDSqp/okTn4XDKxlI0W1O+Pm5848MVuZ4Hd
         EC1ssMYxWE2ykp7SIrmiXQAplOapcTpzQq2zcLz7Nh60FK3shHKfj2mmCG+ULuAUKbpo
         Hc1AKIBkojG6jl8w5PCMopFSBOY570DFSK8uvHcV+ijZTBSbW6yo8dRZFV9LaNw1bcgp
         0JzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013290; x=1758618090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=54a6vrNAUJqXpuCeRFEgTKA2RP5sTalC0x0PuLBwSM4=;
        b=oZFkyjJZDrKKyks0YlzpEmnGpZZRB+fSVWfiy2aaCZaICagEXyNTBlk8ycu5iACdIM
         qyEbMEzZGGeJJG0m1y9qQ5FbGGUaMBgdVz8IHeMmlDv6L3/mf9LPU3xeG9VXeihcuebr
         l2Y2PZpr9sP8yMPyUGPPdSzQZ3w79yieKLAQA+kKiPbaNKHV4Y1YuylwVYpM8OOkNZu5
         8pc1E1YTOM3dN93vVTOLLU1rMJG3DeSrM6beJadF3oSWUSNWM/QxGWHqIIr4Gm4FZkRK
         XeJhXy/hocebn3TV0t7QXf0jv/JD1U86VPD106uWSmSp/K97xjSjlgN59GSi/PkTpkpG
         eKYA==
X-Forwarded-Encrypted: i=1; AJvYcCVlR7J9wjyGrHggyAnE3ZTIdmbGt0k6fbE6g2d+P2EGN1joEQpM89GV2+V1rsFmb8UmePXnYXLtgA==@kvack.org
X-Gm-Message-State: AOJu0YwzxMOtvpe+eLnPwd9nLnw/77ox+L+XwyWTJtMu9ASyIKcw05qm
	Xw4TABMq91OAEDAje+XghEpRnNoOXOd3C8jAjpvoGxSQNDq4Dn+pM+3J
X-Gm-Gg: ASbGnct4n40GOH0JC7GD3uDZ6VAQjxVgENWuDzjbjwvrR0qoZrjsBkihEShwVf8nF2x
	F3rBnHcw47F0W2/E8KecjQXMByjGyRRc1n0rg7GzRRpp0xFqUKqyKVk5yT/oq2J/qL5UNJe3tAS
	h3tFb/hDqk+OvhUqijavnznn0WWysidWNml2CZzfw5c7ruBJw3lcqoacYFsYgO7bxH4zJwGhbaO
	Ouej0v1sm/PqPDBomDZj4E1aasWCQ49dPGuGrxAaefkxTfx/inCXnfLyKR41hOb2ISTUDOByBRv
	ZcTJKl+cnUrbS49XBhI6Q5Bzo4j6F7J0SFCHiBdX7oljjopQMN7e4NyvjCy/3SnEUm7biPZ2UdJ
	H3t8VhTnIkWi8nOSBWd8lA5o33wy9HpycYRqb+WvCorI86NvZftnKk1q84WjfmrIRaqoccXF9cf
	HSmJfdEO+6WS6B
X-Google-Smtp-Source: AGHT+IGQ/nVkVKJ3q2nqGsYpu+DG+PZAA8Y4Ac4hVZt9d7cPYhzkDVimhmHreOcxPfvEMqJ6F549CQ==
X-Received: by 2002:a05:600c:4446:b0:45d:f7e4:bf61 with SMTP id 5b1f17b1804b1-45f27ceb2f2mr101342565e9.4.1758013289608;
        Tue, 16 Sep 2025 02:01:29 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:28 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
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
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v1 09/10] fs/binfmt_script: add KFuzzTest target for load_script
Date: Tue, 16 Sep 2025 09:01:08 +0000
Message-ID: <20250916090109.91132-10-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3891210001A
X-Stat-Signature: a1c87n5eddxjihsxnf9syztatia3qtm6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758013290-56554
X-HE-Meta: U2FsdGVkX1+JfafUkQMPTaVi7CZzCvi8Vpr+yAyAGcULGhNuXDzOfEc31K1mMw+cqXJGwh0vBf7me9vV+5YxiwFeg3gve3rs8wFbQ0K+b8+sK3ax3leWDI0yZZbulTZ/Ptv+djpmVVKFAjzUZYtu4RXuz3+ar9A8i+WeiQBTqO2e/LDVI3fZm+ZbSpFzWAHMa72st55PXSOoWoMdAkve6WYHciip2M94FAxc42D8bnh2pYvjOwTa3aaQWYu0LnTuzKur9p594qFoeEud1YBizg7+2JeM26AJc84JxivUvLGEDOJ1ZtdM/Yy2ifrYDVFUwGkHJhlvmBQqeNn8/uFe7GF5j4gdpc+HUxxq1fn7m8l9/VLwFSCfH2RPrbV703EycsYNBak+IX9WPSUfMaOduEwcVyelkfp3cCpHMLVHXGdwgAI7S3CCrLY8KgZdYEzXYQlsVndww6tl4rnQDcLONwp/Etb8+g1AjDzias5PlKMnw0DS3sS2Xa9NTKbgbDdqLYg9N/W4DCDJWNthMCAeYQSSXywY6L6Ir3pX0GJflkeyKeWZfbLp2mvrto55nDofjFp9zMggu3d8vtEMnmfKOZQ2NrHp4BRGos8Z8QPMHYeEwrYAjqf+f7NKJRh+eOjKSUJthQCO7IhuEJPAmxiMWhqd7M2HukOyIqcXfivNjyvogP9CrNZ9wyUktrlKFrEvZhVt0aChV94h3+BMF43Vp1JsdQsMrcwEeeWTZCG9xGLYfXmBBaixaFJddVytnoIz3IMb2FwM6hTPgRsOjaAfJo8N6PbZVTIOlvOzfh0Rvt0UsHepQ95r+WoTK2WtSHWCgJJ09CxTGJVZSSTUU+nZCGQSxJHB65iycS058ehO3iwTp5sJ8wnL5xtdhFcYXK6f4yTUkcvllKdIpHmt4RQ1Ll3+ZEUQMYQKVMFADyzKrB4M8n72wDZrpbMbPC1dWtEL2AaKnCsKkCiFyIQM3T1
 rptiIupz
 sS1HArETBnSToyoaYnq0t88x+YB5ZeCDpqGrHlnr1vywT/JlIBAjASsZlxfdJd2/9bl0RC0WZPuWvCQGiCXcq3NfGJhfRMxlUD99aGNON64EipTlQi2KQ+EtbuEkKf4vWhTioStT9TMuR7z3a/Udj+yuIuAYX6Uf9ZxiOlYe50XRlPuxOigYgDJAHpgsE3tdW5TEo9maUS3TRVetMjGBAFeEYg/Ymc0ZIUw4HsYbrr24wSRnpD3UZNEM539WPLcSYPSnI0rKIfnOEPcnwEVVHpWw5c7sIs8ds9mLDnkfSe23AZEyoFg4OLsfrf9BcgWZ/7csnwOEUEPufirNfshq/Rq45543B3kHk42UJ75ffG8iiKtQPEsJ4FO3WvC+nxUwCvYTiIUFRcjVaRGfUr9yB3RY4pg1snJzB34POD95g/uWIEJOgSo6xXEP5wJShZ6MX58rq2//LASrxs7N/sC/R0lKUCnbkbvwZHruohWHzTI4i+MC1NhA1UFbjyEWys66g3oOSKlUcWrZIaA2O8dDb42C3/Wug5OeOb79HQDVxDS21HlNIyIjFwPLDRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add a KFuzzTest target for the load_script function to serve as a
real-world example of the framework's usage.

The load_script function is responsible for parsing the shebang line
(`#!`) of script files. This makes it an excellent candidate for
KFuzzTest, as it involves parsing user-controlled data within the
binary loading path, which is not directly exposed as a system call.

The provided fuzz target in fs/tests/binfmt_script_kfuzz.c illustrates
how to fuzz a function that requires more involved setup - here, we only
let the fuzzer generate input for the `buf` field of struct linux_bprm,
and manually set the other fields with sensible values inside of the
FUZZ_TEST body.

To demonstrate the effectiveness of the fuzz target, a buffer overflow
bug was injected in the load_script function like so:

- buf_end = bprm->buf + sizeof(bprm->buf) - 1;
+ buf_end = bprm->buf + sizeof(bprm->buf) + 1;

Which was caught in around 40 seconds by syzkaller simultaneously
fuzzing four other targets, a realistic use case where targets are
continuously fuzzed. It also requires that the fuzzer be smart enough to
generate an input starting with `#!`.

While this bug is shallow, the fact that the bug is caught quickly and
with minimal additional code can potentially be a source of confidence
when modifying existing implementations or writing new functions.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 fs/binfmt_script.c             |  8 ++++++
 fs/tests/binfmt_script_kfuzz.c | 51 ++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 fs/tests/binfmt_script_kfuzz.c

diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 637daf6e4d45..c09f224d6d7e 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -157,3 +157,11 @@ core_initcall(init_script_binfmt);
 module_exit(exit_script_binfmt);
 MODULE_DESCRIPTION("Kernel support for scripts starting with #!");
 MODULE_LICENSE("GPL");
+
+/*
+ * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to ensure
+ * that KFuzzTest targets are built.
+ */
+#ifdef CONFIG_KFUZZTEST
+#include "tests/binfmt_script_kfuzz.c"
+#endif /* CONFIG_KFUZZTEST */
diff --git a/fs/tests/binfmt_script_kfuzz.c b/fs/tests/binfmt_script_kfuzz.c
new file mode 100644
index 000000000000..9db2fb5a7f66
--- /dev/null
+++ b/fs/tests/binfmt_script_kfuzz.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * binfmt_script loader KFuzzTest target
+ *
+ * Copyright 2025 Google LLC
+ */
+#include <linux/binfmts.h>
+#include <linux/kfuzztest.h>
+#include <linux/slab.h>
+#include <linux/sched/mm.h>
+
+struct load_script_arg {
+	char buf[BINPRM_BUF_SIZE];
+};
+
+FUZZ_TEST(test_load_script, struct load_script_arg)
+{
+	struct linux_binprm bprm = {};
+	char *arg_page;
+
+	arg_page = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!arg_page)
+		return;
+
+	memcpy(bprm.buf, arg->buf, sizeof(bprm.buf));
+	/*
+	 * `load_script` calls remove_arg_zero, which expects argc != 0. A
+	 * static value of 1 is sufficient for fuzzing.
+	 */
+	bprm.argc = 1;
+	bprm.p = (unsigned long)arg_page + PAGE_SIZE;
+	bprm.filename = "fuzz_script";
+	bprm.interp = bprm.filename;
+
+	bprm.mm = mm_alloc();
+	if (!bprm.mm) {
+		free_page((unsigned long)arg_page);
+		return;
+	}
+
+	/*
+	 * Call the target function. We expect it to fail and return an error
+	 * (e.g., at open_exec), which is fine. The goal is to survive the
+	 * initial parsing logic without crashing.
+	 */
+	load_script(&bprm);
+
+	if (bprm.mm)
+		mmput(bprm.mm);
+	free_page((unsigned long)arg_page);
+}
-- 
2.51.0.384.g4c02a37b29-goog


