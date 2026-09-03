Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF2C1C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146AF6B009B; Thu,  3 Sep 2026 16:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11EAE6B009D; Thu,  3 Sep 2026 16:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01036B009E; Thu,  3 Sep 2026 16:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0BEC6B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:37:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCC76120616
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:38 +0000 (UTC)
X-FDA: 85173611796.01.7A60833
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 279F640008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PYMOxd0s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JG5wHGxobGMru3PHPCCaPFK+av72ZMxaO+XhGsfKu1Y=;
	b=ilyqVg511GHFPpmn44zp2I+kBpxIlQVYCT6nEeuA1lBJAi32o8lDtNaO56d0shGCDrI20o
	IupDEeEHAbffzEeU2o5n1Oj13mvHD9AAVU/4kzM1vCmNDgf5l9NqzciL7uBvLgXTIYR4br
	LpVvDK4BIPKdPoC7yaz16BzYJs+DrUg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PYMOxd0s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467857;
	b=6WLAD8SkMo/XmI5RBEFZmBTKfQosVQw0S6eL4yTqwAfWIdqAbU2Tg3ia19oifkX+x00fot
	BY3IT36d/rmA63TdUcHiOw9m5GZP2zUsOkuPyWeTL3smIyHdSKKvKPLJKuDEmSg1ZZUqPb
	WzCSCnRr3GkJIqDmEjdQk5vK8GT5YcI=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47fe89fb333so216521f8f.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 13:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788467856; x=1789072656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JG5wHGxobGMru3PHPCCaPFK+av72ZMxaO+XhGsfKu1Y=;
        b=PYMOxd0s3KWz1VWpUSTx/hvOMmZA/JqhGmM5n52lqr/ij8gt91aQL/ATitY0W4Hwhb
         wdCUcE9bYubnufPBKTeNq4GnOAVNe+HMJkLkCEzNfDWqaVfxmJEPxICg0b+1M1EGQ0jR
         qYcvK3wMJ54hkPBcXobGIZHJykXTQc4YjprTuisY2DLnDiOUgNIBkZOVRvEf4hobqpfR
         2UZa0nSpcayFDIGxJEMtcm0nmcO1dC2PfDYAVJFPrtUwYihcfPR8TiZ+3bGDGB/j//s+
         ax09Kb82xdvK/JA/HPlTvuy7zqHHoj10P9rXqdl623X84vcgHCxhvFiUUFgy1kLxKXyD
         e4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467856; x=1789072656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JG5wHGxobGMru3PHPCCaPFK+av72ZMxaO+XhGsfKu1Y=;
        b=I22pqWliE7O9+EXmErc7k6QyXW0BA43hy+foYDPcWIEoOsKwuwllOer02qD16PvUMn
         HDzCWOKimko05gB7IMob3OPQ4Q6tYMok757M+5pxpleD58gckWUpf42idydYjLFNfhwz
         kR5IKLAjOQ4Cq4KGRGqGY5QasXG1C4J7JlXKJ4JJ50ZwrvOxWhPe1oi9b0lUJJJNjiWN
         6wjy/mw5Lfl5DxQUEyiESJJ4A4fn2PYSPHJZ+nuXlwaBhWMfqkzLYpWmqFmv97uylAAy
         ykTJcdd9cSUU/yUJxgp6SJnMJR+gkSWgYKPF2UeWhbG/CG/l2eL8OZ/bqHZmUcjSgm+o
         G5kg==
X-Forwarded-Encrypted: i=1; AKwUvBzSGKeDB0+ZWHe+FCNUUNt87VhQVH/4hO62YHeJGhOVsYFkaxV9DYX1vDL4mfgrM0FgcAwFpmDEtQ==@kvack.org
X-Gm-Message-State: AFuF++lhvi08wkYVfK2BaRsidOCsgrpKwslWojvlNDzAq64Gupqdr4MO
	TrFaoZBO50HIbM5NiCkr8mRFDSElLkBwjJm7KraD5gMjUjKsfgXK9Okr
