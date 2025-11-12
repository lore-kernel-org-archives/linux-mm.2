Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A35CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6D38E0009; Wed, 12 Nov 2025 06:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C774F8E0003; Wed, 12 Nov 2025 06:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66128E0009; Wed, 12 Nov 2025 06:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5188E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:41:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 640B71404B0
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:41:19 +0000 (UTC)
X-FDA: 84101764278.13.AC99B09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A0D641C0008
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:41:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V50cSsvg;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762947677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9brjwWV7LTKYneNrHBlF7d68GjJetXJN+dE8L8/cNlE=;
	b=kk7W4mwspeu9XypBi/7a2PSbIdRgn+2D5e9HWtEh/elvi6rhJqbrVF5Z/a7D1JE8cC9ZO4
	U+pkYrYb+usUV33+R7OxUBK6MC7FHGzyCKaOPUAIRqjOW990b80TucUvF09WgSMvMat/dv
	Kl/lQcJu1gPaaOAm26hDLXLt8HQfzL0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V50cSsvg;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762947677; a=rsa-sha256;
	cv=none;
	b=B5nV6Jpb+ram19XEmd5UN9W1J5+O1ylVa0vhOxWnZWbY6FYNbBhKhW5dc3FsWgBLRO4mTP
	JTHhF5ygfjzstDLZRd9wjMFMWjeQaHFXaf0BRiX+VsikelQTzs7nynFtRy3xNUNoF8vaMa
	tRk7uQ19HCkhnZUn2BpaXz5Z+Obices=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ADC4940792;
	Wed, 12 Nov 2025 11:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38810C116B1;
	Wed, 12 Nov 2025 11:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762947676;
	bh=SIcYOLNtSvw9wJCXNgXOjvI2cZB6CzHnmisI6JJDTrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V50cSsvgX5TzA7qHWhwRyQKwLZenq97Ek5BWphCnh5KEKL4Ij5XcrwVLyPvuVz1w8
	 ZLzEPjYlNXzqH/8D/gH19704pySpJKM+2DLh+f9gmn/AsYOPWVgy7NuxKc4i3CmEyD
	 B3dBdnDKQp2l2X6kqFBmNSOMEbuBpXfn9KfzYZuJexQL+l253CPBFI73/1+vLIFz3a
	 EHRAgFz9lPu2FtfV1VvFwITZddbpKhtJyOqQPAu9JMDnu7VAdbJSS2Pkr8oBbD7YDP
	 hFbi3M/gHXBVAb1IckloaeDog/qYIF8ZCctyNLOWy/LL4xjvolhscUx4GmFdOL1LzR
	 2PqDQTuPSxBew==
Message-ID: <374276d0-1831-44dc-b7c8-1976a07da296@kernel.org>
Date: Wed, 12 Nov 2025 12:41:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
 <04e8e813-b43b-423e-8ad9-fb13ac953055@kernel.org>
 <d4e055dc-be45-4ced-870b-2b62f3507c71@kernel.org>
 <20251112112739.ovfkj6zy7kqcervv@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112112739.ovfkj6zy7kqcervv@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0D641C0008
