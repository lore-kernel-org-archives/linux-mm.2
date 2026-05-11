Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49921CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9BE6B00FB; Mon, 11 May 2026 12:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A986B00FD; Mon, 11 May 2026 12:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7DD6B00FE; Mon, 11 May 2026 12:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FEE46B00FB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:31:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 540E61C00D7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:10 +0000 (UTC)
X-FDA: 84755678700.07.262C703
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5F10240011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:31:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FzN1MA6c;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpq77kpjffqNvJOULBkTgFF2liEcPoOiqix51O0Tu94=;
	b=RFbhVZeccE9Roq/zb2dxDWdRAfJYE0l1RU8xBVb7wyIC+CfMcCJP/Ymicze1fMbgHsYh0E
	qLzU6otyNye1yzOS8HjQOYaMiHCq460P4YNDX9sA51noB2Ca5mglrYkWMSPvTMUvtBVgG/
	8MtqAxKasHWu3+lxQ0ed6v23BVvQpw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517068; a=rsa-sha256;
	cv=none;
	b=LQecQSyJIOdVDPvJDLjlPZhNgWSlCiszXP4xOR+PLynzDTP7Vs0UiXDGIetvPjLeQCz20c
	VWOFYudRgjg7rPlXbFRMO2lUW/GjjXZOqL+fzFeZaobEFVACf7vT5I03GDZyLBOqXpdKK2
	S3GEmIfEus9AJyEl7BVQJuo5Mc/9VAk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FzN1MA6c;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8927440A5A;
	Mon, 11 May 2026 16:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67543C2BCC9;
	Mon, 11 May 2026 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517067;
	bh=TUaLre/sMwxUr1N47mGs01d/9NCciABJgMJChwaRpDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzN1MA6cHDOaHTNHNqtwii36Ga/OSqkuv81ry1CdmJogggUUt3wGSwyco4tE1/Xo8
	 f+F9Hy/UjqeOT5ICPf7laGnjXm65Wt5IihlYpsQNXZIZHRg1KFeKGXuTKa6+yBZW/t
	 EHZ22aiOlbevdwDcMUpdUTk8/cxQauPcWJpcjZaSRbMv1DXWahvJNVUVsofKLrJX/I
	 +xEXJW0iTcSRs40DqjLnbI+W2atdD1fT9A58jkED73JnlcpeCiy9XGKEBxzAGsSzMM
	 6NabsgM87OlpfwydgQRBM3k/TfcD9cggaz6BwPAhVmRlYlUCVGCubyUWwEp+k+E4lf
	 DPxEhCtO9f8nw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 21/55] selftests/mm: va_high_addr_switch: use kselftest framework
Date: Mon, 11 May 2026 19:28:05 +0300
Message-ID: <20260511162840.375890-22-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5F10240011
X-Stat-Signature: 8cjjxnf51dg3w33g3i4cmknxg6n6a5tk
X-Rspam-User: 
X-HE-Tag: 1778517068-100525
X-HE-Meta: U2FsdGVkX1+xHKvQV14PTKO+TGML1TAUjeyKDxz6gGYtc33WXEmg+4o3fWE04g8i2RbT4ubqE3SCgLJheHEWz4w96ychjULKguQFuwBDrUPsfnShL5eE7O20RPCknulWL3tmsq8c13T7CbV4Kf4mi4KlhnX7NCXr7eOWiJ0l7kpD7z5oPcGvvjJk7uSHFa7PTacMz9/VwBxg5A78b4AVkgIfG710QbFbWV50QmINWKNhAQfytyC7WhO2Ww9QkCcxuKbIFUEYwIHCLMHrRn9wS9LJ3uP6UrVxGoz5Y8Ff7UZIoiwlUxb2s72SbOJdgSg4qtD/aRXstOI5vBLpaVZN+JFgs/oM9FzCV8Aym8XOHd7gKURrSOlJMK5y5fLZdeoTYIoeSNUPnssUs27yUD+wlIPIvQYLeknduseOqTfxIcmud13zs85ToKJvN2/AWXvAO8fNk4wjm2njP0cDBNxFMDQr8cM21rJXFWcsL9IuAUZGw+DMDzDmR1HX14hUOFM3LEvD2ADIJu2PM6GmXOk4UFudPGLe+3x5XyMfKU58b87ciY+VBWp4Cj8z8wVD8xe7dI78mX7nXXwE2vI9N88YCCtaAJv5XZ6QiT1aVGkVPKOb9r1Ldq/cSD6DQ8cXPxXrpsuxLrRymmPPJc+z9MggcLpGR4XOYTGLE94HB4u6EjNwrAYbQP4YYywLWb4egWhYWAX/ouVk5NL7mWOvORL1irXp9mvrZypYhgwS3Dlg6RRnAjSP4kEu5uQ98b3njYdJXOInUc9ey9UwoOAkpfYwrH3jhyPovT+gI1EeuQyheyiXeYfvv4MdCsxmTJYothgj2XiHq69sruHrAQ2T3UR67gDynFNI5afC1jEskQF3kJPkCroGJm0ubnL79aWrI4RzKrNO3Zk7rBfqJWUI4ONbbqpWJkwbG0+lNvHqdQfxnI2ZCHX0de4HnQo6EQSEb65rforHBaonGca9tS96nQZ
 NC9pFS87
 2qk/iglccsmLMbHpztYv5Umj+MQCISBIBGG1OSlqv+gT7gYJvdSC11EogF7eUiGiFNHdVvP9qgnz6UifZdWuWwMLmg0qbsATa7bu3JvojnhFwRLdWGcYX5neh/EfEC7WQ02edCdf/QlBcDmGNBiPJW3wbM0tyIfODGfToHGBmLEyEUr9Ew9jgRZx/IhcZJQpdlIqcj9VdRLn2uXDlhSBQUJ29p1CW7xS/BRHRqh/wC1dfo+TUCsVhZAq3YiJAiNSSMA5uPee3f2EEHwoLPLLVV/64lSHF23RmkhxvMRadXK7k/B4W6kivkvwI+vA9C49ptXemCse4BhRHV27FHQkMa9mi/dX2WtgG3Z23ZG+0p9p8BNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert va_high_addr_switch test to use kselftest framework for
