Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F036FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93DE6B00F5; Tue, 28 Apr 2026 16:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6BA26B00F7; Tue, 28 Apr 2026 16:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8296B00F8; Tue, 28 Apr 2026 16:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89A3C6B00F5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5866AA03C2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:16 +0000 (UTC)
X-FDA: 84709152192.26.B5FFF9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C160B4000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RR7cpHE7;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrO7njVxu1EmFkDy0NC95VIXGZ8qqqcrewE7eMpxa0A=;
	b=4GkAHik3ov5b6P5CLvKW/YqXfHWJBHniamdaTqd88PSlJUbYC8E2b/zry6PqEwclraYxUh
	/zP+bERDmeX2p57YkbypC5zsSNWdGKO5po17mTbv5PJtN5aWhLtCVQHmxVlar/EYmbkMhM
	NXz7fqqpyCB33ijf5jCcTIlq1QuGnQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409294; a=rsa-sha256;
	cv=none;
	b=FGXkhmj8ICsmxoKzKNkCsjSo8hXYlD0XyUZuDkBJsTJiVjX3U2IUZlrNZ8CTLDmnwwRgLo
	CIklwRQ4wGXue/NhmVq8uMEP+XBQ5EuryfPjlDLCmIOa0h/Cxg72Tu1LisizfiOpjFEQ7G
	1XuR8X3FChj3SVzEYP1vkBWjgMaxx5E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RR7cpHE7;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45D2361119;
	Tue, 28 Apr 2026 20:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D60C2BCC4;
	Tue, 28 Apr 2026 20:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409294;
	bh=C8Qz87BGrLBhc4P4E9wehTmUZkE5iKzjerVbkLBntAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RR7cpHE7thWHO2+9FeEKmkFhRFBUzwIJiQBh4ygtYGyuaZQqIMQjLpWatx0lOAOwn
	 JQsk+vM2+cwevsRrpF/sFfmtzZp8en2eiVqRRExGdlNe+oG1VJJYBPTgGYHbfGK1Ji
	 jVZaWRywXFcJXKaK9WzReg1cQBJyjBTB0rqAJjmdU1GI1Z4TMhmzVrOwiOZ0IGD3mO
	 sEwpK4iaUg4bXg3/DxvpM7PPOghqX3mVuZidp0+8yJj+CER2WVK3tGGQi7jfejWWNj
	 KdHDSrJ+A9o6OLcqGM4VBhQutBlVHR6LP7Zyq93rtsKII1SoOHBiWBY8b8u5Qyyn8V
	 le9F9rhpfuPJQ==
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
Subject: [PATCH v3 49/54] selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:35 +0300
Message-ID: <20260428204240.1924129-50-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C160B4000B
X-Rspam-User: 
X-Stat-Signature: pq5sz4um5bqghff9n8qx7ptyzfqipahr
X-HE-Tag: 1777409294-553589
X-HE-Meta: U2FsdGVkX1/ZRrvNYswfLHMspvz63p/3PvVllkfMItySFu3DoKLffe7MV2f9AianPOE43fQmW4IpazBSrnKqdWGTWvOYleO4lLn6taoKLBrI5/DQ+iJiXZczzVxDvStYI1N1k+0d8s4VseVZl1/UviauMubhDwmwGSp1oF+buDo21b4IoVLjtybOpOzBi6Eco0cyMcGMia5NVkuxyID7tdZVLApzMUkkGhE7W6B3JtH1tunK7nZXkghEWmtbaiXErutpxZPKZZcvC2GHt8cfCJZh3pvifsoZJuCwHhSagdXTqAcvLmVfVrkWBj843yIKTb1YBfF8efOhzSIjRgM2bMrMia++39vv4OG3jeIM5YrY9z2aGv6wEdEh7AUrZio19yp4Q5+RVsharwaa1JIM8Gxcs/yHNI7txuMNuQZeZoS+YvpHO5DaTYg77HG+0PzCwqdB3STA9YcpEmFZAdBDU7A2qFFFB6v79JXwSwAOAldV4oJLIyLMRjwLf1u7/VNoetKKsz2Z6Jaxv40L1SlBO13dfiGMT0jKpAJ22nPlaJZR4eb2lNy5uYlHlHjO5OYgy0jyc7pQhRY1vHcvArl1BSdkav4sFPkkEtEUhzJimYDysKjlV31RiottzAph1DSe6j7Ier87oHDshbSf8/6yEbKN1TWH74MCzg469sxGOM5T2ttuDIRlK31t8r6G6ptYQrdWQzFhABzgPFtspd0ueL9QqcuSRWSky5YOlkk/Ecd+5ITYzKzn+1+Byl3EMPnTCPj9ZptpPBp4pL6R4qyuLpjawYtCRB/ZVQ8+3M8hIrysGZnq3WC8deNWqv4OtTCWBQIidoqpggy4dY4l2FzmFdyxRDsj9VzIdazBCt3Epmnh8a3nTTXze0RL+HWq3wKeKXwPsv5LnvXHqpNNt1aWofOrHuEnR2uJw9+Qli86b0Rpax6mD3ohwtENMCdHn7lyTrTjEgYczoKjoFCur/y
 aR5q0w5k
 /yl3CypWT81iBLlg2sHA1eiCWkp8OK62AxW8VYq+kUkiyfZhlo+F5eSl8a+GyvFify9WK8L/Gcw6XevKaHKIY79ZYwnUMRwsJY90TB4B60RBfeo4boys59la+Box3wSPv/sItmR+y7ZGf3+Pq8OLTt2FcPjBURo5MMHDlEHSdLHIVEhfIeP/BOEyAobY7z+Ce9wyGWXCNp+FuSoj3sxj3CMjlozXbahtLOWiQq6ZMkF5Wa30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-unit-tests skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 31 +++++++++++++++++---
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 1a33db281f8a..20e1829db91f 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -305,7 +305,7 @@ static int pagemap_test_fork(uffd_global_test_opts_t *gopts, bool with_event, bo
 		if (test_pin)
 			unpin_pages(&args);
 		/* Succeed */
-		exit(0);
+		_exit(0);
 	}
 	waitpid(child, &result, 0);
 
