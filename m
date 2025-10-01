Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83735CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CC88E0005; Wed,  1 Oct 2025 00:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD918E0002; Wed,  1 Oct 2025 00:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCEB8E0005; Wed,  1 Oct 2025 00:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6168E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:23:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEBD21A08E1
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:23:36 +0000 (UTC)
X-FDA: 83948251632.01.D1DF44E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3748120008
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:23:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759292615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oufO/qxtKuBhIvvH4o1hco84voWMHFT5FnkmWTKSNDU=;
	b=IiIzKMJrNmy7SmnDv5SowQ/b/yYBdMUiq/Ran0KWva1lGm1uHQZDZN5HLfr4E0oSK7zHMG
	rYwAulQVdsoL99b1S86YtbyrmXTWWvG+ZyHQ5aLGHKL474iSeSWLIihgxJaotk90cmuhHC
	LRGr+ZEtV6H5YxIOg9ZvlO4p3XCa76I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759292615; a=rsa-sha256;
	cv=none;
	b=Ul9OAQ9ygqNGwEuw4yn02q55rAzBSjw12mFTDCZbsnsgrK4VWCD5JsqKRO8p2Yle9GaGJt
	/TzJvS3gufb9lrwqIJKnEef6MGoLAMBgBy/JodAzZOOmxDay/yd8OtjlVmJDAwIunGd7Cf
	DNFEEsm2sfCnC+17yvuoTN0F6sF84T8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6D8F16F2;
	Tue, 30 Sep 2025 21:23:25 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B29623F66E;
	Tue, 30 Sep 2025 21:23:29 -0700 (PDT)
Message-ID: <746c4dd3-2285-4353-9e15-a0a2fbd4e6b5@arm.com>
Date: Wed, 1 Oct 2025 09:53:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] mm: hugetlb: avoid soft lockup when mprotect to large
 memory area
To: Yang Shi <yang@os.amperecomputing.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@redhat.com, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, anshuman.khandual@arm.com,
 carl@os.amperecomputing.com, cl@gentwo.org
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250929202402.1663290-1-yang@os.amperecomputing.com>
 <cc40d827-3b98-4e15-ad45-5c2033e4ce20@arm.com>
 <6cde8290-3aa2-411c-bf29-eb91a99e33a5@os.amperecomputing.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <6cde8290-3aa2-411c-bf29-eb91a99e33a5@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3748120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i1tz7tjqm14koqkzncrjxnjppucxseo8
X-HE-Tag: 1759292614-47134
X-HE-Meta: U2FsdGVkX19o237ei1rm98jlD3RdtVGicsT2zMwzINWywZL4u5Ci2UpeWfd5kpwtRTbz8ss9tvhidtGiuMEJJD75BWJrtsGTB1UL/XRpNboAS1lYBqLCdDYN9sfyx8zg9p1V6rbUdxctGXdPJVlZNj4ooh2+keptx+7oO+7YKHwmGBwAD/xEcTB2u3lT1fKz5n1c5nAvJx0qf7+gmpkxBjHj34HhmEXsXF323+rDnv8dJjdbwwyGw1TIm0BSXQhhHf58zMtkUJ5qyvd1M0diVs4SeMcU7A+dFHOEhMchYBNG7irWOw6tcwwy3ljaZwjLklt6eUFrSSIjUY3JJuHWd/509a/tFnTdTqtpRZsypQ2So0XciVTp2jIMjGpdrsCbx3M/4sRUG3Y/a2LIDFkyJ5N/fzvrG8wMwn69p1lIlK+KME5MTJdHsFoHAsG1paF9zp1F6NoIBLhAhT+32/7OKB+pp7rObaQMukPXOFQ2fPkwLKl9ZuqmKd6+Zgeyil/pAlsaB5AtaTVnbib4lLzSoyOihXGccn4fbm+3iOnhUzu/vQKIKE7Vxg2ndNIc297o8eCbogJ4CiLAxm3YWZ4ucohr5vSHhEgQBsmjrJVuo7nCd0StGq+OeO6AFUt3T64nc1s4yWtmPCBpzlp9p/Iid5CtsaZh0gakYdMAtHNnAVJskJPKz/7yRfa1UfT4HjwO94rRz+5fth+mom/Y6XAFyNNodxCqvHM0T2sWCtYA8MWzMkQs0xL5vxNdi05SUx8hPyG6NTopSAdroZ0K3Xug225VG26EuSxUGTZM3zSca0EpR6FacnbTrbZFqBwpQKhcl9TDEtasP4norL8zBZ7ENyaWhZxn44584c/y6OYwHoH5om5pmvAooNMNtAd2kcSFgCVTPbxMtnf/69TkoU5IoWpBfJTMYDlW9mNEGdXaHMwIRF3Z2wjNZMofmB6CFuBArr6B2rWbpwb0C7Gf2Po
 EcF4unPh
 XYYumL/TLX6HGc8DbV7301iei125mnYZ8amn/a+uBLTVI8v/7f1FSV1mPBFYyQSiFKAUkC92SAgxuveJIaDbpxZd5N03s26y+b4bWFiCU8TyaVDx6GJFsgyN5JLuRJkx+OiT+aB+2pfW9lZND8pnkCoPrE6EMUsbxeSGb7b31okGxzL5ZBEZTZEvOw4khepCs2DSekwbcI7QmAAbHnxIJTGvk5DNUJyk+dxU+EV1gu/t2MXc7KL6HeAN5hxk1h7shEiMyWKN5YcM35PB7VAq2x8gxmlNIxC3Tr3WTRP+toTuicN0pccqmdwireZINV4yTPVfFiBV/4qR44UfnFbBKSDbh70SA7E2phzpnLSXw2GqPm72z8Xz9lqH1Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30/09/25 11:38 pm, Yang Shi wrote:
