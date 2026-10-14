Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF24CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90726B0092; Wed, 14 Oct 2026 06:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66E96B0095; Wed, 14 Oct 2026 06:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55E16B0096; Wed, 14 Oct 2026 06:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 911386B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:48:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CD571A0316
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:48:00 +0000 (UTC)
X-FDA: 85320906720.14.61BC13A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4FE5D180003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:47:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3c1dj6j;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791974878;
	b=P/vJetwl/dMJYZ4uQYYaEQ0AG736eQjo1reKIdzuhhhFynOAy7EfmHACSJsrla4zJDH3Xa
	QNMFJPQZi/IOi65EmICegZf0rr9dL3thtbuYEf+BqmMq5hhIHCkZdkcXfu/lTSJlxCcN7l
	F35T1pvy4OKiNuwgSjz8Iu0zEkDlhjc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V3c1dj6j;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791974878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IApCsci3eSqyBIQ6NmzUaRZb+6TUkOs0tii8wwaDBSI=;
	b=lXj7qeYd8uDOifKJOnV9jJdep5w7sUOtBH1B+mlfNSRlouKfsu2DcKZSrTdjgEuljYpV8W
	Wnc40zhwg6vz2LJh3vwZoc4kEmGe0EgAyF8Rm22i2XHmtI51ggHQZvur/KE4nRxGhhsxC7
	nOqMu9Q/ej8/HCbPQprsnwxmOrO0EBE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E317407D5;
	Wed, 14 Oct 2026 10:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E891F000FF;
	Wed, 14 Oct 2026 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791974877;
	bh=IApCsci3eSqyBIQ6NmzUaRZb+6TUkOs0tii8wwaDBSI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V3c1dj6j+QKYfnIwQZERyfqrqe+FaHIfB5HHYjPoP0iAFKmlB58XPIiLTt7NQv26o
	 yonRlVYITgy21176x66blhL5AkAMa4TvRkno2/XqbkwC4dW+W2w9Th1e2iAaTYz62R
	 oPN0TwNKKF3PtMljvjL+I3HZ3z104drFV04P0LLPTptEmJ4UozFh2kNDweXk3D+IMz
	 8ZsKrBAhfHbDg4V7X7Dw484s50jmdVeTVmRXrtoxpHIqHtHFglgHNeTAxDUYatjQBh
	 74V+mBmqbH4/BnuZ5RuS/qTv1y1HKtQchEiMx8HGnSeSfsfyWbzJurQWFQcsRbCn5I
	 3zsBoR4hgDM4w==
Message-ID: <75c229ef-ae41-4072-9c90-98d4779c52bf@kernel.org>
Date: Wed, 14 Oct 2026 12:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Robin Murphy <robin.murphy@arm.com>, Luigi Rizzo <lrizzo@google.com>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261003212241.3432303-1-lrizzo@google.com>
 <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <4fda41ed-741b-4c5f-ae83-e3ea5a447441@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4fda41ed-741b-4c5f-ae83-e3ea5a447441@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4FE5D180003
