Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186F2FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8E76B00EF; Tue, 28 Apr 2026 16:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0046B00F1; Tue, 28 Apr 2026 16:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5EC6B00F2; Tue, 28 Apr 2026 16:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 398526B00EF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AA7C1A0414
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:57 +0000 (UTC)
X-FDA: 84709151394.29.D7F59E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 328D71C0009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MUQ0pFf6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2D9ZRjMrnUvJUW9XAX6uWR7S+PDCK0rNUMbYXKkr8Q=;
	b=chS2Fz4inZYjgHFT6zSRyajLuY5WIJdTHGr4ciOqBDh9Za1/XgTldyJRbGtHHl9pVMwGdG
	rIld/buu53OCv3hf7dKPg1FDPpS6iJuG07r+K3EAY4BdDdSl2BbVUVp7pkHVJGNPzj+dJB
	J8k/rZ2yVxPVcoP3+LO2mZgObnlMN/0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MUQ0pFf6;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409275; a=rsa-sha256;
	cv=none;
	b=jx0BPxoBtsr+a7ommJpc9KsEEfg07bk3diYx3nE4UXSkk7RJyolmP8aMussj+Nby1V4Ho/
	yb+Mxm6k4ncVvu4AGsbZIuyWknRWKKNgZJmfL5Kt1SUETjtdJxGOH4tZJpDO0FU6efrBZo
	+V0c48aEJYYPfZoMw9C6gC+vFiD4IuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CADA40214;
	Tue, 28 Apr 2026 20:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5D1C2BCAF;
	Tue, 28 Apr 2026 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409274;
	bh=npg4+uMs+1VXM+YeMA2PoGGD+uhEYXNx6PkYW3tjPLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUQ0pFf6316ds72ArO+ygPQWT45xuWb4xxgTNzqCoxwytGQuR9MlZUAWV6GsXlvV2
	 ytbd6FA/0VAnxQzVefkG7J3EbZvZ9SA8IjG7Cn2rf5j2Qe6fIP94ceP16xm3uS/Y3h
	 T+8XE6lICYyLmkh2E9gTMNKEVYtllRO2Sh3oczOefK+Nw1pxu8xYR0VUI+lmtpqqCj
	 aPFOuMZgTa1hIuqT+06J9brEE0xYFBIDclmlpoldQkSnNhFqXRitWZB29TLV9bFpy1
	 rc69qp467B0tfc1YQEAjK8Om3czsnyhbrekA4Pu9XdPIo8J19K9A/luPL/UC1zaVsg
	 Hw8/Hqhq3Q49w==
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
Subject: [PATCH v3 46/54] selftests/mm: protection_keys: use library code for HugeTLB setup
Date: Tue, 28 Apr 2026 23:42:32 +0300
Message-ID: <20260428204240.1924129-47-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 328D71C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: k1ra7q54mcit8aemntfmose7iwjkn5wq
X-HE-Tag: 1777409274-445246
X-HE-Meta: U2FsdGVkX18FKLEFK5p9dYrFnjx/CT/sIBmniz/DqmWUPtMP1ajShpiVqXOKpAs9Nfxm1ia1HaBlUyK0aYLqHtcg7cnzPQAeeNSnSkazFSlvwL9xi59HJtAy/YwL8UOKdnoWSAnLYgaA1K/7XMOqrazRvFjwsOgebV2rH1A3BNWnbQBjaLpNAZRvCfiva9+FH9SU+hnFAtf1kF570fJYUG5mVWY01JkTDlg2TybPcObpMRhQSKutoO4Y3arAjO1f1TJwUH7sJ3p5oB0FeqJb2s9/a/XJm1ocGsEbPaeZVMPctbxZYkt95VXOBiyTy5nKRbjbeL1hVxCCORal4thZOs0OJylOvRal9PLP82C+a9ncn7LlrNFdNEfT4QZoX/IqZfUsX7IrEtGN4QDjrM+u1Dj6Z7+bMj+MhlDIRuWujjb88ZnxXNdPUBjIkEsj10riL9bcO129UI+RD3Wo10Z4Bv5CPbQlQ61CrqILlcKeHaVf5kNoNR2vMXWcjokD9VDJQVMPQyp7lK3+dnHNK41QNH/o05LFWF3JRDY4J3vnFCTpmplT7dpFhKlbk5K2fC+p2FhtJ8FX1nUJtxoyj/MVdTEG6A37PWyIdIo1JMIiqO0KLwLs71sDpct4TjBvwsfIInfLWju97c755keMzZQPNzZh0lnzhdYzymg9AKetlBEpf7sckLWub/ZAC0aiR2lEZlQ5x377p5pd5xMKsvBLq9yoPEWw0KcEXWyHOXntkbVVyvPbX6O8sypJ+UQQBhvBUN+e+ZYewtQoaYpZ4FqB+Zmce4ikY8993olzotubg1VI7kT2t8O62IvHRN7QRIzK7YqPbFZYkJDR2ce2M1Aumb8/OWMblYna8k7Y90/wjbMt3eak5Q36IbOLSXG44+x5oJ9PdmoI9YtiYUIuD/A45FiazdvOWcR7bpANBHIR8buurzBY9V822NcICGAttQx8+PnqdGhxPlVRnXTE+Uz
 T0+kwg/t
 swpq5hM4FxCk4DjDzJpTyJipKvGm9ooDAkE0JJ30cNpvf6XIxSMLXjL3wlciOuSVHBBvqRbOqWkoyxuJNn3YZL16Wl3uhvB5JFyXiTUHh+Rt/wjK79rCthrp4Fu7Q1lLq7RbtJcM2g4z/IMJCsaO8nV4mWR1EOvNbrYPeVa3Ry4/MW22xnduRotdh2020zhW/Fr778HAWy+ePuyZQ+pz9Ke45/70eU1NHOE0ZvymgxFTaXvFDNbIynEwiDz1J4uoaGu7rpStEt86AdaH7sa/IQY1I8FjSzd7T3pdz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

