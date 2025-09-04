Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A367CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 13:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3A38E0002; Thu,  4 Sep 2025 09:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A627F8E0001; Thu,  4 Sep 2025 09:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9511D8E0002; Thu,  4 Sep 2025 09:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC378E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:16:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0CC7B6B7F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:16:23 +0000 (UTC)
X-FDA: 83851616646.01.23EDD4D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3A4B21C000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:16:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756991782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCm4CPgUQ2/eBX4S70x/16SGPfY+4q4m0DDNY5SUz7c=;
	b=QhIDG6iZXg9SB25gSb7ZrTmOs2TGNqYSxDQIq7BxUCeGYuWbdNhg15YFJyevoYf5tVpFnP
	4ym1G4mR0pfQ+3RhWYPn83iJXl3QpECqXhZMnKgjJe52Kw7wcVCvOc6UoHr+/O8EPD2D61
	Yy38MHDVvica1bKNy0Sjpxv9czWKA60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756991782; a=rsa-sha256;
	cv=none;
	b=GBd1tuVOSuB5M1itR/ux+d2i/3n8WmbpxQupsxk+JgPd+C4BN7OJC5YUSYx67FwNl3aD4Z
	5DK4ihDxeVAj0jbilmwhxwRwAH5yjXRW+vC2JXO54W7Pb9S5342uDYC89RWx0Z9tS92qXo
	rkF9es+bBYfrSwqbMRxlfYPN1cc5GlE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D1D9F1756;
	Thu,  4 Sep 2025 06:16:12 -0700 (PDT)
Received: from [10.1.37.179] (XHFQ2J9959.cambridge.arm.com [10.1.37.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5EC433F6A8;
	Thu,  4 Sep 2025 06:16:19 -0700 (PDT)
Message-ID: <f8cf1823-1ee9-4935-9293-86f58a9e2224@arm.com>
Date: Thu, 4 Sep 2025 14:16:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
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
 <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
In-Reply-To: <1471ea27-386d-4950-8eaa-8af7acf3c34a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A4B21C000B
X-Stat-Signature: pj3wsw3ednh495sc3rp4zzgejaqty1hf
X-Rspam-User: 
X-HE-Tag: 1756991782-485989
X-HE-Meta: U2FsdGVkX18DgPVEBwjy5F/nEVfBgZhJKTQrxzYyx5j7ydHuwqOZJkvBevBU/Oc0Tu0JoAtP45baity+rZ1YwZN50MvLphzepK8/+64Xh4dCYFPN4+/eXReEXpyycsr8we7K4exEFwCMFQiO+pKuUjtiqTywYAbDfP9Csy94obXzEaF4RMC6p/DlAamM6pmp0G5VT1V5LrUTw+qU6q3baCFIfRvDB0aVS57cjyA4lLTfZQldWOJtZMEWN5MjQC1NeGC3Os1P6reaBdSE7gRgGmzXEOjQL2Y29tc9Q+X/SPoHblndwOqaTkMKeCBqLz7c/lNiPALY6bmqAUaYwENOWzc5rx21WZRWgBwBSTWqlsIo+Xf0kot0sNWVJmBpaESHCTZg0FOojWRFdL7dE0uflLSaHwGxLnCn057CnqWk7HetMAtuCRx2+304jFx2xVj63XkuKvEPu956kGfXnegBd6C7WnEuKNmBQlyeg0De/c264MQQXx3HF3IPad0/pcu/dulmsXYMzwa2qmyfVFH3sO3tFo2ngYxP8Lcx0RIvvcDLN00k597Av7+920Bww04v3CH5k1B847iEKiKBz78oFkfDERGxg5B0zSwnMdPcBhVI/AulXV68/DvVN34MfxU0RGGMjnRn8slPXVTdVawsPd0Fh4yCt8v4QGB57gf7eJJMaFE+4OniJkDj0D8GaKlPEhweZJX7xFUYFd/XSXrHkeViOwCsnj0XoAXyxacoLPQFb/4Mm6Fzy3HzG95BzRAfX6G5YTjhqfU1TGmSulrdYnUhO8QYLsBAH1EY9h6xAbECUwF0efNVNEk/jsK5r8eG6nKiHgVeMB0Kj7wfkFVfOsapX+WUcNRPzK9iYOk/7lxoH1oPLkZufhdhxHyhjc81HxZ0fdsLE391U25L0zWl3oszKgYKe8uKymMwTKEdunjlzDv+721tQfvLJNZ4slDVaKJNDXRp7Z+fL3je9nw
 Im+7/XvR
 FSHH6EZnbJB96r+xPU6+Kgf5IR/IZqll64CAs18HXayN4upWcSjuNdz6uELF+caM2t2K8+iw5vnX3ilH35Z3UM3puzts37Opc4/vpLh+7rv4n8dBvzM1J8sAm7CBl1hV3E7F5krvvQY3/A2TAvF/A+NKWPQVoNyAtEtnLo6zlXz0xeXzShVGOC1S+iVkpDa3jnzHo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/09/2025 14:14, Ryan Roberts wrote:
> On 03/09/2025 01:50, Yang Shi wrote:
>>>>>
>>>>>
>>>>> I am wondering whether we can just have a warn_on_once or something for the
>>>>> case
>>>>> when we fail to allocate a pagetable page. Or, Ryan had
>>>>> suggested in an off-the-list conversation that we can maintain a cache of PTE
>>>>> tables for every PMD block mapping, which will give us
>>>>> the same memory consumption as we do today, but not sure if this is worth it.
>>>>> x86 can already handle splitting but due to the callchains
>>>>> I have described above, it has the same problem, and the code has been working
>>>>> for years :)
>>>> I think it's preferable to avoid having to keep a cache of pgtable memory if we
>>>> can...
>>>
>>> Yes, I agree. We simply don't know how many pages we need to cache, and it
>>> still can't guarantee 100% allocation success.
>>
>> This is wrong... We can know how many pages will be needed for splitting linear
>> mapping to PTEs for the worst case once linear mapping is finalized. But it may
>> require a few hundred megabytes memory to guarantee allocation success. I don't
>> think it is worth for such rare corner case.
> 
> Indeed, we know exactly how much memory we need for pgtables to map the linear
> map by pte - that's exactly what we are doing today. So we _could_ keep a cache.
> We would still get the benefit of improved performance but we would lose the
> benefit of reduced memory.
> 
> I think we need to solve the vm_reset_perms() problem somehow, before we can
> enable this.

Sorry I realise this was not very clear... I am saying I think we need to fix it
somehow. A cache would likely work. But I'd prefer to avoid it if we can find a
better solution.


> 
> Thanks,
> Ryan
> 
>>
>> Thanks,
>> Yang
>>
>>>
>>> Thanks,
>>> Yang
>>>
>>>>
>>>> Thanks,
>>>> Ryan
>>>>
>>>>
>>>
>>
> 


