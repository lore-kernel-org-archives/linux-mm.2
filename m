Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4580BF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF7A6B0254; Sat, 18 Apr 2026 06:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F8A6B0256; Sat, 18 Apr 2026 06:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9671B6B0257; Sat, 18 Apr 2026 06:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDF76B0254
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C1C81B7FC8
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:48 +0000 (UTC)
X-FDA: 84671376216.16.9AD44E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F940180007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBQ9sGuc;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBS5VFoA8nCf2wM7fktSaEQM95vBgqWXiAtFhyJbah4=;
	b=2f5K6XFXMjIul0/HPrL2gHmSxBTvOTOEYbRlGPoKMtlFNf98uczqkr7ZCENOrTqOa7W/PS
	i5IYzqERSyWGLjll4SxPtTlLNrBnvYTS2C1racw4DI6KQnqZAiK//akRnTHdodJaqx6xt0
	yu1oCtrHmKqHZupH8FhNdLRCEJ7PCIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509866; a=rsa-sha256;
	cv=none;
	b=0jKHzU2VxIvfJ6iFI7depJeu2fQfvuzFM+QtfA6RChLoToCJuHhsEf6m/wx4GyRUeqAxcs
	QXAr+s3xbJ1qRr6Z3EyLBAu+D7e+hMII5KRyvYrVeqn/4S7XPF8UKzLssDn7SAyEswg2cq
	G3Wj73JbjLmPp+luCBWeld4JjMnCQ3U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBQ9sGuc;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8215F429E0;
	Sat, 18 Apr 2026 10:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1B2C2BCB7;
	Sat, 18 Apr 2026 10:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509865;
	bh=iXIqmQSqfHYYzZ8gJikITuCG1TTtgUzd9IrH+Ph7iZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBQ9sGuc8ND3sdTN3dyO9WZSnOkQSrJWSWjbg39vQrimXQCSxGFyN1WMLgq/SKtxT
	 I2o4TDWj6A8hqHD7ICxGqXBFgxKlM3LKjYOqc84mQb94G8JDNnkjqaU1DnJN5Bi9X/
	 XyEh3MgNVqXKzKLAm8e3gA+McLTjXE75n9JI5kioSiIbOv0MNGrdqsuyoY2mCEttnv
	 zIDU3XcwMMJsHTbM3W/N0y36/bUHNKvDZO4kvhAAjasnZXGd34hOIteK8XxRr0X6VL
	 xHdlJqJlwIAbKsv4xJCdKSnPEsn1B4GCO5+t4trbAdM9/6ISekfupfZfQTxYekYtTw
	 AsOMljb6rJR0g==
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
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH v2 19/53] selftests/mm: va_high_addr_switch: use kselftest framework
Date: Sat, 18 Apr 2026 13:55:04 +0300
Message-ID: <20260418105539.1261536-20-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F940180007
X-Rspamd-Server: rspam07
X-Stat-Signature: gbd6ktzzu4rd65h1b9fjgu4d8qpsf5tp
X-Rspam-User: 
X-HE-Tag: 1776509866-262386
X-HE-Meta: U2FsdGVkX1+6BNglv0OJ/cnjaxoSFXRUyiUuv0P+N0yRTgSTviG41CaYfmtn59g/5u9e/y5zJHDz6nxIfQNzc478O5V9TSSMbCKPyl9e9y5GfjAMBIGhlM8xtVQMiT5nni28e27PFIfKQANPaZbYex3lkN13K8B67ugxbGcp01VfqFgp4hi/ZKhpVEMPw3+Gn1FJCvnRqBQm2+tFn8IX/QICPmMM/bh3gge12Qay+Z8Iqlma5KCv5RnsgfRDvU8I7+PTWvlSGLuf47lXeEx2dNzB5JjQsf/1NQBhy6gbR1I+BOVecO5zC0zXOsZJx96uNZdo8xR3SLPGx73GzTAwcPIlZh8qyRlFuMv/Cpx/fcjaLZSxLDSLHW4UikBfOForZgivbzd/5dqo77nc01zz6lsH8LFQsiBWWB5UGNzNCiR2nd158bpjmhiHI2IFpnKPj1hDjAgAP4DFhLmglNOxVHwWQuMo/VTUAo6O7tMdVgywu9spTtuEhkIEbjF9v1FaAKvKZNticklQ6cennGQsG4u2wR92hVUVy45zXKhBdkhHop3RelyYGufQUHlp17YSLiZHMBXqvtR9pvjUYOfBTPhrIhHtoht37Ps21uRWnN5gqJZKLX4IjzmtlZSwDmQvOV1Ji2gBTC42jI+DM8RYXG+u0+8MXsNdomltu4zWT4HsvctsZPZwQKw85ATiU3HK0JCaZqETxyl1K04nDFuK9VovBLiytGNG8vn4i2hgUcpedBwSmNTIqhjvK/NZCd+KItcpuOSVsu839kHtfZabpiko3Y8i+IHb18NAQ6d2/M8tNLor20pSmmQ5zrqs9ik2vcEfIN7XEVf3dEU3NM2rBvSCu2Van0fVXpAxHFenRjinCpwZDLkoS8najdzf8Y8t7cGypJHOTsH6jjx9WYxQFPI4jf7b5qPTwHheGailkweH9uxsFxtFZEXGwbWi+NxGyw99Rp/ZaCG+5vKw5Gd
 d2F6Cs0E
 PxSPSderdAsMEiBcsLRpe1MEatbk1oVoKisfWpuxWNwzebdzIPnog0NcpcJ5MUfm204M3MMlAaYSufz3EDfDKrwmS9BE/bCEi7VvARRlucm6bFy9++HIuWytNP7w+Vo8uFAmCxQ+zm1npUeNl7Zm9R4JXsb5a4Cc7Xj+5xQXRslNpwsmN7MNSo4BPusiNZW04VvzI49ITm39SDFyOW3NIQs65sZwbOmJk/wryeINJKTe/BdOf8tbu5TrqNaOODGjLsvzMqaNokqn9w3/s3KQiWdEB1ExJR+w29unq
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


