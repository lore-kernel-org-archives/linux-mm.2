Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AF2C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5186B0837; Mon, 17 Aug 2026 11:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50A96B0838; Mon, 17 Aug 2026 11:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9652D6B0839; Mon, 17 Aug 2026 11:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78E026B0837
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:44:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECB4E140456
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:44:29 +0000 (UTC)
X-FDA: 85111183458.21.1BD8739
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0E8F14000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:44:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="lJ/lMFsB";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786981468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Q4JHhgLqf2RX750pGlFPNCkb1zWh9XtIExM+sHI22M=;
	b=Vt075uIPvbwPUzeFY9PwJYtNFMzMMQ3ESksEiAs8YUJscUEAA4jW35/uoJ4hCPBIS8Kzxw
	MnMoYW5RIpjN4CsAjT9vnWpZb6haapn/cAX78DbsH/8zxahMguLe8t2nXlI/9r9yXGp4zq
	kp7lsJdl+hYG04ylLoml0T73qanmN+I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="lJ/lMFsB";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786981468;
	b=vpbACKEg12h7b5f2KizCfRASI8HNCLKT/ILEgTVsxr4p3JFfemgKs1pi+eJq5P8Yb8UJDf
	QkOHh1QZremHiPYz/ESQnief3zJXO2DSZf9KWRwZMANlkX0MLjbsAE+FM4ifp67oSDwsXv
	bjiUf4Q7i1OZx2GejipdQtgb3Bzcj6Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6DF0143D;
	Mon, 17 Aug 2026 08:44:22 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2B6C3F673;
	Mon, 17 Aug 2026 08:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786981466; bh=nfSNkX0Mke+jbuYO+dDTnHSDSi8qw+1krN9Fi8gRdtA=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=lJ/lMFsB1WLR5L52UGl94SU8+gVOnFH1mkky4gU5i0LkxwzmKaNj82r4985zJsXu3
	 kZEgFfPcyQdegobmISFB0pAbSR/DyWhq5h5faGhr65fR6QAeXwk6yLxewOYN++IwvB
	 B0YNCsJFyrV9UIJ0122mLWxtAzs6xZdmjGNpH9To=
Message-ID: <7eb13c5f-127d-4abe-bcde-b4d5066510e2@arm.com>
Date: Mon, 17 Aug 2026 16:44:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, shuah@kernel.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: emit TAP header and use TAP skip in
 mremap_test
To: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org, rppt@kernel.org,
 sarthak.sharma@arm.com
References: <20260815080716.3596514-1-husong@kylinos.cn>
 <20260815080716.3596514-3-husong@kylinos.cn>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260815080716.3596514-3-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ndi8i9ryh51o3993gr4jbqtbuqsyb74r
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0E8F14000C
X-HE-Tag: 1786981467-881341
X-HE-Meta: U2FsdGVkX1+bHBhmkumv1nhoctPCBLkNKXgHkUAOV4eVbJ+Pt70DMnZOjkw+M7mPI+HUynegAogbqbA/H9n7b/OcY47a66Opbjmvsfh6YNH2JpCA2kKY0vpJxkr1Z5qBg4iJXZ3mz+LGiXvnVyt8Oyxdia4oayZ3m0wdWOQ2ngbcW7bVx7MhcLq8D+qy86+XQ1/cFGzxC2JteUng98X9uHSgXF9aWGgU/jKEapdA+zCMDnJH4ImcvEwAUY2aT9mwN+3gb1BPNbqIYJxD01/+VttPHZ4LmujyM44w7ZEJBnbM9AZS9nLNNBDf25ZI/q4IXKIzIJ6XFTlMDMIPfxXPbt87Q+SrVzr6E8UKw9wOZkeZz5ZfP2hPmk1DdBq5M3kqL2NQDQZAFil0yO93KUYmZ4S6CK6UjVN0UL+gcQoqh3bzyOsEw3rm5wHy8wD+6d0Tqqu6CGbTcY42JxQvVJGwXPwmnWr8zL/IzJlsNjgCA+oTrWMSZJEZQHLLTQoU972PUlr2hbS4Pb2hArPQIGd/L/IBOJxatotkhSK4DQOjMn6Qz5L9eOv8CbqY09hWZ8l+9Lpt8DVwmGK8+YDv8Oyg+2sonnFSye9fADXmSsVYKCi062Oqlax9WgbowVybN3s5szywptup1BFE8h7dkIXvKGP6G+eeG4ATb78uWREsUbuRjQkeJ0Wp77unv0bEGD+LQQUkkG5eEKvo+/Tl+OF6wV54JEi/Dv9u36EhmfIRAhjBfnIStw/QZO2tFp9WHRHl1GtsHglpdS2mAfOhh5e4AE2iH2kEbdcDRMWFjvoz1vGuA7Uflz6YIyQrA90xaHCiIewisBiphXJH/fqGGYzbkvczZwtTkPaOFnZwwZ2Z36C7grFWSZH9tV8fflstku6gQtSBsZaAdNqy4W5rlLvv1XTTl4AqaWA1SmBLH63m/xEr/lwiCPBhxFlcBkS1nm6TQpy+lFBPobXWKf2xzqK
 QhoOqIuK
 Kl4LU8mchKooudVY0ZmrHkLKYdN88upcudO6WAziV2600gCOVDMPWdGM046+MKtTRJSxEAOSOgBgsmdZoCqumVla+Td7FUxnuxO+sAiACPWaXGErQH2NjmtYfs9rSWN0zG63ngC7qIj//RypgISQmmVINAe+VQIhtlTt5u7p4gcYIc29mPUZnRYSeK9AtB5DFbd6V5IxRSDS61Qjpl28qxHaYy5NfF+2JMr8PPkZTT4sd1dT0SlaHGIM/IkY/fAcFn6p++cF4Jlhx8Do5UfJThHZjm+GjQgEtYRPafCA2Bwr7fd/g1YkpReSbfxHk1s8mtwHfMpdqbsVRM1ZVxP6sb8YtGd2ygk4hKV72M+dASFMEabAI3EIlRBGv2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2026 9:07 am, Song Hu wrote:
