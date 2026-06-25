Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73CCCDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41A36B00F8; Thu, 25 Jun 2026 07:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18CA6B00FA; Thu, 25 Jun 2026 07:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30366B00FB; Thu, 25 Jun 2026 07:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE616B00F8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:21:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A4AA1675C4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:21:31 +0000 (UTC)
X-FDA: 84918194382.09.F1EC713
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A848100015
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:21:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hR+WW9gI;
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782386488;
	b=v3aiTksI35dEZGIB7BXVPuiPnMCJtnHq15gxhQH/wGN7Pef8Ja67XsqfKsJZD63G/eVEuu
	Q8ssqk5s8VCc96wkVV3v2VicJRq15PrHr5JjXGC55C/sN32aeWviB5cFkd+Q+oe6zAZc24
	Rd5dlE48tBn8DEqBE3zf04zhacAMgGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782386488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAMw0WFN0U7V7evmhPHKbIT2IAgGFjbUT+BVVUGge8s=;
	b=Xky7Jgvc3kAUGfKmC4K08fzb4Gof110lmRKbFvZpswyoLUHPxqw/avq+q98ON+MMJa5anr
	ZRfxEqS1hF3egGNVR/rluyfccGyB/fqYL9h2/YLImx60OCRYEBYQZZUzAaZRQ8koxZqyiZ
	HxQvrVUECLva97jHSXCDqpPovgJMsY0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hR+WW9gI;
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jAMw0WFN0U7V7evmhPHKbIT2IAgGFjbUT+BVVUGge8s=;
	b=hR+WW9gIb2huIy52YgGEmqoLuxHxrNZZonc+KFdrPEaVQfA/Qs6wt/AFrpiR83W0fgJl/XLso
	9tvdrHNOJ/Ymn71n6+5W/i7uJX+q2ob+4Yn+2DyhENl6zM9UBfY63X9PDqTytVIPDy0y7V8Bncp
	2DhvKCLCHg2b8yxFH5gntv4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gmGNc2zVczLlVM;
	Thu, 25 Jun 2026 19:12:16 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B38C40565;
	Thu, 25 Jun 2026 19:21:22 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 25 Jun
 2026 19:21:21 +0800
Message-ID: <c9ddee42-143a-4957-adf1-b302504a14cc@huawei.com>
Date: Thu, 25 Jun 2026 19:21:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ziy@nvidia.com>, <luizcap@redhat.com>, <willy@infradead.org>,
	<linmiaohe@huawei.com>, <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260622091539.836531-1-tujinjiang@huawei.com>
 <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
 <601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
 <6e39171c-8333-463d-9ea6-db331965d2c4@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <6e39171c-8333-463d-9ea6-db331965d2c4@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 0A848100015
