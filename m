Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE50C1090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32046B04BC; Thu, 19 Mar 2026 09:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3526B04BE; Thu, 19 Mar 2026 09:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1F06B04BF; Thu, 19 Mar 2026 09:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CECED6B04BC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:03:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E1111B835F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:03:13 +0000 (UTC)
X-FDA: 84562828266.22.DCF2411
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64F96C0027
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:03:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MzwsjzqP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773925391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKpScpDxZMIsbWUlOY+DYJLETRmQksi4RcS0AEgRoSI=;
	b=lXqMJ6awm9NaWCWDUG/1FL47+h/U7R6bRlSV93VDg4KwX9lhlflQB4+v29x8xC98dBN5Wz
	8oQsRac7A47qhb1EC674gC/taXjIH7JNd+DSXek9B2cwt8Bl5nvFlraHSZVnGoF+DO+uQ3
	FwXFiJrZtWOeRZc7AF/hUBMO/E12ojw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MzwsjzqP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773925391; a=rsa-sha256;
	cv=none;
	b=MtIhoqkwXuaz1fcEqXdEPC8FuDvfkXv82CdL26/3iFYvmgDCyMOXdywesDUEKltMDpPLSV
	4iCCgA+BEfputgbLE7xjoPi5zzW9dwxPHXZCb9XfKJx7LdqQEA7NgUAv3rpyanBkZ21XXr
	uaxx02xH4Ejz7J37rws5rd7rQfHWqys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B369260054;
	Thu, 19 Mar 2026 13:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B7FC19424;
	Thu, 19 Mar 2026 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773925390;
	bh=6YNsoQgr85AvpH0Y2Mgoinex90DDMBOMGLuMRbBsrno=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MzwsjzqPOBrBhjgE9l/AaVTwvqW2q1oDdyHkVRKj+0O84XlbyPqqrSamhMPovUTED
	 y5Dn2Pm1/gyZa/+zzdEjGGtYktz2hP0Dxd125C9pqyUhgzgMtVhf2S4M5jSrHpfH5r
	 KO5s28WPX/niWJCSU80zOO2BGtHCLXJcYorN/TqkRkB57zdjyN0/HVbdD+AZJX1haj
	 EwepfAPreJvi03dq8FylMvC6unRzUUP3PB5ZFof/c3c6pgrG+3GjABvC9EobXVrDX7
	 DjbcVkBmW7jlVymwxjkRqw749j1fDKd3cl08IzPY5YKBzehQOycXViaAtJVidq6ezB
	 zbrkM12tcb4dQ==
Message-ID: <cb86a286-24de-421a-b14e-8d11d4e8e89e@kernel.org>
Date: Thu, 19 Mar 2026 14:03:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773865827.git.ljs@kernel.org>
 <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
 <5ce0932d-e8d7-4f0b-acb2-12be43a035e1@kernel.org>
 <11293efc-8c97-476f-9b65-8576c63e3275@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <11293efc-8c97-476f-9b65-8576c63e3275@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64F96C0027
X-Stat-Signature: duoq9u63empmfxc6hp5gh7ydcp7onudk
X-Rspam-User: 
X-HE-Tag: 1773925391-479510
X-HE-Meta: U2FsdGVkX1/rJQFUMawNNVSbU8avZ/pFKvrnRHOFNrxp8i/OStZS39bdZWwSppX1I0elxmQWyM5eS9j/ni4kbZ7wG8vt839cRmYdoBZTqQYebkwI455zKMCT9pcBH2d5b1Jhx74INVTONC4MhbWjg3wJAbrkfFn6Q3KmfB55QNIPEmddU2j3bCEGSQPll2bY+NzlkT5CGKbDKfDMUgz3xYTUgnb/np8MdGr5/KPLyDfZTAUiJWuYqcxf9A7JVtmb4PJwRIK529LU5DmxJxwflNEkBvsin/RtchlL7eyc139Jrv08z6OWr8nN7RgxX0olqQcSU4uqhRFaZVzb0Oo+sLqzXDNbaXXUj53IV/p9X9LI2RKTczuD5ddxy2HUhNw9PT3UYDnDNiyguEJxS+kbt2eCsZDDvET825hbcLGio67YEZDnE2qkLKuf+Z1hr/HYe4NpdUObrFombx16DCTojX6rZNUoSLwVIsieVWxQVjEGPAAfuvQMOTR5ChuYfbWVvnfkEmFoNmkSvz+hH8IEk+cRYRD9+B1Tn+GzO81v8iOs51HDfnrRR6ot5Ay7FDXh1cfMMbBG+I1ZBAy9mnoKa+EQu0ujiGPn6O0jJQnOwAT9CHrKbZvmFaVfdx6KwGUAoqNd8YGpzh/KqseXFgCLSPxlzNglcTcm0ruolKNIxh7EBBSGW29NJaCmrwx7NtYnxCjwqpRGmiWTM74ZNKY6FyNOdH3mDRw7s2+WJEc4s5ljM36ELi5vFKEOByhF8w/GmAk5ybD7wOtKE4GcE1i1e7N+u2/qHbKGuKjZzL+u7Fgj6dAmFI4xXuqJ34kWP8c6LfzREGSxkI0eyfVdzcwwZQ7hgZbGGeSCwPmAxpp9Llz+AS+xjD5UVOMizBxd0M+HECiL3csKPKnh7zmygHeD6qe98jPLtI+XC2k/AzJ7PtxzOxHS2ki5MZMnmId4SmoHbExjpMVkzhbFp/gtOhT
 wtL+xAoM
 KA+4rUZYykSzlvtuTkl2H8bwhbw/VUX3JA6/Nponuy46hXDSHKHxu5Fns6ZnMkre+mJtIctJfAG23+4ae11EwLaBXXwSIWhvUIMRJsA53NX+vL4UEzuUGumJz3u8UY19k+ohMWAWFvg4OE7++vwgEsC3828rkRWeWKNq9B78r7QbIdqPNjtGhPG4iQbxdKg4HdjejipdWndAYfymQLDlYSzuke66BfE+GzxdMxc5488D5DmGlO/jZovghbyRwLpGBa4c0Py1f6ErcoGS1+v+0nRp/Fr1VQeJuSuhULZLL4AMibD+cL6mLvd1kTVVi8WYGAsqs87jswdOmxHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 11:34, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 18, 2026 at 09:45:31PM +0100, David Hildenbrand (Arm) wrote:
>>> +++ b/mm/huge_memory.c
>>> @@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>>  }
>>>
>>> +/* If returns true, we are unable to access the VMA's folios. */
>>> +static bool vma_is_special_huge(struct vm_area_struct *vma)
>>> +{
>>> +	if (vma_is_dax(vma))
>>> +		return false;
>>> +	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>>> +}
>>
>> I was hoping that we could make this whole code look more like PTE code
>> by using vm_normal_page_pmd() ... :)
> 
> Could that be a follow up?

I guess so, but the code is so awful :(

-- 
Cheers,

David

