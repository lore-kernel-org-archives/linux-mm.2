Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC81606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a4iMyxMc
Received: by kanga.kvack.org (Postfix)
	id A6C836B05B0; Thu,  5 Nov 2026 15:31:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C8B6B05B1; Thu,  5 Nov 2026 15:31:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932416B05B2; Thu,  5 Nov 2026 15:31:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61C8A6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:31:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 924C3160C17
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:31:20 +0000 (UTC)
X-FDA: 85402210320.29.8CE068C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A77BB40016
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:31:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4iMyxMc;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793910678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdhuTks2opBXvdhTmIB8yv80bnVd5dlxad76wxXRLWI=;
	b=yQ6YqcY2eFAGkZk9l2AMs6AKL/hVyBwxMmSguMoDLQWMvHH0gS6t4zREmqpBNSOrzCHhax
	7c5Mv9VDPTIxkbdEmpCwNZUosOc8BCs7xrRVPqzjReIEj/2HIbTBVIV4zkFPk3iyrVxJyr
	1dK/GoJNiwwCTUey9fjIyOuTiWoibYw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793910678;
	b=p4pHyroxurC11EvLTEqiSG0Cc98kCSGum2ayba/8oLFB6bgzFnuTSvC0LL4ZfmVAWbdM41
	RJ71rL1N5tOr86TU9I1bFesy5PAckCQOLjezTV5vI0q7shZU/l8CKJc3VMWdThWPhUmif6
	uVzH9mdS+YssbXYIrupnJ7a9Fft0KD8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4iMyxMc;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D76DD43E1C;
	Thu,  5 Nov 2026 20:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BFE1F008A2;
	Thu,  5 Nov 2026 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793910677;
	bh=TdhuTks2opBXvdhTmIB8yv80bnVd5dlxad76wxXRLWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a4iMyxMcWpMfFTfJfNIxFDxA2rvaiekwJvEwJVsD9AgMRJYdXpBXRleMgAFa6IxCh
	 FxiqU8rJv64UEvYRZ/6gYYVbzscWelg+mWv6Rxml44hPWU7nbHgAHW+v4VYvIkPkV/
	 jrzS2BWYyBBEhdTGjYy+JSwh3g9ayrWo75JJNUfN3IjmNpC5TetPa3YBI7J/+aCUtz
	 nuds2tJ1nAwIwPSzDtyMCHzmRlVcDD71BoLwOLZUrwm7nw+6xozQ0y395XW5qmFo/Q
	 xefxjYblhwNI3XBSZj8pucJn0jKefeiSb46zGHMzeR/nBVDl3ee61bD0gtDrlU+qrF
	 qUHeYhx3uhbZQ==
