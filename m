Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73F8FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208526B0093; Tue, 28 Apr 2026 10:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF986B0095; Tue, 28 Apr 2026 10:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D866B0096; Tue, 28 Apr 2026 10:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 011556B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:16:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBE4EC053D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:16:56 +0000 (UTC)
X-FDA: 84708166032.10.0248C49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2C754000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:16:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N9PsyVWZ;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777385814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drgZBvdgFovUmyn0F4YsFW+A4FlyUejDfNRWxc71Yvs=;
	b=w4vQ5DJlIP4P0sV+B6fYQkXU1Ez+i2elUhFwUry3xtu7MGvIdj62IlHIxOBUhBFaWlXPof
	k9hKXSwT2F/I4AOn3qxTCiOKdMcThzXIUJZhaselTEQhGTFsffe8YLajrsoVOGSqd91cn7
	FUjpiz+TjVzGkdQ1ZIN4uuJizczRE2A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N9PsyVWZ;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777385814; a=rsa-sha256;
	cv=none;
	b=L8KFiuuCIHiixf8uRWr+gctITZRZSPU03ikP6WAiQo6utw8TFqRgRFr0b7/cadjkS5vUyO
	ka0rZIcMwlNmkreIDzldmYEpfyqUw94rYyQhCaK+su5oA8ZPfaUyuG1bxPbRmnydNMiVwW
	5Uw8Nm/dvvqKb+owyAA/64051mJCWr4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B03D15A1;
	Tue, 28 Apr 2026 07:16:47 -0700 (PDT)
Received: from [10.57.63.26] (unknown [10.57.63.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B3763F763;
	Tue, 28 Apr 2026 07:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777385812; bh=oVrjIdlZ5Ebhd/IWkU1FIsmJ7nMiw5cvbtJC65flWy8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N9PsyVWZb9ZJ4M1SqH3xQYLnoSiZIX8Z3lJsZWaSwJBJW9JuJqRJAqdYLmCJDIOoE
	 +6rp3bcWLVPNuxuJnN1AV3qfoMKZVRHdgluQweWZSdfqaUSNbDYhKI/zxfpTj6tJ8j
	 FWC1eGlcCi1Fw2SoBRVyxLOvdlknS60k/xbkGuLA=
Message-ID: <802ca264-a849-4c66-a27c-db6fa9915711@arm.com>
Date: Tue, 28 Apr 2026 16:16:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-19-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E2C754000A
X-Stat-Signature: 8atgi3ipugyg61udf59be4jei64u3685
X-HE-Tag: 1777385813-537234
X-HE-Meta: U2FsdGVkX1+OO41Ce+7Fg3vk+7bpZolzjKYOiiZKSMshPPCrrMW4orD3erCG7ZRDaK6EH0gKIIoH5nshF0rKK5uVsSWwfgE7J4lC12QlGcvT7U8O/TqDHz3LD4246mCuDA9r1BZrzbhJyDg9KDsALl4wsa8Cet14t8xDbD4JfGPoTIkTqEJXPzV5f55LSRWY+EJFvJ2kL2l1mVMXO9J4/prWUfZKBlx5iIbb6kO97gUu9pIsNmQc50jWJzbfMINOvVQ4bWXhNmfQ/WkDPX7p5eN1g2g636F1auhwRIYVY67WP+FuAdzgWjd7/ayEcqn1dskyyon0VO4a385Xjvh7yGmGnUPpzhKPCLodDUnqqLUgVTgLPgRhOCCf0UciDdVKQAVAo+Ie2tQNaIPYMA4HNggulWXYWzpfanWwWTTIllQGZ3uB/PJr6OMmeyj+SJBC5ynpx1eLXDy0x4B3R7YA8NX0+LOsixyHSpAbo004JrGfJ0YFHihyIlG+oKHaSH8zOa65ZuhX6HlcqCt/kNN6zOt2mkofSgch5gQIiYZx0tUASFYKgVwjOaUynSqsD7BNnSRos2mLFVYXzgzBUU2dFJvVSYR9Omx14BaFDezGyoFdI03NfNkYwAP2CwngXu6DBAuIiAy4ircIVGKSGps8PJIbU6k5JxEVyD+O+CmA1HLBZq+n8EbvDMmHBzF9W4M8vMQvnS6YVfGPzZc3JVuWw9y3lIlQIHz79pqg7MHV/ojZUVe7AQNMsCpXOULfdKkMLgKdrDdHB2PJuidW6j6HmkAHIMxBVhPWlkIi2NonTdpNi/NFHeQZeY6VY74XBeeN8zRM/+syWDHiodJ/fTfojnCh3jBPohXNeCYUPsEx1nVMVeSfi9H6cYZ+GyB/kfz/h2OXGYPIjf/e7aEZeVtbqa2OPDC+MUnrM7PlXDvaa5K/ROlz3i+Z7sNvu74EbTd8mU212trYomzy0JUACaE
 Y+mtgSek
 bitU/enzvsOaS12LuxIgyPsll+7uVuFxyr5hrsDfN0DfgAd4MmY0+7HMBLaCWU/OKFdHfYVH5HMIk0uVwqboNnI+7P/hTwLTNCUuuv/69FFSEPGzEw+/lTC476Dd9RNnv82432NB/9aNBmj72t1ppFhfSLnmQH6FTNpHn1QnrVJMiAj8SwR0mZqVy2RQBXbgfAv7qZ+gd0q2BWnLEAJqP5NUqhy17IDfjED1BwssXPFEbLG4rfAaPQOy2127TDr6G4+anZbw2cExJ5jvtP4JZX2ehfKt3c1B3J1SIXSDxXf1R0/HjQlVjMUQNzLrcyFm93MVAlbH1Qp+sw52Ox3De1pG2aYcQtte6ILXGktg/hLIOONGZK+X59ugF8fRRSThrzpkbd+iRK9xBzLE0u6XEf+briOYXFqvnagaQs2HCj9UyaHZcG/uN4TxO3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The empty zero page is used to back any kernel or user space mapping
> that is supposed to remain cleared, and so the page itself is never
> supposed to be modified.
>
> So make it __ro_after_init rather than __page_aligned_bss: on most
> architectures, this ensures that both the kernel's mapping of it and any
> aliases that are accessible via the kernel direct (linear) map are
> mapped read-only, and cannot be used (inadvertently or maliciously) to
> corrupt the contents of the zero page.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..6ca01ed2a5a4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
>  EXPORT_SYMBOL(zero_page_pfn);
>  
>  #ifndef __HAVE_COLOR_ZERO_PAGE
> -uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
> +uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);
>  EXPORT_SYMBOL(empty_zero_page);
>  
>  struct page *__zero_page __ro_after_init;

