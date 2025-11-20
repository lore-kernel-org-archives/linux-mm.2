Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC27CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041736B007B; Thu, 20 Nov 2025 10:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D6F6B0088; Thu, 20 Nov 2025 10:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5376B0089; Thu, 20 Nov 2025 10:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C731A6B007B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:03:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C0E7160194
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:03:03 +0000 (UTC)
X-FDA: 84131303046.06.646F6FA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id EEE7AC0002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CwwHJS5s;
	spf=pass (imf28.hostedemail.com: domain of 3nS0faQUKCMQov5o1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3nS0faQUKCMQov5o1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIkqaT4GZQQ8I2xtRoztfiZr8q25ife+cBqIcslh3gQ=;
	b=wo6cWhyM9CZh9nt+tB302LZtX9xHWUAVU5gYTZjM0NivW6+AMFFalMjMuYGxmYfReI978/
	SSWgRVB13F4w5UUNB1/ERoU1rIvkS8+ACoFxfqpRwbcOwZSmMTTBNUAL96goW2zOQ2rfQl
	4mMlHLgIbjvawQBc9fl7/p7BJr76Ui8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CwwHJS5s;
	spf=pass (imf28.hostedemail.com: domain of 3nS0faQUKCMQov5o1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3nS0faQUKCMQov5o1qyyqvo.mywvsx47-wwu5kmu.y1q@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763650980; a=rsa-sha256;
	cv=none;
	b=EI2KK0gJkKNHIm/zKGXS9UqOE9lROUC3Cl6QdSOBW5Nsy882Y+f4gMBMnVl4ituBzi0uML
	HOsgnJTNuWBv6G5kFqgluXgp1iaQ0YWPyr/HTMQSaAQG1kZTtVKT2jsuPZyxpiC1We8Yhy
	obwAPtPV6rw881Mgb1at203bJvdGPRQ=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775fcf67d8so10369915e9.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763650973; x=1764255773; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lIkqaT4GZQQ8I2xtRoztfiZr8q25ife+cBqIcslh3gQ=;
        b=CwwHJS5sfg5EzhSYkxdGtqhZVfvg3tVAxyRTjblpiCw4kHCNXPK/2hx39CzIBoNjnA
         iXNDMEO/YxtU24qTR/H5zb9v76Qok4pRe6jr+IC0/fT/IVt9Avu3tbtAuZYSJLL1WwBs
         jRONemnvQtlsJT5OsRJ2JdG7m6vV3Uifg2wRghNJk2rJrOra96ObcEKpHnq6/EPy4voh
         Qd2cUaL+cjmqNCZMuLkUU/A6MclpczQrVRW2WDqCjNfiFxBdOS/QX0vHrqGz/VGhmeL5
         z61bePwv05gEb5AzqpDs6O0tg277Q6ZIv07NfBRQCA6kDpJEulGTS+ZUDJsGMFBUh6CN
         IVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650973; x=1764255773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIkqaT4GZQQ8I2xtRoztfiZr8q25ife+cBqIcslh3gQ=;
        b=JV44JEm6j/v3ehRnfeRmkD4KwTFBVa1AFM1ne/0m2tN4O7ScuqhLuqc/5CMzkaoPVD
         9KaprwdxGzSIBbPRFS2kKpSR3vCsmc4BD7jdKqWmwT2z6qxfrttSKkLYBubvGkgImqmI
         xwcLh482u0HKL2nj1KReA9p2FFKtjmSfrgn02Nj9D2N4mhI1ih8029poPwsH27Lss5dY
         1LYVscgc09J2zABgrBsV7N7dIDklN/HE7HcbSmbxEYuM4g3Qo3iwibvx9rxiUhxpd30j
         4vSi5xAIQHJ3CFcvuRqZhLBahOndyfclF+AOgIwFqhB1FD7giWT74dIvL4jnuOPMgFsl
         iyKA==
X-Forwarded-Encrypted: i=1; AJvYcCW0jB694BseIc/5ZOCQO/LXJ2UDynSxUsx/G/q6xEnWGjDHLbCfsLg4SNkr/E8c84I7QQefWRvr1g==@kvack.org
X-Gm-Message-State: AOJu0YwUt0m2Agh1WVS7VchAOCygsukiAVanVfLu8oX2slIrJqWgLfYZ
	UtEkPZrm13gj8+mcCJQB1DCgduTcI+8dh6jaflu1GvUyR1BsfCqUYkRlkzct9ImSg1XBhtRUzwU
	Ypw==
X-Google-Smtp-Source: AGHT+IE7SKgiCw/02hArGI9zujP0xPyrpw65qFKPWhHBeestq9lQVOSID1Bw6HemoDi2xS2ktBePcnke9A==
X-Received: from wmrm14.prod.google.com ([2002:a05:600c:37ce:b0:46e:4c7c:5162])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:470d:b0:477:9cdb:e32e
 with SMTP id 5b1f17b1804b1-477b8a50e80mr28447795e9.9.1763650973180; Thu, 20
 Nov 2025 07:02:53 -0800 (PST)
Date: Thu, 20 Nov 2025 15:49:05 +0100
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120145835.3833031-5-elver@google.com>
Subject: [PATCH v4 03/35] compiler-context-analysis: Add test stub
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EEE7AC0002
X-Stat-Signature: 39r8uaw3k3n1cx1n7krikzdx1ypkt85e
X-Rspam-User: 
X-HE-Tag: 1763650974-359160
X-HE-Meta: U2FsdGVkX1+fVul4LfDP/IbRkfGYIUvYSRTJpDecl0e4v7NI4Ya/w2/S/LULQ6RNiXSqwmb1tXJFrwrx0jlmSpGcKwJF5iqx16E8kOQaCT/KEjj7Kf5kCB+/7xKIED3yWE5SE4nwvjObO8jlCjZcWXo+wbfeyg2qVew/uFFKBHpnfNcAfQxbRev7vrxVt++njJzP39YTuRLpaBb612cZ9nruBQNx10snB5AJQup8YNY2c7IEx6/f8wMxBxUg+XgdOgvtUqk3OKER9ptTXtk6zLv3YCvb62sdjH5oi4Wj/IBjfSLGJngFTlN32pxi4rNWmxl2vvUms78RiKmOKSmDsV8IGuVQW1SFqI20W0ELqz4dllg+fuD7RJglJuQL5vlCe5rNnWu6DXbbEfBv2lBlUKDEmooiPh7aJ0+Rfk0tINwINMzdRh9eWmGBIALJrGZ8mZKGb48R22H6jsqiTDXUkx9FU1u0coozXOczaIEPM7/0o8vb435/zg555RJam7GW6/APFmH3Lf9JEzTZYnxkoLAKbeq11LOxYPfK6OUEuft9x+NG+1Fu1l+LVKh1CH72iJ+httx/tyGz3DYRM0tlH/6AdJv4It1xpEbefDCoRTZxvUg7Jnn0APZCNE4TPlzJ+TODLwhBzexn3pNQo9n6vW19ppDAO8MdiqccqAh8mN+p4JpDc2WWooiv9YgU9/rsem+Q7QhmDm57Um767AaSiCnuNZf6VaKriAd5GC2hFkIISVNESWalsej6/WoiV3K0FFMPFQZunZi3+NJ4VmtnKw8cfB+ELJWmeLIgUVXtILBqJJF1h4RXxcNgEzLOSHWcyiwBuAv+xAista6u9cMeywI9doKsB907Ewz2NDrMhP4O/hLxE9K9fQBgAajN99aaMmEmpicRTziynCw6ABUc1GCZId7v6X5x/SArEQUDuDs3B3X3yqmXxpz0jZppAG8R+TYcDj0+6LAfRysFCyC
 4Bm+WN44
 P5BoyuqngcjzbgfXYv7aR9EB6lUIOsZkQ6Yg9ot+uKL3KMdWaVmbqYt279m1tbXtawax9o5VG1WUgb1NTXb0Q7iXOg1V0RR626NfZdjSbn4Jhq6bLdCCD+f9iji1tM7SjvJzG1riPbvGp1Ts4cHsBmUERMKvaKO+GahelXFgCxPbZ4qcl0QXcu2Du/rayi15mL4kdXaNBQB2PXhpFLy5XmWurG0bD59FhcZ5JVy/xCO96VSonzsMpnM9+xyQ9TD+GuMqPIRCu6+HXUpZYTfHCfzgjHCf9exDYQhJiDK6TW2UGk+e+DPHE5CiBlnYcBtSrUmp0uA1l2BcsjJ0b1OmM5+KK1nM4LQObfMuudHpnCscCrqt8QaDyFDMHDhOIBv1SCkiLosL5Cw/ROhHDywaDCBuaj0BqjB2aNI9FWeaGryKfspfSymXnhi6RrI066CnUq5fLPWnmxHBram38MNb/hVB7dm90YwajayE9bRfiymvkatqaIx5cFUTqkVjoqHV7rribcmAeZ9j5BTyqEZL0n31pWLglmzTvs0iFfTTbFFruj7O2qQ9nim/1bURCojaJg7rj4rPi7mXLoCKSMxlW0w6vxJMV2c9v3FqbM5Gs6vWuBEQ3tNOEiurUHmwmSw+TjrirzE7M25YTlnLy9Vm3avRJVJRj2Xsl1eruD+wEPwPupZ5xBPg+zWSukNTmyePKN1x2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple test stub where we will add common supported patterns that
should not generate false positive of each new supported context guard.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
---
 lib/Kconfig.debug           | 14 ++++++++++++++
 lib/Makefile                |  3 +++
 lib/test_context-analysis.c | 18 ++++++++++++++++++
 3 files changed, 35 insertions(+)
 create mode 100644 lib/test_context-analysis.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 696e2a148a15..0c499d22407c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2833,6 +2833,20 @@ config LINEAR_RANGES_TEST
 
 	  If unsure, say N.
 
+config CONTEXT_ANALYSIS_TEST
+	bool "Compiler context-analysis warnings test"
+	depends on EXPERT
+	help
+	  This builds the test for compiler-based context analysis. The test
+	  does not add executable code to the kernel, but is meant to test that
+	  common patterns supported by the analysis do not result in false
+	  positive warnings.
+
+	  When adding support for new context guards, it is strongly recommended
+	  to add supported patterns to this test.
+
+	  If unsure, say N.
+
 config CMDLINE_KUNIT_TEST
 	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index 1ab2c4be3b66..59ed5f881bcb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -329,4 +329,7 @@ obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
 obj-$(CONFIG_FIRMWARE_TABLE) += fw_table.o
 
+CONTEXT_ANALYSIS_test_context-analysis.o := y
+obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
+
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
new file mode 100644
index 000000000000..68f075dec0e0
--- /dev/null
+++ b/lib/test_context-analysis.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Compile-only tests for common patterns that should not generate false
+ * positive errors when compiled with Clang's context analysis.
+ */
+
+#include <linux/build_bug.h>
+
+/*
+ * Test that helper macros work as expected.
+ */
+static void __used test_common_helpers(void)
+{
+	BUILD_BUG_ON(context_unsafe(3) != 3); /* plain expression */
+	BUILD_BUG_ON(context_unsafe((void)2; 3) != 3); /* does not swallow semi-colon */
+	BUILD_BUG_ON(context_unsafe((void)2, 3) != 3); /* does not swallow commas */
+	context_unsafe(do { } while (0)); /* works with void statements */
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


