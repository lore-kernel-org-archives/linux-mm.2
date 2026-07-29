Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2EEBC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25E46B00B8; Wed, 29 Jul 2026 11:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE706B012E; Wed, 29 Jul 2026 11:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8966C6B0139; Wed, 29 Jul 2026 11:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 579D76B00B8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:50:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC6C9806F5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:50:03 +0000 (UTC)
X-FDA: 85042250286.18.89C235F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1B072100007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:50:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvXgUWyC;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785340202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqKH4VCTe9vViQKnNAGVZMzkIEeNzEW45NjzvfGwTZs=;
	b=C52zZc71e7RZDxZjigHEw2p8CJoEUREF5pF8wb2YHe79YA9WP1ixJm9QacKdPkiI5JtZqC
	/I1MPS4KYcQm9c7y3mIBcY0g29+O3C2TR9Z5pi0WEHUKcxOUY8+l7WgEFYC0aVa5F95eVr
	jco9SvHowhf+AJ6f1QUmb5mqOi+74yE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvXgUWyC;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785340202;
	b=LpxaqUBrVmZgtb7pxH015wJPRG8MFaEY8LMnni5VvbPOfld0BIAPlJUdiFtxW7yQdlvAVY
	kXZmiICwh8FUQCqx+M4IkibLFWWfAdYhqInv2+Wkq9HXHYSx8hbqUNWvKSm+pXzflNh/yz
	T4HPU4Kc6ggXaM1/GJJrqcIBiT7BU/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A1A2600AB;
	Wed, 29 Jul 2026 15:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543911F00A3E;
	Wed, 29 Jul 2026 15:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785340201;
	bh=uqKH4VCTe9vViQKnNAGVZMzkIEeNzEW45NjzvfGwTZs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jvXgUWyCn8XO+hR+RwLHFAVOIo01qZlqspdWH/BNHlSiFPe7kSMNF/A1WYJmGNB3L
	 RQLKNV8Qo8/JmQRx30K3TLy2qPL5PbMKemIEIGYGMqw/qKZ63svwxGqC3mbCW5jeEM
	 rSv7seblRC66ZHEnDAPVVIRhwDwOSEcNisu8/pl9BJIYLi2UVJWoU2lRlHFlOi62G0
	 JkCdUm/Q8pfT/XDZtkpyqJY2U2AtCU55GtuepP4B6IKruYGPSyDitFBOSABshdKbD4
	 2x4RqDWO9ezy8shRf2nFROlynmUDeY9yZtbbcBhIf8A+tRCymg06vD7S7oHKjtZbj3
	 we2dKTxCl8PQA==
Message-ID: <63960288-5240-4b94-b22d-f389911366c8@kernel.org>
Date: Wed, 29 Jul 2026 17:49:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Content-Language: en-US
To: Brendan Jackman <brendan.jackman@linux.dev>,
 Matthew Wilcox <willy@infradead.org>
Cc: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>,
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev,
 loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org> <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
 <al5gQgnBCjNCSD_4@casper.infradead.org>
 <51810eba-2a60-49f9-b879-7f806546e600@kernel.org>
 <DK5767A146ZW.3LV5JXS7T4W1C@linux.dev> <DKB16T0X5I9D.2GCNPBS9VC95V@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DKB16T0X5I9D.2GCNPBS9VC95V@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B072100007