X-Stat-Signature: mwtuknppu8hpnqq5if4shu93sy8xtf97
X-HE-Tag: 1791974878-23538
X-HE-Meta: U2FsdGVkX1/26fb3H5/7tEvQPYRpWDHNxURWauhaX3Gf7pK8pFSBzExobiOwTprn1bXQTvhyv85Cfp/g+HrF7SZN6kMnRjdw6eEvXav175LWLPGCB4UqGLe/DifKjVArXVkYTCrgCV1czYcxxnQ/iexQMi4CptbTtuphvkKKhPP1l95Eby1r8EKjCmECAknhE3dt39bpOkQvpLuy/hzXv3EoYio2vzSxKgQi5PrxfcTmmnEcK0aYcclT4VrhX49g6Qy2uNkkyI0+SVM3BJ+fwke8hTmfht4O3oszCS6ERVQxqsfeLQ/pi/r7YFP3bY4aIu+wOEmtb+n2h9Dp6B3gFeI8/uHx55XMXIMhNlPXbJjqbEP4Tf8SONT9/wwt8ZbWfBUqO5i5h7cBX/DCb324I0TVOHz4AiONI+s9ZGMMh3XKIwNPO5X31erZ5YIMT6wkZqYX0RFvRZ2O2ZBuBgIqt3qV5vPQyD4VNnyZm0vV6f8Bjd70o8IAbSjGqpinF1roGQFfx12b4MJmgM2ftqtO0MDkotC9RQnodoBF7xuCbkQPT/7BWFmdGokwuvT9Pt9SOwvoMuB/XffYSwlRu4kBqm+1tBoNmT2LkN0VvdWDCrpoRrMfQB6iZGxfoBqL3Qv3gJdGwz3Ae4lzwUfYNokzCJcPAlk4w4MDV0vSCSH0MO1ac66Ch3K4/rSSOT5ttrEtkplCk/bWaCqK5qW4+XWs2rkzMcjpP5iXhW2OynzF8cgvNIUpAASh3lb6gXm1KLqYCshFEEWDoQ1Vb66v5rqdjifQfnEn2rCbjjH8bTQvQ6Vg1g5hKOT/5MKMVkKGcJaxKSJSG4fjklATTkmwplybjj4xtF8k/XRtGteM5otEWAO0lGgjKPECmRG+vbErgjkUTROkhUQsLf4XEUE6TnZaC4ECIyP1nOCj9bUSgE65ceLqQRYbOhSZQ+4Z2oFAi22Jr5ZLy8ntwJlW0peDy7w
 IE9ijov1
 ss/eYDp9OnTZJP9sthUUqXD902KUGX+nWbusSzuhi9IjocG+SAypf/fJSopp1yIMkk2H0jiELcfqKP9YYe+n2Qq0+XmcmiUg3tid8E58iukGHn0tcFK0xBtPjJQJetjFNfy296l7ZnQAdto+DxFDedkHaAUyoUIHRsboj6JmKXuSBU8IzGERRCx16mQ0tSZJuZ6q7HT23wbi9fSN5rb1Q3ygYsxdUkf5jNZnK3kWNbBr2Bp87zZmNCpPHb5Q2DtnqE3JBYhsM6nv96fEdf5PXXtYSk2XUaU7RuCsFpoM5+rl/RBLlf5NAVzc3Yv7KxYkCDmn90pZEJzTHHkhPOtLdXlA+DzHIMrRegGRLE8VLq6+sjTiTrpRU/ZZ6XNSu/6x4HAVIMRP5lqymrd+sQQLCo7kvJ0nxlXky/GBDQPB7dzNOa38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 12:42, Robin Murphy wrote:
> On 12/10/2026 8:43 pm, David Hildenbrand (Arm) wrote:
>> On 10/12/26 16:45, Luigi Rizzo wrote:
>>> On Mon, Oct 12, 2026 at 3:51 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> I had to call it something... an earlier prototype used the name IOMMU_2M,
>>> but I didn't want to suggest that the design was limited to 2M (it is not).
>>>
>>> Aside from the name, the _current_ prototype restricts to 2M allocations,
>>> exactly because too large units are expensive and wasteful.
>>>
>>> In the code, decoupling the allocation size from the PMD size is trivial.
>>
>> Yeah, we should do that.
>>
>> We should probably just find a way to describe that this is a POOL that focuses
>> on physical contiguity in some configured granularity.
> And since it's intended for DMA we could call it dma_pool and oh look it already
> exists...

Heh, I did have "DMA_POOL" in mind when writing my reply.

> 
> Sure the current implementation is capped at PAGE_SIZE for allocation (and thus
> mapping too), but I don't see why that couldn't just be made more flexible.

That intuitively sounds like the right direction.

-- 
Cheers,

David

