Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE93C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0896B0101; Mon, 29 Jun 2026 13:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91E56B0102; Mon, 29 Jun 2026 13:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980696B0103; Mon, 29 Jun 2026 13:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 662176B0101
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:44:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA7061C16B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:44:00 +0000 (UTC)
X-FDA: 84933673440.13.DD4ECDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBB0AA0008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:43:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMBCmM6u;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782755039;
	b=LwAPoNzEfyTT66XMfM+UwOqJg8JcVspYpblH8lZA1J6x7biFe04CzcR9ec+pTXNVMOoU25
	qs7mW9iUXPHuNiL0BpZ69vlagA6zxT4oHzSbxMiL3V74pMkmCakxKa7jo8FRS93PKdi7lK
	4meZg6YejCJ8QY05Fb0wGe3AnIOGBWg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782755039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNPWUj0b3dpxJFm9DmiWQoTjCiuvhdzLK8xC9ADnE8o=;
	b=ljZ7EImGVO9weIvJd33bptEO6cf9fs7XqQF1gavzUIStJ8adZA4uaVMYRe0u06t39gp9P8
	shD//5/8voNb6gBtCuy5IqUIVflz8ZVxKA1l1DL+ZDxAwpUg37ZNtRKxSX+M1ex0nXyCVV
	ZicxLA8Q87iPL3srg9ObyjAIXMjo3oI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMBCmM6u;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3611541388;
	Mon, 29 Jun 2026 17:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A651F000E9;
	Mon, 29 Jun 2026 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782755038;
	bh=sNPWUj0b3dpxJFm9DmiWQoTjCiuvhdzLK8xC9ADnE8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FMBCmM6uX9VREwWikdZd8AjqjhA0cn8zckZezxCiaDRwpSVAuFWVUsl7qw03ZO1Hq
	 O40u+9Ah0zciqqs3VgdDdNVUFsHXteukIHLzAm0/rSDQzzzAJ1EfJEalXtLOZYDTe4
	 TsRC/hFucqYfARZ4BGTVaoMkXlPVDT3WIBdsq4bB8ecDMYMcBFzPHuUS7vSTgQyV82
	 e3e7QmolFwS1AZUMzBVQjbX4C+K4Mgv3wroJoKMpxvEfE1BUXOBzzl5w0F4vcXxE8Q
	 GDdkUQxFMLe1h1Pl3KtE1y3UtvsCeWMliEQrBJxAzME36Iz+vio0+BTH5F0NwWOZh9
	 ZaTbQWxQjPVdA==
Message-ID: <fd1b4199-ebbc-420b-afe4-3bea4b9149fc@kernel.org>
Date: Mon, 29 Jun 2026 19:43:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: drop pte_clear_not_present_full()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
 <20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
 <20260629102215.09605f0e9ef66c5f58fe0932@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629102215.09605f0e9ef66c5f58fe0932@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EBB0AA0008
