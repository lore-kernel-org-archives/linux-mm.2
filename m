Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E4BCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5788D6B0005; Wed, 13 May 2026 08:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FE46B0092; Wed, 13 May 2026 08:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465A76B0093; Wed, 13 May 2026 08:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 343876B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:11:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD14E140A90
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:11:57 +0000 (UTC)
X-FDA: 84762283074.28.1941ABC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BAC59120002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:11:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izVWhTpY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778674315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNRub28UwkWPWeijQ6qpjT0qKxxQEO5/xgBnourTh+w=;
	b=PxCi6GJZ4B/PJ8uGF82zK+i+y2SNvfMVv3B3LuP1KLCih0dPsGO0us41Ol/wtjGFFTwFig
	GMgZbVtt0ezg8Cel9/ZIam/VPJ60h5HhxtpOhUJxqywdvswdIDTyWqfv7UkW2luuxv1tso
	cN4eDH5mA3RRI5OXwztK0jYLzQ7MQ4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778674315; a=rsa-sha256;
	cv=none;
	b=3aV5B1a5Mh5rLWtxm+saDsLzm7SErJN02CK8o3qUSIkk2gTPNfo/0eu1SbMx/gxA0Gnnxt
	Xm+BQau/I1ykvc8LK5JlrQz6QxQ3ZrBNtvF0K91LII3R3rok4b1F5/aNe1U4t5iOmB0eEU
	mptmq5md8QgOSbyvwPiz5c5HO/8wYWM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izVWhTpY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA19B408E6;
	Wed, 13 May 2026 12:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ABFC2BCB7;
	Wed, 13 May 2026 12:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778674314;
	bh=od6uJlEUQP53Npilyw45Kr3y1pnzvEmpItakHhsQSIQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=izVWhTpYPaOzCTITlr/RwH4ln3A/k6VQ8lcK9+9ChdErK39p/svQXKaW8NpVC2tm3
	 3WARQE87vzjQD0XKFt3D3mOBgBbVVxb65z1w8U9DI49/cd30ILfp9t4Wf973Hma9Ax
	 HfwhUPdZc7UnXG8rPZMxwmfVF+PeduJUkq4uHT4KZu2bB7MSigRvmonJlzcPpjD4mq
	 JKu50ze+mZTY0GDjMIu7CigSffnIzj+k8PJhy/+FUGf3kSLCD7dw/mDZVYGTInbXhK
	 ORXjDbNlHFU9CG6HMC/hjju9EmP1E1xAG4AlgHU/sNR2EbywMmR9NmCbdSQjNF4Ds9
	 C1prioD/2pBeg==
Message-ID: <593851a5-2659-4996-b0f1-7cb8581a9fae@kernel.org>
Date: Wed, 13 May 2026 14:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
To: Dragos Tatulea <dtatulea@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
References: <20260224051347.19621-1-byungchul@sk.com>
 <982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com>
 <4af19eda-c29c-4302-92d5-c0915267fc0c@kernel.org>
 <agRB2QTbzceRgpzX@pedro-suse>
 <1817a749-8232-43ab-a0f5-350e5aade235@kernel.org>
 <f3e38c07-d410-4c8e-a572-68d52dc55353@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f3e38c07-d410-4c8e-a572-68d52dc55353@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BAC59120002
