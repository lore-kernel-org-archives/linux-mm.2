Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6B7CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D176D8E0078; Fri, 22 Aug 2025 04:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF168E0056; Fri, 22 Aug 2025 04:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE428E0078; Fri, 22 Aug 2025 04:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A76AC8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0D0A138CB3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:08 +0000 (UTC)
X-FDA: 83803703256.13.AABD002
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1B4AC20002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lvazUn21;
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b80XVWxw/YPB11eEdV/B9UldbX7iHhuUtAW7RvyCTws=;
	b=QB3JL87/F/Mu6FTWTjPT/h/MO/yOSrk6WIg+Yt3TTRSwpW993Cjip5yS6qASZsGuaASKbx
	myYrGanxyF7UgphgxzVnixs5JVzw5OXnN+VWnpqfnSmIoqsOxqXJspAD51I+HvxojCURXs
	JE/V/M+NpnqJwKLdK2U4jKEGIkd+ydg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lvazUn21;
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850987; a=rsa-sha256;
	cv=none;
	b=yah00g+QQMhDgbmqcuCPB08PluYHZmbIAmmFsDOdb1xuPyHkoToxXVQmKAR/kpjrbLSJya
	ad1kGdBIRSqio7b0LtKYXgrrYojv2qBdXeSoa4wIfBH6I+BXQN6BiGlHs1cHftZx+LGOj5
	AuoazIfqy6EMi9aGFgN914KsOglEuFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755850984;
	bh=vKA3QXzgA9t4nw9n7BL15bfwnNSlvwYMDzMnDq2mC9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvazUn21mN5Ye3Fu9Rd0Qb8O/9oQP7dp2h2wxUwlcWLhgES+LpwVZJLjpScWskZL7
	 3WZBdRrI7PEAxplXJcGJHIRGcaXaInkLbb8aym1lu1i5+/jO2ZFvXq4wj6QUjP8wHm
	 +wJE4gX6Tm6AbF/do2Yy4zaHURlmKy6N9o0UnIaoHifbkeIp6djQ6MUebA17j/Sofj
	 BRHbz5sKR0pFZdY5WVu3kd6CEYM5losGNsySuj2MHjxq7cOlNmxR/jImA84XpEMPC+
	 k85k93U/nvYGBpFw2SAKlNlivkJPKqMVja4sPTnj2zxRT9ShfMkYjiKYPd7KEIrGmO
	 tnkywhhJ5UGSg==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8A15717E1340;
	Fri, 22 Aug 2025 10:22:59 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH v3 1/8] selftests/mm: Add -Wunreachable-code and fix warnings
Date: Fri, 22 Aug 2025 13:20:58 +0500
Message-ID: <20250822082145.4145617-2-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B4AC20002
X-Stat-Signature: 1o1fiiuoao3jxtggfnium8k55xcewqgy
X-Rspam-User: 
X-HE-Tag: 1755850986-550062
X-HE-Meta: U2FsdGVkX198VJ5UhhiU2o6kj6IiYNGN4qvnYc3YPojUx1RgUX79bzN7O+sChmLMj8oKE/UIs1unBXala+G0/gUb0wz0C0ei6RIYtBL02S+5yOENqmllC/Uhxnry3msbEzqN1XiUeoMETAwgw7eYiJWBtLaTTzHT0LeIA8uFbL++HlSyzISfZupjxn+5QFV6LVSAEGas7Nmfz1SRTAaSX80uKWzow7CXq0RgKYAsTepLSAnJApmJGA6VqngzccM3fi2SL5sIY1In7CsTXid72jv+zrW9aE9BzvJNeqxS/GOF6c2dC4uApyy2j+5HsLDyTA6HOFS6lVfCKiyRrtHo51xTJKBYCIl5yXbt31HSzStrdB19ClbSjyeP4/IMGCJ+Wvq+WYn8L2TSXDkavxjsUtqu5O8TTBoHvNeWGfptqnjuEfnG6W8l8NBRrarnkN1drIH1JHfWaZXU4SeR0CVwNq4gWKLlaiIfJCDqrHHxpO4hBm1RdOH4Ti+xhIOPR2dX7I20kvs5tuAxxY60i28sQK0uHBWauFdDazf9Pnq+tOlbxtsCgVUOyv1CSwSwa4otBtVEkn0smBk1fGb89FOC8MoaeIme9Euh7CR4fVC1uPAVDbejSfyFSYsaMSqeOl7R5BKI7b1YV8vxSRFCLLba3k5qw1wV95yX5kSR1wkE9uDeH+fPOAu8cIBLMOP9wn2UWYRbR5Jq8Hwg9DUomgza4UtfDtUNQilf0eY6idCKfe9uqolHCfrsmOT1KiCBYxVwGH74lxYVAi6Ieh8X1Ay2XlyzxobTmfHYtp6NsasO67oa7Rx3bga8pddIFvhiQNIX/9MS1PYffHr2pbVCz3IW9PPpuw68Uv0oteKOic7ND4uVr0puhVqvsAnUXciteth+tdcM7ePM3nFWgIALhQIjuzM0EejLDoC6z1BzIVEGU+CODsPkTLHo0BrD+agSB6VGEGjdk4IwxelxyqrTV/W
 VOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable -Wunreachable-code flag to catch dead code and fix them.

1. Remove the dead code and write a comment instead:
hmm-tests.c:2033:3: warning: code will never be executed
[-Wunreachable-code]
                perror("Should not reach this\n");
                ^~~~~~

2. ksft_exit_fail_msg() calls exit(). Remove the dead code.
split_huge_page_test.c:301:3: warning: code will never be executed
[-Wunreachable-code]
                goto cleanup;
                ^~~~~~~~~~~~

3. Remove duplicate inline.
pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
specifier [-Wduplicate-decl-specifier]
static inline __always_inline

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes since v2:
- In split_huge_page_test.c, print error message and then go to cleanup
  tag for cleanup instead of just exiting without cleanup
---
 tools/testing/selftests/mm/Makefile                | 1 +
 tools/testing/selftests/mm/hmm-tests.c             | 5 ++---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d13b3cef2a2b2..23d4bf6215465 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -34,6 +34,7 @@ endif
 MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 141bf63cbe05e..15aadaf24a667 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2027,11 +2027,10 @@ TEST_F(hmm, hmm_cow_in_device)
 	if (pid == -1)
 		ASSERT_EQ(pid, 0);
 	if (!pid) {
-		/* Child process waitd for SIGTERM from the parent. */
+		/* Child process waits for SIGTERM from the parent. */
 		while (1) {
 		}
-		perror("Should not reach this\n");
-		exit(0);
+		/* Should not reach this */
 	}
 	/* Parent process writes to COW pages(s) and gets a
 	 * new copy in system. In case of device private pages,
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index b5e076a564c95..302fef54049c8 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -41,7 +41,7 @@ static siginfo_t siginfo = {0};
  * syscall will attempt to access the PLT in order to call a library function
  * which is protected by MPK 0 which we don't have access to.
  */
-static inline __always_inline
+static __always_inline
 long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 {
 	unsigned long ret;
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index bf40e6b121abc..de0d26f3df675 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -297,7 +297,7 @@ void split_file_backed_thp(int order)
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
-		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
+		ksft_print_msg("Fail to create file-backed THP split testing file\n");
 		goto cleanup;
 	}
 
-- 
2.47.2