> mremap_test calls ksft_set_plan() without ksft_print_header(), and its
> get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
> TAP line, so its output is not valid KTAP.  Add the header and switch
> the skip to ksft_exit_skip().
> 
> Also fix two more KTAP compliance issues spotted in review:
> 
> - get_mmap_min_addr() calls strerror(errno) after fclose(), which may
>   clobber errno; save errno before fclose() instead.
> 
> - Some ksft_*() messages embed "\n\t", so the text after each embedded
>   newline is printed without the "# " prefix.  Split those into separate
>   messages.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  tools/testing/selftests/mm/mremap_test.c | 41 +++++++++++++-----------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 131d9d6db867..28f151daabe4 100644
> --- a/tools/testing/selftests/mm/mremap_test.c
> +++ b/tools/testing/selftests/mm/mremap_test.c
> @@ -111,18 +111,17 @@ static unsigned long long get_mmap_min_addr(void)
>  		return addr;
>  
>  	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
> -	if (fp == NULL) {
> -		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
> -			strerror(errno));
> -		exit(KSFT_SKIP);
> -	}
> +	if (!fp)
> +		ksft_exit_skip("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
> +			       strerror(errno));

The skip conditions are usually at the start of the test before we set
the total number planned tests. If skip like this happens later, it
still counts as failure. I found the following corresponding output
with this patch:

TAP version 13
# Test configs:
# threshold_mb=4
# pattern_seed=1786980558
1..26
ok 1 # SKIP Failed to read /proc/sys/vm/mmap_min_addr: Success
# 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Planned tests != run tests (26 != 1)
# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
MREMAP_FORCED_SKIP_RC=4
### MREMAP FORCED READ-SKIP END

>  
>  	n_matched = fscanf(fp, "%llu", &addr);
>  	if (n_matched != 1) {
> -		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
> -			strerror(errno));
> +		int err = errno;
> +
>  		fclose(fp);
> -		exit(KSFT_SKIP);
> +		ksft_exit_skip("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
> +			       strerror(err));
>  	}
>  
>  	fclose(fp);
> @@ -1164,10 +1163,11 @@ static void run_mremap_test_case(struct test test_case, int *failures,
>  					    rand_addr);
>  
>  	if (remap_time < 0) {
> -		if (test_case.expect_failure)
> -			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
> -					      test_case.name);
> -		else {
> +		if (test_case.expect_failure) {
> +			ksft_print_msg("%s: expected mremap failure\n",
> +				       test_case.name);
> +			ksft_test_result_xfail("%s\n", test_case.name);
> +		} else {
>  			ksft_test_result_fail("%s\n", test_case.name);
>  			*failures += 1;
>  		}
> @@ -1177,11 +1177,13 @@ static void run_mremap_test_case(struct test test_case, int *failures,
>  		 * was faulted in.
>  		 */
>  		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
> -		    test_case.config.region_size <= threshold_mb * _1MB)
> -			ksft_test_result_pass("%s\n\tmremap time: %12lldns\n",
> -					      test_case.name, remap_time);
> -		else
> +		    test_case.config.region_size <= threshold_mb * _1MB) {
> +			ksft_print_msg("%s: mremap time: %12lldns\n",
> +				       test_case.name, remap_time);
>  			ksft_test_result_pass("%s\n", test_case.name);
> +		} else {
> +			ksft_test_result_pass("%s\n", test_case.name);
> +		}
>  	}
>  }
>  
> @@ -1250,13 +1252,16 @@ int main(int argc, char **argv)
>  	time_t t;
>  	FILE *maps_fp;
>  
> +	ksft_print_header();
> +
>  	pattern_seed = (unsigned int) time(&t);
>  
>  	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
>  		exit(EXIT_FAILURE);
>  
> -	ksft_print_msg("Test configs:\n\tthreshold_mb=%u\n\tpattern_seed=%u\n\n",
> -		       threshold_mb, pattern_seed);
> +	ksft_print_msg("Test configs:\n");
> +	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
> +	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
>  
>  	/*
>  	 * set preallocated random array according to test configs; see the

Thanks,
Usama


