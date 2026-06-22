Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5E3CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA6D6B0088; Mon, 22 Jun 2026 04:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB0B6B008A; Mon, 22 Jun 2026 04:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8686B008C; Mon, 22 Jun 2026 04:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1286B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:13:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B859F1C31DC
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:13:39 +0000 (UTC)
X-FDA: 84906834558.14.2FA49DF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8F43100007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:13:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PAbsdqpT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5kHDwZW9GQb0EOKeaY3lq0aC38z+5UkoKNeLVuBzmY=;
	b=NF1y13vcmbHVst9pyFT/SruEGvKpqcdAkD9QUAGK1NTHssUV8BhBjSNvsjG7KqMfpH6l5j
	AQe+kjxlR69HdbKLvX8OvAWR0TOprMdNL2U7KZjGYsb81bg5T2OmtvyWNwQxBU8MwYMLEJ
	GDyXL10myv4iH/TfRiXmZJElpYKnczo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116018;
	b=EUwsSUdHvXjrdPUKWS86MhnMpNK2HDML/G00r+TBDUvUn9OfC6yvdX9qXfO62uQsTqV2kf
	wp2odp3mcRTrOZL3TegpKE6h0EdtNWLVXmmhh84EbuknArmLqccDpgMqYCUteyWIHWix6j
	engblIcLmpXKfby4ZCY/5HPe81mGGpM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PAbsdqpT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE1EF1BF7;
	Mon, 22 Jun 2026 01:13:31 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAFDF3F632;
	Mon, 22 Jun 2026 01:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782116016; bh=55pYdM/0X/gY7lsijQt+lVoe4ZgRE5hiLdnxN1F1wys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PAbsdqpTB9bBmH0OMrY/a9PGPUK6A3B5TLXnGG0jgDqAkY6ctLnmLSRI9+6X732wt
	 GV61Tf8sdHrfejsc1aMB0ghFAc12sPu6Vr3u35ja85/Uhwu7zrFudU2fvLA6M1PkvW
	 QiPTzzKlqIsOpUUZQp/gqLz8D/nRCfocKCWrlF38=
Message-ID: <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
Date: Mon, 22 Jun 2026 13:43:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Lance Yang <lance.yang@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
 <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
 <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
 <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: x6umscor4oihd9bhifr7wyajyeewgzuz
