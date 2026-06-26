Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26F1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A572D6B00D9; Fri, 26 Jun 2026 11:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A082D6B00E0; Fri, 26 Jun 2026 11:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8466B00E1; Fri, 26 Jun 2026 11:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0926B00D9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:53:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B906114044F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:53:16 +0000 (UTC)
X-FDA: 84922507992.07.E7BD0E6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD6F912000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:53:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bIJANbQ6;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782489195;
	b=f+s2Pg+MmART2kE2M9aDBGmJd+UqBnHDkunt5MD0E+VOmar3btm10j3Svc4rl6gYZHUYKM
	t5L7CbvbvWsM66YAAjuJoHpwT6VhXCXlmpKVdkEogiRojXcpiuujpBfgLNo2WNqE6T1SN9
	OqXOD2ResU2FQVy+Uk4OWY6xdTSHqyE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782489195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pnehLe8Fc9BTRnNjqfHxijlMhSDnOv3l1cLSbLfm8Q=;
	b=LLI9ZOee440eNKA1xKz7FJXXYcKqmn/dBuFyGqzMQQQCoOdIF9Ibo1PLDMmad2RyJUwCTn
	1esLF5MO38H5Dk9a7xZiaap7Oq9QQpafAWXNGecgKwPkoQRf1OgZprQziP1dsNfibwfoAB
	tUUQV8TaQZqfy2RiAgxTRnNL7lV5xeU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=bIJANbQ6;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7pnehLe8Fc9BTRnNjqfHxijlMhSDnOv3l1cLSbLfm8Q=; b=bIJANbQ6h7BDrfCuAHKDf+qwg2
	nr6VhgsBwLb4IuR4sWUX3QJnAcNcNJiR5/8FnOAPWNQNlLDDRhilZEzyivJaTSfJOxDxumio3gdy/
	fRO1aZ5l3kzgS6SZmkbVeo/RgKaRRqB+UCOSQDf/f9pe0oiOd3Z5trntlAaF3gGtA7IkkPgDG8NSA
	QwJdCL+xFexgVE9XlHfTVCzwdNJHECRWh9rP611QZDo/lQb7uI5hm5nX++lyOtjkK+Fri7deOYqgL
	bvaI52+oxujY9C1fwvuGVs0vVFSqFa4Zs7UsZ6vKgUy+Ij87jha/1Krt4pt2wWkmtPR3ZJ0DcD7OD
	JEjLLohQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8rh-0044nh-1Y;
	Fri, 26 Jun 2026 15:53:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 08:52:03 -0700
Subject: [PATCH 2/2] selftests/mm: test kmemleak's N-consecutive-scan leak
 confirmation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-kmemleak_twice-v1-2-ab28f7cc0971@debian.org>
