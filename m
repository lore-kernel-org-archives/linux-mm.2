Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9D2C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF2C6B0088; Thu, 27 Aug 2026 15:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180136B008A; Thu, 27 Aug 2026 15:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047D76B008C; Thu, 27 Aug 2026 15:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C54106B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:16:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB18240188
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:16:29 +0000 (UTC)
X-FDA: 85148005698.18.715EFE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF10340002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:16:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jJ/v9jgT";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787858187;
	b=lwhydlb8UN61iOYVsKxgVf942jPWUnRucn4s23VAWJCGMZutDvNt4tHLgCZxiw3IHVTfc1
	yHoA743cs5qeGxY5L/nnqQ+N9L9f9JM80D1BKyUEkiwqwrBaBuIORMM/sHp9gbu6B78xR7
	FMIPiHl8Bv/VxS4UXgkvWIlMz0ErgXQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787858187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=402vtSZ0Rvxad3Wmwjw5sTu+r1cgVc0iYiSAKEZTgIQ=;
	b=Y87yc8BPxLut5MljxmjsXp2XRGL1gh81umyvO28jxSEiREMfh6WIEAjM2M9sVgOD4BV6Kh
	UevNqRtylXJVQoYosaAl8NbfbZ/JeM4TzD66kbpGSnSanYBgVlGFxSOo2FirPnfpxPpQjF
	UDc3LF2cVdq+1JiVPhHO9mPFqhY0WVE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jJ/v9jgT";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E31243816;
	Thu, 27 Aug 2026 19:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC1C1F000E9;
	Thu, 27 Aug 2026 19:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787858186;
	bh=402vtSZ0Rvxad3Wmwjw5sTu+r1cgVc0iYiSAKEZTgIQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jJ/v9jgTO2Ny9RtN1fRNk4aRJtG7y9meafSId+pLOomFYcVlXngevf3BBWpPDcyY0
	 qT33QBLV4fDYn7p7gERkq5KBCpuV/o7iZXoi+BsRQE8uZmycSYeCS8Hasv+cGXeO+L
	 iedvaKAIHfz3F4YEm9xuRJl1eFclz/j+YQ/X+/7921Pg5EjS9V/ghQYiXjKUlcOZ/g
	 8hJJTRD7ufECbBOkKIHOZiBKtGgt6wYCkgkUsZk72iI02J3X9MehSynDlxGdGQqGsg
	 LRHuKd1z9k6imYox12A2U83Zg5pQtUq2lb9aboI9sB9xr2o4PhQllRj99J1vqV94uJ
	 jVTI2A85wELbQ==
Message-ID: <77e3dae7-8e59-432e-9cfa-68f71d3e9587@kernel.org>
Date: Thu, 27 Aug 2026 21:16:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/18] mm/huge_memory: allow splitting mappingless swap
 cache folios
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-11-9b43f5163238@tencent.com>
 <5ee65970-abb9-47ea-b548-5430b382cf7c@kernel.org>
 <CAMgjq7CgxBEuX0rtUdx=g5RFijONOfDuUM=A2FBqy1R2N2n-2Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7CgxBEuX0rtUdx=g5RFijONOfDuUM=A2FBqy1R2N2n-2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF10340002
