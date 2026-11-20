Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55EE0606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FbR+xUWp
Received: by kanga.kvack.org (Postfix)
	id 3B0126B05C7; Fri, 20 Nov 2026 02:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360666B05C8; Fri, 20 Nov 2026 02:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277F36B05C9; Fri, 20 Nov 2026 02:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 054556B05C7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:45:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61678120D88
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:45:21 +0000 (UTC)
X-FDA: 85454712042.01.A1A2918
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf28.hostedemail.com (Postfix) with ESMTP id F125EC0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:45:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FbR+xUWp;
	spf=pass (imf28.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795160718;
	b=WsHj2CQECzM4PJTValSpu83lCPu0fELeFubp12NkJ95hVKDnvbgYto0axQTzn92BdD7nO7
	YkSjZRiPggFQhoHmFhsScSh+9oD/yy6eRUlKc6By4s/6KTEzFWLBAaTTjGQQIn7kDA9ESB
	F/XJlWhokmR7X+nA3gS3RSOr+WGn26c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795160718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ep0ATggb/Y672w60Sb1w5LxlTuBduvlPJl1IN+HAHFs=;
	b=O1wnnZmsuuObxxg5QJODNBEJ/SPENoD+VCnJX5EXHX99npZS4aOTUMe+Kg3Qz/krj+OpaB
	/bOls+ECNwlXBR/Zn3LiRTuJMxa2R+aeZJj7ntgoCpsmcxVACNPv8YwAxgpebDdQ6HxgJ5
	MZ9xw2G0HQ4QBumGMjj2pO+DS37KV8w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FbR+xUWp;
	spf=pass (imf28.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JHnjnpTpVniuo9xfwgm87vmWr52+uUxiRXAA2RmX6ds=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795160713; v=1; x=1795765513;
 b=FbR+xUWpleG4L8SrinPmARyiWjNxfbRyL8Z0xOHi4DBGipC6EW1iXFawve4t3L83p2jHbMsz
 eZC/RwIZeyMpT26SU7r2wv/NQIveguxV29rPmxBgdsCi1TJN4V2CN1c13hGLt6u8DUh+KfGR9Fj
 cwOoBiVEN1hVuw3SdvwhtFME=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 158cbfe756fc8433;
	Fri, 20 Nov 2026 07:45:12 +0000
X-Mizu-Trace-ID: 158cbfe756fc8433
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
Subject: [PATCH v2 3/3] selftests/mm: verify ksm_zero_pages is not inherited on fork
Date: Fri, 20 Nov 2026 15:44:59 +0800
Message-Id: <20261120074459.41517-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261120074230.40269-1-xu.xin@linux.dev>
References: <20261120074230.40269-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F125EC0005
X-Rspam-User:
X-Stat-Signature: errhcmin1fujkwkho9tyypez5z1d8jo9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795160717-39502
X-HE-Meta: U2FsdGVkX18dWindxEXiRiZuv23rKoQZ5uX4BlMBvN+qgDyjOSxlRaZ3ybCKHwHyIuvb+dj1F3+kOk1hdns0nRbZjZHRClN8zyUAwhg+o/Ag6FJjWeMYk6JhgoTbdebxwlFdsCvti9uD05S9CzF0VKhDOVlCgiLGXOYAuQIwvRybw2Ie5NsTVicWa6kzOv3KhdnjOgWQc5VhxGulZXKp395dfmLb2WR0CKFQxy++SuTvL2ZP6F7E586ifBWS4HH1xtmQIVQiC5F9uEeqDJjIeD4OoY4Oo3NC2Gb4a0/pgqy9Nvw1jFtfy2G3Ye1v9Vi5obNwwJdu9+Z9MnWgwJzhQyr3d9ge2ii9RIleu8i6s0nBXLcVz4iMUXffSOEbspOGlB9oKHRkuH+jN1RYdAq22V1QEtNc0zlqYbFoZwf4qMOhv5Quvsgv6Fi7azigxWg7d1Urjzn4sEa5BmEf9ceqrwTju4KayKosf/pb6qJD3Y2KSanYaA/du/ZBHOv7pB5FZMu4DZhaP1wP5tC2921UQRraUwEK1llnOPqyYYFjUqbXx97X67PSAHnTtNpSByz4zzhr16m4ysdLtTIJSIGlwalMoqU3E6g34OsDQqmLengdWWqMm0091cnUDIEbY+p2/g8d/V8hmK8Udy7EUHNClx6hf82ZgzvcbX61wBRTFb5cfDDwIfzAv9hzlcfXXiYlk0nHTjjCG7auO5On254KOtGuD3R7nCmOwoQZYg0jzADD7lNEMDfcGtE21+hy2q5SFCx6VggN9fwtBWuDpNGwXt8Af9DomTClzZMGcD8F7fa3rlBWwLkiHedv/q2C/A/njleS/eNlzLMumVB6Y5IB72dzElaf0u9/Ti+Hp1XupvQd+9eshJn8gd8MoKecWzlV9+1EeLJVWP1iiac37UwfaHNA/YpEXyWCTU3ODSCExdTvW13lbblb5gprksVgTXMmvZp5w/EFjKyeLbEfkLj
 nVp2y9Ay
 4GasueB32d3ioSFPSBztcgkDM7H2/s4t9iL6UQyc3feBetx7ImJReXz2joFRJ30S7svksXY8y08Sv0l0EoMEYh4rtLSVpXQp+wQWmkP4m1q9U/Alkqmw1pkNzCoL+Uarrg2Di888+jgbqgO6aQHtQFSuAX2nZVmBbcYoO1mptsGWojpZA/PwJ6EO8lg8SfwWbgMEOJUFtINXzQt1vs+EWPeDOvIzD+7hrL5nInxC3rse63W6qkyg7xEZFIvEpXM46eztYeVysyxj5QGrgMJLX7uHljYpbPxdgecGYztmyflgoQuRshA6ghD3Cj03ctPYP+zUg7QCDhXyKk0pB9hrfIQW1B7r7KHi2RgbWPr5sjrEfKEO+YNnxYDRBJM1nIW34ZPJsxx9DNAVstGRoajhl85ZwQ+bytNHnx4CwQWNyMEISmtYyN5pbLh1jJvZo/yzNZijp2aUKfjpopjuqamQA6VCUGIiZQo7lioUuh3wUT39yFNiUDvBScPt1m5JekwzdEVDN
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
 .../selftests/mm/ksm_functional_tests.c       | 33 ++++++++++++++-----
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index c20982b0aff0..321f8abc85f9 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -655,40 +655,57 @@ static void test_prot_none(void)
 	munmap(map, size);
 }
 
-static void test_fork_ksm_merging_page_count(void)
+static void test_fork_ksm_statistic_count(void)
 {
 	const unsigned int size = 2 * MiB;
 	char *map;
+	char *zero_map;
 	pid_t child_pid;
 	int status;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
+	if (ksm_use_zero_pages() < 0) {
+		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
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
+	if (!ksm_get_self_merging_pages() || !ksm_get_self_zero_pages()) {
+		ksft_test_result_fail("KSM failed to merge pages before fork\n");
+		goto unmap_zero;
+	}
+
 	child_pid = fork();
 	if (!child_pid) {
-		exit(ksm_get_self_merging_pages());
+		exit(!!(ksm_get_self_merging_pages() + ksm_get_self_zero_pages()));
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
-		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
-		goto unmap;
+		ksft_test_result_fail("ksm_merging_pages or ksm_zero_pages is non-zero in child\n");
+		goto unmap_zero;
 	}
 
-	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
+	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
 
+unmap_zero:
+	munmap(zero_map, size);
 unmap:
 	ksm_stop();
 	munmap(map, size);
@@ -837,7 +854,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
-	test_fork_ksm_merging_page_count();
+	test_fork_ksm_statistic_count();
 	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
-- 
2.34.1


