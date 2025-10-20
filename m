Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33BF6CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 06:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1F68E0008; Mon, 20 Oct 2025 02:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9488E0003; Mon, 20 Oct 2025 02:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF9D8E0008; Mon, 20 Oct 2025 02:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA028E0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:58:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEF50C05BA
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:58:58 +0000 (UTC)
X-FDA: 84017590356.12.4ADAC57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F59C140004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:58:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZ7fFHzZ;
	spf=pass (imf23.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760943537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QBc+HhQPdMiFKqVo4pCNaIGci0JZ4ts/c739pXemsQ=;
	b=qYC2xsgFu5J7un74LpuMA7JZzyU2pRGTWVkIGlBXzTkiTZ2OpbEP0Y9MgBhCHSrrMQ1+L9
	qYvAYWSsiOInqUtm0r+PC+ydOOUUZLYsjUClUiXNPE2lihtMEZhs632O3DzvOfKSbKHG0c
	Oc58bMH8B0qzyyawWhw4OOrvwTnWiw0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZ7fFHzZ;
	spf=pass (imf23.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760943537; a=rsa-sha256;
	cv=none;
	b=mz/+IThkAi6hWNli1nCzUbWg5b0fH55cORcVRdkkGvZ2+V0RZgc75u523fSjIYHXOxOetb
	fp7rNm73y4jkziNWVmUWbOo4NQA4GXMYnMnvNfXCNUFHhVXehp/zIC7vgyUTHT2f/upvb+
	Ev5qymMUCZPRRJ2oOaoyTZykHyWQlGw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 679C461439;
	Mon, 20 Oct 2025 06:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B518C4CEFB;
	Mon, 20 Oct 2025 06:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760943536;
	bh=1DpMfoI7ltctuVO7Qw5nyBzKMPuyNQVCtIj9HXzFXw0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pZ7fFHzZMZVCRFDoGCD/kcE3PMExmUz8DtqIWwlhnMQhhmpUh1eKmkB/GyHDUrZqd
	 tW0gik/hlsD36rUmv3oblLDw0ajuVxFkvtfGI8AcsJ/QzRa7uLRaqy1zrn8ml+E2dz
	 D6fG4XRj/PQ2Mnc+INeXrWHRsh9a9cByby69A+ruGhZvpmhz4ZiuBHVB5rA8JFWZKz
	 5vtI8HfwKchza2qul30y5NNI4BPpfFgyxQsIkzvtdDXj7lITwEYv0Od4Xeu3TJpEKD
	 evnpdFXr6UhwrZbxlNsVEQjPlR2ywh8EZz4vh85FS42oc7kdp0CMwV/b7pneE6zJlD
	 yTz9/Nh3xCsvA==
Message-ID: <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
Date: Mon, 20 Oct 2025 08:58:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <aPQxN7-FeFB6vTuv@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qef5dcyh49qbdqyq1do3he7kzxe14f9q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F59C140004
X-HE-Tag: 1760943537-684823
X-HE-Meta: U2FsdGVkX1+ht+1ZpYfO7s1jjES4kDL+/vZ1MHTIMhrpYoYpAVReBfgI0pFKlQ2LNRJktidSlHpWpWYy88s2vmo+LiRpuiikeGpX9+flvWhkkys/o5vQzX4hBPJrgHBbe6ddiuMrQ/lAr5kYpqpa44IuU9xNcxTjyKMCK0Mzr57ht+m1aKFmo74Ik+WJxb0jmAsVYz/X+zuJCFl+jekZnDV7TQTfwixc3T/yZldUBr25EXv+SkkStC9ghEICPxWhftvFUEXx/7uzcTAWeif2ZVQi9jsrglS4fd0ey7x3VP1/wZ42gZcSPKGeLr0uXG3CJQaunfE4+sq+z4LylH76uuGl7zwD7dFF4XDxsBBUtmL5//EG/IwXuhN8L/K4ZtfMciJiRaR0rVPRUBW0/ay0w2dZ9hoYglxy9V9qEJ8OTX9frRfmb5ZIbDi860wGSagRQmSp69vjxn11d1LwsH+pgfJUd6WGsqGue5VycQQe86WTRfGoi1dq022DFqSl4mVONZU8RRSGWpv906Qx4KfEbrrGaeMJPvPPJSiwYXK8wP0gIZ9QijEBUQNyKY1xntNm/KNVTwOkZZ3fEMm8d8hjByaERZhNYvfwnbcSTc1n+VkTQKjPnaVctRMsWep5UPpQ/C+L1o9S0OPSjOxgp+mibk0oPSOyZu6fsFY+Ec/jLHcAsvpqYTwrbN+JGkfdZuhJlCSrvSwYRTusEnq98XMucg2y09+Rq+sdaS32KBj8bwCGrqjK1mpUTbH1vk/YUq4tk0POObdMl0plFGwjXxMkgTrn+8BZITdY6RcfTyuVzAf7fVfk47g6Eu9dFtwwA7YRlaVmVdybRGKRqFFo7amhkdkXjgZRTROm1jTiSwVJyqsdTUOQV913P4MS5vapmS83XbtB0jZAwpIrZ/jBwwnbEPCj4Czb/K8kSV/F2F8364627eNNLYdRsUDCgGD+hkEcUeMamIihyEw3XKufRWb
 hTSD4aw8
 WZIp+RdG76wIL17+mwudJH3gXxYkBv070IXcJsACljKKVy7wtygz6B5hOKpQuzHM3evCtMb1dHJdyE2xVL1PiSSYPeyQjva1BOuQlnqfKAWWZdBbOxkuR/vqY1e5a2t+hJyrjBH/E+Av3/CFtJts6abJFBqnG+4VXF+IpJk2ZgQTRuprAe5DH5hC7PFyLvL4omjrRbRDi59SZ2zpVqgasKFXzZAnZN8z+fhHVY/7MBfQHa+6zpMDjhOH63owcqwI4Um2IOzJxqFMsojVsL6vnNmN5vEy/xGqxPJ/urPGYmQwmlzviobKoA0XyzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19. 10. 25, 2:30, Matthew Wilcox wrote:
> On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
>> Vast majority of allocations that use get_free_pages() and its derivatives
>> cast the returned unsigned long to a pointer and then cast it back to
>> unsigned long when freeing the memory.
>>
>> These castings are useless and only obfuscate the code.
>>
>> Make get_free_pages() and friends return 'void *' and free_pages() accept
>> 'void *' as its address parameter.
> 
> No.  Linus has rejected this change before.  I can't find it now, it was
> a long time ago.  Most of them shouldn't be using get_free_pages() at
> all, they should be using kmalloc().

I'd be interested in the refusal thread (what was the rejection exactly 
about). In a need of whole pages, why would I want to alloc more for 
metadata (using k*alloc)? Or what am I missing?

thanks,
-- 
js
suse labs

