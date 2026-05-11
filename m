Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D0FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7729E6B00AA; Mon, 11 May 2026 09:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749EC6B00B9; Mon, 11 May 2026 09:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6606C6B00BD; Mon, 11 May 2026 09:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54D006B00AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:42:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 070291C006A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:42:51 +0000 (UTC)
X-FDA: 84755254542.05.697862E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CE324000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:42:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EBLtnSG5;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778506969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZCQkOBH2aMemBU8J9OZ7T3Pp5tnAYYcq5hyraC71qI=;
	b=tDxmn82cWFtT9ooyWom2WegfxpNburK6ionORAec2VAMRQ4XHGjzVUdwd8M4Nli9JjzUTl
	8OJ1F1U/KqUGCx+JyJnlObhnHgVhwgrhyBYysVKzZTSmG930gHoqgUSrElS/vK5S1ZQsFM
	NHaZ7KdVKRTWB05oyxFt5LCHjmvLJ/I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EBLtnSG5;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778506969; a=rsa-sha256;
	cv=none;
	b=ZX2+zUDQRNlhqcRogSzK36HvZoEM9znNBryk9mLGXLHkJh2qXcu9USaYySmrIaKreBz8GI
	JDvXvt3WrNFIZ9N2PG17OoRZXUo27PYZGmEqznf75Sjj00FvRooGLQKEjxJebvecnjQgWE
	7MWarOwdkL8l/v7fKS9By6alnh1thig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B054F60123;
	Mon, 11 May 2026 13:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D28C2BCC9;
	Mon, 11 May 2026 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778506968;
	bh=xOte3uNSZatG3qR1qsZN8Z4Fe1SxHgD1xOtRdYD/D38=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EBLtnSG5OM1F0I5eqdeN2Hg0EcB9aE5nXbkRXs9IiJxcokJFzbChdymWZnhpLeDEJ
	 5du2csfjyaOxZTFEoJDRI1E2ELCNM/Gs3UJOxuGftMkiILC+eDFWS1zdAdoRU31xTv
	 j2xwAbh78Iykw+KGTFGPyOpIlE/6Wexj+jgVU0d6oTUlqqDCc7JPMSecz9jYydpJS6
	 nxDtjxWFm4Wnvy7JPIUcQpsoSDkbMQVtSK2TfsXhoW/4HQ1sLb2p9iC4HjhFcm+DKA
	 J9Cf8RFN5fCGguro3Gnr2g2BTQD3nj9rmCLgZaaFUxRDk3IFTmubN6RvtGE1MPnxRf
	 bt60BA0Qa/y6Q==
Message-ID: <574fc329-bf2d-4686-9f15-b1709432326e@kernel.org>
Date: Mon, 11 May 2026 15:42:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: Usama Arif <usama.arif@linux.dev>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 lance.yang@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 ryan.roberts@arm.com, liam@infradead.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, ljs@kernel.org, akpm@linux-foundation.org
References: <20260510114001.600681-1-usama.arif@linux.dev>
 <8838114e-5b6a-4f3d-932c-9e97e51216ae@kernel.org>
 <608bef55-44d1-47f1-a201-4a6bd7be137d@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <608bef55-44d1-47f1-a201-4a6bd7be137d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CE324000E
X-Stat-Signature: iok6m51hpujh46miy1dq8sob94u454di
X-HE-Tag: 1778506969-148873
X-HE-Meta: U2FsdGVkX1/zsauBVCGBxS85/kxVabsDrwPBUp+mH8u4L9BPYw7AMte4VMxuQgDkf1h5slPGOaENbCgdii9SssrOVqtXBTJy4XogFxKTy/gPLck5rKD9AFHagjhWYINS1vuy4/PNwdVzaGjwYHOEaVl82/5KmGSUxCxLHJ2O0XSLbrvFXtqb5EaiUkiIg9Nj2995vEAIssP0pF1uG9NN0OZmzIMFK0/eBEdhTx69H9sNI+R52RNAjna9uWS8QogeaZNi/zBoHxxl3KiVr9NGpdG3YNgWKuXH3PxY8He34PUVBWs/u1NLkja/3yE8FBZ/kl7WraG5XATjlrZjBgyLMDf9sicQ13WA1Lm3mzMam+FPWeQlBOorm7fxDjM4W2SY2Z99Thewme+ePorn+5iiPJX+f8b4cLi2X+oFWMU7QNWyoyxQw90oaX9wW16qGUALjPC9d3+rt/yt5OmPhwuGKP7BVD3vaM2RB1L31Wl598eAPj78p6PG2sShR5+IJvvd50RyIEZEK4xqvKdvd7Eof9prVCa0zhacqb0wuDr3suAwQfoR6zY1KjoXdKxU/PaJ2KJUZTxOGmu+BFJ1Yl02muJMoQ8tSrVH0yQTQBwhXTHpDKYWCzBtV0breJpDS9zbXv3aInWJkfMHCTCm9k44p3H97q55S7wpc1KTZdqUDtMIr8NTD8/u/FsZc37Hh1b6NEnu76eZucsQsd6LaOgGIzuQUxNBSR4psy4C18Ec/IAK7BH9p+5B9mkgYkiRxkXBMVHVjP0eoow/DEG+LEZvKNiH1AY1vA6dTAxaSUWuhp1ndb5J0PgjqlSrtFnAd7b1duAlWqF7NCEJAH06Zs2IuGiR1cvYiOV0poLxAwtVUoh+rphIhdBJYAxqnZwP5gpU/18juPaIlgvk+08qu428BrB9MfDUef3g0LUghZ7SBcqdGqT0OqEQBjlBSpGH0Txs8tpdFYI6Cyl9Hln4Cly
 XscMfpfa
 Mf+ebOaNrmiyU9djosFYjCvBQzAewYTQ2LZn6c5tR05Pr/9mk1MwvEVyK7Y4mnbr6FvCQYoqZEqKyDFFaC0Xq0pkVGeCFGbk7LJhHRCNs833yfXckdwOxMRnI9D3Jk4/cOjluec6VGR2EFhB6Yt1ugUJkLaMvo35FsJDslei+9P0yW8oiEwzrGsv/q5uXp0c8C1muSrQVFFfoDwCnW1lN/4m+7BOzVPLoLRVEqs86zvlx5/JTEc5egogMbD+0yzQEMpNl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 15:10, Usama Arif wrote:
