Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08154CD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8F46B0005; Tue,  9 Jun 2026 03:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A646B0088; Tue,  9 Jun 2026 03:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAD56B008A; Tue,  9 Jun 2026 03:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D678C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:09:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65A3DA0471
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:09:37 +0000 (UTC)
X-FDA: 84859498794.16.F35FC59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95F284000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:09:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NY1mGYm4;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780988975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=139iQQq4xBncPJiuXIb4sR0v5L2oZgj0QjKCDvmp8NE=;
	b=0Cbg4LhlWawHPzw7VZ8FS16XPvUy8nSQb15ZdC4NX5/Kot9dch30EK2aLb8quDsT0xeapH
	hqWuNCONFkAW+cDVH16kSAbbIAPMs5hBLe1VaIWt1CxmuDg2FVQ8cOCHtGFCjWh2GPYe16
	3iS1cFXOdweqdvXM0h/XRWm9C2g3afg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NY1mGYm4;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780988975;
	b=pMHZgVah79ll7y5+nlMODM1XkpmcDHe7ee+TvkmVOukG72NhZikNv5qxWeFVlWsF5zwc7t
	iEkQBQfH9hWgHZzQqh8HLwuiDoGn9nqY7gGt3faKb12DDLx0oc1g6cm+KxI+tMpywhc58d
	1FSpmeTPJHWBy7/p7iKS+vghbh+ZhjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C936343FD4;
	Tue,  9 Jun 2026 07:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1661F00893;
	Tue,  9 Jun 2026 07:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780988974;
	bh=139iQQq4xBncPJiuXIb4sR0v5L2oZgj0QjKCDvmp8NE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NY1mGYm4C+vT98RYZN6oqOfXouBddRRCeQIlOLsXTuf42zmsBzIb3wlrK311N6tyc
	 eKLm4M1smhZ7tnWnZtiOWuOiTCN5Vy66LVwjXRsJhqycdSndJLiH3nXX9enxFgUxyF
	 1n1SMz4An3LfJ1YEv7E0w/Hhw82ofcIKwFa69CoLA/nj/cPw2Zp9PqGnb6B6oL4On0
	 tyQ8TcflwrX4Xa2W+sj84SA89JQLACXHdV+SQRzCCiWHaEVesd7K6Wpe+ROh0qrU6m
	 Hm5a/1pQulWI3CPK+UDJgAUHiOPYdfdfNQXYcLn5vIin4Ci9WzO6xVsNCzhaCng2NM
	 WNcxmhrv36J6A==
Message-ID: <f2a4d5c8-3d7d-4fc3-8769-66e0c24866fb@kernel.org>
Date: Tue, 9 Jun 2026 09:09:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
To: Miaohe Lin <linmiaohe@huawei.com>, Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
 Lance Yang <lance.yang@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
 <aiKXrovzrNN-gExm@gmail.com>
 <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
 <aibN4osY_QF1Rejh@gmail.com>
 <4953bcee-5a0f-2bc5-7295-63e5e7513e8b@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4953bcee-5a0f-2bc5-7295-63e5e7513e8b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 95F284000E
