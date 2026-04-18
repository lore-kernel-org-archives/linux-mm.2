Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C37EF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C706B0294; Sat, 18 Apr 2026 07:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943986B0296; Sat, 18 Apr 2026 07:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859D26B0297; Sat, 18 Apr 2026 07:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 720B26B0294
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 421931404E1
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:47 +0000 (UTC)
X-FDA: 84671383734.01.BA99255
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 68198A0011
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKwyUbqH;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrO7njVxu1EmFkDy0NC95VIXGZ8qqqcrewE7eMpxa0A=;
	b=JSNjHHWWxhOn7KWH6iir1pT5RMuEeSusJfBrf1FmQco5umbgfglYXRO3wZNiwLius2Ancx
	haHMlfy7JNkzrG4N7ysKcWxKQCEBgrDLn7LRwGOmiBlaRBEIg9KgIQWPvMLdTT5EqYGMy+
	I0c/TGVH8q3WXQYtWjBUxNiHvrYZ+4o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKwyUbqH;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510045; a=rsa-sha256;
	cv=none;
	b=snsJXU+vhX9Ffh0Z4oKfSh3Ytm4+HEYfRj1C+dHEt8ZQL5LPZovFJ3l/Pile0+Wtf851cG
	fjaEKhp2Z+PoVw9lkbmoHX0u9McdBtSWK+YeOHvLbofh7Sda4s+HhJj7E7fiPesinFtgGa
	Qsr+Io58Y3dWlexxJqp/oYP8QbIjbTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 974DD40138;
	Sat, 18 Apr 2026 11:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF578C19424;
	Sat, 18 Apr 2026 11:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510044;
	bh=C8Qz87BGrLBhc4P4E9wehTmUZkE5iKzjerVbkLBntAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKwyUbqHgZ/bX7Y6OBcWVUYXSyxiUDS3+xpGqowyE18mZzagnrbL2A1UmjeqHVM/7
	 v4ddSxBgIhSHaIGze++2hIOND+DNVSL2g2T7Qq5Abb2aSmIPDR5UgEGQznropFfVyT
	 OydItKL8//TorAe5wK3wJps+jqps92ECffO7l9Y8B085f9Nsn+BrQTy0J0bFRcoQjb
	 VmMj1MeI4UDEAk2EXbLTLSuoxiCJi2RT5Np7xhJRr1ZLnok+ejSgIaZ9mScWLA2F+G
	 j6FxbWhJIxIxSn3/KkbXPMGcu9s9346GMUAAaTqhlSekgnEY23ciFm0NKmx/lxheQ5
	 bBxtCgjr1kGXg==
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
Subject: [PATCH v2 48/53] selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:33 +0300
Message-ID: <20260418105539.1261536-49-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68198A0011
X-Stat-Signature: z94mr87t7q3xb5obu4xfht664n8agjpf
X-Rspam-User: 
X-HE-Tag: 1776510045-759466
X-HE-Meta: U2FsdGVkX18hSB8RE9x7EeZPHRwoc9QpeYmWu3OYGtPhhSjFcih6d65vSWY1XnB9C/qbVFfOcOE+Rg+AlgnAjS6lbLJq3uVZ6Bv8+EKIX/1RpUe4HEL+I83qr2eCBandyKsIxGrvOkHPUos7ehWgEG0Zr+LQZ2bza10HyJlnZ4U3dKP9WJ8eO7X8HKkPFx2JUKzCuZ0D+k9CFbJzHNMFDYgyeMk8F3U8BISdVYNPvnk0O2icxglBDt7gYbxIaHb9/11GWEu3ZbwMJygDSMc8uWqSitgdPrDHU8yUVhIh3qxyoUshXXciFVfj+dZKwLkgsWUmRfs/calCqyH2p8VNaPTNOs9MDmiTdfacTp460kNKhQKMms7dGWQKFpO6jJwnJh8cC2SYjzASjhzCEHeYj3P/tD4nXzMn10FOSGyIfo4YrzNJxNQcoJY3GAUS3IU1jQy8Zrl0pbjnQ3A73qKrYDug8fJWQj2m1g4aN4g2UJA3OeGShR4mUxExxrRUWxDgCdALvnJuUCDjTPESBkWrhJ/p50QRRBHe5slplcRKXzsa+Zz22SDMm8/fQ8EJBKtHbVskXKZwTMvIygwfjKAPerPK5JqXttSR9IwLRk6yMUMZ7v3EAZjkfjvcjACMnWL+UdgPP/EauyDP501pcLFy8fwy3CUOFoxOH08W+yk2S7iR2jKaKVEI4rWSG1TAwGhGTx2q4c5Aq+bVXIahObig7cDuWtwYptt8Oi9Vb2DmSzLtaWdDy9/IrzFhUEiC9qhSXtpBpBOWCfBsVwMgIJfGRE66wXb8dRy3S3A4ubY6/hEkWFJDe6EbvBC0e1KwOWKlT6/7TyAyxFJMclBFJPTdLHzHVKzGcpGY8TbMEXggumH3V4NKWFShQ20kUco3+t8QZs27wwVKZitFBpXQXYYiQP0nhoMvSQHldYToI9fewuzFeWroZ847MJ1C/cffSz1OHH1rFoW7Zq1oZj+aY8A
 30IwmT3m
 Qz1y27FnTSbGM9OhrN9E7YndIGE+vPElzrn1GSrHUDX1z3RhHexjO+AUWsQ+3AERQi/TzCb2R9My81zFtOhjwHLI2JICDCUCid7SJH9wPF2NBSYooqaxgZ51qcBu68DS33ehwDAXh/rWhdjra0rDGRCQjha4jgosr7GaSp1gdbafpdOpLAdjkV5AQzZsZGD9jIQ7W3EPh8vBQRRaHLq22cUGWsCp108zfOg6K0C44gB817u8=
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