X-Rspamd-Queue-Id: B8F43100007
X-Rspam-User: 
X-HE-Tag: 1782116017-504814
X-HE-Meta: U2FsdGVkX19xA1nz2mJtSFC3/OrpVZC0pEDA9W8pB+u2NW2vGnmJy712RtEzec5Xvj7jQVg58UJSyog0fc7HkKKHulbtu2u6l83QZDgfBL1IyLrsv9irIbwgNvBSsSSTgrC97i3xbHJVHDLX2WGbgHdldwyzQkNpI+CoSoteSTU6wrbwCOWkSPsw1gDS7SzwBXAND7nWo0IL/UlQ0rJ1OATonUDetxqRQbxtpoW+nwiysJEcevs55GCVGn3cc4lOSO5i1RXCMfoM3rvrQ4Xx1GvURCCHZa72twXdzsDKqHe1mCymY+w6JH1Pco0Afe/jZnd9d9c0CfGIdLgqSCi4LuEEbdIzI0CRXapSXthhMczHHxrpYMUpId6ah46VL26qs1/0O46uzyFVEQ9H9N66dU5xHkghO7wLGNWRlW2ZCoB1qaxaJe4cgJJqVrPXbGZJDA2AyzwCffr19lResN6i53w3HKiNOVaOP52yT4fwJp1CPiiHX7bNQgdLfRsHQkfvP6CpcH6+MC0InvPrcCoo/deF6MZ/+t6u3pW/EPfCcD2IXBi8s4D8LVWPM5g1P4g/6XBtDLrO3I+y1OTGTdBL/oxZJ8s2yPNQvMpXcSK5zYF3+smjtOTJUIWQwlqjgWYScNKxRtZBd6p9naoqEOPgLnL1jyoIl6881WJbtvdt8WdGcPsL3bMj6hu9KHbXjCafGGouyV7cz1QS+XsjmL+GMw1Zk2kHdnKqFQgwvLUloy3m0hTqhHR6/ENYf4ajEsUCqgoKCvPrYVZJS77hruSFprNjCrdCIxzZI4EjO9cXinSPZmflWFjqUMxTg/tHamZiNWv5a2X9H+1tr3lxoj/gYyQ8dqirNWTajxYzK/mE//5s3Vy2xw/dE6xA8DlW0g8eEtx51mkqlNRD7lde6MTLIEJzDBXepabCHkG/MyojTGmxQ0wE74yLnQasYVKL8ZccTLyhWDzogLuZNT+ScFX
 ZYNbYsWd
 Ngn1gOBLGyABbAYcG8auYMrN4Ht5MqAmxLzuzB6YFM3ARmKUIgH40XM4NKHda+1dO//6L3sl0LMQL3YNwt9gUItQ1j/PD9ucffLo+HqPAfabKbbRew2iHNhqktl+GMvTd4ADaQ57rJNv4o+gfLDCHWD35J0GAqjXgWkCw61oF6zusoAJb7CX6MTJ6ZWymRslQERKHcoXLDMzz1GzWBg9CI9HEMA8qbXRkdxdtj1K5JMS1WYclkc4SGUCM1md8jzw3k864FNy6YM7bHbwHPQWit1FuCgryeL6xIujPqLCmZGc6TkGQiEL9UqlOiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 3:31 pm, Lance Yang wrote:
> 
> 
> On 2026/6/18 17:43, David Hildenbrand (Arm) wrote:
>> On 6/18/26 11:09, Lance Yang wrote:
>>>
>>>
>>> On 2026/6/18 15:55, David Hildenbrand (Arm) wrote:
>>>>>      return __rste_to_pte(pte_val(*ptep));
>>>>> }
>>>>>
>>>>>
>>>>> So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
>>>>> derived subpage can be wrong.
>>>>
>>>> Good question which impact that might have in practice?
>>>
>>> The subpage check can warn, but we still pass that subpage to
>>> make_hwpoison_entry(). So the hwpoison marker can end up with the
>>> wrong PFN?
>>>
>>> +    subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
>>> +    VM_WARN_ON(folio_page(folio, 0) != subpage);
>>> [...]
>>> +    pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>
>> My s390x page table knowledge is a bit rusty.
>>
>> IIUC, it would be a problem if some PTE bits in segment/region entries (pmd/pud/
>> ...) would pass the
>>
>>      pte_pfn(x) -> (pte_val(x) >> PAGE_SHIFT)
>>
>> check. I don't think this applies, because
>>
>> While
>>     #define _SEGMENT_ENTRY_ORIGIN_LARGE ~0xfffffUL
>>
>> We also have
>>
>>     #define _SEGMENT_ENTRY_ORIGIN ~0x7ffUL
>>
>> So these bits are not actually used.
>>
>> What __rste_to_pte() primarily does is reshuffling present bits etc.
>>
>> So using any other bits besides the PFN would be problematic I guess.
>>
>> Am I wrong or isn't the present bit already at a different location? For
>> prot-none hugetlb folios there might be a real issue, as the PTE present bit
>> corresponds to the PMD/PUD read-permission bit.
>>
>>
>> Oh my :)
>>
>> So yeah, we should probably fix that ahead of time unless I am missing
>> something? Good that we separate that hugetlb crap out.
> 
> Yeah, looks like this was already there before the split. Should this
> be fixed separately?

Same bug is there in try_to_migrate_one(), check_pte(), remove_migration_pte()
and prot_none_hugetlb_entry() :)



