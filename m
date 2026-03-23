Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D191F483F5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C877D6B0005; Mon, 23 Mar 2026 16:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38346B0088; Mon, 23 Mar 2026 16:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B274C6B008A; Mon, 23 Mar 2026 16:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A10096B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:10:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49FBA140D1E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:10:52 +0000 (UTC)
X-FDA: 84578421144.23.57B9826
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D1C640006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:10:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpJke4pi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774296650; a=rsa-sha256;
	cv=none;
	b=QLJmYuAEfTGUJ383DeZnQxaxEnV4J+VhW849RvFQVFVt6svHqoaYIPWsr+/80KIPvSIztZ
	UwQ3kh8C4IopXc+F4pL9FycubmsgFtKep8IHznPwTyKU6mBxqT/T6swehz/6EPm7/5qnm/
	ZC0AVAreiV6pSulP3vHrWNpB1oZYUTk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kpJke4pi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774296650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDA3LEviAH2qBQ40EY4LQwYEptH2Jk1Bm298uBLWdOM=;
	b=HgIMDhiZYKh2SuHq/0m8K4fEbOVuuCviiSvG/+OKWGCoIIJ/jM6qR+qd0zy6/T5FQZhNyc
	c1VxjzAWYdNktook5qd602nQLzL0GlVDv0JJRijMPyM3xJ1UXzczXNjwOSnWnG1j0Yd4kT
	adW/7zXiwrjZ6A1oCLeokSTEGvI9VD8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15389441BE;
	Mon, 23 Mar 2026 20:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC58C4CEF7;
	Mon, 23 Mar 2026 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774296648;
	bh=Nu64mlY3XWdB/UpmDs5KmjCgHvRnp4f74MyqaEjMcSo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kpJke4piH13sLowqeW1ymsR3YHAJzBvrh2tafIlfnppwQZ+DuP5tQtQBLqocDVXBG
	 0KKgbqTXQjs4Yu8/FoXm/n3lX4/QsBnZO7/6MFvhbsRLrIODfHDYKZLUAxIREaMJ1T
	 HYlZ4GEQrJWCe757vyluxTdXn8cmAyTIM1CQJ8WS7gEdLr3wdYgpL1JxXXpyWZHuip
	 gt/3DT2fds1uGtMkWBiztX/XjBKEeZVB1uwUx3OBL4nAPtw+Mwho2PstqljJYLgejA
	 mWmi10c2UhZKV0+Dv3OEQdPAtWnF8UDxyRSmArDgyd5lFE44u+i+77UKFlt7fh861/
	 8razqpxdwgRHQ==
Message-ID: <9dc0b270-f7e3-4bcc-9838-df49cb1e609c@kernel.org>
Date: Mon, 23 Mar 2026 21:10:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/13] Remove device private pages from physical
 address space
To: Alistair Popple <apopple@nvidia.com>
Cc: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org,
 balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com, jhubbard@nvidia.com, maddy@linux.ibm.com,
 mpe@ellerman.id.au, ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <4b5b222a-18e8-4d48-9acb-39e5bfe4e5f7@kernel.org>
 <abiloqDpIs046DJJ@nvdebian.thelocal>
 <b1ae55b3-8058-40ef-96f5-5caf97b1ace5@kernel.org>
 <abzUKN62gOA5b6FN@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abzUKN62gOA5b6FN@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D1C640006
X-Stat-Signature: 7a4kitauqcpfyyibx6phkww5syznit8n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774296650-139287
X-HE-Meta: U2FsdGVkX1/YuGu1pcGZ9dzW3K9QDi+H8ClnWdeyiLZxRyIc8pUB69AV5Q/i/pyeQBhZU9Tak8k/g1wiKZMsBCZKzGg/dx6XFq3L7Y2MbBAvKsfFqDK4v2mloo49gen2xKX8r9yMYSSbrJoqWd0wmK1AMb6ydzDL6Dj9lnMeyBBUTSe6ykAgv6T+w+izepg1C25sKgoG8475tPW6OrKcTNq4hG8XrAmCF37N7NWoAaSQrBm6NpT5gfbON3uPrmEWsepoj4LENh1nmNriHtdqaeSvQYmxSSsU31RRn4BRIVzTLzklQfERa//vUAIEKxles0Np8Pt3lqBqoYd1OkbkejYLGJy+DhHLHWfIVBFDYm937uVw+HFMcxf3YjZgDt7j/3T2CIEeTuHJ4z3X9I/zr/sm+FKiCstSfsLYw2KbTrLqetk92o+4EgY/xZmw7ElF3xgNTBEIZvYwb/Oz73kFh07LWjdpBPNHLZId8YryECw509o2eqJRUoeVVH0U7eTqfP8sMn5+PrxyeuPp9Lz/qgo8N16mwjw290VmmFWoy7rws9wV5fXoiYWjcY72X3cEZjiZiZJbfuBIJmXMJxDAu8Pj2naQFXXUhAslJPkPJF1tpsAMhXT7jrq1W5jkgEu9Q52+miUvp2mPJBOb+tXz4rYef4seW5n0OGqym1ZhYEAbbC5/zYwm4sfH+P9bFEB7xAYHq7gvZfwNrlm4cRH9YzcgsxJTbHJU0k2elpCoAnamXDWdeC/nG2vcHXRAtsCv2BORNPa8zoTN8WgCNhAvOdo4ErrT/IDxBth6ao97HsfsT2ATydRxzbiq0YdtJuKok/4OGE+CKbyBwhEtQnqSKiJAMGNSBEOKqyU3oR+BtMU1Jq1nOct7BmeKC+dxejqdg2XBRBRdXgg/k7yOM9R+t1pY3M8Db+agQtep7tq/WlTn3g6P4hrJ+7ys1hi2mRoTIaR1Ph45dSGUmTSyMyJ
 Qu9whoGs
 g47r2V+jNMGx8hiGm3a78cDXdOFX0NiGEg2b36A+fMAHLE7SW1+gXshV6ITcF5Wpk0UdL1YUCGju5XKtKdDr9DJHuKYLmCEPusofhY87kPgJFUdDP4WFNaKbCOyw3ouFlM2+ZDaEA/9WzbiP8nuKNR/J/0gC2rCiIktnShduWxNM4Q8opQ2slezZVgGGwLRX/cr3CIaUy9L+VBkmykSLLlbMgpMUSeOBVyUs4gh547A2dRc3Fy+DtoBIrt7v5zMczza7ohLGlpknfqLhuKXH6YZiNzDFy/ZYEHL5A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 06:52, Alistair Popple wrote:
