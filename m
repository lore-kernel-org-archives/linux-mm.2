Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E67CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 05:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089BF8E0008; Sat,  4 Oct 2025 01:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24A48E0002; Sat,  4 Oct 2025 01:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13748E0008; Sat,  4 Oct 2025 01:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC0768E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 01:24:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B65C8827E
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:24:44 +0000 (UTC)
X-FDA: 83959292088.22.3D8334C
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31243A0007
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:24:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tznUARli;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759555482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krAO9cVScKxnq0tyI21OqQImIBgM9hOhnJCkOerMbok=;
	b=ohrHSB0gijBtgPBLaYRORC/goN0YL0A1x1kVOq/GyTtAGKaNTHlqHxUAxC8q23yJJ26q0I
	sVOpOfQQ288LjdbYqzr/Oji4Fs7qgIpp6fd3068ps/z00LON7nFNedC+gLEqut7s8ezYIy
	vFTlVvzRWarX4QLq0tSNlnyu5aBokt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759555482; a=rsa-sha256;
	cv=none;
	b=YB/LYxq+Qd1l1lC1GjgAVNy+il/Tom0xpIdselB1NY51KiUDScizr6zwkQu3Tydh4l5Df7
	wuyJd81ZySCNopyvqwz9eiBFvtu15WqUzDdQ7YPDlSzkxnoTSC3RVMUj3uGOJEDtFoS+oI
	XOkvafQMlLUmcQbeWqPNF+inJiXEOis=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tznUARli;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <44d529b6-a538-4131-a00c-76c73ae49d81@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759555479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krAO9cVScKxnq0tyI21OqQImIBgM9hOhnJCkOerMbok=;
	b=tznUARlix33V/Dh3vG3SYEpL/6iSYMloakXilkcJK1RXFcZIt7XmtZmPg7g5vaZJ5JIGmq
	WVK0w2XjqPTyPZXmj0Z21rALpyCwCONyy3Iw38WXM59xn6dr7/qJNZ+v6ms0nXq6PFTKhY
	KrMKMWysn1CU2uBhQVS0ZP87yDHGPeg=
Date: Sat, 4 Oct 2025 13:24:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, david@redhat.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, akpm@linux-foundation.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
 <a36c9776-d158-4add-86d0-c41a09e4a255@linux.dev>
 <f9f62e40-92a6-4ee8-aba0-6bb9b2929f41@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f9f62e40-92a6-4ee8-aba0-6bb9b2929f41@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31243A0007
X-Stat-Signature: 5e7kxp73947aeue41eoac4nesp8t9pfm
X-Rspam-User: 
X-HE-Tag: 1759555481-433849
X-HE-Meta: U2FsdGVkX1/7ID++qou0mk2mCGuTMruWrkNGKqh21HJWE+zUAll9QlDP7V1dOd2A549yGOgoXhZCYmDzRlysj5F0e+RNAw9DZ8V7+mVr6X1Lki1vwvRhYLasY2/b9/unQx4WKA1tiLDkFUs4jYnk2Fx0WrYBkscE5ILfUJppbtTnjpjP0lkcgYZu7mgGPNOj7JHCxxZHLdg+DporWg1uCV3SmBSg/RAak2g0Lk+VlBRPcTx3pshTa4l+vmidD7CA0ylomXA4/08L4x1sLnQI8S6pBVWHTfvLR/DsGqNZ1fXITlHboCThHk6qRgorjpLdWTNOY2jbHRKYBokcNrg7BL+NyoKh9o2mt8Ti5w2AmbClhvrytDUOFMxSjRKh+FQtWkoQrwoGiShH8MCkb2d7SPKLpsVFX3RzS0SjiXbf+E9wx2DXOh2ST8wUo7eMYAXYd9Cg7IWUEdeb/NdfquwGbQEkZwodNtU0ikHEpXhhQQwBEaEl/ZBK5bNlZngVAvDoV46GuhOpyKGvqj+0P/6hvmZTg82UMDkQcsnk9NfNmP5CaYgmo235iGhaVGh91hrDOtQyz2ZvtRlf8b8+KwhOhzhKSWhbWfd2Ju8eVYc3R93CuHzZg3mij+kZ27/4SX1RzLfyN5vXSeMjDfMprEMLzNi3JL71NpfxPFueH8YbuBH5K5V43MtfNdOkkmz5tA3xo921tB5t47v0i3EzA/0fjZCwNruFJOFiLz5cLx+2t4d1kTPjx34UJqmqtOdGpk8om6gYC3W1PQOT22r7otYzTw5mh7ixdS+SbIjufHFlECyIxVUifCJCifXoZGi6hrpZcNMxlgN0FrISXOXrBoFbmzViFaCG2BXEj9peLVZJ9AWNQdfl2YFmSMez752uNUrg5QxJeDOVpx0EXUr+7HRsIufpGNHYZ3aicpPRSA3/UtQQ1iSTZ9WgwkzPAwlIjN0RwjOFOtcjwN+Xe+Et7uZ
 gvV5ttRf
 AFAS84CXaBgVR650kjHGePQ60i1Te63JRh/L8jahXD9rK06WB4HyTJZqYJ3EVL1SwTGjL8HtF6isjFC+Oot2k5QsFe95onMGP5kxNxHouf3sorJhCIrn3QiLyj+F7HOUKgLlgIOXk/EPIqLvaYjCnbHCd//OUGNGrsGuB+9Una1aymGQPRkayuYYVj91ptjVg30t2kwel+ACG+cqi4e7kKCFnYFHzTiFwJ0yyecYyLj0WGogQtPjp1x6YFu6WxaGPOmixcWU9axPpf2rLzJwzHZf0TLz5sL97mA4ZwDHjvKHi6id51haIX+ofbWV2fRyrnOTDzVOTHcjv40o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/4 12:42, Dev Jain wrote:
> 
> On 04/10/25 8:33 am, Lance Yang wrote:
>>
>>
>> On 2025/10/4 01:05, Dev Jain wrote:
>>>
>>> On 02/10/25 1:02 pm, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>>>> and __collapse_huge_page_isolate() was almost duplicated.
>>>>
>>>> This patch cleans things up by moving all the common PTE checking logic
>>>> into a new shared helper, thp_collapse_check_pte().
>>>>
>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>
>>> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
>>> an anonymous vma, is it even possible to hit if (! 
>>> folio_test_anon(folio))?
>>
>> Ah, indeed :)
>>
>>> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>>> till the folio_maybe_mapped_shared() block?
>>
>> So you meant something like this:
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 2a897cfb1d03..ef87d7fe3d50 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1374,11 +1374,7 @@ static int hpage_collapse_scan_pmd(struct 
>> mm_struct *mm,
>>                         goto out_unmap;
>>                 }
>>                 folio = page_folio(page);
>> -
>> -               if (!folio_test_anon(folio)) {
>> -                       result = SCAN_PAGE_ANON;
>> -                       goto out_unmap;
>> -               }
>> +               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> 
> Yes, I would suggest a different patch making this change, then in the
> 
> last patch you can abstract away till the shared statistics line since that
> 
> much code will become common between scan_pmd and _isolate.

Nice. Makes sense to me!

I'll rework the series into three patches then:

1) The if-else-if-else-if optimization
2) Convert the !folio_test_anon() check to a VM_BUG_ON_FOLIO()
3) The final merge of the scanning logic into a new helper

Thanks,
Lance

> 
> 
>>
>>                 /*
>>                  * We treat a single page as shared if any part of the 
>> THP
>>
>>


