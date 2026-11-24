Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13141606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D/NkwOzv
Received: by kanga.kvack.org (Postfix)
	id 3B41C6B06B1; Tue, 24 Nov 2026 08:03:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BE46B06B3; Tue, 24 Nov 2026 08:03:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9216B06B4; Tue, 24 Nov 2026 08:03:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7216B06B1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:03:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00DA4120B3C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:03:53 +0000 (UTC)
X-FDA: 85470029988.14.F6BD201
Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4CF314000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:03:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D/NkwOzv";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.205 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525432;
	b=A9FtPNvlWTv5IUK3T1tkYw/OFO1zHBbU6KFUnNZ0YDFzJxlE6Di99n4ntncBr9vtZn508x
	1QzUogszORVDKziaqwt4SOQjYMnxbT6A3FLszfzHjJ1bMYOqIsMcM28m1wQ96VzY/TAOwn
	a+kExdr9lpGziRHUOgVAsGBwLuBumug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qz1cer2CJEb2XBcnOBD2BJhG3oNesoDxDbfi66TknAQ=;
	b=PSJ4IF5VdmtvMkJ9NxgGyWdIVJ70QbpSiX1AKpTuEci108w4nxmggHtxHF7Nyl5qDr2X95
	V4jG5ArjGguSJVIGsGcx7dwYGEFVpAKolaV88vcMngVs+cNS+hJ3ZadbvIdGpnYcRLn7sL
	mqquLe0gUHTwm3WR4/ho749R/hIFn2I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D/NkwOzv";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.205 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qae+lMQv4Cu2p12O38Ifwn0KaftWxrqv0xG2C05X8Ew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525430; v=1; x=1796130230;
 b=D/NkwOzvGOlIk7c+sENeibj5gDGOIB7mNF4W60a7KIXVwip3EXYdGi4t6u8rE+Oayy5z91f8
 v0m1JWA/XtRvH611ig6/FDu7O5G+Gj4EesgE10IwB2fdjrZfblVbiVvUV9BuQPf9dI2MINshyPL
 rLW5z6dIoCYyP7e5+NtMyAf4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1b470517dc8187ea;
	Tue, 24 Nov 2026 13:03:50 +0000
X-Mizu-Trace-ID: 1b470517dc8187ea
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	david@kernel.org,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v4 3/3] selftests/mm: verify ksm_zero_pages is not inherited on fork
Date: Tue, 24 Nov 2026 21:03:43 +0800
Message-Id: <20261124130343.131760-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124130143.128411-1-xu.xin@linux.dev>
References: <20261124130143.128411-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4CF314000D
X-Stat-Signature: grpfcan7ep8xbiwiuwka5onq1cb6gmsj
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795525431-783757
X-HE-Meta: U2FsdGVkX18QjFZjgsy6KXsChUXFMRCEOa5jP5Ybbi1oBUvmMUluuWtUxT3M7WL2Qfi/vfyFUvU/2ofdqfJ+X5sd43Q7D5JNMhnK9Zc9pblSGvwfj8GCyLHHK3oFelU/50zKJ6HZWbBI+V21RTaYbwIGW+i53xK8v5hatJTrp+CGvwupE/P1Oi1YZxVzgtnkjIAeF77tsOfVaWinFZPhwWFXF9P8X6NZ/S4Vl/IeHr/JVML5ATDuvZHIEC8iefT6DnmJ4ZnaRXJH3MI9NM548Fkr8PO9J5mKRFbSvs3t/m8IOpJp+pKs2ik0K1kyVWS52SbTUHOHGB8crLMozQFV5UTsgr8mMoPjhOLYgQKZwZhpQ+no/+5BRIcNqviF82+sGtE7h8r1HDUSy+ntDnUU85/CE6H/8wFddaH7nsAzGbHjjxwKBRFzTu1ww+aqLqu656sPg69iNykhk/nbURb3Wy38hmCfTYJvAnlsRI7zEZdxrD+RryhFHVFPklUVLfpt/Z1i8tzU4OBM/nGDTODVsKOGH/ui5wIyn/EP+X98k8tQtLdpbD4MxTPl+K8uUM7ZIR1ARRyXXDhLlpSEIkNDMYG71+fmwJ+9Dulc5jOjUqv5vcXmoKl5hwd1etBS5G0XFEYQfVno2uERbrEYtbVXAeJHbyyJvT1GHmK1/UfR4kePSWxThJt7G+gJ8GpzrfcdOCSgJtgP4Rbo6QOa8R7inn/XboaMJPEYIxAorji7+4NFeeG4pxSfcnPxfWHxqoQy/QoBf8AetYgmQ5dyaFqio9WEqZeTdgIcxCmld8e2ANi9durBHiuUCLqjCEi+t9WIdw8hsxQKj/JFpp9aPjfVev6ZZbbmY9GOm5D/7Tsi5ba3ajMcj8pGsU1JzM/kkI/bhU7Nn51X7xzrDzGddxvkMypC5XrGncWDjgKbcUK6NitdfLvxy/Z+MlJlYVJ2GwQBq3RPLH4gB7CAOtnlHA8
 JS3nxVvH
 7iUnElU49/+TZXvUYXgbjxX7T3QJZptHBYdBJY60Cs9tGm2bcEGxjLqrF9bJQsVHCAbMvPpHHSlYX0tHMLYDG7gaFnJpmBDz6eveY8nGMVJ5kc5nuBT2q056y3xZggIHP/2DBm1IZv2eMJ2O2jI05E1k50INA6j4YotGXM8g+MIfGrUDIX5YR+mv6yV4Svt3ouSH2GpFSa9Ainc38mqBrFvOf4nLCBfWAOR6ZawZ3kjzIQqc5zkNUyOgV7J81t8v2Q5pB7+s5ZLn9JMVwKum/jQacq9WJaK/yq4VU8zexBjo23sO4BQbtz3Qt8DKTmW1gBbh1IV/liSezOZN2DeXb6kcIFJWzHA9N7YbD3+wDp4IDdGn7XkentW24uQKh+bZ+mgpEJ/C9p4JPUvTmWvhJVjxvE8dUnA/jyWfAQL2XfKtZ505HmNY4kkt+RfBBflnqhKNbFp/detEP3huiNsOFjkxS4RwcQ0u/ypnblxBBryRWBKEMqnrNoCCIlAWe1LcFqgXr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend test_fork_ksm_merging_page_count() to enable use_zero_pages and
