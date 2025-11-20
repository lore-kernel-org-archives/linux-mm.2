Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED753CFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 20:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC8D6B0011; Thu, 20 Nov 2025 15:02:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD236B0022; Thu, 20 Nov 2025 15:02:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BF36B0026; Thu, 20 Nov 2025 15:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 170B36B0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:02:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A5EFC0330
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:02:01 +0000 (UTC)
X-FDA: 84132056442.01.4D9E0EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6301610000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:01:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=synl6nsr;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763668919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHVgaJEz/7rvdq304rmAiCJ6m4k1j4l8IBv8ks/glf4=;
	b=odzB9nvJORgpcPDVsQ1/SEgWJ2WLEI0LSBzk+hRs6N2PYyV5po2naXFe9b/BeMz8yhHmND
	xv9tcZFKt6KkUFxS1MnBCnCvq0oKd57V+xAFID6cev3LlQlgpoaoUcP7jSYUfMLbUdImD4
	ksbLTzpkrVEdYqcubP+cpob0dxahLXA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=synl6nsr;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763668919; a=rsa-sha256;
	cv=none;
	b=W0GbQfs6KoxfipNbl2EHiSqPKhVbA0GewM0tEwwEtwM9uNRQBNbjgiU6ciLP1yWRV3RPQ/
	v69xuQyP54QBWkeDc4CKoTBamIC/cgkZK5XyGcuGDYm6Zl9SY65fP0662jovS6Bg0SGxVp
	kWxyML0adFeDTsXR53RqR6lZGCFrfFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 773A2600AA;
	Thu, 20 Nov 2025 20:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9507C4CEF1;
	Thu, 20 Nov 2025 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763668918;
	bh=ZvX0wFM0qL1CtiFzpbJjufy/5/LYP6pOHRZEztLhSmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=synl6nsrM7koryVi0hr6FZQxhlPjLlbafWBhokYY8sS5/OqXPPqbsN0XP+yeyDQJB
	 fn2p2iPvCfi1BvSCFhV5u1Q2qN6MDyaoZK0vA97C8VpPFqwUoykvzHEZlcaqFqw5mf
	 MPCMkvHV6SZoCdV/El4CL0YSGFvRP/H7hwVsGMwuEoc/iHhmaOBS6mltuWCx29klCO
	 MhrFWO2gJ39g5tHgax9XHO3kn8SXTxMMYOmDpIuSYLO7RKWWykQoDbrzlw+7UX0YA7
	 bfiqxng42Was01wyhEfy3sii1trz/aRcmolAyR8NWw6EpbW4sTdKXLFKptgow196Ds
	 xmCfl0EPdcKvA==
Message-ID: <90790838-f6aa-41e7-9f34-7d5a1e18a706@kernel.org>
Date: Thu, 20 Nov 2025 21:01:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/huge_memory: add kernel-doc for
 folio_split_supported()
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-3-ziy@nvidia.com>
 <b051bc10-cf68-4e1b-847d-a1323552b963@kernel.org>
 <9D88B1A6-1D00-4770-9B66-A9A0F1B6AC15@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <9D88B1A6-1D00-4770-9B66-A9A0F1B6AC15@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6301610000B
