Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DDA606A334
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c/ne9JZ6
Received: by kanga.kvack.org (Postfix)
	id B8E046B05B7; Tue,  3 Nov 2026 11:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65446B05B8; Tue,  3 Nov 2026 11:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A568F6B05B9; Tue,  3 Nov 2026 11:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756336B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:55:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B1A91C32FD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:55:40 +0000 (UTC)
X-FDA: 85394409240.02.D1B6102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4ED6C0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:55:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/ne9JZ6";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793724938;
	b=UpOlT+84GzOvH/6tnfpQNh0Sx8HHemzj3VAdUqinpM/PlJjpRFo4nvGDzKfcdsCT1hWsXn
	TfoJ9ePetTL8hJR0AaRIXdJQthclFiTAOGjHMaxwKkJShdf52QL1pxfoWDRKHqzEVAmlmz
	8HuJ6yDMJ5tuK3Gduxp7/SEvfT3gouA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c/ne9JZ6";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793724938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YfZexZ1JYycRhSHeLVRER/xerbsZZLglZfGs4x8Tlc=;
	b=M8I5L/4uOGn0qnUcT6DzblF7mfxO6fRbhiI7qFEVA7yUgZajQxQdgJWnAS0zAO0rxdOZ42
	R6YsL277ZwWztgeBHF0DvqFph43jkg1RQV05XDXDWIb1zKklvFNLoHFlSx0B8NJ6K9UCsC
	Co2YPVp4/dWO3Cs2LI4Cq9dbGMtpkqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48A5B60A00;
	Tue,  3 Nov 2026 16:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBB31F000C1;
	Tue,  3 Nov 2026 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724938;
	bh=8YfZexZ1JYycRhSHeLVRER/xerbsZZLglZfGs4x8Tlc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c/ne9JZ6JImyHkQVNBrOmaYf+pq+Dc1L6hkV9Qvgb32JqmLL0tRIDfheyHQhKFhs3
	 xyHUpt33FhRGfUfyCa41jUM7K2bxIyoRC5v4Nj59XUeHVV+Stx+rJp8mdULx9o8kvw
	 a1ejku2NyW6yatQu+Z4RkgSC5cDLvCJogCYZG+93FViEbPrajbY5yn6GVgkBlHWBoq
	 2WU0Uiv0j9MJM1AHQFEeY7H2wmGjLn/K5CnazWecRhrDSus5D9Ao/7inwU5qIXD+Ys
	 dSrrchgTP6ND/xS7zRF/gshnxLsm5zcmWVKybEWmcJ1vKUKvQn+kUnmQO0cvWk/5vU
	 lCEgEzWsUgWaA==
Message-ID: <1affac11-da98-40b3-8cc2-6e8374b5ab69@kernel.org>
Date: Tue, 3 Nov 2026 17:55:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] mm/gup: batch contiguous same-folio PTEs into one
 refcount grab
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org,
 Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-9-riel@surriel.com>
 <fa017227-448b-468f-9797-33c02854f018@kernel.org>
 <9d1572bd5e868d3c9d953aa5fae81967cc81ba55.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9d1572bd5e868d3c9d953aa5fae81967cc81ba55.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j779gu5ey9d35difpj1nb593rzby3q9h
