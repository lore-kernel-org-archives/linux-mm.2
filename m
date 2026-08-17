Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D30EC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7826B0888; Mon, 17 Aug 2026 13:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368B46B0889; Mon, 17 Aug 2026 13:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257836B088C; Mon, 17 Aug 2026 13:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDCAD6B0888
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:46:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17F44160889
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:45:53 +0000 (UTC)
X-FDA: 85111489428.14.D8F3816
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 452E018000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:45:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6lCAadT;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786988751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAKo7TrZu9+ob9VDRDNL34HG8FM2DqWuvJo8ttA9XR0=;
	b=Jm31kIF3XMgyoQPfLAo3OkSktYumK69hcxgW+blsHb6jgon/GEllsf7Zqqx8rTAtTA828l
	kZbCkoaetIx+THZ7GKH49brAi3iWFJ4VfXOBGCbXTxJ0Q0qW1N9+FjQOg6YMY1VLq7hijD
	23z8yWvAxpIVaF01ElFxmppMwOc/gt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786988751;
	b=6vVbF/Y2GXKPUHDL0AvS5juLKVh0Ljg0xl0XtsbRg5fbl+aFW2s8KR1lKQwknRWuIO0ecG
	E3YdkfKd+ectI8R028m4escNN1rDbeQjBbfV4iQZoDhNdNiEKjEHnuU2DgWXM44q77zGc8
	hcosqMUTY3SGT8bjTJGUxopQTu2DibU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6lCAadT;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7682C402B6;
	Mon, 17 Aug 2026 17:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A411F000E9;
	Mon, 17 Aug 2026 17:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786988750;
	bh=fAKo7TrZu9+ob9VDRDNL34HG8FM2DqWuvJo8ttA9XR0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z6lCAadT1fE7faFuJ2NmDgiosFfh6ejTBefrzHqr6GGcbbNigaLzYEBjOt40prDvR
	 lyN7h+sbKHazVIoPNYRv3edYv48af0G+NYUC42N1LA4VEYONxZ91k3kCf6MBfiTZnV
	 1oIf69wm1kSUsd0x9lJANQQRxnhi88WgZwsTiM6dyXSHCRkPYkuZK7qnnFceA6BF83
	 AgyqyKmiL9OBCXKc694/LIaXxWHB8EmNPh2RaWkJfuCCvKaLCQshMu8iOYiRPRRYRH
	 U8q6CKZXpVJe1MaNs5je5CpfV8nTJKJxTGIRiW/gAI/0SFWjn+0jk6XMeCSOHiL9km
	 RbxVcocLbpAuQ==
Message-ID: <d0d781bf-43fd-4a59-ae0f-960c1e942f19@kernel.org>
Date: Mon, 17 Aug 2026 19:45:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: Use a folio in the softleaf_is_device_private path
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260803031554.30421-1-hongfu.li@linux.dev>
 <3ae2f1e1-c784-44ed-9b2c-5edf5699d627@kernel.org>
 <e20678ed-3fa1-4677-a1d7-e2af481e8302@kernel.org> <aoM4hkwYBRgSt88n@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoM4hkwYBRgSt88n@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xxpj77nhes9dp41fqtgcsxef4wf5jkqj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 452E018000A
X-HE-Tag: 1786988751-239103
X-HE-Meta: U2FsdGVkX193DnJFSdFVG5q3383EkL1eQHnd+ukOVEqQQvqSbH4UJAM8Ec0OeUyV0ejCrQoZuSdXZ5qqOAQhlMfEL13f35fMgkpQXuKAwMZoanufiFuFelj+8LEIPCaGTwDIG+HVVAZHZyPHFcyAqbTjvjLE+kKwCPP1y6Nq/GaPIF3itKhiCw9zA09EiNgcgNX37Qa6fufSw1UO3R7/gSzZhZXnt3/vBqvrUGbShQL3q0v0oLsaoDVVIAHHLk0gCh6kkiDW4h5QWNofCDL2L71aue7s1GycV7FtsROfao38/0tHIR8iAxaBwcT1FqlDNugHlrnXZEVSlDRZsyscZV67NCxuevZQOp0MfvASL/n0r9rkluzmIWvGs6g4TJWK/C/Dky1KHDrRqmIczl3Q2WW/QQqna/4mkDlOGGNXt4ivT/p/np5jGh3O5TS2fQNWWAudgJ+VCwwbU78P+YQiSpI6h8dyRHMOc7+c8ZrK6iQ7hz+292S/fVI4UXNC7lBt1/OLlipKhd4kv2b8ug235TkoshbbtWxwHKdMi/wWFvFDpCt4BDj77guCNkhYGwBWwFqOjVpnRxKu0a87WoJwNV8ApKaaAPl69XqrIjixJq5nH09YLiFG8tN2RWLdqqJumfCZd9mNSSSVQOuqaM8ifNDFzx99scMSYadmUaS7ZB0GyiW58rbprrSSNBG51msQ877a6Yfcbp1QOIjFJyIP2aKEZ7VWk4JfmreAgX2HQYpcQ3+wPXUAGmQXvDS1AU2YGwfrryCzvgn1ePbiLVUqc2EYTOGkX0WW5lOnBhgX8KEcrdx8XWACjWGYD1tXrlqF1pAZDRJ7WoCyjh4uHDzWjOiIzp4qiLqURfqd6bAcZku4V4l5xfblW78vkgQEYj6047RXqmqfK9ZzFGMok7WKXz52/kFaQVkVtZvsjkOhxVIIe5WeGzzEoZP+ro9RSfqQ7rrEBKu1+kruX/6oH+u
 tyeO36lW
 Fpxu0OzJ+y5Eo9h0t0ZoMrO9X8Pvq7HQ7GTt8SYg8l6ykWEhfMwx0B283Up6pCNR2QLjDEhKCjA8GfY1YoXW55Gafpwotd9unFyr0p21wt/XCfsfRzOl4AychOfN6NivVcMjDm40GNn9qHT3m4AiEUNfjNesKpFbcg4ldPu+igk2JEV2v99kKAEBcl7Fg6Ve/SoKUSP639rZFG3e8T2WD4c3Coz24J0CLfKWdbi5w6IiRPqD8UcOGBgyjrelJEjrdL8BssqXulkiCv0EMAM2+3/QZJ2XgQ3AQPsFmvtbExsBug/fKfujLGDz42A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 18:39, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 17, 2026 at 05:57:57PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/17/26 17:52, David Hildenbrand (Arm) wrote:
