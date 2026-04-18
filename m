Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69734F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D393B6B024D; Sat, 18 Apr 2026 06:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8D36B024E; Sat, 18 Apr 2026 06:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7CB6B024F; Sat, 18 Apr 2026 06:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A60EB6B024D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:57:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DB59160478
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:23 +0000 (UTC)
X-FDA: 84671375166.13.2FE1D6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B794F140006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:57:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JA11blZm;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UYFvByeyweXL0AEx2skYIFr/cr52VnxWvTq2b7HVVY=;
	b=4svIa/HXC7EdQwEvKXwwoOOuBEwAfJuW91eFMx92kMmafu16sRTFDY7K2mEKnpRglkcfN8
	aBhdKCObpC4PWVHTkSRuPYOQmRcqf6D5YMBsSRHxu3IN9jYZZ6MJOwkrHIe6YBWyCKKsIq
	HDqsBY7qpUC9MAfEIQO9VatcqCuFCkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509841; a=rsa-sha256;
	cv=none;
	b=rcqBjRjPgz5UYa3ymYLuCwn+ELm1+l4cgYNRVaCBqqswm6I2yNut1v8BY4qL0L6GcKoRbT
	OtbfA3yLYI91QezQxXtQxVbmpWwH4a5OhOyMXGjsDAsHEZvmgThLGCa8ox0HXTi0D5lS0S
	smhaTh50vhNDWTMY3F/GQFydsBI/XXs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JA11blZm;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7EE14036B;
	Sat, 18 Apr 2026 10:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3009CC2BCB6;
	Sat, 18 Apr 2026 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509840;
	bh=jgML03owjuwuw1ifgkKAMic2hsKW59SUULtZZqWRifc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA11blZmeeT1CDH5pnZtAZSljd8iH1bFl2Vg6IsLqry9QGajJbRoA/2CF+svpw6U6
	 SpRIOxUcshHIfbznsjwvXC2dXP8CHuN8O6kdtTuM28P+8BDDzsZZH+gAhjRHGkEF28
	 a3eXauc2sfIm/Q0XjfT3z3eOZb2ph7N5PoLbIMga7iswclOnd40T4zSXBLLTnRhEbN
	 un/nEdDfM0CHj+8EDD7pXA2Lra+vuBROBMk3PQd05iupdrQqnQYxblgekJiafDKFT6
	 N3RNEUGRiPxt+jChC44gzG5Rw1T5HludyxuWgKWFw5XEdE6okAcs3NyCkedNaXbkdr
	 Ewvcn2kFwJi2Q==
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
Subject: [PATCH v2 15/53] selftests/mm: protection_keys: use descriptive test names in TAP output
Date: Sat, 18 Apr 2026 13:55:00 +0300
Message-ID: <20260418105539.1261536-16-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xho15pypzbcex585xd5gdyackk1jgp7d
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B794F140006
X-Rspam-User: 
X-HE-Tag: 1776509841-144275
X-HE-Meta: U2FsdGVkX18l3YWC8qbvSDqmbCwEbrmEFeh7TRGtCOgoiQwDpZuspIGScUvmGRn/6cKHFubJjxg8UVYIwE8iLIrtLTQp/ifXliTKH7TOPNxPY4CslrJ2Ybhyp+2RODE813QwZIud2CefjRqXeTkqBX4gwzFaWV2L0jRR7J/XrpBuL5GJuveM++JBLsFAKr5Y1rKo/m2eoKuGxNSFDIq7CYtcNNqEPrtSn1C5WmabTqa2LDXrENwMydYPUek+6iIQlRKfPqRU4JnTnqR/gkOEpjLobllOTIeMiShzF/pU3Ee7F9XpcIMiToG57uLWtl4N4IVGdpG/6l9WzrAfNC2T4q2ccGlEf/x8cbRp6drG0It+4yNZehizlpXUJIpYKyEAcc1E0Xvs/kwApnNkJoG0zEOtNWwEerQsgmUMs7K92+wz0PESOojArRwaS5zSatIRVSc3LItdwMkhCArmFrzuLHsmTfyqMZ4CQ6lCyZ7ucXFqqCw9vENL5ArcO9uWEl0WrZy6Zxx9OA96l7aID5HWqrI6H156U2RaXl8WNfiZUWxin9/kxHgKUtCN0oRy45ceEJ9lD5uEiJmBdbfSBjTuRPquxsSXPeAsPQs83yXTf72tlvssZHJvFn3mUAaz8DFrxJjGsTdebJ4AqcfVCG8+r9djMb9JYolj63z73L3UhNWwz4T4gMNFfrK9ZAb58idJzDgk6sab1qOAjHdXjXrdTMQpaOuONTptjsn4eDF2/2Ve+0KaoPnWc2qsV0omBFBu9Rvg1xnUzVU2wrXGVV5f0B5hT+36UDbzWj4stiRQzQGguAoFhSDnsC/QriJB9J54x1ipBrOuxwGXp+gsP5A8PiXgSX8gZsxUTeqgeJ8zM98lxs4DMVlPR368kMQf5OPakZvJoibF/DlQmx7weauml5TK9sLyjK6ASDqO0vyQgM+OfME0Mx87muPb4R69hywPKafK3LDbl7XDnCPi2TO
 pL/eArgg
 ZPc5v3YoxUQQBtUvsi00TXVtMHjLxQV4142TJqetqb+XK+j/w9aBRP3feNGLpN6NKDEEFMOSMpEP7keJRzNyKdRXYMm8Aj1cM5qZmkbyEIqv8e2xFjWD+XAD2CNA89bGqzITCNPTqXFZWlNn+7u9Jf6SfaguhqG5YJgSPVv2eiG5o8eS6+AMKpP04XsbDU4AVSw0NgLAXiJtg/kBzmKuN4gpnvU9OMh90vJVRoJki+nXSwDeD6FaWvDW6MM+U2c/hk8wove4+O7y2F0T/N2HmnOArWzi2+mCAFbWtzkO4o/mAAOQVJ+zwJw99kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Replace the numeric test index in TAP output with the actual test