X-Stat-Signature: nouyjdhfqnraq6atobno8f6w8fcfpkyz
X-HE-Tag: 1787858187-909762
X-HE-Meta: U2FsdGVkX19YXduKX3F+xogeVvvEweFQxWh8hTDGXMhXc+S+0/hTldoHEAqD17WKWWFBW0JK1j5768LPFmGuTz/jvtOdhcfieyeKaR/mD0SR2GftUR2VqIo+TjIVrOYUK8wLnlumdJ7zxYM3L5EZnZNuIPOmPfUeUADtOlFBJg6YWADBVH5zrpep+tp3meLTo70AcS6/SX7dx3QuN3mNiWSxrnCib70HMERWnr2BC1OrNQBdiwqV2ctGA+l4WktUMvCo6SEl3dIhDYBlSikcj3goR8GT51KMU+OVGarzLOyBbgwiM/ROKP+apaiqEZcVZ/oSGzqVHqUzJtZPmSgBTlgEdXDvbj2hO/9oe+JA5WnDpmexG1mIHh5CdOj1Douq+tOnB4ObWAfaItNTn44AXoac29RmQMn4mffDz0065vReSSt5Z3sN47xhoQ8K3msiEtmgkX3bthCuo+KOIYfuMmH/0nnAg8AoG/WrS3YFvgpn8neyAc4BUwoUC6MwjlBkVSlCJRzkxCsG9MCoNxKdjfgcIf0bRZt4rmzfljBfjhCZZZctsBiCO4wJdY3cb9Il0arbVF5fTCyX5eOwizF2vKOFJBh8hRRyewJRe192qREt4tO6yAD5iH6NSR17Mz8NSyMUonAoTK5XKFlJHoDBY0FR/lI5Zvhfkvn2qPGdAW9QAkrhjG3PzfHiH1KqwFrEYto5vbGhQ8GhxnI9UtNKSBMtXc+kK7py1cv1lmJ6WCYph6DKLResYzbVDy6Tr7aK8GWblkfBciUGDSTNbW442QIeSrJ8FewVq8ARSNFcEYP4HYYv1ECHY4G69GwXYJffBPRhyRGpGoa/oLmcA/iSy0NrdAewwAnPHaX+7JGLywrOne5l3nW3PaVXXYNHyMGYUgMWl1PBEAaZFfM4pYxlkZn6ix9zE5VgU0Tg6/KuH6fXzD6YMtTLj5e2jC7j7zxN6NMsX9G9TAbdUQ5i5BI
 pk3S3xzV
 SIxERFVcnAW+Q477I8XgpEu4pbzG2FHeFzXIbpfq7f1fdjzrIeqUFrLGs1ALBGMN8B8ovtjYRlqPNty3IbKSLMbD8rKLxMuf+9kTIyGX8ulKYzcDU9HSkKHIWaR/GBhfBtda51pwgvtanmL3NJVF3cejGFl8JFVEAhNGUcaXp6Y2z6vHFWeTOnbeNnY4dYKWhU6tfoXC8Ir9VEO6PzLa8qH4YP8lMLMh1tROXhWQsxCGKkIGlyhfLW1kvOsUvbNv1eQ1dSRN4ln9ub4P16RS13XiA/nRtXCeg222rCwro0pyuBiibE+ghBFeMT8TBgyl2vG+hBRzcanynnic77zSeYxsdE50xiYtn8Odn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 19:41, Kairui Song wrote:
> On Fri, Aug 28, 2026 at 12:41 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>> +     if (anon_vma) {
>>>               if (!ret && !folio_is_device_private(folio))
>>>                       ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>>>               remap_page(folio, 1 << old_order, ttu_flags);
>>> @@ -4259,6 +4261,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>               struct page *split_at, struct page *lock_at,
>>>               struct list_head *list, enum split_type split_type)
>>>  {
>>> +     bool is_swapcache = folio_test_swapcache(folio);
>>>       struct folio *end_folio = folio_next(folio);
>>>       bool is_anon = folio_test_anon(folio);
>>>       int old_order = folio_order(folio);
>>> @@ -4285,8 +4288,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>       }
>>>
>>>       if (is_anon)
>>> -             ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
>>> -                                                       true, list, split_type);
>>> +             ret = __folio_split_unmap_and_freeze(folio, new_order, split_at, true,
>>> +                                                  true, list, split_type);
>>> +     else if (is_swapcache)
>>> +             ret = __folio_split_unmap_and_freeze(folio, new_order, split_at, true,
>>> +                                                  false, list, split_type);
>>
>> These two boolean parameters are really a pain. There must be a better way.
>>
>> Also, I don't like that __folio_split_unmap_and_freeze() sounds generic again.
>>
>> There must be a better way for that as well. We had a clean split and now we
>> mangle it again.
>>
>>
>> ... but I am just before my PTO and out of puff, so others can brainstorm on how
>> to do this cleaner :)
> 
> What if we just keep the __folio_split_unmap_and_freeze_anon name? And
> have that "bool remap" mentioned in previous reply? Clean swap cache

I think you can just rely on folio_mapped() internally. swapcache-only is never
mapped. And anon folios you can just detect internally as well, right?

> could be considered "anon compatible" as they might become anon

Dirty but better than what you have right now. As you say, there really is no
difference.

But for example the mapping/remapping is superfluous. So you could also consider
a _swapcache that reuses some common bits from the _anon helper.

-- 
Cheers,

David

