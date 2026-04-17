Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE08F8E497
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EE76B008A; Thu, 16 Apr 2026 22:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06636B008C; Thu, 16 Apr 2026 22:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BD76B0092; Thu, 16 Apr 2026 22:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80FF46B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:56:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22AA8E4D7B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:56:48 +0000 (UTC)
X-FDA: 84666535296.03.94C6B59
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 08A96140002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:56:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=M8X2GZ8y;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776394606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hBpGkTg1PgyAJBD7twOOuJ+aqpiDRnrEiAz0Hh62Rs=;
	b=70xblcoLzHK/Mzo1MFY1o6pyQGHKrzmnsZxSBN5z/XUkyOkcef+t4851yuPtjxsy2gIxZ3
	9l44LOWWZ45Y24Pghdj7qnFqzVqwpfxMaZEXsPxWCifB5pIGhPI45cqnV1uhuW7ICeNaAh
	shfhOsbvovYHBe3Sw7L5JKS6t2iDojc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=M8X2GZ8y;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776394606; a=rsa-sha256;
	cv=none;
	b=8rIYWpfQC31BvptBEEQyKcKjMt3d0QdXIaYZUmSSrKNdLBNDoph5MrQEm4mMpC+DMsFEou
	vB+zVpHScioFfQlaZxjAas7dqUGQNp8Elj1b34fuIgX73FVakJTbTA7bH15F9SEjJxP7ti
	/q7HaBcR3ziJwyGc971AMuyM/TbGeck=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BB5F165C;
	Thu, 16 Apr 2026 19:56:39 -0700 (PDT)
Received: from [10.163.182.249] (unknown [10.163.182.249])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 112CC3F7B4;
	Thu, 16 Apr 2026 19:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776394604; bh=9yoj+9oeEOwnrvff37at3nCipTt6lz6mKXZWJBxfIgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M8X2GZ8ypCm0VLfXOXX1CmyqgoRIfqPMz6W9lp//mbyhZ/QrtqatUvTs4fbYSDAFo
	 kQNAxxrcNdsOtRq83S56upNsXbISnVASnftmGy3ajXX/1IU5fU6aBPkscDmM/QtsvJ
	 jwga2vxGy4SjiCYKGaSFGuOICX7fn6gp+pUatthI=
Message-ID: <aee4e68c-077f-4056-9d40-69bc849d1538@arm.com>
Date: Fri, 17 Apr 2026 08:26:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
To: Mike Rapoport <rppt@kernel.org>, Mark Brown <broonie@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
 <aeE4XSuXY8RfphVs@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aeE4XSuXY8RfphVs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 08A96140002
X-Stat-Signature: 7dgmeknzwzwpjq5ycrewuzru5crf9erm
X-Rspam-User: 
X-HE-Tag: 1776394605-764355
X-HE-Meta: U2FsdGVkX180WiNHhlk1ws2eN9JLCv3I1Pf7DjY00Dt2oyoxYy3Sn12PqVRqcDJkce+nMh2CCqVLkSO4dWYOOLA8TSS0h8YP8vJwLqai96DZi4Zm/MNQ8IRO6S1m8XgpwOYwXH0tZph2qSr8ACrM/AUgQDiQURkmYemKARzxZywPOyqIb98mfqkVbxrC6uNGnFx42X1MzKJ1Y7vrApy2QY8ZyB3XGalFPwTFFDplaXniPgHE+eLjnJ+IQc+7to9sGh0DV/phsYyUb3110aY0UZ9bh5QFEr+SoNh2kQoUyhOXk3yyKcQ9v56ivyKKt68xyVOIIjgT7y3Qzl/bUxORLtwBpR5VSPCaQ4xLm7SiVIZ9tJZ8LPtF235A7jdMjL/2AFr8d4ecAQjfdYxF6GrhGYcy0zEPsJOXEXGACa4xqmAMVd9Dr+dfcsRJdKz9sufQLjmDHmg9biXTYT+2DOoSOVcwlRBJQEJLjW9jc2/F0swBmAveHc/RMp5L8sNhG9TnUs5OusqUKU/Ro/1OzCx3Fi3JsoWfTQFhd7CJE4J2Tinb8it34UFauDfvGdkC75kzHxXNRDw1nVUNwOhxSxyrYHoxQOp9/LcLzGYEPNYdTgJ7qyO4wJ+YsQ6JLB+xF3voF/K+Dzq0I3TnTd9j/7DwJ7HifhBrsI/IfS7WIRBhBTc4iFgAuLIWjSa6pEPq0ggxPIGtftUGIzC7hlh0Uhl/MZyLrmk49BQROwSL4AF+dr8JqelqBzsxgI4zS+PPwIlT4fKDOgRWEIbDVqqFTwS/taA7D5/GUj16s3ePHwSCpPaMxL7TNtkaqJf8wym6J+7KDOnRgUeMeZRz5kU8NBPubn+nE8B4j4NUvxrpqXvHujVHsPJHlCcKrWpnpYPHkZp7ICFKBl9f9eiD8Nxgd2Nnj1+scPCpLUxCIer/OFOf/cHUXHJJU4CrLif+IHUy1cbma4HSSsV63eJlU0kuEVa
 vFREm/gi
 94ElWKEaALQ5kOq8ky/h4bEty4dlhqQqAASVyTvCYQ0tJHv/evzIB7XwhN94ZbS1iTYwjo+H3FHqevxJFNc+fm+8WZGr3nJ0Wt0JJSvES+soIWwfZqAVC1+yHyh6Hm4bf2wJ0CLrgefpvELnTn9dQ9PAE3U56en+UU1j9vbt+dUy10dW2TAJo23Cr5b/zJo4+8rQ5JXw0zOolLR9YSDGecJ2aCrV88mxmMgZ643kqv/vIPwci2EBdd4bBvquDDxo3JG5BoaRJr4gNiZRiKEcdCSw6Ib196EWXUQ18G2cnAWI3aj77g9r91Tf/zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17/04/26 12:58 AM, Mike Rapoport wrote:
