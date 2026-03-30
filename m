Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1361061B0F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29F46B0098; Mon, 30 Mar 2026 11:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB326B00A6; Mon, 30 Mar 2026 11:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3936B00A7; Mon, 30 Mar 2026 11:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7B686B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:16:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63D741B8BDA
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:58 +0000 (UTC)
X-FDA: 84603082116.24.D0EDDAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88623A0011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:16:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5YLUHTP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aalkHGg36oAhxvm4abduMNhyL+g+4nif6ZCHBlNRxFU=;
	b=RPOoBdcPFGL6ZCkAHKTXQmNfyT1AtSrruChxMMfr12TT+lcZH+pGSny8UhdO40q9AHKFSW
	UdXijmYNy4cBaknHBev4WYftzedTl/42KHcQr2cAAM2S7jKcCLxTnx273OyokgI8vAyJMg
	GGogqE5uWwoCXP8fX6wwq60P9NtbJxc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5YLUHTP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883816; a=rsa-sha256;
	cv=none;
	b=Zkm4tCOM0REhcF+FqJW4nJ+bGXgF4wyDJ2HAX/BD0/0KzLPbv5ufllOwZ7bkBMtCYyuyVE
	174vKh4E4Om8z8HLhnBiPimqmIs3/OA4o7r6OnutISncLg8/3aSZHv1sTSVZQ1JMU0Yqei
	mgEZEFTt9GgBp8H6Ch+/WFm8GECP4e4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85A7144331;
	Mon, 30 Mar 2026 15:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA90C19423;
	Mon, 30 Mar 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883815;
	bh=qRggfUYSMFyYosinS8dQnA8OwjJgvfCqMgEcNyPBSZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M5YLUHTPR0Zr87dAPlgooj2AUqUS4ilSBIlOIUk0+shH9LCpc7hJkNsS35FbbHJlg
	 11vvFt94hMJ0rRBfYkrqplKmfFKFHCCNmihD9Bk9UIqm56Fpv2EnMcH7I48X9RjAT+
	 8ZFRoQ37DHKHXECdFw/qGzfjceMRulnKYivXfc7JiapiNgMiJWfJjV6Z/yWzR9vjgp
	 ErfxVQMsRZGnnfxA9E0ouHFGc48hL/2CZlxqVq50cXWck38aEngkPDXDhrUlVxlsv/
	 GlTfmXo8BdNIPudQx+UU2vyfXLtH8ozNbDrt+ume6rWD1XtYOUdDgFOikImyYIWRMu
	 W2HwMKUPHx5Xw==
Message-ID: <a7a903bf-10c2-4d2c-872d-9b31fefb5d1f@kernel.org>
Date: Mon, 30 Mar 2026 17:16:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mprotect: special-case small folios when
 applying write permissions
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>,
 Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324154342.156640-1-pfalcato@suse.de>
 <20260324154342.156640-3-pfalcato@suse.de>
 <fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
 <dccxy3i3kaprljloxbyo2u346bu6xwev42cpvt5lfbbli2hbap@6n2rd5mftffh>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dccxy3i3kaprljloxbyo2u346bu6xwev42cpvt5lfbbli2hbap@6n2rd5mftffh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 88623A0011
X-Stat-Signature: q1qf3d41urz5ehfpa1ehstsbqjipf437
X-Rspamd-Server: rspam06
X-HE-Tag: 1774883816-925975
X-HE-Meta: U2FsdGVkX1/Ow23zKUVLokBbe9c9moFytF5UCgkGuj64FDRYdC0gv3I/AQj0A07lHw3kxr8a4zH3q5xr8JszuFGF+o+F+njTourZJerHOe9Gq/yvSh+lm9xnuIjLPdcUXRUXFBvF4b4ZTrMIegnlawdk3X37Ve3bWg6K8sAEgZT6F3EHrARiwE0az9Hy+xE6nHmCfvDZ9B4oSi54FJCxMX/fleHgTl5aIHJR9aOZbwG+HuFLB06eXOCSseHLY3y2gFoVmtE9QopL7nkTn83Y5bRnBZm7IhHxO6JNluYkm9NvC8EzHNOe5YH6qC+Thxf00B803xnhGFYq/4VwCajd9AbFH6xUIOqG2OBFfAaAIJPemIkSOUioidMLGK+qCleBMl8Xm0ff4zBFX1Oxe7kpBASB/Fefhav7o8wSPzdBld7+i77+4TE4Gd4gCDCg01bxsvMxPlMzOK8317JgZDCCJ1Y7yyuSHcahmw42xM0EuGrgJOBLRyH3JP8LfiQVBLf29z57t6RkZAvrFF2YuaaNTt+B4fC72WIe/8QIO4X2m1GKcuj1Wfy2vTo/Sr6mBLftcYtwFJT4almghFh8cRulTVS+lQsFBoX5BjnSBvvtDwK8XaNTce/oZu1WRr3CeVe+WK0B+7KXAOIoLy9bNXuHii6HUwcCSovfz8su3gMaKZE7DJJWps5+VklDSNjmX+4pD8e5EGHeVWY5Wd910Ji45ft9RHtG2G0FugLa/O/y0lFiNx6vuNaJUB6qYzqyWnUPgb9mo7lZfDcS3JHj+HfDUa1rimObdBp4QWn3u/n5A74mDb/Fo1VIFsM723CsGRjTOZLYqe021xR8OdoyUZFqbSvi4fkEegsErOMESV2riYHVpa80mday48gfc+mzcHGHQP2RFZFtV/kl5+hgI4QACV6g03TYOgvksVA2LyzVz9AlEPa3m4mAsELv9+LgTBGZvHf4GGJxaxv0Suu+K/u
 PPC5WL3r
 qmGotZP6MbbZOUc0oQf0zth1tk5dV1CT44iaWm5WT76oxZPZEpBm2sHNTiWmCJgeqapM1l6uGRcxLq3ypJjbn71u5ybNbCLl9CGG70f8Bjuk5do+p7nM1AWWEhA0kk6pI39/4Gg8F7k2VXe4eUJIedmo/p7XmuldnFL3pNbg/qXGDzkjTA0/wNXYerQWcXpoVhU21TWchGHqR8vnJo7TZhvcYV5kcxndc5j0QEnjzdXmHlkOtMZr6ivavi72o9jHJUIhbTjDZ7qgziG07jIMTpIyeErN/FIkj4dZ7jCYQYsaOTr1pY7NRMzirG+NgO6LvuivHSog2FNXBTfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 12:37, Pedro Falcato wrote:
> On Tue, Mar 24, 2026 at 09:18:42PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/24/26 16:43, Pedro Falcato wrote:
>>> The common order-0 case is important enough to want its own branch, and
>>> avoids the hairy, large loop logic that the CPU does not seem to handle
>>> particularly well.
>>>
>>> While at it, encourage the compiler to inline batch PTE logic and resolve
>>> constant branches by adding __always_inline strategically.
>>>
>>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>> ---
>>>  mm/mprotect.c | 17 ++++++++++++-----
>>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 2eaf862e5734..2fda26107066 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>>>  	return can_change_shared_pte_writable(vma, pte);
>>>  }
>>>  
>>> -static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>> +static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>>  				    pte_t pte, int max_nr_ptes, fpb_t flags)
>>>  {
>>>  	/* No underlying folio, so cannot batch */
>>> @@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>>>  }
>>>  
>>>  /* Set nr_ptes number of ptes, starting from idx */
>>> -static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
>>> -		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
>>> -		int idx, bool set_write, struct mmu_gather *tlb)
>>> +static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
>>> +		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
>>> +		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
>>>  {
>>>  	/*
>>>  	 * Advance the position in the batch by idx; note that if idx > 0,
>>> @@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>>>   * pte of the batch. Therefore, we must individually check all pages and
>>>   * retrieve sub-batches.
>>>   */
>>> -static void commit_anon_folio_batch(struct vm_area_struct *vma,
>>> +static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>>>  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>>>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>>>  {
>>> @@ -177,6 +177,13 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
>>>  	int sub_batch_idx = 0;
>>>  	int len;
>>>  
>>> +	/* Optimize for the common order-0 case. */
>>> +	if (likely(nr_ptes == 1)) {
>>> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
>>> +				       0, PageAnonExclusive(first_page), tlb);
>>
>> To optimize that one, inlining prot_commit_flush_ptes() would be
>> sufficient. Does inlining the other two really help? I don't think we
>> can optimize out loops etc. for them?
> 
> Well, I'm getting meaningful (smaller) wins from adding those
> __always_inline's. (and I also get a small win for __always_inline on
> set_write_prot_commit_flush_ptes, but I didn't realize that until now).
> 
>>
>> I would have thought that specializing on nr_ptes==0 on an even higher
>> level--where we call
>> set_write_prot_commit_flush_ptes/prot_commit_flush_ptes() would allow
>> for optimizing the loops entirely for nr_ptes==0?
> 
> That could also work, but then set_write_prot_commit_flush_ptes (holy cow
> what a long name) would definitely need inlining. And might be a little uglier
> overall.

Right. The idea is that you __always__inline any code that has PTE
loops, such that all loops for nr_pages == 1 gets optimized out.

We do that for zap and fork logic.

> 
> This is the part where having data points other than my giga-fast-giga-powerful
> zen5 could prove handy :/
I just recently lost access to my reliably, well tunes, system ...

Is it just the following benchmark?

	https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933

?


I can easily extending

	https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/pte-mapped-folio-benchmarks.c

to have an "mprotect" mode. I had that in the past bit discarded it.

Then, we can easily measure the effect on various folio sizes when
mprotect'ing a larger memory area.

With order-0 we can then benchmark small folios exclusively.



-- 
Cheers,

David

