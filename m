Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B78C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D2F6B0095; Wed,  9 Sep 2026 09:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE926B00AA; Wed,  9 Sep 2026 09:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6346B00AB; Wed,  9 Sep 2026 09:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E50F6B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:39:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AA1B1C035D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:39:41 +0000 (UTC)
X-FDA: 85194331362.15.81E9C83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5A98420005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:39:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLPoNRcJ;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788961179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iP4r/Esf2pGXwRFwOfaFPtixVlzXtak19L1ZuCehHI=;
	b=7swE/lrAgEnWPZGHXQ4SY4j5gdcLIh2rA+RwPP37E+Ej7HwGBeaEYfYH4Kp1F3rS/UeR1o
	YMyxoZC8OI/9Lduay0PgmOF9OvRuF7IGxH0n/moTa6vDlZvy5Mx5lUIEBOCtYOSTzXunj9
	f5U+acZxtMp1g436ja67xnIr0un7nJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788961179;
	b=F25F7qKwGiEP3UuOx4GQYBQG/6m62Xmpe0PA1RqR4kEiFVPcGp+OgMQMFbXF4un5NC6eCg
	cDEA1J8kA7oPWAkCcgYgn1RjI+FChisJj7bev/QwZ5ydAnnx3eZ7ZgFxSMujBf81IqoGx4
	lXm5liicuxcXHfYfmW6dbl/yKbr7VrM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aLPoNRcJ;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B748860211;
	Wed,  9 Sep 2026 13:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4BA1F00A3A;
	Wed,  9 Sep 2026 13:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788961178;
	bh=2iP4r/Esf2pGXwRFwOfaFPtixVlzXtak19L1ZuCehHI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aLPoNRcJrIUL+1yqxoKS9+amtbp4r91seb6cACR5mTIDhpdc6wojfjfrTvCip5Glu
	 tA7h5LfhL6E3cdvU+mtaMv36LFxeTn7cXy5YIvtuhuR1FyBs64qdeFCrBDIAu1eh/C
	 IH0pR+3/vxzT3FMaHyneR1NIdYVAntqyeB1fpYiYh4QZq5ZGWsgi+avt6V6DFgbJzC
	 QPOVxXnt+bRM9lkBejCdDiKLSUUL+oWMULfrXtNJ+Yhd6QxmbozNFQr9msKbjaC/Sy
	 iM6lNn/cbUanuJCiCnm8KC0R3c923oFV9IZGvBgvEuaAxXL6jSzWrlNzAACXjnRwiw
	 V/LNo3CKTkobQ==
Message-ID: <c23b6290-a648-4a46-bcdb-044ca16f8ea8@kernel.org>
Date: Wed, 9 Sep 2026 15:39:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-11-songmuchun@bytedance.com>
 <67dc7ac8-b39d-4354-8cbf-f2a1c3a369ee@kernel.org>
 <82CAF33D-2482-4E8B-826D-8AF5E6FF8866@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <82CAF33D-2482-4E8B-826D-8AF5E6FF8866@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qp55dnkhinfrox5miky88afqipwcpmmt
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A98420005
X-Rspamd-Server: rspam03
X-HE-Tag: 1788961179-27120
X-HE-Meta: U2FsdGVkX1/y2Ogy2OAdH37s8SUaQfZ6wRpzeqoD1Bp5CxazDERgWIn3oo5Q8f/yrkQZe3G2biJIcTL7DuXxhwDTcUU8Bz9D0Qo5jPo7TWmxBtCqSnDSBipWQ0qFP1JrLolLerZmOGPkbd5AkuSmITT1GRY6pUv/oMUeyHhjstt4duYKtOF3xj1WxWVc6UUGJ5UTiYxOohdPcAI5BCZVd/7xSEvNKrBHqAyj7MLcO8rXBTHqUcwBK6UsMh9oe/WYqvUHWN7JFjxbd06YKxwDxbyuH/BafaBpS/z4GXytTp8W4nD60sq9Qg4GOiD5ujr2EcXNfMu2uZwrlkFcT6uYs95Dki6q3VuXlyFwCGcUdyPFYEb6To21ilZMOX0+hb9Bp5e22OFHUtHtmmTt+mThJa24toRC1sjRsUxjOIQWp1AwFM67cxw9Y39loWWwcWA0Hm/1+fGYf9fyUepSI8a9VS5WfEywSuWbBIEv7P7afg9FgMynuP25K41HRlNn+3sX1sBaWLmN+3po74I6Ysh9ffjWUIU84HgAVlbSwstIauoszh7bFr5sFJqOIiE0gm7J0ypqsrGhPj3coRbMPjGtg+BClYiDE7AK/8dZad4qg1MknbUXwQuqb1vRsTgoF+aSFHXo7L+wJDh+/sNPFArDP3QllRgxiG1Q3/mkcT+9ELlTQ3ry/udbEOUaoMkWBFQvWMs8buasVox+e9XQwc7mPrTsbLSytKQhpNK+g8yeS/kKnvpwhohX2W/xAmsIkxVkMiND6Z+HRq6F57nWwe28U4Uhc6++R1sItKNGSkdZQFvyOhigzdPpJM2/+5AEsfv5K9ggO6INIFkYbU47/H3EbeyOZRnnUpq9vU7kj32a8LxivZeRe296ypOpci+4XjB5IQ2L2TmoDzdrNccU3BDUHt8ivGfGcHAewVGhaQ+jLv6MpLgSfUm4lJDI6cEhqdqS+juJnHS+sEnTxTiAyIz
 EaqaTZcL
 EOA7tXGv5meotObQziOJygTVBHDX8C70sO5l8y27auZU7mgK0+PkrXN6K7NpnrAnE6+F47b4vcDFz9x49XgCURQX/ePhjQT04SVEks7+W1qSfcygiRamYAi0cYeq7PIvDbS2IDCvQh1fTCW1TgZF9CwdnvmNZeZZO0mK6yOtG+gFeUEDMc7yiQkBFW07cA7NBJDY0m46JwowDgP2lIuGOSoG3pTZ9Ky/qhYkIkXtR0v0hJSTGCsfXHebteE2XUBrYzbdzhkxlFCPZpIa+Yxd1N9nFQWqa00auAjVT/Ruaf6kpvdhhAaL2pev44qJSrxg+ackgw+hiMaFD49ep/6ISgr1tFX7XdIcyRxYQxNAQouTzeZaRcA50cuiKj1XA715gTsbn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 15:08, Muchun Song wrote:
> 
> 
>> On Sep 9, 2026, at 17:58, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 8/25/26 10:46, Muchun Song wrote:
>>> HugeTLB bootmem vmemmap optimization still carries its own early setup
>>> path, including pre-populating optimized mappings before the generic
>>> sparse-vmemmap code runs.
>>>
>>> Now that the section-based vmemmap optimization can derive HugeTLB
>>> vmemmap deduplication from section metadata, HugeTLB only needs to mark
>>> the bootmem huge page range with the appropriate order. The generic
>>> sparse-vmemmap population path can then allocate and map the shared tail
>>> vmemmap pages without any HugeTLB-specific early population code.
>>>
>>> Do that by setting the section order when a bootmem huge page is
>>> allocated and dropping the dedicated pre-HVO helpers and related
>>> special-casing.
>>>
>>> This removes duplicate early setup logic and switches HugeTLB to the
>>> section-based vmemmap optimization path.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>> v3:
>>> - Use the order-based helper for the bootmem vmemmap-optimized check
>>>
>>> v2:
>>> - Collect Acked-by from Mike Rapoport
>>> ---
>>> include/linux/hugetlb.h |  1 -
>>> include/linux/mm.h      |  3 --
>>> mm/hugetlb.c            | 30 ++------------
>>> mm/hugetlb_vmemmap.c    | 90 +++--------------------------------------
>>> mm/hugetlb_vmemmap.h    | 14 +++----
>>> mm/sparse-vmemmap.c     | 31 --------------
>>> mm/sparse.h             | 27 +++++++++++++
>>> 7 files changed, 42 insertions(+), 154 deletions(-)
>>
>> Nice cleanup.
>>
>>>
>>> diff --git a/mm/sparse.h b/mm/sparse.h
>>> index e4617f9c8876..049272aba84e 100644
>>> --- a/mm/sparse.h
>>> +++ b/mm/sparse.h
>>> @@ -16,6 +16,24 @@ static inline unsigned int section_order(const struct mem_section *section)
>>> return section->order;
>>> }
>>>
>>> +static inline void section_set_order(struct mem_section *section, unsigned int order)
>>> +{
>>> + 	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
>>> + 	section->order = order;
>>
>> As raised previously "section order" is entirely unclear. If this is a compound
>> page order we should spell that out.
> 
> But I also have another question. Should I also rename the helper name,
> like section_set_compound_order? or it is enough to just renaming
> the field name?

Rename the helpers please.

A memory section has a size (which is a power of two / order). The page order
used inside the section should be clearly separated.

BTW, I didn't mention it yet, but I really enjoy this cleanup.

-- 
Cheers,

David