References: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
In-Reply-To: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6640; i=leitao@debian.org;
 h=from:subject:message-id; bh=LqdNaV8FU9i/YpyPfFZxEtMeY1Tns1Ka3tzd2Zq8Mxk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPqBbM92BUw/lNCj2SdE0hZbvKJoJe+UkFPKK0
 FIcuV5s83yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6gWwAKCRA1o5Of/Hh3
 bVl0D/9SADG1iLDMbNSjOEAH3bm4GJVko36UaxJ+14htHLB3ZEp9xAkWp0WCiBj13Q7tqv8kgPf
 sSnNksaHEY/HvUbc2qmgjyhUnGmNWPLmI/KiLZaXhThzFcZHaGLfKBdEdoPFNfxcj2PQdqpY9Py
 XI0KtxannHHwZFAJhztC3MMo/b/W6prFezHSoxfSJc/vAMGLddZv/XCHzdl3dUMyOfOW2OswaIu
 zUS+MLE+CXX5+wVUNxzrLbFbIe+cabKzxuwbQuzHLapHaT2ZhvkUBewYVoQC/uLEkFc9tUHlJx8
 QsMzgIB9HaDypt51TxmV3PqUFjJ7kXqznE4yDdTfFrf0rOJVMTwUIN8VkXaVDq4I3wouID8DFgc
 BWApe8BKuqV8xZ0jYfRvvr2tYLL9613VsCwhTxBds67B/pGsbvOmUrLtzkTIJfLtV+NZquEjqgt
 zAQ1zuVtY4lF+BG9wWIyDJd4EmzzB5pOJlliZoKKj/QBhWLdVf/X4PqkCxhJtgRl9+byfaIHCWk
 2EcE3JfJjJA/hEb0ORTjU/Ey85O2Wjbi4ek/AxVVuMZDcZkD44g/VbCMlKzI75O4ngq2xrjuXg2
 B30NAA2IudA9emNL/4HaH4R+pkl9tjJJP9ksQdJzUMDZwxpYHpszWt40Z2Q9nY0oaRUQkW0oILU
 VcJpMVijAxCrNWg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: qm8h6jja9t18shw9xetjjjf7eaqxk7ad
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD6F912000B
X-HE-Tag: 1782489194-822245
X-HE-Meta: U2FsdGVkX19J7btSUzwiqazWfSBb/Bloi+ogfCNejOGv4eZSNB0HTIoRMJpL4rcwSAkDDPXUN4nnH6NJYYbKNHgbALjqaRYXusgzw16+IksxUioI8PAGZPFi7L4TtaFXiyZYR1xyVsQs1A5CwZiAgdbI857ObMG0xmAqQzA9X6YwPLkVwPGqkdBcxPTlLXhtk6y2dEtme+hOvCbK1IYthmkgD2NjBNfNwjkL8kBesFqa/W/Ccc+5o+kWFKBnuwQi+4elt6HW0RVSt22DOutkXCDGz0r1kepq1wkc/8saZHWIiZc4gjMxxjuWD7Qppf9JC48vbC35zBlAa/boCXjgLc9ALd2SIw6n2Ubp2yEeO5UP+WEhCDylM4Wdg8HO35jdFURUC0YDJ6Er7uaPZ/RybY3v2kE5EsvuKO7fAl5y1HmsIp2pFT641jSkcgQwxq3g+LzpdNQ3MmW0fSwXGZC1WgsS8UHodvxU4rOR/KUlh09SKdDPlF/NBn0uTEE/O2oP3MgXSQbd7xMCmn4/OS1PMrLOJHbd9xgRmIOZpWoPP/wFFG5uxZQRLDqPSGvFqnF44zqLBYSOrwTja4W12rspVmDDNflku4f49AAM74JteafENMHjWMAl9ZAQOUr4WrStPH/szgvpNb7t7KRKeJ6dsA0J6OJd93tkQeZmV/3cpt8FfkQQKyxigHzydLoEpjdh8DNo7Qa23LO4mwpmTNgOsRyUtP/YCD10p+MztHsFNNoaL0QP59iDtxZeAKbD/U0zh4rO9Rd49Jn28obr64A9QntkCr/ezmK/FYdcbdRAm86r8JW6wgWFs/5+vqHvVlndBss7EVGC+RBof4e5UxfMIwwjtT0CLp1fcKuNFwR31eLzxUC2BscXyFKUZSbgr970XTs5PRDNqwNpEVC0/leKmkv/7DxkMeqDBW2TtksZm/wg1z2BN6nyH8vkCIqSnfT+rfxBGsQI4RDLi10c5ka
 7RSxM0xR
 B05MGlfjp8MgBzH/LTNqtxmbs/Qxn58qQKG7TzQ6zrCX36vEVcN8vcXtttUFyKh1jXQp3xchbXTz/VHmh+38EsX/gDzR2pmKaMV8Mwg2unMqsALk0fcK4bmz4skl/lViN8GnKuWv6Jzez3T3k4GMr1OrDSsDquWbM6X3W8oh8XlcBwYy79xaI39fKtRfbBeaGiPuac/ef4B3B23M3DQKUIojI5p918M6dAcDhqtOdWI8hBjvFCOmqVwfZxv+jpe59qb4BvLA8lJWoDpxcRWI2RUpB0eJDsgV4ye3m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a functional test for the min_unref_scans kmemleak module parameter.
Using samples/kmemleak's helper module it checks that min_unref_scans=1
reports an orphan on the first scan, min_unref_scans=2 reports nothing on
the first scan but does on the second, and that the parameter reads back
what was written.

It counts only the helper module's own orphans (matched by their
[kmemleak_test] backtrace, with the module kept loaded so the symbols
resolve) so unrelated leaks already present on the system do not perturb
the result. The test skips when run as non-root, without
CONFIG_DEBUG_KMEMLEAK / CONFIG_SAMPLE_KMEMLEAK, on a kernel without the
parameter, or when the helper yields no detectable orphan.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/mm/Makefile                |   1 +
 .../testing/selftests/mm/ksft_kmemleak_confirm.sh  | 111 +++++++++++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971c..84026b62a1ae5 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -150,6 +150,7 @@ TEST_PROGS += ksft_gup_test.sh
 TEST_PROGS += ksft_hmm.sh
 TEST_PROGS += ksft_hugetlb.sh
 TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_kmemleak_confirm.sh
 TEST_PROGS += ksft_kmemleak_dedup.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
