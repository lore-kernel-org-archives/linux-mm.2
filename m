Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44847E81BD1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EF36B008C; Mon,  9 Feb 2026 09:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813976B00B1; Mon,  9 Feb 2026 09:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743B96B00B2; Mon,  9 Feb 2026 09:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 633026B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:48:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17D0EAF64B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:48:23 +0000 (UTC)
X-FDA: 84425198886.03.D113C9C
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F437140011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:48:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=QTOPP3Er;
	spf=pass (imf23.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qdm14cHHj8D24U6COEkXGmQ6Vu/705Cb0Axetnz5Nbs=;
	b=TVf0gUQsBxrRTn8MkGDv22T2sDUCz4KHro4353xrykSv3/6GMJnPtazcqMBBFKvYjOdZyq
	3KIUVh/1MZxjczc6tTWaQPgL60e29uRF0BTazCgqMdINNDrsMxxIctFoXqZ8JXoKpeHg7D
	e8I7ZZc4yDstV3GUT8ck+cCt7hSATkw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=QTOPP3Er;
	spf=pass (imf23.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648501; a=rsa-sha256;
	cv=none;
	b=VqA+il8OI4umVCtPii1lIk6oK5hYrfqpBjd6Na21n0OhszQbX76/WN0hX95+zaA7cg28cD
	y5qHXJThQEt7fG90V1SFtJ0eCmKb7z/I6GDLkjY3JrVnAq5oj24/iBAE3t7HtNZQ4IwYwd
	8i9MSTwcHhA5SgFkwyPMBRTLdUEWVoE=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 7FD9540C8B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1770648499; bh=Qdm14cHHj8D24U6COEkXGmQ6Vu/705Cb0Axetnz5Nbs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QTOPP3ErsxHjo2jsLBJaTk8MlmXdMV3D7tvzPLhhuwAyRfdCGsm7FMPFEHG3RoBjT
	 dk68P5aQHoXl2tv6bifVXz/KWrUIapAFwYeapspBTOz7OsP8oG/hndHrCVVA/u4gC/
	 S5r+Kd9POrbu9gcaovUJwFGc+ex0N3yedOWKPGVN3ZYqsEe47dyXv7mi6xaDvhzObW
	 NLriV0oxoxCEzaE+V2Rr5Pb/oDzrO6FFOX8KxBkpHKo86sNz9RWd1694Go/pvrEoTj
	 xr4LWc44i/R4DKM0jm8PiJbiU8mALzZU8FWr2L9uPzDEkost26wD1nxyK3LuKYLMT3
	 w+ebCu3gwCi4g==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 7FD9540C8B;
	Mon,  9 Feb 2026 14:48:19 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Min-Hsun Chang <chmh0624@gmail.com>, akpm@linux-foundation.org
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Min-Hsun Chang <chmh0624@gmail.com>
Subject: Re: [PATCH] Docs/mm: fix typos and grammar in page_tables.rst
In-Reply-To: <20260209081323.68339-1-chmh0624@gmail.com>
References: <20260209081323.68339-1-chmh0624@gmail.com>
Date: Mon, 09 Feb 2026 07:48:18 -0700
Message-ID: <87wm0m9dn1.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mupkixng183wfhu4fooejm9w77speoni
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F437140011
X-HE-Tag: 1770648501-854998
X-HE-Meta: U2FsdGVkX1+JpEGVwAqdm+tht8WRP/pHJmqXKoH1nOlgA9dyy7jwwvxWmsaHyDvOqOy2MuLBuB3974EJBetR1XoLy82Zn9EzY7ceuBniE030B9KGuyZBtUw9hhsVJ6iSNVu7dpgIto+qvQYPIgU2mXjZjYM3pDqrS/y9YwlVym8dzbn+f/LI1Io9Wop+rn/2ZOAuAJ+WrONwFXDKCFzdy/6XLRgcwIXxCkWWWvHEJKgozgzcu5gpE8bUXYX0UO0cruetF+EEDqE7EVFg3LI9W+2GaiznNCWHxkU5/fGRdZZhNo6F8/wNf4l3z1tGH5vQ1bDj841cgrATzeIhiEjX83P0uZdesGA8ZCVSjLXOW4Pm0edZLRNPAdv+sQxJnjAlsWw+18rQKiiiZ24xQ4SClRMDfnxiVCgDqk8TKvu2rFXIhAfjWMfa3AN5Pil3j39lSd/G4lFrBEDi5ZjSU6jSW3slL+c3jPHGU3CYIlSIIWwsSeW2Ac/Wgj+785NLKrJp7p2ZcatFM/3NdG1RYy0UeGzic9ypeMAsZT55BF0YH77Szd2/6Y1PYOkiQCrhKlFH2uk+XGC09XlhZC88bN0dCJ9gcDZYMyN+x3fkX2XLw4/hNXeWKHzK5XhUuy8zuO8XEU5CIqq5P5dvPx7mHi5G0gWsO1bdXd+8+dNMr/CTsdaQqmUCvabTzGNiheajRmnkdtytfUp7/4bPmKTyVa4VbtRUIgDX64NeAghv/EEIfmyqbboTxrqk9eELrsllfRmFTxVqTvqRYAF/hhMXdjGceRgpU2xym0AdxEkFloBA0a8TJhKrIWupDGAimp6UxzINJR/qVICnlhGKP/dj3CPy9haEC7Gi3LZfCuThZ1RJhC4iesP7nKwueIZPfr+DR8+7otUZIl2jkaNvUsJouiWlwCcEVf8Zh6OOnF3g4biHcOCc4yoEWLsU9z+Vvtwl9v//90W4DJK4HX9lCJbpu8w
 LuSZMLKG
 NTPlXKGWeiIYqoBuh52MJ9vRYeUwJFiqWZTk/LcwTG0/S4xit/2zGUuehxkif0v/0YzjVaKVzLccKlRilG8IqeFtgRLqAcCJrdDhvYyPyyj5jLH6tFUNwJKdUHpi46A+syrnB+YkPiT7YqzC1QcQ0UMEqZpYIviePHLpblkBVP33hmMYutrOrSwStmc9EHswCiOIKHJ+ywVNre7+jnJTr+rLSDDHRJUkPjmo1nMSFDXX9HuzFl4NJ93rE3PnFDn8SRRcnQlQEhO0VjEJlb2BXLMFwom6rnYxJi8qN5XPf6P5cX8qK3b/VLwMSuruizndkMKaYo9v9ltjnIYSOc78ZzeBUI4ydEeqNvJlN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Min-Hsun Chang <chmh0624@gmail.com> writes:

> Correct several spelling and grammatical errors in the page tables
> documentation. This includes:
> - Fixing "a address" to "an address"
> - Fixing "pfs" to "pfns"
> - Correcting the possessive "Torvald's" to "Torvalds'"
> - Fixing "instruction that want" to "instruction that wants"
> - Fixing "code path" to "code paths"
>
> Signed-off-by: Min-Hsun Chang <chmh0624@gmail.com>
> ---
>  Documentation/mm/page_tables.rst | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/mm/page_tables.rst b/Documentation/mm/page_tables.rst
> index e7c69cc32493..d5a2c37b05e4 100644
> --- a/Documentation/mm/page_tables.rst
> +++ b/Documentation/mm/page_tables.rst
> @@ -26,9 +26,9 @@ Physical memory address 0 will be *pfn 0* and the highest pfn will be
>  the last page of physical memory the external address bus of the CPU can
>  address.
>  
> -With a page granularity of 4KB and a address range of 32 bits, pfn 0 is at
> +With a page granularity of 4KB and an address range of 32 bits, pfn 0 is at
>  address 0x00000000, pfn 1 is at address 0x00001000, pfn 2 is at 0x00002000
> -and so on until we reach pfn 0xfffff at 0xfffff000. With 16KB pages pfs are
> +and so on until we reach pfn 0xfffff at 0xfffff000. With 16KB pages pfns are
>  at 0x00004000, 0x00008000 ... 0xffffc000 and pfn goes from 0 to 0x3ffff.
>  
>  As you can see, with 4KB pages the page base address uses bits 12-31 of the
> @@ -38,8 +38,8 @@ address, and this is why `PAGE_SHIFT` in this case is defined as 12 and
>  Over time a deeper hierarchy has been developed in response to increasing memory
>  sizes. When Linux was created, 4KB pages and a single page table called
>  `swapper_pg_dir` with 1024 entries was used, covering 4MB which coincided with
> -the fact that Torvald's first computer had 4MB of physical memory. Entries in
> -this single table were referred to as *PTE*:s - page table entries.
> +the fact that Torvalds' first computer had 4MB of physical memory. Entries in
> +this single table were referred to as *PTEs* - page table entries.

If you are going to correct that, it should be, by the rules of English,
"Torvalds's".  The elision of the final "s" is done with plural nouns
but not those ending naturally with "s".  As we all know, there's only
one Linus.

Thanks,

jon

