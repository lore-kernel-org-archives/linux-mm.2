Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A5CCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 17:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008996B0005; Fri, 15 May 2026 13:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB316B0088; Fri, 15 May 2026 13:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11646B008C; Fri, 15 May 2026 13:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D202C6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:14:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96F391C007F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:50:55 +0000 (UTC)
X-FDA: 84770243670.06.2782B17
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id D98E240005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:50:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m3j21Fnp;
	spf=pass (imf12.hostedemail.com: domain of 3604HaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3604HaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778863854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WrDxP0O6KbYVHtNSanPgjGhWRqCYk00NUEI+G+9ODI=;
	b=YaQEtuz1xkRGaVJwBNTzcoUDuZ2A5GXCQjSyUJ+TzmxiiFMEk0q2iVMTOEE9lnsXnLLq8e
	zii3Kdg+uCWDmsrRYFHJ4yous9Ih+/OQkQ2iDdEBatPcUZcswm8ecb5WSFiW/h4TaB+tGD
	lk3RSWe4zBNSfL0VNqruGzsvS6j3Hz8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m3j21Fnp;
	spf=pass (imf12.hostedemail.com: domain of 3604HaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3604HaggKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778863854; a=rsa-sha256;
	cv=none;
	b=mzmSltxSvNZn0FOJuunMWfL9wgZIjMqlNTPZeqQKWvOU2WMLFPzSG4HUCwZx4ZNzWr4v2S
	eUy65v+Mn5LCKxgGw4qkEng92XS1tQYSX+IFVOQ1XkUlho6hWdtLlFo4D73AarWsWd/Ra5
	ZuZTJN0jsDrmkTf4l2PYfAmttPwwrVw=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-680ff5fbf99so33255a12.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 09:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778863852; x=1779468652; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6WrDxP0O6KbYVHtNSanPgjGhWRqCYk00NUEI+G+9ODI=;
        b=m3j21Fnp5eflONZhQ09X14DTn4SDuWwVK6wmvakCAUWPk7LTFXn4GuEWeXt6Md3o25
         428XqHfZ3ovKmw54a/j5D2erd803OqpDyWls6xUGVDdoYjlPbIBItrbQfb8quVk7GrpK
         VTsV0XkM38K8dNiU22dFfsuMA+PGfJ+hxz72+NQhH4cmyqwWiLM7vg1qx8klFHu3IXeD
         7gY6b6n7qnphGvzfstO6vUUFSqNDniBiYc44w0e/JLiW9PD76egjw2cBaqj8SjhVY78G
         vp3qd6lgq1RHYHmsUxBsUYeMW0pMT0c2pdvst2EQmd3JU2bgJdvhTWErpJ0f/jF+pL48
         2mIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778863852; x=1779468652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6WrDxP0O6KbYVHtNSanPgjGhWRqCYk00NUEI+G+9ODI=;
        b=JxqQ9wc1RnEKxGng/LwyvAwNirHty3skhDH2TUqifpDRgA7WOOCMYmdxsQ+JAIS5pC
         sbULk/kGMdPGomxnXuGYQV2I3yBRIK4rOHboOwmM1xfEyQJcrZh/TPMd0IXllT6U3DVt
         0mzrsCKB5TWaC7Y6g+y1D2pb++d3K7rGqGKGTTsMrWtFNBX2hUiXGj6F5BKXx7GJEgQk
         vxcRJfL+k6DvSALkx+NaStvLKBeYxLVYNH9xHLXrOVaXQXxk1g3N0RxxTwHqV46+LdQr
         eHuN0spQzdkWA3I6touA0P0ZBqf7YF3pNnjFwY8uM2k5q4/1agXVRWSbTFUpixEEicQA
         /tvw==
X-Gm-Message-State: AOJu0Yx24y8TJLhzZhrOAA2ZTFLtJDm56DehYugDp+Ca0m4AwTPoQmXl
	Wfx3Z/B3VVXLqiDJ/nFF8za2IxBPm6IitgWtlh1GqVK6GqI9STUGuEw797t8ELEv8sfERWVwjXA
	nga2jAMNnqF9CWg==
X-Received: from edim4.prod.google.com ([2002:a50:cc04:0:b0:674:91ac:5f8d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3251:b0:67b:d0e3:771d with SMTP id 4fb4d7f45d1cf-683bc5bdb15mr1846715a12.7.1778863851966;
 Fri, 15 May 2026 09:50:51 -0700 (PDT)
Date: Fri, 15 May 2026 16:50:51 +0000
In-Reply-To: <3453825f-2bc0-4d63-8731-3eaf9fc716a4@kernel.org>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com> <3453825f-2bc0-4d63-8731-3eaf9fc716a4@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIJELVS3UK3G.AVIQMWBN2WVS@google.com>
Subject: Re: [PATCH v2 20/22] mm/page_alloc: implement __GFP_UNMAPPED|__GFP_ZERO
 allocations
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	<patrick.roy@linux.dev>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D98E240005
X-Rspamd-Server: rspam06
X-Stat-Signature: rud6ntb3fzxumsjp3wukf1zmwuzb1hpr
X-HE-Tag: 1778863853-942871
X-HE-Meta: U2FsdGVkX18jbrioal3iHIySg/EtPYhP1Ymw4twIa+AQuqhCpTrQARoTqbEdjMky4zYtJK2B/8T9KmUob3HAeBe5bQuMERtOJhcpyNwx0M+704XbOumgp723QCELhxsussy/gpiBnMPp7GzccIuZglZswVBZqKJJxhSdijJBq3AQFPDVJX/iuyw7uMm0w9Es68V32CH+fpPgP6BwgnAQ39rn19OvesbTlARUqdJC8jPfPxPyxYlXi/F7oJX4dc8fNBc4VjujVFtGbJdD8ukkgthIG9dLYoaLaZotJ55nFJdW63YdqNUjETBRByVwiohSZgnzNnAtYaKHEO9xV+t4q1Gh/bxXW5GmVw8pZ8djfKtkZD77OVZrbKTwXGNp2ID9BP79UsfjejqwyU8YjXBn16wlH4O2PTnQiHl2ReNh1tayMyu5wEu3aeLFpomChXnMnue8kf7/Qny0nsyzTEw8pMAF4/teER7/fMoeJdWX+tYdjTbwvmlvb8CWaldSyCFmdkCOQJjTqAB3dMzoLhQrV0AtegIdjhye2NvsdmsNAz7Rthpe1JpIKepqGKTSAK01RE01uqAm8EGqiyURQ13XD+fICBLHzXg3/oj5r96mEq7KiCaIwN8h3v+t57CkSouiGddMtoiO4M+PXKGlm787AdxOxH8+zTFoKCoY2lfUHop8HmOKpOeN5GWAqRwXaTHQjbjmCPLO7zZm4D2uIDFr+8LvCtIFKhCHfqLuYPyN1Bf5qz4jpW32Txwz4knREa6i5+jO7wK4gcBMYlYRJ64J8W/SSG60ctN7kz+8mHtNTnxUBbCNlrXN+5Slp8XueM4EnSf0fokaMik4CC7iZ+tUKlwSPWepJSeDcnD+ZA8vqfGYrw58UA57fQJ4XVuavjvxvILLv/8AB3fdYfNp9xa0jj1yFrU/5FhwYXGQY5wkO85HjsgZtyw4MOX1m7ze9J5gKRVjsi2z1W8VlL0gCOL
 EQDYZBlP
 4m2+u8BBynRn7GQwmgRxxQfYmBTTYLQKIMkwzZE9XsS9G+3GJ+sTt5UZHayfjRGuB5Gg+V8Ga3/6CDalKjmw/4I+Fs7cGwyaQuIU6g5DfItSgM1Gqoi/B4zF5w9v71E3+aMrAmeF8UpmyGswxN2Lgmtpn66vxpKXmmauaJqcufc20ppAiFbblo7x4bpij6TNVM9NlWWNv5b6CEid3MeLIuj6jTiz3KGGjsCjTOhM6DDb34PJ3HBYFa1XZeXeMXrjAUrMF5vzkwgl/hNXotr6tLN4M2c8XiH87HuTIfBoo8inpzoFmny7/A3PbsCRSF9/mG+MYxh7LZlrudEdqB08sX7KycQWDsHPhHISk9wQGqpDVlyPrv/vKoflud2x+w0nsrJZsEF3J09jVZg/O5uE/TPuLlrVClTNnwbsqVJ8HUeDXMpEkHi4+uvCZ/G7I93uEAKR31vF0dyNjJRkDQM/j45gMwU/bEfab9sF3gFVO/F3u0nGNlSE5wwgwBeiwPQcqmfTut/eoP2dF4oZkvWqt6bWdeS6Zq4wn+Y7LKOD+iBxDu+Ryeam2IQaL0745CA9UjfRoEhrdKF9DTWpEbqmi5di+N9tAMoNgqrsnxOdoDwPR0fVhZ5Haa974SHFGqgz4i8SbixgMmCrqD/bBhTlmYvZ3MjjMM3OZVPADlSZPr7Uzlb+uvvf98JTzzA/mJjNmzzhXTDwyiHERFNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 13, 2026 at 5:00 PM UTC, Vlastimil Babka (SUSE) wrote:
>>  #define PAGE_KERNEL		__pgprot_mask(__PAGE_KERNEL            | _ENC)
>> +#define PAGE_KERNEL_NOGLOBAL	__pgprot_mask(__PAGE_KERNEL_NOGLOBAL   | _ENC)
>>  #define PAGE_KERNEL_NOENC	__pgprot_mask(__PAGE_KERNEL            |    0)
>>  #define PAGE_KERNEL_RO		__pgprot_mask(__PAGE_KERNEL_RO         | _ENC)
>>  #define PAGE_KERNEL_EXEC	__pgprot_mask(__PAGE_KERNEL_EXEC       | _ENC)
>
> Should this be part of earlier mermap x86 patches?

Maybe it could be in the patch that implements
arch_mermap_pgprot_allowed()? This is the first patch that actually uses
PAGE_KERNEL_NOGLOBAL though since mermap code just cares that you didn't
set _PAGE_GLOBAL.

>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index e4cb52149acad..05b2bb841d0e0 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1506,7 +1506,14 @@ config MERMAP_KUNIT_TEST
>>  	  If unsure, say N.
>>  
>>  config PAGE_ALLOC_UNMAPPED
>> -	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
>> -	default COMPILE_TEST
>> +	bool "Support allocating pages that aren't in the direct map"
>> +	depends on MERMAP
>> +
>> +config PAGE_ALLOC_KUNIT_TESTS
>> +	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
>> +	depends on KUNIT
>> +	default KUNIT_ALL_TESTS
>> +	help
>> +	  Builds KUnit tests for the page allocator.
>
> This belongs to the next patch?

Oops, thanks.


