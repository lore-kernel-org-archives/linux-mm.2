Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F27FC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814A86B00D4; Mon,  6 Jul 2026 04:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5EB6B00D9; Mon,  6 Jul 2026 04:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EC26B00DB; Mon,  6 Jul 2026 04:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43B8D6B00D4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:42:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1BE71A0330
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:42:52 +0000 (UTC)
X-FDA: 84957711384.14.CF991E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 15B2220005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:42:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIn7Iybc;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Q5OO705sqjVj6V3CrHEmc9+5Y9WaD9cC61NbPqoX2M=;
	b=MGiP1F3V4KMaz02QNce6RcrgKDqqjHaB4n/yEWA3Q0KjW1+XhrQRa2boFm3raiRmpq79WU
	uZ6sARCDeViatbhYmzfEpY8a7ywpethXDrtOiyjWAVYmsNR1zxHGeE2X7peDiv7aqKXSX+
	/ZEfxXUe0DrZ7+BsA5qFii6Nuzc3J+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327371;
	b=JDjYqa8m0TNRxqn2iS7BaReMAEtovb5Z/Y6aEtj775oGekdETnQXfr1w7NG7LWRKW3pjZ8
	Dme4YT/1+EAMKb9dS1vjuMsdaHp1em7SYSXpRNs/Bi5+mnT3MBIB/d3RZHOcSDYICM6me7
	ZxfMpCB3d3r/ap1JlckPtdHspXN727o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GIn7Iybc;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0B2F600C3;
	Mon,  6 Jul 2026 08:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18FD1F000E9;
	Mon,  6 Jul 2026 08:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327370;
	bh=4Q5OO705sqjVj6V3CrHEmc9+5Y9WaD9cC61NbPqoX2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GIn7IybcH1uE5DRSJIA+De7ml6yEreHoYtoLylpcdr3GmdnCHE1BTfJt77E81gIrC
	 Bu4bNtxk72Z215rCaWwi1riDyON8LcC30fP0JWQbX3ZDlEKm73Z4JVvyg/VS25Tu0F
	 U9kFe4eN8/5l2LqnonCP5kQPI4hSRTA0MtQbYniBu1TAG/o8crimtVNxICa3IGfTQm
	 44vkMz7rqjToCBYZJ4aNovjI2sQ/eOAxpg1prfNueRtcxJoJ8C/gbEQ8WlLhIT5qVM
	 kyHoUejLrtHyd8J44dK+2YFbFNgNWhLQeoS+kQDnIxdK/jEy7vo/AMVARDnMihBhHQ
	 I4ZtnrgU/XBGw==
Message-ID: <503aee9e-97fc-4889-a379-3c0a5d140554@kernel.org>
Date: Mon, 6 Jul 2026 10:42:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
To: Mike Rapoport <rppt@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
 <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
 <DJQKSKCN9KIB.25WIOU9KF9CNV@linux.dev> <akpBWmnujSnj1ZEE@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akpBWmnujSnj1ZEE@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15B2220005