X-Gm-Gg: AYBFou1u5w1blbfqMV9ruMQVo6LAKSGs+9EIau3PLSSqGWx1BLPHqJnylpwIkCrXVWW
	/h2Ny0K5cBq2fnbQa21+tpScEBDnwnqXHFHgKREpf3lB9H17KJbaxHvHPJSFMnCrz/iiYIdJMMi
	QTRIKU0Myl45Z7ODfJODchExyAks/IrmWB82bJ6ldxVMeskiwJKfCm93z7VqHnbdVcBtfh2dgWA
	PjdJMOJD/FqiHHV1+5+Gvcef6xiMwCOBgn02CxMF4XEceEhvKEorTYfvHBOBMVg6k0hi1T9DUYw
	DZyqqK23584t9OuB32xQwsmjXhS5tFHEANkvmjWgG7hISDNKGXaQcijf5QcP2MDkULerzOS9XwQ
	mxPVrSCLpBSXs02Bq/JFYlaWxmHXRl5H550BWzOPy1zoP6NTv96FTO8FP/uSBiF72XIjrAlwrH3
	pAlfBniKpJo/eqw/Y/9hVm+pUo4Ym/ciPJdkFrbnVG/ti0ZFuDWc5kfc8RRjxCWal0BAEcjxIHO
	J2CP4rXlO6dB5sX6yO6RfQcZ2UNd9V+K66ZLFARvrdcMrQpjpI6awSnkxWvIjJ2IqSemiWqsWUL
	erIaeEVxSIhQ6r8PWDUKPM7fGOJ+AE/FwE1x3dhohtocoie91lninWAJ5nDi0hKmRg1iTQxsZJi
	SZAxD
X-Received: by 2002:a05:6000:4b0f:b0:484:3647:d977 with SMTP id ffacd0b85a97d-485872df445mr2610818f8f.27.1788467855677;
        Thu, 03 Sep 2026 13:37:35 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a979-9501-3df6-d7fa-8a5a-06c5.310.pool.telefonica.de. [2a02:3100:a979:9501:3df6:d7fa:8a5a:6c5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm1005070f8f.8.2026.09.03.13.37.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 13:37:35 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 5/5] slab: test ERR_PTR handling in kfree and hardened usercopy
Date: Thu,  3 Sep 2026 22:37:20 +0200
Message-Id: <20260903203720.63689-6-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260903203720.63689-1-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 316omkozbacchaimrrx6ubsy7zet1jar
X-Rspamd-Queue-Id: 279F640008
X-HE-Tag: 1788467856-724610
X-HE-Meta: U2FsdGVkX1/qHICHjMEfef17BQ/+vfsa9rhWgTIrfA0woSnnFFjktgLu3dFYHZ2332zsGZaTmUlD7Ey+cQxZM5JASJhE+oKbcSqoVg/1UIjZ0f+eWm4MZhxxfW7DVHJ3Tk/erYVed05Vx51MYBbOY5NOCGmjyBsTGsRd035kAh+wajnn6b4zXuULUr/rz2aRhOvsKdLiGfSlrNfs6eYPSaoV+An2xVN1HQQ7oqi4os9zCk21OtSq4LJtirsu6IKNxGRCVtuSKg9PwWea5k2SftvS467layTGqdsmovSkpvos5EpJ4qWs+VYXb0/wHBvol1z/mxM1nGYFFEcBWXd0QTaqdnkVOiS1NV8npfieIN0kyUeUTprv2OnrwCJIb1eTnYE9dvIkXiv5jZbFo5i1annhzLsR4xhgpE2ap+YHiCrxiexR6sE+7xz/eehpQUxOQLS6W1lRmuuHTJcJma3T/7xJCcuBIyL2qJgj3P2uFIbfyPdAESk2tfwplqYTnO0vFeVEVSXkpw/16iZyc3tGA/JnAgE+5A7GNifGdfhuYAUqFgsH7KdOvBeuYAU8Co/fWdAmKh7WC4Kf8DPWUWil1S+sT+xHt6PvMHm5spA0FECdKQ8GVlUXQNR99hQ90Z0M5/oJz0qwtozKqFJtRrVU8DXQDqogoFNUuy4ta9FiWrIPlBs0y26i7T5IrADRnHyCjl84mOFvs0g+3z375tInGt+h4dvFw1uBiFC7fTGP9y0XR1u7ZiRcwe8InsG2imEK2gtUo+gTJUlHgNdjId9ztU2ifDSlFsqwZovVJkdodDKwlLOtu3cFt3w/I1/royHtOHmXFZ+oCE0jT/6kbhdmF5sH/vW141IzQl6iwUfBE31GLXBihXmblcNjkId4FxCH+2WXmiUgaxdlYWp+bwbA2AkRc+h/4l9saeXobdeN/oVm+AKBZCUJfbntBiqkNJ3MqwmrspGPzVZ13FaeNSP
 RAR+0Uo2
 gviFGkfjlvL5R5RgcFN2PFRSnCdQQIWRVBYds9XTaAwRRN6fyjX1qFQ3ZiG9eUA38xUW5u6BPhRNxZD1H5WEpkJMxGWBcwQEDDW/VaGRfUK3KpzMiEuCmdyiQLoTP39K31kEwb4729U8Jxd/vb1w9cIivshsRowO//3+2u9ijhAhClsIpPgkHFPMLNXPlxm6qFNXJ3+p+70lXcgTrhg2ZXgxgRAXxUC+SxLncG77Lqp8TSB30igOCBsxf6V95vBVIL29qkmPZGZPuyjodlQstTVxdf/xCnQ6VhWLgUNEYtwT4oKV1QWsjUsHxr9zEUb1jEaV0AQ7Xpo4W9N2qCL0r9S4ijyfvikz/ODmNSSJXd5MFy80Mler4Fti7lijHoma+DS8SHTwbjcZpH8BldaKSgnYXTNr1UVtkD9yFj3maPmT5pkLVl9v1ngmJ7noH66yUNJaz9FGyx4jnpEAz9roeiLuJKSBCbLbrhFwMGcMOygv7oxsfksOW7VYCEEW8GbrnWMyZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add KUnit coverage that kfree() warns and returns for ERR_PTR values
