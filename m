Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFEFC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E4A6B00A7; Tue, 25 Aug 2026 08:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026436B00AB; Tue, 25 Aug 2026 08:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA56F6B00B0; Tue, 25 Aug 2026 08:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF79F6B00A7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:30:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 457E61C18C2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:30:44 +0000 (UTC)
X-FDA: 85139725608.19.E80E2DC
Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51F2C140010
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:30:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jbXpDYkS;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661042;
	b=PnJExtD09uJlGjDJEGSHIha+UGpgkeVQ0FFDvUJXOulyw0EGMf8dVkrGTdDFjNp2NYBVUh
	8N3DAWSk+88mdjWhgimVGvGOVC6PlRyVWjxFdVAoZAuGyYkEUnC0chG7MKkHBRtTaHPicL
	FZmDx0cIxpCJzHI4lmE5o1meX3gh+98=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jbXpDYkS;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1UeYWR3KEVgTWXl7oP3i7BHbXYcdbuHUgWeQhar23GU=;
	b=jkVRrhEKAg2/j8mtDR+k30AaimfeVuNaBRoDn8O8a2XRdwm5m/YyOcknYVEHBIqss1DCyH
	cuXLzHVnYljaY2/TS12QT/33zmzBE5IZND2ELxPm8FA2z86VTLIE7yD0vFB5iGfW3wDH8F
	QOBeo/qOy8D9NkLIB3cJ4Kc4a8TAK9M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lKJdbgYc40Jcdb2LxGXn1NfTq3I444jKQUjSdN+FxF4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787661040; v=1; x=1788265840;
 b=jbXpDYkSSpE3/fKdMTtIu2NfFmrbZAqBzRZ388JbIUwLFBziMQYAybduM46RMoEvpdkYhRhP
 LG4BXOEeYX8+uUhSDQ0SLmZP1o7iGtwyXZbyBRJOf+EwqOYvKw+c9+obxSKnF65N7epfn7CO2KK
 KbVrjBqsjal1s2vBSduNR4w4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (139.159.170.87)
	by smtp.migadu.com with ESMTPS id fdb6cd8b86f8c3a8;
	Tue, 25 Aug 2026 12:30:40 +0000
X-Mizu-Trace-ID: fdb6cd8b86f8c3a8
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: fix incorrect skip output in pkey_sighandler_tests
Date: Tue, 25 Aug 2026 20:30:23 +0800
Message-ID: <20260825123023.64418-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51F2C140010
X-Rspam-User: 
X-Stat-Signature: ogrn7mzapzbjpx1a9d7haachnjjerhxj
X-Rspamd-Server: rspam06
X-HE-Tag: 1787661042-964873
X-HE-Meta: U2FsdGVkX1+KpWA+xHyGTS0OBugXYqIGReBkBhGoCQNSahxUJj0O7N5DZDZPWAwFOplKhBtqSa9YeyNmTTDyUCbCuUNx2m/wiSuW0SLIg4b38D1XXWuRhifVafKLkaJBexFj/4ie7GL7une6quVpSivu2Mbe10RNE3dUjeMWrRiRQd2POEEFxgGoHCfr8+NVm41OpnZUMnmhonDjiZbXOp6KDfhYhW4tnorppsIvRNL631TMCLYVOuGxuFos56LjHHNU/q9nTkTsVpyBGJsNq4hmSozRAW5vq8H2BRwWOQVb0oFpwo+ZCIFpRsK5hMK9BuJ3QppWRe2wgMYtOXNVDdk0CdEeKwhusAP/hlP1Q2/U/YygEPjZgxXHYA9+iHe24bK321YeS7+e/hRhjvc4ZXFKTnKB8bhPgpy6GW9lBzGa4DGSyYaWTnbZd5DRcHdl6A0N9U8Q3uticJBKbsktd/LxDYjrmYrc2QIt/CYdxzb57prz1tWoNSw3dIGERrOww3n5QB41IFOIm2MkpEVxRUCUNrnPTSMhC46ci+Owtrk2pVq3BVvM6vVWjZbNfefieDTVD59in1Or+uZWk3D7ioxZ4kGRVUd66//vHzZL9WGVQSHECm9vSnXBWAtn7Yeq28eScysFWrX/pbbOB01o74cWITcr1l2v+sKzlA30RCZGXNE22Ol8YEVQUUd/ujwA3t8Y3rKt+v2pMxjiKX79wPmqbEYTE98278hEree315YpxbyzDDT+upFLoQqz/d7e3W9QHbXGZrYCzNqiXqbl26tplS7UMHA71z/ESj/UwJ4xDsWEWD3AcPSwSAK3a6noqfjaIEd01Gx2DJ3LwG1F/GEZFZWIa8tyGHs2zDkNXbV4Sovzuq04zKCSip9iDFCynH8OMCHGGKW0cJN57DyiaOsIahwyvHyxWzmIhOvmah5HT8yfCigz+X68UyPTNh0YRtaM3HvIv00HW1QRpQn
 imdGlk2W
 BlG6UpGijqVh4iKL3hpdOvMF6rTSx3iNYM1z1o298UfO9OF7M2/wqY3cAbmxuDRi2uGYA0QBtnYxc0DkLg3cX5FQZoj1mbUXK5AtWrSHzJtXNzVygRzIPRQ01GAqnXM5IHpDtj/h7q79WQZU7AT2CXGA4Kwu7SGkRphsC6ITJyxzIFU5p6RMqTQuGDPy6VkjUzxzOJz+KVncUl7FC2OvAhKBsFGEl3G4k7ayJFJ9XsJDaZV0672JmUF89fnBYOLauMmgJ8FoERaNsRRxSl2tY6/zRDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

When pkeys is not supported, ksft_exit_skip() runs with ksft_plan already
set, which takes the "ok N # SKIP" branch intended for skipping a single
test case.  The result is a TAP plan of 5 but only one result line.

 $ ./pkey_sighandler_tests
 TAP version 13
 1..5
 ok 1 # SKIP pkeys not supported
 # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
 # Planned tests != run tests (5 != 1)
 # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

Move ksft_set_plan() after the skip check so ksft_exit_skip() takes
the "1..0 # SKIP" branch, the correct TAP representation for
skipping an entire test file.

 $ ./pkey_sighandler_tests
 TAP version 13
 1..0 # SKIP pkeys not supported

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index c218d0510a2a..74bf79a5399d 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -543,11 +543,12 @@ static void (*pkey_tests[])(void) = {
 int main(int argc, char *argv[])
 {
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(pkey_tests));
 
 	if (!is_pkeys_supported())
 		ksft_exit_skip("pkeys not supported\n");
 
+	ksft_set_plan(ARRAY_SIZE(pkey_tests));
+
 	for (test_nr = 0; test_nr < ARRAY_SIZE(pkey_tests); test_nr++) {
 		tracing_on();
 		(*pkey_tests[test_nr])();
-- 
2.53.0