X-Rspamd-Queue-Id: C4ED6C0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793724938-569601
X-HE-Meta: U2FsdGVkX18Ax+plj4t1N2CFFrJRmKxJO7IR8gpLZdNms0CtRkUA9kAdS/mNx1IVyY+BWh7bT7WmcYq9JpkcSTrsPhfFDNXapmsy7fRM0qJgnIq0Rs3cLWIWim5X4kCuvYffu6BiKMfTk6IreEl3jkRFg7zvKQSLjaUPwh9Rflie5fBF+dS7heQMvQt3PjarAyJUtQRVAx6vO+UnvHxkebDu2WMxNdeAk6bYrvkG2CoKfje5d8a8p/tskiY1jqpaD/qSlRn6VTLfQEPYe4mePiTuRqvzSaQXIg4QBX/kHZNNOP3mrANReTIM/GG5aKiC6kobL8chMptofgGewrIaLZwupfSESjne4O92zKeySxtOoGsHRm18sW1g9/eU7SW0Lk3v1gT6Ik+fSW1GqMjZSsFV6OhwnFALVJtfSk5sW5ElmInEXxtGxpWweNRsJU4Tj3AhkpDWm1CyGt1FKW3mOd/HKVQ0n5dloyjYZycCvleCVHLgNqbZn47Tf1cFZ8K+b2+OoWOCj/IlrwU2LysBUeJ+Dqt7EZQSubt0R0UcuXY7x6mEYi59qmC5MV6y99f9cxBER9KH2HiKuv6vybt5bklm37vW8K+Cgiw74b5Ne6W0qHDlMmucZLfdL79HiKSWRd1JU6geLlmw0EtHvbNowKGsmsUubc96T2E6nFJdleIuesVJVMOvBcuxiRY2WfWjC3TcsRMGRpA/SlXKdgSVm1uuN6G8p2riP/damkAsy/XqiiOCkCQLIDITh/w3iU2WdQv5ywtz75nUJEeNXQFpg8XQEC3jDVBUm9D2Kty3eZROT8ybjpBuaqpDQ9duq7LD/Gf9f7DyUWo+FY9jhYAeUYDdUEz27G5TPR3fS1TvgCavZoHzfbg1FpjbD186Tj/9cbOxg1Nuf7pg63eyRjoZEtpOp6vriFddRsBm5TJIsLnWJWGpUOG60OaWBwRIYLFwRHBSkTrbsqQG9kAXbOa
 HFm2JU/M
 C7/U8oecMVdeTgAfuevZC2ev5yPwYgmH9VCn/EzsUHGBix14UJM7rWhg1d8ziER5fiQpMnSiJ9IlbiHsImQ8+zhOBZ+jJBu8rr1RsVkBSbRU3lVGcwpQh1FrVmUECDQ868XRpOWNINTNGduIm72GCPh4DocXcHCeUVOcLImORM+nx8IpCw3XwqKtxD/mKGFe4EkJcgSRhLfhRA3S/lTQCxPjru0Zb0MX2uhBWLe3Y92UxKk3mKMnlo0UnLvcc1yNhWrms
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 17:42, Rik van Riel wrote:
> On Tue, 2026-11-03 at 09:35 +0100, David Hildenbrand (Arm) wrote:
>> On 11/2/26 20:30, Rik van Riel wrote:
>>>
>>> +/*
>>> + * Return how many PTEs map consecutive pages of the same folio
>>> and can be
>>> + * committed as one run. Always at least 1.
>>> + *
>>> + * The write-fault and unshare checks in gup_lookup_pte() are per
>>> PTE, but a
>>> + * writable run needs no repeat: a writable anon page is
>>> exclusive. A read-only
>>> + * run under FOLL_WRITE or FOLL_PIN does need the per-page check,
>>> so it stays
>>> + * one page at a time.
>>
>> That's a clear indication that this needs more work.
>>
>> I'll try to get to it soon and see how it could be done in a cleaner
>> way, likely
>> it should be based on top of the gup-fast series where we will have
>> helpers to
>> check for required unsharing of multiple PTEs.
> 
> I'm all for sharing the same helpers.
> 
> How would you like to sequence things?
> 
> Do you prefer to merge both series separately,
> and then get a follow-up series that merges
> the helper functions?
> 
> Would you like Yeoreum Yun and me to combine
> the series, merge the helper functions beforehand,
> and then send you one larger, combined series?
> 
> I have spent enough time in gup.c that I would
> be happy to get rid of some more of that code.

My plan is to get the small series for gup-fast ready, stage that, and then
build on top of it.

By then I should have been able to dig through most of your series. The cleanups
can stay part of this series.

-- 
Cheers,

David

