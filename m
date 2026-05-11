Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B81CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 06:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456A66B0088; Mon, 11 May 2026 02:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0356B008A; Mon, 11 May 2026 02:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8426B008C; Mon, 11 May 2026 02:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16B006B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:37:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A44E1C04B7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:37:02 +0000 (UTC)
X-FDA: 84754181484.13.73A6FBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A2BE20011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:37:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8QGs785;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778481420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZUi7MzipfUgRw8gjEoTGuMqJEu9A7iduq2t5JAZuhw=;
	b=iYuzK7ZBA92GXR0BCQDU8kpcjh6yTrO9YNnAGs1dVG7eU60fkNwmr4HJOf11VsOSA7SDqA
	sCj489dYQiwLvU/jw4rcJ9mVPLGmsE65JuTVixuZE6Dvxsw83vIaqlHcxjxfhUTeFc/hcS
	nzw942Lx5RmrpVTcZmSH6S7e2HNu4OU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778481420; a=rsa-sha256;
	cv=none;
	b=L3oUqaqQrLptEUgkNVATkdlT7dVAlvfNku9GWX8fPNs33Z4loyz6KiBeGjGlAPo132MuzC
	E4De2qAtIRE1Ml185rM0c5g1alXyYUcsTB3tFWVii1gTv6hrwP6/te62F0srvlW5jB9XK7
	NT1iW6OzLiEjLqOcqi5uXn4BI9poj8g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c8QGs785;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 969C943804;
	Mon, 11 May 2026 06:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E35C2BCB0;
	Mon, 11 May 2026 06:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778481419;
	bh=ept+w7gNJFgeQ60qrTV2nO2GYy7mqakuLHoIBQvP3bg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c8QGs785q87YAORd+5KSXDbeqhYC0NihcuNSSc3GlN2YEfde6NHGV8QaixmdJ5nfT
	 E2OV+4wMY3Ryv0JB3tMFRvbtz85QPt+fRXYe0J5Us3snKbM14tT7AS2XcGHI0u9H5z
	 2eD3GuGtiCd4qSo1Y5VGt1XosKuFab1yFtdIHyZdqYOqFdKJVe8qxSdgP6xpc8te4x
	 BUvG1RynGidJByVR4y46rO7FD6ZGM/tOwl/jihIt3aWEBrCz8JO1Hot5y0zXmaMdNn
	 GWLprvgkxFuN4391NdlGsKYqaqG26irEJHX1lIEiIuWoV4nItXAPkYaa3uyiU882Ef
	 m3992kgY+SbMw==
Message-ID: <8838114e-5b6a-4f3d-932c-9e97e51216ae@kernel.org>
Date: Mon, 11 May 2026 08:36:55 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260510114001.600681-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A2BE20011
X-Stat-Signature: wsfbfz1qkmagpp4qqnsojmep9iy9d66j
X-Rspam-User: 
X-HE-Tag: 1778481420-201189
X-HE-Meta: U2FsdGVkX1+n/xKV0rONX4aCSwzU/vGGgtNOf2jVDFx3asiBEWwjhV4KmibujV6DVvoMIPtebdlR8a3LVabZlox9pvUF6FiehzKLdIUkAlLLS50XYrAgLT8wcFDukTjxZmxjDLZAwYE1kQRL5aE5aFDCvhHYYwXbtErTpBzlj6bzPwflKPMspNY8hYHLipzrMGerYSsadGUnjfBh4PwhIMN3VCofQORebh82iB95kRaDQI8pfo/+r6TZOnAI3aS8fqaI8ep35SPOTSlBHPQctN2dYlFftVUHsoJgbYEhTPoINCuwv/9FuQ9/VMBRjQPlwZF/6lzkqJM/T8lRGwvNW+c9pZfKbtB0gpzAmIKbYs2gQdN2ph4hdv7YUUnzloQyUI3kB8c7BLcxwyKQmGJjb2tUEjyBWp0iSEaBLFx1zArzv/tXYn57j+4VI6eMRCrsBXlCnH/ISp/aGJ3nWFnuINEngu7g/f1EnHgNCGlXFNSOXalxIOcWUnf8Q2q9ah4s1jDl13Z/7zer9TkYZ8w+oaUVZ6NeI0MH7isoFJv3S9QB6rG52Kw2HUg19kJCaA2puw2aIK6qH2nZY7fIwYc8I6KNh3IbqYyhEjiY/qqAgBHwLFCvZb14lFxB+w6NvKJ42CV96rVbpbaxHqyHAPoOLFtzDpxlO132ZnmZG/6z5U5ruaoytOkERWd6T5tu+Z2rM4P3U1MA2LIyrPUwju1aqC8mX70GKDksNKYt94YT08mO9UUYDZ704+0WoYF9hJCuDlBwmAelmHcUjGleo4z2LsZWr5BhODDhfNmj3u9tI8AWUShpOXTkOWfSEwZTuKqaCjk1d9cNbGedLw0w/wKZ29p0GvSzgugfuTCsyyIqrHzsEjkuDDwvDReP7fFLS1GDxAIZm3it8jrbjGkaC8qHiVmSfejbRo0CF4Ohqg3F9sGK6eVBKZb91fEojxQUij66u0xgXORI6+gEHXL+wur
 JMRHuNuv
 zP/vL7lR2xMV0Bk+IdAJqbQFcxIlNMrNimkHMety37JYa+7TnYW7E4bG3pnjIc9jrf/6HDOE/p3Nu54ggxzV9qRJpmjHEwA9zNT88x7tsmTonpNXM+ue9WVSFQ5p0FQ0gCRBhPV5vthcWg1tF0I90aNHPR34UVdFblcSbETFCQsAllO3rWiNi2xxZbCTRZcEUw6DRLwyAgunfFYT0lAL4dzXR9GRveFtkX4vrK2I3pI1Tpbxn+YQlQmNPM0RJOG96yvEp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> I tend to like (2), and maybe (3) on top. Opinions?
