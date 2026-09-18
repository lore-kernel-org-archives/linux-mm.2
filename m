Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05A5C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3A16B008A; Fri, 18 Sep 2026 09:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC286B0092; Fri, 18 Sep 2026 09:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2A76B0093; Fri, 18 Sep 2026 09:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 571B96B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:44:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD0CC1A0649
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:44:20 +0000 (UTC)
X-FDA: 85227002280.07.C54C960
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B13A120008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:44:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HsKUSyLM;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9VPaOBm5A7r04UHfa3NhklcbPIGLG2u7NqH+Abrs+k=;
	b=ljz9vtffY8CyWFBDIlf12aBQ6+qBXqr1XOnJUilFAKtIKnC4Uea6K6QA2T5VK0Gt/9GMMY
	Tb3TQGilIteOOqpYYofYH1NgYeukRw0RHD97YMCZ0ANIZUXa/8FR48ExTXVJArTUbUqYrL
	n8sygaLMevgVF3hdM86i81R5F+ti4B0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739059;
	b=8V2KalhAu6NW9mI1jmNxzdQR39gy1icjjzhHl/hDN/yU+BtYrUBrti6VAzIShbnMi+i6FH
	sUR9F+UxEA7WRsbVOS1DypxcBm2xQl8t7I8eSoBGfJYKKzbcIqhWuNPh1kNvsfq7iZE3h9
	+ODimaYpIlOlbl+FPPlI4tjsDaxc7NM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HsKUSyLM;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51398410B7;
	Fri, 18 Sep 2026 13:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0225C1F000FF;
	Fri, 18 Sep 2026 13:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739058;
	bh=a9VPaOBm5A7r04UHfa3NhklcbPIGLG2u7NqH+Abrs+k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HsKUSyLMN/sYAQw7E49ibbB3T8ByiDDqcQDimeQKcDEKhP4tMRx5LC8I7GUrGejaX
	 60RYN1Tgt1M0rILU9w5IiH5w9mnR24HwpP3urETACDOo87RmfIdy6kRqS+iR1zhNKG
	 vrnSDPaxVveRqi2SBYmIQi1LIJ3YnMFtedH6nwiAyz/BQ+o8exiMFZsX04VqkOhcQC
	 5kJbLaNtnQ8hMOCuOv1KAZU93zEjO/f0WUIkNtCwM+CGelVVZ5eyfAEFrIknKW7T2+
	 xjLFUuFEVfk+zNulLbszGiWq8TPCwoOy6JzH0GakRuyKqkM8YFAu0QfBaeMMPfz5JZ
	 uUWOja6unBl4g==
Message-ID: <7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
Date: Fri, 18 Sep 2026 15:44:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu
 <jane.chu@oracle.com>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
 <an3uN4TAAZ2miXhe@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <an3uN4TAAZ2miXhe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wm7ceyy6ddd8rfpsj7ujp9mhjmd9uyh9
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B13A120008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789739058-383630
X-HE-Meta: U2FsdGVkX18SAU1SR25lo43zpBz/xbgeebryZh5ZHAVs34cicjFRsk/yQeRZ++ExuCukIwjMVHlB/xPfdM2HygPt15CDBp/0nhjlTMVS6M3KV5nnmL5cwf4enDptNyBzuADEbsF3HoQN6HVGlRiTZ+oJMACJYVR3HO+euXjvP9B7b/GJ2mDcCPdk1O0QD6P/UzlYkWZVamQJscBQW2NnSt+iUmVF9znWCExf9H7Rjr+nop9H7cmd0QvJNZU/+e59dhPwA4lg+slqKyZBUgTTBK8mts19RkOOyg1GYUFCAqAgxzYsMgplaisLRJNL+5U3lDT2P073husIDr9JLXF3YbBVwbIPjgpzIPkiQCzKRJDDMz22AI4gdfx9hHbkBysbbM80FlFgs5PHgkSfGHV5RDqQy+d0Hxr/2gkxjatrWrpzb83TyheJFmMh77BN88aqmbOEBVqN+J6Rp6lLJLiItmBEex2yN6zczcCF5M5G9701QZ02DG4j+imPQnOrQw8XEws0h9DMH8/lP+IU/O3BbUrtAEX9sWIcZGMnBgDvyKaswx6PslVivJrsiHMVkOo77ZtRQHWQcxE1n1zZ9EA4NNFKRurL088zS9LYXM3BAmOw1Hu/qzGM87d0qX4NctduUTsXS26F5ublUkdGOzfPsLL5pIBCISxK1QdTGyQxxB1wlRN+FxphPJ89FSGq3aYZR9UHlc+9rt3qQh76v9mVoEJwSbSHpNDhWgjIdNotxl0TWtYSvOLK6zwbENDRf95DRKkZc/iqaLj2gcaCIJhiJ22k6PTcQpzMbEXhVTZsP4ejMYi6J1DdGpVhKp2GfmpVS7ag4SwJ4gzmm0WOWs0qbOksVOcLxW/8tktUz35i6VGGqCsrY+88AFpbFntnqOXM5Ln4iCytzkVLxCdFP/t5jj0XJ2YgelPPzvEurO8SbSRW8nC5WyK7QWN143oCAyeOzaaZZBnGRHbZgQyY6FK
 /dYb0zBK
 IA8aRgdBaZKbC3oCXCVf2dvozQFBuzoePJRkh/tHyVYTJUlmvINLpw23eOQUDjz5RxZ2YkoW8cCFFohtgVnVc1EXVUSRvPGq8Ms/Q3LqMAOfTYEPlkEINaQ6KoYw9D3Td0fuUvsWxzrpm1LS3Rpr4OBqqSSfsdGoQMHcXQ5vvEc6s8tyewX4dTm3Fa7bgKrb9alCrDRTl7TwYEULmnPMOCdYzWfziXZMDosWSYfPQL6YBK7s7Snho44AKICQzcTDyiJLc5NmCwySkEEUoWpN8PgwGBv3uJj7THa7Tg8GV+mKx8PSzc+RMss7bb57eHHDKZghpBerTCfD+St21bNG93u/QoqmWP8LNLpgRVla+eSWrL9YD+fdkaI/JOJy1k82M65wa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm a terrible person and it took me way too long to get back to this :(

> 
> You make it sound so easy ;-)

