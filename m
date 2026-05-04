Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E3FFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A1E6B00A0; Mon,  4 May 2026 04:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF24F6B00A2; Mon,  4 May 2026 04:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07AE6B00A4; Mon,  4 May 2026 04:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBB906B00A0
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:52:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA31AC1BB0
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:52:12 +0000 (UTC)
X-FDA: 84729120504.23.0510008
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1120618000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:52:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NNK2jSQl;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777884731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEyeAUfJQW8Kt1Ng6+Xlvp3Ie550ZOIsa7l52iT+Vyg=;
	b=4fUpnYJ0CM4W9lYND4J5J0OW+BIXufdZH4MepmhkkF4SUBwzSqPnS6zaWb5vX7RF9AsnpT
	jUwnvuqVgaVgf2uS/mAOfnBv1qoP2+o5VwnSIFyivIuE1PepBRUhyBiH0GyaKiHDnXOHrV
	pOI5kN4vNv8ED8NZyQYppXQ8XBDvio0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NNK2jSQl;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777884731; a=rsa-sha256;
	cv=none;
	b=WPjWic10XYNrbpxGnXJEOT59aEOGGP3oJuOnn3OsT1khiN+PlYwX4CQpGfCAr5C/CY1ui3
	UDkm09Li9q1K2/zwMNUBwMvhy9voz2v+/sW0m6X96I9Z8GsUvgODTYxHrqA5OCojSRS5bh
	kI9eqZXjIk5acxlYl3OVoHJxx0NnUWc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C45251713;
	Mon,  4 May 2026 01:52:04 -0700 (PDT)
