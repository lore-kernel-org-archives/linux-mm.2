Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2503CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FC36B00A0; Mon, 12 Oct 2026 09:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00096B00A1; Mon, 12 Oct 2026 09:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA336B00A2; Mon, 12 Oct 2026 09:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 806036B00A0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:34:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F89E140D6C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:34:39 +0000 (UTC)
X-FDA: 85314069078.10.6B9E9F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 34E07180007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:34:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pb2qwS6e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791812077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJoKG/6UOVhJtQlfQRanKoyfmf6h8PW7vA7hrTi9Uzs=;
	b=NWk7PWCl2ZPIHQtoByc2E0JgT+887HbvO4MM+pFgNaK7uzFuzxbxVDLcZH+q/F38fUnMbr
	70CKRTb9dkiO+2aLb+Iw1JYcZPfY79NQjonmcfAOiUxIO1HDFslBxLhoMS4BY4elKx3Ef7
	yDR3GFdZpObH5Rw1c7GBq+1+Y2PXB0Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pb2qwS6e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791812077;
	b=bB63T36Pdz4H/kNEw2JEOHOPHATWwiLdnAwGGbU7pK3kGY6MB/IHdTJetqj5JBscRTVbuO
	F6hitdLHwh0KRLP6R9ybYW+h47ZoLdU7XN8BHlXSRWfhbkQuNWf8ESLLMay7LNycp7/B9o
	1R1zeVC04iKb1RIrA6oHPlHjHfhUlZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71E0A41B5D;
	Mon, 12 Oct 2026 13:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2831F0089C;
	Mon, 12 Oct 2026 13:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812076;
	bh=BJoKG/6UOVhJtQlfQRanKoyfmf6h8PW7vA7hrTi9Uzs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Pb2qwS6eWHO6MPz6e6Cjv4IRYSsPioj8ppCtOqUDgtF5oADW4amg4Rm2d7JZotQw+
	 GFRMFOZog5JGPM/vi3cITAw2xXHYkWcOPUPNdygjRLcToiGgwezrK2esxqasNlm41c
	 1la4YDWxCXqPasGkTAzsjlnXTL7QG0XFmaUTZCWQM5YHTijpXSoU7Muk8T1pOm9B7l
	 ZZHzIWI0J0W7qyl17QBn7c43TRFfYVV3Wlb3cuiMiz0WsECUXjk40joq6b92W/zoFC
	 2Ha28M5aDVhTHoRDPbawlXzi8d0o6txkkqde30XTk7KbDZoIMKa3RK1ttNOfJtAfJL
	 esL/Yl33fruSQ==
Message-ID: <01349eb9-8833-4cf4-bb42-b1d5a608c83d@kernel.org>
Date: Mon, 12 Oct 2026 15:34:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/1] mm: page_frag: account page_frag pages in vmstat
 and meminfo
To: Pedro Falcato <pfalcato@suse.de>
Cc: Yifan Li <liyifan21@xiaomi.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, mhocko@suse.com, netdev@vger.kernel.org
References: <20261010025941.1253-1-liyifan21@xiaomi.com>
 <40fc5d04-2a20-42c4-9557-7277bc981172@kernel.org>
 <asy9PzW41-Wi0JXC@pedro-suse.tail5790ac.ts.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <asy9PzW41-Wi0JXC@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fp7cmusj8b7urcmheh6ffk9yi556bftb
