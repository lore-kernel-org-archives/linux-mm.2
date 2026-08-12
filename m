Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7EBC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CA66B00F2; Wed, 12 Aug 2026 09:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013D46B00FC; Wed, 12 Aug 2026 09:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E0A6B0101; Wed, 12 Aug 2026 09:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9550B6B00F2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F107C037B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:25 +0000 (UTC)
X-FDA: 85092683970.21.EAF7FCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7753918000F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0h3YJ60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6IqI5SYQeuMaSir9Vmbn3pyaNKCBSOsIAQw1ZjmghY=;
	b=kv1g8wNA1svFnKv0WNq7/vC4aldpNfZxkWeaDgNBkGu/jxKo0t3fpgRxZ3dssFYZgXukUq
	q4y5ADOzjuSMpfcMtD7TUGenHfZtQfClPZz9gAlOOi4WS8/i3Vm5mduWsJqYcPUPxHQ5LK
	tFDikj5rsbE2eUms2ad64IQuaUlb9DQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0h3YJ60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541003;
	b=Q9yck5TfupRF45eRzX+g9jzXnl5DTaP88XSFIJpA8ifgoMUltYCgRrbaLL7s+/Fe+ytCQN
	ll8aQzprc1n8TRS5lWViK8JDKg46YQSp8FA8XF8YvuxQNT2enri02r4QoKqakyqjQhwUYJ
	X+J/fUv0qcLDGgs72d81tdEzZDRWoK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AF85440B8;
	Wed, 12 Aug 2026 13:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F501F00A3A;
	Wed, 12 Aug 2026 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541002;
	bh=n6IqI5SYQeuMaSir9Vmbn3pyaNKCBSOsIAQw1ZjmghY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F0h3YJ60UiMnWN4lgr1mNObrgh7vErYkc06AT4iwvSlC0AmmBMO/AFnQdX1OZVihT
	 F8odZtqr9vsy8hmAB5559/81ZwvCKgoR5m1EEp8Az5cL/NsvFzd3o5OzKNcEcAumx0
	 9YJzLYmiLR9kiy2ChZUaZskIOKCjuqdELCpn49K0xOZ/gYXuKsRv57hT0z1vsd8UYP
	 Ge/EkbqR8NPJMnxDCE0vpLbvEGlIW78Ns3gGQKCDKURMNPOf6P1zVWgEfozKnGueDu
	 ZizLW5M/9iKkqoKpzs8QEHmcvX4bp5djgqJlOpDfSWww/Dj7QuY8yB/6PbtZBt1m6U
	 0/pPHJ0XW+zlQ==
Message-ID: <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
Date: Wed, 12 Aug 2026 15:23:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out of
 follow_page_pte()
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
References: <20260811025157.1632867-1-riel@surriel.com>
 <20260811025157.1632867-4-riel@surriel.com>
 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
 <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7753918000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 964usjx1gb9oiw8jd9mem7ks6mr9fw3n
