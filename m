Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8BFCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833C58E0016; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4818E0019; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684AF8E0016; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54BD98E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AE37BA52A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:09 +0000 (UTC)
X-FDA: 83906305098.13.A644DFD
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 675504000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mx70lslj;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LT1ydHgovraiyOIOgetbRaAa0TBzaulhkSUGdqArzzs=;
	b=xHfWfezMjUsEmJsqbINUiAwSKPTAACutah03yutAzW5MjI4BdwJHVmrTNkUU0Gvi2UHJqQ
	5XiPPMixl/Mz7b5I2hvK4kTENiRxLRmayqvxOBvJZC+VUiOIUMtZH0dppIIG1cPB+JJMu7
	AZndN2D0USGBSET71uCN12Ix8A8/eZ8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mx70lslj;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293887; a=rsa-sha256;
	cv=none;
	b=XmqLQ88DvZoAaVbfA3hni+7hmLM15BVbChcKVK1qVrHCN1k+fbWHSTXVxEkwyp4d5fL3Uh
	JSQOFC2sY4VATOUc88BHj1P+rZ1X9XWEnT6/DR14G8J99xQQpWzzSgSo7LY0Zcxus/yHSO
	CfcspRc6i0ta6CACLEOXgEkGdsIE1rY=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3eebc513678so1022014f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293886; x=1758898686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LT1ydHgovraiyOIOgetbRaAa0TBzaulhkSUGdqArzzs=;
        b=mx70lsljt3z3Tbg4GuN7gi6J5dRtnB8FOR1H4KV+N75fFKUncqvBvKIA1yt5BBUmAj
         XM9fdyS5vWRQwZRA/mtotGH9XwVBd3m5MtlsOEEEFHtRWpvbNDNNWAdpfEhFcTyLVxQa
         Q68liqnWUmWphLo+ZSiNWkxCg5BRrrooyA7KWGNtZWbjyhoHqBQFtiUjxjXkbfme65kb
         FUs6m9/gevypwiyO1aj1JK7LIyFDPElaNzNEHaR4PMxCADZtVL9ZuceLannxhksV7iD5
         qQ0tklAuFwOXTyN+c8HxRk5Con0mvVJzuNJ5agKhnyzlcXPEipiRgXt+1YBd1EhMc0xk
         UWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293886; x=1758898686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LT1ydHgovraiyOIOgetbRaAa0TBzaulhkSUGdqArzzs=;
        b=eQa93ZKVAvz+4PZz3dTEfJexB9t6w8szzjSVHK4j4h9x2nNA62wtRkpqhvdr/bFhCW
         lQwKVscECn+ZwrEvsGJpdoR4pwO8ybGaLBtaSf7oyTEa8jB9ucjauu2kyeHDj6IAf+AH
         bHD3099hB0yb30Xi995cJ7xpdThhMt1FVzy7Npi/ATLPqd8qWtvJh4OqH879R5RzyWm0
         sxv5ix3xbYEttn+xbkK2MYEyJIDRyf+19Zvkdfv9ic9e9IostwAN3vdh73PFFxmXHQ6r
         7opAZ0T2Pryy8OSTHH1jVE2eD0UPaXyYxXCacrPtA9ab9koincWOCRO/t5LFT19oPrtD
         rD5w==
X-Forwarded-Encrypted: i=1; AJvYcCUaNmcQYG/uBov+ccO/WJGiagan/c6HDG8HmdmSfP2J5hyaJOSdJyK+/lJHlb3Qbpz4wCDmZggsig==@kvack.org
X-Gm-Message-State: AOJu0YxXnD/Q2ahIuK2KOVXescspgo7jdV50vl+uAggRjgZGCD5xYSZ4
	Ad1I0icWv8Oa8U3PeATZXiqMPdGVAnYtGJ8bG4i/grC71RoPhU2HP+ok
X-Gm-Gg: ASbGncuwDwKOAgH4sjBR+tRj+0cG6iE94YO7o5r7TWmWTYKEY2JTmq6hTehI+L6Wwpw
	yaYkXrnMY4Xa5e78IUWwCKmJ/QtBQ3Bjv8cmdDBhpyB2kWv2HT+Fw8GiSM1NjXcHAndka6nPblB
	VioOIpRT90NNLnFntM7Jk5kfYe2SpaxxMPSvZLb6sYv8WL5rufEeEkIoDABCpxT11FsEA+J45k+
	2TJh3qW6m0Cura0k/C34h9MpAWkrUMR15uutulV6M5c3HY8fHzShONAz2xijx1a+opB5AIZ17z6
	YozVigV8o28zDZAbQGJDP0c7L9FPmr1gLG6TpB082PQ+2fAEBRhzNDiRR6yKn1TqQVkuPopIVkl
	nhF3EwBQm2q7ZRns1vU8GHXARnkIpzBPIGV7SKKGggMqAPTqi53O9PqQ1Ggjb/O9+jOBsWuHsm8
	4TMjm/bQmRYQ/oefo=