X-Stat-Signature: hc3rejh443kkugmko9us64bq7367xfxf
X-Rspam-User: 
X-HE-Tag: 1762947677-637807
X-HE-Meta: U2FsdGVkX1//pMLyV51yYv6sWXLBRc29zy3SjwFF2QuWmcA+PS2E9Nyzea4VGkzXbBSvaUgLRcuDNVRnedRaBynC1zZeR0w+9r2H0BwFSKDbG1RuAcE4G2Muju39FjHh2LjyFbRTxQg4QbUgt5YLq2ZRqvDPBlG1SMV2+lpJRHD+5Tl/fqJspcL1ECyeQg4fT9QfhrH9be9VTj0E5/8jmcZSBCpVgjD0YfeOUpxNNH0Kv97WZqfUUx9qkF/fkdEJqw5CawmQe+N0766bxxJiMXCx74mbM4VEUvED2OqGy4okaDPQ8wroDihF1eEwqfv2jVa0zb3C3sUrAyGgpYGes5MixJ8BORVAhUuDSL/eLb6BQlUwesnUQ+yDAzp5+ha2TMwHHvkgk1H/WrsyvxzXHXLJPLVO+SOTGRfeiM+5HeJUj9a64v4QPAcUfWb2hjoq+ozHu4XFuh9CVp6rMWcBojzJUdbTH/y7WDuTC+CZuHczcsbW+oyDpzfhP5xdx1t7e3BdAAlP5XuEIxM2CnAkjghA0WxHVcd2ZtLV09qabw99C/z6Jz0RPVAc2snHUPnYDCxvKI3UqR9K402f6TJMt5Q+lCnyBY+aPTO0TycOcJn8r4Tz4bUBaBUpDCS0bTMZNEff0GUV+dTxKQ7qlUCUKoCJ+3RF3uxgJS4keO3u2PnHVTzzdHCq0ILyuzpqRpKpTQETKo2nl4V/tMxvLq264FNMmTpAWQBRs/OdStbIxjNL/BBr+Ab7QDZVVq/IK3mjjXlq+gIMOk7XtMjeYn4B301PeujFvJHzExRcmG5RU1OI9uA26YA89ZW/n5bvxxeXSmKFm3u0+ROGevNYE6CS36zH9+oq9tokYS5FSApJPwfAbRC+9VKb4bG2Lhq71vzgXr0Lt7rn7+fO1c8YZeMo6ZOewgjqAMsMXeKQpyIBirhRJBTsuZMk2Kfatdklhr8iPzGr8v6ezAmUkQaI7sf
 9YWxjw/C
 DGnHul8iRKEPk/apXiZiHmlEGBXY6Rw3WVDpxE7VH7vVF8Xtqhgtc0Z/EMELTuT1mARcsex/AU3dRTOlOrznMZOowL1iqbTak8LQ3UiKiIqy8ZRN42F5wJoM3S1/dZRnOgU0c/L4HrIZTZS6O9RegGB7Nux6duNyIIgk/RC/cJvUc3fvIgvsN1a0fzyVgt4FiD45cVCODH6w9sVb5SvZN4yOKA3uZs7F7a4U4wkEi0wuSnWPZv/MVTEqLGcOEO6V+VdnTyoX8qu02YjtMIb5d31F6oGzvLuuuetMm37iOolxB2lrqYJZdqimDip3l7+H8Z87ixfpcaTGw47UlMxJ0sioOilHbTf4AfYOfRCEOeH40XB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.11.25 12:27, Wei Yang wrote:
> On Wed, Nov 12, 2025 at 10:51:43AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12.11.25 10:51, David Hildenbrand (Red Hat) wrote:
>>> On 12.11.25 03:00, Wei Yang wrote:
>>>> SCAN_PMD_NONE means current pmd is empty, but we can still continue
>>>> collapse next pmd range.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> ---
>>>>     mm/khugepaged.c | 1 +
>>>>     1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 7e8cb181d5bd..4c2217076ad3 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -2835,6 +2835,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>     			goto handle_result;
>>>>     		/* Whitelisted set of results where continuing OK */
>>>>     		case SCAN_PMD_NULL:
>>>> +		case SCAN_PMD_NONE:
>>>>     		case SCAN_PTE_NON_PRESENT:
>>>>     		case SCAN_PTE_UFFD_WP:
>>>>     		case SCAN_LACK_REFERENCED_PAGE:
>>>
>>> Looks ok to me.
>>>
>>> I am really confused about PMD_NONE vs. PMD_NULL.
>>>
>>> Is my understanding correct, hat with your patch we can just merge both
>>> into a single NO_PMD_TABLE or sth. like that?
>>
>> NO_PTE_TABLE, actually
>>
> 
> I am thinking about this too.
> 
> If no other objections, I will prepare a v2 with this.
> 
> BTW, you prefer merge them directly, or merge on top of this change?

I'd probably do it in a single commit, stating that both scenarios 
should be handled completely the same.

But no strong opinion against doing it in two commits from my side.

-- 
Cheers

David

