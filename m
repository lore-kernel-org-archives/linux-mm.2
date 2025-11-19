Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9907CF34AD
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512A06B00CE; Wed, 19 Nov 2025 08:58:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2BD6B00D0; Wed, 19 Nov 2025 08:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1DB6B00D2; Wed, 19 Nov 2025 08:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 256996B00CE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:58:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEA5F1A0499
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:58:21 +0000 (UTC)
X-FDA: 84127511202.23.0320F25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E33EA0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:58:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/CZAhY7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763560700; a=rsa-sha256;
	cv=none;
	b=AH/k8hV9h7kO+I/xiE/jUPtwXIP7Nen31s+3QnrJv1I/n0ggxGdyRkjtPHlDDmjMmLRDAM
	bkxqrxRSyBXSQJlXanSNog3dEjpcC567TYU5V/S467UUaXLZy31WILvQ6Whza5DAndrb96
	f+FQJ/3dgjpmet0RkmiBy52HiaMmMYc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="j/CZAhY7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763560700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/O46G3l8a3xd3jAGTmunqMyjv56Qx3dqB//uHeURzw=;
	b=W64Xsp34d1J1HxL8o5Ma7wMikUCqpHQ3dxdPn0ji0+M5ca7D8NTr9kGihyB4Q/IvfUUCrN
	ee3UV4khRXvvQKR3byuQ+S3VZljnBXLxjqe7QcpJxS8Ej003AbwBS+k7X97VMGiNmRNzgE
	OIwbe/24I+uMiUadsa7UrtPy2MX9iFk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C25260166;
	Wed, 19 Nov 2025 13:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1880C2BC9E;
	Wed, 19 Nov 2025 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763560699;
	bh=JRxfngDvQAz26XpSeqsn2PHhq06Y1ysuGPxFMQy3pGQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/CZAhY7IOXTGtYHDrPVJN3J24w7oj9tqLskEU3HV9HITpVTB3d0UdEh2KH0Qs8ep
	 nKPaoJmIRi1gviOyvSWcNhxIMWHqheenctHKlyCtXNY1HH5FwUqwkbb7l4TDKndDGe
	 nuL+ijtZWUlG+SiFQ6AclgX7a3OFwAWuJ5P5XSC8OpBXawA9b66vy3xHEdZHYdcIRV
	 AJBVKInh6gSCz1an+HSvObyG+JSgIt5gPJ6uxiyxA28fO1rRFetrdnahXS+Yobqlu4
	 jIcjZkwTmOVXdrQOn8B7SJ7mCP5lOv1QO9dVuhxloM6ffLbiAiX7HOay6JcUn2Y7xo
	 E9WwH60FLE4bw==
