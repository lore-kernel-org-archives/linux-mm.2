Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934BCD46952
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065DE6B02D4; Thu, 22 Jan 2026 12:36:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EEC6B02D6; Thu, 22 Jan 2026 12:36:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41026B02D7; Thu, 22 Jan 2026 12:36:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCE136B02D4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:36:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99AE8D2D68
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:36:18 +0000 (UTC)
X-FDA: 84360303636.02.D90E6BC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F1841C0006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:36:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of usama.anjum@foss.arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@foss.arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769103377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=02LztQai4l7P85BjGumOFv1iuVLXRilP1bCGfHdyLKg=;
	b=t8PVoqWLRZq9j55kmRCH5wgk2B3QIDgl6MfjTF3U775stIFqueCFFO1LQXSYGU/t5lnx7W
	Z5W9AiSdRWOSbX8h09sxImncyFiCAacGdXtMID2jzLt3dtpUrAhsUAwK+pknmoW4DwdLNn
	t/lfQoIOIUuXCIyYHMAaKQA1Kb0SqCc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of usama.anjum@foss.arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@foss.arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769103377; a=rsa-sha256;
	cv=none;
	b=QERAxNbE8+F0Y3P5QaXSZqASiNursNVheWHAMmWRPZthIXJ0qfYwdXGQqUphhdYBmiiH9U
	fecDjVGprA/ZL2Z+EGD76PIZl0/MTwmCkp7gVWFDuJvoXqPf0hzGYwm6UU3OedRmLchSlq
	9GQJUv2VXU96stpcJIfUCobSR5nL+Y0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37A4E1476;
	Thu, 22 Jan 2026 09:36:09 -0800 (PST)
Received: from [10.1.194.63] (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F4573F632;
	Thu, 22 Jan 2026 09:36:14 -0800 (PST)
Message-ID: <ab021f50-60c9-4d5c-99a0-255ead6e2288@foss.arm.com>
Date: Thu, 22 Jan 2026 17:36:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@foss.arm.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 5/9] selftests/mm: check that FORCE_READ() succeeded
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-6-kevin.brodsky@arm.com>
Content-Language: en-US
From: Usama Anjum <usama.anjum@foss.arm.com>
In-Reply-To: <20260122170224.4056513-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F1841C0006
X-Stat-Signature: g9qbz1r3479rip3drw5ugyk6nwbncnf1
X-Rspam-User: 
X-HE-Tag: 1769103376-940749
X-HE-Meta: U2FsdGVkX1+RCcb++BghYhPd/aTFNz4nZFo+wj9pd18X+JZL1US7MdZOGCp5N+0MaHSL1KfcWub7kA8oMK58LAXHrD/ziALpb8C5BbXTXKZWUJb+4u+BZndjdK6EJtgMD8YRFCrPS9+GQWZIbmo8V43jy+l6AFDdOKOy01XTZBVM+GSDJKyP5SRG4ZnOgyy9TyYzmhR1l4tkE3RMSwKtW3IL0ZESfiS8YHsFtUkKTdge2mabQmav+6UM+oeYFvxpwZFg13PWz7f8NwjZE2wJs+UB2WHesSO+c+GEAxoF7U7ZjBX/5bYyzS7DvSr6Epzgguz8mEY8Ife4o6f1OIInzEVuSbgGuHL0mJV0QvEFBc/JG5RpyNQlQaBoS/I6LJDvvGUuPCMfX9C5WcwAkQk2Sb2jfwkvFH8HaY4shavXD3nbv89j5KE+ycEaYPafhkckJWDGwaMqTQjuYVBpbQOS6D5hApefTxuIIEJyjn3WHx7j2PRUqRfHHzxEjdMtPH2f3kTLkL5IJVbXV5IOO9kEqISdRskBlzpVdUPJpcT7May6WyC/U8RrdYM+qId1CrAA4JlMrzPqzb3/eLJiYIgq8kyXkfiDqlxjJZHY7NiMig011f4P9NHBAJgOnzqWI7cWk/R73tUy4peiTF05g3OghOHaUjcJg7moyn4UFM9maxSzZ1HyedQlxAUf5nTZEvu1RjekTOX07aMUswIDMUmEDdh+bUDmlO6p8hvpgaHDPQly1/MCxrG4+vjGDOrP6AEhzzdsqiGP7L9ks76LPZ3JPGFAxqU7/4Su2XT/SMNXgGRnQDH7/W8FUA1SmCExHwel098LxHNLiXTXXLr7YTB3zAxUGUAV+w4Y7KJRri8ehbPK18wCMmL9eb5Lyn6cVkmKeVTz0R3Zv6uIpicdA/z3/TDrmCgS6dBt1mC6x1XLJV5C7FpuUhT9/3qo3il88YWVNT5pmGK8mUHnog5qNth
 025xohW8
 krPfjbQEI/0ijI1bUMEl8gIUVCg2KxNKBi4nI4C4gjah7REBdU09oDwCt2o4XN1bQUGcIzy6cHSApnM8GDN4IE0wIK9ljgpX8JtuVHiEnZt5xwzZtXx5axJYY064AIywQCwfZEu77m0GcC9CCXDYRiLWG2ctbAYUAM2c0GS68IviIrWDODFXeen1WY9V+cGKzDZg50F5g65bWZkeQhpfxurcFaEaEpRXNfwfQZwRLNUl7EB2PhNdXAf3Osu+Mj4QmtI++tdUivWh74bGN889gnKsfDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/01/2026 5:02 pm, Kevin Brodsky wrote:
