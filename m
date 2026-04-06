Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307CBF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996196B00B9; Mon,  6 Apr 2026 10:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DD46B00BB; Mon,  6 Apr 2026 10:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA9F6B00BC; Mon,  6 Apr 2026 10:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6C26B00B9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E36D160387
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:39 +0000 (UTC)
X-FDA: 84628339278.04.264A2EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8512A20012
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLc6Qalp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485177; a=rsa-sha256;
	cv=none;
	b=m7ETC8aereg9C3+O97SeBtabBU4/NnrVWSlH0tq2KX+4oWOFneNqxJrnwj69/qfwYue1BF
	SaeWZMJaJ3c/XMTzs9KUIr6epLGUt7pLWcnSNpx/qW+iiRfJ37TpB7r2kSkuoIxJ32qceJ
	BElYlJ0XMKkXQfkwPoi1TjxznBM5TEQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLc6Qalp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBS5VFoA8nCf2wM7fktSaEQM95vBgqWXiAtFhyJbah4=;
	b=X/jKkUFygi0InztvHYaZFAMvgjEZRAKthwyD/PcKkdm17qiQp5NsnfV1kP9cFUJ7quF4zG
	FPdyp7QKv2aF6yOqR5kC7q3JjBfHiLXfgQvUf7Uy8zNW9/27GljhK6WW4Sk6R4CPb2I/8n
	smC3gYselaZ4JQzO1nrRe6Ktw4yvKJw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1DE640B10;
	Mon,  6 Apr 2026 14:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CA2C4CEF7;
	Mon,  6 Apr 2026 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485176;
	bh=iXIqmQSqfHYYzZ8gJikITuCG1TTtgUzd9IrH+Ph7iZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLc6QalpBraC5bfXSjUsA5U3MvSHiKXzBUB35WUS4ol6/z/SMEqn/C8m3vU7XtEC8
	 DdrxRxs30TSd+0tSSFeqFFwfauRYNvFZ+vAIlbx27CCqAWPigY8LPaQCqbfvLn9J1y
	 xHI3gz7m4a8bwWqSIPvlUFHi0sN3cYKnIWUCJ3dHMBYZDSEa+gfSZXCB+wahdL4R5U
	 Mzc6O9/fAdGn37DVM2WDsVGLHUV2SGaRlU8Jwt+/rw7wz5nxU5b6Uam7Yy3cayJuIb
	 6RFCdfvABnZRfPCOegta4TV1KrKPDnwZfEXeEx1YHIVnoRQnM2NQH5G+u6cDoB4K2j
	 aRanWpYij++JA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 19/53] selftests/mm: va_high_addr_switch: use kselftest framework
Date: Mon,  6 Apr 2026 17:17:01 +0300
Message-ID: <20260406141735.2179309-20-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8512A20012
X-Stat-Signature: eukggb6bkf7naaod56rjbdjegbfyh4if
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775485177-909110
X-HE-Meta: U2FsdGVkX1+zpaTis7P6AxnhGkwPgHjz4mgr91xITk5EajE9QEVDqUls+9NNRjTrcn9kuHUUZYRtPLAN9eqqeqbTpfwq3wIfrP1K7+o8SrUuOpvtxLiLGdILeHRXx/pa5YOwVNsm5xVBwALv21Be/5ONyKF6kGfMI6W0udrPdvbg/1xwuCztKcJ8b9cZ8HG5Q8pxiERfCo+DGltg/FAU6Y1nylg0y0pxYHBN9gLn7/lLXhFB2SZP3l+5rcoS7ckOTp0pON619/tczH/1OboMliBXIJ+7TaWi2Go6/Kj6Qp3J1SNYfbqLPLb56EkOO+2tgzWPU97qFOOxuW2KmpxDTRjLR0Tv34jO6c6g0xLBVpcpVAQutJ3JaTKKE68dw1PSy8gspT1UG5cKkviB9UOMgk2j2f6hM7kff93FQD8cO87Fcp3WP8Ndig6zwRsf46BSxnywvvdZW/JbQTEnZYFSRlZM7qsi7aTXoUtUAA8Ch9WvQT8yqVUWrwF021axdiA/PgD6pJurP8/+iGM6vS4+aHpDuPX11//zhwDZh7a6CvmoGwaysb+slyGXjXio3vTg9IVTpAdcqeD+U8q1mfhv50FJA2IMsn3LmQ1pp39fY78bNY6bPZadckTA474loXzf/zO297cxHIoxBlMky9XVql3pXpvV0dEp6ofb+O5sVQgvmTmP15n4Cfwrxr1c0ejovdYwY/TpTFJV6oBi8K9IIqSz8CsH99Uec1B4+LrnnwcOLctr9yTLZn14L5U8ov+l/z4sSAqKmmgvhE8lzH5i9mk5l1bXq9m6lIQHZIvz+3zEWisjvGQ1jz3UMJCU1g6IX2cpCRWFeisWO4bN/IjK/+tVCqkoLaDYC2QnaMhCuIX8IDHigDert/2wmDjStYUAQA7y/ogAKXd3K+uKkMyXwJsbYhLHk6M4vlC2J44qyqNMqqhnepJLhkm40+1OBSmwTC1klFe4r9W8Z2gSy6z
 VcRUra+W
 3m9KiM7PVRwI++BYmBeLLmoFshB8RKln2I81ViCpZW11/1XveT7kJK+yhR+o3U8ezRwQ0tkZnc/Xo+gHVVW3dzxJtYCX8HP0X6Cxid55hE7ulpy34WOuQ093e1D+U8S0liH8Ku6gAbjxIz8lD1l+FbrLxYER930wlv0UfpldNZQcRppwZJmNj74zOx6InP0626p/30UWBnHwTDXaimL6Tb30gKodSik8ihV3sJTmg/0qf4g5lDirkSJeJW/cakufhRcb0z3F5YQ+rhzZBt59R+bQcJqxmZRsgPeiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert va_high_addr_switch test to use kselftest framework for
reporting and tracking successful and failing runs.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/va_high_addr_switch.c        | 39 +++++++++----------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
index 51401e081b20..5741fd057640 100644
--- a/tools/testing/selftests/mm/va_high_addr_switch.c
+++ b/tools/testing/selftests/mm/va_high_addr_switch.c
@@ -257,40 +257,33 @@ void testcases_init(void)
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
+			ksft_test_result_fail("%s: MAP_FAILED\n", t->msg);
 			continue;
 		}
 
 		if (t->low_addr_required && p >= (void *)(switch_hint)) {
-			printf("FAILED\n");
-			ret = KSFT_FAIL;
+			ksft_test_result_fail("%s: %p not below switch hint\n", t->msg, p);
 		} else {
 			/*
 			 * Do a dereference of the address returned so that we catch
 			 * bugs in page fault handling
 			 */
 			memset(p, 0, t->size);
-			printf("OK\n");
+			ksft_test_result_pass("%s: %p\n", t->msg, p);
 		}
 		if (!t->keep_mapped)
 			munmap(p, t->size);
 	}
-
-	return ret;
 }
 
 #ifdef __aarch64__
@@ -322,19 +315,23 @@ static int supported_arch(void)
 
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