Message-ID: <6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org>
Date: Thu, 5 Nov 2026 21:31:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: Zi Yan <ziy@nvidia.com>, Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com>
 <20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-1-2828fe5a51ed@virtuozzo.com>
 <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMNK05HCXYUJ.578OO1NG15LZ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A77BB40016
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9s1gy7bmaa6uij54drfd7t4qsiyezfi6
X-Rspam-User: 
X-HE-Tag: 1793910678-445081
X-HE-Meta: U2FsdGVkX18OOFmlUohhwImQJX4+m1KheaG0BrvO47r6oFHqKSsFXI38Caff4zetbEOSDKNRkXZxMb0ANU55fW+PoPZLLT7jQff3OKPaIfopLY4XyvQA+3TFsgoYIUM6qp/UDkrrLyihWpKcAALcqrMjPL7hf+Ehq0kucp02zAFBkLHBHARcsR8M5VfDhHJiRgxS//sk+c616MCKTYPf7+9dxAV9Y7IVkWMZXZyAeSvFFqEzs7ch5MUMBWI8Co+vURYlPtDHBXv/uJWvkWXbGM+XAduEBa3PHpjGETmNrWUwNbV4SlA6wlPqdw7WLRdtGJiQ6wZVwPqkm9vTCFao8vYG0Nyq7AZ7mHH2dOym9gbIDnuCI+BEAY62FICLJXHyW0VvrdTclwuEWNoSJ0MVQ4gZaTRlpnVBS9NVkD9pUK2Dz9XQcQPIkh4euNB1D5UeoKV7r2df/E0BsqsexvGOvZ/0TNK4XR57d3EC1/szniWKIA1EqVSSbLx7L2cWPRwpVl2P6mL1OadSSqDraiMOW5zEvDLRRtqmg0kdOEp4x+E2/9AN+50UamIIx+1u3rrUpv9goIiaBLRg/xGn06QB343+LwmVCZxTbKsfwsgPq626wIM0/jPPUXt2Vq059eXx4aSF0vgsYX2rThTIRWAoSplCo5qmwvm6VgxPorpQ4EX1kj4g8z/QyyVIDnVbFw/GkJM/1tOWu+73LA/hFjxhN/WqxRQjxj1DAsUsyvtTVpmdLqB15z+APl0Zi0KwuXXIZ4QGhj4GlSC+m9joO7XkZn8ZBEXWQp2o7JdDOo8r3J9coTprb1eACE73a9Gx3UdOsMdbeNhwRFbpCm/0im1vGtLRqnL5UZFT7Ti29nx/drcHodEp1yRetUVgH5jOtoUP0zVGOjHH0dzYUNEkSXPc9pYnNbyzorKZi9lOuinScZm2yfEcRVJ2ZmJC25FPBK7nnrvjweIHXNfjh1bZ/SK
 wLA893ue
 8QPXVeIE0TPUWANs2abq98UUH06IXUNY5843kZmaM5aROdXm0OXMuvS1mCdFjfmGapRyTOuDNDfbmwNRgWbdPgiZRiO5kX2BBtOgYFqM63IXFfoBVW3fR53d2ybAlwKtDcq9IojO5aJBBWnJa7udyw3IBOQBbDQJPT+SM4edeCvfXdKuII/sK9QcFKezrgdQ40zIAUGbDCBerRAZ1BJcf9OzahUMrOQppfVWFZz4l4fi61zwXw4QRuO+g2EVt4ic/+hh1mn5RhC5aUBsl+fCTHUiMlIkfYbDJLb0gcEzjBNgfUTfqiCtrdM/P/EPtzKr6HhzQV1WjmwD7HaFT2FHjneWw0H6BfHx4G/5+RMeAQq3ppXUOgc/vD0yKJNusdj2NaXr+r+Zt7HN6nmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 21:19, Zi Yan wrote:
> On Thu Nov 5, 2026 at 12:00 PM EST, Konstantin Khorenko wrote:
>> Device DAX maps its memory with vmf_insert_folio_pud(), which takes a
>> folio reference, adds a PUD rmap and accounts the pages to the mm.
>> zap_huge_pud() drops all three, but copy_huge_pud() copies the PUD into
>> the child without taking any of them. Each child's unmap then drops
>> what the parent took:
>>
>> - the folio is a reference short, so with two children its refcount
>>   drops to zero and free_zone_device_folio() runs while the parent
>>   still maps it;
>> - the child's file counter goes negative, "Bad rss-counter state" when
>>   its mm is freed;
>> - the parent's unmap drives the entire mapcount below zero.
>>
>> fork copies the page tables of a device DAX mapping that has a guard
>> region, and commit f807123d578d ("mm: allow guard regions in file-backed
>> and read-only mappings") allowed MADV_GUARD_INSTALL there.
>>
>> Take the reference, the rmap and the counter for a PUD that
>> vm_normal_page_pud() resolves to a page, as copy_present_ptes() does for
>> a PTE, with a new folio_dup_file_rmap_pud() helper. copy_huge_pud() now
>> needs both VMAs, so pass only them and take the mms from them.
>>
>> Fixes: aed877c2b425 ("device/dax: properly refcount device dax pages when mapping")
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>> ---
>>  include/linux/huge_mm.h |  5 ++---
>>  include/linux/rmap.h    | 22 ++++++++++++++++++++++
>>  mm/huge_memory.c        | 27 +++++++++++++++++++--------
>>  mm/memory.c             |  4 +---
>>  4 files changed, 44 insertions(+), 14 deletions(-)
>>
> 
> I assume this supersedes David's version[1], which uses
> folio_add_file_rmap_pud().
> 
> [1] https://lore.kernel.org/all/20261031-fixes_core-v3-11-d6437171ecc3@kernel.org/

Ugh, I thought I dropped it to wait for this one here. But turns out the flood
of patches confused me :( (hoping I didn't drop another one by mistake)

It's already part of the fixes PULL request:

https://lore.kernel.org/linux-mm/20261105084704.5703-1-david@kernel.org/

Konstantin, sorry! Can you send a follow up to introduce+use the dup variant?

-- 
Cheers,

David