> 
> 
> On 11/05/2026 07:36, David Hildenbrand (Arm) wrote:
>>
>>>
>>> Hello!
>>
>>
>> Hi!
>>
>>>
>>> I think (3) definitely makes sense.
>>>
>>> I have not had a deep look at KSM up until just now, so might be dumb
>>> to say all of below.. :)
>>>
>>> What I see is that KSM scans THPs as 512 individual 4K subpages and splits the
>>> THP whenever it actually wants to merge a single 4K chunk. That seems like a
>>> lot of work for a single 4K?
>>
>> Yes, but that's what the users ask for: if there is a chance to deduplicate
>> memory, it shall be deduplicated asap.
>>
>>>
>>> One thing that came to my mind is to have a separate tree for THPs and only
>>> merge the THPs that have the same content, but the possibility of encoutering
>>> 2M pages with same content is extremely low? so this is probably a bad idea.
>>
>> Right, the probability is low, and it would change existing semantics, breaking
>> existing users.
>>
>> In addition, we would have to add large folio support for KSM, which I rather
>> would avoid.
>>
>>>
>>> An alternative is, does it even make sense to process and split THPs by KSM
>>> in the way it works now? IMO this is a lot of work for a single 4K merge.
>>> Shrinker is designed to release memory when its needed, i.e. reclaim, at
>>> which point IMO free memory is more important than performance. But KSM runs
>>> all the time.. so constantly splitting THPs everytime a single 4K can be
>>> merged just hurts performance all the time.
>>
>> Right, but that's what you get with KSM: bad performance if there is a chance to
>> deduplicate :)
>>
>> (and bad performance from scanning overhead)
>>
>>> If someone cares about memory,
>>> they should be running the shrinker.
>>
>> It's not just the zero page, but really any page content. The zero page is
>> currently only "special" after we added conditional support to deduplicate to
>> the shared zeropage in KSM. The shrinker doesn't help for any other page content
>> besides zero-filled.
>>
>> Further, the shrinker is something system-wide, whereby KSM is usually only
>> enabled for selected VMAs (with some exceptions nowadays).
>>
>> Also note that KSM deduplicates independent of the folio size: not just THPs,
>> but really any (large) folio. Yes, it splits large folios, but that's really
>> just to keep the T in THP.
>>
>>> Is a better alternative that KSM skips
>>> THPs, THP shrinker splits THPs into 4K subpages when memory is needed, and
>>> only then KSM gets those 4K subpages?
>>>
>>> Above sounds like reworking KSM, but just wanted to put it out there.
>>
>> Right, and it makes KSM more THP aware. Which is something I would avoid right now.
>>
>>>
>>> (2) + (3) sounds like a good solution, but I wonder if above alternative
>>> of KSM just skipping THPs might be better?
>>
>> That would change the semantics where, for example, where we expect that memory
>> was deduplicated after a KSM run.
>>
>> VMs (where KSM is usually employed) are expected to be mostly backed by THPs:
>> except where we can deduplicate memory. Skipping THPs would essentially break
>> the main use case for KSM :)
>>
>> Does that make sense?
>>
> 
> Yes, all of above makes sense. But I feel like this means someone should not
> set THP policy to always and enable KSM together. 

IIRC, QEMU will, as default, set MADV_HUGEPAGE and MADV_MERGEABLE :)

(KSM itself later has to be enabled manually on a system level)

> In general I feel like KSM
> is not something that should be run on big servers, as hopefully you are
> not managing memory as 4K chunks for big machines and using a lot of THPs.

Right. But the 4k chunks are movable and compaction can move them around to
create THPs elsewhere.

-- 
Cheers,

David

