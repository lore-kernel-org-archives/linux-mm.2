Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EF3C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F47B6B0099; Mon, 24 Aug 2026 21:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A55C6B009B; Mon, 24 Aug 2026 21:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095466B009D; Mon, 24 Aug 2026 21:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D10C26B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:59:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B0421A023A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:59:58 +0000 (UTC)
X-FDA: 85138136076.21.E9BB524
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 99DDF180004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:59:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ocUTZ15j;
	spf=pass (imf06.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787623196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXZ6arscy3bI1yYYXMDFd7SBEHMelfRFPGbyYXY2R+o=;
	b=IgDWRNC3xQxbpfbUzROaGFY+9cBXyGr7WbOHYQbyECipcTXhTN3WcebyHvWtUP+FXqIe8g
	v64uk/1RUY4IqICoFDY/lYdhIEi0g7nZUFJ+OjHLKAJS7kTaeLKPAErQDb6y1el+8ZYI06
	mghw2SvRR1JSQ9Rk677Q8GJFZggvzvQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ocUTZ15j;
	spf=pass (imf06.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787623196;
	b=L6sUEPkBd+77jpE4VEWc/nY58HoHvFvSnelGN/+zGJgJvmh4SmvitPhSTsAs1WpS3qT3hf
	wGmwuEmiX4LqpHWVfVEfkEjnkBEJtWQCAx8lBSBtVZK7MYKwRuARe3KDc/g/Jx/s4CeJQk
	lrNlmOx7Dno/mCH8GhVMeKKvv7vCw4s=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3964e480f76so323539a91.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787623195; x=1788227995; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rXZ6arscy3bI1yYYXMDFd7SBEHMelfRFPGbyYXY2R+o=;
        b=ocUTZ15jEZgRgL79nBJLCgDmNMMJFKvkQK/ablIMznY3zJVlWHh3nqARkOHTFYdHFB
         vPfmw+iLPBzWTTvn05Ux4sigUthkCBjbtX6sBByweVxa2a8nNdVOZmyZwgk3r+KRlCbL
         kzwhcynPD4bVQs2SdDLNzHD/1HeRx1o4FEdL9IqpWNe1EJX97jtyh8lJmLgxhoQALaEa
         8FMByOIZ2MNN/cVKvWuylsAvQ7H1eHrhtr0lBpagr6GzJCVYkLNiGqZpeVo/n41QfEI3
         Gedtla+6R0+rHvstWF91d0Pn3JiBmrsS+wKmGIf6uNc/h54q9qFqjTYCmmi8coLhGcE1
         fNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787623195; x=1788227995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rXZ6arscy3bI1yYYXMDFd7SBEHMelfRFPGbyYXY2R+o=;
        b=AB5rS/47ZPXgAd9PI8XAUZiCVKSZV3aqF6nTyRVuYR3iFv6VgA2D22/Wo1deIDxKzp
         wE0zqwBquf8ztNVi+NsYQWrvcrbCXKLnPoyHNSqP111fBTZZleaTUnSCVL+Kh8w9mA3x
         L+1yixZ80Wb3wB7A2X6BW++J7jjtfGLrSGuY5qoCtYRX/WLyY/w4FgTqcci5BE6aG2f6
         E3Sa1C9UUhyP7mhiQ8/6C64bjkX1XiS/WkGpgjDBpbdoa1vbqp83UTy1XPlb2eOKi0y0
         CuO9hMY2XvuUNV+qajwa63kPLphB3f1l6H6+jpE1P6nayaG21+4v2WD34DW1wXXkSiHl
         7acg==
X-Gm-Message-State: AFuF++kyD66RoUNmlt6SGzanrjmkEdCBDyPWUBP2lUmUlrnsJa+dSipC
	oYzdQ4tpHfcM9OYw97hts5oujrVHCkCiBuVGrZ6hEOIrc+vHO9aJgIZn
X-Gm-Gg: AR+sD13WhP3C25KiXBfKff45nWMUEU0Qj9EWT1kQ1uB0CAH3pVVzHI56h4NW2p4CYB+
	67qZfLquLxthXFEttxfBocdv7vHkGZ5RsidEqtiK+PJIgs1kRZ2KhHoKMt7Dcb38+FjCdDlFROe
	qr182g/nCWgHXiC7VJwR6jYiZBuDreVkiVeqAelnexYROD9+c65l5ukCDyYa4SkGZCN84OFLGmh
	yS8K/rB7rOBaUv0fTfF0cV15x8wHYcgaJQEDxL8plqFtNtNdOVoBojqCepeXlaGAtWlhS6qo0MS
	AUZdZETb68hkSjVi1elimxp2x0G1KIChWPwM1ht00WwPrVUaBjyQsbCKN+fQT+V66zbCF90Awqi
	+IniG3bjl6XERLfTDW3XO850PnfFd0QGFXSDj3tmNRFTkU3Bep/sHf1h1tYLUVOOU5FxWNtGA2a
	nbF4A95zPDSfvkSwk1YDavtxVek7+/AMNrf5155HOFS1ZqPLYk247sEoypctjepcXOmMfQwOL8t
	aiRP+pWMe2TI3bC0mTEjz2Np8bLoc2wghKVN3c5+omFGo0mlTr7k5BhZfDuCrnZtQs2pXXvjcEV
X-Received: by 2002:a17:90b:56c8:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-3964652108bmr6382091a91.12.1787623195352;
        Mon, 24 Aug 2026 18:59:55 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645b08ca0sm1725042a91.2.2026.08.24.18.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 18:59:54 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id A42B915C677C; Tue, 25 Aug 2026 10:59:53 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v2 1/2] selftests: run tests on nommu architecture
Date: Tue, 25 Aug 2026 10:59:44 +0900
Message-ID: <20260825015945.141739-2-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825015945.141739-1-thehajime@gmail.com>
References: <20260825015945.141739-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8x5gj984a5gdp1k7mzmx9ytu74a3qyw
X-Rspamd-Queue-Id: 99DDF180004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787623196-329318
X-HE-Meta: U2FsdGVkX1+BK1TPuRBXXVdX2376zkvM2lttlKNpoBmhQpO/hNmVX7vI6Ks+Kl1HJeLFweo2j1xH6zQufY4as6Vd/jFbdZcxy0vkdL02bpid8SslHaxyq6suniyh8KORc/HW3m0jOndacYhNKJy8KY/DXeo5iplFlMghQgvbqMgd8f8AzZMISvdeDIl0+80wQTFoYP9W93viqSoO7SKYNwPTy9Eg5HoE+3FicP15OmnJk7dE3g3NwEELl0vR0PXdYepyO5QtMykPoNjLTjt3azTgOiZk0LNwBtTa/Tr3RlHUP/fBu+RrnilX813r4UH3Pk0SJQC3WLuyaw0M2FGkPcS/AE8qY/bjBBmVceu8EAag3xci3Qhsha8wk2DpiG4Zd535Ts0kXdT7wIeO1vVfPIpqXpDe+92naecVyhmo/bbLn0wGaibZAuIh1p7p2onr8HpLmMXkuiDca+hYdiJa5p+Ga797SaGX05KUm7vA3tofursg52JOY6BPQbKaTWpldtI4+q5tHmgIIybBznCWlDzQPx0ZyQYZ3qcA3dQCR54JlSIAHix9Dr9ZadJWyLViNiWlUSkt9bpEctQjxd1txaUOHXsVJXLqfJCZOCG3C+yRZtBfRzpmyghugc/PV+7QpcexmKlM1ablHYBz+RbAxqUmCrP5c8E/GK/ZC+MJ4j66kCDtSb5IpHQSGZncryla5lnbpX/n7LYgI5CFZEfb4ncs3JJR4U1mVCWndyawQtvNipxqbSsg3GnBd24xQsOJk8DbNv2bArf134+SRH2jrAUlr0YZ8AJeJMLYRrdm60n0TpHGTBIj/ctGwUNLZu0UXMlpZogLJetGPT6EQlKGTsvlVonony59IeUa+GF53K7KtkIEBzphz+v1CrxAhEAAHTm55g7XCa+Z8VlJ+72zTXp0jXfcWxSZkOQbQt8vSye+JDNDmo9aoIUPqa0edFmZRqeeR3UUTpYdwYMKKtr
 1l7b0cZx
 yuQZHqORJldoPLOAaWHQtnSiVpfYx7/sfAftInAMURLxnpv8iv0sLGFIZ2UhS0MKKk7szwpK5S0Zb5I9yE7uI3/9t7aDiLuzNyPBrVjaed3hVqo/gp7VmFfon1mLoSRLxjIUHpgVSv/tbASSpp8CP+fYZONY38xhm3a6uIPIAU+yY/dys4Qy/jeNqyAoNBkP5OC5U45VzTB14QMeSODNeqtCGvVM8wjAehD/BI2wqYZlVaRJFyX5c3HLxWBXpJ9Ydu8yOPtLxMsKViyqjHOXdBHYHQLGoEgN4HMrNg8ECN8DuNybsjjwx3xogiYjgsPiErP372jJxLtn/L5rztUKJAswXcDJquoYG9E8/2VZzGRENew1765ixNscqy3zcMeSCrsyyVGQ6ML2jZhDLOpyFpJsVY5fsCB6YfjnJN7qX9MHYp39mmxTo5XvY2T/QQ2Y33Dr3HY5bDs56TAPWP0PldFxanwUe+Cf4orAGC98dSzrunbBfV6C2pbc9cZ2mgeBoMdQxzk4XKpG6n6H62UcD7nSJWuUji/AHrdbAk3qkMTTU85oFo4UkZ3nGMjgeoT1Elq0lZltiy946P6MLYz5Q3efo5Oa25jFSwAzwzkoe2LIsKSxFzlN+iJNi/tNy9r0utbS36CffPzK8HNBzSC+l6KQmIMBqebLoUmlN9IiFXuS/YZXjkdP+GqRomEHH/18MjIJ6O20RLnruKQq3DB0ou70kMCgu7cqnxD509K/Gfm6T8167tYw7UArIarhIFqEwOrzKWMLLpIgfxOFFByJGBV5uztgFdq4vadrNzFMEsJHp7sjkapYcZJ53txoP047pm/Qwwa8p36zCjMeh4j6fpLEVcj/qoiHXTdFp21s+3MmBDMjf6FaR89YQa7gbcyJ72iOH28qoUuTP6OQ=
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
- kselftest_harness.h: skip the tests if the file is include when
  executing on NOMMU platform, as there is no fork(2) syscall.
- replace "cd -" use as it is not available a shell supported on nommu
  (e.g., busybox hush), use cd "$OLDDIR" instead.
- describe the difference of nommu tests in the document.

So command line to build/execute tests for nommu should be like below:

 $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=mm/nommu
 $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=mm/nommu
 $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
   -c mm/nommu

Cc: Shuah Khan <shuah@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: "Ricardo B. Marliere" <rbm@suse.com>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-um@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

rfc => v2
- reformat ktap header, reported by Sashiko review

rfc: https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
---
 Documentation/dev-tools/kselftest.rst       | 14 ++++++++++++++
 tools/testing/selftests/kselftest/runner.sh |  9 +++++++--
 tools/testing/selftests/kselftest_harness.h |  4 ++++
 tools/testing/selftests/lib.mk              |  8 ++++++++
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
index 64c0ec7428a2..a65f3ebc5906 100644
--- a/Documentation/dev-tools/kselftest.rst
+++ b/Documentation/dev-tools/kselftest.rst
@@ -230,6 +230,20 @@ section::
 
 .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
 
+Build and test on nommu target
+==============================
+
+If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
+``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
+checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
+using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
+
+::
+
+  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=mm/nommu  # <= build-only
+  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=mm/nommu
+  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p -c mm/nommu
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
index 261e4df94d9d..0d05946a5e7a 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -1274,6 +1274,10 @@ static int test_harness_run(int argc, char **argv)
 	unsigned int count = 0;
 	unsigned int pass_count = 0;
 
+#ifdef CONFIG_NOMMU
+	ksft_print_header();
+	ksft_exit_skip("kselftest harness requires fork(2), unavailable on NOMMU\n");
+#endif /* CONFIG_NOMMU */
 	ret = test_harness_argv_check(argc, argv);
 	if (ret != KSFT_PASS)
 		return ret;
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index f02cc8a2e4ae..fdb895967768 100644
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


