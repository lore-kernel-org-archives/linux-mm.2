Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FE6CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889FF6B0088; Wed, 14 Oct 2026 14:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B376B0098; Wed, 14 Oct 2026 14:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A966B0099; Wed, 14 Oct 2026 14:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9D66B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C834412046A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:04 +0000 (UTC)
X-FDA: 85322071128.05.6A27E45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0117940006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h9/hPajC";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002603;
	b=jtKP+3sRsy+jaUafPyuFW1FfB2nmPPOahItTI9juPHtSg61bPCmixnpmk+Q8p5ZbS4aNXB
	YFqiyzDUQlbvPhPMDoyx2b4s/mp9dx98yoLYWKeQ+TU+Ot0Z2SpULxLqcqxMaNSO1nIcXN
	hlhK96Z1LZo4eY3e3SrBlSb4BEYAQVs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h9/hPajC";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goPUvnwsBIJ7nqx5a1aYL/GrCgKsovn5VsOtQmOka0M=;
	b=zsrAEApnm4mDW3S3WbEzMXLYrl61fwPJJFK4SG5WsMXmxofozdsgmwDAc3uJ4QEusiRQEU
	l4Q3z14imYsRyaqzMfZ5DrwQ7Yy+Nw1wsGtAGwdExqvwO3jiax1UZrW81Q5+d6ZN4u0NYN
	lRJP1JdCRdkFOjfj07OUMhKZgl8PUhc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05EF543A06;
	Wed, 14 Oct 2026 18:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEAD1F000C4;
	Wed, 14 Oct 2026 18:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792002601;
	bh=goPUvnwsBIJ7nqx5a1aYL/GrCgKsovn5VsOtQmOka0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h9/hPajC0Azg9CvJ98mqMqpfTxxP3tEL0tJENRXOXOdPpN21/xwJANzF0XJT20uEB
	 8ELin1BYHvgD0N0NTjGV2SS7QTiVClPuKdy9qndWJLXyLmgxGK4y3mG8CdYKUqT/vF
	 DyqP9JEHo7TMKboBIPuoQ8M7v9UQGhKIP4Qk9LOX6lTw5aMFzensHD/vWJS7osZ14+
	 lg0plopzf6p8DARJDysGNTpNSR8qvtJEcL9eMu+tb67MVL2m81S5bCWOth8AInlMpO
	 10+niaPkGe77yTgorT+xOIyc+8m6DbJOK17DYw3/z2S4+GG8xN36u7lttN4Evx/Yox
	 khSNkfCi3qmtA==
Message-ID: <c3b95083-f014-432a-8b21-b555f0ab71f5@kernel.org>
Date: Wed, 14 Oct 2026 20:29:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
To: Kyle Zeng <kylebot@openai.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Lokesh Gidra <lokeshgidra@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
 <as99gyi-NUprRK6e@gremlin> <as_EIRMinCdl1zOx@com-75606>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as_EIRMinCdl1zOx@com-75606>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0117940006
