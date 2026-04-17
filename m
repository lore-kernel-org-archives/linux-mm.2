Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D892F8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5D76B0005; Fri, 17 Apr 2026 00:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599436B0089; Fri, 17 Apr 2026 00:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ABA46B008A; Fri, 17 Apr 2026 00:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3386B0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:36:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B84AFC296A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:36:46 +0000 (UTC)
X-FDA: 84666787212.16.54E8D35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E07440006
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:36:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bsLlHEHH;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776400605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNNlTvzFbP2UmOe34EPpNLkhuJGYi+J4rgNK/FPuUhE=;
	b=Zxaep4LpE5ancJci5fZzL80R/Ih+UAW44WZ+Ed4LsFjZXPsJDISBOi14TXbqZii2DWB5tn
	LBrRdynh7tDT6WiM8EeyiCC+k4BX1Fek8C5EMITF4BiSyEDc9ygtPEowTzOFPwA+K5WXe3
	E5EaFX/kvhYLjASTkQvKZR8QKszj00Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bsLlHEHH;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776400605; a=rsa-sha256;
	cv=none;
	b=ZFBWiTl1eh/HpHQPoqXwAhHM3VsqNksAsW+GVKNgMCbfu4pcL3l6lIpScna56e1qsviV91
	mkQfs/IT0/Ln87tmDfER4edAnmnrcc2xEmZEMW+N4apyf+o1zkONHMN+NUrtCiWvE2OJW/
	Y3fyhYkHbw2Fgq5fWVj6BDzc/vt78AA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81F841E8D;
	Thu, 16 Apr 2026 21:36:37 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D4D13F641;
	Thu, 16 Apr 2026 21:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776400603; bh=mx831Os8dYfoqbDqntabhSKcGoZy9kcJenvHhyzZZBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bsLlHEHH56qecEtqnmNS5H9GCf7snAhPw00IZzlmlqJhwRx98e+SBFMZGyOnaMymr
	 ThQ3lu3BhAQXJ/NCoKyE25hUepTfqtK+kKiqmoPQ3LnUR/VWz7hT7HELM6S0i9kzcj
	 eaM9IuN+QeWGSNcLhcFua54RrFXOcf0jMkijHnxE=
Message-ID: <fcdd3d35-f16d-404d-8870-3361ab873f69@arm.com>
Date: Fri, 17 Apr 2026 10:06:27 +0530
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
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aeE4XSuXY8RfphVs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E07440006
X-Stat-Signature: p9fkuy3s5niest3eky8zuakt6jj9xsqb
X-Rspam-User: 
X-HE-Tag: 1776400604-364123
X-HE-Meta: U2FsdGVkX19rkd0ydtoVLPC21hz5TwmRDy7SNBBQD39qbOe7PNuvLOs31N8hCE6lg9bEv7KxsCdMXtIIYfsXAnZhJUeY0tz5pOMT4Sy+FTrmx9S+BQfb/D9RvcZ48zjNJHf1xFjGK5eHBWLhDzWheMwlZrojGtcUC/wOCUOsQkeoSwkTZvzAw/kYA+fQiQ+NCEBZU/LbaJCn4EKll4dsP41c/crrh8cNJ4z/w2s5vIprawdhegkpqDWB/70A93igACzhvsSPAoRsfql1JS0ebzhNyzn3hAtYN9VwqZ/RGFd5HXo5t7XtCXZjo+Za5A8RhBVaHiRfOmU1v+or6w7psXM6f1HP5+vKYeRYPVfvDE+Ir0d9FaSn3I7dYLjfJjVuoryZNXG6JWUc5YYC9SlIiNfnzNRHwwA2JfIW8wD5xkfLsAWkgwJKK5QzRBO1AzV+XWFLHv0ihti++PY3rDWscB6+bcFQdkKYoyNR2jVWa2mYU5p+RxmI7Tfkl8kSvvZQDksdhGzzpLcxuZCa5auP6UO+KP8eb1KZd2UthIivHaetBFDS3ZnXCxnSClZ6BUu+JEGiYhtfvdmjgmx/phJ6FoM+8cTC+iAmAaNMIk6z5lJ9HltGwtwOtpOwb9Iiw8R3B+BeYH+psaAEiIsYplHZA+mm3i5G7hd3wrHlvhk6lAIz7vVHE8uu0O0MzTVjVicf+duhATXRW08TQ2SminsGi+iNZeUA7eipD9mT9LEc9PbocryhC0IKhvFuEIt8yRhaLGyboth4P+UN822vapDxys0QbTnQeWgLwzsNUqVTXbarXSaLLgb5oJEkKNalM/8wWEqJM9XEm/cip11Dp1wv0jePuUtvdR7sjXSzyEMjPrCC50qWKiN+AT6Lo8G6/SBdRVwk/OMWQhlBZAAQMrk8cQl4CbAm8rpEjJXke3Isr0qsx2I0WZNxodYkbkut/Fde8qy680JbmvQl7ghhqzC
 S4YebvZ6
 cJUbeykJQZ/AAk3YGoOohsYKH523FIynYP1s36gsxuLdgDGRhvGOp3hzubYSRhwIR69VjVL6ePYR65k0MRdPrsVPoUJ1ALQksLFBE8X/EvClxqIjBppeM9utroExzZ27hJH3jRlyC5ghTKIQwN24uunBmtV3EHjXUklAcP62ZhefKZEFWkjpaUGXEkZrOJAaheyZ33RpaQYo+aDHcW4+hiOIpB4QmKm6gLKIXgl3KvV/KXX3f7UStvFPUoQMi0/zrRKiU6e8yneq/ePS4pJiXhDksEjWn/CEYJiZu+e8S+zIJzf1UuYU6RP7kJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17/04/26 12:58 am, Mike Rapoport wrote:
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

Looks fine, but would be better to close the fd before function exit?

I can review if you plan to send a patch : )

> 
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> Thanks.
> 
> 
> 


