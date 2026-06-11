Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D89CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0306B008C; Thu, 11 Jun 2026 07:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651216B0095; Thu, 11 Jun 2026 07:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5673B6B0096; Thu, 11 Jun 2026 07:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 464BB6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:19:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8C508F2B1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:19:27 +0000 (UTC)
X-FDA: 84867385974.12.E64797F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67A9C40010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:19:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=s5JDMEet;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781176766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27dFclWA2Lur3qjVK2QJ/m9c9rr2zJt+jnJIG2sLY1I=;
	b=V7B3cMucc7zjpRsyDhPa7f3Bbuu7+0jIw6LoN3+ItsabyHWe5Bxv/AjuQb7RjBOTQdyuba
	tLFn30d8rRSFTIRYk3RkaFtTE7IocpjCBncM7CkbTSm3Uek3jVsQbW4ofyzo/sTOn8uLde
	vCFI0gkpXCpJVqoXWmrYkNuoisxM6HU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=s5JDMEet;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781176766;
	b=segM9XFb+7sqCKHXXCn7EFGyGWIcbfAjXH93l6sNOPhm+dpXr3ZoGOmNlt/cLIZKVztn8i
	mf61b+TJC2j0ndB9xNVU/DO+truikqNB/TRI1vyouX5cqH9B1aRV/n7kNyAhYhOvZwwEen
	yLQ7SFcbA/lRQljIsU+kJSHeCLfW62s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE7041E2F;
	Thu, 11 Jun 2026 04:19:18 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 754853F99C;
	Thu, 11 Jun 2026 04:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781176763; bh=BFKcm0a5+pCf9HpTGuxNYm633tdLx40f3RyFxLVzlDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s5JDMEetBzatj0KcVPyKtSrqxRZ0n8vyYYvVcEgtW/Da9QFMoTJTvCIvu5uV9WkOG
	 s7WPy6RK4NQCasc80DpXJFR92QUOa/qIVMByPiIqf1TfTGD6rRvdMC0FouC5G34EUQ
	 ApK8D6oWbMAnB3kV//fObcHOQ/bDDZvQK+G03cv4=
Message-ID: <bd9d1353-3053-4665-8f35-ae3f6e379237@arm.com>
Date: Thu, 11 Jun 2026 16:49:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67A9C40010
X-Rspam-User: 
X-Stat-Signature: p61jfekyudf4f34w49q5jyyd566bxbn9
X-Rspamd-Server: rspam09
X-HE-Tag: 1781176765-867005
X-HE-Meta: U2FsdGVkX18kfyqHp7Z6K2sppuCzqMRZFcsBv4KQj7VpO5jxneHCvgnE4gMfo+0ANCqE9rUqj+cEx6D4zVqb8pCh7/OcBx8ylZJri9GSnnaxqA8OXPjimZoD1gJJgNOWvFZU2Hcfs72l90K2El3PQXYxo6645uHLTnhhWTBEDw5D/ksQa5xWgOMg/dvtw/wiMFVq4fkhCVBAZDSZgE2O0vYlvDMo/2ux88A1McTH1ZH0e7867BxRzMkDQdX17O9Qhw3QldjsOGdW2BbUekTIGyLBgODzTf9gjkCf3xQCWnSMr0eOqqGBITjlwkaLWqDDelRlSza/K7P4Z4o3eJuXeF4ojSEAyDZ1i02LNQBmT8TtXutv8ihcpq+OZnDxrdw6SD2BNkmGb04cSCYm6RJml2H0mvf7U7jn7g891ifRhQLZCBBD056f02BYXbDjghjXKQhhl0QS3j8PVBeJ1Pg3jXp9acXMsRTSepdAybPrkO+N/bsST3qqk3kh8+VtQ1wg7NORTEonyg8BN5Y33fVd95+ApHwo8d/Y1Aa7f7KTkYxOHHLogMPuB341w2H2Td9HugThzlbTDpvx0pV8kU6v18Z7RphdLbBGjqth194dbbEwzY4ykVcXVPJ3RikeUP88qfB1rD9n8tYtt9E6d6QAMUeEA+ctIYC0JM0KNRANM0/7ZjnrVnA+Mvq2JgFd0T22ag+cBubwhasK9RLO80FGbJ93A3WvqgRZiOk45oYOLsh01GIAKR2JPAPe/RiA6xZ2V5vbbWUJrzDz3WB3lxZFTydSVa0/N0D+ovfFILR/5DRHBrS5pRXErE2i2la9rywlklv26cgUMYTVoMy4Phg8A6rIi2S9nUOjJAP0mQ/cEgAZzYBn9ohZ7zWwqZmmiZcG/wzbiYvGTO3vNHQS0bpDLirZw0sS7tXyW6iRmuvp1UXGQo1qwCT7JbcDN5N7M1oVysf8lId5FckXsKPtYjc
 viKPD7PF
 jTh7SRCK5pCNVRjPYCYXhZIFJxcolcU6Tf9d/6jaUnhhapl0Z11Egpc6DcZX/Fo4reaqe2vi5yThvWioybU457nuVrgNC+f2JuOy2QpiA0MWKbpN7CrcPEkoIfUfbOaq+AhdPBnKAAhE2w2+CmlV6amEyH1WckfgLW+Wom3r+NtKkLDS51/Q3RCAsq0xDbLTJ9PMTbG+EckZosXUCKrfO41pdUhrz85DPP/92h7OuPuGHvy0GjzfcfvwQMZ3w+OvLq9ANh1MaoaCY3H1AT+QVyGSUVeJFqE7MarWOjsfClw0VoYCdncoIFy7HV/YS3S+i4uY8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/06/26 3:31 pm, David Hildenbrand (Arm) wrote:
