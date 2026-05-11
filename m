Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A1C9CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008D76B012F; Mon, 11 May 2026 12:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB4B6B0131; Mon, 11 May 2026 12:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA9A6B0132; Mon, 11 May 2026 12:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8CE86B012F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93924C0AED
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:59 +0000 (UTC)
X-FDA: 84755685798.13.037D3CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 03CE41C0015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fbwBo+Qm;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DocwTMYH/UV+wEnNNsuaAJUjD66lgkVnRA6DBHo2Q/8=;
	b=Sey8jWLIMpI3aUDN6r1SlPgTZvgDkHBaJ26Ci6NRmVAcrhhiANzK7qzX5q8AHv7kdVbtVf
	E9g0WUNjdE8P/IJqgGGRijhDQssCdNGQPU/NcJKRJ84KgaI4LOKgMOigxevlm4OwRpbOfY
	k+lFVAo7vdiIhzouaePJsTV3mWhlDi0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fbwBo+Qm;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517238; a=rsa-sha256;
	cv=none;
	b=DKztNz850HUagVdTYBOm0cKhJjzo38RQ5D9TpBuUJGVeDVPJTEDwefOjgWYCKMTG7Uxal8
	iEs3Wu+2CzKHaqlPTmAP+bB9wXr6mnlPHhoNI6twux0Tl5/COchbBYgTLzUAD2d7sMXsNS
	FrJGtv7OcDTkG32IMJ8GVMArQk8H3l8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FD7A60120;
	Mon, 11 May 2026 16:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B2EC2BCB0;
	Mon, 11 May 2026 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517237;
	bh=IQDojphnUkJOuhcjiAjtIOEI+aajmAdj7pvRTi3gGJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbwBo+QmWT2bWSImD1OzSr2E33L9+ZjXInCDNBnaT4lfnjBJwIZpwuBxQlZ0lQF9g
	 hJRUCi9WcGyi3W1/W8nGrGquTiwYd2iTO5PzXJGaDX8gNkMaGupXbGPTzqQuFdzlGD
	 X/VAlvyOmKMP4l+SVaxQ5RDPc3PDWlny/LBmtc2zE/p75td7Z6zQa13BFRaNZkQ7Zm
	 S72p1u6E36HAbczdFT1sp1c2fQf2OH/2tEbyUlVg0XaiigQBe85CXughaVIiuUsyvi
	 lTfMh6vydugkpinfnptIfsmu7jnNDuIRMAB3UC9HX/8YxzIAa+2cjyGTeaJpW51UUY
	 35H4cut3pqIaQ==
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
Subject: [PATCH v4 47/55] selftests/mm: protection_keys: use library code for HugeTLB setup
Date: Mon, 11 May 2026 19:28:31 +0300
Message-ID: <20260511162840.375890-48-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 57qsyaw7an9xaohoii9dgq8gwr7d4h8m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03CE41C0015
X-Rspam-User: 
X-HE-Tag: 1778517237-539684
X-HE-Meta: U2FsdGVkX1+7Yu6pcM4xTEoUy8OIO3j1X7vfXNCgH3XaSKU8AuaPvKQ4IjbfsjMAlfWrgOxLbql6wN3OQpKfBu8Mvd4peIlwfquzJUslRWpda3lGNcL3xquLOMoU2pgGdfmyxN7+CHMCA9O9eLLGWtPK0Wv7Fcy3D5G44tOZhf9WMOVDws2faBZPsZ5jPtHhbFMZQvYdK9YjE2Uz1wdlXwMTc8h2FMojQs8ew64TunTwB0ns1OM1tekbzrebMa6ukaqcPX8UvFFsJf9nWdc+8MCUE+PDjB+odE6yM3tts5s5vZkXG8UJmcLlB+Md7n85E9bgtpBWKXg+vwlL9flprfDQAXSqYVsxaX00niwKJAPqkqkaae3zOkSGNSh6Y6lRdJbdNqNvbaPS0dQFPOGX0k0rdnwUK39DPPzY2Wm+hL2pGt+V6z3iw15nh9McZP56MOXTolSLcDIHvE5f4+iN63saXV3CpE5AtdpkIHW+YuQq2A70iK9E11GOEGgFvRsWACfisLxH5BN+yvZHsxy89ounoY6C1FWg5hfYbKnJvHgkjPdgiJzssVjvGvtJNSIynfkBIpNRwCDmkBCKyEpD9nPXtBEffcnBjyldJwdFVeP6R1HJU3mUZK9GDUr1qEbRQcoYpmXyrtyL26xxzdFZKx8fuWYO+I5aVrE8mY0kQ59sshiiRia7WSsbfZxEM8UdCPe4IVB64/thzrH2xnfh/DuApBjmAekOXoCCUGAkDp+nDqnqc1iZenBwPkNnMF4HfVQBgPyfRo65C5UNRjXaQ1kSuOy4b3cvIiLUGHk1m8mtPyXzcjpTYtVSHpPM/JhLinFBXe3G8RWISA7NZ7DRP95CqhO4wlefDkk/F4+9E7OqtBOtOsSml73EjAfVnuTWmvN8L6PMDwL33EVahI1a595ck4Q7GKC2WZ+6HBDVzo00Al7Wl6Lq/7Ya6/tC9zD20cBHiWZNYEGtNcBCItx
 88tOIiUy
 fgU7JDL17mxgV8Y50NiCu2HE82cGMvqTxXjeg7gqKwCXrmWAu8s6FM2l8R9mTPK7/6LgIL1gsbxC/Qz74LyL8XjUs2u3ldtkQhxTLQlqlYbIEDFZ8ECvtvpSbdrbKRbs2HOsMMy+Ch+TZn7o1kjrrFR9dTD91MS5Fxoo28ZA4LyGXcYPvDD1La+roPhYy2LeKYLGbNHxcRY0NRmaQgZaDpai5UxbpfWyQ4Pg9dNKH26R55+R7O1v7+cl1IbYZCz9qp0lhPPiBKm6h5Z/u/azGndbRz0dFXa76msvjX7GnQ0nBbKpFyLoaWXGq7g==
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/protection_keys.c | 50 ++++++--------------
 1 file changed, 14 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 4e4aa3b326c1..9a6d954ee371 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -62,6 +62,7 @@ noinline int read_ptr(int *ptr)
 	return *ptr;
 }
 
+#if CONTROL_TRACING > 0
 static void cat_into_file(char *str, char *file)
 {
 	int fd = open(file, O_RDWR);
@@ -87,7 +88,6 @@ static void cat_into_file(char *str, char *file)
 	close(fd);
 }
 
-#if CONTROL_TRACING > 0
 static int warned_tracing;
 static int tracing_root_ok(void)
 {
@@ -710,50 +710,28 @@ static void *malloc_pkey_anon_huge(long size, int prot, u16 pkey)
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
+		ksft_print_msg("could not confirm %ldM pages, got: '%lu' expected %d\n",
+			       hpagesz_mb, free_pages, GET_NR_HUGE_PAGES);
 		return;
 	}
 
@@ -1130,7 +1108,7 @@ static void become_child(void)
 		/* in the child */
 		return;
 	}
-	exit(0);
+	_exit(0);
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
@@ -1509,18 +1487,18 @@ static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
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