X-Google-Smtp-Source: AGHT+IHfk6FVy/mkcxlh5PwT7Aua9hjkv4iEAL059Dub4DeP/hMzVm4A59PgONlD461DIHsT16Nu4w==
X-Received: by 2002:a05:6000:144f:b0:3ee:1357:e191 with SMTP id ffacd0b85a97d-3ee8407d5ecmr2286466f8f.30.1758293885827;
        Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:58:05 -0700 (PDT)
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
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 09/10] fs/binfmt_script: add KFuzzTest target for load_script
Date: Fri, 19 Sep 2025 14:57:49 +0000
Message-ID: <20250919145750.3448393-10-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 675504000A
X-Stat-Signature: gizb1xau3je1rqb7u1w69eojmf79ampe
X-HE-Tag: 1758293887-915983
X-HE-Meta: U2FsdGVkX1+B0eu3NuYeQInWgXRrZcrWRplc2mhPuXJKFLVB9TMKAgX7tmm0+EI1TFS17yqeT905KSvi5lCwjfB6RnI86YS4Fn2eMahgj4khQvPJnJzlkvRLiTIKNDhLy+iPtzF5p898rMI6MLJJD2UKbsfQfKoxtUfMkqPtDzadkjN3nCFcB/wQ7BGF+hrfnFTPxO5zuRp+YMSX1kyJ9ZGK8LG8tH5bmm3Bjf32LjNhV/n0IciZFGwbpLiUVWDooF1zIIN6xNwVGyShuVnxG1SdTkcqtynkhXbQ9ijOwM+huN5hJtCp/UR20CNG4gnoDRxFvFpyLaQuA3HfAv9XSNmqp4iY9dACe4HEiGsfDVBDmISMyuCXeMZk1BFdqLP2ezxKGqVOAoemTbzp+M5RQ+uQzwCYvKfV1KDrwGtHWafvHdvso/+6pecLb5zoLeWcM65Q+njwfh2E93ulWddDkgXWeO8Wq93ZSaMG3sUNttls6zIt1kRd4mq8tFjanwT6+l9SqeP05nLwt28n/HkOCyrRtsNUSNWXKJCk7hEuR0IIFiz2kKluD1yHkAu8dnchfFyg/v+VxQHX7O9VcVI/y+e4/xurxXeaQDTXnjCHszZLg6k6DV6g5JA4oETGHS51xScl0NqV+nkT7Q0oj3Zu0Id10ffZVR+BdZGqaVohxjKA4j9Do1gAupn+qP5kMu86nLL5dUpNA/015GGlReQ5wrCaNOkaVvWo4aknFtkPuuZ54NAYRQh53g2Ks1cxU8fEJlAjqeZJdNORoNlPyK4FuzEXMvcTFwqEIE280MAuor4Px+/X2f8qssGxDg3QJberP5E22aEIam75m4V0tLce1dM32C8IVZ7M/b1TPBk6rFwRLhmMdrFTodaWllHkz2y7iqKz39S18HPSqSwjX9xSz9P99EPNAc9GHCSWEi90M4xcQK1+ssFdK53rIV/rcrJKTi6+QdIqWAB6Y4oqraD
 f7wfcE0u
 oU/qb6fd27KbrpkPSKzAnOfqmFo3UnQyk025AeoldKPiPpAmBvkLcjmIudROUyG03gC6MirNyOQSQIELOsOzi16cZGx57x/pCxljLTDagdcYnT6BoFo1kYFJMyuNS+SCdsSykEWlXdvoWE9odcUFFAQY+VfJ3ODpDT7oX3BBH8AGe8pA=
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
PR v2:
- Introduce cleanup logic in the load_script fuzz target.
---
---
 fs/binfmt_script.c             |  8 +++++
 fs/tests/binfmt_script_kfuzz.c | 58 ++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)
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
index 000000000000..26397a465270
--- /dev/null
+++ b/fs/tests/binfmt_script_kfuzz.c
@@ -0,0 +1,58 @@
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
+	bprm.filename = kstrdup("fuzz_script", GFP_KERNEL);
+	if (!bprm.filename)
+		goto cleanup;
+	bprm.interp = kstrdup(bprm.filename, GFP_KERNEL);
+	if (!bprm.interp)
+		goto cleanup;
+
+	bprm.mm = mm_alloc();
+	if (!bprm.mm)
+		goto cleanup;
+
+	/*
+	 * Call the target function. We expect it to fail and return an error
+	 * (e.g., at open_exec), which is fine. The goal is to survive the
+	 * initial parsing logic without crashing.
+	 */
+	load_script(&bprm);
+
+cleanup:
+	if (bprm.mm)
+		mmput(bprm.mm);
+	if (bprm.interp)
+		kfree(bprm.interp);
+	if (bprm.filename)
+		kfree(bprm.filename);
+	free_page((unsigned long)arg_page);
+}
-- 
2.51.0.470.ga7dc726c21-goog