reporting and tracking successful and failing runs.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/va_high_addr_switch.c        | 41 +++++++++----------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 51401e081b20..5d38735ea60e 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -257,40 +257,35 @@ void testcases_init(void)
 	switch_hint = addr_switch_hint;
 }
 
-static int run_test(struct testcase *test, int count)
+static void run_test(struct testcase *test, int count)
 {
 	void *p;
-	int i, ret = KSFT_PASS;
+	int i;
 
 	for (i = 0; i < count; i++) {
 		struct testcase *t = test + i;
 
 		p = mmap(t->addr, t->size, PROT_READ | PROT_WRITE, t->flags, -1, 0);
-
-		printf("%s: %p - ", t->msg, p);
-
 		if (p == MAP_FAILED) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_perror("MAP_FAILED");
+			ksft_test_result_fail("%s\n", t->msg);
 			continue;
 		}
 
 		if (t->low_addr_required && p >= (void *)(switch_hint)) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_print_msg("%p not below switch hint\n", p);
+			ksft_test_result_fail("%s\n", t->msg);
 		} else {
 			/*
 			 * Do a dereference of the address returned so that we catch
 			 * bugs in page fault handling
 			 */
 			memset(p, 0, t->size);
-			printf("OK\n");
+			ksft_test_result_pass("%s\n", t->msg);
 		}
 		if (!t->keep_mapped)
 			munmap(p, t->size);
 	}
-
-	return ret;
 }
 
 #ifdef __aarch64__
@@ -322,19 +317,23 @@ static int supported_arch(void)
 
 int main(int argc, char **argv)
 {
-	int ret, hugetlb_ret = KSFT_PASS;
+	bool run_hugetlb = false;
+
+	ksft_print_header();
 
 	if (!supported_arch())
-		return KSFT_SKIP;
+		ksft_exit_skip("Architecture not supported\n");
+
+	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
+		run_hugetlb = true;
 
 	testcases_init();
 
-	ret = run_test(testcases, sz_testcases);
-	if (argc == 2 && !strcmp(argv[1], "--run-hugetlb"))
-		hugetlb_ret = run_test(hugetlb_testcases, sz_hugetlb_testcases);
+	ksft_set_plan(sz_testcases + (run_hugetlb ? sz_hugetlb_testcases : 0));
+
+	run_test(testcases, sz_testcases);
+	if (run_hugetlb)
+		run_test(hugetlb_testcases, sz_hugetlb_testcases);
 
-	if (ret == KSFT_PASS && hugetlb_ret == KSFT_PASS)
-		return KSFT_PASS;
-	else
-		return KSFT_FAIL;
+	ksft_finished();
 }
-- 
2.53.0