X-Rspam-User: 
X-Stat-Signature: un8miifur8b63g8cwykgs5f7neg5mxap
X-Rspamd-Server: rspam04
X-HE-Tag: 1785340201-859992
X-HE-Meta: U2FsdGVkX19Qc/gi2YecqpUtfYguJdvGRjcu/fs7TMqHQIrkvRGeO2vGGsOvvBBCHi0isuNd367FmzXFnsq0IJizmfJvYV+Sx2rWODqhKt4IcrbmRuqHwcjozsj/TynfCRHO84Jgk5sLduW3LPHEHBLX+XkQ6bwQ5oFFDXSem4+gxKZfx4nYt2Vo1bk5yPccYB0w2HQZynQ/KTkqN8k8X+fua2P8RdvcuwEeA2j940nQEGK8BcyzfIl5Ii78bpg6Z2WJbZhppazrsb3XKC4U/xPohxVv5u4zlQGE4NKD9MxK31CjZGaGDsQRR6w1Dvc8fDwYS8sQUBwTWxQu+oMvuEOaJo9OU6sjGbWJhSxHKGzUomhejeiSCbYpTjkvnywlBpNdOX6W6OHvkTiGruEKXjPghiSccaqWkEiKKgIC0DGedb+kdyS2n5x8nAiMzh5R3hAmtgiMpIlGW5Cbd6dO24lPLoTOVbK4bYiutcAX8il3DopVU/0pOKD+BI1/dq5kIFDw4PX5NOxBU7zOzeXqMlgYBTLKlAt6OxltCkN9WFx/OnGZodfAzsEEH5VjaD12a1v94yWMWcetDSE+b8WJu9FGCoN+GzjYUX19sHn3+WwlReBh104x1Qh4/egBElNei+vcLlOpRxdJDaQHqepCtT0Wp6E410ixvYu7ExGoW7jnn69AhyZlqOIhTg4yGQlmrYSNk33JpNldGvwUSBEpuZ2Ymwf5gBgxCn6JGPAyy/+LCw1zvz+b5kGzuWpOJm66AwRpGZE43/xxr7JMkMHwillghJtTFD9S9vqfKM0RVf9qBPQ+mIqtqZml4QF83ZtE5fx/jOhKjW0ZFLOmiJNJkiRdLvmU/uKBap+ha3l2NeqnyDMkNCkSv6ovv2VFxvhU1Z5lCrE8MU7kv/hJbENhE1R6cAbDKrHw7ZWaLyCKWZmdifgy7xAT0JxGKJtF5MToOylMO5Dg+cjrrkEAucS
 pQqxzb7d
 DNk/XSzI+plOuU01GfJe/JPlYg2597DbL/sKX5r0pE7Cq0+DXa+1elM8YD4lTAgeEeKCYthi0aI60NXOPoZ6lYo30Li/HfOqum351CMtH/Tw4mSdQ8pLhGUeW50Y+ziGYcpn55QOFuAxfcea0OAPJ5iqUCRCojOQs7mwEFkclN3uhjaumJorgMauA4mEzUIEYgZn3MChfxlFmVQmaafSPn8E2HFm1eemjJ16WVx6L9ynmHHBVFfPfCJk6C5f8/ekFOkIQmQWqiLC79XI2PTGfAFQ6G9jMg3bm+ouXLK4kDsp0Z5nQb38wE/+SHRdGji616rUA1VUsF57t9zaJHj+RKVnDviKwIoVuS95AqJsH6OiEGulYddQpKfOFXACnPXFfvy0c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 13:50, Brendan Jackman wrote:
> On Wed Jul 22, 2026 at 3:15 PM UTC, Brendan Jackman wrote:
> ...
>>>> We have a long history of people just moving stuff around in patches
>>>> without knowing what the intent was if it should be moved.
>>>
>>> I guess this patch is not critical to the rest, if that's an issue.
>>
>> Well, for ALLOC_UNMAPPED we really do need an alloc_flags arg for this
>> function, but we can always just go straight to what I described above.
>> I.e. I can create the __ variant + wrapper from the start. It's just a
>> question of whether we prefer:
>>
>> - "Yuck, there's a public wrapper here that we don't actually need", or
>>
>> - "We hid this mempolicy API and people might think we'd NACK a patch to
>>   un-hide it".0
>>
>>   https://lore.kernel.org/all/20260703-alloc-trylock-v5-2-c87b714e19d3@google.com/
> 
> Uh yeah so in v3 I did not depend on this patch, I just went straight to
> creating __folio_alloc_mpol_noprof() here:
> 
> https://lore.kernel.org/all/20260726-page_alloc-unmapped-v3-25-6f5729aa9832@google.com/
> 
> So yeah I'd say we can just drop this controversial patch and move
> forwards with the other two?

Ack.

