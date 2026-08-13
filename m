Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E96C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9502F6B03C5; Thu, 13 Aug 2026 02:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901D16B03C7; Thu, 13 Aug 2026 02:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8172D6B03C8; Thu, 13 Aug 2026 02:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F416B03C5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:34:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3844A2AB3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:16 +0000 (UTC)
X-FDA: 85095281712.05.72129F8
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0582E8000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZbMMgi0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70ar5JlTr4siaYWARGHSNLurtbvgFrnTr20To12QjOE=;
	b=H7deryXrwqMy37wzcGYsXiYET0I7e4+K+HSf2ytWo9W57bf4gSoVzGRDGWnI1IOlXQsaX4
	RSSwvwy7sYBR308gOjjWHSsAqMXKW45YWVrrQmiG63YYnz+7CdbppfBswIR3TzIG7iVkXL
	zLEaqTXSICI8mE3qZr1Z4sCeNwmqrak=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TZbMMgi0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602855;
	b=y5fofkn+kHf1iDJF52GaniPVPvlFSlnhXP6GT+PLom11vsKAhrbqCDio1buAKmEJvknWko
	6iKIl/IjMQ4vRzq8P4Zid+YIbpxUaLqkUDi0Ep4X9Lv2tQ9Z1esPkqFwZMT7CMn7mKQPzT
	dmzwaY2W/X45WWtT3/rYeaMGL4C0FNM=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8487b7b3fc8so2019938b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786602854; x=1787207654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=70ar5JlTr4siaYWARGHSNLurtbvgFrnTr20To12QjOE=;
        b=TZbMMgi01ezT59d2A5aNUvTYjt5aZIYnea0wOMOhwoM6i26tAXYNjOEPnBo2bjMd5s
         6ZoXw0wPPHRrG0KY7Kr5v+xqOcCEp2Ai7App02uYduxMby6vB/bhIDdB9Fldf+0u1I82
         JjkzgoUyoYB4RCBEaKDzkCoCq77vDuW8vXvdRnfn87prwpTnpR+n/6pipLLaOMiQXecS
         XbPNrdeipoQ/VBotI1l3ujbWeESTf9mLBsLj695PpYk1bJkOLkrzchnohztu6Br+kflQ
         H9Oi75RDsE2TL/AvlBlvNM0KEaosFfXO8+bsqaEL7RiPperNZfRc/EuguVfKCmhVYHX1
         55Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602854; x=1787207654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=70ar5JlTr4siaYWARGHSNLurtbvgFrnTr20To12QjOE=;
        b=eb3xmUMuJJLgNsoYI2DlcLXjhMyMPnd7c5wJFhgoOslOu06SpOlIJllazz6TQqDSvA
         iMgGflqt3VKXLk0AHLuPqY3ZqAgykUj9cNA9hLrW/od+WJqQf5s8cHDMhnA0Fp4gIwp6
         o0q1H0dG+B8PnOzT9c7UhbQhFPJPgpfDUE9HAQIHNxWTZWqK4VzFTDvY3n5edbXj30jG
         8d2iZ1RmmlAJEaxU+Jp+Z2eFHPSJxrAYq07RE1gXbced3oVMZptIABOmhEA1XHN8HPXU
         TPeoejonEW60QAPa50PDlVOkK1Q4RoP1w0RGj6olp5qbUoxM0eUC8021eHdf05nEMWNu
         wS4A==
X-Gm-Message-State: AOJu0Yy4F9n4f8cNUBV1oEq6NZDz3udoLpKTIzO4bmiAew52q7tlVCPk
	Ddgc+zP6JzBZbm2J6NOsmtt/nQ1yMyI86QkeindVsguTu+sMH1ZaTU29
X-Gm-Gg: AR+sD13OlEG2vTj/xtOo0HDIHyCUyyKLAbT+Fq1dSJkTfKZSbldVACUjOeeMYJasmFL
	GqmAope12CY+imCpEHIdzmRz57aPbCb+ZHwX/kOgGjH9CPrkkuUX+7DDUKA1UytQnGwQUGcQ5JI
	7leZibyrk8eRZ0bEtiMVlIM5MV0+fB0IyvQZkq5AV1i8Og12XfzAhcQDqpm6NudQWNZX2zt1hXZ
	fie1AQayCnoXD9KhjXlj3vxeaHNQNahOu50MtEkFaix3AUoDC2MVa5TP5vrnXlwUXtYy94nhvUE
	KuluO9DV35Sd4Z0JtVT0N4bybf6BAdNFOkXBHe+UJWTPGpH2wd5Xysb3Z3yp6eWS7GboJ2GqQK2
	6ookJHmz5Huq1ou2fCYTe6j9aSDyKsTdV+higTgucQKVcqQ/WXAsNUjkH+gifkwM1+rfdg0p5eG
	+dnl/H5nQozJvHNZhjB4owOJLboiROoBIYcQpGHbRUXfHbqrnCTvnNfwnXCvUOS6Ep9G/mRzm6Y
	K6IGVrSE0OjY9kYSvCNV/sEXPrNqcs2bz4GKzTtvMs/L0/BcC1/vMeukc078DNU5w==
