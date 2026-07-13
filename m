Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF7FC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09CF6B00A0; Mon, 13 Jul 2026 07:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CC66B00A1; Mon, 13 Jul 2026 07:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B1F6B00A2; Mon, 13 Jul 2026 07:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 884656B00A0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:48:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 171D486FCA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:54 +0000 (UTC)
X-FDA: 84983581788.18.E034B8C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F4471A0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=O4dNFxzZ;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+3Dbo69/AiAclmmo0zFVcKt382p+VuW4vPQJlc8PVc=;
	b=vOnLMvgNZgjfWjhF4M6Jg9a7cs8HCm2dNwee2j5G/U1y9pQzGo6yYloxRjdVW+kNeTPiGy
	ggEbD7vc3YxUSXuQnuAVZw2S0rQmfe0PEYGA89eScaquNhIoow3qAbi/5JeeYWzixL2CvG
	iW6UFjUau5+pdvs0sMmT43BHKba4sj0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=O4dNFxzZ;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943332;
	b=fKWVBWKmXLjeYCqXRhss29pVjxxNrI9JWxyWA0VxI10b66p2KIGLr3JyyGrIkHDkptBb3b
	gSpR6s86s5Z67Rjs4IsC0EUXd5l+/6N3m6B0vs2wT/1ZiYN8UxJgoBtibjw3vgX/H1LU5E
	fG7LmZjqPG6LaNnEWbxQ8VDhpMmEM9U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=J+3Dbo69/AiAclmmo0zFVcKt382p+VuW4vPQJlc8PVc=; b=O4dNFxzZco/bBX6I7886Md286z
	BQdURH8Wz2iXtTqc7u1PFtdADvAk6Pv75xV0JNWaucThbzig+4x3+wWCLuWGzwwLJVFMeG6dcl1yw
	qurQvJggsW8mwlI0sToNfH/sCmpveQGapeCYfdO8FQN7scPzfeaA0wIxb2xV4cxVEMDlp+qFBlgFY
	t75mvoaPJ/wD3M3vkPM7VjrKdgEJx43WP3UisV25dqzvL4uJLKsSmM2EXvgAIhHfvJfhULflyge9L
	ms1K+O5ue209ncKJXF6/OyAJoJEOmoAo0da3nZnMHpvR0ZGzhoGDpWJowZUHWdIE4vmDxWBgtpBL3
	hsMjYyWQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjF9R-001Tjd-1y;
	Mon, 13 Jul 2026 11:48:45 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 04:48:07 -0700
Subject: [PATCH 4/4] selftests: mm: test kmemleak's N-consecutive-scan leak
 confirmation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-catalin_pto-v1-4-5b93b1131089@debian.org>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
In-Reply-To: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=7712; i=leitao@debian.org;
 h=from:subject:message-id; bh=3eQR/Kd3kFCe8YoRP/xKeQGlrrGIS3gsS7iBDPNwGWE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVNCEK5BL8aTovIa4ZM4PGTSVv0NXeVIOLzzHd
 QS5UNwaN1aJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTQhAAKCRA1o5Of/Hh3
 bT3fD/9z7pPIA0FZEM18v9wAENnYMgC5wBEQ92lbjmm0+47fWixv3W1cLGZJ9XQK5jTaO7zWayd
 ZAlGg5VlwjSzjYaaqtw1+fySCVdYHPtEeb79re7GpXkvgn0shL0Z/dlDS2e6qGZQrD2QHoQVKif
 +IrXlqd+e8TlUyNvMcso2iJzEEc0772PlC7y/2z9O0vjGYSzRMP7vC0mhrIZ9TE2Vgva/HvJfx3
 tOV8j0eDI/4Rh3+LS3jmbRetY4vGP4vFbhgwuNlspydCoJRU3lAnTp8x+b1I4K8LiDjzHFqE899
 XYUMnjbaaHSzT0RIwAm3PmFlmNyJVFmCLcSMGdKq51XzQKWgKs/u+IUW0HlEyC5VHlcUMpCowy+
 tdrjS+gMpHrTQXinSsJj7NvU9qPjKZpM2ju/leu9WpMRENOOj0jqdDKrkWdJhXCDjf93BHEjJfK
 9rmbj6keQk2/Jc7wHG/REuHe2HuLTHFDPQ227mX7SXkCJvDt9hMpy36BRG0j/JgVckLIWP3LN9H
 iF/YcAPoJC7KqrZBnLj9QRR2aoWZBI+E3jGWBzrTNbFxWzusUM1yGx4pP2JgNNXFr5+B7ut7H7i
 9/j/FddfwKk2KPC5xoJC6seTdwTrQBVnKbRatCz706fyFqxzBgLEvd6ginAAI42COkKwnAGqb4F
 AWZ/LjSek/G+Q3w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F4471A0004