merge zero pages alongside non-zero pages before fork(), verifying that
neither ksm_merging_pages nor ksm_zero_pages is inherited by the child.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
Changes in v4:
- Rename test_fork_ksm_statistic_count() to test_fork_ksm_counters() (David)
- Unify cleanup into a single label and munmap before ksm_stop() (David)
- Fix phrasing in log messages ("Reading KSM counters failed", etc.)

 .../selftests/mm/ksm_functional_tests.c       | 44 +++++++++++++++----
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index b871d5656688..7aadce09e6c7 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -655,27 +655,51 @@ static void test_prot_none(void)
 	munmap(map, size);
 }
 
-static void test_fork_ksm_merging_page_count(void)
+static void test_fork_ksm_counters(void)
 {
+	char *zero_map = MAP_FAILED, *map = MAP_FAILED;
 	const unsigned int size = 2 * MiB;
-	char *map;
+	long merging_pages, zero_pages;
 	pid_t child_pid;
 	int status;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
+	if (ksm_use_zero_pages() < 0) {
+		ksft_test_result_skip("Enabling use_zero_pages failed\n");
+		return;
+	}
+
 	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
 	if (map == MAP_FAILED)
 		return;
 
+	zero_map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
+	if (zero_map == MAP_FAILED)
+		goto unmap;
+
+	merging_pages = ksm_get_self_merging_pages();
+	zero_pages = ksm_get_self_zero_pages();
+	if (merging_pages < 0 || zero_pages < 0) {
+		ksft_test_result_skip("Reading KSM counters failed\n");
+		goto unmap;
+	}
+
+	if (!merging_pages || !zero_pages) {
+		ksft_test_result_fail("KSM failed to merge pages before fork\n");
+		goto unmap;
+	}
+
 	if (ksm_pause() < 0) {
-		ksft_test_result_fail("Stop ksmd from running failed\n");
+		ksft_test_result_fail("Stopping ksmd from running failed\n");
 		goto unmap;
 	}
 
 	child_pid = fork();
 	if (!child_pid) {
-		exit(!!ksm_get_self_merging_pages());
+		merging_pages = ksm_get_self_merging_pages();
+		zero_pages = ksm_get_self_zero_pages();
+		exit(merging_pages != 0 || zero_pages != 0);
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
 		goto unmap;
@@ -688,15 +712,17 @@ static void test_fork_ksm_merging_page_count(void)
 
 	status = WEXITSTATUS(status);
 	if (status) {
-		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
+		ksft_test_result_fail("KSM counters are not zero in child\n");
 		goto unmap;
 	}
 
-	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
-
+	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
 unmap:
+	if (zero_map != MAP_FAILED)
+		munmap(zero_map, size);
+	if (map != MAP_FAILED)
+		munmap(map, size);
 	ksm_stop();
-	munmap(map, size);
 }
 
 static void test_merge_aged_pairs(void)
@@ -842,7 +868,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
-	test_fork_ksm_merging_page_count();
+	test_fork_ksm_counters();
 	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
-- 
2.34.1