>>>
>>> Okay, so this breaks the HMM selftests:
>>>
>>> # ok 30 hmm.hmm_device_private.migrate_anon_huge_fault
>>> # #  RUN           hmm.hmm_device_private.migrate_partial_unmap_fault ...
>>> [   14.589125] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>> [   14.589178] Modules linked in: test_hmm
>>> [   14.589203] CPU: 25 UID: 0 PID: 653 Comm: hmm-tests Not tainted 7.2.0-rc5+ #14 PREEMPT
>>> [   14.589243] Hardware name: linux,dummy-virt (DT)
>>> [   14.589268] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
>>> [   14.589300] pc : folio_unlock+0x78/0x88
>>> [   14.589326] lr : folio_unlock+0x78/0x88
>>> [   14.589349] sp : ffff80008284bb90
>>> [   14.589368] x29: ffff80008284bb90 x28: ffff0000cc8ce180 x27: 0000000000000000
>>> [   14.589406] x26: 0000000000000000 x25: ffff0000ca395dc0 x24: 0000000000000000
>>> [   14.589447] x23: 0000000020100073 x22: ffff0000c23d35c0 x21: ffffffffbfff8000
>>> [   14.589485] x20: ffffffffbfff8000 x19: ffff80008284bca0 x18: 0000000000000010
>>> [   14.589523] x17: 3030303030303030 x16: 2066666666666666 x15: 6630303030303030
>>> [   14.589562] x14: 0000000000000000 x13: 29296f696c6f6628 x12: 64656b636f6c5f74
>>> [   14.589603] x11: fffffffffffc7100 x10: fffffffffffc70b0 x9 : ffffb0504ff88f70
>>> [   14.589640] x8 : 3fffffffffffdfff x7 : ffff000c79b24bc0 x6 : 00000000000001a7
>>> [   14.589680] x5 : ffff000c79b24bc0 x4 : 0000000000000000 x3 : 0000000000000000
>>> [   14.589718] x2 : 0000000000000000 x1 : ffff0000cc8ce180 x0 : 000000000000003f
>>> [   14.589756] Call trace:
>>> [   14.589769]  folio_unlock+0x78/0x88 (P)
>>> [   14.589792]  do_swap_page+0xf40/0x1580
>>> [   14.589815]  __handle_mm_fault+0x648/0xe68
>>> [   14.589838]  handle_mm_fault+0x9c/0x330
>>> [   14.589858]  do_page_fault+0x268/0x7e0
>>> [   14.589882]  do_translation_fault+0x5c/0x80
>>> [   14.589904]  do_mem_abort+0x48/0xa0
>>> [   14.589927]  el0_da+0x38/0xd0
>>> [   14.589948]  el0t_64_sync_handler+0xd0/0xe8
>>> [   14.589970]  el0t_64_sync+0x198/0x1a0
>>> [   14.589990] Code: d65f03c0 d000eec1 913c4021 94015993 (d4210000)
>>>
>>> I can only speculate that we need another
>>>
>>> 	folio = page_folio(vmf->page);
>>>
>>> after the migrate_to_ram() call.
>>>
>>> Let me try that real quick.
>>>
>>
>> Yeah, that fixes it:
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 4134ac607ee0..83d1a2be957c 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4937,6 +4937,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>                                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>>                                 pgmap = page_pgmap(vmf->page);
>>                                 ret = pgmap->ops->migrate_to_ram(vmf);
>> +                               folio = page_folio(vmf->page);
> 
> So after migrate_to_ram() the folio might have been split or otherwise somehow
> the page doesn't belong to the same locked, refcount-incremented folio it did
> before?

I suspect a split.

> 
> That's kinda a footgun... but this documents it at least.
> 
> I think a comment explaining how this can happen would be helpful though as this
> doesn't seem intuitive.

I think, conceptually, calling into something that consumes a page (vmf->page)
always needs care when operating on folios.

Passing the vmf to some callback might be the odd thing here, because the
vmf->page contract is not really clear.

-- 
Cheers,

David

