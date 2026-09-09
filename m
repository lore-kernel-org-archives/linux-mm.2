Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A63C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B256B00A1; Wed,  9 Sep 2026 13:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5393E6B00A2; Wed,  9 Sep 2026 13:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448196B00A3; Wed,  9 Sep 2026 13:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2586B00A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:25:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E8CB1C0A9F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:25:36 +0000 (UTC)
X-FDA: 85194900672.06.C09C04F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C6D8740006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:25:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zp8ty+5V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mn85r7VDgTlh3aUR+NGvwOWOBcsUrlMRqggXVv8xvpI=;
	b=oG77zZA2hAVZvMQSsZow2w9WpBkE8AiLvhkna3OQaNYxQGXxC8xn9kYwi3HJKMG75q0hw5
	gxxWBiO4jeLxfVJ4g/GPDUz5veH/GQjVFhXNnw7kD8vwRVpfpPKdlQBaegS77fb9C+ZfDI
	jAqX5QY0R0aSZVmyl9KN7V3sjPudDV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974734;
	b=UFu6B0GZYw0POdhHUbfacNjgYzMcwA8Jb2+Klf3yW2LUbJQO3glzuGIKig2VST/o3HylD3
	4g9FWTEaqiw+pFiGCWBzxrfGasJ2hUW0VodpiUXnrUMB8h0HzNtYbQi/fTLVMbmSSB4e9O
	dLUKRSp+60umT54prCeJWT8aErk72aQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zp8ty+5V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CDF1601EF;
	Wed,  9 Sep 2026 17:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57CE1F000FF;
	Wed,  9 Sep 2026 17:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974733;
	bh=Mn85r7VDgTlh3aUR+NGvwOWOBcsUrlMRqggXVv8xvpI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zp8ty+5V1ia71Mih2o0WCo4SvqrBSau3a3X2hA5v+mvi8+//uxn2FjZkddDnC7VvS
	 /N0vjuc+qH3EySkZSoF+4PQBzqiZWFgvitMo3EKvQfcwihVrQ8j4CC9S2sXH0sJMRY
	 kZnoMm5zO/OLzxDfV3XwYv7hxekZ4yDw+ZiE3ID398Piujj6SxaSEpEuGKnPQzng7V
	 im8KLuKMu9GEs++nCaLuFvSyTKp4ODr1aRuWfUctDgDxoF4VmU38iAMfBtd0XF4I2P
	 O58/p1v2PYelPTKbY1f0bZlxrfGM9zF72WAo8bmsCCnwMfP6itnmlfJrUgFRapGa+w
	 icq/BG3dxXKtw==
Message-ID: <2b0a6809-bd88-4133-a002-7a9acb2a973e@kernel.org>
Date: Wed, 9 Sep 2026 19:25:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm/swap: add folio_swap_entry() and
 folio_page_swap_entry()
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu>
 <d0aa1ccd-d99f-4fa5-98c2-21cea0f413c7@kernel.org>
 <cf9a0873-5ef1-4a5d-ba16-8ba3583ac8ba@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cf9a0873-5ef1-4a5d-ba16-8ba3583ac8ba@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C6D8740006
X-Stat-Signature: jriapy8zyh396rubw9nsj7m8hx9gjg7u
X-HE-Tag: 1788974734-854465
X-HE-Meta: U2FsdGVkX19vixfUYw6RoJEetgh8nV452RL3y3POZYp/iIVApl9pApffShwh/3LkqCdRKxBumF9bMDinR6ctHpb2KsyGsEJVSOJZ3zNbGzbnghQLp9jEUpTGhLV2Pmxf5knYDUK9D43I6zTadEBfKk7crAz1yZQHwUkCi0aQ54idhG+lmdo4PkHBtY6QO2r74FrBSANRM3a1BXjJijCx8j66oEjKY9NW+0hGkp1pI6mUAkfLtymLqd7eW41ok3/ZUPy272Sd3hNy8YVc05A50lXv12Jd2vNAUHPY/aRSl+Axcma08avN2pDlUW0j9r8vZTM7oThhQxQPtUSKmiG2iWoTZynuwKKSGL9fBUXxpRB9ItaO3Lt0Ul6p7m2iura0OJFIohzSshBN7UibFfPsEBdP0qF8kox69CftOeFoV3rVQhDZXECoXbsV04Wp4XfwJbcT6ihVzueB3UFwQXwSWMc2jEJ7VWUvpEKtO/kF+T7K76UeG82n6sk50zIuVNpU2PS+KLwboCKn11QVe1Tfz7oyTDlrYJGXNUsPy1DnD3PfASfq4l0ye9ku7y8KppKfZiZzVV1WGZH9U47duDH0vlfrsNWjdCmXioPU4LAn149QWuD39CmR3CylWLu3vyWj5JHOQXMFkAyRCBUDUKmhVOQKDxVJMgN5zvDgs373MuV05HdjzWFt5ExEnM3ZuyW8b7ItJL8aPl3BP0l1lonLPI6PQFDeltiniu0L3Gl3h8IYRC5VwxxYSnGyIJCwbkxrVmJHtxGspnV3XueI59hjfvQA/MIqYxRCWe9MCHTxlvDQe2Kj/TquKtj56GVcvl16qOkx439RMplS0fGs5lzQ07aA/ph+50hFi2Xf0Hj240fENVKUcZDjejEg/CNEyJCbAWDNIFxqFBKsKUwisoCuTwNtgbXaaMwxCls0zTslD6xdRCpXm2XgLgsIh3yUXlKu+HV+S2OBhaaiTvLInkd
 cT12sk0I
 TJZpmS8tWkYLbZ3lBT1VFfSaFfG6KtyCC5/+CvGLn6d79kAbrhGi5FYhjRlVHs4PiuX/5IIRqRMtBq1KGs5oEIXrIAlR24kzPbGV93LkA80OXyqq8FwUUcmGu3Uxi6kdUBqyapkfOar3zho9JcMZbFBBf1Cq+eiT4LkiUr+PxbxJSoEIKpK+LHEVwWE1U5ke/cLOKXYBRZJf1HIeZHYnFuQs4M1myXIdk/kQiGTITsVP53bk6hXPMjxjHiqZ3tn16pyI12FuWd2ctWjx/XERy7rSnjkmO5iDFYG2vWTItESTLuIjaoBhPiqPf/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 19:21, Tal Zussman wrote:
