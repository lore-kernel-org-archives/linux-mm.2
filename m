Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78F5606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AZ6GIxFi
Received: by kanga.kvack.org (Postfix)
	id C695E6B05B6; Sun, 22 Nov 2026 22:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2DF6B05B7; Sun, 22 Nov 2026 22:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2EC6B05B9; Sun, 22 Nov 2026 22:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89E5E6B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:46:01 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BF85A79A5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:46:01 +0000 (UTC)
X-FDA: 85464995322.07.3C2DCF0
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 138CA180005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:45:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZ6GIxFi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795405559;
	b=L5OenKc0jFUtd10FP425weHbJbSZqXlu3Bwrg75N9uplWYufRcumpk/WGUHSSlJe5WKnxw
	EiTYpcZCDE/AUwi4ufMdok0oyG0WUOd2R1BV+Pm4GLd1x+htGiZppEcQXQCRR+dRpxRaXZ
	6nHz1qLihe+WOzya55HjcBZNk2WGKtE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795405559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Qa0HZZjs7or3S/BSPmhnoxADvYGuQMQWM8HAvfk0Ro=;
	b=vIQHMZfc46+RGU7YJgtseY4dX/f4cjFgT01maBrNzEP3EW+yDPL/lf+E3avrwlNhQAe0FC
	8VdU2GmT3BJ8psRKifVb3fXzNowWw6KkdkU10zUe9nuMexb2NMgCb7Uz550vyqmEtKqQKy
	9X2EbXEIHgboYASm1Sz6qnTGyd3nqs0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZ6GIxFi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ieS6icOUU8W2/q+0+Ez1Zj6/vTJxsNmx9lTsgVr45kc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795405557; v=1; x=1796010357;
 b=AZ6GIxFiXyYvb3yzi1ie45t+JCI8YjlvB7igI1mXeblpvO+QZ/ykV/Alp2a/NQ1lwyR+1lqe
 d/L8Hf30fcByxeOHETETqcQaHFGr8nabFXdCVWMSS6E6kQ97WzY0GuAwQu59vjbqmZXD0O2/8Wp
 I9zJ1ylSjQZyHK+DgcMK4thI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1cf38e753e5e894b;
	Mon, 23 Nov 2026 03:45:57 +0000