X-Rspam-User: 
X-Stat-Signature: zcxx49u3ejfsumw53uodreihwfp8n6t8
X-HE-Tag: 1792002602-238147
X-HE-Meta: U2FsdGVkX18MvdmEOaaDDKPKNCfEyTHuM78CcEGlBj/raKvIbT987qRZeyk3ZPgb/KwY1eiJiCiCKj3QCtnJaksOjmxlld4Y/uf0UZMGvzDZ+xHONqGIwri/ayh1LqER3KCWCkNQPtTd9bzYD5+xomDseHXAB1Lz3vw8xbdPFNIvaEwe/yetVzYHZASvxvIcEm93vn1TG88WPtWXNpY8rMwtailh53gXChfymaHVqOrQrVJBuulTjU7/GLQGvfDHDC1+/NCPs93RPIm48eZUVHKoCvJ82Tv2DEt7FMraYYQGf5mY0nyWxKX6P+NWldEgf0eA2c28+FttsYmT4uh0Fy2JyCgVEB2WNFfTt7pdlxjemV4bLsvqSzAaZuhZbRFZSpky/U6w3Toze+47WYXSJDPnC7KNPC25jj4dqGMt7SeJ3nx05q7o3NCkiMkmeTnseEfyX79nPIHs6f6DoFdCymQXavWsz5OCCDWf5qSTV5fA+4sPL3jPrMuP0rAlczMqLPPgq/rIur6spH+TEHg+/6W/Y98gQxt3TM7x5C+vBi3HKUK8B0iGKRitVdn9dSHFLE/vwxtlr3fD1Cwg1wBmDGgGa8qByjXQXnnUD9i+PPOX23nuin1Rg7xlcgwLPLrceOnw3DyHnCWeUIT9o+OrjPMOtKJdR+57aI7yt+cO0LmOT30SYG6NWVmjqwF6SiDQ1o/cV4OHSVyzRoExYBxvk101613POfA+Eq3pWi8J4K2MvKdKXySpaSUg3osxHUVMwYScH6t0Bjt0XphShOyqw1xNGF5AU1iRJwm0jMAlDH5XlwTundKP/ySyYRQzD9hgs6/Qcp+pLCY2q8MxSzTOSN5j4ajzLtzAWuys2mEbkRc2Ph3qPII4wrxD6qQexijTr5mAMOS0Ez8FY4WuBdBfm4dMy5+C8ZYTzOvB0JEvN4q0MQv0ct6HuHjPi/SHwo2YXG7BKiUM0Dj2ATRlFrB
 51QsK13/
 x01UUn6gnT2PsV72f8ZBbs2qvL4s2Vqx6yo3GCvyYpobg0j4vfOEojkpCL4vS+o3UYP8N8h09KDqyLpgHKuhQpZOy6CLl5LTdC/9C5DJ/1fBsbK7+WS0x4WOkTsHb8y+5vYQ8qxlG+A2exLddM7LuUlugS2LjpbPYkNSobfuoM9UmFVwo+rYMpippWYr3wTJ1vx5+Z90yQ3b+2JkkOFa06UffV92Y4bA1ufFu/9sh7vqHnEvW5p9bk6p1Ss67FDEKhdtaXE0cTQk3LktZ/EyLBZK0C7+8F6htrpBUb7mNLuHiWcxPp+jm7eH0N9zjzFAkmjMGzo6LUMhEHLR0on5RA8enNVfKDke4RsKU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 20:04, Kyle Zeng wrote:
> On Wed, Oct 14, 2026 at 03:51:22PM +0100, Lorenzo Stoakes (ARM) wrote:
>> On Wed, Oct 14, 2026 at 01:53:11PM +0200, David Hildenbrand (Arm) wrote:
>>> As uffd_lock_vma() is part of the same lookup machinery and
>>> also contains a misleading VM_SHARED check, change that one as well
>>> directly for consistency.
>>
>> OK, I think that one isn't _strictly necessary_, but while we're there,
>> worth doing too, clearly.
>>
>> We should also go through and convert the remaining !VM_SHARED checks ->
>> vma_is_cow_mapping() too if possible, but that's a follow up, obviously!
>>
>>>
>>> A follow-up cleanup will stop taking the hugetlb_vma_lock_read(src_vma)
>>> lock in copy_hugetlb_page_range() entirely. Further, the usage of
>>
>> Hmm really? Is it possible to do that without the hugetlb lock?
>>
>> It'd be good in general if we could get rid of that lock as a whole :) but maybe
>> dreaming.
>>
>>> VM_SHARED in userfaultfd code should be cleaned up later to focus on
>>> CoW vs. non-CoW mappings.
>>
>> I think also anywhere else in the kernel where this is done. An audit on that in
>> general would be useful!
>>
>>>
>>> Reported-by: Kyle Zeng <kylebot@openai.com>
>>> Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd operations")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> This LGTM, thanks for handling this!
>>
>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>
>> --
>> Cheers, Lorenzo
> 
> I ran the patch through my system and did not find any issues with this
> patch. Thanks for addressing this!
> 
> Reviewed-by: Kyle Zeng <kylebot@openai.com>

Thanks a bunch, and thanks for reporting all these issues!

-- 
Cheers,

David