while remaining silent for NULL and ZERO_SIZE_PTR.

Add an LKDTM test that verifies hardened usercopy rejects an ERR_PTR
before attempting the copy.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/misc/lkdtm/usercopy.c           | 27 +++++++++++++++++++++++++
 lib/tests/slub_kunit.c                  | 18 +++++++++++++++++
 tools/testing/selftests/lkdtm/tests.txt |  1 +
 3 files changed, 46 insertions(+)

diff --git a/drivers/misc/lkdtm/usercopy.c b/drivers/misc/lkdtm/usercopy.c
index 67db57249a34..10751e48211f 100644
--- a/drivers/misc/lkdtm/usercopy.c
+++ b/drivers/misc/lkdtm/usercopy.c
@@ -4,6 +4,7 @@
  * hardening.
  */
 #include "lkdtm.h"
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
@@ -273,6 +274,31 @@ static void do_usercopy_slab_whitelist(bool to_user)
 }
 
 /* Callable tests. */
+static void lkdtm_USERCOPY_ERR_PTR(void)
+{
+	unsigned long user_addr;
+	size_t size = unconst + 1;
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+			    PROT_READ | PROT_WRITE,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory\n");
+		return;
+	}
+
+	pr_info("attempting bad one-byte copy_to_user() from ERR_PTR\n");
+	if (copy_to_user((void __user *)user_addr, ERR_PTR(-EINVAL), size)) {
+		pr_warn("copy_to_user failed, but lacked Oops\n");
+		goto free_user;
+	}
+	pr_err("FAIL: ERR_PTR usercopy not detected!\n");
+	pr_expected_config_param(CONFIG_HARDENED_USERCOPY, "hardened_usercopy");
+
+free_user:
+	vm_munmap(user_addr, PAGE_SIZE);
+}
+
 static void lkdtm_USERCOPY_SLAB_SIZE_TO(void)
 {
 	do_usercopy_slab_size(true);
@@ -439,6 +465,7 @@ void __exit lkdtm_usercopy_exit(void)
 }
 
 static struct crashtype crashtypes[] = {
+	CRASHTYPE(USERCOPY_ERR_PTR),
 	CRASHTYPE(USERCOPY_SLAB_SIZE_TO),
 	CRASHTYPE(USERCOPY_SLAB_SIZE_FROM),
 	CRASHTYPE(USERCOPY_SLAB_WHITELIST_TO),
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 923d8646bca1..079563387007 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -507,6 +507,23 @@ static void test_zero_size_alloc(struct kunit *test)
 	kvfree(ZERO_SIZE_PTR);
 }
 
+static void test_kfree_err_ptr(struct kunit *test)
+{
+	if (!IS_ENABLED(CONFIG_BUG))
+		kunit_skip(test, "requires CONFIG_BUG");
+
+	kunit_warning_suppress(test) {
+		kfree(NULL);
+		KUNIT_EXPECT_SUPPRESSED_WARNING_COUNT(test, 0);
+
+		kfree(ZERO_SIZE_PTR);
+		KUNIT_EXPECT_SUPPRESSED_WARNING_COUNT(test, 0);
+
+		kfree(ERR_PTR(-EINVAL));
+		KUNIT_EXPECT_SUPPRESSED_WARNING_COUNT(test, 1);
+	}
+}
+
 static int test_init(struct kunit *test)
 {
 	slab_errors = 0;
@@ -532,6 +549,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
 	KUNIT_CASE(test_zero_size_alloc),
+	KUNIT_CASE(test_kfree_err_ptr),
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index bec57a02913a..d3e38c1c75cd 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -70,6 +70,7 @@ REFCOUNT_DEC_AND_TEST_SATURATED Saturation detected: still saturated
 REFCOUNT_SUB_AND_TEST_SATURATED Saturation detected: still saturated
 #REFCOUNT_TIMING timing only
 #ATOMIC_TIMING timing only
+USERCOPY_ERR_PTR Kernel memory exposure attempt detected from ERR_PTR
 USERCOPY_SLAB_SIZE_TO
 USERCOPY_SLAB_SIZE_FROM
 USERCOPY_SLAB_WHITELIST_TO
-- 
2.53.0


