Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8965CF46C48
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC986B00B1; Mon,  6 Apr 2026 10:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D486B00B3; Mon,  6 Apr 2026 10:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA476B00B4; Mon,  6 Apr 2026 10:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDF526B00B1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:19:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4C12E0618
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:15 +0000 (UTC)
X-FDA: 84628338270.15.85A36FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3A2BA100009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:19:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfWy3STM;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3Aei8bsg0EV77Ui56H1c55Bz2vk6Q1YmZ1YM3U4HrE=;
	b=sKKihDK2+v9YJiiCULUMRHF9xb2hkmnNA8uHPBwuiFZieM9hlg0DixwnoWNLAZR7SE/mQH
	qftQw5q66awQNLejnnQT/Z26zEboB7u3Eie5edc96qMUyTLg+NjtWtVWn71NCkp0pnQHnE
	tkAtHnoiOw+3dGdldZaCUoF5Ik5/1Us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485154; a=rsa-sha256;
	cv=none;
	b=ZqHMfSWuzpv0V9rOAWr241pfuzYSKYq8RL/ZI/oSi/bQZqqfqXAiOlZQcQMupA2UwWr27P
	YB2J5JLSZDdHezZfzWZvjJmlGWmpb97ndIXb3Vv2eCtPZk2YgFfaFo7RgNW7zVyt56L/YE
	ziOoNmBY6a0+nsAm2BICeIHgoLZGNU0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IfWy3STM;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3FBD60127;
	Mon,  6 Apr 2026 14:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2D0C4CEF7;
	Mon,  6 Apr 2026 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485153;
	bh=SzcnBMA17+/esvCK7rsu9oOwn8zorTs7CfJQdGsDSMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfWy3STMb+0SjENLADjBHIQr6ipBrxA0mxA1MpWI4Wx3zhhm4U8/IJCXBKl7/Xu1B
	 X3JfQdPZmHr4L2/eta8t9/KY9n2LzcEiMpIfN+AWWOgx2AFFk4wy869UfQP+N0xYdm
	 BecRrGJpxz8c7GN445HNPGW0fHKkK4Ubd9hfnHQnGaA6ZhPMQv9kemo+jaNHP3tkyT
	 ZFy6Gthyby+3cgefcc2/ZfFTdfsU7ybh7iTt20OmiO+6tue/+leEipY6aCckCyhEPw
	 kAu1OUqOGGjqLsHIzi1gfjr2+uPnQ4XvOT5lYBiRps+Ja/8xhpdkUPIf89Jvs7hfPT
	 qOQDa2DTvYxag==
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
Subject: [PATCH 15/53] selftests/mm: protection_keys: use descriptive test names in TAP output
Date: Mon,  6 Apr 2026 17:16:57 +0300
Message-ID: <20260406141735.2179309-16-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: b4757r6umcubqn9np5y9b7rcu1k4tmj9
X-Rspamd-Queue-Id: 3A2BA100009
X-Rspam-User: 
X-HE-Tag: 1775485154-823145
X-HE-Meta: U2FsdGVkX1+fQBPUfPVv0JCvadHbDhqscQNUIV9yfg8arBslhDBZtCln8uP/wwy08ezYcmnbhrOCgX5pl3TUCOLepOdfBDJNT0Uf+St2J0/E7DeuNxOA74GYFGxcKXOY0anmcfOAUHRBjiwi9JKQWcpLNKSGM/3gEZLunU3yhomcz6Pm3SbztsAorZkTZW2ZOwPbEtGQY6JV6eruGQJj3oXL2YoBdncHW2TWYjAhzCS/K36EY1LefIzoCCbZbFt9o4T4n1eBczp+4/Zuc5m9JEgCc9wgnBs8clHHQScBlACaXReY0tMLdHh9nazC9GugliSd1rJuotW+mBU8YJ8vwYcIbu5QLUFYZxtbFgbcAvRk0lHfA1uVpS/zSn84QKgzztsdv244nT6wk+pW3+whfhzQOlPIYhOLn0LXXUHAhUERzilzPEcxJ1N3EzWyQhqkUmMJXB73qs85+AAgTUh6lEohJzKL6oPC3e3gPGvlt5/+IJpCRe52uVGi2BkVys6i7yr7OvLlnpz5E9iCQfzQdXH1uIdS+AOGggehjhC7w0Uda5c5nUYTZcRfyC+8UH2bkJoG+sk4u7DwMODRuraVLzSSJcNlB4NbHrdsnXOmIoKfU1On4lhI+gwE7rMi6uC0CrLJ5ZtdQgLHbBkFwo0rnjbFObsfV+ds8N3pkdYeH08rP6acBbAeTP4sKAl7QA2zbisoXYI+/j8wiz/H84pnS6vDA9yJicR2ru4GWcfweK6rY9ImwWHz6qcI2swPtn4rB8k80Bv6545g+gSnbPviDsWVIfZJMtSO3vG2a6ElyqCjiYpxGFp9UyOnatLrJwAkbB79FlAMbWZqISAHanVZ0hy/sApvzR9h+3c7S+DTK3hwUZpVn9uT9h0+mcNcMIIEnffHSrh5w8vlq9ErqcLy91SVzj4dHUE7qL9xnS5FZ+VGtLjvw1+JOX5BN1ZlH2ZZvl+UMWh4z/0aUai54nt
 jEuAHVbQ
 B525e
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


