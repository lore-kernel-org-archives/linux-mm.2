Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AFDCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781266B008C; Tue, 29 Sep 2026 03:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7582C6B009F; Tue, 29 Sep 2026 03:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E1C6B00A0; Tue, 29 Sep 2026 03:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 404126B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:58:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAE7AC03B5
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:58:56 +0000 (UTC)
X-FDA: 85266048672.20.793307B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E32480002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:58:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpg3NxSK;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pk1v3z+VGNvnZ31sDmqvV8W/43hqaDHhcD0ieAuWqM=;
	b=J/278aJib7us8l3szg9Ko6rEF8akQFfdLlTi3Og57M61MyTrLJ3egeJ4/+tq6DfTr+w4ND
	daIUpDNVh78QQvEKNcLPCc01hseULlSfqr/WjgHUUHQ42rfHFY8GFm3ZACYDZbe0jQ5jV9
	+HfSyoLkf0Zll70quSugdN1JEBsWCZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668735;
	b=JqtYp2ReJXGsygGwJq7GJFp8e/CVF1+fYRxc9whU9g4leQdxiZFGr7bhiVALRZPSkl4raO
	PX3WvaMzctIhYz7+McVUNCeQWD5GRzfFUcjDHf5j3kvo6uqlKRUCJRpcfbSqn6gN7WilFb
	udIo9hwcFRWwJJc3zMC15oRDK0FTak8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpg3NxSK;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44FF243B11;
	Tue, 29 Sep 2026 07:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C81F000FF;
	Tue, 29 Sep 2026 07:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668734;
	bh=7pk1v3z+VGNvnZ31sDmqvV8W/43hqaDHhcD0ieAuWqM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dpg3NxSKrMNJWRZNr2K0ov4/Q0jMbqr0pMwW/bMcZLPvUNEU7KxfLvevHMN58VSMB
	 iyrFoBNb2JfTJEPKfsBZCnESvjtg38WlSV13uOFUD4H7DpQ4J6SBpwCB4dyfKLbmOd
	 5r36xxXmVk0xudeYIGqs3y1+3uyIP78/AVcOH67+Hi9U0GvgYOKBy6OO4mAgVxI8ZF
	 8Lj3Wg2NXS+RLiMl9EyO3dqDGGargFsV20R61Ca+UhP9LUUwh30yI2R+t2ePZhA8N8
	 imlbYivATAtcPbTXIOF/+u/0hvU1mhOIWRKZsVFeJ/lZWBKysrznRulAGFff2kLfvh
	 2RLfq+e2mvgYw==
Message-ID: <6c349d10-2160-4166-8b63-3d60b42a5b69@kernel.org>
Date: Tue, 29 Sep 2026 09:58:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 1/9] selftests/mm: mremap_test: use kselftest
 helpers
To: Sarthak Sharma <sarthak.sharma@arm.com>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-2-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: e3m9zbcykqt841ncog1czqcnyrrbu4sm
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E32480002
X-HE-Tag: 1790668734-780018
X-HE-Meta: U2FsdGVkX19t5PYzQ2of+qQRwjRBs+J5rVFyJl/4We+NnqOCMX3rmDzAbyKZDEgGjHeG1tN4uLerMMnHFrEu+SAOzJd+ubTwY4fdjbE8lnW1LO7/EADJrBcptc4kPDrCAoM67EA9oDR1nPf8eK07p+1cKYo4mDu8iLjAkohKu3TaH90ET3m5/1DdqvNePnVKi02gjiI0TdshWeynssnroIwG2svZB6/fy9ckcg1BwkMz5wzOP/YUNLZ3d2JvuJ0qe8JVEBd5Wuu1bKWlNvyB8P6w0O2JU9gs+cXf34dw2pToIpAQwIvBdLUP9mfYSat5krUW+nU/SrXxdLw3IvHKO3Hml+k8reXMjfFyuxE/EP8W1GUiO3oTfoJoOrXQS1Trbf/KohWcbNksimpJkJ6rJZv1bmD3XnbdGoWbwIxbE8uDkMirkj27VTv6viNTSsLkqbZspfrvEO22Xk6tKbO15A5pqWyPHfv9psvft6IKv1wrOLO0PsbS3Mp9FMem456SAIvbOxxA/Lq/Hcc1e/0gbkW2WUZgQkmbLJ67dC1yzDqXItILuL79J+C8mFB9Uf7Iy8/TmgQQjZ5EIDPtV6NqX5dsWDDF83tWN6ooDWgYNeVMVkE9mcQ1jlL6UH2fV/ySqCC/EkAcHe1kGxRiDrOK8QVAnwKNNx1pDXeV0fsQkREQVpB/EILQGFGqcllifoSVy8ioB2fGskFxr5XkSduXt2eMNMBqAqoktFRUVcFUxdE41SmzNUdSZYEEMsqrURHJepPU3e1oKsmpXFhK4Zu+QILKFBJsozOXuE9o6xWrKjAdCX6zhb1SqXwMB341zqldPhhwz8cFutQRlVxe2zbdNRSrQsKE0nLSTl3YSzlxKNNc1rlX/d1vlZ30Cib8CrG14Jd2VpTRg3GXavQdfcscMDh6283Apg2+iNb8oR2drYxPjP9otm8Fee/yM3zs9Tim5nLVCFE+tH7GhJwQ8bs
 JKKhRy92
 8X9wSbjI8QyfatM4PyJK5w39Z33/Ue+G8em3b7FGZs2MprWTp245oQrafZqF/pQVliFcU3gscnDTyfuRfLPymhU7di9WvDKMunhS5RmuHF0NM7ObzvcICQCvKpELqoQWvkP+bUgNKPQTQRlQBAA7+i8fX8xCdszSuKbkUpfERuHHKBkYCfnUeZ3+26OV3+qshMwx+iWVfxx7dJTkGY0FkRoz1W5iIoN1tLxUpIn9ygOQ0Y69GfcXaYxqkbXxbAcGjXb0Qa8rKKH+Q1vHZGPQvH6WXQkGOw7ZCyZMHKLvkI3/XcVBfBTx73/OoWsfwWt0/YNaTKFcaPR/rdP6+zyXgrCmKGJEXdtH1SewbKvYkUyY3gpqpI/CCNYYIQZRzOav1PkZWYWNZcbb0kzv1NSqeiNSYLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> mremap_test currently uses a lot of fprintf() and perror()