protection_keys open codes setup of HugeTLB pages.

Replace it with the library functions from hugepage_setup.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/protection_keys.c | 51 ++++++--------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index d617b41dda6b..f8a5447a55b7 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -47,6 +47,7 @@
 #include <setjmp.h>
 
 #include "pkey-helpers.h"
+#include "hugepage_settings.h"
 
 int iteration_nr = 1;
 int test_nr;
@@ -61,6 +62,7 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
+#if CONTROL_TRACING > 0
 static void cat_into_file(char *str, char *file)
 {
 	int fd = open(file, O_RDWR);
@@ -86,7 +88,6 @@ static void cat_into_file(char *str, char *file)
 	close(fd);
 }
 
-#if CONTROL_TRACING > 0
 static int warned_tracing;
 static int tracing_root_ok(void)
 {
@@ -709,50 +710,28 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
 }
 
 static int hugetlb_setup_ok;
-#define SYSFS_FMT_NR_HUGE_PAGES "/sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages"
 #define GET_NR_HUGE_PAGES 10
 static void setup_hugetlbfs(void)
 {
-	int err;
-	int fd;
-	char buf[256];
-	long hpagesz_kb;
-	long hpagesz_mb;
+	long hpagesz_mb = HPAGE_SIZE / 1024 / 1024;
+	unsigned long free_pages;
 
 	if (geteuid() != 0) {
 		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
 		return;
 	}
 
-	cat_into_file(__stringify(GET_NR_HUGE_PAGES), "/proc/sys/vm/nr_hugepages");
-
 	/*
-	 * Now go make sure that we got the pages and that they
+	 * Make sure that we got the pages and that they
 	 * are PMD-level pages. Someone might have made PUD-level
 	 * pages the default.
 	 */
-	hpagesz_kb = HPAGE_SIZE / 1024;
-	hpagesz_mb = hpagesz_kb / 1024;
-	sprintf(buf, SYSFS_FMT_NR_HUGE_PAGES, hpagesz_kb);
-	fd = open(buf, O_RDONLY);
-	if (fd < 0) {
-		fprintf(stderr, "opening sysfs %ldM hugetlb config: %s\n",
-			hpagesz_mb, strerror(errno));
-		return;
-	}
-
-	/* -1 to guarantee leaving the trailing \0 */
-	err = read(fd, buf, sizeof(buf)-1);
-	close(fd);
-	if (err <= 0) {
-		fprintf(stderr, "reading sysfs %ldM hugetlb config: %s\n",
-			hpagesz_mb, strerror(errno));
-		return;
-	}
-
-	if (atoi(buf) != GET_NR_HUGE_PAGES) {
-		fprintf(stderr, "could not confirm %ldM pages, got: '%s' expected %d\n",
-			hpagesz_mb, buf, GET_NR_HUGE_PAGES);
+	hugetlb_save_settings();
+	hugetlb_set_nr_pages(HPAGE_SIZE, GET_NR_HUGE_PAGES);
+	free_pages = hugetlb_free_pages(HPAGE_SIZE);
+	if (free_pages < GET_NR_HUGE_PAGES) {
+		ksft_print_msg("could not confirm %ldM pages, got: '%ld' expected %d\n",
+			       hpagesz_mb, free_pages, GET_NR_HUGE_PAGES);
 		return;
 	}
 
@@ -1129,7 +1108,7 @@ static void become_child(void)
 		/* in the child */
 		return;
 	}
-	exit(0);
+	_exit(0);
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
@@ -1508,18 +1487,18 @@ static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
 		 * checking
 		 */
 		if (__read_pkey_reg() != new_pkru)
-			exit(1);
+			_exit(1);
 
 		/* Stop and allow the tracer to clear XSTATE_BV for PKRU */
 		raise(SIGSTOP);
 
 		if (__read_pkey_reg() != 0)
-			exit(1);
+			_exit(1);
 
 		/* Stop and allow the tracer to examine PKRU */
 		raise(SIGSTOP);
 
-		exit(0);
+		_exit(0);
 	}
 
 	pkey_assert(child == waitpid(child, &status, 0));
-- 
2.53.0


