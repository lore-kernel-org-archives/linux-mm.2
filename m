Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD371C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73DA6B0095; Thu, 10 Sep 2026 05:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44D26B0096; Thu, 10 Sep 2026 05:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34EC6B0098; Thu, 10 Sep 2026 05:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A32886B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:33:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9354740471
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:33:29 +0000 (UTC)
X-FDA: 85197339738.19.5CD5606
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B94EA40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:33:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CK3hAOAF;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789032807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovS2OC7CT0g9iSmGDUZDcU3Pa0btm93OF4BuD+LLeGI=;
	b=Qz/03WJaJsa3ORHMqtZARMBrPplhIKUiMYxgYTyM8aNcfi+edRKI5jGleupeP1jH48EUng
	nVOJBninvXSh1Ht8S952rkasdfGYeAYpZvIW9edhg5Eyn2z0/qtuMWrFqt9qe2RkfVTT5y
	8cQ5Z/Eef6kxSu4HhGgdJ7/updcwHtA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CK3hAOAF;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789032807;
	b=WzvVW505yZmFNB8Roem06hh2lO7dWlVLBCJnedVuvVkVNfvjA7iLJ602GLj8LHdkBI62iS
	4IBuD31R2ed4XDZ1rmWkZ8QfUa5hjHR7JmXhJ0QJWtTelI9j7rdC3iYDQ8UGPLQYSLOBLA
	rPKUW8ePv/0Puejxg4tC8H39rHZXi84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8DA743C48;
	Thu, 10 Sep 2026 09:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466CE1F00893;
	Thu, 10 Sep 2026 09:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032806;
	bh=ovS2OC7CT0g9iSmGDUZDcU3Pa0btm93OF4BuD+LLeGI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CK3hAOAFGCnKDY07NnHjc4hA81S61p4PC12UjoWKuLDscChJiFe+2XgkA8fzqu1/F
	 QqnCpsWbwK30+VDahF06e1KkEbIeVplGSD+YBiryYVmdKyJL9C9R0VWfcyzETQqFcC
	 fgCQY95ZeYD9KO7hVG4HeV/39P39F7ljUoTHVkiQi91iLkCys88rU0leA3YS4DaRRg
	 sQOfXEp34rgw8K0ct1jeUhGahWlg95sSKW+orP/lYZyxZ072PU0M0TAfi9XhysvH3B
	 fplxrRDpd+mn3DmoAhmSTG/FGmBV09Ufwh5Z5DcF3Aem5B8/aiW9E7AzaRzmvGpzjs
	 TBfXr2Xu2Mk7A==
Message-ID: <316d740f-a942-4acb-a8a4-fb646effff91@kernel.org>
Date: Thu, 10 Sep 2026 11:33:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests/mm: emit TAP header and use TAP skip in
 mremap_test
To: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org,
 usama.anjum@arm.com
Cc: linux-mm@kvack.org, shuah@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 peterx@redhat.com, sarthak.sharma@arm.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260825085756.63030-1-husong@kylinos.cn>
 <20260825085756.63030-3-husong@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825085756.63030-3-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B94EA40006
X-Stat-Signature: zxmjzjdzsux3yz1xn1x3ypa915wzmy9r
X-Rspam-User: 
X-HE-Tag: 1789032807-160365
X-HE-Meta: U2FsdGVkX1+Cj0YFGfrl0cjU4PQ2VjgGYT8Af1kjZqfXTV/N9I3jHsfZ10r70Pl/BpOICBkE0/SL2o65uCwUNgV6ICsE+CZQWcCg38WlD9zVVxFpoZcDSYjFWAAunQRz7yD46Mi96dlAKsVD2JxO/r9L1aJohDbsmdNH5eKQ4k6ova53rhk/AfucC0OcrAGVWnkBO1jlNwtbMZiXh7ASLXXSJMBuQpl5DqDXSk++m/JP1yRWARA1Bhy4U0xUAT8AuvJ0Rfprph6Q/lkU1+/t366klzEoCBjWXmB5wypHJyHqqc0KFiZUijJZcotoGuj6t1j1Cmkmtt0H08fUFFhZ8t1SMqwMTARDb54mq7lGVpTKQiMb2eOBc32uYcSV0q1Rz9Z10q6ZVMqCiXIvY4irFlODvrlk4s242GRFz4xCAocPNls+5FP0eZLICuQJ4ddH6xOoY9fmshGqvsqmhOv4HJIJFO73o/wd7Ixoc1RCicPc4JTVIgpxH3bfig/Q4mebLb4sQAvo4H0GrI9v7n93a33B48k7fGShn2YWkzZ+SQQeR+klKsDW6oeimsBW6Q2O89jmHsr+fJgSvruByHmVoKoWOQQqinRYqRe961QL2yv8Y7h1R1eShclXxvQhRMusHSUCe1BzrSvKq7SDzaXR8o5x+SDS8hvFwQUoNJGo41w6goSBq4rQOd/P6rs4fOaKbO/36/VTuKweYyvpO3OvCMjW+tcc5IPI/CXWrKjrEcoCXpeJiCGS5X+fkyrP+cJck2UtOtglxb2ZVka1itIkRaWeyRWl9+Us6ITCPNPtqyNNLgoR7IxkSepflXOQ/Owhy6L5cIzDUlvdY5eYlWrDJ8MYAjkgK1EOAGV9jqTKCaxUNhmWI3C6XhtfRF5vgbqAQr+mT18seEfU2C/QaqR+HK8nyb0ZkCSe8sQgNAUgU++GDhd4Qb1XvtoeQOdoKQ7V3GiAboKtAR1VsJWa3sd
 gFUvIj8i
 pSHbNBMWoUWJGKgpIgeGN+q+EPmd9wcS1cimSNVdoCN2tjvQnCCUXlbUluMiAVXrBV4b234lQhmW6Ln0+eso69tk8JyW1xBr7DgLuwv7XQt0S0xksDoyo4eYO57av0uRdvA+MU3UxibRw+Jh7HemeqnYFR6HASalPQ93RfxAIb7kd6aQEQCfx4P5rD17MCKUy7WGgDA7K56nV7kI5tkppeS309SfAiYaX2LfhyLSzmbTugasyGD9/M3KOR/AAssMyUbjRrFJK/suq7X//9pAtxVt4KKqISd032Zd5FjqvGLY5F04Cdqxwr0D0iZtyO9MG0znMp3VNFDJpg1NmpU2PTDy0GChj6FoF+KHIAuCZVBJezgF4frqkch5fo3zV0g0QtXycJiSoDiQvic8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:57, Song Hu wrote:
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
> And cache mmap_min_addr in main() before ksft_set_plan(), so that the
> skip paths in get_mmap_min_addr() are taken before the plan is set; a
> skip after the plan leaves the run with fewer tests than planned.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  tools/testing/selftests/mm/mremap_test.c | 43 ++++++++++++++----------
>  1 file changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
> index 131d9d6db867..ab5420f2e875 100644
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
>  
>  	n_matched = fscanf(fp, "%llu", &addr);
>  	if (n_matched != 1) {
> -		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
> -			strerror(errno));
> +		int err = errno;
> +
>  		fclose(fp);

Why the local variable? And why the fclose() ?

ksft_exit_skip() will just exit the process and clean up, why clean up manually?

In other words, why not just drop the fclose?

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

Why can't we just drop the \n\t  ?

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

Same question, why not drop the \n\t ?

-- 
Cheers,

David