Heh, as long as you hold a folio reference it really is :)

> 
> If we don't hold a reference on the folio, then the folio (whether it's
> hugetlb or not) can be split.  And then folio_test_hwpoison() can hit
> the assertion that it's now a tail page.

Right. I am/was missing the connection to "generic_file_read_iter() in hugetlbfs".

> 
>> Then you write:
>>
>> "This closes a gap where a page in a previously-poisoned hugetlb folio
>> could be observed to not have the hwpoison bit set."
>>
>> When does the race you describe become relevant? When freeing the hugetlb folio
>> or when demoting it? in both cases, we should be holding the hugetlb lock that
>> nasty hwpoison code could sync with (if it doesn't already do that).
> 
> Before this patch series, we don't always hold the hugetlb lock when
> splitting a hugetlb folio that contains hwpoison.  And we don't want
> to have to grab the hugetlb lock if we can avoid it -- unprivileged
> userspace can hammer these paths hard, and I don't want to see this
> lock be contended.

Right. But doesn't at least the pagecache always hold a folio reference when
testing for hwpoison?

I mean, there is other code that might need care (PFN walkers like memory
offlining), but I was surprised to see pagecache code require a rework of
lockless hwpoison checking.

I'm sure I am missing something.

> 
>> I can understand that we want something that covers both scenarios: an
>> indication whether any large folio has any hwpoisoned page. Such a unification
>> would be good.
> 
> Right, and after this patch, we now have that.  Any unknowing part of
> the kernel can test folio_has_hwpoisoned_page() (assuming it has a
> refcount on the folio).
> 
>> But then, special-casing hugetlb *again* through folio_test_huge_poison(),
>> that's rather odd, no?
> 
> Oh, I'm not happy about it.  But we need an atomic way to determine if
> a page belongs to a hugetlb folio with hwpoison detected.  Short of a
> complete rearchitecture of how we handle hwpoison, this is the best I've
> come up with.

(did I express how much I hate the hwpoison infrastructure and how it's racy
left and right? :) )

> 
>> (what on earth is "huge_poison" is this supposed to be "hugetlb_poison" ? Why
>> "poison" and not "hwpoison"? Really odd)
> 
> We're inconsistent in our naming on both of these things.  It doesn't
> help that somebody decided to reuse the term "poison" to mean
> "uninitialised struct page".

Right, but let's be consistent with hugetlb and with hwpoison. ;)

> 
>> I'd expect that we actually get rid of folio_test_hwpoison entirely and
>> exclusively work on per-page state and has_hwpoison. But IIUC, now it's some
>> mixture of folio checks, page checks, folio_has, mixed with some hugetlb oddity.
> 
> If we could get rid of HVO, we could do it entirely on struct page.

That's what I hope we will achieve at some point.

> Or, as above, entirely rearchitecture hwpoison handling to not be based
> around pages or folios any more.
> 
>> I am not quite clear whether the change you propose here is actually required
>> for the remainder of this series?
>>
>> 	[PATCH v9 00/15] Use generic_file_read_iter() in hugetlbfs
>>
>> IOW, do we really need all this hugetlb hwpoison handling just to accomplish
>> that, or could some of that (bigger hwpoison rework) be done separately?
> 
> Blame Sashiko!  I'm going to ignore it in future, but it's really good
> at nerd-sniping "hey all of this is already broken and you could fix it
> as part of this series".

Right, and this is only the tip of the iceberg, because the entire hwpoison
infrastructure is a complete hacked-on racy piece of ... engineering excellence.

To summarize my question: is it possible to separate for this series the
pagecache part (Use generic_file_read_iter() in hugetlbfs) from all the hugetlb
hwpoison rework?

OTOH, if it's really not avoidable, please let me know.

> 
>>
>>> +/*
>>> + * Since we cannot split a hugetlb folio, we want to insert a poison
>>> + * entry into the page table for the whole folio even if only one page
>>> + * is poisoned.  Otherwise, we've split down to the PTE level and we only
>>> + * want to poison the precise page
>>> + */
>>> +static bool ttu_create_hwpoison(const struct folio *folio,
>>> +		const struct page *page, enum ttu_flags flags)
>>> +{
>>> +	if (!(flags & TTU_HWPOISON))
>>> +		return false;
>>
>> Why not keep the flag in the caller? Really looks weird given that we have two
>> users and one of them doesn't even need the check and must fake it.
> 
> try_to_unmap_one() is already 200 lines and contains some tricky code flow.
> I'm trying to at least make the problem not-worse.  I think we should
> pull out even more code into helpers, but not in this patch series.

Note that this code now was partly reworked such that this helper will soon no
longer be required.

[...]

>>> @@ -2423,7 +2436,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>  	struct mmu_notifier_range range;
>>>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>>>  	unsigned long pfn;
>>> -	unsigned long hsz = 0;
>>
>> While these size changes are reasonable, they make this patch harder to review
>> and are not even described in the patch desription.
> 
> I suppose.  Do you want me to take them out?

Cleaner, yes.


Again, sorry for being so terribly slow.

-- 
Cheers,

David

