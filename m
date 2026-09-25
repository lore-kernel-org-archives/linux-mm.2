Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B4AC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91846B009B; Fri, 25 Sep 2026 03:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69466B009D; Fri, 25 Sep 2026 03:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E926B009E; Fri, 25 Sep 2026 03:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6515F6B009B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:29:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25F481C326C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:50 +0000 (UTC)
X-FDA: 85251460140.12.85FA955
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3F14A14000E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/WLg1I8";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiWuf6oQq5A3UnEp7xw9abCzGYw3bR/Kaz85Vp+8SQY=;
	b=5gL/yloLwhOM6k7NtLsnlbrxk8hHGki49PJn/ym8OZq+xMAFaF+TW6A1CCG6Dar34ZkMyW
	TkKF2gZp+JLsdjjPcsWpww5JHqotbEb8Xlx1TE8gtiZInIcHnmd0bclpWwhnVti2Nolea+
	9b/l3iUMuAXaR3VK8mThhRGOl4gaD7o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/WLg1I8";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790321388;
	b=AinJilLvOBjZfh5x5s3aL2GeK5WKd4037rtNl3DcHgbyS7hifNZs7+06k2P8hkh5Vui6XY
	4ANLFFXi8wsyuQU1ziAkZnvyhJ8z+ErKolPNiviSKrHFBxf81iK28lcz/6HgN7hLVPHld+
	TPPjL0jYpo6Af5ezEqek/0YHvcZybYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65AF642DBD;
	Fri, 25 Sep 2026 07:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842F61F000FF;
	Fri, 25 Sep 2026 07:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790321387;
	bh=xiWuf6oQq5A3UnEp7xw9abCzGYw3bR/Kaz85Vp+8SQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E/WLg1I8kZxdzTichv89Q6WWA5WbAA+LPKZuEGnIhEHOk9NIj5mTvV7YT/kPg4aj4
	 ypDFrALDRoYeEW5vamsU5O7k4mCpvBWKxS18afwKyU0l4+l0XRpXRxciAVh8EW4Zfh
	 jezfOXtfdmAQsJ7wI5LRHoL+u0Uqevrrp69vwe9C9dPgLv2our6wdElGYBOHqPRQqJ
	 lgR8Sh9YqbgWmcUeKPlCeL/w5/EQBkdixmVP2aVo12u2zX/F6M6G0bywlHVZ/fkQDB
	 iUuyQt9c8wh3cK02TsP+UAaIEeknIploh4NvqSutvCtlqAEFfr/d/wNRS/HO9SXoPe
	 bdpRBtc6UE96w==
Message-ID: <95e91b4a-ca16-49a3-9a1a-5b38afa6f08d@kernel.org>
Date: Fri, 25 Sep 2026 09:29:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>,
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
 <9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
 <20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F14A14000E
X-Stat-Signature: 65736mmb989ocfn7yffoxdiziy6w3t7e
X-Rspam-User: 
X-HE-Tag: 1790321388-117761
X-HE-Meta: U2FsdGVkX1/SSzPWApHGfZA73jxLk/lxVdsO9+XkNuiKM0Zs00efHkLdF9sAjdtA75eucNvm3Br2DFVbKEKT6DcorAdilaWVklSP4jC3zbEs1e5qJ6Rl7fkNvTNvWOLbexmSWk1ivGCU+Ec+l4Q9lookX43NYjzrMAUarmPF6o2Ip+I77oOCoS77IhmU2ERA+Q4bzT6omd/uYGwDOZ6MSqz2ialrWvO6dzOUX8XDGXTwZNrPTqy0i/y1o1dj97cRtUt04Na4ckAP4jP9m+cJPTsFLYnaeBeMHeGR9I42PY4xxIczZwITPyOn/jz1UTWd7jNcangnFnIcaS8N1Gno14YxT4x+tugQs+v+Ni5KgPSxI6KK0hLsLvnfB/mmjsz/ZbcrfFUPbrtTMMzTHod5vaYcbq4OWrEQOyIYY6vOOm3Z7ParRgxXpZc1AjPCoWAESdXC10ViqNKDQTBi5OsUjRG7xBn4IIgCXLWPJ2AMwdByYK494VNoMqc6ZOM1+2eZMgloJAyZxjY/OX2xKJCfLc07oPJTlHkwx79Ncu5aLGwE+ERei41wgKbcnrWtL7GjmyQaY5v2KPzm8zXFex6HfQkE9BVqVKAKik+oD9zsAjgNvVe2PMs21uOpPS+WjYi5k6DH2Z2EkiPnbvGqHnUnpVIifbppBbhw8FdjLeSQjTMAWxEpPvsoLeWS9STPf+7tp6AWDDavsqsOJTrKCttzH09BkurnKybxxdJcWtV7bTQyiVHO+yUYT+bRz5KkzAjbZk2KCkC18ikvN9vaWnYrd7VwLyYTkI0YAXPiCOZ+I6MyushZpzj1DahkvCFhNsNV39WHWfO8CYIhMzbcaaXSboC72Rbds61usfMT2npS/Z/WFJuzO9v0hnMSsYPC1iGwTq0jwZ4ouPh5Jt7ht8w4Xx2TmyCPAgxkEDYW6dGkOCt8zKnbe7OBwZPap7Qs3b3c5hs3x4YLH3ZgtTGcJ5f
 cwZ4c0sr
 UBnjOXbHDBrNEQK//jW2uQh0Dqb5JoLbInEY43Rb3Kk3J7pDZZB1JjHl21qKQpf6hFPRHypX89PDemC2APTCDqlNnSs2x7drzfa//XWijIqbHIJiWPqldgWYoRw4uxO6qyXCeDcrHRLlK9ncKWJ1IxVUVDi2NoGgpfyx8Gvhhghyazegvdt5l1XTaT2TfaxCDRHOVOwhDQyyoFEIC9eFB2WLmmcL/x4QahUVTCTGOK2CjNxfUqoooFY05kqJW/6vGC80P17GCLzS4qnq/B6Yz8v5VvtAdMdsW/PooxCcNot+xqPagzluPXvzO3b2FgV5rIglXPF91EacxhZcewBqYCVehu6y9BpGpaYxW+0LHk2PJdqMjQYkXzF9XuP5WPLG4JeLx/p+d1qWvD9dg7rOeOw+Nl9DBoxY04fLPW+E+nHog7HaRqXklsBuaP9OrKJlred5EADim2B/SwCQHnmPuPStvpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 04:58, Andrew Morton wrote:
