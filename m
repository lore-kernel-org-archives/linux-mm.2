Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 541A8EC01D4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DA36B0005; Mon, 23 Mar 2026 07:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE086B0088; Mon, 23 Mar 2026 07:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4686B0089; Mon, 23 Mar 2026 07:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7E96B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:56:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2740C1B90AF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:56:41 +0000 (UTC)
X-FDA: 84577175802.02.D8B3021
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41EB51C0007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:56:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/OMXgWu";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774266999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGHi1+LsBRFV7bIXuKKFFzQ7MZaEPPL/W74MGeHCUBI=;
	b=xYy+EnFly4+xub7CT8UTJi1M9StCkf0wScM16t6u/QbkS8p0x/dAnq2+VECu37aRdT4+Kr
	jRBiMCwu4i3l2FHLM1+PQZYPLFhsyVyImYwimFPI+vJBOR48kVkBcoJCQ79x6Nu7GBAfrC
	ouhPT9WMWaSpGhRouQV3mQ8a06vVzAM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774266999; a=rsa-sha256;
	cv=none;
	b=V7q+W7xUHA/0+s48zzHTnvZB9IlFis+DuxRcvsTX1yEz64noclwYSLNDux4Rz+MaF9GNhS
	qZdEClJVW90L6s2DaX9e0Lb2MeC2wSbocYxiYXiHc6aQrTP+pxX2hE+PqSHPUrIbASZVqu
	ETQskG6M9bNo6Gxfkc9EJ+6JNNWSIFM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/OMXgWu";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41E834441B;
	Mon, 23 Mar 2026 11:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D640C2BCB1;
	Mon, 23 Mar 2026 11:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774266998;
	bh=0DqT45wHIWJCNhvxa30ejAPQrE5LelMtMNTQg4f6hjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u/OMXgWu+chO3gvSI12/PPBLGLAG6Xmt6zeic+C0lrMmuuBOFfaJ6NcDr3wEsVEVc
	 EBqviFGr9mMYUGB9SRrwlDRUmyhf06XUyR8nhG95dPymq1tt/woI00vES7KjJgA4zd
	 JhAPgv0JIj7NDVGlazIOCO5TSvA8lTlL1X8XNjI44EYzACpCeCk1d2DwUqW8VStSyI
	 nvu1TAWAspCQtHJo7kjF5KHQBnkrAp41psY4G3AflGpg+hnQUCwvE7aFg0NlOyTUjJ
	 mi/rXt8Z3sz0FkVowK9jcQX2aE7+euJiZyT170qfAwD1tXz/RQVkpf7HT+xUkYBXWE
	 B7ca6w+Ds4q+A==
Message-ID: <a4fb1d56-8c10-46de-acf5-9a00ce0db4ad@kernel.org>
Date: Mon, 23 Mar 2026 12:56:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
To: Audra Mitchell <audra@redhat.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 usama.anjum@collabora.com, colin.i.king@gmail.com, avagin@google.com,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
 <20260320184010.759461-1-audra@redhat.com>
 <20260320184010.759461-2-audra@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260320184010.759461-2-audra@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41EB51C0007
