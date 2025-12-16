Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A43CD609A1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D496B0005; Tue, 16 Dec 2025 09:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904BD6B0089; Tue, 16 Dec 2025 09:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B3C6B008A; Tue, 16 Dec 2025 09:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 747CC6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:57:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C68EC06DE
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:57:05 +0000 (UTC)
X-FDA: 84225636810.23.C1028E9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47BCC140007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:57:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MbW/zTXjAzJ2SDlDqQMOXgofzez3dCZQpxUvYhKCU2s=;
	b=QmesX74iw6NpIA7M48nYawNYQbrWMyaDvogRBCYHoHmCp317vEIrc112JaDVZWMnNgBQI1
	6QeMzJmEfDAySaxmZyN7f2+Y26fe+Wim6XkLaKLZYFin9rWfx8aeKIRX2Wbu5pIGO1TE2Y
	7xFexpFrq1WIFi1f25+wOvA+X9ShlcI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897023; a=rsa-sha256;
	cv=none;
	b=lgRxvLk6b5lV/TkKdIfPz9eJLokhkshn22QkWqwvqRQ698CFoC0nVhrY/n8/+Z6lrh5SiY
	VYwkqNcAfAmgDodhULi3g7CQJkaYD4iJot8y3tjbCUjlNVChomr0L99eq5HO6cDtEURGiB
	cFEorwbYa0bMGV609lBayAB+3F2osoo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3972DFEC;
	Tue, 16 Dec 2025 06:56:55 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 937B03F73B;
	Tue, 16 Dec 2025 06:57:00 -0800 (PST)
Message-ID: <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
Date: Tue, 16 Dec 2025 14:56:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests/mm: fix faulting-in code in pagemap_ioctl
 test
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-4-kevin.brodsky@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251216142633.2401447-4-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47BCC140007
X-Stat-Signature: 5sbqprhczoobzjsazj9hyrbtz3hbadfq
X-Rspam-User: 
X-HE-Tag: 1765897023-377770
X-HE-Meta: U2FsdGVkX18el2ljfl2Q9mtIHLfl+cq9MttqzwRWIt5pAPPP9F/apYqLrYbyQRnzjgTVIVzFwpqhyF+uTYoXsXfPfJgPlhu4SKJxZLMBOGRkmm0YyOUYGwg4aaeLc/UbLkd/pBntFiwpmYPRDReo/TZpGxCJiFHQ78/l7/Zzpu4iOIoE4o26iT7jD0DhU8PRFPexVwwnKker3tOIp98nrJvW+YLGV2/4Fj+3EijhfKRVCmG4XeDLjq2/v1L+Ro935+Fc/Z6yHj+9VDIHRId4rHi/q/6wFSblXFNHZZnxglS3gXZhMhpcp9HYq1RR6BjWP1AzJh7bke3+Co1m1T8VHMeF00Fqt8Wgpa2aXKe3l7HkBS/11UKJtRwXFcVa73bWfSo879jlsSbB2VAEHnq+ROJADtegSx6KTL70XEc4JEawShUQnEYL1pykeJRtHst/X2I2c0V1mern7d/tDCKpAoN/73ZcXrb/3DmSL/nbT3jb7ndqgyiCpgqRhHzf2vzfnehDQmvu89XpT/NwH6dTJgW+jA7tAz9j6UFiSa8D7QnIue9L5UcHMFE3wTyrYZOgWwy39JWjJGtm/mnLjYXqXdEPJxtv+hRApgj84joZCW+bZ+wAxD1vANANEeULLhNQHHKwZ99tHf8ecKKyfhOydnGklFUONvpO5knmRSbvzi+NMBLL2TkocK9Z/Tc+wF7Mi0/sUFtPArAiDKMvjhcnlkiGnKcfZ1bV7Y56BKpQ8XnaH+vIxqRcjq4uzEsYDkarVu4QzFWt7/yXHK9BXvvg8U8A24bj7i5Ze6dwdcnfBTLFDUDVfZDx3dQ4H+rs7AsGi/876PZAqcZH5nhDAVCr5gt8uSJhsHsVdarqYNZkyysXUOwsXV5RT1aoLrvbN+1CB0RCnhaXNEGuq7vTV1X266VnjDdQyPgM3BVIVWyj/J/KtwSQBJnFpJTFNuVJqbe9ETNK9Y6ckRFgqlXyfB0
 S7gzlvWX
 UKoCMfNHcQJtD/Cd9duomKdEBhbA/sDgeSt9/no2EBrgFzMsgzBvpuw+OFjJyNEuE2RPesj6skQz+fTY4Vlt/tHv5wVy3UGcxZEjzl527wtVuPEQTE0xar8AvOQrY42XOnNk1yHnHfSuwve4+5jOJWxRtt7vZXOqnBDC5DKfGeLRqvp7qQM1qTqMl4V4JRHxZym0SF5NOwOxSjrTg2jnA9+N7cTR40/mD6M+E7V8D21UyPhyLxPELkRpMww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/12/2025 14:26, Kevin Brodsky wrote:
> One of the pagemap_ioctl tests attempts to fault in pages by
> memcpy()'ing them to an unused buffer. This probably worked
> originally, but since commit 46036188ea1f ("selftests/mm: build with
> -O2") the compiler is free to optimise away that unused buffer and
> the memcpy() with it. As a result there might not be any resident
> page in the mapping and the test may fail.
> 
> We don't need to copy all that memory anyway. Just fault in every
> page by forcing the compiler to read the first byte.
> 
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 2cb5441f29c7..67a7a3705604 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>  	struct page_region *vec;
>  	char *mem, *fmem;
>  	struct stat sbuf;
> -	char *tmp_buf;
>  
>  	/* 1. wrong operation */
>  	mem_size = 10 * page_size;
> @@ -1167,8 +1166,9 @@ int sanity_tests(void)
>  	if (fmem == MAP_FAILED)
>  		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
>  
> -	tmp_buf = malloc(sbuf.st_size);
> -	memcpy(tmp_buf, fmem, sbuf.st_size);
> +	/* Fault in every page by reading the first byte */
> +	for (i = 0; i < sbuf.st_size; i += page_size)
> +		(void)*(volatile char *)(fmem + i);

We have FORCE_READ() in vm_util.h for this. Perhaps that would be better?

>  
>  	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
>  			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);


