Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2782D29C28
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 13:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA716B01A0; Mon, 19 Jan 2026 08:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085736B01A2; Mon, 19 Jan 2026 08:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC95C6B01A3; Mon, 19 Jan 2026 08:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA9136B01A0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:29:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ACA21A0113
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:29:28 +0000 (UTC)
X-FDA: 84348795216.18.B2B7A0F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8D18C000C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:29:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768829366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8v8ZMpGbwFG1Br1hfdCEyTZrMXw9YgADFPAcQwGpm44=;
	b=qETQxArTxLCtrhDL2S4nL6OyMTRCjNl6hIgLh66Efv5LfUtucyRdbBQ21rGZIKH2ZlTyUs
	79gb0DG88FvD9dvwYGjVwvUnE2SJdY8DSR6AZF1d9Ir/Cr52OtnYnP0jMgAInD5NN9gf46
	NsnBqlJzQsHGppIYJo9GbrWtJUz8XIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768829366; a=rsa-sha256;
	cv=none;
	b=2Zv3bM2GHiKv9ai4CGRgCE9NNAhpA50pKg3erwyMSCafFOgOkw/X0vmaqRRfynUUcoqDjv
	SSxFXrsqiWrdYBtXaaY8P+ZcxEbw1mlVX4VNNBlGk9hsPIMPJmrFC2nbl3DyoObxi22C8Y
	cqYlWp/Xhkzp1z4FkFJ6oHPxFGPUzZA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 349CD497;
	Mon, 19 Jan 2026 05:29:19 -0800 (PST)
