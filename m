Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C32CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55AE46B00EF; Mon, 11 May 2026 12:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5325D6B00F1; Mon, 11 May 2026 12:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FA66B00F2; Mon, 11 May 2026 12:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 384756B00EF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A583A16021C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:37 +0000 (UTC)
X-FDA: 84755677314.11.2B06243
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E79FD80008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJpo5zmf;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5P1E3WrkWM4I811tOvaEDN8Y4QYnTtwrM/+PuOh5ig=;
	b=1n6e4YkbuG+xh9jRNHM+iFdsxJNXcwcNm/OOARoRLJRrHV+3QxzUyQYt7/q6ZZXjIGiqJ2
	qge3C3mqvW3pbOFRtU5bV4qvMRp8jXD8QSsaTTlxvr1UKLCxnuOf05a9OuxQCjQ99GHG0V
	3VRga+DTDXhBgRFJ8XOP51JU/ZlTbE4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJpo5zmf;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517036; a=rsa-sha256;
	cv=none;
	b=C7uGlPgWfYPpCJtXlUlyv7S2PBhYisj6RSgQzJldlIqpP/kME6Ioc+AskK/lBwQHDTouM5
	WRWCa455Fy7xlfxNgcPZJ3sm1DxOfveg+RsN3318DabMvGN5a46MSqYIpKl2aNT5Bf719H
	WvGHHqCoTMIXFPO96hDuUTz/e8VUYXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1EDE404F9;
	Mon, 11 May 2026 16:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0ACAC2BCB0;
	Mon, 11 May 2026 16:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517034;
	bh=IxGwkiVerzk+69w9oGEPtrHGTr9T+VJ5NDxFldF5Syg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJpo5zmfzh6pp8OuMPfLAAjaggVXaG8vzD+Xidfd59DUseSeUHJjOYt2zomf7tKTl
	 sY2IBZSMYpGKslbLY0h6UErtvh8k09VMyPfHZaezNnRDhunpjTCnOLjhOvvmlIZ4NK
	 mxk4oMISsYVsA4lbttgzSMWvWq9JH4k77rqrXw0vSOb7w+u6TfwyjqjhQSLGj+J5JG
	 A1C/6I8bxPGxlZMOD0QerED9hh0pmCgC++pMkVf8ElC1ltEYdQURzvCpDmjTwgPCXW
	 P/mK9pxmH3pajpGcj3/KoFBF6ggCtfI/+nxfuZaRy3AjcMpG9ablMr6YXPFBUhglsP
	 pQ/qV7xrCvcwA==
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
Subject: [PATCH v4 16/55] selftests/mm: protection_keys: use descriptive test names in the output
Date: Mon, 11 May 2026 19:28:00 +0300
Message-ID: <20260511162840.375890-17-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E79FD80008
X-Rspamd-Server: rspam06
X-Stat-Signature: bnysif9idzwzsb88qz5sgodu66m78rcb
X-HE-Tag: 1778517035-81948
X-HE-Meta: U2FsdGVkX199eIWbuh0aQzhYRQff2JNRhIpWNRPHdez+/CNDRtkwptWEjFveZLlLF2WTsm0lZzWNf/OMM9qAxFTiEnnZpaaOpQVSp7F0aisMlVeOVY7jFncOXyxNZoS00MyezPgSX0hMluOcPkMx5ThE5ZaopdiSJt5FXpMW3yRGYWAdjQgQXV1Tg0fMIvliBGuUiTYSVruts8IdPuD+fK2euQYUPmbfzw2yPbCrwMTQe67IvwRAS0UBvdoa0zDe9o9onqhvSy2Yqfj+Su3NK7AYtDRLJPgtgy2QWA4VoYkqt7P1RIY/Ux/gH4IraFoRprStmbim3rQ893bFYEBdJDqw8j19pUQpWPu28rh53t0KV701gJrDorAvItsKd+edsEKJTCC9k/NRv0waLqm07iXIRB3Tf41h0LvOW/wPWkicvKQtWlCZxyXL7893AHXfZ/57seHYgifuMFY3JMlAHAOs0ONB72nmvBT6m1CJpFhHh44BHD+8sr0q+qPgQ3CfXaIvbFALrJ1nAuYVkIBMg88UG9D2j50UY+awazACFB+4yj0Vx134byYwtC9soSIqbOob6WDl6a8iZflek0YQWa2eIOekR9AhE0gnuBS8npUcV7C9CfyIa216dzDw0mUK53y1Jgrpq6naVrEeYwCL53oO9VNtnN5hzmonrYO+aPwN+xE+sC0lRgH6adoP5bRETi3vwoddCWTc+bivki7cHERheXcm+yXkvgDIHB+LMwMWa2Q/FUXPAAxQJ/cJ4/8pGxsp9TNFwzHja85Sz8KJpL8pOZPZkiKBYJuWHDrFKJadcXGKDd1i1VJg5kBwAAqsTHAHggQmny5t95DqPK90XXaBtNWEOIBNR7FvyvFjEfE/RIbyG4/S1wNV/ImxSWy6qCNx3WVlsFsYqBCX+5gTdMxNoxfKt/y/Ra/qwysse75WQTvcyK01/twXYSzKc2R/UPdoc32MVi32qGj4P82
 /PfYrj3Z
 fPMlzqWI/WhXjrXJspihimIP2g8aAgSpC7Wi8Q2bnVpcp80YeAAQrpa5X506TDR10sp7NxgGBae7UjWpO+7Jl17WBXr1U2MllDRMzOE+CYQvZA2scFIVE+lqs/b0Gf9RyvOLYnGbV56fevSt4HhclVWdWRNXTTYPgA3e0xILUe+GfRJCYgTYTYLV5ebi0A8Mu3TkhHr4/78Vv6DDKinTCZYFTY/HFiRKGsWQ+1+nZRxytHxPctRNW5S6cpUBZSreA9C+oerTUWXh/Tcl4eEOs4g20CNQLcHqUzcAwZIJibqF5CcFELee349EP+LwKqOZguoU8Gs4rf+i14UY=
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

Reviewed-by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
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