X-Stat-Signature: zmzx7kf6yff33tfwnexanfj9sw1qkndr
X-Rspam-User: 
X-HE-Tag: 1763668919-898826
X-HE-Meta: U2FsdGVkX18LNlQAYewD+ZcScUUw8AjLCFPCKT8hfqzmOOUC+cbFJpmcox2EeQ7R1mc5KG4okID3QqVHAsloSg69iNoW5jiQatj46UrfLeZSkIKfSKk9o/jliDtZeFzNACQqAR2H9FR8Yy9u10G6ZHn1QrBi9JLYqKqQTtFXLyX2Mp1aQGdGeAY343LdFWD2BTGeqEuXfns1VjqAD9O+shAMtNzrBHuXQ/xEGu5KnJKhkZUsz1IzNmaELoqK397kg5SXPnhnEKu5BTNZzKMtfaa5iZKlU4EAJ+3yO+7xKHDJAlIWqwbZoA6NyN4TRNGVcTM8GvB7FcSCcp+7icyzoGbxg+jkdpYuKGUKbFvBa+Ff5VDd4/Ql3mnhcLglbxp95lIcUrz1YBubNNcs9MQabllx52yQEuCfPveef9S4/npgwQMMBwETCJf5qwwbDf8oS33r/L9Q0cxqqYXV1fG7MOfAbMIOA4QtVSIIvjcWWp45NikzF9nZDH2Dn9mRLjsrz0E1po90UOZA3/oCqNZOVKdS/Gq/89Wtk0SiOChfDMUP2iKe4jSse46Ml2kEERJkwZ/5QqRi8GwEQ9VpbPcNFudnvklDLSnq0k5QSgB9pXfEO/z0kADQzMzyA7xOaFyQPWZ5BJAR7XSXyjALLsyfOz3g3OrLHeVDhIzC0aGC1p/ccGjJSyADBEOkbGFapJm+W141QgDS9SYUA9DlM5Y0wA6RaW0JPBykbvf2EjpH+XDdcns0IX9o3ayIZ9pc5+EzCz2hussPIZMLF/mUnAocfLMsUT9hAm9NwxC+mE88VXdY608/1mSYKdJC8O3/XgIOEnuM3r7rNaPwbSUgAIAVPKGfhWSWIBd+Ebaq39Ak4KjM5Nh9T25mm2OtQeTU6RUcE6eXXZMaqSpyh9IFjAHAacqGnNu/L/5FUSczXiOcmWYXzNWA/aXTnbhzaCdoeU3pTOzF2bFCEcfJh+cetXB
 2PO3zvMS
 wxZZFZLsrUKDgcw/P2WQzu+DK2tPLqNpNMagNzPHtlkI7yLO/ujw7jfkHcB3uIDlu96rhZZFT1lyPg5LuKyIMywbB0XxNwHS4+zrcVS+IDlkxWpmHS5c7LvkctfcErzqAYCXmWNN895wqZ2+QDsnURRcgY7UV+WLhpa/twbyqSExrVqdcqcbLgRjxwHvXHfeYYPFiGq0Vc1KExOVbtzwtA6uz8uyHFRAC4m9wR/ShQ7PBe/8Vp9n7SXon2T/Vu1q9APEe2XthoBD4WsvHaXmXJEr9ZtTOwM3y5JgWJxR0bsTnpcHPtWPx8fRAt60BZFRcOOw6Oqo9RFkILnWBKUtF2CmfgrULIBpE7oG04CjnapA7+3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 15:48, Zi Yan wrote:
> On 20 Nov 2025, at 4:27, David Hildenbrand (Red Hat) wrote:
> 
>> On 11/20/25 04:59, Zi Yan wrote:
>>> It clarifies that folio_split_supported() does not check folio->mapping and
>>> can dereference it.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    mm/huge_memory.c | 17 +++++++++++++++++
>>>    1 file changed, 17 insertions(+)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index efea42d68157..15e555f1b85d 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3688,6 +3688,23 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>    	return 0;
>>>    }
>>>   +/**
>>> + * folio_split_supported() - check if a folio can be split to a given order
>>> + * @folio: folio to be split
>>> + * @new_order: the smallest order of the after split folios (since buddy
>>> + *             allocator like split generates folios with orders from @folio's
>>> + *             order - 1 to new_order).
>>> + * @split_type: uniform or non-uniform split
>>> + * @warns: whether gives warnings or not for the checks in the function
>>> + *
>>> + * folio_split_supported() checks if @folio can be split to @new_order using
>>> + * @split_type method.
>>> + *
>>> + * Context: Caller must make sure folio->mapping is not NULL, since the
>>> + *          function does not check it and can dereference folio->mapping
>>
>> Only for anon folios. Also, I would drop the detail about dereference.
> 
> OK.
> 
>>
>> I guess we really need the folio lock to prevent concurrent truncation.
>>
>> Maybe something like:
>>
>> "The folio must be locked. For non-anon folios, the caller must make sure that folio->mapping is not NULL (e.g., not truncated)."
> 
> Sure. Do you think it is worth adding VM_WARN_ONCE_ON(!folio_test_locked);
> and VM_WARN_ONCE_ON(!folio->mapping); ?

Makes sense. Or we allow !folio->mapping, return false and do something 
like the following. Still wondering how we could handle that case better.

if (!folio_split_supported(folio)) {
	if (folio_split_temporarily_unsupported(folio))
		return -EBUSY;
	return -EINVAL;
}

hmmmm

-- 
Cheers

David

