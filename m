Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA93CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C466B0095; Thu, 18 Jun 2026 05:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263936B00C5; Thu, 18 Jun 2026 05:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1536A6B00BD; Thu, 18 Jun 2026 05:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3090E6B00C5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:43:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6C2D1A05C4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:43:22 +0000 (UTC)
X-FDA: 84892545444.13.EF3418C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE5F240009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:43:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrDg8s7v;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781775801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ+WWK/EtN/+c7t/LuN/tcS76BgfUhzIxVF7vA6SHLk=;
	b=DHM4gH6km+/D7nlpOa5OO+rOBNoQOVQuBSO5s6gilX/lcjF2a5BGOdibyA8f08xtM79DoZ
	MJA89Fnsao6KKrsxmR7IMHrx05NAp942c3/nmQiy5SaDQPM8/kL1pLAnbcEKo/xxnObA10
	dqTx1qqfdp9GWPIS0P3tZq9u1c4ySB4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrDg8s7v;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781775801;
	b=MIc2W4dGp0xtRR+rV2IRjAokzOr4d4eZwGSnfDUwrSqAh1oyZqUuOooP1nSS0S7Gakt3P1
	X9zOloJCJf/ffwVZk74N1G5u818ZahfaCAVYd/xKf+v6zjGwKA79mXPAycvbo+jSHYcBHe
	HskMSQ2NyrFgIKLbqSIXTJXaIQWa5qM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1239243E2E;
	Thu, 18 Jun 2026 09:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB9B1F000E9;
	Thu, 18 Jun 2026 09:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781775799;
	bh=LZ+WWK/EtN/+c7t/LuN/tcS76BgfUhzIxVF7vA6SHLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FrDg8s7vhYdjTv5G4yrao0SsCIYEHjftwZKQKVQTOCNQooQkUEijLSR0pt7xW+ss9
	 baud6F/09FvIiE6d9bL5GVO/ApYEjz9F8G2wnjh84LB9l4gix+y6bQaYXNWWkzQTso
	 8Mgpjsn85i1Tmheg/gvwQJQrs9Z/oWU2fGVNob3oj1du2bG0Tdz/xR+xnAje3K5NZS
	 +BwHU0zkb+QINA+rNVTFn28PBiQC8rghVMqnWR10xES8fK3MqF/AQwofvrH8yiejln
	 lkHeMuk/GdC0haSzwiBpkgDDE9TVQN9qfh4gVHwNf4DaA+22tWY190rC43RIQabpqi
	 z6KJ+74E4TslQ==
Message-ID: <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
Date: Thu, 18 Jun 2026 11:43:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Lance Yang <lance.yang@linux.dev>, dev.jain@arm.com
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE5F240009
X-Stat-Signature: gpoxgns5ge8s1u937dmryqeumccf7fex
X-Rspam-User: 
X-HE-Tag: 1781775800-637211
X-HE-Meta: U2FsdGVkX1/2bi96P5igPlWKs4ZAYk8IptbNQbJ7JjKXSxM2dSXSJ7M6TOmzAb1vSK34R0aGK60VwXFlpsX3A/OJ6RUMzxtgD7UT5h9D1EvrjLbm5BUoRFo+xiJ/7Fpsnwlf/KwFngNTkAsIxx1/4ImV6aXf86jw8I+c8xVHU+rSuv6FF2uyQu32SRAcmEulTBb0u2wQmtGR44U5CweaQVEBEwlPoqSbEGHJOmRfg3tYgwlzC6wfJDSrgfs2SuubyLOKRuu9QqnoSdBuTHLr564BPWc8J/sF44PbO2Iv2mEz3C5wjoqRbncnbLdWFHtbQgYYedx3GLS2OkEDgfTwJWjQlLhaAl44AIuo9erdhcEoqY50d+Wwetkk5VLuV32njeZG/m+JYPhjJGRnRFIcxGD2ym5xz8UCtPWmNqt3DSfAbQv536Jb3KyOe86hvslzFw5XYSZ1bMz1Qs37a7KouspcuL6f8KbMq1a/u4YA5PW/Bxsas9I1P+2ujyCMekYoZEfO8fdPpFZ4E0r8mkYRFkNw8zXFKUqp/K97uQXY4T7ZB9cv2MG4/viHY60THWFFNWpgyQ+5lQymiCrnfPtN4tKo1c8tO+gF8ES7VZT8kYLcvmiFQ2Z31vpdzgJu6mMwrAUztJ4V/3LsrMRxVLjq3gb6zEgYstBVQuErMRwmXx0YuFb2v/TDw/pnahlxxNcNU5hLhTiO7Tn8W8oSf4Of+vzG5bQHkhKGjGeE6gV3vP/5/p6MA4j0he5crv/a2jQEuKIqeEIZeZWrjoPICDSKdxeoMsCttCR11oPR7+QaH8Pjx2rORPvdkJUk1flHCLU1cUmUQBne6GI5/A2jLayzhDuxtNKQ25FCRjm3HqZy/Kc3RXpPfYQQ+i+ejGqh3Nr3DY5wUP/lheUSU0oekP33b61Qh3XbWFf5ysEUxMhOCGforzLettbWiU5odelYc77PBvti1PYtRpkxJ4md8q/
 gmGgS5ea
 hWAQ8A8ghkDXlFT1MmaEvQhaC25D4jsTbIP7p01TwMN/jkoyErbXsDRYVkDiq9jA+3x7j9XSNxwpuZcFh15ULug7vsoHA+7B6EPxdYD2O+MOX/lFKQ9Wy2RLC3EoPiRQ6Q+kKeSBZ3kn3ypRC3SWTEmVRugvCVWfU4jCwaWOaYbK8J6hE0nzrlp2ZoGbI/anZxS8Xf2kPj4wZswvm9BPIbl/BcjgilenYWPLXBmJ2qU6q3ltHZAa95+9nXE6lR8YUw0ubb213hpqgn0Kns/d7zqyxBgJdstpTRVwNSJjnZG5sSerp8vC4oF/Vk7L0D7JurOtOg30alEYhwlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:09, Lance Yang wrote:
> 
> 
> On 2026/6/18 15:55, David Hildenbrand (Arm) wrote:
>>>     return __rste_to_pte(pte_val(*ptep));
>>> }
>>>
>>>
>>> So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
>>> derived subpage can be wrong.
>>
>> Good question which impact that might have in practice?
> 
> The subpage check can warn, but we still pass that subpage to
> make_hwpoison_entry(). So the hwpoison marker can end up with the
> wrong PFN?
> 
> +    subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
> +    VM_WARN_ON(folio_page(folio, 0) != subpage);
> [...]
> +    pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));

My s390x page table knowledge is a bit rusty.

IIUC, it would be a problem if some PTE bits in segment/region entries (pmd/pud/
...) would pass the

	 pte_pfn(x) -> (pte_val(x) >> PAGE_SHIFT)

check. I don't think this applies, because

While
	#define _SEGMENT_ENTRY_ORIGIN_LARGE ~0xfffffUL

We also have

	#define _SEGMENT_ENTRY_ORIGIN ~0x7ffUL

So these bits are not actually used.

What __rste_to_pte() primarily does is reshuffling present bits etc.

So using any other bits besides the PFN would be problematic I guess.

Am I wrong or isn't the present bit already at a different location? For
prot-none hugetlb folios there might be a real issue, as the PTE present bit
corresponds to the PMD/PUD read-permission bit.


Oh my :)

So yeah, we should probably fix that ahead of time unless I am missing
something? Good that we separate that hugetlb crap out.

-- 
Cheers,

David

