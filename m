Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EA0C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A496B00A2; Mon,  3 Aug 2026 09:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F25C6B00A6; Mon,  3 Aug 2026 09:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D0F6B00A2; Mon,  3 Aug 2026 09:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C05D16B00A2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68FE91A0670
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:40 +0000 (UTC)
X-FDA: 85059362640.05.37D758C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D0AFAC000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g1C6H9lY;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZH1yyH6OQfp+HeumAa7QMNRKJ6QwYZoAjIJS12vbQQc=;
	b=IFI1R4Hvp/qGuVpZF18SZ/gX9q6m7uDN+lVifwww1x1s+B7G9B6w8+pS3+GuuKs6EPBvv8
	ocGQgsdMtXw7mjumQ5kIbcQHVU2U0fqSgf+PEFGTFzOwAQRm+EPZCpZ7qrGA7Jr4gGft2M
	svLNL7Vvpy2l7gopndGuI8OMLhA/gXk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g1C6H9lY;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747638;
	b=Xx9/CWBO3JbOUl/VoZClP8jaA7Tu3Aww55JvvRQ+1yEuomteDFY+e2YshHucO8yJS6ntdg
	1bkK0jxDgra2Zen0QKh9Xa3mi/1hLzKlaJS827WzWsmRXiQj4WDu8pedk1yVdAMc2Tl8PF
	AkXRV1vrTvY6bQ60WRXQhPwiJzEqDJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72D8760A5D;
	Mon,  3 Aug 2026 09:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E83E1F00A3D;
	Mon,  3 Aug 2026 09:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747638;
	bh=ZH1yyH6OQfp+HeumAa7QMNRKJ6QwYZoAjIJS12vbQQc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=g1C6H9lY9ewm2jizolbdQB1Yjerow0BfWYnaHZ7AKif87hHGr2V5ySS1fHPjS9Lx3
	 O15XqRNV+SuDtlJWoz25FsRxHl0hIAwf0wSAvzTQpMfEWmo/Fo25C5DivZWJejuuNP
	 Y1Df9EWMNeuPJ/zKxd3yCFwd5xk9HHIYE00yCoTd0iuWArbaiZaRneIW6hT3s9G7ig
	 ig3obMPlfx1Dhq5RKxRV62mpz9cJ4m+JyBL/M/wUgdN+NviA2Wv88zsOEV2OLKmx8M
	 XCrbr6aGjo+/MpDAWROF+Gh6fD/PuwSNC0ImgiuT+wvJn0rHYsjbm0adHN/GXSF9ZQ
	 miwcHh71NAy9g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 5/6] tools/mm: make gup_bench a benchmark only tool
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730140825.238130-6-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
 <20260730140825.238130-6-sarthak.sharma@arm.com>
Date: Mon, 03 Aug 2026 12:00:01 +0300
Message-Id: <178574760162.1561566.7432721858074092727.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: D0AFAC000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 4rr43rwusq5jqdn7w6ohn6uqjsypmfjd
X-HE-Tag: 1785747638-331236
X-HE-Meta: U2FsdGVkX1+wKZphD+D+MN/StwvVq0PaBWVZHhcd2PyxKUUXXLjIVyS3XaN47GUTeJhRzy88dqKgqpTPqYPQ2wtsk40nzswseVbopiOmkHAwEDmWOSag98RMQogTFOkGlrW03PGmem8O6ocfUdvyFfifl9jUnAuLlq8EnKLLejLopzNCHk9PlT5k3mXB5+4EdHnHD0sQ05Fg86+hynjh6txaH352FLFJ6esdB70fEj7eYs87d2ZFEaXMfAUK29a7e7Yub3UOS8qBKYvTQjPgQ0q+dxZ6LNekWV5gPvTP112X0GFTA0OlQzro+6Q8WymRKBc13U1JaDmi/zlGq7ig3XSA5xUrcL3JqcRimZs1n99pwhPqe4KaGK0qHkuihbcH/SgE9cjrxYR4DxiZMPimg8CIW95mYEBNAfA7Rb4oZAnCKB1jpFK+11BMmlOz8IXfloWUrzvZ9L6KngJq439TWqzzjc+FpcxFfkTNQQMIvv1YusHjP/BTYB7ynjm+1q6KbPI8A/K+rQj2HPGT4rMyf26Eu4jo/iZlPxEUu8eua2iRJV8nm+JKN11429ku9+6QXwW/0p/UlM8t+txoVDCVJTRUU3E1uUCWhd/Cuq6o6NRan180wH336HulcalfEHlL12qq76xxTL8ghR5wWUPCkmebLQVAeaOKaLD8l5asjmUEndbcuGYOxIFjPmaelyQrLgT+XAx+3rYuFpbojmjIBa7VAM0+8PK3YgJpP3htmlIKsJnGGey+/+lOt3DVAX6Haflscug/G9KS5zwBBPILdy6nFPp9NgohoHwhQC6EPs9NIfs9E5iu2Q5GwKQrjoHEYuA40nRRFVbkFTq+fm8uF/F0JcttyGExF0p/C/uWUkkAqRHj3NirpW71/PWLJ/idXfKG2gFmI5BvMArsp6tmWgy2KDlw0VcVJAeyGUTGVjYCUGo01ZPT97kCsmTQ8mfaWJD3kqjbWqqnhC5xjxd
 mWvvTqrR
 Sveo9teVcMIc7z8LuVwXuXBWrFaR/K7qHavfBTRzUls80nzbp/4IH46g8ygmlqc2Wc13S3PsTPwGHUk4OwLYzVUiJL9ERmpVs4yMZmJJtlHDvUmV4wTiZkH0r+lCDXjBCAletC02qBgnXU00NXB1QvJg1DvccWJufhPad0FYz9iaEy0qJL5YDUH1RVTApXQNKU0OxJCm24Cec1Of0J36yK1Fhf32LOBQKfeoeKG4gIPgQ+E7lhK7fA50Qw2Qvp/dlVyZxAzYblSgP9RkFhP3Zx9WlDp5vPeDSQbC0Jd/zcBQPtSvo6h04Q6PMWsi9PjJ1nK/CVe+Na5//6k7dVUHGYxbuQSlttphrl8Te
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Remove the functional modes (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST) from gup_bench. Drop kselftest dependency
> and use normal diagnostics and exit statuses.
> 
> When no arguments are supplied, run a single GUP_FAST_BENCHMARK
> with existing default values. Let users select other configs
> through command line options. Also validate numeric arguments
> and reject positional arguments.
> 
> Restore hugeTLB settings on failure and after every run. Also
> handle failures without relying on assert() calls.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>

