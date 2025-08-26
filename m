Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD113CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1D16B017C; Tue, 26 Aug 2025 04:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251A66B017E; Tue, 26 Aug 2025 04:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140C66B017F; Tue, 26 Aug 2025 04:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED31F6B017C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:34:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C8231DE349
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:34:10 +0000 (UTC)
X-FDA: 83818246260.07.A4A1B83
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5B12840003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:34:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756197248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNulZsQfnn8e0CmJj7cObGFs/uz/I7kgA+WobLuyhgA=;
	b=iQDv7+oeMvOlSalaltmAdo9KGlWAFBRXfe1t7R1uFidsgJxtty/oFNIFtcCup+1pq9VTgS
	6SDTSFDbeCPQSyPgaNJDQwy1rvGPfLEoh8H0+DVDII008y0AVo9gG5wchPdRxPZJgL2RaF
	cV/dk/m1ZAqoKY8lZBWgcp72unvH0L0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756197248; a=rsa-sha256;
	cv=none;
	b=4JeC2sNem1WfV8/h/tq0WKgcpzmMynARGsVcySc1LUCkmQjif7V7jMRe2P1dRGD6x+96rC
	Kf984dRQ9+e5/b+jQQ57QfC6yJKeCSA5iohwqepHbs7Lr/KzJqyDy/5jhV6WOVCyEV2155
	7yFxRGiUhixU6bk86fr1rg+wCspLVGg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 054471AC1;
	Tue, 26 Aug 2025 01:33:59 -0700 (PDT)