X-Stat-Signature: tareag38utzqddzgeayo4gj8uwyertwn
X-HE-Tag: 1783327370-236134
X-HE-Meta: U2FsdGVkX1+//Xk/PfYKb1iYxGNeV5GQU9b8Ode4lA06KmfOoXUHpDdeVS0aVhmO9RsuDx5tH/DmDneumfiuYDrrZb2V2tM43joCkBcqhJfcGIm2SOEibgdrY3p7gf64ur0WhAX/McpJrtb4cYDHGN+eZuwnS/huyLATCrS0Wzl7XsTlpsuZASpO1WTmPGnbvfgEPvL3CFIICBgUy3YLFImDbCYAzBZiXt85T53VqejKLlLnrvIEbIp3ZZFq3yavZnhnSialZsVRnlyORGrei3V0/+VU+EeuqiUFbB9dj9dC4Cdaq/z+FwJsfjVcZzcfLAYyWKXp+dnMkYuQLSM+wDhQx82bipwX01DxS58Faww1YBy/hVDsoUWaZGoA4SuqFb/ES5f4P6A4dYCvZkxd62QmLFY+pnSiSCR/fVssI4rNIZGyM1AgOqax8QOeost5XhOiQF9Fr8efZiaCvOw8xijwQM4iu3fXpOwkS2rTPhTK/cFlMCWe7GjO70QpNd9OmN36I/0zlllUQhHl0xBHzPi3/5AAEdW6qTAMZCXaJ4yuL5gHLE1pAo7XIPfqCBnjhd/zasrMJPDDEU4wyn0MS3dWRVVU2tDqNyo5RMSYcc6efn4oUviB5LhGZj4fuFAFORyaX5NDfkdzSUdTr6Wkl6k6EWTAUvMpwBj3t2rSCxkn+WWg545zh6bwC1KckjpwV2mmeZuyvIcWmfRN/+i7rjSE5wc5ZnTEoyaFYlse64kcdCNEHry/ufRQE0g7rd3Ol44WlAXWjanhNREs9+GsaX5shjCtVGMx6JXiWUw8XVkqI3xAb08krDZBm+/ZNHzGf92zcU4SmzH1Kceip4BkUowCOZ7Dk5S/9Yq3lgwsd5poha3pWozsY8hK4louKlOeQeHK9XykRrQRQzjBXNHZW+n5hxJZ8ebAmGTL8RZcExH3HWaLErKunSvvPgEszItWRZstXI/FSaPK5MYa4i/
 hlF+yoYq
 64/Ceeeot8TojzV8IDeKLI7XrMXnayIsjzubi51s1QNwrVUcG2KRQhmQF8Aq9et2w7KrwFQz9+UGxigeBhwSCZxEyPFQJ4vqkpcCVSdIdxLjGhmW6+7MYFDWmg+pwyMAAoRoMFNW8TBYpdUcbWc4CLCX8zP5pdIX35ZtK9RJOIlY/GEGTOeRDMvMAolt/JuwJrJrQguJzWxQkCjern4gQ3KmtbNkrc6UCt8gQT0TBd4N9PxHRWoreYKT+LpwtLYgnfA6S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 13:34, Mike Rapoport wrote:
> On Sun, Jul 05, 2026 at 10:46:19AM +0000, Brendan Jackman wrote:
>> On Sun Jul 5, 2026 at 2:26 AM UTC, Andrew Morton wrote:
>>>
>>> Well OK, but the secretmem code is still wrong.  The patch protects
>>> people from hitting the bug but leaves the bug in place.  Surely it would be
>>> better to fix the bug?
>>
>> I don't think the code is wrong if highmem is disabled. Certainly
>> there is an implicit coupling between the .c file and the Kconfig file,
>> but we could always add a BUILD_BUG_ON(IS_ENABLED(CONFIG_SECRETMEM)) to
>> the relevant bit of code to make it explicit.
>>
>>> Is that as simple as adding the folio_test_highmem() test?  
>>
>> This would fix the WARN+SIGBUS but I don't think it resolves the fact
>> that this configuration is completely untested - there are likely other
>> functional bugs? But more importantly, I am not sure if secretmem
>> actually does its security job if kmap_local_page() isn't a NOP. I
>> think shipping a "security feature" that doesn't do what it says would
>> be really terrible. (It might work totally fine, I dunno, but it would
>> require some research and deep thinking that I don't really want to do
>> for a configuration with no users).
>>
>>> Or switching to GFP_KERNEL?  
>>
>> ... Oh, that's a nice idea though :)
> 
> GFP_USER if anything :)

Right.

> 
> But still with kmap() and friends not being an NOP the promise "kernel does
> not map this memory" does not hold.
> 
> I think that keeping SECRETMEM and HIGHMEM mutually exclusive is
> conceptually correct.

We could even limit it to 64BIT ;)

-- 
Cheers,

David