Received: from [10.44.160.85] (e126510-lin.lund.arm.com [10.44.160.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 316413F740;
	Mon, 19 Jan 2026 05:29:23 -0800 (PST)
Message-ID: <5660b5ea-16f7-485a-8daa-d3d6cb4af310@arm.com>
Date: Mon, 19 Jan 2026 14:29:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] selftests/mm: introduce helper to read every page
 in range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-6-kevin.brodsky@arm.com>
 <aa0ad9eb-dab8-4c29-827d-bed4983a584b@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <aa0ad9eb-dab8-4c29-827d-bed4983a584b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8D18C000C
X-Rspam-User: 
X-Stat-Signature: unsn1im78tqy9q38ca5r8yowgh47bm7m
X-HE-Tag: 1768829366-612284
X-HE-Meta: U2FsdGVkX1/YJmOSy2wLs4z4ZOBXdOaW6Q+FTn4JRJv7O345AxLI9YWbCx/LIzN4nn9cwADPgo1MOlklSchUmQvrQXL1E/x8UIQjzYIKb8yvK/9sESJ6YUQ4VJy8ddSzmrrWN559biKv49Tuxv0tNFOeaSuYvhBz2FoxT5uLCYoZmD5q+HnLRlARRXIhjw+Ms3yWsVMkR6vd5fXSfuFx+07Bhj4NfaRvNkBbKf0kQLqgm57Wl6hUNEpx60mQRLTs5XiqKmlNAq7zhhWPJ7uOcTCRhcjglZWVVoGdvyHT+mIViVBr+A6qOCv7WdWz2IP4+tG3QekE8xHoR/3V1eMBAmqzq5EXyQ+XnYF11FAuiRIcDTR0Hd9GK3FBFRzGxUYFgwQyrI26/T6nqoCWX2O28PxygGpqd1JYX3WwS269YrBFqDSaEUwcDGrSfqAyZvdyyk5dsTRguoqRoMotNLrlIHqkrPzYF573TaWNgDSq4qfcwaltmVrtisMWKdmPW5YKzylh3kekyAnoXvUXrT2O9hpcVQj+XsuE+q0RqvBlH7RZ9O52gBN97gEz/cHe/k0UpR6uabcpddfhsnHES9bYidhl2DIzmOa8qJE/rs6ODLqvEabsd/eDMkQcX8gxWWLsCeIaBvqDZhvV39D76RPJT9jxyWD13HTTLW5Wph+Ok9JN0sojeTJCQs/HrOnjIyqYnL8fk11CljFxWcqT8lz6GndfE9miejICmC2fWqB9XPnn1UwtDxfbkIuuyiaRxDVLELnM12BGNygL421GpXdwNDu8258Dqx7Mh/ALqzHZalpQthk7bnvDRzAUWz+tUN1BjieKgze9k5qBd6yE4qkkUmKnmIUyk1XM4OxEjFMQIfGX9In5F1c2es3guEq+5vd2TiUs602qefuOg2XSLdmklhuO4x25bPL+l2VheeT3zEQ2vw8nBzwW8tHpOn1sIMKIEpH4lQuZ5mW4CgUbMqh
 a+e59s9Q
 aCqLnjO9KxtgB9rrP7K9EC1IVi1Ei8IHVMlwqlcJ4t7oynIhTlRvDQbDDYQlESlq9FfP5BFkUbeOPphaEkXPjZuFPFFjTJoXhbFczSrSHWCtCaRCHQevFdFjjA9aMP2hol8Isxs2OxEUWu5L4pGLm0CTAejf/g3hTVBEpKkrL4VqX7EJ2jtQvpQAEWckQbczMOmDBT6jpq5T9i55YxHzgjucvhOOBu4PTBexNFZTBZc4n+4/c0TK8jSOLK2VqOjCljO5EtX2NdUOvaj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/01/2026 11:55, David Hildenbrand (Red Hat) wrote:
> On 1/7/26 17:48, Kevin Brodsky wrote:
>> FORCE_READ(*addr) ensures that the compiler will emit a load from
>> addr. Several tests need to trigger such a load for every page in
>> the range [addr, addr + len), ensuring that every page is faulted
>> in, if it wasn't already.
>>
>> Introduce a new helper force_read_pages_in_range() that does exactly
>> that and replace existing loops with a call to it. Some of those
>> loops have a different step size, but reading from every page is
>> appropriate in all cases.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   tools/testing/selftests/mm/hugetlb-madvise.c     |  9 +--------
>>   tools/testing/selftests/mm/pfnmap.c              | 16 ++++++----------
>>   .../testing/selftests/mm/split_huge_page_test.c  |  6 +-----
>>   tools/testing/selftests/mm/vm_util.h             |  6 ++++++
>>   4 files changed, 14 insertions(+), 23 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c
>> b/tools/testing/selftests/mm/hugetlb-madvise.c
>> index 05d9d2805ae4..1f82568ae262 100644
>> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
>> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
>> @@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long
>> nr_pages)
>>     void read_fault_pages(void *addr, unsigned long nr_pages)
>>   {
>> -    unsigned long i;
>> -
>> -    for (i = 0; i < nr_pages; i++) {
>> -        unsigned long *addr2 =
>> -            ((unsigned long *)(addr + (i * huge_page_size)));
>> -        /* Prevent the compiler from optimizing out the entire loop: */
>> -        FORCE_READ(*addr2);
>> -    }
>> +    force_read_pages_in_range(addr, nr_pages * huge_page_size);
>>   }
>>     int main(int argc, char **argv)
>> diff --git a/tools/testing/selftests/mm/pfnmap.c
>> b/tools/testing/selftests/mm/pfnmap.c
>> index f546dfb10cae..35b0e3ed54cd 100644
>> --- a/tools/testing/selftests/mm/pfnmap.c
>> +++ b/tools/testing/selftests/mm/pfnmap.c
>> @@ -33,20 +33,17 @@ static void signal_handler(int sig)
>>       siglongjmp(sigjmp_buf_env, -EFAULT);
>>   }
>>   -static int test_read_access(char *addr, size_t size, size_t pagesize)
>> +static int test_read_access(char *addr, size_t size)
>>   {
>> -    size_t offs;
>>       int ret;
>>         if (signal(SIGSEGV, signal_handler) == SIG_ERR)
>>           return -EINVAL;
>>         ret = sigsetjmp(sigjmp_buf_env, 1);
>> -    if (!ret) {
>> -        for (offs = 0; offs < size; offs += pagesize)
>> -            /* Force a read that the compiler cannot optimize out. */
>> -            *((volatile char *)(addr + offs));
>> -    }
>> +    if (!ret)
>> +        force_read_pages_in_range(addr, size);
>> +
>>       if (signal(SIGSEGV, SIG_DFL) == SIG_ERR)
>>           return -EINVAL;
>>   @@ -138,7 +135,7 @@ FIXTURE_SETUP(pfnmap)
>>           SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
>>         /* ... and want to be able to read from them. */
>> -    if (test_read_access(self->addr1, self->size1, self->pagesize))
>> +    if (test_read_access(self->addr1, self->size1))
>>           SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
>>         self->size2 = 0;
>> @@ -243,8 +240,7 @@ TEST_F(pfnmap, fork)
>>       ASSERT_GE(pid, 0);
>>         if (!pid) {
>> -        EXPECT_EQ(test_read_access(self->addr1, self->size1,
>> -                       self->pagesize), 0);
>> +        EXPECT_EQ(test_read_access(self->addr1, self->size1), 0);
>>           exit(0);
>>       }
>>   diff --git a/tools/testing/selftests/mm/split_huge_page_test.c
>> b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 40799f3f0213..65a89ceca4a5 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -652,11 +652,7 @@ static int create_pagecache_thp_and_fd(const
>> char *testfile, size_t fd_size,
>>       }
>>       madvise(*addr, fd_size, MADV_HUGEPAGE);
>>   -    for (size_t i = 0; i < fd_size; i++) {
>> -        char *addr2 = *addr + i;
>> -
>> -        FORCE_READ(*addr2);
>> -    }
>> +    force_read_pages_in_range(*addr, fd_size);
>>         if (!check_huge_file(*addr, fd_size / pmd_pagesize,
>> pmd_pagesize)) {
>>           ksft_print_msg("No large pagecache folio generated, please
>> provide a filesystem supporting large folio\n");
>> diff --git a/tools/testing/selftests/mm/vm_util.h
>> b/tools/testing/selftests/mm/vm_util.h
>> index 6ad32b1830f1..74bdf96161d7 100644
>> --- a/tools/testing/selftests/mm/vm_util.h
>> +++ b/tools/testing/selftests/mm/vm_util.h
>> @@ -54,6 +54,12 @@ static inline unsigned int pshift(void)
>>       return __page_shift;
>>   }
>>   +static inline void force_read_pages_in_range(char *addr, size_t len)
>> +{
>> +    for (size_t i = 0; i < len; i += psize())
>> +        FORCE_READ(addr[i]);
>> +}
>> +
>
> Of course, we could also just pass the pagesize
>
> static inline void force_read_pages_in_range(char *addr, size_t len,
>     size_t pagesize)
> {
>     for (size_t i = 0; i < len; i += pagesize)
>         FORCE_READ(addr[i]);
> }
>
>
> Or alternatively even better:
>
> static inline void force_read_pages(char *addr, unsigned int nr_pages,
>     size_t pagesize)
> {
>     for (size_t i = 0; i < nr_pages; i++)
>         FORCE_READ(addr[i * pagesize]);
> }
>
> Then there is no change at all and we avoid the repeated psize()
> naturally.
>
> Thoughts?

Sure we can do that. I concluded that all tests fetch the pagesize in a
different way and some aren't using psize() sparingly either (e.g.
gup_test) but I suppose that avoiding some ugliness doesn't hurt :)

Of course this especially makes sense for the hugepage tests (then we
can still read hugepage by hugepage).

- Kevin