>>
> 
> Hello!


Hi!

> 
> I think (3) definitely makes sense.
> 
> I have not had a deep look at KSM up until just now, so might be dumb
> to say all of below.. :)
> 
> What I see is that KSM scans THPs as 512 individual 4K subpages and splits the
> THP whenever it actually wants to merge a single 4K chunk. That seems like a
> lot of work for a single 4K?

Yes, but that's what the users ask for: if there is a chance to deduplicate
memory, it shall be deduplicated asap.

> 
> One thing that came to my mind is to have a separate tree for THPs and only
> merge the THPs that have the same content, but the possibility of encoutering
> 2M pages with same content is extremely low? so this is probably a bad idea.

Right, the probability is low, and it would change existing semantics, breaking
existing users.

In addition, we would have to add large folio support for KSM, which I rather
would avoid.

> 
> An alternative is, does it even make sense to process and split THPs by KSM
> in the way it works now? IMO this is a lot of work for a single 4K merge.
> Shrinker is designed to release memory when its needed, i.e. reclaim, at
> which point IMO free memory is more important than performance. But KSM runs
> all the time.. so constantly splitting THPs everytime a single 4K can be
> merged just hurts performance all the time.

Right, but that's what you get with KSM: bad performance if there is a chance to
deduplicate :)

(and bad performance from scanning overhead)

> If someone cares about memory,
> they should be running the shrinker.

It's not just the zero page, but really any page content. The zero page is
currently only "special" after we added conditional support to deduplicate to
the shared zeropage in KSM. The shrinker doesn't help for any other page content
besides zero-filled.

Further, the shrinker is something system-wide, whereby KSM is usually only
enabled for selected VMAs (with some exceptions nowadays).

Also note that KSM deduplicates independent of the folio size: not just THPs,
but really any (large) folio. Yes, it splits large folios, but that's really
just to keep the T in THP.

> Is a better alternative that KSM skips
> THPs, THP shrinker splits THPs into 4K subpages when memory is needed, and
> only then KSM gets those 4K subpages?
> 
> Above sounds like reworking KSM, but just wanted to put it out there.

Right, and it makes KSM more THP aware. Which is something I would avoid right now.

> 
> (2) + (3) sounds like a good solution, but I wonder if above alternative
> of KSM just skipping THPs might be better?

That would change the semantics where, for example, where we expect that memory
was deduplicated after a KSM run.

VMs (where KSM is usually employed) are expected to be mostly backed by THPs:
except where we can deduplicate memory. Skipping THPs would essentially break
the main use case for KSM :)

Does that make sense?

-- 
Cheers,

David