function name.

Use a structure containing function pointer and its name rather than
only the function pointer in the pkey_tests array.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/protection_keys.c | 55 +++++++++++---------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 2085982dba69..80c6124e8378 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -1692,29 +1692,36 @@ static void test_mprotect_pkey_on_unsupported_cpu(int *ptr, u16 pkey)
 	pkey_assert(sret < 0);
 }
 
-static void (*pkey_tests[])(int *ptr, u16 pkey) = {
-	test_read_of_write_disabled_region,
-	test_read_of_access_disabled_region,
-	test_read_of_access_disabled_region_with_page_already_mapped,
-	test_write_of_write_disabled_region,
-	test_write_of_write_disabled_region_with_page_already_mapped,
-	test_write_of_access_disabled_region,
-	test_write_of_access_disabled_region_with_page_already_mapped,
-	test_kernel_write_of_access_disabled_region,
-	test_kernel_write_of_write_disabled_region,
-	test_kernel_gup_of_access_disabled_region,
-	test_kernel_gup_write_to_write_disabled_region,
-	test_executing_on_unreadable_memory,
-	test_implicit_mprotect_exec_only_memory,
-	test_mprotect_with_pkey_0,
-	test_ptrace_of_child,
-	test_pkey_init_state,
-	test_pkey_syscalls_on_non_allocated_pkey,
-	test_pkey_syscalls_bad_args,
-	test_pkey_alloc_exhaust,
-	test_pkey_alloc_free_attach_pkey0,
+struct pkey_test {
+	void (*func)(int *ptr, u16 pkey);
+	const char *name;
+};
+
+#define PKEY_TEST(fn) { fn, #fn }
+
+static struct pkey_test pkey_tests[] = {
+	PKEY_TEST(test_read_of_write_disabled_region),
+	PKEY_TEST(test_read_of_access_disabled_region),
+	PKEY_TEST(test_read_of_access_disabled_region_with_page_already_mapped),
+	PKEY_TEST(test_write_of_write_disabled_region),
+	PKEY_TEST(test_write_of_write_disabled_region_with_page_already_mapped),
+	PKEY_TEST(test_write_of_access_disabled_region),
+	PKEY_TEST(test_write_of_access_disabled_region_with_page_already_mapped),
+	PKEY_TEST(test_kernel_write_of_access_disabled_region),
+	PKEY_TEST(test_kernel_write_of_write_disabled_region),
+	PKEY_TEST(test_kernel_gup_of_access_disabled_region),
+	PKEY_TEST(test_kernel_gup_write_to_write_disabled_region),
+	PKEY_TEST(test_executing_on_unreadable_memory),
+	PKEY_TEST(test_implicit_mprotect_exec_only_memory),
+	PKEY_TEST(test_mprotect_with_pkey_0),
+	PKEY_TEST(test_ptrace_of_child),
+	PKEY_TEST(test_pkey_init_state),
+	PKEY_TEST(test_pkey_syscalls_on_non_allocated_pkey),
+	PKEY_TEST(test_pkey_syscalls_bad_args),
+	PKEY_TEST(test_pkey_alloc_exhaust),
+	PKEY_TEST(test_pkey_alloc_free_attach_pkey0),
 #if defined(__i386__) || defined(__x86_64__) || defined(__aarch64__)
-	test_ptrace_modifies_pkru,
+	PKEY_TEST(test_ptrace_modifies_pkru),
 #endif
 };
 
@@ -1735,7 +1742,7 @@ static void run_tests_once(void)
 		dprintf1("test %d starting with pkey: %d\n", test_nr, pkey);
 		ptr = malloc_pkey(PAGE_SIZE, prot, pkey);
 		dprintf1("test %d starting...\n", test_nr);
-		pkey_tests[test_nr](ptr, pkey);
+		pkey_tests[test_nr].func(ptr, pkey);
 		dprintf1("freeing test memory: %p\n", ptr);
 		free_pkey_malloc(ptr);
 		sys_pkey_free(pkey);
@@ -1746,7 +1753,7 @@ static void run_tests_once(void)
 		tracing_off();
 		close_test_fds();
 
-		printf("test %2d PASSED (iteration %d)\n", test_nr, iteration_nr);
+		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
 		dprintf1("======================\n\n");
 	}
 	iteration_nr++;
-- 
2.53.0