...

>  int main(int argc, char **argv)
>  {
>  	struct gup_test gup = { 0 };
> -	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
> +	int filed, i, opt, nr_pages = 1, thp = -1, write = 1;
> +	int nthreads = 1, ret, started_threads = 0;
>  	int flags = MAP_PRIVATE;
> -	char *file = "/dev/zero";
> -	bool hugetlb = false;
> +	const char *file = "/dev/zero";
> +	bool hugetlb = false, restore_hugetlb = false;
> +	unsigned long nr_pages_per_call;
>  	pthread_t *tid;
>  	char *p;
>  
> -	while ((opt = getopt(argc, argv, "m:r:n:F:f:abcj:tTLUuwWSHpz")) != -1) {
> +	while ((opt = getopt(argc, argv, "m:r:n:F:f:aj:tTLuwWSH")) != -1) {
>  		switch (opt) {
>  		case 'a':
>  			cmd = PIN_FAST_BENCHMARK;
>  			break;
> -		case 'b':
> -			cmd = PIN_BASIC_TEST;
> -			break;
>  		case 'L':
>  			cmd = PIN_LONGTERM_BENCHMARK;
>  			break;
> -		case 'c':
> -			cmd = DUMP_USER_PAGES_TEST;
> -			/*
> -			 * Dump page 0 (index 1). May be overridden later, by
> -			 * user's non-option arguments.
> -			 *
> -			 * .which_pages is zero-based, so that zero can mean "do
> -			 * nothing".
> -			 */
> -			gup.which_pages[0] = 1;
> -			break;
> -		case 'p':
> -			/* works only with DUMP_USER_PAGES_TEST */
> -			gup.test_flags |= GUP_TEST_FLAG_DUMP_PAGES_USE_PIN;
> -			break;
> -		case 'F':
> -			/* strtol, so you can pass flags in hex form */
> -			gup.gup_flags = strtol(optarg, 0, 0);
> +		case 'F': {
> +			long val;
> +
> +			val = parse_long_arg_base(optarg, "GUP flags", 0);
> +			if (val < 0 || val > UINT_MAX) {
> +				fprintf(stderr, "Invalid GUP flags '%s'\n", optarg);
> +				exit(1);
> +			}
> +
> +			gup.gup_flags = val;
>  			break;
> -		case 'j':
> -			nthreads = atoi(optarg);
> +		}
> +		case 'j': {
> +			long val;
> +
> +			val = parse_positive_long_arg(optarg, "thread count");
> +			if (val > INT_MAX ||
> +			    (size_t)val > SIZE_MAX / sizeof(pthread_t)) {
> +				fprintf(stderr, "Invalid thread count '%s'\n", optarg);
> +				exit(1);
> +			}
> +			nthreads = val;
>  			break;
> +		}
>  		case 'm':
> -			size = atoi(optarg) * MB;
> +			size = parse_positive_long_arg(optarg, "size");
> +			if (size > ULONG_MAX / MB) {
> +				fprintf(stderr, "Invalid size '%s'\n", optarg);
> +				exit(1);
> +			}
> +			size *= MB;
>  			break;
> -		case 'r':
> -			repeats = atoi(optarg);
> +		case 'r': {
> +			long val;
> +
> +			val = parse_positive_long_arg(optarg, "repeat count");
> +			if (val > INT_MAX) {
> +				fprintf(stderr, "Invalid repeat count '%s'\n", optarg);
> +				exit(1);
> +			}
> +			repeats = val;
>  			break;
> -		case 'n':
> -			nr_pages = atoi(optarg);
> -			if (nr_pages < 0)
> -				nr_pages = size / getpagesize();
> +		}
> +		case 'n': {
> +			long val;
> +
> +			val = parse_long_arg(optarg, "page count");

It's better to name the numbers parsing after what they do:
parse_flags() and parse_num().

> +			if (val != -1 && (val < 1 || val > INT_MAX)) {
 
And the limit checks seem wierd all over the place, like if we can loop
infinitely, why do we care about INT_MAX?

And what exact limit ULONG_MAX / MB or SIZE_MAX / sizeof(ptread_t) are
supposed to express?

> +				fprintf(stderr, "Invalid page count '%s'\n", optarg);
> +				exit(1);
> +			}
> +			nr_pages = val;
>  			break;

...

>  	if (hugetlb) {
>  		unsigned long hp_size = default_huge_page_size();
>  
> -		if (!hp_size)
> -			ksft_exit_skip("HugeTLB is unavailable\n");
> +		if (!hp_size) {
> +			fprintf(stderr, "Could not determine huge page size\n");
> +			return 1;
> +		}
> +
> +		if (size > ULONG_MAX - (hp_size - 1)) {
> +			fprintf(stderr, "HugeTLB mapping size is too large\n");
> +			return 1;
> +		}
>  
>  		size = (size + hp_size - 1) & ~(hp_size - 1);
> -		if (!hugetlb_setup_default(size / hp_size))
> -			ksft_exit_skip("Not enough huge pages\n");
> +		if (!hugetlb_setup_default(size / hp_size)) {
> +			fprintf(stderr, "Not enough huge pages\n");
> +			hugetlb_restore_settings();

you don't need to explicitly call hugetlb_restore_settings(),
_setup_defaults() sets up automatic restore on exit.

> +			return 1;
> +		}
> +		restore_hugetlb = true;
>  	}

...

>  	gup_fd = open(GUP_TEST_FILE, O_RDWR);
>  	if (gup_fd == -1) {
> -		switch (errno) {
> -		case EACCES:
> -			if (getuid())
> -				ksft_print_msg("Please run this test as root\n");
> -			break;
> -		case ENOENT:
> -			if (opendir("/sys/kernel/debug") == NULL)
> -				ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
> -			ksft_print_msg("check if CONFIG_GUP_TEST is enabled in kernel config\n");
> -			break;
> -		default:
> -			ksft_print_msg("failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
> -			break;
> -		}
> -		ksft_test_result_skip("Please run this test as root\n");
> -		ksft_exit_pass();
> +		int err = errno;
> +
> +		close(filed);
> +		if (err == EACCES)

What was wrong with switch (errno) ?

> +			fprintf(stderr, "Please run as root\n");

Please add root check upfront and skip EACCES here

> +		else if (err == ENOENT) {
> +			DIR *debugfs = opendir("/sys/kernel/debug");
> +
> +			if (!debugfs)
> +				fprintf(stderr, "Mount debugfs at /sys/kernel/debug\n");

Just replace the prints, no need to refactor the logic there.

> +			else {
> +				closedir(debugfs);
> +				fprintf(stderr, "Check CONFIG_GUP_TEST in kernel config\n");
> +			}
> +		} else
> +			fprintf(stderr, "Failed to open %s: %s\n", GUP_TEST_FILE,
> +				strerror(err));
> +		if (restore_hugetlb)
> +			hugetlb_restore_settings();
> +		return 1;
>  	}
>  
>  	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, filed, 0);
> -	if (p == MAP_FAILED)
> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
> +	if (p == MAP_FAILED) {
> +		fprintf(stderr, "mmap: %s\n", strerror(errno));
> +		close(filed);
> +		close(gup_fd);
> +
> +		if (restore_hugetlb)
> +			hugetlb_restore_settings();

Use goto err_do_cleanup here and everywhere else. Piling cleanups in 
if (something_failed) is error prone and unmaintainable.

> +		return 1;
> +	}
> +	close(filed);
>  	gup.addr = (unsigned long)p;
>  
>  	if (thp == 1)
  
...

>  	free(tid);
> +	munmap((void *)gup.addr, size);
> +	close(gup_fd);
> +	if (restore_hugetlb)
> +		hugetlb_restore_settings();
>  
> -	ksft_exit_pass();
> +	return bench_error ? 1 : 0;

Using goto for cleanup gives you clean return 1 on error and return 0 on
success.

-- 
Sincerely yours,
Mike.


