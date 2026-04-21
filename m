Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27633F8FA7B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEBA6B0092; Tue, 21 Apr 2026 09:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6756B0098; Tue, 21 Apr 2026 09:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813A66B009E; Tue, 21 Apr 2026 09:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 745D96B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:45:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1929813C337
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:45:38 +0000 (UTC)
X-FDA: 84682685556.15.CF0A817
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1013D4000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:45:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=N29+8gwv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776779136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmmnr8TWW6YxLTw+YepayNd7RYX3r8i4j8goyBNWTgE=;
	b=gK+0/08poZlf35cPOfgQ28PlApKsSrulPBVe+P3gHqiORe3TLyXTIidyfMM5UTyb+FGI+d
	l5IEDwMxN4YDwUgBjQNfwDVnqapsfAfB8f8LRq7VT1JeacGKyb/Rnf+M3ko90krVdqddHW
	n3LNtQZJg5rE6iBcljaRJoKmxsoQ2Gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776779136; a=rsa-sha256;
	cv=none;
	b=uyxn7z+ZnLpfBf1CXa+nR486XR6LPJlPMjyXaneSv3ffNqd0Z5ZxlYyaEFMWl2nIVAtKEY
	AI4BxLqU0Ax09WRe/+wyvUBz0fgbN/i7H+6Nty4zEhHTJsghWOeKb4e816UoHa+ShzkmS6
	6Tv3Kl/QkDnS1Ae1mxk5UPDicAk2OAs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=N29+8gwv;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=zmmnr8TWW6YxLTw+YepayNd7RYX3r8i4j8goyBNWTgE=; b=N29+8gwvrkSpXl7c4jicvS8gXy
	6ta1kv+OwClGLqjvT1ArLhmoGzZp3cSIV6aFXG0+ZGyEe6MRFI+YTmQeA0fTMzFB0GthI/tMj+Tey
	laWL/wF9g2Oa1lU0ViwqetoDK0HVErkPLUdXGESdi2x0X5z4zbmaVYHEifvEQGQmuvxRK0GVR3hfX
	sNsWTGPb8dm96X3Hry2ICsCOb102XsjD1wDbwppdLebr6F7ZP2mMaa110BEtOUqFC6WIUXYKbqIie
	784EINV6W7umYr/Zy/MSEwDgi7926LvZCqstXQNGDS6vYxQ1JdxB6drsZfArZQdKtXeWxMtCdRv3w
	UlHQBrEg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wFBPr-000tUk-14;
	Tue, 21 Apr 2026 13:45:27 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 21 Apr 2026 06:45:05 -0700
Subject: [PATCH 2/2] selftests/mm: add kmemleak verbose dedup test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-kmemleak_dedup-v1-2-65e31c6cdf0c@debian.org>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
In-Reply-To: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4082; i=leitao@debian.org;
 h=from:subject:message-id; bh=9Wm7Dl8/F3pYBq3qZXT8kJfTkQ2Zpb38Hb44JyLLdyM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp539pSZsITzdPAca14zLveMIHnMZh4OdAp07TV
 mIYE4BT87CJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaed/aQAKCRA1o5Of/Hh3
 bQE+D/4puL//7G+Ueti7kPpEa74j38TB6C8TVaq0xhyFPzwKqvkgXIIyQZIvPWFYfWI0qM0g4/u
 ZQtEt/RgTOs+dfiHFMvKiCAFRKoTxap1JADx117OPqH9gJXB8hDh4N1C1Tkchwbfw6mEUiyjGDQ
 YGpUFU7iIH1bSSQm/rxKHt2b/DHLu/CDZTbnoYABgiEi379B5vv4UZrbtealqDojBf1ynzml6Vf
 8kfeVnSUM4AMk/V3aCYrEZ0WBqTkhOueoxBGAeZdlfVcXy3Mf4bxIxtFikbelLTK95D049gYdnH
 9ixA1dwUbcKO909t5Ht4vM4L5HsmM+kM2RP+l7/TdcBytlp/07c3IvMNVG50Ohl4WH3GdlFcQ8Z
 vb5BisLQHh31KY2d9X/6QPX7BSO0LF/UXR1xjHWd4dd4eU/gzytNtSd89XSyWm6SFbSM8uUnTs4
 2mzQHug8xNU0mC9bORJA93FYYFYwhMAe4tErwEN6x8jF6GN00GaaHZpd5x4vLH2hOsE8Xy30RwR
 qDLuBivyVI8wRcZrZoH8JF6RB3MduoQZVMrcSzQ6nUNVMrM4R2vSEeEj35iqH8BDCHImCdiVRrE
 r0XOXE014XcmS9fYC8U8c4WNsT7tEiN0rurBKg2KUlV5IlcMyNK28z6IgwdW7VRBlu/WXi/VcJA
 5qs3aK+Xx9hJ4jg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: i4np6fbno5ubdyozcu17gfk5j7ta977r