Received: from [10.57.89.149] (unknown [10.57.89.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E23E3F694;
	Tue, 26 Aug 2025 01:34:01 -0700 (PDT)
Message-ID: <9e2dcf8f-98b7-4461-af75-71627ee48230@arm.com>
Date: Tue, 26 Aug 2025 10:33:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] selftests/mm: Add -Wunreachable-code and fix
 warnings
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org
Cc: kernel@collabora.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
 <20250822082145.4145617-2-usama.anjum@collabora.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20250822082145.4145617-2-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B12840003
X-Stat-Signature: zuhh1417wuxanpxifhcs6wubbux6ac88
X-HE-Tag: 1756197248-70799
X-HE-Meta: U2FsdGVkX19sUOoehvRaoYkWtXPjxqTOQQHyTOzMWBr5Q8CD/Gk90M8UZ141N+DT0c3UeWmRDhukdwStS70Xpy2cQaFgGh8ZjnJU9k065O7SjTdZgEpigXMl6lSLsfV2PozFFbOuYuhAs8+g0ZRaKzvPwL61stk6g7yAECQP67TPqoArSEaZnDfgfb/s7fK4oHOim6cpsgapPdM5gCvBsDp3mA5aPg9OU6a6IReyg7mq0iAO2GfNQmLvIkk2Bz1Mp9vEHbVG0j2qGVOtsTcm+sr0a8gvTAVaXnRmmkkiavK1X6aacfMKUPPiSQ1uam5WESsSrWc6KvzG5dqL6ps6uFEQJIco0ZQtWiyDHNuoRnaJOvxtEou6MTq93K5mv3AI/l+yWtlQhQvAsZuT2hXhP4s+jZsMRiC79qOgJKq1WmZ9XJsbUuzs1M4m7VUi2KSni47nOvfw6ri9cOah4VVby/dJ8RNJJ9WPbj8TFm4qOTQQWRfvqG4ruYl768Bb0GZimOZIUrkJuhGof2X9sci8kBdtYFLFKgug5F3S3augmVL1UcTWC4Tu1hb72XhZSnpE8oYyq5LjIB7jLpxzcgI1s2xFbwe67VQFwu3GN5xZwKVzXywW93z9yx3ekeVlYreeuQowZofDOmLt+9Xgb7dT5dBeVP+lUPC+Y7DEr6Zawf7+6co6l4v+hMkm+ap+00+ubNM0aBFBjqOqvVLYr5CQ5LZajs9/nOGwQxvSdJyVRoLYD4uzX+gYYKP91DhXnDlcByoaUIVjtx35PbsdoVd+prwZwYLyWVrsVIE8m4NVDy1pLztHi9Plm7JrJRxbbeVXT5ov35L53LuC8b/KaTOzgjbJ3vwhDCAwOg3RD2Mbnb+yr9C5+4wUMtfWt/0+qeJCj9HeFpq/U86K7rc7edqMfSYY5ulO4xOjICzV8if9z5ZSXtTWJTeFzNsbL1IyFy4j0yKGrREYpjEBPnlRrgb
 SvzYZ3wx
 XV9H+4Laelro1QAr+e7+bDI3lzu0c8ANpn1Nyx1BteVZSK3k6c49usMkE97MUl2G6Ms8MG3g0EOKcEV1IN8IF49wYz+xKLNvOrPl+jNZPVlXGOGQ3dz/9h4ANZfXP6fA45RD4JNbc9HB/IjQtbY8cID/karoju0eu5mmZir6xXMHadrCr+8MHXjpBgr8iuKxhTHd81jf7k4rWlCV/tE0Pvr6MOnxhHDQOnT9BabXXp65YEvsXdQj7JKu/03Oy6tGK2hPfilxj57tKzVyrCFAm5AiqcoY1okZ1bClu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/08/2025 10:20, Muhammad Usama Anjum wrote:
> Enable -Wunreachable-code flag to catch dead code and fix them.
>
> 1. Remove the dead code and write a comment instead:
> hmm-tests.c:2033:3: warning: code will never be executed
> [-Wunreachable-code]
>                 perror("Should not reach this\n");
>                 ^~~~~~
>
> 2. ksft_exit_fail_msg() calls exit(). Remove the dead code.

In that new version there's no dead code removal, rather that call is
replaced to a call to ksft_print_msg() that doesn't exit.

With that corrected:

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

- Kevin

> split_huge_page_test.c:301:3: warning: code will never be executed
> [-Wunreachable-code]
>                 goto cleanup;
>                 ^~~~~~~~~~~~
>
> 3. Remove duplicate inline.
> pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
> specifier [-Wduplicate-decl-specifier]
> static inline __always_inline
>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes since v2:
> - In split_huge_page_test.c, print error message and then go to cleanup
>   tag for cleanup instead of just exiting without cleanup
> ---
>  tools/testing/selftests/mm/Makefile                | 1 +
>  tools/testing/selftests/mm/hmm-tests.c             | 5 ++---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
>  tools/testing/selftests/mm/split_huge_page_test.c  | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index d13b3cef2a2b2..23d4bf6215465 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -34,6 +34,7 @@ endif
>  MAKEFLAGS += --no-builtin-rules
>  
>  CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
> +CFLAGS += -Wunreachable-code
>  LDLIBS = -lrt -lpthread -lm
>  
>  # Some distributions (such as Ubuntu) configure GCC so that _FORTIFY_SOURCE is
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 141bf63cbe05e..15aadaf24a667 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2027,11 +2027,10 @@ TEST_F(hmm, hmm_cow_in_device)
>  	if (pid == -1)
>  		ASSERT_EQ(pid, 0);
>  	if (!pid) {
> -		/* Child process waitd for SIGTERM from the parent. */
> +		/* Child process waits for SIGTERM from the parent. */
>  		while (1) {
>  		}
> -		perror("Should not reach this\n");
> -		exit(0);
> +		/* Should not reach this */
>  	}
>  	/* Parent process writes to COW pages(s) and gets a
>  	 * new copy in system. In case of device private pages,
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index b5e076a564c95..302fef54049c8 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -41,7 +41,7 @@ static siginfo_t siginfo = {0};
>   * syscall will attempt to access the PLT in order to call a library function
>   * which is protected by MPK 0 which we don't have access to.
>   */
> -static inline __always_inline
> +static __always_inline
>  long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
>  {
>  	unsigned long ret;
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index bf40e6b121abc..de0d26f3df675 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -297,7 +297,7 @@ void split_file_backed_thp(int order)
>  
>  	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
>  	if (status >= INPUT_MAX) {
> -		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
> +		ksft_print_msg("Fail to create file-backed THP split testing file\n");
>  		goto cleanup;
>  	}
>  

