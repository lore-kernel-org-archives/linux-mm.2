Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BD3F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2DBA6B00F3; Mon,  6 Apr 2026 10:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEA86B00F5; Mon,  6 Apr 2026 10:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1CA66B00F6; Mon,  6 Apr 2026 10:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C29C86B00F3
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BF8CE143A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:26 +0000 (UTC)
X-FDA: 84628346292.20.2608C7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EDCDE10000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+f2wWK1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485345; a=rsa-sha256;
	cv=none;
	b=pjffcmH7+4iwMTqNOJse5DEw804bAGaJoizQZHwoVFhFFm152m+/PhDllq3AX4H/VjkCbG
	QyJTEoXnYCoX64+y1Z1vSxPA0GThQU3EgB/X7g1p/FvigDZNLljiK0iVG+7U8XsorK3RFP
	IqQgayagRrV70tHkvjaZVgFQJXvOTNw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+f2wWK1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrO7njVxu1EmFkDy0NC95VIXGZ8qqqcrewE7eMpxa0A=;
	b=lSMLUQnvuwtU1WKLW64nm0POGfVk9eS6ZUWvyiKz7rtJp95cC9d1gvR4cyY0zhsZEPQbu6
	HLsZ7nCgBGA6N4xFteSzhA4EzXnhhVFPtGwCz8FTBXUH8EYi/soewi/13uMPqoNLFr1ZFG
	nCLv1jIyE2+Tjbn3jqs55KuP3LfCYKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2798B43624;
	Mon,  6 Apr 2026 14:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC790C4CEF7;
	Mon,  6 Apr 2026 14:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485344;
	bh=C8Qz87BGrLBhc4P4E9wehTmUZkE5iKzjerVbkLBntAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+f2wWK11uSqkm9w/gfOoe4ZmrpHmrkIcM1nMH2cBjS9dSHUYp+bLIQJ/Tbl8vS4q
	 I5EwAxRWOxcIYqXLtvkMw5zFRiDiugCF9S5eFV7eqRGcMfuBBk4qTA4scRyNVDtZdV
	 otJ46/4U20iAcoCWzjRkv97RyFLYbyqJkRglCuI2PUO9BckpRA4QBpFMUG40/670VB
	 xWlvyefHf3tLItwxLBIz8oTgKU7jNhkwHB0GYNyxnC+ZCkIez7SI+KnHiclZBFrKMt
	 +9Gd/J8NUtQeORxVoxKNj1yD5PKwV0d3JP7w8xDE3v9mRqUyu7gLb1t0IWDuzuQGHT
	 jPMFiLjWpYReA==
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
Subject: [PATCH 48/53] selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:30 +0300
Message-ID: <20260406141735.2179309-49-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDCDE10000C
X-Stat-Signature: u7qqohm1im35kyttq77drxwp9yms8upg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775485344-227395
X-HE-Meta: U2FsdGVkX1938howKVgy2NKltVVNNLMim9sdhrUtzuW5aDw128gDmFbWc6+dDUmEQJQoX92ILQ2K7LVO1CWlYzX7VBqxGc6yF/NWK5keJH9QE/xmPZKoMjjXWh9CcrjMBuxObpTnbZGsHIyeSUtqRv3NRrmoGiuIXwvZAPZr2p6MIjj3qeS4uSNAFthiIfw427A5FO4+l9xMRA2HsqJ8tn1AGqKJCNMg1o4gNPCEbVxWa312qhIAi2zgpLzsRYAqIlHK4bSwJL94HI0PbBajaFZNrsb4otILnCpbJektUGnBb9ZTi1HhXfxkeEDEMUNiuiJQPaJKT1pFSN5TOVgaSRSW89Ayr/uWIPxlu2vPEKV4cj/ipjvbamG/c+/+P0aYLV3GrkKJbule8tCtuJgLdoqWivgFsDIVQvA/eUm/SfermYt6VoqUilKHv/wIJ9VZF9XK+urSXam2nWG7r0STRdPky41Cd5LUO8wKI5514tGMvWL3VMTebDGdwjtOMxuNZ39SRDpVqtNbqaRtJ9g4sxeJYB/b5kSXw9PGAu1OHyVVw+6h5VRx2buvh5OiioXddlkpxWDq9kI3Op3yJGPF37A1XMGMb7p7Zz6WsE9XFjdP6g5o+aN+rlF1kG4zQrv+7AOSkN+dmOuLZn+LxKJEF95BqRFywax2KDoCP723o6RAdOfknKxSCDMYTIXVC4hVgeNC/eenZlVDNl9O6X6r8KQzhnqT0MkzVVEBEAd63cr8NaAHCPmVDGd+/gCZtRwPxLTTyte32jPhRY76uHs8ZqJOEGcc4pvP1XNaVsRTUJZGxDn9sDhVQIZzl9VBwnwpRI/qMtddien2eBUSCvHhrS7W3uPts2VGYVo56BMUPjdzORzKUhGaK/seZlBOdG5XGt0wMYCr2TTVRQNTsCCzMCgdo1FWVbOUmVGDeFhBu9OPESvTV6aMJw==
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