X-Received: by 2002:a05:6a00:e10:b0:84e:1a9d:d879 with SMTP id d2e1a72fcca58-84fc760d2b4mr3746110b3a.28.1786602853695;
        Wed, 12 Aug 2026 23:34:13 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbef710cc24sm493765a12.20.2026.08.12.23.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:34:13 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 24DD715B0433; Thu, 13 Aug 2026 15:34:11 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: [RFC PATCH 5/6] selftests: run tests on nommu architecture
Date: Thu, 13 Aug 2026 15:34:00 +0900
Message-ID: <20260813063401.1786548-6-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813063401.1786548-1-thehajime@gmail.com>
References: <20260813063401.1786548-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0582E8000A
X-Rspamd-Server: rspam07
X-Stat-Signature: aaibz7zu7hnxp6e5t4mc1ont6cm61p7b
X-HE-Tag: 1786602854-678820
X-HE-Meta: U2FsdGVkX1+q+EktB5KS1QylGsUSfCASroNm5Z+JRjg5RqLl2qz0aeXU2yFU1QNHCsVT2HkJikT2BoNGX+GAsIe82BfUSBF8ws0CxyPWyCpd0uSyqZZOYyZmGwNZbXAwXqDy3eyGsGLZt8AiwzX1FW+/N4Llhc69pwabEzg5u+Qz7FHTtJtZL3j07QSGPVuSs4y468MTjVHk1NZtOF9NtXN3Q5FUGv5Y/Cn0uvWgDBfSXvfvH/V74H2WfJCwdk8tlBN9tvswRAY7QnyWTEOr5v/qZKP92hK5KrG7nDSToKFJRnvkdVwJPckU68AAqCnq/EfbG0rjP2thVh8i+pr5O4sVPfAE+n0fOuaLr/OqgT+TY+QDsVIR/Sv5msrF7MbbUCkMfM3vKdheWxRJgW4ZFfo+5jtaCDqyBxpTj102CUPol2VIwfZKscGh+6Hr2CP9YPSS1qbNEamB0FWL1yABcJXEBUZ16UsLowRqRLxpKDx6ELq0dJKXIVy0H2ok9u25msZrs1QZ2pRNPWOGU1MVDL6RcmYEb6J7mFnBkiqKlKK10Y6QQGeS6hATnVv5/zIo+p8Z5IlJuvPk6f33YiCdy/zTZhs043H8LmY993ZYBCvLDralc3crrSoG0396NoANyTLbKpTgk1e10A1J/5dvWfp9gz8noYhsmbaQy66TEOO21IctfGjUtfPQ1w9CYzHO9fg1TodEjZnNaoBXsW5z5/Qqwj/4gGvgUCFbq5siiYBAtEhlvpcBlomvzmA8G55nF9sF33sVZKOReYgVb6u4gG/2zW/vlooLVyEoENfpRR7UZqWfTC/LzPwZuRbgk90ILS0eVtNr3h7hDadflOXRpt3ErP1gDBDHijp57uNXni6eSJsteLNP751FFq7/JK+zxje+bXDOVQqvgjZTFDqIh8PBCxc40CCFlhG9EEfYJypqvkc3/CJUzvWKfg1j2/Sg3oc5U/5cy8+eX3wETZX
 YitIYewW
 /kzm8XRHwrwCRSnyt9JZGdTf5t2aOyGadkuEhg47QKEp6wphn0CxKTgZbZl3o2ZVxQmwTnXj6s2ExLxpDkCUcVzJZZ8CuTWeSi+mR2xsUOGHSjoQR2W2usRcy5pF3BAcNRHP07WqxgYkCK/R1lmJWsEUyq+sbsSB5jWydQ4ODxB5pavIMaCoKLU0117lbYpd/FUcbSWtYoxA8wVfZb12f+tTbzZTGmahkTdBRFlZgAOQAIcJZYRr36SyMTm8LmcWnyFPq+8G8VLMUqeUHhylnjcJqL4hc8DaRp1jfIWgOcVKXCXOLOHDqUCNInNOARYGLfaOGnT4tB7gbUVNNJDWPQVFjbeHeED4eWqw018Ld5cHRFSlgtR+KGtvdPXDHtEz4x6BMyZYT0myzFTnulN2fuqpRFXqzc77ilyInRmI3GbG9caEqVzEuI8pXQy8VyKdsgBcYpDXaypE1b32+DAgA69i7j/RaQfG5XdbggrdYZwfrWaDBcgCvVLS6+g6t1P2CcwYf3OCxLwcURe7FmCl1p5o3l2AzBDAnv2jZHbtMZaNSjBHOMSMuRKWOarh8WYWAfiIoPq2tqvZwBeq9Fx5G4AskK0Y8ULM5Fo95HCj0oFDzkZLkDB2dRbSjPJGSpjcPANDr6qwBiJICaLrAbDeVz1hfnvANhtfIBJFKnp8gDB83KciwP8NifVjy1eXCNepWban5jp7PMdOdXWoXzpeu7lyMREbAdF1rz2026qwGjvqfe3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures lacks MMU doesn't support fork(2) syscall and only