diff --git a/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh b/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
new file mode 100755
index 0000000000000..34ab64bc6948f
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
@@ -0,0 +1,111 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Functional test for kmemleak's N-consecutive-scan leak confirmation
+# (the min_unref_scans module parameter).
+#
+# kmemleak only reports an object once it has stayed unreferenced for
+# min_unref_scans consecutive scans. The default of 1 reports on the first
+# scan (historical behaviour); higher values filter transient false
+# positives where a live object's only reference is briefly invisible to a
+# single scan (e.g. an RCU tree update in flight while the scan runs). The
+# test loads samples/kmemleak's helper module to create orphan allocations
+# and, counting only those orphans (matched by their [kmemleak_test]
+# backtrace so unrelated leaks already present on the system are ignored),
+# checks that:
+#   - min_unref_scans=1 reports them on the first scan,
+#   - min_unref_scans=2 reports nothing on the first scan but does on the
+#     second,
+#   - the parameter reads back what was written.
+#
+# The "nothing on the first scan" check is the core regression test: with
+# min_unref_scans=2 no object can be reported in fewer than two scans. Like
+# ksft_kmemleak_dedup.sh, if the module yields no detectable orphan at all
+# in the running environment the test skips rather than failing.
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+ksft_skip=4
+KMEMLEAK=/sys/kernel/debug/kmemleak
+PARAM=/sys/module/kmemleak/parameters/min_unref_scans
+MODULE=kmemleak-test
+AGE=6		# seconds; must exceed kmemleak's 5s minimum object age
+
+skip() { echo "SKIP: $*"; exit $ksft_skip; }
+fail() { echo "FAIL: $*"; exit 1; }
+pass() { echo "PASS: $*"; exit 0; }
+
+[ "$(id -u)" -eq 0 ] || skip "must run as root"
+[ -r "$KMEMLEAK" ] || skip "no kmemleak debugfs (CONFIG_DEBUG_KMEMLEAK)"
+[ -w "$PARAM" ] || skip "min_unref_scans module parameter not present"
+modinfo "$MODULE" >/dev/null 2>&1 ||
+	skip "$MODULE not built (CONFIG_SAMPLE_KMEMLEAK)"
+
+# kmemleak can be present but disabled at runtime (kmemleak=off boot arg,
+# or it self-disabled after an internal error); a "scan" then returns
+# EPERM. Probe once and skip if so.
+echo scan > "$KMEMLEAK" 2>/dev/null ||
+	skip "kmemleak is disabled (check dmesg or kmemleak= boot arg)"
+
+prev=$(cat "$PARAM")
+# shellcheck disable=SC2317  # invoked indirectly via trap
+cleanup() {
+	echo "$prev" > "$PARAM" 2>/dev/null		# restore the parameter
+	echo scan=on > "$KMEMLEAK" 2>/dev/null		# re-enable auto scan
+	rmmod "$MODULE" 2>/dev/null
+	echo clear > "$KMEMLEAK" 2>/dev/null
+}
+trap cleanup EXIT
+
+# Stop the automatic scan thread: only our manual scans should advance an
+# object's consecutive-unreferenced run. An auto scan landing between two
+# manual scans would change the result and make the test flaky.
+echo scan=off > "$KMEMLEAK" 2>/dev/null
+
+# Create a fresh, aged set of orphan objects from the helper module's init
+# path (its kmalloc/vmalloc/percpu allocations are dropped right away).
+# Pre-existing reported leaks are greyed first ("clear") so only our
+# orphans are counted. The module is left loaded on purpose: once it is
+# unloaded its symbols are gone, so the orphan backtraces no longer resolve
+# to [kmemleak_test] and could not be matched below.
+gen_orphans() {
+	rmmod "$MODULE" 2>/dev/null
+	echo clear > "$KMEMLEAK"
+	modprobe "$MODULE" || skip "failed to load $MODULE"
+	sleep "$AGE"
+}
+
+scan() { echo scan > "$KMEMLEAK"; }
+
+# Number of helper-module orphans currently reported by kmemleak. Matching
+# the module's own backtrace ([kmemleak_test]) keeps the count immune to
+# unrelated leaks on the running system. kmemleak only lists an object here
+# once it has been reported, so this reflects the confirmation gating.
+count_orphans() {
+	c=$(grep -c '\[kmemleak_test\]' "$KMEMLEAK" 2>/dev/null)
+	echo "${c:-0}"
+}
+
+# 0) the parameter reads back what was written.
+echo 3 > "$PARAM"
+[ "$(cat "$PARAM")" = "3" ] || fail "min_unref_scans did not read back as 3"
+
+# 1) min_unref_scans=1 (default): orphans reported on the first scan. This
+#    also establishes that the helper produces detectable orphans here.
+echo 1 > "$PARAM"
+gen_orphans
+scan
+first=$(count_orphans)
+[ "$first" -gt 0 ] ||
+	skip "$MODULE produced no detectable orphans (cannot test min_unref_scans)"
+
+# 2) min_unref_scans=2: nothing reported after the first scan, reported
+#    after the second. The first-scan-zero check is the core regression.
+echo 2 > "$PARAM"
+gen_orphans
+scan; s1=$(count_orphans)
+scan; s2=$(count_orphans)
+[ "$s1" -eq 0 ] || fail "min_unref_scans=2: $s1 orphan(s) reported after the 1st scan (must be 0)"
+[ "$s2" -gt 0 ] || fail "min_unref_scans=2: no report on the 2nd scan (false negative)"
+
+pass "min_unref_scans=1 immediate; =2 gated to 2nd scan (counts $first/$s1/$s2); param read-back ok"

-- 
2.53.0-Meta