X-Stat-Signature: 16ix63g9c3pnta8usz1j538id3ae4qdt
X-Rspam-User: 
X-HE-Tag: 1780988975-198890
X-HE-Meta: U2FsdGVkX1+UxtRrVHDhJ0nQfAFd8VkRs/WYmNA0ZRKTe1+zWhsyDdruYLCQK2abulQzjWr/+Gf3QiAc6MjiG7IDz3FNN6shhQGFBbXW02F7L17m2wzeG3I6to5RNnK0vKQ+kmPw0d4cdZ1QPI3F/tkTC5HZRkdjQHYl9zbJKc75446Yu5XkbMwZaoCh4MXdSnObPCUf5sLQ3R5UG51wDHa0FRN2mIZn+KMkWdMDDrUqAPQ52hn9NP7Uda6ScR2mlwyPJYHgbpHI4GFMiDAh76QG2GhccyhW/Z5i3l2HJB+W2A1y7h6Suz2+Mv2oQqVJYm48dlateMtipa/wU/qT7nJVj9QF+cKXMxV7LHLRpIO9jjmtTnuPqv/vMIFWWVqVWsmm4D6DwMxmmXHQIS3+sCbmrvFAq5hDbxJA+93857ZnWEpvB+AWWesWiQOA9+FxrH3QnJjhjWs51dQH107N+evfGadu1QkoDvWjD5+D9v7yGS1FibZfb1wMj6xdhfPHX3yfjq4zOd103ZOLxY7ZfZPiWjTISfCq5m64lddQ6VavwVI+mtvefEF5WOFh5mOb1G7t7IErMnDRYsaW1Q7QwQcDe1tTiCidm5PV6lHUjyI4yAINmSD9q5KwcaqCpZBawQxJ3t3HpFI9eyukxYGVZev/2tdOns0Hmf98seLrJmEzkuHzFPW9gZU56Gt6XomNS+5arvlB/Jzr0xtEDEZSuGTQBqkUFWw6k1pHWRfV//DKLpkvZE1ALnPlDvpU6EPDzVQxUsntFVDWaKQ86sSWmBg7emN5q+5i20pdnzb0JsZTfx9nXbo8p/z7nRXHdexRfq+HtoWs72a+KUWD/jqrWiA+Ejld4W8WlkFaiiugAHw54rUDNeDfsO29WqUvaiQmdvyMUVloE3memamu553hxONMqQjTrrZNgmclJH5nyZ6qgC6+P6Yvjo6bNBbh7hJqtm/q31h9Sq3qoR5jkOH
 LpyB6Zf/
 +7R8Gf2WqoHf0QbA14vvzdQoSiflOzihs0wwK10X/KTXmmWbJfgaDgpDoSjLYfKlGiwYenyjlO1hlGseLJM5eGogGWzmtjuKF+n/3zsUdBAMiYr7aOyE8FBrQdFc+97fI0mcx1fcvFC8D2mvL8yr8QqkRFo85Z9MeydCerNWAO1D3E8rg4ACt1uq5FPFb/dsso9NL102LCTFhbpJqEFf9r0PxrdlzEO8IjCW6egEowRffhssxVvuKHD4tQEHzWvZwjmuz6JZprIr16c7xFQA0aXr0eZYscWIMfO7Y6i7MaidsUq9WStTvVB/BeQN0MFB/EwgkJEjbccsA/mQzRjwk+P695Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 04:39, Miaohe Lin wrote:
> On 2026/6/8 22:15, Breno Leitao wrote:
>> On Fri, Jun 05, 2026 at 11:42:53AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I mean, any such races can currently already happen one way or the other?
>>>
>>> Really, the only way to not get races is to tryget the (compound)page,
>>> revalidate that the page is still part of the compound page.
>>>
>>> I'm not sure if that's really a good idea.
>>>
>>> But my memory is a bit vague in which scenarios we already hold a page reference
>>> here to prevent any concurrent freeing?
>>
>> No, we don't hold one here in the case that matters.
>>
>> HWPoisonKernelOwned() runs at the very top of get_any_page(), before
>> try_again: and before __get_hwpoison_page(). The first refcount taken in
>> the whole path is the folio_try_get() inside __get_hwpoison_page(), which
>> runs *after* the short-circuit.
>>
>> So get_any_page() itself never holds a reference at the check -- the only way
>> one exists is if the caller passed MF_COUNT_INCREASED (count_increased ==
>> true).
>>
>> So on the MCE/GHES path -- the one this panic option exists for -- no
>> reference is held when HWPoisonKernelOwned() does its compound_head() +
>> PageSlab()/PageTable()/PageLargeKmalloc() checks.
>>
>> Given that, I'd rather keep it racy and take no refcount than add a
>> tryget + revalidate purely for this check. As I've said earleir, an operator
> 
> Would it be acceptable to add a simple recheck? Something like below:
> 
> retry:
> head = compound_head(page);
> PageSlab()/PageTable()/PageLargeKmalloc() checks
> if (head != compound_head(page))
> 	goto retry

Sure. I guess it could still be racy in some weird scenarios where we
free+allocate+free in-between.

-- 
Cheers,

David