X-Rspamd-Server: rspam04
X-Stat-Signature: bxct9zexw757k9m8btizinxwq3t3qbip
X-HE-Tag: 1778674315-605910
X-HE-Meta: U2FsdGVkX1+PWliw85tbYbKXbvSb6b+pRQIl0lTtP0btr3QmPoQSHh4EZKTsoiayNCSwl25GInD5wbRZx5TvQpxEOSVlhk7KnH3gRYTZJ2sUH+mFhq90zI5Xvdi+hWDl1bnsfh9FzKdJm3AQoAOCPJhnw+VocwY/yc4xJ+IJUyHsnOpC0Vc312ZxHLpScGqv91CWXXdSNs4VLkoh9JnS9dkTmWkA1iJP7s2aYhKdwcuRg9JCTnhBxWWTd7L7VfUJI8Tt8zT3dMOZmF57rlDOLgsqg4zKJBObC89gq56vTanb7rU5mZO4R1Ln4wXt7/0rVkCUSt2aG2wxlPhZAqHjssQIseXggi1C1jcxicCQSrWOx1MYovnAPbjfEpXKVCx5jYb6NJZ0OeL1V9lMtI4wzvaN1qLpADueK1j72ltVEoAUsZSxX3NMavu5sYLHaVWjFODMtgrOK/o+EmHNh0yKykiYgqBV6T15XU35h+SNAmjEZrm017JmJY8cn+p+oNKYBLhUSFlxY9UT1Xn0o/3tzrQNR5KrZ39qQ6If85qo3cAYVjox3DrfI0L4NyLKUo7uVq3EJgk+3CA7cWyXo6VTSXD3y9DDLbXNB/aDa3BtPu6cw+8CX1XYRGZxqb+cBGY3qHGv8js5LnJxBtAb/X5ozlQKiQyNqVB036TQppJZp7PeJ1q0DozDwGRVdS6gcbL35WSVsxwn556wRdDY0jgKjQ7SWivwRpt/O21/K0mmsvre2LjlHuc/bORZzb5p9BXaPQzZTlikO9g0VCQIgJFHtInBslfstZWtE+A/R1L1/T/dDEVMQTlCjVGsL3yMof+vCg3u8ZY/6qnMmH08/F6X85ZqVHRIBHl9HRTczb6Ato2DCV17E5PpNJWmEOTbwJJJ3WE9flT58b6l/f1w7KpBDPnqSNJ5i+fVREpHknRm4pU0wH0fV6qRQ027mRsF88OzVsM9jONgryERZEFdCa0
 XHIdmzBp
 HZZEHK/oAfSZbqqTFzX4K8NcW9raAOD+jLco2Y4rKv4cHOikQ49NIsVU4D9cxPkWjzC+UCcShmpckU+igzwx6Wepkd8gmvA7DPnXW/tSbZeJh31hV8jo0XzBi9CSNjdqE1MM8jt+k3jUxbmhkIX/9SqoudjjpIux05RpcSJrLGEGuYuLkocnRdVO+3XtVmfTSliCNPxvNeSe5hfaN8Xc/QdiOJ61G5Uj1DOdbdVNHQPct8K21cen3UPLK67FYpS+I1WTTQNauZpR08B0MPM1plZUBPovgOHOaaNxD+Qk3IRxkJgysW/xMEKlvclSpnBkXffimrhEZQJ1e1Z5/aY00e1gfz2s7mR6Z+BMt6/62DqkmKMucG3/5vSUGgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 14:06, Dragos Tatulea wrote:
> 
> 
> On 13.05.26 11:36, David Hildenbrand (Arm) wrote:
>> On 5/13/26 11:26, Pedro Falcato wrote:
>>>
>>> Yep, you fundamentally can't map a page with a type as page type aliases with
>>> mapcount. Even with the given diff, just mapping it will increment the mapcount
>>> and wreak havoc. I think we need to revert this patch for now.
>>>
>>> I'm not sure what the long term plan for this would be. If page types are moved
>>> to memdesc types, then the two stop colliding and that could work. I don't know
>>> if that's Willy's plan, however.
>>>
>>> (then there's the other question: are page pool pages really folios? not really.
>>> they are mappable, but they aren't part of the page cache, or anon, nor are
>>> they in the LRU or have rmap capabilities. perhaps we need a different memdesc
>>> for those. we're one step away from reinventing class polymorphism from first
>>> principles ;)
>>
>> Zi Yan is working on this: non-folio pages would no longer mess with
>> rmap/mapcounts, and page table walking code will identify them to be non-folio
>> things to skip them.
>>
>> It will take a while, though ...
>>
> So do I get it right that the path forward here is to revert this commit [1]
> and wait until the work from Zi Yan is ready?

If there is a requirement that these things will get mapped to user space, then,
yes, it currently doesn't work.

One could remap_pfn_range() and friends instead, but I assume we don't want to
go down that path ...

-- 
Cheers,

David