X-Rspam-User: 
X-Stat-Signature: 897mtw1yth3641yi3b39x65dgo6pw7q1
X-HE-Tag: 1782755038-870306
X-HE-Meta: U2FsdGVkX1+twH+K23J9P7MzkiKEAKj2Q1ZnMMrlO0XOdLGQnWrc8m2/L1mzb9i+3/CyBPXMjLXijkQV1Wqe8QCbqXvHKbTnYPr/As8xKl94MWC7Yqb9uPV1rbXNi4Zdv/f17gP/5BaLYzlH5K+6pw2aEzaZPMAU1e5G99YtaqDAS1J83Vqqslfu9+od2m5tE2Rt+zf+Upj+Dv6vkww4BnNim3Ds5GLEEqmlVXZ/leBrEAIjfhYKhjaksIZSrdLwhGPXIMJWezvyDyriH8m/hwF1YNgmz/sxG8OCz8YGTrV8xYlGqz6NHiBvSI0GZzRgHz9mIaw4E/jOxO5TapIAaiWG3a+sAWx3BfvacHgqML4FXppM/ND5QYCCUlGpb0VXRug3PYgoG4VlzKymLjZJdci6RdwOqYJuxiyWOQlxYSHbJjqySIs+SLe0+pK//G7oBWiPHDriC2sIFQR0UzFXPW8vqTqgSZsN1xQko7EETY7ljnTEFi5fZ7B2mfFER5nHxxEVAGbcjn2+WNMDynMD8G1cnHp47c/llq6q4gn2sIYYBTmChSPqdaiV/cDFC/Mrydw8BBWxZNNxtKWxf41MMNZ21wMU8POZQeWMYPV5apl8FrPJmFL5D7YYgKzJQ2AvSq49ouxA+r7zJanqYx3NFkAi2JlZwVBSICVMDPSyv6Cov5RQ5pETZcL4AVpBA314M6GpvhZBGmm5egUW/7HBci4E6p0oihxEkAZGQk+WLiirFvIM1L7xnSrtxACah2fOfpmJdqJGW6z8bmabCg/IdK8Dyca2PmwxMSv74HQDRx0HLmrJyGHH5OIx095txNzSLBEC5MarCJVgfdPbvUYKcfAtd90Sw5YqnG3enGAO+lh3o463f2gXUaTw+vSlo8wqik5zSt9gp2HO8CHcCXMVksJy103C0khc3xAZ3WuK9sOnJNq2kOVP5dnGPdbt7ySLnCaIj+T37SvXEN9Zn+D
 904dCtv/
 G7YbNhsNGJ7hy9E+eu1CEZ+kY5hK+ARo2iNLhDRvHtMmarG8bHGI0ghmstK7q8aDSEFBwJzmeQp+vXQIHuF0VyRxN3G6TBCpnHtWY+B6NIWz1tB9n1XtSF1aVIgdp7MNiD4htajvwFaqLXe9g71TUAshXdaaUVnJOWiaiia//QaOIeyV+iruNtDOP4x1FKekhWVBSFzbJTih/zOFq3ovbEH8ReqNn3MHNQi7K3jeH+ge4c3ABuHHzCbmh6qrAZlTAGyS2lCdz8SZRLyqGOQN6bLSEpx5KbPYCevKTU9RBwLo+KaSBiISk5oBCMoO2no2np9bQJCdWrMHhpsDTOCfELMI37AQgGKBzm0rY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 19:22, Andrew Morton wrote:
> On Mon, 29 Jun 2026 15:49:48 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> In general, there is no good reason to do anything special when clearing
>> non-present PTEs.
>>
>> In theory, HW that does have to invalidate TLBs for non-present PTEs could
>> benefit from a "full" parameter, but fortunately
>> pte_clear_not_present_full() is not wired up anymore ... and there would
>> have to be something very convincing for us to care about that to re-add
>> it.
>>
>> So, let's just use pte_clear() directly now. To avoid the compiler
>> complaining on some configs about unused "addr" parameter, silence that
>> here.
> 
> Wait, which configs do that?
> 
>> @@ -1022,8 +1007,10 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
>>  static inline void clear_not_present_full_ptes(struct mm_struct *mm,
>>  		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
>>  {
>> +	(void)addr;
>> +
> 
> We heavily rely on this warning not happening.
> 
> eg, one of thousands:
> 
> static inline bool page_range_contiguous(const struct page *page,
> 		unsigned long nr_pages)
> {
> 	return true;
> }
> 
> So... what's happening here?

"nr_pages" are not modified in the function, so the compile does not complain.
See below.


A private build bot barked at me after v1 for

	arm-linux-gnueabi-gcc
	openrisc-allnoconfig
	um-allmodconfig

For example:

https://lore.kernel.org/all/202606121420.Wke8Ipgx-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kasan.h:38,
                    from include/linux/slab.h:264,
                    from lib/test_bitops.c:12:
   include/linux/pgtable.h: In function 'clear_not_present_full_ptes':
>> include/linux/pgtable.h:974:31: error: parameter 'addr' set but not used
[-Werror=unused-but-set-parameter=]
     974 |                 unsigned long addr, pte_t *ptep, unsigned int nr, int
full)
         |                 ~~~~~~~~~~~~~~^~~~
   cc1: all warnings being treated as errors


The problem is that addr is updated (written) in the function but never read.
This becomes visible once pte_clear() is a macro instead of a function.

	arch/arm/include/asm/pgtable.h:#define pte_clear(mm,addr,ptep)
set_pte_ext(ptep, __pte(0), 0)


"(void) addr" silences bots. An alternative would be to find all such macros and
convert them into (assuming inline function is non-trivial)

#define pte_clear(mm,addr,ptep)  ((void)addr, set_pte_ext(ptep, __pte(0), 0))

Something I wanted to avoid for this simple patch here that just removes one
function indirection.

-- 
Cheers,

David

