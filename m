Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28834CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6D66B0095; Thu, 11 Jun 2026 09:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE7E6B0099; Thu, 11 Jun 2026 09:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCDB6B009B; Thu, 11 Jun 2026 09:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396706B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:20:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE17F1C35FC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:20:16 +0000 (UTC)
X-FDA: 84867690432.08.437429A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 136854001C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:20:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZmXI4TC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781184015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbAs11x6sdjRPCa1WwOoOtiOTXFWzk8XHr9nWsO7jas=;
	b=nZQJ1hQd8P6JA8Fih8eKPvVwTu2gHaX/cO6Lb+pC4ZDU+EvM08kh8dcg/PPVpXlCcHz0qr
	apXC+gGk5shrsO2Y9MXVmmkz0/punqgUZttC37Jhlkcv6Am9zT+3ppJOpWkmNgJY5Ko6Gt
	XhyoLZTAHfC7tHOZWyZhACcGUQkqxj8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZmXI4TC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781184015;
	b=0JOx4oBS0KvY/sQo4lwX87mln+GxJNwktIRhOWxrGht40Rp/ephn9tOnEYstQFJe158zW3
	jmzIc5BlKlhew5KqPb9H6v05NcX4Mr1BANRQTCSSp71tP75HQrjjZ0mjpWxMFQfDZ2ODSg
	Xl0doyfJoBwlvqDcILbmuxlgnLRWouM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 685FA6001A;
	Thu, 11 Jun 2026 13:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A371F00893;
	Thu, 11 Jun 2026 13:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781184014;
	bh=DbAs11x6sdjRPCa1WwOoOtiOTXFWzk8XHr9nWsO7jas=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mZmXI4TCsyxa4sX5pM4DsRByQaaOs3d7C8Ljua/wvAKN9TPmcu2iaMcw9mgsddKo8
	 dJ4w1P/oR1cXj+hgY/Ibtz3BqRn0ClHXphR+0hydZmdlRauhCf1o1OJ7ODS5JywLgl
	 0vBVbGss6G3iP07870uUkV8E7U/nHrA/mbl+/7DrGlnxkgh/pwwLTjU35X8ci/C7MN
	 KGxWrMnh2F5orJmyEBmsIhFS0coXBk5XYZD5Q01TrNkodmYflZXuratoNjUAKLgqfC
	 aJTurNg7u2noGQsvfpB4MqpiRz0KI3NtZuWgHcDcG7aE2f3zQUB+W68+dmVZQvlYd/
	 B6Kwbc72AqZRw==
Message-ID: <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
Date: Thu, 11 Jun 2026 15:20:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: Miaohe Lin <linmiaohe@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
 <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
 <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: c877559wf9yzfeikcbasuqdqycm7gcxy
X-Rspamd-Queue-Id: 136854001C
X-HE-Tag: 1781184014-436147
X-HE-Meta: U2FsdGVkX1+aO3QhA4YbrCVy2kvzhN8dC3rYqditO65FgWQsxyUAnuUCK1VnTdG8a1Gd2/dF4RtNZt/Jqh1DD2wkc72ES3aKLsGRtc6ggYx61G07OeozahKu48XvWBDgWqaefowonvcdHtAn079QkZ2A4GGB5Qsw+rgvBeQ4P7pcGeliIpiDKE7RHbdR0pfG6C3G1JguCNDNiZQWNapPlHcgw+quxyEU3LV/57btWARfx5vObt6CtzTJjp6vJTRhRjx8tiCj1btn512STXYB9UrbRsEBJKL3AZ8U1lm87OVbnjmyUpZ4Q/87tPDp1OUKnTLgYMYK7yLUWZr+lD3JggOuRw5CBF0N95As1m/JrxvXIZV5GcerGT40sD3tMMRLf90dV7++yKF/2GaB0ra8eVIuwgjxSo4ft735+S/atDrH64Rv3gbuCL/NKezsJFTsBVkF+sKOIBnj2rYiWrz61PNWxTi+NQAuuw3e3G2y4Fk5CN7TE/HeFAWX0BL8nD/tOmxeQx1gtRLydD0slHPYA9lUNypzlCvmrH+0tBLjrUMMqQ9tFcsIevexkMwSRYAnhhr1Gh3gi/mTrSKpWe9QQLz9QzsDWc03JWmbQUdwWIaY3QU3N4UxgTNYXHu7pV3e8lrATkmdQAfDg/p8gjWmpzZlM1vPWR0yOa0JgNVJkPy3n1wntKJFldREb8l0JJV5iVDU28wL1KyRd0ls3mhS/jMDXVmxGC5GAfBB/sIuZ3poKOs3nWYGYxy3o3HQ8+exXGHBqpIdtlHOlIu2JOTTQydRkCFaQOpSnOJC/wsCK6jktLWbB7VIaEH5vXaEwpQbDy63ZjwXXEK+za5XOucFi+YvUk7YNpT7BlghqPPe/h2OJ1sS5RF0vqSGsecH+NlbonjC041ij3LyqJPCEdjEgsWvCqY3RsU73lc0cs/ObuWw5PB46VVT2l97PkAwEngvJGcl5A1U9ygIMqBGhY4
 ElI8xLg4
 VohGTedLugoUuvuhY+jaJkzPmlC5lrGhjv7eZGqKxXWfom5vTQGuK8O8kw9xmveWyoKDTU1E/GukN/KDJcINYvuwIAocbJgB/MA4Gby1hRqNOJBrYbY5IoX05rzCmH31KCYgX45LDbQ9cnhNI97L3zB5V9qwxhHTXImLxv7+5+Y6JvbyclMphefL9gvGdnYomh7E8//1YvWRoqEaN3AIIlkyGDzP2FqflFsjSD8GnhsB9VZIPUI6uoSsrMYqbpsnK0nvludC+sB64L04077PkHgwh+i1BsaKs0zuX3CKHpULwOQdw9J28DVkONx+vuIcS32x/6yB/TgzRqQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 09:36, Miaohe Lin wrote:
> On 2026/6/11 13:43, Michael S. Tsirkin wrote:
>> On Thu, Jun 11, 2026 at 11:35:36AM +0800, Miaohe Lin wrote:
>>>
>>> Do you mean repeating SetPageHWPoison on every branch?
>>
>> Right.
>>
>>> Is it possible
>>> to make __free_pages_prepare changes page->flags atomically or this race
>>> is specified to memory_failure?
>>>
>>> Thanks.
>>> .
>>
>>
>> Adding an atomic op on every fast path page allocation is, I am
>> guessing, going to slow down Linux measureably.
>>
>> Doing it for the benefit of memory_failure, which is the slowest of
>> slow paths, seems unpalatable, to me.
> 
> Agree, it's not worth to do so.
> 
>>
>> Neither am I sure it's the only racy place -
>> grep for __SetPage and __ClearPage - all these have the same issue, I
>> suspect.
>>
>> At the same time, I'm not an mm maintainer. If you disagree, try to
>> upstream a change converting all non atomics in mm to atomics, and see
>> what others say.
> 
> Since memory_failure might be the only place, this change would be unacceptable.
> We should come up with a better solution. Maybe we can try repeating SetPageHWPoison
> and ClearPageHWPoison at a first attempt though it looks somewhat weird to me and makes
> code more complicated.

And I am fairly sure we could still have some remaining races ... it's shaky.

Hm ...

-- 
Cheers,

David

