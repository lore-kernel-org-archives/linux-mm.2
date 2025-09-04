Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFCA5CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444D68E0005; Thu,  4 Sep 2025 09:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C578E0001; Thu,  4 Sep 2025 09:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359338E0005; Thu,  4 Sep 2025 09:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 287438E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:14:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1FD21A01C1
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:14:29 +0000 (UTC)
X-FDA: 83851611858.06.D577D85
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 280BE160007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:14:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756991668; a=rsa-sha256;
	cv=none;
	b=UWbx/lPGZLRWHSR7Sv6IHf/JOnQrxezXdmsdyQrho8tdaXKuVNMdOFV4ZPQMH6iDLtXt7i
	EEx/xvLDHUxDYE4GDYS5DzhjXmIT3CO+PlwzpIp2kahd+JtI5Wcm+uKiWO++VO1kA60hGR
	aYFSNlwHGWZrdNtv08Nchg/0FY9Xwx8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756991668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QsWUbr08LWV6qW6iTx1pxg/iKPxJrNvSVW8td9fB+P4=;
	b=cW0hy9sQD/83hGty01mq9+B58fug5Dyo/4YGKJqIS1HgEgrBgy7ZuPRlMuFMNu0cbbp7IU
	y5nx6+JOUFlcfkPd6ykpyI5VQh4y57gxIMERq5IWFDZ+Eq83dM1d1Ut0wibT08wNemzzo+
	s5IvI1UddzGmlG3wdfCAwt8/ObqXXo4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CC1C1756;
	Thu,  4 Sep 2025 06:14:19 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E55D3F6A8;
	Thu,  4 Sep 2025 06:14:25 -0700 (PDT)
Message-ID: <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
Date: Thu, 4 Sep 2025 14:14:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>, Dev Jain <dev.jain@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <e722e49a-d982-4b58-98f7-6fef3d0a4468@arm.com>
 <dd242f5b-8bbe-48e8-8d5f-be6a835a8841@arm.com>
 <aeb76956-f980-417f-b4e7-fe0503bb5a2b@os.amperecomputing.com>
 <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <612940d2-4c8e-459c-8d7d-4ccec08fce0a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 280BE160007
X-Stat-Signature: m8zo7mw83kccyzzczzbgjthj3xwnwwei
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756991667-400812
X-HE-Meta: U2FsdGVkX1/SnLBaGRGgRC7KczAf5d8ycGEJRYdYtDLp8bhHIfyqqRJMhZ/hfVSU5H4Sl1CTHkzdKOzXSW+8ssWGf78vRlalnsYWU2nkToXtYayWgT3fknpvWk58ZNe6uAmGsCztSeasOpy2teSOKzptFhCOVTLe00qFK4O4Oq18CAozVlIxtk4e0ik33HcEHyYXpZMGIGp70Ok5IahCKRISXTUNgIeujUac5OHnZkRcbcHU3KN8tAcEAhRkxasaYbVA/Y+5xBaDF/7Wprm1yrHCzKVo2cNW12MPXG3xoTZ5bnC8bdcnOFpuzd31j0EJQ0gdVQwwW6yEJVo+S/KbsW26MONjLCs3+EhOfNjYVXUUdP80sO1uGkevUuf7p5h9lzWDQo9IW5SHgTYZkI0Ui+qp+m1udG5oM5Wdq3TG8uS7L8qfan+4cGsaQAfq5rC6jH4h9NSJALgm+e2TggLBQS9+YeKVeWV+6L8SeMUv8PAev/2nxZzi0BGlR+GPTgqdGOYChGeiJ8uTVx3HrUvxb5XJ0mZNBpix+j+JyBKfG4MXGv7vds7QA28V4grURBIAGnjXfPBse39oex5jr6YUIQi/8FG82UByp546sP9H6tTnIeWbPK54og39402gLT+TfT4u0zvri/+bA0J+jkTAZTe3ED9Qn+1tt4ZDh0DUfPJbzCnaOxu/4dqYt500z5u4s0MsJDwaJpRx2f9GwjNhNS4vayw1pNtxB/L98Sa0QMYnxHjBe73zxhP7S+Qs987jUatFFFWPvFnaV1PAteipDI6GFZt9yH+XgsrpH3ti6HX/WktCJiFzIr+/3leeHB7HnlVVeANq6envaKIDJF8pY3a0yqKjGELfQCv+/a0Ujoc07y6yuW+llSvS8N3buk/AUr6tcU2nJ1w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2025 01:50, Yang Shi wrote:
>>>>
>>>>
>>>> I am wondering whether we can just have a warn_on_once or something for the
>>>> case
>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>> suggested in an off-the-list conversation that we can maintain a cache of PTE
>>>> tables for every PMD block mapping, which will give us
>>>> the same memory consumption as we do today, but not sure if this is worth it.
>>>> x86 can already handle splitting but due to the callchains
>>>> I have described above, it has the same problem, and the code has been working
>>>> for years :)
>>> I think it's preferable to avoid having to keep a cache of pgtable memory if we
>>> can...
>>
>> Yes, I agree. We simply don't know how many pages we need to cache, and it
>> still can't guarantee 100% allocation success.
> 
> This is wrong... We can know how many pages will be needed for splitting linear
> mapping to PTEs for the worst case once linear mapping is finalized. But it may
> require a few hundred megabytes memory to guarantee allocation success. I don't
> think it is worth for such rare corner case.

Indeed, we know exactly how much memory we need for pgtables to map the linear
map by pte - that's exactly what we are doing today. So we _could_ keep a cache.
We would still get the benefit of improved performance but we would lose the
benefit of reduced memory.

I think we need to solve the vm_reset_perms() problem somehow, before we can
enable this.

Thanks,
Ryan

> 
> Thanks,
> Yang
> 
>>
>> Thanks,
>> Yang
>>
>>>
>>> Thanks,
>>> Ryan
>>>
>>>
>>
> 