X-Stat-Signature: h5wa4b9fy6e79miz7y8eti3j11iweegq
X-HE-Tag: 1783943332-630861
X-HE-Meta: U2FsdGVkX18P8xttqoSlODmvDbtO3b2A8FJNIRom3ayTAlY+T9K9iEL9orQ0vSBKZ4b6re5+7ZE/WSMZtaGDP6W41Gk758gLU8vUos2SC3F6f+FWribcz7dAxs8eXtdameQXkkWs0XFCrGtkAITi098OYVPZdkzR59YLTVKHhVCYxjCCDKGKVpJ0vf7YizDZcRMUGjtYytYSTFFvblDOeH4GgvwbMVo3Gof9xhjFGATMRqxbGh3b16arYk+CJtSC+1eO42gLGhehBxaG8oGXL7cBtgWG0ATuvq2ssrpG+CwIJy21IGpiqiVfRDMVpavkBgZu2KElyhpaBAO1Zqbh/zILDyrxu/0dAd/tjq2KEobf/eN2pW6RD7Vks8IqU/OBaigHdIX8jwip7eQFahVAJERd779j3kx2lJcMvcXbXqQbOopEDjgQ6cZfYXoWuP70aKCwyuTgnBANyMqZizF1BQjZKWaX7EqbdSM7ZANQWWJxYI/rvzcfK2hG+buU9roSP13OAt3bjfNPbygDknSOonfd1/sIY3K24xwx3426JWZ6g8g1e9st7A7PHJ9MJUnRyLFwAhU7tq7TPceoKQKYG7pM1+Y4imKp0h4cEH5dPq4olqKAzO26bCDRKP6AvJfNzdFZfRqD55ipdBJvQVw5Y97GzahJ5iXRDQ/aD2v3AQS+oUy60hiiK/D+i9lZBoArBUjhqvGnAAF72EORmLuCD7+fBBk1mdGB1Pzo/f00WjnrHkIE5/W9m239QJtxRGloJyeqYVJaUvKhc52nxy6splBpdxONUUgmWgcml25E8vS3y23a52XigtJ/rNNj0mMRhcpUYIp+mMd7shjx+B9n0Vibvhnxgo052JA06tdvBzn/SJeG1XZzAmb4GzO5TiluW5b1ejWCedQFsFmd+q1HJsfvhnxYt7MkGIyoTeF0smFL9ISbbVdXHbk2LDrgsvwETttcEK0f49HZIMKk+M0
 WleaPVsC
 nsKVIuVgOJHFCVKuO1mRIdoltqmB1XSjmPPNUjchTb/rNWW87fOXFxT3QvblCB/UAF4jh8ZmuFortw1vZlv4GGRnOTdJEpub/Q3fjy1leKAPcmReqAkRqsOyyf8HX6PxYI/uggDhHp/xX2rgbfYVkLfRzImC0OcocZrASPfdypQCepjH088NmpiwZSb7DNHA+wY8IfQZ0TEQbkcHSw6u9FQoz5/LR9FLvtUIrHskVkhN5JDoCLI7YAiGvP6rJ+0N5+Km36nIJm0jjCXkSBzOLpM6jTJfxT1RyDWR3
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
 .../testing/selftests/mm/ksft_kmemleak_confirm.sh  | 132 +++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index ed321ae709dac..786b1d73d93b0 100644
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
index 0000000000000..3a8576e835c8d
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_kmemleak_confirm.sh
@@ -0,0 +1,132 @@
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
+#   - a freshly allocated object is greyed on its first scan (its checksum
+#     settles then), so nothing can be reported before that priming scan;
+#     each case below primes once first,
+#   - with the default threshold (min_unref_scans=1) one scan after priming
+#     reports the orphans,
+#   - raising the threshold to 2 needs two scans after priming: one is not
+#     enough, the second reports,
+#   - the parameter reads back what was written.
+#
+# The "one post-prime scan is not enough at min_unref_scans=2" check is the
+# core regression test: raising min_unref_scans must push the report
+# strictly later. Like ksft_kmemleak_dedup.sh, if the module yields no
+# detectable orphan at all in the running environment the test skips rather
+# than failing.
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+# KTAP output helpers (ktap_skip_all, ktap_exit_fail_msg, ktap_test_pass, ...).
+DIR="$(dirname "$(readlink -f "$0")")"
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${DIR}"/../kselftest/ktap_helpers.sh
+
+KMEMLEAK=/sys/kernel/debug/kmemleak
+PARAM=/sys/module/kmemleak/parameters/min_unref_scans
+MODULE=kmemleak-test
+AGE=6		# seconds; must exceed kmemleak's 5s minimum object age
+
+ktap_print_header
+
+[ "$(id -u)" -eq 0 ] || { ktap_skip_all "must run as root"; exit "$KSFT_SKIP"; }
+[ -r "$KMEMLEAK" ] ||
+	{ ktap_skip_all "no kmemleak debugfs (CONFIG_DEBUG_KMEMLEAK)"; exit "$KSFT_SKIP"; }
+[ -w "$PARAM" ] ||
+	{ ktap_skip_all "min_unref_scans module parameter not present"; exit "$KSFT_SKIP"; }
+modinfo "$MODULE" >/dev/null 2>&1 ||
+	{ ktap_skip_all "$MODULE not built (CONFIG_SAMPLE_KMEMLEAK)"; exit "$KSFT_SKIP"; }
+
+# kmemleak can be present but disabled at runtime (kmemleak=off boot arg,
+# or it self-disabled after an internal error); a "scan" then returns
+# EPERM. Probe once and skip if so.
+echo scan > "$KMEMLEAK" 2>/dev/null ||
+	{ ktap_skip_all "kmemleak is disabled (check dmesg or kmemleak= boot arg)"; exit "$KSFT_SKIP"; }
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
+	modprobe "$MODULE" ||
+		{ ktap_skip_all "failed to load $MODULE"; exit "$KSFT_SKIP"; }
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
+[ "$(cat "$PARAM")" = "3" ] || ktap_exit_fail_msg "min_unref_scans did not read back as 3"
+
+# Priming scan: kmemleak greys a freshly allocated object on its first scan
+# (its checksum settles then), so nothing can be reported until a second
+# scan. Every case below runs this priming scan before counting.
+prime() { scan; }
+
+# 1) min_unref_scans=1 (default): one scan after priming reports the
+#    orphans. This also establishes that the helper produces detectable
+#    orphans here.
+echo 1 > "$PARAM"
+gen_orphans
+prime
+scan
+first=$(count_orphans)
+[ "$first" -gt 0 ] ||
+	{ ktap_skip_all "$MODULE produced no detectable orphans (cannot test min_unref_scans)"; exit "$KSFT_SKIP"; }
+
+# 2) min_unref_scans=2: after priming, one scan is not enough (still
+#    gated), the second reports. The gated-scan-zero check is the core
+#    regression.
+echo 2 > "$PARAM"
+gen_orphans
+prime
+scan; s1=$(count_orphans)
+scan; s2=$(count_orphans)
+[ "$s1" -eq 0 ] || ktap_exit_fail_msg "min_unref_scans=2: $s1 orphan(s) after 1 post-prime scan (must be 0)"
+[ "$s2" -gt 0 ] || ktap_exit_fail_msg "min_unref_scans=2: no report after 2 post-prime scans (false negative)"
+
+ktap_set_plan 1
+ktap_test_pass "min_unref_scans=1 reported $first orphan(s) one scan after priming; =2 held them one scan longer ($s1 after one scan, $s2 after two); param read-back ok"
+ktap_finished

-- 
2.53.0-Meta


