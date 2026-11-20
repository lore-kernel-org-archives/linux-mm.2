Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA8660A2600
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rIr1t80t
Received: by kanga.kvack.org (Postfix)
	id 7323A6B05C5; Fri, 20 Nov 2026 02:45:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709A66B05C6; Fri, 20 Nov 2026 02:45:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FC36B05C7; Fri, 20 Nov 2026 02:45:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2416B05C5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:45:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACC031A0DA4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:44:59 +0000 (UTC)
X-FDA: 85454711118.26.D84E0F4
Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	by imf17.hostedemail.com (Postfix) with ESMTP id A880A40009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:44:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIr1t80t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795160698;
	b=ZvlUGFTNBkk/0SfApIIBwCa/h9eSnS4IkQaC3DcE2Du4T820F9aUjkuJsdxSDcvP16VoLL
	cOMKhlRy8rkcm2c1JH9PpEcDPxnueYAIavqXZ61Qdd/2qv9Re3TnEDib9c7nHt0CLSRNyU
	nl8NguhShrKh/yEcWx4LSVFF/4xyIqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795160698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lxi6unjVQ4QMAgeTvpwgXSWHJFUdnkiAu2/vuTAVwOc=;
	b=l+jBDuA5f+SD+9K2/xSyzT82fUxhhT5kzJTNUb//GRx1Wkt8URmQa2GNusYu66NhwnliNb
	j8dSsiRVFc/f46VJO6xo/Zb1hNPaoag8UVRkJNIA3+0rNMmL1upjec36mJzoAkRntaw/WR
	aWLFDmzgFhG2QtIPr+8P/5FkYD+HXK8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rIr1t80t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lB7kRH1Y6c45DRzOiYxWXvEym+deCOdTIknp2BnEVAM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795160696; v=1; x=1795765496;
 b=rIr1t80tmltB+JcBtrDnIX+74N1Ia1PLfMhBevXJagxvm6AAdWGnvC0fBlJ9srxtn9Zdm4w7
 efcOzUMBCDEYHpPmrzEUJd7yDaoDu32JPJ8rsL3Ks9Vl1oGeW5oJV+M+d5a1USVsjt1Fmaw1o7s
 zGYYPvD9GCuMdLtbNAUgdkCo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9b268e6d28a98aa1;
	Fri, 20 Nov 2026 07:44:55 +0000
X-Mizu-Trace-ID: 9b268e6d28a98aa1
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
Subject: [PATCH v2 2/3] selftests/mm: fix false-positive KSM fork test by dropping init_global_file_handles()
Date: Fri, 20 Nov 2026 15:44:45 +0800
Message-Id: <20261120074445.41446-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261120074230.40269-1-xu.xin@linux.dev>
References: <20261120074230.40269-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: A880A40009
X-Stat-Signature: 3tqu6xbanpmyrmscg7fhokmhdyry4o44
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795160697-24081
X-HE-Meta: U2FsdGVkX19xpX30dYP8G5VQaw8sQxstETLEQvhMHPCdDdyBlu18SiEmfgBEWLOhbHPpp0fX5U7xxN8r10vcfxjOOs1Dar4Hle6loe3EeyzwpPDMP0M4ShnDmU4xH5f99A2h4C6/B1s0LOVmXsD5QqR0+1MtxkXBxLGgp++DuOSU0cB87G8dQ6YbYXpgBMl2Wd1qDyJnZ+CUCXcsmGWhLZI/bSSIIzoKX90763zmzQjCw3l58PM/9e1OreGHjAFAosWNxJ8YslBd0gnktP5tMi3SpClgAmkxGnCGdomomqqoIGax+XqeW0z3auG6nrXDpM1LlmPozZLYtbpYqILWWJwQ2lNrEnKyvnjIm+6Mk4TGSxlUp/RBMgypesZBjong3EgoGMBSSAWXzgMGTL0fESseS/Uam3v3iPEvmpyDnr/Uaj0jWeOAggz4fiF9KSQnYBEIqaSUCRRvPUXHJ2NKiFWE85786lQ5nJ3jFnyPrTbbmBrfxTT+NKUX+ypr9aGpxBchkxtzAXzFRZ7fyw3uY4OLFFOicSYmTNSGKBo3ze9uSvfkwFUl4/uSNlynTtP+o4sbn7GnyaihVGxyD9MtwOly77i/b0iI2tW1CfqlmHx4CAybu3cwFSv9tzefuVGEZkq687ClVcLrDqGHrLiVegE2M48ZGT7sgNHO5jqsQFZmgtSEhbNinNrIXOIcWanJ6ebhuV/waGV4UmeBPElA9hPQq9T14pKH+2Jsfesvqami7T3wdEliLgE3AhlQsLGfL/Z8A+QCEXnV3OoadgrQY/Z5UoHIqSniEGQyo5HFy98c6yYjZu4fC7O/zS/ErIrLx2+ll9DgpIyn0ALLUOmhDMRzHxub8Bc2vixWVTMYU3Rt6SMXxl8Ju9TyAhgv1S8RNQtyFkV8X6Wrk2Cg8wV8QuGqQ1FhFBFx1UIgUr2Op9XlMCjDUOX7MLN64yGFrYdaglxl8Mp0U8lPsHvj46W
 aLOL306g
 gv0fQxyTo6nXMPElw9aNqrDohq1O4GHGXoQvqtpysqvDGSqQ6oLopVzlJOgfEazMhYioZl1iT7flTptfUczrMAWDtNVDvscI4H3NGTolg9DxOyqPOPqGEatVTJcElfMe2wlqrGoyn3VnNk3Z1501STDs4xyWHgdPBzJ3dyxIGRi6HvKqa33vnlTuxauLzNJobxXdyQll76mBsUZuiYkPf2iVc5Y5zUZxO42MOMOUODxkx+kkhtJnTLr2IPm7UBacg7DrWgMED+P5xnoGkxuiDfjKzJrGi2yPCUOvISB+0MgjMV7MZ7qWgWlwOaU3JjfdTO79s3g+kwHrX/cTA7n0SuAa7Q0yOcDug/9Gclp1ho/2xUnTwc2wMBCOrneO07f3LQPMrI0eJmsXmNl8/BDfPvfcoSrf8wMN4j8Y3ePF4kV+7sjZ8fxccYwe3EmooUZDIMFXkF3JriHaP5/7pYihPeLzJ1cqgSaFqit07PPt13EFtY8tlOIRe0cYq7c/AO0WD9I+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In test_fork_ksm_merging_page_count(), the child process currently calls
init_global_file_handles() before reading ksm_get_self_merging_pages().
However, init_global_file_handles() calls ksm_stop(), which writes 2
(KSM_RUN_UNMERGE) to /sys/kernel/mm/ksm/run, unmerging all KSM pages
across the system and resetting the counters to 0. As a result, the test
always passes regardless of whether fork() properly resets the counter.

Remove the redundant init_global_file_handles().

Fixes: 08ff89b5659d ("selftests/mm: add fork inheritance test for ksm_merging_pages counter")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 135191f99962..c20982b0aff0 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -670,7 +670,6 @@ static void test_fork_ksm_merging_page_count(void)
 
 	child_pid = fork();
 	if (!child_pid) {
-		init_global_file_handles();
 		exit(ksm_get_self_merging_pages());
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
-- 
2.34.1


