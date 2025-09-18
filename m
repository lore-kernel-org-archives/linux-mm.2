Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E53CCAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC488E0120; Thu, 18 Sep 2025 10:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6DAB8E0112; Thu, 18 Sep 2025 10:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82D68E0120; Thu, 18 Sep 2025 10:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B69788E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50AE11401DF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:38 +0000 (UTC)
X-FDA: 83902543956.16.8FC7B5C
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 587D12000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uJ9xi06r;
	spf=pass (imf13.hostedemail.com: domain of 3rhHMaAUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3rhHMaAUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRwMz0bPjU6VOADE1reTzyKkaNRl/lw6aWShINvk68c=;
	b=z/zO3NK9Jhio/97VrJssSHwZBFUMj6bIJEDttC1g5fVxuZI48eW0jXE1AEtSgk7rAIcQku
	an/W816D2yvZiAMKOkHgLs6onrr3cTk25O3NTIAIU35Rj4sttQ8YWVjXPZLxz4bEsf5Wx4
	wSOTMo4yr9RW7zF8r0io8Tjh1jmyVds=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uJ9xi06r;
	spf=pass (imf13.hostedemail.com: domain of 3rhHMaAUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3rhHMaAUKCE8v2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204336; a=rsa-sha256;
	cv=none;
	b=mQ8e8TmC/Z4wSx+sMOfOPF32vS4OpQUFjVF0NvoUg1mMxahdEE163AorQVcqMgcaKjgVbx
	IH5jmaIT37lECI2WdmuOIrE83yemVgQ8LlfBEs7Aa/s2ygyp8pG4powo23UpRgBQ3ClwtG
	wTuHyqKkk2F4S5mwiqi36Uzo1iyXj0Q=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b07c2924d53so96075766b.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204335; x=1758809135; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GRwMz0bPjU6VOADE1reTzyKkaNRl/lw6aWShINvk68c=;
        b=uJ9xi06r3CIB8JDproVxjtEg+2VgYy1ZSfprkTph3kLziz/HGM8EydmVNeUaDYjLtp
         JB4f9QyFTXjmspmfCjseXt3t1EbSqauzs5gWmfNF8nFU9radgtVdB/c1je0iJAZa0ssI
         nQx3XiA+vYW4QKYWvD1nvFwdw0dsBlfmiv917sIW2DgxO03oBV4LukbXrc7Rz2N6L8cD
         U+qmmzP6MnL7UZPOB7nQxHYwB9VG0VuPCvEK+psNP9SKE+l7eegfL2S3oSW5YXDxlone
         4k2oLq4oDoQbqoJ8rnljqRdQzNvYWlvdubIm2VS+PCuHLL9ffgW9HqFQ6L6vFaLSCPy5
         d/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204335; x=1758809135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GRwMz0bPjU6VOADE1reTzyKkaNRl/lw6aWShINvk68c=;
        b=RCFaIiAlN/BFL7RwtHnLB1YG3f9zFbhXUqFMSo3f7wA1+sHtnKI8DneDaX2JZN0ueO
         963WJdfugof9WSKDYExVjr5RQMSuOvGzWrzKOQwpMvps69AoiMd0MQFMxCH+biMAfe9S
         XuX14VdvxF4TlwSOEQjIkv+KlMayAAxpxsSqFLDqvdBArZUkvAwXMdz6KFnM171AQRd9
         +3xQKd8fOMlJZdHRwAZAaaqFtYoImF071IdBh1tbvzzogomYG4r02oMfyxhUhSPLZGTc
         KGhs98s7Qn+paSpNfYhEGpC4pbARuxnfR4I3xsS0NY1FfCy1YpdTB1Oa8NcDD69CF+KF
         tsWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVz04xfoTeaGkq7oTqbIM69E8O5oDHqqW/I9rGgtJCJTNX7TwaldlPp/9iTFdyY8F8SYY7p4uvmEQ==@kvack.org
X-Gm-Message-State: AOJu0Yzview8YEVUp1MKBtVaV13vSvP1tDScIKhCfdtPC9bROF3EvVOu
	EaXGXUQpADW2ZBskNhVDDXjwsLSdy8HORiElcuksa1yvX6+n1PexzDzeUDV+Ln+GP5tv4Y3UONF
	qew==
X-Google-Smtp-Source: AGHT+IHNHC2FtU+Fx/5Wkbv7ZWVYfhqefeCuQqPWD0VkzesG9dShOlM75C662GySJ91SvXqJsD8LbBri2w==
X-Received: from ejctl10.prod.google.com ([2002:a17:907:c30a:b0:b0b:a3bb:15d1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:2d8d:b0:b11:3760:9596
 with SMTP id a640c23a62f3a-b1bba5d1389mr603989266b.60.1758204334564; Thu, 18
 Sep 2025 07:05:34 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:14 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-4-elver@google.com>
Subject: [PATCH v3 03/35] compiler-capability-analysis: Add test stub
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 587D12000F
X-Stat-Signature: uq85i1cw6kyjmcaq1ukxw4otdwnfwjf4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758204336-659636
X-HE-Meta: U2FsdGVkX18V93rmq4ppagBJ9h85IhTgsCC7Fvy+HFbEpJeS/1N5YduLc1NoLcl/+2HOzyrweUtosbq/IBxR2bmA3K4esae8cABlGy3Oiex2DVNKUzpDxjWTFlxzncsmRr2IKwwZ3ZKkcdGiZSYDNhpPpbEUhTBvmLHlpucW5zfxl5F9VlEFdC0fEwomQ9UO2yNCq08y77Q8XMp9oa5kdw1vPGk2Sps8vTrBlaPrhdtxC45QXLuNTe1vHMYW81OT/oWbvzb308nMAeT+e3x2VFeYnu4I8c12pDbbedh0IsZqhr06j4oBUzz/qsZuM+hTY6KDo/arVVhK7KNCv7u3vzea/nE6mpzBKaXIyYWJxTQdr4Hg0bLtbnaWhVJBYcqC2YoDjaABQ7EaJl9SEMz2norJh+Rvg+OQsnUJ2miPb80rIqGe3tBCNXP/y+25UA+sgPvihHMPJwXAAvl3bY+b8Ccsvx1OdVeDpUllr5eC292neJn4+U6IVucawxkl9EmMA2NXPNuFKCw+56llfIOn4RbWR5rR0urxznu92yrKLN5izQO6/lZAdNLYRA8rNSsCN5ah1krVel1tAEoV7zjqtIf9AuX4SURHMeHQdgVS2s03MxO/p6U3sw09Z13+CbocrP2Dpvier6ehW2KKmYln6uVgIAOKJ1SHKfEVxoGyrgUfs8Z/RPLOKc0SaRxk46rzbw1OYB9d9ZqrUxji7ztBVpcQTQ4uM87UPnzFOO7rWKpN5ScinetgrccbYR7ZrkOmGD/KheSrVF5bBYfBk2OkiSWvLpe21d2acstpNTIZh/brQMjgTMkmH0ONy2E5F3LiPaI3j/txch58/uU6AYxx+g1tgFHKQsHgM8pY8cxtkWsTdwjTGtZE/bpr/7svn3byKyCNarVzCa/NoD3Ux5yXFfzKRiL+pOjfz7/JoVSQVhrY6e/EvrGwFMS0MI96K42nlwK9xxmt5+s83TcUUYi
 kQ4ijsXf
 rSOrVpPihHBkVcR4D0fB/EEBrwEKzT2BANelz1H8qEKvAHMtAFPTdFFK6E8l5+BVcnI1N4Lf14ytXZOyHk+z3rM1EwUctRTxwOIhwLtZljwQS/z9yw2pcd7CGKIckPei7Uefn2BFG5tDhid5O/DaI3KxRGSO0fBacWEHQSoIix+9DcKZHVJTDMpACKsKM3QpIFHtHw5TgbbKkG3WFRbo5PP8nsUFmrbmSJm6ttNl9vgqi+sNdpgh0Z02sUgXuaoSmwL+9nZf5XRPd3szH/KSi769II9MP1OS58s8gKGLvzHMslYkR0dau9bS66Hxqqmz/T85D72TUiWFSKAzg/+fcrKyEKsRvrT4iRmKb/gdV5CWdkyGyxo7/ISCFBkIQ61pVPqambxD2BXzhzhaT6WUgiOuwC169Xu9l9hEsx6ogBA82cy9xA5deMO/Z6jbJuELAZAIn3VvfmhVXi/rTfz906b9EaFPv2ZGSSMnenIz7T4/mQgRFMq2leCkelxb5dL7mPCLI6S9DIQC+TXtiYAUGtPzRJBq4lAvYLlGupLMV+5/Aeq5MEUVGy7Vo/07CffEGvFrTlKl4KKkpfsDAuMvsiB9Y07ba0Cw9eFPZVUDkQkE+MnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple test stub where we will add common supported patterns that
should not generate false positive of each new supported capability.

Signed-off-by: Marco Elver <elver@google.com>
---
 lib/Kconfig.debug              | 14 ++++++++++++++
 lib/Makefile                   |  3 +++
 lib/test_capability-analysis.c | 18 ++++++++++++++++++
 3 files changed, 35 insertions(+)
 create mode 100644 lib/test_capability-analysis.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 57e09615f88d..ac024861930f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2813,6 +2813,20 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config CAPABILITY_ANALYSIS_TEST
+	bool "Compiler capability-analysis warnings test"
+	depends on EXPERT
+	help
+	  This builds the test for compiler-based capability analysis. The test
+	  does not add executable code to the kernel, but is meant to test that
+	  common patterns supported by the analysis do not result in false
+	  positive warnings.
+
+	  When adding support for new capabilities, it is strongly recommended
+	  to add supported patterns to this test.
+
+	  If unsure, say N.
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index 392ff808c9b9..e677cb5cc777 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -332,4 +332,7 @@ obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
 obj-$(CONFIG_FIRMWARE_TABLE) += fw_table.o
 
+CAPABILITY_ANALYSIS_test_capability-analysis.o := y
+obj-$(CONFIG_CAPABILITY_ANALYSIS_TEST) += test_capability-analysis.o
+
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
new file mode 100644
index 000000000000..a0adacce30ff
--- /dev/null
+++ b/lib/test_capability-analysis.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Compile-only tests for common patterns that should not generate false
+ * positive errors when compiled with Clang's capability analysis.
+ */
+
+#include <linux/build_bug.h>
+
+/*
+ * Test that helper macros work as expected.
+ */
+static void __used test_common_helpers(void)
+{
+	BUILD_BUG_ON(capability_unsafe(3) != 3); /* plain expression */
+	BUILD_BUG_ON(capability_unsafe((void)2; 3;) != 3); /* does not swallow semi-colon */
+	BUILD_BUG_ON(capability_unsafe((void)2, 3) != 3); /* does not swallow commas */
+	capability_unsafe(do { } while (0)); /* works with void statements */
+}
-- 
2.51.0.384.g4c02a37b29-goog


