Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDCCAFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 16:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155FE6B0088; Sat, 25 Apr 2026 12:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1076C6B008A; Sat, 25 Apr 2026 12:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37706B008C; Sat, 25 Apr 2026 12:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E02F36B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:38:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B65C12036D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:38:20 +0000 (UTC)
X-FDA: 84697635960.08.7A59BCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 84AE440011
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:38:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkp8MEy6;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777135098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MmHX+mE0A39dIlINHn1FZ1iFXfsddgRRs69I14BlNk=;
	b=ZcQlx5y7brTNivMQrIKErVSFOCDIgzmETahEJjhWw5vH1ql6P9SZaFn+PXIZv+P/IbNVmy
	hkmr4FFDXAeAvFk5o7KbZ6Jd3I6vZ9LwYFJK4KguXQYzZTkK9X/IpXb+Yuu7x425NpYI24
	fPpQcEgG4LwsHFkBv9zggEa4f3uIbWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777135098; a=rsa-sha256;
	cv=none;
	b=D1n9dA2UvCGVo9QMzBVyUjAW4BvIxmYC06XIviyTwQ0lCPZn2OibcShNYRbDTvMuESUPvf
	2djo8xVyvJW6soksA0So+16iQzgLZcEOp1bHUVcE8HT3qTGJor19MtxqmGxwPjwVwSGnP+
	/DWiCokEeTSDH5Vgrl8inFBifyc8mUs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkp8MEy6;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59C774369B;
	Sat, 25 Apr 2026 16:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F4CC2BCB0;
	Sat, 25 Apr 2026 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777135097;
	bh=EQaknTyW5xfrIybCdsauIZdStSASsj39zFLJnMiJgm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dkp8MEy6yFyo6oGIcyMXEu1jfTy/7hNVAesl76XcrbMoLka631A+jjV3mUGp2nK0c
	 c8uou1pbzxT1Gbu4kKSXLNyV4QSkOPHlSeBZlMd/Xdsk4terPUz48fqhUkqncAQUqB
	 WbOT43uXx5U/gMI6w2dwjJANUgXXjMC0xaU58GZg3Q4MXp9M6j+dtXWcQMfqqJk2Ve
	 B6zYvzGkkIqJr4Kur/pmx/AMOPPSqE5FWGinQ+/J+89+tBObJgNrkZaDxVM+1v/H4J
	 L0cfYdvHWg5YYSfSMvPQ/iOKQKZtFjjqrqRYEgSyxaYxM0Oo041NY1zmypkMBSFc1T
	 bAUpyfNeU0Q5w==
Date: Sat, 25 Apr 2026 12:38:15 -0400
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, skhan@linuxfoundation.org, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
Message-ID: <aezt96xgz_qyf4d-@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
 <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex>
 <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
 <aev-DS4YTp5soVPd@laps>
 <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 84AE440011
X-Rspam-User: 
X-Stat-Signature: hbb94gxn4swt1m3ipjr1qj7fcsceq59e
X-HE-Tag: 1777135098-700221
X-HE-Meta: U2FsdGVkX1/lmrVUrHu0ydLh2Z4cP8wn5gd0XvUcz5Qw7dSgh6CuFck7t7i3wFJ2WnLI3Ribmff7L273ei/9CwY537XVUvZn24V0ADU6QSSlmUAHlhTtxexTZ5UOvcELhAHhYiAtR+GG0m7xxzcJzGYLMqPGimx01lw4oJ15Vf581AfEfFCqmJZ9ONBd1NQU3CoMrHQrvzRuCHmIZDe4AsRBMhsvCy82DqyhuLwfBqFo+fYeTYCIHB2c0uup8is5Cs5kF4QUuUzk6xbklRO5J0LxX+p0tOYIOMWp20t7C1RM2e/7WD/K9YrKgfSjXLXqJ+71SN1BTsgHSUnyQ+MPuVirNAMVxUx+BcTokNCtJ3MDmfLFaeS27G2IESKBwcUD4OMIIqPNQV9VZrHoMV5nczKrtBJyS+8enxKZaHvnRBPokttht/5qhhdzC9A3m5J7FsX326+3wdILhOrujef1DBWGOPnyODWhtRhMLuHdhWHSFi1lFupRZ2GwWIqm42jYiYE2bl4eF92xPCGpY2o3iEfSgnIY1rr3/YW9nN6HaBocJw/KFQbHrMoQj8c7njpK19bA9xzoXGspQMIgyHYVqiZsGZw+twUHqOM6TbQJWclf+w7R5p+WHkBe0st8vAY4/pVBu7ENCc2ET3iFTerHkrvhrVvDHZ8G+Toubst+htrhQk7kkKl7wwe4qpfc97fM7ZWYOtFU1wNFiT23EGZzO4rEMBSUsQI4MDJRn/Hqwkex032frgR28e+DPGkmJyn7RZubYcl/MmC7jTFw63RdmA+euRZOwruarDvO8GH8odpRaO3MsGflcyewkijr/ZOxRxws4cGp+Y2nR8BESBbfGCE0/UdyY5l8dWo1ffx+caxDtpvKs4hvR5iuzHEF7T7JcY90QWvN3N0y8oDYb76s5guOX1Aa/zzJlhwhHY+eZRtycjVP4Pu610d+ssxI/8zRKwexfhIqkw+AxIbwvAF
 8+3Mpfan
 C/zPI2FrAgEArtGtJt6/+anzHOCnH3QxGfYzpr9uQDay2KvTcm7N9WBrZnUefjNIBDstqexAu4emlWZT2rORH228m2JOv+CRGAPwmJOneGSpgYAEoFJKfLi3mcQIE4D7VZKbi4GXudw4JmzkvQGkExH9szQF6VGYiMPsqBfbibZA2eb4cXwxLztityKqHEBqsTWT8DKba5NA8i7riizJkVKHfx69Hmte/MIcqIad1vOl4E9/58BxqS08KSlPKfq7xMB5P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 07:30:56AM +0200, David Hildenbrand (Arm) wrote:
>On 4/25/26 01:34, Sasha Levin wrote:
>> On Fri, Apr 24, 2026 at 08:28:14PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/24/26 17:06, Pasha Tatashin wrote:
>>>>
>>>> The issue is that we are going back in time to a flat memory,
>>>> without NUMA or hotplug support. We need an abstraction that avoids
>>>> allocating this memory in enormous contiguous chunks, as thit approach
>>>> will not work on modern hardware.
>>>>
>>>>
>>>> Page-ext provides all of these capabilities, but as you described in the
>>>> cover letter, it does not meet your requirements. Therefore, I believe
>>>> a new abstraction layer is needed.
>>>
>>> If we decided that we want this (and I am not convinced), we definitely want
>>> something that supports sparsity and, in particular, something that support
>>> memory hotplug.
>>
>> Makes sense. Let me take a few days and see if I can find some middle ground
>> here.
>>
>
>"The natural question is why not use page_ext. The key objection from a
>safety perspective is that page_ext stores per-page metadata in memory
>that is itself subject to the same hardware faults we're trying to
>detect. The dual-bitmap approach works because the two bitmaps are
>independent allocations - corruption in one is caught by comparison
>with the other."
>
>So you want to have two bits per page, whereby both bits come from in dependent
>pages I assume?

Ideally completely different DIMMs (though as you point out later, we can't
easily make this happen).

>Storing one bit in page_ext and one bit in page flags would be possible if we
>had a spare bit in page flags ...  We could allocate two bitmaps per memory section.

Right, I think that the approach you proposed is roughly equivalent spatially
(though I'd need to check with the safety folks here).

>But the real question is: how far away do these bits have to be in memory to be
>considered "independent" and not prone to the same corruption?
>
>1 bit?
>1 byte?
>64 byte?
>4096 byte?
>???

The notes I have from the research side of things (which should be taken with a
grain of salt) are something along the lines of:

  - ~79% are a single bit corruption
  - ~9% are row faults, so multiple bit corruption within ~8kb
  - ~4% are bank faults, so multiple bit corruption within ~512mb

Obviously the numbers would be very different depending on usecase, hardware,
physical location (did you know bits are more likely to flip in higher
altitudes?)...

>"Embedding both in page_ext means a single fault could
>corrupt both the tracking data and its redundant copy in the same
>allocation region."
>
>I might be wrong, but isn't that the case for any such fault, as you don't 100%
>know how the DIMM is organized internally?
>
>Do we really expect that a MCE event would, for example, very likely corrupt two
>neighboring bits, or two bits in the same byte etc? What are the odds that we care?

For something like a datacenter deployment I'd agree with you - the odds are
too low to care. For an unsupervised self driving vehicle, where there's no
human (locally or remotely) available to take over, I'd like the odds to be as
low as possible :)

>It's hard to tell here which part of this work is "too research focused". For
>example, if I were to write a paper about that, I would make such claims to make
>it sound more complicated than it needs to be :)

-- 
Thanks,
Sasha