>
>
> On 9/29/25 10:26 PM, Dev Jain wrote:
>>
>> On 30/09/25 1:54 am, Yang Shi wrote:
>>> When calling mprotect() to a large hugetlb memory area in our 
>>> customer's
>>> workload (~300GB hugetlb memory), soft lockup was observed:
>>>
>>> watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]
>>>
>>> CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 
>>> 6.17-rc7
>>> Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 
>>> 5.4.4.1 07/15/2025
>>> pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>> pc : mte_clear_page_tags+0x14/0x24
>>> lr : mte_sync_tags+0x1c0/0x240
>>> sp : ffff80003150bb80
>>> x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
>>> x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
>>> x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
>>> x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
>>> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>>> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
>>> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
>>> x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
>>> x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000
>>>
>>> Call trace:
>>>    mte_clear_page_tags+0x14/0x24
>>>    set_huge_pte_at+0x25c/0x280
>>>    hugetlb_change_protection+0x220/0x430
>>>    change_protection+0x5c/0x8c
>>>    mprotect_fixup+0x10c/0x294
>>>    do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>>>    __arm64_sys_mprotect+0x24/0x44
>>>    invoke_syscall+0x50/0x160
>>>    el0_svc_common+0x48/0x144
>>>    do_el0_svc+0x30/0xe0
>>>    el0_svc+0x30/0xf0
>>>    el0t_64_sync_handler+0xc4/0x148
>>>    el0t_64_sync+0x1a4/0x1a8
>>>
>>> Soft lockup is not triggered with THP or base page because there is
>>> cond_resched() called for each PMD size.
>>>
>>> Although the soft lockup was triggered by MTE, it should be not MTE
>>> specific. The other processing which takes long time in the loop may
>>> trigger soft lockup too.
>>>
>>> So add cond_resched() for hugetlb to avoid soft lockup.
>>>
>>> Fixes: 8f860591ffb2 ("[PATCH] Enable mprotect on huge pages")
>>> Tested-by: Carl Worth <carl@os.amperecomputing.com>
>>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>>> ---
>>> v2: - Made the subject and commit message less MTE specific and fixed
>>>        the fixes tag.
>>>      - Collected all R-bs and A-bs.
>>>
>>>   mm/hugetlb.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index cb5c4e79e0b8..fe6606d91b31 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct 
>>> vm_area_struct *vma,
>>>                           psize);
>>>           }
>>>           spin_unlock(ptl);
>>> +
>>> +        cond_resched();
>>>       }
>>>       /*
>>>        * Must flush TLB before releasing i_mmap_rwsem: x86's 
>>> huge_pmd_unshare
>>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>
> Thank you.
>
>>
>> Does it make sense to also do cond_resched() in the 
>> huge_pmd_unshare() branch?
>> That also amounts to clearing a page. And I can see for example, 
>> zap_huge_pmd()
>> and change_huge_pmd() consume a cond_resched().
>
> Thanks for raising this. I did think about it. But I didn't convince 
> myself because shared pmd should be not that common IMHO (If I'm 
> wrong, please feel free to correct me). At least PMD can't be shared 
> if the memory is tagged IIRC. So I'd like to keep the patch minimal 
> for now and defer adding cond_resched() until it is hit by some real 
> life workload.

If we have large swathes of hugetlb memory like in your workload, and it 
is MAP_SHARED, then there should be high chances of sharing the PMD. 
Although, I incorrectly

observed that we are clearing a page there - we are only clearing the 
pud entry which is 8 bytes. So yes a soft lockup should be highly 
unlikely. But since cond_resched()

is cheap (I assume this is the case since it is liberally sprinkled all 
over the codebase) I think we should be consistent. Probably not an 
immediate concern and not a matter

of this patch.


>
> Yang
>
>