> On Thu, Apr 16, 2026 at 08:10:53PM +0100, Mark Brown wrote:
>> On Thu, Apr 16, 2026 at 09:05:11PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/16/26 20:40, Mark Brown wrote:
>>
>>>> Several of the mm selftests made use of /proc/pid/mem as part of their
>>>> operation but we do not specify this in the config fragment for them, at
>>>> least mkdirty and ksm_functional_tests have this requirement.
>>
>>> I guess we could teach most tests to SKIP if /proc/pid/mem is unusable.
>>
>> That would be nicer, yes.  I imagine some of these will predate there
>> being a configuration option here at all, it's possible there's newer
>> tests that skip cleanly - I didn't look at the skips.
> 
> Enabling access to /proc/pid/mem keeps the coverage, not that it's great
> right now, but still.
> 
> But sure graceful skips are better than failing the entire tests. Would be
> something like this:
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 8d874c4754f3..374b5a25f36d 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -37,7 +37,6 @@ enum ksm_merge_mode {
>  	KSM_MERGE_NONE, /* PRCTL already set */
>  };
>  
> -static int mem_fd;
>  static int pages_to_scan_fd;
>  static int sleep_millisecs_fd;
>  static int pagemap_fd;
> @@ -622,10 +621,17 @@ static void test_prot_none(void)
>  {
>  	const unsigned int size = 2 * MiB;
>  	char *map;
> +	int mem_fd;
>  	int i;
>  
>  	ksft_print_msg("[RUN] %s\n", __func__);
>  
> +	mem_fd = open("/proc/self/mem", O_RDWR);
> +	if (mem_fd < 0) {
> +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> +		return;
> +	}
> +
>  	map = mmap_and_merge_range(0x11, size, PROT_NONE, KSM_MERGE_MADVISE);
>  	if (map == MAP_FAILED)
>  		goto unmap;
> @@ -694,9 +700,6 @@ static void test_fork_ksm_merging_page_count(void)
>  
>  static void init_global_file_handles(void)
>  {
> -	mem_fd = open("/proc/self/mem", O_RDWR);
> -	if (mem_fd < 0)
> -		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
>  	if (ksm_stop() < 0)
>  		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/run\") failed\n");
>  	if (ksm_get_full_scans() < 0)
> diff --git a/tools/testing/selftests/mm/mkdirty.c b/tools/testing/selftests/mm/mkdirty.c
> index 68dd447a5454..e4a94638018b 100644
> --- a/tools/testing/selftests/mm/mkdirty.c
> +++ b/tools/testing/selftests/mm/mkdirty.c
> @@ -27,7 +27,6 @@
>  
>  static size_t pagesize;
>  static size_t thpsize;
> -static int mem_fd;
>  static int pagemap_fd;
>  static sigjmp_buf env;
>  
> @@ -86,11 +85,18 @@ static char *mmap_thp_range(int prot, char **_mmap_mem, size_t *_mmap_size)
>  static void test_ptrace_write(void)
>  {
>  	char data = 1;
> +	int mem_fd;
>  	char *mem;
>  	int ret;
>  
>  	ksft_print_msg("[INFO] PTRACE write access\n");
>  
> +	mem_fd = open("/proc/self/mem", O_RDWR);
> +	if (mem_fd < 0) {
> +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> +		return;
> +	}
> +
>  	mem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE|MAP_ANON, -1, 0);
>  	if (mem == MAP_FAILED) {
>  		ksft_test_result_fail("mmap() failed\n");
> @@ -124,10 +130,17 @@ static void test_ptrace_write_thp(void)
>  	char *mem, *mmap_mem;
>  	size_t mmap_size;
>  	char data = 1;
> +	int mem_fd;
>  	int ret;
>  
>  	ksft_print_msg("[INFO] PTRACE write access to THP\n");
>  
> +	mem_fd = open("/proc/self/mem", O_RDWR);
> +	if (mem_fd < 0) {
> +		ksft_test_result_skip("opening /proc/self/mem failed\n");
> +		return;
> +	}
> +
>  	mem = mmap_thp_range(PROT_READ, &mmap_mem, &mmap_size);
>  	if (mem == MAP_FAILED)
>  		return;
> @@ -343,9 +356,6 @@ int main(void)
>  	ksft_print_header();
>  	ksft_set_plan(tests);
>  
> -	mem_fd = open("/proc/self/mem", O_RDWR);
> -	if (mem_fd < 0)
> -		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
>  	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>  	if (pagemap_fd < 0)
>  		ksft_exit_fail_msg("opening /proc/self/pagemap failed\n");
>

Change LGTM making these tests skip rather gracefully.
 
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> Thanks.
> 
> 
> 


