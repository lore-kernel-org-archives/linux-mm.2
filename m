Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E256CC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5CD36B0088; Thu, 27 Aug 2026 15:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DA76B008A; Thu, 27 Aug 2026 15:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5796B008C; Thu, 27 Aug 2026 15:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 741D76B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:29:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F28C81A0195
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:29:51 +0000 (UTC)
X-FDA: 85148039382.09.9B4FF62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B477A000F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:29:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvEhuVPb;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787858990;
	b=KnlCjjWrx74V5TW9dVgAMY+2n1PPiG3yYMfzPNSvzNyAsZaxmxEA43ewpqcmThUSqKqpLz
	/kBf/jsglijY7u5+rjbuhxwQSoTpJQqipoH3Lj3jsYTtj/NqFR28TEVGl42gAgoo+TBh89
	2PkPCe4oZr7GUnrbGyi104dOxfZoo2I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvEhuVPb;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787858990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsiFIJKUIbdhwtZuL/ceZshbRCnEhEyMon6IFiRCczM=;
	b=LRbcOhgF+CXPAtYLH70Aw4GaphPVTegQZ2OayrPHm7ZiuClu/7dDaddloGAn7cCJJvJB1H
	4I5lYdj0jJi/bR8yCr7BSnUqxL/TA9M33Te4fHPOneDVZJuEZ/VnVet/X97f0ZJ3eQQm9/
	7x6NOWqgF2fROfYR1ggVIpGG058zDvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1874601F1;
	Thu, 27 Aug 2026 19:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFD31F000E9;
	Thu, 27 Aug 2026 19:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787858989;
	bh=SsiFIJKUIbdhwtZuL/ceZshbRCnEhEyMon6IFiRCczM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=WvEhuVPbYOWgdlyaBZ9UD2AVXpxef2t6+BbSSWUhI9X72zZ9GuQggNN3ccz9pDrWJ
	 mKJU57vPPqDur8rCuEJQM9XOng3Cp3ri7rAe5a4yFrRnY/RjU6RbngBr35teMTHMty
	 NEKMrGcXL65sN6vJ+M8LY2yG0kIgm9D1lT/RkeSnfPjFZqh16csDoqeXLYCs5R/JtX
	 5/B26kJkNtw2SaMOmwySBeWDjxtT2LcBF8L0V9OtGKNtMym1I9aUz3s/wzoHTPGVIQ
	 jeFoYblVcFYtDOYdRFRny5l8kSJ/BLN9oSjvCpW0LM5zDpzv7CdUpnVdhcDm8wMiOZ
	 7bWqaMPg/fwmw==
Message-ID: <7c86ab45-38e1-4e02-94e3-d0925c28b25e@kernel.org>
Date: Thu, 27 Aug 2026 21:29:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/18] mm/huge_memory: allow splitting mappingless swap
 cache folios
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
 <77e3dae7-8e59-432e-9cfa-68f71d3e9587@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <77e3dae7-8e59-432e-9cfa-68f71d3e9587@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B477A000F