X-Stat-Signature: cqai84kyb31oqgggf43r69bkex6so3z3
X-Rspam-User: 
X-HE-Tag: 1774266999-554354
X-HE-Meta: U2FsdGVkX1/XtFvqHVH1L7stkUxpIzvkdMHnfmMvvUSAnnxP7PygOVtDf/xN43OOmQp1GEMcT/g6OFj1jiM5LFgIufR4bjrXjHvWDDeZ2FUw/wNUJgPmwqJ0d7RpxJ99W9Ly2TM+8fYGhLA/E+2RXO2cpXHqJsqKVZywFkv8aBucadrq5I9PKfoQBVZRrajmikid62A5QqLUvAAeRQCC7cNJNkPJRLRA9dAEvX6AC7tN5JxpAafoxyTeVy3KAQexRA72kA+uLdDtFWxOy7ZoHkrMUuYGHHAEfNbfAfWBlZVMfRGm1VWMXqbhuJL7J7a7LsGXtA3Sg/IgzvnyBt0wMLjYTz9p16GQw9QVAGJx8TGwL+J9oJlokSCj/pX2OEuC/Kw34VOmUcnD3weA0+kYPIavTbD3e9YE8wbcrTaOSep3ry17PN7hYCQI/c0H9/zMdQoe4XLjZB2UxmKCeB+D76C/nbU7GYljFYQVAyUHzKW8mW9VKF3mDgiMFWpr/xh6VaF/OTzsfqxBx9eIDpu6bSjcO0xWSf30fuKZxm7ZB2bDBy+lbYOEUd1rHGBf3pZbGCuAVwVtGUIFMc0HkxFVTHVFoyAtGGEe3iHG7DJ/Cw+48rpehar1cbMNa6tqkgFBZ+/M8ClAEeF953g7fRK67HfvHTNt6ekTFnrTlFLgO7EnZk3viZ489zMXkSLIdlivmTefNMLGnnENv1TgkQGqDV+ZHR4bJEzsY0/paYLHXe56S+0n26F6R9FPgR8XokmshAHjARsnqFRfndLhm1+/OzLzA5wukXngrpNqjwXXkhZKM9CmH6Ii+iA1JxG5efqZi4tpROUitBTG1fCx9LLFF25L+B04sr3O/tbwU3U7U2hZgUI4Y1Gx+C0n6FN3O65JJbnkoOidSXIPTAKznvwvrtSXbbS+iMgVtKFVagO8PPlmN5WPM3rcxUms7O+EW62CcaI3WLZtg3i0kzmTToF
 KkJZ3YTk
 HTxuJp6IzqSOPH2TrFeN9+4+oWsTElup+pWJxUtYgBrBZbd/9uj4Xv+dK0LmXnAWmehQ+eD6WbQUI14QXhy1TqeBz/BODTJTli8G2kC5JQRQo+bkncix7CbtWmRBrp6TXv/a6u1WqXxM8njOoQBoPk3tRvlWL+DfyQG3lKttqRf8aGYjcK5kz1XGes1YjhmPZNKdPNiDHXOIXb9oWAd3AcEsQCRdRaBmt4b5+CRS/x4McJxV0c5u3beWW6P5yhxMtYM4j4Cl8VQPSQv9gd0tLFvkCGmAdDiPVJavO8OWS6qZ39ZK6g7e/i40hjbe04JmUQBtPAhhh3UMikOPYaCiS0F5BbgjdxtuMcEJX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:39, Audra Mitchell wrote:
> On architectures with separate user address space, such as s390 or
> those without an MMU, the soft-dirty kselftest may fail when checking
> to see if the feature is supported.
> 
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..15
>   # Bail out! PAGEMAP_SCAN succeeded unexpectedly
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 1 soft-dirty # exit=1
>   # SUMMARY: PASS=0 SKIP=0 FAIL=1
> 
> The soft-dirty test will initate an ioctl with the PAGEMAP_SCAN flag with
> an invalid address for the page_region. This is done intentionally to
> have the ioctl return with an expected EFAULT and with the correct
> categories returned.
> 
> However, on architectures with separate user address space, such as s390 or
> those without an MMU, the call to __access_ok (used to validate the
> variables provided with the ioctl) will always return true and we will not
> fail as expected.
> 
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> Let's simplify the check for PAGEMAP_SCAN and provide a valid page_region
> address so that we get a non-errno return if it is supported.
> 
> Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")
> 
> Signed-off-by: Audra Mitchell <audra@redhat.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index a6d4ff7dfdc0..82998406b335 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -67,20 +67,26 @@ static uint64_t pagemap_scan_get_categories(int fd, char *start)
>  }
>  
>  /* `start` is any valid address. */
> -static bool pagemap_scan_supported(int fd, char *start)
> +static bool pagemap_scan_supported(int fd)
>  {
> +	const size_t pagesize = getpagesize();
>  	static int supported = -1;
> -	int ret;
> +	struct page_region r;
> +	void *test_area;
>  
>  	if (supported != -1)
>  		return supported;
>  
> -	/* Provide an invalid address in order to trigger EFAULT. */
> -	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
> -	if (ret == 0)
> -		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
> -
> -	supported = errno == EFAULT;
> +	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
> +			MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> +	if (test_area == MAP_FAILED) {
> +		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
> +		supported = 0;
> +	} else {
> +		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;

You have to cast it to a (long) first before comparing, like we do in
pagemap_scan_get_categories().


Maybe best written as

	long ret = __pagemap_scan_get_categories(fd, test_area, &r);

	if (ret >= 0)
		supported = 1;

> +		ksft_print_msg("errno: %d\n", errno);

I guess we should drop that, was mostly for testing.

Thanks!

-- 
Cheers,

David