X-Rspam-User: 
X-Rspamd-Queue-Id: 1013D4000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776779135-79735
X-HE-Meta: U2FsdGVkX19v2/UWtGiU0xahxbs9GXiixT3RHU5nWAHnFXDWXKJ3hXgrkOGajUoviGD4sicC/SAznWloCzZ+Lfcsc1pZIs/sNLHjdK+EtCmHZKT1pfrjBFYugwHFhoumOcTr8xouhltsrwPO0ZWy+nmN51rmDCgsdf+7AUAPzrYB7C51IG3nhIYGT4jgKNj5o4o1zLTDDIikPxg7m64qrTe9Yt8NzttXKaX6Y8YIvcYXmcf+7nMRkfwh1o+q6/eV8XPAqaX16JS3uKcR9rQ9chcbKYKCYaR9zKeDrt5TKbTivO7wDzI6MvxywdYsKNljs8MrVsLET2aIlhIpaMeir0osb5s4ykZuBmrlBIJ3HffiNEJKc0OrcOZDsAnd2cyRnEvzDLifL38jYhvx0rR1caM6EeqyLePXxMZVisrtSDeQvqlqjHcgGsqo35Ygcbhbn3dH8faJwVvJRVwUQqB9EG5W4Hz3GE48jC1NL4CvnOCGSDSqa5xKzF0T9HVB8G0QYE1Z897UdCXef7YNhGiSdvC4yBOMG8qEYTlswPWBjjK9sTUPPakRwRH5ZdyWZrmYMlI55KeOE0YuE847/WUqmBIYPTEdZUxFMgO65cNgLl05DSADgc73Af1gckkg3UqskU31SOcY+jE64lORsvZigxqBuvGxFfMUlVy657KecPCkX3v60+qC7HOdiIHmaO41Z9f4KLW3k1mAmcIXywR1KLDhmEdhXA12WG/OCiRNizozHsW1M0aWuA7XVbNunRfEcXs5IglxRSbWmKK6wV2BkxtyTjttlfGMD+W2+ylZqw/s5RCPCgKDMH3W0MqqqMzqLT9Jv/5/I5v5fSJ46ftz/snJ4K3O0/D0XsBbOWE4tsI3R+FeK3cMzLHTSW9fP1UW8K+RXG5k+SWad1WxXbQxgzLYCvmHBh4BTnrt3DckqsFvPpI47fxZ22u96ABGB3Q+PvHpTnxvda6PNeRSeP7
 krCL8Lkl
 Et0RQT299Qm7WJbvn3aGnvUSiOhwQ5FXWGOzAS3ap2fN9ymP8r8jND+MseMsgKUKi1Q2p+aWJEEBkfD8G0/DbpMuX0KMzsCJQj38YDadSzei/oisIQeSdk5WUDZMFX0BxKjwjpi5MeWlmOysVyYerD4YyYc54TRP+K2IF
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
 tools/testing/selftests/mm/test_kmemleak_dedup.sh | 86 +++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/tools/testing/selftests/mm/test_kmemleak_dedup.sh b/tools/testing/selftests/mm/test_kmemleak_dedup.sh
new file mode 100755
index 0000000000000..1a1b6efd6470a
--- /dev/null
+++ b/tools/testing/selftests/mm/test_kmemleak_dedup.sh
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