Received: from [10.57.34.72] (unknown [10.57.34.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 753B83F763;
	Mon,  4 May 2026 01:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777884730; bh=Bg78KoT8CemEyZViwGh6uhzKeqfwdHIhOCQAX57fvRo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NNK2jSQl2B1FVgfn2NY38+h+ww+DbMNckBAn2S5WShSlWOVB0HBAEnYt4Fe7b6x8r
	 dxSgc0GWneyT0Czpajo6Kg4LAJHpFew1oH5j4LCCUImRsL01mFadAPdBOU2JBaDpev
	 sv3EtzBHR9deCjHx0SIYcZRxWDBCuRlBTCHUr4bA=
Message-ID: <4f50dad3-76a6-4117-b5f0-d939c6e551f6@arm.com>
Date: Mon, 4 May 2026 10:52:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/15] arm64: mm: Unmap kernel data/bss entirely from
 the linear map
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-30-ardb+git@google.com>
 <15555e9f-65ab-4811-b20c-8ada90bdc9d0@arm.com>
 <5279ea66-0e31-4f53-ad76-4fd8ebc012fc@app.fastmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <5279ea66-0e31-4f53-ad76-4fd8ebc012fc@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1120618000A
X-Stat-Signature: nngci5jo4ehxzzz6f7858h78y4naqkrf
X-HE-Tag: 1777884730-484069
X-HE-Meta: U2FsdGVkX1+rld95dL4LE5ngLRRskWER6iB/uMj90hmtWYoAdtvSnb1ofWBO9lgvwc4JjyBgYfw7prRtBw9Fxq/0ybZ+EwjxvAr4nK11SeosPjJXf7OiYmMkFz+W+ziql7wNYnGzMNWtWpBjVJKwvamX9OqI052mbmJLTb+d9P/QpwsJ3VWOhVT9cggBEY94p8osy5JYXqh2bqe3XII5oSFZ6p358CBgChEx2HahjSQ7fkbRm2lBiykTitzCgFUzB6G7WkabkxH6G3jCSkErJCYnzxtSNIWsq4xjojGLziWJ2UNg0+7WoxIVkHDGXeu0n98XHIdBZZg/zmbIg8D2JkjbksSODJkb/BXO58wutgzEG9/RdVvaG3VzlS+AKYh2q6bY7kMeBWxDcQtXnAkhGqm/lgWEuYCYS+klZYcxB/9/7htwbn9FsLpozC7mXi/I1YU9xh+EBFzInCScc1oIpN0U+mI5fWqtk/1WfuWAIS+q9Y9qHSv1B7bngJp0AdVvBrkkkhVUDC/3eUjjJEceTVZZsAGiJlozNneTgcT86f+RbKbF6dy4VWSQZ1EP6C1C6jSGk8NJwf6meegkuCmYsg1qc6shg+PFPMoAmjNZKLdAEZuSjiJFt1dGoExRW+5OGB5fDp2YhE2QXWIhAg9p7DUyZ3fnmb63IblM3VI2bvoH6HnxJSjc1o4h+1Tkgp2bzfFjP4YbfQe1qI0X/6XWIM3ftz0TQ+5/0cHzSHwesLhWDFYHkDpMs6UJ4AGuXGUExgkk15ZwEIiUYxks+fS8fos2ncW7LIKFVj81mRtN9ersnJYODmuugbSxjLlX14QQmiEwdWcTzQSxsJyF+hiJUCV3KAIyNe5WNqnuh2zeFgnS5Jp1LIdqcWTw5ej+H9O5cWUU+R/0TfJonWsiOwXD0GrVnk80U3mArUZDEuAW0qL4zYfbW1eCuuoBvWqx+C98cfGMmQ9GtbU+YNGwLXC
 c5F3Ttgm
 UhDTfOGybqFPo97KLnZQ02j8KkquO0LG80ptLvxseJ/CIS1TPCx5it3dyN17Z0gBQkD2CfEmFr1S6GL6b4SnN2b++wPYlzR5OgVEfmnSONYrcH10b8dd587K76T3W/JvgM4Xifv8Tw0inv/SvxeNV+joL7iHYSJ0DrJXZL2uw7W5zFE0qYs1ICrWdS95n8DTeadAYMm0RNAPpvSPYqKlaUJMWfL+0W6b4Yh+2Yt/dLyWzkco2tQPr8AKrWLyOmGJguJqXyjU0PXcafl9YeCbe3fiqNbVuI26aItdBA/Gkte49Z46oEBKONMVsHA0oaxdoN+v2HZgj+v8FPCh0qxEqkP6/tke+4hEMKWjB2dslhZy60F6R+j99QYTTQRVF88mNVvjwk1HIKhdXRsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/04/2026 19:37, Ard Biesheuvel wrote:
> On Wed, 29 Apr 2026, at 15:55, Kevin Brodsky wrote:
>> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> The linear aliases of the kernel text and rodata are mapped read-only in
>>> the linear map as well. Given that the contents of these regions are
>>> mostly identical to the version in the loadable image, mapping them
>>> read-only and leaving their contents visible is a reasonable hardening
>>> measure.
>>>
>>> Data and bss, however, are now also mapped read-only but the contents of
>>> these regions are more likely to contain data that we'd rather not leak.
>> That sounds like a good rationale but I wonder, is there anything
>> stopping us from unmapping text/rodata as well?
>>
> There is the zero page now, which may be accessed via
> 'page_address(ZERO_PAGE(0))'. Also, anything that dereferences page tables
> (like /sys/kernel/debug/kernel_page_tables) will expect to have read-only
> access to swapper_pg_dir.

Isn't swapper_pg_dir always accessed via the kernel mapping? If the zero
page is the only data that actually needs to be accessed via the linear
map, maybe we could move it alongside fixmap_pgdir so that we can unmap
everything else from the linear map?

>>> So let's unmap these entirely in the linear map when the kernel is
>>> running normally.
>>>
>>> When going into hibernation or waking up from it, these regions need to
>>> be mapped, so map the region initially, and toggle the valid bit so
>>> map/unmap the region as needed.
>> Doesn't safe_copy_page() already handle that? I suppose this is an
>> optimisation to avoid modifying the linear map for every page, but if so
>> it would be good to spell it out.
>>
> Uhm, good question.
>
> When hibernate was first implemented for arm64, we had to bring back the
> linear alias of the kernel image, and when I started working on this, I
> hadn't realised that we have safe_copy_page() now which should take care
> of this even if the linear alias is invalid.
>
> However, if I remove this handling, things breaks mysteriously, and it
> is a bit tricky to debug so it may take me some time to answer this
> question. In any case, I will address this in the next revision, and
> put you on cc.

Sounds good, thanks!

>>> [...]
>>>  
>>>  #ifdef CONFIG_KFENCE
>>> @@ -1162,7 +1198,7 @@ static void __init map_mem(void)
>>>  
>>>  	/* Map the kernel data/bss so it can be remapped later */
>>>  	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
>>> -		       flags);
>>> +		       flags | NO_BLOCK_MAPPINGS);
>> Might be an obvious question but why do we need this?
>>
> set_memory_valid() only works on regions that are mapped down to pages.

AFAIU since [1] this is no longer the case. Even if we don't have
BBML2-noabort, we should be able to modify a block-mapped region, as
long as we're not splitting any block (which should not happen here
since we're always changing permissions on the same range).

- Kevin

[1]
https://lore.kernel.org/all/20250917190323.3828347-1-yang@os.amperecomputing.com/