X-Mizu-Trace-ID: 1cf38e753e5e894b
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
Subject: [PATCH v3 3/3] selftests/mm: verify ksm_zero_pages is not inherited on fork
Date: Mon, 23 Nov 2026 11:45:48 +0800
Message-Id: <20261123034548.237302-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123034136.209410-1-xu.xin@linux.dev>
References: <20261123034136.209410-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8oagorn919aqutc4ftxh7h5jo4p4kjp4
X-Rspamd-Queue-Id: 138CA180005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795405558-223192
X-HE-Meta: U2FsdGVkX1+PbBjSh0dTenaTcKOmQq1ZjoKsJFdltLQa1eFNkIldSQHgCbYVCdbBSmuGmSh/OR/N1QaAwE8zmKOccY6KGVLRs4w/FqYHyYLIaRXraJJlFZR1ihbrXcgbIshR98smrSHej2tcjKriZA2WDb19PHzjkCRnqQ1O1fIbxm6lQHVKCcdCaAn7u1Ih8bUX1nAE8+NWISn8OBinepk9QoIbQHh9QGL48KAVVJRU7og0d45cTsWvtgZgUSAq7Dw0u+ZTYdXAReMG02Vjl/yValgAELtF9etqK8sEYSoYvB4c9w8XfSHo55CnK1aXPPImTFVgPpZte4diCP/5ZdSmGzmPWL8YZXp0XEStHWZvF+ByEm/lgk0FruLrjFvlNKwHM+PqtC2ylRuugC7XxfF30tceEGnKjh6/B+/SwKkmLDb0MGP7YiWa0Tu/xdaKDgFXUbolSKls6ZBVO4UzT8lqY2ijG6/MqOskER5z1mOD9Udnua2YpAgzidZwABlacSWI3mE+WdkDk3nFnDmJWb8fpaVVLszqYc8Z0qThmunTlqZHalnzA/Bh5qEUcEaQ01h7x6W4dDnyKI2vK+l4x1HyM4utH2EJyxan/I2pfTCD4Rvz4f3M/Gu6MkYPR96IaWglAFbAq2y4uHF6PksPFRthSgduOc7fKKaC2F0zYVxh+u6IvNuQbH3iY8Y1dUaojTcFyuztPnIXRCDtW7Zx3KyR7YPKB2d27jr6+s5Ip7nFcK8rR2LwCDh72p20AY77WGJwb4hVec7ovUz40wWUJQ2PXQ3XlYs2Av8GDHIIL/MLB4HmhgvJH5kx0CmHt8buP2cWT7aIIBNSbN6S4xRdTXAxin1BNfG83x5jpL/SZs7RcMd0Bmk8tZsphbz+To9wtDGKWegd5BaXJJ8W1Sm1lNgqI+szDMfn6LMT+8w5LT5IKrK/ra2tfaYkr57mV5k1iEqSraFCCzPptcz393s
 uVAxWPLC
 ONA4eg5DHIuEA5xErUIjElXQ6LK0QEI4yRpwV4jyoo9kx71213k2yeNSsQCohStTH+Wfs4RUSjuxHDtZgG5wVlvLHZUMCf17VC6VE3Oy3L57WCWV+KeIUSA7PZkLtQF094m+HQj6FVz8Y8HxVoOGHBqrFnToRz0nfsHSMj6Fhnau5cVSRnseZ5xGawj11lraBTnwUuo0nEve/HuxNxYWg5sgY/ZBteMcJUEJS+VW5roTt4nbA8QXklebODeZFcbJdOtO8cISp2/HpIg2iT2WiMuPxpHFYYRhTmYsYrMW7Fndsicsj+AVuJNo2pqV6W7Xeu4N89fkrFIYBLVd22Yp0eLidU4Cpmb24mlfSsT2vrCkKLDLXseXHfobGxQtLO1WWmUKciQ8L43T9hTS25ewWQGRgzx48WgVU26tHQ9IH6BLeTmB9OY0eBWDuagW9yfy94R5YWOLuoYnDIqhmSkkZW4U/rNlA5e8nk+spAiDyt9iaKasUqgtd0ozpFhPbliIu7uBk
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
 .../selftests/mm/ksm_functional_tests.c       | 44 +++++++++++++++----
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index b871d5656688..0e128c579d5c 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -655,45 +655,71 @@ static void test_prot_none(void)
 	munmap(map, size);
 }
 
-static void test_fork_ksm_merging_page_count(void)
+static void test_fork_ksm_statistic_count(void)
 {
 	const unsigned int size = 2 * MiB;
+	long merging_pages, zero_pages;
 	char *map;
+	char *zero_map;
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
+		ksft_test_result_skip("read KSM stats failed\n");
+		goto unmap_zero;
+	}
+
+	if (!merging_pages || !zero_pages) {
+		ksft_test_result_fail("KSM failed to merge pages before fork\n");
+		goto unmap_zero;
+	}
+
 	if (ksm_pause() < 0) {
 		ksft_test_result_fail("Stop ksmd from running failed\n");
-		goto unmap;
+		goto unmap_zero;
 	}
 
 	child_pid = fork();
 	if (!child_pid) {
-		exit(!!ksm_get_self_merging_pages());
+		merging_pages = ksm_get_self_merging_pages();
+		zero_pages = ksm_get_self_zero_pages();
+		exit(merging_pages != 0 || zero_pages != 0);
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
-		goto unmap;
+		goto unmap_zero;
 	}
 
 	if (waitpid(child_pid, &status, 0) < 0) {
 		ksft_test_result_fail("waitpid() failed\n");
-		goto unmap;
+		goto unmap_zero;
 	}
 
 	status = WEXITSTATUS(status);
 	if (status) {
 		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
-		goto unmap;
+		goto unmap_zero;
 	}
 
-	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
-
+	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
+unmap_zero:
+	munmap(zero_map, size);
 unmap:
 	ksm_stop();
 	munmap(map, size);
@@ -842,7 +868,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
-	test_fork_ksm_merging_page_count();
+	test_fork_ksm_statistic_count();
 	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
-- 
2.34.1