> Many cow tests rely on FORCE_READ() to populate pages. Introduce a
> helper to make sure that the pages are actually populated, and fail
> otherwise.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   tools/testing/selftests/mm/cow.c | 43 ++++++++++++++++++++++++--------
>   1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
> index 83b3563be26b..d9c69c04b67d 100644
> --- a/tools/testing/selftests/mm/cow.c
> +++ b/tools/testing/selftests/mm/cow.c
> @@ -75,6 +75,18 @@ static bool range_is_swapped(void *addr, size_t size)
>   	return true;
>   }
>   
> +static bool populate_page_checked(char *addr)
> +{
> +	bool ret;
> +
> +	FORCE_READ(*addr);
> +	ret = pagemap_is_populated(pagemap_fd, addr);
Very useful. Maybe extending FORCE_READ can help the entire suite?

> +	if (!ret)
> +		ksft_print_msg("Failed to populate page\n");
> +
> +	return ret;
> +}
> +
>   struct comm_pipes {
>   	int child_ready[2];
>   	int parent_ready[2];
> @@ -1549,8 +1561,10 @@ static void run_with_zeropage(non_anon_test_fn fn, const char *desc)
>   	}
>   
>   	/* Read from the page to populate the shared zeropage. */
> -	FORCE_READ(*mem);
> -	FORCE_READ(*smem);
> +	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
> +		log_test_result(KSFT_FAIL);
> +		goto munmap;
> +	}
>   
>   	fn(mem, smem, pagesize);
>   munmap:
> @@ -1612,8 +1626,11 @@ static void run_with_huge_zeropage(non_anon_test_fn fn, const char *desc)
>   	 * the first sub-page and test if we get another sub-page populated
>   	 * automatically.
>   	 */
> -	FORCE_READ(*mem);
> -	FORCE_READ(*smem);
> +	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
> +		log_test_result(KSFT_FAIL);
> +		goto munmap;
> +	}
> +
>   	if (!pagemap_is_populated(pagemap_fd, mem + pagesize) ||
>   	    !pagemap_is_populated(pagemap_fd, smem + pagesize)) {
>   		ksft_test_result_skip("Did not get THPs populated\n");
> @@ -1663,8 +1680,10 @@ static void run_with_memfd(non_anon_test_fn fn, const char *desc)
>   	}
>   
>   	/* Fault the page in. */
> -	FORCE_READ(*mem);
> -	FORCE_READ(*smem);
> +	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
> +		log_test_result(KSFT_FAIL);
> +		goto munmap;
> +	}
>   
>   	fn(mem, smem, pagesize);
>   munmap:
> @@ -1719,8 +1738,10 @@ static void run_with_tmpfile(non_anon_test_fn fn, const char *desc)
>   	}
>   
>   	/* Fault the page in. */
> -	FORCE_READ(*mem);
> -	FORCE_READ(*smem);
> +	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
> +		log_test_result(KSFT_FAIL);
> +		goto munmap;
> +	}
>   
>   	fn(mem, smem, pagesize);
>   munmap:
> @@ -1773,8 +1794,10 @@ static void run_with_memfd_hugetlb(non_anon_test_fn fn, const char *desc,
>   	}
>   
>   	/* Fault the page in. */
> -	FORCE_READ(*mem);
> -	FORCE_READ(*smem);
> +	if (!populate_page_checked(mem) || !populate_page_checked(smem)) {
> +		log_test_result(KSFT_FAIL);
> +		goto munmap;
> +	}
>   
>   	fn(mem, smem, hugetlbsize);
>   munmap:


