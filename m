Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDD9C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542DB6B02C9; Mon, 17 Aug 2026 12:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51AF56B05E1; Mon, 17 Aug 2026 12:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430C06B0856; Mon, 17 Aug 2026 12:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8226B02C9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:44:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A26E61607E0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:44:47 +0000 (UTC)
X-FDA: 85111335414.29.6B43CB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F05A5C0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:44:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYnqBcKI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786985086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDuzR5cxKZS/BaI1hA0RgLkwfQvh6EYcntgsppszUIE=;
	b=AYy2Fzv/LdvZSq2Ny0z9zx9QDZgo9KrpurwPuPLw38kC2/46oCj0YrxtQ/aksRIyfA+rmw
	n4OgeGmsogwUdTzOoggiGAI6vxZK5vPcTmPpo2YWgbIeSTp0qLrcYzHmdzvObUs2/79a7r
	YX/IRJx2peSngEn0u5vNZ+I6CnE8uVo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYnqBcKI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786985086;
	b=wYx2eudhYmeRfbaZidJpdRrOkvGg/KsjAZhLRgWfddvPXut4g9mxTWTRaay/Q8ughVaS3r
	M55sXBNOa2i5OJdd8Gb6ZfkaH/Js69izYnvOBlXIvKC3FUkc1pX0Qy1enXQiCcWce2Nkun
	CpYmIDrXxG3R9+4FZikfswpY//l7Fz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78D43601DE;
	Mon, 17 Aug 2026 16:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE5D1F000E9;
	Mon, 17 Aug 2026 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786985085;
	bh=yDuzR5cxKZS/BaI1hA0RgLkwfQvh6EYcntgsppszUIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BYnqBcKIJLFZCXPWKVyHxamKQzGsB5l3qDD03SM/KGsbGpnbqPimRAPgGALZqRaBE
	 M4fOlWgCN8kqMX8Ae+tOYNP55ixHIwCigtO56NLNiVfAxhDBPSO29mBxBZz1cqXE39
	 60lQeq27eNIQczOHaekHwqdr/iPz9K4a6a6HJGhwEOAtjQ2/L7mbhUI6lFszyopUez
	 Oa4RAFjAq3Q0Wh4JyxHTLM+4w33H0trzrfDyyLtjSA1qAKkp3ElbB5V1hi93LL4JUq
	 yrCdZF0gaRI2dJzAhpFM72IYi7KaLAzsLenfwyjFciqckkhkl1X794faU1yUFr9Pl1
	 b25+hC+bLSN/A==
Date: Mon, 17 Aug 2026 17:44:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, rppt@kernel.org, sarthak.sharma@arm.com, 
	linux-mm@kvack.org, shuah@kernel.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: emit TAP header and use TAP skip in
 mremap_test
Message-ID: <aoM6YivoBU8JXnSO@lucifer>
References: <20260815080716.3596514-1-husong@kylinos.cn>
 <20260815080716.3596514-3-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815080716.3596514-3-husong@kylinos.cn>
X-Rspamd-Queue-Id: F05A5C0003
X-Stat-Signature: x5ukxpxpim8t5xdungucqbz55gkx1bfd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786985085-637084
X-HE-Meta: U2FsdGVkX19qUZEzNZS9GCfW31o9ym2HTOWQ7Jx/158W3dmfoXj7gLaqakM5ixyn/+eMf5I8pbHjIjDxC1N4TQU3iSIouZrtRywSNcgpaFrswEuCMLTPDxZl4q6Zg9GWpQ3332VjMoieSMUPhEDwlJelOWib9BnMQXTNKAfdgc0b7ijxSdPPy6i/gslS4lMWlnCWrMxlWEFlLrDApcIxq2EzVTp1aSa9ccD6hgnfMLbJhJ4nHyTDftsv+UnlX5Hrcqr3WrjqqqexO+Cg/sVQTW6q6mMGnhTZaZfWOznebBXWkOX11cIFjOwXqY80RL/GSm/fFmIt5MgcxRD4tOTAKJqHin+a1aVfdf1yFDPl3EbZatP/XSglfcJRF8ByRBkJI/PdafP+W1UmubYC5yu6VP/2MhCCU8PPhw9rOgocHmh2REkQqa/Rv5CLwdi5Ghq3aBrV7LksIfjSF4+vbSTpWxXSXcdxxAjiXJwWGe2spVR6CHFoF7NNTjruBcJBDub6dSo5SbQsrjl+S9Dv5Hfy6snLw/3O+VrheM+01QDFKzQWkiWuByMT0+JSaf/VpzghumEplDzAzg0joSDOomd1e0p+TvFQKsfKPzqXFWJDm6aWhCV7sTLjFDq/k8ZA9Rar2x/vU0+fldEPWwSWjRzuh5jdrqD9ec1PmgSfziVfIbGxJO8AdkHXZrT6mAKvAa6vFJWlb20DJW5qv1nCqbWHLolLJwKPO+RaHJU9xTcGStcFFqvEUPGRo4GfsvwmGNsYqtQ6Hmzs/RWTnobHP3Wj+Wf5qm5EdtNiWA7tUhkakbREi033Fk81UuxsAUEQtvAMF/XJX684U9dqHtA06fYmODgtYMUL6xmpC8Z6LFUKV3fpkvIs05sbLZdH3ZoQv6+UDotDFVOrD40AXhdvHJT4oYHMeoLH70J5qtvkGVG4lp1qt+mSLPDH3K7NSdY+ddwpM4n9gP4Z3L2zDv1YP9M
 M62Q5KPX
 r6UPC+5pWsFw0ogm3wEWfQxkl3WDUlwed3tsZqDp8b5skV1jilBcVlNJu+ScWn9PjGRJbEKR88vm1SJIrWO6H++cj12coyMb7SWBTpGloS1pZ8FSmfCtwgNtWQ0pJdPZSecLaW/7J4S5cqPnpAJpVaJYThCTr7qqH++esmfM29UgU0KS5VLOtFQHkXg7vN+bCH/0dOMSjPXEv9NRwedaSiCxlVzMTj4oY66pPNnk79Gs++qAQ9d5gTnbVmXEamCopbmlW4brO67XEmjLcTLXL2WqJLSz9csMK2DQ/ydys38pwxbJ1gCH72d/Ytujghug5+hMJCYDdQJPuKShKadpi3UDP9gFPzhJ5pXYFuUD5Oc6RfVaauuFNgay+5/VeDHymm2su
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 04:07:15PM +0800, Song Hu wrote:
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

All LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
> --
> 2.43.0
>

--
Cheers, Lorenzo