> calls. It also uses a variable "failures" to track the number
> of failed table driven tests.
> 
> Use ksft_print_msg() and ksft_perror() for diagnostics.
> Remove the variable "failures" and let kselftest counters
> handle the final exit status. Use ksft_finished() at
> the end instead of manually checking if failures > 0. Replace
> 
> if (success)
> 	ksft_test_result_pass(...);
> else
> 	ksft_test_result_fail(...);
> 
> calls with ksft_test_result(success, ...);
> 
> Also correct the duplicated "mremap" in "mremap move within
> range" and the spelling of "dontunmap".
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

[...]

>  #endif /* __NR_userfaultfd */
>  
> @@ -1124,7 +1096,7 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
>  	void *new_ptr = mremap(src + SIZE_MB(1), SIZE_MB(1), SIZE_MB(1),
>  						   MREMAP_MAYMOVE | MREMAP_FIXED, dest + SIZE_MB(1));
>  	if (new_ptr == MAP_FAILED) {
> -		perror("mremap");
> +		ksft_perror("mremap");
>  		success = 0;
>  		goto out;
>  	}
> @@ -1145,59 +1117,49 @@ static void mremap_move_1mb_from_start(unsigned int pattern_seed,
>  
>  out:
>  	if (src && munmap(src, c.region_size) == -1)

While at it ... why the comparison with -1. And why do we worry about munmap()
failing at all? We generally ignore these errors on the exit path, as it's
unlikely we would ever hit them, and there isn't a lot we can do.

So maybe just remove printing errors entirely?

if (src)
	munmap(src, c.region_size)

...

> -		perror("munmap src");
> +		ksft_perror("munmap src");
>  
>  	if (dest && munmap(dest, c.region_size) == -1)
> -		perror("munmap dest");
> +		ksft_perror("munmap dest");
>  
> -	if (success)
> -		ksft_test_result_pass("%s\n", test_name);
> -	else
> -		ksft_test_result_fail("%s\n", test_name);
> +	ksft_test_result(success, "%s\n", test_name);
>  }

[...]

>  static void usage(const char *cmd)
>  {
> -	fprintf(stderr,
> -		"Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n"
> -		"-t\t only validate threshold_mb of the remapped region\n"
> -		"  \t if 0 is supplied no threshold is used; all tests\n"
> -		"  \t are run and remapped regions validated fully.\n"
> -		"  \t The default threshold used is 4MB.\n"
> -		"-p\t provide a seed to generate the random pattern for\n"
> -		"  \t validating the remapped region.\n", cmd);
> +	ksft_print_msg("Usage: %s [[-t <threshold_mb>] [-p <pattern_seed>]]\n", cmd);
> +	ksft_print_msg("-t\t only validate threshold_mb of the remapped region\n");
> +	ksft_print_msg("  \t if 0 is supplied no threshold is used; all tests\n");
> +	ksft_print_msg("  \t are run and remapped regions validated fully.\n");
> +	ksft_print_msg("  \t The default threshold used is 4MB.\n");
> +	ksft_print_msg("-p\t provide a seed to generate the random pattern for\n");
> +	ksft_print_msg("  \t validating the remapped region.\n");
>  }

That looks odd, as we will now print this as "# ". I would have assumed that
removing all parameters as the first patch would make things cleaner?

So as a first patch I think we should just remove the parameters entirely. They
are unused by our infrastrcture:

	run_vmtests.sh:CATEGORY="mremap" run_test ./mremap_test

Does anything speak against that?

>  
>  static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
> @@ -1232,7 +1194,6 @@ static int parse_args(int argc, char **argv, unsigned int *threshold_mb,
>  #define MAX_PERF_TEST 3
>  int main(int argc, char **argv)
>  {
> -	int failures = 0;
>  	unsigned int i;
>  	int run_perf_tests;
>  	unsigned int threshold_mb = VALIDATION_DEFAULT_THRESHOLD;
> @@ -1260,7 +1221,7 @@ int main(int argc, char **argv)
>  	pattern_seed = (unsigned int) time(&t);
>  
>  	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
> -		exit(EXIT_FAILURE);
> +		ksft_exit_fail_msg("Invalid arguments\n");
>  
>  	ksft_print_msg("Test configs:\n");
>  	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
> @@ -1282,7 +1243,7 @@ int main(int argc, char **argv)
>  	rand_addr = (char *)mmap(NULL, rand_size, PROT_READ | PROT_WRITE,
>  				 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>  	if (rand_addr == MAP_FAILED) {
> -		perror("mmap");
> +		ksft_perror("mmap");
>  		ksft_exit_fail_msg("cannot mmap rand_addr\n");

Would be better combined like:

ksft_exit_fail_msg("cannot mmap rand_addr: %s\n", strerror(errno));

?

-- 
Cheers,

David