> On Thu, 24 Sep 2026 17:37:29 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 9/24/26 16:48, Lorenzo Stoakes (ARM) wrote:
>>> Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
>>> MAP_SHARED gets you true anonymous memory (albeit in a VMA with
>>> non-NULL vma->vm_file).
>>>
>>
>> ...
>>
>>> --- a/drivers/char/mem.c
>>> +++ b/drivers/char/mem.c
>>> @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
>>>  #ifndef CONFIG_MMU
>>>  	return -ENOSYS;
>>>  #endif
>>> -	if (vma_desc_test(desc, VMA_SHARED_BIT))
>>> +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
>>>  		return shmem_zero_setup_desc(desc);
>>>  
>>
>> So instead of shared zeropages we'd now get zero-filled shmem pages.
> 
> "zeropage".  Singular.  Used to be!

Hey, leave that German native speaker alone! :P

Yes, you'd get the shared zeropage multiple times. (some architectures like
s390x do have multiple ones .... likely you could even get the huge zero folio here)

... unless the MM has the shared zeropage disabled, and fallback to anonymous
memory:

-> mm_forbids_zeropage()

... we end up using THPs and the huge zero folio is disallowed, so we fallback
to a anonymous THPs

-> transparent_hugepage_use_zero_page()

> 
> The accounting differences, possible changes in reclaim, memcg
> charging, maybe swap behavior.  Switching to a different fault handler.
> It's hard to foresee all the effects of this.
> 
>> The alternative would be to just convert it to a proper read-only COW mapping in
>> mmap code:
>> * Not clearing VM_MAYWRITE, but keeping VM_WRITE clear
>> * Clearing VMA_SHARED and VMA_MAYSHARE
>>
>> Sure, someone could then mprotect(PROT_WRITE that thing) or
>> FOLL_FORCE|FOLL_WRITE to get anonymous memory. Just raising that as an alternative.
> 
> I dunno, the whole thing feels imprudent.  To alter such longstanding
> core(ish) behavior.  And why?  Because a shiny new assertion said "hey,
> that isn't quite right".  Wouldn't it be better to squish the warning
> somehow and to set about this change in a very careful way?

We really shouldn't allow anonymous pages in non-cow mappings.

We can

a) Disallow allocating an anon_vma and fail gracefully. So only a shared
   zeropage could ever get mapped there. Might break the s390x
   mm_forbids_zeropage(). But given that's only used in hypervisors like QEMU,
   unlikely.

b) Do what Lorenzo proposes. This will allocate real memory. Someone decided to
   use MAP_SHARED, for unknown reasons, so I'd assume it's unlikely that
   something breaks, but you have a point.

c) Convert them to proper COW mappings. After all, having the file read-only is
   absolutely irrelevant, because we will never ever use that file. It's
   anonymous memory.

-- 
Cheers,

David

