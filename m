Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFCBECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCFF8E000C; Fri, 12 Sep 2025 08:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D8C8E0003; Fri, 12 Sep 2025 08:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483488E000C; Fri, 12 Sep 2025 08:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4CC8E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:31:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3DA5871BC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:31:18 +0000 (UTC)
X-FDA: 83880533436.06.192BABA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A2EE10001A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:31:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=H3JI5oOM;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqC/Y5/5X3Jl44Gdt7jThhBkOEYWXM3k58RTRkZoEr8=;
	b=I7MCTrEz6ddZUAv1qAaAyOk7tsZS4lYRHLEu4pu0okKXZdjURkyckCUlQJUio1L0Q7lLUd
	2Vyf+EkDXmxMS/O8tP3jWMFlkyhQBqrt2b+K0B/AuwrKmoFL3PovxZL57TfxYoehf3mJr8
	sjuX1QYwgUZwCZ/agWUeSqjJS7aS+EQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=H3JI5oOM;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680277; a=rsa-sha256;
	cv=none;
	b=6IuXvPlg00ih5P0sLc9nJZqYtzgngcKlmMyzvvJMW5OskjOh9bZWZ3G9rzzOPu2ZesYtyZ
	da0WiiGsiBWHLT2LcgEb77mvucOc0TvNcU4dezYG1vW1oUshS/g6tEQundatOKfXOrfUjL
	pZ6FYVRfT/8CdHaZxkKBRSNiHlCyh8c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1757680274;
	bh=t+a7zA6bZDMOWmuPa8ga3Id8iVwTgiOsXbGtzVzdwx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3JI5oOMwl9BnNQ/9ofEPsnIh7Bo0S8a1+haHTZwoLjB+HK5LE41Ku60KxBPj0G9f
	 ppECop1iZbdyjsdqsADCxKxnBJD08+0j86+lJ1WbDqvgMLwNiox4vjXzxfuxgKe5HT
	 ES62BY1dizMXPbmxIROIRtRG4a9Thr1YY3cWh6eqvo6k+BWybSARB2f1FaA3s5DKSO
	 d/ebpckXtm6p5VGeGV+K5hWlStP7sVa1QegWZ8NM1QuYBkW4LTMW1C+lY5gYQ2Xiqu
	 st0VbvrlsQSxUkuwmBq5QWl0gnD7KGR+mm15hl3eM/VvZRYQIHDg6UzTXqnLgDT+SO
	 J1myC79JdnxVg==
Received: from mt.tail9873f4.ts.net (unknown [144.48.130.189])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C7A2117E0DD7;
	Fri, 12 Sep 2025 14:31:02 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH 1/2] selftests/mm: Add -Wunreachable-code and fix warnings
Date: Fri, 12 Sep 2025 17:30:21 +0500
Message-ID: <20250912123025.1271051-2-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250912123025.1271051-1-usama.anjum@collabora.com>
References: <20250912123025.1271051-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hafa636yriohowrto43ixe4bya743at9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A2EE10001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757680276-487960
X-HE-Meta: U2FsdGVkX1/P8hOTf6AmQ7JRstwnOx6CkAOBL1iqJYklyD6ojteTKoJJhONG4fr65MGIX3z0JjbLrSkULAiPkabeI/KY+2tKOEb3zomJF+bu4KfbJp2lvLjgET5zQec+7i0YWrwFAHAzBYaDdq9fHzJx7QZdk9CWK0TmU6PPsL7X/4eiI/gf/gTtutvx0ng8X0Mb+pJc5FegfZ20H8jXE6lnyOkJtN2qrN0LJ2pcZnu9NB3CWL2s3b2heFPbOe+LFwwOYtu2gjItfxcLYfJDOlOEzX45p+4djM98E4oXvj+imREaDUatv8F1vaJ2ZGVsmoppp9GJINVuMbf3lNPFg3ES5ffC5HUDbeCkCZPw31y+hTk8rj8NsxSjNhAEIzHvXYFf/ZbnW0GwOvp25ojpG1EPa05AZYEb9W1wJgphfOegxSKLUJXg5VsA2no4h6DYtINe/uCRtc+VZKsI9m0eMA4aoTFUXbjbLD87PhMCZWOUnl+dkWq6iwArc2liXWLg9ri4i8PiC7lorfr/9UH4gp9umq5rLR2gx+QhL14VizVS0aJE9UC3pwdjvefoKirF3mxue04wd8ZTpiMlO6myolAwFsWMg2qbd+saTj/SxYO4qz1Dr5bpYqdb9TwLmtCQwHDjBwRQrwiis7wnMT2pOK4itjd0RxJkeeCl1mp2oOuF88S6f2V46804uT7OMmGuzpieQ1iXcsOEFNyICNlTCo4N7e4jrUbx4VHrL1ub+ahpLuaY01dUbzrAFfhXFWoGTlYlFQ4pneuYjLHSu/lNV3k5OThnAbVUfAXxNxil6H9qnnFPxwpdj4500o2Wf/VmVH/O65HqZbKlZzUjlKN6m9eV/aebzmm7ttjCbOYU1gJLujFLqLnJ6ODcl9PZjrNRpJ19BM4eZXPf9x1/DLwT3jJbHtkK5RNSZP0uRi2VpCW71y7xbIAiFH7GAgwccHbYNGKWkFPl8ObEs89pXPx
 ypelgvgZ
 SNVjM/wSVoyZePDa9J4s8//gYt9+7KxkGjTL8ia0adUYQJbsrAN5X+PnhxB3AOqDwd/YM0FIuK9UPdRI9e2VQvtxZsoqij/vwbMye0BORu1TW3aqkcMwZ80g9p4ecDjR/Fj7nhUfpx+IKQeAYSQ/yVuQkHOYUVO8Dg6DDRz3nQ7+t0xm2EFM0V3o5T25ZPND4HudgMFaroYu4F31bGR5So+a4vbCwaLT8LAcvlItj9eRbM/3sg83/VGFoxqqv6UAKQkbfpK3TLER5Sd8bjHQAaVREV6cxHwRw6cEdPerOTaU4sgNIl8ShvllhtJonv7y9Sh39fdX/OYhGizPxA1CuLbe6HnpWCUnxZBUdqmdIrKexeXq9KVhEm3lLqEshFKC6MxaJ
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

2. ksft_exit_fail_msg() calls exit(). So cleanup isn't done. Replace it
   with ksft_print_msg().
split_huge_page_test.c:301:3: warning: code will never be executed
[-Wunreachable-code]
                goto cleanup;
                ^~~~~~~~~~~~

3. Remove duplicate inline.
pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
specifier [-Wduplicate-decl-specifier]
static inline __always_inline

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/Makefile                | 1 +
 tools/testing/selftests/mm/hmm-tests.c             | 5 ++---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 5a1dee50b8987..eaf9312097f7b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -34,6 +34,7 @@ endif
 MAKEFLAGS += --no-builtin-rules
 
 CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
+CFLAGS += -Wunreachable-code
 LDLIBS = -lrt -lpthread -lm
 
 # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 1325de70f44fc..25045536f4707 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2030,11 +2030,10 @@ TEST_F(hmm, hmm_cow_in_device)
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
index 7731191cc8e9b..743af3c051905 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -510,7 +510,7 @@ static void split_file_backed_thp(int order)
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
-		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
+		ksft_print_msg("Fail to create file-backed THP split testing file\n");
 		goto cleanup;
 	}
 
-- 
2.47.3