> On 2026-03-18 at 19:44 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
>> On 3/17/26 02:47, Alistair Popple wrote:
>>> On 2026-03-07 at 03:16 +1100, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
>>>
>>> Thanks David for taking the time to do a thorough review. I will let Jordan
>>> respond to most of the comments but wanted to add some of my own as I helped
>>> with the initial idea.
>>>
>>>
>>> I disagree - this isn't hacking in another/new zone-device thing it is cleaning
>>> up/reworking a pre-existing zone-device thing (DEVICE_PRIVATE pages). My initial
>>> hope was it wouldn't actually involve too much churn on the core-mm side.
>>
>> ... and there is quite some.
>>
>> stuff like make_readable_exclusive_migration_entry_from_page() must be
>> reworked.
> 
> Yeah, I was displeased to (re)discover the migration entry business when we
> fleshed this series out. The idea was basically that raw device-private pfns
> can't be used sensibly by anything in the core-mm anyway so presumably nothing
> was.
> 
> That turned out to be only somewhat true. The exceptions are:
> 
> 1. page_vma_mapped which I think we have a solution for based on the comments to
>    patch 5.

Yes, if we just have the page/folio we are in a better position. I
*suspect* that we want to pass a page range, as the other two weird
cases might pass a page, that, in the future might not be a folio anymore.

> 
> 2. migration entries which obviously we will have to see if we can rework.

Please look into encoding this internally, using one of the highest PFN
bits or sth like that. We don't have to support this on all weird
architectures.

> 
> 3. hmm_range_fault()

Yes.

> 
> 4. page snapshots, although that's actually only used to test zero_pfn so we
>    could probably drop that if we just guarantee device private offsets are
>    always invalid pfns.

Right, I think that can be more reasonably cleaned up.

[...]

>>
>> It will likely still be error prone, but I have no idea how on earth we
>> could possible catch reliably for an "unsigned long" pfn whether it is a
>> PFN (it's right there in the name ...) or something completely different.
> 
> The idea was (at least for device-private) that you never needed the PFN,
> only the page. Ie: that calling page_to_pfn() on a device-private page could,
> conceptually at least, just crash the kernel because it should never happen.
> 
> Obviously we identified some exceptions to that rule, the biggest being
> migration entries, hence the helpers for those.
> 
>> We don't want another pfn_t, it would be too much churn to convert most
>> of MM.
> 
> Given I removed pfn_t I don't need convincing of that :-)

:)

>>>
>>> So any core-mm churn is really just making this more explicit, but this series
>>> doesn't add any new requirements.
>>
>> Again, maybe it can be done in a better way. I did not enjoy some of the
>> code changes I was reading.
> 
> Ok. Was there anything outside the exceptions above that you did not enjoy?

The last patch was hard to review and I am not sure what else is hiding
in there. As said, breaking the patch into logical pieces will make this
a lot easier to review.

> 
> One idea we did have was to make the PFNs "obviously" invalid PFNs, for example
> by setting the MSB which exceeds the physical addressing capabilities of
> every arch/platform. That would allow dropping the hmm and page-snapshot flags
> although is still a bit of a hack.

I mean, that might be cleaner, because *maybe* one could just teach
pfn_valid() about that? Or have another, more lightweight helper that
really just checks for "ordinary" vs. "special" pfns. Needs some thought.

Using the highest bit as "this is not an ordinary pfn" might just do.
Maybe some highmem considerations (making sure we don't run into weird
stuff).

> 
> Ultimately one of the issues we are trying to resolve is that to get a PFN range
> we use get_free_mem_region(), which essentially just returns a random unused PFN
> range from the platform/arch perspective so an architecture may not recognise
> them as valid pfns and hence may not have allocated enough vmemmap space for
> them. That results in pfn_to_page() overflowing into something else (usually
> user space VAs, at least in the case of RISC-V).

Yes, I think it's a noble goal :)

-- 
Cheers,

David