X-Stat-Signature: wegt4o1a8h6p3gbg59nw6uu1fixzzh8w
X-Rspam-User: 
X-HE-Tag: 1787858990-873690
X-HE-Meta: U2FsdGVkX1/wyeniYJ6nT65uLVssmkqdGbsEm2+MqZWaI2/6RoAMokIbFFDoDBMPNoswSNbA/JX/WCx+ax5mvWUw0XAKwLYomhMJmmyIQsARG7a+gT2iJf89esKd6OYtjxuvvbHzZQOHogUYvwmSXxTnFgMoyZBXpswZIFB4oYmogiZlf9uQkFvXc7mE/e0RjmmL5ck8htjyrb8TPLUVqeKiy0o0kCDksrUmIBbfIk7CPS/Bqu1RG4M9SLanqjIyfT2d2QlkBnD359uOjiA/Xd6TrGMCQfoq+wOHZwknKiId022Ilj3ImbzbyvyQSBvnmO7PuRuEx03Ks7TNnfCAFMnbDTLjU9a3udDzyh9yxgHfweHjkRcZhmTBF3qmAXt3uFtr3cGe8bpM7r2iKqMXeDvVBh0w502tU+RQHOTmxY0GJsGpQDy2N/opbIzjVrXgZQVSB0UGL3dC05K0Xpiu7MYHbn5RCb/o4oFRbferD9rPhBuab0BrA36A5KA+ixeEsClg6aTRI99uf7WMW45RDKERzVrm0pBfA7UZa1pZi5Qb/QkU7XgZsKe0nybEW1bVl8IOO2Q2Hkz8Z1D78MSJxa4pF92lANf4TV74XL5Rvsdu7rTbT9+NRV6bBH8shLLkRx5VRKg3t2aqAigJFgUwMt+Qg89BoVBkvRK5RiY2sxWO5cP5JVDMpfbJg3EOPVZaAQFBrcGd5LINDE3qFMHiMHOljG/l+xyTqM815/fOiOM9KXNyuwF+nf3iWAKr+9vI+jvx2uvZyIU0rytcID/gmh3JjpTRK9D+uyhFAKulZakclLzJ0xiz9iySxvApohGmga/wzcdlBKEDnwlWxzCoWojKlQSLkC0mnESxTU3DMkwLUdrEfTRXPVm6aOPHf7IbHJncV30Wp+EwBu15F5hdW5kg/y0q3Ub1v5Z3ZnJhpEk4r3GCEJFKU+v8G7cVj6wGtZx8RsZUXRCDXCsg5pZ
 +QFftsTl
 4zpDlxF2tvmIjylSriTK4Kps6qy75VoalDDHca4JVUIldMtn9uUrwnH6wGiX/Ly4++Eq796EzfAQvIo1DcoN9MEYGW2XaXbZDgDKz/L6okT1iqiMe7Y0OaNORB0Oi3Pj6TtOWrsWNq3pTGjBtrQQQa4jYeccOUPY53j1VAhS51F+2qtMucH3eQL94tmiomizEWg2jHG6aUM+5EgGVJ4bTIAJiSNmxs0HcImdGZbbIBtRoog8bOKoSB+J8w77FTUXTfOX0Zn1tPlLYZVKCcdiw4DcnrOCOks0gVGOmxCBlfNXJ8cnwEqr2nmrKo2rZkBS6Sj47lDOMd6XSSIYx3oi+U+w6hjOUT9dYOSlk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 21:16, David Hildenbrand (Arm) wrote:
> On 8/27/26 19:41, Kairui Song wrote:
>> On Fri, Aug 28, 2026 at 12:41 AM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> These two boolean parameters are really a pain. There must be a better way.
>>>
>>> Also, I don't like that __folio_split_unmap_and_freeze() sounds generic again.
>>>
>>> There must be a better way for that as well. We had a clean split and now we
>>> mangle it again.
>>>
>>>
>>> ... but I am just before my PTO and out of puff, so others can brainstorm on how
>>> to do this cleaner :)
>>
>> What if we just keep the __folio_split_unmap_and_freeze_anon name? And
>> have that "bool remap" mentioned in previous reply? Clean swap cache
> 
> I think you can just rely on folio_mapped() internally. swapcache-only is never
> mapped. And anon folios you can just detect internally as well, right?
> 
>> could be considered "anon compatible" as they might become anon
> 
> Dirty but better than what you have right now. As you say, there really is no
> difference.
> 
> But for example the mapping/remapping is superfluous. So you could also consider
> a _swapcache that reuses some common bits from the _anon helper.
> 

Okay, I took another look at the resulting __folio_split() and I think if you
pack the "Unlock all after-split folios" into a separate helper function, and
call this helper from inside the _anon / _file etc, you can just end up with
very nice function names:

	ret = folio_check_splittable(folio, new_order, split_type);
	...

	if (is_anon)
		ret = __folio_split_anon(...);
	else if (is_swapcache)
		ret = __folio_split_swapcache(...)
	else
		ret = __folio_split_file(...)

out:
	if (is_pmd_order(old_order))
		...
	return ret;

IOW, the common bits don't have to be called by __folio_split(), but can be
called by the other helpers.


I guess it would be ok to have something like

__folio_split_anon_or_swapcache(...);

(the function name length is acceptable)

-- 
Cheers,

David