Message-ID: <86b1e36b-02a4-45c5-9670-543cc635bb65@kernel.org>
Date: Wed, 19 Nov 2025 14:58:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <20251119134106.t7jmnl2k5w265en6@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119134106.t7jmnl2k5w265en6@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2E33EA0006
X-Stat-Signature: oa4zghh8ugi4h3nnyznnnputu1ufursq
X-Rspam-User: 
X-HE-Tag: 1763560700-670306
X-HE-Meta: U2FsdGVkX183s6QucC1MOmbp5vUKwVZpA3UhF6Ck1AyBdVUyL6C7IvJEzoLNP5jSeUjsNwgJe6eZrRboKDwfLCs4TcFZDkWuw0dnrwPblkwJacQ0jnXSKMVxfLcrHIwvxewvqBTi9gJxdynZAPcBNKn9lRWcNoXbZrmCyKuWz+X0clb9vpvK0ja19M7xxrgyPJlUUK2Vmt1tLv2J/B/09xyzgV6poyxuCRHkLeXFkcxA++vD+GGLkYWbxjZn6LegnPZfF+zrM3XGbQAqpDOGRaN/bYZ56a0TDnvf+l/RIG8goQAt59ZH4KtJjobG0DfBu0C4y7BDuq8dcoiRJd2KQIJHVCrgXeUjYydbFWbcaUIeLWbxz0ttI7TMCueal+G290qkj5uboUBVA0wp4bNdF8UeguOxFwpAbpr3+MFLI9aa+Xid41HOOfJlNEMTpgAIgfBdsm17GOEnpuXTNfFuglCmWStlOl4bt3DKweAYlO5g/qkhzwQCHLYe/HrXyCSIrGSuezv3dJsyvwxASCLM6fuINH3c8HD7XFETTr6kHz2jEU3ofHj9cQJAp9YNaMZ8OtsvaGzihx+VDN6oQc7wbrYJMfBfi4qhuhMYSlqMOGav3m1I40GwMtOfH86FKFxjAu7sXsJef6bxwgVADU3i2rzRBFL0WDNOnwDOiD7WWQ3qQRgQDkxMh1eHuAEIr9YqIODLqAGTx2rZg0/xAEj4B/zGvyczmEM+oS4+FBxgpXryY6pWZZ8FWXiwHHBS7PKBZyDPHyYuO1CEqYzcVsmFWJSBhSUzbANG3HHedJE4obq1qAM9aWm23EwYXShW1aKQC/MpRAnix+Dz8QccaW6ATRzL3LX5rjCkM1stc70cvkgd5sdzdLBnAjq15oUlnlX30k07XAOw9vfEn8zacWuzw8XDSe10xDi7wkGK2cuv/DZtwajC+jhG7HiT5QYLDhEFvejBHpOMAsqjDF8L23+
 L+ddMG5J
 SN5thjAndrOaHtmjNg8vQpksbMEQf0ikLOJZ8oH0R1prlP3aFwvyQQCT9uAPctOVnjPkvarD2JUqMqw2IOCO4ynETeL6IVk/xTAEisKyLo/BviBDeg949V+mbzrT+DjxlDUX9hAzk9ATSZvO5wLQ96F7wJ4Z795fpJNoL9dhuMMetA/Gq2ZG4zPlVyNoIJivwBOGnJme1K1TRoqvCobQ8vn3Y8XRuO7bOlmdiPcPZmppBWK75fzRSVO8v3qwYT0NQXXyKLIkcKPRdHj4etQdJlHrYEe0EWWOnx4eaisMoJKAa2Y0u6Yf2tYLkWcOsURrJeswS8TSXodiOJNHHtEYlDlwGjzuxVOAJA+z+4BDmg5JDX2fVvw0DaKBC4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 14:41, Wei Yang wrote:
> On Wed, Nov 19, 2025 at 08:08:01AM -0500, Zi Yan wrote:
>> On 19 Nov 2025, at 7:54, David Hildenbrand (Red Hat) wrote:
>>
>>>>
>>>>> So I think we should try to keep truncation return -EBUSY. For the shmem
>>>>> case, I think it's ok to return -EINVAL. I guess we can identify such folios
>>>>> by checking for folio_test_swapcache().
>>>>>
>>>>
>>>> Hmm... Don't get how to do this nicely.
>>>>
>>>> Looks we can't do it in folio_split_supported().
>>>>
>>>> Or change folio_split_supported() return error code directly?
>>>
>>>
>>> On upstream, I would do something like the following (untested):
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 2f2a521e5d683..33fc3590867e2 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3524,6 +3524,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>                                  "Cannot split to order-1 folio");
>>>                  if (new_order == 1)
>>>                          return false;
>>> +       } else if (folio_test_swapcache(folio)) {
>>> +               /* TODO: support shmem folios that are in the swapcache. */
>>> +               return false;
> 
> Hmm... we are filtering out all swapcache instead of just shmem swapcache?
> 
> Is it possible for (folio->mapping && folio_test_swapcache(folio)) reach here?
> Looks the logic is little different, but maybe I missed something.
> 
> OK, my brain is out of state. Hope I don't make stupid mistake.

It's tricky. folio_test_swapcache() only applies to anon and shmem.

But looking at it, we have

	PG_swapcache = PG_owner_priv_1,

PG_owner_priv_1 is also used for
* XEN stuff
* vmemmap_self_hosted

Which is not important for us IIRC.

But we have

	/* Some filesystems */
	PG_checked = PG_owner_priv_1

So maybe we could indeed have false positives here.


So I guess we cannot rely on folio_test_swapcache() ... here. What a mess.

-- 
Cheers

David