@@ -773,7 +773,7 @@ static void uffd_sigbus_test_common(uffd_global_test_opts_t *gopts, bool wp)
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(gopts, 2, wp));
+		_exit(faulting_process(gopts, 2, wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -827,7 +827,7 @@ static void uffd_events_test_common(uffd_global_test_opts_t *gopts, bool wp)
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(gopts, 0, wp));
+		_exit(faulting_process(gopts, 0, wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -1706,11 +1706,32 @@ static int uffd_count_tests(int n_tests, int n_mems, const char *test_filter)
 	return count;
 }
 
+static unsigned long uffd_setup_hugetlb(void)
+{
+	unsigned long nr_hugepages, hp_size;
+
+	hugetlb_save_settings();
+	hp_size = default_huge_page_size();
+
+	if (!hp_size)
+		return 0;
+
+	/* need twice UFFD_TEST_MEM_SIZE, one for src area and one for dst */
+	nr_hugepages = 2 * MAX(UFFD_TEST_MEM_SIZE, hp_size * 2) / hp_size;
+	hugetlb_set_nr_default_pages(nr_hugepages);
+
+	if (hugetlb_free_default_pages() < nr_hugepages)
+		return 0;
+
+	return hp_size;
+}
+
 int main(int argc, char *argv[])
 {
 	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
 	int n_mems = sizeof(mem_types) / sizeof(mem_type_t);
 	const char *test_filter = NULL;
+	unsigned long hugepage_size;
 	bool list_only = false;
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
@@ -1745,6 +1766,8 @@ int main(int argc, char *argv[])
 		return KSFT_PASS;
 	}
 
+	hugepage_size = uffd_setup_hugetlb();
+
 	ksft_print_header();
 	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
 
@@ -1771,7 +1794,7 @@ int main(int argc, char *argv[])
 			uffd_test_case_ops = test->test_case_ops;
 
 			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
-				gopts.page_size = default_huge_page_size();
+				gopts.page_size = hugepage_size;
 				if (gopts.page_size == 0) {
 					uffd_test_skip("huge page size is 0, feature missing?");
 					continue;
-- 
2.53.0


