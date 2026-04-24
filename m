Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F92EFED3D9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AF36B00A8; Fri, 24 Apr 2026 11:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022906B00A9; Fri, 24 Apr 2026 11:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1F06B00AA; Fri, 24 Apr 2026 11:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D888D6B00A8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:06:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A25461C0166
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:23 +0000 (UTC)
X-FDA: 84693775446.18.21FCF22
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3CB012000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:06:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PI5OVsN4;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043182; a=rsa-sha256;
	cv=none;
	b=Q8tXnV+z488mth9+Lt+wP3lvTLtvHSqsaopxwwlCi01o+2JrEp+nWgUoLbEJbzdvS5/3So
	LULm6BKPK6KobvyEaUQI8nlF7jFk/1tXJM0VGf1zKlhuzK07vpu0amgfvQt0QLoX5fqvJb
	VABslsemt9V2dZ7GYU/qTwBmm0zXjvg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PI5OVsN4;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9dMHvY64E/0Eq0UOACVelGjv1g6r0jBYKkjfUoG9zeY=;
	b=Isq7nOVJ1o1pWY8lAZBZD42ANBo1FHOKHkoqqYzH0mSBvdPVNOv5O2AUyL3HRvisvmINYf
	IwCQw/5rtkYVquAx4QhktMW/OPIuv+q5pQHS9oMBhEbvaSs8PIJAERztQtxjaj50SRUP5D
	aWdxhehu4PqrYNwz2w3FLyXxqFGJ0RM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=9dMHvY64E/0Eq0UOACVelGjv1g6r0jBYKkjfUoG9zeY=; b=PI5OVsN4Z6FnbV8R064sujFqJl
	XDFvbKTV/B2aAsEH9Yhng24qnIyrxQSm0AiayKPUen2OpANSsLqGgl3DbJr/wUzdgIPLBOx35qM79
	P7fOn/9Qdwu2VMtTDPxeQ27YxrXIM73czvuSSqjS5vVDlAlTStmft9+T8v2ebQhHqOaOMB4Ys5U60
	xlaydWz54n/CUFmd0nQxcyI8EueR1oRAlXrK4v8ogIl5BogD22nupTtm1FxnYrFvxYjgwrymQtz+t
	MP51QEgqRcuKRp4DgyAf6/18G9riJRh31d4NNoK7pOTDJv2aNS1vb48T1SkUenv2aLUV7aSzmNodW
	YUV5dyWg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGI6f-003FtN-2S;
	Fri, 24 Apr 2026 15:06:14 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 24 Apr 2026 08:03:37 -0700
Subject: [PATCH v2 2/2] selftests/mm: add kmemleak verbose dedup test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-kmemleak_dedup-v2-2-8bea649b2a92@debian.org>
References: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
In-Reply-To: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=4637; i=leitao@debian.org;
 h=from:subject:message-id; bh=Mx+xKsW705Bvtu1gt8242kE4k6qFTx9knH17MmM+aWY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp64bVkIXMqiaoxF7/YW4ndSiQGKZ4M5JvO3WQi
 jiQ4M/AdmmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaeuG1QAKCRA1o5Of/Hh3
 bWNGD/9iZuj9NLm2IOIKDhoKk9IMdZkgszMRFOP0qTV5nwgrdiwdAvUt1C7/jIRI/5PKG5+qTXf
 Z4J0dOuKdWWiSz+MK4m5cAQl9FQ3GsrBNS3+5DXGhjlGGEqAIyXj50yqtHoYx3g4Exfu9cUWw8i
 KDhkRaFE3oEppROX+1w4pyvJNRG5a/4Lb2kA7oKGt9UWVduGgplYoqsxSs4fEEiRNB38OPvJRW0
 j+MLOuVQrs3dOi8qwhWSHPsotDXcL4pME4OOSroW/BZeM5zidMtTSCmKEHzQxGp+bzDJkmbkCwi
 HIBKvBkGuEC5ntP8yQbGFzxTKTY2nfgxNxFbkqLDcy12L8q2AUdvcsH7J+5HQBgHEHCW6tzfCFV
 6RA3wZMVGy3s4u5J31PnaPn1EEL6u23gdtimMbAabWwS+PREkAjl5Qrepfe2xmarbbgdH7QfeGp
 0EHXp5ii4nh4BxQ5BdeA96gQWSHb24GmKRdOc7RzYb7hSLeRj/OfFUnxyPoN4AYgh3O0Qp+uQpS
 bDH8iZbEKaYjhkpH14t8aaibg9DD4TLuTPY30QNvYc8mxdI0wG8G7e2hSEDUdZMQ+PAH0zrYbtn
 XHPOrGMs9EesA28xLmPrk6Z1Gg086xjeQXVSXY0PKGQVuf3kJA+8YFjHu6WDpS56enRf4+09IIi
 Zd3h+k1wT5ogScA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Stat-Signature: oq9913hemtwhfm5sjo7i13gpkznaorob
X-Rspam-User: 
X-Rspamd-Queue-Id: D3CB012000B
X-HE-Tag: 1777043181-438143
X-HE-Meta: U2FsdGVkX1/fJeD70aiSDeg0cpK4iM4dk+/vTXBUlfgvHvas+eHDB6qFvNYpuT+p279MdfPCzzoGynPBO+tX0Fp05LFTfftWay4OU3a17jtbsrOoW4itPQQ1WKX0Ta9GVBecOaBitGmurXxyoMQwKl7c1NNpbY66QbPQw/nNXnMQrIk+6+HEc4nCLO9p7hT/u0d8BfQ+dy9TKW1DJOCk/i1sdGiSwCS45hW9MtqeSP6TmV+IKSIVQ9p31uuhR+WUB3bUOmtGB7DrEhlf2rw4Z5Ma3iGi59KbKpNQWX4IObzQusTDUZI5RwTbmeL2Ev82bwkWcCHZLokaXjPi0IrALuCmDchJDgb07YIUdU44tol3I9MQ3/ssm8DdckXXf3FLr8jI2+aFflzq4QbbBCQNTwC+pPExi9s01yXLL72HDZJE/xLdr0A4jnEI7sXM51NNZ2K9Pk79oE4PDNcW7DKG8KWMiR9pa/TXond0UgHrzkQJghnDld28oOuM9mUCeTRTmsxEcMcMhuRU/7IwT9RycUm+4zNMkHIa9eJfS6tJlM63IB+p2PdksAfqqfHGHuHTj/zwb9oNiGSAUVtYzzMYG+L/RsvXdxkIHbcRx2HYulmqy8EnL7UFbC8iJVBCRoa2SZBLAgNsT0MCa2RNqDkk1mCv43OCPItrAsaN7sVX+qwUkMnbHQLk80Q/VQIEQIEw02qy0lIfal+ooeugsSooDpRFfb04vYsy5eA/g67tBxYqVqFhGxxcHrXw0dZHLzh2iQpSwRgJnAf+JDI3SlD/V1Qt9SwnfYI6I69tEj5+fWXylv06FSKpbVJwDo6lLBvG7J9tXtFWHdKgmGbW1iGqjxyjI5gCfbyWwax5iwT2MUcXl35/3zcEi+Q0VUnnD82uyivaHJ8SP0G1JQdrlBMFydO4nSj2Qfj95lMteTCTwsHu7WkfCxH6hDVQ82aVycVLEM1X/rX0Xi+m+U3cRBg
 UedMaG5x
 F6NERLT2mnQJYKIzBqZWURMn0NvHRCLh7c49+HYslia8rc4620xszWBjJ9liaf1bIt5gERNjrDE/jxsOY4glpM24acBLNZSEGYHovxzMnWa8PP8TRaG0ZZpfjUgpiAHeETIqVQj6wEHbmNC5X3JpXTESrkWEPDKPQlcSPxdOb9zKfPtgUUQSpy4eOhdhV3AmE6yB/QXtzXSbXsylNhYGFbhTf6dOevdTIwguln7legYt83YM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exercise the per-scan dedup of kmemleak's verbose leak output added in
the previous commit. The test depends on the kmemleak-test sample
module (CONFIG_SAMPLE_KMEMLEAK=m); load it and unload it to orphan ten
list entries from a single kzalloc() call site that all share one
stackdepot trace_handle, trigger two scans, and assert that the number
of "unreferenced object" lines printed in dmesg is strictly less than
the number of leaks reported. Skip cleanly when kmemleak is absent,
disabled at runtime, or CONFIG_SAMPLE_KMEMLEAK is not built in.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 tools/testing/selftests/mm/Makefile               |  1 +
 tools/testing/selftests/mm/ksft_kmemleak_dedup.sh | 86 +++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cdd27e..65ceefb931c3b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -151,6 +151,7 @@ TEST_PROGS += ksft_gup_test.sh
 TEST_PROGS += ksft_hmm.sh
 TEST_PROGS += ksft_hugetlb.sh
 TEST_PROGS += ksft_hugevm.sh
