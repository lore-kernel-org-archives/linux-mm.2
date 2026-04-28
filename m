Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B06FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8F96B00B2; Tue, 28 Apr 2026 16:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869FE6B00B4; Tue, 28 Apr 2026 16:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758D56B00B5; Tue, 28 Apr 2026 16:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 648146B00B2
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:44:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C167A034B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:39 +0000 (UTC)
X-FDA: 84709143078.29.CF40D8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 72DB712000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:44:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDcC27la;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MI2gEgzG1gMIahVFDbuaKaC2duDb4mbBJnYTFYy+lyk=;
	b=3nnOotRbqAKE1BVLoen2C6JBdDaMrdxWD20jzwOccjXf7MaSsXa7csRWZJ2z8thwWnRXrV
	v5fJV9IzAnMNAtr3WJdG6ARbxlN8M5n50V6CDLDPaLBv9+RxhWle4x/dKgvgmOSBtrgbEy
	yeztHj8fCa814U+vqe6Zj4Vz3czWOk8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDcC27la;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409077; a=rsa-sha256;
	cv=none;
	b=bzVB0lysb3BhgGwky5AcYg6LjpGmoevP2DtavBnj10Ls6VbR2XQNTlUwIkQ1Qc/853cSps
	VMz7wLB5EtoQ3nbWA0jnAXl/AX5NWlT5ymr86enybg4UeBQu9kr0nc42q9B9WLQwGNTNIC
	qddIGLAxRiTm268qcxy+nLfEBpjpd9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7DDD6111B;
	Tue, 28 Apr 2026 20:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3A6C2BCAF;
	Tue, 28 Apr 2026 20:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409076;
	bh=fVCj9egQfI3xfmHaM59sAXV1x5+dV8VoGPx5qmYr/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDcC27laQpZlXBDwVn9TC7PuyP8ixtdqjmm78azLyOACYs+mYtDRWfOuJcYQrMDOO
	 RvcF4lasiaWiFizAzCKXNCIWGntXkDlHN4N/uEF8CLj3l9faWXa7SEV70JVRQ2pWYD
	 0EYfhniaqgcJXMtJLLHWrAMUpze+B9TBtogsbaGrfP2sr5z+Z3LMqAKgxmdReAE3Ot
	 G8pAbY1Or1AXLJj1rXmgXRuyk9Qf6eB6IpBcsyOO9ieo0ohOeYC1IRu28IHZWXJFjq
	 8GpALg0WGNOaiuu0aX1CVZ05nOhGvXay2zmOAROkASuL8FisKvTzVz+g1jrKw287IF
	 vDRRA/8UtP83g==
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
Subject: [PATCH v3 16/54] selftests/mm: protection_keys: use descriptive test names in TAP output
Date: Tue, 28 Apr 2026 23:42:02 +0300
Message-ID: <20260428204240.1924129-17-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72DB712000E
X-Stat-Signature: 6yntsw4h5i78xondakrjrwo7gj7m6mdq
X-HE-Tag: 1777409077-8952
X-HE-Meta: U2FsdGVkX19tHeQizviQVCc3CmThhuckk1S01Kag9iEIwFNym3fxatpZGexOyfWQxJiEp8+46ZDcLE9PfS0gBmmOSbiq+9aq7m10Wt5aGRnKPyiBxvSl9sLYSlMTLHcVMB5yAV4zctchbYN4p5uyvBg3VhzsjJ2+8OfQwi+e61QbkyLGB6frpJRfcBjTGNNO8vifOExs8BHazRkUMveArr/alYgoxkY3XQhHHk6j4KlyKQLlSbTlbdCODJdmBgIAJCzOqyuWKrFHJjel1O0J3qB36syHODkWJ4s/y3dJLIyXE5FOiZPTO+WC4tLH3Cid5a8ryRaew//f+xONhEv6F/pyASxB7dSH2JPPiJk1CIn1EX1skWDURc9r29eAp7+/pvCOwhi+niEht1BpL4ApUgBrzDrYOum20ijJlZfyf7bwkWbcl1amEzuWreya0q4yxGq4dlYIJvmja2Bji4XeKidXUfLZesg3pMM6FoMoStP1jTqKnS46r0EobMdbp9q1CybBOWmOnvtg6G1LhWCBZeJAWfb9HC9FW0dlQwpy7hMf/M70WU/3gleKDdYWccQ393q0q5tVFANyvakX1eNl6SNyReM433J05AWKElE/u7yxfatvafDuQYLwGP4Dgt80/YcN+pc2zfb+ZHpDAfIpst0GN9O6Brq1Pqs2BNweIOFFi54efHEoP1fLa8R/2Hyi2BaLoYpUecHYtRq2lqlda+7z2HSk7CXFbFL+JHPq2Hv34zVcLeZfJ0gCIUJoOYZGOt9hrGvaFESKwNa6ReMfMWDV1lE5+aVarXOn8PjfE/O7XeshgUZxfb2goh66+2Xb+aoMYTD6VdknwoAWy4fq3aNqStTfOci4zQ9Oq6MZPPbuUzqCmhk9SWGlS3T+/tkGyj5qepKJiUUXj2Yob3uZOPU3u0XHEC7JqiaCWd0aegtg9wDKD4allXA3CgVavhBjsYqkeKanbTTe44qjKIV
 xuUz2XEC
 7ERJH0rgHy7arzg0m2rQuN9J9UV682XKJtKUqxp7tg7z83r/IgTQSVLnwBNflIluqjkXxhRcnqI93hsnd3fILfBUnrBMdovVwtjdPPpjT+TOb+WCYXdkPHNrRgPJCuNlx2nAF288zYVAPPeacawTXuz7Xv/oprRUweFZ1qJSbGeWuWrY2hQhr1XS07a+yFisr0A6hmU3wj0AwDqW5XdkOgCnKo4vIlnlBBeotDRuFAP2iHwCiR5wIdX2vzjjh9kaeJeQPQsxEh6wt6uVtUFYivy5bBlomNytfyfunp50xOtnDqGQ=
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

Reviewed by: Donet Tom <donettom@linux.ibm.com>

Reviewed-by: Mark Brown <broonie@kernel.org>
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


