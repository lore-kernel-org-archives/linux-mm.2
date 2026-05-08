Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF78CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A85F6B028F; Fri,  8 May 2026 16:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480056B0291; Fri,  8 May 2026 16:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396206B0292; Fri,  8 May 2026 16:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF8C6B028F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:57:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B83B4C1480
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:57:26 +0000 (UTC)
X-FDA: 84745463292.11.788C20E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD3D31C0004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:57:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfpZE6eY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778273844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUp4ijziWEkU2rRwK4y5fVXZIMo0HAUAdDyFEd83HiM=;
	b=W1SxKXhUgmCRYW+xhANytmRclNNEQ50smLQZPKJhLasW0DTLp3LjPXb5Ns2xGtXFbJBnEX
	8s8TZyLqmNSKJfA03SSJwOTEWsozmm/XHpdI05caKNfJGWozaFcb745E/IM2Lp9TzdfN+I
	7Dh3YotdCAyryuK23s4czcFxhvdUAOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778273844; a=rsa-sha256;
	cv=none;
	b=M+xXLNoD3nLXLnCH2VFeK+nwBtf9K91022LUDh4XJZEYeaJ7VcZPCnmymrkgqbWHl+BDAb
	X+YZDcuXcYv3WGzIErq+JGI4DCWA+NqnbEkeeWP9BbW1ov6GChPqCrorJRYqGenBNRGawT
	8MsIu8iReWdMTfjvhv4swyqgdZQq4AM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tfpZE6eY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44D5960181;
	Fri,  8 May 2026 20:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFCCC2BCB0;
	Fri,  8 May 2026 20:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778273844;
	bh=P0LPck5iZ57XEazF2tF77MDiL+FHxAD/GOm7QcnhYVg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tfpZE6eYCOoa555WSgFCjpII32tak+LzoaEaRxP4ye4qZX7LgRj15vNiOZ2695llU
	 MNfVHEWhiFY6NnFFa8g8nQJfBRxUAO+Hn0nxWPWPY5B4fUrvx7ZZuLyM4/WOD1ugyw
	 AzwkrXl7H4ko0dH7qaCv8zpEE0bn6HMAqhQ5z3pD9gHVG7WyGmnci/dDwWGWDIGX7/
	 xf4ifUyl42MHwVWOLr+va8tvt1bsRStWXPNtn6qLNu81pF0Weni7PEtzVKdWzsRwBB
	 mUwDRC9H1eIQfQERPDEtttridHp8UyyA6p0liXVgbGLYBVU2fM9ptlFEUo4w0D4V8y
	 2H7OVgjzqkAHw==
Message-ID: <1abedb3a-f162-42b8-91d4-7d1b3df43fff@kernel.org>
Date: Fri, 8 May 2026 22:57:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
To: Robin Murphy <robin.murphy@arm.com>,
 Feng Tang <feng.tang@linux.alibaba.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam.Howlett@oracle.com, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Christoph Hellwig <hch@lst.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
 <6dd52f8b-7092-4d02-ba24-f8b55409b7b6@kernel.org>
 <afBxtIdWqv8pD8YE@U-2FWC9VHC-2323.local>
 <f900172c-341a-4956-b7b7-b297418be913@kernel.org>
 <aftiQuHOA0t2lfyP@U-2FWC9VHC-2323.local>
 <a5660e22-b1f9-4dcb-a190-f3dc5253c570@kernel.org>
 <59d05fdb-bb61-4d92-8df3-45aa3f9f7bee@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <59d05fdb-bb61-4d92-8df3-45aa3f9f7bee@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD3D31C0004
X-Stat-Signature: f7pyn7btkz4uj7ds43iycijs4iebin5i
X-Rspam-User: 
X-HE-Tag: 1778273844-878158
X-HE-Meta: U2FsdGVkX1+trjBn4bJt5fzU7Iupub3yeAeos6uTDysFu/z7XBsOfmsp3lnJX486+Vla03KdMFnij3yHnNLnDO5HK2Yw+wiYE/RmcYllypbdHc1MCwOWHdq2kzrZkrt+e9QvWzBNXjcRFK/hBZPF+znnNnqXpDAn7+Pif5Wt4a+joR0mgxG4cqY0IbnjMmxl4QRGuG+iqeaMhacDDKawrBLWeIktL+Ex7Fqfdw2s+yAfVgERJIT4wCa80oGn/m4oCL0b6HLsdORdH4i4Uj1OwKl4EJj/u/wwtOmvxWa7+gC5TPMr5g1VGHhRZ7Ecdj1SXiJqSS2NjhG4JiEO+hkjHZP2p6oTupL3A57/Z9wjLgNtEnepTFGXWSPRQEekofokuARXIKiV5ZlBs+r/D7y3EAZ5dGSYzfwA1i+rxKP3n8CbPB6pZrscXLcO0l8whsxBkCWUvd5eKK5b38J2yfYIlXMR+0zHomJGxvKTX5C1SKzoOtWuV7fzzvYeH2aGq33YHVDpC7bmwWCxjgP9CGPKBKZJiiJRgQioJybRtdGx7RbnVJsjvtPDXSVREQvodcrnbu3YbPy9a6dZKbz4rsQVm+PvFVChFGf14vdA29fQbZILcTB8E32mPNBzTK+DpSMOzLEC139e1V+JBXhuXMqwvk7tqcfu1HZ703CaAJ3iyoLYBfSxG9qPmk+kb92dhh7hYXG7UnPURqA29+T62HE1P6+tJLu9N0xCCGtPwNCzdgC6IgdEWQwe1oRoyB4P0Ci2jVj4rbDB9W9PHRnOAjdLgKj1UHZ4h2gQHRQUna+GszHtz9xdAirKZKTYjqNgImeGFeCcZEWRahnOIEXWF8by6CgtLOrKaWqd+5rrU9/TIrI9gTYUrZUmUJZX9nVGwTPv4Mh3BLU2uT13f8hUYPPbP5IanblSgla3oAnp/K5nkx+0jqQlUsxZVuR5/7JwwECKvDtM+KFOCLDirCf8bQZ
 VbQT4ynp
 65iIMWZRdUJvty9+pA3o4OwSzYR4tLsBJM8CNFNBVGIavNts2WftUae8wqpp3dNBZGvCvtARlaXgOAjE1a72CwqafrQ2vdc9fdW3xx1GDeSlgJmL/A4n9NxKE7NV7Fm3fDxve7R0ys9ccYVl2Erw9kkuv3PzlLSupHRXwOhK/kwiu4XcljV1O09SmdFAM+w/egzgfUHBkYJectRu8AzuARp4aVy1ttpvAhPSj+CuBSb4py0deisgB8P6u9Z/OHrAGsE0G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 14:58, Robin Murphy wrote:
> On 2026-05-08 12:46 pm, David Hildenbrand (Arm) wrote:
>> On 5/6/26 17:46, Feng Tang wrote:
>>>
>>> Yes, it is confusing.
>>>
>>>
>>> Maybe a CMA_NUMA_SIZE_MBYTES?
>>
>> Maybe, I'm hoping some CMA DMA people have the capacity to provide input.
> 
> But really that _is_ pretty much the idea here
Cool, I guess that's the right direction then, thanks.

-- 
Cheers,

David