> On 9/9/26 5:00 PM, David Hildenbrand (Arm) wrote:
>> On 9/8/26 17:16, Tal Zussman wrote:
>>> A folio in the swap cache occupies folio_nr_pages() contiguous swap
>>> entries starting at folio->swap, so a page's swap entry is just
>>> folio->swap plus the page's index in the folio. page_swap_entry() hides
>>> this behind a compound_head() call, and callers that already have the
>>> folio sometimes open-code the arithmetic instead.
>>>
>>> Add folio_swap_entry(), which takes a folio and a page index, and
>>> folio_page_swap_entry() for callers that have the page.
>>>
>>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>>> ---
>>>  include/linux/swap.h | 33 +++++++++++++++++++++++++++++++++
>>>  1 file changed, 33 insertions(+)
>>>
>>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>>> index fc290e29e4a9..1d979e76e78a 100644
>>> --- a/include/linux/swap.h
>>> +++ b/include/linux/swap.h
>>> @@ -272,6 +272,39 @@ struct swap_info_struct {
>>>  	const struct swap_ops *ops;
>>>  };
>>>  
>>> +/**
>>> + * folio_swap_entry - Return the swap entry for a page within a folio.
>>> + * @folio: The folio.
>>> + * @idx: The index of the page within the folio.
>>> + *
>>> + * A folio in the swap cache occupies folio_nr_pages() contiguous swap
>>> + * entries starting at folio->swap. The caller must ensure the folio is
>>> + * in the swap cache and that @idx is within the folio.
>>> + */
>>> +static inline
>>> +swp_entry_t folio_swap_entry(const struct folio *folio, unsigned long idx)
>>> +{
>>> +	swp_entry_t entry = folio->swap;
>>> +
>>> +	VM_WARN_ON_ONCE_FOLIO(idx >= folio_nr_pages(folio), folio);
>>> +	entry.val += idx;
>>> +	return entry;
>>> +}
>>> +
>>> +/**
>>> + * folio_page_swap_entry - Return the swap entry of a page in a folio.
>>> + * @folio: The folio containing @page.
>>> + * @page: A page within @folio.
>>> + *
>>> + * The caller must ensure the folio is in the swap cache and that @page
>>> + * is part of @folio.
>>> + */
>>> +static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
>>> +		const struct page *page)
>>> +{
>>> +	return folio_swap_entry(folio, folio_page_idx(folio, page));
>>> +}
>>> +
>>>  static inline swp_entry_t page_swap_entry(struct page *page)
>>>  {
>>>  	struct folio *folio = page_folio(page);
>>>
>>
>> "Return the swap entry for a page within a folio" vs. "Return the swap entry of
>> a page in a folio."
>>
>> yet only of the variants has a "page" in the name :)
>>
>> A bit confusing.
>>
>> Not immediately sure how it could be done cleaner. The minority of cases seem to
>> use folio_swap_entry.
>>
> 
> Yeah... I considered naming them folio_swap_entry() and folio_swap_entry_idx()
> (or a variant of that) but I liked the page version more. I can update the
> comments to try to differentiate between the two a little more if that would
> help. How's "Return the swap entry at an index within a folio"?
> 

I guess we should call it "page index" in the doc.

-- 
Cheers,

David

