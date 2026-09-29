Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65338CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E726B0093; Tue, 29 Sep 2026 05:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5936B0095; Tue, 29 Sep 2026 05:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635446B0098; Tue, 29 Sep 2026 05:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1F16B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:12:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F04BFA044C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:12:56 +0000 (UTC)
X-FDA: 85266235152.18.041EA23
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0065740004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:12:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="js/r2/ns";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790673175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng+a4MUP0GHJFX92oLDnEZUQa684ogvE7SDjPsib84M=;
	b=N5viRYwXwAVFUXs9M13vxAQ4QB1SpFZO0DUKZjGjCR46CoaGy0rbpxjOpAR5u47uGhlSTV
	YY4DtlBUx+UXBd4w04x56AFWcQuaQkDGC102ufaoQeQS6ljCKeoLVuLLeHj/SCzGDwpZFZ
	HbYYdDzbOh7PRjiKBSpZaLmrZ8lc84A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="js/r2/ns";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790673175;
	b=nBP00Jh+xyw3cRRV6UsL6EPXmb0ezh7esKlFAQ1zb/3ZuKQf1CFxwzYjUN0lxQ2QA4mv/M
	+UZpw3/RJQJSEmEhv627D33VpZFny7w7x0V+gvYCFcyzoH/G9bMIp+/SgD0ApLo6vyaIxe
	90OcqIk2kvw8uUzXCI7GTQIzmASt5IA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89B061516;
	Tue, 29 Sep 2026 02:12:50 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA4863F85F;
	Tue, 29 Sep 2026 02:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790673174; bh=L+A+ki4F258ZbWCrWJlsH2ukcU/51HiXJ123/RCt0cQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=js/r2/nsA1DwL2WcPDO5OkJF7bZRGKScgjzgGMCwIST8iXOV5Sr5cJTpwJpzGiiBc
	 bOT/l1RvLUkJ7ULIyZAgBvUYe75Sb5bsKniFMPIqa7ORqSb8KvMNJKm1iQxb8KyN/3
	 7V/udeDnpU65E9tX4vXIHlIRSsmqc3tR3NzBZn88=
Message-ID: <498b8fc3-ef39-424c-81b1-aa4bfdb7eac7@arm.com>
Date: Tue, 29 Sep 2026 14:42:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 1/9] selftests/mm: mremap_test: use kselftest
 helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-2-sarthak.sharma@arm.com>
 <6c349d10-2160-4166-8b63-3d60b42a5b69@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <6c349d10-2160-4166-8b63-3d60b42a5b69@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0065740004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: o15dp3a6n4kdeanp1pjzwyxwnhqdy7zs
X-HE-Tag: 1790673174-930286
X-HE-Meta: U2FsdGVkX1/If4AoFGpKkv1NuEkkZM7dGJwTLPvcV1mTqPmvMpwiGVHlf2StU4Smx7w5SHpsLCMdrBYK12AejlVL+Tjdqx+T1BkzfudUqOmq/s/v6d3o5YX2/ilFRCVvbD14vrWIN+JR6hs3tTt3tcjeBYGFwS8o2eYDA1qSO2F6MD5LmK8XFDqBwhamitlTmqpXH3QZwd7rnIs8FWKVrWP0phL80ib3pNVIMzmsYhZoz/2jRGVnDPu/ieZTF+LmFJDhgzzZ/swNj4gmtQnQXs910c97+yPbh2hm8v9szqkTr9Nij9Ykg0yGmsz4uNFrkh9Q9P7cc/DRMI/ccK5eoha9qVgWKjKGGhdbqpyWI/CVGgvtBS+T8vUrbKQ8FffYqFR+Xej0I15crlv32BDI4csaZHwNj2vZuiD5ManrdtkFOWarFZK10abVNBpzQxrBSQvwDlNepItZhsFZXx1pTAABkeB9+IZORIuSjilSXGzz3gLi+6eCQNpHzLln4dASweapJBVHAF25jIvExZCphXwBt9YbjAgq78ybOGtsu7ITq2OnBF3smlLh6MctgH49R6U+Tl+fNYvKL4ZUGoFrDin8IHSzqdlC5aTpnqtTE6kRKBtkuWTeFHQwI/1QhZpsEhF6aqa8kKTJh9h/B7Jn1L1YnK38YBx09lW5W0kZIFE6mP/FOTpf7Fht17K5ASPQUpmbxNar8VHDadgfhyX1BK+QQ9fhDVpU2xs3c83lWqUOuaHGybO0T5HG7ubZDo/nEMOFVfDK3WaShUfeby/QfzS0OK0Kbsog29/gnRNRbuZM/gDtfnp0m1wvlx24vPr4v8+V/S+2nHAKaSNkxPqsRy6m+uIef7s6oOk1YS562l5Ay13kzHhY+eYyZ4if8XT52CUAYNVVA3i5oZMP/iI5A3Yoyh1v9fbZwQ6wQXMDcmVgYtenPpV8n0nvTKbO8ezIA3IKVupSMlGoTrprhhL
 HWIPvgU2
 6QS+/hMYJEkfGrK1iQV9L6drhGDTCSEbZhxnT0jP4Lvg2rLFrzfCMa8tBiy4Zh90vXT8UoVYeHM+ld9GwamrMG8pdzwTZw601nH3JO8r7BZQ5Z9tJ/4/2nx7TzVSDC+yKG+V064CAShn4i7foc9yaEcj2fVbi/MHJW9p+pWDPB41Pk+0/x75LOND9KZ2rAjKfTKLXzRfzw0rypq1EHAshAUzlXfBuPrprcRDGn8NdGkRg6puRhsBzuB+FnY1HX92HNIC7gt/sxKqZNCemQ12Hl45gmjPNC3rpacCOU292gSs9ckiWUUaE3hKoFgb9RrKfVi1S5ThZwNoy6OcjpFwQh0D5btKHbmve+4R5J7vXePWCLyWfUMTlrpvAuzqnfK1GLKOi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 9/29/26 1:28 PM, David Hildenbrand (Arm) wrote:
> On 9/24/26 07:00, Sarthak Sharma wrote:
>> mremap_test currently uses a lot of fprintf() and perror()
>> calls. It also uses a variable "failures" to track the number
>> of failed table driven tests.
>>
>> Use ksft_print_msg() and ksft_perror() for diagnostics.
>> Remove the variable "failures" and let kselftest counters
>> handle the final exit status. Use ksft_finished() at
>> the end instead of manually checking if failures > 0. Replace
>>
>> if (success)
>> 	ksft_test_result_pass(...);
>> else
>> 	ksft_test_result_fail(...);
>>
>> calls with ksft_test_result(success, ...);
>>
>> Also correct the duplicated "mremap" in "mremap move within
>> range" and the spelling of "dontunmap".
>>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
> 
> [...]
> 
>>  #endif /* __NR_userfaultfd */
>>  
>> @@ -1124,7 +1096,7 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
>>  	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
>>  						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
>>  	if (new_ptr == MAP_FAILED) {
>> -		perror("mremap");
>> +		ksft_perror("mremap");
>>  		success = 0;
>>  		goto out;
>>  	}
>> @@ -1145,59 +1117,49 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
>>  
>>  out:
>>  	if (src && munmap(src, c.region_size) == -1)
> 
> While at it ... why the comparison with -1. And why do we worry about munmap()
> failing at all? We generally ignore these errors on the exit path, as it's
> unlikely we would ever hit them, and there isn't a lot we can do.
> 
> So maybe just remove printing errors entirely?
> 
> if (src)
> 	munmap(src, c.region_size)

Yup, this check is not supposed to be on the exit path. I'll fix this.

> 
> ...
> 
>> -		perror("munmap src");
>> +		ksft_perror("munmap src");
>>  
>>  	if (dest && munmap(dest, c.region_size) == -1)
>> -		perror("munmap dest");
>> +		ksft_perror("munmap dest");
>>  
>> -	if (success)
>> -		ksft_test_result_pass("%s\n", test_name);
>> -	else
>> -		ksft_test_result_fail("%s\n", test_name);
>> +	ksft_test_result(success, "%s\n", test_name);
>>  }
> 
> [...]
> 
>>  static void usage(const char *cmd)
>>  {
>> -	fprintf(stderr,
>> -		"Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n"
>> -		"-t\t only validate threshold_mb of the remapped region\n"
>> -		"  \t if 0 is supplied no threshold is used; all tests\n"
>> -		"  \t are run and remapped regions validated fully.\n"
>> -		"  \t The default threshold used is 4MB.\n"
>> -		"-p\t provide a seed to generate the random pattern for\n"
>> -		"  \t validating the remapped region.\n", cmd);
>> +	ksft_print_msg("Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n", cmd);
>> +	ksft_print_msg("-t\t only validate threshold_mb of the remapped region\n");
>> +	ksft_print_msg("  \t if 0 is supplied no threshold is used; all tests\n");
>> +	ksft_print_msg("  \t are run and remapped regions validated fully.\n");
>> +	ksft_print_msg("  \t The default threshold used is 4MB.\n");
>> +	ksft_print_msg("-p\t provide a seed to generate the random pattern for\n");
>> +	ksft_print_msg("  \t validating the remapped region.\n");
>>  }
> 
> That looks odd, as we will now print this as "# ". I would have assumed that
> removing all parameters as the first patch would make things cleaner?
> 
> So as a first patch I think we should just remove the parameters entirely. They
> are unused by our infrastrcture:
> 
> 	run_vmtests.sh:CATEGORY="mremap" run_test ./mremap_test
> 
> Does anything speak against that?

Okay, I'd kept the 7th and 8th patch of the series for that. I'll make
them the first and second ones then, this will remove all this churn.

Or maybe remove all parameters altogether in the first patch itself.

> 
>>  
>>  static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
>> @@ -1232,7 +1194,6 @@ static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
>>  #define MAX_PERF_TEST 3
>>  int main(int argc, char **argv)
>>  {
>> -	int failures = 0;
>>  	unsigned int i;
>>  	int run_perf_tests;
>>  	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
>> @@ -1260,7 +1221,7 @@ int main(int argc, char **argv)
>>  	pattern_seed = (unsigned int) time(&t);
>>  
>>  	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
>> -		exit(EXIT_FAILURE);
>> +		ksft_exit_fail_msg("Invalid arguments\n");
>>  
>>  	ksft_print_msg("Test configs:\n");
>>  	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
>> @@ -1282,7 +1243,7 @@ int main(int argc, char **argv)
>>  	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
>>  				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>  	if (rand_addr == MAP_FAILED) {
>> -		perror("mmap");
>> +		ksft_perror("mmap");
>>  		ksft_exit_fail_msg("cannot mmap rand_addr\n");
> 
> Would be better combined like:
> 
> ksft_exit_fail_msg("cannot mmap rand_addr: %s\n", strerror(errno));
> 
> ?

Yup, or maybe with a ksft_exit_fail_perror() directly. Will change.