> The droppable test currently relies on creating memory pressure in a
> child process to trigger dropping the droppable pages.
> 
> That not only takes a long time on some machines (allocating and filling
> all that memory), on large machines this will not work as we hardcode the
> area size to 134217728 bytes.
> 
> ... further, we rely on timeouts to detect that memory was not dropped,
> which is really suboptimal.
> 
> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
> with droppable memory even without swap.
> 
> There is the low chance of MADV_PAGEOUT failing to drop a page because
> of speculative references. We'll wait 1s and retry 10 times to
> rule that unlikely case out as best as we can.
> 
> On a machine without swap:
> 
> 	$ ./droppable
> 	TAP version 13
> 	1..1
> 	ok 1 madvise(MADV_PAGEOUT) behavior
> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  tools/testing/selftests/mm/droppable.c | 46 +++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
> index 30c8be37fcb9..57e1b6fc5569 100644
> --- a/tools/testing/selftests/mm/droppable.c
> +++ b/tools/testing/selftests/mm/droppable.c
> @@ -17,10 +17,10 @@
>  
>  int main(int argc, char *argv[])
>  {
> -	size_t alloc_size = 134217728;
> -	size_t page_size = getpagesize();
> +	const size_t alloc_size = 2 * 1024 * 1024;
> +	int retry_count = 10;
> +	bool dropped;
>  	void *alloc;
> -	pid_t child;
>  
>  	ksft_print_header();
>  	ksft_set_plan(1);
> @@ -35,26 +35,32 @@ int main(int argc, char *argv[])
>  		exit(KSFT_FAIL);
>  	}
>  	memset(alloc, 'A', alloc_size);
> -	for (size_t i = 0; i < alloc_size; i += page_size)
> -		assert(*(uint8_t *)(alloc + i));
> -
> -	child = fork();
> -	assert(child >= 0);
> -	if (!child) {
> -		for (;;)
> -			*(char *)malloc(page_size) = 'B';
> -	}
>  
> -	for (bool done = false; !done;) {
> -		for (size_t i = 0; i < alloc_size; i += page_size) {
> -			if (!*(uint8_t *)(alloc + i)) {
> -				done = true;
> -				break;
> +	while (retry_count--) {
> +		if (madvise(alloc, alloc_size, MADV_PAGEOUT)) {
> +			if (errno == EINVAL) {
> +				ksft_test_result_skip("madvise(MADV_PAGEOUT) not supported\n");
> +				exit(KSFT_SKIP);
>  			}
> +			ksft_test_result_fail("madvise(MADV_PAGEOUT) error: %s\n", strerror(errno));
> +			exit(KSFT_FAIL);
>  		}
> +
> +		dropped = memchr(alloc, 'A', alloc_size) == NULL;
> +
> +		/*
> +		 * Speculative reference can temporarily prevent some
> +		 * pages from getting dropped. So sleep and retry.
> +		 *
> +		 * If a page is not droppable for 10s, something
> +		 * is seriously messed up and we want to fail.
> +		 */
> +		if (dropped)
> +			break;
> +		sleep(1);
>  	}
> -	kill(child, SIGTERM);
>  
> -	ksft_test_result_pass("MAP_DROPPABLE: PASS\n");
> -	exit(KSFT_PASS);
> +	ksft_test_result(dropped, "madvise(MADV_PAGEOUT) behavior\n");

You meant "MAP_DROPPABLE" behaviour? Perhaps that can be folded in.

Otherwise LGTM.

Reviewed-by: Dev Jain <dev.jain@arm.com>


> +
> +	ksft_finished();
>  }
> 
> ---
> 
> base-commit: d401506a8ee8ac6bc4a7767c17da036e9434a4a3
> 
> change-id: 20260611-droppable_test-3737bd791dfb
> 
> --
> 
> Cheers,
> 
> David
> 
> 