+TEST_PROGS += ksft_kmemleak_dedup.sh
 TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
 TEST_PROGS += ksft_madv_guard.sh
diff --git a/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
new file mode 100755
index 0000000000000..1a1b6efd6470a
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_kmemleak_dedup.sh
@@ -0,0 +1,86 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify that kmemleak's verbose scan output deduplicates leaks that share
+# the same allocation backtrace. The kmemleak-test module leaks 10 list
+# entries from a single kzalloc() call site, so they share one stackdepot
+# trace_handle. With dedup, only one "unreferenced object" line should be
+# printed for that backtrace per scan, while the per-scan leak counter
+# still accounts for every object.
+#
+# The expected output is something like:
+#   PASS: kmemleak verbose output deduplicated (11 printed for 61 leaks)
+#
+# Author: Breno Leitao <leitao@debian.org>
+
+ksft_skip=4
+KMEMLEAK=/sys/kernel/debug/kmemleak
+VERBOSE_PARAM=/sys/module/kmemleak/parameters/verbose
+MODULE=kmemleak-test
+
+skip() {
+	echo "SKIP: $*"
+	exit $ksft_skip
+}
+
+fail() {
+	echo "FAIL: $*"
+	exit 1
+}
+
+[ "$(id -u)" -eq 0 ] || skip "must run as root"
+[ -r "$KMEMLEAK" ] || skip "no kmemleak debugfs (CONFIG_DEBUG_KMEMLEAK)"
+[ -w "$VERBOSE_PARAM" ] || skip "kmemleak verbose param missing"
+modinfo "$MODULE" >/dev/null 2>&1 ||
+	skip "$MODULE not built (CONFIG_SAMPLE_KMEMLEAK)"
+
+# kmemleak can be present but disabled at runtime (boot arg kmemleak=off,
+# or it self-disabled after an internal error). In that state writes other
+# than "clear" return EPERM, so probe once and skip if so.
+if ! echo scan > "$KMEMLEAK" 2>/dev/null; then
+	skip "kmemleak is disabled (check dmesg or kmemleak= boot arg)"
+fi
+
+prev_verbose=$(cat "$VERBOSE_PARAM")
+cleanup() {
+	echo "$prev_verbose" > "$VERBOSE_PARAM" 2>/dev/null
+	rmmod "$MODULE" 2>/dev/null
+}
+trap cleanup EXIT
+
+echo 1 > "$VERBOSE_PARAM"
+
+# Drain the existing leak set so the next scan only reports our objects.
+echo clear > "$KMEMLEAK"
+
+modprobe "$MODULE" || fail "failed to load $MODULE"
+# Removing the module orphans the list elements without freeing them.
+rmmod "$MODULE"    || fail "failed to unload $MODULE"
+
+# Two scans: kmemleak requires the object to survive a full scan cycle
+# before it is reported as unreferenced.
+dmesg -C >/dev/null
+echo scan > "$KMEMLEAK"; sleep 6
+echo scan > "$KMEMLEAK"; sleep 6
+
+log=$(dmesg)
+
+new_leaks=$(echo "$log" |
+	sed -n 's/.*kmemleak: \([0-9]\+\) new suspected.*/\1/p' | tail -1)
+[ -n "$new_leaks" ] || fail "no 'new suspected memory leaks' line found"
+
+# Count "unreferenced object" lines emitted in verbose output.
+printed=$(echo "$log" | grep -c 'kmemleak: unreferenced object')
+
+echo "new_leaks=$new_leaks printed=$printed"
+
+# The kzalloc(sizeof(*elem)) loop alone contributes 10 leaks sharing one
+# backtrace, so without dedup printed >= 10. With dedup the printed count
+# must be strictly less than the reported leak total.
+[ "$new_leaks" -ge 10 ] || fail "expected >=10 new leaks, got $new_leaks"
+[ "$printed"   -lt "$new_leaks" ] || \
+	fail "no dedup: printed=$printed new_leaks=$new_leaks"
+
+echo "PASS: kmemleak verbose output deduplicated" \
+	"($printed printed for $new_leaks leaks)"
+exit 0

-- 
2.52.0