X-Rspam-User: 
X-Rspamd-Queue-Id: 34E07180007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791812077-460440
X-HE-Meta: U2FsdGVkX1/xuIJMqaPMRGtd60xU/F6befQzIxrt+zP/rZJcD6yHzafsXpvA6QNeStfARp5cmgWr//yPds57oVXTcP1KPU+6zBFvzrmRjewCZkFpqcdFGR5NZOea0U6H2n8wiWCxSmgngIH1Brh37ehzJyHz3Ub8KeBwJxbhq4+MPqOZayu+wOAjDZvc+jm9CjTofZtznUKoBygilptS7p/zAe3X5YPxZqChK8MlMYpF2Yy1RagI6ZJA5KHlQN9ryiVKvmSLOWpuL6VLfsmSQH6zSJpwJ1PB0KiPVTIwNy2ErHRNn33XAn6Yw9pjjhMlc9LAJnJM8YxBoLESfyqN4lzMPs58mb6d/9SZAmzFhzLQGfK8qnvZstcid3XfQ1SheMOdQpnQxrg+qium5/Onl2eVP6ZQucMJZuka++7k8gMJOjPozPtnzJWi0ONRlPFk2HMsTJh6QmJ+pM3fH3OI5R9a/Lg1LeEXJv8+pjr/AQLzDDrYUJ4lnLd6b4oJwIajrtNnSrfywRJvXN5yo3zsJ+olv7oqrX7ny84KQaDimNH+u/VWAGfCWuhAaH2xpzlDe0FSteyfBrbIpk95+ZZudcwONudMmmzbjmPV68f589lHuu/pcxkoC8/Exo6X7NDyBKHVj4zMh8nuvYG3XOD3K2jPP2G0vXS3FcIX3CT6tWpOVu25PrklF8dGTFBOU8rl9mXT+SauyxN8D0XZ0aAz9koQo8eDonlk8ysF78pdrzYipexdvB/Zw7pKUY8hDGkijehFUwrVdagQbce+IYsIQVcVH0X2BsIK+ZEgdcsQOTVKaV0EwIxtJFNDJAEGmhWCfq9oXWOzOpkQMG4u/H83UBMyIlDAwR/lijzpI6wXGS1l91+zbYSqrrs7JC3o15mrYwwvmU0uAR/00jfbjPGeNm5Bd38pAUu/iQt5EQtmAd2WrmzuwU1rzKY+ZcbrgHCnb/P5ozkYzeiKm8ciQGT
 X0zSQIJu
 ZP5kLXcHjSnDXvz/N2lFMKaOXN4gZFx8An9NArsFidNMtxsKB4Kh+FH8GTpU8LsJAUbBPOirqeyFvb3PJfxm0NyYVJabhqqpEZ0M6G63YXqUDke0FoZvDvdE0Kfu9Pc1AbVW8w1nAjgQKxIxT21hh9bvJ1BpnwmZlzyF6a+Cbmp/B7Ya+BmZgnVa522qRH0mizA6yQVoEhIpfwesmt0nvZfSKMBtNpSCOplaAqBJUqjgKhbxmzBU8MMt0wioowUriNDYp2jgkC5Fo+fhs7Q6tgwAK+t0zY6p7U1uR2RwctCu6C8r5fOAAuW+r5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/12/26 13:27, Pedro Falcato wrote:
> On Mon, Oct 12, 2026 at 12:36:35PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/10/26 04:59, Yifan Li wrote:
>>> This is an RFC.
>>>
>>> Pages held by the page_frag cache are not accounted by any memory
>>> statistics counter, so on systems that derive "LostRAM" as MemTotal
>>> minus the sum of accounted memory they inflate LostRAM and lead to
>>
>> Sorry, what exactly is subtracted from MemTotal?
>>
>> How would any other kernel allocations be treated?
> 
> I suppose those would mostly show up as Slab:. But yes, I agree the metric
> is a little dubious.
> 
>>
>>> misleading "leak" conclusions, even though the memory is legitimately
>>> used by the network path.
>>
>> Assuming "leak" in such scenarios is questionable, sorry.
>>
>> Aren't most page_frag allocations short-lived? Or is this more about the
>> page_frag cache?
> 
> page_frag allocations are kinda arbitrarily lived. If you queue (send) some
> data to a socket to send over the wire, they are more likely than not
> short-lived, unless the protocol/qdisc says no (for example, you're hitting
> the TCP congestion window and as such can't send more data over the wire).
> If you send it over loopback/veth you get arbitrarily livetimes as sockets
> can keep the page frag alive if the application never reads them.
> 
> On the regular RX side you can also (AIUI) keep page frags randomly pinned
> as long as you don't read them.
> 
> (note that all of these allocations are bounded by each protocol's memory
> limits)
> 
> 
> In any case, I remember an off-list discussion with mhocko regarding a
> downstream bug, where I suggested adding a counter for this, and he said
> networking is somewhat sensitive to extra accounting on the fast paths.
> Added netdev in case they have comments.

That makes sense.

>> Certainly no page flag.
>>
>> A page type might be the right choice. I don't think Willy planned for that [1],
>> IIUC, the bump allocator was something different, but another page type
>> shouldn't hurt at this point.
> 
> A page type might not work, these pages _may_ need to be mappable. I know
> that was an issue for page_pool (Yet Another Networking Page Allocator) + TCP
> zero-copy RX using mmap.

I'll have to trust on networking experts, I was reading:

	 (requires that page_frag pages are never
     mapped into userspace; true for the current RX paths).

> 
> Of course, if you have a page frag under PAGE_SIZE or misaligned then you can't map that.

It would be best if we could disallow that entirely :)

(of if required, map them through a PFNMAP or similar that does not care about
page metadata ... but the interactions with GUP are tricky)

-- 
Cheers,

David