vfork(2) is available with limitations.  Thus, we cannot run kselftest
on nommu architecture as is.

This commit addresses this issue with the following changes:

- on build stage, add -DCONFIG_NOMMU to CFLAGS when NOMMU=1 variable
  added to the build/make argument.
- on test run stage, avoid calling timeout command when NOMMU=1 variable
  added to environmental variable, since timeout command uses fork
  syscall which nommu platform doesn't support.
- kselftest_harness.h warns if the file is include when building for
  NOMMU platform, as there is no fork(2) syscall.
- replace "cd -" use as it is not available a shell supported on nommu
  (e.g., busybox hush), use cd "$OLDDIR" instead.
- describe the difference of nommu tests in the document.

So command line to build/execute tests for nommu should be like below:

 $ make ARCH=um NOMMU=1 O=build kselftest
 $ make ARCH=um NOMMU=1 -C tools/testing/selftests/mm run_tests
 $ NOMMU=1 /tmp/kselftest_install/run_kselftest.sh -s -c mm

Cc: Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: "Ricardo B. Marliere" <rbm@suse.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-um@lists.infradead.org
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 Documentation/dev-tools/kselftest.rst       | 12 ++++++++++++
 tools/testing/selftests/kselftest/runner.sh |  9 +++++++--
 tools/testing/selftests/kselftest_harness.h |  4 ++++
 tools/testing/selftests/lib.mk              |  8 ++++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 64c0ec7428a2..800b2b688aff 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -230,6 +230,18 @@ section::
 
 .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
 
+Build and test on nommu target
+==============================
+
+If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
+``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
+checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
+using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
+
+  $ make ARCH=um NOMMU=1 O=build kselftest
+  $ make ARCH=um NOMMU=1 -C tools/testing/selftests/mm run_tests
+  $ NOMMU=1 /tmp/kselftest_install/run_kselftest.sh -s -c mm
+
 Contributing new tests
 ======================
 
diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index 311811dc55a0..7287d8290b6c 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -38,8 +38,12 @@ tap_prefix()
 
 tap_timeout()
 {
+	# nommu doesn't support timeout command (missing fork(2))
+	if [ "$NOMMU" = "1" ] ; then
+		echo "timeout isn't supported for nommu"
+		$1
 	# Make sure tests will time out if utility is available.
-	if [ -x /usr/bin/timeout ] ; then
+	elif [ -x /usr/bin/timeout ] ; then
 		/usr/bin/timeout --foreground "$kselftest_timeout" \
 			/usr/bin/timeout "$kselftest_timeout" $1
 	else
@@ -130,6 +134,7 @@ run_one()
 				return $KSFT_FAIL
 			fi
 		fi
+		OLDDIR=$(pwd)
 		cd `dirname $TEST` > /dev/null
 		(((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
 			tap_prefix >&4) 3>&1) |
@@ -147,7 +152,7 @@ run_one()
 		*)
 			ktap_test_fail "$TEST_HDR_MSG # exit=$rc";;
 		esac
-		cd - >/dev/null
+		cd "$OLDDIR" >/dev/null
 	fi
 
 	return $rc
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 261e4df94d9d..8eee7b14f824 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -1274,6 +1274,10 @@ static int test_harness_run(int argc, char **argv)
 	unsigned int count = 0;
 	unsigned int pass_count = 0;
 
+#ifdef CONFIG_NOMMU
+	ksft_print_msg("harness test doesn't support on NOMMU architecture (no fork(2)).\n");
+	return KSFT_SKIP;
+#endif /* CONFIG_NOMMU */
 	ret = test_harness_argv_check(argc, argv);
 	if (ret != KSFT_PASS)
 		return ret;
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 2cc819006424..4734b5ce613f 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -97,6 +97,14 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
 TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
 TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
 
+# detect if users request NOMMU build or not
+# User can set NOMMU to 1 to build/test for NOMMU platforms
+NOMMU ?= 0
+ifeq ($(NOMMU),1)
+CFLAGS += -DCONFIG_NOMMU
+export NOMMU
+endif
+
 all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) \
 	$(if $(TEST_GEN_MODS_DIR),gen_mods_dir)
 
-- 
2.43.0