X-HE-Tag: 1786541003-857461
X-HE-Meta: U2FsdGVkX1+JR9TSbCnqA9H8wTjyTx6A5k+7Gh2zjUn/LLfLgrtApytzl9vXo+plOKsBU5wABmQEK8mBIl9zig4MCs9n5con69+mcFxVjSnogWNgU5OtH6zV+rxLIZeWl/amjC4w8zxXI3zUd25QP1mK29UzG+/mK2ZmjR3aOQWHRaGDUHeFmi7j5NyhYQ2egYENCWRHVlajhavv7fdT5AW5/dQj9ko5qdpa1earsmEYauXR0o0A83e8KYg/Ktmnl7HA48XNthaP3BeHzZuTX3nZ+f3mSnYT7fbONHIvG37nW+39N5dGj5hmXEA/z4bPwsPaNn8DTq4ws0D/mU5atk606bFSffN79IKQWUKhX++cudQkik7lPubhqlD4VgriyJgqBjLQ+nR6rIGy/FfariHg+iiM7OaGqmEFBv27YlEqOTOWsNCKDiKRACcXzXUFefznJGvUgEjlk/NKKgvW5ID1bqa5RySkW9Sj++Nf38LQG0XGvwv+V60u9wv5aOWDjMyn6g2t1FFI9lE3reIC0X+95QFcagLBKkon895DaVC5jsB1+Pvu2iBSLO6MTQJPwh/1xRYzkYdd8Dnwo9h4RDdbqmZSX1pbs38ZllXKRUUOcsJWy01WAGl/xyC31+cJDNyvk6eopmnoTtcztZzr5DSpIKa21wm5NdVzgnzyAairzoNCWTgWgvn+83f0gGAoIFJoIyBGU5r5PRxWK4ZigRmryRtiJDlE0u5pmcRb5Lhvb5Vu+PPk8S/2sKk3Peesjb69WywCIszkVImRkl/5zOm2V3koJFqDjlwjOSarQXFNguU0b01Tl//+tRQij7IlLR6CCTkdlfeUgu5J2bckbgx/qSWnSMorgxYIGK6nnmKa17k8b7x386KJFqj/qIDfneU3dlUA+bStDIjkj6BhzskapKo3/qdNmxOTzWcmYLF/FvMAzuAS7MnagLCnBdvkZTiALuyb7Gt77u6VbX2
 2wadmt9M
 ECIYPgxRKTeJ3MZ/lELx17SrnaWhuwy2MBOwxkA2FNarB0QQhUQuhYk8p9AARS7o6Oei6dSN2uvvzKxgo00zKZRiSMyjXrNkqJIpnHdpxOjObQ1bSwgOIIolMDMOKWMitTt9M4veINVcpNqIMxTjXw9WbHNdAC6SMyUW8tyeeMEa89cLSxQpc1bnMVB7bFMRaHLPU3h9FHZUYOXSLxD2BVCm27T+hOvKEGLkuxoQhWcrvuF3IdUnVQ4ghFkCmKJmLXeqIhaH4KRGcE5FtL/Bo23jFDN9G6d+E8dWUHSjfe2ngCxsvxqN96m+YWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 15:02, Rik van Riel wrote:
> On Wed, 2026-08-12 at 13:50 +0200, David Hildenbrand (Arm) wrote:
>> On 8/11/26 04:51, Rik van Riel wrote:
>>>
>>> +/*
>>> + * The caller has already run every per-PTE safety check (present,
>>> + * write-fault, gup_must_unshare()) on the PTE, so this only does
>>> the
>>> + * per-folio work: the refcount grab, the FOLL_PIN accessibility
>>> fault-in,
>>> + * dirty/accessed marking, and the array fill with the cache
>>> flush.
>>> + */
>>
>> If a function needs 4 lines of internal doc to understand what it
>> does, then
>> maybe it's not the right function name or abstraction. :)
>>
>> I don't particularly enjoy the "commit" terminology, it looses the
>> detail of the
>> most important thing this function is supposed to to: grab a folio
>> reference.
>>
> 
> Should we rename it to gup_grab_folio() ?

It does more than grabbing, hm, let me think.

gup_grab_and_store_folio_pages()

not sure.

> 
>> We're passing in the pte only to do a single pte_dirty(). If the
>> helper is
>> actually what we want, likely we just just pass in the pte_dirty()
>> directly and
>> remove all pte leftovers from the helper.
>>
>> I'd assume that we'd want a function where we can similarly punch in
>> a PMD/PUD
>> and have it do the same thing as well, instead of special-casing
>> ptes.
> 
> Looking at the differences between the pte and pmd
> code, there is another big thing that stands out.
> 
> The pte code will call mark_folio_dirty() when
> needed, but the pmd and pud code do not.

Yes, and my gut feeling is that the same helper should be also used in the other
places. Maybe there is no real bug there, but the inconsistency is concerning.

-- 
Cheers,

David

