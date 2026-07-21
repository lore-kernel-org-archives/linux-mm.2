Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DE7C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071066B0096; Tue, 21 Jul 2026 09:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021916B0098; Tue, 21 Jul 2026 09:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51C66B0099; Tue, 21 Jul 2026 09:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B11E76B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:28:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB3D7A0159
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:28:23 +0000 (UTC)
X-FDA: 85012862886.08.DB4F18F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 19187C0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:28:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpJnpT20;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784640502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6fUyFk8ujRTzbRaJmanF803n/mbAv7CSse41ycTcNk=;
	b=ptH2BXYN3B6crgISAdMZpy0XXblcMObYVeudHjKaozB+utiXN4/Pnq9zpV/+c9mZAiC2Pq
	03rqMdJ4p63NC5f9c6cmuzz7yBl04UQZLwIIXXMRSWGl9m/x9AQnoQGY9hkTzlPqu72434
	/kbSPd6gx+Oh8hSzDQX7lY1QhiKx5Pk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpJnpT20;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784640502;
	b=OpN4E6z0PStdvzfay5LmwXfI0xgRL4n2yBYj9rQit4G2YJrZD2m6s5QcSSFClCuMgt8K8X
	vrhmxXmOy5UX6GCLbh6jkiX8UGt8usG2IZ7I7D4FaDNS+G6ZDeqXkWf0dFZ5q+VL3B8YYD
	2vlm7aViPALt5dI16kbBmXUTni5vwv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98F6D600D8;
	Tue, 21 Jul 2026 13:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E401F000E9;
	Tue, 21 Jul 2026 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784640501;
	bh=R6fUyFk8ujRTzbRaJmanF803n/mbAv7CSse41ycTcNk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KpJnpT20QOyKkepzpMkW5nqZGuzmqwLn2yQU67By8k48KdR4iYMJ9bDWPKEIvprRu
	 4pG9Cq7F6C3mWPzYkptISPkm86QJKYgFYKzgv58AAz1ErdZ/1DMZvRVW4SGLLKf1ST
	 Ba9s+/Fr+nkzmkjWbix78M1cwSc3gDxyLEbNxA7UGNq0gM6MppB5b4F4Qn4CzeBqyu
	 ae499b2FDGEnds5RLdqjNx2YyEQ4KhznYDDJpGlidoqy360ewoHiapGR4X6k5wO7me
	 SSDYddgvEiOIZmBwWeFGSaYjb/5OW6IQkL5y0c0UvgtlHD+NkBUB0MuvDbtZ18PKG0
	 4wPEzcZglcvnQ==
Message-ID: <94ace42d-8d60-4475-953e-74fb3dc23774@kernel.org>
Date: Tue, 21 Jul 2026 15:28:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: transhuge-stress: check duration inside
 page loop
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Aishwarya TCV <aishwarya.tcv@arm.com>
References: <20260720103105.169955-1-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260720103105.169955-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 19187C0009
X-Rspam-User: 
X-Stat-Signature: 8mfk1z6dbdk5g9uspwagtmxwh877e3it
X-Rspamd-Server: rspam04
X-HE-Tag: 1784640501-645303
X-HE-Meta: U2FsdGVkX1+3mWAOg5pdv4DxW7+OYTKWCk/yfXk5sYChnXh8a05zaByw1eA7qqNcMODpqofurwHrV7IdxEr3gvziT3dLrVc3DXgUMCyPwr7zIsIYiOk47Uv4/hu74mqRmYrNOEVY6gwTdlA5ey5MyhxqvitHWGZfDlK6qa+fs3SN5+2pth9AxNWGzTBc2xzMKaJwZKuPgs6E/Ll7V4Y20rUEpmzLQWrBDcQZfWr/oGBIL/dNEJ7Tt2n1h1Fq88KV1QAPt7OeOUzvfYexq3OTPl8ISGwrXsKZa9SJN5zGMD+ndJtMKYir8xuhlT5jXjb9HKQBehK2j/VFJVLzesgTPoiWWqIq4kV8v5+/g33g7/QBaKunVrYv51C4iyD3apVubcCquNGghbJ7puTZL+uSXEICK/Q7EG1NVMSFKAlTyLtcIyIYwyOX8UX2rZI1fhCfhGWZ3wadJNSnlDOCiBWFX5S/4ih/sPGJWQQ0RXSkHxlqD+EVCeKBjKP1TFjKWLay1pvJti6Cwkzf75MT9f5RP4LT4/MWyt78/ONIRoYQeHlzUiTytdgY0sV3UoK5dU1Ti13MrYm7hOSNuu/HQS4//vZUo0hop1zp3H5vaYiJldUAqdU8r+kypMIC2PrwW587EWYJFk7b0UgnvydATYP6UEOuFDFvYLelsFup8sCYGXK7K+N5QnfQxte5Hvy2YG2hWx2ZbwOy5DH0ao1OpahvV2dRs+JV9t3J1HzKUc74rj1h+kFRLrrNujYdarVBXfA+2tc9FqxUTIyegAX1Rim7eAqZ61cb09rEMgQeAF7DOY2pljWo8YKZj890iN52qZkrwmFTngKbejY7NHJuB66Er33Q2G3vewsTxYlS6YLrqw/LzBc3OsRb7SIYYpuqaF6Hzy4S6RBmWY+M7urmmetZkF3hkdvSSGQeru1q7GE3ZEgBgJxXNMSk2iaDgPYEHSQscled9HvygEfGjWeE6Hi
 zLlksCvO
 tTZ3g3HRcCiW9GsLaEnN/lYxzscrCKLAGohhcedKnIZgjXo+ph/kDddHdZyf6YgYfmKaZaK384wFdFZJEoOhfww/S6/yC/A4OcjpDKF1ytpPZS2fn9IvU7BjO9Ef4HDrkEWa5Y4yyiuR4AtJj3cvNhzEdP78h1zfSySOzlUbcVYa0+sO725LL0ZpzNwq4afcSz7phQf+a6Rz++pPmDem5Xez+haT5OT4mWC2Wa6dKQgjZ9G+EhwuPZuTLNR82yaFyokHCrCY7xYHAVI5D2gOan90oeCwlmpenEv9f9ZpSXVJxd279+WT4acf0Py736X8ojuU9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 12:31, Sarthak Sharma wrote:
> transhuge-stress.c currently scans memory equal to RAM by default,
> in jumps of hugepage size, trying to allocate and split a THP at
> each step. After the entire range is covered, it checks whether
> elapsed time is greater than the duration. But it is possible
> that the THP work it does takes time more than the duration itself,
> causing the test to exceed the CI timeout.
> 
> Check the elapsed time after each THP operation. If the duration
> has elapsed, break and end the test. Adjust the statistics
> calculations to accommodate partially completed passes. Also,
> reject sizes which are smaller than a huge page.
> 
> Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
> Tested with -d 5 on a machine with about 250 GiB RAM.

That is certainly an improvement for running the test, but see below on the
overall test: within 5 seconds on that machine, the test is probably completely
useless to run.

IOW, 5 wasted seconds :)

> 
> Time taken before the patch = 4m26.793s
> Time taken after the patch = 0m5.198s
> ---
>  tools/testing/selftests/mm/transhuge-stress.c | 30 ++++++++++++++-----
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> index 8eb0c5630e7e..a0f9fc900360 100644
> --- a/tools/testing/selftests/mm/transhuge-stress.c
> +++ b/tools/testing/selftests/mm/transhuge-stress.c
> @@ -35,6 +35,7 @@ int main(int argc, char **argv)
>  	size_t map_len;
>  	int pagemap_fd;
>  	int duration = 0;
> +	double elapsed = 0;
>  
>  	ksft_print_header();
>  
> @@ -60,8 +61,6 @@ int main(int argc, char **argv)
>  			len = atoll(argv[i]) << 20;
>  	}
>  
> -	ksft_set_plan(1);
> -
>  	if (name) {
>  		backing_fd = open(name, O_RDWR);
>  		if (backing_fd == -1)
> @@ -78,6 +77,10 @@ int main(int argc, char **argv)
>  		ksft_exit_fail_msg("open pagemap\n");
>  
>  	len -= len % HPAGE_SIZE;
> +	if (len == 0)
> +		ksft_exit_fail_msg("len must be at least %d MiB\n",
> +			HPAGE_SIZE >> 20);
> +
>  	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
>  	if (ptr == MAP_FAILED)
>  		ksft_exit_fail_msg("initial mmap");
> @@ -91,6 +94,7 @@ int main(int argc, char **argv)
>  	if (!map)
>  		ksft_exit_fail_msg("map malloc\n");
>  
> +	ksft_set_plan(1);
>  	clock_gettime(CLOCK_MONOTONIC, &start);
>  
>  	while (1) {
> @@ -125,16 +129,28 @@ int main(int argc, char **argv)
>  			/* split transhuge page, keep last page */
>  			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
>  				ksft_exit_fail_msg("MADV_DONTNEED");
> +
> +			if (duration > 0) {
> +				clock_gettime(CLOCK_MONOTONIC, &b);
> +				elapsed = b.tv_sec - start.tv_sec +
> +					(b.tv_nsec - start.tv_nsec) / 1000000000.;
> +				if (elapsed >= duration)
> +					break;
> +			}
>  		}
>  		clock_gettime(CLOCK_MONOTONIC, &b);
>  		s = b.tv_sec - a.tv_sec + (b.tv_nsec - a.tv_nsec) / 1000000000.;
>  
>  		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
> -			       "%4d succeed, %4d failed, %4d different pages\n",
> -			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
> -			       nr_succeed, nr_failed, nr_pages);
> -
> -		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
> +				"%4d succeed, %4d failed, %4d different pages\n",
> +				s, s * 1000 / (nr_failed + nr_succeed),
> +				s > 0 ?
> +					(double)(nr_failed + nr_succeed) *
> +					(HPAGE_SIZE >> 20) / s :
> +					0.0,
> +				nr_succeed, nr_failed, nr_pages);
> +
> +		if (duration > 0 && elapsed >= duration) {
>  			ksft_test_result_pass("Completed\n");
>  			ksft_finished();
>  		}

Looking into this test here, this is actually the type of test we don't want as
a selftests.

a) It never fails on actual THP allocation issues, so the test can never fail
   (only trigger splats etc).

b) It relies on magic input parameters nobody ever sets. Setting the value too
   small (e.g., to 5), will not test anything on a bigger machine, really. Even
   the default of "20" from run_vmtests.sh is likely insufficient.

   There an option to set a file when really, nobody does that. We don't want
   random testing tools to be part of our automated selftests.

c) It measures and prints things nobody ever checks


I think we should rethink this test as a whole: what could it look like as a
proper selftests, whose sole purpose is to be a selftest that passes or fails,
reliably.

For example, we could

a) Allocate as many THPs until it fails

b) Split all THPs, keeping only a single page

c) Retry allocating THPs and make sure that we succeed in allocating the
   majority. If not, fail.

While making sure that the system is configured properly.

To avoid long runtimes, we could consider skipping the tests on larger machines
(e.g., > 10s) where allocation would just take too long.

That would be more deterministic than what we have here.

-- 
Cheers,

David