X-Stat-Signature: h568wx9zqaehiwdcg1um4w43o8i8arid
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782386486-856116
X-HE-Meta: U2FsdGVkX186rN65KfD6Q8fpl4xX2P3TTA5irJcal0+cK/7JbKn8c9hOAnc+/RZdjaPy7/RrwA+Iysp1PutUx12PXsZ8D1FIi5BhbBLpbnwrZQKtTe6ztqFqMFypDLtmkLH40bKzh7pL517ZfeedXr47uzP2JP+bLHjWvB4vsntlvpYDI3E/imIbeTd5KkaHBm25ljmSk3WPoeONlBZ6/UN+lVbhZlnF8L2lop1aMpP+XWyNtE4WFNo9p/GMigRcCW/Q/SxBhZaeEle0QJz0j1WNvxNiQc5S4px+3W9QA/sby1GLZzwoYEa8R1XeConRTH2k0BHvPU8+FFBZ63H22Sx1A/XeCKY+M0GnPftDHzg/g4CWfBcSlENZoxFMrLJNn94fWupCCO2dVDCzY3S8fUUvNfxrRo6GytYAVHmbcSjbqhX9XkI3SElrArE7SeE/72KwJeYQD9NoYixrbtGgdM2WZAMlNJhfruG0u9vmNWWTbfLJUnlWqb1zXfG7eMpPNrLr0ZydL0hqjpmPZsorYMHLVtlpOraIslllG5sELSbv//7Zzw5Y8rMWoG74fbxHPh5tTU2qZA7NyLZY0jjsepizldCIFT6JgygpSSzHCd6jL00rMIPFgznALU//U3hzWcVtnbNDIflwCeJDgeHMFQshjX5pZTInvdYzAmdgJkve/zKEc7e3T1nt5JZRvfo9rKYxch2PIzpRy4aZLKxYPnMJ3th7EKt6Ozme7Si6R5a1e9NaOUHqbZiVzo/BmUIP/V3yj9XHH5iHyNR1sU4EITRXkdYo3T8upQB/LipRXrrRUw0fp2+hcTxNdoUVfVdrw47WRKiWgRlLcCBM9GpJInxgbQyi6GK7ILLxds+iCT9OJDpD+3vvcSRaItNrOtLT/mL4htnp/jEVzdnOK9QysnwiNsQW4jwEgaFMjY6WM0FxTEPqnDNYTFTN0AOxor35bWeElSQ4EnWedKdm+Dz
 gDVA51iM
 uO8B1MZ+f+DrBk7nulg7XXviB+Sd3G5liOXS+63JyXBVJQj4gU2oamFFBmiTWKBKgn8dMscdLJf3YaDIXaRWpX1nHlWXpVKyUOOdkv3yFg09JwcO9vwPl+wJ1tpzPN3MjkW2u5AIFjj2ahwTy3IQwrq9S1qBwUe+iuyT+5rGeEiJhnS7FH6yj7AgPY0kfG4YSOtaGNFa1GGKHi39/DnkFAyBfZBrCPkmgRltDrJvQ2USC5Oy8NCWopjXTO73CivZEnkXDA2xZsAoY8X8O2lyHvMTT1CV4S8rhDeVSXlJKZeYbzGPUMHeSfTMMtqLzUfhbAp8/7iSFPrMhhgoUxAb4qYU6yQ1dwCnOusrvWd6+gpHxo3cDfrYdnatk/rboRIVWtwkjGMhqQdtNc4gaIgHiAalDnw2SLLGGFr5e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/25 14:39, David Hildenbrand (Arm) 写道:
> On 6/23/26 03:37, Jinjiang Tu wrote:
>> 在 2026/6/22 19:45, David Hildenbrand (Arm) 写道:
>>> On 6/22/26 11:15, Jinjiang Tu wrote:
>>>> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
>>>> when KSM is not in use. As a result, tools misclassify all anonymous pages
>>>> as KSM merged.
>>>>
>>>> In stable_page_flags(), if the page is anonymous, then use (mapping &
>>>> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
>>>> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
>>>> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
>>>>
>>>> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>>>>
>>>> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
>>> Right,
>>>
>>> #define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_ANON_KSM)
>>>
>>> Which we later renamed to FOLIO_MAPPING_KSM.
>>>
>>>
>>> Before switching to manual flag checks, PageKsm() translated to folio_test_ksm()
>>> that checked whether the values actually matched:
>>>
>>> ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_KSM;
>>>
>>>
>>> This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
>>> interface), so it's not really that relevant for real workloads (debugging and
>>> testing).
>>>
>>> So not sure whether we should CC:stable. Likely not.
>> /proc/kpageflags is generally used only for analysis and is unlikely to be
>> used in production environments. I found this issue due to I was analyzing
>> pfns allocated by which stacks are KSM-merged. So I think it's unnecessary
>> to CC:stable.
>>
>>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>>> ---
>>>>    fs/proc/page.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>>>> index f9b2c2c906cd..cef8ded97610 100644
>>>> --- a/fs/proc/page.c
>>>> +++ b/fs/proc/page.c
>>>> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>>>>            u |= 1 << KPF_MMAP;
>>>>        if (is_anon) {
>>>>            u |= 1 << KPF_ANON;
>>>> -        if (mapping & FOLIO_MAPPING_KSM)
>>>> +        if (mapping & FOLIO_MAPPING_ANON_KSM)
>>> Wonder whether we should just do
>>>
>>>          if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>>>
>>> To match what we have in folio_test_ksm.
>>>
>>> (although I doubt we would reuse this flag for other purposes, likely
>>> it's more future proof to check it like that)
>> Both are ok. The following check has checked FOLIO_MAPPING_ANON,
>>
>>      if (is_anon) {
>>          if (mapping & FOLIO_MAPPING_ANON_KSM)
>>      }
>>
>> So it's equivalent to do
>>      if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>> or
>>      if (mapping & FOLIO_MAPPING_ANON_KSM)
> As I said, matching precisely what we have in folio_test_ksm() is clearer. We
> don't have any users of FOLIO_MAPPING_ANON_KSM outside of page-flags.h for a
> reason :)

Indeed, I will send v2.

>

