Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B526CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77136B0135; Mon, 11 May 2026 12:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D270F6B0136; Mon, 11 May 2026 12:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15E36B0137; Mon, 11 May 2026 12:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC3596B0135
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 786F5A01E4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:19 +0000 (UTC)
X-FDA: 84755686638.23.91C7F5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDB954001A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gy9Tut4z;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EL/kStTJIYNGn9FqLG8TLGdpN8DAbOlRayh44fZz4GI=;
	b=d2o0xEm3Kk2nocjRZlzNSFSBvmjWoNx1HHWLKxLKMi43jtkMmbtPpNgS9wknomdDxC77d2
	XMlcnURkUF4DCaXNI+hcWVW+4Z7ZYJovwMXJv6jpcLUMVP6Lyt+iHlaGSI6Q23RBhg6cK0
	82N89IN33DYzxlIi8ao9RzSq/U7s1OM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gy9Tut4z;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517257; a=rsa-sha256;
	cv=none;
	b=pYo1oycOj6xklW5Fle+gvRqnPvqSh/bHJWs39GvS7fVT2JbdCUQguJb+ZzhRhih3lqNwbH
	Xl0zKTqc7rLOTZHM14ZVyNVkiTyKOhARGSUwldn+y/JuAeKeiVOwa2OfAQgrklp2bUnoFG
	Erw+XTWfFP53SmFPwRloa0tJeCLrQaU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 491C5600CB;
	Mon, 11 May 2026 16:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BEBC2BCB0;
	Mon, 11 May 2026 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517257;
	bh=CAT3IuSEZPeCdoFxrZmRBLvR4FcaG5dr9dINuioHUqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gy9Tut4zTuMiI7DX6CbEU48/A8Ei6hknht6ahxhMflJVfCg06LPyRHGMJsCqdmYYq
	 uQPB/xSGRvc1OeERMiA6PW/Uw6zitMT3oC6qzRiF0bh2a/Wusx60PaNGgQomRDF7iT
	 QT9prZ5ZhyD8H3elFaVl9Grr6/FjdHxkp6AtLy49GDtfq6ThvReryjwiOgCFm0J+rk
	 DsHwZzBvOYJL7HtFRnV+5tY73LvCcf1vN3Yr4W10DtH5r92X0rHJ1KZ0W/D5X6w9CO
	 hNEOFGJRSZsTiuacp3TU2AByepTRDeaEdB3CoMiDltKBlV/Q7lS+zsMtlI4pFzQU9i
	 /rpQFdSxc1aag==
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
Subject: [PATCH v4 50/55] selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:34 +0300
Message-ID: <20260511162840.375890-51-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BDB954001A
X-Rspam-User: 
X-Stat-Signature: zbkaeh9woaer76tpjhdoija3w49c5nxa
X-HE-Tag: 1778517257-820403
X-HE-Meta: U2FsdGVkX19FltPNehpVeYj4KNz3v5MRTprBSZqjo7+DeLnghkBD+o1viiGZXQUPtUBui6jBWMmpVjzDVqL/D+Cr1yEoxArHXdxlKgd/ojiVRPLEl3DpF4uLaMlBYSy8vwXjDOhV/kTMzYR1yoBzNazvzJKRC4QJ6GoCOBF6WKaTs0TfF98DeakTnSTlPPMsSDHAXgD5xtJZWinNF0TeTt94BL+JbYfSdl9JXvb2X+/kgcJbXMlBnUre4XsoJ5onEawO6WyK+ie3ft6C7c5VZUXqKfOZRZMahS/PB6/IEN3tA0jjAAVXT3qe40Xb2BzhvAp4oZya7t0ANq0Jajmpo5yrteHDrR1ZiLlAcm69HPr/J5dx07ZHDXDXmeFfNNVzNeFzRfHuVEA8n1GQ/BrdhO5u0iUzkUUCUxX8YbKR8xwB3Gyv/Z/HBrTbTuD5fcSxNR9hx4eTX5rnBsjh476Tszk88xPpqFagC6ei5UUW7gfjkFY9BeSiirThde0HyuuoNRvB/rczDwzUix6dcCsuISW5pBatWa6Vyi2ppDjcYW6f/ZFu3pvWg7X14ylqS8zrtyRJY3kYN3U/jOYLlO7UKOu0zrYmpRCBJavhCh37F/00B3pkhJnd5wxMlCvBrg3QDiaQCSwAqiumsxLNquMHPaceuykSOzl3oA6ccYavnEoig6tY7c9Vgfb7+nR3W1vZJ6Mty2+Ss0do9wn9daggAByKszUskP/cHlCaHW9y1g3ORQu5+JOia8dICOoUGHnKVYZkhDpu0hcSris3LqD4ywqeoPCrDXOBGvbySEyZXw0CHvnqJ9dyiHde4Rlz1DVln6+SwbVM7M7isnKLmJfwtn0CFgU+0GYTGYbZ34OzIs65hccZX42semNIBMf8Y/ZdUrjanG0NELviCoifM5fbgkJ3xvRbvSg7Wh2UCERBaKiprfdTbSoHWJaNkLeLYmk2lOTYo/HLRvDtVr2Vvzz
 1RMVPbbj
 n1j82hIgyNVE7+wqGGPqv8MfxB3PtqHqZCe21YKppKYriMqbT7X+/z1rIHf7oqS2+jkzwLPBEB3Pb0jZS2seKOaB/RzPgPDrRZ+zxWg50aOo7SgKxjI0EzjqFiw22yr4SfaUCRNRaNX5x+YgPwSol6LFRnqi8uXsYzkkT3xtOGygAuxbQ99Ohr7er9w9jnH7xORkcfYzj240XOWWUgoJcpn4vJb5LgK3Bui2uw9XBxjTmwL1UmJhliUSQoTwKr9cF2mocSqR0vjfKoAPL60ZrwrA7yxoKXgsVSa1crK1YmuO34sKswNrvQO6TqUQ8JGF1/Txb
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 33 +++++++++++++++++---
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index db7c26835487..a6c14109e818 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -299,7 +299,7 @@ static int pagemap_test_fork(uffd_global_test_opts_t *gopts, bool with_event, bo
 		if (test_pin)
 			unpin_pages(&args);
 		/* Succeed */
-		exit(0);
+		_exit(0);
 	}
 	waitpid(child, &result, 0);
 
@@ -767,7 +767,7 @@ static void uffd_sigbus_test_common(uffd_global_test_opts_t *gopts, bool wp)
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(gopts, 2, wp));
+		_exit(faulting_process(gopts, 2, wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -821,7 +821,7 @@ static void uffd_events_test_common(uffd_global_test_opts_t *gopts, bool wp)
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(gopts, 0, wp));
+		_exit(faulting_process(gopts, 0, wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -1700,11 +1700,32 @@ static int uffd_count_tests(int n_tests, int n_mems, const char *test_filter)
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
@@ -1738,6 +1759,8 @@ int main(int argc, char *argv[])
 		return KSFT_PASS;
 	}
 
+	hugepage_size = uffd_setup_hugetlb();
+
 	ksft_print_header();
 	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
 
@@ -1765,9 +1788,9 @@ int main(int argc, char *argv[])
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
-				gopts.page_size = default_huge_page_size();
+				gopts.page_size = hugepage_size;
 				if (gopts.page_size == 0) {
-					uffd_test_skip("huge page size is 0, feature missing?");
+					uffd_test_skip("not enough HugeTLB pages");
 					continue;
 				}
 			} else {
-- 
2.53.0


